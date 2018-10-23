/*****************************************************
This program was produced by the
CodeWizardAVR V1.25.3 Standard
Automatic Program Generator
© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
http://www.hpinfotech.com

Project : 
Version : 
Date    : 3/8/2009
Author  : F4CG                            
Company : F4CG                            
Comments: 


Chip type           : ATtiny2313
Clock frequency     : 11.059200 MHz
Memory model        : Tiny
External SRAM size  : 0
Data Stack size     : 32
*****************************************************/

#include <tiny2313.h>                                                     
#include <delay.h>  

#define maju                    1
#define mundur                  0  

#define off                     1
#define on                      0

#define pwmkiri              OCR1A
#define arahkiri             PORTB.2
#define remkiri              PORTD.6

#define pwmkanan             OCR1B
#define arahkanan            PORTB.0
#define remkanan             PORTB.1        

#define s1                PIND.0 
#define s2                PIND.1 
#define s3                PIND.2 
#define s4                PIND.3
#define s5                PIND.4 
#define s6                PIND.5
  
// Timer 1 overflow interrupt service routine
interrupt [TIM1_OVF] void timer1_ovf_isr(void)
{
// Place your code here

}
// Declare your global variables here 
unsigned char sensor;    
bit x;   

void countersimpangr(unsigned char xcounter);
void countersimpangl(unsigned char xcounter);
void countersilango(unsigned char xcounter);
void countersilangz(unsigned char xcounter);
void countersilange(unsigned char xcounter);
void countersilangb(unsigned char xcounter);
void countersilangl(unsigned char xcounter);
void scan();
void stop();
void jalanmundur(unsigned char lspeed, unsigned char rspeed);
void jalanmaju();
void jalankanan(unsigned char lspeed, unsigned char rspeed);
void jalankiri(unsigned char lspeed, unsigned char rspeed);
void belokkanan(unsigned char lspeed,unsigned char rspeed);
void belokkiri(unsigned char lspeed,unsigned char rspeed); 
void kebut(unsigned char lspeed, unsigned char rspeed);    

void counterlepas(unsigned char xcounter)
{	
        unsigned char counter;
	unsigned int i;            
	sensor=PIND;
	counter=0;
	while(counter<xcounter)
	{	for(i=0;i<1000;i++)	while ((sensor & 0b00111111)!=0b00000000)scan();
	        counter++;
	};
	stop();
     
} 

void scano()
{	sensor=PIND;
	sensor&=0b00111111;
	switch(sensor)          
	{	
	//jika logika 1 berarti sensor aktif
	//lihat bit: 7.6.5.4.3.2.1.0      
	//0 = sensor kiri
	//7 = sensor kanan  
	        case 0b00000001:	jalankanan(100,100);     x=1;    	 break; 
	        case 0b00000011:	jalankanan(100,100);     x=1;    	 break;
	        case 0b00000010:	jalankanan(100,0);     x=1;    	 break;
		case 0b00000110:	jalankanan(100,0);     x=1;    	 break;  
		/*
		case 0b00000001:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=40;    break;
		case 0b00000011:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=50;    break;
		case 0b00000010:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=60;    break;
		
		case 0b00000110:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=200;    break;
		*/
		case 0b00000100:	jalanmaju();     pwmkiri=120;	x=1;    pwmkanan=100;    break; //serong kanan
		case 0b00001100:	jalanmaju();     pwmkiri=120;	        pwmkanan=120;   break; //full speed
		case 0b00001000:	jalanmaju();     pwmkiri=120;	x=0;    pwmkanan=120;    break; //serong kiri
		/*
		case 0b00011000:	jalanmaju();     pwmkiri=200;	x=0;    pwmkanan=255;    break;
		
		case 0b00010000:	jalanmaju();     pwmkiri=60;	x=0;    pwmkanan=255;    break;
		case 0b00110000:	jalanmaju();     pwmkiri=50;	x=0;    pwmkanan=255;    break;
		case 0b00100000:	jalanmaju();     pwmkiri=40;	x=0;    pwmkanan=255;    break;
		*/
		case 0b00011000:	jalankiri(0,100);    	x=0;    	 break;
	        case 0b00010000:	jalankiri(0,100);    	x=0;    	 break;
	        case 0b00110000:	jalankiri(100,100);    	x=0;    	 break;
		case 0b00100000:	jalankiri(100,100);    	x=0;    	 break;  
		
                case 0b00000000:        
                                        if(x)           
                                        {    
                                        //jalanmaju();     pwmkiri=100;	    pwmkanan=0;
                                          jalankanan(100,100);
                                           break;
                                        }	                
		                        else            
		                        {   
		                        //jalanmaju();     pwmkiri=0;	    pwmkanan=100;
		                           jalankiri(100,100);
		                           break;
		                        }        
       
	}       		 
}     

void scanz()
{	sensor=PIND;
	sensor&=0b00111111;
	switch(sensor)          
	{	
	//jika logika 1 berarti sensor aktif
	//lihat bit: 7.6.5.4.3.2.1.0      
	//0 = sensor kiri
	//7 = sensor kanan  
	        case 0b00000001:	jalankanan(100,100);     x=1;    	 break; 
	        case 0b00000011:	jalankanan(100,100);     x=1;    	 break;
	        case 0b00000010:	jalankanan(100,0);     x=1;    	 break;
		/*
		case 0b00000110:	jalankanan(100,0);     x=1;    	 break;  
		
		case 0b00000001:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=40;    break;
		case 0b00000011:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=50;    break;
		case 0b00000010:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=60;    break;
		*/
		case 0b00000110:	jalanmaju();     pwmkiri=100;	x=1;    pwmkanan=120;    break;
		
		case 0b00000100:	jalanmaju();     pwmkiri=120;	x=1;    pwmkanan=120;    break; //serong kanan
		case 0b00001100:	jalanmaju();     pwmkiri=120;	        pwmkanan=120;   break; //full speed
		case 0b00001000:	jalanmaju();     pwmkiri=120;	x=0;    pwmkanan=120;    break; //serong kiri
		
		case 0b00011000:	jalanmaju();     pwmkiri=120;	x=0;    pwmkanan=100;    break;
		/*
		case 0b00010000:	jalanmaju();     pwmkiri=60;	x=0;    pwmkanan=255;    break;
		case 0b00110000:	jalanmaju();     pwmkiri=50;	x=0;    pwmkanan=255;    break;
		case 0b00100000:	jalanmaju();     pwmkiri=40;	x=0;    pwmkanan=255;    break;
		
		case 0b00011000:	jalankiri(0,100);    	x=0;    	 break;
		*/
	        case 0b00010000:	jalankiri(0,100);    	x=0;    	 break;
	        case 0b00110000:	jalankiri(100,100);    	x=0;    	 break;
		case 0b00100000:	jalankiri(100,100);    	x=0;    	 break;  
		
                case 0b00000000:        
                                        if(x)           
                                        {    
                                        //jalanmaju();     pwmkiri=100;	    pwmkanan=0;
                                          jalankanan(100,100);
                                           break;
                                        }	                
		                        else            
		                        {   
		                        //jalanmaju();     pwmkiri=0;	    pwmkanan=100;
		                           jalankiri(100,100);
		                           break;
		                        }        
       
	}       		 
} 

