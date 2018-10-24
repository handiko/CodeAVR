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

#include <ax25_module.h>
#include <model_a_io.h>
#include <ax25_protocoler.h>
#include <read_temp_batt.h>



void base91_lat(void);
void base91_long(void);
void base91_alt(void);
void kirim_add_aprs(void);
void kirim_ax25_head(void);
void kirim_status(void);
void kirim_paket(void);
unsigned int read_adc(unsigned char adc_input);
void waitComma(void);
void waitDollar(void);
void waitInvCo(void);
void config(void);
void extractGPS(void);

eeprom int timeIntv=4;
eeprom char gps='N';
eeprom char sendtopc='N';

char beacon_stat;
bit nada;
static char bit_stuff;
unsigned short crc;
char tcnt1c;

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
        head_norm_alt[3]=(altitude/100000)+'0';
        head_norm_alt[4]=((altitude%100000)/10000)+'0';
        head_norm_alt[5]=((altitude%10000)/1000)+'0';
        head_norm_alt[6]=((altitude%1000)/100)+'0';
        head_norm_alt[7]=((altitude%100)/10)+'0';
        head_norm_alt[8]=(altitude%10)+'0';

        //itoa(altitude,body_norm_alt);
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
					/*altitude=(3*((n_altitude[0]*100000)+(n_altitude[1]*10000)+(n_altitude[2]*1000)
                                		+(n_altitude[3]*100)+(n_altitude[4]*10)+(n_altitude[5])));*/
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

	while (1)
      	{
        	//putchar(p=getchar());
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
