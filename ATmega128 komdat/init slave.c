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
void init_timer_2(void);
void clr_timer_2(void);
void init_timer_3(void);
void init_usart0_600(void);
void clr_usart0(void);
void init_usart1_600(void);
void clr_usart1(void);
void init_adc(void);
void init_port_all(void);
void baca_sensor(char number);
void kirim_data(void);
void kirim_word(unsigned int data);
void kirim_karakter(unsigned char in_byte);
void kirim_string(char *str);
void set_dac(char value);

eeprom unsigned int sensor[14];
eeprom char jumlah_sensor = 14;
flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
flash char master = 1;
char n_sampling = 0;
bit nada = 0;
unsigned int count_int = 0;
char signal_gen_status = 0;
bit kirim = 0;

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

// USART0 Receiver buffer
#define RX_BUFFER_SIZE0 8
char rx_buffer0[RX_BUFFER_SIZE0];

#if RX_BUFFER_SIZE0 <= 256
        unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
#else
        unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
#endif

// This flag is set on USART0 Receiver buffer overflow
bit rx_buffer_overflow0;

// USART0 Receiver interrupt service routine
interrupt [USART0_RXC] void usart0_rx_isr(void)
{
        char status,data;
        status=UCSR0A;
        data=UDR0;
        if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
        {
                rx_buffer0[rx_wr_index0++]=data;
                #if RX_BUFFER_SIZE0 == 256
                // special case for receiver buffer size=256
                if (++rx_counter0 == 0)
                {
                #else
                if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
                if (++rx_counter0 == RX_BUFFER_SIZE0)
                {
                        rx_counter0=0;
                #endif
                        rx_buffer_overflow0=1;
                }
        }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART0 Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
        char data;
        while (rx_counter0==0);
        data=rx_buffer0[rx_rd_index0++];
        #if RX_BUFFER_SIZE0 != 256
        if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
        #endif
        #asm("cli")
        --rx_counter0;
        #asm("sei")
        return data;
}
#pragma used-
#endif

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
void putchar(char c)
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

// USART1 Receiver buffer
#define RX_BUFFER_SIZE1 8
char rx_buffer1[RX_BUFFER_SIZE1];

#if RX_BUFFER_SIZE1 <= 256
unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
#else
unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
#endif

// This flag is set on USART1 Receiver buffer overflow
bit rx_buffer_overflow1;

// USART1 Receiver interrupt service routine
interrupt [USART1_RXC] void usart1_rx_isr(void)
{
        char status,data;
        status=UCSR1A;
        data=UDR1;
        if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
        {
                rx_buffer1[rx_wr_index1++]=data;
                #if RX_BUFFER_SIZE1 == 256
                // special case for receiver buffer size=256
                if (++rx_counter1 == 0)
                {
                #else
                if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
                if (++rx_counter1 == RX_BUFFER_SIZE1)
                {
                        rx_counter1=0;
                #endif
                        rx_buffer_overflow1=1;
                }
        }
}

// Get a character from the USART1 Receiver buffer
#pragma used+
char getchar1(void)
{
        char data;
        while (rx_counter1==0);
        data=rx_buffer1[rx_rd_index1++];
        #if RX_BUFFER_SIZE1 != 256
        if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
        #endif
        #asm("cli")
        --rx_counter1;
        #asm("sei")
        return data;
}
#pragma used-
// USART1 Transmitter buffer
#define TX_BUFFER_SIZE1 8
char tx_buffer1[TX_BUFFER_SIZE1];

#if TX_BUFFER_SIZE1 <= 256
        unsigned char tx_wr_index1,tx_rd_index1,tx_counter1;
#else
        unsigned int tx_wr_index1,tx_rd_index1,tx_counter1;
#endif

// USART1 Transmitter interrupt service routine
interrupt [USART1_TXC] void usart1_tx_isr(void)
{
        if (tx_counter1)
        {
                --tx_counter1;
                UDR1=tx_buffer1[tx_rd_index1++];
                #if TX_BUFFER_SIZE1 != 256
                if (tx_rd_index1 == TX_BUFFER_SIZE1) tx_rd_index1=0;
                #endif
        }
}

// Write a character to the USART1 Transmitter buffer
#pragma used+
void putchar1(char c)
{
        while (tx_counter1 == TX_BUFFER_SIZE1);
        #asm("cli")
        if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
        {
                tx_buffer1[tx_wr_index1++]=c;
                #if TX_BUFFER_SIZE1 != 256
                if (tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
                #endif
                ++tx_counter1;
        }
        else
        UDR1=c;
        #asm("sei")
}
#pragma used-

// Standard Input/Output functions
#include <stdio.h>
unsigned int ttt = 0;
unsigned int rrr = 0;

unsigned int adc_buff = 0;
bit pancar = 0;
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

unsigned int in_afsk = 0;
bit raw = 0;
bit d1_raw = 0;
bit d2_raw = 0;
bit out_bit_fsk = 0;
unsigned char out_byte = 0;
unsigned int sum_adc = 0;
unsigned int t2_ovf_int = 0;

#define DETECTED        1
#define LOST            0
char bit_count = 0;
char flag = 0;

// Timer2 overflow interrupt service routine
/*interrupt [TIM2_OVF] void timer2_ovf_isr(void)
{
        // Place your code here
        //TCNT2=0xEE;     // Fsampling = 600Hz   
        
} */  

// Timer3 overflow interrupt service routine
interrupt [TIM3_OVF] void timer3_ovf_isr(void)
{
        // Place your code here 
        char x;
        
        //clr_timer_2();
        
        baca_sensor(jumlah_sensor);    
                      
        //init_timer_0();   
        
        if(master) 
        {
                
                PTT = 1; 
                         
                init_usart0_600();
                //init_usart1_600();
           
                puts("PORT OPENED");
                putchar(13); 
                
                clr_usart0();
                //clr_usart1();
                             
                TXD_USART_0 = 1;
                
                for(x=0;x<30;x++)       kirim_karakter('$');
                kirim_string("REMOTE,JTF-TEL,NORM-BROADCAST,"); 
                kirim_data(); 
                kirim_string("!");       
                for(x=0;x<30;x++)       kirim_karakter('*'); 
                kirim_karakter(13);
                
                TXD_USART_0 = 1;
                 
                init_usart0_600();
                //init_usart1_600();
                
                putchar(13);
                puts("PORT CLOSED");
                putchar(13);
                putchar(13);
                
                clr_usart0();
                //clr_usart1(); 
                
                PTT = 0;    
                
        }    
        
        //clr_timer_0(); 
        
        flag = LOST;
        bit_count = 0; 
        
        init_usart0_600();
        init_usart1_600();
         
        //init_timer_2();  
        
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

void init_timer_2(void)
{
        TCCR2=0x05;
        TCNT2=0xEE;
        
        TIMSK=0x40;
        ETIMSK=0x04;
}

void clr_timer_2(void)
{
        TCCR2=0;
        TCNT2=0;
        
        TIMSK=0x00;
        ETIMSK=0x04;
}

void init_timer_3(void)
{
        TCCR3A=0x00;
        TCCR3B=0x05;
        TCNT3H = (11536 >> 8) & 0xFF;
        TCNT3L = 11536 & 0xFF;
}

void init_usart0_600(void)
{
        UCSR0A=0x00;
        UCSR0B=0xD8;
        UCSR0C=0x06;
        UBRR0H=0x04;
        UBRR0L=0x7F;
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
        UCSR1A=0x00;
        UCSR1B=0xD8;
        UCSR1C=0x06;
        UBRR1H=0x04;
        UBRR1L=0x7F;
}

void clr_usart1(void)
{
        UCSR1A=0;
        UCSR1B=0;
        UCSR1C=0;
        UBRR1H=0;
        UBRR1L=0;
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
        
        /*TXD_USART_0 = 1; 
        kirim = OK;  
                        
        while(signal_gen_status < 4)
        {
                nada = TONE_2400; 
                TXD_USART_0 = 0;
        } 
        
        signal_gen_status = 0;
          
        for(i=0;i<8;i++)
        {
                in_bit = in_byte & 0x01;
                TXD_USART_0 = in_bit;
                
                if(in_bit)      
                {       
                        while(signal_gen_status < 2)
                        {
                                nada = TONE_1200; 
                        } 
                }
                else if(!in_bit) 
                {           
                        while(signal_gen_status < 4)
                        {
                                nada = TONE_2400;
                        }  
                } 
                signal_gen_status = 0;
                
                in_byte = in_byte >> 1;
        }   
        
        while(signal_gen_status < 2)
        {
                nada = TONE_1200;
                TXD_USART_0 = 1;
        } 
                           
        kirim = STOP;   
        signal_gen_status = 0;
        TXD_USART_0 = 1;
        in_byte = 0;  */
        
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

void set_dac(char value)
{
        DAC_0 = value & 0x01;
        DAC_1 =( value >> 1 ) & 0x01;
        DAC_2 =( value >> 2 ) & 0x01;
        DAC_3 =( value >> 3 ) & 0x01; 
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

void decode_data(void)
{
        
}

void main(void)
{
        init_port_all(); 
        clr_timer_0();
        clr_timer_2();
        //init_timer_0();
        //init_timer_2();
        //init_timer_3();
        //init_usart0_600();
        //init_usart1_600();
        init_adc();
        
        TIMSK=0x00;
        ETIMSK=0x04;
        ACSR=0x80;
        SFIOR=0x00; 

        //#asm("sei")

        while (1)
        {
                adc_buff = read_adc(FSK_IN);
                if(adc_buff > 50)       TXD_USART_0 = 1;
                else                    TXD_USART_0 = 0;      
        }
}
