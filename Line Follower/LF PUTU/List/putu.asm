
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 11.059200 MHz
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
	.DEF _xcount=R5
	.DEF _lpwm=R4
	.DEF _rpwm=R7
	.DEF _i=R6
	.DEF _sensor=R9
	.DEF _j=R10
	.DEF _d_error=R12

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

_0x66:
	.DB  0x4
_0x67:
	.DB  0xA
_0x68:
	.DB  0x1
_0x9E:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  _Kp
	.DW  _0x66*2

	.DW  0x01
	.DW  _Kd
	.DW  _0x67*2

	.DW  0x01
	.DW  _intervalPWM
	.DW  _0x68*2

	.DW  0x08
	.DW  0x04
	.DW  _0x9E*2

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
;Date    : 11/23/2012
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
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
;
;#include <delay.h>
;
;#define T1      PINB.0
;#define T2      PINB.1
;#define T3      PINB.3
;#define T4      PINB.4
;
;#define PWM_KA          PORTC.5
;#define PWM_KI          PORTC.4
;#define MAJU_KA         PORTC.3
;#define MUNDUR_KA       PORTC.2
;#define MAJU_KI         PORTC.1
;#define MUNDUR_KI       PORTC.0
;
;#define LED_IND_1       PORTD.0
;
;// Timer 0 overflow interrupt service routine
;unsigned char xcount=0;
;unsigned char lpwm=0;
;unsigned char rpwm=0;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 002F {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 0030         // Place your code here
; 0000 0031         xcount++;
	INC  R5
; 0000 0032         if(xcount<lpwm) PWM_KI = 1;
	CP   R5,R4
	BRSH _0x3
	SBI  0x15,4
; 0000 0033         else PWM_KI = 0;
	RJMP _0x6
_0x3:
	CBI  0x15,4
; 0000 0034 
; 0000 0035         if(xcount<rpwm) PWM_KA = 1;
_0x6:
	CP   R5,R7
	BRSH _0x9
	SBI  0x15,5
; 0000 0036         else PWM_KA = 0;
	RJMP _0xC
_0x9:
	CBI  0x15,5
; 0000 0037 
; 0000 0038         if(xcount>255) xcount = 0;
_0xC:
	LDI  R30,LOW(255)
	CP   R30,R5
	BRSH _0xF
	CLR  R5
; 0000 0039 
; 0000 003A         TCNT0 = 0xff;
_0xF:
	LDI  R30,LOW(255)
	OUT  0x32,R30
; 0000 003B }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;#define ADC_VREF_TYPE 0x20
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0042 {
_read_adc:
; 0000 0043         ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 0044         // Delay needed for the stabilization of the ADC input voltage
; 0000 0045         delay_us(10);
	__DELAY_USB 37
; 0000 0046         // Start the AD conversion
; 0000 0047         ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0048         // Wait for the AD conversion to complete
; 0000 0049         while ((ADCSRA & 0x10)==0);
_0x10:
	SBIS 0x6,4
	RJMP _0x10
; 0000 004A         ADCSRA|=0x10;
	SBI  0x6,4
; 0000 004B         return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 004C }
;
;// Declare your global variables here
;char i=0;
;unsigned char sensor = 0;
;eeprom int cenlimit[8];
;void baca_sensor(void)
; 0000 0053 {
; 0000 0054         sensor = 0;
; 0000 0055         for(i=2;i<8;i++)
; 0000 0056         {
; 0000 0057                 if(read_adc(i) < cenlimit[i])   {sensor = sensor + (1 << (i-1));}
; 0000 0058                 else                            {sensor = sensor + (0 << (i-1));}
; 0000 0059         }
; 0000 005A 
; 0000 005B         if(read_adc(1) < cenlimit[1])   {sensor = sensor + (1 << 0);}
; 0000 005C         else                            {sensor = sensor + (0 << 0);}
; 0000 005D 
; 0000 005E         if(read_adc(0) < cenlimit[0])   {sensor = sensor + (1 << 7);}
; 0000 005F         else                            {sensor = sensor + (0 << 7);}
; 0000 0060 }
;
;eeprom int lowlimit1=200,lowlimit2=200,lowlimit3=200,lowlimit4=200,lowlimit5=200,lowlimit6=200,lowlimit7=200,lowlimit8=200;
;eeprom int uplimit1=10,uplimit2=10,uplimit3=10,uplimit4=10,uplimit5=10,uplimit6=10,uplimit7=10,uplimit8=10;
;int j = 0;
;void calibrate_sensor(void)
; 0000 0066 {
_calibrate_sensor:
; 0000 0067         unsigned char temp_s[8];
; 0000 0068 
; 0000 0069         #asm("cli")
	SBIW R28,8
;	temp_s -> Y+0
	cli
; 0000 006A         delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 006B         LED_IND_1 = 1;
	SBI  0x12,0
; 0000 006C         delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 006D         LED_IND_1 = 0;
	CBI  0x12,0
; 0000 006E         for(j=0;j<1000;j++)
	CLR  R10
	CLR  R11
_0x21:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R10,R30
	CPC  R11,R31
	BRLT PC+3
	JMP _0x22
; 0000 006F         {
; 0000 0070                 for(i=0;i<8;i++)
	CLR  R6
_0x24:
	LDI  R30,LOW(8)
	CP   R6,R30
	BRSH _0x25
; 0000 0071                 {
; 0000 0072                         temp_s[i] = read_adc(i);
	MOV  R30,R6
	LDI  R31,0
	MOVW R26,R28
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	ST   -Y,R6
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0073                 }
	INC  R6
	RJMP _0x24
_0x25:
; 0000 0074 
; 0000 0075                 if(temp_s[1-1] < lowlimit1)     lowlimit1=temp_s[1-1];
	LDI  R26,LOW(_lowlimit1)
	LDI  R27,HIGH(_lowlimit1)
	RCALL SUBOPT_0x1
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x26
	LD   R30,Y
	LDI  R26,LOW(_lowlimit1)
	LDI  R27,HIGH(_lowlimit1)
	RCALL SUBOPT_0x2
; 0000 0076                 if(temp_s[1-1] > uplimit1)      uplimit1=temp_s[1-1];
_0x26:
	LDI  R26,LOW(_uplimit1)
	LDI  R27,HIGH(_uplimit1)
	RCALL SUBOPT_0x1
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x27
	LD   R30,Y
	LDI  R26,LOW(_uplimit1)
	LDI  R27,HIGH(_uplimit1)
	RCALL SUBOPT_0x2
; 0000 0077 
; 0000 0078                 if(temp_s[2-1] < lowlimit2)     lowlimit2=temp_s[2-1];
_0x27:
	LDI  R26,LOW(_lowlimit2)
	LDI  R27,HIGH(_lowlimit2)
	RCALL SUBOPT_0x3
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x28
	LDD  R30,Y+1
	LDI  R26,LOW(_lowlimit2)
	LDI  R27,HIGH(_lowlimit2)
	RCALL SUBOPT_0x2
; 0000 0079                 if(temp_s[2-1] > uplimit2)      uplimit2=temp_s[2-1];
_0x28:
	LDI  R26,LOW(_uplimit2)
	LDI  R27,HIGH(_uplimit2)
	RCALL SUBOPT_0x3
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x29
	LDD  R30,Y+1
	LDI  R26,LOW(_uplimit2)
	LDI  R27,HIGH(_uplimit2)
	RCALL SUBOPT_0x2
; 0000 007A 
; 0000 007B                 if(temp_s[3-1] < lowlimit3)     lowlimit3=temp_s[3-1];
_0x29:
	LDI  R26,LOW(_lowlimit3)
	LDI  R27,HIGH(_lowlimit3)
	RCALL SUBOPT_0x4
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x2A
	LDD  R30,Y+2
	LDI  R26,LOW(_lowlimit3)
	LDI  R27,HIGH(_lowlimit3)
	RCALL SUBOPT_0x2
; 0000 007C                 if(temp_s[3-1] > uplimit3)      uplimit3=temp_s[3-1];
_0x2A:
	LDI  R26,LOW(_uplimit3)
	LDI  R27,HIGH(_uplimit3)
	RCALL SUBOPT_0x4
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2B
	LDD  R30,Y+2
	LDI  R26,LOW(_uplimit3)
	LDI  R27,HIGH(_uplimit3)
	RCALL SUBOPT_0x2
; 0000 007D 
; 0000 007E                 if(temp_s[4-1] < lowlimit4)     lowlimit4=temp_s[4-1];
_0x2B:
	LDI  R26,LOW(_lowlimit4)
	LDI  R27,HIGH(_lowlimit4)
	RCALL SUBOPT_0x5
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x2C
	LDD  R30,Y+3
	LDI  R26,LOW(_lowlimit4)
	LDI  R27,HIGH(_lowlimit4)
	RCALL SUBOPT_0x2
; 0000 007F                 if(temp_s[4-1] > uplimit4)      uplimit4=temp_s[4-1];
_0x2C:
	LDI  R26,LOW(_uplimit4)
	LDI  R27,HIGH(_uplimit4)
	RCALL SUBOPT_0x5
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2D
	LDD  R30,Y+3
	LDI  R26,LOW(_uplimit4)
	LDI  R27,HIGH(_uplimit4)
	RCALL SUBOPT_0x2
; 0000 0080 
; 0000 0081                 if(temp_s[5-1] < lowlimit5)     lowlimit5=temp_s[5-1];
_0x2D:
	LDI  R26,LOW(_lowlimit5)
	LDI  R27,HIGH(_lowlimit5)
	RCALL SUBOPT_0x6
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x2E
	LDD  R30,Y+4
	LDI  R26,LOW(_lowlimit5)
	LDI  R27,HIGH(_lowlimit5)
	RCALL SUBOPT_0x2
; 0000 0082                 if(temp_s[5-1] > uplimit5)      uplimit5=temp_s[5-1];
_0x2E:
	LDI  R26,LOW(_uplimit5)
	LDI  R27,HIGH(_uplimit5)
	RCALL SUBOPT_0x6
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x2F
	LDD  R30,Y+4
	LDI  R26,LOW(_uplimit5)
	LDI  R27,HIGH(_uplimit5)
	RCALL SUBOPT_0x2
; 0000 0083 
; 0000 0084                 if(temp_s[6-1] < lowlimit6)     lowlimit6=temp_s[6-1];
_0x2F:
	LDI  R26,LOW(_lowlimit6)
	LDI  R27,HIGH(_lowlimit6)
	RCALL SUBOPT_0x7
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x30
	LDD  R30,Y+5
	LDI  R26,LOW(_lowlimit6)
	LDI  R27,HIGH(_lowlimit6)
	RCALL SUBOPT_0x2
; 0000 0085                 if(temp_s[6-1] > uplimit6)      uplimit6=temp_s[6-1];
_0x30:
	LDI  R26,LOW(_uplimit6)
	LDI  R27,HIGH(_uplimit6)
	RCALL SUBOPT_0x7
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x31
	LDD  R30,Y+5
	LDI  R26,LOW(_uplimit6)
	LDI  R27,HIGH(_uplimit6)
	RCALL SUBOPT_0x2
; 0000 0086 
; 0000 0087                 if(temp_s[7-1] < lowlimit7)     lowlimit7=temp_s[7-1];
_0x31:
	LDI  R26,LOW(_lowlimit7)
	LDI  R27,HIGH(_lowlimit7)
	RCALL SUBOPT_0x8
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x32
	LDD  R30,Y+6
	LDI  R26,LOW(_lowlimit7)
	LDI  R27,HIGH(_lowlimit7)
	RCALL SUBOPT_0x2
; 0000 0088                 if(temp_s[7-1] > uplimit7)      uplimit7=temp_s[7-1];
_0x32:
	LDI  R26,LOW(_uplimit7)
	LDI  R27,HIGH(_uplimit7)
	RCALL SUBOPT_0x8
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x33
	LDD  R30,Y+6
	LDI  R26,LOW(_uplimit7)
	LDI  R27,HIGH(_uplimit7)
	RCALL SUBOPT_0x2
; 0000 0089 
; 0000 008A                 if(temp_s[8-1] < lowlimit8)     lowlimit8=temp_s[8-1];
_0x33:
	LDI  R26,LOW(_lowlimit8)
	LDI  R27,HIGH(_lowlimit8)
	RCALL SUBOPT_0x9
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x34
	LDD  R30,Y+7
	LDI  R26,LOW(_lowlimit8)
	LDI  R27,HIGH(_lowlimit8)
	RCALL SUBOPT_0x2
; 0000 008B                 if(temp_s[8-1] > uplimit8)      uplimit8=temp_s[8-1];
_0x34:
	LDI  R26,LOW(_uplimit8)
	LDI  R27,HIGH(_uplimit8)
	RCALL SUBOPT_0x9
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x35
	LDD  R30,Y+7
	LDI  R26,LOW(_uplimit8)
	LDI  R27,HIGH(_uplimit8)
	RCALL SUBOPT_0x2
; 0000 008C 
; 0000 008D                 delay_ms(10);
_0x35:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 008E         }
	MOVW R30,R10
	ADIW R30,1
	MOVW R10,R30
	RJMP _0x21
_0x22:
; 0000 008F 
; 0000 0090         cenlimit[0] = (lowlimit1 + uplimit1) / 2;
	LDI  R26,LOW(_lowlimit1)
	LDI  R27,HIGH(_lowlimit1)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_uplimit1)
	LDI  R27,HIGH(_uplimit1)
	RCALL SUBOPT_0xA
	LDI  R26,LOW(_cenlimit)
	LDI  R27,HIGH(_cenlimit)
	CALL __EEPROMWRW
