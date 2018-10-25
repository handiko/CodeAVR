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
char kalimat[7][80];

char kalimat2[500] =
{       "Serial With A Baud Data Rate Of 4,800bps.  Note A USB Interface Port Cannot Support This Standard!  If GPS-Enabled Mapping Programs Are To Be Used, The Best Choice Is To Obtain A Serial Interfaced GPS System.  A GPS System With A Serial Port And NMEA Support Will Provide The Most Universally Acceptable System.  Out Of All The Manufactures And Brand Marketed Products,"
};

void queue();
void try_transmit(int INDEX);
void isPrepared();
void transmit(int TX_INDEX);
int success_detect();
int display(int DISP_INDEX);
void string_processor();

void string_processor()
{       for(i=0;i<500;i++)
        {       kalimat[0][i]=kalimat2[i];
                if(i>79)
                {       kalimat[1][i-80]=kalimat2[i];
                }
                if(i<159)
                {       kalimat[2][i-160]=kalimat2[i];
                }
                if(i<239)
                {       kalimat[3][i-240]=kalimat2[i];
                }
                if(i<319)
                {       kalimat[4][i-320]=kalimat2[i];
                }
                if(i<399)
                {       kalimat[5][i-400]=kalimat2[i];
                }
                if(i<479)
                {       kalimat[6][i-480]=kalimat2[i];
                } 
        }
}

void queue()
{       lcd_gotoxy(0,0);
        lcd_putsf("mengirim pesan...");
        for(z=0;z<7;z++)
        {       try_transmit(z);
        }
}

void isPrepared()
{       putchar('P');
        if(getchar()=='P');
}

void transmit(int TX_INDEX)
{       j = 0;
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
        
        string_processor();
        queue();
}    

