
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
;Data Stack size          : 700 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : No
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
	.EQU __DSTACK_SIZE=0x02BC
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
	.DEF _beacon_stat=R6
	.DEF _crc=R7
	.DEF _tcnt1c=R9

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
	.DB  0x30,0x31,0x33,0x2E,0x38,0x56
_0x5:
	.DB  0x21,0x21,0x57
_0x0:
	.DB  0x59,0x6F,0x75,0x72,0x20,0x50,0x72,0x6F
	.DB  0x54,0x72,0x61,0x6B,0x21,0x20,0x6D,0x6F
	.DB  0x64,0x65,0x6C,0x20,0x41,0x20,0x43,0x6F
	.DB  0x6E,0x66,0x69,0x67,0x75,0x72,0x61,0x74
	.DB  0x69,0x6F,0x6E,0x20,0x69,0x73,0x3A,0x0
	.DB  0x43,0x61,0x6C,0x6C,0x73,0x69,0x67,0x6E
	.DB  0x0,0x44,0x69,0x67,0x69,0x20,0x50,0x61
	.DB  0x74,0x68,0x28,0x73,0x29,0x0,0x54,0x58
	.DB  0x20,0x49,0x6E,0x74,0x65,0x72,0x76,0x61
	.DB  0x6C,0x0,0x73,0x65,0x63,0x6F,0x6E,0x64
	.DB  0x28,0x73,0x29,0x0,0x20,0x69,0x73,0x20
	.DB  0x74,0x6F,0x6F,0x20,0x6C,0x6F,0x6E,0x67
	.DB  0x0,0x53,0x79,0x6D,0x62,0x6F,0x6C,0x20
	.DB  0x2F,0x20,0x49,0x63,0x6F,0x6E,0x0,0x53
	.DB  0x79,0x6D,0x62,0x6F,0x6C,0x20,0x54,0x61
	.DB  0x62,0x6C,0x65,0x20,0x2F,0x20,0x4F,0x76
	.DB  0x65,0x72,0x6C,0x61,0x79,0x0,0x43,0x6F
	.DB  0x6D,0x6D,0x65,0x6E,0x74,0x0,0x53,0x74
	.DB  0x61,0x74,0x75,0x73,0x0,0x53,0x74,0x61
	.DB  0x74,0x75,0x73,0x20,0x49,0x6E,0x74,0x65
	.DB  0x72,0x76,0x61,0x6C,0x0,0x74,0x72,0x61
	.DB  0x6E,0x73,0x6D,0x69,0x73,0x73,0x69,0x6F
	.DB  0x6E,0x28,0x73,0x29,0x0,0x42,0x41,0x53
	.DB  0x45,0x2D,0x39,0x31,0x20,0x3F,0x20,0x28
	.DB  0x59,0x2F,0x4E,0x29,0x0,0x4E,0x4F,0x20
	.DB  0x47,0x50,0x53,0x20,0x43,0x6F,0x6F,0x72
	.DB  0x64,0x69,0x6E,0x61,0x74,0x65,0x0,0x55
	.DB  0x73,0x65,0x20,0x47,0x50,0x53,0x20,0x3F
	.DB  0x20,0x28,0x59,0x2F,0x4E,0x29,0x0,0x44
	.DB  0x69,0x70,0x6C,0x61,0x79,0x20,0x42,0x61
	.DB  0x74,0x74,0x65,0x72,0x79,0x20,0x56,0x6F
	.DB  0x6C,0x74,0x61,0x67,0x65,0x20,0x69,0x6E
	.DB  0x20,0x43,0x6F,0x6D,0x6D,0x65,0x6E,0x74
	.DB  0x20,0x3F,0x20,0x28,0x59,0x2F,0x4E,0x29
	.DB  0x0,0x44,0x69,0x70,0x6C,0x61,0x79,0x20
	.DB  0x54,0x65,0x6D,0x70,0x65,0x72,0x61,0x74
	.DB  0x75,0x72,0x65,0x20,0x69,0x6E,0x20,0x43
	.DB  0x6F,0x6D,0x6D,0x65,0x6E,0x74,0x20,0x3F
	.DB  0x20,0x28,0x59,0x2F,0x4E,0x29,0x0,0x53
	.DB  0x65,0x6E,0x64,0x20,0x41,0x6C,0x74,0x69
	.DB  0x74,0x75,0x64,0x65,0x20,0x3F,0x20,0x28
	.DB  0x59,0x2F,0x4E,0x29,0x0,0x53,0x65,0x6E
	.DB  0x64,0x20,0x54,0x65,0x6D,0x70,0x65,0x72
	.DB  0x61,0x74,0x75,0x72,0x65,0x20,0x61,0x6E
	.DB  0x64,0x20,0x42,0x61,0x74,0x74,0x65,0x72
	.DB  0x79,0x20,0x56,0x6F,0x6C,0x74,0x61,0x67
	.DB  0x65,0x20,0x74,0x6F,0x20,0x50,0x43,0x20
	.DB  0x3F,0x20,0x28,0x59,0x2F,0x4E,0x29,0x0
	.DB  0x45,0x4E,0x54,0x45,0x52,0x49,0x4E,0x47
	.DB  0x20,0x43,0x4F,0x4E,0x46,0x49,0x47,0x55
	.DB  0x52,0x41,0x54,0x49,0x4F,0x4E,0x20,0x4D
	.DB  0x4F,0x44,0x45,0x2E,0x2E,0x2E,0x0,0x43
	.DB  0x4F,0x4E,0x46,0x49,0x47,0x55,0x52,0x45
	.DB  0x2E,0x2E,0x2E,0x0,0x53,0x41,0x56,0x49
	.DB  0x4E,0x47,0x20,0x43,0x4F,0x4E,0x46,0x49
	.DB  0x47,0x55,0x52,0x41,0x54,0x49,0x4F,0x4E
	.DB  0x2E,0x2E,0x2E,0x0,0x43,0x4F,0x4E,0x46
	.DB  0x49,0x47,0x20,0x53,0x55,0x43,0x43,0x45
	.DB  0x53,0x53,0x20,0x21,0x0,0x54,0x65,0x6D
	.DB  0x70,0x65,0x72,0x61,0x74,0x75,0x72,0x65
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x3A
	.DB  0x0,0x42,0x61,0x74,0x74,0x65,0x72,0x79
	.DB  0x20,0x56,0x6F,0x6C,0x74,0x61,0x67,0x65
	.DB  0x20,0x20,0x20,0x3A,0x0
_0x2040060:
	.DB  0x1
_0x2040000:
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

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x2040060*2

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
	.ORG 0x31C

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
;#include <stdlib.h>
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
;void kirim_add_aprs(void);
;void kirim_ax25_head(void);
;void kirim_status(void);
;void kirim_paket(void);
;void kirim_crc(void);
;void kirim_karakter(unsigned char input);
;void hitung_crc(char in_crc);
;void ubah_nada(void);
;void set_nada(char i_nada);
;unsigned int read_adc(unsigned char adc_input);
;void waitComma(void);
;void waitDollar(void);
;void waitInvCo(void);
;void config(void);
;void extractGPS(void);
;
;eeprom char SYM_TAB_OVL_='/';
;eeprom char SYM_CODE_='O';
;eeprom unsigned char add_aprs[7]={('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),('0'<<1)};
;eeprom unsigned char add_beacon[7]={('B'<<1),('E'<<1),('A'<<1),('C'<<1),('O'<<1),('N'<<1),('0'<<1)};
;eeprom unsigned char mycall[8]={"YC2WYA0"};
;eeprom unsigned char mydigi1[8]={"WIDE2 1"};
;eeprom unsigned char mydigi2[8]={"WIDE2 2"};
;eeprom unsigned char mydigi3[8]={"WIDE2 2"};
;eeprom char comment[100] ={"New Tracker"};
;eeprom char status[100]={"ProTrak! APRS & Telemetry Encoder"};
;eeprom char posisi_lat[11]={"0745.4821S"};
;eeprom char posisi_long[12]={"11022.5621E"};
;eeprom unsigned int altitude = 0;
;eeprom int m_int=21;
;eeprom char comp_lat[4];
;eeprom char comp_long[4];
;eeprom int timeIntv=4;
;eeprom char compstat='Y';
;eeprom char battvoltincomm='Y';
;eeprom char tempincomm='Y';
;eeprom char sendalt='Y';
;eeprom char gps='N';
;eeprom char sendtopc='N';
;eeprom char commsize=11;
;eeprom char statsize=33;
;
;char temp[7]={"020.0C"};

	.DSEG
;char volt[7]={"013.8V"};
;char comp_cst[3]={33,33,(0b00110110+33)};
;char beacon_stat;
;bit nada;
;static char bit_stuff;
;unsigned short crc;
;unsigned int tcnt1c;
;
;void read_temp(void)
; 0000 006B {

	.CSEG
_read_temp:
; 0000 006C 	int adc;
; 0000 006D         char adc_r,adc_p,adc_s,adc_d;
; 0000 006E 
; 0000 006F         adc = (5*read_adc(TEMP_ADC_)/1.024);
	RCALL __SAVELOCR6
;	adc -> R16,R17
;	adc_r -> R19
;	adc_p -> R18
;	adc_s -> R21
;	adc_d -> R20
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(5)
	LDI  R27,HIGH(5)
	RCALL SUBOPT_0x0
	__GETD1N 0x3F83126F
	RCALL SUBOPT_0x1
; 0000 0070         //itoa(adc,temp);
; 0000 0071 
; 0000 0072         adc_r = (adc/1000);
; 0000 0073         adc_p = ((adc%1000)/100);
; 0000 0074         adc_s = ((adc%100)/10);
; 0000 0075         adc_d = (adc%10);
; 0000 0076 
; 0000 0077         if(adc_r==0)temp[0]=' ';
	BRNE _0x6
	LDI  R30,LOW(32)
	RJMP _0x183
; 0000 0078         else temp[0] = adc_r + '0';
_0x6:
	MOV  R30,R19
	SUBI R30,-LOW(48)
_0x183:
	STS  _temp,R30
; 0000 0079         if((adc_p==0)&&(adc_r==0)) temp[1]=' ';
	CPI  R18,0
	BRNE _0x9
	CPI  R19,0
	BREQ _0xA
_0x9:
	RJMP _0x8
_0xA:
	LDI  R30,LOW(32)
	RJMP _0x184
; 0000 007A         else temp[1] = adc_p + '0';
_0x8:
	MOV  R30,R18
	SUBI R30,-LOW(48)
_0x184:
	__PUTB1MN _temp,1
; 0000 007B         temp[2] = adc_s + '0';
	MOV  R30,R21
	SUBI R30,-LOW(48)
	__PUTB1MN _temp,2
; 0000 007C         temp[4] = adc_d + '0';
	MOV  R30,R20
	SUBI R30,-LOW(48)
	__PUTB1MN _temp,4
; 0000 007D }
	RJMP _0x20A0007
;
;void read_volt(void)
; 0000 0080 {
_read_volt:
; 0000 0081 	int adc;
; 0000 0082         char adc_r,adc_p,adc_s,adc_d;
; 0000 0083 
; 0000 0084         adc = (5*22*read_adc(VSENSE_ADC_))/102.4;
	RCALL __SAVELOCR6
;	adc -> R16,R17
;	adc_r -> R19
;	adc_p -> R18
;	adc_s -> R21
;	adc_d -> R20
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R26,LOW(110)
	LDI  R27,HIGH(110)
	RCALL SUBOPT_0x0
	__GETD1N 0x42CCCCCD
	RCALL SUBOPT_0x1
; 0000 0085         //itoa(adc,volt);
; 0000 0086 
; 0000 0087         adc_r = (adc/1000);
; 0000 0088         adc_p = ((adc%1000)/100);
; 0000 0089         adc_s = ((adc%100)/10);
; 0000 008A         adc_d = (adc%10);
; 0000 008B 
; 0000 008C         if(adc_r==0)	volt[0]=' ';
	BRNE _0xC
	LDI  R30,LOW(32)
	RJMP _0x185
; 0000 008D         else volt[0] = adc_r + '0';
_0xC:
	MOV  R30,R19
	SUBI R30,-LOW(48)
_0x185:
	STS  _volt,R30
; 0000 008E         if((adc_p==0)&&(adc_r==0)) volt[1]=' ';
	CPI  R18,0
	BRNE _0xF
	CPI  R19,0
	BREQ _0x10
_0xF:
	RJMP _0xE
_0x10:
	LDI  R30,LOW(32)
	RJMP _0x186
; 0000 008F         else volt[1] = adc_p + '0';
_0xE:
	MOV  R30,R18
	SUBI R30,-LOW(48)
_0x186:
	__PUTB1MN _volt,1
; 0000 0090         volt[2] = adc_s + '0';
	MOV  R30,R21
	SUBI R30,-LOW(48)
	__PUTB1MN _volt,2
; 0000 0091         volt[4] = adc_d + '0';
	MOV  R30,R20
	SUBI R30,-LOW(48)
	__PUTB1MN _volt,4
; 0000 0092 }
_0x20A0007:
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
;
;void base91_lat(void)
; 0000 0095 {
_base91_lat:
; 0000 0096   	char deg;
; 0000 0097         char min;
; 0000 0098         float sec;
; 0000 0099         char sign;
; 0000 009A         float lat;
; 0000 009B         float f_lat;
; 0000 009C 
; 0000 009D         deg = ((posisi_lat[0]-48)*10) + (posisi_lat[1]-48);
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
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	__POINTW2MN _posisi_lat,1
	RCALL SUBOPT_0x2
	ADD  R30,R0
	MOV  R17,R30
; 0000 009E         min = ((posisi_lat[2]-48)*10) + (posisi_lat[3]-48);
	__POINTW2MN _posisi_lat,2
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	__POINTW2MN _posisi_lat,3
	RCALL SUBOPT_0x2
	ADD  R30,R0
	MOV  R16,R30
; 0000 009F         //sec = ((posisi_lat[5]-48)*1000.0) + ((posisi_lat[6]-48)*100.0)+((posisi_lat[7]-48)*10.0) + (posisi_lat[8]-48);
; 0000 00A0         sec = ((posisi_lat[5]-48)*100.0) + ((posisi_lat[6]-48)*10.0)+((posisi_lat[7]-48)*1.0);
	__POINTW2MN _posisi_lat,5
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _posisi_lat,6
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x6
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _posisi_lat,7
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x7
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	__PUTD1S 12
; 0000 00A1         //sec = ((posisi_lat[5]-48)*10.0) + (posisi_lat[6]-48);
; 0000 00A2 
; 0000 00A3         if(posisi_lat[7]=='N') sign = 1.0;
	__POINTW2MN _posisi_lat,7
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x4E)
	BRNE _0x12
	RCALL SUBOPT_0x8
	RJMP _0x187
; 0000 00A4         else sign = -1.0;
_0x12:
	RCALL SUBOPT_0x9
_0x187:
	MOV  R19,R30
; 0000 00A5 
; 0000 00A6         //f_lat = (deg + (min/60.0) + (0.6*sec/360000.0));
; 0000 00A7         f_lat = (deg + (min/60.0) + (0.6*sec/36000.0));
	MOV  R30,R16
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0xB
	MOV  R26,R17
	RCALL __CBD2
	RCALL __CDF2
	RCALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 12
	RCALL SUBOPT_0xC
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	__PUTD1S 4
; 0000 00A8         //f_lat = (deg + (min/60.0) + (0.6*sec/3600.0));
; 0000 00A9         lat = 380926 * (90 - (f_lat * sign));
	MOV  R30,R19
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x4
	RCALL __MULF12
	__GETD2N 0x42B40000
	RCALL SUBOPT_0xE
	__GETD2N 0x48B9FFC0
	RCALL __MULF12
	__PUTD1S 8
; 0000 00AA 
; 0000 00AB         comp_lat[0] = (lat/753571)+33;
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	LDI  R26,LOW(_comp_lat)
	LDI  R27,HIGH(_comp_lat)
	RCALL SUBOPT_0x12
; 0000 00AC         comp_lat[1] = ((fmod(lat,753571))/8281)+33;
	RCALL SUBOPT_0x13
	__POINTW2MN _comp_lat,1
	RCALL SUBOPT_0x12
; 0000 00AD         comp_lat[2] = ((fmod(lat,8281))/91)+33;
	RCALL SUBOPT_0x14
	__POINTW2MN _comp_lat,2
	RCALL SUBOPT_0x12
; 0000 00AE         comp_lat[3] = (fmod(lat,91))+33;
	RCALL SUBOPT_0x15
	__POINTW2MN _comp_lat,3
	RCALL SUBOPT_0x16
; 0000 00AF }
	RCALL __LOADLOCR4
	ADIW R28,16
	RET
;
;void base91_long(void)
; 0000 00B2 {
_base91_long:
; 0000 00B3   	float deg;
; 0000 00B4         float min;
; 0000 00B5         float sec;
; 0000 00B6         char sign;
; 0000 00B7         float lon;
; 0000 00B8         float f_lon;
; 0000 00B9 
; 0000 00BA         deg = ((posisi_long[0]-48)*100) + ((posisi_long[1]-48)*10) + ((posisi_long[2]-48)*1);
	SBIW R28,20
	ST   -Y,R17
;	deg -> Y+17
;	min -> Y+13
;	sec -> Y+9
;	sign -> R17
;	lon -> Y+5
;	f_lon -> Y+1
	LDI  R26,LOW(_posisi_long)
	LDI  R27,HIGH(_posisi_long)
	RCALL SUBOPT_0x2
	LDI  R26,LOW(100)
	MULS R30,R26
	MOV  R22,R0
	__POINTW2MN _posisi_long,1
	RCALL SUBOPT_0x2
	LDI  R26,LOW(10)
	MULS R30,R26
	MOVW R30,R0
	ADD  R30,R22
	MOV  R0,R30
	__POINTW2MN _posisi_long,2
	RCALL SUBOPT_0x2
	ADD  R30,R0
	RCALL SUBOPT_0x4
	__PUTD1S 17
; 0000 00BB         min = ((posisi_long[3]-48)*10) + (posisi_long[4]-48);
	__POINTW2MN _posisi_long,3
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	__POINTW2MN _posisi_long,4
	RCALL SUBOPT_0x2
	ADD  R30,R0
	RCALL SUBOPT_0x4
	__PUTD1S 13
; 0000 00BC         //sec = ((posisi_long[6]-48)*1000.0) + ((posisi_long[7]-48)*100.0) + ((posisi_long[8]-48)*10.0) + (posisi_long[9]-48); 	// <---- 1 foot resolution
; 0000 00BD         sec = ((posisi_long[6]-48)*100.0) + ((posisi_long[7]-48)*10.0) + ((posisi_long[8]-48)*1.0);				// <---- 1 meter resolution
	__POINTW2MN _posisi_long,6
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x4
	RCALL SUBOPT_0x5
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _posisi_long,7
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x6
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__POINTW2MN _posisi_long,8
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x7
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	__PUTD1S 9
; 0000 00BE         //sec = ((posisi_long[6]-48)*10.0) + (posisi_long[7]-48);  								// <---- 8 meter resolution
; 0000 00BF 
; 0000 00C0         if(posisi_long[8]=='E') sign = 1.0;
	__POINTW2MN _posisi_long,8
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x45)
	BRNE _0x14
	RCALL SUBOPT_0x8
	RJMP _0x188
; 0000 00C1         else			sign = -1.0;
_0x14:
	RCALL SUBOPT_0x9
_0x188:
	MOV  R17,R30
; 0000 00C2 
; 0000 00C3         //f_lon = (deg + (min/60.0) + (0.6*sec/360000.0));	// <---- 1 foot resolution
; 0000 00C4         f_lon = (deg + (min/60.0) + (0.6*sec/36000.0)); 	// <---- 1 meter resolution
	__GETD2S 13
	RCALL SUBOPT_0xB
	__GETD2S 17
	RCALL __ADDF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	__GETD1S 9
	RCALL SUBOPT_0xC
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __ADDF12
	__PUTD1S 1
; 0000 00C5         //f_lon = (deg + (min/60.0) + (0.6*sec/3600.0));	// <---- 8 meter resolution
; 0000 00C6         lon = 190463 * (180 - (f_lon * sign));
	MOV  R30,R17
	__GETD2S 1
	RCALL SUBOPT_0x4
	RCALL __MULF12
	__GETD2N 0x43340000
	RCALL SUBOPT_0xE
	__GETD2N 0x4839FFC0
	RCALL __MULF12
	__PUTD1S 5
; 0000 00C7 
; 0000 00C8         comp_long[0] = (lon/753571)+33;
	__GETD2S 5
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x11
	LDI  R26,LOW(_comp_long)
	LDI  R27,HIGH(_comp_long)
	RCALL SUBOPT_0x16
; 0000 00C9         comp_long[1] = ((fmod(lon,753571))/8281)+33;
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x13
	__POINTW2MN _comp_long,1
	RCALL SUBOPT_0x16
; 0000 00CA         comp_long[2] = ((fmod(lon,8281))/91)+33;
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x14
	__POINTW2MN _comp_long,2
	RCALL SUBOPT_0x16
; 0000 00CB         comp_long[3] = (fmod(lon,91))+33;
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x15
	__POINTW2MN _comp_long,3
	RCALL SUBOPT_0x16
; 0000 00CC }
	LDD  R17,Y+0
	ADIW R28,21
	RET
