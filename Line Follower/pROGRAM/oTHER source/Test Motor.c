/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 01/11/2010
Author  : NeVaDa
Company : Teknik Fisika-UGM
Comments: 


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 8,000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <stdio.h>
#include <math.h>
#include <delay.h>
#include <math.h>

#define led           PORTC.7
#define backlight     PORTB.3

#define ADC_VREF_TYPE 0x60
#define enter   PINC.0
#define back    PIND.7

#define dir_ki   PORTD.1 
#define dir_ka   PORTD.6
#define pwm_ki   OCR1B
#define pwm_ka   OCR1A

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
delay_us(10);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}
// Declare your global variables here

char data[16],dir_kanan,dir_kiri;
unsigned char adc_result1[8],adc_result2[8],adc_frontkanan,adc_frontkiri,adc_rearkanan,adc_rearkiri;
unsigned char front_sensor,rear_sensor,i,adc_tres1[8],adc_tres2[8],adc_tres1_fkanan,adc_tres1_fkiri,adc_tres1_rkanan,adc_tres1_rkiri;
int sen_max[8],sen_max_fkanan,sen_max_fkiri,sen_max_rkanan,sen_max_rkiri,hasil_scan[8],hasil_scan_tresfkanan,hasil_scan_tresfkiri;
int sen_min[8],sen_min_fkanan,sen_min_fkiri,sen_min_rkanan,sen_min_rkiri;
unsigned char hasil_scan_tresrkiri,hasil_scan_tresrkanan,display_sensor,n,select,kd,kp,speed,haruka,satomi_kanan,satomi_kiri;      
unsigned char fork_status,gita,song_hye_kyo,kosong_status,hitam_status;
int koga,aki,ishihara,detik;
int nil_kanan,nil_kiri,d_error,MV,error_before,error;            
bit data_right,data_right1,data_right2,front_kanan,front_kiri;
bit data_left,data_left1,data_left2,rear_kanan,rear_kiri,depan;
unsigned char adc_menu;

 

unsigned char eeprom eep_adc_tres1[8]= {100,100,100,100,100,100,100,100};
unsigned char eeprom eep_adc_tres2[8]= {100,100,100,100,100,100,100,100};
unsigned char eeprom eep_tresfkanan = 100;
unsigned char eeprom eep_tresfkiri = 100;
unsigned char eeprom eep_tresrkanan = 100;
unsigned char eeprom eep_tresrkiri  = 100;
unsigned char eeprom eep_speed   =150;  
unsigned char eeprom eep_kp   =14;
unsigned char eeprom eep_kd   =15; 
unsigned char eeprom eep_gita   =1;


void pwm_on()
{ 

TCCR1A=0xA1;
TCCR1B=0x03;
}

void pwm_off()
{ 

TCCR1A=0x00;
TCCR1B=0x00;
} 

void maju()
{
pwm_on();

dir_ka=0;
pwm_ka=150;

dir_ki=0;
pwm_ki=150;

for(;;)
{
lcd_maju:
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("MAJU");
delay_ms (500);
lcd_gotoxy(3,0);
delay_ms (500);
lcd_gotoxy(4,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(5,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(6,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(7,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(8,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(9,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(10,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(11,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(12,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(13,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(14,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(15,0);
lcd_putsf(".");
delay_ms (500);
lcd_gotoxy(16,0);
lcd_putsf(".");
goto lcd_maju;
}
}

void mundur()
{
pwm_on();

dir_ka=1;
pwm_ka=150;

dir_ki=1;
pwm_ki=150;
}

void NOS()
{
pwm_on();

dir_ka=0;
pwm_ka=255;

dir_ka=0;
pwm_ka=255;
}

void kanan()
{
pwm_on();

dir_ka=0;
pwm_ka=100;

dir_ki=1;
pwm_ki=100;
}


void main_menu()
{     
backlight=1;
select=1;
while (1){

main:         
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("-----MENU-----");    


adc_menu=read_adc(0);
adc_menu=255-adc_menu;

if  (adc_menu<=100) select =1;
else if  (adc_menu<=150) select =2;
else if  (adc_menu<=200) select =3;
else if  (adc_menu<=255) select =4;    
  
if (back==0){goto fin_main;}
        
switch (select)
        {
        case 1: lcd_gotoxy(0,1);
                lcd_putsf("1. Maju");break;          
        case 2: lcd_gotoxy(0,1);
                lcd_putsf("2. Mundur");break;
        case 3: lcd_gotoxy(0,1);
                lcd_putsf("3. Full Speed");break;
        case 4: lcd_gotoxy(0,1);
                lcd_putsf("4. Muter kanan");break;
        default:break;
        }     
delay_ms(150);

if (enter==0)
{
switch (select)
        {  
        case 1:maju();break;   
        case 2:mundur();break; 
        case 3:NOS();break;
        case 4:kanan();break;
        default:break;
        }
        goto main;
 }
 else {delay_ms(85);}
 }                      
 fin_main:
}


void main(void)
{

DDRA=0b00000000;
PORTA=0b00000000;

DDRB=0b11111111;
PORTB=0b00000000;

DDRC=0b11111100;
PORTC=0b10000011;

DDRD= 0b01110010;
PORTD=0b10001100;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
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

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=FFh
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// LCD module initialization
lcd_init(16);

backlight=1;
led=0;
lcd_gotoxy(3,0);
lcd_putsf("TEST MOTOR");
lcd_gotoxy(5,1);
lcd_putsf("OKE!!!");

delay_ms(1000);
led=1;
delay_ms(200);
led=0;
backlight=0;
delay_ms(200);
led=1;
delay_ms(200);
led=0;
backlight=1;
delay_ms(500);
backlight=0;
led=1;

while (1)
    { 
    if(enter==0) {maju();}
    else if(back==0) {main_menu();} 
      
      };
}
