/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/1/2011
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATmega32
Program type        : Application
Clock frequency     : 12.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 512
*****************************************************/

#include <mega32.h> 
#include <lcd.h>
#include <delay.h>
#include <stdio.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm

#define RXB8    1
#define TXB8    0
#define UPE     2
#define OVR     3
#define FE      4
#define UDRE    5
#define RXC     7

#define FRAMING_ERROR           (1<<FE)
#define PARITY_ERROR            (1<<UPE)
#define DATA_OVERRUN            (1<<OVR)
#define DATA_REGISTER_EMPTY     (1<<UDRE)
#define RX_COMPLETE             (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE  8
char rx_buffer[RX_BUFFER_SIZE];   
char huruf;

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
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
// Get a character from the USART Receiver buffer
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

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE<256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
        if (tx_counter)
        {
                --tx_counter;
                UDR=tx_buffer[tx_rd_index];
                if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
        };
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
        while (tx_counter == TX_BUFFER_SIZE);
        #asm("cli")
        if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
        {
                tx_buffer[tx_wr_index]=c;
                if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
                ++tx_counter;
        }
        else
        UDR=c;
        #asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions

// Declare your global variables here

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTA=0x00;
DDRA=0xFF;

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
// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=P 
PORTD=0x01;
DDRD=0x02;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
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
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud rate: 9600
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x4D;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// LCD module initialization
lcd_init(16);

// Global enable interrupts
#asm("sei")   

lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("F");  

delay_ms(290);
lcd_clear();

while (1)
      {
      // Place your code here  
                huruf = getchar();  
                lcd_putchar(huruf);
                
                delay_ms(100);
                putchar('H');

      };
}
