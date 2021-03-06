/*****************************************************
This program was produced by the
CodeWizardAVR V2.04.4a Advanced
Automatic Program Generator
� Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 30/10/2010
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

#include <mega16.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
#include <lcd.h>
#include <delay.h>
#include <stdio.h>
#include <math.h>

#define ADC_VREF_TYPE 0x60    
#define frontlight PORTC.7
#define cancel    PIND.7
#define enter     PINC.0
//#define sub      PINC.2
//#define add      PINC.1
#define pwm_ki   OCR1AL
#define pwm_ka   OCR1BL
#define dir_ki   PORTD.6 
#define dir_ka   PORTD.1 
#define backlight PORTB.3

// Declare your global variables here
char data[16],dir_kanan,dir_kiri;
unsigned char adc_result[8],adc_frontkanan,adc_frontkiri,adc_rearkanan,adc_rearkiri;
unsigned char front_sensor,i,adc_tres[8],adc_tres_fkanan,adc_tres_fkiri,adc_tres_rkanan,adc_tres_rkiri;
int sen_max[8],sen_max_fkanan,sen_max_fkiri,sen_max_rkanan,sen_max_rkiri,hasil_scan[8],hasil_scan_tresfkanan,hasil_scan_tresfkiri;
int sen_min[8],sen_min_fkanan,sen_min_fkiri,sen_min_rkanan,sen_min_rkiri;
unsigned char hasil_scan_tresrkiri,hasil_scan_tresrkanan,display_sensor,n,select,kd,kp,speed,haruka,satomi_kanan,satomi_kiri;      
unsigned char fork_status,gita,song_hye_kyo,kosong_status,hitam_status;
int koga,aki,ishihara,detik;
int nil_kanan,nil_kiri,d_error,MV,error_before,error;            
bit data_right,data_right1,data_right2,front_kanan,front_kiri;
bit data_left,data_left1,data_left2,rear_kanan,rear_kiri,depan;
unsigned char adc_menu;

 

unsigned char eeprom eep_adc_tres[8]= {100,100,100,100,100,100,100,100};
unsigned char eeprom eep_tresfkanan = 100;
unsigned char eeprom eep_tresfkiri = 100;
unsigned char eeprom eep_tresrkanan = 100;
unsigned char eeprom eep_tresrkiri  = 100;
unsigned char eeprom eep_speed   =150;  
unsigned char eeprom eep_kp   =14;
unsigned char eeprom eep_kd   =15; 
unsigned char eeprom eep_gita   =1;


unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
delay_us(10); // Delay needed for the stabilization of the ADC input voltage
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}              
   
// Timer 0 output compare interrupt service routine
interrupt [TIM0_COMP] void timer0_comp_isr(void)
{
aki++;
        if (aki==100)
        {      
        aki=0;
        koga++;
                if(koga==100)
                {
                koga=0;
                ishihara++;
                        if(ishihara==10)
                                {
                                ishihara=0;
                                detik++;
                                }
                }
        }

}

              
void init_ADC()
{
ADMUX=ADC_VREF_TYPE;
ADCSRA=0x87;
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

void init(void)
{

PORTA=0x00;
DDRA=0x00;


PORTB=0x00;
DDRB=0b00001000;


PORTC=0b00000111;
DDRC=0b11110000;


PORTD=0b10000000;
DDRD=0b01110010;

// LCD module initialization
lcd_init(16);  

// Global enable interrupts

     

}
            
void timer_on()
{
// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 1000.000 kHz
// Mode: CTC top=OCR0
// OC0 output: Disconnected
TCCR0=0x0A;
TCNT0=0x00;
OCR0=0x0A;
TIMSK=0x02;   
koga=ishihara=detik=aki=0;   
#asm("sei")      
  
}         

void timer_off()
{
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;   
TIMSK=0x00;     
#asm("cli")     

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

void giving_weight11()
{
switch(front_sensor)
    {
    case 0b11111110:error=  15;break;
    case 0b11111101:error=  10;break;
    case 0b11111011:error=   5;break;
    case 0b11110111:error=   1;break;
    case 0b11101111:error=  -1;break;
    case 0b11011111:error=  -5;break;
    case 0b10111111:error= -10;break;
    case 0b01111111:error= -15;break;
    }
}


void giving_weight21()
{
switch(front_sensor)
    {
    case 0b11111100:error=  13;break;
    case 0b11111001:error=   7;break;
    case 0b11110011:error=   3;break;
    case 0b11100111:error=   0;break;
    case 0b11001111:error=  -3;break;
    case 0b10011111:error=  -7;break;
    case 0b00111111:error= -13;break;
    }
}

void giving_weight31()
{
switch(front_sensor)
    {
    case 0b11111000:error=  10;break;
    case 0b11110001:error=   5;break;
    case 0b11100011:error=   1;break;
    case 0b11000111:error=  -1;break;
    case 0b10001111:error=  -5;break;
    case 0b00011111:error= -10;break;
    }                           
}

void baca_sensor()
{

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
        adc_result[i]=read_adc(7);//depan
    }        
    
 adc_rearkanan=read_adc(3);
 adc_rearkiri=read_adc(1);
} 

void konversi_sensor()
{
front_kanan=0;
front_kiri=0;
rear_kiri=0;
rear_kanan=0; 
front_sensor=0;

baca_sensor();


for(i=0;i<8;i++)
    {
    if      (adc_result[i]>adc_tres[i]){front_sensor=front_sensor|1<<i;}
    else if (adc_result[i]<adc_tres[i]){front_sensor=front_sensor|0<<i;}
    }                          
    

                                                
if(adc_result[0]>adc_tres[0])front_kiri=1;
// else if(adc_result[0]<adc_tres[0])front_kiri=0;

if(adc_result[7]>adc_tres[7])front_kanan=1;
//else if(adc_result[7]<adc_tres[7])front_kanan=0;

if(adc_rearkanan>adc_tres_rkanan)rear_kanan=1;
else if(adc_rearkanan<adc_tres_rkanan)rear_kanan=0;

if(adc_rearkiri>adc_tres_rkiri)rear_kiri=1;
else if(adc_rearkiri<adc_tres_rkiri)rear_kiri=0;


}  
 
// void simpan_kanan()
// {   
// data_right=rear_kanan;
// data_right1=data_right;
// data_right2=data_right1;
// data_right3=data_right2;
// data_right4=data_right3;
// data_right5=data_right4;
// data_right6=data_right5;      
// // data_right7=data_right6;
// // data_right8=data_right7;
// 
// if (data_right==1||data_right1==1||data_right2==1||data_right3==1||data_right4==1||data_right5==1||data_right6)
// 
// {                                                                                                                                                                                                             
// kanan_status_flag=1;
// }                      
// // ||(data_right2==1&&data_right3==1)||(data_right3==1&&data_right4==1)||(data_right4==1&&data_right5==1)||(data_right5==1&&data_right6==1))
// // if (data_right==1||data_right1==1||data_right2==1||data_right3==1||data_right4==1||data_right5==1||data_right6==1||data_right7==1||data_right8==1)
// //  {                                                                                                                                                                                                             
// //  kanan_status_flag=1;
// //  }
// }
// 
// void simpan_kiri()
// {   
// data_left=rear_kiri;
// data_left1=data_left;
// data_left2=data_left1;
// data_left3=data_left2;
// data_left4=data_left3;
// data_left5=data_left4;
// data_left6=data_left5;  
// // data_left7=data_left6;
// // data_left8=data_left7;
// 
// if (data_left==1||data_left1==1||data_left2==1||data_left3==1||data_left4==1)
// 
// {                                                                                                                                                                                                             
// kiri_status_flag=1;
// }
// 
// // (data_left2==1&&data_left3==1)||(data_left3==1&&data_left4==1)||(data_left4==1&&data_left5==1)||(data_left5==1&&data_left6==1))
// // if (data_left==1||data_left1==1||data_left2==1||data_left3==1||data_left4==1||data_left5==1||data_left6==1||data_left7||data_left8)
// //  {                                                                                                                                                                                                             
// //  kiri_status_flag=1;
// //  }
//}  

void display_backadc()
{    
for(;;)
{
lcd_clear();
baca_sensor();
lcd_gotoxy(0,0);
sprintf(data,"%d",adc_frontkiri);
lcd_puts(data);                  

lcd_gotoxy(13,0);
sprintf(data,"%d",adc_frontkanan);
lcd_puts(data);                   

lcd_gotoxy(0,1);
sprintf(data,"%d",adc_rearkiri);
lcd_puts(data);            

lcd_gotoxy(13,1);
sprintf(data,"%d",adc_rearkanan);
lcd_puts(data);                  
      
delay_ms(150);
if (cancel==0)
{break;}



}

}

void display_konversi()
{

for(;;)
        {
        lcd_clear();
        konversi_sensor();
        
         for(i=0;i<8;i++)
        {
        display_sensor=0;
        display_sensor=front_sensor>>i;
        display_sensor=(display_sensor)&(0b00000001);
        n=7-i;
        lcd_gotoxy(n,0);
        sprintf(data,"%d",display_sensor);
        lcd_puts(data);
        }
                   
        lcd_gotoxy(0,1);
        sprintf(data,"%d",front_kiri);
        lcd_puts(data);
                       
        lcd_gotoxy(5,1);
        sprintf(data,"%d",rear_kiri);
        lcd_puts(data);
        
        lcd_gotoxy(10,1);
        sprintf(data,"%d",rear_kanan);
        lcd_puts(data);               
        
        lcd_gotoxy(15,1);
        sprintf(data,"%d",front_kanan);
        lcd_puts(data);
        
        
        delay_ms(80);
        if(cancel==0){break;}
        
        
        
        }

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
if (enter==0){goto A_scan;}
if (cancel==0){goto fin_scan;}
else {goto _mulai;}

A_scan: 
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("lagi nyecan nih..");
for(i=0;i<8;i++){sen_max[i]=10;}
sen_max_fkanan=10;
sen_max_fkiri=10;
sen_max_rkanan=10;
sen_max_rkiri=10;
for(i=0;i<8;i++){sen_min[i]=100;}
sen_min_fkanan=100;
sen_min_fkiri=100;
sen_min_rkanan=100;
sen_min_rkiri=100;
for(;;)
{  
delay_ms(6);
baca_sensor();
        for(i=0;i<8;i++)
        {
        sen_max[i]=max(adc_result[i],sen_max[i]);
        }                                         
        sen_max_fkanan=max(adc_frontkanan,sen_max_fkanan);
        sen_max_fkiri=max(adc_frontkiri,sen_max_fkiri);
        sen_max_rkanan=max(adc_rearkanan,sen_max_rkanan);
        sen_max_rkiri=max(adc_rearkiri,sen_max_rkiri);
        for(i=0;i<8;i++)
        {
        sen_min[i]=min(adc_result[i],sen_min[i]);
        }                                         
        sen_min_fkanan=min(adc_frontkanan,sen_min_fkanan);
        sen_min_fkiri=min(adc_frontkiri,sen_min_fkiri);
        sen_min_rkanan=min(adc_rearkanan,sen_min_rkanan);
        sen_min_rkiri=min(adc_rearkiri,sen_min_rkiri);
        if (cancel==0){break;}                 
         
}            
               
for (i=0;i<8;i++)
{
hasil_scan[i]=(sen_min[i]+((sen_max[i]-sen_min[i])*0.25));
}                                

hasil_scan_tresfkanan=(sen_min_fkanan+((sen_max_fkanan-sen_min_fkanan)*0.25));
hasil_scan_tresfkiri=(sen_min_fkiri+((sen_max_fkiri-sen_min_fkiri)*0.25));
hasil_scan_tresrkanan=(sen_min_rkanan+((sen_max_rkanan-sen_min_rkanan)*0.25));
hasil_scan_tresrkiri=(sen_min_rkiri+((sen_max_rkiri-sen_min_rkiri)*0.25));   


lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("finish"); 
lcd_gotoxy(0,1);
lcd_putsf("save...?");

 
_hasil:
delay_ms(150);        
if (enter==0){goto ask_saving_batas;}   
else goto _hasil;
        
ask_saving_batas:
lcd_clear();
    
    for (i=0;i<8;i++) {eep_adc_tres[i]=hasil_scan[i];}
    eep_tresfkanan=hasil_scan_tresfkanan;
    eep_tresfkiri=hasil_scan_tresfkiri;
    eep_tresrkanan=hasil_scan_tresrkanan;    
    eep_tresrkiri=hasil_scan_tresrkiri;
    
    delay_ms(10);
       
    for (i=0;i<8;i++) {adc_tres[i]=eep_adc_tres[i];}
    adc_tres_fkanan=eep_tresfkanan;
    adc_tres_fkiri=eep_tresfkiri;      
    adc_tres_rkanan=eep_tresrkanan;
    adc_tres_rkiri=eep_tresrkiri;
    
    goto batas_saved;

batas_saved:
lcd_gotoxy(0,1);
lcd_putsf("saved   ");
delay_ms(150);     
lcd_gotoxy(0,1);
lcd_putsf("saved.  ");
delay_ms(150);   
lcd_gotoxy(0,1);
lcd_putsf("saved.. ");
delay_ms(150);    
lcd_gotoxy(0,1);
lcd_putsf("saved...");
delay_ms(150);
goto fin_scan;
        
fin_scan:                

}  

void kanan_maju(unsigned char kanan)
{
dir_ka=0;
pwm_ka=kanan;
}

void kanan_mundur(unsigned char kanan)
{      
dir_ka=1;
pwm_ka=255-kanan;
}

void kiri_maju(unsigned char kiri)
{
dir_ki=0;
pwm_ki=kiri;
}

void kiri_mundur(unsigned char kiri)
{  
dir_ki=1;
pwm_ki=255-kiri;
}                     




void komp_pid()
{
d_error =error-error_before;
MV      =(kp*error)+(kd*d_error);

nil_kanan=speed+MV;
nil_kiri=speed-MV;

error_before=error;
}     


void out_pwm()
{
if (nil_kanan >255)    
    {          
    nil_kanan=255;
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
    nil_kanan=-255;
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
    nil_kiri=255; 
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
    nil_kiri=-255;
    kiri_mundur(-nil_kiri);
    goto akhir_kiri;
    }
else if (nil_kiri <0)       
    {
    kiri_mundur(-nil_kiri);
    goto akhir_kiri;
    };
akhir_kiri:

if(nil_kiri>=0) {dir_kiri='F';}
else            {dir_kiri='R';}

if(nil_kanan>=0) {dir_kanan='F';}
else            {dir_kanan='R';}

    
    for(i=0;i<8;i++)
        {
        display_sensor=0;
        display_sensor=front_sensor>>i;
        display_sensor=(display_sensor)&(0b00000001);
        n=7-i;
        lcd_gotoxy(n,0);
        sprintf(data,"%d",display_sensor);
        lcd_puts(data);
        }

lcd_gotoxy(9,0);
sprintf(data,"%d",error);
lcd_puts(data);
    
lcd_gotoxy(0,1);
sprintf(data,"%d%c  %d%c",nil_kiri,dir_kiri, nil_kanan,dir_kanan);
lcd_puts(data); 

delay_ms(5);
}
                      
void display_front_sensor()
{    

for(;;)
{ 
lcd_clear();
baca_sensor();
sprintf(data,"%d",adc_result[0]);
lcd_gotoxy(0,0);
lcd_puts(data);

sprintf(data,"%d",adc_result[1]);
lcd_gotoxy(4,0);
lcd_puts(data);

sprintf(data,"%d",adc_result[2]);
lcd_gotoxy(8,0);
lcd_puts(data);

sprintf(data,"%d",adc_result[3]);
lcd_gotoxy(12,0);
lcd_puts(data);

sprintf(data,"%d",adc_result[4]);
lcd_gotoxy(0,1);
lcd_puts(data);

sprintf(data,"%d",adc_result[5]);
lcd_gotoxy(4,1);
lcd_puts(data);

sprintf(data,"%d",adc_result[6]);
lcd_gotoxy(8,1);
lcd_puts(data);

sprintf(data,"%d",adc_result[7]);
lcd_gotoxy(12,1);
lcd_puts(data);

delay_ms(250);
if (cancel==0) break;

}
}
void set_speed()
{
atur_speed: 
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("speed=");
tampilkan_lcd(10,0,eep_speed);
lcd_gotoxy(0,1);
lcd_putsf("ubah=");
tampilkan_lcd(10,1,speed);    
delay_ms(15);  


/*
if (add==0)
        {
        speed++;
        lcd_gotoxy(10,1);
        sprintf(data,"%d",speed);
        lcd_puts(data);
        }                       
if (sub==0)
        {
        speed--;
        lcd_gotoxy(10,1);
        sprintf(data,"%d",speed);
        lcd_puts(data);
        } 
*/                   
 
