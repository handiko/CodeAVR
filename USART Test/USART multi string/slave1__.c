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

char kalimat[7][80];
int i,j,k;

int receive(int RX_INDEX);
int send_confirm();
void try_receive(int INDEX);
void display(int DISP_INDEX);
void queue();
void isPrepared();

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

void queue()
{       for(k=0;k<7;k++)
        {       try_receive(k);
        }

        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("finish receiving");
        delay_ms(500);

        for(k=0;k<7;k++)
        {       display(k);
        }

        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("algorithm selesai");
}

void isPrepared()
{       if(getchar()=='P')
        putchar('P');
}

int receive(int RX_INDEX)
{       for(i=0;i<80;i++)
        {       kalimat[RX_INDEX][i]=getchar();
                if(kalimat[RX_INDEX][i]=='@')   goto rx_complete;
        }
        rx_complete:
        return 1;
}

void display(int DISP_INDEX)
{       lcd_clear();
        j=0;
        for(i=0;i<80;i++)
        {       if(i<20)        {lcd_gotoxy(i,0);}
                if(i>19)        {lcd_gotoxy((i-20),1);}
                if(i>39)        {lcd_gotoxy((i-40),2);}
                if(i>59)        {lcd_gotoxy((i-60),3);}
                if(kalimat[DISP_INDEX][i]=='@') goto jump;
                lcd_putchar(kalimat[DISP_INDEX][i]);
        }
        jump:
        delay_ms(1000);
}

int send_confirm()
{       putchar('@');
        return 1;
}

void try_receive(int INDEX)
{       isPrepared();
        receive(INDEX);
        send_confirm();
}

