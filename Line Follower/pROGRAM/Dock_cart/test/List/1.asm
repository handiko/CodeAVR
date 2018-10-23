
;CodeVisionAVR C Compiler V2.04.4a Advanced
;(C) Copyright 1998-2009 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 512 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega32
	#pragma AVRPART MEMORY PROG_FLASH 32768
	#pragma AVRPART MEMORY EEPROM 1024
	#pragma AVRPART MEMORY INT_SRAM SIZE 2048
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
	.DEF _l=R5
	.DEF _menu=R4
	.DEF _kp_div=R7
	.DEF _menu_slave=R6
	.DEF _strategi=R9
	.DEF _temp_adc_menu=R8
	.DEF _adc_menu=R11
	.DEF _nos_speed=R10
	.DEF _boleh_nos=R13
	.DEF _i=R12

	.CSEG
	.ORG 0x00

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
	JMP  0x00

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0008

_0x471:
	.DB  0xD
_0x0:
	.DB  0x25,0x64,0x0,0x77,0x6F,0x69,0x0,0x68
	.DB  0x65,0x68,0x0,0x25,0x64,0x20,0x25,0x64
	.DB  0x20,0x25,0x64,0x20,0x25,0x64,0x20,0x0
	.DB  0x25,0x64,0x20,0x25,0x64,0x20,0x25,0x64
	.DB  0x20,0x25,0x64,0x0,0x3D,0x25,0x64,0x0
	.DB  0x20,0x20,0x20,0x0,0x20,0x3C,0x2D,0x20
	.DB  0x25,0x64,0x0,0x31,0x2E,0x20,0x41,0x72
	.DB  0x61,0x68,0x20,0x50,0x65,0x72,0x34,0x61
	.DB  0x6E,0x20,0x31,0x0,0x32,0x2E,0x20,0x41
	.DB  0x72,0x61,0x68,0x20,0x50,0x65,0x72,0x34
	.DB  0x61,0x6E,0x20,0x32,0x0,0x33,0x2E,0x20
	.DB  0x41,0x72,0x61,0x68,0x20,0x50,0x65,0x72
	.DB  0x34,0x61,0x6E,0x20,0x33,0x0,0x34,0x2E
	.DB  0x20,0x41,0x72,0x61,0x68,0x20,0x50,0x65
	.DB  0x72,0x34,0x61,0x6E,0x20,0x34,0x0,0x35
	.DB  0x2E,0x20,0x41,0x72,0x61,0x68,0x20,0x50
	.DB  0x65,0x72,0x34,0x61,0x6E,0x20,0x35,0x0
	.DB  0x36,0x2E,0x20,0x41,0x72,0x61,0x68,0x20
	.DB  0x50,0x65,0x72,0x34,0x61,0x6E,0x20,0x36
	.DB  0x0,0x37,0x2E,0x20,0x41,0x72,0x61,0x68
	.DB  0x20,0x50,0x65,0x72,0x34,0x61,0x6E,0x20
	.DB  0x37,0x0,0x38,0x2E,0x20,0x41,0x72,0x61
	.DB  0x68,0x20,0x50,0x65,0x72,0x34,0x61,0x6E
	.DB  0x20,0x38,0x0,0x39,0x2E,0x20,0x41,0x72
	.DB  0x61,0x68,0x20,0x50,0x65,0x72,0x34,0x61
	.DB  0x6E,0x20,0x39,0x0,0x31,0x30,0x2E,0x20
	.DB  0x41,0x72,0x61,0x68,0x20,0x50,0x65,0x72
	.DB  0x34,0x61,0x6E,0x20,0x31,0x30,0x0,0x6C
	.DB  0x65,0x66,0x74,0x0,0x72,0x69,0x67,0x68
	.DB  0x74,0x0,0x6C,0x75,0x72,0x75,0x73,0x0
	.DB  0x3C,0x2D,0x0,0x31,0x2E,0x20,0x41,0x72
	.DB  0x61,0x68,0x20,0x50,0x65,0x72,0x34,0x61
	.DB  0x6E,0x20,0x0,0x32,0x2E,0x50,0x65,0x6D
	.DB  0x62,0x61,0x67,0x69,0x20,0x4B,0x70,0x20
	.DB  0x0,0x31,0x2E,0x20,0x53,0x70,0x65,0x65
	.DB  0x64,0x20,0x0,0x32,0x2E,0x20,0x53,0x63
	.DB  0x61,0x6E,0x20,0x64,0x65,0x70,0x61,0x6E
	.DB  0x20,0x0,0x33,0x2E,0x20,0x53,0x63,0x61
	.DB  0x6E,0x20,0x62,0x65,0x6C,0x61,0x6B,0x61
	.DB  0x6E,0x67,0x0,0x34,0x2E,0x20,0x44,0x72
	.DB  0x69,0x76,0x65,0x72,0x20,0x54,0x65,0x73
	.DB  0x74,0x0,0x44,0x6F,0x2D,0x43,0x61,0x72
	.DB  0x20,0x4C,0x50,0x4B,0x54,0x41,0x0,0x54
	.DB  0x46,0x20,0x46,0x54,0x20,0x55,0x47,0x4D
	.DB  0x20,0x32,0x30,0x30,0x39,0x0
_0x204005F:
	.DB  0x1
_0x2040000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0
_0x2060003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  0x07
	.DW  _0x471*2

	.DW  0x01
	.DW  __seed_G102
	.DW  _0x204005F*2

	.DW  0x02
	.DW  __base_y_G103
	.DW  _0x2060003*2

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
	LDI  R24,LOW(0x800)
	LDI  R25,HIGH(0x800)
	LDI  R26,0x60
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x85F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x85F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x260)
	LDI  R29,HIGH(0x260)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x260

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V1.25.9 Professional
;Automatic Program Generator
;© Copyright 1998-2008 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 28/03/2009
;Author  : aditya rifki
;Company : TE UGM
;Comments:
;
;
;Chip type           : ATmega16
;Program type        : Application
;Clock frequency     : 8,000000 MHz
;Memory model        : Small
;External SRAM size  : 0
;Data Stack size     : 256
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
;#include <math.h>
;#include <stdlib.h>
;
;// Alphanumeric LCD Module functions
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 0020 #endasm
;#include <lcd.h>
;
;#include <delay.h>
;#include <math.h>
;
;#define led           PORTC.7
;#define backlight     PORTB.3
;
;#define ADC_VREF_TYPE 0x60
;#define enter   PINC.0
;#define back    PIND.7
;
;#define dir_ki   PORTD.1
;#define dir_ka   PORTD.6
;#define pwm_ki   OCR1B
;#define pwm_ka   OCR1A
;
;bit status_error_lalu,status_error,pwm_en,black_line=1,per4an_enable=0,status_nos=0;
;bit white_line,berhasil=0,flag_per4an=0,flag_siku,front_kiri,front_kanan,rear_kiri,rear_kanan;
;unsigned char  l, menu, kp_div=13, menu_slave, strategi,temp_adc_menu,;
;unsigned char adc_result1[8],adc_result2[8],adc_tres1[8],adc_tres2[8],adc_menu,lcd[16];
;unsigned char max_adc1[8],max_adc2[8],min_adc1[8],min_adc2[8];
;unsigned int temp_langkah_nos[10],langkah_rem[10], langkah_cepat[10],langkah_nos[10];
;unsigned char nos_speed,boleh_nos,i,j,n,front_sensor,rear_sensor,disp_sensor,backlight_on,led_on,right_back,left_back;
;int i_speed,speed,MV,error,error_before,d_d_error,d_error,min_kp,max_kp,kp,kd,speed_ka,speed_ki,temp_speed;
;unsigned char set_per4an, per4an,siku,per4an_dir[11];
;unsigned char sampling_blank=0,sampling_blank_black=0,temp_kp_div;
;unsigned int siku_kiri=0, siku_kanan=0,time,count, nos, temp_langkah, langkah_kanan,langkah_kiri,langkah,step,sigma_langkah,k;
;eeprom int e_speed=130,e_min_kp=8,e_max_kp=30;
;eeprom unsigned char e_adc_tres1[8]={100,100,100,100,100,100,100,100};
;eeprom unsigned char e_adc_tres2[8]={100,100,100,100,100,100,100,100};
;eeprom unsigned char e_kp_div=16;
;eeprom unsigned char e_per4an_dir[11]={2,2,1,0,0,1,2,2,0,2};
;eeprom unsigned char e_per4an_enable=1;
;eeprom unsigned int e_langkah_nos[10], e_langkah_cepat[10];
;
;unsigned char depan_kanan, depan_kiri, tadi_depan_kanan, tadi_depan_kiri, fork_status, tadi_per4an, per4an, sekarang;
;unsigned char tadi_white_line, rear_sensor10, rear_sensor11, rear_sensor30, rear_sensor31;
;
;unsigned char read_adc(unsigned char adc_input)
; 0000 0049 {

	.CSEG
_read_adc:
; 0000 004A ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,LOW(0x60)
	OUT  0x7,R30
; 0000 004B // Delay needed for the stabilization of the ADC input voltage
; 0000 004C delay_us(10);
	__DELAY_USB 27
; 0000 004D // Start the AD conversion
; 0000 004E ADCSRA|=0x40;
	SBI  0x6,6
; 0000 004F // Wait for the AD conversion to complete
; 0000 0050 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0051 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0052 return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0053 }
;void init_IO()
; 0000 0055 {
_init_IO:
; 0000 0056 unsigned char ;
; 0000 0057 DDRA=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0058 PORTA=0b00000000;
	OUT  0x1B,R30
; 0000 0059 
; 0000 005A DDRB=0b11111111;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 005B PORTB=0b00000000;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 005C 
; 0000 005D DDRC=0b11111100;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0000 005E PORTC=0b10000011;
	LDI  R30,LOW(131)
	OUT  0x15,R30
; 0000 005F 
; 0000 0060 DDRD= 0b01110010;
	LDI  R30,LOW(114)
	OUT  0x11,R30
; 0000 0061 PORTD=0b10001100;
	LDI  R30,LOW(140)
	OUT  0x12,R30
; 0000 0062 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0063 }
	RET
;
;void init_ADC()
; 0000 0066 {
_init_ADC:
; 0000 0067 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(96)
	OUT  0x7,R30
; 0000 0068 ADCSRA=0x86;
	LDI  R30,LOW(134)
	OUT  0x6,R30
; 0000 0069 }
	RET
;
;
;void pwm_on()
; 0000 006D {
_pwm_on:
; 0000 006E pwm_en=1;
	SET
	BLD  R2,2
; 0000 006F TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0070 TCCR1B=0x03;
	LDI  R30,LOW(3)
	RJMP _0x20C0008
; 0000 0071 }
;
;void pwm_off()
; 0000 0074 {
_pwm_off:
; 0000 0075 pwm_en=0;
	CLT
	BLD  R2,2
; 0000 0076 dir_ki=0;
	CBI  0x12,1
; 0000 0077 dir_ka=0;
	CBI  0x12,6
; 0000 0078 TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0079 TCCR1B=0x00;
_0x20C0008:
	OUT  0x2E,R30
; 0000 007A }
	RET
;
;
;
;void read_sensor()
; 0000 007F {
_read_sensor:
; 0000 0080 front_kanan=0;
	CLT
	BLD  R3,3
; 0000 0081 front_kiri=0;
	BLD  R3,2
; 0000 0082 rear_kiri=0;
	BLD  R3,4
; 0000 0083 rear_kanan=0;
	BLD  R3,5
; 0000 0084 front_sensor=0;
	LDI  R30,LOW(0)
	STS  _front_sensor,R30
; 0000 0085 rear_sensor=0;
	STS  _rear_sensor,R30
; 0000 0086 
; 0000 0087 for(i=0;i<8;i++)
	CLR  R12
_0xB:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRLO PC+3
	JMP _0xC
; 0000 0088     {
; 0000 0089         if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
	TST  R12
	BRNE _0xD
	CBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 008A         else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
	RJMP _0x14
_0xD:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x15
	CBI  0x15,6
	CBI  0x15,5
	RJMP _0x42E
; 0000 008B         else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
_0x15:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x1D
	CBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 008C         else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
	RJMP _0x24
_0x1D:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0x25
	CBI  0x15,6
	RJMP _0x42F
; 0000 008D         else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
_0x25:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x2D
	SBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 008E         else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
	RJMP _0x34
_0x2D:
	LDI  R30,LOW(5)
	CP   R30,R12
	BRNE _0x35
	SBI  0x15,6
	CBI  0x15,5
	RJMP _0x42E
; 0000 008F         else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
_0x35:
	LDI  R30,LOW(6)
	CP   R30,R12
	BRNE _0x3D
	SBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 0090         else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
	RJMP _0x44
_0x3D:
	LDI  R30,LOW(7)
	CP   R30,R12
	BRNE _0x45
	SBI  0x15,6
_0x42F:
	SBI  0x15,5
_0x42E:
	SBI  0x15,4
; 0000 0091         adc_result1[i]=read_adc(7);//depan
_0x45:
_0x44:
_0x34:
_0x24:
_0x14:
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0092         adc_result2[i]=read_adc(6);//belakang
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_result2)
	SBCI R31,HIGH(-_adc_result2)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0093     }
	INC  R12
	RJMP _0xB
_0xC:
; 0000 0094 
; 0000 0095 for(i=0;i<8;i++)
	CLR  R12
_0x4D:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x4E
; 0000 0096     {
; 0000 0097     if      (adc_result1[i]>adc_tres1[i]){front_sensor=front_sensor|1<<i;}
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	CP   R30,R26
	BRSH _0x4F
	MOV  R30,R12
	LDI  R26,LOW(1)
	CALL __LSLB12
	LDS  R26,_front_sensor
	OR   R30,R26
	RJMP _0x430
; 0000 0098     else if (adc_result1[i]<adc_tres1[i]){front_sensor=front_sensor|0<<i;}
_0x4F:
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	CP   R26,R30
	BRSH _0x51
	LDS  R30,_front_sensor
_0x430:
	STS  _front_sensor,R30
; 0000 0099 
; 0000 009A     if      (adc_result2[i]>adc_tres2[i]){rear_sensor=rear_sensor|1<<i;}
_0x51:
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	CP   R30,R26
	BRSH _0x52
	MOV  R30,R12
	LDI  R26,LOW(1)
	CALL __LSLB12
	LDS  R26,_rear_sensor
	OR   R30,R26
	RJMP _0x431
; 0000 009B     else if (adc_result2[i]<adc_tres2[i]){rear_sensor=rear_sensor|0<<i;}
_0x52:
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2
	CP   R26,R30
	BRSH _0x54
	LDS  R30,_rear_sensor
_0x431:
	STS  _rear_sensor,R30
; 0000 009C     }
_0x54:
	INC  R12
	RJMP _0x4D
_0x4E:
; 0000 009D 
; 0000 009E rear_sensor=0b01111110&rear_sensor;
	LDS  R30,_rear_sensor
	ANDI R30,LOW(0x7E)
	STS  _rear_sensor,R30
; 0000 009F 
; 0000 00A0 if(adc_result1[0]>adc_tres1[0])front_kiri=1;
	LDS  R30,_adc_tres1
	LDS  R26,_adc_result1
	CP   R30,R26
	BRSH _0x55
	SET
	BLD  R3,2
; 0000 00A1 // else if(adc_result[0]<adc_tres[0])front_kiri=0;
; 0000 00A2 
; 0000 00A3 if(adc_result1[7]>adc_tres1[7])front_kanan=1;
_0x55:
	__GETB2MN _adc_result1,7
	__GETB1MN _adc_tres1,7
	CP   R30,R26
	BRSH _0x56
	SET
	BLD  R3,3
; 0000 00A4 //else if(adc_result[7]<adc_tres[7])front_kanan=0;
; 0000 00A5 
; 0000 00A6 if(adc_result2[1]>adc_tres2[1]||adc_result2[2]>adc_tres2[2]||adc_result2[3]>adc_tres2[3])rear_kanan=1;
_0x56:
	__GETB2MN _adc_result2,1
	__GETB1MN _adc_tres2,1
	CP   R30,R26
	BRLO _0x58
	__GETB2MN _adc_result2,2
	__GETB1MN _adc_tres2,2
	CP   R30,R26
	BRLO _0x58
	__GETB2MN _adc_result2,3
	__GETB1MN _adc_tres2,3
	CP   R30,R26
	BRSH _0x57
_0x58:
	SET
	RJMP _0x432
; 0000 00A7 else if(adc_result2[1]>adc_tres2[1]||adc_result2[2]>adc_tres2[2]||adc_result2[3]>adc_tres2[3])rear_kanan=0;
_0x57:
	__GETB2MN _adc_result2,1
	__GETB1MN _adc_tres2,1
	CP   R30,R26
	BRLO _0x5C
	__GETB2MN _adc_result2,2
	__GETB1MN _adc_tres2,2
	CP   R30,R26
	BRLO _0x5C
	__GETB2MN _adc_result2,3
	__GETB1MN _adc_tres2,3
	CP   R30,R26
	BRSH _0x5B
_0x5C:
	CLT
_0x432:
	BLD  R3,5
; 0000 00A8 
; 0000 00A9 if(adc_result2[6]>adc_tres2[6]||adc_result2[5]>adc_tres2[5]||adc_result2[4]>adc_tres2[4])rear_kiri=1;
_0x5B:
	__GETB2MN _adc_result2,6
	__GETB1MN _adc_tres2,6
	CP   R30,R26
	BRLO _0x5F
	__GETB2MN _adc_result2,5
	__GETB1MN _adc_tres2,5
	CP   R30,R26
	BRLO _0x5F
	__GETB2MN _adc_result2,4
	__GETB1MN _adc_tres2,4
	CP   R30,R26
	BRSH _0x5E
_0x5F:
	SET
	RJMP _0x433
; 0000 00AA else if(adc_result2[6]>adc_tres2[6]||adc_result2[5]>adc_tres2[5]||adc_result2[4]>adc_tres2[4])rear_kiri=0;
_0x5E:
	__GETB2MN _adc_result2,6
	__GETB1MN _adc_tres2,6
	CP   R30,R26
	BRLO _0x63
	__GETB2MN _adc_result2,5
	__GETB1MN _adc_tres2,5
	CP   R30,R26
	BRLO _0x63
	__GETB2MN _adc_result2,4
	__GETB1MN _adc_tres2,4
	CP   R30,R26
	BRSH _0x62
_0x63:
	CLT
_0x433:
	BLD  R3,4
; 0000 00AB }
_0x62:
	RET
;
;void read_rear_sensor()
; 0000 00AE {
; 0000 00AF rear_sensor=0;
; 0000 00B0 rear_kiri=0;
; 0000 00B1 rear_kanan=0;
; 0000 00B2 
; 0000 00B3 for(i=0;i<8;i++)
; 0000 00B4     {
; 0000 00B5         if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
; 0000 00B6         else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
; 0000 00B7         else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
; 0000 00B8         else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
; 0000 00B9         else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
; 0000 00BA         else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
; 0000 00BB         else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
; 0000 00BC         else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
; 0000 00BD             adc_result2[i]=read_adc(6);//belakang
; 0000 00BE     }
; 0000 00BF 
; 0000 00C0 
; 0000 00C1 for(i=0;i<8;i++)
; 0000 00C2     {
; 0000 00C3 
; 0000 00C4     if      (adc_result2[i]>adc_tres2[i]){rear_sensor=rear_sensor|1<<i;}
; 0000 00C5     else if (adc_result2[i]<adc_tres2[i]){rear_sensor=rear_sensor|0<<i;}
; 0000 00C6 
; 0000 00C7 if(adc_result1[0]>adc_tres1[0])front_kiri=1;
; 0000 00C8 // else if(adc_result[0]<adc_tres[0])front_kiri=0;
; 0000 00C9 
; 0000 00CA if(adc_result1[7]>adc_tres1[7])front_kanan=1;
; 0000 00CB //else if(adc_result[7]<adc_tres[7])front_kanan=0;
; 0000 00CC     }
; 0000 00CD 
; 0000 00CE rear_sensor=0b01111110&rear_sensor;
; 0000 00CF }
;
;void read_front_sensor()
; 0000 00D2 {
; 0000 00D3 front_sensor=0;
; 0000 00D4 front_kanan=0;
; 0000 00D5 front_kiri=0;
; 0000 00D6 
; 0000 00D7 for(i=0;i<8;i++)
; 0000 00D8     {
; 0000 00D9         if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
; 0000 00DA         else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
; 0000 00DB         else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
; 0000 00DC         else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
; 0000 00DD         else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
; 0000 00DE         else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
; 0000 00DF         else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
; 0000 00E0         else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
; 0000 00E1         adc_result1[i]=read_adc(7);//depan
; 0000 00E2 
; 0000 00E3 if(adc_result1[0]>adc_tres1[0])front_kiri=1;
; 0000 00E4 // else if(adc_result[0]<adc_tres[0])front_kiri=0;
; 0000 00E5 
; 0000 00E6 if(adc_result1[7]>adc_tres1[7])front_kanan=1;
; 0000 00E7 //else if(adc_result[7]<adc_tres[7])front_kanan=0;
; 0000 00E8     }
; 0000 00E9 
; 0000 00EA 
; 0000 00EB for(i=0;i<8;i++)
; 0000 00EC     {
; 0000 00ED     if      (adc_result1[i]>adc_tres1[i]){front_sensor=front_sensor|1<<i;}
; 0000 00EE     else if (adc_result1[i]<adc_tres1[i]){front_sensor=front_sensor|0<<i;}
; 0000 00EF     }
; 0000 00F0 }
;
;void ka_maju()
; 0000 00F3 {
_ka_maju:
; 0000 00F4 dir_ka=0;
	CBI  0x12,6
; 0000 00F5 pwm_ka=speed_ka;
	RJMP _0x20C0007
; 0000 00F6 }
;
;void ka_mund()
; 0000 00F9 {
_ka_mund:
; 0000 00FA if(pwm_en==1)dir_ka  =1;
	SBRC R2,2
	SBI  0x12,6
; 0000 00FB speed_ka=255+speed_ka;
	CALL SUBOPT_0x3
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	CALL SUBOPT_0x4
; 0000 00FC pwm_ka  =speed_ka;
_0x20C0007:
	LDS  R30,_speed_ka
	LDS  R31,_speed_ka+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 00FD }
	RET
;
;void ki_maju()
; 0000 0100 {
_ki_maju:
; 0000 0101 dir_ki=0;
	CBI  0x12,1
; 0000 0102 pwm_ki=speed_ki;
	RJMP _0x20C0006
; 0000 0103 }
;
;void ki_mund()
; 0000 0106 {
_ki_mund:
; 0000 0107 if(pwm_en==1)dir_ki  =1;
	SBRC R2,2
	SBI  0x12,1
; 0000 0108 speed_ki=255+speed_ki;
	CALL SUBOPT_0x5
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	CALL SUBOPT_0x6
; 0000 0109 pwm_ki  =speed_ki;
_0x20C0006:
	LDS  R30,_speed_ki
	LDS  R31,_speed_ki+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 010A }
	RET
;
;
;
;void pwm_out()
; 0000 010F {
_pwm_out:
; 0000 0110 lcd_clear();
	CALL _lcd_clear
; 0000 0111 if      (speed_ka>255)  speed_ka  =255;
	LDS  R26,_speed_ka
	LDS  R27,_speed_ka+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x103
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x43A
; 0000 0112 else if (speed_ka<-255) speed_ka  =-255;
_0x103:
	LDS  R26,_speed_ka
	LDS  R27,_speed_ka+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x105
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
_0x43A:
	STS  _speed_ka,R30
	STS  _speed_ka+1,R31
; 0000 0113 
; 0000 0114 if      (speed_ki>255)  speed_ki  =255;
_0x105:
	LDS  R26,_speed_ki
	LDS  R27,_speed_ki+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x106
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RJMP _0x43B
; 0000 0115 else if (speed_ki<-255) speed_ki  =-255;
_0x106:
	LDS  R26,_speed_ki
	LDS  R27,_speed_ki+1
	CPI  R26,LOW(0xFF01)
	LDI  R30,HIGH(0xFF01)
	CPC  R27,R30
	BRGE _0x108
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
_0x43B:
	STS  _speed_ki,R30
	STS  _speed_ki+1,R31
; 0000 0116 
; 0000 0117 
; 0000 0118     for(i=0;i<8;i++)
_0x108:
	CLR  R12
_0x10A:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x10B
; 0000 0119         {
; 0000 011A         disp_sensor=0;
	CALL SUBOPT_0x7
; 0000 011B         disp_sensor=front_sensor>>i;
; 0000 011C         disp_sensor=(disp_sensor)&(0b00000001);
; 0000 011D         n=i;
; 0000 011E         lcd_gotoxy(n,0);
; 0000 011F         sprintf(lcd,"%d",disp_sensor);
; 0000 0120         lcd_puts(lcd);
; 0000 0121         }
	INC  R12
	RJMP _0x10A
_0x10B:
; 0000 0122 
; 0000 0123     for(i=0;i<8;i++)
	CLR  R12
_0x10D:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x10E
; 0000 0124         {
; 0000 0125         disp_sensor=0;
	CALL SUBOPT_0x8
; 0000 0126         disp_sensor=rear_sensor>>i;
; 0000 0127         disp_sensor=(disp_sensor)&(0b00000001);
; 0000 0128         n=i;
; 0000 0129         lcd_gotoxy(n,1);
; 0000 012A         sprintf(lcd,"%d",disp_sensor);
; 0000 012B         lcd_puts(lcd);
; 0000 012C         }
	INC  R12
	RJMP _0x10D
_0x10E:
; 0000 012D 
; 0000 012E lcd_gotoxy(9,0);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x9
; 0000 012F sprintf(lcd,"%d",error);
	CALL SUBOPT_0xA
	CALL SUBOPT_0xB
; 0000 0130 lcd_puts(lcd);
; 0000 0131 
; 0000 0132 lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x9
; 0000 0133 sprintf(lcd,"%d",langkah);
	LDS  R30,_langkah
	LDS  R31,_langkah+1
	CLR  R22
	CLR  R23
	CALL SUBOPT_0xC
; 0000 0134 lcd_puts(lcd);
; 0000 0135 
; 0000 0136 lcd_gotoxy(15,0);
	LDI  R30,LOW(15)
	CALL SUBOPT_0x9
; 0000 0137 sprintf(lcd,"%d",per4an);
	LDS  R30,_per4an
	CALL SUBOPT_0xD
; 0000 0138 lcd_puts(lcd);
; 0000 0139 
; 0000 013A lcd_gotoxy(8,1);
	CALL SUBOPT_0xE
; 0000 013B sprintf(lcd,"%d",speed_ki);
	CALL SUBOPT_0x5
	CALL SUBOPT_0xB
; 0000 013C lcd_puts(lcd);
; 0000 013D 
; 0000 013E lcd_gotoxy(13,1);
	LDI  R30,LOW(13)
	CALL SUBOPT_0xF
; 0000 013F sprintf(lcd,"%d",speed_ka);
	CALL SUBOPT_0x10
	CALL SUBOPT_0x3
	CALL SUBOPT_0xB
; 0000 0140 lcd_puts(lcd);
; 0000 0141 
; 0000 0142 if      (speed_ka >=0)  ka_maju();
	LDS  R26,_speed_ka+1
	TST  R26
	BRMI _0x10F
	RCALL _ka_maju
; 0000 0143 else if (speed_ka <0)   ka_mund();
	RJMP _0x110
_0x10F:
	LDS  R26,_speed_ka+1
	TST  R26
	BRPL _0x111
	RCALL _ka_mund
; 0000 0144 
; 0000 0145 if      (speed_ki >=0)  ki_maju();
_0x111:
_0x110:
	LDS  R26,_speed_ki+1
	TST  R26
	BRMI _0x112
	RCALL _ki_maju
; 0000 0146 else if (speed_ki <0)   ki_mund();
	RJMP _0x113
_0x112:
	LDS  R26,_speed_ki+1
	TST  R26
	BRPL _0x114
	RCALL _ki_mund
; 0000 0147 }
_0x114:
_0x113:
	RET
;
;
;void rem()
; 0000 014B {
_rem:
; 0000 014C speed_ka=-100;speed_ki=-100;pwm_out();delay_ms(50);
	CALL SUBOPT_0x11
	CALL SUBOPT_0x12
	RCALL _pwm_out
	CALL SUBOPT_0x13
; 0000 014D }
	RET
;
;
;void komp_pid()
; 0000 0151 {
_komp_pid:
; 0000 0152 d_error =error-error_before;
	LDS  R26,_error_before
	LDS  R27,_error_before+1
	CALL SUBOPT_0xA
	SUB  R30,R26
	SBC  R31,R27
	STS  _d_error,R30
	STS  _d_error+1,R31
; 0000 0153 MV      =(kp*error)+(kd*d_error);
	CALL SUBOPT_0xA
	LDS  R26,_kp
	LDS  R27,_kp+1
	CALL __MULW12
	MOVW R22,R30
	LDS  R30,_d_error
	LDS  R31,_d_error+1
	LDS  R26,_kd
	LDS  R27,_kd+1
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	STS  _MV,R30
	STS  _MV+1,R31
; 0000 0154 
; 0000 0155 speed_ka=i_speed+MV;
	CALL SUBOPT_0x14
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x4
; 0000 0156 speed_ki=i_speed-MV;
	LDS  R26,_MV
	LDS  R27,_MV+1
	LDS  R30,_i_speed
	LDS  R31,_i_speed+1
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x6
; 0000 0157 
; 0000 0158 error_before=error;
	CALL SUBOPT_0xA
	STS  _error_before,R30
	STS  _error_before+1,R31
; 0000 0159 d_d_error=error-d_error;
	LDS  R26,_d_error
	LDS  R27,_d_error+1
	CALL SUBOPT_0xA
	SUB  R30,R26
	SBC  R31,R27
	STS  _d_d_error,R30
	STS  _d_d_error+1,R31
; 0000 015A }
	RET
;
;void giving_weight10()
; 0000 015D {
_giving_weight10:
; 0000 015E switch(front_sensor)
	CALL SUBOPT_0x15
; 0000 015F     {
; 0000 0160     case 0b00000001:error=  16;white_line=0;break;
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x118
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP _0x43C
; 0000 0161     case 0b00000010:error=  10;white_line=0;break;
_0x118:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x119
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP _0x43C
; 0000 0162     case 0b00000100:error=   5;white_line=0;break;
_0x119:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x11A
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x43C
; 0000 0163     case 0b00001000:error=   1;white_line=0;kp=speed/20;kd=6*kp;break;
_0x11A:
	CPI  R30,LOW(0x8)
	LDI  R26,HIGH(0x8)
	CPC  R31,R26
	BRNE _0x11B
	CALL SUBOPT_0x16
	RJMP _0x117
; 0000 0164     case 0b00010000:error=  -1;white_line=0;kp=speed/20;kd=6*kp;break;
_0x11B:
	CPI  R30,LOW(0x10)
	LDI  R26,HIGH(0x10)
	CPC  R31,R26
	BRNE _0x11C
	CALL SUBOPT_0x17
	RJMP _0x117
; 0000 0165     case 0b00100000:error=  -5;white_line=0;break;
_0x11C:
	CPI  R30,LOW(0x20)
	LDI  R26,HIGH(0x20)
	CPC  R31,R26
	BRNE _0x11D
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	RJMP _0x43C
; 0000 0166     case 0b01000000:error= -10;white_line=0;break;
_0x11D:
	CPI  R30,LOW(0x40)
	LDI  R26,HIGH(0x40)
	CPC  R31,R26
	BRNE _0x11E
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	RJMP _0x43C
; 0000 0167     case 0b10000000:error= -16;white_line=0;break;
_0x11E:
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRNE _0x117
	LDI  R30,LOW(65520)
	LDI  R31,HIGH(65520)
_0x43C:
	STS  _error,R30
	STS  _error+1,R31
	CLT
	BLD  R2,6
; 0000 0168     }
_0x117:
; 0000 0169 }
	RET
;
;void giving_weight20()
; 0000 016C {
_giving_weight20:
; 0000 016D switch(front_sensor)
	CALL SUBOPT_0x15
; 0000 016E     {
; 0000 016F     case 0b00000011:error=  13;white_line=0;break;
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x123
	LDI  R30,LOW(13)
	LDI  R31,HIGH(13)
	RJMP _0x43D
; 0000 0170     case 0b00000110:error=   7;white_line=0;break;
_0x123:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0x124
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	RJMP _0x43D
; 0000 0171     case 0b00001100:error=   3;white_line=0;break;
_0x124:
	CPI  R30,LOW(0xC)
	LDI  R26,HIGH(0xC)
	CPC  R31,R26
	BRNE _0x125
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP _0x43D
; 0000 0172     case 0b00011000:error=   0;kp=speed/20;kd=6*kp;white_line=0;break;
_0x125:
	CPI  R30,LOW(0x18)
	LDI  R26,HIGH(0x18)
	CPC  R31,R26
	BRNE _0x126
	LDI  R30,LOW(0)
	STS  _error,R30
	STS  _error+1,R30
	LDS  R26,_speed
	LDS  R27,_speed+1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x18
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL SUBOPT_0x19
	RJMP _0x43E
; 0000 0173     case 0b00110000:error=  -3;white_line=0;break;
_0x126:
	CPI  R30,LOW(0x30)
	LDI  R26,HIGH(0x30)
	CPC  R31,R26
	BRNE _0x127
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	RJMP _0x43D
; 0000 0174     case 0b01100000:error=  -7;white_line=0;break;
_0x127:
	CPI  R30,LOW(0x60)
	LDI  R26,HIGH(0x60)
	CPC  R31,R26
	BRNE _0x128
	LDI  R30,LOW(65529)
	LDI  R31,HIGH(65529)
	RJMP _0x43D
; 0000 0175     case 0b11000000:error= -13;white_line=0;break;
_0x128:
	CPI  R30,LOW(0xC0)
	LDI  R26,HIGH(0xC0)
	CPC  R31,R26
	BRNE _0x122
	LDI  R30,LOW(65523)
	LDI  R31,HIGH(65523)
_0x43D:
	STS  _error,R30
	STS  _error+1,R31
_0x43E:
	CLT
	BLD  R2,6
; 0000 0176     }
_0x122:
; 0000 0177 }
	RET
;
;void giving_weight30()
; 0000 017A {
_giving_weight30:
; 0000 017B switch(front_sensor)
	CALL SUBOPT_0x15
; 0000 017C     {
; 0000 017D     case 0b00000111:error=  10;white_line=0;break;
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x12D
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP _0x43F
; 0000 017E     case 0b00001110:error=   5;white_line=0;break;
_0x12D:
	CPI  R30,LOW(0xE)
	LDI  R26,HIGH(0xE)
	CPC  R31,R26
	BRNE _0x12E
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	RJMP _0x43F
; 0000 017F     case 0b00011100:error=   1;white_line=0;kp=speed/20;kd=6*kp;break;
_0x12E:
	CPI  R30,LOW(0x1C)
	LDI  R26,HIGH(0x1C)
	CPC  R31,R26
	BRNE _0x12F
	CALL SUBOPT_0x16
	RJMP _0x12C
; 0000 0180     case 0b00111000:error=  -1;white_line=0;kp=speed/20;kd=6*kp;break;
_0x12F:
	CPI  R30,LOW(0x38)
	LDI  R26,HIGH(0x38)
	CPC  R31,R26
	BRNE _0x130
	CALL SUBOPT_0x17
	RJMP _0x12C
; 0000 0181     case 0b01110000:error=  -5;white_line=0;break;
_0x130:
	CPI  R30,LOW(0x70)
	LDI  R26,HIGH(0x70)
	CPC  R31,R26
	BRNE _0x131
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	RJMP _0x43F
; 0000 0182     case 0b11100000:error= -10;white_line=0;break;
_0x131:
	CPI  R30,LOW(0xE0)
	LDI  R26,HIGH(0xE0)
	CPC  R31,R26
	BRNE _0x12C
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
_0x43F:
	STS  _error,R30
	STS  _error+1,R31
	CLT
	BLD  R2,6
; 0000 0183     }
_0x12C:
; 0000 0184 }
	RET
;
;void giving_weight11()
; 0000 0187 {
; 0000 0188 switch(front_sensor)
; 0000 0189     {
; 0000 018A     case 0b11111110:error=  16; backlight_on=10;white_line=1;break;
; 0000 018B     case 0b11111101:error=  10;backlight_on=10;white_line=1;break;
; 0000 018C     case 0b11111011:error=   5;backlight_on=10;white_line=1;break;
; 0000 018D     case 0b11110111:error=   1;backlight_on=10;white_line=1;kp=speed/20;kd=6*kp;break;
; 0000 018E     case 0b11101111:error=  -1;backlight_on=10;white_line=1;kp=speed/20;kd=6*kp;break;
; 0000 018F     case 0b11011111:error=  -5;backlight_on=10;white_line=1;break;
; 0000 0190     case 0b10111111:error= -10;backlight_on=10;white_line=1;break;
; 0000 0191     case 0b01111111:error= -16;backlight_on=10;white_line=1;break;
; 0000 0192     }
; 0000 0193 }
;
;void giving_weight21()
; 0000 0196 {
; 0000 0197 switch(front_sensor)
; 0000 0198     {
; 0000 0199     case 0b11111100:error=  13;backlight_on=10;white_line=1;break;
; 0000 019A     case 0b11111001:error=   7;backlight_on=10;white_line=1;break;
; 0000 019B     case 0b11110011:error=   3;backlight_on=10;white_line=1;break;
; 0000 019C     case 0b11100111:error=   0;backlight_on=10;white_line=1;kp=speed/20;kd=6*kp;break;
; 0000 019D     case 0b11001111:error=  -3;backlight_on=10;white_line=1;break;
; 0000 019E     case 0b10011111:error=  -7;backlight_on=10;white_line=1;break;
; 0000 019F     case 0b00111111:error= -13;backlight_on=10;white_line=1;break;
; 0000 01A0     }
; 0000 01A1 }
;
;void giving_weight31()
; 0000 01A4 {
; 0000 01A5 switch(front_sensor)
; 0000 01A6     {
; 0000 01A7     case 0b11111000:error=  10;white_line=1;break;
; 0000 01A8     case 0b11110001:error=   5;white_line=1;break;
; 0000 01A9     case 0b11100011:error=   1;kp=speed/20;kd=6*kp;break;
; 0000 01AA     case 0b11000111:error=  -1;kp=speed/20;kd=6*kp;break;
; 0000 01AB     case 0b10001111:error=  -5;white_line=1;break;
; 0000 01AC     case 0b00011111:error= -10;white_line=1;break;
; 0000 01AD     }
; 0000 01AE }
;
;void per4an_handler()
; 0000 01B1 {
; 0000 01B2    if(per4an>=9) goto selesai;
; 0000 01B3    per4an++;
; 0000 01B4 
; 0000 01B5 
; 0000 01B6     if(per4an_dir[per4an]==0) //pilih kiri
; 0000 01B7     {
; 0000 01B8       berhasil=1;
; 0000 01B9       error=15;
; 0000 01BA       speed_ki=-150;
; 0000 01BB       speed_ka=-150;
; 0000 01BC       pwm_out();
; 0000 01BD       delay_ms(40);
; 0000 01BE       /*
; 0000 01BF       if(per4an==4)
; 0000 01C0       {
; 0000 01C1          speed_ki=-200;
; 0000 01C2          speed_ka=80;
; 0000 01C3       }
; 0000 01C4       else
; 0000 01C5       {
; 0000 01C6       speed_ki=-200;
; 0000 01C7       speed_ka=120;
; 0000 01C8     }
; 0000 01C9       */
; 0000 01CA         speed_ki=-200;
; 0000 01CB         speed_ka=120;
; 0000 01CC 
; 0000 01CD       pwm_out();
; 0000 01CE       //error=7;
; 0000 01CF       for(;;){read_front_sensor();if(front_sensor==0b00000011||front_sensor==0b00000001||front_sensor==0b00000010)break;}
; 0000 01D0 
; 0000 01D1       for(;;){i_speed=-100;read_sensor();giving_weight10();giving_weight20();kp_div=kp_div+3;
; 0000 01D2       kp=speed/kp_div;kd=4*kp;komp_pid();pwm_out();if(-3<=error<=3){i_speed=130;speed=temp_speed; break;}}
; 0000 01D3     }
; 0000 01D4     else if (per4an_dir[per4an]==1) //pilih kanan
; 0000 01D5     {
; 0000 01D6       berhasil=1;
; 0000 01D7       error=-15;
; 0000 01D8       speed_ki=-150;
; 0000 01D9       speed_ka=-150;
; 0000 01DA       pwm_out();
; 0000 01DB       delay_ms(50);
; 0000 01DC       speed_ki=120;
; 0000 01DD       speed_ka=-200;
; 0000 01DE       pwm_out();
; 0000 01DF       //error=-7;
; 0000 01E0       for(;;){read_front_sensor();delay_ms(2);if(front_sensor==0b10000000||front_sensor==0b11000000||front_sensor==0b01000000)break;}
; 0000 01E1       kp_div=kp_div+3;
; 0000 01E2       kp=speed/kp_div;
; 0000 01E3       kd=4*kp;
; 0000 01E4       for(;;){i_speed=-120;read_sensor();giving_weight10();giving_weight20();kp_div=kp_div+3;
; 0000 01E5       kp=speed/kp_div;kd=4*kp;komp_pid();pwm_out();delay_ms(2);if(-3<=error<=3){i_speed=180;speed=temp_speed; break;}}
; 0000 01E6     }
; 0000 01E7     else delay_ms(30);
; 0000 01E8     //if(per4an<5)speed=130;
; 0000 01E9     //else speed=temp_speed;
; 0000 01EA 
; 0000 01EB    flag_per4an=1; right_back=0;left_back=0;
; 0000 01EC    selesai:
; 0000 01ED    #asm("sei")
; 0000 01EE }
;
;void fork_Y()
; 0000 01F1 {
_fork_Y:
; 0000 01F2 switch (fork_status)
	LDS  R30,_fork_status
	LDI  R31,0
; 0000 01F3     {
; 0000 01F4     case 0: error=  14;break;
	SBIW R30,0
	BRNE _0x16E
	LDI  R30,LOW(14)
	LDI  R31,HIGH(14)
	RJMP _0x443
; 0000 01F5     case 1: error= -14;break;
_0x16E:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x16D
	LDI  R30,LOW(65522)
	LDI  R31,HIGH(65522)
_0x443:
	STS  _error,R30
	STS  _error+1,R31
; 0000 01F6     }
_0x16D:
; 0000 01F7 }
	RET
