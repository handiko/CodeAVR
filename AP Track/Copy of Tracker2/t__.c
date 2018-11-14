/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Professional
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 12/23/2011
Author  : F4CG
Company : F4CG
Comments:


Chip type           : ATmega8
Program type        : Application
Clock frequency     : 11.059200 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/

#include <mega8.h>
#include <stdio.h>
#include <delay.h>

#define on 1
#define ON 1
#define off 0
#define OFF 0

#define PTT PIND.1
#define dac0    PORTB.0
#define dac1    PORTB.1
#define dac2    PORTB.2
#define dac3    PORTB.3

void protocol();
void send_data(char input);
void fliptone();
void send_tone(int nada);
void calc_fcs(char in);
void send_fcs(char infcs);

/**********************************************************************************************/
// AX.25
/**********************************************************************************************/

eeprom char flag[12] = {
        0x7E,0x7E,0x7E,0x7E,
        0x7E,0x7E,0x7E,0x7E,
        0x7E,0x7E,0x7E,0x7E
        // FLAG 12 KALI
};
eeprom char destination[7] = {
        0x41,0x50,0x55,0x32,0x35,0x4D,
        0b01100101
        // APU25N-2     //0b011SSSSx format, SSSS = 2 = 0b0010, x = 1 (callsign terakhir)
};
eeprom char source[7] = {
        0x59,0x44,0x32,0x58,0x42,0x43,
        0b01110010      //0b011SSSSx format, SSSS = 9 = 0b1001, x = 0 (bukan callsign terakhir)
        // YD2XBC-9
};
eeprom char digi[7] = {
        0x57,0x49,0x44,0x45,0x32,0x33,0x20
        // WIDE2-3
};
eeprom char control_field = 0x03;
eeprom char protocol_id = 0xF0;
eeprom char data_type = 0x21;
char latitude[8];// = {

//};
eeprom char symbol_table = 0x2F;
char longitude[9];// = {

//};
eeprom char symbol_code = 0x3E;
eeprom char comment[43];// = {

        // testing for emergency beacon
//};
char fcshi;
char fcslo;

/**********************************************************************************************/
// USART
/**********************************************************************************************/

#define RXB8 1
#define TXB8 0
#define UPE 2
#define OVR 3
#define FE 4
#define UDRE 5
#define RXC 7

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

#define RX_BUFFER_SIZE 8
#define TX_BUFFER_SIZE 8