;
;void base91_alt(void)
; 0000 00CF {
_base91_alt:
; 0000 00D0 	int alt;
; 0000 00D1 
; 0000 00D2         alt = (500.5*log(altitude*1.0));
	RCALL __SAVELOCR2
;	alt -> R16,R17
	LDI  R26,LOW(_altitude)
	LDI  R27,HIGH(_altitude)
	RCALL __EEPROMRDW
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL SUBOPT_0x18
	RCALL __MULF12
	RCALL __PUTPARD1
	RCALL _log
	__GETD2N 0x43FA4000
	RCALL __MULF12
	RCALL __CFD1
	MOVW R16,R30
; 0000 00D3         comp_cst[0] = (alt/91)+33;
	MOVW R26,R16
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	RCALL __DIVW21
	SUBI R30,-LOW(33)
	STS  _comp_cst,R30
; 0000 00D4         comp_cst[1] = (alt%91)+33;
	MOVW R26,R16
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	RCALL __MODW21
	SUBI R30,-LOW(33)
	__PUTB1MN _comp_cst,1
; 0000 00D5 }
	RCALL __LOADLOCR2P
	RET
;
;void kirim_add_aprs(void)
; 0000 00D8 {
_kirim_add_aprs:
; 0000 00D9 	char i;
; 0000 00DA 
; 0000 00DB         for(i=0;i<7;i++)kirim_karakter(add_aprs[i]);
	RCALL SUBOPT_0x19
;	i -> R17
_0x17:
	CPI  R17,7
	BRGE _0x18
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_add_aprs)
	SBCI R27,HIGH(-_add_aprs)
	RCALL SUBOPT_0x1B
	SUBI R17,-1
	RJMP _0x17
_0x18:
; 0000 00DC }
	RJMP _0x20A0006
;
;void kirim_add_beacon(void)
; 0000 00DF {
_kirim_add_beacon:
; 0000 00E0 	char i;
; 0000 00E1 
; 0000 00E2         for(i=0;i<7;i++)kirim_karakter(add_beacon[i]);
	RCALL SUBOPT_0x19
;	i -> R17
_0x1A:
	CPI  R17,7
	BRGE _0x1B
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_add_beacon)
	SBCI R27,HIGH(-_add_beacon)
	RCALL SUBOPT_0x1B
	SUBI R17,-1
	RJMP _0x1A
_0x1B:
; 0000 00E3 }
	RJMP _0x20A0006
;
;void kirim_ax25_head(void)
; 0000 00E6 {
_kirim_ax25_head:
; 0000 00E7 	char i;
; 0000 00E8 
; 0000 00E9         for(i=0;i<6;i++)kirim_karakter(mycall[i]<<1);
	RCALL SUBOPT_0x19
;	i -> R17
_0x1D:
	CPI  R17,6
	BRGE _0x1E
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	SUBI R17,-1
	RJMP _0x1D
_0x1E:
; 0000 00EA if(((mydigi1[0]>47)&&(mydigi1[0]<58))||((mydigi1[0]>64)&&(mydigi1[0]<91)))
	LDI  R26,LOW(_mydigi1)
	LDI  R27,HIGH(_mydigi1)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x30)
	BRLO _0x20
	CPI  R30,LOW(0x3A)
	BRLO _0x22
_0x20:
	CPI  R30,LOW(0x41)
	BRLO _0x23
	CPI  R30,LOW(0x5B)
	BRLO _0x22
_0x23:
	RJMP _0x1F
_0x22:
; 0000 00EB         {
; 0000 00EC         	kirim_karakter(mycall[6]<<1);
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x1D
; 0000 00ED                 for(i=0;i<6;i++)kirim_karakter(mydigi1[i]<<1);
	LDI  R17,LOW(0)
_0x27:
	CPI  R17,6
	BRGE _0x28
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x1D
	SUBI R17,-1
	RJMP _0x27
_0x28:
; 0000 00EE if(((mydigi2[0]>47)&&(mydigi2[0]<58))||((mydigi2[0]>64)&&(mydigi2[0]<91)))
	LDI  R26,LOW(_mydigi2)
	LDI  R27,HIGH(_mydigi2)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x30)
	BRLO _0x2A
	CPI  R30,LOW(0x3A)
	BRLO _0x2C
_0x2A:
	CPI  R30,LOW(0x41)
	BRLO _0x2D
	CPI  R30,LOW(0x5B)
	BRLO _0x2C
_0x2D:
	RJMP _0x29
_0x2C:
; 0000 00EF         	{
; 0000 00F0         		kirim_karakter(mydigi1[6]<<1);
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1D
; 0000 00F1                 	for(i=0;i<6;i++)kirim_karakter(mydigi2[i]<<1);
	LDI  R17,LOW(0)
_0x31:
	CPI  R17,6
	BRGE _0x32
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1D
	SUBI R17,-1
	RJMP _0x31
_0x32:
; 0000 00F2 if(((mydigi3[0]>47)&&(mydigi3[0]<58))||((mydigi3[0]>64)&&(mydigi3[0]<91)))
	LDI  R26,LOW(_mydigi3)
	LDI  R27,HIGH(_mydigi3)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x30)
	BRLO _0x34
	CPI  R30,LOW(0x3A)
	BRLO _0x36
_0x34:
	CPI  R30,LOW(0x41)
	BRLO _0x37
	CPI  R30,LOW(0x5B)
	BRLO _0x36
_0x37:
	RJMP _0x33
_0x36:
; 0000 00F3         		{
; 0000 00F4         			kirim_karakter(mydigi2[6]<<1);
	RCALL SUBOPT_0x22
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x1D
; 0000 00F5                 		for(i=0;i<6;i++)kirim_karakter(mydigi3[i]<<1);
	LDI  R17,LOW(0)
_0x3B:
	CPI  R17,6
	BRGE _0x3C
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x1D
	SUBI R17,-1
	RJMP _0x3B
_0x3C:
; 0000 00F6 kirim_karakter((mydigi3[6]<<1)+1);
	RCALL SUBOPT_0x24
	RJMP _0x189
; 0000 00F7         		}
; 0000 00F8         		else
_0x33:
; 0000 00F9         		{
; 0000 00FA         			kirim_karakter((mydigi2[6]<<1)+1);
	RCALL SUBOPT_0x22
_0x189:
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x25
; 0000 00FB         		}
; 0000 00FC         	}
; 0000 00FD         	else
	RJMP _0x3E
_0x29:
; 0000 00FE         	{
; 0000 00FF         		kirim_karakter((mydigi1[6]<<1)+1);
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x25
; 0000 0100         	}
_0x3E:
; 0000 0101         }
; 0000 0102         else
	RJMP _0x3F
_0x1F:
; 0000 0103         {
; 0000 0104         	kirim_karakter((mycall[6]<<1)+1);
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0x25
; 0000 0105         }
_0x3F:
; 0000 0106 	kirim_karakter(CONTROL_FIELD_);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x26
; 0000 0107 	kirim_karakter(PROTOCOL_ID_);
	LDI  R30,LOW(240)
	RCALL SUBOPT_0x26
; 0000 0108 }
	RJMP _0x20A0006
;
;void kirim_status(void)
; 0000 010B {
_kirim_status:
; 0000 010C 	char i;
; 0000 010D 
; 0000 010E         kirim_add_aprs();
	ST   -Y,R17
;	i -> R17
	RCALL _kirim_add_aprs
; 0000 010F         kirim_ax25_head();
	RCALL _kirim_ax25_head
; 0000 0110         kirim_karakter(TD_STATUS_);
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x26
; 0000 0111 	for(i=0;i<statsize;i++)
	LDI  R17,LOW(0)
_0x41:
	RCALL SUBOPT_0x27
	BRGE _0x42
; 0000 0112         {
; 0000 0113         	if(status[i]!=0)kirim_karakter(status[i]);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	BREQ _0x43
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x1B
; 0000 0114         }
_0x43:
	SUBI R17,-1
	RJMP _0x41
_0x42:
; 0000 0115 }
	RJMP _0x20A0006
;
;void kirim_beacon(void)
; 0000 0118 {
_kirim_beacon:
; 0000 0119 	char i;
; 0000 011A 
; 0000 011B         kirim_add_beacon();
	ST   -Y,R17
;	i -> R17
	RCALL _kirim_add_beacon
; 0000 011C         kirim_ax25_head();
	RCALL _kirim_ax25_head
; 0000 011D         for(i=0;i<statsize;i++)kirim_karakter(status[i]);
	LDI  R17,LOW(0)
_0x45:
	RCALL SUBOPT_0x27
	BRGE _0x46
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x1B
	SUBI R17,-1
	RJMP _0x45
_0x46:
; 0000 011E }
	RJMP _0x20A0006
