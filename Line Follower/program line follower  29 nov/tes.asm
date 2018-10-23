
;CodeVisionAVR C Compiler V2.03.4 Standard
;(C) Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 12.000000 MHz
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
	.DEF _adc0=R5
	.DEF _adc1=R4
	.DEF _adc2=R7
	.DEF _adc3=R6
	.DEF _adc4=R9
	.DEF _adc5=R8
	.DEF _adc6=R11
	.DEF _adc7=R10
	.DEF _a1=R13
	.DEF _a2=R12

	.CSEG
	.ORG 0x00

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
	JMP  _timer0_ovf_isr
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

_char0:
	.DB  0x60,0x18,0x6,0x7F,0x7F,0x6,0x18,0x60
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x6:
	.DB  0x80
_0x7:
	.DB  0x80
_0x8:
	.DB  0x80
_0x9:
	.DB  0x80
_0xA:
	.DB  0x80
_0xB:
	.DB  0x80
_0xC:
	.DB  0x80
_0xD:
	.DB  0x80
_0xE:
	.DB  0x80
_0xF:
	.DB  0x80
_0x10:
	.DB  0x80
_0x11:
	.DB  0x80
_0x12:
	.DB  0x80
_0x13:
	.DB  0x80
_0xE9:
	.DB  0x5
_0x116:
	.DB  0x64
_0x117:
	.DB  0x9C
_0x188:
	.DB  0x80,0x80
_0x0:
	.DB  0x54,0x75,0x6C,0x69,0x73,0x20,0x6B,0x65
	.DB  0x20,0x45,0x45,0x50,0x52,0x4F,0x4D,0x20
	.DB  0x0,0x2E,0x2E,0x2E,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x53,0x65,0x74,0x20,0x4B,0x70
	.DB  0x20,0x3A,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x53,0x65,0x74,0x20,0x4B
	.DB  0x69,0x20,0x3A,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x53,0x65,0x74,0x20
	.DB  0x4B,0x64,0x20,0x3A,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x53,0x65,0x74
	.DB  0x20,0x4D,0x41,0x58,0x20,0x53,0x70,0x65
	.DB  0x65,0x64,0x20,0x3A,0x20,0x0,0x53,0x65
	.DB  0x74,0x20,0x4D,0x49,0x4E,0x20,0x53,0x70
	.DB  0x65,0x65,0x64,0x20,0x3A,0x20,0x0,0x57
	.DB  0x61,0x72,0x6E,0x61,0x20,0x47,0x61,0x72
	.DB  0x69,0x73,0x20,0x20,0x20,0x3A,0x20,0x0
	.DB  0x53,0x65,0x6E,0x73,0x4C,0x69,0x6E,0x65
	.DB  0x20,0x3A,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x53,0x6B,0x65,0x6E,0x61,0x72,0x69
	.DB  0x6F,0x20,0x3A,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x53,0x65,0x74,0x20
	.DB  0x50,0x49,0x44,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x53,0x65,0x74
	.DB  0x20,0x53,0x70,0x65,0x65,0x64,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x53,0x65
	.DB  0x74,0x20,0x47,0x61,0x72,0x69,0x73,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x53
	.DB  0x6B,0x65,0x6E,0x61,0x72,0x69,0x6F,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x53,0x74,0x61,0x72,0x74,0x21,0x21,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x4B,0x70,0x20,0x20,0x20,0x4B,0x69,0x20
	.DB  0x20,0x20,0x4B,0x64,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x4D,0x41,0x58,0x20,0x20,0x20
	.DB  0x20,0x4D,0x49,0x4E,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x57,0x41,0x52,0x4E,0x41,0x20
	.DB  0x3A,0x20,0x50,0x75,0x74,0x69,0x68,0x20
	.DB  0x0,0x20,0x20,0x57,0x41,0x52,0x4E,0x41
	.DB  0x20,0x3A,0x20,0x48,0x69,0x74,0x61,0x6D
	.DB  0x20,0x0,0x20,0x20,0x53,0x65,0x6E,0x73
	.DB  0x4C,0x20,0x3A,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x53,0x6B,0x65,0x6E
	.DB  0x2E,0x20,0x79,0x67,0x20,0x20,0x64,0x70
	.DB  0x61,0x6B,0x65,0x3A,0x0,0x25,0x64,0x20
	.DB  0x20,0x20,0x25,0x64,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x62,0x61,0x72,0x75,0x5F,0x62,0x65,0x6C
	.DB  0x61,0x6A,0x61,0x72,0x20,0x20,0x0,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x62,0x79,0x20
	.DB  0x3A,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x44,0x49,0x4F,0x4E,0x59,0x53,0x49
	.DB  0x55,0x53,0x20,0x49,0x56,0x41,0x4E,0x20
	.DB  0x0,0x20,0x48,0x41,0x4E,0x44,0x49,0x4B
	.DB  0x4F,0x20,0x47,0x45,0x53,0x41,0x4E,0x47
	.DB  0x0,0x54,0x45,0x4B,0x4E,0x49,0x4B,0x20
	.DB  0x46,0x49,0x53,0x49,0x4B,0x41,0x20,0x31
	.DB  0x30,0x0,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x55,0x47,0x4D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x0,0x52,0x4F,0x42,0x4F,0x52
	.DB  0x41,0x43,0x45,0x20,0x55,0x4E,0x59,0x20
	.DB  0x27,0x31,0x30,0x0,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x0
_0x2020003:
	.DB  0x80,0xC0
_0x20A005F:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _a3
	.DW  _0x6*2

	.DW  0x01
	.DW  _a4
	.DW  _0x7*2

	.DW  0x01
	.DW  _a5
	.DW  _0x8*2

	.DW  0x01
	.DW  _a6
	.DW  _0x9*2

	.DW  0x01
	.DW  _a7
	.DW  _0xA*2

	.DW  0x01
	.DW  _a8
	.DW  _0xB*2

	.DW  0x01
	.DW  _b1
	.DW  _0xC*2

	.DW  0x01
	.DW  _b2
	.DW  _0xD*2

	.DW  0x01
	.DW  _b3
	.DW  _0xE*2

	.DW  0x01
	.DW  _b4
	.DW  _0xF*2

	.DW  0x01
	.DW  _b5
	.DW  _0x10*2

	.DW  0x01
	.DW  _b6
	.DW  _0x11*2

	.DW  0x01
	.DW  _b7
	.DW  _0x12*2

	.DW  0x01
	.DW  _b8
	.DW  _0x13*2

	.DW  0x01
	.DW  _diffPWM
	.DW  _0xE9*2

	.DW  0x02
	.DW  0x0C
	.DW  _0x188*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A005F*2

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
;CodeWizardAVR V2.03.4 Standard
;Automatic Program Generator
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 11/26/2010
;Author  : HANDIKO GESANG
;Company : FISTEK - UGM '10
;Comments:
;
;coba lengkapi ADC NYA..!!!!
;coba lengkapi ADC NYA..!!!!
;coba lengkapi ADC NYA..!!!!
;coba lengkapi ADC NYA..!!!!
;coba lengkapi ADC NYA..!!!!
;coba lengkapi ADC NYA..!!!!
;coba lengkapi ADC NYA..!!!!
;coba lengkapi ADC NYA..!!!!
;
;
;
;Chip type           : ATmega16
;Program type        : Application
;Clock frequency     : 12.000000 MHz
;Memory model        : Small
;External RAM size   : 0
;Data Stack size     : 256
;*****************************************************/
;
;#include <mega16.h>
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
;#include <stdio.h>
;#include <lcd.h>
;#include <delay.h>
;#include <math.h>
;#define ADC_VREF_TYPE 0x20
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x15 ;PORTC
; 0000 002C #endasm
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0031 {

	.CSEG
; 0000 0032 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 0033 // Delay needed for the stabilization of the ADC input voltage
; 0000 0034 delay_us(10);
; 0000 0035 // Start the AD conversion
; 0000 0036 ADCSRA|=0x40;
; 0000 0037 // Wait for the AD conversion to complete
; 0000 0038 while ((ADCSRA & 0x10)==0);
; 0000 0039 ADCSRA|=0x10;
; 0000 003A return ADCH;
; 0000 003B }
;
;//void tampil();
;//void tulisKeEEPROM();
;//void setByte();
;void showMenu();
;void displaySensorBit();
;void maju();
;void mundur();
;void bkan();
;void bkir();
;void stop();
;void scanBlackLine();
;//void ketemuSiku();
;void kalibrasi_sensor();
;void baca_sensor();
;void read_sensor();
;
;unsigned char adc0,adc1,adc2,adc3,adc4,adc5,adc6,adc7;
;unsigned char a1=128,a2=128,a3=128,a4=128,a5=128,a6=128,a7=128,a8=128;

	.DSEG
