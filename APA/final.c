/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 6/8/2012
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

char i;
bit enadc;

unsigned int time;

unsigned char sen_buff[10];
unsigned char sen[26];

// External Interrupt 0 service routine
//interrupt [EXT_INT0] void ext_int0_isr(void)
//{
	//for(i=0;i<26;i++)
        //{
        //	sen[i]=0;
        //}
//}

// Standard Input/Output functions
#include <stdio.h>

#define TRIGGER PINB.0
#define MUX_A	PINB.0
#define MUX_B	PINB.1
#define MUX_C	PINB.2

unsigned char read_adc(unsigned char adc_input);

char ratusan(unsigned char in)
{
	in/=100;

        return (in +'0');
}

char puluhan(unsigned char in)
{
	in%=100;

        return ((in / 10)+'0');
}

char satuan(unsigned char in)
{
	return ((in % 10)+'0');
}

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
	time++;
        sen_buff[0]=read_adc(0);
        sen_buff[1]=read_adc(1);
        sen_buff[2]=read_adc(2);
        sen_buff[3]=read_adc(3);

        if(sen_buff[0]>sen[17])	sen[17]=sen_buff[0];
        if(sen_buff[1]>sen[9])	sen[9]=sen_buff[1];
        if(sen_buff[2]>sen[1])	sen[1]=sen_buff[2];
        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];

        sen_buff[0]=read_adc(0);
        sen_buff[1]=read_adc(1);
        sen_buff[2]=read_adc(2);
        sen_buff[3]=read_adc(3);

        if(sen_buff[0]>sen[18])	sen[18]=sen_buff[0];
        if(sen_buff[1]>sen[10])	sen[10]=sen_buff[1];
        if(sen_buff[2]>sen[2])	sen[2]=sen_buff[2];
        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];

        sen_buff[0]=read_adc(0);
	sen_buff[1]=read_adc(1);
        sen_buff[2]=read_adc(2);
        sen_buff[3]=read_adc(3);

        if(sen_buff[0]>sen[19])	sen[18]=sen_buff[0];
        if(sen_buff[1]>sen[11])	sen[11]=sen_buff[1];
        if(sen_buff[2]>sen[3])	sen[3]=sen_buff[2];
        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];

        sen_buff[0]=read_adc(0);
        sen_buff[1]=read_adc(1);
        sen_buff[2]=read_adc(2);
        sen_buff[3]=read_adc(3);

        if(sen_buff[0]>sen[20])	sen[20]=sen_buff[0];
        if(sen_buff[1]>sen[12])	sen[12]=sen_buff[1];
        if(sen_buff[2]>sen[4])	sen[4]=sen_buff[2];
        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];

        sen_buff[0]=read_adc(0);
        sen_buff[1]=read_adc(1);
        sen_buff[2]=read_adc(2);
        sen_buff[3]=read_adc(3);

	if(sen_buff[0]>sen[21])	sen[21]=sen_buff[0];
        if(sen_buff[1]>sen[13])	sen[13]=sen_buff[1];
        if(sen_buff[2]>sen[5])	sen[5]=sen_buff[2];
        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];

        sen_buff[0]=read_adc(0);
        sen_buff[1]=read_adc(1);
        sen_buff[2]=read_adc(2);
        sen_buff[3]=read_adc(3);

                        if(sen_buff[0]>sen[22])	sen[22]=sen_buff[0];
                        if(sen_buff[1]>sen[14])	sen[14]=sen_buff[1];
                        if(sen_buff[2]>sen[6])	sen[6]=sen_buff[2];
                        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
                //}

                //else if((MUX_A==1)&&(MUX_B==1)&&(MUX_C==0))
                //{
                	sen_buff[0]=read_adc(0);
                        sen_buff[1]=read_adc(1);
                        sen_buff[2]=read_adc(2);
                        sen_buff[3]=read_adc(3);

                        if(sen_buff[0]>sen[23])	sen[23]=sen_buff[0];
                        if(sen_buff[1]>sen[15])	sen[15]=sen_buff[1];
                        if(sen_buff[2]>sen[7])	sen[7]=sen_buff[2];
                        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
               // }

                //else if((MUX_A==1)&&(MUX_B==1)&&(MUX_C==1))
                //{
                	sen_buff[0]=read_adc(0);
                        sen_buff[1]=read_adc(1);
                        sen_buff[2]=read_adc(2);
                        sen_buff[3]=read_adc(3);

                        if(sen_buff[0]>sen[24])	sen[24]=sen_buff[0];
                        if(sen_buff[1]>sen[16])	sen[16]=sen_buff[1];
                        if(sen_buff[2]>sen[8])	sen[8]=sen_buff[2];
                        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
               // }

        putchar(13);
        puts("mulai");
        for(i=0;i<25;i++)
        {
        	putchar(13);
                putchar(ratusan(sen[i+1]));
                putchar(puluhan(sen[i+1]));
                putchar(satuan(sen[i+1]));
        }
        putchar(13);
        puts("selesai");
        putchar(13);

        if(time==1000)
        {
        	for(i=0;i<26;i++)
                {
                	sen[i]=0;
                }
                time=0;
        }

        TCNT0=0x94;
}

