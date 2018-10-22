
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega128
;Program type             : Application
;Clock frequency          : 11.059200 MHz
;Memory model             : Small
;Optimize for             : Size
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
	.DEF _tc=R5
	.DEF _t0=R4

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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x39:
	.DB  0x0,0x0
_0x0:
	.DB  0x54,0x45,0x53,0x54,0x20,0x31,0x32,0x33
	.DB  0x20,0x31,0x32,0x33,0x20,0x31,0x32,0x33
	.DB  0x20,0x46,0x46,0x46,0x46,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x16
	.DW  _0x37
	.DW  _0x0*2

	.DW  0x02
	.DW  0x04
	.DW  _0x39*2

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
;Date    : 10/3/2013
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
;
;#include <delay.h>
;
;#define DAC0    PORTE.4
;#define DAC1    PORTE.5
;#define DAC2    PORTE.6
;#define DAC3    PORTE.7
;
;bit data_bit;
;char tc = 0;
;char t0 = 0;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0027 {

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
; 0000 0028         // Place your code here
; 0000 0029         TCNT0=184;
	LDI  R30,LOW(184)
	OUT  0x32,R30
; 0000 002A 
; 0000 002B         if(data_bit == 1)
	SBRS R2,0
	RJMP _0x3
; 0000 002C         {
; 0000 002D                 if((tc == 0)||((tc%2)==0))
	LDI  R30,LOW(0)
	CP   R30,R5
	BREQ _0x5
	MOV  R26,R5
	CLR  R27
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __MODW21
	SBIW R30,0
	BRNE _0x4
_0x5:
; 0000 002E                 {
; 0000 002F                         if(t0 == 1)
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x7
; 0000 0030                         {
; 0000 0031                                 DAC0 = 1;
	SBI  0x3,4
; 0000 0032                                 DAC1 = 1;
	SBI  0x3,5
; 0000 0033                                 DAC2 = 1;
	SBI  0x3,6
; 0000 0034                                 DAC3 = 1;
	SBI  0x3,7
; 0000 0035 
; 0000 0036                                 t0 = 0;
	CLR  R4
; 0000 0037                         }
; 0000 0038                         else
	RJMP _0x10
_0x7:
; 0000 0039                         {
; 0000 003A                                 DAC0 = 0;
	RCALL SUBOPT_0x0
; 0000 003B                                 DAC1 = 0;
; 0000 003C                                 DAC2 = 0;
; 0000 003D                                 DAC3 = 0;
; 0000 003E 
; 0000 003F                                 t0 = 1;
; 0000 0040                         }
_0x10:
; 0000 0041                 }
; 0000 0042         }
_0x4:
; 0000 0043         else
	RJMP _0x19
_0x3:
; 0000 0044         {
; 0000 0045                 if(t0 == 1)
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x1A
; 0000 0046                 {
; 0000 0047                         DAC0 = 1;
	SBI  0x3,4
; 0000 0048                         DAC1 = 1;
	SBI  0x3,5
; 0000 0049                         DAC2 = 1;
	SBI  0x3,6
; 0000 004A                         DAC3 = 1;
	SBI  0x3,7
; 0000 004B 
; 0000 004C                         t0 = 0;
	CLR  R4
; 0000 004D                 }
; 0000 004E                 else
	RJMP _0x23
_0x1A:
; 0000 004F                 {
; 0000 0050                         DAC0 = 0;
	RCALL SUBOPT_0x0
; 0000 0051                         DAC1 = 0;
; 0000 0052                         DAC2 = 0;
; 0000 0053                         DAC3 = 0;
; 0000 0054 
; 0000 0055                         t0 = 1;
; 0000 0056                 }
_0x23:
; 0000 0057         }
_0x19:
; 0000 0058 
; 0000 0059         if(tc < 253)    tc++;
	LDI  R30,LOW(253)
	CP   R5,R30
	BRSH _0x2C
	INC  R5
; 0000 005A         else            tc = 0;
	RJMP _0x2D
_0x2C:
	CLR  R5
; 0000 005B }
_0x2D:
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
; 0000 005F {
_timer1_ovf_isr:
	ST   -Y,R30
; 0000 0060         // Place your code here
; 0000 0061         TCNT1H=11536 >> 8;
	LDI  R30,LOW(45)
	OUT  0x2D,R30
; 0000 0062         TCNT1L=11536 & 0xFF;
	LDI  R30,LOW(16)
	OUT  0x2C,R30
; 0000 0063 
; 0000 0064         //if(data_bit)    data_bit = 0;
; 0000 0065         //else            data_bit = 1;
; 0000 0066 }
	LD   R30,Y+
	RETI
;
;// Declare your global variables here
;#define BAUD    745
;
;void kirim_karakter(unsigned char c)
; 0000 006C {
_kirim_karakter:
; 0000 006D         char i;
; 0000 006E 
; 0000 006F         c = (1 << 9) + (c << 1);
	ST   -Y,R17
;	c -> Y+1
;	i -> R17
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
; 0000 0070 
; 0000 0071         for(i=0;i<10;i++)
	LDI  R17,LOW(0)
_0x2F:
	CPI  R17,10
	BRSH _0x30
; 0000 0072         {
; 0000 0073                 //tc = 0;
; 0000 0074                 data_bit = (c >> i) & 0x01;
	LDD  R26,Y+1
	LDI  R27,0
	MOV  R30,R17
	CALL __ASRW12
	BST  R30,0
	BLD  R2,0
; 0000 0075                 delay_us(BAUD);
	__DELAY_USW 2060
; 0000 0076                 //while(tc < 8);
; 0000 0077         }
	SUBI R17,-1
	RJMP _0x2F
_0x30:
; 0000 0078 
; 0000 0079         data_bit = 1;
	SET
	BLD  R2,0
; 0000 007A         delay_us(BAUD);
	__DELAY_USW 2060
; 0000 007B }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void kirim_string(char *str)
; 0000 007E {
_kirim_string:
; 0000 007F         char k;
; 0000 0080         while (k=*str++)        kirim_karakter(k);
	ST   -Y,R17
;	*str -> Y+1
;	k -> R17
_0x31:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x33
	ST   -Y,R17
	RCALL _kirim_karakter
	RJMP _0x31
_0x33:
; 0000 0081 kirim_karakter(10);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 0082 }
	LDD  R17,Y+0
	ADIW R28,3
	RET
;
;void main(void)
; 0000 0085 {
_main:
; 0000 0086 // Declare your local variables here
; 0000 0087 
; 0000 0088 // Input/Output Ports initialization
; 0000 0089 // Port A initialization
; 0000 008A // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 008B // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 008C PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 008D DDRA=0x00;
	OUT  0x1A,R30
; 0000 008E 
; 0000 008F // Port B initialization
; 0000 0090 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0091 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0092 PORTB=0x00;
	OUT  0x18,R30
; 0000 0093 DDRB=0x00;
	OUT  0x17,R30
; 0000 0094 
; 0000 0095 // Port C initialization
; 0000 0096 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0097 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0098 PORTC=0x00;
	OUT  0x15,R30
; 0000 0099 DDRC=0x00;
	OUT  0x14,R30
; 0000 009A 
; 0000 009B // Port D initialization
; 0000 009C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 009D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 009E PORTD=0x00;
	OUT  0x12,R30
; 0000 009F DDRD=0x00;
	OUT  0x11,R30
; 0000 00A0 
; 0000 00A1 // Port E initialization
; 0000 00A2 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 00A3 // State7=0 State6=0 State5=0 State4=0 State3=T State2=T State1=T State0=T
; 0000 00A4 PORTE=0x00;
	OUT  0x3,R30
; 0000 00A5 DDRE=0xF0;
	LDI  R30,LOW(240)
	OUT  0x2,R30
; 0000 00A6 
; 0000 00A7 // Port F initialization
; 0000 00A8 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A9 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00AA PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 00AB DDRF=0x00;
	STS  97,R30
; 0000 00AC 
; 0000 00AD // Port G initialization
; 0000 00AE // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00AF // State4=T State3=T State2=T State1=T State0=T
; 0000 00B0 PORTG=0x00;
	STS  101,R30
; 0000 00B1 DDRG=0x00;
	STS  100,R30
; 0000 00B2 
; 0000 00B3 // Timer/Counter 0 initialization
; 0000 00B4 // Clock source: System Clock
; 0000 00B5 // Clock value: 345.600 kHz
; 0000 00B6 // Mode: Normal top=0xFF
; 0000 00B7 // OC0 output: Disconnected
; 0000 00B8 ASSR=0x00;
	OUT  0x30,R30
; 0000 00B9 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 00BA TCNT0=184;
	LDI  R30,LOW(184)
	OUT  0x32,R30
; 0000 00BB OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 00BC 
; 0000 00BD // Timer/Counter 1 initialization
; 0000 00BE // Clock source: System Clock
; 0000 00BF // Clock value: 10.800 kHz
; 0000 00C0 // Mode: Normal top=0xFFFF
; 0000 00C1 // OC1A output: Discon.
; 0000 00C2 // OC1B output: Discon.
; 0000 00C3 // OC1C output: Discon.
; 0000 00C4 // Noise Canceler: Off
; 0000 00C5 // Input Capture on Falling Edge
; 0000 00C6 // Timer1 Overflow Interrupt: On
; 0000 00C7 // Input Capture Interrupt: Off
; 0000 00C8 // Compare A Match Interrupt: Off
; 0000 00C9 // Compare B Match Interrupt: Off
; 0000 00CA // Compare C Match Interrupt: Off
; 0000 00CB TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00CC TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 00CD TCNT1H=11536 >> 8;
	LDI  R30,LOW(45)
	OUT  0x2D,R30
; 0000 00CE TCNT1L=11536 & 0xFF;
	LDI  R30,LOW(16)
	OUT  0x2C,R30
; 0000 00CF ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00D0 ICR1L=0x00;
	OUT  0x26,R30
; 0000 00D1 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00D2 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00D3 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00D4 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00D5 OCR1CH=0x00;
	STS  121,R30
; 0000 00D6 OCR1CL=0x00;
	STS  120,R30
; 0000 00D7 
; 0000 00D8 // Timer/Counter 2 initialization
; 0000 00D9 // Clock source: System Clock
; 0000 00DA // Clock value: Timer2 Stopped
; 0000 00DB // Mode: Normal top=0xFF
; 0000 00DC // OC2 output: Disconnected
; 0000 00DD TCCR2=0x00;
	OUT  0x25,R30
; 0000 00DE TCNT2=0x00;
	OUT  0x24,R30
; 0000 00DF OCR2=0x00;
	OUT  0x23,R30
; 0000 00E0 
; 0000 00E1 // Timer/Counter 3 initialization
; 0000 00E2 // Clock source: System Clock
; 0000 00E3 // Clock value: Timer3 Stopped
; 0000 00E4 // Mode: Normal top=0xFFFF
; 0000 00E5 // OC3A output: Discon.
; 0000 00E6 // OC3B output: Discon.
; 0000 00E7 // OC3C output: Discon.
; 0000 00E8 // Noise Canceler: Off
; 0000 00E9 // Input Capture on Falling Edge
; 0000 00EA // Timer3 Overflow Interrupt: Off
; 0000 00EB // Input Capture Interrupt: Off
; 0000 00EC // Compare A Match Interrupt: Off
; 0000 00ED // Compare B Match Interrupt: Off
; 0000 00EE // Compare C Match Interrupt: Off
; 0000 00EF TCCR3A=0x00;
	STS  139,R30
; 0000 00F0 TCCR3B=0x00;
	STS  138,R30
; 0000 00F1 TCNT3H=0x00;
	STS  137,R30
; 0000 00F2 TCNT3L=0x00;
	STS  136,R30
; 0000 00F3 ICR3H=0x00;
	STS  129,R30
; 0000 00F4 ICR3L=0x00;
	STS  128,R30
; 0000 00F5 OCR3AH=0x00;
	STS  135,R30
; 0000 00F6 OCR3AL=0x00;
	STS  134,R30
; 0000 00F7 OCR3BH=0x00;
	STS  133,R30
; 0000 00F8 OCR3BL=0x00;
	STS  132,R30
; 0000 00F9 OCR3CH=0x00;
	STS  131,R30
; 0000 00FA OCR3CL=0x00;
	STS  130,R30
; 0000 00FB 
; 0000 00FC // External Interrupt(s) initialization
; 0000 00FD // INT0: Off
; 0000 00FE // INT1: Off
; 0000 00FF // INT2: Off
; 0000 0100 // INT3: Off
; 0000 0101 // INT4: Off
; 0000 0102 // INT5: Off
; 0000 0103 // INT6: Off
; 0000 0104 // INT7: Off
; 0000 0105 EICRA=0x00;
	STS  106,R30
; 0000 0106 EICRB=0x00;
	OUT  0x3A,R30
; 0000 0107 EIMSK=0x00;
	OUT  0x39,R30
; 0000 0108 
; 0000 0109 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 010A TIMSK=0x05;
	LDI  R30,LOW(5)
	OUT  0x37,R30
; 0000 010B 
; 0000 010C ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 010D 
; 0000 010E // USART0 initialization
; 0000 010F // USART0 disabled
; 0000 0110 UCSR0B=0x00;
	OUT  0xA,R30
; 0000 0111 
; 0000 0112 // USART1 initialization
; 0000 0113 // USART1 disabled
; 0000 0114 UCSR1B=0x00;
	STS  154,R30
; 0000 0115 
; 0000 0116 // Analog Comparator initialization
; 0000 0117 // Analog Comparator: Off
; 0000 0118 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0119 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 011A SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 011B 
; 0000 011C // ADC initialization
; 0000 011D // ADC disabled
; 0000 011E ADCSRA=0x00;
	OUT  0x6,R30
; 0000 011F 
; 0000 0120 // SPI initialization
; 0000 0121 // SPI disabled
; 0000 0122 SPCR=0x00;
	OUT  0xD,R30
; 0000 0123 
; 0000 0124 // TWI initialization
; 0000 0125 // TWI disabled
; 0000 0126 TWCR=0x00;
	STS  116,R30
; 0000 0127 
; 0000 0128 // Global enable interrupts
; 0000 0129 #asm("sei")
	sei
; 0000 012A 
; 0000 012B data_bit = 1;
	SET
	BLD  R2,0
; 0000 012C 
; 0000 012D while (1)
_0x34:
; 0000 012E       {
; 0000 012F       // Place your code here
; 0000 0130         kirim_string("TEST 123 123 123 FFFF");
	__POINTW1MN _0x37,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _kirim_string
; 0000 0131         kirim_karakter(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 0132       }
	RJMP _0x34
; 0000 0133 }
_0x38:
	RJMP _0x38

	.DSEG
_0x37:
	.BYTE 0x16

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	CBI  0x3,4
	CBI  0x3,5
	CBI  0x3,6
	CBI  0x3,7
	LDI  R30,LOW(1)
	MOV  R4,R30
	RET


	.CSEG
__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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
