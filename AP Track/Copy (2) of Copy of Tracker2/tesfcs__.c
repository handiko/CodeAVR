/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : APRS BEACON
Version : PROTOCOL & HARDWARE TEST
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
		       G(x) = 0b10001000000100001

*****************************************************/

#include <tiny2313.h>
#include <delay.h>

#define _1200		0
#define _2200		1
#define CONST_1200      46
#define CONST_2200      22

#define TX_NOW  PIND.3
#define PTT     PORTB.3
#define DAC_0   PORTB.7
#define DAC_1   PORTB.6
#define DAC_2   PORTB.5
#define DAC_3   PORTB.4

#define L_BUSY	PORTD.4
#define L_STBY  PORTD.5

void set_dac(char value);
void set_nada(char i_nada);
void tes_nada_1200(void);
void tes_nada_2200(void);
void kirim_karakter(unsigned char input);
void kirim_paket(void);
void ubah_nada(void);
void hitung_fcs(char in_fcs);
void kirim_crc(void);

flash char flag = 0x7E;
flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
flash char data[74] =
{ 	('A'<<1),('P'<<1),('Z'<<1),('T'<<1),('2'<<1),('3'<<1),0b11100000,
	('Y'<<1),('D'<<1),('2'<<1),('X'<<1),('A'<<1),('C'<<1),('9'<<1),
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('1'<<1),(' '<<1),('1'<<1),
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1,
        0x03,0xf0, // index 29
        ':',':',':',' ','H','A','N','D','I','K','O',' ','(','3','6','7','0','9',')',' ',
        'M','O','B','I','L','E',' ','A','P','R','S',' ','T','R','A','C','K','E','R',' ',':',':',':',0x0D
};
char koordinat[20] =
{       '=','0','7','4','5','.','8','5','S','H','1','1','0','2','2','.','5','2','E','&'
};
bit nada = _1200;
bit flag_s;
char n = 0;
static char bit_stuff = 0;
unsigned short crc;

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

void tes_nada_2200(void)
{	char i;
	int j;
        L_STBY = 1;
        for(j=0; j<2000; j++)
        {	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
                	delay_us(CONST_2200);
                }
        }
        L_STBY = 0;
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{	delay_ms(250);
        kirim_paket();
}

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{	n++;
	if(n==5)
        {	L_STBY = 0;
        	L_BUSY = 0;
                n=0;
                kirim_paket();
        }
        TCNT1H=0x02;
	TCNT1L=0xE0;
}

void kirim_paket(void)
{	char i;

	crc = 0xFFFF;
	PTT = 1;

        flag_s=1;
        for(i=0;i<100;i++)	kirim_karakter(flag);
        flag_s=0;
        bit_stuff = 0;
        for(i=0;i<30;i++)	kirim_karakter(data[i]);
        for(i=0;i<20;i++)	kirim_karakter(koordinat[i]);
        for(i=30;i<74;i++)	kirim_karakter(data[i]);
        kirim_crc();
        flag_s=1;
        for(i=0;i<5;i++)	kirim_karakter(flag);
        flag_s=0;

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
	bit r_bit;

	for(i=0;i<8;i++)
        {	r_bit = input & 0x01;
                if(flag_s)	{bit_stuff = 0;}
                else 	{hitung_fcs(r_bit);}
                if(!r_bit)
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
                input >>= 1;
        }
}

void hitung_fcs(char in_fcs)
{  	static unsigned short xor;

	xor = crc ^ in_fcs;
	crc >>= 1;
        if(xor & 0x01)	{crc ^= 0x8408;}
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
	WDTCR=0x38;
	WDTCR=0x28;
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

        while (1)
        {       delay_ms(2000);
                tes_nada_1200();
                tes_nada_2200();
        };
}
