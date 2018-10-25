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
bit rx_buffer_overflow;
char rx_buffer[8 ];
char tx_buffer[8   ];
        unsigned char rx_wr_index,rx_rd_index,rx_counter;
                interrupt [14] void usart_rx_isr(void)
{
        char status,data;
        status=UCSRA;
        data=UDR;
        if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
        {
                rx_buffer[rx_wr_index]=data;
                if (++rx_wr_index == 8 ) rx_wr_index=0;
                if (++rx_counter == 8 )
                {
                        rx_counter=0;
                        rx_buffer_overflow=1;
                };
        };
}
                #pragma used+
                char getchar(void)
        {
                char data;
                while (rx_counter==0);
                data=rx_buffer[rx_rd_index];
                if (++rx_rd_index == 8 ) rx_rd_index=0;
                                #asm("cli")
                --rx_counter;
                #asm("sei")
                return data;
        }
        #pragma used-
        unsigned char tx_wr_index,tx_rd_index,tx_counter;       
                interrupt [16] void usart_tx_isr(void)
{
        if (tx_counter)
        {
                --tx_counter;
                UDR=tx_buffer[tx_rd_index];
                if (++tx_rd_index == 8   ) tx_rd_index=0;
        };
}
                #pragma used+
        void putchar(char c)
        {
                while (tx_counter == 8   );
                #asm("cli")
                if (tx_counter || ((UCSRA & (1<<5))==0))
                {
                        tx_buffer[tx_wr_index]=c;
                        if (++tx_wr_index == 8   ) tx_wr_index=0;
                ++tx_counter;
                }
                else
                UDR=c;
                #asm("sei")
        }
        #pragma used-
void init_usart_port()
{      
        PORTD=0x01;
        DDRD=0x02;
        UCSRA=0x00;
        UCSRB=0xD8;
        UCSRC=0x86;
        UBRRH=0x00;
        UBRRL=0x4D;
}
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
// Prototypes for character type functions
#pragma used+
unsigned char isalnum(char c);
unsigned char isalpha(char c);
unsigned char isascii(char c);
unsigned char iscntrl(char c);
unsigned char isdigit(char c);
unsigned char islower(char c);
unsigned char isprint(char c);
unsigned char ispunct(char c);
unsigned char isspace(char c);
unsigned char isupper(char c);
unsigned char isxdigit(char c);
unsigned char toint(char c);
char tolower(char c);
char toupper(char c);
#pragma used-
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
