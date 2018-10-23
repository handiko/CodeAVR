/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 11/23/2012
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

#define T1      PINB.0
#define T2      PINB.1
#define T3      PINB.3
#define T4      PINB.4

#define PWM_KA          PORTC.5
#define PWM_KI          PORTC.4
#define MAJU_KA         PORTC.3
#define MUNDUR_KA       PORTC.2
#define MAJU_KI         PORTC.1
#define MUNDUR_KI       PORTC.0

#define LED_IND_1       PORTD.0

// Timer 0 overflow interrupt service routine
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
                if(read_adc(i) < cenlimit[i])   {sensor = sensor + (1 << (i-1));}    
                else                            {sensor = sensor + (0 << (i-1));}
        }    
        
        if(read_adc(1) < cenlimit[1])   {sensor = sensor + (1 << 0);}    
        else                            {sensor = sensor + (0 << 0);}
        
        if(read_adc(0) < cenlimit[0])   {sensor = sensor + (1 << 7);}    
        else                            {sensor = sensor + (0 << 7);}
}

eeprom int lowlimit1=200,lowlimit2=200,lowlimit3=200,lowlimit4=200,lowlimit5=200,lowlimit6=200,lowlimit7=200,lowlimit8=200;
eeprom int uplimit1=10,uplimit2=10,uplimit3=10,uplimit4=10,uplimit5=10,uplimit6=10,uplimit7=10,uplimit8=10;
int j = 0;
void calibrate_sensor(void)
{
        unsigned char temp_s[8];
        
        #asm("cli")     
        delay_ms(500);
        LED_IND_1 = 1;
        delay_ms(500);
        LED_IND_1 = 0;
        for(j=0;j<1000;j++)
        {
                for(i=0;i<8;i++)
                {        
                        temp_s[i] = read_adc(i);        
                }       
                
                if(temp_s[1-1] < lowlimit1)     lowlimit1=temp_s[1-1];
                if(temp_s[1-1] > uplimit1)      uplimit1=temp_s[1-1];
                
                if(temp_s[2-1] < lowlimit2)     lowlimit2=temp_s[2-1];
                if(temp_s[2-1] > uplimit2)      uplimit2=temp_s[2-1];
                
                if(temp_s[3-1] < lowlimit3)     lowlimit3=temp_s[3-1];
                if(temp_s[3-1] > uplimit3)      uplimit3=temp_s[3-1];
                
                if(temp_s[4-1] < lowlimit4)     lowlimit4=temp_s[4-1];
                if(temp_s[4-1] > uplimit4)      uplimit4=temp_s[4-1];
                
                if(temp_s[5-1] < lowlimit5)     lowlimit5=temp_s[5-1];
                if(temp_s[5-1] > uplimit5)      uplimit5=temp_s[5-1];
                
                if(temp_s[6-1] < lowlimit6)     lowlimit6=temp_s[6-1];
                if(temp_s[6-1] > uplimit6)      uplimit6=temp_s[6-1];
                
                if(temp_s[7-1] < lowlimit7)     lowlimit7=temp_s[7-1];
                if(temp_s[7-1] > uplimit7)      uplimit7=temp_s[7-1];
                
                if(temp_s[8-1] < lowlimit8)     lowlimit8=temp_s[8-1];
                if(temp_s[8-1] > uplimit8)      uplimit8=temp_s[8-1];
                
                delay_ms(10);    
        }              
        
        cenlimit[0] = (lowlimit1 + uplimit1) / 2;
        cenlimit[1] = (lowlimit2 + uplimit2) / 2; 
        cenlimit[2] = (lowlimit3 + uplimit3) / 2;
        cenlimit[3] = (lowlimit4 + uplimit4) / 2; 
        cenlimit[4] = (lowlimit5 + uplimit5) / 2;
        cenlimit[5] = (lowlimit6 + uplimit6) / 2; 
        cenlimit[6] = (lowlimit7 + uplimit7) / 2;
        cenlimit[7] = (lowlimit8 + uplimit8) / 2; 
        
        delay_ms(500);
        LED_IND_1 = 1;
        delay_ms(500);
        LED_IND_1 = 0; 
        
        delay_ms(500);
        LED_IND_1 = 1;
        delay_ms(500);
        LED_IND_1 = 0;  
                
        #asm("sei")
}

void maju(void)
{
        MAJU_KA = 1;
        MAJU_KI = 1;
        MUNDUR_KA = 0;
        MUNDUR_KI = 0;
}

