/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/8/2011
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 12.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega16.h>
#include <lcd.h> 
#include <delay.h>

#define         ADC_VREF_TYPE   0x00 

#define         tomb_1          PINC.0
#define         tomb_2          PINC.1
#define         tomb_3          PINC.2
#define         tomb_4          PINC.3

#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm     

unsigned int read_adc(unsigned char adc_input)
{
        ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
        ADCSRA|=0x40;
        while ((ADCSRA & 0x10)==0);
        ADCSRA|=0x10;
        return ADCW;
} 

void init_port()
{       
        PORTA=0x00;
        DDRA=0x00;
        
        PORTB=0x00;
        DDRB=0xFF; 
        
        PORTC=0xFF;
        DDRC=0x00;
        
        PORTD=0x00;
        DDRD=0x00; 
        
        ACSR=0x80;      
}   

void init_adc()
{       
        ADMUX=ADC_VREF_TYPE & 0xff;
        ADCSRA=0x84;
}

void init_lcd()
{       
        lcd_init(16);
}

void baca_tombol()
{       if(!tomb_1)
        {       delay_ms(125);
                lcd_gotoxy(0,0); 
                lcd_putsf("tombol 1 ditekan");
                delay_ms(2000);
                lcd_clear();
        }   
        if(!tomb_2)
        {       delay_ms(125);
                lcd_gotoxy(0,0); 
                lcd_putsf("tombol 2 ditekan");
                delay_ms(2000);
                lcd_clear();
        }
        if(!tomb_3)
        {       delay_ms(125);
                lcd_gotoxy(0,0); 
                lcd_putsf("tombol 3 ditekan");
                delay_ms(2000);
                lcd_clear();
        }
        if(!tomb_4)
        {       delay_ms(125);
                lcd_gotoxy(0,0); 
                lcd_putsf("tombol 4 ditekan");
                delay_ms(2000);
                lcd_clear();
        }
}

void main(void)
{
        init_port();
        init_adc();
        init_lcd();
        
        lcd_gotoxy(0,0);
        lcd_putsf("Kerja Coy..!!!");  
        lcd_gotoxy(0,1);
        lcd_putsf("H-2........!!!");
        delay_ms(2000); 
        lcd_clear(); 
        
        while (1)
        {       baca_tombol();    
        };
}
