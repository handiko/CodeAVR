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

#include <mega32.h>
#include <stdio.h>
#include <math.h>

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
 
bit per4an_status, pwm_en,black_line=1,status_per3an,per4an_enable=0,multiline_status=0,per4an_dir=0,status_nos,status_nos_before;
unsigned char i_temp, menu, kp_div=13,status_sensor,front_sensor4, menu_slave, strategi,temp_adc_menu,counter_nos,nos_ke,counter_nos_off=0;
unsigned char adc_result1[8],adc_result2[8],adc_result_top,adc_tres1[8],adc_tres2[8],adc_menu,lcd[16];
unsigned char max_adc1[8],max_adc2[8],min_adc1[8],min_adc2[8];
unsigned char i,j,n,front_sensor,rear_sensor,disp_sensor,top_sensor,backlight_on,led_on,right_back,left_back;
int i_speed,speed,MV,error,error_before,d_error,min_kp,max_kp,kp,kd,speed_ka,speed_ki,temp_speed;
int langkah_kanan,langkah_kiri,langkah,y_fork,do_nos[20],count_step[20],toleransi=10,step_kanan=0,step_kiri=0,step=0;
int time=0, usec1=0, usec0=0, sec1=0, sec0=0, min0=0, min1=0,temp_sec=0;  
unsigned char v_kanan=0, v_kiri=0, per4an_sampling=0,per4an;
int langkah_per4an[3],sigma_langkah;
eeprom int e_speed=200,e_min_kp=8,e_max_kp=30;
eeprom unsigned char e_adc_tres1[8]={100,100,100,100,100,100,100,100};
eeprom unsigned char e_adc_tres2[8]={100,100,100,100,100,100,100,100};
eeprom unsigned char e_per3an_enable=0;
eeprom unsigned char e_kp_div=13;
eeprom unsigned char e_per4an_dir=0;
eeprom unsigned char e_per4an_enable=0;
eeprom int e_langkah_per4an[3];
eeprom unsigned char e_toleransi=100;



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
void screensaver()
{
j=16;
for(;;)
{
adc_menu=read_adc(0);
adc_menu=255-adc_menu;
lcd_clear();
lcd_gotoxy(j,1);
lcd_putchar('R');
lcd_putchar('O');
lcd_putchar('B');
lcd_putchar('O');
lcd_putchar('L');
lcd_putchar('I');
lcd_putchar('N');
lcd_putchar('E');
lcd_putchar(' ');
lcd_putchar('U');
lcd_putchar('G');
lcd_putchar('M');
lcd_putchar(' ');
lcd_putchar('0');
lcd_putchar('9');

lcd_gotoxy(j,0);
lcd_putchar(' ');
lcd_putchar('B');
lcd_putchar('E');
lcd_putchar(' ');
lcd_putchar('A');
lcd_putchar(' ');
lcd_putchar('W');
lcd_putchar('I');
lcd_putchar('N');
lcd_putchar('N');
lcd_putchar('E');
lcd_putchar('R');
lcd_putchar(' ');
j--;
delay_ms(70);
if(j==0)delay_ms(300);
else if(j==250)break;
if(enter==0)break;
if(back==0)break;
if(temp_adc_menu!=adc_menu)break;
temp_adc_menu=adc_menu;

}
}

void init_IO()
{ 
DDRA=0b00000000;
PORTA=0b00000000;

DDRB=0b11111111;
PORTB=0b00000000;

DDRC=0b11111100;
PORTC=0b10000011;

DDRD= 0b01110010;
PORTD=0b10001100;
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
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x03;
OCR0=0x00;
TCNT0=6;
TIFR=0x00;
TIMSK=0x01;
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
GICR|=0xC0;
MCUCR=0x0A;
MCUCSR=0x00;
GIFR=0xC0;
TIFR=0x00;
// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;
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



void display_time()
{   
for(;;)
    {
    if(temp_sec!=sec0)lcd_clear(); 
    lcd_gotoxy(14,0);
    sprintf(lcd,"%d",step);
    lcd_puts(lcd);
    lcd_gotoxy (4,1);
    sprintf(lcd,"%d%d:%d%d:%d%d",min1,min0,sec1,sec0,usec1,usec0);
    lcd_puts(lcd);
    temp_sec=sec0;
    
    if(back==0)break;
    if(enter==0)break;
    }
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
if      (adc_result_top>adc_tres1[4])top_sensor=1;
else if (adc_result_top<adc_tres1[4])top_sensor=0;
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

lcd_gotoxy(9,0);
sprintf(lcd,"%d",error);
lcd_puts(lcd);
    
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
    
    for(i=0;i<6;i++)
        {
        if(i<3) menu=i;
        else    menu=i+2;
        disp_sensor=0;
        disp_sensor=rear_sensor>>menu;
        disp_sensor=(disp_sensor)&(0b00000001);
        n=5-i;
        lcd_gotoxy(n,1);
        sprintf(lcd,"%d",disp_sensor);
        lcd_puts(lcd);
        }     
        
lcd_gotoxy(6,1);
sprintf(lcd,"%d",top_sensor);
lcd_puts(lcd);

lcd_gotoxy(7,1);
sprintf(lcd,"%d",speed_ki); 
lcd_puts(lcd);
   
lcd_gotoxy(12,1); 
sprintf(lcd,"%d",speed_ka); 
lcd_puts(lcd);

lcd_gotoxy(12,0);
sprintf(lcd,"%d",langkah);
lcd_puts(lcd);

lcd_gotoxy(15,1);
if(per4an_dir==1)lcd_putchar('>');
else if(per4an_dir==0)lcd_putchar('<'); 

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
} 


void giving_weight10()
{
switch(front_sensor)
    {
    case 0b00000001:error=  15;break;
    case 0b00000010:error=  10;break;
    case 0b00000100:error=   5;break;
    case 0b00001000:error=   1;break;
    case 0b00010000:error=  -1;break;
    case 0b00100000:error=  -5;break;
    case 0b01000000:error= -10;break;
    case 0b10000000:error= -15;break;
    }
}


void giving_weight20()
{
switch(front_sensor)
    {
    case 0b00000011:error=  13;break;
    case 0b00000110:error=   7;break;
    case 0b00001100:error=   3;break;
    case 0b00011000:error=   0;break;
    case 0b00110000:error=  -3;break;
    case 0b01100000:error=  -7;break;
    case 0b11000000:error= -13;break;
    }
}


void giving_weight30()
{
switch(front_sensor)
    {
    case 0b00000111:error=  11;break;
    case 0b00001110:error=   5;break;
    case 0b00011100:error=   1;break;
    case 0b00111000:error=  -1;break;
    case 0b01110000:error=  -5;break;
    case 0b11100000:error= -11;break;
    }                           
}

void giving_weight40()
{
switch(front_sensor)
    {
    case 0b00001111:error=   7;break;
    case 0b00011110:error=   3;break;
    case 0b00111100:error=   0;break;
    case 0b01111000:error=  -3;break;
    case 0b11110000:error=  -7;break;
    }
}

void giving_weight_per4an()
{    
switch(front_sensor)
    {
    case 0b10011001:per4an_sampling++; break;
    case 0b10010001:per4an_sampling++; break;
    case 0b10001001:per4an_sampling++; break;
    case 0b10010011:per4an_sampling++; break;
    
    case 0b01010011:per4an_sampling++; break;
    case 0b11010010:per4an_sampling++; break;
    //case 0b00110001:per4an_sampling++;  break;
    //case 0b00110011:per4an_sampling++;  break;
    
    case 0b00111100:per4an_sampling++; break;
    case 0b00111110:per4an_sampling++; break;
    case 0b01111100:per4an_sampling++; break;   

    case 0b10111101:per4an_sampling++; break;
    
    case 0b11001001:per4an_sampling++; break;
    case 0b11011011:per4an_sampling++; break;
    
    case 0b01011010:per4an_sampling++; break;
    case 0b01001010:per4an_sampling++; break;
    case 0b01010010:per4an_sampling++; break;
    
    case 0b10100011:per4an_sampling++; break;
    case 0b10100010:per4an_sampling++; break;    
    case 0b10100001:per4an_sampling++; break;
     
    case 0b11000101:per4an_sampling++; break;
    case 0b01100101:per4an_sampling++; break;    
    case 0b10000101:per4an_sampling++; break;
    
    case 0b11111110:per4an_sampling++; break;
    case 0b01111111:per4an_sampling++; break;
    
    case 0b10111110:per4an_sampling++; break;
    case 0b01111101:per4an_sampling++; break;
    
    case 0b10011011:per4an_sampling++; break;
    case 0b11011001:per4an_sampling++; break;
    
    case 0b10011110:per4an_sampling++; break;
    case 0b01111001:per4an_sampling++; break;
    
    case 0b01111110:per4an_sampling++; break;
    //case 0b11001100:v_kiri++;  break;
    //case 0b10001100:v_kiri++;  break;
    }
}


void per4an_handler()
{   
    
    backlight=1;
    led=0;
    intrpt_on(); 
    if(strategi==1)
    {
        if      (per4an==1)langkah=langkah_per4an[1];
        else if (per4an==2)langkah=langkah_per4an[2];
        else               langkah=0;
    }
    
    if(per4an==3)
    {
        if(per4an_enable==1)
        {
            if(per4an_dir==0)//pilih kiri
                {
                    speed_ka=0.8*speed;
                    speed_ki=-0.8*speed;
                    pwm_out();
                    delay_ms(100);
                }
            else if(per4an_dir==1)//pilih_kanan
                {  
                    speed_ka=0.8*speed;
                    speed_ki=-0.8*speed;
                    pwm_out();
                    delay_ms(100);
                }
            per4an++;
        }
    }
    per4an++;
    delay_ms(50);
}

void y_fork_handler()
{
backlight=1;

error=-11;
for(;;)
    {
     delay_ms(2);
     giving_weight10();
     giving_weight20();
     giving_weight30();
     komp_pid();
     pwm_out();
     if(-5>=error<=5)break;
    }
y_fork++;

} 

void giving_weight_y_fork()
{
switch(front_sensor)
    {                                       
    //case 0b00100100: status_per3an=1;y_fork_handler();break;
    //case 0b00100110: status_per3an=1;y_fork_handler();break;
    case 0b00100001: status_per3an=1;y_fork_handler();break;
    case 0b00100011: status_per3an=1;y_fork_handler();break;
    //case 0b00100111: status_per3an=1;y_fork_handler();break;
    case 0b01100001: status_per3an=1;y_fork_handler();break;
    case 0b01100011: status_per3an=1;y_fork_handler();break;
    //case 0b01100111: status_per3an=1;y_fork_handler();break;
    case 0b01000001: status_per3an=1;y_fork_handler();break;
    case 0b01000011: status_per3an=1;y_fork_handler();break;
    case 0b01000111: status_per3an=1;y_fork_handler();break; 
    case 0b11000001: status_per3an=1;y_fork_handler();break;
    case 0b11000011: status_per3an=1;y_fork_handler();break;
    case 0b11000111: status_per3an=1;y_fork_handler();break;
    case 0b10000001: status_per3an=1;y_fork_handler();break;
    case 0b10000011: status_per3an=1;y_fork_handler();break;
    case 0b10000111: status_per3an=1;y_fork_handler();break;
    case 0b11100001: status_per3an=1;y_fork_handler();break;
    case 0b11100011: status_per3an=1;y_fork_handler();break;
    case 0b11100010: status_per3an=1;y_fork_handler();break;
    //case 0b11100110: status_per3an=1;y_fork_handler();break;  
    case 0b01000100: status_per3an=1;y_fork_handler();break;
    case 0b01000110: status_per3an=1;y_fork_handler();break;
    case 0b01000010: status_per3an=1;y_fork_handler();break;
    case 0b11000100: status_per3an=1;y_fork_handler();break;
    case 0b11000110: status_per3an=1;y_fork_handler();break;
    case 0b11000010: status_per3an=1;y_fork_handler();break;
    case 0b10000110: status_per3an=1;y_fork_handler();break;
    case 0b10000010: status_per3an=1;y_fork_handler();break;


    }
}                




void line_following()
{
read_sensor();
lcd_clear();
    

if(right_back>0)
    {
    right_back--;
    if(left_back>0)backlight_on=10;
    }
if(left_back>0)
    {
    left_back--;
    if(right_back>0)backlight_on=10;
    }
    
if(backlight_on>0){backlight_on--;backlight=1;}
else               backlight=0; 
    
if(led_on>0){led_on--;led=0;}
else         led=1;
    
if(i_speed<speed)   i_speed=i_speed+3;
else                i_speed=speed;
    
black_line=1;

if(strategi==1);
{
    if(langkah!=0){led=0;speed=speed+20;}
    else    {speed=temp_speed;intrpt_off();}
    
    if(speed>=180)speed=180;
    else speed=speed;

}

kp=speed/kp_div;
kd=3*kp;


giving_weight10();
giving_weight20();
giving_weight30();
giving_weight40();
giving_weight_per4an();                       

if      (per4an_sampling ==2)per4an_handler();
else if (per4an_sampling>2)per4an_sampling=0; 


komp_pid();
    
// if(error>-11&&error<11)
//     {
//         if      (rear_sensor==0b00001000)right_back=15;
//         else if (rear_sensor==0b00010000)left_back=15;
//         else if (rear_sensor==0b00011000)backlight_on=10;
//     }
    
    
//-----------------kondisi khusus menggunakan sensor belakang-----------------//    
if(front_sensor==0)           
    {  
        if      (rear_sensor==0b00000100)       //sudut 45   
                {
                speed_ki=-(0.8)*speed;
                speed_ka=0.4*speed;
                pwm_out();
                for(;;){read_sensor();delay_ms(2);if(front_sensor!=0)break;}
                }
                
        else if (rear_sensor==0b00100000)       //sudut 45   
                {
                speed_ki=0.4*speed;
                speed_ka=-(0.8)*speed;
                pwm_out();
                for(;;){read_sensor();delay_ms(2);if(front_sensor!=0)break;}
                }
                
        else if (rear_sensor==0b00000010)       //sudut 30   
                {
                speed_ki=-(0.9)*speed;
                speed_ka=0.4*speed;
                pwm_out();
                for(;;){read_sensor();delay_ms(2);if(front_sensor!=0)break;}
                }
        else if (rear_sensor==0b01000000)       //sudut 30   
                {
                speed_ki=0.4*speed;
                speed_ka=-(0.9)*speed;
                pwm_out();
                for(;;){read_sensor();delay_ms(2);if(front_sensor!=0)break;}
                }
        
        else if (rear_sensor==0b10000000)       //sudut 30   
                {
                led=0;
                //speed_ki=0.6*speed;
                //speed_ka=-(0.8)*speed;
                error=-11;
                komp_pid();
                pwm_out();
                for(;;){read_sensor();delay_ms(2);if(front_sensor!=0)break;}
                }
        
        else if (rear_sensor==0b00000001)       //sudut 30   
                { 
                led=0;
                //speed_ki=-(0.6)*speed;
                //speed_ka=(0.8)*speed;
                error=11;
                komp_pid();
                pwm_out();
                for(;;){read_sensor();delay_ms(2);if(front_sensor!=0)break;}
                }
        
   }                        
    
    
pwm_out();
}
//--------------------------------------------------------------------------------//

void action()
{
j=0; 

for(;;)
    {   
    line_following();
    
    if(j>=200)
        {
        if(enter==0){lcd_clear();init_time_off();display_time();break;}
        if(back==0) {lcd_clear();init_time_off();display_time();break;}
        }
    j++;
    if(j>200)j=200;
    delay_us(700);
    }
pwm_off();
intrpt_off();
backlight=0;

led=1;
backlight=0;
delay_ms(250);
}

void tampil_auto_set()
{
lcd_gotoxy(0,0);
sprintf(lcd,"%d%d%d%d%d%d%d%d",adc_tres1[0]/5,adc_tres1[1]/5,adc_tres1[2]/5,adc_tres1[3]/5,adc_tres1[4]/5,adc_tres1[5]/5,adc_tres1[6]/5,adc_tres1[7]/5);
lcd_puts(lcd);

lcd_gotoxy(0,1);
sprintf(lcd,"%d%d%d%d%d%d%d%d",adc_tres2[0]/5,adc_tres2[1]/5,adc_tres2[2]/5,adc_tres2[3]/5,adc_tres2[4]/5,adc_tres2[5]/5,adc_tres2[6]/5,adc_tres2[7]/5);
lcd_puts(lcd);
    
for(;;)
    {
    delay_ms(200);
    if(enter==0)
        {
        delay_ms(200);
        break;
        }
    if(back==0)goto selesai;
    }
    
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
        adc_tres1[i]=min_adc1[i]+((max_adc1[i]-min_adc1[i])/2);
        
        delay_us(50);
        lcd_gotoxy((i*2),0);
        sprintf(lcd,"%d",max_adc1[i]/9);
        lcd_puts(lcd);
        }
       
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
        if(adc_result2[i]>max_adc2[i])max_adc2[i]=adc_result2[i];        
        if(adc_result2[i]<max_adc2[i])min_adc2[i]=adc_result2[i];        
        adc_tres2[i]=min_adc2[i]+((max_adc2[i]-min_adc2[i])/2);
        delay_us(50);
                
        lcd_gotoxy((i*2),1);
        sprintf(lcd,"%d",max_adc2[i]/10);
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
    
    if(enter==0){e_speed=adc_menu;speed=adc_menu;delay_ms(400);break;}
    if(back==0){delay_ms(400);break;}
    delay_ms(50);
    }
}

