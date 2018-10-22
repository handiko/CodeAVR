/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 9/30/2013
Author  : 
Company : 
Comments: 


Chip type               : ATmega128
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 1024
*****************************************************/

#include <mega128.h>
#include <delay.h>
#include <stdlib.h>
#include <string.h>
#include <math.h>

#define SENSOR_0        0
#define SENSOR_1        1
#define SENSOR_2        2
#define SENSOR_3        3
#define SENSOR_4        4
#define SENSOR_5        5
#define SENSOR_EXP      6
#define FSK_IN          7

#define ADCMUX0         PORTA.3
#define ADCMUX1         PORTA.4
#define ADCMUX2         PORTA.5

#define STATUS_0        PORTC.3
#define STATUS_1        PORTC.2
#define STATUS_2        PORTC.1
#define STATUS_3        PORTC.0
#define STATUS_4        PORTG.1
#define STATUS_5        PORTG.0

#define TXD_USART_0     PORTE.1
#define RXD_USART_0     PINE.0

#define PTT             PORTD.7
#define TXD_USART_1     PORTD.3
#define RXD_USART_1     PIND.2

#define DEBUG_1         PIND.1
#define DEBUG_2         PIND.0

#define DAC_0           PORTE.4
#define DAC_1           PORTE.5
#define DAC_2           PORTE.6
#define DAC_3           PORTE.7

#define TONE_1200       1
#define TONE_2400       0

#define OK              1
#define STOP            0

#ifdef	_OPTIMIZE_SIZE_
	#define CONST_1200      46
	#define CONST_2200      25  // 22-25    22-->2400Hz   25-->2200Hz

        // Konstanta untuk kompilasi dalam mode optimasi kecepatan
#else
	#define CONST_1200      50
	#define CONST_2200      25
#endif

unsigned int read_adc(unsigned char adc_input);
void init_port_all(void);
void init_porta(void);
void init_portc(void);
void init_portd(void);
void init_porte(void);
void init_portf(void);
void init_portg(void);
void init_timer_0(void);
void clr_timer_0(void);
void init_timer_3(void);
void init_usart0_600(void);
void clr_usart0(void);
void init_usart1_600(void);
void init_adc(void);
void init_port_all(void);
void baca_sensor(char number);
void kirim_data(void);
void kirim_word(unsigned int data);
void kirim_karakter(unsigned char in_byte);
void kirim_string(char *str);

eeprom unsigned int sensor[14];
eeprom char jumlah_sensor = 14;
flash char master = 1;

// Standard Input/Output functions
#include <stdio.h>
unsigned int ttt = 0;

unsigned int adc_buff = 0;
// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
        TCNT0=0xF7; 
        
        ttt++; 
        
        /*if(kirim == OK)
        {
                if(nada == TONE_1200)
                {
                        if((count_int % 2) == 0)
                        {
                                set_dac(matrix[n_sampling]);
                                n_sampling++;  
                        }
                        
                        count_int++;
                        
                        if(n_sampling == 16)
                        {
                                n_sampling = 0;
                                count_int = 0;
                                signal_gen_status++;
                        }    
                }
                
                else
                {
                        set_dac(matrix[n_sampling]);
                        n_sampling++;
                        
                        count_int++;
                        
                        if(n_sampling == 16)
                        {
                                n_sampling = 0;
                                count_int = 0;
                                signal_gen_status++;
                        }    
                }    
        } */
}


#define DETECTED        1
#define LOST            0
char bit_count = 0;
char flag = 0;

// Timer3 overflow interrupt service routine
interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
        // Place your code here 
        char x;
                
        baca_sensor(jumlah_sensor);    
                      
        init_timer_0();   
        
        if(master) 
        {
                
                PTT = 1; 
                         
                init_usart0_600();
                putchar(13); 
                clr_usart0();
                             
                TXD_USART_0 = 1;
                
                for(x=0;x<30;x++)       kirim_karakter('$');
                kirim_string("BASE,JTF-TEL,ASK-STATUS,"); 
                //kirim_data(); 
                kirim_string("!");       
                for(x=0;x<30;x++)       kirim_karakter('*'); 
                kirim_karakter(13);
                
                TXD_USART_0 = 1;
                 
                init_usart0_600();
                putchar(13);
                clr_usart0();
                
                PTT = 0;  
        }    
        
        clr_timer_0(); 
        
        flag = LOST;
        bit_count = 0; 
        
        init_usart0_600();
        init_usart1_600();
               
        TCNT3H = (11536 >> 8) & 0xFF;
        TCNT3L = 11536 & 0xFF;
}

#define ADC_VREF_TYPE 0x00

// Read the AD conversion result
unsigned int read_adc(unsigned char adc_input)
{
        ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
        // Delay needed for the stabilization of the ADC input voltage
        delay_us(10);
        // Start the AD conversion
        ADCSRA|=0x40;
        // Wait for the AD conversion to complete
        while ((ADCSRA & 0x10)==0);
        ADCSRA|=0x10;
        return ADCW;
}

// Declare your global variables here

void init_porta(void)
{
        PORTA=0x00;
        DDRA=0x38;
}

void init_portc(void)
{
        PORTC=0x00;
        DDRC=0x0F;
}

void init_portd(void)
{
        PORTD=0x0F;
        DDRD=0x88;
}

void init_porte(void)
{
        PORTE=0x03;
        DDRE=0xF2;
}

void init_portf(void)
{
        PORTF=0x00;
        DDRF=0x00;
}

void init_portg(void)
{
        PORTG=0x00;
        DDRG=0x03;
}

