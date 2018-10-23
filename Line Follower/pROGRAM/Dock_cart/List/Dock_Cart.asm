
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External RAM size      : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;global const stored in FLASH  : No
;8 bit enums            : Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
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
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
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

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
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

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	LDI  R23,BYTE4(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	LDI  R23,BYTE4(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
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

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
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
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTB1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	CALL __EEPROMWRD
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
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
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
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
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
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
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
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
	.DEF _i_speed=R4
	.DEF _speed=R6
	.DEF _MV=R8
	.DEF _error=R10
	.DEF _error_before=R12

	.CSEG
	.ORG 0x00

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer0_comp_isr
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0008

_0x3:
	.DB  0xD
_0x0:
	.DB  0x25,0x64,0x0,0x25,0x64,0x20,0x25,0x64
	.DB  0x20,0x25,0x64,0x20,0x25,0x64,0x20,0x0
	.DB  0x25,0x64,0x20,0x25,0x64,0x20,0x25,0x64
	.DB  0x20,0x25,0x64,0x0,0x3D,0x25,0x64,0x0
	.DB  0x20,0x20,0x20,0x0,0x20,0x3C,0x2D,0x20
	.DB  0x25,0x64,0x0,0x31,0x2E,0x20,0x41,0x72
	.DB  0x61,0x68,0x20,0x50,0x65,0x72,0x34,0x61
	.DB  0x6E,0x20,0x31,0x0,0x32,0x2E,0x20,0x41
	.DB  0x72,0x61,0x68,0x20,0x50,0x65,0x72,0x34
	.DB  0x61,0x6E,0x20,0x32,0x0,0x33,0x2E,0x20
	.DB  0x41,0x72,0x61,0x68,0x20,0x50,0x65,0x72
	.DB  0x34,0x61,0x6E,0x20,0x33,0x0,0x34,0x2E
	.DB  0x20,0x41,0x72,0x61,0x68,0x20,0x50,0x65
	.DB  0x72,0x34,0x61,0x6E,0x20,0x34,0x0,0x35
	.DB  0x2E,0x20,0x41,0x72,0x61,0x68,0x20,0x50
	.DB  0x65,0x72,0x34,0x61,0x6E,0x20,0x35,0x0
	.DB  0x6C,0x65,0x66,0x74,0x0,0x72,0x69,0x67
	.DB  0x68,0x74,0x0,0x6C,0x75,0x72,0x75,0x73
	.DB  0x0,0x3C,0x2D,0x0,0x4B,0x52,0x3D,0x0
	.DB  0x4B,0x4E,0x3D,0x0,0x6C,0x61,0x6E,0x67
	.DB  0x6B,0x61,0x68,0x3D,0x0,0x31,0x2E,0x20
	.DB  0x55,0x6A,0x69,0x20,0x4C,0x61,0x6E,0x67
	.DB  0x6B,0x61,0x68,0x20,0x0,0x32,0x2E,0x20
	.DB  0x41,0x72,0x61,0x68,0x20,0x50,0x65,0x72
	.DB  0x34,0x61,0x6E,0x0,0x33,0x2E,0x20,0x50
	.DB  0x65,0x6D,0x62,0x61,0x67,0x69,0x20,0x4B
	.DB  0x70,0x0,0x34,0x2E,0x20,0x74,0x65,0x73
	.DB  0x74,0x5F,0x64,0x72,0x69,0x76,0x65,0x0
	.DB  0x31,0x2E,0x20,0x53,0x70,0x65,0x65,0x64
	.DB  0x20,0x0,0x32,0x2E,0x20,0x41,0x75,0x74
	.DB  0x6F,0x20,0x53,0x65,0x74,0x20,0x0,0x52
	.DB  0x55,0x4E,0x3F,0x0,0x50,0x49,0x44,0x0
	.DB  0x44,0x65,0x74,0x65,0x6B,0x73,0x69,0x20
	.DB  0x50,0x65,0x72,0x34,0x61,0x6E,0x0,0x4E
	.DB  0x4F,0x53,0x2D,0x4E,0x4F,0x53,0x0,0x55
	.DB  0x73,0x69,0x6E,0x67,0x20,0x41,0x49,0x0
	.DB  0x47,0x41,0x52,0x55,0x44,0x41,0x0,0x44
	.DB  0x49,0x20,0x44,0x41,0x44,0x41,0x4B,0x55
	.DB  0x21,0x21,0x21,0x0
_0x204005F:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _kp_div
	.DW  _0x3*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x204005F*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

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
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
	LDI  R26,0x60
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V1.25.9 Professional
;Automatic Program Generator
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 28/03/2009
;Author  : aditya rifki
;Company : TE UGM
;Comments:
;
;
;Chip type           : ATmega16
;Program type        : Application
;Clock frequency     : 8,000000 MHz
;Memory model        : Small
;External SRAM size  : 0
;Data Stack size     : 256
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
;#include <stdio.h>
;#include <math.h>
;#include <stdlib.h>
;#include <lcd.h>
;#include <delay.h>
;#include <math.h>
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 0023 #endasm
;
;#define led           PORTC.7
;#define backlight     PORTB.3
;
;#define ADC_VREF_TYPE 0x60
;#define enter   PINC.0
;#define back    PIND.7
;
;#define dir_ki   PORTD.1
;#define dir_ka   PORTD.6
;#define pwm_ki   OCR1B
;#define pwm_ka   OCR1A
;
;bit status_error_lalu,status_error,pwm_en,black_line=1,per4an_enable=0,status_nos=0;
;bit white_line,berhasil=0,flag_per4an=0,flag_siku;
;int i_speed,speed,MV,error,error_before,d_d_error,d_error,min_kp,max_kp,kp,kd,speed_ka,speed_ki,temp_speed;
;unsigned char  l, menu, kp_div=13, menu_slave, strategi,temp_adc_menu,;

	.DSEG
;unsigned char adc_result1[8],adc_result2[8],adc_tres1[8],adc_tres2[8],adc_menu,lcd[16];
;unsigned char max_adc1[8],max_adc2[8],min_adc1[8],min_adc2[8];
;unsigned int temp_langkah_nos[10],langkah_rem[10], langkah_cepat[10],langkah_nos[10];
;unsigned char nos_speed,boleh_nos,i,j,n,front_sensor,rear_sensor,disp_sensor,backlight_on,led_on,right_back,left_back;
;unsigned char set_per4an, per4an,siku,per4an_dir[6];
;unsigned char sampling_blank=0,sampling_blank_black=0,temp_kp_div;
;unsigned int siku_kiri=0, siku_kanan=0,time,count, nos, temp_langkah, langkah_kanan,langkah_kiri,langkah,step,sigma_langkah,k;
;
;eeprom int e_speed=200,e_min_kp=8,e_max_kp=30;
;eeprom unsigned char e_adc_tres1[8]={100,100,100,100,100,100,100,100};
;eeprom unsigned char e_adc_tres2[8]={100,100,100,100,100,100,100,100};
;eeprom unsigned char e_kp_div=13;
;eeprom unsigned char e_per4an_dir[6];
;eeprom unsigned char e_per4an_enable=0;
;eeprom unsigned int e_langkah_nos[10], e_langkah_cepat[10];
;
;
;unsigned char read_adc(unsigned char adc_input)
; 0000 0047 {

	.CSEG
_read_adc:
; 0000 0048     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	CALL SUBOPT_0x0
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 0049     // Delay needed for the stabilization of the ADC input voltage
; 0000 004A     delay_us(10);
	__DELAY_USB 27
; 0000 004B     // Start the AD conversion
; 0000 004C     ADCSRA|=0x40;
	CALL SUBOPT_0x1
	ORI  R30,0x40
	OUT  0x6,R30
; 0000 004D     // Wait for the AD conversion to complete
; 0000 004E     while ((ADCSRA & 0x10)==0);
_0x4:
	CALL SUBOPT_0x1
	ANDI R30,LOW(0x10)
	BREQ _0x4
; 0000 004F     ADCSRA|=0x10;
	CALL SUBOPT_0x1
	ORI  R30,0x10
	OUT  0x6,R30
; 0000 0050     return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0051 }
;
;void init_IO()
; 0000 0054 {
_init_IO:
; 0000 0055     unsigned char ;
; 0000 0056     DDRA=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0057     PORTA=0b00000000;
	OUT  0x1B,R30
; 0000 0058 
; 0000 0059     DDRB=0b11111111;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 005A     PORTB=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 005B 
; 0000 005C     DDRC=0b11111100;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0000 005D     PORTC=0b10000011;
	LDI  R30,LOW(131)
	OUT  0x15,R30
; 0000 005E 
; 0000 005F     DDRD= 0b01110010;
	LDI  R30,LOW(114)
	OUT  0x11,R30
; 0000 0060     PORTD=0b10001100;
	LDI  R30,LOW(140)
	OUT  0x12,R30
; 0000 0061     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0062 }
	RET
;
;void init_ADC()
; 0000 0065 {
_init_ADC:
; 0000 0066     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 0067     ADCSRA=0x86;
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 0068 }
	RET
;
;void init_time_on()
; 0000 006B {
_init_time_on:
; 0000 006C     // Timer/Counter 0 initialization
; 0000 006D     // Clock source: System Clock
; 0000 006E     // Clock value: 7.813 kHz
; 0000 006F     // Mode: ctc
; 0000 0070     // OC0 output: Disconnected
; 0000 0071 
; 0000 0072     //OCR0 7,813 = 53 ms
; 0000 0073     TCCR0=0x0D;
	LDI  R30,LOW(13)
	OUT  0x33,R30
; 0000 0074     TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 0075     TIMSK=0x02;
	LDI  R30,LOW(2)
	OUT  0x39,R30
; 0000 0076     OCR0=30; //setiap 8 ms
	LDI  R30,LOW(30)
	OUT  0x3C,R30
; 0000 0077 
; 0000 0078     //ASSR=0x00;
; 0000 0079     //TCCR2=0x0F;
; 0000 007A     //TCNT2=0x00;
; 0000 007B     //OCR2=50;
; 0000 007C 
; 0000 007D     #asm ("sei")
	sei
; 0000 007E }
	RET
;
;
;
;void init_time_off()
; 0000 0083 {
_init_time_off:
; 0000 0084     // Timer/Counter 0 initialization
; 0000 0085     // Clock source: System Clock
; 0000 0086     // Clock value: 7.813 kHz
; 0000 0087     // Mode: Normal top=FFh
; 0000 0088     // OC0 output: Disconnected
; 0000 0089     TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 008A     TCNT0=0x00;
	OUT  0x32,R30
; 0000 008B     OCR0=0x00;
	OUT  0x3C,R30
; 0000 008C 
; 0000 008D     TIMSK=0x00;
	OUT  0x39,R30
; 0000 008E     #asm ("cli")
	cli
; 0000 008F }
	RET
;
;void pwm_on()
; 0000 0092 {
_pwm_on:
; 0000 0093     pwm_en=1;
	SET
	BLD  R2,2
; 0000 0094     TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0095     TCCR1B=0x03;
	LDI  R30,LOW(3)
	RJMP _0x20C0006
; 0000 0096 }
;
;void pwm_off()
; 0000 0099 {
_pwm_off:
; 0000 009A     pwm_en=0;
	CLT
	BLD  R2,2
; 0000 009B     dir_ki=0;
	CBI  0x12,1
; 0000 009C     dir_ka=0;
	CBI  0x12,6
; 0000 009D     TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 009E     TCCR1B=0x00;
_0x20C0006:
	OUT  0x2E,R30
; 0000 009F }
	RET
;
;void intrpt_on()
; 0000 00A2 {
_intrpt_on:
; 0000 00A3     // External Interrupt(s) initialization
; 0000 00A4     // INT0: On
; 0000 00A5     // INT0 Mode: Falling Edge
; 0000 00A6     // INT1: On
; 0000 00A7     // INT1 Mode: Falling Edge
; 0000 00A8     // INT2: Off
; 0000 00A9 
; 0000 00AA 
; 0000 00AB     GICR|=0x40;
	IN   R30,0x3B
	LDI  R31,0
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 00AC     MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 00AD     MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00AE     GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 00AF     TIFR=0x00;
	LDI  R30,LOW(0)
	OUT  0x38,R30
; 0000 00B0     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00B1     // Global enable interrupts
; 0000 00B2     #asm("sei")
	sei
; 0000 00B3 }
	RET
;
;void intrpt_off()
; 0000 00B6 {
_intrpt_off:
; 0000 00B7     // External Interrupt(s) initialization
; 0000 00B8     // INT0: On
; 0000 00B9     // INT0 Mode: Falling Edge
; 0000 00BA     // INT1: On
; 0000 00BB     // INT1 Mode: Falling Edge
; 0000 00BC     // INT2: Off
; 0000 00BD     GICR|=0x00;
	IN   R30,0x3B
	LDI  R31,0
	OUT  0x3B,R30
; 0000 00BE     MCUCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x35,R30
; 0000 00BF     MCUCSR=0x00;
	OUT  0x34,R30
; 0000 00C0     GIFR=0x00;
	OUT  0x3A,R30
; 0000 00C1 
; 0000 00C2     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00C3     TIMSK=0x00;
	OUT  0x39,R30
; 0000 00C4     langkah_kiri=0;
	CALL SUBOPT_0x2
; 0000 00C5     langkah_kanan=0;
	CALL SUBOPT_0x3
; 0000 00C6     langkah=0;
	CALL SUBOPT_0x4
; 0000 00C7     sigma_langkah=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _sigma_langkah,R30
	STS  _sigma_langkah+1,R31
; 0000 00C8     // Global enable interrupts
; 0000 00C9     #asm("cli")
	cli
; 0000 00CA }
	RET
;
;
;void read_sensor()
; 0000 00CE {
_read_sensor:
; 0000 00CF     front_sensor=0;
	LDI  R30,LOW(0)
	STS  _front_sensor,R30
; 0000 00D0     rear_sensor=0;
	STS  _rear_sensor,R30
; 0000 00D1 
; 0000 00D2     for(i=0;i<8;i++)
	STS  _i,R30
_0xC:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRLO PC+3
	JMP _0xD
; 0000 00D3         {
; 0000 00D4             if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
	LDS  R30,_i
	CPI  R30,0
	BRNE _0xE
	CBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 00D5             else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
	RJMP _0x15
_0xE:
	LDS  R26,_i
	CPI  R26,LOW(0x1)
	BRNE _0x16
	CBI  0x15,6
	CBI  0x15,5
	RJMP _0x2EB
; 0000 00D6             else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
_0x16:
	LDS  R26,_i
	CPI  R26,LOW(0x2)
	BRNE _0x1E
	CBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 00D7             else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
	RJMP _0x25
_0x1E:
	LDS  R26,_i
	CPI  R26,LOW(0x3)
	BRNE _0x26
	CBI  0x15,6
	RJMP _0x2EC
; 0000 00D8             else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
_0x26:
	LDS  R26,_i
	CPI  R26,LOW(0x4)
	BRNE _0x2E
	SBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 00D9             else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
	RJMP _0x35
_0x2E:
	LDS  R26,_i
	CPI  R26,LOW(0x5)
	BRNE _0x36
	SBI  0x15,6
	CBI  0x15,5
	RJMP _0x2EB
; 0000 00DA             else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
_0x36:
	LDS  R26,_i
	CPI  R26,LOW(0x6)
	BRNE _0x3E
	SBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 00DB             else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
	RJMP _0x45
_0x3E:
	LDS  R26,_i
	CPI  R26,LOW(0x7)
	BRNE _0x46
	SBI  0x15,6
_0x2EC:
	SBI  0x15,5
_0x2EB:
	SBI  0x15,4
; 0000 00DC             adc_result1[i]=read_adc(7);//depan
_0x46:
_0x45:
_0x35:
_0x25:
_0x15:
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00DD             adc_result2[i]=read_adc(6);//belakang
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_adc_result2)
	SBCI R31,HIGH(-_adc_result2)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 00DE         }
	CALL SUBOPT_0x7
	RJMP _0xC
_0xD:
; 0000 00DF     //adc_result_top=read_adc(1);
; 0000 00E0 
; 0000 00E1     for(i=0;i<8;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x4E:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0x4F
; 0000 00E2         {
; 0000 00E3             if      (adc_result1[i]>adc_tres1[i]){front_sensor=front_sensor|1<<i;}
	CALL SUBOPT_0x5
	CALL SUBOPT_0x8
	CP   R30,R26
	BRSH _0x50
	CALL SUBOPT_0x9
	RJMP _0x2ED
; 0000 00E4             else if (adc_result1[i]<adc_tres1[i]){front_sensor=front_sensor|0<<i;}
_0x50:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x8
	CP   R26,R30
	BRSH _0x52
	CALL SUBOPT_0xA
_0x2ED:
	STS  _front_sensor,R30
; 0000 00E5 
; 0000 00E6             if      (adc_result2[i]>adc_tres2[i]){rear_sensor=rear_sensor|1<<i;}
_0x52:
	CALL SUBOPT_0x5
	CALL SUBOPT_0xB
	CP   R30,R26
	BRSH _0x53
	LDS  R22,_rear_sensor
	CLR  R23
	LDS  R30,_i
	LDI  R26,LOW(1)
	CALL __LSLB12
	LDI  R31,0
	MOVW R26,R22
	OR   R30,R26
	RJMP _0x2EE
; 0000 00E7             else if (adc_result2[i]<adc_tres2[i]){rear_sensor=rear_sensor|0<<i;}
_0x53:
	CALL SUBOPT_0x5
	CALL SUBOPT_0xB
	CP   R26,R30
	BRSH _0x55
	CALL SUBOPT_0xC
_0x2EE:
	STS  _rear_sensor,R30
; 0000 00E8         }
_0x55:
	CALL SUBOPT_0x7
	RJMP _0x4E
_0x4F:
; 0000 00E9 
; 0000 00EA     rear_sensor=0b01111110&rear_sensor;
	CALL SUBOPT_0xC
	ANDI R30,LOW(0x7E)
	ANDI R31,HIGH(0x7E)
	STS  _rear_sensor,R30
; 0000 00EB }
	RET
;
;void read_rear_sensor()
; 0000 00EE {
; 0000 00EF     front_sensor=0;
; 0000 00F0     rear_sensor=0;
; 0000 00F1 
; 0000 00F2     for(i=0;i<8;i++)
; 0000 00F3     {
; 0000 00F4         if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
; 0000 00F5         else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
; 0000 00F6         else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
; 0000 00F7         else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
; 0000 00F8         else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
; 0000 00F9         else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
; 0000 00FA         else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
; 0000 00FB         else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
; 0000 00FC        // adc_result1[i]=read_adc(7);//depan
; 0000 00FD         adc_result2[i]=read_adc(6);//belakang
; 0000 00FE     }
; 0000 00FF     //adc_result_top=read_adc(1);
; 0000 0100 
; 0000 0101     for(i=0;i<8;i++)
; 0000 0102     {
; 0000 0103         if      (adc_result2[i]>adc_tres2[i]){rear_sensor=rear_sensor|1<<i;}
; 0000 0104         else if (adc_result2[i]<adc_tres2[i]){rear_sensor=rear_sensor|0<<i;}
; 0000 0105     }
; 0000 0106 
; 0000 0107     rear_sensor=0b01111110&rear_sensor;
; 0000 0108 }
;
;void read_front_sensor()
; 0000 010B {
_read_front_sensor:
; 0000 010C     front_sensor=0;
	LDI  R30,LOW(0)
	STS  _front_sensor,R30
; 0000 010D 
; 0000 010E     for(i=0;i<8;i++)
	STS  _i,R30
_0x9F:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRLO PC+3
	JMP _0xA0
; 0000 010F     {
; 0000 0110         if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
	LDS  R30,_i
	CPI  R30,0
	BRNE _0xA1
	CBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 0111         else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
	RJMP _0xA8
_0xA1:
	LDS  R26,_i
	CPI  R26,LOW(0x1)
	BRNE _0xA9
	CBI  0x15,6
	CBI  0x15,5
	RJMP _0x2F2
; 0000 0112         else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
_0xA9:
	LDS  R26,_i
	CPI  R26,LOW(0x2)
	BRNE _0xB1
	CBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 0113         else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
	RJMP _0xB8
_0xB1:
	LDS  R26,_i
	CPI  R26,LOW(0x3)
	BRNE _0xB9
	CBI  0x15,6
	RJMP _0x2F3
; 0000 0114         else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
_0xB9:
	LDS  R26,_i
	CPI  R26,LOW(0x4)
	BRNE _0xC1
	SBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 0115         else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
	RJMP _0xC8
_0xC1:
	LDS  R26,_i
	CPI  R26,LOW(0x5)
	BRNE _0xC9
	SBI  0x15,6
	CBI  0x15,5
	RJMP _0x2F2
; 0000 0116         else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
_0xC9:
	LDS  R26,_i
	CPI  R26,LOW(0x6)
	BRNE _0xD1
	SBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 0117         else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
	RJMP _0xD8
_0xD1:
	LDS  R26,_i
	CPI  R26,LOW(0x7)
	BRNE _0xD9
	SBI  0x15,6
_0x2F3:
	SBI  0x15,5
_0x2F2:
	SBI  0x15,4
; 0000 0118         adc_result1[i]=read_adc(7);//depan
_0xD9:
_0xD8:
_0xC8:
_0xB8:
_0xA8:
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0119     }
	CALL SUBOPT_0x7
	RJMP _0x9F
_0xA0:
; 0000 011A     //adc_result_top=read_adc(1);
; 0000 011B 
; 0000 011C     for(i=0;i<8;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0xE1:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0xE2
; 0000 011D     {
; 0000 011E         if      (adc_result1[i]>adc_tres1[i]){front_sensor=front_sensor|1<<i;}
	CALL SUBOPT_0x5
	CALL SUBOPT_0x8
	CP   R30,R26
	BRSH _0xE3
	CALL SUBOPT_0x9
	RJMP _0x2F4
; 0000 011F         else if (adc_result1[i]<adc_tres1[i]){front_sensor=front_sensor|0<<i;}
_0xE3:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x8
	CP   R26,R30
	BRSH _0xE5
	CALL SUBOPT_0xA
_0x2F4:
	STS  _front_sensor,R30
; 0000 0120     }
_0xE5:
	CALL SUBOPT_0x7
	RJMP _0xE1
_0xE2:
; 0000 0121 }
	RET
;
;void ka_maju()
; 0000 0124 {
_ka_maju:
; 0000 0125     dir_ka=0;
	CBI  0x12,6
; 0000 0126     pwm_ka=speed_ka;
	RJMP _0x20C0005
; 0000 0127 }
;
;void ka_mund()
; 0000 012A {
_ka_mund:
; 0000 012B     if(pwm_en==1)dir_ka  =1;
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xE8
	SBI  0x12,6
; 0000 012C     speed_ka=255+speed_ka;
_0xE8:
	LDS  R30,_speed_ka
	LDS  R31,_speed_ka+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	CALL SUBOPT_0xD
; 0000 012D     pwm_ka  =speed_ka;
_0x20C0005:
	LDS  R30,_speed_ka
	LDS  R31,_speed_ka+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 012E }
	RET
;
;void ki_maju()
; 0000 0131 {
_ki_maju:
; 0000 0132     dir_ki=0;
	CBI  0x12,1
; 0000 0133     pwm_ki=speed_ki;
	RJMP _0x20C0004
; 0000 0134 }
;
;void ki_mund()
; 0000 0137 {
_ki_mund:
; 0000 0138     if(pwm_en==1)dir_ki  =1;
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	CPI  R26,LOW(0x1)
	BRNE _0xED
	SBI  0x12,1
; 0000 0139     speed_ki=255+speed_ki;
_0xED:
	LDS  R30,_speed_ki
	LDS  R31,_speed_ki+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	CALL SUBOPT_0xE
; 0000 013A     pwm_ki  =speed_ki;
_0x20C0004:
	LDS  R30,_speed_ki
	LDS  R31,_speed_ki+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 013B }
	RET
;
;void pwm_out()
; 0000 013E {
_pwm_out:
; 0000 013F     if      (speed_ka>255)  speed_ka  =255;
	LDS  R26,_speed_ka
	LDS  R27,_speed_ka+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0xF0
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x2F5
; 0000 0140     else if (speed_ka<-255) speed_ka  =-255;
_0xF0:
	LDS  R26,_speed_ka
	LDS  R27,_speed_ka+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0xF2
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
_0x2F5:
	STS  _speed_ka,R30
	STS  _speed_ka+1,R31
; 0000 0141 
; 0000 0142     if      (speed_ki>255)  speed_ki  =255;
_0xF2:
	LDS  R26,_speed_ki
	LDS  R27,_speed_ki+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0xF3
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x2F6
; 0000 0143     else if (speed_ki<-255) speed_ki  =-255;
_0xF3:
	LDS  R26,_speed_ki
	LDS  R27,_speed_ki+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0xF5
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
_0x2F6:
	STS  _speed_ki,R30
	STS  _speed_ki+1,R31
; 0000 0144 
; 0000 0145 
; 0000 0146     for(i=0;i<8;i++)
_0xF5:
	LDI  R30,LOW(0)
	STS  _i,R30
_0xF7:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0xF8
; 0000 0147     {
; 0000 0148         disp_sensor=0;
	LDI  R30,LOW(0)
	STS  _disp_sensor,R30
; 0000 0149         disp_sensor=front_sensor>>i;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xF
; 0000 014A         disp_sensor=(disp_sensor)&(0b00000001);
; 0000 014B         n=7-i;
	CALL SUBOPT_0x10
; 0000 014C         lcd_gotoxy(n,0);
	CALL SUBOPT_0x11
; 0000 014D         sprintf(lcd,"%d",disp_sensor);
	CALL SUBOPT_0x12
; 0000 014E         lcd_puts(lcd);
; 0000 014F     }
	CALL SUBOPT_0x7
	RJMP _0xF7
_0xF8:
; 0000 0150 
; 0000 0151     for(i=0;i<8;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0xFA:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0xFB
; 0000 0152     {
; 0000 0153         disp_sensor=0;
	LDI  R30,LOW(0)
	STS  _disp_sensor,R30
; 0000 0154         disp_sensor=rear_sensor>>i;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xF
; 0000 0155         disp_sensor=(disp_sensor)&(0b00000001);
; 0000 0156         n=7-i;
	CALL SUBOPT_0x10
; 0000 0157         lcd_gotoxy(n,1);
	CALL SUBOPT_0x13
; 0000 0158         sprintf(lcd,"%d",disp_sensor);
	CALL SUBOPT_0x12
; 0000 0159         lcd_puts(lcd);
; 0000 015A     }
	CALL SUBOPT_0x7
	RJMP _0xFA
_0xFB:
; 0000 015B 
; 0000 015C     lcd_gotoxy(9,0);
	LDI  R30,LOW(9)
	ST   -Y,R30
	CALL SUBOPT_0x11
; 0000 015D     sprintf(lcd,"%d",error);
	MOVW R30,R10
	CALL SUBOPT_0x14
; 0000 015E     lcd_puts(lcd);
; 0000 015F 
; 0000 0160     lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL SUBOPT_0x11
; 0000 0161     sprintf(lcd,"%d",langkah);
	LDS  R30,_langkah
	LDS  R31,_langkah+1
	CALL SUBOPT_0x15
; 0000 0162     lcd_puts(lcd);
; 0000 0163 
; 0000 0164     lcd_gotoxy(15,0);
	LDI  R30,LOW(15)
	ST   -Y,R30
	CALL SUBOPT_0x11
; 0000 0165     sprintf(lcd,"%d",per4an);
	LDS  R30,_per4an
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0166     lcd_puts(lcd);
; 0000 0167 
; 0000 0168     lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 0169     sprintf(lcd,"%d",speed_ki);
	LDS  R30,_speed_ki
	LDS  R31,_speed_ki+1
	CALL SUBOPT_0x14
; 0000 016A     lcd_puts(lcd);
; 0000 016B 
; 0000 016C     lcd_gotoxy(13,1);
	LDI  R30,LOW(13)
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 016D     sprintf(lcd,"%d",speed_ka);
	LDS  R30,_speed_ka
	LDS  R31,_speed_ka+1
	CALL SUBOPT_0x14
; 0000 016E     lcd_puts(lcd);
; 0000 016F 
; 0000 0170     if      (speed_ka >=0)  ka_maju();
	LDS  R26,_speed_ka+1
	TST  R26
	BRMI _0xFC
	RCALL _ka_maju
; 0000 0171     else if (speed_ka <0)   ka_mund();
	RJMP _0xFD
_0xFC:
	LDS  R26,_speed_ka+1
	TST  R26
	BRPL _0xFE
	RCALL _ka_mund
; 0000 0172 
; 0000 0173     if      (speed_ki >=0)  ki_maju();
_0xFE:
_0xFD:
	LDS  R26,_speed_ki+1
	TST  R26
	BRMI _0xFF
	RCALL _ki_maju
; 0000 0174     else if (speed_ki <0)   ki_mund();
	RJMP _0x100
_0xFF:
	LDS  R26,_speed_ki+1
	TST  R26
	BRPL _0x101
	RCALL _ki_mund
; 0000 0175 }
_0x101:
_0x100:
	RET
;
;void komp_pid()
; 0000 0178 {
_komp_pid:
; 0000 0179     d_error =error-error_before;
	MOVW R30,R10
	SUB  R30,R12
	SBC  R31,R13
	STS  _d_error,R30
	STS  _d_error+1,R31
; 0000 017A     MV      =(kp*error)+(kd*d_error);
	MOVW R30,R10
	LDS  R26,_kp
	LDS  R27,_kp+1
	CALL __MULW12
	MOVW R22,R30
	LDS  R30,_d_error
	LDS  R31,_d_error+1
	LDS  R26,_kd
	LDS  R27,_kd+1
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	MOVW R8,R30
; 0000 017B 
; 0000 017C     speed_ka=i_speed+MV;
	MOVW R30,R8
	ADD  R30,R4
	ADC  R31,R5
	CALL SUBOPT_0xD
; 0000 017D     speed_ki=i_speed-MV;
	MOVW R30,R4
	SUB  R30,R8
	SBC  R31,R9
	CALL SUBOPT_0xE
; 0000 017E 
; 0000 017F     error_before=error;
	MOVW R12,R10
; 0000 0180     d_d_error=error-d_error;
	LDS  R26,_d_error
	LDS  R27,_d_error+1
	MOVW R30,R10
	SUB  R30,R26
	SBC  R31,R27
	STS  _d_d_error,R30
	STS  _d_d_error+1,R31
; 0000 0181 }
	RET
;
;void giving_weight10()
; 0000 0184 {
_giving_weight10:
; 0000 0185     switch(front_sensor)
	CALL SUBOPT_0xA
; 0000 0186     {
; 0000 0187     case 0b00000001:error=  16;white_line=0;break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x105
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP _0x2F7
; 0000 0188     case 0b00000010:error=  10;white_line=0;break;
_0x105:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x106
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP _0x2F7
; 0000 0189     case 0b00000100:error=   5;white_line=0;break;
_0x106:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x107
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x2F7
; 0000 018A     case 0b00001000:error=   1;white_line=0;kp=speed/20;kd=6*kp;break;
_0x107:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x108
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x18
	RJMP _0x104
; 0000 018B     case 0b00010000:error=  -1;white_line=0;kp=speed/20;kd=6*kp;;break;
_0x108:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x109
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL SUBOPT_0x18
	RJMP _0x104
; 0000 018C     case 0b00100000:error=  -5;white_line=0;break;
_0x109:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x10A
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	RJMP _0x2F7
; 0000 018D     case 0b01000000:error= -10;white_line=0;break;
_0x10A:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x10B
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	RJMP _0x2F7
; 0000 018E     case 0b10000000:error= -16;white_line=0;break;
_0x10B:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x104
	LDI  R30,LOW(65520)
	LDI  R31,HIGH(65520)
_0x2F7:
	MOVW R10,R30
	CLT
	BLD  R2,6
; 0000 018F     }
_0x104:
; 0000 0190 }
	RET
;
;
;void giving_weight20()
; 0000 0194 {
_giving_weight20:
; 0000 0195     switch(front_sensor)
	CALL SUBOPT_0xA
; 0000 0196     {
; 0000 0197         case 0b00000011:error=  13;white_line=0;break;
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x110
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP _0x2F8
; 0000 0198         case 0b00000110:error=   7;white_line=0;break;
_0x110:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x111
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP _0x2F8
; 0000 0199         case 0b00001100:error=   3;white_line=0;break;
_0x111:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x112
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x2F8
; 0000 019A         case 0b00011000:error=   0;kp=speed/20;kd=6*kp;white_line=0;break;
_0x112:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x113
	CLR  R10
	CLR  R11
	MOVW R26,R6
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x19
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL SUBOPT_0x1A
	RJMP _0x2F9
; 0000 019B         case 0b00110000:error=  -3;white_line=0;break;
_0x113:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x114
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	RJMP _0x2F8
; 0000 019C         case 0b01100000:error=  -7;white_line=0;break;
_0x114:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x115
	LDI  R30,LOW(65529)
	LDI  R31,HIGH(65529)
	RJMP _0x2F8
; 0000 019D         case 0b11000000:error= -13;white_line=0;break;
_0x115:
	CPI  R30,LOW(0xC0)
	LDI  R26,HIGH(0xC0)
	CPC  R31,R26
	BRNE _0x10F
	LDI  R30,LOW(65523)
	LDI  R31,HIGH(65523)
_0x2F8:
	MOVW R10,R30
_0x2F9:
	CLT
	BLD  R2,6
; 0000 019E     }
_0x10F:
; 0000 019F }
	RET
;
;void giving_weight11()
; 0000 01A2 {
; 0000 01A3     switch(front_sensor)
; 0000 01A4     {
; 0000 01A5         case 0b11111110:error=  16; backlight_on=10;white_line=1;break;
; 0000 01A6         case 0b11111101:error=  10;backlight_on=10;white_line=1;break;
; 0000 01A7     case 0b11111011:error=   5;backlight_on=10;white_line=1;break;
; 0000 01A8     case 0b11110111:error=   1;backlight_on=10;white_line=1;kp=speed/20;kd=6*kp;break;
; 0000 01A9     case 0b11101111:error=  -1;backlight_on=10;white_line=1;kp=speed/20;kd=6*kp;break;
; 0000 01AA     case 0b11011111:error=  -5;backlight_on=10;white_line=1;break;
; 0000 01AB     case 0b10111111:error= -10;backlight_on=10;white_line=1;break;
; 0000 01AC     case 0b01111111:error= -16;backlight_on=10;white_line=1;break;
; 0000 01AD     }
; 0000 01AE }
;
;
;void giving_weight21()
; 0000 01B2 {
; 0000 01B3 switch(front_sensor)
; 0000 01B4     {
; 0000 01B5     case 0b11111100:error=  13;backlight_on=10;white_line=1;break;
; 0000 01B6     case 0b11111001:error=   7;backlight_on=10;white_line=1;break;
; 0000 01B7     case 0b11110011:error=   3;backlight_on=10;white_line=1;break;
; 0000 01B8     case 0b11100111:error=   0;backlight_on=10;white_line=1;kp=speed/20;kd=6*kp;break;
; 0000 01B9     case 0b11001111:error=  -3;backlight_on=10;white_line=1;break;
; 0000 01BA     case 0b10011111:error=  -7;backlight_on=10;white_line=1;break;
; 0000 01BB     case 0b00111111:error= -13;backlight_on=10;white_line=1;break;
; 0000 01BC }
; 0000 01BD }
;
;
;
;void per4an_handler()
; 0000 01C2 {
_per4an_handler:
; 0000 01C3    #asm("cli")
	cli
; 0000 01C4    if(per4an>=4) goto selesai;
	LDS  R26,_per4an
	CPI  R26,LOW(0x4)
	BRLO _0x12C
	RJMP _0x12D
; 0000 01C5    per4an++;
_0x12C:
	LDS  R30,_per4an
	SUBI R30,-LOW(1)
	STS  _per4an,R30
; 0000 01C6 
; 0000 01C7 
; 0000 01C8     if(per4an_dir[per4an]==0) //pilih kiri
	CALL SUBOPT_0x1B
	CPI  R30,0
	BREQ PC+3
	JMP _0x12E
; 0000 01C9     {
; 0000 01CA       berhasil=1;
	SET
	BLD  R2,7
; 0000 01CB       error=15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x1C
; 0000 01CC       speed_ki=-150;
; 0000 01CD       speed_ka=-150;
; 0000 01CE       pwm_out();
; 0000 01CF       delay_ms(40);
	LDI  R30,LOW(40)
	LDI  R31,HIGH(40)
	CALL SUBOPT_0x1D
; 0000 01D0       if(per4an==4)
	LDS  R26,_per4an
	CPI  R26,LOW(0x4)
	BRNE _0x12F
; 0000 01D1       {
; 0000 01D2          speed_ki=-200;
	LDI  R30,LOW(65336)
	LDI  R31,HIGH(65336)
	CALL SUBOPT_0xE
; 0000 01D3          speed_ka=80;
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x2FC
; 0000 01D4       }
; 0000 01D5       else
_0x12F:
; 0000 01D6       {
; 0000 01D7       speed_ki=-200;
	LDI  R30,LOW(65336)
	LDI  R31,HIGH(65336)
	CALL SUBOPT_0xE
; 0000 01D8       speed_ka=120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
_0x2FC:
	STS  _speed_ka,R30
	STS  _speed_ka+1,R31
; 0000 01D9     }
; 0000 01DA       pwm_out();
	RCALL _pwm_out
; 0000 01DB       //error=7;
; 0000 01DC       for(;;){read_front_sensor();if(front_sensor==0b00000011||front_sensor==0b00000001||front_sensor==0b00000010)break;}
_0x132:
	RCALL _read_front_sensor
	LDS  R26,_front_sensor
	CPI  R26,LOW(0x3)
	BREQ _0x135
	CPI  R26,LOW(0x1)
	BREQ _0x135
	CPI  R26,LOW(0x2)
	BRNE _0x134
_0x135:
	RJMP _0x133
_0x134:
	RJMP _0x132
_0x133:
; 0000 01DD 
; 0000 01DE       for(;;){i_speed=-100;read_sensor();giving_weight10();giving_weight20();kp_div=kp_div+3;
_0x138:
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	CALL SUBOPT_0x1E
; 0000 01DF       kp=speed/kp_div;kd=4*kp;komp_pid();pwm_out();if(-3<=error<=3){i_speed=130;speed=temp_speed; break;}}
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	CALL SUBOPT_0x21
	BRSH _0x13A
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	MOVW R4,R30
	CALL SUBOPT_0x22
	RJMP _0x139
_0x13A:
	RJMP _0x138
_0x139:
; 0000 01E0     }
; 0000 01E1     else if (per4an_dir[per4an]==1) //pilih kanan
	RJMP _0x13B
_0x12E:
	CALL SUBOPT_0x1B
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0x13C
; 0000 01E2     {
; 0000 01E3       berhasil=1;
	SET
	BLD  R2,7
; 0000 01E4       error=-15;
	LDI  R30,LOW(65521)
	LDI  R31,HIGH(65521)
	CALL SUBOPT_0x1C
; 0000 01E5       speed_ki=-150;
; 0000 01E6       speed_ka=-150;
; 0000 01E7       pwm_out();
; 0000 01E8       delay_ms(50);
	CALL SUBOPT_0x23
; 0000 01E9       speed_ki=120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0xE
; 0000 01EA       speed_ka=-200;
	LDI  R30,LOW(65336)
	LDI  R31,HIGH(65336)
	CALL SUBOPT_0xD
; 0000 01EB       pwm_out();
	RCALL _pwm_out
; 0000 01EC       //error=-7;
; 0000 01ED       for(;;){read_front_sensor();delay_ms(2);if(front_sensor==0b10000000||front_sensor==0b11000000||front_sensor==0b01000000)break;}
_0x13E:
	RCALL _read_front_sensor
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x1D
	LDS  R26,_front_sensor
	CPI  R26,LOW(0x80)
	BREQ _0x141
	CPI  R26,LOW(0xC0)
	BREQ _0x141
	CPI  R26,LOW(0x40)
	BRNE _0x140
_0x141:
	RJMP _0x13F
_0x140:
	RJMP _0x13E
_0x13F:
; 0000 01EE       kp_div=kp_div+3;
	CALL SUBOPT_0x24
	ADIW R30,3
	STS  _kp_div,R30
; 0000 01EF       kp=speed/kp_div;
	CALL SUBOPT_0x24
	MOVW R26,R6
	CALL SUBOPT_0x19
; 0000 01F0       kd=4*kp;
	CALL SUBOPT_0x1F
; 0000 01F1       for(;;){i_speed=-120;read_sensor();giving_weight10();giving_weight20();kp_div=kp_div+3;
_0x144:
	LDI  R30,LOW(65416)
	LDI  R31,HIGH(65416)
	CALL SUBOPT_0x1E
; 0000 01F2       kp=speed/kp_div;kd=4*kp;komp_pid();pwm_out();delay_ms(2);if(-3<=error<=3){i_speed=180;speed=temp_speed; break;}}
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x20
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x21
	BRSH _0x146
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	MOVW R4,R30
	CALL SUBOPT_0x22
	RJMP _0x145
_0x146:
	RJMP _0x144
_0x145:
; 0000 01F3     }
; 0000 01F4     else delay_ms(30);
	RJMP _0x147
_0x13C:
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x1D
; 0000 01F5     if(per4an<5)speed=130;
_0x147:
_0x13B:
	LDS  R26,_per4an
	CPI  R26,LOW(0x5)
	BRSH _0x148
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	MOVW R6,R30
; 0000 01F6     else speed=temp_speed;
	RJMP _0x149
_0x148:
	CALL SUBOPT_0x22
; 0000 01F7 
; 0000 01F8    flag_per4an=1; right_back=0;left_back=0;
_0x149:
	SET
	BLD  R3,0
	LDI  R30,LOW(0)
	STS  _right_back,R30
	STS  _left_back,R30
; 0000 01F9    selesai:
_0x12D:
; 0000 01FA    #asm("sei")
	sei
; 0000 01FB }
	RET
;
;void line_following()
; 0000 01FE {
_line_following:
; 0000 01FF read_sensor();
	RCALL _read_sensor
; 0000 0200 lcd_clear();
	CALL _lcd_clear
; 0000 0201 led=1;
	SBI  0x15,7
; 0000 0202 backlight=0;
	CBI  0x18,3
; 0000 0203 if(time<=230)time++;
	LDS  R26,_time
	LDS  R27,_time+1
	CPI  R26,LOW(0xE7)
	LDI  R30,HIGH(0xE7)
	CPC  R27,R30
	BRSH _0x14E
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	CALL SUBOPT_0x25
; 0000 0204 
; 0000 0205 if(backlight_on>0){backlight_on--;backlight=1;}
_0x14E:
	LDS  R26,_backlight_on
	CPI  R26,LOW(0x1)
	BRLO _0x14F
	LDS  R30,_backlight_on
	SUBI R30,LOW(1)
	STS  _backlight_on,R30
	SBI  0x18,3
; 0000 0206 else               backlight=0;
	RJMP _0x152
_0x14F:
	CBI  0x18,3
; 0000 0207 
; 0000 0208 if(led_on>0){led_on--;led=0;}
_0x152:
	LDS  R26,_led_on
	CPI  R26,LOW(0x1)
	BRLO _0x155
	LDS  R30,_led_on
	SUBI R30,LOW(1)
	STS  _led_on,R30
	CBI  0x15,7
; 0000 0209 else         led=1;
	RJMP _0x158
_0x155:
	SBI  0x15,7
; 0000 020A 
; 0000 020B if(i_speed<speed)   i_speed=i_speed+10;
_0x158:
	__CPWRR 4,5,6,7
	BRGE _0x15B
	MOVW R30,R4
	ADIW R30,10
	MOVW R4,R30
; 0000 020C else                i_speed=speed;
	RJMP _0x15C
_0x15B:
	MOVW R4,R6
; 0000 020D kp=i_speed/kp_div;
_0x15C:
	CALL SUBOPT_0x24
	MOVW R26,R4
	CALL SUBOPT_0x19
; 0000 020E //kp=kp+0.15* abs(d_error)* abs(d_d_error);
; 0000 020F //if(kp>=30)kp=30;
; 0000 0210 //kd=60-(1.5*kp);
; 0000 0211 kd=3*kp;
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL SUBOPT_0x1A
; 0000 0212 //if(time<240)kp=speed/30;
; 0000 0213 
; 0000 0214 
; 0000 0215 
; 0000 0216 giving_weight10();
	RCALL _giving_weight10
; 0000 0217 giving_weight20();
	RCALL _giving_weight20
; 0000 0218 
; 0000 0219 
; 0000 021A komp_pid();
	CALL SUBOPT_0x20
; 0000 021B 
; 0000 021C 
; 0000 021D //-----------------kondisi khusus menggunakan sensor belakang-----------------//
; 0000 021E 
; 0000 021F pwm_out();
; 0000 0220 }
	RET
;
;
;
;
;
;//--------------------------------------------------------------------------------//
;
;void action()
; 0000 0229 {
_action:
; 0000 022A j=0;
	LDI  R30,LOW(0)
	STS  _j,R30
; 0000 022B init_time_on();
	RCALL _init_time_on
; 0000 022C // if(strategi==3)
; 0000 022D // {
; 0000 022E // intrpt_on();
; 0000 022F // step=90;
; 0000 0230 // }
; 0000 0231 if(strategi==4)
	LDS  R26,_strategi
	CPI  R26,LOW(0x4)
	BRNE _0x15D
; 0000 0232 {
; 0000 0233    per4an=2;
	LDI  R30,LOW(2)
	STS  _per4an,R30
; 0000 0234 }
; 0000 0235 for(;;)
_0x15D:
_0x15F:
; 0000 0236     {
; 0000 0237     line_following();
	RCALL _line_following
; 0000 0238         //if(enter==0){lcd_clear();init_time_off();break;}
; 0000 0239     if(back==0) {lcd_clear();intrpt_off();init_time_off();break;}
	SBIC 0x10,7
	RJMP _0x161
	CALL _lcd_clear
	RCALL _intrpt_off
	RCALL _init_time_off
	RJMP _0x160
; 0000 023A     //delay_ms(2);
; 0000 023B     }
_0x161:
	RJMP _0x15F
_0x160:
; 0000 023C pwm_off();
	RCALL _pwm_off
; 0000 023D intrpt_off();
	RCALL _intrpt_off
; 0000 023E backlight=0;
	CBI  0x18,3
; 0000 023F 
; 0000 0240 
; 0000 0241 
; 0000 0242 led=1;
	SBI  0x15,7
; 0000 0243 backlight=0;
	CBI  0x18,3
; 0000 0244 delay_ms(250);
	RJMP _0x20C0003
; 0000 0245 }
;
;void tampil_auto_set()
; 0000 0248 {
_tampil_auto_set:
; 0000 0249 lcd_gotoxy(0,0);
	CALL SUBOPT_0x26
; 0000 024A sprintf(lcd,"%d %d %d %d ",adc_tres1[0],adc_tres1[1],adc_tres1[2],adc_tres1[3]);
	__POINTW1FN _0x0,3
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adc_tres1
	CALL SUBOPT_0x16
	__GETB1MN _adc_tres1,1
	CALL SUBOPT_0x16
	__GETB1MN _adc_tres1,2
	CALL SUBOPT_0x16
	__GETB1MN _adc_tres1,3
	CALL SUBOPT_0x16
	CALL SUBOPT_0x27
; 0000 024B lcd_puts(lcd);
; 0000 024C 
; 0000 024D lcd_gotoxy(0,1);
	CALL SUBOPT_0x28
; 0000 024E sprintf(lcd,"%d %d %d %d",adc_tres1[4],adc_tres1[5],adc_tres1[6],adc_tres1[7]);
	__POINTW1FN _0x0,16
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _adc_tres1,4
	CALL SUBOPT_0x16
	__GETB1MN _adc_tres1,5
	CALL SUBOPT_0x16
	__GETB1MN _adc_tres1,6
	CALL SUBOPT_0x16
	__GETB1MN _adc_tres1,7
	CALL SUBOPT_0x16
	CALL SUBOPT_0x27
; 0000 024F lcd_puts(lcd);
; 0000 0250 
; 0000 0251 
; 0000 0252 for(;;)
_0x169:
; 0000 0253     {
; 0000 0254     lcd_clear();
	CALL _lcd_clear
; 0000 0255     for(i=0;i<8;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x16C:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRLO PC+3
	JMP _0x16D
; 0000 0256         {
; 0000 0257         if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
	LDS  R30,_i
	CPI  R30,0
	BRNE _0x16E
	CBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 0258         else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
	RJMP _0x175
_0x16E:
	LDS  R26,_i
	CPI  R26,LOW(0x1)
	BRNE _0x176
	CBI  0x15,6
	CBI  0x15,5
	RJMP _0x2FD
; 0000 0259         else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
_0x176:
	LDS  R26,_i
	CPI  R26,LOW(0x2)
	BRNE _0x17E
	CBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 025A         else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
	RJMP _0x185
_0x17E:
	LDS  R26,_i
	CPI  R26,LOW(0x3)
	BRNE _0x186
	CBI  0x15,6
	RJMP _0x2FE
; 0000 025B         else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
_0x186:
	LDS  R26,_i
	CPI  R26,LOW(0x4)
	BRNE _0x18E
	SBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 025C         else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
	RJMP _0x195
_0x18E:
	LDS  R26,_i
	CPI  R26,LOW(0x5)
	BRNE _0x196
	SBI  0x15,6
	CBI  0x15,5
	RJMP _0x2FD
; 0000 025D         else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
_0x196:
	LDS  R26,_i
	CPI  R26,LOW(0x6)
	BRNE _0x19E
	SBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 025E         else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
	RJMP _0x1A5
_0x19E:
	LDS  R26,_i
	CPI  R26,LOW(0x7)
	BRNE _0x1A6
	SBI  0x15,6
_0x2FE:
	SBI  0x15,5
_0x2FD:
	SBI  0x15,4
; 0000 025F         adc_result1[i]=read_adc(7);//depan
_0x1A6:
_0x1A5:
_0x195:
_0x185:
_0x175:
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	PUSH R31
	PUSH R30
	CALL SUBOPT_0x6
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0260         //adc_result2[i]=read_adc(6);//belakang
; 0000 0261         }
	CALL SUBOPT_0x7
	RJMP _0x16C
_0x16D:
; 0000 0262 
; 0000 0263     for(i=0;i<8;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x1AE:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRLO PC+3
	JMP _0x1AF
; 0000 0264         {
; 0000 0265         if(adc_result1[i]>max_adc1[i])max_adc1[i]=adc_result1[i];
	CALL SUBOPT_0x5
	CALL SUBOPT_0x29
	CP   R30,R26
	BRSH _0x1B0
	CALL SUBOPT_0x2A
	SUBI R26,LOW(-_max_adc1)
	SBCI R27,HIGH(-_max_adc1)
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	LD   R30,Z
	ST   X,R30
; 0000 0266         if(adc_result1[i]<max_adc1[i])min_adc1[i]=adc_result1[i];
_0x1B0:
	CALL SUBOPT_0x5
	CALL SUBOPT_0x29
	CP   R26,R30
	BRSH _0x1B1
	CALL SUBOPT_0x2A
	SUBI R26,LOW(-_min_adc1)
	SBCI R27,HIGH(-_min_adc1)
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	LD   R30,Z
	ST   X,R30
; 0000 0267         //adc_tres1[i]=min_adc1[i]+((max_adc1[i]-min_adc1[i])/10);
; 0000 0268         adc_tres1[i]=min_adc1[i]+40;
_0x1B1:
	CALL SUBOPT_0x2A
	SUBI R26,LOW(-_adc_tres1)
	SBCI R27,HIGH(-_adc_tres1)
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_min_adc1)
	SBCI R31,HIGH(-_min_adc1)
	LD   R30,Z
	LDI  R31,0
	ADIW R30,40
	ST   X,R30
; 0000 0269         //adc_tres1[i]=0.6*max_adc1[i];
; 0000 026A 
; 0000 026B         delay_us(50);
	__DELAY_USB 133
; 0000 026C         lcd_gotoxy(0,0);
	CALL SUBOPT_0x26
; 0000 026D         sprintf(lcd,"%d",adc_result1[0]);
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adc_result1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 026E         lcd_puts(lcd);
; 0000 026F 
; 0000 0270         lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL SUBOPT_0x11
; 0000 0271         sprintf(lcd,"%d",adc_result1[1]);
	__GETB1MN _adc_result1,1
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0272         lcd_puts(lcd);
; 0000 0273 
; 0000 0274         lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL SUBOPT_0x11
; 0000 0275         sprintf(lcd,"%d",adc_result1[2]);
	__GETB1MN _adc_result1,2
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0276         lcd_puts(lcd);
; 0000 0277 
; 0000 0278         lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL SUBOPT_0x11
; 0000 0279         sprintf(lcd,"%d",adc_result1[3]);
	__GETB1MN _adc_result1,3
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 027A         lcd_puts(lcd);
; 0000 027B 
; 0000 027C         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 027D         sprintf(lcd,"%d",adc_result1[4]);
	__GETB1MN _adc_result1,4
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 027E         lcd_puts(lcd);
; 0000 027F 
; 0000 0280         lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 0281         sprintf(lcd,"%d",adc_result1[5]);
	__GETB1MN _adc_result1,5
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0282         lcd_puts(lcd);
; 0000 0283 
; 0000 0284         lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 0285         sprintf(lcd,"%d",adc_result1[6]);
	__GETB1MN _adc_result1,6
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 0286         lcd_puts(lcd);
; 0000 0287 
; 0000 0288         lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 0289         sprintf(lcd,"%d",adc_result1[7]);
	__GETB1MN _adc_result1,7
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 028A         lcd_puts(lcd);
; 0000 028B         }
	CALL SUBOPT_0x7
	RJMP _0x1AE
_0x1AF:
; 0000 028C 
; 0000 028D 
; 0000 028E     delay_us(600);
	__DELAY_USW 1200
; 0000 028F     if(enter==0)
	SBIC 0x13,0
	RJMP _0x1B2
; 0000 0290         {
; 0000 0291         for(i=0;i<8;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x1B4:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0x1B5
; 0000 0292             {
; 0000 0293             e_adc_tres1[i]=adc_tres1[i];
	CALL SUBOPT_0x2A
	SUBI R26,LOW(-_e_adc_tres1)
	SBCI R27,HIGH(-_e_adc_tres1)
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_adc_tres1)
	SBCI R31,HIGH(-_adc_tres1)
	LD   R30,Z
	CALL __EEPROMWRB
; 0000 0294             e_adc_tres2[i]=adc_tres2[i];
	CALL SUBOPT_0x2A
	SUBI R26,LOW(-_e_adc_tres2)
	SBCI R27,HIGH(-_e_adc_tres2)
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_adc_tres2)
	SBCI R31,HIGH(-_adc_tres2)
	LD   R30,Z
	CALL __EEPROMWRB
; 0000 0295             }
	CALL SUBOPT_0x7
	RJMP _0x1B4
_0x1B5:
; 0000 0296         break;
	RJMP _0x16A
; 0000 0297         }
; 0000 0298     if(back==0)break;
_0x1B2:
	SBIS 0x10,7
	RJMP _0x16A
; 0000 0299     }
	RJMP _0x169
_0x16A:
; 0000 029A selesai:
; 0000 029B for(i=0;i<8;i++){adc_tres1[i]=e_adc_tres1[i];adc_tres2[i]=e_adc_tres2[i];}
	LDI  R30,LOW(0)
	STS  _i,R30
_0x1B9:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0x1BA
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_adc_tres1)
	SBCI R31,HIGH(-_adc_tres1)
	MOVW R0,R30
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	SUBI R30,LOW(-_adc_tres2)
	SBCI R31,HIGH(-_adc_tres2)
	MOVW R0,R30
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x7
	RJMP _0x1B9
_0x1BA:
; 0000 029C delay_ms(250);
_0x20C0003:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1D
; 0000 029D }
	RET
;
;void tampil_speed()
; 0000 02A0 {
_tampil_speed:
; 0000 02A1 lcd_gotoxy(0,1);
	CALL SUBOPT_0x28
; 0000 02A2 sprintf(lcd,"=%d",speed);
	__POINTW1FN _0x0,28
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R6
	CALL SUBOPT_0x14
; 0000 02A3 lcd_puts(lcd);
; 0000 02A4 for(;;)
_0x1BC:
; 0000 02A5     {
; 0000 02A6     adc_menu=read_adc(0);
	CALL SUBOPT_0x2D
; 0000 02A7     adc_menu=255-adc_menu;
; 0000 02A8 
; 0000 02A9     lcd_gotoxy(8,1);
; 0000 02AA     lcd_putsf("   ");
; 0000 02AB     lcd_gotoxy(5,1);
; 0000 02AC     sprintf(lcd," <- %d",adc_menu);
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 02AD     lcd_puts(lcd);
; 0000 02AE 
; 0000 02AF     if(enter==0){e_speed=adc_menu;speed=adc_menu;temp_speed=speed;delay_ms(400);break;}
	SBIC 0x13,0
	RJMP _0x1BE
	LDS  R30,_adc_menu
	LDI  R26,LOW(_e_speed)
	LDI  R27,HIGH(_e_speed)
	LDI  R31,0
	CALL __EEPROMWRW
	LDS  R6,_adc_menu
	CLR  R7
	__PUTWMRN _temp_speed,0,6,7
	CALL SUBOPT_0x2E
	RJMP _0x1BD
; 0000 02B0     if(back==0){delay_ms(400);break;}
_0x1BE:
	SBIC 0x10,7
	RJMP _0x1BF
	CALL SUBOPT_0x2E
	RJMP _0x1BD
; 0000 02B1     delay_ms(50);
_0x1BF:
	CALL SUBOPT_0x23
; 0000 02B2     }
	RJMP _0x1BC
_0x1BD:
; 0000 02B3 }
	RET
;
;
;// void detect_per4an()
;// {
;//
;// for(;;)
;//     {
;//     adc_menu=read_adc(0);
;//     adc_menu=255-adc_menu;
;//
;//     if  (adc_menu<=50)per3an_enable=0;
;//     else per3an_enable=1;
;//
;//     lcd_gotoxy(0,1);
;//     if     (e_per4an_enable==0)lcd_putsf("disable");
;//     else if(e_per4an_enable==1)lcd_putsf("enable");
;//
;//     lcd_gotoxy(7,1);
;//     lcd_putsf("<-");
;//     if     (per4an_enable==0)lcd_putsf("disable");
;//     else if(per4an_enable==1)lcd_putsf("enable");
;//
;//
;//     if(enter==0){e_per3an_enable=per3an_enable;per3an_enable=per3an_enable;delay_ms(400);break;}
;//     if(back==0){delay_ms(400);break;}
;//     delay_ms(50);
;//     }
;// }
;
;void eksekusi_per4an()
; 0000 02D2 {
; 0000 02D3 
; 0000 02D4 awal:
; 0000 02D5 adc_menu=read_adc(0);
; 0000 02D6 lcd_gotoxy(0,0);
; 0000 02D7 if(adc_menu<30)
; 0000 02D8     {
; 0000 02D9     lcd_putsf("1. Arah Per4an 1");
; 0000 02DA     set_per4an=1;
; 0000 02DB     }
; 0000 02DC else if(adc_menu<60)
; 0000 02DD     {
; 0000 02DE     lcd_putsf("2. Arah Per4an 2");
; 0000 02DF     set_per4an=2;
; 0000 02E0     }
; 0000 02E1 else if(adc_menu<90)
; 0000 02E2     {
; 0000 02E3     lcd_putsf("3. Arah Per4an 3");
; 0000 02E4     set_per4an=3;
; 0000 02E5     }
; 0000 02E6 else if(adc_menu<120)
; 0000 02E7     {
; 0000 02E8     lcd_putsf("4. Arah Per4an 4");
; 0000 02E9     set_per4an=4;
; 0000 02EA     }
; 0000 02EB else if(adc_menu<150)
; 0000 02EC     {
; 0000 02ED     lcd_putsf("5. Arah Per4an 5");
; 0000 02EE     set_per4an=5;
; 0000 02EF     }
; 0000 02F0 
; 0000 02F1 if(enter==0) {delay_ms(400);goto edit_per4an;}
; 0000 02F2 if(back==0) {delay_ms(400);goto selesai;}
; 0000 02F3 goto awal;
; 0000 02F4 
; 0000 02F5 edit_per4an:
; 0000 02F6 if(set_per4an==1) goto per4an_1;
; 0000 02F7 else if(set_per4an==2) goto per4an_2;
; 0000 02F8 else if(set_per4an==3) goto per4an_3;
; 0000 02F9 else if(set_per4an==4) goto per4an_4;
; 0000 02FA else if(set_per4an==5) goto per4an_5;
; 0000 02FB 
; 0000 02FC per4an_1:
; 0000 02FD for(;;)
; 0000 02FE     {
; 0000 02FF     adc_menu=read_adc(0);
; 0000 0300     if         (adc_menu<=60)    per4an_dir[1]=0;
; 0000 0301     else if  (adc_menu<=120)  per4an_dir[1]=1;
; 0000 0302     else                               per4an_dir[1]=2;
; 0000 0303 
; 0000 0304     lcd_gotoxy(0,1);
; 0000 0305     if     (e_per4an_dir[1]==0)lcd_putsf("left");
; 0000 0306     else if(e_per4an_dir[1]==1)lcd_putsf("right");
; 0000 0307     else if(e_per4an_dir[1]==2)lcd_putsf("lurus");
; 0000 0308 
; 0000 0309     lcd_gotoxy(7,1);
; 0000 030A     lcd_putsf("<-");
; 0000 030B     if        (per4an_dir[1]==0)lcd_putsf("left");
; 0000 030C     else if (per4an_dir[1]==1)lcd_putsf("right");
; 0000 030D     else if (per4an_dir[1]==2)lcd_putsf("lurus");
; 0000 030E 
; 0000 030F     if(enter==0){e_per4an_dir[1]=per4an_dir[1];per4an_dir[1]=per4an_dir[1];delay_ms(400);lcd_clear();goto awal;}
; 0000 0310     if(back==0){delay_ms(400);lcd_clear();goto awal;}
; 0000 0311     delay_ms(50);
; 0000 0312     }
; 0000 0313 
; 0000 0314     per4an_2:
; 0000 0315     for(;;)
; 0000 0316     {
; 0000 0317     adc_menu=read_adc(0);
; 0000 0318     if         (adc_menu<=60)    per4an_dir[2]=0;
; 0000 0319     else if  (adc_menu<=120)  per4an_dir[2]=1;
; 0000 031A     else                               per4an_dir[2]=2;
; 0000 031B 
; 0000 031C     lcd_gotoxy(0,1);
; 0000 031D     if     (e_per4an_dir[2]==0)lcd_putsf("left");
; 0000 031E     else if(e_per4an_dir[2]==1)lcd_putsf("right");
; 0000 031F     else if(e_per4an_dir[2]==2)lcd_putsf("lurus");
; 0000 0320 
; 0000 0321     lcd_gotoxy(7,1);
; 0000 0322     lcd_putsf("<-");
; 0000 0323     if     (per4an_dir[2]==0)lcd_putsf("left");
; 0000 0324     else if(per4an_dir[2]==1)lcd_putsf("right");
; 0000 0325     else if(per4an_dir[2]==2)lcd_putsf("lurus");
; 0000 0326     if(enter==0){e_per4an_dir[2]=per4an_dir[2];per4an_dir[2]=per4an_dir[2];delay_ms(400);lcd_clear();goto awal;}
; 0000 0327     if(back==0){delay_ms(400);lcd_clear();goto awal;}
; 0000 0328     delay_ms(50);
; 0000 0329     }
; 0000 032A 
; 0000 032B     per4an_3:
; 0000 032C     for(;;)
; 0000 032D     {
; 0000 032E     adc_menu=read_adc(0);
; 0000 032F 
; 0000 0330     if        (adc_menu<=50)   per4an_dir[3]=0;
; 0000 0331     else if (adc_menu<=120) per4an_dir[3]=1;
; 0000 0332     else                             per4an_dir[3]=2;
; 0000 0333 
; 0000 0334     lcd_gotoxy(0,1);
; 0000 0335     if     (e_per4an_dir[3]==0)lcd_putsf("left");
; 0000 0336     else if(e_per4an_dir[3]==1)lcd_putsf("right");
; 0000 0337     else if(e_per4an_dir[3]==2)lcd_putsf("lurus");
; 0000 0338 
; 0000 0339     lcd_gotoxy(7,1);
; 0000 033A     lcd_putsf("<-");
; 0000 033B     if     (per4an_dir[3]==0)lcd_putsf("left");
; 0000 033C     else if(per4an_dir[3]==1)lcd_putsf("right");
; 0000 033D     else if(per4an_dir[3]==2)lcd_putsf("lurus");
; 0000 033E 
; 0000 033F     if(enter==0){e_per4an_dir[3]=per4an_dir[3];per4an_dir[3]=per4an_dir[3];delay_ms(400);lcd_clear();goto awal;}
; 0000 0340     if(back==0){delay_ms(400);lcd_clear();goto awal;}
; 0000 0341     delay_ms(50);
; 0000 0342     }
; 0000 0343 
; 0000 0344     per4an_4:
; 0000 0345     for(;;)
; 0000 0346     {
; 0000 0347     adc_menu=read_adc(0);
; 0000 0348 
; 0000 0349     if       (adc_menu<=50)   per4an_dir[4]=0;
; 0000 034A     else if(adc_menu<=120) per4an_dir[4]=1;
; 0000 034B     else                            per4an_dir[4]=2;
; 0000 034C 
; 0000 034D     lcd_gotoxy(0,1);
; 0000 034E     if     (e_per4an_dir[4]==0)lcd_putsf("left");
; 0000 034F     else if(e_per4an_dir[4]==1)lcd_putsf("right");
; 0000 0350     else if(e_per4an_dir[4]==2)lcd_putsf("lurus");
; 0000 0351 
; 0000 0352     lcd_gotoxy(7,1);
; 0000 0353     lcd_putsf("<-");
; 0000 0354     if     (per4an_dir[4]==0)lcd_putsf("left");
; 0000 0355     else if(per4an_dir[4]==1)lcd_putsf("right");
; 0000 0356     else if(per4an_dir[4]==2)lcd_putsf("lurus");
; 0000 0357 
; 0000 0358     if(enter==0){e_per4an_dir[4]=per4an_dir[4];per4an_dir[4]=per4an_dir[4];delay_ms(400);lcd_clear();goto awal;}
; 0000 0359     if(back==0){delay_ms(400);lcd_clear();goto awal;}
; 0000 035A     delay_ms(50);
; 0000 035B     }
; 0000 035C 
; 0000 035D     per4an_5:
; 0000 035E     for(;;)
; 0000 035F     {
; 0000 0360     adc_menu=read_adc(0);
; 0000 0361 
; 0000 0362     if         (adc_menu<=50) per4an_dir[5]=0;
; 0000 0363     else if  (adc_menu<=120)per4an_dir[5]=1;
; 0000 0364     else                             per4an_dir[5]=2;
; 0000 0365 
; 0000 0366     lcd_gotoxy(0,1);
; 0000 0367     if     (e_per4an_dir[5]==0)lcd_putsf("left");
; 0000 0368     else if(e_per4an_dir[5]==1)lcd_putsf("right");
; 0000 0369     else if(e_per4an_dir[5]==2)lcd_putsf("lurus");
; 0000 036A 
; 0000 036B     lcd_gotoxy(7,1);
; 0000 036C     lcd_putsf("<-");
; 0000 036D     if     (per4an_dir[5]==0)lcd_putsf("left");
; 0000 036E     else if(per4an_dir[5]==1)lcd_putsf("right");
; 0000 036F     else if(per4an_dir[5]==2)lcd_putsf("lurus");
; 0000 0370 
; 0000 0371     if(enter==0){e_per4an_dir[5]=per4an_dir[5];per4an_dir[5]=per4an_dir[5];delay_ms(400);lcd_clear();goto awal;}
; 0000 0372     if(back==0){delay_ms(400);lcd_clear();goto awal;}
; 0000 0373     delay_ms(50);
; 0000 0374     }
; 0000 0375 
; 0000 0376     selesai:
; 0000 0377 }
;
;void pembagi_kp()
; 0000 037A {
_pembagi_kp:
; 0000 037B lcd_gotoxy(0,1);
	CALL SUBOPT_0x28
; 0000 037C sprintf(lcd,"=%d",kp_div);
	__POINTW1FN _0x0,28
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_kp_div
	CALL SUBOPT_0x16
	CALL SUBOPT_0x17
; 0000 037D lcd_puts(lcd);
; 0000 037E for(;;)
_0x23C:
; 0000 037F     {
; 0000 0380     adc_menu=read_adc(0);
	CALL SUBOPT_0x2D
; 0000 0381     adc_menu=255-adc_menu;
; 0000 0382 
; 0000 0383     //kp_div=adc_menu/5;
; 0000 0384 
; 0000 0385     lcd_gotoxy(8,1);
; 0000 0386     lcd_putsf("   ");
; 0000 0387     lcd_gotoxy(5,1);
; 0000 0388     sprintf(lcd," <- %d",adc_menu/3);
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x14
; 0000 0389     lcd_puts(lcd);
; 0000 038A 
; 0000 038B     if(enter==0){e_kp_div=adc_menu/3;kp_div=adc_menu/3;delay_ms(400);break;}
	SBIC 0x13,0
	RJMP _0x23E
	LDS  R30,_adc_menu
	CALL SUBOPT_0x2F
	LDI  R26,LOW(_e_kp_div)
	LDI  R27,HIGH(_e_kp_div)
	CALL __EEPROMWRB
	LDS  R30,_adc_menu
	CALL SUBOPT_0x2F
	STS  _kp_div,R30
	CALL SUBOPT_0x2E
	RJMP _0x23D
; 0000 038C     if(back==0){delay_ms(400);break;}
_0x23E:
	SBIC 0x10,7
	RJMP _0x23F
	CALL SUBOPT_0x2E
	RJMP _0x23D
; 0000 038D     delay_ms(50);
_0x23F:
	CALL SUBOPT_0x23
; 0000 038E     }
	RJMP _0x23C
_0x23D:
; 0000 038F }
	RET
;
;
;void uji_langkah()
; 0000 0393 {
_uji_langkah:
; 0000 0394 intrpt_on();
	RCALL _intrpt_on
; 0000 0395 lcd_clear();
	CALL _lcd_clear
; 0000 0396 langkah_kanan=0;
	CALL SUBOPT_0x3
; 0000 0397 for(;;)
_0x241:
; 0000 0398     {
; 0000 0399         speed_ka=pwm_ka=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
	CALL SUBOPT_0xD
; 0000 039A         speed_ki=pwm_ki=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	OUT  0x28+1,R31
	OUT  0x28,R30
	CALL SUBOPT_0xE
; 0000 039B         lcd_gotoxy(0,0);
	CALL SUBOPT_0x30
; 0000 039C         lcd_putsf("KR=");
	__POINTW1FN _0x0,148
	CALL SUBOPT_0x31
; 0000 039D         lcd_gotoxy(3,0);
	LDI  R30,LOW(3)
	CALL SUBOPT_0x32
; 0000 039E         sprintf(lcd," %d",langkah_kiri);
	CALL SUBOPT_0x33
	LDS  R30,_langkah_kiri
	LDS  R31,_langkah_kiri+1
	CALL SUBOPT_0x15
; 0000 039F         lcd_puts(lcd);
; 0000 03A0         lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x32
; 0000 03A1         lcd_putsf("KN=");
	__POINTW1FN _0x0,152
	CALL SUBOPT_0x31
; 0000 03A2         lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x32
; 0000 03A3         sprintf(lcd," %d",langkah_kanan);
	CALL SUBOPT_0x33
	LDS  R30,_langkah_kanan
	LDS  R31,_langkah_kanan+1
	CALL SUBOPT_0x15
; 0000 03A4         lcd_puts(lcd);
; 0000 03A5 
; 0000 03A6 
; 0000 03A7         lcd_gotoxy(0,1);
	CALL SUBOPT_0x34
; 0000 03A8         lcd_putsf("langkah=");
	__POINTW1FN _0x0,156
	CALL SUBOPT_0x31
; 0000 03A9         lcd_gotoxy(8,1);
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 03AA         sprintf(lcd," %d",step);
	CALL SUBOPT_0x33
	LDS  R30,_step
	LDS  R31,_step+1
	CALL SUBOPT_0x15
; 0000 03AB         lcd_puts(lcd);
; 0000 03AC 
; 0000 03AD         if(back==0){intrpt_off();delay_ms(50);break;}
	SBIC 0x10,7
	RJMP _0x243
	RCALL _intrpt_off
	CALL SUBOPT_0x23
	RJMP _0x242
; 0000 03AE     }
_0x243:
	RJMP _0x241
_0x242:
; 0000 03AF }
	RET
;
;void test_drive()
; 0000 03B2 {
_test_drive:
; 0000 03B3 
; 0000 03B4 pwm_on();
	RCALL _pwm_on
; 0000 03B5 speed_ka=speed;
	__PUTWMRN _speed_ka,0,6,7
; 0000 03B6 speed_ki=speed;
	__PUTWMRN _speed_ki,0,6,7
; 0000 03B7 pwm_out();
	RCALL _pwm_out
; 0000 03B8 for(;;){if(back==0||enter==0){pwm_off();break;}}
_0x245:
	LDI  R26,0
	SBIC 0x10,7
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BREQ _0x248
	LDI  R26,0
	SBIC 0x13,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x247
_0x248:
	RCALL _pwm_off
	RJMP _0x246
_0x247:
	RJMP _0x245
_0x246:
; 0000 03B9 }
	RET
;
;
;void slave_menu()
; 0000 03BD {
_slave_menu:
; 0000 03BE     menu_slave=0;
	LDI  R30,LOW(0)
	STS  _menu_slave,R30
; 0000 03BF     temp_adc_menu=0;
	STS  _temp_adc_menu,R30
; 0000 03C0     for(;;)
_0x24B:
; 0000 03C1     {
; 0000 03C2     adc_menu=read_adc(0);
	CALL SUBOPT_0x35
; 0000 03C3     //adc_menu=255-adc_menu;
; 0000 03C4     if(temp_adc_menu!=adc_menu) lcd_clear();
	LDS  R30,_adc_menu
	LDS  R26,_temp_adc_menu
	CP   R30,R26
	BREQ _0x24D
	CALL _lcd_clear
; 0000 03C5     lcd_gotoxy(0,0);
_0x24D:
	CALL SUBOPT_0x30
; 0000 03C6 
; 0000 03C7     if (adc_menu<=40)
	LDS  R26,_adc_menu
	CPI  R26,LOW(0x29)
	BRSH _0x24E
; 0000 03C8         {
; 0000 03C9         lcd_putsf("1. Uji Langkah ");
	__POINTW1FN _0x0,165
	CALL SUBOPT_0x31
; 0000 03CA         menu_slave=1;
	LDI  R30,LOW(1)
	RJMP _0x30F
; 0000 03CB         }
; 0000 03CC     else if (adc_menu<=80)
_0x24E:
	LDS  R26,_adc_menu
	CPI  R26,LOW(0x51)
	BRSH _0x250
; 0000 03CD         {
; 0000 03CE         lcd_putsf("2. Arah Per4an");
	__POINTW1FN _0x0,181
	CALL SUBOPT_0x31
; 0000 03CF         menu_slave=2;
	LDI  R30,LOW(2)
	RJMP _0x30F
; 0000 03D0         }
; 0000 03D1     else if (adc_menu<=120)
_0x250:
	LDS  R26,_adc_menu
	CPI  R26,LOW(0x79)
	BRSH _0x252
; 0000 03D2         {
; 0000 03D3         lcd_putsf("3. Pembagi Kp");
	__POINTW1FN _0x0,196
	CALL SUBOPT_0x31
; 0000 03D4         menu_slave=3;
	LDI  R30,LOW(3)
	RJMP _0x30F
; 0000 03D5         }
; 0000 03D6 
; 0000 03D7     else
_0x252:
; 0000 03D8         {
; 0000 03D9         lcd_putsf("4. test_drive");
	__POINTW1FN _0x0,210
	CALL SUBOPT_0x31
; 0000 03DA         menu_slave=4;
	LDI  R30,LOW(4)
_0x30F:
	STS  _menu_slave,R30
; 0000 03DB         }
; 0000 03DC 
; 0000 03DD 
; 0000 03DE 
; 0000 03DF     if(enter==0)
	SBIC 0x13,0
	RJMP _0x254
; 0000 03E0     {
; 0000 03E1         delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL SUBOPT_0x1D
; 0000 03E2         if      (menu_slave==1)uji_langkah();
	LDS  R26,_menu_slave
	CPI  R26,LOW(0x1)
	BRNE _0x255
	RCALL _uji_langkah
; 0000 03E3         //else if (menu_slave==2)eksekusi_per4an();
; 0000 03E4         else if (menu_slave==3)pembagi_kp();
	RJMP _0x256
_0x255:
	LDS  R26,_menu_slave
	CPI  R26,LOW(0x3)
	BRNE _0x257
	RCALL _pembagi_kp
; 0000 03E5         else if (menu_slave==4)test_drive();
	RJMP _0x258
_0x257:
	LDS  R26,_menu_slave
	CPI  R26,LOW(0x4)
	BRNE _0x259
	RCALL _test_drive
; 0000 03E6     }
_0x259:
_0x258:
_0x256:
; 0000 03E7        if(back==0){delay_ms(400);menu_slave=0;break;}
_0x254:
	SBIC 0x10,7
	RJMP _0x25A
	CALL SUBOPT_0x2E
	LDI  R30,LOW(0)
	STS  _menu_slave,R30
	RJMP _0x24C
; 0000 03E8 
; 0000 03E9     temp_adc_menu=adc_menu;
_0x25A:
	LDS  R30,_adc_menu
	STS  _temp_adc_menu,R30
; 0000 03EA     }
	RJMP _0x24B
_0x24C:
; 0000 03EB 
; 0000 03EC 
; 0000 03ED }
	RET
;
;void tampil_menu()
; 0000 03F0 {
_tampil_menu:
; 0000 03F1 menu=0;
	LDI  R30,LOW(0)
	STS  _menu,R30
; 0000 03F2 for(;;)
_0x25C:
; 0000 03F3     {
; 0000 03F4     adc_menu=read_adc(0);
	CALL SUBOPT_0x35
; 0000 03F5     lcd_clear();
	CALL _lcd_clear
; 0000 03F6     lcd_gotoxy(0,0);
	CALL SUBOPT_0x30
; 0000 03F7     if (adc_menu<=100)
	LDS  R26,_adc_menu
	CPI  R26,LOW(0x65)
	BRSH _0x25E
; 0000 03F8         {
; 0000 03F9         lcd_putsf("1. Speed ");
	__POINTW1FN _0x0,224
	CALL SUBOPT_0x31
; 0000 03FA         menu=1;
	LDI  R30,LOW(1)
	RJMP _0x310
; 0000 03FB         }
; 0000 03FC     else if (adc_menu<=255)
_0x25E:
	LDS  R26,_adc_menu
	LDI  R30,LOW(255)
	CP   R30,R26
	BRLO _0x260
; 0000 03FD         {
; 0000 03FE         lcd_putsf("2. Auto Set ");
	__POINTW1FN _0x0,234
	CALL SUBOPT_0x31
; 0000 03FF         menu=2;
	LDI  R30,LOW(2)
_0x310:
	STS  _menu,R30
; 0000 0400         }
; 0000 0401 
; 0000 0402     if(enter==0)
_0x260:
	SBIC 0x13,0
	RJMP _0x261
; 0000 0403         {
; 0000 0404         delay_ms(400);
	CALL SUBOPT_0x2E
; 0000 0405         if      (menu==2)
	LDS  R26,_menu
	CPI  R26,LOW(0x2)
	BRNE _0x262
; 0000 0406             {
; 0000 0407             for(i=0;i<8;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x264:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0x265
; 0000 0408                 {
; 0000 0409                 min_adc1[i]=255;
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_min_adc1)
	SBCI R31,HIGH(-_min_adc1)
	LDI  R26,LOW(255)
	STD  Z+0,R26
; 0000 040A                 min_adc2[i]=255;
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_min_adc2)
	SBCI R31,HIGH(-_min_adc2)
	LDI  R26,LOW(255)
	STD  Z+0,R26
; 0000 040B                 max_adc1[i]=0;
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_max_adc1)
	SBCI R31,HIGH(-_max_adc1)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 040C                 max_adc2[i]=0;
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_max_adc2)
	SBCI R31,HIGH(-_max_adc2)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 040D                 }
	CALL SUBOPT_0x7
	RJMP _0x264
_0x265:
; 0000 040E             tampil_auto_set();
	RCALL _tampil_auto_set
; 0000 040F             }
; 0000 0410         else if (menu==1)tampil_speed();
	RJMP _0x266
_0x262:
	LDS  R26,_menu
	CPI  R26,LOW(0x1)
	BRNE _0x267
	RCALL _tampil_speed
; 0000 0411         }
_0x267:
_0x266:
; 0000 0412 
; 0000 0413     if(back==0)
_0x261:
	SBIC 0x10,7
	RJMP _0x268
; 0000 0414     {
; 0000 0415         i=0;
	LDI  R30,LOW(0)
	STS  _i,R30
; 0000 0416         while(back==0){delay_ms(10);i++;if(i>200)i=200;}
_0x269:
	SBIC 0x10,7
	RJMP _0x26B
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x7
	LDS  R26,_i
	CPI  R26,LOW(0xC9)
	BRLO _0x26C
	LDI  R30,LOW(200)
	STS  _i,R30
_0x26C:
	RJMP _0x269
_0x26B:
; 0000 0417         if(i>60)    {slave_menu();}
	LDS  R26,_i
	CPI  R26,LOW(0x3D)
	BRLO _0x26D
	RCALL _slave_menu
; 0000 0418         else        {delay_ms(400);menu=0;break;}
	RJMP _0x26E
_0x26D:
	CALL SUBOPT_0x2E
	LDI  R30,LOW(0)
	STS  _menu,R30
	RJMP _0x25D
_0x26E:
; 0000 0419         }
; 0000 041A     delay_ms(50);
_0x268:
	CALL SUBOPT_0x23
; 0000 041B     }
	RJMP _0x25C
_0x25D:
; 0000 041C }
	RET
;
;void tampil_siap()
; 0000 041F {
_tampil_siap:
; 0000 0420     i=0;
	CALL SUBOPT_0x36
; 0000 0421     n=0;
; 0000 0422 
; 0000 0423     start:
_0x26F:
; 0000 0424     for(;;)
_0x271:
; 0000 0425     {
; 0000 0426         lcd_clear();
	CALL _lcd_clear
; 0000 0427         i=0;
	CALL SUBOPT_0x36
; 0000 0428         n=0;
; 0000 0429         langkah=0;
	CALL SUBOPT_0x4
; 0000 042A         langkah_kanan=0;
	CALL SUBOPT_0x3
; 0000 042B         langkah_kiri=0;
	CALL SUBOPT_0x2
; 0000 042C         per4an=0;
	LDI  R30,LOW(0)
	STS  _per4an,R30
; 0000 042D         flag_siku=0;
	CLT
	BLD  R3,1
; 0000 042E         siku=0;
	STS  _siku,R30
; 0000 042F         flag_per4an=0;
	BLD  R3,0
; 0000 0430         adc_menu=read_adc(0);
	CALL SUBOPT_0x35
; 0000 0431         boleh_nos=0;
	LDI  R30,LOW(0)
	STS  _boleh_nos,R30
; 0000 0432         berhasil=0;
	CLT
	BLD  R2,7
; 0000 0433         status_error=0;
	BLD  R2,1
; 0000 0434         status_error_lalu=1;
	SET
	BLD  R2,0
; 0000 0435         temp_kp_div=kp_div;
	LDS  R30,_kp_div
	STS  _temp_kp_div,R30
; 0000 0436         per4an_dir[1]=2;
	LDI  R30,LOW(2)
	__PUTB1MN _per4an_dir,1
; 0000 0437         per4an_dir[2]=1;
	LDI  R30,LOW(1)
	__PUTB1MN _per4an_dir,2
; 0000 0438         per4an_dir[3]=2;
	LDI  R30,LOW(2)
	__PUTB1MN _per4an_dir,3
; 0000 0439         per4an_dir [4]=0;
	LDI  R30,LOW(0)
	__PUTB1MN _per4an_dir,4
; 0000 043A         time=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _time,R30
	STS  _time+1,R31
; 0000 043B 
; 0000 043C         lcd_clear();
	CALL _lcd_clear
; 0000 043D         lcd_gotoxy(0,0);
	CALL SUBOPT_0x30
; 0000 043E         lcd_putsf("RUN?");
	__POINTW1FN _0x0,247
	CALL SUBOPT_0x31
; 0000 043F         speed=temp_speed;
	CALL SUBOPT_0x22
; 0000 0440 
; 0000 0441         lcd_gotoxy(0,1);
	CALL SUBOPT_0x34
; 0000 0442 
; 0000 0443         if           (adc_menu<=30)strategi=1;
	LDS  R26,_adc_menu
	CPI  R26,LOW(0x1F)
	BRSH _0x273
	LDI  R30,LOW(1)
	STS  _strategi,R30
; 0000 0444         else if    (adc_menu<=70)strategi=2;
	RJMP _0x274
_0x273:
	LDS  R26,_adc_menu
	CPI  R26,LOW(0x47)
	BRSH _0x275
	LDI  R30,LOW(2)
	STS  _strategi,R30
; 0000 0445         else if    (adc_menu<=120)strategi=3;
	RJMP _0x276
_0x275:
	LDS  R26,_adc_menu
	CPI  R26,LOW(0x79)
	BRSH _0x277
	LDI  R30,LOW(3)
	STS  _strategi,R30
; 0000 0446         else if    (adc_menu<=250)strategi=4;
	RJMP _0x278
_0x277:
	LDS  R26,_adc_menu
	CPI  R26,LOW(0xFB)
	BRSH _0x279
	LDI  R30,LOW(4)
	STS  _strategi,R30
; 0000 0447         else      goto lihat_sensor;
	RJMP _0x27A
_0x279:
	RJMP _0x27B
; 0000 0448 
; 0000 0449         if           (strategi==1)lcd_putsf("PID");
_0x27A:
_0x278:
_0x276:
_0x274:
	LDS  R26,_strategi
	CPI  R26,LOW(0x1)
	BRNE _0x27C
	__POINTW1FN _0x0,252
	RJMP _0x311
; 0000 044A         else if    (strategi==2)lcd_putsf("Deteksi Per4an");
_0x27C:
	LDS  R26,_strategi
	CPI  R26,LOW(0x2)
	BRNE _0x27E
	__POINTW1FN _0x0,256
	RJMP _0x311
; 0000 044B         else if    (strategi==3)lcd_putsf("NOS-NOS");
_0x27E:
	LDS  R26,_strategi
	CPI  R26,LOW(0x3)
	BRNE _0x280
	__POINTW1FN _0x0,271
	RJMP _0x311
; 0000 044C         else if    (strategi==4)lcd_putsf("Using AI");
_0x280:
	LDS  R26,_strategi
	CPI  R26,LOW(0x4)
	BRNE _0x282
	__POINTW1FN _0x0,279
_0x311:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 044D 
; 0000 044E         delay_ms(200);
_0x282:
	CALL SUBOPT_0x37
; 0000 044F         if(back==0){delay_ms(250);tampil_menu();goto start;}
	SBIC 0x10,7
	RJMP _0x283
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x1D
	RCALL _tampil_menu
	RJMP _0x26F
; 0000 0450         if(enter==0)
_0x283:
	SBIC 0x13,0
	RJMP _0x284
; 0000 0451         {
; 0000 0452             i=0;
	LDI  R30,LOW(0)
	STS  _i,R30
; 0000 0453             while(enter==0){delay_ms(10);i++;if(i>200)i=200;}
_0x285:
	SBIC 0x13,0
	RJMP _0x287
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x7
	LDS  R26,_i
	CPI  R26,LOW(0xC9)
	BRLO _0x288
	LDI  R30,LOW(200)
	STS  _i,R30
_0x288:
	RJMP _0x285
_0x287:
; 0000 0454             if(i>30)    {pwm_off();i_speed=50;action();goto start;}
	LDS  R26,_i
	CPI  R26,LOW(0x1F)
	BRLO _0x289
	CALL _pwm_off
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	MOVW R4,R30
	RCALL _action
	RJMP _0x26F
; 0000 0455             else        {pwm_on();i_speed=50;action();goto start;}
_0x289:
	CALL _pwm_on
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	MOVW R4,R30
	RCALL _action
	RJMP _0x26F
; 0000 0456         }
; 0000 0457 
; 0000 0458     //     while(enter!=0&&back!=0&&(adc_menu==temp_adc_menu))
; 0000 0459     //         {
; 0000 045A     //         i++;
; 0000 045B     //         if(i>100){n++;i=0;}
; 0000 045C     //         delay_ms(10);
; 0000 045D     //         if(n>6){n=2;screensaver();}
; 0000 045E     //         }
; 0000 045F         temp_adc_menu=adc_menu;
_0x284:
	LDS  R30,_adc_menu
	STS  _temp_adc_menu,R30
; 0000 0460         goto selesai;
	RJMP _0x28B
; 0000 0461         lihat_sensor:
_0x27B:
; 0000 0462         lcd_clear();
	CALL _lcd_clear
; 0000 0463 
; 0000 0464         for(;;)
_0x28D:
; 0000 0465         {
; 0000 0466 
; 0000 0467             adc_menu=read_adc(0);
	CALL SUBOPT_0x35
; 0000 0468 
; 0000 0469             read_sensor();
	CALL _read_sensor
; 0000 046A             for(i=0;i<8;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x290:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0x291
; 0000 046B             {
; 0000 046C                 disp_sensor=0;
	LDI  R30,LOW(0)
	STS  _disp_sensor,R30
; 0000 046D                 disp_sensor=front_sensor>>i;
	CALL SUBOPT_0xA
	CALL SUBOPT_0xF
; 0000 046E                 disp_sensor=(disp_sensor)&(0b00000001);
; 0000 046F                 n=7-i;
	CALL SUBOPT_0x10
; 0000 0470                 lcd_gotoxy(n,0);
	CALL SUBOPT_0x11
; 0000 0471                 sprintf(lcd,"%d",disp_sensor);
	CALL SUBOPT_0x12
; 0000 0472                 lcd_puts(lcd);
; 0000 0473             }
	CALL SUBOPT_0x7
	RJMP _0x290
_0x291:
; 0000 0474 
; 0000 0475             for(i=0;i<8;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x293:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0x294
; 0000 0476             {
; 0000 0477                 disp_sensor=0;
	LDI  R30,LOW(0)
	STS  _disp_sensor,R30
; 0000 0478                 disp_sensor=rear_sensor>>i;
	CALL SUBOPT_0xC
	CALL SUBOPT_0xF
; 0000 0479                 disp_sensor=(disp_sensor)&(0b00000001);
; 0000 047A                 n=7-i;
	CALL SUBOPT_0x10
; 0000 047B                 lcd_gotoxy(n,1);
	CALL SUBOPT_0x13
; 0000 047C                 sprintf(lcd,"%d",disp_sensor);
	CALL SUBOPT_0x12
; 0000 047D                 lcd_puts(lcd);
; 0000 047E             }
	CALL SUBOPT_0x7
	RJMP _0x293
_0x294:
; 0000 047F 
; 0000 0480             if(adc_menu<=120){delay_ms(400);break;}
	LDS  R26,_adc_menu
	CPI  R26,LOW(0x79)
	BRSH _0x295
	CALL SUBOPT_0x2E
	RJMP _0x28E
; 0000 0481 
; 0000 0482             if(back==0){delay_ms(400);tampil_menu();};
_0x295:
	SBIC 0x10,7
	RJMP _0x296
	CALL SUBOPT_0x2E
	RCALL _tampil_menu
_0x296:
; 0000 0483         }
	RJMP _0x28D
_0x28E:
; 0000 0484 
; 0000 0485         selesai:
_0x28B:
; 0000 0486     }
	RJMP _0x271
; 0000 0487 }
;
;void main(void)
; 0000 048A {
_main:
; 0000 048B 
; 0000 048C pwm_off();
	CALL _pwm_off
; 0000 048D // LCD module initialization
; 0000 048E lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 048F init_IO();
	CALL _init_IO
; 0000 0490 init_ADC();
	CALL _init_ADC
; 0000 0491 backlight=1;
	SBI  0x18,3
; 0000 0492 led=0;
	CBI  0x15,7
; 0000 0493 lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x32
; 0000 0494 lcd_putsf("GARUDA");
	__POINTW1FN _0x0,288
	CALL SUBOPT_0x31
; 0000 0495 lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0496 lcd_putsf("DI DADAKU!!!");
	__POINTW1FN _0x0,295
	CALL SUBOPT_0x31
; 0000 0497 
; 0000 0498 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x1D
; 0000 0499 led=1;
	SBI  0x15,7
; 0000 049A delay_ms(200);
	CALL SUBOPT_0x37
; 0000 049B led=0;
	CBI  0x15,7
; 0000 049C backlight=0;
	CBI  0x18,3
; 0000 049D delay_ms(200);
	CALL SUBOPT_0x37
; 0000 049E led=1;
	SBI  0x15,7
; 0000 049F delay_ms(200);
	CALL SUBOPT_0x37
; 0000 04A0 led=0;
	CBI  0x15,7
; 0000 04A1 backlight=1;
	SBI  0x18,3
; 0000 04A2 delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x1D
; 0000 04A3 backlight=0;
	CBI  0x18,3
; 0000 04A4 led=1;
	SBI  0x15,7
; 0000 04A5 
; 0000 04A6 temp_speed=speed   =e_speed;
	LDI  R26,LOW(_e_speed)
	LDI  R27,HIGH(_e_speed)
	CALL __EEPROMRDW
	MOVW R6,R30
	STS  _temp_speed,R30
	STS  _temp_speed+1,R31
; 0000 04A7 min_kp  =e_min_kp;
	LDI  R26,LOW(_e_min_kp)
	LDI  R27,HIGH(_e_min_kp)
	CALL __EEPROMRDW
	STS  _min_kp,R30
	STS  _min_kp+1,R31
; 0000 04A8 max_kp  =e_max_kp;
	LDI  R26,LOW(_e_max_kp)
	LDI  R27,HIGH(_e_max_kp)
	CALL __EEPROMRDW
	STS  _max_kp,R30
	STS  _max_kp+1,R31
; 0000 04A9 per4an_enable=e_per4an_enable;
	LDI  R26,LOW(_e_per4an_enable)
	LDI  R27,HIGH(_e_per4an_enable)
	CALL __EEPROMRDB
	CALL __BSTB1
	BLD  R2,4
; 0000 04AA kp_div  =e_kp_div;
	LDI  R26,LOW(_e_kp_div)
	LDI  R27,HIGH(_e_kp_div)
	CALL __EEPROMRDB
	STS  _kp_div,R30
; 0000 04AB 
; 0000 04AC 
; 0000 04AD     for(i=0;i<=10;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x2AC:
	LDS  R26,_i
	CPI  R26,LOW(0xB)
	BRSH _0x2AD
; 0000 04AE     {
; 0000 04AF         langkah_nos[i]=e_langkah_nos[i];
	LDS  R30,_i
	LDI  R26,LOW(_langkah_nos)
	LDI  R27,HIGH(_langkah_nos)
	CALL SUBOPT_0x38
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDS  R30,_i
	LDI  R26,LOW(_e_langkah_nos)
	LDI  R27,HIGH(_e_langkah_nos)
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
; 0000 04B0         langkah_cepat[i]=e_langkah_cepat[i];
	LDS  R30,_i
	LDI  R26,LOW(_langkah_cepat)
	LDI  R27,HIGH(_langkah_cepat)
	CALL SUBOPT_0x38
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	LDS  R30,_i
	LDI  R26,LOW(_e_langkah_cepat)
	LDI  R27,HIGH(_e_langkah_cepat)
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
; 0000 04B1     }
	CALL SUBOPT_0x7
	RJMP _0x2AC
_0x2AD:
; 0000 04B2 
; 0000 04B3 
; 0000 04B4     for(i=0;i<8;i++)
	LDI  R30,LOW(0)
	STS  _i,R30
_0x2AF:
	LDS  R26,_i
	CPI  R26,LOW(0x8)
	BRSH _0x2B0
; 0000 04B5     {
; 0000 04B6         adc_tres1[i]=e_adc_tres1[i];
	CALL SUBOPT_0x5
	SUBI R30,LOW(-_adc_tres1)
	SBCI R31,HIGH(-_adc_tres1)
	MOVW R0,R30
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
; 0000 04B7         adc_tres2[i]=e_adc_tres2[i];
	SUBI R30,LOW(-_adc_tres2)
	SBCI R31,HIGH(-_adc_tres2)
	MOVW R0,R30
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2C
; 0000 04B8     }
	CALL SUBOPT_0x7
	RJMP _0x2AF
_0x2B0:
; 0000 04B9 
; 0000 04BA     while (1)
_0x2B1:
; 0000 04BB     {
; 0000 04BC         tampil_siap();
	RCALL _tampil_siap
; 0000 04BD     }
	RJMP _0x2B1
; 0000 04BE }
_0x2B4:
	RJMP _0x2B4
;
;interrupt [TIM0_COMP] void timer0_comp_isr(void)
; 0000 04C1 {
_timer0_comp_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R15
	ST   -Y,R22
	ST   -Y,R23
	ST   -Y,R24
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 04C2 
; 0000 04C3 //led=0;
; 0000 04C4 //for(i=0;i<8;i++)
; 0000 04C5 //    {
; 0000 04C6 //        if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
; 0000 04C7 //        else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
; 0000 04C8 //        else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
; 0000 04C9 //        else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
; 0000 04CA //        else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
; 0000 04CB //        else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
; 0000 04CC //        else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
; 0000 04CD //        else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
; 0000 04CE //        //adc_result1[i]=read_adc(7);//depan
; 0000 04CF //        adc_result2[i]=read_adc(6);//belakang
; 0000 04D0 //    }
; 0000 04D1 ////adc_result_top=read_adc(1);
; 0000 04D2 //
; 0000 04D3 //for(i=0;i<8;i++)
; 0000 04D4 //    {
; 0000 04D5 //    //if      (adc_result1[i]>adc_tres1[i]){front_sensor=front_sensor|1<<i;}
; 0000 04D6 //    //else if (adc_result1[i]<adc_tres1[i]){front_sensor=front_sensor|0<<i;}
; 0000 04D7 //
; 0000 04D8 //    if      (adc_result2[i]>adc_tres2[i]){rear_sensor=rear_sensor|1<<i;}
; 0000 04D9 //    else if (adc_result2[i]<adc_tres2[i]){rear_sensor=rear_sensor|0<<i;}
; 0000 04DA //    }
; 0000 04DB //
; 0000 04DC //rear_sensor=rear_sensor&0b01111110;
; 0000 04DD //
; 0000 04DE 
; 0000 04DF //strategi 2 berarti mengeksekusi per4an
; 0000 04E0     if(white_line==0)
	SBRC R2,6
	RJMP _0x2B5
; 0000 04E1     {
; 0000 04E2         if(error>=-11&&error<=11)
	LDI  R30,LOW(65525)
	LDI  R31,HIGH(65525)
	CP   R10,R30
	CPC  R11,R31
	BRLT _0x2B7
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CP   R30,R10
	CPC  R31,R11
	BRGE _0x2B8
_0x2B7:
	RJMP _0x2B6
_0x2B8:
; 0000 04E3         {
; 0000 04E4             if      (rear_sensor==0b00001000){right_back=20;}
	LDS  R26,_rear_sensor
	CPI  R26,LOW(0x8)
	BREQ _0x312
; 0000 04E5             else if (rear_sensor==0b00010000){left_back=20;}
	CPI  R26,LOW(0x10)
	BRNE _0x2BB
	LDI  R30,LOW(20)
	STS  _left_back,R30
; 0000 04E6             else if (rear_sensor==0b00011000){left_back=20;right_back=20;}
	RJMP _0x2BC
_0x2BB:
	LDS  R26,_rear_sensor
	CPI  R26,LOW(0x18)
	BREQ _0x313
; 0000 04E7             else if (rear_sensor==0b00000100){right_back=20;}
	CPI  R26,LOW(0x4)
	BREQ _0x312
; 0000 04E8             else if (rear_sensor==0b00100000){left_back=20;}
	CPI  R26,LOW(0x20)
	BRNE _0x2C1
	LDI  R30,LOW(20)
	STS  _left_back,R30
; 0000 04E9             else if (rear_sensor==0b00100100){left_back=20;right_back=20;}
	RJMP _0x2C2
_0x2C1:
	LDS  R26,_rear_sensor
	CPI  R26,LOW(0x24)
	BREQ _0x313
; 0000 04EA             else if (rear_sensor==0b00000010){right_back=20;}
	CPI  R26,LOW(0x2)
	BREQ _0x312
; 0000 04EB             else if (rear_sensor==0b01000000){left_back=20;}
	CPI  R26,LOW(0x40)
	BRNE _0x2C7
	LDI  R30,LOW(20)
	STS  _left_back,R30
; 0000 04EC             //else if (rear_sensor==0b00001100){right_back=8;}
; 0000 04ED             //else if (rear_sensor==0b00110000){left_back=8;}
; 0000 04EE             //else if (rear_sensor==0b00011000){left_back=8;right_back=8;}
; 0000 04EF             //else if (rear_sensor==0b00000110){right_back=8;}
; 0000 04F0             //else if (rear_sensor==0b01100000){left_back=8;}
; 0000 04F1             //else if (rear_sensor==0b01100110){left_back=8;right_back=8;}
; 0000 04F2             else if (rear_sensor==0b01000100){left_back=20;right_back=20;}
	RJMP _0x2C8
_0x2C7:
	LDS  R26,_rear_sensor
	CPI  R26,LOW(0x44)
	BREQ _0x313
; 0000 04F3             else if (rear_sensor==0b00100010){left_back=20;right_back=20;}
	CPI  R26,LOW(0x22)
	BREQ _0x313
; 0000 04F4             else if (rear_sensor==0b00010100){left_back=20;right_back=20;}
	CPI  R26,LOW(0x14)
	BREQ _0x313
; 0000 04F5             else if (rear_sensor==0b00101000){left_back=20;right_back=20;}
	CPI  R26,LOW(0x28)
	BRNE _0x2CF
_0x313:
	LDI  R30,LOW(20)
	STS  _left_back,R30
_0x312:
	LDI  R30,LOW(20)
	STS  _right_back,R30
; 0000 04F6         }
_0x2CF:
_0x2C8:
_0x2C2:
_0x2BC:
; 0000 04F7     }
_0x2B6:
; 0000 04F8 
; 0000 04F9     if(right_back>0)
_0x2B5:
	LDS  R26,_right_back
	CPI  R26,LOW(0x1)
	BRLO _0x2D0
; 0000 04FA     {
; 0000 04FB         right_back--;
	LDS  R30,_right_back
	SUBI R30,LOW(1)
	STS  _right_back,R30
; 0000 04FC     }
; 0000 04FD 
; 0000 04FE     if(left_back>0)
_0x2D0:
	LDS  R26,_left_back
	CPI  R26,LOW(0x1)
	BRLO _0x2D1
; 0000 04FF     {
; 0000 0500         left_back--;
	LDS  R30,_left_back
	SUBI R30,LOW(1)
	STS  _left_back,R30
; 0000 0501     }
; 0000 0502 
; 0000 0503     if(left_back>0&&right_back>0)
_0x2D1:
	LDS  R26,_left_back
	CPI  R26,LOW(0x1)
	BRLO _0x2D3
	LDS  R26,_right_back
	CPI  R26,LOW(0x1)
	BRSH _0x2D4
_0x2D3:
	RJMP _0x2D2
_0x2D4:
; 0000 0504     {
; 0000 0505         backlight=1;
	SBI  0x18,3
; 0000 0506         led=0;
	CBI  0x15,7
; 0000 0507         backlight_on=15;
	LDI  R30,LOW(15)
	STS  _backlight_on,R30
; 0000 0508         led_on=15;
	STS  _led_on,R30
; 0000 0509 
; 0000 050A         if(strategi==2||strategi==4)
	LDS  R26,_strategi
	CPI  R26,LOW(0x2)
	BREQ _0x2DA
	CPI  R26,LOW(0x4)
	BRNE _0x2D9
_0x2DA:
; 0000 050B         {
; 0000 050C             if(flag_per4an==0)
	SBRS R3,0
; 0000 050D             per4an_handler();
	RCALL _per4an_handler
; 0000 050E         }
; 0000 050F 
; 0000 0510         if(strategi==3)
_0x2D9:
	LDS  R26,_strategi
	CPI  R26,LOW(0x3)
	BRNE _0x2DD
; 0000 0511         {
; 0000 0512            if(flag_per4an==0)
	SBRC R3,0
	RJMP _0x2DE
; 0000 0513            if(white_line==0&&siku>4)
	LDI  R26,0
	SBRC R2,6
	LDI  R26,1
	CPI  R26,LOW(0x0)
	BRNE _0x2E0
	LDS  R26,_siku
	CPI  R26,LOW(0x5)
	BRSH _0x2E1
_0x2E0:
	RJMP _0x2DF
_0x2E1:
; 0000 0514            per4an_handler();
	RCALL _per4an_handler
; 0000 0515         }
_0x2DF:
_0x2DE:
; 0000 0516     }
_0x2DD:
; 0000 0517 
; 0000 0518     else if(left_back==0||right_back==0)
	RJMP _0x2E2
_0x2D2:
	LDS  R26,_left_back
	CPI  R26,LOW(0x0)
	BREQ _0x2E4
	LDS  R26,_right_back
	CPI  R26,LOW(0x0)
	BRNE _0x2E3
_0x2E4:
; 0000 0519     {
; 0000 051A         flag_per4an=0;
	CLT
	BLD  R3,0
; 0000 051B     }
; 0000 051C 
; 0000 051D     count=0;
_0x2E3:
_0x2E2:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _count,R30
	STS  _count+1,R31
; 0000 051E }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R24,Y+
	LD   R23,Y+
	LD   R22,Y+
	LD   R15,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;
;////--------Routine Menghitung Langkah kanan------//
;////--------Routine Menghitung Langkah kanan------//
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0524 {
_ext_int0_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0525     langkah_kanan++; langkah++;
	LDI  R26,LOW(_langkah_kanan)
	LDI  R27,HIGH(_langkah_kanan)
	CALL SUBOPT_0x25
	LDI  R26,LOW(_langkah)
	LDI  R27,HIGH(_langkah)
	CALL SUBOPT_0x25
; 0000 0526 
; 0000 0527     if(langkah<step)
	LDS  R30,_step
	LDS  R31,_step+1
	LDS  R26,_langkah
	LDS  R27,_langkah+1
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x2E6
; 0000 0528     {
; 0000 0529         led=0;
	CBI  0x15,7
; 0000 052A         led_on=3;
	LDI  R30,LOW(3)
	STS  _led_on,R30
; 0000 052B         speed=speed+20;
	MOVW R30,R6
	ADIW R30,20
	MOVW R6,R30
; 0000 052C         if(speed>255)speed=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CP   R30,R6
	CPC  R31,R7
	BRGE _0x2E9
	MOVW R6,R30
; 0000 052D     }
_0x2E9:
; 0000 052E 
; 0000 052F     else
	RJMP _0x2EA
_0x2E6:
; 0000 0530     {
; 0000 0531         langkah=0;
	CALL SUBOPT_0x4
; 0000 0532         step=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _step,R30
	STS  _step+1,R31
; 0000 0533         speed=temp_speed;
	CALL SUBOPT_0x22
; 0000 0534     }
_0x2EA:
; 0000 0535 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;// interrupt [EXT_INT1] void ext_int1_isr(void)
;// {
;//
;// langkah_kanan++; langkah++;
;//
;// if(langkah<step)
;// {
;//    led=0;
;//    led_on=3;
;//    speed=speed+20;
;//    if(speed>255)speed=255;
;// }
;//
;// else
;// {
;//    langkah=0;
;//    step=0;
;//    speed=temp_speed;
;// }
;//
;//
;// }
;
;
;
;
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	JMP  _0x20C0001
__put_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x2000012:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL SUBOPT_0x25
	SBIW R30,1
	LDD  R26,Y+6
	STD  Z+0,R26
_0x2000013:
	RJMP _0x2000014
_0x2000010:
	LDD  R30,Y+6
	ST   -Y,R30
	RCALL _putchar
_0x2000014:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__print_G100:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
_0x2000015:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x2000017
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,0
	BRNE _0x200001B
	CPI  R18,37
	BRNE _0x200001C
	LDI  R17,LOW(1)
	RJMP _0x200001D
_0x200001C:
	CALL SUBOPT_0x3A
_0x200001D:
	RJMP _0x200001A
_0x200001B:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x200001E
	CPI  R18,37
	BRNE _0x200001F
	CALL SUBOPT_0x3A
	RJMP _0x20000BC
_0x200001F:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000020
	LDI  R16,LOW(1)
	RJMP _0x200001A
_0x2000020:
	CPI  R18,43
	BRNE _0x2000021
	LDI  R20,LOW(43)
	RJMP _0x200001A
_0x2000021:
	CPI  R18,32
	BRNE _0x2000022
	LDI  R20,LOW(32)
	RJMP _0x200001A
_0x2000022:
	RJMP _0x2000023
_0x200001E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2000024
_0x2000023:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000025
	CALL SUBOPT_0x3B
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	OR   R30,R26
	MOV  R16,R30
	RJMP _0x200001A
_0x2000025:
	RJMP _0x2000026
_0x2000024:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x200001A
_0x2000026:
	CPI  R18,48
	BRLO _0x2000029
	CPI  R18,58
	BRLO _0x200002A
_0x2000029:
	RJMP _0x2000028
_0x200002A:
	MOV  R26,R21
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	MULS R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R22,R21
	CLR  R23
	MOV  R26,R18
	LDI  R27,0
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R22
	ADD  R30,R26
	MOV  R21,R30
	RJMP _0x200001A
_0x2000028:
	CALL SUBOPT_0x3C
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BRNE _0x200002E
	CALL SUBOPT_0x3D
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x3E
	RJMP _0x200002F
_0x200002E:
	CPI  R30,LOW(0x73)
	LDI  R26,HIGH(0x73)
	CPC  R31,R26
	BRNE _0x2000031
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3F
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000032
_0x2000031:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x2000034
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x3F
	CALL _strlenf
	MOV  R17,R30
	CALL SUBOPT_0x3B
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	OR   R30,R26
	MOV  R16,R30
_0x2000032:
	CALL SUBOPT_0x3B
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	OR   R30,R26
	MOV  R16,R30
	CALL SUBOPT_0x3B
	LDI  R30,LOW(65407)
	LDI  R31,HIGH(65407)
	AND  R30,R26
	MOV  R16,R30
	LDI  R19,LOW(0)
	RJMP _0x2000035
_0x2000034:
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BREQ _0x2000038
	CPI  R30,LOW(0x69)
	LDI  R26,HIGH(0x69)
	CPC  R31,R26
	BRNE _0x2000039
_0x2000038:
	CALL SUBOPT_0x3B
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	OR   R30,R26
	MOV  R16,R30
	RJMP _0x200003A
_0x2000039:
	CPI  R30,LOW(0x75)
	LDI  R26,HIGH(0x75)
	CPC  R31,R26
	BRNE _0x200003B
_0x200003A:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003C
_0x200003B:
	CPI  R30,LOW(0x58)
	LDI  R26,HIGH(0x58)
	CPC  R31,R26
	BRNE _0x200003E
	CALL SUBOPT_0x3B
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	OR   R30,R26
	MOV  R16,R30
	RJMP _0x200003F
_0x200003E:
	CPI  R30,LOW(0x78)
	LDI  R26,HIGH(0x78)
	CPC  R31,R26
	BREQ PC+3
	JMP _0x2000070
_0x200003F:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003C:
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x40
	BREQ _0x2000041
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x41
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000042
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000042:
	CPI  R20,0
	BREQ _0x2000043
	SUBI R17,-LOW(1)
	RJMP _0x2000044
_0x2000043:
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x42
_0x2000044:
	RJMP _0x2000045
_0x2000041:
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x41
_0x2000045:
_0x2000035:
	CALL SUBOPT_0x43
	BRNE _0x2000046
_0x2000047:
	CP   R17,R21
	BRSH _0x2000049
	CALL SUBOPT_0x3B
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x200004A
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x40
	BREQ _0x200004B
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x42
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004C
_0x200004B:
	LDI  R18,LOW(48)
_0x200004C:
	RJMP _0x200004D
_0x200004A:
	LDI  R18,LOW(32)
_0x200004D:
	CALL SUBOPT_0x3A
	SUBI R21,LOW(1)
	RJMP _0x2000047
_0x2000049:
_0x2000046:
	MOV  R19,R17
	CALL SUBOPT_0x3B
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x200004E
_0x200004F:
	CPI  R19,0
	BREQ _0x2000051
	CALL SUBOPT_0x3B
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x2000052
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x20000BD
_0x2000052:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x20000BD:
	ST   -Y,R30
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x2000054
	SUBI R21,LOW(1)
_0x2000054:
	SUBI R19,LOW(1)
	RJMP _0x200004F
_0x2000051:
	RJMP _0x2000055
_0x200004E:
_0x2000057:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
_0x2000059:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005B
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x2000059
_0x200005B:
	CPI  R18,58
	BRLO _0x200005C
	CALL SUBOPT_0x3B
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x200005D
	CALL SUBOPT_0x3C
	ADIW R30,7
	RJMP _0x20000BE
_0x200005D:
	CALL SUBOPT_0x3C
	ADIW R30,39
_0x20000BE:
	MOV  R18,R30
_0x200005C:
	CALL SUBOPT_0x3B
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE _0x2000060
	CPI  R18,49
	BRSH _0x2000062
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000061
_0x2000062:
	RJMP _0x20000BF
_0x2000061:
	CP   R21,R19
	BRLO _0x2000066
	CALL SUBOPT_0x43
	BREQ _0x2000067
_0x2000066:
	RJMP _0x2000065
_0x2000067:
	LDI  R18,LOW(32)
	CALL SUBOPT_0x3B
	LDI  R30,LOW(128)
	LDI  R31,HIGH(128)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ _0x2000068
	LDI  R18,LOW(48)
_0x20000BF:
	MOV  R26,R16
	LDI  R27,0
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	OR   R30,R26
	MOV  R16,R30
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x40
	BREQ _0x2000069
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x42
	ST   -Y,R20
	CALL SUBOPT_0x3E
	CPI  R21,0
	BREQ _0x200006A
	SUBI R21,LOW(1)
_0x200006A:
_0x2000069:
_0x2000068:
_0x2000060:
	CALL SUBOPT_0x3A
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x2000065:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000058
	RJMP _0x2000057
_0x2000058:
_0x2000055:
	CALL SUBOPT_0x43
	BREQ _0x200006C
_0x200006D:
	CPI  R21,0
	BREQ _0x200006F
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x3E
	RJMP _0x200006D
_0x200006F:
_0x200006C:
_0x2000070:
_0x200002F:
_0x20000BC:
	LDI  R17,LOW(0)
_0x200001A:
	RJMP _0x2000015
_0x2000017:
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET

	.CSEG

	.CSEG

	.DSEG

	.CSEG
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G103:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G103:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G103
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G103
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0001
__lcd_read_nibble_G103:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G103
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G103
    andi  r30,0xf0
	RET
_lcd_read_byte0_G103:
	CALL __lcd_delay_G103
	RCALL __lcd_read_nibble_G103
    mov   r26,r30
	RCALL __lcd_read_nibble_G103
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	CALL SUBOPT_0x0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDI  R31,0
	MOVW R26,R30
	LDD  R30,Y+1
	LDI  R31,0
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R30,R26
	BRSH _0x2060004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2060004:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0001
_lcd_puts:
	ST   -Y,R17
_0x2060005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2060005
_0x2060007:
	RJMP _0x20C0002
_lcd_putsf:
	ST   -Y,R17
_0x2060008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2060008
_0x206000A:
_0x20C0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G103:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G103:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	CALL SUBOPT_0x0
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G103,2
	CALL SUBOPT_0x0
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G103,3
	CALL SUBOPT_0x44
	CALL SUBOPT_0x44
	CALL SUBOPT_0x44
	RCALL __long_delay_G103
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G103
	RCALL __long_delay_G103
	LDI  R30,LOW(40)
	CALL SUBOPT_0x45
	LDI  R30,LOW(4)
	CALL SUBOPT_0x45
	LDI  R30,LOW(133)
	CALL SUBOPT_0x45
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G103
	CPI  R30,LOW(0x5)
	BREQ _0x206000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x206000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0001:
	ADIW R28,1
	RET

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

	.DSEG
_d_d_error:
	.BYTE 0x2
_d_error:
	.BYTE 0x2
_min_kp:
	.BYTE 0x2
_max_kp:
	.BYTE 0x2
_kp:
	.BYTE 0x2
_kd:
	.BYTE 0x2
_speed_ka:
	.BYTE 0x2
_speed_ki:
	.BYTE 0x2
_temp_speed:
	.BYTE 0x2
_menu:
	.BYTE 0x1
_kp_div:
	.BYTE 0x1
_menu_slave:
	.BYTE 0x1
_strategi:
	.BYTE 0x1
_temp_adc_menu:
	.BYTE 0x1
_adc_result1:
	.BYTE 0x8
_adc_result2:
	.BYTE 0x8
_adc_tres1:
	.BYTE 0x8
_adc_tres2:
	.BYTE 0x8
_adc_menu:
	.BYTE 0x1
_lcd:
	.BYTE 0x10
_max_adc1:
	.BYTE 0x8
_max_adc2:
	.BYTE 0x8
_min_adc1:
	.BYTE 0x8
_min_adc2:
	.BYTE 0x8
_langkah_cepat:
	.BYTE 0x14
_langkah_nos:
	.BYTE 0x14
_boleh_nos:
	.BYTE 0x1
_i:
	.BYTE 0x1
_j:
	.BYTE 0x1
_n:
	.BYTE 0x1
_front_sensor:
	.BYTE 0x1
_rear_sensor:
	.BYTE 0x1
_disp_sensor:
	.BYTE 0x1
_backlight_on:
	.BYTE 0x1
_led_on:
	.BYTE 0x1
_right_back:
	.BYTE 0x1
_left_back:
	.BYTE 0x1
_set_per4an:
	.BYTE 0x1
_per4an:
	.BYTE 0x1
_siku:
	.BYTE 0x1
_per4an_dir:
	.BYTE 0x6
_temp_kp_div:
	.BYTE 0x1
_time:
	.BYTE 0x2
_count:
	.BYTE 0x2
_langkah_kanan:
	.BYTE 0x2
_langkah_kiri:
	.BYTE 0x2
_langkah:
	.BYTE 0x2
_step:
	.BYTE 0x2
_sigma_langkah:
	.BYTE 0x2

	.ESEG
_e_speed:
	.DW  0xC8
_e_min_kp:
	.DW  0x8
_e_max_kp:
	.DW  0x1E
_e_adc_tres1:
	.DB  LOW(0x64646464),HIGH(0x64646464),BYTE3(0x64646464),BYTE4(0x64646464)
	.DB  LOW(0x64646464),HIGH(0x64646464),BYTE3(0x64646464),BYTE4(0x64646464)
_e_adc_tres2:
	.DB  LOW(0x64646464),HIGH(0x64646464),BYTE3(0x64646464),BYTE4(0x64646464)
	.DB  LOW(0x64646464),HIGH(0x64646464),BYTE3(0x64646464),BYTE4(0x64646464)
_e_kp_div:
	.DB  0xD
_e_per4an_dir:
	.BYTE 0x6
_e_per4an_enable:
	.DB  0x0
_e_langkah_nos:
	.BYTE 0x14
_e_langkah_cepat:
	.BYTE 0x14

	.DSEG
__seed_G102:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
_p_S1050024:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	IN   R30,0x6
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _langkah_kiri,R30
	STS  _langkah_kiri+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _langkah_kanan,R30
	STS  _langkah_kanan+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _langkah,R30
	STS  _langkah+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x5:
	LDS  R30,_i
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(7)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x7:
	LDS  R30,_i
	SUBI R30,-LOW(1)
	STS  _i,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x8:
	MOVW R0,R30
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	LD   R30,Z
	MOV  R26,R30
	MOVW R30,R0
	SUBI R30,LOW(-_adc_tres1)
	SBCI R31,HIGH(-_adc_tres1)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x9:
	LDS  R22,_front_sensor
	CLR  R23
	LDS  R30,_i
	LDI  R26,LOW(1)
	CALL __LSLB12
	LDI  R31,0
	MOVW R26,R22
	OR   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	LDS  R30,_front_sensor
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	MOVW R0,R30
	SUBI R30,LOW(-_adc_result2)
	SBCI R31,HIGH(-_adc_result2)
	LD   R30,Z
	MOV  R26,R30
	MOVW R30,R0
	SUBI R30,LOW(-_adc_tres2)
	SBCI R31,HIGH(-_adc_tres2)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	LDS  R30,_rear_sensor
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	STS  _speed_ka,R30
	STS  _speed_ka+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xE:
	STS  _speed_ki,R30
	STS  _speed_ki+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0xF:
	MOVW R26,R30
	LDS  R30,_i
	CALL __ASRW12
	STS  _disp_sensor,R30
	LDI  R31,0
	ANDI R30,LOW(0x1)
	STS  _disp_sensor,R30
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(7)
	LDI  R27,HIGH(7)
	CALL __SWAPW12
	SUB  R30,R26
	STS  _n,R30
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x12:
	LDS  R30,_disp_sensor
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x14:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x15:
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x16:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x17:
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x18:
	MOVW R10,R30
	CLT
	BLD  R2,6
	MOVW R26,R6
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21
	STS  _kp,R30
	STS  _kp+1,R31
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __MULW12
	STS  _kd,R30
	STS  _kd+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x19:
	CALL __DIVW21
	STS  _kp,R30
	STS  _kp+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	CALL __MULW12
	STS  _kd,R30
	STS  _kd+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDS  R30,_per4an
	LDI  R31,0
	SUBI R30,LOW(-_per4an_dir)
	SBCI R31,HIGH(-_per4an_dir)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1C:
	MOVW R10,R30
	LDI  R30,LOW(65386)
	LDI  R31,HIGH(65386)
	RCALL SUBOPT_0xE
	LDI  R30,LOW(65386)
	LDI  R31,HIGH(65386)
	RCALL SUBOPT_0xD
	JMP  _pwm_out

;OPTIMIZER ADDED SUBROUTINE, CALLED 29 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x1D:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x1E:
	MOVW R4,R30
	CALL _read_sensor
	CALL _giving_weight10
	CALL _giving_weight20
	LDS  R30,_kp_div
	LDI  R31,0
	ADIW R30,3
	STS  _kp_div,R30
	LDI  R31,0
	MOVW R26,R6
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	CALL __LSLW2
	STS  _kd,R30
	STS  _kd+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	CALL _komp_pid
	JMP  _pwm_out

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	MOVW R30,R10
	LDI  R26,LOW(65533)
	LDI  R27,HIGH(65533)
	CALL __LEW12
	CPI  R30,LOW(0x4)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	__GETWRMN 6,7,0,_temp_speed
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	LDS  R30,_kp_div
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x27:
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x29:
	MOVW R0,R30
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	LD   R30,Z
	MOV  R26,R30
	MOVW R30,R0
	SUBI R30,LOW(-_max_adc1)
	SBCI R31,HIGH(-_max_adc1)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2A:
	LDS  R26,_i
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	SUBI R26,LOW(-_e_adc_tres1)
	SBCI R27,HIGH(-_e_adc_tres1)
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	SUBI R26,LOW(-_e_adc_tres2)
	SBCI R27,HIGH(-_e_adc_tres2)
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _read_adc
	STS  _adc_menu,R30
	LDI  R31,0
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	CALL __SWAPW12
	SUB  R30,R26
	STS  _adc_menu,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,32
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,36
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_adc_menu
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2F:
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x31:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x32:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,24
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _read_adc
	STS  _adc_menu,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _n,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x38:
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x39:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x3A:
	ST   -Y,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x3B:
	MOV  R26,R16
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	MOV  R30,R18
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3D:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3E:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G100

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3F:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x41:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	AND  R30,R26
	MOV  R16,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	MOV  R30,R16
	LDI  R31,0
	ANDI R30,LOW(0x1)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x44:
	CALL __long_delay_G103
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G103


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
	RET

__ASRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __ASRW12R
__ASRW12L:
	ASR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRW12L
__ASRW12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__LEW12:
	CP   R30,R26
	CPC  R31,R27
	LDI  R30,1
	BRGE __LEW12T
	CLR  R30
__LEW12T:
	RET

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVW21U:
	CLR  R0
	CLR  R1
	LDI  R25,16
__DIVW21U1:
	LSL  R26
	ROL  R27
	ROL  R0
	ROL  R1
	SUB  R0,R30
	SBC  R1,R31
	BRCC __DIVW21U2
	ADD  R0,R30
	ADC  R1,R31
	RJMP __DIVW21U3
__DIVW21U2:
	SBR  R26,1
__DIVW21U3:
	DEC  R25
	BRNE __DIVW21U1
	MOVW R30,R26
	MOVW R26,R0
	RET

__DIVW21:
	RCALL __CHKSIGNW
	RCALL __DIVW21U
	BRTC __DIVW211
	RCALL __ANEGW1
__DIVW211:
	RET

__CHKSIGNW:
	CLT
	SBRS R31,7
	RJMP __CHKSW1
	RCALL __ANEGW1
	SET
__CHKSW1:
	SBRS R27,7
	RJMP __CHKSW2
	COM  R26
	COM  R27
	ADIW R26,1
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSW2:
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

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

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
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
