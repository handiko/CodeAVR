/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : DDS Controller dual Phase
Version : 0.0
Date    : 8/19/2013
Author  : Handiko Gesang
Company : Lab.Sensor & Sistem Telekontrol - Jurusan Teknik Fisika
Comments: 


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega16.h>

#include <delay.h>

#include <alcd.h>
char lcd_buff[32];

#define ADC_VREF_TYPE 0x20

unsigned char read_adc(unsigned char adc_input)
{
        ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
        delay_us(10);
        ADCSRA|=0x40;
        while ((ADCSRA & 0x10)==0);
        ADCSRA|=0x10;
        return ADCH;
}

#include <stdio.h>

#define CLK     PORTB.0         
#define FUD     PORTB.1         
#define DAT     PORTB.2         
#define RST     PORTB.3
#define DAT_2   PORTB.4

#define EXE     PINA.1
#define IN_100  PINA.2
#define IN_10K  PINA.3
#define IN_MHZ  PINA.4

#define LOW     0
#define HIGH    1

eeprom unsigned long in_freq = 14070000;
flash unsigned char phase = (90 * 100 / 1125);
unsigned long d_in_freq = 0;
unsigned char adc;
bit i_menu = 0;

void dds_reset(void)
{
        CLK = LOW;
        FUD = LOW;
        
        RST = LOW;      delay_us(5);
        RST = HIGH;     delay_us(5);
        RST = LOW;
        
        CLK = LOW;      delay_us(5);
        CLK = HIGH;     delay_us(5);
        CLK = LOW;
        
        DAT = LOW;
        
        FUD = LOW;      delay_us(5);
        FUD = HIGH;     delay_us(5);
        FUD = LOW;
}

void send_data(void)
{
        unsigned long data_word = (in_freq * 4294967296) / 125000000; 
        unsigned long data_word_2 = data_word + (phase << 35);
        int i; 
        
        FUD = HIGH;     delay_us(5); 
        FUD = LOW;
        
        for(i=0; i<40; i++)
        {
                DAT = (data_word & 0x01);       
                DAT_2 = (data_word_2 & 0x01);
                delay_us(5); 
                
                if(i == 39) goto finish;
                data_word = data_word >> 1;
                
                finish:        
                CLK = HIGH;     delay_us(5);
                CLK = LOW;
        }      
        
        FUD = HIGH;     delay_us(5); 
        FUD = LOW;
}

int p_mega;
int mega;
int r_kilo;
int p_kilo;
int kilo;
int rat;
int pul;
int sat;

void display_freq(unsigned long input)
{
        p_mega = input / 10000000;
        input %= 10000000;
        mega = input / 1000000;
        input %= 1000000;
        r_kilo = input / 100000;
        input %= 100000;
        p_kilo = input / 10000;
        input %= 10000;
        kilo = input / 1000;
        input %= 1000;
        rat = input / 100;
        input %= 100;
        pul = input / 10;
        sat = input % 10;
        
        if(p_mega < 1)  p_mega = ' ';
                            
        lcd_clear();
        
        lcd_gotoxy(0,0);
        sprintf(lcd_buff, "F: %i%i.%i%i%i%i%i%i MHz", p_mega, mega, r_kilo, p_kilo, kilo, rat, pul, sat);    
        lcd_puts(lcd_buff); 
        
        lcd_gotoxy(0,1);     
                // 0123456789abcdef
        lcd_putsf("MHZ 10K 100     "); 
        delay_ms(200);
}
        
void display_freq_menu(unsigned long input)
{
        p_mega = input / 10000000;
        input %= 10000000;
        mega = input / 1000000;
        input %= 1000000;
        r_kilo = input / 100000;
        input %= 100000;
        p_kilo = input / 10000;
        input %= 10000;
        kilo = input / 1000;
        input %= 1000;
        rat = input / 100;
        input %= 100;
        pul = input / 10;
        sat = input % 10;
        
        if(p_mega < 1)  p_mega = ' ';
                            
        lcd_clear();
        
        lcd_gotoxy(0,0);
        sprintf(lcd_buff, "F: %i%i.%i%i%i%i%i%i MHz", p_mega, mega, r_kilo, p_kilo, kilo, rat, pul, sat);    
        lcd_puts(lcd_buff); 
        
        lcd_gotoxy(0,1);     
                // 0123456789abcdef
        lcd_putsf("            EXE"); 
        delay_ms(200); 
}

void main(void)
{
        // Port A initialization
        // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
        // State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=T 
        PORTA=0xFE;
        DDRA=0x00;

        // Port B initialization
        // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
        // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
        PORTB=0x00;
        DDRB=0xFF;

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

        ACSR=0x80;
        SFIOR=0x00;

        ADMUX=ADC_VREF_TYPE & 0xff;
        ADCSRA=0x84;

        lcd_init(16);  
        
        lcd_clear();      
        
        dds_reset();
        send_data();  
        display_freq(in_freq);
        delay_ms(150);
        
        while (1)
        {
                // Place your code here
                d_in_freq = in_freq; 
                
                if(!IN_MHZ)     
                {
                        i_menu= 1;
                        display_freq_menu(in_freq);
                                  
                        while(i_menu)
                        {
                                d_in_freq = in_freq;     
                                
                                adc = 0;
                                adc = read_adc(0);
                                
                                if(adc < 80)    in_freq -= 1000000;
                                if(adc > 160)   in_freq += 1000000; 
                                
                                if(in_freq != d_in_freq)        
                                {
                                        send_data();  
                                        display_freq_menu(in_freq);
                                }
                                
                                if(!EXE)        
                                {
                                        i_menu = 0;
                                        display_freq(in_freq); 
                                }  
                        }
                }
                
                if(!IN_10K)     
                {
                        i_menu= 1;
                        display_freq_menu(in_freq);
                                  
                        while(i_menu)
                        {
                                d_in_freq = in_freq; 
                                
                                adc = 0;
                                adc = read_adc(0);
                                
                                if(adc < 80)    in_freq -= 10000;
                                if(adc > 160)   in_freq += 10000; 
                                
                                if(in_freq != d_in_freq)        
                                {
                                        send_data();  
                                        display_freq_menu(in_freq);
                                }
                                
                                if(!EXE)        
                                {
                                        i_menu = 0;
                                        display_freq(in_freq); 
                                } 
                        }
                }
                
                if(!IN_100)     
                {
                        i_menu= 1; 
                        display_freq_menu(in_freq);
                                  
                        while(i_menu)
                        {
                                d_in_freq = in_freq;
                                
                                adc = 0;
                                adc = read_adc(0);
                                
                                if(adc < 80)    in_freq -= 100;
                                if(adc > 160)   in_freq += 100; 
                                
                                if(in_freq != d_in_freq)        
                                {
                                        send_data();  
                                        display_freq_menu(in_freq);
                                }
                                
                                if(!EXE)        
                                {
                                        i_menu = 0;
                                        display_freq(in_freq); 
                                } 
                        }
                }
                               
                adc = 0;
                adc = read_adc(0);
                                
                if(adc < 80)    in_freq -= 1000;
                if(adc > 160)   in_freq += 1000;  
                
                if(in_freq != d_in_freq)        
                {
                        send_data();  
                        display_freq(in_freq);
                }
        }
}
