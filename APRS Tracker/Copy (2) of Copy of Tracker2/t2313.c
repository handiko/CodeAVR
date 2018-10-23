/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : APRS BEACON
Version : STRING TEST
Date    : 12/23/2011
Author  : HANDIKO GESANG ANUGRAH S.                            
Company : LABORATORIUM SENSOR DAN TELEKONTROL 
	  JURUSAN TEKNIK FISIKA 
          FAKULTAS TEKNIK 
          UNIVERSITAS GADJAH MADA

Chip type           : ATtiny2313
Program type        : Application
Clock frequency     : 11.059200 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 32

Polynomial Generator G(x) = x^16 + x^12 + x^5 + 1

*****************************************************/

#include <tiny2313.h>              
#include <delay.h>
#include <stdio.h> 
#include <string.h>

#ifndef RXB8
#define RXB8 1
#endif

#ifndef	UPE
#define UPE 2
#endif

#ifndef	OVR 
#define OVR 3 
#endif

#ifndef	FE
#define FE 4
#endif

#ifndef	UDRE
#define UDRE 5
#endif

#ifndef	RXC
#define RXC 7
#endif

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)
#define RX_BUFFER_SIZE 8

char rx_buffer[RX_BUFFER_SIZE];
bit rx_buffer_overflow;

#if RX_BUFFER_SIZE<256
	unsigned char rx_wr_index,rx_rd_index,rx_counter;
	#else
	unsigned int rx_wr_index,rx_rd_index,rx_counter;
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

#define _1200		0
#define _2200		1
#define CONST_1200      46
#define CONST_2400      20  // 22 = 2200Hz, = 2400Hz
#define CONST_POLYNOM   0b10001000000100001	// x^16 + x^12 + x^5 + 1 
//#define CONST_POLYNOM	0b11000000000000101	// x^16 + x^15 + x^2 + 1 

#define TX_NOW  PIND.3
#define PTT     PORTB.3 
#define DAC_0   PORTB.4
#define DAC_1   PORTB.5
#define DAC_2   PORTB.6
#define DAC_3   PORTB.7

#define L_TX	PORTD.4
#define L_BUSY	PORTD.5
#define L_STBY  PORTD.6

void protocol(void);
void send_data(char input);
void fliptone(void);
void set_dac(char value);
void send_tone(char nada);
//void send_fcs(char infcs);
void calc_fcs(char in);
//void getComma();
//void ekstrak_gps();
void init_usart(void);
void clear_usart(void);

flash char flag = 0x7E;
 
/*
char destination[7] = 
{     	'A'<<1, 'P'<<1, 'U'<<1, '2'<<1, '5'<<1, 'N'<<1, '2'<<1
}; 
char source[7] = 
{      	'Y'<<1, 'D'<<1, '2'<<1, 'X'<<1, 'B'<<1, 'C'<<1, '9'<<1
};                                  
char digi[7] = 
{       'W'<<1, 'I'<<1, 'D'<<1, 'E'<<1, '2'<<1, ' '<<1, ('2'<<1)
};
char digi2[7] = 
{       'W'<<1, 'I'<<1, 'D'<<1, 'E'<<1, '1'<<1, ' '<<1, ('1'<<1)+1
};
flash char control_field = 0x03;
flash unsigned char protocol_id = 0xF0;
flash char data_type = 0x21;
eeprom char latitude[8] = 
{	'0'<<1, '7'<<1, '4'<<1, '5'<<1, '.'<<1, '7'<<1, '9'<<1, 'S'<<1
        // 0745.79S
};
flash char symbol_table = (0x2F << 1);
eeprom char longitude[9] = 
{	'1'<<1, '1'<<1, '0'<<1, '0'<<1, '5'<<1, '.'<<1, '2'<<1, '1'<<1, 'E'<<1
        // 11005.21E
};
flash char symbol_code = (0x3E<<1);
flash char comment[] = 
{	'V'<<1, 'H'<<1, 'F'<<1, ' '<<1, 
	'D'<<1, 'i'<<1, 'g'<<1, 'i'<<1, 'p'<<1, 'e'<<1, 'a'<<1, 't'<<1, 'e'<<1, 'r'<<1, ' '<<1,
	'D'<<1, 's'<<1, '.'<<1, ' '<<1, 'P'<<1, 'o'<<1, 'g'<<1, 'u'<<1, 'n'<<1, 'g'<<1, ' '<<1,
        'k'<<1, 'i'<<1, 'd'<<1, 'u'<<1, 'l'<<1
};  */ 
flash char string[98] = 
{ 	('A'<<1),('P'<<1),('U'<<1),('2'<<1),('5'<<1),('N'<<1),0b11100000,
	('Y'<<1),('D'<<1),('2'<<1),('X'<<1),('B'<<1),('C'<<1),('1'<<1),
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1),
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('1'<<1),(' '<<1),0b01100011,
        
        0x03,0xF0,0x79,
        
        ('0'<<1),('7'<<1),('4'<<1),('5'<<1),('.'<<1),('5'<<1),('8'<<1),('S'<<1),
        ('/'<<1),
        ('1'<<1),('1'<<1),('0'<<1),('2'<<1),('2'<<1),('.'<<1),('2'<<1),('2'<<1),('E'<<1),
        
        ('$'<<1),
        
        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),('-'<<1),('2'<<1),(' '<<1),
        ('E'<<1),('x'<<1),('p'<<1),('e'<<1),('r'<<1),('i'<<1),('m'<<1),('e'<<1),('n'<<1),('t'<<1),('a'<<1),('l'<<1),(' '<<1),
        ('V'<<1),('H'<<1),('F'<<1),(' '<<1),
        ('D'<<1),('i'<<1),('g'<<1),('i'<<1),('p'<<1),('e'<<1),('a'<<1),('t'<<1),('e'<<1),('r'<<1),(' '<<1),
        ('{'<<1),('U'<<1),('I'<<1),('V'<<1),('3'<<1),('2'<<1),('}'<<1),
        
        0b00110100,
        0b10101000,
        0b00100111,
        0b11111010,
        0b11111001
};
unsigned char fcshi;
unsigned char fcslo;
char count_1 = 0;
char x_counter = 0;
bit flag_state;
bit crc_flag = 0;
bit tone = _1200;
long fcs_arr = 0;
flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};	// pemetaan tegangan sinusoidal

void tes_nada_1200(void)
{	char i;
	int j; 
        L_BUSY = 1;
	for(j=0; j<1200; j++) 
    	{	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
        		delay_us(CONST_1200);
        	}
    	}  
        L_BUSY = 0;
}

void tes_nada_2400(void)
{	char i;
	int j;
        L_STBY =1;
        for(j=0; j<2400; j++)
        {	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
                	delay_us(CONST_2400);
                } 
        }
        L_STBY = 0;
}

interrupt [EXT_INT1] void ext_int1_isr(void)
{	L_STBY = 0; 
        L_BUSY = 0;
        delay_ms(250);
        clear_usart(); 
        protocol();
        init_usart();
} 

/*

void protocol(void) 
{	char i;
        PTT = 1;      
        L_TX = 1;
        delay_ms(500);                  			// tunggu sampai radio stabil
        crc_flag = 0;
        flag_state = 1;
        for(i=0;i<30;i++)       send_data(flag);             	// kirim flag 24 kali 
        flag_state = 0;
        for(i=0;i<7;i++)        send_data(destination[i]);      // kirim callsign tujuan
        for(i=0;i<7;i++)        send_data(source[i]);           // kirim callsign asal
        for(i=0;i<7;i++)        send_data(digi[i]);             // kirim path digi  
        for(i=0;i<7;i++)        send_data(digi2[i]);            // kirim path digi
        send_data(control_field);                               // kirim data control field
        send_data(protocol_id);                                 // kirim data PID
        send_data(data_type);                                   // kirim data type info
        for(i=0;i<8;i++)        send_data(latitude[i]);         // kirim data lintang posisi
        send_data(symbol_table);                                // kirim simbol tabel
        for(i=0;i<9;i++)        send_data(longitude[i]);        // kirim data bujur posisi
        send_data(symbol_code);                                 // kirim simbol kode
        for(i=0;i<strlenf(comment);i++);      	send_data(comment[i]);          // kirim komen 
        crc_flag = 1;    	calc_fcs(0);	        	// hitung FCS                           
        send_fcs(fcshi);                                        // kirim 8 MSB dari FCS 
        send_fcs(fcslo);                                        // kirim 8 LSB dari FCS   
        flag_state = 1;
        for(i=0;i<24;i++)       send_data(flag);             	// kirim flag 12 kali 
        flag_state = 0; 
        PTT = 0;   
        L_TX = 0;
}   */

void send_data(char input) 
{	char i;
        bit x;
        for(i=0;i<8;i++) 
        {	x = (input >> i) & 0x01;
                //if(!flag_state)	calc_fcs(x);
                if(x) 
                {	//if(!flag_state) count_1++;
                        //if(count_1==5)  fliptone();
                        send_tone(tone);
                } 
                if(!x)  fliptone();
        }
}  

void protocol(void)
{	char i;
	for(i=0; i<50; i++)		send_data(flag);
	for(i=0; i<strlenf(string); i++)send_data(string[i]);
	for(i=0; i<15; i++)		send_data(flag);
}   

void fliptone(void) 
{	count_1 = 0;
        if(tone == _1200)
        {	tone = _2200;	
        	send_tone(tone);
        }                                       
        else
        {	tone = _1200;	
        	send_tone(tone);
        }
}        

void set_dac(char value) 
{	DAC_0 = value & 0x01;
        DAC_1 =( value >> 1 ) & 0x01;
        DAC_2 =( value >> 2 ) & 0x01;
        DAC_3 =( value >> 3 ) & 0x01;
}

void send_tone(char nada) 
{	char i;
	char j;
	if(nada == _1200) 
    	{	for(i=0; i<16; i++)
        	{	set_dac(matrix[i]);
        		delay_us(CONST_1200);
        	} 
    	} 
    	else
    	{	for(j=0; j<2; j++)
                {	for(i=0; i<16; i++)
                	{	set_dac(matrix[i]);
                        	delay_us(CONST_2400);
                	}
                }
    	}
}    

void send_fcs(char infcs) 
{	char j=7;
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
{	char i;
 	fcs_arr += in;                             
        x_counter++;       
   	if(crc_flag) 
        {	for(i=0;i<16;i++) 		// selesaikan hitungan
        	{	if((fcs_arr >> 16)==1) 	fcs_arr ^= CONST_POLYNOM;
          		fcs_arr <<= 1;
          	}
          	fcshi = fcs_arr >> 8; 		// ambil 8 bit paling kiri
       		fcslo = fcs_arr & 0b11111111; 	// ambil 8 bit paling kanan
    	}        
     	if((x_counter==17) && ((fcs_arr >> 16)==1)) 
        {	fcs_arr ^= CONST_POLYNOM; 
                x_counter -= 1;    
      	}      
        if(x_counter==17) 	x_counter -= 1;	// hitung terus 
       	fcs_arr <<= 1;
}

/*

void getComma()
{	while(getchar() != ',');
}

void ekstrak_gps()
{	char i;
        while(getchar() != '$');
        // led rx_gps on
	getchar();
        getchar();
        if(getchar() == 'G')
        {	if(getchar() == 'L')
        	{	if(getchar() == 'L')
                	{	getComma(); 
                        	for(i=0; i<7; i++)	latitude[i] = getchar();
                                getchar();
                                getchar(); 
                                getComma();
                                latitude[7] = getchar();
                                getComma();
                                for(i=0; i<8; i++)	longitude[i] = getchar();
                                getchar();
                                getchar();    
                                getComma();
                                longitude[8] = getchar();
                        }
                }
        }     
        // led rx gps off
} */

void init_usart(void)
{	UCSRA=0x00;
	UCSRB=0x90;
	UCSRC=0x06;
	UBRRH=0x00;
	UBRRL=0x8F; 
}

void clear_usart(void)
{ 	UCSRA=0;
	UCSRB=0;
	UCSRC=0;
	UBRRH=0;
	UBRRL=0;
}

void main(void) 
{	
#pragma optsize-
	CLKPR=0x80;
	CLKPR=0x00;
	#ifdef _OPTIMIZE_SIZE_ 
#pragma optsize+
	#endif    
        
	PORTB=0x00;
	DDRB=0xF8;
	PORTD=0x01;
	DDRD=0x70;
        
        ACSR=0x80;
        DIDR=0x00; 

	GIMSK=0x80;
	MCUCR=0x08;
	EIFR=0x80; 
        
        init_usart();  
        L_BUSY = 1;
        delay_ms(500);
        L_STBY = 1;
        delay_ms(500);
        L_BUSY = 0; 
        delay_ms(500);
        L_STBY = 0;
        
        #asm("sei")  
        
        while (1) 
        {	//ekstrak_gps(); 
                delay_ms(2000);
                tes_nada_1200();
                tes_nada_2400();
        };
}