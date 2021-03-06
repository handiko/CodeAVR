/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/28/2012
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATtiny2313
Clock frequency     : 11.059200 MHz
Memory model        : Tiny
External SRAM size  : 0
Data Stack size     : 32
*****************************************************/

#include <tiny2313.h>              
#include <delay.h>

//#define _1200		0
//#define _2200		1
#define CONST_1200      46
#define CONST_2400      20  			// 22 = 2200Hz, 20 = 2400Hz, 21 = 2320Hz

#define TX_NOW  PIND.3
#define PTT     PORTB.3 
#define DAC_0   PORTB.7
#define DAC_1   PORTB.6
#define DAC_2   PORTB.5
#define DAC_3   PORTB.4

#define L_BUSY	PORTD.5
#define L_STBY  PORTD.4

void send_data(char input);
void set_dac(char value);
void send_tone(char nada);
flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};	// pemetaan tegangan sinusoidal
int timer=0;
char i=0;
char j=0;
bit nada = 0;

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
        for(j=0; j<2400; j++)
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
}       

void set_dac(char value) 
{	DAC_0 = value & 0x01;   	// LSB
        DAC_1 =( value >> 1 ) & 0x01;
        DAC_2 =( value >> 2 ) & 0x01;
        DAC_3 =( value >> 3 ) & 0x01;	// MSB
}

/*void send_tone(char nada) 
{	char i;
	char j;
	if(nada == _1200) 
    	{	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
        		delay_us(CONST_1200);
        	} 
    	} 
    	else
    	{	for(j=0; j<2; j++)
                {	for(i=0; i<16; i++)
                	{	set_dac(matrix[i]);
                        	delay_us(CONST_2400);
                	}
                }
    	}
}  */


/*interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{	timer++; 
        if( ((timer%52)==0) || ((timer%28)==0) )
        {	if(nada==0)
        	{  	set_dac(matrix[i]);
                	i++;	
                        if(i==15) i=0;
        	} 
                else                                              	
        	{  	set_dac(matrix[j]);
                	j++;	
                        if(j==15) j=0;
        	}
        }
        
        if(timer==832)	{timer=0; i=0; j=0;} 
        TCNT0=0xF5;
} */

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

	/*TCCR0A=0x00;
	TCCR0B=0x01;
	TCNT0=0xF5;
	OCR0A=0x00;
	OCR0B=0x00;*/

	GIMSK=0x80;
	MCUCR=0x08;
	EIFR=0x80;  

	//TIMSK=0x02;

	ACSR=0x80;

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
      	{  	tes_nada=0;
        	delay_ms(2000);
                nada=1;
                delay_ms(2000);
      	};
}
