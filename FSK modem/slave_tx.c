/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/16/2011
Author  : Handiko Gesang Anugrah Sejati                           
Company : Teknik Fisika UGM --- LPKTA UGM                          
Comments: 


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 12.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>
#include <delay.h> 

#define data_input PIND.0
#define TX_CONTROL PIND.1
#define PWM_OUT PORTD.2
#define ON 1
#define OFF 0

void main(void)
{       PORTD=0x00;
        DDRD=0x0C;

        ACSR=0x80;
        SFIOR=0x00;

        while (1)
        {       if(TX_CONTROL)
                {       if(data_input)
                        {       PWM_OUT = ON;
                                delay_us(850);
                                PWM_OUT = OFF;
                                delay_us(150);
                                
                        }
                        else if(!data_input)
                        {       PWM_OUT = ON;
                                delay_us(150);
                                PWM_OUT = OFF;
                                delay_us(850);
                        }  
                }
        };
}
