
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
	.DEF _t0=R5
	.DEF _tone=R4
	.DEF _t01=R7
	.DEF _t02=R6

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
	JMP  _timer1_ovf_isr
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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_matrix:
	.DB  0xA,0xC,0xD,0xE,0xD,0xC,0xA,0x7
	.DB  0x4,0x2,0x1,0x0,0x1,0x2,0x4,0x7
_tbl10_G103:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G103:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x63:
	.DB  0x0,0x0,0x0,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  0x04
	.DW  _0x63*2

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
;#ifdef        _OPTIMIZE_SIZE_
;        #define CONST_1200      46
;        #define CONST_2200      25  // 22-25    22-->2400Hz   25-->2200Hz
;
;        // Konstanta untuk kompilasi dalam mode optimasi kecepatan
;#else
;        #define CONST_1200      50
;        #define CONST_2200      25
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
;void kirim_karakter(unsigned int in_byte);
;void kirim_string(char *str);
;void set_dac(char value);
;
;eeprom unsigned int sensor[14];
;eeprom char jumlah_sensor = 14;
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Timer 0 overflow interrupt service routine
;
;#define DETECTED        1
;#define LOST            0
;
;flash char matrix[16] = {10,12,13,14,13,12,10,7,4,2,1,0,1,2,4,7};
;char t0 = 0;
;char tone = 0;
;char t01 = 0;
;char t02 = 0;
;bit data_bit = 0;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 007B {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R0
	ST   -Y,R1
	ST   -Y,R25
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 007C         // Reinitialize Timer 0 value
; 0000 007D         TCNT0=0xB8;
	LDI  R30,LOW(184)
	OUT  0x32,R30
; 0000 007E         // Place your code here
; 0000 007F 
; 0000 0080         if(data_bit)
	SBRS R2,0
	RJMP _0x3
; 0000 0081         {
; 0000 0082                 if((t0%2)==0)
	MOV  R26,R5
	CLR  R27
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	SBIW R30,0
	BRNE _0x4
; 0000 0083                 {
; 0000 0084                         if(tone)
	TST  R4
	BREQ _0x5
; 0000 0085                         {
; 0000 0086                                 DAC_0 = 1;
	SBI  0x3,4
; 0000 0087                                 DAC_1 = 1;
	SBI  0x3,5
; 0000 0088                                 DAC_2 = 1;
	SBI  0x3,6
; 0000 0089                                 DAC_3 = 1;
	SBI  0x3,7
; 0000 008A 
; 0000 008B                                 tone = 0;
	CLR  R4
; 0000 008C                         }
; 0000 008D                         else
	RJMP _0xE
_0x5:
; 0000 008E                         {
; 0000 008F                                 DAC_0 = 1;
	SBI  0x3,4
; 0000 0090                                 DAC_1 = 1;
	SBI  0x3,5
; 0000 0091                                 DAC_2 = 1;
	SBI  0x3,6
; 0000 0092                                 DAC_3 = 1;
	SBI  0x3,7
; 0000 0093 
; 0000 0094                                 tone = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0095                         }
_0xE:
; 0000 0096                 }
; 0000 0097         }
_0x4:
; 0000 0098         else if(data_bit == 0)
	RJMP _0x17
_0x3:
	SBRC R2,0
	RJMP _0x18
; 0000 0099         {
; 0000 009A                 if(tone)
	TST  R4
	BREQ _0x19
; 0000 009B                 {
; 0000 009C                         DAC_0 = 1;
	SBI  0x3,4
; 0000 009D                         DAC_1 = 1;
	SBI  0x3,5
; 0000 009E                         DAC_2 = 1;
	SBI  0x3,6
; 0000 009F                         DAC_3 = 1;
	SBI  0x3,7
; 0000 00A0 
; 0000 00A1                         tone = 0;
	CLR  R4
; 0000 00A2                 }
; 0000 00A3                 else
	RJMP _0x22
_0x19:
; 0000 00A4                 {
; 0000 00A5                         DAC_0 = 1;
	SBI  0x3,4
; 0000 00A6                         DAC_1 = 1;
	SBI  0x3,5
; 0000 00A7                         DAC_2 = 1;
	SBI  0x3,6
; 0000 00A8                         DAC_3 = 1;
	SBI  0x3,7
; 0000 00A9 
; 0000 00AA                         tone = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 00AB                 }
_0x22:
; 0000 00AC         }
; 0000 00AD 
; 0000 00AE         t0++;
_0x18:
_0x17:
	INC  R5
; 0000 00AF         if(t0>254)      t0 = 0;
	LDI  R30,LOW(254)
	CP   R30,R5
	BRSH _0x2B
	CLR  R5
; 0000 00B0 }
_0x2B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	LD   R25,Y+
	LD   R1,Y+
	LD   R0,Y+
	RETI
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00B4 {
_timer1_ovf_isr:
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
; 0000 00B5 
; 0000 00B6 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00B7 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00B8 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00B9 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00BA kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00BB kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00BC kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00BD kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00BE kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00BF kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00C0 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00C1 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00C2 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00C3 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00C4 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00C5 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00C6 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00C7 kirim_karakter('D');
	LDI  R30,LOW(68)
	LDI  R31,HIGH(68)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00C8 kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00C9 kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00CA kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00CB kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00CC kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00CD kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00CE kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00CF kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00D0 kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00D1 kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00D2 kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00D3 kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00D4 kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00D5 kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00D6 kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00D7 kirim_karakter('A');
	LDI  R30,LOW(65)
	LDI  R31,HIGH(65)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00D8 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00D9 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00DA kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00DB kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00DC kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00DD kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00DE kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00DF kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00E0 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00E1 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00E2 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00E3 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00E4 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00E5 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00E6 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00E7 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00E8 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00E9 kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00EA kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00EB kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00EC kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00ED kirim_karakter('Z');
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00EE 
; 0000 00EF // Reinitialize Timer1 value
; 0000 00F0 TCNT1H=0x2D10 >> 8;
	LDI  R30,LOW(45)
	OUT  0x2D,R30
; 0000 00F1 TCNT1L=0x2D10 & 0xff;
	LDI  R30,LOW(16)
	OUT  0x2C,R30
; 0000 00F2 // Place your code here
; 0000 00F3 }
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
;#define ADC_VREF_TYPE 0x00
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 00F9 {
; 0000 00FA         ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 00FB         // Delay needed for the stabilization of the ADC input voltage
; 0000 00FC         delay_us(10);
; 0000 00FD         // Start the AD conversion
; 0000 00FE         ADCSRA|=0x40;
; 0000 00FF         // Wait for the AD conversion to complete
; 0000 0100         while ((ADCSRA & 0x10)==0);
; 0000 0101         ADCSRA|=0x10;
; 0000 0102         return ADCW;
; 0000 0103 }
;
;// Declare your global variables here
;
;void init_porta(void)
; 0000 0108 {
_init_porta:
; 0000 0109         PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 010A         DDRA=0x38;
	LDI  R30,LOW(56)
	OUT  0x1A,R30
; 0000 010B }
	RET
;
;void init_portc(void)
; 0000 010E {
_init_portc:
; 0000 010F         PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0110         DDRC=0x0F;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 0111 }
	RET
;
;void init_portd(void)
; 0000 0114 {
_init_portd:
; 0000 0115         PORTD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 0116         DDRD=0x88;
	LDI  R30,LOW(136)
	OUT  0x11,R30
; 0000 0117 }
	RET
;
;void init_porte(void)
; 0000 011A {
_init_porte:
; 0000 011B         PORTE=0x03;
	LDI  R30,LOW(3)
	OUT  0x3,R30
; 0000 011C         DDRE=0xF2;
	LDI  R30,LOW(242)
	OUT  0x2,R30
; 0000 011D }
	RET
;
;void init_portf(void)
; 0000 0120 {
_init_portf:
; 0000 0121         PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 0122         DDRF=0x00;
	STS  97,R30
; 0000 0123 }
	RET
;
;void init_portg(void)
; 0000 0126 {
_init_portg:
; 0000 0127         PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 0128         DDRG=0x03;
	LDI  R30,LOW(3)
	STS  100,R30
; 0000 0129 }
	RET
;
;void init_timer_0(void)
; 0000 012C {
_init_timer_0:
; 0000 012D // Timer/Counter 0 initialization
; 0000 012E // Clock source: System Clock
; 0000 012F // Clock value: 345.600 kHz
; 0000 0130 // Mode: Normal top=0xFF
; 0000 0131 // OC0 output: Disconnected
; 0000 0132 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0133 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0134 TCNT0=0xB8;
	LDI  R30,LOW(184)
	OUT  0x32,R30
; 0000 0135 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 0136 }
	RET
;
;void init_timer_1(void)
; 0000 0139 {
_init_timer_1:
; 0000 013A TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 013B TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 013C TCNT1H=0x2D;
	LDI  R30,LOW(45)
	OUT  0x2D,R30
; 0000 013D TCNT1L=0x10;
	LDI  R30,LOW(16)
	OUT  0x2C,R30
; 0000 013E 
; 0000 013F // Reinitialize Timer1 value
; 0000 0140 TCNT1H=0x2D10 >> 8;
	LDI  R30,LOW(45)
	OUT  0x2D,R30
; 0000 0141 TCNT1L=0x2D10 & 0xff;
	LDI  R30,LOW(16)
	OUT  0x2C,R30
; 0000 0142 // Place your code here
; 0000 0143 }
	RET
;
;void init_usart0_600(void)
; 0000 0146 {
; 0000 0147         // USART0 initialization
; 0000 0148 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0149 // USART0 Receiver: On
; 0000 014A // USART0 Transmitter: On
; 0000 014B // USART0 Mode: Asynchronous
; 0000 014C // USART0 Baud Rate: 9600
; 0000 014D UCSR0A=0x00;
; 0000 014E UCSR0B=0x18;
; 0000 014F UCSR0C=0x06;
; 0000 0150 UBRR0H=0x00;
; 0000 0151 UBRR0L=0x47;
; 0000 0152 }
;
;void clr_usart0(void)
; 0000 0155 {
; 0000 0156         UCSR0A=0;
; 0000 0157         UCSR0B=0;
; 0000 0158         UCSR0C=0;
; 0000 0159         UBRR0H=0;
; 0000 015A         UBRR0L=0;
; 0000 015B }
;
;void init_adc(void)
; 0000 015E {
; 0000 015F         ADMUX=ADC_VREF_TYPE & 0xff;
; 0000 0160         ADCSRA=0x84;
; 0000 0161 }
;
;void baca_sensor(char number)
; 0000 0164 {
; 0000 0165         char i;
; 0000 0166 
; 0000 0167         for(i=0;i<number;i++)
;	number -> Y+1
;	i -> R17
; 0000 0168         {
; 0000 0169                 if(i<6)
; 0000 016A                 {
; 0000 016B                         sensor[i] = read_adc(i);
; 0000 016C                 }
; 0000 016D                 else
; 0000 016E                 {
; 0000 016F                         ADCMUX0 = (i - 6) & 0x01;
; 0000 0170                         ADCMUX1 = ((i - 6) >> 1) & 0x01;
; 0000 0171                         ADCMUX2 = ((i - 6) >> 2) & 0x01;
; 0000 0172 
; 0000 0173                         delay_us(2);
; 0000 0174 
; 0000 0175                         sensor[i] = read_adc(SENSOR_EXP);
; 0000 0176 
; 0000 0177                         ADCMUX0 = 0;
; 0000 0178                         ADCMUX1 = 0;
; 0000 0179                         ADCMUX2 = 0;
; 0000 017A                 }
; 0000 017B         }
; 0000 017C }
;
;void kirim_data(void)
; 0000 017F {
; 0000 0180         char i;
; 0000 0181 
; 0000 0182         for(i=0;i<jumlah_sensor;i++)
;	i -> R17
; 0000 0183         {
; 0000 0184                 kirim_word(sensor[i]);
; 0000 0185                 kirim_karakter(',');
; 0000 0186         }
; 0000 0187 }
;
;void kirim_word(unsigned int data)
; 0000 018A {
; 0000 018B         char rib;
; 0000 018C         char rat;
; 0000 018D         char pul;
; 0000 018E         char sat;
; 0000 018F 
; 0000 0190         rib = data / 1000;
;	data -> Y+4
;	rib -> R17
;	rat -> R16
;	pul -> R19
;	sat -> R18
; 0000 0191         data = data % 1000;
; 0000 0192 
; 0000 0193         rat = data / 100;
; 0000 0194         data = data % 100;
; 0000 0195 
; 0000 0196         pul = data / 10;
; 0000 0197 
; 0000 0198         sat = data % 10;
; 0000 0199 
; 0000 019A         kirim_karakter((rib + '1')-1);
; 0000 019B         kirim_karakter((rat + '1')-1);
; 0000 019C         kirim_karakter((pul + '1')-1);
; 0000 019D         kirim_karakter((sat + '1')-1);
; 0000 019E }
;
;void set_dac(char value)
; 0000 01A1 {
; 0000 01A2         DAC_0 = value & 0x01;
;	value -> Y+0
; 0000 01A3         DAC_1 = (value >> 1) & 0x01;
; 0000 01A4         DAC_2 = (value >> 2) & 0x01;
; 0000 01A5         DAC_3 = (value >> 3) & 0x01;
; 0000 01A6 }
;
;// Konstanta untuk kompilasi dalam mode optimasi ukuran
;#ifdef	_OPTIMIZE_SIZE_
;	#define CONST_1200      46
;	#define CONST_2200      25  // 22-25    22-->2400Hz   25-->2200Hz
;
;        // Konstanta untuk kompilasi dalam mode optimasi kecepatan
;#else
;	#define CONST_1200      52
;	#define CONST_2200      26
;#endif
;
;/***************************************************************************************/
;	void 			set_nada(char i_nada)
; 0000 01B5 /***************************************************************************************
; 0000 01B6 *	ABSTRAKSI  	: 	Membentuk baudrate serta frekensi tone 1200Hz dan 2200Hz
; 0000 01B7 *				dari konstanta waktu. Men-setting nilai DAC. Lakukan fine
; 0000 01B8 *				tuning pada jumlah masing - masing perulangan for dan
; 0000 01B9 *				konstanta waktu untuk meng-adjust parameter baudrate dan
; 0000 01BA *				frekuensi tone.
; 0000 01BB *
; 0000 01BC *      	INPUT		:	nilai frekuensi tone yang akan ditransmisikan
; 0000 01BD *	OUTPUT		:       nilai DAC
; 0000 01BE *	RETURN		:       tak ada
; 0000 01BF */
; 0000 01C0 {
; 0000 01C1 	char i;
; 0000 01C2 
; 0000 01C3         // jika frekuensi tone yang akan segera dipancarkan adalah :
; 0000 01C4         // 1200Hz
; 0000 01C5 	if(i_nada)
;	i_nada -> Y+1
;	i -> R17
; 0000 01C6     	{
; 0000 01C7         	// jika ya
; 0000 01C8         	for(i=0; i<16; i++)
; 0000 01C9         	{
; 0000 01CA                 	// set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 01CB                 		// dan urutan perulangan for 0 - 15
; 0000 01CC                 	set_dac(matrix[i]);
; 0000 01CD 
; 0000 01CE                         // bangkitkan frekuensi 1200Hz dari konstanta waktu
; 0000 01CF         		delay_us(CONST_1200);
; 0000 01D0         	}
; 0000 01D1     	}
; 0000 01D2         // 2200Hz
; 0000 01D3     	else
; 0000 01D4     	{
; 0000 01D5         	// jika ya
; 0000 01D6         	for(i=0; i<16; i++)
; 0000 01D7         	{
; 0000 01D8                 	// set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 01D9                 		// dan urutan perulangan for 0 - 15
; 0000 01DA                 	set_dac(matrix[i]);
; 0000 01DB 
; 0000 01DC                         // bangkitkan frekuensi 2200Hz dari konstanta waktu
; 0000 01DD                 	delay_us(CONST_2200);
; 0000 01DE                 }
; 0000 01DF                 // sekali lagi, untuk mengatur baudrate lakukan fine tune pada jumlah for
; 0000 01E0                 for(i=0; i<16; i++)
; 0000 01E1                 {
; 0000 01E2                 	// set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 01E3                 		// dan urutan perulangan for
; 0000 01E4                 	set_dac(matrix[i]);
; 0000 01E5 
; 0000 01E6                         // bangkitkan frekuensi 2200Hz dari konstanta waktu
; 0000 01E7                 	delay_us(CONST_2200);
; 0000 01E8                 }
; 0000 01E9     	}
; 0000 01EA 
; 0000 01EB } 	// EndOf void set_nada(char i_nada)
;
;void kirim_karakter(unsigned int in_byte)
; 0000 01EE {
_kirim_karakter:
	PUSH R15
; 0000 01EF         char h=0;
; 0000 01F0         bit in_bit;
; 0000 01F1 
; 0000 01F2         in_byte = (1 << 9) + (in_byte << 1);
	ST   -Y,R17
;	in_byte -> Y+1
;	h -> R17
;	in_bit -> R15.0
	LDI  R17,0
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	LSL  R30
	ROL  R31
	SUBI R30,LOW(-512)
	SBCI R31,HIGH(-512)
	STD  Y+1,R30
	STD  Y+1+1,R31
; 0000 01F3 
; 0000 01F4         for(h=0;h<10;h++)
	LDI  R17,LOW(0)
_0x57:
	CPI  R17,10
	BRSH _0x58
; 0000 01F5         {
; 0000 01F6                 data_bit = (in_byte >> h) & 0x01;
	MOV  R30,R17
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	CALL __LSRW12
	BST  R30,0
	BLD  R2,0
; 0000 01F7                 t0 = 0;
	CLR  R5
; 0000 01F8                 while(t0<4);
_0x59:
	LDI  R30,LOW(4)
	CP   R5,R30
	BRLO _0x59
; 0000 01F9         }
	SUBI R17,-1
	RJMP _0x57
_0x58:
; 0000 01FA         data_bit = 1;
	SET
	BLD  R2,0
; 0000 01FB }
	LDD  R17,Y+0
	ADIW R28,3
	POP  R15
	RET
;
;void kirim_string(char *str)
; 0000 01FE {
; 0000 01FF         char k;
; 0000 0200         while (k=*str++) kirim_karakter(k);
;	*str -> Y+1
;	k -> R17
; 0000 0201 kirim_karakter(10);
; 0000 0202 }
;
;void init_port_all(void)
; 0000 0205 {
_init_port_all:
; 0000 0206         init_porta();
	RCALL _init_porta
; 0000 0207         init_portc();
	RCALL _init_portc
; 0000 0208         init_portd();
	RCALL _init_portd
; 0000 0209         init_porte();
	RCALL _init_porte
; 0000 020A         init_portf();
	RCALL _init_portf
; 0000 020B         init_portg();
	RCALL _init_portg
; 0000 020C }
	RET
;
;void main(void)
; 0000 020F {
_main:
; 0000 0210         init_port_all();
	RCALL _init_port_all
; 0000 0211 
; 0000 0212         init_timer_0();
	RCALL _init_timer_0
; 0000 0213         init_timer_1();
	RCALL _init_timer_1
; 0000 0214 
; 0000 0215         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0216         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0217 
; 0000 0218         TIMSK=0x05;
	LDI  R30,LOW(5)
	OUT  0x37,R30
; 0000 0219 
; 0000 021A         #asm("sei")
	sei
; 0000 021B 
; 0000 021C         while (1)
_0x5F:
; 0000 021D         {
; 0000 021E 
; 0000 021F         }
	RJMP _0x5F
; 0000 0220 }
_0x62:
	RJMP _0x62

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
__seed_G100:
	.BYTE 0x4

	.CSEG

	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
	RET

__LSRW12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	BREQ __LSRW12R
__LSRW12L:
	LSR  R31
	ROR  R30
	DEC  R0
	BRNE __LSRW12L
__LSRW12R:
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

;END OF CODE MARKER
__END_OF_CODE:
