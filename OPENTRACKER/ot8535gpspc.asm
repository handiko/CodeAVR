
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8535
;Program type             : Application
;Clock frequency          : 12.000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 128 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
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
	.DEF _ssid=R11
	.DEF _path=R10
	.DEF _sim=R13
	.DEF _hasil=R12

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
	RJMP 0x00
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

_welcome:
	.DB  0x53,0x65,0x6C,0x61,0x6D,0x61,0x74,0x20
	.DB  0x64,0x61,0x74,0x61,0x6E,0x67,0x20,0x64
	.DB  0x69,0x20,0x66,0x61,0x73,0x69,0x6C,0x69
	.DB  0x74,0x61,0x73,0x20,0x6B,0x6F,0x6E,0x66
	.DB  0x69,0x67,0x75,0x72,0x61,0x73,0x69,0x20
	.DB  0x74,0x72,0x61,0x63,0x6B,0x65,0x72,0x20
	.DB  0x76,0x69,0x61,0x20,0x6B,0x6F,0x6D,0x75
	.DB  0x6E,0x69,0x6B,0x61,0x73,0x69,0x20,0x73
	.DB  0x65,0x72,0x69,0x61,0x6C,0x2F,0x70,0x63
	.DB  0x0
_pak:
	.DB  0x50,0x72,0x65,0x73,0x73,0x20,0x61,0x6E
	.DB  0x79,0x20,0x6B,0x65,0x79,0x20,0x21,0x0
_petunjuk:
	.DB  0x4B,0x65,0x74,0x69,0x6B,0x20,0x72,0x61
	.DB  0x6E,0x67,0x6B,0x61,0x69,0x61,0x6E,0x20
	.DB  0x73,0x65,0x74,0x74,0x69,0x6E,0x67,0x20
	.DB  0x54,0x72,0x61,0x63,0x6B,0x65,0x72,0x20
	.DB  0x79,0x61,0x6E,0x67,0x20,0x61,0x6E,0x64
	.DB  0x61,0x20,0x69,0x6E,0x67,0x69,0x6E,0x6B
	.DB  0x61,0x6E,0x0
_mintaCall:
	.DB  0x4D,0x61,0x73,0x75,0x6B,0x6B,0x61,0x6E
	.DB  0x20,0x43,0x61,0x6C,0x6C,0x73,0x69,0x67
	.DB  0x6E,0x20,0x41,0x6E,0x64,0x61,0x20,0x3A
	.DB  0x20,0x0
_mintaSSID:
	.DB  0x4D,0x61,0x73,0x75,0x6B,0x6B,0x61,0x6E
	.DB  0x20,0x53,0x53,0x49,0x44,0x20,0x41,0x6E
	.DB  0x64,0x61,0x20,0x3A,0x20,0x0
_mintaPath:
	.DB  0x50,0x61,0x74,0x68,0x20,0x61,0x6E,0x64
	.DB  0x61,0x2E,0x2E,0x20,0x74,0x65,0x6B,0x61
	.DB  0x6E,0x20,0x68,0x75,0x72,0x75,0x66,0x20
	.DB  0x6B,0x61,0x70,0x69,0x74,0x61,0x6C,0x20
	.DB  0x41,0x20,0x75,0x6E,0x74,0x75,0x6B,0x20
	.DB  0x57,0x49,0x44,0x45,0x32,0x2D,0x31,0x2C
	.DB  0x20,0x42,0x20,0x75,0x6E,0x74,0x75,0x6B
	.DB  0x20,0x57,0x49,0x44,0x45,0x32,0x2D,0x32
	.DB  0x2C,0x20,0x61,0x74,0x61,0x75,0x20,0x43
	.DB  0x20,0x75,0x6E,0x74,0x75,0x6B,0x20,0x57
	.DB  0x49,0x44,0x45,0x33,0x2D,0x33,0x20,0x3A
	.DB  0x20,0x0
_wide21:
	.DB  0x57,0x49,0x44,0x45,0x32,0x2D,0x31,0x0
_wide22:
	.DB  0x57,0x49,0x44,0x45,0x32,0x2D,0x32,0x0
_wide33:
	.DB  0x57,0x49,0x44,0x45,0x33,0x2D,0x33,0x0
_mintaSimbol:
	.DB  0x4D,0x61,0x73,0x75,0x6B,0x6B,0x61,0x6E
	.DB  0x20,0x73,0x69,0x6D,0x62,0x6F,0x6C,0x20
	.DB  0x73,0x74,0x61,0x74,0x69,0x6F,0x6E,0x20
	.DB  0x61,0x6E,0x64,0x61,0x20,0x28,0x62,0x61
	.DB  0x63,0x61,0x20,0x62,0x75,0x6B,0x75,0x20
	.DB  0x70,0x65,0x74,0x75,0x6E,0x6A,0x75,0x6B
	.DB  0x29,0x0
_tunggu:
	.DB  0x53,0x65,0x64,0x61,0x6E,0x67,0x20,0x64
	.DB  0x69,0x20,0x70,0x72,0x6F,0x73,0x65,0x73
	.DB  0x2E,0x2E,0x2E,0x0
_selesai:
	.DB  0x50,0x72,0x6F,0x73,0x65,0x73,0x20,0x73
	.DB  0x65,0x6C,0x65,0x73,0x61,0x69,0x0
_CallAnda:
	.DB  0x43,0x61,0x6C,0x6C,0x73,0x69,0x67,0x6E
	.DB  0x20,0x61,0x6E,0x64,0x61,0x20,0x3A,0x20
	.DB  0x0
_SSIDAnda:
	.DB  0x53,0x53,0x49,0x44,0x20,0x61,0x6E,0x64
	.DB  0x61,0x20,0x3A,0x20,0x0
_PathAnda:
	.DB  0x50,0x61,0x74,0x68,0x20,0x61,0x6E,0x64
	.DB  0x61,0x20,0x3A,0x20,0x0
_SimbolAnda:
	.DB  0x53,0x69,0x6D,0x62,0x6F,0x6C,0x20,0x73
	.DB  0x74,0x61,0x73,0x69,0x75,0x6E,0x20,0x61
	.DB  0x6E,0x64,0x61,0x20,0x3A,0x20,0x0
_reconfigure:
	.DB  0x53,0x65,0x74,0x69,0x6E,0x67,0x20,0x75
	.DB  0x6C,0x61,0x6E,0x67,0x20,0x3F,0x20,0x59
	.DB  0x20,0x2F,0x20,0x4E,0x0
_setingulang:
	.DB  0x44,0x61,0x74,0x61,0x20,0x64,0x69,0x68
	.DB  0x61,0x70,0x75,0x73,0x2E,0x2E,0x2E,0x2E
	.DB  0x2E,0x2E,0x20,0x53,0x65,0x74,0x69,0x6E
	.DB  0x67,0x20,0x75,0x6C,0x61,0x6E,0x67,0x20
	.DB  0x64,0x61,0x74,0x61,0x20,0x61,0x6E,0x64
	.DB  0x61,0x0
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000


__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

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
;CodeWizardAVR V1.25.3 Professional
;Automatic Program Generator
;© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 1/13/2012
;Author  : F4CG
;Company : F4CG
;Comments:
;
;
;Chip type           : ATmega8535
;Program type        : Application
;Clock frequency     : 11.059200 MHz
;Memory model        : Small
;External SRAM size  : 0
;Data Stack size     : 128
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
;#include <string.h>
;#include <delay.h>
;
;#define RXB8 1
;#define TXB8 0
;#define UPE 2
;#define OVR 3
;#define FE 4
;#define UDRE 5
;#define RXC 7
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
; 0000 003E {

	.CSEG
_usart_rx_isr:
	RCALL SUBOPT_0x0
; 0000 003F 	char status,data;
; 0000 0040 	status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0041 	data=UDR;
	IN   R16,12
; 0000 0042 	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0043    	{
; 0000 0044    		rx_buffer[rx_wr_index]=data;
	MOV  R30,R5
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0045    		if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 0046    		if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x5
; 0000 0047       	{
; 0000 0048       		rx_counter=0;
	CLR  R7
; 0000 0049       		rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 004A       	};
_0x5:
; 0000 004B    	};
_0x3:
; 0000 004C }
	RCALL __LOADLOCR2P
	RJMP _0x60
;
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 004F {
_usart_tx_isr:
	RCALL SUBOPT_0x0
; 0000 0050 	if (tx_counter)
	TST  R8
	BREQ _0x6
; 0000 0051    	{
; 0000 0052    		--tx_counter;
	DEC  R8
; 0000 0053    		UDR=tx_buffer[tx_rd_index];
	MOV  R30,R9
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0054    		if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x7
	CLR  R9
; 0000 0055    	};
_0x7:
_0x6:
; 0000 0056 }
_0x60:
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
; 0000 005C {
_getchar:
; 0000 005D 	char data;
; 0000 005E 	while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x8:
	TST  R7
	BREQ _0x8
; 0000 005F 	data=rx_buffer[rx_rd_index];
	MOV  R30,R4
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
; 0000 0060 	if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	INC  R4
	LDI  R30,LOW(8)
	CP   R30,R4
	BRNE _0xB
	CLR  R4
; 0000 0061 	#asm("cli")
_0xB:
	cli
; 0000 0062 	--rx_counter;
	DEC  R7
; 0000 0063 	#asm("sei")
	sei
; 0000 0064 	return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 0065 }
;#pragma used-
;#endif
;
;#ifndef _DEBUG_TERMINAL_IO_
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 006D {
_putchar:
; 0000 006E 	while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0xC:
	LDI  R30,LOW(8)
	CP   R30,R8
	BREQ _0xC
; 0000 006F 	#asm("cli")
	cli
; 0000 0070 	if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R8
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
; 0000 0071    	{
; 0000 0072    		tx_buffer[tx_wr_index]=c;
	MOV  R30,R6
	RCALL SUBOPT_0x1
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 0073    		if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	INC  R6
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x12
	CLR  R6
; 0000 0074    		++tx_counter;
_0x12:
	INC  R8
; 0000 0075    	}
; 0000 0076 	else
	RJMP _0x13
_0xF:
; 0000 0077    	UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 0078 	#asm("sei")
_0x13:
	sei
; 0000 0079 }
	ADIW R28,1
	RET
;#pragma used-
;#endif
;
;void SetIOPorts(void)
; 0000 007E {
_SetIOPorts:
; 0000 007F 	// Input/Output Ports initialization
; 0000 0080 	// Port A initialization
; 0000 0081 	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0082 	// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0083 	PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0084 	DDRA=0x00;
	OUT  0x1A,R30
; 0000 0085 
; 0000 0086 	// Port B initialization
; 0000 0087 	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0088 	// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0089 	PORTB=0x00;
	OUT  0x18,R30
; 0000 008A 	DDRB=0x00;
	OUT  0x17,R30
; 0000 008B 
; 0000 008C 	// Port C initialization
; 0000 008D 	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 008E 	// State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 008F 	PORTC=0x00;
	OUT  0x15,R30
; 0000 0090 	DDRC=0x00;
	OUT  0x14,R30
; 0000 0091 
; 0000 0092 	// Port D initialization
; 0000 0093 	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
; 0000 0094 	// State7=T State6=T State5=T State4=T State3=T State2=T State1=0 State0=T
; 0000 0095 	PORTD=0x00;
	OUT  0x12,R30
; 0000 0096 	DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 0097 }
	RET
