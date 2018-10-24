
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
;Data Stack size          : 564 byte(s)
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
	.EQU __DSTACK_SIZE=0x0234
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
_0x1F8:
	.DB  0x0,0x0
_0x0:
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

	.DW  0x09
	.DW  _norm_alt
	.DW  _0x6*2

	.DW  0x02
	.DW  0x06
	.DW  _0x1F8*2

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
	.ORG 0x294

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
;void waitDollar(void);
;void waitInvCo(void);
;void config(void);
;void extractGPS(void);
;
;eeprom char SYM_TAB_OVL_='/';
;eeprom char SYM_CODE_='O';
;eeprom unsigned char add_aprs[7]={('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),('0'<<1)};
;eeprom unsigned char add_tel[7]={('T'<<1),('E'<<1),('L'<<1),(' '<<1),(' '<<1),(' '<<1),('0'<<1)};
;eeprom unsigned char add_beacon[7]={('B'<<1),('E'<<1),('A'<<1),('C'<<1),('O'<<1),('N'<<1),('0'<<1)};
;eeprom unsigned char mycall[8]={"YC2WYA0"};
;eeprom unsigned char mydigi1[8]={"WIDE2 1"};
;eeprom unsigned char mydigi2[8]={"WIDE2 2"};
;eeprom unsigned char mydigi3[8]={"WIDE2 2"};
;eeprom char comment[100] ={"New Tracker"};
;eeprom char status[100]={"ProTrak! APRS & Telemetry Encoder"};
;eeprom char posisi_lat[]={"0745.48S"};
;eeprom char posisi_long[]={"11022.56E"};
;eeprom char message_head[12]={":YB2YOU-11:"};
;eeprom char param[] ={"PARM.Temp,B.Volt,Alti"};
;eeprom char unit[]  ={"UNIT.Deg.C,Volt,Feet"};
;eeprom char eqns[]  ={"EQNS.0,0.1,0,0,0.1,0,0,66,0"};
;eeprom unsigned int altitude = 0;
;eeprom char m_int=21;
;eeprom int tel_int=5;
;eeprom char comp_lat[4];
;eeprom char comp_long[4];
;eeprom int seq=0;
;eeprom int timeIntv=4;
;eeprom char compstat='Y';
;eeprom char battvoltincomm='Y';
;eeprom char tempincomm='Y';
;eeprom char sendalt='Y';
;eeprom char sendtel='Y';
;eeprom char gps='Y';
;eeprom char pri1='T';
;eeprom char pri2='B';
;eeprom char pri3='A';
;eeprom char pri4='2';
;eeprom char pri5='3';
;eeprom char commsize=11;
;eeprom char statsize=33;
;eeprom char sendtopc='N';
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
;char alti[3];
;char tcnt1c=0;
;
;void read_temp(void)
; 0000 0084 {

	.CSEG
_read_temp:
; 0000 0085 	int adc;
; 0000 0086         char adc_r,adc_p,adc_s,adc_d;
; 0000 0087 
; 0000 0088         adc = (5*read_adc(TEMP_ADC_)/1.024);
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
; 0000 0089         //itoa(adc,temp);
; 0000 008A 
; 0000 008B         adc_r = (adc/1000);
; 0000 008C         adc_p = ((adc%1000)/100);
; 0000 008D         adc_s = ((adc%100)/10);
; 0000 008E         adc_d = (adc%10);
; 0000 008F 
; 0000 0090         if(adc_r==0)temp[0]=' ';
	BRNE _0x7
	LDI  R30,LOW(32)
	RJMP _0x1EC
; 0000 0091         else temp[0] = adc_r + '0';
_0x7:
	MOV  R30,R19
	SUBI R30,-LOW(48)
_0x1EC:
	STS  _temp,R30
; 0000 0092         if((adc_p==0)&&(adc_r==0)) temp[1]=' ';
	CPI  R18,0
	BRNE _0xA
	CPI  R19,0
	BREQ _0xB
_0xA:
	RJMP _0x9
_0xB:
	LDI  R30,LOW(32)
	RJMP _0x1ED
; 0000 0093         else temp[1] = adc_p + '0';
_0x9:
	MOV  R30,R18
	SUBI R30,-LOW(48)
_0x1ED:
	__PUTB1MN _temp,1
; 0000 0094         temp[2] = adc_s + '0';
	MOV  R30,R21
	SUBI R30,-LOW(48)
	__PUTB1MN _temp,2
; 0000 0095         temp[4] = adc_d + '0';
	MOV  R30,R20
	SUBI R30,-LOW(48)
	__PUTB1MN _temp,4
; 0000 0096 }
	RJMP _0x20A000A
;
;void read_volt(void)
; 0000 0099 {
_read_volt:
; 0000 009A 	int adc;
; 0000 009B         char adc_r,adc_p,adc_s,adc_d;
; 0000 009C 
; 0000 009D         adc = (5*22*read_adc(VSENSE_ADC_))/102.4;
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
; 0000 009E         //itoa(adc,volt);
; 0000 009F 
; 0000 00A0         adc_r = (adc/1000);
; 0000 00A1         adc_p = ((adc%1000)/100);
; 0000 00A2         adc_s = ((adc%100)/10);
; 0000 00A3         adc_d = (adc%10);
; 0000 00A4 
; 0000 00A5         if(adc_r==0)	volt[0]=' ';
	BRNE _0xD
	LDI  R30,LOW(32)
	RJMP _0x1EE
; 0000 00A6         else volt[0] = adc_r + '0';
_0xD:
	MOV  R30,R19
	SUBI R30,-LOW(48)
_0x1EE:
	STS  _volt,R30
; 0000 00A7         if((adc_p==0)&&(adc_r==0)) volt[1]=' ';
	CPI  R18,0
	BRNE _0x10
	CPI  R19,0
	BREQ _0x11
_0x10:
	RJMP _0xF
_0x11:
	LDI  R30,LOW(32)
	RJMP _0x1EF
; 0000 00A8         else volt[1] = adc_p + '0';
_0xF:
	MOV  R30,R18
	SUBI R30,-LOW(48)
_0x1EF:
	__PUTB1MN _volt,1
; 0000 00A9         volt[2] = adc_s + '0';
	MOV  R30,R21
	SUBI R30,-LOW(48)
	__PUTB1MN _volt,2
; 0000 00AA         volt[4] = adc_d + '0';
	MOV  R30,R20
	SUBI R30,-LOW(48)
	__PUTB1MN _volt,4
; 0000 00AB }
_0x20A000A:
	RCALL __LOADLOCR6
	ADIW R28,6
	RET
;
;void base91_lat(void)
; 0000 00AE {
_base91_lat:
; 0000 00AF   	char deg;
; 0000 00B0         char min;
; 0000 00B1         float sec;
; 0000 00B2         char sign;
; 0000 00B3         float lat;
; 0000 00B4         float f_lat;
; 0000 00B5 
; 0000 00B6         deg = ((posisi_lat[0]-48)*10) + (posisi_lat[1]-48);
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
	RCALL SUBOPT_0x4
	__POINTW2MN _posisi_lat,1
	RCALL SUBOPT_0x3
	ADD  R30,R0
	MOV  R17,R30
; 0000 00B7         min = ((posisi_lat[2]-48)*10) + (posisi_lat[3]-48);
	__POINTW2MN _posisi_lat,2
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	__POINTW2MN _posisi_lat,3
	RCALL SUBOPT_0x3
	ADD  R30,R0
	MOV  R16,R30
; 0000 00B8         //sec = ((posisi_lat[5]-48)*1000.0) + ((posisi_lat[6]-48)*100.0)+((posisi_lat[7]-48)*10.0) + (posisi_lat[8]-48);
; 0000 00B9         sec = ((posisi_lat[5]-48)*10.0) + (posisi_lat[6]-48);
	__POINTW2MN _posisi_lat,5
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
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
	RCALL SUBOPT_0x7
; 0000 00BA 
; 0000 00BB         if(posisi_lat[7]=='N') sign = 1.0;
	__POINTW2MN _posisi_lat,7
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x4E)
	BRNE _0x13
	RCALL SUBOPT_0x8
	RJMP _0x1F0
; 0000 00BC         else sign = -1.0;
_0x13:
	RCALL SUBOPT_0x9
_0x1F0:
	MOV  R19,R30
; 0000 00BD 
; 0000 00BE         //f_lat = (deg + (min/60.0) + (0.6*sec/360000.0));
; 0000 00BF         f_lat = (deg + (min/60.0) + (0.6*sec/3600.0));
	RCALL SUBOPT_0xA
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xB
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0xC
; 0000 00C0         lat = 380926 * (90 - (f_lat * sign));
	__GETD2N 0x42B40000
	RCALL SUBOPT_0xD
	__GETD2N 0x48B9FFC0
	RCALL SUBOPT_0xE
; 0000 00C1 
; 0000 00C2         comp_lat[0] = (lat/753571)+33;
	LDI  R26,LOW(_comp_lat)
	LDI  R27,HIGH(_comp_lat)
	RCALL SUBOPT_0xF
; 0000 00C3         comp_lat[1] = ((fmod(lat,753571))/8281)+33;
	RCALL SUBOPT_0x10
	__POINTW2MN _comp_lat,1
	RCALL SUBOPT_0xF
; 0000 00C4         comp_lat[2] = ((fmod(lat,8281))/91)+33;
	RCALL SUBOPT_0x11
	__POINTW2MN _comp_lat,2
	RCALL SUBOPT_0xF
; 0000 00C5         comp_lat[3] = (fmod(lat,91))+33;
	RCALL SUBOPT_0x12
	__POINTW2MN _comp_lat,3
	RJMP _0x20A0009
; 0000 00C6 }
;
;void base91_long(void)
; 0000 00C9 {
_base91_long:
; 0000 00CA   	char deg;
; 0000 00CB         char min;
; 0000 00CC         float sec;
; 0000 00CD         char sign;
; 0000 00CE         float lon;
; 0000 00CF         float f_lon;
; 0000 00D0 
; 0000 00D1         deg = ((posisi_long[0]-48)*100) + ((posisi_long[1]-48)*10) + (posisi_long[2]-48);
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
; 0000 00D2         min = ((posisi_long[3]-48)*10) + (posisi_long[4]-48);
	__POINTW2MN _posisi_long,3
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
	__POINTW2MN _posisi_long,4
	RCALL SUBOPT_0x3
	ADD  R30,R0
	MOV  R16,R30
; 0000 00D3         //sec = ((posisi_long[6]-48)*1000.0) + ((posisi_long[7]-48)*100.0) + ((posisi_long[8]-48)*10.0) + (posisi_long[9]-48);
; 0000 00D4         sec = ((posisi_long[6]-48)*10.0) + (posisi_long[7]-48);
	__POINTW2MN _posisi_long,6
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x6
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
	RCALL SUBOPT_0x7
; 0000 00D5 
; 0000 00D6         if(posisi_long[8]=='E') sign = -1.0;
	__POINTW2MN _posisi_long,8
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x45)
	BRNE _0x15
	RCALL SUBOPT_0x9
	RJMP _0x1F1
; 0000 00D7         else			sign = 1.0;
_0x15:
	RCALL SUBOPT_0x8
_0x1F1:
	MOV  R19,R30
; 0000 00D8 
; 0000 00D9         //f_lon = (deg + (min/60.0) + (0.6*sec/360000.0));
; 0000 00DA         f_lon = (deg + (min/60.0) + (0.6*sec/3600.0));
	RCALL SUBOPT_0xA
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0xB
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL SUBOPT_0xC
; 0000 00DB         lon = 190463 * (180 - (f_lon * sign));
	__GETD2N 0x43340000
	RCALL SUBOPT_0xD
	__GETD2N 0x4839FFC0
	RCALL SUBOPT_0xE
; 0000 00DC 
; 0000 00DD         comp_long[0] = (lon/753571)+33;
	LDI  R26,LOW(_comp_long)
	LDI  R27,HIGH(_comp_long)
	RCALL SUBOPT_0xF
; 0000 00DE         comp_long[1] = ((fmod(lon,753571))/8281)+33;
	RCALL SUBOPT_0x10
	__POINTW2MN _comp_long,1
	RCALL SUBOPT_0xF
; 0000 00DF         comp_long[2] = ((fmod(lon,8281))/91)+33;
	RCALL SUBOPT_0x11
	__POINTW2MN _comp_long,2
	RCALL SUBOPT_0xF
; 0000 00E0         comp_long[3] = (fmod(lon,91))+33;
	RCALL SUBOPT_0x12
	__POINTW2MN _comp_long,3
_0x20A0009:
	RCALL __CFD1
	RCALL __EEPROMWRB
; 0000 00E1 }
	RCALL __LOADLOCR4
	ADIW R28,16
	RET
;
;void base91_alt(void)
; 0000 00E4 {
_base91_alt:
; 0000 00E5 	int alt;
; 0000 00E6 
; 0000 00E7         alt = (500.5*log(altitude*1.0));
	RCALL __SAVELOCR2
;	alt -> R16,R17
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x14
	RCALL SUBOPT_0x15
	RCALL __MULF12
	RCALL __PUTPARD1
	RCALL _log
	__GETD2N 0x43FA4000
	RCALL SUBOPT_0x16
; 0000 00E8         comp_cst[0] = (alt/91)+33;
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	RCALL __DIVW21
	SUBI R30,-LOW(33)
	STS  _comp_cst,R30
; 0000 00E9         comp_cst[1] = (alt%91)+33;
	MOVW R26,R16
	LDI  R30,LOW(91)
	LDI  R31,HIGH(91)
	RCALL __MODW21
	SUBI R30,-LOW(33)
	__PUTB1MN _comp_cst,1
; 0000 00EA }
	RJMP _0x20A0008
;
;void normal_alt(void)
; 0000 00ED {
_normal_alt:
; 0000 00EE 	norm_alt[3]=(altitude/100000)+'0';
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x17
	RCALL __DIVD21U
	SUBI R30,-LOW(48)
	__PUTB1MN _norm_alt,3
; 0000 00EF         norm_alt[4]=((altitude%100000)/10000)+'0';
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x17
	RCALL __MODD21U
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x2710
	RCALL __DIVD21U
	SUBI R30,-LOW(48)
	__PUTB1MN _norm_alt,4
; 0000 00F0         norm_alt[5]=((altitude%10000)/1000)+'0';
	RCALL SUBOPT_0x13
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
; 0000 00F1         norm_alt[6]=((altitude%1000)/100)+'0';
	RCALL SUBOPT_0x13
	MOVW R26,R30
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MODW21U
	RCALL SUBOPT_0x18
	RCALL __DIVW21U
	SUBI R30,-LOW(48)
	__PUTB1MN _norm_alt,6
; 0000 00F2         norm_alt[7]=((altitude%100)/10)+'0';
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x18
	RCALL __MODW21U
	RCALL SUBOPT_0x19
	RCALL __DIVW21U
	SUBI R30,-LOW(48)
	__PUTB1MN _norm_alt,7
; 0000 00F3         norm_alt[8]=(altitude%10)+'0';
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x19
	RCALL __MODW21U
	SUBI R30,-LOW(48)
	__PUTB1MN _norm_alt,8
; 0000 00F4 }
	RET
