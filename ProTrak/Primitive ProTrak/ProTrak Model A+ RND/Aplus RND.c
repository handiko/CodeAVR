/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 5/24/2014
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
#include <delay.h>
#include <stdio.h>
#include <stdint.h>
#include <delay.h>
#include <math.h>

// Enabling this area : RX on Int TX on noInt
/*
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

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
	char status,data;
	status=UCSRA;
	data=UDR;
	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   	{
   		rx_buffer[rx_wr_index++]=data;
		#if RX_BUFFER_SIZE == 256
   			// special case for receiver buffer size=256
   			if (++rx_counter == 0)
      			{
		#else
   			if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   			if (++rx_counter == RX_BUFFER_SIZE)
      			{
      				rx_counter=0;
		#endif
      				rx_buffer_overflow=1;
      			}
   	}
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
	char data;
	while (rx_counter==0);
	data=rx_buffer[rx_rd_index++];
	#if RX_BUFFER_SIZE != 256
		if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	#endif
	#asm("cli")
		--rx_counter;
	#asm("sei")
	return data;
}
#pragma used-
#endif
*/

// Enabling this area : RX on Int TX on Int
/*
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

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE <= 256
unsigned char rx_wr_index,rx_rd_index,rx_counter;
#else
unsigned int rx_wr_index,rx_rd_index,rx_counter;
#endif

// This flag is set on USART Receiver buffer overflow
bit rx_buffer_overflow;

// USART Receiver interrupt service routine
interrupt [USART_RXC] void usart_rx_isr(void)
{
char status,data;
status=UCSRA;
data=UDR;
if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
   {
   rx_buffer[rx_wr_index++]=data;
#if RX_BUFFER_SIZE == 256
   // special case for receiver buffer size=256
   if (++rx_counter == 0)
      {
#else
   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
#endif
      rx_buffer_overflow=1;
      }
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
char data;
while (rx_counter==0);
data=rx_buffer[rx_rd_index++];
#if RX_BUFFER_SIZE != 256
if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
#endif
#asm("cli")
--rx_counter;
#asm("sei")
return data;
}
#pragma used-
#endif

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE <= 256
unsigned char tx_wr_index,tx_rd_index,tx_counter;
#else
unsigned int tx_wr_index,tx_rd_index,tx_counter;
#endif

// USART Transmitter interrupt service routine
interrupt [USART_TXC] void usart_tx_isr(void)
{
if (tx_counter)
   {
   --tx_counter;
   UDR=tx_buffer[tx_rd_index++];
#if TX_BUFFER_SIZE != 256
   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
#endif
   }
}

#ifndef _DEBUG_TERMINAL_IO_
// Write a character to the USART Transmitter buffer
#define _ALTERNATE_PUTCHAR_
#pragma used+
void putchar(char c)
{
while (tx_counter == TX_BUFFER_SIZE);
#asm("cli")
if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
   {
   tx_buffer[tx_wr_index++]=c;
#if TX_BUFFER_SIZE != 256
   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
#endif
   ++tx_counter;
   }
else
   UDR=c;
#asm("sei")
}
#pragma used-
#endif
*/

#define ADC_VREF_TYPE 0x00
#define AFOUT	PORTB.4
#define PTT	PORTB.5
#define MERAH	PORTD.6
#define HIJAU	PORTD.7
#define VSENSE_ADC_	0
#define TEMP_ADC_	1

#define _1200		0
#define _2200		1
#define TX_DELAY_ 	45
#define FLAG_		0x7E
#define	CONTROL_FIELD_	0x03
#define PROTOCOL_ID_	0xF0
#define TD_POSISI_ 	'='
#define TD_STATUS_	'>'
#define TX_TAIL_	5

void read_temp(void);
void read_volt(void);
void base91_lat(void);
void base91_long(void);
void base91_alt(void);
void calc_tel_data(void);
void kirim_add_aprs(void);
void kirim_add_tel(void);
void kirim_ax25_head(void);
void kirim_tele_data(void);
void kirim_tele_param(void);
void kirim_tele_unit(void);
void kirim_tele_eqns(void);
void kirim_status(void);
void kirim_paket(void);
void kirim_crc(void);
void kirim_karakter(unsigned char input);
void hitung_crc(char in_crc);
void ubah_nada(void);
void set_nada(char i_nada);
unsigned int read_adc(unsigned char adc_input);
void waitComma(void);
void waitDollar(void);
void waitInvCo(void);
//void resetData(void);
void config(void);
void extractGPS(void);

