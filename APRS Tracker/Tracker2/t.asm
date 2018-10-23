
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8
;Program type             : Application
;Clock frequency          : 11.059200 MHz
;Memory model             : Small
;Optimize for             : Speed
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
;'char' is unsigned       : Yes
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
	.DEF _fcshi=R5
	.DEF _fcslo=R4
	.DEF _rx_wr_index=R7
	.DEF _rx_rd_index=R6
	.DEF _rx_counter=R9
	.DEF _tx_wr_index=R8
	.DEF _tx_rd_index=R11
	.DEF _tx_counter=R10
	.DEF _count_1=R13

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

_flag:
	.DB  0x7E,0x7E,0x7E,0x7E,0x7E,0x7E,0x7E,0x7E
	.DB  0x7E,0x7E,0x7E,0x7E
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x41,0x50,0x55,0x32,0x35,0x4D,0x65
_0x4:
	.DB  0x59,0x44,0x32,0x58,0x42,0x43,0x72
_0x5:
	.DB  0x57,0x49,0x44,0x45,0x32,0x33,0x20
_0x17:
	.DB  0xB0,0x4
_0x51:
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x07
	.DW  _destination
	.DW  _0x3*2

	.DW  0x07
	.DW  _source
	.DW  _0x4*2

	.DW  0x07
	.DW  _digi
	.DW  _0x5*2

	.DW  0x02
	.DW  _tone
	.DW  _0x17*2

	.DW  0x01
	.DW  0x0D
	.DW  _0x51*2

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
;CodeWizardAVR V1.25.3 Professional
;Automatic Program Generator
;© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 12/23/2011
;Author  : F4CG
;Company : F4CG
;Comments:
;
;
;Chip type           : ATmega8
;Program type        : Application
;Clock frequency     : 11.059200 MHz
;Memory model        : Small
;External SRAM size  : 0
;Data Stack size     : 256
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
;#include <stdio.h>
;#include <delay.h>
;
;#define on 1
;#define ON 1
;#define off 0
;#define OFF 0
;
;#define PTT PIND.1
;#define dac0    PORTB.0
;#define dac1    PORTB.1
;#define dac2    PORTB.2
;#define dac3    PORTB.3
;
;void protocol();
;void send_data(char input);
;void fliptone();
;void send_tone(int nada);
;void calc_fcs(char in);
;void send_fcs(char infcs);
;
;/**********************************************************************************************/
;// AX.25
;/**********************************************************************************************/
;
;flash char flag[12] = {
;        0x7E,0x7E,0x7E,0x7E,
;        0x7E,0x7E,0x7E,0x7E,
;        0x7E,0x7E,0x7E,0x7E
;        // FLAG 12 KALI
;};
;char destination[7] = {
;        0x41,0x50,0x55,0x32,0x35,0x4D,
;        0b01100101
;        // APU25N-2     //0b011SSSSx format, SSSS = 2 = 0b0010, x = 1 (callsign terakhir)
;};

	.DSEG
;char source[7] = {
;        0x59,0x44,0x32,0x58,0x42,0x43,
;        0b01110010      //0b011SSSSx format, SSSS = 9 = 0b1001, x = 0 (bukan callsign terakhir)
;        // YD2XBC-9
;};
;char digi[7] = {
;        0x57,0x49,0x44,0x45,0x32,0x33,0x20
;        // WIDE2-3
;};
;flash char control_field = 0x03;
;flash char protocol_id = 0xF0;
;flash char data_type = 0x21;
;char latitude[8];// = {
;
;//};
;flash char symbol_table = 0x2F;
;char longitude[9];// = {
;
;//};
;flash char symbol_code = 0x3E;
;flash char comment[43];// = {
;
;        // testing for emergency beacon
;//};
;char fcshi;
;char fcslo;
;
;/**********************************************************************************************/
;// USART
;/**********************************************************************************************/
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
;
;bit rx_buffer_overflow;
;char rx_buffer[RX_BUFFER_SIZE];
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE<256
;        unsigned char rx_wr_index,rx_rd_index,rx_counter;
;        #else
;        unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;interrupt [USART_RXC] void usart_rx_isr(void) {
; 0000 0077 interrupt [12] void usart_rx_isr(void) {

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0078         char status,data;
; 0000 0079         status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 007A         data=UDR;
	IN   R16,12
; 0000 007B         if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0) {
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x6
; 0000 007C                 rx_buffer[rx_wr_index]=data;
	MOV  R30,R7
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 007D                 if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x7
	CLR  R7
; 0000 007E                 if (++rx_counter == RX_BUFFER_SIZE) {
_0x7:
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x8
; 0000 007F                         rx_counter=0;
	CLR  R9
; 0000 0080                         rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0081                 };
_0x8:
; 0000 0082         };
_0x6:
; 0000 0083 }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;        #define _ALTERNATE_GETCHAR_
;        #pragma used+
;        char getchar(void) {
; 0000 0088 char getchar(void) {
; 0000 0089                 char data;
; 0000 008A                 while (rx_counter==0);
;	data -> R17
; 0000 008B                 data=rx_buffer[rx_rd_index];
; 0000 008C                 if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 008D                 #asm("cli")
; 0000 008E                 --rx_counter;
; 0000 008F                 #asm("sei")
; 0000 0090                 return data;
; 0000 0091         }
;        #pragma used-
;#endif
;
;#if TX_BUFFER_SIZE<256
;        unsigned char tx_wr_index,tx_rd_index,tx_counter;
;        #else
;        unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;interrupt [USART_TXC] void usart_tx_isr(void) {
; 0000 009B interrupt [14] void usart_tx_isr(void) {
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 009C         if (tx_counter) {
	TST  R10
	BREQ _0xD
; 0000 009D                 --tx_counter;
	DEC  R10
; 0000 009E                 UDR=tx_buffer[tx_rd_index];
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 009F                 if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R11
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0xE
	CLR  R11
; 0000 00A0         };
_0xE:
_0xD:
; 0000 00A1 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;        #define _ALTERNATE_PUTCHAR_
;        #pragma used+
;        void putchar(char c) {
; 0000 00A6 void putchar(char c) {
; 0000 00A7                 while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
; 0000 00A8                 #asm("cli")
; 0000 00A9                 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0)) {
; 0000 00AA                         tx_buffer[tx_wr_index]=c;
; 0000 00AB                         if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
; 0000 00AC                         ++tx_counter;
; 0000 00AD                 }
; 0000 00AE                 else
; 0000 00AF                         UDR=c;
; 0000 00B0                 #asm("sei")
; 0000 00B1         }
;        #pragma used-
;#endif
;
;
;/////////////////////////////////////////////////////////////////////////////////////////////
;/////////////////  AX.25 ////////////////////////////////////////////////////////////////////
;/////////////////////////////////////////////////////////////////////////////////////////////
;
;#define cons1200 52
;#define cons2200 26
;
;char count_1 = 0;
;int tone = 1200;

	.DSEG
;
;void protocol() {
; 0000 00C0 void protocol() {

	.CSEG
; 0000 00C1         int i;
; 0000 00C2         PTT = on;
;	i -> R16,R17
; 0000 00C3         delay_ms(500);
; 0000 00C4         for(i=0;i<12;i++)       send_data(flag[i]);             // kirim flag 12 kali
; 0000 00C5 for(i=0;i<7;i++)        send_data(destination[i]);
; 0000 00C6 for(i=0;i<7;i++)        send_data(source[i]);
; 0000 00C7 for(i=0;i<7;i++)        send_data(digi[i]);
; 0000 00C8 send_data(control_field);
; 0000 00C9         send_data(protocol_id);                                 // kirim data PID
; 0000 00CA         send_data(data_type);                                   // kirim data type info
; 0000 00CB         for(i=0;i<8;i++)        send_data(latitude[i]);         // kirim data lintang posisi
; 0000 00CC send_data(symbol_table);
; 0000 00CD         for(i=0;i<9;i++)        send_data(longitude[i]);        // kirim data bujur posisi
; 0000 00CE send_data(symbol_code);
; 0000 00CF         send_fcs(fcshi);
; 0000 00D0         send_fcs(fcslo);
; 0000 00D1         for(i=0;i<12;i++)       send_data(flag[i]);             // kirim flag 12 kali
; 0000 00D2 PIND.1  = 0;
; 0000 00D3 }
;
;void send_data(char input) {
; 0000 00D5 void send_data(char input) {
; 0000 00D6         int i;
; 0000 00D7         bit x;
; 0000 00D8         for(i=0;i<8;i++) {
;	input -> Y+2
;	i -> R16,R17
;	x -> R15.0
; 0000 00D9                 x = input & 0x01;
; 0000 00DA                 calc_fcs(x);
; 0000 00DB 
; 0000 00DC                 if(x) {
; 0000 00DD                         count_1++;
; 0000 00DE                         if(count_1==5)    fliptone();
; 0000 00DF                         send_tone(tone);
; 0000 00E0                 }
; 0000 00E1                 if(!x)  fliptone();
; 0000 00E2                 input = input >> 1;
; 0000 00E3         }
; 0000 00E4 }
;
;void fliptone() {
; 0000 00E6 void fliptone() {
; 0000 00E7         count_1 = 0;
; 0000 00E8         switch(tone) {
; 0000 00E9                 case 1200:      tone=2200;      send_tone(tone);        break;
; 0000 00EA                 case 2200:      tone=1200;      send_tone(tone);        break;
; 0000 00EB         }
; 0000 00EC }
;
;void set_dac(char value) {
; 0000 00EE void set_dac(char value) {
; 0000 00EF         dac0 = value & 0x01;
;	value -> Y+0
; 0000 00F0         dac1 =( value >> 1) & 0x01;
; 0000 00F1         dac2 =( value >> 2) & 0x01;
; 0000 00F2         dac3 =( value >> 3) & 0x01;
; 0000 00F3 }
;
;void send_tone(int nada) {
; 0000 00F5 void send_tone(int nada) {
; 0000 00F6         if(nada==1200) {
;	nada -> Y+0
; 0000 00F7                 set_dac(7);     delay_us(cons1200);
; 0000 00F8 
; 0000 00F9                 set_dac(10);    delay_us(cons1200);
; 0000 00FA                 set_dac(13);    delay_us(cons1200);
; 0000 00FB                 set_dac(14);    delay_us(cons1200);
; 0000 00FC 
; 0000 00FD                 set_dac(15);    delay_us(cons1200);
; 0000 00FE 
; 0000 00FF                 set_dac(14);    delay_us(cons1200);
; 0000 0100                 set_dac(13);    delay_us(cons1200);
; 0000 0101                 set_dac(10);    delay_us(cons1200);
; 0000 0102 
; 0000 0103                 set_dac(7);     delay_us(cons1200);
; 0000 0104 
; 0000 0105                 set_dac(5);     delay_us(cons1200);
; 0000 0106                 set_dac(2);     delay_us(cons1200);
; 0000 0107                 set_dac(1);     delay_us(cons1200);
; 0000 0108 
; 0000 0109                 set_dac(0);     delay_us(cons1200);
; 0000 010A 
; 0000 010B                 set_dac(1);     delay_us(cons1200);
; 0000 010C                 set_dac(2);     delay_us(cons1200);
; 0000 010D                 set_dac(5);     delay_us(cons1200);
; 0000 010E         }
; 0000 010F         else {
; 0000 0110                 set_dac(7);     delay_us(cons2200);
; 0000 0111 
; 0000 0112                 set_dac(10);    delay_us(cons2200);
; 0000 0113                 set_dac(13);    delay_us(cons2200);
; 0000 0114                 set_dac(14);    delay_us(cons2200);
; 0000 0115 
; 0000 0116                 set_dac(15);    delay_us(cons2200);
; 0000 0117 
; 0000 0118                 set_dac(14);    delay_us(cons2200);
; 0000 0119                 set_dac(13);    delay_us(cons2200);
; 0000 011A                 set_dac(10);    delay_us(cons2200);
; 0000 011B 
; 0000 011C                 set_dac(7);     delay_us(cons2200);
; 0000 011D 
; 0000 011E                 set_dac(5);     delay_us(cons2200);
; 0000 011F                 set_dac(2);     delay_us(cons2200);
; 0000 0120                 set_dac(1);     delay_us(cons2200);
; 0000 0121 
; 0000 0122                 set_dac(0);     delay_us(cons2200);
; 0000 0123 
; 0000 0124                 set_dac(1);     delay_us(cons2200);
; 0000 0125                 set_dac(2);     delay_us(cons2200);
; 0000 0126                 set_dac(5);     delay_us(cons2200);
; 0000 0127 
; 0000 0128                 set_dac(7);     delay_us(cons2200);
; 0000 0129 
; 0000 012A                 set_dac(10);    delay_us(cons2200);
; 0000 012B                 set_dac(13);    delay_us(cons2200);
; 0000 012C                 set_dac(14);    delay_us(cons2200);
; 0000 012D 
; 0000 012E                 set_dac(15);    delay_us(cons2200);
; 0000 012F 
; 0000 0130                 set_dac(14);    delay_us(cons2200);
; 0000 0131                 set_dac(13);    delay_us(cons2200);
; 0000 0132                 set_dac(10);    delay_us(cons2200);
; 0000 0133 
; 0000 0134                 set_dac(7);     delay_us(cons2200);
; 0000 0135 
; 0000 0136                 set_dac(5);     delay_us(cons2200);
; 0000 0137                 set_dac(2);     delay_us(cons2200);
; 0000 0138                 set_dac(1);     delay_us(cons2200);
; 0000 0139 
; 0000 013A                 set_dac(0);     delay_us(cons2200);
; 0000 013B 
; 0000 013C                 set_dac(1);     delay_us(cons2200);
; 0000 013D                 set_dac(2);     delay_us(cons2200);
; 0000 013E                 set_dac(5);     delay_us(cons2200);
; 0000 013F         }
; 0000 0140 }
;
;void send_fcs(char infcs) {
; 0000 0142 void send_fcs(char infcs) {
; 0000 0143         int j=7;
; 0000 0144         bit x;
; 0000 0145         while(j>0) {
;	infcs -> Y+2
;	j -> R16,R17
;	x -> R15.0
; 0000 0146                 x = (infcs >> j) & 0x01;
; 0000 0147                 if(x) {
; 0000 0148                         count_1++;
; 0000 0149                         if(count_1==5)    fliptone();
; 0000 014A                         send_tone(tone);
; 0000 014B                 }
; 0000 014C                 if(!x)  fliptone();
; 0000 014D                 j--;
; 0000 014E         }
; 0000 014F }
;
;void calc_fcs(char in) {
; 0000 0151 void calc_fcs(char in) {
; 0000 0152 
; 0000 0153 }
;
;/////////////////////////////////////////////////////////////////////////////////////////////
;/////////////////// main & utility function /////////////////////////////////////////////////
;/////////////////////////////////////////////////////////////////////////////////////////////
;
;void main(void) {
; 0000 0159 void main(void) {
_main:
; 0000 015A         PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 015B         DDRB=0x00;
	OUT  0x17,R30
; 0000 015C         PORTC=0x00;
	OUT  0x15,R30
; 0000 015D         DDRC=0x00;
	OUT  0x14,R30
; 0000 015E         PORTD=0x00;
	OUT  0x12,R30
; 0000 015F         DDRD=0x00;
	OUT  0x11,R30
; 0000 0160 
; 0000 0161         // USART initialization
; 0000 0162         // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0163         // USART Receiver: On
; 0000 0164         // USART Transmitter: On
; 0000 0165         // USART Mode: Asynchronous
; 0000 0166         // USART Baud rate: 4800
; 0000 0167         UCSRA=0x00;
	OUT  0xB,R30
; 0000 0168         UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0169         UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 016A         UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 016B         UBRRL=0x8F;
	LDI  R30,LOW(143)
	OUT  0x9,R30
; 0000 016C 
; 0000 016D         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 016E         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 016F 
; 0000 0170         #asm("sei")
	sei
; 0000 0171 
; 0000 0172         while (1) {
_0x4C:
; 0000 0173         };
	RJMP _0x4C
; 0000 0174 }
_0x4F:
	RJMP _0x4F
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

	.CSEG

	.CSEG

	.DSEG
_destination:
	.BYTE 0x7
_source:
	.BYTE 0x7
_digi:
	.BYTE 0x7
_latitude:
	.BYTE 0x8
_longitude:
	.BYTE 0x9
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8
_tone:
	.BYTE 0x2

	.CSEG

	.CSEG
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
