/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 4/22/2012
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
#include <delay.h>

#define DAC_0   PORTB.7	//LSB
#define DAC_1   PORTB.6
#define DAC_2   PORTB.5
#define DAC_3   PORTB.4	//MSB

#define DATA_OUT	PORTD.5
#define CARIER_DET	PORTD.3
#define LED_1200	PORTD.4
#define LED_2200	PORTD.2

#define CONST_1200      46
#define CONST_2200      22

#define _1200	0
#define _2200	1

#define _TCNT0	((unsigned char)(1+0xFF)-(0.0001*1382400))

bit data = 0;
bit d_data = 0;
bit tone;
char t = 0;
char v_2200 = 0;
eeprom char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
char int_anacomp = 0;

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
	// Place your code here
        TCNT0 = _TCNT0;
        t++; 
        if(t > 8) 
        {
        	t = 0;   
                tone = 0;
                PORTD.2 = 0;
                PORTD.4 = 0;   
        } 
        if(LED_1200 ^ LED_2200)
        {
        	if((t < 3)||(t > 5))
                {
                	CARIER_DET = 1;
                }     
                else
                {
                	CARIER_DET = 0;
                }
        }  
}

// Analog Comparator interrupt service routine
interrupt [ANA_COMP] void ana_comp_isr(void)
{
	// Place your code here
	int_anacomp++;
        if(int_anacomp == 2)
        {
        	int_anacomp = 0;
                tone = 1;
                if((t>2)&&(t<6))
        	{
        		v_2200++;
                	if(v_2200 == 2)
                	{
                		v_2200 = 0;
                        	LED_2200 = 1;
                		LED_1200 = 0;  
                        	d_data = data;
                        	data = _2200;
                	}
        	} 
        	else if((t>6)&&(t<10))
        	{
        		v_2200 = 0;
                	LED_2200 = 0;
                	LED_1200 = 1; 
                	d_data = data;
                	data = _1200;
        	}
        	t = 0;
                DATA_OUT = !(data ^ d_data);
        } 
}

void set_dac(char value) 
{	
	DAC_0 = value & 0x01; 		//LSB
        DAC_1 =( value >> 1 ) & 0x01;
        DAC_2 =( value >> 2 ) & 0x01;
        DAC_3 =( value >> 3 ) & 0x01; 	//MSB
}

void set_nada(void) 
{	
	char i;  
        if(tone)
        {
        	if(DATA_OUT) 
    		{	
        		for(i=0; i<16; i++)
        		{	
                		set_dac(matrix[i]);
                        	delay_us(CONST_1200);
        		} 
    		}  
       		else
    		{	
        		for(i=0; i<16; i++)
        		{	
                		set_dac(matrix[i]);
                        	delay_us(CONST_2200);
                	}       
                	for(i=0; i<13; i++)
                	{	
                		set_dac(matrix[i]);
                        	delay_us(CONST_2200);
                	}
    		}   
        }
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

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T 
PORTB=0x00;
DDRB=0xFC;

// Port D initialization
// Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
// State6=0 State5=0 State4=0 State3=0 State2=0 State1=T State0=T 
PORTD=0x00;
DDRD=0x7C;

CARIER_DET = 1;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1382.400 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x02;
TCNT0 = _TCNT0;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x02;

// Analog Comparator initialization
// Analog Comparator: On
// Interrupt on Output Toggle
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x08;
// Digital input buffer on AIN0: On
// Digital input buffer on AIN1: On
DIDR=0x03;

PORTD.2 = 0;
PORTD.4 = 1;
PORTD.5 = 0;
delay_ms(200);
PORTD.2 = 0;
PORTD.4 = 0;
PORTD.5 = 1;
delay_ms(200);
PORTD.2 = 1;
PORTD.4 = 0;
PORTD.5 = 0;
delay_ms(200);
PORTD.2 = 0;
PORTD.4 = 1;
PORTD.5 = 0;
delay_ms(200);

// Global enable interrupts
#asm("sei")

while (1)
      	{
      		// Place your code here
                //set_nada();
      	}
}