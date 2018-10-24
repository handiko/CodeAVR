
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
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
;'char' is unsigned       : No
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1119
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
	.DEF _beacon_stat=R7
	.DEF _crc=R8
	.DEF _tcnt1c=R6

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
	RJMP _timer1_ovf_isr
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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x30,0x32,0x30,0x2E,0x30,0x43
_0x4:
	.DB  0x30,0x31,0x32,0x2E,0x30,0x56
_0x5:
	.DB  0x21,0x21,0x57
_0x6:
	.DB  0x2F,0x41,0x3D,0x30,0x30,0x30,0x30,0x30
	.DB  0x30
_0x12D:
	.DB  0x0,0x0
_0x2080060:
	.DB  0x1
_0x2080000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  _temp
	.DW  _0x3*2

	.DW  0x06
	.DW  _volt
	.DW  _0x4*2

	.DW  0x03
	.DW  _comp_cst
	.DW  _0x5*2

	.DW  0x09
	.DW  _norm_alt
	.DW  _0x6*2

	.DW  0x02
	.DW  0x06
	.DW  _0x12D*2

	.DW  0x01
	.DW  __seed_G104
	.DW  _0x2080060*2

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
;Date    : 5/24/2014
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega8
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega8.h>
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
;#include <stdint.h>
;#include <delay.h>
;#include <math.h>
;
;// Enabling this area : RX on Int TX on noInt
;/*
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
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
;{
;	char status,data;
;	status=UCSRA;
;	data=UDR;
;	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
;   	{
;   		rx_buffer[rx_wr_index++]=data;
;		#if RX_BUFFER_SIZE == 256
;   			// special case for receiver buffer size=256
;   			if (++rx_counter == 0)
;      			{
;		#else
;   			if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
;   			if (++rx_counter == RX_BUFFER_SIZE)
;      			{
;      				rx_counter=0;
;		#endif
;      				rx_buffer_overflow=1;
;      			}
;   	}
;}
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
;{
;	char data;
;	while (rx_counter==0);
;	data=rx_buffer[rx_rd_index++];
;	#if RX_BUFFER_SIZE != 256
;		if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
;	#endif
;	#asm("cli")
;		--rx_counter;
;	#asm("sei")
;	return data;
;}
;#pragma used-
;#endif
;*/
;
;// Enabling this area : RX on Int TX on Int
;/*
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
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
;{
;char status,data;
;status=UCSRA;
;data=UDR;
;if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
;   {
;   rx_buffer[rx_wr_index++]=data;
;#if RX_BUFFER_SIZE == 256
;   // special case for receiver buffer size=256
;   if (++rx_counter == 0)
;      {
;#else
;   if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
;   if (++rx_counter == RX_BUFFER_SIZE)
;      {
;      rx_counter=0;
;#endif
;      rx_buffer_overflow=1;
;      }
;   }
;}
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
;{
;char data;
;while (rx_counter==0);
;data=rx_buffer[rx_rd_index++];
;#if RX_BUFFER_SIZE != 256
;if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
;#endif
;#asm("cli")
;--rx_counter;
;#asm("sei")
;return data;
;}
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
;{
;if (tx_counter)
;   {
;   --tx_counter;
;   UDR=tx_buffer[tx_rd_index++];
;#if TX_BUFFER_SIZE != 256
;   if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
;#endif
;   }
;}
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
;{
;while (tx_counter == TX_BUFFER_SIZE);
;#asm("cli")
;if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
;   {
;   tx_buffer[tx_wr_index++]=c;
;#if TX_BUFFER_SIZE != 256
;   if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
;#endif
;   ++tx_counter;
;   }
;else
;   UDR=c;
;#asm("sei")
;}
;#pragma used-
;#endif
;*/
;
;#define ADC_VREF_TYPE 0x00
;#define AFOUT	PORTB.4
;#define PTT	PORTB.5
;#define MERAH	PORTD.6
;#define HIJAU	PORTD.7
;#define VSENSE_ADC_	0
;#define TEMP_ADC_	1
;
;#define _1200		0
;#define _2200		1
;#define TX_DELAY_ 	45
;#define FLAG_		0x7E
;#define	CONTROL_FIELD_	0x03
;#define PROTOCOL_ID_	0xF0
;#define TD_POSISI_ 	'='
;#define TD_STATUS_	'>'
;#define TX_TAIL_	5
;
;void read_temp(void);
;void read_volt(void);
;void base91_lat(void);
;void base91_long(void);
;void base91_alt(void);
;void calc_tel_data(void);
;void kirim_add_aprs(void);
;void kirim_add_tel(void);
;void kirim_ax25_head(void);
;void kirim_tele_data(void);
;void kirim_tele_param(void);
;void kirim_tele_unit(void);
;void kirim_tele_eqns(void);
;void kirim_status(void);
;void kirim_paket(void);
;void kirim_crc(void);
;void kirim_karakter(unsigned char input);
;void hitung_crc(char in_crc);
;void ubah_nada(void);
;void set_nada(char i_nada);
;unsigned int read_adc(unsigned char adc_input);
;void waitComma(void);
;void extractGPS(void);
;
;eeprom char SYM_TAB_OVL_='/';
;eeprom char SYM_CODE_='O';
;eeprom unsigned char add_aprs[]={('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),('0'<<1)};
;eeprom unsigned char add_beacon[]={('B'<<1),('E'<<1),('A'<<1),('C'<<1),('O'<<1),('N'<<1),('0'<<1)};
;eeprom unsigned char add_tel[]={('T'<<1),('E'<<1),('L'<<1),(' '<<1),(' '<<1),(' '<<1),('0'<<1)};
;eeprom unsigned char data_1[] =
;{
;	('Y'<<1),('B'<<1),('2'<<1),('Y'<<1),('O'<<1),('U'<<1),((11+'0')<<1),
;	('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1
;};
;eeprom char status[] ={"High Altitude Balloon - Teknik Fisika UGM"};
;eeprom char message_head[12]={":YB2YOU-11:"};
;eeprom char param[] ={"PARM.Temp,B.Volt,Alti"};
;eeprom char unit[]  ={"UNIT.Deg.C,Volt,Feet"};
;eeprom char eqns[]  ={"EQNS.0,0.1,0,0,0.1,0,0,66,0"};
;eeprom char posisi_lat[]={"0745.98S"};
;eeprom char posisi_long[]={"11022.36E"};
;eeprom unsigned int altitude = 0;
;eeprom char m_int=21;
;eeprom char comp_lat[4];
;eeprom char comp_long[4];
;eeprom int seq=0;
;eeprom int timeIntv=4;
;eeprom char gps='Y';
;eeprom char pri1='T';
;eeprom char pri2='B';
;eeprom char pri3='A';
;eeprom char pri4='2';
;eeprom char pri5='3';
;
;char temp[]={"020.0C"};

	.DSEG
;char volt[]={"012.0V"};
;char comp_cst[3]={33,33,(0b00110110+33)};
;char norm_alt[]={"/A=000000"};
;char beacon_stat = 0;
;bit nada = _1200;
;static char bit_stuff = 0;
;unsigned short crc;
;char seq_num[3];
;char ch1[3];
;char ch2[3];
;char ch3[3];
;//char m_count;
;char alti[3];
;char tcnt1c=0;
;
;void read_temp(void)
; 0000 0162 {

	.CSEG
_read_temp:
; 0000 0163 
; 0000 0164         unsigned int adc;
; 0000 0165         char adc_r,adc_p,adc_s,adc_d;
; 0000 0166 
; 0000 0167         adc = (5*read_adc(TEMP_ADC_)/1.024);
	RCALL __SAVELOCR6
;	adc -> R16,R17
;	adc_r -> R19
;	adc_p -> R18
;	adc_s -> R21
;	adc_d -> R20
	LDI  R30,LOW(1)
	RCALL SUBOPT_0x0
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	RCALL SUBOPT_0x1
	__GETD1N 0x3F83126F
	RCALL SUBOPT_0x2
; 0000 0168 
; 0000 0169         adc_r = (adc/1000);
; 0000 016A         adc_p = ((adc%1000)/100);
; 0000 016B         adc_s = ((adc%100)/10);
; 0000 016C         adc_d = (adc%10);
; 0000 016D 
; 0000 016E         if(adc_r==0)temp[0]='!';
	BRNE _0x7
	LDI  R30,LOW(33)
	RJMP _0x122
; 0000 016F         else temp[0] = adc_r + '0';
_0x7:
	MOV  R30,R19
	SUBI R30,-LOW(48)
_0x122:
	STS  _temp,R30
; 0000 0170         if((adc_p==0)&&(adc_r==0)) temp[1]='!';
	CPI  R18,0
	BRNE _0xA
	CPI  R19,0
	BREQ _0xB
_0xA:
	RJMP _0x9
_0xB:
	LDI  R30,LOW(33)
	RJMP _0x123
; 0000 0171         else temp[1] = adc_p + '0';
_0x9:
	MOV  R30,R18
	SUBI R30,-LOW(48)
_0x123:
	__PUTB1MN _temp,1
; 0000 0172         temp[2] = adc_s + '0';
	MOV  R30,R21
	SUBI R30,-LOW(48)
	__PUTB1MN _temp,2
; 0000 0173         temp[4] = adc_d + '0';
	MOV  R30,R20
	SUBI R30,-LOW(48)
	__PUTB1MN _temp,4
; 0000 0174 }
	RJMP _0x20A0009
;
;void read_volt(void)
; 0000 0177 {
_read_volt:
; 0000 0178 	unsigned int adc;
; 0000 0179         char adc_r,adc_p,adc_s,adc_d;
; 0000 017A 
; 0000 017B         adc = (5*22*read_adc(VSENSE_ADC_))/102.4;
	RCALL __SAVELOCR6
;	adc -> R16,R17
;	adc_r -> R19
;	adc_p -> R18
;	adc_s -> R21
;	adc_d -> R20
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x0
	LDI  R26,LOW(110)
	LDI  R27,HIGH(110)
	RCALL SUBOPT_0x1
	__GETD1N 0x42CCCCCD
	RCALL SUBOPT_0x2
; 0000 017C 
; 0000 017D         adc_r = (adc/1000);
; 0000 017E         adc_p = ((adc%1000)/100);
; 0000 017F         adc_s = ((adc%100)/10);
; 0000 0180         adc_d = (adc%10);
; 0000 0181 
; 0000 0182         if(adc_r==0)	volt[0]='!';
	BRNE _0xD
	LDI  R30,LOW(33)
	RJMP _0x124
; 0000 0183         else volt[0] = adc_r + '0';
_0xD:
	MOV  R30,R19
	SUBI R30,-LOW(48)
_0x124:
	STS  _volt,R30
; 0000 0184         if((adc_p==0)&&(adc_r==0)) volt[1]='!';
	CPI  R18,0
	BRNE _0x10
	CPI  R19,0
	BREQ _0x11
_0x10:
	RJMP _0xF
_0x11:
	LDI  R30,LOW(33)
	RJMP _0x125
; 0000 0185         else volt[1] = adc_p + '0';
_0xF:
	MOV  R30,R18
	SUBI R30,-LOW(48)
_0x125:
	__PUTB1MN _volt,1
; 0000 0186         volt[2] = adc_s + '0';
	MOV  R30,R21
	SUBI R30,-LOW(48)
	__PUTB1MN _volt,2
; 0000 0187         volt[4] = adc_d + '0';
	MOV  R30,R20
	SUBI R30,-LOW(48)
	__PUTB1MN _volt,4
; 0000 0188 }
_0x20A0009:
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
;
;void base91_lat(void)
; 0000 018B {
_base91_lat:
; 0000 018C   	char deg;
; 0000 018D         char min;
; 0000 018E         float sec;
; 0000 018F         char sign;
; 0000 0190         float lat;
; 0000 0191         float f_lat;
; 0000 0192 
; 0000 0193         deg = ((posisi_lat[0]-48)*10) + (posisi_lat[1]-48);
	SBIW R28,12
	RCALL __SAVELOCR4
;	deg -> R17
;	min -> R16
;	sec -> Y+12
;	sign -> R19
;	lat -> Y+8
;	f_lat -> Y+4
	LDI  R26,LOW(_posisi_lat)
	LDI  R27,HIGH(_posisi_lat)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(10)
	MULS R30,R26
	__POINTW2MN _posisi_lat,1
	RCALL SUBOPT_0x3
	ADD  R30,R0
	MOV  R17,R30
; 0000 0194         min = ((posisi_lat[2]-48)*10) + (posisi_lat[3]-48);
	__POINTW2MN _posisi_lat,2
	RCALL SUBOPT_0x3
	LDI  R26,LOW(10)
	MULS R30,R26
	__POINTW2MN _posisi_lat,3
	RCALL SUBOPT_0x3
	ADD  R30,R0
	MOV  R16,R30
; 0000 0195         //sec = ((posisi_lat[5]-48)*1000.0) + ((posisi_lat[6]-48)*100.0)+((posisi_lat[7]-48)*10.0) + (posisi_lat[8]-48);
; 0000 0196         sec = ((posisi_lat[5]-48)*10.0) + (posisi_lat[6]-48);
	__POINTW2MN _posisi_lat,5
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _posisi_lat,6
	RCALL SUBOPT_0x3
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x6
; 0000 0197 
; 0000 0198         if(posisi_lat[7]=='N') sign = 1.0;
	__POINTW2MN _posisi_lat,7
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x4E)
	BRNE _0x13
	RCALL SUBOPT_0x7
	RJMP _0x126
; 0000 0199         else sign = -1.0;
_0x13:
	RCALL SUBOPT_0x8
_0x126:
	MOV  R19,R30
; 0000 019A 
; 0000 019B         //f_lat = (deg + (min/60.0) + (0.6*sec/360000.0));
; 0000 019C         f_lat = (deg + (min/60.0) + (0.6*sec/3600.0));
	RCALL SUBOPT_0x9
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	RCALL SUBOPT_0xB
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xC
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0xD
; 0000 019D         lat = 380926 * (90 - (f_lat * sign));
	__GETD2N 0x42B40000
	RCALL SUBOPT_0xE
	__GETD2N 0x48B9FFC0
	RCALL SUBOPT_0xF
; 0000 019E 
; 0000 019F         comp_lat[0] = (lat/753571)+33;
	LDI  R26,LOW(_comp_lat)
	LDI  R27,HIGH(_comp_lat)
	RCALL SUBOPT_0x10
; 0000 01A0         comp_lat[1] = ((fmod(lat,753571))/8281)+33;
	RCALL SUBOPT_0x11
	__POINTW2MN _comp_lat,1
	RCALL SUBOPT_0x10
; 0000 01A1         comp_lat[2] = ((fmod(lat,8281))/91)+33;
	RCALL SUBOPT_0x12
	__POINTW2MN _comp_lat,2
	RCALL SUBOPT_0x10
; 0000 01A2         comp_lat[3] = (fmod(lat,91))+33;
	RCALL SUBOPT_0x13
	__POINTW2MN _comp_lat,3
	RJMP _0x20A0008
; 0000 01A3 }
;
;void base91_long(void)
; 0000 01A6 {
_base91_long:
; 0000 01A7   	char deg;
; 0000 01A8         char min;
; 0000 01A9         float sec;
; 0000 01AA         char sign;
; 0000 01AB         float lon;
; 0000 01AC         float f_lon;
; 0000 01AD 
; 0000 01AE         deg = ((posisi_long[0]-48)*100) + ((posisi_long[1]-48)*10) + (posisi_long[2]-48);
	SBIW R28,12
	RCALL __SAVELOCR4
;	deg -> R17
;	min -> R16
;	sec -> Y+12
;	sign -> R19
;	lon -> Y+8
;	f_lon -> Y+4
	LDI  R26,LOW(_posisi_long)
	LDI  R27,HIGH(_posisi_long)
	RCALL SUBOPT_0x3
	LDI  R26,LOW(100)
	MULS R30,R26
	MOV  R18,R0
	__POINTW2MN _posisi_long,1
	RCALL SUBOPT_0x3
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	ADD  R30,R18
	MOV  R0,R30
	__POINTW2MN _posisi_long,2
	RCALL SUBOPT_0x3
	ADD  R30,R0
	MOV  R17,R30
; 0000 01AF         min = ((posisi_long[3]-48)*10) + (posisi_long[4]-48);
	__POINTW2MN _posisi_long,3
	RCALL SUBOPT_0x3
	LDI  R26,LOW(10)
	MULS R30,R26
	__POINTW2MN _posisi_long,4
	RCALL SUBOPT_0x3
	ADD  R30,R0
	MOV  R16,R30
; 0000 01B0         //sec = ((posisi_long[6]-48)*1000.0) + ((posisi_long[7]-48)*100.0) + ((posisi_long[8]-48)*10.0) + (posisi_long[9]-48);
; 0000 01B1         sec = ((posisi_long[6]-48)*10.0) + (posisi_long[7]-48);
	__POINTW2MN _posisi_long,6
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _posisi_long,7
	RCALL SUBOPT_0x3
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0x6
; 0000 01B2 
; 0000 01B3         if(posisi_long[8]=='E') sign = -1.0;
	__POINTW2MN _posisi_long,8
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x45)
	BRNE _0x15
	RCALL SUBOPT_0x8
	RJMP _0x127
; 0000 01B4         else			sign = 1.0;
_0x15:
	RCALL SUBOPT_0x7
_0x127:
	MOV  R19,R30
; 0000 01B5 
; 0000 01B6         //f_lon = (deg + (min/60.0) + (0.6*sec/360000.0));
; 0000 01B7         f_lon = (deg + (min/60.0) + (0.6*sec/3600.0));
	RCALL SUBOPT_0x9
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xA
	POP  R26
	POP  R27
	RCALL SUBOPT_0xB
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xC
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0xD
; 0000 01B8         lon = 190463 * (180 - (f_lon * sign));
	__GETD2N 0x43340000
	RCALL SUBOPT_0xE
	__GETD2N 0x4839FFC0
	RCALL SUBOPT_0xF
; 0000 01B9 
; 0000 01BA         comp_long[0] = (lon/753571)+33;
	LDI  R26,LOW(_comp_long)
	LDI  R27,HIGH(_comp_long)
	RCALL SUBOPT_0x10
; 0000 01BB         comp_long[1] = ((fmod(lon,753571))/8281)+33;
	RCALL SUBOPT_0x11
	__POINTW2MN _comp_long,1
	RCALL SUBOPT_0x10
; 0000 01BC         comp_long[2] = ((fmod(lon,8281))/91)+33;
	RCALL SUBOPT_0x12
	__POINTW2MN _comp_long,2
	RCALL SUBOPT_0x10
; 0000 01BD         comp_long[3] = (fmod(lon,91))+33;
	RCALL SUBOPT_0x13
	__POINTW2MN _comp_long,3
_0x20A0008:
	RCALL __CFD1
	RCALL __EEPROMWRB
; 0000 01BE }
	RCALL __LOADLOCR4
	ADIW R28,16
	RET
;
;void base91_alt(void)
; 0000 01C1 {
_base91_alt:
; 0000 01C2 	int alt;
; 0000 01C3 
; 0000 01C4         alt = (500.5*log(altitude*1.0));
	RCALL __SAVELOCR2
;	alt -> R16,R17
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL SUBOPT_0x16
	RCALL __MULF12
	RCALL __PUTPARD1
	RCALL _log
	__GETD2N 0x43FA4000
	RCALL SUBOPT_0x17
; 0000 01C5         comp_cst[0] = (alt/91)+33;
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	RCALL __DIVW21
	SUBI R30,-LOW(33)
	STS  _comp_cst,R30
; 0000 01C6         comp_cst[1] = (alt%91)+33;
	MOVW R26,R16
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	RCALL __MODW21
	SUBI R30,-LOW(33)
	__PUTB1MN _comp_cst,1
; 0000 01C7 }
	RJMP _0x20A0007
;
;void normal_alt(void)
; 0000 01CA {
_normal_alt:
; 0000 01CB 	norm_alt[3]=(altitude/100000)+'0';
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x18
	RCALL __DIVD21U
	SUBI R30,-LOW(48)
	__PUTB1MN _norm_alt,3
; 0000 01CC         norm_alt[4]=((altitude%100000)/10000)+'0';
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x18
	RCALL __MODD21U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x2710
	RCALL __DIVD21U
	SUBI R30,-LOW(48)
	__PUTB1MN _norm_alt,4
; 0000 01CD         norm_alt[5]=((altitude%10000)/1000)+'0';
	RCALL SUBOPT_0x14
	MOVW R26,R30
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	RCALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	SUBI R30,-LOW(48)
	__PUTB1MN _norm_alt,5
; 0000 01CE         norm_alt[6]=((altitude%1000)/100)+'0';
	RCALL SUBOPT_0x14
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MODW21U
	RCALL SUBOPT_0x19
	RCALL __DIVW21U
	SUBI R30,-LOW(48)
	__PUTB1MN _norm_alt,6
; 0000 01CF         norm_alt[7]=((altitude%100)/10)+'0';
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x19
	RCALL __MODW21U
	RCALL SUBOPT_0x1A
	RCALL __DIVW21U
	SUBI R30,-LOW(48)
	__PUTB1MN _norm_alt,7
; 0000 01D0         norm_alt[8]=(altitude%10)+'0';
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x1A
	RCALL __MODW21U
	SUBI R30,-LOW(48)
	__PUTB1MN _norm_alt,8
; 0000 01D1 }
	RET
;
;void calc_tel_data(void)
; 0000 01D4 {
_calc_tel_data:
; 0000 01D5 	int adc;
; 0000 01D6 
; 0000 01D7         seq_num[0]=(seq/100)+'0';
	RCALL __SAVELOCR2
;	adc -> R16,R17
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
	STS  _seq_num,R30
; 0000 01D8         seq_num[1]=((seq%100)/10)+'0';
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1C
	__PUTB1MN _seq_num,1
; 0000 01D9         seq_num[2]=(seq%10)+'0';
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1F
	__PUTB1MN _seq_num,2
; 0000 01DA 
; 0000 01DB         adc=0.25*read_adc(2);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x20
; 0000 01DC         ch1[0]=(adc/100)+'0';
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1C
	STS  _ch1,R30
; 0000 01DD         ch1[1]=((adc%100)/10)+'0';
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x1C
	__PUTB1MN _ch1,1
; 0000 01DE         ch1[2]=(adc%10)+'0';
	RCALL SUBOPT_0x23
	__PUTB1MN _ch1,2
; 0000 01DF 
; 0000 01E0         adc=0.25*read_adc(3);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x20
; 0000 01E1         ch2[0]=(adc/100)+'0';
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1C
	STS  _ch2,R30
; 0000 01E2         ch2[1]=((adc%100)/10)+'0';
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x1C
	__PUTB1MN _ch2,1
; 0000 01E3         ch2[2]=(adc%10)+'0';
	RCALL SUBOPT_0x23
	__PUTB1MN _ch2,2
; 0000 01E4 
; 0000 01E5         adc=0.25*read_adc(4);
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x20
; 0000 01E6         ch3[0]=(adc/100)+'0';
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1C
	STS  _ch3,R30
; 0000 01E7         ch3[1]=((adc%100)/10)+'0';
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x1C
	__PUTB1MN _ch3,1
; 0000 01E8         ch3[2]=(adc%10)+'0';
	RCALL SUBOPT_0x23
	__PUTB1MN _ch3,2
; 0000 01E9 
; 0000 01EA         adc=altitude/66;
	RCALL SUBOPT_0x14
	MOVW R26,R30
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	RCALL __DIVW21U
	MOVW R16,R30
; 0000 01EB         alti[0]=(adc/100)+'0';
	MOVW R26,R16
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1C
	STS  _alti,R30
; 0000 01EC         alti[1]=((adc%100)/10)+'0';
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x1C
	__PUTB1MN _alti,1
; 0000 01ED         alti[2]=(adc%10)+'0';
	RCALL SUBOPT_0x23
	__PUTB1MN _alti,2
; 0000 01EE 
; 0000 01EF         seq++;
	RCALL SUBOPT_0x1E
	ADIW R30,1
	RCALL __EEPROMWRW
	SBIW R30,1
; 0000 01F0 	if(seq==999)seq=0;
	RCALL SUBOPT_0x1E
	CPI  R30,LOW(0x3E7)
	LDI  R26,HIGH(0x3E7)
	CPC  R31,R26
	BRNE _0x17
	LDI  R26,LOW(_seq)
	LDI  R27,HIGH(_seq)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
; 0000 01F1 
; 0000 01F2         altitude+=3;
_0x17:
	RCALL SUBOPT_0x14
	ADIW R30,3
	LDI  R26,LOW(_altitude)
	LDI  R27,HIGH(_altitude)
	RCALL __EEPROMWRW
; 0000 01F3         if(altitude==65535)altitude=0;
	RCALL SUBOPT_0x14
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x18
	LDI  R26,LOW(_altitude)
	LDI  R27,HIGH(_altitude)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
; 0000 01F4 }
_0x18:
_0x20A0007:
	RCALL __LOADLOCR2P
	RET
;
;void kirim_add_aprs(void)
; 0000 01F7 {
_kirim_add_aprs:
; 0000 01F8 	char i;
; 0000 01F9 
; 0000 01FA         for(i=0;i<7;i++)kirim_karakter(add_aprs[i]);
	RCALL SUBOPT_0x24
;	i -> R17
_0x1A:
	CPI  R17,7
	BRGE _0x1B
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_add_aprs)
	SBCI R27,HIGH(-_add_aprs)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x1A
_0x1B:
; 0000 01FB }
	RJMP _0x20A0006