bit rx_buffer_overflow;
char rx_buffer[RX_BUFFER_SIZE];
char tx_buffer[TX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
        unsigned char rx_wr_index,rx_rd_index,rx_counter;
        #else
        unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

interrupt [USART_RXC] void usart_rx_isr(void) {
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
#endif

#if TX_BUFFER_SIZE<256
        unsigned char tx_wr_index,tx_rd_index,tx_counter;
        #else
        unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

interrupt [USART_TXC] void usart_tx_isr(void) {
        if (tx_counter) {
                --tx_counter;
                UDR=tx_buffer[tx_rd_index];
                if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
        };
}

#ifndef _DEBUG_TERMINAL_IO_
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


/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////  AX.25 ////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

#define cons1200 52
#define cons2200 26

char count_1 = 0;
int tone = 1200;

void protocol() {
        int i;
        PTT = on;
        delay_ms(500);
        for(i=0;i<12;i++)       send_data(flag[i]);             // kirim flag 12 kali
        for(i=0;i<7;i++)        send_data(destination[i]);      // kirim callsign tujuan
        for(i=0;i<7;i++)        send_data(source[i]);           // kirim callsign asal
        for(i=0;i<7;i++)        send_data(digi[i]);             // kirim path digi
        send_data(control_field);                               // kirim data control field
        send_data(protocol_id);                                 // kirim data PID
        send_data(data_type);                                   // kirim data type info
        for(i=0;i<8;i++)        send_data(latitude[i]);         // kirim data lintang posisi
        send_data(symbol_table);                                // kirim simbol tabel
        for(i=0;i<9;i++)        send_data(longitude[i]);        // kirim data bujur posisi
        send_data(symbol_code);                                 // kirim simbol kode
        send_fcs(fcshi);
        send_fcs(fcslo);
        for(i=0;i<12;i++)       send_data(flag[i]);             // kirim flag 12 kali
        PTT = off;
}

void send_data(char input) {
        int i;
        bit x;
        for(i=0;i<8;i++) {
                x = input & 0x01;
                calc_fcs(x);

                if(x) {
                        count_1++;
                        if(count_1==5)    fliptone();
                        send_tone(tone);
                }
                if(!x)  fliptone();
                input = input >> 1;
        }
}

void fliptone() {
        count_1 = 0;
        switch(tone) {
                case 1200:      tone=2200;      send_tone(tone);        break;
                case 2200:      tone=1200;      send_tone(tone);        break;
        }
}

void set_dac(char value) {
        dac0 = value & 0x01;
        dac1 =( value >> 1) & 0x01;
        dac2 =( value >> 2) & 0x01;
        dac3 =( value >> 3) & 0x01;
}

void send_tone(int nada) {
        if(nada==1200) {
                set_dac(7);     delay_us(cons1200);

                set_dac(10);    delay_us(cons1200);
                set_dac(13);    delay_us(cons1200);
                set_dac(14);    delay_us(cons1200);

                set_dac(15);    delay_us(cons1200);

                set_dac(14);    delay_us(cons1200);
                set_dac(13);    delay_us(cons1200);
                set_dac(10);    delay_us(cons1200);

                set_dac(7);     delay_us(cons1200);

                set_dac(5);     delay_us(cons1200);
                set_dac(2);     delay_us(cons1200);
                set_dac(1);     delay_us(cons1200);

                set_dac(0);     delay_us(cons1200);

                set_dac(1);     delay_us(cons1200);
                set_dac(2);     delay_us(cons1200);
                set_dac(5);     delay_us(cons1200);
        }
        else {
                set_dac(7);     delay_us(cons2200);

                set_dac(10);    delay_us(cons2200);
                set_dac(13);    delay_us(cons2200);
                set_dac(14);    delay_us(cons2200);

                set_dac(15);    delay_us(cons2200);

                set_dac(14);    delay_us(cons2200);
                set_dac(13);    delay_us(cons2200);
                set_dac(10);    delay_us(cons2200);

                set_dac(7);     delay_us(cons2200);

                set_dac(5);     delay_us(cons2200);
                set_dac(2);     delay_us(cons2200);
                set_dac(1);     delay_us(cons2200);

                set_dac(0);     delay_us(cons2200);

                set_dac(1);     delay_us(cons2200);
                set_dac(2);     delay_us(cons2200);
                set_dac(5);     delay_us(cons2200);

                set_dac(7);     delay_us(cons2200);

                set_dac(10);    delay_us(cons2200);
                set_dac(13);    delay_us(cons2200);
                set_dac(14);    delay_us(cons2200);

                set_dac(15);    delay_us(cons2200);

                set_dac(14);    delay_us(cons2200);
                set_dac(13);    delay_us(cons2200);
                set_dac(10);    delay_us(cons2200);

                set_dac(7);     delay_us(cons2200);

                set_dac(5);     delay_us(cons2200);
                set_dac(2);     delay_us(cons2200);
                set_dac(1);     delay_us(cons2200);

                set_dac(0);     delay_us(cons2200);

                set_dac(1);     delay_us(cons2200);
                set_dac(2);     delay_us(cons2200);
                set_dac(5);     delay_us(cons2200);
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

}

/////////////////////////////////////////////////////////////////////////////////////////////
/////////////////// main & utility function /////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////

void main(void) {
        PORTB=0x00;
        DDRB=0x00;
        PORTC=0x00;
        DDRC=0x00;
        PORTD=0x00;
        DDRD=0x00;

        // USART initialization
        // Communication Parameters: 8 Data, 1 Stop, No Parity
        // USART Receiver: On
        // USART Transmitter: On
        // USART Mode: Asynchronous
        // USART Baud rate: 4800
        UCSRA=0x00;
        UCSRB=0xD8;
        UCSRC=0x86;
        UBRRH=0x00;
        UBRRL=0x8F;

        ACSR=0x80;
        SFIOR=0x00;

        #asm("sei")

        while (1) {
        };
}