; 0000 0091         cenlimit[1] = (lowlimit2 + uplimit2) / 2;
	__POINTWRMN 22,23,_cenlimit,2
	LDI  R26,LOW(_lowlimit2)
	LDI  R27,HIGH(_lowlimit2)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_uplimit2)
	LDI  R27,HIGH(_uplimit2)
	RCALL SUBOPT_0xA
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 0092         cenlimit[2] = (lowlimit3 + uplimit3) / 2;
	__POINTWRMN 22,23,_cenlimit,4
	LDI  R26,LOW(_lowlimit3)
	LDI  R27,HIGH(_lowlimit3)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_uplimit3)
	LDI  R27,HIGH(_uplimit3)
	RCALL SUBOPT_0xA
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 0093         cenlimit[3] = (lowlimit4 + uplimit4) / 2;
	__POINTWRMN 22,23,_cenlimit,6
	LDI  R26,LOW(_lowlimit4)
	LDI  R27,HIGH(_lowlimit4)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_uplimit4)
	LDI  R27,HIGH(_uplimit4)
	RCALL SUBOPT_0xA
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 0094         cenlimit[4] = (lowlimit5 + uplimit5) / 2;
	__POINTWRMN 22,23,_cenlimit,8
	LDI  R26,LOW(_lowlimit5)
	LDI  R27,HIGH(_lowlimit5)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_uplimit5)
	LDI  R27,HIGH(_uplimit5)
	RCALL SUBOPT_0xA
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 0095         cenlimit[5] = (lowlimit6 + uplimit6) / 2;
	__POINTWRMN 22,23,_cenlimit,10
	LDI  R26,LOW(_lowlimit6)
	LDI  R27,HIGH(_lowlimit6)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_uplimit6)
	LDI  R27,HIGH(_uplimit6)
	RCALL SUBOPT_0xA
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 0096         cenlimit[6] = (lowlimit7 + uplimit7) / 2;
	__POINTWRMN 22,23,_cenlimit,12
	LDI  R26,LOW(_lowlimit7)
	LDI  R27,HIGH(_lowlimit7)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_uplimit7)
	LDI  R27,HIGH(_uplimit7)
	RCALL SUBOPT_0xA
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 0097         cenlimit[7] = (lowlimit8 + uplimit8) / 2;
	__POINTWRMN 22,23,_cenlimit,14
	LDI  R26,LOW(_lowlimit8)
	LDI  R27,HIGH(_lowlimit8)
	CALL __EEPROMRDW
	MOVW R0,R30
	LDI  R26,LOW(_uplimit8)
	LDI  R27,HIGH(_uplimit8)
	RCALL SUBOPT_0xA
	MOVW R26,R22
	CALL __EEPROMWRW
; 0000 0098 
; 0000 0099         delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 009A         LED_IND_1 = 1;
	SBI  0x12,0
; 0000 009B         delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 009C         LED_IND_1 = 0;
	CBI  0x12,0
; 0000 009D 
; 0000 009E         delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 009F         LED_IND_1 = 1;
	SBI  0x12,0
; 0000 00A0         delay_ms(500);
	RCALL SUBOPT_0x0
; 0000 00A1         LED_IND_1 = 0;
	CBI  0x12,0
; 0000 00A2 
; 0000 00A3         #asm("sei")
	sei
; 0000 00A4 }
	ADIW R28,8
	RET
;
;void maju(void)
; 0000 00A7 {
_maju:
; 0000 00A8         MAJU_KA = 1;
	SBI  0x15,3
; 0000 00A9         MAJU_KI = 1;
	SBI  0x15,1
; 0000 00AA         MUNDUR_KA = 0;
	RJMP _0x2000001
; 0000 00AB         MUNDUR_KI = 0;
; 0000 00AC }
;
;void maju_ka(void)
; 0000 00AF {
; 0000 00B0         MAJU_KA = 1;
; 0000 00B1         MUNDUR_KA = 0;
; 0000 00B2 }
;
;void maju_ki(void)
; 0000 00B5 {
; 0000 00B6         MAJU_KI = 1;
; 0000 00B7         MUNDUR_KI = 0;
; 0000 00B8 }
;
;void mundur(void)
; 0000 00BB {
; 0000 00BC         MAJU_KA = 0;
; 0000 00BD         MAJU_KI = 0;
; 0000 00BE         MUNDUR_KA = 1;
; 0000 00BF         MUNDUR_KI = 1;
; 0000 00C0 }
;
;void stop (void)
; 0000 00C3 {
_stop:
; 0000 00C4         MAJU_KA = 0;
	CBI  0x15,3
; 0000 00C5         MAJU_KI = 0;
	CBI  0x15,1
; 0000 00C6         MUNDUR_KA = 0;
_0x2000001:
	CBI  0x15,2
; 0000 00C7         MUNDUR_KI = 0;
	CBI  0x15,0
; 0000 00C8 }
	RET
;
;void mundur_ka(void)
; 0000 00CB {
; 0000 00CC         MAJU_KA = 0;
; 0000 00CD         MUNDUR_KA = 1;
; 0000 00CE }
;
;void mundur_ki(void)
; 0000 00D1 {
; 0000 00D2         MAJU_KI = 0;
; 0000 00D3         MUNDUR_KI = 1;
; 0000 00D4 }
;
;void bkan(void)
; 0000 00D7 {
; 0000 00D8         stop();
; 0000 00D9         maju_ki();
; 0000 00DA }
;
;void bkir(void)
; 0000 00DD {
; 0000 00DE         stop();
; 0000 00DF         maju_ka();
; 0000 00E0 }
;
;void rotkan(void)
; 0000 00E3 {
; 0000 00E4         maju_ki();
; 0000 00E5         mundur_ka();
; 0000 00E6 }
;
;void rotkir(void)
; 0000 00E9 {
; 0000 00EA         mundur_ki();
; 0000 00EB         maju_ka();
; 0000 00EC }
;
;int d_error,error,last_error = 0,PV,Kp = 4,Kd = 10,intervalPWM = 1;

	.DSEG
;void pid()
; 0000 00F0 {

	.CSEG
; 0000 00F1         baca_sensor();
; 0000 00F2         maju();
; 0000 00F3 
; 0000 00F4         if(sensor==0b00000001)  error = 15;  //kanan
; 0000 00F5         if(sensor==0b00000011)  error = 10;
; 0000 00F6         if(sensor==0b00000010)  error = 5;
; 0000 00F7         if(sensor==0b00000110)  error = 4;
; 0000 00F8         if(sensor==0b00000100)  error = 3;
; 0000 00F9         if(sensor==0b00001100)  error = 2;
; 0000 00FA         if(sensor==0b00001000)  error = 1;
; 0000 00FB 
; 0000 00FC         if(sensor==0b00010000)  error = -1;
; 0000 00FD         if(sensor==0b00110000)  error = -2;
; 0000 00FE         if(sensor==0b00100000)  error = -3;
; 0000 00FF         if(sensor==0b01100000)  error = -4;
; 0000 0100         if(sensor==0b01000000)  error = -5;
; 0000 0101         if(sensor==0b11000000)  error = -10;
; 0000 0102         if(sensor==0b10000000)  error = -15;      //kiri
; 0000 0103 
; 0000 0104         d_error = error - last_error;
; 0000 0105         PV      = (Kp*error)+(Kd*d_error);
; 0000 0106 
; 0000 0107         rpwm = PV + intervalPWM;
; 0000 0108         lpwm = PV - intervalPWM + 20;
; 0000 0109 
; 0000 010A         last_error = error;
; 0000 010B 
; 0000 010C         if(lpwm>=100)       lpwm = 100;
; 0000 010D         if(lpwm<=0)         lpwm = 0;
; 0000 010E 
; 0000 010F         if(rpwm>=100)       rpwm = 100;
; 0000 0110         if(rpwm<=0)         rpwm = 0;
; 0000 0111 }
;
;int x = 0;
;void jalan()
; 0000 0115 {
; 0000 0116         baca_sensor();
; 0000 0117 
; 0000 0118         if(sensor==0b00000001){bkan();rpwm=0;lpwm=90;x=1;}  //kanan
; 0000 0119         if(sensor==0b00000011){bkan();rpwm=0;lpwm=80;x=1;}
; 0000 011A         if(sensor==0b00000010){maju();rpwm=10;lpwm=75;x=1;}
; 0000 011B         if(sensor==0b00000110){maju();rpwm=20;lpwm=75;x=1;}
; 0000 011C         if(sensor==0b00000100){maju();rpwm=35;lpwm=80;x=1;}
; 0000 011D         if(sensor==0b00001100){maju();rpwm=50;lpwm=80;x=1;}
; 0000 011E         if(sensor==0b00001000){maju();rpwm=70;lpwm=80;x=1;}
; 0000 011F 
; 0000 0120         //if(sensor==0b00011000){maju();rpwm=75;lpwm=75;}  //tengah
; 0000 0121 
; 0000 0122         if(sensor==0b00010000){maju();rpwm=80;lpwm=70;x=0;}
; 0000 0123         if(sensor==0b00110000){maju();rpwm=80;lpwm=50;x=0;}
; 0000 0124         if(sensor==0b00100000){maju();rpwm=80;lpwm=35;x=0;}
; 0000 0125         if(sensor==0b01100000){maju();rpwm=75;lpwm=20;x=0;}
; 0000 0126         if(sensor==0b01000000){maju();rpwm=75;lpwm=10;x=0;}
; 0000 0127         if(sensor==0b11000000){bkir();rpwm=80;lpwm=0;x=0;}
; 0000 0128         if(sensor==0b10000000){bkir();rpwm=90;lpwm=0;x=0;}  //kiri
; 0000 0129 
; 0000 012A         if(sensor==0b00000000)                                  //lepas
; 0000 012B     {
; 0000 012C         if(x)
; 0000 012D         {
; 0000 012E             stop();rotkan();rpwm=150;lpwm=150;
; 0000 012F         }
; 0000 0130 
; 0000 0131         else
; 0000 0132         {
; 0000 0133             stop();rotkir();rpwm=150;lpwm=150;
; 0000 0134         }
; 0000 0135     }
; 0000 0136 
; 0000 0137     //sudutkanan
; 0000 0138     sensor&=0b00001011;
; 0000 0139     if(sensor==0b00001011)
; 0000 013A     {
; 0000 013B         stop();
; 0000 013C         delay_ms(2);
; 0000 013D         sensor&=0b00001111;
; 0000 013E         if(sensor==0b00001111)
; 0000 013F         {
; 0000 0140             delay_ms(2);
; 0000 0141             sensor&=0b00001110;
; 0000 0142             if(sensor==0b00001110)
; 0000 0143             {
; 0000 0144                 delay_ms(2);
; 0000 0145                 sensor&=0b00001100;
; 0000 0146                 if(sensor==0b00001100)
; 0000 0147                 {
; 0000 0148                     bkan();rpwm=0;lpwm=250;
; 0000 0149                 }
; 0000 014A             }
; 0000 014B         }
; 0000 014C     }
; 0000 014D 
; 0000 014E 
; 0000 014F     //sudutkiri
; 0000 0150     sensor&=0b11010000;
; 0000 0151     if(sensor==0b11010000)
; 0000 0152     {
; 0000 0153         stop();
; 0000 0154         delay_ms(2);
; 0000 0155         sensor&=0b11110000;
; 0000 0156         if(sensor==0b11110000)
; 0000 0157         {
; 0000 0158             delay_ms(2);
; 0000 0159             sensor&=0b01110000;
; 0000 015A             if(sensor==0b01110000)
; 0000 015B             {
; 0000 015C                 delay_ms(2);
; 0000 015D                 sensor&=0b00110000;
; 0000 015E                 if(sensor==0b00110000)
; 0000 015F                 {
; 0000 0160                     bkir();rpwm=250;lpwm=0;
; 0000 0161                 }
; 0000 0162             }
; 0000 0163         }
; 0000 0164     }
; 0000 0165 
; 0000 0166 
; 0000 0167         //lpwm = lpwm + 20;
; 0000 0168 }
;
;void main(void)
; 0000 016B {
_main:
; 0000 016C         // Declare your local variables here
; 0000 016D 
; 0000 016E         // Input/Output Ports initialization
; 0000 016F         // Port A initialization
; 0000 0170         // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0171         // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0172         PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0173         DDRA=0x00;
	OUT  0x1A,R30
; 0000 0174 
; 0000 0175         // Port B initialization
; 0000 0176         // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0177         // State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 0178         PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 0179         DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 017A 
; 0000 017B         // Port C initialization
; 0000 017C         // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 017D         // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 017E         PORTC=0x00;
	OUT  0x15,R30
; 0000 017F         DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0180 
; 0000 0181         // Port D initialization
; 0000 0182         // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0183         // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0184         PORTD=0x00;
	LDI  R30,LOW(0)
	OUT  0x12,R30
; 0000 0185         DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0186 
; 0000 0187         // Timer/Counter 0 initialization
; 0000 0188         // Clock source: System Clock
; 0000 0189         // Clock value: 62.500 kHz
; 0000 018A         // Mode: Normal top=0xFF
; 0000 018B         // OC0 output: Disconnected
; 0000 018C         TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 018D         TCNT0=0xFF;
	LDI  R30,LOW(255)
	OUT  0x32,R30
; 0000 018E         OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 018F 
; 0000 0190         // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0191         TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0192 
; 0000 0193         // Analog Comparator initialization
; 0000 0194         // Analog Comparator: Off
; 0000 0195         // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0196         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0197         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0198 
; 0000 0199         // ADC initialization
; 0000 019A         // ADC Clock frequency: 1000.000 kHz
; 0000 019B         // ADC Voltage Reference: AREF pin
; 0000 019C         // ADC Auto Trigger Source: ADC Stopped
; 0000 019D         // Only the 8 most significant bits of
; 0000 019E         // the AD conversion result are used
; 0000 019F         ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 01A0         ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 01A1 
; 0000 01A2         // Global enable interrupts
; 0000 01A3         #asm("sei")
	sei
; 0000 01A4 
; 0000 01A5         while (1)
_0x94:
; 0000 01A6         {
; 0000 01A7                 // Place your code here
; 0000 01A8                 if(!T1)
	SBIC 0x16,0
	RJMP _0x97
; 0000 01A9                 {
; 0000 01AA                         delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 01AB                         stop();
	RCALL _stop
; 0000 01AC                         calibrate_sensor();
	RCALL _calibrate_sensor
; 0000 01AD                 }
; 0000 01AE 
; 0000 01AF                 //jalan();
; 0000 01B0                 maju();
_0x97:
	RCALL _maju
; 0000 01B1                 lpwm = 30;
	LDI  R30,LOW(30)
	MOV  R4,R30
; 0000 01B2                 rpwm = 30;
	MOV  R7,R30
; 0000 01B3 
; 0000 01B4                 LED_IND_1 = 1;
	SBI  0x12,0
; 0000 01B5         }
	RJMP _0x94
; 0000 01B6 }
_0x9A:
	RJMP _0x9A

	.ESEG
