/*******************************************************************************
File:			Messaging.c

				Messaging definitions/declarations for the atmega8.

Version:		1.02

*******************************************************************************/

unsigned char	Time_Temp[9]; 	// Temp variable here so main can read seconds
unsigned char ucSpeed; 	// Speed variable here so main can read seconds

extern void MsgInit (void);
extern void MsgPrepare (void);
extern void MsgSendPos (unsigned char ucShortPos);
extern void MsgSendTelem (void);
extern void MsgSendAck (unsigned char *rxbytes, unsigned char msg_start);
extern void MsgHandler (unsigned char newchar);
extern unsigned char GetValidGPS(void);

