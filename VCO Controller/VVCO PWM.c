/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 8/23/2012
Author  :
Company :
Comments:


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>

#include <stdio.h>

#include <delay.h>

#include <stdlib.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

#define MAXPWM	15000
#define LOCK	100
#define out_1 	PORTD.5
#define out_2 	PORTD.6

#define f_presc	16
#define f_sample 100
#define PORT_F	PIND.7

#define SLOW_UP	PINB.0
#define FAST_UP	PINB.1
#define SLOW_DOWN	PINB.2
#define FAST_DOWN	PINB.3

int t_count;
int PWM, PWM_1,PWM_2;
long int f_count, act_f, delta;
eeprom long int f_set, step;
char buff[32];

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
	// Place your code here
        // f = 1MHz

        t_count++;

        if(t_count > (MAXPWM-1))t_count = 0;
        if(t_count < PWM_1)	out_1 = 1;
        else	out_1 = 0;
        if(t_count < PWM_2)	out_2 = 1;
        else 	out_2 = 0;

        TCNT0 = 0xF0;
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
	// Place your code here
        // f = 100Hz

        act_f = ( f_count * f_sample * f_presc );
        f_count = 0;
        delta = labs(f_set - act_f);

        PWM = ((2*f_set) - act_f) / 2;

        if(PWM > 7500)
        {
        	PWM_1 = 7500;
                PWM_2 = PWM - 7500;
        }
        else
        {
        	PWM_1 = PWM;
                PWM_2 = 0;
        }

        lcd_clear();
        lcd_gotoxy(0,0);
        sprintf(buff,"F : %i Hz",act_f);
        lcd_puts(buff);
        if(delta < LOCK)
        {
        	lcd_gotoxy(0,1);
                lcd_putsf("LOCKED");
        }

        if(f_set > 15000000)		PORTD = 1;
        else if(f_set >  7500000)	PORTD = 2;
        else if(f_set >  3750000)	PORTD = 4;
        else if(f_set >  1875000)	PORTD = 8;
        else if(f_set >   937500)	PORTD = 16;
        else if(f_set >	  468750)	PORTD = 32;
        else if(f_set >   234375)	PORTD = 64;
        else PORTD = 128;

        if(!PIND.0)	step = 1000000;
        if(!PIND.1)	step =  100000;
        if(!PIND.2)	step =   10000;
        if(!PIND.3)	step = 	  1000;

        if(!SLOW_UP)	{f_set += step;		delay_ms(125);}
        if(!FAST_UP)	{f_set += (2*step);	delay_ms(125);}
        if(!SLOW_DOWN)	{f_set -= step;		delay_ms(125);}
        if(!SLOW_DOWN)	{f_set -= (2*step);	delay_ms(125);}

        if(f_set < 100000) 	f_set = 100000;
        if(f_set > 29000000) 	f_set = 29000000;

        TCNT1H = 0xB1;
        TCNT1L = 0xE0;
}

// Declare your global variables here

void main(void)
{
	// Declare your local variables here

	// Input/Output Ports initialization
	// Port A initialization
	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
	PORTA=0x00;
	DDRA=0xFF;

	// Port B initialization
	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
	// State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
	PORTB=0xFF;
	DDRB=0x00;

	// Port C initialization
	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
	PORTC=0x00;
	DDRC=0xFF;

	// Port D initialization
	// Func7=In Func6=Out Func5=Out Func4=In Func3=In Func2=In Func1=In Func0=In
	// State7=P State6=0 State5=0 State4=P State3=P State2=P State1=P State0=P
	PORTD=0x9F;
	DDRD=0x60;

	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: 16000.000 kHz
	// Mode: Normal top=0xFF
	// OC0 output: Disconnected
	TCCR0=0x01;
	TCNT0=0xF0;

	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: 2000.000 kHz
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
	TCCR1B=0x02;
	TCNT1H=0xB1;
	TCNT1L=0xE0;

	// Analog Comparator initialization
	// Analog Comparator: Off
	// Analog Comparator Input Capture by Timer/Counter 1: Off
	ACSR=0x80;
	SFIOR=0x00;

	// Alphanumeric LCD initialization
	// Connections specified in the
	// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
	// RS - PORTA Bit 0
	// RD - PORTA Bit 1
	// EN - PORTA Bit 2
	// D4 - PORTA Bit 4
	// D5 - PORTA Bit 5
	// D6 - PORTA Bit 6
	// D7 - PORTA Bit 7
	// Characters/line: 16
	lcd_init(16);

	t_count = 0;
	f_count = 0;
	f_set = 14070000;
	step = 100000;
	PORTD = 2;

	// Global enable interrupts
	#asm("sei")

	while (1)
      	{
      		// Place your code here
      		if(!PORT_F) f_count++;
                while(!PORT_F);
      	}
}
