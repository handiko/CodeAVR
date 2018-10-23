
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega16
;Program type             : Application
;Clock frequency          : 8.000000 MHz
;Memory model             : Small
;Optimize for             : Size
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
	.DEF _sensor=R5
	.DEF _adc0=R4
	.DEF _adc1=R7
	.DEF _adc2=R6
	.DEF _adc3=R9
	.DEF _adc4=R8
	.DEF _adc5=R11
	.DEF _adc6=R10
	.DEF _adc7=R13
	.DEF _ba7=R12

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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x3:
	.DB  0x7
_0x4:
	.DB  0x7
_0x5:
	.DB  0x7
_0x6:
	.DB  0x7
_0x7:
	.DB  0x7
_0x8:
	.DB  0x7
_0x9:
	.DB  0x9
_0xA:
	.DB  0x7
_0xB:
	.DB  0x7
_0xC:
	.DB  0x7
_0xD:
	.DB  0x7
_0xE:
	.DB  0x7
_0xF:
	.DB  0x7
_0x10:
	.DB  0x7
_0x11:
	.DB  0x9
_0x12:
	.DB  0xFF
_0x1CF:
	.DB  0x7
_0x0:
	.DB  0x20,0x20,0x62,0x61,0x72,0x75,0x5F,0x62
	.DB  0x65,0x6C,0x61,0x6A,0x61,0x72,0x20,0x20
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x62
	.DB  0x79,0x20,0x3A,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x3F,0x3F,0x3F,0x3F,0x3F
	.DB  0x3F,0x3F,0x3F,0x3F,0x3F,0x3F,0x3F,0x3F
	.DB  0x3F,0x20,0x0,0x20,0x21,0x21,0x21,0x21
	.DB  0x21,0x21,0x21,0x21,0x21,0x21,0x21,0x21
	.DB  0x21,0x21,0x20,0x0,0x20,0x20,0x20,0x20
	.DB  0x20,0x4C,0x50,0x4B,0x54,0x41,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x46,0x54,0x20
	.DB  0x2D,0x20,0x55,0x47,0x4D,0x20,0x2D,0x20
	.DB  0x31,0x31,0x20,0x0,0x20,0x25,0x64,0x20
	.DB  0x25,0x64,0x0,0x54,0x75,0x6C,0x69,0x73
	.DB  0x20,0x6B,0x65,0x20,0x45,0x45,0x50,0x52
	.DB  0x4F,0x4D,0x20,0x0,0x2E,0x2E,0x2E,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x53,0x65,0x74
	.DB  0x20,0x4B,0x70,0x20,0x3A,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x53,0x65
	.DB  0x74,0x20,0x4B,0x69,0x20,0x3A,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x0,0x53
	.DB  0x65,0x74,0x20,0x4B,0x64,0x20,0x3A,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x53,0x65,0x74,0x20,0x4D,0x41,0x58,0x20
	.DB  0x53,0x70,0x65,0x65,0x64,0x20,0x3A,0x20
	.DB  0x0,0x53,0x65,0x74,0x20,0x4D,0x49,0x4E
	.DB  0x20,0x53,0x70,0x65,0x65,0x64,0x20,0x3A
	.DB  0x20,0x0,0x57,0x61,0x72,0x6E,0x61,0x20
	.DB  0x47,0x61,0x72,0x69,0x73,0x20,0x20,0x20
	.DB  0x3A,0x20,0x0,0x53,0x65,0x6E,0x73,0x4C
	.DB  0x69,0x6E,0x65,0x20,0x3A,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x53,0x6B,0x65,0x6E
	.DB  0x61,0x72,0x69,0x6F,0x20,0x3A,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x53
	.DB  0x65,0x74,0x20,0x50,0x49,0x44,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x53,0x65,0x74,0x20,0x53,0x70,0x65,0x65
	.DB  0x64,0x20,0x20,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x53,0x65,0x74,0x20,0x47,0x61,0x72
	.DB  0x69,0x73,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x53,0x6B,0x65,0x6E,0x61,0x72
	.DB  0x69,0x6F,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x20,0x53,0x65,0x74,0x20,0x4D
	.DB  0x6F,0x64,0x65,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x53
	.DB  0x74,0x61,0x72,0x74,0x21,0x21,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x4B
	.DB  0x70,0x20,0x20,0x20,0x4B,0x69,0x20,0x20
	.DB  0x20,0x4B,0x64,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x4D,0x41,0x58,0x20,0x20,0x20,0x20
	.DB  0x4D,0x49,0x4E,0x20,0x20,0x20,0x0,0x20
	.DB  0x20,0x57,0x41,0x52,0x4E,0x41,0x20,0x3A
	.DB  0x20,0x50,0x75,0x74,0x69,0x68,0x20,0x0
	.DB  0x20,0x20,0x57,0x41,0x52,0x4E,0x41,0x20
	.DB  0x3A,0x20,0x48,0x69,0x74,0x61,0x6D,0x20
	.DB  0x0,0x20,0x20,0x53,0x65,0x6E,0x73,0x4C
	.DB  0x20,0x3A,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x53,0x6B,0x65,0x6E,0x2E
	.DB  0x20,0x79,0x67,0x20,0x20,0x64,0x70,0x61
	.DB  0x6B,0x65,0x3A,0x0,0x20,0x4D,0x6F,0x64
	.DB  0x65,0x20,0x3A,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x31,0x2E
	.DB  0x4C,0x69,0x68,0x61,0x74,0x20,0x41,0x44
	.DB  0x43,0x0,0x20,0x32,0x2E,0x54,0x65,0x73
	.DB  0x74,0x20,0x4D,0x6F,0x64,0x65,0x0,0x20
	.DB  0x33,0x2E,0x43,0x65,0x6B,0x20,0x53,0x65
	.DB  0x6E,0x73,0x6F,0x72,0x20,0x0,0x20,0x34
	.DB  0x2E,0x41,0x75,0x74,0x6F,0x20,0x54,0x75
	.DB  0x6E,0x65,0x20,0x31,0x2D,0x31,0x0,0x20
	.DB  0x35,0x2E,0x41,0x75,0x74,0x6F,0x20,0x54
	.DB  0x75,0x6E,0x65,0x20,0x0,0x20,0x36,0x2E
	.DB  0x43,0x65,0x6B,0x20,0x50,0x57,0x4D,0x20
	.DB  0x41,0x6B,0x74,0x69,0x66,0x0,0x20,0x20
	.DB  0x25,0x64,0x20,0x25,0x64,0x20,0x25,0x64
	.DB  0x20,0x25,0x64,0x0,0x20,0x54,0x65,0x73
	.DB  0x74,0x3A,0x53,0x65,0x6E,0x73,0x6F,0x72
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x43,0x65
	.DB  0x6B,0x20,0x4D,0x65,0x6D,0x6F,0x72,0x79
	.DB  0x20,0x3F,0x0,0x20,0x59,0x20,0x2F,0x20
	.DB  0x4E,0x20,0x0,0x20,0x25,0x64,0x20,0x25
	.DB  0x64,0x20,0x25,0x64,0x20,0x25,0x64,0x20
	.DB  0x25,0x64,0x20,0x25,0x64,0x20,0x25,0x64
	.DB  0x20,0x25,0x64,0x0,0x20,0x62,0x62,0x30
	.DB  0x20,0x20,0x62,0x61,0x30,0x20,0x20,0x62
	.DB  0x74,0x30,0x0,0x20,0x25,0x64,0x20,0x20
	.DB  0x25,0x64,0x20,0x20,0x25,0x64,0x0,0x20
	.DB  0x62,0x62,0x31,0x20,0x20,0x62,0x61,0x31
	.DB  0x20,0x20,0x62,0x74,0x31,0x0,0x20,0x62
	.DB  0x62,0x32,0x20,0x20,0x62,0x61,0x32,0x20
	.DB  0x20,0x62,0x74,0x32,0x0,0x20,0x62,0x62
	.DB  0x33,0x20,0x20,0x62,0x61,0x33,0x20,0x20
	.DB  0x62,0x74,0x33,0x0,0x20,0x62,0x62,0x34
	.DB  0x20,0x20,0x62,0x61,0x34,0x20,0x20,0x62
	.DB  0x74,0x34,0x0,0x20,0x62,0x62,0x35,0x20
	.DB  0x20,0x62,0x61,0x35,0x20,0x20,0x62,0x74
	.DB  0x35,0x0,0x20,0x62,0x62,0x36,0x20,0x20
	.DB  0x62,0x61,0x36,0x20,0x20,0x62,0x74,0x36
	.DB  0x0,0x20,0x62,0x62,0x37,0x20,0x20,0x62
	.DB  0x61,0x37,0x20,0x20,0x62,0x74,0x37,0x0
	.DB  0x25,0x64,0x20,0x20,0x20,0x25,0x64,0x0
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x01
	.DW  _ba6
	.DW  _0x3*2

	.DW  0x01
	.DW  _ba5
	.DW  _0x4*2

	.DW  0x01
	.DW  _ba4
	.DW  _0x5*2

	.DW  0x01
	.DW  _ba3
	.DW  _0x6*2

	.DW  0x01
	.DW  _ba2
	.DW  _0x7*2

	.DW  0x01
	.DW  _ba1
	.DW  _0x8*2

	.DW  0x01
	.DW  _ba0
	.DW  _0x9*2

	.DW  0x01
	.DW  _bb7
	.DW  _0xA*2

	.DW  0x01
	.DW  _bb6
	.DW  _0xB*2

	.DW  0x01
	.DW  _bb5
	.DW  _0xC*2

	.DW  0x01
	.DW  _bb4
	.DW  _0xD*2

	.DW  0x01
	.DW  _bb3
	.DW  _0xE*2

	.DW  0x01
	.DW  _bb2
	.DW  _0xF*2

	.DW  0x01
	.DW  _bb1
	.DW  _0x10*2

	.DW  0x01
	.DW  _bb0
	.DW  _0x11*2

	.DW  0x01
	.DW  _MAXPWM
	.DW  _0x12*2

	.DW  0x01
	.DW  0x0C
	.DW  _0x1CF*2

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
;
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V1.25.3 Standard
;Automatic Program Generator
;© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 6/25/2008
;Author  : F4CG
;Company : F4CG
;Comments: test PID
;
;
;Chip type           : ATmega16
;Program type        : Application
;Clock frequency     : 12.000000 MHz
;Memory model        : Small
;External SRAM size  : 0
;Data Stack size     : 256
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
;#include <delay.h>
;#include <stdio.h>
;#include <lcd.h>
;
;#define sw_ok     PINC.0
;#define sw_cancel PINC.1
;#define sw_up     PINC.2
;#define sw_down   PINC.3
;
;#define Enki    PORTD.7
;#define kirplus PORTD.5
;#define kirmin  PORTD.4
;
;#define Enka    PORTD.6
;#define kaplus  PORTD.3
;#define kamin   PORTD.2
;
;#define ADC_VREF_TYPE 0x20
;
;#asm
   .equ __lcd_port=0x18 ;PORTB
; 0000 002F #endasm
;
;char lcd[16];
;unsigned char sensor, adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7;
;eeprom unsigned char bt7=7,bt6=7,bt5=7,bt4=7,bt3=7,bt2=7,bt1=7,bt0=9;
;unsigned char ba7=7,ba6=7,ba5=7,ba4=7,ba3=7,ba2=7,ba1=7,ba0=9;

	.DSEG