;
;void calc_tel_data(void)
; 0000 00F7 {
_calc_tel_data:
; 0000 00F8 	int adc;
; 0000 00F9 
; 0000 00FA         seq_num[0]=(seq/100)+'0';
	RCALL __SAVELOCR2
;	adc -> R16,R17
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
	STS  _seq_num,R30
; 0000 00FB         seq_num[1]=((seq%100)/10)+'0';
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1B
	__PUTB1MN _seq_num,1
; 0000 00FC         seq_num[2]=(seq%10)+'0';
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1E
	__PUTB1MN _seq_num,2
; 0000 00FD 
; 0000 00FE         adc=0.25*read_adc(2);
	LDI  R30,LOW(2)
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1F
; 0000 00FF         ch1[0]=(adc/100)+'0';
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1B
	STS  _ch1,R30
; 0000 0100         ch1[1]=((adc%100)/10)+'0';
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1B
	__PUTB1MN _ch1,1
; 0000 0101         ch1[2]=(adc%10)+'0';
	RCALL SUBOPT_0x22
	__PUTB1MN _ch1,2
; 0000 0102 
; 0000 0103         adc=0.25*read_adc(3);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1F
; 0000 0104         ch2[0]=(adc/100)+'0';
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1B
	STS  _ch2,R30
; 0000 0105         ch2[1]=((adc%100)/10)+'0';
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1B
	__PUTB1MN _ch2,1
; 0000 0106         ch2[2]=(adc%10)+'0';
	RCALL SUBOPT_0x22
	__PUTB1MN _ch2,2
; 0000 0107 
; 0000 0108         adc=0.25*read_adc(4);
	LDI  R30,LOW(4)
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1F
; 0000 0109         ch3[0]=(adc/100)+'0';
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1B
	STS  _ch3,R30
; 0000 010A         ch3[1]=((adc%100)/10)+'0';
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1B
	__PUTB1MN _ch3,1
; 0000 010B         ch3[2]=(adc%10)+'0';
	RCALL SUBOPT_0x22
	__PUTB1MN _ch3,2
; 0000 010C 
; 0000 010D         adc=altitude/66;
	RCALL SUBOPT_0x13
	MOVW R26,R30
	LDI  R30,LOW(66)
	LDI  R31,HIGH(66)
	RCALL __DIVW21U
	MOVW R16,R30
; 0000 010E         alti[0]=(adc/100)+'0';
	MOVW R26,R16
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x1B
	STS  _alti,R30
; 0000 010F         alti[1]=((adc%100)/10)+'0';
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x1B
	__PUTB1MN _alti,1
; 0000 0110         alti[2]=(adc%10)+'0';
	RCALL SUBOPT_0x22
	__PUTB1MN _alti,2
; 0000 0111 
; 0000 0112         seq++;
	RCALL SUBOPT_0x1D
	ADIW R30,1
	RCALL __EEPROMWRW
	SBIW R30,1
; 0000 0113 	if(seq==999)seq=0;
	RCALL SUBOPT_0x1D
	CPI  R30,LOW(0x3E7)
	LDI  R26,HIGH(0x3E7)
	CPC  R31,R26
	BRNE _0x17
	LDI  R26,LOW(_seq)
	LDI  R27,HIGH(_seq)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
; 0000 0114 
; 0000 0115         altitude+=3;
_0x17:
	RCALL SUBOPT_0x13
	ADIW R30,3
	LDI  R26,LOW(_altitude)
	LDI  R27,HIGH(_altitude)
	RCALL __EEPROMWRW
; 0000 0116         if(altitude==65535)altitude=0;
	RCALL SUBOPT_0x13
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x18
	LDI  R26,LOW(_altitude)
	LDI  R27,HIGH(_altitude)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	RCALL __EEPROMWRW
; 0000 0117 }
_0x18:
_0x20A0008:
	RCALL __LOADLOCR2P
	RET
;
;void kirim_add_aprs(void)
; 0000 011A {
_kirim_add_aprs:
; 0000 011B 	char i;
; 0000 011C 
; 0000 011D         for(i=0;i<7;i++)kirim_karakter(add_aprs[i]);
	RCALL SUBOPT_0x23
;	i -> R17
_0x1A:
	CPI  R17,7
	BRGE _0x1B
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_add_aprs)
	SBCI R27,HIGH(-_add_aprs)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0x1A
_0x1B:
; 0000 011E }
	RJMP _0x20A0007
;
;void kirim_add_tel(void)
; 0000 0121 {
_kirim_add_tel:
; 0000 0122 	char i;
; 0000 0123 
; 0000 0124         for(i=0;i<7;i++)kirim_karakter(add_tel[i]);
	RCALL SUBOPT_0x23
;	i -> R17
_0x1D:
	CPI  R17,7
	BRGE _0x1E
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_add_tel)
	SBCI R27,HIGH(-_add_tel)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0x1D
_0x1E:
; 0000 0125 }
	RJMP _0x20A0007
;
;void kirim_add_beacon(void)
; 0000 0128 {
_kirim_add_beacon:
; 0000 0129 	char i;
; 0000 012A 
; 0000 012B         for(i=0;i<7;i++)kirim_karakter(add_beacon[i]);
	RCALL SUBOPT_0x23
;	i -> R17
_0x20:
	CPI  R17,7
	BRGE _0x21
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_add_beacon)
	SBCI R27,HIGH(-_add_beacon)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0x20
_0x21:
; 0000 012C }
	RJMP _0x20A0007
;
;void kirim_ax25_head(void)
; 0000 012F {
_kirim_ax25_head:
; 0000 0130 	char i;
; 0000 0131 
; 0000 0132         for(i=0;i<6;i++)kirim_karakter(mycall[i]<<1);
	RCALL SUBOPT_0x23
;	i -> R17
_0x23:
	CPI  R17,6
	BRGE _0x24
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_mycall)
	SBCI R27,HIGH(-_mycall)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x23
_0x24:
; 0000 0133 if(((mydigi1[0]>47)&&(mydigi1[0]<58))||((mydigi1[0]>64)&&(mydigi1[0]<91)))
	LDI  R26,LOW(_mydigi1)
	LDI  R27,HIGH(_mydigi1)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x30)
	BRLO _0x26
	CPI  R30,LOW(0x3A)
	BRLO _0x28
_0x26:
	CPI  R30,LOW(0x41)
	BRLO _0x29
	CPI  R30,LOW(0x5B)
	BRLO _0x28
_0x29:
	RJMP _0x25
_0x28:
; 0000 0134         {
; 0000 0135         	kirim_karakter(mycall[6]<<1);
	__POINTW2MN _mycall,6
	RCALL SUBOPT_0x26
; 0000 0136                 for(i=0;i<6;i++)kirim_karakter(mydigi1[i]<<1);
	LDI  R17,LOW(0)
_0x2D:
	CPI  R17,6
	BRGE _0x2E
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_mydigi1)
	SBCI R27,HIGH(-_mydigi1)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x2D
_0x2E:
; 0000 0137 if(((mydigi2[0]>47)&&(mydigi2[0]<58))||((mydigi2[0]>64)&&(mydigi2[0]<91)))
	LDI  R26,LOW(_mydigi2)
	LDI  R27,HIGH(_mydigi2)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x30)
	BRLO _0x30
	CPI  R30,LOW(0x3A)
	BRLO _0x32
_0x30:
	CPI  R30,LOW(0x41)
	BRLO _0x33
	CPI  R30,LOW(0x5B)
	BRLO _0x32
_0x33:
	RJMP _0x2F
_0x32:
; 0000 0138         	{
; 0000 0139         		kirim_karakter(mydigi1[6]<<1);
	__POINTW2MN _mydigi1,6
	RCALL SUBOPT_0x26
; 0000 013A                 	for(i=0;i<6;i++)kirim_karakter(mydigi2[i]<<1);
	LDI  R17,LOW(0)
_0x37:
	CPI  R17,6
	BRGE _0x38
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_mydigi2)
	SBCI R27,HIGH(-_mydigi2)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x37
_0x38:
; 0000 013B if(((mydigi3[0]>47)&&(mydigi3[0]<58))||((mydigi3[0]>64)&&(mydigi3[0]<91)))
	LDI  R26,LOW(_mydigi3)
	LDI  R27,HIGH(_mydigi3)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x30)
	BRLO _0x3A
	CPI  R30,LOW(0x3A)
	BRLO _0x3C
_0x3A:
	CPI  R30,LOW(0x41)
	BRLO _0x3D
	CPI  R30,LOW(0x5B)
	BRLO _0x3C
_0x3D:
	RJMP _0x39
_0x3C:
; 0000 013C         		{
; 0000 013D         			kirim_karakter(mydigi2[6]<<1);
	__POINTW2MN _mydigi2,6
	RCALL SUBOPT_0x26
; 0000 013E                 		for(i=0;i<6;i++)kirim_karakter(mydigi3[i]<<1);
	LDI  R17,LOW(0)
_0x41:
	CPI  R17,6
	BRGE _0x42
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_mydigi3)
	SBCI R27,HIGH(-_mydigi3)
	RCALL SUBOPT_0x26
	SUBI R17,-1
	RJMP _0x41
_0x42:
; 0000 013F kirim_karakter((mydigi3[6]<<1)+1);
	__POINTW2MN _mydigi3,6
	RJMP _0x1F2
; 0000 0140         		}
; 0000 0141         		else
_0x39:
; 0000 0142         		{
; 0000 0143         			kirim_karakter((mydigi2[6]<<1)+1);
	__POINTW2MN _mydigi2,6
_0x1F2:
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x27
; 0000 0144         		}
; 0000 0145         	}
; 0000 0146         	else
	RJMP _0x44
_0x2F:
; 0000 0147         	{
; 0000 0148         		kirim_karakter((mydigi1[6]<<1)+1);
	__POINTW2MN _mydigi1,6
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x27
; 0000 0149         	}
_0x44:
; 0000 014A         }
; 0000 014B         else
	RJMP _0x45
_0x25:
; 0000 014C         {
; 0000 014D         	kirim_karakter((mycall[6]<<1)+1);
	__POINTW2MN _mycall,6
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x27
; 0000 014E         }
_0x45:
; 0000 014F 	kirim_karakter(CONTROL_FIELD_);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x28
; 0000 0150 	kirim_karakter(PROTOCOL_ID_);
	LDI  R30,LOW(240)
	RCALL SUBOPT_0x28
; 0000 0151 }
	RJMP _0x20A0007
;
;void send_batt(void)
; 0000 0154 {
_send_batt:
; 0000 0155 	if(volt[1]!=' ')kirim_karakter(volt[1]);
	__GETB2MN _volt,1
	CPI  R26,LOW(0x20)
	BREQ _0x46
	__GETB1MN _volt,1
	RJMP _0x1F3
; 0000 0156         else		kirim_karakter('0');
_0x46:
	LDI  R30,LOW(48)
_0x1F3:
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 0157         kirim_karakter(volt[2]);
	__GETB1MN _volt,2
	RCALL SUBOPT_0x28
; 0000 0158         kirim_karakter(volt[4]);
	__GETB1MN _volt,4
	RJMP _0x20A0006
; 0000 0159 }
;
;void send_temp(void)
; 0000 015C {
_send_temp:
; 0000 015D 	if(temp[1]!=' ')kirim_karakter(temp[1]);
	__GETB2MN _temp,1
	CPI  R26,LOW(0x20)
	BREQ _0x48
	__GETB1MN _temp,1
	RJMP _0x1F4
; 0000 015E         else		kirim_karakter('0');
_0x48:
	LDI  R30,LOW(48)
_0x1F4:
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 015F         kirim_karakter(temp[2]);
	__GETB1MN _temp,2
	RCALL SUBOPT_0x28
; 0000 0160         kirim_karakter(temp[4]);
	__GETB1MN _temp,4
	RJMP _0x20A0006
; 0000 0161 }
;void send_alti(void)
; 0000 0163 {
_send_alti:
; 0000 0164 	char i;
; 0000 0165         for(i=0;i<3;i++)kirim_karakter(alti[i]);
	RCALL SUBOPT_0x23
;	i -> R17
_0x4B:
	CPI  R17,3
	BRGE _0x4C
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_alti)
	SBCI R31,HIGH(-_alti)
	RCALL SUBOPT_0x2A
	SUBI R17,-1
	RJMP _0x4B
_0x4C:
; 0000 0166 }
	RJMP _0x20A0007
;
;void send_ch1(void)
; 0000 0169 {
_send_ch1:
; 0000 016A 	char i;
; 0000 016B         for(i=0;i<3;i++)kirim_karakter(ch1[i]);
	RCALL SUBOPT_0x23
;	i -> R17
_0x4E:
	CPI  R17,3
	BRGE _0x4F
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_ch1)
	SBCI R31,HIGH(-_ch1)
	RCALL SUBOPT_0x2A
	SUBI R17,-1
	RJMP _0x4E
_0x4F:
; 0000 016C }
	RJMP _0x20A0007
;
;void send_ch2(void)
; 0000 016F {
_send_ch2:
; 0000 0170 	char i;
; 0000 0171         for(i=0;i<3;i++)kirim_karakter(ch2[i]);
	RCALL SUBOPT_0x23
;	i -> R17
_0x51:
	CPI  R17,3
	BRGE _0x52
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_ch2)
	SBCI R31,HIGH(-_ch2)
	RCALL SUBOPT_0x2A
	SUBI R17,-1
	RJMP _0x51
_0x52:
; 0000 0172 }
	RJMP _0x20A0007
;
;void send_ch3(void)
; 0000 0175 {
_send_ch3:
; 0000 0176 	char i;
; 0000 0177         for(i=0;i<3;i++)kirim_karakter(ch3[i]);
	RCALL SUBOPT_0x23
;	i -> R17
_0x54:
	CPI  R17,3
	BRGE _0x55
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_ch3)
	SBCI R31,HIGH(-_ch3)
	RCALL SUBOPT_0x2A
	SUBI R17,-1
	RJMP _0x54
_0x55:
; 0000 0178 }
	RJMP _0x20A0007
;
;void kirim_tele_data(void)
; 0000 017B {
_kirim_tele_data:
; 0000 017C 	char i;
; 0000 017D 
; 0000 017E         kirim_add_tel();
	RCALL SUBOPT_0x2B
;	i -> R17
; 0000 017F         kirim_ax25_head();
; 0000 0180         kirim_karakter('T');
	LDI  R30,LOW(84)
	RCALL SUBOPT_0x28
; 0000 0181         kirim_karakter('#');
	LDI  R30,LOW(35)
	RCALL SUBOPT_0x28
; 0000 0182         for(i=0;i<3;i++)kirim_karakter(seq_num[i]);
	LDI  R17,LOW(0)
_0x57:
	CPI  R17,3
	BRGE _0x58
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_seq_num)
	SBCI R31,HIGH(-_seq_num)
	RCALL SUBOPT_0x2A
	SUBI R17,-1
	RJMP _0x57
_0x58:
; 0000 0184 kirim_karakter(',');
	RCALL SUBOPT_0x2C
; 0000 0185         if     (pri1=='B')send_batt();
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x42)
	BRNE _0x59
	RCALL _send_batt
; 0000 0186         else if(pri1=='T')send_temp();
	RJMP _0x5A
_0x59:
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x54)
	BRNE _0x5B
	RCALL _send_temp
; 0000 0187         else if(pri1=='A')send_alti();
	RJMP _0x5C
_0x5B:
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x41)
	BRNE _0x5D
	RCALL _send_alti
; 0000 0188         else if(pri1=='1')send_ch1();
	RJMP _0x5E
_0x5D:
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x31)
	BRNE _0x5F
	RCALL _send_ch1
; 0000 0189         else if(pri1=='2')send_ch2();
	RJMP _0x60
_0x5F:
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x32)
	BRNE _0x61
	RCALL _send_ch2
; 0000 018A         else if(pri1=='3')send_ch3();
	RJMP _0x62
_0x61:
	RCALL SUBOPT_0x2D
	CPI  R30,LOW(0x33)
	BRNE _0x63
	RCALL _send_ch3
; 0000 018B 
; 0000 018C         kirim_karakter(',');
_0x63:
_0x62:
_0x60:
_0x5E:
_0x5C:
_0x5A:
	RCALL SUBOPT_0x2C
; 0000 018D         if     (pri2=='B')send_batt();
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x42)
	BRNE _0x64
	RCALL _send_batt
; 0000 018E         else if(pri2=='T')send_temp();
	RJMP _0x65
_0x64:
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x54)
	BRNE _0x66
	RCALL _send_temp
; 0000 018F         else if(pri2=='A')send_alti();
	RJMP _0x67
