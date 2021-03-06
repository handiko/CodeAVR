/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/20/2013
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

#ifndef RXB8
#define RXB8 1
#endif

#ifndef TXB8
#define TXB8 0
#endif

#ifndef UPE
#define UPE 2
#endif

#ifndef DOR
#define DOR 3
#endif

#ifndef FE
#define FE 4
#endif

#ifndef UDRE
#define UDRE 5
#endif

#ifndef RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<DOR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART0 Transmitter buffer
#define TX_BUFFER_SIZE0 8
char tx_buffer0[TX_BUFFER_SIZE0];

#if TX_BUFFER_SIZE0 <= 256
unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
#else
unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
#endif

// USART0 Transmitter interrupt service routine
interrupt [USART0_TXC] void usart0_tx_isr(void)
{
if (tx_counter0)
   {
   --tx_counter0;
   UDR0=tx_buffer0[tx_rd_index0++];
#if TX_BUFFER_SIZE0 != 256
   if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART0 Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(unsigned char c)
{
while (tx_counter0 == TX_BUFFER_SIZE0);
#asm("cli")
if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer0[tx_wr_index0++]=c;
#if TX_BUFFER_SIZE0 != 256
   if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
#endif
   ++tx_counter0;
   }
else
   UDR0=c;
#asm("sei")
}
#pragma used-
#endif

// Standard Input/Output functions
#include <stdio.h>

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

eeprom unsigned char op_string[25] = 
{
        0xC0,0x00,
        ('A'<<1),('P'<<1),('A'<<1),('V'<<1),('R'<<1),(' '<<1),('0'<<1),
        ('S'<<1),('E'<<1),('R'<<1),('M'<<1),('O'<<1),(' '<<1),('0'<<1),     
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),(('2'<<1)+1),
        0x03,0xF0
};

flash unsigned char pos[45] =
{
        "=0749.48S/11007.40Er Telemetry Waduk Sermo"
};

flash unsigned char def_t[43] =
{      //:YD2JTF-1 :
        ":SERMO    :PARM.Piezo1,Piezo2,W_Lvl,Cahaya"
};

flash unsigned char unit_t[37] = 
{      //:YD2JTF-1 :
        ":SERMO    :UNIT.Volt,Volt,meter,Volt"
};

flash unsigned char eqn_t[62] =
{
        ":SERMO    :EQNS.0,0.019,0,0,0.019,0,0,0.004,0,0,0.019,0,0,1,0"
};

flash unsigned char cls_string[2] =
{
        0x0D,0xC0
};

//int t_idx = 0;
//eeprom unsigned int e_t_idx = 250;
eeprom int e_idx = 100;
int _idx = 0;
eeprom int _t_idx[3];
eeprom unsigned char _ch1[3];
eeprom unsigned char _ch2[3];
eeprom unsigned char _ch3[3];
eeprom unsigned char _ch4[3];
eeprom unsigned char _ch5[3];

char timer_idx = 0;

void read_sensor(void)
{
        unsigned char ch1,ch2,ch3,ch4,ch5;
        int rat,pul,sat;
        char _rat;
        char _pul;
        char _sat;
        
        unsigned char b_t_idx;
        
        ch1 = read_adc(0);
        
        rat = ch1 / 100;
        ch1 = ch1 % 100;
        pul = ch1 / 10;
        sat = ch1 % 10;
        
        _rat = rat + '0';
        _pul = pul + '0';
        _sat = sat + '0';
        
        _ch1[0] = _rat;
        _ch1[1] = _pul;
        _ch1[2] = _sat;
        
        ch2 = read_adc(1);
        
        rat = ch2 / 100;
        ch2 = ch2 % 100;
        pul = ch2 / 10;
        sat = ch2 % 10;
        
        _rat = rat + '0';
        _pul = pul + '0';
        _sat = sat + '0';
        
        _ch2[0] = _rat;
        _ch2[1] = _pul;
        _ch2[2] = _sat;
        
        ch3 = read_adc(2);
        
        rat = ch3 / 100;
        ch3 = ch3 % 100;
        pul = ch3 / 10;
        sat = ch3 % 10;
        
        _rat = rat + '0';
        _pul = pul + '0';
        _sat = sat + '0';
        
        _ch3[0] = _rat;
        _ch3[1] = _pul;
        _ch3[2] = _sat;
        
        ch4 = read_adc(3);
        
        rat = ch4 / 100;
        ch4 = ch4 % 100;
        pul = ch4 / 10;
        sat = ch4 % 10;
        
        _rat = rat + '0';
        _pul = pul + '0';
        _sat = sat + '0';
        
        _ch4[0] = _rat;
        _ch4[1] = _pul;
        _ch4[2] = _sat;
        
        ch5 = 0;
        
        rat = ch5 / 100;
        ch5 = ch5 % 100;
        pul = ch5 / 10;
        sat = ch5 % 10;
        
        _rat = rat + '0';
        _pul = pul + '0';
        _sat = sat + '0';
        
        _ch5[0] = _rat;
        _ch5[1] = _pul;
        _ch5[2] = _sat; 
                  
        b_t_idx = _idx;  
        
        rat = b_t_idx / 100;
        b_t_idx = b_t_idx % 100;
        pul = b_t_idx / 10;
        sat = b_t_idx % 10;
        
        _rat = rat + '0';
        _pul = pul + '0';
        _sat = sat + '0';
        
        _t_idx[0] = _rat;
        _t_idx[1] = _pul;
        _t_idx[2] = _sat;
        
        _idx++; 
        //if(_idx > 999) _idx = 0;       
        
        e_idx = _idx;
}

