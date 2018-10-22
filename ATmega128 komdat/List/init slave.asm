
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 11.059200 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 1024 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega128
	#pragma AVRPART MEMORY PROG_FLASH 131072
	#pragma AVRPART MEMORY EEPROM 4096
	#pragma AVRPART MEMORY INT_SRAM SIZE 4351
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

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
	.EQU RAMPZ=0x3B
	.EQU SPL=0x3D
	.EQU SPH=0x3E
	.EQU SREG=0x3F
	.EQU XMCRA=0x6D
	.EQU XMCRB=0x6C

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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x10FF
	.EQU __DSTACK_SIZE=0x0400
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
	.DEF _n_sampling=R5
	.DEF _count_int=R6
	.DEF _signal_gen_status=R4
	.DEF _rx_wr_index0=R9
	.DEF _rx_rd_index0=R8
	.DEF _rx_counter0=R11
	.DEF _tx_wr_index0=R10
	.DEF _tx_rd_index0=R13
	.DEF _tx_counter0=R12

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
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _timer3_ovf_isr
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  _usart1_tx_isr
	JMP  0x00
	JMP  0x00

_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x8B:
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x50,0x4F,0x52,0x54,0x20,0x4F,0x50,0x45
	.DB  0x4E,0x45,0x44,0x0,0x52,0x45,0x4D,0x4F
	.DB  0x54,0x45,0x2C,0x4A,0x54,0x46,0x2D,0x54
	.DB  0x45,0x4C,0x2C,0x4E,0x4F,0x52,0x4D,0x2D
	.DB  0x42,0x52,0x4F,0x41,0x44,0x43,0x41,0x53
	.DB  0x54,0x2C,0x0,0x21,0x0,0x50,0x4F,0x52
	.DB  0x54,0x20,0x43,0x4C,0x4F,0x53,0x45,0x44
	.DB  0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0C
	.DW  _0x28
	.DW  _0x0*2

	.DW  0x1F
	.DW  _0x28+12
	.DW  _0x0*2+12

	.DW  0x02
	.DW  _0x28+43
	.DW  _0x0*2+43

	.DW  0x0C
	.DW  _0x28+45
	.DW  _0x0*2+45

	.DW  0x04
	.DW  0x04
	.DW  _0x8B*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30