_0x66:
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x41)
	BRNE _0x68
	RCALL _send_alti
; 0000 0190         else if(pri2=='1')send_ch1();
	RJMP _0x69
_0x68:
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x31)
	BRNE _0x6A
	RCALL _send_ch1
; 0000 0191         else if(pri2=='2')send_ch2();
	RJMP _0x6B
_0x6A:
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x32)
	BRNE _0x6C
	RCALL _send_ch2
; 0000 0192         else if(pri2=='3')send_ch3();
	RJMP _0x6D
_0x6C:
	RCALL SUBOPT_0x2E
	CPI  R30,LOW(0x33)
	BRNE _0x6E
	RCALL _send_ch3
; 0000 0193 
; 0000 0194         kirim_karakter(',');
_0x6E:
_0x6D:
_0x6B:
_0x69:
_0x67:
_0x65:
	RCALL SUBOPT_0x2C
; 0000 0195         if     (pri3=='B')send_batt();
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x42)
	BRNE _0x6F
	RCALL _send_batt
; 0000 0196         else if(pri3=='T')send_temp();
	RJMP _0x70
_0x6F:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x54)
	BRNE _0x71
	RCALL _send_temp
; 0000 0197         else if(pri3=='A')send_alti();
	RJMP _0x72
_0x71:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x41)
	BRNE _0x73
	RCALL _send_alti
; 0000 0198         else if(pri3=='1')send_ch1();
	RJMP _0x74
_0x73:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x31)
	BRNE _0x75
	RCALL _send_ch1
; 0000 0199         else if(pri3=='2')send_ch2();
	RJMP _0x76
_0x75:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x32)
	BRNE _0x77
	RCALL _send_ch2
; 0000 019A         else if(pri3=='3')send_ch3();
	RJMP _0x78
_0x77:
	RCALL SUBOPT_0x2F
	CPI  R30,LOW(0x33)
	BRNE _0x79
	RCALL _send_ch3
; 0000 019B 
; 0000 019C         kirim_karakter(',');
_0x79:
_0x78:
_0x76:
_0x74:
_0x72:
_0x70:
	RCALL SUBOPT_0x2C
; 0000 019D         if     (pri4=='B')send_batt();
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x42)
	BRNE _0x7A
	RCALL _send_batt
; 0000 019E         else if(pri4=='T')send_temp();
	RJMP _0x7B
_0x7A:
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x54)
	BRNE _0x7C
	RCALL _send_temp
; 0000 019F         else if(pri4=='A')send_alti();
	RJMP _0x7D
_0x7C:
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x41)
	BRNE _0x7E
	RCALL _send_alti
; 0000 01A0         else if(pri4=='1')send_ch1();
	RJMP _0x7F
_0x7E:
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x31)
	BRNE _0x80
	RCALL _send_ch1
; 0000 01A1         else if(pri4=='2')send_ch2();
	RJMP _0x81
_0x80:
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x32)
	BRNE _0x82
	RCALL _send_ch2
; 0000 01A2         else if(pri4=='3')send_ch3();
	RJMP _0x83
_0x82:
	RCALL SUBOPT_0x30
	CPI  R30,LOW(0x33)
	BRNE _0x84
	RCALL _send_ch3
; 0000 01A3 
; 0000 01A4         kirim_karakter(',');
_0x84:
_0x83:
_0x81:
_0x7F:
_0x7D:
_0x7B:
	RCALL SUBOPT_0x2C
; 0000 01A5         if     (pri5=='B')send_batt();
	RCALL SUBOPT_0x31
	CPI  R30,LOW(0x42)
	BRNE _0x85
	RCALL _send_batt
; 0000 01A6         else if(pri5=='T')send_temp();
	RJMP _0x86
_0x85:
	RCALL SUBOPT_0x31
	CPI  R30,LOW(0x54)
	BRNE _0x87
	RCALL _send_temp
; 0000 01A7         else if(pri5=='A')send_alti();
	RJMP _0x88
_0x87:
	RCALL SUBOPT_0x31
	CPI  R30,LOW(0x41)
	BRNE _0x89
	RCALL _send_alti
; 0000 01A8         else if(pri5=='1')send_ch1();
	RJMP _0x8A
_0x89:
	RCALL SUBOPT_0x31
	CPI  R30,LOW(0x31)
	BRNE _0x8B
	RCALL _send_ch1
; 0000 01A9         else if(pri5=='2')send_ch2();
	RJMP _0x8C
_0x8B:
	RCALL SUBOPT_0x31
	CPI  R30,LOW(0x32)
	BRNE _0x8D
	RCALL _send_ch2
; 0000 01AA         else if(pri5=='3')send_ch3();
	RJMP _0x8E
_0x8D:
	RCALL SUBOPT_0x31
	CPI  R30,LOW(0x33)
	BRNE _0x8F
	RCALL _send_ch3
; 0000 01AB 
; 0000 01AC         kirim_karakter(',');
_0x8F:
_0x8E:
_0x8C:
_0x8A:
_0x88:
_0x86:
	RCALL SUBOPT_0x2C
; 0000 01AD         for(i=0;i<8;i++)kirim_karakter('0');
	LDI  R17,LOW(0)
_0x91:
	CPI  R17,8
	BRGE _0x92
	LDI  R30,LOW(48)
	RCALL SUBOPT_0x28
	SUBI R17,-1
	RJMP _0x91
_0x92:
; 0000 01AE }
	RJMP _0x20A0007
;
;void kirim_tele_param(void)
; 0000 01B1 {
_kirim_tele_param:
; 0000 01B2 	char i;
; 0000 01B3 
; 0000 01B4         kirim_add_tel();
	RCALL SUBOPT_0x2B
;	i -> R17
; 0000 01B5         kirim_ax25_head();
; 0000 01B6         for(i=0;i<11;i++)	{kirim_karakter(message_head[i]);}
	LDI  R17,LOW(0)
_0x94:
	CPI  R17,11
	BRGE _0x95
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x32
	SUBI R17,-1
	RJMP _0x94
_0x95:
; 0000 01B7         for(i=0;i<sizeof(param);i++)	{kirim_karakter(param[i]);}
	LDI  R17,LOW(0)
_0x97:
	MOV  R26,R17
	LDI  R30,LOW(22)
	RCALL SUBOPT_0x33
	BRGE _0x98
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_param)
	SBCI R27,HIGH(-_param)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0x97
_0x98:
; 0000 01B8 }
	RJMP _0x20A0007
;
;void kirim_tele_unit(void)
; 0000 01BB {
_kirim_tele_unit:
; 0000 01BC 	char i;
; 0000 01BD 
; 0000 01BE         kirim_add_tel();
	RCALL SUBOPT_0x2B
;	i -> R17
; 0000 01BF         kirim_ax25_head();
; 0000 01C0         for(i=0;i<11;i++)	{kirim_karakter(message_head[i]);}
	LDI  R17,LOW(0)
_0x9A:
	CPI  R17,11
	BRGE _0x9B
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x32
	SUBI R17,-1
	RJMP _0x9A
_0x9B:
; 0000 01C1         for(i=0;i<sizeof(unit);i++)	{kirim_karakter(unit[i]);}
	LDI  R17,LOW(0)
_0x9D:
	MOV  R26,R17
	LDI  R30,LOW(21)
	RCALL SUBOPT_0x33
	BRGE _0x9E
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_unit)
	SBCI R27,HIGH(-_unit)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0x9D
_0x9E:
; 0000 01C2 }
	RJMP _0x20A0007
;
;void kirim_tele_eqns(void)
; 0000 01C5 {
_kirim_tele_eqns:
; 0000 01C6 	char i;
; 0000 01C7 
; 0000 01C8         kirim_add_tel();
	RCALL SUBOPT_0x2B
;	i -> R17
; 0000 01C9         kirim_ax25_head();
; 0000 01CA         for(i=0;i<11;i++)	{kirim_karakter(message_head[i]);}
	LDI  R17,LOW(0)
_0xA0:
	CPI  R17,11
	BRGE _0xA1
	RCALL SUBOPT_0x24
	RCALL SUBOPT_0x32
	SUBI R17,-1
	RJMP _0xA0
_0xA1:
; 0000 01CB         for(i=0;i<sizeof(eqns);i++)	{kirim_karakter(eqns[i]);}
	LDI  R17,LOW(0)
_0xA3:
	MOV  R26,R17
	LDI  R30,LOW(28)
	RCALL SUBOPT_0x33
	BRGE _0xA4
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_eqns)
	SBCI R27,HIGH(-_eqns)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0xA3
_0xA4:
; 0000 01CC }
	RJMP _0x20A0007
;
;void kirim_status(void)
; 0000 01CF {
_kirim_status:
; 0000 01D0 	char i;
; 0000 01D1 
; 0000 01D2         kirim_add_aprs();
	ST   -Y,R17
;	i -> R17
	RCALL _kirim_add_aprs
; 0000 01D3         kirim_ax25_head();
	RCALL _kirim_ax25_head
; 0000 01D4         kirim_karakter(TD_STATUS_);
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x28
; 0000 01D5 	for(i=0;i<statsize;i++)
	LDI  R17,LOW(0)
_0xA6:
	RCALL SUBOPT_0x34
	BRGE _0xA7
; 0000 01D6         {
; 0000 01D7         	if(status[i]!=0)kirim_karakter(status[i]);
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_status)
	SBCI R27,HIGH(-_status)
	RCALL __EEPROMRDB
	CPI  R30,0
	BREQ _0xA8
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_status)
	SBCI R27,HIGH(-_status)
	RCALL SUBOPT_0x25
; 0000 01D8         }
_0xA8:
	SUBI R17,-1
	RJMP _0xA6
_0xA7:
; 0000 01D9 }
	RJMP _0x20A0007
;
;void kirim_beacon(void)
; 0000 01DC {
_kirim_beacon:
; 0000 01DD 	char i;
; 0000 01DE 
; 0000 01DF         kirim_add_beacon();
	ST   -Y,R17
;	i -> R17
	RCALL _kirim_add_beacon
; 0000 01E0         kirim_ax25_head();
	RCALL _kirim_ax25_head
; 0000 01E1         for(i=0;i<statsize;i++)kirim_karakter(status[i]);
	LDI  R17,LOW(0)
_0xAA:
	RCALL SUBOPT_0x34
	BRGE _0xAB
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_status)
	SBCI R27,HIGH(-_status)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0xAA
_0xAB:
; 0000 01E2 }
	RJMP _0x20A0007
;
;void prepare(void)
; 0000 01E5 {
_prepare:
; 0000 01E6 	char i;
; 0000 01E7 
; 0000 01E8         PTT = 1;
	ST   -Y,R17
;	i -> R17
	SBI  0x18,5
; 0000 01E9 	delay_ms(100);
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x35
	RCALL _delay_ms
; 0000 01EA 	for(i=0;i<TX_DELAY_;i++)kirim_karakter(0x00);
	LDI  R17,LOW(0)
_0xAF:
	CPI  R17,45
	BRGE _0xB0
	LDI  R30,LOW(0)
	RCALL SUBOPT_0x28
	SUBI R17,-1
	RJMP _0xAF
_0xB0:
; 0000 01EB kirim_karakter(0x7E);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x28
; 0000 01EC 	bit_stuff = 0;
	RCALL SUBOPT_0x36
; 0000 01ED         crc = 0xFFFF;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R8,R30
; 0000 01EE }
	RJMP _0x20A0007
;
;void kirim_paket(void)
; 0000 01F1 {
_kirim_paket:
; 0000 01F2 	char i;
; 0000 01F3 
; 0000 01F4         read_temp();
	ST   -Y,R17
;	i -> R17
	RCALL _read_temp
; 0000 01F5         read_volt();
	RCALL _read_volt
; 0000 01F6         base91_lat();
	RCALL _base91_lat
; 0000 01F7         base91_long();
	RCALL _base91_long
; 0000 01F8         base91_alt();
	RCALL _base91_alt
; 0000 01F9         calc_tel_data();
	RCALL _calc_tel_data
; 0000 01FA         normal_alt();
	RCALL _normal_alt
; 0000 01FB 
; 0000 01FC 	MERAH = 1;
	SBI  0x12,6
; 0000 01FD         HIJAU = 0;
	CBI  0x12,7
; 0000 01FE 
; 0000 01FF         beacon_stat++;
	INC  R7
; 0000 0200         prepare();
	RCALL _prepare
; 0000 0201         if((beacon_stat==6)||((beacon_stat>7)&&((beacon_stat%m_int)==0)))
	LDI  R30,LOW(6)
	CP   R30,R7
	BREQ _0xB6
	RCALL SUBOPT_0x37
	BRGE _0xB7
	RCALL SUBOPT_0x38
	BREQ _0xB6
_0xB7:
	RJMP _0xB5
_0xB6:
; 0000 0202         {
; 0000 0203         	kirim_status();
	RCALL _kirim_status
; 0000 0204                 goto oke;
	RJMP _0xBA
; 0000 0205         }
; 0000 0206         if((beacon_stat==2)||((beacon_stat>7)&&((beacon_stat%tel_int)==0)))
_0xB5:
	LDI  R30,LOW(2)
	CP   R30,R7
	BREQ _0xBC
	RCALL SUBOPT_0x37
	BRGE _0xBD
	RCALL SUBOPT_0x39
	BREQ _0xBC
_0xBD:
	RJMP _0xBB
_0xBC:
; 0000 0207         {
; 0000 0208         	if(sendtel=='N')
	LDI  R26,LOW(_sendtel)
	LDI  R27,HIGH(_sendtel)
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x4E)
	BRNE _0xC0
; 0000 0209                 {
; 0000 020A                 	if(beacon_stat==2)beacon_stat=6;
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0xC1
	LDI  R30,LOW(6)
	MOV  R7,R30
; 0000 020B                         goto oke;
_0xC1:
	RJMP _0xBA
; 0000 020C                 }
; 0000 020D                 kirim_tele_data();
_0xC0:
	RCALL _kirim_tele_data
; 0000 020E                 goto oke;
	RJMP _0xBA
; 0000 020F         }
; 0000 0210         if((beacon_stat==1)||((beacon_stat>7)&&((beacon_stat%m_int)!=0)&&((beacon_stat%tel_int)!=0)))
_0xBB:
	LDI  R30,LOW(1)
	CP   R30,R7
	BREQ _0xC3
	RCALL SUBOPT_0x37
	BRGE _0xC4
	RCALL SUBOPT_0x38
	BREQ _0xC4
	RCALL SUBOPT_0x39
	BRNE _0xC3
_0xC4:
	RJMP _0xC2
_0xC3:
; 0000 0211         {
; 0000 0212         	kirim_add_aprs();
	RCALL _kirim_add_aprs
; 0000 0213         	kirim_ax25_head();
	RCALL _kirim_ax25_head
; 0000 0214         	kirim_karakter(TD_POSISI_);
	LDI  R30,LOW(61)
	RCALL SUBOPT_0x28
; 0000 0215         	if(compstat=='Y')
	LDI  R26,LOW(_compstat)
	LDI  R27,HIGH(_compstat)
	RCALL SUBOPT_0x3A
	BRNE _0xC7
; 0000 0216                 {
; 0000 0217         		kirim_karakter(SYM_TAB_OVL_);
	LDI  R26,LOW(_SYM_TAB_OVL_)
	LDI  R27,HIGH(_SYM_TAB_OVL_)
	RCALL SUBOPT_0x25
; 0000 0218         		for(i=0;i<4;i++)kirim_karakter(comp_lat[i]);
	LDI  R17,LOW(0)
_0xC9:
	CPI  R17,4
	BRGE _0xCA
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_comp_lat)
	SBCI R27,HIGH(-_comp_lat)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0xC9
_0xCA:
; 0000 0219 for(i=0;i<4;i++)kirim_karakter(comp_long[i]);
	LDI  R17,LOW(0)
_0xCC:
	CPI  R17,4
	BRGE _0xCD
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_comp_long)
	SBCI R27,HIGH(-_comp_long)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0xCC
_0xCD:
; 0000 021A kirim_karakter(SYM_CODE_);
	LDI  R26,LOW(_SYM_CODE_)
	LDI  R27,HIGH(_SYM_CODE_)
	RCALL SUBOPT_0x25
; 0000 021B         		for(i=0;i<3;i++)kirim_karakter(comp_cst[i]);
	LDI  R17,LOW(0)
_0xCF:
	CPI  R17,3
	BRGE _0xD0
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_comp_cst)
	SBCI R31,HIGH(-_comp_cst)
	RCALL SUBOPT_0x2A
	SUBI R17,-1
	RJMP _0xCF
_0xD0:
; 0000 021C }
; 0000 021D                 else
	RJMP _0xD1
_0xC7:
; 0000 021E                 {
; 0000 021F                         for(i=0;i<8;i++)kirim_karakter(posisi_lat[i]);
	LDI  R17,LOW(0)
_0xD3:
	CPI  R17,8
	BRGE _0xD4
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_posisi_lat)
	SBCI R27,HIGH(-_posisi_lat)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0xD3
_0xD4:
; 0000 0220 kirim_karakter(SYM_TAB_OVL_);
	LDI  R26,LOW(_SYM_TAB_OVL_)
	LDI  R27,HIGH(_SYM_TAB_OVL_)
	RCALL SUBOPT_0x25
; 0000 0221 			for(i=0;i<9;i++)kirim_karakter(posisi_long[i]);
	LDI  R17,LOW(0)
_0xD6:
	CPI  R17,9
	BRGE _0xD7
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_posisi_long)
	SBCI R27,HIGH(-_posisi_long)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0xD6
_0xD7:
; 0000 0222 kirim_karakter(SYM_CODE_);
	LDI  R26,LOW(_SYM_CODE_)
	LDI  R27,HIGH(_SYM_CODE_)
	RCALL SUBOPT_0x25
; 0000 0223                         if(sendalt=='Y')
	LDI  R26,LOW(_sendalt)
	LDI  R27,HIGH(_sendalt)
	RCALL SUBOPT_0x3A
	BRNE _0xD8
; 0000 0224                         {
; 0000 0225                 		for(i=0;i<9;i++)kirim_karakter(norm_alt[i]);
	LDI  R17,LOW(0)
_0xDA:
	CPI  R17,9
	BRGE _0xDB
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_norm_alt)
	SBCI R31,HIGH(-_norm_alt)
	RCALL SUBOPT_0x2A
	SUBI R17,-1
	RJMP _0xDA
_0xDB:
; 0000 0226 kirim_karakter(' ');
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x28
; 0000 0227                         }
; 0000 0228                 }
_0xD8:
_0xD1:
; 0000 0229                 if(tempincomm=='Y')
	LDI  R26,LOW(_tempincomm)
	LDI  R27,HIGH(_tempincomm)
	RCALL SUBOPT_0x3A
	BRNE _0xDC
; 0000 022A                 {for(i=0;i<6;i++){if(temp[i]!=' ')kirim_karakter(temp[i]);}kirim_karakter(' ');}
	LDI  R17,LOW(0)
_0xDE:
	CPI  R17,6
	BRGE _0xDF
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	LD   R26,Z
	CPI  R26,LOW(0x20)
	BREQ _0xE0
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_temp)
	SBCI R31,HIGH(-_temp)
	RCALL SUBOPT_0x2A
_0xE0:
	SUBI R17,-1
	RJMP _0xDE
_0xDF:
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x28
; 0000 022B                 if(battvoltincomm=='Y')
_0xDC:
	LDI  R26,LOW(_battvoltincomm)
	LDI  R27,HIGH(_battvoltincomm)
	RCALL SUBOPT_0x3A
	BRNE _0xE1
; 0000 022C                 {for(i=0;i<6;i++){if(volt[i]!=' ')kirim_karakter(volt[i]);}kirim_karakter(' ');}
	LDI  R17,LOW(0)
_0xE3:
	CPI  R17,6
	BRGE _0xE4
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_volt)
	SBCI R31,HIGH(-_volt)
	LD   R26,Z
	CPI  R26,LOW(0x20)
	BREQ _0xE5
	RCALL SUBOPT_0x29
	SUBI R30,LOW(-_volt)
	SBCI R31,HIGH(-_volt)
	RCALL SUBOPT_0x2A
_0xE5:
	SUBI R17,-1
	RJMP _0xE3
_0xE4:
	LDI  R30,LOW(32)
	RCALL SUBOPT_0x28
; 0000 022D                 for(i=0;i<sizeof(comment);i++)
_0xE1:
	LDI  R17,LOW(0)
_0xE7:
	MOV  R26,R17
	LDI  R30,LOW(100)
	RCALL SUBOPT_0x33
	BRGE _0xE8
; 0000 022E                 kirim_karakter(comment[i]);
	RCALL SUBOPT_0x24
	SUBI R26,LOW(-_comment)
	SBCI R27,HIGH(-_comment)
	RCALL SUBOPT_0x25
	SUBI R17,-1
	RJMP _0xE7
_0xE8:
; 0000 022F goto oke;
	RJMP _0xBA
; 0000 0230         }
; 0000 0231 
; 0000 0232         if(beacon_stat==3)
_0xC2:
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0xE9
; 0000 0233         {
; 0000 0234         	kirim_tele_param();
	RCALL _kirim_tele_param
; 0000 0235                 goto oke;
	RJMP _0xBA
; 0000 0236         }
; 0000 0237         if(beacon_stat==4)
_0xE9:
	LDI  R30,LOW(4)
	CP   R30,R7
	BRNE _0xEA
; 0000 0238         {
; 0000 0239         	kirim_tele_unit();
	RCALL _kirim_tele_unit
; 0000 023A                 goto oke;
	RJMP _0xBA
; 0000 023B         }
; 0000 023C         if(beacon_stat==5)
_0xEA:
	LDI  R30,LOW(5)
	CP   R30,R7
	BRNE _0xEB
; 0000 023D         {
; 0000 023E         	kirim_tele_eqns();
	RCALL _kirim_tele_eqns
; 0000 023F                 goto oke;
	RJMP _0xBA
; 0000 0240         }
; 0000 0241         if(beacon_stat==7)kirim_beacon();
_0xEB:
	RCALL SUBOPT_0x37
	BRNE _0xEC
	RCALL _kirim_beacon
; 0000 0242 
; 0000 0243         oke:
_0xEC:
_0xBA:
; 0000 0244 	kirim_crc();
	RCALL _kirim_crc
; 0000 0245         kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x28
; 0000 0246         kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x28
; 0000 0247         PTT = 0;
	CBI  0x18,5
; 0000 0248 
; 0000 0249         if(beacon_stat==25)beacon_stat=0;
	LDI  R30,LOW(25)
	CP   R30,R7
	BRNE _0xEF
	CLR  R7
; 0000 024A         MERAH = 0;
_0xEF:
	CBI  0x12,6
; 0000 024B         HIJAU = 0;
	CBI  0x12,7
; 0000 024C }
_0x20A0007:
	LD   R17,Y+
	RET
;
;void kirim_crc(void)
; 0000 024F {
_kirim_crc:
; 0000 0250 	static unsigned char crc_lo;
; 0000 0251 	static unsigned char crc_hi;
; 0000 0252 
; 0000 0253         crc_lo = crc ^ 0xFF;
	LDI  R30,LOW(255)
	EOR  R30,R8
	STS  _crc_lo_S0000019000,R30
; 0000 0254 	crc_hi = (crc >> 8) ^ 0xFF;
	MOV  R30,R9
	ANDI R31,HIGH(0x0)
	LDI  R26,LOW(255)
	EOR  R30,R26
	STS  _crc_hi_S0000019000,R30
; 0000 0255 	kirim_karakter(crc_lo);
	LDS  R30,_crc_lo_S0000019000
	RCALL SUBOPT_0x28
; 0000 0256 	kirim_karakter(crc_hi);
	LDS  R30,_crc_hi_S0000019000
_0x20A0006:
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 0257 }
	RET
;
;void kirim_karakter(unsigned char input)
; 0000 025A {
_kirim_karakter:
	PUSH R15
; 0000 025B 	char i;
; 0000 025C 	bit in_bit;
; 0000 025D 
; 0000 025E         for(i=0;i<8;i++)
	RCALL SUBOPT_0x23
;	input -> Y+1
;	i -> R17
;	in_bit -> R15.0
_0xF5:
	CPI  R17,8
	BRGE _0xF6
; 0000 025F         {
; 0000 0260         	in_bit = (input >> i) & 0x01;
	MOV  R30,R17
	LDD  R26,Y+1
	RCALL __LSRB12
	BST  R30,0
	BLD  R15,0
; 0000 0261 		if(input==0x7E)	{bit_stuff = 0;}
	CPI  R26,LOW(0x7E)
	BRNE _0xF7
	RCALL SUBOPT_0x36
; 0000 0262 		else		{hitung_crc(in_bit);}
	RJMP _0xF8
_0xF7:
	LDI  R30,0
	SBRC R15,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _hitung_crc
_0xF8:
; 0000 0263 
; 0000 0264 		if(!in_bit)
	SBRS R15,0
; 0000 0265                 {
; 0000 0266                 	ubah_nada();
	RJMP _0x1F5
; 0000 0267 			bit_stuff = 0;
; 0000 0268                 }
; 0000 0269                 else
; 0000 026A                 {
; 0000 026B                 	set_nada(nada);
	RCALL SUBOPT_0x3B
; 0000 026C 			bit_stuff++;
	LDS  R30,_bit_stuff_G000
	SUBI R30,-LOW(1)
	STS  _bit_stuff_G000,R30
; 0000 026D 			if(bit_stuff==5)
	LDS  R26,_bit_stuff_G000
	CPI  R26,LOW(0x5)
	BRNE _0xFB
; 0000 026E                         {
; 0000 026F                         	ubah_nada();
_0x1F5:
	RCALL _ubah_nada
; 0000 0270                                 bit_stuff = 0;
	RCALL SUBOPT_0x36
; 0000 0271                         }
; 0000 0272                 }
_0xFB:
; 0000 0273         }
	SUBI R17,-1
	RJMP _0xF5
_0xF6:
; 0000 0274 }
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;void hitung_crc(char in_crc)
; 0000 0277 {
_hitung_crc:
; 0000 0278 	static unsigned short xor_in;
; 0000 0279 	xor_in = crc ^ in_crc;
;	in_crc -> Y+0
	LD   R30,Y
	RCALL SUBOPT_0x3C
	EOR  R30,R8
	EOR  R31,R9
	STS  _xor_in_S000001B000,R30
	STS  _xor_in_S000001B000+1,R31
; 0000 027A 	crc >>= 1;
	LSR  R9
	ROR  R8
; 0000 027B 	if(xor_in & 0x01)	crc ^= 0x8408;
	LDS  R30,_xor_in_S000001B000
	ANDI R30,LOW(0x1)
	BREQ _0xFC
	LDI  R30,LOW(33800)
	LDI  R31,HIGH(33800)
	__EORWRR 8,9,30,31
; 0000 027C }
_0xFC:
	RJMP _0x20A0005
;
;void ubah_nada(void)
; 0000 027F {
_ubah_nada:
; 0000 0280 	nada = ~nada;
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 0281         set_nada(nada);
	RCALL SUBOPT_0x3B
; 0000 0282 }
	RET
;
;void set_nada(char i_nada)
; 0000 0285 {
_set_nada:
; 0000 0286 	if(i_nada == _1200)
;	i_nada -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0xFD
; 0000 0287     	{
; 0000 0288         	delay_us(417);
	RCALL SUBOPT_0x3D
; 0000 0289         	AFOUT = 1;
	SBI  0x18,4
; 0000 028A         	delay_us(417);
	RCALL SUBOPT_0x3D
; 0000 028B         	AFOUT = 0;
	RJMP _0x1F6
; 0000 028C     	}
; 0000 028D         else
_0xFD:
; 0000 028E     	{
; 0000 028F         	delay_us(208);
	RCALL SUBOPT_0x3E
; 0000 0290         	AFOUT = 1;
; 0000 0291         	delay_us(209);
; 0000 0292         	AFOUT = 0;
	CBI  0x18,4
; 0000 0293                 delay_us(208);
	RCALL SUBOPT_0x3E
; 0000 0294         	AFOUT = 1;
; 0000 0295         	delay_us(209);
; 0000 0296         	AFOUT = 0;
_0x1F6:
	CBI  0x18,4
; 0000 0297     	}
; 0000 0298 }
	RJMP _0x20A0005
;
;unsigned int read_adc(unsigned char adc_input)
; 0000 029B {
_read_adc:
; 0000 029C 	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	OUT  0x7,R30
; 0000 029D 	delay_us(10);
	__DELAY_USB 37
; 0000 029E 	ADCSRA|=0x40;
	SBI  0x6,6
; 0000 029F 	while ((ADCSRA & 0x10)==0);
_0x10B:
	SBIS 0x6,4
	RJMP _0x10B
; 0000 02A0 	ADCSRA|=0x10;
	SBI  0x6,4
; 0000 02A1 	return ADCW;
	IN   R30,0x4
	IN   R31,0x4+1
	RJMP _0x20A0005
; 0000 02A2 }
;
;void waitComma(void)
; 0000 02A5 {
_waitComma:
; 0000 02A6 	while(getchar()!=',');
_0x10E:
	RCALL _getchar
	CPI  R30,LOW(0x2C)
	BRNE _0x10E
; 0000 02A7 }
	RET
;
;void waitDollar(void)
; 0000 02AA {
_waitDollar:
; 0000 02AB 	while(getchar()!='$');
_0x111:
	RCALL _getchar
	CPI  R30,LOW(0x24)
	BRNE _0x111
; 0000 02AC }
	RET
;
;void waitInvCo(void)
; 0000 02AF {
_waitInvCo:
; 0000 02B0 	while(getchar()!='"');
_0x114:
	RCALL _getchar
	CPI  R30,LOW(0x22)
	BRNE _0x114
; 0000 02B1 }
	RET
;
;/*void mem_display(void)
;{
;	// configuration ECHO
;        // mycall & SSID
;        char k;
;        char f[];
;
;        #asm("cli")
;
;        MERAH=1;
;        HIJAU=0;
;
;        putchar(13);
;        putchar(13);putsf("Your ProTrak! model A Configuration is:");
;        putchar(13);
;        putchar(13);putsf("Callsign");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        for(k=0;k<6;k++)if((mycall[k])!=' ')putchar(mycall[k]);
;        if((mycall[6])>'0')
;        {
;        	putchar('-');
;                itoa(mycall[6]-48,f);
;                puts(f);
;        }
;
;        // digipath
;        putchar(13);putsf("Digi Path(s)");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        if(mydigi1[0]!=0)
;        {
;        	for(k=0;k<6;k++)if((mydigi1[k])!=' ')putchar(mydigi1[k]);
;        	if(mydigi1[6]>'0')
;        	{
;        		putchar('-');
;                        itoa(mydigi1[6]-48,f);
;                        puts(f);
;        	}
;        }
;        if(mydigi2[0]!=0)
;        {
;        	putchar(',');
;        	for(k=0;k<6;k++)if((mydigi2[k])!=' ')putchar(mydigi2[k]);
;        	if(mydigi2[6]>'0')
;        	{
;        		putchar('-');
;                        itoa(mydigi2[6]-48,f);
;                        puts(f);
;        	}
;        }
;        if(mydigi3[0]!=0)
;        {
;        	putchar(',');
;        	for(k=0;k<6;k++)if((mydigi3[k])!=' ')putchar(mydigi3[k]);
;        	if(mydigi3[6]>'0')
;        	{
;        		putchar('-');
;                        itoa(mydigi3[6]-48,f);
;                        puts(f);
;        	}
;        }
;
;        // beacon interval
;        putchar(13);putsf("TX Interval");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        itoa(timeIntv,f);
;        puts(f);
;        putchar(' ');putsf("second(s)");
;        if(timeIntv>9999)putsf(" is too long");
;
;        // symbol code / icon
;        putchar(13);putsf("Symbol / Icon");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        putchar(SYM_CODE_);
;
;        // symbol table / overlay
;        putchar(13);putsf("Symbol Table / Overlay");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        putchar(SYM_TAB_OVL_);
;
;        // comment
;        putchar(13);putsf("Comment");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        for(k=0;k<commsize;k++)
;        {
;        	if(comment[k]!=0)putchar(comment[k]);
;        }
;
;        // status
;        putchar(13);putsf("Status");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        for(k=0;k<statsize;k++)
;        {
;        	if(status[k]!=0)putchar(status[k]);
;        }
;
;        // status interval
;        putchar(13);putsf("Status Interval");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        itoa(m_int,f);
;        puts(f);
;        putchar(' ');putsf("transmission(s)");
;        if(m_int>99)putsf(" is too long");
;
;        // BASE-91 Comppresion ?
;        putchar(13);putsf("BASE-91 ? (Y/N)");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        putchar(compstat);
;
;        // Coordinate
;        putchar(13);putsf("NO GPS Coordinate");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        for(k=0;k<8;k++)putchar(posisi_lat[k]);
;        putchar(',');
;        for(k=0;k<9;k++)putchar(posisi_long[k]);
;
;        //use gps
;        putchar(13);putsf("Use GPS ? (Y/N)");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        putchar(gps);
;
;        // battery volt
;        putchar(13);putsf("Diplay Battery Voltage in Comment ? (Y/N)");
;        putchar(9);putchar(9);putchar(':');
;        putchar(battvoltincomm);
;
;        // temperature
;        putchar(13);putsf("Diplay Temperature in Comment ? (Y/N)");
;        putchar(9);putchar(9);putchar(9);putchar(':');
;        putchar(tempincomm);
;
;        // altitude
;        putchar(13);putsf("Send Altitude ? (Y/N)");
;        putchar(9);putchar(9);putchar(9);putchar(9);putchar(9);putchar(':');
;        putchar(sendalt);
;
;        // send to PC
;        putchar(13);putsf("Send Temperature and Battery Voltage to PC ? (Y/N)");
;        putchar(9);putchar(':');
;        putchar(sendtopc);
;
;        MERAH=0;
;        HIJAU=0;
;
;        #asm("sei")
;}  */
;
;void config(void)
; 0000 0346 {
_config:
; 0000 0347 	char buffer[500];
; 0000 0348         char dbuff[];
; 0000 0349         char cbuff[];
; 0000 034A         char ibuff[5];
; 0000 034B         char tbuff[3];
; 0000 034C         int b,j,k,l;
; 0000 034D 
; 0000 034E         #asm("cli")
	SBIW R28,63
	SBIW R28,63
	SBIW R28,63
	SBIW R28,63
	SBIW R28,2
	SUBI R29,1
	RCALL __SAVELOCR6
;	buffer -> Y+16
;	dbuff -> Y+16
;	cbuff -> Y+16
;	ibuff -> Y+11
;	tbuff -> Y+8
;	b -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
;	l -> Y+6
	cli
; 0000 034F 
; 0000 0350         MERAH=1;
	SBI  0x12,6
; 0000 0351         HIJAU=0;
	CBI  0x12,7
; 0000 0352 
; 0000 0353         b=0;
	RCALL SUBOPT_0x3F
; 0000 0354 
; 0000 0355         putchar(13);putsf("ENTERING CONFIGURATION MODE...");
	RCALL SUBOPT_0x40
	__POINTW1FN _0x0,0
	RCALL SUBOPT_0x41
; 0000 0356         putchar(13);putsf("CONFIGURE...");
	RCALL SUBOPT_0x40
	__POINTW1FN _0x0,31
	RCALL SUBOPT_0x41
; 0000 0357 
; 0000 0358         // download configuration file
; 0000 0359         waitDollar();
	RCALL _waitDollar
; 0000 035A         waitInvCo();
	RCALL _waitInvCo
; 0000 035B         for(;;)
_0x11C:
; 0000 035C         {
; 0000 035D         	buffer[b]=getchar();
	MOVW R30,R16
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 035E                 if(buffer[b]=='$')goto rxd_selesai;
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x24)
	BREQ _0x11F
; 0000 035F                 if(buffer[b]=='"')waitInvCo();
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BRNE _0x120
	RCALL _waitInvCo
; 0000 0360                 putchar('.');
_0x120:
	LDI  R30,LOW(46)
	ST   -Y,R30
	RCALL _putchar
; 0000 0361                 b++;
	RCALL SUBOPT_0x45
; 0000 0362         }
	RJMP _0x11C
; 0000 0363         rxd_selesai:
_0x11F:
; 0000 0364         // config file downloaded
; 0000 0365         //j=b;
; 0000 0366 
; 0000 0367         putchar(13);putsf("SAVING CONFIGURATION...");
	RCALL SUBOPT_0x40
	__POINTW1FN _0x0,44
	RCALL SUBOPT_0x41
; 0000 0368 
; 0000 0369         // mycall
; 0000 036A         b=0;
	RCALL SUBOPT_0x3F
; 0000 036B         k=0;
	RCALL SUBOPT_0x46
; 0000 036C         while(buffer[b]!='"') 				//<--- move data from rxbuffer to databuffer
_0x121:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x123
; 0000 036D         {
; 0000 036E         	cbuff[k]=buffer[b];
	RCALL SUBOPT_0x47
; 0000 036F                 k++;
; 0000 0370                 b++;
; 0000 0371         }
	RJMP _0x121
_0x123:
; 0000 0372         j=b+1; 						// j = index , atau "   j+b = index next data field
	RCALL SUBOPT_0x48
; 0000 0373 
; 0000 0374         // pada titik ini, k adalah ukuran array 1st digi string
; 0000 0375         l=k;
; 0000 0376         for(k=0;k<6;k++)mycall[k]=' '; 			//<--- resetting mycall
_0x125:
	__CPWRN 20,21,6
	BRGE _0x126
	LDI  R26,LOW(_mycall)
	LDI  R27,HIGH(_mycall)
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	RJMP _0x125
_0x126:
; 0000 0377 mycall[6]='0';
	__POINTW2MN _mycall,6
	RCALL SUBOPT_0x4B
; 0000 0378         for(k=1;k<10;k++)message_head[k]=' ';
	__GETWRN 20,21,1
_0x128:
	__CPWRN 20,21,10
	BRGE _0x129
	LDI  R26,LOW(_message_head)
	LDI  R27,HIGH(_message_head)
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	RJMP _0x128
_0x129:
; 0000 0379 for(k=0;k<sizeof(cbuff);k++)message_head[k+1]=cbuff[k];
	RCALL SUBOPT_0x46
_0x12B:
	__CPWRN 20,21,1
	BRGE _0x12C
	MOVW R30,R20
	__ADDW1MN _message_head,1
	RCALL SUBOPT_0x4C
	RCALL SUBOPT_0x4A
	RJMP _0x12B
_0x12C:
; 0000 037A for(k=0;k<l;k++)
	RCALL SUBOPT_0x46
_0x12E:
	RCALL SUBOPT_0x4D
	BRGE _0x12F
; 0000 037B         {
; 0000 037C         	if(cbuff[k]=='-')
	RCALL SUBOPT_0x4E
	BRNE _0x130
; 0000 037D                 {
; 0000 037E                 	if((l-k)==2)
	RCALL SUBOPT_0x4F
	SBIW R26,2
	BRNE _0x131
; 0000 037F                         {
; 0000 0380                         	mycall[6]=cbuff[k+1];
	__POINTW1MN _mycall,6
	RCALL SUBOPT_0x50
; 0000 0381                                 goto selesai_mycall;
	RJMP _0x132
; 0000 0382                         }
; 0000 0383                         else if((l-k)==3)
_0x131:
	RCALL SUBOPT_0x4F
	SBIW R26,3
	BRNE _0x134
; 0000 0384                         {
; 0000 0385                         	mycall[6]=((10*(cbuff[k+1]-48)+cbuff[k+2]-48)+48);
	__POINTWRMN 22,23,_mycall,6
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
; 0000 0386                         	goto selesai_mycall;
	RJMP _0x132
; 0000 0387                         }
; 0000 0388                 }
_0x134:
; 0000 0389                 mycall[k]=cbuff[k];
_0x130:
	MOVW R30,R20
	SUBI R30,LOW(-_mycall)
	SBCI R31,HIGH(-_mycall)
	RCALL SUBOPT_0x4C
; 0000 038A         }
	RCALL SUBOPT_0x4A
	RJMP _0x12E
_0x12F:
; 0000 038B         selesai_mycall:
_0x132:
; 0000 038C 
; 0000 038D         //1st digi
; 0000 038E         b=j;
	RCALL SUBOPT_0x53
; 0000 038F         k=0;
; 0000 0390         while((buffer[b]!='"')&&(buffer[b]!=',')) 	//<--- move data from rxbuffer to databuffer
_0x135:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x138
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x2C)
	BRNE _0x139
_0x138:
	RJMP _0x137
_0x139:
; 0000 0391         {
; 0000 0392         	dbuff[k]=buffer[b];
	RCALL SUBOPT_0x47
; 0000 0393                 k++;
; 0000 0394                 b++;
; 0000 0395         }
	RJMP _0x135
_0x137:
; 0000 0396         j=b+1; 						// j = index , atau "   j+b = index next data field
	RCALL SUBOPT_0x48
; 0000 0397 
; 0000 0398         // pada titik ini, k adalah ukuran array 1st digi string
; 0000 0399         l=k;
; 0000 039A         for(k=0;k<6;k++)mydigi1[k]=' '; 		//<--- resetting digi call
_0x13B:
	__CPWRN 20,21,6
	BRGE _0x13C
	LDI  R26,LOW(_mydigi1)
	LDI  R27,HIGH(_mydigi1)
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	RJMP _0x13B
_0x13C:
; 0000 039B for(k=0;k<7;k++)mydigi2[k]=' ';
	RCALL SUBOPT_0x46
_0x13E:
	__CPWRN 20,21,7
	BRGE _0x13F
	LDI  R26,LOW(_mydigi2)
	LDI  R27,HIGH(_mydigi2)
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	RJMP _0x13E
_0x13F:
; 0000 039C for(k=0;k<7;k++)mydigi3[k]=' ';
	RCALL SUBOPT_0x46
_0x141:
	__CPWRN 20,21,7
	BRGE _0x142
	LDI  R26,LOW(_mydigi3)
	LDI  R27,HIGH(_mydigi3)
	RCALL SUBOPT_0x49
	RCALL SUBOPT_0x4A
	RJMP _0x141
_0x142:
; 0000 039D mydigi1[6]='0';
	__POINTW2MN _mydigi1,6
	RCALL SUBOPT_0x4B
; 0000 039E         mydigi2[6]='0';
	__POINTW2MN _mydigi2,6
	RCALL SUBOPT_0x4B
; 0000 039F         mydigi3[6]='0';
	__POINTW2MN _mydigi3,6
	RCALL SUBOPT_0x4B
; 0000 03A0         mydigi1[0]=0;
	LDI  R26,LOW(_mydigi1)
	LDI  R27,HIGH(_mydigi1)
	RCALL SUBOPT_0x54
; 0000 03A1         mydigi2[0]=0;
	LDI  R26,LOW(_mydigi2)
	LDI  R27,HIGH(_mydigi2)
	RCALL SUBOPT_0x54
; 0000 03A2         mydigi3[0]=0;
	LDI  R26,LOW(_mydigi3)
	LDI  R27,HIGH(_mydigi3)
	RCALL SUBOPT_0x54
; 0000 03A3         if(l<2)goto time_interval;			//<--- jika tidak menggunakan digi
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BRGE _0x143
	RJMP _0x144
; 0000 03A4         for(k=0;k<l;k++)
_0x143:
	RCALL SUBOPT_0x46
_0x146:
	RCALL SUBOPT_0x4D
	BRGE _0x147
; 0000 03A5         {
; 0000 03A6         	if(dbuff[k]=='-')
	RCALL SUBOPT_0x4E
	BRNE _0x148
; 0000 03A7                 {
; 0000 03A8                 	if((l-k)==2)
	RCALL SUBOPT_0x4F
	SBIW R26,2
	BRNE _0x149
; 0000 03A9                         {
; 0000 03AA                         	mydigi1[6]=dbuff[k+1];
	__POINTW1MN _mydigi1,6
	RCALL SUBOPT_0x50
; 0000 03AB                                 goto selesai_myssid1;
	RJMP _0x14A
; 0000 03AC                         }
; 0000 03AD                         else if((l-k)==3)
_0x149:
	RCALL SUBOPT_0x4F
	SBIW R26,3
	BRNE _0x14C
; 0000 03AE                         {
; 0000 03AF                         	mydigi1[6]=(10*(dbuff[k+1]-48)+dbuff[k+2]-48)+48;
	__POINTWRMN 22,23,_mydigi1,6
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
; 0000 03B0                         	goto selesai_myssid1;
	RJMP _0x14A
; 0000 03B1                         }
; 0000 03B2                 }
_0x14C:
; 0000 03B3                 mydigi1[k]=dbuff[k];
_0x148:
	MOVW R30,R20
	SUBI R30,LOW(-_mydigi1)
	SBCI R31,HIGH(-_mydigi1)
	RCALL SUBOPT_0x4C
; 0000 03B4         }
	RCALL SUBOPT_0x4A
	RJMP _0x146
_0x147:
; 0000 03B5         selesai_myssid1:
_0x14A:
; 0000 03B6         if(buffer[b]=='"')goto time_interval;
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BRNE _0x14D
	RJMP _0x144
; 0000 03B7 
; 0000 03B8 	// 2nd digi
; 0000 03B9         b=j;
_0x14D:
	RCALL SUBOPT_0x53
; 0000 03BA         k=0;
; 0000 03BB         while((buffer[b]!='"')&&(buffer[b]!=',')) //<--- move data from rxbuffer to databuffer
_0x14E:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x151
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x2C)
	BRNE _0x152
_0x151:
	RJMP _0x150
_0x152:
; 0000 03BC         {
; 0000 03BD         	dbuff[k]=buffer[b];
	RCALL SUBOPT_0x47
; 0000 03BE                 k++;
; 0000 03BF                 b++;
; 0000 03C0         }
	RJMP _0x14E
_0x150:
; 0000 03C1         j=b+1; 		// j = index , atau "   j+b = index next data field
	RCALL SUBOPT_0x48
; 0000 03C2 
; 0000 03C3         // pada titik ini, k adalah ukuran array 2nd digi string
; 0000 03C4         l=k;
; 0000 03C5         for(k=0;k<l;k++)
_0x154:
	RCALL SUBOPT_0x4D
	BRGE _0x155
; 0000 03C6         {
; 0000 03C7         	if(dbuff[k]=='-')
	RCALL SUBOPT_0x4E
	BRNE _0x156
; 0000 03C8                 {
; 0000 03C9                 	if((l-k)==2)
	RCALL SUBOPT_0x4F
	SBIW R26,2
	BRNE _0x157
; 0000 03CA                         {
; 0000 03CB                         	mydigi2[6]=dbuff[k+1];
	__POINTW1MN _mydigi2,6
	RCALL SUBOPT_0x50
; 0000 03CC                                 goto selesai_myssid2;
	RJMP _0x158
; 0000 03CD                         }
; 0000 03CE                         else if((l-k)==3)
_0x157:
	RCALL SUBOPT_0x4F
	SBIW R26,3
	BRNE _0x15A
; 0000 03CF                         {
; 0000 03D0                         	mydigi2[6]=(10*(dbuff[k+1]-48)+dbuff[k+2]-48)+48;
	__POINTWRMN 22,23,_mydigi2,6
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
; 0000 03D1                         	goto selesai_myssid2;
	RJMP _0x158
; 0000 03D2                         }
; 0000 03D3                 }
_0x15A:
; 0000 03D4                 mydigi2[k]=dbuff[k];
_0x156:
	MOVW R30,R20
	SUBI R30,LOW(-_mydigi2)
	SBCI R31,HIGH(-_mydigi2)
	RCALL SUBOPT_0x4C
; 0000 03D5         }
	RCALL SUBOPT_0x4A
	RJMP _0x154
