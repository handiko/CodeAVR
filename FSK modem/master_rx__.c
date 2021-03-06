/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 10/16/2011
Author  : F4CG
Company : F4CG
Comments:


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 12.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega16.h>
#include <delay.h>
#include <lcd.h>
#include <stdio.h>

#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm

#define CONTROL_RX PINB.0

#define RXB8 1
#define TXB8 0
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
char rx_string[100];
bit rx_buffer_overflow;
int i;

#if RX_BUFFER_SIZE<256
        unsigned char rx_wr_index,rx_rd_index,rx_counter;
        #else
        unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

interrupt [USART_RXC] void usart_rx_isr(void)
{       char status,data;
        status=UCSRA;
        data=UDR;
        if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
        {       rx_buffer[rx_wr_index]=data;
                if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
                if (++rx_counter == RX_BUFFER_SIZE)
                {       rx_counter=0;
                        rx_buffer_overflow=1;
                };
        };
}

#ifndef _DEBUG_TERMINAL_IO_
        #define _ALTERNATE_GETCHAR_
        #pragma used+
        char getchar(void)
        {       char data;
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

void main(void)
{       PORTA=0x00;
        DDRA=0xFF;

        PORTD=0x01;
        DDRD=0x00;

        // USART initialization
        // Communication Parameters: 8 Data, 1 Stop, No Parity
        // USART Receiver: On
        // USART Transmitter: Off
        // USART Mode: Asynchronous
        // USART Baud rate: 300
        UCSRA=0x00;
        UCSRB=0x90;
        UCSRC=0x86;
        UBRRH=0x09;
        UBRRL=0xC3;

        ACSR=0x80;
        SFIOR=0x00;

        lcd_init(20);

        #asm("sei")
        top:
        if(CONTROL_RX)
        {
        for(i=0;;i++)
        {       rx_string[i]=getchar();
                if(rx_string[i]=='#')   break;
                if(i<20)
                {       lcd_gotoxy(i,0);
                }
                else if(i<40)
                {       lcd_gotoxy((i-20),1);
                }
                else if(i<60)
                {       lcd_gotoxy((i-40),2);
                }
                else if(i<80)
                {       lcd_gotoxy((i-60),3);
                }
                lcd_putchar(rx_string[i]);
        }
        delay_ms(800);
        lcd_clear();
        }
        goto top;
}
