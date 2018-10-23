
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 12.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
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
	.EQU __SRAM_END=0x045F
	.EQU __DSTACK_SIZE=0x0100
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
	.DEF _kursorPID=R5
	.DEF _kursorSpeed=R4
	.DEF _kursorGaris=R7
	.DEF _sensor=R6
	.DEF _adc0=R9
	.DEF _adc1=R8
	.DEF _adc2=R11
	.DEF _adc3=R10
	.DEF _adc4=R13
	.DEF _adc5=R12

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

_char0:
	.DB  0x60,0x18,0x6,0x7F,0x7F,0x6,0x18,0x60
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

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
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x4E
	.DB  0x6F,0x74,0x20,0x55,0x73,0x65,0x64,0x20
	.DB  0x21,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x53,0x65,0x74,0x20,0x4D,0x6F,0x64,0x65
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x53,0x74,0x61,0x72
	.DB  0x74,0x21,0x21,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x4B,0x70,0x20,0x20
	.DB  0x20,0x4B,0x69,0x20,0x20,0x20,0x4B,0x64
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x4D,0x41
	.DB  0x58,0x20,0x20,0x20,0x20,0x4D,0x49,0x4E
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x57,0x41
	.DB  0x52,0x4E,0x41,0x20,0x3A,0x20,0x50,0x75
	.DB  0x74,0x69,0x68,0x20,0x0,0x20,0x20,0x57
	.DB  0x41,0x52,0x4E,0x41,0x20,0x3A,0x20,0x48
	.DB  0x69,0x74,0x61,0x6D,0x20,0x0,0x20,0x20
	.DB  0x53,0x65,0x6E,0x73,0x4C,0x20,0x3A,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x53,0x6B,0x65,0x6E,0x2E,0x20,0x79,0x67
	.DB  0x20,0x20,0x64,0x70,0x61,0x6B,0x65,0x3A
	.DB  0x0,0x20,0x4D,0x6F,0x64,0x65,0x20,0x3A
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x31,0x2E,0x4C,0x69,0x68
	.DB  0x61,0x74,0x20,0x41,0x44,0x43,0x0,0x20
	.DB  0x32,0x2E,0x54,0x65,0x73,0x74,0x20,0x4D
	.DB  0x6F,0x64,0x65,0x0,0x20,0x33,0x2E,0x43
	.DB  0x65,0x6B,0x20,0x53,0x65,0x6E,0x73,0x6F
	.DB  0x72,0x20,0x0,0x20,0x34,0x2E,0x41,0x75
	.DB  0x74,0x6F,0x20,0x54,0x75,0x6E,0x65,0x20
	.DB  0x31,0x2D,0x31,0x0,0x20,0x35,0x2E,0x41
	.DB  0x75,0x74,0x6F,0x20,0x54,0x75,0x6E,0x65
	.DB  0x20,0x0,0x20,0x36,0x2E,0x43,0x65,0x6B
	.DB  0x20,0x50,0x57,0x4D,0x20,0x41,0x6B,0x74
	.DB  0x69,0x66,0x0,0x20,0x25,0x64,0x20,0x25
	.DB  0x64,0x20,0x25,0x64,0x20,0x25,0x64,0x0
	.DB  0x20,0x54,0x65,0x73,0x74,0x3A,0x53,0x65
	.DB  0x6E,0x73,0x6F,0x72,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x62,0x62,0x30,0x20,0x20,0x62
	.DB  0x61,0x30,0x20,0x20,0x62,0x74,0x30,0x0
	.DB  0x20,0x25,0x64,0x20,0x20,0x25,0x64,0x20
	.DB  0x20,0x25,0x64,0x0,0x20,0x62,0x62,0x31
	.DB  0x20,0x20,0x62,0x61,0x31,0x20,0x20,0x62
	.DB  0x74,0x31,0x0,0x20,0x62,0x62,0x32,0x20
	.DB  0x20,0x62,0x61,0x32,0x20,0x20,0x62,0x74
	.DB  0x32,0x0,0x20,0x62,0x62,0x33,0x20,0x20
	.DB  0x62,0x61,0x33,0x20,0x20,0x62,0x74,0x33
	.DB  0x0,0x20,0x62,0x62,0x34,0x20,0x20,0x62
	.DB  0x61,0x34,0x20,0x20,0x62,0x74,0x34,0x0
	.DB  0x20,0x62,0x62,0x35,0x20,0x20,0x62,0x61
	.DB  0x35,0x20,0x20,0x62,0x74,0x35,0x0,0x20
	.DB  0x62,0x62,0x36,0x20,0x20,0x62,0x61,0x36
	.DB  0x20,0x20,0x62,0x74,0x36,0x0,0x20,0x62
	.DB  0x62,0x37,0x20,0x20,0x62,0x61,0x37,0x20
	.DB  0x20,0x62,0x74,0x37,0x0,0x25,0x64,0x20
	.DB  0x25,0x64,0x20,0x25,0x64,0x20,0x25,0x64
	.DB  0x20,0x25,0x64,0x20,0x25,0x64,0x20,0x25
	.DB  0x64,0x20,0x25,0x64,0x0,0x25,0x64,0x20
	.DB  0x20,0x20,0x25,0x64,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x53
	.DB  0x6B,0x65,0x6E,0x61,0x72,0x69,0x6F,0x2D
	.DB  0x53,0x74,0x61,0x72,0x74,0x41,0x0,0x20
	.DB  0x20,0x4F,0x4B,0x20,0x3F,0x0,0x20,0x20
	.DB  0x53,0x6B,0x65,0x6E,0x61,0x72,0x69,0x6F
	.DB  0x2D,0x31,0x41,0x0,0x20,0x20,0x53,0x6B
	.DB  0x65,0x6E,0x61,0x72,0x69,0x6F,0x2D,0x32
	.DB  0x41,0x0,0x20,0x20,0x53,0x6B,0x65,0x6E
	.DB  0x61,0x72,0x69,0x6F,0x2D,0x33,0x41,0x0
	.DB  0x20,0x20,0x53,0x6B,0x65,0x6E,0x61,0x72
	.DB  0x69,0x6F,0x2D,0x34,0x41,0x0,0x20,0x20
	.DB  0x53,0x6B,0x65,0x6E,0x61,0x72,0x69,0x6F
	.DB  0x2D,0x35,0x41,0x0,0x20,0x53,0x6B,0x65
	.DB  0x6E,0x61,0x72,0x69,0x6F,0x2D,0x53,0x74
	.DB  0x61,0x72,0x74,0x42,0x0,0x20,0x20,0x53
	.DB  0x6B,0x65,0x6E,0x61,0x72,0x69,0x6F,0x2D
	.DB  0x31,0x42,0x0,0x20,0x20,0x53,0x6B,0x65
	.DB  0x6E,0x61,0x72,0x69,0x6F,0x2D,0x32,0x42
	.DB  0x0,0x20,0x20,0x53,0x6B,0x65,0x6E,0x61
	.DB  0x72,0x69,0x6F,0x2D,0x33,0x42,0x0,0x20
	.DB  0x20,0x53,0x6B,0x65,0x6E,0x61,0x72,0x69
	.DB  0x6F,0x2D,0x34,0x42,0x0,0x20,0x20,0x53
	.DB  0x6B,0x65,0x6E,0x61,0x72,0x69,0x6F,0x2D
	.DB  0x35,0x42,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  __base_y_G101
	.DW  _0x2020003*2

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
	.ORG 0x160

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Line Follower Micro - Liffoco 2012
;Version : v1.0
;Date    : 12/6/2012
;Author  : Handiko Gesang
;Company : Lab. STTK
;Comments: Lalalalalalalala
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 12.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
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
;#include <delay.h>
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;#define ADC_VREF_TYPE 0x20
;
;#define sw_up           PIND.4
;#define sw_down         PIND.6
;#define sw_ok           PIND.5
;#define sw_cancel       PIND.3
;
;#define backlight       PORTB.3
;
;//#define sKa     PINC.0
;//#define sKi     PINC.1
;
;#define Enki    PORTC.2
;#define kirplus PORTC.3
;#define kirmin  PORTC.4
;#define Enka    PORTC.5
;#define kaplus  PORTC.7
;#define kamin   PORTC.6
;
;bit s0,s1,s2,s3,s4,s5,s6,s7,sKa,sKi;
;char lcd[32];
;//char diffPWM = 10;
;unsigned char kursorPID, kursorSpeed, kursorGaris;
;unsigned char sensor, adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7;
;unsigned char xcount;
;unsigned char SP = 0;
;int lpwm, rpwm, MAXPWM, MINPWM, _MINPWM, intervalPWM;
;int MV, P, I, D, PV, error, last_error, rate;
;int var_Kp, var_Ki, var_Kd;
;
;eeprom unsigned char Kp = 17; //33
;eeprom unsigned char Ki = 0;
;eeprom unsigned char Kd = 11; //16
;eeprom unsigned char tempKp = 17; //33
;eeprom unsigned char tempKi = 0;
;eeprom unsigned char tempKd = 11; //16
;eeprom unsigned char MAXSpeed = 255;
;eeprom unsigned char MINSpeed = 115;
;eeprom unsigned char WarnaGaris = 1; // 1 : putih; 0 : hitam
;eeprom unsigned char SensLine = 2; // banyaknya sensor dlm 1 garis
;eeprom unsigned char Skenario = 2;
;eeprom unsigned char Mode = 1;
;eeprom unsigned char NoStrategi = 1;
;eeprom unsigned char bt7=7,bt6=7,bt5=7,bt4=7,bt3=7,bt2=7,bt1=7,bt0=7;
;eeprom unsigned char ba7=7,ba6=7,ba5=7,ba4=7,ba3=7,ba2=7,ba1=7,ba0=7;
;eeprom unsigned char bb7=200,bb6=200,bb5=200,bb4=200,bb3=200,bb2=200,bb1=200,bb0=200;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 004F {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0050         // Place your code here
; 0000 0051         xcount++;
	LDS  R30,_xcount
	SUBI R30,-LOW(1)
	STS  _xcount,R30
; 0000 0052         if(xcount<=lpwm)Enki=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRLT _0x3
	SBI  0x15,2
; 0000 0053         else Enki=0;
	RJMP _0x6
_0x3:
	CBI  0x15,2
; 0000 0054         if(xcount<=rpwm)Enka=1;
_0x6:
	CALL SUBOPT_0x2
	CALL SUBOPT_0x1
	BRLT _0x9
	SBI  0x15,5
; 0000 0055         else Enka=0;
	RJMP _0xC
_0x9:
	CBI  0x15,5
; 0000 0056         TCNT0=0xFF;
_0xC:
	LDI  R30,LOW(255)
	OUT  0x32,R30
; 0000 0057 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;typedef unsigned char byte;
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
;unsigned char read_adc(unsigned char adc_input);
;void define_char(byte flash *pc,byte char_code);
;void tampil(unsigned char dat);
;void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom );
;void setByte( byte NoMenu, byte NoSubMenu );
;void showMenu(void);
;void baca_sensor(void);
;void displaySensorBit(void);
;void maju(void);
;void mundur(void);
;void stop(char s);
;void pemercepat(void);
;void pelambat(void);
;void rotkan(void);
;void rotkir(void);
;void cek_sensor(void);
;void tune_batas(void);
;void auto_scan(void);
;void scanBlackLine(void);
;void scanSudut(void);
;void cekPointStarta(void);
;void cekPoint1a(void);
;void cekPoint2a(void);
;void cekPoint3a(void);
;void cekPoint4a(void);
;void cekPoint5a(void);
;void strategiA(void);
;void cekPointStartb(void);
;void cekPoint1b(void);
;void cekPoint2b(void);
;void cekPoint3b(void);
;void cekPoint4b(void);
;void cekPoint5b(void);
;void strategiB(void);
;void indikatorSudut(void);
;void indikatorPerempatan(void);
;
;unsigned char read_adc(unsigned char adc_input)
; 0000 008A {
_read_adc:
; 0000 008B         ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 008C 
; 0000 008D         // Delay needed for the stabilization of the ADC input voltage
; 0000 008E         delay_us(10);
	__DELAY_USB 40
; 0000 008F 
; 0000 0090         // Start the AD conversion
; 0000 0091         ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0092 
; 0000 0093         // Wait for the AD conversion to complete
; 0000 0094         while ((ADCSRA & 0x10)==0);
_0xF:
	SBIS 0x6,4
	RJMP _0xF
; 0000 0095         ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0096         return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0097 }
;
;void define_char(byte flash *pc,byte char_code)
; 0000 009A {
_define_char:
; 0000 009B         byte i,a;
; 0000 009C         a=(char_code<<3) | 0x40;
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0000 009D         for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
	LDI  R17,LOW(0)
_0x13:
	CPI  R17,8
	BRSH _0x14
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
	RJMP _0x13
_0x14:
; 0000 009E }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;
;void tampil(unsigned char dat)
; 0000 00A1 {
_tampil:
; 0000 00A2         unsigned char data;
; 0000 00A3 
; 0000 00A4         data = dat / 100;
	ST   -Y,R17
;	dat -> Y+1
;	data -> R17
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x3
; 0000 00A5         data+=0x30;
; 0000 00A6         lcd_putchar(data);
; 0000 00A7 
; 0000 00A8         dat%=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	STD  Y+1,R30
; 0000 00A9         data = dat / 10;
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x3
; 0000 00AA         data+=0x30;
; 0000 00AB         lcd_putchar(data);
; 0000 00AC 
; 0000 00AD         dat%=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+1,R30
; 0000 00AE         data = dat + 0x30;
	SUBI R30,-LOW(48)
	MOV  R17,R30
; 0000 00AF         lcd_putchar(data);
	ST   -Y,R17
	CALL _lcd_putchar
; 0000 00B0 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom )
; 0000 00B3 {
_tulisKeEEPROM:
; 0000 00B4         lcd_gotoxy(0, 0);
;	NoMenu -> Y+2
;	NoSubMenu -> Y+1
;	var_in_eeprom -> Y+0
	CALL SUBOPT_0x4
; 0000 00B5         lcd_putsf("Tulis ke EEPROM ");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x5
; 0000 00B6         lcd_putsf("...             ");
	__POINTW1FN _0x0,17
	CALL SUBOPT_0x5
; 0000 00B7         switch (NoMenu)
	LDD  R30,Y+2
	CALL SUBOPT_0x6
; 0000 00B8         {
; 0000 00B9                 case 1: // PID
	BRNE _0x18
; 0000 00BA                 switch (NoSubMenu)
	LDD  R30,Y+1
	CALL SUBOPT_0x6
; 0000 00BB                 {
; 0000 00BC                         case 1: // Kp
	BRNE _0x1C
; 0000 00BD                         Kp = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	RJMP _0x396
; 0000 00BE                         break;
; 0000 00BF 
; 0000 00C0                         case 2: // Ki
_0x1C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1D
; 0000 00C1                         Ki = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	RJMP _0x396
; 0000 00C2                         break;
; 0000 00C3 
; 0000 00C4                         case 3: // Kd
_0x1D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1B
; 0000 00C5                         Kd = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
_0x396:
	CALL __EEPROMWRB
; 0000 00C6                         break;
; 0000 00C7                 }
_0x1B:
; 0000 00C8                 break;
	RJMP _0x17
; 0000 00C9 
; 0000 00CA                 case 2: // Speed
_0x18:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F
; 0000 00CB                 switch (NoSubMenu)
	LDD  R30,Y+1
	CALL SUBOPT_0x6
; 0000 00CC                 {
; 0000 00CD                         case 1: // MAX
	BRNE _0x23
; 0000 00CE                         MAXSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	RJMP _0x397
; 0000 00CF                         break;
; 0000 00D0 
; 0000 00D1                         case 2: // MIN
_0x23:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x22
; 0000 00D2                         MINSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
_0x397:
	CALL __EEPROMWRB
; 0000 00D3                         break;
; 0000 00D4                 }
_0x22:
; 0000 00D5                 break;
	RJMP _0x17
; 0000 00D6 
; 0000 00D7                 case 3: // Warna Garis
_0x1F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x25
; 0000 00D8                 switch (NoSubMenu)
	LDD  R30,Y+1
	CALL SUBOPT_0x6
; 0000 00D9                 {
; 0000 00DA                         case 1: // Warna
	BRNE _0x29
; 0000 00DB                         WarnaGaris = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	RJMP _0x398
; 0000 00DC                         break;
; 0000 00DD 
; 0000 00DE                         case 2: // SensL
_0x29:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x28
; 0000 00DF                         SensLine = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
_0x398:
	CALL __EEPROMWRB
; 0000 00E0                         break;
; 0000 00E1                 }
_0x28:
; 0000 00E2                 break;
	RJMP _0x17
; 0000 00E3 
; 0000 00E4                 case 4: // Skenario
_0x25:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x17
; 0000 00E5                 Skenario = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMWRB
; 0000 00E6                 break;
; 0000 00E7         }
_0x17:
; 0000 00E8         delay_ms(200);
	CALL SUBOPT_0x7
; 0000 00E9 }
	ADIW R28,3
	RET
;
;void setByte( byte NoMenu, byte NoSubMenu )
; 0000 00EC {
_setByte:
; 0000 00ED         byte var_in_eeprom;
; 0000 00EE         byte plus5 = 0;
; 0000 00EF         char limitPilih = -1;
; 0000 00F0 
; 0000 00F1         lcd_clear();
	CALL __SAVELOCR4
;	NoMenu -> Y+5
;	NoSubMenu -> Y+4
;	var_in_eeprom -> R17
;	plus5 -> R16
;	limitPilih -> R19
	LDI  R16,0
	LDI  R19,255
	CALL SUBOPT_0x8
; 0000 00F2         lcd_gotoxy(0, 0);
; 0000 00F3         switch (NoMenu)
	LDD  R30,Y+5
	CALL SUBOPT_0x6
; 0000 00F4         {
; 0000 00F5                 case 1: // PID
	BRNE _0x2F
; 0000 00F6                 switch (NoSubMenu)
	LDD  R30,Y+4
	CALL SUBOPT_0x6
; 0000 00F7                 {
; 0000 00F8                         case 1: // Kp
	BRNE _0x33
; 0000 00F9                         lcd_putsf("Set Kp :        ");
	__POINTW1FN _0x0,34
	CALL SUBOPT_0x5
; 0000 00FA                         var_in_eeprom = Kp;
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	RJMP _0x399
; 0000 00FB                         break;
; 0000 00FC 
; 0000 00FD                         case 2: // Ki
_0x33:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x34
; 0000 00FE                         lcd_putsf("Set Ki :        ");
	__POINTW1FN _0x0,51
	CALL SUBOPT_0x5
; 0000 00FF                         var_in_eeprom = Ki;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	RJMP _0x399
; 0000 0100                         break;
; 0000 0101 
; 0000 0102                         case 3: // Kd
_0x34:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x32
; 0000 0103                         lcd_putsf("Set Kd :        ");
	__POINTW1FN _0x0,68
	CALL SUBOPT_0x5
; 0000 0104                         var_in_eeprom = Kd;
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
_0x399:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 0105                         break;
; 0000 0106                 }
_0x32:
; 0000 0107                 break;
	RJMP _0x2E
; 0000 0108 
; 0000 0109                 case 2: // Speed
_0x2F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x36
; 0000 010A                 plus5 = 1;
	LDI  R16,LOW(1)
; 0000 010B                 switch (NoSubMenu)
	LDD  R30,Y+4
	CALL SUBOPT_0x6
; 0000 010C                 {
; 0000 010D                         case 1: // MAX
	BRNE _0x3A
; 0000 010E                         lcd_putsf("Set MAX Speed : ");
	__POINTW1FN _0x0,85
	CALL SUBOPT_0x5
; 0000 010F                         var_in_eeprom = MAXSpeed;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	RJMP _0x39A
; 0000 0110                         break;
; 0000 0111 
; 0000 0112                         case 2: // MIN
_0x3A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x39
; 0000 0113                         lcd_putsf("Set MIN Speed : ");
	__POINTW1FN _0x0,102
	CALL SUBOPT_0x5
; 0000 0114                         var_in_eeprom = MINSpeed;
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
_0x39A:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 0115                         break;
; 0000 0116                 }
_0x39:
; 0000 0117                 break;
	RJMP _0x2E
; 0000 0118 
; 0000 0119                 case 3: // Warna Garis
_0x36:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x3C
; 0000 011A                 switch (NoSubMenu)
	LDD  R30,Y+4
	CALL SUBOPT_0x6
; 0000 011B                 {
; 0000 011C                         case 1: // Warna
	BRNE _0x40
; 0000 011D                         limitPilih = 1;
	LDI  R19,LOW(1)
; 0000 011E                         lcd_putsf("Warna Garis   : ");
	__POINTW1FN _0x0,119
	CALL SUBOPT_0x5
; 0000 011F                         var_in_eeprom = WarnaGaris;
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	RJMP _0x39B
; 0000 0120                         break;
; 0000 0121 
; 0000 0122                         case 2: // SensL
_0x40:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3F
; 0000 0123                         limitPilih = 3;
	LDI  R19,LOW(3)
; 0000 0124                         lcd_putsf("SensLine :      ");
	__POINTW1FN _0x0,136
	CALL SUBOPT_0x5
; 0000 0125                         var_in_eeprom = SensLine;
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
_0x39B:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 0126                         break;
; 0000 0127                 }
_0x3F:
; 0000 0128                 break;
	RJMP _0x2E
; 0000 0129 
; 0000 012A                 case 4: // Skenario
_0x3C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2E
; 0000 012B                 lcd_putsf("Skenario :      ");
	__POINTW1FN _0x0,153
	CALL SUBOPT_0x5
; 0000 012C                 var_in_eeprom = Skenario;
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 012D                 limitPilih = 8;
	LDI  R19,LOW(8)
; 0000 012E                 break;
; 0000 012F         }
_0x2E:
; 0000 0130 
; 0000 0131         while (sw_cancel)
_0x43:
	SBIS 0x10,3
	RJMP _0x45
; 0000 0132         {
; 0000 0133                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0134                 lcd_gotoxy(0, 1);
	CALL SUBOPT_0xA
; 0000 0135                 tampil(var_in_eeprom);
	ST   -Y,R17
	RCALL _tampil
; 0000 0136 
; 0000 0137                 if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x46
; 0000 0138                 {
; 0000 0139                         lcd_clear();
	CALL _lcd_clear
; 0000 013A                         tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R17
	RCALL _tulisKeEEPROM
; 0000 013B                         goto exitSetByte;
	RJMP _0x47
; 0000 013C                 }
; 0000 013D 
; 0000 013E                 if (!sw_down)
_0x46:
	SBIC 0x10,6
	RJMP _0x48
; 0000 013F                 {
; 0000 0140                         if ( plus5 )
	CPI  R16,0
	BREQ _0x49
; 0000 0141                                 if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x4A
; 0000 0142                                         var_in_eeprom = 255;
	LDI  R17,LOW(255)
; 0000 0143                                 else
	RJMP _0x4B
_0x4A:
; 0000 0144                                         var_in_eeprom -= 5;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,5
	MOV  R17,R30
; 0000 0145                         else
_0x4B:
	RJMP _0x4C
_0x49:
; 0000 0146                                 if ( !limitPilih )
	CPI  R19,0
	BREQ _0x39C
; 0000 0147                                         var_in_eeprom--;
; 0000 0148                                 else
; 0000 0149                                 {
; 0000 014A                                         if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x4F
; 0000 014B                                                 var_in_eeprom = limitPilih;
	MOV  R17,R19
; 0000 014C                                         else
	RJMP _0x50
_0x4F:
; 0000 014D                                                 var_in_eeprom--;
_0x39C:
	SUBI R17,1
; 0000 014E                                 }
_0x50:
_0x4C:
; 0000 014F                 }
; 0000 0150 
; 0000 0151                 if (!sw_up)
_0x48:
	SBIC 0x10,4
	RJMP _0x51
; 0000 0152                 {
; 0000 0153                         if ( plus5 )
	CPI  R16,0
	BREQ _0x52
; 0000 0154                                 if ( var_in_eeprom == 255 )
	CPI  R17,255
	BRNE _0x53
; 0000 0155                                         var_in_eeprom = 0;
	LDI  R17,LOW(0)
; 0000 0156                                 else
	RJMP _0x54
_0x53:
; 0000 0157                                         var_in_eeprom += 5;
	SUBI R17,-LOW(5)
; 0000 0158                         else
_0x54:
	RJMP _0x55
_0x52:
; 0000 0159                                 if ( !limitPilih )
	CPI  R19,0
	BREQ _0x39D
; 0000 015A                                         var_in_eeprom++;
; 0000 015B                                 else
; 0000 015C                                 {
; 0000 015D                                         if ( var_in_eeprom == limitPilih )
	CP   R19,R17
	BRNE _0x58
; 0000 015E                                                 var_in_eeprom = 0;
	LDI  R17,LOW(0)
; 0000 015F                                         else
	RJMP _0x59
_0x58:
; 0000 0160                                                 var_in_eeprom++;
_0x39D:
	SUBI R17,-1
; 0000 0161                                 }
_0x59:
_0x55:
; 0000 0162                 }
; 0000 0163         }
_0x51:
	RJMP _0x43
_0x45:
; 0000 0164 
; 0000 0165         exitSetByte:
_0x47:
; 0000 0166         delay_ms(100);
	CALL SUBOPT_0xB
; 0000 0167         lcd_clear();
; 0000 0168 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;void showMenu(void)
; 0000 016B {
_showMenu:
; 0000 016C         lcd_clear();
	CALL _lcd_clear
; 0000 016D     menu01:
_0x5A:
; 0000 016E         delay_ms(125);   // bouncing sw
	CALL SUBOPT_0xC
; 0000 016F         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0170                 // 0123456789abcdef
; 0000 0171         lcd_putsf("  Set PID       ");
	__POINTW1FN _0x0,170
	CALL SUBOPT_0x5
; 0000 0172         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0173         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x5
; 0000 0174 
; 0000 0175         // kursor awal
; 0000 0176         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0177         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0178 
; 0000 0179         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x5B
; 0000 017A         {
; 0000 017B                 lcd_clear();
	CALL _lcd_clear
; 0000 017C                 kursorPID = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 017D                 goto setPID;
	RJMP _0x5C
; 0000 017E         }
; 0000 017F         if (!sw_down)
_0x5B:
	SBIS 0x10,6
; 0000 0180         {
; 0000 0181                 goto menu02;
	RJMP _0x5E
; 0000 0182         }
; 0000 0183         if (!sw_up)
	SBIC 0x10,4
	RJMP _0x5F
; 0000 0184         {
; 0000 0185                 lcd_clear();
	CALL _lcd_clear
; 0000 0186                 goto menu06;
	RJMP _0x60
; 0000 0187         }
; 0000 0188         if (!sw_cancel)
_0x5F:
	SBIC 0x10,3
	RJMP _0x61
; 0000 0189         {
; 0000 018A                 delay_ms(125);
	CALL SUBOPT_0xC
; 0000 018B                 backlight = 0;
	CBI  0x18,3
; 0000 018C         }
; 0000 018D 
; 0000 018E         goto menu01;
_0x61:
	RJMP _0x5A
; 0000 018F     menu02:
_0x5E:
; 0000 0190         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0191         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0192                  // 0123456789abcdef
; 0000 0193         lcd_putsf("  Set PID       ");
	__POINTW1FN _0x0,170
	CALL SUBOPT_0x5
; 0000 0194         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0195         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x5
; 0000 0196 
; 0000 0197         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0198         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0199 
; 0000 019A         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x64
; 0000 019B         {
; 0000 019C                 lcd_clear();
	CALL _lcd_clear
; 0000 019D                 kursorSpeed = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 019E                 goto setSpeed;
	RJMP _0x65
; 0000 019F         }
; 0000 01A0         if (!sw_up)
_0x64:
	SBIS 0x10,4
; 0000 01A1         {
; 0000 01A2                 goto menu01;
	RJMP _0x5A
; 0000 01A3         }
; 0000 01A4         if (!sw_down)
	SBIC 0x10,6
	RJMP _0x67
; 0000 01A5         {
; 0000 01A6                 lcd_clear();
	CALL _lcd_clear
; 0000 01A7                 goto menu03;
	RJMP _0x68
; 0000 01A8         }
; 0000 01A9         if (!sw_cancel)
_0x67:
	SBIC 0x10,3
	RJMP _0x69
; 0000 01AA         {
; 0000 01AB                 delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01AC                 backlight = 0;
	CBI  0x18,3
; 0000 01AD         }
; 0000 01AE         goto menu02;
_0x69:
	RJMP _0x5E
; 0000 01AF     menu03:
_0x68:
; 0000 01B0         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01B1         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 01B2                 // 0123456789abcdef
; 0000 01B3         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0x0,204
	CALL SUBOPT_0x5
; 0000 01B4         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 01B5         lcd_putsf("  Not Used !    ");
	__POINTW1FN _0x0,221
	CALL SUBOPT_0x5
; 0000 01B6 
; 0000 01B7         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 01B8         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 01B9 
; 0000 01BA         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x6C
; 0000 01BB         {
; 0000 01BC                 lcd_clear();
	CALL _lcd_clear
; 0000 01BD                 kursorGaris = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 01BE                 goto setGaris;
	RJMP _0x6D
; 0000 01BF         }
; 0000 01C0         if (!sw_up)
_0x6C:
	SBIC 0x10,4
	RJMP _0x6E
; 0000 01C1         {
; 0000 01C2                 lcd_clear();
	CALL _lcd_clear
; 0000 01C3                 goto menu02;
	RJMP _0x5E
; 0000 01C4         }
; 0000 01C5         if (!sw_down)
_0x6E:
	SBIS 0x10,6
; 0000 01C6         {
; 0000 01C7                 goto menu04;
	RJMP _0x70
; 0000 01C8         }
; 0000 01C9         if (!sw_cancel)
	SBIC 0x10,3
	RJMP _0x71
; 0000 01CA         {
; 0000 01CB                 delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01CC                 backlight = 0;
	CBI  0x18,3
; 0000 01CD         }
; 0000 01CE         goto menu03;
_0x71:
	RJMP _0x68
; 0000 01CF     menu04:
_0x70:
; 0000 01D0         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01D1         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 01D2                 // 0123456789abcdef
; 0000 01D3         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0x0,204
	CALL SUBOPT_0x5
; 0000 01D4         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 01D5         lcd_putsf("  Not Used !    ");
	__POINTW1FN _0x0,221
	CALL SUBOPT_0x5
; 0000 01D6 
; 0000 01D7         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 01D8         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 01D9 
; 0000 01DA         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x74
; 0000 01DB         {
; 0000 01DC                 lcd_clear();
	CALL _lcd_clear
; 0000 01DD                 goto setSkenario;
	RJMP _0x75
; 0000 01DE         }
; 0000 01DF         if (!sw_up)
_0x74:
	SBIS 0x10,4
; 0000 01E0         {
; 0000 01E1                 goto menu03;
	RJMP _0x68
; 0000 01E2         }
; 0000 01E3         if (!sw_down)
	SBIC 0x10,6
	RJMP _0x77
; 0000 01E4         {
; 0000 01E5                 lcd_clear();
	CALL _lcd_clear
; 0000 01E6                 goto menu05;
	RJMP _0x78
; 0000 01E7         }
; 0000 01E8         if (!sw_cancel)
_0x77:
	SBIC 0x10,3
	RJMP _0x79
; 0000 01E9         {
; 0000 01EA                 delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01EB                 backlight = 0;
	CBI  0x18,3
; 0000 01EC         }
; 0000 01ED         goto menu04;
_0x79:
	RJMP _0x70
; 0000 01EE     menu05:            // Bikin sendiri lhoo ^^d
_0x78:
; 0000 01EF         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01F0         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 01F1         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0x0,238
	CALL SUBOPT_0x5
; 0000 01F2         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 01F3         lcd_putsf("  Start!!      ");
	__POINTW1FN _0x0,258
	CALL SUBOPT_0x5
; 0000 01F4 
; 0000 01F5         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 01F6         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 01F7 
; 0000 01F8         if  (!sw_ok)
	SBIC 0x10,5
	RJMP _0x7C
; 0000 01F9         {
; 0000 01FA             lcd_clear();
	CALL _lcd_clear
; 0000 01FB             goto mode;
	RJMP _0x7D
; 0000 01FC         }
; 0000 01FD 
; 0000 01FE         if  (!sw_up)
_0x7C:
	SBIC 0x10,4
	RJMP _0x7E
; 0000 01FF         {
; 0000 0200             lcd_clear();
	CALL _lcd_clear
; 0000 0201             goto menu04;
	RJMP _0x70
; 0000 0202         }
; 0000 0203 
; 0000 0204         if  (!sw_down)
_0x7E:
	SBIS 0x10,6
; 0000 0205         {
; 0000 0206             goto menu06;
	RJMP _0x60
; 0000 0207         }
; 0000 0208         if (!sw_cancel)
	SBIC 0x10,3
	RJMP _0x80
; 0000 0209         {
; 0000 020A                 delay_ms(125);
	CALL SUBOPT_0xC
; 0000 020B                 backlight = 0;
	CBI  0x18,3
; 0000 020C         }
; 0000 020D 
; 0000 020E         goto menu05;
_0x80:
	RJMP _0x78
; 0000 020F     menu06:
_0x60:
; 0000 0210         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0211         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0212         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0x0,238
	CALL SUBOPT_0x5
; 0000 0213         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0214         lcd_putsf("  Start!!      ");
	__POINTW1FN _0x0,258
	CALL SUBOPT_0x5
; 0000 0215 
; 0000 0216         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0217         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0218 
; 0000 0219         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x83
; 0000 021A         {
; 0000 021B                 lcd_clear();
	CALL _lcd_clear
; 0000 021C                 goto startRobot;
	RJMP _0x84
; 0000 021D         }
; 0000 021E 
; 0000 021F         if (!sw_up)
_0x83:
	SBIS 0x10,4
; 0000 0220         {
; 0000 0221                 goto menu05;
	RJMP _0x78
; 0000 0222         }
; 0000 0223 
; 0000 0224         if (!sw_down)
	SBIC 0x10,6
	RJMP _0x86
; 0000 0225         {
; 0000 0226                 lcd_clear();
	CALL _lcd_clear
; 0000 0227                 goto menu01;
	RJMP _0x5A
; 0000 0228         }
; 0000 0229 
; 0000 022A         goto menu06;
_0x86:
	RJMP _0x60
; 0000 022B 
; 0000 022C 
; 0000 022D     setPID:
_0x5C:
; 0000 022E         delay_ms(150);
	CALL SUBOPT_0x9
; 0000 022F         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0230                 // 0123456789ABCDEF
; 0000 0231         lcd_putsf("  Kp   Ki   Kd  ");
	__POINTW1FN _0x0,274
	CALL SUBOPT_0x5
; 0000 0232         // lcd_putsf(" 250  200  300  ");
; 0000 0233         lcd_putchar(' ');
	CALL SUBOPT_0xE
; 0000 0234         tampil(Kp); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	CALL SUBOPT_0xE
; 0000 0235         tampil(Ki); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
	CALL SUBOPT_0xE
; 0000 0236         tampil(Kd); lcd_putchar(' '); lcd_putchar(' ');
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL SUBOPT_0x12
	CALL SUBOPT_0xE
; 0000 0237 
; 0000 0238         switch (kursorPID)
	MOV  R30,R5
	CALL SUBOPT_0x6
; 0000 0239         {
; 0000 023A           case 1:
	BRNE _0x8A
; 0000 023B                 lcd_gotoxy(1,0); // kursor Kp
	LDI  R30,LOW(1)
	RJMP _0x39E
; 0000 023C                 lcd_putchar(0);
; 0000 023D                 break;
; 0000 023E           case 2:
_0x8A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8B
; 0000 023F                 lcd_gotoxy(6,0); // kursor Ki
	LDI  R30,LOW(6)
	RJMP _0x39E
; 0000 0240                 lcd_putchar(0);
; 0000 0241                 break;
; 0000 0242           case 3:
_0x8B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x89
; 0000 0243                 lcd_gotoxy(11,0); // kursor Kd
	LDI  R30,LOW(11)
_0x39E:
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 0244                 lcd_putchar(0);
; 0000 0245                 break;
; 0000 0246         }
_0x89:
; 0000 0247 
; 0000 0248         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x8D
; 0000 0249         {
; 0000 024A                 setByte( 1, kursorPID);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R5
	CALL SUBOPT_0x14
; 0000 024B                 delay_ms(200);
; 0000 024C         }
; 0000 024D         if (!sw_up)
_0x8D:
	SBIC 0x10,4
	RJMP _0x8E
; 0000 024E         {
; 0000 024F                 if (kursorPID == 3) {
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x8F
; 0000 0250                         kursorPID = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0251                 } else kursorPID++;
	RJMP _0x90
_0x8F:
	INC  R5
; 0000 0252         }
_0x90:
; 0000 0253         if (!sw_down)
_0x8E:
	SBIC 0x10,6
	RJMP _0x91
; 0000 0254         {
; 0000 0255                 if (kursorPID == 1) {
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x92
; 0000 0256                         kursorPID = 3;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 0257                 } else kursorPID--;
	RJMP _0x93
_0x92:
	DEC  R5
; 0000 0258         }
_0x93:
; 0000 0259 
; 0000 025A         if (!sw_cancel)
_0x91:
	SBIC 0x10,3
	RJMP _0x94
; 0000 025B         {
; 0000 025C                 lcd_clear();
	CALL _lcd_clear
; 0000 025D                 goto menu01;
	RJMP _0x5A
; 0000 025E         }
; 0000 025F 
; 0000 0260         goto setPID;
_0x94:
	RJMP _0x5C
; 0000 0261 
; 0000 0262     setSpeed:
_0x65:
; 0000 0263         delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0264         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0265                 // 0123456789ABCDEF
; 0000 0266         lcd_putsf("   MAX    MIN   ");
	__POINTW1FN _0x0,291
	CALL SUBOPT_0x5
; 0000 0267         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
; 0000 0268 
; 0000 0269         //lcd_putsf("   250    200   ");
; 0000 026A         tampil(MAXSpeed);
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL SUBOPT_0x12
; 0000 026B         lcd_putchar(' '); lcd_putchar(' ');lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
; 0000 026C         tampil(MINSpeed);
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x12
; 0000 026D         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
; 0000 026E 
; 0000 026F         switch (kursorSpeed)
	MOV  R30,R4
	CALL SUBOPT_0x6
; 0000 0270         {
; 0000 0271           case 1:
	BRNE _0x98
; 0000 0272                 lcd_gotoxy(2,0); // kursor MAX
	LDI  R30,LOW(2)
	RJMP _0x39F
; 0000 0273                 lcd_putchar(0);
; 0000 0274                 break;
; 0000 0275           case 2:
_0x98:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x97
; 0000 0276                 lcd_gotoxy(9,0); // kursor MIN
	LDI  R30,LOW(9)
_0x39F:
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 0277                 lcd_putchar(0);
; 0000 0278                 break;
; 0000 0279         }
_0x97:
; 0000 027A 
; 0000 027B         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x9A
; 0000 027C         {
; 0000 027D                 setByte( 2, kursorSpeed);
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R4
	CALL SUBOPT_0x14
; 0000 027E                 delay_ms(200);
; 0000 027F         }
; 0000 0280         if (!sw_up)
_0x9A:
	SBIC 0x10,4
	RJMP _0x9B
; 0000 0281         {
; 0000 0282                 if (kursorSpeed == 2)
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x9C
; 0000 0283                 {
; 0000 0284                         kursorSpeed = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0285                 } else kursorSpeed++;
	RJMP _0x9D
_0x9C:
	INC  R4
; 0000 0286         }
_0x9D:
; 0000 0287         if (!sw_down)
_0x9B:
	SBIC 0x10,6
	RJMP _0x9E
; 0000 0288         {
; 0000 0289                 if (kursorSpeed == 1)
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x9F
; 0000 028A                 {
; 0000 028B                         kursorSpeed = 2;
	LDI  R30,LOW(2)
	MOV  R4,R30
; 0000 028C                 } else kursorSpeed--;
	RJMP _0xA0
_0x9F:
	DEC  R4
; 0000 028D         }
_0xA0:
; 0000 028E 
; 0000 028F         if (!sw_cancel)
_0x9E:
	SBIC 0x10,3
	RJMP _0xA1
; 0000 0290         {
; 0000 0291                 lcd_clear();
	CALL _lcd_clear
; 0000 0292                 goto menu02;
	RJMP _0x5E
; 0000 0293         }
; 0000 0294 
; 0000 0295         goto setSpeed;
_0xA1:
	RJMP _0x65
; 0000 0296 
; 0000 0297      setGaris: // not yet
_0x6D:
; 0000 0298         delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0299         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 029A                 // 0123456789ABCDEF
; 0000 029B         if ( WarnaGaris == 1 )
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0xA2
; 0000 029C                 lcd_putsf("  WARNA : Putih ");
	__POINTW1FN _0x0,308
	RJMP _0x3A0
; 0000 029D         else
_0xA2:
; 0000 029E                 lcd_putsf("  WARNA : Hitam ");
	__POINTW1FN _0x0,325
_0x3A0:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 029F 
; 0000 02A0         //lcd_putsf("  LEBAR: 1.5 cm ");
; 0000 02A1         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 02A2         lcd_putsf("  SensL :        ");
	__POINTW1FN _0x0,342
	CALL SUBOPT_0x5
; 0000 02A3         lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x15
; 0000 02A4         tampil( SensLine );
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _tampil
; 0000 02A5 
; 0000 02A6         switch (kursorGaris)
	MOV  R30,R7
	CALL SUBOPT_0x6
; 0000 02A7         {
; 0000 02A8           case 1:
	BRNE _0xA7
; 0000 02A9                 lcd_gotoxy(0,0); // kursor Warna
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x3A1
; 0000 02AA                 lcd_putchar(0);
; 0000 02AB                 break;
; 0000 02AC           case 2:
_0xA7:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA6
; 0000 02AD                 lcd_gotoxy(0,1); // kursor SensL
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x3A1:
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 02AE                 lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 02AF                 break;
; 0000 02B0         }
_0xA6:
; 0000 02B1 
; 0000 02B2         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0xA9
; 0000 02B3         {
; 0000 02B4                 setByte( 3, kursorGaris);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R7
	CALL SUBOPT_0x14
; 0000 02B5                 delay_ms(200);
; 0000 02B6         }
; 0000 02B7         if (!sw_up)
_0xA9:
	SBIC 0x10,4
	RJMP _0xAA
; 0000 02B8         {
; 0000 02B9                 if (kursorGaris == 2)
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0xAB
; 0000 02BA                 {
; 0000 02BB                         kursorGaris = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 02BC                 } else kursorGaris++;
	RJMP _0xAC
_0xAB:
	INC  R7
; 0000 02BD         }
_0xAC:
; 0000 02BE         if (!sw_down)
_0xAA:
	SBIC 0x10,6
	RJMP _0xAD
; 0000 02BF         {
; 0000 02C0                 if (kursorGaris == 1)
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0xAE
; 0000 02C1                 {
; 0000 02C2                         kursorGaris = 2;
	LDI  R30,LOW(2)
	MOV  R7,R30
; 0000 02C3                 } else kursorGaris--;
	RJMP _0xAF
_0xAE:
	DEC  R7
; 0000 02C4         }
_0xAF:
; 0000 02C5 
; 0000 02C6         if (!sw_cancel)
_0xAD:
	SBIC 0x10,3
	RJMP _0xB0
; 0000 02C7         {
; 0000 02C8                 lcd_clear();
	CALL _lcd_clear
; 0000 02C9                 goto menu03;
	RJMP _0x68
; 0000 02CA         }
; 0000 02CB 
; 0000 02CC         goto setGaris;
_0xB0:
	RJMP _0x6D
; 0000 02CD 
; 0000 02CE      setSkenario:
_0x75:
; 0000 02CF         delay_ms(150);
	CALL SUBOPT_0x9
; 0000 02D0         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 02D1                 // 0123456789ABCDEF
; 0000 02D2         lcd_putsf("Sken. yg  dpake:");
	__POINTW1FN _0x0,360
	CALL SUBOPT_0x5
; 0000 02D3         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xA
; 0000 02D4         tampil( Skenario );
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _tampil
; 0000 02D5 
; 0000 02D6         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0xB1
; 0000 02D7         {
; 0000 02D8                 setByte( 4, 0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x14
; 0000 02D9                 delay_ms(200);
; 0000 02DA         }
; 0000 02DB 
; 0000 02DC         if (!sw_cancel)
_0xB1:
	SBIC 0x10,3
	RJMP _0xB2
; 0000 02DD         {
; 0000 02DE                 lcd_clear();
	CALL _lcd_clear
; 0000 02DF                 goto menu04;
	RJMP _0x70
; 0000 02E0         }
; 0000 02E1 
; 0000 02E2         goto setSkenario;
_0xB2:
	RJMP _0x75
; 0000 02E3 
; 0000 02E4      mode:
_0x7D:
; 0000 02E5         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 02E6         if  (!sw_up)
	SBIC 0x10,4
	RJMP _0xB3
; 0000 02E7         {
; 0000 02E8             if (Mode==6)
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x6)
	BRNE _0xB4
; 0000 02E9             {
; 0000 02EA                 Mode=1;
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 02EB             }
; 0000 02EC 
; 0000 02ED             else Mode++;
	RJMP _0xB5
_0xB4:
	CALL SUBOPT_0x16
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 02EE 
; 0000 02EF             goto nomorMode;
_0xB5:
	RJMP _0xB6
; 0000 02F0         }
; 0000 02F1 
; 0000 02F2         if  (!sw_down)
_0xB3:
	SBIC 0x10,6
	RJMP _0xB7
; 0000 02F3         {
; 0000 02F4             if  (Mode==1)
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x1)
	BRNE _0xB8
; 0000 02F5             {
; 0000 02F6                 Mode=6;
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	LDI  R30,LOW(6)
	CALL __EEPROMWRB
; 0000 02F7             }
; 0000 02F8 
; 0000 02F9             else Mode--;
	RJMP _0xB9
_0xB8:
	CALL SUBOPT_0x16
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
; 0000 02FA 
; 0000 02FB             goto nomorMode;
_0xB9:
; 0000 02FC         }
; 0000 02FD 
; 0000 02FE         nomorMode:
_0xB7:
_0xB6:
; 0000 02FF             if (Mode==1)
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x1)
	BRNE _0xBA
; 0000 0300             {
; 0000 0301                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 0302                 lcd_gotoxy(0,0);
; 0000 0303                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 0304                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0305                 lcd_putsf(" 1.Lihat ADC");
	__POINTW1FN _0x0,394
	CALL SUBOPT_0x5
; 0000 0306             }
; 0000 0307 
; 0000 0308             if  (Mode==2)
_0xBA:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x2)
	BRNE _0xBB
; 0000 0309             {
; 0000 030A                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 030B                 lcd_gotoxy(0,0);
; 0000 030C                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 030D                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 030E                 lcd_putsf(" 2.Test Mode");
	__POINTW1FN _0x0,407
	CALL SUBOPT_0x5
; 0000 030F             }
; 0000 0310 
; 0000 0311             if  (Mode==3)
_0xBB:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x3)
	BRNE _0xBC
; 0000 0312             {
; 0000 0313                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 0314                 lcd_gotoxy(0,0);
; 0000 0315                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 0316                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0317                 lcd_putsf(" 3.Cek Sensor ");
	__POINTW1FN _0x0,420
	CALL SUBOPT_0x5
; 0000 0318             }
; 0000 0319 
; 0000 031A             if  (Mode==4)
_0xBC:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x4)
	BRNE _0xBD
; 0000 031B             {
; 0000 031C                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 031D                 lcd_gotoxy(0,0);
; 0000 031E                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 031F                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0320                 lcd_putsf(" 4.Auto Tune 1-1");
	__POINTW1FN _0x0,435
	CALL SUBOPT_0x5
; 0000 0321             }
; 0000 0322 
; 0000 0323              if  (Mode==5)
_0xBD:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x5)
	BRNE _0xBE
; 0000 0324             {
; 0000 0325                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 0326                 lcd_gotoxy(0,0);
; 0000 0327                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 0328                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0329                 lcd_putsf(" 5.Auto Tune ");
	__POINTW1FN _0x0,452
	CALL SUBOPT_0x5
; 0000 032A             }
; 0000 032B 
; 0000 032C             if  (Mode==6)
_0xBE:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x6)
	BRNE _0xBF
; 0000 032D             {
; 0000 032E                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 032F                 lcd_gotoxy(0,0);
; 0000 0330                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 0331                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0332                 lcd_putsf(" 6.Cek PWM Aktif");
	__POINTW1FN _0x0,466
	CALL SUBOPT_0x5
; 0000 0333             }
; 0000 0334 
; 0000 0335         if  (!sw_ok)
_0xBF:
	SBIC 0x10,5
	RJMP _0xC0
; 0000 0336         {
; 0000 0337             switch  (Mode)
	CALL SUBOPT_0x16
	CALL SUBOPT_0x6
; 0000 0338             {
; 0000 0339                 case 1:
	BRNE _0xC4
; 0000 033A                 {
; 0000 033B                     for(;;)
_0xC6:
; 0000 033C                     {
; 0000 033D                         lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x18
; 0000 033E                         sprintf(lcd," %d %d %d %d",read_adc(3),read_adc(2),read_adc(1),read_adc(0));
	CALL SUBOPT_0x19
	__POINTW1FN _0x0,483
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1F
; 0000 033F                         lcd_puts(lcd);
	CALL _lcd_puts
; 0000 0340                         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 0341                         sprintf(lcd,"%d %d %d %d",read_adc(7),read_adc(6),read_adc(5),read_adc(4));
	CALL SUBOPT_0x19
	__POINTW1FN _0x0,484
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1F
; 0000 0342                         lcd_puts(lcd);
	CALL _lcd_puts
; 0000 0343                         delay_ms(100);
	CALL SUBOPT_0xB
; 0000 0344                         lcd_clear();
; 0000 0345                     }
	RJMP _0xC6
; 0000 0346                 }
; 0000 0347                 break;
; 0000 0348 
; 0000 0349                 case 2:
_0xC4:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC8
; 0000 034A                 {
; 0000 034B                     cek_sensor();
	RCALL _cek_sensor
; 0000 034C                 }
; 0000 034D                 break;
	RJMP _0xC3
; 0000 034E 
; 0000 034F                 case 3:
_0xC8:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC9
; 0000 0350                 {
; 0000 0351                     cek_sensor();
	RCALL _cek_sensor
; 0000 0352                 }
; 0000 0353                 break;
	RJMP _0xC3
; 0000 0354 
; 0000 0355                 case 4:
_0xC9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xCA
; 0000 0356                 {
; 0000 0357                     tune_batas();
	RCALL _tune_batas
; 0000 0358 
; 0000 0359                 }
; 0000 035A                 break;
	RJMP _0xC3
; 0000 035B 
; 0000 035C                 case 5:
_0xCA:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xCB
; 0000 035D                 {
; 0000 035E                     auto_scan();
	RCALL _auto_scan
; 0000 035F                     goto menu01;
	RJMP _0x5A
; 0000 0360                 }
; 0000 0361                 break;
; 0000 0362 
; 0000 0363                 case 6:
_0xCB:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xC3
; 0000 0364                 {
; 0000 0365                     pemercepat();
	RCALL _pemercepat
; 0000 0366                     pelambat();
	RCALL _pelambat
; 0000 0367                     goto menu01;
	RJMP _0x5A
; 0000 0368                 }
; 0000 0369                 break;
; 0000 036A             }
_0xC3:
; 0000 036B         }
; 0000 036C 
; 0000 036D         if  (!sw_cancel)
_0xC0:
	SBIC 0x10,3
	RJMP _0xCD
; 0000 036E         {
; 0000 036F             lcd_clear();
	CALL _lcd_clear
; 0000 0370             goto menu05;
	RJMP _0x78
; 0000 0371         }
; 0000 0372 
; 0000 0373         goto mode;
_0xCD:
	RJMP _0x7D
; 0000 0374 
; 0000 0375      startRobot:
_0x84:
; 0000 0376         lcd_clear();
	CALL _lcd_clear
; 0000 0377 }
	RET
;
;void baca_sensor(void)
; 0000 037A {
_baca_sensor:
; 0000 037B     sensor=0;
	CLR  R6
; 0000 037C     adc0=read_adc(7);
	CALL SUBOPT_0x20
	MOV  R9,R30
; 0000 037D     adc1=read_adc(6);
	CALL SUBOPT_0x21
	MOV  R8,R30
; 0000 037E     adc2=read_adc(5);
	CALL SUBOPT_0x22
	MOV  R11,R30
; 0000 037F     adc3=read_adc(4);
	CALL SUBOPT_0x23
	MOV  R10,R30
; 0000 0380     adc4=read_adc(3);
	CALL SUBOPT_0x1A
	MOV  R13,R30
; 0000 0381     adc5=read_adc(2);
	CALL SUBOPT_0x1C
	MOV  R12,R30
; 0000 0382     adc6=read_adc(1);
	CALL SUBOPT_0x1D
	STS  _adc6,R30
; 0000 0383     adc7=read_adc(0);
	CALL SUBOPT_0x1E
	STS  _adc7,R30
; 0000 0384 
; 0000 0385     if(adc0>bt0){s0=1;sensor=sensor|1<<0;}      // deteksi hitam
	CALL SUBOPT_0x24
	CP   R30,R9
	BRSH _0xCE
	SET
	BLD  R2,0
	LDI  R30,LOW(1)
	RJMP _0x3A2
; 0000 0386     else {s0=0;sensor=sensor|0<<0;}             // deteksi putih
_0xCE:
	CLT
	BLD  R2,0
	LDI  R30,LOW(0)
_0x3A2:
	OR   R6,R30
; 0000 0387 
; 0000 0388     if(adc1>bt1){s1=1;sensor=sensor|1<<1;}
	CALL SUBOPT_0x25
	CP   R30,R8
	BRSH _0xD0
	SET
	BLD  R2,1
	LDI  R30,LOW(2)
	RJMP _0x3A3
; 0000 0389     else {s1=0;sensor=sensor|0<<1;}
_0xD0:
	CLT
	BLD  R2,1
	LDI  R30,LOW(0)
_0x3A3:
	OR   R6,R30
; 0000 038A 
; 0000 038B     if(adc2>bt2){s2=1;sensor=sensor|1<<2;}
	CALL SUBOPT_0x26
	CP   R30,R11
	BRSH _0xD2
	SET
	BLD  R2,2
	LDI  R30,LOW(4)
	RJMP _0x3A4
; 0000 038C     else {s2=0;sensor=sensor|0<<2;}
_0xD2:
	CLT
	BLD  R2,2
	LDI  R30,LOW(0)
_0x3A4:
	OR   R6,R30
; 0000 038D 
; 0000 038E     if(adc3>bt3){s3=1;sensor=sensor|1<<3;}
	CALL SUBOPT_0x27
	CP   R30,R10
	BRSH _0xD4
	SET
	BLD  R2,3
	LDI  R30,LOW(8)
	RJMP _0x3A5
; 0000 038F     else {s3=0;sensor=sensor|0<<3;}
_0xD4:
	CLT
	BLD  R2,3
	LDI  R30,LOW(0)
_0x3A5:
	OR   R6,R30
; 0000 0390 
; 0000 0391     if(adc4>bt4){s4=1;sensor=sensor|1<<4;}
	CALL SUBOPT_0x28
	CP   R30,R13
	BRSH _0xD6
	SET
	BLD  R2,4
	LDI  R30,LOW(16)
	RJMP _0x3A6
; 0000 0392     else {s4=0;sensor=sensor|0<<4;}
_0xD6:
	CLT
	BLD  R2,4
	LDI  R30,LOW(0)
_0x3A6:
	OR   R6,R30
; 0000 0393 
; 0000 0394     if(adc5>bt5){s5=1;sensor=sensor|1<<5;}
	CALL SUBOPT_0x29
	CP   R30,R12
	BRSH _0xD8
	SET
	BLD  R2,5
	LDI  R30,LOW(32)
	RJMP _0x3A7
; 0000 0395     else {s5=0;sensor=sensor|0<<5;}
_0xD8:
	CLT
	BLD  R2,5
	LDI  R30,LOW(0)
_0x3A7:
	OR   R6,R30
; 0000 0396 
; 0000 0397     if(adc6>bt6){s6=1;sensor=sensor|1<<6;}
	CALL SUBOPT_0x2A
	LDS  R26,_adc6
	CP   R30,R26
	BRSH _0xDA
	SET
	BLD  R2,6
	LDI  R30,LOW(64)
	RJMP _0x3A8
; 0000 0398     else {s6=0;sensor=sensor|0<<6;}
_0xDA:
	CLT
	BLD  R2,6
	LDI  R30,LOW(0)
_0x3A8:
	OR   R6,R30
; 0000 0399 
; 0000 039A     if(adc7>bt7){s7=1;sensor=sensor|1<<7;}
	CALL SUBOPT_0x2B
	LDS  R26,_adc7
	CP   R30,R26
	BRSH _0xDC
	SET
	BLD  R2,7
	LDI  R30,LOW(128)
	RJMP _0x3A9
; 0000 039B     else {s7=0;sensor=sensor|0<<7;}
_0xDC:
	CLT
	BLD  R2,7
	LDI  R30,LOW(0)
_0x3A9:
	OR   R6,R30
; 0000 039C 
; 0000 039D     // hitam dari 1 dibuat 0
; 0000 039E     // putih dari 0 dibuat 1
; 0000 039F     s0 = ~s0;
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 03A0     s1 = ~s1;
	LDI  R30,LOW(2)
	EOR  R2,R30
; 0000 03A1     s2 = ~s2;
	LDI  R30,LOW(4)
	EOR  R2,R30
; 0000 03A2     s3 = ~s3;
	LDI  R30,LOW(8)
	EOR  R2,R30
; 0000 03A3     s4 = ~s4;
	LDI  R30,LOW(16)
	EOR  R2,R30
; 0000 03A4     s5 = ~s5;
	LDI  R30,LOW(32)
	EOR  R2,R30
; 0000 03A5     s6 = ~s6;
	LDI  R30,LOW(64)
	EOR  R2,R30
; 0000 03A6     s7 = ~s7;
	LDI  R30,LOW(128)
	EOR  R2,R30
; 0000 03A7 
; 0000 03A8     sensor = ~sensor;
	COM  R6
; 0000 03A9 
; 0000 03AA     if(PINC.0)  sKa = 0;
	SBIS 0x13,0
	RJMP _0xDE
	CLT
	RJMP _0x3AA
; 0000 03AB     else        sKa = 1;
_0xDE:
	SET
_0x3AA:
	BLD  R3,0
; 0000 03AC 
; 0000 03AD     if(PINC.1)  sKi = 0;
	SBIS 0x13,1
	RJMP _0xE0
	CLT
	RJMP _0x3AB
; 0000 03AE     else        sKi = 1;
_0xE0:
	SET
_0x3AB:
	BLD  R3,1
; 0000 03AF }
	RET
;
;void displaySensorBit(void)
; 0000 03B2 {
_displaySensorBit:
; 0000 03B3     baca_sensor();
	RCALL _baca_sensor
; 0000 03B4 
; 0000 03B5     lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x15
; 0000 03B6     if (s7) lcd_putchar('1');
	SBRS R2,7
	RJMP _0xE2
	LDI  R30,LOW(49)
	RJMP _0x3AC
; 0000 03B7     else    lcd_putchar('0');
_0xE2:
	LDI  R30,LOW(48)
_0x3AC:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03B8     if (s6) lcd_putchar('1');
	SBRS R2,6
	RJMP _0xE4
	LDI  R30,LOW(49)
	RJMP _0x3AD
; 0000 03B9     else    lcd_putchar('0');
_0xE4:
	LDI  R30,LOW(48)
_0x3AD:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03BA     if (s5) lcd_putchar('1');
	SBRS R2,5
	RJMP _0xE6
	LDI  R30,LOW(49)
	RJMP _0x3AE
; 0000 03BB     else    lcd_putchar('0');
_0xE6:
	LDI  R30,LOW(48)
_0x3AE:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03BC     if (s4) lcd_putchar('1');
	SBRS R2,4
	RJMP _0xE8
	LDI  R30,LOW(49)
	RJMP _0x3AF
; 0000 03BD     else    lcd_putchar('0');
_0xE8:
	LDI  R30,LOW(48)
_0x3AF:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03BE     if (s3) lcd_putchar('1');
	SBRS R2,3
	RJMP _0xEA
	LDI  R30,LOW(49)
	RJMP _0x3B0
; 0000 03BF     else    lcd_putchar('0');
_0xEA:
	LDI  R30,LOW(48)
_0x3B0:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03C0     if (s2) lcd_putchar('1');
	SBRS R2,2
	RJMP _0xEC
	LDI  R30,LOW(49)
	RJMP _0x3B1
; 0000 03C1     else    lcd_putchar('0');
_0xEC:
	LDI  R30,LOW(48)
_0x3B1:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03C2     if (s1) lcd_putchar('1');
	SBRS R2,1
	RJMP _0xEE
	LDI  R30,LOW(49)
	RJMP _0x3B2
; 0000 03C3     else    lcd_putchar('0');
_0xEE:
	LDI  R30,LOW(48)
_0x3B2:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03C4     if (s0) lcd_putchar('1');
	SBRS R2,0
	RJMP _0xF0
	LDI  R30,LOW(49)
	RJMP _0x3B3
; 0000 03C5     else    lcd_putchar('0');
_0xF0:
	LDI  R30,LOW(48)
_0x3B3:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03C6 }
	RET
;
;void maju(void)
; 0000 03C9 {
_maju:
; 0000 03CA         kaplus=1;kirplus=1;
	SBI  0x15,7
	SBI  0x15,3
; 0000 03CB         kamin=0;kirmin=0;
	CBI  0x15,6
	RJMP _0x2080010
; 0000 03CC }
;
;void mundur(void)
; 0000 03CF {
_mundur:
; 0000 03D0         kaplus=0;kirplus=0;
	CBI  0x15,7
	CBI  0x15,3
; 0000 03D1         kamin=1;kirmin=1;
	SBI  0x15,6
	RJMP _0x208000F
; 0000 03D2 }
;
;void bkir(void)
; 0000 03D5 {
_bkir:
; 0000 03D6         kirplus=0;
	RJMP _0x208000E
; 0000 03D7         kirmin=1;
; 0000 03D8 }
;
;void bkan(void)
; 0000 03DB {
_bkan:
; 0000 03DC         kaplus=0;
	CBI  0x15,7
; 0000 03DD         kamin=1;
	SBI  0x15,6
; 0000 03DE }
	RET
;
;void stop(char s)
; 0000 03E1 {
_stop:
; 0000 03E2         char i;
; 0000 03E3         for(i=0;i<s;i++)
	ST   -Y,R17
;	s -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x10B:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0x10C
; 0000 03E4         {
; 0000 03E5                 rpwm=255;lpwm=255;
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
; 0000 03E6                 Enki = 1;
	SBI  0x15,2
; 0000 03E7                 Enka = 1;
	SBI  0x15,5
; 0000 03E8                 kaplus=1;kirplus=1;
	SBI  0x15,7
	SBI  0x15,3
; 0000 03E9                 kamin=1;kirmin=1;
	SBI  0x15,6
	SBI  0x15,4
; 0000 03EA                 delay_ms(10);
	CALL SUBOPT_0x2E
; 0000 03EB         }
	SUBI R17,-1
	RJMP _0x10B
_0x10C:
; 0000 03EC }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void rotkan(void)
; 0000 03EF {
_rotkan:
; 0000 03F0         kaplus=0;kamin=1;
	CBI  0x15,7
	SBI  0x15,6
; 0000 03F1         kirplus=1;kirmin=0;
	SBI  0x15,3
_0x2080010:
	CBI  0x15,4
; 0000 03F2 }
	RET
;
;void rotkir(void)
; 0000 03F5 {
_rotkir:
; 0000 03F6         kaplus=1;kamin=0;
	SBI  0x15,7
	CBI  0x15,6
; 0000 03F7         kirplus=0;kirmin=1;
_0x208000E:
	CBI  0x15,3
_0x208000F:
	SBI  0x15,4
; 0000 03F8 }
	RET
;
;void pemercepat(void)
; 0000 03FB {
_pemercepat:
; 0000 03FC         int b;
; 0000 03FD 
; 0000 03FE         #asm("sei")
	ST   -Y,R17
	ST   -Y,R16
;	b -> R16,R17
	sei
; 0000 03FF 
; 0000 0400         lpwm=0;
	CALL SUBOPT_0x2F
; 0000 0401         rpwm=0;
; 0000 0402 
; 0000 0403         maju();
	RCALL _maju
; 0000 0404 
; 0000 0405         for(b=0;b<255;b++)
	__GETWRN 16,17,0
_0x12A:
	__CPWRN 16,17,255
	BRGE _0x12B
; 0000 0406         {
; 0000 0407             delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0408 
; 0000 0409             lpwm++;
	LDI  R26,LOW(_lpwm)
	LDI  R27,HIGH(_lpwm)
	CALL SUBOPT_0x30
; 0000 040A             rpwm++;
	LDI  R26,LOW(_rpwm)
	LDI  R27,HIGH(_rpwm)
	CALL SUBOPT_0x30
; 0000 040B 
; 0000 040C             lcd_clear();
	CALL SUBOPT_0x8
; 0000 040D 
; 0000 040E             lcd_gotoxy(0,0);
; 0000 040F             sprintf(lcd," %d %d",lpwm,rpwm);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x31
; 0000 0410             lcd_puts(lcd);
	CALL _lcd_puts
; 0000 0411         }
	__ADDWRN 16,17,1
	RJMP _0x12A
_0x12B:
; 0000 0412         lpwm=0;
	CALL SUBOPT_0x2F
; 0000 0413         rpwm=0;
; 0000 0414 
; 0000 0415         #asm("cli")
	cli
; 0000 0416 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void pelambat(void)
; 0000 0419 {
_pelambat:
; 0000 041A         int b;
; 0000 041B 
; 0000 041C         #asm("sei")
	ST   -Y,R17
	ST   -Y,R16
;	b -> R16,R17
	sei
; 0000 041D 
; 0000 041E         lpwm=255;
	CALL SUBOPT_0x2D
; 0000 041F         rpwm=255;
	CALL SUBOPT_0x2C
; 0000 0420 
; 0000 0421         mundur();
	RCALL _mundur
; 0000 0422 
; 0000 0423         for(b=0;b<255;b++)
	__GETWRN 16,17,0
_0x12D:
	__CPWRN 16,17,255
	BRGE _0x12E
; 0000 0424         {
; 0000 0425             delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0426 
; 0000 0427             lpwm--;
	LDI  R26,LOW(_lpwm)
	LDI  R27,HIGH(_lpwm)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0428             rpwm--;
	LDI  R26,LOW(_rpwm)
	LDI  R27,HIGH(_rpwm)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0429 
; 0000 042A             lcd_clear();
	CALL SUBOPT_0x8
; 0000 042B 
; 0000 042C             lcd_gotoxy(0,0);
; 0000 042D             sprintf(lcd," %d %d",lpwm,rpwm);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x31
; 0000 042E             lcd_puts(lcd);
	CALL _lcd_puts
; 0000 042F         }
	__ADDWRN 16,17,1
	RJMP _0x12D
_0x12E:
; 0000 0430         lpwm=0;
	CALL SUBOPT_0x2F
; 0000 0431         rpwm=0;
; 0000 0432 
; 0000 0433         #asm("cli")
	cli
; 0000 0434 }
	RJMP _0x208000D
;
;void cek_sensor(void)
; 0000 0437 {
_cek_sensor:
; 0000 0438         int t;
; 0000 0439 
; 0000 043A         baca_sensor();
	ST   -Y,R17
	ST   -Y,R16
;	t -> R16,R17
	RCALL _baca_sensor
; 0000 043B         lcd_clear();
	CALL _lcd_clear
; 0000 043C         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 043D                 // wait 125ms
; 0000 043E         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 043F                 //0123456789abcdef
; 0000 0440         lcd_putsf(" Test:Sensor    ");
	__POINTW1FN _0x0,496
	CALL SUBOPT_0x5
; 0000 0441 
; 0000 0442         for (t=0; t<30000; t++) {displaySensorBit();}
	__GETWRN 16,17,0
_0x130:
	__CPWRN 16,17,30000
	BRGE _0x131
	RCALL _displaySensorBit
	__ADDWRN 16,17,1
	RJMP _0x130
_0x131:
; 0000 0443 }
	RJMP _0x208000D
;
;void tune_batas(void)
; 0000 0446 {
_tune_batas:
; 0000 0447         int k;
; 0000 0448 
; 0000 0449         ba7=7;
	CALL SUBOPT_0x32
;	k -> R16,R17
; 0000 044A         ba6=7;
; 0000 044B         ba5=7;
; 0000 044C         ba4=7;
; 0000 044D         ba3=7;
; 0000 044E         ba2=7;
; 0000 044F         ba1=7;
; 0000 0450         ba0=7;
; 0000 0451         bb7=200;
; 0000 0452         bb6=200;
; 0000 0453         bb5=200;
; 0000 0454         bb4=200;
; 0000 0455         bb3=200;
; 0000 0456         bb2=200;
; 0000 0457         bb1=200;
; 0000 0458         bb0=200;
; 0000 0459 
; 0000 045A         lcd_clear();
	CALL _lcd_clear
; 0000 045B 
; 0000 045C     for(;;)
_0x133:
; 0000 045D     {
; 0000 045E         k = 0;
	__GETWRN 16,17,0
; 0000 045F 
; 0000 0460         k = read_adc(0);
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x33
; 0000 0461         if  (k<bb0)   {bb0=k;}
	BRGE _0x135
	MOV  R30,R16
	LDI  R26,LOW(_bb0)
	LDI  R27,HIGH(_bb0)
	CALL __EEPROMWRB
; 0000 0462         if  (k>ba0)   {ba0=k;}
_0x135:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x136
	MOV  R30,R16
	LDI  R26,LOW(_ba0)
	LDI  R27,HIGH(_ba0)
	CALL __EEPROMWRB
; 0000 0463 
; 0000 0464         bt0=((bb0+ba0)/2);
_0x136:
	CALL SUBOPT_0x36
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x34
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL SUBOPT_0x38
; 0000 0465 
; 0000 0466         lcd_clear();
; 0000 0467         lcd_gotoxy(1,0);
; 0000 0468         lcd_putsf(" bb0  ba0  bt0");
	__POINTW1FN _0x0,513
	CALL SUBOPT_0x5
; 0000 0469         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 046A         sprintf(lcd," %d  %d  %d",bb0,ba0,bt0);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x39
	CALL SUBOPT_0x36
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x34
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3A
; 0000 046B         lcd_puts(lcd);
	CALL SUBOPT_0x3B
; 0000 046C         delay_ms(50);
; 0000 046D 
; 0000 046E         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x137
; 0000 046F         {
; 0000 0470             delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0471             goto sensor1;
	RJMP _0x138
; 0000 0472         }
; 0000 0473     }
_0x137:
	RJMP _0x133
; 0000 0474     sensor1:
_0x138:
; 0000 0475     for(;;)
_0x13A:
; 0000 0476     {
; 0000 0477         k = read_adc(1);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x3C
; 0000 0478         if  (k<bb1)   {bb1=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x13C
	MOV  R30,R16
	LDI  R26,LOW(_bb1)
	LDI  R27,HIGH(_bb1)
	CALL __EEPROMWRB
; 0000 0479         if  (k>ba1)   {ba1=k;}
_0x13C:
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x13D
	MOV  R30,R16
	LDI  R26,LOW(_ba1)
	LDI  R27,HIGH(_ba1)
	CALL __EEPROMWRB
; 0000 047A 
; 0000 047B         bt1=((bb1+ba1)/2);
_0x13D:
	CALL SUBOPT_0x3E
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL SUBOPT_0x38
; 0000 047C 
; 0000 047D         lcd_clear();
; 0000 047E         lcd_gotoxy(1,0);
; 0000 047F         lcd_putsf(" bb1  ba1  bt1");
	__POINTW1FN _0x0,540
	CALL SUBOPT_0x5
; 0000 0480         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 0481         sprintf(lcd," %d  %d  %d",bb1,ba1,bt1);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x25
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3A
; 0000 0482         lcd_puts(lcd);
	CALL SUBOPT_0x3B
; 0000 0483         delay_ms(50);
; 0000 0484 
; 0000 0485         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x13E
; 0000 0486         {
; 0000 0487             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0488             goto sensor2;
	RJMP _0x13F
; 0000 0489         }
; 0000 048A     }
_0x13E:
	RJMP _0x13A
; 0000 048B     sensor2:
_0x13F:
; 0000 048C     for(;;)
_0x141:
; 0000 048D     {
; 0000 048E         k = read_adc(2);
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x3F
; 0000 048F         if  (k<bb2)   {bb2=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x143
	MOV  R30,R16
	LDI  R26,LOW(_bb2)
	LDI  R27,HIGH(_bb2)
	CALL __EEPROMWRB
; 0000 0490         if  (k>ba2)   {ba2=k;}
_0x143:
	CALL SUBOPT_0x40
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x144
	MOV  R30,R16
	LDI  R26,LOW(_ba2)
	LDI  R27,HIGH(_ba2)
	CALL __EEPROMWRB
; 0000 0491 
; 0000 0492         bt2=((bb2+ba2)/2);
_0x144:
	CALL SUBOPT_0x41
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x40
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt2)
	LDI  R27,HIGH(_bt2)
	CALL SUBOPT_0x38
; 0000 0493 
; 0000 0494         lcd_clear();
; 0000 0495         lcd_gotoxy(1,0);
; 0000 0496         lcd_putsf(" bb2  ba2  bt2");
	__POINTW1FN _0x0,555
	CALL SUBOPT_0x5
; 0000 0497         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 0498         sprintf(lcd," %d  %d  %d",bb2,ba2,bt2);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x39
	CALL SUBOPT_0x41
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x40
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3A
; 0000 0499         lcd_puts(lcd);
	CALL SUBOPT_0x42
; 0000 049A         delay_ms(10);
; 0000 049B 
; 0000 049C         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x145
; 0000 049D         {
; 0000 049E             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 049F             goto sensor3;
	RJMP _0x146
; 0000 04A0         }
; 0000 04A1     }
_0x145:
	RJMP _0x141
; 0000 04A2     sensor3:
_0x146:
; 0000 04A3     for(;;)
_0x148:
; 0000 04A4     {
; 0000 04A5         k = read_adc(3);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x43
; 0000 04A6         if  (k<bb3)   {bb3=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x14A
	MOV  R30,R16
	LDI  R26,LOW(_bb3)
	LDI  R27,HIGH(_bb3)
	CALL __EEPROMWRB
; 0000 04A7         if  (k>ba3)   {ba3=k;}
_0x14A:
	CALL SUBOPT_0x44
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x14B
	MOV  R30,R16
	LDI  R26,LOW(_ba3)
	LDI  R27,HIGH(_ba3)
	CALL __EEPROMWRB
; 0000 04A8 
; 0000 04A9         bt3=((bb3+ba3)/2);
_0x14B:
	CALL SUBOPT_0x45
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x44
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt3)
	LDI  R27,HIGH(_bt3)
	CALL SUBOPT_0x38
; 0000 04AA 
; 0000 04AB         lcd_clear();
; 0000 04AC         lcd_gotoxy(1,0);
; 0000 04AD         lcd_putsf(" bb3  ba3  bt3");
	__POINTW1FN _0x0,570
	CALL SUBOPT_0x5
; 0000 04AE         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 04AF         sprintf(lcd," %d  %d  %d",bb3,ba3,bt3);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x39
	CALL SUBOPT_0x45
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x44
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3A
; 0000 04B0         lcd_puts(lcd);
	CALL SUBOPT_0x42
; 0000 04B1         delay_ms(10);
; 0000 04B2 
; 0000 04B3         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x14C
; 0000 04B4         {
; 0000 04B5             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 04B6             goto sensor4;
	RJMP _0x14D
; 0000 04B7         }
; 0000 04B8     }
_0x14C:
	RJMP _0x148
; 0000 04B9     sensor4:
_0x14D:
; 0000 04BA     for(;;)
_0x14F:
; 0000 04BB     {
; 0000 04BC         k = read_adc(4);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x46
; 0000 04BD         if  (k<bb4)   {bb4=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x151
	MOV  R30,R16
	LDI  R26,LOW(_bb4)
	LDI  R27,HIGH(_bb4)
	CALL __EEPROMWRB
; 0000 04BE         if  (k>ba4)   {ba4=k;}
_0x151:
	CALL SUBOPT_0x47
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x152
	MOV  R30,R16
	LDI  R26,LOW(_ba4)
	LDI  R27,HIGH(_ba4)
	CALL __EEPROMWRB
; 0000 04BF 
; 0000 04C0         bt4=((bb4+ba4)/2);
_0x152:
	CALL SUBOPT_0x48
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x47
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt4)
	LDI  R27,HIGH(_bt4)
	CALL SUBOPT_0x38
; 0000 04C1 
; 0000 04C2         lcd_clear();
; 0000 04C3         lcd_gotoxy(1,0);
; 0000 04C4         lcd_putsf(" bb4  ba4  bt4");
	__POINTW1FN _0x0,585
	CALL SUBOPT_0x5
; 0000 04C5         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 04C6         sprintf(lcd," %d  %d  %d",bb4,ba4,bt4);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x39
	CALL SUBOPT_0x48
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x47
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3A
; 0000 04C7         lcd_puts(lcd);
	CALL SUBOPT_0x42
; 0000 04C8         delay_ms(10);
; 0000 04C9 
; 0000 04CA         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x153
; 0000 04CB         {
; 0000 04CC             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 04CD             goto sensor5;
	RJMP _0x154
; 0000 04CE         }
; 0000 04CF     }
_0x153:
	RJMP _0x14F
; 0000 04D0     sensor5:
_0x154:
; 0000 04D1     for(;;)
_0x156:
; 0000 04D2     {
; 0000 04D3         k = read_adc(5);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x49
; 0000 04D4         if  (k<bb5)   {bb5=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x158
	MOV  R30,R16
	LDI  R26,LOW(_bb5)
	LDI  R27,HIGH(_bb5)
	CALL __EEPROMWRB
; 0000 04D5         if  (k>ba5)   {ba5=k;}
_0x158:
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x159
	MOV  R30,R16
	LDI  R26,LOW(_ba5)
	LDI  R27,HIGH(_ba5)
	CALL __EEPROMWRB
; 0000 04D6 
; 0000 04D7         bt5=((bb5+ba5)/2);
_0x159:
	CALL SUBOPT_0x4B
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt5)
	LDI  R27,HIGH(_bt5)
	CALL SUBOPT_0x38
; 0000 04D8 
; 0000 04D9         lcd_clear();
; 0000 04DA         lcd_gotoxy(1,0);
; 0000 04DB         lcd_putsf(" bb5  ba5  bt5");
	__POINTW1FN _0x0,600
	CALL SUBOPT_0x5
; 0000 04DC         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 04DD         sprintf(lcd," %d  %d  %d",bb5,ba5,bt5);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x39
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x29
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3A
; 0000 04DE         lcd_puts(lcd);
	CALL SUBOPT_0x42
; 0000 04DF         delay_ms(10);
; 0000 04E0 
; 0000 04E1         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x15A
; 0000 04E2         {
; 0000 04E3             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 04E4             goto sensor6;
	RJMP _0x15B
; 0000 04E5         }
; 0000 04E6     }
_0x15A:
	RJMP _0x156
; 0000 04E7     sensor6:
_0x15B:
; 0000 04E8     for(;;)
_0x15D:
; 0000 04E9     {
; 0000 04EA         k = read_adc(06);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x4C
; 0000 04EB         if  (k<bb6)   {bb6=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x15F
	MOV  R30,R16
	LDI  R26,LOW(_bb6)
	LDI  R27,HIGH(_bb6)
	CALL __EEPROMWRB
; 0000 04EC         if  (k>ba6)   {ba6=k;}
_0x15F:
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x160
	MOV  R30,R16
	LDI  R26,LOW(_ba6)
	LDI  R27,HIGH(_ba6)
	CALL __EEPROMWRB
; 0000 04ED 
; 0000 04EE         bt6=((bb6+ba6)/2);
_0x160:
	CALL SUBOPT_0x4E
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt6)
	LDI  R27,HIGH(_bt6)
	CALL SUBOPT_0x38
; 0000 04EF 
; 0000 04F0         lcd_clear();
; 0000 04F1         lcd_gotoxy(1,0);
; 0000 04F2         lcd_putsf(" bb6  ba6  bt6");
	__POINTW1FN _0x0,615
	CALL SUBOPT_0x5
; 0000 04F3         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 04F4         sprintf(lcd," %d  %d  %d",bb6,ba6,bt6);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x39
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3A
; 0000 04F5         lcd_puts(lcd);
	CALL SUBOPT_0x42
; 0000 04F6         delay_ms(10);
; 0000 04F7 
; 0000 04F8         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x161
; 0000 04F9         {
; 0000 04FA             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 04FB             goto sensor7;
	RJMP _0x162
; 0000 04FC         }
; 0000 04FD     }
_0x161:
	RJMP _0x15D
; 0000 04FE     sensor7:
_0x162:
; 0000 04FF     for(;;)
_0x164:
; 0000 0500     {
; 0000 0501         k = read_adc(7);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x4F
; 0000 0502         if  (k<bb7)   {bb7=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x166
	MOV  R30,R16
	LDI  R26,LOW(_bb7)
	LDI  R27,HIGH(_bb7)
	CALL __EEPROMWRB
; 0000 0503         if  (k>ba7)   {ba7=k;}
_0x166:
	CALL SUBOPT_0x50
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x167
	MOV  R30,R16
	LDI  R26,LOW(_ba7)
	LDI  R27,HIGH(_ba7)
	CALL __EEPROMWRB
; 0000 0504 
; 0000 0505         bt7=((bb7+ba7)/2);
_0x167:
	CALL SUBOPT_0x51
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x50
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt7)
	LDI  R27,HIGH(_bt7)
	CALL SUBOPT_0x38
; 0000 0506 
; 0000 0507         lcd_clear();
; 0000 0508         lcd_gotoxy(1,0);
; 0000 0509         lcd_putsf(" bb7  ba7  bt7");
	__POINTW1FN _0x0,630
	CALL SUBOPT_0x5
; 0000 050A         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 050B         sprintf(lcd," %d  %d  %d",bb7,ba7,bt7);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x39
	CALL SUBOPT_0x51
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x50
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3A
; 0000 050C         lcd_puts(lcd);
	CALL SUBOPT_0x42
; 0000 050D         delay_ms(10);
; 0000 050E 
; 0000 050F         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x168
; 0000 0510         {
; 0000 0511             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0512             goto selesai;
	RJMP _0x169
; 0000 0513         }
; 0000 0514     }
_0x168:
	RJMP _0x164
; 0000 0515     selesai:
_0x169:
; 0000 0516     lcd_clear();
	RJMP _0x208000C
; 0000 0517 }
;
;void auto_scan(void)
; 0000 051A {
_auto_scan:
; 0000 051B         int k;
; 0000 051C 
; 0000 051D         ba7=7;
	CALL SUBOPT_0x32
;	k -> R16,R17
; 0000 051E         ba6=7;
; 0000 051F         ba5=7;
; 0000 0520         ba4=7;
; 0000 0521         ba3=7;
; 0000 0522         ba2=7;
; 0000 0523         ba1=7;
; 0000 0524         ba0=7;
; 0000 0525         bb7=200;
; 0000 0526         bb6=200;
; 0000 0527         bb5=200;
; 0000 0528         bb4=200;
; 0000 0529         bb3=200;
; 0000 052A         bb2=200;
; 0000 052B         bb1=200;
; 0000 052C         bb0=200;
; 0000 052D 
; 0000 052E         for(;;)
_0x16B:
; 0000 052F         {
; 0000 0530                 k = 0;
	__GETWRN 16,17,0
; 0000 0531 
; 0000 0532                 k = read_adc(0);
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x33
; 0000 0533                 if  (k<bb0)   {bb0=k;}
	BRGE _0x16D
	MOV  R30,R16
	LDI  R26,LOW(_bb0)
	LDI  R27,HIGH(_bb0)
	CALL __EEPROMWRB
; 0000 0534                 if  (k>ba0)   {ba0=k;}
_0x16D:
	CALL SUBOPT_0x34
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x16E
	MOV  R30,R16
	LDI  R26,LOW(_ba0)
	LDI  R27,HIGH(_ba0)
	CALL __EEPROMWRB
; 0000 0535 
; 0000 0536                 bt0=((bb0+ba0)/2);
_0x16E:
	CALL SUBOPT_0x36
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x34
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL __EEPROMWRB
; 0000 0537 
; 0000 0538                 k = read_adc(1);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x3C
; 0000 0539                 if  (k<bb1)   {bb1=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x16F
	MOV  R30,R16
	LDI  R26,LOW(_bb1)
	LDI  R27,HIGH(_bb1)
	CALL __EEPROMWRB
; 0000 053A                 if  (k>ba1)   {ba1=k;}
_0x16F:
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x170
	MOV  R30,R16
	LDI  R26,LOW(_ba1)
	LDI  R27,HIGH(_ba1)
	CALL __EEPROMWRB
; 0000 053B 
; 0000 053C                 bt1=((bb1+ba1)/2);
_0x170:
	CALL SUBOPT_0x3E
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x3D
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL __EEPROMWRB
; 0000 053D 
; 0000 053E                 k = read_adc(2);
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x3F
; 0000 053F                 if  (k<bb2)   {bb2=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x171
	MOV  R30,R16
	LDI  R26,LOW(_bb2)
	LDI  R27,HIGH(_bb2)
	CALL __EEPROMWRB
; 0000 0540                 if  (k>ba2)   {ba2=k;}
_0x171:
	CALL SUBOPT_0x40
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x172
	MOV  R30,R16
	LDI  R26,LOW(_ba2)
	LDI  R27,HIGH(_ba2)
	CALL __EEPROMWRB
; 0000 0541 
; 0000 0542                 bt2=((bb2+ba2)/2);
_0x172:
	CALL SUBOPT_0x41
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x40
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt2)
	LDI  R27,HIGH(_bt2)
	CALL __EEPROMWRB
; 0000 0543 
; 0000 0544                 k = read_adc(3);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x43
; 0000 0545                 if  (k<bb3)   {bb3=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x173
	MOV  R30,R16
	LDI  R26,LOW(_bb3)
	LDI  R27,HIGH(_bb3)
	CALL __EEPROMWRB
; 0000 0546                 if  (k>ba3)   {ba3=k;}
_0x173:
	CALL SUBOPT_0x44
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x174
	MOV  R30,R16
	LDI  R26,LOW(_ba3)
	LDI  R27,HIGH(_ba3)
	CALL __EEPROMWRB
; 0000 0547 
; 0000 0548                 bt3=((bb3+ba3)/2);
_0x174:
	CALL SUBOPT_0x45
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x44
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt3)
	LDI  R27,HIGH(_bt3)
	CALL __EEPROMWRB
; 0000 0549 
; 0000 054A                 k = read_adc(4);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x46
; 0000 054B                 if  (k<bb4)   {bb4=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x175
	MOV  R30,R16
	LDI  R26,LOW(_bb4)
	LDI  R27,HIGH(_bb4)
	CALL __EEPROMWRB
; 0000 054C                 if  (k>ba4)   {ba4=k;}
_0x175:
	CALL SUBOPT_0x47
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x176
	MOV  R30,R16
	LDI  R26,LOW(_ba4)
	LDI  R27,HIGH(_ba4)
	CALL __EEPROMWRB
; 0000 054D 
; 0000 054E                 bt4=((bb4+ba4)/2);
_0x176:
	CALL SUBOPT_0x48
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x47
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt4)
	LDI  R27,HIGH(_bt4)
	CALL __EEPROMWRB
; 0000 054F 
; 0000 0550                 k = read_adc(5);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x49
; 0000 0551                 if  (k<bb5)   {bb5=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x177
	MOV  R30,R16
	LDI  R26,LOW(_bb5)
	LDI  R27,HIGH(_bb5)
	CALL __EEPROMWRB
; 0000 0552                 if  (k>ba5)   {ba5=k;}
_0x177:
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x178
	MOV  R30,R16
	LDI  R26,LOW(_ba5)
	LDI  R27,HIGH(_ba5)
	CALL __EEPROMWRB
; 0000 0553 
; 0000 0554                 bt5=((bb5+ba5)/2);
_0x178:
	CALL SUBOPT_0x4B
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt5)
	LDI  R27,HIGH(_bt5)
	CALL __EEPROMWRB
; 0000 0555 
; 0000 0556                 k = read_adc(6);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x4C
; 0000 0557                 if  (k<bb6)   {bb6=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x179
	MOV  R30,R16
	LDI  R26,LOW(_bb6)
	LDI  R27,HIGH(_bb6)
	CALL __EEPROMWRB
; 0000 0558                 if  (k>ba6)   {ba6=k;}
_0x179:
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x17A
	MOV  R30,R16
	LDI  R26,LOW(_ba6)
	LDI  R27,HIGH(_ba6)
	CALL __EEPROMWRB
; 0000 0559 
; 0000 055A                 bt6=((bb6+ba6)/2);
_0x17A:
	CALL SUBOPT_0x4E
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt6)
	LDI  R27,HIGH(_bt6)
	CALL __EEPROMWRB
; 0000 055B 
; 0000 055C                 k = read_adc(7);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x4F
; 0000 055D                 if  (k<bb7)   {bb7=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x17B
	MOV  R30,R16
	LDI  R26,LOW(_bb7)
	LDI  R27,HIGH(_bb7)
	CALL __EEPROMWRB
; 0000 055E                 if  (k>ba7)   {ba7=k;}
_0x17B:
	CALL SUBOPT_0x50
	CALL SUBOPT_0x35
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x17C
	MOV  R30,R16
	LDI  R26,LOW(_ba7)
	LDI  R27,HIGH(_ba7)
	CALL __EEPROMWRB
; 0000 055F 
; 0000 0560                 bt7=((bb7+ba7)/2);
_0x17C:
	CALL SUBOPT_0x51
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x50
	CALL SUBOPT_0x37
	LDI  R26,LOW(_bt7)
	LDI  R27,HIGH(_bt7)
	CALL SUBOPT_0x38
; 0000 0561 
; 0000 0562                 lcd_clear();
; 0000 0563                 lcd_gotoxy(1,0);
; 0000 0564                 sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
	CALL SUBOPT_0x19
	__POINTW1FN _0x0,645
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x29
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x25
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1B
	LDI  R24,32
	CALL _sprintf
	ADIW R28,36
; 0000 0565                 lcd_puts(lcd);
	CALL SUBOPT_0x19
	CALL _lcd_puts
; 0000 0566                 delay_ms(120);
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x52
; 0000 0567 
; 0000 0568                 if (!sw_ok)
	SBIS 0x10,5
; 0000 0569                 {
; 0000 056A                         goto selesai_auto_scan;
	RJMP _0x17E
; 0000 056B                 }
; 0000 056C         }
	RJMP _0x16B
; 0000 056D 
; 0000 056E     selesai_auto_scan:
_0x17E:
; 0000 056F     lcd_clear();
_0x208000C:
	CALL _lcd_clear
; 0000 0570 }
_0x208000D:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void scanBlackLine(void)
; 0000 0573 {
_scanBlackLine:
; 0000 0574         switch(sensor)
	MOV  R30,R6
	LDI  R31,0
; 0000 0575         {
; 0000 0576                 case 0b11111110:        // ujung kiri
	CPI  R30,LOW(0xFE)
	LDI  R26,HIGH(0xFE)
	CPC  R31,R26
	BRNE _0x182
; 0000 0577                 PV = -7;
	LDI  R30,LOW(65529)
	LDI  R31,HIGH(65529)
	CALL SUBOPT_0x53
; 0000 0578                 maju();
	RJMP _0x3B4
; 0000 0579                 break;
; 0000 057A 
; 0000 057B                 case 0b11111000:
_0x182:
	CPI  R30,LOW(0xF8)
	LDI  R26,HIGH(0xF8)
	CPC  R31,R26
	BREQ _0x184
; 0000 057C                 case 0b11111100:
	CPI  R30,LOW(0xFC)
	LDI  R26,HIGH(0xFC)
	CPC  R31,R26
	BRNE _0x185
_0x184:
; 0000 057D                 PV = -6;
	LDI  R30,LOW(65530)
	LDI  R31,HIGH(65530)
	CALL SUBOPT_0x53
; 0000 057E                 maju();
	RJMP _0x3B4
; 0000 057F                 break;
; 0000 0580 
; 0000 0581                 case 0b11111101:
_0x185:
	CPI  R30,LOW(0xFD)
	LDI  R26,HIGH(0xFD)
	CPC  R31,R26
	BRNE _0x186
; 0000 0582                 PV = -5;
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	CALL SUBOPT_0x53
; 0000 0583                 maju();
	RJMP _0x3B4
; 0000 0584                 break;
; 0000 0585 
; 0000 0586                 case 0b11110001:
_0x186:
	CPI  R30,LOW(0xF1)
	LDI  R26,HIGH(0xF1)
	CPC  R31,R26
	BREQ _0x188
; 0000 0587                 case 0b11111001:
	CPI  R30,LOW(0xF9)
	LDI  R26,HIGH(0xF9)
	CPC  R31,R26
	BRNE _0x189
_0x188:
; 0000 0588                 PV = -4;
	LDI  R30,LOW(65532)
	LDI  R31,HIGH(65532)
	CALL SUBOPT_0x53
; 0000 0589                 maju();
	RJMP _0x3B4
; 0000 058A                 break;
; 0000 058B 
; 0000 058C                 case 0b11111011:
_0x189:
	CPI  R30,LOW(0xFB)
	LDI  R26,HIGH(0xFB)
	CPC  R31,R26
	BRNE _0x18A
; 0000 058D                 PV = -3;
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	CALL SUBOPT_0x53
; 0000 058E                 maju();
	RJMP _0x3B4
; 0000 058F                 break;
; 0000 0590 
; 0000 0591                 case 0b11100011:
_0x18A:
	CPI  R30,LOW(0xE3)
	LDI  R26,HIGH(0xE3)
	CPC  R31,R26
	BREQ _0x18C
; 0000 0592                 case 0b11110011:
	CPI  R30,LOW(0xF3)
	LDI  R26,HIGH(0xF3)
	CPC  R31,R26
	BRNE _0x18D
_0x18C:
; 0000 0593                 PV = -2;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CALL SUBOPT_0x53
; 0000 0594                 maju();
	RJMP _0x3B4
; 0000 0595                 break;
; 0000 0596 
; 0000 0597                 case 0b11110111:
_0x18D:
	CPI  R30,LOW(0xF7)
	LDI  R26,HIGH(0xF7)
	CPC  R31,R26
	BRNE _0x18E
; 0000 0598                 PV = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL SUBOPT_0x53
; 0000 0599                 maju();
	RJMP _0x3B4
; 0000 059A                 break;
; 0000 059B 
; 0000 059C                 //////////////
; 0000 059D                 case 0b11100111:        // tengah
_0x18E:
	CPI  R30,LOW(0xE7)
	LDI  R26,HIGH(0xE7)
	CPC  R31,R26
	BRNE _0x18F
; 0000 059E                 PV = 0;
	LDI  R30,LOW(0)
	STS  _PV,R30
	STS  _PV+1,R30
; 0000 059F                 maju();
	RJMP _0x3B4
; 0000 05A0                 break;
; 0000 05A1                 //////////////
; 0000 05A2 
; 0000 05A3                 case 0b11101111:
_0x18F:
	CPI  R30,LOW(0xEF)
	LDI  R26,HIGH(0xEF)
	CPC  R31,R26
	BRNE _0x190
; 0000 05A4                 PV = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x53
; 0000 05A5                 maju();
	RJMP _0x3B4
; 0000 05A6                 break;
; 0000 05A7 
; 0000 05A8                 case 0b11000111:
_0x190:
	CPI  R30,LOW(0xC7)
	LDI  R26,HIGH(0xC7)
	CPC  R31,R26
	BREQ _0x192
; 0000 05A9                 case 0b11001111:
	CPI  R30,LOW(0xCF)
	LDI  R26,HIGH(0xCF)
	CPC  R31,R26
	BRNE _0x193
_0x192:
; 0000 05AA                 PV = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x53
; 0000 05AB                 maju();
	RJMP _0x3B4
; 0000 05AC                 break;
; 0000 05AD 
; 0000 05AE                 case 0b11011111:
_0x193:
	CPI  R30,LOW(0xDF)
	LDI  R26,HIGH(0xDF)
	CPC  R31,R26
	BRNE _0x194
; 0000 05AF                 PV = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x53
; 0000 05B0                 maju();
	RJMP _0x3B4
; 0000 05B1                 break;
; 0000 05B2 
; 0000 05B3                 case 0b10001111:
_0x194:
	CPI  R30,LOW(0x8F)
	LDI  R26,HIGH(0x8F)
	CPC  R31,R26
	BREQ _0x196
; 0000 05B4                 case 0b10011111:
	CPI  R30,LOW(0x9F)
	LDI  R26,HIGH(0x9F)
	CPC  R31,R26
	BRNE _0x197
_0x196:
; 0000 05B5                 PV = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x53
; 0000 05B6                 maju();
	RJMP _0x3B4
; 0000 05B7                 break;
; 0000 05B8 
; 0000 05B9                 case 0b10111111:
_0x197:
	CPI  R30,LOW(0xBF)
	LDI  R26,HIGH(0xBF)
	CPC  R31,R26
	BRNE _0x198
; 0000 05BA                 PV = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x53
; 0000 05BB                 maju();
	RJMP _0x3B4
; 0000 05BC                 break;
; 0000 05BD 
; 0000 05BE                 case 0b00011111:
_0x198:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BREQ _0x19A
; 0000 05BF                 case 0b00111111:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0x19B
_0x19A:
; 0000 05C0                 PV = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x53
; 0000 05C1                 maju();
	RJMP _0x3B4
; 0000 05C2                 break;
; 0000 05C3 
; 0000 05C4                 case 0b01111111:        // ujung kanan
_0x19B:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x19C
; 0000 05C5                 PV = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x53
; 0000 05C6                 maju();
	RJMP _0x3B4
; 0000 05C7                 break;
; 0000 05C8 
; 0000 05C9                 case 0b11111111:        // loss
_0x19C:
	CPI  R30,LOW(0xFF)
	LDI  R26,HIGH(0xFF)
	CPC  R31,R26
	BRNE _0x19D
; 0000 05CA                 if(PV<0)
	LDS  R26,_PV+1
	TST  R26
	BRPL _0x19E
; 0000 05CB                 {
; 0000 05CC                         lpwm = MINPWM;
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
; 0000 05CD                         rpwm = MINPWM;
; 0000 05CE                         bkir();
	RCALL _bkir
; 0000 05CF                         goto exit;
	RJMP _0x19F
; 0000 05D0                 }
; 0000 05D1                 else if(PV>0)
_0x19E:
	CALL SUBOPT_0x56
	CALL __CPW02
	BRGE _0x1A1
; 0000 05D2                 {
; 0000 05D3                         lpwm = MINPWM;
	CALL SUBOPT_0x54
	CALL SUBOPT_0x55
; 0000 05D4                         rpwm = MINPWM;
; 0000 05D5                         bkan();
	RCALL _bkan
; 0000 05D6                         goto exit;
	RJMP _0x19F
; 0000 05D7                 }
; 0000 05D8                 break;
_0x1A1:
	RJMP _0x181
; 0000 05D9 
; 0000 05DA                 //case 0b11000000:
; 0000 05DB                 case 0b11100000:
_0x19D:
	CPI  R30,LOW(0xE0)
	LDI  R26,HIGH(0xE0)
	CPC  R31,R26
	BREQ _0x1A3
; 0000 05DC                 case 0b11110000:
	CPI  R30,LOW(0xF0)
	LDI  R26,HIGH(0xF0)
	CPC  R31,R26
	BRNE _0x1A4
_0x1A3:
; 0000 05DD                 PV = -15;
	LDI  R30,LOW(65521)
	LDI  R31,HIGH(65521)
	CALL SUBOPT_0x53
; 0000 05DE                 bkir();
	RCALL _bkir
; 0000 05DF                 break;
	RJMP _0x181
; 0000 05E0 
; 0000 05E1                 //case 0b00000011:
; 0000 05E2                 case 0b00000111:
_0x1A4:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BREQ _0x1A6
; 0000 05E3                 case 0b00001111:
	CPI  R30,LOW(0xF)
	LDI  R26,HIGH(0xF)
	CPC  R31,R26
	BRNE _0x1A7
_0x1A6:
; 0000 05E4                 PV = 15;
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x53
; 0000 05E5                 bkan();
	RCALL _bkan
; 0000 05E6                 break;
	RJMP _0x181
; 0000 05E7 
; 0000 05E8                 case 0b10000001:
_0x1A7:
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BREQ _0x1A9
; 0000 05E9                 case 0b11000011:
	CPI  R30,LOW(0xC3)
	LDI  R26,HIGH(0xC3)
	CPC  R31,R26
	BRNE _0x181
_0x1A9:
; 0000 05EA                 maju();
_0x3B4:
	RCALL _maju
; 0000 05EB                 break;
; 0000 05EC         }
_0x181:
; 0000 05ED 
; 0000 05EE         error = SP - PV;
	LDS  R30,_SP
	LDI  R31,0
	CALL SUBOPT_0x56
	SUB  R30,R26
	SBC  R31,R27
	STS  _error,R30
	STS  _error+1,R31
; 0000 05EF         P = (var_Kp * error) / 2;
	CALL SUBOPT_0x57
	LDS  R26,_var_Kp
	LDS  R27,_var_Kp+1
	CALL SUBOPT_0x58
	STS  _P,R30
	STS  _P+1,R31
; 0000 05F0 
; 0000 05F1         rate = error - last_error;
	LDS  R26,_last_error
	LDS  R27,_last_error+1
	CALL SUBOPT_0x57
	SUB  R30,R26
	SBC  R31,R27
	STS  _rate,R30
	STS  _rate+1,R31
; 0000 05F2         I    = (rate * var_Ki) / 2;
	LDS  R30,_var_Ki
	LDS  R31,_var_Ki+1
	LDS  R26,_rate
	LDS  R27,_rate+1
	CALL SUBOPT_0x58
	STS  _I,R30
	STS  _I+1,R31
; 0000 05F3 
; 0000 05F4         D = ((error / 11) * (MINPWM / 20) * var_Kd);
	LDS  R26,_error
	LDS  R27,_error+1
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL __DIVW21
	MOVW R22,R30
	CALL SUBOPT_0x59
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21
	MOVW R26,R22
	CALL __MULW12
	LDS  R26,_var_Kd
	LDS  R27,_var_Kd+1
	CALL __MULW12
	STS  _D,R30
	STS  _D+1,R31
; 0000 05F5 
; 0000 05F6         last_error = error;
	CALL SUBOPT_0x57
	STS  _last_error,R30
	STS  _last_error+1,R31
; 0000 05F7 
; 0000 05F8         MV = P + I + D;
	LDS  R30,_I
	LDS  R31,_I+1
	LDS  R26,_P
	LDS  R27,_P+1
	ADD  R30,R26
	ADC  R31,R27
	LDS  R26,_D
	LDS  R27,_D+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _MV,R30
	STS  _MV+1,R31
; 0000 05F9 
; 0000 05FA         intervalPWM = (MAXPWM - MINPWM) / 8;
	CALL SUBOPT_0x59
	LDS  R30,_MAXPWM
	LDS  R31,_MAXPWM+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	CALL SUBOPT_0x5A
; 0000 05FB 
; 0000 05FC         //rpwm = MINPWM + (intervalPWM * (0 + MV));
; 0000 05FD         //lpwm = MINPWM + (intervalPWM * (0 - MV));
; 0000 05FE 
; 0000 05FF         rpwm = 40 + MINPWM + MV;
	CALL SUBOPT_0x54
	ADIW R30,40
	LDS  R26,_MV
	LDS  R27,_MV+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x5B
; 0000 0600         lpwm = (MINPWM * 0.72) - MV;
	CALL SUBOPT_0x54
	CALL __CWD1
	CALL __CDF1
	__GETD2N 0x3F3851EC
	CALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	LDS  R30,_MV
	LDS  R31,_MV+1
	CALL __CWD1
	CALL __CDF1
	CALL __SWAPD12
	CALL __SUBF12
	LDI  R26,LOW(_lpwm)
	LDI  R27,HIGH(_lpwm)
	CALL __CFD1
	ST   X+,R30
	ST   X,R31
; 0000 0601         //lpwm = (MINPWM - MV) * 0.72;
; 0000 0602         if(lpwm>255)
	LDS  R26,_lpwm
	LDS  R27,_lpwm+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1AB
; 0000 0603         {
; 0000 0604                 rpwm = rpwm - (lpwm - 255);
	CALL SUBOPT_0x0
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	LDS  R26,_rpwm
	LDS  R27,_rpwm+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _rpwm,R26
	STS  _rpwm+1,R27
; 0000 0605                 lpwm = 255;
	CALL SUBOPT_0x2D
; 0000 0606         }
; 0000 0607 
; 0000 0608         if(rpwm>255)
_0x1AB:
	LDS  R26,_rpwm
	LDS  R27,_rpwm+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1AC
; 0000 0609         {
; 0000 060A                 lpwm = lpwm - (rpwm - 255);
	CALL SUBOPT_0x2
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	LDS  R26,_lpwm
	LDS  R27,_lpwm+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _lpwm,R26
	STS  _lpwm+1,R27
; 0000 060B                 rpwm = 255;
	CALL SUBOPT_0x2C
; 0000 060C         }
; 0000 060D 
; 0000 060E         if(lpwm < 0)
_0x1AC:
	LDS  R26,_lpwm+1
	TST  R26
	BRPL _0x1AD
; 0000 060F         {
; 0000 0610                 stop(3);
	CALL SUBOPT_0x5C
; 0000 0611                 rotkir();
	RCALL _rotkir
; 0000 0612                 lpwm = -1 * lpwm;
	CALL SUBOPT_0x0
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	CALL SUBOPT_0x5D
; 0000 0613         }
; 0000 0614 
; 0000 0615         if(rpwm < 0)
_0x1AD:
	LDS  R26,_rpwm+1
	TST  R26
	BRPL _0x1AE
; 0000 0616         {
; 0000 0617                 stop(3);
	CALL SUBOPT_0x5C
; 0000 0618                 rotkan();
	RCALL _rotkan
; 0000 0619                 rpwm = -1 * rpwm;
	CALL SUBOPT_0x2
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	CALL SUBOPT_0x5B
; 0000 061A         }
; 0000 061B 
; 0000 061C         if(lpwm==0)
_0x1AE:
	CALL SUBOPT_0x0
	SBIW R30,0
	BRNE _0x1AF
; 0000 061D         {
; 0000 061E                 if(PV<0)
	LDS  R26,_PV+1
	TST  R26
	BRPL _0x1B0
; 0000 061F                 {
; 0000 0620                         lpwm = MAXPWM/2;
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5D
; 0000 0621                         rpwm = MAXPWM/2;
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5B
; 0000 0622                         bkir();
	RCALL _bkir
; 0000 0623                         goto exit;
	RJMP _0x19F
; 0000 0624                 }
; 0000 0625                 else if(PV>0)
_0x1B0:
	CALL SUBOPT_0x56
	CALL __CPW02
	BRGE _0x1B2
; 0000 0626                 {
; 0000 0627                         lpwm = MAXPWM/2;
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5D
; 0000 0628                         rpwm = MAXPWM/2;
	CALL SUBOPT_0x5E
	CALL SUBOPT_0x5B
; 0000 0629                         bkan();
	RCALL _bkan
; 0000 062A                         goto exit;
; 0000 062B                 }
; 0000 062C         }
_0x1B2:
; 0000 062D 
; 0000 062E         if(rpwm==0)
_0x1AF:
; 0000 062F         {
; 0000 0630         }
; 0000 0631 
; 0000 0632         exit:
_0x19F:
; 0000 0633 
; 0000 0634         //debug pwm
; 0000 0635         sprintf(lcd,"%d   %d",lpwm, rpwm);
	CALL SUBOPT_0x19
	__POINTW1FN _0x0,669
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x0
	CALL __CWD1
	CALL __PUTPARD1
	CALL SUBOPT_0x2
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 0636         lcd_gotoxy(0, 0);
	CALL SUBOPT_0x4
; 0000 0637         lcd_putsf("                ");
	__POINTW1FN _0x0,677
	CALL SUBOPT_0x5
; 0000 0638         lcd_gotoxy(0, 0);
	CALL SUBOPT_0x4
; 0000 0639         lcd_puts(lcd);
	CALL SUBOPT_0x19
	CALL _lcd_puts
; 0000 063A         delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x52
; 0000 063B 
; 0000 063C         /*
; 0000 063D         //debug MV
; 0000 063E         sprintf(lcd_buffer,"MV:%d",MV);
; 0000 063F         lcd_gotoxy(0,0);
; 0000 0640         lcd_putsf("                ");
; 0000 0641         lcd_gotoxy(0,0);
; 0000 0642         lcd_puts(lcd_buffer);
; 0000 0643         delay_ms(10);
; 0000 0644         */
; 0000 0645 }
	RET
;
;void scanSudut(void)
; 0000 0648 {
; 0000 0649         if((!sKa)&&(sensor==255))
; 0000 064A         {
; 0000 064B                 indikatorSudut();
; 0000 064C                 baca_sensor();
; 0000 064D                 //while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
; 0000 064E                 while(sensor==255)
; 0000 064F                 {
; 0000 0650                         baca_sensor();
; 0000 0651                         lpwm=MINPWM;
; 0000 0652                         rpwm=MINPWM;
; 0000 0653                         rotkan();
; 0000 0654                 }
; 0000 0655                 stop(5);
; 0000 0656                 goto exit_sudut;
; 0000 0657         }
; 0000 0658 
; 0000 0659         if((!sKi)&&(sensor==255))
; 0000 065A         {
; 0000 065B                 indikatorSudut();
; 0000 065C                 baca_sensor();
; 0000 065D                 //while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
; 0000 065E                 while(sensor==255)
; 0000 065F                 {
; 0000 0660                         baca_sensor();
; 0000 0661                         lpwm=MINPWM;
; 0000 0662                         rpwm=MINPWM;
; 0000 0663                         rotkir();
; 0000 0664                 }
; 0000 0665                 stop(5);
; 0000 0666                 goto exit_sudut;
; 0000 0667         }
; 0000 0668 
; 0000 0669         exit_sudut:
; 0000 066A 
; 0000 066B         maju();
; 0000 066C }
;
;// strategi track A penyisihan, warna : merah , hijau
;
;void cekPointStarta(void)
; 0000 0671 {
_cekPointStarta:
; 0000 0672         MINPWM = _MINPWM;
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x60
; 0000 0673         var_Kp = 17;
; 0000 0674         var_Ki = 0;
; 0000 0675         var_Kd = 11;
; 0000 0676 
; 0000 0677         maju();
	RCALL _maju
; 0000 0678         while(sKa)
_0x1C1:
	SBRS R3,0
	RJMP _0x1C3
; 0000 0679         {
; 0000 067A                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 067B                 scanBlackLine();
; 0000 067C         }
	RJMP _0x1C1
_0x1C3:
; 0000 067D         stop(10);
	CALL SUBOPT_0x62
; 0000 067E         baca_sensor();
	CALL _baca_sensor
; 0000 067F         while(sensor==255)
_0x1C4:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x1C6
; 0000 0680         {
; 0000 0681                 rotkan();
	CALL SUBOPT_0x63
; 0000 0682                 lpwm = MINPWM;
; 0000 0683                 rpwm = MINPWM + 15;
	ADIW R30,15
	CALL SUBOPT_0x64
; 0000 0684                 baca_sensor();
; 0000 0685         }
	RJMP _0x1C4
_0x1C6:
; 0000 0686         stop(10);
	CALL SUBOPT_0x62
; 0000 0687         for(;;)
_0x1C8:
; 0000 0688         {
; 0000 0689                 maju();
	CALL SUBOPT_0x65
; 0000 068A                 displaySensorBit();
; 0000 068B                 scanBlackLine();
; 0000 068C         }
	RJMP _0x1C8
; 0000 068D }
;
;void cekPoint1a(void)
; 0000 0690 {
_cekPoint1a:
; 0000 0691         //cek point 1
; 0000 0692         MINPWM = _MINPWM - 10;
	CALL SUBOPT_0x5F
	SBIW R30,10
	CALL SUBOPT_0x60
; 0000 0693         var_Kp = 17;
; 0000 0694         var_Ki = 0;
; 0000 0695         var_Kd = 11;
; 0000 0696 
; 0000 0697         // cari simpangan T
; 0000 0698         baca_sensor();
	CALL _baca_sensor
; 0000 0699         maju();
	RCALL _maju
; 0000 069A         while(sKi)
_0x1CA:
	SBRS R3,1
	RJMP _0x1CC
; 0000 069B         {
; 0000 069C                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 069D                 scanBlackLine();
; 0000 069E         }
	RJMP _0x1CA
_0x1CC:
; 0000 069F         stop(10);
	CALL SUBOPT_0x62
; 0000 06A0         indikatorSudut();
	CALL SUBOPT_0x66
; 0000 06A1 
; 0000 06A2         // lepas T, mundur
; 0000 06A3         baca_sensor();
; 0000 06A4         while(sKi)
_0x1CD:
	SBRS R3,1
	RJMP _0x1CF
; 0000 06A5         {
; 0000 06A6                 mundur();
	CALL SUBOPT_0x67
; 0000 06A7                 lpwm = MINPWM;
; 0000 06A8                 rpwm = MINPWM + 30;
; 0000 06A9                 baca_sensor();
; 0000 06AA         }
	RJMP _0x1CD
_0x1CF:
; 0000 06AB 
; 0000 06AC         // balik ke T putar kanan
; 0000 06AD         baca_sensor();
	CALL _baca_sensor
; 0000 06AE         while(sensor==255)
_0x1D0:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x1D2
; 0000 06AF         {
; 0000 06B0                 rotkir();
	CALL SUBOPT_0x68
; 0000 06B1                 lpwm = MINPWM;
; 0000 06B2                 rpwm = MINPWM + 30;
; 0000 06B3                 baca_sensor();
; 0000 06B4         }
	RJMP _0x1D0
_0x1D2:
; 0000 06B5         stop(10);
	CALL SUBOPT_0x62
; 0000 06B6 
; 0000 06B7         // maju menuju busur dan perempatan
; 0000 06B8         maju();
	CALL _maju
; 0000 06B9         while(sKi)
_0x1D3:
	SBRS R3,1
	RJMP _0x1D5
; 0000 06BA         {
; 0000 06BB                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 06BC                 scanBlackLine();
; 0000 06BD         }
	RJMP _0x1D3
_0x1D5:
; 0000 06BE         /*indikatorSudut();
; 0000 06BF         while(!sKi)
; 0000 06C0         {
; 0000 06C1                 displaySensorBit();
; 0000 06C2                 scanBlackLine();
; 0000 06C3         }
; 0000 06C4         while(sKi)
; 0000 06C5         {
; 0000 06C6                 displaySensorBit();
; 0000 06C7                 scanBlackLine();
; 0000 06C8         } */
; 0000 06C9         stop(10);
	CALL SUBOPT_0x62
; 0000 06CA         indikatorSudut();
	CALL SUBOPT_0x66
; 0000 06CB 
; 0000 06CC         // ketemu perempatan, putar kiri
; 0000 06CD         baca_sensor();
; 0000 06CE         while(sKi)      // lepas perempatan
_0x1D6:
	SBRS R3,1
	RJMP _0x1D8
; 0000 06CF         {
; 0000 06D0                 mundur();
	CALL SUBOPT_0x67
; 0000 06D1                 lpwm = MINPWM;
; 0000 06D2                 rpwm = MINPWM + 30;
; 0000 06D3                 baca_sensor();
; 0000 06D4         }
	RJMP _0x1D6
_0x1D8:
; 0000 06D5         baca_sensor();
	CALL _baca_sensor
; 0000 06D6         while(sensor<255)       // manuver kiri
_0x1D9:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x1DB
; 0000 06D7         {
; 0000 06D8                 rotkan();
	CALL SUBOPT_0x63
; 0000 06D9                 lpwm = MINPWM;
; 0000 06DA                 rpwm = MINPWM + 30;
	ADIW R30,30
	CALL SUBOPT_0x64
; 0000 06DB                 baca_sensor();
; 0000 06DC         }
	RJMP _0x1D9
_0x1DB:
; 0000 06DD         while(sensor==255)
_0x1DC:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x1DE
; 0000 06DE         {
; 0000 06DF                 rotkan();
	CALL SUBOPT_0x63
; 0000 06E0                 lpwm = MINPWM;
; 0000 06E1                 rpwm = MINPWM + 30;
	ADIW R30,30
	CALL SUBOPT_0x64
; 0000 06E2                 baca_sensor();
; 0000 06E3         }
	RJMP _0x1DC
_0x1DE:
; 0000 06E4         stop(10);
	RJMP _0x208000B
; 0000 06E5 
; 0000 06E6         maju();
; 0000 06E7 }
;
;void cekPoint2a(void)
; 0000 06EA {
_cekPoint2a:
; 0000 06EB         int tlpwm, trpwm;
; 0000 06EC 
; 0000 06ED         //cek point 2
; 0000 06EE         MINPWM = _MINPWM - 15;
	CALL SUBOPT_0x69
;	tlpwm -> R16,R17
;	trpwm -> R18,R19
; 0000 06EF         var_Kp = 17;
; 0000 06F0         var_Ki = 0;
; 0000 06F1         var_Kd = 8;
; 0000 06F2 
; 0000 06F3         // cari perempatan V
; 0000 06F4         maju();
; 0000 06F5         while(sKi)
_0x1DF:
	SBRS R3,1
	RJMP _0x1E1
; 0000 06F6         {
; 0000 06F7                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 06F8                 scanBlackLine();
; 0000 06F9         }
	RJMP _0x1DF
_0x1E1:
; 0000 06FA         indikatorSudut();
	CALL SUBOPT_0x6A
; 0000 06FB         tlpwm = lpwm;
; 0000 06FC         trpwm = rpwm;
; 0000 06FD         lpwm = MINPWM;
; 0000 06FE         rpwm = MINPWM + 30;
; 0000 06FF         rotkan();
	CALL _rotkan
; 0000 0700         delay_ms(50);
	CALL SUBOPT_0x6B
; 0000 0701         stop(5);
	CALL SUBOPT_0x6C
; 0000 0702         maju();
; 0000 0703         MINPWM = _MINPWM;
; 0000 0704         lpwm = tlpwm;
; 0000 0705         rpwm = trpwm;
; 0000 0706         for(;;)
_0x1E3:
; 0000 0707         {
; 0000 0708                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 0709                 scanBlackLine();
; 0000 070A         }
	RJMP _0x1E3
; 0000 070B }
;
;void cekPoint3a(void)
; 0000 070E {
_cekPoint3a:
; 0000 070F         char f;
; 0000 0710 
; 0000 0711         //cek point 3
; 0000 0712         MINPWM = _MINPWM - 13;
	CALL SUBOPT_0x6D
;	f -> R17
; 0000 0713         var_Kp = 11;
; 0000 0714         var_Ki = 0;
; 0000 0715         var_Kd = 7;
; 0000 0716 
; 0000 0717         // cari simpangan
; 0000 0718         maju();
; 0000 0719         while(sKi)
_0x1E5:
	SBRS R3,1
	RJMP _0x1E7
; 0000 071A         {
; 0000 071B                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 071C                 scanBlackLine();
; 0000 071D         }
	RJMP _0x1E5
_0x1E7:
; 0000 071E         indikatorSudut();
	CALL SUBOPT_0x6E
; 0000 071F 
; 0000 0720         // putar kanan
; 0000 0721         stop(10);
; 0000 0722         baca_sensor();
	CALL _baca_sensor
; 0000 0723         while(sKi)
_0x1E8:
	SBRS R3,1
	RJMP _0x1EA
; 0000 0724         {
; 0000 0725                 mundur();
	CALL SUBOPT_0x67
; 0000 0726                 lpwm = MINPWM;
; 0000 0727                 rpwm = MINPWM + 30;
; 0000 0728                 baca_sensor();
; 0000 0729         }
	RJMP _0x1E8
_0x1EA:
; 0000 072A         stop(10);
	CALL SUBOPT_0x62
; 0000 072B         baca_sensor();
	CALL _baca_sensor
; 0000 072C         while(s7)
_0x1EB:
	SBRS R2,7
	RJMP _0x1ED
; 0000 072D         {
; 0000 072E                 rotkir();
	CALL SUBOPT_0x68
; 0000 072F                 lpwm = MINPWM;
; 0000 0730                 rpwm = MINPWM + 30;
; 0000 0731                 baca_sensor();
; 0000 0732         }
	RJMP _0x1EB
_0x1ED:
; 0000 0733         baca_sensor();
	CALL _baca_sensor
; 0000 0734         while(!s7)
_0x1EE:
	SBRC R2,7
	RJMP _0x1F0
; 0000 0735         {
; 0000 0736                 rotkir();
	CALL SUBOPT_0x68
; 0000 0737                 lpwm = MINPWM;
; 0000 0738                 rpwm = MINPWM + 30;
; 0000 0739                 baca_sensor();
; 0000 073A         }
	RJMP _0x1EE
_0x1F0:
; 0000 073B         baca_sensor();
	CALL _baca_sensor
; 0000 073C         while(s3)
_0x1F1:
	SBRS R2,3
	RJMP _0x1F3
; 0000 073D         {
; 0000 073E                 rotkir();
	CALL SUBOPT_0x68
; 0000 073F                 lpwm = MINPWM;
; 0000 0740                 rpwm = MINPWM + 30;
; 0000 0741                 baca_sensor();
; 0000 0742         }
	RJMP _0x1F1
_0x1F3:
; 0000 0743 
; 0000 0744         // counting simpangan
; 0000 0745         stop(10);
	CALL SUBOPT_0x62
; 0000 0746         baca_sensor();
	CALL _baca_sensor
; 0000 0747         while(sKi)
_0x1F4:
	SBRS R3,1
	RJMP _0x1F6
; 0000 0748         {
; 0000 0749                 maju();
	CALL SUBOPT_0x65
; 0000 074A                 displaySensorBit();
; 0000 074B                 scanBlackLine();
; 0000 074C         }
	RJMP _0x1F4
_0x1F6:
; 0000 074D         indikatorSudut();
	RCALL _indikatorSudut
; 0000 074E         while(!sKi)
_0x1F7:
	SBRC R3,1
	RJMP _0x1F9
; 0000 074F         {
; 0000 0750                 maju();
	CALL SUBOPT_0x65
; 0000 0751                 displaySensorBit();
; 0000 0752                 scanBlackLine();
; 0000 0753         }
	RJMP _0x1F7
_0x1F9:
; 0000 0754         while(sKi)
_0x1FA:
	SBRS R3,1
	RJMP _0x1FC
; 0000 0755         {
; 0000 0756                 maju();
	CALL SUBOPT_0x65
; 0000 0757                 displaySensorBit();
; 0000 0758                 scanBlackLine();
; 0000 0759         }
	RJMP _0x1FA
_0x1FC:
; 0000 075A         indikatorSudut();
	RCALL _indikatorSudut
; 0000 075B         while(!sKi)
_0x1FD:
	SBRC R3,1
	RJMP _0x1FF
; 0000 075C         {
; 0000 075D                 maju();
	CALL SUBOPT_0x65
; 0000 075E                 displaySensorBit();
; 0000 075F                 scanBlackLine();
; 0000 0760         }
	RJMP _0x1FD
_0x1FF:
; 0000 0761         while(sKi)
_0x200:
	SBRS R3,1
	RJMP _0x202
; 0000 0762         {
; 0000 0763                 maju();
	CALL SUBOPT_0x65
; 0000 0764                 displaySensorBit();
; 0000 0765                 scanBlackLine();
; 0000 0766         }
	RJMP _0x200
_0x202:
; 0000 0767         indikatorSudut();
	RCALL _indikatorSudut
; 0000 0768         while(!sKi)
_0x203:
	SBRC R3,1
	RJMP _0x205
; 0000 0769         {
; 0000 076A                 maju();
	CALL SUBOPT_0x65
; 0000 076B                 displaySensorBit();
; 0000 076C                 scanBlackLine();
; 0000 076D         }
	RJMP _0x203
_0x205:
; 0000 076E         for(f=0;f<10;f++)
	LDI  R17,LOW(0)
_0x207:
	CPI  R17,10
	BRSH _0x208
; 0000 076F         {
; 0000 0770                 maju();
	CALL SUBOPT_0x65
; 0000 0771                 displaySensorBit();
; 0000 0772                 scanBlackLine();
; 0000 0773         }
	SUBI R17,-1
	RJMP _0x207
_0x208:
; 0000 0774         while(sKa)
_0x209:
	SBRS R3,0
	RJMP _0x20B
; 0000 0775         {
; 0000 0776                 maju();
	CALL _maju
; 0000 0777                 displaySensorBit();
	CALL _displaySensorBit
; 0000 0778         }
	RJMP _0x209
_0x20B:
; 0000 0779         indikatorSudut();
	CALL SUBOPT_0x6E
; 0000 077A 
; 0000 077B         // putar kiri
; 0000 077C         stop(10);
; 0000 077D         baca_sensor();
	CALL _baca_sensor
; 0000 077E         while(sKi)
_0x20C:
	SBRS R3,1
	RJMP _0x20E
; 0000 077F         {
; 0000 0780                 mundur();
	CALL SUBOPT_0x67
; 0000 0781                 lpwm = MINPWM;
; 0000 0782                 rpwm = MINPWM + 30;
; 0000 0783                 baca_sensor();
; 0000 0784         }
	RJMP _0x20C
_0x20E:
; 0000 0785         stop(10);
	CALL SUBOPT_0x62
; 0000 0786         baca_sensor();
	CALL _baca_sensor
; 0000 0787         while(sensor<255)
_0x20F:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x211
; 0000 0788         {
; 0000 0789                 bkan();
	CALL SUBOPT_0x6F
; 0000 078A                 lpwm = MINPWM;
; 0000 078B                 rpwm = MINPWM + 30;
; 0000 078C                 baca_sensor();
; 0000 078D         }
	RJMP _0x20F
_0x211:
; 0000 078E         while(s4)
_0x212:
	SBRS R2,4
	RJMP _0x214
; 0000 078F         {
; 0000 0790                 bkan();
	CALL SUBOPT_0x6F
; 0000 0791                 lpwm = MINPWM;
; 0000 0792                 rpwm = MINPWM + 30;
; 0000 0793                 baca_sensor();
; 0000 0794         }
	RJMP _0x212
_0x214:
; 0000 0795 
; 0000 0796         // counting simpangan
; 0000 0797         stop(10);
	CALL SUBOPT_0x62
; 0000 0798         baca_sensor();
	CALL _baca_sensor
; 0000 0799         while(sKi)
_0x215:
	SBRS R3,1
	RJMP _0x217
; 0000 079A         {
; 0000 079B                 maju();
	CALL SUBOPT_0x65
; 0000 079C                 displaySensorBit();
; 0000 079D                 scanBlackLine();
; 0000 079E         }
	RJMP _0x215
_0x217:
; 0000 079F         indikatorSudut();
	RCALL _indikatorSudut
; 0000 07A0         while(!sKi)
_0x218:
	SBRC R3,1
	RJMP _0x21A
; 0000 07A1         {
; 0000 07A2                 maju();
	CALL SUBOPT_0x65
; 0000 07A3                 displaySensorBit();
; 0000 07A4                 scanBlackLine();
; 0000 07A5         }
	RJMP _0x218
_0x21A:
; 0000 07A6         baca_sensor();
	CALL _baca_sensor
; 0000 07A7         while(sKi)
_0x21B:
	SBRS R3,1
	RJMP _0x21D
; 0000 07A8         {
; 0000 07A9                 maju();
	CALL SUBOPT_0x65
; 0000 07AA                 displaySensorBit();
; 0000 07AB                 scanBlackLine();
; 0000 07AC         }
	RJMP _0x21B
_0x21D:
; 0000 07AD         indikatorSudut();
	RCALL _indikatorSudut
; 0000 07AE         while(!sKi)
_0x21E:
	SBRC R3,1
	RJMP _0x220
; 0000 07AF         {
; 0000 07B0                 maju();
	CALL SUBOPT_0x65
; 0000 07B1                 displaySensorBit();
; 0000 07B2                 scanBlackLine();
; 0000 07B3         }
	RJMP _0x21E
_0x220:
; 0000 07B4         while(sKi)
_0x221:
	SBRS R3,1
	RJMP _0x223
; 0000 07B5         {
; 0000 07B6                 maju();
	CALL SUBOPT_0x65
; 0000 07B7                 displaySensorBit();
; 0000 07B8                 scanBlackLine();
; 0000 07B9         }
	RJMP _0x221
_0x223:
; 0000 07BA         indikatorSudut();
	CALL SUBOPT_0x6E
; 0000 07BB 
; 0000 07BC         // putar kanan
; 0000 07BD         stop(10);
; 0000 07BE         baca_sensor();
	CALL _baca_sensor
; 0000 07BF         while(sKi)
_0x224:
	SBRS R3,1
	RJMP _0x226
; 0000 07C0         {
; 0000 07C1                 mundur();
	CALL SUBOPT_0x67
; 0000 07C2                 lpwm = MINPWM;
; 0000 07C3                 rpwm = MINPWM + 30;
; 0000 07C4                 baca_sensor();
; 0000 07C5         }
	RJMP _0x224
_0x226:
; 0000 07C6         /*while(sensor<255)
; 0000 07C7         {
; 0000 07C8                 rotkir();
; 0000 07C9                 lpwm = MINPWM;
; 0000 07CA                 rpwm = MINPWM;
; 0000 07CB                 baca_sensor();
; 0000 07CC         } */
; 0000 07CD         baca_sensor();
	CALL _baca_sensor
; 0000 07CE         while(s0)
_0x227:
	SBRS R2,0
	RJMP _0x229
; 0000 07CF         {
; 0000 07D0                 rotkir();
	CALL SUBOPT_0x68
; 0000 07D1                 lpwm = MINPWM;
; 0000 07D2                 rpwm = MINPWM + 30;
; 0000 07D3                 baca_sensor();
; 0000 07D4         }
	RJMP _0x227
_0x229:
; 0000 07D5         baca_sensor();
	CALL _baca_sensor
; 0000 07D6         while(sKa)
_0x22A:
	SBRS R3,0
	RJMP _0x22C
; 0000 07D7         {
; 0000 07D8                 maju();
	CALL SUBOPT_0x65
; 0000 07D9                 displaySensorBit();
; 0000 07DA                 scanBlackLine();
; 0000 07DB         }
	RJMP _0x22A
_0x22C:
; 0000 07DC         baca_sensor();
	CALL _baca_sensor
; 0000 07DD         while(!sKa)
_0x22D:
	SBRC R3,0
	RJMP _0x22F
; 0000 07DE         {
; 0000 07DF                 maju();
	CALL SUBOPT_0x65
; 0000 07E0                 displaySensorBit();
; 0000 07E1                 scanBlackLine();
; 0000 07E2         }
	RJMP _0x22D
_0x22F:
; 0000 07E3         for(f=0;f<10;f++)
	LDI  R17,LOW(0)
_0x231:
	CPI  R17,10
	BRSH _0x232
; 0000 07E4         {
; 0000 07E5                 maju();
	CALL SUBOPT_0x65
; 0000 07E6                 displaySensorBit();
; 0000 07E7                 scanBlackLine();
; 0000 07E8         }
	SUBI R17,-1
	RJMP _0x231
_0x232:
; 0000 07E9         // done !
; 0000 07EA         indikatorSudut();
	RJMP _0x2080009
; 0000 07EB }
;
;void cekPoint4a(void)
; 0000 07EE {
_cekPoint4a:
; 0000 07EF         // cekpoint 4;
; 0000 07F0         MINPWM = _MINPWM - 5;
	CALL SUBOPT_0x5F
	SBIW R30,5
	CALL SUBOPT_0x60
; 0000 07F1         var_Kp = 17;
; 0000 07F2         var_Ki = 0;
; 0000 07F3         var_Kd = 11;
; 0000 07F4 
; 0000 07F5         cekpoint4:
_0x233:
; 0000 07F6 
; 0000 07F7         maju();
	CALL SUBOPT_0x65
; 0000 07F8         displaySensorBit();
; 0000 07F9         scanBlackLine();
; 0000 07FA 
; 0000 07FB         if(!sKa)
	SBRC R3,0
	RJMP _0x234
; 0000 07FC         {
; 0000 07FD                 stop(10);
	CALL SUBOPT_0x62
; 0000 07FE                 indikatorSudut();
	CALL SUBOPT_0x66
; 0000 07FF                 baca_sensor();
; 0000 0800                 while(sKa)
_0x235:
	SBRS R3,0
	RJMP _0x237
; 0000 0801                 {
; 0000 0802                         mundur();
	CALL SUBOPT_0x67
; 0000 0803                         lpwm = MINPWM;
; 0000 0804                         rpwm = MINPWM + 30;
; 0000 0805                         baca_sensor();
; 0000 0806                 }
	RJMP _0x235
_0x237:
; 0000 0807 
; 0000 0808                 stop(10);
	CALL SUBOPT_0x62
; 0000 0809 
; 0000 080A                 baca_sensor();
	CALL _baca_sensor
; 0000 080B                 while(sensor<255)
_0x238:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x23A
; 0000 080C                 {
; 0000 080D                         baca_sensor();
	CALL SUBOPT_0x70
; 0000 080E                         lpwm = MINPWM;
; 0000 080F                         rpwm = MINPWM + 30;
; 0000 0810                         rotkan();
; 0000 0811                 }
	RJMP _0x238
_0x23A:
; 0000 0812 
; 0000 0813                 baca_sensor();
	CALL _baca_sensor
; 0000 0814                 while(s4)
_0x23B:
	SBRS R2,4
	RJMP _0x23D
; 0000 0815                 {
; 0000 0816                         baca_sensor();
	CALL SUBOPT_0x70
; 0000 0817                         lpwm = MINPWM;
; 0000 0818                         rpwm = MINPWM + 30;
; 0000 0819                         rotkan();
; 0000 081A                 }
	RJMP _0x23B
_0x23D:
; 0000 081B 
; 0000 081C                 stop(10);
	CALL SUBOPT_0x62
; 0000 081D                 goto cekpoint41;
	RJMP _0x23E
; 0000 081E         }
; 0000 081F         goto cekpoint4;
_0x234:
	RJMP _0x233
; 0000 0820 
; 0000 0821         cekpoint41:
_0x23E:
; 0000 0822 
; 0000 0823         maju();
	CALL SUBOPT_0x65
; 0000 0824         displaySensorBit();
; 0000 0825         scanBlackLine();
; 0000 0826 
; 0000 0827         if(!sKi)
	SBRC R3,1
	RJMP _0x23F
; 0000 0828         {
; 0000 0829                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 082A                 //MINPWM = 100;
; 0000 082B                 while(!sKi)
_0x240:
	SBRC R3,1
	RJMP _0x242
; 0000 082C                 {
; 0000 082D                         maju();
	CALL SUBOPT_0x65
; 0000 082E                         displaySensorBit();
; 0000 082F                         scanBlackLine();
; 0000 0830                 }
	RJMP _0x240
_0x242:
; 0000 0831                 goto cekpoint42;
	RJMP _0x243
; 0000 0832         }
; 0000 0833 
; 0000 0834         goto cekpoint41;
_0x23F:
	RJMP _0x23E
; 0000 0835 
; 0000 0836         cekpoint42:
_0x243:
; 0000 0837 
; 0000 0838         maju();
	CALL SUBOPT_0x65
; 0000 0839         displaySensorBit();
; 0000 083A         scanBlackLine();
; 0000 083B         if(!sKi)
	SBRC R3,1
	RJMP _0x244
; 0000 083C         {
; 0000 083D                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 083E                 //MINPWM = 110;
; 0000 083F                 while(!sKi)
_0x245:
	SBRC R3,1
	RJMP _0x247
; 0000 0840                 {
; 0000 0841                         maju();
	CALL SUBOPT_0x65
; 0000 0842                         displaySensorBit();
; 0000 0843                         scanBlackLine();
; 0000 0844                 }
	RJMP _0x245
_0x247:
; 0000 0845                 goto cekpoint43;
	RJMP _0x248
; 0000 0846         }
; 0000 0847         goto cekpoint42;
_0x244:
	RJMP _0x243
; 0000 0848 
; 0000 0849         cekpoint43:
_0x248:
; 0000 084A 
; 0000 084B         //maju();
; 0000 084C         displaySensorBit();
	CALL SUBOPT_0x61
; 0000 084D         scanBlackLine();
; 0000 084E         if(!sKi)
	SBRC R3,1
	RJMP _0x249
; 0000 084F         {
; 0000 0850                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 0851                 //MINPWM = 120;
; 0000 0852                 while(!sKi)
_0x24A:
	SBRC R3,1
	RJMP _0x24C
; 0000 0853                 {
; 0000 0854                         maju();
	CALL SUBOPT_0x65
; 0000 0855                         displaySensorBit();
; 0000 0856                         scanBlackLine();
; 0000 0857                 }
	RJMP _0x24A
_0x24C:
; 0000 0858                 goto cekpoint44;
	RJMP _0x24D
; 0000 0859         }
; 0000 085A         goto cekpoint43;
_0x249:
	RJMP _0x248
; 0000 085B 
; 0000 085C         cekpoint44:
_0x24D:
; 0000 085D 
; 0000 085E         maju();
	CALL SUBOPT_0x65
; 0000 085F         displaySensorBit();
; 0000 0860         scanBlackLine();
; 0000 0861         if(!sKi)
	SBRC R3,1
	RJMP _0x24E
; 0000 0862         {
; 0000 0863                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 0864                 //MINPWM = 130;
; 0000 0865                 while(!sKi)
_0x24F:
	SBRC R3,1
	RJMP _0x251
; 0000 0866                 {
; 0000 0867                         maju();
	CALL SUBOPT_0x65
; 0000 0868                         displaySensorBit();
; 0000 0869                         scanBlackLine();
; 0000 086A                 }
	RJMP _0x24F
_0x251:
; 0000 086B                 goto cekpoint45;
	RJMP _0x252
; 0000 086C         }
; 0000 086D         goto cekpoint44;
_0x24E:
	RJMP _0x24D
; 0000 086E 
; 0000 086F         cekpoint45:
_0x252:
; 0000 0870 
; 0000 0871         maju();
	CALL SUBOPT_0x65
; 0000 0872         displaySensorBit();
; 0000 0873         scanBlackLine();
; 0000 0874         if(!sKi)
	SBRC R3,1
	RJMP _0x253
; 0000 0875         {
; 0000 0876                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 0877                 //MINPWM = 140;
; 0000 0878                 while(!sKi)
_0x254:
	SBRC R3,1
	RJMP _0x256
; 0000 0879                 {
; 0000 087A                         maju();
	CALL SUBOPT_0x65
; 0000 087B                         displaySensorBit();
; 0000 087C                         scanBlackLine();
; 0000 087D                 }
	RJMP _0x254
_0x256:
; 0000 087E                 goto cekpoint5;
	RJMP _0x257
; 0000 087F         }
; 0000 0880         goto cekpoint45;
_0x253:
	RJMP _0x252
; 0000 0881 
; 0000 0882         cekpoint5:
_0x257:
; 0000 0883         indikatorSudut();
	RJMP _0x2080007
; 0000 0884 }
;
;void cekPoint5a(void)
; 0000 0887 {
_cekPoint5a:
; 0000 0888         char k = 0;
; 0000 0889 
; 0000 088A         //cek point 5
; 0000 088B         stop(3);
	ST   -Y,R17
;	k -> R17
	LDI  R17,0
	CALL SUBOPT_0x5C
; 0000 088C         MINPWM = _MINPWM;
	CALL SUBOPT_0x71
; 0000 088D         var_Kp = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x72
; 0000 088E         var_Ki = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x73
; 0000 088F         var_Kd = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0x74
; 0000 0890 
; 0000 0891         maju();
	CALL _maju
; 0000 0892         cekpoint5:
_0x258:
; 0000 0893 
; 0000 0894         displaySensorBit();
	CALL SUBOPT_0x61
; 0000 0895         scanBlackLine();
; 0000 0896         MINPWM = MINPWM + 2;
	CALL SUBOPT_0x54
	ADIW R30,2
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
; 0000 0897         if(MINPWM > 255) MINPWM = 255;
	CALL SUBOPT_0x59
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x259
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
; 0000 0898         if(sensor==255)
_0x259:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x25A
; 0000 0899         {
; 0000 089A                 k++;
	SUBI R17,-1
; 0000 089B                 if(k > 100)
	CPI  R17,101
	BRLO _0x25B
; 0000 089C                 {
; 0000 089D                         mundur();
	CALL _mundur
; 0000 089E                         indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 089F                         stop(150);
	LDI  R30,LOW(150)
	ST   -Y,R30
	CALL _stop
; 0000 08A0                         indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 08A1                         goto exit;
	RJMP _0x25C
; 0000 08A2                 }
; 0000 08A3         }
_0x25B:
; 0000 08A4         goto cekpoint5;
_0x25A:
	RJMP _0x258
; 0000 08A5 
; 0000 08A6         exit:
_0x25C:
; 0000 08A7 }
	RJMP _0x2080008
;
;void cekPointFinalA(void)
; 0000 08AA {
; 0000 08AB }
;
;void strategiA(void)
; 0000 08AE {
_strategiA:
; 0000 08AF         if(NoStrategi < 2)      goto level_1a;
	CALL SUBOPT_0x75
	CPI  R30,LOW(0x2)
	BRLO _0x25E
; 0000 08B0         else if(NoStrategi < 3) goto level_2a;
	CALL SUBOPT_0x75
	CPI  R30,LOW(0x3)
	BRLO _0x261
; 0000 08B1         else if(NoStrategi < 4) goto level_3a;
	CALL SUBOPT_0x75
	CPI  R30,LOW(0x4)
	BRSH _0x263
	RJMP _0x264
; 0000 08B2         else if(NoStrategi < 5) goto level_4a;
_0x263:
	CALL SUBOPT_0x75
	CPI  R30,LOW(0x5)
	BRSH _0x266
	RJMP _0x267
; 0000 08B3 
; 0000 08B4         else if(NoStrategi < 6) goto level_5a;
_0x266:
	CALL SUBOPT_0x75
	CPI  R30,LOW(0x6)
	BRSH _0x269
	RJMP _0x26A
; 0000 08B5         else                    goto level_6a;
_0x269:
	RJMP _0x26C
; 0000 08B6 
; 0000 08B7         level_1a:
_0x25E:
; 0000 08B8 
; 0000 08B9         backlight = 1;
	CALL SUBOPT_0x76
; 0000 08BA         NoStrategi = 1;
; 0000 08BB         delay_ms(50);
; 0000 08BC         lcd_clear();
	CALL SUBOPT_0x8
; 0000 08BD         lcd_gotoxy(0,0);
; 0000 08BE         lcd_putsf(" Skenario-StartA");
	__POINTW1FN _0x0,694
	CALL SUBOPT_0x5
; 0000 08BF         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 08C0         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 08C1         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 08C2         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 08C3 
; 0000 08C4         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x26F
; 0000 08C5         {
; 0000 08C6                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 08C7                 goto level_6a;
	RJMP _0x26C
; 0000 08C8         }
; 0000 08C9         if(!sw_down)
_0x26F:
	SBIC 0x10,6
	RJMP _0x270
; 0000 08CA         {
; 0000 08CB                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 08CC                 goto level_2a;
	RJMP _0x261
; 0000 08CD         }
; 0000 08CE         if(!sw_ok)
_0x270:
	SBIC 0x10,5
	RJMP _0x271
; 0000 08CF         {
; 0000 08D0                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 08D1                 backlight = 0;
	CBI  0x18,3
; 0000 08D2 
; 0000 08D3                 cekPointStarta();
	RCALL _cekPointStarta
; 0000 08D4                 cekPoint1a();
	CALL SUBOPT_0x79
; 0000 08D5                 cekPoint2a();
; 0000 08D6                 cekPoint3a();
; 0000 08D7                 cekPoint4a();
; 0000 08D8                 cekPoint5a();
; 0000 08D9 
; 0000 08DA                 goto exit_strategi;
	RJMP _0x274
; 0000 08DB         }
; 0000 08DC         if(!sw_cancel)
_0x271:
	SBIC 0x10,3
	RJMP _0x275
; 0000 08DD         {
; 0000 08DE                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 08DF                 goto exit_strategi;
	RJMP _0x274
; 0000 08E0         }
; 0000 08E1 
; 0000 08E2         goto level_1a;
_0x275:
	RJMP _0x25E
; 0000 08E3 
; 0000 08E4         level_2a:
_0x261:
; 0000 08E5 
; 0000 08E6         backlight = 1;
	CALL SUBOPT_0x7A
; 0000 08E7         NoStrategi = 2;
; 0000 08E8         delay_ms(50);
; 0000 08E9         lcd_clear();
	CALL SUBOPT_0x8
; 0000 08EA         lcd_gotoxy(0,0);
; 0000 08EB         lcd_putsf("  Skenario-1A");
	__POINTW1FN _0x0,718
	CALL SUBOPT_0x5
; 0000 08EC         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 08ED         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 08EE         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 08EF         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 08F0 
; 0000 08F1         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x278
; 0000 08F2         {
; 0000 08F3                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 08F4                 goto level_1a;
	RJMP _0x25E
; 0000 08F5         }
; 0000 08F6         if(!sw_down)
_0x278:
	SBIC 0x10,6
	RJMP _0x279
; 0000 08F7         {
; 0000 08F8                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 08F9                 goto level_3a;
	RJMP _0x264
; 0000 08FA         }
; 0000 08FB          if(!sw_ok)
_0x279:
	SBIC 0x10,5
	RJMP _0x27A
; 0000 08FC         {
; 0000 08FD                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 08FE                 backlight = 0;
	CBI  0x18,3
; 0000 08FF 
; 0000 0900                 cekPoint1a();
	CALL SUBOPT_0x79
; 0000 0901                 cekPoint2a();
; 0000 0902                 cekPoint3a();
; 0000 0903                 cekPoint4a();
; 0000 0904                 cekPoint5a();
; 0000 0905 
; 0000 0906                 goto exit_strategi;
	RJMP _0x274
; 0000 0907         }
; 0000 0908         if(!sw_cancel)
_0x27A:
	SBIC 0x10,3
	RJMP _0x27D
; 0000 0909         {
; 0000 090A                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 090B                 goto exit_strategi;
	RJMP _0x274
; 0000 090C         }
; 0000 090D         goto level_2a;
_0x27D:
	RJMP _0x261
; 0000 090E 
; 0000 090F         level_3a:
_0x264:
; 0000 0910 
; 0000 0911         backlight = 1;
	CALL SUBOPT_0x7B
; 0000 0912         NoStrategi = 3;
; 0000 0913         delay_ms(50);
; 0000 0914         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0915         lcd_gotoxy(0,0);
; 0000 0916         lcd_putsf("  Skenario-2A");
	__POINTW1FN _0x0,732
	CALL SUBOPT_0x5
; 0000 0917         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0918         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 0919         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 091A         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 091B 
; 0000 091C         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x280
; 0000 091D         {
; 0000 091E                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 091F                 goto level_2a;
	RJMP _0x261
; 0000 0920         }
; 0000 0921         if(!sw_down)
_0x280:
	SBIC 0x10,6
	RJMP _0x281
; 0000 0922         {
; 0000 0923                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0924                 goto level_4a;
	RJMP _0x267
; 0000 0925         }
; 0000 0926          if(!sw_ok)
_0x281:
	SBIC 0x10,5
	RJMP _0x282
; 0000 0927         {
; 0000 0928                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0929                 backlight = 0;
	CBI  0x18,3
; 0000 092A 
; 0000 092B                 cekPoint2a();
	RCALL _cekPoint2a
; 0000 092C                 cekPoint3a();
	CALL SUBOPT_0x7C
; 0000 092D                 cekPoint4a();
; 0000 092E                 cekPoint5a();
; 0000 092F 
; 0000 0930                 goto exit_strategi;
	RJMP _0x274
; 0000 0931         }
; 0000 0932         if(!sw_cancel)
_0x282:
	SBIC 0x10,3
	RJMP _0x285
; 0000 0933         {
; 0000 0934                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0935                 goto exit_strategi;
	RJMP _0x274
; 0000 0936         }
; 0000 0937         goto level_3a;
_0x285:
	RJMP _0x264
; 0000 0938 
; 0000 0939         level_4a:
_0x267:
; 0000 093A 
; 0000 093B         backlight = 1;
	CALL SUBOPT_0x7D
; 0000 093C         NoStrategi = 4;
; 0000 093D         delay_ms(50);
; 0000 093E         lcd_clear();
	CALL SUBOPT_0x8
; 0000 093F         lcd_gotoxy(0,0);
; 0000 0940         lcd_putsf("  Skenario-3A");
	__POINTW1FN _0x0,746
	CALL SUBOPT_0x5
; 0000 0941         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0942         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 0943         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0944         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0945 
; 0000 0946         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x288
; 0000 0947         {
; 0000 0948                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0949                 goto level_3a;
	RJMP _0x264
; 0000 094A         }
; 0000 094B         if(!sw_down)
_0x288:
	SBIC 0x10,6
	RJMP _0x289
; 0000 094C         {
; 0000 094D                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 094E                 goto level_5a;
	RJMP _0x26A
; 0000 094F         }
; 0000 0950          if(!sw_ok)
_0x289:
	SBIC 0x10,5
	RJMP _0x28A
; 0000 0951         {
; 0000 0952                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0953                 backlight = 0;
	CBI  0x18,3
; 0000 0954 
; 0000 0955                 cekPoint3a();
	CALL SUBOPT_0x7C
; 0000 0956                 cekPoint4a();
; 0000 0957                 cekPoint5a();
; 0000 0958 
; 0000 0959                 goto exit_strategi;
	RJMP _0x274
; 0000 095A         }
; 0000 095B         if(!sw_cancel)
_0x28A:
	SBIC 0x10,3
	RJMP _0x28D
; 0000 095C         {
; 0000 095D                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 095E                 goto exit_strategi;
	RJMP _0x274
; 0000 095F         }
; 0000 0960         goto level_4a;
_0x28D:
	RJMP _0x267
; 0000 0961 
; 0000 0962         level_5a:
_0x26A:
; 0000 0963 
; 0000 0964         backlight = 1;
	CALL SUBOPT_0x7E
; 0000 0965         NoStrategi = 5;
; 0000 0966         delay_ms(50);
; 0000 0967         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0968         lcd_gotoxy(0,0);
; 0000 0969         lcd_putsf("  Skenario-4A");
	__POINTW1FN _0x0,760
	CALL SUBOPT_0x5
; 0000 096A         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 096B         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 096C         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 096D         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 096E 
; 0000 096F         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x290
; 0000 0970         {
; 0000 0971                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0972                 goto level_4a;
	RJMP _0x267
; 0000 0973         }
; 0000 0974         if(!sw_down)
_0x290:
	SBIC 0x10,6
	RJMP _0x291
; 0000 0975         {
; 0000 0976                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0977                 goto level_6a;
	RJMP _0x26C
; 0000 0978         }
; 0000 0979          if(!sw_ok)
_0x291:
	SBIC 0x10,5
	RJMP _0x292
; 0000 097A         {
; 0000 097B                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 097C                 backlight = 0;
	CBI  0x18,3
; 0000 097D 
; 0000 097E                 cekPoint4a();
	RCALL _cekPoint4a
; 0000 097F                 cekPoint5a();
	RCALL _cekPoint5a
; 0000 0980 
; 0000 0981                 goto exit_strategi;
	RJMP _0x274
; 0000 0982         }
; 0000 0983         if(!sw_cancel)
_0x292:
	SBIC 0x10,3
	RJMP _0x295
; 0000 0984         {
; 0000 0985                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0986                 goto exit_strategi;
	RJMP _0x274
; 0000 0987         }
; 0000 0988         goto level_5a;
_0x295:
	RJMP _0x26A
; 0000 0989 
; 0000 098A         level_6a:
_0x26C:
; 0000 098B 
; 0000 098C         backlight = 1;
	CALL SUBOPT_0x7F
; 0000 098D         NoStrategi = 6;
; 0000 098E         delay_ms(50);
; 0000 098F         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0990         lcd_gotoxy(0,0);
; 0000 0991         lcd_putsf("  Skenario-5A");
	__POINTW1FN _0x0,774
	CALL SUBOPT_0x5
; 0000 0992         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0993         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 0994         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0995         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0996 
; 0000 0997         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x298
; 0000 0998         {
; 0000 0999                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 099A                 goto level_5a;
	RJMP _0x26A
; 0000 099B         }
; 0000 099C         if(!sw_down)
_0x298:
	SBIC 0x10,6
	RJMP _0x299
; 0000 099D         {
; 0000 099E                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 099F                 goto level_1a;
	RJMP _0x25E
; 0000 09A0         }
; 0000 09A1          if(!sw_ok)
_0x299:
	SBIC 0x10,5
	RJMP _0x29A
; 0000 09A2         {
; 0000 09A3                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 09A4                 backlight = 0;
	CBI  0x18,3
; 0000 09A5 
; 0000 09A6                 cekPoint5a();
	RCALL _cekPoint5a
; 0000 09A7 
; 0000 09A8                 goto exit_strategi;
	RJMP _0x274
; 0000 09A9         }
; 0000 09AA         if(!sw_cancel)
_0x29A:
	SBIC 0x10,3
	RJMP _0x29D
; 0000 09AB         {
; 0000 09AC                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 09AD                 goto exit_strategi;
	RJMP _0x274
; 0000 09AE         }
; 0000 09AF         goto level_6a;
_0x29D:
	RJMP _0x26C
; 0000 09B0 
; 0000 09B1         exit_strategi:
_0x274:
; 0000 09B2         backlight = 0;
	RJMP _0x2080006
; 0000 09B3 }
;
;// strategi track B penyisihan, warna : biru , kuning
;
;void cekPointStartb(void)
; 0000 09B8 {
_cekPointStartb:
; 0000 09B9         MINPWM = _MINPWM;
	CALL SUBOPT_0x5F
	CALL SUBOPT_0x60
; 0000 09BA         var_Kp = 17;
; 0000 09BB         var_Ki = 0;
; 0000 09BC         var_Kd = 11;
; 0000 09BD 
; 0000 09BE         maju();
	CALL _maju
; 0000 09BF         while(sKi)
_0x2A0:
	SBRS R3,1
	RJMP _0x2A2
; 0000 09C0         {
; 0000 09C1                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 09C2                 scanBlackLine();
; 0000 09C3         }
	RJMP _0x2A0
_0x2A2:
; 0000 09C4         stop(10);
	CALL SUBOPT_0x62
; 0000 09C5         baca_sensor();
	CALL _baca_sensor
; 0000 09C6         while(sensor==255)
_0x2A3:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x2A5
; 0000 09C7         {
; 0000 09C8                 rotkir();
	CALL _rotkir
; 0000 09C9                 lpwm = MINPWM;
	CALL SUBOPT_0x80
; 0000 09CA                 rpwm = MINPWM + 15;
	ADIW R30,15
	CALL SUBOPT_0x64
; 0000 09CB                 baca_sensor();
; 0000 09CC         }
	RJMP _0x2A3
_0x2A5:
; 0000 09CD         stop(10);
	CALL SUBOPT_0x62
; 0000 09CE         for(;;)
_0x2A7:
; 0000 09CF         {
; 0000 09D0                 maju();
	CALL SUBOPT_0x65
; 0000 09D1                 displaySensorBit();
; 0000 09D2                 scanBlackLine();
; 0000 09D3         }
	RJMP _0x2A7
; 0000 09D4 }
;
;void cekPoint1b(void)
; 0000 09D7 {
_cekPoint1b:
; 0000 09D8         //cek point 1
; 0000 09D9         MINPWM = _MINPWM - 10;
	CALL SUBOPT_0x5F
	SBIW R30,10
	CALL SUBOPT_0x60
; 0000 09DA         var_Kp = 17;
; 0000 09DB         var_Ki = 0;
; 0000 09DC         var_Kd = 11;
; 0000 09DD 
; 0000 09DE         // cari simpangan T
; 0000 09DF         baca_sensor();
	CALL _baca_sensor
; 0000 09E0         maju();
	CALL _maju
; 0000 09E1         while(sKa)
_0x2A9:
	SBRS R3,0
	RJMP _0x2AB
; 0000 09E2         {
; 0000 09E3                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 09E4                 scanBlackLine();
; 0000 09E5         }
	RJMP _0x2A9
_0x2AB:
; 0000 09E6         stop(10);
	CALL SUBOPT_0x62
; 0000 09E7         indikatorSudut();
	CALL SUBOPT_0x66
; 0000 09E8 
; 0000 09E9         // lepas T, mundur
; 0000 09EA         baca_sensor();
; 0000 09EB         while(sKa)
_0x2AC:
	SBRS R3,0
	RJMP _0x2AE
; 0000 09EC         {
; 0000 09ED                 mundur();
	CALL SUBOPT_0x67
; 0000 09EE                 lpwm = MINPWM;
; 0000 09EF                 rpwm = MINPWM + 30;
; 0000 09F0                 baca_sensor();
; 0000 09F1         }
	RJMP _0x2AC
_0x2AE:
; 0000 09F2 
; 0000 09F3         // balik ke T putar kanan
; 0000 09F4         baca_sensor();
	CALL _baca_sensor
; 0000 09F5         while(sensor==255)
_0x2AF:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x2B1
; 0000 09F6         {
; 0000 09F7                 rotkan();
	CALL SUBOPT_0x63
; 0000 09F8                 lpwm = MINPWM;
; 0000 09F9                 rpwm = MINPWM + 30;
	ADIW R30,30
	CALL SUBOPT_0x64
; 0000 09FA                 baca_sensor();
; 0000 09FB         }
	RJMP _0x2AF
_0x2B1:
; 0000 09FC         stop(10);
	CALL SUBOPT_0x62
; 0000 09FD 
; 0000 09FE         // maju menuju busur dan perempatan
; 0000 09FF         maju();
	CALL _maju
; 0000 0A00         while(sKa)
_0x2B2:
	SBRS R3,0
	RJMP _0x2B4
; 0000 0A01         {
; 0000 0A02                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 0A03                 scanBlackLine();
; 0000 0A04         }
	RJMP _0x2B2
_0x2B4:
; 0000 0A05         /*indikatorSudut();
; 0000 0A06         while(!sKi)
; 0000 0A07         {
; 0000 0A08                 displaySensorBit();
; 0000 0A09                 scanBlackLine();
; 0000 0A0A         }
; 0000 0A0B         while(sKi)
; 0000 0A0C         {
; 0000 0A0D                 displaySensorBit();
; 0000 0A0E                 scanBlackLine();
; 0000 0A0F         } */
; 0000 0A10         stop(10);
	CALL SUBOPT_0x62
; 0000 0A11         indikatorSudut();
	CALL SUBOPT_0x66
; 0000 0A12 
; 0000 0A13         // ketemu perempatan, putar kiri
; 0000 0A14         baca_sensor();
; 0000 0A15         while(sKa)      // lepas perempatan
_0x2B5:
	SBRS R3,0
	RJMP _0x2B7
; 0000 0A16         {
; 0000 0A17                 mundur();
	CALL SUBOPT_0x67
; 0000 0A18                 lpwm = MINPWM;
; 0000 0A19                 rpwm = MINPWM + 30;
; 0000 0A1A                 baca_sensor();
; 0000 0A1B         }
	RJMP _0x2B5
_0x2B7:
; 0000 0A1C         baca_sensor();
	CALL _baca_sensor
; 0000 0A1D         while(sensor<255)       // manuver kiri
_0x2B8:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x2BA
; 0000 0A1E         {
; 0000 0A1F                 rotkir();
	CALL SUBOPT_0x68
; 0000 0A20                 lpwm = MINPWM;
; 0000 0A21                 rpwm = MINPWM + 30;
; 0000 0A22                 baca_sensor();
; 0000 0A23         }
	RJMP _0x2B8
_0x2BA:
; 0000 0A24         while(sensor==255)
_0x2BB:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x2BD
; 0000 0A25         {
; 0000 0A26                 rotkir();
	CALL SUBOPT_0x68
; 0000 0A27                 lpwm = MINPWM;
; 0000 0A28                 rpwm = MINPWM + 30;
; 0000 0A29                 baca_sensor();
; 0000 0A2A         }
	RJMP _0x2BB
_0x2BD:
; 0000 0A2B         stop(10);
_0x208000B:
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _stop
; 0000 0A2C 
; 0000 0A2D         maju();
	CALL _maju
; 0000 0A2E }
	RET
;
;void cekPoint2b(void)
; 0000 0A31 {
_cekPoint2b:
; 0000 0A32         int tlpwm, trpwm;
; 0000 0A33 
; 0000 0A34         //cek point 2
; 0000 0A35         MINPWM = _MINPWM - 15;
	CALL SUBOPT_0x69
;	tlpwm -> R16,R17
;	trpwm -> R18,R19
; 0000 0A36         var_Kp = 17;
; 0000 0A37         var_Ki = 0;
; 0000 0A38         var_Kd = 8;
; 0000 0A39 
; 0000 0A3A         // cari perempatan V
; 0000 0A3B         maju();
; 0000 0A3C         while(sKa)
_0x2BE:
	SBRS R3,0
	RJMP _0x2C0
; 0000 0A3D         {
; 0000 0A3E                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 0A3F                 scanBlackLine();
; 0000 0A40         }
	RJMP _0x2BE
_0x2C0:
; 0000 0A41         indikatorSudut();
	CALL SUBOPT_0x6A
; 0000 0A42         tlpwm = lpwm;
; 0000 0A43         trpwm = rpwm;
; 0000 0A44         lpwm = MINPWM;
; 0000 0A45         rpwm = MINPWM + 30;
; 0000 0A46         rotkir();
	CALL _rotkir
; 0000 0A47         delay_ms(75);
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	CALL SUBOPT_0x52
; 0000 0A48         stop(5);
	CALL SUBOPT_0x6C
; 0000 0A49         maju();
; 0000 0A4A         MINPWM = _MINPWM;
; 0000 0A4B         lpwm = tlpwm;
; 0000 0A4C         rpwm = trpwm;
; 0000 0A4D         for(;;)
_0x2C2:
; 0000 0A4E         {
; 0000 0A4F                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 0A50                 scanBlackLine();
; 0000 0A51         }
	RJMP _0x2C2
; 0000 0A52 }
_0x208000A:
	CALL __LOADLOCR4
	ADIW R28,4
	RET
;
;void cekPoint3b(void)
; 0000 0A55 {
_cekPoint3b:
; 0000 0A56         char f;
; 0000 0A57 
; 0000 0A58         //cek point 3
; 0000 0A59         MINPWM = _MINPWM - 13;
	CALL SUBOPT_0x6D
;	f -> R17
; 0000 0A5A         var_Kp = 11;
; 0000 0A5B         var_Ki = 0;
; 0000 0A5C         var_Kd = 7;
; 0000 0A5D 
; 0000 0A5E         // cari simpangan
; 0000 0A5F         maju();
; 0000 0A60         while(sKa)
_0x2C4:
	SBRS R3,0
	RJMP _0x2C6
; 0000 0A61         {
; 0000 0A62                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 0A63                 scanBlackLine();
; 0000 0A64         }
	RJMP _0x2C4
_0x2C6:
; 0000 0A65         indikatorSudut();
	CALL SUBOPT_0x6E
; 0000 0A66 
; 0000 0A67         // putar kiri
; 0000 0A68         stop(10);
; 0000 0A69         baca_sensor();
	CALL _baca_sensor
; 0000 0A6A         while(sKa)
_0x2C7:
	SBRS R3,0
	RJMP _0x2C9
; 0000 0A6B         {
; 0000 0A6C                 mundur();
	CALL SUBOPT_0x67
; 0000 0A6D                 lpwm = MINPWM;
; 0000 0A6E                 rpwm = MINPWM + 30;
; 0000 0A6F                 baca_sensor();
; 0000 0A70         }
	RJMP _0x2C7
_0x2C9:
; 0000 0A71         stop(10);
	CALL SUBOPT_0x62
; 0000 0A72         baca_sensor();
	CALL _baca_sensor
; 0000 0A73         while(s0)
_0x2CA:
	SBRS R2,0
	RJMP _0x2CC
; 0000 0A74         {
; 0000 0A75                 rotkan();
	CALL SUBOPT_0x63
; 0000 0A76                 lpwm = MINPWM;
; 0000 0A77                 rpwm = MINPWM + 30;
	ADIW R30,30
	CALL SUBOPT_0x64
; 0000 0A78                 baca_sensor();
; 0000 0A79         }
	RJMP _0x2CA
_0x2CC:
; 0000 0A7A         baca_sensor();
	CALL _baca_sensor
; 0000 0A7B         while(!s0)
_0x2CD:
	SBRC R2,0
	RJMP _0x2CF
; 0000 0A7C         {
; 0000 0A7D                 rotkan();
	CALL SUBOPT_0x63
; 0000 0A7E                 lpwm = MINPWM;
; 0000 0A7F                 rpwm = MINPWM + 30;
	ADIW R30,30
	CALL SUBOPT_0x64
; 0000 0A80                 baca_sensor();
; 0000 0A81         }
	RJMP _0x2CD
_0x2CF:
; 0000 0A82         baca_sensor();
	CALL _baca_sensor
; 0000 0A83         while(s4)
_0x2D0:
	SBRS R2,4
	RJMP _0x2D2
; 0000 0A84         {
; 0000 0A85                 rotkan();
	CALL SUBOPT_0x63
; 0000 0A86                 lpwm = MINPWM;
; 0000 0A87                 rpwm = MINPWM + 30;
	ADIW R30,30
	CALL SUBOPT_0x64
; 0000 0A88                 baca_sensor();
; 0000 0A89         }
	RJMP _0x2D0
_0x2D2:
; 0000 0A8A 
; 0000 0A8B         // counting simpangan
; 0000 0A8C         stop(10);
	CALL SUBOPT_0x62
; 0000 0A8D         baca_sensor();
	CALL _baca_sensor
; 0000 0A8E         while(sKa)
_0x2D3:
	SBRS R3,0
	RJMP _0x2D5
; 0000 0A8F         {
; 0000 0A90                 maju();
	CALL SUBOPT_0x65
; 0000 0A91                 displaySensorBit();
; 0000 0A92                 scanBlackLine();
; 0000 0A93         }
	RJMP _0x2D3
_0x2D5:
; 0000 0A94         indikatorSudut();
	RCALL _indikatorSudut
; 0000 0A95         while(!sKa)
_0x2D6:
	SBRC R3,0
	RJMP _0x2D8
; 0000 0A96         {
; 0000 0A97                 maju();
	CALL SUBOPT_0x65
; 0000 0A98                 displaySensorBit();
; 0000 0A99                 scanBlackLine();
; 0000 0A9A         }
	RJMP _0x2D6
_0x2D8:
; 0000 0A9B         while(sKa)
_0x2D9:
	SBRS R3,0
	RJMP _0x2DB
; 0000 0A9C         {
; 0000 0A9D                 maju();
	CALL SUBOPT_0x65
; 0000 0A9E                 displaySensorBit();
; 0000 0A9F                 scanBlackLine();
; 0000 0AA0         }
	RJMP _0x2D9
_0x2DB:
; 0000 0AA1         indikatorSudut();
	RCALL _indikatorSudut
; 0000 0AA2         while(!sKa)
_0x2DC:
	SBRC R3,0
	RJMP _0x2DE
; 0000 0AA3         {
; 0000 0AA4                 maju();
	CALL SUBOPT_0x65
; 0000 0AA5                 displaySensorBit();
; 0000 0AA6                 scanBlackLine();
; 0000 0AA7         }
	RJMP _0x2DC
_0x2DE:
; 0000 0AA8         for(f=0;f<10;f++)
	LDI  R17,LOW(0)
_0x2E0:
	CPI  R17,10
	BRSH _0x2E1
; 0000 0AA9         {
; 0000 0AAA                 maju();
	CALL SUBOPT_0x65
; 0000 0AAB                 displaySensorBit();
; 0000 0AAC                 scanBlackLine();
; 0000 0AAD         }
	SUBI R17,-1
	RJMP _0x2E0
_0x2E1:
; 0000 0AAE         while(sKa)
_0x2E2:
	SBRS R3,0
	RJMP _0x2E4
; 0000 0AAF         {
; 0000 0AB0                 maju();
	CALL _maju
; 0000 0AB1                 displaySensorBit();
	CALL _displaySensorBit
; 0000 0AB2         }
	RJMP _0x2E2
_0x2E4:
; 0000 0AB3         indikatorSudut();
	CALL SUBOPT_0x6E
; 0000 0AB4 
; 0000 0AB5         // putar kanan
; 0000 0AB6         stop(10);
; 0000 0AB7         baca_sensor();
	CALL _baca_sensor
; 0000 0AB8         while(sKa)
_0x2E5:
	SBRS R3,0
	RJMP _0x2E7
; 0000 0AB9         {
; 0000 0ABA                 mundur();
	CALL SUBOPT_0x67
; 0000 0ABB                 lpwm = MINPWM;
; 0000 0ABC                 rpwm = MINPWM + 30;
; 0000 0ABD                 baca_sensor();
; 0000 0ABE         }
	RJMP _0x2E5
_0x2E7:
; 0000 0ABF         stop(10);
	CALL SUBOPT_0x62
; 0000 0AC0         baca_sensor();
	CALL _baca_sensor
; 0000 0AC1         while(sensor<255)
_0x2E8:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x2EA
; 0000 0AC2         {
; 0000 0AC3                 bkir();
	CALL _bkir
; 0000 0AC4                 lpwm = MINPWM;
	CALL SUBOPT_0x80
; 0000 0AC5                 rpwm = MINPWM + 30;
	ADIW R30,30
	CALL SUBOPT_0x64
; 0000 0AC6                 baca_sensor();
; 0000 0AC7         }
	RJMP _0x2E8
_0x2EA:
; 0000 0AC8         while(s3)
_0x2EB:
	SBRS R2,3
	RJMP _0x2ED
; 0000 0AC9         {
; 0000 0ACA                 bkir();
	CALL _bkir
; 0000 0ACB                 lpwm = MINPWM;
	CALL SUBOPT_0x80
; 0000 0ACC                 rpwm = MINPWM + 30;
	ADIW R30,30
	CALL SUBOPT_0x64
; 0000 0ACD                 baca_sensor();
; 0000 0ACE         }
	RJMP _0x2EB
_0x2ED:
; 0000 0ACF 
; 0000 0AD0         // counting simpangan
; 0000 0AD1         stop(10);
	CALL SUBOPT_0x62
; 0000 0AD2         baca_sensor();
	CALL _baca_sensor
; 0000 0AD3         while(sKa)
_0x2EE:
	SBRS R3,0
	RJMP _0x2F0
; 0000 0AD4         {
; 0000 0AD5                 maju();
	CALL SUBOPT_0x65
; 0000 0AD6                 displaySensorBit();
; 0000 0AD7                 scanBlackLine();
; 0000 0AD8         }
	RJMP _0x2EE
_0x2F0:
; 0000 0AD9         indikatorSudut();
	RCALL _indikatorSudut
; 0000 0ADA         while(!sKa)
_0x2F1:
	SBRC R3,0
	RJMP _0x2F3
; 0000 0ADB         {
; 0000 0ADC                 maju();
	CALL SUBOPT_0x65
; 0000 0ADD                 displaySensorBit();
; 0000 0ADE                 scanBlackLine();
; 0000 0ADF         }
	RJMP _0x2F1
_0x2F3:
; 0000 0AE0         baca_sensor();
	CALL _baca_sensor
; 0000 0AE1         while(sKa)
_0x2F4:
	SBRS R3,0
	RJMP _0x2F6
; 0000 0AE2         {
; 0000 0AE3                 maju();
	CALL SUBOPT_0x65
; 0000 0AE4                 displaySensorBit();
; 0000 0AE5                 scanBlackLine();
; 0000 0AE6         }
	RJMP _0x2F4
_0x2F6:
; 0000 0AE7         indikatorSudut();
	RCALL _indikatorSudut
; 0000 0AE8         while(!sKa)
_0x2F7:
	SBRC R3,0
	RJMP _0x2F9
; 0000 0AE9         {
; 0000 0AEA                 maju();
	CALL SUBOPT_0x65
; 0000 0AEB                 displaySensorBit();
; 0000 0AEC                 scanBlackLine();
; 0000 0AED         }
	RJMP _0x2F7
_0x2F9:
; 0000 0AEE         while(sKa)
_0x2FA:
	SBRS R3,0
	RJMP _0x2FC
; 0000 0AEF         {
; 0000 0AF0                 maju();
	CALL SUBOPT_0x65
; 0000 0AF1                 displaySensorBit();
; 0000 0AF2                 scanBlackLine();
; 0000 0AF3         }
	RJMP _0x2FA
_0x2FC:
; 0000 0AF4         indikatorSudut();
	CALL SUBOPT_0x6E
; 0000 0AF5 
; 0000 0AF6         // putar kiri
; 0000 0AF7         stop(10);
; 0000 0AF8         baca_sensor();
	CALL _baca_sensor
; 0000 0AF9         while(sKa)
_0x2FD:
	SBRS R3,0
	RJMP _0x2FF
; 0000 0AFA         {
; 0000 0AFB                 mundur();
	CALL SUBOPT_0x67
; 0000 0AFC                 lpwm = MINPWM;
; 0000 0AFD                 rpwm = MINPWM + 30;
; 0000 0AFE                 baca_sensor();
; 0000 0AFF         }
	RJMP _0x2FD
_0x2FF:
; 0000 0B00         /*while(sensor<255)
; 0000 0B01         {
; 0000 0B02                 rotkir();
; 0000 0B03                 lpwm = MINPWM;
; 0000 0B04                 rpwm = MINPWM;
; 0000 0B05                 baca_sensor();
; 0000 0B06         } */
; 0000 0B07         baca_sensor();
	CALL _baca_sensor
; 0000 0B08         while(s7)
_0x300:
	SBRS R2,7
	RJMP _0x302
; 0000 0B09         {
; 0000 0B0A                 rotkan();
	CALL SUBOPT_0x63
; 0000 0B0B                 lpwm = MINPWM;
; 0000 0B0C                 rpwm = MINPWM + 30;
	ADIW R30,30
	CALL SUBOPT_0x64
; 0000 0B0D                 baca_sensor();
; 0000 0B0E         }
	RJMP _0x300
_0x302:
; 0000 0B0F         baca_sensor();
	CALL _baca_sensor
; 0000 0B10         while(sKi)
_0x303:
	SBRS R3,1
	RJMP _0x305
; 0000 0B11         {
; 0000 0B12                 maju();
	CALL SUBOPT_0x65
; 0000 0B13                 displaySensorBit();
; 0000 0B14                 scanBlackLine();
; 0000 0B15         }
	RJMP _0x303
_0x305:
; 0000 0B16         baca_sensor();
	CALL _baca_sensor
; 0000 0B17         while(!sKi)
_0x306:
	SBRC R3,1
	RJMP _0x308
; 0000 0B18         {
; 0000 0B19                 maju();
	CALL SUBOPT_0x65
; 0000 0B1A                 displaySensorBit();
; 0000 0B1B                 scanBlackLine();
; 0000 0B1C         }
	RJMP _0x306
_0x308:
; 0000 0B1D         for(f=0;f<10;f++)
	LDI  R17,LOW(0)
_0x30A:
	CPI  R17,10
	BRSH _0x30B
; 0000 0B1E         {
; 0000 0B1F                 maju();
	CALL SUBOPT_0x65
; 0000 0B20                 displaySensorBit();
; 0000 0B21                 scanBlackLine();
; 0000 0B22         }
	SUBI R17,-1
	RJMP _0x30A
_0x30B:
; 0000 0B23         // done !
; 0000 0B24         indikatorSudut();
_0x2080009:
	RCALL _indikatorSudut
; 0000 0B25 }
_0x2080008:
	LD   R17,Y+
	RET
;
;void cekPoint4b(void)
; 0000 0B28 {
_cekPoint4b:
; 0000 0B29         //cek point 4
; 0000 0B2A         MINPWM = _MINPWM - 5;
	CALL SUBOPT_0x5F
	SBIW R30,5
	CALL SUBOPT_0x60
; 0000 0B2B         var_Kp = 17;
; 0000 0B2C         var_Ki = 0;
; 0000 0B2D         var_Kd = 11;
; 0000 0B2E 
; 0000 0B2F         cekpoint4:
_0x30C:
; 0000 0B30 
; 0000 0B31         maju();
	CALL SUBOPT_0x65
; 0000 0B32         displaySensorBit();
; 0000 0B33         scanBlackLine();
; 0000 0B34 
; 0000 0B35         if(!sKi)
	SBRC R3,1
	RJMP _0x30D
; 0000 0B36         {
; 0000 0B37                 stop(10);
	CALL SUBOPT_0x62
; 0000 0B38                 indikatorSudut();
	CALL SUBOPT_0x66
; 0000 0B39                 baca_sensor();
; 0000 0B3A                 while(sKi)
_0x30E:
	SBRS R3,1
	RJMP _0x310
; 0000 0B3B                 {
; 0000 0B3C                         mundur();
	CALL SUBOPT_0x67
; 0000 0B3D                         lpwm = MINPWM;
; 0000 0B3E                         rpwm = MINPWM + 30;
; 0000 0B3F                         baca_sensor();
; 0000 0B40                 }
	RJMP _0x30E
_0x310:
; 0000 0B41 
; 0000 0B42                 stop(10);
	CALL SUBOPT_0x62
; 0000 0B43 
; 0000 0B44                 baca_sensor();
	CALL _baca_sensor
; 0000 0B45                 while(sensor<255)
_0x311:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x313
; 0000 0B46                 {
; 0000 0B47                         baca_sensor();
	CALL _baca_sensor
; 0000 0B48                         lpwm = MINPWM;
	CALL SUBOPT_0x80
; 0000 0B49                         rpwm = MINPWM + 30;
	ADIW R30,30
	CALL SUBOPT_0x5B
; 0000 0B4A                         rotkir();
	CALL _rotkir
; 0000 0B4B                 }
	RJMP _0x311
_0x313:
; 0000 0B4C 
; 0000 0B4D                 baca_sensor();
	CALL _baca_sensor
; 0000 0B4E                 while(s4)
_0x314:
	SBRS R2,4
	RJMP _0x316
; 0000 0B4F                 {
; 0000 0B50                         baca_sensor();
	CALL _baca_sensor
; 0000 0B51                         lpwm = MINPWM;
	CALL SUBOPT_0x80
; 0000 0B52                         rpwm = MINPWM + 30;
	ADIW R30,30
	CALL SUBOPT_0x5B
; 0000 0B53                         rotkir();
	CALL _rotkir
; 0000 0B54                 }
	RJMP _0x314
_0x316:
; 0000 0B55 
; 0000 0B56                 stop(10);
	CALL SUBOPT_0x62
; 0000 0B57                 goto cekpoint41;
	RJMP _0x317
; 0000 0B58         }
; 0000 0B59         goto cekpoint4;
_0x30D:
	RJMP _0x30C
; 0000 0B5A 
; 0000 0B5B         cekpoint41:
_0x317:
; 0000 0B5C 
; 0000 0B5D         maju();
	CALL SUBOPT_0x65
; 0000 0B5E         displaySensorBit();
; 0000 0B5F         scanBlackLine();
; 0000 0B60 
; 0000 0B61         if(!sKa)
	SBRC R3,0
	RJMP _0x318
; 0000 0B62         {
; 0000 0B63                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 0B64                 //MINPWM = 100;
; 0000 0B65                 while(!sKa)
_0x319:
	SBRC R3,0
	RJMP _0x31B
; 0000 0B66                 {
; 0000 0B67                         maju();
	CALL SUBOPT_0x65
; 0000 0B68                         displaySensorBit();
; 0000 0B69                         scanBlackLine();
; 0000 0B6A                 }
	RJMP _0x319
_0x31B:
; 0000 0B6B                 goto cekpoint42;
	RJMP _0x31C
; 0000 0B6C         }
; 0000 0B6D 
; 0000 0B6E         goto cekpoint41;
_0x318:
	RJMP _0x317
; 0000 0B6F 
; 0000 0B70         cekpoint42:
_0x31C:
; 0000 0B71 
; 0000 0B72         maju();
	CALL SUBOPT_0x65
; 0000 0B73         displaySensorBit();
; 0000 0B74         scanBlackLine();
; 0000 0B75         if(!sKa)
	SBRC R3,0
	RJMP _0x31D
; 0000 0B76         {
; 0000 0B77                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 0B78                 //MINPWM = 110;
; 0000 0B79                 while(!sKa)
_0x31E:
	SBRC R3,0
	RJMP _0x320
; 0000 0B7A                 {
; 0000 0B7B                         maju();
	CALL SUBOPT_0x65
; 0000 0B7C                         displaySensorBit();
; 0000 0B7D                         scanBlackLine();
; 0000 0B7E                 }
	RJMP _0x31E
_0x320:
; 0000 0B7F                 goto cekpoint43;
	RJMP _0x321
; 0000 0B80         }
; 0000 0B81         goto cekpoint42;
_0x31D:
	RJMP _0x31C
; 0000 0B82 
; 0000 0B83         cekpoint43:
_0x321:
; 0000 0B84 
; 0000 0B85         //maju();
; 0000 0B86         displaySensorBit();
	CALL SUBOPT_0x61
; 0000 0B87         scanBlackLine();
; 0000 0B88         if(!sKa)
	SBRC R3,0
	RJMP _0x322
; 0000 0B89         {
; 0000 0B8A                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 0B8B                 //MINPWM = 120;
; 0000 0B8C                 while(!sKa)
_0x323:
	SBRC R3,0
	RJMP _0x325
; 0000 0B8D                 {
; 0000 0B8E                         maju();
	CALL SUBOPT_0x65
; 0000 0B8F                         displaySensorBit();
; 0000 0B90                         scanBlackLine();
; 0000 0B91                 }
	RJMP _0x323
_0x325:
; 0000 0B92                 goto cekpoint44;
	RJMP _0x326
; 0000 0B93         }
; 0000 0B94         goto cekpoint43;
_0x322:
	RJMP _0x321
; 0000 0B95 
; 0000 0B96         cekpoint44:
_0x326:
; 0000 0B97 
; 0000 0B98         maju();
	CALL SUBOPT_0x65
; 0000 0B99         displaySensorBit();
; 0000 0B9A         scanBlackLine();
; 0000 0B9B         if(!sKa)
	SBRC R3,0
	RJMP _0x327
; 0000 0B9C         {
; 0000 0B9D                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 0B9E                 //MINPWM = 130;
; 0000 0B9F                 while(!sKa)
_0x328:
	SBRC R3,0
	RJMP _0x32A
; 0000 0BA0                 {
; 0000 0BA1                         maju();
	CALL SUBOPT_0x65
; 0000 0BA2                         displaySensorBit();
; 0000 0BA3                         scanBlackLine();
; 0000 0BA4                 }
	RJMP _0x328
_0x32A:
; 0000 0BA5                 goto cekpoint45;
	RJMP _0x32B
; 0000 0BA6         }
; 0000 0BA7         goto cekpoint44;
_0x327:
	RJMP _0x326
; 0000 0BA8 
; 0000 0BA9         cekpoint45:
_0x32B:
; 0000 0BAA 
; 0000 0BAB         maju();
	CALL SUBOPT_0x65
; 0000 0BAC         displaySensorBit();
; 0000 0BAD         scanBlackLine();
; 0000 0BAE         if(!sKa)
	SBRC R3,0
	RJMP _0x32C
; 0000 0BAF         {
; 0000 0BB0                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 0BB1                 //MINPWM = 140;
; 0000 0BB2                 while(!sKa)
_0x32D:
	SBRC R3,0
	RJMP _0x32F
; 0000 0BB3                 {
; 0000 0BB4                         maju();
	CALL SUBOPT_0x65
; 0000 0BB5                         displaySensorBit();
; 0000 0BB6                         scanBlackLine();
; 0000 0BB7                 }
	RJMP _0x32D
_0x32F:
; 0000 0BB8                 goto cekpoint5;
	RJMP _0x330
; 0000 0BB9         }
; 0000 0BBA         goto cekpoint45;
_0x32C:
	RJMP _0x32B
; 0000 0BBB 
; 0000 0BBC         cekpoint5:
_0x330:
; 0000 0BBD         indikatorSudut();
_0x2080007:
	RCALL _indikatorSudut
; 0000 0BBE }
	RET
;
;void cekPoint5b(void)
; 0000 0BC1 {
_cekPoint5b:
; 0000 0BC2         //cek point 5
; 0000 0BC3         cekPoint5a();
	RCALL _cekPoint5a
; 0000 0BC4 }
	RET
;
;void cekPointFinalB(void)
; 0000 0BC7 {
; 0000 0BC8 }
;
;void strategiB(void)
; 0000 0BCB {
_strategiB:
; 0000 0BCC         if(NoStrategi < 2)      goto level_1b;
	CALL SUBOPT_0x75
	CPI  R30,LOW(0x2)
	BRLO _0x332
; 0000 0BCD         else if(NoStrategi < 3) goto level_2b;
	CALL SUBOPT_0x75
	CPI  R30,LOW(0x3)
	BRLO _0x335
; 0000 0BCE         else if(NoStrategi < 4) goto level_3b;
	CALL SUBOPT_0x75
	CPI  R30,LOW(0x4)
	BRSH _0x337
	RJMP _0x338
; 0000 0BCF         else if(NoStrategi < 5) goto level_4b;
_0x337:
	CALL SUBOPT_0x75
	CPI  R30,LOW(0x5)
	BRSH _0x33A
	RJMP _0x33B
; 0000 0BD0 
; 0000 0BD1         else if(NoStrategi < 6) goto level_5b;
_0x33A:
	CALL SUBOPT_0x75
	CPI  R30,LOW(0x6)
	BRSH _0x33D
	RJMP _0x33E
; 0000 0BD2         else                    goto level_6b;
_0x33D:
	RJMP _0x340
; 0000 0BD3 
; 0000 0BD4         level_1b:
_0x332:
; 0000 0BD5 
; 0000 0BD6         backlight = 1;
	CALL SUBOPT_0x76
; 0000 0BD7         NoStrategi = 1;
; 0000 0BD8         delay_ms(50);
; 0000 0BD9         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0BDA         lcd_gotoxy(0,0);
; 0000 0BDB         lcd_putsf(" Skenario-StartB");
	__POINTW1FN _0x0,788
	CALL SUBOPT_0x5
; 0000 0BDC         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0BDD         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 0BDE         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0BDF         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0BE0 
; 0000 0BE1         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x343
; 0000 0BE2         {
; 0000 0BE3                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0BE4                 goto level_6b;
	RJMP _0x340
; 0000 0BE5         }
; 0000 0BE6         if(!sw_down)
_0x343:
	SBIC 0x10,6
	RJMP _0x344
; 0000 0BE7         {
; 0000 0BE8                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0BE9                 goto level_2b;
	RJMP _0x335
; 0000 0BEA         }
; 0000 0BEB         if(!sw_ok)
_0x344:
	SBIC 0x10,5
	RJMP _0x345
; 0000 0BEC         {
; 0000 0BED                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0BEE                 backlight = 0;
	CBI  0x18,3
; 0000 0BEF 
; 0000 0BF0                 cekPointStartb();
	RCALL _cekPointStartb
; 0000 0BF1                 cekPoint1b();
	CALL SUBOPT_0x81
; 0000 0BF2                 cekPoint2b();
; 0000 0BF3                 cekPoint3b();
; 0000 0BF4                 cekPoint4b();
; 0000 0BF5                 cekPoint5b();
; 0000 0BF6 
; 0000 0BF7                 goto exit_strategi;
	RJMP _0x348
; 0000 0BF8         }
; 0000 0BF9         if(!sw_cancel)
_0x345:
	SBIC 0x10,3
	RJMP _0x349
; 0000 0BFA         {
; 0000 0BFB                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0BFC                 goto exit_strategi;
	RJMP _0x348
; 0000 0BFD         }
; 0000 0BFE 
; 0000 0BFF         goto level_1b;
_0x349:
	RJMP _0x332
; 0000 0C00 
; 0000 0C01         level_2b:
_0x335:
; 0000 0C02 
; 0000 0C03         backlight = 1;
	CALL SUBOPT_0x7A
; 0000 0C04         NoStrategi = 2;
; 0000 0C05         delay_ms(50);
; 0000 0C06         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0C07         lcd_gotoxy(0,0);
; 0000 0C08         lcd_putsf("  Skenario-1B");
	__POINTW1FN _0x0,805
	CALL SUBOPT_0x5
; 0000 0C09         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0C0A         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 0C0B         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0C0C         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0C0D 
; 0000 0C0E         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x34C
; 0000 0C0F         {
; 0000 0C10                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C11                 goto level_1b;
	RJMP _0x332
; 0000 0C12         }
; 0000 0C13         if(!sw_down)
_0x34C:
	SBIC 0x10,6
	RJMP _0x34D
; 0000 0C14         {
; 0000 0C15                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C16                 goto level_3b;
	RJMP _0x338
; 0000 0C17         }
; 0000 0C18          if(!sw_ok)
_0x34D:
	SBIC 0x10,5
	RJMP _0x34E
; 0000 0C19         {
; 0000 0C1A                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C1B                 backlight = 0;
	CBI  0x18,3
; 0000 0C1C 
; 0000 0C1D                 cekPoint1b();
	CALL SUBOPT_0x81
; 0000 0C1E                 cekPoint2b();
; 0000 0C1F                 cekPoint3b();
; 0000 0C20                 cekPoint4b();
; 0000 0C21                 cekPoint5b();
; 0000 0C22 
; 0000 0C23                 goto exit_strategi;
	RJMP _0x348
; 0000 0C24         }
; 0000 0C25         if(!sw_cancel)
_0x34E:
	SBIC 0x10,3
	RJMP _0x351
; 0000 0C26         {
; 0000 0C27                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C28                 goto exit_strategi;
	RJMP _0x348
; 0000 0C29         }
; 0000 0C2A         goto level_2b;
_0x351:
	RJMP _0x335
; 0000 0C2B 
; 0000 0C2C         level_3b:
_0x338:
; 0000 0C2D 
; 0000 0C2E         backlight = 1;
	CALL SUBOPT_0x7B
; 0000 0C2F         NoStrategi = 3;
; 0000 0C30         delay_ms(50);
; 0000 0C31         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0C32         lcd_gotoxy(0,0);
; 0000 0C33         lcd_putsf("  Skenario-2B");
	__POINTW1FN _0x0,819
	CALL SUBOPT_0x5
; 0000 0C34         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0C35         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 0C36         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0C37         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0C38 
; 0000 0C39         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x354
; 0000 0C3A         {
; 0000 0C3B                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C3C                 goto level_2b;
	RJMP _0x335
; 0000 0C3D         }
; 0000 0C3E         if(!sw_down)
_0x354:
	SBIC 0x10,6
	RJMP _0x355
; 0000 0C3F         {
; 0000 0C40                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C41                 goto level_4b;
	RJMP _0x33B
; 0000 0C42         }
; 0000 0C43          if(!sw_ok)
_0x355:
	SBIC 0x10,5
	RJMP _0x356
; 0000 0C44         {
; 0000 0C45                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C46                 backlight = 0;
	CBI  0x18,3
; 0000 0C47 
; 0000 0C48                 cekPoint2b();
	RCALL _cekPoint2b
; 0000 0C49                 cekPoint3b();
	CALL SUBOPT_0x82
; 0000 0C4A                 cekPoint4b();
; 0000 0C4B                 cekPoint5b();
; 0000 0C4C 
; 0000 0C4D                 goto exit_strategi;
	RJMP _0x348
; 0000 0C4E         }
; 0000 0C4F         if(!sw_cancel)
_0x356:
	SBIC 0x10,3
	RJMP _0x359
; 0000 0C50         {
; 0000 0C51                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C52                 goto exit_strategi;
	RJMP _0x348
; 0000 0C53         }
; 0000 0C54         goto level_3b;
_0x359:
	RJMP _0x338
; 0000 0C55 
; 0000 0C56         level_4b:
_0x33B:
; 0000 0C57 
; 0000 0C58         backlight = 1;
	CALL SUBOPT_0x7D
; 0000 0C59         NoStrategi = 4;
; 0000 0C5A         delay_ms(50);
; 0000 0C5B         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0C5C         lcd_gotoxy(0,0);
; 0000 0C5D         lcd_putsf("  Skenario-3B");
	__POINTW1FN _0x0,833
	CALL SUBOPT_0x5
; 0000 0C5E         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0C5F         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 0C60         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0C61         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0C62 
; 0000 0C63         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x35C
; 0000 0C64         {
; 0000 0C65                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C66                 goto level_3b;
	RJMP _0x338
; 0000 0C67         }
; 0000 0C68         if(!sw_down)
_0x35C:
	SBIC 0x10,6
	RJMP _0x35D
; 0000 0C69         {
; 0000 0C6A                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C6B                 goto level_5b;
	RJMP _0x33E
; 0000 0C6C         }
; 0000 0C6D          if(!sw_ok)
_0x35D:
	SBIC 0x10,5
	RJMP _0x35E
; 0000 0C6E         {
; 0000 0C6F                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C70                 backlight = 0;
	CBI  0x18,3
; 0000 0C71 
; 0000 0C72                 cekPoint3b();
	CALL SUBOPT_0x82
; 0000 0C73                 cekPoint4b();
; 0000 0C74                 cekPoint5b();
; 0000 0C75 
; 0000 0C76                 goto exit_strategi;
	RJMP _0x348
; 0000 0C77         }
; 0000 0C78         if(!sw_cancel)
_0x35E:
	SBIC 0x10,3
	RJMP _0x361
; 0000 0C79         {
; 0000 0C7A                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C7B                 goto exit_strategi;
	RJMP _0x348
; 0000 0C7C         }
; 0000 0C7D         goto level_4b;
_0x361:
	RJMP _0x33B
; 0000 0C7E 
; 0000 0C7F         level_5b:
_0x33E:
; 0000 0C80 
; 0000 0C81         backlight = 1;
	CALL SUBOPT_0x7E
; 0000 0C82         NoStrategi = 5;
; 0000 0C83         delay_ms(50);
; 0000 0C84         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0C85         lcd_gotoxy(0,0);
; 0000 0C86         lcd_putsf("  Skenario-4B");
	__POINTW1FN _0x0,847
	CALL SUBOPT_0x5
; 0000 0C87         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0C88         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 0C89         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0C8A         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0C8B 
; 0000 0C8C         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x364
; 0000 0C8D         {
; 0000 0C8E                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C8F                 goto level_4b;
	RJMP _0x33B
; 0000 0C90         }
; 0000 0C91         if(!sw_down)
_0x364:
	SBIC 0x10,6
	RJMP _0x365
; 0000 0C92         {
; 0000 0C93                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C94                 goto level_6b;
	RJMP _0x340
; 0000 0C95         }
; 0000 0C96          if(!sw_ok)
_0x365:
	SBIC 0x10,5
	RJMP _0x366
; 0000 0C97         {
; 0000 0C98                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0C99                 backlight = 0;
	CBI  0x18,3
; 0000 0C9A 
; 0000 0C9B                 cekPoint4b();
	RCALL _cekPoint4b
; 0000 0C9C                 cekPoint5b();
	RCALL _cekPoint5b
; 0000 0C9D 
; 0000 0C9E                 goto exit_strategi;
	RJMP _0x348
; 0000 0C9F         }
; 0000 0CA0         if(!sw_cancel)
_0x366:
	SBIC 0x10,3
	RJMP _0x369
; 0000 0CA1         {
; 0000 0CA2                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0CA3                 goto exit_strategi;
	RJMP _0x348
; 0000 0CA4         }
; 0000 0CA5         goto level_5b;
_0x369:
	RJMP _0x33E
; 0000 0CA6 
; 0000 0CA7         level_6b:
_0x340:
; 0000 0CA8 
; 0000 0CA9         backlight = 1;
	CALL SUBOPT_0x7F
; 0000 0CAA         NoStrategi = 6;
; 0000 0CAB         delay_ms(50);
; 0000 0CAC         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0CAD         lcd_gotoxy(0,0);
; 0000 0CAE         lcd_putsf("  Skenario-5B");
	__POINTW1FN _0x0,861
	CALL SUBOPT_0x5
; 0000 0CAF         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0CB0         lcd_putsf("  OK ?");
	CALL SUBOPT_0x77
; 0000 0CB1         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0CB2         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0CB3 
; 0000 0CB4         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x36C
; 0000 0CB5         {
; 0000 0CB6                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0CB7                 goto level_5b;
	RJMP _0x33E
; 0000 0CB8         }
; 0000 0CB9         if(!sw_down)
_0x36C:
	SBIC 0x10,6
	RJMP _0x36D
; 0000 0CBA         {
; 0000 0CBB                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0CBC                 goto level_1b;
	RJMP _0x332
; 0000 0CBD         }
; 0000 0CBE          if(!sw_ok)
_0x36D:
	SBIC 0x10,5
	RJMP _0x36E
; 0000 0CBF         {
; 0000 0CC0                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0CC1                 backlight = 0;
	CBI  0x18,3
; 0000 0CC2 
; 0000 0CC3                 cekPoint5b();
	RCALL _cekPoint5b
; 0000 0CC4 
; 0000 0CC5                 goto exit_strategi;
	RJMP _0x348
; 0000 0CC6         }
; 0000 0CC7         if(!sw_cancel)
_0x36E:
	SBIC 0x10,3
	RJMP _0x371
; 0000 0CC8         {
; 0000 0CC9                 delay_ms(250);
	CALL SUBOPT_0x78
; 0000 0CCA                 goto exit_strategi;
	RJMP _0x348
; 0000 0CCB         }
; 0000 0CCC         goto level_6b;
_0x371:
	RJMP _0x340
; 0000 0CCD 
; 0000 0CCE         exit_strategi:
_0x348:
; 0000 0CCF         lcd_clear();
	CALL _lcd_clear
; 0000 0CD0         backlight = 0;
	RJMP _0x2080006
; 0000 0CD1 }
;
;////////////////////////////////////////
;
;void indikatorSudut(void)
; 0000 0CD6 {
_indikatorSudut:
; 0000 0CD7         backlight = 1;
	RJMP _0x2080005
; 0000 0CD8         delay_ms(100);
; 0000 0CD9         backlight = 0;
; 0000 0CDA }
;
;void indikatorPerempatan(void)
; 0000 0CDD {
_indikatorPerempatan:
; 0000 0CDE         backlight = 1;
	SBI  0x18,3
; 0000 0CDF         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x52
; 0000 0CE0         backlight = 0;
	CBI  0x18,3
; 0000 0CE1         delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0CE2         backlight = 1;
_0x2080005:
	SBI  0x18,3
; 0000 0CE3         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x52
; 0000 0CE4         backlight = 0;
_0x2080006:
	CBI  0x18,3
; 0000 0CE5 }
	RET
;
;/////////////////////////////////////
;
;void main(void)
; 0000 0CEA {
_main:
; 0000 0CEB         PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0CEC         DDRA=0x00;
	OUT  0x1A,R30
; 0000 0CED         PORTB=0x00;
	OUT  0x18,R30
; 0000 0CEE         DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0CEF         PORTC=0x03;
	LDI  R30,LOW(3)
	OUT  0x15,R30
; 0000 0CF0         DDRC=0xFC;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0000 0CF1         PORTD=0x78;
	LDI  R30,LOW(120)
	OUT  0x12,R30
; 0000 0CF2         DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0CF3 
; 0000 0CF4         TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0CF5         TCNT0=0xFF;
	LDI  R30,LOW(255)
	OUT  0x32,R30
; 0000 0CF6         OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0CF7 
; 0000 0CF8         TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0CF9 
; 0000 0CFA         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0CFB         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0CFC 
; 0000 0CFD         ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0CFE         ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0CFF 
; 0000 0D00         lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0D01         define_char(char0,0);
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _define_char
; 0000 0D02 
; 0000 0D03         indikatorSudut();
	RCALL _indikatorSudut
; 0000 0D04         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x52
; 0000 0D05         backlight = 1;
	SBI  0x18,3
; 0000 0D06 
; 0000 0D07         stop(1);
	CALL SUBOPT_0x83
; 0000 0D08         TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0D09 
; 0000 0D0A         showMenu();
	CALL _showMenu
; 0000 0D0B         backlight = 0;
	CBI  0x18,3
; 0000 0D0C         #asm("sei")
	sei
; 0000 0D0D 
; 0000 0D0E         var_Kp  = Kp;
	CALL SUBOPT_0xF
	LDI  R31,0
	CALL SUBOPT_0x72
; 0000 0D0F         var_Ki  = Ki;
	CALL SUBOPT_0x11
	LDI  R31,0
	CALL SUBOPT_0x73
; 0000 0D10         var_Kd  = Kd;
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL SUBOPT_0x84
	CALL SUBOPT_0x74
; 0000 0D11 
; 0000 0D12         tempKp = Kp;
	CALL SUBOPT_0xF
	LDI  R26,LOW(_tempKp)
	LDI  R27,HIGH(_tempKp)
	CALL __EEPROMWRB
; 0000 0D13         tempKd = Ki;
	CALL SUBOPT_0x11
	LDI  R26,LOW(_tempKd)
	LDI  R27,HIGH(_tempKd)
	CALL __EEPROMWRB
; 0000 0D14         tempKi = Ki;
	CALL SUBOPT_0x11
	LDI  R26,LOW(_tempKi)
	LDI  R27,HIGH(_tempKi)
	CALL __EEPROMWRB
; 0000 0D15 
; 0000 0D16         MAXPWM = (int)MAXSpeed;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL SUBOPT_0x84
	STS  _MAXPWM,R30
	STS  _MAXPWM+1,R31
; 0000 0D17         _MINPWM = MINSpeed;
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x84
	STS  __MINPWM,R30
	STS  __MINPWM+1,R31
; 0000 0D18         MINPWM = _MINPWM;
	CALL SUBOPT_0x71
; 0000 0D19 
; 0000 0D1A         intervalPWM = (MAXSpeed - MINSpeed) / 8;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL __EEPROMRDB
	MOV  R0,R30
	CLR  R1
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x84
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	CALL SUBOPT_0x5A
; 0000 0D1B         PV = 0;
	LDI  R30,LOW(0)
	STS  _PV,R30
	STS  _PV+1,R30
; 0000 0D1C         error = 0;
	STS  _error,R30
	STS  _error+1,R30
; 0000 0D1D         last_error = 0;
	STS  _last_error,R30
	STS  _last_error+1,R30
; 0000 0D1E 
; 0000 0D1F         delay_ms(200);
	CALL SUBOPT_0x7
; 0000 0D20         indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 0D21 
; 0000 0D22         maju();
	CALL _maju
; 0000 0D23 
; 0000 0D24         while (1)
_0x384:
; 0000 0D25         {
; 0000 0D26                 displaySensorBit();
	CALL SUBOPT_0x61
; 0000 0D27                 scanBlackLine();
; 0000 0D28                 //scanSudut();
; 0000 0D29 
; 0000 0D2A                 // strategi track A
; 0000 0D2B                 if(!sw_up)      // interupsi
	SBIC 0x10,4
	RJMP _0x387
; 0000 0D2C                 {
; 0000 0D2D                         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0D2E                         stop(1);
	CALL SUBOPT_0x83
; 0000 0D2F                         lcd_clear();
	CALL _lcd_clear
; 0000 0D30                         strategiA();
	RCALL _strategiA
; 0000 0D31                         goto exitRobot;
	RJMP _0x388
; 0000 0D32                 }
; 0000 0D33 
; 0000 0D34                 // strategi track B
; 0000 0D35                 if(!sw_down)    // interupsi
_0x387:
	SBIC 0x10,6
	RJMP _0x389
; 0000 0D36                 {
; 0000 0D37                         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0D38                         stop(1);
	CALL SUBOPT_0x83
; 0000 0D39                         lcd_clear();
	CALL _lcd_clear
; 0000 0D3A                         strategiB();
	RCALL _strategiB
; 0000 0D3B                         goto exitRobot;
	RJMP _0x388
; 0000 0D3C                 }
; 0000 0D3D 
; 0000 0D3E                 // percobaan counting
; 0000 0D3F                 while(!sKi)
_0x389:
_0x38A:
	SBRC R3,1
	RJMP _0x38C
; 0000 0D40                 {
; 0000 0D41                         displaySensorBit();
	CALL SUBOPT_0x61
; 0000 0D42                         scanBlackLine();
; 0000 0D43                         backlight = 1;
	SBI  0x18,3
; 0000 0D44                 }
	RJMP _0x38A
_0x38C:
; 0000 0D45 
; 0000 0D46                 while(!sKa)
_0x38F:
	SBRC R3,0
	RJMP _0x391
; 0000 0D47                 {
; 0000 0D48                         displaySensorBit();
	CALL SUBOPT_0x61
; 0000 0D49                         scanBlackLine();
; 0000 0D4A                         backlight = 1;
	SBI  0x18,3
; 0000 0D4B                 }
	RJMP _0x38F
_0x391:
; 0000 0D4C                 backlight = 0;
	CBI  0x18,3
; 0000 0D4D         };
	RJMP _0x384
; 0000 0D4E 
; 0000 0D4F         var_Kp = tempKp;
; 0000 0D50         var_Ki = tempKi;
; 0000 0D51         var_Kd = tempKd;
; 0000 0D52 
; 0000 0D53         exitRobot:
_0x388:
; 0000 0D54         goto exitRobot;
	RJMP _0x388
; 0000 0D55 }
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
_put_buff_G100:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2000010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2000012
	__CPWRN 16,17,2
	BRLO _0x2000013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2000012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL SUBOPT_0x30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x30
_0x2000014:
_0x2000013:
	RJMP _0x2000015
_0x2000010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2000015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G100:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2000016:
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
	JMP _0x2000018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x200001C
	CPI  R18,37
	BRNE _0x200001D
	LDI  R17,LOW(1)
	RJMP _0x200001E
_0x200001D:
	CALL SUBOPT_0x85
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x85
	RJMP _0x20000C9
_0x2000020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2000021
	LDI  R16,LOW(1)
	RJMP _0x200001B
_0x2000021:
	CPI  R18,43
	BRNE _0x2000022
	LDI  R20,LOW(43)
	RJMP _0x200001B
_0x2000022:
	CPI  R18,32
	BRNE _0x2000023
	LDI  R20,LOW(32)
	RJMP _0x200001B
_0x2000023:
	RJMP _0x2000024
_0x200001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2000025
_0x2000024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2000026
	ORI  R16,LOW(128)
	RJMP _0x200001B
_0x2000026:
	RJMP _0x2000027
_0x2000025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x200001B
_0x2000027:
	CPI  R18,48
	BRLO _0x200002A
	CPI  R18,58
	BRLO _0x200002B
_0x200002A:
	RJMP _0x2000029
_0x200002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x200001B
_0x2000029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x200002F
	CALL SUBOPT_0x86
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x87
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x86
	CALL SUBOPT_0x88
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x86
	CALL SUBOPT_0x88
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2000033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2000036
_0x2000035:
	CPI  R30,LOW(0x64)
	BREQ _0x2000039
	CPI  R30,LOW(0x69)
	BRNE _0x200003A
_0x2000039:
	ORI  R16,LOW(4)
	RJMP _0x200003B
_0x200003A:
	CPI  R30,LOW(0x75)
	BRNE _0x200003C
_0x200003B:
	LDI  R30,LOW(_tbl10_G100*2)
	LDI  R31,HIGH(_tbl10_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x200003D
_0x200003C:
	CPI  R30,LOW(0x58)
	BRNE _0x200003F
	ORI  R16,LOW(8)
	RJMP _0x2000040
_0x200003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2000071
_0x2000040:
	LDI  R30,LOW(_tbl16_G100*2)
	LDI  R31,HIGH(_tbl16_G100*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x200003D:
	SBRS R16,2
	RJMP _0x2000042
	CALL SUBOPT_0x86
	CALL SUBOPT_0x89
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2000043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2000043:
	CPI  R20,0
	BREQ _0x2000044
	SUBI R17,-LOW(1)
	RJMP _0x2000045
_0x2000044:
	ANDI R16,LOW(251)
_0x2000045:
	RJMP _0x2000046
_0x2000042:
	CALL SUBOPT_0x86
	CALL SUBOPT_0x89
_0x2000046:
_0x2000036:
	SBRC R16,0
	RJMP _0x2000047
_0x2000048:
	CP   R17,R21
	BRSH _0x200004A
	SBRS R16,7
	RJMP _0x200004B
	SBRS R16,2
	RJMP _0x200004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x200004D
_0x200004C:
	LDI  R18,LOW(48)
_0x200004D:
	RJMP _0x200004E
_0x200004B:
	LDI  R18,LOW(32)
_0x200004E:
	CALL SUBOPT_0x85
	SUBI R21,LOW(1)
	RJMP _0x2000048
_0x200004A:
_0x2000047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x200004F
_0x2000050:
	CPI  R19,0
	BREQ _0x2000052
	SBRS R16,3
	RJMP _0x2000053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2000054
_0x2000053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2000054:
	CALL SUBOPT_0x85
	CPI  R21,0
	BREQ _0x2000055
	SUBI R21,LOW(1)
_0x2000055:
	SUBI R19,LOW(1)
	RJMP _0x2000050
_0x2000052:
	RJMP _0x2000056
_0x200004F:
_0x2000058:
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
_0x200005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x200005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x200005A
_0x200005C:
	CPI  R18,58
	BRLO _0x200005D
	SBRS R16,3
	RJMP _0x200005E
	SUBI R18,-LOW(7)
	RJMP _0x200005F
_0x200005E:
	SUBI R18,-LOW(39)
_0x200005F:
_0x200005D:
	SBRC R16,4
	RJMP _0x2000061
	CPI  R18,49
	BRSH _0x2000063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2000062
_0x2000063:
	RJMP _0x20000CA
_0x2000062:
	CP   R21,R19
	BRLO _0x2000067
	SBRS R16,0
	RJMP _0x2000068
_0x2000067:
	RJMP _0x2000066
_0x2000068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2000069
	LDI  R18,LOW(48)
_0x20000CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x200006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x87
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x85
	CPI  R21,0
	BREQ _0x200006C
	SUBI R21,LOW(1)
_0x200006C:
_0x2000066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2000059
	RJMP _0x2000058
_0x2000059:
_0x2000056:
	SBRS R16,0
	RJMP _0x200006D
_0x200006E:
	CPI  R21,0
	BREQ _0x2000070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0x87
	RJMP _0x200006E
_0x2000070:
_0x200006D:
_0x2000071:
_0x2000030:
_0x20000C9:
	LDI  R17,LOW(0)
_0x200001B:
	RJMP _0x2000016
_0x2000018:
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	CALL __GETW1P
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,6
	CALL __SAVELOCR4
	CALL SUBOPT_0x8A
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080004
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x8A
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
	LDI  R30,LOW(_put_buff_G100)
	LDI  R31,HIGH(_put_buff_G100)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G100
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x2080004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
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

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x18,4
	RJMP _0x2020005
_0x2020004:
	CBI  0x18,4
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x18,5
	RJMP _0x2020007
_0x2020006:
	CBI  0x18,5
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x18,6
	RJMP _0x2020009
_0x2020008:
	CBI  0x18,6
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x18,7
	RJMP _0x202000B
_0x202000A:
	CBI  0x18,7
_0x202000B:
	__DELAY_USB 8
	SBI  0x18,2
	__DELAY_USB 20
	CBI  0x18,2
	__DELAY_USB 20
	RJMP _0x2080001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USB 200
	RJMP _0x2080001
_lcd_write_byte:
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL __lcd_write_data
	CALL SUBOPT_0x8B
	RJMP _0x2080003
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080003:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x8C
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x8C
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x2080001
_0x2020013:
_0x2020010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	CALL SUBOPT_0x8B
	RJMP _0x2080001
_lcd_puts:
	ST   -Y,R17
_0x2020014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020014
_0x2020016:
	RJMP _0x2080002
_lcd_putsf:
	ST   -Y,R17
_0x2020017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020017
_0x2020019:
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,6
	SBI  0x17,7
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x52
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8D
	CALL SUBOPT_0x8D
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 300
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
_0x2080001:
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
_lcd:
	.BYTE 0x20
_adc6:
	.BYTE 0x1
_adc7:
	.BYTE 0x1
_xcount:
	.BYTE 0x1
_SP:
	.BYTE 0x1
_lpwm:
	.BYTE 0x2
_rpwm:
	.BYTE 0x2
_MAXPWM:
	.BYTE 0x2
_MINPWM:
	.BYTE 0x2
__MINPWM:
	.BYTE 0x2
_intervalPWM:
	.BYTE 0x2
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

	.ESEG
_Kp:
	.DB  0x11
_Ki:
	.DB  0x0
_Kd:
	.DB  0xB
_tempKp:
	.DB  0x11
_tempKi:
	.DB  0x0
_tempKd:
	.DB  0xB
_MAXSpeed:
	.DB  0xFF
_MINSpeed:
	.DB  0x73
_WarnaGaris:
	.DB  0x1
_SensLine:
	.DB  0x2
_Skenario:
	.DB  0x2
_Mode:
	.DB  0x1
_NoStrategi:
	.DB  0x1
_bt7:
	.DB  0x7
_bt6:
	.DB  0x7
_bt5:
	.DB  0x7
_bt4:
	.DB  0x7
_bt3:
	.DB  0x7
_bt2:
	.DB  0x7
_bt1:
	.DB  0x7
_bt0:
	.DB  0x7
_ba7:
	.DB  0x7
_ba6:
	.DB  0x7
_ba5:
	.DB  0x7
_ba4:
	.DB  0x7
_ba3:
	.DB  0x7
_ba2:
	.DB  0x7
_ba1:
	.DB  0x7
_ba0:
	.DB  0x7
_bb7:
	.DB  0xC8
_bb6:
	.DB  0xC8
_bb5:
	.DB  0xC8
_bb4:
	.DB  0xC8
_bb3:
	.DB  0xC8
_bb2:
	.DB  0xC8
_bb1:
	.DB  0xC8
_bb0:
	.DB  0xC8

	.DSEG
__base_y_G101:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDS  R30,_lpwm
	LDS  R31,_lpwm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDS  R26,_xcount
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	LDS  R30,_rpwm
	LDS  R31,_rpwm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	CALL __DIVW21
	MOV  R17,R30
	SUBI R17,-LOW(48)
	ST   -Y,R17
	CALL _lcd_putchar
	LDD  R26,Y+1
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:193 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 72 TIMES, CODE SIZE REDUCTION:139 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x6:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x8:
	CALL _lcd_clear
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:113 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(32)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	ST   -Y,R30
	CALL _tampil
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL __EEPROMRDB
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	CALL _setByte
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x15:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	__POINTW1FN _0x0,377
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x18:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:114 WORDS
SUBOPT_0x1B:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(7)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(6)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(5)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(_bt2)
	LDI  R27,HIGH(_bt2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDI  R26,LOW(_bt3)
	LDI  R27,HIGH(_bt3)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(_bt4)
	LDI  R27,HIGH(_bt4)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(_bt5)
	LDI  R27,HIGH(_bt5)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(_bt6)
	LDI  R27,HIGH(_bt6)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDI  R26,LOW(_bt7)
	LDI  R27,HIGH(_bt7)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(0)
	STS  _lpwm,R30
	STS  _lpwm+1,R30
	STS  _rpwm,R30
	STS  _rpwm+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x30:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x31:
	__POINTW1FN _0x0,489
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x0
	CALL __CWD1
	CALL __PUTPARD1
	RCALL SUBOPT_0x2
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x32:
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(_ba7)
	LDI  R27,HIGH(_ba7)
	LDI  R30,LOW(7)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba6)
	LDI  R27,HIGH(_ba6)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba5)
	LDI  R27,HIGH(_ba5)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba4)
	LDI  R27,HIGH(_ba4)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba3)
	LDI  R27,HIGH(_ba3)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba2)
	LDI  R27,HIGH(_ba2)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba1)
	LDI  R27,HIGH(_ba1)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba0)
	LDI  R27,HIGH(_ba0)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb7)
	LDI  R27,HIGH(_bb7)
	LDI  R30,LOW(200)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb6)
	LDI  R27,HIGH(_bb6)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb5)
	LDI  R27,HIGH(_bb5)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb4)
	LDI  R27,HIGH(_bb4)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb3)
	LDI  R27,HIGH(_bb3)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb2)
	LDI  R27,HIGH(_bb2)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb1)
	LDI  R27,HIGH(_bb1)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb0)
	LDI  R27,HIGH(_bb0)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x33:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb0)
	LDI  R27,HIGH(_bb0)
	CALL __EEPROMRDB
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x34:
	LDI  R26,LOW(_ba0)
	LDI  R27,HIGH(_ba0)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x35:
	MOVW R26,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	LDI  R26,LOW(_bb0)
	LDI  R27,HIGH(_bb0)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0x37:
	LDI  R31,0
	MOVW R26,R0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x38:
	CALL __EEPROMWRB
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x39:
	__POINTW1FN _0x0,528
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3A:
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	CALL _lcd_puts
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb1)
	LDI  R27,HIGH(_bb1)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3D:
	LDI  R26,LOW(_ba1)
	LDI  R27,HIGH(_ba1)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	LDI  R26,LOW(_bb1)
	LDI  R27,HIGH(_bb1)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3F:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb2)
	LDI  R27,HIGH(_bb2)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	LDI  R26,LOW(_ba2)
	LDI  R27,HIGH(_ba2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	LDI  R26,LOW(_bb2)
	LDI  R27,HIGH(_bb2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x42:
	CALL _lcd_puts
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb3)
	LDI  R27,HIGH(_bb3)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x44:
	LDI  R26,LOW(_ba3)
	LDI  R27,HIGH(_ba3)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	LDI  R26,LOW(_bb3)
	LDI  R27,HIGH(_bb3)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb4)
	LDI  R27,HIGH(_bb4)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x47:
	LDI  R26,LOW(_ba4)
	LDI  R27,HIGH(_ba4)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	LDI  R26,LOW(_bb4)
	LDI  R27,HIGH(_bb4)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x49:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb5)
	LDI  R27,HIGH(_bb5)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4A:
	LDI  R26,LOW(_ba5)
	LDI  R27,HIGH(_ba5)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	LDI  R26,LOW(_bb5)
	LDI  R27,HIGH(_bb5)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb6)
	LDI  R27,HIGH(_bb6)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4D:
	LDI  R26,LOW(_ba6)
	LDI  R27,HIGH(_ba6)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	LDI  R26,LOW(_bb6)
	LDI  R27,HIGH(_bb6)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4F:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb7)
	LDI  R27,HIGH(_bb7)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x35

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x50:
	LDI  R26,LOW(_ba7)
	LDI  R27,HIGH(_ba7)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	LDI  R26,LOW(_bb7)
	LDI  R27,HIGH(_bb7)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 58 TIMES, CODE SIZE REDUCTION:111 WORDS
SUBOPT_0x52:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x53:
	STS  _PV,R30
	STS  _PV+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 83 TIMES, CODE SIZE REDUCTION:161 WORDS
SUBOPT_0x54:
	LDS  R30,_MINPWM
	LDS  R31,_MINPWM+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x55:
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RCALL SUBOPT_0x54
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x56:
	LDS  R26,_PV
	LDS  R27,_PV+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	LDS  R30,_error
	LDS  R31,_error+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x58:
	CALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	LDS  R26,_MINPWM
	LDS  R27,_MINPWM+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5A:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	STS  _intervalPWM,R30
	STS  _intervalPWM+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 42 TIMES, CODE SIZE REDUCTION:79 WORDS
SUBOPT_0x5B:
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5C:
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x5D:
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x5E:
	LDS  R26,_MAXPWM
	LDS  R27,_MAXPWM+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x5F:
	LDS  R30,__MINPWM
	LDS  R31,__MINPWM+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:92 WORDS
SUBOPT_0x60:
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
	LDI  R30,LOW(0)
	STS  _var_Ki,R30
	STS  _var_Ki+1,R30
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 68 TIMES, CODE SIZE REDUCTION:131 WORDS
SUBOPT_0x61:
	CALL _displaySensorBit
	JMP  _scanBlackLine

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x62:
	LDI  R30,LOW(10)
	ST   -Y,R30
	JMP  _stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x63:
	CALL _rotkan
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x5D
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0x64:
	RCALL SUBOPT_0x5B
	JMP  _baca_sensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:95 WORDS
SUBOPT_0x65:
	CALL _maju
	RJMP SUBOPT_0x61

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x66:
	CALL _indikatorSudut
	JMP  _baca_sensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:96 WORDS
SUBOPT_0x67:
	CALL _mundur
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x54
	ADIW R30,30
	RJMP SUBOPT_0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x68:
	CALL _rotkir
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x54
	ADIW R30,30
	RJMP SUBOPT_0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x69:
	CALL __SAVELOCR4
	RCALL SUBOPT_0x5F
	SBIW R30,15
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
	LDI  R30,LOW(0)
	STS  _var_Ki,R30
	STS  _var_Ki+1,R30
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
	JMP  _maju

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x6A:
	CALL _indikatorSudut
	__GETWRMN 16,17,0,_lpwm
	__GETWRMN 18,19,0,_rpwm
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x54
	ADIW R30,30
	RJMP SUBOPT_0x5B

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6B:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x6C:
	LDI  R30,LOW(5)
	ST   -Y,R30
	CALL _stop
	CALL _maju
	RCALL SUBOPT_0x5F
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
	__PUTWMRN _lpwm,0,16,17
	__PUTWMRN _rpwm,0,18,19
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x6D:
	ST   -Y,R17
	RCALL SUBOPT_0x5F
	SBIW R30,13
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
	LDI  R30,LOW(0)
	STS  _var_Ki,R30
	STS  _var_Ki+1,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
	JMP  _maju

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6E:
	CALL _indikatorSudut
	RJMP SUBOPT_0x62

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6F:
	CALL _bkan
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x54
	ADIW R30,30
	RJMP SUBOPT_0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x70:
	CALL _baca_sensor
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x54
	ADIW R30,30
	RCALL SUBOPT_0x5B
	JMP  _rotkan

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	RCALL SUBOPT_0x5F
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x73:
	STS  _var_Ki,R30
	STS  _var_Ki+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x74:
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x75:
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x76:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x6B

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x77:
	__POINTW1FN _0x0,711
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 36 TIMES, CODE SIZE REDUCTION:67 WORDS
SUBOPT_0x78:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x79:
	CALL _cekPoint1a
	CALL _cekPoint2a
	CALL _cekPoint3a
	CALL _cekPoint4a
	JMP  _cekPoint5a

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7A:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(2)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x6B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7B:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(3)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x6B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7C:
	CALL _cekPoint3a
	CALL _cekPoint4a
	JMP  _cekPoint5a

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7D:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(4)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x6B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7E:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(5)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x6B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7F:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(6)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x6B

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x80:
	RCALL SUBOPT_0x54
	RCALL SUBOPT_0x5D
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x81:
	CALL _cekPoint1b
	CALL _cekPoint2b
	CALL _cekPoint3b
	CALL _cekPoint4b
	JMP  _cekPoint5b

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x82:
	CALL _cekPoint3b
	CALL _cekPoint4b
	JMP  _cekPoint5b

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x83:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x84:
	CALL __EEPROMRDB
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x85:
	ST   -Y,R18
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x86:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x87:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x88:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x89:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8A:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8B:
	SBI  0x18,0
	LD   R30,Y
	ST   -Y,R30
	CALL __lcd_write_data
	CBI  0x18,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8C:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x52

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8D:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G101
	__DELAY_USW 300
	RET


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

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

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

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
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