_0x155:
; 0000 03D6         selesai_myssid2:
_0x158:
; 0000 03D7 	if(buffer[b]=='"')goto time_interval;
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x144
; 0000 03D8 
; 0000 03D9         // 3rd digi
; 0000 03DA        	b=j;
	RCALL SUBOPT_0x53
; 0000 03DB         k=0;
; 0000 03DC         while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
_0x15C:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x15E
; 0000 03DD         {
; 0000 03DE         	dbuff[k]=buffer[b];
	RCALL SUBOPT_0x47
; 0000 03DF                 k++;
; 0000 03E0                 b++;
; 0000 03E1         }
	RJMP _0x15C
_0x15E:
; 0000 03E2         j=b+1; 		// b = index , atau "   j+1 = index next data field
	RCALL SUBOPT_0x48
; 0000 03E3 
; 0000 03E4         // pada titik ini, k adalah ukuran array 3rd digi string
; 0000 03E5         l=k;
; 0000 03E6         for(k=0;k<l;k++)
_0x160:
	RCALL SUBOPT_0x4D
	BRGE _0x161
; 0000 03E7         {
; 0000 03E8         	if(dbuff[k]=='-')
	RCALL SUBOPT_0x4E
	BRNE _0x162
; 0000 03E9                 {
; 0000 03EA                 	if((l-k)==2)
	RCALL SUBOPT_0x4F
	SBIW R26,2
	BRNE _0x163
; 0000 03EB                         {
; 0000 03EC                         	mydigi3[6]=dbuff[k+1];
	__POINTW1MN _mydigi3,6
	RCALL SUBOPT_0x50
; 0000 03ED                                 goto selesai_myssid3;
	RJMP _0x164
; 0000 03EE                         }
; 0000 03EF                         else if((l-k)==3)
_0x163:
	RCALL SUBOPT_0x4F
	SBIW R26,3
	BRNE _0x166
; 0000 03F0                         {
; 0000 03F1                         	mydigi3[6]=(10*(dbuff[k+1]-48)+dbuff[k+2]-48)+48;
	__POINTWRMN 22,23,_mydigi3,6
	RCALL SUBOPT_0x51
	RCALL SUBOPT_0x52
; 0000 03F2                         	goto selesai_myssid3;
	RJMP _0x164
; 0000 03F3                         }
; 0000 03F4                 }
_0x166:
; 0000 03F5                 mydigi3[k]=dbuff[k];
_0x162:
	MOVW R30,R20
	SUBI R30,LOW(-_mydigi3)
	SBCI R31,HIGH(-_mydigi3)
	RCALL SUBOPT_0x4C
; 0000 03F6         }
	RCALL SUBOPT_0x4A
	RJMP _0x160
_0x161:
; 0000 03F7         selesai_myssid3:
_0x164:
; 0000 03F8 
; 0000 03F9         time_interval:
_0x144:
; 0000 03FA         //time interval
; 0000 03FB         b=j;
	RCALL SUBOPT_0x53
; 0000 03FC         for(k=0;k<sizeof(ibuff);k++)ibuff[k]=0;
_0x168:
	__CPWRN 20,21,5
	BRGE _0x169
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x56
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL SUBOPT_0x4A
	RJMP _0x168
_0x169:
; 0000 03FD k=0;
	RCALL SUBOPT_0x46
; 0000 03FE         while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
_0x16A:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x16C
; 0000 03FF         {
; 0000 0400         	ibuff[k]=buffer[b];
	RCALL SUBOPT_0x57
; 0000 0401                 k++;
; 0000 0402                 b++;
	RCALL SUBOPT_0x45
; 0000 0403         }
	RJMP _0x16A
_0x16C:
; 0000 0404         j=b+1;
	RCALL SUBOPT_0x58
; 0000 0405         timeIntv=atoi(ibuff);
	RCALL SUBOPT_0x59
	LDI  R26,LOW(_timeIntv)
	LDI  R27,HIGH(_timeIntv)
	RCALL __EEPROMWRW
; 0000 0406 
; 0000 0407         //symbol code
; 0000 0408         b=j;
	RCALL SUBOPT_0x5A
; 0000 0409         SYM_CODE_=buffer[b];
	LDI  R26,LOW(_SYM_CODE_)
	LDI  R27,HIGH(_SYM_CODE_)
	RCALL SUBOPT_0x5B
; 0000 040A         j=b+2;
; 0000 040B 
; 0000 040C         //symbol table
; 0000 040D         b=j;
	RCALL SUBOPT_0x5A
; 0000 040E         SYM_TAB_OVL_=buffer[b];
	LDI  R26,LOW(_SYM_TAB_OVL_)
	LDI  R27,HIGH(_SYM_TAB_OVL_)
	RCALL SUBOPT_0x5B
; 0000 040F         j=b+2;
; 0000 0410 
; 0000 0411         //comment
; 0000 0412         b=j;
	RCALL SUBOPT_0x53
; 0000 0413         for(k=0;k<commsize;k++)comment[k]=0;
_0x16E:
	LDI  R26,LOW(_commsize)
	LDI  R27,HIGH(_commsize)
	RCALL SUBOPT_0x5C
	BRGE _0x16F
	LDI  R26,LOW(_comment)
	LDI  R27,HIGH(_comment)
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x4A
	RJMP _0x16E
_0x16F:
; 0000 0414 k=0;
	RCALL SUBOPT_0x46
; 0000 0415         while(buffer[b]!='"')
_0x170:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x172
; 0000 0416         {
; 0000 0417         	comment[k]=buffer[b];
	MOVW R30,R20
	SUBI R30,LOW(-_comment)
	SBCI R31,HIGH(-_comment)
	RCALL SUBOPT_0x5E
; 0000 0418                 k++;
; 0000 0419                 b++;
	RCALL SUBOPT_0x45
; 0000 041A                 commsize=k;
	MOV  R30,R20
	LDI  R26,LOW(_commsize)
	LDI  R27,HIGH(_commsize)
	RCALL __EEPROMWRB
; 0000 041B         }
	RJMP _0x170
_0x172:
; 0000 041C         j=b+1;
	RCALL SUBOPT_0x58
; 0000 041D 
; 0000 041E         //status
; 0000 041F         b=j;
	RCALL SUBOPT_0x53
; 0000 0420         for(k=0;k<statsize;k++)status[k]=0;
_0x174:
	LDI  R26,LOW(_statsize)
	LDI  R27,HIGH(_statsize)
	RCALL SUBOPT_0x5C
	BRGE _0x175
	LDI  R26,LOW(_status)
	LDI  R27,HIGH(_status)
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x4A
	RJMP _0x174
_0x175:
; 0000 0421 k=0;
	RCALL SUBOPT_0x46
; 0000 0422         while(buffer[b]!='"')
_0x176:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x178
; 0000 0423         {
; 0000 0424         	status[k]=buffer[b];
	MOVW R30,R20
	SUBI R30,LOW(-_status)
	SBCI R31,HIGH(-_status)
	RCALL SUBOPT_0x5E
; 0000 0425                 k++;
; 0000 0426                 b++;
	RCALL SUBOPT_0x45
; 0000 0427                 statsize=k;
	MOV  R30,R20
	LDI  R26,LOW(_statsize)
	LDI  R27,HIGH(_statsize)
	RCALL __EEPROMWRB
; 0000 0428         }
	RJMP _0x176
_0x178:
; 0000 0429         j=b+1;
	RCALL SUBOPT_0x58
; 0000 042A 
; 0000 042B         //status interval
; 0000 042C         b=j;
	RCALL SUBOPT_0x53
; 0000 042D         for(k=0;k<sizeof(ibuff);k++)ibuff[k]=0;
_0x17A:
	__CPWRN 20,21,5
	BRGE _0x17B
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x56
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL SUBOPT_0x4A
	RJMP _0x17A
_0x17B:
; 0000 042E k=0;
	RCALL SUBOPT_0x46
; 0000 042F         while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
_0x17C:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x17E
; 0000 0430         {
; 0000 0431         	ibuff[k]=buffer[b];
	RCALL SUBOPT_0x57
; 0000 0432                 k++;
; 0000 0433                 b++;
	RCALL SUBOPT_0x45
; 0000 0434         }
	RJMP _0x17C
_0x17E:
; 0000 0435         j=b+1;
	RCALL SUBOPT_0x58
; 0000 0436         m_int=atoi(ibuff);
	RCALL SUBOPT_0x59
	LDI  R26,LOW(_m_int)
	LDI  R27,HIGH(_m_int)
	RCALL __EEPROMWRB
; 0000 0437 
; 0000 0438         //BASE-91 compression
; 0000 0439         b=j;
	RCALL SUBOPT_0x5A
; 0000 043A         compstat=buffer[b];
	LDI  R26,LOW(_compstat)
	LDI  R27,HIGH(_compstat)
	RCALL SUBOPT_0x5B
; 0000 043B         j=b+2;
; 0000 043C 
; 0000 043D         //set latitude
; 0000 043E         b=j;
	MOVW R16,R18
; 0000 043F         if(buffer[b]=='"')goto usegps;
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x180
; 0000 0440         k=0;
	RCALL SUBOPT_0x46
; 0000 0441         while(buffer[b]!=',')
_0x181:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x2C)
	BREQ _0x183
; 0000 0442         {
; 0000 0443         	posisi_lat[k]=buffer[b];
	MOVW R30,R20
	SUBI R30,LOW(-_posisi_lat)
	SBCI R31,HIGH(-_posisi_lat)
	RCALL SUBOPT_0x5E
; 0000 0444                 k++;
; 0000 0445                 b++;
	RCALL SUBOPT_0x45
; 0000 0446         }
	RJMP _0x181
_0x183:
; 0000 0447         j=b+1;
	RCALL SUBOPT_0x58
; 0000 0448 
; 0000 0449         //set longitude
; 0000 044A         b=j;
	RCALL SUBOPT_0x53
; 0000 044B         k=0;
; 0000 044C         while(buffer[b]!='"')
_0x184:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x186
; 0000 044D         {
; 0000 044E         	posisi_long[k]=buffer[b];
	MOVW R30,R20
	SUBI R30,LOW(-_posisi_long)
	SBCI R31,HIGH(-_posisi_long)
	RCALL SUBOPT_0x5E
; 0000 044F                 k++;
; 0000 0450                 b++;
	RCALL SUBOPT_0x45
; 0000 0451         }
	RJMP _0x184
_0x186:
; 0000 0452         j=b+1;
	RCALL SUBOPT_0x58
; 0000 0453 
; 0000 0454         usegps:
_0x180:
; 0000 0455         //use GPS ?
; 0000 0456         b=j;
	RCALL SUBOPT_0x5A
; 0000 0457         gps=buffer[b];
	LDI  R26,LOW(_gps)
	LDI  R27,HIGH(_gps)
	RCALL SUBOPT_0x5B
; 0000 0458         j=b+2;
; 0000 0459 
; 0000 045A         // battery voltage in comment ?
; 0000 045B         b=j;
	RCALL SUBOPT_0x5A
; 0000 045C         battvoltincomm=buffer[b];
	LDI  R26,LOW(_battvoltincomm)
	LDI  R27,HIGH(_battvoltincomm)
	RCALL SUBOPT_0x5B
; 0000 045D         j=b+2;
; 0000 045E 
; 0000 045F         // temperature in comment ?
; 0000 0460         b=j;
	RCALL SUBOPT_0x5A
; 0000 0461         tempincomm=buffer[b];
	LDI  R26,LOW(_tempincomm)
	LDI  R27,HIGH(_tempincomm)
	RCALL SUBOPT_0x5B
; 0000 0462         j=b+2;
; 0000 0463 
; 0000 0464         // send altitude ?
; 0000 0465         b=j;
	RCALL SUBOPT_0x5A
; 0000 0466         sendalt=buffer[b];
	LDI  R26,LOW(_sendalt)
	LDI  R27,HIGH(_sendalt)
	RCALL SUBOPT_0x5B
; 0000 0467         j=b+2;
; 0000 0468 
; 0000 0469         // send to PC ?
; 0000 046A         b=j;
	RCALL SUBOPT_0x5A
; 0000 046B         sendtopc=buffer[b];
	LDI  R26,LOW(_sendtopc)
	LDI  R27,HIGH(_sendtopc)
	RCALL SUBOPT_0x5B
; 0000 046C         j=b+2;
; 0000 046D 
; 0000 046E         //ProTrak! model A configuration ends here
; 0000 046F 
; 0000 0470         // telemetry interval
; 0000 0471         b=j;
	RCALL SUBOPT_0x53
; 0000 0472         for(k=0;k<sizeof(tbuff);k++)tbuff[k]=0;
_0x188:
	__CPWRN 20,21,3
	BRGE _0x189
	MOVW R26,R28
	ADIW R26,8
	RCALL SUBOPT_0x56
	LDI  R30,LOW(0)
	ST   X,R30
	RCALL SUBOPT_0x4A
	RJMP _0x188
_0x189:
; 0000 0473 k=0;
	RCALL SUBOPT_0x46
; 0000 0474         while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
_0x18A:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x18C
; 0000 0475         {
; 0000 0476         	tbuff[k]=buffer[b];
	MOVW R30,R20
	MOVW R26,R28
	ADIW R26,8
	RCALL SUBOPT_0x43
	MOVW R0,R30
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x5F
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
; 0000 0477                 k++;
	RCALL SUBOPT_0x4A
; 0000 0478                 b++;
	RCALL SUBOPT_0x45
; 0000 0479         }
	RJMP _0x18A
_0x18C:
; 0000 047A         j=b+1;
	RCALL SUBOPT_0x58
; 0000 047B         tel_int=atoi(tbuff);
	MOVW R30,R28
	ADIW R30,8
	RCALL SUBOPT_0x35
	RCALL _atoi
	LDI  R26,LOW(_tel_int)
	LDI  R27,HIGH(_tel_int)
	RCALL __EEPROMWRW
; 0000 047C 
; 0000 047D         /*/ telemetri input channel
; 0000 047E         // 1
; 0000 047F         b=j;
; 0000 0480         pri1=buffer[b];
; 0000 0481         j=b+5;
; 0000 0482 
; 0000 0483         // 2
; 0000 0484         b=j;
; 0000 0485         pri2=buffer[b];
; 0000 0486         j=b+5;
; 0000 0487 
; 0000 0488         // 3
; 0000 0489         b=j;
; 0000 048A         pri3=buffer[b];
; 0000 048B         j=b+8;
; 0000 048C 
; 0000 048D         // 4
; 0000 048E         b=j;
; 0000 048F         pri4=buffer[b];
; 0000 0490         j=b+8;
; 0000 0491 
; 0000 0492         // 5
; 0000 0493         b=j;
; 0000 0494         pri5=buffer[b];
; 0000 0495         j=b+2; */
; 0000 0496 
; 0000 0497         //label
; 0000 0498         b=j;
	RCALL SUBOPT_0x53
; 0000 0499         for(k=0;k<sizeof(param);k++)param[k]=0;
_0x18E:
	__CPWRN 20,21,22
	BRGE _0x18F
	LDI  R26,LOW(_param)
	LDI  R27,HIGH(_param)
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x4A
	RJMP _0x18E
_0x18F:
; 0000 049A k=0;
	RCALL SUBOPT_0x46
; 0000 049B         while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
_0x190:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x192
; 0000 049C         {
; 0000 049D         	param[k]=buffer[b];
	MOVW R30,R20
	SUBI R30,LOW(-_param)
	SBCI R31,HIGH(-_param)
	RCALL SUBOPT_0x5E
; 0000 049E                 k++;
; 0000 049F                 b++;
	RCALL SUBOPT_0x45
; 0000 04A0         }
	RJMP _0x190
_0x192:
; 0000 04A1         j=b+1;
	RCALL SUBOPT_0x58
; 0000 04A2 
; 0000 04A3         // unit
; 0000 04A4         b=j;
	RCALL SUBOPT_0x53
; 0000 04A5         for(k=0;k<sizeof(unit);k++)unit[k]=0;
_0x194:
	__CPWRN 20,21,21
	BRGE _0x195
	LDI  R26,LOW(_unit)
	LDI  R27,HIGH(_unit)
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x4A
	RJMP _0x194
_0x195:
; 0000 04A6 k=0;
	RCALL SUBOPT_0x46
; 0000 04A7         while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
_0x196:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x198
; 0000 04A8         {
; 0000 04A9         	unit[k]=buffer[b];
	MOVW R30,R20
	SUBI R30,LOW(-_unit)
	SBCI R31,HIGH(-_unit)
	RCALL SUBOPT_0x5E
; 0000 04AA                 k++;
; 0000 04AB                 b++;
	RCALL SUBOPT_0x45
; 0000 04AC         }
	RJMP _0x196
_0x198:
; 0000 04AD         j=b+1;
	RCALL SUBOPT_0x58
; 0000 04AE 
; 0000 04AF         // equation
; 0000 04B0         b=j;
	RCALL SUBOPT_0x53
; 0000 04B1         for(k=0;k<sizeof(eqns);k++)eqns[k]=0;
_0x19A:
	__CPWRN 20,21,28
	BRGE _0x19B
	LDI  R26,LOW(_eqns)
	LDI  R27,HIGH(_eqns)
	RCALL SUBOPT_0x5D
	RCALL SUBOPT_0x4A
	RJMP _0x19A
_0x19B:
; 0000 04B2 k=0;
	RCALL SUBOPT_0x46
; 0000 04B3         while(buffer[b]!='"') 			//<--- move data from rxbuffer to databuffer
_0x19C:
	RCALL SUBOPT_0x44
	CPI  R26,LOW(0x22)
	BREQ _0x19E
; 0000 04B4         {
; 0000 04B5         	eqns[k]=buffer[b];
	MOVW R30,R20
	SUBI R30,LOW(-_eqns)
	SBCI R31,HIGH(-_eqns)
	RCALL SUBOPT_0x5E
; 0000 04B6                 k++;
; 0000 04B7                 b++;
	RCALL SUBOPT_0x45
; 0000 04B8         }
	RJMP _0x19C
_0x19E:
; 0000 04B9         //j=b+1;
; 0000 04BA 
; 0000 04BB         // EHCOING
; 0000 04BC         //mem_display();
; 0000 04BD 
; 0000 04BE         //ProTrak! model A+ configuration ends here
; 0000 04BF 
; 0000 04C0         MERAH=0;
	CBI  0x12,6
; 0000 04C1         HIJAU=0;
	CBI  0x12,7
; 0000 04C2         putchar(13);putchar(13);putsf("CONFIG SUCCESS !");
	RCALL SUBOPT_0x40
	RCALL SUBOPT_0x40
	__POINTW1FN _0x0,68
	RCALL SUBOPT_0x41
; 0000 04C3         putchar(13);
	RCALL SUBOPT_0x40
; 0000 04C4 
; 0000 04C5 	#asm("sei")
	sei
; 0000 04C6 }
	RCALL __LOADLOCR6
	ADIW R28,4
	SUBI R29,-2
	RET
;
;void extractGPS(void)
; 0000 04C9 {
_extractGPS:
; 0000 04CA 	int i,j;
; 0000 04CB         char buff_altitude[9];
; 0000 04CC         char cb;
; 0000 04CD         char n_altitude[6];
; 0000 04CE 
; 0000 04CF         #asm("cli")
	SBIW R28,15
	RCALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	buff_altitude -> Y+12
;	cb -> R21
;	n_altitude -> Y+6
	cli
; 0000 04D0         lagi:
_0x1A3:
; 0000 04D1         while(getchar() != '$');
_0x1A4:
	RCALL _getchar
	CPI  R30,LOW(0x24)
	BRNE _0x1A4
; 0000 04D2         cb=getchar();
	RCALL _getchar
	MOV  R21,R30
; 0000 04D3 	if(cb=='G')
	CPI  R21,71
	BREQ PC+2
	RJMP _0x1A7
; 0000 04D4         {
; 0000 04D5         	getchar();
	RCALL _getchar
; 0000 04D6         	if(getchar() == 'G')
	RCALL _getchar
	CPI  R30,LOW(0x47)
	BREQ PC+2
	RJMP _0x1A8
; 0000 04D7         	{
; 0000 04D8         	if(getchar() == 'G')
	RCALL _getchar
	CPI  R30,LOW(0x47)
	BREQ PC+2
	RJMP _0x1A9
; 0000 04D9         	{
; 0000 04DA                 	if(getchar() == 'A')
	RCALL _getchar
	CPI  R30,LOW(0x41)
	BREQ PC+2
	RJMP _0x1AA
; 0000 04DB                 	{
; 0000 04DC                         	MERAH = 0;
	CBI  0x12,6
; 0000 04DD         			HIJAU = 1;
	SBI  0x12,7
; 0000 04DE 
; 0000 04DF                                 waitComma();
	RCALL _waitComma
; 0000 04E0                                 waitComma();
	RCALL _waitComma
; 0000 04E1 				for(i=0; i<7; i++)	posisi_lat[i] = getchar();
	RCALL SUBOPT_0x3F
_0x1B0:
	__CPWRN 16,17,7
	BRGE _0x1B1
	MOVW R30,R16
	SUBI R30,LOW(-_posisi_lat)
	SBCI R31,HIGH(-_posisi_lat)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
	RCALL SUBOPT_0x45
	RJMP _0x1B0
_0x1B1:
; 0000 04E2 waitComma();
	RCALL _waitComma
; 0000 04E3 				posisi_lat[7] = getchar();
	__POINTW1MN _posisi_lat,7
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
; 0000 04E4 				waitComma();
	RCALL _waitComma
; 0000 04E5 				for(i=0; i<8; i++)	posisi_long[i] = getchar();
	RCALL SUBOPT_0x3F
_0x1B3:
	RCALL SUBOPT_0x60
	BRGE _0x1B4
	MOVW R30,R16
	SUBI R30,LOW(-_posisi_long)
	SBCI R31,HIGH(-_posisi_long)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
	RCALL SUBOPT_0x45
	RJMP _0x1B3
_0x1B4:
; 0000 04E6 waitComma();		posisi_long[8] = getchar();
	RCALL _waitComma
	__POINTW1MN _posisi_long,8
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
; 0000 04E7 				waitComma();
	RCALL _waitComma
; 0000 04E8                                 waitComma();
	RCALL _waitComma
; 0000 04E9                                 waitComma();
	RCALL _waitComma
; 0000 04EA                                 waitComma();
	RCALL _waitComma
; 0000 04EB 				for(i=0;i<8;i++)        buff_altitude[i] = getchar();
	RCALL SUBOPT_0x3F
_0x1B6:
	RCALL SUBOPT_0x60
	BRGE _0x1B7
	MOVW R30,R16
	RCALL SUBOPT_0x61
	RCALL SUBOPT_0x43
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
	RCALL SUBOPT_0x45
	RJMP _0x1B6
_0x1B7:
; 0000 04EC for(i=0;i<6;i++)        n_altitude[i] = '0';
	RCALL SUBOPT_0x3F
_0x1B9:
	__CPWRN 16,17,6
	BRGE _0x1BA
	RCALL SUBOPT_0x62
	RCALL SUBOPT_0x5F
	LDI  R30,LOW(48)
	ST   X,R30
	RCALL SUBOPT_0x45
	RJMP _0x1B9
_0x1BA:
; 0000 04ED for(i=0;i<8;i++)
	RCALL SUBOPT_0x3F
_0x1BC:
	RCALL SUBOPT_0x60
	BRGE _0x1BD
; 0000 04EE                                 {
; 0000 04EF                                         if(buff_altitude[i] == '.')     goto selesai;
	RCALL SUBOPT_0x63
	BREQ _0x1BF
; 0000 04F0                                         if((buff_altitude[i] != '.')&&(buff_altitude[i] != ',')&&(buff_altitude[i] != 'M'))
	RCALL SUBOPT_0x63
	BREQ _0x1C1
	RCALL SUBOPT_0x61
	RCALL SUBOPT_0x5F
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BREQ _0x1C1
	RCALL SUBOPT_0x61
	RCALL SUBOPT_0x5F
	LD   R26,X
	CPI  R26,LOW(0x4D)
	BRNE _0x1C2
_0x1C1:
	RJMP _0x1C0
_0x1C2:
; 0000 04F1                                         {
; 0000 04F2                                         	for(j=0;j<6;j++)        n_altitude[j] = n_altitude[j+1];
	__GETWRN 18,19,0
_0x1C4:
	__CPWRN 18,19,6
	BRGE _0x1C5
	MOVW R30,R18
	RCALL SUBOPT_0x62
	RCALL SUBOPT_0x43
	MOVW R0,R30
	MOVW R30,R18
	ADIW R30,1
	RCALL SUBOPT_0x62
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	__ADDWRN 18,19,1
	RJMP _0x1C4
_0x1C5:
; 0000 04F3 n_altitude[5] = buff_altitude[i];
	RCALL SUBOPT_0x61
	RCALL SUBOPT_0x5F
	LD   R30,X
	STD  Y+11,R30
; 0000 04F4                                         }
; 0000 04F5                                 }
_0x1C0:
	RCALL SUBOPT_0x45
	RJMP _0x1BC
_0x1BD:
; 0000 04F6 
; 0000 04F7                                 selesai:
_0x1BF:
; 0000 04F8 
; 0000 04F9                                 for(i=0;i<6;i++)n_altitude[i]-='0';
	RCALL SUBOPT_0x3F
_0x1C7:
	__CPWRN 16,17,6
	BRGE _0x1C8
	RCALL SUBOPT_0x62
	RCALL SUBOPT_0x5F
	LD   R30,X
	SUBI R30,LOW(48)
	ST   X,R30
	RCALL SUBOPT_0x45
	RJMP _0x1C7
_0x1C8:
; 0000 04FC altitude=3*atol(n_altitude);
	MOVW R30,R28
	ADIW R30,6
	RCALL SUBOPT_0x35
	RCALL _atol
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __MULW12
	LDI  R26,LOW(_altitude)
	LDI  R27,HIGH(_altitude)
	RCALL __EEPROMWRW
; 0000 04FD 
; 0000 04FE                                 MERAH = 0;
	CBI  0x12,6
; 0000 04FF         			HIJAU = 0;
	CBI  0x12,7
; 0000 0500                                 delay_ms(150);
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RCALL SUBOPT_0x64
; 0000 0501                                 goto keluar;
	RJMP _0x1CD
; 0000 0502                         }
; 0000 0503                 }
_0x1AA:
; 0000 0504         	}
_0x1A9:
; 0000 0505         }
_0x1A8:
; 0000 0506 
; 0000 0507         else if(cb=='C')
	RJMP _0x1CE
_0x1A7:
	CPI  R21,67
	BRNE _0x1CF
; 0000 0508         {
; 0000 0509         	if(getchar()=='O')
	RCALL _getchar
	CPI  R30,LOW(0x4F)
	BRNE _0x1D0
; 0000 050A                 {
; 0000 050B                 	if(getchar()=='N')
	RCALL _getchar
	CPI  R30,LOW(0x4E)
	BRNE _0x1D1
; 0000 050C                         {
; 0000 050D                         	if(getchar()=='F')
	RCALL _getchar
	CPI  R30,LOW(0x46)
	BRNE _0x1D2
; 0000 050E                                 {
; 0000 050F                                 	config();
	RCALL _config
; 0000 0510                                         goto keluar;
	RJMP _0x1CD
; 0000 0511         			}
; 0000 0512                         }
_0x1D2:
; 0000 0513                 }
_0x1D1:
; 0000 0514         }
_0x1D0:
; 0000 0515         goto lagi;
_0x1CF:
_0x1CE:
	RJMP _0x1A3
; 0000 0516 
; 0000 0517         keluar:
_0x1CD:
; 0000 0518         #asm("sei")
	sei
; 0000 0519 }
	RCALL __LOADLOCR6
	ADIW R28,21
	RET
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 051C {
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
; 0000 051D 	if(gps=='Y')
	LDI  R26,LOW(_gps)
	LDI  R27,HIGH(_gps)
	RCALL SUBOPT_0x3A
	BRNE _0x1D3
; 0000 051E         {
; 0000 051F         	HIJAU=0;
	CBI  0x12,7
; 0000 0520                 MERAH=0;
	CBI  0x12,6
; 0000 0521                 extractGPS();
	RJMP _0x1F7
; 0000 0522         }
; 0000 0523         else
_0x1D3:
; 0000 0524         {
; 0000 0525         	HIJAU=1;
	SBI  0x12,7
; 0000 0526                 MERAH=0;
	CBI  0x12,6
; 0000 0527                 if(PIND.0==0)extractGPS();
	SBIS 0x10,0
_0x1F7:
	RCALL _extractGPS
; 0000 0528         }
; 0000 0529         if((tcnt1c/2)==timeIntv)
	MOV  R26,R6
	LDI  R30,LOW(2)
	RCALL __DIVB21
	MOV  R0,R30
	LDI  R26,LOW(_timeIntv)
	LDI  R27,HIGH(_timeIntv)
	RCALL __EEPROMRDW
	MOV  R26,R0
	LDI  R27,0
	SBRC R26,7
	SER  R27
	CP   R30,R26
	CPC  R31,R27
	BRNE _0x1DE
; 0000 052A         {
; 0000 052B         	kirim_paket();
	RCALL _kirim_paket
; 0000 052C                 tcnt1c=0;
	CLR  R6
; 0000 052D         }
; 0000 052E         TCNT1H = (60135 >> 8);
_0x1DE:
	RCALL SUBOPT_0x65
; 0000 052F         TCNT1L = (60135 & 0xFF);
; 0000 0530 
; 0000 0531         tcnt1c++;
	INC  R6
; 0000 0532 }
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
; 0000 0535 {
_main:
; 0000 0536         PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0537 	DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0538 	PORTD=0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 0539 	DDRD=0xFE;
	LDI  R30,LOW(254)
	OUT  0x11,R30
; 0000 053A 
; 0000 053B         TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 053C 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 053D 	TCNT1H = (60135 >> 8);
	RCALL SUBOPT_0x65
; 0000 053E         TCNT1L = (60135 & 0xFF);
; 0000 053F         TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 0540 
; 0000 0541 	UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0542 	UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0543 	UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0544 	UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0545 	UBRRL=0x8F;
	LDI  R30,LOW(143)
	OUT  0x9,R30
; 0000 0546 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0547 
; 0000 0548 	ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(0)
	OUT  0x7,R30
; 0000 0549 	ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 054A 
; 0000 054B         MERAH = 1;
	SBI  0x12,6
; 0000 054C         HIJAU = 0;
	CBI  0x12,7
; 0000 054D         delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x64
; 0000 054E         MERAH = 0;
	CBI  0x12,6
; 0000 054F         HIJAU = 1;
	SBI  0x12,7
; 0000 0550         delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x64
; 0000 0551 
; 0000 0552         #asm("sei")
	sei
; 0000 0553 
; 0000 0554 	while (1)
_0x1E7:
; 0000 0555       	{
; 0000 0556         	if(sendtopc=='Y')
	LDI  R26,LOW(_sendtopc)
	LDI  R27,HIGH(_sendtopc)
	RCALL SUBOPT_0x3A
	BRNE _0x1EA
; 0000 0557                 {
; 0000 0558                 read_temp();
	RCALL _read_temp
; 0000 0559                 read_volt();
	RCALL _read_volt
; 0000 055A                 putchar(13);putsf("Temperature       :");puts(temp);//putchar('C');
	RCALL SUBOPT_0x40
	__POINTW1FN _0x0,85
	RCALL SUBOPT_0x41
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	RCALL SUBOPT_0x35
	RCALL _puts
; 0000 055B                 putchar(13);putsf("Battery Voltage   :");puts(volt);//putchar('V');
	RCALL SUBOPT_0x40
	__POINTW1FN _0x0,105
	RCALL SUBOPT_0x41
	LDI  R30,LOW(_volt)
	LDI  R31,HIGH(_volt)
	RCALL SUBOPT_0x35
	RCALL _puts
; 0000 055C                 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x64
; 0000 055D                 }
; 0000 055E       	}
_0x1EA:
	RJMP _0x1E7
; 0000 055F }
_0x1EB:
	RJMP _0x1EB
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
	ST   -Y,R30
	RCALL _putchar
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
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x67
    brne __floor1
