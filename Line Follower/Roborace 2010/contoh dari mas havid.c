/*********************************************
This program was produced by the
CodeWizardAVR V1.24.0 Standard
Automatic Program Generator
© Copyright 1998-2003 HP InfoTech s.r.l.
http://www.hpinfotech.ro
e-mail:office@hpinfotech.ro

Project : 
Version : 
Date    : 23/08/2010
Author  : havid                           
Company :                                 
Comments: 


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 12,000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*********************************************/

#include <mega16.h>       
#include <stdio.h>
#include <delay.h>
#include <math.h>



// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x18;PORTB
#endasm
#include <lcd.h>

#define ADC_VREF_TYPE 0x60
// Read the 8 most significant bits
// of the AD conversion result     

unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input|ADC_VREF_TYPE;
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}

eeprom unsigned char acc=5,base_speed=180, r1,r2,r3,r4,r5,r6,r7,r8;
eeprom char Ki=10,Kp=10,Kd=10;
   
// Declare your global variables here
unsigned char buf[33],buf2[33],sensor,x=0,target;
unsigned char p,q,r,s,t,u,v,w,a1=128,a2=128,a3=128,a4=128,a5=128,a6=128,a7=128,a8=128;
unsigned char adc0,adc1,adc2,adc3,adc4,adc5,adc6,adc7;
unsigned char screen1[33],screen2[33],b1=128,b2=128,b3=128,b4=128,b5=128,b6=128,b7=128,b8=128,koreksi,koko,kiki;
signed char bobot,i,j,prev_error,P,integral,derivatif;

#define pwm_ka OCR1A
#define pwm_ki OCR1B
#define tambah PINC.3
#define kurang PINC.2
#define enter PINC.1
#define balik PINC.0

void baca_sensor();
void read_sensor();
void pembobotan();
void arah();
void pid();
void main_prog();
void main_menu();
void motor_ka_maju();
void motor_ka_mundur();
void motor_ki_maju();
void motor_ki_mundur();
void motor_ka_stop();
void motor_ki_stop();
void kanan_90();
void kiri_90();
void lurus();
void per_4an();
void axel();
void kalibrasi_sensor();
void reset_sensor();

   
void main(void)
{
                    
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
PORTA=0xFF;
DDRA=0x00;

// Port B initialization
// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func0=In Func1=In Func2=In Func3=In Func4=In Func5=In Func6=In Func7=In 
// State0=T State1=T State2=T State3=T State4=T State5=T State6=T State7=T 
PORTD=0x00;
DDRD=0xFF;

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
// Clock value: 12000,000 kHz
// Mode: Normal top=FFFFh
// OC1A output: Toggle
// OC1B output: Toggle
// Noise Canceler: Off
// Input Capture on Falling Edge
TCCR1A=0x50;
TCCR1B=0x01;
TCNT1H=0x00;
TCNT1L=0xFF;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer 2 Stopped
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
// Analog Comparator Output: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 187,500 kHz
// ADC Voltage Reference: AVCC pin
// ADC High Speed Mode: Off
// ADC Auto Trigger Source: None
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE;
ADCSRA=0x86;
SFIOR&=0xEF;

// LCD module initialization
lcd_init(16);
      //lcd_gotoxy(0,0); lcd_putsf("assalamu'alaikum"); delay_ms(1000); 
      //lcd_gotoxy(0,0); lcd_putsf("   welcome to   "); delay_ms(1000);
      //lcd_gotoxy(0,1); lcd_putsf("    Impulse     "); delay_ms(1000);   
 i=1;j=0;
while (1)
      { 
      	if (tambah==1) {i++;delay_ms(200);}
      	else if (kurang==1) {i--;delay_ms(200);}
      	else i=i;
     	      
        main_menu(); 
      };      
}

void main_prog()
{
	baca_sensor();
	pembobotan();
	pid();
	arah();
	lcd_gotoxy(0,0); sprintf(screen1,"e=%i     k=%i    ",bobot,koreksi); lcd_puts(screen1);
	lcd_gotoxy(0,1); sprintf(screen2,"Ka=%i  Ki=%i     ",pwm_ka,pwm_ki); lcd_puts(screen2);  
}