void atur_toleransi()
{
lcd_gotoxy(0,1);
sprintf(lcd,"=%d",toleransi);
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
    
    if(enter==0){e_toleransi=toleransi;toleransi=adc_menu;delay_ms(400);break;}
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

void eksekusi_per4an_3()
{

for(;;)
    {
    adc_menu=read_adc(0);
    adc_menu=255-adc_menu;
    
    if  (adc_menu<=50)per4an_dir=0;
    else per4an_dir=1;
    
    lcd_gotoxy(0,1);
    if     (e_per4an_dir==0)lcd_putsf("left");
    else if(e_per4an_dir==1)lcd_putsf("right");
    
    lcd_gotoxy(7,1);
    lcd_putsf("<-");
    if     (per4an_dir==0)lcd_putsf("left");
    else if(per4an_dir==1)lcd_putsf("right");
    
    if(enter==0){e_per4an_dir=per4an_dir;per4an_dir=per4an_dir;delay_ms(400);break;}
    if(back==0){delay_ms(400);break;}
    delay_ms(50);
    }
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
    sprintf(lcd," <- %d",kp_div);
    lcd_puts(lcd);
    
    if(enter==0){e_kp_div=adc_menu/3;kp_div=adc_menu/3;delay_ms(400);break;}
    if(back==0){delay_ms(400);break;}
    delay_ms(50);
    }
}