;
;void prepare(void)
; 0000 0121 {
_prepare:
; 0000 0122 	char i;
; 0000 0123 
; 0000 0124         PTT = 1;
	ST   -Y,R17
;	i -> R17
	SBI  0x18,5
; 0000 0125 	delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x2A
	RCALL _delay_ms
; 0000 0126 	for(i=0;i<TX_DELAY_;i++)kirim_karakter(0x00);
	LDI  R17,LOW(0)
_0x4A:
	CPI  R17,45
	BRGE _0x4B
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x4A
_0x4B:
; 0000 0127 kirim_karakter(0x7E);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x26
; 0000 0128 	bit_stuff = 0;
	RCALL SUBOPT_0x2B
; 0000 0129         crc = 0xFFFF;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	__PUTW1R 7,8
; 0000 012A }
	RJMP _0x20A0006
;
;void kirim_paket(void)
; 0000 012D {
_kirim_paket:
; 0000 012E 	char i;
; 0000 012F 
; 0000 0130         read_temp();
	ST   -Y,R17
;	i -> R17
	RCALL _read_temp
; 0000 0131         read_volt();
	RCALL _read_volt
; 0000 0132         base91_lat();
	RCALL _base91_lat
; 0000 0133         base91_long();
	RCALL _base91_long
; 0000 0134         base91_alt();
	RCALL _base91_alt
; 0000 0135         //altitude+=3;             	// <---------- incremental of altitude
; 0000 0136         //if(altitude>65500)altitude=0;	// <---------- altitude limiter
; 0000 0137 
; 0000 0138         MERAH = 1;
	RCALL SUBOPT_0x2C
; 0000 0139         HIJAU = 0;
; 0000 013A 
; 0000 013B         beacon_stat++;
	INC  R6
; 0000 013C         prepare();
	RCALL _prepare
; 0000 013D         if(beacon_stat==2)
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x50
; 0000 013E         {
; 0000 013F         	kirim_status();
	RJMP _0x18A
; 0000 0140                 goto oke;
; 0000 0141         }
; 0000 0142         if(beacon_stat==3)
_0x50:
	LDI  R30,LOW(3)
	CP   R30,R6
	BRNE _0x52
; 0000 0143         {
; 0000 0144         	kirim_beacon();
	RCALL _kirim_beacon
; 0000 0145                 goto oke;
	RJMP _0x51
; 0000 0146         }
; 0000 0147         if((beacon_stat==1)||((beacon_stat%m_int)!=0))
_0x52:
	LDI  R30,LOW(1)
	CP   R30,R6
	BREQ _0x54
	RCALL SUBOPT_0x2D
	BRNE _0x54
	RJMP _0x53
_0x54:
; 0000 0148         {
; 0000 0149         	kirim_add_aprs();
	RCALL _kirim_add_aprs
; 0000 014A         	kirim_ax25_head();
	RCALL _kirim_ax25_head
; 0000 014B         	kirim_karakter(TD_POSISI_);
	LDI  R30,LOW(61)
	RCALL SUBOPT_0x26
; 0000 014C         	//if(compstat=='Y')
; 0000 014D                 //{
; 0000 014E         		kirim_karakter(SYM_TAB_OVL_);
	LDI  R26,LOW(_SYM_TAB_OVL_)
	LDI  R27,HIGH(_SYM_TAB_OVL_)
	RCALL SUBOPT_0x1B
; 0000 014F         		for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
	LDI  R17,LOW(0)
_0x57:
	CPI  R17,4
	BRGE _0x58
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_comp_lat)
	SBCI R27,HIGH(-_comp_lat)
	RCALL SUBOPT_0x1B
	SUBI R17,-1
	RJMP _0x57
_0x58:
; 0000 0150 for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
	LDI  R17,LOW(0)
_0x5A:
	CPI  R17,4
	BRGE _0x5B
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_comp_long)
	SBCI R27,HIGH(-_comp_long)
	RCALL SUBOPT_0x1B
	SUBI R17,-1
	RJMP _0x5A
_0x5B:
; 0000 0151 kirim_karakter(SYM_CODE_);
	LDI  R26,LOW(_SYM_CODE_)
	LDI  R27,HIGH(_SYM_CODE_)
	RCALL SUBOPT_0x1B
; 0000 0152         		for(i=0;i<3;i++)kirim_karakter(comp_cst[i]);
	LDI  R17,LOW(0)
_0x5D:
	CPI  R17,3
	BRGE _0x5E
	RCALL SUBOPT_0x2E
	SUBI R30,LOW(-_comp_cst)
	SBCI R31,HIGH(-_comp_cst)
	LD   R30,Z
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x5D
_0x5E:
; 0000 0154 if(tempincomm=='Y')
	LDI  R26,LOW(_tempincomm)
	LDI  R27,HIGH(_tempincomm)
	RCALL SUBOPT_0x2F
	BRNE _0x5F
; 0000 0155                 {for(i=0;i<6;i++)if(temp[i]!=' ')kirim_karakter(temp[i]);
	LDI  R17,LOW(0)
_0x61:
	CPI  R17,6
	BRGE _0x62
	RCALL SUBOPT_0x2E
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	LD   R26,Z
	CPI  R26,LOW(0x20)
	BREQ _0x63
	RCALL SUBOPT_0x2E
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	LD   R30,Z
	RCALL SUBOPT_0x26
; 0000 0156                 kirim_karakter(' ');}
_0x63:
	SUBI R17,-1
	RJMP _0x61
_0x62:
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x26
; 0000 0157                 if(battvoltincomm=='Y')
_0x5F:
	LDI  R26,LOW(_battvoltincomm)
	LDI  R27,HIGH(_battvoltincomm)
	RCALL SUBOPT_0x2F
	BRNE _0x64
; 0000 0158                 {for(i=0;i<6;i++)if(volt[i]!=' ')kirim_karakter(volt[i]);
	LDI  R17,LOW(0)
_0x66:
	CPI  R17,6
	BRGE _0x67
	RCALL SUBOPT_0x2E
	SUBI R30,LOW(-_volt)
	SBCI R31,HIGH(-_volt)
	LD   R26,Z
	CPI  R26,LOW(0x20)
	BREQ _0x68
	RCALL SUBOPT_0x2E
	SUBI R30,LOW(-_volt)
	SBCI R31,HIGH(-_volt)
	LD   R30,Z
	RCALL SUBOPT_0x26
; 0000 0159                 kirim_karakter(' ');}
_0x68:
	SUBI R17,-1
	RJMP _0x66
_0x67:
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x26
; 0000 015A                 for(i=0;i<commsize;i++)kirim_karakter(comment[i]);
_0x64:
	LDI  R17,LOW(0)
_0x6A:
	RCALL SUBOPT_0x30
	BRGE _0x6B
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_comment)
	SBCI R27,HIGH(-_comment)
	RCALL SUBOPT_0x1B
	SUBI R17,-1
	RJMP _0x6A
_0x6B:
; 0000 015C goto oke;
	RJMP _0x51
; 0000 015D         }
; 0000 015E         if((beacon_stat%m_int)==0)kirim_status();
_0x53:
	RCALL SUBOPT_0x2D
	BRNE _0x6C
_0x18A:
	RCALL _kirim_status
; 0000 015F 
; 0000 0160         oke:
_0x6C:
_0x51:
; 0000 0161 	kirim_crc();
	RCALL _kirim_crc
; 0000 0162         kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x26
; 0000 0163         kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x26
; 0000 0164         if(beacon_stat==100)beacon_stat=0;
	LDI  R30,LOW(100)
	CP   R30,R6
	BRNE _0x6D
	CLR  R6
; 0000 0165         PTT = 0;
_0x6D:
	CBI  0x18,5
; 0000 0166         MERAH = 0;
	RCALL SUBOPT_0x31
; 0000 0167         HIJAU = 0;
; 0000 0168 }
	RJMP _0x20A0006
;
;void kirim_crc(void)
; 0000 016B {
_kirim_crc:
; 0000 016C 	static unsigned char crc_lo;
; 0000 016D 	static unsigned char crc_hi;
; 0000 016E 
; 0000 016F         crc_lo = crc ^ 0xFF;
	LDI  R30,LOW(255)
	EOR  R30,R7
	STS  _crc_lo_S000000C000,R30
; 0000 0170 	crc_hi = (crc >> 8) ^ 0xFF;
	MOV  R30,R8
	ANDI R31,HIGH(0x0)
	LDI  R26,LOW(255)
	EOR  R30,R26
	STS  _crc_hi_S000000C000,R30
; 0000 0171 	kirim_karakter(crc_lo);
	LDS  R30,_crc_lo_S000000C000
	RCALL SUBOPT_0x26
; 0000 0172 	kirim_karakter(crc_hi);
	LDS  R30,_crc_hi_S000000C000
	RCALL SUBOPT_0x26
; 0000 0173 }
	RET
;
;void kirim_karakter(unsigned char input)
; 0000 0176 {
_kirim_karakter:
	PUSH R15
; 0000 0177 	char i;
; 0000 0178 	bit in_bit;
; 0000 0179 
; 0000 017A         for(i=0;i<8;i++)
	RCALL SUBOPT_0x19
;	input -> Y+1
;	i -> R17
;	in_bit -> R15.0
_0x75:
	CPI  R17,8
	BRGE _0x76
; 0000 017B         {
; 0000 017C         	in_bit = (input >> i) & 0x01;
	MOV  R30,R17
	LDD  R26,Y+1
	RCALL __LSRB12
	BST  R30,0
	BLD  R15,0
; 0000 017D 		if(input==0x7E)	{bit_stuff = 0;}
	CPI  R26,LOW(0x7E)
	BRNE _0x77
	RCALL SUBOPT_0x2B
; 0000 017E 		else		{hitung_crc(in_bit);}
	RJMP _0x78
_0x77:
	LDI  R30,0
	SBRC R15,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _hitung_crc
_0x78:
; 0000 017F 
; 0000 0180 		if(!in_bit)
	SBRS R15,0
; 0000 0181                 {
; 0000 0182                 	ubah_nada();
	RJMP _0x18B
; 0000 0183 			bit_stuff = 0;
; 0000 0184                 }
; 0000 0185                 else
; 0000 0186                 {
; 0000 0187                 	set_nada(nada);
	RCALL SUBOPT_0x32
; 0000 0188 			bit_stuff++;
	LDS  R30,_bit_stuff_G000
	SUBI R30,-LOW(1)
	STS  _bit_stuff_G000,R30
; 0000 0189 			if(bit_stuff==5)
	LDS  R26,_bit_stuff_G000
	CPI  R26,LOW(0x5)
	BRNE _0x7B
; 0000 018A                         {
; 0000 018B                         	ubah_nada();
_0x18B:
	RCALL _ubah_nada
; 0000 018C                                 bit_stuff = 0;
	RCALL SUBOPT_0x2B
; 0000 018D                         }
; 0000 018E                 }
_0x7B:
; 0000 018F         }
	SUBI R17,-1
	RJMP _0x75
_0x76:
; 0000 0190 }
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;void hitung_crc(char in_crc)
; 0000 0193 {
_hitung_crc:
; 0000 0194 	static unsigned short xor_in;
; 0000 0195 	xor_in = crc ^ in_crc;
;	in_crc -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x33
	EOR  R30,R7
	EOR  R31,R8
	STS  _xor_in_S000000E000,R30
	STS  _xor_in_S000000E000+1,R31
; 0000 0196 	crc >>= 1;
	LSR  R8
	ROR  R7
; 0000 0197 	if(xor_in & 0x01)	crc ^= 0x8408;
	LDS  R30,_xor_in_S000000E000
	ANDI R30,LOW(0x1)
	BREQ _0x7C
	LDI  R30,LOW(33800)
	LDI  R31,HIGH(33800)
	__EORWRR 7,8,30,31
; 0000 0198 }
_0x7C:
	RJMP _0x20A0005
;
;void ubah_nada(void)
; 0000 019B {
_ubah_nada:
; 0000 019C 	nada = ~nada;
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 019D         set_nada(nada);
	RCALL SUBOPT_0x32
; 0000 019E }
	RET
;
;void set_nada(char i_nada)
; 0000 01A1 {
_set_nada:
; 0000 01A2 	if(i_nada == _1200)
;	i_nada -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x7D
; 0000 01A3     	{
; 0000 01A4         	delay_us(417);
	RCALL SUBOPT_0x34
; 0000 01A5         	AFOUT = 1;
	SBI  0x18,4
; 0000 01A6         	delay_us(417);
	RCALL SUBOPT_0x34
; 0000 01A7         	AFOUT = 0;
	RJMP _0x18C
; 0000 01A8     	}
; 0000 01A9         else
_0x7D:
; 0000 01AA     	{
; 0000 01AB         	delay_us(208);
	RCALL SUBOPT_0x35
; 0000 01AC         	AFOUT = 1;
; 0000 01AD         	delay_us(209);
; 0000 01AE         	AFOUT = 0;
	CBI  0x18,4
; 0000 01AF                 delay_us(208);
	RCALL SUBOPT_0x35
; 0000 01B0         	AFOUT = 1;
; 0000 01B1         	delay_us(209);
; 0000 01B2         	AFOUT = 0;
_0x18C:
	CBI  0x18,4
; 0000 01B3     	}
; 0000 01B4 }
	RJMP _0x20A0005
;
;unsigned int read_adc(unsigned char adc_input)
; 0000 01B7 {
_read_adc:
; 0000 01B8 	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 01B9 	delay_us(10);
	__DELAY_USB 37
; 0000 01BA 	ADCSRA|=0x40;
	SBI  0x6,6
; 0000 01BB 	while ((ADCSRA & 0x10)==0);
_0x8B:
	SBIS 0x6,4
	RJMP _0x8B
; 0000 01BC 	ADCSRA|=0x10;
	SBI  0x6,4
; 0000 01BD 	return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20A0005
; 0000 01BE }
;
;void waitComma(void)
; 0000 01C1 {
_waitComma:
; 0000 01C2 	while(getchar()!=',');
_0x8E:
	RCALL _getchar
	CPI  R30,LOW(0x2C)
	BRNE _0x8E
; 0000 01C3 }
	RET
;
;void waitDollar(void)
; 0000 01C6 {
_waitDollar:
; 0000 01C7 	while(getchar()!='$');
_0x91:
	RCALL _getchar
	CPI  R30,LOW(0x24)
	BRNE _0x91
; 0000 01C8 }
	RET
;
;void waitInvCo(void)
; 0000 01CB {
_waitInvCo:
; 0000 01CC 	while(getchar()!='"');
_0x94:
	RCALL _getchar
	CPI  R30,LOW(0x22)
	BRNE _0x94
; 0000 01CD }
	RET
;
;void mem_display(void)
; 0000 01D0 {
_mem_display:
; 0000 01D1 	// configuration ECHO
; 0000 01D2         // mycall & SSID
; 0000 01D3         char k;
; 0000 01D4         char f[];
; 0000 01D5 
; 0000 01D6         #asm("cli")
	ST   -Y,R17
;	k -> R17
;	f -> Y+1
	cli
; 0000 01D7 
; 0000 01D8         MERAH=1;
	RCALL SUBOPT_0x2C
; 0000 01D9         HIJAU=0;
; 0000 01DA 
; 0000 01DB         putchar(13);
	RCALL SUBOPT_0x36
; 0000 01DC         putchar(13);putsf("Your ProTrak! model A Configuration is:");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x37
; 0000 01DD         putchar(13);
	RCALL SUBOPT_0x36
; 0000 01DE         putchar(13);putsf("Callsign");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,40
	RCALL SUBOPT_0x37
; 0000 01DF         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 01E0         for(k=0;k<6;k++)if((mycall[k])!=' ')putchar(mycall[k]);
	LDI  R17,LOW(0)
_0x9C:
	CPI  R17,6
	BRGE _0x9D
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1C
	CPI  R30,LOW(0x20)
	BREQ _0x9E
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x3A
; 0000 01E1         if((mycall[6])>'0')
_0x9E:
	SUBI R17,-1
	RJMP _0x9C
_0x9D:
	RCALL SUBOPT_0x1E
	CPI  R30,LOW(0x31)
	BRLO _0x9F
; 0000 01E2         {
; 0000 01E3         	putchar('-');
	RCALL SUBOPT_0x3B
; 0000 01E4                 itoa(mycall[6]-48,f);
	__POINTW2MN _mycall,6
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3C
; 0000 01E5                 puts(f);
; 0000 01E6         }
; 0000 01E7 
; 0000 01E8         // digipath
; 0000 01E9         putchar(13);putsf("Digi Path(s)");
_0x9F:
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,49
	RCALL SUBOPT_0x37
; 0000 01EA         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 01EB         if(mydigi1[0]!=0)
	LDI  R26,LOW(_mydigi1)
	LDI  R27,HIGH(_mydigi1)
	RCALL SUBOPT_0x29
	BREQ _0xA0
; 0000 01EC         {
; 0000 01ED         	for(k=0;k<6;k++)if((mydigi1[k])!=' ')putchar(mydigi1[k]);
	LDI  R17,LOW(0)
_0xA2:
	CPI  R17,6
	BRGE _0xA3
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1F
	CPI  R30,LOW(0x20)
	BREQ _0xA4
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x3A
; 0000 01EE         	if(mydigi1[6]>'0')
_0xA4:
	SUBI R17,-1
	RJMP _0xA2
_0xA3:
	RCALL SUBOPT_0x20
	CPI  R30,LOW(0x31)
	BRLO _0xA5
; 0000 01EF         	{
; 0000 01F0         		putchar('-');
	RCALL SUBOPT_0x3B
; 0000 01F1                         itoa(mydigi1[6]-48,f);
	__POINTW2MN _mydigi1,6
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3C
; 0000 01F2                         puts(f);
; 0000 01F3         	}
; 0000 01F4         }
_0xA5:
; 0000 01F5         if(mydigi2[0]!=0)
_0xA0:
	LDI  R26,LOW(_mydigi2)
	LDI  R27,HIGH(_mydigi2)
	RCALL SUBOPT_0x29
	BREQ _0xA6
; 0000 01F6         {
; 0000 01F7         	putchar(',');
	LDI  R30,LOW(44)
	RCALL SUBOPT_0x3A
; 0000 01F8         	for(k=0;k<6;k++)if((mydigi2[k])!=' ')putchar(mydigi2[k]);
	LDI  R17,LOW(0)
_0xA8:
	CPI  R17,6
	BRGE _0xA9
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x21
	CPI  R30,LOW(0x20)
	BREQ _0xAA
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x3A
; 0000 01F9         	if(mydigi2[6]>'0')
_0xAA:
	SUBI R17,-1
	RJMP _0xA8
_0xA9:
	RCALL SUBOPT_0x22
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x31)
	BRLO _0xAB
; 0000 01FA         	{
; 0000 01FB         		putchar('-');
	RCALL SUBOPT_0x3B
; 0000 01FC                         itoa(mydigi2[6]-48,f);
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3C
; 0000 01FD                         puts(f);
; 0000 01FE         	}
; 0000 01FF         }
_0xAB:
; 0000 0200         if(mydigi3[0]!=0)
_0xA6:
	LDI  R26,LOW(_mydigi3)
	LDI  R27,HIGH(_mydigi3)
	RCALL SUBOPT_0x29
	BREQ _0xAC
; 0000 0201         {
; 0000 0202         	putchar(',');
	LDI  R30,LOW(44)
	RCALL SUBOPT_0x3A
; 0000 0203         	for(k=0;k<6;k++)if((mydigi3[k])!=' ')putchar(mydigi3[k]);
	LDI  R17,LOW(0)
_0xAE:
	CPI  R17,6
	BRGE _0xAF
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x23
	CPI  R30,LOW(0x20)
	BREQ _0xB0
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x23
	RCALL SUBOPT_0x3A
; 0000 0204         	if(mydigi3[6]>'0')
_0xB0:
	SUBI R17,-1
	RJMP _0xAE
_0xAF:
	RCALL SUBOPT_0x24
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x31)
	BRLO _0xB1
; 0000 0205         	{
; 0000 0206         		putchar('-');
	RCALL SUBOPT_0x3B
; 0000 0207                         itoa(mydigi3[6]-48,f);
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3C
; 0000 0208                         puts(f);
; 0000 0209         	}
; 0000 020A         }
_0xB1:
; 0000 020B 
; 0000 020C         // beacon interval
; 0000 020D         putchar(13);putsf("TX Interval");
_0xAC:
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,62
	RCALL SUBOPT_0x37
; 0000 020E         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 020F         itoa(timeIntv,f);
	RCALL SUBOPT_0x3D
	RCALL SUBOPT_0x3E
; 0000 0210         puts(f);
; 0000 0211         putchar(' ');putsf("second(s)");
	__POINTW1FN _0x0,74
	RCALL SUBOPT_0x37
; 0000 0212         if(timeIntv>9999)putsf(" is too long");
	RCALL SUBOPT_0x3D
	CPI  R30,LOW(0x2710)
	LDI  R26,HIGH(0x2710)
	CPC  R31,R26
	BRLT _0xB2
	__POINTW1FN _0x0,84
	RCALL SUBOPT_0x37
; 0000 0213 
; 0000 0214         // symbol code / icon
; 0000 0215         putchar(13);putsf("Symbol / Icon");
_0xB2:
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,97
	RCALL SUBOPT_0x37
; 0000 0216         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 0217         putchar(SYM_CODE_);
	LDI  R26,LOW(_SYM_CODE_)
	LDI  R27,HIGH(_SYM_CODE_)
	RCALL SUBOPT_0x3F
; 0000 0218 
; 0000 0219         // symbol table / overlay
; 0000 021A         putchar(13);putsf("Symbol Table / Overlay");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,111
	RCALL SUBOPT_0x37
; 0000 021B         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 021C         putchar(SYM_TAB_OVL_);
	LDI  R26,LOW(_SYM_TAB_OVL_)
	LDI  R27,HIGH(_SYM_TAB_OVL_)
	RCALL SUBOPT_0x3F
; 0000 021D 
; 0000 021E         // comment
; 0000 021F         putchar(13);putsf("Comment");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,134
	RCALL SUBOPT_0x37
; 0000 0220         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 0221         for(k=0;k<commsize;k++)
	LDI  R17,LOW(0)
_0xB4:
	RCALL SUBOPT_0x30
	BRGE _0xB5
; 0000 0222         {
; 0000 0223         	if(comment[k]!=0)putchar(comment[k]);
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_comment)
	SBCI R27,HIGH(-_comment)
	RCALL SUBOPT_0x29
	BREQ _0xB6
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_comment)
	SBCI R27,HIGH(-_comment)
	RCALL SUBOPT_0x3F
; 0000 0224         }
_0xB6:
	SUBI R17,-1
	RJMP _0xB4
_0xB5:
; 0000 0225 
; 0000 0226         // status
; 0000 0227         putchar(13);putsf("Status");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,142
	RCALL SUBOPT_0x37
; 0000 0228         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 0229         for(k=0;k<statsize;k++)
	LDI  R17,LOW(0)
_0xB8:
	RCALL SUBOPT_0x27
	BRGE _0xB9
; 0000 022A         {
; 0000 022B         	if(status[k]!=0)putchar(status[k]);
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x29
	BREQ _0xBA
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x28
	RCALL SUBOPT_0x3F
; 0000 022C         }
_0xBA:
	SUBI R17,-1
	RJMP _0xB8
_0xB9:
; 0000 022D 
; 0000 022E         // status interval
; 0000 022F         putchar(13);putsf("Status Interval");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,149
	RCALL SUBOPT_0x37
; 0000 0230         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 0231         itoa(m_int,f);
	LDI  R26,LOW(_m_int)
	LDI  R27,HIGH(_m_int)
	RCALL __EEPROMRDW
	RCALL SUBOPT_0x3E
; 0000 0232         puts(f);
; 0000 0233         putchar(' ');putsf("transmission(s)");
	__POINTW1FN _0x0,165
	RCALL SUBOPT_0x37
; 0000 0234         if(m_int>99)putsf(" is too long");
	LDI  R26,LOW(_m_int)
	LDI  R27,HIGH(_m_int)
	RCALL __EEPROMRDW
	CPI  R30,LOW(0x64)
	LDI  R26,HIGH(0x64)
	CPC  R31,R26
	BRLT _0xBB
	__POINTW1FN _0x0,84
	RCALL SUBOPT_0x37
; 0000 0235 
; 0000 0236         // BASE-91 Comppresion ?
; 0000 0237         putchar(13);putsf("BASE-91 ? (Y/N)");
_0xBB:
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,181
	RCALL SUBOPT_0x37
; 0000 0238         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 0239         putchar(compstat);
	LDI  R26,LOW(_compstat)
	LDI  R27,HIGH(_compstat)
	RCALL SUBOPT_0x3F
; 0000 023A 
; 0000 023B         // Coordinate
; 0000 023C         putchar(13);putsf("NO GPS Coordinate");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,197
	RCALL SUBOPT_0x37
; 0000 023D         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 023E         for(k=0;k<10;k++)putchar(posisi_lat[k]);
	LDI  R17,LOW(0)
_0xBD:
	CPI  R17,10
	BRGE _0xBE
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_posisi_lat)
	SBCI R27,HIGH(-_posisi_lat)
	RCALL SUBOPT_0x3F
	SUBI R17,-1
	RJMP _0xBD
_0xBE:
; 0000 023F putchar(',');
	LDI  R30,LOW(44)
	RCALL SUBOPT_0x3A
; 0000 0240         for(k=0;k<11;k++)putchar(posisi_long[k]);
	LDI  R17,LOW(0)
_0xC0:
	CPI  R17,11
	BRGE _0xC1
	RCALL SUBOPT_0x1A
	SUBI R26,LOW(-_posisi_long)
	SBCI R27,HIGH(-_posisi_long)
	RCALL SUBOPT_0x3F
	SUBI R17,-1
	RJMP _0xC0
_0xC1:
; 0000 0243 putchar(13);putsf("Use GPS ? (Y/N)");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,215
	RCALL SUBOPT_0x37
; 0000 0244         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 0245         putchar(gps);
	LDI  R26,LOW(_gps)
	LDI  R27,HIGH(_gps)
	RCALL SUBOPT_0x3F
; 0000 0246 
; 0000 0247         // battery volt
; 0000 0248         putchar(13);putsf("Diplay Battery Voltage in Comment ? (Y/N)");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,231
	RCALL SUBOPT_0x37
; 0000 0249         putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 024A         putchar(battvoltincomm);
	LDI  R26,LOW(_battvoltincomm)
	LDI  R27,HIGH(_battvoltincomm)
	RCALL SUBOPT_0x3F
; 0000 024B 
; 0000 024C         // temperature
; 0000 024D         putchar(13);putsf("Diplay Temperature in Comment ? (Y/N)");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,273
	RCALL SUBOPT_0x37
; 0000 024E         putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 024F         putchar(tempincomm);
	LDI  R26,LOW(_tempincomm)
	LDI  R27,HIGH(_tempincomm)
	RCALL SUBOPT_0x3F
; 0000 0250 
; 0000 0251         // altitude
; 0000 0252         putchar(13);putsf("Send Altitude ? (Y/N)");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,311
	RCALL SUBOPT_0x37
; 0000 0253         putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 0254         putchar(sendalt);
	LDI  R26,LOW(_sendalt)
	LDI  R27,HIGH(_sendalt)
	RCALL SUBOPT_0x3F
; 0000 0255 
; 0000 0256         // send to PC
; 0000 0257         putchar(13);putsf("Send Temperature and Battery Voltage to PC ? (Y/N)");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,333
	RCALL SUBOPT_0x37
; 0000 0258         putchar(9);putchar(':');
	RCALL SUBOPT_0x38
	RCALL SUBOPT_0x39
; 0000 0259         putchar(sendtopc);
	LDI  R26,LOW(_sendtopc)
	LDI  R27,HIGH(_sendtopc)
	RCALL SUBOPT_0x3F
; 0000 025A 
; 0000 025B         MERAH=0;
	RCALL SUBOPT_0x31
; 0000 025C         HIJAU=0;
; 0000 025D 
; 0000 025E         #asm("sei")
	sei
; 0000 025F }
_0x20A0006:
	LD   R17,Y+
	RET
;
;void config(void)
; 0000 0262 {
_config:
; 0000 0263 	char buffer[500];
; 0000 0264         char dbuff[];
; 0000 0265         char cbuff[];
; 0000 0266         char ibuff[5];
; 0000 0267         int b,j,k,l;
; 0000 0268 
; 0000 0269         #asm("cli")
	SBIW R28,63
	SBIW R28,63
	SBIW R28,63
	SBIW R28,62
	SUBI R29,1
	RCALL __SAVELOCR6
;	buffer -> Y+13
;	dbuff -> Y+13
;	cbuff -> Y+13
;	ibuff -> Y+8
;	b -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
;	l -> Y+6
	cli
; 0000 026A 
; 0000 026B         MERAH=1;
	RCALL SUBOPT_0x2C
; 0000 026C         HIJAU=0;
; 0000 026D 
; 0000 026E         b=0;
	RCALL SUBOPT_0x40
; 0000 026F 
; 0000 0270         putchar(13);putsf("ENTERING CONFIGURATION MODE...");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,384
	RCALL SUBOPT_0x37
; 0000 0271         putchar(13);putsf("CONFIGURE...");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,415
	RCALL SUBOPT_0x37
; 0000 0272 
; 0000 0273         // download configuration file
; 0000 0274         waitDollar();
	RCALL _waitDollar
; 0000 0275         waitInvCo();
	RCALL _waitInvCo
; 0000 0276         for(;;)
_0xCB:
; 0000 0277         {
; 0000 0278         	buffer[b]=getchar();
	MOVW R30,R16
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x42
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0279                 if(buffer[b]=='$')goto rxd_selesai;
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x24)
	BREQ _0xCE
; 0000 027A                 if(buffer[b]=='"')waitInvCo();
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BRNE _0xCF
	RCALL _waitInvCo
; 0000 027B                 putchar('.');
_0xCF:
	LDI  R30,LOW(46)
	RCALL SUBOPT_0x3A
; 0000 027C                 b++;
	RCALL SUBOPT_0x44
; 0000 027D         }
	RJMP _0xCB
; 0000 027E         rxd_selesai:
_0xCE:
; 0000 027F         // config file downloaded
; 0000 0280         //j=b;
; 0000 0281 
; 0000 0282         putchar(13);putsf("SAVING CONFIGURATION...");
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,428
	RCALL SUBOPT_0x37
