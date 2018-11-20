/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 5/6/2012
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

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
// Place your code here

}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here

}

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// Get a character from the USART Receiver
#ifndef _DEBUG_TERMINAL_IO_
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
	char status,data;
	while (1)
      	{
      		while (((status=UCSRA) & RX_COMPLETE)==0);
      		data=UDR;
      		if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
         	return data;
      	}
}
#pragma used-
#endif

// Write a character to the USART Transmitter
#ifndef _DEBUG_TERMINAL_IO_
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
	while ((UCSRA & DATA_REGISTER_EMPTY)==0);
	UDR=c;
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

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

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T
PORTB=0x00;
DDRB=0xF8;

// Port D initialization
// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
// State6=T State5=T State4=T State3=T State2=T State1=1 State0=P
PORTD=0x03;
DDRD=0x02;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 10.800 kHz
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
TCCR1B=0x05;
TCNT1H=0x00;
TCNT1L=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: On
// INT1 Mode: Any change
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x80;
MCUCR=0x04;
EIFR=0x80;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x80;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, Even Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 1200
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x26;
UBRRH=0x02;
UBRRL=0x3F;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
DIDR=0x00;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here

      }
}
