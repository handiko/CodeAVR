/*****************************************************
This program was produced by the
CodeWizardAVR V1.24.6 Professional
Automatic Program Generator
© Copyright 1998-2005 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com
e-mail:office@hpinfotech.com

Project : 
Version : 
Date    : 5/20/2009
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 8.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega16.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>

// Declare your global variables here

#include <delay.h>    
#include <stdio.h>
#include <math.h>

#define ADC_VREF_TYPE 0x60
#define tom_menu PINC.4
#define tom_plus PINC.5   
#define tom_min PINC.6
#define tom_enter PINC.7  
                           
unsigned char rear_sensor1,rear_sensor2,adc_tres_rear1,adc_tres_rear2,adc_result[8],speed,kp,kd; 
unsigned char i,adc_rear1,adc_rear2,front_sensor,adc_tres[8],data_tres1,data_tres2,sen_max[8],sen_max_tres1;
unsigned char lcd,sen_max_tres2,select,hasil_scan[8],hasil_scan_tres1,hasil_scan_tres2,j,data_awal[8];
unsigned char n,display_sensor,mode_kal,adc_front,data_front1,sen_max_front,hasil_scan_tresfront,adc_tres_front,front_sensor1;
char data[16],dir;
int error,d_error,error_before,MV,nil_kanan,nil_kiri;               
unsigned char eeprom eep_adc_tres[8] = {100,100,100,100,100,100,100,100};    
unsigned char eeprom eep_adc_tres_rear2 = 100;
unsigned char eeprom eep_adc_tres_rear1 = 100;
unsigned char eeprom eep_speed = 100;
unsigned char eeprom eep_adc_tres_front = 100;



unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input|ADC_VREF_TYPE;
ADCSRA|=0x40;
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}
              
void init_ADC()
{
ADMUX=ADC_VREF_TYPE;
ADCSRA=0x87;
}
 
void init_IO()
{
DDRA=0b00001110;
PORTA=0b00000000;

PORTB=0b00000000;
DDRB=0b11111111;


PORTC=0b11110011;
DDRC=0b00001100;


DDRD=0b11111111;
PORTD=0b00001000;
}                

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

void tampilkan_lcd(unsigned char kolom,unsigned char baris,int variabel_tampilan)
        {
        lcd_gotoxy(kolom,baris);
        sprintf(data,"%d",variabel_tampilan);
        lcd_puts(data);
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
    case 0b00000111:error=  10;break;
    case 0b00001110:error=   5;break;
    case 0b00011100:error=   1;break;
    case 0b00111000:error=  -1;break;
    case 0b01110000:error=  -5;break;
    case 0b11100000:error= -10;break;
    }                           
}

   
void baca_sensor()
{
for(i=0;i<8;i++)
    {
    if     (i==0){PORTA.1=0;PORTA.2=0;PORTA.3=0;}
    else if(i==1){PORTA.1=0;PORTA.2=0;PORTA.3=1;}
    else if(i==2){PORTA.1=0;PORTA.2=1;PORTA.3=0;}
    else if(i==3){PORTA.1=0;PORTA.2=1;PORTA.3=1;}
    else if(i==4){PORTA.1=1;PORTA.2=0;PORTA.3=0;}
    else if(i==5){PORTA.1=1;PORTA.2=0;PORTA.3=1;}
    else if(i==6){PORTA.1=1;PORTA.2=1;PORTA.3=0;}
    else if(i==7){PORTA.1=1;PORTA.2=1;PORTA.3=1;}
    adc_result[i]=read_adc(0);//depan
    }                                 
 adc_rear1=read_adc(4);
 adc_rear2=read_adc(5);   
 adc_front=read_adc(7);
}                         

void read_sensor()
{
front_sensor=0;
rear_sensor1=0;
rear_sensor2=0;

for(i=0;i<8;i++)
    {
        if     (i==0){PORTA.1=0;PORTA.2=0;PORTA.3=0;}
        else if(i==1){PORTA.1=0;PORTA.2=0;PORTA.3=1;}
        else if(i==2){PORTA.1=0;PORTA.2=1;PORTA.3=0;}
        else if(i==3){PORTA.1=0;PORTA.2=1;PORTA.3=1;}
        else if(i==4){PORTA.1=1;PORTA.2=0;PORTA.3=0;}
        else if(i==5){PORTA.1=1;PORTA.2=0;PORTA.3=1;}
        else if(i==6){PORTA.1=1;PORTA.2=1;PORTA.3=0;}
        else if(i==7){PORTA.1=1;PORTA.2=1;PORTA.3=1;}
    adc_result[i]=read_adc(0);//depan
    }                                 
 adc_rear1=read_adc(4);
 adc_rear2=read_adc(5);                      
 adc_front=read_adc(7);


for(i=0;i<8;i++)
    {
    if      (adc_result[i]>adc_tres[i]){front_sensor=front_sensor|1<<i;}
    else if (adc_result[i]<adc_tres[i]){front_sensor=front_sensor|0<<i;}
    }                          
    
if(adc_rear1>adc_tres_rear1)rear_sensor1=1;
else if(adc_rear1<adc_tres_rear1)rear_sensor1=0;              

if(adc_rear2>adc_tres_rear2)rear_sensor2=1;
else if(adc_rear2<adc_tres_rear2)rear_sensor2=0;
                                                
if(adc_front>adc_tres_front)front_sensor1=1;
else if(adc_front<adc_tres_front)front_sensor1=0;

              
    
// if   (line_color_status==1){front_sensor=~front_sensor;rear_sensor1=~rear_sensor1; rear_sensor2=~rear_sensor2;}
// else                       {front_sensor=front_sensor; rear_sensor1=rear_sensor1; rear_sensor2=rear_sensor2;}                                                                      
}      


void kanan_maju(unsigned char kanan)
{
PORTD.6=0;
PORTD.7=1;
OCR1AL=kanan;
}

void kanan_mundur(unsigned char kanan)
{
PORTD.6=1;
PORTD.7=0;
OCR1AL=kanan;
}

void kiri_mundur(unsigned char kiri)
{
PORTC.2=0;
PORTC.3=1;
OCR1BL=kiri;
}

void kiri_maju(unsigned char kiri)
{
PORTC.2=1;
PORTC.3=0;
OCR1BL=kiri;     
}

void out_pwm()
{
if (nil_kanan >255)    
    {
    nil_kanan  =255;          
    kanan_maju(nil_kanan);  
    goto akhir_kanan;
    }
else if (nil_kanan >=0)     
    {
    kanan_maju(nil_kanan);
    goto akhir_kanan;
    }
else if (nil_kanan <-255)   
    {
    nil_kanan  =-255;          
    kanan_mundur(-nil_kanan);
    goto akhir_kanan;
    }
else if (nil_kanan <0)      
    { 
    kanan_mundur(-nil_kanan);
    goto akhir_kanan;
    };
akhir_kanan:

if (nil_kiri >255)     
    {
    nil_kiri   =255;          
    kiri_maju(nil_kiri);  
    goto akhir_kiri;
    }
else if (nil_kiri >=0)      
    {
    kiri_maju(nil_kiri);
    goto akhir_kiri;
    }
else if (nil_kiri <-255)    
    {
    nil_kiri   =-255;          
    kiri_mundur(-nil_kiri);
    goto akhir_kiri;
    }
else if (nil_kiri <0)       
    {
    kiri_mundur(-nil_kiri);
    goto akhir_kiri;
    };
akhir_kiri:

if(nil_kiri>=0) {dir='F';}
else            {dir='R';}

lcd_gotoxy(0,1);
sprintf(data,"%d%c",nil_kiri,dir); 
lcd_puts(data);

if(nil_kanan>=0){dir='F';}
else            {dir='R';}
   
lcd_gotoxy(5,1); 
sprintf(data,"%d%c",nil_kanan,dir); 
lcd_puts(data);

}                  

void komp_pid()
{
d_error =error-error_before;
MV      =(kp*error)+(kd*d_error);

nil_kanan=speed+MV;
nil_kiri=speed-MV;

error_before=error;
}     

void atur_speed()
{

speed=eep_speed;

atur_nos:    
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("speed=");
tampilkan_lcd(10,0,eep_speed);
lcd_gotoxy(0,1);
lcd_putsf("ubah=");
tampilkan_lcd(10,1,speed);    
delay_ms(15);  
while(1)
{       
if (tom_plus==0)
        {
        speed++;
        if (speed==256){speed=0;}    
        lcd_gotoxy(10,1);
        sprintf(data,"%d",speed);
        lcd_puts(data);
        }    
 else {delay_ms(10);}                        
if (tom_min==0)
        {
        speed--;
        if (speed==-1){speed=255;} 
        lcd_gotoxy(10,1);
        sprintf(data,"%d",speed);
        lcd_puts(data);
        }                    
    
 else { delay_ms(10);}          
if (tom_enter==0)
        {goto simpan_nos;}
if (tom_menu==0){goto fin_nos;}
else {goto atur_nos;}
       
     
simpan_nos:
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("speed");
lcd_gotoxy(0,1);
lcd_putsf("save?");
delay_ms(500);
if (tom_enter==0)
        {
        lcd_gotoxy(0,1);
        lcd_putsf("saved...");
        eep_speed=speed;
        kp=speed/15;  
        kd=kp*3;
        delay_ms(500);
        goto fin_nos;
        }
if (tom_menu==0){goto fin_nos;}
else {goto atur_nos;}
       
     
// simpan_nos:
//         lcd_gotoxy(0,1);
//         lcd_putsf("saved...");
//         eep_speed=speed;
//         kp=speed/13; 
//         kd=kp*4;  
//         delay_ms(500);
//         goto fin_nos;
        
if (tom_menu==0){goto fin_nos;}
else {goto atur_nos;}
}
fin_nos:
}           

void auto_scan()
{        

lcd_clear();
_mulai:
lcd_gotoxy(0,0);
lcd_putsf("auto scan");
lcd_gotoxy(0,1);
lcd_putsf("mulai...?");
delay_ms(100);
if (tom_enter==0){goto A_scan;}
if (tom_menu==0){goto fin_scan;}
else {goto _mulai;}

A_scan: 
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("lagi nyecan nih..");
for(i=0;i<8;i++){data_awal[i]=10;}
data_tres1=10;
data_tres2=10;
data_front1=10;
for(;;)
{  
delay_ms(6);
baca_sensor();
        for(i=0;i<8;i++)
        {
        sen_max[i]=max(adc_result[i],data_awal[i]);
        }                                         
        sen_max_tres1=max(adc_rear1,data_tres1);
        sen_max_tres2=max(adc_rear2,data_tres2);
        sen_max_front=max(adc_front,data_front1);
        for(i=0;i<8;i++)
        {
        data_awal[i]=sen_max[i];
        }
        
        data_tres1=sen_max_tres1;
        data_tres2=sen_max_tres2;                
        data_front1=sen_max_front;
        if (tom_menu==0){break;}                 
         
}            
               
for (i=0;i<8;i++)
{
hasil_scan[i]=0.6 * data_awal[i];
}                                

hasil_scan_tres1=0.6 * data_tres1;
hasil_scan_tres2=0.6 * data_tres2;
hasil_scan_tresfront=0.6 * data_front1;

lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("finish"); 
lcd_gotoxy(0,1);
lcd_putsf("save...?");

 
_hasil:
delay_ms(150);        
if (tom_enter==0){goto ask_saving_batas;}   
else goto _hasil;
        
ask_saving_batas:
lcd_clear();
    
    for (i=0;i<8;i++) {eep_adc_tres[i]=hasil_scan[i];}
    eep_adc_tres_rear1=hasil_scan_tres1;
    eep_adc_tres_rear2=hasil_scan_tres2;
    eep_adc_tres_front=hasil_scan_tresfront;
    
    delay_ms(10);
       
    for (i=0;i<8;i++) {adc_tres[i]=eep_adc_tres[i];}
    adc_tres_rear1=eep_adc_tres_rear1;
    adc_tres_rear2=eep_adc_tres_rear2;      
    adc_tres_front=eep_adc_tres_front;
    
    goto batas_saved;

batas_saved:
lcd_gotoxy(0,1);
lcd_putsf("saved...");
delay_ms(250);
goto fin_scan;
        
fin_scan:        
}                    

void jalan()
{
pwm_on();       
for(;;)
{
delay_ms(1); 
read_sensor();
for(i=0;i<8;i++)
        {
        display_sensor=0;
        display_sensor=front_sensor>>i;
        display_sensor=(display_sensor)&(0b00000001);
        n=11-i;
        lcd_gotoxy(n,0);
        sprintf(data,"%d",display_sensor);
        lcd_puts(data);
        }                    
        
        lcd_gotoxy(0,0);
        sprintf(data,"%d",rear_sensor1);
        lcd_puts(data);
        
        lcd_gotoxy(13,0);  
        sprintf(data,"%d",rear_sensor2);
        lcd_puts(data);
        
                   
giving_weight10();
giving_weight20();
giving_weight30();  
komp_pid();
out_pwm();        
if(tom_menu==0){pwm_off();break;}      
// if((rear_sensor1=1)||(rear_sensor2=1))
// {pwm_off();
// lcd_clear();
// lcd_gotoxy(0,0);
// PORTB.3=1;
// lcd_putsf("checkpoint");
// break;}
             
}                         

}         

void display_front_adc()
{
        for(;;)
        {
        lcd_clear();
        baca_sensor();
        for(i=0;i<4;i++)
                {
                n=(4*i);
                lcd_gotoxy(n,0);
                sprintf(data,"%d",adc_result[i]);
                lcd_puts(data);
                }              
        for(i=4;i<8;i++)
                {  
                n=(4*i)-16;
                lcd_gotoxy(n,1);
                sprintf(data,"%d",adc_result[i]);
                lcd_puts(data);                
                }              
        delay_ms(80);
        if(tom_menu==0){break;}
        }
}

void display_rear_adc()
{
        for(;;)
        {
        lcd_clear();
        baca_sensor();
        
        lcd_gotoxy(0,1);
        sprintf(data,"%d",adc_rear1);
        lcd_puts(data);
        
         lcd_gotoxy(13,1);
         sprintf(data,"%d",adc_rear2);
         lcd_puts(data);
         
         lcd_gotoxy(5,0);
         sprintf(data,"%d",adc_front);
         lcd_puts(data);
         
        delay_ms(80);
        if(tom_menu==0){break;}
        
        }
}       

void display_konv_sensor()
{
        for(;;)
        {
        lcd_clear();
        read_sensor();
        
        for(i=0;i<8;i++)
        {
        display_sensor=0;
        display_sensor=front_sensor>>i;
        display_sensor=(display_sensor)&(0b00000001);
        n=11-i;
        lcd_gotoxy(n,0);
        sprintf(data,"%d",display_sensor);
        lcd_puts(data);
        }                    
        
        lcd_gotoxy(3,1);
        sprintf(data,"%d",rear_sensor1);
        lcd_puts(data);
        
        lcd_gotoxy(13,1);  
        sprintf(data,"%d",rear_sensor2);
        lcd_puts(data);               
                        
        lcd_gotoxy(7,1);
        sprintf(data,"%d",front_sensor1);
        lcd_puts(data);
        
        delay_ms(80);
        if(tom_menu==0){break;}
        
        
        
        }
}
     
void display_calibrate()
{ 
mode_kal=1;
_kal_menu:
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("   >calibrate<   ");


if(tom_plus==0)
    {
    mode_kal++;
    if(mode_kal==4)  {mode_kal=1;}
    }
if(tom_min==0)
    {
    mode_kal--;
    if(mode_kal==0)  {mode_kal=3;}
    }

switch(mode_kal)
    {
    case 1: 
        lcd_gotoxy(0,1);
        lcd_putsf("1.frontsensor   ");
        break;
    case 2:
        lcd_gotoxy(0,1);
        lcd_putsf("2.rearsensor    ");
        break;
    case 3:
        lcd_gotoxy(0,1);
        lcd_putsf("3.konv.sensor   ");
        break;           
    }
delay_ms(300);

if(tom_enter==0)
    {
    switch(mode_kal)
        {
        case 1:display_front_adc();break;
        case 2:display_rear_adc();break;
        case 3:display_konv_sensor();break;

        }
    goto _kal_menu;
    }
if(tom_menu==0){goto fin_set;}
else goto _kal_menu;

fin_set:
} 
void main_menu()
{     
select=1;
while (1){

main:         
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("-----MENU-----");    

if (tom_plus==0)       
        { select++;
        if (select==5){select=1;}
        }
if (tom_min==0)
        { select--;
        if (select==0){select=4;}
        }  
if (tom_menu==0)
        {goto fin_main;}
        
switch (select)
        {
        case 1: lcd_gotoxy(0,1);
                lcd_putsf("     >Run<     ");break;
        case 2: lcd_gotoxy(0,1);
                lcd_putsf("    >speed<    ");break;
        case 3: lcd_gotoxy(0,1);
                lcd_putsf("   >autoset<   ");break;
        case 4: lcd_gotoxy(0,1);
                lcd_putsf("  >calibrate<  ");break;
        default:break;
        }     
delay_ms(150);

if (tom_enter==0)
{
switch (select)
        {
        case 1:jalan();break;
        case 2:atur_speed();break;   
        case 3:auto_scan();break;
        case 4:display_calibrate();break;                      
        }
        goto main;
 }
 else {delay_ms(85);}
 }                      
 fin_main:
}
void main()
{
init_IO();
init_ADC();
lcd_init(16);
for (i=0;i<8;i++) {adc_tres[i]=eep_adc_tres[i];}
adc_tres_rear1=eep_adc_tres_rear1;
adc_tres_rear2=eep_adc_tres_rear2;
speed=eep_speed;                  
kp=speed/15; 
kd=kp*3;
PORTB.3=1;
lcd_gotoxy(0,0);
lcd_putsf("OM-HUNGRY");
lcd_gotoxy(0,1);
lcd_putsf("CINTA");         
delay_ms(1000);
PORTB.3=0;
while (1)
{
main_menu();
}

}