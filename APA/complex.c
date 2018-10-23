/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 6/3/2012
Author  :
Company :
Comments:


Chip type               : ATmega32
Program type            : Application
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 512
*****************************************************/

#include <mega32.h>

#include <delay.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

// Standard Input/Output functions
#include <stdio.h>

#ifndef _ADC_SEL_
	#define _ADC_SEL_
	#define SEL_1	PORTD.2
	#define SEL_2	PORTD.3
	#define SEL_3	PORTD.4
#endif

#ifndef _SEV_SEL_
	#define _SEV_SEL_
        #define SEV_1	PORTB.0
        #define SEV_2	PORTB.1
        #define SEV_3	PORTB.2
        #define SEV_4	PORTB.3

        #define en_1	PORTB.0
	#define en_2 	PORTB.1
	#define en_3	PORTB.2
	#define en_4	PORTB.3

        #define DIG_1	PORTB.4
        #define DIG_2	PORTB.5
        #define DIG_3	PORTB.6
        #define DIG_4	PORTB.7
#endif

#ifndef PTT
#define PTT	PORTA.4
#endif

#ifndef BELL
#define BELL 	PORTC.3
#endif

#ifndef TOM_ENT
#define	TOM_ENT	PINA.6
#endif

#ifndef	TOM_BACK
#define TOM_BACK PINA.5
#endif

#pragma optsize+

unsigned int timebase=0,count=0;

// Timer 0 overflow interrupt service routine
interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
	// Reinitialize Timer 0 value
	TCNT0=0x6A;
	// Place your code here
        count++;
        if(count==10000)
        {
        	count=0;
                timebase++;
        	if(timebase>120) timebase=0;
        }
}

#define ADC_VREF_TYPE 0x20

// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	// Delay needed for the stabilization of the ADC input voltage
	delay_us(10);
	// Start the AD conversion
	ADCSRA|=0x40;
	// Wait for the AD conversion to complete
	while ((ADCSRA & 0x10)==0);
	ADCSRA|=0x10;
	return ADCH;
}


#define OVR 3

#define FRAMING_ERROR (1<<FE)
#define PARITY_ERROR (1<<UPE)
#define DATA_OVERRUN (1<<OVR)
#define DATA_REGISTER_EMPTY (1<<UDRE)
#define RX_COMPLETE (1<<RXC)

// USART Receiver buffer
#define RX_BUFFER_SIZE 8
char rx_buffer[RX_BUFFER_SIZE];

#if RX_BUFFER_SIZE<256
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
   rx_buffer[rx_wr_index]=data;
   if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
   if (++rx_counter == RX_BUFFER_SIZE)
      {
      rx_counter=0;
      rx_buffer_overflow=1;
      };
   };
}

#ifndef _DEBUG_TERMINAL_IO_
// Get a character from the USART Receiver buffer
#define _ALTERNATE_GETCHAR_
#pragma used+
char getchar(void)
{
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

// USART Transmitter buffer
#define TX_BUFFER_SIZE 8
char tx_buffer[TX_BUFFER_SIZE];

#if TX_BUFFER_SIZE<256
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
   UDR=tx_buffer[tx_rd_index];
   if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
   };
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

// Declare your global variables here
void menu(void);
void navi_mode(void);
void mode_manual(void);
void mode_automatis(void);
void run_manual(void);
void run_automatis(void);
void sev_seg(unsigned int value);
void analyzing(void);
void hitung_skor(void);
void clear_sensor(void);
void kirim_to_pc(void);

char lcd[32],
	no_menu=0,
        detik;

unsigned char adc_menu;
unsigned int skor;

unsigned char senbuff[25],
	sen[25];

void menu(void)
{
	lcd_clear();
        for(;;)
        {
        	adc_menu = read_adc(7);
                if(no_menu==0)	{navi_mode();}
                else if(no_menu==1)	{run_manual();}
                else if(no_menu==2)	{run_automatis();}
        }
}

void navi_mode(void)
{
        adc_menu = read_adc(7);
        if(adc_menu < 128)
        {
        	mode_manual();
        }
        else if(adc_menu > 128)
        {
        	mode_automatis();
        }
}

void mode_manual(void)
{
  	lcd_clear();
        lcd_gotoxy(0,0);
        	// 0123456789abcdef
        lcd_putsf("Mode Manual  <==");
      	lcd_gotoxy(0,1);
        lcd_putsf("Mode Automat    ");
        delay_ms(100);
        if(!TOM_ENT)
        {
        	delay_ms(125);
                no_menu = 1;
        }
}

void mode_automatis(void)
{
        lcd_clear();
        lcd_gotoxy(0,0);
        	// 0123456789abcdef
        lcd_putsf("Mode Manual     ");
      	lcd_gotoxy(0,1);
        lcd_putsf("Mode Automat <==");
        delay_ms(100);
        if(!TOM_ENT)
        {
        	delay_ms(125);
                no_menu = 2;
        }
}

void run_manual(void)
{
                lagi:
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("RUN ???");
        lcd_gotoxy(0,1);
        lcd_putsf("ENTER AGAIN..");
        delay_ms(250);
        if(!TOM_ENT)
        {
        	delay_ms(250);
                goto run_manual;
        }
        if(!TOM_BACK)
        {
        	no_menu=0;
        	goto exit;
        }
        	goto lagi;
                run_manual:

       	lcd_clear();
        lcd_putsf("Hitung mundur");

        timebase = 0;
        count=0;

        do
        {
        	detik = 120 - timebase;
                sev_seg(detik);
                lcd_clear();
                sprintf(lcd,"waktu = %d",detik);
                lcd_puts(lcd);
                if(!TOM_ENT) goto keluar;
        }
        while(detik>0);
        keluar:
        sev_seg(0);
        delay_ms(400);

        BELL = 1;
        lcd_clear();
        lcd_putsf("WAKTU HABIS !!");
        delay_ms(4000);
        BELL = 0;

        while(TOM_ENT);
        lcd_clear();
        lcd_putsf("ANALYZING");
        delay_ms(500);

        timebase=0;
        count=0;
        PTT = 1;
        delay_ms(250);
        clear_sensor();

        do
        {
        	detik = 5 - timebase;
                analyzing();
        }

        while(detik>0);

        PTT = 0;
        delay_ms(500);
        hitung_skor();

        lcd_clear();

        lcd_gotoxy(0,0);
        sprintf(lcd,"%d %d %d %d",sen[0],sen[1],sen[2],sen[3]);
        lcd_puts(lcd);
        lcd_gotoxy(0,1);
        sprintf(lcd,"%d %d %d %d",sen[4],sen[5],sen[6],sen[7]);
        lcd_puts(lcd);
        delay_ms(500);

        lcd_clear();
        lcd_gotoxy(0,0);
        sprintf(lcd,"%d %d %d %d",sen[8],sen[9],sen[10],sen[11]);
        lcd_puts(lcd);
        lcd_gotoxy(0,1);
        sprintf(lcd,"%d %d %d %d",sen[12],sen[13],sen[14],sen[15]);
        lcd_puts(lcd);
        delay_ms(500);

        lcd_clear();
        lcd_gotoxy(0,0);
        sprintf(lcd,"%d %d %d %d",sen[16],sen[17],sen[18],sen[19]);
        lcd_puts(lcd);
        lcd_gotoxy(0,1);
        sprintf(lcd,"%d %d %d %d",sen[20],sen[21],sen[22],sen[23]);
        lcd_puts(lcd);
        delay_ms(500);

        lcd_clear();
        lcd_gotoxy(0,0);
        sprintf(lcd,"%d",sen[24]);
        lcd_puts(lcd);
        lcd_gotoxy(0,1);
        sprintf(lcd,"%d",skor);
        lcd_puts(lcd);
        delay_ms(500);

        //kirim_to_pc();

        do
        {
        	sev_seg(skor);
                lcd_clear();
        	lcd_putsf("COMPLETE..!!");
        }
        while(TOM_ENT);

        delay_ms(100);
        no_menu=0;
                exit:
}

