
#pragma used+
sfrb DIDR=1;
sfrb UBRRH=2;
sfrb UCSRC=3;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb USICR=0xd;
sfrb USISR=0xe;
sfrb USIDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb GPIOR0=0x13;
sfrb GPIOR1=0x14;
sfrb GPIOR2=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEAR=0x1e;
sfrb PCMSK=0x20;
sfrb WDTCR=0x21;
sfrb TCCR1C=0x22;
sfrb GTCCR=0x23;
sfrb ICR1L=0x24;
sfrb ICR1H=0x25;
sfrw ICR1=0x24;   
sfrb CLKPR=0x26;
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
sfrb TCCR0A=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0B=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb OCR0A=0x36;
sfrb SPMCSR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb EIFR=0x3a;
sfrb GIMSK=0x3b;
sfrb OCR0B=0x3c;
sfrb SPL=0x3d;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
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

char *gets(char *str,unsigned char len);
int snprintf(char *str, unsigned char size, char flash *fmtstr,...);
int vsnprintf(char *str, unsigned char size, char flash * fmtstr, va_list argptr);

int scanf(char flash *fmtstr,...);
int sscanf(char *str, char flash *fmtstr,...);

#pragma used-

#pragma library stdio.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

void set_dac(char value);
void set_nada(char i_nada);
void kirim_karakter(unsigned char input);
void kirim_paket(void);
void ubah_nada(void);
void hitung_crc(char in_crc);
void kirim_crc(void);
void ekstrak_gps(void);

flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};