void ambil_langkah()
{ 

lcd_clear();
intrpt_on();
speed_ka=5;
speed_ki=5;
for(;;)
    {
    lcd_gotoxy(0,0);
    lcd_putsf("Per4an 1");
    
    lcd_gotoxy(0,1);
    sprintf(lcd,"%d",langkah_per4an[1]);
    lcd_puts(lcd);
    sprintf(lcd,"<- %d",sigma_langkah);
    lcd_puts(lcd);
    
    if(enter==0){e_langkah_per4an[1]=sigma_langkah;langkah_per4an[i]=sigma_langkah;intrpt_off();lcd_clear();delay_ms(400);break;}
    if(back==0){delay_ms(400);break;}
    delay_ms(50);
    }
intrpt_on();    
for(;;)
    {
    lcd_gotoxy(0,0);
    lcd_putsf("Per4an 2");
    
    lcd_gotoxy(0,1);
    sprintf(lcd,"%d",langkah_per4an[2]);
    lcd_puts(lcd);
    sprintf(lcd,"<- %d",sigma_langkah);
    lcd_puts(lcd);
    
    if(enter==0){e_langkah_per4an[2]=sigma_langkah;langkah_per4an[2]=sigma_langkah;intrpt_off();lcd_clear();delay_ms(400);break;}
    if(back==0){delay_ms(400);break;}
    delay_ms(50);
    }
}   

