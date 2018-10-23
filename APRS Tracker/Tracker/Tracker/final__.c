/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : APRS BEACON
Version : PROTOCOL TEST
Date    : 12/23/2011
Author  : HANDIKO GESANG ANUGRAH S.
Company : TIM TELEMETRI & RADIO INSTRUMENTASI
	  LABORATORIUM SENSOR DAN SISTEM TELEKONTROL
	  JURUSAN TEKNIK FISIKA
          FAKULTAS TEKNIK
          UNIVERSITAS GADJAH MADA

Chip type           : ATtiny2313
Program type        : Application
Clock frequency     : 11.059200 MHz
Memory model        : Tiny
External SRAM size  : 0
Data Stack size     : 32

Pembangkit Polynomial, G(x) = x^16 + x^12 + x^5 + 1

*****************************************************/

#include <tiny2313.h>
#include <delay.h>
#include <stdio.h>

#ifndef RXB8
#define RXB8 1
#endif

#ifndef	UPE
#define UPE 2
#endif

#ifndef	OVR
#define OVR 3
#endif

#ifndef	FE
#define FE 4
#endif

#ifndef	UDRE
#define UDRE 5
#endif

#ifndef	RXC
#define RXC 7
#endif

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
{	char status,data;
	status=UCSRA;
	data=UDR;
	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   	{	rx_buffer[rx_wr_index]=data;
   		if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   		if (++rx_counter == RX_BUFFER_SIZE)
      		{	rx_counter=0;
      			rx_buffer_overflow=1;
      		};
   	};
}

#ifndef _DEBUG_TERMINAL_IO_
#define _ALTERNATE_GETCHAR_
#pragma used+
	char getchar(void)
	{	char data;
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



#define _1200		0
#define _2200		1
#define CONST_1200      46
#define CONST_2200      22
#define waktu		1
#define prescaler	10800
#define TIME_CONST	((65536)-(waktu * prescaler))

#define TX_NOW  PIND.3
#define PTT     PORTB.3
#define DAC_0   PORTB.7
#define DAC_1   PORTB.6
#define DAC_2   PORTB.5
#define DAC_3   PORTB.4

#define L_BUSY	PORTD.5
#define L_STBY  PORTD.4

#define aktif		1
#define non_aktif	0

void set_dac(char value);
void set_nada(char i_nada);
void kirim_karakter(unsigned char input);
void kirim_paket(void);
void ubah_nada(void);
void hitung_crc(char in_crc);
void kirim_crc(void);
void ekstrak_gps(void);
void init_usart(void);
void clear_usart(void);

flash char flag = 0x7E;
flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
flash char data[75] =
{ 	('A'<<1),('P'<<1),('Z'<<1),('U'<<1),('G'<<1),('M'<<1),0b11100000,
	('3'<<1),('6'<<1),('7'<<1),('0'<<1),('9'<<1),(' '<<1),('9'<<1),
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('1'<<1),(' '<<1),('1'<<1),
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1,

        0x03,0xF0,

        //index 30 (elemen 31)
        '=',

        //index31 (elemen 32)
        ':',':',':',' ','H','A','N','D','I','K','O',' ','(','3','6','7','0','9',')',' ',
        'M','O','B','I','L','E',' ','A','P','R','S',' ','T','R','A','C','K','E','R',' ',':',':',':',0x0D
};
char posisi[19] =
{ 	'0','7','4','5','.','3','1','S','H','1','1','0','2','2','.','5','2','E','&'
};
bit nada = _1200;
bit usart_stat;
static char bit_stuff = 0;
unsigned short _TCNT0;
unsigned short crc;

interrupt [EXT_INT1] void ext_int1_isr(void)
{	L_STBY = 0;
        L_BUSY = 0;
        delay_ms(250);
        kirim_paket();
}

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{	bit mem;

        mem = L_STBY;
	L_STBY = 0;
        L_BUSY = 1;
        init_usart();
        ekstrak_gps();
        clear_usart();
        L_BUSY = 0;
        L_STBY = mem;

        TCNT1H=0x02;
	TCNT1L=0xE0;
}

void kirim_paket(void)
{	char i;

	crc = 0xFFFF;
	PTT = 1;
        delay_ms(500);

        for(i=0;i<70;i++)	kirim_karakter(flag);
        bit_stuff = 0;
        for(i=0;i<31;i++)	kirim_karakter(data[i]);
        for(i=0;i<19;i++)	kirim_karakter(posisi[i]);
        for(i=31;i<75;i++)	kirim_karakter(data[i]);
        kirim_crc();
        for(i=0;i<10;i++)	kirim_karakter(flag);

        PTT = 0;
}

void kirim_crc(void)
{ 	static unsigned char crc_lo;
	static unsigned char crc_hi;

        crc_lo = crc ^ 0xFF;
        crc_hi = (crc >> 8) ^ 0xFF;
        kirim_karakter(crc_lo);
        kirim_karakter(crc_hi);
}

void kirim_karakter(unsigned char input)
{	char i;
	bit in_bit;

	for(i=0;i<8;i++)
        {	in_bit = (input >> i) & 0x01;
                if(input==0x7E)	{bit_stuff = 0;}
                else		{hitung_crc(in_bit);}
                if(!in_bit)
                {	ubah_nada();
                        bit_stuff = 0;
                }
                else
                {	set_nada(nada);
                        bit_stuff = bit_stuff + 1;
                        if(bit_stuff==5)
                        {	ubah_nada();
                                bit_stuff = 0;
                        }
                }
        }
}

void hitung_crc(char in_crc)
{  	static unsigned short xor_in;

	xor_in = crc ^ in_crc;
	crc >>= 1;
        if(xor_in & 0x01)	crc ^= 0x8408;
}

void ubah_nada(void)
{	if(nada ==_1200)
	{	nada = _2200;
        	set_nada(nada);
	}
        else
        {	nada = _1200;
        	set_nada(nada);
        }
}

void set_dac(char value)
{	DAC_0 = value & 0x01;   	// LSB
        DAC_1 =( value >> 1 ) & 0x01;
        DAC_2 =( value >> 2 ) & 0x01;
        DAC_3 =( value >> 3 ) & 0x01;	// MSB
}

void set_nada(char i_nada)
{	char i;

	if(i_nada == _1200)
    	{	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
        		delay_us(CONST_1200);
        	}
    	}
    	else
    	{	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
                	delay_us(CONST_2200);
                }
                for(i=0; i<13; i++)
                {	set_dac(matrix[i]);
                	delay_us(CONST_2200);
                }
    	}
}