;
;void kirim_add_tel(void)
; 0000 01FE {
_kirim_add_tel:
; 0000 01FF 	char i;
; 0000 0200 
; 0000 0201         for(i=0;i<7;i++)kirim_karakter(add_tel[i]);
	RCALL SUBOPT_0x24
;	i -> R17
_0x1D:
	CPI  R17,7
	BRGE _0x1E
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_add_tel)
	SBCI R27,HIGH(-_add_tel)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x1D
_0x1E:
; 0000 0202 }
	RJMP _0x20A0006
;
;void kirim_ax25_head(void)
; 0000 0205 {
_kirim_ax25_head:
; 0000 0206 	char i;
; 0000 0207 
; 0000 0208         for(i=0;i<14;i++)kirim_karakter(data_1[i]);
	RCALL SUBOPT_0x24
;	i -> R17
_0x20:
	CPI  R17,14
	BRGE _0x21
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_data_1)
	SBCI R27,HIGH(-_data_1)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x20
_0x21:
; 0000 0209 kirim_karakter(0x03);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x27
; 0000 020A 	kirim_karakter(PROTOCOL_ID_);
	LDI  R30,LOW(240)
	RCALL SUBOPT_0x27
; 0000 020B }
	RJMP _0x20A0006
;
;void send_batt(void)
; 0000 020E {
_send_batt:
; 0000 020F 	if(volt[1]!='!')kirim_karakter(volt[1]);
	__GETB2MN _volt,1
	CPI  R26,LOW(0x21)
	BREQ _0x22
	__GETB1MN _volt,1
	RJMP _0x128
; 0000 0210         else		kirim_karakter('0');
_0x22:
	LDI  R30,LOW(48)
_0x128:
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 0211         kirim_karakter(volt[2]);
	__GETB1MN _volt,2
	RCALL SUBOPT_0x27
; 0000 0212         kirim_karakter(volt[4]);
	__GETB1MN _volt,4
	RJMP _0x20A0005
; 0000 0213 }
;
;void send_temp(void)
; 0000 0216 {
_send_temp:
; 0000 0217 	if(temp[1]!='!')kirim_karakter(temp[1]);
	__GETB2MN _temp,1
	CPI  R26,LOW(0x21)
	BREQ _0x24
	__GETB1MN _temp,1
	RJMP _0x129
; 0000 0218         else		kirim_karakter('0');
_0x24:
	LDI  R30,LOW(48)
_0x129:
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 0219         kirim_karakter(temp[2]);
	__GETB1MN _temp,2
	RCALL SUBOPT_0x27
; 0000 021A         kirim_karakter(temp[4]);
	__GETB1MN _temp,4
	RJMP _0x20A0005
; 0000 021B }
;void send_alti(void)
; 0000 021D {
_send_alti:
; 0000 021E 	char i;
; 0000 021F         for(i=0;i<3;i++)kirim_karakter(alti[i]);
	RCALL SUBOPT_0x24
;	i -> R17
_0x27:
	CPI  R17,3
	BRGE _0x28
	RCALL SUBOPT_0x28
	SUBI R30,LOW(-_alti)
	SBCI R31,HIGH(-_alti)
	RCALL SUBOPT_0x29
	SUBI R17,-1
	RJMP _0x27
_0x28:
; 0000 0220 }
	RJMP _0x20A0006
;
;void send_ch1(void)
; 0000 0223 {
_send_ch1:
; 0000 0224 	char i;
; 0000 0225         for(i=0;i<3;i++)kirim_karakter(ch1[i]);
	RCALL SUBOPT_0x24
;	i -> R17
_0x2A:
	CPI  R17,3
	BRGE _0x2B
	RCALL SUBOPT_0x28
	SUBI R30,LOW(-_ch1)
	SBCI R31,HIGH(-_ch1)
	RCALL SUBOPT_0x29
	SUBI R17,-1
	RJMP _0x2A
_0x2B:
; 0000 0226 }
	RJMP _0x20A0006
;
;void send_ch2(void)
; 0000 0229 {
_send_ch2:
; 0000 022A 	char i;
; 0000 022B         for(i=0;i<3;i++)kirim_karakter(ch2[i]);
	RCALL SUBOPT_0x24
;	i -> R17
_0x2D:
	CPI  R17,3
	BRGE _0x2E
	RCALL SUBOPT_0x28
	SUBI R30,LOW(-_ch2)
	SBCI R31,HIGH(-_ch2)
	RCALL SUBOPT_0x29
	SUBI R17,-1
	RJMP _0x2D
_0x2E:
; 0000 022C }
	RJMP _0x20A0006
;
;void send_ch3(void)
; 0000 022F {
_send_ch3:
; 0000 0230 	char i;
; 0000 0231         for(i=0;i<3;i++)kirim_karakter(ch3[i]);
	RCALL SUBOPT_0x24
;	i -> R17
_0x30:
	CPI  R17,3
	BRGE _0x31
	RCALL SUBOPT_0x28
	SUBI R30,LOW(-_ch3)
	SBCI R31,HIGH(-_ch3)
	RCALL SUBOPT_0x29
	SUBI R17,-1
	RJMP _0x30
_0x31:
; 0000 0232 }
	RJMP _0x20A0006
;
;void kirim_tele_data(void)
; 0000 0235 {
_kirim_tele_data:
; 0000 0236 	char i;
; 0000 0237 
; 0000 0238         kirim_add_tel();
	RCALL SUBOPT_0x2A
;	i -> R17
; 0000 0239         kirim_ax25_head();
; 0000 023A         kirim_karakter('T');
	LDI  R30,LOW(84)
	RCALL SUBOPT_0x27
; 0000 023B         kirim_karakter('#');
	LDI  R30,LOW(35)
	RCALL SUBOPT_0x27
; 0000 023C         for(i=0;i<3;i++)kirim_karakter(seq_num[i]);
	LDI  R17,LOW(0)
_0x33:
	CPI  R17,3
	BRGE _0x34
	RCALL SUBOPT_0x28
	SUBI R30,LOW(-_seq_num)
	SBCI R31,HIGH(-_seq_num)
	RCALL SUBOPT_0x29
	SUBI R17,-1
	RJMP _0x33
_0x34:
; 0000 023E kirim_karakter(',');
	RCALL SUBOPT_0x2B
; 0000 023F         if     (pri1=='B')send_batt();
	RCALL SUBOPT_0x2C
	CPI  R30,LOW(0x42)
	BRNE _0x35
	RCALL _send_batt
; 0000 0240         else if(pri1=='T')send_temp();
	RJMP _0x36
_0x35:
	RCALL SUBOPT_0x2C
	CPI  R30,LOW(0x54)
	BRNE _0x37
	RCALL _send_temp
; 0000 0241         else if(pri1=='A')send_alti();
	RJMP _0x38
_0x37:
	RCALL SUBOPT_0x2C
	CPI  R30,LOW(0x41)
	BRNE _0x39
	RCALL _send_alti
; 0000 0242         else if(pri1=='1')send_ch1();
	RJMP _0x3A
_0x39:
	RCALL SUBOPT_0x2C
	CPI  R30,LOW(0x31)
	BRNE _0x3B
	RCALL _send_ch1
; 0000 0243         else if(pri1=='2')send_ch2();
	RJMP _0x3C
_0x3B:
	RCALL SUBOPT_0x2C
	CPI  R30,LOW(0x32)
	BRNE _0x3D
	RCALL _send_ch2
; 0000 0244         else if(pri1=='3')send_ch3();
	RJMP _0x3E
_0x3D:
	RCALL SUBOPT_0x2C
	CPI  R30,LOW(0x33)
	BRNE _0x3F
	RCALL _send_ch3
; 0000 0245 
; 0000 0246         kirim_karakter(',');
_0x3F:
_0x3E:
_0x3C:
_0x3A:
_0x38:
_0x36:
	RCALL SUBOPT_0x2B
; 0000 0247         if     (pri2=='B')send_batt();
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x42)
	BRNE _0x40
	RCALL _send_batt