;
;void SetUsart4800(void)
; 0000 009A {
_SetUsart4800:
; 0000 009B 	UCSRA=0x00;
	RCALL SUBOPT_0x2
; 0000 009C 	UCSRB=0xD8;
; 0000 009D 	UCSRC=0x86;
; 0000 009E 	UBRRH=0x00;
; 0000 009F 	UBRRL=0x9B;
	LDI  R30,LOW(155)
	RJMP _0x2060001
; 0000 00A0 }
;
;void SetUsart38400(void)
; 0000 00A3 {
_SetUsart38400:
; 0000 00A4 	UCSRA=0x00;
	RCALL SUBOPT_0x2
; 0000 00A5 	UCSRB=0xD8;
; 0000 00A6 	UCSRC=0x86;
; 0000 00A7 	UBRRH=0x00;
; 0000 00A8 	UBRRL=0x11;
	LDI  R30,LOW(17)
_0x2060001:
	OUT  0x9,R30
; 0000 00A9 }
	RET
;
;flash char welcome[] = {"Selamat datang di fasilitas konfigurasi tracker via komunikasi serial/pc"};
;flash char pak[] = {"Press any key !"};
;flash char petunjuk[] = {"Ketik rangkaian setting Tracker yang anda inginkan"};
;flash char mintaCall[] = {"Masukkan Callsign Anda : "};
;flash char mintaSSID[] = {"Masukkan SSID Anda : "};
;flash char mintaPath[] = {"Path anda.. tekan huruf kapital A untuk WIDE2-1, B untuk WIDE2-2, atau C untuk WIDE3-3 : "};
;flash char wide21[] = {"WIDE2-1"};
;flash char wide22[] = {"WIDE2-2"};
;flash char wide33[] = {"WIDE3-3"};
;flash char mintaSimbol[] = {"Masukkan simbol station anda (baca buku petunjuk)"};
;flash char tunggu[] = {"Sedang di proses..."};
;flash char selesai[] = {"Proses selesai"};
;flash char CallAnda[] = {"Callsign anda : "};
;flash char SSIDAnda[] = {"SSID anda : "};
;flash char PathAnda[] = {"Path anda : "};
;flash char SimbolAnda[] = {"Simbol stasiun anda : "};
;flash char reconfigure[] = {"Seting ulang ? Y / N"};
;flash char setingulang[] = {"Data dihapus...... Seting ulang data anda"};
;char call[6];
;char ssid;
;char path;
;char sim;
;char hasil;
;int i;
;
;void KomunikasiSerial(void)
; 0000 00C5 {
_KomunikasiSerial:
; 0000 00C6  	SetUsart38400();
	RCALL _SetUsart38400
; 0000 00C7     //LED tx dinyalakan
; 0000 00C8     putchar(getchar());
	RCALL _getchar
	RCALL SUBOPT_0x3
; 0000 00C9 
; 0000 00CA     for(i=0; i<strlenf(welcome); i++) putchar(welcome[i]);
	RCALL SUBOPT_0x4
_0x15:
	LDI  R30,LOW(_welcome*2)
	LDI  R31,HIGH(_welcome*2)
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
	BRSH _0x16
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_welcome*2)
	SBCI R31,HIGH(-_welcome*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x15
_0x16:
; 0000 00CB putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00CC     delay_ms(1000);
	RCALL SUBOPT_0xB
; 0000 00CD 
; 0000 00CE     for(i=0; i<strlenf(pak); i++) putchar(pak[i]);
_0x18:
	LDI  R30,LOW(_pak*2)
	LDI  R31,HIGH(_pak*2)
	RCALL SUBOPT_0xC
	BRSH _0x19
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_pak*2)
	SBCI R31,HIGH(-_pak*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x18
_0x19:
; 0000 00CF putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00D0     getchar();
	RCALL _getchar
; 0000 00D1 
; 0000 00D2     	ulang:
_0x1A:
; 0000 00D3 
; 0000 00D4     for(i=0; i<strlenf(petunjuk); i++) putchar(petunjuk[i]);
	RCALL SUBOPT_0x4
_0x1C:
	LDI  R30,LOW(_petunjuk*2)
	LDI  R31,HIGH(_petunjuk*2)
	RCALL SUBOPT_0xC
	BRSH _0x1D
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_petunjuk*2)
	SBCI R31,HIGH(-_petunjuk*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x1C
_0x1D:
; 0000 00D5 putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00D6     delay_ms(500);
	RCALL SUBOPT_0xD
; 0000 00D7 
; 0000 00D8     for(i=0; i<strlenf(mintaCall); i++) putchar(mintaCall[i]);
_0x1F:
	LDI  R30,LOW(_mintaCall*2)
	LDI  R31,HIGH(_mintaCall*2)
	RCALL SUBOPT_0xC
	BRSH _0x20
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_mintaCall*2)
	SBCI R31,HIGH(-_mintaCall*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x1F
_0x20:
; 0000 00D9 putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00DA     for(i=0; i<6; i++) {call[i]=getchar();}
	RCALL SUBOPT_0x4
_0x22:
	RCALL SUBOPT_0xE
	BRGE _0x23
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_call)
	SBCI R31,HIGH(-_call)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
	RCALL SUBOPT_0x9
	RJMP _0x22
_0x23:
; 0000 00DB     putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00DC     delay_ms(500);
	RCALL SUBOPT_0xD
; 0000 00DD 
; 0000 00DE     for(i=0; i<strlenf(mintaSSID); i++) putchar(mintaSSID[i]);
_0x25:
	LDI  R30,LOW(_mintaSSID*2)
	LDI  R31,HIGH(_mintaSSID*2)
	RCALL SUBOPT_0xC
	BRSH _0x26
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_mintaSSID*2)
	SBCI R31,HIGH(-_mintaSSID*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x25
_0x26:
; 0000 00DF putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00E0     ssid=getchar();
	RCALL _getchar
	MOV  R11,R30
; 0000 00E1     putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00E2     delay_ms(500);
	RCALL SUBOPT_0xD
; 0000 00E3 
; 0000 00E4     for(i=0; i<strlenf(mintaPath); i++) putchar(mintaPath[i]);
_0x28:
	LDI  R30,LOW(_mintaPath*2)
	LDI  R31,HIGH(_mintaPath*2)
	RCALL SUBOPT_0xC
	BRSH _0x29
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_mintaPath*2)
	SBCI R31,HIGH(-_mintaPath*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x28
_0x29:
; 0000 00E5 putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00E6     path=getchar();
	RCALL _getchar
	MOV  R10,R30
; 0000 00E7     putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00E8     delay_ms(500);
	RCALL SUBOPT_0xD
; 0000 00E9 
; 0000 00EA     for(i=0; i<strlenf(mintaSimbol); i++) putchar(mintaSimbol[i]);
_0x2B:
	LDI  R30,LOW(_mintaSimbol*2)
	LDI  R31,HIGH(_mintaSimbol*2)
	RCALL SUBOPT_0xC
	BRSH _0x2C
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_mintaSimbol*2)
	SBCI R31,HIGH(-_mintaSimbol*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x2B
_0x2C:
; 0000 00EB putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00EC     sim=getchar();
	RCALL _getchar
	MOV  R13,R30
; 0000 00ED     putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00EE     delay_ms(500);
	RCALL SUBOPT_0xD
; 0000 00EF 
; 0000 00F0     for(i=0; i<strlenf(tunggu); i++) putchar(tunggu[i]);
_0x2E:
	LDI  R30,LOW(_tunggu*2)
	LDI  R31,HIGH(_tunggu*2)
	RCALL SUBOPT_0xC
	BRSH _0x2F
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_tunggu*2)
	SBCI R31,HIGH(-_tunggu*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x2E
_0x2F:
; 0000 00F1 putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00F2     delay_ms(125);
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	RCALL SUBOPT_0x5
	RCALL _delay_ms
; 0000 00F3 
; 0000 00F4     for(i=0; i<strlenf(selesai); i++) putchar(selesai[i]);
	RCALL SUBOPT_0x4
_0x31:
	LDI  R30,LOW(_selesai*2)
	LDI  R31,HIGH(_selesai*2)
	RCALL SUBOPT_0xC
	BRSH _0x32
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_selesai*2)
	SBCI R31,HIGH(-_selesai*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x31
_0x32:
; 0000 00F5 putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00F6 
; 0000 00F7     for(i=0; i<strlenf(CallAnda); i++) putchar(CallAnda[i]);
	RCALL SUBOPT_0x4
_0x34:
	LDI  R30,LOW(_CallAnda*2)
	LDI  R31,HIGH(_CallAnda*2)
	RCALL SUBOPT_0xC
	BRSH _0x35
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_CallAnda*2)
	SBCI R31,HIGH(-_CallAnda*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x34
_0x35:
; 0000 00F8 for(i=0; i<6; i++) {putchar(call[i]);}
	RCALL SUBOPT_0x4
_0x37:
	RCALL SUBOPT_0xE
	BRGE _0x38
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_call)
	SBCI R31,HIGH(-_call)
	LD   R30,Z
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x9
	RJMP _0x37