void scane()
{	sensor=PIND;
	sensor&=0b00111111;
	switch(sensor)          
	{	
	//jika logika 1 berarti sensor aktif
	//lihat bit: 7.6.5.4.3.2.1.0      
	//0 = sensor kiri
	//7 = sensor kanan  
	        case 0b00000001:	jalankanan(100,100);     x=1;    	 break; 
	        case 0b00000011:	jalankanan(100,100);     x=1;    	 break;
	        case 0b00000010:	jalankanan(100,0);     x=1;    	 break;
		case 0b00000110:	jalankanan(100,0);     x=1;    	 break;  
		/*
		case 0b00000001:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=40;    break;
		case 0b00000011:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=50;    break;
		case 0b00000010:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=60;    break;
		
		case 0b00000110:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=200;    break;
		*/
		case 0b00000100:	jalanmaju();     pwmkiri=150;	x=1;    pwmkanan=100;    break; //serong kanan
		case 0b00001100:	jalanmaju();     pwmkiri=150;	        pwmkanan=150;   break; //full speed
		case 0b00001000:	jalanmaju();     pwmkiri=150;	x=0;    pwmkanan=150;    break; //serong kiri
		/*
		case 0b00011000:	jalanmaju();     pwmkiri=200;	x=0;    pwmkanan=255;    break;
		
		case 0b00010000:	jalanmaju();     pwmkiri=60;	x=0;    pwmkanan=255;    break;
		case 0b00110000:	jalanmaju();     pwmkiri=50;	x=0;    pwmkanan=255;    break;
		case 0b00100000:	jalanmaju();     pwmkiri=40;	x=0;    pwmkanan=255;    break;
		*/
		case 0b00011000:	jalankiri(0,100);    	x=0;    	 break;
	        case 0b00010000:	jalankiri(0,100);    	x=0;    	 break;
	        case 0b00110000:	jalankiri(100,100);    	x=0;    	 break;
		case 0b00100000:	jalankiri(100,100);    	x=0;    	 break;  
		
                case 0b00000000:        
                                        if(x)           
                                        {    
                                        //jalanmaju();     pwmkiri=100;	    pwmkanan=0;
                                          jalankanan(100,100);
                                           break;
                                        }	                
		                        else            
		                        {   
		                        //jalanmaju();     pwmkiri=0;	    pwmkanan=100;
		                           jalankiri(100,100);
		                           break;
		                        }        
       
	}       		 
}                      

void scanb()
{	sensor=PIND;
	sensor&=0b00111111;
	switch(sensor)          
	{	
	//jika logika 1 berarti sensor aktif
	//lihat bit: 7.6.5.4.3.2.1.0      
	//0 = sensor kiri
	//7 = sensor kanan  
	        case 0b00000001:	jalankanan(100,100);     x=1;    	 break; 
	        case 0b00000011:	jalankanan(100,100);     x=1;    	 break;
	        case 0b00000010:	jalankanan(100,0);     x=1;    	 break;
		case 0b00000110:	jalankanan(100,0);     x=1;    	 break;  
		/*
		case 0b00000001:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=40;    break;
		case 0b00000011:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=50;    break;
		case 0b00000010:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=60;    break;
		
		case 0b00000110:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=200;    break;
		*/
		case 0b00000100:	jalanmaju();     pwmkiri=100;	x=1;    pwmkanan=80;    break; //serong kanan
		case 0b00001100:	jalanmaju();     pwmkiri=100;	        pwmkanan=100;   break; //full speed
		case 0b00001000:	jalanmaju();     pwmkiri=100;	x=0;    pwmkanan=100;    break; //serong kiri
		/*
		case 0b00011000:	jalanmaju();     pwmkiri=200;	x=0;    pwmkanan=255;    break;
		
		case 0b00010000:	jalanmaju();     pwmkiri=60;	x=0;    pwmkanan=255;    break;
		case 0b00110000:	jalanmaju();     pwmkiri=50;	x=0;    pwmkanan=255;    break;
		case 0b00100000:	jalanmaju();     pwmkiri=40;	x=0;    pwmkanan=255;    break;
		*/
		case 0b00011000:	jalankiri(0,100);    	x=0;    	 break;
	        case 0b00010000:	jalankiri(0,100);    	x=0;    	 break;
	        case 0b00110000:	jalankiri(100,100);    	x=0;    	 break;
		case 0b00100000:	jalankiri(100,100);    	x=0;    	 break;   
		
		
		//case 0b00000111:	jalankiri(100,100);    	x=1;    	 break;
		case 0b00001110:	jalanmaju();     pwmkiri=100;	  x=1;  pwmkanan=80;   break;   
		case 0b00011110:	jalanmaju();     pwmkiri=100;	        pwmkanan=100;   break;
		case 0b00011100:	jalanmaju();     pwmkiri=80;	  x=0;  pwmkanan=100;   break;   
		//case 0b00111000:	jalankiri(100,100);    	x=0;    	 break;   
                case 0b00000000:        
                                        if(x)           
                                        {    
                                        //jalanmaju();     pwmkiri=100;	    pwmkanan=0;
                                          jalankanan(100,100);
                                           break;
                                        }	                
		                        else            
		                        {   
		                        //jalanmaju();     pwmkiri=0;	    pwmkanan=100;
		                           jalankiri(100,100);
		                           break;
		                        }        
       
	}       		 
}         

