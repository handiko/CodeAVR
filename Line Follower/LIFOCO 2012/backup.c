/*****************************************************
This program was produced by the
CodeWizardAVR V2.05.0 Professional
Automatic Program Generator
� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : Line Follower Micro - Liffoco 2012
Version : v1.0
Date    : 12/6/2012
Author  : Handiko Gesang
Company : Lab. STTK
Comments: Lalalalalalalala


Chip type               : ATmega16
Program type            : Application
AVR Core Clock frequency: 12.000000 MHz
Memory model            : Small
External RAM size       : 0
Data Stack size         : 256
*****************************************************/

#include <mega32.h>
#include <stdio.h>
#include <delay.h>

// Alphanumeric LCD Module functions
#include <alcd.h>

#define ADC_VREF_TYPE 0x20

#define sw_up           PIND.4
#define sw_down         PIND.6
#define sw_ok           PIND.5
#define sw_cancel       PIND.3

#define backlight       PORTB.3

//#define sKa     PINC.0
//#define sKi     PINC.1

#define Enki    PORTC.2
#define kirplus PORTC.3
#define kirmin  PORTC.4
#define Enka    PORTC.5
#define kaplus  PORTC.7
#define kamin   PORTC.6 

bit s0,s1,s2,s3,s4,s5,s6,s7,sKa,sKi;
char lcd[32];                                  
//char diffPWM = 10;
unsigned char kursorPID, kursorSpeed, kursorGaris; 
unsigned char sensor, adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7;
unsigned char xcount;
unsigned char SP = 0;
int lpwm, rpwm, MAXPWM, MINPWM, _MINPWM, intervalPWM; 
int MV, P, I, D, PV, error, last_error, rate;
int var_Kp, var_Ki, var_Kd;

eeprom unsigned char Kp = 17; //33 
eeprom unsigned char Ki = 0;
eeprom unsigned char Kd = 11; //16
eeprom unsigned char tempKp = 17; //33 
eeprom unsigned char tempKi = 0;
eeprom unsigned char tempKd = 11; //16 
eeprom unsigned char MAXSpeed = 255;
eeprom unsigned char MINSpeed = 115;
eeprom unsigned char WarnaGaris = 1; // 1 : putih; 0 : hitam
eeprom unsigned char SensLine = 2; // banyaknya sensor dlm 1 garis
eeprom unsigned char Skenario = 2; 
eeprom unsigned char Mode = 1; 
eeprom unsigned char NoStrategi = 1;                         
eeprom unsigned char bt7=7,bt6=7,bt5=7,bt4=7,bt3=7,bt2=7,bt1=7,bt0=7;
eeprom unsigned char ba7=7,ba6=7,ba5=7,ba4=7,ba3=7,ba2=7,ba1=7,ba0=7;
eeprom unsigned char bb7=200,bb6=200,bb5=200,bb4=200,bb3=200,bb2=200,bb1=200,bb0=200;

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
        // Place your code here
        xcount++;
        if(xcount<=lpwm)Enki=1;
        else Enki=0;
        if(xcount<=rpwm)Enka=1;
        else Enka=0;
        TCNT0=0xFF; 
}

typedef unsigned char byte;
flash byte char0[8]={
0b1100000,
0b0011000,
0b0000110,
0b1111111,
0b1111111,
0b0000110,
0b0011000,
0b1100000};

unsigned char read_adc(unsigned char adc_input);
void define_char(byte flash *pc,byte char_code);
void tampil(unsigned char dat);
void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom );
void setByte( byte NoMenu, byte NoSubMenu );
void showMenu(void);
void baca_sensor(void);
void displaySensorBit(void);
void maju(void);
void mundur(void);
void stop(char s);
void pemercepat(void);
void pelambat(void);
void rotkan(void);
void rotkir(void);
void cek_sensor(void);
void tune_batas(void);
void auto_scan(void);
void scanBlackLine(void);
void scanSudut(void);
void cekPointStarta(void);
void cekPoint1a(void);
void cekPoint2a(void);
void cekPoint3a(void);
void cekPoint4a(void);
void cekPoint5a(void);
void strategiA(void);
void cekPointStartb(void);
void cekPoint1b(void);
void cekPoint2b(void);
void cekPoint3b(void);
void cekPoint4b(void);
void cekPoint5b(void);
void strategiB(void);
void indikatorSudut(void);
void indikatorPerempatan(void);

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

