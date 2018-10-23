/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/8/2011
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 12.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega16.h>
#include <delay.h> 

#define         t0      PIND.0
#define         t1      PIND.1
#define         t2      PIND.2
#define         t3      PIND.3
#define         t4      PIND.4
#define         t5      PIND.5
#define         t6      PIND.6
#define         t7      PIND.7

#define         l0      PORTC.0
#define         l1      PORTC.1
#define         l2      PORTC.2
#define         l3      PORTC.3
#define         l4      PORTC.4
#define         l5      PORTC.5
#define         l6      PORTC.6
#define         l7      PORTC.7

#define         on      1
#define         off     0
#define         ON      1
#define         OFF     0 

void baca_tombol()
{       
        if(!t0) l0=on; 
        if(!t1) l1=on;
        if(!t2) l2=on;
        if(!t3) l3=on;
        if(!t4) l4=on;
        if(!t5) l5=on;
        if(!t6) l6=on;
        if(!t7) l7=on;
}

void main(void)
{
        PORTA=0x00;
        DDRA=0x00;

        PORTB=0x00;
        DDRB=0x00;

        PORTC=0x00;
        DDRC=0xFF;

        PORTD=0x00;
        DDRD=0x00;

        ACSR=0x80; 
        
        l0 = on;
        delay_ms(1000);
        l0 = off;

        while (1)
        {
                baca_tombol();
        };
}
