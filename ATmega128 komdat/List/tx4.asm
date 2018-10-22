
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
	.DEF _m_idx=R5
	.DEF _tc=R4
	.DEF _jumlah_sensor=R7
	.DEF _t_value=R8
	.DEF _adc_buff=R10
	.DEF _t_value2=R12
	.DEF _t0c=R6

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

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0020

_0x5E:
	.DB  0x0,0x0,0x0,0xE,0x0,0x0,0x0,0x0
	.DB  0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0A
	.DW  0x04
	.DW  _0x5E*2

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
;Date    : 10/4/2013
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
;#define BAUD    745
;#define DF_1200 370     // dilatation factor 1200 --> 2.185
;#define DF_2400 370
;
;unsigned char data[100];
;flash char matrix[16] = {10,12,13,14,13,12,10,7,4,2,1,0,1,2,4,7};
;char m_idx = 0;
;char tc = 0;
;bit data_bit = 0;
;char jumlah_sensor = 14;
;unsigned char sensor[20];
;int t_value = 0;
;unsigned int adc_buff = 0;
;int t_value2= 0;
;bit buff = 0;
;bit b1 = 0;
;bit b2 = 0;
;bit b3 = 0;
;char t0c = 0;
;
;#define PANCAR  1
;#define TERIMA  0
;
;bit mode = PANCAR;
;
;unsigned char read_adc(unsigned char adc_input);
;void baca_sensor(char number);
;void proses_data_1(void);
;void proses_data_2(void);
;void kirim_karakter(unsigned char c);
;void kirim_data(void);
;void kirim_string(char *str);
;void init_porta(void);
;void init_portc(void);
;void init_portd(void);
;void init_porte(void);
;void init_portf(void);
;void init_portg(void);
;void init_port_all(void);
;
;#define ADC_VREF_TYPE 0x20
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 006C {

	.CSEG
_read_adc:
; 0000 006D ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 006E // Delay needed for the stabilization of the ADC input voltage
; 0000 006F delay_us(10);
	__DELAY_USB 37
; 0000 0070 // Start the AD conversion
; 0000 0071 ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0072 // Wait for the AD conversion to complete
; 0000 0073 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0074 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0075 return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0076 }
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 007A {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 007B         // Place your code here
; 0000 007C         if(mode==PANCAR)
	SBRS R2,5
	RJMP _0x6
; 0000 007D         {
; 0000 007E                 TCNT0=247;
	LDI  R30,LOW(247)
	OUT  0x32,R30
; 0000 007F 
; 0000 0080                 if(m_idx==16)   m_idx=0;
	LDI  R30,LOW(16)
	CP   R30,R5
	BRNE _0x7
	CLR  R5
; 0000 0081 
; 0000 0082                 DAC_0 =  matrix[m_idx] & 0x01;
_0x7:
	RCALL SUBOPT_0x0
	ANDI R30,LOW(0x1)
	BRNE _0x8
	CBI  0x3,4
	RJMP _0x9
_0x8:
	SBI  0x3,4
_0x9:
; 0000 0083                 DAC_1 = (matrix[m_idx] >> 1) & 0x01;
	RCALL SUBOPT_0x0
	LDI  R31,0
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	BRNE _0xA
	CBI  0x3,5
	RJMP _0xB
_0xA:
	SBI  0x3,5
_0xB:
; 0000 0084                 DAC_2 = (matrix[m_idx] >> 2) & 0x01;
	RCALL SUBOPT_0x0
	LDI  R31,0
	CALL __ASRW2
	ANDI R30,LOW(0x1)
	BRNE _0xC
	CBI  0x3,6
	RJMP _0xD
_0xC:
	SBI  0x3,6
_0xD:
; 0000 0085                 DAC_3 = (matrix[m_idx] >> 3) & 0x01;
	RCALL SUBOPT_0x0
	LDI  R31,0
	CALL __ASRW3
	ANDI R30,LOW(0x1)
	BRNE _0xE
	CBI  0x3,7
	RJMP _0xF
_0xE:
	SBI  0x3,7
_0xF:
; 0000 0086 
; 0000 0087                 if(data_bit==1)
	SBRS R2,0
	RJMP _0x10
; 0000 0088                 {
; 0000 0089                         if((tc==0)||(tc==2))
	LDI  R30,LOW(0)
	CP   R30,R4
	BREQ _0x12
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x11
_0x12:
; 0000 008A                         {
; 0000 008B                                 m_idx++;
	INC  R5
; 0000 008C                         }
; 0000 008D                 }
_0x11:
; 0000 008E                 else
	RJMP _0x14
_0x10:
; 0000 008F                 {
; 0000 0090                         m_idx++;
	INC  R5
; 0000 0091                 }
_0x14:
; 0000 0092 
; 0000 0093                 /*/------------------
; 0000 0094 
; 0000 0095                 //adc_buff = read_adc(FSK_IN);
; 0000 0096                 //if(adc_buff > 1)        buff = 1;
; 0000 0097                 //if(adc_buff < 2)        buff = 0;
; 0000 0098 
; 0000 0099                 if((tc==0)||((tc % 4)==0))
; 0000 009A                 {
; 0000 009B                 if(b1 ^ buff)
; 0000 009C                 {
; 0000 009D                         if(t0c < 6)
; 0000 009E                         {
; 0000 009F                                 TXD_USART_0 = 0;
; 0000 00A0                                 PTT = 0;
; 0000 00A1                                 t0c = 0;
; 0000 00A2                         }
; 0000 00A3 
; 0000 00A4                         if(t0c > 5)
; 0000 00A5                         {
; 0000 00A6                                 TXD_USART_0 = 1;
; 0000 00A7                                 PTT = 1;
; 0000 00A8                                 t0c = 0;
; 0000 00A9                         }
; 0000 00AA                 }
; 0000 00AB 
; 0000 00AC                 //TXD_USART_0 = b2 ^ buff;
; 0000 00AD                 //PTT = b2 ^ buff;
; 0000 00AE                 b3 = b2;
; 0000 00AF                 b2 = b1;
; 0000 00B0                 b1 = buff;
; 0000 00B1 
; 0000 00B2                 adc_buff = read_adc(FSK_IN);
; 0000 00B3                 if(adc_buff > 1)        buff = 1;
; 0000 00B4                 if(adc_buff < 2)        buff = 0;
; 0000 00B5 
; 0000 00B6                 buff = 0;
; 0000 00B7 
; 0000 00B8                 t0c++;
; 0000 00B9 
; 0000 00BA                 //if(adc_buff > 0)      buff = 1;
; 0000 00BB                 if(t0c > 126)   t0c = 0;
; 0000 00BC 
; 0000 00BD                 }
; 0000 00BE 
; 0000 00BF                 *///-----------------
; 0000 00C0 
; 0000 00C1                 if(tc==2)       tc = 1;
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x15
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 00C2                 else            tc++;
	RJMP _0x16
_0x15:
	INC  R4
; 0000 00C3         }
_0x16:
; 0000 00C4 
; 0000 00C5         if(mode==TERIMA)
_0x6:
	SBRC R2,5
	RJMP _0x17
; 0000 00C6         {
; 0000 00C7                 // Reinitialize Timer 0 value
; 0000 00C8                 TCNT0=0xF7;
	LDI  R30,LOW(247)
	OUT  0x32,R30
; 0000 00C9                 // Place your code here
; 0000 00CA 
; 0000 00CB                 if(b1 ^ buff)
	LDI  R26,0
	SBRC R2,2
	LDI  R26,1
	LDI  R30,0
	SBRC R2,1
	LDI  R30,1
	EOR  R30,R26
	BREQ _0x18
; 0000 00CC                 {
; 0000 00CD                         if(t0c < 6)
	LDI  R30,LOW(6)
	CP   R6,R30
	BRSH _0x19
; 0000 00CE                         {
; 0000 00CF                                 TXD_USART_0 = 0;
	CBI  0x3,1
; 0000 00D0                                 PTT = 0;
	CBI  0x12,7
; 0000 00D1                                 t0c = 0;
	CLR  R6
; 0000 00D2                         }
; 0000 00D3 
; 0000 00D4                         if(t0c > 5)
_0x19:
	LDI  R30,LOW(5)
	CP   R30,R6
	BRSH _0x1E
; 0000 00D5                         {
; 0000 00D6                                 TXD_USART_0 = 1;
	SBI  0x3,1
; 0000 00D7                                 PTT = 1;
	SBI  0x12,7
; 0000 00D8                                 t0c = 0;
	CLR  R6
; 0000 00D9                         }
; 0000 00DA                 }
_0x1E:
; 0000 00DB                 //TXD_USART_0 = b2 ^ buff;
; 0000 00DC                 //PTT = b2 ^ buff;
; 0000 00DD                 b3 = b2;
_0x18:
	BST  R2,3
	BLD  R2,4
; 0000 00DE                 b2 = b1;
	BST  R2,2
	BLD  R2,3
; 0000 00DF                 b1 = buff;
	BST  R2,1
	BLD  R2,2
; 0000 00E0 
; 0000 00E1                 buff = 0;
	CLT
	BLD  R2,1
; 0000 00E2 
; 0000 00E3                 t0c++;
	INC  R6
; 0000 00E4 
; 0000 00E5                 //if(adc_buff > 0)      buff = 1;
; 0000 00E6                 if(t0c > 126)   t0c = 0;
	LDI  R30,LOW(126)
	CP   R30,R6
	BRSH _0x23
	CLR  R6
; 0000 00E7         }
_0x23:
; 0000 00E8 }
_0x17:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00EC {
_timer1_ovf_isr:
	ST   -Y,R30
; 0000 00ED         // Place your code here
; 0000 00EE         if(mode==PANCAR)
	SBRS R2,5
	RJMP _0x24
; 0000 00EF         {
; 0000 00F0                 TCNT1H=11536 >> 8;
	LDI  R30,LOW(45)
	OUT  0x2D,R30
; 0000 00F1                 TCNT1L=11536 & 0xFF;
	LDI  R30,LOW(16)
	OUT  0x2C,R30
; 0000 00F2         }
; 0000 00F3 
; 0000 00F4         if(mode==TERIMA)
_0x24:
; 0000 00F5         {
; 0000 00F6         }
; 0000 00F7 }
	LD   R30,Y+
	RETI
