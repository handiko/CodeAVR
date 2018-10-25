
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8535
;Program type             : Application
;Clock frequency          : 11.059200 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 128 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8535
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 607
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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
	.EQU __SRAM_END=0x025F
	.EQU __DSTACK_SIZE=0x0080
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8
	.DEF _tone=R10
	.DEF _fcshi=R13
	.DEF _fcslo=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP _timer0_ovf_isr
	RJMP 0x00
	RJMP _usart_rx_isr
	RJMP 0x00
	RJMP _usart_tx_isr
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_flag:
	.DB  0x7E,0x7E,0x7E,0x7E,0x7E,0x7E,0x7E,0x7E
	.DB  0x7E,0x7E,0x7E,0x7E,0x7E,0x7E,0x7E,0x7E
	.DB  0x7E,0x7E,0x7E,0x7E,0x7E,0x7E,0x7E,0x7E
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x97:
	.DB  0xB0,0x4

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x02
	.DW  0x0A
	.DW  _0x97*2

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

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xE0

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
;Date    : 1/13/2012
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8535
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 128
;*****************************************************/
;
;#include <mega8535.h>
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
;#include <stdio.h>
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;#define RX_BUFFER_SIZE 8
;#define TX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;char tx_buffer[TX_BUFFER_SIZE];
;char GPRMC[100];
;bit rx_buffer_overflow;
;
;#if RX_BUFFER_SIZE<256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;#if TX_BUFFER_SIZE<256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 0035 {	char status,data;

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0036 	status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0037 	data=UDR;
	IN   R16,12
; 0000 0038 	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0039    	{	rx_buffer[rx_wr_index]=data;
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 003A    		if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 003B    		if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
; 0000 003C       	{	rx_counter=0;
	CLR  R7
; 0000 003D       		rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 003E       	};
_0x5:
; 0000 003F    	};
_0x3:
; 0000 0040 }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 0043 {	if (tx_counter)
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	TST  R8
	BREQ _0x6
; 0000 0044    	{	--tx_counter;
	DEC  R8
; 0000 0045    		UDR=tx_buffer[tx_rd_index];
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0046    		if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x7
	CLR  R9
; 0000 0047    	};
_0x7:
_0x6:
; 0000 0048 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 004E {	char data;
_getchar:
; 0000 004F 	while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x8:
	TST  R7
	BREQ _0x8
; 0000 0050 	data=rx_buffer[rx_rd_index];
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 0051 	if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	INC  R4
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0xB
	CLR  R4
; 0000 0052 	#asm("cli")
_0xB:
	cli
; 0000 0053 	--rx_counter;
	DEC  R7
; 0000 0054 	#asm("sei")
	sei
; 0000 0055 	return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0056 }
;#pragma used-
;#endif
;
;#ifndef _DEBUG_TERMINAL_IO_
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 005E {	while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
; 0000 005F 	#asm("cli")
; 0000 0060 	if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
; 0000 0061    	{	tx_buffer[tx_wr_index]=c;
; 0000 0062    		if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
; 0000 0063    		++tx_counter;
; 0000 0064    	}
; 0000 0065 	else
; 0000 0066    	UDR=c;
; 0000 0067 	#asm("sei")
; 0000 0068 }
;#pragma used-
;#endif
;
;#include <string.h>
;#include <ctype.h>
;#include <delay.h>
;
;#define DAC_0	PORTB.0
;#define DAC_1	PORTB.1
;#define DAC_2	PORTB.2
;#define DAC_3	PORTB.3
;
;#define PTT	PORTB.4
;
;#define STBY_LED	PORTD.3
;#define TX_LED		PORTD.4
;#define AUX_LED		PORTD.5
;
;#define MODE	PIND.6
;#define TX_NOW	PIND.7
;
;#define on	1
;#define off 0
;
;#define PTT_ON	(PTT = on)
;#define PTT_OFF	(PTT = off)
;#define TX_LED_ON	(TX_LED = on)
;#define TX_LED_OFF	(TX_LED = off)
;#define STBY_LED_ON	(STBY_LED = off)
;#define STBY_LED_OFF	(STBY_LED = off)
;
;#define CONST_1200      52
;#define CONST_2200      (CONST_1200/2)
;#define CONST_POLYNOM   0b10001000000100001	// x^16 + x^12 + x^5 + 1
;//#define CONST_POLYNOM	0b11000000000000101	// x^16 + x^15 + x^2 + 1
;
;flash char flag[24] =
;{	0x7E,0x7E,0x7E,0x7E,
;    0x7E,0x7E,0x7E,0x7E,
;    0x7E,0x7E,0x7E,0x7E,
;    0x7E,0x7E,0x7E,0x7E,
;    0x7E,0x7E,0x7E,0x7E,
;    0x7E,0x7E,0x7E,0x7E
;};
;flash char ssid_2 = 0b01100100;
;flash char ssid_9 = 0b01110010;
;flash char ssid_2final = 0b01100101;
;//flash char ssid_9final = 0b01110011;
;eeprom char destination[7] =
;{   0x41,0x50,0x55,0x32,0x35,0x4D,
;    0               // SSID
;    // APU25N-2     // 0b011SSIDx format, SSID = 2 = 0b0010
;};
;eeprom char source[7] =
;{   0x59,0x44,0x32,0x58,0x42,0x43,
;    0               // SSID
;    // YD2XBC-9     // 0b011SSIDx format, SSID = 9 = 0b1001
;};
;eeprom char digi[7] =
;{   // 0x57,0x49,0x44,0x45,0x32,0x32,0x20    // atau
;    0x57,0x49,0x44,0x45,0x32,
;    0,              // SSID
;    0x20
;    // WIDE2-2      // 0b011SSIDx format, SSID = 2 = 0b0010
;};
;char destination_final[7];
;char source_final[7];
;char digi_final[7];
;flash char control_field = 0x03;
;flash char protocol_id = 0xF0;
;flash char data_type = 0x21;
;eeprom char latitude[8] =
;{	0x30,0x37,0x34,0x35,0x2E,0x37,0x39,0x53					// format string
;    // 0,7,4,5,0x2E,7,9,0x53								// format int
;    // 0745.79S
;};
;eeprom char symbol_table = 0x2F;
;eeprom char longitude[9] =
;{	0x31,0x31,0x30,0x30,0x35,0x2E,0x32,0x31,0x45
;    // 1,1,0,0,5,0x2E,2,1,0x45
;    // 11005.21E
;};
;eeprom char symbol_code = 0x3E;
;eeprom char comment[43] =
;{	0x54,0x45,0x53,0x54,0x49,0x4E,0x47,0x20,                // testing(spasi)
;    0x46,0x4F,0x52,0x20,                                    // for(spasi)
;    0x45,0x4D,0x45,0x52,0x47,0x45,0x4E,0x43,0x59,0x20,      // emergency(spasi)
;    0x42,0x45,0x41,0x43,0x4F,0x4E,0x20,                     // beacon(spasi)
;    0x20,0x20,0x20,0x20,0x20,0x20,0x20,                     // (spasi)
;    0x20,0x20,0x20,0x20,0x20,0x20,0x20                      // (spasi)
;    // testing for emergency beacon
;};
;bit flag_state;
;bit crc_flag = 0;
;int tone = 1200;
;char fcshi;
;char fcslo;
;char count_1 = 0;
;char x_counter = 0;
;unsigned char xcount = 0;
;long fcs_arr = 0;
;
;void init_data(void);
;void protocol(void);
;void send_data(char input);
;void fliptone(void);
;void set_dac(char value);
;void send_tone(int nada);
;void send_fcs(char infcs);
;void calc_fcs(char in);
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00D9 {	xcount++;
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
	LDS  R30,_xcount
	SUBI R30,-LOW(1)
	STS  _xcount,R30
; 0000 00DA     if((xcount>1) && (xcount<80))	AUX_LED = on;
	LDS  R26,_xcount
	CPI  R26,LOW(0x2)
	BRLO _0x15
	CPI  R26,LOW(0x50)
	BRLO _0x16
_0x15:
	RJMP _0x14
_0x16:
	SBI  0x12,5
; 0000 00DB     else AUX_LED = off;
	RJMP _0x19
_0x14:
	CBI  0x12,5
; 0000 00DC     TCNT0=0xFF;
_0x19:
	LDI  R30,LOW(255)
	OUT  0x32,R30
; 0000 00DD }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;void init_data(void)
; 0000 00E0 {	int i;
_init_data:
; 0000 00E1     for(i=0;i<7;i++)
	RCALL __SAVELOCR2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x1D:
	__CPWRN 16,17,7
	BRGE _0x1E
; 0000 00E2     {  	digi_final[i] = digi[i] << 1;
	MOVW R30,R16
	SUBI R30,LOW(-_digi_final)
	SBCI R31,HIGH(-_digi_final)
	MOVW R0,R30
	LDI  R26,LOW(_digi)
	LDI  R27,HIGH(_digi)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	LSL  R30
	MOVW R26,R0
	ST   X,R30
; 0000 00E3         destination_final[i] = destination[i] << 1;
	MOVW R30,R16
	SUBI R30,LOW(-_destination_final)
	SBCI R31,HIGH(-_destination_final)
	MOVW R0,R30
	LDI  R26,LOW(_destination)
	LDI  R27,HIGH(_destination)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	LSL  R30
	MOVW R26,R0
	ST   X,R30
; 0000 00E4         source_final[i] = source[i] << 1;
	MOVW R30,R16
	SUBI R30,LOW(-_source_final)
	SBCI R31,HIGH(-_source_final)
	MOVW R0,R30
	LDI  R26,LOW(_source)
	LDI  R27,HIGH(_source)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	LSL  R30
	MOVW R26,R0
	ST   X,R30
; 0000 00E5     }
	__ADDWRN 16,17,1
	RJMP _0x1D
_0x1E:
; 0000 00E6 
; 0000 00E7     destination_final[6] = ssid_2;
	LDI  R30,LOW(100)
	__PUTB1MN _destination_final,6
; 0000 00E8     source_final[6] = ssid_9;
	LDI  R30,LOW(114)
	__PUTB1MN _source_final,6
; 0000 00E9     digi_final[5] = ssid_2final;
	LDI  R30,LOW(101)
	__PUTB1MN _digi_final,5
; 0000 00EA }
	RJMP _0x2060002
;
;void protocol(void)
; 0000 00ED {	int i;
_protocol:
; 0000 00EE 
; 0000 00EF     init_data();											// persiapkan bit shifting
	RCALL __SAVELOCR2
;	i -> R16,R17
	RCALL _init_data
; 0000 00F0 
; 0000 00F1     PTT_ON;
	SBI  0x18,4
; 0000 00F2     TX_LED_ON;
	SBI  0x12,4
; 0000 00F3     delay_ms(250);                  						// tunggu sampai radio stabil
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 00F4 
; 0000 00F5     crc_flag = 0;
	CLT
	BLD  R2,2
; 0000 00F6     flag_state = 1;
	SET
	BLD  R2,1
; 0000 00F7     for(i=0;i<24;i++)       send_data(flag[i]);             // kirim flag 24 kali
	__GETWRN 16,17,0
_0x24:
	__CPWRN 16,17,24
	BRGE _0x25
	MOVW R30,R16
	SUBI R30,LOW(-_flag*2)
	SBCI R31,HIGH(-_flag*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _send_data
	__ADDWRN 16,17,1
	RJMP _0x24
_0x25:
; 0000 00F8 flag_state = 0;
	CLT
	BLD  R2,1
; 0000 00F9     for(i=0;i<7;i++)        send_data(destination_final[i]);// kirim callsign tujuan
	__GETWRN 16,17,0
_0x27:
	__CPWRN 16,17,7
	BRGE _0x28
	LDI  R26,LOW(_destination_final)
	LDI  R27,HIGH(_destination_final)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	ST   -Y,R30
	RCALL _send_data
	__ADDWRN 16,17,1
	RJMP _0x27
_0x28:
; 0000 00FA for(i=0;i<7;i++)        send_data(source_final[i]);
	__GETWRN 16,17,0
_0x2A:
	__CPWRN 16,17,7
	BRGE _0x2B
	LDI  R26,LOW(_source_final)
	LDI  R27,HIGH(_source_final)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	ST   -Y,R30
	RCALL _send_data
	__ADDWRN 16,17,1
	RJMP _0x2A
_0x2B:
; 0000 00FB send_data(ssid_9);
	LDI  R30,LOW(114)
	ST   -Y,R30
	RCALL _send_data
; 0000 00FC     for(i=0;i<7;i++)        send_data(digi_final[i]);       // kirim path digi
	__GETWRN 16,17,0
_0x2D:
	__CPWRN 16,17,7
	BRGE _0x2E
	LDI  R26,LOW(_digi_final)
	LDI  R27,HIGH(_digi_final)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	ST   -Y,R30
	RCALL _send_data
	__ADDWRN 16,17,1
	RJMP _0x2D
_0x2E:
; 0000 00FD send_data(control_field);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _send_data
; 0000 00FE     send_data(protocol_id);                                 // kirim data PID
	LDI  R30,LOW(240)
	ST   -Y,R30
	RCALL _send_data
; 0000 00FF     send_data(data_type);                                   // kirim data type info
	LDI  R30,LOW(33)
	ST   -Y,R30
	RCALL _send_data
; 0000 0100     for(i=0;i<8;i++)        send_data(latitude[i]);         // kirim data lintang posisi
	__GETWRN 16,17,0
_0x30:
	__CPWRN 16,17,8
	BRGE _0x31
	LDI  R26,LOW(_latitude)
	LDI  R27,HIGH(_latitude)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _send_data
	__ADDWRN 16,17,1
	RJMP _0x30
_0x31:
; 0000 0101 send_data(symbol_table);
	LDI  R26,LOW(_symbol_table)
	LDI  R27,HIGH(_symbol_table)
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _send_data
; 0000 0102     for(i=0;i<9;i++)        send_data(longitude[i]);        // kirim data bujur posisi
	__GETWRN 16,17,0
_0x33:
	__CPWRN 16,17,9
	BRGE _0x34
	LDI  R26,LOW(_longitude)
	LDI  R27,HIGH(_longitude)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _send_data
	__ADDWRN 16,17,1
	RJMP _0x33
_0x34:
; 0000 0103 send_data(symbol_code);
	LDI  R26,LOW(_symbol_code)
	LDI  R27,HIGH(_symbol_code)
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _send_data
; 0000 0104     for(i=0;i<43;i++);      send_data(comment[i]);          // kirim komen
	__GETWRN 16,17,0
_0x36:
	__CPWRN 16,17,43
	BRGE _0x37
	__ADDWRN 16,17,1
	RJMP _0x36
_0x37:
	LDI  R26,LOW(_comment)
	LDI  R27,HIGH(_comment)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _send_data
; 0000 0105     crc_flag = 1;    		calc_fcs(0);	               		// hitung FCS
	SET
	BLD  R2,2
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _calc_fcs
; 0000 0106     send_fcs(fcshi);                                        // kirim 8 MSB dari FCS
	ST   -Y,R13
	RCALL _send_fcs
; 0000 0107     send_fcs(fcslo);                                        // kirim 8 LSB dari FCS
	ST   -Y,R12
	RCALL _send_fcs
; 0000 0108     flag_state = 1;
	SET
	BLD  R2,1
; 0000 0109     for(i=0;i<12;i++)       send_data(flag[i]);             // kirim flag 12 kali
	__GETWRN 16,17,0
_0x39:
	__CPWRN 16,17,12
	BRGE _0x3A
	MOVW R30,R16
	SUBI R30,LOW(-_flag*2)
	SBCI R31,HIGH(-_flag*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _send_data
	__ADDWRN 16,17,1
	RJMP _0x39
_0x3A:
; 0000 010A flag_state = 0;
	CLT
	BLD  R2,1
; 0000 010B     PTT_OFF;
	CBI  0x18,4
; 0000 010C     TX_LED_OFF;
	CBI  0x12,4
; 0000 010D }
	RJMP _0x2060002
;
;void send_data(char input)
; 0000 0110 {	int i;
_send_data:
	PUSH R15
; 0000 0111     bit x;
; 0000 0112     for(i=0;i<8;i++)
	RCALL __SAVELOCR2
;	input -> Y+2
;	i -> R16,R17
;	x -> R15.0
	__GETWRN 16,17,0
_0x40:
	__CPWRN 16,17,8
	BRGE _0x41
; 0000 0113     {	x = (input >> i) & 0x01;
	LDD  R26,Y+2
	LDI  R27,0
	MOV  R30,R16
	RCALL __ASRW12
	BST  R30,0
	BLD  R15,0
; 0000 0114         if(!flag_state)	calc_fcs(x);
	SBRC R2,1
	RJMP _0x42
	LDI  R30,0
	SBRC R15,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _calc_fcs
; 0000 0115         if(x)
_0x42:
	SBRS R15,0
	RJMP _0x43
; 0000 0116         {	if(!flag_state) count_1++;
	SBRC R2,1
	RJMP _0x44
	LDS  R30,_count_1
	SUBI R30,-LOW(1)
	STS  _count_1,R30
; 0000 0117             if(count_1==5)  fliptone();
_0x44:
	LDS  R26,_count_1
	CPI  R26,LOW(0x5)
	BRNE _0x45
	RCALL _fliptone
; 0000 0118             send_tone(tone);
_0x45:
	ST   -Y,R11
	ST   -Y,R10
	RCALL _send_tone
; 0000 0119         }
; 0000 011A         if(!x)  fliptone();
_0x43:
	SBRS R15,0
	RCALL _fliptone
; 0000 011B     }
	__ADDWRN 16,17,1
	RJMP _0x40
_0x41:
; 0000 011C }
	RJMP _0x2060005
;
;void fliptone(void)
; 0000 011F {	count_1 = 0;
_fliptone:
	LDI  R30,LOW(0)
	STS  _count_1,R30
; 0000 0120     switch(tone)
	MOVW R30,R10
; 0000 0121     {	case 1200:      tone=2200;      send_tone(tone);        break;
	CPI  R30,LOW(0x4B0)
	LDI  R26,HIGH(0x4B0)
	CPC  R31,R26
	BRNE _0x4A
	LDI  R30,LOW(2200)
	LDI  R31,HIGH(2200)
	RJMP _0x96
; 0000 0122         case 2200:      tone=1200;      send_tone(tone);        break;
_0x4A:
	CPI  R30,LOW(0x898)
	LDI  R26,HIGH(0x898)
	CPC  R31,R26
	BRNE _0x49
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
_0x96:
	MOVW R10,R30
	ST   -Y,R11
	ST   -Y,R10
	RCALL _send_tone
; 0000 0123     }
_0x49:
; 0000 0124 }
	RET
;
;void set_dac(char value)
; 0000 0127 {	DAC_0 = value & 0x01;
_set_dac:
;	value -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x4C
	CBI  0x18,0
	RJMP _0x4D
_0x4C:
	SBI  0x18,0
_0x4D:
; 0000 0128     DAC_1 =( value >> 1 ) & 0x01;
	LD   R30,Y
	LDI  R31,0
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x4E
	CBI  0x18,1
	RJMP _0x4F
_0x4E:
	SBI  0x18,1
_0x4F:
; 0000 0129     DAC_2 =( value >> 2 ) & 0x01;
	LD   R30,Y
	LDI  R31,0
	RCALL __ASRW2
	ANDI R30,LOW(0x1)
	BRNE _0x50
	CBI  0x18,2
	RJMP _0x51
_0x50:
	SBI  0x18,2
_0x51:
; 0000 012A     DAC_3 =( value >> 3 ) & 0x01;
	LD   R30,Y
	LDI  R31,0
	RCALL __ASRW3
	ANDI R30,LOW(0x1)
	BRNE _0x52
	CBI  0x18,3
	RJMP _0x53
_0x52:
	SBI  0x18,3
_0x53:
; 0000 012B }
	ADIW R28,1
	RET
;
;void send_tone(int nada)
; 0000 012E {	if(nada==1200)
_send_tone:
;	nada -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x4B0)
	LDI  R30,HIGH(0x4B0)
	CPC  R27,R30
	BREQ PC+2
	RJMP _0x54
; 0000 012F     {	set_dac(7);     delay_us(CONST_1200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0130 
; 0000 0131         set_dac(10);    delay_us(CONST_1200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0132         set_dac(13);    delay_us(CONST_1200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0133         set_dac(14);    delay_us(CONST_1200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0134 
; 0000 0135         set_dac(15);    delay_us(CONST_1200);
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0136 
; 0000 0137         set_dac(14);    delay_us(CONST_1200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0138         set_dac(13);    delay_us(CONST_1200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0139         set_dac(10);    delay_us(CONST_1200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 013A 
; 0000 013B         set_dac(7);     delay_us(CONST_1200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 013C 
; 0000 013D         set_dac(5);     delay_us(CONST_1200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 013E         set_dac(2);     delay_us(CONST_1200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 013F         set_dac(1);     delay_us(CONST_1200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0140 
; 0000 0141         set_dac(0);     delay_us(CONST_1200);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0142 
; 0000 0143         set_dac(1);     delay_us(CONST_1200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0144         set_dac(2);     delay_us(CONST_1200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0145         set_dac(5);     delay_us(CONST_1200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
; 0000 0146     }
; 0000 0147 
; 0000 0148     else
	RJMP _0x55
_0x54:
; 0000 0149     {  	set_dac(7);     delay_us(CONST_2200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 014A 
; 0000 014B         set_dac(10);    delay_us(CONST_2200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 014C         set_dac(13);    delay_us(CONST_2200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 014D         set_dac(14);    delay_us(CONST_2200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 014E 
; 0000 014F         set_dac(15);    delay_us(CONST_2200);
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0150 
; 0000 0151         set_dac(14);    delay_us(CONST_2200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0152         set_dac(13);    delay_us(CONST_2200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0153         set_dac(10);    delay_us(CONST_2200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0154 
; 0000 0155         set_dac(7);     delay_us(CONST_2200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0156 
; 0000 0157         set_dac(5);     delay_us(CONST_2200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0158         set_dac(2);     delay_us(CONST_2200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0159         set_dac(1);     delay_us(CONST_2200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 015A 
; 0000 015B         set_dac(0);     delay_us(CONST_2200);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 015C 
; 0000 015D         set_dac(1);     delay_us(CONST_2200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 015E         set_dac(2);     delay_us(CONST_2200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 015F         set_dac(5);     delay_us(CONST_2200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0160 
; 0000 0161         set_dac(7);     delay_us(CONST_2200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0162 
; 0000 0163         set_dac(10);    delay_us(CONST_2200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0164         set_dac(13);    delay_us(CONST_2200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0165         set_dac(14);    delay_us(CONST_2200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0166 
; 0000 0167         set_dac(15);    delay_us(CONST_2200);
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0168 
; 0000 0169         set_dac(14);    delay_us(CONST_2200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 016A         set_dac(13);    delay_us(CONST_2200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 016B         set_dac(10);    delay_us(CONST_2200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 016C 
; 0000 016D         set_dac(7);     delay_us(CONST_2200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 016E 
; 0000 016F         set_dac(5);     delay_us(CONST_2200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0170         set_dac(2);     delay_us(CONST_2200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0171         set_dac(1);     delay_us(CONST_2200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0172 
; 0000 0173         set_dac(0);     delay_us(CONST_2200);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0174 
; 0000 0175         set_dac(1);     delay_us(CONST_2200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0176         set_dac(2);     delay_us(CONST_2200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0177         set_dac(5);     delay_us(CONST_2200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 96
; 0000 0178     }
_0x55:
; 0000 0179 }
	ADIW R28,2
	RET
;
;void send_fcs(char infcs)
; 0000 017C {	int j=7;
_send_fcs:
	PUSH R15
; 0000 017D 	bit x;
; 0000 017E 	while(j>0)
	RCALL __SAVELOCR2
;	infcs -> Y+2
;	j -> R16,R17
;	x -> R15.0
	__GETWRN 16,17,7
_0x56:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x58
; 0000 017F     {	x = (infcs >> j) & 0x01;
	LDD  R26,Y+2
	LDI  R27,0
	MOV  R30,R16
	RCALL __ASRW12
	BST  R30,0
	BLD  R15,0
; 0000 0180         if(x)
	SBRS R15,0
	RJMP _0x59
; 0000 0181         {	count_1++;
	LDS  R30,_count_1
	SUBI R30,-LOW(1)
	STS  _count_1,R30
; 0000 0182             if(count_1==5)    fliptone();
	LDS  R26,_count_1
	CPI  R26,LOW(0x5)
	BRNE _0x5A
	RCALL _fliptone
; 0000 0183             send_tone(tone);
_0x5A:
	ST   -Y,R11
	ST   -Y,R10
	RCALL _send_tone
; 0000 0184         }
; 0000 0185         if(!x)  fliptone();
_0x59:
	SBRS R15,0
	RCALL _fliptone
; 0000 0186         j--;
	__SUBWRN 16,17,1
; 0000 0187 	}
	RJMP _0x56
_0x58:
; 0000 0188 }
_0x2060005:
	RCALL __LOADLOCR2
	ADIW R28,3
	POP  R15
	RET
;
;void calc_fcs(char in)
; 0000 018B {	int i;
_calc_fcs:
; 0000 018C  	fcs_arr += in;
	RCALL __SAVELOCR2
;	in -> Y+2
;	i -> R16,R17
	LDD  R30,Y+2
	LDI  R31,0
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	RCALL __CWD1
	RCALL __ADDD12
	STS  _fcs_arr,R30
	STS  _fcs_arr+1,R31
	STS  _fcs_arr+2,R22
	STS  _fcs_arr+3,R23
; 0000 018D   	x_counter++;
	LDS  R30,_x_counter
	SUBI R30,-LOW(1)
	STS  _x_counter,R30
; 0000 018E 
; 0000 018F    	if(crc_flag)
	SBRS R2,2
	RJMP _0x5C
; 0000 0190     {	for(i=0;i<16;i++)
	__GETWRN 16,17,0
_0x5E:
	__CPWRN 16,17,16
	BRGE _0x5F
; 0000 0191         {	if((fcs_arr >> 16)==1)
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	LDI  R30,LOW(16)
	RCALL __ASRD12
	__CPD1N 0x1
	BRNE _0x60
; 0000 0192             {	fcs_arr ^= CONST_POLYNOM;
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	__GETD1N 0x11021
	RCALL __XORD12
	STS  _fcs_arr,R30
	STS  _fcs_arr+1,R31
	STS  _fcs_arr+2,R22
	STS  _fcs_arr+3,R23
; 0000 0193             }
; 0000 0194           	fcs_arr <<= 1;
_0x60:
	LDS  R30,_fcs_arr
	LDS  R31,_fcs_arr+1
	LDS  R22,_fcs_arr+2
	LDS  R23,_fcs_arr+3
	RCALL __LSLD1
	STS  _fcs_arr,R30
	STS  _fcs_arr+1,R31
	STS  _fcs_arr+2,R22
	STS  _fcs_arr+3,R23
; 0000 0195     	}
	__ADDWRN 16,17,1
	RJMP _0x5E
_0x5F:
; 0000 0196     	fcshi = fcs_arr >> 8; 			// ambil 8 bit paling kiri
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	LDI  R30,LOW(8)
	RCALL __ASRD12
	MOV  R13,R30
; 0000 0197     	fcslo = fcs_arr & 0b11111111; 	// ambil 8 bit paling kanan
	LDS  R30,_fcs_arr
	MOV  R12,R30
; 0000 0198     }
; 0000 0199 
; 0000 019A     if((x_counter==17) && ((fcs_arr >> 16)==1))
_0x5C:
	LDS  R26,_x_counter
	CPI  R26,LOW(0x11)
	BRNE _0x62
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	LDI  R30,LOW(16)
	RCALL __ASRD12
	__CPD1N 0x1
	BREQ _0x63
_0x62:
	RJMP _0x61
_0x63:
; 0000 019B     {	fcs_arr ^= CONST_POLYNOM;
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	__GETD1N 0x11021
	RCALL __XORD12
	STS  _fcs_arr,R30
	STS  _fcs_arr+1,R31
	STS  _fcs_arr+2,R22
	STS  _fcs_arr+3,R23
; 0000 019C         x_counter -= 1;
	LDS  R30,_x_counter
	LDI  R31,0
	SBIW R30,1
	STS  _x_counter,R30
; 0000 019D     }
; 0000 019E 
; 0000 019F     if(x_counter==17)
_0x61:
	LDS  R26,_x_counter
	CPI  R26,LOW(0x11)
	BRNE _0x64
; 0000 01A0     {	x_counter -= 1;
	LDS  R30,_x_counter
	LDI  R31,0
	SBIW R30,1
	STS  _x_counter,R30
; 0000 01A1     }
; 0000 01A2 
; 0000 01A3     fcs_arr <<= 1;
_0x64:
	LDS  R30,_fcs_arr
	LDS  R31,_fcs_arr+1
	LDS  R22,_fcs_arr+2
	LDS  R23,_fcs_arr+3
	RCALL __LSLD1
	STS  _fcs_arr,R30
	STS  _fcs_arr+1,R31
	STS  _fcs_arr+2,R22
	STS  _fcs_arr+3,R23
; 0000 01A4 }
	RJMP _0x2060004
;
;void TerimaGps(void)
; 0000 01A7 {	int i;
_TerimaGps:
; 0000 01A8 	for(i=0; i<100; i++)
	RCALL __SAVELOCR2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x66:
	__CPWRN 16,17,100
	BRGE _0x67
; 0000 01A9 	GPRMC[i] = getchar();
	MOVW R30,R16
	SUBI R30,LOW(-_GPRMC)
	SBCI R31,HIGH(-_GPRMC)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
	__ADDWRN 16,17,1
	RJMP _0x66
_0x67:
; 0000 01AA }
	RJMP _0x2060002
;
;char last_marker;
;char buffer[2][11];
;char cari_koma(char marker_koma);
;char lintang(char marker_lintang);
;char bujur(char marker_bujur);
;void ParsingLintang(void);
;void ParsingBujur(void);
;void ParsingGps(void)
; 0000 01B4 {	int i;
_ParsingGps:
; 0000 01B5 	for(i=0; i<strlen(GPRMC); i++)
	RCALL __SAVELOCR2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x69:
	LDI  R30,LOW(_GPRMC)
	LDI  R31,HIGH(_GPRMC)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strlen
	CP   R16,R30
	CPC  R17,R31
	BRLO PC+2
	RJMP _0x6A
; 0000 01B6     {	if(GPRMC[i]=='$')
	LDI  R26,LOW(_GPRMC)
	LDI  R27,HIGH(_GPRMC)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CPI  R26,LOW(0x24)
	BREQ PC+2
	RJMP _0x6B
; 0000 01B7     	{
; 0000 01B8         if(GPRMC[i+1]=='G')
	MOVW R30,R16
	__ADDW1MN _GPRMC,1
	LD   R26,Z
	CPI  R26,LOW(0x47)
	BRNE _0x6C
; 0000 01B9         {
; 0000 01BA         if(GPRMC[i+2]=='P')
	MOVW R30,R16
	__ADDW1MN _GPRMC,2
	LD   R26,Z
	CPI  R26,LOW(0x50)
	BRNE _0x6D
; 0000 01BB         {
; 0000 01BC         if(GPRMC[i+3]=='R')
	MOVW R30,R16
	__ADDW1MN _GPRMC,3
	LD   R26,Z
	CPI  R26,LOW(0x52)
	BRNE _0x6E
; 0000 01BD         {
; 0000 01BE         if(GPRMC[i+4]=='M')
	MOVW R30,R16
	__ADDW1MN _GPRMC,4
	LD   R26,Z
	CPI  R26,LOW(0x4D)
	BRNE _0x6F
; 0000 01BF         {
; 0000 01C0         if(GPRMC[i+5]=='C')
	MOVW R30,R16
	__ADDW1MN _GPRMC,5
	LD   R26,Z
	CPI  R26,LOW(0x43)
	BRNE _0x70
; 0000 01C1         {	i += 5;
	__ADDWRN 16,17,5
; 0000 01C2         	last_marker = i;
	STS  _last_marker,R16
; 0000 01C3         	last_marker = cari_koma(last_marker);
	LDS  R30,_last_marker
	ST   -Y,R30
	RCALL _cari_koma
	STS  _last_marker,R30
; 0000 01C4         	last_marker = lintang(last_marker);
	ST   -Y,R30
	RCALL _lintang
	STS  _last_marker,R30
; 0000 01C5         	last_marker = cari_koma(last_marker);
	ST   -Y,R30
	RCALL _cari_koma
	STS  _last_marker,R30
; 0000 01C6         	last_marker = bujur(last_marker);
	ST   -Y,R30
	RCALL _bujur
	STS  _last_marker,R30
; 0000 01C7         	last_marker = cari_koma(last_marker);
	ST   -Y,R30
	RCALL _cari_koma
	STS  _last_marker,R30
; 0000 01C8             ParsingLintang();
	RCALL _ParsingLintang
; 0000 01C9             ParsingBujur();
	RCALL _ParsingBujur
; 0000 01CA         }}}}}}
_0x70:
_0x6F:
_0x6E:
_0x6D:
_0x6C:
; 0000 01CB     }
_0x6B:
	__ADDWRN 16,17,1
	RJMP _0x69
_0x6A:
; 0000 01CC }
	RJMP _0x2060002
;
;char cari_koma(char marker_koma)
; 0000 01CF {	int i;
_cari_koma:
; 0000 01D0 	marker_koma += 1;
	RCALL __SAVELOCR2
;	marker_koma -> Y+2
;	i -> R16,R17
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	STD  Y+2,R30
; 0000 01D1 	if(GPRMC[marker_koma] == ',')
	LDI  R31,0
	SUBI R30,LOW(-_GPRMC)
	SBCI R31,HIGH(-_GPRMC)
	LD   R26,Z
	CPI  R26,LOW(0x2C)
	BRNE _0x71
; 0000 01D2 	last_marker = marker_koma;
	LDD  R30,Y+2
	STS  _last_marker,R30
; 0000 01D3 	else
	RJMP _0x72
_0x71:
; 0000 01D4     {	for(i=marker_koma;;i++)
	LDD  R16,Y+2
	CLR  R17
_0x74:
; 0000 01D5     	{	last_marker = i;
	STS  _last_marker,R16
; 0000 01D6         	if(GPRMC[i]==',')
	LDI  R26,LOW(_GPRMC)
	LDI  R27,HIGH(_GPRMC)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BREQ _0x75
; 0000 01D7             break;
; 0000 01D8         }
	__ADDWRN 16,17,1
	RJMP _0x74
_0x75:
; 0000 01D9     }
_0x72:
; 0000 01DA     return (last_marker);
	RJMP _0x2060003
; 0000 01DB }
;
;char lintang(char marker_lintang)
; 0000 01DE { 	int i;
_lintang:
; 0000 01DF 	marker_lintang += 1;
	RCALL __SAVELOCR2
;	marker_lintang -> Y+2
;	i -> R16,R17
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	STD  Y+2,R30
; 0000 01E0     for(i=marker_lintang;;i++)
	LDD  R16,Y+2
	CLR  R17
_0x78:
; 0000 01E1     { 	if(GPRMC[i]==',')
	LDI  R26,LOW(_GPRMC)
	LDI  R27,HIGH(_GPRMC)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BREQ _0x79
; 0000 01E2     	break;
; 0000 01E3         buffer[0][i-marker_lintang]=GPRMC[i];
	LDD  R26,Y+2
	CLR  R27
	MOVW R30,R16
	SUB  R30,R26
	SBC  R31,R27
	SUBI R30,LOW(-_buffer)
	SBCI R31,HIGH(-_buffer)
	MOVW R0,R30
	LDI  R26,LOW(_GPRMC)
	LDI  R27,HIGH(_GPRMC)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 01E4         last_marker=i;
	STS  _last_marker,R16
; 0000 01E5     }
	__ADDWRN 16,17,1
	RJMP _0x78
_0x79:
; 0000 01E6     return (last_marker);
	RJMP _0x2060003
; 0000 01E7 }
;
;char bujur(char marker_bujur)
; 0000 01EA { 	int i;
_bujur:
; 0000 01EB 	marker_bujur += 1;
	RCALL __SAVELOCR2
;	marker_bujur -> Y+2
;	i -> R16,R17
	LDD  R30,Y+2
	SUBI R30,-LOW(1)
	STD  Y+2,R30
; 0000 01EC     for(i=marker_bujur;;i++)
	LDD  R16,Y+2
	CLR  R17
_0x7C:
; 0000 01ED     { 	if(GPRMC[i]==',')
	LDI  R26,LOW(_GPRMC)
	LDI  R27,HIGH(_GPRMC)
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BREQ _0x7D
; 0000 01EE     	break;
; 0000 01EF         buffer[1][i-marker_bujur]=GPRMC[i];
	LDD  R26,Y+2
	CLR  R27
	MOVW R30,R16
	SUB  R30,R26
	SBC  R31,R27
	__ADDW1MN _buffer,11
	MOVW R0,R30
	LDI  R26,LOW(_GPRMC)
	LDI  R27,HIGH(_GPRMC)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 01F0         last_marker=i;
	STS  _last_marker,R16
; 0000 01F1     }
	__ADDWRN 16,17,1
	RJMP _0x7C
_0x7D:
; 0000 01F2     return (last_marker);
_0x2060003:
	LDS  R30,_last_marker
_0x2060004:
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
; 0000 01F3 }
;
;void ParsingLintang(void)
; 0000 01F6 {	int i;
_ParsingLintang:
; 0000 01F7 	for(i=0; i<7; i++) latitude[i]=buffer[0][i];
	RCALL __SAVELOCR2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x80:
	__CPWRN 16,17,7
	BRGE _0x81
	MOVW R30,R16
	SUBI R30,LOW(-_latitude)
	SBCI R31,HIGH(-_latitude)
	MOVW R0,R30
	LDI  R26,LOW(_buffer)
	LDI  R27,HIGH(_buffer)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	RCALL __EEPROMWRB
	__ADDWRN 16,17,1
	RJMP _0x80
_0x81:
; 0000 01F8 latitude[7]='S';
	__POINTW2MN _latitude,7
	LDI  R30,LOW(83)
	RJMP _0x2060001
; 0000 01F9 }
;
;void ParsingBujur(void)
; 0000 01FC {	int i;
_ParsingBujur:
; 0000 01FD 	for(i=0; i<8; i++) longitude[i]=buffer[1][i];
	RCALL __SAVELOCR2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x83:
	__CPWRN 16,17,8
	BRGE _0x84
	MOVW R26,R16
	SUBI R26,LOW(-_longitude)
	SBCI R27,HIGH(-_longitude)
	__POINTW1MN _buffer,11
	ADD  R30,R16
	ADC  R31,R17
	LD   R30,Z
	RCALL __EEPROMWRB
	__ADDWRN 16,17,1
	RJMP _0x83
_0x84:
; 0000 01FE longitude[8]='E';
	__POINTW2MN _longitude,8
	LDI  R30,LOW(69)
_0x2060001:
	RCALL __EEPROMWRB
; 0000 01FF }
_0x2060002:
	RCALL __LOADLOCR2P
	RET
;
;void main(void)
; 0000 0202 {	// Port B initialization
_main:
; 0000 0203 	// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0204 	// State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0205 	PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0206 	DDRB=0x1F;
	LDI  R30,LOW(31)
	OUT  0x17,R30
; 0000 0207 
; 0000 0208 	// Port D initialization
; 0000 0209 	// Func7=In Func6=In Func5=Out Func4=Out Func3=Out Func2=In Func1=Out Func0=In
; 0000 020A 	// State7=P State6=P State5=0 State4=0 State3=0 State2=T State1=0 State0=T
; 0000 020B 	PORTD=0xC0;
	LDI  R30,LOW(192)
	OUT  0x12,R30
; 0000 020C 	DDRD=0x3A;
	LDI  R30,LOW(58)
	OUT  0x11,R30
; 0000 020D 
; 0000 020E     // USART initialization
; 0000 020F 	// Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0210 	// USART Receiver: On
; 0000 0211 	// USART Transmitter: On
; 0000 0212 	// USART Mode: Asynchronous
; 0000 0213 	// USART Baud Rate: 4800
; 0000 0214 	UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0215 	UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0216 	UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0217 	UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0218 	UBRRL=0x8F;
	LDI  R30,LOW(143)
	OUT  0x9,R30
; 0000 0219 
; 0000 021A     // Timer/Counter 0 initialization
; 0000 021B 	// Clock source: System Clock
; 0000 021C 	// Clock value: 10.800 kHz
; 0000 021D 	// Mode: Normal top=0xFF
; 0000 021E 	// OC0 output: Disconnected
; 0000 021F 	TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0220 	TCNT0=0xFF;
	LDI  R30,LOW(255)
	OUT  0x32,R30
; 0000 0221 	OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0222 
; 0000 0223 	// Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0224 	TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0225 
; 0000 0226 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0227 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0228 
; 0000 0229 	#asm("sei")
	sei
; 0000 022A 
; 0000 022B     STBY_LED = on;
	SBI  0x12,3
; 0000 022C 
; 0000 022D 	while (1)
_0x87:
; 0000 022E     {	STBY_LED = on;
	SBI  0x12,3
; 0000 022F     	if((MODE) && (TX_NOW))
	SBIS 0x10,6
	RJMP _0x8D
	SBIC 0x10,7
	RJMP _0x8E
_0x8D:
	RJMP _0x8C
_0x8E:
; 0000 0230     	{	TerimaGps();
	RCALL _TerimaGps
; 0000 0231     		ParsingGps();
	RCALL _ParsingGps
; 0000 0232         	#asm("cli")
	cli
; 0000 0233     		protocol();
	RCALL _protocol
; 0000 0234         	#asm("sei")
	sei
; 0000 0235             delay_ms(10000);
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0236         	delay_ms(10000);
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0237             delay_ms(10000);
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0238         }
; 0000 0239     	if((!MODE) && (TX_NOW))
_0x8C:
	SBIC 0x10,6
	RJMP _0x90
	SBIC 0x10,7
	RJMP _0x91
_0x90:
	RJMP _0x8F
_0x91:
; 0000 023A         {	delay_ms(10000);
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 023B         	delay_ms(10000);
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 023C             delay_ms(10000);
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 023D         	#asm("cli")
	cli
; 0000 023E     		protocol();
	RCALL _protocol
; 0000 023F         	#asm("sei")
	sei
; 0000 0240         }
; 0000 0241         if(!TX_NOW)
_0x8F:
	SBIC 0x10,7
	RJMP _0x92
; 0000 0242         { 	delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0243         	STBY_LED = off;
	CBI  0x12,3
; 0000 0244         	#asm("cli")
	cli
; 0000 0245     		protocol();
	RCALL _protocol
; 0000 0246         	#asm("sei")
	sei
; 0000 0247         }
; 0000 0248     }
_0x92:
	RJMP _0x87
; 0000 0249 }
_0x95:
	RJMP _0x95
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

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8
_GPRMC:
	.BYTE 0x64

	.ESEG
_destination:
	.DB  LOW(0x32555041),HIGH(0x32555041),BYTE3(0x32555041),BYTE4(0x32555041)
	.DW  0x4D35
	.DB  0x0
_source:
	.DB  LOW(0x58324459),HIGH(0x58324459),BYTE3(0x58324459),BYTE4(0x58324459)
	.DW  0x4342
	.DB  0x0
_digi:
	.DB  LOW(0x45444957),HIGH(0x45444957),BYTE3(0x45444957),BYTE4(0x45444957)
	.DW  0x32
	.DB  0x20

	.DSEG
_destination_final:
	.BYTE 0x7
_source_final:
	.BYTE 0x7
_digi_final:
	.BYTE 0x7

	.ESEG
_latitude:
	.DB  LOW(0x35343730),HIGH(0x35343730),BYTE3(0x35343730),BYTE4(0x35343730)
	.DB  LOW(0x5339372E),HIGH(0x5339372E),BYTE3(0x5339372E),BYTE4(0x5339372E)
_symbol_table:
	.DB  0x2F
_longitude:
	.DB  LOW(0x30303131),HIGH(0x30303131),BYTE3(0x30303131),BYTE4(0x30303131)
	.DB  LOW(0x31322E35),HIGH(0x31322E35),BYTE3(0x31322E35),BYTE4(0x31322E35)
	.DB  0x45
_symbol_code:
	.DB  0x3E
_comment:
	.DB  LOW(0x54534554),HIGH(0x54534554),BYTE3(0x54534554),BYTE4(0x54534554)
	.DB  LOW(0x20474E49),HIGH(0x20474E49),BYTE3(0x20474E49),BYTE4(0x20474E49)
	.DB  LOW(0x20524F46),HIGH(0x20524F46),BYTE3(0x20524F46),BYTE4(0x20524F46)
	.DB  LOW(0x52454D45),HIGH(0x52454D45),BYTE3(0x52454D45),BYTE4(0x52454D45)
	.DB  LOW(0x434E4547),HIGH(0x434E4547),BYTE3(0x434E4547),BYTE4(0x434E4547)
	.DB  LOW(0x45422059),HIGH(0x45422059),BYTE3(0x45422059),BYTE4(0x45422059)
	.DB  LOW(0x4E4F4341),HIGH(0x4E4F4341),BYTE3(0x4E4F4341),BYTE4(0x4E4F4341)
	.DB  LOW(0x20202020),HIGH(0x20202020),BYTE3(0x20202020),BYTE4(0x20202020)
	.DB  LOW(0x20202020),HIGH(0x20202020),BYTE3(0x20202020),BYTE4(0x20202020)
	.DB  LOW(0x20202020),HIGH(0x20202020),BYTE3(0x20202020),BYTE4(0x20202020)
	.DW  0x2020
	.DB  0x20

	.DSEG
_count_1:
	.BYTE 0x1
_x_counter:
	.BYTE 0x1
_xcount:
	.BYTE 0x1
_fcs_arr:
	.BYTE 0x4
_last_marker:
	.BYTE 0x1
_buffer:
	.BYTE 0x16

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

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__XORD12:
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
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

__ASRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __ASRD12R
__ASRD12L:
	ASR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRD12L
__ASRD12R:
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

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
