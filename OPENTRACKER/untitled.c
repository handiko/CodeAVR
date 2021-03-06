#include <mega8535_bits.h>

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

#define RX_BUFFER_SIZE 8 
#define TX_BUFFER_SIZE 8

char tx_buffer[TX_BUFFER_SIZE];
char rx_buffer[RX_BUFFER_SIZE]; 
bit rx_buffer_overflow;

#if RX_BUFFER_SIZE<256
	unsigned char rx_wr_index,rx_rd_index,rx_counter;
	#else
	unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

#if TX_BUFFER_SIZE<256
	unsigned char tx_wr_index,tx_rd_index,tx_counter;
	#else
	unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

interrupt [USART_RXC] void usart_rx_isr(void) {
	char status,data;
	status=UCSRA;
	data=UDR;
	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0) {
   		rx_buffer[rx_wr_index]=data;
   		if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   		if (++rx_counter == RX_BUFFER_SIZE) {
      			rx_counter=0;
      			rx_buffer_overflow=1;
      		};
   	};
} 

interrupt [USART_TXC] void usart_tx_isr(void) {
	if (tx_counter) {
   		--tx_counter;
   		UDR=tx_buffer[tx_rd_index];
   		if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   	};
}

#ifndef _DEBUG_TERMINAL_IO_
	#define _ALTERNATE_GETCHAR_
#pragma used+
	char getchar(void) {
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

#ifndef _DEBUG_TERMINAL_IO_
	#define _ALTERNATE_PUTCHAR_
#pragma used+
	void putchar(char c) {
		while (tx_counter == TX_BUFFER_SIZE);
		#asm("cli")
		if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0)) {
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