void main_menu()
{                
	if (i!=6) {PORTD=0;}
	switch (i){
	case 0 : lcd_gotoxy(0,1);lcd_putsf("1-RUN!!!!!!!!   ");i=1; break;
        case 1 : lcd_gotoxy(0,0);lcd_putsf("     Menu       ");        
        	 lcd_gotoxy(0,1);lcd_putsf("1-RUN!!!!!!!!   "); if (enter==1) {i=6;delay_ms(200);} break;
        case 6 : main_prog(); if (balik==1) {i=1;} break;
        
	case 2 : lcd_gotoxy(0,0);lcd_putsf("     Menu       ");
		 lcd_gotoxy(0,1);lcd_putsf("2-Baca sensor   "); if (enter==1) {i=17;delay_ms(200);} break;
	case 17: lcd_gotoxy(0,1);lcd_putsf("a-Baca          "); if (enter==1) {i=37;delay_ms(200);} break; 
	case 37: while (balik==0) {i=7; 
		 baca_sensor(); read_sensor();};
	 	 if (balik==1) {i=17;delay_ms(200);} break;
	case 18: lcd_gotoxy(0,1);lcd_putsf("a-Calibrate     "); if (enter==1) {i=38;delay_ms(200);} break; 
	case 38: while (balik==0) {kalibrasi_sensor();};
		  if (balik==1) i=18; break;
	case 3 : lcd_gotoxy(0,1);lcd_putsf("3-Setting       "); if (enter==1) {i=10;delay_ms(200);} break; 
	case 4 : lcd_gotoxy(0,1);lcd_putsf("3-Setting       "); i=3; break;//kembali ke menu setting lagi
	 
	case 9  : lcd_gotoxy(0,1);lcd_putsf("1-Kp            ");i=10; break;                                                                
	case 10 : lcd_gotoxy(0,1);lcd_putsf("1-Kp            ");if (enter==1) {i=20;delay_ms(200);} if (balik==1) {i=3;delay_ms(200);} break;
	case 20 : lcd_gotoxy(0,1);lcd_putsf("1-Kp=  ");
		  while (balik==0){i=21;
		  if (tambah==1) {Kp++;delay_ms(100);}
      		  else if (kurang==1) {Kp--;delay_ms(100);}
 		  else Kp=Kp;
 		  lcd_gotoxy(8,1);sprintf(screen1,"%d        ",Kp); lcd_puts(screen1);}; 
 		  if (balik==1) {i=10;delay_ms(200);} break;
 		   
	case 11 : lcd_gotoxy(0,1);lcd_putsf("2-Ki            "); if (enter==1) {i=21;delay_ms(200);} if (balik==1) {i=3;delay_ms(200);} break;
	case 21 : lcd_gotoxy(0,1);lcd_putsf("2-Ki=  ");
		  while(balik==0){i=21;
		  if (tambah==1) {Ki++;delay_ms(100);}
      		  else if (kurang==1) {Ki--;delay_ms(100);}
 		  else Ki=Ki;
 		  lcd_gotoxy(8,1);sprintf(screen1,"%d        ",Ki); lcd_puts(screen1);}; 
 		  if (balik==1) {i=11;delay_ms(200);} break;
 		  
	case 12 : lcd_gotoxy(0,1);lcd_putsf("3-Kd            "); if (enter==1) {i=22;} if (balik==1) {i=3;delay_ms(200);} break;
	case 22 : lcd_gotoxy(0,1);lcd_putsf("3-Kd=  ");
		  while (balik==0) {i=22; 
		  if (tambah==1) {Kd++;delay_ms(100);}
      		  else if (kurang==1) {Kd--;delay_ms(100);}
 		  else Kd=Kd;
 		  lcd_gotoxy(8,1);sprintf(screen1,"%d        ",Kd); lcd_puts(screen1);}; 
 		  if (balik==1) {i=12;delay_ms(200);} break;	
                  
	case 13 : lcd_gotoxy(0,1);lcd_putsf("4-Speed         "); if (enter==1) {i=23;} if (balik==1) {i=3;delay_ms(200);} break;
	case 23 : lcd_gotoxy(0,1);lcd_putsf("4-Speed");
		  while (balik==0) {i=23; 
		  if (tambah==1) {base_speed++;delay_ms(100);}
      		  else if (kurang==1) {base_speed--;delay_ms(100);}
 		  else Kd=Kd;
 		  lcd_gotoxy(8,1);sprintf(screen1,"  = %d    ",base_speed); lcd_puts(screen1);}; 
 		  if (balik==1) {i=13;delay_ms(200);} break;
 		  
 	case 14 : lcd_gotoxy(0,1);lcd_putsf("5-Acceleration  "); if (enter==1) {i=24;delay_ms(200);} if (balik==1) {i=3;delay_ms(200);} break;
	case 24 : lcd_gotoxy(0,1);lcd_putsf("5-Accel");
		  while (balik==0) {i=24; 
		  if (tambah==1) {acc++;delay_ms(100);}
      		  else if (kurang==1) {acc--;delay_ms(100);}
 		  else Kd=Kd;
 		  lcd_gotoxy(8,1);sprintf(screen1,"  = %d    ",acc); lcd_puts(screen1);}; 
 		  if (balik==1) {i=14;delay_ms(200);} break;
 		  
 	case 15 : lcd_gotoxy(0,1);lcd_putsf("5-Reset!!!      "); if (enter==1) {i=26; delay_ms(200);} break;
 	case 25 : lcd_gotoxy(0,1);lcd_putsf("5-Reset Sensor  "); i=25; break;
 	case 26 : lcd_gotoxy(0,1);lcd_putsf("5-Reset Sensor  "); if (balik==1) {i=15;delay_ms(200);} 
 		   while (balik==0) {
 		   if (enter==1) { r1=128;r2=128;r3=128;r4=128;r5=128;r6=128;r7=128;r8=128;
 		   		   lcd_gotoxy(0,1);lcd_putsf("       OK!      ");  delay_ms(1500); 
 		   		   lcd_gotoxy(0,1);lcd_putsf("5-Reset Sensor  "); }};
 		   break;
 	case 27 : lcd_gotoxy(0,1);lcd_putsf("5-Reset all     "); if (balik==1) {i=15;delay_ms(200);} 
 	           while (balik==0) {
 	           if (enter==1) { r1=128;r2=128;r3=128;r4=128;r5=128;r6=128;r7=128;r8=128;
 	           		   Ki=10,Kp=10,Kd=10,acc=5,base_speed=180;
 		   		   lcd_gotoxy(0,1);lcd_putsf("       OK!      ");  delay_ms(1500); 
 		   		   lcd_gotoxy(0,1);lcd_putsf("5-Reset all     "); }
 		   		   };
 		   break;
 	case 28 : lcd_gotoxy(0,1);lcd_putsf("5-Reset all     "); i=26; break;

		}	
}

void kalibrasi_sensor()
{     
      adc0=read_adc(0);      
   	if (adc0>b1) b1=adc0;
	if (adc0<a1) a1=adc0;
 	r1= ( fabs(a1-b1)/2 ) + b1;
      	
      adc1=read_adc(1);
   	if (adc1>b2) b2=adc1;
	if (adc1<a2) a2=adc1;
 	r1= ( fabs(a2-b2)/2 ) + b2;
       
      adc2=read_adc(2);
      	if (adc2>b3) b3=adc2;
	if (adc2<a3) a3=adc2;
 	r1= ( fabs(a3-b3)/2 ) + b3; 
 	
      adc3=read_adc(3); 
      	if (adc3>b4) b4=adc3;
	if (adc3<a4) a4=adc3;
 	r1= ( fabs(a4-b4)/2 ) + b4;
 	
      adc4=read_adc(4); 
      	if (adc4>b5) b5=adc4;
	if (adc4<a5) a5=adc4;
 	r1= ( fabs(a5-b5)/2 ) + b5;
 	
      adc5=read_adc(5); 
      	if (adc5>b6) b6=adc5;
	if (adc5<a6) a6=adc5;
 	r1= ( fabs(a6-b6)/2 ) + b6;
 	
      adc6=read_adc(6); 
      	if (adc6>b7) b7=adc6;
	if (adc6<a7) a7=adc6;
 	r1= ( fabs(a7-b7)/2 ) + b7;
 	
      adc7=read_adc(7); 
      if (adc7>b8) b8=adc7;
	if (adc7<a8) a8=adc7;
 	r1= ( fabs(a8-b8)/2 ) + b8;
 	
 	lcd_gotoxy(0,0);
	sprintf(buf,"%d %d %d %d             ",r1,r2,r3,r4);
	lcd_puts(buf);
	lcd_gotoxy(0,1);
	sprintf(buf2,"%d %d %d %d             ",r5,r6,r7,r8);
	lcd_puts(buf2);
 	
}

void reset_sensor()
{
	
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
	
	lcd_gotoxy(0,0);
	lcd_putsf("h g f e  d c b a");
	lcd_gotoxy(0,1);
	sprintf(buf2,"%d %d %d %d  %d %d %d %d",p,q,r,s,t,u,v,w);
	lcd_puts(buf2);    
}                          

void pembobotan()
{       
	switch (sensor)
	{
		case 0b00011000:bobot=0;break;
		case 0b00001000:bobot=1;break;
		case 0b00001100:bobot=2;break;
		case 0b00000100:bobot=3;break;
		case 0b00000110:bobot=4;break;
		case 0b00000010:bobot=5;break;
		case 0b00000011:bobot=6;break;		
		case 0b00000001:bobot=7;break;
		case 0b00010000:bobot=-1;break;
		case 0b00110000:bobot=-2;break;
		case 0b00100000:bobot=-3;break;
		case 0b01100000:bobot=-4;break;
		case 0b01000000:bobot=-5;break;
		case 0b11000000:bobot=-6;break;
		case 0b10000000:bobot=-7;break;
	}                                      
}

void motor_ka_maju() 	{PORTD.0=1; PORTD.2=0;}
void motor_ka_mundur() 	{PORTD.0=0; PORTD.2=1;}
void motor_ki_maju()	{PORTD.1=1; PORTD.3=0;}
void motor_ki_mundur() 	{PORTD.1=0; PORTD.3=1;}
void motor_ka_stop()	{PORTD.0=0; PORTD.2=0;	pwm_ka=0;}
void motor_ki_stop()	{PORTD.1=0; PORTD.3=0; 	pwm_ki=0;}
void kanan_90()	{motor_ka_maju(); motor_ki_maju(); pwm_ki=255; pwm_ka=pwm_ki/7; }
void kiri_90() 	{motor_ka_maju(); motor_ki_maju(); pwm_ka=255; pwm_ki=pwm_ka/7;	}
void lurus()	{motor_ka_maju(); motor_ki_maju(); pid();}

void per_4an()
{
}

void arah()
{  	
        if (koko<0) {motor_ka_mundur();}			//arah motor kanan maju
	else if (koko=0) {PORTD.0=0; PORTD.2=0;} 		//arah motor kanan stop
	else {motor_ka_maju();}               		//arah motor kanan mundur
	
	if (kiki<0) {motor_ki_mundur();}			//arah motor kiri maju
	else if (kiki=0) {PORTD.1=0; PORTD.3=0;}		//arah motor kiri stop
	else {motor_ki_maju();}              		//arah motor kiri mundur
}

void pid()
{       
	P=0; integral=0; derivatif=0; base_speed<=255;
	target=0;
	bobot=target-bobot;
	P=bobot*Kp;		
	integral=integral+bobot;
	integral=integral*Ki;
	derivatif=bobot-prev_error;			
	derivatif=derivatif*Kd; 
	koreksi=P+integral+derivatif;
	
	koko = base_speed - koreksi;
	kiki = base_speed + koreksi;
	
	
	if (koko<0) koko *= (-1);
	else koko=koko;
	
	if (kiki<0) kiki *= (-1);
	else kiki=kiki;
	
	pwm_ka=koko; pwm_ki=kiki;
	         
}

void axel()
{
	if (bobot==0&&base_speed <= 255) {base_speed =base_speed + acc; delay_ms(100); 
		if (base_speed=255) base_speed=base_speed;}
	else {base_speed -= 75; base_speed ++;  delay_ms(100); 
		if (base_speed=255) base_speed=base_speed; }
}

