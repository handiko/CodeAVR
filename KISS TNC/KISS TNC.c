/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/1/2012
Author  : 
Company : 
Comments: 


Chip type               : ATmega8
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega8.h>

// Standard Input/Output functions
#include <stdio.h>

#define CARRIER PINB.7

#define DATA_IN PINB.6

#define LED_CARRIER     PORTB.0

#define LED_BUSY        PORTB.1

#define FLAG    (0x7E)

#define DATA_FRAME      (0x00)
#define FEND    (0xC0)
#define FESC    (0xDB)
#define TFEND   (0xDC)
#define TFESC   (0xDD)
#define RETURN  (0xFF)

bit last_bit_in = 0;
bit bit_in = 0;
bit binary_data = 0;
bit valid = 0;
bit flag_det = 0;
bit data_det = 0;
char data_index = 0;
char bit_stuff = 0;
unsigned char byte_data = 0;
unsigned char data_stream[512];
int index_ds = 0;

void tnc_to_pc(void);

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
        // Reinitialize Timer1 value
        TCNT1H=0xFFF7 >> 8;
        TCNT1L=0xFFF7 & 0xff;
        
        // Place your code here 
        if(CARRIER)
        {
                last_bit_in = bit_in;
         
                bit_in = DATA_IN;
                
                if(bit_in != last_bit_in)
                {
                        binary_data = 0; 
                        valid = 1;
                        if(bit_stuff == 5) 
                                valid = 0;
                        bit_stuff = 0;
                }
         
                if(bit_in == last_bit_in)
                {
                        binary_data = 1; 
                        valid = 1; 
                        bit_stuff++;
                } 
                                     
                if(valid)    
                {         
                        // MSB sent first
                        // byte_data = (byte_data << 1) + binary_data;  
                        
                        // LSB sent first
                        binary_data <<= 8;
                        byte_data = (byte_data >> 1) | binary_data;
                        data_index++; 
                }         
                
                if(flag_det == 0)
                {
                        if(byte_data == FLAG)
                        {
                                data_index = 8;
                                flag_det = 1;
                        }
                        
                        else
                        {
                                data_index--;
                        }
                }   
                               
                if((data_index == 8)&&(flag_det == 1))
                {          
                        if(byte_data == FLAG)
                        {
                                bit_stuff = 0;  
                                byte_data = 0;
                         
                                if(data_det)
                                {
                                        data_det = 0;
                                        flag_det = 0;   
                                        tnc_to_pc(); 
                                        index_ds = 0;
                                }
                        }  
                        
                        else
                        {
                                data_det = 1; 
                                
                                data_stream[index_ds] = byte_data;   
                                byte_data = 0;
                                index_ds++;  
                                if(index_ds==512) index_ds = 0;
                        }
                        
                        data_index = 0;
                }     
        }  
}

// Declare your global variables here

void tnc_to_pc(void)
{
        int i;
        
        putchar(FEND);
        putchar(DATA_FRAME);  
        
        for(i=0;i<(index_ds-2);i++)
        {     
                if(data_stream[i] == FEND)
                {
                        putchar(FESC);
                        putchar(TFEND); 
                }
                          
                else if(data_stream[i] == FESC)
                {
                        putchar(FESC);
                        putchar(TFESC);
                }   
                        
                else
                {
                        putchar(data_stream[i]);
                }      
        } 
        
        putchar(FEND);
}

void main(void)
{
        // Declare your local variables here

        PORTB=0x00;  
        
        DDRB=0x0F;

        PORTD=0x03; 
        
        DDRD=0x72;

        // Timer/Counter 1 initialization
        // Clock source: System Clock
        // Clock value: 10.800 kHz
        // Mode: Normal top=0xFFFF
        // OC1A output: Discon.
        // OC1B output: Discon.
        // Noise Canceler: Off
        // Input Capture on Falling Edge
        // Timer1 Overflow Interrupt: On
        // Input Capture Interrupt: Off
        // Compare A Match Interrupt: Off
        // Compare B Match Interrupt: Off 
        TCCR1A=0x00;
        TCCR1B=0x05;
        TCNT1H=0xFF;
        TCNT1L=0xF7;

        // Timer(s)/Counter(s) Interrupt(s) initialization
        TIMSK=0x04;

        // USART initialization
        // Communication Parameters: 8 Data, 1 Stop, No Parity
        // USART Receiver: Off
        // USART Transmitter: On
        // USART Mode: Asynchronous
        // USART Baud Rate: 9600
        UCSRA=0x00;
        UCSRB=0x08;
        UCSRC=0x86;
        UBRRH=0x00;
        UBRRL=0x47;

        // Analog Comparator initialization
        // Analog Comparator: Off
        // Analog Comparator Input Capture by Timer/Counter 1: Off
        ACSR=0x80;

        // Global enable interrupts
        #asm("sei")

        while (1)
        {
                // Place your code here
        }
}
