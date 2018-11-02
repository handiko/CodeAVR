/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Scanning Display 7 Segment
Version : 
Date    : 12/12/2011
Author  : Handiko Gesang 
Company : LPKTA 11
Comments: 
PORTC as DATA
PORTD as DISPLAY SELECTOR


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <delay.h>

int i;
char b_p[8] = {
        0b11111110,
        0b11111101,
        0b11111011,
        0b11110111,
        0b11101111,
        0b11011111,
        0b10111111,
        0b01111111
};

void tampil_angka(int angka)
{
        if(angka == 1)
        {
                PORTA = 0b00000001;
        }
        if(angka == 2)
        {
                PORTA = 0b00000100;
        }
        if(angka == 3)
        {
                PORTA = 0b00001000;
        }
        if(angka == 4)
        {
                PORTA = 0b00010000;
        }
        if(angka == 5)
        {
                PORTA = 0b00100000;
        }
        if(angka == 6)
        {
                PORTA = 0b01000000;
        }
        if(angka == 7)
        {
                PORTA = 0b10000000;
        } 
        if(angka == 8)
        {
                PORTA = 0b11111111;
        }
}

void pilih_bit(int b)
{
        PORTD = b_p[b-1];
}

void tampilkan()
{       
        for(i=1; i<9; i++)
        {
                tampil_angka(i);
                pilih_bit(i);
        }
}

void main(void)
{
        PORTA=0x00;
        DDRA=0xFF;

        PORTB=0x00;
        DDRB=0x00;

        PORTC=0x00;
        DDRC=0xFF;

        PORTD=0x00;
        DDRD=0xFF;

        ACSR=0x80;
        SFIOR=0x00;

        while (1)
        {   
                tampilkan();
        }
}
