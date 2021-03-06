/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/5/2012
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>
#include <stdio.h>
#include <delay.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

#define BL PORTB.3

#define sw_up           PIND.4
#define sw_down         PIND.6
#define sw_enter        PIND.5
#define sw_cancel       PIND.3

// Declare your global variables here
char lcd_buff[33];
eeprom int c = 0;

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
// Reinitialize Timer 0 value
TCNT0=0xFF;
// Place your code here

}

// Timer2 overflow interrupt service routine
interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
// Reinitialize Timer2 value
TCNT2=0x7E;
// Place your code here

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
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTB=0x00;
DDRB=0xFF;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=In Func0=In 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=P State0=P 
PORTC=0x03;
DDRC=0xFC;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=P State5=P State4=P State3=P State2=T State1=T State0=T 
PORTD=0x78;
DDRD=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x41;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 750.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

BL = 1;
delay_ms(1000);
BL = 0;
delay_ms(1000);
BL = 1;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 11.719 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x05;
TCNT0=0xFF;
OCR0=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: 11.719 kHz
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x07;
TCNT2=0x7E;
OCR2=0x00;

// Global enable interrupts
#asm("sei")

 while (1)
        {
                // Place your code here
                if(!sw_up)
                { 
                        delay_ms(250); 
                        lcd_clear();
                        lcd_gotoxy(0,0); 
                        sprintf(lcd_buff,"sw up  %d",c++);
                        lcd_puts(lcd_buff);
                }
                
                if(!sw_down)
                { 
                        delay_ms(250); 
                        lcd_clear();
                        lcd_gotoxy(0,0);
                        sprintf(lcd_buff,"sw dowm  %d",c++);
                        lcd_puts(lcd_buff);
                }  
                
                if(!sw_enter)
                { 
                        delay_ms(250); 
                        lcd_clear();
                        lcd_gotoxy(0,0);
                        sprintf(lcd_buff,"sw enter  %d",c++);
                        lcd_puts(lcd_buff);
                }
                
                if(!sw_cancel)
                { 
                        delay_ms(250); 
                        lcd_clear();
                        lcd_gotoxy(0,0);
                        sprintf(lcd_buff,"sw cancel  %d",c++);
                        lcd_puts(lcd_buff);
                } 
        }
}