; 0000 0248         else if(pri2=='T')send_temp();
	RJMP _0x41
_0x40:
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x54)
	BRNE _0x42
	RCALL _send_temp
; 0000 0249         else if(pri2=='A')send_alti();
	RJMP _0x43
_0x42:
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x41)
	BRNE _0x44
	RCALL _send_alti
; 0000 024A         else if(pri2=='1')send_ch1();
	RJMP _0x45
_0x44:
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x31)
	BRNE _0x46
	RCALL _send_ch1
; 0000 024B         else if(pri2=='2')send_ch2();
	RJMP _0x47
_0x46:
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x32)
	BRNE _0x48
	RCALL _send_ch2
; 0000 024C         else if(pri2=='3')send_ch3();
	RJMP _0x49
_0x48:
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x33)
	BRNE _0x4A
	RCALL _send_ch3
; 0000 024D 
; 0000 024E         kirim_karakter(',');
_0x4A:
_0x49:
_0x47:
_0x45:
_0x43:
_0x41:
	RCALL SUBOPT_0x2B
; 0000 024F         if     (pri3=='B')send_batt();
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x42)
	BRNE _0x4B
	RCALL _send_batt
; 0000 0250         else if(pri3=='T')send_temp();
	RJMP _0x4C
_0x4B:
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x54)
	BRNE _0x4D
	RCALL _send_temp
; 0000 0251         else if(pri3=='A')send_alti();
	RJMP _0x4E
_0x4D:
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x41)
	BRNE _0x4F
	RCALL _send_alti
; 0000 0252         else if(pri3=='1')send_ch1();
	RJMP _0x50
_0x4F:
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x31)
	BRNE _0x51
	RCALL _send_ch1
; 0000 0253         else if(pri3=='2')send_ch2();
	RJMP _0x52
_0x51:
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x32)
	BRNE _0x53
	RCALL _send_ch2
; 0000 0254         else if(pri3=='3')send_ch3();
	RJMP _0x54
_0x53:
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x33)
	BRNE _0x55
	RCALL _send_ch3
; 0000 0255 
; 0000 0256         kirim_karakter(',');
_0x55:
_0x54:
_0x52:
_0x50:
_0x4E:
_0x4C:
	RCALL SUBOPT_0x2B
; 0000 0257         if     (pri4=='B')send_batt();
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x42)
	BRNE _0x56
	RCALL _send_batt
; 0000 0258         else if(pri4=='T')send_temp();
	RJMP _0x57
_0x56:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x54)
	BRNE _0x58
	RCALL _send_temp
; 0000 0259         else if(pri4=='A')send_alti();
	RJMP _0x59
_0x58:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x41)
	BRNE _0x5A
	RCALL _send_alti
; 0000 025A         else if(pri4=='1')send_ch1();
	RJMP _0x5B
_0x5A:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x31)
	BRNE _0x5C
	RCALL _send_ch1
; 0000 025B         else if(pri4=='2')send_ch2();
	RJMP _0x5D
_0x5C:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x32)
	BRNE _0x5E
	RCALL _send_ch2
; 0000 025C         else if(pri4=='3')send_ch3();
	RJMP _0x5F
_0x5E:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x33)
	BRNE _0x60
	RCALL _send_ch3
; 0000 025D 
; 0000 025E         kirim_karakter(',');
_0x60:
_0x5F:
_0x5D:
_0x5B:
_0x59:
_0x57:
	RCALL SUBOPT_0x2B
; 0000 025F         if     (pri5=='B')send_batt();
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x42)
	BRNE _0x61
	RCALL _send_batt
; 0000 0260         else if(pri5=='T')send_temp();
	RJMP _0x62
_0x61:
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x54)
	BRNE _0x63
	RCALL _send_temp
; 0000 0261         else if(pri5=='A')send_alti();
	RJMP _0x64
_0x63:
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x41)
	BRNE _0x65
	RCALL _send_alti
; 0000 0262         else if(pri5=='1')send_ch1();
	RJMP _0x66
_0x65:
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x31)
	BRNE _0x67
	RCALL _send_ch1
; 0000 0263         else if(pri5=='2')send_ch2();
	RJMP _0x68
_0x67:
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x32)
	BRNE _0x69
	RCALL _send_ch2
; 0000 0264         else if(pri5=='3')send_ch3();
	RJMP _0x6A
_0x69:
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x33)
	BRNE _0x6B
	RCALL _send_ch3
; 0000 0265 
; 0000 0266         kirim_karakter(',');
_0x6B:
_0x6A:
_0x68:
_0x66:
_0x64:
_0x62:
	RCALL SUBOPT_0x2B
; 0000 0267         for(i=0;i<8;i++)kirim_karakter('0');
	LDI  R17,LOW(0)
_0x6D:
	CPI  R17,8
	BRGE _0x6E
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x27
	SUBI R17,-1
	RJMP _0x6D
_0x6E:
; 0000 0268 }
	RJMP _0x20A0006
;
;void kirim_tele_param(void)
; 0000 026B {
_kirim_tele_param:
; 0000 026C 	char i;
; 0000 026D 
; 0000 026E         kirim_add_tel();
	RCALL SUBOPT_0x2A
;	i -> R17
; 0000 026F         kirim_ax25_head();
; 0000 0270         for(i=0;i<11;i++)	{kirim_karakter(message_head[i]);}
	LDI  R17,LOW(0)
_0x70:
	CPI  R17,11
	BRGE _0x71
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x31
	SUBI R17,-1
	RJMP _0x70
_0x71:
; 0000 0271         for(i=0;i<sizeof(param);i++)	{kirim_karakter(param[i]);}
	LDI  R17,LOW(0)
_0x73:
	MOV  R26,R17
	LDI  R30,LOW(22)
	RCALL SUBOPT_0x32
	BRGE _0x74
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_param)
	SBCI R27,HIGH(-_param)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x73
_0x74:
; 0000 0272 }
	RJMP _0x20A0006
;
;void kirim_tele_unit(void)
; 0000 0275 {
_kirim_tele_unit:
; 0000 0276 	char i;
; 0000 0277 
; 0000 0278         kirim_add_tel();
	RCALL SUBOPT_0x2A
;	i -> R17
; 0000 0279         kirim_ax25_head();
; 0000 027A         for(i=0;i<11;i++)	{kirim_karakter(message_head[i]);}
	LDI  R17,LOW(0)
_0x76:
	CPI  R17,11
	BRGE _0x77
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x31
	SUBI R17,-1
	RJMP _0x76
_0x77:
; 0000 027B         for(i=0;i<sizeof(unit);i++)	{kirim_karakter(unit[i]);}
	LDI  R17,LOW(0)
_0x79:
	MOV  R26,R17
	LDI  R30,LOW(21)
	RCALL SUBOPT_0x32
	BRGE _0x7A
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_unit)
	SBCI R27,HIGH(-_unit)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x79
_0x7A:
; 0000 027C }
	RJMP _0x20A0006
;
;void kirim_tele_eqns(void)
; 0000 027F {
_kirim_tele_eqns:
; 0000 0280 	char i;
; 0000 0281 
; 0000 0282         kirim_add_tel();
	RCALL SUBOPT_0x2A
;	i -> R17
; 0000 0283         kirim_ax25_head();
; 0000 0284         for(i=0;i<11;i++)	{kirim_karakter(message_head[i]);}
	LDI  R17,LOW(0)
_0x7C:
	CPI  R17,11
	BRGE _0x7D
	RCALL SUBOPT_0x25
	RCALL SUBOPT_0x31
	SUBI R17,-1
	RJMP _0x7C
_0x7D:
; 0000 0285         for(i=0;i<sizeof(eqns);i++)	{kirim_karakter(eqns[i]);}
	LDI  R17,LOW(0)
_0x7F:
	MOV  R26,R17
	LDI  R30,LOW(28)
	RCALL SUBOPT_0x32
	BRGE _0x80
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_eqns)
	SBCI R27,HIGH(-_eqns)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x7F
_0x80:
; 0000 0286 }
	RJMP _0x20A0006
;
;void kirim_status(void)
; 0000 0289 {
_kirim_status:
; 0000 028A 	char i;
; 0000 028B 
; 0000 028C         kirim_add_aprs();
	ST   -Y,R17
;	i -> R17
	RCALL _kirim_add_aprs
; 0000 028D         kirim_ax25_head();
	RCALL _kirim_ax25_head
; 0000 028E         kirim_karakter(TD_STATUS_);
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x27
; 0000 028F 	for(i=0;i<sizeof(status);i++)	kirim_karakter(status[i]);
	LDI  R17,LOW(0)
_0x82:
	MOV  R26,R17
	LDI  R30,LOW(42)
	RCALL SUBOPT_0x32
	BRGE _0x83
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_status)
	SBCI R27,HIGH(-_status)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x82
_0x83:
; 0000 0290 }
	RJMP _0x20A0006
;
;void kirim_beacon(void)
; 0000 0293 {
_kirim_beacon:
; 0000 0294 	char i;
; 0000 0295 
; 0000 0296         for(i=0;i<7;i++)kirim_karakter(add_beacon[i]);
	RCALL SUBOPT_0x24
;	i -> R17
_0x85:
	CPI  R17,7
	BRGE _0x86
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_add_beacon)
	SBCI R27,HIGH(-_add_beacon)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x85
_0x86:
; 0000 0297 kirim_ax25_head();
	RCALL _kirim_ax25_head
; 0000 0298         for(i=0;i<sizeof(status);i++)	kirim_karakter(status[i]);
	LDI  R17,LOW(0)
_0x88:
	MOV  R26,R17
	LDI  R30,LOW(42)
	RCALL SUBOPT_0x32
	BRGE _0x89
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_status)
	SBCI R27,HIGH(-_status)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x88
_0x89:
; 0000 0299 }
	RJMP _0x20A0006
;
;void prepare(void)
; 0000 029C {
_prepare:
; 0000 029D 	char i;
; 0000 029E 
; 0000 029F         PTT = 1;
	ST   -Y,R17
;	i -> R17
	SBI  0x18,5
; 0000 02A0 	delay_ms(100);
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x33
; 0000 02A1 	for(i=0;i<TX_DELAY_;i++)kirim_karakter(0x00);
	LDI  R17,LOW(0)
_0x8D:
	CPI  R17,45
	BRGE _0x8E
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x27
	SUBI R17,-1
	RJMP _0x8D
_0x8E:
; 0000 02A2 kirim_karakter(0x7E);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x27
; 0000 02A3 	bit_stuff = 0;
	RCALL SUBOPT_0x34
; 0000 02A4         crc = 0xFFFF;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R8,R30
; 0000 02A5 }
	RJMP _0x20A0006
;
;void kirim_paket(void)
; 0000 02A8 {
_kirim_paket:
; 0000 02A9 	char i;
; 0000 02AA 
; 0000 02AB         read_temp();
	ST   -Y,R17
;	i -> R17
	RCALL _read_temp
; 0000 02AC         read_volt();
	RCALL _read_volt
; 0000 02AD         base91_lat();
	RCALL _base91_lat
; 0000 02AE         base91_long();
	RCALL _base91_long
; 0000 02AF         base91_alt();
	RCALL _base91_alt
; 0000 02B0         calc_tel_data();
	RCALL _calc_tel_data
; 0000 02B1         normal_alt();
	RCALL _normal_alt
; 0000 02B2 
; 0000 02B3 	MERAH = 1;
	SBI  0x12,6
; 0000 02B4         HIJAU = 0;
	CBI  0x12,7
; 0000 02B5 
; 0000 02B6         beacon_stat++;
	INC  R7
; 0000 02B7         prepare();
	RCALL _prepare
; 0000 02B8         if((beacon_stat==6)||((beacon_stat>7)&&((beacon_stat%m_int)==0)))
	LDI  R30,LOW(6)
	CP   R30,R7
	BREQ _0x94
	RCALL SUBOPT_0x35
	BRGE _0x95
	MOV  R30,R7
	RCALL SUBOPT_0x36
	MOVW R0,R30
	LDI  R26,LOW(_m_int)
	LDI  R27,HIGH(_m_int)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x36
	MOVW R26,R0
	RCALL __MODW21
	SBIW R30,0
	BREQ _0x94
_0x95:
	RJMP _0x93
_0x94:
; 0000 02B9         {
; 0000 02BA         	kirim_status();
	RCALL _kirim_status
; 0000 02BB                 goto oke;
	RJMP _0x98
; 0000 02BC         }
; 0000 02BD         if((beacon_stat==1)||((beacon_stat>7)&&((beacon_stat%2)==1)))
_0x93:
	LDI  R30,LOW(1)
	CP   R30,R7
	BREQ _0x9A
	RCALL SUBOPT_0x35
	BRGE _0x9B
	RCALL SUBOPT_0x37
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BREQ _0x9A
_0x9B:
	RJMP _0x99
_0x9A:
; 0000 02BE         {
; 0000 02BF         	kirim_add_aprs();
	RCALL _kirim_add_aprs
; 0000 02C0         	kirim_ax25_head();
	RCALL _kirim_ax25_head
; 0000 02C1         	kirim_karakter(TD_POSISI_);
	LDI  R30,LOW(61)
	RCALL SUBOPT_0x27
; 0000 02C2         	kirim_karakter(SYM_TAB_OVL_);
	LDI  R26,LOW(_SYM_TAB_OVL_)
	LDI  R27,HIGH(_SYM_TAB_OVL_)
	RCALL SUBOPT_0x26
; 0000 02C3         	for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
	LDI  R17,LOW(0)
_0x9F:
	CPI  R17,4
	BRGE _0xA0
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_comp_lat)
	SBCI R27,HIGH(-_comp_lat)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x9F
_0xA0:
; 0000 02C4 for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
	LDI  R17,LOW(0)
_0xA2:
	CPI  R17,4
	BRGE _0xA3
	RCALL SUBOPT_0x25
	SUBI R26,LOW(-_comp_long)
	SBCI R27,HIGH(-_comp_long)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0xA2
_0xA3:
; 0000 02C5 kirim_karakter(SYM_CODE_);
	LDI  R26,LOW(_SYM_CODE_)
	LDI  R27,HIGH(_SYM_CODE_)
	RCALL SUBOPT_0x26
; 0000 02C6         	for(i=0;i<3;i++)kirim_karakter(comp_cst[i]);
	LDI  R17,LOW(0)
_0xA5:
	CPI  R17,3
	BRGE _0xA6
	RCALL SUBOPT_0x28
	SUBI R30,LOW(-_comp_cst)
	SBCI R31,HIGH(-_comp_cst)
	RCALL SUBOPT_0x29
	SUBI R17,-1
	RJMP _0xA5
_0xA6:
; 0000 02C7 for(i=0;i<6;i++){if(temp[i]!='!')kirim_karakter(temp[i]);}kirim_karakter(' ');
	LDI  R17,LOW(0)
_0xA8:
	CPI  R17,6
	BRGE _0xA9
	RCALL SUBOPT_0x28
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	LD   R26,Z
	CPI  R26,LOW(0x21)
	BREQ _0xAA
	RCALL SUBOPT_0x28
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	RCALL SUBOPT_0x29
_0xAA:
	SUBI R17,-1
	RJMP _0xA8
_0xA9:
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x27
; 0000 02C8                 for(i=0;i<6;i++){if(volt[i]!='!')kirim_karakter(volt[i]);}kirim_karakter(' ');
	LDI  R17,LOW(0)
_0xAC:
	CPI  R17,6
	BRGE _0xAD
	RCALL SUBOPT_0x28
	SUBI R30,LOW(-_volt)
	SBCI R31,HIGH(-_volt)
	LD   R26,Z
	CPI  R26,LOW(0x21)
	BREQ _0xAE
	RCALL SUBOPT_0x28
	SUBI R30,LOW(-_volt)
	SBCI R31,HIGH(-_volt)
	RCALL SUBOPT_0x29
_0xAE:
	SUBI R17,-1
	RJMP _0xAC
_0xAD:
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x27
; 0000 02C9                 goto oke;
	RJMP _0x98
; 0000 02CA         }
; 0000 02CB         if((beacon_stat==2)||((beacon_stat>7)&&((beacon_stat%2)==0)))
_0x99:
	LDI  R30,LOW(2)
	CP   R30,R7
	BREQ _0xB0
	RCALL SUBOPT_0x35
	BRGE _0xB1
	RCALL SUBOPT_0x37
	SBIW R30,0
	BREQ _0xB0
_0xB1:
	RJMP _0xAF
_0xB0:
; 0000 02CC         {
; 0000 02CD         	kirim_tele_data();
	RCALL _kirim_tele_data
; 0000 02CE                 goto oke;
	RJMP _0x98
; 0000 02CF         }
; 0000 02D0         if(beacon_stat==3)
_0xAF:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0xB4
; 0000 02D1         {
; 0000 02D2         	kirim_tele_param();
	RCALL _kirim_tele_param
; 0000 02D3                 goto oke;
	RJMP _0x98
; 0000 02D4         }
; 0000 02D5         if(beacon_stat==4)
_0xB4:
	LDI  R30,LOW(4)
	CP   R30,R7
	BRNE _0xB5
; 0000 02D6         {
; 0000 02D7         	kirim_tele_unit();
	RCALL _kirim_tele_unit
; 0000 02D8                 goto oke;
	RJMP _0x98
; 0000 02D9         }
; 0000 02DA         if(beacon_stat==5)
_0xB5:
	LDI  R30,LOW(5)
	CP   R30,R7
	BRNE _0xB6
; 0000 02DB         {
; 0000 02DC         	kirim_tele_eqns();
	RCALL _kirim_tele_eqns
; 0000 02DD                 goto oke;
	RJMP _0x98
; 0000 02DE         }
; 0000 02DF         if(beacon_stat==7)kirim_beacon();
_0xB6:
	RCALL SUBOPT_0x35
	BRNE _0xB7
	RCALL _kirim_beacon
; 0000 02E0 
; 0000 02E1         oke:
_0xB7:
_0x98:
; 0000 02E2 	kirim_crc();
	RCALL _kirim_crc
; 0000 02E3         kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x27
; 0000 02E4         kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x27
; 0000 02E5         PTT = 0;
	CBI  0x18,5
; 0000 02E6 
; 0000 02E7         if(beacon_stat==100)beacon_stat=0;
	LDI  R30,LOW(100)
	CP   R30,R7
	BRNE _0xBA
	CLR  R7
; 0000 02E8         MERAH = 0;
_0xBA:
	CBI  0x12,6
; 0000 02E9         HIJAU = 0;
	CBI  0x12,7
; 0000 02EA }
_0x20A0006:
	LD   R17,Y+
	RET
;
;void kirim_crc(void)
; 0000 02ED {
_kirim_crc:
; 0000 02EE 	static unsigned char crc_lo;
; 0000 02EF 	static unsigned char crc_hi;
; 0000 02F0 
; 0000 02F1         crc_lo = crc ^ 0xFF;
	LDI  R30,LOW(255)
	EOR  R30,R8
	STS  _crc_lo_S0000018000,R30
; 0000 02F2 	crc_hi = (crc >> 8) ^ 0xFF;
	MOV  R30,R9
	ANDI R31,HIGH(0x0)
	LDI  R26,LOW(255)
	EOR  R30,R26
	STS  _crc_hi_S0000018000,R30
; 0000 02F3 	kirim_karakter(crc_lo);
	LDS  R30,_crc_lo_S0000018000
	RCALL SUBOPT_0x27
; 0000 02F4 	kirim_karakter(crc_hi);
	LDS  R30,_crc_hi_S0000018000
_0x20A0005:
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 02F5 }
	RET
;
;void kirim_karakter(unsigned char input)
; 0000 02F8 {
_kirim_karakter:
	PUSH R15
; 0000 02F9 	char i;
; 0000 02FA 	bit in_bit;
; 0000 02FB 
; 0000 02FC         for(i=0;i<8;i++)
	RCALL SUBOPT_0x24
;	input -> Y+1
;	i -> R17
;	in_bit -> R15.0
_0xC0:
	CPI  R17,8
	BRGE _0xC1
; 0000 02FD         {
; 0000 02FE         	in_bit = (input >> i) & 0x01;
	LDD  R26,Y+1
	LDI  R27,0
	MOV  R30,R17
	RCALL __ASRW12
	BST  R30,0
	BLD  R15,0
; 0000 02FF 		if(input==0x7E)	{bit_stuff = 0;}
	LDD  R26,Y+1
	CPI  R26,LOW(0x7E)
	BRNE _0xC2
	RCALL SUBOPT_0x34
; 0000 0300 		else		{hitung_crc(in_bit);}
	RJMP _0xC3
_0xC2:
	LDI  R30,0
	SBRC R15,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _hitung_crc
_0xC3:
; 0000 0301 
; 0000 0302 		if(!in_bit)
	SBRS R15,0
; 0000 0303                 {
; 0000 0304                 	ubah_nada();
	RJMP _0x12A
; 0000 0305 			bit_stuff = 0;
; 0000 0306                 }
; 0000 0307                 else
; 0000 0308                 {
; 0000 0309                 	set_nada(nada);
	RCALL SUBOPT_0x38
; 0000 030A 			bit_stuff++;
	LDS  R30,_bit_stuff_G000
	SUBI R30,-LOW(1)
	STS  _bit_stuff_G000,R30
; 0000 030B 			if(bit_stuff==5)
	LDS  R26,_bit_stuff_G000
	CPI  R26,LOW(0x5)
	BRNE _0xC6
; 0000 030C                         {
; 0000 030D                         	ubah_nada();
_0x12A:
	RCALL _ubah_nada
; 0000 030E                                 bit_stuff = 0;
	RCALL SUBOPT_0x34
; 0000 030F                         }
; 0000 0310                 }
_0xC6:
; 0000 0311         }
	SUBI R17,-1
	RJMP _0xC0
_0xC1:
; 0000 0312 }
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;void hitung_crc(char in_crc)
; 0000 0315 {
_hitung_crc:
; 0000 0316 	static unsigned short xor_in;
; 0000 0317 	xor_in = crc ^ in_crc;
;	in_crc -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x36
	EOR  R30,R8
	EOR  R31,R9
	STS  _xor_in_S000001A000,R30
	STS  _xor_in_S000001A000+1,R31
; 0000 0318 	crc >>= 1;
	LSR  R9
	ROR  R8
; 0000 0319 	if(xor_in & 0x01)	crc ^= 0x8408;
	LDS  R30,_xor_in_S000001A000
	ANDI R30,LOW(0x1)
	BREQ _0xC7
	LDI  R30,LOW(33800)
	LDI  R31,HIGH(33800)
	__EORWRR 8,9,30,31
; 0000 031A }
_0xC7:
	RJMP _0x20A0004