void define_char(byte flash *pc,byte char_code)
{
        byte i,a;
        a=(char_code<<3) | 0x40;
        for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
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
        lcd_gotoxy(0, 0);
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
        delay_ms(200);
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
        
        while (sw_cancel) 
        {  
                delay_ms(150);
                lcd_gotoxy(0, 1);
                tampil(var_in_eeprom);
                
                if (!sw_ok)   
                {
                        lcd_clear();
                        tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
                        goto exitSetByte;
                }  
                
                if (!sw_down) 
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
                
                if (!sw_up)   
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
 
void showMenu(void)
{
        lcd_clear();
    menu01:
        delay_ms(125);   // bouncing sw
        lcd_gotoxy(0,0);
                // 0123456789abcdef
        lcd_putsf("  Set PID       ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Set Speed     ");

        // kursor awal
        lcd_gotoxy(0,0);
        lcd_putchar(0);

        if (!sw_ok)
        {
                lcd_clear();
                kursorPID = 1;
                goto setPID;
        }
        if (!sw_down)
        {
                goto menu02;
        }
        if (!sw_up)
        {
                lcd_clear();
                goto menu06;
        } 
        if (!sw_cancel)
        {
                delay_ms(125);
                backlight = 0;
        }

        goto menu01;
    menu02:
        delay_ms(125);
        lcd_gotoxy(0,0);
                 // 0123456789abcdef
        lcd_putsf("  Set PID       ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Set Speed     ");

        lcd_gotoxy(0,1);
        lcd_putchar(0);

        if (!sw_ok)
        {
                lcd_clear();
                kursorSpeed = 1;
                goto setSpeed;
        }
        if (!sw_up)
        {
                goto menu01;
        }
        if (!sw_down)
        {
                lcd_clear();
                goto menu03;
        } 
        if (!sw_cancel)
        {
                delay_ms(125);
                backlight = 0;
        }
        goto menu02;
    menu03:
        delay_ms(125);
        lcd_gotoxy(0,0);
                // 0123456789abcdef
        lcd_putsf("  Set Garis     ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Not Used !    ");

        lcd_gotoxy(0,0);
        lcd_putchar(0);

        if (!sw_ok)
        {
                lcd_clear();
                kursorGaris = 1;
                goto setGaris;
        }
        if (!sw_up)
        {
                lcd_clear();
                goto menu02;
        }
        if (!sw_down)
        {
                goto menu04;
        } 
        if (!sw_cancel)
        {
                delay_ms(125);
                backlight = 0;
        }
        goto menu03;
    menu04:
        delay_ms(125);
        lcd_gotoxy(0,0);
                // 0123456789abcdef
        lcd_putsf("  Set Garis     ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Not Used !    ");

        lcd_gotoxy(0,1);
        lcd_putchar(0);

        if (!sw_ok)
        {
                lcd_clear();
                goto setSkenario;
        }
        if (!sw_up)
        {
                goto menu03;
        }
        if (!sw_down)
        {
                lcd_clear();
                goto menu05;
        } 
        if (!sw_cancel)
        {
                delay_ms(125);
                backlight = 0;
        }
        goto menu04;
    menu05:            // Bikin sendiri lhoo ^^d
        delay_ms(125);
        lcd_gotoxy(0,0);
        lcd_putsf("  Set Mode         ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Start!!      ");

        lcd_gotoxy(0,0);
        lcd_putchar(0);

        if  (!sw_ok)
        {
            lcd_clear();
            goto mode;
        }

        if  (!sw_up)
        {
            lcd_clear();
            goto menu04;
        }

        if  (!sw_down)
        {
            goto menu06;
        } 
        if (!sw_cancel)
        {
                delay_ms(125);
                backlight = 0;
        }

        goto menu05;
    menu06:
        delay_ms(125);
        lcd_gotoxy(0,0);
        lcd_putsf("  Set Mode         ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Start!!      ");

        lcd_gotoxy(0,1);
        lcd_putchar(0);

        if (!sw_ok)
        {
                lcd_clear();
                goto startRobot;
        }

        if (!sw_up)
        {
                goto menu05;
        }

        if (!sw_down)
        {
                lcd_clear();
                goto menu01;
        }

        goto menu06;


    setPID:
        delay_ms(150);
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

        if (!sw_ok)
        {
                setByte( 1, kursorPID);
                delay_ms(200);
        }
        if (!sw_up)
        {
                if (kursorPID == 3) {
                        kursorPID = 1;
                } else kursorPID++;
        }
        if (!sw_down)
        {
                if (kursorPID == 1) {
                        kursorPID = 3;
                } else kursorPID--;
        }

        if (!sw_cancel)
        {
                lcd_clear();
                goto menu01;
        }

        goto setPID;

    setSpeed:
        delay_ms(150);
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

        if (!sw_ok)
        {
                setByte( 2, kursorSpeed);
                delay_ms(200);
        }
        if (!sw_up)
        {
                if (kursorSpeed == 2)
                {
                        kursorSpeed = 1;
                } else kursorSpeed++;
        }
        if (!sw_down)
        {
                if (kursorSpeed == 1)
                {
                        kursorSpeed = 2;
                } else kursorSpeed--;
        }

        if (!sw_cancel)
        {
                lcd_clear();
                goto menu02;
        }

        goto setSpeed;

     setGaris: // not yet
        delay_ms(150);
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

        if (!sw_ok)
        {
                setByte( 3, kursorGaris);
                delay_ms(200);
        }
        if (!sw_up)
        {
                if (kursorGaris == 2)
                {
                        kursorGaris = 1;
                } else kursorGaris++;
        }
        if (!sw_down)
        {
                if (kursorGaris == 1)
                {
                        kursorGaris = 2;
                } else kursorGaris--;
        }

        if (!sw_cancel)
        {
                lcd_clear();
                goto menu03;
        }

        goto setGaris;

     setSkenario:
        delay_ms(150);
        lcd_gotoxy(0,0);
                // 0123456789ABCDEF
        lcd_putsf("Sken. yg  dpake:");
        lcd_gotoxy(0, 1);
        tampil( Skenario );

        if (!sw_ok)
        {
                setByte( 4, 0);
                delay_ms(200);
        }

        if (!sw_cancel)
        {
                lcd_clear();
                goto menu04;
        }

        goto setSkenario;

     mode:
        delay_ms(125);
        if  (!sw_up)
        {
            if (Mode==6)
            {
                Mode=1;
            }

            else Mode++;

            goto nomorMode;
        }

        if  (!sw_down)
        {
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

        if  (!sw_ok)
        {
            switch  (Mode)
            {
                case 1:
                {
                    for(;;)
                    {
                        lcd_gotoxy(2,0);
                        sprintf(lcd," %d %d %d %d",read_adc(3),read_adc(2),read_adc(1),read_adc(0));
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

        if  (!sw_cancel)
        {
            lcd_clear();
            goto menu05;
        }

        goto mode;

     startRobot:
        lcd_clear();
}

void baca_sensor(void)
{
    sensor=0;
    adc0=read_adc(7);
    adc1=read_adc(6);
    adc2=read_adc(5);
    adc3=read_adc(4);
    adc4=read_adc(3);
    adc5=read_adc(2);
    adc6=read_adc(1);
    adc7=read_adc(0);

    if(adc0>bt0){s0=1;sensor=sensor|1<<0;}      // deteksi hitam
    else {s0=0;sensor=sensor|0<<0;}             // deteksi putih

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
           
    // hitam dari 1 dibuat 0
    // putih dari 0 dibuat 1
    s0 = ~s0;
    s1 = ~s1;
    s2 = ~s2;
    s3 = ~s3;
    s4 = ~s4;
    s5 = ~s5;
    s6 = ~s6;
    s7 = ~s7;
    
    sensor = ~sensor;  
    
    if(PINC.0)  sKa = 0;
    else        sKa = 1;
    
    if(PINC.1)  sKi = 0;
    else        sKi = 1;
}

void displaySensorBit(void)
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

void maju(void)
{   
        kaplus=1;kirplus=1;
        kamin=0;kirmin=0;
}

void mundur(void)
{   
        kaplus=0;kirplus=0;
        kamin=1;kirmin=1;
} 

void bkir(void)
{
        kirplus=0;
        kirmin=1;
}

void bkan(void)
{
        kaplus=0;
        kamin=1;
}
 
void stop(char s)
{   
        char i;
        for(i=0;i<s;i++)
        {
                rpwm=255;lpwm=255;       
                Enki = 1;
                Enka = 1;
                kaplus=1;kirplus=1;
                kamin=1;kirmin=1;
                delay_ms(10); 
        }
}

void rotkan(void)
{
        kaplus=0;kamin=1;
        kirplus=1;kirmin=0;
}

void rotkir(void)
{
        kaplus=1;kamin=0;
        kirplus=0;kirmin=1;
}

void pemercepat(void)
{
        int b;
        
        #asm("sei")
        
        lpwm=0;
        rpwm=0;

        maju();

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
        
        #asm("cli")
}

void pelambat(void)
{
        int b;
          
        #asm("sei")
        
        lpwm=255;
        rpwm=255;

        mundur();

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
        
        #asm("cli")
}

void cek_sensor(void)      
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

void tune_batas(void)
{
        int k;
        
        ba7=7;
        ba6=7;
        ba5=7;
        ba4=7;
        ba3=7;
        ba2=7;
        ba1=7;
        ba0=7;
        bb7=200;
        bb6=200;
        bb5=200;
        bb4=200;
        bb3=200;
        bb2=200;
        bb1=200;
        bb0=200; 
        
        lcd_clear();
    
    for(;;)
    {
        k = 0;
        
        k = read_adc(0);
        if  (k<bb0)   {bb0=k;}
        if  (k>ba0)   {ba0=k;}

        bt0=((bb0+ba0)/2);

        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb0  ba0  bt0");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb0,ba0,bt0);
        lcd_puts(lcd);
        delay_ms(50);

        if(!sw_ok)
        {
            delay_ms(125);
            goto sensor1;
        }
    }
    sensor1:
    for(;;)
    {
        k = read_adc(1);
        if  (k<bb1)   {bb1=k;}
        if  (k>ba1)   {ba1=k;}

        bt1=((bb1+ba1)/2);

        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb1  ba1  bt1");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb1,ba1,bt1);
        lcd_puts(lcd);
        delay_ms(50);

        if(!sw_ok)
        {
            delay_ms(150);
            goto sensor2;
        }
    }
    sensor2:
    for(;;)
    {
        k = read_adc(2);
        if  (k<bb2)   {bb2=k;}
        if  (k>ba2)   {ba2=k;}

        bt2=((bb2+ba2)/2);

        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb2  ba2  bt2");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb2,ba2,bt2);
        lcd_puts(lcd);
        delay_ms(10);

        if(!sw_ok)
        {
            delay_ms(150);
            goto sensor3;
        }
    }
    sensor3:
    for(;;)
    {
        k = read_adc(3);
        if  (k<bb3)   {bb3=k;}
        if  (k>ba3)   {ba3=k;}

        bt3=((bb3+ba3)/2);

        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb3  ba3  bt3");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb3,ba3,bt3);
        lcd_puts(lcd);
        delay_ms(10);

        if(!sw_ok)
        {
            delay_ms(150);
            goto sensor4;
        }
    }
    sensor4:
    for(;;)
    {
        k = read_adc(4);
        if  (k<bb4)   {bb4=k;}
        if  (k>ba4)   {ba4=k;}

        bt4=((bb4+ba4)/2);

        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb4  ba4  bt4");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb4,ba4,bt4);
        lcd_puts(lcd);
        delay_ms(10);

        if(!sw_ok)
        {
            delay_ms(150);
            goto sensor5;
        }
    }
    sensor5:
    for(;;)
    {
        k = read_adc(5);
        if  (k<bb5)   {bb5=k;}
        if  (k>ba5)   {ba5=k;}

        bt5=((bb5+ba5)/2);

        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb5  ba5  bt5");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb5,ba5,bt5);
        lcd_puts(lcd);
        delay_ms(10);

        if(!sw_ok)
        {
            delay_ms(150);
            goto sensor6;
        }
    }
    sensor6:
    for(;;)
    {
        k = read_adc(06);
        if  (k<bb6)   {bb6=k;}
        if  (k>ba6)   {ba6=k;}

        bt6=((bb6+ba6)/2);

        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb6  ba6  bt6");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb6,ba6,bt6);
        lcd_puts(lcd);
        delay_ms(10);

        if(!sw_ok)
        {
            delay_ms(150);
            goto sensor7;
        }
    }
    sensor7:
    for(;;)
    {
        k = read_adc(7);
        if  (k<bb7)   {bb7=k;}
        if  (k>ba7)   {ba7=k;}

        bt7=((bb7+ba7)/2);

        lcd_clear();
        lcd_gotoxy(1,0);
        lcd_putsf(" bb7  ba7  bt7");
        lcd_gotoxy(1,1);
        sprintf(lcd," %d  %d  %d",bb7,ba7,bt7);
        lcd_puts(lcd);
        delay_ms(10);

        if(!sw_ok)
        {
            delay_ms(150);
            goto selesai;
        }
    }
    selesai:
    lcd_clear();
}

void auto_scan(void)
{
        int k;
        
        ba7=7;
        ba6=7;
        ba5=7;
        ba4=7;
        ba3=7;
        ba2=7;
        ba1=7;
        ba0=7;
        bb7=200;
        bb6=200;
        bb5=200;
        bb4=200;
        bb3=200;
        bb2=200;
        bb1=200;
        bb0=200;
        
        for(;;)
        {
                k = 0;
                
                k = read_adc(0);
                if  (k<bb0)   {bb0=k;}
                if  (k>ba0)   {ba0=k;}

                bt0=((bb0+ba0)/2);
                
                k = read_adc(1);
                if  (k<bb1)   {bb1=k;}
                if  (k>ba1)   {ba1=k;}

                bt1=((bb1+ba1)/2);

                k = read_adc(2);
                if  (k<bb2)   {bb2=k;}
                if  (k>ba2)   {ba2=k;}

                bt2=((bb2+ba2)/2);

                k = read_adc(3);
                if  (k<bb3)   {bb3=k;}
                if  (k>ba3)   {ba3=k;}

                bt3=((bb3+ba3)/2);

                k = read_adc(4);
                if  (k<bb4)   {bb4=k;}
                if  (k>ba4)   {ba4=k;}

                bt4=((bb4+ba4)/2);

                k = read_adc(5);
                if  (k<bb5)   {bb5=k;}
                if  (k>ba5)   {ba5=k;}

                bt5=((bb5+ba5)/2);

                k = read_adc(6);
                if  (k<bb6)   {bb6=k;}
                if  (k>ba6)   {ba6=k;}

                bt6=((bb6+ba6)/2);

                k = read_adc(7);
                if  (k<bb7)   {bb7=k;}
                if  (k>ba7)   {ba7=k;}

                bt7=((bb7+ba7)/2);

                lcd_clear();
                lcd_gotoxy(1,0);
                sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
                lcd_puts(lcd);
                delay_ms(120);

                if (!sw_ok)
                {
                        goto selesai_auto_scan;
                }
        }  
    
    selesai_auto_scan:
    lcd_clear();
}

void scanBlackLine(void) 
{
        switch(sensor) 
        { 
                case 0b11111110:        // ujung kiri        
                PV = -7;
                maju();
                break;
                
                case 0b11111000:        
                case 0b11111100:        
                PV = -6;
                maju();
                break;
                
                case 0b11111101:        
                PV = -5;
                maju();
                break;
                
                case 0b11110001:        
                case 0b11111001:        
                PV = -4;
                maju();
                break;
                
                case 0b11111011:        
                PV = -3;
                maju();
                break;
                
                case 0b11100011:        
                case 0b11110011:        
                PV = -2;
                maju();
                break;
                
                case 0b11110111:        
                PV = -1;
                maju();
                break;
                
                //////////////
                case 0b11100111:        // tengah        
                PV = 0;
                maju();           
                break;
                //////////////
                
                case 0b11101111:
                PV = 1;
                maju();     
                break;
                
                case 0b11000111:
                case 0b11001111:        
                PV = 2;
                maju();
                break;
                
                case 0b11011111:        
                PV = 3;
                maju();   
                break;
                
                case 0b10001111:
                case 0b10011111:        
                PV = 4;
                maju();    
                break;
                
                case 0b10111111:        
                PV = 5;
                maju(); 
                break;
                
                case 0b00011111:
                case 0b00111111:        
                PV = 6;
                maju();  
                break;
                
                case 0b01111111:        // ujung kanan        
                PV = 7;
                maju();      
                break;
                
                case 0b11111111:        // loss
                if(PV<0)
                {    
                        lpwm = MINPWM;
                        rpwm = MINPWM;
                        bkir();
                        goto exit;
                }
                else if(PV>0)
                {    
                        lpwm = MINPWM;
                        rpwm = MINPWM;
                        bkan();   
                        goto exit; 
                }
                break; 
                
                //case 0b11000000:
                case 0b11100000: 
                case 0b11110000:  
                PV = -15;
                bkir();
                break;
                
                //case 0b00000011:
                case 0b00000111: 
                case 0b00001111:
                PV = 15;
                bkan();
                break; 
                
                case 0b10000001:
                case 0b11000011:
                maju();
                break;
        }
    
        error = SP - PV;
        P = (var_Kp * error) / 2;  
    
        rate = error - last_error;
        I    = (rate * var_Ki) / 2;
        
        D = ((error / 11) * (MINPWM / 20) * var_Kd);
    
        last_error = error; 
    
        MV = P + I + D;
        
        intervalPWM = (MAXPWM - MINPWM) / 8;
    
        //rpwm = MINPWM + (intervalPWM * (0 + MV));
        //lpwm = MINPWM + (intervalPWM * (0 - MV)); 
        
        rpwm = 40 + MINPWM + MV;    
        lpwm = (MINPWM * 0.72) - MV;
        //lpwm = (MINPWM - MV) * 0.72;
        if(lpwm>255)
        {
                rpwm = rpwm - (lpwm - 255);
                lpwm = 255;
        }     
        
        if(rpwm>255)
        {
                lpwm = lpwm - (rpwm - 255);
                rpwm = 255;
        }
        
        if(lpwm < 0)
        {
                stop(3);
                rotkir();
                lpwm = -1 * lpwm;
        } 
        
        if(rpwm < 0)
        {
                stop(3);
                rotkan();
                rpwm = -1 * rpwm;
        }  
        
        if(lpwm==0)
        { 
                if(PV<0)
                {    
                        lpwm = MAXPWM/2;
                        rpwm = MAXPWM/2;
                        bkir();
                        goto exit;
                }
                else if(PV>0)
                {    
                        lpwm = MAXPWM/2;
                        rpwm = MAXPWM/2;
                        bkan();   
                        goto exit; 
                }
        }
        
        if(rpwm==0)
        {
        }
    
        exit:
    
        //debug pwm
        sprintf(lcd,"%d   %d",lpwm, rpwm);
        lcd_gotoxy(0, 0);
        lcd_putsf("                ");
        lcd_gotoxy(0, 0);
        lcd_puts(lcd);
        delay_ms(1);     
    
        /*
        //debug MV
        sprintf(lcd_buffer,"MV:%d",MV);
        lcd_gotoxy(0,0);
        lcd_putsf("                ");
        lcd_gotoxy(0,0);
        lcd_puts(lcd_buffer);
        delay_ms(10); 
        */
}        

void scanSudut(void)
{
        if((!sKa)&&(sensor==255))
        {
                indikatorSudut();
                baca_sensor(); 
                //while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111)) 
                while(sensor==255)
                {        
                        baca_sensor();
                        lpwm=MINPWM;
                        rpwm=MINPWM;
                        rotkan();
                }
                stop(5);
                goto exit_sudut;
        }
        
        if((!sKi)&&(sensor==255))
        {    
                indikatorSudut();
                baca_sensor();
                //while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))   
                while(sensor==255)
                {        
                        baca_sensor();
                        lpwm=MINPWM;
                        rpwm=MINPWM;
                        rotkir();
                }
                stop(5);
                goto exit_sudut;
        }
        
        exit_sudut:
        
        maju();
}

// strategi track A penyisihan, warna : merah , hijau

void cekPointStarta(void)
{
        MINPWM = _MINPWM;
        var_Kp = 17;
        var_Ki = 0;
        var_Kd = 11;  
        
        maju();
        while(sKa)
        {
                displaySensorBit();
                scanBlackLine();     
        }       
        stop(10);                
        baca_sensor();
        while(sensor==255)
        {
                rotkan();
                lpwm = MINPWM;
                rpwm = MINPWM + 15;
                baca_sensor();
        }                     
        stop(10);
        for(;;)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        }
}

void cekPoint1a(void)
{
        //cek point 1
        MINPWM = _MINPWM - 10;
        var_Kp = 17;
        var_Ki = 0;
        var_Kd = 11; 
                       
        // cari simpangan T
        baca_sensor();
        maju();
        while(sKi)
        { 
                displaySensorBit();
                scanBlackLine();
        }  
        stop(10);
        indikatorSudut(); 
        
        // lepas T, mundur 
        baca_sensor();
        while(sKi)
        {     
                mundur();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
               
        // balik ke T putar kanan
        baca_sensor();
        while(sensor==255)
        {
                rotkir();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }                     
        stop(10); 
        
        // maju menuju busur dan perempatan
        maju();
        while(sKi)
        {
                displaySensorBit();
                scanBlackLine();       
        } 
        /*indikatorSudut();                      
        while(!sKi)
        {
                displaySensorBit();
                scanBlackLine();       
        }
        while(sKi)
        {
                displaySensorBit();
                scanBlackLine();       
        } */
        stop(10);
        indikatorSudut();
        
        // ketemu perempatan, putar kiri 
        baca_sensor();
        while(sKi)      // lepas perempatan
        {  
                mundur();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }     
        baca_sensor();
        while(sensor<255)       // manuver kiri
        {
                rotkan();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
        while(sensor==255)
        {
                rotkan();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        } 
        stop(10); 
        
        maju();
}

void cekPoint2a(void)
{
        int tlpwm, trpwm;
        
        //cek point 2   
        MINPWM = _MINPWM - 15; 
        var_Kp = 17;
        var_Ki = 0;
        var_Kd = 8;
               
        // cari perempatan V  
        maju();
        while(sKi)
        {
                displaySensorBit();
                scanBlackLine();
        }          
        indikatorSudut();  
        tlpwm = lpwm;
        trpwm = rpwm;
        lpwm = MINPWM;
        rpwm = MINPWM + 30;
        rotkan();
        delay_ms(50); 
        stop(5);  
        maju();     
        MINPWM = _MINPWM;
        lpwm = tlpwm;
        rpwm = trpwm;
        for(;;)
        {
                displaySensorBit();
                scanBlackLine();
        }
}

void cekPoint3a(void)
{
        char f;
        
        //cek point 3 
        MINPWM = _MINPWM - 13; 
        var_Kp = 11;
        var_Ki = 0;
        var_Kd = 7;
         
        // cari simpangan
        maju();
        while(sKi)
        {
                displaySensorBit();
                scanBlackLine();
        }  
        indikatorSudut();
             
        // putar kanan 
        stop(10);
        baca_sensor();
        while(sKi)
        {
                mundur();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }           
        stop(10);
        baca_sensor();
        while(s7)
        {
                rotkir();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        } 
        baca_sensor();
        while(!s7)
        {
                rotkir();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
        baca_sensor();
        while(s3)
        {
                rotkir();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
            
        // counting simpangan
        stop(10);
        baca_sensor();
        while(sKi)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        } 
        indikatorSudut();
        while(!sKi)
        {    
                maju();
                displaySensorBit();
                scanBlackLine();
        }
        while(sKi)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        } 
        indikatorSudut();
        while(!sKi)
        {    
                maju();
                displaySensorBit();
                scanBlackLine();
        }
        while(sKi)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        } 
        indikatorSudut();
        while(!sKi)
        {    
                maju();
                displaySensorBit();
                scanBlackLine();
        }  
        for(f=0;f<10;f++)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        } 
        while(sKa)
        {
                maju();
                displaySensorBit();
        } 
        indikatorSudut();  
            
        // putar kiri
        stop(10);   
        baca_sensor();
        while(sKi)
        {
                mundur();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }   
        stop(10);
        baca_sensor();
        while(sensor<255)
        {
                bkan();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        } 
        while(s4)
        {
                bkan();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
            
        // counting simpangan
        stop(10);
        baca_sensor();
        while(sKi)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        }   
        indikatorSudut();
        while(!sKi)
        {    
                maju();
                displaySensorBit();
                scanBlackLine();
        }
        baca_sensor();
        while(sKi)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        }   
        indikatorSudut();
        while(!sKi)
        {    
                maju();
                displaySensorBit();
                scanBlackLine();
        }
        while(sKi)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        } 
        indikatorSudut();
            
        // putar kanan
        stop(10);
        baca_sensor();
        while(sKi)
        {
                mundur();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
        /*while(sensor<255)
        {
                rotkir();
                lpwm = MINPWM;
                rpwm = MINPWM;
                baca_sensor();
        } */ 
        baca_sensor();
        while(s0)
        {
                rotkir();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        } 
        baca_sensor();
        while(sKa)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        }                       
        baca_sensor();
        while(!sKa)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        }
        for(f=0;f<10;f++)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        } 
        // done !
        indikatorSudut();
}

void cekPoint4a(void)
{
        // cekpoint 4;
        MINPWM = _MINPWM - 5; 
        var_Kp = 17;
        var_Ki = 0;
        var_Kd = 11;
                      
        cekpoint4:
        
        maju();
        displaySensorBit();
        scanBlackLine(); 
        
        if(!sKa)
        {
                stop(10);
                indikatorSudut(); 
                baca_sensor();
                while(sKa)
                { 
                        mundur();
                        lpwm = MINPWM;
                        rpwm = MINPWM + 30;
                        baca_sensor();
                } 
                
                stop(10);
                     
                baca_sensor();
                while(sensor<255)
                {
                        baca_sensor();
                        lpwm = MINPWM;
                        rpwm = MINPWM + 30;
                        rotkan();   
                }         
                
                baca_sensor();
                while(s4)
                {   
                        baca_sensor();
                        lpwm = MINPWM;
                        rpwm = MINPWM + 30;
                        rotkan();
                }  
                
                stop(10);
                goto cekpoint41;  
        }      
        goto cekpoint4;
        
        cekpoint41:
        
        maju();
        displaySensorBit();
        scanBlackLine(); 
        
        if(!sKi)
        {
                indikatorSudut();
                //MINPWM = 100; 
                while(!sKi)
                {
                        maju();
                        displaySensorBit();
                        scanBlackLine();
                }
                goto cekpoint42;  
        }      
        
        goto cekpoint41;
        
        cekpoint42: 
        
        maju();
        displaySensorBit();
        scanBlackLine();
        if(!sKi)
        {
                indikatorSudut();
                //MINPWM = 110;
                while(!sKi)
                {
                        maju();
                        displaySensorBit();
                        scanBlackLine();
                }
                goto cekpoint43;
        }
        goto cekpoint42; 
        
        cekpoint43:
                        
        //maju();
        displaySensorBit();
        scanBlackLine();
        if(!sKi)
        {
                indikatorSudut(); 
                //MINPWM = 120;
                while(!sKi)
                {
                        maju();
                        displaySensorBit();
                        scanBlackLine();
                }
                goto cekpoint44;
        }
        goto cekpoint43; 
                  
        cekpoint44:
        
        maju();
        displaySensorBit();
        scanBlackLine();
        if(!sKi)
        {
                indikatorSudut(); 
                //MINPWM = 130;  
                while(!sKi)
                {
                        maju();
                        displaySensorBit();
                        scanBlackLine();
                }
                goto cekpoint45;
        }
        goto cekpoint44;
        
        cekpoint45:
        
        maju();
        displaySensorBit();
        scanBlackLine();
        if(!sKi)
        {
                indikatorSudut(); 
                //MINPWM = 140; 
                while(!sKi)
                {
                        maju();
                        displaySensorBit();
                        scanBlackLine();
                }
                goto cekpoint5;
        }            
        goto cekpoint45;
        
        cekpoint5: 
        indikatorSudut();
}

void cekPoint5a(void)
{
        char k = 0;
        
        //cek point 5 
        stop(3);
        MINPWM = _MINPWM;
        var_Kp = 17;
        var_Ki = 1;
        var_Kd = 7;
        
        maju();
        cekpoint5:     
        
        displaySensorBit();
        scanBlackLine();  
        MINPWM = MINPWM + 2; 
        if(MINPWM > 255) MINPWM = 255;
        if(sensor==255) 
        {
                k++;
                if(k > 100)
                {  
                        mundur();
                        indikatorPerempatan(); 
                        stop(150);
                        indikatorPerempatan();  
                        goto exit;
                }
        }
        goto cekpoint5;  
        
        exit:
}

void cekPointFinalA(void)
{
}

void strategiA(void)
{
        if(NoStrategi < 2)      goto level_1a;
        else if(NoStrategi < 3) goto level_2a;
        else if(NoStrategi < 4) goto level_3a;
        else if(NoStrategi < 5) goto level_4a;
        
        else if(NoStrategi < 6) goto level_5a;
        else                    goto level_6a; 
        
        level_1a: 
        
        backlight = 1; 
        NoStrategi = 1; 
        delay_ms(50);         
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf(" Skenario-StartA");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0);
        
        if(!sw_up)
        { 
                delay_ms(150);
                goto level_6a;
        }
        if(!sw_down)
        {  
                delay_ms(150);
                goto level_2a;
        }
        if(!sw_ok)
        {  
                delay_ms(250); 
                backlight = 0; 
                
                cekPointStarta(); 
                cekPoint1a();
                cekPoint2a();
                cekPoint3a();
                cekPoint4a();
                cekPoint5a();
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        
        goto level_1a; 
        
        level_2a: 
        
        backlight = 1;  
        NoStrategi = 2; 
        delay_ms(50); 
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("  Skenario-1A");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0); 
        
        if(!sw_up)
        { 
                delay_ms(150);
                goto level_1a;
        }
        if(!sw_down)
        {  
                delay_ms(150);
                goto level_3a;
        }
         if(!sw_ok)
        {  
                delay_ms(250); 
                backlight = 0;
                
                cekPoint1a();
                cekPoint2a();
                cekPoint3a();
                cekPoint4a();
                cekPoint5a(); 
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        goto level_2a;

        level_3a: 
        
        backlight = 1;  
        NoStrategi = 3;
        delay_ms(50); 
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("  Skenario-2A");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0);
        
        if(!sw_up)
        { 
                delay_ms(150);
                goto level_2a;
        }
        if(!sw_down)
        {  
                delay_ms(150);  
                goto level_4a;
        }
         if(!sw_ok)
        {  
                delay_ms(250); 
                backlight = 0;
                
                cekPoint2a();
                cekPoint3a();
                cekPoint4a();
                cekPoint5a(); 
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        goto level_3a;
        
        level_4a: 
        
        backlight = 1;  
        NoStrategi = 4;
        delay_ms(50); 
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("  Skenario-3A");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0); 
        
        if(!sw_up)
        { 
                delay_ms(150);
                goto level_3a;
        }
        if(!sw_down)
        {  
                delay_ms(150);
                goto level_5a;
        }
         if(!sw_ok)
        {  
                delay_ms(250); 
                backlight = 0;
                
                cekPoint3a();
                cekPoint4a();
                cekPoint5a();
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        goto level_4a;
        
        level_5a:
        
        backlight = 1;  
        NoStrategi = 5;
        delay_ms(50); 
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("  Skenario-4A");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0);
        
        if(!sw_up)
        { 
                delay_ms(150);
                goto level_4a;
        }
        if(!sw_down)
        {  
                delay_ms(150);
                goto level_6a;
        }
         if(!sw_ok)
        {  
                delay_ms(250); 
                backlight = 0;
                
                cekPoint4a();
                cekPoint5a();
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        goto level_5a;
        
        level_6a:
        
        backlight = 1;  
        NoStrategi = 6;
        delay_ms(50); 
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("  Skenario-5A");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0); 
        
        if(!sw_up)
        { 
                delay_ms(150);
                goto level_5a;
        }
        if(!sw_down)
        {  
                delay_ms(150);
                goto level_1a;
        }
         if(!sw_ok)
        {  
                delay_ms(250);
                backlight = 0;
                
                cekPoint5a();
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        goto level_6a;
                
        exit_strategi:
        backlight = 0;
}

// strategi track B penyisihan, warna : biru , kuning

void cekPointStartb(void)
{
        MINPWM = _MINPWM;
        var_Kp = 17;
        var_Ki = 0;
        var_Kd = 11;  
        
        maju();
        while(sKi)
        {
                displaySensorBit();
                scanBlackLine();     
        }       
        stop(10);                
        baca_sensor();
        while(sensor==255)
        {
                rotkir();
                lpwm = MINPWM;
                rpwm = MINPWM + 15;
                baca_sensor();
        }                     
        stop(10);
        for(;;)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        }
}

void cekPoint1b(void)
{
        //cek point 1
        MINPWM = _MINPWM - 10;
        var_Kp = 17;
        var_Ki = 0;
        var_Kd = 11; 
                       
        // cari simpangan T
        baca_sensor();
        maju();
        while(sKa)
        { 
                displaySensorBit();
                scanBlackLine();
        }  
        stop(10);
        indikatorSudut(); 
        
        // lepas T, mundur 
        baca_sensor();
        while(sKa)
        {     
                mundur();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
               
        // balik ke T putar kanan
        baca_sensor();
        while(sensor==255)
        {
                rotkan();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }                     
        stop(10); 
        
        // maju menuju busur dan perempatan
        maju();
        while(sKa)
        {
                displaySensorBit();
                scanBlackLine();       
        } 
        /*indikatorSudut();                      
        while(!sKi)
        {
                displaySensorBit();
                scanBlackLine();       
        }
        while(sKi)
        {
                displaySensorBit();
                scanBlackLine();       
        } */
        stop(10);
        indikatorSudut();
        
        // ketemu perempatan, putar kiri 
        baca_sensor();
        while(sKa)      // lepas perempatan
        {  
                mundur();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }     
        baca_sensor();
        while(sensor<255)       // manuver kiri
        {
                rotkir();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
        while(sensor==255)
        {
                rotkir();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        } 
        stop(10); 
        
        maju();
}

void cekPoint2b(void)
{
        int tlpwm, trpwm;
        
        //cek point 2   
        MINPWM = _MINPWM - 15; 
        var_Kp = 17;
        var_Ki = 0;
        var_Kd = 8;
               
        // cari perempatan V  
        maju();
        while(sKa)
        {
                displaySensorBit();
                scanBlackLine();
        }          
        indikatorSudut();  
        tlpwm = lpwm;
        trpwm = rpwm;
        lpwm = MINPWM;
        rpwm = MINPWM + 30;
        rotkir();
        delay_ms(75); 
        stop(5);  
        maju(); 
        MINPWM = _MINPWM;
        lpwm = tlpwm;
        rpwm = trpwm;
        for(;;)
        {
                displaySensorBit();
                scanBlackLine();
        }
}

void cekPoint3b(void)
{
        char f;
        
        //cek point 3 
        MINPWM = _MINPWM - 13; 
        var_Kp = 11;
        var_Ki = 0;
        var_Kd = 7;
         
        // cari simpangan
        maju();
        while(sKa)
        {
                displaySensorBit();
                scanBlackLine();
        }  
        indikatorSudut();
             
        // putar kiri 
        stop(10);
        baca_sensor();
        while(sKa)
        {
                mundur();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }           
        stop(10);
        baca_sensor();
        while(s0)
        {
                rotkan();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        } 
        baca_sensor();
        while(!s0)
        {
                rotkan();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
        baca_sensor();
        while(s4)
        {
                rotkan();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
            
        // counting simpangan
        stop(10);
        baca_sensor();
        while(sKa)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        } 
        indikatorSudut();
        while(!sKa)
        {    
                maju();
                displaySensorBit();
                scanBlackLine();
        }
        while(sKa)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        } 
        indikatorSudut();
        while(!sKa)
        {    
                maju();
                displaySensorBit();
                scanBlackLine();
        }  
        for(f=0;f<10;f++)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        } 
        while(sKa)
        {
                maju();
                displaySensorBit();
        } 
        indikatorSudut();  
            
        // putar kanan
        stop(10);   
        baca_sensor();
        while(sKa)
        {
                mundur();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }   
        stop(10);
        baca_sensor();
        while(sensor<255)
        {
                bkir();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        } 
        while(s3)
        {
                bkir();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
            
        // counting simpangan
        stop(10);
        baca_sensor();
        while(sKa)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        }   
        indikatorSudut();
        while(!sKa)
        {    
                maju();
                displaySensorBit();
                scanBlackLine();
        }
        baca_sensor();
        while(sKa)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        }   
        indikatorSudut();
        while(!sKa)
        {    
                maju();
                displaySensorBit();
                scanBlackLine();
        }
        while(sKa)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        } 
        indikatorSudut();
            
        // putar kiri
        stop(10);
        baca_sensor();
        while(sKa)
        {
                mundur();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        }  
        /*while(sensor<255)
        {
                rotkir();
                lpwm = MINPWM;
                rpwm = MINPWM;
                baca_sensor();
        } */ 
        baca_sensor();
        while(s7)
        {
                rotkan();
                lpwm = MINPWM;
                rpwm = MINPWM + 30;
                baca_sensor();
        } 
        baca_sensor();
        while(sKi)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        }                       
        baca_sensor();
        while(!sKi)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        }
        for(f=0;f<10;f++)
        {
                maju();
                displaySensorBit();
                scanBlackLine();
        } 
        // done !
        indikatorSudut();
}

void cekPoint4b(void)
{
        //cek point 4 
        MINPWM = _MINPWM - 5; 
        var_Kp = 17;
        var_Ki = 0;
        var_Kd = 11;
                      
        cekpoint4:
        
        maju();
        displaySensorBit();
        scanBlackLine(); 
        
        if(!sKi)
        {
                stop(10);
                indikatorSudut(); 
                baca_sensor();
                while(sKi)
                { 
                        mundur();
                        lpwm = MINPWM;
                        rpwm = MINPWM + 30;
                        baca_sensor();
                } 
                
                stop(10);
                     
                baca_sensor();
                while(sensor<255)
                {
                        baca_sensor();
                        lpwm = MINPWM;
                        rpwm = MINPWM + 30;
                        rotkir();   
                }         
                
                baca_sensor();
                while(s4)
                {   
                        baca_sensor();
                        lpwm = MINPWM;
                        rpwm = MINPWM + 30;
                        rotkir();
                }  
                
                stop(10);
                goto cekpoint41;  
        }      
        goto cekpoint4;
        
        cekpoint41:
        
        maju();
        displaySensorBit();
        scanBlackLine(); 
        
        if(!sKa)
        {
                indikatorSudut();
                //MINPWM = 100; 
                while(!sKa)
                {
                        maju();
                        displaySensorBit();
                        scanBlackLine();
                }
                goto cekpoint42;  
        }      
        
        goto cekpoint41;
        
        cekpoint42: 
        
        maju();
        displaySensorBit();
        scanBlackLine();
        if(!sKa)
        {
                indikatorSudut();
                //MINPWM = 110;
                while(!sKa)
                {
                        maju();
                        displaySensorBit();
                        scanBlackLine();
                }
                goto cekpoint43;
        }
        goto cekpoint42; 
        
        cekpoint43:
                        
        //maju();
        displaySensorBit();
        scanBlackLine();
        if(!sKa)
        {
                indikatorSudut(); 
                //MINPWM = 120;
                while(!sKa)
                {
                        maju();
                        displaySensorBit();
                        scanBlackLine();
                }
                goto cekpoint44;
        }
        goto cekpoint43; 
                  
        cekpoint44:
        
        maju();
        displaySensorBit();
        scanBlackLine();
        if(!sKa)
        {
                indikatorSudut(); 
                //MINPWM = 130;  
                while(!sKa)
                {
                        maju();
                        displaySensorBit();
                        scanBlackLine();
                }
                goto cekpoint45;
        }
        goto cekpoint44;
        
        cekpoint45:
        
        maju();
        displaySensorBit();
        scanBlackLine();
        if(!sKa)
        {
                indikatorSudut(); 
                //MINPWM = 140; 
                while(!sKa)
                {
                        maju();
                        displaySensorBit();
                        scanBlackLine();
                }
                goto cekpoint5;
        }            
        goto cekpoint45;
        
        cekpoint5: 
        indikatorSudut();
}

