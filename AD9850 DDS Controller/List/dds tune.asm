
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 16.000000 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : long, width, precision
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	#define CALL_SUPPORTED 1

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU SPSR=0xE
	.EQU SPDR=0xF
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU EEARH=0x1F
	.EQU WDTCR=0x21
	.EQU MCUCR=0x35
	.EQU GICR=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F

	.DEF R0X0=R0
	.DEF R0X1=R1
	.DEF R0X2=R2
	.DEF R0X3=R3
	.DEF R0X4=R4
	.DEF R0X5=R5
	.DEF R0X6=R6
	.DEF R0X7=R7
	.DEF R0X8=R8
	.DEF R0X9=R9
	.DEF R0XA=R10
	.DEF R0XB=R11
	.DEF R0XC=R12
	.DEF R0XD=R13
	.DEF R0XE=R14
	.DEF R0XF=R15
	.DEF R0X10=R16
	.DEF R0X11=R17
	.DEF R0X12=R18
	.DEF R0X13=R19
	.DEF R0X14=R20
	.DEF R0X15=R21
	.DEF R0X16=R22
	.DEF R0X17=R23
	.DEF R0X18=R24
	.DEF R0X19=R25
	.DEF R0X1A=R26
	.DEF R0X1B=R27
	.DEF R0X1C=R28
	.DEF R0X1D=R29
	.DEF R0X1E=R30
	.DEF R0X1F=R31

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
	.EQU __HEAP_SIZE=0x0000
	.EQU __CLEAR_SRAM_SIZE=__SRAM_END-__SRAM_START+1

	.MACRO __CPD1N
	CPI  R30,LOW(@0)
	LDI  R26,HIGH(@0)
	CPC  R31,R26
	LDI  R26,BYTE3(@0)
	CPC  R22,R26
	LDI  R26,BYTE4(@0)
	CPC  R23,R26
	.ENDM

	.MACRO __CPD2N
	CPI  R26,LOW(@0)
	LDI  R30,HIGH(@0)
	CPC  R27,R30
	LDI  R30,BYTE3(@0)
	CPC  R24,R30
	LDI  R30,BYTE4(@0)
	CPC  R25,R30
	.ENDM

	.MACRO __CPWRR
	CP   R@0,R@2
	CPC  R@1,R@3
	.ENDM

	.MACRO __CPWRN
	CPI  R@0,LOW(@2)
	LDI  R30,HIGH(@2)
	CPC  R@1,R30
	.ENDM

	.MACRO __ADDB1MN
	SUBI R30,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDB2MN
	SUBI R26,LOW(-@0-(@1))
	.ENDM

	.MACRO __ADDW1MN
	SUBI R30,LOW(-@0-(@1))
	SBCI R31,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW2MN
	SUBI R26,LOW(-@0-(@1))
	SBCI R27,HIGH(-@0-(@1))
	.ENDM

	.MACRO __ADDW1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1FN
	SUBI R30,LOW(-2*@0-(@1))
	SBCI R31,HIGH(-2*@0-(@1))
	SBCI R22,BYTE3(-2*@0-(@1))
	.ENDM

	.MACRO __ADDD1N
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	SBCI R22,BYTE3(-@0)
	SBCI R23,BYTE4(-@0)
	.ENDM

	.MACRO __ADDD2N
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	SBCI R24,BYTE3(-@0)
	SBCI R25,BYTE4(-@0)
	.ENDM

	.MACRO __SUBD1N
	SUBI R30,LOW(@0)
	SBCI R31,HIGH(@0)
	SBCI R22,BYTE3(@0)
	SBCI R23,BYTE4(@0)
	.ENDM

	.MACRO __SUBD2N
	SUBI R26,LOW(@0)
	SBCI R27,HIGH(@0)
	SBCI R24,BYTE3(@0)
	SBCI R25,BYTE4(@0)
	.ENDM

	.MACRO __ANDBMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+(@1)
	ANDI R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ANDI R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ANDD2N
	ANDI R26,LOW(@0)
	ANDI R27,HIGH(@0)
	ANDI R24,BYTE3(@0)
	ANDI R25,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+(@1)
	ORI  R30,LOW(@2)
	STS  @0+(@1),R30
	LDS  R30,@0+(@1)+1
	ORI  R30,HIGH(@2)
	STS  @0+(@1)+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
	.ENDM

	.MACRO __ORD2N
	ORI  R26,LOW(@0)
	ORI  R27,HIGH(@0)
	ORI  R24,BYTE3(@0)
	ORI  R25,BYTE4(@0)
	.ENDM

	.MACRO __DELAY_USB
	LDI  R24,LOW(@0)
__DELAY_USB_LOOP:
	DEC  R24
	BRNE __DELAY_USB_LOOP
	.ENDM

	.MACRO __DELAY_USW
	LDI  R24,LOW(@0)
	LDI  R25,HIGH(@0)
__DELAY_USW_LOOP:
	SBIW R24,1
	BRNE __DELAY_USW_LOOP
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
	.ENDM

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __PUTD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R31
	STD  Y+@0+2,R22
	STD  Y+@0+3,R23
	.ENDM

	.MACRO __PUTD2S
	STD  Y+@0,R26
	STD  Y+@0+1,R27
	STD  Y+@0+2,R24
	STD  Y+@0+3,R25
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __CLRD1S
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+(@1))
	LDI  R31,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	LDI  R22,BYTE3(2*@0+(@1))
	LDI  R23,BYTE4(2*@0+(@1))
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+(@1))
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+(@2))
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+(@3))
	LDI  R@1,HIGH(@2+(@3))
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+(@3))
	LDI  R@1,HIGH(@2*2+(@3))
	.ENDM

	.MACRO __GETD1N
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __GETD2N
	LDI  R26,LOW(@0)
	LDI  R27,HIGH(@0)
	LDI  R24,BYTE3(@0)
	LDI  R25,BYTE4(@0)
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+(@1)
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+(@1)
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	LDS  R22,@0+(@1)+2
	LDS  R23,@0+(@1)+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+(@2)
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+(@3)
	LDS  R@1,@2+(@3)+1
	.ENDM

	.MACRO __GETWRZ
	LDD  R@0,Z+@2
	LDD  R@1,Z+@2+1
	.ENDM

	.MACRO __GETD2Z
	LDD  R26,Z+@0
	LDD  R27,Z+@0+1
	LDD  R24,Z+@0+2
	LDD  R25,Z+@0+3
	.ENDM

	.MACRO __GETB2MN
	LDS  R26,@0+(@1)
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+(@1)
	LDS  R27,@0+(@1)+1
	LDS  R24,@0+(@1)+2
	LDS  R25,@0+(@1)+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+(@1),R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+(@1),R30
	STS  @0+(@1)+1,R31
	STS  @0+(@1)+2,R22
	STS  @0+(@1)+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+(@1),R0
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+(@1),R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+(@1),R@2
	STS  @0+(@1)+1,R@3
	.ENDM

	.MACRO __PUTBZR
	STD  Z+@1,R@0
	.ENDM

	.MACRO __PUTWZR
	STD  Z+@2,R@0
	STD  Z+@2+1,R@1
	.ENDM

	.MACRO __GETW1R
	MOV  R30,R@0
	MOV  R31,R@1
	.ENDM

	.MACRO __GETW2R
	MOV  R26,R@0
	MOV  R27,R@1
	.ENDM

	.MACRO __GETWRN
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __PUTW1R
	MOV  R@0,R30
	MOV  R@1,R31
	.ENDM

	.MACRO __PUTW2R
	MOV  R@0,R26
	MOV  R@1,R27
	.ENDM

	.MACRO __ADDWRN
	SUBI R@0,LOW(-@2)
	SBCI R@1,HIGH(-@2)
	.ENDM

	.MACRO __ADDWRR
	ADD  R@0,R@2
	ADC  R@1,R@3
	.ENDM

	.MACRO __SUBWRN
	SUBI R@0,LOW(@2)
	SBCI R@1,HIGH(@2)
	.ENDM

	.MACRO __SUBWRR
	SUB  R@0,R@2
	SBC  R@1,R@3
	.ENDM

	.MACRO __ANDWRN
	ANDI R@0,LOW(@2)
	ANDI R@1,HIGH(@2)
	.ENDM

	.MACRO __ANDWRR
	AND  R@0,R@2
	AND  R@1,R@3
	.ENDM

	.MACRO __ORWRN
	ORI  R@0,LOW(@2)
	ORI  R@1,HIGH(@2)
	.ENDM

	.MACRO __ORWRR
	OR   R@0,R@2
	OR   R@1,R@3
	.ENDM

	.MACRO __EORWRR
	EOR  R@0,R@2
	EOR  R@1,R@3
	.ENDM

	.MACRO __GETWRS
	LDD  R@0,Y+@2
	LDD  R@1,Y+@2+1
	.ENDM

	.MACRO __PUTBSR
	STD  Y+@1,R@0
	.ENDM

	.MACRO __PUTWSR
	STD  Y+@2,R@0
	STD  Y+@2+1,R@1
	.ENDM

	.MACRO __MOVEWRR
	MOV  R@0,R@2
	MOV  R@1,R@3
	.ENDM

	.MACRO __INWR
	IN   R@0,@2
	IN   R@1,@2+1
	.ENDM

	.MACRO __OUTWR
	OUT  @2+1,R@1
	OUT  @2,R@0
	.ENDM

	.MACRO __CALL1MN
	LDS  R30,@0+(@1)
	LDS  R31,@0+(@1)+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+(@1))
	LDI  R31,HIGH(2*@0+(@1))
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMRDW
	ICALL
	.ENDM

	.MACRO __GETW1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X
	.ENDM

	.MACRO __GETD1STACK
	IN   R26,SPL
	IN   R27,SPH
	ADIW R26,@0+1
	LD   R30,X+
	LD   R31,X+
	LD   R22,X
	.ENDM

	.MACRO __NBST
	BST  R@0,@1
	IN   R30,SREG
	LDI  R31,0x40
	EOR  R30,R31
	OUT  SREG,R30
	.ENDM


	.MACRO __PUTB1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	LDS  R27,@0+1
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	LDS  R27,@0+1
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOVW R26,R@0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOVW R26,R@0
	ADIW R26,@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOVW R26,R@0
	ADIW R26,@1
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RON
	MOV  R26,R@0
	MOV  R27,R@1
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	CALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RONS
	MOV  R26,R@0
	MOV  R27,R@1
	ADIW R26,@2
	CALL __PUTDP1
	.ENDM


	.MACRO __GETB1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R30,Z
	.ENDM

	.MACRO __GETB1HSX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	.ENDM

	.MACRO __GETW1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R31,Z
	MOV  R30,R0
	.ENDM

	.MACRO __GETD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R0,Z+
	LD   R1,Z+
	LD   R22,Z+
	LD   R23,Z
	MOVW R30,R0
	.ENDM

	.MACRO __GETB2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R26,X
	.ENDM

	.MACRO __GETW2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	.ENDM

	.MACRO __GETD2SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R1,X+
	LD   R24,X+
	LD   R25,X
	MOVW R26,R0
	.ENDM

	.MACRO __GETBRSX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	LD   R@0,Z
	.ENDM

	.MACRO __GETWRSX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	LD   R@0,Z+
	LD   R@1,Z
	.ENDM

	.MACRO __GETBRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	LD   R@0,X
	.ENDM

	.MACRO __GETWRSX2
	MOVW R26,R28
	SUBI R26,LOW(-@2)
	SBCI R27,HIGH(-@2)
	LD   R@0,X+
	LD   R@1,X
	.ENDM

	.MACRO __LSLW8SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	LD   R31,Z
	CLR  R30
	.ENDM

	.MACRO __PUTB1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __CLRW1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __CLRD1SX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	ST   X+,R30
	ST   X+,R30
	ST   X+,R30
	ST   X,R30
	.ENDM

	.MACRO __PUTB2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R26
	.ENDM

	.MACRO __PUTW2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z,R27
	.ENDM

	.MACRO __PUTD2SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z+,R26
	ST   Z+,R27
	ST   Z+,R24
	ST   Z,R25
	.ENDM

	.MACRO __PUTBSRX
	MOVW R30,R28
	SUBI R30,LOW(-@1)
	SBCI R31,HIGH(-@1)
	ST   Z,R@0
	.ENDM

	.MACRO __PUTWSRX
	MOVW R30,R28
	SUBI R30,LOW(-@2)
	SBCI R31,HIGH(-@2)
	ST   Z+,R@0
	ST   Z,R@1
	.ENDM

	.MACRO __PUTB1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNX
	MOVW R26,R28
	SUBI R26,LOW(-@0)
	SBCI R27,HIGH(-@0)
	LD   R0,X+
	LD   R27,X
	MOV  R26,R0
	SUBI R26,LOW(-@1)
	SBCI R27,HIGH(-@1)
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	.ENDM

	.MACRO __MULBRR
	MULS R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRRU
	MUL  R@0,R@1
	MOVW R30,R0
	.ENDM

	.MACRO __MULBRR0
	MULS R@0,R@1
	.ENDM

	.MACRO __MULBRRU0
	MUL  R@0,R@1
	.ENDM

	.MACRO __MULBNWRU
	LDI  R26,@2
	MUL  R26,R@0
	MOVW R30,R0
	MUL  R26,R@1
	ADD  R31,R0
	.ENDM

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF __lcd_x=R8
	.DEF __lcd_y=R7
	.DEF __lcd_maxx=R10

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_0x0:
	.DB  0x46,0x3A,0x20,0x25,0x32,0x69,0x2E,0x25
	.DB  0x30,0x33,0x69,0x2E,0x25,0x30,0x33,0x69
	.DB  0x20,0x48,0x7A,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x73,0x3A,0x20,0x20,0x20,0x20
	.DB  0x31,0x4D,0x48,0x7A,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x73,0x3A,0x20,0x20,0x31
	.DB  0x30,0x30,0x6B,0x48,0x7A,0x0,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x73,0x3A,0x20,0x20
	.DB  0x20,0x31,0x30,0x6B,0x48,0x7A,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x73,0x3A,0x20
	.DB  0x20,0x20,0x20,0x31,0x6B,0x48,0x7A,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x73,0x3A
	.DB  0x20,0x20,0x31,0x30,0x30,0x20,0x48,0x7A
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x73
	.DB  0x3A,0x20,0x20,0x20,0x31,0x30,0x20,0x48
	.DB  0x7A,0x0,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x73,0x3A,0x20,0x20,0x20,0x20,0x31,0x20
	.DB  0x48,0x7A,0x0,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x73,0x3A,0x20,0x20,0x20,0x20,0x30
	.DB  0x20,0x48,0x7A,0x0
