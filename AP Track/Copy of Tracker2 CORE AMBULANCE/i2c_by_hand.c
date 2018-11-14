#include <avr/io.h>
#include "i2c_by_hand.h"


#define	SDA_PORT	PORTC
#define SDA_LINE	0x10
#define SDA_DDR		DDRC
#define SDA_PIN		PINC
#define SCL_PORT	PORTC
#define SCL_LINE	0x20
#define SCL_DDR		DDRC
#define SCL_PIN		PINC


void vI2C_Delay(void)
{
	static unsigned short usCounter = 0;
	while (usCounter < 50)
	{
		usCounter++;
	}
	usCounter = 0;
}

void vI2C_Init (void)
{
	SCL_PORT |= (SCL_LINE | SDA_LINE);		// Preconfig as high
	SCL_DDR |= (SCL_LINE | SDA_LINE);		// Both pins as outputs
	vI2C_Delay();							// Some delay
}

void vI2C_Start (void)
{
	vI2C_Init();				// All lines to default high state

	vI2C_Delay();				// Some delay
	vI2C_Delay();				// Some delay
	vI2C_Delay();				// Some delay
	vI2C_Delay();				// Some delay
	vI2C_Delay();				// Some delay
	vI2C_Delay();				// Some delay
	vI2C_Delay();				// Some delay

	SDA_PORT &= ~SDA_LINE;		// SDA to low while SCL is high -> START condition
	vI2C_Delay();				// Some delay

	SCL_PORT &= ~SCL_LINE;		// SCL down 
	vI2C_Delay();				// Some delay
}

void vI2C_Stop (void)
{
	SDA_DDR |= SDA_LINE;		// SDA as Output

	SDA_PORT &= ~SDA_LINE;		// Data to low
	vI2C_Delay();				// Some delay

	SCL_PORT |= SCL_LINE;		// Clock to high
	vI2C_Delay();				// Some delay

	SDA_PORT |= SDA_LINE;		// Data to high
	vI2C_Delay();				// Some delay
	vI2C_Delay();				// Some delay
}



unsigned char ucI2C_SendByte (unsigned char ucByte)
{
	unsigned char ucCounter;
	unsigned char ucReturn;

	SDA_DDR |= SDA_LINE;				// Define SDA-Pin as Output
	for (ucCounter = 0; ucCounter < 8; ucCounter++)
	{
		vI2C_Delay();					// Some delay
		if ((ucByte & 0x80) == 0x80)	// Send Data MSB first
		{
			SDA_PORT |= SDA_LINE;
		}
		else
		{
			SDA_PORT &= ~SDA_LINE;
		}
		ucByte <<= 1;					// Rotate source byte
		vI2C_Delay();					// Some delay
		SCL_PORT |= SCL_LINE;			// Clock to high, data is established on SDA
		vI2C_Delay();					// Some delay
		SCL_PORT &= ~SCL_LINE;			// Clock to low, data is valid
	}
	// Data is sent, check for ACK
	SDA_DDR &= ~SDA_LINE;				// Define SDA-Pin as Input
	SDA_PORT |= SDA_LINE;				// Activate internal pullup
	vI2C_Delay();						// Some delay


	SCL_PORT |= SCL_LINE;				// Clock to high, data is established on SDA
	vI2C_Delay();						// Some delay


	if ((SDA_PIN & SDA_LINE) != SDA_LINE)
	{
		ucReturn = 1;					// ACK received
	}
	else
	{
		ucReturn = 0;					// ACK not received
	}
	
	SCL_PORT &= ~SCL_LINE;				// Clock to low, data is valid
	vI2C_Delay();						// Some delay



	return ucReturn;
}

unsigned char ucI2C_ReceiveByte (void)
{
	unsigned char ucCounter;
	unsigned char ucByte = 0;

	SDA_DDR &= ~SDA_LINE;				// Define SDA-Pin as Input
	SDA_PORT |= SDA_LINE;				// Activate internal pullup
	
	ucByte = 0;
	vI2C_Delay();						// Some delay
		
	for (ucCounter = 0; ucCounter < 8; ucCounter++)
	{
		SCL_PORT |= SCL_LINE;					// Clock to high, data is established on SDA
		vI2C_Delay();							// Some delay

		if ((SDA_PIN & SDA_LINE) == SDA_LINE)	// Receive Data MSB first
		{
			ucByte++;							// If it's a 1, add 1 to 
		}
		if (ucCounter != 7)
		{
			ucByte <<= 1;						// And rotate it to the left
		}


		SCL_PORT &= ~SCL_LINE;					// Clock to low, data is received
		vI2C_Delay();							// Some delay
	}
	
	// Send ACK
	SDA_PORT &= ~SDA_LINE;						// Pull line to low
	SDA_DDR |= SDA_LINE;						// Define SDA-Pin as Output
	vI2C_Delay();								// Some delay
	SCL_PORT |= SCL_LINE;						// Clock to high, data is established on SDA
	vI2C_Delay();								// Some delay
	SDA_DDR &= ~SDA_LINE;						// Define SDA-Pin as Input
	SCL_PORT &= ~SCL_LINE;						// Clock to low, data is received
	vI2C_Delay();								// Some delay
	return ucByte;
}


