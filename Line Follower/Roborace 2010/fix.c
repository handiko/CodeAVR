/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Standard
Automatic Program Generator
� Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
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

#include <mega16.h>    
#include <delay.h>
#include <stdio.h>
#include <lcd.h>

#define sw_ok     PINB.1
#define sw_cancel PINB.0
#define sw_up     PINB.3
#define sw_down   PINB.2            

#define sKi  PINB.5
#define sKa  PINB.6

#define Enki PORTD.4
#define kirplus PORTD.6
#define kirmin PORTD.3
#define Enka PORTD.5
#define kaplus PORTD.1
#define kamin PORTD.0

#define ADC_VREF_TYPE 0x20 

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm   

char lcd[16];
unsigned char sensor, adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7;
//unsigned char b7=37,b6=50,b5=9,b4=10,b3=8,b2=15,b1=25,b0=30;
unsigned char bt7=7,bt6=7,bt5=7,bt4=7,bt3=7,bt2=7,bt1=7,bt0=9;
unsigned char ba7=7,ba6=7,ba5=7,ba4=7,ba3=7,ba2=7,ba1=7,ba0=9;
unsigned char bb7=7,bb6=7,bb5=7,bb4=7,bb3=7,bb2=7,bb1=7,bb0=9;
unsigned char xcount;
unsigned char max_MV = 100;
unsigned char min_MV = -100;
unsigned char SP = 0;
bit s0,s1,s2,s3,s4,s5,s6,s7;
int lpwm, rpwm, MAXPWM, MINPWM, intervalPWM;
typedef unsigned char byte;
int MV, P, I, D, PV, error, last_error, rate;
int var_Kp, var_Ki, var_Kd;
byte kursorPID, kursorSpeed, kursorGaris;
byte diffPWM = 4;
int hitungSiku;
char lcd_buffer[33]; 

eeprom byte Kp = 20; 
eeprom byte Ki = 10;
eeprom byte Kd = 15;
eeprom byte MAXSpeed = 255;
eeprom byte MINSpeed = 0;
eeprom byte WarnaGaris = 0; // 1 : putih; 0 : hitam
eeprom byte SensLine = 2; // banyaknya sensor dlm 1 garis
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
void stopSemiReset();
void scanBlackLine();
void test();
void cek_sensor();
void test_sensor();
void test_ScanLine();
void baca_sensor();
void tune_batas();
void tampil_eror();
void auto_scan();

unsigned char read_adc(unsigned char adc_input){
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

flash byte char0[8]={
0b1100000,
0b0011000,
0b0000110,
0b1111111,
0b1111111,
0b0000110,
0b0011000,
0b1100000};

void main(void)
{
// sensor
PORTA=0x00;
DDRA=0x00;

//switch & sKi & sKa
PORTB=0x0F;
DDRB=0x00;

//lcd
PORTC=0x00;
DDRC=0x00;
     
//motor
PORTD=0x00;
DDRD=0xFF;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0 output: Disconnected
TCCR0=0x00;
TCNT0=0x00;
OCR0=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: Timer 1 Stopped
// Mode: Normal top=FFFFh
// OC1A output: Discon.
// OC1B output: Discon.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
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
// Clock value: Timer 2 Stopped
// Mode: Normal top=FFh
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
TIMSK=0x01;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 750.000 kHz
// ADC Voltage Reference: AREF pin
// ADC Auto Trigger Source: None
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;

// LCD module initialization
lcd_init(16);   

/* define user character 0 */
define_char(char0,0);

// stop motor
TCCR0=0x00;
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
lcd_putsf(" TEKNIK FISIKA ");
lcd_gotoxy(0,1);
lcd_putsf("------UGM------");
delay_ms(500);
lcd_clear();

delay_ms(125);
lcd_gotoxy(0,0);
        // 0123456789ABCDEF
lcd_putsf("ROBORACE UNY '10");
lcd_gotoxy(0,1);
lcd_putsf("----------------");
delay_ms(500);
lcd_clear();

TCCR0=0x05;   
#asm("sei")

//                    <<-----------SEMI RESET-----------<<
semiReset:
stop();         
// read eeprom
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
delay_ms(200);
    
    if  (!sw_up)    
    {
        goto semiReset;
    }

    if  (!sw_down)
    {
        goto semiReset;
    }

    if  (!sw_cancel)
    {
        goto semiReset;
    }

maju();

while (1)
      {
            displaySensorBit();  
            scanBlackLine();
            tampil_eror();
       
            delay_ms(200);
            if  (!sw_up)    
            {
                goto semiReset;
            }

            if  (!sw_down)
            {
                goto semiReset;
            }

            if  (!sw_cancel)
            {
                goto semiReset;
            }
            
      };
}

void baca_sensor(){
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

void define_char(byte flash *pc,byte char_code){
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

void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom ) {
                                                     lcd_gotoxy(0, 0);
        lcd_putsf("Tulis ke EEPROM ");
        lcd_putsf("...             ");
        switch (NoMenu) {
          case 1: // PID
                switch (NoSubMenu) {
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
                switch (NoSubMenu) {
                  case 1: // MAX 
                        MAXSpeed = var_in_eeprom;
                        break;
                  case 2: // MIN
                        MINSpeed = var_in_eeprom;
                        break;
                }
                break;
          case 3: // Warna Garis
                switch (NoSubMenu) {
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

void setByte( byte NoMenu, byte NoSubMenu ) {
        byte var_in_eeprom;    
        byte plus5 = 0;
        char limitPilih = -1;
        
        lcd_clear();
        lcd_gotoxy(0, 0);
        switch (NoMenu) {
          case 1: // PID
                switch (NoSubMenu) {
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
                switch (NoSubMenu) {
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
                switch (NoSubMenu) {
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
        
        while (sw_cancel) {  
                delay_ms(150);
                lcd_gotoxy(0, 1);
                tampil(var_in_eeprom);
                
                if (!sw_ok)   {
                        lcd_clear();
                        tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
                        goto exitSetByte;
                }
                if (!sw_down) { 
                        if ( plus5 )
                                if ( var_in_eeprom == 0 )
                                        var_in_eeprom = 255;
                                else 
                                        var_in_eeprom -= 5;
                        else     
                                if ( !limitPilih )
                                        var_in_eeprom--;
                                else {  
                                        if ( var_in_eeprom == 0 )
                                          var_in_eeprom = limitPilih;
                                        else
                                          var_in_eeprom--;
                                }
                }  
                if (!sw_up)   {
                        if ( plus5 )
                                if ( var_in_eeprom == 255 )
                                        var_in_eeprom = 0;
                                else
                                        var_in_eeprom += 5;
                        else
                                if ( !limitPilih )
                                        var_in_eeprom++;
                                else {
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
        
        if (!sw_ok)   {
                lcd_clear();
                kursorPID = 1;
                goto setPID;
        }
        if (!sw_down) {
                goto menu02;
        }  
        if (!sw_up)   {
                lcd_clear();
                goto menu06;
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
        
        if (!sw_ok) {   
                lcd_clear(); 
                kursorSpeed = 1;
                goto setSpeed;
        }
        if (!sw_up) {
                goto menu01;
        }
        if (!sw_down) {
                lcd_clear();
                goto menu03;        
       }
        goto menu02;
    menu03:       
        delay_ms(125);
        lcd_gotoxy(0,0);
                // 0123456789abcdef
        lcd_putsf("  Set Garis     ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Skenario      ");
        
        lcd_gotoxy(0,0);
        lcd_putchar(0); 
        
        if (!sw_ok) {
                lcd_clear(); 
                kursorGaris = 1;  
                goto setGaris;
        }
        if (!sw_up) {  
                lcd_clear();
                goto menu02;
        }
        if (!sw_down) { 
                goto menu04;
        }
        goto menu03;
    menu04:  
        delay_ms(125);
        lcd_gotoxy(0,0);  
                // 0123456789abcdef
        lcd_putsf("  Set Garis     ");
        lcd_gotoxy(0,1);
        lcd_putsf("  Skenario      ");
        
        lcd_gotoxy(0,1);
        lcd_putchar(0); 
        
        if (!sw_ok) {  
                lcd_clear();
                goto setSkenario;
        }
        if (!sw_up) { 
                goto menu03;
        }
        if (!sw_down) {
                lcd_clear();
                goto menu05;
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
        
        switch (kursorPID) {        
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
        
        if (!sw_ok) {
                setByte( 1, kursorPID); 
                delay_ms(200);
        }
        if (!sw_up) {
                if (kursorPID == 3) {
                        kursorPID = 1;        
                } else kursorPID++;
        }
        if (!sw_down) {
                if (kursorPID == 1) {
                        kursorPID = 3;        
                } else kursorPID--;
        } 

        if (!sw_cancel) {   
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
        
        switch (kursorSpeed) {        
          case 1:
                lcd_gotoxy(2,0); // kursor MAX
                lcd_putchar(0);  
                break;
          case 2:
                lcd_gotoxy(9,0); // kursor MIN
                lcd_putchar(0);
                break;  
        }
        
        if (!sw_ok) {
                setByte( 2, kursorSpeed); 
                delay_ms(200);
        }
        if (!sw_up) {
                if (kursorSpeed == 2) {
                        kursorSpeed = 1;        
                } else kursorSpeed++;
        }
        if (!sw_down) {
                if (kursorSpeed == 1) {
                        kursorSpeed = 2;        
                } else kursorSpeed--;
        } 

        if (!sw_cancel) {   
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
        
        switch (kursorGaris) {        
          case 1:
                lcd_gotoxy(0,0); // kursor Warna
                lcd_putchar(0);  
                break;
          case 2:
                lcd_gotoxy(0,1); // kursor SensL
                lcd_putchar(0);
                break;  
        } 
        
        if (!sw_ok) {
                setByte( 3, kursorGaris); 
                delay_ms(200);
        }
        if (!sw_up) {
                if (kursorGaris == 2) {
                        kursorGaris = 1;        
                } else kursorGaris++;
        }
        if (!sw_down) {
                if (kursorGaris == 1) {
                        kursorGaris = 2;        
                } else kursorGaris--;
        }           
        
        if (!sw_cancel) {   
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
        
        if (!sw_ok) {
                setByte( 4, 0); 
                delay_ms(200);
        }
        
        if (!sw_cancel) {   
                lcd_clear();
                goto menu04;
        }
        
        goto setSkenario;
        
     mode:      // Bikin sendiri lhoo ^^d
        delay_ms(125);
        if  (!sw_up)
        {
            if (Mode==5)
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
                Mode=5;
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
            
        if  (!sw_ok)
        {
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
                    test();
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
                    auto_tune();
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

interrupt [TIM0_OVF] void timer0_ovf_isr(void)
{
        xcount++;
        if(xcount<=lpwm)Enki=1;
        else Enki=0;
        if(xcount<=rpwm)Enka=1;
        else Enka=0;
        TCNT0=0xFF; 
}

void maju(){kaplus=1;kamin=0;kirplus=1;kirmin=0;}

void mundur(){kaplus=0;kamin=1;kirplus=0;kirmin=1;}

void bkan(){kaplus=0;kamin=0;kirplus=1;kirmin=0;}

void bkir(){kaplus=1;kamin=0;kirplus=0;kirmin=0;}   

void rotkan(){kaplus=0;kamin=1;kirplus=1;kirmin=0;}

void rotkir(){kaplus=1;kamin=0;kirplus=0;kirmin=1;}   
 
void stop(){ kaplus=0;kamin=0;kirplus=0;kirmin=0; }

void stopSemiReset(){rpwm=0;lpwm=0;kaplus=0;kamin=0;kirplus=0;kirmin=0; }

void cek_sensor()      {
        int t;
        
        lcd_clear();
        delay_ms(125);
                // wait 125ms                             
        lcd_gotoxy(0,0);
                //0123456789abcdef
        lcd_putsf(" Test:Sensor    ");
        
        for (t=0; t<30000; t++) {displaySensorBit();}     
}

void test_ScanLine(){
        int t;
        for (t=0; t<7500; t++)
        {
            displaySensorBit();
            scanBlackLine();
        }
}

void tune_sensor(){
    lcd_clear();
    for(;;)
    {
        displaySensorBit();
        delay_ms(200);
        lcd_clear();
    } 
}

void tune_batas(){
    
    lcd_clear();
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
        
        if(!sw_ok)
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
        
        if(!sw_ok)
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
        
        if(!sw_ok)
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
        
        if(!sw_ok)
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
        
        if(!sw_ok)
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
        
        if(!sw_ok)
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
        
        if(!sw_ok)
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
        
        if(!sw_ok)
        {
            delay_ms(150);
            goto selesai;
        } 
    }
    selesai:
    lcd_clear();
}

void auto_scan(){
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
        
        if (!sw_ok){showMenu();}        
    }
}

void test()  {
        lcd_clear();
        delay_ms(200);
        lcd_gotoxy(0,0);
                 //0123456789abcdef
        lcd_putsf("   Kita Akan    ");
        lcd_gotoxy(0,1);
        lcd_putsf("   Menjalani    ");
        delay_ms(1000);
        lcd_clear();
        
        lcd_clear();
        lcd_gotoxy(0,0);
                 //0123456789abcdef
        lcd_putsf("Serangkaian Test");
        delay_ms(1000);
        lcd_clear();
        
        lcd_clear();
        lcd_gotoxy(0,0);
                 //0123456789abcdef
        lcd_putsf("  Terdiri dari :");
        delay_ms(1000);
        lcd_clear();
        
        lcd_clear();
        lcd_gotoxy(0,0);
                 //0123456789abcdef
        lcd_putsf("Test");
        lcd_gotoxy(0,1);
        lcd_putsf("sensor");
        delay_ms(1500);
        lcd_clear();
        
        lcd_clear();
        lcd_gotoxy(0,0);
                 //0123456789abcdef
        lcd_putsf("Test");
        lcd_gotoxy(0,1);
        lcd_putsf("maju-bkan-bkir");
        delay_ms(1500);
        lcd_clear();
        
        lcd_clear();
        lcd_gotoxy(0,0);
                 //0123456789abcdef
        lcd_putsf("Test");
        lcd_gotoxy(0,1);
        lcd_putsf("mundur-maju-rot");
        delay_ms(1500);
        lcd_clear();
        
        lcd_clear();
        lcd_gotoxy(0,0);
                 //0123456789abcdef
        lcd_putsf("Test");
        lcd_gotoxy(0,1);
        lcd_putsf("kan-rotkir-mun");
        delay_ms(1500);
        lcd_clear();
        
        lcd_clear();
        lcd_gotoxy(0,0);
                 //0123456789abcdef
        lcd_putsf("Test");
        lcd_gotoxy(0,1);
        lcd_putsf("dur             ");
        delay_ms(1000);
        lcd_clear();
        
        lcd_clear();
        lcd_gotoxy(0,0);
                 //0123456789abcdef
        lcd_putsf("Test");
        lcd_gotoxy(0,1);
        lcd_putsf("Scan.Line");
        delay_ms(1000);
        lcd_clear();
        
        lpwm=0;
        rpwm=0;
        stop();
    
        delay_ms(10);
        lpwm=10;
        rpwm=10;
        
        
        test_sensor();
    
        lcd_clear();
        lcd_gotoxy(0,0);
                //0123456789abcdef
        lcd_putsf(" Test:Maju      ");
        maju();
        delay_ms(500);
        lpwm=10;
        rpwm=10;
        
        delay_ms(500);
        lpwm=10;
        rpwm=10;
        
        delay_ms(500);
        lpwm=50;
        rpwm=20;
        
        delay_ms(500);
        lpwm=30;
        rpwm=30;
        
        delay_ms(500);
        lpwm=40;
        rpwm=40;
        
        delay_ms(500);
        lpwm=50;
        rpwm=50;
        
        delay_ms(500);
        lpwm=60;
        rpwm=60;
        
        delay_ms(500);
        lpwm=70;
        rpwm=70;
        
        delay_ms(500);
        lpwm=80;
        rpwm=80;
        
        delay_ms(500);
        lpwm=90;
        rpwm=90;
        
        delay_ms(500);
        lpwm=100;
        rpwm=100;
        
        delay_ms(500);
        lpwm=110;
        rpwm=110;
        
        delay_ms(500);
        lpwm=120;
        rpwm=120;
        
        delay_ms(500);
        lpwm=130;
        rpwm=130;
        
        delay_ms(500);
        lpwm=140;
        rpwm=140;
        
        delay_ms(500);
        lpwm=150;
        rpwm=150;
        
        delay_ms(500);
        lpwm=250;
        rpwm=250;
        
        lcd_clear();
        lcd_gotoxy(0,0);
                //0123456789abcdef
        lcd_putsf(" Test:B.Kanan   ");
        bkan();
        delay_ms(7000);
        
        lcd_clear();
        lcd_gotoxy(0,0);
                //0123456789abcdef
        lcd_putsf(" Test:B.Kiri    ");
        bkir();
        delay_ms(7000);
        
        lcd_clear();
        lcd_gotoxy(0,0);
                //0123456789abcdef
        lcd_putsf(" Test:Mundur    ");
        mundur();
        delay_ms(7000);
        
        lcd_clear();
        lcd_gotoxy(0,0);
                //0123456789abcdef
        lcd_putsf(" Test:Maju      ");
        maju();
        delay_ms(7000);
    
        lcd_clear();
        lcd_gotoxy(0,0);
                //0123456789abcdef
        lcd_putsf(" Test:Rot.Kanan");
        rotkan();
        delay_ms(7000);
        
        lcd_clear();
        lcd_gotoxy(0,0);
                //0123456789abcdef
        lcd_putsf(" Test:Rot.Kiri ");
        rotkir();
        delay_ms(7000);
        
        lcd_clear();
        lcd_gotoxy(0,0);
                //0123456789abcdef
        lcd_putsf(" Test:Mundur    ");
        mundur();
        delay_ms(7000);
        
        lcd_clear();
        lcd_gotoxy(0,0);
                //0123456789abcdef
        lcd_putsf(" Test:Scan.Line ");
        delay_ms(900);
        lcd_clear();
        lcd_gotoxy(0,0);
        lcd_putsf(" Letakkan Sensor");
        lcd_gotoxy(0,1);
        lcd_putsf("     Di Arena   ");
        delay_ms(900);
        lcd_clear();
        maju();
        test_ScanLine();
            
            //-----------akhir test----------//
            
        stopSemiReset();
} 


void scanBlackLine() {

    switch(sensor) { 
        case 0b00000001:        // ujung kanan        
                PV = 7;
                maju();
                break;
        case 0b00000111:
                PV = 7;
                maju();
                break;        
        case 0b00000011:        
                PV = 6;
                maju();
                break;
        case 0b00000010:        
                PV = 5;
                maju();
                break;
        case 0b00001110:
                PV = 5;
                maju();
                break;        
        case 0b00000110:        
                PV = 4;
                maju();
                break;
        case 0b00000100:        
                PV = 3;
                maju();
                break;
        case 0b00011100:
                PV = 3;
                maju();
                break;        
        case 0b00001100:        
                PV = 2;
                maju();
                break;
        case 0b00001000:        
                PV = 1;
                maju();
                break;
        case 0b00011000:        // tengah        
                PV = 0;
                maju();           
                break;
        case 0b00010000:
                PV = -1;
                maju();     
                break;
        case 0b00111000:
                PV = -1;
                maju();     
                break;
        case 0b00110000:        
                PV = -2;
                maju();
                break;
        case 0b00100000:        
                PV = -3;
                maju();   
                break;
        case 0b01110000:
                PV = -4;
                maju();    
                break;
        case 0b01100000:        
                PV = -4;
                maju();    
                break;
        case 0b01000000:        
                PV = -5;
                maju(); 
                break;
        case 0b11100000:
                PV = -6;
                maju();  
                break;
        case 0b11000000:        
                PV = -6;
                maju();  
                break;
        case 0b10000000:        // ujung kiri        
                PV = -7;
                maju();      
                break;
        case 0b00000000:        // loss
                if (PV < 0) {
                        PV = -8;
                        lpwm = 150; 
                        rpwm = 185;
                        bkir();
                        goto exit;
                
                } 
                
                else if (PV > 0) {
                        PV = 8;
                        lpwm = 180; 
                        rpwm = 155;
                        bkan();
                        goto exit;
                } 
    }
    
        error = SP - PV;
        P = (var_Kp * error) / 8;  
    
        I = I + error;
        I = (I * var_Ki) / 8;
    
        rate = error - last_error;
        D    = (rate * var_Kd) / 8;
    
        last_error = error; 
    
        MV = P + I + D;
    
        if (MV == 0) 
        {
            lpwm = MAXPWM - diffPWM;
            rpwm = MAXPWM;
        } 
        
        else if (MV > 0) 
        {   // alihkan ke kiri
            rpwm = MAXPWM - ((intervalPWM - 20) * MV);
            lpwm = (MAXPWM - (intervalPWM * MV) - 15) - diffPWM;
    
            //rpwm = MAXPWM - ((intervalPWM - 12) * MV);
            //lpwm = (MAXPWM - (intervalPWM * MV)) - diffPWM;
        
            if (lpwm < MINPWM) lpwm = MINPWM;
            if (lpwm > MAXPWM) lpwm = MAXPWM;
            if (rpwm < MINPWM) rpwm = MINPWM;
            if (rpwm > MAXPWM) rpwm = MAXPWM;
        } 
        
        else if (MV < 0) 
        {   // alihkan ke kanan
            lpwm = MAXPWM + ( ( intervalPWM - 20 ) * MV);
            rpwm = MAXPWM + ( ( intervalPWM * MV ) - 15 ); 
        
            if (lpwm < MINPWM) lpwm = MINPWM;
            if (lpwm > MAXPWM) lpwm = MAXPWM;
            if (rpwm < MINPWM) rpwm = MINPWM;
            if (rpwm > MAXPWM) rpwm = MAXPWM;
        
            //lpwm = MAXPWM + ( ((intervalPWM - 12) + 5) * MV);
            //rpwm = MAXPWM + ((intervalPWM * MV) * MV); 
        } 
    
    exit:
    
    sprintf(lcd_buffer,"%d   %d",lpwm, rpwm);
    lcd_gotoxy(0, 0);
    lcd_putsf("                ");
    lcd_gotoxy(0, 0);
    lcd_puts(lcd_buffer);
    delay_ms(5);     
}

void tampil_eror()
{
    lcd_clear();
    lcd_gotoxy(13,1);
    sprintf(lcd,"%d",error);
    lcd_puts(lcd);
    delay_ms(200);
}
