/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 5/6/2012
Author  :
Company :
Comments:


Chip type               : ATtiny4313
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 64
*****************************************************/

#include <tiny2313.h>
#include <stdio.h>
//#include <string.h>
#include <delay.h>

#define DAC_0	PORTB.4
#define DAC_1  	PORTB.5
#define DAC_2   PORTB.6
#define DAC_3   PORTB.7

#define PTT	PORTB.3

#define AFSK_IN	PINB.1
#define GND_COM	PINB.0

#define UART_IN		PIND.0
#define DATA_IN		PIND.3
#define DATA_OUT 	PORTD.1
#define INV_DATA_OUT	PORTD.2
#define CARIER_CLK	PORTD.5

//flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
char matrix_fasa;
char cls_flag;
char int_anacomp;
char t;
char t_2200;
char t1_count;
bit dac_stat;
bit dat_out;

/*void set_dac(char value)
{
	DAC_0 = value & 0x01; 		//LSB
        DAC_1 =( value >> 1 ) & 0x01;
        DAC_2 =( value >> 2 ) & 0x01;
        DAC_3 =( value >> 3 ) & 0x01; 	//MSB
}

// External Interrupt 1 service routine
interrupt [EXT_INT1] void ext_int1_isr(void)
{
	// Place your code here
        matrix_fasa = 0;
}*/

// Timer0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
	// Place your code here
        TCNT0 = 0x75;
        t++;
        if(t > 8)
        {
        	t = 0;
        }
        else if((t>1)||(t<6)) CARIER_CLK = 0;
        else if((t<2)||(t>5)) CARIER_CLK = 1;

}


// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
	// Place your code here
        TCNT1L = 0xE0;
        TCNT1H = 0xFE;

        if(dac_stat)
        {
        	t1_count++;
        	//if((DATA_IN)&&(t1_count==2))
                if((DATA_IN)&&(t1_count==8))
        	{
        		/*set_dac(matrix[matrix_fasa]);
                        t1_count=0;
                        matrix_fasa++;
        		if(matrix_fasa==16) matrix_fasa=0;
                        */
                        t1_count=0;
                        if(dat_out)	{dat_out = 0; DAC_0 = dat_out;}
                        else		{dat_out = 1; DAC_0 = dat_out;}
        	}
                //if(!DATA_IN)
        	if((!DATA_IN)&&(t1_count==4))
        	{
        		/*set_dac(matrix[matrix_fasa]);
                	t1_count=0;
                        matrix_fasa++;
        		if(matrix_fasa==16) matrix_fasa=0;
                        */
                       	t1_count=0;
                        if(dat_out)	{dat_out = 0; DAC_0 = dat_out;}
                        else		{dat_out = 1; DAC_0 = dat_out;}
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
                if((t>2)&&(t<6))
        	{
        		t_2200++;
                	if(t_2200 == 2)
                	{
                		t_2200 = 0;
                                DATA_OUT = 1;
                                INV_DATA_OUT = 0;
                	}
        	}
        	else if((t>6)&&(t<10))
        	{
        		t_2200 = 0;
                        DATA_OUT = 0;
                        INV_DATA_OUT = 1;
        	}
        	t = 0;
        }

}

// Declare your global variables here

void main(void)
{
	//char strng[10];

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
	// State2=P State1=T State0=T
	PORTA=0x04;
	DDRA=0x00;

	// Port B initialization
	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=T State1=T State0=T
	PORTB=0x00;
	DDRB=0xF8;

	// Port D initialization
	// Func6=Out Func5=Out Func4=Out Func3=In Func2=Out Func1=Out Func0=In
	// State6=0 State5=0 State4=0 State3=P State2=1 State1=1 State0=P
	PORTD=0x0F;
	DDRD=0x76;

	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: 1382.400 kHz
	// Mode: Normal top=0xFF
	// OC0A output: Disconnected
	// OC0B output: Disconnected
	TCCR0A=0x00;
	TCCR0B=0x02;
	TCNT0=0x75;

	// Timer/Counter 1 initialization
	// Clock source: System Clock
	// Clock value: 11059.200 kHz
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
	TCNT1L=0xE0;
        TCNT1H=0xFE;

	// External Interrupt(s) initialization
	// INT0: Off
	// INT1: On
	// INT1 Mode: Any change
	// Interrupt on any change on pins PCINT0-7: Off
	GIMSK=0x80;
	MCUCR=0x04;
	EIFR=0x80;

        // Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=0x82;

	// USART initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART Receiver: On
	// USART Transmitter: Off
	// USART Mode: Asynchronous
	// USART Baud Rate: 1200
	UCSRA=0x00;
	UCSRB=0x10;
	UCSRC=0x06;
	UBRRH=0x02;
	UBRRL=0x3F;

	// Analog Comparator initialization
	// Analog Comparator: On
	// Interrupt on Output Toggle
	// Analog Comparator Input Capture by Timer/Counter 1: Off
	ACSR=0x08;
	// Digital input buffer on AIN0: On
	// Digital input buffer on AIN1: On
	DIDR=0x03;

        matrix_fasa = 0;
	cls_flag = 0;
	int_anacomp = 0;
	t = 0;
	t_2200 = 0;
	t1_count = 0;
	dac_stat = 0;
        dat_out = 0;

	// Global enable interrupts
	#asm("sei")

	while (1)
      	{

                // Place your code here
                if(getchar()=='$')
                {
                	dac_stat = 1;
                        PTT = 1;
                }

                //gets(strng,10);
                //if(strcmpf(strng,"~~~~~"))
                else if(getchar()=='~')
                {
                	cls_flag++;
                        if(cls_flag==5)
                        {
                        	delay_ms(100);
                        	PTT = 0;
                                dac_stat = 0;
                                cls_flag = 0;
                        }
                }
      	}
}