;
;void ubah_nada(void)
; 0000 031D {
_ubah_nada:
; 0000 031E 	nada = ~nada;
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 031F         set_nada(nada);
	RCALL SUBOPT_0x38
; 0000 0320 }
	RET
;
;void set_nada(char i_nada)
; 0000 0323 {
_set_nada:
; 0000 0324 	if(i_nada == _1200)
;	i_nada -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0xC8
; 0000 0325     	{
; 0000 0326         	delay_us(417);
	RCALL SUBOPT_0x39
; 0000 0327         	AFOUT = 1;
	SBI  0x18,4
; 0000 0328         	delay_us(417);
	RCALL SUBOPT_0x39
; 0000 0329         	AFOUT = 0;
	RJMP _0x12B
; 0000 032A     	}
; 0000 032B         else
_0xC8:
; 0000 032C     	{
; 0000 032D         	delay_us(208);
	RCALL SUBOPT_0x3A
; 0000 032E         	AFOUT = 1;
; 0000 032F         	delay_us(209);
; 0000 0330         	AFOUT = 0;
	CBI  0x18,4
; 0000 0331                 delay_us(208);
	RCALL SUBOPT_0x3A
; 0000 0332         	AFOUT = 1;
; 0000 0333         	delay_us(209);
; 0000 0334         	AFOUT = 0;
_0x12B:
	CBI  0x18,4
; 0000 0335     	}
; 0000 0336 }
	RJMP _0x20A0004
;
;unsigned int read_adc(unsigned char adc_input)
; 0000 0339 {
_read_adc:
; 0000 033A 	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 033B 	delay_us(10);
	__DELAY_USB 37
; 0000 033C 	ADCSRA|=0x40;
	SBI  0x6,6
; 0000 033D 	while ((ADCSRA & 0x10)==0);
_0xD6:
	SBIS 0x6,4
	RJMP _0xD6
; 0000 033E 	ADCSRA|=0x10;
	SBI  0x6,4
; 0000 033F 	return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
_0x20A0004:
	ADIW R28,1
	RET
; 0000 0340 }
;
;void waitComma(void)
; 0000 0343 {
_waitComma:
; 0000 0344 	while(getchar()!=',');
_0xD9:
	RCALL _getchar
	CPI  R30,LOW(0x2C)
	BRNE _0xD9
; 0000 0345 }
	RET
;
;void extractGPS(void)
; 0000 0348 {
_extractGPS:
; 0000 0349 	int i,j;
; 0000 034A         char buff_altitude[9];
; 0000 034B         char cb;
; 0000 034C         char n_altitude[6];
; 0000 034D 
; 0000 034E         #asm("cli")
	SBIW R28,15
	RCALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	buff_altitude -> Y+12
;	cb -> R21
;	n_altitude -> Y+6
	cli
; 0000 034F         lagi:
_0xDC:
; 0000 0350         while(getchar() != '$');
_0xDD:
	RCALL _getchar
	CPI  R30,LOW(0x24)
	BRNE _0xDD
; 0000 0351         cb=getchar();
	RCALL _getchar
	MOV  R21,R30
; 0000 0352 	if(cb=='G')
	CPI  R21,71
	BREQ PC+2
	RJMP _0xE0
; 0000 0353         {
; 0000 0354         	getchar();
	RCALL _getchar
; 0000 0355         	if(getchar() == 'G')
	RCALL _getchar
	CPI  R30,LOW(0x47)
	BREQ PC+2
	RJMP _0xE1
; 0000 0356         	{
; 0000 0357         	if(getchar() == 'G')
	RCALL _getchar
	CPI  R30,LOW(0x47)
	BREQ PC+2
	RJMP _0xE2
; 0000 0358         	{
; 0000 0359                 	if(getchar() == 'A')
	RCALL _getchar
	CPI  R30,LOW(0x41)
	BREQ PC+2
	RJMP _0xE3
; 0000 035A                 	{
; 0000 035B                         	MERAH = 0;
	CBI  0x12,6
; 0000 035C         			HIJAU = 1;
	SBI  0x12,7
; 0000 035D 
; 0000 035E                                 waitComma();
	RCALL _waitComma
; 0000 035F                                 waitComma();
	RCALL _waitComma
; 0000 0360 				for(i=0; i<7; i++)	posisi_lat[i] = getchar();
	RCALL SUBOPT_0x3B
_0xE9:
	__CPWRN 16,17,7
	BRGE _0xEA
	MOVW R30,R16
	SUBI R30,LOW(-_posisi_lat)
	SBCI R31,HIGH(-_posisi_lat)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
	RCALL SUBOPT_0x3C
	RJMP _0xE9
_0xEA:
; 0000 0361 waitComma();
	RCALL _waitComma
; 0000 0362 				posisi_lat[7] = getchar();
	__POINTW1MN _posisi_lat,7
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
; 0000 0363 				waitComma();
	RCALL _waitComma
; 0000 0364 				for(i=0; i<8; i++)	posisi_long[i] = getchar();
	RCALL SUBOPT_0x3B
_0xEC:
	RCALL SUBOPT_0x3D
	BRGE _0xED
	MOVW R30,R16
	SUBI R30,LOW(-_posisi_long)
	SBCI R31,HIGH(-_posisi_long)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
	RCALL SUBOPT_0x3C
	RJMP _0xEC
_0xED:
; 0000 0365 waitComma();		posisi_long[8] = getchar();
	RCALL _waitComma
	__POINTW1MN _posisi_long,8
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
; 0000 0366 				waitComma();
	RCALL _waitComma
; 0000 0367                                 waitComma();
	RCALL _waitComma
; 0000 0368                                 waitComma();
	RCALL _waitComma
; 0000 0369                                 waitComma();
	RCALL _waitComma
; 0000 036A 				for(i=0;i<8;i++)        buff_altitude[i] = getchar();
	RCALL SUBOPT_0x3B
_0xEF:
	RCALL SUBOPT_0x3D
	BRGE _0xF0
	MOVW R30,R16
	RCALL SUBOPT_0x3E
	ADD  R30,R26
	ADC  R31,R27
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
	RCALL SUBOPT_0x3C
	RJMP _0xEF
_0xF0:
; 0000 036B for(i=0;i<6;i++)        n_altitude[i] = '0';
	RCALL SUBOPT_0x3B
_0xF2:
	__CPWRN 16,17,6
	BRGE _0xF3
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	LDI  R30,LOW(48)
	ST   X,R30
	RCALL SUBOPT_0x3C
	RJMP _0xF2
_0xF3:
; 0000 036C for(i=0;i<8;i++)
	RCALL SUBOPT_0x3B
_0xF5:
	RCALL SUBOPT_0x3D
	BRGE _0xF6
; 0000 036D                                 {
; 0000 036E                                         if(buff_altitude[i] == '.')     goto selesai;
	RCALL SUBOPT_0x41
	BREQ _0xF8
; 0000 036F                                         if((buff_altitude[i] != '.')&&(buff_altitude[i] != ',')&&(buff_altitude[i] != 'M'))
	RCALL SUBOPT_0x41
	BREQ _0xFA
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x40
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BREQ _0xFA
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x40
	LD   R26,X
	CPI  R26,LOW(0x4D)
	BRNE _0xFB
_0xFA:
	RJMP _0xF9
_0xFB:
; 0000 0370                                         {
; 0000 0371                                         	for(j=0;j<6;j++)        n_altitude[j] = n_altitude[j+1];
	__GETWRN 18,19,0
_0xFD:
	__CPWRN 18,19,6
	BRGE _0xFE
	MOVW R30,R18
	RCALL SUBOPT_0x3F
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOVW R30,R18
	ADIW R30,1
	RCALL SUBOPT_0x3F
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	__ADDWRN 18,19,1
	RJMP _0xFD
_0xFE:
; 0000 0372 n_altitude[5] = buff_altitude[i];
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x40
	LD   R30,X
	STD  Y+11,R30
; 0000 0373                                         }
; 0000 0374                                 }
_0xF9:
	RCALL SUBOPT_0x3C
	RJMP _0xF5
_0xF6:
; 0000 0375 
; 0000 0376                                 selesai:
_0xF8:
; 0000 0377 
; 0000 0378                                 for(i=0;i<6;i++)n_altitude[i]-='0';
	RCALL SUBOPT_0x3B
_0x100:
	__CPWRN 16,17,6
	BRGE _0x101
	RCALL SUBOPT_0x3F
	RCALL SUBOPT_0x40
	LD   R30,X
	RCALL SUBOPT_0x36
	SBIW R30,48
	ST   X,R30
	RCALL SUBOPT_0x3C
	RJMP _0x100
_0x101:
; 0000 0379 altitude=    (3*(long)((n_altitude[0]*100000)+(n_altitude[1]*10000)+(n_altitude[2]*1000)
; 0000 037A                                 		+(n_altitude[3]*100)+(n_altitude[4]*10)+(n_altitude[5])));
	LDD  R26,Y+6
	RCALL SUBOPT_0x42
	LDI  R30,LOW(34464)
	LDI  R31,HIGH(34464)
	RCALL __MULW12
	MOVW R22,R30
	LDD  R26,Y+7
	RCALL SUBOPT_0x42
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	RCALL __MULW12
	__ADDWRR 22,23,30,31
	LDD  R26,Y+8
	RCALL SUBOPT_0x42
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MULW12
	__ADDWRR 22,23,30,31
	LDD  R26,Y+9
	LDI  R30,LOW(100)
	MULS R30,R26
	MOVW R30,R0
	__ADDWRR 22,23,30,31
	LDD  R26,Y+10
	LDI  R30,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	MOVW R26,R22
	ADD  R26,R30
	ADC  R27,R31
	LDD  R30,Y+11
	RCALL SUBOPT_0x36
	ADD  R30,R26
	ADC  R31,R27
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __MULW12
	LDI  R26,LOW(_altitude)
	LDI  R27,HIGH(_altitude)
	RCALL __EEPROMWRW
; 0000 037B 
; 0000 037C                                 MERAH = 0;
	CBI  0x12,6
; 0000 037D         			HIJAU = 0;
	CBI  0x12,7
; 0000 037E                                 delay_ms(150);
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RCALL SUBOPT_0x33
; 0000 037F                                 goto keluar;
	RJMP _0x106
; 0000 0380                         }
; 0000 0381                 }
_0xE3:
; 0000 0382         	}
_0xE2:
; 0000 0383         }
_0xE1:
; 0000 0384         goto lagi;
_0xE0:
	RJMP _0xDC
; 0000 0385 
; 0000 0386         keluar:
_0x106:
; 0000 0387         #asm("sei")
	sei
; 0000 0388 }
	RCALL __LOADLOCR6
	ADIW R28,21
	RET
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 038B {
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
; 0000 038C 	char z;
; 0000 038D         if(gps=='Y')
	ST   -Y,R17
;	z -> R17
	LDI  R26,LOW(_gps)
	LDI  R27,HIGH(_gps)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x59)
	BRNE _0x107
; 0000 038E         {
; 0000 038F         	HIJAU=0;
	CBI  0x12,7
; 0000 0390                 MERAH=0;
	RJMP _0x12C
; 0000 0391         }
; 0000 0392         else
_0x107:
; 0000 0393         {
; 0000 0394         	HIJAU=1;
	SBI  0x12,7
; 0000 0395                 MERAH=0;
_0x12C:
	CBI  0x12,6
; 0000 0396         }
; 0000 0397         for(z=0;z<100;z++)
	LDI  R17,LOW(0)
_0x112:
	CPI  R17,100
	BRGE _0x113
; 0000 0398         {
; 0000 0399        		if(PIND.0==0)
	SBIS 0x10,0
; 0000 039A                 {
; 0000 039B                 	extractGPS();
	RCALL _extractGPS
; 0000 039C                 }
; 0000 039D         }
	SUBI R17,-1
	RJMP _0x112
_0x113:
; 0000 039E         if((tcnt1c/2)==timeIntv)
	MOV  R26,R6
	RCALL SUBOPT_0x42
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __DIVW21
	MOVW R0,R30
	LDI  R26,LOW(_timeIntv)
	LDI  R27,HIGH(_timeIntv)
	RCALL __EEPROMRDW
	CP   R30,R0
	CPC  R31,R1
	BRNE _0x115
; 0000 039F         {
; 0000 03A0         	kirim_paket();
	RCALL _kirim_paket
; 0000 03A1                 tcnt1c=0;
	CLR  R6
; 0000 03A2         }
; 0000 03A3         TCNT1H = (60135 >> 8);
_0x115:
	RCALL SUBOPT_0x43
; 0000 03A4         TCNT1L = (60135 & 0xFF);
; 0000 03A5 
; 0000 03A6         tcnt1c++;
	INC  R6
; 0000 03A7 }
	LD   R17,Y+
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
;void main(void)
; 0000 03AA {
_main:
; 0000 03AB         PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 03AC 	DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 03AD 	PORTD=0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 03AE 	DDRD=0xFE;
	LDI  R30,LOW(254)
	OUT  0x11,R30
; 0000 03AF 
; 0000 03B0         TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 03B1 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 03B2 	TCNT1H = (60135 >> 8);
	RCALL SUBOPT_0x43
; 0000 03B3         TCNT1L = (60135 & 0xFF);
; 0000 03B4         TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 03B5 
; 0000 03B6 	// USART initialization
; 0000 03B7 	// Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 03B8 	// USART Receiver: On
; 0000 03B9 	// USART Transmitter: Off
; 0000 03BA 	// USART Mode: Asynchronous
; 0000 03BB 	// USART Baud Rate: 4800
; 0000 03BC 
; 0000 03BD 	// Rx ON-noInt Tx ON-noInt
; 0000 03BE 	//*
; 0000 03BF 	UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 03C0 	UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 03C1 	UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 03C2 	UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 03C3 	UBRRL=0x8F;
	LDI  R30,LOW(143)
	OUT  0x9,R30
; 0000 03C4 	//*/
; 0000 03C5 
; 0000 03C6 	// Rx ON-Int Tx ON-noInt
; 0000 03C7 	/*
; 0000 03C8 	UCSRA=0x00;
; 0000 03C9 	UCSRB=0x98;
; 0000 03CA 	UCSRC=0x86;
; 0000 03CB 	UBRRH=0x00;
; 0000 03CC 	UBRRL=0x8F;
; 0000 03CD 	*/
; 0000 03CE 
; 0000 03CF 	// Rx ON-Int Tx ON-Int
; 0000 03D0 	/*
; 0000 03D1 	UCSRA=0x00;
; 0000 03D2 	UCSRB=0xD8;
; 0000 03D3 	UCSRC=0x86;
; 0000 03D4 	UBRRH=0x00;
; 0000 03D5 	UBRRL=0x8F;
; 0000 03D6 	*/
; 0000 03D7 
; 0000 03D8 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 03D9 
; 0000 03DA 	ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 03DB 	ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 03DC 
; 0000 03DD         MERAH = 1;
	SBI  0x12,6
; 0000 03DE         HIJAU = 0;
	CBI  0x12,7
; 0000 03DF         delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x33
; 0000 03E0         MERAH = 0;
	CBI  0x12,6
; 0000 03E1         HIJAU = 1;
	SBI  0x12,7
; 0000 03E2         delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x33
; 0000 03E3 
; 0000 03E4         #asm("sei")
	sei
; 0000 03E5 
; 0000 03E6 	while (1)
_0x11E:
; 0000 03E7       	{
; 0000 03E8         	//putchar(p=getchar());
; 0000 03E9       	}
	RJMP _0x11E
; 0000 03EA }
_0x121:
	RJMP _0x121
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

	.CSEG
_getchar:
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x45
    brne __floor1
__floor0:
	RCALL SUBOPT_0x44
	RJMP _0x20A0003
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x16
	RCALL __SUBF12
	RJMP _0x20A0003
_ceil:
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x45
    brne __ceil1
__ceil0:
	RCALL SUBOPT_0x44
	RJMP _0x20A0003
__ceil1:
    brts __ceil0
	RCALL SUBOPT_0x44
	RCALL SUBOPT_0x16
	RCALL __ADDF12
_0x20A0003:
	ADIW R28,4
	RET
_fmod:
	SBIW R28,4
	RCALL SUBOPT_0x46
	RCALL __CPD10
	BRNE _0x2020005
	RCALL SUBOPT_0x47
	RJMP _0x20A0002
_0x2020005:
	RCALL SUBOPT_0x46
	RCALL SUBOPT_0x48
	RCALL __DIVF21
	RCALL __PUTD1S0
	RCALL SUBOPT_0x44
	RCALL __CPD10
	BRNE _0x2020006
	RCALL SUBOPT_0x47
	RJMP _0x20A0002
_0x2020006:
	RCALL __GETD2S0
	RCALL __CPD02
	BRGE _0x2020007
	RCALL SUBOPT_0x44
	RCALL __PUTPARD1
	RCALL _floor
	RJMP _0x2020033
_0x2020007:
	RCALL SUBOPT_0x44
	RCALL __PUTPARD1
	RCALL _ceil
_0x2020033:
	RCALL __PUTD1S0
	RCALL SUBOPT_0x44
	__GETD2S 4
	RCALL __MULF12
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0xE
_0x20A0002:
	ADIW R28,12
	RET
_log:
	SBIW R28,4
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x49
	RCALL __CPD02
	BRLT _0x202000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20A0001
_0x202000C:
	RCALL SUBOPT_0x4A
	RCALL __PUTPARD1
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	ST   -Y,R31
	ST   -Y,R30
	PUSH R17
	PUSH R16
	RCALL _frexp
	POP  R16
	POP  R17
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x49
	__GETD1N 0x3F3504F3
	RCALL __CMPF12
	BRSH _0x202000D
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x49
	RCALL __ADDF12
	RCALL SUBOPT_0x4B
	__SUBWRN 16,17,1
_0x202000D:
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x16
	RCALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x16
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	RCALL SUBOPT_0x4B
	RCALL SUBOPT_0x4A
	RCALL SUBOPT_0x49
	RCALL __MULF12
	__PUTD1S 2
	RCALL SUBOPT_0x4C
	__GETD2N 0x3F654226
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x49
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x4C
	__GETD2N 0x3FD4114D
	RCALL __SUBF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	MOVW R30,R16
	RCALL SUBOPT_0x4
	__GETD2N 0x3F317218
	RCALL __MULF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
_0x20A0001:
	RCALL __LOADLOCR2
	ADIW R28,10
	RET

	.CSEG

	.CSEG

	.CSEG

	.DSEG

	.CSEG

	.ESEG
_SYM_TAB_OVL_:
	.DB  0x2F
_SYM_CODE_:
	.DB  0x4F
_add_aprs:
	.DB  LOW(0xA6A4A082),HIGH(0xA6A4A082),BYTE3(0xA6A4A082),BYTE4(0xA6A4A082)
	.DW  0x4040
	.DB  0x60
_add_beacon:
	.DB  LOW(0x86828A84),HIGH(0x86828A84),BYTE3(0x86828A84),BYTE4(0x86828A84)
	.DW  0x9C9E
	.DB  0x60
_add_tel:
	.DB  LOW(0x40988AA8),HIGH(0x40988AA8),BYTE3(0x40988AA8),BYTE4(0x40988AA8)
	.DW  0x4040
	.DB  0x60
_data_1:
	.DB  LOW(0xB26484B2),HIGH(0xB26484B2),BYTE3(0xB26484B2),BYTE4(0xB26484B2)
	.DB  LOW(0xAE76AA9E),HIGH(0xAE76AA9E),BYTE3(0xAE76AA9E),BYTE4(0xAE76AA9E)
	.DB  LOW(0x648A8892),HIGH(0x648A8892),BYTE3(0x648A8892),BYTE4(0x648A8892)
	.DW  0x6540
_status:
	.DB  LOW(0x68676948),HIGH(0x68676948),BYTE3(0x68676948),BYTE4(0x68676948)
	.DB  LOW(0x746C4120),HIGH(0x746C4120),BYTE3(0x746C4120),BYTE4(0x746C4120)
	.DB  LOW(0x64757469),HIGH(0x64757469),BYTE3(0x64757469),BYTE4(0x64757469)
	.DB  LOW(0x61422065),HIGH(0x61422065),BYTE3(0x61422065),BYTE4(0x61422065)
	.DB  LOW(0x6F6F6C6C),HIGH(0x6F6F6C6C),BYTE3(0x6F6F6C6C),BYTE4(0x6F6F6C6C)
	.DB  LOW(0x202D206E),HIGH(0x202D206E),BYTE3(0x202D206E),BYTE4(0x202D206E)
	.DB  LOW(0x6E6B6554),HIGH(0x6E6B6554),BYTE3(0x6E6B6554),BYTE4(0x6E6B6554)
	.DB  LOW(0x46206B69),HIGH(0x46206B69),BYTE3(0x46206B69),BYTE4(0x46206B69)
	.DB  LOW(0x6B697369),HIGH(0x6B697369),BYTE3(0x6B697369),BYTE4(0x6B697369)
	.DB  LOW(0x47552061),HIGH(0x47552061),BYTE3(0x47552061),BYTE4(0x47552061)
	.DW  0x4D