void main(void)      

{
// Declare your local variables here

unsigned int i;

// Input/Output Ports initialization
// Port A initialization
// Func2=In Func1=In Func0=In 
// State2=T State1=T State0=T 
PORTA=0x00;
DDRA=0x00;

// Port B initialization
// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
// State7=T State6=T State5=T State4=0 State3=0 State2=1 State1=1 State0=1 
PORTB=0x07;
DDRB=0x1F;

// Port D initialization
// Func6=Out Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In 
// State6=1 State5=T State4=T State3=T State2=T State1=T State0=T 
PORTD=0x40;
DDRD=0x40;

// Timer/Counter 0 initialization
// Clock source: System Clock
// Clock value: Timer 0 Stopped
// Mode: Normal top=FFh
// OC0A output: Disconnected
// OC0B output: Disconnected
TCCR0A=0x00;
TCCR0B=0x00;
TCNT0=0x00;
OCR0A=0x00;
OCR0B=0x00;

// Timer/Counter 1 initialization
// Clock source: System Clock
// Clock value: 10.800 kHz
// Mode: Fast PWM top=00FFh
// OC1A output: Inverted
// OC1B output: Inverted
// Noise Canceler: Off
// Input Capture on Falling Edge
// Timer 1 Overflow Interrupt: On
// Input Capture Interrupt: Off
// Compare A Match Interrupt: Off
// Compare B Match Interrupt: Off
TCCR1A=0xF1;

TCCR1B=0x0D;
TCNT1H=0x00;
TCNT1L=0x00;
ICR1H=0x00;
ICR1L=0x00;
OCR1AH=0x00;
OCR1AL=0x00;
OCR1BH=0x00;
OCR1BL=0x00;

// External Interrupt(s) initialization
// INT0: Off
// INT1: Off
// Interrupt on any change on pins PCINT0-7: Off
GIMSK=0x00;
MCUCR=0x00;

// Timer(s)/Counter(s) Interrupt(s) initialization
TIMSK=0x80;

// Universal Serial Interface initialization
// Mode: Disabled
// Clock source: Register & Counter=no clk.
// USI Counter Overflow Interrupt: Off
USICR=0x00;

// Analog Comparator initialization
// Analog Comparator: Off
// Analog Comparator Input Capture by Timer/Counter 1: Off     
ACSR=0x80;
{
            stop();          
            delay_ms(3000); 

            jalanmaju();        pwmkiri=255;    pwmkanan=255;
            delay_ms(350);
            stop();
            delay_ms(300); 
}

while (1)
      {
      // Place your code here
     countersimpangr(1); 
     belokkanan(120,120); 
     
     countersilango(1); 
     
     countersilangz(1);
     
     countersilangl(1);
     stop();
     delay_ms(200);
     
     countersilange(2); 
     
     countersilangb(1);
     stop();
     delay_ms(500);
     countersimpangl(1); 
     belokkanan(120,120);
     //while(1);
      };   
      
}  

void scan()
{	sensor=PIND;
	sensor&=0b00111111;
	switch(sensor)          
	{	
	//jika logika 1 berarti sensor aktif
	//lihat bit: 7.6.5.4.3.2.1.0      
	//0 = sensor kiri
	//7 = sensor kanan  
	        case 0b00000001:	jalankanan(100,100);     x=1;    	 break; 
	        case 0b00000011:	jalankanan(100,100);     x=1;    	 break;
	        case 0b00000010:	jalankanan(100,0);     x=1;    	 break;
		case 0b00000110:	jalankanan(100,0);     x=1;    	 break;  
		/*
		case 0b00000001:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=40;    break;
		case 0b00000011:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=50;    break;
		case 0b00000010:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=60;    break;
		
		case 0b00000110:	jalanmaju();     pwmkiri=255;	x=1;    pwmkanan=200;    break;
		*/
		case 0b00000100:	jalanmaju();     pwmkiri=150;	x=1;    pwmkanan=100;    break; //serong kanan
		case 0b00001100:	jalanmaju();     pwmkiri=150;	        pwmkanan=150;   break; //full speed
		case 0b00001000:	jalanmaju();     pwmkiri=100;	x=0;    pwmkanan=150;    break; //serong kiri
		/*
		case 0b00011000:	jalanmaju();     pwmkiri=200;	x=0;    pwmkanan=255;    break;
		
		case 0b00010000:	jalanmaju();     pwmkiri=60;	x=0;    pwmkanan=255;    break;
		case 0b00110000:	jalanmaju();     pwmkiri=50;	x=0;    pwmkanan=255;    break;
		case 0b00100000:	jalanmaju();     pwmkiri=40;	x=0;    pwmkanan=255;    break;
		*/
		case 0b00011000:	jalankiri(0,100);    	x=0;    	 break;
	        case 0b00010000:	jalankiri(0,100);    	x=0;    	 break;
	        case 0b00110000:	jalankiri(100,100);    	x=0;    	 break;
		case 0b00100000:	jalankiri(100,100);    	x=0;    	 break;  
		
                case 0b00000000:        
                                        if(x)           
                                        {    
                                        //jalanmaju();     pwmkiri=100;	    pwmkanan=0;
                                          jalankanan(100,100);
                                           break;
                                        }	                
		                        else            
		                        {   
		                        //jalanmaju();     pwmkiri=0;	    pwmkanan=100;
		                           jalankiri(100,100);
		                           break;
		                        }        
       
	}       		 
}     

void belokkanan(unsigned char lspeed,unsigned char rspeed)  //left speed, right speed
{	
        unsigned int i;
        stop(); 
        delay_ms(500);                     
        sensor=PIND;
	jalankanan(lspeed,rspeed);
        for(i=0;i<800;i++)  while (!s2) {}; 
        stop(); delay_ms(11); stop();
	
} 

void belokkiri(unsigned char lspeed,unsigned char rspeed)  //left speed, right speed
{	
        unsigned int i;
        stop(); 
        delay_ms(500);                     
        sensor=PIND;
	jalankiri(lspeed,rspeed);
        for(i=0;i<800;i++)  while ((sensor & 0b00000011)!=0b00000011) {}; 
        stop(); delay_ms(11); stop();
	
} 

void countersimpangr(unsigned char xcounter)
{	
        unsigned char counter;
	unsigned int i;            
	sensor=PIND;
	counter=0;
	while(counter<xcounter)
	{	for(i=0;i<1000;i++)	while ((sensor & 0b00000111)!=0b00000111)scan(); 
        	for(i=0;i<90;i++)  	while ((sensor & 0b00000111)==0b00000111)scan();  
	        counter++;
	};
	stop();  
} 

void countersimpangl(unsigned char xcounter)
{	
        unsigned char counter;
	unsigned int i;            
	sensor=PIND;
	counter=0;
	while(counter<xcounter)
	{	for(i=0;i<1000;i++)	while ((sensor & 0b00000111)!=0b00000111)scan(); 
        	for(i=0;i<90;i++)  	while ((sensor & 0b00000111)==0b00000111)scan();  
	        counter++;
	};
	stop();  
} 

