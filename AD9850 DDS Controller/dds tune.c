/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 9/13/2013
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

// Declare your global variables here
#include <delay.h>
#include <stdlib.h>
#include <stdint.h>
#include <stdio.h>

#define DAT_2   PORTB.0
#define CLK     PORTB.1         
#define FUD     PORTB.2         
#define DAT     PORTB.3         
#define RST     PORTB.4

#define T_DOWN  PINA.0
#define T_UP    PINA.1
#define S_DOWN  PINA.2
#define S_UP    PINA.3

#define LOW     0
#define HIGH    1

eeprom uint32_t freq = 1000000;
eeprom uint32_t d_freq;
eeprom uint32_t step = 1000000;
eeprom uint32_t d_step;
char lcd[32];

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

flash unsigned char phase = ((90 * 100 / 1125) + 0);

void send_data(void)
{
        uint32_t data_word = (freq * 4294967296) / 100000000; 
        unsigned long data_word_2 = data_word + (phase << 35);
        int i; 
        
        FUD = HIGH;     delay_us(5); 
        FUD = LOW;
        
        for(i=0; i<40; i++)
        {
                DAT = ((data_word >> i) & 0x01);  
                DAT_2 = ((data_word_2 >> i) & 0x01);
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

void display(void)
{
        char string[32];
        
        uint32_t temp_freq = freq;    
        int mega;
        int kilo;
        int hertz;  
        
        mega = (int)(temp_freq / 1000000);
        temp_freq = temp_freq % 1000000;
        kilo = temp_freq / 1000;
        hertz= temp_freq % 1000; 
        
        lcd_clear();
        lcd_gotoxy(0,0);
        sprintf(lcd,"F: %2i.%03i.%03i Hz",mega,kilo,hertz);
        lcd_puts(lcd); 
        
        ltoa(step,string);   
        
        lcd_gotoxy(0,1);    
        if(step == 1000000)
        {   
                    // 0123456789abcdef
            lcd_putsf("      s:    1MHz");
        }
        else if(step == 100000)
        {      
                    // 0123456789abcdef
            lcd_putsf("      s:  100kHz");
        }
        else if(step == 10000)
        {   
                    // 0123456789abcdef
            lcd_putsf("      s:   10kHz");
        }
        else if(step == 1000)
        {   
                    // 0123456789abcdef
            lcd_putsf("      s:    1kHz");
        }
        else if(step == 100)
        {  
                    // 0123456789abcdef
            lcd_putsf("      s:  100 Hz");
        }
        else if(step == 10)
        {  
                    // 0123456789abcdef
            lcd_putsf("      s:   10 Hz");
        }
        else if(step == 1)
        {  
                    // 0123456789abcdef
            lcd_putsf("      s:    1 Hz");
        }
        else
        {  
                    // 0123456789abcdef
            lcd_putsf("      s:    0 Hz");
        }
}

void tuning (void)
{
        if(!T_UP)
        {   
                delay_ms(125);
                              
                d_freq = freq;   
                freq += step;
                if(freq > 30000000) freq = 30000000;
        }
        
        if(!T_DOWN)
        {
                delay_ms(125);
                                
                d_freq = freq;  
                if((step == 1)&&(freq == 1));
                else
                {
                        if((freq / step) < 2)   step /= 10;
                        freq -= step;
                }   
                if(freq < 0)        freq = 0; 
        }  
        
        if(!S_UP)
        {   
                delay_ms(125); 
                
                d_step = step;
                              
                if(step == 0)
                {
                    step = 1;
                }    
                else if(step == 1)
                {
                    step = 10;  
                }             
                else if(step == 10)
                {
                    step = 100;  
                }
                else if(step == 100)
                {
                    step = 1000; 
                }
                else if(step == 1000)    
                {
                    step = 10000;  
                }
                else if(step == 10000)   
                {
                    step = 100000; 
                }
                else if(step == 100000)  
                {
                    step = 1000000;
                }
        }
        
        if(!S_DOWN)
        {
                delay_ms(125);
                
                d_step = step;
                                
                if(step == 1000000) 
                {
                    step = 100000;
                }
                else if(step == 100000)  
                {
                    step = 10000;    
                }
                else if(step == 10000)   
                {
                    step = 1000;      
                }
                else if(step == 1000)    
                {
                    step = 100;    
                }   
                else if(step == 100)
                {
                    step = 10;  
                }             
                else if(step == 10)
                {
                    step = 1;  
                }            
                else if(step == 1)
                {
                    step = 0;  
                }
        }                                           
        
        if(d_freq != freq)
        {
                dds_reset();
                send_data();
                display();
                d_freq = freq;
        }      
        
        if(d_step != step)
        {
                display();
                d_step = step;
        }
}

void main(void)
{
        PORTA=0xFF;
        DDRA=0x00;
        PORTB=0x00;
        DDRB=0xFF;
        PORTC=0xFF;
        DDRC=0x00;
        PORTD=0x00;
        DDRD=0xFF; 
        
        ACSR=0x80;
        SFIOR=0x00;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTD Bit 7
// RD - PORTD Bit 6
// EN - PORTD Bit 5
// D4 - PORTD Bit 4
// D5 - PORTD Bit 3
// D6 - PORTD Bit 2
// D7 - PORTD Bit 1
// Characters/line: 16
lcd_init(16);
dds_reset();
send_data();
display();

while (1)
      {
      // Place your code here 
      tuning();

      }
}