;unsigned char bb7=7,bb6=7,bb5=7,bb4=7,bb3=7,bb2=7,bb1=7,bb0=9;
;unsigned char xcount;
;bit s0,s1,s2,s3,s4,s5,s6,s7;
;int lpwm, rpwm, MAXPWM=255, MINPWM=0, intervalPWM;
;typedef unsigned char byte;
;int PV, error, last_error, d_error;
;int var_Kp, var_Ki, var_Kd;
;byte kursorPID, kursorSpeed, kursorGaris;
;char lcd_buffer[33];
;int b;
;int x;
;
;eeprom byte Kp = 10;
;eeprom byte Ki = 5;
;eeprom byte Kd = 7;
;eeprom byte MAXSpeed = 255;
;eeprom byte MINSpeed = 0;
;eeprom byte WarnaGaris = 0;     // 1 : putih, 0 : hitam
;eeprom byte SensLine = 2;       // banyaknya sensor dlm 1 garis
;eeprom byte Skenario = 2;
;eeprom byte Mode = 1;
;
;void showMenu();
;void displaySensorBit();
;void maju();
;void mundur();
;void bkan();
;void bkir();
;void rotkan();
;void rotkir();
;void stop();
;void ikuti_garis();
;void cek_sensor();
;void baca_sensor();
;void tune_batas();
;void auto_scan();
;void pemercepat();
;void pelambat();
;
;unsigned char read_adc(unsigned char adc_input)
; 0000 005D {

	.CSEG
_read_adc:
; 0000 005E     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 005F     delay_us(10);       // time sampling
	__DELAY_USB 27
; 0000 0060     ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0061     while ((ADCSRA & 0x10)==0);
_0x13:
	SBIS 0x6,4
	RJMP _0x13
; 0000 0062     ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0063     return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0064 }
;
;/*flash byte char0[8]=
;{
;    0b1100000,
;    0b0011000,
;    0b0000110,
;    0b1111111,
;    0b1111111,
;    0b0000110,
;    0b0011000,
;    0b1100000
;};/
;
;void define_char(byte flash *pc,byte char_code)
;{
;        byte i,a;
;        a=(char_code<<3) | 0x40;
;        for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
;}*/
;
;void main(void)
; 0000 007A {
_main:
; 0000 007B         PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 007C         DDRA=0x00;
	OUT  0x1A,R30
; 0000 007D 
; 0000 007E         PORTB=0x00;
	OUT  0x18,R30
; 0000 007F         DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0080 
; 0000 0081         PORTC=0x0F;
	LDI  R30,LOW(15)
	OUT  0x15,R30
; 0000 0082         DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0083 
; 0000 0084         PORTD=0x00;
	OUT  0x12,R30
; 0000 0085         DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0086 
; 0000 0087         TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0088 
; 0000 0089         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 008A         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 008B 
; 0000 008C         ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 008D         ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 008E 
; 0000 008F         lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0090 
; 0000 0091         TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0092         stop();
	RCALL _stop
; 0000 0093 
; 0000 0094         delay_ms(125);
	CALL SUBOPT_0x0
; 0000 0095         lcd_gotoxy(0,0);
; 0000 0096                 // 0123456789ABCDEF
; 0000 0097         lcd_putsf("  baru_belajar  ");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x1
; 0000 0098         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0099         lcd_putsf("      by :      ");
	__POINTW1FN _0x0,17
	CALL SUBOPT_0x1
; 0000 009A         delay_ms(500);
	CALL SUBOPT_0x3
; 0000 009B         lcd_clear();
; 0000 009C 
; 0000 009D         delay_ms(125);
	CALL SUBOPT_0x0
; 0000 009E         lcd_gotoxy(0,0);
; 0000 009F                 // 0123456789ABCDEF
; 0000 00A0         lcd_putsf(" ?????????????? ");
	__POINTW1FN _0x0,34
	CALL SUBOPT_0x1
; 0000 00A1         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 00A2         lcd_putsf(" !!!!!!!!!!!!!! ");
	__POINTW1FN _0x0,51
	CALL SUBOPT_0x1
; 0000 00A3         delay_ms(1300);
	LDI  R30,LOW(1300)
	LDI  R31,HIGH(1300)
	CALL SUBOPT_0x4
; 0000 00A4         lcd_clear();
	CALL _lcd_clear
; 0000 00A5 
; 0000 00A6         delay_ms(125);
	CALL SUBOPT_0x0
; 0000 00A7         lcd_gotoxy(0,0);
; 0000 00A8                 // 0123456789ABCDEF
; 0000 00A9         lcd_putsf("     LPKTA     ");
	__POINTW1FN _0x0,68
	CALL SUBOPT_0x1
; 0000 00AA         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 00AB         lcd_putsf(" FT - UGM - 11 ");
	__POINTW1FN _0x0,84
	CALL SUBOPT_0x1
; 0000 00AC         delay_ms(500);
	CALL SUBOPT_0x3
; 0000 00AD         lcd_clear();
; 0000 00AE 
; 0000 00AF         TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00B0         #asm("sei")
	sei
; 0000 00B1 
; 0000 00B2         mundur();
	RCALL _mundur
; 0000 00B3         delay_ms(200);
	CALL SUBOPT_0x5
; 0000 00B4         stop();
	RCALL _stop
; 0000 00B5         var_Kp  = Kp;
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL SUBOPT_0x6
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
; 0000 00B6         var_Ki  = Ki;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL SUBOPT_0x6
	STS  _var_Ki,R30
	STS  _var_Ki+1,R31
; 0000 00B7         var_Kd  = Kd;
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL SUBOPT_0x6
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
; 0000 00B8         MAXPWM  = (int)MAXSpeed + 1;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL SUBOPT_0x6
	ADIW R30,1
	STS  _MAXPWM,R30
	STS  _MAXPWM+1,R31
; 0000 00B9         MINPWM  = MINSpeed;
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x6
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
; 0000 00BA 
; 0000 00BB         intervalPWM = (MAXSpeed - MINSpeed) / 8;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL __EEPROMRDB
	MOV  R0,R30
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL __EEPROMRDB
	MOV  R26,R0
	SUB  R26,R30
	MOV  R30,R26
	LSR  R30
	LSR  R30
	LSR  R30
	LDI  R31,0
	STS  _intervalPWM,R30
	STS  _intervalPWM+1,R31
; 0000 00BC         PV = 0;
	LDI  R30,LOW(0)
	STS  _PV,R30
	STS  _PV+1,R30
; 0000 00BD         error = 0;
	STS  _error,R30
	STS  _error+1,R30
; 0000 00BE         last_error = 0;
	STS  _last_error,R30
	STS  _last_error+1,R30
; 0000 00BF 
; 0000 00C0         showMenu();
	RCALL _showMenu
; 0000 00C1         maju();
	RCALL _maju
; 0000 00C2         displaySensorBit();
	RCALL _displaySensorBit
; 0000 00C3         while (1)
_0x16:
; 0000 00C4         {
; 0000 00C5                 displaySensorBit();
	RCALL _displaySensorBit
; 0000 00C6                 ikuti_garis();
	CALL _ikuti_garis
; 0000 00C7                 //maju();
; 0000 00C8                 //lpwm = 255;
; 0000 00C9                 //rpwm = 255;
; 0000 00CA         };
	RJMP _0x16
; 0000 00CB }
_0x19:
	RJMP _0x19
;
;void pemercepat()
; 0000 00CE {
_pemercepat:
; 0000 00CF         TCCR0 = 0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00D0         lpwm=0;
	LDI  R30,LOW(0)
	CALL SUBOPT_0x7
; 0000 00D1         rpwm=0;
; 0000 00D2 
; 0000 00D3         rotkir();
	RCALL _rotkir
; 0000 00D4 
; 0000 00D5         for(b=0;b<255;b++)
	LDI  R30,LOW(0)
	STS  _b,R30
	STS  _b+1,R30
_0x1B:
	CALL SUBOPT_0x8
	BRGE _0x1C
; 0000 00D6         {
; 0000 00D7                 delay_ms(125);
	CALL SUBOPT_0x9
; 0000 00D8 
; 0000 00D9                 lpwm++;
	LDI  R26,LOW(_lpwm)
	LDI  R27,HIGH(_lpwm)
	CALL SUBOPT_0xA
; 0000 00DA                 rpwm++;
	LDI  R26,LOW(_rpwm)
	LDI  R27,HIGH(_rpwm)
	CALL SUBOPT_0xA
; 0000 00DB 
; 0000 00DC                 lcd_clear();
	CALL SUBOPT_0xB
; 0000 00DD 
; 0000 00DE                 lcd_gotoxy(0,0);
; 0000 00DF                 sprintf(lcd," %d %d",lpwm,rpwm);
; 0000 00E0                 lcd_puts(lcd);
; 0000 00E1         }
	LDI  R26,LOW(_b)
	LDI  R27,HIGH(_b)
	CALL SUBOPT_0xA
	RJMP _0x1B
_0x1C:
; 0000 00E2         lpwm=0;
	RJMP _0x2080008
; 0000 00E3         rpwm=0;
; 0000 00E4 }
;
;void pelambat()
; 0000 00E7 {
_pelambat:
; 0000 00E8         TCCR0 = 0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 00E9         lpwm=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0xC
; 0000 00EA         rpwm=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0xD
; 0000 00EB 
; 0000 00EC         rotkan();
	RCALL _rotkan
; 0000 00ED 
; 0000 00EE         for(b=0;b<255;b++)
	LDI  R30,LOW(0)
	STS  _b,R30
	STS  _b+1,R30
_0x1E:
	CALL SUBOPT_0x8
	BRGE _0x1F
; 0000 00EF         {
; 0000 00F0                 delay_ms(125);
	CALL SUBOPT_0x9
; 0000 00F1 
; 0000 00F2                 lpwm--;
	LDI  R26,LOW(_lpwm)
	LDI  R27,HIGH(_lpwm)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00F3                 rpwm--;
	LDI  R26,LOW(_rpwm)
	LDI  R27,HIGH(_rpwm)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 00F4 
; 0000 00F5                 lcd_clear();
	CALL SUBOPT_0xB
; 0000 00F6 
; 0000 00F7                 lcd_gotoxy(0,0);
; 0000 00F8                 sprintf(lcd," %d %d",lpwm,rpwm);
; 0000 00F9                 lcd_puts(lcd);
; 0000 00FA         }
	LDI  R26,LOW(_b)
	LDI  R27,HIGH(_b)
	CALL SUBOPT_0xA
	RJMP _0x1E
_0x1F:
; 0000 00FB         lpwm=0;
_0x2080008:
	LDI  R30,LOW(0)
	CALL SUBOPT_0x7
; 0000 00FC         rpwm=0;
; 0000 00FD }
	RET
;
;void baca_sensor()
; 0000 0100 {
_baca_sensor:
; 0000 0101         sensor=0;
	CLR  R5
; 0000 0102         adc0=read_adc(0);
	CALL SUBOPT_0xE
	MOV  R4,R30
; 0000 0103         adc1=read_adc(1);
	CALL SUBOPT_0xF
	MOV  R7,R30
; 0000 0104         adc2=read_adc(2);
	CALL SUBOPT_0x10
	MOV  R6,R30
; 0000 0105         adc3=read_adc(3);
	CALL SUBOPT_0x11
	MOV  R9,R30
; 0000 0106         adc4=read_adc(4);
	CALL SUBOPT_0x12
	MOV  R8,R30
; 0000 0107         adc5=read_adc(5);
	CALL SUBOPT_0x13
	MOV  R11,R30
; 0000 0108         adc6=read_adc(6);
	CALL SUBOPT_0x14
	MOV  R10,R30
; 0000 0109         adc7=read_adc(7);
	CALL SUBOPT_0x15
	MOV  R13,R30
; 0000 010A 
; 0000 010B         if(adc0>bt0){s0=1;sensor=sensor|1<<0;}
	CALL SUBOPT_0x16
	CP   R30,R4
	BRSH _0x20
	SET
	BLD  R2,0
	LDI  R30,LOW(1)
	RJMP _0x1AD
; 0000 010C         else {s0=0;sensor=sensor|0<<0;}
_0x20:
	CLT
	BLD  R2,0
	LDI  R30,LOW(0)
_0x1AD:
	OR   R5,R30
; 0000 010D 
; 0000 010E         if(adc1>bt1){s1=1;sensor=sensor|1<<1;}
	CALL SUBOPT_0x17
	CP   R30,R7
	BRSH _0x22
	SET
	BLD  R2,1
	LDI  R30,LOW(2)
	RJMP _0x1AE
; 0000 010F         else {s1=0;sensor=sensor|0<<1;}
_0x22:
	CLT
	BLD  R2,1
	LDI  R30,LOW(0)
_0x1AE:
	OR   R5,R30
; 0000 0110 
; 0000 0111         if(adc2>bt2){s2=1;sensor=sensor|1<<2;}
	CALL SUBOPT_0x18
	CP   R30,R6
	BRSH _0x24
	SET
	BLD  R2,2
	LDI  R30,LOW(4)
	RJMP _0x1AF
; 0000 0112         else {s2=0;sensor=sensor|0<<2;}
_0x24:
	CLT
	BLD  R2,2
	LDI  R30,LOW(0)
_0x1AF:
	OR   R5,R30
; 0000 0113 
; 0000 0114         if(adc3>bt3){s3=1;sensor=sensor|1<<3;}
	CALL SUBOPT_0x19
	CP   R30,R9
	BRSH _0x26
	SET
	BLD  R2,3
	LDI  R30,LOW(8)
	RJMP _0x1B0
; 0000 0115         else {s3=0;sensor=sensor|0<<3;}
_0x26:
	CLT
	BLD  R2,3
	LDI  R30,LOW(0)
_0x1B0:
	OR   R5,R30
; 0000 0116 
; 0000 0117         if(adc4>bt4){s4=1;sensor=sensor|1<<4;}
	CALL SUBOPT_0x1A
	CP   R30,R8
	BRSH _0x28
	SET
	BLD  R2,4
	LDI  R30,LOW(16)
	RJMP _0x1B1
; 0000 0118         else {s4=0;sensor=sensor|0<<4;}
_0x28:
	CLT
	BLD  R2,4
	LDI  R30,LOW(0)
_0x1B1:
	OR   R5,R30
; 0000 0119 
; 0000 011A         if(adc5>bt5){s5=1;sensor=sensor|1<<5;}
	CALL SUBOPT_0x1B
	CP   R30,R11
	BRSH _0x2A
	SET
	BLD  R2,5
	LDI  R30,LOW(32)
	RJMP _0x1B2
; 0000 011B         else {s5=0;sensor=sensor|0<<5;}
_0x2A:
	CLT
	BLD  R2,5
	LDI  R30,LOW(0)
_0x1B2:
	OR   R5,R30
; 0000 011C 
; 0000 011D         if(adc6>bt6){s6=1;sensor=sensor|1<<6;}
	CALL SUBOPT_0x1C
	CP   R30,R10
	BRSH _0x2C
	SET
	BLD  R2,6
	LDI  R30,LOW(64)
	RJMP _0x1B3
; 0000 011E         else {s6=0;sensor=sensor|0<<6;}
_0x2C:
	CLT
	BLD  R2,6
	LDI  R30,LOW(0)
_0x1B3:
	OR   R5,R30
; 0000 011F 
; 0000 0120         if(adc7>bt7){s7=1;sensor=sensor|1<<7;}
	CALL SUBOPT_0x1D
	CP   R30,R13
	BRSH _0x2E
	SET
	BLD  R2,7
	LDI  R30,LOW(128)
	RJMP _0x1B4
; 0000 0121         else {s7=0;sensor=sensor|0<<7;}
_0x2E:
	CLT
	BLD  R2,7
	LDI  R30,LOW(0)
_0x1B4:
	OR   R5,R30
; 0000 0122 }
	RET
