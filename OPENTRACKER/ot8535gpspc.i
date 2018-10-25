
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      
sfrb ADCSRA=6;
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
sfrb OCDR=0x31;
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

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

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

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

char rx_buffer[8];
char tx_buffer[8];
bit rx_buffer_overflow;

unsigned char rx_wr_index,rx_rd_index,rx_counter;

unsigned char tx_wr_index,tx_rd_index,tx_counter;

interrupt [12] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & ((1<<4) | (1<<2) | (1<<3)))==0)
{
rx_buffer[rx_wr_index]=data;
if (++rx_wr_index == 8) rx_wr_index=0;
if (++rx_counter == 8)
{
rx_counter=0;
rx_buffer_overflow=1;
};
};
}

interrupt [14] void usart_tx_isr(void)
{
if (tx_counter)
{
--tx_counter;
UDR=tx_buffer[tx_rd_index];
if (++tx_rd_index == 8) tx_rd_index=0;
};
}

#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index];
if (++rx_rd_index == 8) rx_rd_index=0;
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-

#pragma used+
void putchar(char c)
{
while (tx_counter == 8);
#asm("cli")
if (tx_counter || ((UCSRA & (1<<5))==0))
{
tx_buffer[tx_wr_index]=c;
if (++tx_wr_index == 8) tx_wr_index=0;
++tx_counter;
}
else
UDR=c;
#asm("sei")
}
#pragma used-

void SetIOPorts(void)
{

PORTA=0x00;
DDRA=0x00;

PORTB=0x00;
DDRB=0x00;

PORTC=0x00;
DDRC=0x00;

PORTD=0x00;
DDRD=0x02;	
}

void SetUsart4800(void)
{
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x9B;
}

void SetUsart38400(void)
{
UCSRA=0x00;
UCSRB=0xD8;
UCSRC=0x86;
UBRRH=0x00;
UBRRL=0x11;
}

flash char welcome[] = {"Selamat datang di fasilitas konfigurasi tracker via komunikasi serial/pc"};
flash char pak[] = {"Press any key !"};
flash char petunjuk[] = {"Ketik rangkaian setting Tracker yang anda inginkan"};
flash char mintaCall[] = {"Masukkan Callsign Anda : "};
flash char mintaSSID[] = {"Masukkan SSID Anda : "};
flash char mintaPath[] = {"Path anda.. tekan huruf kapital A untuk WIDE2-1, B untuk WIDE2-2, atau C untuk WIDE3-3 : "};
flash char wide21[] = {"WIDE2-1"};
flash char wide22[] = {"WIDE2-2"};
flash char wide33[] = {"WIDE3-3"};
flash char mintaSimbol[] = {"Masukkan simbol station anda (baca buku petunjuk)"};
flash char tunggu[] = {"Sedang di proses..."};
flash char selesai[] = {"Proses selesai"};
flash char CallAnda[] = {"Callsign anda : "};
flash char SSIDAnda[] = {"SSID anda : "};
flash char PathAnda[] = {"Path anda : "}; 
flash char SimbolAnda[] = {"Simbol stasiun anda : "};
flash char reconfigure[] = {"Seting ulang ? Y / N"};
flash char setingulang[] = {"Data dihapus...... Seting ulang data anda"};
char call[6];
char ssid;
char path;
char sim;
char hasil;
int i;

void KomunikasiSerial(void)
{
SetUsart38400();   

putchar(getchar());

for(i=0; i<strlenf(welcome); i++) putchar(welcome[i]);
putchar('\n');
delay_ms(1000);

for(i=0; i<strlenf(pak); i++) putchar(pak[i]);
putchar('\n');
getchar(); 

ulang:

for(i=0; i<strlenf(petunjuk); i++) putchar(petunjuk[i]);
putchar('\n');
delay_ms(500);  

for(i=0; i<strlenf(mintaCall); i++) putchar(mintaCall[i]);
putchar('\n');   
for(i=0; i<6; i++) {call[i]=getchar();}
putchar('\n');
delay_ms(500);

for(i=0; i<strlenf(mintaSSID); i++) putchar(mintaSSID[i]);
putchar('\n');   
ssid=getchar();
putchar('\n');
delay_ms(500);

for(i=0; i<strlenf(mintaPath); i++) putchar(mintaPath[i]);
putchar('\n');   
path=getchar();
putchar('\n');
delay_ms(500); 

for(i=0; i<strlenf(mintaSimbol); i++) putchar(mintaSimbol[i]);
putchar('\n');   
sim=getchar();
putchar('\n');
delay_ms(500);

for(i=0; i<strlenf(tunggu); i++) putchar(tunggu[i]);
putchar('\n'); 
delay_ms(125);

for(i=0; i<strlenf(selesai); i++) putchar(selesai[i]);
putchar('\n');

for(i=0; i<strlenf(CallAnda); i++) putchar(CallAnda[i]);
for(i=0; i<6; i++) {putchar(call[i]);}
putchar('\n');   

for(i=0; i<strlenf(SSIDAnda); i++) putchar(SSIDAnda[i]);  
putchar(ssid);
putchar('\n');

for(i=0; i<strlenf(PathAnda); i++) putchar(PathAnda[i]);  
if((path=='A') || (path=='a')){for(i=0; i<strlenf(wide21); i++) putchar(wide21[i]);}
else if((path=='B') || (path=='b')){for(i=0; i<strlenf(wide22); i++) putchar(wide22[i]);}
else {for(i=0; i<strlenf(wide33); i++) putchar(wide33[i]);}
putchar('\n');   

for(i=0; i<strlenf(SimbolAnda); i++) putchar(SimbolAnda[i]);  
putchar(sim);
putchar('\n');
delay_ms(1000);      

for(i=0; i<strlenf(reconfigure); i++) putchar(reconfigure[i]);
putchar('\n');         

hasil = getchar();

if((hasil=='N') || (hasil=='n'))
{
for(i=0; i<strlenf(setingulang); i++) putchar(setingulang[i]);
putchar('\n');
goto ulang;
}    

SetUsart4800();
}

void main(void)
{
SetIOPorts();

ACSR=0x80;
SFIOR=0x00; 

SetUsart4800();

#asm("sei")

while (1)
{
KomunikasiSerial();	
};
}
