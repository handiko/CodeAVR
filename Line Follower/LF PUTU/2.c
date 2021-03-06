/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 11/24/2012
Author  : 
Company : 
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 16.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>

#include <delay.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

#define T1      PINB.0

#define DIR_KA          PORTD.2
#define DIR_KI          PORTD.3

#define PWM_KA          PORTD.4
#define PWM_KI          PORTD.5

unsigned char xcount=0;
unsigned char lpwm=0;
unsigned char rpwm=0;
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
        // Place your code here    
        xcount++;    
        if(xcount<lpwm) PWM_KI = 1;
        else PWM_KI = 0;
        
        if(xcount<rpwm) PWM_KA = 1;
        else PWM_KA = 0;
        
        if(xcount>255) xcount = 0;
        
        TCNT0 = 0xff;
}

#define ADC_VREF_TYPE 0x20

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
char i=0;
unsigned char sensor = 0;
eeprom int cenlimit[8];
void baca_sensor(void)
{
        sensor = 0;
        for(i=2;i<8;i++)
        {
                if(read_adc(i) < cenlimit[i])   {sensor = sensor + (1 << i);}    
                else                            {sensor = sensor + (0 << i);}
        }    
}

eeprom int lowlimit[8];
eeprom int uplimit[8];
int j = 0;
void calibrate_sensor(void)
{
        unsigned char temp_s[8];
        
        
        for(i=0;i<8;i++)
        {
                uplimit[i] = 0;
                lowlimit[i] = 255;
        }     
        
        for(j=0;j<1000;j++)
        {
                for(i=0;i<8;i++)
                {        
                        temp_s[i] = read_adc(i);      
                        if(temp_s[i] < lowlimit[i])     lowlimit[i] = temp_s[i];
                        if(temp_s[i] > uplimit[i])      uplimit[i] = temp_s[i];  
                } 
                
                for(i=0;i<8;i++)
                {
                        cenlimit[i] = (uplimit[i] + lowlimit[i]) / 2;
                }      
                
                delay_ms(10);    
        }              
         
}

int d_error,error,last_error = 0,PV,Kp = 4,Kd = 10,intervalPWM = 1;
void pid()
{
        baca_sensor(); 
        DIR_KA = 1;
        DIR_KI = 1; 
        
        if(sensor==0b00000001)  error = 15;  //kanan
        if(sensor==0b00000011)  error = 10;     
        if(sensor==0b00000010)  error = 5;      
        if(sensor==0b00000110)  error = 4;      
        if(sensor==0b00000100)  error = 3;      
        if(sensor==0b00001100)  error = 2;      
        if(sensor==0b00001000)  error = 1;      

        if(sensor==0b00010000)  error = -1;     
        if(sensor==0b00110000)  error = -2;    
        if(sensor==0b00100000)  error = -3;     
        if(sensor==0b01100000)  error = -4;     
        if(sensor==0b01000000)  error = -5;    
        if(sensor==0b11000000)  error = -10;    
        if(sensor==0b10000000)  error = -15;      //kiri 
        
        d_error = error - last_error;
        PV      = (Kp*error)+(Kd*d_error);

        rpwm = PV + intervalPWM;
        lpwm = PV - intervalPWM + 20;

        last_error = error;

        if(lpwm>=100)       lpwm = 100;
        if(lpwm<=0)         lpwm = 0;
    
        if(rpwm>=100)       rpwm = 100;
        if(rpwm<=0)         rpwm = 0;
}  

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P 
PORTB=0xFF;
DDRB=0x00;

// Port C initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTC=0x00;
DDRC=0xFF;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x00;
DDRD=0xFF;

        // Timer/Counter 0 initialization
        // Clock source: System Clock
        // Clock value: 62.500 kHz
        // Mode: Normal top=0xFF
        // OC0 output: Disconnected
        TCCR0=0x05;
        TCNT0=0xFF;
        OCR0=0x00;

        // Timer(s)/Counter(s) Interrupt(s) initialization
        TIMSK=0x01;


// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 1000.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: ADC Stopped
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;



// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTC Bit 0
// RD - PORTC Bit 1
// EN - PORTC Bit 2
// D4 - PORTC Bit 4
// D5 - PORTC Bit 5
// D6 - PORTC Bit 6
// D7 - PORTC Bit 7
// Characters/line: 16
lcd_init(16);

while (1)
      {
                if(!T1)
                {
                        delay_ms(250);
                        rpwm = 0;
                        lpwm = 0;
                        calibrate_sensor(); 
                }     
                
                //pid();
                lpwm = rpwm = 250;
                delay_ms(200);
                
                lpwm = rpwm = 200;
                delay_ms(200);
                
                lpwm = rpwm = 180;
                delay_ms(200);
                
                lpwm = rpwm = 100;
                delay_ms(200);
                
                lpwm = rpwm = 80;
                delay_ms(200);
      }
}