_0x2000003:
	.DB  0x80,0xC0
_0x2020060:
	.DB  0x1
_0x2020000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

	.DW  0x01
	.DW  __seed_G101
	.DW  _0x2020060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  GICR,R31
	OUT  GICR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	SBIW R24,1
	BRNE __CLEAR_SRAM

;GLOBAL VARIABLES INITIALIZATION
	LDI  R30,LOW(__GLOBAL_INI_TBL*2)
	LDI  R31,HIGH(__GLOBAL_INI_TBL*2)
__GLOBAL_INI_NEXT:
	LPM  R24,Z+
	LPM  R25,Z+
	SBIW R24,0
	BREQ __GLOBAL_INI_END
	LPM  R26,Z+
	LPM  R27,Z+
	LPM  R0,Z+
	LPM  R1,Z+
	MOVW R22,R30
	MOVW R30,R0
__GLOBAL_INI_LOOP:
	LPM  R0,Z+
	ST   X+,R0
	SBIW R24,1
	BRNE __GLOBAL_INI_LOOP
	MOVW R30,R22
	RJMP __GLOBAL_INI_NEXT
__GLOBAL_INI_END:

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 9/13/2013
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
;*****************************************************/
;
;#include <mega32.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;// Declare your global variables here
;#include <delay.h>
;#include <stdlib.h>
;#include <stdint.h>
;#include <stdio.h>
;
;#define DAT_2   PORTB.0
;#define CLK     PORTB.1
;#define FUD     PORTB.2
;#define DAT     PORTB.3
;#define RST     PORTB.4
;
;#define T_DOWN  PINA.0
;#define T_UP    PINA.1
;#define S_DOWN  PINA.2
;#define S_UP    PINA.3
;
;#define LOW     0
;#define HIGH    1
;
;eeprom uint32_t freq = 1000000;
;eeprom uint32_t d_freq;
;eeprom uint32_t step = 1000000;
;eeprom uint32_t d_step;
;char lcd[32];
;
;void dds_reset(void)
; 0000 0038 {

	.CSEG
_dds_reset:
; 0000 0039         CLK = LOW;
	CBI  0x18,1
; 0000 003A         FUD = LOW;
	CBI  0x18,2
; 0000 003B         DAT = LOW;
	CBI  0x18,3
; 0000 003C 
; 0000 003D         RST = LOW;      delay_us(5);
	CBI  0x18,4
	__DELAY_USB 27
; 0000 003E         RST = HIGH;     delay_us(5);
	SBI  0x18,4
	__DELAY_USB 27
; 0000 003F         RST = LOW;
	CBI  0x18,4
; 0000 0040 
; 0000 0041         CLK = LOW;      delay_us(5);
	CBI  0x18,1
	__DELAY_USB 27
; 0000 0042         CLK = HIGH;     delay_us(5);
	SBI  0x18,1
	__DELAY_USB 27
; 0000 0043         CLK = LOW;
	CBI  0x18,1
; 0000 0044 
; 0000 0045         FUD = LOW;      delay_us(5);
	CBI  0x18,2
	__DELAY_USB 27
; 0000 0046         FUD = HIGH;     delay_us(5);
	SBI  0x18,2
	__DELAY_USB 27
; 0000 0047         FUD = LOW;
	CBI  0x18,2
; 0000 0048 }
	RET
;
;flash unsigned char phase = ((90 * 100 / 1125) + 0);
;
;void send_data(void)
; 0000 004D {
_send_data:
; 0000 004E         uint32_t data_word = (freq * 4294967296) / 100000000;
; 0000 004F         unsigned long data_word_2 = data_word + (phase << 35);
; 0000 0050         int i;
; 0000 0051 
; 0000 0052         FUD = HIGH;     delay_us(5);
	SBIW R28,8
	ST   -Y,R17
	ST   -Y,R16
;	data_word -> Y+6
;	data_word_2 -> Y+2
;	i -> R16,R17
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	CALL __CDF1U
	__GETD2N 0x4F800000
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4CBEBC20
	CALL __DIVF21
	CALL __CFD1U
	__PUTD1S 6
	__PUTD1S 2
	SBI  0x18,2
	__DELAY_USB 27
; 0000 0053         FUD = LOW;
	CBI  0x18,2
; 0000 0054 
; 0000 0055         for(i=0; i<40; i++)
	__GETWRN 16,17,0
_0x20:
	__CPWRN 16,17,40
	BRGE _0x21
; 0000 0056         {
; 0000 0057                 DAT = ((data_word >> i) & 0x01);
	MOV  R30,R16
	__GETD2S 6
	CALL __LSRD12
	ANDI R30,LOW(0x1)
	BRNE _0x22
	CBI  0x18,3
	RJMP _0x23
_0x22:
	SBI  0x18,3
_0x23:
; 0000 0058                 DAT_2 = ((data_word_2 >> i) & 0x01);
	MOV  R30,R16
	__GETD2S 2
	CALL __LSRD12
	ANDI R30,LOW(0x1)
	BRNE _0x24
	CBI  0x18,0
	RJMP _0x25
_0x24:
	SBI  0x18,0
_0x25:
; 0000 0059                 delay_us(10);
	__DELAY_USB 53
; 0000 005A 
; 0000 005B                 CLK = HIGH;
	SBI  0x18,1
; 0000 005C                 delay_us(5);
	__DELAY_USB 27
; 0000 005D                 CLK = LOW;
	CBI  0x18,1
; 0000 005E         }
	__ADDWRN 16,17,1
	RJMP _0x20
_0x21:
; 0000 005F 
; 0000 0060         delay_us(10);
	__DELAY_USB 53
; 0000 0061 
; 0000 0062         FUD = HIGH;
	SBI  0x18,2
; 0000 0063         delay_us(5);
	__DELAY_USB 27
; 0000 0064         FUD = LOW;
	CBI  0x18,2
; 0000 0065 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,10
	RET
;
;void display(void)
; 0000 0068 {
_display:
; 0000 0069         char string[32];
; 0000 006A 
; 0000 006B         uint32_t temp_freq = freq;
; 0000 006C         int mega;
; 0000 006D         int kilo;
; 0000 006E         int hertz;
; 0000 006F 
; 0000 0070         mega = (int)(temp_freq / 1000000);
	SBIW R28,36
	CALL __SAVELOCR6
;	string -> Y+10
;	temp_freq -> Y+6
;	mega -> R16,R17
;	kilo -> R18,R19
;	hertz -> R20,R21
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	__PUTD1S 6
	__GETD2S 6
	__GETD1N 0xF4240
	CALL __DIVD21U
	MOVW R16,R30
; 0000 0071         temp_freq = temp_freq % 1000000;
	__GETD2S 6
	__GETD1N 0xF4240
	CALL __MODD21U
	__PUTD1S 6
; 0000 0072         kilo = temp_freq / 1000;
	__GETD2S 6
	__GETD1N 0x3E8
	CALL __DIVD21U
	MOVW R18,R30
; 0000 0073         hertz= temp_freq % 1000;
	__GETD2S 6
	__GETD1N 0x3E8
	CALL __MODD21U
	MOVW R20,R30
; 0000 0074 
; 0000 0075         lcd_clear();
	CALL _lcd_clear
; 0000 0076         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0077         sprintf(lcd,"F: %2i.%03i.%03i Hz",mega,kilo,hertz);
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R16
	CALL __CWD1
	CALL __PUTPARD1
	MOVW R30,R18
	CALL __CWD1
	CALL __PUTPARD1
	MOVW R30,R20
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
; 0000 0078         lcd_puts(lcd);
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0079 
; 0000 007A         ltoa(step,string);
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	CALL __PUTPARD1
	MOVW R30,R28
	ADIW R30,14
	ST   -Y,R31
	ST   -Y,R30
	CALL _ltoa
; 0000 007B 
; 0000 007C         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 007D         if(step == 1000000)
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0xF4240
	BRNE _0x2E
; 0000 007E         {
; 0000 007F                     // 0123456789abcdef
; 0000 0080             lcd_putsf("      s:    1MHz");
	__POINTW1FN _0x0,20
	RJMP _0x67
; 0000 0081         }
; 0000 0082         else if(step == 100000)
_0x2E:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x186A0
	BRNE _0x30
; 0000 0083         {
; 0000 0084                     // 0123456789abcdef
; 0000 0085             lcd_putsf("      s:  100kHz");
	__POINTW1FN _0x0,37
	RJMP _0x67
; 0000 0086         }
; 0000 0087         else if(step == 10000)
_0x30:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x2710
	BRNE _0x32
; 0000 0088         {
; 0000 0089                     // 0123456789abcdef
; 0000 008A             lcd_putsf("      s:   10kHz");
	__POINTW1FN _0x0,54
	RJMP _0x67
; 0000 008B         }
; 0000 008C         else if(step == 1000)
_0x32:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x3E8
	BRNE _0x34
; 0000 008D         {
; 0000 008E                     // 0123456789abcdef
; 0000 008F             lcd_putsf("      s:    1kHz");
	__POINTW1FN _0x0,71
	RJMP _0x67
; 0000 0090         }
; 0000 0091         else if(step == 100)
_0x34:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x64
	BRNE _0x36
; 0000 0092         {
; 0000 0093                     // 0123456789abcdef
; 0000 0094             lcd_putsf("      s:  100 Hz");
	__POINTW1FN _0x0,88
	RJMP _0x67
; 0000 0095         }
; 0000 0096         else if(step == 10)
_0x36:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0xA
	BRNE _0x38
; 0000 0097         {
; 0000 0098                     // 0123456789abcdef
; 0000 0099             lcd_putsf("      s:   10 Hz");
	__POINTW1FN _0x0,105
	RJMP _0x67
; 0000 009A         }
; 0000 009B         else if(step == 1)
_0x38:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x1
	BRNE _0x3A
; 0000 009C         {
; 0000 009D                     // 0123456789abcdef
; 0000 009E             lcd_putsf("      s:    1 Hz");
	__POINTW1FN _0x0,122
	RJMP _0x67
; 0000 009F         }
; 0000 00A0         else
_0x3A:
; 0000 00A1         {
; 0000 00A2                     // 0123456789abcdef
; 0000 00A3             lcd_putsf("      s:    0 Hz");
	__POINTW1FN _0x0,139
_0x67:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 00A4         }
; 0000 00A5 }
	CALL __LOADLOCR6
	ADIW R28,42
	RET
;
;void tuning (void)
; 0000 00A8 {
_tuning:
; 0000 00A9         if(!T_UP)
	SBIC 0x19,1
	RJMP _0x3C
; 0000 00AA         {
; 0000 00AB                 delay_ms(125);
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00AC 
; 0000 00AD                 d_freq = freq;
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	LDI  R26,LOW(_d_freq)
	LDI  R27,HIGH(_d_freq)
	CALL __EEPROMWRD
; 0000 00AE                 freq += step;
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __ADDD12
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMWRD
; 0000 00AF                 if(freq > 30000000) freq = 30000000;
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	__CPD1N 0x1C9C381
	BRLO _0x3D
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	__GETD1N 0x1C9C380
	CALL __EEPROMWRD
; 0000 00B0         }
_0x3D:
; 0000 00B1 
; 0000 00B2         if(!T_DOWN)
_0x3C:
	SBIC 0x19,0
	RJMP _0x3E
; 0000 00B3         {
; 0000 00B4                 delay_ms(125);
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00B5 
; 0000 00B6                 d_freq = freq;
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	LDI  R26,LOW(_d_freq)
	LDI  R27,HIGH(_d_freq)
	CALL __EEPROMWRD
; 0000 00B7                 if((step == 1)&&(freq == 1));
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x1
	BRNE _0x40
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	__CPD1N 0x1
	BREQ _0x41
_0x40:
	RJMP _0x3F
_0x41:
; 0000 00B8                 else
	RJMP _0x42
_0x3F:
; 0000 00B9                 {
; 0000 00BA                         if((freq / step) < 2)   step /= 10;
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __DIVD21U
	__CPD1N 0x2
	BRSH _0x43
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0xA
	CALL __DIVD21U
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMWRD
; 0000 00BB                         freq -= step;
_0x43:
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __SWAPD12
	CALL __SUBD12
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMWRD
; 0000 00BC                 }
_0x42:
; 0000 00BD                 if(freq < 0)        freq = 0;
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	MOVW R26,R30
	MOVW R24,R22
; 0000 00BE         }
; 0000 00BF 
; 0000 00C0         if(!S_UP)
_0x3E:
	SBIC 0x19,3
	RJMP _0x45
; 0000 00C1         {
; 0000 00C2                 delay_ms(125);
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00C3 
; 0000 00C4                 d_step = step;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	LDI  R26,LOW(_d_step)
	LDI  R27,HIGH(_d_step)
	CALL __EEPROMWRD
; 0000 00C5 
; 0000 00C6                 if(step == 0)
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	CALL __CPD10
	BRNE _0x46
; 0000 00C7                 {
; 0000 00C8                     step = 1;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0x1
	RJMP _0x68
; 0000 00C9                 }
; 0000 00CA                 else if(step == 1)
_0x46:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x1
	BRNE _0x48
; 0000 00CB                 {
; 0000 00CC                     step = 10;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0xA
	RJMP _0x68
; 0000 00CD                 }
; 0000 00CE                 else if(step == 10)
_0x48:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0xA
	BRNE _0x4A
; 0000 00CF                 {
; 0000 00D0                     step = 100;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0x64
	RJMP _0x68
; 0000 00D1                 }
; 0000 00D2                 else if(step == 100)
_0x4A:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x64
	BRNE _0x4C
; 0000 00D3                 {
; 0000 00D4                     step = 1000;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0x3E8
	RJMP _0x68
; 0000 00D5                 }
; 0000 00D6                 else if(step == 1000)
_0x4C:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x3E8
	BRNE _0x4E
; 0000 00D7                 {
; 0000 00D8                     step = 10000;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0x2710
	RJMP _0x68
; 0000 00D9                 }
; 0000 00DA                 else if(step == 10000)
_0x4E:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x2710
	BRNE _0x50
; 0000 00DB                 {
; 0000 00DC                     step = 100000;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0x186A0
	RJMP _0x68
; 0000 00DD                 }
; 0000 00DE                 else if(step == 100000)
_0x50:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x186A0
	BRNE _0x52
; 0000 00DF                 {
; 0000 00E0                     step = 1000000;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0xF4240
_0x68:
	CALL __EEPROMWRD
; 0000 00E1                 }
; 0000 00E2         }
_0x52:
; 0000 00E3 
; 0000 00E4         if(!S_DOWN)
_0x45:
	SBIC 0x19,2
	RJMP _0x53
; 0000 00E5         {
; 0000 00E6                 delay_ms(125);
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 00E7 
; 0000 00E8                 d_step = step;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	LDI  R26,LOW(_d_step)
	LDI  R27,HIGH(_d_step)
	CALL __EEPROMWRD
; 0000 00E9 
; 0000 00EA                 if(step == 1000000)
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0xF4240
	BRNE _0x54
; 0000 00EB                 {
; 0000 00EC                     step = 100000;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0x186A0
	RJMP _0x69
; 0000 00ED                 }
; 0000 00EE                 else if(step == 100000)
_0x54:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x186A0
	BRNE _0x56
; 0000 00EF                 {
; 0000 00F0                     step = 10000;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0x2710
	RJMP _0x69
; 0000 00F1                 }
; 0000 00F2                 else if(step == 10000)
_0x56:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x2710
	BRNE _0x58
; 0000 00F3                 {
; 0000 00F4                     step = 1000;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0x3E8
	RJMP _0x69
; 0000 00F5                 }
; 0000 00F6                 else if(step == 1000)
_0x58:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x3E8
	BRNE _0x5A
; 0000 00F7                 {
; 0000 00F8                     step = 100;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0x64
	RJMP _0x69
; 0000 00F9                 }
; 0000 00FA                 else if(step == 100)
_0x5A:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x64
	BRNE _0x5C
; 0000 00FB                 {
; 0000 00FC                     step = 10;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0xA
	RJMP _0x69
; 0000 00FD                 }
; 0000 00FE                 else if(step == 10)
_0x5C:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0xA
	BRNE _0x5E
; 0000 00FF                 {
; 0000 0100                     step = 1;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0x1
	RJMP _0x69
; 0000 0101                 }
; 0000 0102                 else if(step == 1)
_0x5E:
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	__CPD1N 0x1
	BRNE _0x60
; 0000 0103                 {
; 0000 0104                     step = 0;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	__GETD1N 0x0
_0x69:
	CALL __EEPROMWRD
; 0000 0105                 }
; 0000 0106         }
_0x60:
; 0000 0107 
; 0000 0108         if(d_freq != freq)
_0x53:
	LDI  R26,LOW(_d_freq)
	LDI  R27,HIGH(_d_freq)
	CALL __EEPROMRDD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BREQ _0x61
; 0000 0109         {
; 0000 010A                 dds_reset();
	RCALL _dds_reset
; 0000 010B                 send_data();
	RCALL _send_data
; 0000 010C                 display();
	RCALL _display
; 0000 010D                 d_freq = freq;
	LDI  R26,LOW(_freq)
	LDI  R27,HIGH(_freq)
	CALL __EEPROMRDD
	LDI  R26,LOW(_d_freq)
	LDI  R27,HIGH(_d_freq)
	CALL __EEPROMWRD
; 0000 010E         }
; 0000 010F 
; 0000 0110         if(d_step != step)
_0x61:
	LDI  R26,LOW(_d_step)
	LDI  R27,HIGH(_d_step)
	CALL __EEPROMRDD
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	CALL __CPD12
	BREQ _0x62
; 0000 0111         {
; 0000 0112                 display();
	RCALL _display
; 0000 0113                 d_step = step;
	LDI  R26,LOW(_step)
	LDI  R27,HIGH(_step)
	CALL __EEPROMRDD
	LDI  R26,LOW(_d_step)
	LDI  R27,HIGH(_d_step)
	CALL __EEPROMWRD
; 0000 0114         }
; 0000 0115 }
_0x62:
	RET
;
;void main(void)
; 0000 0118 {
_main:
; 0000 0119         PORTA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 011A         DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 011B         PORTB=0x00;
	OUT  0x18,R30
; 0000 011C         DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 011D         PORTC=0xFF;
	OUT  0x15,R30
; 0000 011E         DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 011F         PORTD=0x00;
	OUT  0x12,R30
; 0000 0120         DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0121 
; 0000 0122         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0123         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0124 
; 0000 0125 // Alphanumeric LCD initialization
; 0000 0126 // Connections specified in the
; 0000 0127 // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 0128 // RS - PORTD Bit 7
; 0000 0129 // RD - PORTD Bit 6
; 0000 012A // EN - PORTD Bit 5
; 0000 012B // D4 - PORTD Bit 4
; 0000 012C // D5 - PORTD Bit 3
; 0000 012D // D6 - PORTD Bit 2
; 0000 012E // D7 - PORTD Bit 1
; 0000 012F // Characters/line: 16
; 0000 0130 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 0131 dds_reset();
	RCALL _dds_reset
; 0000 0132 send_data();
	RCALL _send_data
; 0000 0133 display();
	RCALL _display
; 0000 0134 
; 0000 0135 while (1)
_0x63:
; 0000 0136       {
; 0000 0137       // Place your code here
; 0000 0138       tuning();
	RCALL _tuning
; 0000 0139 
; 0000 013A       }
	RJMP _0x63
; 0000 013B }
_0x66:
	RJMP _0x66
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.DSEG

	.CSEG
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x12,3
	RJMP _0x2000005
_0x2000004:
	CBI  0x12,3
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x12,2
	RJMP _0x2000007
_0x2000006:
	CBI  0x12,2
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x12,1
	RJMP _0x2000009
_0x2000008:
	CBI  0x12,1
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x12,0
	RJMP _0x200000B
_0x200000A:
	CBI  0x12,0
_0x200000B:
	__DELAY_USB 11
	SBI  0x12,4
	__DELAY_USB 27
	CBI  0x12,4
	__DELAY_USB 27
	RJMP _0x20C0002
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 200
	RJMP _0x20C0002
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R8,Y+1
	LDD  R7,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(0)
	MOV  R7,R30
	MOV  R8,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	CP   R8,R10
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R7
	ST   -Y,R7
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x20C0002
_0x2000013:
_0x2000010:
	INC  R8
	SBI  0x12,6
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x12,6
	RJMP _0x20C0002
_lcd_puts:
	ST   -Y,R17
_0x2000014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	RJMP _0x20C0003
_lcd_putsf:
	ST   -Y,R17
_0x2000017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000017
_0x2000019:
_0x20C0003:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x11,3
	SBI  0x11,2
	SBI  0x11,1
	SBI  0x11,0
	SBI  0x11,4
	SBI  0x11,6
	SBI  0x11,5
	CBI  0x12,4
	CBI  0x12,6
	CBI  0x12,5
	LDD  R10,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 400
	LDI  R30,LOW(40)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(133)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL __lcd_write_data
	RCALL _lcd_clear
_0x20C0002:
	ADIW R28,1
	RET

	.CSEG
_ltoa:
	SBIW R28,4
	ST   -Y,R17
	ST   -Y,R16
	__GETD1N 0x3B9ACA00
	__PUTD1S 2
	LDI  R16,LOW(0)
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2020003
	__GETD1S 8
	CALL __ANEGD1
	__PUTD1S 8
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	LDI  R30,LOW(45)
	ST   X,R30
_0x2020003:
_0x2020005:
	__GETD1S 2
	__GETD2S 8
	CALL __DIVD21U
	MOV  R17,R30
	CPI  R17,0
	BRNE _0x2020008
	CPI  R16,0
	BRNE _0x2020008
	__GETD2S 2
	__CPD2N 0x1
	BRNE _0x2020007
_0x2020008:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	MOV  R30,R17
	SUBI R30,-LOW(48)
	ST   X,R30
	LDI  R16,LOW(1)
_0x2020007:
	__GETD1S 2
	__GETD2S 8
	CALL __MODD21U
	__PUTD1S 8
	__GETD2S 2
	__GETD1N 0xA
	CALL __DIVD21U
	__PUTD1S 2
	CALL __CPD10
	BREQ _0x2020006
	RJMP _0x2020005
_0x2020006:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,12
	RET

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x80
	.EQU __sm_mask=0x70
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0x60
	.EQU __sm_ext_standby=0x70
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_put_buff_G102:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2040014:
_0x2040013:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G102:
	SBIW R28,12
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
	LDD  R30,Y+24
	LDD  R31,Y+24+1
	ADIW R30,1
	STD  Y+24,R30
	STD  Y+24+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	ST   -Y,R18
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ICALL
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	ST   -Y,R18
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ICALL
	RJMP _0x20400E4
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R30,LOW(0)
	STD  Y+17,R30
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R30,LOW(43)
	STD  Y+17,R30
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R30,LOW(32)
	STD  Y+17,R30
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BRNE _0x2040028
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	LDI  R20,LOW(0)
	CPI  R18,46
	BRNE _0x204002C
	LDI  R17,LOW(4)
	RJMP _0x204001B
_0x204002C:
	RJMP _0x204002D
_0x2040028:
	CPI  R30,LOW(0x4)
	BRNE _0x204002F
	CPI  R18,48
	BRLO _0x2040031
	CPI  R18,58
	BRLO _0x2040032
_0x2040031:
	RJMP _0x2040030
_0x2040032:
	LDI  R26,LOW(10)
	MUL  R20,R26
	MOV  R20,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R20,R30
	RJMP _0x204001B
_0x2040030:
_0x204002D:
	CPI  R18,108
	BRNE _0x2040033
	ORI  R16,LOW(2)
	LDI  R17,LOW(5)
	RJMP _0x204001B
_0x2040033:
	RJMP _0x2040034
_0x204002F:
	CPI  R30,LOW(0x5)
	BREQ PC+3
	JMP _0x204001B
_0x2040034:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x2040039
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,4
	STD  Y+22,R30
	STD  Y+22+1,R31
	LDD  R26,Z+4
	ST   -Y,R26
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ICALL
	RJMP _0x204003A
_0x2040039:
	CPI  R30,LOW(0x73)
	BRNE _0x204003C
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,4
	STD  Y+22,R30
	STD  Y+22+1,R31
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlen
	MOV  R17,R30
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x70)
	BRNE _0x204003F
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,4
	STD  Y+22,R30
	STD  Y+22+1,R31
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x204003D:
	ANDI R16,LOW(127)
	CPI  R20,0
	BREQ _0x2040041
	CP   R20,R17
	BRLO _0x2040042
_0x2040041:
	RJMP _0x2040040
_0x2040042:
	MOV  R17,R20
_0x2040040:
	LDI  R20,LOW(0)
	LDI  R30,LOW(0)
	STD  Y+16,R30
	LDI  R19,LOW(0)
	RJMP _0x2040043
_0x204003F:
	CPI  R30,LOW(0x64)
	BREQ _0x2040046
	CPI  R30,LOW(0x69)
	BRNE _0x2040047
_0x2040046:
	ORI  R16,LOW(4)
	RJMP _0x2040048
_0x2040047:
	CPI  R30,LOW(0x75)
	BRNE _0x2040049
_0x2040048:
	LDI  R30,LOW(10)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x204004A
	__GETD1N 0x3B9ACA00
	__PUTD1S 8
	LDI  R17,LOW(10)
	RJMP _0x204004B
_0x204004A:
	__GETD1N 0x2710
	__PUTD1S 8
	LDI  R17,LOW(5)
	RJMP _0x204004B
_0x2040049:
	CPI  R30,LOW(0x58)
	BRNE _0x204004D
	ORI  R16,LOW(8)
	RJMP _0x204004E
_0x204004D:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x204008C
_0x204004E:
	LDI  R30,LOW(16)
	STD  Y+16,R30
	SBRS R16,1
	RJMP _0x2040050
	__GETD1N 0x10000000
	__PUTD1S 8
	LDI  R17,LOW(8)
	RJMP _0x204004B
