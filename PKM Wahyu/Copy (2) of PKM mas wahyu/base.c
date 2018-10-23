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
#include <delay.h>
#include <alcd.h>
#include <stdio.h>

char eeprom data_rx[1000];

void tampil_lcd(void)
{
      	char i;
        for(i=0;;i++)
        {
                if(data_rx[i]=='#') goto out;
                if(data_rx[i]==',') {delay_ms(500);lcd_clear();}
                lcd_putchar(data_rx[i]);
        }
        out:
}

void terima_data(void)
{
	char i,c_buff;
        while(getchar()!='$');
        while(getchar()=='$');
        for(i=0;;i++)
        {
        	c_buff = getchar();
                data_rx[i]=c_buff;
                if(data_rx[i]=='#') goto out;
        }
        out:
}

void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out
// State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=0
PORTA=0x00;
DDRA=0x81;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTB=0x00;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
// State7=P State6=P State5=P State4=P State3=T State2=T State1=1 State0=P
PORTD=0xF3;
DDRD=0x02;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=0xFF
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer1 Stopped
// Mode: Normal top=0xFFFF
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0x00;
TCCR1B=0x00;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// Timer/Counter 2 initialization
// Clock source: System Clock
// Clock value: Timer2 Stopped
// Mode: Normal top=0xFF
// OC2 output: Disconnected
ASSR=0x00;
TCCR2=0x00;
TCNT2=0x00;
OCR2=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// INT2: Off
MCUCR=0x00;
MCUCSR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x00;

// USART initialization
// Communication Parameters: 8 Data, 1 Stop, No Parity
// USART Receiver: On
// USART Transmitter: On
// USART Mode: Asynchronous
// USART Baud Rate: 1200
UCSRA=0x00;
UCSRB=0x18;
UCSRC=0x86;
UBRRH=0x02;
UBRRL=0x3F;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC disabled
ADCSRA=0x00;

// SPI initialization
// SPI disabled
SPCR=0x00;

// TWI initialization
// TWI disabled
TWCR=0x00;

// Alphanumeric LCD initialization
// Connections specified in the
// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
// RS - PORTB Bit 0
// RD - PORTB Bit 1
// EN - PORTB Bit 2
// D4 - PORTB Bit 4
// D5 - PORTB Bit 5
// D6 - PORTB Bit 6
// D7 - PORTB Bit 7
// Characters/line: 16
lcd_init(16);
delay_ms(2000);
delay_ms(4000);
while (1)
      	{
        	lcd_clear();
                lcd_putsf("kirim perintah");
                delay_ms(500);
                PORTA.0 = 1;
                PORTD.1 = 1;
                delay_ms(300);
                putsf("$$$$$$TEL,SET-WAKE,ASK-OMEGA2,ASK-ID,ASK,OMEGA3,SAD-T,ASK-OMEGA1,SET-SLEEP####");
                lcd_clear();
                lcd_putsf("menunggu data diterima.............");
                PORTA.0 = 0;
                terima_data();
                lcd_clear();
                lcd_putsf("DATA DARI STASIUN TELE");
                delay_ms(500);
                lcd_clear();
                tampil_lcd();
                delay_ms(3000);

                lcd_clear();
                lcd_putsf("kirim perintah");
                delay_ms(500);
                PORTA.0 = 1;
                PORTD.1 = 1;
                delay_ms(300);
                putsf("$$$$$$TEL,ASK-STAT,ASK-OMEGA2,ASK-ID,ASK-OMEGA3,SAD-T,ASK-OMEGA1,SET-WAKE####");
                lcd_clear();
                lcd_putsf("menunggu data diterima.............");
                PORTA.0 = 0;
                terima_data();
                lcd_clear();
                lcd_putsf("DATA DARI STASIUN TELE");
                delay_ms(500);
                lcd_clear();
                tampil_lcd();
                delay_ms(3000);

                lcd_clear();
                lcd_putsf("kirim perintah");
                delay_ms(500);
                PORTA.0 = 1;
                PORTD.1 = 1;
                delay_ms(300);
                putsf("$$$$$$TEL,ASK-STAT,SAD-T,SET-WAKE,ASK-ID,ASK-STAT,ASK-OMEGA1,ASK-OMEGA2,ASK-OMEGA3,SET-SLEEP####");
                lcd_clear();
                lcd_putsf("menunggu data diterima.............");
                PORTA.0 = 0;
                terima_data();
                lcd_clear();
                lcd_putsf("DATA DARI STASIUN TELE");
                delay_ms(500);
                lcd_clear();
                tampil_lcd();
                delay_ms(3000);

                lcd_clear();
                lcd_putsf("kirim perintah");
                delay_ms(500);
                PORTA.0 = 1;
                PORTD.1 = 1;
                delay_ms(300);
                putsf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$##################################");
                lcd_clear();
                lcd_putsf("menunggu data diterima.............");
                PORTA.0 = 0;
                terima_data();
                lcd_clear();
                lcd_putsf("DATA DARI STASIUN TELE");
                delay_ms(500);
                lcd_clear();
                tampil_lcd();
                delay_ms(3000);

                lcd_clear();
                lcd_putsf("kirim perintah");
                delay_ms(500);
                PORTA.0 = 1;
                PORTD.1 = 1;
                delay_ms(300);
                putsf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$##################################");
                lcd_clear();
                lcd_putsf("menunggu data diterima.............");
                PORTA.0 = 0;
                terima_data();
                lcd_clear();
                lcd_putsf("DATA DARI STASIUN TELE");
                delay_ms(500);
                lcd_clear();
                tampil_lcd();
                delay_ms(3000);

                lcd_clear();
                lcd_putsf("kirim perintah");
                delay_ms(500);
                PORTA.0 = 1;
                PORTD.1 = 1;
                delay_ms(300);
                putsf("$$$$$$TEL,SET-WAKE,AFxK-NOW#####");
                lcd_clear();
                lcd_putsf("menunggu data diterima.............");
                PORTA.0 = 0;
                terima_data();
                lcd_clear();
                lcd_putsf("DATA DARI STASIUN TELE");
                delay_ms(500);
                lcd_clear();
                tampil_lcd();
                delay_ms(3000);

                lcd_clear();
                lcd_putsf("kirim perintah");
                delay_ms(500);
                PORTA.0 = 1;
                PORTD.1 = 1;
                delay_ms(300);
                putsf("$$$$$$$$$$$$$$$$$$$$$$$$$$$############");
                lcd_clear();
                lcd_putsf("menunggu data diterima.............");
                PORTA.0 = 0;
                terima_data();
                lcd_clear();
                lcd_putsf("DATA DARI STASIUN TELE");
                delay_ms(500);
                lcd_clear();
                tampil_lcd();
                delay_ms(3000);
      	}
}
