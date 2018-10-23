/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Standard
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 3/18/2011
Author  : F4CG
Company : F4CG
Comments:


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 12.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#include <lcd.h>
#include <delay.h>
#include <stdio.h>

#define ADC_VREF_TYPE 0x00
#define IRed PORTB.0

#asm
   .equ __lcd_port=0x12 ;PORTD
#endasm

char lcd[16];
char lcd_buffer[33];
unsigned int sensor;
unsigned int read_adc(unsigned char adc_input);
unsigned int baca_warna();
void tampilan_awal();
void switching_IRed();
void tampil_adc();

void main(void)
{
        PORTB=0x00;
        DDRB=0xFF;

        PORTC=0xFF;
        DDRC=0x00;

        PORTD=0x00;
        DDRD=0xFF;

        TCCR0=0x00;
        TCNT0=0x00;

        TCCR1A=0x00;
        TCCR1B=0x00;
        TCNT1H=0x00;
        TCNT1L=0x00;
        ICR1H=0x00;
        ICR1L=0x00;
        OCR1AH=0x00;
        OCR1AL=0x00;
        OCR1BH=0x00;
        OCR1BL=0x00;

        ASSR=0x00;
        TCCR2=0x00;
        TCNT2=0x00;
        OCR2=0x00;

        MCUCR=0x00;

        TIMSK=0x00;

        ACSR=0x80;
        SFIOR=0x00;

        ADMUX=ADC_VREF_TYPE & 0xff;
        ADCSRA=0x84;

        lcd_init(16);

        tampilan_awal();

        while (1)
        {
                switching_IRed();
                baca_warna();
                tampil_adc();
        };
}

unsigned int read_adc(unsigned char adc_input)
{
        ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
        ADCSRA|=0x40;
        while ((ADCSRA & 0x10)==0);
                ADCSRA|=0x10;
        return ADCW;
}

void tampilan_awal()
{
        lcd_clear();            // 0123456789ABCDEF
        lcd_gotoxy(0,0);lcd_putsf(" SELAMAT DATANG ");
        lcd_gotoxy(0,1);lcd_putsf(" DIMANA AJA KEK ");
        delay_ms(300);
        lcd_clear();
}

void switching_IRed()
{
        int i;
        for(i=0;i<4;i++)
        {
                IRed = 0;
                delay_us(25);
                IRed = 1;
                delay_us(25);
        }
}

unsigned int baca_warna()
{
        sensor = read_adc(0);
                                                                         //  0123456789abcdef
        if((sensor<100)&&(sensor>104))          {sensor = sensor; lcd_putsf("    MERAH      ");}
        else if((sensor<104)&&(sensor>108))     {sensor = sensor; lcd_putsf("    KUNING     ");}
        else if((sensor<108)&&(sensor>112))     {sensor = sensor; lcd_putsf("    HIJAU      ");}
        else if((sensor<112)&&(sensor>116))     {sensor = sensor; lcd_putsf("    CYAN       ");}
        else if((sensor<116)&&(sensor>120))     {sensor = sensor; lcd_putsf("    BIRU       ");}
        return sensor;
}

void tampil_adc()
{
        sensor = read_adc(0);
                  // 0123456789abcdef
        sprintf(lcd," %d ",sensor);
        lcd_puts(lcd_buffer);
        delay_ms(10);
        lcd_clear();
}