;
;void tampil(unsigned char dat)
; 0000 0125 {
_tampil:
; 0000 0126     unsigned char data;
; 0000 0127 
; 0000 0128     data = dat / 100;
	ST   -Y,R17
;	dat -> Y+1
;	data -> R17
	LDD  R26,Y+1
	LDI  R30,LOW(100)
	CALL SUBOPT_0x1E
; 0000 0129     data+=0x30;
; 0000 012A     lcd_putchar(data);
; 0000 012B 
; 0000 012C     dat%=100;
	LDI  R30,LOW(100)
	CALL __MODB21U
	STD  Y+1,R30
; 0000 012D     data = dat / 10;
	LDD  R26,Y+1
	LDI  R30,LOW(10)
	CALL SUBOPT_0x1E
; 0000 012E     data+=0x30;
; 0000 012F     lcd_putchar(data);
; 0000 0130 
; 0000 0131     dat%=10;
	LDI  R30,LOW(10)
	CALL __MODB21U
	STD  Y+1,R30
; 0000 0132     data = dat + 0x30;
	SUBI R30,-LOW(48)
	MOV  R17,R30
; 0000 0133     lcd_putchar(data);
	ST   -Y,R17
	CALL _lcd_putchar
; 0000 0134 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom )
; 0000 0137 {
_tulisKeEEPROM:
; 0000 0138         lcd_gotoxy(0,0);
;	NoMenu -> Y+2
;	NoSubMenu -> Y+1
;	var_in_eeprom -> Y+0
	CALL SUBOPT_0x1F
; 0000 0139         lcd_putsf("Tulis ke EEPROM ");
	__POINTW1FN _0x0,107
	CALL SUBOPT_0x1
; 0000 013A         lcd_putsf("...             ");
	__POINTW1FN _0x0,124
	CALL SUBOPT_0x1
; 0000 013B         switch (NoMenu)
	LDD  R30,Y+2
; 0000 013C         {
; 0000 013D           case 1: // PID
	CPI  R30,LOW(0x1)
	BRNE _0x33
; 0000 013E                 switch (NoSubMenu)
	LDD  R30,Y+1
; 0000 013F                 {
; 0000 0140                   case 1: // Kp
	CPI  R30,LOW(0x1)
	BRNE _0x37
; 0000 0141                         Kp = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	RJMP _0x1B5
; 0000 0142                         break;
; 0000 0143                   case 2: // Ki
_0x37:
	CPI  R30,LOW(0x2)
	BRNE _0x38
; 0000 0144                         Ki = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	RJMP _0x1B5
; 0000 0145                         break;
; 0000 0146                   case 3: // Kd
_0x38:
	CPI  R30,LOW(0x3)
	BRNE _0x36
; 0000 0147                         Kd = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
_0x1B5:
	CALL __EEPROMWRB
; 0000 0148                         break;
; 0000 0149                 }
_0x36:
; 0000 014A                 break;
	RJMP _0x32
; 0000 014B           case 2: // Speed
_0x33:
	CPI  R30,LOW(0x2)
	BRNE _0x3A
; 0000 014C                 switch (NoSubMenu)
	LDD  R30,Y+1
; 0000 014D                 {
; 0000 014E                   case 1: // MAX
	CPI  R30,LOW(0x1)
	BRNE _0x3E
; 0000 014F                         MAXSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	RJMP _0x1B6
; 0000 0150                         break;
; 0000 0151                   case 2: // MIN
_0x3E:
	CPI  R30,LOW(0x2)
	BRNE _0x3D
; 0000 0152                         MINSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
_0x1B6:
	CALL __EEPROMWRB
; 0000 0153                         break;
; 0000 0154                 }
_0x3D:
; 0000 0155                 break;
	RJMP _0x32
; 0000 0156           case 3: // Warna Garis
_0x3A:
	CPI  R30,LOW(0x3)
	BRNE _0x40
; 0000 0157                 switch (NoSubMenu)
	LDD  R30,Y+1
; 0000 0158                 {
; 0000 0159                   case 1: // Warna
	CPI  R30,LOW(0x1)
	BRNE _0x44
; 0000 015A                         WarnaGaris = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	RJMP _0x1B7
; 0000 015B                         break;
; 0000 015C                   case 2: // SensL
_0x44:
	CPI  R30,LOW(0x2)
	BRNE _0x43
; 0000 015D                         SensLine = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
_0x1B7:
	CALL __EEPROMWRB
; 0000 015E                         break;
; 0000 015F                 }
_0x43:
; 0000 0160                 break;
	RJMP _0x32
; 0000 0161           case 4: // Skenario
_0x40:
	CPI  R30,LOW(0x4)
	BRNE _0x32
; 0000 0162                 Skenario = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMWRB
; 0000 0163                 break;
; 0000 0164         }
_0x32:
; 0000 0165         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x4
; 0000 0166 }
	ADIW R28,3
	RET
;
;void setByte( byte NoMenu, byte NoSubMenu )
; 0000 0169 {
_setByte:
; 0000 016A         byte var_in_eeprom;
; 0000 016B         byte plus5 = 0;
; 0000 016C         char limitPilih = -1;
; 0000 016D 
; 0000 016E         lcd_clear();
	CALL __SAVELOCR4
;	NoMenu -> Y+5
;	NoSubMenu -> Y+4
;	var_in_eeprom -> R17
;	plus5 -> R16
;	limitPilih -> R19
	LDI  R16,0
	LDI  R19,255
	CALL SUBOPT_0x20
; 0000 016F         lcd_gotoxy(0, 0);
; 0000 0170         switch (NoMenu)
	LDD  R30,Y+5
; 0000 0171         {
; 0000 0172           case 1: // PID
	CPI  R30,LOW(0x1)
	BRNE _0x4A
; 0000 0173                 switch (NoSubMenu)
	LDD  R30,Y+4
; 0000 0174                 {
; 0000 0175                   case 1: // Kp
	CPI  R30,LOW(0x1)
	BRNE _0x4E
; 0000 0176                         lcd_putsf("Set Kp :        ");
	__POINTW1FN _0x0,141
	CALL SUBOPT_0x1
; 0000 0177                         var_in_eeprom = Kp;
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	RJMP _0x1B8
; 0000 0178                         break;
; 0000 0179                   case 2: // Ki
_0x4E:
	CPI  R30,LOW(0x2)
	BRNE _0x4F
; 0000 017A                         lcd_putsf("Set Ki :        ");
	__POINTW1FN _0x0,158
	CALL SUBOPT_0x1
; 0000 017B                         var_in_eeprom = Ki;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	RJMP _0x1B8
; 0000 017C                         break;
; 0000 017D                   case 3: // Kd
_0x4F:
	CPI  R30,LOW(0x3)
	BRNE _0x4D
; 0000 017E                         lcd_putsf("Set Kd :        ");
	__POINTW1FN _0x0,175
	CALL SUBOPT_0x1
; 0000 017F                         var_in_eeprom = Kd;
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
_0x1B8:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 0180                         break;
; 0000 0181                 }
_0x4D:
; 0000 0182                 break;
	RJMP _0x49
; 0000 0183           case 2: // Speed
_0x4A:
	CPI  R30,LOW(0x2)
	BRNE _0x51
; 0000 0184                 plus5 = 1;
	LDI  R16,LOW(1)
; 0000 0185                 switch (NoSubMenu)
	LDD  R30,Y+4
; 0000 0186                 {
; 0000 0187                   case 1: // MAX
	CPI  R30,LOW(0x1)
	BRNE _0x55
; 0000 0188                         lcd_putsf("Set MAX Speed : ");
	__POINTW1FN _0x0,192
	CALL SUBOPT_0x1
; 0000 0189                         var_in_eeprom = MAXSpeed;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	RJMP _0x1B9
; 0000 018A                         break;
; 0000 018B                   case 2: // MIN
_0x55:
	CPI  R30,LOW(0x2)
	BRNE _0x54
; 0000 018C                         lcd_putsf("Set MIN Speed : ");
	__POINTW1FN _0x0,209
	CALL SUBOPT_0x1
; 0000 018D                         var_in_eeprom = MINSpeed;
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
_0x1B9:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 018E                         break;
; 0000 018F                 }
_0x54:
; 0000 0190                 break;
	RJMP _0x49
; 0000 0191           case 3: // Warna Garis
_0x51:
	CPI  R30,LOW(0x3)
	BRNE _0x57
; 0000 0192                 switch (NoSubMenu)
	LDD  R30,Y+4
; 0000 0193                 {
; 0000 0194                   case 1: // Warna
	CPI  R30,LOW(0x1)
	BRNE _0x5B
; 0000 0195                         limitPilih = 1;
	LDI  R19,LOW(1)
; 0000 0196                         lcd_putsf("Warna Garis   : ");
	__POINTW1FN _0x0,226
	CALL SUBOPT_0x1
; 0000 0197                         var_in_eeprom = WarnaGaris;
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	RJMP _0x1BA
; 0000 0198                         break;
; 0000 0199                   case 2: // SensL
_0x5B:
	CPI  R30,LOW(0x2)
	BRNE _0x5A
; 0000 019A                         limitPilih = 3;
	LDI  R19,LOW(3)
; 0000 019B                         lcd_putsf("SensLine :      ");
	__POINTW1FN _0x0,243
	CALL SUBOPT_0x1
; 0000 019C                         var_in_eeprom = SensLine;
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
_0x1BA:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 019D                         break;
; 0000 019E                 }
_0x5A:
; 0000 019F                 break;
	RJMP _0x49
; 0000 01A0           case 4: // Skenario
_0x57:
	CPI  R30,LOW(0x4)
	BRNE _0x49
; 0000 01A1                   lcd_putsf("Skenario :      ");
	__POINTW1FN _0x0,260
	CALL SUBOPT_0x1
; 0000 01A2                   var_in_eeprom = Skenario;
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 01A3                   limitPilih = 8;
	LDI  R19,LOW(8)
; 0000 01A4                   break;
; 0000 01A5         }
_0x49:
; 0000 01A6 
; 0000 01A7         while (sw_cancel)
_0x5E:
	SBIS 0x13,1
	RJMP _0x60
; 0000 01A8         {
; 0000 01A9                 delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x4
; 0000 01AA                 lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
; 0000 01AB                 tampil(var_in_eeprom);
	ST   -Y,R17
	RCALL _tampil
; 0000 01AC 
; 0000 01AD                 if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x61
; 0000 01AE                 {
; 0000 01AF                         lcd_clear();
	CALL _lcd_clear
; 0000 01B0                         tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R17
	RCALL _tulisKeEEPROM
; 0000 01B1                         goto exitSetByte;
	RJMP _0x62
; 0000 01B2                 }
; 0000 01B3                 if (!sw_down)
_0x61:
	SBIC 0x13,3
	RJMP _0x63
; 0000 01B4                 {
; 0000 01B5                         if ( plus5 )
	CPI  R16,0
	BREQ _0x64
; 0000 01B6                                 if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x65
; 0000 01B7                                         var_in_eeprom = 255;
	LDI  R17,LOW(255)
; 0000 01B8                                 else
	RJMP _0x66
_0x65:
; 0000 01B9                                         var_in_eeprom -= 5;
	SUBI R17,LOW(5)
; 0000 01BA                         else
_0x66:
	RJMP _0x67
_0x64:
; 0000 01BB                                 if ( !limitPilih )
	CPI  R19,0
	BREQ _0x1BB
; 0000 01BC                                         var_in_eeprom--;
; 0000 01BD                                 else
; 0000 01BE                                 {
; 0000 01BF                                         if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x6A
; 0000 01C0                                           var_in_eeprom = limitPilih;
	MOV  R17,R19
; 0000 01C1                                         else
	RJMP _0x6B
_0x6A:
; 0000 01C2                                           var_in_eeprom--;
_0x1BB:
	SUBI R17,1
; 0000 01C3                                 }
_0x6B:
_0x67:
; 0000 01C4                 }
; 0000 01C5                 if (!sw_up)
_0x63:
	SBIC 0x13,2
	RJMP _0x6C
; 0000 01C6                 {
; 0000 01C7                         if ( plus5 )
	CPI  R16,0
	BREQ _0x6D
; 0000 01C8                                 if ( var_in_eeprom == 255 )
	CPI  R17,255
	BRNE _0x6E
; 0000 01C9                                         var_in_eeprom = 0;
	LDI  R17,LOW(0)
; 0000 01CA                                 else
	RJMP _0x6F
_0x6E:
; 0000 01CB                                         var_in_eeprom += 5;
	SUBI R17,-LOW(5)
; 0000 01CC                         else
_0x6F:
	RJMP _0x70
_0x6D:
; 0000 01CD                                 if ( !limitPilih )
	CPI  R19,0
	BREQ _0x1BC
; 0000 01CE                                         var_in_eeprom++;
; 0000 01CF                                 else
; 0000 01D0                                 {
; 0000 01D1                                         if ( var_in_eeprom == limitPilih )
	CP   R19,R17
	BRNE _0x73
; 0000 01D2                                           var_in_eeprom = 0;
	LDI  R17,LOW(0)
; 0000 01D3                                         else
	RJMP _0x74
_0x73:
; 0000 01D4                                           var_in_eeprom++;
_0x1BC:
	SUBI R17,-1
; 0000 01D5                                 }
_0x74:
_0x70:
; 0000 01D6                 }
; 0000 01D7         }
_0x6C:
	RJMP _0x5E
_0x60:
; 0000 01D8       exitSetByte:
_0x62:
; 0000 01D9         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
; 0000 01DA         lcd_clear();
	CALL _lcd_clear
; 0000 01DB }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;void showMenu()
; 0000 01DE {
_showMenu:
; 0000 01DF         //TIMSK = 0x00;
; 0000 01E0         //#asm("cli")
; 0000 01E1         lcd_clear();
	CALL _lcd_clear
; 0000 01E2     menu01:
_0x75:
; 0000 01E3         delay_ms(225);   // bouncing sw
	CALL SUBOPT_0x21
; 0000 01E4         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 01E5                 // 0123456789abcdef
; 0000 01E6         lcd_putsf("  Set PID       ");
	__POINTW1FN _0x0,277
	CALL SUBOPT_0x1
; 0000 01E7         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 01E8         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0x0,294
	CALL SUBOPT_0x1
; 0000 01E9 
; 0000 01EA         // kursor awal
; 0000 01EB         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 01EC         lcd_putchar(0);
	CALL SUBOPT_0x22
; 0000 01ED 
; 0000 01EE         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x76
; 0000 01EF         {
; 0000 01F0                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 01F1                 lcd_clear();
	CALL _lcd_clear
; 0000 01F2                 kursorPID = 1;
	LDI  R30,LOW(1)
	STS  _kursorPID,R30
; 0000 01F3                 goto setPID;
	RJMP _0x77
; 0000 01F4         }
; 0000 01F5         if (!sw_down)
_0x76:
	SBIC 0x13,3
	RJMP _0x78
; 0000 01F6         {
; 0000 01F7                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 01F8                 goto menu02;
	RJMP _0x79
; 0000 01F9         }
; 0000 01FA         if (!sw_up)
_0x78:
	SBIC 0x13,2
	RJMP _0x7A
; 0000 01FB         {
; 0000 01FC                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 01FD                 lcd_clear();
	CALL _lcd_clear
; 0000 01FE                 goto menu06;
	RJMP _0x7B
; 0000 01FF         }
; 0000 0200 
; 0000 0201         goto menu01;
_0x7A:
	RJMP _0x75
; 0000 0202     menu02:
_0x79:
; 0000 0203         delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0204         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 0205                  // 0123456789abcdef
; 0000 0206         lcd_putsf("  Set PID       ");
	__POINTW1FN _0x0,277
	CALL SUBOPT_0x1
; 0000 0207         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0208         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0x0,294
	CALL SUBOPT_0x1
; 0000 0209 
; 0000 020A         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 020B         lcd_putchar(0);
	CALL SUBOPT_0x22
; 0000 020C 
; 0000 020D         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x7C
; 0000 020E         {
; 0000 020F                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0210                 lcd_clear();
	CALL _lcd_clear
; 0000 0211                 kursorSpeed = 1;
	LDI  R30,LOW(1)
	STS  _kursorSpeed,R30
; 0000 0212                 goto setSpeed;
	RJMP _0x7D
; 0000 0213         }
; 0000 0214         if (!sw_up)
_0x7C:
	SBIC 0x13,2
	RJMP _0x7E
; 0000 0215         {
; 0000 0216                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0217                 goto menu01;
	RJMP _0x75
; 0000 0218         }
; 0000 0219         if (!sw_down)
_0x7E:
	SBIC 0x13,3
	RJMP _0x7F
; 0000 021A         {
; 0000 021B                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 021C                 lcd_clear();
	CALL _lcd_clear
; 0000 021D                 goto menu03;
	RJMP _0x80
; 0000 021E         }
; 0000 021F         goto menu02;
_0x7F:
	RJMP _0x79
; 0000 0220     menu03:
_0x80:
; 0000 0221         delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0222         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 0223                 // 0123456789abcdef
; 0000 0224         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0x0,311
	CALL SUBOPT_0x1
; 0000 0225         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0226         lcd_putsf("  Skenario      ");
	__POINTW1FN _0x0,328
	CALL SUBOPT_0x1
; 0000 0227 
; 0000 0228         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 0229         lcd_putchar(0);
	CALL SUBOPT_0x22
; 0000 022A 
; 0000 022B         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x81
; 0000 022C         {
; 0000 022D                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 022E                 lcd_clear();
	CALL _lcd_clear
; 0000 022F                 kursorGaris = 1;
	LDI  R30,LOW(1)
	STS  _kursorGaris,R30
; 0000 0230                 goto setGaris;
	RJMP _0x82
; 0000 0231         }
; 0000 0232         if (!sw_up)
_0x81:
	SBIC 0x13,2
	RJMP _0x83
; 0000 0233         {
; 0000 0234                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0235                 lcd_clear();
	CALL _lcd_clear
; 0000 0236                 goto menu02;
	RJMP _0x79
; 0000 0237         }
; 0000 0238         if (!sw_down)
_0x83:
	SBIC 0x13,3
	RJMP _0x84
; 0000 0239         {
; 0000 023A                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 023B                 goto menu04;
	RJMP _0x85
; 0000 023C         }
; 0000 023D         goto menu03;
_0x84:
	RJMP _0x80
; 0000 023E     menu04:
_0x85:
; 0000 023F         delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0240         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 0241                 // 0123456789abcdef
; 0000 0242         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0x0,311
	CALL SUBOPT_0x1
; 0000 0243         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0244         lcd_putsf("  Skenario      ");
	__POINTW1FN _0x0,328
	CALL SUBOPT_0x1
; 0000 0245 
; 0000 0246         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0247         lcd_putchar(0);
	CALL SUBOPT_0x22
; 0000 0248 
; 0000 0249         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x86
; 0000 024A         {
; 0000 024B                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 024C                 lcd_clear();
	CALL _lcd_clear
; 0000 024D                 goto setSkenario;
	RJMP _0x87
; 0000 024E         }
; 0000 024F         if (!sw_up)
_0x86:
	SBIC 0x13,2
	RJMP _0x88
; 0000 0250         {
; 0000 0251                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0252                 goto menu03;
	RJMP _0x80
; 0000 0253         }
; 0000 0254         if (!sw_down)
_0x88:
	SBIC 0x13,3
	RJMP _0x89
; 0000 0255         {
; 0000 0256                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0257                 lcd_clear();
	CALL _lcd_clear
; 0000 0258                 goto menu05;
	RJMP _0x8A
; 0000 0259         }
; 0000 025A         goto menu04;
_0x89:
	RJMP _0x85
; 0000 025B     menu05:            // Bikin sendiri lhoo ^^d
_0x8A:
; 0000 025C         delay_ms(225);
	CALL SUBOPT_0x21
; 0000 025D         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 025E         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0x0,345
	CALL SUBOPT_0x1
; 0000 025F         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0260         lcd_putsf("  Start!!      ");
	__POINTW1FN _0x0,365
	CALL SUBOPT_0x1
; 0000 0261 
; 0000 0262         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 0263         lcd_putchar(0);
	CALL SUBOPT_0x22
; 0000 0264 
; 0000 0265         if  (!sw_ok)
	SBIC 0x13,0
	RJMP _0x8B
; 0000 0266         {
; 0000 0267             delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0268             lcd_clear();
	CALL _lcd_clear
; 0000 0269             goto mode;
	RJMP _0x8C
; 0000 026A         }
; 0000 026B 
; 0000 026C         if  (!sw_up)
_0x8B:
	SBIC 0x13,2
	RJMP _0x8D
; 0000 026D         {
; 0000 026E             delay_ms(225);
	CALL SUBOPT_0x21
; 0000 026F             lcd_clear();
	CALL _lcd_clear
; 0000 0270             goto menu04;
	RJMP _0x85
; 0000 0271         }
; 0000 0272 
; 0000 0273         if  (!sw_down)
_0x8D:
	SBIC 0x13,3
	RJMP _0x8E
; 0000 0274         {
; 0000 0275             delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0276             goto menu06;
	RJMP _0x7B
; 0000 0277         }
; 0000 0278 
; 0000 0279         goto menu05;
_0x8E:
	RJMP _0x8A
; 0000 027A     menu06:
_0x7B:
; 0000 027B         delay_ms(225);
	CALL SUBOPT_0x21
; 0000 027C         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 027D         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0x0,345
	CALL SUBOPT_0x1
; 0000 027E         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 027F         lcd_putsf("  Start!!      ");
	__POINTW1FN _0x0,365
	CALL SUBOPT_0x1
; 0000 0280 
; 0000 0281         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0282         lcd_putchar(0);
	CALL SUBOPT_0x22
; 0000 0283 
; 0000 0284         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x8F
; 0000 0285         {
; 0000 0286                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0287                 lcd_clear();
	CALL _lcd_clear
; 0000 0288                 goto startRobot;
	RJMP _0x90
; 0000 0289         }
; 0000 028A 
; 0000 028B         if (!sw_up)
_0x8F:
	SBIC 0x13,2
	RJMP _0x91
; 0000 028C         {
; 0000 028D                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 028E                 goto menu05;
	RJMP _0x8A
; 0000 028F         }
; 0000 0290 
; 0000 0291         if (!sw_down)
_0x91:
	SBIC 0x13,3
	RJMP _0x92
; 0000 0292         {
; 0000 0293                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0294                 lcd_clear();
	CALL _lcd_clear
; 0000 0295                 goto menu01;
	RJMP _0x75
; 0000 0296         }
; 0000 0297 
; 0000 0298         goto menu06;
_0x92:
	RJMP _0x7B
; 0000 0299 
; 0000 029A 
; 0000 029B     setPID:
_0x77:
; 0000 029C         delay_ms(225);
	CALL SUBOPT_0x21
; 0000 029D         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 029E                 // 0123456789ABCDEF
; 0000 029F         lcd_putsf("  Kp   Ki   Kd  ");
	__POINTW1FN _0x0,381
	CALL SUBOPT_0x1
; 0000 02A0         // lcd_putsf(" 250  200  300  ");
; 0000 02A1         lcd_putchar(' ');
	CALL SUBOPT_0x23
; 0000 02A2         tampil(Kp); lcd_putchar(' '); lcd_putchar(' ');
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL SUBOPT_0x24
	CALL SUBOPT_0x23
; 0000 02A3         tampil(Ki); lcd_putchar(' '); lcd_putchar(' ');
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL SUBOPT_0x24
	CALL SUBOPT_0x23
; 0000 02A4         tampil(Kd); lcd_putchar(' '); lcd_putchar(' ');
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL SUBOPT_0x24
	CALL SUBOPT_0x23
; 0000 02A5 
; 0000 02A6         switch (kursorPID)
	LDS  R30,_kursorPID
; 0000 02A7         {
; 0000 02A8           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x96
; 0000 02A9                 lcd_gotoxy(1,0); // kursor Kp
	LDI  R30,LOW(1)
	RJMP _0x1BD
; 0000 02AA                 lcd_putchar(0);
; 0000 02AB                 break;
; 0000 02AC           case 2:
_0x96:
	CPI  R30,LOW(0x2)
	BRNE _0x97
; 0000 02AD                 lcd_gotoxy(6,0); // kursor Ki
	LDI  R30,LOW(6)
	RJMP _0x1BD
; 0000 02AE                 lcd_putchar(0);
; 0000 02AF                 break;
; 0000 02B0           case 3:
_0x97:
	CPI  R30,LOW(0x3)
	BRNE _0x95
; 0000 02B1                 lcd_gotoxy(11,0); // kursor Kd
	LDI  R30,LOW(11)
_0x1BD:
	ST   -Y,R30
	CALL SUBOPT_0x25
; 0000 02B2                 lcd_putchar(0);
; 0000 02B3                 break;
; 0000 02B4         }
_0x95:
; 0000 02B5 
; 0000 02B6         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x99
; 0000 02B7         {
; 0000 02B8                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 02B9                 setByte( 1, kursorPID);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDS  R30,_kursorPID
	CALL SUBOPT_0x26
; 0000 02BA                 delay_ms(200);
; 0000 02BB         }
; 0000 02BC         if (!sw_up)
_0x99:
	SBIC 0x13,2
	RJMP _0x9A
; 0000 02BD         {
; 0000 02BE                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 02BF                 if (kursorPID == 3) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x3)
	BRNE _0x9B
; 0000 02C0                         kursorPID = 1;
	LDI  R30,LOW(1)
	RJMP _0x1BE
; 0000 02C1                 } else kursorPID++;
_0x9B:
	LDS  R30,_kursorPID
	SUBI R30,-LOW(1)
_0x1BE:
	STS  _kursorPID,R30
; 0000 02C2         }
; 0000 02C3         if (!sw_down)
_0x9A:
	SBIC 0x13,3
	RJMP _0x9D
; 0000 02C4         {
; 0000 02C5                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 02C6                 if (kursorPID == 1) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x1)
	BRNE _0x9E
; 0000 02C7                         kursorPID = 3;
	LDI  R30,LOW(3)
	RJMP _0x1BF
; 0000 02C8                 } else kursorPID--;
_0x9E:
	LDS  R30,_kursorPID
	SUBI R30,LOW(1)
_0x1BF:
	STS  _kursorPID,R30
; 0000 02C9         }
; 0000 02CA 
; 0000 02CB         if (!sw_cancel)
_0x9D:
	SBIC 0x13,1
	RJMP _0xA0
; 0000 02CC         {
; 0000 02CD                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 02CE                 lcd_clear();
	CALL _lcd_clear
; 0000 02CF                 goto menu01;
	RJMP _0x75
; 0000 02D0         }
; 0000 02D1 
; 0000 02D2         goto setPID;
_0xA0:
	RJMP _0x77
; 0000 02D3 
; 0000 02D4     setSpeed:
_0x7D:
; 0000 02D5         delay_ms(225);
	CALL SUBOPT_0x21
; 0000 02D6         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 02D7                 // 0123456789ABCDEF
; 0000 02D8         lcd_putsf("   MAX    MIN   ");
	__POINTW1FN _0x0,398
	CALL SUBOPT_0x1
; 0000 02D9         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
; 0000 02DA 
; 0000 02DB         //lcd_putsf("   250    200   ");
; 0000 02DC         tampil(MAXSpeed);
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL SUBOPT_0x24
; 0000 02DD         lcd_putchar(' '); lcd_putchar(' ');lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
; 0000 02DE         tampil(MINSpeed);
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x24
; 0000 02DF         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
; 0000 02E0 
; 0000 02E1         switch (kursorSpeed)
	LDS  R30,_kursorSpeed
; 0000 02E2         {
; 0000 02E3           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0xA4
; 0000 02E4                 lcd_gotoxy(2,0); // kursor MAX
	LDI  R30,LOW(2)
	RJMP _0x1C0
; 0000 02E5                 lcd_putchar(0);
; 0000 02E6                 break;
; 0000 02E7           case 2:
_0xA4:
	CPI  R30,LOW(0x2)
	BRNE _0xA3
; 0000 02E8                 lcd_gotoxy(9,0); // kursor MIN
	LDI  R30,LOW(9)
_0x1C0:
	ST   -Y,R30
	CALL SUBOPT_0x25
; 0000 02E9                 lcd_putchar(0);
; 0000 02EA                 break;
; 0000 02EB         }
_0xA3:
; 0000 02EC 
; 0000 02ED         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xA6
; 0000 02EE         {
; 0000 02EF                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 02F0                 setByte( 2, kursorSpeed);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R30,_kursorSpeed
	CALL SUBOPT_0x26
; 0000 02F1                 delay_ms(200);
; 0000 02F2         }
; 0000 02F3         if (!sw_up)
_0xA6:
	SBIC 0x13,2
	RJMP _0xA7
; 0000 02F4         {
; 0000 02F5                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 02F6                 if (kursorSpeed == 2)
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x2)
	BRNE _0xA8
; 0000 02F7                 {
; 0000 02F8                         kursorSpeed = 1;
	LDI  R30,LOW(1)
	RJMP _0x1C1
; 0000 02F9                 } else kursorSpeed++;
_0xA8:
	LDS  R30,_kursorSpeed
	SUBI R30,-LOW(1)
_0x1C1:
	STS  _kursorSpeed,R30
; 0000 02FA         }
; 0000 02FB         if (!sw_down)
_0xA7:
	SBIC 0x13,3
	RJMP _0xAA
; 0000 02FC         {
; 0000 02FD                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 02FE                 if (kursorSpeed == 1)
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x1)
	BRNE _0xAB
; 0000 02FF                 {
; 0000 0300                         kursorSpeed = 2;
	LDI  R30,LOW(2)
	RJMP _0x1C2
; 0000 0301                 } else kursorSpeed--;
_0xAB:
	LDS  R30,_kursorSpeed
	SUBI R30,LOW(1)
_0x1C2:
	STS  _kursorSpeed,R30
; 0000 0302         }
; 0000 0303 
; 0000 0304         if (!sw_cancel)
_0xAA:
	SBIC 0x13,1
	RJMP _0xAD
; 0000 0305         {
; 0000 0306                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0307                 lcd_clear();
	CALL _lcd_clear
; 0000 0308                 goto menu02;
	RJMP _0x79
; 0000 0309         }
; 0000 030A 
; 0000 030B         goto setSpeed;
_0xAD:
	RJMP _0x7D
; 0000 030C 
; 0000 030D      setGaris: // not yet
_0x82:
; 0000 030E         delay_ms(225);
	CALL SUBOPT_0x21
; 0000 030F         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 0310                 // 0123456789ABCDEF
; 0000 0311         if ( WarnaGaris == 1 )
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0xAE
; 0000 0312                 lcd_putsf("  WARNA : Putih ");
	__POINTW1FN _0x0,415
	RJMP _0x1C3
; 0000 0313         else
_0xAE:
; 0000 0314                 lcd_putsf("  WARNA : Hitam ");
	__POINTW1FN _0x0,432
_0x1C3:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0315 
; 0000 0316         //lcd_putsf("  LEBAR: 1.5 cm ");
; 0000 0317         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0318         lcd_putsf("  SensL :        ");
	__POINTW1FN _0x0,449
	CALL SUBOPT_0x1
; 0000 0319         lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x27
; 0000 031A         tampil( SensLine );
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _tampil
; 0000 031B 
; 0000 031C         switch (kursorGaris)
	LDS  R30,_kursorGaris
; 0000 031D         {
; 0000 031E           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0xB3
; 0000 031F                 lcd_gotoxy(0,0); // kursor Warna
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x1C4
; 0000 0320                 lcd_putchar(0);
; 0000 0321                 break;
; 0000 0322           case 2:
_0xB3:
	CPI  R30,LOW(0x2)
	BRNE _0xB2
; 0000 0323                 lcd_gotoxy(0,1); // kursor SensL
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x1C4:
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0324                 lcd_putchar(0);
	CALL SUBOPT_0x22
; 0000 0325                 break;
; 0000 0326         }
_0xB2:
; 0000 0327 
; 0000 0328         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xB5
; 0000 0329         {
; 0000 032A                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 032B                 setByte( 3, kursorGaris);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDS  R30,_kursorGaris
	CALL SUBOPT_0x26
; 0000 032C                 delay_ms(200);
; 0000 032D         }
; 0000 032E         if (!sw_up)
_0xB5:
	SBIC 0x13,2
	RJMP _0xB6
; 0000 032F         {
; 0000 0330                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0331                 if (kursorGaris == 2)
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x2)
	BRNE _0xB7
; 0000 0332                 {
; 0000 0333                         kursorGaris = 1;
	LDI  R30,LOW(1)
	RJMP _0x1C5
; 0000 0334                 } else kursorGaris++;
_0xB7:
	LDS  R30,_kursorGaris
	SUBI R30,-LOW(1)
_0x1C5:
	STS  _kursorGaris,R30
; 0000 0335         }
; 0000 0336         if (!sw_down)
_0xB6:
	SBIC 0x13,3
	RJMP _0xB9
; 0000 0337         {
; 0000 0338                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0339                 if (kursorGaris == 1)
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x1)
	BRNE _0xBA
; 0000 033A                 {
; 0000 033B                         kursorGaris = 2;
	LDI  R30,LOW(2)
	RJMP _0x1C6
; 0000 033C                 } else kursorGaris--;
_0xBA:
	LDS  R30,_kursorGaris
	SUBI R30,LOW(1)
_0x1C6:
	STS  _kursorGaris,R30
; 0000 033D         }
; 0000 033E 
; 0000 033F         if (!sw_cancel)
_0xB9:
	SBIC 0x13,1
	RJMP _0xBC
; 0000 0340         {
; 0000 0341                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0342                 lcd_clear();
	CALL _lcd_clear
; 0000 0343                 goto menu03;
	RJMP _0x80
; 0000 0344         }
; 0000 0345 
; 0000 0346         goto setGaris;
_0xBC:
	RJMP _0x82
; 0000 0347 
; 0000 0348      setSkenario:
_0x87:
; 0000 0349         delay_ms(225);
	CALL SUBOPT_0x21
; 0000 034A         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1F
; 0000 034B                 // 0123456789ABCDEF
; 0000 034C         lcd_putsf("Sken. yg  dpake:");
	__POINTW1FN _0x0,467
	CALL SUBOPT_0x1
; 0000 034D         lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
; 0000 034E         tampil( Skenario );
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _tampil
; 0000 034F 
; 0000 0350         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xBD
; 0000 0351         {
; 0000 0352                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0353                 setByte( 4, 0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x26
; 0000 0354                 delay_ms(200);
; 0000 0355         }
; 0000 0356 
; 0000 0357         if (!sw_cancel)
_0xBD:
	SBIC 0x13,1
	RJMP _0xBE
; 0000 0358         {
; 0000 0359                 delay_ms(225);
	CALL SUBOPT_0x21
; 0000 035A                 lcd_clear();
	CALL _lcd_clear
; 0000 035B                 goto menu04;
	RJMP _0x85
; 0000 035C         }
; 0000 035D 
; 0000 035E         goto setSkenario;
_0xBE:
	RJMP _0x87
; 0000 035F 
; 0000 0360      mode:
_0x8C:
; 0000 0361         delay_ms(125);
	CALL SUBOPT_0x9
; 0000 0362         if  (!sw_up)
	SBIC 0x13,2
	RJMP _0xBF
; 0000 0363         {
; 0000 0364             delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0365             if (Mode==6)
	CALL SUBOPT_0x28
	CPI  R30,LOW(0x6)
	BRNE _0xC0
; 0000 0366             {
; 0000 0367                 Mode=1;
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0368             }
; 0000 0369 
; 0000 036A             else Mode++;
	RJMP _0xC1
_0xC0:
	CALL SUBOPT_0x28
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 036B 
; 0000 036C             goto nomorMode;
_0xC1:
	RJMP _0xC2
; 0000 036D         }
; 0000 036E 
; 0000 036F         if  (!sw_down)
_0xBF:
	SBIC 0x13,3
	RJMP _0xC3
; 0000 0370         {
; 0000 0371             delay_ms(225);
	CALL SUBOPT_0x21
; 0000 0372             if  (Mode==1)
	CALL SUBOPT_0x28
	CPI  R30,LOW(0x1)
	BRNE _0xC4
; 0000 0373             {
; 0000 0374                 Mode=6;
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	LDI  R30,LOW(6)
	CALL __EEPROMWRB
; 0000 0375             }
; 0000 0376 
; 0000 0377             else Mode--;
	RJMP _0xC5
_0xC4:
	CALL SUBOPT_0x28
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
; 0000 0378 
; 0000 0379             goto nomorMode;
_0xC5:
; 0000 037A         }
; 0000 037B 
; 0000 037C         nomorMode:
_0xC3:
_0xC2:
; 0000 037D             if (Mode==1)
	CALL SUBOPT_0x28
	CPI  R30,LOW(0x1)
	BRNE _0xC6
; 0000 037E             {
; 0000 037F                 lcd_clear();
	CALL SUBOPT_0x20
; 0000 0380                 lcd_gotoxy(0,0);
; 0000 0381                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x29
; 0000 0382                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0383                 lcd_putsf(" 1.Lihat ADC");
	__POINTW1FN _0x0,501
	CALL SUBOPT_0x1
; 0000 0384             }
; 0000 0385 
; 0000 0386             if  (Mode==2)
_0xC6:
	CALL SUBOPT_0x28
	CPI  R30,LOW(0x2)
	BRNE _0xC7
; 0000 0387             {
; 0000 0388                 lcd_clear();
	CALL SUBOPT_0x20
; 0000 0389                 lcd_gotoxy(0,0);
; 0000 038A                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x29
; 0000 038B                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 038C                 lcd_putsf(" 2.Test Mode");
	__POINTW1FN _0x0,514
	CALL SUBOPT_0x1
; 0000 038D             }
; 0000 038E 
; 0000 038F             if  (Mode==3)
_0xC7:
	CALL SUBOPT_0x28
	CPI  R30,LOW(0x3)
	BRNE _0xC8
; 0000 0390             {
; 0000 0391                 lcd_clear();
	CALL SUBOPT_0x20
; 0000 0392                 lcd_gotoxy(0,0);
; 0000 0393                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x29
; 0000 0394                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 0395                 lcd_putsf(" 3.Cek Sensor ");
	__POINTW1FN _0x0,527
	CALL SUBOPT_0x1
; 0000 0396             }
; 0000 0397 
; 0000 0398             if  (Mode==4)
_0xC8:
	CALL SUBOPT_0x28
	CPI  R30,LOW(0x4)
	BRNE _0xC9
; 0000 0399             {
; 0000 039A                 lcd_clear();
	CALL SUBOPT_0x20
; 0000 039B                 lcd_gotoxy(0,0);
; 0000 039C                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x29
; 0000 039D                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 039E                 lcd_putsf(" 4.Auto Tune 1-1");
	__POINTW1FN _0x0,542
	CALL SUBOPT_0x1
; 0000 039F             }
; 0000 03A0 
; 0000 03A1              if  (Mode==5)
_0xC9:
	CALL SUBOPT_0x28
	CPI  R30,LOW(0x5)
	BRNE _0xCA
; 0000 03A2             {
; 0000 03A3                 lcd_clear();
	CALL SUBOPT_0x20
; 0000 03A4                 lcd_gotoxy(0,0);
; 0000 03A5                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x29
; 0000 03A6                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 03A7                 lcd_putsf(" 5.Auto Tune ");
	__POINTW1FN _0x0,559
	CALL SUBOPT_0x1
; 0000 03A8             }
; 0000 03A9 
; 0000 03AA             if  (Mode==6)
_0xCA:
	CALL SUBOPT_0x28
	CPI  R30,LOW(0x6)
	BRNE _0xCB
; 0000 03AB             {
; 0000 03AC                 lcd_clear();
	CALL SUBOPT_0x20
; 0000 03AD                 lcd_gotoxy(0,0);
; 0000 03AE                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x29
; 0000 03AF                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 03B0                 lcd_putsf(" 6.Cek PWM Aktif");
	__POINTW1FN _0x0,573
	CALL SUBOPT_0x1
; 0000 03B1             }
; 0000 03B2 
; 0000 03B3         if  (!sw_ok)
_0xCB:
	SBIC 0x13,0
	RJMP _0xCC
; 0000 03B4         {
; 0000 03B5             delay_ms(225);
	CALL SUBOPT_0x21
; 0000 03B6             switch  (Mode)
	CALL SUBOPT_0x28
; 0000 03B7             {
; 0000 03B8                 case 1:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0xD0
; 0000 03B9                 {
; 0000 03BA                     for(;;)
_0xD2:
; 0000 03BB                     {
; 0000 03BC                         lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2A
; 0000 03BD                         sprintf(lcd,"  %d %d %d %d",read_adc(3),read_adc(2),read_adc(1),read_adc(0));
	CALL SUBOPT_0x2B
	__POINTW1FN _0x0,590
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x11
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x10
	CALL SUBOPT_0x2C
	CALL SUBOPT_0xF
	CALL SUBOPT_0x2C
	CALL SUBOPT_0xE
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
; 0000 03BE                         lcd_puts(lcd);
	CALL _lcd_puts
; 0000 03BF                         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 03C0                         sprintf(lcd,"%d %d %d %d",read_adc(7),read_adc(6),read_adc(5),read_adc(4));
	CALL SUBOPT_0x2B
	__POINTW1FN _0x0,592
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x15
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x13
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x12
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
; 0000 03C1                         lcd_puts(lcd);
	CALL _lcd_puts
; 0000 03C2                         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
; 0000 03C3                         lcd_clear();
	CALL _lcd_clear
; 0000 03C4                     }
	RJMP _0xD2
; 0000 03C5                 }
; 0000 03C6                 break;
; 0000 03C7 
; 0000 03C8                 case 2:
_0xD0:
	CPI  R30,LOW(0x2)
	BRNE _0xD4
; 0000 03C9                 {
; 0000 03CA                     cek_sensor();
	RCALL _cek_sensor
; 0000 03CB                 }
; 0000 03CC                 break;
	RJMP _0xCF
; 0000 03CD 
; 0000 03CE                 case 3:
_0xD4:
	CPI  R30,LOW(0x3)
	BRNE _0xD5
; 0000 03CF                 {
; 0000 03D0                     cek_sensor();
	RCALL _cek_sensor
; 0000 03D1                 }
; 0000 03D2                 break;
	RJMP _0xCF
; 0000 03D3 
; 0000 03D4                 case 4:
_0xD5:
	CPI  R30,LOW(0x4)
	BRNE _0xD6
; 0000 03D5                 {
; 0000 03D6                     tune_batas();
	RCALL _tune_batas
; 0000 03D7 
; 0000 03D8                 }
; 0000 03D9                 break;
	RJMP _0xCF
; 0000 03DA 
; 0000 03DB                 case 5:
_0xD6:
	CPI  R30,LOW(0x5)
	BRNE _0xD7
; 0000 03DC                 {
; 0000 03DD                     auto_scan();
	RCALL _auto_scan
; 0000 03DE                     goto menu01;
	RJMP _0x75
; 0000 03DF                 }
; 0000 03E0                 break;
; 0000 03E1 
; 0000 03E2                 case 6:
_0xD7:
	CPI  R30,LOW(0x6)
	BRNE _0xCF
; 0000 03E3                 {
; 0000 03E4                     pemercepat();
	RCALL _pemercepat
; 0000 03E5                     pelambat();
	RCALL _pelambat
; 0000 03E6                     goto menu01;
	RJMP _0x75
; 0000 03E7                 }
; 0000 03E8                 break;
; 0000 03E9             }
_0xCF:
; 0000 03EA         }
; 0000 03EB 
; 0000 03EC         if  (!sw_cancel)
_0xCC:
	SBIC 0x13,1
	RJMP _0xD9
; 0000 03ED         {
; 0000 03EE             lcd_clear();
	CALL _lcd_clear
; 0000 03EF             goto menu05;
	RJMP _0x8A
; 0000 03F0         }
; 0000 03F1 
; 0000 03F2         goto mode;
_0xD9:
	RJMP _0x8C
; 0000 03F3 
; 0000 03F4      startRobot:
_0x90:
; 0000 03F5         //TIMSK = 0x01;
; 0000 03F6         //#asm("sei")
; 0000 03F7         lcd_clear();
	RJMP _0x2080004
; 0000 03F8 }
;
;void displaySensorBit()
; 0000 03FB {
_displaySensorBit:
; 0000 03FC     baca_sensor();
	RCALL _baca_sensor
; 0000 03FD     lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x27
; 0000 03FE     if (s7) lcd_putchar('1');
	SBRS R2,7
	RJMP _0xDA
	LDI  R30,LOW(49)
	RJMP _0x1C7
; 0000 03FF     else    lcd_putchar('0');
_0xDA:
	LDI  R30,LOW(48)
_0x1C7:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0400     if (s6) lcd_putchar('1');
	SBRS R2,6
	RJMP _0xDC
	LDI  R30,LOW(49)
	RJMP _0x1C8
; 0000 0401     else    lcd_putchar('0');
_0xDC:
	LDI  R30,LOW(48)
_0x1C8:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0402     if (s5) lcd_putchar('1');
	SBRS R2,5
	RJMP _0xDE
	LDI  R30,LOW(49)
	RJMP _0x1C9
; 0000 0403     else    lcd_putchar('0');
_0xDE:
	LDI  R30,LOW(48)
_0x1C9:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0404     if (s4) lcd_putchar('1');
	SBRS R2,4
	RJMP _0xE0
	LDI  R30,LOW(49)
	RJMP _0x1CA
; 0000 0405     else    lcd_putchar('0');
_0xE0:
	LDI  R30,LOW(48)
_0x1CA:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0406     if (s3) lcd_putchar('1');
	SBRS R2,3
	RJMP _0xE2
	LDI  R30,LOW(49)
	RJMP _0x1CB
; 0000 0407     else    lcd_putchar('0');
_0xE2:
	LDI  R30,LOW(48)
_0x1CB:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0408     if (s2) lcd_putchar('1');
	SBRS R2,2
	RJMP _0xE4
	LDI  R30,LOW(49)
	RJMP _0x1CC
; 0000 0409     else    lcd_putchar('0');
_0xE4:
	LDI  R30,LOW(48)
_0x1CC:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 040A     if (s1) lcd_putchar('1');
	SBRS R2,1
	RJMP _0xE6
	LDI  R30,LOW(49)
	RJMP _0x1CD
; 0000 040B     else    lcd_putchar('0');
_0xE6:
	LDI  R30,LOW(48)
_0x1CD:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 040C     if (s0) lcd_putchar('1');
	SBRS R2,0
	RJMP _0xE8
	LDI  R30,LOW(49)
	RJMP _0x1CE
; 0000 040D     else    lcd_putchar('0');
_0xE8:
	LDI  R30,LOW(48)
_0x1CE:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 040E }
	RET
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0411 {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0412         xcount++;
	LDS  R30,_xcount
	SUBI R30,-LOW(1)
	STS  _xcount,R30
; 0000 0413         if(xcount<=lpwm)Enki=1;
	LDS  R30,_lpwm
	LDS  R31,_lpwm+1
	CALL SUBOPT_0x2E
	BRLT _0xEA
	SBI  0x12,7
; 0000 0414         else Enki=0;
	RJMP _0xED
_0xEA:
	CBI  0x12,7
; 0000 0415         if(xcount<=rpwm)Enka=1;
_0xED:
	LDS  R30,_rpwm
	LDS  R31,_rpwm+1
	CALL SUBOPT_0x2E
	BRLT _0xF0
	SBI  0x12,6
; 0000 0416         else Enka=0;
	RJMP _0xF3
_0xF0:
	CBI  0x12,6
; 0000 0417         TCNT0=0xFF;
_0xF3:
	LDI  R30,LOW(255)
	OUT  0x32,R30
; 0000 0418 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;void maju(){kaplus=1;kamin=0;kirplus=1;kirmin=0;}
; 0000 041A void maju(){PORTD.3=1;PORTD.2=0;PORTD.5=1;PORTD.4=0;}
_maju:
	SBI  0x12,3
	CBI  0x12,2
	SBI  0x12,5
	RJMP _0x2080005
;
;void mundur(){kaplus=0;kamin=1;kirplus=0;kirmin=1;}
; 0000 041C void mundur(){PORTD.3=0;PORTD.2=1;PORTD.5=0;PORTD.4=1;}
_mundur:
	CBI  0x12,3
	SBI  0x12,2
	RJMP _0x2080007
;
;void bkan(){kaplus=0;kamin=0;kirplus=1;kirmin=0;}
; 0000 041E void bkan(){PORTD.3=0;PORTD.2=0;PORTD.5=1;PORTD.4=0;}
_bkan:
	CBI  0x12,3
	CBI  0x12,2
	SBI  0x12,5
	RJMP _0x2080005
;
;void bkir(){kaplus=1;kamin=0;kirplus=0;kirmin=0;}
; 0000 0420 void bkir(){PORTD.3=1;PORTD.2=0;PORTD.5=0;PORTD.4=0;}
_bkir:
	SBI  0x12,3
	RJMP _0x2080006
;
;void rotkan(){kaplus=0;kamin=1;kirplus=1;kirmin=0;}
; 0000 0422 void rotkan(){PORTD.3=0;PORTD.2=1;PORTD.5=1;PORTD.4=0;}
_rotkan:
	CBI  0x12,3
	SBI  0x12,2
	SBI  0x12,5
	RJMP _0x2080005
;
;void rotkir(){kaplus=1;kamin=0;kirplus=0;kirmin=1;}
; 0000 0424 void rotkir(){PORTD.3=1;PORTD.2=0;PORTD.5=0;PORTD.4=1;}
_rotkir:
	SBI  0x12,3
	CBI  0x12,2
_0x2080007:
	CBI  0x12,5
	SBI  0x12,4
	RET
;
;void stop(){ kaplus=0;kamin=0;kirplus=0;kirmin=0; }
; 0000 0426 void stop(){ PORTD.3=0;PORTD.2=0;PORTD.5=0;PORTD.4=0; }
_stop:
	CBI  0x12,3
_0x2080006:
	CBI  0x12,2
	CBI  0x12,5
_0x2080005:
	CBI  0x12,4
	RET
;
;void cek_sensor()
; 0000 0429 {
_cek_sensor:
; 0000 042A         int t;
; 0000 042B 
; 0000 042C         baca_sensor();
	ST   -Y,R17
	ST   -Y,R16
;	t -> R16,R17
	RCALL _baca_sensor
; 0000 042D         lcd_clear();
	CALL _lcd_clear
; 0000 042E         delay_ms(125);
	CALL SUBOPT_0x0
; 0000 042F                 // wait 125ms
; 0000 0430         lcd_gotoxy(0,0);
; 0000 0431                 //0123456789abcdef
; 0000 0432         lcd_putsf(" Test:Sensor    ");
	__POINTW1FN _0x0,604
	CALL SUBOPT_0x1
; 0000 0433 
; 0000 0434         for (t=0; t<30000; t++) {displaySensorBit();}
	__GETWRN 16,17,0
_0x12F:
	__CPWRN 16,17,30000
	BRGE _0x130
	RCALL _displaySensorBit
	__ADDWRN 16,17,1
	RJMP _0x12F
_0x130:
; 0000 0435 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void tune_batas()
; 0000 0438 {
_tune_batas:
; 0000 0439     lcd_clear();
	CALL SUBOPT_0x20
; 0000 043A     lcd_gotoxy(0,0);
; 0000 043B     lcd_putsf(" Cek Memory ?");
	__POINTW1FN _0x0,621
	CALL SUBOPT_0x1
; 0000 043C     lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
; 0000 043D     lcd_putsf(" Y / N ");
	__POINTW1FN _0x0,635
	CALL SUBOPT_0x1
; 0000 043E     for(;;)
_0x132:
; 0000 043F     {
; 0000 0440         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x134
; 0000 0441         {
; 0000 0442                 delay_ms(200);
	CALL SUBOPT_0x5
; 0000 0443                 lcd_clear();
	CALL SUBOPT_0x20
; 0000 0444                 lcd_gotoxy(0,0);
; 0000 0445                 sprintf(lcd," %d %d %d %d %d %d %d %d",bt0, bt1, bt2, bt3, bt4, bt5, bt6, bt7);
	CALL SUBOPT_0x2B
	__POINTW1FN _0x0,643
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x17
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x18
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x19
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2F
; 0000 0446                 lcd_puts(lcd);
	CALL _lcd_puts
; 0000 0447                 delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x4
; 0000 0448         }
; 0000 0449 
; 0000 044A         if(!sw_cancel)
_0x134:
	SBIS 0x13,1
; 0000 044B         {
; 0000 044C                 break;
	RJMP _0x133
; 0000 044D         }
; 0000 044E     }
	RJMP _0x132
_0x133:
; 0000 044F     for(;;)
_0x137:
; 0000 0450     {
; 0000 0451         read_adc(0);
	CALL SUBOPT_0xE
; 0000 0452         if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
	CALL SUBOPT_0xE
	MOV  R26,R30
	LDS  R30,_bb0
	CP   R26,R30
	BRSH _0x139
	CALL SUBOPT_0xE
	STS  _bb0,R30
; 0000 0453         if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
_0x139:
	CALL SUBOPT_0xE
	MOV  R26,R30
	LDS  R30,_ba0
	CP   R30,R26
	BRSH _0x13A
	CALL SUBOPT_0xE
	STS  _ba0,R30
; 0000 0454 
; 0000 0455         bt0=((bb0+ba0)/2);
_0x13A:
	CALL SUBOPT_0x30
; 0000 0456 
; 0000 0457         lcd_clear();
	CALL SUBOPT_0x31
; 0000 0458         lcd_gotoxy(1,0);
; 0000 0459         lcd_putsf(" bb0  ba0  bt0");
	__POINTW1FN _0x0,668
	CALL SUBOPT_0x1
; 0000 045A         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 045B         sprintf(lcd," %d  %d  %d",bb0,ba0,bt0);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x32
	LDS  R30,_bb0
	CALL SUBOPT_0x2C
	LDS  R30,_ba0
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x33
; 0000 045C         lcd_puts(lcd);
	CALL SUBOPT_0x34
; 0000 045D         delay_ms(50);
; 0000 045E 
; 0000 045F         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x13B
; 0000 0460         {
; 0000 0461             delay_ms(125);
	CALL SUBOPT_0x9
; 0000 0462             goto sensor1;
	RJMP _0x13C
; 0000 0463         }
; 0000 0464     }
_0x13B:
	RJMP _0x137
; 0000 0465     sensor1:
_0x13C:
; 0000 0466     for(;;)
_0x13E:
; 0000 0467     {
; 0000 0468         read_adc(1);
	CALL SUBOPT_0xF
; 0000 0469         if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
	CALL SUBOPT_0xF
	MOV  R26,R30
	LDS  R30,_bb1
	CP   R26,R30
	BRSH _0x140
	CALL SUBOPT_0xF
	STS  _bb1,R30
; 0000 046A         if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
_0x140:
	CALL SUBOPT_0xF
	MOV  R26,R30
	LDS  R30,_ba1
	CP   R30,R26
	BRSH _0x141
	CALL SUBOPT_0xF
	STS  _ba1,R30
; 0000 046B 
; 0000 046C         bt1=((bb1+ba1)/2);
_0x141:
	CALL SUBOPT_0x35
; 0000 046D 
; 0000 046E         lcd_clear();
	CALL SUBOPT_0x31
; 0000 046F         lcd_gotoxy(1,0);
; 0000 0470         lcd_putsf(" bb1  ba1  bt1");
	__POINTW1FN _0x0,695
	CALL SUBOPT_0x1
; 0000 0471         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 0472         sprintf(lcd," %d  %d  %d",bb1,ba1,bt1);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x32
	LDS  R30,_bb1
	CALL SUBOPT_0x2C
	LDS  R30,_ba1
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x17
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x33
; 0000 0473         lcd_puts(lcd);
	CALL SUBOPT_0x34
; 0000 0474         delay_ms(50);
; 0000 0475 
; 0000 0476         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x142
; 0000 0477         {
; 0000 0478             delay_ms(150);
	CALL SUBOPT_0x36
; 0000 0479             goto sensor2;
	RJMP _0x143
; 0000 047A         }
; 0000 047B     }
_0x142:
	RJMP _0x13E
; 0000 047C     sensor2:
_0x143:
; 0000 047D     for(;;)
_0x145:
; 0000 047E     {
; 0000 047F         read_adc(2);
	CALL SUBOPT_0x10
; 0000 0480         if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
	CALL SUBOPT_0x10
	MOV  R26,R30
	LDS  R30,_bb2
	CP   R26,R30
	BRSH _0x147
	CALL SUBOPT_0x10
	STS  _bb2,R30
; 0000 0481         if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
_0x147:
	CALL SUBOPT_0x10
	MOV  R26,R30
	LDS  R30,_ba2
	CP   R30,R26
	BRSH _0x148
	CALL SUBOPT_0x10
	STS  _ba2,R30
; 0000 0482 
; 0000 0483         bt2=((bb2+ba2)/2);
_0x148:
	CALL SUBOPT_0x37
; 0000 0484 
; 0000 0485         lcd_clear();
	CALL SUBOPT_0x31
; 0000 0486         lcd_gotoxy(1,0);
; 0000 0487         lcd_putsf(" bb2  ba2  bt2");
	__POINTW1FN _0x0,710
	CALL SUBOPT_0x1
; 0000 0488         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 0489         sprintf(lcd," %d  %d  %d",bb2,ba2,bt2);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x32
	LDS  R30,_bb2
	CALL SUBOPT_0x2C
	LDS  R30,_ba2
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x18
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x33
; 0000 048A         lcd_puts(lcd);
	CALL SUBOPT_0x38
; 0000 048B         delay_ms(10);
; 0000 048C 
; 0000 048D         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x149
; 0000 048E         {
; 0000 048F             delay_ms(150);
	CALL SUBOPT_0x36
; 0000 0490             goto sensor3;
	RJMP _0x14A
; 0000 0491         }
; 0000 0492     }
_0x149:
	RJMP _0x145
; 0000 0493     sensor3:
_0x14A:
; 0000 0494     for(;;)
_0x14C:
; 0000 0495     {
; 0000 0496         read_adc(3);
	CALL SUBOPT_0x11
; 0000 0497         if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
	CALL SUBOPT_0x11
	MOV  R26,R30
	LDS  R30,_bb3
	CP   R26,R30
	BRSH _0x14E
	CALL SUBOPT_0x11
	STS  _bb3,R30
; 0000 0498         if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
_0x14E:
	CALL SUBOPT_0x11
	MOV  R26,R30
	LDS  R30,_ba3
	CP   R30,R26
	BRSH _0x14F
	CALL SUBOPT_0x11
	STS  _ba3,R30
; 0000 0499 
; 0000 049A         bt3=((bb3+ba3)/2);
_0x14F:
	CALL SUBOPT_0x39
; 0000 049B 
; 0000 049C         lcd_clear();
	CALL SUBOPT_0x31
; 0000 049D         lcd_gotoxy(1,0);
; 0000 049E         lcd_putsf(" bb3  ba3  bt3");
	__POINTW1FN _0x0,725
	CALL SUBOPT_0x1
; 0000 049F         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 04A0         sprintf(lcd," %d  %d  %d",bb3,ba3,bt3);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x32
	LDS  R30,_bb3
	CALL SUBOPT_0x2C
	LDS  R30,_ba3
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x19
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x33
; 0000 04A1         lcd_puts(lcd);
	CALL SUBOPT_0x38
; 0000 04A2         delay_ms(10);
; 0000 04A3 
; 0000 04A4         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x150
; 0000 04A5         {
; 0000 04A6             delay_ms(150);
	CALL SUBOPT_0x36
; 0000 04A7             goto sensor4;
	RJMP _0x151
; 0000 04A8         }
; 0000 04A9     }
_0x150:
	RJMP _0x14C
; 0000 04AA     sensor4:
_0x151:
; 0000 04AB     for(;;)
_0x153:
; 0000 04AC     {
; 0000 04AD         read_adc(4);
	CALL SUBOPT_0x12
; 0000 04AE         if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
	CALL SUBOPT_0x12
	MOV  R26,R30
	LDS  R30,_bb4
	CP   R26,R30
	BRSH _0x155
	CALL SUBOPT_0x12
	STS  _bb4,R30
; 0000 04AF         if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
_0x155:
	CALL SUBOPT_0x12
	MOV  R26,R30
	LDS  R30,_ba4
	CP   R30,R26
	BRSH _0x156
	CALL SUBOPT_0x12
	STS  _ba4,R30
; 0000 04B0 
; 0000 04B1         bt4=((bb4+ba4)/2);
_0x156:
	CALL SUBOPT_0x3A
; 0000 04B2 
; 0000 04B3         lcd_clear();
	CALL SUBOPT_0x31
; 0000 04B4         lcd_gotoxy(1,0);
; 0000 04B5         lcd_putsf(" bb4  ba4  bt4");
	__POINTW1FN _0x0,740
	CALL SUBOPT_0x1
; 0000 04B6         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 04B7         sprintf(lcd," %d  %d  %d",bb4,ba4,bt4);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x32
	LDS  R30,_bb4
	CALL SUBOPT_0x2C
	LDS  R30,_ba4
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x33
; 0000 04B8         lcd_puts(lcd);
	CALL SUBOPT_0x38
; 0000 04B9         delay_ms(10);
; 0000 04BA 
; 0000 04BB         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x157
; 0000 04BC         {
; 0000 04BD             delay_ms(150);
	CALL SUBOPT_0x36
; 0000 04BE             goto sensor5;
	RJMP _0x158
; 0000 04BF         }
; 0000 04C0     }
_0x157:
	RJMP _0x153
; 0000 04C1     sensor5:
_0x158:
; 0000 04C2     for(;;)
_0x15A:
; 0000 04C3     {
; 0000 04C4         read_adc(5);
	CALL SUBOPT_0x13
; 0000 04C5         if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
	CALL SUBOPT_0x13
	MOV  R26,R30
	LDS  R30,_bb5
	CP   R26,R30
	BRSH _0x15C
	CALL SUBOPT_0x13
	STS  _bb5,R30
; 0000 04C6         if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
_0x15C:
	CALL SUBOPT_0x13
	MOV  R26,R30
	LDS  R30,_ba5
	CP   R30,R26
	BRSH _0x15D
	CALL SUBOPT_0x13
	STS  _ba5,R30
; 0000 04C7 
; 0000 04C8         bt5=((bb5+ba5)/2);
_0x15D:
	CALL SUBOPT_0x3B
; 0000 04C9 
; 0000 04CA         lcd_clear();
	CALL SUBOPT_0x31
; 0000 04CB         lcd_gotoxy(1,0);
; 0000 04CC         lcd_putsf(" bb5  ba5  bt5");
	__POINTW1FN _0x0,755
	CALL SUBOPT_0x1
; 0000 04CD         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 04CE         sprintf(lcd," %d  %d  %d",bb5,ba5,bt5);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x32
	LDS  R30,_bb5
	CALL SUBOPT_0x2C
	LDS  R30,_ba5
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x33
; 0000 04CF         lcd_puts(lcd);
	CALL SUBOPT_0x38
; 0000 04D0         delay_ms(10);
; 0000 04D1 
; 0000 04D2         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x15E
; 0000 04D3         {
; 0000 04D4             delay_ms(150);
	CALL SUBOPT_0x36
; 0000 04D5             goto sensor6;
	RJMP _0x15F
; 0000 04D6         }
; 0000 04D7     }
_0x15E:
	RJMP _0x15A
; 0000 04D8     sensor6:
_0x15F:
; 0000 04D9     for(;;)
_0x161:
; 0000 04DA     {
; 0000 04DB         read_adc(06);
	CALL SUBOPT_0x14
; 0000 04DC         if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_bb6
	CP   R26,R30
	BRSH _0x163
	CALL SUBOPT_0x14
	STS  _bb6,R30
; 0000 04DD         if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
_0x163:
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_ba6
	CP   R30,R26
	BRSH _0x164
	CALL SUBOPT_0x14
	STS  _ba6,R30
; 0000 04DE 
; 0000 04DF         bt6=((bb6+ba6)/2);
_0x164:
	CALL SUBOPT_0x3C
; 0000 04E0 
; 0000 04E1         lcd_clear();
	CALL SUBOPT_0x31
; 0000 04E2         lcd_gotoxy(1,0);
; 0000 04E3         lcd_putsf(" bb6  ba6  bt6");
	__POINTW1FN _0x0,770
	CALL SUBOPT_0x1
; 0000 04E4         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 04E5         sprintf(lcd," %d  %d  %d",bb6,ba6,bt6);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x32
	LDS  R30,_bb6
	CALL SUBOPT_0x2C
	LDS  R30,_ba6
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x33
; 0000 04E6         lcd_puts(lcd);
	CALL SUBOPT_0x38
; 0000 04E7         delay_ms(10);
; 0000 04E8 
; 0000 04E9         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x165
; 0000 04EA         {
; 0000 04EB             delay_ms(150);
	CALL SUBOPT_0x36
; 0000 04EC             goto sensor7;
	RJMP _0x166
; 0000 04ED         }
; 0000 04EE     }
_0x165:
	RJMP _0x161
; 0000 04EF     sensor7:
_0x166:
; 0000 04F0     for(;;)
_0x168:
; 0000 04F1     {
; 0000 04F2         read_adc(7);
	CALL SUBOPT_0x15
; 0000 04F3         if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_bb7
	CP   R26,R30
	BRSH _0x16A
	CALL SUBOPT_0x15
	STS  _bb7,R30
; 0000 04F4         if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
_0x16A:
	CALL SUBOPT_0x15
	CP   R12,R30
	BRSH _0x16B
	CALL SUBOPT_0x15
	MOV  R12,R30
; 0000 04F5 
; 0000 04F6         bt7=((bb7+ba7)/2);
_0x16B:
	CALL SUBOPT_0x3D
; 0000 04F7 
; 0000 04F8         lcd_clear();
; 0000 04F9         lcd_gotoxy(1,0);
; 0000 04FA         lcd_putsf(" bb7  ba7  bt7");
	__POINTW1FN _0x0,785
	CALL SUBOPT_0x1
; 0000 04FB         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x27
; 0000 04FC         sprintf(lcd," %d  %d  %d",bb7,ba7,bt7);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x32
	LDS  R30,_bb7
	CALL SUBOPT_0x2C
	MOV  R30,R12
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x33
; 0000 04FD         lcd_puts(lcd);
	CALL SUBOPT_0x38
; 0000 04FE         delay_ms(10);
; 0000 04FF 
; 0000 0500         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x16C
; 0000 0501         {
; 0000 0502             delay_ms(150);
	CALL SUBOPT_0x36
; 0000 0503             goto selesai;
	RJMP _0x16D
; 0000 0504         }
; 0000 0505     }
_0x16C:
	RJMP _0x168
; 0000 0506     selesai:
_0x16D:
; 0000 0507     lcd_clear();
_0x2080004:
	CALL _lcd_clear
; 0000 0508 }
	RET
;
;void auto_scan()
; 0000 050B {
_auto_scan:
; 0000 050C     for(;;)
_0x16F:
; 0000 050D     {
; 0000 050E     read_adc(0);
	CALL SUBOPT_0xE
; 0000 050F         if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
	CALL SUBOPT_0xE
	MOV  R26,R30
	LDS  R30,_bb0
	CP   R26,R30
	BRSH _0x171
	CALL SUBOPT_0xE
	STS  _bb0,R30
; 0000 0510         if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
_0x171:
	CALL SUBOPT_0xE
	MOV  R26,R30
	LDS  R30,_ba0
	CP   R30,R26
	BRSH _0x172
	CALL SUBOPT_0xE
	STS  _ba0,R30
; 0000 0511 
; 0000 0512         bt0=((bb0+ba0)/2);
_0x172:
	CALL SUBOPT_0x30
; 0000 0513 
; 0000 0514     read_adc(1);
	CALL SUBOPT_0xF
; 0000 0515         if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
	CALL SUBOPT_0xF
	MOV  R26,R30
	LDS  R30,_bb1
	CP   R26,R30
	BRSH _0x173
	CALL SUBOPT_0xF
	STS  _bb1,R30
; 0000 0516         if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
_0x173:
	CALL SUBOPT_0xF
	MOV  R26,R30
	LDS  R30,_ba1
	CP   R30,R26
	BRSH _0x174
	CALL SUBOPT_0xF
	STS  _ba1,R30
; 0000 0517 
; 0000 0518         bt1=((bb1+ba1)/2);
_0x174:
	CALL SUBOPT_0x35
; 0000 0519 
; 0000 051A     read_adc(2);
	CALL SUBOPT_0x10
; 0000 051B         if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
	CALL SUBOPT_0x10
	MOV  R26,R30
	LDS  R30,_bb2
	CP   R26,R30
	BRSH _0x175
	CALL SUBOPT_0x10
	STS  _bb2,R30
; 0000 051C         if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
_0x175:
	CALL SUBOPT_0x10
	MOV  R26,R30
	LDS  R30,_ba2
	CP   R30,R26
	BRSH _0x176
	CALL SUBOPT_0x10
	STS  _ba2,R30
; 0000 051D 
; 0000 051E         bt2=((bb2+ba2)/2);
_0x176:
	CALL SUBOPT_0x37
; 0000 051F 
; 0000 0520     read_adc(3);
	CALL SUBOPT_0x11
; 0000 0521         if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
	CALL SUBOPT_0x11
	MOV  R26,R30
	LDS  R30,_bb3
	CP   R26,R30
	BRSH _0x177
	CALL SUBOPT_0x11
	STS  _bb3,R30
; 0000 0522         if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
_0x177:
	CALL SUBOPT_0x11
	MOV  R26,R30
	LDS  R30,_ba3
	CP   R30,R26
	BRSH _0x178
	CALL SUBOPT_0x11
	STS  _ba3,R30
; 0000 0523 
; 0000 0524         bt3=((bb3+ba3)/2);
_0x178:
	CALL SUBOPT_0x39
; 0000 0525 
; 0000 0526     read_adc(4);
	CALL SUBOPT_0x12
; 0000 0527         if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
	CALL SUBOPT_0x12
	MOV  R26,R30
	LDS  R30,_bb4
	CP   R26,R30
	BRSH _0x179
	CALL SUBOPT_0x12
	STS  _bb4,R30
; 0000 0528         if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
_0x179:
	CALL SUBOPT_0x12
	MOV  R26,R30
	LDS  R30,_ba4
	CP   R30,R26
	BRSH _0x17A
	CALL SUBOPT_0x12
	STS  _ba4,R30
; 0000 0529 
; 0000 052A         bt4=((bb4+ba4)/2);
_0x17A:
	CALL SUBOPT_0x3A
; 0000 052B 
; 0000 052C     read_adc(5);
	CALL SUBOPT_0x13
; 0000 052D         if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
	CALL SUBOPT_0x13
	MOV  R26,R30
	LDS  R30,_bb5
	CP   R26,R30
	BRSH _0x17B
	CALL SUBOPT_0x13
	STS  _bb5,R30
; 0000 052E         if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
_0x17B:
	CALL SUBOPT_0x13
	MOV  R26,R30
	LDS  R30,_ba5
	CP   R30,R26
	BRSH _0x17C
	CALL SUBOPT_0x13
	STS  _ba5,R30
; 0000 052F 
; 0000 0530         bt5=((bb5+ba5)/2);
_0x17C:
	CALL SUBOPT_0x3B
; 0000 0531 
; 0000 0532     read_adc(6);
	CALL SUBOPT_0x14
; 0000 0533         if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_bb6
	CP   R26,R30
	BRSH _0x17D
	CALL SUBOPT_0x14
	STS  _bb6,R30
; 0000 0534         if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
_0x17D:
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_ba6
	CP   R30,R26
	BRSH _0x17E
	CALL SUBOPT_0x14
	STS  _ba6,R30
; 0000 0535 
; 0000 0536         bt6=((bb6+ba6)/2);
_0x17E:
	CALL SUBOPT_0x3C
; 0000 0537 
; 0000 0538     read_adc(7);
	CALL SUBOPT_0x15
; 0000 0539         if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_bb7
	CP   R26,R30
	BRSH _0x17F
	CALL SUBOPT_0x15
	STS  _bb7,R30
; 0000 053A         if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
_0x17F:
	CALL SUBOPT_0x15
	CP   R12,R30
	BRSH _0x180
	CALL SUBOPT_0x15
	MOV  R12,R30
; 0000 053B 
; 0000 053C         bt7=((bb7+ba7)/2);
_0x180:
	CALL SUBOPT_0x3D
; 0000 053D 
; 0000 053E         lcd_clear();
; 0000 053F         lcd_gotoxy(1,0);
; 0000 0540         sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x19
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x18
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x17
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2F
; 0000 0541         lcd_puts(lcd);
	CALL _lcd_puts
; 0000 0542         delay_ms(120);
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x4
; 0000 0543 
; 0000 0544         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x181
; 0000 0545         {
; 0000 0546                 //showMenu();
; 0000 0547                 lcd_clear();
	CALL SUBOPT_0x31
; 0000 0548                 lcd_gotoxy(1,0);
; 0000 0549                 sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x19
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x18
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x17
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2F
; 0000 054A                 lcd_puts(lcd);
	CALL _lcd_puts
; 0000 054B         }
; 0000 054C     }
_0x181:
	RJMP _0x16F
; 0000 054D }
;
;void ikuti_garis()
; 0000 0550 {
_ikuti_garis:
; 0000 0551         baca_sensor();
	CALL _baca_sensor
; 0000 0552 
; 0000 0553         if((sensor==0b00000001) || (0b11111110)){bkan();      lpwm = 100;       rpwm = 70;      error = 15;     x=1;}  //kanan
	LDI  R30,LOW(1)
	CP   R30,R5
	BREQ _0x183
	LDI  R30,LOW(254)
	CPI  R30,0
	BREQ _0x182
_0x183:
	RCALL _bkan
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x3F
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x40
; 0000 0554         if((sensor==0b00000011) || (0b11111100)){maju();      lpwm = 90;        rpwm = 70;error = 10;     x=1;}
_0x182:
	LDI  R30,LOW(3)
	CP   R30,R5
	BREQ _0x186
	LDI  R30,LOW(252)
	CPI  R30,0
	BREQ _0x185
_0x186:
	RCALL _maju
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x3F
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x40
; 0000 0555         if((sensor==0b00000010) || (0b11111101)){maju();      lpwm = 80;        rpwm = 70;error = 8;      x=1;}
_0x185:
	LDI  R30,LOW(2)
	CP   R30,R5
	BREQ _0x189
	LDI  R30,LOW(253)
	CPI  R30,0
	BREQ _0x188
_0x189:
	RCALL _maju
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x3F
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x40
; 0000 0556         if((sensor==0b00000110) || (0b11111001)){maju();      lpwm = 70;        rpwm = 70;error = 5;      x=1;}
_0x188:
	LDI  R30,LOW(6)
	CP   R30,R5
	BREQ _0x18C
	LDI  R30,LOW(249)
	CPI  R30,0
	BREQ _0x18B
_0x18C:
	CALL SUBOPT_0x41
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x40
; 0000 0557         if((sensor==0b00000100) || (0b11111011)){maju();      lpwm = 70;        rpwm = 70;error = 3;      x=1;}
_0x18B:
	LDI  R30,LOW(4)
	CP   R30,R5
	BREQ _0x18F
	LDI  R30,LOW(251)
	CPI  R30,0
	BREQ _0x18E
_0x18F:
	CALL SUBOPT_0x41
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x40
; 0000 0558         if((sensor==0b00001100) || (0b11110011)){maju();      lpwm = 70;        rpwm = 70;error = 2;      x=1;}
_0x18E:
	LDI  R30,LOW(12)
	CP   R30,R5
	BREQ _0x192
	LDI  R30,LOW(243)
	CPI  R30,0
	BREQ _0x191
_0x192:
	CALL SUBOPT_0x41
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x40
; 0000 0559         if((sensor==0b00001000) || (0b11110111)){maju();      lpwm = 70;        rpwm = 70;error = 1;      x=1;}
_0x191:
	LDI  R30,LOW(8)
	CP   R30,R5
	BREQ _0x195
	LDI  R30,LOW(247)
	CPI  R30,0
	BREQ _0x194
_0x195:
	CALL SUBOPT_0x41
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x40
; 0000 055A 
; 0000 055B         if((sensor==0b00010000) || (0b11101111)){maju();      rpwm = 70;        lpwm = 70;error = -1;     x=0;}
_0x194:
	LDI  R30,LOW(16)
	CP   R30,R5
	BREQ _0x198
	LDI  R30,LOW(239)
	CPI  R30,0
	BREQ _0x197
_0x198:
	CALL SUBOPT_0x42
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL SUBOPT_0x43
; 0000 055C         if((sensor==0b00110000) || (0b11001111)){maju();      rpwm = 70;        lpwm = 70;error = -2;     x=0;}
_0x197:
	LDI  R30,LOW(48)
	CP   R30,R5
	BREQ _0x19B
	LDI  R30,LOW(207)
	CPI  R30,0
	BREQ _0x19A
_0x19B:
	CALL SUBOPT_0x42
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CALL SUBOPT_0x43
; 0000 055D         if((sensor==0b00100000) || (0b11011111)){maju();      rpwm = 70;        lpwm = 70;error = -3;     x=0;}
_0x19A:
	LDI  R30,LOW(32)
	CP   R30,R5
	BREQ _0x19E
	LDI  R30,LOW(223)
	CPI  R30,0
	BREQ _0x19D
_0x19E:
	CALL SUBOPT_0x42
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	CALL SUBOPT_0x43
; 0000 055E         if((sensor==0b01100000) || (0b10011111)){maju();      rpwm = 70;        lpwm = 70;error = -5;     x=0;}
_0x19D:
	LDI  R30,LOW(96)
	CP   R30,R5
	BREQ _0x1A1
	LDI  R30,LOW(159)
	CPI  R30,0
	BREQ _0x1A0
_0x1A1:
	CALL SUBOPT_0x42
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	CALL SUBOPT_0x43
; 0000 055F         if((sensor==0b01000000) || (0b10111111)){maju();      rpwm = 80;        lpwm = 70;error = -8;     x=0;}
_0x1A0:
	LDI  R30,LOW(64)
	CP   R30,R5
	BREQ _0x1A4
	LDI  R30,LOW(191)
	CPI  R30,0
	BREQ _0x1A3
_0x1A4:
	RCALL _maju
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x44
	LDI  R30,LOW(65528)
	LDI  R31,HIGH(65528)
	CALL SUBOPT_0x43
; 0000 0560         if((sensor==0b11000000) || (0b00111111)){maju();      rpwm = 90;        lpwm = 70;error = -10;    x=0;}
_0x1A3:
	LDI  R30,LOW(192)
	CP   R30,R5
	BREQ _0x1A7
	LDI  R30,LOW(63)
	CPI  R30,0
	BREQ _0x1A6
_0x1A7:
	RCALL _maju
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x44
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	CALL SUBOPT_0x43
; 0000 0561         if((sensor==0b10000000) || (0b01111111)){bkir();      rpwm = 100;error = -15;    x=0;}  //kiri
_0x1A6:
	LDI  R30,LOW(128)
	CP   R30,R5
	BREQ _0x1AA
	LDI  R30,LOW(127)
	CPI  R30,0
	BREQ _0x1A9
_0x1AA:
	RCALL _bkir
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0xD
	LDI  R30,LOW(65521)
	LDI  R31,HIGH(65521)
	CALL SUBOPT_0x43
; 0000 0562 
; 0000 0563         if(sensor==0b11111111)  {maju();        lpwm = 100; rpwm = 100;}
_0x1A9:
	LDI  R30,LOW(255)
	CP   R30,R5
	BRNE _0x1AC
	RCALL _maju
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0xC
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0xD
; 0000 0564 
; 0000 0565        /* if(
; 0000 0566                 (sensor==0b10000001) ||
; 0000 0567                 (sensor==0b11000011) ||
; 0000 0568                 (sensor==0b01000010)
; 0000 0569                 ||
; 0000 056A                 (sensor==0b01111110) ||
; 0000 056B                 (sensor==0b00111100) ||
; 0000 056C                 (sensor==0b10111101))
; 0000 056D                 {
; 0000 056E                         bkir();
; 0000 056F                         error = -20;
; 0000 0570                 }
; 0000 0571 
; 0000 0572         d_error = error-last_error;
; 0000 0573         PV      = (Kp*error)+(Kd*d_error);
; 0000 0574 
; 0000 0575         rpwm=intervalPWM+PV;
; 0000 0576         lpwm=intervalPWM-PV;
; 0000 0577 
; 0000 0578         last_error=error;
; 0000 0579 
; 0000 057A         if(lpwm>=255)       lpwm = 255;
; 0000 057B         if(lpwm<=0)         lpwm = 0;
; 0000 057C 
; 0000 057D         if(rpwm>=255)       rpwm = 255;
; 0000 057E         if(rpwm<=0)         rpwm = 0; */
; 0000 057F 
; 0000 0580         sprintf(lcd_buffer,"%d   %d",lpwm, rpwm);
_0x1AC:
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,800
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
; 0000 0581         lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1F
; 0000 0582         lcd_putsf("                ");
	__POINTW1FN _0x0,808
	CALL SUBOPT_0x1
; 0000 0583         lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1F
; 0000 0584         lcd_puts(lcd_buffer);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
; 0000 0585         delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x4
; 0000 0586 }
	RET
;
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
	CALL SUBOPT_0xA
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0xA
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
	CALL SUBOPT_0x45
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x45
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
	CALL SUBOPT_0x46
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x47
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
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
	CALL SUBOPT_0x46
	CALL SUBOPT_0x49
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
	CALL SUBOPT_0x46
	CALL SUBOPT_0x49
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
	CALL SUBOPT_0x45
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
	CALL SUBOPT_0x45
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
	CALL SUBOPT_0x47
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x45
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
	CALL SUBOPT_0x47
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
	CALL SUBOPT_0x4A
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080003
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x4A
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
_0x2080003:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG

	.CSEG
__lcd_delay_G101:
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
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	RCALL __lcd_delay_G101
    sbi   __lcd_port,__lcd_enable ;EN=1
	RCALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G101:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	RCALL __lcd_write_nibble_G101
    ld    r26,y
    swap  r26
	RCALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	JMP  _0x2080001
__lcd_read_nibble_G101:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G101
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G101
    andi  r30,0xf0
	RET
_lcd_read_byte0_G101:
	CALL __lcd_delay_G101
	RCALL __lcd_read_nibble_G101
    mov   r26,r30
	RCALL __lcd_read_nibble_G101
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G101)
	SBCI R31,HIGH(-__base_y_G101)
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
	BRLO _0x2020004
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
_0x2020004:
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
	JMP  _0x2080001
_lcd_puts:
	ST   -Y,R17
_0x2020005:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020007
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020005
_0x2020007:
	RJMP _0x2080002
_lcd_putsf:
	ST   -Y,R17
_0x2020008:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x202000A
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2020008
_0x202000A:
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
__long_delay_G101:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G101:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G101
    sbi   __lcd_port,__lcd_rd     ;RD=1
	RJMP _0x2080001
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4B
	RCALL __long_delay_G101
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_init_write_G101
	RCALL __long_delay_G101
	LDI  R30,LOW(40)
	CALL SUBOPT_0x4C
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4C
	LDI  R30,LOW(133)
	CALL SUBOPT_0x4C
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G101
	CPI  R30,LOW(0x5)
	BREQ _0x202000B
	LDI  R30,LOW(0)
	RJMP _0x2080001
_0x202000B:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
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
	.BYTE 0x10

	.ESEG
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
	.DB  0x9

	.DSEG
_ba6:
	.BYTE 0x1
_ba5:
	.BYTE 0x1
_ba4:
	.BYTE 0x1
_ba3:
	.BYTE 0x1
_ba2:
	.BYTE 0x1
_ba1:
	.BYTE 0x1
_ba0:
	.BYTE 0x1
_bb7:
	.BYTE 0x1
_bb6:
	.BYTE 0x1
_bb5:
	.BYTE 0x1
_bb4:
	.BYTE 0x1
_bb3:
	.BYTE 0x1
_bb2:
	.BYTE 0x1
_bb1:
	.BYTE 0x1
_bb0:
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
_PV:
	.BYTE 0x2
_error:
	.BYTE 0x2
_last_error:
	.BYTE 0x2
_var_Kp:
	.BYTE 0x2
_var_Ki:
	.BYTE 0x2
_var_Kd:
	.BYTE 0x2
_kursorPID:
	.BYTE 0x1
_kursorSpeed:
	.BYTE 0x1
_kursorGaris:
	.BYTE 0x1
_lcd_buffer:
	.BYTE 0x21
_b:
	.BYTE 0x2
_x:
	.BYTE 0x2

	.ESEG
_Kp:
	.DB  0xA
_Ki:
	.DB  0x5
_Kd:
	.DB  0x7
_MAXSpeed:
	.DB  0xFF
_MINSpeed:
	.DB  0x0
_WarnaGaris:
	.DB  0x0
_SensLine:
	.DB  0x2
_Skenario:
	.DB  0x2
_Mode:
	.DB  0x1

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
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 56 TIMES, CODE SIZE REDUCTION:107 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 78 TIMES, CODE SIZE REDUCTION:151 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	CALL __EEPROMRDB
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x7:
	STS  _lpwm,R30
	STS  _lpwm+1,R30
	LDI  R30,LOW(0)
	STS  _rpwm,R30
	STS  _rpwm+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDS  R26,_b
	LDS  R27,_b+1
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xA:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xB:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0x0,100
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
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xC:
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xD:
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x10:
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(5)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(6)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(7)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x17:
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x18:
	LDI  R26,LOW(_bt2)
	LDI  R27,HIGH(_bt2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x19:
	LDI  R26,LOW(_bt3)
	LDI  R27,HIGH(_bt3)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1A:
	LDI  R26,LOW(_bt4)
	LDI  R27,HIGH(_bt4)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1B:
	LDI  R26,LOW(_bt5)
	LDI  R27,HIGH(_bt5)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_bt6)
	LDI  R27,HIGH(_bt6)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(_bt7)
	LDI  R27,HIGH(_bt7)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	CALL __DIVB21U
	MOV  R17,R30
	SUBI R17,-LOW(48)
	ST   -Y,R17
	CALL _lcd_putchar
	LDD  R26,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:93 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x20:
	CALL _lcd_clear
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 45 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(225)
	LDI  R31,HIGH(225)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(32)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x24:
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _tampil
	RJMP SUBOPT_0x23

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x22

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x26:
	ST   -Y,R30
	CALL _setByte
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x27:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x29:
	__POINTW1FN _0x0,484
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x2A:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 56 TIMES, CODE SIZE REDUCTION:162 WORDS
SUBOPT_0x2C:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2D:
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2E:
	LDS  R26,_xcount
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2F:
	LDI  R24,32
	CALL _sprintf
	ADIW R28,36
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x30:
	LDS  R30,_ba0
	LDS  R26,_bb0
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x31:
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x2A

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x32:
	__POINTW1FN _0x0,683
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x33:
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RJMP SUBOPT_0x2B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x34:
	CALL _lcd_puts
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	LDS  R30,_ba1
	LDS  R26,_bb1
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x36:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x37:
	LDS  R30,_ba2
	LDS  R26,_bb2
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt2)
	LDI  R27,HIGH(_bt2)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x38:
	CALL _lcd_puts
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x39:
	LDS  R30,_ba3
	LDS  R26,_bb3
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt3)
	LDI  R27,HIGH(_bt3)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3A:
	LDS  R30,_ba4
	LDS  R26,_bb4
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt4)
	LDI  R27,HIGH(_bt4)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3B:
	LDS  R30,_ba5
	LDS  R26,_bb5
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt5)
	LDI  R27,HIGH(_bt5)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3C:
	LDS  R30,_ba6
	LDS  R26,_bb6
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt6)
	LDI  R27,HIGH(_bt6)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3D:
	MOV  R30,R12
	LDS  R26,_bb7
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt7)
	LDI  R27,HIGH(_bt7)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	__POINTW1FN _0x0,644
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x3F:
	RCALL SUBOPT_0xC
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x40:
	STS  _error,R30
	STS  _error+1,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _x,R30
	STS  _x+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x41:
	CALL _maju
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x42:
	CALL _maju
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RCALL SUBOPT_0xD
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x43:
	STS  _error,R30
	STS  _error+1,R31
	LDI  R30,LOW(0)
	STS  _x,R30
	STS  _x+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	RCALL SUBOPT_0xD
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x45:
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
SUBOPT_0x46:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x47:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x48:
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
SUBOPT_0x49:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4A:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	CALL __long_delay_G101
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G101

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G101


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

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__MODB21U:
	RCALL __DIVB21U
	MOV  R30,R26
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
