/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/13/2012
Author  : 
Company : 
Comments: 


Chip type               : ATmega8535
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 128
*****************************************************/

#include <mega8535.h>
#include <stdio.h>

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

#define RX_BUFFER_SIZE 8
#define TX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];
char tx_buffer[TX_BUFFER_SIZE];
char GPRMC[100];
bit rx_buffer_overflow;

#if RX_BUFFER_SIZE<256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

#if TX_BUFFER_SIZE<256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

interrupt [USART_RXC] void usart_rx_isr(void)
{	char status,data;
	status=UCSRA;
	data=UDR;
	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   	{	rx_buffer[rx_wr_index]=data;
   		if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   		if (++rx_counter == RX_BUFFER_SIZE)
      	{	rx_counter=0;
      		rx_buffer_overflow=1;
      	};
   	};
}

interrupt [USART_TXC] void usart_tx_isr(void)
{	if (tx_counter)
   	{	--tx_counter;
   		UDR=tx_buffer[tx_rd_index];
   		if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   	};
}

#ifndef _DEBUG_TERMINAL_IO_
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{	char data;
	while (rx_counter==0);
	data=rx_buffer[rx_rd_index];
	if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	#asm("cli")
	--rx_counter;
	#asm("sei")
	return data;
}
#pragma used-
#endif

#ifndef _DEBUG_TERMINAL_IO_
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{	while (tx_counter == TX_BUFFER_SIZE);
	#asm("cli")
	if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   	{	tx_buffer[tx_wr_index]=c;
   		if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   		++tx_counter;
   	}
	else
   	UDR=c;
	#asm("sei")
}
#pragma used-
#endif

#include <string.h>
#include <ctype.h>
#include <delay.h>

#define DAC_0	PORTB.0
#define DAC_1	PORTB.1
#define DAC_2	PORTB.2
#define DAC_3	PORTB.3

#define PTT	PORTB.4

#define STBY_LED	PORTD.3
#define TX_LED		PORTD.4
#define AUX_LED		PORTD.5

#define MODE	PIND.6
#define TX_NOW	PIND.7

#define on	1
#define off 0

#define PTT_ON	(PTT = on)
#define PTT_OFF	(PTT = off)
#define TX_LED_ON	(TX_LED = on)
#define TX_LED_OFF	(TX_LED = off)
#define STBY_LED_ON	(STBY_LED = off)
#define STBY_LED_OFF	(STBY_LED = off)

#define CONST_1200      52
#define CONST_2200      (CONST_1200/2)
#define CONST_POLYNOM   0b10001000000100001	// x^16 + x^12 + x^5 + 1 
//#define CONST_POLYNOM	0b11000000000000101	// x^16 + x^15 + x^2 + 1 

flash char flag[24] = 
{	0x7E,0x7E,0x7E,0x7E,
    0x7E,0x7E,0x7E,0x7E,
    0x7E,0x7E,0x7E,0x7E,
    0x7E,0x7E,0x7E,0x7E,
    0x7E,0x7E,0x7E,0x7E,
    0x7E,0x7E,0x7E,0x7E
};
flash char ssid_2 = 0b01100100;
flash char ssid_9 = 0b01110010;
flash char ssid_2final = 0b01100101;
//flash char ssid_9final = 0b01110011;
eeprom char destination[7] = 
{   0x41,0x50,0x55,0x32,0x35,0x4D,
    0               // SSID 
    // APU25N-2     // 0b011SSIDx format, SSID = 2 = 0b0010
}; 
eeprom char source[7] = 
{   0x59,0x44,0x32,0x58,0x42,0x43,
    0               // SSID    
    // YD2XBC-9     // 0b011SSIDx format, SSID = 9 = 0b1001
};                                  
eeprom char digi[7] = 
{   // 0x57,0x49,0x44,0x45,0x32,0x32,0x20    // atau
    0x57,0x49,0x44,0x45,0x32,
    0,              // SSID
    0x20 
    // WIDE2-2      // 0b011SSIDx format, SSID = 2 = 0b0010
};
char destination_final[7];
char source_final[7];
char digi_final[7];
flash char control_field = 0x03;
flash char protocol_id = 0xF0;
flash char data_type = 0x21;
eeprom char latitude[8] = 
{	0x30,0x37,0x34,0x35,0x2E,0x37,0x39,0x53					// format string
    // 0,7,4,5,0x2E,7,9,0x53								// format int
    // 0745.79S
};
eeprom char symbol_table = 0x2F;
eeprom char longitude[9] = 
{	0x31,0x31,0x30,0x30,0x35,0x2E,0x32,0x31,0x45
    // 1,1,0,0,5,0x2E,2,1,0x45
    // 11005.21E
};
eeprom char symbol_code = 0x3E;
eeprom char comment[43] = 
{	0x54,0x45,0x53,0x54,0x49,0x4E,0x47,0x20,                // testing(spasi)
    0x46,0x4F,0x52,0x20,                                    // for(spasi)
    0x45,0x4D,0x45,0x52,0x47,0x45,0x4E,0x43,0x59,0x20,      // emergency(spasi)
    0x42,0x45,0x41,0x43,0x4F,0x4E,0x20,                     // beacon(spasi)
    0x20,0x20,0x20,0x20,0x20,0x20,0x20,                     // (spasi)
    0x20,0x20,0x20,0x20,0x20,0x20,0x20                      // (spasi)
    // testing for emergency beacon
}; 
bit flag_state;
bit crc_flag = 0;
int tone = 1200;
char fcshi;
char fcslo;
char count_1 = 0;
char x_counter = 0;
unsigned char xcount = 0;
long fcs_arr = 0;