eeprom char SYM_TAB_OVL_='/';
eeprom char SYM_CODE_='O';
eeprom unsigned char add_aprs[]={('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),('0'<<1)};
eeprom unsigned char add_tel[]={('T'<<1),('E'<<1),('L'<<1),(' '<<1),(' '<<1),(' '<<1),('0'<<1)};
eeprom unsigned char data_1[] =
{
	('Y'<<1),('B'<<1),('2'<<1),('Y'<<1),('O'<<1),('U'<<1),((11+'0')<<1),
	('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1
};
eeprom char status[] ={"ProTrak! APRS Tracker"};
eeprom char comment[]={" "};
eeprom char message_head[12]={":YB2YOU-11:"};
eeprom char param[] ={"PARM.Temp,B.Volt,Alti"};
eeprom char unit[]  ={"UNIT.Deg.C,Volt,Feet"};
eeprom char eqns[]  ={"EQNS.0,0.1,0,0,0.1,0,0,66,0"};
eeprom char posisi_lat[]={"0745.98S"};
eeprom char posisi_long[]={"11022.36E"};
eeprom unsigned int altitude = 0;
eeprom char m_int=21;
eeprom char tel_int=5;
eeprom char comp_lat[4];
eeprom char comp_long[4];
eeprom int seq=0;
eeprom int timeIntv=4;
eeprom char compstat='Y';
eeprom char battvoltincomm='Y';
eeprom char tempincomm='Y';
eeprom char sendalt='Y';
eeprom char sendtel='Y';
eeprom char gps='Y';
eeprom char pri1='T';
eeprom char pri2='B';
eeprom char pri3='A';
eeprom char pri4='2';
eeprom char pri5='3';

char temp[]={"020.0C"};
char volt[]={"012.0V"};
char comp_cst[3]={33,33,(0b00110110+33)};
char norm_alt[]={"/A=000000"};
char beacon_stat = 0;
bit nada = _1200;
static char bit_stuff = 0;
unsigned short crc;
char seq_num[3];
char ch1[3];
char ch2[3];
char ch3[3];
//char m_count;
char alti[3];
char tcnt1c=0;

void read_temp(void)
{

        unsigned int adc;
        char adc_r,adc_p,adc_s,adc_d;

        adc = (5*read_adc(TEMP_ADC_)/1.024);

        adc_r = (adc/1000);
        adc_p = ((adc%1000)/100);
        adc_s = ((adc%100)/10);
        adc_d = (adc%10);

        if(adc_r==0)temp[0]='!';
        else temp[0] = adc_r + '0';
        if((adc_p==0)&&(adc_r==0)) temp[1]='!';
        else temp[1] = adc_p + '0';
        temp[2] = adc_s + '0';
        temp[4] = adc_d + '0';
}

void read_volt(void)
{
	unsigned int adc;
        char adc_r,adc_p,adc_s,adc_d;

        adc = (5*22*read_adc(VSENSE_ADC_))/102.4;

        adc_r = (adc/1000);
        adc_p = ((adc%1000)/100);
        adc_s = ((adc%100)/10);
        adc_d = (adc%10);

        if(adc_r==0)	volt[0]='!';
        else volt[0] = adc_r + '0';
        if((adc_p==0)&&(adc_r==0)) volt[1]='!';
        else volt[1] = adc_p + '0';
        volt[2] = adc_s + '0';
        volt[4] = adc_d + '0';
}

void base91_lat(void)
{
  	char deg;
        char min;
        float sec;
        char sign;
        float lat;
        float f_lat;

        deg = ((posisi_lat[0]-48)*10) + (posisi_lat[1]-48);
        min = ((posisi_lat[2]-48)*10) + (posisi_lat[3]-48);
        //sec = ((posisi_lat[5]-48)*1000.0) + ((posisi_lat[6]-48)*100.0)+((posisi_lat[7]-48)*10.0) + (posisi_lat[8]-48);
        sec = ((posisi_lat[5]-48)*10.0) + (posisi_lat[6]-48);

        if(posisi_lat[7]=='N') sign = 1.0;
        else sign = -1.0;

        //f_lat = (deg + (min/60.0) + (0.6*sec/360000.0));
        f_lat = (deg + (min/60.0) + (0.6*sec/3600.0));
        lat = 380926 * (90 - (f_lat * sign));

        comp_lat[0] = (lat/753571)+33;
        comp_lat[1] = ((fmod(lat,753571))/8281)+33;
        comp_lat[2] = ((fmod(lat,8281))/91)+33;
        comp_lat[3] = (fmod(lat,91))+33;
}

void base91_long(void)
{
  	char deg;
        char min;
        float sec;
        char sign;
        float lon;
        float f_lon;

        deg = ((posisi_long[0]-48)*100) + ((posisi_long[1]-48)*10) + (posisi_long[2]-48);
        min = ((posisi_long[3]-48)*10) + (posisi_long[4]-48);
        //sec = ((posisi_long[6]-48)*1000.0) + ((posisi_long[7]-48)*100.0) + ((posisi_long[8]-48)*10.0) + (posisi_long[9]-48);
        sec = ((posisi_long[6]-48)*10.0) + (posisi_long[7]-48);

        if(posisi_long[8]=='E') sign = -1.0;
        else			sign = 1.0;

        //f_lon = (deg + (min/60.0) + (0.6*sec/360000.0));
        f_lon = (deg + (min/60.0) + (0.6*sec/3600.0));
        lon = 190463 * (180 - (f_lon * sign));

        comp_long[0] = (lon/753571)+33;
        comp_long[1] = ((fmod(lon,753571))/8281)+33;
        comp_long[2] = ((fmod(lon,8281))/91)+33;
        comp_long[3] = (fmod(lon,91))+33;
}

void base91_alt(void)
{
	int alt;

        alt = (500.5*log(altitude*1.0));
        comp_cst[0] = (alt/91)+33;
        comp_cst[1] = (alt%91)+33;
}

void normal_alt(void)
{
	norm_alt[3]=(altitude/100000)+'0';
        norm_alt[4]=((altitude%100000)/10000)+'0';
        norm_alt[5]=((altitude%10000)/1000)+'0';
        norm_alt[6]=((altitude%1000)/100)+'0';
        norm_alt[7]=((altitude%100)/10)+'0';
        norm_alt[8]=(altitude%10)+'0';
}

void calc_tel_data(void)
{
	int adc;

        seq_num[0]=(seq/100)+'0';
        seq_num[1]=((seq%100)/10)+'0';
        seq_num[2]=(seq%10)+'0';

        adc=0.25*read_adc(2);
        ch1[0]=(adc/100)+'0';
        ch1[1]=((adc%100)/10)+'0';
        ch1[2]=(adc%10)+'0';

        adc=0.25*read_adc(3);
        ch2[0]=(adc/100)+'0';
        ch2[1]=((adc%100)/10)+'0';
        ch2[2]=(adc%10)+'0';

        adc=0.25*read_adc(4);
        ch3[0]=(adc/100)+'0';
        ch3[1]=((adc%100)/10)+'0';
        ch3[2]=(adc%10)+'0';

        adc=altitude/66;
        alti[0]=(adc/100)+'0';
        alti[1]=((adc%100)/10)+'0';
        alti[2]=(adc%10)+'0';

        seq++;
	if(seq==999)seq=0;

        altitude+=3;
        if(altitude==65535)altitude=0;
}

void kirim_add_aprs(void)
{
	char i;

        for(i=0;i<7;i++)kirim_karakter(add_aprs[i]);
}

void kirim_add_tel(void)
{
	char i;

        for(i=0;i<7;i++)kirim_karakter(add_tel[i]);
}

void kirim_ax25_head(void)
{
	char i;

        for(i=0;i<14;i++)kirim_karakter(data_1[i]);
	kirim_karakter(CONTROL_FIELD_);
	kirim_karakter(PROTOCOL_ID_);
}

void send_batt(void)
{
	if(volt[1]!='!')kirim_karakter(volt[1]);
        else		kirim_karakter('0');
        kirim_karakter(volt[2]);
        kirim_karakter(volt[4]);
}

void send_temp(void)
{
	if(temp[1]!='!')kirim_karakter(temp[1]);
        else		kirim_karakter('0');
        kirim_karakter(temp[2]);
        kirim_karakter(temp[4]);
}
void send_alti(void)
{
	char i;
        for(i=0;i<3;i++)kirim_karakter(alti[i]);
}

void send_ch1(void)
{
	char i;
        for(i=0;i<3;i++)kirim_karakter(ch1[i]);
}

void send_ch2(void)
{
	char i;
        for(i=0;i<3;i++)kirim_karakter(ch2[i]);
}

void send_ch3(void)
{
	char i;
        for(i=0;i<3;i++)kirim_karakter(ch3[i]);
}

void kirim_tele_data(void)
{
	char i;

        kirim_add_tel();
        kirim_ax25_head();
        kirim_karakter('T');
        kirim_karakter('#');
        for(i=0;i<3;i++)kirim_karakter(seq_num[i]);

        kirim_karakter(',');
        if     (pri1=='B')send_batt();
        else if(pri1=='T')send_temp();
        else if(pri1=='A')send_alti();
        else if(pri1=='1')send_ch1();
        else if(pri1=='2')send_ch2();
        else if(pri1=='3')send_ch3();

        kirim_karakter(',');
        if     (pri2=='B')send_batt();
        else if(pri2=='T')send_temp();
        else if(pri2=='A')send_alti();
        else if(pri2=='1')send_ch1();
        else if(pri2=='2')send_ch2();
        else if(pri2=='3')send_ch3();

        kirim_karakter(',');
        if     (pri3=='B')send_batt();
        else if(pri3=='T')send_temp();
        else if(pri3=='A')send_alti();
        else if(pri3=='1')send_ch1();
        else if(pri3=='2')send_ch2();
        else if(pri3=='3')send_ch3();

        kirim_karakter(',');
        if     (pri4=='B')send_batt();
        else if(pri4=='T')send_temp();
        else if(pri4=='A')send_alti();
        else if(pri4=='1')send_ch1();
        else if(pri4=='2')send_ch2();
        else if(pri4=='3')send_ch3();

        kirim_karakter(',');
        if     (pri5=='B')send_batt();
        else if(pri5=='T')send_temp();
        else if(pri5=='A')send_alti();
        else if(pri5=='1')send_ch1();
        else if(pri5=='2')send_ch2();
        else if(pri5=='3')send_ch3();

        kirim_karakter(',');
        for(i=0;i<8;i++)kirim_karakter('0');
}

void kirim_tele_param(void)
{
	char i;

        kirim_add_tel();
        kirim_ax25_head();
        for(i=0;i<11;i++)	{kirim_karakter(message_head[i]);}
        for(i=0;i<sizeof(param);i++)	{kirim_karakter(param[i]);}
}

void kirim_tele_unit(void)
{
	char i;

        kirim_add_tel();
        kirim_ax25_head();
        for(i=0;i<11;i++)	{kirim_karakter(message_head[i]);}
        for(i=0;i<sizeof(unit);i++)	{kirim_karakter(unit[i]);}
}

void kirim_tele_eqns(void)
{
	char i;

        kirim_add_tel();
        kirim_ax25_head();
        for(i=0;i<11;i++)	{kirim_karakter(message_head[i]);}
        for(i=0;i<sizeof(eqns);i++)	{kirim_karakter(eqns[i]);}
}

void kirim_status(void)
{
	char i;

        kirim_add_aprs();
        kirim_ax25_head();
        kirim_karakter(TD_STATUS_);
	for(i=0;i<sizeof(status);i++)	kirim_karakter(status[i]);
}

//char cns_tx_count;
//char tel_tx_count;
void prepare(void)
{
	char i;

        PTT = 1;
	delay_ms(100);
	for(i=0;i<TX_DELAY_;i++)kirim_karakter(0x00);
	kirim_karakter(FLAG_);
	bit_stuff = 0;
        crc = 0xFFFF;
}

void kirim_paket(void)
{
	char i;

        read_temp();
        read_volt();
        base91_lat();
        base91_long();
        base91_alt();
        calc_tel_data();
        normal_alt();

        /*
        beacon_stat++;
        prepare();
        if(beacon_stat==1)
        {
        	kirim_status();
                goto tutup;
        }
        if((beacon_stat%tel_int)==0)
        {
        	if(sendtel=='Y')
                {
                	kirim_tele_data();
			goto tutup;
                }
                else
                {
                	if((beacon_stat%m_int)==0)
                        {
                        	kirim_status();
                		goto tutup;
                        }
                        else
                        {
                        	kirim_add_aprs();
                		kirim_ax25_head();
                		kirim_karakter(TD_POSISI_);
                		if(compstat=='Y')
                		{
        				kirim_karakter(SYM_TAB_OVL_);
        				for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
        				for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
					kirim_karakter(SYM_CODE_);
        				for(i=0;i<3;i++)kirim_karakter(comp_cst[i]);
                		}
                		else
                		{
                			for(i=0;i<8;i++)kirim_karakter(posisi_lat[i]);
					kirim_karakter(SYM_TAB_OVL_);
					for(i=0;i<9;i++)kirim_karakter(posisi_long[i]);
					kirim_karakter(SYM_CODE_);
                        		if(sendalt=='Y'){for(i=0;i<9;i++)kirim_karakter(norm_alt[i]);}
                		}
                		if(tempincomm=='Y'){for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}}
                		if(battvoltincomm=='Y'){for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}}
                		for(i=0;i<sizeof(comment);i++)kirim_karakter(comment[i]);
                        }
                }

                goto tutup;
        }
        if(((beacon_stat-1)%(10*tel_int))==0)
        {
        	if(sendtel=='Y')
                {
                	kirim_tele_param();
               		goto tutup;
                }
                else
                {
                	if((beacon_stat%m_int)==0)
                        {
                        	kirim_status();
                		goto tutup;
                        }
                        else
                        {
                        	kirim_add_aprs();
                		kirim_ax25_head();
                		kirim_karakter(TD_POSISI_);
                		if(compstat=='Y')
                		{
        				kirim_karakter(SYM_TAB_OVL_);
        				for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
        				for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
					kirim_karakter(SYM_CODE_);
        				for(i=0;i<3;i++)kirim_karakter(comp_cst[i]);
                		}
                		else
                		{
                			for(i=0;i<8;i++)kirim_karakter(posisi_lat[i]);
					kirim_karakter(SYM_TAB_OVL_);
					for(i=0;i<9;i++)kirim_karakter(posisi_long[i]);
					kirim_karakter(SYM_CODE_);
                        		if(sendalt=='Y'){for(i=0;i<9;i++)kirim_karakter(norm_alt[i]);}
                		}
                		if(tempincomm=='Y'){for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}}
                		if(battvoltincomm=='Y'){for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}}
                		for(i=0;i<sizeof(comment);i++)kirim_karakter(comment[i]);
                        }
                }

                goto tutup;
        }
        if(((beacon_stat-2)%(10*tel_int))==0)
        {
        	if(sendtel=='Y')
                {
                	kirim_tele_unit();
                	goto tutup;
                }
                else
                {
                	if((beacon_stat%m_int)==0)
                        {
                        	kirim_status();
                		goto tutup;
                        }
                        else
                        {
                        	kirim_add_aprs();
                		kirim_ax25_head();
                		kirim_karakter(TD_POSISI_);
                		if(compstat=='Y')
                		{
        				kirim_karakter(SYM_TAB_OVL_);
        				for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
        				for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
					kirim_karakter(SYM_CODE_);
        				for(i=0;i<3;i++)kirim_karakter(comp_cst[i]);
                		}
                		else
                		{
                			for(i=0;i<8;i++)kirim_karakter(posisi_lat[i]);
					kirim_karakter(SYM_TAB_OVL_);
					for(i=0;i<9;i++)kirim_karakter(posisi_long[i]);
					kirim_karakter(SYM_CODE_);
                        		if(sendalt=='Y'){for(i=0;i<9;i++)kirim_karakter(norm_alt[i]);}
                		}
                		if(tempincomm=='Y'){for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}}
                		if(battvoltincomm=='Y'){for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}}
                		for(i=0;i<sizeof(comment);i++)kirim_karakter(comment[i]);
                        }
                }

                goto tutup;
        }
        if(((beacon_stat-3)%(10*tel_int))==0)
        {
        	if(sendtel=='Y')
                {
                	kirim_tele_eqns();
			goto tutup;
                }
                else
                {
                	if((beacon_stat%m_int)==0)
                        {
                        	kirim_status();
                		goto tutup;
                        }
                        else
                        {
                        	kirim_add_aprs();
                		kirim_ax25_head();
                		kirim_karakter(TD_POSISI_);
                		if(compstat=='Y')
                		{
        				kirim_karakter(SYM_TAB_OVL_);
        				for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
        				for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
					kirim_karakter(SYM_CODE_);
        				for(i=0;i<3;i++)kirim_karakter(comp_cst[i]);
                		}
                		else
                		{
                			for(i=0;i<8;i++)kirim_karakter(posisi_lat[i]);
					kirim_karakter(SYM_TAB_OVL_);
					for(i=0;i<9;i++)kirim_karakter(posisi_long[i]);
					kirim_karakter(SYM_CODE_);
                        		if(sendalt=='Y'){for(i=0;i<9;i++)kirim_karakter(norm_alt[i]);}
                		}
                		if(tempincomm=='Y'){for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}}
                		if(battvoltincomm=='Y'){for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}}
                		for(i=0;i<sizeof(comment);i++)kirim_karakter(comment[i]);
                        }
                }

                goto tutup;
        }
        if((beacon_stat%m_int)==0)
        {
        	kirim_status();
                goto tutup;
        }

       	kirim_add_aprs();
        kirim_ax25_head();
        kirim_karakter(TD_POSISI_);
        if(compstat=='Y')
        {
        	kirim_karakter(SYM_TAB_OVL_);
        	for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
        	for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
		kirim_karakter(SYM_CODE_);
        	for(i=0;i<3;i++)kirim_karakter(comp_cst[i]);
        }
        else
        {
        	for(i=0;i<8;i++)kirim_karakter(posisi_lat[i]);
		kirim_karakter(SYM_TAB_OVL_);
		for(i=0;i<9;i++)kirim_karakter(posisi_long[i]);
		kirim_karakter(SYM_CODE_);
        	if(sendalt=='Y'){for(i=0;i<9;i++)kirim_karakter(norm_alt[i]);}
        }
        if(tempincomm=='Y'){for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}}
        if(battvoltincomm=='Y'){for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}}
        for(i=0;i<sizeof(comment);i++)kirim_karakter(comment[i]);

        goto tutup;

	*///*
        MERAH = 1;
        HIJAU = 0;
        if(compstat=='Y')
        {
        	beacon_stat++;
                if(beacon_stat==1)
                {
                	prepare();
                        kirim_status();

                        goto tutup;
                }
                if(beacon_stat==2)
                {
                	prepare();
                        kirim_add_aprs();
                	kirim_ax25_head();
                	kirim_karakter(TD_POSISI_);
        		kirim_karakter(SYM_TAB_OVL_);
        		for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
        		for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
			kirim_karakter(SYM_CODE_);
        		for(i=0;i<3;i++)kirim_karakter(comp_cst[i]);
                        if(tempincomm=='Y')
                        {for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}kirim_karakter(' ');}
                        if(battvoltincomm=='Y')
                        {for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}kirim_karakter(' ');}
                        for(i=0;i<sizeof(comment);i++)
                        	kirim_karakter(comment[i]);

                        goto tutup;
                }
                if(sendtel=='Y')
                {
                	if((beacon_stat%tel_int)==0)
                        {
                        	prepare();
                                kirim_tele_data();

                                goto tutup;
                        }
                        if(((beacon_stat-1)%(10*tel_int))==0)
                        {
                        	prepare();
                                kirim_tele_param();

                                goto tutup;
                        }
                	if(((beacon_stat-2)%(10*tel_int))==0)
                        {
                        	prepare();
                                kirim_tele_unit();

                                goto tutup;
                        }
                	if(((beacon_stat-3)%(10*tel_int))==0)
                        {
                        	prepare();
                                kirim_tele_eqns();

                                goto tutup;
                        }
                        if((beacon_stat%m_int)==0)
                        {
                        	prepare();
                                kirim_status();

                        	goto tutup;
                        }

                        prepare();
                        kirim_add_aprs();
                	kirim_ax25_head();
                	kirim_karakter(TD_POSISI_);
        		kirim_karakter(SYM_TAB_OVL_);
        		for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
        		for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
			kirim_karakter(SYM_CODE_);
        		for(i=0;i<3;i++)kirim_karakter(comp_cst[i]);
                        if(tempincomm=='Y')
                        {for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}kirim_karakter(' ');}
                        if(battvoltincomm=='Y')
                        {for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}kirim_karakter(' ');}
                        for(i=0;i<sizeof(comment);i++)
                        	kirim_karakter(comment[i]);

                        goto tutup;
                }
                if(sendtel=='N')
                {
                	if((beacon_stat%m_int)==0)
                        {
                        	prepare();
                                kirim_status();

                        	goto tutup;
                        }

                        prepare();
                        kirim_add_aprs();
                	kirim_ax25_head();
                	kirim_karakter(TD_POSISI_);
        		kirim_karakter(SYM_TAB_OVL_);
        		for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
        		for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
			kirim_karakter(SYM_CODE_);
        		for(i=0;i<3;i++)kirim_karakter(comp_cst[i]);
                        if(tempincomm=='Y')
                        {for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}kirim_karakter(' ');}
                        if(battvoltincomm=='Y')
                        {for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}kirim_karakter(' ');}
                        for(i=0;i<sizeof(comment);i++)
                        	kirim_karakter(comment[i]);

                        goto tutup;
                }
        }
        else
        {
        	beacon_stat++;
                if(beacon_stat==1)
                {
                	prepare();
                        kirim_status();

                        goto tutup;
                }
                if(beacon_stat==2)
                {
                	prepare();
                        kirim_add_aprs();
                	kirim_ax25_head();
                	kirim_karakter(TD_POSISI_);
			for(i=0;i<8;i++)kirim_karakter(posisi_lat[i]);
			kirim_karakter(SYM_TAB_OVL_);
			for(i=0;i<9;i++)kirim_karakter(posisi_long[i]);
			kirim_karakter(SYM_CODE_);
                        if(tempincomm=='Y')
                        {for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}kirim_karakter(' ');}
                        if(battvoltincomm=='Y')
                        {for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}kirim_karakter(' ');}
                        if(sendalt=='Y')
                        {for(i=0;i<9;i++)kirim_karakter(norm_alt[i]);}
                        for(i=0;i<sizeof(comment);i++)
                        	kirim_karakter(comment[i]);

                        goto tutup;
                }
                if(sendtel=='Y')
                {
                	if((beacon_stat%tel_int)==0)
                        {
                        	prepare();
                                kirim_tele_data();

                                goto tutup;
                        }
                        if(((beacon_stat-1)%(10*tel_int))==0)
                        {
                        	prepare();
                                kirim_tele_param();

                                goto tutup;
                        }
                	if(((beacon_stat-2)%(10*tel_int))==0)
                        {
                        	prepare();
                                kirim_tele_unit();

                                goto tutup;
                        }
                	if(((beacon_stat-3)%(10*tel_int))==0)
                        {
                        	prepare();
                                kirim_tele_eqns();

                                goto tutup;
                        }
                        if((beacon_stat%m_int)==0)
                        {
                        	prepare();
                                kirim_status();

                        	goto tutup;
                        }

                        prepare();
                        kirim_add_aprs();
                	kirim_ax25_head();
                	kirim_karakter(TD_POSISI_);
			for(i=0;i<8;i++)kirim_karakter(posisi_lat[i]);
			kirim_karakter(SYM_TAB_OVL_);
			for(i=0;i<9;i++)kirim_karakter(posisi_long[i]);
			kirim_karakter(SYM_CODE_);
                        if(tempincomm=='Y')
                        {for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}kirim_karakter(' ');}
                        if(battvoltincomm=='Y')
                        {for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}kirim_karakter(' ');}
                        if(sendalt=='Y')
                        {for(i=0;i<9;i++)kirim_karakter(norm_alt[i]);}
                        for(i=0;i<sizeof(comment);i++)
                        	kirim_karakter(comment[i]);

                        goto tutup;
                }
                if(sendtel=='N')
                {
                	if((beacon_stat%m_int)==0)
                        {
                        	prepare();
                                kirim_status();

                        	goto tutup;
                        }

                        prepare();
                        kirim_add_aprs();
                	kirim_ax25_head();
                	kirim_karakter(TD_POSISI_);
			for(i=0;i<8;i++)kirim_karakter(posisi_lat[i]);
			kirim_karakter(SYM_TAB_OVL_);
			for(i=0;i<9;i++)kirim_karakter(posisi_long[i]);
			kirim_karakter(SYM_CODE_);
                        if(tempincomm=='Y')
                        {for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}kirim_karakter(' ');}
                        if(battvoltincomm=='Y')
                        {for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}kirim_karakter(' ');}
                        if(sendalt=='Y')
                        {for(i=0;i<9;i++)kirim_karakter(norm_alt[i]);}
                        for(i=0;i<sizeof(comment);i++)
                        	kirim_karakter(comment[i]);

                        goto tutup;
                }
        }
        //*/

        tutup:
	kirim_crc();
        kirim_karakter(FLAG_);
        kirim_karakter(FLAG_);
        PTT = 0;
        MERAH = 0;
        HIJAU = 0;
}

void kirim_crc(void)
{
	static unsigned char crc_lo;
	static unsigned char crc_hi;

        crc_lo = crc ^ 0xFF;
	crc_hi = (crc >> 8) ^ 0xFF;
	kirim_karakter(crc_lo);
	kirim_karakter(crc_hi);
}

void kirim_karakter(unsigned char input)
{
	char i;
	bit in_bit;

        for(i=0;i<8;i++)
        {
        	in_bit = (input >> i) & 0x01;
		if(input==0x7E)	{bit_stuff = 0;}
		else		{hitung_crc(in_bit);}

		if(!in_bit)
                {
                	ubah_nada();
			bit_stuff = 0;
                }
                else
                {
                	set_nada(nada);
			bit_stuff++;
			if(bit_stuff==5)
                        {
                        	ubah_nada();
                                bit_stuff = 0;
                        }
                }
        }
}

void hitung_crc(char in_crc)
{
	static unsigned short xor_in;
	xor_in = crc ^ in_crc;
	crc >>= 1;
	if(xor_in & 0x01)	crc ^= 0x8408;
}

void ubah_nada(void)
{
	nada = ~nada;
        set_nada(nada);
}

void set_nada(char i_nada)
{
	if(i_nada == _1200)
    	{
        	delay_us(417);
        	AFOUT = 1;
        	delay_us(417);
        	AFOUT = 0;
    	}
        else
    	{
        	delay_us(208);
        	AFOUT = 1;
        	delay_us(209);
        	AFOUT = 0;
                delay_us(208);
        	AFOUT = 1;
        	delay_us(209);
        	AFOUT = 0;
    	}
}

unsigned int read_adc(unsigned char adc_input)
{
	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	delay_us(10);
	ADCSRA|=0x40;
	while ((ADCSRA & 0x10)==0);
	ADCSRA|=0x10;
	return ADCW;
}

void waitComma(void)
{
	while(getchar()!=',');
}

void waitDollar(void)
{
	while(getchar()!='$');
}

void waitInvCo(void)
{
	while(getchar()!='"');
}

void config(void)
{
	char buffer[200];
        char cbuffer[];
        int b,j,k,l,m,n,o;

        MERAH=1;
        HIJAU=0;

        b=0;

        putchar('.');
        waitDollar();
        waitInvCo();

        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto myssid;
                }
                b++;
        }
        myssid:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto digipath;
                }
                b++;
        }
        digipath:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto timeintv;
                }
                b++;
        }
        timeintv:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto symbcode;
                }
                b++;
        }
        symbcode:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto symbtab;
                }
                b++;
        }
        symbtab:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto comment;
                }
                b++;
        }
        comment:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto status;
                }
                b++;
        }
        status:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto cnsintv;
                }
                b++;
        }
        cnsintv:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto compstat;
                }
                b++;
        }
        compstat:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto coordinate;
                }
                b++;
        }
        coordinate:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto gps;
                }
                b++;
        }
        gps:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto tempincom;
                }
                b++;
        }
        tempincom:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto battincom;
                }
                b++;
        }
        battincom:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto sendalt;
                }
                b++;
        }
        sendalt:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto sendtel;
                }
                b++;
        }
        sendtel:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto telintv;
                }
                b++;
        }
        telintv:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto telprio;
                }
                b++;
        }
        telprio:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto label;
                }
                b++;
        }
        label:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto unit;
                }
                b++;
        }
        unit:

        putchar('.');
        waitInvCo();
        while(1)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='"')
                {
                	b++;
                        goto eqns;
                }
                b++;
        }
        eqns:
        j=b;

        putchar(13);
        for(b=0;b<(j+1);b++)
        {
        	putchar(buffer[b]);
        }

        putchar(13);
        putsf("SAVING CONFIGURATION...");

        // mycall & message call
        //for(k=0;k<6;k++)data_1[k]=(' '<<1);
        for(b=0;b<6;b++)
        {
        	data_1[b]=(buffer[b]<<1);
                message_head[b+1]=buffer[b];
        }

        // myssid
        data_1[6]=(((10*(buffer[7]-48))+(buffer[8]-48))<<1);
        /*
        if(buffer[5]==' ')
        {
         	if(buffer[4]==' ')
                {
                	if(buffer[3]==' ')
                        {
                        	if(buffer[8]=='0')
                                {
                                	if(buffer[7]=='0')
                                        {
                                        	message_head[4]=' ';
                                		message_head[5]=' ';
                                		message_head[6]=' ';
                                        }
                                        else
                                        {
                                        	message_head[4]='-';
                                		message_head[5]=buffer[7];
                                		message_head[6]=buffer[8];
                                        }
                                }
                                else
                                {
                                	message_head[4]='-';
                                        if(buffer[7]=='0')
                                        {
                                        	message_head[5]=buffer[8];
                                		message_head[6]=' ';
                                        }
                                        else
                                        {
                                        	message_head[5]=buffer[7];
                                		message_head[6]=buffer[8];
                                        }
                                }
                                message_head[7]=' ';
                        }
                        else
                        {
                        	message_head[5]='-';
                        	message_head[6]=buffer[7];
                        	message_head[7]=buffer[8];
                        }
                        message_head[8]=' ';
                }
                else
                {
                	message_head[6]='-';
                        message_head[7]=buffer[7];
                        message_head[8]=buffer[8];
                }
                message_head[9]=' ';
        }
        else
        {
        	message_head[7]='-';
                message_head[8]=buffer[7];
                message_head[9]=buffer[8];
        }   */

        // digipath
        data_1[12]=(' '<<1);
        if((buffer[10]=='W')&&(buffer[11]=='I')&&(buffer[12]=='D')&&(buffer[13]=='E'))
        {
        	for(k=7;k<11;k++)data_1[k]=(buffer[k+3]<<1);
                if(buffer[14]==0)
                {
                	data_1[11]=(' '<<1);
                        data_1[13]=(' '<<1)+1;
                }
                else
                {
                	data_1[11]=(buffer[14]<<1);
                        data_1[13]=(buffer[16]<<1)+1;
                }
        }
        else {for(k=7;k<14;k++)data_1[k]=(buffer[k+3]<<1);data_1[13]+=1;}

        //time interval
        timeIntv=(100*(buffer[18]-48))+(10*(buffer[19]-48))+(buffer[20]-48);

        //symbol code
        SYM_CODE_=buffer[22];

        //symbol table
        SYM_TAB_OVL_=buffer[24];

        //comment
        k=26;
        j=0;
        while(buffer[k]!='"')
        {
        	comment[l]=buffer[k];
                j++;
                k++;
        }
        j=k;



        MERAH=0;
        HIJAU=0;
        putchar(13);
        putsf("CONFIG SUCCESS !");
        putchar(13);
}