_0x38:
; 0000 00F9     putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00FA 
; 0000 00FB     for(i=0; i<strlenf(SSIDAnda); i++) putchar(SSIDAnda[i]);
	RCALL SUBOPT_0x4
_0x3A:
	LDI  R30,LOW(_SSIDAnda*2)
	LDI  R31,HIGH(_SSIDAnda*2)
	RCALL SUBOPT_0xC
	BRSH _0x3B
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_SSIDAnda*2)
	SBCI R31,HIGH(-_SSIDAnda*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x3A
_0x3B:
; 0000 00FC putchar(ssid);
	ST   -Y,R11
	RCALL _putchar
; 0000 00FD     putchar('\n');
	RCALL SUBOPT_0xA
; 0000 00FE 
; 0000 00FF     for(i=0; i<strlenf(PathAnda); i++) putchar(PathAnda[i]);
	RCALL SUBOPT_0x4
_0x3D:
	LDI  R30,LOW(_PathAnda*2)
	LDI  R31,HIGH(_PathAnda*2)
	RCALL SUBOPT_0xC
	BRSH _0x3E
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_PathAnda*2)
	SBCI R31,HIGH(-_PathAnda*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x3D
_0x3E:
; 0000 0100 if((path=='A') || (path=='a')){for(i=0; i<strlenf(wide21); i++) putchar(wide21[i]);}
	LDI  R30,LOW(65)
	CP   R30,R10
	BREQ _0x40
	LDI  R30,LOW(97)
	CP   R30,R10
	BRNE _0x3F
_0x40:
	RCALL SUBOPT_0x4
_0x43:
	LDI  R30,LOW(_wide21*2)
	LDI  R31,HIGH(_wide21*2)
	RCALL SUBOPT_0xC
	BRSH _0x44
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_wide21*2)
	SBCI R31,HIGH(-_wide21*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x43
_0x44:
; 0000 0101     else if((path=='B') || (path=='b')){for(i=0; i<strlenf(wide22); i++) putchar(wide22[i]);}
	RJMP _0x45
_0x3F:
	LDI  R30,LOW(66)
	CP   R30,R10
	BREQ _0x47
	LDI  R30,LOW(98)
	CP   R30,R10
	BRNE _0x46
_0x47:
	RCALL SUBOPT_0x4
_0x4A:
	LDI  R30,LOW(_wide22*2)
	LDI  R31,HIGH(_wide22*2)
	RCALL SUBOPT_0xC
	BRSH _0x4B
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_wide22*2)
	SBCI R31,HIGH(-_wide22*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x4A
_0x4B:
; 0000 0102     else {for(i=0; i<strlenf(wide33); i++) putchar(wide33[i]);}
	RJMP _0x4C
_0x46:
	RCALL SUBOPT_0x4
_0x4E:
	LDI  R30,LOW(_wide33*2)
	LDI  R31,HIGH(_wide33*2)
	RCALL SUBOPT_0xC
	BRSH _0x4F
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_wide33*2)
	SBCI R31,HIGH(-_wide33*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x4E
_0x4F:
_0x4C:
_0x45:
; 0000 0103     putchar('\n');
	RCALL SUBOPT_0xA
; 0000 0104 
; 0000 0105     for(i=0; i<strlenf(SimbolAnda); i++) putchar(SimbolAnda[i]);
	RCALL SUBOPT_0x4
_0x51:
	LDI  R30,LOW(_SimbolAnda*2)
	LDI  R31,HIGH(_SimbolAnda*2)
	RCALL SUBOPT_0xC
	BRSH _0x52
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_SimbolAnda*2)
	SBCI R31,HIGH(-_SimbolAnda*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x51
_0x52:
; 0000 0106 putchar(sim);
	ST   -Y,R13
	RCALL _putchar
; 0000 0107     putchar('\n');
	RCALL SUBOPT_0xA
; 0000 0108     delay_ms(1000);
	RCALL SUBOPT_0xB
; 0000 0109 
; 0000 010A     for(i=0; i<strlenf(reconfigure); i++) putchar(reconfigure[i]);
_0x54:
	LDI  R30,LOW(_reconfigure*2)
	LDI  R31,HIGH(_reconfigure*2)
	RCALL SUBOPT_0xC
	BRSH _0x55
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_reconfigure*2)
	SBCI R31,HIGH(-_reconfigure*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x54
_0x55:
; 0000 010B putchar('\n');
	RCALL SUBOPT_0xA
; 0000 010C 
; 0000 010D     hasil = getchar();
	RCALL _getchar
	MOV  R12,R30
; 0000 010E 
; 0000 010F     if((hasil=='N') || (hasil=='n'))
	LDI  R30,LOW(78)
	CP   R30,R12
	BREQ _0x57
	LDI  R30,LOW(110)
	CP   R30,R12
	BRNE _0x56
_0x57:
; 0000 0110     {
; 0000 0111     	for(i=0; i<strlenf(setingulang); i++) putchar(setingulang[i]);
	RCALL SUBOPT_0x4
_0x5A:
	LDI  R30,LOW(_setingulang*2)
	LDI  R31,HIGH(_setingulang*2)
	RCALL SUBOPT_0xC
	BRSH _0x5B
	RCALL SUBOPT_0x7
	SUBI R30,LOW(-_setingulang*2)
	SBCI R31,HIGH(-_setingulang*2)
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x9
	RJMP _0x5A
_0x5B:
; 0000 0112 putchar('\n');
	RCALL SUBOPT_0xA
; 0000 0113         goto ulang;
	RJMP _0x1A
; 0000 0114     }
; 0000 0115     //led tx dimatikan
; 0000 0116     SetUsart4800();
_0x56:
	RCALL _SetUsart4800
; 0000 0117 }
	RET
