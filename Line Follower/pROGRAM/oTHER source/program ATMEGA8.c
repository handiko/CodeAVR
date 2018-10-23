/*****************************************************
beta5.c tes driver baru
algritma cabang belum di tes sama black corner
*****************************************************/

#include <mega8.h>
#include <stdio.h>
#include <math.h>

// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x12 ;PORTD
#endasm
#include <lcd.h>

#include <delay.h>

#define led           PORTB.6
#define backlight     PORTB.7

#define ADC_VREF_TYPE 0x60
#define enter   PINB.4
#define back    PINB.5

#define dir_ki   PORTB.0 
#define dir_ka   PORTB.3
#define pwm_ki   OCR1A
#define pwm_ka   OCR1B
 
bit adaptif=0,pwm_en,black_line=1;
unsigned char menu;
unsigned char adc_result1[8],adc_result2[8],adc_limit1[8],adc_limit2[8],adc_menu,lcd[16];
unsigned char max_adc1[8],max_adc2[8],min_adc1[8],min_adc2[8];
unsigned char i,j,front_sensor,rear_sensor,backlight_on,led_on,right_back,left_back;
int init_speed,speed,MV,error,error_before,dif_error,kp,kd,speed_ka,speed_ki;
bit menu_tes, strategi_status, ngenos, ngenos_before;
unsigned char perempatan, fork_status, kiridepan_sensor, kanandepan_sensor,habis_blackcorner;
unsigned char kode,rear_sensor1, rear_sensor3, dif_speed, masih_perempatan, delay_rem, habis_45, ngenos_on;
int bagikp;

eeprom int e_speed=200,e_bagikp=14;
eeprom unsigned char e_adc_limit1[8]={100,100,100,100,100,100,100,100};
eeprom unsigned char e_adc_limit2[8]={100,100,100,100,100,100,100,100};

eeprom unsigned char e_fork_status1[10]={2,2,2,2,2,2,2,2,2,2};  //latihan
eeprom unsigned char e_fork_status2[10]={0,2,0,0,0,0,0,0,0,0};  //kualifikasi
eeprom unsigned char e_fork_status3[10]={0,2,0,1,0,0,0,0,0,0};  //final

eeprom int e_speed_ka[12]={100,255,-100,-255,0,0,0,0,100,255,-100,-255};
eeprom int e_speed_ki[12]={0,0,0,0,100,255,-100,-255,100,255,-100,-255};
eeprom unsigned char e_delay_rem=1;

void pwm_on()
{
pwm_en=1;
TCCR1A=0xA1;
TCCR1B=0x03;
}

void pwm_off()
{
pwm_en=0;
dir_ki=0;
dir_ka=0;
TCCR1A=0x00;
TCCR1B=0x00;
}
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


void read_sensor()
{
front_sensor=0;
rear_sensor=0;

for(i=0;i<8;i++)
    {
    PORTC=i;
    adc_result1[i]=read_adc(3);
    adc_result2[i]=read_adc(4);
    }

for(i=0;i<8;i++)
    {
    if      (adc_result1[i]>adc_limit1[i]){front_sensor=front_sensor|1<<i;}
    else if (adc_result1[i]<adc_limit1[i]){front_sensor=front_sensor|0<<i;}
    
    if      (adc_result2[i]>adc_limit2[i]){rear_sensor=rear_sensor|1<<i;}
    else if (adc_result2[i]<adc_limit2[i]){rear_sensor=rear_sensor|0<<i;}
    }

kiridepan_sensor =(front_sensor)&(0b00000011);    
kanandepan_sensor =(front_sensor)&(0b11000000);
rear_sensor1=(rear_sensor)&(0b00011000);
rear_sensor3=(rear_sensor)&(0b01000010);
}

void tampil_kode()
{
lcd_clear();sprintf(lcd,"%d",kode);lcd_puts(lcd);
}

