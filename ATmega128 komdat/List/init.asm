
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
	.DEF _rx_rd_index0=R5
	.DEF _rx_counter0=R4
	.DEF _tx_wr_index0=R7
	.DEF _tx_counter0=R6
	.DEF _rx_rd_index1=R9
	.DEF _rx_counter1=R8
	.DEF _tx_wr_index1=R11
	.DEF _tx_counter1=R10
	.DEF _ttt=R12

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
	JMP  _timer3_ovf_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
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

_0x80:
	.DB  0x0,0x0
_0x0:
	.DB  0x42,0x41,0x53,0x45,0x2C,0x4A,0x54,0x46
	.DB  0x2D,0x54,0x45,0x4C,0x2C,0x41,0x53,0x4B
	.DB  0x2D,0x53,0x54,0x41,0x54,0x55,0x53,0x2C
	.DB  0x0,0x21,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x19
	.DW  _0x23
	.DW  _0x0*2

	.DW  0x02
	.DW  _0x23+25
	.DW  _0x0*2+25

	.DW  0x02
	.DW  0x0C
	.DW  _0x80*2

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
;void init_timer_3(void);
;void init_usart0_600(void);
;void clr_usart0(void);
;void init_usart1_600(void);
;void init_adc(void);
;void init_port_all(void);
;void baca_sensor(char number);
;void kirim_data(void);
;void kirim_word(unsigned int data);
;void kirim_karakter(unsigned char in_byte);
;void kirim_string(char *str);
;
;eeprom unsigned int sensor[14];
;eeprom char jumlah_sensor = 14;
;flash char master = 1;
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
;        unsigned char rx_rd_index0,rx_counter0;
;#else
;        unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 009E {

	.CSEG
; 0000 009F         char data;
; 0000 00A0         while (rx_counter0==0);
;	data -> R17
; 0000 00A1         data=rx_buffer0[rx_rd_index0++];
; 0000 00A2         #if RX_BUFFER_SIZE0 != 256
; 0000 00A3         if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
; 0000 00A4         #endif
; 0000 00A5         #asm("cli")
; 0000 00A6         --rx_counter0;
; 0000 00A7         #asm("sei")
; 0000 00A8         return data;
; 0000 00A9 }
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 8
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;        unsigned char tx_wr_index0,tx_counter0;
;#else
;        unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00BD {
_putchar:
; 0000 00BE         while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
_0x7:
	LDI  R30,LOW(8)
	CP   R30,R6
	BREQ _0x7
; 0000 00BF         #asm("cli")
	cli
; 0000 00C0         if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R6
	BRNE _0xB
	SBIC 0xB,5
	RJMP _0xA
_0xB:
; 0000 00C1         {
; 0000 00C2                 tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R7
	INC  R7
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00C3                 #if TX_BUFFER_SIZE0 != 256
; 0000 00C4                 if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0xD
	CLR  R7
; 0000 00C5                 #endif
; 0000 00C6                 ++tx_counter0;
_0xD:
	INC  R6
; 0000 00C7         }
; 0000 00C8         else
	RJMP _0xE
_0xA:
; 0000 00C9                 UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00CA         #asm("sei")
_0xE:
	sei
; 0000 00CB }
	RJMP _0x20A0004
;#pragma used-
;#endif
;
;// USART1 Receiver buffer
;#define RX_BUFFER_SIZE1 8
;char rx_buffer1[RX_BUFFER_SIZE1];
;
;#if RX_BUFFER_SIZE1 <= 256
;unsigned char rx_rd_index1,rx_counter1;
;#else
;unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
;#endif
;
;// This flag is set on USART1 Receiver buffer overflow
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;char getchar1(void)
; 0000 00DD {
; 0000 00DE         char data;
; 0000 00DF         while (rx_counter1==0);
;	data -> R17
; 0000 00E0         data=rx_buffer1[rx_rd_index1++];
; 0000 00E1         #if RX_BUFFER_SIZE1 != 256
; 0000 00E2         if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
; 0000 00E3         #endif
; 0000 00E4         #asm("cli")
; 0000 00E5         --rx_counter1;
; 0000 00E6         #asm("sei")
; 0000 00E7         return data;
; 0000 00E8 }
;#pragma used-
;// USART1 Transmitter buffer
;#define TX_BUFFER_SIZE1 8
;char tx_buffer1[TX_BUFFER_SIZE1];
;
;#if TX_BUFFER_SIZE1 <= 256
;        unsigned char tx_wr_index1,tx_counter1;
;#else
;        unsigned int tx_wr_index1,tx_rd_index1,tx_counter1;
;#endif
;
;// Write a character to the USART1 Transmitter buffer
;#pragma used+
;void putchar1(char c)
; 0000 00F7 {
; 0000 00F8         while (tx_counter1 == TX_BUFFER_SIZE1);
;	c -> Y+0
; 0000 00F9         #asm("cli")
; 0000 00FA         if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
; 0000 00FB         {
; 0000 00FC                 tx_buffer1[tx_wr_index1++]=c;
; 0000 00FD                 #if TX_BUFFER_SIZE1 != 256
; 0000 00FE                 if (tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
; 0000 00FF                 #endif
; 0000 0100                 ++tx_counter1;
; 0000 0101         }
; 0000 0102         else
; 0000 0103         UDR1=c;
; 0000 0104         #asm("sei")
; 0000 0105 }
;#pragma used-
;
;// Standard Input/Output functions
;#include <stdio.h>
;unsigned int ttt = 0;
;
;unsigned int adc_buff = 0;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 010F {
_timer0_ovf_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0110         TCNT0=0xF7;
	LDI  R30,LOW(247)
	OUT  0x32,R30
; 0000 0111 
; 0000 0112         ttt++;
	MOVW R30,R12
	ADIW R30,1
	MOVW R12,R30
; 0000 0113 
; 0000 0114         /*if(kirim == OK)
; 0000 0115         {
; 0000 0116                 if(nada == TONE_1200)
; 0000 0117                 {
; 0000 0118                         if((count_int % 2) == 0)
; 0000 0119                         {
; 0000 011A                                 set_dac(matrix[n_sampling]);
; 0000 011B                                 n_sampling++;
; 0000 011C                         }
; 0000 011D 
; 0000 011E                         count_int++;
; 0000 011F 
; 0000 0120                         if(n_sampling == 16)
; 0000 0121                         {
; 0000 0122                                 n_sampling = 0;
; 0000 0123                                 count_int = 0;
; 0000 0124                                 signal_gen_status++;
; 0000 0125                         }
; 0000 0126                 }
; 0000 0127 
; 0000 0128                 else
; 0000 0129                 {
; 0000 012A                         set_dac(matrix[n_sampling]);
; 0000 012B                         n_sampling++;
; 0000 012C 
; 0000 012D                         count_int++;
; 0000 012E 
; 0000 012F                         if(n_sampling == 16)
; 0000 0130                         {
; 0000 0131                                 n_sampling = 0;
; 0000 0132                                 count_int = 0;
; 0000 0133                                 signal_gen_status++;
; 0000 0134                         }
; 0000 0135                 }
; 0000 0136         } */
; 0000 0137 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;
;#define DETECTED        1
;#define LOST            0
;char bit_count = 0;
;char flag = 0;
;
;// Timer3 overflow interrupt service routine
;interrupt [TIM3_OVF] void timer3_ovf_isr(void)
; 0000 0141 {
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
; 0000 0142         // Place your code here
; 0000 0143         char x;
; 0000 0144 
; 0000 0145         baca_sensor(jumlah_sensor);
	ST   -Y,R17
;	x -> R17
	LDI  R26,LOW(_jumlah_sensor)
	LDI  R27,HIGH(_jumlah_sensor)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _baca_sensor
; 0000 0146 
; 0000 0147         init_timer_0();
	RCALL _init_timer_0
; 0000 0148 
; 0000 0149         if(master)
; 0000 014A         {
; 0000 014B 
; 0000 014C                 PTT = 1;
	SBI  0x12,7
; 0000 014D 
; 0000 014E                 init_usart0_600();
	RCALL _init_usart0_600
; 0000 014F                 putchar(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _putchar
; 0000 0150                 clr_usart0();
	RCALL _clr_usart0
; 0000 0151 
; 0000 0152                 TXD_USART_0 = 1;
	SBI  0x3,1
; 0000 0153 
; 0000 0154                 for(x=0;x<30;x++)       kirim_karakter('$');
	LDI  R17,LOW(0)
_0x21:
	CPI  R17,30
	BRSH _0x22
	LDI  R30,LOW(36)
	ST   -Y,R30
	RCALL _kirim_karakter
	SUBI R17,-1
	RJMP _0x21
_0x22:
; 0000 0155 kirim_string("BASE,JTF-TEL,ASK-STATUS,");
	__POINTW1MN _0x23,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_string
; 0000 0156                 //kirim_data();
; 0000 0157                 kirim_string("!");
	__POINTW1MN _0x23,25
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_string
; 0000 0158                 for(x=0;x<30;x++)       kirim_karakter('*');
	LDI  R17,LOW(0)
_0x25:
	CPI  R17,30
	BRSH _0x26
	LDI  R30,LOW(42)
	ST   -Y,R30
	RCALL _kirim_karakter
	SUBI R17,-1
	RJMP _0x25
_0x26:
; 0000 0159 kirim_karakter(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 015A 
; 0000 015B                 TXD_USART_0 = 1;
	SBI  0x3,1
; 0000 015C 
; 0000 015D                 init_usart0_600();
	RCALL _init_usart0_600
; 0000 015E                 putchar(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _putchar
; 0000 015F                 clr_usart0();
	RCALL _clr_usart0
; 0000 0160 
; 0000 0161                 PTT = 0;
	CBI  0x12,7
; 0000 0162         }
; 0000 0163 
; 0000 0164         clr_timer_0();
	RCALL _clr_timer_0
; 0000 0165 
; 0000 0166         flag = LOST;
	LDI  R30,LOW(0)
	STS  _flag,R30
; 0000 0167         bit_count = 0;
	STS  _bit_count,R30
; 0000 0168 
; 0000 0169         init_usart0_600();
	RCALL _init_usart0_600
; 0000 016A         init_usart1_600();
	RCALL _init_usart1_600
; 0000 016B 
; 0000 016C         TCNT3H = (11536 >> 8) & 0xFF;
	LDI  R30,LOW(45)
	STS  137,R30
; 0000 016D         TCNT3L = 11536 & 0xFF;
	LDI  R30,LOW(16)
	STS  136,R30
; 0000 016E }
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
_0x23:
	.BYTE 0x1B
;
;#define ADC_VREF_TYPE 0x00
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0174 {

	.CSEG
_read_adc:
; 0000 0175         ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 0176         // Delay needed for the stabilization of the ADC input voltage
; 0000 0177         delay_us(10);
	__DELAY_USB 37
; 0000 0178         // Start the AD conversion
; 0000 0179         ADCSRA|=0x40;
	SBI  0x6,6
; 0000 017A         // Wait for the AD conversion to complete
; 0000 017B         while ((ADCSRA & 0x10)==0);
_0x2B:
	SBIS 0x6,4
	RJMP _0x2B
; 0000 017C         ADCSRA|=0x10;
	SBI  0x6,4
; 0000 017D         return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x20A0004:
	ADIW R28,1
	RET
; 0000 017E }
;
;// Declare your global variables here
;
;void init_porta(void)
; 0000 0183 {
_init_porta:
; 0000 0184         PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0185         DDRA=0x38;
	LDI  R30,LOW(56)
	OUT  0x1A,R30
; 0000 0186 }
	RET
;
;void init_portc(void)
; 0000 0189 {
_init_portc:
; 0000 018A         PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 018B         DDRC=0x0F;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 018C }
	RET
;
;void init_portd(void)
; 0000 018F {
_init_portd:
; 0000 0190         PORTD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 0191         DDRD=0x88;
	LDI  R30,LOW(136)
	OUT  0x11,R30
; 0000 0192 }
	RET
;
;void init_porte(void)
; 0000 0195 {
_init_porte:
; 0000 0196         PORTE=0x03;
	LDI  R30,LOW(3)
	OUT  0x3,R30
; 0000 0197         DDRE=0xF2;
	LDI  R30,LOW(242)
	OUT  0x2,R30
; 0000 0198 }
	RET
;
;void init_portf(void)
; 0000 019B {
_init_portf:
; 0000 019C         PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 019D         DDRF=0x00;
	STS  97,R30
; 0000 019E }
	RET
;
;void init_portg(void)
; 0000 01A1 {
_init_portg:
; 0000 01A2         PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 01A3         DDRG=0x03;
	LDI  R30,LOW(3)
	STS  100,R30
; 0000 01A4 }
	RET
;
;void init_timer_0(void)
; 0000 01A7 {
_init_timer_0:
; 0000 01A8         TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 01A9         TCNT0=0xF7;
	LDI  R30,LOW(247)
	OUT  0x32,R30
; 0000 01AA 
; 0000 01AB         TIMSK=0x01;
	RJMP _0x20A0003
; 0000 01AC         ETIMSK=0x04;
; 0000 01AD }
;
;void clr_timer_0(void)
; 0000 01B0 {
_clr_timer_0:
; 0000 01B1         TCCR0=0;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 01B2         TCNT0=0;
	OUT  0x32,R30
; 0000 01B3 
; 0000 01B4         TIMSK=0x00;
	RJMP _0x20A0002
; 0000 01B5         ETIMSK=0x04;
; 0000 01B6 }
;
;void init_timer_3(void)
; 0000 01B9 {
_init_timer_3:
; 0000 01BA         TCCR3A=0x00;
	LDI  R30,LOW(0)
	STS  139,R30
; 0000 01BB         TCCR3B=0x05;
	LDI  R30,LOW(5)
	STS  138,R30
; 0000 01BC         TCNT3H = (11536 >> 8) & 0xFF;
	LDI  R30,LOW(45)
	STS  137,R30
; 0000 01BD         TCNT3L = 11536 & 0xFF;
	LDI  R30,LOW(16)
	STS  136,R30
; 0000 01BE         TIMSK=0x01;
_0x20A0003:
	LDI  R30,LOW(1)
_0x20A0002:
	OUT  0x37,R30
; 0000 01BF         ETIMSK=0x04;
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 01C0 }
	RET
;
;void init_usart0_600(void)
; 0000 01C3 {
_init_usart0_600:
; 0000 01C4         UCSR0A=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01C5 UCSR0B=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 01C6 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 01C7 UBRR0H=0x04;
	LDI  R30,LOW(4)
	STS  144,R30
; 0000 01C8 UBRR0L=0x7F;
	LDI  R30,LOW(127)
	RJMP _0x20A0001
; 0000 01C9 }
;
;void clr_usart0(void)
; 0000 01CC {
_clr_usart0:
; 0000 01CD         UCSR0A=0;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01CE         UCSR0B=0;
	OUT  0xA,R30
; 0000 01CF         UCSR0C=0;
	STS  149,R30
; 0000 01D0         UBRR0H=0;
	STS  144,R30
; 0000 01D1         UBRR0L=0;
_0x20A0001:
	OUT  0x9,R30
; 0000 01D2 }
	RET
;
;void init_usart1_600(void)
; 0000 01D5 {
_init_usart1_600:
; 0000 01D6         UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 01D7 UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
; 0000 01D8 UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 01D9 UBRR1H=0x04;
	LDI  R30,LOW(4)
	STS  152,R30
; 0000 01DA UBRR1L=0x7F;
	LDI  R30,LOW(127)
	STS  153,R30
; 0000 01DB }
	RET
;
;void init_adc(void)
; 0000 01DE {
_init_adc:
; 0000 01DF         ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 01E0         ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 01E1 }
	RET
;
;void baca_sensor(char number)
; 0000 01E4 {
_baca_sensor:
; 0000 01E5         char i;
; 0000 01E6 
; 0000 01E7         for(i=0;i<number;i++)
	ST   -Y,R17
;	number -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x2F:
	LDD  R30,Y+1
	CP   R17,R30
	BRLO PC+3
	JMP _0x30
; 0000 01E8         {
; 0000 01E9                 if(i<6)
	CPI  R17,6
	BRSH _0x31
; 0000 01EA                 {
; 0000 01EB                         sensor[i] = read_adc(i);
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
; 0000 01EC                 }
; 0000 01ED                 else
	RJMP _0x32
_0x31:
; 0000 01EE                 {
; 0000 01EF                         ADCMUX0 = (i - 6) & 0x01;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,6
	ANDI R30,LOW(0x1)
	BRNE _0x33
	CBI  0x1B,3
	RJMP _0x34
_0x33:
	SBI  0x1B,3
_0x34:
; 0000 01F0                         ADCMUX1 = ((i - 6) >> 1) & 0x01;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,6
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x35
	CBI  0x1B,4
	RJMP _0x36
_0x35:
	SBI  0x1B,4
_0x36:
; 0000 01F1                         ADCMUX2 = ((i - 6) >> 2) & 0x01;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,6
	CALL __ASRW2
	ANDI R30,LOW(0x1)
	BRNE _0x37
	CBI  0x1B,5
	RJMP _0x38
_0x37:
	SBI  0x1B,5
_0x38:
; 0000 01F2 
; 0000 01F3                         delay_us(2);
	__DELAY_USB 7
; 0000 01F4 
; 0000 01F5                         sensor[i] = read_adc(SENSOR_EXP);
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
; 0000 01F6 
; 0000 01F7                         ADCMUX0 = 0;
	CBI  0x1B,3
; 0000 01F8                         ADCMUX1 = 0;
	CBI  0x1B,4
; 0000 01F9                         ADCMUX2 = 0;
	CBI  0x1B,5
; 0000 01FA                 }
_0x32:
; 0000 01FB         }
	SUBI R17,-1
	RJMP _0x2F
_0x30:
; 0000 01FC }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void kirim_data(void)
; 0000 01FF {
; 0000 0200         char i;
; 0000 0201 
; 0000 0202         for(i=0;i<jumlah_sensor;i++)
;	i -> R17
; 0000 0203         {
; 0000 0204                 kirim_word(sensor[i]);
; 0000 0205                 kirim_karakter(',');
; 0000 0206         }
; 0000 0207 }
;
;void kirim_word(unsigned int data)
; 0000 020A {
; 0000 020B         char rib;
; 0000 020C         char rat;
; 0000 020D         char pul;
; 0000 020E         char sat;
; 0000 020F 
; 0000 0210         rib = data / 1000;
;	data -> Y+4
;	rib -> R17
;	rat -> R16
;	pul -> R19
;	sat -> R18
; 0000 0211         data = data % 1000;
; 0000 0212 
; 0000 0213         rat = data / 100;
; 0000 0214         data = data % 100;
; 0000 0215 
; 0000 0216         pul = data / 10;
; 0000 0217 
; 0000 0218         sat = data % 10;
; 0000 0219 
; 0000 021A         kirim_karakter((rib + '1')-1);
; 0000 021B         kirim_karakter((rat + '1')-1);
; 0000 021C         kirim_karakter((pul + '1')-1);
; 0000 021D         kirim_karakter((sat + '1')-1);
; 0000 021E }
;
;void kirim_karakter(unsigned char in_byte)
; 0000 0221 {
_kirim_karakter:
	PUSH R15
; 0000 0222         char i;
; 0000 0223         bit in_bit;
; 0000 0224 
; 0000 0225         TXD_USART_0 = 0;
	ST   -Y,R17
;	in_byte -> Y+1
;	i -> R17
;	in_bit -> R15.0
	CBI  0x3,1
; 0000 0226         DAC_0 = 0;
	CBI  0x3,4
; 0000 0227         DAC_1 = 0;
	CBI  0x3,5
; 0000 0228         DAC_2 = 0;
	CBI  0x3,6
; 0000 0229         DAC_3 = 0;
	CBI  0x3,7
; 0000 022A         ttt = 0;
	CLR  R12
	CLR  R13
; 0000 022B         while(ttt < 64);
_0x4C:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CP   R12,R30
	CPC  R13,R31
	BRLO _0x4C
; 0000 022C 
; 0000 022D         for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x50:
	CPI  R17,8
	BRSH _0x51
; 0000 022E         {
; 0000 022F                 in_bit = in_byte & 0x01;
	LDD  R30,Y+1
	BST  R30,0
	BLD  R15,0
; 0000 0230                 TXD_USART_0 = in_bit;
	SBRC R15,0
	RJMP _0x52
	CBI  0x3,1
	RJMP _0x53
_0x52:
	SBI  0x3,1
_0x53:
; 0000 0231                 DAC_0 = in_bit;
	SBRC R15,0
	RJMP _0x54
	CBI  0x3,4
	RJMP _0x55
_0x54:
	SBI  0x3,4
_0x55:
; 0000 0232                 DAC_1 = in_bit;
	SBRC R15,0
	RJMP _0x56
	CBI  0x3,5
	RJMP _0x57
_0x56:
	SBI  0x3,5
_0x57:
; 0000 0233                 DAC_2 = in_bit;
	SBRC R15,0
	RJMP _0x58
	CBI  0x3,6
	RJMP _0x59
_0x58:
	SBI  0x3,6
_0x59:
; 0000 0234                 DAC_3 = in_bit;
	SBRC R15,0
	RJMP _0x5A
	CBI  0x3,7
	RJMP _0x5B
_0x5A:
	SBI  0x3,7
_0x5B:
; 0000 0235                 ttt = 0;
	CLR  R12
	CLR  R13
; 0000 0236                 while(ttt < 64);
_0x5C:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CP   R12,R30
	CPC  R13,R31
	BRLO _0x5C
; 0000 0237                 in_byte >>= 1;
	LDD  R30,Y+1
	LDI  R31,0
	ASR  R31
	ROR  R30
	STD  Y+1,R30
; 0000 0238         }
	SUBI R17,-1
	RJMP _0x50
_0x51:
; 0000 0239 
; 0000 023A         TXD_USART_0 = 1;
	SBI  0x3,1
; 0000 023B         DAC_0 = 1;
	SBI  0x3,4
; 0000 023C         DAC_1 = 1;
	SBI  0x3,5
; 0000 023D         DAC_2 = 1;
	SBI  0x3,6
; 0000 023E         DAC_3 = 1;
	SBI  0x3,7
; 0000 023F         ttt = 0;
	CLR  R12
	CLR  R13
; 0000 0240         while(ttt < 64);
_0x69:
	LDI  R30,LOW(64)
	LDI  R31,HIGH(64)
	CP   R12,R30
	CPC  R13,R31
	BRLO _0x69
; 0000 0241 }
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;void kirim_string(char *str)
; 0000 0244 {
_kirim_string:
; 0000 0245         char k;
; 0000 0246         while (k=*str++) kirim_karakter(k);
	ST   -Y,R17
;	*str -> Y+1
;	k -> R17
_0x6C:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x6E
	ST   -Y,R17
	RCALL _kirim_karakter
	RJMP _0x6C
_0x6E:
; 0000 0247 kirim_karakter(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 0248 }
	LDD  R17,Y+0
	ADIW R28,3
	RET
;
;void init_port_all(void)
; 0000 024B {
_init_port_all:
; 0000 024C         init_porta();
	RCALL _init_porta
; 0000 024D         init_portc();
	RCALL _init_portc
; 0000 024E         init_portd();
	RCALL _init_portd
; 0000 024F         init_porte();
	RCALL _init_porte
; 0000 0250         init_portf();
	RCALL _init_portf
; 0000 0251         init_portg();
	RCALL _init_portg
; 0000 0252 }
	RET
;
;bit data_bit = 0;
;bit data_bit7,data_bit6,data_bit5,data_bit4,data_bit3,data_bit2,data_bit1;
;char data_byte;
;
;void decode_data(void)
; 0000 0259 {
; 0000 025A         init_timer_0();
; 0000 025B 
; 0000 025C         ttt = 0;
; 0000 025D         while(ttt < 64);
; 0000 025E 
; 0000 025F         data_bit7 = data_bit6;
; 0000 0260         data_bit6 = data_bit5;
; 0000 0261         data_bit5 = data_bit4;
; 0000 0262         data_bit4 = data_bit3;
; 0000 0263         data_bit3 = data_bit2;
; 0000 0264         data_bit2 = data_bit1;
; 0000 0265         data_bit1 = data_bit;
; 0000 0266 
; 0000 0267         data_byte = (data_bit << 7) +(data_bit1 << 6) +(data_bit2 << 5) +(data_bit3 << 4) +(data_bit4 << 3) +(data_bit5 << 2) +(data_bit6 << 1) +data_bit7;
; 0000 0268 
; 0000 0269         clr_timer_0();
; 0000 026A 
; 0000 026B         if(data_byte == '$')    kirim_karakter(data_byte);
; 0000 026C }
;
;unsigned int v= 0;
;void main(void)
; 0000 0270 {
_main:
; 0000 0271         init_port_all();
	RCALL _init_port_all
; 0000 0272         init_timer_0();
	RCALL _init_timer_0
; 0000 0273         init_timer_3();
	RCALL _init_timer_3
; 0000 0274         init_usart0_600();
	RCALL _init_usart0_600
; 0000 0275         init_usart1_600();
	RCALL _init_usart1_600
; 0000 0276         init_adc();
	RCALL _init_adc
; 0000 0277 
; 0000 0278         // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0279         TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 027A         ETIMSK=0x04;
	LDI  R30,LOW(4)
	STS  125,R30
; 0000 027B 
; 0000 027C         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 027D         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 027E 
; 0000 027F         //#asm("sei")
; 0000 0280 
; 0000 0281         while (1)
_0x73:
; 0000 0282         {
; 0000 0283                 #asm("cli")
	cli
; 0000 0284                 clr_usart0();
	RCALL _clr_usart0
; 0000 0285                 for(v=0;v<65535;v++)
	LDI  R30,LOW(0)
	STS  _v,R30
	STS  _v+1,R30
_0x77:
	LDS  R26,_v
	LDS  R27,_v+1
	CPI  R26,LOW(0xFFFF)
	LDI  R30,HIGH(0xFFFF)
	CPC  R27,R30
	BRSH _0x78
; 0000 0286                 {
; 0000 0287                         adc_buff = read_adc(FSK_IN);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	STS  _adc_buff,R30
	STS  _adc_buff+1,R31
; 0000 0288                         if(adc_buff > 50)
	LDS  R26,_adc_buff
	LDS  R27,_adc_buff+1
	SBIW R26,51
	BRLO _0x79
; 0000 0289                         {
; 0000 028A                                 TXD_USART_0 = 1;
	SBI  0x3,1
; 0000 028B                                 data_bit = 1;
	SET
	BLD  R2,0
; 0000 028C                         }
; 0000 028D                         if(adc_buff < 51)
_0x79:
	LDS  R26,_adc_buff
	LDS  R27,_adc_buff+1
	SBIW R26,51
	BRSH _0x7C
; 0000 028E                         {
; 0000 028F                                 TXD_USART_0 = 0;
	CBI  0x3,1
; 0000 0290                                 data_bit = 0;
	CLT
	BLD  R2,0
; 0000 0291                         }
; 0000 0292                         //decode_data();
; 0000 0293                 }
_0x7C:
	LDI  R26,LOW(_v)
	LDI  R27,HIGH(_v)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RJMP _0x77
_0x78:
; 0000 0294                 init_usart0_600();
	RCALL _init_usart0_600
; 0000 0295                 #asm("sei")
	sei
; 0000 0296                 delay_us(1);
	__DELAY_USB 4
; 0000 0297         }
	RJMP _0x73
; 0000 0298 }
_0x7F:
	RJMP _0x7F

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
_tx_buffer1:
	.BYTE 0x8
_adc_buff:
	.BYTE 0x2
_bit_count:
	.BYTE 0x1
_flag:
	.BYTE 0x1
_data_byte:
	.BYTE 0x1
_v:
	.BYTE 0x2
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

;END OF CODE MARKER
__END_OF_CODE:
