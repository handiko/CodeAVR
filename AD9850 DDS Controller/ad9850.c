/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 8/14/2013
Author  : 
Company : 
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

// Declare your global variables here
#include <math.h>
#include <stdio.h>
#include <delay.h>

#define DAT     PORTD.0
#define CLK     PORTD.1
#define FUD     PORTD.2
#define RST     PORTD.3

#define IN_MHZ  PIND.4
#define IN_10K  PIND.5
#define IN_100  PIND.6

#define LOW     0
#define HIGH    1

eeprom unsigned long in_freq = 10000000;
unsigned long clk_freq = 125000000;

void dds_reset(void)
{
        CLK = LOW;
        FUD = LOW;
        
        RST = LOW;      delay_us(5);
        RST = HIGH;     delay_us(5);
        RST = LOW;
        
        CLK = LOW;      delay_us(5);
        CLK = HIGH;     delay_us(5);
        CLK = LOW;
        
        DAT = LOW;
        
        FUD = LOW;      delay_us(5);
        FUD = HIGH;     delay_us(5);
        FUD = LOW;
}

void send_data(void)
{
        unsigned long data_word = (in_freq * pow(2,32)) / clk_freq; 
        int i; 
        
        FUD = HIGH;     delay_us(5); 
        FUD = LOW;
        
        for(i=0; i<40; i++)
        {
                DAT = (data_word & 0x01);       delay_us(5); 
                
                if(i == 39) goto finish;
                data_word = data_word >> 1;
                
                finish:        
                CLK = HIGH;     delay_us(5);
                CLK = LOW;
        }      
        
        FUD = HIGH;     delay_us(5); 
        FUD = LOW;
}

void io_init(void)
{
        // Port A initialization
        // Func2=In Func1=In Func0=In 
        // State2=P State1=P State0=P 
        PORTA=0x07;
        DDRA=0x00;

        // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
        // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
        PORTB=0x00;
        DDRB=0xFF;

        // Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out 
        // State6=P State5=P State4=P State3=0 State2=0 State1=0 State0=0 
        PORTD=0x70;
        DDRD=0x0F;       
}

void main(void)
{
#pragma optsize-
        CLKPR=0x80;
        CLKPR=0x00;
        #ifdef _OPTIMIZE_SIZE_
#pragma optsize+
        #endif

        ACSR=0x80;
        DIDR=0x00;

        // Alphanumeric LCD initialization
        // Connections specified in the
        // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
        // RS - PORTB Bit 0
        // RD - PORTB Bit 1
        // EN - PORTB Bit 2
        // D4 - PORTB Bit 4
        // D5 - PORTB Bit 5
        // D6 - PORTB Bit 6
        // D7 - PORTB Bit 7
        // Characters/line: 16
        lcd_init(16);
                    
        dds_reset(); 
        send_data();
        
        while (1)
        {

        }
}