void init_data(void);
void protocol(void);
void send_data(char input);
void fliptone(void);
void set_dac(char value);
void send_tone(int nada);
void send_fcs(char infcs);
void calc_fcs(char in);

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{	xcount++;
    if((xcount>1) && (xcount<80))	AUX_LED = on;
    else AUX_LED = off;
    TCNT0=0xFF;
}

void init_data(void) 
{	int i;
    for(i=0;i<7;i++) 
    {  	digi_final[i] = digi[i] << 1;
        destination_final[i] = destination[i] << 1;
        source_final[i] = source[i] << 1;
    }  
        
    destination_final[6] = ssid_2;
    source_final[6] = ssid_9;
    digi_final[5] = ssid_2final;
}

void protocol(void) 
{	int i;
        
    init_data();											// persiapkan bit shifting
        
    PTT_ON;   
    TX_LED_ON;
    delay_ms(250);                  						// tunggu sampai radio stabil
        
    crc_flag = 0;
    flag_state = 1;
    for(i=0;i<24;i++)       send_data(flag[i]);             // kirim flag 24 kali 
    flag_state = 0;
    for(i=0;i<7;i++)        send_data(destination_final[i]);// kirim callsign tujuan
    for(i=0;i<7;i++)        send_data(source_final[i]);     // kirim callsign asal 
    send_data(ssid_9);
    for(i=0;i<7;i++)        send_data(digi_final[i]);       // kirim path digi
    send_data(control_field);                               // kirim data control field
    send_data(protocol_id);                                 // kirim data PID
    send_data(data_type);                                   // kirim data type info
    for(i=0;i<8;i++)        send_data(latitude[i]);         // kirim data lintang posisi
    send_data(symbol_table);                                // kirim simbol tabel
    for(i=0;i<9;i++)        send_data(longitude[i]);        // kirim data bujur posisi
    send_data(symbol_code);                                 // kirim simbol kode
    for(i=0;i<43;i++);      send_data(comment[i]);          // kirim komen 
    crc_flag = 1;    		calc_fcs(0);	               		// hitung FCS                           
    send_fcs(fcshi);                                        // kirim 8 MSB dari FCS 
    send_fcs(fcslo);                                        // kirim 8 LSB dari FCS   
    flag_state = 1;
    for(i=0;i<12;i++)       send_data(flag[i]);             // kirim flag 12 kali 
    flag_state = 0; 
    PTT_OFF; 
    TX_LED_OFF;
}

void send_data(char input) 
{	int i;
    bit x;
    for(i=0;i<8;i++)
    {	x = (input >> i) & 0x01;
        if(!flag_state)	calc_fcs(x);
        if(x)
        {	if(!flag_state) count_1++;
            if(count_1==5)  fliptone();
            send_tone(tone);
        } 
        if(!x)  fliptone();
    }
}     

void fliptone(void) 
{	count_1 = 0;
    switch(tone) 
    {	case 1200:      tone=2200;      send_tone(tone);        break;
        case 2200:      tone=1200;      send_tone(tone);        break;
    }
}        

