/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 2/17/2012
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 16.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>
#include <lcd.h>
#include <stdio.h>

#define	INPUT	PIND.0
#define CONST	1

#asm
   .equ __lcd_port=0x12 ;PORTD
#endasm

//void tampil_nilai(char x, char y);
void tampil_nilai_digit(char x, char y);

long hitung = 0;
long frek = 0;
char lcd_buff[33];

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{	TCNT1H=0xC2;
	TCNT1L=0xF7;
        
        frek = hitung * CONST;
        hitung = 0;
        
        lcd_putsf_pos("Frekuensi :",1,0); 
        tampil_nilai_digit(1,1);
        //tampil_nilai(frek,1,1);
}

/*void tampil_nilai(char x, char y)
{	sprintf(lcd_buff, "%d Hz", frek);
        lcd_puts_pos(lcd_buff,x,y);
}*/

void tampil_nilai_digit(char x, char y)
{	int mega, kilo, hertz;

	mega = (frek / 1000000);
        kilo = (frek / 1000);
 	hertz = (frek % 1000);  
        
        sprintf(lcd_buff, "%03d", mega);
        lcd_puts_pos(lcd_buff,x,y);
        
        lcd_putsf_pos(".",x+4,y);
        
        sprintf(lcd_buff, "%03d", kilo);
        lcd_puts_pos(lcd_buff,x+5,y); 
        
        lcd_putsf_pos(".",x+8,y); 
        
        sprintf(lcd_buff, "%03d", hertz);
        lcd_puts_pos(lcd_buff,x+9,y);    
}

void init_ports(void)
{	PORTC=0x7F;
	DDRC=0x00;
	PORTD=0x00;
	DDRD=0xFF;
}

void init_timer(void)
{ 	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: 15.625 kHz
	// Mode: Normal top=FFFFh
	// OC1A output: Discon.
	// OC1B output: Discon.
	// Noise Canceler: Off
	// Input Capture on Falling Edge
	// Timer 1 Overflow Interrupt: On
	// Input Capture Interrupt: Off
	// Compare A Match Interrupt: Off
	// Compare B Match Interrupt: Off
	TCCR1A=0x00;
	TCCR1B=0x05;
	TCNT1H=0xC2;
	TCNT1L=0xF7;
	ICR1H=0x00;
	ICR1L=0x00;
	OCR1AH=0x00;
	OCR1AL=0x00;
	OCR1BH=0x00;
	OCR1BL=0x00;
	TIMSK=0x04;
}

void main(void)
{       init_ports();
	init_timer();
        lcd_init(16);
        
	ACSR=0x80;
	SFIOR=0x00;

	#asm("sei")

	while (1)
      	{   	if(!INPUT)	hitung++;
        	while(!INPUT);
      	};
}
