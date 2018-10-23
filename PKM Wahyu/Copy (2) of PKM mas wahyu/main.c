/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 5/1/2012
Author  :
Company :
Comments:


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 11.059200 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>
#include <alcd.h>
#include <stdio.h>
#include <delay.h>
#include <string.h>

#ifndef _EEP_SIZE
#define _EEP_SIZE 1000
#endif

#define MAX_EEP_SIZE 1000

#ifdef _EEP_SIZE
#if    _EEP_SIZE > MAX_EEP_SIZE
#undef _EEP_SIZE
#define _EEP_SIZE MAX_EEP_SIZE
#message EEPROM SUDAH DI-SET KE : _EEP_SIZE BYTE(S)
#endif
#endif

#define ADC_VREF_TYPE 0x40

void goto_menu(void);
void pattern_menu_a(char *str1,char *str2,char up,char down,char ent);
void pattern_menu_b(char *str1,char *str2,char up,char down,char ent,char can);
void menu1(void);
void menu2(void);
void menu3(void);
void menu4(void);
void menu5(void);
void menu6(void);
void menu7(void);
void menu8(void);
void menu9(void);
void menu10(void);
void menu11(void);
void menu12(void);
void menu13(void);
void menu14(void);
void menu15(void);
void menu16(void);
void menu17(void);
void menu18(void);
void menu19(void);
void menu20(void);
void menu21(void);
void menu22(void);
void menu23(void);
void menu24(void);
void menu25(void);
void menu26(void);
void menu27(void);
void menu28(void);
void menu29(void);
void menu30(void);
void menu31(void);
void menu32(void);
void menu33(void);
void menu34(void);
void menu35(void);
void menu36(void);
void menu37(void);
void menu38(void);
void menu39(void);
void menu40(void);
unsigned int read_adc(unsigned char adc_input);
void switch_to_modem(void);
void switch_clear(void);
//void reflect_data_until(unsigned char limiter);
void banner_pembuka(void);
void banner_sys(void);
void banner_sys_freeze(void);
void kirim_data_komplit(void);
void kirim_data_sekarang(void);

bit data_valid;
eeprom char data_petir[_EEP_SIZE];
eeprom char no_menu,last_menu;
char lcd_buff[33];
char data_perintah[200];

#define INDIKATOR_1 PORTC.2
#define INDIKATOR_2 PORTC.3

#define SEL_A	PORTC.1
#define SEL_B	PORTC.0

#define TOM_ENTER	PIND.4
#define TOM_UP		PIND.5
#define TOM_DOWN  	PIND.6
#define TOM_CANCEL	PIND.7

#define SENSE_1	1
#define SENSE_2	2
#define SENSE_3 3
#define SENSE_4	4
#define SENSE_5	5
#define SENSE_6 6

#define PTT		PORTA.0
#define CARIER_DET	PIND.0

#define S_SLEEP	0
#define S_WAKE	1

eeprom char sys_mode = 0;
eeprom char chn_omega1 = 1;
eeprom char chn_omega2 = 2;
eeprom char chn_omega3 = 3;
eeprom char chn_petir = 4;
eeprom int xcount = 0;

interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
	TCNT1H=0xFB;
	TCNT1L=0xF0;

        #asm("cli")
        if(sys_mode)
        {
        	if(xcount>_EEP_SIZE)
        	{
        		xcount = 0;
                	kirim_data_komplit();
        	}
        	data_petir[xcount]=read_adc(chn_petir);
        	xcount++;
        }
        //#asm("sei")
}

#define STATION_STRING	",JTF_BALERANTE,"

void kirim_data_komplit(void)
{
	int i,j,k=0;
        PTT = 1;
        PORTD.1 = 1;
        delay_ms(500);
        puts("$$$$$$$$$$$$$$$$$$,");
        for(i=0;i<20;i++)
        {
        	puts(STATION_STRING"$TEL*,PETIR*,");
                for(j=0;j<50;j++)
                {
                	putchar(data_petir[k]);
                        putchar(',');
                        k++;
                }
                puts("*50*,");
                putchar('\n');
        }

        puts(STATION_STRING"$TEL*,OMEGA*,");
        putchar(read_adc(chn_omega1));
        putchar(',');
        putchar(read_adc(chn_omega2));
        putchar(',');
        putchar(read_adc(chn_omega3));
        puts(",*3*,");
        putchar('\n');
        puts("#########");
        PTT = 0;
}



void kirim_data_sekarang(void)
{
	char i,j;
        int k=0;

        #asm("cli")

        for(i=0;i<20;i++)
        {
        	puts(STATION_STRING"$TEL*,PETIR*,");
                for(j=0;j<50;j++)
                {
                	putchar(data_petir[k]);
                        putchar(',');
                        k++;
                        if(k==xcount) goto selesai;
                }
                puts("*50*");
                putchar('\n');
        }

       	selesai:

        puts("*END*,");
        putchar('\n');

        puts(STATION_STRING"$TEL*,OMEGA*,");
        putchar(read_adc(chn_omega1));
        putchar(',');
        putchar(read_adc(chn_omega2));
        putchar(',');
        putchar(read_adc(chn_omega3));
        puts(",*3*,");
        putchar('\n');
}

void adc_init(void)
{
   	ADMUX = ADC_VREF_TYPE & 0xff;
	ADCSRA = 0x84;
}

unsigned int read_adc(unsigned char adc_input)
{
	ADMUX = adc_input | (ADC_VREF_TYPE & 0xff);
	delay_us(10);
	ADCSRA |= 0x40;
	while ((ADCSRA & 0x10) == 0);
	ADCSRA |= 0x10;
        if(ADCW>127) ADCW=127;
	return ADCW;
}

void usart_init(void)
{
	UCSRA = 0x00;
	UCSRB = 0xD8;
	UCSRC = 0x86;
	UBRRH = 0x02;
	UBRRL = 0x3F;
}

void switch_to_modem(void)
{
	SEL_B = 1; SEL_A = 0;
}

void switch_clear(void)
{
  	SEL_B = 1; SEL_A = 1;
}
/*
void reflect_data_until(unsigned char limiter)
{
	int i;

        //data_stat = 0;
        for(i=0;;i++)
        {
        	data[i] = getchar();
                lcd_putchar(data[i]);
                if(data[i]==limiter)
                {
                	//data_stat = 1;
                        goto esc;
                }
                if(i == (_EEP_SIZE-1))goto esc;
                //if(i == 20)goto esc;
        }

        esc:
        data_stat = 1;
        if(data_stat)
        {
        	PTT = 1;
                //delay_ms(500);
                puts("FSTART");
        	for(i=0;((data[i]!=limiter)&&(i!=(_EEP_SIZE-1)));i++)
                	putchar(data[i]);
                puts("FEND");
                PTT = 0;
                delay_ms(500);
                lcd_clear();
                banner_sys();
        }
}*/

void banner_pembuka(void)
{
 	lcd_clear();
        lcd_gotoxy(0,0);
        	 //0123456789abcdef
        lcd_putsf("----JTF.UGM-----");
       	delay_ms(1000);
        lcd_clear();
        lcd_gotoxy(0,0);
        	 //0123456789abcdef
        lcd_putsf(" Sistem");
        lcd_gotoxy(0,1);
        lcd_putsf(" Monitoring");
        delay_ms(1000);
        lcd_clear();
        lcd_gotoxy(0,0);
        	 //0123456789abcdef
        lcd_putsf(" Ds. Balerante");
        lcd_gotoxy(0,1);
        lcd_putsf(" Gn. Merapi DIY");
        delay_ms(1000);
        lcd_clear();
}

void banner_sys(void)
{
 	lcd_clear();
        lcd_gotoxy(0,0);
        if(sys_mode)	lcd_putsf("System running");
        else		lcd_putsf("System stanby");
}

void banner_sys_freeze(void)
{
 	lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("System stoped !");
}

void goto_menu(void)
{
	switch_clear();
        for(;;)
        {
		#asm("cli")
                if(no_menu==0)	banner_sys_freeze();

                else if(no_menu==1)	menu1();
                else if(no_menu==2)	menu2();
                else if(no_menu==3)	menu3();
                else if(no_menu==4)	menu4();
                else if(no_menu==5)	menu5();
                else if(no_menu==6)	menu6();
                else if(no_menu==7)	menu7();
                else if(no_menu==8)	menu8();
                else if(no_menu==9)	menu9();
                else if(no_menu==10)	menu10();
                else if(no_menu==11)	menu11();
                else if(no_menu==12)	menu12();
                else if(no_menu==13)	menu13();
                else if(no_menu==14)	menu14();
                else if(no_menu==15)	menu15();
                else if(no_menu==16)	menu16();
                else if(no_menu==17)	menu17();
                else if(no_menu==18)	menu18();
                else if(no_menu==19)	menu19();
                else if(no_menu==20)	menu20();
                else if(no_menu==21)	menu21();
                else if(no_menu==22)	menu22();
                else if(no_menu==23)	menu23();
                else if(no_menu==24)	menu24();
                else if(no_menu==25)	menu25();
                else if(no_menu==26)	menu26();
                else if(no_menu==27)	menu27();
                else if(no_menu==28)	menu28();
                else if(no_menu==29)	menu29();
                else if(no_menu==30)	menu30();
                else if(no_menu==31)	menu31();
                else if(no_menu==32)	menu32();
                else if(no_menu==33)	menu33();
                else if(no_menu==34)	menu34();
                else if(no_menu==35)	menu35();
                else if(no_menu==36)	menu36();
                else if(no_menu==37)	menu37();
                else if(no_menu==38)	menu38();
                else if(no_menu==39)	menu39();
                else if(no_menu==40)	menu40();

                else if(no_menu==100)	goto esc;
        }
        esc:
        lcd_clear();
        delay_ms(500);
        //#asm("sei")
        banner_sys();
        puts("$$##");
}

