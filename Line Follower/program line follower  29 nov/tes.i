
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

#pragma used-
#pragma library lcd.lib

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

#pragma used+

signed char cmax(signed char a,signed char b);
int max(int a,int b);
long lmax(long a,long b);
float fmax(float a,float b);
signed char cmin(signed char a,signed char b);
int min(int a,int b);
long lmin(long a,long b);
float fmin(float a,float b);
signed char csign(signed char x);
signed char sign(int x);
signed char lsign(long x);
signed char fsign(float x);
unsigned char isqrt(unsigned int x);
unsigned int lsqrt(unsigned long x);
float sqrt(float x);
float floor(float x);
float ceil(float x);
float fmod(float x,float y);
float modf(float x,float *ipart);
float ldexp(float x,int expon);
float frexp(float x,int *expon);
float exp(float x);
float log(float x);
float log10(float x);
float pow(float x,float y);
float sin(float x);
float cos(float x);
float tan(float x);
float sinh(float x);
float cosh(float x);
float tanh(float x);
float asin(float x);
float acos(float x);
float atan(float x);
float atan2(float y,float x);

#pragma used-
#pragma library math.lib

#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (0x20 & 0xff);

delay_us(10);

ADCSRA|=0x40;

while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

void showMenu();
void displaySensorBit();
void maju();
void mundur();
void bkan();
void bkir();
void stop();
void scanBlackLine();

void kalibrasi_sensor();
void baca_sensor();
void read_sensor();

unsigned char adc0,adc1,adc2,adc3,adc4,adc5,adc6,adc7;
unsigned char a1=128,a2=128,a3=128,a4=128,a5=128,a6=128,a7=128,a8=128;
unsigned char b1=128,b2=128,b3=128,b4=128,b5=128,b6=128,b7=128,b8=128;
unsigned char r1,r2,r3,r4,r5,r6,r7,r8,sensor;
bit p,q,r,s,t,u,v,w;

void kalibrasi_sensor()
{     
adc0=read_adc(0);      
if (adc0>b1) b1=adc0;
if (adc0<a1) a1=adc0;
r1= ((a1-b1)/2 ) + b1;

adc1=read_adc(1);
if (adc1>b2) b2=adc1;
if (adc1<a2) a2=adc1;
r1= ((a2-b2)/2 ) + b2;

adc2=read_adc(2);
if (adc2>b3) b3=adc2;
if (adc2<a3) a3=adc2;
r1= ((a3-b3)/2 ) + b3; 

adc3=read_adc(3); 
if (adc3>b4) b4=adc3;
if (adc3<a4) a4=adc3;
r1= ((a4-b4)/2 ) + b4;

adc4=read_adc(4); 
if (adc4>b5) b5=adc4;
if (adc4<a5) a5=adc4;
r1= ((a5-b5)/2 ) + b5;

adc5=read_adc(5); 
if (adc5>b6) b6=adc5;
if (adc5<a6) a6=adc5;
r1= ((a6-b6)/2 ) + b6;

adc6=read_adc(6); 
if (adc6>b7) b7=adc6;
if (adc6<a7) a7=adc6;
r1= ((a7-b7)/2 ) + b7;

adc7=read_adc(7); 
if (adc7>b8) b8=adc7;
if (adc7<a8) a8=adc7;
r1= ((a8-b8)/2 ) + b8;
}

void baca_sensor()
{    		 
sensor=0;
if(adc0<r1) {sensor=sensor+1;}
if(adc1<r2) {sensor=sensor+2;}
if(adc2<r3) {sensor=sensor+4;}
if(adc3<r4) {sensor=sensor+8;}
if(adc4<r5) {sensor=sensor+16;}
if(adc5<r6) {sensor=sensor+32;}
if(adc6<r7) {sensor=sensor+64;}
if(adc7<r8) {sensor=sensor+128;}
}

void read_sensor()
{      
if (adc0<r1) {w=1;}
else w=0;
if (adc1<r2) {v=1;}
else v=0;
if (adc2<r3) {u=1;}
else u=0;
if (adc3<r4) {t=1;}
else t=0;
if (adc4<r5) {s=1;}
else s=0;
if (adc5<r6) {r=1;}
else r=0;
if (adc6<r7) {q=1;}
else q=0;
if (adc7<r8) {p=1;}
else p=0;

lcd_gotoxy(2,1);
if (p)  lcd_putchar('1');
else    lcd_putchar('0');
if (q)  lcd_putchar('1');
else    lcd_putchar('0');
if (r)  lcd_putchar('1');
else    lcd_putchar('0');
if (s)  lcd_putchar('1');
else    lcd_putchar('0');
if (t)  lcd_putchar('1');
else    lcd_putchar('0');
if (u)  lcd_putchar('1');
else    lcd_putchar('0');
if (v)  lcd_putchar('1');
else    lcd_putchar('0');
if (w)  lcd_putchar('1');
else    lcd_putchar('0');
}           