;
;// Declare your global variables here
;
;void baca_sensor(char number)
; 0000 00FC {
_baca_sensor:
; 0000 00FD         char i;
; 0000 00FE 
; 0000 00FF         for(i=0;i<number;i++)
	ST   -Y,R17
;	number -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x27:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0x28
; 0000 0100         {
; 0000 0101                 if(i<6)
	CPI  R17,6
	BRSH _0x29
; 0000 0102                 {
; 0000 0103                         sensor[i] = read_adc(i);
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_sensor)
	SBCI R31,HIGH(-_sensor)
	PUSH R31
	PUSH R30
	ST   -Y,R17
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0104                 }
; 0000 0105                 else
	RJMP _0x2A
_0x29:
; 0000 0106                 {
; 0000 0107                         ADCMUX0 = (i - 6) & 0x01;
	RCALL SUBOPT_0x1
	SBIW R30,6
	ANDI R30,LOW(0x1)
	BRNE _0x2B
	CBI  0x1B,3
	RJMP _0x2C
_0x2B:
	SBI  0x1B,3
_0x2C:
; 0000 0108                         ADCMUX1 = ((i - 6) >> 1) & 0x01;
	RCALL SUBOPT_0x1
	SBIW R30,6
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x2D
	CBI  0x1B,4
	RJMP _0x2E
_0x2D:
	SBI  0x1B,4
_0x2E:
; 0000 0109                         ADCMUX2 = ((i - 6) >> 2) & 0x01;
	RCALL SUBOPT_0x1
	SBIW R30,6
	CALL __ASRW2
	ANDI R30,LOW(0x1)
	BRNE _0x2F
	CBI  0x1B,5
	RJMP _0x30
_0x2F:
	SBI  0x1B,5
_0x30:
; 0000 010A 
; 0000 010B                         delay_us(2);
	__DELAY_USB 7
; 0000 010C 
; 0000 010D                         sensor[i] = read_adc(SENSOR_EXP);
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_sensor)
	SBCI R31,HIGH(-_sensor)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 010E 
; 0000 010F                         ADCMUX0 = 0;
	CBI  0x1B,3
; 0000 0110                         ADCMUX1 = 0;
	CBI  0x1B,4
; 0000 0111                         ADCMUX2 = 0;
	CBI  0x1B,5
; 0000 0112                 }
_0x2A:
; 0000 0113         }
	SUBI R17,-1
	RJMP _0x27
_0x28:
; 0000 0114 }
	RJMP _0x2000002
;
;void proses_data_1(void)
; 0000 0117 {
_proses_data_1:
; 0000 0118         char i;
; 0000 0119 
; 0000 011A         t_value = 0;
	RCALL SUBOPT_0x2
;	i -> R17
; 0000 011B         t_value2= 0;
; 0000 011C 
; 0000 011D         data[0] = '$';
; 0000 011E 
; 0000 011F         data[1] = 'B';
; 0000 0120         data[2] = 'E';
; 0000 0121         data[3] = 'A';
; 0000 0122         data[4] = 'C';
; 0000 0123         data[5] = 'O';
; 0000 0124         data[6] = 'N';
; 0000 0125         data[7] = '2';
; 0000 0126         data[8] = '-';
; 0000 0127         data[9] = '1';
	LDI  R30,LOW(49)
	__PUTB1MN _data,9
; 0000 0128         data[10]= ',';
	LDI  R30,LOW(44)
	__PUTB1MN _data,10
; 0000 0129 
; 0000 012A         for(i=1;i<11;i++)      t_value += data[i];
	LDI  R17,LOW(1)
_0x38:
	CPI  R17,11
	BRSH _0x39
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x3
	SUBI R17,-1
	RJMP _0x38
_0x39:
; 0000 012C t_value += sensor[0];
	LDS  R30,_sensor
	RCALL SUBOPT_0x4
; 0000 012D         t_value2 += sensor[0];
	LDS  R30,_sensor
	RCALL SUBOPT_0x5
; 0000 012E         data[11]= sensor[0] / 100;      sensor[0] %= 100;       data[11] += '0';
	LDS  R26,_sensor
	RCALL SUBOPT_0x6
	__PUTB1MN _data,11
	LDS  R26,_sensor
	CLR  R27
	RCALL SUBOPT_0x7
	STS  _sensor,R30
	__GETB1MN _data,11
	SUBI R30,-LOW(48)
	__PUTB1MN _data,11
; 0000 012F         data[12]= sensor[0] / 10;                               data[12] += '0';
	LDS  R26,_sensor
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 0130         data[13]= sensor[0] % 10;                               data[13] += '0';
	LDS  R26,_sensor
	CLR  R27
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
; 0000 0131 
; 0000 0132         t_value += sensor[1];
	__GETB1MN _sensor,1
	RCALL SUBOPT_0x4
; 0000 0133         t_value2 += sensor[1];
	__GETB1MN _sensor,1
	RCALL SUBOPT_0x5
; 0000 0134         data[14]= sensor[1] / 100;      sensor[1] %= 100;       data[14] += '0';
	__GETB2MN _sensor,1
	RCALL SUBOPT_0x6
	__PUTB1MN _data,14
	__POINTW1MN _sensor,1
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 0135         data[15]= sensor[1] / 10;                               data[15] += '0';
	__GETB2MN _sensor,1
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xE
; 0000 0136         data[16]= sensor[1] % 10;                               data[16] += '0';
	__GETB2MN _sensor,1
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
; 0000 0137 
; 0000 0138         t_value += sensor[2];
	__GETB1MN _sensor,2
	RCALL SUBOPT_0x4
; 0000 0139         t_value2 += sensor[2];
	__GETB1MN _sensor,2
	RCALL SUBOPT_0x5
; 0000 013A         data[17]= sensor[2] / 100;      sensor[2] %= 100;       data[17] += '0';
	__GETB2MN _sensor,2
	RCALL SUBOPT_0x6
	__PUTB1MN _data,17
	__POINTW1MN _sensor,2
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x11
; 0000 013B         data[18]= sensor[2] / 10;                               data[18] += '0';
	__GETB2MN _sensor,2
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x12
; 0000 013C         data[19]= sensor[2] % 10;                               data[19] += '0';
	__GETB2MN _sensor,2
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x13
; 0000 013D 
; 0000 013E         t_value += sensor[3];
	__GETB1MN _sensor,3
	RCALL SUBOPT_0x4
; 0000 013F         t_value2 += sensor[3];
	__GETB1MN _sensor,3
	RCALL SUBOPT_0x5
; 0000 0140         data[20]= sensor[3] / 100;      sensor[3] %=  100;      data[20] += '0';
	__GETB2MN _sensor,3
	RCALL SUBOPT_0x6
	__PUTB1MN _data,20
	__POINTW1MN _sensor,3
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x14
; 0000 0141         data[21]= sensor[3] / 10;                               data[21] += '0';
	__GETB2MN _sensor,3
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x15
; 0000 0142         data[22]= sensor[3] % 10;                               data[22] += '0';
	__GETB2MN _sensor,3
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x16
; 0000 0143 
; 0000 0144         t_value += sensor[4];
	__GETB1MN _sensor,4
	RCALL SUBOPT_0x4
; 0000 0145         t_value2 += sensor[4];
	__GETB1MN _sensor,4
	RCALL SUBOPT_0x5
; 0000 0146         data[23]= sensor[4] / 100;      sensor[4] %=  100;      data[23] += '0';
	__GETB2MN _sensor,4
	RCALL SUBOPT_0x6
	__PUTB1MN _data,23
	__POINTW1MN _sensor,4
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x17
; 0000 0147         data[24]= sensor[4] / 10;                               data[24] += '0';
	__GETB2MN _sensor,4
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x18
; 0000 0148         data[25]= sensor[4] % 10;                               data[25] += '0';
	__GETB2MN _sensor,4
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x19
; 0000 0149 
; 0000 014A         data[26]= 'S';
; 0000 014B         t_value += data[26];
; 0000 014C 
; 0000 014D         t_value += t_value2;
	RCALL SUBOPT_0x1A
; 0000 014E         data[27]= t_value2 / 1000;       t_value2 %=  1000;      data[27] += '0';
; 0000 014F         data[28]= t_value2 / 100;        t_value2 %=  100;       data[28] += '0';
	RCALL SUBOPT_0x1B
; 0000 0150         data[29]= t_value2 / 10;                                 data[29] += '0';
; 0000 0151         data[30]= t_value2 % 10;                                 data[30] += '0';
	RCALL SUBOPT_0x1C
; 0000 0152 
; 0000 0153         data[31]= 'P';
; 0000 0154         t_value += data[31];
; 0000 0155 
; 0000 0156         data[32]= t_value / 1000;       t_value %=  1000;       data[32] += '0';
	RCALL SUBOPT_0x1D
; 0000 0157         data[33]= t_value / 100;        t_value %=  100;        data[33] += '0';
	RCALL SUBOPT_0x1E
; 0000 0158         data[34]= t_value / 10;                                 data[34] += '0';
; 0000 0159         data[35]= t_value % 10;                                 data[35] += '0';
	RCALL SUBOPT_0x1F
; 0000 015A 
; 0000 015B         data[36]= '*';
; 0000 015C 
; 0000 015D         t_value = 0;
; 0000 015E         t_value2= 0;
; 0000 015F }
	RJMP _0x2000001
;
;void proses_data_2(void)
; 0000 0162 {
_proses_data_2:
; 0000 0163         char i;
; 0000 0164 
; 0000 0165         t_value = 0;
	RCALL SUBOPT_0x2
;	i -> R17
; 0000 0166         t_value2= 0;
; 0000 0167 
; 0000 0168         data[0] = '$';
; 0000 0169 
; 0000 016A         data[1] = 'B';
; 0000 016B         data[2] = 'E';
; 0000 016C         data[3] = 'A';
; 0000 016D         data[4] = 'C';
; 0000 016E         data[5] = 'O';
; 0000 016F         data[6] = 'N';
; 0000 0170         data[7] = '2';
; 0000 0171         data[8] = '-';
; 0000 0172         data[9] = '2';
	LDI  R30,LOW(50)
	__PUTB1MN _data,9
; 0000 0173         data[10]= ',';
	LDI  R30,LOW(44)
	__PUTB1MN _data,10
; 0000 0174 
; 0000 0175         for(i=0;i<11;i++)      t_value += data[i];
	LDI  R17,LOW(0)
_0x3B:
	CPI  R17,11
	BRSH _0x3C
	RCALL SUBOPT_0x1
	RCALL SUBOPT_0x3
	SUBI R17,-1
	RJMP _0x3B
_0x3C:
; 0000 0177 t_value += sensor[5];
	__GETB1MN _sensor,5
	RCALL SUBOPT_0x4
; 0000 0178         t_value2 += sensor[5];
	__GETB1MN _sensor,5
	RCALL SUBOPT_0x5
; 0000 0179         data[11]= sensor[5] / 100;      sensor[5] %= 100;       data[11] += '0';
	__GETB2MN _sensor,5
	RCALL SUBOPT_0x6
	__PUTB1MN _data,11
	__POINTW1MN _sensor,5
	RCALL SUBOPT_0xC
	MOVW R26,R22
	ST   X,R30
	__GETB1MN _data,11
	SUBI R30,-LOW(48)
	__PUTB1MN _data,11
; 0000 017A         data[12]= sensor[5] / 10;                               data[12] += '0';
	__GETB2MN _sensor,5
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
; 0000 017B         data[13]= sensor[5] % 10;                               data[13] += '0';
	__GETB2MN _sensor,5
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xB
; 0000 017C 
; 0000 017D         t_value += sensor[6];
	__GETB1MN _sensor,6
	RCALL SUBOPT_0x4
; 0000 017E         t_value2 += sensor[6];
	__GETB1MN _sensor,6
	RCALL SUBOPT_0x5
; 0000 017F         data[14]= sensor[6] / 100;      sensor[6] %= 100;       data[14] += '0';
	__GETB2MN _sensor,6
	RCALL SUBOPT_0x6
	__PUTB1MN _data,14
	__POINTW1MN _sensor,6
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
; 0000 0180         data[15]= sensor[6] / 10;                               data[15] += '0';
	__GETB2MN _sensor,6
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0xE
; 0000 0181         data[16]= sensor[6] % 10;                               data[16] += '0';
	__GETB2MN _sensor,6
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
; 0000 0182 
; 0000 0183         t_value += sensor[7];
	__GETB1MN _sensor,7
	RCALL SUBOPT_0x4
; 0000 0184         t_value2 += sensor[7];
	__GETB1MN _sensor,7
	RCALL SUBOPT_0x5
; 0000 0185         data[17]= sensor[7] / 100;      sensor[7] %= 100;       data[17] += '0';
	__GETB2MN _sensor,7
	RCALL SUBOPT_0x6
	__PUTB1MN _data,17
	__POINTW1MN _sensor,7
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x11
; 0000 0186         data[18]= sensor[7] / 10;                               data[18] += '0';
	__GETB2MN _sensor,7
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x12
; 0000 0187         data[19]= sensor[7] % 10;                               data[19] += '0';
	__GETB2MN _sensor,7
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x13
; 0000 0188 
; 0000 0189         t_value += sensor[8];
	__GETB1MN _sensor,8
	RCALL SUBOPT_0x4
; 0000 018A         t_value2 += sensor[8];
	__GETB1MN _sensor,8
	RCALL SUBOPT_0x5
; 0000 018B         data[20]= sensor[8] / 100;      sensor[8] %=  100;      data[20] += '0';
	__GETB2MN _sensor,8
	RCALL SUBOPT_0x6
	__PUTB1MN _data,20
	__POINTW1MN _sensor,8
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x14
; 0000 018C         data[21]= sensor[8] / 10;                               data[21] += '0';
	__GETB2MN _sensor,8
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x15
; 0000 018D         data[22]= sensor[8] % 10;                               data[22] += '0';
	__GETB2MN _sensor,8
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x16
; 0000 018E 
; 0000 018F         t_value += sensor[9];
	__GETB1MN _sensor,9
	RCALL SUBOPT_0x4
; 0000 0190         t_value2 += sensor[9];
	__GETB1MN _sensor,9
	RCALL SUBOPT_0x5
; 0000 0191         data[23]= sensor[9] / 100;      sensor[9] %=  100;      data[23] += '0';
	__GETB2MN _sensor,9
	RCALL SUBOPT_0x6
	__PUTB1MN _data,23
	__POINTW1MN _sensor,9
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0x17
; 0000 0192         data[24]= sensor[9] / 10;                               data[24] += '0';
	__GETB2MN _sensor,9
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x18
; 0000 0193         data[25]= sensor[9] % 10;                               data[25] += '0';
	__GETB2MN _sensor,9
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x19
; 0000 0194 
; 0000 0195         data[26]= 'S';
; 0000 0196         t_value += data[26];
; 0000 0197 
; 0000 0198         t_value += t_value2;
	RCALL SUBOPT_0x1A
; 0000 0199         data[27]= t_value2 / 1000;       t_value2 %=  1000;      data[27] += '0';
; 0000 019A         data[28]= t_value2 / 100;        t_value2 %=  100;       data[28] += '0';
	RCALL SUBOPT_0x1B
; 0000 019B         data[29]= t_value2 / 10;                                 data[29] += '0';
; 0000 019C         data[30]= t_value2 % 10;                                 data[30] += '0';
	RCALL SUBOPT_0x1C
; 0000 019D 
; 0000 019E         data[31]= 'P';
; 0000 019F         t_value += data[31];
; 0000 01A0 
; 0000 01A1         data[32]= t_value / 1000;       t_value %=  1000;       data[32] += '0';
	RCALL SUBOPT_0x1D
; 0000 01A2         data[33]= t_value / 100;        t_value %=  100;        data[33] += '0';
	RCALL SUBOPT_0x1E
; 0000 01A3         data[34]= t_value / 10;                                 data[34] += '0';
; 0000 01A4         data[35]= t_value % 10;                                 data[35] += '0';
	RCALL SUBOPT_0x1F
; 0000 01A5 
; 0000 01A6         data[36]= '*';
; 0000 01A7 
; 0000 01A8         t_value = 0;
; 0000 01A9         t_value2= 0;
; 0000 01AA }
	RJMP _0x2000001
;
;void kirim_karakter(unsigned char c)
; 0000 01AD {
_kirim_karakter:
; 0000 01AE         char i;
; 0000 01AF 
; 0000 01B0         c = (1 << 9) + (c << 1);
	ST   -Y,R17
;	c -> Y+1
;	i -> R17
	LDD  R30,Y+1
	LSL  R30
	STD  Y+1,R30
; 0000 01B1 
; 0000 01B2         for(i=0;i<10;i++)
	LDI  R17,LOW(0)
_0x3E:
	CPI  R17,10
	BRSH _0x3F
; 0000 01B3         {
; 0000 01B4                 data_bit = (c >> i) & 0x01;
	LDD  R26,Y+1
	LDI  R27,0
	MOV  R30,R17
	CALL __ASRW12
	BST  R30,0
	BLD  R2,0
; 0000 01B5                 if(data_bit)    delay_us(DF_1200*2);
; 0000 01B6                 else            delay_us(DF_2400*2);
_0x5D:
	__DELAY_USW 2046
; 0000 01B7         }
	SUBI R17,-1
	RJMP _0x3E
_0x3F:
; 0000 01B8 
; 0000 01B9         data_bit = 1;
	SET
	BLD  R2,0
; 0000 01BA         delay_us(DF_1200*2);
	__DELAY_USW 2046
; 0000 01BB }
_0x2000002:
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void kirim_data(void)
; 0000 01BE {
_kirim_data:
; 0000 01BF         char x;
; 0000 01C0 
; 0000 01C1         for(x=0;x<37;x++)       kirim_karakter(data[x]);
	ST   -Y,R17
;	x -> R17
	LDI  R17,LOW(0)
_0x43:
	CPI  R17,37
	BRSH _0x44
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_data)
	SBCI R31,HIGH(-_data)
	LD   R30,Z
	ST   -Y,R30
	RCALL _kirim_karakter
	SUBI R17,-1
	RJMP _0x43
_0x44:
; 0000 01C2 }
_0x2000001:
	LD   R17,Y+
	RET
;
;void kirim_string(char *str)
; 0000 01C5 {
; 0000 01C6         char k;
; 0000 01C7         while (k=*str++)        kirim_karakter(k);
;	*str -> Y+1
;	k -> R17
; 0000 01C8 kirim_karakter(10);
; 0000 01C9 }
;
;void init_porta(void)
; 0000 01CC {
_init_porta:
; 0000 01CD         PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01CE         DDRA=0x38;
	LDI  R30,LOW(56)
	OUT  0x1A,R30
; 0000 01CF }
	RET
;
;void init_portc(void)
; 0000 01D2 {
_init_portc:
; 0000 01D3         PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 01D4         DDRC=0x0F;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 01D5 }
	RET
;
;void init_portd(void)
; 0000 01D8 {
_init_portd:
; 0000 01D9         PORTD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 01DA         DDRD=0x88;
	LDI  R30,LOW(136)
	OUT  0x11,R30
; 0000 01DB }
	RET
;
;void init_porte(void)
; 0000 01DE {
_init_porte:
; 0000 01DF         PORTE=0x03;
	LDI  R30,LOW(3)
	OUT  0x3,R30
; 0000 01E0         DDRE=0xF2;
	LDI  R30,LOW(242)
	OUT  0x2,R30
; 0000 01E1 }
	RET
;
;void init_portf(void)
; 0000 01E4 {
_init_portf:
; 0000 01E5         PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 01E6         DDRF=0x00;
	STS  97,R30
; 0000 01E7 }
	RET
;
;void init_portg(void)
; 0000 01EA {
_init_portg:
; 0000 01EB         PORTG=0x00;
	LDI  R30,LOW(0)
	STS  101,R30
; 0000 01EC         DDRG=0x03;
	LDI  R30,LOW(3)
	STS  100,R30
; 0000 01ED }
	RET
;
;void init_port_all(void)
; 0000 01F0 {
_init_port_all:
; 0000 01F1         init_porta();
	RCALL _init_porta
; 0000 01F2         init_portc();
	RCALL _init_portc
; 0000 01F3         init_portd();
	RCALL _init_portd
; 0000 01F4         init_porte();
	RCALL _init_porte
; 0000 01F5         init_portf();
	RCALL _init_portf
; 0000 01F6         init_portg();
	RCALL _init_portg
; 0000 01F7 }
	RET
;
;void main(void)
; 0000 01FA {
_main:
; 0000 01FB         init_port_all();
	RCALL _init_port_all
; 0000 01FC 
; 0000 01FD         if(DEBUG_2==PANCAR)     mode = PANCAR;
	SBIS 0x10,0
	RJMP _0x48
	SET
	BLD  R2,5
; 0000 01FE         if(DEBUG_2==TERIMA)     mode = TERIMA;
_0x48:
	SBIC 0x10,0
	RJMP _0x49
	CLT
	BLD  R2,5
; 0000 01FF 
; 0000 0200         if(mode==PANCAR)
_0x49:
	SBRS R2,5
	RJMP _0x4A
; 0000 0201         {
; 0000 0202                 // Timer/Counter 0 initialization
; 0000 0203                 // Clock source: System Clock
; 0000 0204                 // Clock value: 345.600 kHz
; 0000 0205                 // Mode: Normal top=0xFF
; 0000 0206                 // OC0 output: Disconnected
; 0000 0207                 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0208                 TCCR0=0x03;
	LDI  R30,LOW(3)
	OUT  0x33,R30
; 0000 0209                 TCNT0=247;
	LDI  R30,LOW(247)
	OUT  0x32,R30
; 0000 020A                 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 020B 
; 0000 020C                 // Timer/Counter 1 initialization
; 0000 020D                 // Clock source: System Clock
; 0000 020E                 // Clock value: 10.800 kHz
; 0000 020F                 // Mode: Normal top=0xFFFF
; 0000 0210                 // OC1A output: Discon.
; 0000 0211                 // OC1B output: Discon.
; 0000 0212                 // OC1C output: Discon.
; 0000 0213                 // Noise Canceler: Off
; 0000 0214                 // Input Capture on Falling Edge
; 0000 0215                 // Timer1 Overflow Interrupt: On
; 0000 0216                 // Input Capture Interrupt: Off
; 0000 0217                 // Compare A Match Interrupt: Off
; 0000 0218                 // Compare B Match Interrupt: Off
; 0000 0219                 // Compare C Match Interrupt: Off
; 0000 021A                 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 021B                 TCCR1B=0; //0x05;
	OUT  0x2E,R30
; 0000 021C                 TCNT1H=11536 >> 8;
	LDI  R30,LOW(45)
	OUT  0x2D,R30
; 0000 021D                 TCNT1L=11536 & 0xFF;
	LDI  R30,LOW(16)
	OUT  0x2C,R30
; 0000 021E 
; 0000 021F                 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0220                 TIMSK=0x01; //0x05;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 0221 
; 0000 0222                 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 0223 
; 0000 0224                 // ADC initialization
; 0000 0225                 // ADC Clock frequency: 691.200 kHz
; 0000 0226                 // ADC Voltage Reference: AREF pin
; 0000 0227                 // Only the 8 most significant bits of
; 0000 0228                 // the AD conversion result are used
; 0000 0229                 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 022A                 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 022B 
; 0000 022C                 // Global enable interrupts
; 0000 022D                 #asm("sei")
	sei
; 0000 022E 
; 0000 022F                 data_bit = 1;
	SET
	BLD  R2,0
; 0000 0230 
; 0000 0231                 while (1)
_0x4B:
; 0000 0232                 {
; 0000 0233                         // Place your code here
; 0000 0234                         baca_sensor(jumlah_sensor);
	ST   -Y,R7
	RCALL _baca_sensor
; 0000 0235                         proses_data_1();
	RCALL _proses_data_1
; 0000 0236 
; 0000 0237                         PTT = 1;
	RCALL SUBOPT_0x20
; 0000 0238                         TCCR0=0x03;
; 0000 0239 
; 0000 023A                         delay_ms(250);
; 0000 023B 
; 0000 023C                         kirim_karakter(13);
; 0000 023D                         kirim_data();
; 0000 023E                         kirim_karakter(13);
; 0000 023F                         kirim_data();
; 0000 0240                         kirim_karakter(13);
; 0000 0241                         kirim_data();
; 0000 0242                         kirim_karakter(13);
; 0000 0243 
; 0000 0244                         TCCR0=0x00;
; 0000 0245                         PTT = 0;
; 0000 0246 
; 0000 0247                         delay_ms(7000);
; 0000 0248 
; 0000 0249                         baca_sensor(jumlah_sensor);
	ST   -Y,R7
	RCALL _baca_sensor
; 0000 024A                         proses_data_2();
	RCALL _proses_data_2
; 0000 024B 
; 0000 024C                         PTT = 1;
	RCALL SUBOPT_0x20
; 0000 024D                         TCCR0=0x03;
; 0000 024E 
; 0000 024F                         delay_ms(250);
; 0000 0250 
; 0000 0251                         kirim_karakter(13);
; 0000 0252                         kirim_data();
; 0000 0253                         kirim_karakter(13);
; 0000 0254                         kirim_data();
; 0000 0255                         kirim_karakter(13);
; 0000 0256                         kirim_data();
; 0000 0257                         kirim_karakter(13);
; 0000 0258 
; 0000 0259                         TCCR0=0x00;
; 0000 025A                         PTT = 0;
; 0000 025B 
; 0000 025C                         delay_ms(7000);
; 0000 025D                 }
	RJMP _0x4B
; 0000 025E         }
; 0000 025F 
; 0000 0260         if(mode==TERIMA)
_0x4A:
	SBRC R2,5
	RJMP _0x56
; 0000 0261         {
; 0000 0262                 // Timer/Counter 0 initialization
; 0000 0263                 // Clock source: System Clock
; 0000 0264                 // Clock value: 86.400 kHz
; 0000 0265                 // Mode: Normal top=0xFF
; 0000 0266                 // OC0 output: Disconnected
; 0000 0267                 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0268                 TCCR0=0x04;
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 0269                 TCNT0=0xF7;
	LDI  R30,LOW(247)
	OUT  0x32,R30
; 0000 026A                 OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x31,R30
; 0000 026B 
; 0000 026C                 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 026D                 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x37,R30
; 0000 026E 
; 0000 026F                 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 0270 
; 0000 0271                 // USART0 initialization
; 0000 0272                 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0273                 // USART0 Receiver: On
; 0000 0274                 // USART0 Transmitter: On
; 0000 0275                 // USART0 Mode: Asynchronous
; 0000 0276                 // USART0 Baud Rate: 9600
; 0000 0277                 UCSR0A=0; //x00;
	OUT  0xB,R30
; 0000 0278                 UCSR0B=0; //x18;
	OUT  0xA,R30
; 0000 0279                 UCSR0C=0; //x06;
	STS  149,R30
; 0000 027A                 UBRR0H=0; //x00;
	STS  144,R30
; 0000 027B                 UBRR0L=0; //x47;
	OUT  0x9,R30
; 0000 027C 
; 0000 027D                 // Analog Comparator initialization
; 0000 027E                 // Analog Comparator: Off
; 0000 027F                 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0280                 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0281                 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0282 
; 0000 0283                 // ADC initialization
; 0000 0284                 // ADC Clock frequency: 691.200 kHz
; 0000 0285                 // ADC Voltage Reference: AREF pin
; 0000 0286                 // Only the 8 most significant bits of
; 0000 0287                 // the AD conversion result are used
; 0000 0288                 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0289                 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 028A 
; 0000 028B                 // Global enable interrupts
; 0000 028C                 #asm("sei")
	sei
; 0000 028D 
; 0000 028E                 while (1)
_0x57:
; 0000 028F                 {
; 0000 0290                         // Place your code here
; 0000 0291                         adc_buff = read_adc(FSK_IN);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R10,R30
	CLR  R11
; 0000 0292                         if(adc_buff > 0)        buff = 1;
	CLR  R0
	CP   R0,R10
	CPC  R0,R11
	BRSH _0x5A
	SET
	BLD  R2,1
; 0000 0293                         if(adc_buff < 1)        buff = 0;
_0x5A:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CP   R10,R30
	CPC  R11,R31
	BRSH _0x5B
	CLT
	BLD  R2,1
; 0000 0294 
; 0000 0295                 }
_0x5B:
	RJMP _0x57
; 0000 0296         }
; 0000 0297 }
_0x56:
_0x5C:
	RJMP _0x5C

	.DSEG
_data:
	.BYTE 0x64
_sensor:
	.BYTE 0x14

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x0:
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_matrix*2)
	SBCI R31,HIGH(-_matrix*2)
	LPM  R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x2:
	ST   -Y,R17
	CLR  R8
	CLR  R9
	CLR  R12
	CLR  R13
	LDI  R30,LOW(36)
	STS  _data,R30
	LDI  R30,LOW(66)
	__PUTB1MN _data,1
	LDI  R30,LOW(69)
	__PUTB1MN _data,2
	LDI  R30,LOW(65)
	__PUTB1MN _data,3
	LDI  R30,LOW(67)
	__PUTB1MN _data,4
	LDI  R30,LOW(79)
	__PUTB1MN _data,5
	LDI  R30,LOW(78)
	__PUTB1MN _data,6
	LDI  R30,LOW(50)
	__PUTB1MN _data,7
	LDI  R30,LOW(45)
	__PUTB1MN _data,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	SUBI R30,LOW(-_data)
	SBCI R31,HIGH(-_data)
	LD   R30,Z
	LDI  R31,0
	__ADDWRR 8,9,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x4:
	LDI  R31,0
	__ADDWRR 8,9,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x5:
	LDI  R31,0
	__ADDWRR 12,13,30,31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x6:
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x8:
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	__PUTB1MN _data,12
	__GETB1MN _data,12
	SUBI R30,-LOW(48)
	__PUTB1MN _data,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	__PUTB1MN _data,13
	__GETB1MN _data,13
	SUBI R30,-LOW(48)
	__PUTB1MN _data,13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xC:
	MOVW R22,R30
	LD   R26,Z
	LDI  R27,0
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xD:
	MOVW R26,R22
	ST   X,R30
	__GETB1MN _data,14
	SUBI R30,-LOW(48)
	__PUTB1MN _data,14
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	__PUTB1MN _data,15
	__GETB1MN _data,15
	SUBI R30,-LOW(48)
	__PUTB1MN _data,15
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xF:
	LDI  R27,0
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x10:
	__PUTB1MN _data,16
	__GETB1MN _data,16
	SUBI R30,-LOW(48)
	__PUTB1MN _data,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x11:
	MOVW R26,R22
	ST   X,R30
	__GETB1MN _data,17
	SUBI R30,-LOW(48)
	__PUTB1MN _data,17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	__PUTB1MN _data,18
	__GETB1MN _data,18
	SUBI R30,-LOW(48)
	__PUTB1MN _data,18
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x13:
	__PUTB1MN _data,19
	__GETB1MN _data,19
	SUBI R30,-LOW(48)
	__PUTB1MN _data,19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	MOVW R26,R22
	ST   X,R30
	__GETB1MN _data,20
	SUBI R30,-LOW(48)
	__PUTB1MN _data,20
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	__PUTB1MN _data,21
	__GETB1MN _data,21
	SUBI R30,-LOW(48)
	__PUTB1MN _data,21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	__PUTB1MN _data,22
	__GETB1MN _data,22
	SUBI R30,-LOW(48)
	__PUTB1MN _data,22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x17:
	MOVW R26,R22
	ST   X,R30
	__GETB1MN _data,23
	SUBI R30,-LOW(48)
	__PUTB1MN _data,23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x18:
	__PUTB1MN _data,24
	__GETB1MN _data,24
	SUBI R30,-LOW(48)
	__PUTB1MN _data,24
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x19:
	__PUTB1MN _data,25
	__GETB1MN _data,25
	SUBI R30,-LOW(48)
	__PUTB1MN _data,25
	LDI  R30,LOW(83)
	__PUTB1MN _data,26
	__GETB1MN _data,26
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x1A:
	__ADDWRR 8,9,12,13
	MOVW R26,R12
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	__PUTB1MN _data,27
	MOVW R26,R12
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	MOVW R12,R30
	__GETB1MN _data,27
	SUBI R30,-LOW(48)
	__PUTB1MN _data,27
	MOVW R26,R12
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	__PUTB1MN _data,28
	MOVW R26,R12
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1B:
	MOVW R12,R30
	__GETB1MN _data,28
	SUBI R30,-LOW(48)
	__PUTB1MN _data,28
	MOVW R26,R12
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	__PUTB1MN _data,29
	__GETB1MN _data,29
	SUBI R30,-LOW(48)
	__PUTB1MN _data,29
	MOVW R26,R12
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	__PUTB1MN _data,30
	__GETB1MN _data,30
	SUBI R30,-LOW(48)
	__PUTB1MN _data,30
	LDI  R30,LOW(80)
	__PUTB1MN _data,31
	__GETB1MN _data,31
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x1D:
	MOVW R26,R8
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __DIVW21
	__PUTB1MN _data,32
	MOVW R26,R8
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL __MODW21
	MOVW R8,R30
	__GETB1MN _data,32
	SUBI R30,-LOW(48)
	__PUTB1MN _data,32
	MOVW R26,R8
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	__PUTB1MN _data,33
	MOVW R26,R8
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x1E:
	MOVW R8,R30
	__GETB1MN _data,33
	SUBI R30,-LOW(48)
	__PUTB1MN _data,33
	MOVW R26,R8
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	__PUTB1MN _data,34
	__GETB1MN _data,34
	SUBI R30,-LOW(48)
	__PUTB1MN _data,34
	MOVW R26,R8
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	__PUTB1MN _data,35
	__GETB1MN _data,35
	SUBI R30,-LOW(48)
	__PUTB1MN _data,35
	LDI  R30,LOW(42)
	__PUTB1MN _data,36
	CLR  R8
	CLR  R9
	CLR  R12
	CLR  R13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x20:
	SBI  0x12,7
	LDI  R30,LOW(3)
	OUT  0x33,R30
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _kirim_karakter
	RCALL _kirim_data
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _kirim_karakter
	RCALL _kirim_data
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _kirim_karakter
	RCALL _kirim_data
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _kirim_karakter
	LDI  R30,LOW(0)
	OUT  0x33,R30
	CBI  0x12,7
	LDI  R30,LOW(7000)
	LDI  R31,HIGH(7000)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xACD
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

__ASRW3:
	ASR  R31
	ROR  R30
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

;END OF CODE MARKER
__END_OF_CODE:
