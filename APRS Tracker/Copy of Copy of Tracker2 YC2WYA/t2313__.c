/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : APRS BEACON
Version : STRING TEST
Date    : 12/23/2011
Author  : HANDIKO GESANG ANUGRAH S.
Company : LABORATORIUM SENSOR DAN TELEKONTROL
	  JURUSAN TEKNIK FISIKA
          FAKULTAS TEKNIK
          UNIVERSITAS GADJAH MADA

Chip type           : ATtiny2313
Program type        : Application
Clock frequency     : 11.059200 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 32

Polynomial Generator G(x) = x^16 + x^12 + x^5 + 1

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
#define CONST_2400      21
#define CONST_POLYNOM   0b10001000000100001	// x^16 + x^12 + x^5 + 1
//#define CONST_POLYNOM	0b11000000000000101	// x^16 + x^15 + x^2 + 1

#define TX_NOW  PIND.3
#define PTT     PORTB.3
#define DAC_0   PORTB.4
#define DAC_1   PORTB.5
#define DAC_2   PORTB.6
#define DAC_3   PORTB.7

#define L_TX	PORTD.4
#define L_BUSY	PORTD.5
#define L_STBY  PORTD.6

// PIND.0 usart pullup
// PINB.0 AIN0 input toggle

void init_data(void);
void protocol(void);
void send_data(char input);
void fliptone(void);
void set_dac(char value);
void send_tone(char nada);
void send_fcs(char infcs);
void calc_fcs(char in);
void getComma();
void ekstrak_gps();
void init_usart(void);
void clear_usart(void);

flash char flag = 0x7E;
flash char ssid_2 = 0b01100100;
flash char ssid_9 = 0b01110010;
flash char ssid_2final = 0b01100101;
// flash char ssid_9final = 0b01110011;
/* 	APRStracker.h
 *	position 0x00-0x06 destination address APERXQ-0
 *	db	'A'<<1, 'P'<<1, 'E'<<1, 'R'<<1, 'X'<<1, 'Q'<<1, '0'<<1
 *
 *	position 0x07-0x0d source address NOCALL-0
 *	db	'N'<<1, 'O'<<1, 'C'<<1, 'A'<<1, 'L'<<1, 'L'<<1, '0'<<1
 *
 *	position 0x0e-0x14 first digipeater RELAY-0
 *	db	'R'<<1, 'E'<<1, 'L'<<1, 'A'<<1, 'Y'<<1, ' '<<1, '0'<<1
 *
 *	position 0x15-0x1b second digipeater WIDE2-2
 *	db	'W'<<1, 'I'<<1, 'D'<<1, 'E'<<1, '2'<<1, ' '<<1, ('2'<<1) + 1
 */

char destination[7] =
{     	0x41,0x50,0x55,0x32,0x35,0x4D,
        0               // nol untuk SSID
        //'A'<<1, 'P'<<1, 'U'<<1, '2'<<1, '5'<<1, 'N'<<1, '2'<<1
        // APU25N-2     // 0b011SSIDx format, SSID = 2 = 0b0010
};
char source[7] =
{      	0x59,0x44,0x32,0x58,0x42,0x43,
        0               // nol untuk SSID
        //'Y'<<1, 'D'<<1, '2'<<1, 'X'<<1, 'B'<<1, 'C'<<1, '9'<<1
        // YD2XBC-9     // 0b011SSIDx format, SSID = 9 = 0b1001
};
char digi[7] =
{       // 0x57,0x49,0x44,0x45,0x32,0x32,0x20    // atau
        0x57,0x49,0x44,0x45,0x32,
        0x20,
        0x0 		// nol untuk SSID
        //'W'<<1, 'I'<<1, 'D'<<1, 'E'<<1, '3'<<1, ' '<<1, ('3'<<1)+1
        // WIDE2-2      // 0b011SSIDx format, SSID = 2 = 0b0010
};
flash char control_field = 0x03;
flash unsigned char protocol_id = 0xF0;
flash char data_type = 0x21;
eeprom char latitude[8] =
{	0x30,0x37,0x34,0x35,0x2E,0x37,0x39,0x53			// format string
        // 0,7,4,5,0x2E,7,9,0x53				// format int
        // 0745.79S
};
flash char symbol_table = 0x2F;
eeprom char longitude[9] =
{	0x31,0x31,0x30,0x30,0x35,0x2E,0x32,0x31,0x45
        // 1,1,0,0,5,0x2E,2,1,0x45
        // 11005.21E
};
flash char symbol_code = 0x3E;
flash char comment[43] =
{	0x54,0x45,0x53,0x54,0x49,0x4E,0x47,0x20,                // testing(spasi)
        0x46,0x4F,0x52,0x20,                                    // for(spasi)
        0x45,0x4D,0x45,0x52,0x47,0x45,0x4E,0x43,0x59,0x20,      // emergency(spasi)
        0x42,0x45,0x41,0x43,0x4F,0x4E,0x20,                     // beacon(spasi)
        0x20,0x20,0x20,0x20,0x20,0x20,0x20,                     // (spasi)
        0x20,0x20,0x20,0x20,0x20,0x20,0x20                      // (spasi)
        // testing for emergency beacon
};
unsigned char fcshi;
unsigned char fcslo;
char count_1 = 0;
char x_counter = 0;
bit flag_state;
bit crc_flag = 0;
bit tone = _1200;
long fcs_arr = 0;
flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};	//fungsi sinus

void tes_nada_1200(void)
{	char i;
	int j;
        L_BUSY = 1;
	for(j=0; j<1000; j++)
    	{	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
        		delay_us(CONST_1200);
        	}
    	}
        L_BUSY = 0;
}

void tes_nada_2400(void)
{	char i;
	int j;
        L_STBY =1;
        for(j=0; j<2000; j++)
        {	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
                	delay_us(CONST_2400);
                }
        }
        L_STBY = 0;
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{	L_STBY = 0;
        L_BUSY = 0;
        delay_ms(250);
        clear_usart();
        protocol();
        init_usart();
}

void init_data(void)
{	char i;
        for(i=0;i<7;i++)
        {      	digi[i] <<= 1;
                destination[i] <<= 1;
                source[i] <<= 1;
        }

        destination[6] = ssid_2;
        source[6] = ssid_9;
        digi[5] = ssid_2final;
}

void protocol(void)
{	char i;
        init_data();						// persiapkan bit shifting
        PTT = 1;
        L_TX = 1;
        delay_ms(1000);                  			// tunggu sampai radio stabil
        crc_flag = 0;
        flag_state = 1;
        for(i=0;i<30;i++)       send_data(flag);             	// kirim flag 24 kali
        flag_state = 0;
        for(i=0;i<7;i++)        send_data(destination[i]);      // kirim callsign tujuan
        for(i=0;i<7;i++)        send_data(source[i]);           // kirim callsign asal
        send_data(ssid_9);
        for(i=0;i<7;i++)        send_data(digi[i]);             // kirim path digi
        send_data(control_field);                               // kirim data control field
        send_data(protocol_id);                                 // kirim data PID
        send_data(data_type);                                   // kirim data type info
        for(i=0;i<8;i++)        send_data(latitude[i]);         // kirim data lintang posisi
        send_data(symbol_table);                                // kirim simbol tabel
        for(i=0;i<9;i++)        send_data(longitude[i]);        // kirim data bujur posisi
        send_data(symbol_code);                                 // kirim simbol kode
        for(i=0;i<43;i++);      send_data(comment[i]);          // kirim komen
        crc_flag = 1;    	calc_fcs(0);	        	// hitung FCS
        send_fcs(fcshi);                                        // kirim 8 MSB dari FCS
        send_fcs(fcslo);                                        // kirim 8 LSB dari FCS
        flag_state = 1;
        for(i=0;i<15;i++)       send_data(flag);             	// kirim flag 12 kali
        flag_state = 0;
        PTT = 0;
        L_TX = 0;
}

