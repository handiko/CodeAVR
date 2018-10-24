

#ifndef _AX25_MODULE_INCLUDED_
#define _AX25_MODULE_INCLUDED_

#include <model_a_io.h>

#define _1200		0
#define _2200		1

void kirim_crc(void);
void kirim_karakter(unsigned char input);
void hitung_crc(char in_crc);
void ubah_nada(void);
void set_nada(char i_nada);

bit nada;
static char bit_stuff;
unsigned short crc;

void kirim_crc(void)
{
	static unsigned char crc_lo;
	static unsigned char crc_hi;

        crc_lo = crc ^ 0xFF;
	crc_hi = (crc >> 8) ^ 0xFF;
	kirim_karakter(crc_lo);
	kirim_karakter(crc_hi);
}

void kirim_karakter(unsigned char input)
{
	char i;
	bit in_bit;

        for(i=0;i<8;i++)
        {
        	in_bit = (input >> i) & 0x01;
		if(input==0x7E)	{bit_stuff = 0;}
		else		{hitung_crc(in_bit);}

		if(!in_bit)
                {
                	ubah_nada();
			bit_stuff = 0;
                }
                else
                {
                	set_nada(nada);
			bit_stuff++;
			if(bit_stuff==5)
                        {
                        	ubah_nada();
                                bit_stuff = 0;
                        }
                }
        }
}

void hitung_crc(char in_crc)
{
	static unsigned short xor_in;
	xor_in = crc ^ in_crc;
	crc >>= 1;
	if(xor_in & 0x01)	crc ^= 0x8408;
}

void ubah_nada(void)
{
	nada = ~nada;
        set_nada(nada);
}

void set_nada(char i_nada)
{
	if(i_nada == _1200)
    	{
        	delay_us(417);
        	AFOUT = 1;
        	delay_us(417);
        	AFOUT = 0;
    	}
        else
    	{
        	delay_us(208);
        	AFOUT = 1;
        	delay_us(209);
        	AFOUT = 0;
                delay_us(208);
        	AFOUT = 1;
        	delay_us(209);
        	AFOUT = 0;
    	}
}

#endif