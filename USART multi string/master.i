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