void run_automatis(void)
{
		autom:
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("RUN ???");
        lcd_gotoxy(0,1);
        lcd_putsf("ENTER AGAIN..");
        delay_ms(250);
        if(!TOM_ENT)
        {
        	delay_ms(125);
                goto run_autom;
        }
        if(!TOM_BACK)
        {
        	no_menu=0;
        	goto exit;
        }
        	goto autom;
       	run_autom:
        lcd_clear();
        lcd_puts("Wait Command");

        while(getchar()!='a');

        lcd_clear();
        lcd_putsf("Hitung mundur");

        timebase = 0;
        count=0;

        do
        {
        	detik = 120 - timebase;
                sev_seg(detik);
                lcd_clear();
                sprintf(lcd,"waktu = %d",detik);
                lcd_puts(lcd);
                if(!TOM_ENT) goto lanjut;
        }
        while(detik>0);

        BELL = 1;
        lanjut:
        lcd_clear();
        lcd_putsf("WAKTU HABIS !!");
        delay_ms(4000);
        BELL = 0;

        while(getchar()!='b');

        lcd_clear();
        lcd_putsf("ANALYZING");

        timebase=0;
        count=0;
        PTT = 1;
        delay_ms(250);
        clear_sensor();

        do
        {
        	detik = 5 - timebase;
                analyzing();
        }
        while(detik>0);

        PTT = 0;
        delay_ms(500);
        hitung_skor();

        lcd_clear();

        lcd_gotoxy(0,0);
        sprintf(lcd,"%d %d %d %d",sen[0],sen[1],sen[2],sen[3]);
        lcd_gotoxy(0,1);
        sprintf(lcd,"%d %d %d %d",sen[4],sen[5],sen[6],sen[7]);
        delay_ms(300);

        lcd_gotoxy(0,0);
        sprintf(lcd,"%d %d %d %d",sen[8],sen[9],sen[10],sen[11]);
        lcd_gotoxy(0,1);
        sprintf(lcd,"%d %d %d %d",sen[12],sen[13],sen[14],sen[15]);
        delay_ms(300);

        lcd_gotoxy(0,0);
        sprintf(lcd,"%d %d %d %d",sen[16],sen[17],sen[18],sen[19]);
        lcd_gotoxy(0,1);
        sprintf(lcd,"%d %d %d %d",sen[20],sen[21],sen[22],sen[23]);
        delay_ms(300);

        lcd_gotoxy(0,0);
        sprintf(lcd,"%d",sen[24]);
        lcd_gotoxy(0,1);
        sprintf(lcd,"%d",skor);
        delay_ms(300);

        kirim_to_pc();

        do
        {
        	sev_seg(skor);
                lcd_clear();
        	lcd_putsf("COMPLETE..!!");
        }
        while(getchar()!='c');

        goto run_autom;
        exit:
}

void sev_seg(unsigned int value)
{
	char 	ribuan,
        	ratusan,
                puluhan,
                satuan;

        satuan=value%10;
        value/=10;
        puluhan=value%10;
        value/=10;
        ratusan=value%10;
        value/=10;
        ribuan=value%10;

	PORTB = 0;
        en_1 = 1;
        en_2 = 0;
        en_3 = 0;
        en_4 = 0;
        PORTB |= (ribuan << 4);
        delay_ms(5);

        PORTB = 0;
        en_1 = 0;
        en_2 = 1;
        en_3 = 0;
        en_4 = 0;
        PORTB |= (ratusan << 4);
        delay_ms(5);

	PORTB = 0;
        en_1 = 0;
        en_2 = 0;
        en_3 = 1;
        en_4 = 0;
        PORTB |= (puluhan << 4);
        delay_ms(5);

        PORTB = 0;
        en_1 = 0;
        en_2 = 0;
        en_3 = 0;
        en_4 = 1;
        PORTB |= (satuan << 4);
        delay_ms(5);
}

void analyzing(void)
{
	char i;

        SEL_1 = 0;
        SEL_2 = 0;
        SEL_3 = 0;
        delay_ms(10);
        for(i=0;i<3;i++)
        {
        	senbuff[i] = read_adc(i);
                if(senbuff[i]>sen[i]) sen[i]=senbuff[i];
        }

        SEL_1 = 1;
        SEL_2 = 0;
        SEL_3 = 0;
        delay_ms(10);
        for(i=0;i<3;i++)
        {
        	senbuff[i+3] = read_adc(i);
                if(senbuff[i+3]>sen[i+3]) sen[i+3]=senbuff[i+3];
        }

        SEL_1 = 0;
        SEL_2 = 1;
        SEL_3 = 0;
        delay_ms(10);
        for(i=0;i<3;i++)
        {
        	senbuff[i+6] = read_adc(i);
                if(senbuff[i+6]>sen[i+6]) sen[i+6]=senbuff[i+6];
        }

        SEL_1 = 1;
        SEL_2 = 1;
        SEL_3 = 0;
        delay_ms(10);
        for(i=0;i<3;i++)
        {
        	senbuff[i+9] = read_adc(i);
                if(senbuff[i+9]>sen[i+9]) sen[i+9]=senbuff[i+9];
        }

        SEL_1 = 0;
        SEL_2 = 0;
        SEL_3 = 1;
        delay_ms(10);
        for(i=0;i<3;i++)
        {
        	senbuff[i+12] = read_adc(i);
                if(senbuff[i+12]>sen[i+12]) sen[i+12]=senbuff[i+12];
        }

        SEL_1 = 1;
        SEL_2 = 0;
        SEL_3 = 1;
        delay_ms(10);
        for(i=0;i<3;i++)
        {
        	senbuff[i+15] = read_adc(i);
                if(senbuff[i+15]>sen[i+15]) sen[i+15]=senbuff[i+15];
        }

        SEL_1 = 0;
        SEL_2 = 1;
        SEL_3 = 1;
        delay_ms(10);
        for(i=0;i<3;i++)
        {
        	senbuff[i+18] = read_adc(i);
                if(senbuff[i+18]>sen[i+18]) sen[i+18]=senbuff[i+18];
        }

        SEL_1 = 1;
        SEL_2 = 1;
        SEL_3 = 1;
        delay_ms(10);
        for(i=0;i<3;i++)
        {
        	senbuff[i+21] = read_adc(i);
                if(senbuff[i+21]>sen[i+21]) sen[i+21]=senbuff[i+21];
        }

        senbuff[24] = read_adc(3);
        if(senbuff[24]>sen[24]) sen[24]=senbuff[24];
}

void hitung_skor(void)
{
	long skor_temp=0;

        skor_temp = (long)(sen[0]+
        		sen[1]+
                        sen[2]+
                        sen[3]+
                        sen[4]+
                        sen[5]+
                        sen[6]+
                        sen[7]+
                        sen[8]+
                        sen[9]+
                        sen[10]+
                        sen[11]+
                        sen[12]+
                        sen[13]+
                        sen[14]+
                        sen[15]+
                        sen[16]+
                        sen[17]+
                        sen[18]+
                        sen[19]+
                        sen[20]+
                        sen[21]+
                        sen[22]+
                        sen[23]+
                        sen[24]);
        skor_temp*=1000;
        skor_temp/=6375;
        skor=skor_temp;
}

void clear_sensor(void)
{
	char i;

        for(i=0;i<25;i++)
        {
        	sen[i]=0;
        }
}

void kirim_to_pc(void)
{
	char 	ribuan,
        	ratusan,
                puluhan,
                satuan,
                i;

        ribuan = skor/1000;
        ratusan = (skor%1000)/100;
        puluhan = ((skor%1000)%100)/10;
        satuan = ((skor%1000)%100)%10;

        putchar('c');putchar(ribuan+'0');putchar(ratusan+'0');putchar(puluhan+'0');putchar(satuan+'0');
        putchar(13);
        for(i=0;i<25;i++)
        {
        	putchar(sen[i]+'0');
        }
        putchar(13);
}