void init_timer_0(void)
{
        TCCR0=0x03;
        TCNT0=0xF7; 
        
        TIMSK=0x01;
        ETIMSK=0x04;
}

void clr_timer_0(void)
{
        TCCR0=0;
        TCNT0=0; 
        
        TIMSK=0x00;
        ETIMSK=0x04;
}

void init_timer_3(void)
{
        TCCR3A=0x00;
        TCCR3B=0x05;
        TCNT3H = (11536 >> 8) & 0xFF;
        TCNT3L = 11536 & 0xFF;  
        TIMSK=0x01;
        ETIMSK=0x04;
}

void init_usart0_600(void)
{
        // USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 9600
UCSR0A=0x00;
UCSR0B=0x18;
UCSR0C=0x06;
UBRR0H=0x00;
UBRR0L=0x47;
}

void clr_usart0(void)
{
        UCSR0A=0;
        UCSR0B=0;
        UCSR0C=0;
        UBRR0H=0;
        UBRR0L=0;
}

void init_usart1_600(void)
{
        
}

void init_adc(void)
{
        ADMUX=ADC_VREF_TYPE & 0xff;
        ADCSRA=0x84;
}

void baca_sensor(char number)
{
        char i;
        
        for(i=0;i<number;i++)
        {
                if(i<6)
                {
                        sensor[i] = read_adc(i); 
                }
                else 
                {
                        ADCMUX0 = (i - 6) & 0x01;
                        ADCMUX1 = ((i - 6) >> 1) & 0x01; 
                        ADCMUX2 = ((i - 6) >> 2) & 0x01; 
                        
                        delay_us(2);
                        
                        sensor[i] = read_adc(SENSOR_EXP);
                        
                        ADCMUX0 = 0;
                        ADCMUX1 = 0;
                        ADCMUX2 = 0;
                }
        }
}

void kirim_data(void)
{
        char i;
        
        for(i=0;i<jumlah_sensor;i++)
        {
                kirim_word(sensor[i]); 
                kirim_karakter(',');
        }                             
}

void kirim_word(unsigned int data)
{
        char rib;
        char rat;
        char pul;
        char sat;  
        
        rib = data / 1000;
        data = data % 1000;
        
        rat = data / 100;
        data = data % 100;
        
        pul = data / 10;
        
        sat = data % 10;    
        
        kirim_karakter((rib + '1')-1);
        kirim_karakter((rat + '1')-1);
        kirim_karakter((pul + '1')-1);
        kirim_karakter((sat + '1')-1);   
}

void kirim_karakter(unsigned char in_byte)
{
        char i;
        bit in_bit;
        
        TXD_USART_0 = 0; 
        DAC_0 = 0;
        DAC_1 = 0;
        DAC_2 = 0;
        DAC_3 = 0;
        ttt = 0;
        while(ttt < 64);
        
        for(i=0;i<8;i++)
        {
                in_bit = in_byte & 0x01;
                TXD_USART_0 = in_bit;
                DAC_0 = in_bit;
                DAC_1 = in_bit;
                DAC_2 = in_bit;
                DAC_3 = in_bit;
                ttt = 0;
                while(ttt < 64);
                in_byte >>= 1; 
        } 
        
        TXD_USART_0 = 1;
        DAC_0 = 1;
        DAC_1 = 1;
        DAC_2 = 1;
        DAC_3 = 1;
        ttt = 0;
        while(ttt < 64); 
}

void kirim_string(char *str)
{
        char k;
        while (k=*str++) kirim_karakter(k);
        kirim_karakter(10);
}

void init_port_all(void)
{
        init_porta();
        init_portc();
        init_portd();
        init_porte();
        init_portf();
        init_portg();       
}

bit data_bit = 0;
bit data_bit7,data_bit6,data_bit5,data_bit4,data_bit3,data_bit2,data_bit1;
char data_byte;

void decode_data(void)
{
        init_timer_0();
        
        ttt = 0;
        while(ttt < 64);
        
        data_bit7 = data_bit6;
        data_bit6 = data_bit5;
        data_bit5 = data_bit4;
        data_bit4 = data_bit3;
        data_bit3 = data_bit2;
        data_bit2 = data_bit1;
        data_bit1 = data_bit;
         
        data_byte = (data_bit << 7) +(data_bit1 << 6) +(data_bit2 << 5) +(data_bit3 << 4) +(data_bit4 << 3) +(data_bit5 << 2) +(data_bit6 << 1) +data_bit7;  
        
        clr_timer_0();
        
        if(data_byte == '$')    kirim_karakter(data_byte);           
}

unsigned int v= 0;
void main(void)
{
        init_port_all(); 
        init_timer_0();
        init_timer_3();
        init_usart0_600();
        init_usart1_600();
        init_adc();
        
        // Timer(s)/Counter(s) Interrupt(s) initialization
        TIMSK=0x01;
        ETIMSK=0x04;

        ACSR=0x80;
        SFIOR=0x00; 

        //#asm("sei")

        while (1)
        { 
                #asm("cli") 
                clr_usart0();   
                for(v=0;v<65535;v++)
                {
                        adc_buff = read_adc(FSK_IN);
                        if(adc_buff > 50)       
                        {
                                TXD_USART_0 = 1; 
                                data_bit = 1;
                        }
                        if(adc_buff < 51)       
                        {
                                TXD_USART_0 = 0; 
                                data_bit = 0;
                        }
                        //decode_data();
                }
                init_usart0_600();
                #asm("sei") 
                delay_us(1);  
        }
}
