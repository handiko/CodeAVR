/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/16/2011
Author  : Handiko Gesang Anugrah Sejati                          
Company : Teknik Fisika UGM -- LPKTA UGM                        
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
#include <string.h>

#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm  

#define TX_CONTROL PORTD.2 
#define ON 1
#define OFF 0

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

#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];
char tx_string[100] = {"tes transfer serial data string melalui modulasi FSK #"}; 
int i;      

void kirim_serial();
void tunggu(int t);

#if TX_BUFFER_SIZE<256
        unsigned char tx_wr_index,tx_rd_index,tx_counter;
        #else
        unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

interrupt [USART_TXC] void usart_tx_isr(void)
{       if (tx_counter)
        {       --tx_counter;
                UDR=tx_buffer[tx_rd_index];
                if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
        };
}

#ifndef _DEBUG_TERMINAL_IO_
        #define _ALTERNATE_PUTCHAR_
        #pragma used+
        void putchar(char c)
        {       while (tx_counter == TX_BUFFER_SIZE);
                #asm("cli")
                if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
                {       tx_buffer[tx_wr_index]=c;
                        if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
                        ++tx_counter;
                }
                else
                        UDR=c;
                #asm("sei")
        }
        #pragma used-
#endif  

void kirim_serial()
{       for(i=0;i<(strlen(tx_string));i++)
        {       TX_CONTROL = ON; 
                tunggu(500);
                putchar(tx_string[i]);
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
                if(tx_string[i]!='#')   lcd_putchar(tx_string[i]);
        }   
        TX_CONTROL = OFF; 
        tunggu(300);
        lcd_clear();
}    

void tunggu(int t)
{       delay_ms(t);
}

void main(void)
{       PORTA=0x00;
        DDRA=0xFF;

        PORTD=0x01;
        DDRD=0x06;

        // USART initialization
        // Communication Parameters: 8 Data, 1 Stop, No Parity
        // USART Receiver: Off
        // USART Transmitter: On
        // USART Mode: Asynchronous
        // USART Baud rate: 300
        UCSRA=0x00;
        UCSRB=0x48;
        UCSRC=0x86;
        UBRRH=0x09;
        UBRRL=0xC3;
        
        ACSR=0x80;
        SFIOR=0x00;

        lcd_init(20);

        #asm("sei")

        while (1)
        {       tunggu(1300);
                kirim_serial();
        };
}