void uji_langkah()
{
intrpt_on();
lcd_clear();
for(;;)
    {   
        speed_ka=10;
        speed_ki=10;
        lcd_gotoxy(0,0);
        lcd_putsf("KR=");
        lcd_gotoxy(3,0);
        sprintf(lcd," %d",step_kiri);
        lcd_puts(lcd);
        lcd_gotoxy(8,0);
        lcd_putsf("KN=");
        lcd_gotoxy(11,0);
        sprintf(lcd," %d",step_kanan);
        lcd_puts(lcd);                        
        
               
        lcd_gotoxy(0,1);
        lcd_putsf("langkah=");
        lcd_gotoxy(8,1);
        sprintf(lcd," %d",step);
        lcd_puts(lcd);
        
        if(back==0){intrpt_off();delay_ms(50);break;}
    }
}


slave_menu()
{
    menu_slave=0;
    temp_adc_menu=0;
    for(;;)
    {
    adc_menu=read_adc(0);
    adc_menu=255-adc_menu;
    if(temp_adc_menu!=adc_menu)lcd_clear();
    lcd_gotoxy(0,0);
    
    if (adc_menu<=40)  
        {
        lcd_putsf("1. Uji Langkah ");
        menu_slave=1;
        }
    else if (adc_menu<=120)  
        {
        lcd_putsf("2. Arah Per4an");
        menu_slave=2;
        }
    else if (adc_menu<=160)
        {
        lcd_putsf("3. Pembagi Kp");
        menu_slave=3;
        }
    else if (adc_menu<=210)
        {
        lcd_putsf("4. Toleransi");
        menu_slave=4;
        }
    else if (adc_menu<=255)
        {
        lcd_putsf("5. Ambil_langkah");
        menu_slave=5;
        }     
    if(enter==0)
    {   
        delay_ms(300);
        if      (menu_slave==1)uji_langkah();
        else if (menu_slave==2)eksekusi_per4an_3();
        else if (menu_slave==3)pembagi_kp(); 
        else if (menu_slave==4)atur_toleransi();
        else if (menu_slave==5)ambil_langkah();  
    }
       if(back==0){delay_ms(400);menu_slave=0;break;}
       
    temp_adc_menu=adc_menu;     
    }                            
    
    
}

void tampil_menu()
{
menu=0;
for(;;)
    {
    adc_menu=read_adc(0);
    adc_menu=255-adc_menu;
    lcd_clear();
    lcd_gotoxy(0,0);
    if      (adc_menu<=40)  
        {
        lcd_putsf("1. Speed ");
        menu=1;
        }
    else if (adc_menu<=255)  
        {
        lcd_putsf("2. Auto Set ");
        menu=2;
        }
        
    if(enter==0)
        {
        delay_ms(400);
        if      (menu==2)
            {
            for(i=0;i<8;i++)
                {
                min_adc1[i]=255;
                min_adc2[i]=255;
                max_adc1[i]=0;
                max_adc2[i]=0;
                }
            tampil_auto_set();
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
    time=0; usec0=0; usec1=0; sec0=0; sec1=0; min0=0; min1=0;
    lcd_clear();
    i=0;
    n=0;
    langkah=0;
    langkah_kanan=0;
    langkah_kiri=0;
    adc_menu=read_adc(0);
    adc_menu=255-adc_menu;
    nos_ke=1;
    counter_nos=0;
    counter_nos_off=0;
    v_kanan=0;
    v_kiri=0;
    per4an_sampling=0;
    per4an=1;
    
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("RUN?");
    
        kp=speed/kp_div;
        kd=3*kp;   
        
    lcd_gotoxy(0,1);
    
    if(adc_menu<=60)strategi=1;
    else if(adc_menu<=180)strategi=2;
    else if(adc_menu<=255)strategi=3;
    
    if      (strategi==1)lcd_putsf("Complete");
    else if (strategi==2)lcd_putsf("Without Counter");
    else if (strategi==3)lcd_putsf("Scanning Track");
       
    delay_ms(200);
    if(back==0){delay_ms(250);tampil_menu();goto start;}
    if(enter==0)
        {
        i=0;
        while(enter==0){delay_ms(10);i++;if(i>200)i=200;}
        if(i>30)    {pwm_off();i_speed=50;action();goto start;}
        else        {pwm_on();i_speed=50;action();init_time_on();goto start;}
        }
        
//     while(enter!=0&&back!=0&&(adc_menu==temp_adc_menu))
//         {
//         i++;
//         if(i>100){n++;i=0;}
//         delay_ms(10);
//         if(n>6){n=2;screensaver();}
//         }
    temp_adc_menu=adc_menu;    
    }
}

void main(void)
{

// LCD module initialization
lcd_init(16);
init_IO();
init_ADC();
backlight=1;
led=0;
lcd_gotoxy(3,0);
lcd_putsf("OM_HUNGRY");
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

temp_speed=speed   =e_speed;
min_kp  =e_min_kp;
max_kp  =e_max_kp;
per4an_enable=e_per4an_enable;
kp_div  =e_kp_div;
toleransi=e_toleransi;

for(i=0;i<3;i++)
    {
    langkah_per4an[i]=e_langkah_per4an[i];
    }   

for(i=0;i<8;i++)
    {
    adc_tres1[i]=e_adc_tres1[i];
    adc_tres2[i]=e_adc_tres2[i];
    }
        
while (1)
    {  
    tampil_siap();
    };
}

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{   
    TCNT0=6;
    time++;
    if(time>=4)
    {
        time=0;
        usec0++;
    }
    if(usec0>=10)
    {
        usec0=0;
        usec1++;
    }
    if(usec1>=10)
    {
        usec1=0;
        sec0++;
    }
    if(sec0>=10)
    {
        sec0=0;
        sec1++;
    }
    if(sec1>=6)
    {
        sec1=0;
        min0++;
    }
    if(min0>=10)
    {
        min0=0;
        min1++;
    }
    
}


//--------Routine Menghitung Langkah kanan------//
interrupt [EXT_INT0] void ext_int0_isr(void)
{      

if(speed_ka>0)
    {
    langkah_kanan++;
    step_kanan++;
    }
    
if(speed_ka<0)
    {
    langkah_kanan--;
    step_kanan--;
    }
    
sigma_langkah=0.5*langkah_kiri+0.5*langkah_kanan;
langkah=langkah-sigma_langkah;
}
//-----------------------------------------------//


//--------Routine Menghitung Langkah Kiri--------//
interrupt [EXT_INT1] void ext_int1_isr(void)
{

if(speed_ki>0)
    {
    langkah_kiri++;
    step_kiri++;
    }
    
if(speed_ka<0)
    {
    langkah_kiri--;
    step_kiri--;
    }

sigma_langkah=0.5*langkah_kiri+0.5*langkah_kanan;
langkah=langkah-sigma_langkah;
}
//-----------------------------------------------//