;unsigned char b1=128,b2=128,b3=128,b4=128,b5=128,b6=128,b7=128,b8=128;
;unsigned char r1,r2,r3,r4,r5,r6,r7,r8,sensor;
;bit p,q,r,s,t,u,v,w;
;
;void kalibrasi_sensor()
; 0000 0054 {

	.CSEG
; 0000 0055     adc0=read_adc(0);
; 0000 0056    	if (adc0>b1) b1=adc0;
; 0000 0057 	if (adc0<a1) a1=adc0;
; 0000 0058  	r1= ((a1-b1)/2 ) + b1;
; 0000 0059 
; 0000 005A     adc1=read_adc(1);
; 0000 005B    	if (adc1>b2) b2=adc1;
; 0000 005C 	if (adc1<a2) a2=adc1;
; 0000 005D  	r1= ((a2-b2)/2 ) + b2;
; 0000 005E 
; 0000 005F     adc2=read_adc(2);
; 0000 0060     if (adc2>b3) b3=adc2;
; 0000 0061 	if (adc2<a3) a3=adc2;
; 0000 0062  	r1= ((a3-b3)/2 ) + b3;
; 0000 0063 
; 0000 0064     adc3=read_adc(3);
; 0000 0065     if (adc3>b4) b4=adc3;
; 0000 0066 	if (adc3<a4) a4=adc3;
; 0000 0067  	r1= ((a4-b4)/2 ) + b4;
; 0000 0068 
; 0000 0069     adc4=read_adc(4);
; 0000 006A     if (adc4>b5) b5=adc4;
; 0000 006B 	if (adc4<a5) a5=adc4;
; 0000 006C  	r1= ((a5-b5)/2 ) + b5;
; 0000 006D 
; 0000 006E     adc5=read_adc(5);
; 0000 006F     if (adc5>b6) b6=adc5;
; 0000 0070 	if (adc5<a6) a6=adc5;
; 0000 0071  	r1= ((a6-b6)/2 ) + b6;
; 0000 0072 
; 0000 0073     adc6=read_adc(6);
; 0000 0074     if (adc6>b7) b7=adc6;
; 0000 0075 	if (adc6<a7) a7=adc6;
; 0000 0076  	r1= ((a7-b7)/2 ) + b7;
; 0000 0077 
; 0000 0078     adc7=read_adc(7);
; 0000 0079     if (adc7>b8) b8=adc7;
; 0000 007A 	if (adc7<a8) a8=adc7;
; 0000 007B  	r1= ((a8-b8)/2 ) + b8;
; 0000 007C }
;
;void baca_sensor()
; 0000 007F {
; 0000 0080       sensor=0;
; 0000 0081       if(adc0<r1) {sensor=sensor+1;}
; 0000 0082       if(adc1<r2) {sensor=sensor+2;}
; 0000 0083       if(adc2<r3) {sensor=sensor+4;}
; 0000 0084       if(adc3<r4) {sensor=sensor+8;}
; 0000 0085       if(adc4<r5) {sensor=sensor+16;}
; 0000 0086       if(adc5<r6) {sensor=sensor+32;}
; 0000 0087       if(adc6<r7) {sensor=sensor+64;}
; 0000 0088       if(adc7<r8) {sensor=sensor+128;}
; 0000 0089 }
;
;void read_sensor()
; 0000 008C {
; 0000 008D 	if (adc0<r1) {w=1;}
; 0000 008E 	else w=0;
; 0000 008F 	if (adc1<r2) {v=1;}
; 0000 0090 	else v=0;
; 0000 0091 	if (adc2<r3) {u=1;}
; 0000 0092 	else u=0;
; 0000 0093 	if (adc3<r4) {t=1;}
; 0000 0094 	else t=0;
; 0000 0095 	if (adc4<r5) {s=1;}
; 0000 0096 	else s=0;
; 0000 0097 	if (adc5<r6) {r=1;}
; 0000 0098 	else r=0;
; 0000 0099 	if (adc6<r7) {q=1;}
; 0000 009A 	else q=0;
; 0000 009B 	if (adc7<r8) {p=1;}
; 0000 009C 	else p=0;
; 0000 009D 
; 0000 009E 	lcd_gotoxy(2,1);
; 0000 009F     if (p)  lcd_putchar('1');
; 0000 00A0     else    lcd_putchar('0');
; 0000 00A1     if (q)  lcd_putchar('1');
; 0000 00A2     else    lcd_putchar('0');
; 0000 00A3     if (r)  lcd_putchar('1');
; 0000 00A4     else    lcd_putchar('0');
; 0000 00A5     if (s)  lcd_putchar('1');
; 0000 00A6     else    lcd_putchar('0');
; 0000 00A7     if (t)  lcd_putchar('1');
; 0000 00A8     else    lcd_putchar('0');
; 0000 00A9     if (u)  lcd_putchar('1');
; 0000 00AA     else    lcd_putchar('0');
; 0000 00AB     if (v)  lcd_putchar('1');
; 0000 00AC     else    lcd_putchar('0');
; 0000 00AD     if (w)  lcd_putchar('1');
; 0000 00AE     else    lcd_putchar('0');
; 0000 00AF }
;
;typedef unsigned char byte;
;/* table for the user defined character
;   arrow that points to the top right corner */
;flash byte char0[8]={
;0b1100000,
;0b0011000,
;0b0000110,
;0b1111111,
;0b1111111,
;0b0000110,
;0b0011000,
;0b1100000};
;
;char lcd_buffer[33];
;
;/* function used to define user characters */
;void define_char(byte flash *pc,byte char_code)
; 0000 00C2 {
_define_char:
; 0000 00C3 byte i,a;
; 0000 00C4 a=(char_code<<3) | 0x40;
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LDI  R31,0
	CALL __LSLW3
	ORI  R30,0x40
	MOV  R16,R30
; 0000 00C5 for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
	LDI  R17,LOW(0)
_0x4D:
	CPI  R17,8
	BRSH _0x4E
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R30,Z
	ST   -Y,R30
	CALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0x4D
_0x4E:
; 0000 00C6 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;
;void tampil(unsigned char dat)
; 0000 00C9 {
_tampil:
; 0000 00CA     unsigned char data;
; 0000 00CB 
; 0000 00CC     data = dat / 100;
	ST   -Y,R17
;	dat -> Y+1
;	data -> R17
	LDD  R30,Y+1
	CALL SUBOPT_0x0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x1
; 0000 00CD     data+=0x30;
; 0000 00CE     lcd_putchar(data);
; 0000 00CF 
; 0000 00D0     dat%=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	STD  Y+1,R30
; 0000 00D1     data = dat / 10;
	CALL SUBOPT_0x0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x1
; 0000 00D2     data+=0x30;
; 0000 00D3     lcd_putchar(data);
; 0000 00D4 
; 0000 00D5     dat%=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+1,R30
; 0000 00D6     data = dat + 0x30;
	CALL SUBOPT_0x2
	ADIW R30,48
	MOV  R17,R30
; 0000 00D7     lcd_putchar(data);
	ST   -Y,R17
	CALL _lcd_putchar
; 0000 00D8 }
	LDD  R17,Y+0
	JMP  _0x20C0003
;
;// switch
;#define sw_ok     PINB.1
;#define sw_cancel PINB.0
;#define sw_up     PINB.3
;#define sw_down   PINB.2
;
;// eeprom & inisialisasi awal, ketulis lg saat ngisi chip
;eeprom byte Kp = 10;
;eeprom byte Ki = 0;
;eeprom byte Kd = 5;
;eeprom byte MAXSpeed = 255;
;eeprom byte MINSpeed = 0;
;eeprom byte WarnaGaris = 1; // 1 : putih; 0 : hitam
;eeprom byte SensLine = 2; // banyaknya sensor dlm 1 garis
;eeprom byte Skenario = 2;
;
;void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom ) {
; 0000 00EA void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom ) {
_tulisKeEEPROM:
; 0000 00EB                                                      lcd_gotoxy(0, 0);
;	NoMenu -> Y+2
;	NoSubMenu -> Y+1
;	var_in_eeprom -> Y+0
	CALL SUBOPT_0x3
; 0000 00EC         lcd_putsf("Tulis ke EEPROM ");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x4
; 0000 00ED         lcd_putsf("...             ");
	__POINTW1FN _0x0,17
	CALL SUBOPT_0x4
; 0000 00EE         switch (NoMenu) {
	LDD  R30,Y+2
	CALL SUBOPT_0x5
; 0000 00EF           case 1: // PID
	BRNE _0x52
; 0000 00F0                 switch (NoSubMenu) {
	CALL SUBOPT_0x2
; 0000 00F1                   case 1: // Kp
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x56
; 0000 00F2                         Kp = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	RJMP _0x16D
; 0000 00F3                         break;
; 0000 00F4                   case 2: // Ki
_0x56:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x57
; 0000 00F5                         Ki = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	RJMP _0x16D
; 0000 00F6                         break;
; 0000 00F7                   case 3: // Kd
_0x57:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x55
; 0000 00F8                         Kd = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
_0x16D:
	CALL __EEPROMWRB
; 0000 00F9                         break;
; 0000 00FA                 }
_0x55:
; 0000 00FB                 break;
	RJMP _0x51
; 0000 00FC           case 2: // Speed
_0x52:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x59
; 0000 00FD                 switch (NoSubMenu) {
	CALL SUBOPT_0x2
; 0000 00FE                   case 1: // MAX
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x5D
; 0000 00FF                         MAXSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	RJMP _0x16E
; 0000 0100                         break;
; 0000 0101                   case 2: // MIN
_0x5D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x5C
; 0000 0102                         MINSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
_0x16E:
	CALL __EEPROMWRB
; 0000 0103                         break;
; 0000 0104                 }
_0x5C:
; 0000 0105                 break;
	RJMP _0x51
; 0000 0106           case 3: // Warna Garis
_0x59:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x5F
; 0000 0107                 switch (NoSubMenu) {
	CALL SUBOPT_0x2
; 0000 0108                   case 1: // Warna
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x63
; 0000 0109                         WarnaGaris = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	RJMP _0x16F
; 0000 010A                         break;
; 0000 010B                   case 2: // SensL
_0x63:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x62
; 0000 010C                         SensLine = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
_0x16F:
	CALL __EEPROMWRB
; 0000 010D                         break;
; 0000 010E                 }
_0x62:
; 0000 010F                 break;
	RJMP _0x51
; 0000 0110           case 4: // Skenario
_0x5F:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x51
; 0000 0111                 Skenario = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMWRB
; 0000 0112                 break;
; 0000 0113         }
_0x51:
; 0000 0114         delay_ms(200);
	CALL SUBOPT_0x6
; 0000 0115 }
	JMP  _0x20C0002