void cekPoint5b(void)
{
        //cek point 5 
        cekPoint5a();
}

void cekPointFinalB(void)
{
}

void strategiB(void)
{
        if(NoStrategi < 2)      goto level_1b;
        else if(NoStrategi < 3) goto level_2b;
        else if(NoStrategi < 4) goto level_3b;
        else if(NoStrategi < 5) goto level_4b;
        
        else if(NoStrategi < 6) goto level_5b;
        else                    goto level_6b; 
        
        level_1b: 
        
        backlight = 1; 
        NoStrategi = 1; 
        delay_ms(50);         
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf(" Skenario-StartB");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0);
        
        if(!sw_up)
        { 
                delay_ms(250);
                goto level_6b;
        }
        if(!sw_down)
        {  
                delay_ms(250);
                goto level_2b;
        }
        if(!sw_ok)
        {  
                delay_ms(250); 
                backlight = 0; 
                
                cekPointStartb(); 
                cekPoint1b();
                cekPoint2b();
                cekPoint3b();
                cekPoint4b();
                cekPoint5b();
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        
        goto level_1b; 
        
        level_2b: 
        
        backlight = 1;  
        NoStrategi = 2; 
        delay_ms(50); 
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("  Skenario-1B");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0); 
        
        if(!sw_up)
        { 
                delay_ms(250);
                goto level_1b;
        }
        if(!sw_down)
        {  
                delay_ms(250);
                goto level_3b;
        }
         if(!sw_ok)
        {  
                delay_ms(250); 
                backlight = 0;
                
                cekPoint1b();
                cekPoint2b();
                cekPoint3b();
                cekPoint4b();
                cekPoint5b(); 
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        goto level_2b;

        level_3b: 
        
        backlight = 1;  
        NoStrategi = 3;
        delay_ms(50); 
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("  Skenario-2B");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0);
        
        if(!sw_up)
        { 
                delay_ms(250);
                goto level_2b;
        }
        if(!sw_down)
        {  
                delay_ms(250);  
                goto level_4b;
        }
         if(!sw_ok)
        {  
                delay_ms(250); 
                backlight = 0;
                
                cekPoint2b();
                cekPoint3b();
                cekPoint4b();
                cekPoint5b(); 
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        goto level_3b;
        
        level_4b: 
        
        backlight = 1;  
        NoStrategi = 4;
        delay_ms(50); 
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("  Skenario-3B");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0); 
        
        if(!sw_up)
        { 
                delay_ms(250);
                goto level_3b;
        }
        if(!sw_down)
        {  
                delay_ms(250);
                goto level_5b;
        }
         if(!sw_ok)
        {  
                delay_ms(250); 
                backlight = 0;
                
                cekPoint3b();
                cekPoint4b();
                cekPoint5b(); 
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        goto level_4b;
        
        level_5b:
        
        backlight = 1;  
        NoStrategi = 5;
        delay_ms(50); 
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("  Skenario-4B");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0);
        
        if(!sw_up)
        { 
                delay_ms(250);
                goto level_4b;
        }
        if(!sw_down)
        {  
                delay_ms(250);
                goto level_6b;
        }
         if(!sw_ok)
        {  
                delay_ms(250); 
                backlight = 0;
                
                cekPoint4b();
                cekPoint5b();
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        goto level_5b;
        
        level_6b:
        
        backlight = 1;  
        NoStrategi = 6;
        delay_ms(50); 
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf("  Skenario-5B");
        lcd_gotoxy(0,1);
        lcd_putsf("  OK ?");
        lcd_gotoxy(0,0);
        lcd_putchar(0); 
        
        if(!sw_up)
        { 
                delay_ms(250);
                goto level_5b;
        }
        if(!sw_down)
        {  
                delay_ms(250);
                goto level_1b;
        }
         if(!sw_ok)
        {  
                delay_ms(250);
                backlight = 0;
                
                cekPoint5b();
                
                goto exit_strategi;
        }
        if(!sw_cancel)
        {   
                delay_ms(250);
                goto exit_strategi;
        }
        goto level_6b;
                
        exit_strategi: 
        lcd_clear(); 
        backlight = 0;
}

////////////////////////////////////////

void indikatorSudut(void)
{
        backlight = 1;
        delay_ms(100);
        backlight = 0;
}

void indikatorPerempatan(void)
{
        backlight = 1;
        delay_ms(100);
        backlight = 0;
        delay_ms(150);
        backlight = 1;
        delay_ms(100);
        backlight = 0;
}

/////////////////////////////////////

void main(void)
{
        PORTA=0x00;
        DDRA=0x00;
        PORTB=0x00;
        DDRB=0xFF;
        PORTC=0x03;
        DDRC=0xFC;
        PORTD=0x78;
        DDRD=0x00;
        
        TCCR0=0x05;
        TCNT0=0xFF;
        OCR0=0x00;

        TIMSK=0x01;

        ACSR=0x80;
        SFIOR=0x00;
        
        ADMUX=ADC_VREF_TYPE & 0xff;
        ADCSRA=0x87;
        
        lcd_init(16); 
        define_char(char0,0);
        
        indikatorSudut();
        delay_ms(500);
        backlight = 1;
        
        stop(1);
        TCCR0=0x05; 
        
        showMenu();  
        backlight = 0;
        #asm("sei") 
        
        var_Kp  = Kp;
        var_Ki  = Ki;
        var_Kd  = Kd;
        
        tempKp = Kp;
        tempKd = Ki;
        tempKi = Ki;
           
        MAXPWM = (int)MAXSpeed;
        _MINPWM = MINSpeed;
        MINPWM = _MINPWM;

        intervalPWM = (MAXSpeed - MINSpeed) / 8;
        PV = 0;
        error = 0;
        last_error = 0; 
        
        delay_ms(200);
        indikatorPerempatan();
                 
        maju(); 

        while (1)
        { 
                displaySensorBit();
                scanBlackLine(); 
                //scanSudut();
                
                // strategi track A
                if(!sw_up)      // interupsi
                {
                        delay_ms(125);
                        stop(1);
                        lcd_clear();
                        strategiA(); 
                        goto exitRobot;
                }    
                
                // strategi track B
                if(!sw_down)    // interupsi
                {     
                        delay_ms(125);
                        stop(1);
                        lcd_clear();
                        strategiB(); 
                        goto exitRobot;    
                } 
                
                // percobaan counting
                while(!sKi)
                {
                        displaySensorBit();
                        scanBlackLine();
                        backlight = 1;
                } 
                
                while(!sKa)
                {
                        displaySensorBit();
                        scanBlackLine();
                        backlight = 1;
                }  
                backlight = 0;
        };  
          
        var_Kp = tempKp;
        var_Ki = tempKi;
        var_Kd = tempKd;
        
        exitRobot:  
        goto exitRobot;
}
