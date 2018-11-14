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

#define DAC_1	PORTB.7
#define DAC_2	PORTB.6
#define DAC_3	PORTB.5
#define DAC_4	PORTB.4

#define LED_2200	PORTD.2
#define LED_STBY	PORTD.4
#define LED_1200	PORTD.5

unsigned int waktu_timer = 0;
char toggle = 0;

void set_timer_0(char mikro_s)
{
 	TCNT0 = (1 + 0xFF) - (mikro_s * 11059200);
}

/***************************************************************************************/
	void 			timer_detik(char detik)
/***************************************************************************************
*	ABSTRAKSI  	: 	Menghitung nilai register TCNT1H dan TCNT1L dari input nilai
*				konstanta timer dalam satuan detik. Formula untuk menghitung 
*				nilai register :
*				_TCNT1 = (TCNT1H << 8) + TCNT1L
*				_TCNT1 = (1 + 0xFFFF) - (konstanta_timer_detik * (sys_clock / prescaler))
*
*      	INPUT		:	konstanta timer dalam satuan detik
*	OUTPUT		:       tak ada
*	RETURN		:       tak ada
*/
{	
	unsigned short _TCNT1;
        
        // hitung nilai vaiabel _TCNT1 dari nilai input berdasarkan formula :
         	// _TCNT1 = (1 + 0xFFFF) - (konstanta_timer_detik * (sys_clock / prescaler))
                // menjadi bilangan 16 bit 
	_TCNT1 = (1 + 0xFFFF) - (detik * 10800); 
                                        
        // ambil 8 bit paling kanan dan jadikan nilai register TCNT1L
        TCNT1L = _TCNT1 & 0xFF;
        
        // ambil 8 bit paling kiri dan jadikan nilai register TCNT1H
        TCNT1H = _TCNT1 >> 8;
        
}       // EndOf void timer_detik(char detik)

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
	// Place your code here  
        set_timer_0(10);
        waktu_timer++; 
        if(toggle != 0)
        {
        	if((waktu_timer > 30) && (waktu_timer < 50))
                { 
                	waktu_timer = 0;
                        toggle = 0;
                        LED_2200 = 1;
                	LED_1200 = 0;
                	LED_STBY = 0;
                } 
                
                if((waktu_timer > 60) && (waktu_timer < 100))
                { 
                	waktu_timer = 0;
                        toggle = 0;
                        LED_2200 = 0;
                	LED_1200 = 1;
                	LED_STBY = 0;
                } 
        }
}

/*
// Analog Comparator interrupt service routine
interrupt [ANA_COMP] void ana_comp_isr(void)
{
	// Place your code here
        unsigned int waktu_mikro;
        
        waktu_mikro = waktu_timer;
        waktu_timer = 0;
        
        if((waktu_mikro > 600) && (waktu_mikro < 1000))
        {   
        	LED_2200 = 1;
                LED_1200 = 0;
                LED_STBY = 0;
        }
        if((waktu_mikro > 1400) && (waktu_mikro < 1800))
        {       
        	LED_1200 = 1;
                LED_2200 = 0; 
                LED_STBY = 0;
        }
}
*/

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
// State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=P State0=T 
PORTB=0x02;
DDRB=0xF0;

// Port D initialization
// Func6=In Func5=Out Func4=Out Func3=In Func2=Out Func1=In Func0=In 
// State6=T State5=0 State4=0 State3=T State2=0 State1=T State0=T 
PORTD=0x00;
DDRD=0x34;

// set register Analog Comparator
ACSR=0x80;

// set register Timer 1, System clock 10.8kHz, Timer 1 overflow
TCCR1B=0x05; 
        
// set konstanta waktu 5 detik sebagai awalan
timer_detik(1);  
        
// set interupsi timer untuk Timer 1
TIMSK=0x80;

/*
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 11059.200 kHz
// Mode: Normal top=0xFF
// OC0A output: Disconnected
// OC0B output: Disconnected
set_timer_0(10);
TCCR0A=0x00;
TCCR0B=0x01;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x02;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// USART initialization
// USART disabled
UCSRB=0x00;


// Analog Comparator initialization
// Analog Comparator: On
// The Analog Comparator's positive input is
// connected to the Bandgap Voltage Reference
// Interrupt on Output Toggle
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x48;

// Digital input buffer on AIN0: Off
// Digital input buffer on AIN1: Off
DIDR=0x00;

*/

// Global enable interrupts

LED_2200 = 1;
delay_ms(125);
LED_1200 = 1;
LED_2200 = 0;
delay_ms(125);
LED_1200 = 0;

#asm("sei")

while (1)
      	{
      		// Place your code here 
                LED_1200 = 0;
                LED_2200 = 0;
                LED_STBY = 1;  
                if(PINB.1) toggle++;
                while(PINB.1);
      	}
}
