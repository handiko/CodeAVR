
#pragma used+
sfrb DIDR=1;
sfrb UBRRH=2;
sfrb UCSRC=3;
sfrb ACSR=8;
sfrb UBRRL=9;
sfrb UCSRB=0xa;
sfrb UCSRA=0xb;
sfrb UDR=0xc;
sfrb USICR=0xd;
sfrb USISR=0xe;
sfrb USIDR=0xf;
sfrb PIND=0x10;
sfrb DDRD=0x11;
sfrb PORTD=0x12;
sfrb GPIOR0=0x13;
sfrb GPIOR1=0x14;
sfrb GPIOR2=0x15;
sfrb PINB=0x16;
sfrb DDRB=0x17;
sfrb PORTB=0x18;
sfrb PINA=0x19;
sfrb DDRA=0x1a;
sfrb PORTA=0x1b;
sfrb EECR=0x1c;
sfrb EEDR=0x1d;
sfrb EEAR=0x1e;
sfrb PCMSK=0x20;
sfrb WDTCR=0x21;
sfrb TCCR1C=0x22;
sfrb GTCCR=0x23;
sfrb ICR1L=0x24;
sfrb ICR1H=0x25;
sfrw ICR1=0x24;   
sfrb CLKPR=0x26;
sfrb OCR1BL=0x28;
sfrb OCR1BH=0x29;
sfrw OCR1B=0x28;   
sfrb OCR1AL=0x2a;
sfrb OCR1AH=0x2b;
sfrw OCR1A=0x2a;   
sfrb TCNT1L=0x2c;
sfrb TCNT1H=0x2d;
sfrw TCNT1=0x2c;  
sfrb TCCR1B=0x2e;
sfrb TCCR1A=0x2f;
sfrb TCCR0A=0x30;
sfrb OSCCAL=0x31;
sfrb TCNT0=0x32;
sfrb TCCR0B=0x33;
sfrb MCUSR=0x34;
sfrb MCUCR=0x35;
sfrb OCR0A=0x36;
sfrb SPMCSR=0x37;
sfrb TIFR=0x38;
sfrb TIMSK=0x39;
sfrb EIFR=0x3a;
sfrb GIMSK=0x3b;
sfrb OCR0B=0x3c;
sfrb SPL=0x3d;
sfrb SREG=0x3f;
#pragma used-

#asm
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
#endasm

#pragma used+

void delay_us(unsigned int n);
void delay_ms(unsigned int n);

#pragma used-

bit data = 0;
bit d_data = 0;
bit tone;
char t = 0;
char v_2200 = 0;
eeprom char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
char int_anacomp = 0;

interrupt [7] void timer0_ovf_isr(void)
{

TCNT0 = ((unsigned char)(1+0xFF)-(0.0001*1382400));
t++; 
if(t > 8) 
{
t = 0;   
tone = 0;
PORTD.2 = 0;
PORTD.4 = 0;   
} 
if(PORTD.4 ^ PORTD.2)
{
if((t < 3)||(t > 5))
{
PORTD.3 = 1;
}     
else
{
PORTD.3 = 0;
}
}  
}

interrupt [11] void ana_comp_isr(void)
{

int_anacomp++;
if(int_anacomp == 2)
{
int_anacomp = 0;
tone = 1;
if((t>2)&&(t<6))
{
v_2200++;
if(v_2200 == 2)
{
v_2200 = 0;
PORTD.2 = 1;
PORTD.4 = 0;  
d_data = data;
data = 1;
}
} 
else if((t>6)&&(t<10))
{
v_2200 = 0;
PORTD.2 = 0;
PORTD.4 = 1; 
d_data = data;
data = 0;
}
t = 0;
PORTD.5 = !(data ^ d_data);
} 
}

void set_dac(char value) 
{	
PORTB.7	 = value & 0x01; 		
PORTB.6 =( value >> 1 ) & 0x01;
PORTB.5 =( value >> 2 ) & 0x01;
PORTB.4	 =( value >> 3 ) & 0x01; 	
}

void set_nada(void) 
{	
char i;  
if(tone)
{
if(PORTD.5) 
{	
for(i=0; i<16; i++)
{	
set_dac(matrix[i]);
delay_us(46);
} 
}  
else
{	
for(i=0; i<16; i++)
{	
set_dac(matrix[i]);
delay_us(22);
}       
for(i=0; i<13; i++)
{	
set_dac(matrix[i]);
delay_us(22);
}
}   
}
} 

void main(void)
{

#pragma optsize-
CLKPR=0x80;
CLKPR=0x00;
#pragma optsize+

PORTB=0x00;
DDRB=0xFC;

PORTD=0x00;
DDRD=0x7C;

PORTD.3 = 1;

TCCR0A=0x00;
TCCR0B=0x02;
TCNT0 = ((unsigned char)(1+0xFF)-(0.0001*1382400));

TIMSK=0x02;

ACSR=0x08;

DIDR=0x03;

PORTD.2 = 0;
PORTD.4 = 1;
PORTD.5 = 0;
delay_ms(200);
PORTD.2 = 0;
PORTD.4 = 0;
PORTD.5 = 1;
delay_ms(200);
PORTD.2 = 1;
PORTD.4 = 0;
PORTD.5 = 0;
delay_ms(200);
PORTD.2 = 0;
PORTD.4 = 1;
PORTD.5 = 0;
delay_ms(200);

#asm("sei")

while (1)
{

}
}