void set_dac(char value) 
{	DAC_0 = value & 0x01;
    DAC_1 =( value >> 1 ) & 0x01;
    DAC_2 =( value >> 2 ) & 0x01;
    DAC_3 =( value >> 3 ) & 0x01;
}

void send_tone(int nada) 
{	if(nada==1200) 
    {	set_dac(7);     delay_us(CONST_1200);     
                          
        set_dac(10);    delay_us(CONST_1200);  
        set_dac(13);    delay_us(CONST_1200);      
        set_dac(14);    delay_us(CONST_1200);    
                        
        set_dac(15);    delay_us(CONST_1200); 
                        
        set_dac(14);    delay_us(CONST_1200);
        set_dac(13);    delay_us(CONST_1200); 
        set_dac(10);    delay_us(CONST_1200);
                        
        set_dac(7);     delay_us(CONST_1200);
                        
        set_dac(5);     delay_us(CONST_1200);
        set_dac(2);     delay_us(CONST_1200);
        set_dac(1);     delay_us(CONST_1200);
                        
        set_dac(0);     delay_us(CONST_1200);
                        
        set_dac(1);     delay_us(CONST_1200);
        set_dac(2);     delay_us(CONST_1200);
        set_dac(5);     delay_us(CONST_1200);
    } 
                                   
    else 
    {  	set_dac(7);     delay_us(CONST_2200);     
                          
        set_dac(10);    delay_us(CONST_2200);  
        set_dac(13);    delay_us(CONST_2200);      
        set_dac(14);    delay_us(CONST_2200);    
                        
        set_dac(15);    delay_us(CONST_2200); 
                        
        set_dac(14);    delay_us(CONST_2200);
        set_dac(13);    delay_us(CONST_2200); 
        set_dac(10);    delay_us(CONST_2200);
                        
        set_dac(7);     delay_us(CONST_2200);
                        
        set_dac(5);     delay_us(CONST_2200);
        set_dac(2);     delay_us(CONST_2200);
        set_dac(1);     delay_us(CONST_2200);
                        
        set_dac(0);     delay_us(CONST_2200);
                        
        set_dac(1);     delay_us(CONST_2200);
        set_dac(2);     delay_us(CONST_2200);
        set_dac(5);     delay_us(CONST_2200);
                
        set_dac(7);     delay_us(CONST_2200);     
                          
        set_dac(10);    delay_us(CONST_2200);  
        set_dac(13);    delay_us(CONST_2200);      
        set_dac(14);    delay_us(CONST_2200);    
                        
        set_dac(15);    delay_us(CONST_2200); 
                        
        set_dac(14);    delay_us(CONST_2200);
        set_dac(13);    delay_us(CONST_2200); 
        set_dac(10);    delay_us(CONST_2200);
                        
        set_dac(7);     delay_us(CONST_2200);
                        
        set_dac(5);     delay_us(CONST_2200);
        set_dac(2);     delay_us(CONST_2200);
        set_dac(1);     delay_us(CONST_2200);
                        
        set_dac(0);     delay_us(CONST_2200);
                        
        set_dac(1);     delay_us(CONST_2200);
        set_dac(2);     delay_us(CONST_2200);
        set_dac(5);     delay_us(CONST_2200);
    }
}    

void send_fcs(char infcs) 
{	int j=7;
	bit x;
	while(j>0) 
    {	x = (infcs >> j) & 0x01; 
        if(x) 
        {	count_1++;
            if(count_1==5)    fliptone();
            send_tone(tone);
        } 
        if(!x)  fliptone();
        j--;      
	}
}                   

void calc_fcs(char in) 
{	int i;
 	fcs_arr += in;
  	x_counter++;     
          
   	if(crc_flag) 
    {	for(i=0;i<16;i++) 
        {	if((fcs_arr >> 16)==1) 
            {	fcs_arr ^= CONST_POLYNOM;
            }
          	fcs_arr <<= 1;
    	}
    	fcshi = fcs_arr >> 8; 			// ambil 8 bit paling kiri
    	fcslo = fcs_arr & 0b11111111; 	// ambil 8 bit paling kanan
    }        
        
    if((x_counter==17) && ((fcs_arr >> 16)==1)) 
    {	fcs_arr ^= CONST_POLYNOM; 
        x_counter -= 1;    
    }      
        
    if(x_counter==17) 
    {	x_counter -= 1; 
    }
          
    fcs_arr <<= 1;
} 