__floor0:
	RCALL SUBOPT_0x66
	RJMP _0x20A0003
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x15
	RCALL __SUBF12
	RJMP _0x20A0003
_ceil:
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x67
    brne __ceil1
__ceil0:
	RCALL SUBOPT_0x66
	RJMP _0x20A0003
__ceil1:
    brts __ceil0
	RCALL SUBOPT_0x66
	RCALL SUBOPT_0x15
	RCALL __ADDF12
_0x20A0003:
	ADIW R28,4
	RET
_fmod:
	SBIW R28,4
	RCALL SUBOPT_0x68
	RCALL __CPD10
	BRNE _0x2020005
	RCALL SUBOPT_0x69
	RJMP _0x20A0002
_0x2020005:
	RCALL SUBOPT_0x68
	RCALL SUBOPT_0x6A
	RCALL __DIVF21
	RCALL __PUTD1S0
	RCALL SUBOPT_0x66
	RCALL __CPD10
	BRNE _0x2020006
	RCALL SUBOPT_0x69
	RJMP _0x20A0002
_0x2020006:
	RCALL __GETD2S0
	RCALL __CPD02
	BRGE _0x2020007
	RCALL SUBOPT_0x66
	RCALL __PUTPARD1
	RCALL _floor
	RJMP _0x2020033
_0x2020007:
	RCALL SUBOPT_0x66
	RCALL __PUTPARD1
	RCALL _ceil
_0x2020033:
	RCALL __PUTD1S0
	RCALL SUBOPT_0x66
	__GETD2S 4
	RCALL __MULF12
	RCALL SUBOPT_0x6A
	RCALL SUBOPT_0xD
_0x20A0002:
	ADIW R28,12
	RET
_log:
	SBIW R28,4
	RCALL __SAVELOCR2
	RCALL SUBOPT_0x6B
	RCALL __CPD02
	BRLT _0x202000C
	__GETD1N 0xFF7FFFFF
	RJMP _0x20A0001
_0x202000C:
	RCALL SUBOPT_0x6C
	RCALL __PUTPARD1
	IN   R30,SPL
	IN   R31,SPH
	SBIW R30,1
	RCALL SUBOPT_0x35
	PUSH R17
	PUSH R16
	RCALL _frexp
	POP  R16
	POP  R17
	RCALL SUBOPT_0x6D
	RCALL SUBOPT_0x6B
	__GETD1N 0x3F3504F3
	RCALL __CMPF12
	BRSH _0x202000D
	RCALL SUBOPT_0x6C
	RCALL SUBOPT_0x6B
	RCALL __ADDF12
	RCALL SUBOPT_0x6D
	__SUBWRN 16,17,1
_0x202000D:
	RCALL SUBOPT_0x6C
	RCALL SUBOPT_0x15
	RCALL __SUBF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x6C
	RCALL SUBOPT_0x15
	RCALL __ADDF12
	POP  R26
	POP  R27
	POP  R24
	POP  R25
	RCALL __DIVF21
	RCALL SUBOPT_0x6D
	RCALL SUBOPT_0x6C
	RCALL SUBOPT_0x6B
	RCALL __MULF12
	__PUTD1S 2
	RCALL SUBOPT_0x6E
	__GETD2N 0x3F654226
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x4054114E
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x6B
	RCALL __MULF12
	PUSH R23
	PUSH R22
	PUSH R31
	PUSH R30
	RCALL SUBOPT_0x6E
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
_atol:
    ldd  r27,y+1
    ld   r26,y
__atol0:
    ld   r30,x
	ST   -Y,R30
	RCALL _isspace
    tst  r30
    breq __atol1
    adiw r26,1
    rjmp __atol0
__atol1:
    clt
    ld   r30,x
    cpi  r30,'-'
    brne __atol2
    set
    rjmp __atol3
__atol2:
    cpi  r30,'+'
    brne __atol4
__atol3:
    adiw r26,1
__atol4:
    clr  r0
    clr  r1
    clr  r24
    clr  r25
__atol5:
    ld   r30,x
	ST   -Y,R30
	RCALL _isdigit
    tst  r30
    breq __atol6
    movw r30,r0
    movw r22,r24
    rcall __atol8
    rcall __atol8
    add  r0,r30
    adc  r1,r31
    adc  r24,r22
    adc  r25,r23
    rcall __atol8
    ld   r30,x+
    clr  r31
    subi r30,'0'
    add  r0,r30
    adc  r1,r31
    adc  r24,r31
    adc  r25,r31
    rjmp __atol5
__atol6:
    movw r30,r0
    movw r22,r24
    brtc __atol7
    com  r30
    com  r31
    com  r22
    com  r23
    clr  r24
    adiw r30,1
    adc  r22,r24
    adc  r23,r24
__atol7:
    adiw r28,2
    ret

__atol8:
    lsl  r0
    rol  r1
    rol  r24
    rol  r25
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
_add_tel:
	.DB  LOW(0x40988AA8),HIGH(0x40988AA8),BYTE3(0x40988AA8),BYTE4(0x40988AA8)
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
	.DB  LOW(0x5338342E),HIGH(0x5338342E),BYTE3(0x5338342E),BYTE4(0x5338342E)
	.DB  0x0
_posisi_long:
	.DB  LOW(0x32303131),HIGH(0x32303131),BYTE3(0x32303131),BYTE4(0x32303131)
	.DB  LOW(0x36352E32),HIGH(0x36352E32),BYTE3(0x36352E32),BYTE4(0x36352E32)
	.DW  0x45
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
_altitude:
	.DW  0x0
_m_int:
	.DB  0x15
_tel_int:
	.DW  0x5
_comp_lat:
	.BYTE 0x4
_comp_long:
	.BYTE 0x4
_seq:
	.DW  0x0
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
_sendtel:
	.DB  0x59
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
_commsize:
	.DB  0xB
_statsize:
	.DB  0x21
_sendtopc:
	.DB  0x4E

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
_crc_lo_S0000019000:
	.BYTE 0x1
_crc_hi_S0000019000:
	.BYTE 0x1
_xor_in_S000001B000:
	.BYTE 0x2
__seed_G102:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
	RCALL __EEPROMRDB
	SUBI R30,LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(10)
	MULS R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x5:
	RCALL __CBD1
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	__GETD2N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x7:
	RCALL SUBOPT_0x5
	RCALL __ADDF12
	__PUTD1S 12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	__GETD1N 0x1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	__GETD1N 0xFFFFFFFF
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	MOV  R30,R16
	RCALL SUBOPT_0x5
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x42700000
	RCALL __DIVF21
	MOV  R26,R17
	RCALL __CBD2
	RCALL __CDF2
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB:
	__GETD1S 12
	__GETD2N 0x3F19999A
	RCALL __MULF12
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x45610000
	RCALL __DIVF21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xC:
	RCALL __ADDF12
	__PUTD1S 4
	MOV  R30,R19
	__GETD2S 4
	RCALL SUBOPT_0x5
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	RCALL __SWAPD12
	RCALL __SUBF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0xE:
	RCALL __MULF12
	__PUTD1S 8
	__GETD2S 8
	__GETD1N 0x4937FA30
	RCALL __DIVF21
	__GETD2N 0x42040000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0xF:
	RCALL __CFD1
	RCALL __EEPROMWRB
	__GETD1S 8
	RCALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x10:
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
SUBOPT_0x11:
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
SUBOPT_0x12:
	__GETD1N 0x42B60000
	RCALL __PUTPARD1
	RCALL _fmod
	__GETD2N 0x42040000
	RCALL __ADDF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(_altitude)
	LDI  R27,HIGH(_altitude)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x15:
	__GETD2N 0x3F800000
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x16:
	RCALL __MULF12
	RCALL __CFD1
	MOVW R16,R30
	MOVW R26,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	CLR  R22
	CLR  R23
	MOVW R26,R30
	MOVW R24,R22
	__GETD1N 0x186A0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x18:
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x19:
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(_seq)
	LDI  R27,HIGH(_seq)
	RCALL __EEPROMRDW
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	RCALL __DIVW21
	SUBI R30,-LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	RCALL __MODW21
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(_seq)
	LDI  R27,HIGH(_seq)
	RCALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1E:
	RCALL __MODW21
	SUBI R30,-LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x14
	__GETD2N 0x3E800000
	RJMP SUBOPT_0x16

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x21:
	MOVW R26,R16
	RCALL SUBOPT_0x20
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x22:
	MOVW R26,R16
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x23:
	ST   -Y,R17
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:58 WORDS
SUBOPT_0x24:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:36 WORDS
SUBOPT_0x25:
	RCALL __EEPROMRDB
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x26:
	RCALL __EEPROMRDB
	LSL  R30
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	LSL  R30
	SUBI R30,-LOW(1)
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x28:
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x29:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2A:
	LD   R30,Z
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2B:
	ST   -Y,R17
	RCALL _kirim_add_tel
	RJMP _kirim_ax25_head

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(44)
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2D:
	LDI  R26,LOW(_pri1)
	LDI  R27,HIGH(_pri1)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2E:
	LDI  R26,LOW(_pri2)
	LDI  R27,HIGH(_pri2)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x2F:
	LDI  R26,LOW(_pri3)
	LDI  R27,HIGH(_pri3)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x30:
	LDI  R26,LOW(_pri4)
	LDI  R27,HIGH(_pri4)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x31:
	LDI  R26,LOW(_pri5)
	LDI  R27,HIGH(_pri5)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x32:
	SUBI R26,LOW(-_message_head)
	SBCI R27,HIGH(-_message_head)
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x33:
	LDI  R27,0
	SBRC R26,7
	SER  R27
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	LDI  R26,LOW(_statsize)
	LDI  R27,HIGH(_statsize)
	RCALL __EEPROMRDB
	CP   R17,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x35:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(0)
	STS  _bit_stuff_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(7)
	CP   R30,R7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	LDI  R26,LOW(_m_int)
	LDI  R27,HIGH(_m_int)
	RCALL __EEPROMRDB
	MOV  R26,R7
	RCALL __MODB21
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	LDI  R26,LOW(_tel_int)
	LDI  R27,HIGH(_tel_int)
	RCALL __EEPROMRDW
	MOV  R26,R7
	LDI  R27,0
	SBRC R26,7
	SER  R27
	RCALL __MODW21
	SBIW R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x59)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3B:
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	ST   -Y,R30
	RJMP _set_nada

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3C:
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	__DELAY_USW 1153
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3E:
	__DELAY_USW 575
	SBI  0x18,4
	__DELAY_USW 578
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x40:
	LDI  R30,LOW(13)
	ST   -Y,R30
	RJMP _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x41:
	RCALL SUBOPT_0x35
	RJMP _putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 69 TIMES, CODE SIZE REDUCTION:66 WORDS
SUBOPT_0x42:
	MOVW R26,R28
	ADIW R26,16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x43:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:58 WORDS
SUBOPT_0x44:
	RCALL SUBOPT_0x42
	ADD  R26,R16
	ADC  R27,R17
	LD   R26,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x45:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 31 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x46:
	__GETWRN 20,21,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x47:
	MOVW R30,R20
	RCALL SUBOPT_0x42
	RCALL SUBOPT_0x43
	MOVW R0,R30
	RCALL SUBOPT_0x42
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	__ADDWRN 20,21,1
	RJMP SUBOPT_0x45

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x48:
	MOVW R30,R16
	ADIW R30,1
	MOVW R18,R30
	__PUTWSR 20,21,6
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x49:
	ADD  R26,R20
	ADC  R27,R21
	LDI  R30,LOW(32)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x4A:
	__ADDWRN 20,21,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4B:
	LDI  R30,LOW(48)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x4C:
	MOVW R0,R30
	RCALL SUBOPT_0x42
	ADD  R26,R20
	ADC  R27,R21
	LD   R30,X
	MOVW R26,R0
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4D:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CP   R20,R30
	CPC  R21,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x4E:
	RCALL SUBOPT_0x42
	ADD  R26,R20
	ADC  R27,R21
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
	RCALL SUBOPT_0x42
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
	RCALL SUBOPT_0x42
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	SUBI R30,LOW(48)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x52:
	MOVW R30,R20
	ADIW R30,2
	RCALL SUBOPT_0x42
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x53:
	MOVW R16,R18
	RJMP SUBOPT_0x46

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x54:
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x55:
	MOVW R26,R28
	ADIW R26,11
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x56:
	ADD  R26,R20
	ADC  R27,R21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x57:
	MOVW R30,R20
	RCALL SUBOPT_0x55
	RCALL SUBOPT_0x43
	MOVW R0,R30
	RCALL SUBOPT_0x42
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0x58:
	MOVW R30,R16
	ADIW R30,1
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	MOVW R30,R28
	ADIW R30,11
	RCALL SUBOPT_0x35
	RJMP _atoi

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x5A:
	MOVW R16,R18
	RCALL SUBOPT_0x42
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x5B:
	RCALL __EEPROMWRB
	MOVW R30,R16
	ADIW R30,2
	MOVW R18,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5C:
	RCALL __EEPROMRDB
	MOVW R26,R20
	RCALL SUBOPT_0x3C
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5D:
	RCALL SUBOPT_0x56
	RJMP SUBOPT_0x54

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:40 WORDS
SUBOPT_0x5E:
	MOVW R0,R30
	RCALL SUBOPT_0x42
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	MOVW R26,R0
	RCALL __EEPROMWRB
	RJMP SUBOPT_0x4A

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x5F:
	ADD  R26,R16
	ADC  R27,R17
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x60:
	__CPWRN 16,17,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x61:
	MOVW R26,R28
	ADIW R26,12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	MOVW R26,R28
	ADIW R26,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x63:
	RCALL SUBOPT_0x61
	RCALL SUBOPT_0x5F
	LD   R26,X
	CPI  R26,LOW(0x2E)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x64:
	RCALL SUBOPT_0x35
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x65:
	LDI  R30,LOW(234)
	OUT  0x2D,R30
	LDI  R30,LOW(231)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x66:
	RCALL __GETD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x67:
	RCALL __PUTPARD1
	RCALL _ftrunc
	RCALL __PUTD1S0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x68:
	__GETD1S 4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x69:
	__GETD1N 0x0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6A:
	__GETD2S 8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6B:
	__GETD2S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6C:
	__GETD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6D:
	__PUTD1S 6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6E:
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

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
	RET

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
	RET

__DIVB21:
	RCALL __CHKSIGNB
	RCALL __DIVB21U
	BRTC __DIVB211
	NEG  R30
__DIVB211:
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

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
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

__CHKSIGNB:
	CLT
	SBRS R30,7
	RJMP __CHKSB1
	NEG  R30
	SET
__CHKSB1:
	SBRS R26,7
	RJMP __CHKSB2
	NEG  R26
	BLD  R0,0
	INC  R0
	BST  R0,0
__CHKSB2:
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
