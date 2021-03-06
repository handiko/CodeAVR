/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 1/11/2012
Author  : 
Company : 
Comments: 


Chip type               : ATmega8535
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 128

Polynomial Generator G(x) = x^16 + x^12 + x^5 + 1

*****************************************************/

#include <binclude.h>
#include <versi2pinout.h>

#define USART_ENABLED	(usart_status_=1)
#define USART_DISABLED	(usart_status_=0)
#define GPS_ENABLED	(gps_status=1)
#define GPS_DISABLED	(gps_status=0)

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

#define RX_BUFFER_SIZE 8 
#define TX_BUFFER_SIZE 8

#define on	1
#define off	0

#define PTT_ON	(PTT = on)
#define PTT_OFF	(PTT = off)
#define TX_LED_ON	(TX_LED = on)
#define TX_LED_OFF	(TX_LED = off)
#define STBY_LED_ON	(STBY_LED = off)
#define STBY_LED_OFF	(STBY_LED = off)

#define CONST_1200      52
#define CONST_2200      28
#define CONST_POLYNOM   0b10001000000100001	// x^16 + x^12 + x^5 + 1 
//#define CONST_POLYNOM	0b11000000000000101	// x^16 + x^15 + x^2 + 1 

flash char flag[24] = {
 	0x7E,0x7E,0x7E,0x7E,
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
eeprom char destination[7] = {         
        0x41,0x50,0x55,0x32,0x35,0x4D,
        0               // SSID 
        // APU25N-2     // 0b011SSIDx format, SSID = 2 = 0b0010
}; 
eeprom char source[7] = {              
        0x59,0x44,0x32,0x58,0x42,0x43,
        0               // SSID    
        // YD2XBC-9     // 0b011SSIDx format, SSID = 9 = 0b1001
};                                  
eeprom char digi[7] = {                
        // 0x57,0x49,0x44,0x45,0x32,0x32,0x20    // atau
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
eeprom char latitude[8] = {
        0x30,0x37,0x34,0x35,0x2E,0x37,0x39,0x53			// format string
        // 0,7,4,5,0x2E,7,9,0x53				// format int
        // 0745.79S
};
eeprom char symbol_table = 0x2F;
eeprom char longitude[9] = {
        0x31,0x31,0x30,0x30,0x35,0x2E,0x32,0x31,0x45
        // 1,1,0,0,5,0x2E,2,1,0x45
        // 11005.21E
};
eeprom char symbol_code = 0x3E;
eeprom char comment[43] = {
        0x54,0x45,0x53,0x54,0x49,0x4E,0x47,0x20,                // testing(spasi)
        0x46,0x4F,0x52,0x20,                                    // for(spasi)
        0x45,0x4D,0x45,0x52,0x47,0x45,0x4E,0x43,0x59,0x20,      // emergency(spasi)
        0x42,0x45,0x41,0x43,0x4F,0x4E,0x20,                     // beacon(spasi)
        0x20,0x20,0x20,0x20,0x20,0x20,0x20,                     // (spasi)
        0x20,0x20,0x20,0x20,0x20,0x20,0x20                      // (spasi)
        // testing for emergency beacon
}; 
eeprom char gpsString[300];
char gpsString_buff[300];
char tx_buffer[TX_BUFFER_SIZE];
char rx_buffer[RX_BUFFER_SIZE]; 
bit rx_buffer_overflow;
bit usart_status_; 
bit flag_state;
bit crc_flag = 0;
bit gps_status;
int tone = 1200;
char fcshi;
char fcslo;
char count_1 = 0;
char x_counter = 0;
long fcs_arr = 0;

void init_data(void);
void protocol(void);
void send_data(char input);
void fliptone(void);
void set_dac(char value);
void send_tone(int nada);
void send_fcs(char infcs);
void calc_fcs(char in);
void USART_init(unsigned int baud_rate);

#if (RX_BUFFER_SIZE<256)
	unsigned char rx_wr_index,rx_rd_index,rx_counter;
	#else
	unsigned int rx_wr_index,rx_rd_index,rx_counter; 
#endif

#if (TX_BUFFER_SIZE<256) 
        unsigned char tx_wr_index,tx_rd_index,tx_counter;
	#else
        unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

#ifndef _DEBUG_TERMINAL_IO_
	#define _ALTERNATE_GETCHAR_
#pragma used+
	char getchar(void) {
		char data;
		while (rx_counter==0);
		data=rx_buffer[rx_rd_index];
		if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
		#asm("cli")
		--rx_counter;
		#asm("sei")
		return data;
	}
#pragma used-

	#define _ALTERNATE_PUTCHAR_
#pragma used+
	void putchar(char c) {
		while (tx_counter == TX_BUFFER_SIZE);
		#asm("cli")
		if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0)) {
   			tx_buffer[tx_wr_index]=c;
   			if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
   			++tx_counter;
   		}
		else
   		UDR=c;
		#asm("sei")
	}
#pragma used-
#endif 

interrupt [USART_RXC] void usart_rx_isr(void) {
	if(usart_status_) {
		char status,data;
		status=UCSRA;
		data=UDR;
		if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0) {
   			rx_buffer[rx_wr_index]=data;
   			if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   			if (++rx_counter == RX_BUFFER_SIZE) {
      				rx_counter=0;
      				rx_buffer_overflow=1;
      			};
   		}; 
        } 
} 

interrupt [USART_TXC] void usart_tx_isr(void) {
	if(usart_status_) {
		if (tx_counter) {
   			--tx_counter;
   			UDR=tx_buffer[tx_rd_index];
   			if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   		}; 
        }
}

void init_data(void) {
	int i;
        for(i=0;i<7;i++) {      
                digi_final[i] = digi[i] << 1;
                destination_final[i] = destination[i] << 1;
                source_final[i] = source[i] << 1;
        }  
        
        destination_final[6] = ssid_2;
        source_final[6] = ssid_9;
        digi_final[5] = ssid_2final;
}

void protocol(void) {
        int i;
        
        init_data();						// persiapkan bit shifting
        
        PTT_ON;   
        TX_LED_ON;
        delay_ms(250);                  			// tunggu sampai radio stabil
        
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
        crc_flag = 1;    	calc_fcs(0);	               	// hitung FCS                           
        send_fcs(fcshi);                                        // kirim 8 MSB dari FCS 
        send_fcs(fcslo);                                        // kirim 8 LSB dari FCS   
        flag_state = 1;
        for(i=0;i<12;i++)       send_data(flag[i]);             // kirim flag 12 kali 
        flag_state = 0; 
        PTT_OFF; 
        TX_LED_OFF;
}

void send_data(char input) {
        int i;
        bit x;
        for(i=0;i<8;i++) {
                x = (input >> i) & 0x01;
                if(!flag_state)	calc_fcs(x);
                if(x) {
                        if(!flag_state) count_1++;
                        if(count_1==5)  fliptone();
                        send_tone(tone);
                } 
                if(!x)  fliptone();
        }
}     

void fliptone(void) {
        count_1 = 0;
        switch(tone) {
                case 1200:      tone=2200;      send_tone(tone);        break;
                case 2200:      tone=1200;      send_tone(tone);        break;
        }
}        

void set_dac(char value) {
        DAC_0 = value & 0x01;
        DAC_1 =( value >> 1 ) & 0x01;
        DAC_2 =( value >> 2 ) & 0x01;
        DAC_3 =( value >> 3 ) & 0x01;
}

void send_tone(int nada) {
	if(nada==1200) {
                set_dac(7);     delay_us(CONST_1200);     
                          
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
                                   
        else {               
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

void send_fcs(char infcs) {
        int j=7;
        bit x;
        while(j>0) {
                x = (infcs >> j) & 0x01; 
                if(x) {
                        count_1++;
                        if(count_1==5)    fliptone();
                        send_tone(tone);
                } 
                if(!x)  fliptone();
                j--;      
        }
}                   

void calc_fcs(char in) {
	int i;
 	fcs_arr += in;
  	x_counter++;     
          
   	if(crc_flag) {
      	 	for(i=0;i<16;i++) {
                	if((fcs_arr >> 16)==1) {
      	 			fcs_arr ^= CONST_POLYNOM;
                        }
          		fcs_arr <<= 1;
          	}
          	fcshi = fcs_arr >> 8; 		// ambil 8 bit paling kiri
       		fcslo = fcs_arr & 0b11111111; 	// ambil 8 bit paling kanan
    	}        
        
     	if((x_counter==17) && ((fcs_arr >> 16)==1)) {
         	fcs_arr ^= CONST_POLYNOM; 
                x_counter -= 1;    
      	}      
        
        if(x_counter==17) {
         	x_counter -= 1; 
        }
          
       	fcs_arr <<= 1;
}  

void TerimaMentahGPS(void) {
        int i;
        for(i=0; i<300; i++) {
         	gpsString[i] = gpsString_buff[i] = getchar();
        } 
        
}

void ParsingStringGPS(void) {
 	int i, j, k, hitung_koma=0;
        for(i=0; i<strlen(gpsString_buff); i++) {  
        	if(     (
                	(gpsString[i] == '$') &&
                        (gpsString[i+3] == 'R') && 
                        (gpsString[i+4] == 'M') && 
                	(gpsString[i+5] == 'C')
                        )) {
                        for(k=i; k<strlen(gpsString_buff); k++) {
                           	if(gpsString[k] == ',') hitung_koma++;
                		if((hitung_koma == 2) && (gpsString[k+1] == 'V')) goto lompat;
                		if((hitung_koma == 3) && (isdigit(gpsString[k+1]))) {
                			for(j=0; j<7; j++) latitude[j] = gpsString[k+j+1];
                		}   
                		if((hitung_koma == 4) && (isdigit(gpsString[k+1]))) latitude[7]=gpsString[k+1];
                		if((hitung_koma == 5) && (isdigit(gpsString[k+1]))) {
                			for(j=0; j<8; j++) longitude[j] = gpsString[k+j+1]; 	
                		}    
               			if((hitung_koma == 6) && (isdigit(gpsString[k+1]))) {
                                 	longitude[8]=gpsString[k+1];    
                                        goto lompat;
                                }
                        }
                }
        	
                lompat:
        } 
}

void USART_init(unsigned int baud_rate) {
	if(baud_rate == 4800) {
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
        }
        if(baud_rate == 38400) {
        	// USART initialization
		// Communication Parameters: 8 Data, 1 Stop, No Parity
		// USART Receiver: On
		// USART Transmitter: On
		// USART Mode: Asynchronous
		// USART Baud Rate: 38400
		UCSRA=0x00;
		UCSRB=0xD8;
		UCSRC=0x86;
		UBRRH=0x00;
		UBRRL=0x11;
        }  
}

void main(void) {        
	//Port_init();
        VERSI_2_INIT_PORT;
        USART_init(4800);
        
	ACSR=0x80;
	SFIOR=0x00;                 
        
        #asm("sei")
        
        SMART_BEACON_MODE(SMART_BEACON_DISABLED);
        LED_BLINKING_MODE(LED_BLINKING_DISABLED);
        
        while(1) {
         	STBY_LED_ON;
                
                if(MODE) 	GPS_ENABLED;
        	if(!MODE) 	GPS_DISABLED;
                
                if(gps_status) 	goto pakai_gps;
        	if(!gps_status) goto gak_pakai_gps; 
                
                gak_pakai_gps:
                	if(!TX_NOW) {
                		delay_ms(125);
                       	 	STBY_LED_OFF;
                		protocol();
                	}   	
                        goto jump;
                pakai_gps:  
                	USART_ENABLED;
                	TerimaMentahGPS();
                	USART_DISABLED;
                	ParsingStringGPS();  
                        STBY_LED_OFF;
                	protocol(); 
                jump:
        }
}