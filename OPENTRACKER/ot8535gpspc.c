/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/13/2012
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATmega8535
Program type        : Application
Clock frequency     : 11.059200 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 128
*****************************************************/

#include <mega8535.h>
#include <stdio.h>
#include <string.h>
#include <delay.h>

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
#define TX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];
char tx_buffer[TX_BUFFER_SIZE];
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

#ifndef _DEBUG_TERMINAL_IO_
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

void SetIOPorts(void)
{
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
	// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=T 
	PORTD=0x00;
	DDRD=0x02;	
}

void SetUsart4800(void)
{
	UCSRA=0x00;
	UCSRB=0xD8;
	UCSRC=0x86;
	UBRRH=0x00;
	UBRRL=0x9B;
}

void SetUsart38400(void)
{
	UCSRA=0x00;
	UCSRB=0xD8;
	UCSRC=0x86;
	UBRRH=0x00;
	UBRRL=0x11;
}

flash char welcome[] = {"Selamat datang di fasilitas konfigurasi tracker via komunikasi serial/pc"};
flash char pak[] = {"Press any key !"};
flash char petunjuk[] = {"Ketik rangkaian setting Tracker yang anda inginkan"};
flash char mintaCall[] = {"Masukkan Callsign Anda : "};
flash char mintaSSID[] = {"Masukkan SSID Anda : "};
flash char mintaPath[] = {"Path anda.. tekan huruf kapital A untuk WIDE2-1, B untuk WIDE2-2, atau C untuk WIDE3-3 : "};
flash char wide21[] = {"WIDE2-1"};
flash char wide22[] = {"WIDE2-2"};
flash char wide33[] = {"WIDE3-3"};
flash char mintaSimbol[] = {"Masukkan simbol station anda (baca buku petunjuk)"};
flash char tunggu[] = {"Sedang di proses..."};
flash char selesai[] = {"Proses selesai"};
flash char CallAnda[] = {"Callsign anda : "};
flash char SSIDAnda[] = {"SSID anda : "};
flash char PathAnda[] = {"Path anda : "}; 
flash char SimbolAnda[] = {"Simbol stasiun anda : "};
flash char reconfigure[] = {"Seting ulang ? Y / N"};
flash char setingulang[] = {"Data dihapus...... Seting ulang data anda"};
char call[6];
char ssid;
char path;
char sim;
char hasil;
int i;

void KomunikasiSerial(void)
{
 	SetUsart38400();   
    //LED tx dinyalakan
    putchar(getchar());
    
    for(i=0; i<strlenf(welcome); i++) putchar(welcome[i]);
    putchar('\n');
    delay_ms(1000);
    
    for(i=0; i<strlenf(pak); i++) putchar(pak[i]);
    putchar('\n');
    getchar(); 
    
    	ulang:
    
    for(i=0; i<strlenf(petunjuk); i++) putchar(petunjuk[i]);
    putchar('\n');
    delay_ms(500);  
     
    for(i=0; i<strlenf(mintaCall); i++) putchar(mintaCall[i]);
    putchar('\n');   
    for(i=0; i<6; i++) {call[i]=getchar();}
    putchar('\n');
    delay_ms(500);
    
    for(i=0; i<strlenf(mintaSSID); i++) putchar(mintaSSID[i]);
    putchar('\n');   
    ssid=getchar();
    putchar('\n');
    delay_ms(500);
    
    for(i=0; i<strlenf(mintaPath); i++) putchar(mintaPath[i]);
    putchar('\n');   
    path=getchar();
    putchar('\n');
    delay_ms(500); 
    
    for(i=0; i<strlenf(mintaSimbol); i++) putchar(mintaSimbol[i]);
    putchar('\n');   
    sim=getchar();
    putchar('\n');
    delay_ms(500);
    
    for(i=0; i<strlenf(tunggu); i++) putchar(tunggu[i]);
    putchar('\n'); 
    delay_ms(125);
    
    for(i=0; i<strlenf(selesai); i++) putchar(selesai[i]);
    putchar('\n');
    
    for(i=0; i<strlenf(CallAnda); i++) putchar(CallAnda[i]);
    for(i=0; i<6; i++) {putchar(call[i]);}//tampilkan callsign
    putchar('\n');   
    
    for(i=0; i<strlenf(SSIDAnda); i++) putchar(SSIDAnda[i]);  
    putchar(ssid);//tampilkan SSID
    putchar('\n');
    
    for(i=0; i<strlenf(PathAnda); i++) putchar(PathAnda[i]);  
    if((path=='A') || (path=='a')){for(i=0; i<strlenf(wide21); i++) putchar(wide21[i]);}
    else if((path=='B') || (path=='b')){for(i=0; i<strlenf(wide22); i++) putchar(wide22[i]);}
    else {for(i=0; i<strlenf(wide33); i++) putchar(wide33[i]);}
    putchar('\n');   
    
    for(i=0; i<strlenf(SimbolAnda); i++) putchar(SimbolAnda[i]);  
    putchar(sim);//tampilkan simbol stasiun
    putchar('\n');
    delay_ms(1000);      
    
    for(i=0; i<strlenf(reconfigure); i++) putchar(reconfigure[i]);
    putchar('\n');         
    
    hasil = getchar();
    
    if((hasil=='N') || (hasil=='n'))
    {
    	for(i=0; i<strlenf(setingulang); i++) putchar(setingulang[i]);
    	putchar('\n');
        goto ulang;
    }    
    //led tx dimatikan 
    SetUsart4800();
}

void main(void)
{
	SetIOPorts();
    
    ACSR=0x80;
	SFIOR=0x00; 
    
    SetUsart4800();

	#asm("sei")

	while (1)
    {
    	KomunikasiSerial();	
	};
}
