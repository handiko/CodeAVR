/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/21/2012
Author  : 
Company : 
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 4.000000 MHz
VCC                     : 3 Volt
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>

#define TIME_CONST 50

flash unsigned char max_OCR = 80;
flash char min_OCR = 12;
char comp_a_counter;

// Timer 0 output compare A interrupt service routine
interrupt [TIM0_COMPA] void timer0_compa_isr(void)
{
        // Place your code here
        comp_a_counter++;
        if(comp_a_counter==TIME_CONST)
        {
                comp_a_counter=0;
                OCR0A--;
                if(OCR0A < min_OCR) OCR0A = max_OCR;
        }     
         
        #asm
                sleep
        #endasm
}

// Declare your global variables here

void main(void)
{

#pragma optsize-
        CLKPR=0x80;
        CLKPR=0x00;
        #ifdef _OPTIMIZE_SIZE_
#pragma optsize+
        #endif

        PORTB=0x00;
        DDRB=0x04;
        
        comp_a_counter = 0;

        TCCR0A=0x42;
        TCCR0B=0x03;
        TCNT0=0x00;
        OCR0A=max_OCR;
        OCR0B=0x00;

        TIMSK=0x01;
        
        ACSR=0x80;
        DIDR=0x00; 
        
        MCUCR |= (1 << SE);

        // Global enable interrupts
        #asm 
                sleep
                sei
        #endasm 

        while (1)
        {
              // Place your code here

        }
}