;
;void main(void)
; 0000 011A {
_main:
; 0000 011B 	SetIOPorts();
	RCALL _SetIOPorts
; 0000 011C 
; 0000 011D     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 011E 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 011F 
; 0000 0120     SetUsart4800();
	RCALL _SetUsart4800
; 0000 0121 
; 0000 0122 	#asm("sei")
	sei
; 0000 0123 
; 0000 0124 	while (1)
_0x5C:
; 0000 0125     {
; 0000 0126     	KomunikasiSerial();
	RCALL _KomunikasiSerial
; 0000 0127 	};
	RJMP _0x5C
; 0000 0128 }
_0x5F:
	RJMP _0x5F
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

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8
_call:
	.BYTE 0x6
_i:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	OUT  0xB,R30
	LDI  R30,LOW(216)
	OUT  0xA,R30
	LDI  R30,LOW(134)
	OUT  0x20,R30
	LDI  R30,LOW(0)
	OUT  0x20,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 39 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x3:
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:74 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	STS  _i,R30
	STS  _i+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:100 WORDS
SUBOPT_0x6:
	RCALL _strlenf
	LDS  R26,_i
	LDS  R27,_i+1
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x7:
	LDS  R30,_i
	LDS  R31,_i+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x8:
	LPM  R30,Z
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:112 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_i)
	LDI  R27,HIGH(_i)
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(10)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x5
	RCALL _delay_ms
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xC:
	RCALL SUBOPT_0x5
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x5
	RCALL _delay_ms
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDS  R26,_i
	LDS  R27,_i+1
	SBIW R26,6
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

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
