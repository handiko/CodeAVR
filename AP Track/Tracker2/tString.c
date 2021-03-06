/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/21/2012
Author  : 
Company : 
Comments: 


Chip type               : ATtiny2313
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Tiny
External RAM size       : 0
Data Stack size         : 32
*****************************************************/

#include <tiny2313.h>
#include <delay.h>

#define _1200		0
#define _2200		1
#define CONST_1200      42
#define CONST_2200      28

#define TX_NOW  PIND.3
#define PTT     PORTB.3 
#define DAC_0   PORTB.4
#define DAC_1   PORTB.5
#define DAC_2   PORTB.6
#define DAC_3   PORTB.7

#define L_TX	PORTD.4

flash char flag = 0x7E;
eeprom char string[98] = 
{ 	('A'<<1),('P'<<1),('U'<<1),('2'<<1),('5'<<1),('N'<<1),0b11100000,
	('Y'<<1),('D'<<1),('2'<<1),('X'<<1),('B'<<1),('C'<<1),('1'<<1),
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1),
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('1'<<1),(' '<<1),0b01100011,
        
        0x03,0xF0,0x79,
        
        ('0'<<1),('7'<<1),('4'<<1),('5'<<1),('.'<<1),('5'<<1),('8'<<1),('S'<<1),
        ('/'<<1),
        ('1'<<1),('1'<<1),('0'<<1),('2'<<1),('2'<<1),('.'<<1),('2'<<1),('2'<<1),('E'<<1),
        
        ('$'<<1),
        
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),('-'<<1),('2'<<1),(' '<<1),
        ('E'<<1),('x'<<1),('p'<<1),('e'<<1),('r'<<1),('i'<<1),('m'<<1),('e'<<1),('n'<<1),('t'<<1),('a'<<1),('l'<<1),(' '<<1),
        ('V'<<1),('H'<<1),('F'<<1),(' '<<1),
        ('D'<<1),('i'<<1),('g'<<1),('i'<<1),('p'<<1),('e'<<1),('a'<<1),('t'<<1),('e'<<1),('r'<<1),(' '<<1),
        ('{'<<1),('U'<<1),('I'<<1),('V'<<1),('3'<<1),('2'<<1),('}'<<1),
        
        0b00110100,
        0b10101000,
        0b00100111,
        0b11111010,
        0b11111001
};
bit tone = _1200;
flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};

void send_data(void);
void fliptone(void);
void set_dac(char value);
void send_tone(char nada);

void tes_nada_1200(void)
{	char i;
	int j; 
	for(j=0; j<1000; j++) 
    	{	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
        		delay_us(CONST_1200);
        	}
    	}  
}

void tes_nada_2400(void)
{	char i;
	int j;
        for(j=0; j<2000; j++)
        {	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
                	delay_us(CONST_2200);
                }
        }
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{	L_TX = 1;
	delay_ms(200);
        PTT = 1;
        delay_ms(1000);
        send_data();
        PTT = 0;
        L_TX = 0;
        
        delay_ms(1000);
        tes_nada_1200();
        tes_nada_2400();	
} 

void send_data(void) 
{	char i;
	char j;
        bit x; 
        for(i=0; i<35; i++)
        {	for(j=0; j<8; j++)
        	{	x = (flag >> j) & 0x01;
                	if(x) send_tone(tone);
                        else fliptone();
                }	
        }
	for(i=0; i<98; i++)
        {	for(j=0; j<8; j++)
        	{	x = (string[i] >> j) & 0x01;
                	if(x) send_tone(tone);
                        else fliptone();
                }	
        }
        for(i=0; i<12; i++)
        {	for(j=0; j<8; j++)
        	{	x = (flag >> j) & 0x01;
                	if(x) send_tone(tone);
                        else fliptone();
                }	
        }	
}

void fliptone(void) 
{	if(tone == _1200)
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
	if(nada == _1200) 
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
                for(i=0; i<15; i++)
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
	PORTD=0x01;
	DDRD=0x70;
        
        ACSR=0x80;
        DIDR=0x00; 

	GIMSK=0x80;
	MCUCR=0x08;
	EIFR=0x80;   
        
        #asm("sei")

	while (1)
      	{
      	}
}
