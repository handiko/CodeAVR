
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
	.DEF _s0=R5
	.DEF _s1=R4
	.DEF _s2=R7
	.DEF _s3=R6
	.DEF _s4=R9
	.DEF _s5=R8
	.DEF _s6=R11
	.DEF _s7=R10
	.DEF _sensor=R13
	.DEF _kursorPID=R12

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
	JMP  _timer2_ovf_isr
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

_0xA3:
	.DB  0x5
_0xE0:
	.DB  0x64
_0xE1:
	.DB  0x9C
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
	.DB  0x20,0x20,0x20,0x20,0x20,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _diffPWM
	.DW  _0xA3*2

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
;Project :
;Version :
;Date    : 12/5/2012
;Author  :
;Company :
;Comments:
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
;#include <delay.h>
;#include <stdio.h>
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;#define ADC_VREF_TYPE 0x20
;
;unsigned char s0,s1,s2,s3,s4,s5,s6,s7,s7,sensor;
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0026 {

	.CSEG
_read_adc:
; 0000 0027 ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 0028 // Delay needed for the stabilization of the ADC input voltage
; 0000 0029 delay_us(10);
	__DELAY_USB 40
; 0000 002A // Start the AD conversion
; 0000 002B ADCSRA|=0x40;
	SBI  0x6,6
; 0000 002C // Wait for the AD conversion to complete
; 0000 002D while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 002E ADCSRA|=0x10;
	SBI  0x6,4
; 0000 002F return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0030 }
;
;// Declare your global variables here
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
; 0000 0044 {
_define_char:
; 0000 0045 byte i,a;
; 0000 0046 a=(char_code<<3) | 0x40;
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
; 0000 0047 for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
	LDI  R17,LOW(0)
_0x7:
	CPI  R17,8
	BRSH _0x8
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
	RJMP _0x7
_0x8:
; 0000 0048 }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;
;void tampil(unsigned char dat)
; 0000 004B {
_tampil:
; 0000 004C         unsigned char data;
; 0000 004D 
; 0000 004E         data = dat / 100;
	ST   -Y,R17
;	dat -> Y+1
;	data -> R17
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x0
; 0000 004F         data+=0x30;
; 0000 0050         lcd_putchar(data);
; 0000 0051 
; 0000 0052         dat%=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	STD  Y+1,R30
; 0000 0053         data = dat / 10;
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x0
; 0000 0054         data+=0x30;
; 0000 0055         lcd_putchar(data);
; 0000 0056 
; 0000 0057         dat%=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+1,R30
; 0000 0058         data = dat + 0x30;
	SUBI R30,-LOW(48)
	MOV  R17,R30
; 0000 0059         lcd_putchar(data);
	ST   -Y,R17
	CALL _lcd_putchar
; 0000 005A }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;// switch
;#define sw_up           PIND.4
;#define sw_down         PIND.6
;#define sw_ok           PIND.5
;#define sw_cancel       PIND.3
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
; 0000 006C void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom ) {
_tulisKeEEPROM:
; 0000 006D                                                      lcd_gotoxy(0, 0);
;	NoMenu -> Y+2
;	NoSubMenu -> Y+1
;	var_in_eeprom -> Y+0
	CALL SUBOPT_0x1
; 0000 006E         lcd_putsf("Tulis ke EEPROM ");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x2
; 0000 006F         lcd_putsf("...             ");
	__POINTW1FN _0x0,17
	CALL SUBOPT_0x2
; 0000 0070         switch (NoMenu) {
	LDD  R30,Y+2
	CALL SUBOPT_0x3
; 0000 0071           case 1: // PID
	BRNE _0xC
; 0000 0072                 switch (NoSubMenu) {
	LDD  R30,Y+1
	CALL SUBOPT_0x3
; 0000 0073                   case 1: // Kp
	BRNE _0x10
; 0000 0074                         Kp = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	RJMP _0x136
; 0000 0075                         break;
; 0000 0076                   case 2: // Ki
_0x10:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x11
; 0000 0077                         Ki = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	RJMP _0x136
; 0000 0078                         break;
; 0000 0079                   case 3: // Kd
_0x11:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xF
; 0000 007A                         Kd = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
_0x136:
	CALL __EEPROMWRB
; 0000 007B                         break;
; 0000 007C                 }
_0xF:
; 0000 007D                 break;
	RJMP _0xB
; 0000 007E           case 2: // Speed
_0xC:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x13
; 0000 007F                 switch (NoSubMenu) {
	LDD  R30,Y+1
	CALL SUBOPT_0x3
; 0000 0080                   case 1: // MAX
	BRNE _0x17
; 0000 0081                         MAXSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	RJMP _0x137
; 0000 0082                         break;
; 0000 0083                   case 2: // MIN
_0x17:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x16
; 0000 0084                         MINSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
_0x137:
	CALL __EEPROMWRB
; 0000 0085                         break;
; 0000 0086                 }
_0x16:
; 0000 0087                 break;
	RJMP _0xB
; 0000 0088           case 3: // Warna Garis
_0x13:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x19
; 0000 0089                 switch (NoSubMenu) {
	LDD  R30,Y+1
	CALL SUBOPT_0x3
; 0000 008A                   case 1: // Warna
	BRNE _0x1D
; 0000 008B                         WarnaGaris = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	RJMP _0x138
; 0000 008C                         break;
; 0000 008D                   case 2: // SensL
_0x1D:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1C
; 0000 008E                         SensLine = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
_0x138:
	CALL __EEPROMWRB
; 0000 008F                         break;
; 0000 0090                 }
_0x1C:
; 0000 0091                 break;
	RJMP _0xB
; 0000 0092           case 4: // Skenario
_0x19:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xB
; 0000 0093                 Skenario = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMWRB
; 0000 0094                 break;
; 0000 0095         }
_0xB:
; 0000 0096         delay_ms(200);
	CALL SUBOPT_0x4
; 0000 0097 }
	ADIW R28,3
	RET