_cenlimit:
	.BYTE 0x10
_lowlimit1:
	.DW  0xC8
_lowlimit2:
	.DW  0xC8
_lowlimit3:
	.DW  0xC8
_lowlimit4:
	.DW  0xC8
_lowlimit5:
	.DW  0xC8
_lowlimit6:
	.DW  0xC8
_lowlimit7:
	.DW  0xC8
_lowlimit8:
	.DW  0xC8
_uplimit1:
	.DW  0xA
_uplimit2:
	.DW  0xA
_uplimit3:
	.DW  0xA
_uplimit4:
	.DW  0xA
_uplimit5:
	.DW  0xA
_uplimit6:
	.DW  0xA
_uplimit7:
	.DW  0xA
_uplimit8:
	.DW  0xA

	.DSEG
_error:
	.BYTE 0x2
_last_error:
	.BYTE 0x2
_PV:
	.BYTE 0x2
_Kp:
	.BYTE 0x2
_Kd:
	.BYTE 0x2
_intervalPWM:
	.BYTE 0x2
_x:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	CALL __EEPROMRDW
	LD   R26,Y
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x2:
	LDI  R31,0
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	CALL __EEPROMRDW
	LDD  R26,Y+1
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	CALL __EEPROMRDW
	LDD  R26,Y+2
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	CALL __EEPROMRDW
	LDD  R26,Y+3
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	CALL __EEPROMRDW
	LDD  R26,Y+4
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	CALL __EEPROMRDW
	LDD  R26,Y+5
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CALL __EEPROMRDW
	LDD  R26,Y+6
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	CALL __EEPROMRDW
	LDD  R26,Y+7
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0xA:
	CALL __EEPROMRDW
	MOVW R26,R0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET


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

;END OF CODE MARKER
__END_OF_CODE:
