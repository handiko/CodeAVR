/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.9 Professional
Automatic Program Generator
© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 28/03/2009
Author  : aditya rifki                           
Company : TE UGM                          
Comments: 


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 8,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega16.h>
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

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
 
bit status_error_lalu,status_error,pwm_en,black_line=1,per4an_enable=0,status_nos=0;
bit white_line,berhasil=0,flag_per4an=0,flag_siku;
unsigned char  l, menu, kp_div=13, menu_slave, strategi,temp_adc_menu,;
unsigned char adc_result1[8],adc_result2[8],adc_tres1[8],adc_tres2[8],adc_menu,lcd[16];
unsigned char max_adc1[8],max_adc2[8],min_adc1[8],min_adc2[8];     
unsigned int temp_langkah_nos[10],langkah_rem[10], langkah_cepat[10],langkah_nos[10];
unsigned char nos_speed,boleh_nos,i,j,n,front_sensor,rear_sensor,disp_sensor,backlight_on,led_on,right_back,left_back;
int i_speed,speed,MV,error,error_before,d_d_error,d_error,min_kp,max_kp,kp,kd,speed_ka,speed_ki,temp_speed;
unsigned char set_per4an, per4an,siku,per4an_dir[6];
unsigned char sampling_blank=0,sampling_blank_black=0,temp_kp_div;
unsigned int siku_kiri=0, siku_kanan=0,time,count, nos, temp_langkah, langkah_kanan,langkah_kiri,langkah,step,sigma_langkah,k;
eeprom int e_speed=200,e_min_kp=8,e_max_kp=30;
eeprom unsigned char e_adc_tres1[8]={100,100,100,100,100,100,100,100};
eeprom unsigned char e_adc_tres2[8]={100,100,100,100,100,100,100,100};
eeprom unsigned char e_kp_div=13;
eeprom unsigned char e_per4an_dir[6];
eeprom unsigned char e_per4an_enable=0;
eeprom unsigned int e_langkah_nos[10], e_langkah_cepat[10];


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
void init_IO()
{
unsigned char ; 
DDRA=0b00000000;
PORTA=0b00000000;

DDRB=0b11111111;
PORTB=0b00000000;

DDRC=0b11111100;
PORTC=0b10000011;

DDRD= 0b01110010;
PORTD=0b10001100; 
ACSR=0x80;
}

void init_ADC()
{
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x86;
}

void init_time_on()
{
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: ctc
// OC0 output: Disconnected

//OCR0 7,813 = 53 ms
TCCR0=0x0D;
TCNT0=0x00; 
TIMSK=0x02;
OCR0=30; //setiap 8 ms

//ASSR=0x00;
//TCCR2=0x0F;
//TCNT2=0x00;
//OCR2=50;

#asm ("sei")
}



void init_time_off()
{
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 7.813 kHz
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

TIMSK=0x00;
#asm ("cli")
}

void pwm_on()
{
pwm_en=1;
TCCR1A=0xA1;
TCCR1B=0x03;
}

void pwm_off()
{
pwm_en=0;
dir_ki=0;
dir_ka=0;
TCCR1A=0x00;
TCCR1B=0x00;
}

void intrpt_on()
{
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: Off


GICR|=0x40;
MCUCR=0x02;
MCUCSR=0x00;
GIFR=0x40;
TIFR=0x00;
// Timer(s)/Counter(s) Interrupt(s) initialization
// Global enable interrupts
#asm("sei")
}

void intrpt_off()
{
// External Interrupt(s) initialization
// INT0: On
// INT0 Mode: Falling Edge
// INT1: On
// INT1 Mode: Falling Edge
// INT2: Off
GICR|=0x00;
MCUCR=0x00;
MCUCSR=0x00;
GIFR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;
langkah_kiri=0;
langkah_kanan=0;
langkah=0;
sigma_langkah=0;
// Global enable interrupts
#asm("cli")
}


void read_sensor()
{
front_sensor=0;
rear_sensor=0;

for(i=0;i<8;i++)
    {
        if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
        else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
        else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
        else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
        else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
        else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
        else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
        else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
        adc_result1[i]=read_adc(7);//depan
        adc_result2[i]=read_adc(6);//belakang
    }  
//adc_result_top=read_adc(1);

for(i=0;i<8;i++)
    {
    if      (adc_result1[i]>adc_tres1[i]){front_sensor=front_sensor|1<<i;}
    else if (adc_result1[i]<adc_tres1[i]){front_sensor=front_sensor|0<<i;}
    
    if      (adc_result2[i]>adc_tres2[i]){rear_sensor=rear_sensor|1<<i;}
    else if (adc_result2[i]<adc_tres2[i]){rear_sensor=rear_sensor|0<<i;}
    }

rear_sensor=0b01111110&rear_sensor;
}

void read_rear_sensor()
{
rear_sensor=0;

for(i=0;i<8;i++)
    {
        if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
        else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
        else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
        else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
        else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
        else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
        else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
        else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
            adc_result2[i]=read_adc(6);//belakang
    }  
//adc_result_top=read_adc(1);

for(i=0;i<8;i++)
    {
    
    if      (adc_result2[i]>adc_tres2[i]){rear_sensor=rear_sensor|1<<i;}
    else if (adc_result2[i]<adc_tres2[i]){rear_sensor=rear_sensor|0<<i;}
    }

rear_sensor=0b01111110&rear_sensor;
}

void read_front_sensor()
{
front_sensor=0;

for(i=0;i<8;i++)
    {
        if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
        else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
        else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
        else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
        else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
        else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
        else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
        else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
        adc_result1[i]=read_adc(7);//depan
    }  
//adc_result_top=read_adc(1);

for(i=0;i<8;i++)
    {
    if      (adc_result1[i]>adc_tres1[i]){front_sensor=front_sensor|1<<i;}
    else if (adc_result1[i]<adc_tres1[i]){front_sensor=front_sensor|0<<i;}
    }
}

void ka_maju()
{
dir_ka=0;
pwm_ka=speed_ka;
}

void ka_mund()
{
if(pwm_en==1)dir_ka  =1;
speed_ka=255+speed_ka;
pwm_ka  =speed_ka;
}

void ki_maju()
{
dir_ki=0;
pwm_ki=speed_ki;
}

void ki_mund()
{
if(pwm_en==1)dir_ki  =1;
speed_ki=255+speed_ki;
pwm_ki  =speed_ki;
}

void pwm_out()
{
if      (speed_ka>255)  speed_ka  =255;
else if (speed_ka<-255) speed_ka  =-255; 

if      (speed_ki>255)  speed_ki  =255;
else if (speed_ki<-255) speed_ki  =-255;

    
    for(i=0;i<8;i++)
        {
        disp_sensor=0;
        disp_sensor=front_sensor>>i;
        disp_sensor=(disp_sensor)&(0b00000001);
        n=7-i;
        lcd_gotoxy(n,0);
        sprintf(lcd,"%d",disp_sensor);
        lcd_puts(lcd);
        }
    
    for(i=0;i<8;i++)
        {
        disp_sensor=0;
        disp_sensor=rear_sensor>>i;
        disp_sensor=(disp_sensor)&(0b00000001);
        n=7-i;
        lcd_gotoxy(n,1);
        sprintf(lcd,"%d",disp_sensor);
        lcd_puts(lcd);
        }     

lcd_gotoxy(9,0);
sprintf(lcd,"%d",error);
lcd_puts(lcd);

lcd_gotoxy(12,0);
sprintf(lcd,"%d",langkah);
lcd_puts(lcd);

lcd_gotoxy(15,0);
sprintf(lcd,"%d",per4an);
lcd_puts(lcd);
        
lcd_gotoxy(8,1);
sprintf(lcd,"%d",speed_ki); 
lcd_puts(lcd);
   
lcd_gotoxy(13,1); 
sprintf(lcd,"%d",speed_ka); 
lcd_puts(lcd);

if      (speed_ka >=0)  ka_maju();
else if (speed_ka <0)   ka_mund();

if      (speed_ki >=0)  ki_maju();
else if (speed_ki <0)   ki_mund();
}

void komp_pid()
{
d_error =error-error_before;
MV      =(kp*error)+(kd*d_error);

speed_ka=i_speed+MV;
speed_ki=i_speed-MV;

error_before=error;
d_d_error=error-d_error;
} 

void giving_weight10()
{
switch(front_sensor)
    {
    case 0b00000001:error=  16;white_line=0;break;
    case 0b00000010:error=  10;white_line=0;break;
    case 0b00000100:error=   5;white_line=0;break;
    case 0b00001000:error=   1;white_line=0;kp=speed/20;kd=6*kp;break;
    case 0b00010000:error=  -1;white_line=0;kp=speed/20;kd=6*kp;;break;
    case 0b00100000:error=  -5;white_line=0;break;
    case 0b01000000:error= -10;white_line=0;break;
    case 0b10000000:error= -16;white_line=0;break; 
    }
    
}


void giving_weight20()
{
switch(front_sensor)
    {
    case 0b00000011:error=  13;white_line=0;break;
    case 0b00000110:error=   7;white_line=0;break;
    case 0b00001100:error=   3;white_line=0;break;
    case 0b00011000:error=   0;kp=speed/20;kd=6*kp;white_line=0;break;
    case 0b00110000:error=  -3;white_line=0;break;
    case 0b01100000:error=  -7;white_line=0;break;
    case 0b11000000:error= -13;white_line=0;break;
    }
}

void giving_weight11()
{
switch(front_sensor)
    {
    case 0b11111110:error=  16; backlight_on=10;white_line=1;break;
    case 0b11111101:error=  10;backlight_on=10;white_line=1;break;
    case 0b11111011:error=   5;backlight_on=10;white_line=1;break;
    case 0b11110111:error=   1;backlight_on=10;white_line=1;kp=speed/20;kd=6*kp;break;
    case 0b11101111:error=  -1;backlight_on=10;white_line=1;kp=speed/20;kd=6*kp;break;
    case 0b11011111:error=  -5;backlight_on=10;white_line=1;break;
    case 0b10111111:error= -10;backlight_on=10;white_line=1;break;
    case 0b01111111:error= -16;backlight_on=10;white_line=1;break; 
    }   
}


void giving_weight21()
{
switch(front_sensor)
    {
    case 0b11111100:error=  13;backlight_on=10;white_line=1;break;
    case 0b11111001:error=   7;backlight_on=10;white_line=1;break;
    case 0b11110011:error=   3;backlight_on=10;white_line=1;break;
    case 0b11100111:error=   0;backlight_on=10;white_line=1;kp=speed/20;kd=6*kp;break;
    case 0b11001111:error=  -3;backlight_on=10;white_line=1;break;
    case 0b10011111:error=  -7;backlight_on=10;white_line=1;break;
    case 0b00111111:error= -13;backlight_on=10;white_line=1;break;
}
}



void per4an_handler()
{  
   #asm("cli")
   if(per4an>=4) goto selesai;
   per4an++;
   
    
    if(per4an_dir[per4an]==0) //pilih kiri
    { 
      berhasil=1;
      error=15;
      speed_ki=-150;
      speed_ka=-150;
      pwm_out();
      delay_ms(40);
      if(per4an==4)
      { 
         speed_ki=-200;
         speed_ka=80;
      }    
      else
      {
      speed_ki=-200;
      speed_ka=120;
    }
      pwm_out();
      //error=7;    
      for(;;){read_front_sensor();if(front_sensor==0b00000011||front_sensor==0b00000001||front_sensor==0b00000010)break;}
      
      for(;;){i_speed=-100;read_sensor();giving_weight10();giving_weight20();kp_div=kp_div+3;
      kp=speed/kp_div;kd=4*kp;komp_pid();pwm_out();if(-3<=error<=3){i_speed=130;speed=temp_speed; break;}}
    }
    else if (per4an_dir[per4an]==1) //pilih kanan
    { 
      berhasil=1;
      error=-15;
      speed_ki=-150;
      speed_ka=-150;
      pwm_out();
      delay_ms(50);
      speed_ki=120;
      speed_ka=-200;
      pwm_out();
      //error=-7;
      for(;;){read_front_sensor();delay_ms(2);if(front_sensor==0b10000000||front_sensor==0b11000000||front_sensor==0b01000000)break;}
      kp_div=kp_div+3;
      kp=speed/kp_div;
      kd=4*kp;
      for(;;){i_speed=-120;read_sensor();giving_weight10();giving_weight20();kp_div=kp_div+3;
      kp=speed/kp_div;kd=4*kp;komp_pid();pwm_out();delay_ms(2);if(-3<=error<=3){i_speed=180;speed=temp_speed; break;}}  
    }
    else delay_ms(30);
    if(per4an<5)speed=130;
    else speed=temp_speed;
       
   flag_per4an=1; right_back=0;left_back=0;
   selesai:
   #asm("sei")
}            

void line_following()
{
read_sensor();
lcd_clear();
led=1;
backlight=0; 
if(time<=230)time++; 

if(backlight_on>0){backlight_on--;backlight=1;}
else               backlight=0; 
    
if(led_on>0){led_on--;led=0;}
else         led=1;
    
if(i_speed<speed)   i_speed=i_speed+10;
else                i_speed=speed;
kp=i_speed/kp_div;
//kp=kp+0.15* abs(d_error)* abs(d_d_error);
//if(kp>=30)kp=30;
//kd=60-(1.5*kp);
kd=3*kp;
//if(time<240)kp=speed/30;



giving_weight10();
giving_weight20();


komp_pid();

        
//-----------------kondisi khusus menggunakan sensor belakang-----------------//    

pwm_out();                         
}
    

        


//--------------------------------------------------------------------------------//

void action()
{
j=0;
init_time_on(); 
// if(strategi==3) 
// {
// intrpt_on();
// step=90;
// }
if(strategi==4)
{
   per4an=2;
}
for(;;)
    {   
    line_following();
        //if(enter==0){lcd_clear();init_time_off();break;}
    if(back==0) {lcd_clear();intrpt_off();init_time_off();break;}
    //delay_ms(2);
    }
pwm_off();
intrpt_off();
backlight=0;



led=1;
backlight=0;
delay_ms(250);
}

void tampil_auto_set1()
{
lcd_gotoxy(0,0);
sprintf(lcd,"%d %d %d %d ",adc_tres1[0],adc_tres1[1],adc_tres1[2],adc_tres1[3]);
lcd_puts(lcd);

lcd_gotoxy(0,1);
sprintf(lcd,"%d %d %d %d",adc_tres1[4],adc_tres1[5],adc_tres1[6],adc_tres1[7]);
lcd_puts(lcd);
    
    
for(;;)
    {
    lcd_clear();
    for(i=0;i<8;i++)
        {
        if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
        else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
        else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
        else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
        else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
        else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
        else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
        else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
        adc_result1[i]=read_adc(7);//depan
        //adc_result2[i]=read_adc(6);//belakang
        }                                                
      
    for(i=0;i<8;i++)
        {
        if(adc_result1[i]>max_adc1[i])max_adc1[i]=adc_result1[i];
        if(adc_result1[i]<max_adc1[i])min_adc1[i]=adc_result1[i];        
        //adc_tres1[i]=min_adc1[i]+((max_adc1[i]-min_adc1[i])/10);
        adc_tres1[i]=min_adc1[i]+40;
        //adc_tres1[i]=0.6*max_adc1[i];
        
        delay_us(50);
        lcd_gotoxy(0,0);
        sprintf(lcd,"%d",adc_result1[0]);
        lcd_puts(lcd);
        
        lcd_gotoxy(4,0);
        sprintf(lcd,"%d",adc_result1[1]);
        lcd_puts(lcd);
        
        lcd_gotoxy(8,0);
        sprintf(lcd,"%d",adc_result1[2]);
        lcd_puts(lcd);
        
        lcd_gotoxy(12,0);
        sprintf(lcd,"%d",adc_result1[3]);
        lcd_puts(lcd);
        
        lcd_gotoxy(0,1);
        sprintf(lcd,"%d",adc_result1[4]);
        lcd_puts(lcd);
        
        lcd_gotoxy(4,1);
        sprintf(lcd,"%d",adc_result1[5]);
        lcd_puts(lcd);
        
        lcd_gotoxy(8,1);
        sprintf(lcd,"%d",adc_result1[6]);
        lcd_puts(lcd);                
        
        lcd_gotoxy(12,1);
        sprintf(lcd,"%d",adc_result1[7]);
        lcd_puts(lcd);
        }
       
    
    delay_us(600);
    if(enter==0)
        {
        for(i=0;i<8;i++)
            {
            e_adc_tres1[i]=adc_tres1[i];
            e_adc_tres2[i]=adc_tres2[i];
            }
        break;
        }
    if(back==0)break;
    }
selesai:
for(i=0;i<8;i++){adc_tres1[i]=e_adc_tres1[i];adc_tres2[i]=e_adc_tres2[i];}
delay_ms(250);
}

void tampil_auto_set2()
{
lcd_gotoxy(0,0);
sprintf(lcd,"%d %d %d %d ",adc_tres2[0],adc_tres2[1],adc_tres2[2],adc_tres2[3]);
lcd_puts(lcd);

lcd_gotoxy(0,1);
sprintf(lcd,"%d %d %d %d",adc_tres2[4],adc_tres2[5],adc_tres2[6],adc_tres2[7]);
lcd_puts(lcd);
    
    
for(;;)
    {
    lcd_clear();
    for(i=0;i<8;i++)
        {
        if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
        else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
        else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
        else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
        else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
        else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
        else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
        else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
        //adc_result1[i]=read_adc(7);//depan
        adc_result2[i]=read_adc(6);//belakang
        }                                                
      
    for(i=0;i<8;i++)
        {
        if(adc_result2[i]>max_adc2[i])max_adc1[i]=adc_result2[i];
        if(adc_result2[i]<max_adc2[i])min_adc1[i]=adc_result2[i];        
        //adc_tres1[i]=min_adc1[i]+((max_adc1[i]-min_adc1[i])/10);
        adc_tres2[i]=min_adc2[i]+40;
        //adc_tres1[i]=0.6*max_adc1[i];
        
        delay_us(50);
        lcd_gotoxy(0,0);
        sprintf(lcd,"%d",adc_result2[0]);
        lcd_puts(lcd);
        
        lcd_gotoxy(4,0);
        sprintf(lcd,"%d",adc_result2[1]);
        lcd_puts(lcd);
        
        lcd_gotoxy(8,0);
        sprintf(lcd,"%d",adc_result2[2]);
        lcd_puts(lcd);
        
        lcd_gotoxy(12,0);
        sprintf(lcd,"%d",adc_result2[3]);
        lcd_puts(lcd);
        
        lcd_gotoxy(0,1);
        sprintf(lcd,"%d",adc_result2[4]);
        lcd_puts(lcd);
        
        lcd_gotoxy(4,1);
        sprintf(lcd,"%d",adc_result2[5]);
        lcd_puts(lcd);
        
        lcd_gotoxy(8,1);
        sprintf(lcd,"%d",adc_result2[6]);
        lcd_puts(lcd);                
        
        lcd_gotoxy(12,1);
        sprintf(lcd,"%d",adc_result2[7]);
        lcd_puts(lcd);
        }
       
    
    delay_us(600);
    if(enter==0)
        {
        for(i=0;i<8;i++)
            {
            e_adc_tres1[i]=adc_tres1[i];
            e_adc_tres2[i]=adc_tres2[i];
            }
        break;
        }
    if(back==0)break;
    }
selesai:
for(i=0;i<8;i++){adc_tres1[i]=e_adc_tres1[i];adc_tres2[i]=e_adc_tres2[i];}
delay_ms(250);
}

void tampil_speed()
{
lcd_gotoxy(0,1);
sprintf(lcd,"=%d",speed);
lcd_puts(lcd);
for(;;)
    {
    adc_menu=read_adc(0);
    adc_menu=255-adc_menu;
    
    lcd_gotoxy(8,1);
    lcd_putsf("   ");
    lcd_gotoxy(5,1);
    sprintf(lcd," <- %d",adc_menu);
    lcd_puts(lcd);
    
    if(enter==0){e_speed=adc_menu;speed=adc_menu;temp_speed=speed;delay_ms(400);break;}
    if(back==0){delay_ms(400);break;}
    delay_ms(50);
    }
}


// void detect_per4an()
// {
// 
// for(;;)
//     {
//     adc_menu=read_adc(0);
//     adc_menu=255-adc_menu;
//     
//     if  (adc_menu<=50)per3an_enable=0;
//     else per3an_enable=1;
//     
//     lcd_gotoxy(0,1);
//     if     (e_per4an_enable==0)lcd_putsf("disable");
//     else if(e_per4an_enable==1)lcd_putsf("enable");
//     
//     lcd_gotoxy(7,1);
//     lcd_putsf("<-");
//     if     (per4an_enable==0)lcd_putsf("disable");
//     else if(per4an_enable==1)lcd_putsf("enable");
//     
//     
//     if(enter==0){e_per3an_enable=per3an_enable;per3an_enable=per3an_enable;delay_ms(400);break;}
//     if(back==0){delay_ms(400);break;}
//     delay_ms(50);
//     }
// }