;
;void setByte( byte NoMenu, byte NoSubMenu ) {
; 0000 0099 void setByte( byte NoMenu, byte NoSubMenu ) {
_setByte:
; 0000 009A         byte var_in_eeprom;
; 0000 009B         byte plus5 = 0;
; 0000 009C         char limitPilih = -1;
; 0000 009D 
; 0000 009E         lcd_clear();
	CALL __SAVELOCR4
;	NoMenu -> Y+5
;	NoSubMenu -> Y+4
;	var_in_eeprom -> R17
;	plus5 -> R16
;	limitPilih -> R19
	LDI  R16,0
	LDI  R19,255
	CALL _lcd_clear
; 0000 009F         lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1
; 0000 00A0         switch (NoMenu) {
	LDD  R30,Y+5
	CALL SUBOPT_0x3
; 0000 00A1           case 1: // PID
	BRNE _0x23
; 0000 00A2                 switch (NoSubMenu) {
	LDD  R30,Y+4
	CALL SUBOPT_0x3
; 0000 00A3                   case 1: // Kp
	BRNE _0x27
; 0000 00A4                         lcd_putsf("Set Kp :        ");
	__POINTW1FN _0x0,34
	CALL SUBOPT_0x2
; 0000 00A5                         var_in_eeprom = Kp;
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	RJMP _0x139
; 0000 00A6                         break;
; 0000 00A7                   case 2: // Ki
_0x27:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x28
; 0000 00A8                         lcd_putsf("Set Ki :        ");
	__POINTW1FN _0x0,51
	CALL SUBOPT_0x2
; 0000 00A9                         var_in_eeprom = Ki;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	RJMP _0x139
; 0000 00AA                         break;
; 0000 00AB                   case 3: // Kd
_0x28:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x26
; 0000 00AC                         lcd_putsf("Set Kd :        ");
	__POINTW1FN _0x0,68
	CALL SUBOPT_0x2
; 0000 00AD                         var_in_eeprom = Kd;
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
_0x139:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 00AE                         break;
; 0000 00AF                 }
_0x26:
; 0000 00B0                 break;
	RJMP _0x22
; 0000 00B1           case 2: // Speed
_0x23:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2A
; 0000 00B2                 plus5 = 1;
	LDI  R16,LOW(1)
; 0000 00B3                 switch (NoSubMenu) {
	LDD  R30,Y+4
	CALL SUBOPT_0x3
; 0000 00B4                   case 1: // MAX
	BRNE _0x2E
; 0000 00B5                         lcd_putsf("Set MAX Speed : ");
	__POINTW1FN _0x0,85
	CALL SUBOPT_0x2
; 0000 00B6                         var_in_eeprom = MAXSpeed;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	RJMP _0x13A
; 0000 00B7                         break;
; 0000 00B8                   case 2: // MIN
_0x2E:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x2D
; 0000 00B9                         lcd_putsf("Set MIN Speed : ");
	__POINTW1FN _0x0,102
	CALL SUBOPT_0x2
; 0000 00BA                         var_in_eeprom = MINSpeed;
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
_0x13A:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 00BB                         break;
; 0000 00BC                 }
_0x2D:
; 0000 00BD                 break;
	RJMP _0x22
; 0000 00BE           case 3: // Warna Garis
_0x2A:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x30
; 0000 00BF                 switch (NoSubMenu) {
	LDD  R30,Y+4
	CALL SUBOPT_0x3
; 0000 00C0                   case 1: // Warna
	BRNE _0x34
; 0000 00C1                         limitPilih = 1;
	LDI  R19,LOW(1)
; 0000 00C2                         lcd_putsf("Warna Garis   : ");
	__POINTW1FN _0x0,119
	CALL SUBOPT_0x2
; 0000 00C3                         var_in_eeprom = WarnaGaris;
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	RJMP _0x13B
; 0000 00C4                         break;
; 0000 00C5                   case 2: // SensL
_0x34:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x33
; 0000 00C6                         limitPilih = 3;
	LDI  R19,LOW(3)
; 0000 00C7                         lcd_putsf("SensLine :      ");
	__POINTW1FN _0x0,136
	CALL SUBOPT_0x2
; 0000 00C8                         var_in_eeprom = SensLine;
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
_0x13B:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 00C9                         break;
; 0000 00CA                 }
_0x33:
; 0000 00CB                 break;
	RJMP _0x22
; 0000 00CC           case 4: // Skenario
_0x30:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x22
; 0000 00CD                   lcd_putsf("Skenario :      ");
	__POINTW1FN _0x0,153
	CALL SUBOPT_0x2
; 0000 00CE                   var_in_eeprom = Skenario;
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 00CF                   limitPilih = 8;
	LDI  R19,LOW(8)
; 0000 00D0                   break;
; 0000 00D1         }
_0x22:
; 0000 00D2 
; 0000 00D3         while (sw_cancel) {
_0x37:
	SBIS 0x10,3
	RJMP _0x39
; 0000 00D4                 delay_ms(150);
	CALL SUBOPT_0x5
; 0000 00D5                 lcd_gotoxy(0, 1);
	CALL SUBOPT_0x6
; 0000 00D6                 tampil(var_in_eeprom);
	ST   -Y,R17
	RCALL _tampil
; 0000 00D7 
; 0000 00D8                 if (!sw_ok)   {
	SBIC 0x10,5
	RJMP _0x3A
; 0000 00D9                         lcd_clear();
	CALL _lcd_clear
; 0000 00DA                         tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R17
	RCALL _tulisKeEEPROM
; 0000 00DB                         goto exitSetByte;
	RJMP _0x3B
; 0000 00DC                 }
; 0000 00DD                 if (!sw_down) {
_0x3A:
	SBIC 0x10,6
	RJMP _0x3C
; 0000 00DE                         if ( plus5 )
	CPI  R16,0
	BREQ _0x3D
; 0000 00DF                                 if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x3E
; 0000 00E0                                         var_in_eeprom = 255;
	LDI  R17,LOW(255)
; 0000 00E1                                 else
	RJMP _0x3F
_0x3E:
; 0000 00E2                                         var_in_eeprom -= 5;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,5
	MOV  R17,R30
; 0000 00E3                         else
_0x3F:
	RJMP _0x40
_0x3D:
; 0000 00E4                                 if ( !limitPilih )
	CPI  R19,0
	BREQ _0x13C
; 0000 00E5                                         var_in_eeprom--;
; 0000 00E6                                 else {
; 0000 00E7                                         if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x43
; 0000 00E8                                           var_in_eeprom = limitPilih;
	MOV  R17,R19
; 0000 00E9                                         else
	RJMP _0x44
_0x43:
; 0000 00EA                                           var_in_eeprom--;
_0x13C:
	SUBI R17,1
; 0000 00EB                                 }
_0x44:
_0x40:
; 0000 00EC                 }
; 0000 00ED                 if (!sw_up)   {
_0x3C:
	SBIC 0x10,4
	RJMP _0x45
; 0000 00EE                         if ( plus5 )
	CPI  R16,0
	BREQ _0x46
; 0000 00EF                                 if ( var_in_eeprom == 255 )
	CPI  R17,255
	BRNE _0x47
; 0000 00F0                                         var_in_eeprom = 0;
	LDI  R17,LOW(0)
; 0000 00F1                                 else
	RJMP _0x48
_0x47:
; 0000 00F2                                         var_in_eeprom += 5;
	SUBI R17,-LOW(5)
; 0000 00F3                         else
_0x48:
	RJMP _0x49
_0x46:
; 0000 00F4                                 if ( !limitPilih )
	CPI  R19,0
	BREQ _0x13D
; 0000 00F5                                         var_in_eeprom++;
; 0000 00F6                                 else {
; 0000 00F7                                         if ( var_in_eeprom == limitPilih )
	CP   R19,R17
	BRNE _0x4C
; 0000 00F8                                           var_in_eeprom = 0;
	LDI  R17,LOW(0)
; 0000 00F9                                         else
	RJMP _0x4D
_0x4C:
; 0000 00FA                                           var_in_eeprom++;
_0x13D:
	SUBI R17,-1
; 0000 00FB                                 }
_0x4D:
_0x49:
; 0000 00FC                 }
; 0000 00FD         }
_0x45:
	RJMP _0x37
_0x39:
; 0000 00FE       exitSetByte:
_0x3B:
; 0000 00FF         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x7
; 0000 0100         lcd_clear();
	CALL _lcd_clear
; 0000 0101 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;byte kursorPID, kursorSpeed, kursorGaris;
;void showMenu() {
; 0000 0104 void showMenu() {
_showMenu:
; 0000 0105         lcd_clear();
	CALL _lcd_clear
; 0000 0106     menu01:
_0x4E:
; 0000 0107         delay_ms(125);   // bouncing sw
	CALL SUBOPT_0x8
; 0000 0108         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 0109                 // 0123456789abcdef
; 0000 010A         lcd_putsf("  Set PID       ");
	__POINTW1FN _0x0,170
	CALL SUBOPT_0x2
; 0000 010B         lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
; 0000 010C         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x2
; 0000 010D 
; 0000 010E         // kursor awal
; 0000 010F         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 0110         lcd_putchar(0);
	CALL SUBOPT_0x9
; 0000 0111 
; 0000 0112         if (!sw_ok)   {
	SBIC 0x10,5
	RJMP _0x4F
; 0000 0113                 lcd_clear();
	CALL _lcd_clear
; 0000 0114                 kursorPID = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 0115                 goto setPID;
	RJMP _0x50
; 0000 0116         }
; 0000 0117         if (!sw_down) {
_0x4F:
	SBIS 0x10,6
; 0000 0118                 goto menu02;
	RJMP _0x52
; 0000 0119         }
; 0000 011A         if (!sw_up)   {
	SBIC 0x10,4
	RJMP _0x53
; 0000 011B                 lcd_clear();
	CALL _lcd_clear
; 0000 011C                 goto menu05;
	RJMP _0x54
; 0000 011D         }
; 0000 011E 
; 0000 011F         goto menu01;
_0x53:
	RJMP _0x4E
; 0000 0120     menu02:
_0x52:
; 0000 0121         delay_ms(125);
	CALL SUBOPT_0x8
; 0000 0122         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 0123                  // 0123456789abcdef
; 0000 0124         lcd_putsf("  Set PID       ");
	__POINTW1FN _0x0,170
	CALL SUBOPT_0x2
; 0000 0125         lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
; 0000 0126         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x2
; 0000 0127 
; 0000 0128         lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
; 0000 0129         lcd_putchar(0);
	CALL SUBOPT_0x9
; 0000 012A 
; 0000 012B         if (!sw_ok) {
	SBIC 0x10,5
	RJMP _0x55
; 0000 012C                 lcd_clear();
	CALL _lcd_clear
; 0000 012D                 kursorSpeed = 1;
	LDI  R30,LOW(1)
	STS  _kursorSpeed,R30
; 0000 012E                 goto setSpeed;
	RJMP _0x56
; 0000 012F         }
; 0000 0130         if (!sw_up) {
_0x55:
	SBIS 0x10,4
; 0000 0131                 goto menu01;
	RJMP _0x4E
; 0000 0132         }
; 0000 0133         if (!sw_down) {
	SBIC 0x10,6
	RJMP _0x58
; 0000 0134                 lcd_clear();
	CALL _lcd_clear
; 0000 0135                 goto menu03;
	RJMP _0x59
; 0000 0136        }
; 0000 0137         goto menu02;
_0x58:
	RJMP _0x52
; 0000 0138     menu03:
_0x59:
; 0000 0139         delay_ms(125);
	CALL SUBOPT_0x8
; 0000 013A         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 013B                 // 0123456789abcdef
; 0000 013C         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0x0,204
	CALL SUBOPT_0x2
; 0000 013D         lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
; 0000 013E         lcd_putsf("  Skenario      ");
	__POINTW1FN _0x0,221
	CALL SUBOPT_0x2
; 0000 013F 
; 0000 0140         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 0141         lcd_putchar(0);
	CALL SUBOPT_0x9
; 0000 0142 
; 0000 0143         if (!sw_ok) {
	SBIC 0x10,5
	RJMP _0x5A
; 0000 0144                 lcd_clear();
	CALL _lcd_clear
; 0000 0145                 kursorGaris = 1;
	LDI  R30,LOW(1)
	STS  _kursorGaris,R30
; 0000 0146                 goto setGaris;
	RJMP _0x5B
; 0000 0147         }
; 0000 0148         if (!sw_up) {
_0x5A:
	SBIC 0x10,4
	RJMP _0x5C
; 0000 0149                 lcd_clear();
	CALL _lcd_clear
; 0000 014A                 goto menu02;
	RJMP _0x52
; 0000 014B         }
; 0000 014C         if (!sw_down) {
_0x5C:
	SBIS 0x10,6
; 0000 014D                 goto menu04;
	RJMP _0x5E
; 0000 014E         }
; 0000 014F         goto menu03;
	RJMP _0x59
; 0000 0150     menu04:
_0x5E:
; 0000 0151         delay_ms(125);
	CALL SUBOPT_0x8
; 0000 0152         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 0153                 // 0123456789abcdef
; 0000 0154         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0x0,204
	CALL SUBOPT_0x2
; 0000 0155         lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
; 0000 0156         lcd_putsf("  Skenario      ");
	__POINTW1FN _0x0,221
	CALL SUBOPT_0x2
; 0000 0157 
; 0000 0158         lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
; 0000 0159         lcd_putchar(0);
	CALL SUBOPT_0x9
; 0000 015A 
; 0000 015B         if (!sw_ok) {
	SBIC 0x10,5
	RJMP _0x5F
; 0000 015C                 lcd_clear();
	CALL _lcd_clear
; 0000 015D                 goto setSkenario;
	RJMP _0x60
; 0000 015E         }
; 0000 015F         if (!sw_up) {
_0x5F:
	SBIS 0x10,4
; 0000 0160                 goto menu03;
	RJMP _0x59
; 0000 0161         }
; 0000 0162         if (!sw_down) {
	SBIC 0x10,6
	RJMP _0x62
; 0000 0163                 lcd_clear();
	CALL _lcd_clear
; 0000 0164                 goto menu05;
	RJMP _0x54
; 0000 0165         }
; 0000 0166         goto menu04;
_0x62:
	RJMP _0x5E
; 0000 0167     menu05:
_0x54:
; 0000 0168         delay_ms(125);
	CALL SUBOPT_0x8
; 0000 0169         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 016A         lcd_putsf("  Start!!      ");
	__POINTW1FN _0x0,238
	CALL SUBOPT_0x2
; 0000 016B         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 016C         lcd_putchar(0);
	CALL SUBOPT_0x9
; 0000 016D 
; 0000 016E         if (!sw_ok) {
	SBIC 0x10,5
	RJMP _0x63
; 0000 016F                 lcd_clear();
	CALL _lcd_clear
; 0000 0170                 goto startRobot;
	RJMP _0x64
; 0000 0171         }
; 0000 0172         if (!sw_up) {
_0x63:
	SBIC 0x10,4
	RJMP _0x65
; 0000 0173                 lcd_clear();
	CALL _lcd_clear
; 0000 0174                 goto menu04;
	RJMP _0x5E
; 0000 0175         }
; 0000 0176         if (!sw_down) {
_0x65:
	SBIC 0x10,6
	RJMP _0x66
; 0000 0177                 lcd_clear();
	CALL _lcd_clear
; 0000 0178                 goto menu01;
	RJMP _0x4E
; 0000 0179         }
; 0000 017A 
; 0000 017B         goto menu05;
_0x66:
	RJMP _0x54
; 0000 017C 
; 0000 017D     setPID:
_0x50:
; 0000 017E         delay_ms(150);
	CALL SUBOPT_0x5
; 0000 017F         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 0180                 // 0123456789ABCDEF
; 0000 0181         lcd_putsf("  Kp   Ki   Kd  ");
	__POINTW1FN _0x0,254
	CALL SUBOPT_0x2
; 0000 0182         // lcd_putsf(" 250  200  300  ");
; 0000 0183         lcd_putchar(' ');
	CALL SUBOPT_0xA
; 0000 0184         tampil(Kp); lcd_putchar(' '); lcd_putchar(' ');
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA
; 0000 0185         tampil(Ki); lcd_putchar(' '); lcd_putchar(' ');
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA
; 0000 0186         tampil(Kd); lcd_putchar(' '); lcd_putchar(' ');
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL SUBOPT_0xB
	CALL SUBOPT_0xA
; 0000 0187 
; 0000 0188         switch (kursorPID) {
	MOV  R30,R12
	CALL SUBOPT_0x3
; 0000 0189           case 1:
	BRNE _0x6A
; 0000 018A                 lcd_gotoxy(1,0); // kursor Kp
	LDI  R30,LOW(1)
	RJMP _0x13E
; 0000 018B                 lcd_putchar(0);
; 0000 018C                 break;
; 0000 018D           case 2:
_0x6A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x6B
; 0000 018E                 lcd_gotoxy(6,0); // kursor Ki
	LDI  R30,LOW(6)
	RJMP _0x13E
; 0000 018F                 lcd_putchar(0);
; 0000 0190                 break;
; 0000 0191           case 3:
_0x6B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x69
; 0000 0192                 lcd_gotoxy(11,0); // kursor Kd
	LDI  R30,LOW(11)
_0x13E:
	ST   -Y,R30
	CALL SUBOPT_0xC
; 0000 0193                 lcd_putchar(0);
; 0000 0194                 break;
; 0000 0195         }
_0x69:
; 0000 0196 
; 0000 0197         if (!sw_ok) {
	SBIC 0x10,5
	RJMP _0x6D
; 0000 0198                 setByte( 1, kursorPID);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R12
	CALL SUBOPT_0xD
; 0000 0199                 delay_ms(200);
; 0000 019A         }
; 0000 019B         if (!sw_up) {
_0x6D:
	SBIC 0x10,4
	RJMP _0x6E
; 0000 019C                 if (kursorPID == 3) {
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0x6F
; 0000 019D                         kursorPID = 1;
	LDI  R30,LOW(1)
	MOV  R12,R30
; 0000 019E                 } else kursorPID++;
	RJMP _0x70
_0x6F:
	INC  R12
; 0000 019F         }
_0x70:
; 0000 01A0         if (!sw_down) {
_0x6E:
	SBIC 0x10,6
	RJMP _0x71
; 0000 01A1                 if (kursorPID == 1) {
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x72
; 0000 01A2                         kursorPID = 3;
	LDI  R30,LOW(3)
	MOV  R12,R30
; 0000 01A3                 } else kursorPID--;
	RJMP _0x73
_0x72:
	DEC  R12
; 0000 01A4         }
_0x73:
; 0000 01A5 
; 0000 01A6         if (!sw_cancel) {
_0x71:
	SBIC 0x10,3
	RJMP _0x74
; 0000 01A7                 lcd_clear();
	CALL _lcd_clear
; 0000 01A8                 goto menu01;
	RJMP _0x4E
; 0000 01A9         }
; 0000 01AA 
; 0000 01AB         goto setPID;
_0x74:
	RJMP _0x50
; 0000 01AC 
; 0000 01AD     setSpeed:
_0x56:
; 0000 01AE         delay_ms(150);
	CALL SUBOPT_0x5
; 0000 01AF         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 01B0                 // 0123456789ABCDEF
; 0000 01B1         lcd_putsf("   MAX    MIN   ");
	__POINTW1FN _0x0,271
	CALL SUBOPT_0x2
; 0000 01B2         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
; 0000 01B3 
; 0000 01B4         //lcd_putsf("   250    200   ");
; 0000 01B5         tampil(MAXSpeed);
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL SUBOPT_0xB
; 0000 01B6         lcd_putchar(' '); lcd_putchar(' ');lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
; 0000 01B7         tampil(MINSpeed);
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0xB
; 0000 01B8         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
; 0000 01B9 
; 0000 01BA         switch (kursorSpeed) {
	LDS  R30,_kursorSpeed
	CALL SUBOPT_0x3
; 0000 01BB           case 1:
	BRNE _0x78
; 0000 01BC                 lcd_gotoxy(2,0); // kursor MAX
	LDI  R30,LOW(2)
	RJMP _0x13F
; 0000 01BD                 lcd_putchar(0);
; 0000 01BE                 break;
; 0000 01BF           case 2:
_0x78:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x77
; 0000 01C0                 lcd_gotoxy(9,0); // kursor MIN
	LDI  R30,LOW(9)
_0x13F:
	ST   -Y,R30
	CALL SUBOPT_0xC
; 0000 01C1                 lcd_putchar(0);
; 0000 01C2                 break;
; 0000 01C3         }
_0x77:
; 0000 01C4 
; 0000 01C5         if (!sw_ok) {
	SBIC 0x10,5
	RJMP _0x7A
; 0000 01C6                 setByte( 2, kursorSpeed);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R30,_kursorSpeed
	ST   -Y,R30
	CALL SUBOPT_0xD
; 0000 01C7                 delay_ms(200);
; 0000 01C8         }
; 0000 01C9         if (!sw_up) {
_0x7A:
	SBIC 0x10,4
	RJMP _0x7B
; 0000 01CA                 if (kursorSpeed == 2) {
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x2)
	BRNE _0x7C
; 0000 01CB                         kursorSpeed = 1;
	LDI  R30,LOW(1)
	RJMP _0x140
; 0000 01CC                 } else kursorSpeed++;
_0x7C:
	LDS  R30,_kursorSpeed
	SUBI R30,-LOW(1)
_0x140:
	STS  _kursorSpeed,R30
; 0000 01CD         }
; 0000 01CE         if (!sw_down) {
_0x7B:
	SBIC 0x10,6
	RJMP _0x7E
; 0000 01CF                 if (kursorSpeed == 1) {
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x1)
	BRNE _0x7F
; 0000 01D0                         kursorSpeed = 2;
	LDI  R30,LOW(2)
	RJMP _0x141
; 0000 01D1                 } else kursorSpeed--;
_0x7F:
	LDS  R30,_kursorSpeed
	SUBI R30,LOW(1)
_0x141:
	STS  _kursorSpeed,R30
; 0000 01D2         }
; 0000 01D3 
; 0000 01D4         if (!sw_cancel) {
_0x7E:
	SBIC 0x10,3
	RJMP _0x81
; 0000 01D5                 lcd_clear();
	CALL _lcd_clear
; 0000 01D6                 goto menu02;
	RJMP _0x52
; 0000 01D7         }
; 0000 01D8 
; 0000 01D9         goto setSpeed;
_0x81:
	RJMP _0x56
; 0000 01DA 
; 0000 01DB      setGaris: // not yet
_0x5B:
; 0000 01DC         delay_ms(150);
	CALL SUBOPT_0x5
; 0000 01DD         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 01DE                 // 0123456789ABCDEF
; 0000 01DF         if ( WarnaGaris == 1 )
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0x82
; 0000 01E0                 lcd_putsf("  WARNA : Putih ");
	__POINTW1FN _0x0,288
	RJMP _0x142
; 0000 01E1         else
_0x82:
; 0000 01E2                 lcd_putsf("  WARNA : Hitam ");
	__POINTW1FN _0x0,305
_0x142:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 01E3 
; 0000 01E4         //lcd_putsf("  LEBAR: 1.5 cm ");
; 0000 01E5         lcd_gotoxy(0,1);
	CALL SUBOPT_0x6
; 0000 01E6         lcd_putsf("  SensL :        ");
	__POINTW1FN _0x0,322
	CALL SUBOPT_0x2
; 0000 01E7         lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01E8         tampil( SensLine );
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _tampil
; 0000 01E9 
; 0000 01EA         switch (kursorGaris) {
	LDS  R30,_kursorGaris
	CALL SUBOPT_0x3
; 0000 01EB           case 1:
	BRNE _0x87
; 0000 01EC                 lcd_gotoxy(0,0); // kursor Warna
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x143
; 0000 01ED                 lcd_putchar(0);
; 0000 01EE                 break;
; 0000 01EF           case 2:
_0x87:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x86
; 0000 01F0                 lcd_gotoxy(0,1); // kursor SensL
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x143:
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 01F1                 lcd_putchar(0);
	CALL SUBOPT_0x9
; 0000 01F2                 break;
; 0000 01F3         }
_0x86:
; 0000 01F4 
; 0000 01F5         if (!sw_ok) {
	SBIC 0x10,5
	RJMP _0x89
; 0000 01F6                 setByte( 3, kursorGaris);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDS  R30,_kursorGaris
	ST   -Y,R30
	CALL SUBOPT_0xD
; 0000 01F7                 delay_ms(200);
; 0000 01F8         }
; 0000 01F9         if (!sw_up) {
_0x89:
	SBIC 0x10,4
	RJMP _0x8A
; 0000 01FA                 if (kursorGaris == 2) {
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x2)
	BRNE _0x8B
; 0000 01FB                         kursorGaris = 1;
	LDI  R30,LOW(1)
	RJMP _0x144
; 0000 01FC                 } else kursorGaris++;
_0x8B:
	LDS  R30,_kursorGaris
	SUBI R30,-LOW(1)
_0x144:
	STS  _kursorGaris,R30
; 0000 01FD         }
; 0000 01FE         if (!sw_down) {
_0x8A:
	SBIC 0x10,6
	RJMP _0x8D
; 0000 01FF                 if (kursorGaris == 1) {
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x1)
	BRNE _0x8E
; 0000 0200                         kursorGaris = 2;
	LDI  R30,LOW(2)
	RJMP _0x145
; 0000 0201                 } else kursorGaris--;
_0x8E:
	LDS  R30,_kursorGaris
	SUBI R30,LOW(1)
_0x145:
	STS  _kursorGaris,R30
; 0000 0202         }
; 0000 0203 
; 0000 0204         if (!sw_cancel) {
_0x8D:
	SBIC 0x10,3
	RJMP _0x90
; 0000 0205                 lcd_clear();
	CALL _lcd_clear
; 0000 0206                 goto menu03;
	RJMP _0x59
; 0000 0207         }
; 0000 0208 
; 0000 0209         goto setGaris;
_0x90:
	RJMP _0x5B
; 0000 020A 
; 0000 020B      setSkenario:
_0x60:
; 0000 020C         delay_ms(150);
	CALL SUBOPT_0x5
; 0000 020D         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1
; 0000 020E                 // 0123456789ABCDEF
; 0000 020F         lcd_putsf("Sken. yg  dpake:");
	__POINTW1FN _0x0,340
	CALL SUBOPT_0x2
; 0000 0210         lcd_gotoxy(0, 1);
	CALL SUBOPT_0x6
; 0000 0211         tampil( Skenario );
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _tampil
; 0000 0212 
; 0000 0213         if (!sw_ok) {
	SBIC 0x10,5
	RJMP _0x91
; 0000 0214                 setByte( 4, 0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0xD
; 0000 0215                 delay_ms(200);
; 0000 0216         }
; 0000 0217 
; 0000 0218         if (!sw_cancel) {
_0x91:
	SBIC 0x10,3
	RJMP _0x92
; 0000 0219                 lcd_clear();
	CALL _lcd_clear
; 0000 021A                 goto menu04;
	RJMP _0x5E
; 0000 021B         }
; 0000 021C 
; 0000 021D         goto setSkenario;
_0x92:
	RJMP _0x60
; 0000 021E 
; 0000 021F      startRobot:
_0x64:
; 0000 0220         lcd_clear();
	CALL _lcd_clear
; 0000 0221 
; 0000 0222 }
	RET