void main(void)
{
	// Declare your local variables here

	// Input/Output Ports initialization
	// Port A initialization
	// Func7=In Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In
	// State7=T State6=P State5=P State4=0 State3=T State2=T State1=T State0=T
	PORTA=0x60;
	DDRA=0x10;

	// Port B initialization
	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
	PORTB=0x00;
	DDRB=0xFF;

	// Port C initialization
	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
	PORTC=0x00;
	DDRC=0xFF;

	// Port D initialization
	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In
	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=1 State0=P
	PORTD=0x03;
	DDRD=0xFE;

	// Timer/Counter 0 initialization
	// Clock source: System Clock
	// Clock value: 1500.000 kHz
	// Mode: Normal top=0xFF
	// OC0 output: Disconnected
	TCCR0=0x02;
	TCNT0=0x6A;
	OCR0=0x00;

	// Timer(s)/Counter(s) Interrupt(s) initialization
	TIMSK=0x01;

	// USART initialization
	// Communication Parameters: 8 Data, 1 Stop, No Parity
	// USART Receiver: On
	// USART Transmitter: On
	// USART Mode: Asynchronous
	// USART Baud Rate: 9600
	UCSRA=0x00;
	UCSRB=0x18;
	UCSRC=0x86;
	UBRRH=0x00;
	UBRRL=0x4D;

	// Analog Comparator initialization
	// Analog Comparator: Off
	// Analog Comparator Input Capture by Timer/Counter 1: Off
	ACSR=0x80;
	SFIOR=0x00;

	// ADC initialization
	// ADC Clock frequency: 750.000 kHz
	// ADC Voltage Reference: AREF pin
	// Only the 8 most significant bits of
	// the AD conversion result are used
	ADMUX=ADC_VREF_TYPE & 0xff;
	ADCSRA=0x84;

	// Alphanumeric LCD initialization
	// Connections specified in the
	// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
	// RS - PORTC Bit 0
	// RD - PORTC Bit 1
	// EN - PORTC Bit 2
	// D4 - PORTC Bit 4
	// D5 - PORTC Bit 5
	// D6 - PORTC Bit 6
	// D7 - PORTC Bit 7
	// Characters/line: 16
	lcd_init(16);

	// Global enable interrupts
        lcd_clear();
        lcd_putsf("Anten P Analyzer");
	lcd_gotoxy(0,1);
        lcd_putsf(" Techno  Antena ");

        delay_ms(500);

	lcd_clear();
        lcd_putsf(" Teknik  Fisika ");
	lcd_gotoxy(0,1);
        lcd_putsf("    U  G  M    ");

        no_menu=0;

        #asm("sei")

	while (1)
      	{
      		// Place your code here
                //menu();
                PORTB = 0;
                PORTB.4 = 1;
                PORTB.0 = 1;
                delay_ms(1000);
                PORTB.0 = 0;
                PORTB.1 = 1;
                delay_ms(1000);
                PORTB.1 = 0;
                PORTB.2 = 1;
                delay_ms(1000);
                PORTB.2 = 0;
                PORTB.3 = 1;
                delay_ms(1000);
                PORTB.3 = 0;

                PORTB.5 = 1;
                PORTB.0 = 1;
                delay_ms(1000);
                PORTB.0 = 0;
                PORTB.1 = 1;
                delay_ms(1000);
                PORTB.1 = 0;
                PORTB.2 = 1;
                delay_ms(1000);
                PORTB.2 = 0;
                PORTB.3 = 1;
                delay_ms(1000);
                PORTB.3 = 0;

                PORTB.6 = 1;
                PORTB.0 = 1;
                delay_ms(1000);
                PORTB.0 = 0;
                PORTB.1 = 1;
                delay_ms(1000);
                PORTB.1 = 0;
                PORTB.2 = 1;
                delay_ms(1000);
                PORTB.2 = 0;
                PORTB.3 = 1;
                delay_ms(1000);
                PORTB.3 = 0;

                PORTB.7 = 1;
                PORTB.0 = 1;
                delay_ms(1000);
                PORTB.0 = 0;
                PORTB.1 = 1;
                delay_ms(1000);
                PORTB.1 = 0;
                PORTB.2 = 1;
                delay_ms(1000);
                PORTB.2 = 0;
                PORTB.3 = 1;
                delay_ms(1000);
                PORTB.3 = 0;
      	}
}
#pragma optsize-