; 0000 0283 
; 0000 0284         // mycall
; 0000 0285         b=0;
	RCALL SUBOPT_0x40
; 0000 0286         k=0;
	RCALL SUBOPT_0x45
; 0000 0287         while(buffer[b]!='"') 				//<--- move data from rxbuffer to databuffer
_0xD0:
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BREQ _0xD2
; 0000 0288         {
; 0000 0289         	cbuff[k]=buffer[b];
	RCALL SUBOPT_0x46
; 0000 028A                 k++;
; 0000 028B                 b++;
; 0000 028C         }
	RJMP _0xD0
_0xD2:
; 0000 028D         j=b+1; 						// j = index , atau "   j+b = index next data field
	RCALL SUBOPT_0x47
; 0000 028E 
; 0000 028F         // pada titik ini, k adalah ukuran array 1st digi string
; 0000 0290         l=k;
; 0000 0291         for(k=0;k<6;k++)mycall[k]=' '; 			//<--- resetting mycall
_0xD4:
	__CPWRN 20,21,6
	BRGE _0xD5
	LDI  R26,LOW(_mycall)
	LDI  R27,HIGH(_mycall)
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	RJMP _0xD4
_0xD5:
; 0000 0292 mycall[6]='0';
	__POINTW2MN _mycall,6
	RCALL SUBOPT_0x4B
; 0000 0293         for(k=0;k<l;k++)
	RCALL SUBOPT_0x45
_0xD7:
	RCALL SUBOPT_0x4C
	BRGE _0xD8
; 0000 0294         {
; 0000 0295         	if(cbuff[k]=='-')
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x4E
	BRNE _0xD9
; 0000 0296                 {
; 0000 0297                 	if((l-k)==2)
	RCALL SUBOPT_0x4F
	SBIW R26,2
	BRNE _0xDA
; 0000 0298                         {
; 0000 0299                         	mycall[6]=cbuff[k+1];
	__POINTW1MN _mycall,6
	RCALL SUBOPT_0x50
; 0000 029A                                 goto selesai_mycall;
	RJMP _0xDB
; 0000 029B                         }
; 0000 029C                         else if((l-k)==3)
_0xDA:
	RCALL SUBOPT_0x4F
	SBIW R26,3
	BRNE _0xDD
; 0000 029D                         {
; 0000 029E                         	mycall[6]=((10*(cbuff[k+1]-48)+cbuff[k+2]-48)+48);
	__POINTWRMN 22,23,_mycall,6
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
; 0000 029F                         	goto selesai_mycall;
	RJMP _0xDB
; 0000 02A0                         }
; 0000 02A1                 }
_0xDD:
; 0000 02A2                 mycall[k]=cbuff[k];
_0xD9:
	MOVW R30,R20
	SUBI R30,LOW(-_mycall)
	SBCI R31,HIGH(-_mycall)
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x54
; 0000 02A3         }
	RCALL SUBOPT_0x4A
	RJMP _0xD7
_0xD8:
; 0000 02A4         selesai_mycall:
_0xDB:
; 0000 02A5 
; 0000 02A6         //1st digi
; 0000 02A7         b=j;
	RCALL SUBOPT_0x55
; 0000 02A8         k=0;
; 0000 02A9         while((buffer[b]!='"')&&(buffer[b]!=',')) 	//<--- move data from rxbuffer to databuffer
_0xDE:
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BREQ _0xE1
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x2C)
	BRNE _0xE2
_0xE1:
	RJMP _0xE0
_0xE2:
; 0000 02AA         {
; 0000 02AB         	dbuff[k]=buffer[b];
	RCALL SUBOPT_0x46
; 0000 02AC                 k++;
; 0000 02AD                 b++;
; 0000 02AE         }
	RJMP _0xDE
_0xE0:
; 0000 02AF         j=b+1; 						// j = index , atau "   j+b = index next data field
	RCALL SUBOPT_0x47
; 0000 02B0 
; 0000 02B1         // pada titik ini, k adalah ukuran array 1st digi string
; 0000 02B2         l=k;
; 0000 02B3         for(k=0;k<6;k++)mydigi1[k]=' '; 		//<--- resetting digi call
_0xE4:
	__CPWRN 20,21,6
	BRGE _0xE5
	LDI  R26,LOW(_mydigi1)
	LDI  R27,HIGH(_mydigi1)
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	RJMP _0xE4
_0xE5:
; 0000 02B4 for(k=0;k<7;k++)mydigi2[k]=' ';
	RCALL SUBOPT_0x45
_0xE7:
	__CPWRN 20,21,7
	BRGE _0xE8
	LDI  R26,LOW(_mydigi2)
	LDI  R27,HIGH(_mydigi2)
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	RJMP _0xE7
_0xE8:
; 0000 02B5 for(k=0;k<7;k++)mydigi3[k]=' ';
	RCALL SUBOPT_0x45
_0xEA:
	__CPWRN 20,21,7
	BRGE _0xEB
	LDI  R26,LOW(_mydigi3)
	LDI  R27,HIGH(_mydigi3)
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	RJMP _0xEA
_0xEB:
; 0000 02B6 mydigi1[6]='0';
	__POINTW2MN _mydigi1,6
	RCALL SUBOPT_0x4B
; 0000 02B7         mydigi2[6]='0';
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x4B
; 0000 02B8         mydigi3[6]='0';
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x4B
; 0000 02B9         mydigi1[0]=0;
	LDI  R26,LOW(_mydigi1)
	LDI  R27,HIGH(_mydigi1)
	RCALL SUBOPT_0x56
; 0000 02BA         mydigi2[0]=0;
	LDI  R26,LOW(_mydigi2)
	LDI  R27,HIGH(_mydigi2)
	RCALL SUBOPT_0x56
; 0000 02BB         mydigi3[0]=0;
	LDI  R26,LOW(_mydigi3)
	LDI  R27,HIGH(_mydigi3)
	RCALL SUBOPT_0x56
; 0000 02BC         if(l<2)goto time_interval;			//<--- jika tidak menggunakan digi
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BRGE _0xEC
	RJMP _0xED
; 0000 02BD         for(k=0;k<l;k++)
_0xEC:
	RCALL SUBOPT_0x45
_0xEF:
	RCALL SUBOPT_0x4C
	BRGE _0xF0
; 0000 02BE         {
; 0000 02BF         	if(dbuff[k]=='-')
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x4E
	BRNE _0xF1
; 0000 02C0                 {
; 0000 02C1                 	if((l-k)==2)
	RCALL SUBOPT_0x4F
	SBIW R26,2
	BRNE _0xF2
; 0000 02C2                         {
; 0000 02C3                         	mydigi1[6]=dbuff[k+1];
	__POINTW1MN _mydigi1,6
	RCALL SUBOPT_0x50
; 0000 02C4                                 goto selesai_myssid1;
	RJMP _0xF3
; 0000 02C5                         }
; 0000 02C6                         else if((l-k)==3)
_0xF2:
	RCALL SUBOPT_0x4F
	SBIW R26,3
	BRNE _0xF5
; 0000 02C7                         {
; 0000 02C8                         	mydigi1[6]=(10*(dbuff[k+1]-48)+dbuff[k+2]-48)+48;
	__POINTWRMN 22,23,_mydigi1,6
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
; 0000 02C9                         	goto selesai_myssid1;
	RJMP _0xF3
; 0000 02CA                         }
; 0000 02CB                 }
_0xF5:
; 0000 02CC                 mydigi1[k]=dbuff[k];
_0xF1:
	MOVW R30,R20
	SUBI R30,LOW(-_mydigi1)
	SBCI R31,HIGH(-_mydigi1)
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x54
; 0000 02CD         }
	RCALL SUBOPT_0x4A
	RJMP _0xEF
_0xF0:
; 0000 02CE         selesai_myssid1:
_0xF3:
; 0000 02CF         if(buffer[b]=='"')goto time_interval;
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BRNE _0xF6
	RJMP _0xED
; 0000 02D0 
; 0000 02D1 	// 2nd digi
; 0000 02D2         b=j;
_0xF6:
	RCALL SUBOPT_0x55
; 0000 02D3         k=0;
; 0000 02D4         while((buffer[b]!='"')&&(buffer[b]!=',')) //<--- move data from rxbuffer to databuffer
_0xF7:
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BREQ _0xFA
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x2C)
	BRNE _0xFB
_0xFA:
	RJMP _0xF9
_0xFB:
; 0000 02D5         {
; 0000 02D6         	dbuff[k]=buffer[b];
	RCALL SUBOPT_0x46
; 0000 02D7                 k++;
; 0000 02D8                 b++;
; 0000 02D9         }
	RJMP _0xF7
_0xF9:
; 0000 02DA         j=b+1; 		// j = index , atau "   j+b = index next data field
	RCALL SUBOPT_0x47
; 0000 02DB 
; 0000 02DC         // pada titik ini, k adalah ukuran array 2nd digi string
; 0000 02DD         l=k;
; 0000 02DE         for(k=0;k<l;k++)
_0xFD:
	RCALL SUBOPT_0x4C
	BRGE _0xFE
; 0000 02DF         {
; 0000 02E0         	if(dbuff[k]=='-')
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x4E
	BRNE _0xFF
; 0000 02E1                 {
; 0000 02E2                 	if((l-k)==2)
	RCALL SUBOPT_0x4F
	SBIW R26,2
	BRNE _0x100
; 0000 02E3                         {
; 0000 02E4                         	mydigi2[6]=dbuff[k+1];
	__POINTW1MN _mydigi2,6
	RCALL SUBOPT_0x50
; 0000 02E5                                 goto selesai_myssid2;
	RJMP _0x101
; 0000 02E6                         }
; 0000 02E7                         else if((l-k)==3)
_0x100:
	RCALL SUBOPT_0x4F
	SBIW R26,3
	BRNE _0x103
; 0000 02E8                         {
; 0000 02E9                         	mydigi2[6]=(10*(dbuff[k+1]-48)+dbuff[k+2]-48)+48;
	__POINTWRMN 22,23,_mydigi2,6
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
; 0000 02EA                         	goto selesai_myssid2;
	RJMP _0x101
; 0000 02EB                         }
; 0000 02EC                 }
_0x103:
; 0000 02ED                 mydigi2[k]=dbuff[k];
_0xFF:
	MOVW R30,R20
	SUBI R30,LOW(-_mydigi2)
	SBCI R31,HIGH(-_mydigi2)
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x54
; 0000 02EE         }
	RCALL SUBOPT_0x4A
	RJMP _0xFD
_0xFE:
; 0000 02EF         selesai_myssid2:
_0x101:
; 0000 02F0 	if(buffer[b]=='"')goto time_interval;
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BREQ _0xED
; 0000 02F1 
; 0000 02F2         // 3rd digi
; 0000 02F3        	b=j;
	RCALL SUBOPT_0x55
; 0000 02F4         k=0;
; 0000 02F5         while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
_0x105:
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BREQ _0x107
; 0000 02F6         {
; 0000 02F7         	dbuff[k]=buffer[b];
	RCALL SUBOPT_0x46
; 0000 02F8                 k++;
; 0000 02F9                 b++;
; 0000 02FA         }
	RJMP _0x105
_0x107:
; 0000 02FB         j=b+1; 		// b = index , atau "   j+1 = index next data field
	RCALL SUBOPT_0x47
; 0000 02FC 
; 0000 02FD         // pada titik ini, k adalah ukuran array 3rd digi string
; 0000 02FE         l=k;
; 0000 02FF         for(k=0;k<l;k++)
_0x109:
	RCALL SUBOPT_0x4C
	BRGE _0x10A
; 0000 0300         {
; 0000 0301         	if(dbuff[k]=='-')
	RCALL SUBOPT_0x4D
	RCALL SUBOPT_0x4E
	BRNE _0x10B
; 0000 0302                 {
; 0000 0303                 	if((l-k)==2)
	RCALL SUBOPT_0x4F
	SBIW R26,2
	BRNE _0x10C
; 0000 0304                         {
; 0000 0305                         	mydigi3[6]=dbuff[k+1];
	__POINTW1MN _mydigi3,6
	RCALL SUBOPT_0x50
; 0000 0306                                 goto selesai_myssid3;
	RJMP _0x10D
; 0000 0307                         }
; 0000 0308                         else if((l-k)==3)
_0x10C:
	RCALL SUBOPT_0x4F
	SBIW R26,3
	BRNE _0x10F
; 0000 0309                         {
; 0000 030A                         	mydigi3[6]=(10*(dbuff[k+1]-48)+dbuff[k+2]-48)+48;
	__POINTWRMN 22,23,_mydigi3,6
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
; 0000 030B                         	goto selesai_myssid3;
	RJMP _0x10D
; 0000 030C                         }
; 0000 030D                 }
_0x10F:
; 0000 030E                 mydigi3[k]=dbuff[k];
_0x10B:
	MOVW R30,R20
	SUBI R30,LOW(-_mydigi3)
	SBCI R31,HIGH(-_mydigi3)
	RCALL SUBOPT_0x53
	RCALL SUBOPT_0x54
; 0000 030F         }
	RCALL SUBOPT_0x4A
	RJMP _0x109
_0x10A:
; 0000 0310         selesai_myssid3:
_0x10D:
; 0000 0311 
; 0000 0312         time_interval:
_0xED:
; 0000 0313         //time interval
; 0000 0314         b=j;
	RCALL SUBOPT_0x55
; 0000 0315         for(k=0;k<sizeof(ibuff);k++)ibuff[k]=0;
_0x111:
	__CPWRN 20,21,5
	BRGE _0x112
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x48
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL SUBOPT_0x4A
	RJMP _0x111
_0x112:
; 0000 0316 k=0;
	RCALL SUBOPT_0x45
; 0000 0317         while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
_0x113:
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BREQ _0x115
; 0000 0318         {
; 0000 0319         	ibuff[k]=buffer[b];
	RCALL SUBOPT_0x58
; 0000 031A                 k++;
; 0000 031B                 b++;
	RCALL SUBOPT_0x44
; 0000 031C         }
	RJMP _0x113
_0x115:
; 0000 031D         j=b+1;
	RCALL SUBOPT_0x59
; 0000 031E         timeIntv=atoi(ibuff);
	RCALL SUBOPT_0x5A
	LDI  R26,LOW(_timeIntv)
	LDI  R27,HIGH(_timeIntv)
	RCALL SUBOPT_0x5B
; 0000 031F 
; 0000 0320         //symbol code
; 0000 0321         b=j;
; 0000 0322         SYM_CODE_=buffer[b];
	LDI  R26,LOW(_SYM_CODE_)
	LDI  R27,HIGH(_SYM_CODE_)
	RCALL SUBOPT_0x5C
; 0000 0323         j=b+2;
; 0000 0324 
; 0000 0325         //symbol table
; 0000 0326         b=j;
	RCALL SUBOPT_0x5D
; 0000 0327         SYM_TAB_OVL_=buffer[b];
	LDI  R26,LOW(_SYM_TAB_OVL_)
	LDI  R27,HIGH(_SYM_TAB_OVL_)
	RCALL SUBOPT_0x5C
; 0000 0328         j=b+2;
; 0000 0329 
; 0000 032A         //comment
; 0000 032B         b=j;
	RCALL SUBOPT_0x55
; 0000 032C         for(k=0;k<commsize;k++)comment[k]=0;
_0x117:
	LDI  R26,LOW(_commsize)
	LDI  R27,HIGH(_commsize)
	RCALL SUBOPT_0x5E
	BRGE _0x118
	LDI  R26,LOW(_comment)
	LDI  R27,HIGH(_comment)
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x4A
	RJMP _0x117
_0x118:
; 0000 032D k=0;
	RCALL SUBOPT_0x45
; 0000 032E         while(buffer[b]!='"')
_0x119:
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BREQ _0x11B
; 0000 032F         {
; 0000 0330         	comment[k]=buffer[b];
	MOVW R30,R20
	SUBI R30,LOW(-_comment)
	SBCI R31,HIGH(-_comment)
	RCALL SUBOPT_0x5F
; 0000 0331                 k++;
	RCALL SUBOPT_0x4A
; 0000 0332                 b++;
	RCALL SUBOPT_0x44
; 0000 0333                 commsize=k;
	MOV  R30,R20
	LDI  R26,LOW(_commsize)
	LDI  R27,HIGH(_commsize)
	RCALL __EEPROMWRB
; 0000 0334         }
	RJMP _0x119
_0x11B:
; 0000 0335         j=b+1;
	RCALL SUBOPT_0x59
; 0000 0336 
; 0000 0337         //status
; 0000 0338         b=j;
	RCALL SUBOPT_0x55
; 0000 0339         for(k=0;k<statsize;k++)status[k]=0;
_0x11D:
	LDI  R26,LOW(_statsize)
	LDI  R27,HIGH(_statsize)
	RCALL SUBOPT_0x5E
	BRGE _0x11E
	LDI  R26,LOW(_status)
	LDI  R27,HIGH(_status)
	RCALL SUBOPT_0x48
	RCALL SUBOPT_0x56
	RCALL SUBOPT_0x4A
	RJMP _0x11D
_0x11E:
; 0000 033A k=0;
	RCALL SUBOPT_0x45
; 0000 033B         while(buffer[b]!='"')
_0x11F:
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BREQ _0x121
; 0000 033C         {
; 0000 033D         	status[k]=buffer[b];
	MOVW R30,R20
	SUBI R30,LOW(-_status)
	SBCI R31,HIGH(-_status)
	RCALL SUBOPT_0x5F
; 0000 033E                 k++;
	RCALL SUBOPT_0x4A
; 0000 033F                 b++;
	RCALL SUBOPT_0x44
; 0000 0340                 statsize=k;
	MOV  R30,R20
	LDI  R26,LOW(_statsize)
	LDI  R27,HIGH(_statsize)
	RCALL __EEPROMWRB
; 0000 0341         }
	RJMP _0x11F
_0x121:
; 0000 0342         j=b+1;
	RCALL SUBOPT_0x59
; 0000 0343 
; 0000 0344         //status interval
; 0000 0345         b=j;
	RCALL SUBOPT_0x55
; 0000 0346         for(k=0;k<sizeof(ibuff);k++)ibuff[k]=0;
_0x123:
	__CPWRN 20,21,5
	BRGE _0x124
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x48
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL SUBOPT_0x4A
	RJMP _0x123
_0x124:
; 0000 0347 k=0;
	RCALL SUBOPT_0x45
; 0000 0348         while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
_0x125:
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BREQ _0x127
; 0000 0349         {
; 0000 034A         	ibuff[k]=buffer[b];
	RCALL SUBOPT_0x58
; 0000 034B                 k++;
; 0000 034C                 b++;
	RCALL SUBOPT_0x44
; 0000 034D         }
	RJMP _0x125
_0x127:
; 0000 034E         j=b+1;
	RCALL SUBOPT_0x59
; 0000 034F         m_int=atoi(ibuff);
	RCALL SUBOPT_0x5A
	LDI  R26,LOW(_m_int)
	LDI  R27,HIGH(_m_int)
	RCALL SUBOPT_0x5B
; 0000 0350 
; 0000 0351         //BASE-91 compression
; 0000 0352         b=j;
; 0000 0353         compstat=buffer[b];
	LDI  R26,LOW(_compstat)
	LDI  R27,HIGH(_compstat)
	RCALL SUBOPT_0x5C
; 0000 0354         j=b+2;
; 0000 0355 
; 0000 0356         //set latitude
; 0000 0357         b=j;
	MOVW R16,R18
; 0000 0358         if(buffer[b]=='"')goto usegps;
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BREQ _0x129
; 0000 0359         k=0;
	RCALL SUBOPT_0x45
; 0000 035A         while(buffer[b]!=',')
_0x12A:
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x2C)
	BREQ _0x12C
; 0000 035B         {
; 0000 035C         	posisi_lat[k]=buffer[b];
	MOVW R30,R20
	SUBI R30,LOW(-_posisi_lat)
	SBCI R31,HIGH(-_posisi_lat)
	RCALL SUBOPT_0x5F
; 0000 035D                 k++;
	RCALL SUBOPT_0x4A
; 0000 035E                 b++;
	RCALL SUBOPT_0x44
; 0000 035F         }
	RJMP _0x12A
_0x12C:
; 0000 0360         j=b+1;
	RCALL SUBOPT_0x59
; 0000 0361 
; 0000 0362         //set longitude
; 0000 0363         b=j;
	RCALL SUBOPT_0x55
; 0000 0364         k=0;
; 0000 0365         while(buffer[b]!='"')
_0x12D:
	RCALL SUBOPT_0x43
	CPI  R26,LOW(0x22)
	BREQ _0x12F
; 0000 0366         {
; 0000 0367         	posisi_long[k]=buffer[b];
	MOVW R30,R20
	SUBI R30,LOW(-_posisi_long)
	SBCI R31,HIGH(-_posisi_long)
	RCALL SUBOPT_0x5F
; 0000 0368                 k++;
	RCALL SUBOPT_0x4A
; 0000 0369                 b++;
	RCALL SUBOPT_0x44
; 0000 036A         }
	RJMP _0x12D
_0x12F:
; 0000 036B         j=b+1;
	RCALL SUBOPT_0x59
; 0000 036C 
; 0000 036D         usegps:
_0x129:
; 0000 036E         //use GPS ?
; 0000 036F         b=j;
	RCALL SUBOPT_0x5D
; 0000 0370         gps=buffer[b];
	LDI  R26,LOW(_gps)
	LDI  R27,HIGH(_gps)
	RCALL SUBOPT_0x5C
; 0000 0371         j=b+2;
; 0000 0372 
; 0000 0373         // battery voltage in comment ?
; 0000 0374         b=j;
	RCALL SUBOPT_0x5D
; 0000 0375         battvoltincomm=buffer[b];
	LDI  R26,LOW(_battvoltincomm)
	LDI  R27,HIGH(_battvoltincomm)
	RCALL SUBOPT_0x5C
; 0000 0376         j=b+2;
; 0000 0377 
; 0000 0378         // temperature in comment ?
; 0000 0379         b=j;
	RCALL SUBOPT_0x5D
; 0000 037A         tempincomm=buffer[b];
	LDI  R26,LOW(_tempincomm)
	LDI  R27,HIGH(_tempincomm)
	RCALL SUBOPT_0x5C
; 0000 037B         j=b+2;
; 0000 037C 
; 0000 037D         // send altitude ?
; 0000 037E         b=j;
	RCALL SUBOPT_0x5D
; 0000 037F         sendalt=buffer[b];
	LDI  R26,LOW(_sendalt)
	LDI  R27,HIGH(_sendalt)
	RCALL SUBOPT_0x5C
; 0000 0380         j=b+2;
; 0000 0381 
; 0000 0382         // send to PC ?
; 0000 0383         b=j;
	RCALL SUBOPT_0x5D
; 0000 0384         sendtopc=buffer[b];
	LDI  R26,LOW(_sendtopc)
	LDI  R27,HIGH(_sendtopc)
	RCALL __EEPROMWRB
; 0000 0385         //j=b+2;
; 0000 0386 
; 0000 0387         //ProTrak! model A configuration ends here
; 0000 0388 
; 0000 0389         // EHCOING
; 0000 038A         mem_display();
	RCALL _mem_display
; 0000 038B 
; 0000 038C         //ProTrak! model A+ configuration ends here
; 0000 038D 
; 0000 038E         MERAH=0;
	RCALL SUBOPT_0x31
; 0000 038F         HIJAU=0;
; 0000 0390         putchar(13);putchar(13);putsf("CONFIG SUCCESS !");
	RCALL SUBOPT_0x36
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,452
	RCALL SUBOPT_0x37
; 0000 0391         putchar(13);
	RCALL SUBOPT_0x36
; 0000 0392 
; 0000 0393 	#asm("sei")
	sei
; 0000 0394 }
	RCALL __LOADLOCR6
	ADIW R28,1
	SUBI R29,-2
	RET