typedef unsigned char byte;

flash byte char0[8]={
0b1100000,
0b0011000,
0b0000110,
0b1111111,
0b1111111,
0b0000110,
0b0011000,
0b1100000};

char lcd_buffer[33]; 

void define_char(byte flash *pc,byte char_code)
{
byte i,a;
a=(char_code<<3) | 0x40;
for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
}

void tampil(unsigned char dat)
{
unsigned char data;

data = dat / 100;
data+=0x30;
lcd_putchar(data);

dat%=100;
data = dat / 10;
data+=0x30;
lcd_putchar(data);

dat%=10;
data = dat + 0x30;
lcd_putchar(data);
}

eeprom byte Kp = 10; 
eeprom byte Ki = 0;
eeprom byte Kd = 5;
eeprom byte MAXSpeed = 255;
eeprom byte MINSpeed = 0;
eeprom byte WarnaGaris = 1; 
eeprom byte SensLine = 2; 
eeprom byte Skenario = 2;                           

void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom ) {
lcd_gotoxy(0, 0);
lcd_putsf("Tulis ke EEPROM ");
lcd_putsf("...             ");
switch (NoMenu) {
case 1: 
switch (NoSubMenu) {
case 1: 
Kp = var_in_eeprom;
break;
case 2: 
Ki = var_in_eeprom;
break;
case 3: 
Kd = var_in_eeprom;
break;
}
break;
case 2: 
switch (NoSubMenu) {
case 1: 
MAXSpeed = var_in_eeprom;
break;
case 2: 
MINSpeed = var_in_eeprom;
break;
}
break;
case 3: 
switch (NoSubMenu) {
case 1: 
WarnaGaris = var_in_eeprom;
break;
case 2: 
SensLine = var_in_eeprom;
break;
}
break;
case 4: 
Skenario = var_in_eeprom;
break;
}
delay_ms(200);
}

void scanBlackLine();

void setByte( byte NoMenu, byte NoSubMenu ) {
byte var_in_eeprom;    
byte plus5 = 0;
char limitPilih = -1;

lcd_clear();
lcd_gotoxy(0, 0);
switch (NoMenu) {
case 1: 
switch (NoSubMenu) {
case 1: 
lcd_putsf("Set Kp :        ");
var_in_eeprom = Kp;
break;
case 2: 
lcd_putsf("Set Ki :        ");
var_in_eeprom = Ki;
break;
case 3: 
lcd_putsf("Set Kd :        ");
var_in_eeprom = Kd;
break;
}
break;
case 2: 
plus5 = 1;
switch (NoSubMenu) {
case 1: 
lcd_putsf("Set MAX Speed : ");
var_in_eeprom = MAXSpeed;
break;
case 2: 
lcd_putsf("Set MIN Speed : ");
var_in_eeprom = MINSpeed;
break;
}
break;
case 3: 
switch (NoSubMenu) {
case 1: 
limitPilih = 1;
lcd_putsf("Warna Garis   : ");
var_in_eeprom = WarnaGaris;
break;
case 2: 
limitPilih = 3;
lcd_putsf("SensLine :      ");
var_in_eeprom = SensLine;
break;
}  
break;
case 4: 
lcd_putsf("Skenario :      ");
var_in_eeprom = Skenario; 
limitPilih = 8;
break;
}

while (PINB.0) {  
delay_ms(150);
lcd_gotoxy(0, 1);
tampil(var_in_eeprom);

if (!PINB.1)   {
lcd_clear();
tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
goto exitSetByte;
}
if (!PINB.2) { 
if ( plus5 )
if ( var_in_eeprom == 0 )
var_in_eeprom = 255;
else 
var_in_eeprom -= 5;
else     
if ( !limitPilih )
var_in_eeprom--;
else {  
if ( var_in_eeprom == 0 )
var_in_eeprom = limitPilih;
else
var_in_eeprom--;
}
}  
if (!PINB.3)   {
if ( plus5 )
if ( var_in_eeprom == 255 )
var_in_eeprom = 0;
else
var_in_eeprom += 5;
else
if ( !limitPilih )
var_in_eeprom++;
else {
if ( var_in_eeprom == limitPilih )
var_in_eeprom = 0;
else
var_in_eeprom++;
}
}
} 
exitSetByte:
delay_ms(100);
lcd_clear();
}