_0x2040050:
	__GETD1N 0x1000
	__PUTD1S 8
	LDI  R17,LOW(4)
_0x204004B:
	CPI  R20,0
	BREQ _0x2040051
	ANDI R16,LOW(127)
	RJMP _0x2040052
_0x2040051:
	LDI  R20,LOW(1)
_0x2040052:
	SBRS R16,1
	RJMP _0x2040053
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,4
	STD  Y+22,R30
	STD  Y+22+1,R31
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETD1P
	RJMP _0x20400E5
_0x2040053:
	SBRS R16,2
	RJMP _0x2040055
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,4
	STD  Y+22,R30
	STD  Y+22+1,R31
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETW1P
	CALL __CWD1
	RJMP _0x20400E5
_0x2040055:
	LDD  R30,Y+22
	LDD  R31,Y+22+1
	SBIW R30,4
	STD  Y+22,R30
	STD  Y+22+1,R31
	LDD  R26,Y+22
	LDD  R27,Y+22+1
	ADIW R26,4
	CALL __GETW1P
	CLR  R22
	CLR  R23
_0x20400E5:
	__PUTD1S 12
	SBRS R16,2
	RJMP _0x2040057
	LDD  R26,Y+15
	TST  R26
	BRPL _0x2040058
	__GETD1S 12
	CALL __ANEGD1
	__PUTD1S 12
	LDI  R30,LOW(45)
	STD  Y+17,R30
