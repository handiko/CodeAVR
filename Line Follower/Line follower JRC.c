/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Standard
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 11/20/2009
Author  : inzar                           
Company : inzdonesia                      
Comments: 


Chip type           : ATmega8535
Program type        : Application
Clock frequency     : 12.000000 MHz
Memory model        : Small
External SRAM size  : 0
Data Stack size     : 128
*****************************************************/

#include <mega8535.h> 
#include <delay.h> 
#include <stdio.h>

//PIN oscilator untuk PWM
#define pwmka   OCR1A
#define pwmki   OCR1B

//LCD back light
#define led     PORTD.7  //led ini adalah led LCD
#define on      0
#define off     1  


//Tombol Push Button pada robot
#define start   PINB.0
#define ataska  PINB.1
#define bawahka PINB.2
#define bawahki PINB.3
#define ataski  PINB.4
#define select  PINB.5



//inisialisasi LCD pada PORTC
// Alphanumeric LCD Module functions
#asm
   .equ __lcd_port=0x15 ;PORTC
#endasm
#include <lcd.h>

#define ADC_VREF_TYPE 0x60

//inisialisasi ADC untuk sensor garis pastinya pada PORTA
// Read the 8 most significant bits
// of the AD conversion result
unsigned char read_adc(unsigned char adc_input)
{
ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
// Start the AD conversion
ADCSRA|=0x40;
// Wait for the AD conversion to complete
while ((ADCSRA & 0x10)==0);
ADCSRA|=0x10;
return ADCH;
}


//deklarasi variable yang bisa digunakan untuk seluruh rutin program
// Declare your global variables here       

//eeprom maksudnya untuk menampung data yang disimpan sebagai perbandingan
eeprom unsigned char tengah[10],sen[10],line[10],back[10],simpan;  
eeprom unsigned char kpx,kdx,kix,speedx,plusx,loopx,cpx;
unsigned char i,y,n,sendat; 
unsigned char buff[33],buff1[33],buff2[33]; 
static int e=0;  
int sensor[10],s[10],data; 
bit x;  
char buffpwmki[33],buffpwmka[33],bufftampil[33];    

int get_sensor,set_point=0;
int error=0,d_error=0;
static int old_error=0; 
volatile int Vref;
volatile int u1,u2,u1x,u2x;


//sub program menggerakkan motor maju
void maju(unsigned char kiri,unsigned char kanan)
{
        PORTD.1=0;
        PORTD.2=1;
        
        PORTD.3=0;
        PORTD.6=1;
        
        pwmka=kanan;
        pwmki=kiri;
} 

      
//sub program untuk menggerakkan motor mundur
void mundur(unsigned char kiri,unsigned char kanan)
{
        PORTD.1=1;
        PORTD.2=0;
        
        PORTD.3=1;
        PORTD.6=0;
        
        pwmka=kanan;
        pwmki=kiri;
}

//sub program untuk menggerakkan motor kekanan
void bkanan(unsigned char kiri,unsigned char kanan)
{
        PORTD.1=0;
        PORTD.2=1;
        
        PORTD.3=1;
        PORTD.6=0;
        
        pwmka=kanan;
        pwmki=kiri;
}

//sub program untuk menggerakkan motor kekiri
void bkiri(unsigned char kiri,unsigned char kanan)
{
        PORTD.1=1;
        PORTD.2=0;
        
        PORTD.3=0;
        PORTD.6=1;
        
        pwmka=kanan;
        pwmki=kiri;
}   


//sub program untuk mendeteksi garis putih
//sensor diletakkan pada bagian putih semua
//kemudian jalankan rutin ini
//maka data putih akan disimpan
//untuk perbandingan nantinya
void cekline()
{         
        lcd_clear();  				//bersihkan lcd
        for (i=0;i<=6;i++)   			//ngulang sampai 7 kali karena sensor saya ada 7
        {		     			//kalo mau pakai delapan ganti aja dengan angka 7 karena hitungnya dari nol
                lcd_gotoxy(0,0);  		//posisi letak kursor LCD bila pakai lcd baris atas kolom nol
        	sprintf(buff,"%d",i);   	//nampilin data tiap sensor
        	lcd_puts(buff);      		//tamplilan juga
        
        	line[i]=read_adc(i);    	//data dari sensor disimpan dalam variabel line array urutan ke i karena looping
        	
        	lcd_gotoxy(5,1);		//posisi letak kursor LCD bila pakai lcd baris bawah kolom nol
                sprintf(buff1,"%d",line[i]);	//nampilin data tiap sensor
                lcd_puts(buff1); 		//tamplilan juga
                 
                led=on;				//kelipkan back light LCD bila perlu ganti dengan indikator led saja
                delay_ms(100);			//tunda 100 mili detik
                led=off;
                delay_ms(100); 
                lcd_clear();      		//bersihkan LCD lagi
        }   
        delay_ms(100);
        lcd_clear();
        i=0;					//setelah selesai maka i di nolkan lagi karena akan digunakan unutk sub program lain
} 


//sub proagram untuk mendeteksi garis hitam
//atau back grown 
//letakkan di bagian hitam
//jalankan rutin ini
//sistim kerja sama dengan pengecekan garis putih
//akan tetapi penyimpanan variabel beda
void cekback()
{         
        lcd_clear();
        for (i=0;i<=6;i++)
        {
                lcd_gotoxy(0,0);
        	sprintf(buff,"%d",i);
        	lcd_puts(buff);    
        
        	back[i]=read_adc(i);		//simpan di variabel array bernama back dengan urutan ke i
						//ke i maksudnya setiap pengulangan berarti beda angka di akhir varibelnya
        	
        	lcd_gotoxy(5,1);
                sprintf(buff1,"%d",back[i]);
                lcd_puts(buff1); 
                 
                led=on;
                delay_ms(100);
                led=off;
                delay_ms(100); 
                lcd_clear();      
        }   
	
         
//tambahan....
//disini karena saya menggunakan robot pada garis putih dan background hitam 
//maka saya langsung tambahkan program berikut ini yaitu
//menghitung tengah untuk perbandingan
//program ini bisa juga di buatkan pada sub program lainnya 
//yang pasti program ini di jalankan setelah pengecekan garis backgraund dan garis putih
//agar mempermudah kalkulasi nantinya

        for(i=0;i<=6;i++)
        {
                tengah[i]=(line[i]+back[i])/2;	
        }
        
        delay_ms(100);
        lcd_clear();
        i=0;  
}

//cuma menu doang pengen tau? komen ja ntar di posting
void cekdat()
{       
             
        if (ataska==0){i++;}  
        if (bawahka==0){i--;} 
        if (i>=6){i=6;} 
        
        delay_ms(200);
        lcd_clear();
        lcd_gotoxy(0,0);
        sprintf(buff,"%d",i);
        lcd_puts(buff); 
         
        lcd_gotoxy(10,1);
        sprintf(buff1,"%d",line[i]);
        lcd_puts(buff1); 
}    

//ini sub program penting dimana juga merupakan perhitungan untuk mendapatkan komparator. 
//artinya jika sensor yang terbaca lebih besar dari data garis maka dianggap nol "0"
//sedangkan jika lebih kecil maka dianggap satu "1"
//sehingga ini menjadi komparator tersendiri untuk mempermudah mengolah data
void hitsen()
{                 
        for(i=0;i<=6;i++)
        {
                s[i]=read_adc(i);         if (s[i]>(line[i]+20)){sensor[i]=0;}       else {sensor[i]=1;}
        } 

//perintah berikut ini adalah program konversi beberapa variable biner menjadi desimal
//pada bit ke 7 (128) saya nol kan karena saya menggunakan 7 sensor saja.
//jika menggunakan 8 maka ganti dengan nama variable penyimpanan data sensor tersebut   
    
        sendat=(sensor[0]*1)+(sensor[1]*2)+(sensor[2]*4)+(sensor[3]*8)+(sensor[4]*16)+(sensor[5]*32)+(sensor[6]*64)+(0*128);
simpan=sendat; 			//disini data yang telah dihitung digabungkan menjadi 1 variabel saja agar mudah dilakukan scanning garis
}   



