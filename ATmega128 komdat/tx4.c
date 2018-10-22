/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 10/4/2013
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

#define BAUD    745
#define DF_1200 370     // dilatation factor 1200 --> 2.185
#define DF_2400 370

unsigned char data[100];
flash char matrix[16] = {10,12,13,14,13,12,10,7,4,2,1,0,1,2,4,7};
char m_idx = 0;
char tc = 0;
bit data_bit = 0;
char jumlah_sensor = 14;
unsigned char sensor[20];
int t_value = 0; 
unsigned int adc_buff = 0;
int t_value2= 0;
bit buff = 0;
bit b1 = 0;
bit b2 = 0;
bit b3 = 0;
char t0c = 0;

#define PANCAR  1
#define TERIMA  0

bit mode = PANCAR;

unsigned char read_adc(unsigned char adc_input);
void baca_sensor(char number);
void proses_data_1(void);
void proses_data_2(void);
void kirim_karakter(unsigned char c);
void kirim_data(void);
void kirim_string(char *str);
void init_porta(void);
void init_portc(void);
void init_portd(void);
void init_porte(void);
void init_portf(void);
void init_portg(void);
void init_port_all(void);

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

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
        // Place your code here  
        if(mode==PANCAR)
        {    
                TCNT0=247;  
                
                if(m_idx==16)   m_idx=0; 
                
                DAC_0 =  matrix[m_idx] & 0x01;
                DAC_1 = (matrix[m_idx] >> 1) & 0x01;
                DAC_2 = (matrix[m_idx] >> 2) & 0x01;
                DAC_3 = (matrix[m_idx] >> 3) & 0x01;
                
                if(data_bit==1)
                { 
                        if((tc==0)||(tc==2))
                        {
                                m_idx++;
                        }       
                }
                else
                {   
                        m_idx++;
                }    
                         
                /*/------------------
                
                //adc_buff = read_adc(FSK_IN);
                //if(adc_buff > 1)        buff = 1;
                //if(adc_buff < 2)        buff = 0;  
                
                if((tc==0)||((tc % 4)==0))
                {                 
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
                
                adc_buff = read_adc(FSK_IN);
                if(adc_buff > 1)        buff = 1;
                if(adc_buff < 2)        buff = 0; 
                
                buff = 0;             
                
                t0c++;
                
                //if(adc_buff > 0)      buff = 1;  
                if(t0c > 126)   t0c = 0;
                
                }
          
                *///-----------------    
                
                if(tc==2)       tc = 1;
                else            tc++;
        }
           
        if(mode==TERIMA)
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
}

// Timer1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
        // Place your code here  
        if(mode==PANCAR)
        {  
                TCNT1H=11536 >> 8;
                TCNT1L=11536 & 0xFF;
        }   
        
        if(mode==TERIMA)
        {
        }
}

// Declare your global variables here

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

void proses_data_1(void)
{
        char i;
        
        t_value = 0;   
        t_value2= 0;
        
        data[0] = '$';
        
        data[1] = 'B';
        data[2] = 'E';
        data[3] = 'A';
        data[4] = 'C';
        data[5] = 'O';
        data[6] = 'N';
        data[7] = '2';
        data[8] = '-';
        data[9] = '1';          
        data[10]= ',';
                          
        for(i=1;i<11;i++)      t_value += data[i];
                         
        t_value += sensor[0];
        t_value2 += sensor[0];
        data[11]= sensor[0] / 100;      sensor[0] %= 100;       data[11] += '0';
        data[12]= sensor[0] / 10;                               data[12] += '0';
        data[13]= sensor[0] % 10;                               data[13] += '0';
                    
        t_value += sensor[1];
        t_value2 += sensor[1];
        data[14]= sensor[1] / 100;      sensor[1] %= 100;       data[14] += '0';       
        data[15]= sensor[1] / 10;                               data[15] += '0';
        data[16]= sensor[1] % 10;                               data[16] += '0';
                    
        t_value += sensor[2];
        t_value2 += sensor[2];
        data[17]= sensor[2] / 100;      sensor[2] %= 100;       data[17] += '0';
        data[18]= sensor[2] / 10;                               data[18] += '0';
        data[19]= sensor[2] % 10;                               data[19] += '0';
                    
        t_value += sensor[3];
        t_value2 += sensor[3];
        data[20]= sensor[3] / 100;      sensor[3] %=  100;      data[20] += '0';
        data[21]= sensor[3] / 10;                               data[21] += '0';
        data[22]= sensor[3] % 10;                               data[22] += '0';
                    
        t_value += sensor[4];
        t_value2 += sensor[4];
        data[23]= sensor[4] / 100;      sensor[4] %=  100;      data[23] += '0';
        data[24]= sensor[4] / 10;                               data[24] += '0';
        data[25]= sensor[4] % 10;                               data[25] += '0';
          
        data[26]= 'S';  
        t_value += data[26];
                           
        t_value += t_value2;
        data[27]= t_value2 / 1000;       t_value2 %=  1000;      data[27] += '0';
        data[28]= t_value2 / 100;        t_value2 %=  100;       data[28] += '0';
        data[29]= t_value2 / 10;                                 data[29] += '0';
        data[30]= t_value2 % 10;                                 data[30] += '0';
        
        data[31]= 'P';
        t_value += data[31];
        
        data[32]= t_value / 1000;       t_value %=  1000;       data[32] += '0';
        data[33]= t_value / 100;        t_value %=  100;        data[33] += '0';
        data[34]= t_value / 10;                                 data[34] += '0';
        data[35]= t_value % 10;                                 data[35] += '0'; 
        
        data[36]= '*';  
        
        t_value = 0;   
        t_value2= 0;
}

void proses_data_2(void)
{
        char i;
        
        t_value = 0;   
        t_value2= 0;
        
        data[0] = '$';
        
        data[1] = 'B';
        data[2] = 'E';
        data[3] = 'A';
        data[4] = 'C';
        data[5] = 'O';
        data[6] = 'N';
        data[7] = '2';
        data[8] = '-';
        data[9] = '2';          
        data[10]= ',';
                          
        for(i=0;i<11;i++)      t_value += data[i];
                         
        t_value += sensor[5];
        t_value2 += sensor[5];
        data[11]= sensor[5] / 100;      sensor[5] %= 100;       data[11] += '0';
        data[12]= sensor[5] / 10;                               data[12] += '0';
        data[13]= sensor[5] % 10;                               data[13] += '0';
                    
        t_value += sensor[6];
        t_value2 += sensor[6];
        data[14]= sensor[6] / 100;      sensor[6] %= 100;       data[14] += '0';       
        data[15]= sensor[6] / 10;                               data[15] += '0';
        data[16]= sensor[6] % 10;                               data[16] += '0';
                    
        t_value += sensor[7];
        t_value2 += sensor[7];
        data[17]= sensor[7] / 100;      sensor[7] %= 100;       data[17] += '0';
        data[18]= sensor[7] / 10;                               data[18] += '0';
        data[19]= sensor[7] % 10;                               data[19] += '0';
                    
        t_value += sensor[8];
        t_value2 += sensor[8];
        data[20]= sensor[8] / 100;      sensor[8] %=  100;      data[20] += '0';
        data[21]= sensor[8] / 10;                               data[21] += '0';
        data[22]= sensor[8] % 10;                               data[22] += '0';
                    
        t_value += sensor[9];
        t_value2 += sensor[9];
        data[23]= sensor[9] / 100;      sensor[9] %=  100;      data[23] += '0';
        data[24]= sensor[9] / 10;                               data[24] += '0';
        data[25]= sensor[9] % 10;                               data[25] += '0';
          
        data[26]= 'S'; 
        t_value += data[26];
                              
        t_value += t_value2;
        data[27]= t_value2 / 1000;       t_value2 %=  1000;      data[27] += '0';
        data[28]= t_value2 / 100;        t_value2 %=  100;       data[28] += '0';
        data[29]= t_value2 / 10;                                 data[29] += '0';
        data[30]= t_value2 % 10;                                 data[30] += '0';
        
        data[31]= 'P'; 
        t_value += data[31];
        
        data[32]= t_value / 1000;       t_value %=  1000;       data[32] += '0';
        data[33]= t_value / 100;        t_value %=  100;        data[33] += '0';
        data[34]= t_value / 10;                                 data[34] += '0';
        data[35]= t_value % 10;                                 data[35] += '0'; 
        
        data[36]= '*'; 
        
        t_value = 0;   
        t_value2= 0;
}

void kirim_karakter(unsigned char c)
{
        char i;
        
        c = (1 << 9) + (c << 1);
        
        for(i=0;i<10;i++)
        {
                data_bit = (c >> i) & 0x01;
                if(data_bit)    delay_us(DF_1200*2);
                else            delay_us(DF_2400*2);
        }     
        
        data_bit = 1;
        delay_us(DF_1200*2);
}

void kirim_data(void)
{
        char x;
        
        for(x=0;x<37;x++)       kirim_karakter(data[x]);
}

void kirim_string(char *str)
{
        char k;
        while (k=*str++)        kirim_karakter(k);
        kirim_karakter(10);
}

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
        
        if(DEBUG_2==PANCAR)     mode = PANCAR;
        if(DEBUG_2==TERIMA)     mode = TERIMA;
        
        if(mode==PANCAR)
        {  
                // Timer/Counter 0 initialization
                // Clock source: System Clock
                // Clock value: 345.600 kHz
                // Mode: Normal top=0xFF
                // OC0 output: Disconnected
                ASSR=0x00;
                TCCR0=0x03;
                TCNT0=247;
                OCR0=0x00;

                // Timer/Counter 1 initialization
                // Clock source: System Clock
                // Clock value: 10.800 kHz
                // Mode: Normal top=0xFFFF
                // OC1A output: Discon.
                // OC1B output: Discon.
                // OC1C output: Discon.
                // Noise Canceler: Off
                // Input Capture on Falling Edge
                // Timer1 Overflow Interrupt: On
                // Input Capture Interrupt: Off
                // Compare A Match Interrupt: Off
                // Compare B Match Interrupt: Off
                // Compare C Match Interrupt: Off
                TCCR1A=0x00;
                TCCR1B=0; //0x05;
                TCNT1H=11536 >> 8;
                TCNT1L=11536 & 0xFF;
                
                // Timer(s)/Counter(s) Interrupt(s) initialization
                TIMSK=0x01; //0x05;

                ETIMSK=0x00;

                // ADC initialization
                // ADC Clock frequency: 691.200 kHz
                // ADC Voltage Reference: AREF pin
                // Only the 8 most significant bits of
                // the AD conversion result are used
                ADMUX=ADC_VREF_TYPE & 0xff;
                ADCSRA=0x84;
                
                // Global enable interrupts
                #asm("sei")

                data_bit = 1;

                while (1)
                {
                        // Place your code here 
                        baca_sensor(jumlah_sensor);
                        proses_data_1(); 
                          
                        PTT = 1;  
                        TCCR0=0x03;     
                        
                        delay_ms(250);
                        
                        kirim_karakter(13);
                        kirim_data();
                        kirim_karakter(13);
                        kirim_data();
                        kirim_karakter(13);
                        kirim_data();
                        kirim_karakter(13); 
                         
                        TCCR0=0x00;
                        PTT = 0;
                 
                        delay_ms(7000);
                        
                        baca_sensor(jumlah_sensor);
                        proses_data_2();  
                           
                        PTT = 1; 
                        TCCR0=0x03;
                        
                        delay_ms(250);
                        
                        kirim_karakter(13);
                        kirim_data();
                        kirim_karakter(13);
                        kirim_data();
                        kirim_karakter(13);
                        kirim_data();
                        kirim_karakter(13); 
                          
                        TCCR0=0x00;
                        PTT = 0;
                 
                        delay_ms(7000);
                }
        }    
        
        if(mode==TERIMA)
        {
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
}
