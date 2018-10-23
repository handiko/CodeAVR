#include "tmp275.h"
#include "i2c_by_hand.h"
#include <avr/io.h>


#define TMP275_ADRESS	0x90
#define TMP275_WRITE	0x00
#define TMP275_READ		0x01
#define TMP275_CONFIG	0x20
#define TMP275_REG_TEMP	0x00
#define TMP275_REG_CONF	0x01



unsigned char ucTMP275_Init(void)
{
	vI2C_Init();
	return ucTMP275_WriteConfig(TMP275_CONFIG);
}

unsigned short usTMP275_ReadTemp(void)
{
	unsigned short usReturn = 0;

	vI2C_Start();
	if (ucI2C_SendByte(TMP275_ADRESS | TMP275_WRITE) == 1)	// Slave Address
	{
		if (ucI2C_SendByte(TMP275_REG_TEMP) == 1)			// Write Temp Register
		{
//			vI2C_Stop();

			vI2C_Start();
			if (ucI2C_SendByte(TMP275_ADRESS | TMP275_READ) == 1)	// Slave Address
			{
				usReturn = 	(ucI2C_ReceiveByte())<<8;		// Receive Temp Data
				usReturn += ucI2C_ReceiveByte();			// Receive Temp Data
			}

			vI2C_Stop();									// If all was good -> stop
			return usReturn;								// And we're ready here
		}
	}
	
	vI2C_Stop();											// No ACK -> Stop
	return 0;
}



unsigned char ucTMP275_WriteConfig(unsigned char ucConfig)
{
	vI2C_Start();
	if (ucI2C_SendByte(TMP275_ADRESS | TMP275_WRITE) == 1)	// Slave Address
	{
		if (ucI2C_SendByte(TMP275_REG_CONF) == 1)			// Write Config Register
		{
			if (ucI2C_SendByte(ucConfig) == 1)				// Send Config Data
			{
				vI2C_Stop();								// If all was good -> stop
				return 1;									// Success
			}
		}
	}
	
	vI2C_Stop();											// No ACK -> Stop
	return 0;												// Mission Failed	
}

unsigned char ucTMP275_ReadConfig(void)
{
	unsigned char ucReturn = 0;

	vI2C_Start();
	if (ucI2C_SendByte(TMP275_ADRESS | TMP275_WRITE) == 1)	// Slave Address
	{
		if (ucI2C_SendByte(TMP275_REG_CONF) == 1)			// Write Config Register
		{
//			vI2C_Stop();

			vI2C_Start();
			if (ucI2C_SendByte(TMP275_ADRESS | TMP275_READ) == 1)	// Slave Address
			{
				ucReturn = 	ucI2C_ReceiveByte();			// Receive Config Data

			}
			vI2C_Stop();									// If all was good -> stop
			return ucReturn;								// And we're ready here
		}
	}
	
	vI2C_Stop();											// No ACK -> Stop
	return 0;
}


