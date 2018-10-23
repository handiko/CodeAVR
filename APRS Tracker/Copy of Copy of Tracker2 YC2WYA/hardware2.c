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
#include <stdio.h>

#define _1200		0
#define _2200		1
#define CONST_1200      46
#define CONST_2400      22

#define TX_NOW  PIND.3
#define PTT     PORTB.3 
#define DAC_0   PORTB.7
#define DAC_1   PORTB.6
#define DAC_2   PORTB.5
#define DAC_3   PORTB.4

#define L_BUSY	PORTD.5
#define L_STBY  PORTD.4

void set_dac(char value);
void send_tone(char nada);

flash char flag = 0x7E;
flash char data[85] =  // eeprom char data[93] = // ????? eepromnya rusak
{ 	('A'<<1),('P'<<1),('U'<<1),('2'<<1),('5'<<1),('N'<<1),0xE0,
	('Y'<<1),('D'<<1),('2'<<1),('H'<<1),('A'<<1),('N'<<1),('9'<<1), 
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1,
	        
        0x03, 0xF0,
        
        //'=',
        0b01111001,
        ('0'<<1),('7'<<1),('4'<<1),('5'<<1),('.'<<1),('5'<<1),('8'<<1),('S'<<1),
        ('/'<<1),
        ('1'<<1),('1'<<1),('0'<<1),('2'<<1),('2'<<1),('.'<<1),('2'<<1),('2'<<1),('E'<<1),
        ('['<<1),
        
        (':'<<1),(':'<<1),(':'<<1),(' '<<1),('H'<<1),('A'<<1),('N'<<1),('D'<<1),('I'<<1),('K'<<1),('O'<<1),(' '<<1),
        ('('<<1),('3'<<1),('6'<<1),('7'<<1),('0'<<1),('9'<<1),(')'<<1),(' '<<1),
        ('M'<<1),('O'<<1),('B'<<1),('I'<<1),('L'<<1),('E'<<1),(' '<<1),
        ('T'<<1),('R'<<1),('A'<<1),('C'<<1),('K'<<1),('E'<<1),('R'<<1),(' '<<1),(':'<<1),(':'<<1),(':'<<1),
        
        0b00011010,
        0b10011010,
        0b11110110,
        0b11111110
};
char n = 0;
bit tone = _1200;
flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};	// pemetaan tegangan sinusoidal

void tes_nada_1200(void)
{	char i;
	int j; 
        L_BUSY = 1;
	for(j=0; j<1200; j++) 
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
        L_STBY = 1;
        for(j=0; j<2200; j++)
        {	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
                	delay_us(CONST_2400);
                } 
        }
        L_STBY = 0;
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

void send_data(char input) 
{	char i;
        bit x;
        for(i=0;i<8;i++) 
        {	x = (input >> i) & 0x01;
                if(x) send_tone(tone);
                else  fliptone();
        }
}   

char k;
void protocol2(void)
{ 	PTT = 1; 
	delay_ms(500); 
        for(k=0;k<50;k++)	send_data(flag); 
        for(k=0;k<85;k++)	send_data(data[k]);
        for(k=0;k<25;k++)	send_data(flag);  
        PTT = 0;
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{	L_STBY = 0; 
        L_BUSY = 0;
        delay_ms(250); 
        protocol2();
} 

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{	n++;
	if(n == 5)
        {	n = 0;
        	L_STBY = 0; 
        	L_BUSY = 0;
        	protocol2();
        } 
        TCNT1H=0x02;
	TCNT1L=0xE0;
}      

void set_dac(char value) 
{	DAC_0 = value & 0x01;   	// LSB
        DAC_1 =( value >> 1 ) & 0x01;
        DAC_2 =( value >> 2 ) & 0x01;
        DAC_3 =( value >> 3 ) & 0x01;	// MSB
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
                	delay_us(CONST_2400);
                } 
                for(i=0; i<13; i++)
                {	set_dac(matrix[i]);
                	delay_us(CONST_2400);
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
            
        // 39, 29, = 8 detik    
        // 38, 28, = 4 detik
        // 1F, 0F, = 2 detik
        // 1E, 0E, = 1 detik 
        
#pragma optsize-
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
                tes_nada_2400();
        };
}