;
;void scan_Y()
; 0000 01FA {
_scan_Y:
; 0000 01FB switch(front_sensor)
	CALL SUBOPT_0x15
; 0000 01FC         {
; 0000 01FD         case 0b01000010:fork_Y();break;
	CPI  R30,LOW(0x42)
	LDI  R26,HIGH(0x42)
	CPC  R31,R26
	BREQ _0x444
; 0000 01FE         case 0b10000001:fork_Y();break;
	CPI  R30,LOW(0x81)
	LDI  R26,HIGH(0x81)
	CPC  R31,R26
	BREQ _0x444
; 0000 01FF         case 0b11000011:fork_Y();break;
	CPI  R30,LOW(0xC3)
	LDI  R26,HIGH(0xC3)
	CPC  R31,R26
	BREQ _0x444
; 0000 0200         case 0b10000011:fork_Y();break;
	CPI  R30,LOW(0x83)
	LDI  R26,HIGH(0x83)
	CPC  R31,R26
	BREQ _0x444
; 0000 0201         case 0b11000001:fork_Y();break;
	CPI  R30,LOW(0xC1)
	LDI  R26,HIGH(0xC1)
	CPC  R31,R26
	BREQ _0x444
; 0000 0202         case 0b11000110:fork_Y();break;
	CPI  R30,LOW(0xC6)
	LDI  R26,HIGH(0xC6)
	CPC  R31,R26
	BREQ _0x444
; 0000 0203         case 0b01100011:fork_Y();break;
	CPI  R30,LOW(0x63)
	LDI  R26,HIGH(0x63)
	CPC  R31,R26
	BREQ _0x444
; 0000 0204         case 0b01000011:fork_Y();break;
	CPI  R30,LOW(0x43)
	LDI  R26,HIGH(0x43)
	CPC  R31,R26
	BREQ _0x444
; 0000 0205         case 0b01100010:fork_Y();break;
	CPI  R30,LOW(0x62)
	LDI  R26,HIGH(0x62)
	CPC  R31,R26
	BRNE _0x172
_0x444:
	RCALL _fork_Y
; 0000 0206         }
_0x172:
; 0000 0207 }
	RET
;
;void lurus()
; 0000 020A {
_lurus:
; 0000 020B speed_ki=speed;speed_ka=speed;pwm_out();delay_ms(80);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x6
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP _0x20C0005
; 0000 020C }
;
;
;void cross_handler()
; 0000 0210 {
_cross_handler:
; 0000 0211     depan_kanan= 0b00000001&&front_sensor;
	LDI  R30,LOW(1)
	CPI  R30,0
	BREQ _0x17C
	LDS  R30,_front_sensor
	CPI  R30,0
	BREQ _0x17C
	LDI  R30,1
	RJMP _0x17D
_0x17C:
	LDI  R30,0
_0x17D:
	STS  _depan_kanan,R30
; 0000 0212     depan_kiri= 0b10000000&&front_sensor;
	LDI  R30,LOW(128)
	CPI  R30,0
	BREQ _0x17E
	LDS  R30,_front_sensor
	CPI  R30,0
	BREQ _0x17E
	LDI  R30,1
	RJMP _0x17F
_0x17E:
	LDI  R30,0
_0x17F:
	STS  _depan_kiri,R30
; 0000 0213     led=1;
	CALL SUBOPT_0x1C
; 0000 0214     backlight=0;
; 0000 0215     delay_ms(200);
; 0000 0216     led=0;
; 0000 0217     backlight=1;
; 0000 0218     delay_ms(200);
; 0000 0219     led=1;
; 0000 021A     delay_ms(200);
; 0000 021B     led=0;
; 0000 021C     backlight=0;
; 0000 021D     delay_ms(500);
; 0000 021E     backlight=1;
; 0000 021F     led=1;
; 0000 0220 
; 0000 0221     sekarang =e_per4an_dir[per4an];
	LDS  R26,_per4an
	LDI  R27,0
	SUBI R26,LOW(-_e_per4an_dir)
	SBCI R27,HIGH(-_e_per4an_dir)
	CALL __EEPROMRDB
	STS  _sekarang,R30
; 0000 0222     switch (sekarang)
	LDI  R31,0
; 0000 0223             {
; 0000 0224             case 0: rem();
	SBIW R30,0
	BRNE _0x195
	RCALL _rem
; 0000 0225                     speed_ki=-150;speed_ka=150;pwm_out();  //
	CALL SUBOPT_0x1D
; 0000 0226                     for(;;)
_0x197:
; 0000 0227                         {
; 0000 0228                         delay_us(700);
	CALL SUBOPT_0x1E
; 0000 0229                         read_sensor();
; 0000 022A                         if(depan_kiri==0b10000000)break;
	LDS  R26,_depan_kiri
	CPI  R26,LOW(0x80)
	BRNE _0x197
; 0000 022B                         };
; 0000 022C                     backlight=0;
	CBI  0x18,3
; 0000 022D                     break;
	RJMP _0x194
; 0000 022E             case 1: rem();
_0x195:
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	BRNE _0x19C
	RCALL _rem
; 0000 022F                     speed_ka=-150;speed_ki=150;pwm_out();
	LDI  R30,LOW(65386)
	LDI  R31,HIGH(65386)
	CALL SUBOPT_0x4
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x6
	RCALL _pwm_out
; 0000 0230                     //speed_ka=-speed;speed_ki=speed/2;pwm_out();
; 0000 0231                     for(;;)
_0x19E:
; 0000 0232                         {
; 0000 0233                         delay_us(700);
	CALL SUBOPT_0x1E
; 0000 0234                         read_sensor();
; 0000 0235                         if(depan_kanan==0b0000000)break;
	LDS  R30,_depan_kanan
	CPI  R30,0
	BRNE _0x19E
; 0000 0236                         };
; 0000 0237                     backlight=0;
	CBI  0x18,3
; 0000 0238                     break;
	RJMP _0x194
; 0000 0239             case 2:lurus();break;
_0x19C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x194
	RCALL _lurus
; 0000 023A             }
_0x194:
; 0000 023B         per4an++;
	LDS  R30,_per4an
	SUBI R30,-LOW(1)
	STS  _per4an,R30
; 0000 023C         led=1;backlight=0;
	SBI  0x15,7
	CBI  0x18,3
; 0000 023D         }
	RET
;
;
;
;void line_following()
; 0000 0242 {
_line_following:
; 0000 0243 read_sensor();
	RCALL _read_sensor
; 0000 0244 lcd_clear();
	CALL _lcd_clear
; 0000 0245 led=1;
	SBI  0x15,7
; 0000 0246 backlight=0;
	CBI  0x18,3
; 0000 0247 if(time<=230)time++;
	LDS  R26,_time
	LDS  R27,_time+1
	CPI  R26,LOW(0xE7)
	LDI  R30,HIGH(0xE7)
	CPC  R27,R30
	BRSH _0x1AC
	LDI  R26,LOW(_time)
	LDI  R27,HIGH(_time)
	CALL SUBOPT_0x1F
; 0000 0248 
; 0000 0249 if(backlight_on>0){backlight_on--;backlight=1;}
_0x1AC:
	LDS  R26,_backlight_on
	CPI  R26,LOW(0x1)
	BRLO _0x1AD
	LDS  R30,_backlight_on
	SUBI R30,LOW(1)
	STS  _backlight_on,R30
	SBI  0x18,3
; 0000 024A else               backlight=0;
	RJMP _0x1B0
_0x1AD:
	CBI  0x18,3
; 0000 024B 
; 0000 024C if(led_on>0){led_on--;led=0;}
_0x1B0:
	LDS  R26,_led_on
	CPI  R26,LOW(0x1)
	BRLO _0x1B3
	LDS  R30,_led_on
	SUBI R30,LOW(1)
	STS  _led_on,R30
	CBI  0x15,7
; 0000 024D else         led=1;
	RJMP _0x1B6
_0x1B3:
	SBI  0x15,7
; 0000 024E 
; 0000 024F if(i_speed<speed)   i_speed=i_speed+10;
_0x1B6:
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x14
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x1B9
	LDS  R30,_i_speed
	LDS  R31,_i_speed+1
	ADIW R30,10
	RJMP _0x445
; 0000 0250 else                i_speed=speed;
_0x1B9:
	CALL SUBOPT_0x1A
_0x445:
	STS  _i_speed,R30
	STS  _i_speed+1,R31
; 0000 0251 
; 0000 0252 //if (tadi_depan_kanan>0) {tadi_depan_kanan--;}
; 0000 0253 //else if (tadi_depan_kanan==0) {tadi_depan_kanan=0;}
; 0000 0254 
; 0000 0255 //if (tadi_depan_kiri>0) {tadi_depan_kiri--;}
; 0000 0256 //else if (tadi_depan_kiri==0) {tadi_depan_kiri=0;}
; 0000 0257 
; 0000 0258 if (tadi_per4an>0) {tadi_per4an--;}
	LDS  R26,_tadi_per4an
	CPI  R26,LOW(0x1)
	BRLO _0x1BB
	LDS  R30,_tadi_per4an
	SUBI R30,LOW(1)
	RJMP _0x446
; 0000 0259 else if (tadi_per4an==0) {tadi_per4an=0;}
_0x1BB:
	LDS  R30,_tadi_per4an
	CPI  R30,0
	BRNE _0x1BD
	LDI  R30,LOW(0)
_0x446:
	STS  _tadi_per4an,R30
; 0000 025A 
; 0000 025B //if (tadi_white_line>0) {tadi_white_line--;}
; 0000 025C //else if (tadi_white_line==0) {tadi_white_line=0;}
; 0000 025D 
; 0000 025E if(right_back>0){right_back--;}
_0x1BD:
	LDS  R26,_right_back
	CPI  R26,LOW(0x1)
	BRLO _0x1BE
	LDS  R30,_right_back
	SUBI R30,LOW(1)
	RJMP _0x447
; 0000 025F else if (right_back==0){right_back=0;}
_0x1BE:
	LDS  R30,_right_back
	CPI  R30,0
	BRNE _0x1C0
	LDI  R30,LOW(0)
_0x447:
	STS  _right_back,R30
; 0000 0260 
; 0000 0261 if(left_back>0){left_back--;}
_0x1C0:
	LDS  R26,_left_back
	CPI  R26,LOW(0x1)
	BRLO _0x1C1
	LDS  R30,_left_back
	SUBI R30,LOW(1)
	RJMP _0x448
; 0000 0262 else if (left_back==0){left_back=0;}
_0x1C1:
	LDS  R30,_left_back
	CPI  R30,0
	BRNE _0x1C3
	LDI  R30,LOW(0)
_0x448:
	STS  _left_back,R30
; 0000 0263 
; 0000 0264 kp=i_speed/kp_div;
_0x1C3:
	MOV  R30,R7
	LDI  R31,0
	CALL SUBOPT_0x14
	CALL SUBOPT_0x18
; 0000 0265 kd=3*kp;
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	CALL SUBOPT_0x19
; 0000 0266 
; 0000 0267 giving_weight10();
	RCALL _giving_weight10
; 0000 0268 giving_weight20();
	RCALL _giving_weight20
; 0000 0269 giving_weight30();
	RCALL _giving_weight30
; 0000 026A scan_Y();
	RCALL _scan_Y
; 0000 026B //giving_weight11(); //yang putih di atas hitam
; 0000 026C //giving_weight21();
; 0000 026D 
; 0000 026E if (enter==0){if (fork_status>=1) fork_status=0; else fork_status++;delay_ms(300);} //set cabang Y
	SBIC 0x13,0
	RJMP _0x1C4
	LDS  R26,_fork_status
	CPI  R26,LOW(0x1)
	BRLO _0x1C5
	LDI  R30,LOW(0)
	RJMP _0x449
_0x1C5:
	LDS  R30,_fork_status
	SUBI R30,-LOW(1)
_0x449:
	STS  _fork_status,R30
	CALL SUBOPT_0x20
; 0000 026F scan_Y(); //cabang Y
_0x1C4:
	RCALL _scan_Y
; 0000 0270 
; 0000 0271 depan_kanan= 0b00000001&&front_sensor;
	LDI  R30,LOW(1)
	CPI  R30,0
	BREQ _0x1C7
	LDS  R30,_front_sensor
	CPI  R30,0
	BREQ _0x1C7
	LDI  R30,1
	RJMP _0x1C8
_0x1C7:
	LDI  R30,0
_0x1C8:
	STS  _depan_kanan,R30
; 0000 0272 depan_kiri= 0b10000000&&front_sensor;
	LDI  R30,LOW(128)
	CPI  R30,0
	BREQ _0x1C9
	LDS  R30,_front_sensor
	CPI  R30,0
	BREQ _0x1C9
	LDI  R30,1
	RJMP _0x1CA
_0x1C9:
	LDI  R30,0
_0x1CA:
	STS  _depan_kiri,R30
; 0000 0273 if  (depan_kanan!=0){tadi_depan_kanan=15;}
	LDS  R30,_depan_kanan
	CPI  R30,0
	BREQ _0x1CB
	LDI  R30,LOW(15)
	STS  _tadi_depan_kanan,R30
; 0000 0274 if  (depan_kiri!=0){tadi_depan_kiri=15;}
_0x1CB:
	LDS  R30,_depan_kiri
	CPI  R30,0
	BREQ _0x1CC
	LDI  R30,LOW(15)
	STS  _tadi_depan_kiri,R30
; 0000 0275 
; 0000 0276 
; 0000 0277 
; 0000 0278 /*------- untuk deteksi sudut 45, siku, sama perempatan ------------*/
; 0000 0279 /*
; 0000 027A     if(front_sensor==0)
; 0000 027B         {
; 0000 027C         if  (tadi_depan_kanan==0&&tadi_depan_kiri>0)
; 0000 027D                 {
; 0000 027E                 rem();
; 0000 027F                 backlight=1;
; 0000 0280                 speed_ki=-speed;speed_ka=speed/2;pwm_out();
; 0000 0281                 for(;;)
; 0000 0282                     {
; 0000 0283                     delay_us(700);
; 0000 0284                     read_sensor();
; 0000 0285                     if(front_sensor!=0)break;
; 0000 0286                     };
; 0000 0287                 backlight=0;
; 0000 0288                 }
; 0000 0289 
; 0000 028A         else if (tadi_depan_kanan>0&&tadi_depan_kiri==0)
; 0000 028B                 {
; 0000 028C                 rem();
; 0000 028D                 backlight=1;
; 0000 028E                 speed_ki=speed/2;speed_ka=-speed;pwm_out();
; 0000 028F                 for(;;)
; 0000 0290                     {
; 0000 0291                     delay_us(700);
; 0000 0292                     read_sensor();
; 0000 0293                     if(front_sensor!=0)break;
; 0000 0294                     };
; 0000 0295                 backlight=0;
; 0000 0296                 }
; 0000 0297         else if (tadi_depan_kanan>0&&tadi_depan_kiri>0)
; 0000 0298                 {
; 0000 0299                 //rem();
; 0000 029A                 //cross_handler();
; 0000 029B                 tadi_per4an=15;
; 0000 029C                 }
; 0000 029D         }
; 0000 029E */
; 0000 029F 
; 0000 02A0 /*----------percabangan 3 dan 4-----------*/
; 0000 02A1           if  (rear_sensor==0b00010000||rear_sensor==0b00110000||rear_sensor==0b00100000)
_0x1CC:
	LDS  R26,_rear_sensor
	CPI  R26,LOW(0x10)
	BREQ _0x1CE
	CPI  R26,LOW(0x30)
	BREQ _0x1CE
	CPI  R26,LOW(0x20)
	BRNE _0x1CD
_0x1CE:
; 0000 02A2             {
; 0000 02A3                cross_handler();
	RJMP _0x44A
; 0000 02A4             }
; 0000 02A5         else if (rear_sensor==0b00001000||rear_sensor==0b00001100||rear_sensor==0b00000100)
_0x1CD:
	LDS  R26,_rear_sensor
	CPI  R26,LOW(0x8)
	BREQ _0x1D2
	CPI  R26,LOW(0xC)
	BREQ _0x1D2
	CPI  R26,LOW(0x4)
	BRNE _0x1D1
_0x1D2:
; 0000 02A6             {
; 0000 02A7                 cross_handler();
	RJMP _0x44A
; 0000 02A8             }
; 0000 02A9         else if(rear_sensor==0b00011000||rear_sensor==0b00100100||rear_sensor==0b00111100||rear_sensor==0b00101100||rear_sensor==0b00110100)
_0x1D1:
	LDS  R26,_rear_sensor
	CPI  R26,LOW(0x18)
	BREQ _0x1D6
	CPI  R26,LOW(0x24)
	BREQ _0x1D6
	CPI  R26,LOW(0x3C)
	BREQ _0x1D6
	CPI  R26,LOW(0x2C)
	BREQ _0x1D6
	CPI  R26,LOW(0x34)
	BRNE _0x1D5
_0x1D6:
; 0000 02AA                 {cross_handler();}
_0x44A:
	RCALL _cross_handler
; 0000 02AB 
; 0000 02AC 
; 0000 02AD 
; 0000 02AE  /*-----------deteksi siku dan sudut 45 pake sensor belakang ----------*/
; 0000 02AF  if(front_sensor==0||front_sensor==0b01100000||front_sensor==0b00000110)
_0x1D5:
	LDS  R26,_front_sensor
	CPI  R26,LOW(0x0)
	BREQ _0x1D9
	CPI  R26,LOW(0x60)
	BREQ _0x1D9
	CPI  R26,LOW(0x6)
	BREQ _0x1D9
	RJMP _0x1D8
_0x1D9:
; 0000 02B0         {
; 0000 02B1         if      (rear_sensor==0b00001000||rear_sensor==0b00000100||rear_sensor==0b00001100/*||rear_sensor==0b00000010*/)
	LDS  R26,_rear_sensor
	CPI  R26,LOW(0x8)
	BREQ _0x1DC
	CPI  R26,LOW(0x4)
	BREQ _0x1DC
	CPI  R26,LOW(0xC)
	BRNE _0x1DB
_0x1DC:
; 0000 02B2                 {
; 0000 02B3                 if (error>-4)
	LDS  R26,_error
	LDS  R27,_error+1
	LDI  R30,LOW(65532)
	LDI  R31,HIGH(65532)
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x1DE
; 0000 02B4                         {
; 0000 02B5                         rem();
	RCALL _rem
; 0000 02B6                         backlight=1;
	SBI  0x18,3
; 0000 02B7                         speed_ki=-150;speed_ka=150;pwm_out();
	CALL SUBOPT_0x1D
; 0000 02B8                         for(;;)
_0x1E2:
; 0000 02B9                                 {
; 0000 02BA                                 delay_us(700);
	CALL SUBOPT_0x1E
; 0000 02BB                                 read_sensor();lcd_clear();lcd_putsf("woi");
	CALL _lcd_clear
	__POINTW1FN _0x0,3
	CALL SUBOPT_0x21
; 0000 02BC                                 if(front_sensor!=0)break;
	BREQ _0x1E2
; 0000 02BD                                 };
; 0000 02BE                         backlight=0;
	CBI  0x18,3
; 0000 02BF                         }
; 0000 02C0                 }
_0x1DE:
; 0000 02C1         else if (rear_sensor==0b00010000||rear_sensor==0b00100000||rear_sensor==0b00110000/*||rear_sensor==0b01000000*/)
	RJMP _0x1E7
_0x1DB:
	LDS  R26,_rear_sensor
	CPI  R26,LOW(0x10)
	BREQ _0x1E9
	CPI  R26,LOW(0x20)
	BREQ _0x1E9
	CPI  R26,LOW(0x30)
	BRNE _0x1E8
_0x1E9:
; 0000 02C2                 {
; 0000 02C3                 if (error<4)   //depan belakang sama2 kiri
	LDS  R26,_error
	LDS  R27,_error+1
	SBIW R26,4
	BRGE _0x1EB
; 0000 02C4                         {
; 0000 02C5                         rem();
	RCALL _rem
; 0000 02C6                         backlight=1;
	SBI  0x18,3
; 0000 02C7                         speed_ki=150;speed_ka=-150;pwm_out();
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x6
	LDI  R30,LOW(65386)
	LDI  R31,HIGH(65386)
	CALL SUBOPT_0x1B
; 0000 02C8                         for(;;)
_0x1EF:
; 0000 02C9                                 {
; 0000 02CA                                 delay_us(700);
	CALL SUBOPT_0x1E
; 0000 02CB                                 read_sensor();lcd_clear();lcd_putsf("heh");
	CALL _lcd_clear
	__POINTW1FN _0x0,7
	CALL SUBOPT_0x21
; 0000 02CC                                 if(front_sensor!=0)break;
	BREQ _0x1EF
; 0000 02CD                                 };
; 0000 02CE                         backlight=0;
	CBI  0x18,3
; 0000 02CF                         }
; 0000 02D0                 }
_0x1EB:
; 0000 02D1         }
_0x1E8:
_0x1E7:
; 0000 02D2 
; 0000 02D3 
; 0000 02D4 /*------- untuk deteksi white_line ------------*/
; 0000 02D5 rear_sensor10=(rear_sensor)&(0b00010000);
_0x1D8:
	LDS  R30,_rear_sensor
	ANDI R30,LOW(0x10)
	STS  _rear_sensor10,R30
; 0000 02D6 rear_sensor30=(rear_sensor)&(0b01000000);
	LDS  R30,_rear_sensor
	ANDI R30,LOW(0x40)
	STS  _rear_sensor30,R30
; 0000 02D7 
; 0000 02D8 rear_sensor11=(rear_sensor)&(0b00001000);
	LDS  R30,_rear_sensor
	ANDI R30,LOW(0x8)
	STS  _rear_sensor11,R30
; 0000 02D9 rear_sensor31=(rear_sensor)&(0b00000010);
	LDS  R30,_rear_sensor
	ANDI R30,LOW(0x2)
	STS  _rear_sensor31,R30
; 0000 02DA 
; 0000 02DB if (rear_sensor10!=0&&rear_sensor30!=0){white_line=1;tadi_white_line=15;}
	LDS  R26,_rear_sensor10
	CPI  R26,LOW(0x0)
	BREQ _0x1F5
	LDS  R26,_rear_sensor30
	CPI  R26,LOW(0x0)
	BRNE _0x1F6
_0x1F5:
	RJMP _0x1F4
_0x1F6:
	SET
	BLD  R2,6
	LDI  R30,LOW(15)
	STS  _tadi_white_line,R30
; 0000 02DC if (rear_sensor11!=0&&rear_sensor31!=0){white_line=1;tadi_white_line=15;}
_0x1F4:
	LDS  R26,_rear_sensor11
	CPI  R26,LOW(0x0)
	BREQ _0x1F8
	LDS  R26,_rear_sensor31
	CPI  R26,LOW(0x0)
	BRNE _0x1F9
_0x1F8:
	RJMP _0x1F7
_0x1F9:
	SET
	BLD  R2,6
	LDI  R30,LOW(15)
	STS  _tadi_white_line,R30
; 0000 02DD 
; 0000 02DE if (white_line==1)
_0x1F7:
	SBRS R2,6
	RJMP _0x1FA
; 0000 02DF     {
; 0000 02E0        if (front_sensor==0b11111111){error=16;}
	LDS  R26,_front_sensor
	CPI  R26,LOW(0xFF)
	BRNE _0x1FB
	LDI  R30,LOW(16)
	LDI  R31,HIGH(16)
	RJMP _0x44B
; 0000 02E1        else {error=error;}
_0x1FB:
	CALL SUBOPT_0xA
_0x44B:
	STS  _error,R30
	STS  _error+1,R31
; 0000 02E2     }
; 0000 02E3 komp_pid();
_0x1FA:
	RCALL _komp_pid
; 0000 02E4 pwm_out();
	RCALL _pwm_out
; 0000 02E5 }
	RET