_0x2040058:
	LDD  R30,Y+17
	CPI  R30,0
	BREQ _0x2040059
	SUBI R17,-LOW(1)
	SUBI R20,-LOW(1)
	RJMP _0x204005A
_0x2040059:
	ANDI R16,LOW(251)
_0x204005A:
_0x2040057:
	MOV  R19,R20
_0x2040043:
	SBRC R16,0
	RJMP _0x204005B
_0x204005C:
	CP   R17,R21
	BRSH _0x204005F
	CP   R19,R21
	BRLO _0x2040060
_0x204005F:
	RJMP _0x204005E
_0x2040060:
	SBRS R16,7
	RJMP _0x2040061
	SBRS R16,2
	RJMP _0x2040062
	ANDI R16,LOW(251)
	LDD  R18,Y+17
	SUBI R17,LOW(1)
	RJMP _0x2040063
_0x2040062:
	LDI  R18,LOW(48)
_0x2040063:
	RJMP _0x2040064
_0x2040061:
	LDI  R18,LOW(32)
_0x2040064:
	ST   -Y,R18
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ICALL
	SUBI R21,LOW(1)
	RJMP _0x204005C
_0x204005E:
_0x204005B:
_0x2040065:
	CP   R17,R20
	BRSH _0x2040067
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040068
	ANDI R16,LOW(251)
	LDD  R30,Y+17
	ST   -Y,R30
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ICALL
	CPI  R21,0
	BREQ _0x2040069
	SUBI R21,LOW(1)
