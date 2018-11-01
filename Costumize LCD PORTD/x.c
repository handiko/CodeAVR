/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/12/2011
Author  : 
Company : 
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <alcd.h>
#include <delay.h>

void main(void)
{
        PORTA=0x00;
        DDRA=0x03; 
        PORTB=0x00;
        DDRB=0x00;
        PORTC=0x00;
        DDRC=0x00;
        PORTD=0x00;
        DDRD=0x1F;

        ACSR=0x80;
        SFIOR=0x00;

        // Alphanumeric LCD initialization
        // Connections specified in the
        // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
        // RS - PORTC Bit 0
        // RD - PORTC Bit 1
        // EN - PORTD Bit 0
        // D4 - PORTD Bit 1
        // D5 - PORTD Bit 2
        // D6 - PORTD Bit 3
        // D7 - PORTD Bit 4
        // Characters/line: 20
        lcd_init(20);

        while (1)
        {
                lcd_clear();
                delay_ms(125);
                
                lcd_gotoxy(0,0);
                lcd_putsf("hello world");
                
                lcd_gotoxy(0,1);
                lcd_putsf("Helo world");
                
                lcd_gotoxy(0,2);
                lcd_putsf("hello world"); 
                
                lcd_gotoxy(0,3);
                lcd_putsf("hello world");

                delay_ms(1000);
        }
}
