/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 8/20/2012
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

#include <delay.h>

#include <stdlib.h>

#include <stdio.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

long int count;
unsigned char adc;
long int count_freq;
long int delta, last_delta;
eeprom long int set_freq = 14070000;
eeprom long int step;
unsigned char lcd_buff[32];
char a,b,c,d,e,f,g,h;
eeprom char action;

#define MUX_1_A		PORTA.2
#define MUX_1_B        	PORTA.3
#define MUX_1_C         PORTA.4

#define MUX_2_A       	PORTA.5
#define MUX_2_B       	PORTA.6
#define MUX_2_C       	PORTA.7

#define STEP_1		PINB.0
#define STEP_2		PINB.1
#define STEP_3		PINB.2
#define STEP_4		PINB.3
#define STEP_5		PINB.4
#define STEP_6		PINB.5

#define IN_COUNTER	PINB.7

unsigned char read_adc(unsigned char adc_input);

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)	// T = 10ms
{
// Place your code here

	adc = read_adc(0);

        if(!STEP_1)	step = 10;
        if(!STEP_2)   	step = 100;
        if(!STEP_3)  	step = 1000;
        if(!STEP_4) 	step = 10000;
        if(!STEP_5) 	step = 100000;
        if(!STEP_6) 	step = 1000000;

	if(adc>150)
        {
        	if(adc>200)
                {
                	set_freq = set_freq + (2*step);
                }
                else
                {
                	set_freq = set_freq + step;
                }
        }
        else
        {
        	if(adc<50)
                {
                	set_freq = set_freq - (2*step);
                }
                else
                {
                	set_freq = set_freq - step;
                }
        }

        count_freq = count * 16 * 100;
        count = 0;
        last_delta = delta;
        delta = labs(count_freq - set_freq);

        if(delta > last_delta)
        {
        	if(action) action = 0;
                else	action = 1;
        }
        else;

        if(delta > 1000000)
        {
        	if(action)
                {
                	PORTD.0 = 1;
                        PORTD.1 = 0;

                        PORTD.2 = 0;
                        PORTD.3 = 0;

                        PORTD.4 = 0;
                        PORTD.5 = 0;

                        PORTD.6 = 0;
                        PORTD.7 = 0;
                }
                else
                {
                	PORTD.0 = 0;
                        PORTD.1 = 1;

                        PORTD.2 = 0;
                        PORTD.3 = 0;

                        PORTD.4 = 0;
                        PORTD.5 = 0;

                        PORTD.6 = 0;
                        PORTD.7 = 0;
                }
        }
        else if(delta > 100000)
        {
        	if(action)
                {
                	PORTD.0 = 0;
                        PORTD.1 = 0;

                        PORTD.2 = 1;
                        PORTD.3 = 0;

                        PORTD.4 = 0;
                        PORTD.5 = 0;

                        PORTD.6 = 0;
                        PORTD.7 = 0;
                }
                else
                {
                	PORTD.0 = 0;
                        PORTD.1 = 0;

                        PORTD.2 = 0;
                        PORTD.3 = 1;

                        PORTD.4 = 0;
                        PORTD.5 = 0;

                        PORTD.6 = 0;
                        PORTD.7 = 0;
                }
        }
        else if(delta > 10000)
        {
        	if(action)
                {
                	PORTD.0 = 0;
                        PORTD.1 = 0;

                        PORTD.2 = 0;
                        PORTD.3 = 0;

                        PORTD.4 = 1;
                        PORTD.5 = 0;

                        PORTD.6 = 0;
                        PORTD.7 = 0;
                }
                else
                {
                	PORTD.0 = 0;
                        PORTD.1 = 0;

                        PORTD.2 = 0;
                        PORTD.3 = 0;

                        PORTD.4 = 0;
                        PORTD.5 = 1;

                        PORTD.6 = 0;
                        PORTD.7 = 0;
                }
        }
        else
        {
        	if(action)
                {
                	PORTD.0 = 0;
                        PORTD.1 = 0;

                        PORTD.2 = 0;
                        PORTD.3 = 0;

                        PORTD.4 = 0;
                        PORTD.5 = 0;

                        PORTD.6 = 1;
                        PORTD.7 = 0;
                }
                else
                {
                	PORTD.0 = 0;
                        PORTD.1 = 0;

                        PORTD.2 = 0;
                        PORTD.3 = 0;

                        PORTD.4 = 0;
                        PORTD.5 = 0;

                        PORTD.6 = 0;
                        PORTD.7 = 1;
                }
        }


        a = count_freq % 10;
        count_freq = count_freq / 10;
        b = count_freq % 10;
        count_freq = count_freq / 10;
        c = count_freq % 10;
        count_freq = count_freq / 10;
        d = count_freq % 10;
        count_freq = count_freq / 10;
        e = count_freq % 10;
        count_freq = count_freq / 10;
        f = count_freq % 10;
        count_freq = count_freq / 10;
        g = count_freq % 10;
        count_freq = count_freq / 10;
        h = count_freq % 10;

        lcd_clear();
        lcd_gotoxy(0,0);
        sprintf(lcd_buff,"F : %i%i.%i%i%i.%i%i%i Hz",h,g,f,e,d,c,b,a);
        lcd_puts(lcd_buff);

        lcd_gotoxy(0,1);
        sprintf(lcd_buff,"Step : %i Hz",step);
        lcd_puts(lcd_buff);

	TCNT1H=0xB1;
	TCNT1L=0xE0;
}

#define ADC_VREF_TYPE 0x20

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T
PORTA=0x00;
DDRA=0xFC;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=P State4=P State3=P State2=P State1=P State0=P
PORTB=0xFF;
DDRB=0x00;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=0
PORTD=0x00;
DDRD=0xFF;

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

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x04;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);

step = 10000;
delta = 0;
action = 0;
count = 0;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here
      	if(!IN_COUNTER) count++;
        while(!IN_COUNTER);

      }
}