adc_menu=read_adc(0);
adc_menu=255-adc_menu;

speed=adc_menu;
lcd_gotoxy(10,1);
sprintf(data,"%d",speed);
lcd_puts(data);

   
 delay_ms(120); 
if (enter==0)
        {goto simpan_speed;}
else if (cancel==0){goto fin_speed;}
else {goto atur_speed;}
       
     
simpan_speed:
lcd_clear();
lcd_gotoxy(0,1);
lcd_putsf("saved...");
eep_speed=speed;  
song_hye_kyo=speed;
delay_ms(500);      
kp=speed/15; 
kd=kp*4;  
eep_kp=kp;
eep_kd=kd;
delay_ms(500);

fin_speed:
}          

void inisial()
{   
gita=eep_gita;
kp=eep_kp;
kd=eep_kd;
speed=eep_speed; 
song_hye_kyo=eep_speed;
for (i=0;i<8;i++) {adc_tres[i]=eep_adc_tres[i];}
    adc_tres_fkanan=eep_tresfkanan;
    adc_tres_fkiri=eep_tresfkiri;      
    adc_tres_rkanan=eep_tresrkanan;
    adc_tres_rkiri=eep_tresrkiri;      
data_left=0;
data_left1=0;
data_right=0;
data_right1=0;
satomi_kanan=0;
satomi_kiri=0;
                                     
haruka=0;
}        

void pid_diam()
{             
for(;;)
{
konversi_sensor();
giving_weight10();
giving_weight20();
giving_weight30();
d_error =error-error_before;
MV      =(8*error)+(10*d_error);

nil_kanan=MV;
nil_kiri=-MV;

out_pwm();
error_before=error;
if (error>=-3&& error<=3){break;}
delay_ms(1);

}
}   

void pid_diam_lambat()
{             
for(;;)
{
konversi_sensor();
giving_weight10();
giving_weight20();
giving_weight30();
d_error =error-error_before;
MV      =(7*error)+(10*d_error);

nil_kanan=MV;
nil_kiri=-MV;

out_pwm();
error_before=error;
if (error>=-1&& error<=1){break;}
delay_ms(1);

}
}   

void pid_diam_hitam()
{             
for(;;)
{
konversi_sensor();
giving_weight11();
giving_weight21();
giving_weight31();
d_error =error-error_before;
MV      =(12*error)+(10*d_error);

nil_kanan=MV;
nil_kiri=-MV;

out_pwm();
error_before=error;
if (error>=-2&& error<=2){break;}
delay_ms(1);

}
}   


void kanan_tajam()
{  
for(;;)
{
kanan_mundur(130);
kiri_maju(90);
baca_sensor();
if (adc_result[7]>adc_tres[7]||adc_result[6]>adc_tres[6]||adc_result[5]>adc_tres[5]||adc_result[4]>adc_tres[4])
        {break;}
delay_ms(3);
}
error=-12;
pid_diam(); 
// data_right=data_right1=data_right2=data_right3=data_right4=data_right5=data_right6=0;
// data_left=data_left1=data_left2=data_left3=data_left4=data_left5=data_left6=0;
// kanan_status_flag=0;
// kiri_status_flag=0;
}               
             
void kanan_tajam_lambat()
{  
for(;;)
{
kanan_mundur(130);
kiri_maju(90);
baca_sensor();
if (adc_result[7]>adc_tres[7]||adc_result[6]>adc_tres[6]||adc_result[5]>adc_tres[5]||adc_result[4]>adc_tres[4])
        {break;}
delay_ms(3);
}
error=-12;
pid_diam_lambat(); 
// data_right=data_right1=data_right2=data_right3=data_right4=data_right5=data_right6=0;
// data_left=data_left1=data_left2=data_left3=data_left4=data_left5=data_left6=0;
// kanan_status_flag=0;
// kiri_status_flag=0;
}            
void kanan_tajam_hitam()
{  
for(;;)
{
kanan_mundur(130);
kiri_maju(90);
baca_sensor();
if (adc_result[7]<adc_tres[7]||adc_result[6]<adc_tres[6]||adc_result[5]<adc_tres[5]||adc_result[4]<adc_tres[4])
        {break;}
delay_ms(3);
}
error=-12;
pid_diam_hitam(); 
// data_right=data_right1=data_right2=data_right3=data_right4=data_right5=data_right6=0;
// data_left=data_left1=data_left2=data_left3=data_left4=data_left5=data_left6=0;
// kanan_status_flag=0;
// kiri_status_flag=0;
}

void kiri_tajam()
{     
for(;;)
{
baca_sensor();
kiri_mundur(130);
kanan_maju(90);

if (adc_result[0]>adc_tres[0]||adc_result[1]>adc_tres[1]||adc_result[2]>adc_tres[2]||adc_result[3]>adc_tres[3])
        {break;}
delay_ms(3);
}     
error=12;
pid_diam(); 
// data_right=data_right1=data_right2=data_right3=data_right4=data_right5=data_right6=0;
// data_left=data_left1=data_left2=data_left3=data_left4=data_left5=data_left6=0;
// kanan_status_flag=0;
// kiri_status_flag=0;
}
       
       
void kiri_tajam_lambat()
{     
for(;;)
{
baca_sensor();
kiri_mundur(130);
kanan_maju(90);

if (adc_result[0]>adc_tres[0]||adc_result[1]>adc_tres[1]||adc_result[2]>adc_tres[2]||adc_result[3]>adc_tres[3])
        {break;}
delay_ms(3);
}     
error=12;
pid_diam_lambat(); 
// data_right=data_right1=data_right2=data_right3=data_right4=data_right5=data_right6=0;
// data_left=data_left1=data_left2=data_left3=data_left4=data_left5=data_left6=0;
// kanan_status_flag=0;
// kiri_status_flag=0;
}
       
void cek_translasi()
{  
backlight=1;
hitam_status=0;   
speed=song_hye_kyo-10;  
pwm_on();
for(;;)
{   
delay_ms(1); 
lcd_clear();     
 
konversi_sensor();  
giving_weight10();
giving_weight20();
giving_weight30();
giving_weight11();
giving_weight21();
giving_weight31();    

if (front_sensor==0b11111111)
        {
        if (rear_kanan==0)
                { 
                kanan_mundur(120);
                kiri_mundur(120);
                delay_ms(50);  
                kanan_tajam_hitam();
                }
        }
                             
komp_pid();
out_pwm();  
if (rear_kanan==0&&rear_kiri==0){hitam_status++;}
if (hitam_status>1){break;}

}
backlight=0;
}                 

void cek_motong()
{   
speed=song_hye_kyo-20;
fork_status=0;
pwm_on();
for(;;)
{    
delay_ms(1);       
lcd_clear();     
if (haruka>0) {haruka--;backlight=1;} 
else if(haruka==0) {backlight=0;}    
konversi_sensor();  
giving_weight10();
giving_weight20();
giving_weight30();
              
if (front_kiri==1)         
        {
                
                haruka=12;
                fork_status++;     
                
        }
                              
        

          
komp_pid();
out_pwm();  
if (fork_status>1){break;}

}

}
   
void cek_p1()
{ 
backlight=0;   
hitam_status=0;     
pwm_on(); 
speed=250; 
for(;;)
{    
lcd_clear(); 

delay_ms(1);           
konversi_sensor();  
giving_weight10();
giving_weight20();
giving_weight30();
giving_weight11();
giving_weight21();
giving_weight31();
                                       
komp_pid();
out_pwm();                   
if (rear_kanan==1&&rear_kiri==1){hitam_status++;}
if (hitam_status>1){break;}       

if (cancel==0){kanan_maju(0);kiri_maju(0);}


}  

}
void cek_p2()
{        
fork_status=0;
speed=song_hye_kyo; 
pwm_on();
for(;;)
{   
delay_ms(1); 
lcd_clear();     
if (haruka>0) {haruka--;backlight=1;} 
else if(haruka==0) {backlight=0;}     
if (satomi_kanan>0) {satomi_kanan--;}
if (satomi_kiri>0) {satomi_kiri--;}
if (front_kanan>0) {front_kanan--;}
if (front_kiri>0)  {front_kiri--;}
           
 
konversi_sensor();  
giving_weight10();
giving_weight20();
giving_weight30();
                   
        

if (front_sensor==0b00000000)
        {     
                        if (data_right==1||data_right1==1)
                        {          
//                         front_kanan=0; 
//                         kanan_mundur(100);
//                         kiri_mundur(100);
//                         delay_ms(20);
                        error=-15;
                        pid_diam_lambat();
                        }       
                
                        else if (data_left==1||data_left==1)
                        {  
//                         front_kiri=0;
//                         kanan_mundur(100);
//                         kiri_mundur(100);
//                         delay_ms(20);
                        error=15;
                        pid_diam_lambat();
                        }   
                
                        else if (rear_kanan==1&&error>-8)
                        { 
                
                        kanan_mundur(120);
                        kiri_mundur(120);
                        delay_ms(50);
                        kanan_tajam_lambat();
                        }                
                
                        else if (rear_kiri==1)
                        {    
                        kanan_mundur(120);
                        kiri_mundur(120);
                        delay_ms(50);                
                        kiri_tajam_lambat();
    
                
                        }       
                 
                }
 
 if (front_sensor==0b011111110||front_sensor==0b011111100||front_sensor==0b001111110)
        {
        fork_status++;
        depan=1;
        }       
              
 if (rear_kanan==1)         
        {
        satomi_kanan=20;
                if(rear_kiri==1)
                {haruka=20; satomi_kanan=0;satomi_kiri=0;fork_status++;}     
                else if(satomi_kiri>0)
                {
                haruka=20; satomi_kanan=0;satomi_kiri=0;fork_status++;depan=0;
                }
        }
                              
else if (rear_kiri==1)
        {
       satomi_kiri=20;
                if(satomi_kanan>0)
                {
                haruka=20; satomi_kanan=0;satomi_kiri=0;  fork_status++;depan=0;
                }
        }
          
komp_pid();
out_pwm();  
if (fork_status>0){break;}
data_right=front_kanan;
data_right1=data_right;   

data_left=front_kiri;
data_left1=data_left;



if (cancel==0){kanan_maju(0);kiri_maju(0);}

}
}



 
void cek_fin()
{     
speed=song_hye_kyo;     
kosong_status=0;
pwm_on();
for(;;)
{       
delay_ms(1); 
lcd_clear();   
if (front_kanan>0) {front_kanan--;}
if (front_kiri>0)  {front_kiri--;}            
konversi_sensor();  
giving_weight10();
giving_weight20();
giving_weight30();


if (front_sensor==0b00000000)
        {     
        
                        if (front_kanan>0)
                        {          
                        front_kanan=0;
                        error=-15;
                        pid_diam();
                        }       
                
                        else if (front_kiri>0)
                        {  
                        front_kiri=0;
                        error=15;
                        pid_diam();
                        }   
                
                        else if (rear_kanan==1)
                        { 
                
                        kanan_mundur(120);
                        kiri_mundur(120);
                        delay_ms(50);
                        kanan_tajam();
                        }                
                
                        else if (rear_kiri==1)
                        {    
                        kanan_mundur(120);
                        kiri_mundur(120);
                        delay_ms(50);                
                        kiri_tajam();
    
                
                        }       
                 
                }
        
             
        
         
komp_pid();
out_pwm();  

if (cancel==0){kanan_maju(0);kiri_maju(0);break;}

}
}

void pid_murni()
{  
speed=song_hye_kyo;
pwm_on();
for(;;)
{  
delay_ms(1);  
if (front_kanan>0) {front_kanan--;}
if (front_kiri>0)  {front_kiri--;}   
lcd_clear();     
konversi_sensor();  
giving_weight10();
giving_weight20();
giving_weight30();

/*
if (front_sensor==0b00000000)
       {
              
                kosong_status=0;
                        if (front_kanan>0)
                        {          
                        front_kanan=0;
                        error=-15;
                        pid_diam();
                        }       
                
                        else if (front_kiri>0)
                        {  
                        front_kiri=0;
                        error=15;
                        pid_diam();
                        }   
                
                        else if (rear_kanan==1&&error>-8)
                        { 
                
                        kanan_mundur(120);
                        kiri_mundur(120);
                        delay_ms(50);
                        kanan_tajam();
                        }                
                
                        else if (rear_kiri==1)
                        {    
                        kanan_mundur(120);
                        kiri_mundur(120);
                        delay_ms(50);                
                        kiri_tajam();
    
                
                        }       
                 
                
        }
*/
         
komp_pid();
out_pwm();  

if (cancel==0){kanan_maju(0);kiri_maju(0);break;}

}
}    

void action()
{
//if (gita==1) {goto cp1;}



cp1:  


cek_p1(); 
cek_translasi();

cp2:
cek_p2(); 
if (depan==1)
        {
        speed=speed-20;
        for(;;)
                {
        konversi_sensor();  
        giving_weight10();
        giving_weight20();
        giving_weight30();
                if(rear_kanan==1||rear_kiri==1)
                {
                break;
                } 
        komp_pid();
        out_pwm();  
        
                   
        delay_ms(1);
                
                }
        }    
else {goto lanjut1;}
lanjut1:
//pelan();

kanan_mundur(100);
kiri_mundur(100);
delay_ms(50);
for(;;)
{    
kanan_mundur(130);
kiri_maju(100);
baca_sensor();
 if (adc_result[7]>adc_tres[7]||adc_result[6]>adc_tres[6])
         {break;}
 delay_ms(3);
}  
pid_diam_lambat();  

cp_motong:

cek_motong();    
for(;;)
                {
        konversi_sensor();  
        giving_weight10();
        giving_weight20();
        giving_weight30();
                if(rear_kanan==1||rear_kiri==1)
                {
                break;
                } 
        komp_pid();
        out_pwm();  
        
                   
        delay_ms(1);
                
                }

kanan_mundur(100);
kiri_mundur(100);
delay_ms(50);
for(;;)
{    
kanan_maju(100);
kiri_mundur(130);
baca_sensor();
 if (adc_result[0]>adc_tres[0]||adc_result[1]>adc_tres[1])
         {break;}
 delay_ms(3);
} 

pid_diam_lambat();  

cp3:
cek_fin();
fin_act:
}

void other_way()
{
//cek_kepepet();  
kanan_mundur(100);
kiri_mundur(100);
delay_ms(50);
for(;;)
{    
kanan_mundur(130);
kiri_maju(100);
baca_sensor();
 if (adc_result[7]>adc_tres[7]||adc_result[6]>adc_tres[6])
         {break;}
 delay_ms(3);
}
cek_fin();
}
void display_cal()
{     
//select=1;
while (1){

main_cal:         
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("Calibrate");    

/*

if (add==0)       
        { select++;
        if (select==5){select=1;}
        }
if (sub==0)
        { select--;
        if (select==0){select=4;}
        }
*/

adc_menu=read_adc(0);
adc_menu=255-adc_menu;

if  (adc_menu<=100) select =1;
else if  (adc_menu<=150) select =2;
else if  (adc_menu<=200) select =3;
else if  (adc_menu<=255) select =4;
  
if (cancel==0)
        {goto fin_main_cal;}
        
switch (select)
        {          
        case 1: lcd_gotoxy(0,1);
                lcd_putsf("   >autoset<   ");break;
        case 2: lcd_gotoxy(0,1);
                lcd_putsf("  >konversi <  ");break;  
        case 3: lcd_gotoxy(0,1);
                lcd_putsf(">display front<");break;
        case 4: lcd_gotoxy(0,1);
                lcd_putsf(">display rear <");break;
        default:break;
        }     
delay_ms(150);

if (enter==0)
{
switch (select)
        {     
        case 1:auto_scan();break;
        case 2:display_konversi();break;
        case 3:display_front_sensor();break;
        case 4:display_backadc();break;
        default:break;
        }
        goto main_cal;
 }
 else {delay_ms(85);}
 }                      
 fin_main_cal:
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
  
if (cancel==0){goto fin_main;}
        
switch (select)
        {
        case 1: lcd_gotoxy(0,1);
                lcd_putsf("  >action< ");break;          
        case 2: lcd_gotoxy(0,1);
                lcd_putsf("    >PID<     ");break;
        case 3: lcd_gotoxy(0,1);
                lcd_putsf("   >speed<    ");break;
        case 4: lcd_gotoxy(0,1);
                lcd_putsf(" >calibrate<  ");break;
        default:break;
        }     
delay_ms(150);

if (enter==0)
{
switch (select)
        {  
        case 1:action();break;   
        case 2:pid_murni();break; 
        case 3:set_speed();break;
        case 4:display_cal();break;
        
        }
        goto main;
 }
 else {delay_ms(85);}
 }                      
 fin_main:
}                   

void main()
{        

frontlight=1;
init_ADC();
init();
inisial();  
backlight=1;
lcd_gotoxy(0,0);
lcd_putsf("dock_CART");
lcd_gotoxy(0,1);
lcd_putsf("TF FT UGM 2009");
delay_ms(2000);
lcd_clear();
backlight=1;
lcd_gotoxy(0,0);
lcd_putsf("Bismillah...");
delay_ms(2000);
backlight=0; 
frontlight=0;                




while (1)
      {
      if(enter==0) {action();}
      else if(cancel==0) {main_menu();} 
      };
}
