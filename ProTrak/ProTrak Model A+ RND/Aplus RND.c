/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
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
#include <stdlib.h>

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
void config(void);
void extractGPS(void);

eeprom char SYM_TAB_OVL_='/';
eeprom char SYM_CODE_='O';
eeprom unsigned char add_aprs[7]={('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),('0'<<1)};
eeprom unsigned char add_tel[7]={('T'<<1),('E'<<1),('L'<<1),(' '<<1),(' '<<1),(' '<<1),('0'<<1)};
eeprom unsigned char add_beacon[7]={('B'<<1),('E'<<1),('A'<<1),('C'<<1),('O'<<1),('N'<<1),('0'<<1)};
eeprom unsigned char mycall[8]={"YC2WYA0"};
eeprom unsigned char mydigi1[8]={"WIDE2 1"};
eeprom unsigned char mydigi2[8]={"WIDE2 2"};
eeprom unsigned char mydigi3[8]={"WIDE2 2"};
eeprom char comment[100] ={"New Tracker"};
eeprom char status[100]={"ProTrak! APRS & Telemetry Encoder"};
eeprom char posisi_lat[]={"0745.48S"};
eeprom char posisi_long[]={"11022.56E"};
eeprom char message_head[12]={":YB2YOU-11:"};
eeprom char param[] ={"PARM.Temp,B.Volt,Alti"};
eeprom char unit[]  ={"UNIT.Deg.C,Volt,Feet"};
eeprom char eqns[]  ={"EQNS.0,0.1,0,0,0.1,0,0,66,0"};
eeprom unsigned int altitude = 0;
eeprom char m_int=21;
eeprom int tel_int=5;
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
eeprom char commsize=11;
eeprom char statsize=33;
eeprom char sendtopc='N';

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
char alti[3];
char tcnt1c=0;

void read_temp(void)
{
	int adc;
        char adc_r,adc_p,adc_s,adc_d;

        adc = (5*read_adc(TEMP_ADC_)/1.024);
        //itoa(adc,temp);

        adc_r = (adc/1000);
        adc_p = ((adc%1000)/100);
        adc_s = ((adc%100)/10);
        adc_d = (adc%10);

        if(adc_r==0)temp[0]=' ';
        else temp[0] = adc_r + '0';
        if((adc_p==0)&&(adc_r==0)) temp[1]=' ';
        else temp[1] = adc_p + '0';
        temp[2] = adc_s + '0';
        temp[4] = adc_d + '0';
}

void read_volt(void)
{
	int adc;
        char adc_r,adc_p,adc_s,adc_d;

        adc = (5*22*read_adc(VSENSE_ADC_))/102.4;
        //itoa(adc,volt);

        adc_r = (adc/1000);
        adc_p = ((adc%1000)/100);
        adc_s = ((adc%100)/10);
        adc_d = (adc%10);

        if(adc_r==0)	volt[0]=' ';
        else volt[0] = adc_r + '0';
        if((adc_p==0)&&(adc_r==0)) volt[1]=' ';
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

void kirim_add_beacon(void)
{
	char i;

        for(i=0;i<7;i++)kirim_karakter(add_beacon[i]);
}

void kirim_ax25_head(void)
{
	char i;

        for(i=0;i<6;i++)kirim_karakter(mycall[i]<<1);
        if(((mydigi1[0]>47)&&(mydigi1[0]<58))||((mydigi1[0]>64)&&(mydigi1[0]<91)))
        {
        	kirim_karakter(mycall[6]<<1);
                for(i=0;i<6;i++)kirim_karakter(mydigi1[i]<<1);
        	if(((mydigi2[0]>47)&&(mydigi2[0]<58))||((mydigi2[0]>64)&&(mydigi2[0]<91)))
        	{
        		kirim_karakter(mydigi1[6]<<1);
                	for(i=0;i<6;i++)kirim_karakter(mydigi2[i]<<1);
                	if(((mydigi3[0]>47)&&(mydigi3[0]<58))||((mydigi3[0]>64)&&(mydigi3[0]<91)))
        		{
        			kirim_karakter(mydigi2[6]<<1);
                		for(i=0;i<6;i++)kirim_karakter(mydigi3[i]<<1);
                        	kirim_karakter((mydigi3[6]<<1)+1);
        		}
        		else
        		{
        			kirim_karakter((mydigi2[6]<<1)+1);
        		}
        	}
        	else
        	{
        		kirim_karakter((mydigi1[6]<<1)+1);
        	}
        }
        else
        {
        	kirim_karakter((mycall[6]<<1)+1);
        }
	kirim_karakter(CONTROL_FIELD_);
	kirim_karakter(PROTOCOL_ID_);
}

void send_batt(void)
{
	if(volt[1]!=' ')kirim_karakter(volt[1]);
        else		kirim_karakter('0');
        kirim_karakter(volt[2]);
        kirim_karakter(volt[4]);
}

void send_temp(void)
{
	if(temp[1]!=' ')kirim_karakter(temp[1]);
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
	for(i=0;i<statsize;i++)
        {
        	if(status[i]!=0)kirim_karakter(status[i]);
        }
}

void kirim_beacon(void)
{
	char i;

        kirim_add_beacon();
        kirim_ax25_head();
        for(i=0;i<statsize;i++)kirim_karakter(status[i]);
}

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

	MERAH = 1;
        HIJAU = 0;

        beacon_stat++;
        prepare();
        if((beacon_stat==6)||((beacon_stat>7)&&((beacon_stat%m_int)==0)))
        {
        	kirim_status();
                goto oke;
        }
        if((beacon_stat==2)||((beacon_stat>7)&&((beacon_stat%tel_int)==0)))
        {
        	if(sendtel=='N')
                {
                	if(beacon_stat==2)beacon_stat=6;
                        goto oke;
                }
                kirim_tele_data();
                goto oke;
        }
        if((beacon_stat==1)||((beacon_stat>7)&&((beacon_stat%m_int)!=0)&&((beacon_stat%tel_int)!=0)))
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
                        if(sendalt=='Y')
                        {
                		for(i=0;i<9;i++)kirim_karakter(norm_alt[i]);
                        	kirim_karakter(' ');
                        }
                }
                if(tempincomm=='Y')
                {for(i=0;i<6;i++){if(temp[i]!=' ')kirim_karakter(temp[i]);}kirim_karakter(' ');}
                if(battvoltincomm=='Y')
                {for(i=0;i<6;i++){if(volt[i]!=' ')kirim_karakter(volt[i]);}kirim_karakter(' ');}
                for(i=0;i<sizeof(comment);i++)
                kirim_karakter(comment[i]);
                goto oke;
        }

        if(beacon_stat==3)
        {
        	kirim_tele_param();
                goto oke;
        }
        if(beacon_stat==4)
        {
        	kirim_tele_unit();
                goto oke;
        }
        if(beacon_stat==5)
        {
        	kirim_tele_eqns();
                goto oke;
        }
        if(beacon_stat==7)kirim_beacon();

        oke:
	kirim_crc();
        kirim_karakter(FLAG_);
        kirim_karakter(FLAG_);
        PTT = 0;

        if(beacon_stat==25)beacon_stat=0;
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

/*void mem_display(void)
{
	// configuration ECHO
        // mycall & SSID
        char k;
        char f[];

        #asm("cli")

        MERAH=1;
        HIJAU=0;

        putchar(13);
        putchar(13);putsf("Your ProTrak! model A Configuration is:");
        putchar(13);
        putchar(13);putsf("Callsign");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        for(k=0;k<6;k++)if((mycall[k])!=' ')putchar(mycall[k]);
        if((mycall[6])>'0')
        {
        	putchar('-');
                itoa(mycall[6]-48,f);
                puts(f);
        }

        // digipath
        putchar(13);putsf("Digi Path(s)");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        if(mydigi1[0]!=0)
        {
        	for(k=0;k<6;k++)if((mydigi1[k])!=' ')putchar(mydigi1[k]);
        	if(mydigi1[6]>'0')
        	{
        		putchar('-');
                        itoa(mydigi1[6]-48,f);
                        puts(f);
        	}
        }
        if(mydigi2[0]!=0)
        {
        	putchar(',');
        	for(k=0;k<6;k++)if((mydigi2[k])!=' ')putchar(mydigi2[k]);
        	if(mydigi2[6]>'0')
        	{
        		putchar('-');
                        itoa(mydigi2[6]-48,f);
                        puts(f);
        	}
        }
        if(mydigi3[0]!=0)
        {
        	putchar(',');
        	for(k=0;k<6;k++)if((mydigi3[k])!=' ')putchar(mydigi3[k]);
        	if(mydigi3[6]>'0')
        	{
        		putchar('-');
                        itoa(mydigi3[6]-48,f);
                        puts(f);
        	}
        }

        // beacon interval
        putchar(13);putsf("TX Interval");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        itoa(timeIntv,f);
        puts(f);
        putchar(' ');putsf("second(s)");
        if(timeIntv>9999)putsf(" is too long");

        // symbol code / icon
        putchar(13);putsf("Symbol / Icon");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        putchar(SYM_CODE_);

        // symbol table / overlay
        putchar(13);putsf("Symbol Table / Overlay");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        putchar(SYM_TAB_OVL_);

        // comment
        putchar(13);putsf("Comment");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        for(k=0;k<commsize;k++)
        {
        	if(comment[k]!=0)putchar(comment[k]);
        }

        // status
        putchar(13);putsf("Status");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        for(k=0;k<statsize;k++)
        {
        	if(status[k]!=0)putchar(status[k]);
        }

        // status interval
        putchar(13);putsf("Status Interval");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        itoa(m_int,f);
        puts(f);
        putchar(' ');putsf("transmission(s)");
        if(m_int>99)putsf(" is too long");

        // BASE-91 Comppresion ?
        putchar(13);putsf("BASE-91 ? (Y/N)");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        putchar(compstat);

        // Coordinate
        putchar(13);putsf("NO GPS Coordinate");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        for(k=0;k<8;k++)putchar(posisi_lat[k]);
        putchar(',');
        for(k=0;k<9;k++)putchar(posisi_long[k]);

        //use gps
        putchar(13);putsf("Use GPS ? (Y/N)");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        putchar(gps);

        // battery volt
        putchar(13);putsf("Diplay Battery Voltage in Comment ? (Y/N)");
        putchar(9);putchar(9);putchar(':');
        putchar(battvoltincomm);

        // temperature
        putchar(13);putsf("Diplay Temperature in Comment ? (Y/N)");
        putchar(9);putchar(9);putchar(9);putchar(':');
        putchar(tempincomm);

        // altitude
        putchar(13);putsf("Send Altitude ? (Y/N)");
        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
        putchar(sendalt);

        // send to PC
        putchar(13);putsf("Send Temperature and Battery Voltage to PC ? (Y/N)");
        putchar(9);putchar(':');
        putchar(sendtopc);

        MERAH=0;
        HIJAU=0;

        #asm("sei")
}  */

void config(void)
{
	char buffer[500];
        char dbuff[];
        char cbuff[];
        char ibuff[5];
        char tbuff[3];
        int b,j,k,l;

        #asm("cli")

        MERAH=1;
        HIJAU=0;

        b=0;

        putchar(13);putsf("ENTERING CONFIGURATION MODE...");
        putchar(13);putsf("CONFIGURE...");

        // download configuration file
        waitDollar();
        waitInvCo();
        for(;;)
        {
        	buffer[b]=getchar();
                if(buffer[b]=='$')goto rxd_selesai;
                if(buffer[b]=='"')waitInvCo();
                putchar('.');
                b++;
        }
        rxd_selesai:
        // config file downloaded
        //j=b;

        putchar(13);putsf("SAVING CONFIGURATION...");

        // mycall
        b=0;
        k=0;
        while(buffer[b]!='"') 				//<--- move data from rxbuffer to databuffer
        {
        	cbuff[k]=buffer[b];
                k++;
                b++;
        }
        j=b+1; 						// j = index , atau "   j+b = index next data field

        // pada titik ini, k adalah ukuran array 1st digi string
        l=k;
        for(k=0;k<6;k++)mycall[k]=' '; 			//<--- resetting mycall
        mycall[6]='0';
        for(k=1;k<10;k++)message_head[k]=' ';
        for(k=0;k<sizeof(cbuff);k++)message_head[k+1]=cbuff[k];
        for(k=0;k<l;k++)
        {
        	if(cbuff[k]=='-')
                {
                	if((l-k)==2)
                        {
                        	mycall[6]=cbuff[k+1];
                                goto selesai_mycall;
                        }
                        else if((l-k)==3)
                        {
                        	mycall[6]=((10*(cbuff[k+1]-48)+cbuff[k+2]-48)+48);
                        	goto selesai_mycall;
                        }
                }
                mycall[k]=cbuff[k];
        }
        selesai_mycall:

        //1st digi
        b=j;
        k=0;
        while((buffer[b]!='"')&&(buffer[b]!=',')) 	//<--- move data from rxbuffer to databuffer
        {
        	dbuff[k]=buffer[b];
                k++;
                b++;
        }
        j=b+1; 						// j = index , atau "   j+b = index next data field

        // pada titik ini, k adalah ukuran array 1st digi string
        l=k;
        for(k=0;k<6;k++)mydigi1[k]=' '; 		//<--- resetting digi call
        for(k=0;k<7;k++)mydigi2[k]=' ';
        for(k=0;k<7;k++)mydigi3[k]=' ';
        mydigi1[6]='0';
        mydigi2[6]='0';
        mydigi3[6]='0';
        mydigi1[0]=0;
        mydigi2[0]=0;
        mydigi3[0]=0;
        if(l<2)goto time_interval;			//<--- jika tidak menggunakan digi
        for(k=0;k<l;k++)
        {
        	if(dbuff[k]=='-')
                {
                	if((l-k)==2)
                        {
                        	mydigi1[6]=dbuff[k+1];
                                goto selesai_myssid1;
                        }
                        else if((l-k)==3)
                        {
                        	mydigi1[6]=(10*(dbuff[k+1]-48)+dbuff[k+2]-48)+48;
                        	goto selesai_myssid1;
                        }
                }
                mydigi1[k]=dbuff[k];
        }
        selesai_myssid1:
        if(buffer[b]=='"')goto time_interval;

	// 2nd digi
        b=j;
        k=0;
        while((buffer[b]!='"')&&(buffer[b]!=',')) //<--- move data from rxbuffer to databuffer
        {
        	dbuff[k]=buffer[b];
                k++;
                b++;
        }
        j=b+1; 		// j = index , atau "   j+b = index next data field

        // pada titik ini, k adalah ukuran array 2nd digi string
        l=k;
        for(k=0;k<l;k++)
        {
        	if(dbuff[k]=='-')
                {
                	if((l-k)==2)
                        {
                        	mydigi2[6]=dbuff[k+1];
                                goto selesai_myssid2;
                        }
                        else if((l-k)==3)
                        {
                        	mydigi2[6]=(10*(dbuff[k+1]-48)+dbuff[k+2]-48)+48;
                        	goto selesai_myssid2;
                        }
                }
                mydigi2[k]=dbuff[k];
        }
        selesai_myssid2:
	if(buffer[b]=='"')goto time_interval;

        // 3rd digi
       	b=j;
        k=0;
        while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
        {
        	dbuff[k]=buffer[b];
                k++;
                b++;
        }
        j=b+1; 		// b = index , atau "   j+1 = index next data field

        // pada titik ini, k adalah ukuran array 3rd digi string
        l=k;
        for(k=0;k<l;k++)
        {
        	if(dbuff[k]=='-')
                {
                	if((l-k)==2)
                        {
                        	mydigi3[6]=dbuff[k+1];
                                goto selesai_myssid3;
                        }
                        else if((l-k)==3)
                        {
                        	mydigi3[6]=(10*(dbuff[k+1]-48)+dbuff[k+2]-48)+48;
                        	goto selesai_myssid3;
                        }
                }
                mydigi3[k]=dbuff[k];
        }
        selesai_myssid3:

        time_interval:
        //time interval
        b=j;
        for(k=0;k<sizeof(ibuff);k++)ibuff[k]=0;
        k=0;
        while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
        {
        	ibuff[k]=buffer[b];
                k++;
                b++;
        }
        j=b+1;
        timeIntv=atoi(ibuff);

        //symbol code
        b=j;
        SYM_CODE_=buffer[b];
        j=b+2;

        //symbol table
        b=j;
        SYM_TAB_OVL_=buffer[b];
        j=b+2;

        //comment
        b=j;
        for(k=0;k<commsize;k++)comment[k]=0;
        k=0;
        while(buffer[b]!='"')
        {
        	comment[k]=buffer[b];
                k++;
                b++;
                commsize=k;
        }
        j=b+1;

        //status
        b=j;
        for(k=0;k<statsize;k++)status[k]=0;
        k=0;
        while(buffer[b]!='"')
        {
        	status[k]=buffer[b];
                k++;
                b++;
                statsize=k;
        }
        j=b+1;

        //status interval
        b=j;
        for(k=0;k<sizeof(ibuff);k++)ibuff[k]=0;
        k=0;
        while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
        {
        	ibuff[k]=buffer[b];
                k++;
                b++;
        }
        j=b+1;
        m_int=atoi(ibuff);

        //BASE-91 compression
        b=j;
        compstat=buffer[b];
        j=b+2;

        //set latitude
        b=j;
        if(buffer[b]=='"')goto usegps;
        k=0;
        while(buffer[b]!=',')
        {
        	posisi_lat[k]=buffer[b];
                k++;
                b++;
        }
        j=b+1;

        //set longitude
        b=j;
        k=0;
        while(buffer[b]!='"')
        {
        	posisi_long[k]=buffer[b];
                k++;
                b++;
        }
        j=b+1;

        usegps:
        //use GPS ?
        b=j;
        gps=buffer[b];
        j=b+2;

        // battery voltage in comment ?
        b=j;
        battvoltincomm=buffer[b];
        j=b+2;

        // temperature in comment ?
        b=j;
        tempincomm=buffer[b];
        j=b+2;

        // send altitude ?
        b=j;
        sendalt=buffer[b];
        j=b+2;

        // send to PC ?
        b=j;
        sendtopc=buffer[b];
        j=b+2;

        //ProTrak! model A configuration ends here

        // telemetry interval
        b=j;
        for(k=0;k<sizeof(tbuff);k++)tbuff[k]=0;
        k=0;
        while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
        {
        	tbuff[k]=buffer[b];
                k++;
                b++;
        }
        j=b+1;
        tel_int=atoi(tbuff);

        /*/ telemetri input channel
        // 1
        b=j;
        pri1=buffer[b];
        j=b+5;

        // 2
        b=j;
        pri2=buffer[b];
        j=b+5;

        // 3
        b=j;
        pri3=buffer[b];
        j=b+8;

        // 4
        b=j;
        pri4=buffer[b];
        j=b+8;

        // 5
        b=j;
        pri5=buffer[b];
        j=b+2; */

        //label
        b=j;
        for(k=0;k<sizeof(param);k++)param[k]=0;
        k=0;
        while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
        {
        	param[k]=buffer[b];
                k++;
                b++;
        }
        j=b+1;

        // unit
        b=j;
        for(k=0;k<sizeof(unit);k++)unit[k]=0;
        k=0;
        while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
        {
        	unit[k]=buffer[b];
                k++;
                b++;
        }
        j=b+1;

        // equation
        b=j;
        for(k=0;k<sizeof(eqns);k++)eqns[k]=0;
        k=0;
        while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
        {
        	eqns[k]=buffer[b];
                k++;
                b++;
        }
        //j=b+1;

        // EHCOING
        //mem_display();

        //ProTrak! model A+ configuration ends here

        MERAH=0;
        HIJAU=0;
        putchar(13);putchar(13);putsf("CONFIG SUCCESS !");
        putchar(13);

	#asm("sei")
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
				/*altitude=    (3*(long)((n_altitude[0]*100000)+(n_altitude[1]*10000)+(n_altitude[2]*1000)
                                		+(n_altitude[3]*100)+(n_altitude[4]*10)+(n_altitude[5])));  */
                                altitude=3*atol(n_altitude);

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
	if(gps=='Y')
        {
        	HIJAU=0;
                MERAH=0;
                extractGPS();
        }
        else
        {
        	HIJAU=1;
                MERAH=0;
                if(PIND.0==0)extractGPS();
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

	UCSRA=0x00;
	UCSRB=0x18;
	UCSRC=0x86;
	UBRRH=0x00;
	UBRRL=0x8F;
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
        	if(sendtopc=='Y')
                {
                read_temp();
                read_volt();
                putchar(13);putsf("Temperature       :");puts(temp);//putchar('C');
                putchar(13);putsf("Battery Voltage   :");puts(volt);//putchar('V');
                delay_ms(1000);
                }
      	}
}
