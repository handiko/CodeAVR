/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 10/16/2011
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

#define out PORTD.0

int pwm = 0;
int xcount = 0;

void start();
void value_1();
void value_0();
void mark();

/*interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{       TCNT0=0xF7;
        for(xcount=0;xcount<256;xcount++)
        {       if(xcount<=pwm) out=1;
                else    out=0;
        }
        xcount=0;
}*/

void start()
{       value_0();
}

void value_1()
{       OCR1AL=250;
        delay_ms(1);
}

void value_0()
{       OCR1AL=5;
        delay_ms(1);
}

void mark()
{       OCR1AL=250;
        delay_ms(10);
}

void main(void)
{       PORTD=0b00000000;
        DDRD =0b11111111;

        TCCR1A=0xA1;
        TCCR1B=0x02;

        TCCR0=0x01;
        TCNT0=0x00;
        OCR0=0x00;

        TIMSK=0x01;

        ACSR=0x80;
        SFIOR=0x00;

        //#asm("sei")

        while (1)
        {       mark();
                start();
                value_1();
                value_0();
                value_1();
                value_1();
                value_1();
                value_0();
                value_0();
                value_1();
                //mark();
        };
}
