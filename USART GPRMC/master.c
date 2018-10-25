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

char GPRMC[240] =
{       "GPGGL$GPRMC,092750,A,5321.6802,N,00630.3372,W,0.02,31.66,280511,0050,005,A*43$GPRMC,092751,A,5321.6802,N,00630.3371,W,0.06,31.66,280511,0035,0004,A*45$GPRMC,123519,A,4807.0380,N,01131.0000,E,22.4,84.4,230394,003.1,W*6A"
};
char GPRMC_[3][80];
char info[12][15];
char digit[6];
int i,j,k,m,n,marker,flag,counter = 0,info_counter = 0, last_marker; 

void cari_info(int info_marker);

int cek_6_digit_berikut(int cek_marker)
{       for(i=0;i<5;i++)        
        {       digit[i]=GPRMC[1+i+cek_marker];
                last_marker = (1+i+cek_marker);
        }
        if(     (digit[0]=='G') && (digit[1]=='P') && 
                (digit[2]=='R') && (digit[3]=='M') && 
                (digit[4]=='C')        )
                for(i=0;i<5;i++)
                {       lcd_gotoxy(i,0);
                        lcd_putchar(digit[i]);
                }
        delay_ms(1000);
        return last_marker;
}

int waktu(int marker_waktu)
{       int X;
        int Y;
        for(i=0;i<6;i++)
        {       info[counter-1][i]=GPRMC[marker_waktu+i+1];
                last_marker = (marker_waktu+i+1);
                Y = (counter-1);
                X = i;
        }
        
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("waktu");
        delay_ms(1000);
        
        for(k=0;k<(X+1);k++)
        {       lcd_gotoxy(k,Y);
                lcd_putchar(info[Y][X]);
        } 
        delay_ms(4000);
        
        return last_marker;
}

int alarm(int marker_alarm)
{       for(i=0;i<1;i++)
        {       info[counter-1][i]=GPRMC[marker_alarm+i+1];
                last_marker = (marker_alarm+i+1);
        }
        
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("alert");
        delay_ms(1000);
        
        return last_marker;
}        

int lintang(int marker_lintang)
{       int X;
        int Y;
        for(i=0;i<9;i++)
        {       info[counter-1][i]=GPRMC[marker_lintang+i+1];
                Y = (counter-1);
                X = i;
                last_marker = (marker_lintang+i+1);
        } 
        
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("lat mark");
        delay_ms(1000);
        
        for(k=0;k<(X+1);k++)
        {       lcd_gotoxy(k,Y);
                lcd_putchar(info[Y][X]);
        } 
        delay_ms(4000);
        
        return last_marker;
}  

void tampil_data()
{       lcd_clear(); 
        lcd_gotoxy(0,0);
        lcd_putsf("yo");
        for(j=0;j<3;j++)
        {       for(k=0;k<15;k++)
                {       if(info[j][k]!='\0')    {lcd_gotoxy(k,j); lcd_putsf("kena");}
                }
        } 
        delay_ms(4000);
}

void cari_info(int info_marker)
{       info_marker=(info_marker+1);
        last_marker = waktu(info_marker);
        last_marker = alarm(last_marker);
        last_marker = lintang(last_marker);
}

void coba_proses()
{       for(i=0;i<240;i++)
        {       if(GPRMC[i]=='$')
                {       last_marker = cek_6_digit_berikut(i);
                        cari_info(last_marker); 
                        tampil_data();
                }
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
        
        coba_proses();
} 


