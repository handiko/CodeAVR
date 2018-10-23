/*
program punya agus, arep, sohib
*/
#include <mega16.h>
#include <stdio.h>
#include <delay.h>
#include <math.h>
#include <alcd.h>

#define enter   PINC.2
#define back    PINC.1
#define plus    PINC.0
#define minus   PIND.7
#define dir_ki   PORTD.3 
#define dir_ka   PORTD.6
#define pwm_ki   OCR1B
#define pwm_ka   OCR1A 
#define ADC_VREF_TYPE 0x20

unsigned char kp,kd,lines,speed,start;
//unsigned char hi[8],lo[8],ref[8];
unsigned char hi1,hi2,hi3,hi4,hi5,hi6,hi7,hi8;
unsigned char lo1,lo2,lo3,lo4,lo5,lo6,lo7,lo8;
unsigned char ref1,ref2,ref3,ref4,ref5,ref6,ref7,ref8;
char buf[33];
int error,error_lalu;
int level,select;

eeprom unsigned char ekp=50,ekd=50,espeed=255,estart=1; //,eref[8]={255,255,255,255,255,255,255,255};
eeprom unsigned char eref1=255;
eeprom unsigned char eref2=255;
eeprom unsigned char eref3=255;
eeprom unsigned char eref4=255;
eeprom unsigned char eref5=255;
eeprom unsigned char eref6=255;
eeprom unsigned char eref7=255;
eeprom unsigned char eref8=255;
eeprom int elevel=50;

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
delay_us(10);
ADCSRA|=0x40;
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

void set_motor(int L, int R){
 if (R<0){

 dir_ka=0;
 pwm_ka=255+R; 
  if(R<-150){R=-150;}
 }
 
 if (L<0){

 dir_ki=0;
 pwm_ki=255+L;
 if(L<-150){L=-150;}
 } 
 
 if (R>=0){

 dir_ka=1;
 pwm_ka=R; 
 if(R>255){R=255;}
 }
 
 if (L>=0){

 dir_ki=1;
 pwm_ki=L;
 if(L>255){L=255;}

}
}


void baca()            // scan sensor 8
{
while(1){
lcd_clear();
lines=0;       

        lcd_gotoxy(4,0);
        if(read_adc(0)>ref1){
        lcd_putchar('1');
        }
        else lcd_putchar('0');
        
        lcd_gotoxy(5,0);
        if(read_adc(1)>ref2){
        lcd_putchar('1');
        }
        else lcd_putchar('0');  

        lcd_gotoxy(6,0);
        if(read_adc(2)>ref3){
        lcd_putchar('1');
        }
        else lcd_putchar('0'); 

        lcd_gotoxy(7,0);
        if(read_adc(3)>ref4){
        lcd_putchar('1');
        }
        else lcd_putchar('0');
          
        lcd_gotoxy(8,0);
        if(read_adc(4)>ref5){
        lcd_putchar('1');
        }
        else lcd_putchar('0');
     
        lcd_gotoxy(9,0);
        if(read_adc(5)>ref6){
        lcd_putchar('1');
        }
        else lcd_putchar('0');

        lcd_gotoxy(10,0);
        if(read_adc(6)>ref7){
        lcd_putchar('1');
        }
        else lcd_putchar('0');
      
        lcd_gotoxy(11,0);
        if(read_adc(7)>ref8){
        lcd_putchar('1');
        }
        else lcd_putchar('0');   
        
        delay_ms(3);
}       
}

void auto_scan(){
unsigned char data,i;

lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("    start?");
lcd_gotoxy(0,1);
lcd_putsf("  scanning...");
delay_ms(300);
for(;;) {
if(!back) {
delay_ms(100);
break;}
}
lcd_gotoxy(0,0);
lcd_putsf("              ");
delay_ms(100);
lcd_gotoxy(0,0);
lcd_putsf("   proses...");

hi1=read_adc(0);
hi2=read_adc(1);
hi3=read_adc(2);
hi4=read_adc(3);
hi5=read_adc(4);
hi6=read_adc(5);
hi7=read_adc(6);
hi8=read_adc(7);
lo1=read_adc(0);
lo2=read_adc(1);
lo3=read_adc(2);
lo4=read_adc(3);
lo5=read_adc(4);
lo6=read_adc(5);
lo7=read_adc(6);
lo8=read_adc(7);

do {
if(read_adc(0)>hi1){hi1=read_adc(0);}
if(read_adc(1)>hi2){hi2=read_adc(1);}
if(read_adc(2)>hi3){hi3=read_adc(2);}
if(read_adc(3)>hi4){hi4=read_adc(3);}
if(read_adc(4)>hi5){hi5=read_adc(4);}
if(read_adc(5)>hi6){hi6=read_adc(5);}
if(read_adc(6)>hi7){hi7=read_adc(6);}
if(read_adc(7)>hi8){hi8=read_adc(7);}
if(read_adc(0)<lo1){lo1=read_adc(0);}
if(read_adc(1)<lo2){lo2=read_adc(1);}
if(read_adc(2)<lo3){lo3=read_adc(2);}
if(read_adc(3)<lo4){lo4=read_adc(3);}
if(read_adc(4)<lo5){lo5=read_adc(4);}
if(read_adc(5)<lo6){lo6=read_adc(5);}
if(read_adc(6)<lo7){lo7=read_adc(6);}
if(read_adc(7)<lo8){lo8=read_adc(7);}
delay_ms(1);
}
while(!back);
delay_ms(100);
goto ref;
 
ref: 
delay_ms(5);
ref1=hi1+lo1;
ref2=hi2+lo2;
ref3=hi3+lo3;
ref4=hi4+lo4;
ref5=hi5+lo5;
ref6=hi6+lo6;
ref7=hi7+lo7;
ref8=hi8+lo8;

ref1=ref1/2;
ref2=ref2/2;
ref3=ref3/2;
ref4=ref4/2;
ref5=ref5/2;
ref6=ref6/2;
ref7=ref7/2;
ref8=ref8/2;

eref1=ref1;
eref2=ref2;
eref3=ref3;
eref4=ref4;
eref5=ref5;
eref6=ref6;
eref7=ref7;
eref8=ref8;
//eref1=ref1;

lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("  scanning");
lcd_gotoxy(0,1);
lcd_putsf("  selesai!");
delay_ms(300);
baca(); 
}

void set()
{
unsigned char n=1;
while(1){
delay_ms(120); 
        
        if(!back){         //plus=up minus=down enter=ok back=cancel
        n=n+1;  
        }    
        if(n>7){
        n=1;
        }
            
        if(n==0){
        n=7;
        }
        
/////////////////////////////////////////////////////////////////mulai set        
                
          if(n==2){
          lcd_clear();
          lcd_gotoxy(0,0);
          sprintf(buf,"Speed1=%d",speed); 
          lcd_puts(buf);
                        if(!plus){
                                speed=speed+1;
                                
                        }
                        if(!minus){ 
                                speed=speed-1;
                                           
                }
                }
          
          if(n==1){
          lcd_clear();
          lcd_gotoxy(0,0);
          sprintf(buf,"Level=%d",level);
          lcd_puts(buf);
                        if(!plus){
                                level=level+1;
                        }
                        if(!min){
                                level=level-1;
                        }
          }
                
          if(n==3){
          lcd_clear();
          lcd_gotoxy(0,0);
          sprintf(buf,"P=%d",kp); 
          lcd_puts(buf);
         
                        if(!plus){
                                
                               kp=kp+1;
                        }
                        if(!min){
                               
                               kp=kp-1;           
                }
                }  
                         
           if(n==4){
                lcd_clear();
                lcd_gotoxy(0,0);
                sprintf(buf,"D=%d", kd);
                lcd_puts(buf);
                        if(!plus){
                                kd=kd+1;
                                
                        }
                        if(!min){
                                kd=kd-1;
                }
                }                    
                 
          if(n==5){
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf("auto scan..?");
                        if(!plus){
                                auto_scan();
                } 
                }
          
          if(n==6){
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf("baca sensor..?");
                if(!plus)
                        {
                        baca();
                        }
          }              
                
           if(n==7){
           lcd_clear();
                        lcd_gotoxy(0,0);
                        sprintf(buf,"start=%d",start);       
                        lcd_puts(buf);
                        if(!plus){
                                start=start+1; 
                                if(start>3)(start=1)  ;             
                        }
                        if(!min){
                                start=start-1;  
                                if(start<1)(start=3) ; 
                }          
                }      
                        
                           
         if(!enter)     //running plann
         { 
         
                if(speed!=espeed){
                        espeed=speed;
                }
                if(kp!=ekp){
                        ekp=kp;
                }
                if(kd!=ekd){
                       ekd=kd;
                }        
                if(start!=estart){
                        estart=start;    
                }  
                if(level!=elevel){
                        elevel=level;
                }
                 
                 break; 
        
                 
         }
        } 
}

void set_simpang(){
level=level+1;
        if(level==1){
        }
}

void baca_garis()        // baca sensornya
{  
int L,R;       
if(lines==0b00011000||lines==0b00010000||lines==0b00001000){
        set_motor(90,90);
}                         
if(lines==0b10000000){
        set_motor(-70,70);
}    
if(lines==0b00000001){
        set_motor(70,-70);
}
}

void main(){                                   
PORTA=0x00;
DDRA=0x00;
PORTB=0x00;
DDRB=0x7F;
PORTC=0x00;
DDRC=0x00;
PORTD=0x00;
DDRD=0xFF;
TCCR1A=0xA1;
TCCR1B=0x03;

lcd_init(16);

kp=ekp;
kd=ekd;
level=elevel;
speed=espeed;

lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("   KAMABROTO!   ");
lcd_gotoxy(0,1);
lcd_putsf("    JTF  UGM    ");
delay_ms(300);

set();
#asm("sei");
while(1)
        {
                baca_garis();
                set_simpang();
        }
}