;
;void extractGPS(void)
; 0000 0397 {
_extractGPS:
; 0000 0398 	int i,j;
; 0000 0399         char buff_altitude[9];
; 0000 039A         char cb;
; 0000 039B         long n_altitude[6];
; 0000 039C 
; 0000 039D         #asm("cli")
	SBIW R28,33
	RCALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	buff_altitude -> Y+30
;	cb -> R21
;	n_altitude -> Y+6
	cli
; 0000 039E         lagi:
_0x134:
; 0000 039F         while(getchar() != '$');
_0x135:
	RCALL _getchar
	CPI  R30,LOW(0x24)
	BRNE _0x135
; 0000 03A0         cb=getchar();
	RCALL _getchar
	MOV  R21,R30
; 0000 03A1 	if(cb=='G')
	CPI  R21,71
	BREQ PC+2
	RJMP _0x138
; 0000 03A2         {
; 0000 03A3         	getchar();
	RCALL _getchar
; 0000 03A4         	if(getchar() == 'G')
	RCALL _getchar
	CPI  R30,LOW(0x47)
	BREQ PC+2
	RJMP _0x139
; 0000 03A5         	{
; 0000 03A6         		if(getchar() == 'G')
	RCALL _getchar
	CPI  R30,LOW(0x47)
	BREQ PC+2
	RJMP _0x13A
; 0000 03A7         		{
; 0000 03A8                 		if(getchar() == 'A')
	RCALL _getchar
	CPI  R30,LOW(0x41)
	BREQ PC+2
	RJMP _0x13B
; 0000 03A9                 		{
; 0000 03AA                         		MERAH = 0;
	CBI  0x12,6
; 0000 03AB         				HIJAU = 1;
	SBI  0x12,7
; 0000 03AC 
; 0000 03AD                                 	waitComma();
	RCALL _waitComma
; 0000 03AE                                 	waitComma();
	RCALL _waitComma
; 0000 03AF 					for(i=0; i<9; i++)	posisi_lat[i] = getchar();
	RCALL SUBOPT_0x40
_0x141:
	__CPWRN 16,17,9
	BRGE _0x142
	MOVW R30,R16
	SUBI R30,LOW(-_posisi_lat)
	SBCI R31,HIGH(-_posisi_lat)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
	RCALL SUBOPT_0x44
	RJMP _0x141
_0x142:
; 0000 03B0 getchar();
	RCALL _getchar
; 0000 03B1 					posisi_lat[9] = getchar();
	__POINTW1MN _posisi_lat,9
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
; 0000 03B2 					getchar();
	RCALL _getchar
; 0000 03B3 					for(i=0; i<10; i++)	posisi_long[i] = getchar();
	RCALL SUBOPT_0x40
_0x144:
	__CPWRN 16,17,10
	BRGE _0x145
	MOVW R30,R16
	SUBI R30,LOW(-_posisi_long)
	SBCI R31,HIGH(-_posisi_long)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
	RCALL SUBOPT_0x44
	RJMP _0x144
_0x145:
; 0000 03B4 getchar();
	RCALL _getchar
; 0000 03B5                                         posisi_long[10] = getchar();
	__POINTW1MN _posisi_long,10
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
; 0000 03B6 					waitComma();
	RCALL _waitComma
; 0000 03B7                                 	waitComma();
	RCALL _waitComma
; 0000 03B8                                 	waitComma();
	RCALL _waitComma
; 0000 03B9                                 	waitComma();
	RCALL _waitComma
; 0000 03BA 					// ambil 8 byte data ketinggian dalam meter
; 0000 03BB                                 	for(i=0;i<8;i++)        buff_altitude[i] = getchar();
	RCALL SUBOPT_0x40
_0x147:
	__CPWRN 16,17,8
	BRGE _0x148
	MOVW R30,R16
	RCALL SUBOPT_0x60
	RCALL SUBOPT_0x42
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
	RCALL SUBOPT_0x44
	RJMP _0x147
_0x148:
; 0000 03BE for(i=0;i<6;i++)        n_altitude[i] = '0';
	RCALL SUBOPT_0x40
_0x14A:
	__CPWRN 16,17,6
	BRGE _0x14B
	RCALL SUBOPT_0x61
	__GETD1N 0x30
	RCALL __PUTDP1
	RCALL SUBOPT_0x44
	RJMP _0x14A
_0x14B:
; 0000 03C1 for(i=0;i<8;i++)
	RCALL SUBOPT_0x40
_0x14D:
	__CPWRN 16,17,8
	BRGE _0x14E
; 0000 03C2                                 	{
; 0000 03C3                                         	if(buff_altitude[i] == '.')     goto selesai;
	RCALL SUBOPT_0x62
	BREQ _0x150
; 0000 03C4                                         	if((buff_altitude[i] != '.')&&(buff_altitude[i] != ',')&&(buff_altitude[i] != 'M'))
	RCALL SUBOPT_0x62
	BREQ _0x152
	RCALL SUBOPT_0x63
	CPI  R26,LOW(0x2C)
	BREQ _0x152
	RCALL SUBOPT_0x63
	CPI  R26,LOW(0x4D)
	BRNE _0x153
_0x152:
	RJMP _0x151
_0x153:
; 0000 03C5                                         	{
; 0000 03C6                                                 	// geser dari satuan ke puluhan dst.
; 0000 03C7                                                 	for(j=0;j<6;j++)        n_altitude[j] = n_altitude[j+1];
	__GETWRN 18,19,0
_0x155:
	__CPWRN 18,19,6
	BRGE _0x156
	MOVW R30,R18
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	RCALL SUBOPT_0x42
	MOVW R0,R30
	MOVW R30,R18
	ADIW R30,1
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RCALL __GETD1P
	MOVW R26,R0
	RCALL __PUTDP1
	__ADDWRN 18,19,1
	RJMP _0x155
_0x156:
; 0000 03CA n_altitude[5] = buff_altitude[i];
	RCALL SUBOPT_0x60
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	RCALL __CBD1
	RCALL SUBOPT_0x64
; 0000 03CB                                         	}
; 0000 03CC                                 	}
_0x151:
	RCALL SUBOPT_0x44
	RJMP _0x14D
_0x14E:
; 0000 03CD 
; 0000 03CE                                 	selesai:
_0x150:
; 0000 03CF 
; 0000 03D0                                 	// atoi
; 0000 03D1                                 	for(i=0;i<6;i++)        n_altitude[i] -= '0';
	RCALL SUBOPT_0x40
_0x158:
	__CPWRN 16,17,6
	BRGE _0x159
	RCALL SUBOPT_0x61
	RCALL __GETD1P_INC
	__SUBD1N 48
	RCALL __PUTDP1_DEC
	RCALL SUBOPT_0x44
	RJMP _0x158
_0x159:
; 0000 03D4 n_altitude[0] *= 100000;
	RCALL SUBOPT_0x65
	__GETD2N 0x186A0
	RCALL __MULD12
	RCALL SUBOPT_0x66
; 0000 03D5                                 	n_altitude[1] *=  10000;
	RCALL SUBOPT_0x67
	__GETD2N 0x2710
	RCALL __MULD12
	__PUTD1S 10
; 0000 03D6                                 	n_altitude[2] *=   1000;
	__GETD1S 14
	__GETD2N 0x3E8
	RCALL __MULD12
	__PUTD1S 14
; 0000 03D7                                 	n_altitude[3] *=    100;
	__GETD1S 18
	__GETD2N 0x64
	RCALL __MULD12
	__PUTD1S 18
; 0000 03D8                                 	n_altitude[4] *=     10;
	__GETD1S 22
	__GETD2N 0xA
	RCALL __MULD12
	__PUTD1S 22
; 0000 03D9 
; 0000 03DA                                 	// jumlahkan satuan + puluhan + ratusan dst.
; 0000 03DB                                 	n_altitude[5] += (n_altitude[0] + n_altitude[1] + n_altitude[2] + n_altitude[3] + n_altitude[4]);
	RCALL SUBOPT_0x67
	RCALL SUBOPT_0x68
	RCALL __ADDD12
	__GETD2S 14
	RCALL __ADDD12
	__GETD2S 18
	RCALL __ADDD12
	__GETD2S 22
	RCALL __ADDD12
	__GETD2S 26
	RCALL __ADDD12
	RCALL SUBOPT_0x64
; 0000 03DC 
; 0000 03DD                                 	// meter to feet
; 0000 03DE                                 	n_altitude[5] *= 3;
	__GETD1S 26
	__GETD2N 0x3
	RCALL __MULD12
	RCALL SUBOPT_0x64
; 0000 03DF                                 	altitude=n_altitude[5];
	LDD  R30,Y+26
	LDD  R31,Y+26+1
	LDI  R26,LOW(_altitude)
	LDI  R27,HIGH(_altitude)
	RCALL __EEPROMWRW
; 0000 03E0 
; 0000 03E1                                 	MERAH = 0;
	RCALL SUBOPT_0x31
; 0000 03E2         				HIJAU = 0;
; 0000 03E3                                 	delay_ms(150);
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RCALL SUBOPT_0x69
; 0000 03E4                                 	goto keluar;
	RJMP _0x15E
; 0000 03E5                         	}
; 0000 03E6                 	}
_0x13B:
; 0000 03E7         	}
_0x13A:
; 0000 03E8         }
_0x139:
; 0000 03E9 
; 0000 03EA         else if(cb=='C')
	RJMP _0x15F
_0x138:
	CPI  R21,67
	BRNE _0x160
; 0000 03EB         {
; 0000 03EC         	if(getchar()=='O')
	RCALL _getchar
	CPI  R30,LOW(0x4F)
	BRNE _0x161
; 0000 03ED                 {
; 0000 03EE                 	if(getchar()=='N')
	RCALL _getchar
	CPI  R30,LOW(0x4E)
	BRNE _0x162
; 0000 03EF                         {
; 0000 03F0                         	if(getchar()=='F')
	RCALL _getchar
	CPI  R30,LOW(0x46)
	BRNE _0x163
; 0000 03F1                                 {
; 0000 03F2                                 	config();
	RCALL _config
; 0000 03F3                                         goto keluar;
	RJMP _0x15E
; 0000 03F4         			}
; 0000 03F5                         }
_0x163:
; 0000 03F6                 }
_0x162:
; 0000 03F7         }
_0x161:
; 0000 03F8 
; 0000 03F9 	else if(cb=='E')
	RJMP _0x164
_0x160:
	CPI  R21,69
	BRNE _0x165
; 0000 03FA         {
; 0000 03FB         	if(getchar()=='C')
	RCALL _getchar
	CPI  R30,LOW(0x43)
	BRNE _0x166
; 0000 03FC                 {
; 0000 03FD                 	if(getchar()=='H')
	RCALL _getchar
	CPI  R30,LOW(0x48)
	BRNE _0x167
; 0000 03FE                         {
; 0000 03FF                         	if(getchar()=='O')
	RCALL _getchar
	CPI  R30,LOW(0x4F)
	BRNE _0x168
; 0000 0400                                 {
; 0000 0401                                 	mem_display();
	RCALL _mem_display
; 0000 0402                                         goto keluar;
	RJMP _0x15E
; 0000 0403         			}
; 0000 0404                         }
_0x168:
; 0000 0405                 }
_0x167:
; 0000 0406         }
_0x166:
; 0000 0407 
; 0000 0408         goto lagi;
_0x165:
_0x164:
_0x15F:
	RJMP _0x134
; 0000 0409 
; 0000 040A         keluar:
_0x15E:
; 0000 040B         #asm("sei")
	sei
; 0000 040C }
	RCALL __LOADLOCR6
	ADIW R28,39
	RET
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 040F {
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
; 0000 0410         if(gps=='Y')
	LDI  R26,LOW(_gps)
	LDI  R27,HIGH(_gps)
	RCALL SUBOPT_0x2F
	BRNE _0x169
; 0000 0411         {
; 0000 0412         	HIJAU=0;
	CBI  0x12,7
; 0000 0413                 MERAH=0;
	CBI  0x12,6
; 0000 0414                 extractGPS();
	RJMP _0x18D
; 0000 0415         }
; 0000 0416         else
_0x169:
; 0000 0417         {
; 0000 0418         	HIJAU=1;
	SBI  0x12,7
; 0000 0419                 MERAH=0;
	CBI  0x12,6
; 0000 041A                 if(PIND.0==0)extractGPS();
	SBIS 0x10,0
_0x18D:
	RCALL _extractGPS
; 0000 041B         }
; 0000 041C         if((tcnt1c/2)==timeIntv)
	__GETW1R 9,10
	LSR  R31
	ROR  R30
	MOVW R0,R30
	RCALL SUBOPT_0x3D
	CP   R30,R0
	CPC  R31,R1
	BRNE _0x174
; 0000 041D         {
; 0000 041E         	kirim_paket();
	RCALL _kirim_paket
; 0000 041F                 tcnt1c=0;
	CLR  R9
	CLR  R10
; 0000 0420         }
; 0000 0421         TCNT1H = (60135 >> 8);
_0x174:
	RCALL SUBOPT_0x6A
; 0000 0422         TCNT1L = (60135 & 0xFF);
; 0000 0423 
; 0000 0424         tcnt1c++;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	__ADDWRR 9,10,30,31
; 0000 0425         if(tcnt1c==65535)tcnt1c=0;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CP   R30,R9
	CPC  R31,R10
	BRNE _0x175
	CLR  R9
	CLR  R10
; 0000 0426 }
_0x175:
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
; 0000 0429 {
_main:
; 0000 042A         PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 042B 	DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 042C 	PORTD=0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 042D 	DDRD=0xFE;
	LDI  R30,LOW(254)
	OUT  0x11,R30
; 0000 042E 
; 0000 042F         TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0430 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 0431 	TCNT1H = (60135 >> 8);
	RCALL SUBOPT_0x6A
; 0000 0432         TCNT1L = (60135 & 0xFF);
; 0000 0433         TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0434 
; 0000 0435 	// Rx ON-noInt Tx ON-noInt
; 0000 0436 	UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0437 	UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0438 	UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0439 	UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 043A 	UBRRL=0x8F;
	LDI  R30,LOW(143)
	OUT  0x9,R30
; 0000 043B 
; 0000 043C 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 043D 
; 0000 043E 	ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 043F 	ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0440 
; 0000 0441         MERAH = 1;
	RCALL SUBOPT_0x2C
; 0000 0442         HIJAU = 0;
; 0000 0443         delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x69
; 0000 0444         MERAH = 0;
	CBI  0x12,6
; 0000 0445         HIJAU = 1;
	SBI  0x12,7
; 0000 0446         delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x69
; 0000 0447 
; 0000 0448         #asm("sei")
	sei
; 0000 0449 
; 0000 044A         kirim_paket();
	RCALL _kirim_paket
; 0000 044B 
; 0000 044C 	while (1)
_0x17E:
; 0000 044D       	{
; 0000 044E         	//putchar(p=getchar());
; 0000 044F                 if(sendtopc=='Y')
	LDI  R26,LOW(_sendtopc)
	LDI  R27,HIGH(_sendtopc)
	RCALL SUBOPT_0x2F
	BRNE _0x181
; 0000 0450                 {
; 0000 0451                 read_temp();
	RCALL _read_temp
; 0000 0452                 read_volt();
	RCALL _read_volt
; 0000 0453                 putchar(13);putsf("Temperature       :");puts(temp);//putchar('C');
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,469
	RCALL SUBOPT_0x37
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	RCALL SUBOPT_0x2A
	RCALL _puts
; 0000 0454                 putchar(13);putsf("Battery Voltage   :");puts(volt);//putchar('V');
	RCALL SUBOPT_0x36
	__POINTW1FN _0x0,489
	RCALL SUBOPT_0x37
	LDI  R30,LOW(_volt)
	LDI  R31,HIGH(_volt)
	RCALL SUBOPT_0x2A
	RCALL _puts
; 0000 0455                 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x69
; 0000 0456                 }
; 0000 0457       	}
_0x181:
	RJMP _0x17E
; 0000 0458 }
_0x182:
	RJMP _0x182
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
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x20A0005:
	ADIW R28,1
	RET
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
	RJMP _0x20A0004
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
_0x20A0004:
	LDI  R30,LOW(10)
	RCALL SUBOPT_0x3A
	LDD  R17,Y+0
	ADIW R28,3
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
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x6C
    brne __floor1
__floor0:
	RCALL SUBOPT_0x6B
	RJMP _0x20A0003
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x18
	RCALL __SUBF12
	RJMP _0x20A0003
_ceil:
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x6C
    brne __ceil1
__ceil0:
	RCALL SUBOPT_0x6B
	RJMP _0x20A0003
__ceil1:
    brts __ceil0
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0x18
	RCALL __ADDF12
_0x20A0003:
	ADIW R28,4
	RET
_fmod:
	SBIW R28,4
	RCALL SUBOPT_0x6D
	RCALL __CPD10
	BRNE _0x2020005
	RCALL SUBOPT_0x6E
	RJMP _0x20A0002
_0x2020005:
	RCALL SUBOPT_0x6D
	RCALL SUBOPT_0xF
	RCALL __DIVF21
	RCALL __PUTD1S0
	RCALL SUBOPT_0x6B
	RCALL __CPD10
	BRNE _0x2020006
	RCALL SUBOPT_0x6E
	RJMP _0x20A0002
_0x2020006:
	RCALL __GETD2S0
	RCALL __CPD02
	BRGE _0x2020007
	RCALL SUBOPT_0x6B
	RCALL __PUTPARD1
	RCALL _floor
	RJMP _0x2020033
_0x2020007:
	RCALL SUBOPT_0x6B
	RCALL __PUTPARD1
	RCALL _ceil
_0x2020033:
	RCALL __PUTD1S0
	RCALL SUBOPT_0x6B
	RCALL SUBOPT_0xD
	RCALL __MULF12
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0xE
_0x20A0002:
	ADIW R28,12
	RET
_log:
	SBIW R28,4
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x68
	RCALL __CPD02
	BRLT _0x202000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20A0001
_0x202000C:
	RCALL SUBOPT_0x65
	RCALL __PUTPARD1
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	RCALL SUBOPT_0x2A
	PUSH R17
	PUSH R16
	RCALL _frexp
	POP  R16
	POP  R17
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x68
	__GETD1N 0x3F3504F3
	RCALL __CMPF12
	BRSH _0x202000D
	RCALL SUBOPT_0x65
	RCALL SUBOPT_0x68
	RCALL __ADDF12
	RCALL SUBOPT_0x66
	__SUBWRN 16,17,1
_0x202000D:
	RCALL SUBOPT_0x65
	RCALL SUBOPT_0x18
	RCALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x65
	RCALL SUBOPT_0x18
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x65
	RCALL SUBOPT_0x68
	RCALL __MULF12
	__PUTD1S 2
	RCALL SUBOPT_0x6F
	__GETD2N 0x3F654226
	RCALL __MULF12
	RCALL SUBOPT_0xA
	__GETD1N 0x4054114E
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x68
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x6F
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
	RCALL __CWD1
	RCALL __CDF1
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
_atoi:
   	ldd  r27,y+1
   	ld   r26,y
__atoi0:
   	ld   r30,x
	ST   -Y,R30
	RCALL _isspace
   	tst  r30
   	breq __atoi1
   	adiw r26,1
   	rjmp __atoi0
__atoi1:
   	clt
   	ld   r30,x
   	cpi  r30,'-'
   	brne __atoi2
   	set
   	rjmp __atoi3
__atoi2:
   	cpi  r30,'+'
   	brne __atoi4
__atoi3:
   	adiw r26,1
__atoi4:
   	clr  r22
   	clr  r23
__atoi5:
   	ld   r30,x
	ST   -Y,R30
	RCALL _isdigit
   	tst  r30
   	breq __atoi6
   	movw r30,r22
   	lsl  r22
   	rol  r23
   	lsl  r22
   	rol  r23
   	add  r22,r30
   	adc  r23,r31
   	lsl  r22
   	rol  r23
   	ld   r30,x+
   	clr  r31
   	subi r30,'0'
   	add  r22,r30
   	adc  r23,r31
   	rjmp __atoi5
__atoi6:
   	movw r30,r22
   	brtc __atoi7
   	com  r30
   	com  r31
   	adiw r30,1
__atoi7:
   	adiw r28,2
   	ret
_itoa:
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    adiw r30,0
    brpl __itoa0
    com  r30
    com  r31
    adiw r30,1
    ldi  r22,'-'
    st   x+,r22
__itoa0:
    clt
    ldi  r24,low(10000)
    ldi  r25,high(10000)
    rcall __itoa1
    ldi  r24,low(1000)
    ldi  r25,high(1000)
    rcall __itoa1
    ldi  r24,100
    clr  r25
    rcall __itoa1
    ldi  r24,10
    rcall __itoa1
    mov  r22,r30
    rcall __itoa5
    clr  r22
    st   x,r22
    ret

__itoa1:
    clr	 r22
__itoa2:
    cp   r30,r24
    cpc  r31,r25
    brlo __itoa3
    inc  r22
    sub  r30,r24
    sbc  r31,r25
    brne __itoa2
__itoa3:
    tst  r22
    brne __itoa4
    brts __itoa5
    ret
__itoa4:
    set
__itoa5:
    subi r22,-0x30
    st   x+,r22
    ret

	.DSEG

	.CSEG

	.CSEG
