/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 2/17/2012
Author  : F4CG
Company : F4CG
Comments:


Chip type           : ATtiny2313
Clock frequency     : 16.000000 MHz
Memory model        : Tiny
External SRAM size  : 0
Data Stack size     : 32
*****************************************************/

#include <tiny2313.h>
#include <lcd.h>

#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm

#define	INPUT	PINA.0

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{    	TCNT1H=0x00;
	TCNT1L=0x00;
}

void init_ports(void)
{  	PORTA=0x01;
	DDRA=0x00;

	PORTB=0x00;
	DDRB=0xFF;
}

void init_timer(void)
{      	// Timer/Counter 1 initialization
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
	TCNT1H=0x00;
	TCNT1L=0x00;
	ICR1H=0x00;
	ICR1L=0x00;
	OCR1AH=0x00;
	OCR1AL=0x00;
	OCR1BH=0x00;
	OCR1BL=0x00;
	TIMSK=0x80;
}

void init_clock(void)
{
#pragma optsize-
	CLKPR=0x80;
	CLKPR=0x00;
	#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
	#endif
}

void main(void)
{	init_clock();
	init_ports();
	init_timer();
	lcd_init(16);

	ACSR=0x80;

	#asm("sei")

while (1)
      	{ 	while(!INPUT);
      	};
}