#define ADC_VREF_TYPE 0x60

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
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=1 State0=P
PORTD=0x03;
DDRD=0x02;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 10.800 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x05;
TCNT0=0x94;
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
// INT0 Mode: Rising Edge
// INT1: Off
// INT2: Off
GICR|=0x40;
MCUCR=0x03;
MCUCSR=0x00;
GIFR=0x40;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: Off
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 1200
UCSRA=0x00;
UCSRB=0x08;
UCSRC=0x86;
UBRRH=0x02;
UBRRL=0x3F;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 691.200 kHz
// ADC Voltage Reference: AVCC pin
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

time=0;

enadc=0;

// Global enable interrupts
#asm("sei")

while (1)
      {
      /* Place your code here
      		if((MUX_A==0)&&(MUX_B==0)&&(MUX_C==0))
                {
                	sen_buff[0]=read_adc(0);
                        sen_buff[1]=read_adc(1);
                        sen_buff[2]=read_adc(2);
                        sen_buff[3]=read_adc(3);

                        if(sen_buff[0]>sen[17])	sen[17]=sen_buff[0];
                        if(sen_buff[1]>sen[9])	sen[9]=sen_buff[1];
                        if(sen_buff[2]>sen[1])	sen[1]=sen_buff[2];
                        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
                }

                else if((MUX_A==0)&&(MUX_B==0)&&(MUX_C==1))
                {
                	sen_buff[0]=read_adc(0);
                        sen_buff[1]=read_adc(1);
                        sen_buff[2]=read_adc(2);
                        sen_buff[3]=read_adc(3);

                        if(sen_buff[0]>sen[18])	sen[18]=sen_buff[0];
                        if(sen_buff[1]>sen[10])	sen[10]=sen_buff[1];
                        if(sen_buff[2]>sen[2])	sen[2]=sen_buff[2];
                        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
                }

                else if((MUX_A==0)&&(MUX_B==1)&&(MUX_C==0))
                {
                	sen_buff[0]=read_adc(0);
                        sen_buff[1]=read_adc(1);
                        sen_buff[2]=read_adc(2);
                        sen_buff[3]=read_adc(3);

                        if(sen_buff[0]>sen[19])	sen[18]=sen_buff[0];
                        if(sen_buff[1]>sen[11])	sen[11]=sen_buff[1];
                        if(sen_buff[2]>sen[3])	sen[3]=sen_buff[2];
                        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
                }

                else if((MUX_A==0)&&(MUX_B==1)&&(MUX_C==1))
                {
                	sen_buff[0]=read_adc(0);
                        sen_buff[1]=read_adc(1);
                        sen_buff[2]=read_adc(2);
                        sen_buff[3]=read_adc(3);

                        if(sen_buff[0]>sen[20])	sen[20]=sen_buff[0];
                        if(sen_buff[1]>sen[12])	sen[12]=sen_buff[1];
                        if(sen_buff[2]>sen[4])	sen[4]=sen_buff[2];
                        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
                }

                else if((MUX_A==1)&&(MUX_B==0)&&(MUX_C==0))
                {
                	sen_buff[0]=read_adc(0);
                        sen_buff[1]=read_adc(1);
                        sen_buff[2]=read_adc(2);
                        sen_buff[3]=read_adc(3);

                        if(sen_buff[0]>sen[21])	sen[21]=sen_buff[0];
                        if(sen_buff[1]>sen[13])	sen[13]=sen_buff[1];
                        if(sen_buff[2]>sen[5])	sen[5]=sen_buff[2];
                        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
                }

                else if((MUX_A==1)&&(MUX_B==0)&&(MUX_C==1))
                {
                	sen_buff[0]=read_adc(0);
                        sen_buff[1]=read_adc(1);
                        sen_buff[2]=read_adc(2);
                        sen_buff[3]=read_adc(3);

                        if(sen_buff[0]>sen[22])	sen[22]=sen_buff[0];
                        if(sen_buff[1]>sen[14])	sen[14]=sen_buff[1];
                        if(sen_buff[2]>sen[6])	sen[6]=sen_buff[2];
                        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
                }

                else if((MUX_A==1)&&(MUX_B==1)&&(MUX_C==0))
                {
                	sen_buff[0]=read_adc(0);
                        sen_buff[1]=read_adc(1);
                        sen_buff[2]=read_adc(2);
                        sen_buff[3]=read_adc(3);

                        if(sen_buff[0]>sen[23])	sen[23]=sen_buff[0];
                        if(sen_buff[1]>sen[15])	sen[15]=sen_buff[1];
                        if(sen_buff[2]>sen[7])	sen[7]=sen_buff[2];
                        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
                }

                else if((MUX_A==1)&&(MUX_B==1)&&(MUX_C==1))
                {
                	sen_buff[0]=read_adc(0);
                        sen_buff[1]=read_adc(1);
                        sen_buff[2]=read_adc(2);
                        sen_buff[3]=read_adc(3);

                        if(sen_buff[0]>sen[24])	sen[24]=sen_buff[0];
                        if(sen_buff[1]>sen[16])	sen[16]=sen_buff[1];
                        if(sen_buff[2]>sen[8])	sen[8]=sen_buff[2];
                        if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
                }  */
      }
}
