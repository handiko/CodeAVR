/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Standard
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project :
Version :
Date    : 6/25/2008
Author  : F4CG
Company : F4CG
Comments: test PID


Chip type           : ATmega16
Program type        : Application
Clock frequency     : 12.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 256
*****************************************************/
// CodeVisionAVR C Compiler
// (C) 1998-2001 Pavel Haiduc, HP InfoTech S.R.L.
// I/O registers definitions for the ATmega16
#pragma used+
sfrb TWBR=0;
sfrb TWSR=1;
sfrb TWAR=2;
sfrb TWDR=3;
sfrb ADCL=4;
sfrb ADCH=5;
sfrw ADCW=4;      // 16 bit access
sfrb ADCSRA=6;
sfrb ADMUX=7;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb SPCR=0xd;
sfrb SPSR=0xe;
sfrb SPDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb PINC=0x13;
sfrb DDRC=0x14;
sfrb PORTC=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEARL=0x1e;
sfrb EEARH=0x1f;
sfrw EEAR=0x1e;   // 16 bit access
sfrb UBRRH=0x20;
sfrb UCSRC=0X20;
sfrb WDTCR=0x21;
sfrb ASSR=0x22;
sfrb OCR2=0x23;
sfrb TCNT2=0x24;
sfrb TCCR2=0x25;
sfrb ICR1L=0x26;
sfrb ICR1H=0x27;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;  // 16 bit access
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;  // 16 bit access
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  // 16 bit access
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb SFIOR=0x30;
sfrb OSCCAL=0x31;
sfrb OCDR=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0=0x33;
sfrb MCUCSR=0x34;
sfrb MCUCR=0x35;
sfrb TWCR=0x36;
sfrb SPMCR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb GIFR=0x3a;
sfrb GICR=0x3b;
sfrb OCR0=0X3c;
sfrb SPL=0x3d;
sfrb SPH=0x3e;
sfrb SREG=0x3f;
#pragma used-
// Interrupt vectors definitions
// CodeVisionAVR C Compiler
// (C) 1998-2000 Pavel Haiduc, HP InfoTech S.R.L.
#pragma used+
void delay_us(unsigned int n);
void delay_ms(unsigned int n);
#pragma used-
// CodeVisionAVR C Compiler
// (C) 1998-2006 Pavel Haiduc, HP InfoTech S.R.L.
// Prototypes for standard I/O functions
// CodeVisionAVR C Compiler
// (C) 1998-2002 Pavel Haiduc, HP InfoTech S.R.L.
// Variable length argument list macros
typedef char *va_list;
#pragma used+
char getchar(void);
void putchar(char c);
void puts(char *str);
void putsf(char flash *str);
char *gets(char *str,unsigned int len);
void printf(char flash *fmtstr,...);
void sprintf(char *str, char flash *fmtstr,...);
void snprintf(char *str, unsigned int size, char flash *fmtstr,...);
void vprintf (char flash * fmtstr, va_list argptr);
void vsprintf (char *str, char flash * fmtstr, va_list argptr);
void vsnprintf (char *str, unsigned int size, char flash * fmtstr, va_list argptr);
signed char scanf(char flash *fmtstr,...);
signed char sscanf(char *str, char flash *fmtstr,...);
                                               #pragma used-
#pragma library stdio.lib
/* LCD driver routines

  CodeVisionAVR C Compiler
  (C) 1998-2003 Pavel Haiduc, HP InfoTech S.R.L.

  BEFORE #include -ING THIS FILE YOU
  MUST DECLARE THE I/O ADDRESS OF THE
  DATA REGISTER OF THE PORT AT WHICH
  THE LCD IS CONNECTED!

  EXAMPLE FOR PORTB:

    #asm
        .equ __lcd_port=0x18
    #endasm
    #include <lcd.h>

*/
#pragma used+
void _lcd_ready(void);
void _lcd_write_data(unsigned char data);
// write a byte to the LCD character generator or display RAM
void lcd_write_byte(unsigned char addr, unsigned char data);
// read a byte from the LCD character generator or display RAM
unsigned char lcd_read_byte(unsigned char addr);
// set the LCD display position  x=0..39 y=0..3
void lcd_gotoxy(unsigned char x, unsigned char y);
// clear the LCD
void lcd_clear(void);
void lcd_putchar(char c);
// write the string str located in SRAM to the LCD
void lcd_puts(char *str);
// write the string str located in FLASH to the LCD
void lcd_putsf(char flash *str);
// initialize the LCD controller
unsigned char lcd_init(unsigned char lcd_columns);
#pragma used-
#pragma library lcd.lib
#asm
   .equ __lcd_port=0x18 ;PORTB
#endasm
char lcd[16];
unsigned char sensor, adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7;
eeprom unsigned char bt7=7,bt6=7,bt5=7,bt4=7,bt3=7,bt2=7,bt1=7,bt0=9;
unsigned char ba7=7,ba6=7,ba5=7,ba4=7,ba3=7,ba2=7,ba1=7,ba0=9;
unsigned char bb7=7,bb6=7,bb5=7,bb4=7,bb3=7,bb2=7,bb1=7,bb0=9;
unsigned char xcount;
bit s0,s1,s2,s3,s4,s5,s6,s7;
int lpwm, rpwm, MAXPWM=255, MINPWM=0, intervalPWM;
typedef unsigned char byte;
int PV, error, last_error, d_error;
int var_Kp, var_Ki, var_Kd;
byte kursorPID, kursorSpeed, kursorGaris;
char lcd_buffer[33];
int b; 
int x;
eeprom byte Kp = 10;
eeprom byte Ki = 5;
eeprom byte Kd = 7;
eeprom byte MAXSpeed = 255;
eeprom byte MINSpeed = 0;
eeprom byte WarnaGaris = 0;     // 1 : putih, 0 : hitam
eeprom byte SensLine = 2;       // banyaknya sensor dlm 1 garis
eeprom byte Skenario = 2;
eeprom byte Mode = 1;
void showMenu();
void displaySensorBit();
void maju();
void mundur();
void bkan();
void bkir();
void rotkan();
void rotkir();
void stop();
void ikuti_garis();
void cek_sensor();
void baca_sensor();
void tune_batas();
void auto_scan();
void pemercepat();
void pelambat();
unsigned char read_adc(unsigned char adc_input)
{
    ADMUX=adc_input | (0x20 & 0xff);
    delay_us(10);       // time sampling
    ADCSRA|=0x40;
    while ((ADCSRA & 0x10)==0);
    ADCSRA|=0x10;
    return ADCH;
}
/*flash byte char0[8]=
{
    0b1100000,
    0b0011000,
    0b0000110,
    0b1111111,
    0b1111111,
    0b0000110,
    0b0011000,
    0b1100000
};/

void define_char(byte flash *pc,byte char_code)
{
        byte i,a;
        a=(char_code<<3) | 0x40;
        for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
}*/
void main(void)
{
        PORTA=0x00;
        DDRA=0x00;
        PORTB=0x00;
        DDRB=0xFF;
        PORTC=0x0F;
        DDRC=0x00;
        PORTD=0x00;
        DDRD=0xFF;
        TIMSK=0x01;
        ACSR=0x80;
        SFIOR=0x00;
        ADMUX=0x20 & 0xff;
        ADCSRA=0x84;
        lcd_init(16);
        TCCR0=0x05;
        stop();
        delay_ms(125);
        lcd_gotoxy(0,0);
                // 0123456789ABCDEF
        lcd_putsf("  baru_belajar  ");
        lcd_gotoxy(0,1);
        lcd_putsf("      by :      ");
        delay_ms(500);
        lcd_clear();
        delay_ms(125);
        lcd_gotoxy(0,0);
                // 0123456789ABCDEF
        lcd_putsf(" ?????????????? ");
        lcd_gotoxy(0,1);
        lcd_putsf(" !!!!!!!!!!!!!! ");
        delay_ms(1300);
        lcd_clear();
        delay_ms(125);
        lcd_gotoxy(0,0);
                // 0123456789ABCDEF
        lcd_putsf("     LPKTA     ");
        lcd_gotoxy(0,1);
        lcd_putsf(" FT - UGM - 11 ");
        delay_ms(500);
        lcd_clear();
        TCCR0=0x05;
        #asm("sei")
        mundur();
        delay_ms(200);
        stop();
        var_Kp  = Kp;
        var_Ki  = Ki;
        var_Kd  = Kd;
        MAXPWM  = (int)MAXSpeed + 1;
        MINPWM  = MINSpeed;
        intervalPWM = (MAXSpeed - MINSpeed) / 8;
        PV = 0;
        error = 0;
        last_error = 0;
        showMenu();
        maju();
        displaySensorBit();
        #asm("sei")
        TIMSK=0x01;
        while (1)
        {
                displaySensorBit();
                //ikuti_garis();
                lpwm = 100;
                rpwm = 100;
                                             PORTD.5 = 0;
                PORTD.4 = 1;
                                PORTD.3 = 1;
                PORTD.2  = 0;
        };
}
void pemercepat()
{
        lpwm=0;
        rpwm=0;
        rotkir();
        for(b=0;b<255;b++)
        {
                delay_ms(125);
                lpwm++;
                rpwm++;
                lcd_clear();
                lcd_gotoxy(0,0);
                sprintf(lcd," %d %d",lpwm,rpwm);
                lcd_puts(lcd);
        }
        lpwm=0;
        rpwm=0;
}
void pelambat()
{
        lpwm=255;
        rpwm=255;
        rotkan();
        for(b=0;b<255;b++)
        {
                delay_ms(125);
                lpwm--;
                rpwm--;
                lcd_clear();
                lcd_gotoxy(0,0);
                sprintf(lcd," %d %d",lpwm,rpwm);
                lcd_puts(lcd);
        }
        lpwm=0;
        rpwm=0;
}
void baca_sensor()
{
        sensor=0;
        adc0=read_adc(0);
        adc1=read_adc(1);
        adc2=read_adc(2);
        adc3=read_adc(3);
        adc4=read_adc(4);
        adc5=read_adc(5);
        adc6=read_adc(6);
        adc7=read_adc(7);
        if(adc0>bt0){s0=1;sensor=sensor|1<<0;}
        else {s0=0;sensor=sensor|0<<0;}
        if(adc1>bt1){s1=1;sensor=sensor|1<<1;}
        else {s1=0;sensor=sensor|0<<1;}
        if(adc2>bt2){s2=1;sensor=sensor|1<<2;}
        else {s2=0;sensor=sensor|0<<2;}
        if(adc3>bt3){s3=1;sensor=sensor|1<<3;}
        else {s3=0;sensor=sensor|0<<3;}
        if(adc4>bt4){s4=1;sensor=sensor|1<<4;}
        else {s4=0;sensor=sensor|0<<4;}
        if(adc5>bt5){s5=1;sensor=sensor|1<<5;}
        else {s5=0;sensor=sensor|0<<5;}
        if(adc6>bt6){s6=1;sensor=sensor|1<<6;}
        else {s6=0;sensor=sensor|0<<6;}
        if(adc7>bt7){s7=1;sensor=sensor|1<<7;}
        else {s7=0;sensor=sensor|0<<7;}
}
void tampil(unsigned char dat)
{
    unsigned char data;
    data = dat / 100;
    data+=0x30;
    lcd_putchar(data);
    dat%=100;
    data = dat / 10;
    data+=0x30;
    lcd_putchar(data);
    dat%=10;
    data = dat + 0x30;
    lcd_putchar(data);
}
void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom )
{
        lcd_gotoxy(0,0);
        lcd_putsf("Tulis ke EEPROM ");
        lcd_putsf("...             ");
        switch (NoMenu)
        { 
          case 1: // PID
                switch (NoSubMenu)
                {
                  case 1: // Kp
                        Kp = var_in_eeprom;
                        break;
                  case 2: // Ki
                        Ki = var_in_eeprom;
                        break;
                  case 3: // Kd
                        Kd = var_in_eeprom;
                        break;
                }
                break;
          case 2: // Speed
                switch (NoSubMenu)
                {
                  case 1: // MAX
                        MAXSpeed = var_in_eeprom;
                        break;
                  case 2: // MIN
                        MINSpeed = var_in_eeprom;
                        break;
                }
                break;
          case 3: // Warna Garis
                switch (NoSubMenu)
                {
                  case 1: // Warna
                        WarnaGaris = var_in_eeprom;
                        break;
                  case 2: // SensL
                        SensLine = var_in_eeprom;
                        break;
                }
                break;
          case 4: // Skenario
                Skenario = var_in_eeprom;
                break;
        }
        delay_ms(500);
}
void setByte( byte NoMenu, byte NoSubMenu )
{
        byte var_in_eeprom;
        byte plus5 = 0;
        char limitPilih = -1;
        lcd_clear();
        lcd_gotoxy(0, 0);
        switch (NoMenu)
        {
          case 1: // PID
                switch (NoSubMenu)
                {
                  case 1: // Kp
                        lcd_putsf("Set Kp :        ");
                        var_in_eeprom = Kp;
                        break;
                  case 2: // Ki
                        lcd_putsf("Set Ki :        ");
                        var_in_eeprom = Ki;
                        break;
                  case 3: // Kd
                        lcd_putsf("Set Kd :        ");
                        var_in_eeprom = Kd;
                        break;
                }
                break;
          case 2: // Speed
                plus5 = 1;
                switch (NoSubMenu)
                {
                  case 1: // MAX
                        lcd_putsf("Set MAX Speed : ");
                        var_in_eeprom = MAXSpeed;
                        break;
                  case 2: // MIN
                        lcd_putsf("Set MIN Speed : ");
                        var_in_eeprom = MINSpeed;
                        break;
                }
                break;
          case 3: // Warna Garis
                switch (NoSubMenu)
                {
                  case 1: // Warna
                        limitPilih = 1;
                        lcd_putsf("Warna Garis   : ");
                        var_in_eeprom = WarnaGaris;
                        break;
                  case 2: // SensL
                        limitPilih = 3;
                        lcd_putsf("SensLine :      ");
                        var_in_eeprom = SensLine;
                        break;
                }
                break;
          case 4: // Skenario
                  lcd_putsf("Skenario :      ");
                  var_in_eeprom = Skenario;
                  limitPilih = 8;
                  break;
        }
        while (PINC.1)
        {
                delay_ms(250);
                lcd_gotoxy(0, 1);
                tampil(var_in_eeprom);
                if (!PINC.0)
                {
                        lcd_clear();
                        tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
                        goto exitSetByte;
                }
                if (!PINC.3)
                {
                        if ( plus5 )
                                if ( var_in_eeprom == 0 )
                                        var_in_eeprom = 255;
                                else
                                        var_in_eeprom -= 5;
                        else
                                if ( !limitPilih )
                                        var_in_eeprom--;
                                else
                                {
                                        if ( var_in_eeprom == 0 )
                                          var_in_eeprom = limitPilih;
                                        else
                                          var_in_eeprom--;
                                }
                }
                if (!PINC.2)
                {
                        if ( plus5 )
                                if ( var_in_eeprom == 255 )
                                        var_in_eeprom = 0;
                                else
                                        var_in_eeprom += 5;
                        else
                                if ( !limitPilih )
                                        var_in_eeprom++;
                                else
                                {
                                        if ( var_in_eeprom == limitPilih )
                                          var_in_eeprom = 0;
                                        else
                                          var_in_eeprom++;
                                }
                }
        }
      exitSetByte:
        delay_ms(100);
        lcd_clear();
}
void showMenu()
{
        //TIMSK = 0x00;
        //#asm("cli")
        lcd_clear();
    menu01:
        delay_ms(225);   // bouncing sw
        lcd_gotoxy(0,0);
                // 0123456789abcdef
        lcd_putsf("  Set PID       ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Set Speed     ");
        // kursor awal
        lcd_gotoxy(0,0);
        lcd_putchar(0);
        if (!PINC.0)
        {
                delay_ms(225);
                lcd_clear();
                kursorPID = 1;
                goto setPID;
        }
        if (!PINC.3)
        {
                delay_ms(225);
                goto menu02;
        }
        if (!PINC.2)
        {
                delay_ms(225);
                lcd_clear();
                goto menu06;
        }
        goto menu01;
    menu02:
        delay_ms(225);
        lcd_gotoxy(0,0);
                 // 0123456789abcdef
        lcd_putsf("  Set PID       ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Set Speed     ");
        lcd_gotoxy(0,1);
        lcd_putchar(0);
        if (!PINC.0)
        {
                delay_ms(225);
                lcd_clear();
                kursorSpeed = 1;
                goto setSpeed;
        }
        if (!PINC.2)
        {
                delay_ms(225);
                goto menu01;
        }
        if (!PINC.3)
        {
                delay_ms(225);
                lcd_clear();
                goto menu03;
        }
        goto menu02;
    menu03:
        delay_ms(225);
        lcd_gotoxy(0,0);
                // 0123456789abcdef
        lcd_putsf("  Set Garis     ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Skenario      ");
        lcd_gotoxy(0,0);
        lcd_putchar(0);
        if (!PINC.0)
        {
                delay_ms(225);
                lcd_clear();
                kursorGaris = 1;
                goto setGaris;
        }
        if (!PINC.2)
        {
                delay_ms(225);
                lcd_clear();
                goto menu02;
        }
        if (!PINC.3)
        {
                delay_ms(225);
                goto menu04;
        }
        goto menu03;
    menu04:
        delay_ms(225);
        lcd_gotoxy(0,0);
                // 0123456789abcdef
        lcd_putsf("  Set Garis     ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Skenario      ");
        lcd_gotoxy(0,1);
        lcd_putchar(0);
        if (!PINC.0)
        {
                delay_ms(225);
                lcd_clear();
                goto setSkenario;
        }
        if (!PINC.2)
        {
                delay_ms(225);
                goto menu03;
        }
        if (!PINC.3)
        {
                delay_ms(225);
                lcd_clear();
                goto menu05;
        }
        goto menu04;
    menu05:            // Bikin sendiri lhoo ^^d
        delay_ms(225);
        lcd_gotoxy(0,0);
        lcd_putsf("  Set Mode         ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Start!!      ");
        lcd_gotoxy(0,0);
        lcd_putchar(0);
        if  (!PINC.0)
        {
            delay_ms(225);
            lcd_clear();
            goto mode;
        }
        if  (!PINC.2)
        {
            delay_ms(225);
            lcd_clear();
            goto menu04;
        }
        if  (!PINC.3)
        {
            delay_ms(225);
            goto menu06;
        }
        goto menu05;
    menu06:
        delay_ms(225);
        lcd_gotoxy(0,0);
        lcd_putsf("  Set Mode         ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Start!!      ");
        lcd_gotoxy(0,1);
        lcd_putchar(0);
        if (!PINC.0)
        {
                delay_ms(225);
                lcd_clear();
                goto startRobot;
        }
        if (!PINC.2)
        {
                delay_ms(225);
                goto menu05;
        }
        if (!PINC.3)
        {
                delay_ms(225);
                lcd_clear();
                goto menu01;
        }
        goto menu06;
    setPID:
        delay_ms(225);
        lcd_gotoxy(0,0);
                // 0123456789ABCDEF
        lcd_putsf("  Kp   Ki   Kd  ");
        // lcd_putsf(" 250  200  300  ");
        lcd_putchar(' ');
        tampil(Kp); lcd_putchar(' '); lcd_putchar(' ');
        tampil(Ki); lcd_putchar(' '); lcd_putchar(' ');
        tampil(Kd); lcd_putchar(' '); lcd_putchar(' ');
        switch (kursorPID)
        {
          case 1:
                lcd_gotoxy(1,0); // kursor Kp
                lcd_putchar(0);
                break;
          case 2:
                lcd_gotoxy(6,0); // kursor Ki
                lcd_putchar(0);
                break;
          case 3:
                lcd_gotoxy(11,0); // kursor Kd
                lcd_putchar(0);
                break;
        }
        if (!PINC.0)
        {
                delay_ms(225);
                setByte( 1, kursorPID);
                delay_ms(200);
        }
        if (!PINC.2)
        {
                delay_ms(225);
                if (kursorPID == 3) {
                        kursorPID = 1;
                } else kursorPID++;
        }
        if (!PINC.3)
        {
                delay_ms(225);
                if (kursorPID == 1) {
                        kursorPID = 3;
                } else kursorPID--;
        }
        if (!PINC.1)
        {
                delay_ms(225);
                lcd_clear();
                goto menu01;
        }
        goto setPID;
    setSpeed:
        delay_ms(225);
        lcd_gotoxy(0,0);
                // 0123456789ABCDEF
        lcd_putsf("   MAX    MIN   ");
        lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
        //lcd_putsf("   250    200   ");
        tampil(MAXSpeed);
        lcd_putchar(' '); lcd_putchar(' ');lcd_putchar(' '); lcd_putchar(' ');
        tampil(MINSpeed);
        lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
        switch (kursorSpeed)
        {
          case 1:
                lcd_gotoxy(2,0); // kursor MAX
                lcd_putchar(0);
                break;
          case 2:
                lcd_gotoxy(9,0); // kursor MIN
                lcd_putchar(0);
                break;
        }
        if (!PINC.0)
        {
                delay_ms(225);
                setByte( 2, kursorSpeed);
                delay_ms(200);
        }
        if (!PINC.2)
        {
                delay_ms(225);
                if (kursorSpeed == 2)
                {
                        kursorSpeed = 1;
                } else kursorSpeed++;
        }
        if (!PINC.3)
        {
                delay_ms(225);
                if (kursorSpeed == 1)
                {
                        kursorSpeed = 2;
                } else kursorSpeed--;
        }
        if (!PINC.1)
        {
                delay_ms(225);
                lcd_clear();
                goto menu02;
        }
        goto setSpeed;
     setGaris: // not yet
        delay_ms(225);
        lcd_gotoxy(0,0);
                // 0123456789ABCDEF
        if ( WarnaGaris == 1 )
                lcd_putsf("  WARNA : Putih ");
        else
                lcd_putsf("  WARNA : Hitam ");
        //lcd_putsf("  LEBAR: 1.5 cm ");
        lcd_gotoxy(0,1);
        lcd_putsf("  SensL :        ");
        lcd_gotoxy(10,1);
        tampil( SensLine );
        switch (kursorGaris)
        {
          case 1:
                lcd_gotoxy(0,0); // kursor Warna
                lcd_putchar(0);
                break;
          case 2:
                lcd_gotoxy(0,1); // kursor SensL
                lcd_putchar(0);
                break;
        }
        if (!PINC.0)
        {
                delay_ms(225);
                setByte( 3, kursorGaris);
                delay_ms(200);
        }
        if (!PINC.2)
        {
                delay_ms(225);
                if (kursorGaris == 2)
                {
                        kursorGaris = 1;
                } else kursorGaris++;
        }
        if (!PINC.3)
        {
                delay_ms(225);
                if (kursorGaris == 1)
                {
                        kursorGaris = 2;
                } else kursorGaris--;
        }
        if (!PINC.1)
        {
                delay_ms(225);
                lcd_clear();
                goto menu03;
        }
        goto setGaris;
     setSkenario:
        delay_ms(225);
        lcd_gotoxy(0,0);
                // 0123456789ABCDEF
        lcd_putsf("Sken. yg  dpake:");
        lcd_gotoxy(0, 1);
        tampil( Skenario );
        if (!PINC.0)
        {
                delay_ms(225);
                setByte( 4, 0);
                delay_ms(200);
        }
        if (!PINC.1)
        {
                delay_ms(225);
                lcd_clear();
                goto menu04;
        }
        goto setSkenario;
     mode:
        delay_ms(125);
        if  (!PINC.2)
        {
            delay_ms(225);
            if (Mode==6)
            {
                Mode=1;
            }
            else Mode++;
            goto nomorMode;
        }
        if  (!PINC.3)
        {
            delay_ms(225);
            if  (Mode==1)
            {
                Mode=6;
            }
            else Mode--;
            goto nomorMode;
        }
        nomorMode:
            if (Mode==1)
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf(" Mode :         ");
                lcd_gotoxy(0,1);
                lcd_putsf(" 1.Lihat ADC");
            }
            if  (Mode==2)
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf(" Mode :         ");
                lcd_gotoxy(0,1);
                lcd_putsf(" 2.Test Mode");
            }
            if  (Mode==3)
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf(" Mode :         ");
                lcd_gotoxy(0,1);
                lcd_putsf(" 3.Cek Sensor ");
            }
            if  (Mode==4)
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf(" Mode :         ");
                lcd_gotoxy(0,1);
                lcd_putsf(" 4.Auto Tune 1-1");
            }
             if  (Mode==5)
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf(" Mode :         ");
                lcd_gotoxy(0,1);
                lcd_putsf(" 5.Auto Tune ");
            }
            if  (Mode==6)
            {
                lcd_clear();
                lcd_gotoxy(0,0);
                lcd_putsf(" Mode :         ");
                lcd_gotoxy(0,1);
                lcd_putsf(" 6.Cek PWM Aktif");
            }
        if  (!PINC.0)
        {
            delay_ms(225);
            switch  (Mode)
            {
                case 1:
                {
                    for(;;)
                    {
                        lcd_gotoxy(2,0);
                        sprintf(lcd,"  %d %d %d %d",read_adc(3),read_adc(2),read_adc(1),read_adc(0));
                        lcd_puts(lcd);
                        lcd_gotoxy(1,1);
                        sprintf(lcd,"%d %d %d %d",read_adc(7),read_adc(6),read_adc(5),read_adc(4));
                        lcd_puts(lcd);
                        delay_ms(100);
                        lcd_clear();
                    }
                }
                break;
                case 2:
                {
                    cek_sensor();
                }
                break;
                case 3:
                {
                    cek_sensor();
                }
                break;
                case 4:
                {
                    tune_batas();
                }
                break;
                case 5:
                {
                    auto_scan();
                    goto menu01;
                }
                break;
                case 6:
                {
                    pemercepat();
                    pelambat();
                    goto menu01;
                }
                break;
            }
        }
        if  (!PINC.1)
        {
            lcd_clear();
            goto menu05;
        }
        goto mode;
     startRobot:
        //TIMSK = 0x01; 
        //#asm("sei")
        lcd_clear();
}
void displaySensorBit()
{
    baca_sensor();
    lcd_gotoxy(2,1);
    if (s7) lcd_putchar('1');
    else    lcd_putchar('0');
    if (s6) lcd_putchar('1');
    else    lcd_putchar('0');
    if (s5) lcd_putchar('1');
    else    lcd_putchar('0');
    if (s4) lcd_putchar('1');
    else    lcd_putchar('0');
    if (s3) lcd_putchar('1');
    else    lcd_putchar('0');
    if (s2) lcd_putchar('1');
    else    lcd_putchar('0');
    if (s1) lcd_putchar('1');
    else    lcd_putchar('0');
    if (s0) lcd_putchar('1');
    else    lcd_putchar('0');
}
interrupt [10] void timer0_ovf_isr(void)
{
        xcount++;
        if(xcount<=lpwm)PORTD.7=1; // PORTC.1 = 1;
        else PORTD.7=0;  // PORTC.1 = 0;
        if(xcount<=rpwm)PORTD.6=1;
        else PORTD.6=0;
        TCNT0=0xFF;
}
void maju(){PORTD.3=1;PORTD.2=0;PORTD.5=1;PORTD.4=0;}
void mundur(){PORTD.3=0;PORTD.2=1;PORTD.5=0;PORTD.4=1;}
void bkan(){PORTD.3=0;PORTD.2=0;PORTD.5=1;PORTD.4=0;}
void bkir(){PORTD.3=1;PORTD.2=0;PORTD.5=0;PORTD.4=0;}
void rotkan(){PORTD.3=0;PORTD.2=1;PORTD.5=1;PORTD.4=0;}
void rotkir(){PORTD.3=1;PORTD.2=0;PORTD.5=0;PORTD.4=1;}
void stop(){ PORTD.3=0;PORTD.2=0;PORTD.5=0;PORTD.4=0; }
void cek_sensor()      
{
        int t;
        baca_sensor();
        lcd_clear();
        delay_ms(125);
                // wait 125ms
        lcd_gotoxy(0,0);
                //0123456789abcdef
        lcd_putsf(" Test:Sensor    ");
        for (t=0; t<30000; t++) {displaySensorBit();}
}
void tune_batas()
{
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf(" Cek Memory ?");
    lcd_gotoxy(0,1);
    lcd_putsf(" Y / N ");
    for(;;)
    {   
        if(!PINC.0)
        {
                delay_ms(200);
                lcd_clear();
                lcd_gotoxy(0,0);
                sprintf(lcd," %d %d %d %d %d %d %d %d",bt0, bt1, bt2, bt3, bt4, bt5, bt6, bt7);
                lcd_puts(lcd);
                delay_ms(2000);
        }
                if(!PINC.1)
        {
                break;
        }
    }
    for(;;)
    {
        read_adc(0);
        if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
        if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
        bt0=((bb0+ba0)/2);
        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb0  ba0  bt0");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb0,ba0,bt0);
        lcd_puts(lcd);
        delay_ms(50);
        if(!PINC.0)
        {
            delay_ms(125);
            goto sensor1;
        }
    }
    sensor1:
    for(;;)
    {
        read_adc(1);
        if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
        if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
        bt1=((bb1+ba1)/2);
        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb1  ba1  bt1");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb1,ba1,bt1);
        lcd_puts(lcd);
        delay_ms(50);
        if(!PINC.0)
        {
            delay_ms(150);
            goto sensor2;
        }
    }
    sensor2:
    for(;;)
    {
        read_adc(2);
        if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
        if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
        bt2=((bb2+ba2)/2);
        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb2  ba2  bt2");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb2,ba2,bt2);
        lcd_puts(lcd);
        delay_ms(10);
        if(!PINC.0)
        {
            delay_ms(150);
            goto sensor3;
        }
    }
    sensor3:
    for(;;)
    {
        read_adc(3);
        if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
        if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
        bt3=((bb3+ba3)/2);
        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb3  ba3  bt3");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb3,ba3,bt3);
        lcd_puts(lcd);
        delay_ms(10);
        if(!PINC.0)
        {
            delay_ms(150);
            goto sensor4;
        }
    }
    sensor4:
    for(;;)
    {
        read_adc(4);
        if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
        if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
        bt4=((bb4+ba4)/2);
        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb4  ba4  bt4");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb4,ba4,bt4);
        lcd_puts(lcd);
        delay_ms(10);
        if(!PINC.0)
        {
            delay_ms(150);
            goto sensor5;
        }
    }
    sensor5:
    for(;;)
    {
        read_adc(5);
        if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
        if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
        bt5=((bb5+ba5)/2);
        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb5  ba5  bt5");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb5,ba5,bt5);
        lcd_puts(lcd);
        delay_ms(10);
        if(!PINC.0)
        {
            delay_ms(150);
            goto sensor6;
        }
    }
    sensor6:
    for(;;)
    {
        read_adc(06);
        if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
        if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
        bt6=((bb6+ba6)/2);
        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb6  ba6  bt6");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb6,ba6,bt6);
        lcd_puts(lcd);
        delay_ms(10);
        if(!PINC.0)
        {
            delay_ms(150);
            goto sensor7;
        }
    }
    sensor7:
    for(;;)
    {
        read_adc(7);
        if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
        if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
        bt7=((bb7+ba7)/2);
        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb7  ba7  bt7");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb7,ba7,bt7);
        lcd_puts(lcd);
        delay_ms(10);
        if(!PINC.0)
        {
            delay_ms(150);
            goto selesai;
        }
    }
    selesai:
    lcd_clear();
}
void auto_scan()
{
    for(;;)
    {
    read_adc(0);
        if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
        if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
        bt0=((bb0+ba0)/2);
    read_adc(1);
        if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
        if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
        bt1=((bb1+ba1)/2);
    read_adc(2);
        if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
        if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
        bt2=((bb2+ba2)/2);
    read_adc(3);
        if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
        if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
        bt3=((bb3+ba3)/2);
    read_adc(4);
        if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
        if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
        bt4=((bb4+ba4)/2);
    read_adc(5);
        if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
        if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
        bt5=((bb5+ba5)/2);
    read_adc(6);
        if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
        if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
        bt6=((bb6+ba6)/2);
    read_adc(7);
        if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
        if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
        bt7=((bb7+ba7)/2);
        lcd_clear();
        lcd_gotoxy(1,0);
        sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
        lcd_puts(lcd);
        delay_ms(120);
        if (!PINC.0)
        {
                //showMenu();
                lcd_clear();
                lcd_gotoxy(1,0);
                sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
                lcd_puts(lcd);
        }
    }
}
void ikuti_garis()
{
        baca_sensor();
        if((sensor==0b00000001) || (0b11111110)){bkan();      error = 15;     x=1;}  //kanan
        if((sensor==0b00000011) || (0b11111100)){maju();      error = 10;     x=1;}
        if((sensor==0b00000010) || (0b11111101)){maju();      error = 8;      x=1;}
        if((sensor==0b00000110) || (0b11111001)){maju();      error = 5;      x=1;}
        if((sensor==0b00000100) || (0b11111011)){maju();      error = 3;      x=1;}
        if((sensor==0b00001100) || (0b11110011)){maju();      error = 2;      x=1;}
        if((sensor==0b00001000) || (0b11110111)){maju();      error = 1;      x=1;}
        if((sensor==0b00010000) || (0b11101111)){maju();      error = -1;     x=0;}
        if((sensor==0b00110000) || (0b11001111)){maju();      error = -2;     x=0;}
        if((sensor==0b00100000) || (0b11011111)){maju();      error = -3;     x=0;}
        if((sensor==0b01100000) || (0b1001111)){maju();      error = -5;     x=0;}
        if((sensor==0b01000000) || (0b10111111)){maju();      error = -8;     x=0;}
        if((sensor==0b11000000) || (0b00111111)){maju();      error = -10;    x=0;}
        if((sensor==0b10000000) || (0b01111111)){bkir();      error = -15;    x=0;}  //kiri
                if(
                (sensor==0b10000001) || 
                (sensor==0b11000011) || 
                (sensor==0b01000010)
                ||
                (sensor==0b01111110) || 
                (sensor==0b00111100) || 
                (sensor==0b10111101))
                {       
                        bkir(); 
                        error = -20;
                } 
            d_error = error-last_error;
        PV      = (Kp*error)+(Kd*d_error);
        rpwm=intervalPWM+PV;
        lpwm=intervalPWM-PV;
        last_error=error;
        if(lpwm>=255)       lpwm = 255;
        if(lpwm<=0)         lpwm = 0;
            if(rpwm>=255)       rpwm = 255;
        if(rpwm<=0)         rpwm = 0;
        sprintf(lcd_buffer,"%d   %d",lpwm, rpwm);
        lcd_gotoxy(0, 0);
        //lcd_putsf("                ");
        //lcd_gotoxy(0, 0);
        lcd_puts(lcd_buffer);
        delay_ms(5);
}  
