/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 5/11/2012
Author  :
Company :
Comments:


Chip type               : ATtiny2313
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>

#define DATA_OUT PORTD.1

bit b1 = 0;
bit b2 = 0;

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
	// Reinitialize Timer1 value
	TCNT1H=0xF6;
	TCNT1L=0x3C;
	// Place your code here

        DATA_OUT=(b2^ACO);
        b2=b1;
        b1=ACO;
}

// Declare your global variables here

void main(void)
{
	// Declare your local variables here

	// Crystal Oscillator division factor: 1
#pragma optsize-
	CLKPR=0x80;
	CLKPR=0x00;
	#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
	#endif

	// Input/Output Ports initialization
	// Port A initialization
	// Func2=In Func1=In Func0=In
	// State2=T State1=T State0=T
	PORTA=0x00;
	DDRA=0x00;

	// Port B initialization
	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
	// State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
	PORTB=0x00;
	DDRB=0xF0;

	// Port D initialization
	// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
	// State6=T State5=T State4=T State3=T State2=T State1=1 State0=P
	PORTD=0x03;
	DDRD=0x02;

	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: Timer 0 Stopped
	// Mode: Normal top=0xFF
	// OC0A output: Disconnected
	// OC0B output: Disconnected
	TCCR0A=0x00;
	TCCR0B=0x00;
	TCNT0=0x00;

	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: 12000.000 kHz
	// Mode: Normal top=0xFFFF
	// OC1A output: Discon.
	// OC1B output: Discon.
	// Noise Canceler: Off
	// Input Capture on Falling Edge
	// Timer1 Overflow Interrupt: On
	// Input Capture Interrupt: Off
	// Compare A Match Interrupt: Off
	// Compare B Match Interrupt: Off
	TCCR1A=0x00;
	TCCR1B=0x01;
	TCNT1H=0xF6;
	TCNT1L=0x3C;

	// External Interrupt(s) initialization
	// INT0: Off
	// INT1: Off
	// Interrupt on any change on pins PCINT0-7: Off
	GIMSK=0x00;
	MCUCR=0x00;

	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=0x80;

	// USART initialization
	// USART disabled
	UCSRB=0x00;

	// Analog Comparator initialization
	// Analog Comparator: On
	// Analog Comparator Input Capture by Timer/Counter 1: Off
	ACSR=0x00;
	// Digital input buffer on AIN0: On
	// Digital input buffer on AIN1: On
	//DIDR=0x03;
        DIDR=0x00;

	// Global enable interrupts
	#asm("sei")

	while (1)
      	{
      		// Place your code here

      	}
}