void pattern_menu_a(char *str1,char *str2,char up,char down,char ent)
{
	last_menu = no_menu;
	lcd_clear();
        lcd_gotoxy(0,0);
        lcd_puts(str1);
	lcd_gotoxy(0,1);
        lcd_puts(str2);
        delay_ms(500);
        while((TOM_UP)&&(TOM_DOWN)&&(TOM_ENTER)&&(TOM_CANCEL));
        if(TOM_UP==0)
        {
        	delay_ms(200);
        	no_menu = up;
        }
        if(TOM_DOWN==0)
        {
        	delay_ms(200);
        	no_menu = down;
        }
        if(TOM_ENTER==0)
        {
        	delay_ms(200);
        	no_menu = ent;
        }
        if(TOM_CANCEL==0)
        {
        	delay_ms(200);
        	no_menu = last_menu;
        }
}

void pattern_menu_b(char *str1,char *str2,char up,char down,char ent,char can)
{
	last_menu = no_menu;
	lcd_clear();
        lcd_gotoxy(0,0);
        lcd_puts(str1);
	lcd_gotoxy(0,1);
        lcd_puts(str2);
        delay_ms(500);
        while((TOM_UP)&&(TOM_DOWN)&&(TOM_ENTER)&&(TOM_CANCEL));
        if(!TOM_UP)
        {
        	delay_ms(200);
        	no_menu = up;
        }
        if(!TOM_DOWN)
        {
        	delay_ms(200);
        	no_menu = down;
        }
        if(!TOM_ENTER)
        {
        	delay_ms(200);
        	no_menu = ent;
        }
        if(!TOM_CANCEL)
        {
        	delay_ms(200);
                no_menu = can;
        }
}

void menu1(void) //fixed
{
	pattern_menu_b(	"1.Jalankan ",
        		" Sistem ",
                        2,16,100,0);
}

void menu2(void)
{                      //0123456789abcdef
	pattern_menu_b(	"2.Setting tres-",
        		" hold sensor",
                        3,1,0,last_menu);
}

void menu3(void)
{                      //0123456789abcdef
	pattern_menu_b(	"3.Setting jum-",
        		" lah sensor",
                        4,2,0,last_menu);
}

void menu4(void)
{                      //0123456789abcdef
	pattern_menu_b(	"4.Lihat data",
        		" sensor",
                        5,3,0,last_menu);
}

void menu5(void)
{                      //0123456789abcdef
	pattern_menu_b(	"5.Aktifkan ",
        		" sensor",
                        6,4,0,last_menu);
}

void menu6(void)
{                      //0123456789abcdef
	pattern_menu_b(	"6.Matikan",
        		" sensor",
                        7,5,0,last_menu);
}

void menu7(void)
{                      //0123456789abcdef
	pattern_menu_b(	"7.Tes pancar",
        		" data",
                        8,6,0,last_menu);
}

void menu8(void)
{                      //0123456789abcdef
	pattern_menu_b(	"8.Tes terima",
        		" data",
                        9,7,0,last_menu);
}

void menu9(void)
{
	pattern_menu_b(	"9.Sleep mode",
        		" ",
                        10,8,0,last_menu);
}

void menu10(void)
{
	pattern_menu_b(	"10.Wake-up",
        		" ",
                        11,9,0,last_menu);
}

void menu11(void)
{
	pattern_menu_b(	"11.",
        		"",
                        12,10,11,last_menu);
}

void menu12(void)
{
	pattern_menu_b(	"12.",
        		"",
                        13,11,12,last_menu);
}

void menu13(void)
{
	pattern_menu_b(	"13.",
        		"",
                        14,12,0,last_menu);
}

void menu14(void)
{
	pattern_menu_b(	"14.",
        		"",
                        15,13,14,last_menu);
}

void menu15(void)
{
	pattern_menu_b(	"15.",
        		"",
                        16,14,10,last_menu);
}

void menu16(void)
{
	pattern_menu_b(	"16.",
        		"",
                        1,15,10,last_menu);
}

void menu17(void)
{

}

void menu18(void)
{

}

void menu19(void)
{

}

void menu20(void)
{

}

void menu21(void)
{

}

void menu22(void)
{

}
void menu23(void)
{

}

void menu24(void)
{

}

void menu25(void)
{

}

void menu26(void)
{

}

void menu27(void)
{

}

void menu28(void)
{

}

void menu29(void)
{

}

void menu30(void)
{

}

void menu31(void)
{

}

void menu32(void)
{

}

void menu33(void)
{

}

void menu34(void)
{

}

void menu35(void)
{

}

void menu36(void)
{

}

void menu37(void)
{

}

void menu38(void)
{

}

void menu39(void)
{

}

void menu40(void)
{

}

void tx_data(char *str1,char *str2)
{
	PORTD.1 = 1;
        delay_ms(100);
        lcd_gotoxy(0,1);
        lcd_puts(str1);
        puts(str2);
        delay_ms(100);
        lcd_clear();
}

void usart_no_rx(void)
{
	// USART initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART Receiver: Off
	// USART Transmitter: On
	// USART Mode: Asynchronous
	// USART Baud Rate: 1200
	UCSRA=0x00;
	UCSRB=0x08;
	UCSRC=0x86;
	UBRRH=0x02;
	UBRRL=0x3F;
}

void baca_perintah(void)
{
	char i;
        if(!CARIER_DET)
        {
        	#asm("cli")
                for(i=0;;i++)
        	{
        		data_perintah[i]=getchar();
                	if(data_perintah[i]=='#') goto exec;
                	if(i==1)
                        {
                        	lcd_clear();
                                lcd_putsf("receiving");
                        }
        	}
        	exec:
                usart_no_rx();
                PTT = 1;
                PORTD.1 = 1;
                delay_ms(300);
        	lcd_clear();
                tx_data("","$$$$$$$$$$$$$$$$$$$,"STATION_STRING);
                for(i=0;;i++)
                {
			lcd_clear();
                        lcd_putsf("Sending data:");
                        delay_ms(150);
                	if(data_perintah[i]=='$')
                        {
                        	if((data_perintah[i+1]=='T')&&
                                (data_perintah[i+2]=='E')&&
                                (data_perintah[i+3]=='L'))
                                {
                        		tx_data("tipe protokol","$TEL*,");
                                        i+=3;
                                }

                                else if(data_perintah[i+1]=='$')
                                {
                                	lcd_clear();
                                }

                                else if((data_perintah[i+1]!='T')||
                                (data_perintah[i+2]!='E')||
                                (data_perintah[i+3]!='L'))
                                {
                                        goto esc;
                                }
                        }

                        else if(data_perintah[i]==',')
                        {
                        	if(data_perintah[i+1]==',')
                                {
                                	lcd_clear();
                                }

                                else if((data_perintah[i+1]=='S')&&
                                (data_perintah[i+2]=='A')&&
                                (data_perintah[i+3]=='D'))
                                {
                                	if(data_perintah[i+5]=='T')
                                        {
                                        	tx_data("alamat stasiun","TELE*,");
                                                i+=5;
                                        }
                                }

                                else if((data_perintah[i+1]=='S')&&
                                (data_perintah[i+2]=='E')&&
                                (data_perintah[i+3]=='T'))
                                {
                                	if((data_perintah[i+5]=='S')&&
                                        (data_perintah[i+6]=='L')&&
                                        (data_perintah[i+7]=='E')&&
                                        (data_perintah[i+8]=='E')&&
                                        (data_perintah[i+9]=='P'))
                                        {
                                        	tx_data("mode setting","SLEEP*,");
                                                sys_mode = S_SLEEP;
                                                i+=9;
                                        }

                                        else if((data_perintah[i+5]=='W')&&
                                        (data_perintah[i+6]=='A')&&
                                        (data_perintah[i+7]=='K')&&
                                        (data_perintah[i+8]=='E'))
                                        {
                                        	tx_data("mode setting","WAKE*,");
                                                sys_mode = S_WAKE;
                                                i+=8;
                                        }
                                }

                                else if((data_perintah[i+1]=='M')&&
                                (data_perintah[i+2]=='E')&&
                                (data_perintah[i+3]=='M'))
                                {
                                	if((data_perintah[i+5]=='E')&&
                                        (data_perintah[i+6]=='E')&&
                                        (data_perintah[i+7]=='P'))
                                        {
                                        	tx_data("tipe memori","EEP*,");
                                                i+=7;
                                        }
                                }

                                else if((data_perintah[i+1]=='A')&&
                                (data_perintah[i+2]=='S')&&
                                (data_perintah[i+3]=='K')&&
                                (sys_mode))
                                {
                                	if((data_perintah[i+5]=='I')&&
                                        (data_perintah[i+6]=='D'))
                                        {
                                        	tx_data("id stasiun","ANS-BALERANTE,");
                                                i+=6;
                                        }

                                        else if((data_perintah[i+5]=='S')&&
                                        (data_perintah[i+6]=='T')&&
                                        (data_perintah[i+7]=='A')&&
                                        (data_perintah[i+8]=='T'))
                                        {
                                        	if(sys_mode)
                                                {
                                                	tx_data("status service","ANS-SERVICE,");
                                                	i+=8;
                                                }

                                                else if(!sys_mode)
                                                {
                                                	tx_data("status service","ANS-SLEEP,");
                                                	i+=8;
                                                }
                                        }

                                        else if((data_perintah[i+5]=='O')&&
                                        (data_perintah[i+6]=='M')&&
                                        (data_perintah[i+7]=='E')&&
                                        (data_perintah[i+8]=='G')&&
                                        (data_perintah[i+9]=='A'))
                                        {
                                        	if(data_perintah[i+10]=='1')
                                                {
                                                	tx_data("data 1 konduktifitas","ANS-1");
                                                	putchar(read_adc(chn_omega1));
                                                	puts(",");
                                                	i+=10;
                                                }

                                                else if(data_perintah[i+10]=='2')
                                                {
                                                	tx_data("data 2 konduktifitas","ANS-2");
                                                	putchar(read_adc(chn_omega2));
                                                	puts(",");
                                                	i+=10;
                                                }

                                                else if(data_perintah[i+10]=='3')
                                                {
                                                	tx_data("data 3 konduktifitas","ANS-3");
                                                	putchar(read_adc(chn_omega3));
                                                	puts(",");
                                                	i+=10;
                                                }
                                        }

                                	else if((data_perintah[i+5]=='N')&&
                                        (data_perintah[i+6]=='O')&&
                                        (data_perintah[i+7]=='W'))
                                        {
                                        	lcd_gotoxy(0,1);
                                                lcd_putsf("kirim data sekarang");
                                                kirim_data_sekarang();
                                                PTT = 0;
                                                delay_ms(5000);
                                                PTT = 1;
                                                delay_ms(500);
                                                kirim_data_sekarang();
                                                PTT = 0;
                                                delay_ms(5000);
                                                PTT = 1;
                                                delay_ms(500);
                                                kirim_data_sekarang();
                                                xcount=0;
                                                i+=7;
                                        }
                                }

                                else if((data_perintah[i+1]=='A')&&
                                (data_perintah[i+2]=='S')&&
                                (data_perintah[i+3]=='K')&&
                                (!sys_mode))
                                {
                                	tx_data("mode sleep","NANS,");
                                        i+=10;
                                }
                        }

                        else if(data_perintah[i]=='#')
                        {
                        	goto esc;
                        }

                }

                esc:

                PTT = 1;
                lcd_clear();
                lcd_putsf("SELESAI");
                delay_ms(100);
                lcd_clear();
                putchar('\n');
                tx_data("","############");
                PTT = 0;
        	banner_sys();
                usart_init();

                goto keluar;
	}
        keluar:
        //#asm("sei")
}

void main(void)
{
	PORTA=0x00;
	DDRA=0x81;
	PORTB=0x00;
	DDRB=0xFF;
	PORTC=0x00;
	DDRC=0x0F;
	PORTD=0xF7;
	DDRD=0x02;

        TCCR1A=0x00;
	TCCR1B=0x05;
	TCNT1H=0xFB;
	TCNT1L=0xF0;
	ICR1H=0x00;
	ICR1L=0x00;
	OCR1AH=0x00;
	OCR1AL=0x00;
	OCR1BH=0x00;
	OCR1BL=0x00;

	TIMSK=0x04;

        data_valid = 0;

	usart_init();
	adc_init();
	lcd_init(16);
        banner_pembuka();
        no_menu = 1;
        last_menu = no_menu;
        switch_to_modem();
        //goto_menu();
        banner_sys();
        //#asm("sei")

	while (1)
      	{
                if(!TOM_ENTER) {no_menu = last_menu; goto_menu();}
                baca_perintah();
      	}
}
