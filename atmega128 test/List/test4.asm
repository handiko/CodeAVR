
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
	.DEF _rx_wr_index0=R5
	.DEF _rx_rd_index0=R4
	.DEF _rx_counter0=R7
	.DEF _tx_wr_index0=R6
	.DEF _tx_rd_index0=R9
	.DEF _tx_counter0=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
	JMP  _ext_int1_isr
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
	JMP  0x00
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
	.DW  0x0004

_0x2C:
	.DB  0x6E,0x79,0x61,0x6C,0x61
_0x2D:
	.DB  0x6D,0x61,0x74,0x69,0x69
_0x0:
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x0
	.DB  0x23,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x23,0x0
	.DB  0x23,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A
	.DB  0x3A,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A
	.DB  0x3A,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A
	.DB  0x3A,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A
	.DB  0x3A,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A
	.DB  0x3A,0x3A,0x3A,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x23,0x0
	.DB  0x23,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A
	.DB  0x3A,0x3A,0x3A,0x3A,0x3A,0x3A,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x3A
	.DB  0x3A,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A,0x3A
	.DB  0x3A,0x3A,0x3A,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x23,0x0
	.DB  0x23,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x5B,0x20,0x20,0x20,0x20,0x43
	.DB  0x6F,0x6F,0x6C,0x20,0x45,0x64,0x69,0x74
	.DB  0x20,0x50,0x72,0x6F,0x20,0x76,0x32,0x2E
	.DB  0x31,0x20,0x42,0x75,0x69,0x6C,0x64,0x20
	.DB  0x33,0x30,0x39,0x37,0x2E,0x30,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x23,0x0
	.DB  0x23,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x3E,0x52,0x65
	.DB  0x67,0x69,0x73,0x74,0x72,0x61,0x74,0x69
	.DB  0x6F,0x6E,0x20,0x66,0x6F,0x72,0x20,0x57
	.DB  0x69,0x6E,0x39,0x38,0x2F,0x4D,0x45,0x2F
	.DB  0x32,0x30,0x30,0x30,0x2F,0x58,0x50,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x23,0x0
	.DB  0x23,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x3E,0x50,0x72
	.DB  0x6F,0x74,0x65,0x63,0x74,0x69,0x6F,0x6E
	.DB  0x3A,0x20,0x54,0x72,0x69,0x61,0x6C,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x23,0x0
	.DB  0x23,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x3E,0x52,0x65
	.DB  0x6C,0x65,0x61,0x73,0x65,0x20,0x44,0x61
	.DB  0x74,0x65,0x3A,0x20,0x31,0x37,0x2D,0x30
	.DB  0x34,0x2D,0x32,0x30,0x30,0x33,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x23,0x0
	.DB  0x23,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x3E,0x53,0x69
	.DB  0x74,0x65,0x3A,0x20,0x68,0x74,0x74,0x70
	.DB  0x3A,0x2F,0x2F,0x77,0x77,0x77,0x2E,0x73
	.DB  0x79,0x6E,0x74,0x72,0x69,0x6C,0x6C,0x69
	.DB  0x75,0x6D,0x2E,0x63,0x6F,0x6D,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x23,0x0
	.DB  0x23,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x5B,0x20,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D,0x3D
	.DB  0x3D,0x20,0x5D,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x23,0x0
	.DB  0x23,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x5B,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x62,0x79,0x20
	.DB  0x43,0x72,0x61,0x63,0x6B,0x20,0x44,0x65
	.DB  0x6D,0x6F,0x6E,0x20,0x32,0x30,0x30,0x33
	.DB  0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x2D,0x5D,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x23,0x0
	.DB  0x45,0x4E,0x54,0x45,0x52,0x20,0x53,0x45
	.DB  0x54,0x20,0x4D,0x4F,0x44,0x45,0x0,0x20
	.DB  0x59,0x20,0x2F,0x20,0x4E,0x0,0x2D,0x2D
	.DB  0x3E,0x0,0x4C,0x45,0x44,0x20,0x54,0x45
	.DB  0x4C,0x41,0x48,0x20,0x44,0x49,0x4E,0x59
	.DB  0x41,0x4C,0x41,0x4B,0x41,0x4E,0x0,0x4C
	.DB  0x45,0x44,0x20,0x54,0x45,0x4C,0x41,0x48
	.DB  0x20,0x44,0x49,0x4D,0x41,0x54,0x49,0x4B
	.DB  0x41,0x4E,0x0,0x61,0x68,0x68,0x61,0x68
	.DB  0x61,0x68,0x61,0x68,0x61,0x68,0x61,0x68
	.DB  0x61,0x68,0x61,0x68,0x68,0x61,0x0,0x6B
	.DB  0x61,0x6B,0x61,0x6B,0x6B,0x61,0x6B,0x61
	.DB  0x6B,0x61,0x6B,0x61,0x6B,0x6B,0x61,0x6B
	.DB  0x61,0x6B,0x61,0x6B,0x61,0x6B,0x6B,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x14
	.DW  _0x35
	.DW  _0x0*2+1123

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
;Date    : 9/28/2013
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
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 001D {

	.CSEG
_ext_int0_isr:
; 0000 001E // Place your code here
; 0000 001F     PORTD.7 = 1;
; 0000 0020     delay_ms(1000);
; 0000 0021     PORTD.7 = 0;
; 0000 0022 }
;
;// External Interrupt 1 service routine
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0026 {
_ext_int1_isr:
_0x38:
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
; 0000 0027 // Place your code here
; 0000 0028     PORTD.7 = 1;
	SBI  0x12,7
; 0000 0029     delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 002A     PORTD.7 = 0;
	CBI  0x12,7
; 0000 002B }
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
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 005E {
_usart0_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 005F char status,data;
; 0000 0060 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0061 data=UDR0;
	IN   R16,12
; 0000 0062 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0xB
; 0000 0063    {
; 0000 0064    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0065 #if RX_BUFFER_SIZE0 == 256
; 0000 0066    // special case for receiver buffer size=256
; 0000 0067    if (++rx_counter0 == 0)
; 0000 0068       {
; 0000 0069 #else
; 0000 006A    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0xC
	CLR  R5
; 0000 006B    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0xC:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0xD
; 0000 006C       {
; 0000 006D       rx_counter0=0;
	CLR  R7
; 0000 006E #endif
; 0000 006F       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 0070       }
; 0000 0071    }
_0xD:
; 0000 0072 }
_0xB:
	LD   R16,Y+
	LD   R17,Y+
	RJMP _0x37
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0079 {
_getchar:
; 0000 007A char data;
; 0000 007B while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0xE:
	TST  R7
	BREQ _0xE
; 0000 007C data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 007D #if RX_BUFFER_SIZE0 != 256
; 0000 007E if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0x11
	CLR  R4
; 0000 007F #endif
; 0000 0080 #asm("cli")
_0x11:
	cli
; 0000 0081 --rx_counter0;
	DEC  R7
; 0000 0082 #asm("sei")
	sei
; 0000 0083 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0084 }
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 8
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
;#else
;unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 0094 {
_usart0_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0095 if (tx_counter0)
	TST  R8
	BREQ _0x12
; 0000 0096    {
; 0000 0097    --tx_counter0;
	DEC  R8
; 0000 0098    UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0099 #if TX_BUFFER_SIZE0 != 256
; 0000 009A    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x13
	CLR  R9
; 0000 009B #endif
; 0000 009C    }
_0x13:
; 0000 009D }
_0x12:
_0x37:
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
; 0000 00A4 {
_putchar:
; 0000 00A5 while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
_0x14:
	LDI  R30,LOW(8)
	CP   R30,R8
	BREQ _0x14
; 0000 00A6 #asm("cli")
	cli
; 0000 00A7 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R8
	BRNE _0x18
	SBIC 0xB,5
	RJMP _0x17
_0x18:
; 0000 00A8    {
; 0000 00A9    tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00AA #if TX_BUFFER_SIZE0 != 256
; 0000 00AB    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x1A
	CLR  R6
; 0000 00AC #endif
; 0000 00AD    ++tx_counter0;
_0x1A:
	INC  R8
; 0000 00AE    }
; 0000 00AF else
	RJMP _0x1B
_0x17:
; 0000 00B0    UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00B1 #asm("sei")
_0x1B:
	sei
; 0000 00B2 }
	RJMP _0x2060002
;#pragma used-
;#endif
;
;// Get a character from the USART1 Receiver
;#pragma used+
;char getchar1(void)
; 0000 00B9 {
; 0000 00BA char status,data;
; 0000 00BB while (1)
;	status -> R17
;	data -> R16
; 0000 00BC       {
; 0000 00BD       while (((status=UCSR1A) & RX_COMPLETE)==0);
; 0000 00BE       data=UDR1;
; 0000 00BF       if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
; 0000 00C0          return data;
; 0000 00C1       }
; 0000 00C2 }
;#pragma used-
;
;// Write a character to the USART1 Transmitter
;#pragma used+
;void putchar1(char c)
; 0000 00C8 {
_putchar1:
; 0000 00C9 while ((UCSR1A & DATA_REGISTER_EMPTY)==0);
;	c -> Y+0
_0x23:
	LDS  R30,155
	ANDI R30,LOW(0x20)
	BREQ _0x23
; 0000 00CA UDR1=c;
	LD   R30,Y
	STS  156,R30
; 0000 00CB }
_0x2060002:
	ADIW R28,1
	RET
;#pragma used-
;
;// Standard Input/Output functions
;#include <stdio.h>
;#include <string.h>
;
;bit status;
;bit output = 1;
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00D7 {
_timer1_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 00D8 // Reinitialize Timer1 value
; 0000 00D9 TCNT1H=0xEE56 >> 8;
	LDI  R30,LOW(238)
	OUT  0x2D,R30
; 0000 00DA TCNT1L=0xEE56 & 0xff;
	LDI  R30,LOW(86)
	OUT  0x2C,R30
; 0000 00DB // Place your code here
; 0000 00DC     if(status)
	SBRS R2,1
	RJMP _0x26
; 0000 00DD     {
; 0000 00DE         output = ~output;
	LDI  R30,LOW(4)
	EOR  R2,R30
; 0000 00DF         PORTD.7 = output;
	SBRC R2,2
	RJMP _0x27
	CBI  0x12,7
	RJMP _0x28
_0x27:
	SBI  0x12,7
_0x28:
; 0000 00E0     }
; 0000 00E1     if(!status)
_0x26:
	SBRS R2,1
; 0000 00E2     {
; 0000 00E3         PORTD.7 = 0;
	CBI  0x12,7
; 0000 00E4     }
; 0000 00E5 
; 0000 00E6 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;
;// Declare your global variables here
;char string[6];
;char string_n[6] = "nyala";

	.DSEG
;char string_m[6] = "matii";
;
;void setting(void)
; 0000 00EF {

	.CSEG
_setting:
; 0000 00F0     char k;
; 0000 00F1 
; 0000 00F2     putchar(13);
	ST   -Y,R17
;	k -> R17
	CALL SUBOPT_0x0
; 0000 00F3     putchar1(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _putchar1
; 0000 00F4 
; 0000 00F5     putsf("###############################################################################################");putchar(13);
	CALL SUBOPT_0x1
; 0000 00F6     putsf("#                                                                                             #");putchar(13);
	CALL SUBOPT_0x2
; 0000 00F7     putsf("#                                                                                             #");putchar(13);
	CALL SUBOPT_0x2
; 0000 00F8     putsf("#                                                                                             #");putchar(13);
	CALL SUBOPT_0x2
; 0000 00F9     putsf("#                                                                                             #");putchar(13);
	CALL SUBOPT_0x2
; 0000 00FA     putsf("#                 :::::::::::::::::::::::::::::::::::::::::                                   #");putchar(13);
	CALL SUBOPT_0x3
; 0000 00FB     putsf("#                 ::::::::::::$$$$$$$$$$$$$$$$$::::::::::::                                   #");putchar(13);
	CALL SUBOPT_0x4
; 0000 00FC     putsf("#                 [    Cool Edit Pro v2.1 Build 3097.0                                        #");putchar(13);
	__POINTW1FN _0x0,384
	CALL SUBOPT_0x5
; 0000 00FD     putsf("#                    >Registration for Win98/ME/2000/XP                                       #");putchar(13);
	__POINTW1FN _0x0,480
	CALL SUBOPT_0x5
; 0000 00FE     putsf("#                    >Protection: Trial                                                       #");putchar(13);
	__POINTW1FN _0x0,576
	CALL SUBOPT_0x5
; 0000 00FF     putsf("#                    >Release Date: 17-04-2003                                                #");putchar(13);
	__POINTW1FN _0x0,672
	CALL SUBOPT_0x5
; 0000 0100     putsf("#                    >Site: http://www.syntrillium.com                                        #");putchar(13);
	__POINTW1FN _0x0,768
	CALL SUBOPT_0x5
; 0000 0101     putsf("#                 [ ===================================== ]                                   #");putchar(13);
	__POINTW1FN _0x0,864
	CALL SUBOPT_0x5
; 0000 0102     putsf("#                 [----------by Crack Demon 2003----------]                                   #");putchar(13);
	__POINTW1FN _0x0,960
	CALL SUBOPT_0x5
; 0000 0103     putsf("#                 [ ===================================== ]                                   #");putchar(13);
	__POINTW1FN _0x0,864
	CALL SUBOPT_0x5
; 0000 0104     putsf("#                 :::::::::::::::::::::::::::::::::::::::::                                   #");putchar(13);
	CALL SUBOPT_0x3
; 0000 0105     putsf("#                 ::::::::::::$$$$$$$$$$$$$$$$$::::::::::::                                   #");putchar(13);
	CALL SUBOPT_0x4
; 0000 0106     putsf("#                                                                                             #");putchar(13);
	CALL SUBOPT_0x2
; 0000 0107     putsf("#                                                                                             #");putchar(13);
	CALL SUBOPT_0x2
; 0000 0108     putsf("#                                                                                             #");putchar(13);
	CALL SUBOPT_0x2
; 0000 0109     putsf("#                                                                                             #");putchar(13);
	CALL SUBOPT_0x2
; 0000 010A     putsf("###############################################################################################");putchar(13);
	CALL SUBOPT_0x1
; 0000 010B 
; 0000 010C     ulang :
_0x2E:
; 0000 010D 
; 0000 010E     putchar(13);
	CALL SUBOPT_0x0
; 0000 010F     putsf("ENTER SET MODE");putchar(13);
	__POINTW1FN _0x0,1056
	CALL SUBOPT_0x5
; 0000 0110     putchar(13);
	CALL SUBOPT_0x0
; 0000 0111     putsf(" Y / N");putchar(13);
	__POINTW1FN _0x0,1071
	CALL SUBOPT_0x5
; 0000 0112     putchar(13);
	CALL SUBOPT_0x0
; 0000 0113     putsf("-->");
	__POINTW1FN _0x0,1078
	ST   -Y,R31
	ST   -Y,R30
	RCALL _putsf
; 0000 0114 
; 0000 0115     k =getchar();
	RCALL _getchar
	MOV  R17,R30
; 0000 0116     putchar(k);putchar(13);
	ST   -Y,R17
	RCALL _putchar
	CALL SUBOPT_0x0
; 0000 0117     putchar(13);
	CALL SUBOPT_0x0
; 0000 0118     if(k == 'Y')
	CPI  R17,89
	BRNE _0x2F
; 0000 0119     {
; 0000 011A         status = 1;
	SET
	BLD  R2,1
; 0000 011B         putchar(13);
	CALL SUBOPT_0x0
; 0000 011C         putsf("LED TELAH DINYALAKAN");putchar(13);
	__POINTW1FN _0x0,1082
	CALL SUBOPT_0x5
; 0000 011D         putchar(13);
	CALL SUBOPT_0x0
; 0000 011E     }
; 0000 011F     if(k == 'N')
_0x2F:
	CPI  R17,78
	BRNE _0x30
; 0000 0120     {
; 0000 0121         status = 0;
	CLT
	BLD  R2,1
; 0000 0122         putchar(13);
	CALL SUBOPT_0x0
; 0000 0123         putsf("LED TELAH DIMATIKAN");putchar(13);
	__POINTW1FN _0x0,1103
	CALL SUBOPT_0x5
; 0000 0124         putchar(13);
	CALL SUBOPT_0x0
; 0000 0125     }
; 0000 0126 
; 0000 0127     goto ulang;
_0x30:
	RJMP _0x2E
; 0000 0128 }
;
;void main(void)
; 0000 012B {
_main:
; 0000 012C // Declare your local variables here
; 0000 012D 
; 0000 012E // Input/Output Ports initialization
; 0000 012F // Port A initialization
; 0000 0130 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0131 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0132 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0133 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0134 
; 0000 0135 // Port B initialization
; 0000 0136 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0137 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0138 PORTB=0x00;
	OUT  0x18,R30
; 0000 0139 DDRB=0x00;
	OUT  0x17,R30
; 0000 013A 
; 0000 013B // Port C initialization
; 0000 013C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 013D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 013E PORTC=0x00;
	OUT  0x15,R30
; 0000 013F DDRC=0x00;
	OUT  0x14,R30
; 0000 0140 
; 0000 0141 // Port D initialization
; 0000 0142 // Func7=Out Func6=In Func5=In Func4=In Func3=Out Func2=In Func1=In Func0=In
; 0000 0143 // State7=0 State6=T State5=T State4=T State3=1 State2=P State1=P State0=P
; 0000 0144 PORTD=0x0F;
	LDI  R30,LOW(15)
	OUT  0x12,R30
; 0000 0145 DDRD=0x88;
	LDI  R30,LOW(136)
	OUT  0x11,R30
; 0000 0146 
; 0000 0147 // Port E initialization
; 0000 0148 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
; 0000 0149 // State7=T State6=T State5=T State4=T State3=T State2=T State1=1 State0=P
; 0000 014A PORTE=0x03;
	LDI  R30,LOW(3)
	OUT  0x3,R30
; 0000 014B DDRE=0x02;
	LDI  R30,LOW(2)
	OUT  0x2,R30
; 0000 014C 
; 0000 014D // Port F initialization
; 0000 014E // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 014F // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0150 PORTF=0x00;
	LDI  R30,LOW(0)
	STS  98,R30
; 0000 0151 DDRF=0x00;
	STS  97,R30
; 0000 0152 
; 0000 0153 // Port G initialization
; 0000 0154 // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0155 // State4=T State3=T State2=T State1=T State0=T
; 0000 0156 PORTG=0x00;
	STS  101,R30
; 0000 0157 DDRG=0x00;
	STS  100,R30
; 0000 0158 
; 0000 0159 // Timer/Counter 0 initialization
; 0000 015A // Clock source: System Clock
; 0000 015B // Clock value: Timer 0 Stopped
; 0000 015C // Mode: Normal top=0xFF
; 0000 015D // OC0 output: Disconnected
; 0000 015E ASSR=0x00;
	OUT  0x30,R30
; 0000 015F TCCR0=0x00;
	OUT  0x33,R30
; 0000 0160 TCNT0=0x00;
	OUT  0x32,R30
; 0000 0161 OCR0=0x00;
	OUT  0x31,R30
; 0000 0162 
; 0000 0163 // Timer/Counter 1 initialization
; 0000 0164 // Clock source: System Clock
; 0000 0165 // Clock value: 10.800 kHz
; 0000 0166 // Mode: Normal top=0xFFFF
; 0000 0167 // OC1A output: Discon.
; 0000 0168 // OC1B output: Discon.
; 0000 0169 // OC1C output: Discon.
; 0000 016A // Noise Canceler: Off
; 0000 016B // Input Capture on Falling Edge
; 0000 016C // Timer1 Overflow Interrupt: On
; 0000 016D // Input Capture Interrupt: Off
; 0000 016E // Compare A Match Interrupt: Off
; 0000 016F // Compare B Match Interrupt: Off
; 0000 0170 // Compare C Match Interrupt: Off
; 0000 0171 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0172 TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 0173 TCNT1H=0xAA;
	LDI  R30,LOW(170)
	OUT  0x2D,R30
; 0000 0174 TCNT1L=0x56;
	LDI  R30,LOW(86)
	OUT  0x2C,R30
; 0000 0175 ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 0176 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0177 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0178 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0179 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 017A OCR1BL=0x00;
	OUT  0x28,R30
; 0000 017B OCR1CH=0x00;
	STS  121,R30
; 0000 017C OCR1CL=0x00;
	STS  120,R30
; 0000 017D 
; 0000 017E // Timer/Counter 2 initialization
; 0000 017F // Clock source: System Clock
; 0000 0180 // Clock value: Timer2 Stopped
; 0000 0181 // Mode: Normal top=0xFF
; 0000 0182 // OC2 output: Disconnected
; 0000 0183 TCCR2=0x00;
	OUT  0x25,R30
; 0000 0184 TCNT2=0x00;
	OUT  0x24,R30
; 0000 0185 OCR2=0x00;
	OUT  0x23,R30
; 0000 0186 
; 0000 0187 // Timer/Counter 3 initialization
; 0000 0188 // Clock source: System Clock
; 0000 0189 // Clock value: Timer3 Stopped
; 0000 018A // Mode: Normal top=0xFFFF
; 0000 018B // OC3A output: Discon.
; 0000 018C // OC3B output: Discon.
; 0000 018D // OC3C output: Discon.
; 0000 018E // Noise Canceler: Off
; 0000 018F // Input Capture on Falling Edge
; 0000 0190 // Timer3 Overflow Interrupt: Off
; 0000 0191 // Input Capture Interrupt: Off
; 0000 0192 // Compare A Match Interrupt: Off
; 0000 0193 // Compare B Match Interrupt: Off
; 0000 0194 // Compare C Match Interrupt: Off
; 0000 0195 TCCR3A=0x00;
	STS  139,R30
; 0000 0196 TCCR3B=0x00;
	STS  138,R30
; 0000 0197 TCNT3H=0x00;
	STS  137,R30
; 0000 0198 TCNT3L=0x00;
	STS  136,R30
; 0000 0199 ICR3H=0x00;
	STS  129,R30
; 0000 019A ICR3L=0x00;
	STS  128,R30
; 0000 019B OCR3AH=0x00;
	STS  135,R30
; 0000 019C OCR3AL=0x00;
	STS  134,R30
; 0000 019D OCR3BH=0x00;
	STS  133,R30
; 0000 019E OCR3BL=0x00;
	STS  132,R30
; 0000 019F OCR3CH=0x00;
	STS  131,R30
; 0000 01A0 OCR3CL=0x00;
	STS  130,R30
; 0000 01A1 
; 0000 01A2 // External Interrupt(s) initialization
; 0000 01A3 // INT0: On
; 0000 01A4 // INT0 Mode: Low level
; 0000 01A5 // INT1: On
; 0000 01A6 // INT1 Mode: Low level
; 0000 01A7 // INT2: Off
; 0000 01A8 // INT3: Off
; 0000 01A9 // INT4: Off
; 0000 01AA // INT5: Off
; 0000 01AB // INT6: Off
; 0000 01AC // INT7: Off
; 0000 01AD EICRA=0x00;
	STS  106,R30
; 0000 01AE EICRB=0x00;
	OUT  0x3A,R30
; 0000 01AF EIMSK=0x03;
	LDI  R30,LOW(3)
	OUT  0x39,R30
; 0000 01B0 EIFR=0x03;
	OUT  0x38,R30
; 0000 01B1 
; 0000 01B2 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 01B3 TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x37,R30
; 0000 01B4 
; 0000 01B5 ETIMSK=0x00;
	LDI  R30,LOW(0)
	STS  125,R30
; 0000 01B6 
; 0000 01B7 // USART0 initialization
; 0000 01B8 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01B9 // USART0 Receiver: On
; 0000 01BA // USART0 Transmitter: On
; 0000 01BB // USART0 Mode: Asynchronous
; 0000 01BC // USART0 Baud Rate: 38400
; 0000 01BD UCSR0A=0x00;
	OUT  0xB,R30
; 0000 01BE UCSR0B=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 01BF UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 01C0 UBRR0H=0x00;
	LDI  R30,LOW(0)
	STS  144,R30
; 0000 01C1 UBRR0L=0x11;
	LDI  R30,LOW(17)
	OUT  0x9,R30
; 0000 01C2 
; 0000 01C3 // USART1 initialization
; 0000 01C4 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01C5 // USART1 Receiver: On
; 0000 01C6 // USART1 Transmitter: On
; 0000 01C7 // USART1 Mode: Asynchronous
; 0000 01C8 // USART1 Baud Rate: 9600
; 0000 01C9 UCSR1A=0x00;
	LDI  R30,LOW(0)
	STS  155,R30
; 0000 01CA UCSR1B=0x18;
	LDI  R30,LOW(24)
	STS  154,R30
; 0000 01CB UCSR1C=0x06;
	LDI  R30,LOW(6)
	STS  157,R30
; 0000 01CC UBRR1H=0x00;
	LDI  R30,LOW(0)
	STS  152,R30
; 0000 01CD UBRR1L=0x47;
	LDI  R30,LOW(71)
	STS  153,R30
; 0000 01CE 
; 0000 01CF // Analog Comparator initialization
; 0000 01D0 // Analog Comparator: Off
; 0000 01D1 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01D2 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01D3 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01D4 
; 0000 01D5 // ADC initialization
; 0000 01D6 // ADC disabled
; 0000 01D7 ADCSRA=0x00;
	OUT  0x6,R30
; 0000 01D8 
; 0000 01D9 // SPI initialization
; 0000 01DA // SPI disabled
; 0000 01DB SPCR=0x00;
	OUT  0xD,R30
; 0000 01DC 
; 0000 01DD // TWI initialization
; 0000 01DE // TWI disabled
; 0000 01DF TWCR=0x00;
	STS  116,R30
; 0000 01E0 
; 0000 01E1 // Global enable interrupts
; 0000 01E2 #asm("sei")
	sei
; 0000 01E3 if(!PIND.0) setting();
	SBIS 0x10,0
	RCALL _setting
; 0000 01E4 
; 0000 01E5 while (1)
_0x32:
; 0000 01E6       {
; 0000 01E7         // Place your code here
; 0000 01E8         putchar('B');
	CALL SUBOPT_0x6
; 0000 01E9         putchar('B');
	CALL SUBOPT_0x6
; 0000 01EA         putchar('B');
	CALL SUBOPT_0x6
; 0000 01EB         putchar('B');
	CALL SUBOPT_0x6
; 0000 01EC         putchar('B');
	CALL SUBOPT_0x6
; 0000 01ED         putchar('B');
	CALL SUBOPT_0x6
; 0000 01EE         putchar('B');
	CALL SUBOPT_0x6
; 0000 01EF         putchar('B');
	CALL SUBOPT_0x6
; 0000 01F0         putchar('B');
	CALL SUBOPT_0x6
; 0000 01F1         putchar('B');
	CALL SUBOPT_0x6
; 0000 01F2         putchar('B');
	CALL SUBOPT_0x6
; 0000 01F3         putchar('B');
	CALL SUBOPT_0x6
; 0000 01F4         putchar('B');
	CALL SUBOPT_0x6
; 0000 01F5         putchar('B');
	CALL SUBOPT_0x6
; 0000 01F6         putchar('B');
	CALL SUBOPT_0x6
; 0000 01F7         putchar('B');
	CALL SUBOPT_0x6
; 0000 01F8         putchar('B');
	CALL SUBOPT_0x6
; 0000 01F9         putchar('B');
	CALL SUBOPT_0x6
; 0000 01FA         putchar('B');
	CALL SUBOPT_0x6
; 0000 01FB         putchar('B');
	CALL SUBOPT_0x6
; 0000 01FC         putchar('B');
	CALL SUBOPT_0x6
; 0000 01FD         putchar('B');
	CALL SUBOPT_0x6
; 0000 01FE         putchar('B');
	CALL SUBOPT_0x6
; 0000 01FF         putchar('B');
	CALL SUBOPT_0x6
; 0000 0200         putchar('B');
	CALL SUBOPT_0x6
; 0000 0201         putchar('B');
	CALL SUBOPT_0x6
; 0000 0202         putchar('B');
	CALL SUBOPT_0x6
; 0000 0203         putchar('B');
	CALL SUBOPT_0x6
; 0000 0204         putchar(13);
	CALL SUBOPT_0x0
; 0000 0205 
; 0000 0206         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0207         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0208         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0209         putchar1('M');
	CALL SUBOPT_0x7
; 0000 020A         putchar1('M');
	CALL SUBOPT_0x7
; 0000 020B         putchar1('M');
	CALL SUBOPT_0x7
; 0000 020C         putchar1('M');
	CALL SUBOPT_0x7
; 0000 020D         putchar1('M');
	CALL SUBOPT_0x7
; 0000 020E         putchar1('M');
	CALL SUBOPT_0x7
; 0000 020F         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0210         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0211         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0212         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0213         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0214         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0215         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0216         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0217         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0218         putchar1('M');
	CALL SUBOPT_0x7
; 0000 0219         putchar1('M');
	CALL SUBOPT_0x7
; 0000 021A         putchar1('M');
	CALL SUBOPT_0x7
; 0000 021B         putchar1('M');
	CALL SUBOPT_0x7
; 0000 021C         putchar1('M');
	CALL SUBOPT_0x7
; 0000 021D         putchar1(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _putchar1
; 0000 021E 
; 0000 021F         puts("ahhahahahahahahahha");
	__POINTW1MN _0x35,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _puts
; 0000 0220         putsf("kakakkakakakakkakakakakk");
	__POINTW1FN _0x0,1143
	ST   -Y,R31
	ST   -Y,R30
	RCALL _putsf
; 0000 0221       };
	RJMP _0x32
; 0000 0222 }
_0x36:
	RJMP _0x36

	.DSEG
_0x35:
	.BYTE 0x14
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
_0x2000003:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000005
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2000003
_0x2000005:
	RJMP _0x2060001
_putsf:
	ST   -Y,R17
_0x2000006:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000008
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2000006
_0x2000008:
_0x2060001:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _putchar
	LDD  R17,Y+0
	ADIW R28,3
	RET

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x8
_tx_buffer0:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 37 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(13)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _putsf
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x2:
	__POINTW1FN _0x0,96
	ST   -Y,R31
	ST   -Y,R30
	CALL _putsf
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	__POINTW1FN _0x0,192
	ST   -Y,R31
	ST   -Y,R30
	CALL _putsf
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	__POINTW1FN _0x0,288
	ST   -Y,R31
	ST   -Y,R30
	CALL _putsf
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	CALL _putsf
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(66)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(77)
	ST   -Y,R30
	JMP  _putchar1


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

;END OF CODE MARKER
__END_OF_CODE:
