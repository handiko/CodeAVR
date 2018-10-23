/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 10/3/2011
Author  : F4CG
Company : F4CG
Comments:


Chip type           : ATmega32
Program type        : Application
Clock frequency     : 12.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 512
*****************************************************/

#include <mega32ndelay.h>
#include <lcd.h>
#include <stdio.h>
#include <string.h>

#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm

int last_marker;
int i;
int digit[5];
char info[3][15];
char GPRMC[1000] =
{       "GPGGL$GPRMC,001430.0030,A,3907.3885,N,12102.4767,W,000.0,175.3,220403,015.4,E*71$GPIMC,666557.916,A,5058.7456,N,00647.0515,E,0.00,82.33,220503,,*39$GPRMC,230611.016,V,3907.3813,N,12102.4635,W,0.14,136.40,041002,,*04$GPRMC,184050.84,A,3907.3839,N,12102.4772,W,00.0,000.0,080301,15,E*54$GPRMC,092750,A,5321.6802,N,00630.3372,W,0.02,31.66,280511,0050,005,A*43$GPRMC,220735,A,0403.1433,N,00630.3371,W,0.06,31.66,280511,0035,0004,A*45$GPRMC,123519,A,4807.0380,N,01131.0000,E,22.4,84.4,230394,003.1,W*6A$GPRMC,184429,A,1843.0120,S,293713.2043,W,23.5,61.9,190959,002.9,W*5A$GPRMC,50401,V,259.8339,N,071310.3922,W,10.3,139.7,291003,,*10"
};

int cari_koma(int marker_koma)
{       marker_koma = (marker_koma + 1);
        if(GPRMC[marker_koma]==',')
        last_marker = marker_koma;
        else
        {       for(i=marker_koma;;i++)
                {       last_marker = i;
                        if(GPRMC[i]==',')
                        break;
                }
        }
        return last_marker;
}

int waktu(int marker_waktu)
{       marker_waktu = (marker_waktu + 1);
        for(i=marker_waktu;;i++)
        {       if(GPRMC[i]==',')
                break;
                info[0][i-marker_waktu]=GPRMC[i];
                lcd_gotoxy(i-marker_waktu,1);
                lcd_putchar(info[0][i-marker_waktu]);
                last_marker=i;
        }
        delay_ms(1000);
        return last_marker;
}

int alarm(int marker_alarm)
{       marker_alarm = (marker_alarm + 1);
        info[1][0]=GPRMC[marker_alarm];
        lcd_gotoxy(0,2);
        lcd_putchar(info[1][0]);
        delay_ms(1000);
        last_marker=marker_alarm;
        return last_marker;
}

int lintang(int marker_lintang)
{       marker_lintang = (marker_lintang + 1);
        for(i=marker_lintang;;i++)
        {       if(GPRMC[i]==',')
                break;
                info[2][i-marker_lintang]=GPRMC[i];
                lcd_gotoxy(i-marker_lintang,3);
                lcd_putchar(info[2][i-marker_lintang]);
                last_marker=i;
        }
        delay_ms(1000);
        lcd_clear();
        return last_marker;
}

void tampil_GPRMC(int loc, int param)
{       digit[param]=GPRMC[param];
        lcd_gotoxy(loc,0);
        lcd_putchar(digit[param]);
}

void algoritma()
{       top:
        for(i=0;i<strlen(GPRMC);i++)
        {       if(GPRMC[i]=='$')
                {
                if(GPRMC[i+1]=='G')
                {
                if(GPRMC[i+2]=='P')
                {
                if(GPRMC[i+3]=='R')
                {
                if(GPRMC[i+4]=='M')
                {
                if(GPRMC[i+5]=='C')
                {	i=i+5;
                        last_marker = i;
                        last_marker = cari_koma(last_marker);
                        last_marker = waktu(last_marker);
                        last_marker = cari_koma(last_marker);
                        last_marker = alarm(last_marker);
                        last_marker = cari_koma(last_marker);
                        last_marker = lintang(last_marker);
                        last_marker = cari_koma(last_marker);
                }}}}}}
        }
        goto top;
}

void main(void)
{       PORTA=0x00;
        DDRA=0xFF;
        ACSR=0x80;
        SFIOR=0x00;

        lcd_init(20);

        algoritma();
}
