/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.3 Standard
Automatic Program Generator
� Copyright 1998-2011 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/11/2018
Author  : Handiko Gesang
Company : SDL Labs
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>

// Alphanumeric LCD functions
#include <alcd.h>

#include <delay.h>
#include <stdint.h>

#define DAT_2   PORTD.0
#define CLK     PORTD.1         
#define FUD     PORTD.2         
#define DAT     PORTD.3         
#define RST     PORTD.4

#define LOW     0
#define HIGH    1

eeprom unsigned long freq = 12345678;
//eeprom uint32_t d_freq;
//eeprom uint32_t step = 1000000;
//eeprom uint32_t d_step;

void dds_reset(void)
{
        CLK = LOW;
        FUD = LOW;
        DAT = LOW;
        
        RST = LOW;      delay_us(5);
        RST = HIGH;     delay_us(5);
        RST = LOW;
        
        CLK = LOW;      delay_us(5);
        CLK = HIGH;     delay_us(5);
        CLK = LOW;
        
        FUD = LOW;      delay_us(5);
        FUD = HIGH;     delay_us(5);
        FUD = LOW; 
}

void send_data(void)
{
        unsigned long data_word = (freq * 4294967296) / 100000000; 
        char i;
        char bits=0; 
        
        FUD = HIGH;     delay_us(5); 
        FUD = LOW;
        
        for(i=0; i<40; i++)
        {
                bits = ((data_word >> i) & 0x01);   
                DAT=bits;
                if(bits)    lcd_putchar('1');
                else        lcd_putchar('0');
                delay_us(10);
                   
                CLK = HIGH;     
                delay_us(5);
                CLK = LOW;
        }      
            
        delay_us(10);
        
        FUD = HIGH;     
        delay_us(5); 
        FUD = LOW;
}

void main(void)
{
    PORTB=0x00;
    DDRB=0xFF;
    PORTD=0x00;
    DDRD=0xFF;

    ACSR=0x80;
    SFIOR=0x00;
    lcd_init(16);                
    
    dds_reset();
    send_data();
                           
    lcd_clear();
    lcd_putsf("Hello");
    while (1)
    {
        dds_reset();
        delay_ms(100);
        lcd_clear();
        send_data();
        delay_ms(100);
        lcd_clear();
    }
}