_0x2040069:
	SUBI R17,LOW(1)
	SUBI R20,LOW(1)
_0x2040068:
	LDI  R30,LOW(48)
	ST   -Y,R30
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ICALL
	CPI  R21,0
	BREQ _0x204006A
	SUBI R21,LOW(1)
_0x204006A:
	SUBI R20,LOW(1)
	RJMP _0x2040065
_0x2040067:
	MOV  R19,R17
	LDD  R30,Y+16
	CPI  R30,0
	BRNE _0x204006B
_0x204006C:
	CPI  R19,0
	BREQ _0x204006E
	SBRS R16,3
	RJMP _0x204006F
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040070
_0x204006F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040070:
	ST   -Y,R18
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ICALL
	CPI  R21,0
	BREQ _0x2040071
	SUBI R21,LOW(1)
_0x2040071:
	SUBI R19,LOW(1)
	RJMP _0x204006C
_0x204006E:
	RJMP _0x2040072
_0x204006B:
_0x2040074:
	__GETD1S 8
	__GETD2S 12
	CALL __DIVD21U
	MOV  R18,R30
	CPI  R18,10
	BRLO _0x2040076
	SBRS R16,3
	RJMP _0x2040077
	SUBI R18,-LOW(55)
	RJMP _0x2040078
_0x2040077:
	SUBI R18,-LOW(87)
_0x2040078:
	RJMP _0x2040079
_0x2040076:
	SUBI R18,-LOW(48)
_0x2040079:
	SBRC R16,4
	RJMP _0x204007B
	CPI  R18,49
	BRSH _0x204007D
	__GETD2S 8
	__CPD2N 0x1
	BRNE _0x204007C
_0x204007D:
	RJMP _0x204007F
_0x204007C:
	CP   R20,R19
	BRSH _0x20400E6
	CP   R21,R19
	BRLO _0x2040082
	SBRS R16,0
	RJMP _0x2040083
_0x2040082:
	RJMP _0x2040081
_0x2040083:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040084
_0x20400E6:
	LDI  R18,LOW(48)
_0x204007F:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x2040085
	ANDI R16,LOW(251)
	LDD  R30,Y+17
	ST   -Y,R30
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ICALL
	CPI  R21,0
	BREQ _0x2040086
	SUBI R21,LOW(1)
_0x2040086:
_0x2040085:
_0x2040084:
_0x204007B:
	ST   -Y,R18
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ICALL
	CPI  R21,0
	BREQ _0x2040087
	SUBI R21,LOW(1)
_0x2040087:
_0x2040081:
	SUBI R19,LOW(1)
	__GETD1S 8
	__GETD2S 12
	CALL __MODD21U
	__PUTD1S 12
	LDD  R30,Y+16
	__GETD2S 8
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __DIVD21U
	__PUTD1S 8
	CALL __CPD10
	BREQ _0x2040075
	RJMP _0x2040074
_0x2040075:
_0x2040072:
	SBRS R16,0
	RJMP _0x2040088
_0x2040089:
	CPI  R21,0
	BREQ _0x204008B
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	LDD  R30,Y+19
	LDD  R31,Y+19+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+23
	LDD  R31,Y+23+1
	ICALL
	RJMP _0x2040089
_0x204008B:
_0x2040088:
_0x204008C:
_0x204003A:
_0x20400E4:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
	LDD  R26,Y+18
	LDD  R27,Y+18+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,26
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	SBIW R30,0
	BRNE _0x204008D
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x204008D:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R30,LOW(0)
	STD  Y+8,R30
	STD  Y+8+1,R30
	MOVW R26,R28
	ADIW R26,10
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.CSEG

	.CSEG
_strlen:
    ld   r26,y+
    ld   r27,y+
    clr  r30
    clr  r31
strlen0:
    ld   r22,x+
    tst  r22
    breq strlen1
    adiw r30,1
    rjmp strlen0
strlen1:
    ret
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.ESEG
_freq:
	.DB  LOW(0xF4240),HIGH(0xF4240),BYTE3(0xF4240),BYTE4(0xF4240)
_d_freq:
	.BYTE 0x4
_step:
	.DB  LOW(0xF4240),HIGH(0xF4240),BYTE3(0xF4240),BYTE4(0xF4240)
_d_step:
	.BYTE 0x4

	.DSEG
_lcd:
	.BYTE 0x20
__base_y_G100:
	.BYTE 0x4
__seed_G101:
	.BYTE 0x4

	.CSEG

	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__LSRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __LSRD12R
__LSRD12L:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRD12L
__LSRD12R:
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDD:
	ADIW R26,2
	RCALL __EEPROMRDW
	MOVW R22,R30
	SBIW R26,2

__EEPROMRDW:
	ADIW R26,1
	RCALL __EEPROMRDB
	MOV  R31,R30
	SBIW R26,1

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R30,EEDR
	OUT  SREG,R31
	POP  R31
	RET

__EEPROMWRD:
	RCALL __EEPROMWRW
	ADIW R26,2
	MOVW R0,R30
	MOVW R30,R22
	RCALL __EEPROMWRW
	MOVW R30,R0
	SBIW R26,2
	RET

__EEPROMWRW:
	RCALL __EEPROMWRB
	ADIW R26,1
	PUSH R30
	MOV  R30,R31
	RCALL __EEPROMWRB
	POP  R30
	SBIW R26,1
	RET

__EEPROMWRB:
	SBIS EECR,EEWE
	RJMP __EEPROMWRB1
	WDR
	RJMP __EEPROMWRB
__EEPROMWRB1:
	IN   R25,SREG
	CLI
	OUT  EEARL,R26
	OUT  EEARH,R27
	SBI  EECR,EERE
	IN   R24,EEDR
	CP   R30,R24
	BREQ __EEPROMWRB0
	OUT  EEDR,R30
	SBI  EECR,EEMWE
	SBI  EECR,EEWE
__EEPROMWRB0:
	OUT  SREG,R25
	RET

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	RET

__SAVELOCR6:
	ST   -Y,R21
__SAVELOCR5:
	ST   -Y,R20
__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR6:
	LDD  R21,Y+5
__LOADLOCR5:
	LDD  R20,Y+4
__LOADLOCR4:
	LDD  R19,Y+3
__LOADLOCR3:
	LDD  R18,Y+2
__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