void extractGPS(void)
{
	int i,j;
        char buff_altitude[9];
        char cb;
        char n_altitude[6];

        #asm("cli")
        lagi:
        while(getchar() != '$');
        cb=getchar();
	if(cb=='G')
        {
        	getchar();
        	if(getchar() == 'G')
        	{
        	if(getchar() == 'G')
        	{
                	if(getchar() == 'A')
                	{
                        	MERAH = 0;
        			HIJAU = 1;

                                waitComma();
                                waitComma();
				for(i=0; i<7; i++)	posisi_lat[i] = getchar();
				waitComma();
				posisi_lat[7] = getchar();
				waitComma();
				for(i=0; i<8; i++)	posisi_long[i] = getchar();
				waitComma();		posisi_long[8] = getchar();
				waitComma();
                                waitComma();
                                waitComma();
                                waitComma();
				for(i=0;i<8;i++)        buff_altitude[i] = getchar();
				for(i=0;i<6;i++)        n_altitude[i] = '0';
				for(i=0;i<8;i++)
                                {
                                        if(buff_altitude[i] == '.')     goto selesai;
                                        if((buff_altitude[i] != '.')&&(buff_altitude[i] != ',')&&(buff_altitude[i] != 'M'))
                                        {
                                        	for(j=0;j<6;j++)        n_altitude[j] = n_altitude[j+1];
						n_altitude[5] = buff_altitude[i];
                                        }
                                }

                                selesai:

                                for(i=0;i<6;i++)n_altitude[i]-='0';
				altitude=    (3*(long)((n_altitude[0]*100000)+(n_altitude[1]*10000)+(n_altitude[2]*1000)
                                		+(n_altitude[3]*100)+(n_altitude[4]*10)+(n_altitude[5])));

                                MERAH = 0;
        			HIJAU = 0;
                                delay_ms(150);
                                goto keluar;
                        }
                }
        	}
        }

        else if(cb=='C')
        {
        	if(getchar()=='O')
                {
                	if(getchar()=='N')
                        {
                        	if(getchar()=='F')
                                {
                                	putsf("CONFIGURE...");
                                        config();
                                        goto keluar;
        			}
                        }
                }
        }
        goto lagi;

        keluar:
        #asm("sei")
}

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
	char z;
        if(gps=='Y')
        {
        	HIJAU=0;
                MERAH=0;
        }
        else
        {
        	HIJAU=1;
                MERAH=0;
        }
        for(z=0;z<100;z++)
        {
       		if(PIND.0==0)
                {
                	extractGPS();
                }
        }
        if((tcnt1c/2)==timeIntv)
        {
        	kirim_paket();
                tcnt1c=0;
        }
        TCNT1H = (60135 >> 8);
        TCNT1L = (60135 & 0xFF);

        tcnt1c++;
}

void main(void)
{
        PORTB=0x00;
	DDRB=0xFF;
	PORTD=0x03;
	DDRD=0xFE;

        TCCR1A=0x00;
	TCCR1B=0x05;
	TCNT1H = (60135 >> 8);
        TCNT1L = (60135 & 0xFF);
        TIMSK=0x04;

	// USART initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART Receiver: On
	// USART Transmitter: Off
	// USART Mode: Asynchronous
	// USART Baud Rate: 4800

	// Rx ON-noInt Tx ON-noInt
	//*
	UCSRA=0x00;
	UCSRB=0x18;
	UCSRC=0x86;
	UBRRH=0x00;
	UBRRL=0x8F;
	//*/

	// Rx ON-Int Tx ON-noInt
	/*
	UCSRA=0x00;
	UCSRB=0x98;
	UCSRC=0x86;
	UBRRH=0x00;
	UBRRL=0x8F;
	*/

	// Rx ON-Int Tx ON-Int
	/*
	UCSRA=0x00;
	UCSRB=0xD8;
	UCSRC=0x86;
	UBRRH=0x00;
	UBRRL=0x8F;
	*/

	ACSR=0x80;

	ADMUX=ADC_VREF_TYPE & 0xff;
	ADCSRA=0x84;

        MERAH = 1;
        HIJAU = 0;
        delay_ms(200);
        MERAH = 0;
        HIJAU = 1;
        delay_ms(200);

        #asm("sei")

	while (1)
      	{
        	//putchar(p=getchar());
      	}
}
