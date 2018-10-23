/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 5/3/2012
Author  :
Company :
Comments:


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <delay.h>
#include <stdio.h>
#define INDIKATOR_1 PORTC.2
#define INDIKATOR_2 PORTC.3

#define SEL_A	PORTC.1
#define SEL_B	PORTC.0

#define TOM_ENTER	PIND.4
#define TOM_UP		PIND.5
#define TOM_DOWN  	PIND.6
#define TOM_CANCEL	PIND.7

#define SENSE_1	1
#define SENSE_2	2
#define SENSE_3 3
#define SENSE_4	4
#define SENSE_5	5
#define SENSE_6 6

#define PTT		PORTA.0
#define CARIER_DET	PIND.0

void usart_init(void)
{
	UCSRA = 0x00;
	UCSRB = 0xD8;
	UCSRC = 0x86;
	UBRRH = 0x02;
	UBRRL = 0x3F;
}

void switch_to_maxim(void)
{
	SEL_B = 0; SEL_A = 1;
}

// Declare your global variables here
char i=0;

void main(void)
{
	PORTA=0x00;
	DDRA=0x81;
        PORTB=0x00;
	DDRB=0x00;
        PORTC=0x00;
        DDRC=0x00;
	PORTD=0x01;
	DDRD=0x00;

	usart_init();
	switch_to_maxim();

	while (1)
      	{
      		if(getchar()=='$')
        	{
        		PORTA.0 = 1;
        	}

        	else if(getchar()=='~')
        	{
        		if(i==3)
                        {
                        	PORTA.0 = 0;
                		delay_ms(250);
                                i=0;
                        }
                        i++;
        	}
      	}
}
