/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 6/1/2012
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

bit baca_adc = 0;
unsigned char adc[25];
unsigned char adc_temp[25];

#define ADC_VREF_TYPE 0x20

#define SEL1	PINB.0
#define SEL2	PINB.1
#define SEL3	PINB.2

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

void scan_adc(void)
{
 	char i;

        if((!SEL1)&&(!SEL2)&&(!SEL3))
        {
        	for(i=0;i<3;i++)
                {
                	adc[i] = read_adc(i);
                        if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
                }
        }
        else if((!SEL1)&&(!SEL2)&&(SEL3))
        {
        	for(i=3;i<6;i++)
                {
                	adc[i] = read_adc(i-3);
                        if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
                }
        }
        else if((!SEL1)&&(SEL2)&&(!SEL3))
        {
        	for(i=6;i<9;i++)
                {
                	adc[i] = read_adc(i-6);
                        if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
                }
        }
        else if((!SEL1)&&(SEL2)&&(!SEL3))
        {
        	for(i=9;i<12;i++)
                {
                	adc[i] = read_adc(i-9);
                        if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
                }
        }

        else if((!SEL1)&&(SEL2)&&(!SEL3))
        {
        	for(i=12;i<15;i++)
                {
                	adc[i] = read_adc(i-12);
                        if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
                }
        }
        else if((!SEL1)&&(SEL2)&&(!SEL3))
        {
        	for(i=15;i<18;i++)
                {
                	adc[i] = read_adc(i-15);
                        if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
                }
        }
        else if((!SEL1)&&(SEL2)&&(!SEL3))
        {
        	for(i=18;i<21;i++)
                {
                	adc[i] = read_adc(i-18);
                        if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
                }
        }
        else if((!SEL1)&&(SEL2)&&(!SEL3))
        {
        	for(i=21;i<24;i++)
                {
                	adc[i] = read_adc(i-21);
                        if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
                }
        }

        adc[24]=read_adc(3);
        if(adc[24]>adc_temp[24])
        	adc_temp[24]=adc[24];
}

void string_putchar(unsigned char nilai)
{
	char ratusan;
        char puluhan;
        char satuan;

        ratusan = nilai/100;
        puluhan = (nilai%100)/10;
        satuan = nilai%10;

        putchar(ratusan);
        putchar(puluhan);
        putchar(satuan);
}

// External Interrupt 0 service routine
interrupt [EXT_INT0] void ext_int0_isr(void)
{
// Place your code here
	char j;

	baca_adc = 1;
        for(j=0;j<25;j++)
        {
        	adc_temp[j] = 0;
        }
        for(j=0;j<25;j++)
        {
        	scan_adc();
                delay_ms(2);
        }
        for(j=0;j<25;j++)
        {
        	string_putchar(adc_temp[j]);
                putchar(13);
        }
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
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
PORTB=0xFF;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
PORTC=0xFF;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
// State7=P State6=P State5=P State4=P State3=P State2=P State1=1 State0=P
PORTD=0xFF;
DDRD=0x02;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

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

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x02;
MCUCSR=0x00;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 9600
UCSRA=0x00;
UCSRB=0x08;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x47;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 691.200 kHz
// ADC Voltage Reference: AREF pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here

      }
}
