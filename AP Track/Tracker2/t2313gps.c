/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/13/2012
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATtiny2313
Clock frequency     : 12.000000 MHz
Memory model        : Tiny
External SRAM size  : 0
Data Stack size     : 32
*****************************************************/

#include <tiny2313.h>
#include <stdio.h>
#include <ctype.h>

#define RXB8 1
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];
bit rx_buffer_overflow;

#if RX_BUFFER_SIZE<256
	unsigned char rx_wr_index,rx_rd_index,rx_counter;
	#else
	unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

interrupt [USART_RXC] void usart_rx_isr(void)
{
	char status,data;
	status=UCSRA;
	data=UDR;
	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   	{
   		rx_buffer[rx_wr_index]=data;
   		if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   		if (++rx_counter == RX_BUFFER_SIZE)
      		{
      			rx_counter=0;
      			rx_buffer_overflow=1;
      		};
   	};
}

#ifndef _DEBUG_TERMINAL_IO_
#define _ALTERNATE_GETCHAR_
#pragma used+
	char getchar(void)
	{
		char data;
		while (rx_counter==0);
		data=rx_buffer[rx_rd_index];
		if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
		#asm("cli")
		--rx_counter;
		#asm("sei")
		return data;
	}
#pragma used-
#endif

void InitClockDivision(void)
{
#pragma optsize-
	CLKPR=0x80;
	CLKPR=0x00;
	#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
	#endif
}

void InitIOPorts(void)
{
	// Port B initialization
	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
	// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
	PORTB=0x00;
	DDRB=0x00;

	// Port D initialization
	// Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In 
	// State6=T State5=T State4=T State3=T State2=T State1=0 State0=T 
	PORTD=0x00;
	DDRD=0x02;
}

void InitUSART(void)
{	
	UCSRA = 0x00;
	UCSRB = 0xD8;
	UCSRC = 0x06;
        UBRRH = 0x00;
        UBRRL = 0x9B;
}

char GPRMCReceived(void)
{
	if(getchar()=='$')
        {
         	getchar();
                getchar();
                getchar();
                getchar();
                if(getchar()=='C')
                	return(1);
        } 
}

char lat[8];
char lon[9];
eeprom char gps_buff[80];

void BufferingGPS(void)
{
 	int i;
        for(i=0; i<80; i++)
        {
        	gps_buff[i]=getchar();
        }
}

void ParsingGPRMC(void)
{
	    
}

void main(void)
{
	InitClockDivision();
        InitIOPorts();
        InitUSART();
        ACSR=0x80;

	#asm("sei")

}