eeprom unsigned char data_1[21] =
{

('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),('0'<<1),

('Y'<<1),('C'<<1),('2'<<1),('W'<<1),('Y'<<1),('A'<<1),('9'<<1),

('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1
};

eeprom char posisi_lat[8] =
{

'0','0','0','0','.','0','0','S'
};

eeprom char posisi_long[9] =
{

'0','0','0','0','0','.','0','0','E'
};

eeprom char altitude[6];

eeprom char data_extension[7] =
{

'P','H','G',

'2',

'0',

'2',

'0'

};

eeprom char komentar[18] =
{

':',':',':',' ','1','4','4','.','3','9','0','M','H','z',' ',':',':',':'

};

eeprom char status[47] =
{

'A','T','t','i','n','y','2','3','1','3',' ',
'A','P','R','S',' ','t','r','a','c','k','e','r',' ',
'h','a','n','d','i','k','o','g','e','s','a','n','g','@','g','m','a','i','l','.','c','o','m'
};

eeprom char beacon_stat = 0;

char xcount = 0;

bit nada = 0;

static char bit_stuff = 0;

unsigned short crc;

interrupt 		[3] void ext_int1_isr(void)

{

PORTD.4 = 0;

delay_ms(250);

kirim_paket();

PORTD.4 = 1;

} 	

interrupt 		[6] void timer1_ovf_isr(void)

{

PORTD.4 = 0;

PORTD.5 = 1;

ekstrak_gps();

PORTD.5 = 0;

delay_ms(500);

kirim_paket();

PORTD.4 = 1;

TCNT1H = 0xFF;  
TCNT1L = 0xFF;  

}       

void 			kirim_paket(void)

{
char i;

PORTB.3 = 1;

delay_ms(100);

for(i=0;i<45;i++)
kirim_karakter(0x00);

crc = 0xFFFF;

kirim_karakter(0x7E);

bit_stuff = 0;

for(i=0;i<21;i++)
kirim_karakter(data_1[i]);

kirim_karakter(0x03);

kirim_karakter(0xF0);

kirim_karakter('!');

for(i=0;i<8;i++)
kirim_karakter(posisi_lat[i]);

kirim_karakter('\\');

for(i=0;i<9;i++)
kirim_karakter(posisi_long[i]);

kirim_karakter('l');

kirim_karakter('/');
kirim_karakter('A');
kirim_karakter('=');

for(i=0;i<6;i++)
kirim_karakter(altitude[i]);

if(beacon_stat == 5)
{

for(i=0;i<7;i++)
kirim_karakter(data_extension[i]);

}

lompat:

kirim_crc();

kirim_karakter(0x7E);

for(i=0;i<15;i++)
kirim_karakter(0x00);

delay_ms(50);
PORTB.3 = 0;

}       

void 			kirim_crc(void)

{
static unsigned char crc_lo;
static unsigned char crc_hi;

crc_lo = crc ^ 0xFF;

crc_hi = (crc >> 8) ^ 0xFF;

kirim_karakter(crc_lo);

kirim_karakter(crc_hi);

}       

void 			kirim_karakter(unsigned char input)

{
char i;
bit in_bit;

for(i=0;i<8;i++)
{

in_bit = (input >> i) & 0x01;

if(input==0x7E)	{bit_stuff = 0;}

else		{hitung_crc(in_bit);}

if(!in_bit)
{	

ubah_nada();

bit_stuff = 0;
}

else
{	

set_nada(nada);

bit_stuff++;

if(bit_stuff==5)
{

ubah_nada();

bit_stuff = 0;

}
}
}

}      

void 			hitung_crc(char in_crc)

{
static unsigned short xor_in;

xor_in = crc ^ in_crc;

crc >>= 1;

if(xor_in & 0x01)

crc ^= 0x8408;

}      

void 			ubah_nada(void)

{

if(nada ==0)
{	

nada = 1;

set_nada(nada);
}

else
{	

nada = 0;

set_nada(nada);
}

}       

void 			set_dac(char value)

{

PORTB.7 = value & 0x01;

PORTB.6 =( value >> 1 ) & 0x01;

PORTB.5 =( value >> 2 ) & 0x01;

PORTB.4 =( value >> 3 ) & 0x01;

}      	

void 			set_nada(char i_nada)

{
char i;

if(i_nada == 0)
{

for(i=0; i<16; i++)
{

set_dac(matrix[i]);

delay_us(46);
}
}

else
{

for(i=0; i<15; i++)
{

set_dac(matrix[i]);

delay_us(25  );
}

for(i=0; i<12; i++)
{

set_dac(matrix[i]);

delay_us(25  );
}
}

} 	

void 			getComma(void)

{

while(getchar() != ',');

}      	

void 			ekstrak_gps(void)

{
int i,j;
static char buff_posisi[17], buff_altitude[9];
unsigned int n_altitude[6];

while(getchar() != '$');

getchar();

getchar();

if(getchar() == 'G')
{

if(getchar() == 'G')
{

if(getchar() == 'A')
{

getComma();
getComma();

for(i=0; i<7; i++)	buff_posisi[i] = getchar();

getComma();

buff_posisi[7] = getchar();

getComma();

for(i=0; i<8; i++)	buff_posisi[i+8] = getchar();

getComma();

buff_posisi[16] = getchar();

getComma();
getComma();
getComma();
getComma();

for(i=0;i<8;i++)        buff_altitude[i] = getchar();

for(i=0;i<8;i++)	{posisi_lat[i]=buff_posisi[i];}
for(i=0;i<9;i++)	{posisi_long[i]=buff_posisi[i+8];}

for(i=0;i<6;i++)        n_altitude[i] = '0';

for(i=0;i<8;i++)
{
if(buff_altitude[i] == '.')     goto selesai;
if((buff_altitude[i] != '.')&&(buff_altitude[i] != ',')&&(buff_altitude[i] != 'M'))
{

for(j=0;j<6;j++)        n_altitude[j] = n_altitude[j+1];

n_altitude[5] = buff_altitude[i];
}
}

selesai:

for(i=0;i<6;i++)        n_altitude[i] -= '0';

n_altitude[0] *= 100000;
n_altitude[1] *=  10000;
n_altitude[2] *=   1000;
n_altitude[3] *=    100;
n_altitude[4] *=     10;

n_altitude[5] += (n_altitude[0] + n_altitude[1] + n_altitude[2] + n_altitude[3] + n_altitude[4]);

n_altitude[5] *= 3;

n_altitude[0] = n_altitude[5] / 100000;
n_altitude[5] %= 100000;

n_altitude[1] = n_altitude[5] / 10000;
n_altitude[5] %= 10000;

n_altitude[2] = n_altitude[5] / 1000;
n_altitude[5] %= 1000;

n_altitude[3] = n_altitude[5] / 100;
n_altitude[5] %= 100;

n_altitude[4] = n_altitude[5] / 10;
n_altitude[5] %= 10;

for(i=0;i<6;i++)        altitude[i] = (char)(n_altitude[i] + '0');
}
}
}

} 	

void main(void)

{

#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#pragma optsize+

PORTB=0x00;

DDRB=0xF8;

PORTD=0x09;

DDRD=0x30;

UCSRA=0x00;
UCSRB=0x10;
UCSRC=0x06;
UBRRH=0x00;
UBRRL=0x8F;

ACSR=0x80;

GIMSK=0x80;
MCUCR=0x08;
EIFR=0x80;

TCCR1B=0x05;

TCNT1H = 0xAB;
TCNT1L = 0xA0;

TIMSK=0x80;

xcount = 0;

PORTD.5 = 1;

delay_ms(500);

PORTD.4 = 1;

delay_ms(500);

PORTD.5 = 0;

delay_ms(500);

#asm("sei")

while (1)
{

};

}	