_message_head:
	.DB  LOW(0x3242593A),HIGH(0x3242593A),BYTE3(0x3242593A),BYTE4(0x3242593A)
	.DB  LOW(0x2D554F59),HIGH(0x2D554F59),BYTE3(0x2D554F59),BYTE4(0x2D554F59)
	.DB  LOW(0x3A3131),HIGH(0x3A3131),BYTE3(0x3A3131),BYTE4(0x3A3131)
_param:
	.DB  LOW(0x4D524150),HIGH(0x4D524150),BYTE3(0x4D524150),BYTE4(0x4D524150)
	.DB  LOW(0x6D65542E),HIGH(0x6D65542E),BYTE3(0x6D65542E),BYTE4(0x6D65542E)
	.DB  LOW(0x2E422C70),HIGH(0x2E422C70),BYTE3(0x2E422C70),BYTE4(0x2E422C70)
	.DB  LOW(0x746C6F56),HIGH(0x746C6F56),BYTE3(0x746C6F56),BYTE4(0x746C6F56)
	.DB  LOW(0x746C412C),HIGH(0x746C412C),BYTE3(0x746C412C),BYTE4(0x746C412C)
	.DW  0x69
_unit:
	.DB  LOW(0x54494E55),HIGH(0x54494E55),BYTE3(0x54494E55),BYTE4(0x54494E55)
	.DB  LOW(0x6765442E),HIGH(0x6765442E),BYTE3(0x6765442E),BYTE4(0x6765442E)
	.DB  LOW(0x562C432E),HIGH(0x562C432E),BYTE3(0x562C432E),BYTE4(0x562C432E)
	.DB  LOW(0x2C746C6F),HIGH(0x2C746C6F),BYTE3(0x2C746C6F),BYTE4(0x2C746C6F)
	.DB  LOW(0x74656546),HIGH(0x74656546),BYTE3(0x74656546),BYTE4(0x74656546)
	.DB  0x0
_eqns:
	.DB  LOW(0x534E5145),HIGH(0x534E5145),BYTE3(0x534E5145),BYTE4(0x534E5145)
	.DB  LOW(0x302C302E),HIGH(0x302C302E),BYTE3(0x302C302E),BYTE4(0x302C302E)
	.DB  LOW(0x302C312E),HIGH(0x302C312E),BYTE3(0x302C312E),BYTE4(0x302C312E)
	.DB  LOW(0x302C302C),HIGH(0x302C302C),BYTE3(0x302C302C),BYTE4(0x302C302C)
	.DB  LOW(0x302C312E),HIGH(0x302C312E),BYTE3(0x302C312E),BYTE4(0x302C312E)
	.DB  LOW(0x362C302C),HIGH(0x362C302C),BYTE3(0x362C302C),BYTE4(0x362C302C)
	.DB  LOW(0x302C36),HIGH(0x302C36),BYTE3(0x302C36),BYTE4(0x302C36)
_posisi_lat:
	.DB  LOW(0x35343730),HIGH(0x35343730),BYTE3(0x35343730),BYTE4(0x35343730)
	.DB  LOW(0x5338392E),HIGH(0x5338392E),BYTE3(0x5338392E),BYTE4(0x5338392E)
	.DB  0x0
_posisi_long:
	.DB  LOW(0x32303131),HIGH(0x32303131),BYTE3(0x32303131),BYTE4(0x32303131)
	.DB  LOW(0x36332E32),HIGH(0x36332E32),BYTE3(0x36332E32),BYTE4(0x36332E32)
	.DW  0x45
_altitude:
	.DW  0x0
_m_int:
	.DB  0x15
_comp_lat:
	.BYTE 0x4
_comp_long:
	.BYTE 0x4
_seq:
	.DW  0x0
_timeIntv:
	.DW  0x4
_gps:
	.DB  0x59
_pri1:
	.DB  0x54
_pri2:
	.DB  0x42
_pri3:
	.DB  0x41
_pri4:
	.DB  0x32
_pri5:
	.DB  0x33

	.DSEG
_temp:
	.BYTE 0x7
_volt:
	.BYTE 0x7
_comp_cst:
	.BYTE 0x3
_norm_alt:
	.BYTE 0xA
_bit_stuff_G000:
	.BYTE 0x1
_seq_num:
	.BYTE 0x3
_ch1:
	.BYTE 0x3
_ch2:
	.BYTE 0x3
_ch3:
	.BYTE 0x3
_alti:
	.BYTE 0x3
_crc_lo_S0000018000:
	.BYTE 0x1
_crc_hi_S0000018000:
	.BYTE 0x1
_xor_in_S000001A000:
	.BYTE 0x2
__seed_G104:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	RJMP _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	RCALL __MULW12U
	CLR  R22
	CLR  R23
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x2:
	RCALL __DIVF21
	RCALL __CFD1U
	MOVW R16,R30
	MOVW R26,R16
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	MOV  R19,R30
	MOVW R26,R16
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	MOV  R18,R30
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21U
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	MOV  R21,R30
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	MOV  R20,R30
	CPI  R19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x3:
	RCALL __EEPROMRDB
	LDI  R31,0
	SBRC R30,7
	SER  R31
	SBIW R30,48
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x4:
	RCALL __CWD1
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	__GETD2N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x4
	RCALL __ADDF12
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	__GETD1N 0x1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD1N 0xFFFFFFFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	MOV  R30,R17
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	MOV  R30,R16
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RCALL SUBOPT_0x4
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42700000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	RCALL __CWD2
	RCALL __CDF2
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xC:
	__GETD1S 12
	__GETD2N 0x3F19999A
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x45610000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xD:
	RCALL __ADDF12
	__PUTD1S 4
	MOV  R30,R19
	LDI  R31,0
	SBRC R30,7
	SER  R31
	__GETD2S 4
	RCALL SUBOPT_0x4
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	RCALL __SWAPD12
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xF:
	RCALL __MULF12
	__PUTD1S 8
	__GETD2S 8
	__GETD1N 0x4937FA30
	RCALL __DIVF21
	__GETD2N 0x42040000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x10:
	RCALL __CFD1
	RCALL __EEPROMWRB
	__GETD1S 8
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x11:
	__GETD1N 0x4937FA30
	RCALL __PUTPARD1
	RCALL _fmod
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x46016400
	RCALL __DIVF21
	__GETD2N 0x42040000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x12:
	__GETD1N 0x46016400
	RCALL __PUTPARD1
	RCALL _fmod
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42B60000
	RCALL __DIVF21
	__GETD2N 0x42040000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x13:
	__GETD1N 0x42B60000
	RCALL __PUTPARD1
	RCALL _fmod
	__GETD2N 0x42040000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(_altitude)
	LDI  R27,HIGH(_altitude)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x15:
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x16:
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	RCALL __MULF12
	RCALL __CFD1
	MOVW R16,R30
	MOVW R26,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x186A0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x19:
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1A:
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_seq)
	LDI  R27,HIGH(_seq)
	RCALL __EEPROMRDW
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1C:
	RCALL __DIVW21
	SUBI R30,-LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	RCALL __MODW21
	RJMP SUBOPT_0x1A

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(_seq)
	LDI  R27,HIGH(_seq)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	RCALL __MODW21
	SUBI R30,-LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0x15
	__GETD2N 0x3E800000
	RJMP SUBOPT_0x17

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x22:
	MOVW R26,R16
	RCALL SUBOPT_0x21
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x23:
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	ST   -Y,R17
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x25:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x26:
	RCALL __EEPROMRDB
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x27:
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x28:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x29:
	LD   R30,Z
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2A:
	ST   -Y,R17
	RCALL _kirim_add_tel
	RJMP _kirim_ax25_head

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(44)
	RJMP SUBOPT_0x27

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2C:
	LDI  R26,LOW(_pri1)
	LDI  R27,HIGH(_pri1)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(_pri2)
	LDI  R27,HIGH(_pri2)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2E:
	LDI  R26,LOW(_pri3)
	LDI  R27,HIGH(_pri3)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2F:
	LDI  R26,LOW(_pri4)
	LDI  R27,HIGH(_pri4)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x30:
	LDI  R26,LOW(_pri5)
	LDI  R27,HIGH(_pri5)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x31:
	SUBI R26,LOW(-_message_head)
	SBCI R27,HIGH(-_message_head)
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x32:
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x34:
	LDI  R30,LOW(0)
	STS  _bit_stuff_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(7)
	CP   R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x36:
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x37:
	MOV  R26,R7
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __MODW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x38:
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	ST   -Y,R30
	RJMP _set_nada

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	__DELAY_USW 1153
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3A:
	__DELAY_USW 575
	SBI  0x18,4
	__DELAY_USW 578
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	__CPWRN 16,17,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3E:
	MOVW R26,R28
	ADIW R26,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	MOVW R26,R28
	ADIW R26,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x40:
	ADD  R26,R16
	ADC  R27,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	RCALL SUBOPT_0x3E
	RCALL SUBOPT_0x40
	LD   R26,X
	CPI  R26,LOW(0x2E)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x42:
	LDI  R27,0
	SBRC R26,7
	SER  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	LDI  R30,LOW(234)
	OUT  0x2D,R30
	LDI  R30,LOW(231)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x44:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x45:
	RCALL __PUTPARD1
	RCALL _ftrunc
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x47:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x48:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x49:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4A:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4B:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	__GETD1S 2
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

_frexp:
	LD   R26,Y+
	LD   R27,Y+
	LD   R30,Y+
	LD   R31,Y+
	LD   R22,Y+
	LD   R23,Y+
	BST  R23,7
	LSL  R22
	ROL  R23
	CLR  R24
	SUBI R23,0x7E
	SBC  R24,R24
	ST   X+,R23
	ST   X,R24
	LDI  R23,0x7E
	LSR  R23
	ROR  R22
	BRTS __ANEGF1
	RET

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

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

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

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

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CWD2:
	MOV  R24,R27
	ADD  R24,R24
	SBC  R24,R24
	MOV  R25,R24
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

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
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

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
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

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__GETD2S0:
	LD   R26,Y
	LDD  R27,Y+1
	LDD  R24,Y+2
	LDD  R25,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
	RET

__CDF2U:
	SET
	RJMP __CDF2U0
__CDF2:
	CLT
__CDF2U0:
	RCALL __SWAPD12
	RCALL __CDF1U0

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

__CPD10:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	RET

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
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

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