;
;void action()
; 0000 02E8 {
_action:
; 0000 02E9 j=0;
	LDI  R30,LOW(0)
	STS  _j,R30
; 0000 02EA 
; 0000 02EB for(;;)
_0x1FE:
; 0000 02EC     {
; 0000 02ED     line_following();
	RCALL _line_following
; 0000 02EE     if(back==0) {lcd_clear();break;}
	SBIC 0x10,7
	RJMP _0x200
	CALL _lcd_clear
	RJMP _0x1FF
; 0000 02EF     }
_0x200:
	RJMP _0x1FE
_0x1FF:
; 0000 02F0 pwm_off();
	RCALL _pwm_off
; 0000 02F1 backlight=0;
	CBI  0x18,3
; 0000 02F2 
; 0000 02F3 led=1;
	SBI  0x15,7
; 0000 02F4 backlight=0;
	CBI  0x18,3
; 0000 02F5 delay_ms(250);
	RJMP _0x20C0004
; 0000 02F6 }
;
;void tampil_auto_set1()
; 0000 02F9 {
_tampil_auto_set1:
; 0000 02FA lcd_gotoxy(0,0);
	CALL SUBOPT_0x22
; 0000 02FB sprintf(lcd,"%d %d %d %d ",adc_tres1[0],adc_tres1[1],adc_tres1[2],adc_tres1[3]);
	LDS  R30,_adc_tres1
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres1,1
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres1,2
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres1,3
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
; 0000 02FC lcd_puts(lcd);
; 0000 02FD 
; 0000 02FE lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF
; 0000 02FF sprintf(lcd,"%d %d %d %d",adc_tres1[4],adc_tres1[5],adc_tres1[6],adc_tres1[7]);
	__POINTW1FN _0x0,24
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _adc_tres1,4
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres1,5
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres1,6
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres1,7
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
; 0000 0300 lcd_puts(lcd);
; 0000 0301 
; 0000 0302 
; 0000 0303 for(;;)
_0x208:
; 0000 0304     {
; 0000 0305     lcd_clear();
	CALL _lcd_clear
; 0000 0306     for(i=0;i<8;i++)
	CLR  R12
_0x20B:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRLO PC+3
	JMP _0x20C
; 0000 0307         {
; 0000 0308         if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
	TST  R12
	BRNE _0x20D
	CBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 0309         else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
	RJMP _0x214
_0x20D:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x215
	CBI  0x15,6
	CBI  0x15,5
	RJMP _0x44C
; 0000 030A         else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
_0x215:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x21D
	CBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 030B         else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
	RJMP _0x224
_0x21D:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0x225
	CBI  0x15,6
	RJMP _0x44D
; 0000 030C         else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
_0x225:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x22D
	SBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 030D         else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
	RJMP _0x234
_0x22D:
	LDI  R30,LOW(5)
	CP   R30,R12
	BRNE _0x235
	SBI  0x15,6
	CBI  0x15,5
	RJMP _0x44C
; 0000 030E         else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
_0x235:
	LDI  R30,LOW(6)
	CP   R30,R12
	BRNE _0x23D
	SBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 030F         else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
	RJMP _0x244
_0x23D:
	LDI  R30,LOW(7)
	CP   R30,R12
	BRNE _0x245
	SBI  0x15,6
_0x44D:
	SBI  0x15,5
_0x44C:
	SBI  0x15,4
; 0000 0310         adc_result1[i]=read_adc(7);//depan
_0x245:
_0x244:
_0x234:
_0x224:
_0x214:
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0311         //adc_result2[i]=read_adc(6);//belakang
; 0000 0312         }
	INC  R12
	RJMP _0x20B
_0x20C:
; 0000 0313 
; 0000 0314     for(i=0;i<8;i++)
	CLR  R12
_0x24D:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRLO PC+3
	JMP _0x24E
; 0000 0315         {
; 0000 0316         if(adc_result1[i]>max_adc1[i])max_adc1[i]=adc_result1[i];
	CALL SUBOPT_0x0
	CALL SUBOPT_0x25
	CP   R30,R26
	BRSH _0x24F
	CALL SUBOPT_0x26
	SUBI R26,LOW(-_max_adc1)
	SBCI R27,HIGH(-_max_adc1)
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	LD   R30,Z
	ST   X,R30
; 0000 0317         if(adc_result1[i]<max_adc1[i])min_adc1[i]=adc_result1[i];
_0x24F:
	CALL SUBOPT_0x0
	CALL SUBOPT_0x25
	CP   R26,R30
	BRSH _0x250
	CALL SUBOPT_0x26
	SUBI R26,LOW(-_min_adc1)
	SBCI R27,HIGH(-_min_adc1)
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	LD   R30,Z
	ST   X,R30
; 0000 0318         //adc_tres1[i]=min_adc1[i]+((max_adc1[i]-min_adc1[i])/10);
; 0000 0319         adc_tres1[i]=min_adc1[i]+40;
_0x250:
	CALL SUBOPT_0x26
	SUBI R26,LOW(-_adc_tres1)
	SBCI R27,HIGH(-_adc_tres1)
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_min_adc1)
	SBCI R31,HIGH(-_min_adc1)
	CALL SUBOPT_0x27
; 0000 031A         //adc_tres1[i]=0.6*max_adc1[i];
; 0000 031B 
; 0000 031C         delay_us(50);
; 0000 031D         lcd_gotoxy(0,0);
; 0000 031E         sprintf(lcd,"%d",adc_result1[0]);
	LDS  R30,_adc_result1
	CALL SUBOPT_0xD
; 0000 031F         lcd_puts(lcd);
; 0000 0320 
; 0000 0321         lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x9
; 0000 0322         sprintf(lcd,"%d",adc_result1[1]);
	__GETB1MN _adc_result1,1
	CALL SUBOPT_0xD
; 0000 0323         lcd_puts(lcd);
; 0000 0324 
; 0000 0325         lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x9
; 0000 0326         sprintf(lcd,"%d",adc_result1[2]);
	__GETB1MN _adc_result1,2
	CALL SUBOPT_0xD
; 0000 0327         lcd_puts(lcd);
; 0000 0328 
; 0000 0329         lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x9
; 0000 032A         sprintf(lcd,"%d",adc_result1[3]);
	__GETB1MN _adc_result1,3
	CALL SUBOPT_0xD
; 0000 032B         lcd_puts(lcd);
; 0000 032C 
; 0000 032D         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF
; 0000 032E         sprintf(lcd,"%d",adc_result1[4]);
	CALL SUBOPT_0x10
	__GETB1MN _adc_result1,4
	CALL SUBOPT_0xD
; 0000 032F         lcd_puts(lcd);
; 0000 0330 
; 0000 0331         lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0xF
; 0000 0332         sprintf(lcd,"%d",adc_result1[5]);
	CALL SUBOPT_0x10
	__GETB1MN _adc_result1,5
	CALL SUBOPT_0xD
; 0000 0333         lcd_puts(lcd);
; 0000 0334 
; 0000 0335         lcd_gotoxy(8,1);
	CALL SUBOPT_0xE
; 0000 0336         sprintf(lcd,"%d",adc_result1[6]);
	__GETB1MN _adc_result1,6
	CALL SUBOPT_0xD
; 0000 0337         lcd_puts(lcd);
; 0000 0338 
; 0000 0339         lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xF
; 0000 033A         sprintf(lcd,"%d",adc_result1[7]);
	CALL SUBOPT_0x10
	__GETB1MN _adc_result1,7
	CALL SUBOPT_0xD
; 0000 033B         lcd_puts(lcd);
; 0000 033C         }
	INC  R12
	RJMP _0x24D
_0x24E:
; 0000 033D 
; 0000 033E 
; 0000 033F     delay_us(600);
	__DELAY_USW 1200
; 0000 0340     if(enter==0)
	SBIC 0x13,0
	RJMP _0x251
; 0000 0341         {
; 0000 0342         for(i=0;i<8;i++)
	CLR  R12
_0x253:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x254
; 0000 0343             {
; 0000 0344             e_adc_tres1[i]=adc_tres1[i];
	CALL SUBOPT_0x26
	SUBI R26,LOW(-_e_adc_tres1)
	SBCI R27,HIGH(-_e_adc_tres1)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x28
; 0000 0345             e_adc_tres2[i]=adc_tres2[i];
	SUBI R26,LOW(-_e_adc_tres2)
	SBCI R27,HIGH(-_e_adc_tres2)
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_tres2)
	SBCI R31,HIGH(-_adc_tres2)
	LD   R30,Z
	CALL __EEPROMWRB
; 0000 0346             }
	INC  R12
	RJMP _0x253
_0x254:
; 0000 0347         break;
	RJMP _0x209
; 0000 0348         }
; 0000 0349     if(back==0)break;
_0x251:
	SBIS 0x10,7
	RJMP _0x209
; 0000 034A     }
	RJMP _0x208
_0x209:
; 0000 034B selesai:
; 0000 034C for(i=0;i<8;i++){adc_tres1[i]=e_adc_tres1[i];adc_tres2[i]=e_adc_tres2[i];}
	CLR  R12
_0x258:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x259
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	INC  R12
	RJMP _0x258
_0x259:
; 0000 034D delay_ms(250);
	RJMP _0x20C0004
; 0000 034E }
;
;void tampil_auto_set2()
; 0000 0351 {
_tampil_auto_set2:
; 0000 0352 lcd_gotoxy(0,0);
	CALL SUBOPT_0x22
; 0000 0353 sprintf(lcd,"%d %d %d %d ",adc_tres2[0],adc_tres2[1],adc_tres2[2],adc_tres2[3]);
	LDS  R30,_adc_tres2
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres2,1
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres2,2
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres2,3
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
; 0000 0354 lcd_puts(lcd);
; 0000 0355 
; 0000 0356 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF
; 0000 0357 sprintf(lcd,"%d %d %d %d",adc_tres2[4],adc_tres2[5],adc_tres2[6],adc_tres2[7]);
	__POINTW1FN _0x0,24
	ST   -Y,R31
	ST   -Y,R30
	__GETB1MN _adc_tres2,4
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres2,5
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres2,6
	CALL SUBOPT_0x23
	__GETB1MN _adc_tres2,7
	CALL SUBOPT_0x23
	CALL SUBOPT_0x24
; 0000 0358 lcd_puts(lcd);
; 0000 0359 
; 0000 035A 
; 0000 035B for(;;)
_0x25B:
; 0000 035C     {
; 0000 035D     lcd_clear();
	CALL _lcd_clear
; 0000 035E     for(i=0;i<8;i++)
	CLR  R12
_0x25E:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRLO PC+3
	JMP _0x25F
; 0000 035F         {
; 0000 0360         if     (i==0){PORTC.6=0;PORTC.5=0;PORTC.4=0;}
	TST  R12
	BRNE _0x260
	CBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 0361         else if(i==1){PORTC.6=0;PORTC.5=0;PORTC.4=1;}
	RJMP _0x267
_0x260:
	LDI  R30,LOW(1)
	CP   R30,R12
	BRNE _0x268
	CBI  0x15,6
	CBI  0x15,5
	RJMP _0x44E
; 0000 0362         else if(i==2){PORTC.6=0;PORTC.5=1;PORTC.4=0;}
_0x268:
	LDI  R30,LOW(2)
	CP   R30,R12
	BRNE _0x270
	CBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 0363         else if(i==3){PORTC.6=0;PORTC.5=1;PORTC.4=1;}
	RJMP _0x277
_0x270:
	LDI  R30,LOW(3)
	CP   R30,R12
	BRNE _0x278
	CBI  0x15,6
	RJMP _0x44F
; 0000 0364         else if(i==4){PORTC.6=1;PORTC.5=0;PORTC.4=0;}
_0x278:
	LDI  R30,LOW(4)
	CP   R30,R12
	BRNE _0x280
	SBI  0x15,6
	CBI  0x15,5
	CBI  0x15,4
; 0000 0365         else if(i==5){PORTC.6=1;PORTC.5=0;PORTC.4=1;}
	RJMP _0x287
_0x280:
	LDI  R30,LOW(5)
	CP   R30,R12
	BRNE _0x288
	SBI  0x15,6
	CBI  0x15,5
	RJMP _0x44E
; 0000 0366         else if(i==6){PORTC.6=1;PORTC.5=1;PORTC.4=0;}
_0x288:
	LDI  R30,LOW(6)
	CP   R30,R12
	BRNE _0x290
	SBI  0x15,6
	SBI  0x15,5
	CBI  0x15,4
; 0000 0367         else if(i==7){PORTC.6=1;PORTC.5=1;PORTC.4=1;}
	RJMP _0x297
_0x290:
	LDI  R30,LOW(7)
	CP   R30,R12
	BRNE _0x298
	SBI  0x15,6
_0x44F:
	SBI  0x15,5
_0x44E:
	SBI  0x15,4
; 0000 0368         //adc_result1[i]=read_adc(7);//depan
; 0000 0369         adc_result2[i]=read_adc(6);//belakang
_0x298:
_0x297:
_0x287:
_0x277:
_0x267:
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_result2)
	SBCI R31,HIGH(-_adc_result2)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 036A         }
	INC  R12
	RJMP _0x25E
_0x25F:
; 0000 036B 
; 0000 036C     for(i=0;i<8;i++)
	CLR  R12
_0x2A0:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRLO PC+3
	JMP _0x2A1
; 0000 036D         {
; 0000 036E         if(adc_result2[i]>max_adc2[i])max_adc1[i]=adc_result2[i];
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2D
	CP   R30,R26
	BRSH _0x2A2
	CALL SUBOPT_0x26
	SUBI R26,LOW(-_max_adc1)
	SBCI R27,HIGH(-_max_adc1)
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_result2)
	SBCI R31,HIGH(-_adc_result2)
	LD   R30,Z
	ST   X,R30
; 0000 036F         if(adc_result2[i]<max_adc2[i])min_adc1[i]=adc_result2[i];
_0x2A2:
	CALL SUBOPT_0x0
	CALL SUBOPT_0x2D
	CP   R26,R30
	BRSH _0x2A3
	CALL SUBOPT_0x26
	SUBI R26,LOW(-_min_adc1)
	SBCI R27,HIGH(-_min_adc1)
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_result2)
	SBCI R31,HIGH(-_adc_result2)
	LD   R30,Z
	ST   X,R30
; 0000 0370         //adc_tres1[i]=min_adc1[i]+((max_adc1[i]-min_adc1[i])/10);
; 0000 0371         adc_tres2[i]=min_adc2[i]+40;
_0x2A3:
	CALL SUBOPT_0x26
	SUBI R26,LOW(-_adc_tres2)
	SBCI R27,HIGH(-_adc_tres2)
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_min_adc2)
	SBCI R31,HIGH(-_min_adc2)
	CALL SUBOPT_0x27
; 0000 0372         //adc_tres1[i]=0.6*max_adc1[i];
; 0000 0373 
; 0000 0374         delay_us(50);
; 0000 0375         lcd_gotoxy(0,0);
; 0000 0376         sprintf(lcd,"%d",adc_result2[0]);
	LDS  R30,_adc_result2
	CALL SUBOPT_0xD
; 0000 0377         lcd_puts(lcd);
; 0000 0378 
; 0000 0379         lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x9
; 0000 037A         sprintf(lcd,"%d",adc_result2[1]);
	__GETB1MN _adc_result2,1
	CALL SUBOPT_0xD
; 0000 037B         lcd_puts(lcd);
; 0000 037C 
; 0000 037D         lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x9
; 0000 037E         sprintf(lcd,"%d",adc_result2[2]);
	__GETB1MN _adc_result2,2
	CALL SUBOPT_0xD
; 0000 037F         lcd_puts(lcd);
; 0000 0380 
; 0000 0381         lcd_gotoxy(12,0);
	LDI  R30,LOW(12)
	CALL SUBOPT_0x9
; 0000 0382         sprintf(lcd,"%d",adc_result2[3]);
	__GETB1MN _adc_result2,3
	CALL SUBOPT_0xD
; 0000 0383         lcd_puts(lcd);
; 0000 0384 
; 0000 0385         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF
; 0000 0386         sprintf(lcd,"%d",adc_result2[4]);
	CALL SUBOPT_0x10
	__GETB1MN _adc_result2,4
	CALL SUBOPT_0xD
; 0000 0387         lcd_puts(lcd);
; 0000 0388 
; 0000 0389         lcd_gotoxy(4,1);
	LDI  R30,LOW(4)
	CALL SUBOPT_0xF
; 0000 038A         sprintf(lcd,"%d",adc_result2[5]);
	CALL SUBOPT_0x10
	__GETB1MN _adc_result2,5
	CALL SUBOPT_0xD
; 0000 038B         lcd_puts(lcd);
; 0000 038C 
; 0000 038D         lcd_gotoxy(8,1);
	CALL SUBOPT_0xE
; 0000 038E         sprintf(lcd,"%d",adc_result2[6]);
	__GETB1MN _adc_result2,6
	CALL SUBOPT_0xD
; 0000 038F         lcd_puts(lcd);
; 0000 0390 
; 0000 0391         lcd_gotoxy(12,1);
	LDI  R30,LOW(12)
	CALL SUBOPT_0xF
; 0000 0392         sprintf(lcd,"%d",adc_result2[7]);
	CALL SUBOPT_0x10
	__GETB1MN _adc_result2,7
	CALL SUBOPT_0xD
; 0000 0393         lcd_puts(lcd);
; 0000 0394         }
	INC  R12
	RJMP _0x2A0
_0x2A1:
; 0000 0395 
; 0000 0396 
; 0000 0397     delay_us(600);
	__DELAY_USW 1200
; 0000 0398     if(enter==0)
	SBIC 0x13,0
	RJMP _0x2A4
; 0000 0399         {
; 0000 039A         for(i=0;i<8;i++)
	CLR  R12
_0x2A6:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x2A7
; 0000 039B             {
; 0000 039C             e_adc_tres1[i]=adc_tres1[i];
	CALL SUBOPT_0x26
	SUBI R26,LOW(-_e_adc_tres1)
	SBCI R27,HIGH(-_e_adc_tres1)
	CALL SUBOPT_0x0
	CALL SUBOPT_0x28
; 0000 039D             e_adc_tres2[i]=adc_tres2[i];
	SUBI R26,LOW(-_e_adc_tres2)
	SBCI R27,HIGH(-_e_adc_tres2)
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_tres2)
	SBCI R31,HIGH(-_adc_tres2)
	LD   R30,Z
	CALL __EEPROMWRB
; 0000 039E             }
	INC  R12
	RJMP _0x2A6
_0x2A7:
; 0000 039F         break;
	RJMP _0x25C
; 0000 03A0         }
; 0000 03A1     if(back==0)break;
_0x2A4:
	SBIS 0x10,7
	RJMP _0x25C
; 0000 03A2     }
	RJMP _0x25B
_0x25C:
; 0000 03A3 selesai:
; 0000 03A4 for(i=0;i<8;i++){adc_tres1[i]=e_adc_tres1[i];adc_tres2[i]=e_adc_tres2[i];}
	CLR  R12
_0x2AB:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x2AC
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
	INC  R12
	RJMP _0x2AB
_0x2AC:
; 0000 03A5 delay_ms(250);
_0x20C0004:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
_0x20C0005:
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 03A6 }
	RET
;
;void tampil_speed()
; 0000 03A9 {
_tampil_speed:
; 0000 03AA lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF
; 0000 03AB sprintf(lcd,"=%d",speed);
	__POINTW1FN _0x0,36
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0xB
; 0000 03AC lcd_puts(lcd);
; 0000 03AD for(;;)
_0x2AE:
; 0000 03AE     {
; 0000 03AF     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 03B0     adc_menu=255-adc_menu;
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
; 0000 03B1 
; 0000 03B2     lcd_gotoxy(8,1);
; 0000 03B3     lcd_putsf("   ");
; 0000 03B4     lcd_gotoxy(5,1);
; 0000 03B5     sprintf(lcd," <- %d",adc_menu);
	__POINTW1FN _0x0,44
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R11
	CALL SUBOPT_0xD
; 0000 03B6     lcd_puts(lcd);
; 0000 03B7 
; 0000 03B8     if(enter==0){e_speed=adc_menu;speed=adc_menu;temp_speed=speed;delay_ms(400);break;}
	SBIC 0x13,0
	RJMP _0x2B0
	MOV  R30,R11
	LDI  R26,LOW(_e_speed)
	LDI  R27,HIGH(_e_speed)
	LDI  R31,0
	CALL __EEPROMWRW
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x31
	CALL SUBOPT_0x1A
	STS  _temp_speed,R30
	STS  _temp_speed+1,R31
	CALL SUBOPT_0x32
	RJMP _0x2AF
; 0000 03B9     if(back==0){delay_ms(400);break;}
_0x2B0:
	SBIC 0x10,7
	RJMP _0x2B1
	CALL SUBOPT_0x32
	RJMP _0x2AF
; 0000 03BA     delay_ms(50);
_0x2B1:
	CALL SUBOPT_0x13
; 0000 03BB     }
	RJMP _0x2AE
_0x2AF:
; 0000 03BC }
	RET
;
;
;// void detect_per4an()
;// {
;//
;// for(;;)
;//     {
;//     adc_menu=read_adc(0);
;//     adc_menu=255-adc_menu;
;//
;//     if  (adc_menu<=50)per3an_enable=0;
;//     else per3an_enable=1;
;//
;//     lcd_gotoxy(0,1);
;//     if     (e_per4an_enable==0)lcd_putsf("disable");
;//     else if(e_per4an_enable==1)lcd_putsf("enable");
;//
;//     lcd_gotoxy(7,1);
;//     lcd_putsf("<-");
;//     if     (per4an_enable==0)lcd_putsf("disable");
;//     else if(per4an_enable==1)lcd_putsf("enable");
;//
;//
;//     if(enter==0){e_per3an_enable=per3an_enable;per3an_enable=per3an_enable;delay_ms(400);break;}
;//     if(back==0){delay_ms(400);break;}
;//     delay_ms(50);
;//     }
;// }
;
;void eksekusi_per4an()
; 0000 03DB {
_eksekusi_per4an:
; 0000 03DC 
; 0000 03DD awal:
_0x2B2:
; 0000 03DE lcd_clear();
	CALL _lcd_clear
; 0000 03DF adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 03E0 lcd_gotoxy(0,0);
	CALL SUBOPT_0x33
; 0000 03E1 if(adc_menu<25)
	LDI  R30,LOW(25)
	CP   R11,R30
	BRSH _0x2B3
; 0000 03E2     {
; 0000 03E3     lcd_putsf("1. Arah Per4an 1");
	__POINTW1FN _0x0,51
	CALL SUBOPT_0x34
; 0000 03E4     set_per4an=1;
	LDI  R30,LOW(1)
	RJMP _0x450
; 0000 03E5     }
; 0000 03E6 else if(adc_menu<50)
_0x2B3:
	LDI  R30,LOW(50)
	CP   R11,R30
	BRSH _0x2B5
; 0000 03E7     {
; 0000 03E8     lcd_putsf("2. Arah Per4an 2");
	__POINTW1FN _0x0,68
	CALL SUBOPT_0x34
; 0000 03E9     set_per4an=2;
	LDI  R30,LOW(2)
	RJMP _0x450
; 0000 03EA     }
; 0000 03EB else if(adc_menu<75)
_0x2B5:
	LDI  R30,LOW(75)
	CP   R11,R30
	BRSH _0x2B7
; 0000 03EC     {
; 0000 03ED     lcd_putsf("3. Arah Per4an 3");
	__POINTW1FN _0x0,85
	CALL SUBOPT_0x34
; 0000 03EE     set_per4an=3;
	LDI  R30,LOW(3)
	RJMP _0x450
; 0000 03EF     }
; 0000 03F0 else if(adc_menu<100)
_0x2B7:
	LDI  R30,LOW(100)
	CP   R11,R30
	BRSH _0x2B9
; 0000 03F1     {
; 0000 03F2     lcd_putsf("4. Arah Per4an 4");
	__POINTW1FN _0x0,102
	CALL SUBOPT_0x34
; 0000 03F3     set_per4an=4;
	LDI  R30,LOW(4)
	RJMP _0x450
; 0000 03F4     }
; 0000 03F5 else if(adc_menu<125)
_0x2B9:
	LDI  R30,LOW(125)
	CP   R11,R30
	BRSH _0x2BB
; 0000 03F6     {
; 0000 03F7     lcd_putsf("5. Arah Per4an 5");
	__POINTW1FN _0x0,119
	CALL SUBOPT_0x34
; 0000 03F8     set_per4an=5;
	LDI  R30,LOW(5)
	RJMP _0x450
; 0000 03F9     }
; 0000 03FA else if(adc_menu<150)
_0x2BB:
	LDI  R30,LOW(150)
	CP   R11,R30
	BRSH _0x2BD
; 0000 03FB     {
; 0000 03FC     lcd_putsf("6. Arah Per4an 6");
	__POINTW1FN _0x0,136
	CALL SUBOPT_0x34
; 0000 03FD     set_per4an=6;
	LDI  R30,LOW(6)
	RJMP _0x450
; 0000 03FE     }
; 0000 03FF else if(adc_menu<175)
_0x2BD:
	LDI  R30,LOW(175)
	CP   R11,R30
	BRSH _0x2BF
; 0000 0400     {
; 0000 0401     lcd_putsf("7. Arah Per4an 7");
	__POINTW1FN _0x0,153
	CALL SUBOPT_0x34
; 0000 0402     set_per4an=7;
	LDI  R30,LOW(7)
	RJMP _0x450
; 0000 0403     }
; 0000 0404 else if(adc_menu<200)
_0x2BF:
	LDI  R30,LOW(200)
	CP   R11,R30
	BRSH _0x2C1
; 0000 0405     {
; 0000 0406     lcd_putsf("8. Arah Per4an 8");
	__POINTW1FN _0x0,170
	CALL SUBOPT_0x34
; 0000 0407     set_per4an=8;
	LDI  R30,LOW(8)
	RJMP _0x450
; 0000 0408     }
; 0000 0409 else if(adc_menu<225)
_0x2C1:
	LDI  R30,LOW(225)
	CP   R11,R30
	BRSH _0x2C3
; 0000 040A     {
; 0000 040B     lcd_putsf("9. Arah Per4an 9");
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x34
; 0000 040C     set_per4an=9;
	LDI  R30,LOW(9)
	RJMP _0x450
; 0000 040D     }
; 0000 040E else{
_0x2C3:
; 0000 040F     lcd_putsf("10. Arah Per4an 10");
	__POINTW1FN _0x0,204
	CALL SUBOPT_0x34
; 0000 0410     set_per4an=10;
	LDI  R30,LOW(10)
_0x450:
	STS  _set_per4an,R30
; 0000 0411     }
; 0000 0412 
; 0000 0413 
; 0000 0414 if(enter==0) {delay_ms(400);goto edit_per4an;}
	SBIC 0x13,0
	RJMP _0x2C5
	CALL SUBOPT_0x32
	RJMP _0x2C6
; 0000 0415 if(back==0) {delay_ms(400);goto selesai;}
_0x2C5:
	SBIC 0x10,7
	RJMP _0x2C7
	CALL SUBOPT_0x32
	RJMP _0x2C8
; 0000 0416 goto awal;
_0x2C7:
	RJMP _0x2B2
; 0000 0417 
; 0000 0418 edit_per4an:
_0x2C6:
; 0000 0419 if(set_per4an==1) goto per4an_1;
	LDS  R26,_set_per4an
	CPI  R26,LOW(0x1)
	BREQ _0x2CA
; 0000 041A else if(set_per4an==2) goto per4an_2;
	CPI  R26,LOW(0x2)
	BRNE _0x2CC
	RJMP _0x2CD
; 0000 041B else if(set_per4an==3) goto per4an_3;
_0x2CC:
	LDS  R26,_set_per4an
	CPI  R26,LOW(0x3)
	BRNE _0x2CF
	RJMP _0x2D0
; 0000 041C else if(set_per4an==4) goto per4an_4;
_0x2CF:
	LDS  R26,_set_per4an
	CPI  R26,LOW(0x4)
	BRNE _0x2D2
	RJMP _0x2D3
; 0000 041D else if(set_per4an==5) goto per4an_5;
_0x2D2:
	LDS  R26,_set_per4an
	CPI  R26,LOW(0x5)
	BRNE _0x2D5
	RJMP _0x2D6
; 0000 041E else if(set_per4an==6) goto per4an_6;
_0x2D5:
	LDS  R26,_set_per4an
	CPI  R26,LOW(0x6)
	BRNE _0x2D8
	RJMP _0x2D9
; 0000 041F else if(set_per4an==7) goto per4an_7;
_0x2D8:
	LDS  R26,_set_per4an
	CPI  R26,LOW(0x7)
	BRNE _0x2DB
	RJMP _0x2DC
; 0000 0420 else if(set_per4an==8) goto per4an_8;
_0x2DB:
	LDS  R26,_set_per4an
	CPI  R26,LOW(0x8)
	BRNE _0x2DE
	RJMP _0x2DF
; 0000 0421 else if(set_per4an==9) goto per4an_9;
_0x2DE:
	LDS  R26,_set_per4an
	CPI  R26,LOW(0x9)
	BRNE _0x2E1
	RJMP _0x2E2
; 0000 0422 else if(set_per4an==10) goto per4an_10;
_0x2E1:
	LDS  R26,_set_per4an
	CPI  R26,LOW(0xA)
	BRNE _0x2E4
	RJMP _0x2E5
; 0000 0423 
; 0000 0424 
; 0000 0425 
; 0000 0426 per4an_1:
_0x2E4:
_0x2CA:
; 0000 0427 for(;;)
_0x2E7:
; 0000 0428     {
; 0000 0429     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 042A     if         (adc_menu<=60)    per4an_dir[1]=0;
	LDI  R30,LOW(60)
	CP   R30,R11
	BRLO _0x2E9
	LDI  R30,LOW(0)
	RJMP _0x451
; 0000 042B     else if  (adc_menu<=120)  per4an_dir[1]=1;
_0x2E9:
	LDI  R30,LOW(120)
	CP   R30,R11
	BRLO _0x2EB
	LDI  R30,LOW(1)
	RJMP _0x451
; 0000 042C     else                               per4an_dir[1]=2;
_0x2EB:
	LDI  R30,LOW(2)
_0x451:
	__PUTB1MN _per4an_dir,1
; 0000 042D 
; 0000 042E     lcd_gotoxy(0,1);
	CALL SUBOPT_0x35
; 0000 042F     if     (e_per4an_dir[1]==0)lcd_putsf("left");
	CALL SUBOPT_0x36
	CPI  R30,0
	BRNE _0x2ED
	__POINTW1FN _0x0,223
	RJMP _0x452
; 0000 0430     else if(e_per4an_dir[1]==1)lcd_putsf("right");
_0x2ED:
	CALL SUBOPT_0x36
	CPI  R30,LOW(0x1)
	BRNE _0x2EF
	__POINTW1FN _0x0,228
	RJMP _0x452
; 0000 0431     else if(e_per4an_dir[1]==2)lcd_putsf("lurus");
_0x2EF:
	CALL SUBOPT_0x36
	CPI  R30,LOW(0x2)
	BRNE _0x2F1
	__POINTW1FN _0x0,234
_0x452:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0432 
; 0000 0433     lcd_gotoxy(7,1);
_0x2F1:
	CALL SUBOPT_0x37
; 0000 0434     lcd_putsf("<-");
; 0000 0435     if        (per4an_dir[1]==0)lcd_putsf("left");
	__GETB1MN _per4an_dir,1
	CPI  R30,0
	BRNE _0x2F2
	__POINTW1FN _0x0,223
	RJMP _0x453
; 0000 0436     else if (per4an_dir[1]==1)lcd_putsf("right");
_0x2F2:
	__GETB2MN _per4an_dir,1
	CPI  R26,LOW(0x1)
	BRNE _0x2F4
	__POINTW1FN _0x0,228
	RJMP _0x453
; 0000 0437     else if (per4an_dir[1]==2)lcd_putsf("lurus");
_0x2F4:
	__GETB2MN _per4an_dir,1
	CPI  R26,LOW(0x2)
	BRNE _0x2F6
	__POINTW1FN _0x0,234
_0x453:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0438 
; 0000 0439     if(enter==0){e_per4an_dir[1]=per4an_dir[1];per4an_dir[1]=per4an_dir[1];delay_ms(400);lcd_clear();goto awal;}
_0x2F6:
	SBIC 0x13,0
	RJMP _0x2F7
	__POINTW2MN _e_per4an_dir,1
	__GETB1MN _per4an_dir,1
	CALL __EEPROMWRB
	__GETB1MN _per4an_dir,1
	__PUTB1MN _per4an_dir,1
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 043A     if(back==0){delay_ms(400);lcd_clear();goto awal;}
_0x2F7:
	SBIC 0x10,7
	RJMP _0x2F8
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 043B     delay_ms(50);
_0x2F8:
	CALL SUBOPT_0x13
; 0000 043C     }
	RJMP _0x2E7
; 0000 043D 
; 0000 043E     per4an_2:
_0x2CD:
; 0000 043F     for(;;)
_0x2FA:
; 0000 0440     {
; 0000 0441     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 0442     if         (adc_menu<=60)    per4an_dir[2]=0;
	LDI  R30,LOW(60)
	CP   R30,R11
	BRLO _0x2FC
	LDI  R30,LOW(0)
	RJMP _0x454
; 0000 0443     else if  (adc_menu<=120)  per4an_dir[2]=1;
_0x2FC:
	LDI  R30,LOW(120)
	CP   R30,R11
	BRLO _0x2FE
	LDI  R30,LOW(1)
	RJMP _0x454
; 0000 0444     else                               per4an_dir[2]=2;
_0x2FE:
	LDI  R30,LOW(2)
_0x454:
	__PUTB1MN _per4an_dir,2
; 0000 0445 
; 0000 0446     lcd_gotoxy(0,1);
	CALL SUBOPT_0x35
; 0000 0447     if     (e_per4an_dir[2]==0)lcd_putsf("left");
	CALL SUBOPT_0x38
	CPI  R30,0
	BRNE _0x300
	__POINTW1FN _0x0,223
	RJMP _0x455
; 0000 0448     else if(e_per4an_dir[2]==1)lcd_putsf("right");
_0x300:
	CALL SUBOPT_0x38
	CPI  R30,LOW(0x1)
	BRNE _0x302
	__POINTW1FN _0x0,228
	RJMP _0x455
; 0000 0449     else if(e_per4an_dir[2]==2)lcd_putsf("lurus");
_0x302:
	CALL SUBOPT_0x38
	CPI  R30,LOW(0x2)
	BRNE _0x304
	__POINTW1FN _0x0,234
_0x455:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 044A 
; 0000 044B     lcd_gotoxy(7,1);
_0x304:
	CALL SUBOPT_0x37
; 0000 044C     lcd_putsf("<-");
; 0000 044D     if     (per4an_dir[2]==0)lcd_putsf("left");
	__GETB1MN _per4an_dir,2
	CPI  R30,0
	BRNE _0x305
	__POINTW1FN _0x0,223
	RJMP _0x456
; 0000 044E     else if(per4an_dir[2]==1)lcd_putsf("right");
_0x305:
	__GETB2MN _per4an_dir,2
	CPI  R26,LOW(0x1)
	BRNE _0x307
	__POINTW1FN _0x0,228
	RJMP _0x456
; 0000 044F     else if(per4an_dir[2]==2)lcd_putsf("lurus");
_0x307:
	__GETB2MN _per4an_dir,2
	CPI  R26,LOW(0x2)
	BRNE _0x309
	__POINTW1FN _0x0,234
_0x456:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0450     if(enter==0){e_per4an_dir[2]=per4an_dir[2];per4an_dir[2]=per4an_dir[2];delay_ms(400);lcd_clear();goto awal;}
_0x309:
	SBIC 0x13,0
	RJMP _0x30A
	__POINTW2MN _e_per4an_dir,2
	__GETB1MN _per4an_dir,2
	CALL __EEPROMWRB
	__GETB1MN _per4an_dir,2
	__PUTB1MN _per4an_dir,2
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 0451     if(back==0){delay_ms(400);lcd_clear();goto awal;}
_0x30A:
	SBIC 0x10,7
	RJMP _0x30B
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 0452     delay_ms(50);
_0x30B:
	CALL SUBOPT_0x13
; 0000 0453     }
	RJMP _0x2FA
; 0000 0454 
; 0000 0455     per4an_3:
_0x2D0:
; 0000 0456     for(;;)
_0x30D:
; 0000 0457     {
; 0000 0458     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 0459 
; 0000 045A     if        (adc_menu<=50)   per4an_dir[3]=0;
	LDI  R30,LOW(50)
	CP   R30,R11
	BRLO _0x30F
	LDI  R30,LOW(0)
	RJMP _0x457
; 0000 045B     else if (adc_menu<=120) per4an_dir[3]=1;
_0x30F:
	LDI  R30,LOW(120)
	CP   R30,R11
	BRLO _0x311
	LDI  R30,LOW(1)
	RJMP _0x457
; 0000 045C     else                             per4an_dir[3]=2;
_0x311:
	LDI  R30,LOW(2)
_0x457:
	__PUTB1MN _per4an_dir,3
; 0000 045D 
; 0000 045E     lcd_gotoxy(0,1);
	CALL SUBOPT_0x35
; 0000 045F     if     (e_per4an_dir[3]==0)lcd_putsf("left");
	CALL SUBOPT_0x39
	CPI  R30,0
	BRNE _0x313
	__POINTW1FN _0x0,223
	RJMP _0x458
; 0000 0460     else if(e_per4an_dir[3]==1)lcd_putsf("right");
_0x313:
	CALL SUBOPT_0x39
	CPI  R30,LOW(0x1)
	BRNE _0x315
	__POINTW1FN _0x0,228
	RJMP _0x458
; 0000 0461     else if(e_per4an_dir[3]==2)lcd_putsf("lurus");
_0x315:
	CALL SUBOPT_0x39
	CPI  R30,LOW(0x2)
	BRNE _0x317
	__POINTW1FN _0x0,234
_0x458:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0462 
; 0000 0463     lcd_gotoxy(7,1);
_0x317:
	CALL SUBOPT_0x37
; 0000 0464     lcd_putsf("<-");
; 0000 0465     if     (per4an_dir[3]==0)lcd_putsf("left");
	__GETB1MN _per4an_dir,3
	CPI  R30,0
	BRNE _0x318
	__POINTW1FN _0x0,223
	RJMP _0x459
; 0000 0466     else if(per4an_dir[3]==1)lcd_putsf("right");
_0x318:
	__GETB2MN _per4an_dir,3
	CPI  R26,LOW(0x1)
	BRNE _0x31A
	__POINTW1FN _0x0,228
	RJMP _0x459
; 0000 0467     else if(per4an_dir[3]==2)lcd_putsf("lurus");
_0x31A:
	__GETB2MN _per4an_dir,3
	CPI  R26,LOW(0x2)
	BRNE _0x31C
	__POINTW1FN _0x0,234
_0x459:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0468 
; 0000 0469     if(enter==0){e_per4an_dir[3]=per4an_dir[3];per4an_dir[3]=per4an_dir[3];delay_ms(400);lcd_clear();goto awal;}
_0x31C:
	SBIC 0x13,0
	RJMP _0x31D
	__POINTW2MN _e_per4an_dir,3
	__GETB1MN _per4an_dir,3
	CALL __EEPROMWRB
	__GETB1MN _per4an_dir,3
	__PUTB1MN _per4an_dir,3
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 046A     if(back==0){delay_ms(400);lcd_clear();goto awal;}
_0x31D:
	SBIC 0x10,7
	RJMP _0x31E
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 046B     delay_ms(50);
_0x31E:
	CALL SUBOPT_0x13
; 0000 046C     }
	RJMP _0x30D
; 0000 046D 
; 0000 046E     per4an_4:
_0x2D3:
; 0000 046F     for(;;)
_0x320:
; 0000 0470     {
; 0000 0471     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 0472 
; 0000 0473     if       (adc_menu<=50)   per4an_dir[4]=0;
	LDI  R30,LOW(50)
	CP   R30,R11
	BRLO _0x322
	LDI  R30,LOW(0)
	RJMP _0x45A
; 0000 0474     else if(adc_menu<=120) per4an_dir[4]=1;
_0x322:
	LDI  R30,LOW(120)
	CP   R30,R11
	BRLO _0x324
	LDI  R30,LOW(1)
	RJMP _0x45A
; 0000 0475     else                            per4an_dir[4]=2;
_0x324:
	LDI  R30,LOW(2)
_0x45A:
	__PUTB1MN _per4an_dir,4
; 0000 0476 
; 0000 0477     lcd_gotoxy(0,1);
	CALL SUBOPT_0x35
; 0000 0478     if     (e_per4an_dir[4]==0)lcd_putsf("left");
	CALL SUBOPT_0x3A
	CPI  R30,0
	BRNE _0x326
	__POINTW1FN _0x0,223
	RJMP _0x45B
; 0000 0479     else if(e_per4an_dir[4]==1)lcd_putsf("right");
_0x326:
	CALL SUBOPT_0x3A
	CPI  R30,LOW(0x1)
	BRNE _0x328
	__POINTW1FN _0x0,228
	RJMP _0x45B
; 0000 047A     else if(e_per4an_dir[4]==2)lcd_putsf("lurus");
_0x328:
	CALL SUBOPT_0x3A
	CPI  R30,LOW(0x2)
	BRNE _0x32A
	__POINTW1FN _0x0,234
_0x45B:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 047B 
; 0000 047C     lcd_gotoxy(7,1);
_0x32A:
	CALL SUBOPT_0x37
; 0000 047D     lcd_putsf("<-");
; 0000 047E     if     (per4an_dir[4]==0)lcd_putsf("left");
	__GETB1MN _per4an_dir,4
	CPI  R30,0
	BRNE _0x32B
	__POINTW1FN _0x0,223
	RJMP _0x45C
; 0000 047F     else if(per4an_dir[4]==1)lcd_putsf("right");
_0x32B:
	__GETB2MN _per4an_dir,4
	CPI  R26,LOW(0x1)
	BRNE _0x32D
	__POINTW1FN _0x0,228
	RJMP _0x45C
; 0000 0480     else if(per4an_dir[4]==2)lcd_putsf("lurus");
_0x32D:
	__GETB2MN _per4an_dir,4
	CPI  R26,LOW(0x2)
	BRNE _0x32F
	__POINTW1FN _0x0,234
_0x45C:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0481 
; 0000 0482     if(enter==0){e_per4an_dir[4]=per4an_dir[4];per4an_dir[4]=per4an_dir[4];delay_ms(400);lcd_clear();goto awal;}
_0x32F:
	SBIC 0x13,0
	RJMP _0x330
	__POINTW2MN _e_per4an_dir,4
	__GETB1MN _per4an_dir,4
	CALL __EEPROMWRB
	__GETB1MN _per4an_dir,4
	__PUTB1MN _per4an_dir,4
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 0483     if(back==0){delay_ms(400);lcd_clear();goto awal;}
_0x330:
	SBIC 0x10,7
	RJMP _0x331
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 0484     delay_ms(50);
_0x331:
	CALL SUBOPT_0x13
; 0000 0485     }
	RJMP _0x320
; 0000 0486 
; 0000 0487     per4an_5:
_0x2D6:
; 0000 0488     for(;;)
_0x333:
; 0000 0489     {
; 0000 048A     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 048B 
; 0000 048C     if         (adc_menu<=50) per4an_dir[5]=0;
	LDI  R30,LOW(50)
	CP   R30,R11
	BRLO _0x335
	LDI  R30,LOW(0)
	RJMP _0x45D
; 0000 048D     else if  (adc_menu<=120)per4an_dir[5]=1;
_0x335:
	LDI  R30,LOW(120)
	CP   R30,R11
	BRLO _0x337
	LDI  R30,LOW(1)
	RJMP _0x45D
; 0000 048E     else                             per4an_dir[5]=2;
_0x337:
	LDI  R30,LOW(2)
_0x45D:
	__PUTB1MN _per4an_dir,5
; 0000 048F 
; 0000 0490     lcd_gotoxy(0,1);
	CALL SUBOPT_0x35
; 0000 0491     if     (e_per4an_dir[5]==0)lcd_putsf("left");
	CALL SUBOPT_0x3B
	CPI  R30,0
	BRNE _0x339
	__POINTW1FN _0x0,223
	RJMP _0x45E
; 0000 0492     else if(e_per4an_dir[5]==1)lcd_putsf("right");
_0x339:
	CALL SUBOPT_0x3B
	CPI  R30,LOW(0x1)
	BRNE _0x33B
	__POINTW1FN _0x0,228
	RJMP _0x45E
; 0000 0493     else if(e_per4an_dir[5]==2)lcd_putsf("lurus");
_0x33B:
	CALL SUBOPT_0x3B
	CPI  R30,LOW(0x2)
	BRNE _0x33D
	__POINTW1FN _0x0,234
_0x45E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0494 
; 0000 0495     lcd_gotoxy(7,1);
_0x33D:
	CALL SUBOPT_0x37
; 0000 0496     lcd_putsf("<-");
; 0000 0497     if     (per4an_dir[5]==0)lcd_putsf("left");
	__GETB1MN _per4an_dir,5
	CPI  R30,0
	BRNE _0x33E
	__POINTW1FN _0x0,223
	RJMP _0x45F
; 0000 0498     else if(per4an_dir[5]==1)lcd_putsf("right");
_0x33E:
	__GETB2MN _per4an_dir,5
	CPI  R26,LOW(0x1)
	BRNE _0x340
	__POINTW1FN _0x0,228
	RJMP _0x45F
; 0000 0499     else if(per4an_dir[5]==2)lcd_putsf("lurus");
_0x340:
	__GETB2MN _per4an_dir,5
	CPI  R26,LOW(0x2)
	BRNE _0x342
	__POINTW1FN _0x0,234
_0x45F:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 049A 
; 0000 049B     if(enter==0){e_per4an_dir[5]=per4an_dir[5];per4an_dir[5]=per4an_dir[5];delay_ms(400);lcd_clear();goto awal;}
_0x342:
	SBIC 0x13,0
	RJMP _0x343
	__POINTW2MN _e_per4an_dir,5
	__GETB1MN _per4an_dir,5
	CALL __EEPROMWRB
	__GETB1MN _per4an_dir,5
	__PUTB1MN _per4an_dir,5
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 049C     if(back==0){delay_ms(400);lcd_clear();goto awal;}
_0x343:
	SBIC 0x10,7
	RJMP _0x344
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 049D     delay_ms(50);
_0x344:
	CALL SUBOPT_0x13
; 0000 049E     }
	RJMP _0x333
; 0000 049F 
; 0000 04A0 per4an_6:
_0x2D9:
; 0000 04A1     for(;;)
_0x346:
; 0000 04A2     {
; 0000 04A3     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 04A4 
; 0000 04A5     if         (adc_menu<=50) per4an_dir[6]=0;
	LDI  R30,LOW(50)
	CP   R30,R11
	BRLO _0x348
	LDI  R30,LOW(0)
	RJMP _0x460
; 0000 04A6     else if  (adc_menu<=120)per4an_dir[6]=1;
_0x348:
	LDI  R30,LOW(120)
	CP   R30,R11
	BRLO _0x34A
	LDI  R30,LOW(1)
	RJMP _0x460
; 0000 04A7     else                             per4an_dir[6]=2;
_0x34A:
	LDI  R30,LOW(2)
_0x460:
	__PUTB1MN _per4an_dir,6
; 0000 04A8 
; 0000 04A9     lcd_gotoxy(0,1);
	CALL SUBOPT_0x35
; 0000 04AA     if     (e_per4an_dir[6]==0)lcd_putsf("left");
	CALL SUBOPT_0x3C
	CPI  R30,0
	BRNE _0x34C
	__POINTW1FN _0x0,223
	RJMP _0x461
; 0000 04AB     else if(e_per4an_dir[6]==1)lcd_putsf("right");
_0x34C:
	CALL SUBOPT_0x3C
	CPI  R30,LOW(0x1)
	BRNE _0x34E
	__POINTW1FN _0x0,228
	RJMP _0x461
; 0000 04AC     else if(e_per4an_dir[6]==2)lcd_putsf("lurus");
_0x34E:
	CALL SUBOPT_0x3C
	CPI  R30,LOW(0x2)
	BRNE _0x350
	__POINTW1FN _0x0,234
_0x461:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 04AD 
; 0000 04AE     lcd_gotoxy(7,1);
_0x350:
	CALL SUBOPT_0x37
; 0000 04AF     lcd_putsf("<-");
; 0000 04B0     if     (per4an_dir[6]==0)lcd_putsf("left");
	__GETB1MN _per4an_dir,6
	CPI  R30,0
	BRNE _0x351
	__POINTW1FN _0x0,223
	RJMP _0x462
; 0000 04B1     else if(per4an_dir[6]==1)lcd_putsf("right");
_0x351:
	__GETB2MN _per4an_dir,6
	CPI  R26,LOW(0x1)
	BRNE _0x353
	__POINTW1FN _0x0,228
	RJMP _0x462
; 0000 04B2     else if(per4an_dir[6]==2)lcd_putsf("lurus");
_0x353:
	__GETB2MN _per4an_dir,6
	CPI  R26,LOW(0x2)
	BRNE _0x355
	__POINTW1FN _0x0,234
_0x462:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 04B3 
; 0000 04B4     if(enter==0){e_per4an_dir[6]=per4an_dir[6];per4an_dir[6]=per4an_dir[6];delay_ms(400);lcd_clear();goto awal;}
_0x355:
	SBIC 0x13,0
	RJMP _0x356
	__POINTW2MN _e_per4an_dir,6
	__GETB1MN _per4an_dir,6
	CALL __EEPROMWRB
	__GETB1MN _per4an_dir,6
	__PUTB1MN _per4an_dir,6
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 04B5     if(back==0){delay_ms(400);lcd_clear();goto awal;}
_0x356:
	SBIC 0x10,7
	RJMP _0x357
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 04B6     delay_ms(50);
_0x357:
	CALL SUBOPT_0x13
; 0000 04B7     }
	RJMP _0x346
; 0000 04B8 
; 0000 04B9     per4an_7:
_0x2DC:
; 0000 04BA     for(;;)
_0x359:
; 0000 04BB     {
; 0000 04BC     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 04BD 
; 0000 04BE     if         (adc_menu<=50) per4an_dir[7]=0;
	LDI  R30,LOW(50)
	CP   R30,R11
	BRLO _0x35B
	LDI  R30,LOW(0)
	RJMP _0x463
; 0000 04BF     else if  (adc_menu<=120)per4an_dir[7]=1;
_0x35B:
	LDI  R30,LOW(120)
	CP   R30,R11
	BRLO _0x35D
	LDI  R30,LOW(1)
	RJMP _0x463
; 0000 04C0     else                             per4an_dir[7]=2;
_0x35D:
	LDI  R30,LOW(2)
_0x463:
	__PUTB1MN _per4an_dir,7
; 0000 04C1 
; 0000 04C2     lcd_gotoxy(0,1);
	CALL SUBOPT_0x35
; 0000 04C3     if     (e_per4an_dir[7]==0)lcd_putsf("left");
	CALL SUBOPT_0x3D
	CPI  R30,0
	BRNE _0x35F
	__POINTW1FN _0x0,223
	RJMP _0x464
; 0000 04C4     else if(e_per4an_dir[7]==1)lcd_putsf("right");
_0x35F:
	CALL SUBOPT_0x3D
	CPI  R30,LOW(0x1)
	BRNE _0x361
	__POINTW1FN _0x0,228
	RJMP _0x464
; 0000 04C5     else if(e_per4an_dir[7]==2)lcd_putsf("lurus");
_0x361:
	CALL SUBOPT_0x3D
	CPI  R30,LOW(0x2)
	BRNE _0x363
	__POINTW1FN _0x0,234
_0x464:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 04C6 
; 0000 04C7     lcd_gotoxy(7,1);
_0x363:
	CALL SUBOPT_0x37
; 0000 04C8     lcd_putsf("<-");
; 0000 04C9     if     (per4an_dir[7]==0)lcd_putsf("left");
	__GETB1MN _per4an_dir,7
	CPI  R30,0
	BRNE _0x364
	__POINTW1FN _0x0,223
	RJMP _0x465
; 0000 04CA     else if(per4an_dir[7]==1)lcd_putsf("right");
_0x364:
	__GETB2MN _per4an_dir,7
	CPI  R26,LOW(0x1)
	BRNE _0x366
	__POINTW1FN _0x0,228
	RJMP _0x465
; 0000 04CB     else if(per4an_dir[7]==2)lcd_putsf("lurus");
_0x366:
	__GETB2MN _per4an_dir,7
	CPI  R26,LOW(0x2)
	BRNE _0x368
	__POINTW1FN _0x0,234
_0x465:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 04CC 
; 0000 04CD     if(enter==0){e_per4an_dir[7]=per4an_dir[7];per4an_dir[7]=per4an_dir[7];delay_ms(400);lcd_clear();goto awal;}
_0x368:
	SBIC 0x13,0
	RJMP _0x369
	__POINTW2MN _e_per4an_dir,7
	__GETB1MN _per4an_dir,7
	CALL __EEPROMWRB
	__GETB1MN _per4an_dir,7
	__PUTB1MN _per4an_dir,7
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 04CE     if(back==0){delay_ms(400);lcd_clear();goto awal;}
_0x369:
	SBIC 0x10,7
	RJMP _0x36A
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 04CF     delay_ms(50);
_0x36A:
	CALL SUBOPT_0x13
; 0000 04D0     }
	RJMP _0x359
; 0000 04D1 
; 0000 04D2     per4an_8:
_0x2DF:
; 0000 04D3     for(;;)
_0x36C:
; 0000 04D4     {
; 0000 04D5     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 04D6 
; 0000 04D7     if         (adc_menu<=50) per4an_dir[8]=0;
	LDI  R30,LOW(50)
	CP   R30,R11
	BRLO _0x36E
	LDI  R30,LOW(0)
	RJMP _0x466
; 0000 04D8     else if  (adc_menu<=120)per4an_dir[8]=1;
_0x36E:
	LDI  R30,LOW(120)
	CP   R30,R11
	BRLO _0x370
	LDI  R30,LOW(1)
	RJMP _0x466
; 0000 04D9     else                             per4an_dir[8]=2;
_0x370:
	LDI  R30,LOW(2)
_0x466:
	__PUTB1MN _per4an_dir,8
; 0000 04DA 
; 0000 04DB     lcd_gotoxy(0,1);
	CALL SUBOPT_0x35
; 0000 04DC     if     (e_per4an_dir[8]==0)lcd_putsf("left");
	CALL SUBOPT_0x3E
	CPI  R30,0
	BRNE _0x372
	__POINTW1FN _0x0,223
	RJMP _0x467
; 0000 04DD     else if(e_per4an_dir[8]==1)lcd_putsf("right");
_0x372:
	CALL SUBOPT_0x3E
	CPI  R30,LOW(0x1)
	BRNE _0x374
	__POINTW1FN _0x0,228
	RJMP _0x467
; 0000 04DE     else if(e_per4an_dir[8]==2)lcd_putsf("lurus");
_0x374:
	CALL SUBOPT_0x3E
	CPI  R30,LOW(0x2)
	BRNE _0x376
	__POINTW1FN _0x0,234
_0x467:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 04DF 
; 0000 04E0     lcd_gotoxy(7,1);
_0x376:
	CALL SUBOPT_0x37
; 0000 04E1     lcd_putsf("<-");
; 0000 04E2     if     (per4an_dir[8]==0)lcd_putsf("left");
	__GETB1MN _per4an_dir,8
	CPI  R30,0
	BRNE _0x377
	__POINTW1FN _0x0,223
	RJMP _0x468
; 0000 04E3     else if(per4an_dir[8]==1)lcd_putsf("right");
_0x377:
	__GETB2MN _per4an_dir,8
	CPI  R26,LOW(0x1)
	BRNE _0x379
	__POINTW1FN _0x0,228
	RJMP _0x468
; 0000 04E4     else if(per4an_dir[8]==2)lcd_putsf("lurus");
_0x379:
	__GETB2MN _per4an_dir,8
	CPI  R26,LOW(0x2)
	BRNE _0x37B
	__POINTW1FN _0x0,234
_0x468:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 04E5 
; 0000 04E6     if(enter==0){e_per4an_dir[8]=per4an_dir[8];per4an_dir[8]=per4an_dir[8];delay_ms(400);lcd_clear();goto awal;}
_0x37B:
	SBIC 0x13,0
	RJMP _0x37C
	__POINTW2MN _e_per4an_dir,8
	__GETB1MN _per4an_dir,8
	CALL __EEPROMWRB
	__GETB1MN _per4an_dir,8
	__PUTB1MN _per4an_dir,8
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 04E7     if(back==0){delay_ms(400);lcd_clear();goto awal;}
_0x37C:
	SBIC 0x10,7
	RJMP _0x37D
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 04E8     delay_ms(50);
_0x37D:
	CALL SUBOPT_0x13
; 0000 04E9     }
	RJMP _0x36C
; 0000 04EA 
; 0000 04EB     per4an_9:
_0x2E2:
; 0000 04EC     for(;;)
_0x37F:
; 0000 04ED     {
; 0000 04EE     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 04EF 
; 0000 04F0     if         (adc_menu<=50) per4an_dir[9]=0;
	LDI  R30,LOW(50)
	CP   R30,R11
	BRLO _0x381
	LDI  R30,LOW(0)
	RJMP _0x469
; 0000 04F1     else if  (adc_menu<=120)per4an_dir[9]=1;
_0x381:
	LDI  R30,LOW(120)
	CP   R30,R11
	BRLO _0x383
	LDI  R30,LOW(1)
	RJMP _0x469
; 0000 04F2     else                             per4an_dir[9]=2;
_0x383:
	LDI  R30,LOW(2)
_0x469:
	__PUTB1MN _per4an_dir,9
; 0000 04F3 
; 0000 04F4     lcd_gotoxy(0,1);
	CALL SUBOPT_0x35
; 0000 04F5     if     (e_per4an_dir[9]==0)lcd_putsf("left");
	CALL SUBOPT_0x3F
	CPI  R30,0
	BRNE _0x385
	__POINTW1FN _0x0,223
	RJMP _0x46A
; 0000 04F6     else if(e_per4an_dir[9]==1)lcd_putsf("right");
_0x385:
	CALL SUBOPT_0x3F
	CPI  R30,LOW(0x1)
	BRNE _0x387
	__POINTW1FN _0x0,228
	RJMP _0x46A
; 0000 04F7     else if(e_per4an_dir[9]==2)lcd_putsf("lurus");
_0x387:
	CALL SUBOPT_0x3F
	CPI  R30,LOW(0x2)
	BRNE _0x389
	__POINTW1FN _0x0,234
_0x46A:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 04F8 
; 0000 04F9     lcd_gotoxy(7,1);
_0x389:
	CALL SUBOPT_0x37
; 0000 04FA     lcd_putsf("<-");
; 0000 04FB     if     (per4an_dir[9]==0)lcd_putsf("left");
	__GETB1MN _per4an_dir,9
	CPI  R30,0
	BRNE _0x38A
	__POINTW1FN _0x0,223
	RJMP _0x46B
; 0000 04FC     else if(per4an_dir[9]==1)lcd_putsf("right");
_0x38A:
	__GETB2MN _per4an_dir,9
	CPI  R26,LOW(0x1)
	BRNE _0x38C
	__POINTW1FN _0x0,228
	RJMP _0x46B
; 0000 04FD     else if(per4an_dir[9]==2)lcd_putsf("lurus");
_0x38C:
	__GETB2MN _per4an_dir,9
	CPI  R26,LOW(0x2)
	BRNE _0x38E
	__POINTW1FN _0x0,234
_0x46B:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 04FE 
; 0000 04FF     if(enter==0){e_per4an_dir[9]=per4an_dir[9];per4an_dir[9]=per4an_dir[9];delay_ms(400);lcd_clear();goto awal;}
_0x38E:
	SBIC 0x13,0
	RJMP _0x38F
	__POINTW2MN _e_per4an_dir,9
	__GETB1MN _per4an_dir,9
	CALL __EEPROMWRB
	__GETB1MN _per4an_dir,9
	__PUTB1MN _per4an_dir,9
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 0500     if(back==0){delay_ms(400);lcd_clear();goto awal;}
_0x38F:
	SBIC 0x10,7
	RJMP _0x390
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 0501     delay_ms(50);
_0x390:
	CALL SUBOPT_0x13
; 0000 0502     }
	RJMP _0x37F
; 0000 0503 
; 0000 0504     per4an_10:
_0x2E5:
; 0000 0505     for(;;)
_0x392:
; 0000 0506     {
; 0000 0507     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 0508 
; 0000 0509     if         (adc_menu<=50) per4an_dir[10]=0;
	LDI  R30,LOW(50)
	CP   R30,R11
	BRLO _0x394
	LDI  R30,LOW(0)
	RJMP _0x46C
; 0000 050A     else if  (adc_menu<=120)per4an_dir[10]=1;
_0x394:
	LDI  R30,LOW(120)
	CP   R30,R11
	BRLO _0x396
	LDI  R30,LOW(1)
	RJMP _0x46C
; 0000 050B     else                             per4an_dir[10]=2;
_0x396:
	LDI  R30,LOW(2)
_0x46C:
	__PUTB1MN _per4an_dir,10
; 0000 050C 
; 0000 050D     lcd_gotoxy(0,1);
	CALL SUBOPT_0x35
; 0000 050E     if     (e_per4an_dir[10]==0)lcd_putsf("left");
	CALL SUBOPT_0x40
	CPI  R30,0
	BRNE _0x398
	__POINTW1FN _0x0,223
	RJMP _0x46D
; 0000 050F     else if(e_per4an_dir[10]==1)lcd_putsf("right");
_0x398:
	CALL SUBOPT_0x40
	CPI  R30,LOW(0x1)
	BRNE _0x39A
	__POINTW1FN _0x0,228
	RJMP _0x46D
; 0000 0510     else if(e_per4an_dir[10]==2)lcd_putsf("lurus");
_0x39A:
	CALL SUBOPT_0x40
	CPI  R30,LOW(0x2)
	BRNE _0x39C
	__POINTW1FN _0x0,234
_0x46D:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0511 
; 0000 0512     lcd_gotoxy(7,1);
_0x39C:
	CALL SUBOPT_0x37
; 0000 0513     lcd_putsf("<-");
; 0000 0514     if     (per4an_dir[10]==0)lcd_putsf("left");
	__GETB1MN _per4an_dir,10
	CPI  R30,0
	BRNE _0x39D
	__POINTW1FN _0x0,223
	RJMP _0x46E
; 0000 0515     else if(per4an_dir[10]==1)lcd_putsf("right");
_0x39D:
	__GETB2MN _per4an_dir,10
	CPI  R26,LOW(0x1)
	BRNE _0x39F
	__POINTW1FN _0x0,228
	RJMP _0x46E
; 0000 0516     else if(per4an_dir[10]==2)lcd_putsf("lurus");
_0x39F:
	__GETB2MN _per4an_dir,10
	CPI  R26,LOW(0x2)
	BRNE _0x3A1
	__POINTW1FN _0x0,234
_0x46E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0517 
; 0000 0518     if(enter==0){e_per4an_dir[10]=per4an_dir[10];per4an_dir[10]=per4an_dir[10];delay_ms(400);lcd_clear();goto awal;}
_0x3A1:
	SBIC 0x13,0
	RJMP _0x3A2
	__POINTW2MN _e_per4an_dir,10
	__GETB1MN _per4an_dir,10
	CALL __EEPROMWRB
	__GETB1MN _per4an_dir,10
	__PUTB1MN _per4an_dir,10
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 0519     if(back==0){delay_ms(400);lcd_clear();goto awal;}
_0x3A2:
	SBIC 0x10,7
	RJMP _0x3A3
	CALL SUBOPT_0x32
	CALL _lcd_clear
	RJMP _0x2B2
; 0000 051A     delay_ms(50);
_0x3A3:
	CALL SUBOPT_0x13
; 0000 051B     }
	RJMP _0x392
; 0000 051C 
; 0000 051D     selesai:
_0x2C8:
; 0000 051E }
	RET
;
;void pembagi_kp()
; 0000 0521 {
_pembagi_kp:
; 0000 0522 lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF
; 0000 0523 sprintf(lcd,"=%d",kp_div);
	__POINTW1FN _0x0,36
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R7
	CALL SUBOPT_0xD
; 0000 0524 lcd_puts(lcd);
; 0000 0525 for(;;)
_0x3A5:
; 0000 0526     {
; 0000 0527     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 0528     adc_menu=255-adc_menu;
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
; 0000 0529 
; 0000 052A     //kp_div=adc_menu/5;
; 0000 052B 
; 0000 052C     lcd_gotoxy(8,1);
; 0000 052D     lcd_putsf("   ");
; 0000 052E     lcd_gotoxy(5,1);
; 0000 052F     sprintf(lcd," <- %d",adc_menu/3);
	__POINTW1FN _0x0,44
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x41
	CALL SUBOPT_0xB
; 0000 0530     lcd_puts(lcd);
; 0000 0531 
; 0000 0532     if(enter==0){e_kp_div=adc_menu/3;kp_div=adc_menu/3;delay_ms(400);break;}
	SBIC 0x13,0
	RJMP _0x3A7
	CALL SUBOPT_0x41
	LDI  R26,LOW(_e_kp_div)
	LDI  R27,HIGH(_e_kp_div)
	CALL __EEPROMWRB
	CALL SUBOPT_0x41
	MOV  R7,R30
	CALL SUBOPT_0x32
	RJMP _0x3A6
; 0000 0533     if(back==0){delay_ms(400);break;}
_0x3A7:
	SBIC 0x10,7
	RJMP _0x3A8
	CALL SUBOPT_0x32
	RJMP _0x3A6
; 0000 0534     delay_ms(50);
_0x3A8:
	CALL SUBOPT_0x13
; 0000 0535     }
	RJMP _0x3A5
_0x3A6:
; 0000 0536 }
	RET
;
;
;void slave_menu()
; 0000 053A {
_slave_menu:
; 0000 053B     menu_slave=0;
	CLR  R6
; 0000 053C     temp_adc_menu=0;
	CLR  R8
; 0000 053D     for(;;)
_0x3AA:
; 0000 053E     {
; 0000 053F     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 0540     if(temp_adc_menu!=adc_menu) lcd_clear();
	CP   R11,R8
	BREQ _0x3AC
	CALL _lcd_clear
; 0000 0541     lcd_gotoxy(0,0);
_0x3AC:
	CALL SUBOPT_0x33
; 0000 0542 
; 0000 0543     if (adc_menu<=125)
	LDI  R30,LOW(125)
	CP   R30,R11
	BRLO _0x3AD
; 0000 0544         {
; 0000 0545         lcd_putsf("1. Arah Per4an ");
	__POINTW1FN _0x0,243
	CALL SUBOPT_0x34
; 0000 0546         menu_slave=1;
	LDI  R30,LOW(1)
	RJMP _0x46F
; 0000 0547         }
; 0000 0548     else if (adc_menu<=255)
_0x3AD:
	LDI  R30,LOW(255)
	CP   R30,R11
	BRLO _0x3AF
; 0000 0549         {
; 0000 054A         lcd_putsf("2.Pembagi Kp ");
	__POINTW1FN _0x0,259
	CALL SUBOPT_0x34
; 0000 054B         menu_slave=2;
	LDI  R30,LOW(2)
_0x46F:
	MOV  R6,R30
; 0000 054C         }
; 0000 054D 
; 0000 054E     if(enter==0)
_0x3AF:
	SBIC 0x13,0
	RJMP _0x3B0
; 0000 054F     {
; 0000 0550         delay_ms(300);
	CALL SUBOPT_0x20
; 0000 0551         if      (menu_slave==1)eksekusi_per4an();
	LDI  R30,LOW(1)
	CP   R30,R6
	BRNE _0x3B1
	RCALL _eksekusi_per4an
; 0000 0552         else if (menu_slave==2)pembagi_kp();
	RJMP _0x3B2
_0x3B1:
	LDI  R30,LOW(2)
	CP   R30,R6
	BRNE _0x3B3
	RCALL _pembagi_kp
; 0000 0553 
; 0000 0554     }
_0x3B3:
_0x3B2:
; 0000 0555        if(back==0){delay_ms(400);menu_slave=0;break;}
_0x3B0:
	SBIC 0x10,7
	RJMP _0x3B4
	CALL SUBOPT_0x32
	CLR  R6
	RJMP _0x3AB
; 0000 0556 
; 0000 0557     temp_adc_menu=adc_menu;
_0x3B4:
	MOV  R8,R11
; 0000 0558     }
	RJMP _0x3AA
_0x3AB:
; 0000 0559 
; 0000 055A 
; 0000 055B }
	RET
;
;void tampil_driver ()
; 0000 055E {
_tampil_driver:
; 0000 055F lcd_clear();lcd_gotoxy(0,1);sprintf(lcd,"%d %d",speed_ki,speed_ka); lcd_puts(lcd);
	CALL _lcd_clear
	LDI  R30,LOW(0)
	CALL SUBOPT_0xF
	__POINTW1FN _0x0,30
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x5
	CALL __CWD1
	CALL __PUTPARD1
	CALL SUBOPT_0x3
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0560 }
	RET
;
;void tes_driver()
; 0000 0563 {
_tes_driver:
; 0000 0564 pwm_on();
	CALL _pwm_on
; 0000 0565 
; 0000 0566 kanan_maju_full:
_0x3B5:
; 0000 0567         speed_ki=0;ki_maju();
	LDI  R30,LOW(0)
	STS  _speed_ki,R30
	STS  _speed_ki+1,R30
	CALL _ki_maju
; 0000 0568 tampil_driver();
	CALL SUBOPT_0x42
; 0000 0569 speed_ka=255;ka_maju();
	CALL SUBOPT_0x43
; 0000 056A if (enter==0) {delay_ms(400);goto kanan_maju_pelan;}
	SBIC 0x13,0
	RJMP _0x3B6
	CALL SUBOPT_0x32
	RJMP _0x3B7
; 0000 056B if (back==0) {goto completed_test;}
_0x3B6:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 056C goto kanan_maju_full;
	RJMP _0x3B5
; 0000 056D 
; 0000 056E kanan_maju_pelan:
_0x3B7:
; 0000 056F tampil_driver();
	CALL SUBOPT_0x44
; 0000 0570 speed_ka=100;ka_maju();
	CALL SUBOPT_0x43
; 0000 0571 if (enter==0) {delay_ms(400);goto kanan_mundur_full;}
	SBIC 0x13,0
	RJMP _0x3BA
	CALL SUBOPT_0x32
	RJMP _0x3BB
; 0000 0572 if (back==0) goto completed_test;
_0x3BA:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 0573 goto kanan_maju_pelan;
	RJMP _0x3B7
; 0000 0574 
; 0000 0575 kanan_mundur_full:
_0x3BB:
; 0000 0576 tampil_driver();
	CALL SUBOPT_0x45
; 0000 0577 speed_ka=-255;ka_mund();
	CALL SUBOPT_0x4
	CALL _ka_mund
; 0000 0578 if (enter==0) {delay_ms(400);goto kanan_mundur_pelan;}
	SBIC 0x13,0
	RJMP _0x3BD
	CALL SUBOPT_0x32
	RJMP _0x3BE
; 0000 0579 if (back==0) goto completed_test;
_0x3BD:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 057A goto kanan_mundur_full;
	RJMP _0x3BB
; 0000 057B 
; 0000 057C kanan_mundur_pelan:
_0x3BE:
; 0000 057D tampil_driver();
	RCALL _tampil_driver
; 0000 057E speed_ka=-100;ka_mund();
	CALL SUBOPT_0x11
	CALL _ka_mund
; 0000 057F if (enter==0) {delay_ms(400);goto kiri_maju_full;}
	SBIC 0x13,0
	RJMP _0x3C0
	CALL SUBOPT_0x32
	RJMP _0x3C1
; 0000 0580 if (back==0) goto completed_test;
_0x3C0:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 0581 goto kanan_mundur_pelan;
	RJMP _0x3BE
; 0000 0582 
; 0000 0583 kiri_maju_full:
_0x3C1:
; 0000 0584     speed_ka=0;ka_maju();
	LDI  R30,LOW(0)
	STS  _speed_ka,R30
	STS  _speed_ka+1,R30
	CALL _ka_maju
; 0000 0585 
; 0000 0586 tampil_driver();
	CALL SUBOPT_0x42
; 0000 0587 speed_ki=255;ki_maju();
	CALL SUBOPT_0x46
; 0000 0588 if (enter==0) {delay_ms(400);goto kiri_maju_pelan;}
	SBIC 0x13,0
	RJMP _0x3C3
	CALL SUBOPT_0x32
	RJMP _0x3C4
; 0000 0589 if (back==0) goto completed_test;
_0x3C3:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 058A goto kiri_maju_full;
	RJMP _0x3C1
; 0000 058B 
; 0000 058C kiri_maju_pelan:
_0x3C4:
; 0000 058D tampil_driver();
	CALL SUBOPT_0x44
; 0000 058E speed_ki=100;ki_maju();
	CALL SUBOPT_0x46
; 0000 058F if (enter==0) {delay_ms(400);goto kiri_mundur_full;}
	SBIC 0x13,0
	RJMP _0x3C6
	CALL SUBOPT_0x32
	RJMP _0x3C7
; 0000 0590 if (back==0) goto completed_test;
_0x3C6:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 0591 goto kiri_maju_pelan;
	RJMP _0x3C4
; 0000 0592 
; 0000 0593 kiri_mundur_full:
_0x3C7:
; 0000 0594 tampil_driver();
	CALL SUBOPT_0x45
; 0000 0595 speed_ki=-255;ki_mund();
	CALL SUBOPT_0x6
	CALL _ki_mund
; 0000 0596 if (enter==0) {delay_ms(400);goto kiri_mundur_pelan;}
	SBIC 0x13,0
	RJMP _0x3C9
	CALL SUBOPT_0x32
	RJMP _0x3CA
; 0000 0597 if (back==0) goto completed_test;
_0x3C9:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 0598 goto kiri_mundur_full;
	RJMP _0x3C7
; 0000 0599 
; 0000 059A kiri_mundur_pelan:
_0x3CA:
; 0000 059B tampil_driver();
	RCALL _tampil_driver
; 0000 059C speed_ki=-100;ki_mund();
	CALL SUBOPT_0x12
	CALL _ki_mund
; 0000 059D if (enter==0) {delay_ms(400);goto maju_full;}
	SBIC 0x13,0
	RJMP _0x3CC
	CALL SUBOPT_0x32
	RJMP _0x3CD
; 0000 059E if (back==0) goto completed_test;
_0x3CC:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 059F goto kiri_mundur_pelan;
	RJMP _0x3CA
; 0000 05A0 
; 0000 05A1 maju_full:
_0x3CD:
; 0000 05A2 tampil_driver();
	CALL SUBOPT_0x42
; 0000 05A3 speed_ka=255;ka_maju();
	CALL SUBOPT_0x43
; 0000 05A4 speed_ki=255;ki_maju();
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x46
; 0000 05A5 if (enter==0) {delay_ms(400);goto maju_pelan;}
	SBIC 0x13,0
	RJMP _0x3CF
	CALL SUBOPT_0x32
	RJMP _0x3D0
; 0000 05A6 if (back==0) goto completed_test;
_0x3CF:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 05A7 goto maju_full;
	RJMP _0x3CD
; 0000 05A8 
; 0000 05A9 maju_pelan:
_0x3D0:
; 0000 05AA tampil_driver();
	CALL SUBOPT_0x44
; 0000 05AB speed_ka=100;ka_maju();
	CALL SUBOPT_0x43
; 0000 05AC speed_ki=100;ki_maju();
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x46
; 0000 05AD if (enter==0) {delay_ms(400);goto mundur_full;}
	SBIC 0x13,0
	RJMP _0x3D2
	CALL SUBOPT_0x32
	RJMP _0x3D3
; 0000 05AE if (back==0) goto completed_test;
_0x3D2:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 05AF goto maju_pelan;
	RJMP _0x3D0
; 0000 05B0 
; 0000 05B1 mundur_full:
_0x3D3:
; 0000 05B2 tampil_driver();
	CALL SUBOPT_0x45
; 0000 05B3 speed_ka=-255;ka_mund();
	CALL SUBOPT_0x4
	CALL _ka_mund
; 0000 05B4 speed_ki=-255;ki_mund();
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	CALL SUBOPT_0x6
	CALL _ki_mund
; 0000 05B5 if (enter==0) {delay_ms(400);goto mundur_pelan;}
	SBIC 0x13,0
	RJMP _0x3D5
	CALL SUBOPT_0x32
	RJMP _0x3D6
; 0000 05B6 if (back==0) goto completed_test;
_0x3D5:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 05B7 goto mundur_full;
	RJMP _0x3D3
; 0000 05B8 
; 0000 05B9 mundur_pelan:
_0x3D6:
; 0000 05BA tampil_driver();
	RCALL _tampil_driver
; 0000 05BB speed_ka=-100;ka_mund();
	CALL SUBOPT_0x11
	CALL _ka_mund
; 0000 05BC speed_ki=-100;ki_mund();
	CALL SUBOPT_0x12
	CALL _ki_mund
; 0000 05BD if (enter==0) {delay_ms(400);goto completed_test;}
	SBIC 0x13,0
	RJMP _0x3D8
	CALL SUBOPT_0x32
	RJMP _0x3B9
; 0000 05BE if (back==0) goto completed_test;
_0x3D8:
	SBIS 0x10,7
	RJMP _0x3B9
; 0000 05BF goto mundur_pelan;
	RJMP _0x3D6
; 0000 05C0 
; 0000 05C1 
; 0000 05C2 completed_test:
_0x3B9:
; 0000 05C3 
; 0000 05C4 delay_ms(200);
	CALL SUBOPT_0x47
; 0000 05C5 speed_ka=0;speed_ki=0;pwm_out();pwm_off();
	LDI  R30,LOW(0)
	STS  _speed_ka,R30
	STS  _speed_ka+1,R30
	STS  _speed_ki,R30
	STS  _speed_ki+1,R30
	CALL _pwm_out
	CALL _pwm_off
; 0000 05C6 delay_ms(200);
	CALL SUBOPT_0x47
; 0000 05C7 }
	RET
;
;void tampil_menu()
; 0000 05CA {
_tampil_menu:
; 0000 05CB 
; 0000 05CC menu=0;
	CLR  R4
; 0000 05CD for(;;)
_0x3DB:
; 0000 05CE     {
; 0000 05CF     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 05D0     lcd_clear();
	CALL _lcd_clear
; 0000 05D1     lcd_gotoxy(0,0);
	CALL SUBOPT_0x33
; 0000 05D2     if (adc_menu<=85)
	LDI  R30,LOW(85)
	CP   R30,R11
	BRLO _0x3DD
; 0000 05D3         {
; 0000 05D4         lcd_putsf("1. Speed ");
	__POINTW1FN _0x0,273
	CALL SUBOPT_0x34
; 0000 05D5         menu=1;
	LDI  R30,LOW(1)
	RJMP _0x470
; 0000 05D6         }
; 0000 05D7     else if (adc_menu<=170)
_0x3DD:
	LDI  R30,LOW(170)
	CP   R30,R11
	BRLO _0x3DF
; 0000 05D8         {
; 0000 05D9         lcd_putsf("2. Scan depan ");
	__POINTW1FN _0x0,283
	CALL SUBOPT_0x34
; 0000 05DA         menu=2;
	LDI  R30,LOW(2)
	RJMP _0x470
; 0000 05DB         }
; 0000 05DC     else if (adc_menu<=200)
_0x3DF:
	LDI  R30,LOW(200)
	CP   R30,R11
	BRLO _0x3E1
; 0000 05DD         {
; 0000 05DE         lcd_putsf("3. Scan belakang");
	__POINTW1FN _0x0,298
	CALL SUBOPT_0x34
; 0000 05DF         menu=3;
	LDI  R30,LOW(3)
	RJMP _0x470
; 0000 05E0         }
; 0000 05E1     else if (adc_menu<=255)
_0x3E1:
	LDI  R30,LOW(255)
	CP   R30,R11
	BRLO _0x3E3
; 0000 05E2         {
; 0000 05E3         lcd_putsf("4. Driver Test");
	__POINTW1FN _0x0,315
	CALL SUBOPT_0x34
; 0000 05E4         menu=4;
	LDI  R30,LOW(4)
_0x470:
	MOV  R4,R30
; 0000 05E5         }
; 0000 05E6 
; 0000 05E7     if(enter==0)
_0x3E3:
	SBIC 0x13,0
	RJMP _0x3E4
; 0000 05E8         {
; 0000 05E9         delay_ms(400);
	CALL SUBOPT_0x32
; 0000 05EA         if      (menu==2)
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x3E5
; 0000 05EB             {
; 0000 05EC             for(i=0;i<8;i++)
	CLR  R12
_0x3E7:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x3E8
; 0000 05ED                 {
; 0000 05EE                 min_adc1[i]=255;
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_min_adc1)
	SBCI R31,HIGH(-_min_adc1)
	LDI  R26,LOW(255)
	STD  Z+0,R26
; 0000 05EF                 max_adc1[i]=0;
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_max_adc1)
	SBCI R31,HIGH(-_max_adc1)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 05F0                 }
	INC  R12
	RJMP _0x3E7
_0x3E8:
; 0000 05F1             tampil_auto_set1();
	CALL _tampil_auto_set1
; 0000 05F2             }
; 0000 05F3 
; 0000 05F4         else if  (menu==3)
	RJMP _0x3E9
_0x3E5:
	LDI  R30,LOW(3)
	CP   R30,R4
	BRNE _0x3EA
; 0000 05F5             {
; 0000 05F6             for(i=0;i<8;i++)
	CLR  R12
_0x3EC:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x3ED
; 0000 05F7                 {
; 0000 05F8                 min_adc2[i]=255;
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_min_adc2)
	SBCI R31,HIGH(-_min_adc2)
	LDI  R26,LOW(255)
	STD  Z+0,R26
; 0000 05F9                 max_adc2[i]=0;
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_max_adc2)
	SBCI R31,HIGH(-_max_adc2)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 05FA                 }
	INC  R12
	RJMP _0x3EC
_0x3ED:
; 0000 05FB             tampil_auto_set2();
	RCALL _tampil_auto_set2
; 0000 05FC             }
; 0000 05FD 
; 0000 05FE          else if  (menu==4)
	RJMP _0x3EE
_0x3EA:
	LDI  R30,LOW(4)
	CP   R30,R4
	BRNE _0x3EF
; 0000 05FF             {
; 0000 0600             tes_driver();
	RCALL _tes_driver
; 0000 0601             }
; 0000 0602 
; 0000 0603         else if (menu==1)tampil_speed();
	RJMP _0x3F0
_0x3EF:
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x3F1
	RCALL _tampil_speed
; 0000 0604         }
_0x3F1:
_0x3F0:
_0x3EE:
_0x3E9:
; 0000 0605 
; 0000 0606     if(back==0)
_0x3E4:
	SBIC 0x10,7
	RJMP _0x3F2
; 0000 0607     {
; 0000 0608         i=0;
	CLR  R12
; 0000 0609         while(back==0){delay_ms(10);i++;if(i>200)i=200;}
_0x3F3:
	SBIC 0x10,7
	RJMP _0x3F5
	CALL SUBOPT_0x48
	BRSH _0x3F6
	LDI  R30,LOW(200)
	MOV  R12,R30
_0x3F6:
	RJMP _0x3F3
_0x3F5:
; 0000 060A         if(i>60)    {slave_menu();}
	LDI  R30,LOW(60)
	CP   R30,R12
	BRSH _0x3F7
	RCALL _slave_menu
; 0000 060B         else        {delay_ms(400);menu=0;break;}
	RJMP _0x3F8
_0x3F7:
	CALL SUBOPT_0x32
	CLR  R4
	RJMP _0x3DC
_0x3F8:
; 0000 060C         }
; 0000 060D     delay_ms(50);
_0x3F2:
	CALL SUBOPT_0x13
; 0000 060E     }
	RJMP _0x3DB
_0x3DC:
; 0000 060F }
	RET
;
;void tampil_siap()
; 0000 0612 {
_tampil_siap:
; 0000 0613 i=0;
	CLR  R12
; 0000 0614 n=0;
	LDI  R30,LOW(0)
	STS  _n,R30
; 0000 0615 
; 0000 0616 start:
_0x3F9:
; 0000 0617 for(;;)
; 0000 0618     {
; 0000 0619     lcd_clear();
	CALL _lcd_clear
; 0000 061A     i=0;
	CLR  R12
; 0000 061B     n=0;
	LDI  R30,LOW(0)
	STS  _n,R30
; 0000 061C     langkah=0;
	STS  _langkah,R30
	STS  _langkah+1,R30
; 0000 061D     langkah_kanan=0;
	STS  _langkah_kanan,R30
	STS  _langkah_kanan+1,R30
; 0000 061E     langkah_kiri=0;
	STS  _langkah_kiri,R30
	STS  _langkah_kiri+1,R30
; 0000 061F     per4an=0;
	STS  _per4an,R30
; 0000 0620     flag_siku=0;
	CLT
	BLD  R3,1
; 0000 0621     siku=0;
	STS  _siku,R30
; 0000 0622     flag_per4an=0;
	BLD  R3,0
; 0000 0623     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 0624     boleh_nos=0;
	CLR  R13
; 0000 0625     berhasil=0;
	CLT
	BLD  R2,7
; 0000 0626     status_error=0;
	BLD  R2,1
; 0000 0627     status_error_lalu=1;
	SET
	BLD  R2,0
; 0000 0628     temp_kp_div=kp_div;
	STS  _temp_kp_div,R7
; 0000 0629     /*
; 0000 062A     per4an_dir[1]=2;
; 0000 062B     per4an_dir[2]=1;
; 0000 062C     per4an_dir[3]=2;
; 0000 062D     per4an_dir [4]=0;
; 0000 062E     */
; 0000 062F     time=0;
	LDI  R30,LOW(0)
	STS  _time,R30
	STS  _time+1,R30
; 0000 0630 
; 0000 0631     //lcd_clear();
; 0000 0632     //lcd_gotoxy(0,0);
; 0000 0633     //lcd_putsf("RUN?");
; 0000 0634     speed=temp_speed;
	LDS  R30,_temp_speed
	LDS  R31,_temp_speed+1
	CALL SUBOPT_0x31
; 0000 0635 
; 0000 0636     lcd_gotoxy(0,1);
	CALL SUBOPT_0x35
; 0000 0637 
; 0000 0638     delay_ms(200);
	CALL SUBOPT_0x47
; 0000 0639     if(back==0){delay_ms(250);tampil_menu();goto start;}
	SBIC 0x10,7
	RJMP _0x3FD
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RCALL _tampil_menu
	RJMP _0x3F9
; 0000 063A     if(enter==0)
_0x3FD:
	SBIC 0x13,0
	RJMP _0x3FE
; 0000 063B         {
; 0000 063C         i=0;
	CLR  R12
; 0000 063D         while(enter==0){delay_ms(10);i++;if(i>200)i=200;}
_0x3FF:
	SBIC 0x13,0
	RJMP _0x401
	CALL SUBOPT_0x48
	BRSH _0x402
	LDI  R30,LOW(200)
	MOV  R12,R30
_0x402:
	RJMP _0x3FF
_0x401:
; 0000 063E         if(i>30)    {pwm_off();i_speed=50;action();goto start;}
	LDI  R30,LOW(30)
	CP   R30,R12
	BRSH _0x403
	CALL _pwm_off
	CALL SUBOPT_0x49
	RJMP _0x3F9
; 0000 063F         else        {pwm_on();i_speed=50;action();goto start;}
_0x403:
	CALL _pwm_on
	CALL SUBOPT_0x49
	RJMP _0x3F9
; 0000 0640         }
; 0000 0641 
; 0000 0642     lcd_clear();
_0x3FE:
	CALL _lcd_clear
; 0000 0643 
; 0000 0644     for(;;)
_0x406:
; 0000 0645     {
; 0000 0646 
; 0000 0647     adc_menu=read_adc(0);
	CALL SUBOPT_0x2E
; 0000 0648 
; 0000 0649       read_sensor();
	CALL _read_sensor
; 0000 064A      for(i=0;i<8;i++)
	CLR  R12
_0x409:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x40A
; 0000 064B         {
; 0000 064C         disp_sensor=0;
	CALL SUBOPT_0x7
; 0000 064D         disp_sensor=front_sensor>>i;
; 0000 064E         disp_sensor=(disp_sensor)&(0b00000001);
; 0000 064F         n=i;
; 0000 0650         lcd_gotoxy(n,0);
; 0000 0651         sprintf(lcd,"%d",disp_sensor);
; 0000 0652         lcd_puts(lcd);
; 0000 0653         }
	INC  R12
	RJMP _0x409
_0x40A:
; 0000 0654 
; 0000 0655     for(i=0;i<8;i++)
	CLR  R12
_0x40C:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x40D
; 0000 0656         {
; 0000 0657         disp_sensor=0;
	CALL SUBOPT_0x8
; 0000 0658         disp_sensor=rear_sensor>>i;
; 0000 0659         disp_sensor=(disp_sensor)&(0b00000001);
; 0000 065A         n=i;
; 0000 065B         lcd_gotoxy(n,1);
; 0000 065C         sprintf(lcd,"%d",disp_sensor);
; 0000 065D         lcd_puts(lcd);
; 0000 065E         }
	INC  R12
	RJMP _0x40C
_0x40D:
; 0000 065F     }
	RJMP _0x406
; 0000 0660 
; 0000 0661 }
; 0000 0662 }
;
;void main(void)
; 0000 0665 {
_main:
; 0000 0666 
; 0000 0667 pwm_off();
	CALL _pwm_off
; 0000 0668 
; 0000 0669 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 066A init_IO();
	CALL _init_IO
; 0000 066B init_ADC();
	CALL _init_ADC
; 0000 066C backlight=1;
	SBI  0x18,3
; 0000 066D led=0;
	CBI  0x15,7
; 0000 066E lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 066F lcd_putsf("Do-Car LPKTA");
	__POINTW1FN _0x0,330
	CALL SUBOPT_0x34
; 0000 0670 lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0671 lcd_putsf("TF FT UGM 2009");
	__POINTW1FN _0x0,343
	CALL SUBOPT_0x34
; 0000 0672 
; 0000 0673 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0674 led=1;
	CALL SUBOPT_0x1C
; 0000 0675 backlight=0;
; 0000 0676 delay_ms(200);
; 0000 0677 led=0;
; 0000 0678 backlight=1;
; 0000 0679 delay_ms(200);
; 0000 067A led=1;
; 0000 067B delay_ms(200);
; 0000 067C led=0;
; 0000 067D backlight=0;
; 0000 067E delay_ms(500);
; 0000 067F backlight=1;
; 0000 0680 led=1;
; 0000 0681 
; 0000 0682 temp_speed=speed   =e_speed;
	LDI  R26,LOW(_e_speed)
	LDI  R27,HIGH(_e_speed)
	CALL __EEPROMRDW
	CALL SUBOPT_0x31
	STS  _temp_speed,R30
	STS  _temp_speed+1,R31
; 0000 0683 min_kp  =e_min_kp;
	LDI  R26,LOW(_e_min_kp)
	LDI  R27,HIGH(_e_min_kp)
	CALL __EEPROMRDW
	STS  _min_kp,R30
	STS  _min_kp+1,R31
; 0000 0684 max_kp  =e_max_kp;
	LDI  R26,LOW(_e_max_kp)
	LDI  R27,HIGH(_e_max_kp)
	CALL __EEPROMRDW
	STS  _max_kp,R30
	STS  _max_kp+1,R31
; 0000 0685 per4an_enable=e_per4an_enable;
	LDI  R26,LOW(_e_per4an_enable)
	LDI  R27,HIGH(_e_per4an_enable)
	CALL __EEPROMRDB
	CALL __BSTB1
	BLD  R2,4
; 0000 0686 kp_div  =e_kp_div;
	LDI  R26,LOW(_e_kp_div)
	LDI  R27,HIGH(_e_kp_div)
	CALL __EEPROMRDB
	MOV  R7,R30
; 0000 0687 
; 0000 0688 fork_status=0; // 0 kiri, 1 kanan, 2 lurus
	LDI  R30,LOW(0)
	STS  _fork_status,R30
; 0000 0689 per4an=1;
	LDI  R30,LOW(1)
	STS  _per4an,R30
; 0000 068A e_per4an_enable=1;
	LDI  R26,LOW(_e_per4an_enable)
	LDI  R27,HIGH(_e_per4an_enable)
	CALL __EEPROMWRB
; 0000 068B 
; 0000 068C for(i=0;i<=10;i++)
	CLR  R12
_0x425:
	LDI  R30,LOW(10)
	CP   R30,R12
	BRLO _0x426
; 0000 068D {
; 0000 068E langkah_nos[i]=e_langkah_nos[i];
	MOV  R30,R12
	LDI  R26,LOW(_langkah_nos)
	LDI  R27,HIGH(_langkah_nos)
	CALL SUBOPT_0x4A
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R12
	LDI  R26,LOW(_e_langkah_nos)
	LDI  R27,HIGH(_e_langkah_nos)
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x4B
; 0000 068F langkah_cepat[i]=e_langkah_cepat[i];
	MOV  R30,R12
	LDI  R26,LOW(_langkah_cepat)
	LDI  R27,HIGH(_langkah_cepat)
	CALL SUBOPT_0x4A
	ADD  R30,R26
	ADC  R31,R27
	MOVW R0,R30
	MOV  R30,R12
	LDI  R26,LOW(_e_langkah_cepat)
	LDI  R27,HIGH(_e_langkah_cepat)
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x4B
; 0000 0690 }
	INC  R12
	RJMP _0x425
_0x426:
; 0000 0691 
; 0000 0692 
; 0000 0693 for(i=0;i<8;i++)
	CLR  R12
_0x428:
	LDI  R30,LOW(8)
	CP   R12,R30
	BRSH _0x429
; 0000 0694     {
; 0000 0695     adc_tres1[i]=e_adc_tres1[i];
	CALL SUBOPT_0x0
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2A
; 0000 0696     adc_tres2[i]=e_adc_tres2[i];
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x2C
; 0000 0697     }
	INC  R12
	RJMP _0x428
_0x429:
; 0000 0698 
; 0000 0699 while (1)
_0x42A:
; 0000 069A     {
; 0000 069B     tampil_siap();
	RCALL _tampil_siap
; 0000 069C     }
	RJMP _0x42A
; 0000 069D }
_0x42D:
	RJMP _0x42D
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
	CALL SUBOPT_0x1F
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x1F
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
	CALL SUBOPT_0x4C
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x4C
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
	CALL SUBOPT_0x4D
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x4E
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4F
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x4F
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
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x50
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
	CALL SUBOPT_0x4D
	CALL SUBOPT_0x50
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
	CALL SUBOPT_0x4C
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
	CALL SUBOPT_0x4C
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
	CALL SUBOPT_0x4E
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x4C
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
	CALL SUBOPT_0x4E
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
	CALL SUBOPT_0x51
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0003
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x51
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
_0x20C0003:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

	.CSEG

	.DSEG

	.CSEG
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G103:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G103
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G103:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G103
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G103
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G103
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x20C0001
__lcd_read_nibble_G103:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G103
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G103
    andi  r30,0xf0
	RET
_lcd_read_byte0_G103:
	CALL __lcd_delay_G103
	RCALL __lcd_read_nibble_G103
    mov   r26,r30
	RCALL __lcd_read_nibble_G103
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G103)
	SBCI R31,HIGH(-__base_y_G103)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2060004
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	RCALL _lcd_gotoxy
	brts __lcd_putchar0
_0x2060004:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	JMP  _0x20C0001
_lcd_puts:
	ST   -Y,R17
_0x2060005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2060007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2060005
_0x2060007:
	RJMP _0x20C0002
_lcd_putsf:
	ST   -Y,R17
_0x2060008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x206000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2060008
_0x206000A:
_0x20C0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G103:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G103:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G103
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x20C0001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G103,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G103,3
	CALL SUBOPT_0x52
	CALL SUBOPT_0x52
	CALL SUBOPT_0x52
	RCALL __long_delay_G103
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G103
	RCALL __long_delay_G103
	LDI  R30,LOW(40)
	CALL SUBOPT_0x53
	LDI  R30,LOW(4)
	CALL SUBOPT_0x53
	LDI  R30,LOW(133)
	CALL SUBOPT_0x53
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G103
	CPI  R30,LOW(0x5)
	BREQ _0x206000B
	LDI  R30,LOW(0)
	RJMP _0x20C0001
_0x206000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x20C0001:
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
_adc_result1:
	.BYTE 0x8
_adc_result2:
	.BYTE 0x8
_adc_tres1:
	.BYTE 0x8
_adc_tres2:
	.BYTE 0x8
_lcd:
	.BYTE 0x10
_max_adc1:
	.BYTE 0x8
_max_adc2:
	.BYTE 0x8
_min_adc1:
	.BYTE 0x8
_min_adc2:
	.BYTE 0x8
_langkah_cepat:
	.BYTE 0x14
_langkah_nos:
	.BYTE 0x14
_j:
	.BYTE 0x1
_n:
	.BYTE 0x1
_front_sensor:
	.BYTE 0x1
_rear_sensor:
	.BYTE 0x1
_disp_sensor:
	.BYTE 0x1
_backlight_on:
	.BYTE 0x1
_led_on:
	.BYTE 0x1
_right_back:
	.BYTE 0x1
_left_back:
	.BYTE 0x1
_i_speed:
	.BYTE 0x2
_speed:
	.BYTE 0x2
_MV:
	.BYTE 0x2
_error:
	.BYTE 0x2
_error_before:
	.BYTE 0x2
_d_d_error:
	.BYTE 0x2
_d_error:
	.BYTE 0x2
_min_kp:
	.BYTE 0x2
_max_kp:
	.BYTE 0x2
_kp:
	.BYTE 0x2
_kd:
	.BYTE 0x2
_speed_ka:
	.BYTE 0x2
_speed_ki:
	.BYTE 0x2
_temp_speed:
	.BYTE 0x2
_set_per4an:
	.BYTE 0x1
_per4an:
	.BYTE 0x1
_siku:
	.BYTE 0x1
_per4an_dir:
	.BYTE 0xB
_temp_kp_div:
	.BYTE 0x1
_time:
	.BYTE 0x2
_langkah_kanan:
	.BYTE 0x2
_langkah_kiri:
	.BYTE 0x2
_langkah:
	.BYTE 0x2

	.ESEG
_e_speed:
	.DW  0x82
_e_min_kp:
	.DW  0x8
_e_max_kp:
	.DW  0x1E
_e_adc_tres1:
	.DB  LOW(0x64646464),HIGH(0x64646464),BYTE3(0x64646464),BYTE4(0x64646464)
	.DB  LOW(0x64646464),HIGH(0x64646464),BYTE3(0x64646464),BYTE4(0x64646464)
_e_adc_tres2:
	.DB  LOW(0x64646464),HIGH(0x64646464),BYTE3(0x64646464),BYTE4(0x64646464)
	.DB  LOW(0x64646464),HIGH(0x64646464),BYTE3(0x64646464),BYTE4(0x64646464)
_e_kp_div:
	.DB  0x10
_e_per4an_dir:
	.DB  LOW(0x10202),HIGH(0x10202),BYTE3(0x10202),BYTE4(0x10202)
	.DB  LOW(0x2020100),HIGH(0x2020100),BYTE3(0x2020100),BYTE4(0x2020100)
	.DW  0x200
	.DB  0x0
_e_per4an_enable:
	.DB  0x1
_e_langkah_nos:
	.BYTE 0x14
_e_langkah_cepat:
	.BYTE 0x14

	.DSEG
_depan_kanan:
	.BYTE 0x1
_depan_kiri:
	.BYTE 0x1
_tadi_depan_kanan:
	.BYTE 0x1
_tadi_depan_kiri:
	.BYTE 0x1
_fork_status:
	.BYTE 0x1
_tadi_per4an:
	.BYTE 0x1
_sekarang:
	.BYTE 0x1
_tadi_white_line:
	.BYTE 0x1
_rear_sensor10:
	.BYTE 0x1
_rear_sensor11:
	.BYTE 0x1
_rear_sensor30:
	.BYTE 0x1
_rear_sensor31:
	.BYTE 0x1
__seed_G102:
	.BYTE 0x4
__base_y_G103:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0x0:
	MOV  R30,R12
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	MOVW R0,R30
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_adc_tres1)
	SBCI R31,HIGH(-_adc_tres1)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	MOVW R0,R30
	SUBI R30,LOW(-_adc_result2)
	SBCI R31,HIGH(-_adc_result2)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_adc_tres2)
	SBCI R31,HIGH(-_adc_tres2)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDS  R30,_speed_ka
	LDS  R31,_speed_ka+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x4:
	STS  _speed_ka,R30
	STS  _speed_ka+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDS  R30,_speed_ki
	LDS  R31,_speed_ki+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x6:
	STS  _speed_ki,R30
	STS  _speed_ki+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  _disp_sensor,R30
	LDS  R26,_front_sensor
	LDI  R27,0
	MOV  R30,R12
	CALL __ASRW12
	STS  _disp_sensor,R30
	ANDI R30,LOW(0x1)
	STS  _disp_sensor,R30
	STS  _n,R12
	LDS  R30,_n
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_disp_sensor
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(0)
	STS  _disp_sensor,R30
	LDS  R26,_rear_sensor
	LDI  R27,0
	MOV  R30,R12
	CALL __ASRW12
	STS  _disp_sensor,R30
	ANDI R30,LOW(0x1)
	STS  _disp_sensor,R30
	STS  _n,R12
	LDS  R30,_n
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	LDS  R30,_disp_sensor
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:107 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xA:
	LDS  R30,_error
	LDS  R31,_error+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0xB:
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:187 WORDS
SUBOPT_0xC:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0xD:
	CLR  R31
	CLR  R22
	CLR  R23
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:88 WORDS
SUBOPT_0xF:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(65436)
	LDI  R31,HIGH(65436)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:49 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x14:
	LDS  R26,_i_speed
	LDS  R27,_i_speed+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x15:
	LDS  R30,_front_sensor
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _error,R30
	STS  _error+1,R31
	CLT
	BLD  R2,6
	LDS  R26,_speed
	LDS  R27,_speed+1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21
	STS  _kp,R30
	STS  _kp+1,R31
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __MULW12
	STS  _kd,R30
	STS  _kd+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	STS  _error,R30
	STS  _error+1,R31
	CLT
	BLD  R2,6
	LDS  R26,_speed
	LDS  R27,_speed+1
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21
	STS  _kp,R30
	STS  _kp+1,R31
	LDI  R26,LOW(6)
	LDI  R27,HIGH(6)
	CALL __MULW12
	STS  _kd,R30
	STS  _kd+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	CALL __DIVW21
	STS  _kp,R30
	STS  _kp+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	CALL __MULW12
	STS  _kd,R30
	STS  _kd+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	LDS  R30,_speed
	LDS  R31,_speed+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	RCALL SUBOPT_0x4
	JMP  _pwm_out

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x1C:
	SBI  0x15,7
	CBI  0x18,3
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CBI  0x15,7
	SBI  0x18,3
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBI  0x15,7
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	CBI  0x15,7
	CBI  0x18,3
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	SBI  0x18,3
	SBI  0x15,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(65386)
	LDI  R31,HIGH(65386)
	RCALL SUBOPT_0x6
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RJMP SUBOPT_0x1B

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1E:
	__DELAY_USW 1400
	JMP  _read_sensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x21:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	LDS  R30,_front_sensor
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,11
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:42 WORDS
SUBOPT_0x23:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x24:
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x25:
	MOVW R0,R30
	SUBI R30,LOW(-_adc_result1)
	SBCI R31,HIGH(-_adc_result1)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_max_adc1)
	SBCI R31,HIGH(-_max_adc1)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x26:
	MOV  R26,R12
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x27:
	LD   R30,Z
	SUBI R30,-LOW(40)
	ST   X,R30
	__DELAY_USB 133
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x28:
	SUBI R30,LOW(-_adc_tres1)
	SBCI R31,HIGH(-_adc_tres1)
	LD   R30,Z
	CALL __EEPROMWRB
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x29:
	SUBI R30,LOW(-_adc_tres1)
	SBCI R31,HIGH(-_adc_tres1)
	MOVW R0,R30
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	SUBI R26,LOW(-_e_adc_tres1)
	SBCI R27,HIGH(-_e_adc_tres1)
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2B:
	SUBI R30,LOW(-_adc_tres2)
	SBCI R31,HIGH(-_adc_tres2)
	MOVW R0,R30
	RJMP SUBOPT_0x26

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	SUBI R26,LOW(-_e_adc_tres2)
	SBCI R27,HIGH(-_e_adc_tres2)
	CALL __EEPROMRDB
	MOVW R26,R0
	ST   X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2D:
	MOVW R0,R30
	SUBI R30,LOW(-_adc_result2)
	SBCI R31,HIGH(-_adc_result2)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_max_adc2)
	SBCI R31,HIGH(-_max_adc2)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _read_adc
	MOV  R11,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2F:
	MOV  R30,R11
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x30:
	LDI  R26,LOW(255)
	LDI  R27,HIGH(255)
	CALL __SWAPW12
	SUB  R30,R26
	SBC  R31,R27
	MOV  R11,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,40
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	LDI  R30,LOW(5)
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	STS  _speed,R30
	STS  _speed+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 41 TIMES, CODE SIZE REDUCTION:157 WORDS
SUBOPT_0x32:
	LDI  R30,LOW(400)
	LDI  R31,HIGH(400)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x33:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x34:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x35:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x36:
	__POINTW2MN _e_per4an_dir,1
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:69 WORDS
SUBOPT_0x37:
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
	__POINTW1FN _0x0,240
	RJMP SUBOPT_0x34

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x38:
	__POINTW2MN _e_per4an_dir,2
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	__POINTW2MN _e_per4an_dir,3
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3A:
	__POINTW2MN _e_per4an_dir,4
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3B:
	__POINTW2MN _e_per4an_dir,5
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3C:
	__POINTW2MN _e_per4an_dir,6
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	__POINTW2MN _e_per4an_dir,7
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	__POINTW2MN _e_per4an_dir,8
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	__POINTW2MN _e_per4an_dir,9
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x40:
	__POINTW2MN _e_per4an_dir,10
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x41:
	MOV  R26,R11
	LDI  R27,0
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	CALL _tampil_driver
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x43:
	RCALL SUBOPT_0x4
	JMP  _ka_maju

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	CALL _tampil_driver
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x45:
	CALL _tampil_driver
	LDI  R30,LOW(65281)
	LDI  R31,HIGH(65281)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x46:
	RCALL SUBOPT_0x6
	JMP  _ki_maju

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x47:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x48:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	INC  R12
	LDI  R30,LOW(200)
	CP   R30,R12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x49:
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	STS  _i_speed,R30
	STS  _i_speed+1,R31
	JMP  _action

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4A:
	LDI  R31,0
	LSL  R30
	ROL  R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4B:
	ADD  R26,R30
	ADC  R27,R31
	CALL __EEPROMRDW
	MOVW R26,R0
	ST   X+,R30
	ST   X,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4C:
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
SUBOPT_0x4D:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4E:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4F:
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
SUBOPT_0x50:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x51:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	CALL __long_delay_G103
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G103

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x53:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G103


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
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

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
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

__BSTB1:
	CLT
	TST  R30
	BREQ PC+2
	SET
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
