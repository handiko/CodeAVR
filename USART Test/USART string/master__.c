/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 10/2/2011
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
#include <usartMEGA32.h>
#include <ctype.h>
#include <string.h>

#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm

#define n 20

int i,j,k,m,z;
char kalimat[3][80] =
//       0123456789abcdefghij0123456789abcdefghij0123456789abcdefghij0123456789abcdefghij
{       "Pesan pertama : Ini adalah uji coba pengiriman string array melalui USART@",
        "Pesan kedua : Jika berhasil menerima ketiga string, maka ini berhasil@",
        "Pesan ketiga : Ini bisa digunakan dalam distribusi perintah untuk multi mikro@"
};

void queue();
void try_transmit(int INDEX);
void isPrepared();
void transmit(int TX_INDEX);
int success_detect();
int display(int DISP_INDEX);

void queue()
{       start:
        for(z=0;z<3;z++)
        {       try_transmit(z);
                delay_ms(1000);
        }
        goto start;
}

void isPrepared()
{       putchar('P');
        if(getchar()=='P');
}

void transmit(int TX_INDEX)
{       if(!display(TX_INDEX))
        {       lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf("fail to display !");
        }
        j = 0;
        do
        {       if(kalimat[TX_INDEX][j]=='\0')  {goto end;}
                putchar(kalimat[TX_INDEX][j]);
                j++;
        }while(1);
        end:
}

int success_detect()
{       if(getchar()=='@')
        return 1;
        else return 0;
}

int display(int DISP_INDEX)
{       k = 0;
        m = 0;
        lcd_clear();
        for(i=0;i<80;i++)
        {       if(kalimat[DISP_INDEX][i]=='@')  goto quit;
                lcd_gotoxy(i,m);
                if(i>19)        {m=1;   k=i-20; lcd_gotoxy(k,m);}
                if(i>39)        {m=2;   k=i-40; lcd_gotoxy(k,m);}
                if(i>59)        {m=3;   k=i-60; lcd_gotoxy(k,m);}
                lcd_putchar(kalimat[DISP_INDEX][i]);
        }
        quit:
        return 1;
}

void try_transmit(int INDEX)
{       isPrepared();
        transmit(INDEX);
        if(success_detect())
        {       delay_ms(1000);
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf("Berhasil terkirim !");
        }
}

void main()
{       PORTA=0x00;
        DDRA=0xFF;

        ACSR=0x80;
        SFIOR=0x00;

        lcd_init(20);
        init_usart_port();

        #asm("sei")

        queue();
}