void getComma(void)
{	while(getchar() != ',');
}

void ekstrak_gps(void)
{	int i;
        static char buff_posisi[17];

        while(getchar() != '$');
	getchar();
        getchar();
        if(getchar() == 'G')
        {	if(getchar() == 'L')
        	{	if(getchar() == 'L')
                	{	getComma();
                        	for(i=0; i<7; i++)	buff_posisi[i] = getchar();
                                getchar();
                                getchar();
                                getComma();
                                buff_posisi[7] = getchar();
                                getComma();
                                for(i=0; i<8; i++)	buff_posisi[i+8] = getchar();
                                getchar();
                                getchar();
                                getComma();
                                buff_posisi[16] = getchar();

                                for(i=0;i<8;i++)	{posisi[i]=buff_posisi[i];}
        			for(i=0;i<9;i++)	{posisi[i+9]=buff_posisi[i+8];}
                        }
                }
        }
}

void init_usart(void)
{	usart_stat = 1;
	UCSRA=0x00;
	UCSRB=0x90;
	UCSRC=0x06;
	UBRRH=0x00;
	UBRRL=0x8F;
}

void clear_usart(void)
{ 	usart_stat = 0;
	UCSRA=0;
	UCSRB=0;
	UCSRC=0;
	UBRRH=0;
	UBRRL=0;
}

void main(void)
{
#pragma optsize-
	CLKPR=0x80;
	CLKPR=0x00;
	#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
	#endif

        PORTB=0x00;
	DDRB=0xF8;
        PORTD=0x09;
	DDRD=0x30;

        ACSR=0x80;
        DIDR=0x00;

	GIMSK=0x80;
	MCUCR=0x08;
	EIFR=0x80;

	_TCNT0 = TIME_CONST;

	TCCR1A=0x00;
	TCCR1B=0x05;
	TCNT1H=0x02;
	TCNT1L=0xE0;
	ICR1H=0x00;
	ICR1L=0x00;
        TIMSK=0x80;

#pragma optsize-
	// 39, 29, = 8 detik
        // 38, 28, = 4 detik
        // 1F, 0F, = 2 detik
        // 1E, 0E, = 1 detik
        WDTCR=0x39;
	WDTCR=0x29;
	#ifdef _OPTIMIZE_SIZE_
#pragma optsize+
	#endif

        L_BUSY = 1;
        delay_ms(500);
        L_STBY = 1;
        delay_ms(500);
        L_BUSY = 0;
        delay_ms(500);
        L_STBY = 0;

        #asm("sei")

        L_STBY = 1;
        delay_ms(1000);

        while (1)
        {	L_STBY = 0;

                try:
                if(usart_stat)
                { 	delay_ms(100);
                	goto try;
                }
                else	kirim_paket();
                L_STBY = 1;

                delay_ms(12000);
        };
}