void kirim_string(void)
{
        int i; 
        
        for(i=0;i<25;i++)
        {
                putchar(op_string[i]);
        } 
        for(i=0;i<45;i++)
        {
                putchar(pos[i]);
        } 
        for(i=0;i<2;i++)
        {
                putchar(cls_string[i]);
        }        
        
        putchar(13);
        
        delay_ms(1000);
}

void kirim_data_telem(void)
{
        int i;    
        
        read_sensor();
        
        for(i=0;i<25;i++)
        {
                                putchar(op_string[i]);
        } 
                                putchar('T');
                                putchar('#');
        for(i=0;i<3;i++)        putchar(_t_idx[i]);  
                                putchar(',');
        for(i=0;i<3;i++)        putchar(_ch1[i]);
                                putchar(',');
        for(i=0;i<3;i++)        putchar(_ch2[i]);
                                putchar(',');
        for(i=0;i<3;i++)        putchar(_ch3[i]);
                                putchar(',');
        for(i=0;i<3;i++)        putchar(_ch4[i]); 
                                putchar(',');
        for(i=0;i<3;i++)        putchar(_ch5[i]);
                                putchar(','); 
                                puts("00000000");  
        for(i=0;i<2;i++)
        {
                                putchar(cls_string[i]);
        }        
        
        putchar(13);
        
        delay_ms(1000);
}

void kirim_param_telem(void)
{
        int i;
        
        for(i=0;i<25;i++)
        {
                putchar(op_string[i]);
        } 
        for(i=0;i<43;i++)
        {
                putchar(def_t[i]);
        } 
        for(i=0;i<2;i++)
        {
                putchar(cls_string[i]);
        }        
        
        putchar(13);
        
        delay_ms(1000);
}

void kirim_unit_telem(void)
{
        int i;
        
        for(i=0;i<25;i++)
        {
                putchar(op_string[i]);
        } 
        for(i=0;i<37;i++)
        {
                putchar(unit_t[i]);
        } 
        for(i=0;i<2;i++)
        {
                putchar(cls_string[i]);
        }        
        
        putchar(13);
        
        delay_ms(1000);
}

void kirim_eqn_telem(void)
{
        int i;
        
        for(i=0;i<25;i++)
        {
                putchar(op_string[i]);
        } 
        for(i=0;i<62;i++)
        {
                putchar(eqn_t[i]);
        } 
        for(i=0;i<2;i++)
        {
                putchar(cls_string[i]);
        }        
        
        putchar(13);
        
        delay_ms(1000);
}

void timer(void)
{
        if(timer_idx==3)
        {
                kirim_string();
                delay_ms(5000);
                
                kirim_param_telem();
                delay_ms(5000);
                
                kirim_unit_telem(); 
                delay_ms(5000);
                
                kirim_eqn_telem(); 
                delay_ms(5000);
                
                kirim_data_telem();
        }  
        else
        {    
                kirim_data_telem();
        }                       
        
        if(timer_idx==100)      timer_idx = 0; 
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
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=1 State0=P 
PORTD=0x03;
DDRD=0x02;

// Port E initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTE=0x00;
DDRE=0x00;

// Port F initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTF=0x00;
DDRF=0x00;

// Port G initialization
// Func4=In Func3=In Func2=In Func1=In Func0=In 
// State4=T State3=T State2=T State1=T State0=T 
PORTG=0x00;
DDRG=0x00;

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: Off
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 1200
UCSR0A=0x00;
UCSR0B=0x48;
UCSR0C=0x06;
UBRR0H=0x02;
UBRR0L=0x3F;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 691.200 kHz
// ADC Voltage Reference: AREF pin
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

_idx = e_idx;

while (1)
        {
                // Place your code here  
                timer();
                timer_idx++;
                delay_ms(5000);
        }
}
