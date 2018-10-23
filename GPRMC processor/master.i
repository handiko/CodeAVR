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
// CodeVisionAVR C Compiler
// (C) 1998-2004 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega32
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADCSR=6;     // for compatibility with older code
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   // 16 bit access
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
/* LCD driver routines

  CodeVisionAVR C Compiler
  (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.

  BEFORE #include -ING THIS FILE YOU
  MUST DECLARE THE I/O ADDRESS OF THE
  DATA REGISTER OF THE PORT AT WHICH
  THE LCD IS CONNECTED!

  EXAMPLE FOR PORTB:

    #asm
        .equ __lcd_port=0x18
    #endasm
    #include <lcd.h>

*/
#pragma used+
void _lcd_ready(void);
void _lcd_write_data(unsigned char data);
// write a byte to the LCD character generator or display RAM
void lcd_write_byte(unsigned char addr, unsigned char data);
// read a byte from the LCD character generator or display RAM
unsigned char lcd_read_byte(unsigned char addr);
// set the LCD display position  x=0..39 y=0..3
void lcd_gotoxy(unsigned char x, unsigned char y);
// clear the LCD
void lcd_clear(void);
void lcd_putchar(char c);
// write the string str located in SRAM to the LCD
void lcd_puts(char *str);
// write the string str located in FLASH to the LCD
void lcd_putsf(char flash *str);
// initialize the LCD controller
unsigned char lcd_init(unsigned char lcd_columns);
#pragma used-
#pragma library lcd.lib
// CodeVisionAVR C Compiler
// (C) 1998-2006 Pavel Haiduc, HP InfoTech S.R.L.
// Prototypes for standard I/O functions
// CodeVisionAVR C Compiler
// (C) 1998-2002 Pavel Haiduc, HP InfoTech S.R.L.
// Variable length argument list macros
typedef char *va_list;
#pragma used+
char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
char *gets(char *str,unsigned int len);
void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);
                                               #pragma used-
#pragma library stdio.lib
// CodeVisionAVR C Compiler
// (C) 1998-2005 Pavel Haiduc, HP InfoTech S.R.L.
// Prototypes for string functions
#pragma used+
char *strcat(char *str1,char *str2);
char *strcatf(char *str1,char flash *str2);
char *strchr(char *str,char c);
signed char strcmp(char *str1,char *str2);
signed char strcmpf(char *str1,char flash *str2);
char *strcpy(char *dest,char *src);
char *strcpyf(char *dest,char flash *src);
unsigned char strcspn(char *str,char *set);
unsigned char strcspnf(char *str,char flash *set);
unsigned int strlenf(char flash *str);
char *strncat(char *str1,char *str2,unsigned char n);
char *strncatf(char *str1,char flash *str2,unsigned char n);
signed char strncmp(char *str1,char *str2,unsigned char n);
signed char strncmpf(char *str1,char flash *str2,unsigned char n);
char *strncpy(char *dest,char *src,unsigned char n);
char *strncpyf(char *dest,char flash *src,unsigned char n);
char *strpbrk(char *str,char *set);
char *strpbrkf(char *str,char flash *set);
signed char strpos(char *str,char c);
char *strrchr(char *str,char c);
char *strrpbrk(char *str,char *set);
char *strrpbrkf(char *str,char flash *set);
signed char strrpos(char *str,char c);
char *strstr(char *str1,char *str2);
char *strstrf(char *str1,char flash *str2);
unsigned char strspn(char *str,char *set);
unsigned char strspnf(char *str,char flash *set);
char *strtok(char *str1,char flash *str2);
 unsigned int strlen(char *str);
void *memccpy(void *dest,void *src,char c,unsigned n);
void *memchr(void *buf,unsigned char c,unsigned n);
signed char memcmp(void *buf1,void *buf2,unsigned n);
signed char memcmpf(void *buf1,void flash *buf2,unsigned n);
void *memcpy(void *dest,void *src,unsigned n);
void *memcpyf(void *dest,void flash *src,unsigned n);
void *memmove(void *dest,void *src,unsigned n);
void *memset(void *buf,unsigned char c,unsigned n);
#pragma used-
#pragma library string.lib
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