//sub program scan garis dengan kondisi garis seperti pada kondisi dibawah
void scan()  //oke
{	
        hitsen();  									//menghitung data sensor dr rutin diatas sudah dibahas
	sendat&=0b01111111;								//sensor yang digunakan saja hanya 7 maka harus di AND kan agar kondisi tetap
	switch(sendat)          							//pemilihan keputusan dengan metode switch case terhadap variable sendat
	{	
	//jika logika 1 berarti sensor aktif
	//lihat bit: 7--6.5.4.3.2.1.0      
	//0 = sensor kanan  					
	//6 = sensor kiri
	//7 = kosong digunakan untuk cek baterai 
	

//berikut ini dalah kondisi yang akan terjadi pada robot yang kita berkirakan 
//beserta tindakannnya setelah salah satu kondisi terpilih
//misalnya maju atau sebagainya
		case 0b00000001:	bkanan(30,30); 	  x=1;    break; 
		case 0b00000011:	bkanan(30,20);     x=1;    break; 
		case 0b00000010:	bkanan(30,0); 	  x=1;    break;
		case 0b00000110:	maju(plusx,20);    x=1;    break;  
		case 0b00000100:	maju(plusx,50);    x=1;    break;        
		case 0b00001100:	maju(speedx,70);    x=1;    break; 
		case 0b00001000:	maju(speedx,speedx);            break; 
		case 0b00011100:	maju(speedx,speedx);            break; 
		case 0b00011000:	maju(70,speedx);    x=0;    break;
		case 0b00010000:	maju(50,plusx);    x=0;    break;
		case 0b00110000:	maju(20,plusx);    x=0;    break;
		case 0b00100000:	bkiri(0,30);     x=0;    break; 
		case 0b01100000:	bkiri(20,30);     x=0;    break;   
		case 0b01000000:	bkiri(30,30);     x=0;    break;
                case 0b00000000:        						//kondisi sensor keluar jalur (tak membaca garis)
                                        if(x)           				//memanfaatkan nilai x yang diberikan diatas sebagai kondisi terakhir 
                                        {    						//sehingga robot harus kembali
                                           bkanan(30,30);
                                           break;
                                        }	                
		                        else            
		                        {  
		                           bkiri(30,30);
		                           break;
		                        }        
	}
}  


//ini digunakan untuk error pada PID
//belom sempat posting
int scanx()  //oke
{	
	sendat&=0b01111111;
	switch(sendat)          
	{	
	//jika logika 1 berarti sensor aktif
	//lihat bit: 7--6.5.4.3.2.1.0      
	//0 = sensor kanan  
	//6 = sensor kiri
	//7 = kosong digunakan untuk cek baterai 
	
		case 0b00000001:	e=0;	 led=off;  break; 
		case 0b00000011:	e=0;       led=off; break;  
		case 0b00000010:	e=0;	 led=off;   break;
		case 0b00000110:	e=4;   x=1;   led=off; break;  
		case 0b00000100:	e=3;    x=1;   led=off; break;        
		case 0b00001100:	e=2;    x=1;   led=off; break; 
		case 0b00001000:	e=1;           led=off; break; 
		case 0b00011100:	e=1;           led=off; break; 
		case 0b00011000:	e=-2;    x=0;   led=off; break;
		case 0b00010000:	e=-3;    x=0;   led=off; break;
		case 0b00110000:	e=-4;    x=0;  led=off; break;
		case 0b00100000:	e=0;       led=off;  break;
		case 0b01100000:	e=0;        led=off; break; 
		case 0b01000000:	e=0;       led=off; break;   
		/*
	        case 0b00000001:	e=0;  	  x=1; led=on;  break;
		case 0b00000011:	e=0;  	  x=1; led=on;     break;
		case 0b00000010:	e=0;	  x=1;  led=on;    break; 
		case 0b00000111:	e=0;    x=1;    led=on;  break;  
		case 0b00000110:	e=0;	  x=1;  led=on;    break;
		case 0b00000100:	e=0;    x=1;    led=on;  break;  
		case 0b00001110:	e=0;    x=1;   led=on;   break;        
		case 0b00001100:	e=0;    x=1;   led=on;   break; 
		case 0b00001000:	e=0;            led=on;  break; 
		case 0b00011100:	e=0;           led=on;   break; 
		case 0b00011000:	e=0;    x=0;   led=on;   break;
		case 0b00111000:	e=0;    x=0;  led=on;    break;
		case 0b00010000:	e=0;    x=0;   led=on;   break;
		case 0b00110000:	e=0;     x=0;  led=on;    break;
		case 0b01110000:	e=0;     x=0;  led=on;    break; 
		case 0b00100000:	e=0;     x=0;  led=on;    break;
		case 0b01100000:	e=0;     x=0;  led=on;    break;
		case 0b01000000:	e=0;     x=0;  led=on;   break; 	
        	*/                                        
        	case 0b01111111:        e=4;      led=on;    break;
                case 0b00000000:        e=0;      led=off;    break;  
                                        
                                        /*
                                        if(x)           
                                        {    
                                           bkanan(255,255);
                                           break;
                                        }	                
		                        else            
		                        {  
		                           bkiri(255,255);
		                           break;
		                        }        
                                        */
	}
	return(e);
}       
               
  
 