;
;#define sKi  PIND.0
;#define sKa  PIND.1
;
;void displaySensorBit()
; 0000 0228 {
_displaySensorBit:
; 0000 0229     lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 022A     if (s7) lcd_putchar('1');
	TST  R10
	BREQ _0x93
	LDI  R30,LOW(49)
	RJMP _0x146
; 0000 022B     else    lcd_putchar('0');
_0x93:
	LDI  R30,LOW(48)
_0x146:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 022C     if (s6) lcd_putchar('1');
	TST  R11
	BREQ _0x95
	LDI  R30,LOW(49)
	RJMP _0x147
; 0000 022D     else    lcd_putchar('0');
_0x95:
	LDI  R30,LOW(48)
_0x147:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 022E     if (s5) lcd_putchar('1');
	TST  R8
	BREQ _0x97
	LDI  R30,LOW(49)
	RJMP _0x148
; 0000 022F     else    lcd_putchar('0');
_0x97:
	LDI  R30,LOW(48)
_0x148:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0230     if (s4) lcd_putchar('1');
	TST  R9
	BREQ _0x99
	LDI  R30,LOW(49)
	RJMP _0x149
; 0000 0231     else    lcd_putchar('0');
_0x99:
	LDI  R30,LOW(48)
_0x149:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0232     if (s3) lcd_putchar('1');
	TST  R6
	BREQ _0x9B
	LDI  R30,LOW(49)
	RJMP _0x14A
; 0000 0233     else    lcd_putchar('0');
_0x9B:
	LDI  R30,LOW(48)
_0x14A:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0234     if (s2) lcd_putchar('1');
	TST  R7
	BREQ _0x9D
	LDI  R30,LOW(49)
	RJMP _0x14B
; 0000 0235     else    lcd_putchar('0');
_0x9D:
	LDI  R30,LOW(48)
_0x14B:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0236     if (s1) lcd_putchar('1');
	TST  R4
	BREQ _0x9F
	LDI  R30,LOW(49)
	RJMP _0x14C
; 0000 0237     else    lcd_putchar('0');
_0x9F:
	LDI  R30,LOW(48)
_0x14C:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0238     if (s0) lcd_putchar('1');
	TST  R5
	BREQ _0xA1
	LDI  R30,LOW(49)
	RJMP _0x14D
; 0000 0239     else    lcd_putchar('0');
_0xA1:
	LDI  R30,LOW(48)
_0x14D:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 023A }
	RET
;
;#define BL      PORTB.3
;
;#define Enki PORTD.7
;#define kirplus PORTD.6
;#define kirmin PORTD.5
;#define Enka PORTD.4
;#define kaplus PORTD.3
;#define kamin PORTD.2
;
;unsigned char xcount;
;int lpwm, rpwm, MAXPWM, MINPWM, intervalPWM;
;byte diffPWM = 5; // utk kiri

	.DSEG
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 024A {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 024B         // Place your code here
; 0000 024C         xcount++;
	LDS  R30,_xcount
	SUBI R30,-LOW(1)
	STS  _xcount,R30
; 0000 024D         if(xcount<=lpwm)Enki=1;
	LDS  R30,_lpwm
	LDS  R31,_lpwm+1
	CALL SUBOPT_0xE
	BRLT _0xA4
	SBI  0x12,7
; 0000 024E         else Enki=0;
	RJMP _0xA7
_0xA4:
	CBI  0x12,7
; 0000 024F         if(xcount<=rpwm)Enka=1;
_0xA7:
	LDS  R30,_rpwm
	LDS  R31,_rpwm+1
	CALL SUBOPT_0xE
	BRLT _0xAA
	SBI  0x12,4
; 0000 0250         else Enka=0;
	RJMP _0xAD
_0xAA:
	CBI  0x12,4
; 0000 0251         TCNT0=0xFF;
_0xAD:
	LDI  R30,LOW(255)
	OUT  0x32,R30
; 0000 0252 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;//unsigned char s0_low,s1_low,s2_low,s3_low,s4_low,s5_low,s6_low,s7_low;
;//unsigned char s0_up,s1_up,s2_up,s3_up,s4_up,s5_up,s6_up,s7_up;
;unsigned char s0_cent,s1_cent,s2_cent,s3_cent,s4_cent,s5_cent,s6_cent,s7_cent;
;// Timer2 overflow interrupt service routine
;interrupt [TIM2_OVF] void timer2_ovf_isr(void)
; 0000 0259 {
_timer2_ovf_isr:
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
; 0000 025A         // Reinitialize Timer2 value
; 0000 025B         TCNT2=0x7E;
	LDI  R30,LOW(126)
	OUT  0x24,R30
; 0000 025C 
; 0000 025D         // Place your code here
; 0000 025E         s0_cent = 125;
	LDI  R30,LOW(125)
	STS  _s0_cent,R30
; 0000 025F         s1_cent = 125;
	STS  _s1_cent,R30
; 0000 0260         s2_cent = 125;
	STS  _s2_cent,R30
; 0000 0261         s3_cent = 125;
	STS  _s3_cent,R30
; 0000 0262 
; 0000 0263         s4_cent = 125;
	STS  _s4_cent,R30
; 0000 0264         s5_cent = 125;
	STS  _s5_cent,R30
; 0000 0265         s6_cent = 125;
	STS  _s6_cent,R30
; 0000 0266         s7_cent = 125;
	STS  _s7_cent,R30
; 0000 0267 
; 0000 0268         s0 = read_adc(0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R5,R30
; 0000 0269         s1 = read_adc(1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R4,R30
; 0000 026A         s2 = read_adc(2);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R7,R30
; 0000 026B         s3 = read_adc(3);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R6,R30
; 0000 026C 
; 0000 026D         s4 = read_adc(4);
	LDI  R30,LOW(4)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R9,R30
; 0000 026E         s5 = read_adc(5);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R8,R30
; 0000 026F         s6 = read_adc(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R11,R30
; 0000 0270         s7 = read_adc(7);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	MOV  R10,R30
; 0000 0271 
; 0000 0272         if(s0<s0_cent)  s0 = 0;
	LDS  R30,_s0_cent
	CP   R5,R30
	BRSH _0xB0
	CLR  R5
; 0000 0273         else            s0 = 1;
	RJMP _0xB1
_0xB0:
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0274 
; 0000 0275         if(s1<s1_cent)  s1 = 0;
_0xB1:
	LDS  R30,_s1_cent
	CP   R4,R30
	BRSH _0xB2
	CLR  R4
; 0000 0276         else            s1 = 1;
	RJMP _0xB3
_0xB2:
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0277 
; 0000 0278         if(s2<s2_cent)  s2 = 0;
_0xB3:
	LDS  R30,_s2_cent
	CP   R7,R30
	BRSH _0xB4
	CLR  R7
; 0000 0279         else            s2 = 1;
	RJMP _0xB5
_0xB4:
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 027A 
; 0000 027B         if(s3<s3_cent)  s3 = 0;
_0xB5:
	LDS  R30,_s3_cent
	CP   R6,R30
	BRSH _0xB6
	CLR  R6
; 0000 027C         else            s3 = 1;
	RJMP _0xB7
_0xB6:
	LDI  R30,LOW(1)
	MOV  R6,R30
; 0000 027D 
; 0000 027E         if(s4<s4_cent)  s4 = 0;
_0xB7:
	LDS  R30,_s4_cent
	CP   R9,R30
	BRSH _0xB8
	CLR  R9
; 0000 027F         else            s4 = 1;
	RJMP _0xB9
_0xB8:
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0280 
; 0000 0281         if(s5<s5_cent)  s5 = 0;
_0xB9:
	LDS  R30,_s5_cent
	CP   R8,R30
	BRSH _0xBA
	CLR  R8
; 0000 0282         else            s5 = 1;
	RJMP _0xBB
_0xBA:
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0283 
; 0000 0284         if(s6<s6_cent)  s6 = 0;
_0xBB:
	LDS  R30,_s6_cent
	CP   R11,R30
	BRSH _0xBC
	CLR  R11
; 0000 0285         else            s6 = 1;
	RJMP _0xBD
_0xBC:
	LDI  R30,LOW(1)
	MOV  R11,R30
; 0000 0286 
; 0000 0287         if(s7<s7_cent)  s7 = 0;
_0xBD:
	LDS  R30,_s7_cent
	CP   R10,R30
	BRSH _0xBE
	CLR  R10
; 0000 0288         else            s7 = 1;
	RJMP _0xBF
_0xBE:
	LDI  R30,LOW(1)
	MOV  R10,R30
; 0000 0289 }
_0xBF:
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
;void maju()
; 0000 028C {
_maju:
; 0000 028D         kaplus=1;kirplus=1;
	SBI  0x12,3
	SBI  0x12,6
; 0000 028E         kamin=0;kirmin=0;
	RJMP _0x2080005
; 0000 028F }
;
;void mundur()
; 0000 0292 {
_mundur:
; 0000 0293         kaplus=0;kirplus=0;
	CBI  0x12,3
	CBI  0x12,6
; 0000 0294         kamin=1;kirmin=1;
	SBI  0x12,2
	RJMP _0x2080006
; 0000 0295 }
;
;void bkan()
; 0000 0298 {
_bkan:
; 0000 0299         kaplus=0;
	CBI  0x12,3
; 0000 029A         kamin=1;
	SBI  0x12,2
; 0000 029B }
	RET
;
;void bkir()
; 0000 029E {
_bkir:
; 0000 029F         kirplus=0;
	CBI  0x12,6
; 0000 02A0         kirmin=1;
_0x2080006:
	SBI  0x12,5
; 0000 02A1 }
	RET
;
;void stop()
; 0000 02A4 {
_stop:
; 0000 02A5         rpwm=0;lpwm=0;
	LDI  R30,LOW(0)
	STS  _rpwm,R30
	STS  _rpwm+1,R30
	STS  _lpwm,R30
	STS  _lpwm+1,R30
; 0000 02A6         kaplus=0;kirplus=0;
	CBI  0x12,3
	CBI  0x12,6
; 0000 02A7         kamin=0;kirmin=0;
_0x2080005:
	CBI  0x12,2
	CBI  0x12,5
; 0000 02A8 }
	RET
;
;int MV, P, I, D, PV, error, last_error, rate;
;int var_Kp, var_Ki, var_Kd;
;unsigned char max_MV = 100;

	.DSEG
;unsigned char min_MV = -100;
;unsigned char SP = 0;
;void scanBlackLine() {
; 0000 02AF void scanBlackLine() {

	.CSEG
_scanBlackLine:
; 0000 02B0 
; 0000 02B1     switch(sensor) {
	MOV  R30,R13
	LDI  R31,0
; 0000 02B2         case 0b11111110:        // ujung kiri
	CPI  R30,LOW(0xFE)
	LDI  R26,HIGH(0xFE)
	CPC  R31,R26
	BRNE _0xE5
; 0000 02B3                 PV = -7;
	LDI  R30,LOW(65529)
	LDI  R31,HIGH(65529)
	CALL SUBOPT_0xF
; 0000 02B4                 maju();
; 0000 02B5                 break;
	RJMP _0xE4
; 0000 02B6         case 0b11111000:
_0xE5:
	CPI  R30,LOW(0xF8)
	LDI  R26,HIGH(0xF8)
	CPC  R31,R26
	BREQ _0xE7
; 0000 02B7         case 0b11111100:
	CPI  R30,LOW(0xFC)
	LDI  R26,HIGH(0xFC)
	CPC  R31,R26
	BRNE _0xE8
_0xE7:
; 0000 02B8                 PV = -6;
	LDI  R30,LOW(65530)
	LDI  R31,HIGH(65530)
	CALL SUBOPT_0xF
; 0000 02B9                 maju();
; 0000 02BA                 break;
	RJMP _0xE4
; 0000 02BB         case 0b11111101:
_0xE8:
	CPI  R30,LOW(0xFD)
	LDI  R26,HIGH(0xFD)
	CPC  R31,R26
	BRNE _0xE9
; 0000 02BC                 PV = -5;
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	CALL SUBOPT_0xF
; 0000 02BD                 maju();
; 0000 02BE                 break;
	RJMP _0xE4
; 0000 02BF         case 0b11110001:
_0xE9:
	CPI  R30,LOW(0xF1)
	LDI  R26,HIGH(0xF1)
	CPC  R31,R26
	BREQ _0xEB
; 0000 02C0         case 0b11111001:
	CPI  R30,LOW(0xF9)
	LDI  R26,HIGH(0xF9)
	CPC  R31,R26
	BRNE _0xEC
_0xEB:
; 0000 02C1                 PV = -4;
	LDI  R30,LOW(65532)
	LDI  R31,HIGH(65532)
	CALL SUBOPT_0xF
; 0000 02C2                 maju();
; 0000 02C3                 break;
	RJMP _0xE4
; 0000 02C4         case 0b11111011:
_0xEC:
	CPI  R30,LOW(0xFB)
	LDI  R26,HIGH(0xFB)
	CPC  R31,R26
	BRNE _0xED
; 0000 02C5                 PV = -3;
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	CALL SUBOPT_0xF
; 0000 02C6                 maju();
; 0000 02C7                 break;
	RJMP _0xE4
; 0000 02C8         case 0b11100011:
_0xED:
	CPI  R30,LOW(0xE3)
	LDI  R26,HIGH(0xE3)
	CPC  R31,R26
	BREQ _0xEF
; 0000 02C9         case 0b11110011:
	CPI  R30,LOW(0xF3)
	LDI  R26,HIGH(0xF3)
	CPC  R31,R26
	BRNE _0xF0
_0xEF:
; 0000 02CA                 PV = -2;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CALL SUBOPT_0xF
; 0000 02CB                 maju();
; 0000 02CC                 break;
	RJMP _0xE4
; 0000 02CD         case 0b11110111:
_0xF0:
	CPI  R30,LOW(0xF7)
	LDI  R26,HIGH(0xF7)
	CPC  R31,R26
	BRNE _0xF1
; 0000 02CE                 PV = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL SUBOPT_0xF
; 0000 02CF                 maju();
; 0000 02D0                 break;
	RJMP _0xE4
; 0000 02D1         case 0b11100111:        // tengah
_0xF1:
	CPI  R30,LOW(0xE7)
	LDI  R26,HIGH(0xE7)
	CPC  R31,R26
	BRNE _0xF2
; 0000 02D2                 PV = 0;
	LDI  R30,LOW(0)
	STS  _PV,R30
	STS  _PV+1,R30
; 0000 02D3                 maju();
	RCALL _maju
; 0000 02D4                 break;
	RJMP _0xE4
; 0000 02D5         case 0b11101111:
_0xF2:
	CPI  R30,LOW(0xEF)
	LDI  R26,HIGH(0xEF)
	CPC  R31,R26
	BRNE _0xF3
; 0000 02D6                 PV = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xF
; 0000 02D7                 maju();
; 0000 02D8                 break;
	RJMP _0xE4
; 0000 02D9         case 0b11000111:
_0xF3:
	CPI  R30,LOW(0xC7)
	LDI  R26,HIGH(0xC7)
	CPC  R31,R26
	BREQ _0xF5
; 0000 02DA         case 0b11001111:
	CPI  R30,LOW(0xCF)
	LDI  R26,HIGH(0xCF)
	CPC  R31,R26
	BRNE _0xF6
_0xF5:
; 0000 02DB                 PV = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0xF
; 0000 02DC                 maju();
; 0000 02DD                 break;
	RJMP _0xE4
; 0000 02DE         case 0b11011111:
_0xF6:
	CPI  R30,LOW(0xDF)
	LDI  R26,HIGH(0xDF)
	CPC  R31,R26
	BRNE _0xF7
; 0000 02DF                 PV = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0xF
; 0000 02E0                 maju();
; 0000 02E1                 break;
	RJMP _0xE4
; 0000 02E2         case 0b10001111:
_0xF7:
	CPI  R30,LOW(0x8F)
	LDI  R26,HIGH(0x8F)
	CPC  R31,R26
	BREQ _0xF9
; 0000 02E3         case 0b10011111:
	CPI  R30,LOW(0x9F)
	LDI  R26,HIGH(0x9F)
	CPC  R31,R26
	BRNE _0xFA
_0xF9:
; 0000 02E4                 PV = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0xF
; 0000 02E5                 maju();
; 0000 02E6                 break;
	RJMP _0xE4
; 0000 02E7         case 0b10111111:
_0xFA:
	CPI  R30,LOW(0xBF)
	LDI  R26,HIGH(0xBF)
	CPC  R31,R26
	BRNE _0xFB
; 0000 02E8                 PV = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0xF
; 0000 02E9                 maju();
; 0000 02EA                 break;
	RJMP _0xE4
; 0000 02EB         case 0b00011111:
_0xFB:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BREQ _0xFD
; 0000 02EC         case 0b00111111:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0xFE
_0xFD:
; 0000 02ED                 PV = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0xF
; 0000 02EE                 maju();
; 0000 02EF                 break;
	RJMP _0xE4
; 0000 02F0         case 0b01111111:        // ujung kanan
_0xFE:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0xFF
; 0000 02F1                 PV = 7;
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	CALL SUBOPT_0xF
; 0000 02F2                 maju();
; 0000 02F3                 break;
	RJMP _0xE4
; 0000 02F4         case 0b11111111:        // loss
_0xFF:
	CPI  R30,LOW(0xFF)
	LDI  R26,HIGH(0xFF)
	CPC  R31,R26
	BRNE _0xE4
; 0000 02F5                 //if (PV < -3) {
; 0000 02F6                 if (PV < 0) {
	LDS  R26,_PV+1
	TST  R26
	BRPL _0x101
; 0000 02F7                         // PV = -8;
; 0000 02F8                         lpwm = 150;
	CALL SUBOPT_0x10
; 0000 02F9                         rpwm = 185;
	LDI  R30,LOW(185)
	LDI  R31,HIGH(185)
	CALL SUBOPT_0x11
; 0000 02FA                         bkir();
	RCALL _bkir
; 0000 02FB                         goto exit;
	RJMP _0x102
; 0000 02FC                 //} else if (PV > 3) {
; 0000 02FD                 } else if (PV > 0) {
_0x101:
	LDS  R26,_PV
	LDS  R27,_PV+1
	CALL __CPW02
	BRGE _0x104
; 0000 02FE                         // PV = 8;
; 0000 02FF                         lpwm = 180;
	LDI  R30,LOW(180)
	LDI  R31,HIGH(180)
	CALL SUBOPT_0x12
; 0000 0300                         rpwm = 155;
	LDI  R30,LOW(155)
	LDI  R31,HIGH(155)
	CALL SUBOPT_0x11
; 0000 0301                         bkan();
	RCALL _bkan
; 0000 0302                         goto exit;
	RJMP _0x102
; 0000 0303                 } /*else {
; 0000 0304                         PV = 0;
; 0000 0305                         lpwm = MAXPWM - 5;
; 0000 0306                         rpwm = MAXPWM;
; 0000 0307                         maju();
; 0000 0308                 }*/
; 0000 0309     }
_0x104:
_0xE4:
; 0000 030A 
; 0000 030B     error = SP - PV;
	LDS  R30,_SP
	LDI  R31,0
	LDS  R26,_PV
	LDS  R27,_PV+1
	SUB  R30,R26
	SBC  R31,R27
	STS  _error,R30
	STS  _error+1,R31
; 0000 030C     P = (var_Kp * error) / 10;
	CALL SUBOPT_0x13
	LDS  R26,_var_Kp
	LDS  R27,_var_Kp+1
	CALL SUBOPT_0x14
	STS  _P,R30
	STS  _P+1,R31
; 0000 030D 
; 0000 030E     I = I + error;
	CALL SUBOPT_0x13
	LDS  R26,_I
	LDS  R27,_I+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _I,R30
	STS  _I+1,R31
; 0000 030F     I = (I * var_Ki) / 10;
	LDS  R30,_var_Ki
	LDS  R31,_var_Ki+1
	LDS  R26,_I
	LDS  R27,_I+1
	CALL SUBOPT_0x14
	STS  _I,R30
	STS  _I+1,R31
; 0000 0310 
; 0000 0311     rate = error - last_error;
	LDS  R26,_last_error
	LDS  R27,_last_error+1
	CALL SUBOPT_0x13
	SUB  R30,R26
	SBC  R31,R27
	STS  _rate,R30
	STS  _rate+1,R31
; 0000 0312     D    = (rate * var_Kd) / 10;
	LDS  R30,_var_Kd
	LDS  R31,_var_Kd+1
	LDS  R26,_rate
	LDS  R27,_rate+1
	CALL SUBOPT_0x14
	STS  _D,R30
	STS  _D+1,R31
; 0000 0313 
; 0000 0314     last_error = error;
	CALL SUBOPT_0x13
	STS  _last_error,R30
	STS  _last_error+1,R31
; 0000 0315 
; 0000 0316     MV = P + I + D;
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
; 0000 0317 
; 0000 0318     if (MV == 0) {
	CALL SUBOPT_0x15
	SBIW R30,0
	BRNE _0x105
; 0000 0319          lpwm = MAXPWM - diffPWM;
	LDS  R30,_diffPWM
	LDI  R31,0
	CALL SUBOPT_0x16
	STS  _lpwm,R26
	STS  _lpwm+1,R27
; 0000 031A          rpwm = MAXPWM;
	RJMP _0x14E
; 0000 031B     } else if (MV > 0) { // alihkan ke kiri
_0x105:
	CALL SUBOPT_0x17
	CALL __CPW02
	BRGE _0x107
; 0000 031C         rpwm = MAXPWM - ((intervalPWM - 20) * MV);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x16
	STS  _rpwm,R26
	STS  _rpwm+1,R27
; 0000 031D         lpwm = (MAXPWM - (intervalPWM * MV) - 15) - diffPWM;
	CALL SUBOPT_0x19
	CALL SUBOPT_0x16
	SBIW R26,15
	LDS  R30,_diffPWM
	LDI  R31,0
	SUB  R26,R30
	SBC  R27,R31
	STS  _lpwm,R26
	STS  _lpwm+1,R27
; 0000 031E 
; 0000 031F         //rpwm = MAXPWM - ((intervalPWM - 12) * MV);
; 0000 0320         //lpwm = (MAXPWM - (intervalPWM * MV)) - diffPWM;
; 0000 0321 
; 0000 0322         if (lpwm < MINPWM) lpwm = MINPWM;
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x108
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x12
; 0000 0323         if (lpwm > MAXPWM) lpwm = MAXPWM;
_0x108:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1B
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x109
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x12
; 0000 0324         if (rpwm < MINPWM) rpwm = MINPWM;
_0x109:
	CALL SUBOPT_0x1D
	BRGE _0x10A
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x11
; 0000 0325         if (rpwm > MAXPWM) rpwm = MAXPWM;
_0x10A:
	CALL SUBOPT_0x1E
	BRGE _0x10B
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x11
; 0000 0326     } else if (MV < 0) { // alihkan ke kanan
_0x10B:
	RJMP _0x10C
_0x107:
	LDS  R26,_MV+1
	TST  R26
	BRPL _0x10D
; 0000 0327         lpwm = MAXPWM + ( ( intervalPWM - 20 ) * MV);
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x12
; 0000 0328         rpwm = MAXPWM + ( ( intervalPWM * MV ) - 15 );
	CALL SUBOPT_0x19
	SBIW R30,15
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x11
; 0000 0329 
; 0000 032A         if (lpwm < MINPWM) lpwm = MINPWM;
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x10E
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x12
; 0000 032B         if (lpwm > MAXPWM) lpwm = MAXPWM;
_0x10E:
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1B
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x10F
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x12
; 0000 032C         if (rpwm < MINPWM) rpwm = MINPWM;
_0x10F:
	CALL SUBOPT_0x1D
	BRGE _0x110
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x11
; 0000 032D         if (rpwm > MAXPWM) rpwm = MAXPWM;
_0x110:
	CALL SUBOPT_0x1E
	BRGE _0x111
_0x14E:
	LDS  R30,_MAXPWM
	LDS  R31,_MAXPWM+1
	CALL SUBOPT_0x11
; 0000 032E 
; 0000 032F         //lpwm = MAXPWM + ( ((intervalPWM - 12) + 5) * MV);
; 0000 0330         //rpwm = MAXPWM + ((intervalPWM * MV) * MV);
; 0000 0331     }
_0x111:
; 0000 0332 
; 0000 0333     exit:
_0x10D:
_0x10C:
_0x102:
; 0000 0334     //debug pwm
; 0000 0335     sprintf(lcd_buffer,"%d   %d",lpwm, rpwm);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,357
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_lpwm
	LDS  R31,_lpwm+1
	CALL __CWD1
	CALL __PUTPARD1
	LDS  R30,_rpwm
	LDS  R31,_rpwm+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 0336     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1
; 0000 0337     lcd_putsf("                ");
	__POINTW1FN _0x0,365
	CALL SUBOPT_0x2
; 0000 0338     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1
; 0000 0339     lcd_puts(lcd_buffer);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 033A     delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x7
; 0000 033B 
; 0000 033C     /*debug MV
; 0000 033D     sprintf(lcd_buffer,"MV:%d",MV);
; 0000 033E     lcd_gotoxy(0,0);
; 0000 033F     lcd_putsf("                ");
; 0000 0340     lcd_gotoxy(0,0);
; 0000 0341     lcd_puts(lcd_buffer);
; 0000 0342     delay_ms(10); */
; 0000 0343 
; 0000 0344 }
	RET
;
;int hitungSiku;
;void ketemuSiku(unsigned char belokKanan) {
; 0000 0347 void ketemuSiku(unsigned char belokKanan) {
_ketemuSiku:
; 0000 0348     stop();
;	belokKanan -> Y+0
	RCALL _stop
; 0000 0349 
; 0000 034A     lpwm = 120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x12
; 0000 034B     rpwm = 120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x11
; 0000 034C     mundur();
	RCALL _mundur
; 0000 034D 
; 0000 034E loopSiku:
_0x112:
; 0000 034F     if ( !sKi ) goto keluarSiku_;
	SBIS 0x10,0
	RJMP _0x114
; 0000 0350     if ( !sKa ) goto keluarSiku_;
	SBIS 0x10,1
	RJMP _0x114
; 0000 0351     if ( sensor != 0xff ) goto keluarSiku_;
	LDI  R30,LOW(255)
	CP   R30,R13
	BREQ _0x112
; 0000 0352     goto loopSiku;
; 0000 0353 
; 0000 0354 keluarSiku_:
_0x114:
; 0000 0355     stop();
	RCALL _stop
; 0000 0356     lpwm = 150;
	CALL SUBOPT_0x10
; 0000 0357     rpwm = 155;
	LDI  R30,LOW(155)
	LDI  R31,HIGH(155)
	CALL SUBOPT_0x11
; 0000 0358 
; 0000 0359     if ( belokKanan ) {
	LD   R30,Y
	CPI  R30,0
	BREQ _0x117
; 0000 035A         while (sensor == 0xff) {
_0x118:
	LDI  R30,LOW(255)
	CP   R30,R13
	BRNE _0x11A
; 0000 035B                 bkan();
	RCALL _bkan
; 0000 035C         }
	RJMP _0x118
_0x11A:
; 0000 035D     } else {
	RJMP _0x11B
_0x117:
; 0000 035E         while (sensor == 0xff) {
_0x11C:
	LDI  R30,LOW(255)
	CP   R30,R13
	BRNE _0x11E
; 0000 035F                 bkir();
	RCALL _bkir
; 0000 0360         }
	RJMP _0x11C
_0x11E:
; 0000 0361     }
_0x11B:
; 0000 0362 keluarSiku:
; 0000 0363     for (hitungSiku = 0; hitungSiku < 150; hitungSiku++) {
	LDI  R30,LOW(0)
	STS  _hitungSiku,R30
	STS  _hitungSiku+1,R30
_0x121:
	LDS  R26,_hitungSiku
	LDS  R27,_hitungSiku+1
	CPI  R26,LOW(0x96)
	LDI  R30,HIGH(0x96)
	CPC  R27,R30
	BRGE _0x122
; 0000 0364         scanBlackLine();
	RCALL _scanBlackLine
; 0000 0365         delay_ms(1);
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x7
; 0000 0366     }
	LDI  R26,LOW(_hitungSiku)
	LDI  R27,HIGH(_hitungSiku)
	CALL SUBOPT_0x20
	RJMP _0x121
_0x122:
; 0000 0367 }
	JMP  _0x2080001
;
;
;void main(void)
; 0000 036B {
_main:
; 0000 036C // Declare your local variables here
; 0000 036D 
; 0000 036E // Input/Output Ports initialization
; 0000 036F // Port A initialization
; 0000 0370 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0371 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0372 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0373 DDRA=0x00;
	OUT  0x1A,R30
; 0000 0374 
; 0000 0375 // Port B initialization
; 0000 0376 // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0377 // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0378 PORTB=0x00;
	OUT  0x18,R30
; 0000 0379 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 037A 
; 0000 037B // Port C initialization
; 0000 037C // Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 037D // State7=P State6=P State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 037E PORTC=0b00000011;
	LDI  R30,LOW(3)
	OUT  0x15,R30
; 0000 037F DDRC=0x11111100;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0380 
; 0000 0381 // Port D initialization
; 0000 0382 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0383 // State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 0384 PORTD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 0385 DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0386 
; 0000 0387 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0388 TIMSK=0x41;
	LDI  R30,LOW(65)
	OUT  0x39,R30
; 0000 0389 
; 0000 038A // Analog Comparator initialization
; 0000 038B // Analog Comparator: Off
; 0000 038C // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 038D ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 038E SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 038F 
; 0000 0390 // ADC initialization
; 0000 0391 // ADC Clock frequency: 750.000 kHz
; 0000 0392 // ADC Voltage Reference: AREF pin
; 0000 0393 // ADC Auto Trigger Source: ADC Stopped
; 0000 0394 // Only the 8 most significant bits of
; 0000 0395 // the AD conversion result are used
; 0000 0396 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0397 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0398 
; 0000 0399 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 039A 
; 0000 039B /* define user character 0 */
; 0000 039C define_char(char0,0);
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _define_char
; 0000 039D 
; 0000 039E // stop motor
; 0000 039F TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 03A0 stop();
	RCALL _stop
; 0000 03A1 
; 0000 03A2 BL = 1;
	SBI  0x18,3
; 0000 03A3 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x7
; 0000 03A4 BL = 0;
	CBI  0x18,3
; 0000 03A5 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x7
; 0000 03A6 BL = 1;
	SBI  0x18,3
; 0000 03A7 
; 0000 03A8 showMenu();
	RCALL _showMenu
; 0000 03A9 
; 0000 03AA // Timer/Counter 0 initialization
; 0000 03AB // Clock source: System Clock
; 0000 03AC // Clock value: 11.719 kHz
; 0000 03AD // Mode: Normal top=0xFF
; 0000 03AE // OC0 output: Disconnected
; 0000 03AF TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 03B0 TCNT0=0x00;
	LDI  R30,LOW(0)
	OUT  0x32,R30
; 0000 03B1 OCR0=0x00;
	OUT  0x3C,R30
; 0000 03B2 
; 0000 03B3 // Timer/Counter 2 initialization
; 0000 03B4 // Clock source: System Clock
; 0000 03B5 // Clock value: 11.719 kHz
; 0000 03B6 // Mode: Normal top=0xFF
; 0000 03B7 // OC2 output: Disconnected
; 0000 03B8 ASSR=0x00;
	OUT  0x22,R30
; 0000 03B9 TCCR2=0x07;
	LDI  R30,LOW(7)
	OUT  0x25,R30
; 0000 03BA TCNT2=0xFF;
	LDI  R30,LOW(255)
	OUT  0x24,R30
; 0000 03BB OCR2=0x00;
	LDI  R30,LOW(0)
	OUT  0x23,R30
; 0000 03BC 
; 0000 03BD // read eeprom
; 0000 03BE var_Kp  = Kp;
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL SUBOPT_0x21
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
; 0000 03BF var_Ki  = Ki;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL SUBOPT_0x21
	STS  _var_Ki,R30
	STS  _var_Ki+1,R31
; 0000 03C0 var_Kd  = Kd;
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL SUBOPT_0x21
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
; 0000 03C1 MAXPWM = (int)MAXSpeed + 1;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL SUBOPT_0x21
	ADIW R30,1
	STS  _MAXPWM,R30
	STS  _MAXPWM+1,R31
; 0000 03C2 MINPWM = MINSpeed;
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x21
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
; 0000 03C3 
; 0000 03C4 intervalPWM = (MAXSpeed - MINSpeed) / 8;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL __EEPROMRDB
	MOV  R0,R30
	CLR  R1
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x21
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	STS  _intervalPWM,R30
	STS  _intervalPWM+1,R31
; 0000 03C5 PV = 0;
	LDI  R30,LOW(0)
	STS  _PV,R30
	STS  _PV+1,R30
; 0000 03C6 error = 0;
	STS  _error,R30
	STS  _error+1,R30
; 0000 03C7 last_error = 0;
	STS  _last_error,R30
	STS  _last_error+1,R30
; 0000 03C8 
; 0000 03C9 BL = 0;
	CBI  0x18,3
; 0000 03CA 
; 0000 03CB TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 03CC #asm("sei")
	sei
; 0000 03CD 
; 0000 03CE maju();
	RCALL _maju
; 0000 03CF while (1)
_0x12B:
; 0000 03D0       {
; 0000 03D1        displaySensorBit();
	RCALL _displaySensorBit
; 0000 03D2        if ( (!sKi) && (sensor==0xff) ) {
	SBIC 0x10,0
	RJMP _0x12F
	LDI  R30,LOW(255)
	CP   R30,R13
	BREQ _0x130
_0x12F:
	RJMP _0x12E
_0x130:
; 0000 03D3          ketemuSiku(0);
	LDI  R30,LOW(0)
	RJMP _0x14F
; 0000 03D4          goto scan01;
; 0000 03D5        }
; 0000 03D6        if ( (!sKa) && (sensor==0xff) ) {
_0x12E:
	SBIC 0x10,1
	RJMP _0x133
	LDI  R30,LOW(255)
	CP   R30,R13
	BREQ _0x134
_0x133:
	RJMP _0x132
_0x134:
; 0000 03D7         ketemuSiku(1);
	LDI  R30,LOW(1)
_0x14F:
	ST   -Y,R30
	RCALL _ketemuSiku
; 0000 03D8        }
; 0000 03D9     scan01:
_0x132:
; 0000 03DA        scanBlackLine();
	RCALL _scanBlackLine
; 0000 03DB       };
	RJMP _0x12B
; 0000 03DC }
_0x135:
	RJMP _0x135
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
	CALL SUBOPT_0x20
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x20
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
	CALL SUBOPT_0x22
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x23
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x24
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x23
	CALL SUBOPT_0x25
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
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
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
	CALL SUBOPT_0x23
	CALL SUBOPT_0x26
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
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x24
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x24
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
	CALL SUBOPT_0x27
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
	CALL SUBOPT_0x27
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
	CALL SUBOPT_0x28
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
	CALL SUBOPT_0x29
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x29
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
	CALL SUBOPT_0x28
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
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2A
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
_s0_cent:
	.BYTE 0x1
_s1_cent:
	.BYTE 0x1
_s2_cent:
	.BYTE 0x1
_s3_cent:
	.BYTE 0x1
_s4_cent:
	.BYTE 0x1
_s5_cent:
	.BYTE 0x1
_s6_cent:
	.BYTE 0x1
_s7_cent:
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

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x0:
	CALL __DIVW21
	MOV  R17,R30
	SUBI R17,-LOW(48)
	ST   -Y,R17
	CALL _lcd_putchar
	LDD  R26,Y+1
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 24 TIMES, CODE SIZE REDUCTION:43 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x3:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(32)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0xB:
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _tampil
	RJMP SUBOPT_0xA

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	CALL _setByte
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDS  R26,_xcount
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0xF:
	STS  _PV,R30
	STS  _PV+1,R31
	JMP  _maju

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x11:
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x12:
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDS  R30,_error
	LDS  R31,_error+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14:
	CALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDS  R30,_MV
	LDS  R31,_MV+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDS  R26,_MAXPWM
	LDS  R27,_MAXPWM+1
	SUB  R26,R30
	SBC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x17:
	LDS  R26,_MV
	LDS  R27,_MV+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	LDS  R30,_intervalPWM
	LDS  R31,_intervalPWM+1
	SBIW R30,20
	RCALL SUBOPT_0x17
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x19:
	RCALL SUBOPT_0x15
	LDS  R26,_intervalPWM
	LDS  R27,_intervalPWM+1
	CALL __MULW12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1A:
	LDS  R30,_MINPWM
	LDS  R31,_MINPWM+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	LDS  R26,_lpwm
	LDS  R27,_lpwm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1C:
	LDS  R30,_MAXPWM
	LDS  R31,_MAXPWM+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	RCALL SUBOPT_0x1A
	LDS  R26,_rpwm
	LDS  R27,_rpwm+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	RCALL SUBOPT_0x1C
	LDS  R26,_rpwm
	LDS  R27,_rpwm+1
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDS  R26,_MAXPWM
	LDS  R27,_MAXPWM+1
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x21:
	CALL __EEPROMRDB
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x22:
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
SUBOPT_0x23:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x24:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x25:
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
SUBOPT_0x26:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	SBI  0x18,0
	LD   R30,Y
	ST   -Y,R30
	CALL __lcd_write_data
	CBI  0x18,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x29:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
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