void eksekusi_per4an()
{

awal:
lcd_clear();   
adc_menu=read_adc(0);
lcd_gotoxy(0,0);
if(adc_menu<30)
    {
    lcd_putsf("1. Arah Per4an 1");
    set_per4an=1;
    }
else if(adc_menu<60)
    {
    lcd_putsf("2. Arah Per4an 2");
    set_per4an=2;
    }
else if(adc_menu<90)
    {
    lcd_putsf("3. Arah Per4an 3");
    set_per4an=3;
    }
else if(adc_menu<120)
    {
    lcd_putsf("4. Arah Per4an 4");
    set_per4an=4;
    }
else if(adc_menu<150)
    {
    lcd_putsf("5. Arah Per4an 5");
    set_per4an=5;
    }

if(enter==0) {delay_ms(400);goto edit_per4an;}
if(back==0) {delay_ms(400);goto selesai;}
goto awal;

edit_per4an:
if(set_per4an==1) goto per4an_1;
else if(set_per4an==2) goto per4an_2;
else if(set_per4an==3) goto per4an_3;
else if(set_per4an==4) goto per4an_4;
else if(set_per4an==5) goto per4an_5;

per4an_1:
for(;;)
    {
    adc_menu=read_adc(0);
    if         (adc_menu<=60)    per4an_dir[1]=0;
    else if  (adc_menu<=120)  per4an_dir[1]=1;
    else                               per4an_dir[1]=2;
    
    lcd_gotoxy(0,1);
    if     (e_per4an_dir[1]==0)lcd_putsf("left");
    else if(e_per4an_dir[1]==1)lcd_putsf("right");
    else if(e_per4an_dir[1]==2)lcd_putsf("lurus");
    
    lcd_gotoxy(7,1);
    lcd_putsf("<-");
    if        (per4an_dir[1]==0)lcd_putsf("left");
    else if (per4an_dir[1]==1)lcd_putsf("right");
    else if (per4an_dir[1]==2)lcd_putsf("lurus"); 

    if(enter==0){e_per4an_dir[1]=per4an_dir[1];per4an_dir[1]=per4an_dir[1];delay_ms(400);lcd_clear();goto awal;}
    if(back==0){delay_ms(400);lcd_clear();goto awal;}
    delay_ms(50);
    }
    
    per4an_2:
    for(;;)
    {
    adc_menu=read_adc(0);
    if         (adc_menu<=60)    per4an_dir[2]=0;
    else if  (adc_menu<=120)  per4an_dir[2]=1;
    else                               per4an_dir[2]=2;
    
    lcd_gotoxy(0,1);
    if     (e_per4an_dir[2]==0)lcd_putsf("left");
    else if(e_per4an_dir[2]==1)lcd_putsf("right");
    else if(e_per4an_dir[2]==2)lcd_putsf("lurus");
    
    lcd_gotoxy(7,1);
    lcd_putsf("<-");
    if     (per4an_dir[2]==0)lcd_putsf("left");
    else if(per4an_dir[2]==1)lcd_putsf("right");
    else if(per4an_dir[2]==2)lcd_putsf("lurus");
    if(enter==0){e_per4an_dir[2]=per4an_dir[2];per4an_dir[2]=per4an_dir[2];delay_ms(400);lcd_clear();goto awal;}
    if(back==0){delay_ms(400);lcd_clear();goto awal;}
    delay_ms(50);
    }
    
    per4an_3:
    for(;;)
    {
    adc_menu=read_adc(0);
    
    if        (adc_menu<=50)   per4an_dir[3]=0;
    else if (adc_menu<=120) per4an_dir[3]=1;
    else                             per4an_dir[3]=2;
    
    lcd_gotoxy(0,1);
    if     (e_per4an_dir[3]==0)lcd_putsf("left");
    else if(e_per4an_dir[3]==1)lcd_putsf("right");
    else if(e_per4an_dir[3]==2)lcd_putsf("lurus");
    
    lcd_gotoxy(7,1);
    lcd_putsf("<-");
    if     (per4an_dir[3]==0)lcd_putsf("left");
    else if(per4an_dir[3]==1)lcd_putsf("right");
    else if(per4an_dir[3]==2)lcd_putsf("lurus");
    
    if(enter==0){e_per4an_dir[3]=per4an_dir[3];per4an_dir[3]=per4an_dir[3];delay_ms(400);lcd_clear();goto awal;}
    if(back==0){delay_ms(400);lcd_clear();goto awal;}
    delay_ms(50);
    }
    
    per4an_4:
    for(;;)
    {
    adc_menu=read_adc(0);
    
    if       (adc_menu<=50)   per4an_dir[4]=0;
    else if(adc_menu<=120) per4an_dir[4]=1;
    else                            per4an_dir[4]=2;
    
    lcd_gotoxy(0,1);
    if     (e_per4an_dir[4]==0)lcd_putsf("left");
    else if(e_per4an_dir[4]==1)lcd_putsf("right");
    else if(e_per4an_dir[4]==2)lcd_putsf("lurus");
    
    lcd_gotoxy(7,1);
    lcd_putsf("<-");
    if     (per4an_dir[4]==0)lcd_putsf("left");
    else if(per4an_dir[4]==1)lcd_putsf("right");
    else if(per4an_dir[4]==2)lcd_putsf("lurus");
    
    if(enter==0){e_per4an_dir[4]=per4an_dir[4];per4an_dir[4]=per4an_dir[4];delay_ms(400);lcd_clear();goto awal;}
    if(back==0){delay_ms(400);lcd_clear();goto awal;}
    delay_ms(50);
    }
    
    per4an_5:
    for(;;)
    {
    adc_menu=read_adc(0);
    
    if         (adc_menu<=50) per4an_dir[5]=0;
    else if  (adc_menu<=120)per4an_dir[5]=1;
    else                             per4an_dir[5]=2;
    
    lcd_gotoxy(0,1);
    if     (e_per4an_dir[5]==0)lcd_putsf("left");
    else if(e_per4an_dir[5]==1)lcd_putsf("right");
    else if(e_per4an_dir[5]==2)lcd_putsf("lurus");
    
    lcd_gotoxy(7,1);
    lcd_putsf("<-");
    if     (per4an_dir[5]==0)lcd_putsf("left");
    else if(per4an_dir[5]==1)lcd_putsf("right");
    else if(per4an_dir[5]==2)lcd_putsf("lurus");
    
    if(enter==0){e_per4an_dir[5]=per4an_dir[5];per4an_dir[5]=per4an_dir[5];delay_ms(400);lcd_clear();goto awal;}
    if(back==0){delay_ms(400);lcd_clear();goto awal;}
    delay_ms(50);
    }
    
    selesai:
}