void tampil_run()
{
if      (speed_ka>255)  speed_ka  =255;
else if (speed_ka<-255) speed_ka  =-255; 

if      (speed_ki>255)  speed_ki  =255;
else if (speed_ki<-255) speed_ki  =-255;

    



/***************
11100111 e16 
11100111 s22  2>   
***************/
    
for (i=0;i<8;i++)
        {
        lcd_gotoxy(i,0);
        if (adc_result1[(i)]<adc_limit1[i]) lcd_putsf("0"); else lcd_putsf("1");
        }

for (i=0;i<8;i++)
        {
        lcd_gotoxy(i,1);
        if (adc_result2[(i)]<adc_limit2[i]) lcd_putsf("0"); else lcd_putsf("1");
        }    

lcd_gotoxy(9,0);
sprintf(lcd,"e%d ",error); 
lcd_puts(lcd);


/*
lcd_gotoxy(9,0);
sprintf(lcd,"%d ",(speed_ki/10)); 
lcd_puts(lcd);
   
lcd_gotoxy(13,0); 
sprintf(lcd,"%d ",(speed_ka/10)); 
lcd_puts(lcd); 

*/

lcd_gotoxy(9,1); 
sprintf(lcd,"s%d ",speed); 
lcd_puts(lcd); 

lcd_gotoxy(14,1); 
sprintf(lcd,"%d ",perempatan); 
lcd_puts(lcd); 

switch (fork_status)
    {
    case 0: lcd_gotoxy(15,1);lcd_putsf("|");break;
    case 1: lcd_gotoxy(15,1);lcd_putsf("<");break;
    case 2: lcd_gotoxy(15,1);lcd_putsf(">");break;
    }


}

void ka_maju()
{
dir_ka=0;
pwm_ka=speed_ka;
}

void ka_mund()
{
if(pwm_en==1)dir_ka  =1;
speed_ka=255+speed_ka;
pwm_ka  =speed_ka;
}

void ki_maju()
{
dir_ki=0;
pwm_ki=speed_ki;
}

void ki_mund()
{
if(pwm_en==1)dir_ki  =1;
speed_ki=255+speed_ki;
pwm_ki  =speed_ki;
}

void pwm_out()
{

if      (speed_ka >=0)  ka_maju();
else if (speed_ka <0)   ka_mund();

if      (speed_ki >=0)  ki_maju();
else if (speed_ki <0)   ki_mund();
}

void komp_pid()
{
kp=speed/bagikp;
kd=kp*4;

dif_error =error-error_before;
MV      =(kp*error)+(kd*dif_error);

speed_ka=init_speed+MV;
speed_ki=init_speed-MV;

error_before=error; 

if (speed_ka>speed_ki&&speed_ka>255){dif_speed=speed_ka-speed_ki;speed_ki=speed_ki-dif_speed;}
if (speed_ki>speed_ka&&speed_ki>255){dif_speed=speed_ki-speed_ka;speed_ka=speed_ka-dif_speed;}
       
}

void per4an_kanan()
{
speed_ki=speed/2;speed_ka=-speed;pwm_out();
for(;;)
        {
        delay_us(800);
        read_sensor();
        lcd_clear();lcd_putsf("kanan +++"); 
        if(kanandepan_sensor!=0)break;
        };
}

void per4an_kiri()
{
speed_ki=-speed;speed_ka=speed/2;pwm_out();
for(;;)
        {
        delay_us(800);
        read_sensor();
        lcd_clear();lcd_putsf("kiri +++"); 
        if(kiridepan_sensor!=0)break;
        };
}

void lurus()
{
speed_ki= speed;speed_ka=speed; pwm_out();
/*
for(;;)
        {
        delay_ms(1);
        read_sensor(); //sampe sensor paling belakang kena
        if(rear_sensor==0b00000010||rear_sensor==0b01000010||rear_sensor==0b01000000)break;
        lcd_clear();lcd_putsf("  lurus"); 
        if(rear_sensor3!=0)break;
        };

*/
}

void rem()
{
speed_ka=-speed;speed_ki=-speed;pwm_out();delay_ms(delay_rem);
}

void berhenti()
{
speed_ka=0;speed_ki=0;pwm_out();
}

void fork_Y()
{
switch (fork_status)
    {
    case 1: error=  14;break;
    case 2: error= -14;break;
    }
}

void scan_Y()
{
switch(front_sensor)
        {
        case 0b01000010:fork_Y();backlight_on=2;break;
        case 0b10000001:fork_Y();backlight_on=2;break;
        case 0b11000011:fork_Y();backlight_on=2;break;
        case 0b10000011:fork_Y();backlight_on=2;break;
        case 0b11000001:fork_Y();backlight_on=2;break;
        case 0b11000110:fork_Y();backlight_on=2;break;
        case 0b01100011:fork_Y();backlight_on=2;break;
        case 0b01000011:fork_Y();backlight_on=2;break;
        case 0b01100010:fork_Y();backlight_on=2;break;
        }
}

void cross_handler()
{
if (strategi_status==1&&masih_perempatan==0&&habis_45==0)
        {
        rem();berhenti();delay_ms(1);backlight=1;led=0;
        if (perempatan>9){perempatan=0;}
        switch (perempatan)
        {
        case 0:lurus();delay_ms(100);break;
        case 1:per4an_kanan();break;
        case 2:lurus();delay_ms(100);break;
        case 3:per4an_kiri();break;
        case 4:lurus();delay_ms(100);break;
        case 5:lurus();delay_ms(100);break;
        case 6:lurus();delay_ms(100);break;
        case 7:lurus();delay_ms(100);break;
        case 8:lurus();delay_ms(100);break;
        case 9:lurus();delay_ms(100);break;
        }
    
    
    /*
    switch (strategi_status)
        {
        case 1:fork_status= e_fork_status1[perempatan];break;  //latihan
        case 2:fork_status= e_fork_status2[perempatan];break;  //kualifikasi
        case 3:fork_status= e_fork_status3[perempatan];break;  //final
        }
    switch (fork_status)
        {
        case 0:lurus();break;
        case 1:per4an_kiri();break;
        case 2:per4an_kanan();break;
        }
    
    */
    
        perempatan++;masih_perempatan=15;    
        led=1;backlight=0;
        }
}

void blackcorner()
{
if(black_line==0) 
    {
    if(front_sensor==0b11111111)
        {
        
//if (rear_sensor==0b01101110||rear_sensor==0b01011110||rear_sensor==0b01001110)   
//                {
//                if (error_before <4)   //depan belakang sama2 kiri
//                        {
                        rem();berhenti();delay_ms(1);
                        speed_ki=speed/2;speed_ka=-speed;pwm_out();
                        for(;;)
                                {
                                delay_us(700);
                                read_sensor();kode=7;tampil_kode();
                                if(front_sensor!=0b11111111)break;
                                };
  //                      }        
              //  }
        }
    }
}

void blackline1()
{
switch(front_sensor)
    {
    case 0b00000001:error=  14;break;
    case 0b00000010:error=   10;break;
    case 0b00000100:error=   4;break;
    case 0b00001000:error=   1;break;
    case 0b00010000:error=  -1;break;
    case 0b00100000:error=  -4;break;
    case 0b01000000:error= -10;break;
    case 0b10000000:error= -14;break;
    }
}

void blackout1()
{              
switch(front_sensor)
    {
    case 0b11111110:error=  14;black_line=0;break;
    case 0b11111101:error=  10;black_line=0;break;
    case 0b11111011:error=   4;black_line=0;break;
    case 0b11110111:error=   1;black_line=0;break;
    case 0b11101111:error=  -1;black_line=0;break;
    case 0b11011111:error=  -4;black_line=0;break;
    case 0b10111111:error= -10;black_line=0;break;
    case 0b01111111:error= -14;black_line=0;break;
    }
}

void blackline2()
{
switch(front_sensor)
    {
    case 0b00000011:error=   12;break;
    case 0b00000110:error=   7;break;
    case 0b00001100:error=   2;break;
    case 0b00011000:error=   0;break;
    case 0b00110000:error=  -2;break;
    case 0b01100000:error=  -7;break;
    case 0b11000000:error= -12;break;
    }
}

void blackout2()
{
switch(front_sensor)
    {
    case 0b11111100:error=  12;black_line=0;break;
    case 0b11111001:error=   7;black_line=0;break;
    case 0b11110011:error=   2;black_line=0;break;
    case 0b11100111:error=   0;black_line=0;break;
    case 0b11001111:error=  -2;black_line=0;break;
    case 0b10011111:error=  -7;black_line=0;break;
    case 0b00111111:error= -12;black_line=0;break;
    }
}

void action()
{
speed=e_speed;
j=0;
for(;;)
    {
    read_sensor();
    if (ngenos_on>0){ngenos_on--;ngenos=1;}else {ngenos=0;}
    if (habis_blackcorner>0){habis_blackcorner--;}
    if (habis_45>0){habis_45--;}    
    if (masih_perempatan>0){masih_perempatan--;}    
    if(right_back>0){right_back--;}
    if(left_back>0){left_back--;}
    
    if(backlight_on>0){backlight_on--;backlight=1;}
    else               backlight=0; 
    
    if(led_on>0){led_on--;led=0;}
    else         led=1;
    
    if (ngenos==1){speed=240;}else if (ngenos==0){speed=e_speed;}
    if(init_speed<speed)   init_speed=init_speed+3;
    else                init_speed=speed;

    rear_sensor=rear_sensor&0b01111110;
    black_line=1;
    blackline1();
    blackline2();
    blackout1();
    blackout2();
    
    if (enter==0){if (fork_status>=2) fork_status=0; else fork_status++;delay_ms(300);}

    if (rear_sensor1!=0&&rear_sensor3!=0){black_line=0;habis_blackcorner=15;}
    
    if (black_line==0){led_on=3;ngenos=0;}
    //if (ngenos_before==1&&ngenos==0){speed_ka=-speed;speed_ki=-speed;pwm_out();delay_ms(50);berhenti();delay_ms(5);}
    //ngenos_before=ngenos;
    if (black_line==1){scan_Y();}
    
    komp_pid();
    
    
    blackcorner(); //32 final
        //
        //
   ////////////
        //
        //
    if(black_line==1)
    {
    if(error>-11&&error<11) //khusus perempatan
        {
        if      (rear_sensor==0b00010000||rear_sensor==0b00110000||rear_sensor==0b00100000/*||rear_sensor==0b10000000*/)
            {
                right_back=15;
                if(left_back>0){backlight_on=10;kode=1;tampil_kode();cross_handler();}
            }
        else if (rear_sensor==0b00001000||rear_sensor==0b00001100||rear_sensor==0b00000100/*||rear_sensor==0b00000001*/)
            {
                left_back=15;
                if(right_back>0){backlight_on=10;kode=2;tampil_kode();cross_handler();}
            }
        else if(rear_sensor==0b00011000||rear_sensor==0b00100100||rear_sensor==0b00111100
                ||rear_sensor==0b00101100||rear_sensor==0b00110100)
                {backlight_on=10;kode=3;tampil_kode();rem();cross_handler();}
        }
    }
    
                ///////////     ////
                //              //  //
                //              //    //
                //              //      //
    
    if(black_line==1) 
    {
    if(front_sensor==0)
        {
        if      (rear_sensor==0b00001000||rear_sensor==0b00000100||rear_sensor==0b00001100/*||rear_sensor==0b00000010*/)   
                {
                if (error>-4/*&&habis_blackcorner==0*/)
                        {
                        rem();backlight=1;
                        speed_ki=-speed;speed_ka=speed/2;pwm_out();
                        for(;;)
                                {
                                delay_us(700);
                                read_sensor();kode=4;tampil_kode();
                                if(front_sensor!=0)break;
                                };
                        backlight=0;habis_45=15;
                        }
                }
        else if (rear_sensor==0b00010000||rear_sensor==0b00100000||rear_sensor==0b00110000/*||rear_sensor==0b01000000*/)   
                {
                if (error<4/*&&habis_blackcorner==0*/)   //depan belakang sama2 kiri
                        {
                        rem();backlight=1;
                        speed_ki=speed/2;speed_ka=-speed;pwm_out();
                        for(;;)
                                {
                                delay_us(700);
                                read_sensor();kode=5;tampil_kode();
                                if(front_sensor!=0)break;
                                };
                        backlight=0;habis_45=15;
                        }        
                }
        }
    }
    
    tampil_run();
    pwm_out();    
    
    if(j>=200)
        {
        //if(enter==0)break;
        if(back==0) break;
        }
    j++;
    if(j>200)j=200;
    delay_us(700);
    }
pwm_off();
//led=0;
led=1;
backlight=0;
delay_ms(400);
}