;INTERRUPT VECTORS ARE PLACED
;AT THE START OF FLASH
	LDI  R31,1
	OUT  MCUCR,R31
	OUT  MCUCR,R30
	STS  XMCRB,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

	OUT  RAMPZ,R24

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
	.ORG 0x500

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
;Date    : 9/30/2013
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega128
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 1024
;*****************************************************/
;
;#include <mega128.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdlib.h>
;#include <string.h>
;#include <math.h>
;
;#define SENSOR_0        0
;#define SENSOR_1        1
;#define SENSOR_2        2
;#define SENSOR_3        3
;#define SENSOR_4        4
;#define SENSOR_5        5
;#define SENSOR_EXP      6
;#define FSK_IN          7
;
;#define ADCMUX0         PORTA.3
;#define ADCMUX1         PORTA.4
;#define ADCMUX2         PORTA.5
;
;#define STATUS_0        PORTC.3
;#define STATUS_1        PORTC.2
;#define STATUS_2        PORTC.1
;#define STATUS_3        PORTC.0
;#define STATUS_4        PORTG.1
;#define STATUS_5        PORTG.0
;
;#define TXD_USART_0     PORTE.1
;#define RXD_USART_0     PINE.0
;
;#define PTT             PORTD.7
;#define TXD_USART_1     PORTD.3
;#define RXD_USART_1     PIND.2
;
;#define DEBUG_1         PIND.1
;#define DEBUG_2         PIND.0
;
;#define DAC_0           PORTE.4
;#define DAC_1           PORTE.5
;#define DAC_2           PORTE.6
;#define DAC_3           PORTE.7
;
;#define TONE_1200       1
;#define TONE_2400       0
;
;#define OK              1
;#define STOP            0
;
;#ifdef	_OPTIMIZE_SIZE_
;	#define CONST_1200      46
;	#define CONST_2200      25  // 22-25    22-->2400Hz   25-->2200Hz
;
;        // Konstanta untuk kompilasi dalam mode optimasi kecepatan
;#else
;	#define CONST_1200      50
;	#define CONST_2200      25
;#endif
;
;unsigned int read_adc(unsigned char adc_input);
;void init_port_all(void);
;void init_porta(void);
;void init_portc(void);
;void init_portd(void);
;void init_porte(void);
;void init_portf(void);
;void init_portg(void);
;void init_timer_0(void);
;void clr_timer_0(void);
;void init_timer_2(void);
;void clr_timer_2(void);
;void init_timer_3(void);
;void init_usart0_600(void);
;void clr_usart0(void);
;void init_usart1_600(void);
;void clr_usart1(void);
;void init_adc(void);
;void init_port_all(void);
;void baca_sensor(char number);
;void kirim_data(void);
;void kirim_word(unsigned int data);
;void kirim_karakter(unsigned char in_byte);
;void kirim_string(char *str);
;void set_dac(char value);
;
;eeprom unsigned int sensor[14];
;eeprom char jumlah_sensor = 14;
;flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
;flash char master = 1;
;char n_sampling = 0;
;bit nada = 0;
;unsigned int count_int = 0;
;char signal_gen_status = 0;
;bit kirim = 0;
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 8
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;        unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;#else
;        unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 00A6 {

	.CSEG
_usart0_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A7         char status,data;
; 0000 00A8         status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 00A9         data=UDR0;
	IN   R16,12
; 0000 00AA         if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 00AB         {
; 0000 00AC                 rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 00AD                 #if RX_BUFFER_SIZE0 == 256
; 0000 00AE                 // special case for receiver buffer size=256
; 0000 00AF                 if (++rx_counter0 == 0)
; 0000 00B0                 {
; 0000 00B1                 #else
; 0000 00B2                 if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x4
	CLR  R9
; 0000 00B3                 if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	INC  R11
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0x5
; 0000 00B4                 {
; 0000 00B5                         rx_counter0=0;
	CLR  R11
; 0000 00B6                 #endif
; 0000 00B7                         rx_buffer_overflow0=1;
	SET
	BLD  R2,2
; 0000 00B8                 }
; 0000 00B9         }
_0x5:
; 0000 00BA }
_0x3:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 00C1 {
; 0000 00C2         char data;
; 0000 00C3         while (rx_counter0==0);
;	data -> R17
; 0000 00C4         data=rx_buffer0[rx_rd_index0++];
; 0000 00C5         #if RX_BUFFER_SIZE0 != 256
; 0000 00C6         if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 00C7         #endif
; 0000 00C8         #asm("cli")
; 0000 00C9         --rx_counter0;
; 0000 00CA         #asm("sei")
; 0000 00CB         return data;
; 0000 00CC }
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 8
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;        unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
;#else
;        unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 00DC {
_usart0_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00DD         if (tx_counter0)
	TST  R12
	BREQ _0xA
; 0000 00DE         {
; 0000 00DF                 --tx_counter0;
	DEC  R12
; 0000 00E0                 UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R13
	INC  R13
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00E1                 #if TX_BUFFER_SIZE0 != 256
; 0000 00E2                 if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0xB
	CLR  R13
; 0000 00E3                 #endif
; 0000 00E4         }
_0xB:
; 0000 00E5 }
_0xA:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00EC {
_putchar:
; 0000 00ED         while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
_0xC:
	LDI  R30,LOW(8)
	CP   R30,R12
	BREQ _0xC
; 0000 00EE         #asm("cli")
	cli
; 0000 00EF         if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R12
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
; 0000 00F0         {
; 0000 00F1                 tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R10
	INC  R10
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00F2                 #if TX_BUFFER_SIZE0 != 256
; 0000 00F3                 if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R10
	BRNE _0x12
	CLR  R10
; 0000 00F4                 #endif
; 0000 00F5                 ++tx_counter0;
_0x12:
	INC  R12
; 0000 00F6         }
; 0000 00F7         else
	RJMP _0x13
_0xF:
; 0000 00F8                 UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00F9         #asm("sei")
_0x13:
	sei
; 0000 00FA }
	RJMP _0x20A0004
;#pragma used-
;#endif
;
;// USART1 Receiver buffer
;#define RX_BUFFER_SIZE1 8
;char rx_buffer1[RX_BUFFER_SIZE1];
;
;#if RX_BUFFER_SIZE1 <= 256
;unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
;#else
;unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
;#endif
;
;// This flag is set on USART1 Receiver buffer overflow
;bit rx_buffer_overflow1;
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 010D {
_usart1_rx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 010E         char status,data;
; 0000 010F         status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	LDS  R17,155
; 0000 0110         data=UDR1;
	LDS  R16,156
; 0000 0111         if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x14
; 0000 0112         {
; 0000 0113                 rx_buffer1[rx_wr_index1++]=data;
	LDS  R30,_rx_wr_index1
	SUBI R30,-LOW(1)
	STS  _rx_wr_index1,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 0114                 #if RX_BUFFER_SIZE1 == 256
; 0000 0115                 // special case for receiver buffer size=256
; 0000 0116                 if (++rx_counter1 == 0)
; 0000 0117                 {
; 0000 0118                 #else
; 0000 0119                 if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	LDS  R26,_rx_wr_index1
	CPI  R26,LOW(0x8)
	BRNE _0x15
	LDI  R30,LOW(0)
	STS  _rx_wr_index1,R30
; 0000 011A                 if (++rx_counter1 == RX_BUFFER_SIZE1)
_0x15:
	LDS  R26,_rx_counter1
	SUBI R26,-LOW(1)
	STS  _rx_counter1,R26
	CPI  R26,LOW(0x8)
	BRNE _0x16
; 0000 011B                 {
; 0000 011C                         rx_counter1=0;
	LDI  R30,LOW(0)
	STS  _rx_counter1,R30
; 0000 011D                 #endif
; 0000 011E                         rx_buffer_overflow1=1;
	SET
	BLD  R2,3
; 0000 011F                 }
; 0000 0120         }
_0x16:
; 0000 0121 }
_0x14:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;char getchar1(void)
; 0000 0126 {
; 0000 0127         char data;
; 0000 0128         while (rx_counter1==0);
;	data -> R17
; 0000 0129         data=rx_buffer1[rx_rd_index1++];
; 0000 012A         #if RX_BUFFER_SIZE1 != 256
; 0000 012B         if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
; 0000 012C         #endif
; 0000 012D         #asm("cli")
; 0000 012E         --rx_counter1;
; 0000 012F         #asm("sei")
; 0000 0130         return data;
; 0000 0131 }
;#pragma used-
;// USART1 Transmitter buffer
;#define TX_BUFFER_SIZE1 8
;char tx_buffer1[TX_BUFFER_SIZE1];
;
;#if TX_BUFFER_SIZE1 <= 256
;        unsigned char tx_wr_index1,tx_rd_index1,tx_counter1;
;#else
;        unsigned int tx_wr_index1,tx_rd_index1,tx_counter1;
;#endif
;
;// USART1 Transmitter interrupt service routine
;interrupt [USART1_TXC] void usart1_tx_isr(void)
; 0000 013F {
_usart1_tx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0140         if (tx_counter1)
	LDS  R30,_tx_counter1
	CPI  R30,0
	BREQ _0x1B
; 0000 0141         {
; 0000 0142                 --tx_counter1;
	SUBI R30,LOW(1)
	STS  _tx_counter1,R30
; 0000 0143                 UDR1=tx_buffer1[tx_rd_index1++];
	LDS  R30,_tx_rd_index1
	SUBI R30,-LOW(1)
	STS  _tx_rd_index1,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer1)
	SBCI R31,HIGH(-_tx_buffer1)
	LD   R30,Z
	STS  156,R30
; 0000 0144                 #if TX_BUFFER_SIZE1 != 256
; 0000 0145                 if (tx_rd_index1 == TX_BUFFER_SIZE1) tx_rd_index1=0;
	LDS  R26,_tx_rd_index1
	CPI  R26,LOW(0x8)
	BRNE _0x1C
	LDI  R30,LOW(0)
	STS  _tx_rd_index1,R30
; 0000 0146                 #endif
; 0000 0147         }
_0x1C:
; 0000 0148 }
_0x1B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;// Write a character to the USART1 Transmitter buffer
;#pragma used+
;void putchar1(char c)
; 0000 014D {
; 0000 014E         while (tx_counter1 == TX_BUFFER_SIZE1);
;	c -> Y+0
; 0000 014F         #asm("cli")
; 0000 0150         if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
; 0000 0151         {
; 0000 0152                 tx_buffer1[tx_wr_index1++]=c;
; 0000 0153                 #if TX_BUFFER_SIZE1 != 256
; 0000 0154                 if (tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
; 0000 0155                 #endif
; 0000 0156                 ++tx_counter1;
; 0000 0157         }
; 0000 0158         else
; 0000 0159         UDR1=c;
; 0000 015A         #asm("sei")
; 0000 015B }
;#pragma used-
;
;// Standard Input/Output functions
;#include <stdio.h>
;unsigned int ttt = 0;
;unsigned int rrr = 0;
;
;unsigned int adc_buff = 0;
;bit pancar = 0;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0167 {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0168         TCNT0=0xF7;
	LDI  R30,LOW(247)
	OUT  0x32,R30
; 0000 0169 
; 0000 016A         ttt++;
	LDI  R26,LOW(_ttt)
	LDI  R27,HIGH(_ttt)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 016B 
; 0000 016C         /*if(kirim == OK)
; 0000 016D         {
; 0000 016E                 if(nada == TONE_1200)
; 0000 016F                 {
; 0000 0170                         if((count_int % 2) == 0)
; 0000 0171                         {
; 0000 0172                                 set_dac(matrix[n_sampling]);
; 0000 0173                                 n_sampling++;
; 0000 0174                         }
; 0000 0175 
; 0000 0176                         count_int++;
; 0000 0177 
; 0000 0178                         if(n_sampling == 16)
; 0000 0179                         {
; 0000 017A                                 n_sampling = 0;
; 0000 017B                                 count_int = 0;
; 0000 017C                                 signal_gen_status++;
; 0000 017D                         }
; 0000 017E                 }
; 0000 017F 
; 0000 0180                 else
; 0000 0181                 {
; 0000 0182                         set_dac(matrix[n_sampling]);
; 0000 0183                         n_sampling++;
; 0000 0184 
; 0000 0185                         count_int++;
; 0000 0186 
; 0000 0187                         if(n_sampling == 16)
; 0000 0188                         {
; 0000 0189                                 n_sampling = 0;
; 0000 018A                                 count_int = 0;
; 0000 018B                                 signal_gen_status++;
; 0000 018C                         }
; 0000 018D                 }
; 0000 018E         } */
; 0000 018F }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;unsigned int in_afsk = 0;
;bit raw = 0;
;bit d1_raw = 0;
;bit d2_raw = 0;
;bit out_bit_fsk = 0;
;unsigned char out_byte = 0;
;unsigned int sum_adc = 0;
;unsigned int t2_ovf_int = 0;
;
;#define DETECTED        1
;#define LOST            0
;char bit_count = 0;
;char flag = 0;
;
;// Timer2 overflow interrupt service routine
;/*interrupt [TIM2_OVF] void timer2_ovf_isr(void)
;{
;        // Place your code here
;        //TCNT2=0xEE;     // Fsampling = 600Hz
;
;} */
;
;// Timer3 overflow interrupt service routine
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0000 01A9 {
_timer3_ovf_isr:
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
; 0000 01AA         // Place your code here
; 0000 01AB         char x;
; 0000 01AC 
; 0000 01AD         //clr_timer_2();
; 0000 01AE 
; 0000 01AF         baca_sensor(jumlah_sensor);
	ST   -Y,R17
;	x -> R17
	LDI  R26,LOW(_jumlah_sensor)
	LDI  R27,HIGH(_jumlah_sensor)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _baca_sensor
; 0000 01B0 
; 0000 01B1         //init_timer_0();
; 0000 01B2 
; 0000 01B3         if(master)
; 0000 01B4         {
; 0000 01B5 
; 0000 01B6                 PTT = 1;
	SBI  0x12,7
; 0000 01B7 
; 0000 01B8                 init_usart0_600();
	RCALL _init_usart0_600
; 0000 01B9                 //init_usart1_600();
; 0000 01BA 
; 0000 01BB                 puts("PORT OPENED");
	__POINTW1MN _0x28,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
; 0000 01BC                 putchar(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _putchar
; 0000 01BD 
; 0000 01BE                 clr_usart0();
	RCALL _clr_usart0
; 0000 01BF                 //clr_usart1();
; 0000 01C0 
; 0000 01C1                 TXD_USART_0 = 1;
	SBI  0x3,1
; 0000 01C2 
; 0000 01C3                 for(x=0;x<30;x++)       kirim_karakter('$');
	LDI  R17,LOW(0)
_0x2C:
	CPI  R17,30
	BRSH _0x2D
	LDI  R30,LOW(36)
	ST   -Y,R30
	RCALL _kirim_karakter
	SUBI R17,-1
	RJMP _0x2C
_0x2D:
; 0000 01C4 kirim_string("REMOTE,JTF-TEL,NORM-BROADCAST,");
	__POINTW1MN _0x28,12
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_string
; 0000 01C5                 kirim_data();
	RCALL _kirim_data
; 0000 01C6                 kirim_string("!");
	__POINTW1MN _0x28,43
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_string
; 0000 01C7                 for(x=0;x<30;x++)       kirim_karakter('*');
	LDI  R17,LOW(0)
_0x2F:
	CPI  R17,30
	BRSH _0x30
	LDI  R30,LOW(42)
	ST   -Y,R30
	RCALL _kirim_karakter
	SUBI R17,-1
	RJMP _0x2F
_0x30:
; 0000 01C8 kirim_karakter(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 01C9 
; 0000 01CA                 TXD_USART_0 = 1;
	SBI  0x3,1
; 0000 01CB 
; 0000 01CC                 init_usart0_600();
	RCALL _init_usart0_600
; 0000 01CD                 //init_usart1_600();
; 0000 01CE 
; 0000 01CF                 putchar(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _putchar
; 0000 01D0                 puts("PORT CLOSED");
	__POINTW1MN _0x28,45
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
; 0000 01D1                 putchar(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _putchar
; 0000 01D2                 putchar(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _putchar
; 0000 01D3 
; 0000 01D4                 clr_usart0();
	RCALL _clr_usart0
; 0000 01D5                 //clr_usart1();
; 0000 01D6 
; 0000 01D7                 PTT = 0;
	CBI  0x12,7
; 0000 01D8 
; 0000 01D9         }
; 0000 01DA 
; 0000 01DB         //clr_timer_0();
; 0000 01DC 
; 0000 01DD         flag = LOST;
	LDI  R30,LOW(0)
	STS  _flag,R30
; 0000 01DE         bit_count = 0;
	STS  _bit_count,R30
; 0000 01DF 
; 0000 01E0         init_usart0_600();
	RCALL _init_usart0_600
; 0000 01E1         init_usart1_600();
	RCALL _init_usart1_600
; 0000 01E2 
; 0000 01E3         //init_timer_2();
; 0000 01E4 
; 0000 01E5         TCNT3H = (11536 >> 8) & 0xFF;
	LDI  R30,LOW(45)
	STS  137,R30
; 0000 01E6         TCNT3L = 11536 & 0xFF;
	LDI  R30,LOW(16)
	STS  136,R30
; 0000 01E7 }
	LD   R17,Y+
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

	.DSEG
_0x28:
	.BYTE 0x39
;
;#define ADC_VREF_TYPE 0x00
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 01ED {

	.CSEG
_read_adc:
; 0000 01EE         ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 01EF         // Delay needed for the stabilization of the ADC input voltage
; 0000 01F0         delay_us(10);
	__DELAY_USB 37
; 0000 01F1         // Start the AD conversion
; 0000 01F2         ADCSRA|=0x40;
	SBI  0x6,6
; 0000 01F3         // Wait for the AD conversion to complete
; 0000 01F4         while ((ADCSRA & 0x10)==0);
_0x35:
	SBIS 0x6,4
	RJMP _0x35
; 0000 01F5         ADCSRA|=0x10;
	SBI  0x6,4
; 0000 01F6         return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x20A0004:
	ADIW R28,1
	RET
; 0000 01F7 }
;
;// Declare your global variables here
;
;void init_porta(void)
; 0000 01FC {
_init_porta:
; 0000 01FD         PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01FE         DDRA=0x38;
	LDI  R30,LOW(56)
	OUT  0x1A,R30
; 0000 01FF }
	RET
;
;void init_portc(void)
; 0000 0202 {
_init_portc:
; 0000 0203         PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0204         DDRC=0x0F;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 0205 }
	RET
;
;void init_portd(void)
; 0000 0208 {
_init_portd:
; 0000 0209         PORTD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 020A         DDRD=0x88;
	LDI  R30,LOW(136)
	OUT  0x11,R30
; 0000 020B }
	RET
;
;void init_porte(void)
; 0000 020E {
_init_porte:
; 0000 020F         PORTE=0x03;
	LDI  R30,LOW(3)
	OUT  0x3,R30
; 0000 0210         DDRE=0xF2;
	LDI  R30,LOW(242)
	OUT  0x2,R30
; 0000 0211 }
	RET
;
;void init_portf(void)
; 0000 0214 {
_init_portf:
; 0000 0215         PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 0216         DDRF=0x00;
	STS  97,R30
; 0000 0217 }
	RET
;
;void init_portg(void)
; 0000 021A {
_init_portg:
; 0000 021B         PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 021C         DDRG=0x03;
	LDI  R30,LOW(3)
	STS  100,R30
; 0000 021D }
	RET
;
;void init_timer_0(void)
; 0000 0220 {
; 0000 0221         TCCR0=0x03;
; 0000 0222         TCNT0=0xF7;
; 0000 0223 
; 0000 0224         TIMSK=0x01;
; 0000 0225         ETIMSK=0x04;
; 0000 0226 }
;
;void clr_timer_0(void)
; 0000 0229 {
_clr_timer_0:
; 0000 022A         TCCR0=0;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 022B         TCNT0=0;
	OUT  0x32,R30
; 0000 022C 
; 0000 022D         TIMSK=0x00;
	RJMP _0x20A0003
; 0000 022E         ETIMSK=0x04;
; 0000 022F }
;
;void init_timer_2(void)
; 0000 0232 {
; 0000 0233         TCCR2=0x05;
; 0000 0234         TCNT2=0xEE;
; 0000 0235 
; 0000 0236         TIMSK=0x40;
; 0000 0237         ETIMSK=0x04;
; 0000 0238 }
;
;void clr_timer_2(void)
; 0000 023B {
_clr_timer_2:
; 0000 023C         TCCR2=0;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 023D         TCNT2=0;
	OUT  0x24,R30
; 0000 023E 
; 0000 023F         TIMSK=0x00;
_0x20A0003:
	LDI  R30,LOW(0)
	OUT  0x37,R30
; 0000 0240         ETIMSK=0x04;
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 0241 }
	RET
;
;void init_timer_3(void)
; 0000 0244 {
; 0000 0245         TCCR3A=0x00;
; 0000 0246         TCCR3B=0x05;
; 0000 0247         TCNT3H = (11536 >> 8) & 0xFF;
; 0000 0248         TCNT3L = 11536 & 0xFF;
; 0000 0249 }
;
;void init_usart0_600(void)
; 0000 024C {
_init_usart0_600:
; 0000 024D         UCSR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 024E         UCSR0B=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 024F         UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 0250         UBRR0H=0x04;
	LDI  R30,LOW(4)
	STS  144,R30
; 0000 0251         UBRR0L=0x7F;
	LDI  R30,LOW(127)
	RJMP _0x20A0002
; 0000 0252 }
;
;void clr_usart0(void)
; 0000 0255 {
_clr_usart0:
; 0000 0256         UCSR0A=0;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0257         UCSR0B=0;
	OUT  0xA,R30
; 0000 0258         UCSR0C=0;
	STS  149,R30
; 0000 0259         UBRR0H=0;
	STS  144,R30
; 0000 025A         UBRR0L=0;
_0x20A0002:
	OUT  0x9,R30
; 0000 025B }
	RET
;
;void init_usart1_600(void)
; 0000 025E {
_init_usart1_600:
; 0000 025F         UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 0260         UCSR1B=0xD8;
	LDI  R30,LOW(216)
	STS  154,R30
; 0000 0261         UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 0262         UBRR1H=0x04;
	LDI  R30,LOW(4)
	STS  152,R30
; 0000 0263         UBRR1L=0x7F;
	LDI  R30,LOW(127)
	STS  153,R30
; 0000 0264 }
	RET
;
;void clr_usart1(void)
; 0000 0267 {
; 0000 0268         UCSR1A=0;
; 0000 0269         UCSR1B=0;
; 0000 026A         UCSR1C=0;
; 0000 026B         UBRR1H=0;
; 0000 026C         UBRR1L=0;
; 0000 026D }
;
;void init_adc(void)
; 0000 0270 {
_init_adc:
; 0000 0271         ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 0272         ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0273 }
	RET
;
;void baca_sensor(char number)
; 0000 0276 {
_baca_sensor:
; 0000 0277         char i;
; 0000 0278 
; 0000 0279         for(i=0;i<number;i++)
	ST   -Y,R17
;	number -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x39:
	LDD  R30,Y+1
	CP   R17,R30
	BRLO PC+3
	JMP _0x3A
; 0000 027A         {
; 0000 027B                 if(i<6)
	CPI  R17,6
	BRSH _0x3B
; 0000 027C                 {
; 0000 027D                         sensor[i] = read_adc(i);
	MOV  R30,R17
	LDI  R26,LOW(_sensor)
	LDI  R27,HIGH(_sensor)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	ST   -Y,R17
	RCALL _read_adc
	POP  R26
	POP  R27
	CALL __EEPROMWRW
; 0000 027E                 }
; 0000 027F                 else
	RJMP _0x3C
_0x3B:
; 0000 0280                 {
; 0000 0281                         ADCMUX0 = (i - 6) & 0x01;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,6
	ANDI R30,LOW(0x1)
	BRNE _0x3D
	CBI  0x1B,3
	RJMP _0x3E
_0x3D:
	SBI  0x1B,3
_0x3E:
; 0000 0282                         ADCMUX1 = ((i - 6) >> 1) & 0x01;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,6
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x3F
	CBI  0x1B,4
	RJMP _0x40
_0x3F:
	SBI  0x1B,4
_0x40:
; 0000 0283                         ADCMUX2 = ((i - 6) >> 2) & 0x01;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,6
	CALL __ASRW2
	ANDI R30,LOW(0x1)
	BRNE _0x41
	CBI  0x1B,5
	RJMP _0x42
_0x41:
	SBI  0x1B,5
_0x42:
; 0000 0284 
; 0000 0285                         delay_us(2);
	__DELAY_USB 7
; 0000 0286 
; 0000 0287                         sensor[i] = read_adc(SENSOR_EXP);
	MOV  R30,R17
	LDI  R26,LOW(_sensor)
	LDI  R27,HIGH(_sensor)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	CALL __EEPROMWRW
; 0000 0288 
; 0000 0289                         ADCMUX0 = 0;
	CBI  0x1B,3
; 0000 028A                         ADCMUX1 = 0;
	CBI  0x1B,4
; 0000 028B                         ADCMUX2 = 0;
	CBI  0x1B,5
; 0000 028C                 }
_0x3C:
; 0000 028D         }
	SUBI R17,-1
	RJMP _0x39
_0x3A:
; 0000 028E }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void kirim_data(void)
; 0000 0291 {
_kirim_data:
; 0000 0292         char i;
; 0000 0293 
; 0000 0294         for(i=0;i<jumlah_sensor;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x4A:
	LDI  R26,LOW(_jumlah_sensor)
	LDI  R27,HIGH(_jumlah_sensor)
	CALL __EEPROMRDB
	CP   R17,R30
	BRSH _0x4B
; 0000 0295         {
; 0000 0296                 kirim_word(sensor[i]);
	MOV  R30,R17
	LDI  R26,LOW(_sensor)
	LDI  R27,HIGH(_sensor)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_word
; 0000 0297                 kirim_karakter(',');
	LDI  R30,LOW(44)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 0298         }
	SUBI R17,-1
	RJMP _0x4A
_0x4B:
; 0000 0299 }
	LD   R17,Y+
	RET
;
;void kirim_word(unsigned int data)
; 0000 029C {
_kirim_word:
; 0000 029D         char rib;
; 0000 029E         char rat;
; 0000 029F         char pul;
; 0000 02A0         char sat;
; 0000 02A1 
; 0000 02A2         rib = data / 1000;
	CALL __SAVELOCR4
;	data -> Y+4
;	rib -> R17
;	rat -> R16
;	pul -> R19
;	sat -> R18
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21U
	MOV  R17,R30
; 0000 02A3         data = data % 1000;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21U
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 02A4 
; 0000 02A5         rat = data / 100;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	MOV  R16,R30
; 0000 02A6         data = data % 100;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21U
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 02A7 
; 0000 02A8         pul = data / 10;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21U
	MOV  R19,R30
; 0000 02A9 
; 0000 02AA         sat = data % 10;
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21U
	MOV  R18,R30
; 0000 02AB 
; 0000 02AC         kirim_karakter((rib + '1')-1);
	MOV  R30,R17
	LDI  R31,0
	ADIW R30,49
	SBIW R30,1
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 02AD         kirim_karakter((rat + '1')-1);
	MOV  R30,R16
	LDI  R31,0
	ADIW R30,49
	SBIW R30,1
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 02AE         kirim_karakter((pul + '1')-1);
	MOV  R30,R19
	LDI  R31,0
	ADIW R30,49
	SBIW R30,1
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 02AF         kirim_karakter((sat + '1')-1);
	MOV  R30,R18
	LDI  R31,0
	ADIW R30,49
	SBIW R30,1
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 02B0 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;void kirim_karakter(unsigned char in_byte)
; 0000 02B3 {
_kirim_karakter:
	PUSH R15
; 0000 02B4         char i;
; 0000 02B5         bit in_bit;
; 0000 02B6 
; 0000 02B7         /*TXD_USART_0 = 1;
; 0000 02B8         kirim = OK;
; 0000 02B9 
; 0000 02BA         while(signal_gen_status < 4)
; 0000 02BB         {
; 0000 02BC                 nada = TONE_2400;
; 0000 02BD                 TXD_USART_0 = 0;
; 0000 02BE         }
; 0000 02BF 
; 0000 02C0         signal_gen_status = 0;
; 0000 02C1 
; 0000 02C2         for(i=0;i<8;i++)
; 0000 02C3         {
; 0000 02C4                 in_bit = in_byte & 0x01;
; 0000 02C5                 TXD_USART_0 = in_bit;
; 0000 02C6 
; 0000 02C7                 if(in_bit)
; 0000 02C8                 {
; 0000 02C9                         while(signal_gen_status < 2)
; 0000 02CA                         {
; 0000 02CB                                 nada = TONE_1200;
; 0000 02CC                         }
; 0000 02CD                 }
; 0000 02CE                 else if(!in_bit)
; 0000 02CF                 {
; 0000 02D0                         while(signal_gen_status < 4)
; 0000 02D1                         {
; 0000 02D2                                 nada = TONE_2400;
; 0000 02D3                         }
; 0000 02D4                 }
; 0000 02D5                 signal_gen_status = 0;
; 0000 02D6 
; 0000 02D7                 in_byte = in_byte >> 1;
; 0000 02D8         }
; 0000 02D9 
; 0000 02DA         while(signal_gen_status < 2)
; 0000 02DB         {
; 0000 02DC                 nada = TONE_1200;
; 0000 02DD                 TXD_USART_0 = 1;
; 0000 02DE         }
; 0000 02DF 
; 0000 02E0         kirim = STOP;
; 0000 02E1         signal_gen_status = 0;
; 0000 02E2         TXD_USART_0 = 1;
; 0000 02E3         in_byte = 0;  */
; 0000 02E4 
; 0000 02E5         TXD_USART_0 = 0;
	ST   -Y,R17
;	in_byte -> Y+1
;	i -> R17
;	in_bit -> R15.0
	CBI  0x3,1
; 0000 02E6         DAC_0 = 0;
	CBI  0x3,4
; 0000 02E7         DAC_1 = 0;
	CBI  0x3,5
; 0000 02E8         DAC_2 = 0;
	CBI  0x3,6
; 0000 02E9         DAC_3 = 0;
	CBI  0x3,7
; 0000 02EA         ttt = 0;
	LDI  R30,LOW(0)
	STS  _ttt,R30
	STS  _ttt+1,R30
; 0000 02EB         while(ttt < 64);
_0x56:
	LDS  R26,_ttt
	LDS  R27,_ttt+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLO _0x56
; 0000 02EC 
; 0000 02ED         for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x5A:
	CPI  R17,8
	BRSH _0x5B
; 0000 02EE         {
; 0000 02EF                 in_bit = in_byte & 0x01;
	LDD  R30,Y+1
	BST  R30,0
	BLD  R15,0
; 0000 02F0                 TXD_USART_0 = in_bit;
	SBRC R15,0
	RJMP _0x5C
	CBI  0x3,1
	RJMP _0x5D
_0x5C:
	SBI  0x3,1
_0x5D:
; 0000 02F1                 DAC_0 = in_bit;
	SBRC R15,0
	RJMP _0x5E
	CBI  0x3,4
	RJMP _0x5F
_0x5E:
	SBI  0x3,4
_0x5F:
; 0000 02F2                 DAC_1 = in_bit;
	SBRC R15,0
	RJMP _0x60
	CBI  0x3,5
	RJMP _0x61
_0x60:
	SBI  0x3,5
_0x61:
; 0000 02F3                 DAC_2 = in_bit;
	SBRC R15,0
	RJMP _0x62
	CBI  0x3,6
	RJMP _0x63
_0x62:
	SBI  0x3,6
_0x63:
; 0000 02F4                 DAC_3 = in_bit;
	SBRC R15,0
	RJMP _0x64
	CBI  0x3,7
	RJMP _0x65
_0x64:
	SBI  0x3,7
_0x65:
; 0000 02F5                 ttt = 0;
	LDI  R30,LOW(0)
	STS  _ttt,R30
	STS  _ttt+1,R30
; 0000 02F6                 while(ttt < 64);
_0x66:
	LDS  R26,_ttt
	LDS  R27,_ttt+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLO _0x66
; 0000 02F7                 in_byte >>= 1;
	LDD  R30,Y+1
	LDI  R31,0
	ASR  R31
	ROR  R30
	STD  Y+1,R30
; 0000 02F8         }
	SUBI R17,-1
	RJMP _0x5A
_0x5B:
; 0000 02F9 
; 0000 02FA         TXD_USART_0 = 1;
	SBI  0x3,1
; 0000 02FB         DAC_0 = 1;
	SBI  0x3,4
; 0000 02FC         DAC_1 = 1;
	SBI  0x3,5
; 0000 02FD         DAC_2 = 1;
	SBI  0x3,6
; 0000 02FE         DAC_3 = 1;
	SBI  0x3,7
; 0000 02FF         ttt = 0;
	LDI  R30,LOW(0)
	STS  _ttt,R30
	STS  _ttt+1,R30
; 0000 0300         while(ttt < 64);
_0x73:
	LDS  R26,_ttt
	LDS  R27,_ttt+1
	CPI  R26,LOW(0x40)
	LDI  R30,HIGH(0x40)
	CPC  R27,R30
	BRLO _0x73
; 0000 0301 }
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;void kirim_string(char *str)
; 0000 0304 {
_kirim_string:
; 0000 0305         char k;
; 0000 0306         while (k=*str++) kirim_karakter(k);
	ST   -Y,R17
;	*str -> Y+1
;	k -> R17
_0x76:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x78
	ST   -Y,R17
	RCALL _kirim_karakter
	RJMP _0x76
_0x78:
; 0000 0307 kirim_karakter(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 0308 }
	RJMP _0x20A0001
;
;void set_dac(char value)
; 0000 030B {
; 0000 030C         DAC_0 = value & 0x01;
;	value -> Y+0
; 0000 030D         DAC_1 =( value >> 1 ) & 0x01;
; 0000 030E         DAC_2 =( value >> 2 ) & 0x01;
; 0000 030F         DAC_3 =( value >> 3 ) & 0x01;
; 0000 0310 }
;
;void init_port_all(void)
; 0000 0313 {
_init_port_all:
; 0000 0314         init_porta();
	RCALL _init_porta
; 0000 0315         init_portc();
	RCALL _init_portc
; 0000 0316         init_portd();
	RCALL _init_portd
; 0000 0317         init_porte();
	RCALL _init_porte
; 0000 0318         init_portf();
	RCALL _init_portf
; 0000 0319         init_portg();
	RCALL _init_portg
; 0000 031A }
	RET
;
;void decode_data(void)
; 0000 031D {
; 0000 031E 
; 0000 031F }
;
;void main(void)
; 0000 0322 {
_main:
; 0000 0323         init_port_all();
	RCALL _init_port_all
; 0000 0324         clr_timer_0();
	RCALL _clr_timer_0
; 0000 0325         clr_timer_2();
	RCALL _clr_timer_2
; 0000 0326         //init_timer_0();
; 0000 0327         //init_timer_2();
; 0000 0328         //init_timer_3();
; 0000 0329         //init_usart0_600();
; 0000 032A         //init_usart1_600();
; 0000 032B         init_adc();
	RCALL _init_adc
; 0000 032C 
; 0000 032D         TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x37,R30
; 0000 032E         ETIMSK=0x04;
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 032F         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0330         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0331 
; 0000 0332         //#asm("sei")
; 0000 0333 
; 0000 0334         while (1)
_0x81:
; 0000 0335         {
; 0000 0336                 adc_buff = read_adc(FSK_IN);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	STS  _adc_buff,R30
	STS  _adc_buff+1,R31
; 0000 0337                 if(adc_buff > 50)       TXD_USART_0 = 1;
	LDS  R26,_adc_buff
	LDS  R27,_adc_buff+1
	SBIW R26,51
	BRLO _0x84
	SBI  0x3,1
; 0000 0338                 else                    TXD_USART_0 = 0;
	RJMP _0x87
_0x84:
	CBI  0x3,1
; 0000 0339         }
_0x87:
	RJMP _0x81
; 0000 033A }
_0x8A:
	RJMP _0x8A

	.CSEG

	.DSEG

	.CSEG

	.CSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x1C
	.EQU __sm_powerdown=0x10
	.EQU __sm_powersave=0x18
	.EQU __sm_standby=0x14
	.EQU __sm_ext_standby=0x1C
	.EQU __sm_adc_noise_red=0x08
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_puts:
	ST   -Y,R17
_0x2060003:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060005
	ST   -Y,R17
	CALL _putchar
	RJMP _0x2060003
_0x2060005:
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _putchar
_0x20A0001:
	LDD  R17,Y+0
	ADIW R28,3
	RET

	.CSEG

	.ESEG
_sensor:
	.BYTE 0x1C
_jumlah_sensor:
	.DB  0xE

	.DSEG
_rx_buffer0:
	.BYTE 0x8
_tx_buffer0:
	.BYTE 0x8
_rx_buffer1:
	.BYTE 0x8
_rx_wr_index1:
	.BYTE 0x1
_rx_rd_index1:
	.BYTE 0x1
_rx_counter1:
	.BYTE 0x1
_tx_buffer1:
	.BYTE 0x8
_tx_wr_index1:
	.BYTE 0x1
_tx_rd_index1:
	.BYTE 0x1
_tx_counter1:
	.BYTE 0x1
_ttt:
	.BYTE 0x2
_adc_buff:
	.BYTE 0x2
_bit_count:
	.BYTE 0x1
_flag:
	.BYTE 0x1
__seed_G100:
	.BYTE 0x4

	.CSEG

	.CSEG
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
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

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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
