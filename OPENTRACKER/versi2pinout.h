#ifndef _VERSI_2_PINOUT_INCLUDED_
#define _VERSI_2_PINOUT_INCLUDED_

#pragma used+

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

#pragma used- 

#define DAC_0	PORTB.0
#define DAC_1	PORTB.1
#define DAC_2	PORTB.2
#define DAC_3	PORTB.3

#define PTT	PORTB.4

#define STBY_LED	PORTD.2
#define TX_LED		PORTD.3

#define MODE	PORTD.4
#define TX_NOW	PORTD.5

#define VERSI_2_INIT_PORT	(Versi_2_Init_Ports())

void Versi_2_Init_Ports(void);

void Versi_2_Init_Ports(void) {
	// Port B initialization
	// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out 
	// State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=0 State0=0 
	PORTB=0x00;
	DDRB=0x1F;

	// Port C initialization
	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out 
	// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=0 
	PORTC=0x00;
	DDRC=0x01;

	// Port D initialization
	// Func7=Out Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=In 
	// State7=1 State6=T State5=P State4=P State3=0 State2=0 State1=0 State0=P 
	PORTD=0xB1;
	DDRD=0x8E;
}

#endif



