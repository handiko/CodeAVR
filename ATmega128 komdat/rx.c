#include <mega128.h>

#include <delay.h>

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

// Standard Input/Output functions
#include <stdio.h>

unsigned char read_adc(unsigned char adc_input);

unsigned char adc_buff;
bit buff = 0, b1 = 0, b2 = 0, b3 = 0;
char t0c = 0;

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
        // Reinitialize Timer 0 value
        TCNT0=0xF7;
        // Place your code here  
        
        if(b1 ^ buff)
        {
                if(t0c < 6)
                {
                        TXD_USART_0 = 0;
                        PTT = 0; 
                        t0c = 0;
                } 
                
                if(t0c > 5)
                {
                        TXD_USART_0 = 1;
                        PTT = 1;
                        t0c = 0;
                }
        }
        //TXD_USART_0 = b2 ^ buff; 
        //PTT = b2 ^ buff;  
        b3 = b2;
        b2 = b1;
        b1 = buff;      
        
        buff = 0;             
        
        t0c++;
        
        //if(adc_buff > 0)      buff = 1;  
        if(t0c > 126)   t0c = 0;
}

#define ADC_VREF_TYPE 0x20

// Read the 8 most significant bits        
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Delay needed for the stabilization of the ADC input voltage
//delay_us(1);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
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

void init_port_all(void)
{
        init_porta();
        init_portc();
        init_portd();
        init_porte();
        init_portf();
        init_portg();       
}

void main(void)
{
        init_port_all();

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: 86.400 kHz
// Mode: Normal top=0xFF
// OC0 output: Disconnected
ASSR=0x00;
TCCR0=0x04;
TCNT0=0xF7;
OCR0=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x01;

ETIMSK=0x00;

// USART0 initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART0 Receiver: On
// USART0 Transmitter: On
// USART0 Mode: Asynchronous
// USART0 Baud Rate: 9600
UCSR0A=0; //x00;
UCSR0B=0; //x18;
UCSR0C=0; //x06;
UBRR0H=0; //x00;
UBRR0L=0; //x47;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 691.200 kHz
// ADC Voltage Reference: AREF pin
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// Global enable interrupts
#asm("sei")

while (1)
      {
      // Place your code here   
        adc_buff = read_adc(FSK_IN);
        if(adc_buff > 0)        buff = 1;
        if(adc_buff < 1)        buff = 0;

      }
}