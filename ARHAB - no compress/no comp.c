
// header firmware
#include <mega8.h>
#include <stdio.h>
#include <mega8_bits.h>
#include <delay.h>

#define ADC_VREF_TYPE 0x00
#define AFOUT	PORTB.4
#define PTT	PORTB.5
#define MERAH	PORTD.6
#define HIJAU	PORTD.7
#define VSENSE_ADC_	0
#define TEMP_ADC_	1


#define _1200		0
#define _2200		1

#define TX_DELAY_	45
#define FLAG_		0x7E
#define	CONTROL_FIELD_	0x03
#define PROTOCOL_ID_	0xF0
#define TD_POSISI_	'!'
#define TD_STATUS_	'>'
#define TX_TAIL_	15

#include <delay.h>
#include <stdarg.h>
#include <stdlib.h>
#include <math.h>

void set_nada(char i_nada);
void kirim_karakter(unsigned char input);
void kirim_paket(void);
void ubah_nada(void);
void hitung_crc(char in_crc);
void kirim_crc(void);
void ekstrak_gps(void);
void read_temp(void);
void read_volt(void);




eeprom int GAP_TIME_=5;
eeprom char SYM_TAB_OVL_='/';
eeprom char SYM_CODE_='[';
eeprom unsigned int ketinggian=0;
eeprom unsigned char add_aprs[7]={('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),('0'<<1)};
eeprom unsigned char mycall[8]={"YD2WZM9"};
eeprom unsigned char mydigi1[8]={"WIDE2 2"};
eeprom unsigned char mydigi2[8]={"WIDE2 2"};
eeprom unsigned char mydigi3[8]={"WIDE2 2"};
eeprom char posisi_lat[9] ={'0','7','4','5','.','9','8','2','S'};
eeprom char posisi_long[10] ={'1','1','0','2','2','.','3','7','5','E'};
eeprom char altitude[6];
eeprom char beacon_stat = 0;
eeprom char battvoltincomm='Y';
eeprom char tempincomm='Y';
eeprom char komentar[100] ={"New Tracker"};
eeprom char status[100]={"ProTrak! APRS & Telemetry Encoder"};
eeprom int timeIntv=20;
eeprom char compstat='Y';
eeprom char sendalt='Y';
eeprom char gps='N';
eeprom char sendtopc='N';
eeprom char commsize=11;
eeprom char statsize=33;

char temp[7]={"020.0C"};
char volt[7]={"013.8V"};
char xcount = 0;
bit nada = _1200;
static char bit_stuff = 0;
unsigned short crc;
char comp_lat[4];
char comp_long[4];
char comp_cst[3]={33,33,(0b00110110+33)};
unsigned short crc;


/***************************************************************************************/
	interrupt 		[TIM1_OVF] void timer1_ovf_isr(void)
/***************************************************************************************/
{
	// matikan LED stanby
        //if((xcount%2) == 0)
        //{
                if(gps=='Y')
                {
                	HIJAU=0;
                	MERAH=0;
                	ekstrak_gps();
        	}
                else
                {
                	HIJAU=1;
                	MERAH=0;
                	if(PIND.0==0)ekstrak_gps();
                }

        //}

        if((xcount==GAP_TIME_)||(xcount==0))
        {
                //ekstrak_gps();
                delay_ms(500);
                kirim_paket();
                xcount = 0;
        }

        xcount++;

        TCNT1H = (60135 >> 8);
        TCNT1L = (60135 & 0xFF);

}       // EndOf interrupt [TIM1_OVF] void timer1_ovf_isr(void)

unsigned int read_adc(unsigned char adc_input)
{
	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	delay_us(10);
	ADCSRA|=0x40;
	while ((ADCSRA & 0x10)==0);
	ADCSRA|=0x10;
	return ADCW;
}

void read_temp(void)
{
	int adc;
        char adc_r,adc_p,adc_s,adc_d;

        adc = (5*read_adc(TEMP_ADC_)/1.024);

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

        adc = (5*8*read_adc(VSENSE_ADC_))/102.4;

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
        sec = ((posisi_lat[5]-48)*100.0) + ((posisi_lat[6]-48)*10.0)+((posisi_lat[7]-48)*1.0);
        //sec = ((posisi_lat[5]-48)*10.0) + (posisi_lat[6]-48);

        if(posisi_lat[8]=='N') sign = 1.0;
        else sign = -1.0;

        //f_lat = (deg + (min/60.0) + (0.6*sec/360000.0));
        f_lat = (deg + (min/60.0) + (0.6*sec/36000.0));
        //f_lat = (deg + (min/60.0) + (0.6*sec/3600.0));
        lat = 380926 * (90 - (f_lat * sign));

        comp_lat[0] = (lat/753571)+33;
        comp_lat[1] = ((fmod(lat,753571))/8281)+33;
        comp_lat[2] = ((fmod(lat,8281))/91)+33;
        comp_lat[3] = (fmod(lat,91))+33;
}

void base91_long(void)
{
  	unsigned char deg;
        char min;
        int sec;
        char sign;
        float lon;
        float f_lon;

        deg = ((posisi_long[0]-48)*100.0) + ((posisi_long[1]-48)*10.0) + ((posisi_long[2]-48)*1.0);
        min = ((posisi_long[3]-48)*10.0) + ((posisi_long[4]-48)*1.0);
        //sec = ((posisi_long[6]-48)*1000.0) + ((posisi_long[7]-48)*100.0) + ((posisi_long[8]-48)*10.0) + (posisi_long[9]-48);
        sec = ((posisi_long[6]-48)*100.0) + ((posisi_long[7]-48)*10.0) + ((posisi_long[8]-48)*1.0);
        //sec = ((posisi_long[6]-48)*10.0) + (posisi_long[7]-48);

        if(posisi_long[9]=='E') sign = 1.0;
        else			sign = -1.0;

        //f_lon = (deg + (min/60.0) + (sec/360000.0));
        f_lon = (deg + (min/60.0) + (0.61*sec/36000.0));
        //f_lon = (deg + (min/60.0) + (sec/3600.0));
        lon = 190463 * (180 + (f_lon * sign));

        comp_long[0] = (lon/(91*91*91))+33;
        comp_long[1] = ((fmod(lon,(91*91*91)))/(91*91))+33;
        comp_long[2] = ((fmod(lon,(91*91)))/91)+33;
        comp_long[3] = (fmod(lon,91))+33;
}

void base91_alt(void)
{
	int alt;

        alt = (500.5*log(ketinggian*1.0));
        comp_cst[0] = (alt/91)+33;
        comp_cst[1] = (alt%91)+33;
}

void kirim_add_aprs(void)
{
	char i;

        for(i=0;i<7;i++)kirim_karakter(add_aprs[i]);
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


/***************************************************************************************/
	void 			kirim_paket(void)
/***************************************************************************************/
{
	char i;

        crc = 0xFFFF;
	beacon_stat++;
	PTT = 1;
        MERAH=1;
        HIJAU=0;
	delay_ms(100);

        base91_lat();
        base91_long();
        base91_alt();
        read_volt();
        read_temp();

        for(i=0;i<TX_DELAY_;i++)kirim_karakter(FLAG_);

        bit_stuff = 0;

        kirim_add_aprs();
        kirim_ax25_head();

        if(beacon_stat == timeIntv)
        {
        	kirim_karakter(TD_STATUS_);
		for(i=0;i<statsize;i++)kirim_karakter(status[i]);
		beacon_stat = 0;

                goto lompat;
        }
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
        	for(i=0;i<7;i++)kirim_karakter(posisi_lat[i]);
                kirim_karakter(posisi_lat[8]);
		kirim_karakter(SYM_TAB_OVL_);
		for(i=0;i<8;i++)kirim_karakter(posisi_long[i]);
                kirim_karakter(posisi_long[9]);
		kirim_karakter(SYM_CODE_);
        	if(sendalt=='Y')
        	{
                	//for(i=0;i<9;i++)kirim_karakter(head_norm_alt[i]);
                        kirim_karakter('/');
                        kirim_karakter('A');
                        kirim_karakter('=');
                        for(i=0;i<6;i++)kirim_karakter(altitude[i]);
                	kirim_karakter(' ');
        	}
        }

        /*kirim_karakter(SYM_TAB_OVL_);
        for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
        for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
	kirim_karakter(SYM_CODE_);
        for(i=0;i<3;i++)kirim_karakter(comp_cst[i]); */
        if(tempincomm=='Y')
        {for(i=0;i<6;i++)if(temp[i]!=' ')kirim_karakter(temp[i]);
        kirim_karakter(' ');}
        if(battvoltincomm=='Y')
        {for(i=0;i<6;i++)if(volt[i]!=' ')kirim_karakter(volt[i]);
        kirim_karakter(' ');}
        for(i=0;i<commsize;i++)kirim_karakter(komentar[i]);

	lompat:

        kirim_crc();
        for(i=0;i<TX_TAIL_;i++)kirim_karakter(FLAG_);

        delay_ms(50);
        MERAH=0;
        HIJAU=0;
        PTT = 0;


}       // EndOf void kirim_paket(void)


/***************************************************************************************/
	void 			kirim_crc(void)
/***************************************************************************************/
{
	static unsigned char crc_lo;
	static unsigned char crc_hi;

        crc_lo = crc ^ 0xFF;
	crc_hi = (crc >> 8) ^ 0xFF;
	kirim_karakter(crc_lo);
	kirim_karakter(crc_hi);
}       // EndOf void kirim_crc(void)


/***************************************************************************************/
	void 			kirim_karakter(unsigned char input)
/***************************************************************************************/
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

}      // EndOf void kirim_karakter(unsigned char input)


/***************************************************************************************/
	void 			hitung_crc(char in_crc)
/***************************************************************************************/
{
	static unsigned short xor_in;

        xor_in = crc ^ in_crc;
	crc >>= 1;
        if(xor_in & 0x01) crc ^= 0x8408;

}      // EndOf void hitung_crc(char in_crc)


/***************************************************************************************/
	void 			ubah_nada(void)
/***************************************************************************************/
{
	if(nada ==_1200)
	{
        	nada = _2200;
                set_nada(nada);
	}
        else
        {
                nada = _1200;
                set_nada(nada);
        }

}       // EndOf void ubah_nada(void)





/***************************************************************************************/
	void 			set_nada(char i_nada)
/***************************************************************************************/
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

} 	// EndOf void set_nada(char i_nada)


/***************************************************************************************/
	void 			getComma(void)
/***************************************************************************************/
{
	while(getchar() != ',');
}      	// EndOf void getComma(void)

void mem_display(void)
{
	// configuration ECHO
        // mycall & SSID
        char k;
        char f[];

        #asm("cli")

        MERAH=1;
        HIJAU=0;

        putchar(13);
        putchar(',');
        for(k=0;k<6;k++)if((mycall[k])!=' ')putchar(mycall[k]);
        if((mycall[6])>'0')
        {
        	putchar('-');
                itoa(mycall[6]-48,f);
                puts(f);
        }

        // digipath
        putchar(',');
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
        putchar(',');
        itoa(timeIntv,f);
        puts(f);


        // symbol code / icon
       	putchar(',');
        putchar(SYM_CODE_);

        // symbol table / overlay
        putchar(',');
        putchar(SYM_TAB_OVL_);

        // comment
        putchar(',');
        for(k=0;k<commsize;k++)
        {
        	if(komentar[k]!=0)putchar(komentar[k]);
        }

        // status
        putchar(',');
        for(k=0;k<statsize;k++)
        {
        	if(status[k]!=0)putchar(status[k]);
        }

        // status interval
        putchar(',');
        itoa(timeIntv,f);
        puts(f);

        // BASE-91 Comppresion ?
        putchar(',');
        putchar(compstat);

        // Coordinate
        putchar(',');
        for(k=0;k<9;k++)putchar(posisi_lat[k]);
        putchar(',');
        for(k=0;k<10;k++)putchar(posisi_long[k]);

        //use gps
        putchar(',');
        putchar(gps);

        // battery volt
        putchar(',');
        putchar(battvoltincomm);

        // temperature
        putchar(',');
        putchar(tempincomm);

        // altitude
        putchar(',');
        putchar(sendalt);

        // send to PC
        putchar(',');
        putchar(sendtopc);

        MERAH=0;
        HIJAU=0;

        #asm("sei")
}