//menu utama
void menu()
{     

menu:   				//label lompatan untuk fungsi goto
        lcd_clear();
        while(1)
        {
        lcd_gotoxy(0,0);
        lcd_putsf("1.SET  CONTROL.3");
        lcd_gotoxy(0,1);
        lcd_putsf("2.SENS   SPEED.4");
        
        if(ataski==0){delay_ms(300); goto cp;}           if(ataska==0){delay_ms(300); goto control;}
        if(bawahki==0){delay_ms(300); goto sens;}        if(bawahka==0){delay_ms(300); goto speed;} 
        
        if(start==0){delay_ms(300); goto exit;}
        if(select==0){delay_ms(300); goto menu;}
        }     
        
sens:  					//label lompatan untuk fungsi goto
        lcd_clear();
        while(1)
        {
        lcd_gotoxy(0,0);
        lcd_putsf("1.Line        .3");
        lcd_gotoxy(0,1);
        lcd_putsf("2.Ground      .4");
        
        if (ataski==0){cekline();}  
        if (bawahki==0){cekback();} 
        
        if(select==0){delay_ms(300); goto menu;}
        if(start==0){delay_ms(300); goto exit;}
        }
        
cp:     
        lcd_clear();
        while(1)
        {
        if(ataska==0){delay_ms(100); loopx++;}
        if(ataski==0){delay_ms(100); loopx--;}  
        if(bawahka==0){delay_ms(100); cpx++;}
        if(bawahki==0){delay_ms(100); cpx--;} 
        
        lcd_gotoxy(0,0);
        sprintf(bufftampil,"- loop  %d  ",loopx);
        lcd_puts(bufftampil); 
        lcd_gotoxy(0,1);
        sprintf(bufftampil,"- speed %d  ",cpx);
        lcd_puts(bufftampil);
        
        
        //if(ataski==0){delay_ms(300); goto kp;}           if(ataska==0){delay_ms(300); goto ki;}
        //if(bawahki==0){delay_ms(300); goto kd;}          if(bawahka==0){delay_ms(300); goto speed;}  
        
        if(select==0){delay_ms(300); goto menu;}
        if(start==0){delay_ms(300); goto exit;}
        }  

control:
        lcd_clear();
        while(1)
        {
        if(ataska==0){delay_ms(100); kpx++;}
        if(ataski==0){delay_ms(100); kpx--;}  
        if(bawahka==0){delay_ms(100); kdx++;}
        if(bawahki==0){delay_ms(100); kdx--;} 
        
        lcd_gotoxy(0,0);
        sprintf(bufftampil,"- KP    %d  ",kpx);
        lcd_puts(bufftampil); 
        lcd_gotoxy(0,1);
        sprintf(bufftampil,"- KD    %d  ",kdx);
        lcd_puts(bufftampil);
        
        
        //if(ataski==0){delay_ms(300); goto kp;}           if(ataska==0){delay_ms(300); goto ki;}
        //if(bawahki==0){delay_ms(300); goto kd;}          if(bawahka==0){delay_ms(300); goto speed;}  
        
        if(select==0){delay_ms(300); goto menu;}
        if(start==0){delay_ms(300); goto exit;}
        }     

speed:
        lcd_clear();
        while(1)
        {
        if(ataska==0){delay_ms(100); speedx++;}
        if(ataski==0){delay_ms(100); speedx--;}  
        if(bawahka==0){delay_ms(100); plusx++;}
        if(bawahki==0){delay_ms(100); plusx--;} 
        
        lcd_gotoxy(0,0);
        sprintf(bufftampil,"- Speed %d  ",speedx);
        lcd_puts(bufftampil); 
        lcd_gotoxy(0,1);
        sprintf(bufftampil,"- sdx   %d  ",plusx);
        lcd_puts(bufftampil);
        
        
        //if(ataski==0){delay_ms(300); goto kp;}           if(ataska==0){delay_ms(300); goto ki;}
        //if(bawahki==0){delay_ms(300); goto kd;}          if(bawahka==0){delay_ms(300); goto speed;}  
        
        if(select==0){delay_ms(300); goto menu;}
        if(start==0){delay_ms(300); goto exit;}
        }        
        
        
exit:
led=on;   
delay_ms(100);
led=off; 
delay_ms(100);

}        

 
//rutin program PD controller
void pdc(void)
{
  float Kp1=kpx,Kp2=kpx;
  float Kd1=kdx,Kd2=kdx; 
  
  hitsen();
  get_sensor=scanx();
  Vref=speedx;
  error=set_point - get_sensor;
  d_error=error - old_error;
  u1=Vref+(int)(Kp1*(float)error)+(int)(Kd1*(float)d_error);
  u2=Vref-(int)(Kp2*(float)error)-(int)(Kd2*(float)d_error);  
  
  old_error = error;    

  if (u1<0) u1=0;
  if (u1>255) u1=255;
  if (u2<0) u2=0;
  if (u2>255) u2=255; 
     
  if (get_sensor==0)
  {         
        if(x)           
        {    
                bkanan(cpx,plusx);
        }	                
        else            
        {  
                bkiri(plusx,cpx);
        }
  }  
  
  else {maju(u2,u1);}
  
  lcd_gotoxy(0,0);
  sprintf(buffpwmki,"%d    ",u2);
  lcd_puts(buffpwmki);  
  lcd_gotoxy(0,1);
  sprintf(buffpwmka,"%d    ",u1);
  lcd_puts(buffpwmka); 
}   
   

//sub program PD controller yang saya modifikasi
void pdcx(void)
{
  float Kp1=kpx,Kp2=kpx;
  float Kd1=kdx,Kd2=kdx; 
  
  hitsen();
  get_sensor=scanx();
  Vref=100;
  error=set_point - get_sensor;
  d_error=error - old_error;
  u1=Vref+(int)(Kp1*(float)error)+(int)(Kd1*(float)d_error);
  u2=Vref-(int)(Kp2*(float)error)-(int)(Kd2*(float)d_error);
  old_error = error;    

  if (u1<0) u1=0;
  if (u1>255) u1=255;
  if (u2<0) u2=0;
  if (u2>255) u2=255; 
     
  if (get_sensor==7)
  {         
        if(x)           
        {    
                bkanan(100,50);
        }	                
        else            
        {  
                bkiri(50,100);
        }
  }  
  
  else {maju(u2,u1);}
  
  lcd_gotoxy(0,0);
  sprintf(buffpwmki,"%d    ",u2);
  lcd_puts(buffpwmki);  
  lcd_gotoxy(0,1);
  sprintf(buffpwmka,"%d    ",u1);
  lcd_puts(buffpwmka); 
}


//sub program berhentikan motor
void stop()
{

        PORTD.1=1;
        PORTD.2=1;
        
        PORTD.3=1;
        PORTD.6=1;
        
        pwmka=0;
        pwmki=0;

} 


//sub program mengetahui adanya persimpangan    
void countersimpang(unsigned char xcounter)
{	
        unsigned char counter;
	unsigned int i;            
	counter=0;
	while(counter<xcounter)
	{	for(i=0;i<1000;i++)	while ((sendat & 0b01111111)!=0b01111111)pdc(); 
        	for(i=0;i<90;i++)  	while ((sendat & 0b01111111)==0b01111111)pdc();  
	        counter++;
	};
	stop(); 
} 


void countersimpangputus(unsigned char xcounter)
{	
        unsigned char counter;
	unsigned int i;
	get_sensor=scanx();
	counter=0;
	while(counter<xcounter)
	{	for(i=0;i<1000;i++)	while (get_sensor!=10)pdcx(); 
        	for(i=0;i<90;i++)  	while (get_sensor==10)pdcx();  
	        counter++;
	};
	stop();  
}                        

     
void main(void)
{
// Declare your local variables here

// Input/Output Ports initialization
// Port A initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTB=0xFF;
DDRB=0x00;

// Port C initialization
// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T 
PORTC=0x00;
DDRC=0x00;

// Port D initialization
// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=1 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0 
PORTD=0x80;
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
// Clock value: 12000.000 kHz
// Mode: Fast PWM top=00FFh
// OC1A output: Non-Inv.
// OC1B output: Non-Inv.
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: Off
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xA1;
TCCR1B=0x09;
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
TIMSK=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off
ACSR=0x80;
SFIOR=0x00;

// ADC initialization
// ADC Clock frequency: 750.000 kHz
// ADC Voltage Reference: AVCC pin
// ADC High Speed Mode: On
// ADC Auto Trigger Source: None
// Only the 8 most significant bits of
// the AD conversion result are used
ADMUX=ADC_VREF_TYPE & 0xff;
ADCSRA=0x84;
SFIOR&=0xEF;
SFIOR|=0x10;

// LCD module initialization
lcd_init(16); 

   
menu();


led=on;
lcd_clear();
lcd_gotoxy(0,0);
lcd_putsf("bismillah....!!!");
delay_ms(500);
led=off;
lcd_clear(); 



while (1)
{
      // Place your code here 
       //if (start==0){cekline();}  
       //if (select==0){cekback();} 
       if (cpx==1){zigzag();}
       if (start==0)
       {       
        while(1)				//program akan terus berulang-ulang
        {
                //countersimpang(loopx);   
                //while(1);
                //countersimpangputus(1);
                //countersimpang(1);  		
               pdc();
               //scan();  
        
        
        }
       } 
          
};

}


//	kurang jelas komen aja........saya siap membantu
//	http://keep-elka.blogspot.com


//	salam anak pulau