void pembagi_kp()
{
lcd_gotoxy(0,1);
sprintf(lcd,"=%d",kp_div);
lcd_puts(lcd);
for(;;)
    {
    adc_menu=read_adc(0);
    adc_menu=255-adc_menu;
    
    //kp_div=adc_menu/5;
    
    lcd_gotoxy(8,1);
    lcd_putsf("   ");
    lcd_gotoxy(5,1);
    sprintf(lcd," <- %d",adc_menu/3);
    lcd_puts(lcd);
    
    if(enter==0){e_kp_div=adc_menu/3;kp_div=adc_menu/3;delay_ms(400);break;}
    if(back==0){delay_ms(400);break;}
    delay_ms(50);
    }
}


void uji_langkah()
{
intrpt_on();
lcd_clear();
langkah_kanan=0;
for(;;)
    {   
        speed_ka=pwm_ka=10;
        speed_ki=pwm_ki=10;
        lcd_gotoxy(0,0);
        lcd_putsf("KR=");
        lcd_gotoxy(3,0);
        sprintf(lcd," %d",langkah_kiri);
        lcd_puts(lcd);
        lcd_gotoxy(8,0);
        lcd_putsf("KN=");
        lcd_gotoxy(11,0);
        sprintf(lcd," %d",langkah_kanan);
        lcd_puts(lcd);                        
        
               
        lcd_gotoxy(0,1);
        lcd_putsf("langkah=");
        lcd_gotoxy(8,1);
        sprintf(lcd," %d",step);
        lcd_puts(lcd);
        
        if(back==0){intrpt_off();delay_ms(50);break;}
    }
}

void test_drive()
{     

pwm_on();
speed_ka=speed;
speed_ki=speed;
pwm_out();
for(;;){if(back==0||enter==0){pwm_off();break;}}
}


void slave_menu()
{
    menu_slave=0;
    temp_adc_menu=0;
    for(;;)
    {
    adc_menu=read_adc(0);
    //adc_menu=255-adc_menu;
    if(temp_adc_menu!=adc_menu) lcd_clear();
    lcd_gotoxy(0,0);
    
    if (adc_menu<=40)  
        {
        lcd_putsf("1. Uji Langkah ");
        menu_slave=1;
        }
    else if (adc_menu<=80)  
        {
        lcd_putsf("2. Arah Per4an");
        menu_slave=2;
        }
    else if (adc_menu<=120)
        {
        lcd_putsf("3. Pembagi Kp");
        menu_slave=3;
        }

    else 
        {
        lcd_putsf("4. test_drive");
        menu_slave=4;
        }
  

            
    if(enter==0)
    {   
        delay_ms(300);
        if      (menu_slave==1)uji_langkah();
        else if (menu_slave==2)eksekusi_per4an();
        else if (menu_slave==3)pembagi_kp(); 
        else if (menu_slave==4)test_drive();  
    }
       if(back==0){delay_ms(400);menu_slave=0;break;}
       
    temp_adc_menu=adc_menu;     
    }                            
    
   
}


void tampil_driver ()
{
lcd_clear();lcd_gotoxy(0,1);sprintf(lcd,"%d %d",speed_ki,speed_ka); lcd_puts(lcd);
}

void tes_driver()
{
pwm_on();

kanan_maju_full:
        speed_ki=0;ki_maju();
tampil_driver();
speed_ka=255;ka_maju();
if (enter==0) {delay_ms(400);goto kanan_maju_pelan;}
if (back==0) {goto completed_test;}
goto kanan_maju_full;

kanan_maju_pelan:
tampil_driver();
speed_ka=100;ka_maju();
if (enter==0) {delay_ms(400);goto kanan_mundur_full;}
if (back==0) goto completed_test;
goto kanan_maju_pelan;

kanan_mundur_full:
tampil_driver();
speed_ka=-255;ka_mund();
if (enter==0) {delay_ms(400);goto kanan_mundur_pelan;}
if (back==0) goto completed_test;
goto kanan_mundur_full;

kanan_mundur_pelan:
tampil_driver();
speed_ka=-100;ka_mund();
if (enter==0) {delay_ms(400);goto kiri_maju_full;}
if (back==0) goto completed_test;
goto kanan_mundur_pelan;

kiri_maju_full:
    speed_ka=0;ka_maju();

tampil_driver();
speed_ki=255;ki_maju();
if (enter==0) {delay_ms(400);goto kiri_maju_pelan;}
if (back==0) goto completed_test;
goto kiri_maju_full;

kiri_maju_pelan:
tampil_driver();
speed_ki=100;ki_maju();
if (enter==0) {delay_ms(400);goto kiri_mundur_full;}
if (back==0) goto completed_test;
goto kiri_maju_pelan;

kiri_mundur_full:
tampil_driver();
speed_ki=-255;ki_mund();
if (enter==0) {delay_ms(400);goto kiri_mundur_pelan;}
if (back==0) goto completed_test;
goto kiri_mundur_full;

kiri_mundur_pelan:
tampil_driver();
speed_ki=-100;ki_mund();
if (enter==0) {delay_ms(400);goto maju_full;}
if (back==0) goto completed_test;
goto kiri_mundur_pelan;

maju_full:
tampil_driver();
speed_ka=255;ka_maju();
speed_ki=255;ki_maju();
if (enter==0) {delay_ms(400);goto maju_pelan;}
if (back==0) goto completed_test;
goto maju_full;

maju_pelan:
tampil_driver();
speed_ka=100;ka_maju();
speed_ki=100;ki_maju();
if (enter==0) {delay_ms(400);goto mundur_full;}
if (back==0) goto completed_test;
goto maju_pelan;

mundur_full:
tampil_driver();
speed_ka=-255;ka_mund();
speed_ki=-255;ki_mund();
if (enter==0) {delay_ms(400);goto mundur_pelan;}
if (back==0) goto completed_test;
goto mundur_full;

mundur_pelan:
tampil_driver();
speed_ka=-100;ka_mund();
speed_ki=-100;ki_mund();
if (enter==0) {delay_ms(400);goto completed_test;}
if (back==0) goto completed_test;
goto mundur_pelan;


completed_test:

delay_ms(200);
speed_ka=0;speed_ki=0;pwm_out();pwm_off();
delay_ms(200);
}

void tampil_menu()
{

menu=0;
for(;;)
    {
    adc_menu=read_adc(0);
    lcd_clear();
    lcd_gotoxy(0,0);
    if (adc_menu<=85)  
        {
        lcd_putsf("1. Speed ");
        menu=1;
        }
    else if (adc_menu<=170)  
        {
        lcd_putsf("2. Scan depan ");
        menu=2;
        }
    
    else if (adc_menu<=200)  
        {
        lcd_putsf("3. Scan belakang");
        menu=3;
        }          
    else if (adc_menu<=255)  
        {
        lcd_putsf("4. Driver Test");
        menu=4;
        }      
    if(enter==0)
        {
        delay_ms(400);
        if      (menu==2)
            {
            for(i=0;i<8;i++)
                {
                min_adc1[i]=255;
                max_adc1[i]=0;
                }
            tampil_auto_set1();
            } 
            
        else if  (menu==3)
            {
            for(i=0;i<8;i++)
                {
                min_adc2[i]=255;
                max_adc2[i]=0;
                }
            tampil_auto_set2();
            }    
         else if  (menu==4)
            {
            tes_driver();
            }
        else if (menu==1)tampil_speed();   
        }
        
    if(back==0)
    {
        i=0;
        while(back==0){delay_ms(10);i++;if(i>200)i=200;}
        if(i>60)    {slave_menu();}
        else        {delay_ms(400);menu=0;break;}
        }
    delay_ms(50);
    }
}

void tampil_siap()
{
i=0;
n=0;

start:
for(;;)
    {
    lcd_clear();
    i=0;
    n=0;
    langkah=0;
    langkah_kanan=0;
    langkah_kiri=0;
    per4an=0;
    flag_siku=0;
    siku=0;
    flag_per4an=0;  
    adc_menu=read_adc(0);
    boleh_nos=0;
    berhasil=0;
    status_error=0;
    status_error_lalu=1;
    temp_kp_div=kp_div;
    per4an_dir[1]=2;
    per4an_dir[2]=1;
    per4an_dir[3]=2;
    per4an_dir [4]=0;
    time=0;
    
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("RUN?");
    speed=temp_speed;
        
    lcd_gotoxy(0,1);
    
    if           (adc_menu<=30)strategi=1;
    else if    (adc_menu<=70)strategi=2;
    else if    (adc_menu<=100)strategi=3;
    else if    (adc_menu<=170)strategi=4;
    else      goto lihat_sensor;
        
    if           (strategi==1)lcd_putsf("PID");
    else if    (strategi==2)lcd_putsf("Deteksi Per4an");
    else if    (strategi==3)lcd_putsf("NOS-NOS");
    else if    (strategi==4)lcd_putsf("Using AI");
    
    delay_ms(200);
    if(back==0){delay_ms(250);tampil_menu();goto start;}
    if(enter==0)
        {
        i=0;
        while(enter==0){delay_ms(10);i++;if(i>200)i=200;}
        if(i>30)    {pwm_off();i_speed=50;action();goto start;}
        else        {pwm_on();i_speed=50;action();goto start;}
        }
        
//     while(enter!=0&&back!=0&&(adc_menu==temp_adc_menu))
//         {
//         i++;
//         if(i>100){n++;i=0;}
//         delay_ms(10);
//         if(n>6){n=2;screensaver();}
//         }
    temp_adc_menu=adc_menu;
    goto selesai;
    lihat_sensor:
    lcd_clear();
    
    for(;;)
    {
    lcd_clear(); 
    adc_menu=read_adc(0);
    
      read_sensor();
     for(i=0;i<8;i++)
        {
        disp_sensor=0;
        disp_sensor=front_sensor>>i;
        disp_sensor=(disp_sensor)&(0b00000001);
        n=i;
        lcd_gotoxy(n,0);
        sprintf(lcd,"%d",disp_sensor);
        lcd_puts(lcd);
        }
    
    for(i=0;i<8;i++)
        {
        disp_sensor=0;
        disp_sensor=rear_sensor>>i;
        disp_sensor=(disp_sensor)&(0b00000001);
        n=i;
        lcd_gotoxy(n,1);
        sprintf(lcd,"%d",disp_sensor);
        lcd_puts(lcd);
        }     
    if(adc_menu<=120){delay_ms(400);break;}
    if(back==0){delay_ms(400);tampil_menu();};
    }
       
    selesai:
    }
    
}

void main(void)
{

pwm_off();
// LCD module initialization
lcd_init(16);
init_IO();
init_ADC();
backlight=1;
led=0;
lcd_gotoxy(2,0);
lcd_putsf("Do-Car LPKTA");
lcd_gotoxy(1,1);
lcd_putsf("TF FT UGM 2009");

delay_ms(1000);
led=1;
backlight=0;
delay_ms(200);
led=0;
backlight=1;
delay_ms(200);
led=1;
delay_ms(200);
led=0;
backlight=0;
delay_ms(500);
backlight=1;
led=1;

temp_speed=speed   =e_speed;
min_kp  =e_min_kp;
max_kp  =e_max_kp;
per4an_enable=e_per4an_enable;
kp_div  =e_kp_div;   
 

for(i=0;i<=10;i++)
{
langkah_nos[i]=e_langkah_nos[i];
langkah_cepat[i]=e_langkah_cepat[i];
}
   

for(i=0;i<8;i++)
    {
    adc_tres1[i]=e_adc_tres1[i];
    adc_tres2[i]=e_adc_tres2[i];
    }

     

while (1)
    {  
    tampil_siap();
    }
}

interrupt [TIM0_COMP] void timer0_comp_isr(void)
{   
    
//led=0;    
//for(i=0;i<8;i++)
//    {
//        if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
//        else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
//        else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
//        else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
//        else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
//        else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
//        else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
//        else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
//        //adc_result1[i]=read_adc(7);//depan
//        adc_result2[i]=read_adc(6);//belakang
//    }  
////adc_result_top=read_adc(1);
//
//for(i=0;i<8;i++)
//    {
//    //if      (adc_result1[i]>adc_tres1[i]){front_sensor=front_sensor|1<<i;}
//    //else if (adc_result1[i]<adc_tres1[i]){front_sensor=front_sensor|0<<i;}
//    
//    if      (adc_result2[i]>adc_tres2[i]){rear_sensor=rear_sensor|1<<i;}
//    else if (adc_result2[i]<adc_tres2[i]){rear_sensor=rear_sensor|0<<i;}
//    }          
//    
//rear_sensor=rear_sensor&0b01111110;
//     

//strategi 2 berarti mengeksekusi per4an                         
 if(white_line==0)
 {       
    if(error>=-11&&error<=11)
    {
        if      (rear_sensor==0b00001000){right_back=20;}
        else if (rear_sensor==0b00010000){left_back=20;}
        else if (rear_sensor==0b00011000){left_back=20;right_back=20;}
        else if (rear_sensor==0b00000100){right_back=20;}
        else if (rear_sensor==0b00100000){left_back=20;}
        else if (rear_sensor==0b00100100){left_back=20;right_back=20;}
        else if (rear_sensor==0b00000010){right_back=20;}
        else if (rear_sensor==0b01000000){left_back=20;}
        //else if (rear_sensor==0b00001100){right_back=8;}
        //else if (rear_sensor==0b00110000){left_back=8;}
        //else if (rear_sensor==0b00011000){left_back=8;right_back=8;}
        //else if (rear_sensor==0b00000110){right_back=8;}
        //else if (rear_sensor==0b01100000){left_back=8;}
        //else if (rear_sensor==0b01100110){left_back=8;right_back=8;}
        else if (rear_sensor==0b01000100){left_back=20;right_back=20;}
        else if (rear_sensor==0b00100010){left_back=20;right_back=20;}
        else if (rear_sensor==0b00010100){left_back=20;right_back=20;}
        else if (rear_sensor==0b00101000){left_back=20;right_back=20;}
        
    }
 }
     
    if(right_back>0)
    {
    right_back--; 
    }
     if(left_back>0)
    {
    left_back--;
    }
    
    if(left_back>0&&right_back>0)
        {
         backlight=1;
         led=0; 
         backlight_on=15;   
         led_on=15;
       
        if(strategi==2||strategi==4)
          {
          if(flag_per4an==0)
          per4an_handler();
          }
         if(strategi==3)
         {
           if(flag_per4an==0)
           if(white_line==0&&siku>4)
           per4an_handler();
         }     
        }
        else if(left_back==0||right_back==0)
        {
        flag_per4an=0;
        }
     
    count=0;
}


////--------Routine Menghitung Langkah kanan------//
////--------Routine Menghitung Langkah kanan------//
interrupt [EXT_INT0] void ext_int0_isr(void)
{
langkah_kanan++; langkah++;

if(langkah<step)
{
   led=0;
   led_on=3;
   speed=speed+20; 
   if(speed>255)speed=255;
}

else 
{
   langkah=0;
   step=0;
   speed=temp_speed;
}

}

// interrupt [EXT_INT1] void ext_int1_isr(void)
// {
// 
// langkah_kanan++; langkah++;
// 
// if(langkah<step)
// {
//    led=0;
//    led_on=3;
//    speed=speed+20; 
//    if(speed>255)speed=255;
// }
// 
// else 
// {
//    langkah=0;
//    step=0;
//    speed=temp_speed;
// }
// 
// 
// }




