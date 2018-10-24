

#include <mega8.h>
#include <delay.h>
#include <stdio.h>
#include <stdint.h>
#include <delay.h>
#include <math.h>
#include <stdlib.h>

#include <read_temp_batt.h>

#define TX_DELAY_ 	45
#define FLAG_		0x7E
#define	CONTROL_FIELD_	0x03
#define PROTOCOL_ID_	0xF0
#define TD_POSISI_ 	'='
#define TD_STATUS_	'>'
#define TX_TAIL_	5

void kirim_add_aprs(void);
void kirim_ax25_head(void);
void kirim_status(void);
void kirim_paket(void);

eeprom char SYM_TAB_OVL_='/';
eeprom char SYM_CODE_='O';
eeprom unsigned char add_aprs[7]={('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),('0'<<1)};
eeprom unsigned char add_beacon[7]={('B'<<1),('E'<<1),('A'<<1),('C'<<1),('O'<<1),('N'<<1),('0'<<1)};
eeprom unsigned char mycall[8]={"YC2WYA0"};
eeprom unsigned char mydigi1[8]={"WIDE2 1"};
eeprom unsigned char mydigi2[8]={"WIDE2 2"};
eeprom unsigned char mydigi3[8]={"WIDE2 2"};
eeprom char comment[100] ={"New Tracker"};
eeprom char status[100]={"ProTrak! APRS & Telemetry Encoder"};
eeprom char statsize=33;
eeprom int m_int=21;
eeprom char commsize=11;
eeprom unsigned int altitude = 0;
eeprom char battvoltincomm='Y';
eeprom char tempincomm='Y';
eeprom char sendalt='Y';
eeprom char compstat='Y';
eeprom char posisi_lat[]={"0745.48S"};
eeprom char posisi_long[]={"11022.56E"};
eeprom char comp_lat[4];
eeprom char comp_long[4];

char comp_cst[3]={33,33,(0b00110110+33)};
char head_norm_alt[10]={"/A=000000"};
char beacon_stat;
bit nada;
static char bit_stuff;
unsigned short crc;
char tcnt1c;

void kirim_add_aprs(void)
{
	char i;

        for(i=0;i<7;i++)kirim_karakter(add_aprs[i]);
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
        altitude+=3;
        if(altitude==65535)altitude=0;
        normal_alt();

        MERAH = 1;
        HIJAU = 0;

        beacon_stat++;
        prepare();
        if(beacon_stat==1)
        {
        	kirim_status();
                goto oke;
        }
        if(beacon_stat==3)
        {
        	kirim_beacon();
                goto oke;
        }
        if((beacon_stat==2)||((beacon_stat%m_int)!=0))
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
                		for(i=0;i<9;i++)kirim_karakter(head_norm_alt[i]);
                        	kirim_karakter(' ');
                        }
                }
                if(tempincomm=='Y')
                {for(i=0;i<6;i++)if(temp[i]!=' ')kirim_karakter(temp[i]);
                kirim_karakter(' ');}
                if(battvoltincomm=='Y')
                {for(i=0;i<6;i++)if(volt[i]!=' ')kirim_karakter(volt[i]);
                kirim_karakter(' ');}
                for(i=0;i<commsize;i++)kirim_karakter(comment[i]);

                goto oke;
        }
        if((beacon_stat%m_int)==0)kirim_status();

        oke:
	kirim_crc();
        kirim_karakter(FLAG_);
        kirim_karakter(FLAG_);
        if(beacon_stat==100)beacon_stat=0;
        PTT = 0;
        MERAH = 0;
        HIJAU = 0;
}