void TerimaGps(void)
{	int i;
	for(i=0; i<100; i++)
	GPRMC[i] = getchar();
}

char last_marker;
char buffer[2][11];
char cari_koma(char marker_koma);
char lintang(char marker_lintang);
char bujur(char marker_bujur);
void ParsingLintang(void);
void ParsingBujur(void);
void ParsingGps(void)
{	int i;
	for(i=0; i<strlen(GPRMC); i++)
    {	if(GPRMC[i]=='$')
    	{     
        if(GPRMC[i+1]=='G')
        {  
        if(GPRMC[i+2]=='P')
        {   
        if(GPRMC[i+3]=='R')
        { 
        if(GPRMC[i+4]=='M')
        { 	
        if(GPRMC[i+5]=='C')
        {	i += 5;
        	last_marker = i;
        	last_marker = cari_koma(last_marker);
        	last_marker = lintang(last_marker); 
        	last_marker = cari_koma(last_marker);
        	last_marker = bujur(last_marker); 
        	last_marker = cari_koma(last_marker);  
            ParsingLintang();
            ParsingBujur();
        }}}}}}
    }
}

char cari_koma(char marker_koma)
{	int i;
	marker_koma += 1;
	if(GPRMC[marker_koma] == ',')
	last_marker = marker_koma;
	else
    {	for(i=marker_koma;;i++)
    	{	last_marker = i;
        	if(GPRMC[i]==',')
            break;
        }
    }  
    return (last_marker);
}

char lintang(char marker_lintang)
{ 	int i;
	marker_lintang += 1;
    for(i=marker_lintang;;i++)
    { 	if(GPRMC[i]==',')       
    	break;
        buffer[0][i-marker_lintang]=GPRMC[i];
        last_marker=i;
    }
    return (last_marker);
}

char bujur(char marker_bujur)
{ 	int i;
	marker_bujur += 1;
    for(i=marker_bujur;;i++)
    { 	if(GPRMC[i]==',')       
    	break;
        buffer[1][i-marker_bujur]=GPRMC[i];
        last_marker=i;
    }
    return (last_marker);
}

void ParsingLintang(void)
{	int i;
	for(i=0; i<7; i++) latitude[i]=buffer[0][i];
    latitude[7]='S';
}

void ParsingBujur(void)
{	int i;
	for(i=0; i<8; i++) longitude[i]=buffer[1][i];
    longitude[8]='E';
}

void main(void)
{	// Port B initialization
	// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
	// State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=0 State0=0 
	PORTB=0x00;
	DDRB=0x1F;

	// Port D initialization
	// Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=In 
	// State7=P State6=P State5=0 State4=0 State3=0 State2=T State1=0 State0=T 
	PORTD=0xC0;
	DDRD=0x3A;
    
    // USART initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART Receiver: On
	// USART Transmitter: On
	// USART Mode: Asynchronous
	// USART Baud Rate: 4800
	UCSRA=0x00;
	UCSRB=0xD8;
	UCSRC=0x86;
	UBRRH=0x00;
	UBRRL=0x8F; 
    
    // Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: 10.800 kHz
	// Mode: Normal top=0xFF
	// OC0 output: Disconnected
	TCCR0=0x05;
	TCNT0=0xFF;
	OCR0=0x00;

	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=0x01;

	ACSR=0x80;
	SFIOR=0x00;

	#asm("sei")
    
    STBY_LED = on;

	while (1)
    {	STBY_LED = on;
    	if((MODE) && (TX_NOW))
    	{	TerimaGps();
    		ParsingGps(); 
        	#asm("cli")   
    		protocol();   
        	#asm("sei")	
            delay_ms(10000);
        	delay_ms(10000);
            delay_ms(10000);
        }
    	if((!MODE) && (TX_NOW))
        {	delay_ms(10000);
        	delay_ms(10000);
            delay_ms(10000); 
        	#asm("cli")   
    		protocol();   
        	#asm("sei")
        }
        if(!TX_NOW)
        { 	delay_ms(250);
        	STBY_LED = off; 
        	#asm("cli")   
    		protocol();   
        	#asm("sei")
        }
    }
}