void countersilango(unsigned char xcounter)
{	
        unsigned char counter;
	unsigned int i;            
	sensor=PIND;
	counter=0;
	while(counter<xcounter)
	{	for(i=0;i<1000;i++)	while ((sensor & 0b00111111)!=0b00111111)scano(); 
        	for(i=0;i<90;i++)  	while ((sensor & 0b00111111)==0b00111111)scano();  
	        counter++;
	};
	stop();
}         

void countersilangz(unsigned char xcounter)
{	
        unsigned char counter;
	unsigned int i;            
	sensor=PIND;
	counter=0;
	while(counter<xcounter)
	{	for(i=0;i<1000;i++)	while ((sensor & 0b00111111)!=0b00111111)scanz(); 
        	for(i=0;i<90;i++)  	while ((sensor & 0b00111111)==0b00111111)scanz();  
	        counter++;
	};
	stop();
}                                 

void countersilange(unsigned char xcounter)
{	
        unsigned char counter;
	unsigned int i;            
	sensor=PIND;
	counter=0;
	while(counter<xcounter)
	{	for(i=0;i<1000;i++)	while ((sensor & 0b00111111)!=0b00111111)scane(); 
        	for(i=0;i<90;i++)  	while ((sensor & 0b00111111)==0b00111111)scane();  
	        counter++;
	};
	stop();
}                                                                                   
        
void countersilangb(unsigned char xcounter)
{	
        unsigned char counter;
	unsigned int i;            
	sensor=PIND;
	counter=0;
	while(counter<xcounter)
	{	for(i=0;i<1000;i++)	while ((sensor & 0b00111111)!=0b00111111)scanb(); 
        	for(i=0;i<90;i++)  	while ((sensor & 0b00111111)==0b00111111)scanb();  
	        counter++;
	};
	stop();
}              

void countersilangl(unsigned char xcounter)
{	
        unsigned char counter;
	unsigned int i;            
	sensor=PIND;
	counter=0;
	while(counter<xcounter)
	{	for(i=0;i<1000;i++)	while ((sensor & 0b00111111)!=0b00111111)scan(); 
        	for(i=0;i<90;i++)  	while ((sensor & 0b00111111)==0b00111111)scan();  
	        counter++;
	};
	stop();
}          

void stop()
{
        pwmkanan=0;
        pwmkiri=0;
        remkanan=on;
        remkiri=on;  //logika 0 untuk mengaktifkan rem
}

void jalanmundur(unsigned char lspeed, unsigned char rspeed)
{
        remkanan=off;
        remkiri=off;
        arahkanan=mundur;
        arahkiri=mundur;
        pwmkanan=rspeed;
        pwmkiri=lspeed;
}    

void kebut(unsigned char lspeed, unsigned char rspeed)
{
        remkanan=off;     //logika 1 untuk off - mematikan rem   
        remkiri=off;        
        arahkanan=maju;
        arahkiri=maju; 
        pwmkanan=rspeed;
        pwmkiri=lspeed;
}                 
 
void jalanmaju()
{
        remkanan=off;     //logika 1 untuk off - mematikan rem   
        remkiri=off;        
        arahkanan=maju;
        arahkiri=maju;  
}         

void jalankanan(unsigned char lspeed, unsigned char rspeed)
{
        remkanan=off;
        remkiri=off;
        arahkanan=mundur;
        arahkiri=maju;
        pwmkanan=rspeed;
        pwmkiri=lspeed;
}
void jalankiri(unsigned char lspeed, unsigned char rspeed)
{
        remkanan=off;
        remkiri=off;
        arahkiri=mundur;
        arahkanan=maju;
        pwmkanan=rspeed;
        pwmkiri=lspeed;
}        
