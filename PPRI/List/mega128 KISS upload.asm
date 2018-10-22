
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
;8 bit enums              : No
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
	.DEF _tx_wr_index0=R7
	.DEF _tx_rd_index0=R6
	.DEF _tx_counter0=R9
	.DEF __idx=R10
	.DEF _timer_idx=R8

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

_pos:
	.DB  0x3D,0x30,0x37,0x34,0x39,0x2E,0x34,0x38
	.DB  0x53,0x2F,0x31,0x31,0x30,0x30,0x37,0x2E
	.DB  0x34,0x30,0x45,0x72,0x20,0x54,0x65,0x6C
	.DB  0x65,0x6D,0x65,0x74,0x72,0x79,0x20,0x57
	.DB  0x61,0x64,0x75,0x6B,0x20,0x53,0x65,0x72
	.DB  0x6D,0x6F,0x0,0x0,0x0
_def_t:
	.DB  0x3A,0x53,0x45,0x52,0x4D,0x4F,0x20,0x20
	.DB  0x20,0x20,0x3A,0x50,0x41,0x52,0x4D,0x2E
	.DB  0x50,0x69,0x65,0x7A,0x6F,0x31,0x2C,0x50
	.DB  0x69,0x65,0x7A,0x6F,0x32,0x2C,0x57,0x5F
	.DB  0x4C,0x76,0x6C,0x2C,0x43,0x61,0x68,0x61
	.DB  0x79,0x61,0x0
_unit_t:
	.DB  0x3A,0x53,0x45,0x52,0x4D,0x4F,0x20,0x20
	.DB  0x20,0x20,0x3A,0x55,0x4E,0x49,0x54,0x2E
	.DB  0x56,0x6F,0x6C,0x74,0x2C,0x56,0x6F,0x6C
	.DB  0x74,0x2C,0x6D,0x65,0x74,0x65,0x72,0x2C
	.DB  0x56,0x6F,0x6C,0x74,0x0
_eqn_t:
	.DB  0x3A,0x53,0x45,0x52,0x4D,0x4F,0x20,0x20
	.DB  0x20,0x20,0x3A,0x45,0x51,0x4E,0x53,0x2E
	.DB  0x30,0x2C,0x30,0x2E,0x30,0x31,0x39,0x2C
	.DB  0x30,0x2C,0x30,0x2C,0x30,0x2E,0x30,0x31
	.DB  0x39,0x2C,0x30,0x2C,0x30,0x2C,0x30,0x2E
	.DB  0x30,0x30,0x34,0x2C,0x30,0x2C,0x30,0x2C
	.DB  0x30,0x2E,0x30,0x31,0x39,0x2C,0x30,0x2C
	.DB  0x30,0x2C,0x31,0x2C,0x30,0x0
_cls_string:
	.DB  0xD,0xC0
_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x55:
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x30,0x30,0x30,0x30,0x30,0x30,0x30,0x30
	.DB  0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x09
	.DW  _0x2E
	.DW  _0x0*2

	.DW  0x04
	.DW  0x08
	.DW  _0x55*2

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
;Date    : 10/20/2013
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
;#include <stdlib.h>
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
; 0000 004C {

	.CSEG
_usart0_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 004D if (tx_counter0)
	TST  R9
	BREQ _0x3
; 0000 004E    {
; 0000 004F    --tx_counter0;
	DEC  R9
; 0000 0050    UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0051 #if TX_BUFFER_SIZE0 != 256
; 0000 0052    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x4
	CLR  R6
; 0000 0053 #endif
; 0000 0054    }
_0x4:
; 0000 0055 }
_0x3:
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
;void putchar(unsigned char c)
; 0000 005C {
_putchar:
; 0000 005D while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
_0x5:
	LDI  R30,LOW(8)
	CP   R30,R9
	BREQ _0x5
; 0000 005E #asm("cli")
	cli
; 0000 005F if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R9
	BRNE _0x9
	SBIC 0xB,5
	RJMP _0x8
_0x9:
; 0000 0060    {
; 0000 0061    tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R7
	INC  R7
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0062 #if TX_BUFFER_SIZE0 != 256
; 0000 0063    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0xB
	CLR  R7
; 0000 0064 #endif
; 0000 0065    ++tx_counter0;
_0xB:
	INC  R9
; 0000 0066    }
; 0000 0067 else
	RJMP _0xC
_0x8:
; 0000 0068    UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0069 #asm("sei")
_0xC:
	sei
; 0000 006A }
	RJMP _0x20A0002
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;#define ADC_VREF_TYPE 0x00
;
;// Read the AD conversion result
;unsigned int read_adc(unsigned char adc_input)
; 0000 0075 {
_read_adc:
; 0000 0076 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 0077 // Delay needed for the stabilization of the ADC input voltage
; 0000 0078 delay_us(10);
	__DELAY_USB 37
; 0000 0079 // Start the AD conversion
; 0000 007A ADCSRA|=0x40;
	SBI  0x6,6
; 0000 007B // Wait for the AD conversion to complete
; 0000 007C while ((ADCSRA & 0x10)==0);
_0xD:
	SBIS 0x6,4
	RJMP _0xD
; 0000 007D ADCSRA|=0x10;
	SBI  0x6,4
; 0000 007E return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x20A0002:
	ADIW R28,1
	RET
; 0000 007F }
;
;// Declare your global variables here
;
;eeprom unsigned char op_string[25] =
;{
;        0xC0,0x00,
;        ('A'<<1),('P'<<1),('A'<<1),('V'<<1),('R'<<1),(' '<<1),('0'<<1),
;        ('S'<<1),('E'<<1),('R'<<1),('M'<<1),('O'<<1),(' '<<1),('0'<<1),
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),(('2'<<1)+1),
;        0x03,0xF0
;};
;
;flash unsigned char pos[45] =
;{
;        "=0749.48S/11007.40Er Telemetry Waduk Sermo"
;};
;
;flash unsigned char def_t[43] =
;{      //:YD2JTF-1 :
;        ":SERMO    :PARM.Piezo1,Piezo2,W_Lvl,Cahaya"
;};
;
;flash unsigned char unit_t[37] =
;{      //:YD2JTF-1 :
;        ":SERMO    :UNIT.Volt,Volt,meter,Volt"
;};
;
;flash unsigned char eqn_t[62] =
;{
;        ":SERMO    :EQNS.0,0.019,0,0,0.019,0,0,0.004,0,0,0.019,0,0,1,0"
;};
;
;flash unsigned char cls_string[2] =
;{
;        0x0D,0xC0
;};
;
;//int t_idx = 0;
;//eeprom unsigned int e_t_idx = 250;
;eeprom int e_idx = 100;
;int _idx = 0;
;eeprom int _t_idx[3];
;eeprom unsigned char _ch1[3];
;eeprom unsigned char _ch2[3];
;eeprom unsigned char _ch3[3];
;eeprom unsigned char _ch4[3];
;eeprom unsigned char _ch5[3];
;
;char timer_idx = 0;
;
;void read_sensor(void)
; 0000 00B3 {
_read_sensor:
; 0000 00B4         unsigned char ch1,ch2,ch3,ch4,ch5;
; 0000 00B5         int rat,pul,sat;
; 0000 00B6         char _rat;
; 0000 00B7         char _pul;
; 0000 00B8         char _sat;
; 0000 00B9 
; 0000 00BA         unsigned char b_t_idx;
; 0000 00BB 
; 0000 00BC         ch1 = read_adc(0);
	SBIW R28,9
	CALL __SAVELOCR6
;	ch1 -> R17
;	ch2 -> R16
;	ch3 -> R19
;	ch4 -> R18
;	ch5 -> R21
;	rat -> Y+13
;	pul -> Y+11
;	sat -> Y+9
;	_rat -> R20
;	_pul -> Y+8
;	_sat -> Y+7
;	b_t_idx -> Y+6
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R17,R30
; 0000 00BD 
; 0000 00BE         rat = ch1 / 100;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 00BF         ch1 = ch1 % 100;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOV  R17,R30
; 0000 00C0         pul = ch1 / 10;
	MOV  R26,R17
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 00C1         sat = ch1 % 10;
	MOV  R26,R17
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+9,R30
	STD  Y+9+1,R31
; 0000 00C2 
; 0000 00C3         _rat = rat + '0';
	LDD  R30,Y+13
	SUBI R30,-LOW(48)
	MOV  R20,R30
; 0000 00C4         _pul = pul + '0';
	LDD  R30,Y+11
	SUBI R30,-LOW(48)
	STD  Y+8,R30
; 0000 00C5         _sat = sat + '0';
	LDD  R30,Y+9
	SUBI R30,-LOW(48)
	STD  Y+7,R30
; 0000 00C6 
; 0000 00C7         _ch1[0] = _rat;
	MOV  R30,R20
	LDI  R26,LOW(__ch1)
	LDI  R27,HIGH(__ch1)
	CALL __EEPROMWRB
; 0000 00C8         _ch1[1] = _pul;
	__POINTW2MN __ch1,1
	LDD  R30,Y+8
	CALL __EEPROMWRB
; 0000 00C9         _ch1[2] = _sat;
	__POINTW2MN __ch1,2
	LDD  R30,Y+7
	CALL __EEPROMWRB
; 0000 00CA 
; 0000 00CB         ch2 = read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R16,R30
; 0000 00CC 
; 0000 00CD         rat = ch2 / 100;
	MOV  R26,R16
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 00CE         ch2 = ch2 % 100;
	MOV  R26,R16
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOV  R16,R30
; 0000 00CF         pul = ch2 / 10;
	MOV  R26,R16
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 00D0         sat = ch2 % 10;
	MOV  R26,R16
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+9,R30
	STD  Y+9+1,R31
; 0000 00D1 
; 0000 00D2         _rat = rat + '0';
	LDD  R30,Y+13
	SUBI R30,-LOW(48)
	MOV  R20,R30
; 0000 00D3         _pul = pul + '0';
	LDD  R30,Y+11
	SUBI R30,-LOW(48)
	STD  Y+8,R30
; 0000 00D4         _sat = sat + '0';
	LDD  R30,Y+9
	SUBI R30,-LOW(48)
	STD  Y+7,R30
; 0000 00D5 
; 0000 00D6         _ch2[0] = _rat;
	MOV  R30,R20
	LDI  R26,LOW(__ch2)
	LDI  R27,HIGH(__ch2)
	CALL __EEPROMWRB
; 0000 00D7         _ch2[1] = _pul;
	__POINTW2MN __ch2,1
	LDD  R30,Y+8
	CALL __EEPROMWRB
; 0000 00D8         _ch2[2] = _sat;
	__POINTW2MN __ch2,2
	LDD  R30,Y+7
	CALL __EEPROMWRB
; 0000 00D9 
; 0000 00DA         ch3 = read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R19,R30
; 0000 00DB 
; 0000 00DC         rat = ch3 / 100;
	MOV  R26,R19
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 00DD         ch3 = ch3 % 100;
	MOV  R26,R19
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOV  R19,R30
; 0000 00DE         pul = ch3 / 10;
	MOV  R26,R19
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 00DF         sat = ch3 % 10;
	MOV  R26,R19
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+9,R30
	STD  Y+9+1,R31
; 0000 00E0 
; 0000 00E1         _rat = rat + '0';
	LDD  R30,Y+13
	SUBI R30,-LOW(48)
	MOV  R20,R30
; 0000 00E2         _pul = pul + '0';
	LDD  R30,Y+11
	SUBI R30,-LOW(48)
	STD  Y+8,R30
; 0000 00E3         _sat = sat + '0';
	LDD  R30,Y+9
	SUBI R30,-LOW(48)
	STD  Y+7,R30
; 0000 00E4 
; 0000 00E5         _ch3[0] = _rat;
	MOV  R30,R20
	LDI  R26,LOW(__ch3)
	LDI  R27,HIGH(__ch3)
	CALL __EEPROMWRB
; 0000 00E6         _ch3[1] = _pul;
	__POINTW2MN __ch3,1
	LDD  R30,Y+8
	CALL __EEPROMWRB
; 0000 00E7         _ch3[2] = _sat;
	__POINTW2MN __ch3,2
	LDD  R30,Y+7
	CALL __EEPROMWRB
; 0000 00E8 
; 0000 00E9         ch4 = read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R18,R30
; 0000 00EA 
; 0000 00EB         rat = ch4 / 100;
	MOV  R26,R18
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 00EC         ch4 = ch4 % 100;
	MOV  R26,R18
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOV  R18,R30
; 0000 00ED         pul = ch4 / 10;
	MOV  R26,R18
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 00EE         sat = ch4 % 10;
	MOV  R26,R18
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+9,R30
	STD  Y+9+1,R31
; 0000 00EF 
; 0000 00F0         _rat = rat + '0';
	LDD  R30,Y+13
	SUBI R30,-LOW(48)
	MOV  R20,R30
; 0000 00F1         _pul = pul + '0';
	LDD  R30,Y+11
	SUBI R30,-LOW(48)
	STD  Y+8,R30
; 0000 00F2         _sat = sat + '0';
	LDD  R30,Y+9
	SUBI R30,-LOW(48)
	STD  Y+7,R30
; 0000 00F3 
; 0000 00F4         _ch4[0] = _rat;
	MOV  R30,R20
	LDI  R26,LOW(__ch4)
	LDI  R27,HIGH(__ch4)
	CALL __EEPROMWRB
; 0000 00F5         _ch4[1] = _pul;
	__POINTW2MN __ch4,1
	LDD  R30,Y+8
	CALL __EEPROMWRB
; 0000 00F6         _ch4[2] = _sat;
	__POINTW2MN __ch4,2
	LDD  R30,Y+7
	CALL __EEPROMWRB
; 0000 00F7 
; 0000 00F8         ch5 = 0;
	LDI  R21,LOW(0)
; 0000 00F9 
; 0000 00FA         rat = ch5 / 100;
	MOV  R26,R21
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 00FB         ch5 = ch5 % 100;
	MOV  R26,R21
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOV  R21,R30
; 0000 00FC         pul = ch5 / 10;
	MOV  R26,R21
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 00FD         sat = ch5 % 10;
	MOV  R26,R21
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+9,R30
	STD  Y+9+1,R31
; 0000 00FE 
; 0000 00FF         _rat = rat + '0';
	LDD  R30,Y+13
	SUBI R30,-LOW(48)
	MOV  R20,R30
; 0000 0100         _pul = pul + '0';
	LDD  R30,Y+11
	SUBI R30,-LOW(48)
	STD  Y+8,R30
; 0000 0101         _sat = sat + '0';
	LDD  R30,Y+9
	SUBI R30,-LOW(48)
	STD  Y+7,R30
; 0000 0102 
; 0000 0103         _ch5[0] = _rat;
	MOV  R30,R20
	LDI  R26,LOW(__ch5)
	LDI  R27,HIGH(__ch5)
	CALL __EEPROMWRB
; 0000 0104         _ch5[1] = _pul;
	__POINTW2MN __ch5,1
	LDD  R30,Y+8
	CALL __EEPROMWRB
; 0000 0105         _ch5[2] = _sat;
	__POINTW2MN __ch5,2
	LDD  R30,Y+7
	CALL __EEPROMWRB
; 0000 0106 
; 0000 0107         b_t_idx = _idx;
	__PUTBSR 10,6
; 0000 0108 
; 0000 0109         rat = b_t_idx / 100;
	LDD  R26,Y+6
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	STD  Y+13,R30
	STD  Y+13+1,R31
; 0000 010A         b_t_idx = b_t_idx % 100;
	LDD  R26,Y+6
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	STD  Y+6,R30
; 0000 010B         pul = b_t_idx / 10;
	LDD  R26,Y+6
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	STD  Y+11,R30
	STD  Y+11+1,R31
; 0000 010C         sat = b_t_idx % 10;
	LDD  R26,Y+6
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+9,R30
	STD  Y+9+1,R31
; 0000 010D 
; 0000 010E         _rat = rat + '0';
	LDD  R30,Y+13
	SUBI R30,-LOW(48)
	MOV  R20,R30
; 0000 010F         _pul = pul + '0';
	LDD  R30,Y+11
	SUBI R30,-LOW(48)
	STD  Y+8,R30
; 0000 0110         _sat = sat + '0';
	LDD  R30,Y+9
	SUBI R30,-LOW(48)
	STD  Y+7,R30
; 0000 0111 
; 0000 0112         _t_idx[0] = _rat;
	MOV  R30,R20
	LDI  R26,LOW(__t_idx)
	LDI  R27,HIGH(__t_idx)
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 0113         _t_idx[1] = _pul;
	__POINTW2MN __t_idx,2
	LDD  R30,Y+8
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 0114         _t_idx[2] = _sat;
	__POINTW2MN __t_idx,4
	LDD  R30,Y+7
	LDI  R31,0
	CALL __EEPROMWRW
; 0000 0115 
; 0000 0116         _idx++;
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
; 0000 0117         //if(_idx > 999) _idx = 0;
; 0000 0118 
; 0000 0119         e_idx = _idx;
	MOVW R30,R10
	LDI  R26,LOW(_e_idx)
	LDI  R27,HIGH(_e_idx)
	CALL __EEPROMWRW
; 0000 011A }
	CALL __LOADLOCR6
	ADIW R28,15
	RET
;
;void kirim_string(void)
; 0000 011D {
_kirim_string:
; 0000 011E         int i;
; 0000 011F 
; 0000 0120         for(i=0;i<25;i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x11:
	__CPWRN 16,17,25
	BRGE _0x12
; 0000 0121         {
; 0000 0122                 putchar(op_string[i]);
	LDI  R26,LOW(_op_string)
	LDI  R27,HIGH(_op_string)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 0123         }
	__ADDWRN 16,17,1
	RJMP _0x11
_0x12:
; 0000 0124         for(i=0;i<45;i++)
	__GETWRN 16,17,0
_0x14:
	__CPWRN 16,17,45
	BRGE _0x15
; 0000 0125         {
; 0000 0126                 putchar(pos[i]);
	MOVW R30,R16
	SUBI R30,LOW(-_pos*2)
	SBCI R31,HIGH(-_pos*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar
; 0000 0127         }
	__ADDWRN 16,17,1
	RJMP _0x14
_0x15:
; 0000 0128         for(i=0;i<2;i++)
	__GETWRN 16,17,0
_0x17:
	__CPWRN 16,17,2
	BRGE _0x18
; 0000 0129         {
; 0000 012A                 putchar(cls_string[i]);
	MOVW R30,R16
	SUBI R30,LOW(-_cls_string*2)
	SBCI R31,HIGH(-_cls_string*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar
; 0000 012B         }
	__ADDWRN 16,17,1
	RJMP _0x17
_0x18:
; 0000 012C 
; 0000 012D         putchar(13);
	RJMP _0x20A0001
; 0000 012E 
; 0000 012F         delay_ms(1000);
; 0000 0130 }
;
;void kirim_data_telem(void)
; 0000 0133 {
_kirim_data_telem:
; 0000 0134         int i;
; 0000 0135 
; 0000 0136         read_sensor();
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	RCALL _read_sensor
; 0000 0137 
; 0000 0138         for(i=0;i<25;i++)
	__GETWRN 16,17,0
_0x1A:
	__CPWRN 16,17,25
	BRGE _0x1B
; 0000 0139         {
; 0000 013A                                 putchar(op_string[i]);
	LDI  R26,LOW(_op_string)
	LDI  R27,HIGH(_op_string)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 013B         }
	__ADDWRN 16,17,1
	RJMP _0x1A
_0x1B:
; 0000 013C                                 putchar('T');
	LDI  R30,LOW(84)
	ST   -Y,R30
	RCALL _putchar
; 0000 013D                                 putchar('#');
	LDI  R30,LOW(35)
	ST   -Y,R30
	RCALL _putchar
; 0000 013E         for(i=0;i<3;i++)        putchar(_t_idx[i]);
	__GETWRN 16,17,0
_0x1D:
	__CPWRN 16,17,3
	BRGE _0x1E
	MOVW R30,R16
	LDI  R26,LOW(__t_idx)
	LDI  R27,HIGH(__t_idx)
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
	__ADDWRN 16,17,1
	RJMP _0x1D
_0x1E:
; 0000 013F putchar(',');
	LDI  R30,LOW(44)
	ST   -Y,R30
	RCALL _putchar
; 0000 0140         for(i=0;i<3;i++)        putchar(_ch1[i]);
	__GETWRN 16,17,0
_0x20:
	__CPWRN 16,17,3
	BRGE _0x21
	LDI  R26,LOW(__ch1)
	LDI  R27,HIGH(__ch1)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
	__ADDWRN 16,17,1
	RJMP _0x20
_0x21:
; 0000 0141 putchar(',');
	LDI  R30,LOW(44)
	ST   -Y,R30
	RCALL _putchar
; 0000 0142         for(i=0;i<3;i++)        putchar(_ch2[i]);
	__GETWRN 16,17,0
_0x23:
	__CPWRN 16,17,3
	BRGE _0x24
	LDI  R26,LOW(__ch2)
	LDI  R27,HIGH(__ch2)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
	__ADDWRN 16,17,1
	RJMP _0x23
_0x24:
; 0000 0143 putchar(',');
	LDI  R30,LOW(44)
	ST   -Y,R30
	RCALL _putchar
; 0000 0144         for(i=0;i<3;i++)        putchar(_ch3[i]);
	__GETWRN 16,17,0
_0x26:
	__CPWRN 16,17,3
	BRGE _0x27
	LDI  R26,LOW(__ch3)
	LDI  R27,HIGH(__ch3)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
	__ADDWRN 16,17,1
	RJMP _0x26
_0x27:
; 0000 0145 putchar(',');
	LDI  R30,LOW(44)
	ST   -Y,R30
	RCALL _putchar
; 0000 0146         for(i=0;i<3;i++)        putchar(_ch4[i]);
	__GETWRN 16,17,0
_0x29:
	__CPWRN 16,17,3
	BRGE _0x2A
	LDI  R26,LOW(__ch4)
	LDI  R27,HIGH(__ch4)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
	__ADDWRN 16,17,1
	RJMP _0x29
_0x2A:
; 0000 0147 putchar(',');
	LDI  R30,LOW(44)
	ST   -Y,R30
	RCALL _putchar
; 0000 0148         for(i=0;i<3;i++)        putchar(_ch5[i]);
	__GETWRN 16,17,0
_0x2C:
	__CPWRN 16,17,3
	BRGE _0x2D
	LDI  R26,LOW(__ch5)
	LDI  R27,HIGH(__ch5)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
	__ADDWRN 16,17,1
	RJMP _0x2C
_0x2D:
; 0000 0149 putchar(',');
	LDI  R30,LOW(44)
	ST   -Y,R30
	RCALL _putchar
; 0000 014A                                 puts("00000000");
	__POINTW1MN _0x2E,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
; 0000 014B         for(i=0;i<2;i++)
	__GETWRN 16,17,0
_0x30:
	__CPWRN 16,17,2
	BRGE _0x31
; 0000 014C         {
; 0000 014D                                 putchar(cls_string[i]);
	MOVW R30,R16
	SUBI R30,LOW(-_cls_string*2)
	SBCI R31,HIGH(-_cls_string*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar
; 0000 014E         }
	__ADDWRN 16,17,1
	RJMP _0x30
_0x31:
; 0000 014F 
; 0000 0150         putchar(13);
	RJMP _0x20A0001
; 0000 0151 
; 0000 0152         delay_ms(1000);
; 0000 0153 }

	.DSEG
_0x2E:
	.BYTE 0x9
;
;void kirim_param_telem(void)
; 0000 0156 {

	.CSEG
_kirim_param_telem:
; 0000 0157         int i;
; 0000 0158 
; 0000 0159         for(i=0;i<25;i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x33:
	__CPWRN 16,17,25
	BRGE _0x34
; 0000 015A         {
; 0000 015B                 putchar(op_string[i]);
	LDI  R26,LOW(_op_string)
	LDI  R27,HIGH(_op_string)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 015C         }
	__ADDWRN 16,17,1
	RJMP _0x33
_0x34:
; 0000 015D         for(i=0;i<43;i++)
	__GETWRN 16,17,0
_0x36:
	__CPWRN 16,17,43
	BRGE _0x37
; 0000 015E         {
; 0000 015F                 putchar(def_t[i]);
	MOVW R30,R16
	SUBI R30,LOW(-_def_t*2)
	SBCI R31,HIGH(-_def_t*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar
; 0000 0160         }
	__ADDWRN 16,17,1
	RJMP _0x36
_0x37:
; 0000 0161         for(i=0;i<2;i++)
	__GETWRN 16,17,0
_0x39:
	__CPWRN 16,17,2
	BRGE _0x3A
; 0000 0162         {
; 0000 0163                 putchar(cls_string[i]);
	MOVW R30,R16
	SUBI R30,LOW(-_cls_string*2)
	SBCI R31,HIGH(-_cls_string*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar
; 0000 0164         }
	__ADDWRN 16,17,1
	RJMP _0x39
_0x3A:
; 0000 0165 
; 0000 0166         putchar(13);
	RJMP _0x20A0001
; 0000 0167 
; 0000 0168         delay_ms(1000);
; 0000 0169 }
;
;void kirim_unit_telem(void)
; 0000 016C {
_kirim_unit_telem:
; 0000 016D         int i;
; 0000 016E 
; 0000 016F         for(i=0;i<25;i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x3C:
	__CPWRN 16,17,25
	BRGE _0x3D
; 0000 0170         {
; 0000 0171                 putchar(op_string[i]);
	LDI  R26,LOW(_op_string)
	LDI  R27,HIGH(_op_string)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 0172         }
	__ADDWRN 16,17,1
	RJMP _0x3C
_0x3D:
; 0000 0173         for(i=0;i<37;i++)
	__GETWRN 16,17,0
_0x3F:
	__CPWRN 16,17,37
	BRGE _0x40
; 0000 0174         {
; 0000 0175                 putchar(unit_t[i]);
	MOVW R30,R16
	SUBI R30,LOW(-_unit_t*2)
	SBCI R31,HIGH(-_unit_t*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar
; 0000 0176         }
	__ADDWRN 16,17,1
	RJMP _0x3F
_0x40:
; 0000 0177         for(i=0;i<2;i++)
	__GETWRN 16,17,0
_0x42:
	__CPWRN 16,17,2
	BRGE _0x43
; 0000 0178         {
; 0000 0179                 putchar(cls_string[i]);
	MOVW R30,R16
	SUBI R30,LOW(-_cls_string*2)
	SBCI R31,HIGH(-_cls_string*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar
; 0000 017A         }
	__ADDWRN 16,17,1
	RJMP _0x42
_0x43:
; 0000 017B 
; 0000 017C         putchar(13);
	RJMP _0x20A0001
; 0000 017D 
; 0000 017E         delay_ms(1000);
; 0000 017F }
;
;void kirim_eqn_telem(void)
; 0000 0182 {
_kirim_eqn_telem:
; 0000 0183         int i;
; 0000 0184 
; 0000 0185         for(i=0;i<25;i++)
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	__GETWRN 16,17,0
_0x45:
	__CPWRN 16,17,25
	BRGE _0x46
; 0000 0186         {
; 0000 0187                 putchar(op_string[i]);
	LDI  R26,LOW(_op_string)
	LDI  R27,HIGH(_op_string)
	ADD  R26,R16
	ADC  R27,R17
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 0188         }
	__ADDWRN 16,17,1
	RJMP _0x45
_0x46:
; 0000 0189         for(i=0;i<62;i++)
	__GETWRN 16,17,0
_0x48:
	__CPWRN 16,17,62
	BRGE _0x49
; 0000 018A         {
; 0000 018B                 putchar(eqn_t[i]);
	MOVW R30,R16
	SUBI R30,LOW(-_eqn_t*2)
	SBCI R31,HIGH(-_eqn_t*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar
; 0000 018C         }
	__ADDWRN 16,17,1
	RJMP _0x48
_0x49:
; 0000 018D         for(i=0;i<2;i++)
	__GETWRN 16,17,0
_0x4B:
	__CPWRN 16,17,2
	BRGE _0x4C
; 0000 018E         {
; 0000 018F                 putchar(cls_string[i]);
	MOVW R30,R16
	SUBI R30,LOW(-_cls_string*2)
	SBCI R31,HIGH(-_cls_string*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _putchar
; 0000 0190         }
	__ADDWRN 16,17,1
	RJMP _0x4B
_0x4C:
; 0000 0191 
; 0000 0192         putchar(13);
_0x20A0001:
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _putchar
; 0000 0193 
; 0000 0194         delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0195 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void timer(void)
; 0000 0198 {
_timer:
; 0000 0199         if(timer_idx==3)
	LDI  R30,LOW(3)
	CP   R30,R8
	BRNE _0x4D
; 0000 019A         {
; 0000 019B                 kirim_string();
	RCALL _kirim_string
; 0000 019C                 delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 019D 
; 0000 019E                 kirim_param_telem();
	RCALL _kirim_param_telem
; 0000 019F                 delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01A0 
; 0000 01A1                 kirim_unit_telem();
	RCALL _kirim_unit_telem
; 0000 01A2                 delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01A3 
; 0000 01A4                 kirim_eqn_telem();
	RCALL _kirim_eqn_telem
; 0000 01A5                 delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01A6 
; 0000 01A7                 kirim_data_telem();
; 0000 01A8         }
; 0000 01A9         else
_0x4D:
; 0000 01AA         {
; 0000 01AB                 kirim_data_telem();
_0x54:
	RCALL _kirim_data_telem
; 0000 01AC         }
; 0000 01AD 
; 0000 01AE         if(timer_idx==100)      timer_idx = 0;
	LDI  R30,LOW(100)
	CP   R30,R8
	BRNE _0x4F
	CLR  R8
; 0000 01AF }
_0x4F:
	RET
;
;void main(void)
; 0000 01B2 {
_main:
; 0000 01B3 // Declare your local variables here
; 0000 01B4 
; 0000 01B5 // Input/Output Ports initialization
; 0000 01B6 // Port A initialization
; 0000 01B7 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01B8 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01B9 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 01BA DDRA=0x00;
	OUT  0x1A,R30
; 0000 01BB 
; 0000 01BC // Port B initialization
; 0000 01BD // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01BE // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01BF PORTB=0x00;
	OUT  0x18,R30
; 0000 01C0 DDRB=0x00;
	OUT  0x17,R30
; 0000 01C1 
; 0000 01C2 // Port C initialization
; 0000 01C3 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01C4 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01C5 PORTC=0x00;
	OUT  0x15,R30
; 0000 01C6 DDRC=0x00;
	OUT  0x14,R30
; 0000 01C7 
; 0000 01C8 // Port D initialization
; 0000 01C9 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
; 0000 01CA // State7=T State6=T State5=T State4=T State3=T State2=T State1=1 State0=P
; 0000 01CB PORTD=0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 01CC DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 01CD 
; 0000 01CE // Port E initialization
; 0000 01CF // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01D0 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01D1 PORTE=0x00;
	LDI  R30,LOW(0)
	OUT  0x3,R30
; 0000 01D2 DDRE=0x00;
	OUT  0x2,R30
; 0000 01D3 
; 0000 01D4 // Port F initialization
; 0000 01D5 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01D6 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 01D7 PORTF=0x00;
	STS  98,R30
; 0000 01D8 DDRF=0x00;
	STS  97,R30
; 0000 01D9 
; 0000 01DA // Port G initialization
; 0000 01DB // Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 01DC // State4=T State3=T State2=T State1=T State0=T
; 0000 01DD PORTG=0x00;
	STS  101,R30
; 0000 01DE DDRG=0x00;
	STS  100,R30
; 0000 01DF 
; 0000 01E0 // USART0 initialization
; 0000 01E1 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01E2 // USART0 Receiver: Off
; 0000 01E3 // USART0 Transmitter: On
; 0000 01E4 // USART0 Mode: Asynchronous
; 0000 01E5 // USART0 Baud Rate: 1200
; 0000 01E6 UCSR0A=0x00;
	OUT  0xB,R30
; 0000 01E7 UCSR0B=0x48;
	LDI  R30,LOW(72)
	OUT  0xA,R30
; 0000 01E8 UCSR0C=0x06;
	LDI  R30,LOW(6)
	STS  149,R30
; 0000 01E9 UBRR0H=0x02;
	LDI  R30,LOW(2)
	STS  144,R30
; 0000 01EA UBRR0L=0x3F;
	LDI  R30,LOW(63)
	OUT  0x9,R30
; 0000 01EB 
; 0000 01EC // Analog Comparator initialization
; 0000 01ED // Analog Comparator: Off
; 0000 01EE // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01EF ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01F0 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01F1 
; 0000 01F2 // ADC initialization
; 0000 01F3 // ADC Clock frequency: 691.200 kHz
; 0000 01F4 // ADC Voltage Reference: AREF pin
; 0000 01F5 ADMUX=ADC_VREF_TYPE & 0xff;
	OUT  0x7,R30
; 0000 01F6 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 01F7 
; 0000 01F8 _idx = e_idx;
	LDI  R26,LOW(_e_idx)
	LDI  R27,HIGH(_e_idx)
	CALL __EEPROMRDW
	MOVW R10,R30
; 0000 01F9 
; 0000 01FA while (1)
_0x50:
; 0000 01FB         {
; 0000 01FC                 // Place your code here
; 0000 01FD                 timer();
	RCALL _timer
; 0000 01FE                 timer_idx++;
	INC  R8
; 0000 01FF                 delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0200         }
	RJMP _0x50
; 0000 0201 }
_0x53:
	RJMP _0x53

	.CSEG

	.DSEG

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
_0x2020003:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020005
	ST   -Y,R17
	CALL _putchar
	RJMP _0x2020003
_0x2020005:
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _putchar
	LDD  R17,Y+0
	ADIW R28,3
	RET

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_tx_buffer0:
	.BYTE 0x8

	.ESEG
_op_string:
	.DB  LOW(0xA08200C0),HIGH(0xA08200C0),BYTE3(0xA08200C0),BYTE4(0xA08200C0)
	.DB  LOW(0x40A4AC82),HIGH(0x40A4AC82),BYTE3(0x40A4AC82),BYTE4(0x40A4AC82)
	.DB  LOW(0xA48AA660),HIGH(0xA48AA660),BYTE3(0xA48AA660),BYTE4(0xA48AA660)
	.DB  LOW(0x60409E9A),HIGH(0x60409E9A),BYTE3(0x60409E9A),BYTE4(0x60409E9A)
	.DB  LOW(0x8A8892AE),HIGH(0x8A8892AE),BYTE3(0x8A8892AE),BYTE4(0x8A8892AE)
	.DB  LOW(0x3654064),HIGH(0x3654064),BYTE3(0x3654064),BYTE4(0x3654064)
	.DB  0xF0
_e_idx:
	.DW  0x64
__t_idx:
	.BYTE 0x6
__ch1:
	.BYTE 0x3
__ch2:
	.BYTE 0x3
__ch3:
	.BYTE 0x3
__ch4:
	.BYTE 0x3
__ch5:
	.BYTE 0x3

	.DSEG
__seed_G100:
	.BYTE 0x4

	.CSEG

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