void waitInvCo(void)
{
	while(getchar()!='"');
}

void waitDollar(void)
{
	while(getchar()!='$');
}

void config(void)
{
	char buffer[500];
        char dbuff[];
        char cbuff[];
        char ibuff[5];
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
        GAP_TIME_=atoi(ibuff);

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
        for(k=0;k<commsize;k++)komentar[k]=0;
        k=0;
        while(buffer[b]!='"')
        {
        	komentar[k]=buffer[b];
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
        timeIntv=atoi(ibuff);

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
        //j=b+2;

        //ProTrak! model A configuration ends here

        // EHCOING
        mem_display();

        //ProTrak! model A+ configuration ends here

        MERAH=0;
        HIJAU=0;
        putchar(13);putchar(13);putsf("CONFIG SUCCESS !");
        putchar(13);

	#asm("sei")
}


/***************************************************************************************/
	void 			ekstrak_gps(void)
/***************************************************************************************/
{
	int i,j;
        static char buff_posisi[20], buff_altitude[9];
        char n_altitude[6];
        char cb;

        HIJAU=1;
        MERAH=0;

        //#asm("cli")
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
                                getComma();
                                getComma();
                                for(i=0; i<8; i++)	buff_posisi[i] = getchar();
                                //for(i=0;i<8;i++)posisi_lat[i]=getchar();
                                getComma();
                                buff_posisi[8] = getchar();
                                //posisi_lat[8]=getchar();
                                getComma();
                                for(i=0; i<9; i++)	buff_posisi[i+9] = getchar();
                                //for(i=0;i<9;i++)posisi_long[i]=getchar();
                                getComma();
                                buff_posisi[18] = getchar();
                                //posisi_long[9]=getchar();
                                getComma();
                                getComma();
                                getComma();
                                getComma();
                                for(i=0;i<8;i++)        buff_altitude[i] = getchar();
                                for(i=0;i<9;i++)	{posisi_lat[i]=buff_posisi[i];}
        			for(i=0;i<10;i++)	{posisi_long[i]=buff_posisi[i+9];}
                                for(i=0;i<8;i++)if(posisi_lat[i]==',')posisi_lat[i]='0';
                                for(i=0;i<9;i++)if(posisi_long[i]==',')posisi_long[i]='0';
                                if((posisi_lat[8]!='N')&&(posisi_lat[8]!='S'))posisi_lat[8]='N';
                                if((posisi_long[9]!='E')&&(posisi_long[9]!='W'))posisi_long[9]='E';
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

                                for(i=0;i<6;i++)        n_altitude[i] -= '0';

                                n_altitude[0] *= 100000;
                                n_altitude[1] *=  10000;
                                n_altitude[2] *=   1000;
                                n_altitude[3] *=    100;
                                n_altitude[4] *=     10;

                                n_altitude[5] += (n_altitude[0] + n_altitude[1] + n_altitude[2] + n_altitude[3] + n_altitude[4]);
                                n_altitude[5] *= 3;


                                ketinggian=n_altitude[5];
                                //ketinggian=3*atoi(n_altitude);

                                n_altitude[0] = n_altitude[5] / 100000;
                                n_altitude[5] = n_altitude[5]%100000;

                                n_altitude[1] = n_altitude[5] / 10000;
                                n_altitude[5] %= 10000;

                                n_altitude[2] = n_altitude[5] / 1000;
                                n_altitude[5] %= 1000;

                                n_altitude[3] = n_altitude[5] / 100;
                                n_altitude[5] %= 100;

                                n_altitude[4] = n_altitude[5] / 10;
                                n_altitude[5] %= 10;

                                // itoa, pindahkan dari variable numerik ke eeprom
                                for(i=0;i<6;i++)        altitude[i] = (char)(n_altitude[i] + '0');

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

	else if(cb=='E')
        {
        	if(getchar()=='C')
                {
                	if(getchar()=='H')
                        {
                        	if(getchar()=='O')
                                {
                                	mem_display();
                                        goto keluar;
        			}
                        }
                }
        }

        goto lagi;

        keluar:
        //#asm("sei")
        HIJAU=0;
        MERAH=0;

} 	// EndOf void ekstrak_gps(void)


/***************************************************************************************/
	void main(void)
/***************************************************************************************/
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

	// Rx ON-noInt Tx ON-noInt
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

        //kirim_paket();

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

}	// END OF MAIN PROGRAM
/*
*
*	END OF FILE
*
****************************************************************************************/