;
;void scanBlackLine();
;
;void setByte( byte NoMenu, byte NoSubMenu ) {
; 0000 0119 void setByte( byte NoMenu, byte NoSubMenu ) {
_setByte:
; 0000 011A         byte var_in_eeprom;
; 0000 011B         byte plus5 = 0;
; 0000 011C         char limitPilih = -1;
; 0000 011D 
; 0000 011E         lcd_clear();
	CALL __SAVELOCR4
;	NoMenu -> Y+5
;	NoSubMenu -> Y+4
;	var_in_eeprom -> R17
;	plus5 -> R16
;	limitPilih -> R19
	LDI  R16,0
	LDI  R19,255
	CALL _lcd_clear
; 0000 011F         lcd_gotoxy(0, 0);
	CALL SUBOPT_0x3
; 0000 0120         switch (NoMenu) {
	LDD  R30,Y+5
	CALL SUBOPT_0x5
; 0000 0121           case 1: // PID
	BRNE _0x69
; 0000 0122                 switch (NoSubMenu) {
	LDD  R30,Y+4
	CALL SUBOPT_0x5
; 0000 0123                   case 1: // Kp
	BRNE _0x6D
; 0000 0124                         lcd_putsf("Set Kp :        ");
	__POINTW1FN _0x0,34
	CALL SUBOPT_0x4
; 0000 0125                         var_in_eeprom = Kp;
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	RJMP _0x170
; 0000 0126                         break;
; 0000 0127                   case 2: // Ki
_0x6D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6E
; 0000 0128                         lcd_putsf("Set Ki :        ");
	__POINTW1FN _0x0,51
	CALL SUBOPT_0x4
; 0000 0129                         var_in_eeprom = Ki;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	RJMP _0x170
; 0000 012A                         break;
; 0000 012B                   case 3: // Kd
_0x6E:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x6C
; 0000 012C                         lcd_putsf("Set Kd :        ");
	__POINTW1FN _0x0,68
	CALL SUBOPT_0x4
; 0000 012D                         var_in_eeprom = Kd;
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
_0x170:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 012E                         break;
; 0000 012F                 }
_0x6C:
; 0000 0130                 break;
	RJMP _0x68
; 0000 0131           case 2: // Speed
_0x69:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x70
; 0000 0132                 plus5 = 1;
	LDI  R16,LOW(1)
; 0000 0133                 switch (NoSubMenu) {
	LDD  R30,Y+4
	CALL SUBOPT_0x5
; 0000 0134                   case 1: // MAX
	BRNE _0x74
; 0000 0135                         lcd_putsf("Set MAX Speed : ");
	__POINTW1FN _0x0,85
	CALL SUBOPT_0x4
; 0000 0136                         var_in_eeprom = MAXSpeed;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	RJMP _0x171
; 0000 0137                         break;
; 0000 0138                   case 2: // MIN
_0x74:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x73
; 0000 0139                         lcd_putsf("Set MIN Speed : ");
	__POINTW1FN _0x0,102
	CALL SUBOPT_0x4
; 0000 013A                         var_in_eeprom = MINSpeed;
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
_0x171:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 013B                         break;
; 0000 013C                 }
_0x73:
; 0000 013D                 break;
	RJMP _0x68
; 0000 013E           case 3: // Warna Garis
_0x70:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x76
; 0000 013F                 switch (NoSubMenu) {
	LDD  R30,Y+4
	CALL SUBOPT_0x5
; 0000 0140                   case 1: // Warna
	BRNE _0x7A
; 0000 0141                         limitPilih = 1;
	LDI  R19,LOW(1)
; 0000 0142                         lcd_putsf("Warna Garis   : ");
	__POINTW1FN _0x0,119
	CALL SUBOPT_0x4
; 0000 0143                         var_in_eeprom = WarnaGaris;
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	RJMP _0x172
; 0000 0144                         break;
; 0000 0145                   case 2: // SensL
_0x7A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x79
; 0000 0146                         limitPilih = 3;
	LDI  R19,LOW(3)
; 0000 0147                         lcd_putsf("SensLine :      ");
	__POINTW1FN _0x0,136
	CALL SUBOPT_0x4
; 0000 0148                         var_in_eeprom = SensLine;
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
_0x172:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 0149                         break;
; 0000 014A                 }
_0x79:
; 0000 014B                 break;
	RJMP _0x68
; 0000 014C           case 4: // Skenario
_0x76:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x68
; 0000 014D                   lcd_putsf("Skenario :      ");
	__POINTW1FN _0x0,153
	CALL SUBOPT_0x4
; 0000 014E                   var_in_eeprom = Skenario;
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 014F                   limitPilih = 8;
	LDI  R19,LOW(8)
; 0000 0150                   break;
; 0000 0151         }
_0x68:
; 0000 0152 
; 0000 0153         while (sw_cancel) {
_0x7D:
	SBIS 0x16,0
	RJMP _0x7F
; 0000 0154                 delay_ms(150);
	CALL SUBOPT_0x7
; 0000 0155                 lcd_gotoxy(0, 1);
	CALL SUBOPT_0x8
; 0000 0156                 tampil(var_in_eeprom);
	ST   -Y,R17
	RCALL _tampil
; 0000 0157 
; 0000 0158                 if (!sw_ok)   {
	SBIC 0x16,1
	RJMP _0x80
; 0000 0159                         lcd_clear();
	CALL _lcd_clear
; 0000 015A                         tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R17
	RCALL _tulisKeEEPROM
; 0000 015B                         goto exitSetByte;
	RJMP _0x81
; 0000 015C                 }
; 0000 015D                 if (!sw_down) {
_0x80:
	SBIC 0x16,2
	RJMP _0x82
; 0000 015E                         if ( plus5 )
	CPI  R16,0
	BREQ _0x83
; 0000 015F                                 if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x84
; 0000 0160                                         var_in_eeprom = 255;
	LDI  R17,LOW(255)
; 0000 0161                                 else
	RJMP _0x85
_0x84:
; 0000 0162                                         var_in_eeprom -= 5;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL __SWAPW12
	SUB  R30,R26
	MOV  R17,R30
; 0000 0163                         else
_0x85:
	RJMP _0x86
_0x83:
; 0000 0164                                 if ( !limitPilih )
	CPI  R19,0
	BREQ _0x173
; 0000 0165                                         var_in_eeprom--;
; 0000 0166                                 else {
; 0000 0167                                         if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x89
; 0000 0168                                           var_in_eeprom = limitPilih;
	MOV  R17,R19
; 0000 0169                                         else
	RJMP _0x8A
_0x89:
; 0000 016A                                           var_in_eeprom--;
_0x173:
	SUBI R17,1
; 0000 016B                                 }
_0x8A:
_0x86:
; 0000 016C                 }
; 0000 016D                 if (!sw_up)   {
_0x82:
	SBIC 0x16,3
	RJMP _0x8B
; 0000 016E                         if ( plus5 )
	CPI  R16,0
	BREQ _0x8C
; 0000 016F                                 if ( var_in_eeprom == 255 )
	CPI  R17,255
	BRNE _0x8D
; 0000 0170                                         var_in_eeprom = 0;
	LDI  R17,LOW(0)
; 0000 0171                                 else
	RJMP _0x8E
_0x8D:
; 0000 0172                                         var_in_eeprom += 5;
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,5
	MOV  R17,R30
; 0000 0173                         else
_0x8E:
	RJMP _0x8F
_0x8C:
; 0000 0174                                 if ( !limitPilih )
	CPI  R19,0
	BREQ _0x174
; 0000 0175                                         var_in_eeprom++;
; 0000 0176                                 else {
; 0000 0177                                         if ( var_in_eeprom == limitPilih )
	CP   R19,R17
	BRNE _0x92
; 0000 0178                                           var_in_eeprom = 0;
	LDI  R17,LOW(0)
; 0000 0179                                         else
	RJMP _0x93
_0x92:
; 0000 017A                                           var_in_eeprom++;
_0x174:
	SUBI R17,-1
; 0000 017B                                 }
_0x93:
_0x8F:
; 0000 017C                 }
; 0000 017D         }
_0x8B:
	RJMP _0x7D
_0x7F:
; 0000 017E       exitSetByte:
_0x81:
; 0000 017F         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x9
; 0000 0180         lcd_clear();
	CALL _lcd_clear
; 0000 0181 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;byte kursorPID, kursorSpeed, kursorGaris;
;void showMenu() {
; 0000 0184 void showMenu() {
_showMenu:
; 0000 0185         lcd_clear();
	CALL _lcd_clear
; 0000 0186     menu01:
_0x94:
; 0000 0187         delay_ms(125);   // bouncing sw
	CALL SUBOPT_0xA
; 0000 0188         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0189                 // 0123456789abcdef
; 0000 018A         lcd_putsf("  Set PID       ");
	__POINTW1FN _0x0,170
	CALL SUBOPT_0x4
; 0000 018B         lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 018C         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x4
; 0000 018D 
; 0000 018E         // kursor awal
; 0000 018F         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0190         lcd_putchar(0);
	CALL SUBOPT_0xB
; 0000 0191 
; 0000 0192         if (!sw_ok)   {
	SBIC 0x16,1
	RJMP _0x95
; 0000 0193                 lcd_clear();
	CALL _lcd_clear
; 0000 0194                 kursorPID = 1;
	LDI  R30,LOW(1)
	STS  _kursorPID,R30
; 0000 0195                 goto setPID;
	RJMP _0x96
; 0000 0196         }
; 0000 0197         if (!sw_down) {
_0x95:
	SBIS 0x16,2
; 0000 0198                 goto menu02;
	RJMP _0x98
; 0000 0199         }
; 0000 019A         if (!sw_up)   {
	SBIC 0x16,3
	RJMP _0x99
; 0000 019B                 lcd_clear();
	CALL _lcd_clear
; 0000 019C                 goto menu05;
	RJMP _0x9A
; 0000 019D         }
; 0000 019E 
; 0000 019F         goto menu01;
_0x99:
	RJMP _0x94
; 0000 01A0     menu02:
_0x98:
; 0000 01A1         delay_ms(125);
	CALL SUBOPT_0xA
; 0000 01A2         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 01A3                  // 0123456789abcdef
; 0000 01A4         lcd_putsf("  Set PID       ");
	__POINTW1FN _0x0,170
	CALL SUBOPT_0x4
; 0000 01A5         lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 01A6         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x4
; 0000 01A7 
; 0000 01A8         lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 01A9         lcd_putchar(0);
	CALL SUBOPT_0xB
; 0000 01AA 
; 0000 01AB         if (!sw_ok) {
	SBIC 0x16,1
	RJMP _0x9B
; 0000 01AC                 lcd_clear();
	CALL _lcd_clear
; 0000 01AD                 kursorSpeed = 1;
	LDI  R30,LOW(1)
	STS  _kursorSpeed,R30
; 0000 01AE                 goto setSpeed;
	RJMP _0x9C
; 0000 01AF         }
; 0000 01B0         if (!sw_up) {
_0x9B:
	SBIS 0x16,3
; 0000 01B1                 goto menu01;
	RJMP _0x94
; 0000 01B2         }
; 0000 01B3         if (!sw_down) {
	SBIC 0x16,2
	RJMP _0x9E
; 0000 01B4                 lcd_clear();
	CALL _lcd_clear
; 0000 01B5                 goto menu03;
	RJMP _0x9F
; 0000 01B6        }
; 0000 01B7         goto menu02;
_0x9E:
	RJMP _0x98
; 0000 01B8     menu03:
_0x9F:
; 0000 01B9         delay_ms(125);
	CALL SUBOPT_0xA
; 0000 01BA         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 01BB                 // 0123456789abcdef
; 0000 01BC         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0x0,204
	CALL SUBOPT_0x4
; 0000 01BD         lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 01BE         lcd_putsf("  Skenario      ");
	__POINTW1FN _0x0,221
	CALL SUBOPT_0x4
; 0000 01BF 
; 0000 01C0         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 01C1         lcd_putchar(0);
	CALL SUBOPT_0xB
; 0000 01C2 
; 0000 01C3         if (!sw_ok) {
	SBIC 0x16,1
	RJMP _0xA0
; 0000 01C4                 lcd_clear();
	CALL _lcd_clear
; 0000 01C5                 kursorGaris = 1;
	LDI  R30,LOW(1)
	STS  _kursorGaris,R30
; 0000 01C6                 goto setGaris;
	RJMP _0xA1
; 0000 01C7         }
; 0000 01C8         if (!sw_up) {
_0xA0:
	SBIC 0x16,3
	RJMP _0xA2
; 0000 01C9                 lcd_clear();
	CALL _lcd_clear
; 0000 01CA                 goto menu02;
	RJMP _0x98
; 0000 01CB         }
; 0000 01CC         if (!sw_down) {
_0xA2:
	SBIS 0x16,2
; 0000 01CD                 goto menu04;
	RJMP _0xA4
; 0000 01CE         }
; 0000 01CF         goto menu03;
	RJMP _0x9F
; 0000 01D0     menu04:
_0xA4:
; 0000 01D1         delay_ms(125);
	CALL SUBOPT_0xA
; 0000 01D2         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 01D3                 // 0123456789abcdef
; 0000 01D4         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0x0,204
	CALL SUBOPT_0x4
; 0000 01D5         lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 01D6         lcd_putsf("  Skenario      ");
	__POINTW1FN _0x0,221
	CALL SUBOPT_0x4
; 0000 01D7 
; 0000 01D8         lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 01D9         lcd_putchar(0);
	CALL SUBOPT_0xB
; 0000 01DA 
; 0000 01DB         if (!sw_ok) {
	SBIC 0x16,1
	RJMP _0xA5
; 0000 01DC                 lcd_clear();
	CALL _lcd_clear
; 0000 01DD                 goto setSkenario;
	RJMP _0xA6
; 0000 01DE         }
; 0000 01DF         if (!sw_up) {
_0xA5:
	SBIS 0x16,3
; 0000 01E0                 goto menu03;
	RJMP _0x9F
; 0000 01E1         }
; 0000 01E2         if (!sw_down) {
	SBIC 0x16,2
	RJMP _0xA8
; 0000 01E3                 lcd_clear();
	CALL _lcd_clear
; 0000 01E4                 goto menu05;
	RJMP _0x9A
; 0000 01E5         }
; 0000 01E6         goto menu04;
_0xA8:
	RJMP _0xA4
; 0000 01E7     menu05:
_0x9A:
; 0000 01E8         delay_ms(125);
	CALL SUBOPT_0xA
; 0000 01E9         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 01EA         lcd_putsf("  Start!!      ");
	__POINTW1FN _0x0,238
	CALL SUBOPT_0x4
; 0000 01EB         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 01EC         lcd_putchar(0);
	CALL SUBOPT_0xB
; 0000 01ED 
; 0000 01EE         if (!sw_ok) {
	SBIC 0x16,1
	RJMP _0xA9
; 0000 01EF                 lcd_clear();
	CALL _lcd_clear
; 0000 01F0                 goto startRobot;
	RJMP _0xAA
; 0000 01F1         }
; 0000 01F2         if (!sw_up) {
_0xA9:
	SBIC 0x16,3
	RJMP _0xAB
; 0000 01F3                 lcd_clear();
	CALL _lcd_clear
; 0000 01F4                 goto menu04;
	RJMP _0xA4
; 0000 01F5         }
; 0000 01F6         if (!sw_down) {
_0xAB:
	SBIC 0x16,2
	RJMP _0xAC
; 0000 01F7                 lcd_clear();
	CALL _lcd_clear
; 0000 01F8                 goto menu01;
	RJMP _0x94
; 0000 01F9         }
; 0000 01FA 
; 0000 01FB         goto menu05;
_0xAC:
	RJMP _0x9A
; 0000 01FC 
; 0000 01FD     setPID:
_0x96:
; 0000 01FE         delay_ms(150);
	CALL SUBOPT_0x7
; 0000 01FF         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0200                 // 0123456789ABCDEF
; 0000 0201         lcd_putsf("  Kp   Ki   Kd  ");
	__POINTW1FN _0x0,254
	CALL SUBOPT_0x4
; 0000 0202         // lcd_putsf(" 250  200  300  ");
; 0000 0203         lcd_putchar(' ');
	CALL SUBOPT_0xC
; 0000 0204         tampil(Kp); lcd_putchar(' '); lcd_putchar(' ');
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
; 0000 0205         tampil(Ki); lcd_putchar(' '); lcd_putchar(' ');
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
; 0000 0206         tampil(Kd); lcd_putchar(' '); lcd_putchar(' ');
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
; 0000 0207 
; 0000 0208         switch (kursorPID) {
	LDS  R30,_kursorPID
	CALL SUBOPT_0x5
; 0000 0209           case 1:
	BRNE _0xB0
; 0000 020A                 lcd_gotoxy(1,0); // kursor Kp
	LDI  R30,LOW(1)
	RJMP _0x175
; 0000 020B                 lcd_putchar(0);
; 0000 020C                 break;
; 0000 020D           case 2:
_0xB0:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xB1
; 0000 020E                 lcd_gotoxy(6,0); // kursor Ki
	LDI  R30,LOW(6)
	RJMP _0x175
; 0000 020F                 lcd_putchar(0);
; 0000 0210                 break;
; 0000 0211           case 3:
_0xB1:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xAF
; 0000 0212                 lcd_gotoxy(11,0); // kursor Kd
	LDI  R30,LOW(11)
_0x175:
	ST   -Y,R30
	CALL SUBOPT_0xE
; 0000 0213                 lcd_putchar(0);
; 0000 0214                 break;
; 0000 0215         }
_0xAF:
; 0000 0216 
; 0000 0217         if (!sw_ok) {
	SBIC 0x16,1
	RJMP _0xB3
; 0000 0218                 setByte( 1, kursorPID);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDS  R30,_kursorPID
	CALL SUBOPT_0xF
; 0000 0219                 delay_ms(200);
; 0000 021A         }
; 0000 021B         if (!sw_up) {
_0xB3:
	SBIC 0x16,3
	RJMP _0xB4
; 0000 021C                 if (kursorPID == 3) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x3)
	BRNE _0xB5
; 0000 021D                         kursorPID = 1;
	LDI  R30,LOW(1)
	RJMP _0x176
; 0000 021E                 } else kursorPID++;
_0xB5:
	LDS  R30,_kursorPID
	SUBI R30,-LOW(1)
_0x176:
	STS  _kursorPID,R30
; 0000 021F         }
; 0000 0220         if (!sw_down) {
_0xB4:
	SBIC 0x16,2
	RJMP _0xB7
; 0000 0221                 if (kursorPID == 1) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x1)
	BRNE _0xB8
; 0000 0222                         kursorPID = 3;
	LDI  R30,LOW(3)
	RJMP _0x177
; 0000 0223                 } else kursorPID--;
_0xB8:
	LDS  R30,_kursorPID
	SUBI R30,LOW(1)
_0x177:
	STS  _kursorPID,R30
; 0000 0224         }
; 0000 0225 
; 0000 0226         if (!sw_cancel) {
_0xB7:
	SBIC 0x16,0
	RJMP _0xBA
; 0000 0227                 lcd_clear();
	CALL _lcd_clear
; 0000 0228                 goto menu01;
	RJMP _0x94
; 0000 0229         }
; 0000 022A 
; 0000 022B         goto setPID;
_0xBA:
	RJMP _0x96
; 0000 022C 
; 0000 022D     setSpeed:
_0x9C:
; 0000 022E         delay_ms(150);
	CALL SUBOPT_0x7
; 0000 022F         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0230                 // 0123456789ABCDEF
; 0000 0231         lcd_putsf("   MAX    MIN   ");
	__POINTW1FN _0x0,271
	CALL SUBOPT_0x4
; 0000 0232         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
; 0000 0233 
; 0000 0234         //lcd_putsf("   250    200   ");
; 0000 0235         tampil(MAXSpeed);
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL SUBOPT_0xD
; 0000 0236         lcd_putchar(' '); lcd_putchar(' ');lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
; 0000 0237         tampil(MINSpeed);
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0xD
; 0000 0238         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0xC
	CALL SUBOPT_0xC
; 0000 0239 
; 0000 023A         switch (kursorSpeed) {
	LDS  R30,_kursorSpeed
	CALL SUBOPT_0x5
; 0000 023B           case 1:
	BRNE _0xBE
; 0000 023C                 lcd_gotoxy(2,0); // kursor MAX
	LDI  R30,LOW(2)
	RJMP _0x178
; 0000 023D                 lcd_putchar(0);
; 0000 023E                 break;
; 0000 023F           case 2:
_0xBE:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xBD
; 0000 0240                 lcd_gotoxy(9,0); // kursor MIN
	LDI  R30,LOW(9)
_0x178:
	ST   -Y,R30
	CALL SUBOPT_0xE
; 0000 0241                 lcd_putchar(0);
; 0000 0242                 break;
; 0000 0243         }
_0xBD:
; 0000 0244 
; 0000 0245         if (!sw_ok) {
	SBIC 0x16,1
	RJMP _0xC0
; 0000 0246                 setByte( 2, kursorSpeed);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R30,_kursorSpeed
	CALL SUBOPT_0xF
; 0000 0247                 delay_ms(200);
; 0000 0248         }
; 0000 0249         if (!sw_up) {
_0xC0:
	SBIC 0x16,3
	RJMP _0xC1
; 0000 024A                 if (kursorSpeed == 2) {
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x2)
	BRNE _0xC2
; 0000 024B                         kursorSpeed = 1;
	LDI  R30,LOW(1)
	RJMP _0x179
; 0000 024C                 } else kursorSpeed++;
_0xC2:
	LDS  R30,_kursorSpeed
	SUBI R30,-LOW(1)
_0x179:
	STS  _kursorSpeed,R30
; 0000 024D         }
; 0000 024E         if (!sw_down) {
_0xC1:
	SBIC 0x16,2
	RJMP _0xC4
; 0000 024F                 if (kursorSpeed == 1) {
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x1)
	BRNE _0xC5
; 0000 0250                         kursorSpeed = 2;
	LDI  R30,LOW(2)
	RJMP _0x17A
; 0000 0251                 } else kursorSpeed--;
_0xC5:
	LDS  R30,_kursorSpeed
	SUBI R30,LOW(1)
_0x17A:
	STS  _kursorSpeed,R30
; 0000 0252         }
; 0000 0253 
; 0000 0254         if (!sw_cancel) {
_0xC4:
	SBIC 0x16,0
	RJMP _0xC7
; 0000 0255                 lcd_clear();
	CALL _lcd_clear
; 0000 0256                 goto menu02;
	RJMP _0x98
; 0000 0257         }
; 0000 0258 
; 0000 0259         goto setSpeed;
_0xC7:
	RJMP _0x9C
; 0000 025A 
; 0000 025B      setGaris: // not yet
_0xA1:
; 0000 025C         delay_ms(150);
	CALL SUBOPT_0x7
; 0000 025D         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 025E                 // 0123456789ABCDEF
; 0000 025F         if ( WarnaGaris == 1 )
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0xC8
; 0000 0260                 lcd_putsf("  WARNA : Putih ");
	__POINTW1FN _0x0,288
	RJMP _0x17B
; 0000 0261         else
_0xC8:
; 0000 0262                 lcd_putsf("  WARNA : Hitam ");
	__POINTW1FN _0x0,305
_0x17B:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0263 
; 0000 0264         //lcd_putsf("  LEBAR: 1.5 cm ");
; 0000 0265         lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 0266         lcd_putsf("  SensL :        ");
	__POINTW1FN _0x0,322
	CALL SUBOPT_0x4
; 0000 0267         lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0268         tampil( SensLine );
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _tampil
; 0000 0269 
; 0000 026A         switch (kursorGaris) {
	LDS  R30,_kursorGaris
	CALL SUBOPT_0x5
; 0000 026B           case 1:
	BRNE _0xCD
; 0000 026C                 lcd_gotoxy(0,0); // kursor Warna
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x17C
; 0000 026D                 lcd_putchar(0);
; 0000 026E                 break;
; 0000 026F           case 2:
_0xCD:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xCC
; 0000 0270                 lcd_gotoxy(0,1); // kursor SensL
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x17C:
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0271                 lcd_putchar(0);
	CALL SUBOPT_0xB
; 0000 0272                 break;
; 0000 0273         }
_0xCC:
; 0000 0274 
; 0000 0275         if (!sw_ok) {
	SBIC 0x16,1
	RJMP _0xCF
; 0000 0276                 setByte( 3, kursorGaris);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDS  R30,_kursorGaris
	CALL SUBOPT_0xF
; 0000 0277                 delay_ms(200);
; 0000 0278         }
; 0000 0279         if (!sw_up) {
_0xCF:
	SBIC 0x16,3
	RJMP _0xD0
; 0000 027A                 if (kursorGaris == 2) {
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x2)
	BRNE _0xD1
; 0000 027B                         kursorGaris = 1;
	LDI  R30,LOW(1)
	RJMP _0x17D
; 0000 027C                 } else kursorGaris++;
_0xD1:
	LDS  R30,_kursorGaris
	SUBI R30,-LOW(1)
_0x17D:
	STS  _kursorGaris,R30
; 0000 027D         }
; 0000 027E         if (!sw_down) {
_0xD0:
	SBIC 0x16,2
	RJMP _0xD3
; 0000 027F                 if (kursorGaris == 1) {
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x1)
	BRNE _0xD4
; 0000 0280                         kursorGaris = 2;
	LDI  R30,LOW(2)
	RJMP _0x17E
; 0000 0281                 } else kursorGaris--;
_0xD4:
	LDS  R30,_kursorGaris
	SUBI R30,LOW(1)
_0x17E:
	STS  _kursorGaris,R30
; 0000 0282         }
; 0000 0283 
; 0000 0284         if (!sw_cancel) {
_0xD3:
	SBIC 0x16,0
	RJMP _0xD6
; 0000 0285                 lcd_clear();
	CALL _lcd_clear
; 0000 0286                 goto menu03;
	RJMP _0x9F
; 0000 0287         }
; 0000 0288 
; 0000 0289         goto setGaris;
_0xD6:
	RJMP _0xA1
; 0000 028A 
; 0000 028B      setSkenario:
_0xA6:
; 0000 028C         delay_ms(150);
	CALL SUBOPT_0x7
; 0000 028D         lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 028E                 // 0123456789ABCDEF
; 0000 028F         lcd_putsf("Sken. yg  dpake:");
	__POINTW1FN _0x0,340
	CALL SUBOPT_0x4
; 0000 0290         lcd_gotoxy(0, 1);
	CALL SUBOPT_0x8
; 0000 0291         tampil( Skenario );
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _tampil
; 0000 0292 
; 0000 0293         if (!sw_ok) {
	SBIC 0x16,1
	RJMP _0xD7
; 0000 0294                 setByte( 4, 0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF
; 0000 0295                 delay_ms(200);
; 0000 0296         }
; 0000 0297 
; 0000 0298         if (!sw_cancel) {
_0xD7:
	SBIC 0x16,0
	RJMP _0xD8
; 0000 0299                 lcd_clear();
	CALL _lcd_clear
; 0000 029A                 goto menu04;
	RJMP _0xA4
; 0000 029B         }
; 0000 029C 
; 0000 029D         goto setSkenario;
_0xD8:
	RJMP _0xA6
; 0000 029E 
; 0000 029F      startRobot:
_0xAA:
; 0000 02A0         lcd_clear();
	CALL _lcd_clear
; 0000 02A1 }
	RET
;
;
;
;#define sensor    PINA
;#define s0   PINA.0
;#define s1   PINA.1
;#define s2   PINA.2
;#define s3   PINA.3
;#define s4   PINA.4
;#define s5   PINA.5
;#define s6   PINA.6
;#define s7   PINA.7
;
;#define sKi  PINB.5
;#define sKa  PINB.6
;
;void displaySensorBit()
; 0000 02B3 {
_displaySensorBit:
; 0000 02B4     lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 02B5     if (s7) lcd_putchar('1');
	SBIS 0x19,7
	RJMP _0xD9
	LDI  R30,LOW(49)
	RJMP _0x17F
; 0000 02B6     else    lcd_putchar('0');
_0xD9:
	LDI  R30,LOW(48)
_0x17F:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 02B7     if (s6) lcd_putchar('1');
	SBIS 0x19,6
	RJMP _0xDB
	LDI  R30,LOW(49)
	RJMP _0x180
; 0000 02B8     else    lcd_putchar('0');
_0xDB:
	LDI  R30,LOW(48)
_0x180:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 02B9     if (s5) lcd_putchar('1');
	SBIS 0x19,5
	RJMP _0xDD
	LDI  R30,LOW(49)
	RJMP _0x181
; 0000 02BA     else    lcd_putchar('0');
_0xDD:
	LDI  R30,LOW(48)
_0x181:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 02BB     if (s4) lcd_putchar('1');
	SBIS 0x19,4
	RJMP _0xDF
	LDI  R30,LOW(49)
	RJMP _0x182
; 0000 02BC     else    lcd_putchar('0');
_0xDF:
	LDI  R30,LOW(48)
_0x182:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 02BD     if (s3) lcd_putchar('1');
	SBIS 0x19,3
	RJMP _0xE1
	LDI  R30,LOW(49)
	RJMP _0x183
; 0000 02BE     else    lcd_putchar('0');
_0xE1:
	LDI  R30,LOW(48)
_0x183:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 02BF     if (s2) lcd_putchar('1');
	SBIS 0x19,2
	RJMP _0xE3
	LDI  R30,LOW(49)
	RJMP _0x184
; 0000 02C0     else    lcd_putchar('0');
_0xE3:
	LDI  R30,LOW(48)
_0x184:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 02C1     if (s1) lcd_putchar('1');
	SBIS 0x19,1
	RJMP _0xE5
	LDI  R30,LOW(49)
	RJMP _0x185
; 0000 02C2     else    lcd_putchar('0');
_0xE5:
	LDI  R30,LOW(48)
_0x185:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 02C3     if (s0) lcd_putchar('1');
	SBIS 0x19,0
	RJMP _0xE7
	LDI  R30,LOW(49)
	RJMP _0x186
; 0000 02C4     else    lcd_putchar('0');
_0xE7:
	LDI  R30,LOW(48)
_0x186:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 02C5 }
	RET
;
;#define Enki PORTD.4
;#define kirplus PORTD.6
;#define kirmin PORTD.3
;
;#define Enka PORTD.5
;#define kaplus PORTD.1
;#define kamin PORTD.0
;
;unsigned char xcount;
;int lpwm, rpwm, MAXPWM, MINPWM, intervalPWM;
;byte diffPWM = 5; // utk kiri

	.DSEG
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 02D4 {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 02D5         // Place your code here
; 0000 02D6     xcount++;
	LDS  R30,_xcount
	SUBI R30,-LOW(1)
	STS  _xcount,R30
; 0000 02D7     if(xcount<=lpwm)Enki=1;
	LDS  R30,_lpwm
	LDS  R31,_lpwm+1
	CALL SUBOPT_0x10
	BRLT _0xEA
	SBI  0x12,4
; 0000 02D8     else Enki=0;
	RJMP _0xED
_0xEA:
	CBI  0x12,4
; 0000 02D9     if(xcount<=rpwm)Enka=1;
_0xED:
	LDS  R30,_rpwm
	LDS  R31,_rpwm+1
	CALL SUBOPT_0x10
	BRLT _0xF0
	SBI  0x12,5
; 0000 02DA     else Enka=0;
	RJMP _0xF3
_0xF0:
	CBI  0x12,5
; 0000 02DB     TCNT0=0xFF;
_0xF3:
	LDI  R30,LOW(255)
	OUT  0x32,R30
; 0000 02DC }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;void maju()
; 0000 02DF {
; 0000 02E0         kaplus=1;kirplus=1;
; 0000 02E1         kamin=0;kirmin=0;
; 0000 02E2 }
;
;void mundur()
; 0000 02E5 {
; 0000 02E6         kaplus=0;kirplus=0;
; 0000 02E7         kamin=1;kirmin=1;
; 0000 02E8 }
;
;void bkan()
; 0000 02EB {
; 0000 02EC         kaplus=0;
; 0000 02ED         kamin=1;
; 0000 02EE }
;
;void bkir()
; 0000 02F1 {
; 0000 02F2         kirplus=0;
; 0000 02F3         kirmin=1;
; 0000 02F4 }
;
;void stop()
; 0000 02F7 {
_stop:
; 0000 02F8         rpwm=0;lpwm=0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	STS  _lpwm,R30
	STS  _lpwm+1,R31
; 0000 02F9         kaplus=0;kirplus=0;
	CBI  0x12,1
	CBI  0x12,6
; 0000 02FA         kamin=0;kirmin=0;
	CBI  0x12,0
	CBI  0x12,3
; 0000 02FB }
	RET
;
;int MV, P, I, D, PV, error, last_error, rate;
;int var_Kp, var_Ki, var_Kd;
;unsigned char max_MV = 100;

	.DSEG
;unsigned char min_MV = -100;
;unsigned char SP = 0;
;void scanBlackLine() {
; 0000 0302 void scanBlackLine() {

	.CSEG
; 0000 0303 
; 0000 0304     switch(sensor) {
; 0000 0305         case 0b11111110:        // ujung kiri
; 0000 0306                 PV = -7;
; 0000 0307                 maju();
; 0000 0308                 break;
; 0000 0309         case 0b11111000:
; 0000 030A         case 0b11111100:
; 0000 030B                 PV = -6;
; 0000 030C                 maju();
; 0000 030D                 break;
; 0000 030E         case 0b11111101:
; 0000 030F                 PV = -5;
; 0000 0310                 maju();
; 0000 0311                 break;
; 0000 0312         case 0b11110001:
; 0000 0313         case 0b11111001:
; 0000 0314                 PV = -4;
; 0000 0315                 maju();
; 0000 0316                 break;
; 0000 0317         case 0b11111011:
; 0000 0318                 PV = -3;
; 0000 0319                 maju();
; 0000 031A                 break;
; 0000 031B         case 0b11100011:
; 0000 031C         case 0b11110011:
; 0000 031D                 PV = -2;
; 0000 031E                 maju();
; 0000 031F                 break;
; 0000 0320         case 0b11110111:
; 0000 0321                 PV = -1;
; 0000 0322                 maju();
; 0000 0323                 break;
; 0000 0324         case 0b11100111:        // tengah
; 0000 0325                 PV = 0;
; 0000 0326                 maju();
; 0000 0327                 break;
; 0000 0328         case 0b11101111:
; 0000 0329                 PV = 1;
; 0000 032A                 maju();
; 0000 032B                 break;
; 0000 032C         case 0b11000111:
; 0000 032D         case 0b11001111:
; 0000 032E                 PV = 2;
; 0000 032F                 maju();
; 0000 0330                 break;
; 0000 0331         case 0b11011111:
; 0000 0332                 PV = 3;
; 0000 0333                 maju();
; 0000 0334                 break;
; 0000 0335         case 0b10001111:
; 0000 0336         case 0b10011111:
; 0000 0337                 PV = 4;
; 0000 0338                 maju();
; 0000 0339                 break;
; 0000 033A         case 0b10111111:
; 0000 033B                 PV = 5;
; 0000 033C                 maju();
; 0000 033D                 break;
; 0000 033E         case 0b00011111:
; 0000 033F         case 0b00111111:
; 0000 0340                 PV = 6;
; 0000 0341                 maju();
; 0000 0342                 break;
; 0000 0343         case 0b01111111:        // ujung kanan
; 0000 0344                 PV = 7;
; 0000 0345                 maju();
; 0000 0346                 break;
; 0000 0347         case 0b11111111:        // loss
; 0000 0348                 //if (PV < -3) {
; 0000 0349                 if (PV < 0) {
; 0000 034A                         // PV = -8;
; 0000 034B                         lpwm = 150;
; 0000 034C                         rpwm = 185;
; 0000 034D                         bkir();
; 0000 034E                         goto exit;
; 0000 034F                 //} else if (PV > 3) {
; 0000 0350                 } else if (PV > 0) {
; 0000 0351                         // PV = 8;
; 0000 0352                         lpwm = 180;
; 0000 0353                         rpwm = 155;
; 0000 0354                         bkan();
; 0000 0355                         goto exit;
; 0000 0356                 } /*else {
; 0000 0357                         PV = 0;
; 0000 0358                         lpwm = MAXPWM - 5;
; 0000 0359                         rpwm = MAXPWM;
; 0000 035A                         maju();
; 0000 035B                 }*/
; 0000 035C     }
; 0000 035D 
; 0000 035E     error = SP - PV;
; 0000 035F     P = (var_Kp * error) / 8;
; 0000 0360 
; 0000 0361     I = I + error;
; 0000 0362     I = (I * var_Ki) / 8;
; 0000 0363 
; 0000 0364     rate = error - last_error;
; 0000 0365     D    = (rate * var_Kd) / 8;
; 0000 0366 
; 0000 0367     last_error = error;
; 0000 0368 
; 0000 0369     MV = P + I + D;
; 0000 036A 
; 0000 036B     if (MV == 0) {
; 0000 036C          lpwm = MAXPWM - diffPWM;
; 0000 036D          rpwm = MAXPWM;
; 0000 036E     }
; 0000 036F 
; 0000 0370     else if (MV > 0)
; 0000 0371     { // alihkan ke kiri
; 0000 0372         rpwm = MAXPWM - ((intervalPWM - 20) * MV);
; 0000 0373         lpwm = (MAXPWM - (intervalPWM * MV) - 15) - diffPWM;
; 0000 0374 
; 0000 0375         //rpwm = MAXPWM - ((intervalPWM - 12) * MV);
; 0000 0376         //lpwm = (MAXPWM - (intervalPWM * MV)) - diffPWM;
; 0000 0377 
; 0000 0378         if (lpwm < MINPWM) lpwm = MINPWM;
; 0000 0379         if (lpwm > MAXPWM) lpwm = MAXPWM;
; 0000 037A         if (rpwm < MINPWM) rpwm = MINPWM;
; 0000 037B         if (rpwm > MAXPWM) rpwm = MAXPWM;
; 0000 037C     }
; 0000 037D 
; 0000 037E     else if (MV < 0)
; 0000 037F     { // alihkan ke kanan
; 0000 0380         lpwm = MAXPWM + ( ( intervalPWM - 20 ) * MV);
; 0000 0381         rpwm = MAXPWM + ( ( intervalPWM * MV ) - 15 );
; 0000 0382 
; 0000 0383         if (lpwm < MINPWM) lpwm = MINPWM;
; 0000 0384         if (lpwm > MAXPWM) lpwm = MAXPWM;
; 0000 0385         if (rpwm < MINPWM) rpwm = MINPWM;
; 0000 0386         if (rpwm > MAXPWM) rpwm = MAXPWM;
; 0000 0387 
; 0000 0388         //lpwm = MAXPWM + ( ((intervalPWM - 12) + 5) * MV);
; 0000 0389         //rpwm = MAXPWM + ((intervalPWM * MV) * MV);
; 0000 038A     }
; 0000 038B 
; 0000 038C     exit:
; 0000 038D     //debug pwm
; 0000 038E     sprintf(lcd_buffer,"%d   %d",lpwm, rpwm);
; 0000 038F     lcd_gotoxy(0, 0);
; 0000 0390     lcd_putsf("                ");
; 0000 0391     lcd_gotoxy(0, 0);
; 0000 0392     lcd_puts(lcd_buffer);
; 0000 0393     delay_ms(5);
; 0000 0394 
; 0000 0395     /*debug MV
; 0000 0396     sprintf(lcd_buffer,"MV:%d",MV);
; 0000 0397     lcd_gotoxy(0,0);
; 0000 0398     lcd_putsf("                ");
; 0000 0399     lcd_gotoxy(0,0);
; 0000 039A     lcd_puts(lcd_buffer);
; 0000 039B     delay_ms(10); */
; 0000 039C }
;
;int hitungSiku;
;void ketemuSiku(unsigned char belokKanan) {
; 0000 039F void ketemuSiku(unsigned char belokKanan) {
; 0000 03A0     stop();
;	belokKanan -> Y+0
; 0000 03A1 
; 0000 03A2     lpwm = 120;
; 0000 03A3     rpwm = 120;
; 0000 03A4     mundur();
; 0000 03A5 
; 0000 03A6 loopSiku:
; 0000 03A7     if ( !sKi ) goto keluarSiku_;
; 0000 03A8     if ( !sKa ) goto keluarSiku_;
; 0000 03A9     if ( sensor != 0xff ) goto keluarSiku_;
; 0000 03AA     goto loopSiku;
; 0000 03AB 
; 0000 03AC keluarSiku_:
; 0000 03AD     stop();
; 0000 03AE     lpwm = 150;
; 0000 03AF     rpwm = 155;
; 0000 03B0 
; 0000 03B1     if ( belokKanan ) {
; 0000 03B2         while (sensor == 0xff) {
; 0000 03B3                 bkan();
; 0000 03B4         }
; 0000 03B5     } else {
; 0000 03B6         while (sensor == 0xff) {
; 0000 03B7                 bkir();
; 0000 03B8         }
; 0000 03B9     }
; 0000 03BA keluarSiku:
; 0000 03BB     for (hitungSiku = 0; hitungSiku < 150; hitungSiku++) {
; 0000 03BC         scanBlackLine();
; 0000 03BD         delay_ms(1);
; 0000 03BE     }
; 0000 03BF }
;
;// Declare your global variables here
;
;void main(void)
; 0000 03C4 {
_main:
; 0000 03C5 // Declare your local variables here
; 0000 03C6 
; 0000 03C7 // Input/Output Ports initialization
; 0000 03C8 // Port A initialization
; 0000 03C9 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 03CA // State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 03CB PORTA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 03CC DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 03CD 
; 0000 03CE // Port B initialization
; 0000 03CF // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 03D0 // State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 03D1 PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 03D2 DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 03D3 
; 0000 03D4 // Port C initialization
; 0000 03D5 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 03D6 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 03D7 PORTC=0x00;
	OUT  0x15,R30
; 0000 03D8 DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 03D9 
; 0000 03DA // Port D initialization
; 0000 03DB // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 03DC // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 03DD PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 03DE DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 03DF 
; 0000 03E0 // Timer/Counter 0 initialization
; 0000 03E1 // Clock source: System Clock
; 0000 03E2 // Clock value: 12000.000 kHz
; 0000 03E3 // Mode: Normal top=FFh
; 0000 03E4 // OC0 output: Disconnected
; 0000 03E5 TCCR0=0x01;
	LDI  R30,LOW(1)
	OUT  0x33,R30
; 0000 03E6 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 03E7 OCR0=0x00;
	OUT  0x3C,R30
; 0000 03E8 
; 0000 03E9 // Timer/Counter 1 initialization
; 0000 03EA // Clock source: System Clock
; 0000 03EB // Clock value: Timer 1 Stopped
; 0000 03EC // Mode: Normal top=FFFFh
; 0000 03ED // OC1A output: Discon.
; 0000 03EE // OC1B output: Discon.
; 0000 03EF // Noise Canceler: Off
; 0000 03F0 // Input Capture on Falling Edge
; 0000 03F1 // Timer 1 Overflow Interrupt: Off
; 0000 03F2 // Input Capture Interrupt: Off
; 0000 03F3 // Compare A Match Interrupt: Off
; 0000 03F4 // Compare B Match Interrupt: Off
; 0000 03F5 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 03F6 TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 03F7 TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 03F8 TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 03F9 ICR1H=0x00;
	OUT  0x27,R30
; 0000 03FA ICR1L=0x00;
	OUT  0x26,R30
; 0000 03FB OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 03FC OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 03FD OCR1BH=0x00;
	OUT  0x29,R30
; 0000 03FE OCR1BL=0x00;
	OUT  0x28,R30
; 0000 03FF 
; 0000 0400 // Timer/Counter 2 initialization
; 0000 0401 // Clock source: System Clock
; 0000 0402 // Clock value: Timer 2 Stopped
; 0000 0403 // Mode: Normal top=FFh
; 0000 0404 // OC2 output: Disconnected
; 0000 0405 ASSR=0x00;
	OUT  0x22,R30
; 0000 0406 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0407 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0408 OCR2=0x00;
	OUT  0x23,R30
; 0000 0409 
; 0000 040A // External Interrupt(s) initialization
; 0000 040B // INT0: Off
; 0000 040C // INT1: Off
; 0000 040D // INT2: Off
; 0000 040E MCUCR=0x00;
	OUT  0x35,R30
; 0000 040F MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0410 
; 0000 0411 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0412 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0413 
; 0000 0414 // Analog Comparator initialization
; 0000 0415 // Analog Comparator: Off
; 0000 0416 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0417 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0418 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0419 
; 0000 041A // ADC initialization
; 0000 041B // ADC Clock frequency: 750.000 kHz
; 0000 041C // ADC Voltage Reference: AREF pin
; 0000 041D // ADC Auto Trigger Source: None
; 0000 041E // Only the 8 most significant bits of
; 0000 041F // the AD conversion result are used
; 0000 0420 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0421 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0422 
; 0000 0423 // LCD module initialization
; 0000 0424 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0425 
; 0000 0426 /* define user character 0 */
; 0000 0427 define_char(char0,0);
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _define_char
; 0000 0428 
; 0000 0429 // stop motor
; 0000 042A TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 042B stop();
	RCALL _stop
; 0000 042C 
; 0000 042D delay_ms(125);
	CALL SUBOPT_0xA
; 0000 042E lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 042F         // 0123456789ABCDEF
; 0000 0430 lcd_putsf("  baru_belajar  ");
	__POINTW1FN _0x0,382
	CALL SUBOPT_0x4
; 0000 0431 lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 0432 lcd_putsf("      by :      ");
	__POINTW1FN _0x0,399
	CALL SUBOPT_0x4
; 0000 0433 delay_ms(500);
	CALL SUBOPT_0x11
; 0000 0434 lcd_clear();
	CALL _lcd_clear
; 0000 0435 
; 0000 0436 lcd_clear();
	CALL SUBOPT_0x12
; 0000 0437 delay_ms(125);
; 0000 0438 lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0439         // 0123456789ABCDEF
; 0000 043A lcd_putsf(" DIONYSIUS IVAN ");
	__POINTW1FN _0x0,416
	CALL SUBOPT_0x4
; 0000 043B delay_ms(500);
	CALL SUBOPT_0x11
; 0000 043C lcd_clear();
	CALL SUBOPT_0x12
; 0000 043D 
; 0000 043E delay_ms(125);
; 0000 043F lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0440         // 0123456789ABCDEF
; 0000 0441 lcd_putsf(" HANDIKO GESANG");
	__POINTW1FN _0x0,433
	CALL SUBOPT_0x4
; 0000 0442 delay_ms(500);
	CALL SUBOPT_0x11
; 0000 0443 lcd_clear();
	CALL SUBOPT_0x12
; 0000 0444 
; 0000 0445 delay_ms(125);
; 0000 0446 lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0447         // 0123456789ABCDEF
; 0000 0448 lcd_putsf("TEKNIK FISIKA 10");
	__POINTW1FN _0x0,449
	CALL SUBOPT_0x4
; 0000 0449 lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 044A lcd_putsf("-------UGM------");
	__POINTW1FN _0x0,466
	CALL SUBOPT_0x4
; 0000 044B delay_ms(500);
	CALL SUBOPT_0x11
; 0000 044C lcd_clear();
	CALL SUBOPT_0x12
; 0000 044D 
; 0000 044E delay_ms(125);
; 0000 044F lcd_gotoxy(0,0);
	CALL SUBOPT_0x3
; 0000 0450         // 0123456789ABCDEF
; 0000 0451 lcd_putsf("ROBORACE UNY '10");
	__POINTW1FN _0x0,483
	CALL SUBOPT_0x4
; 0000 0452 lcd_gotoxy(0,1);
	CALL SUBOPT_0x8
; 0000 0453 lcd_putsf("----------------");
	__POINTW1FN _0x0,500
	CALL SUBOPT_0x4
; 0000 0454 delay_ms(500);
	CALL SUBOPT_0x11
; 0000 0455 lcd_clear();
	CALL _lcd_clear
; 0000 0456 
; 0000 0457 showMenu();
	RCALL _showMenu
; 0000 0458 
; 0000 0459 TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 045A #asm("sei")
	sei
; 0000 045B 
; 0000 045C // read eeprom
; 0000 045D var_Kp  = Kp;
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL SUBOPT_0x13
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
; 0000 045E var_Ki  = Ki;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL SUBOPT_0x13
	STS  _var_Ki,R30
	STS  _var_Ki+1,R31
; 0000 045F var_Kd  = Kd;
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL SUBOPT_0x13
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
; 0000 0460 MAXPWM = (int)MAXSpeed + 1;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL SUBOPT_0x13
	ADIW R30,1
	STS  _MAXPWM,R30
	STS  _MAXPWM+1,R31
; 0000 0461 MINPWM = MINSpeed;
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x13
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
; 0000 0462 
; 0000 0463 intervalPWM = (MAXSpeed - MINSpeed) / 8;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL __EEPROMRDB
	MOV  R0,R30
	CLR  R1
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x13
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	STS  _intervalPWM,R30
	STS  _intervalPWM+1,R31
; 0000 0464 PV = 0;
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	STS  _PV,R30
	STS  _PV+1,R31
; 0000 0465 error = 0;
	STS  _error,R30
	STS  _error+1,R31
; 0000 0466 last_error = 0;
	STS  _last_error,R30
	STS  _last_error+1,R31
; 0000 0467 
; 0000 0468 //maju();
; 0000 0469 
; 0000 046A while (1)
_0x159:
; 0000 046B         {
; 0000 046C         // Place your code here
; 0000 046D         displaySensorBit();
	RCALL _displaySensorBit
; 0000 046E         //kalibrasi_sensor();
; 0000 046F         //baca_sensor();
; 0000 0470         //read_sensor();
; 0000 0471 
; 0000 0472         /*kaplus=0; kamin=0;
; 0000 0473         kirplus=0; kirmin=0;
; 0000 0474 
; 0000 0475         kaplus=1; kirmin=1;  //kiri
; 0000 0476 
; 0000 0477             delay_ms(420);
; 0000 0478 
; 0000 0479         kaplus=0; kirmin=0;
; 0000 047A 
; 0000 047B             delay_ms(220);
; 0000 047C 
; 0000 047D         kaplus=1; kirplus=1;  //maju
; 0000 047E 
; 0000 047F             delay_ms(320);
; 0000 0480 
; 0000 0481         kaplus=0; kirplus=0;
; 0000 0482 
; 0000 0483             delay_ms(220);
; 0000 0484 
; 0000 0485         kamin=1; kirplus=1;   //kanan
; 0000 0486 
; 0000 0487             delay_ms(420);
; 0000 0488 
; 0000 0489         kamin=0; kirplus=0;
; 0000 048A 
; 0000 048B             delay_ms(220);
; 0000 048C 
; 0000 048D         kamin=1; kirmin=1;    //mundur
; 0000 048E 
; 0000 048F             delay_ms(500);
; 0000 0490 
; 0000 0491         kamin=0; kirmin=0;
; 0000 0492 
; 0000 0493             delay_ms(220);
; 0000 0494 
; 0000 0495         kamin=1; kirplus=1;   //rotasi kanan
; 0000 0496 
; 0000 0497             delay_ms(700);
; 0000 0498 
; 0000 0499         kamin=0; kirplus=0;
; 0000 049A 
; 0000 049B             delay_ms(220);
; 0000 049C 
; 0000 049D         kaplus=1; kirmin=1;    //rotasi kiri
; 0000 049E 
; 0000 049F             delay_ms(700);
; 0000 04A0 
; 0000 04A1         kaplus=0; kirmin=0;
; 0000 04A2 
; 0000 04A3             delay_ms(200);
; 0000 04A4 
; 0000 04A5         kaplus=1; kirmin=1;   //rotasi panjang kanan
; 0000 04A6 
; 0000 04A7             delay_ms(1500);
; 0000 04A8 
; 0000 04A9         kaplus=0; kirmin=0;
; 0000 04AA 
; 0000 04AB 
; 0000 04AC         if ( (!sKi) && (sensor==0xff) )
; 0000 04AD         {
; 0000 04AE             ketemuSiku(0);
; 0000 04AF             goto scan01;
; 0000 04B0         }
; 0000 04B1 
; 0000 04B2         if ( (!sKa) && (sensor==0xff) )
; 0000 04B3         {
; 0000 04B4             ketemuSiku(1);
; 0000 04B5         }
; 0000 04B6 
; 0000 04B7         scan01:*/
; 0000 04B8         //scanBlackLine();
; 0000 04B9 
; 0000 04BA         };
	RJMP _0x159
; 0000 04BB }
_0x15C:
	RJMP _0x15C
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
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
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
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G101:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0001
_lcd_write_byte:
	CALL __lcd_ready
	LDD  R30,Y+1
	CALL SUBOPT_0x14
    sbi   __lcd_port,__lcd_rs     ;RS=1
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	RJMP _0x20C0003
__lcd_read_nibble_G101:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
    andi  r30,0xf0
	RET
_lcd_read_byte0_G101:
	CALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	CALL SUBOPT_0x15
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	ADD  R30,R26
	ADC  R31,R27
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x20C0003:
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	CALL SUBOPT_0x14
	LDI  R30,LOW(12)
	CALL SUBOPT_0x14
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
	BRSH _0x2020004
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
_0x2020004:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0001
_lcd_putsf:
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
	LDD  R17,Y+0
_0x20C0002:
	ADIW R28,3
	RET
__long_delay_G101:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G101:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	CALL SUBOPT_0x15
	SUBI R30,LOW(-128)
	SBCI R31,HIGH(-128)
	__PUTB1MN __base_y_G101,2
	CALL SUBOPT_0x15
	SUBI R30,LOW(-192)
	SBCI R31,HIGH(-192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	CALL SUBOPT_0x16
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x17
	LDI  R30,LOW(4)
	CALL SUBOPT_0x17
	LDI  R30,LOW(133)
	CALL SUBOPT_0x17
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x202000B:
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

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_a3:
	.BYTE 0x1
_a4:
	.BYTE 0x1
_a5:
	.BYTE 0x1
_a6:
	.BYTE 0x1
_a7:
	.BYTE 0x1
_a8:
	.BYTE 0x1
_b1:
	.BYTE 0x1
_b2:
	.BYTE 0x1
_b3:
	.BYTE 0x1
_b4:
	.BYTE 0x1
_b5:
	.BYTE 0x1
_b6:
	.BYTE 0x1
_b7:
	.BYTE 0x1
_b8:
	.BYTE 0x1
_r1:
	.BYTE 0x1
_r2:
	.BYTE 0x1
_r3:
	.BYTE 0x1
_r4:
	.BYTE 0x1
_r5:
	.BYTE 0x1
_r6:
	.BYTE 0x1
_r7:
	.BYTE 0x1
_r8:
	.BYTE 0x1
_sensor:
	.BYTE 0x1
_lcd_buffer:
	.BYTE 0x21

	.ESEG
_Kp:
	.DB  0xA
_Ki:
	.DB  0x0
_Kd:
	.DB  0x5
_MAXSpeed:
	.DB  0xFF
_MINSpeed:
	.DB  0x0
_WarnaGaris:
	.DB  0x1
_SensLine:
	.DB  0x2
_Skenario:
	.DB  0x2

	.DSEG
_kursorPID:
	.BYTE 0x1
_kursorSpeed:
	.BYTE 0x1
_kursorGaris:
	.BYTE 0x1
_xcount:
	.BYTE 0x1
_lpwm:
	.BYTE 0x2
_rpwm:
	.BYTE 0x2
_MAXPWM:
	.BYTE 0x2
_MINPWM:
	.BYTE 0x2
_intervalPWM:
	.BYTE 0x2
_diffPWM:
	.BYTE 0x1
_MV:
	.BYTE 0x2
_P:
	.BYTE 0x2
_I:
	.BYTE 0x2
_D:
	.BYTE 0x2
_PV:
	.BYTE 0x2
_error:
	.BYTE 0x2
_last_error:
	.BYTE 0x2
_rate:
	.BYTE 0x2
_var_Kp:
	.BYTE 0x2
_var_Ki:
	.BYTE 0x2
_var_Kd:
	.BYTE 0x2
_SP:
	.BYTE 0x1
_hitungSiku:
	.BYTE 0x2
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
_p_S1040024:
	.BYTE 0x2
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	LDI  R31,0
	MOVW R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	CALL __DIVW21
	MOV  R17,R30
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,48
	MOV  R17,R30
	ST   -Y,R17
	CALL _lcd_putchar
	LDD  R26,Y+1
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDD  R30,Y+1
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x5:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x9:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(32)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xD:
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _tampil
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0xB

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	ST   -Y,R30
	CALL _setByte
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	LDS  R26,_xcount
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	CALL _lcd_clear
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x13:
	CALL __EEPROMRDB
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __lcd_ready

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x17:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xBB8
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSLW3:
	LSL  R30
	ROL  R31
__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
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

__MODW21:
	CLT
	SBRS R27,7
	RJMP __MODW211
	COM  R26
	COM  R27
	ADIW R26,1
	SET
__MODW211:
	SBRC R31,7
	RCALL __ANEGW1
	RCALL __DIVW21U
	MOVW R30,R26
	BRTC __MODW212
	RCALL __ANEGW1
__MODW212:
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

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
