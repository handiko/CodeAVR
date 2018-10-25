
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
sfrw ADCW=4;      
sfrb ADCSRA=6;
sfrb ADCSR=6;     
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
sfrw EEAR=0x1e;   
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
sfrw OCR1B=0x28;  
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
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

#pragma used+

void _lcd_ready(void);
void _lcd_write_data(unsigned char data);

void lcd_write_byte(unsigned char addr, unsigned char data);

unsigned char lcd_read_byte(unsigned char addr);

void lcd_gotoxy(unsigned char x, unsigned char y);

void lcd_clear(void);
void lcd_putchar(char c);

void lcd_puts(char *str);

void lcd_putsf(char flash *str);

unsigned char lcd_init(unsigned char lcd_columns);

void lcd_control (unsigned char control);

#pragma used-
#pragma library lcd.lib

typedef char *va_list;

#pragma used+

char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
int printf(char flash *fmtstr,...);
int sprintf(char *str, char flash *fmtstr,...);
int vprintf(char flash * fmtstr, va_list argptr);
int vsprintf(char *str, char flash * fmtstr, va_list argptr);

char *gets(char *str,unsigned int len);
int snprintf(char *str, unsigned int size, char flash *fmtstr,...);
int vsnprintf(char *str, unsigned int size, char flash * fmtstr, va_list argptr);

int scanf(char flash *fmtstr,...);
int sscanf(char *str, char flash *fmtstr,...);

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

#pragma library ctype.lib

#pragma used+

char *strcat(char *str1,char *str2);
char *strcatf(char *str1,char flash *str2);
char *strchr(char *str,char c);
signed char strcmp(char *str1,char *str2);
signed char strcmpf(char *str1,char flash *str2);
char *strcpy(char *dest,char *src);
char *strcpyf(char *dest,char flash *src);
unsigned char strlcpy(char *dest,char *src,unsigned char n);	
unsigned char strlcpyf(char *dest,char flash *src,unsigned char n); 
unsigned int strlenf(char flash *str);
char *strncat(char *str1,char *str2,unsigned char n);
char *strncatf(char *str1,char flash *str2,unsigned char n);
signed char strncmp(char *str1,char *str2,unsigned char n);
signed char strncmpf(char *str1,char flash *str2,unsigned char n);
char *strncpy(char *dest,char *src,unsigned char n);
char *strncpyf(char *dest,char flash *src,unsigned char n);
char *strpbrk(char *str,char *set);
char *strpbrkf(char *str,char flash *set);
char *strrchr(char *str,char c);
char *strrpbrk(char *str,char *set);
char *strrpbrkf(char *str,char flash *set);
char *strstr(char *str1,char *str2);
char *strstrf(char *str1,char flash *str2);
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
unsigned int strcspn(char *str,char *set);
unsigned int strcspnf(char *str,char flash *set);
int strpos(char *str,char c);
int strrpos(char *str,char c);
unsigned int strspn(char *str,char *set);
unsigned int strspnf(char *str,char flash *set);

#pragma used-
#pragma library string.lib

#asm
   .equ __lcd_port=0x1B ;PORTA
#endasm 

int i,j,k,m,z;
char kalimat[3][80] =

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

