/*******************************************************************************
File:			ADC.c

				Control subsystem function library.

Functions:	extern void					ADCInit(void)
				extern unsigned short	ADCGet(unsigned char chan)
				SIGNAL(SIG_ADC)

Revisions:	1.00	11/02/04	GND	Gary Dion

Copyright:	(c)2005, Gary N. Dion (me@garydion.com). All rights reserved.
				This software is available only for non-commercial amateur radio
				or educational applications.  ALL other uses are prohibited.
				This software may be modified only if the resulting code be
				made available publicly and the original author(s) given credit.

*******************************************************************************/

// OS headers
#include <avr/io.h>
#include <avr/interrupt.h>
//#include <avr/signal.h>

// App required include files
#include	"ADC.h"

static unsigned char 	channel;
static unsigned short 	adc;


/******************************************************************************/
extern void	ADCInit(void)
/*******************************************************************************
* ABSTRACT:	Initializes the ADC control registers.
*
* INPUT:	None
* OUTPUT:	None
* RETURN:	None
*/
{
	// Initialize the ADC to use AVCC as reference voltage, left adjustment, ADC1
	ADMUX = 0x41;	
	// Enable ADC, start a conversion, free run, interrupt, and prescale of 128
	ADCSRA = (1<<ADEN)|(1<<ADSC)|(1<<ADFR)|(1<<ADIE)|7;
	channel = 0;			// Set up initial channel for the interrupt routine
	return;

}		// End ADCInit(void)


/******************************************************************************/
extern unsigned short ADCGet(unsigned char chan)
/*******************************************************************************
* ABSTRACT:	This function reads the position of the to analog to digital
*			converter channels.  Adc0 is
*
* INPUT:	chan	Channel to return the 8-bit analog value of.
* OUTPUT:	None
* RETURN:	None
*/
{


	return adc;

}		// End ADCGet(unsigned char chan)


/******************************************************************************/
SIGNAL(SIG_ADC)
/*******************************************************************************
* ABSTRACT:	This function handles the ADC interrupt.  The Mux channel and
*			array index are offset one channel due to the way the ADC works.
*
* INPUT:	None
* OUTPUT:	None
* RETURN:	None
*/
{
	unsigned char ucADCHigh,ucADCLow;
	ucADCLow = ADCL;
	ucADCHigh = ADCH;

	adc = (ucADCHigh<<8)+ucADCLow;			// Just take the upper 8 bits


/*
	static unsigned char admux_temp = 0x60;

	if (++admux_temp == 0x66) admux_temp = 0x60;

	if (admux_temp == 0x62) channel = 0;

	adc[channel++] = (ADCH*4);
	ADMUX = admux_temp;
*/
}		// End SIGNAL(SIG_ADC)
