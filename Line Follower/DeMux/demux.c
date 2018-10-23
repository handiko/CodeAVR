/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 12/9/2011
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

#define tom0  PIND.0
#define tom1  PIND.1
#define tom2  PIND.2
#define tom3  PIND.3
#define tom4  PIND.4
#define tom5  PIND.5
#define tom6  PIND.6
#define tom7  PIND.7 

int i;

void pilih_segment(int seg_ke)
{       
        for(i=0;i<8;i++)
        {       
                if(seg_ke==i)
                {       
                        PORTA=seg_ke;
                        PORTA=PORTA<<4;             
                }
        }
}

void tampilkan_nilai(int nilai)
{       
        PORTA=PORTA|nilai;
}   

void baca_tombol()
{       
        if(!tom0)
        {       
                delay_ms(200);
                pilih_segment(1);
                tampilkan_nilai(1);
        }
        if(!tom1)
        {       
                delay_ms(200);
                pilih_segment(2);
                tampilkan_nilai(2);
        }
        if(!tom2)
        {      
                delay_ms(200);
                pilih_segment(3);
                tampilkan_nilai(3);
        }
        if(!tom3)
        {       
                delay_ms(200);
                pilih_segment(4);
                tampilkan_nilai(4);
        }
        if(!tom4)
        {       
                delay_ms(200);
                pilih_segment(5);
                tampilkan_nilai(5);
        }
        if(!tom5)
        {       
                delay_ms(200);
                pilih_segment(6);
                tampilkan_nilai(6);
        }
        if(!tom6)
        {       
                delay_ms(200);
                pilih_segment(7);
                tampilkan_nilai(7);
        }
        if(!tom7)
        {       
                delay_ms(200);
                pilih_segment(8);
                tampilkan_nilai(8);
        }
}

void main(void)
{       PORTA=0x00;  // output segment dan selector
        DDRA=0xFF;

        PORTB=0x00;
        DDRB=0x00;

        PORTC=0x00;
        DDRC=0x00;

        PORTD=0xFF;  // input tombol
        DDRD=0x00;

        ACSR=0x80;
        SFIOR=0x00;

        while (1)
        {
                baca_tombol();
        };
}