void send_data(char input)
{	char i;
        bit x;
        for(i=0;i<8;i++)
        {	x = (input >> i) & 0x01;
                if(!flag_state)	calc_fcs(x);
                if(x)
                {	if(!flag_state) count_1++;
                        if(count_1==5)  fliptone();
                        send_tone(tone);
                }
                if(!x)  fliptone();
        }
}

void fliptone(void)
{	count_1 = 0;
        if(tone == _1200)
        {	tone = _2200;
        	send_tone(tone);
        }
        else
        {	tone = _1200;
        	send_tone(tone);
        }
}

void set_dac(char value)
{	DAC_0 = value & 0x01;
        DAC_1 =( value >> 1 ) & 0x01;
        DAC_2 =( value >> 2 ) & 0x01;
        DAC_3 =( value >> 3 ) & 0x01;
}

void send_tone(char nada)
{	char i;
	char j;
	if(nada == _1200)
    	{	for(j=0; j<2; j++)
                {	for(i=0; i<16; i++)
        		{	set_dac(matrix[i]);
        			delay_us(CONST_1200);
        		}
                }
    	}
    	else
    	{	for(j=0; j<4; j++)
                {	for(i=0; i<16; i++)
                	{	set_dac(matrix[i]);
                        	delay_us(CONST_2400);
                	}
                }
    	}
}

void send_fcs(char infcs)
{	char j=7;
        bit x;
        while(j>0)
        {	x = (infcs >> j) & 0x01;
                if(x)
                {	count_1++;
                        if(count_1==5)    fliptone();
                        send_tone(tone);
                }
                if(!x)  fliptone();
                j--;
        }
}

void calc_fcs(char in)
{	char i;
 	fcs_arr += in;
        x_counter++;
   	if(crc_flag)
        {	for(i=0;i<16;i++) 		// selesaikan hitungan
        	{	if((fcs_arr >> 16)==1) 	fcs_arr ^= CONST_POLYNOM;
          		fcs_arr <<= 1;
          	}
          	fcshi = fcs_arr >> 8; 		// ambil 8 bit paling kiri
       		fcslo = fcs_arr & 0b11111111; 	// ambil 8 bit paling kanan
    	}
     	if((x_counter==17) && ((fcs_arr >> 16)==1))
        {	fcs_arr ^= CONST_POLYNOM;
                x_counter -= 1;
      	}
        if(x_counter==17) 	x_counter -= 1;	// hitung terus
       	fcs_arr <<= 1;
}

void getComma()
{	while(getchar() != ',');
}

void ekstrak_gps()
{	char i;
        while(getchar() != '$');
        // led rx_gps on
	getchar();
        getchar();
        if(getchar() == 'G')
        {	if(getchar() == 'L')
        	{	if(getchar() == 'L')
                	{	getComma();
                        	for(i=0; i<7; i++)	latitude[i] = getchar();
                                getchar();
                                getchar();
                                getComma();
                                latitude[7] = getchar();
                                getComma();
                                for(i=0; i<8; i++)	longitude[i] = getchar();
                                getchar();
                                getchar();
                                getComma();
                                longitude[8] = getchar();
                        }
                }
        }
        // led rx gps off
}

void init_usart(void)
{	UCSRA=0x00;
	UCSRB=0x90;
	UCSRC=0x06;
	UBRRH=0x00;
	UBRRL=0x8F;
}

void clear_usart(void)
{ 	UCSRA=0;
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
	PORTD=0x01;
	DDRD=0x70;

        ACSR=0x80;
        DIDR=0x00;

	GIMSK=0x80;
	MCUCR=0x08;
	EIFR=0x80;

        init_usart();
        L_BUSY = 1;
        delay_ms(250);
        L_BUSY = 0;
        L_STBY = 1;
        delay_ms(700);
        L_STBY = 0;

        #asm("sei")

        while (1)
        {	//ekstrak_gps();
                /*L_BUSY = 1;
                delay_ms(100);
                L_BUSY = 0;
                delay_ms(2000);
                L_STBY = 1;
                delay_ms(100);
                L_STBY = 0;     */
                delay_ms(2000);
                tes_nada_1200();
                tes_nada_2400();
        };
}