_isdigit:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,'0'
    brlo isdigit0
    cpi  r31,'9'+1
    brlo isdigit1
isdigit0:
    clr  r30
isdigit1:
    ret
_isspace:
    ldi  r30,1
    ld   r31,y+
    cpi  r31,' '
    breq isspace1
    cpi  r31,9
    brlo isspace0
    cpi  r31,13+1
    brlo isspace1
isspace0:
    clr  r30
isspace1:
    ret

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
_mycall:
	.DB  LOW(0x57324359),HIGH(0x57324359),BYTE3(0x57324359),BYTE4(0x57324359)
	.DB  LOW(0x304159),HIGH(0x304159),BYTE3(0x304159),BYTE4(0x304159)
_mydigi1:
	.DB  LOW(0x45444957),HIGH(0x45444957),BYTE3(0x45444957),BYTE4(0x45444957)
	.DB  LOW(0x312032),HIGH(0x312032),BYTE3(0x312032),BYTE4(0x312032)
_mydigi2:
	.DB  LOW(0x45444957),HIGH(0x45444957),BYTE3(0x45444957),BYTE4(0x45444957)
	.DB  LOW(0x322032),HIGH(0x322032),BYTE3(0x322032),BYTE4(0x322032)
_mydigi3:
	.DB  LOW(0x45444957),HIGH(0x45444957),BYTE3(0x45444957),BYTE4(0x45444957)
	.DB  LOW(0x322032),HIGH(0x322032),BYTE3(0x322032),BYTE4(0x322032)
_comment:
	.DB  LOW(0x2077654E),HIGH(0x2077654E),BYTE3(0x2077654E),BYTE4(0x2077654E)
	.DB  LOW(0x63617254),HIGH(0x63617254),BYTE3(0x63617254),BYTE4(0x63617254)
	.DB  LOW(0x72656B),HIGH(0x72656B),BYTE3(0x72656B),BYTE4(0x72656B)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
_status:
	.DB  LOW(0x546F7250),HIGH(0x546F7250),BYTE3(0x546F7250),BYTE4(0x546F7250)
	.DB  LOW(0x216B6172),HIGH(0x216B6172),BYTE3(0x216B6172),BYTE4(0x216B6172)
	.DB  LOW(0x52504120),HIGH(0x52504120),BYTE3(0x52504120),BYTE4(0x52504120)
	.DB  LOW(0x20262053),HIGH(0x20262053),BYTE3(0x20262053),BYTE4(0x20262053)
	.DB  LOW(0x656C6554),HIGH(0x656C6554),BYTE3(0x656C6554),BYTE4(0x656C6554)
	.DB  LOW(0x7274656D),HIGH(0x7274656D),BYTE3(0x7274656D),BYTE4(0x7274656D)
	.DB  LOW(0x6E452079),HIGH(0x6E452079),BYTE3(0x6E452079),BYTE4(0x6E452079)
	.DB  LOW(0x65646F63),HIGH(0x65646F63),BYTE3(0x65646F63),BYTE4(0x65646F63)
	.DB  LOW(0x72),HIGH(0x72),BYTE3(0x72),BYTE4(0x72)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
	.DB  LOW(0x0),HIGH(0x0),BYTE3(0x0),BYTE4(0x0)
_posisi_lat:
	.DB  LOW(0x35343730),HIGH(0x35343730),BYTE3(0x35343730),BYTE4(0x35343730)
	.DB  LOW(0x3238342E),HIGH(0x3238342E),BYTE3(0x3238342E),BYTE4(0x3238342E)
	.DW  0x5331
	.DB  0x0
_posisi_long:
	.DB  LOW(0x32303131),HIGH(0x32303131),BYTE3(0x32303131),BYTE4(0x32303131)
	.DB  LOW(0x36352E32),HIGH(0x36352E32),BYTE3(0x36352E32),BYTE4(0x36352E32)
	.DB  LOW(0x453132),HIGH(0x453132),BYTE3(0x453132),BYTE4(0x453132)
_altitude:
	.DW  0x0
_m_int:
	.DW  0x15
_comp_lat:
	.BYTE 0x4
_comp_long:
	.BYTE 0x4
_timeIntv:
	.DW  0x4
_compstat:
	.DB  0x59
_battvoltincomm:
	.DB  0x59
_tempincomm:
	.DB  0x59
_sendalt:
	.DB  0x59
_gps:
	.DB  0x4E
_sendtopc:
	.DB  0x4E
_commsize:
	.DB  0xB
_statsize:
	.DB  0x21

	.DSEG
_temp:
	.BYTE 0x7
_volt:
	.BYTE 0x7
_comp_cst:
	.BYTE 0x3
_bit_stuff_G000:
	.BYTE 0x1
_crc_lo_S000000C000:
	.BYTE 0x1
_crc_hi_S000000C000:
	.BYTE 0x1
_xor_in_S000000E000:
	.BYTE 0x2
__seed_G102:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	RCALL __MULW12U
	CLR  R22
	CLR  R23
	RCALL __CDF1
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x1:
	RCALL __DIVF21
	RCALL __CFD1
	MOVW R16,R30
	MOVW R26,R16
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21
	MOV  R19,R30
	MOVW R26,R16
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21
	MOV  R18,R30
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21
	MOV  R21,R30
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21
	MOV  R20,R30
	CPI  R19,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x2:
	RCALL __EEPROMRDB
	SUBI R30,LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(10)
	MULS R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x4:
	RCALL __CBD1
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5:
	__GETD2N 0x42C80000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6:
	RCALL SUBOPT_0x4
	__GETD2N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x4
	__GETD2N 0x3F800000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD1N 0x1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__GETD1N 0xFFFFFFFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	MOVW R26,R30
	MOVW R24,R22
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	__GETD1N 0x42700000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0xC:
	__GETD2N 0x3F19999A
	RCALL __MULF12
	RCALL SUBOPT_0xA
	__GETD1N 0x470CA000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__GETD2S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	RCALL __SWAPD12
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xF:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	__GETD1N 0x4937FA30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x11:
	RCALL __DIVF21
	__GETD2N 0x42040000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x12:
	RCALL __CFD1
	RCALL __EEPROMWRB
	__GETD1S 8
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x13:
	RCALL SUBOPT_0x10
	RCALL __PUTPARD1
	RCALL _fmod
	RCALL SUBOPT_0xA
	__GETD1N 0x46016400
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x14:
	__GETD1N 0x46016400
	RCALL __PUTPARD1
	RCALL _fmod
	RCALL SUBOPT_0xA
	__GETD1N 0x42B60000
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x15:
	__GETD1N 0x42B60000
	RCALL __PUTPARD1
	RCALL _fmod
	__GETD2N 0x42040000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x16:
	RCALL __CFD1
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	__GETD1S 5
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x18:
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	ST   -Y,R17
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:73 WORDS
SUBOPT_0x1A:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x1B:
	RCALL __EEPROMRDB
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	SUBI R26,LOW(-_mycall)
	SBCI R27,HIGH(-_mycall)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x1D:
	LSL  R30
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	__POINTW2MN _mycall,6
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1F:
	SUBI R26,LOW(-_mydigi1)
	SBCI R27,HIGH(-_mydigi1)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x20:
	__POINTW2MN _mydigi1,6
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	SUBI R26,LOW(-_mydigi2)
	SBCI R27,HIGH(-_mydigi2)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	__POINTW2MN _mydigi2,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	SUBI R26,LOW(-_mydigi3)
	SBCI R27,HIGH(-_mydigi3)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	__POINTW2MN _mydigi3,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x25:
	LSL  R30
	SUBI R30,-LOW(1)
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x26:
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	LDI  R26,LOW(_statsize)
	LDI  R27,HIGH(_statsize)
	RCALL __EEPROMRDB
	CP   R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x28:
	SUBI R26,LOW(-_status)
	SBCI R27,HIGH(-_status)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	RCALL __EEPROMRDB
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 54 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x2A:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(0)
	STS  _bit_stuff_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2C:
	SBI  0x12,6
	CBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(_m_int)
	LDI  R27,HIGH(_m_int)
	RCALL __EEPROMRDW
	MOV  R26,R6
	LDI  R27,0
	SBRC R26,7
	SER  R27
	RCALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2E:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x59)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x30:
	LDI  R26,LOW(_commsize)
	LDI  R27,HIGH(_commsize)
	RCALL __EEPROMRDB
	CP   R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	CBI  0x12,6
	CBI  0x12,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	ST   -Y,R30
	RJMP _set_nada

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x33:
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	__DELAY_USW 1153
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	__DELAY_USW 575
	SBI  0x18,4
	__DELAY_USW 578
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:48 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(13)
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x2A
	RJMP _putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 77 TIMES, CODE SIZE REDUCTION:150 WORDS
SUBOPT_0x38:
	LDI  R30,LOW(9)
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x39:
	LDI  R30,LOW(58)
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 27 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x3A:
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	LDI  R30,LOW(45)
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:31 WORDS
SUBOPT_0x3C:
	LDI  R31,0
	RCALL SUBOPT_0x2A
	MOVW R30,R28
	ADIW R30,3
	RCALL SUBOPT_0x2A
	RCALL _itoa
	MOVW R30,R28
	ADIW R30,1
	RCALL SUBOPT_0x2A
	RJMP _puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3D:
	LDI  R26,LOW(_timeIntv)
	LDI  R27,HIGH(_timeIntv)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3E:
	RCALL SUBOPT_0x2A
	MOVW R30,R28
	ADIW R30,3
	RCALL SUBOPT_0x2A
	RCALL _itoa
	MOVW R30,R28
	ADIW R30,1
	RCALL SUBOPT_0x2A
	RCALL _puts
	LDI  R30,LOW(32)
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3F:
	RCALL __EEPROMRDB
	RJMP SUBOPT_0x3A

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x40:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 60 TIMES, CODE SIZE REDUCTION:57 WORDS
SUBOPT_0x41:
	MOVW R26,R28
	ADIW R26,13
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x42:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x43:
	RCALL SUBOPT_0x41
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x44:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x45:
	__GETWRN 20,21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x46:
	MOVW R30,R20
	RCALL SUBOPT_0x41
	RCALL SUBOPT_0x42
	MOVW R0,R30
	RCALL SUBOPT_0x41
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	__ADDWRN 20,21,1
	RJMP SUBOPT_0x44

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x47:
	MOVW R30,R16
	ADIW R30,1
	MOVW R18,R30
	__PUTWSR 20,21,6
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x48:
	ADD  R26,R20
	ADC  R27,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(32)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x4A:
	__ADDWRN 20,21,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	LDI  R30,LOW(48)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4C:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R20,R30
	CPC  R21,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4D:
	RCALL SUBOPT_0x41
	RJMP SUBOPT_0x48

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4E:
	LD   R26,X
	CPI  R26,LOW(0x2D)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x4F:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SUB  R26,R20
	SBC  R27,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x50:
	MOVW R0,R30
	MOVW R30,R20
	ADIW R30,1
	RCALL SUBOPT_0x41
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x51:
	MOVW R30,R20
	ADIW R30,1
	RCALL SUBOPT_0x41
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,LOW(48)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x52:
	MOVW R30,R20
	ADIW R30,2
	RCALL SUBOPT_0x41
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOV  R26,R0
	ADD  R26,R30
	LDI  R30,LOW(48)
	RCALL __SWAPB12
	SUB  R30,R26
	SUBI R30,-LOW(48)
	MOVW R26,R22
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x53:
	MOVW R0,R30
	RJMP SUBOPT_0x4D

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x54:
	LD   R30,X
	MOVW R26,R0
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x55:
	MOVW R16,R18
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x56:
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	MOVW R26,R28
	ADIW R26,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x58:
	MOVW R30,R20
	RCALL SUBOPT_0x57
	RCALL SUBOPT_0x42
	MOVW R0,R30
	RCALL SUBOPT_0x41
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x59:
	MOVW R30,R16
	ADIW R30,1
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5A:
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x2A
	RJMP _atoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5B:
	RCALL __EEPROMWRW
	MOVW R16,R18
	RCALL SUBOPT_0x41
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x5C:
	RCALL __EEPROMWRB
	MOVW R30,R16
	ADIW R30,2
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5D:
	MOVW R16,R18
	RCALL SUBOPT_0x41
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5E:
	RCALL __EEPROMRDB
	MOVW R26,R20
	RCALL SUBOPT_0x33
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x5F:
	MOVW R0,R30
	RCALL SUBOPT_0x41
	ADD  R26,R16
	ADC  R27,R17
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x60:
	MOVW R26,R28
	ADIW R26,30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	MOVW R30,R16
	MOVW R26,R28
	ADIW R26,6
	RCALL __LSLW2
	ADD  R26,R30
	ADC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x62:
	RCALL SUBOPT_0x60
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	CPI  R26,LOW(0x2E)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	RCALL SUBOPT_0x60
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x64:
	__PUTD1S 26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x65:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x66:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x67:
	__GETD1S 10
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x68:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	RCALL SUBOPT_0x2A
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	LDI  R30,LOW(234)
	OUT  0x2D,R30
	LDI  R30,LOW(231)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x6B:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6C:
	RCALL __PUTPARD1
	RCALL _ftrunc
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6D:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6F:
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

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
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

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
	RET

__LSLW2:
	LSL  R30
	ROL  R31
	LSL  R30
	ROL  R31
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__CBD2:
	MOV  R27,R26
	ADD  R27,R27
	SBC  R27,R27
	MOV  R24,R27
	MOV  R25,R27
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

__MULD12U:
	MUL  R23,R26
	MOV  R23,R0
	MUL  R22,R27
	ADD  R23,R0
	MUL  R31,R24
	ADD  R23,R0
	MUL  R30,R25
	ADD  R23,R0
	MUL  R22,R26
	MOV  R22,R0
	ADD  R23,R1
	MUL  R31,R27
	ADD  R22,R0
	ADC  R23,R1
	MUL  R30,R24
	ADD  R22,R0
	ADC  R23,R1
	CLR  R24
	MUL  R31,R26
	MOV  R31,R0
	ADD  R22,R1
	ADC  R23,R24
	MUL  R30,R27
	ADD  R31,R0
	ADC  R22,R1
	ADC  R23,R24
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	ADC  R22,R24
	ADC  R23,R24
	RET

__MULD12:
	RCALL __CHKSIGND
	RCALL __MULD12U
	BRTC __MULD121
	RCALL __ANEGD1
__MULD121:
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

__CHKSIGND:
	CLT
	SBRS R23,7
	RJMP __CHKSD1
	RCALL __ANEGD1
	SET
__CHKSD1:
	SBRS R25,7
	RJMP __CHKSD2
	CLR  R0
	COM  R26
	COM  R27
	COM  R24
	COM  R25
	ADIW R26,1
	ADC  R24,R0
	ADC  R25,R0
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSD2:
	RET

__GETD1P:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X
	SBIW R26,3
	RET

__GETD1P_INC:
	LD   R30,X+
	LD   R31,X+
	LD   R22,X+
	LD   R23,X+
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__PUTDP1_DEC:
	ST   -X,R23
	ST   -X,R22
	ST   -X,R31
	ST   -X,R30
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