void maju_ka(void)
{
        MAJU_KA = 1;
        MUNDUR_KA = 0;
}

void maju_ki(void)
{
        MAJU_KI = 1;
        MUNDUR_KI = 0;
}

void mundur(void)
{
        MAJU_KA = 0;
        MAJU_KI = 0;
        MUNDUR_KA = 1;
        MUNDUR_KI = 1;
}

void stop (void)
{
        MAJU_KA = 0;
        MAJU_KI = 0;
        MUNDUR_KA = 0;
        MUNDUR_KI = 0;
}

void mundur_ka(void)
{
        MAJU_KA = 0;
        MUNDUR_KA = 1;
}

void mundur_ki(void)
{
        MAJU_KI = 0;
        MUNDUR_KI = 1;
}

void bkan(void)
{
        stop();
        maju_ki();
}

void bkir(void)
{
        stop();
        maju_ka();
}

void rotkan(void)
{
        maju_ki();
        mundur_ka();
}

void rotkir(void)
{
        mundur_ki();
        maju_ka();
}

int d_error,error,last_error = 0,PV,Kp = 4,Kd = 10,intervalPWM = 1;
void pid()
{
        baca_sensor(); 
        maju(); 
        
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

int x = 0;
void jalan()
{
        baca_sensor();

        if(sensor==0b00000001){bkan();rpwm=0;lpwm=90;x=1;}  //kanan
        if(sensor==0b00000011){bkan();rpwm=0;lpwm=80;x=1;}
        if(sensor==0b00000010){maju();rpwm=10;lpwm=75;x=1;}
        if(sensor==0b00000110){maju();rpwm=20;lpwm=75;x=1;}
        if(sensor==0b00000100){maju();rpwm=35;lpwm=80;x=1;}
        if(sensor==0b00001100){maju();rpwm=50;lpwm=80;x=1;}
        if(sensor==0b00001000){maju();rpwm=70;lpwm=80;x=1;}

        //if(sensor==0b00011000){maju();rpwm=75;lpwm=75;}  //tengah

        if(sensor==0b00010000){maju();rpwm=80;lpwm=70;x=0;}
        if(sensor==0b00110000){maju();rpwm=80;lpwm=50;x=0;}
        if(sensor==0b00100000){maju();rpwm=80;lpwm=35;x=0;}
        if(sensor==0b01100000){maju();rpwm=75;lpwm=20;x=0;}
        if(sensor==0b01000000){maju();rpwm=75;lpwm=10;x=0;}
        if(sensor==0b11000000){bkir();rpwm=80;lpwm=0;x=0;}
        if(sensor==0b10000000){bkir();rpwm=90;lpwm=0;x=0;}  //kiri

        if(sensor==0b00000000)                                  //lepas
    {
        if(x)
        {
            stop();rotkan();rpwm=150;lpwm=150;
        }

        else
        {
            stop();rotkir();rpwm=150;lpwm=150;
        }
    }

    //sudutkanan
    sensor&=0b00001011;
    if(sensor==0b00001011)
    {
        stop();
        delay_ms(2);
        sensor&=0b00001111;
        if(sensor==0b00001111)
        {
            delay_ms(2);
            sensor&=0b00001110;
            if(sensor==0b00001110)
            {
                delay_ms(2);
                sensor&=0b00001100;
                if(sensor==0b00001100)
                {
                    bkan();rpwm=0;lpwm=250;
                }
            }
        }
    }


    //sudutkiri
    sensor&=0b11010000;
    if(sensor==0b11010000)
    {
        stop();
        delay_ms(2);
        sensor&=0b11110000;
        if(sensor==0b11110000)
        {
            delay_ms(2);
            sensor&=0b01110000;
            if(sensor==0b01110000)
            {
                delay_ms(2);
                sensor&=0b00110000;
                if(sensor==0b00110000)
                {
                    bkir();rpwm=250;lpwm=0;
                }
            }
        }
    }

        
        //lpwm = lpwm + 20;
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

        // Global enable interrupts
        #asm("sei")

        while (1)
        {      
                // Place your code here  
                if(!T1)
                {
                        delay_ms(250);
                        stop();
                        calibrate_sensor(); 
                }    
              
                //jalan(); 
                maju();
                lpwm = 30;
                rpwm = 30;
                
                LED_IND_1 = 1;
        }
}