byte kursorPID, kursorSpeed, kursorGaris;  
void showMenu() { 
lcd_clear();
menu01: 
delay_ms(125);   
lcd_gotoxy(0,0);

lcd_putsf("  Set PID       ");
lcd_gotoxy(0,1);
lcd_putsf("  Set Speed     ");

lcd_gotoxy(0,0);
lcd_putchar(0);

if (!PINB.1)   {
lcd_clear();
kursorPID = 1;
goto setPID;
}
if (!PINB.2) {
goto menu02;
}  
if (!PINB.3)   {
lcd_clear();
goto menu05;
}

goto menu01;
menu02:         
delay_ms(125);
lcd_gotoxy(0,0);

lcd_putsf("  Set PID       ");
lcd_gotoxy(0,1);
lcd_putsf("  Set Speed     ");

lcd_gotoxy(0,1);
lcd_putchar(0); 

if (!PINB.1) {   
lcd_clear(); 
kursorSpeed = 1;
goto setSpeed;
}
if (!PINB.3) {
goto menu01;
}
if (!PINB.2) {
lcd_clear();
goto menu03;        
}
goto menu02;
menu03:       
delay_ms(125);
lcd_gotoxy(0,0);

lcd_putsf("  Set Garis     ");
lcd_gotoxy(0,1);
lcd_putsf("  Skenario      ");

lcd_gotoxy(0,0);
lcd_putchar(0); 

if (!PINB.1) {
lcd_clear(); 
kursorGaris = 1;  
goto setGaris;
}
if (!PINB.3) {  
lcd_clear();
goto menu02;
}
if (!PINB.2) { 
goto menu04;
}
goto menu03;
menu04:  
delay_ms(125);
lcd_gotoxy(0,0);  

lcd_putsf("  Set Garis     ");
lcd_gotoxy(0,1);
lcd_putsf("  Skenario      ");

lcd_gotoxy(0,1);
lcd_putchar(0); 

if (!PINB.1) {  
lcd_clear();
goto setSkenario;
}
if (!PINB.3) { 
goto menu03;
}
if (!PINB.2) {
lcd_clear();
goto menu05;
}
goto menu04;
menu05:      
delay_ms(125);
lcd_gotoxy(0,0);
lcd_putsf("  Start!!      ");
lcd_gotoxy(0,0);
lcd_putchar(0); 

if (!PINB.1) {   
lcd_clear();
goto startRobot;
}
if (!PINB.3) {
lcd_clear();
goto menu04;
}
if (!PINB.2) {
lcd_clear();
goto menu01;
}

goto menu05;

setPID: 
delay_ms(150);
lcd_gotoxy(0,0);

lcd_putsf("  Kp   Ki   Kd  ");

lcd_putchar(' ');
tampil(Kp); lcd_putchar(' '); lcd_putchar(' '); 
tampil(Ki); lcd_putchar(' '); lcd_putchar(' ');
tampil(Kd); lcd_putchar(' '); lcd_putchar(' ');   

switch (kursorPID) {        
case 1:
lcd_gotoxy(1,0); 
lcd_putchar(0);  
break;
case 2:
lcd_gotoxy(6,0); 
lcd_putchar(0);
break;
case 3:
lcd_gotoxy(11,0); 
lcd_putchar(0);
break;      
}

if (!PINB.1) {
setByte( 1, kursorPID); 
delay_ms(200);
}
if (!PINB.3) {
if (kursorPID == 3) {
kursorPID = 1;        
} else kursorPID++;
}
if (!PINB.2) {
if (kursorPID == 1) {
kursorPID = 3;        
} else kursorPID--;
} 

if (!PINB.0) {   
lcd_clear();
goto menu01;
}

goto setPID;

setSpeed:
delay_ms(150);
lcd_gotoxy(0,0);

lcd_putsf("   MAX    MIN   ");
lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');

tampil(MAXSpeed); 
lcd_putchar(' '); lcd_putchar(' ');lcd_putchar(' '); lcd_putchar(' '); 
tampil(MINSpeed); 
lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');           

switch (kursorSpeed) {        
case 1:
lcd_gotoxy(2,0); 
lcd_putchar(0);  
break;
case 2:
lcd_gotoxy(9,0); 
lcd_putchar(0);
break;  
}

if (!PINB.1) {
setByte( 2, kursorSpeed); 
delay_ms(200);
}
if (!PINB.3) {
if (kursorSpeed == 2) {
kursorSpeed = 1;        
} else kursorSpeed++;
}
if (!PINB.2) {
if (kursorSpeed == 1) {
kursorSpeed = 2;        
} else kursorSpeed--;
} 

if (!PINB.0) {   
lcd_clear();
goto menu02;
}

goto setSpeed;  

setGaris: 
delay_ms(150);  
lcd_gotoxy(0,0);

if ( WarnaGaris == 1 )
lcd_putsf("  WARNA : Putih "); 
else
lcd_putsf("  WARNA : Hitam "); 

lcd_gotoxy(0,1);
lcd_putsf("  SensL :        ");                              
lcd_gotoxy(10,1);
tampil( SensLine );

switch (kursorGaris) {        
case 1:
lcd_gotoxy(0,0); 
lcd_putchar(0);  
break;
case 2:
lcd_gotoxy(0,1); 
lcd_putchar(0);
break;  
} 

if (!PINB.1) {
setByte( 3, kursorGaris); 
delay_ms(200);
}
if (!PINB.3) {
if (kursorGaris == 2) {
kursorGaris = 1;        
} else kursorGaris++;
}
if (!PINB.2) {
if (kursorGaris == 1) {
kursorGaris = 2;        
} else kursorGaris--;
}           

if (!PINB.0) {   
lcd_clear();
goto menu03;
}

goto setGaris;    

setSkenario:
delay_ms(150);
lcd_gotoxy(0,0);

lcd_putsf("Sken. yg  dpake:");
lcd_gotoxy(0, 1);
tampil( Skenario );  

if (!PINB.1) {
setByte( 4, 0); 
delay_ms(200);
}

if (!PINB.0) {   
lcd_clear();
goto menu04;
}

goto setSkenario; 

startRobot:   
lcd_clear();   
}

void displaySensorBit()
{      
lcd_gotoxy(2,1);
if (PINA.7                ) lcd_putchar('1');
else    lcd_putchar('0');
if (PINA.6) lcd_putchar('1');
else    lcd_putchar('0');    
if (PINA.5) lcd_putchar('1');
else    lcd_putchar('0'); 
if (PINA.4) lcd_putchar('1');
else    lcd_putchar('0'); 
if (PINA.3) lcd_putchar('1');
else    lcd_putchar('0');
if (PINA.2) lcd_putchar('1');
else    lcd_putchar('0');
if (PINA.1) lcd_putchar('1');
else    lcd_putchar('0');
if (PINA.0) lcd_putchar('1');
else    lcd_putchar('0'); 
}                                         

unsigned char xcount;
int lpwm, rpwm, MAXPWM, MINPWM, intervalPWM;    
byte diffPWM = 5; 

interrupt [10] void timer0_ovf_isr(void)
{

xcount++;
if(xcount<=lpwm)PORTD.4=1;
else PORTD.4=0;
if(xcount<=rpwm)PORTD.5=1;
else PORTD.5=0;
TCNT0=0xFF; 
}

void maju()
{   
PORTD.1=1;PORTD.6=1;
PORTD.0    =0;PORTD.3=0;
}

void mundur()
{   
PORTD.1=0;PORTD.6=0;
PORTD.0    =1;PORTD.3=1;
}

void bkan()
{
PORTD.1=0;
PORTD.0    =1;
}

void bkir()
{
PORTD.6=0;
PORTD.3=1;
}   

void stop()
{   
rpwm=0;lpwm=0;
PORTD.1=0;PORTD.6=0;
PORTD.0    =0;PORTD.3=0; 
}

int MV, P, I, D, PV, error, last_error, rate;
int var_Kp, var_Ki, var_Kd;
unsigned char max_MV = 100;
unsigned char min_MV = -100;
unsigned char SP = 0;
void scanBlackLine() {

switch(PINA) { 
case 0b11111110:        
PV = -7;
maju();
break;
case 0b11111000:        
case 0b11111100:        
PV = -6;
maju();
break;
case 0b11111101:        
PV = -5;
maju();
break;
case 0b11110001:        
case 0b11111001:        
PV = -4;
maju();
break;
case 0b11111011:        
PV = -3;
maju();
break;
case 0b11100011:        
case 0b11110011:        
PV = -2;
maju();
break;
case 0b11110111:        
PV = -1;
maju();
break;
case 0b11100111:        
PV = 0;
maju();           
break;
case 0b11101111:
PV = 1;
maju();     
break;
case 0b11000111:
case 0b11001111:        
PV = 2;
maju();
break;
case 0b11011111:        
PV = 3;
maju();   
break;
case 0b10001111:
case 0b10011111:        
PV = 4;
maju();    
break;
case 0b10111111:        
PV = 5;
maju(); 
break;
case 0b00011111:
case 0b00111111:        
PV = 6;
maju();  
break;
case 0b01111111:        
PV = 7;
maju();      
break;
case 0b11111111:        

if (PV < 0) {

lpwm = 150; 
rpwm = 185;
bkir();
goto exit;

} else if (PV > 0) {

lpwm = 180; 
rpwm = 155;
bkan();
goto exit;
} 
}

error = SP - PV;
P = (var_Kp * error) / 8;  

I = I + error;
I = (I * var_Ki) / 8;

rate = error - last_error;
D    = (rate * var_Kd) / 8;

last_error = error; 

MV = P + I + D;

if (MV == 0) {
lpwm = MAXPWM - diffPWM;
rpwm = MAXPWM;
} 

else if (MV > 0) 
{ 
rpwm = MAXPWM - ((intervalPWM - 20) * MV);
lpwm = (MAXPWM - (intervalPWM * MV) - 15) - diffPWM;

if (lpwm < MINPWM) lpwm = MINPWM;
if (lpwm > MAXPWM) lpwm = MAXPWM;
if (rpwm < MINPWM) rpwm = MINPWM;
if (rpwm > MAXPWM) rpwm = MAXPWM;
} 

else if (MV < 0) 
{ 
lpwm = MAXPWM + ( ( intervalPWM - 20 ) * MV);
rpwm = MAXPWM + ( ( intervalPWM * MV ) - 15 ); 

if (lpwm < MINPWM) lpwm = MINPWM;
if (lpwm > MAXPWM) lpwm = MAXPWM;
if (rpwm < MINPWM) rpwm = MINPWM;
if (rpwm > MAXPWM) rpwm = MAXPWM;

} 

exit:

sprintf(lcd_buffer,"%d   %d",lpwm, rpwm);
lcd_gotoxy(0, 0);
lcd_putsf("                ");
lcd_gotoxy(0, 0);
lcd_puts(lcd_buffer);
delay_ms(5);     

}        

int hitungSiku;
void ketemuSiku(unsigned char belokKanan) {
stop();  

lpwm = 120;
rpwm = 120;
mundur();

loopSiku:
if ( !PINB.5 ) goto keluarSiku_;
if ( !PINB.6 ) goto keluarSiku_;
if ( PINA != 0xff ) goto keluarSiku_; 
goto loopSiku; 

keluarSiku_:    
stop();
lpwm = 150;
rpwm = 155;    

if ( belokKanan ) { 
while (PINA == 0xff) {
bkan(); 
}
} else {
while (PINA == 0xff) {
bkir(); 
}
}
keluarSiku:
for (hitungSiku = 0; hitungSiku < 150; hitungSiku++) {
scanBlackLine();
delay_ms(1);
}       
}

void main(void)
{

PORTA=0xFF;
DDRA=0x00;

PORTB=0xFF;
DDRB=0x00;

PORTC=0x00;
DDRC=0xFF;

PORTD=0x00;
DDRD=0xFF;

TCCR0=0x01;
TCNT0=0x00;
OCR0=0x00;

TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

MCUCR=0x00;
MCUCSR=0x00;

TIMSK=0x01;

ACSR=0x80;
SFIOR=0x00;

ADMUX=0x20 & 0xff;
ADCSRA=0x84;

lcd_init(16);

define_char(char0,0);

TCCR0=0x00;
stop(); 

delay_ms(125);
lcd_gotoxy(0,0);

lcd_putsf("  baru_belajar  ");
lcd_gotoxy(0,1);
lcd_putsf("      by :      ");
delay_ms(500);
lcd_clear();    

lcd_clear();
delay_ms(125);
lcd_gotoxy(0,0);

lcd_putsf(" DIONYSIUS IVAN ");
delay_ms(500);
lcd_clear();

delay_ms(125);
lcd_gotoxy(0,0);

lcd_putsf(" HANDIKO GESANG");
delay_ms(500);
lcd_clear();

delay_ms(125);
lcd_gotoxy(0,0);

lcd_putsf("TEKNIK FISIKA 10");
lcd_gotoxy(0,1);
lcd_putsf("-------UGM------");
delay_ms(500);
lcd_clear();

delay_ms(125);
lcd_gotoxy(0,0);

lcd_putsf("ROBORACE UNY '10");
lcd_gotoxy(0,1);
lcd_putsf("----------------");
delay_ms(500);
lcd_clear();

showMenu();

TCCR0=0x05;   
#asm("sei")

var_Kp  = Kp;
var_Ki  = Ki;
var_Kd  = Kd;   
MAXPWM = (int)MAXSpeed + 1;
MINPWM = MINSpeed;

intervalPWM = (MAXSpeed - MINSpeed) / 8;
PV = 0;
error = 0;
last_error = 0;   

while (1)
{

displaySensorBit();

};
}