void tes_sensor()
{
lihat_adc1:
lcd_clear();
    for(i=0;i<8;i++)
        {
        PORTC=i;
        adc_result1[i]=read_adc(3);
        }

lcd_gotoxy(0,0);sprintf(lcd,"%d",adc_result1[0]);lcd_puts(lcd);
lcd_gotoxy(4,0);sprintf(lcd,"%d",adc_result1[1]);lcd_puts(lcd);
lcd_gotoxy(8,0);sprintf(lcd,"%d",adc_result1[2]);lcd_puts(lcd);
lcd_gotoxy(12,0);sprintf(lcd,"%d",adc_result1[3]);lcd_puts(lcd);
lcd_gotoxy(0,1);sprintf(lcd,"%d",adc_result1[4]);lcd_puts(lcd);
lcd_gotoxy(4,1);sprintf(lcd,"%d",adc_result1[5]);lcd_puts(lcd);
lcd_gotoxy(8,1);sprintf(lcd,"%d",adc_result1[6]);lcd_puts(lcd);
lcd_gotoxy(12,1);sprintf(lcd,"%d",adc_result1[7]);lcd_puts(lcd);
        

if (enter==0){delay_ms(400);lcd_clear();goto lihat_adc2;}
if (back==0){delay_ms(400);goto lihat_adc_n;}
delay_ms(10);

goto lihat_adc1;

lihat_adc2:
lcd_clear();
    for(i=0;i<8;i++)
        {
        PORTC=i;
        adc_result2[i]=read_adc(4);
        }

lcd_gotoxy(0,0);sprintf(lcd,"%d",adc_result2[0]);lcd_puts(lcd);
lcd_gotoxy(4,0);sprintf(lcd,"%d",adc_result2[1]);lcd_puts(lcd);
lcd_gotoxy(8,0);sprintf(lcd,"%d",adc_result2[2]);lcd_puts(lcd);
lcd_gotoxy(12,0);sprintf(lcd,"%d",adc_result2[3]);lcd_puts(lcd);
lcd_gotoxy(0,1);sprintf(lcd,"%d",adc_result2[4]);lcd_puts(lcd);
lcd_gotoxy(4,1);sprintf(lcd,"%d",adc_result2[5]);lcd_puts(lcd);
lcd_gotoxy(8,1);sprintf(lcd,"%d",adc_result2[6]);lcd_puts(lcd);
lcd_gotoxy(12,1);sprintf(lcd,"%d",adc_result2[7]);lcd_puts(lcd);

if (enter==0){delay_ms(400);lcd_clear();goto lihat_adc_n;}
if (back==0){delay_ms(400);goto lihat_adc_n;}
delay_ms(10);

goto lihat_adc2;

lihat_adc_n:

}

void tampil_driver ()
{
lcd_clear();lcd_gotoxy(0,1);sprintf(lcd,"%d %d",speed_ki,speed_ka); lcd_puts(lcd);
}


void tes_driver()
{
pwm_on();

kanan_maju_full:
        speed_ki=0;ki_maju();
tampil_driver();
speed_ka=255;ka_maju();
if (enter==0) {delay_ms(400);goto kanan_maju_pelan;}
if (back==0) {goto completed_test;}
goto kanan_maju_full;

kanan_maju_pelan:
tampil_driver();
speed_ka=100;ka_maju();
if (enter==0) {delay_ms(400);goto kanan_mundur_full;}
if (back==0) goto completed_test;
goto kanan_maju_pelan;

kanan_mundur_full:
tampil_driver();
speed_ka=-255;ka_mund();
if (enter==0) {delay_ms(400);goto kanan_mundur_pelan;}
if (back==0) goto completed_test;
goto kanan_mundur_full;

kanan_mundur_pelan:
tampil_driver();
speed_ka=-100;ka_mund();
if (enter==0) {delay_ms(400);goto kiri_maju_full;}
if (back==0) goto completed_test;
goto kanan_mundur_pelan;

kiri_maju_full:
    speed_ka=0;ka_maju();

tampil_driver();
speed_ki=255;ki_maju();
if (enter==0) {delay_ms(400);goto kiri_maju_pelan;}
if (back==0) goto completed_test;
goto kiri_maju_full;

kiri_maju_pelan:
tampil_driver();
speed_ki=100;ki_maju();
if (enter==0) {delay_ms(400);goto kiri_mundur_full;}
if (back==0) goto completed_test;
goto kiri_maju_pelan;

kiri_mundur_full:
tampil_driver();
speed_ki=-255;ki_mund();
if (enter==0) {delay_ms(400);goto kiri_mundur_pelan;}
if (back==0) goto completed_test;
goto kiri_mundur_full;

kiri_mundur_pelan:
tampil_driver();
speed_ki=-100;ki_mund();
if (enter==0) {delay_ms(400);goto maju_full;}
if (back==0) goto completed_test;
goto kiri_mundur_pelan;

maju_full:
tampil_driver();
speed_ka=255;ka_maju();
speed_ki=255;ki_maju();
if (enter==0) {delay_ms(400);goto maju_pelan;}
if (back==0) goto completed_test;
goto maju_full;

maju_pelan:
tampil_driver();
speed_ka=100;ka_maju();
speed_ki=100;ki_maju();
if (enter==0) {delay_ms(400);goto mundur_full;}
if (back==0) goto completed_test;
goto maju_pelan;

mundur_full:
tampil_driver();
speed_ka=-255;ka_mund();
speed_ki=-255;ki_mund();
if (enter==0) {delay_ms(400);goto mundur_pelan;}
if (back==0) goto completed_test;
goto mundur_full;

mundur_pelan:
tampil_driver();
speed_ka=-100;ka_mund();
speed_ki=-100;ki_mund();
if (enter==0) {delay_ms(400);goto completed_test;}
if (back==0) goto completed_test;
goto mundur_pelan;


completed_test:

delay_ms(200);
speed_ka=0;speed_ki=0;pwm_out();pwm_off();
delay_ms(200);
}


void tampil_auto_set()
{

lcd_gotoxy(0,0);
sprintf(lcd,"%d%d%d%d%d%d%d%d",adc_limit1[0]/10,adc_limit1[1]/10,adc_limit1[2]/10,adc_limit1[3]/10,adc_limit1[4]/10,adc_limit1[5]/10,adc_limit1[6]/10,adc_limit1[7]/10);
lcd_puts(lcd);

lcd_gotoxy(0,1);
sprintf(lcd,"%d%d%d%d%d%d%d%d",adc_limit2[0]/10,adc_limit2[1]/10,adc_limit2[2]/10,adc_limit2[3]/10,adc_limit2[4]/10,adc_limit2[5]/10,adc_limit2[6]/10,adc_limit2[7]/10);
lcd_puts(lcd);
    
for(;;)
    {
    delay_ms(200);
    if(enter==0)
        {
        delay_ms(200);
        break;
        }
    if(back==0)goto selesai;
    }
    
for(;;)
    {
    //lcd_clear();
    for(i=0;i<8;i++)
        {
        PORTC=i;
        adc_result1[i]=read_adc(3);
        }                                                
      
    for(i=0;i<8;i++)
        {
        if(adc_result1[i]>max_adc1[i])max_adc1[i]=adc_result1[i];
        if(adc_result1[i]<min_adc1[i])min_adc1[i]=adc_result1[i];        
        //adc_limit1[i]=min_adc1[i]+((max_adc1[i]-min_adc1[i])/3);
        adc_limit1[i]=min_adc1[i]+30;
        
        delay_us(50);
        lcd_gotoxy((i*2),0);
        sprintf(lcd,"%d",max_adc1[i]/10);
        lcd_puts(lcd);
        }
       
    for(i=0;i<8;i++)
        {
        PORTC=i;
        adc_result2[i]=read_adc(4);
        }
    for(i=0;i<8;i++)
        {
        if(adc_result2[i]>max_adc2[i])max_adc2[i]=adc_result2[i];        
        if(adc_result2[i]<min_adc2[i])min_adc2[i]=adc_result2[i];        
        //adc_limit2[i]=min_adc2[i]+((max_adc2[i]-min_adc2[i])/3);
        adc_limit2[i]=min_adc2[i]+30;
        delay_us(50);
                
        lcd_gotoxy((i*2),1);
        sprintf(lcd,"%d",max_adc2[i]/10);
        lcd_puts(lcd);
        }
    
    delay_us(600);
    if(enter==0)
        {
        for(i=0;i<8;i++)
            {
            e_adc_limit1[i]=adc_limit1[i];
            e_adc_limit2[i]=adc_limit2[i];
            }
        break;
        }
    if(back==0)break;
    }
selesai:
for(i=0;i<8;i++){adc_limit1[i]=e_adc_limit1[i];adc_limit2[i]=e_adc_limit2[i];}
lcd_clear();lcd_putsf("done");delay_ms(500);
}

void tampil_speed()
{
lcd_clear();
lcd_gotoxy(0,1);
sprintf(lcd,"=%d",speed);
lcd_puts(lcd);
for(;;)
    {
    adc_menu=read_adc(5);
    adc_menu=255-adc_menu;
    
    lcd_gotoxy(8,1);
    lcd_putsf("   ");
    lcd_gotoxy(5,1);
    sprintf(lcd,"<= %d",adc_menu);
    lcd_puts(lcd);
    
    if(enter==0){e_speed=adc_menu;speed=adc_menu;lcd_clear();lcd_putsf("done");delay_ms(500);break;}
    if(back==0){delay_ms(400);break;}
    delay_ms(50);
    }
}

void atur_delay_rem()
{
lcd_clear();
lcd_gotoxy(0,1);
sprintf(lcd,"=%d",delay_rem);
lcd_puts(lcd);
for(;;)
    {
    adc_menu=read_adc(5);
    adc_menu=255-adc_menu;
    
    lcd_gotoxy(8,1);
    lcd_putsf("   ");
    lcd_gotoxy(5,1);
    sprintf(lcd,"<= %d",(adc_menu));
    lcd_puts(lcd);
    
    if(enter==0){e_delay_rem=(adc_menu);delay_rem=(adc_menu);lcd_clear();lcd_putsf("done");delay_ms(500);break;}
    if(back==0){delay_ms(400);break;}
    delay_ms(50);
    }

}

void atur_kp()
{
lcd_clear();
lcd_gotoxy(0,1);
sprintf(lcd,"=%d",bagikp);
lcd_puts(lcd);
for(;;)
    {
    adc_menu=read_adc(5);
    adc_menu=255-adc_menu;
    
    lcd_gotoxy(8,1);
    lcd_putsf("   ");
    lcd_gotoxy(5,1);
    sprintf(lcd,"<= %d",(adc_menu/5));
    lcd_puts(lcd);
    
    if(enter==0){e_bagikp=(adc_menu/5);bagikp=(adc_menu/5);lcd_clear();lcd_putsf("done");delay_ms(500);break;}
    if(back==0){delay_ms(400);break;}
    delay_ms(50);
    }
}

void tampil_menu()
{
menu=0;
for(;;)
    {
    adc_menu=read_adc(5);
    adc_menu=255-adc_menu;
    lcd_clear();
    lcd_gotoxy(0,1);
    switch (menu_tes)
        {
        case 0: if      (adc_menu<=126){lcd_putsf("1. AutoCalb");menu=1;}
                else if (adc_menu<=255){lcd_putsf("2. Speed");menu=2;}
                break;
        case 1: if      (adc_menu<=80){lcd_putsf("3. Tes Sensor");menu=3;}
                else if (adc_menu<=160){lcd_putsf("4. Tes Driver");menu=4;}
                else if (adc_menu<=200){lcd_putsf("5. Pembagi Kp");menu=5;}
                else if (adc_menu<=255){lcd_putsf("6. Delay Rem");menu=6;}
                break;
        }
    if(enter==0)
        {
        lcd_clear();delay_ms(400);
        if      (menu==1)
            {
            for(i=0;i<8;i++)
                {
                min_adc1[i]=255;
                min_adc2[i]=255;
                max_adc1[i]=0;
                max_adc2[i]=0;
                }
            tampil_auto_set();
            }
        else if (menu==2){tampil_speed();}    
        else if (menu==3){tes_sensor();}    
        else if (menu==4){tes_driver();}    
        else if (menu==5){atur_kp();}    
        else if (menu==6){atur_delay_rem();}    
        }
    if(back==0){lcd_clear();delay_ms(400);menu=0;break;}
    delay_ms(50);
    }
}

void intro()
{
for(;;)
    {
    lcd_clear();
    lcd_gotoxy(0,0);
    lcd_putsf("menu =>");
    
    strategi_status=0;
  
    adc_menu=read_adc(5);
    adc_menu=255-adc_menu;
    
    if      (adc_menu<=140)
        {
        lcd_gotoxy(0,1);lcd_putsf("latihan");  
        }
    else if (adc_menu<=255) 
        {
        lcd_gotoxy(0,1);lcd_putsf("strategi"); 
        strategi_status=1;
        } 
    //if(back==0){delay_ms(250);tampil_menu();}
    if(back==0)
        {
        i=0;
        while(back==0){delay_ms(10);i++;if(i>200)i=200;}
        if(i>20)    {menu_tes=1;tampil_menu();}
        else        {menu_tes=0;tampil_menu();}
        }
    

    if(enter==0)
        {
        i=0;
        while(enter==0){delay_ms(10);i++;if(i>200)i=200;}
        if(i>20)    {pwm_on();init_speed=60;bagikp  =e_bagikp;action();}
        else        {pwm_off();init_speed=60;bagikp  =e_bagikp;action();}
        }
    delay_ms(200);
    }
}

void main(void)
{
PORTC   =0x00;
DDRC    =0b00000111;  // 1output

PORTB   =0b01110000;
DDRB    =0b11001111;

PORTD   =0x00;
DDRD    =0x00;

ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x86;

// LCD module initialization
lcd_init(16);

backlight=1;
led=0;
lcd_gotoxy(7,0);
lcd_putsf("88"); 
lcd_gotoxy(0,1);
lcd_putsf("Wendy & Denny"); 
delay_ms(400);
lcd_clear();
lcd_gotoxy(7,0);
lcd_putsf("88"); 
lcd_gotoxy(0,1);
lcd_putsf("Roborace2009"); 
delay_ms(400);
 
delay_ms(200);
led=1;
delay_ms(200);
led=0;
backlight=0;
delay_ms(200);
led=1;
delay_ms(200);
led=0;
backlight=1;
delay_ms(200);
backlight=0;
led=1;

fork_status=0;
kode=0;
perempatan=0;
right_back=0;
left_back=0;

ngenos=1;ngenos_on=500;
habis_blackcorner=0;
habis_45=0;
masih_perempatan=0;
speed   =e_speed;
bagikp  =e_bagikp;
delay_rem=e_delay_rem;
for(i=0;i<8;i++)
    {
    adc_limit1[i]=e_adc_limit1[i];
    adc_limit2[i]=e_adc_limit2[i];
    }
        
while (1)
    {
    intro();
    };
}


