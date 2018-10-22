
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 16.000000 MHz
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
	#pragma AVRPART MEMORY INT_SRAM SIZE 2143
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
	.EQU __SRAM_END=0x085F
	.EQU __DSTACK_SIZE=0x0200
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
	.DEF _d_channel_n=R8
	.DEF __lcd_x=R7
	.DEF __lcd_y=R10
	.DEF __lcd_maxx=R9

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

_channel_f:
	.DB  0x20,0x31,0x2E,0x38,0x30,0x30,0x2E,0x30
	.DB  0x30,0x30,0x20,0x48,0x7A,0x0,0x0,0x20
	.DB  0x31,0x2E,0x39,0x30,0x30,0x2E,0x30,0x30
	.DB  0x30,0x20,0x48,0x7A,0x0,0x0,0x20,0x32
	.DB  0x2E,0x30,0x30,0x30,0x2E,0x30,0x30,0x30
	.DB  0x20,0x48,0x7A,0x0,0x0,0x20,0x33,0x2E
	.DB  0x35,0x30,0x30,0x2E,0x30,0x30,0x30,0x20
	.DB  0x48,0x7A,0x0,0x0,0x20,0x33,0x2E,0x36
	.DB  0x30,0x30,0x2E,0x30,0x30,0x30,0x20,0x48
	.DB  0x7A,0x0,0x0,0x20,0x33,0x2E,0x37,0x30
	.DB  0x30,0x2E,0x30,0x30,0x30,0x20,0x48,0x7A
	.DB  0x0,0x0,0x20,0x33,0x2E,0x38,0x30,0x30
	.DB  0x2E,0x30,0x30,0x30,0x20,0x48,0x7A,0x0
	.DB  0x0,0x20,0x33,0x2E,0x39,0x30,0x30,0x2E
	.DB  0x30,0x30,0x30,0x20,0x48,0x7A,0x0,0x0
	.DB  0x20,0x34,0x2E,0x30,0x30,0x30,0x2E,0x30
	.DB  0x30,0x30,0x20,0x48,0x7A,0x0,0x0,0x20
	.DB  0x37,0x2E,0x30,0x30,0x30,0x2E,0x30,0x30
	.DB  0x30,0x20,0x48,0x7A,0x0,0x0,0x20,0x37
	.DB  0x2E,0x31,0x30,0x30,0x2E,0x30,0x30,0x30
	.DB  0x20,0x48,0x7A,0x0,0x0,0x20,0x37,0x2E
	.DB  0x32,0x30,0x30,0x2E,0x30,0x30,0x30,0x20
	.DB  0x48,0x7A,0x0,0x0,0x20,0x37,0x2E,0x33
	.DB  0x30,0x30,0x2E,0x30,0x30,0x30,0x20,0x48
	.DB  0x7A,0x0,0x0,0x31,0x30,0x2E,0x30,0x30
	.DB  0x30,0x2E,0x30,0x30,0x30,0x20,0x48,0x7A
	.DB  0x0,0x0,0x31,0x30,0x2E,0x31,0x30,0x30
	.DB  0x2E,0x30,0x30,0x30,0x20,0x48,0x7A,0x0
	.DB  0x0,0x31,0x30,0x2E,0x32,0x30,0x30,0x2E
	.DB  0x30,0x30,0x30,0x20,0x48,0x7A,0x0,0x0
	.DB  0x31,0x34,0x2E,0x30,0x30,0x30,0x2E,0x30
	.DB  0x30,0x30,0x20,0x48,0x7A,0x0,0x0,0x31
	.DB  0x34,0x2E,0x31,0x30,0x30,0x2E,0x30,0x30
	.DB  0x30,0x20,0x48,0x7A,0x0,0x0,0x31,0x34
	.DB  0x2E,0x32,0x30,0x30,0x2E,0x30,0x30,0x30
	.DB  0x20,0x48,0x7A,0x0,0x0,0x31,0x34,0x2E
	.DB  0x33,0x30,0x30,0x2E,0x30,0x30,0x30,0x20
	.DB  0x48,0x7A,0x0,0x0,0x31,0x34,0x2E,0x34
	.DB  0x30,0x30,0x2E,0x30,0x30,0x30,0x20,0x48
	.DB  0x7A,0x0,0x0,0x31,0x38,0x2E,0x30,0x30
	.DB  0x30,0x2E,0x30,0x30,0x30,0x20,0x48,0x7A
	.DB  0x0,0x0,0x31,0x38,0x2E,0x31,0x30,0x30
	.DB  0x2E,0x30,0x30,0x30,0x20,0x48,0x7A,0x0
	.DB  0x0,0x31,0x38,0x2E,0x32,0x30,0x30,0x2E
	.DB  0x30,0x30,0x30,0x20,0x48,0x7A,0x0,0x0
	.DB  0x32,0x31,0x2E,0x30,0x30,0x30,0x2E,0x30
	.DB  0x30,0x30,0x20,0x48,0x7A,0x0,0x0,0x32
	.DB  0x31,0x2E,0x31,0x30,0x30,0x2E,0x30,0x30
	.DB  0x30,0x20,0x48,0x7A,0x0,0x0,0x32,0x31
	.DB  0x2E,0x32,0x30,0x30,0x2E,0x30,0x30,0x30
	.DB  0x20,0x48,0x7A,0x0,0x0,0x32,0x31,0x2E
	.DB  0x33,0x30,0x30,0x2E,0x30,0x30,0x30,0x20
	.DB  0x48,0x7A,0x0,0x0,0x32,0x31,0x2E,0x34
	.DB  0x30,0x30,0x2E,0x30,0x30,0x30,0x20,0x48
	.DB  0x7A,0x0,0x0,0x32,0x31,0x2E,0x35,0x30
	.DB  0x30,0x2E,0x30,0x30,0x30,0x20,0x48,0x7A
	.DB  0x0,0x0
_channel_a:
	.DB  0x0,0x0,0x0,0x0,0x1,0x1,0x1,0x0
	.DB  0x1,0x0,0x1,0x1,0x1,0x1,0x1,0x0
	.DB  0x1,0x1,0x0,0x1,0x1,0x1,0x1,0x1
	.DB  0x1,0x0,0x1,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x1,0x1,0x1,0x1,0x1,0x0
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x1,0x0,0x1,0x1,0x0,0x1,0x0
	.DB  0x1,0x1,0x1,0x0,0x0,0x0,0x0,0x1
	.DB  0x0,0x0,0x0,0x0,0x0,0x1,0x1,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x1,0x0,0x0
	.DB  0x1,0x1,0x0,0x1,0x1,0x1,0x0,0x1
	.DB  0x0,0x0,0x0,0x0,0x0,0x1,0x1,0x1
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x1,0x1
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x1,0x1,0x0,0x1
	.DB  0x0,0x1,0x1,0x1,0x1,0x1,0x0,0x1
	.DB  0x1,0x0,0x1,0x1,0x1,0x1,0x1,0x1
	.DB  0x0,0x1,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x1,0x1,0x1,0x1,0x0,0x0,0x1
	.DB  0x0,0x0,0x1,0x1,0x1,0x1,0x0,0x1
	.DB  0x1,0x1,0x0,0x1,0x1,0x0,0x0,0x1
	.DB  0x0,0x1,0x1,0x1,0x0,0x0,0x0,0x1
	.DB  0x1,0x1,0x1,0x1,0x0,0x0,0x1,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x1,0x0
	.DB  0x1,0x1,0x0,0x1,0x0,0x1,0x1,0x1
	.DB  0x0,0x1,0x0,0x0,0x0,0x1,0x1,0x1
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x0,0x0
	.DB  0x1,0x0,0x1,0x1,0x1,0x0,0x0,0x1
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x1,0x1
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x1,0x0,0x0,0x0,0x1,0x0,0x0
	.DB  0x1,0x0,0x0,0x1,0x1,0x0,0x1,0x1
	.DB  0x1,0x0,0x1,0x0,0x0,0x1,0x0,0x0
	.DB  0x1,0x1,0x1,0x0,0x0,0x1,0x0,0x1
	.DB  0x0,0x1,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x1,0x1
	.DB  0x1,0x0,0x1,0x0,0x0,0x0,0x1,0x0
	.DB  0x1,0x0,0x0,0x1,0x1,0x1,0x0,0x0
	.DB  0x0,0x1,0x1,0x1,0x0,0x1,0x1,0x1
	.DB  0x1,0x0,0x0,0x0,0x1,0x1,0x1,0x0
	.DB  0x1,0x0,0x1,0x1,0x1,0x1,0x1,0x0
	.DB  0x1,0x1,0x0,0x1,0x1,0x1,0x1,0x1
	.DB  0x1,0x0,0x1,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x1,0x1,0x1,0x0,0x1,0x1
	.DB  0x1,0x1,0x0,0x0,0x1,0x1,0x0,0x1
	.DB  0x0,0x0,0x1,0x1,0x0,0x1,0x0,0x1
	.DB  0x1,0x0,0x1,0x0,0x1,0x0,0x0,0x1
	.DB  0x0,0x1,0x0,0x0,0x0,0x1,0x1,0x1
	.DB  0x1,0x0,0x1,0x0,0x1,0x1,0x1,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x1,0x0,0x0
	.DB  0x0,0x1,0x1,0x1,0x0,0x1,0x0,0x1
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x1,0x1
	.DB  0x1,0x1,0x0,0x1,0x0,0x0,0x1,0x1
	.DB  0x1,0x1,0x0,0x0,0x0,0x0,0x1,0x1
	.DB  0x0,0x1,0x0,0x1,0x0,0x1,0x0,0x0
	.DB  0x1,0x1,0x1,0x0,0x0,0x0,0x1,0x1
	.DB  0x1,0x0,0x1,0x1,0x1,0x1,0x0,0x0
	.DB  0x1,0x1,0x0,0x1,0x0,0x0,0x1,0x1
	.DB  0x0,0x1,0x1,0x1,0x0,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x1,0x0,0x0,0x0,0x1,0x0,0x1
	.DB  0x1,0x1,0x0,0x0,0x1,0x1,0x1,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x1,0x1,0x1
	.DB  0x0,0x1,0x0,0x1,0x1,0x1,0x1,0x1
	.DB  0x0,0x1,0x1,0x0,0x0,0x1,0x1,0x1
	.DB  0x0,0x1,0x0,0x0,0x0,0x1,0x0,0x1
	.DB  0x0,0x0,0x1,0x1,0x1,0x0,0x0,0x0
	.DB  0x1,0x1,0x1,0x0,0x1,0x1,0x1,0x1
	.DB  0x0,0x0,0x0,0x1,0x1,0x1,0x0,0x1
	.DB  0x0,0x1,0x0,0x0,0x1,0x0,0x0,0x1
	.DB  0x0,0x1,0x0,0x1,0x0,0x0,0x0,0x1
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x1,0x1,0x1,0x0,0x1,0x0,0x1
	.DB  0x1,0x1,0x1,0x1,0x0,0x1,0x1,0x0
	.DB  0x1,0x1,0x1,0x1,0x1,0x1,0x0,0x1
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x1,0x0
	.DB  0x0,0x1,0x0,0x0,0x1,0x1,0x0,0x1
	.DB  0x1,0x1,0x0,0x1,0x0,0x0,0x1,0x0
	.DB  0x1,0x1,0x1,0x1,0x0,0x0,0x0,0x1
	.DB  0x1,0x0,0x1,0x0,0x1,0x0,0x0,0x1
	.DB  0x0,0x1,0x0,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x1,0x1,0x0,0x0,0x1,0x1,0x1
	.DB  0x0,0x0,0x1,0x1,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x1,0x0,0x1
	.DB  0x0,0x1,0x0,0x0,0x0,0x1,0x1,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x0,0x0,0x1,0x1,0x0
	.DB  0x1,0x0,0x1,0x0,0x1,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x1,0x0,0x0,0x0,0x1
	.DB  0x0,0x0,0x1,0x0,0x0,0x1,0x1,0x0
	.DB  0x1,0x0,0x1,0x1,0x0,0x0,0x1,0x1
	.DB  0x0,0x1,0x1,0x0,0x0,0x1,0x1,0x1
	.DB  0x1,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x1,0x1,0x1,0x1,0x0,0x1,0x0
	.DB  0x1,0x1,0x0,0x1,0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x1,0x1,0x0,0x0,0x1
	.DB  0x1,0x1,0x1,0x1,0x0,0x1,0x0,0x1
	.DB  0x0,0x1,0x1,0x0,0x1,0x0,0x1,0x1
	.DB  0x1,0x0,0x0,0x1,0x1,0x1,0x1,0x1
	.DB  0x0,0x1,0x0,0x1,0x0,0x1,0x0,0x1
	.DB  0x1,0x0,0x0,0x1,0x1,0x0,0x1,0x1
	.DB  0x1,0x0,0x1,0x0,0x1,0x1,0x1,0x1
	.DB  0x0,0x1,0x0,0x0,0x1,0x1,0x1,0x1
	.DB  0x0,0x0,0x0,0x0,0x1,0x1,0x0,0x1
	.DB  0x1,0x0,0x0,0x0,0x0,0x1,0x1,0x0
	.DB  0x1,0x1,0x0,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x1,0x1
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x1,0x0
	.DB  0x0,0x1,0x1,0x0
_channel_b:
	.DB  0x0,0x0,0x0,0x0,0x1,0x1,0x1,0x0
	.DB  0x1,0x0,0x1,0x1,0x1,0x1,0x1,0x0
	.DB  0x1,0x1,0x0,0x1,0x1,0x1,0x1,0x1
	.DB  0x1,0x0,0x1,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x1,0x1,0x1,0x1
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x1
	.DB  0x0,0x0,0x1,0x0,0x1,0x1,0x0,0x1
	.DB  0x0,0x1,0x1,0x1,0x0,0x1,0x0,0x0
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x1,0x0,0x0,0x0,0x1,0x0,0x0,0x1
	.DB  0x0,0x0,0x1,0x1,0x0,0x1,0x1,0x1
	.DB  0x0,0x1,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x1,0x1,0x1,0x0,0x0,0x1,0x0,0x1
	.DB  0x0,0x1,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x1,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x0,0x1
	.DB  0x1,0x1,0x0,0x1,0x0,0x1,0x1,0x1
	.DB  0x1,0x1,0x0,0x1,0x1,0x0,0x1,0x1
	.DB  0x1,0x1,0x1,0x1,0x0,0x1,0x0,0x0
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x1,0x1
	.DB  0x1,0x1,0x0,0x0,0x1,0x0,0x0,0x1
	.DB  0x1,0x1,0x1,0x0,0x1,0x1,0x1,0x0
	.DB  0x1,0x1,0x0,0x0,0x1,0x0,0x1,0x1
	.DB  0x1,0x1,0x0,0x0,0x0,0x1,0x1,0x1
	.DB  0x1,0x1,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x1,0x0,0x0,0x1,0x0,0x1,0x1
	.DB  0x0,0x1,0x0,0x1,0x1,0x1,0x0,0x1
	.DB  0x1,0x0,0x0,0x0,0x1,0x1,0x1,0x1
	.DB  0x1,0x1,0x1,0x1,0x1,0x0,0x0,0x1
	.DB  0x0,0x1,0x1,0x1,0x0,0x0,0x1,0x0
	.DB  0x0,0x1,0x0,0x0,0x0,0x1,0x1,0x1
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x1,0x0,0x0,0x0,0x1,0x0,0x0
	.DB  0x1,0x0,0x0,0x1,0x1,0x0,0x1,0x1
	.DB  0x1,0x0,0x1,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x1,0x1,0x1,0x0,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x1,0x0,0x0,0x0,0x1,0x0,0x0
	.DB  0x1,0x1,0x1,0x0,0x1,0x0,0x0,0x0
	.DB  0x1,0x0,0x1,0x0,0x0,0x1,0x1,0x1
	.DB  0x0,0x0,0x0,0x1,0x1,0x1,0x0,0x1
	.DB  0x1,0x1,0x1,0x0,0x0,0x0,0x0,0x1
	.DB  0x1,0x1,0x0,0x1,0x0,0x1,0x1,0x1
	.DB  0x1,0x1,0x0,0x1,0x1,0x0,0x1,0x1
	.DB  0x1,0x1,0x1,0x1,0x0,0x1,0x0,0x0
	.DB  0x1,0x0,0x0,0x0,0x0,0x0,0x1,0x1
	.DB  0x1,0x0,0x1,0x1,0x1,0x1,0x0,0x0
	.DB  0x1,0x1,0x0,0x1,0x0,0x0,0x1,0x1
	.DB  0x0,0x1,0x0,0x1,0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x0,0x0,0x1,0x0,0x1,0x0
	.DB  0x0,0x0,0x1,0x1,0x1,0x1,0x0,0x1
	.DB  0x0,0x1,0x1,0x1,0x0,0x0,0x0,0x0
	.DB  0x1,0x0,0x1,0x0,0x0,0x0,0x1,0x1
	.DB  0x1,0x1,0x0,0x1,0x0,0x1,0x0,0x0
	.DB  0x1,0x0,0x1,0x0,0x1,0x1,0x1,0x1
	.DB  0x0,0x1,0x0,0x0,0x1,0x1,0x1,0x1
	.DB  0x0,0x0,0x0,0x0,0x1,0x1,0x0,0x1
	.DB  0x1,0x0,0x1,0x0,0x1,0x0,0x0,0x1
	.DB  0x1,0x1,0x0,0x0,0x0,0x1,0x1,0x1
	.DB  0x0,0x1,0x1,0x1,0x1,0x0,0x0,0x1
	.DB  0x1,0x0,0x1,0x0,0x0,0x1,0x1,0x0
	.DB  0x0,0x1,0x1,0x1,0x0,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x1,0x1,0x0,0x0,0x0,0x1,0x0,0x0
	.DB  0x1,0x1,0x1,0x0,0x0,0x1,0x1,0x1
	.DB  0x0,0x0,0x0,0x0,0x0,0x0,0x1,0x1
	.DB  0x1,0x0,0x1,0x0,0x1,0x1,0x1,0x1
	.DB  0x1,0x0,0x1,0x1,0x0,0x1,0x0,0x1
	.DB  0x1,0x1,0x0,0x1,0x0,0x0,0x0,0x1
	.DB  0x0,0x1,0x0,0x0,0x1,0x1,0x1,0x0
	.DB  0x0,0x0,0x1,0x1,0x1,0x0,0x1,0x1
	.DB  0x1,0x1,0x0,0x0,0x1,0x0,0x1,0x1
	.DB  0x1,0x0,0x1,0x0,0x1,0x0,0x0,0x1
	.DB  0x0,0x0,0x1,0x0,0x1,0x0,0x1,0x0
	.DB  0x0,0x0,0x1,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x1,0x0,0x1,0x0,0x1,0x1,0x1
	.DB  0x0,0x1,0x0,0x1,0x1,0x1,0x1,0x1
	.DB  0x0,0x1,0x1,0x0,0x1,0x1,0x1,0x1
	.DB  0x1,0x1,0x0,0x1,0x0,0x0,0x1,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x1,0x0
	.DB  0x0,0x1,0x1,0x0,0x1,0x1,0x1,0x0
	.DB  0x1,0x0,0x0,0x1,0x0,0x1,0x1,0x1
	.DB  0x1,0x0,0x0,0x0,0x1,0x1,0x0,0x1
	.DB  0x0,0x1,0x1,0x0,0x0,0x1,0x0,0x1
	.DB  0x0,0x0,0x0,0x1,0x0,0x0,0x0,0x1
	.DB  0x1,0x0,0x0,0x1,0x1,0x1,0x0,0x0
	.DB  0x1,0x1,0x1,0x0,0x0,0x0,0x0,0x0
	.DB  0x0,0x1,0x0,0x0,0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x0,0x0,0x1,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x0,0x1,0x0,0x1
	.DB  0x0,0x1,0x0,0x0,0x1,0x1,0x0,0x0
	.DB  0x1,0x0,0x1,0x0,0x1,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x0,0x1,0x0,0x0,0x0
	.DB  0x0,0x0,0x1,0x1,0x0,0x0,0x0,0x1
	.DB  0x0,0x0,0x1,0x0,0x0,0x1,0x1,0x1
	.DB  0x0,0x1,0x0,0x1,0x1,0x0,0x0,0x1
	.DB  0x1,0x0,0x1,0x1,0x0,0x0,0x1,0x1
	.DB  0x1,0x1,0x0,0x1,0x0,0x0,0x0,0x0
	.DB  0x0,0x1,0x1,0x1,0x1,0x1,0x1,0x0
	.DB  0x1,0x0,0x1,0x1,0x0,0x1,0x1,0x0
	.DB  0x1,0x0,0x1,0x0,0x1,0x1,0x1,0x0
	.DB  0x0,0x1,0x1,0x1,0x1,0x1,0x0,0x1
	.DB  0x0,0x1,0x0,0x1,0x0,0x1,0x0,0x1
	.DB  0x0,0x1,0x1,0x1,0x0,0x0,0x1,0x1
	.DB  0x1,0x1,0x1,0x0,0x1,0x0,0x1,0x0
	.DB  0x1,0x0,0x1,0x1,0x0,0x0,0x1,0x1
	.DB  0x0,0x1,0x1,0x0,0x1,0x0,0x1,0x0
	.DB  0x1,0x1,0x1,0x1,0x0,0x1,0x0,0x0
	.DB  0x1,0x1,0x1,0x1,0x0,0x0,0x0,0x0
	.DB  0x1,0x1,0x0,0x1,0x1,0x0,0x0,0x0
	.DB  0x0,0x1,0x0,0x1,0x0,0x1,0x1,0x0
	.DB  0x0,0x0,0x0,0x0,0x0,0x1,0x0,0x0
	.DB  0x0,0x0,0x0,0x1,0x1,0x0,0x0,0x0
	.DB  0x1,0x0,0x0,0x1,0x0,0x0,0x1,0x1
	.DB  0x0,0x1
_tbl10_G102:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G102:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x43,0x68,0x61,0x6E,0x6E,0x65,0x6C,0x3A
	.DB  0x20,0x25,0x32,0x69,0x20,0x41,0x0,0x43
	.DB  0x68,0x61,0x6E,0x6E,0x65,0x6C,0x3A,0x20
	.DB  0x25,0x32,0x69,0x20,0x42,0x0,0x46,0x3A
	.DB  0x20,0x0,0x25,0x63,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

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
	.ORG 0x260

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
;Date    : 9/8/2013
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32A
;Program type            : Application
;AVR Core Clock frequency: 16.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 512
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
;
;// Alphanumeric LCD Module functions
;#include <stdlib.h>
;#include <stdint.h>
;#include <alcd.h>
;#include <delay.h>
;
;// Declare your global variables here
;
;#include <stdio.h>
;
;#define CLK     PORTB.1
;#define FUD     PORTB.2
;#define DAT     PORTB.3
;#define RST     PORTB.4
;#define DAT_2   PORTB.0
;
;#define T_DOWN  PINA.0
;#define T_UP    PINA.1
;#define S_DOWN  PINA.2
;#define S_UP    PINA.3
;
;#define LOW     0
;#define HIGH    1
;
;eeprom int channel_n = 9;
;flash char channel_f[30][15] =
;{
;" 1.800.000 Hz", // 1
;" 1.900.000 Hz", // 2
;" 2.000.000 Hz", // 3
;
;" 3.500.000 Hz", // 4
;" 3.600.000 Hz", // 5
;" 3.700.000 Hz", // 6
;" 3.800.000 Hz", // 7
;" 3.900.000 Hz", // 8
;" 4.000.000 Hz", // 9
;
;" 7.000.000 Hz", // 10
;" 7.100.000 Hz", // 11
;" 7.200.000 Hz", // 12
;" 7.300.000 Hz", // 13
;
;"10.000.000 Hz", // 14
;"10.100.000 Hz", // 15
;"10.200.000 Hz", // 16
;
;"14.000.000 Hz", // 17
;"14.100.000 Hz", // 18
;"14.200.000 Hz", // 19
;"14.300.000 Hz", // 20
;"14.400.000 Hz", // 21
;
;"18.000.000 Hz", // 22
;"18.100.000 Hz", // 23
;"18.200.000 Hz", // 24
;
;"21.000.000 Hz", // 25
;"21.100.000 Hz", // 26
;"21.200.000 Hz", // 27
;"21.300.000 Hz", // 28
;"21.400.000 Hz", // 29
;"21.500.000 Hz"  // 30
;};
;
;eeprom int mode = 1;
;
;flash char channel_a[30][30] =
;{
;0,0,0,0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,0,0,1,  // 1800000
;0,0,0,0,1,1,1,1,1,0,0,1,0,0,0,0,1,0,0,1,0,1,1,0,1,0,1,1,1,0,  // 1900000
;0,0,0,1,0,0,0,0,0,1,1,0,0,0,1,0,0,1,0,0,1,1,0,1,1,1,0,1,0,0,  // 2000000
;
;0,0,0,1,1,1,0,0,1,0,1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,  // 3500000
;0,0,0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,0,0,1,0,  // 3600000
;0,0,0,1,1,1,1,0,0,1,0,0,1,1,1,1,0,1,1,1,0,1,1,0,0,1,0,1,1,1,  // 3700000
;0,0,0,1,1,1,1,1,0,0,1,0,0,0,0,1,0,0,1,0,1,1,0,1,0,1,1,1,0,1,  // 3800000
;0,0,0,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,1,0,0,1,0,0,1,0,0,0,1,1,  // 3900000
;0,0,1,0,0,0,0,0,1,1,0,0,0,1,0,0,1,0,0,1,1,0,1,1,1,0,1,0,0,1,  // 4000000
;
;0,0,1,1,1,0,0,1,0,1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,  // 7000000
;0,0,1,1,1,0,1,0,0,0,1,0,1,0,0,1,1,1,0,0,0,1,1,1,0,1,1,1,1,0,  // 7100000
;0,0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,0,0,1,0,0,  // 7200000
;0,0,1,1,1,0,1,1,1,1,0,0,1,1,0,1,0,0,1,1,0,1,0,1,1,0,1,0,1,0,  // 7300000
;
;0,1,0,1,0,0,0,1,1,1,1,0,1,0,1,1,1,0,0,0,0,1,0,1,0,0,0,1,1,1,  // 10000000
;0,1,0,1,0,0,1,0,1,0,1,1,1,1,0,1,0,0,1,1,1,1,0,0,0,0,1,1,0,1,  // 10100000
;0,1,0,1,0,0,1,1,1,0,0,0,1,1,1,0,1,1,1,1,0,0,1,1,0,1,0,0,1,1,  // 10200000
;
;0,1,1,1,0,0,1,0,1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,1,  // 14000000
;0,1,1,1,0,0,1,1,1,0,0,0,0,0,0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,0,  // 14100000
;0,1,1,1,0,1,0,0,0,1,0,1,0,0,1,1,1,0,0,0,1,1,1,0,1,1,1,1,0,0,  // 14200000
;0,1,1,1,0,1,0,1,0,0,1,0,0,1,0,1,0,1,0,0,0,1,1,0,0,0,0,0,1,0,  // 14300000
;0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,0,0,1,0,0,0,  // 14400000
;
;1,0,0,1,0,0,1,1,0,1,1,1,0,1,0,0,1,0,1,1,1,1,0,0,0,1,1,0,1,0,  // 18000000
;1,0,0,1,0,1,0,0,0,1,0,0,0,1,1,0,0,1,1,1,0,0,1,1,1,0,0,0,0,0,  // 18100000
;1,0,0,1,0,1,0,1,0,0,0,1,1,0,0,0,0,0,1,0,1,0,1,0,1,0,0,1,1,0,  // 18200000
;
;1,0,1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,1,0,0,1,0,0,1,  // 21000000
;1,0,1,0,1,1,0,0,1,1,0,1,1,0,0,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,  // 21100000
;1,0,1,0,1,1,0,1,1,0,1,0,1,0,1,1,1,0,0,1,1,1,1,1,0,1,0,1,0,1,  // 21200000
;1,0,1,0,1,1,1,0,0,1,1,1,1,1,0,1,0,1,0,1,0,1,1,0,0,1,1,0,1,1,  // 21300000
;1,0,1,0,1,1,1,1,0,1,0,0,1,1,1,1,0,0,0,0,1,1,0,1,1,0,0,0,0,1,  // 21400000
;1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,1,0,0,1,0,0,1,1,0   // 21500000
;};
;
;flash char channel_b[30][31] =
;{
;0,0,0,0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,0,0,1,0,  // 3600000
;0,0,0,0,1,1,1,1,1,0,0,1,0,0,0,0,1,0,0,1,0,1,1,0,1,0,1,1,1,0,1,  // 3800000
;0,0,0,1,0,0,0,0,0,1,1,0,0,0,1,0,0,1,0,0,1,1,0,1,1,1,0,1,0,0,1,  // 4000000
;
;0,0,0,1,1,1,0,0,1,0,1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,  // 7000000
;0,0,0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,0,0,1,0,0,  // 7200000
;0,0,0,1,1,1,1,0,0,1,0,0,1,1,1,1,0,1,1,1,0,1,1,0,0,1,0,1,1,1,1,  // 7400000
;0,0,0,1,1,1,1,1,0,0,1,0,0,0,0,1,0,0,1,0,1,1,0,1,0,1,1,1,0,1,1,  // 7600000
;0,0,0,1,1,1,1,1,1,1,1,1,0,0,1,0,1,1,1,0,0,1,0,0,1,0,0,0,1,1,1,  // 7800000
;0,0,1,0,0,0,0,0,1,1,0,0,0,1,0,0,1,0,0,1,1,0,1,1,1,0,1,0,0,1,0,  // 8000000
;
;0,0,1,1,1,0,0,1,0,1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,1,  // 14000000
;0,0,1,1,1,0,1,0,0,0,1,0,1,0,0,1,1,1,0,0,0,1,1,1,0,1,1,1,1,0,0,  // 14200000
;0,0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,0,0,1,0,0,0,  // 14400000
;0,0,1,1,1,0,1,1,1,1,0,0,1,1,0,1,0,0,1,1,0,1,0,1,1,0,1,0,1,0,0,  // 14600000
;
;0,1,0,1,0,0,0,1,1,1,1,0,1,0,1,1,1,0,0,0,0,1,0,1,0,0,0,1,1,1,1,  // 20000000
;0,1,0,1,0,0,1,0,1,0,1,1,1,1,0,1,0,0,1,1,1,1,0,0,0,0,1,1,0,1,1,  // 20200000
;0,1,0,1,0,0,1,1,1,0,0,0,1,1,1,0,1,1,1,1,0,0,1,1,0,1,0,0,1,1,0,  // 20400000
;
;0,1,1,1,0,0,1,0,1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,1,0,  // 28000000
;0,1,1,1,0,0,1,1,1,0,0,0,0,0,0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,  // 28200000
;0,1,1,1,0,1,0,0,0,1,0,1,0,0,1,1,1,0,0,0,1,1,1,0,1,1,1,1,0,0,1,  // 28400000
;0,1,1,1,0,1,0,1,0,0,1,0,0,1,0,1,0,1,0,0,0,1,1,0,0,0,0,0,1,0,1,  // 28600000
;0,1,1,1,0,1,0,1,1,1,1,1,0,1,1,0,1,1,1,1,1,1,0,1,0,0,1,0,0,0,0,  // 28800000
;
;1,0,0,1,0,0,1,1,0,1,1,1,0,1,0,0,1,0,1,1,1,1,0,0,0,1,1,0,1,0,1,  // 36000000
;1,0,0,1,0,1,0,0,0,1,0,0,0,1,1,0,0,1,1,1,0,0,1,1,1,0,0,0,0,0,0,  // 36200000
;1,0,0,1,0,1,0,1,0,0,0,1,1,0,0,0,0,0,1,0,1,0,1,0,1,0,0,1,1,0,0,  // 36400000
;
;1,0,1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,1,0,0,1,0,0,1,1,  // 42000000
;1,0,1,0,1,1,0,0,1,1,0,1,1,0,0,1,1,1,1,0,1,0,0,0,0,0,1,1,1,1,1,  // 42200000
;1,0,1,0,1,1,0,1,1,0,1,0,1,0,1,1,1,0,0,1,1,1,1,1,0,1,0,1,0,1,0,  // 42400000
;1,0,1,0,1,1,1,0,0,1,1,1,1,1,0,1,0,1,0,1,0,1,1,0,0,1,1,0,1,1,0,  // 42600000
;1,0,1,0,1,1,1,1,0,1,0,0,1,1,1,1,0,0,0,0,1,1,0,1,1,0,0,0,0,1,0,  // 42800000
;1,0,1,1,0,0,0,0,0,0,1,0,0,0,0,0,1,1,0,0,0,1,0,0,1,0,0,1,1,0,1,  // 43000000
;};
;
;char d_channel_n;
;char lcd_buff[32];
;
;void display (void);
;
;void dds_reset(void)
; 0000 00B3 {

	.CSEG
_dds_reset:
; 0000 00B4         CLK = LOW;
	CBI  0x18,1
; 0000 00B5         FUD = LOW;
	CBI  0x18,2
; 0000 00B6 
; 0000 00B7         RST = LOW;      delay_us(5);
	CBI  0x18,4
	__DELAY_USB 27
; 0000 00B8         RST = HIGH;     delay_us(5);
	SBI  0x18,4
	__DELAY_USB 27
; 0000 00B9         RST = LOW;
	CBI  0x18,4
; 0000 00BA 
; 0000 00BB         CLK = LOW;      delay_us(5);
	CBI  0x18,1
	__DELAY_USB 27
; 0000 00BC         CLK = HIGH;     delay_us(5);
	CALL SUBOPT_0x0
; 0000 00BD         CLK = LOW;
; 0000 00BE 
; 0000 00BF         DAT = LOW;
	CBI  0x18,3
; 0000 00C0 
; 0000 00C1         FUD = LOW;      delay_us(5);
	CBI  0x18,2
	__DELAY_USB 27
; 0000 00C2         FUD = HIGH;     delay_us(5);
	CALL SUBOPT_0x1
; 0000 00C3         FUD = LOW;
; 0000 00C4 }
	RET
;
;void send_data(void)
; 0000 00C7 {
_send_data:
; 0000 00C8         int i;
; 0000 00C9 
; 0000 00CA         FUD = HIGH;     delay_us(5);
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CALL SUBOPT_0x1
; 0000 00CB         FUD = LOW;
; 0000 00CC 
; 0000 00CD         if(mode == 1)
	CALL SUBOPT_0x2
	BRNE _0x1F
; 0000 00CE         {
; 0000 00CF                 for(i=0; i<30; i++)
	__GETWRN 16,17,0
_0x21:
	__CPWRN 16,17,30
	BRGE _0x22
; 0000 00D0                 {
; 0000 00D1                         DAT = channel_a[channel_n][29-i];
	CALL SUBOPT_0x3
	LDI  R26,LOW(30)
	LDI  R27,HIGH(30)
	CALL __MULW12U
	SUBI R30,LOW(-_channel_a*2)
	SBCI R31,HIGH(-_channel_a*2)
	MOVW R26,R30
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	CALL SUBOPT_0x4
	BRNE _0x23
	CBI  0x18,3
	RJMP _0x24
_0x23:
	SBI  0x18,3
_0x24:
; 0000 00D2                         CLK = HIGH;     delay_us(5);
	CALL SUBOPT_0x0
; 0000 00D3                         CLK = LOW;
; 0000 00D4                 }
	__ADDWRN 16,17,1
	RJMP _0x21
_0x22:
; 0000 00D5 
; 0000 00D6                 for(i=0; i<10; i++)
	__GETWRN 16,17,0
_0x2A:
	__CPWRN 16,17,10
	BRGE _0x2B
; 0000 00D7                 {
; 0000 00D8                         DAT = 0;
	CBI  0x18,3
; 0000 00D9                         CLK = HIGH;     delay_us(5);
	CALL SUBOPT_0x0
; 0000 00DA                         CLK = LOW;
; 0000 00DB                 }
	__ADDWRN 16,17,1
	RJMP _0x2A
_0x2B:
; 0000 00DC         }
; 0000 00DD         else
	RJMP _0x32
_0x1F:
; 0000 00DE         {
; 0000 00DF                 for(i=0; i<31; i++)
	__GETWRN 16,17,0
_0x34:
	__CPWRN 16,17,31
	BRGE _0x35
; 0000 00E0                 {
; 0000 00E1                         DAT = channel_b[channel_n][30-i];
	CALL SUBOPT_0x3
	LDI  R26,LOW(31)
	LDI  R27,HIGH(31)
	CALL __MULW12U
	SUBI R30,LOW(-_channel_b*2)
	SBCI R31,HIGH(-_channel_b*2)
	MOVW R26,R30
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL SUBOPT_0x4
	BRNE _0x36
	CBI  0x18,3
	RJMP _0x37
_0x36:
	SBI  0x18,3
_0x37:
; 0000 00E2                         CLK = HIGH;     delay_us(5);
	CALL SUBOPT_0x0
; 0000 00E3                         CLK = LOW;
; 0000 00E4                 }
	__ADDWRN 16,17,1
	RJMP _0x34
_0x35:
; 0000 00E5 
; 0000 00E6                 for(i=0; i<9; i++)
	__GETWRN 16,17,0
_0x3D:
	__CPWRN 16,17,9
	BRGE _0x3E
; 0000 00E7                 {
; 0000 00E8                         DAT = 0;
	CBI  0x18,3
; 0000 00E9                         CLK = HIGH;     delay_us(5);
	CALL SUBOPT_0x0
; 0000 00EA                         CLK = LOW;
; 0000 00EB                 }
	__ADDWRN 16,17,1
	RJMP _0x3D
_0x3E:
; 0000 00EC         }
_0x32:
; 0000 00ED 
; 0000 00EE         FUD = HIGH;     delay_us(5);
	CALL SUBOPT_0x1
; 0000 00EF         FUD = LOW;
; 0000 00F0 }
	RJMP _0x20C0004
;
;void tuning (void)
; 0000 00F3 {
_tuning:
; 0000 00F4         if(!T_UP)
	SBIC 0x19,1
	RJMP _0x49
; 0000 00F5         {
; 0000 00F6                 delay_ms(125);
	CALL SUBOPT_0x5
; 0000 00F7 
; 0000 00F8                 d_channel_n = channel_n;
; 0000 00F9                 channel_n++;
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 00FA                 if(channel_n > 29) channel_n = 0;
	CALL SUBOPT_0x3
	SBIW R30,30
	BRLT _0x4A
	LDI  R26,LOW(_channel_n)
	LDI  R27,HIGH(_channel_n)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 00FB         }
_0x4A:
; 0000 00FC 
; 0000 00FD         if(!T_DOWN)
_0x49:
	SBIC 0x19,0
	RJMP _0x4B
; 0000 00FE         {
; 0000 00FF                 delay_ms(125);
	CALL SUBOPT_0x5
; 0000 0100 
; 0000 0101                 d_channel_n = channel_n;
; 0000 0102                 channel_n--;
	SBIW R30,1
	CALL __EEPROMWRW
	ADIW R30,1
; 0000 0103                 if(channel_n < 0) channel_n = 29;
	LDI  R26,LOW(_channel_n+1)
	LDI  R27,HIGH(_channel_n+1)
	CALL __EEPROMRDB
	TST  R30
	BRPL _0x4C
	LDI  R26,LOW(_channel_n)
	LDI  R27,HIGH(_channel_n)
	LDI  R30,LOW(29)
	LDI  R31,HIGH(29)
	CALL __EEPROMWRW
; 0000 0104         }
_0x4C:
; 0000 0105 
; 0000 0106         if(!S_UP)
_0x4B:
	SBIC 0x19,3
	RJMP _0x4D
; 0000 0107         {
; 0000 0108                 delay_ms(125);
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	CALL SUBOPT_0x6
; 0000 0109 
; 0000 010A                 if(mode == 1)
	CALL SUBOPT_0x2
	BRNE _0x4E
; 0000 010B                 {
; 0000 010C                         mode = 2;
	LDI  R26,LOW(_mode)
	LDI  R27,HIGH(_mode)
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP _0x5A
; 0000 010D                         d_channel_n++;
; 0000 010E                 }
; 0000 010F                 else
_0x4E:
; 0000 0110                 {
; 0000 0111                         mode = 1;
	LDI  R26,LOW(_mode)
	LDI  R27,HIGH(_mode)
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
_0x5A:
	CALL __EEPROMWRW
; 0000 0112                         d_channel_n++;
	INC  R8
; 0000 0113                 }
; 0000 0114         }
; 0000 0115 
; 0000 0116 
; 0000 0117         if(d_channel_n != channel_n)
_0x4D:
	CALL SUBOPT_0x3
	MOV  R26,R8
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x50
; 0000 0118         {
; 0000 0119                 send_data();
	RCALL _send_data
; 0000 011A                 display();
	RCALL _display
; 0000 011B                 d_channel_n = channel_n;
	LDI  R26,LOW(_channel_n)
	LDI  R27,HIGH(_channel_n)
	CALL __EEPROMRDB
	MOV  R8,R30
; 0000 011C         }
; 0000 011D }
_0x50:
	RET
;
;
;void display (void)
; 0000 0121 {
_display:
; 0000 0122         int i;
; 0000 0123 
; 0000 0124         lcd_clear();
	ST   -Y,R17
	ST   -Y,R16
;	i -> R16,R17
	CALL _lcd_clear
; 0000 0125         lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0126         if(mode == 1)
	CALL SUBOPT_0x2
	BRNE _0x51
; 0000 0127         {
; 0000 0128                 sprintf(lcd_buff,"Channel: %2i A", channel_n + 1);
	CALL SUBOPT_0x7
	__POINTW1FN _0x0,0
	RJMP _0x5B
; 0000 0129         }
; 0000 012A         else
_0x51:
; 0000 012B         {
; 0000 012C                 sprintf(lcd_buff,"Channel: %2i B", channel_n + 1);
	CALL SUBOPT_0x7
	__POINTW1FN _0x0,15
_0x5B:
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3
	ADIW R30,1
	CALL __CWD1
	CALL SUBOPT_0x8
; 0000 012D         }
; 0000 012E         lcd_puts(lcd_buff);
	CALL SUBOPT_0x7
	CALL _lcd_puts
; 0000 012F 
; 0000 0130         lcd_gotoxy(0,1);
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 0131         lcd_putsf("F: ");
	__POINTW1FN _0x0,30
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0132         for(i=0;i<15;i++)
	__GETWRN 16,17,0
_0x54:
	__CPWRN 16,17,15
	BRGE _0x55
; 0000 0133         {
; 0000 0134                 sprintf(lcd_buff,"%c",channel_f[channel_n][i]);
	CALL SUBOPT_0x7
	__POINTW1FN _0x0,34
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x3
	LDI  R26,LOW(15)
	LDI  R27,HIGH(15)
	CALL __MULW12U
	SUBI R30,LOW(-_channel_f*2)
	SBCI R31,HIGH(-_channel_f*2)
	ADD  R30,R16
	ADC  R31,R17
	LPM  R30,Z
	CLR  R31
	CLR  R22
	CLR  R23
	CALL SUBOPT_0x8
; 0000 0135                 lcd_puts(lcd_buff);
	CALL SUBOPT_0x7
	CALL _lcd_puts
; 0000 0136         }
	__ADDWRN 16,17,1
	RJMP _0x54
_0x55:
; 0000 0137 
; 0000 0138         delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x6
; 0000 0139 }
_0x20C0004:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void main(void)
; 0000 013C {
_main:
; 0000 013D         PORTA=0xFF;
	LDI  R30,LOW(255)
	OUT  0x1B,R30
; 0000 013E         DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 013F         PORTB=0x00;
	OUT  0x18,R30
; 0000 0140         DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0141         PORTC=0xFF;
	OUT  0x15,R30
; 0000 0142         DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 0143         PORTD=0x00;
	OUT  0x12,R30
; 0000 0144         DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0145 
; 0000 0146         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0147         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0148 
; 0000 0149         lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 014A         lcd_clear();
	CALL _lcd_clear
; 0000 014B 
; 0000 014C         dds_reset();
	RCALL _dds_reset
; 0000 014D         send_data();
	RCALL _send_data
; 0000 014E         display();
	RCALL _display
; 0000 014F         delay_ms(150);
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x6
; 0000 0150 
; 0000 0151         while (1)
_0x56:
; 0000 0152         {
; 0000 0153                 tuning();
	RCALL _tuning
; 0000 0154         }
	RJMP _0x56
; 0000 0155 }
_0x59:
	RJMP _0x59

	.CSEG

	.DSEG

	.CSEG
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

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x12,3
	RJMP _0x2020005
_0x2020004:
	CBI  0x12,3
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x12,2
	RJMP _0x2020007
_0x2020006:
	CBI  0x12,2
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x12,1
	RJMP _0x2020009
_0x2020008:
	CBI  0x12,1
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x12,0
	RJMP _0x202000B
_0x202000A:
	CBI  0x12,0
_0x202000B:
	__DELAY_USB 11
	SBI  0x12,4
	__DELAY_USB 27
	CBI  0x12,4
	__DELAY_USB 27
	RJMP _0x20C0002
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
	__DELAY_USW 200
	RJMP _0x20C0002
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
	LDD  R7,Y+1
	LDD  R10,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x9
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x9
	LDI  R30,LOW(0)
	MOV  R10,R30
	MOV  R7,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	CP   R7,R9
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R10
	ST   -Y,R10
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x20C0002
_0x2020013:
_0x2020010:
	INC  R7
	SBI  0x12,6
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x12,6
	RJMP _0x20C0002
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
	RJMP _0x20C0003
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
_0x20C0003:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x11,3
	SBI  0x11,2
	SBI  0x11,1
	SBI  0x11,0
	SBI  0x11,4
	SBI  0x11,6
	SBI  0x11,5
	CBI  0x12,4
	CBI  0x12,6
	CBI  0x12,5
	LDD  R9,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x6
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
	__DELAY_USW 400
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
_0x20C0002:
	ADIW R28,1
	RET
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
_put_buff_G102:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x2040010
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,4
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x2040012
	__CPWRN 16,17,2
	BRLO _0x2040013
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	__PUTW1SNS 2,4
_0x2040012:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADIW R26,2
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2040014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
_0x2040014:
_0x2040013:
	RJMP _0x2040015
_0x2040010:
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	ST   X+,R30
	ST   X,R31
_0x2040015:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
__print_G102:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   X+,R30
	ST   X,R31
_0x2040016:
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
	JMP _0x2040018
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x204001C
	CPI  R18,37
	BRNE _0x204001D
	LDI  R17,LOW(1)
	RJMP _0x204001E
_0x204001D:
	CALL SUBOPT_0xB
_0x204001E:
	RJMP _0x204001B
_0x204001C:
	CPI  R30,LOW(0x1)
	BRNE _0x204001F
	CPI  R18,37
	BRNE _0x2040020
	CALL SUBOPT_0xB
	RJMP _0x20400C9
_0x2040020:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x2040021
	LDI  R16,LOW(1)
	RJMP _0x204001B
_0x2040021:
	CPI  R18,43
	BRNE _0x2040022
	LDI  R20,LOW(43)
	RJMP _0x204001B
_0x2040022:
	CPI  R18,32
	BRNE _0x2040023
	LDI  R20,LOW(32)
	RJMP _0x204001B
_0x2040023:
	RJMP _0x2040024
_0x204001F:
	CPI  R30,LOW(0x2)
	BRNE _0x2040025
_0x2040024:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x2040026
	ORI  R16,LOW(128)
	RJMP _0x204001B
_0x2040026:
	RJMP _0x2040027
_0x2040025:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x204001B
_0x2040027:
	CPI  R18,48
	BRLO _0x204002A
	CPI  R18,58
	BRLO _0x204002B
_0x204002A:
	RJMP _0x2040029
_0x204002B:
	LDI  R26,LOW(10)
	MUL  R21,R26
	MOV  R21,R0
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x204001B
_0x2040029:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x204002F
	CALL SUBOPT_0xC
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0xD
	RJMP _0x2040030
_0x204002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2040032
	CALL SUBOPT_0xC
	CALL SUBOPT_0xE
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2040033
_0x2040032:
	CPI  R30,LOW(0x70)
	BRNE _0x2040035
	CALL SUBOPT_0xC
	CALL SUBOPT_0xE
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x2040033:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x2040036
_0x2040035:
	CPI  R30,LOW(0x64)
	BREQ _0x2040039
	CPI  R30,LOW(0x69)
	BRNE _0x204003A
_0x2040039:
	ORI  R16,LOW(4)
	RJMP _0x204003B
_0x204003A:
	CPI  R30,LOW(0x75)
	BRNE _0x204003C
_0x204003B:
	LDI  R30,LOW(_tbl10_G102*2)
	LDI  R31,HIGH(_tbl10_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x204003D
_0x204003C:
	CPI  R30,LOW(0x58)
	BRNE _0x204003F
	ORI  R16,LOW(8)
	RJMP _0x2040040
_0x204003F:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x2040071
_0x2040040:
	LDI  R30,LOW(_tbl16_G102*2)
	LDI  R31,HIGH(_tbl16_G102*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x204003D:
	SBRS R16,2
	RJMP _0x2040042
	CALL SUBOPT_0xC
	CALL SUBOPT_0xF
	LDD  R26,Y+11
	TST  R26
	BRPL _0x2040043
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x2040043:
	CPI  R20,0
	BREQ _0x2040044
	SUBI R17,-LOW(1)
	RJMP _0x2040045
_0x2040044:
	ANDI R16,LOW(251)
_0x2040045:
	RJMP _0x2040046
_0x2040042:
	CALL SUBOPT_0xC
	CALL SUBOPT_0xF
_0x2040046:
_0x2040036:
	SBRC R16,0
	RJMP _0x2040047
_0x2040048:
	CP   R17,R21
	BRSH _0x204004A
	SBRS R16,7
	RJMP _0x204004B
	SBRS R16,2
	RJMP _0x204004C
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x204004D
_0x204004C:
	LDI  R18,LOW(48)
_0x204004D:
	RJMP _0x204004E
_0x204004B:
	LDI  R18,LOW(32)
_0x204004E:
	CALL SUBOPT_0xB
	SUBI R21,LOW(1)
	RJMP _0x2040048
_0x204004A:
_0x2040047:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x204004F
_0x2040050:
	CPI  R19,0
	BREQ _0x2040052
	SBRS R16,3
	RJMP _0x2040053
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LPM  R18,Z+
	STD  Y+6,R30
	STD  Y+6+1,R31
	RJMP _0x2040054
_0x2040053:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R18,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x2040054:
	CALL SUBOPT_0xB
	CPI  R21,0
	BREQ _0x2040055
	SUBI R21,LOW(1)
_0x2040055:
	SUBI R19,LOW(1)
	RJMP _0x2040050
_0x2040052:
	RJMP _0x2040056
_0x204004F:
_0x2040058:
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
_0x204005A:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x204005C
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x204005A
_0x204005C:
	CPI  R18,58
	BRLO _0x204005D
	SBRS R16,3
	RJMP _0x204005E
	SUBI R18,-LOW(7)
	RJMP _0x204005F
_0x204005E:
	SUBI R18,-LOW(39)
_0x204005F:
_0x204005D:
	SBRC R16,4
	RJMP _0x2040061
	CPI  R18,49
	BRSH _0x2040063
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x2040062
_0x2040063:
	RJMP _0x20400CA
_0x2040062:
	CP   R21,R19
	BRLO _0x2040067
	SBRS R16,0
	RJMP _0x2040068
_0x2040067:
	RJMP _0x2040066
_0x2040068:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x2040069
	LDI  R18,LOW(48)
_0x20400CA:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x204006A
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0xD
	CPI  R21,0
	BREQ _0x204006B
	SUBI R21,LOW(1)
_0x204006B:
_0x204006A:
_0x2040069:
_0x2040061:
	CALL SUBOPT_0xB
	CPI  R21,0
	BREQ _0x204006C
	SUBI R21,LOW(1)
_0x204006C:
_0x2040066:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x2040059
	RJMP _0x2040058
_0x2040059:
_0x2040056:
	SBRS R16,0
	RJMP _0x204006D
_0x204006E:
	CPI  R21,0
	BREQ _0x2040070
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL SUBOPT_0xD
	RJMP _0x204006E
_0x2040070:
_0x204006D:
_0x2040071:
_0x2040030:
_0x20400C9:
	LDI  R17,LOW(0)
_0x204001B:
	RJMP _0x2040016
_0x2040018:
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
	CALL SUBOPT_0x10
	SBIW R30,0
	BRNE _0x2040072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x20C0001
_0x2040072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x10
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
	LDI  R30,LOW(_put_buff_G102)
	LDI  R31,HIGH(_put_buff_G102)
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,10
	ST   -Y,R31
	ST   -Y,R30
	RCALL __print_G102
	MOVW R18,R30
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
	MOVW R30,R18
_0x20C0001:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
	RET

	.CSEG

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

	.ESEG
_channel_n:
	.DW  0x9
_mode:
	.DW  0x1

	.DSEG
_lcd_buff:
	.BYTE 0x20
__seed_G100:
	.BYTE 0x4
__base_y_G101:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	SBI  0x18,1
	__DELAY_USB 27
	CBI  0x18,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	SBI  0x18,2
	__DELAY_USB 27
	CBI  0x18,2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_mode)
	LDI  R27,HIGH(_mode)
	CALL __EEPROMRDW
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_channel_n)
	LDI  R27,HIGH(_channel_n)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	SUB  R30,R16
	SBC  R31,R17
	ADD  R30,R26
	ADC  R31,R27
	LPM  R30,Z
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R26,LOW(_channel_n)
	LDI  R27,HIGH(_channel_n)
	CALL __EEPROMRDB
	MOV  R8,R30
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(_lcd_buff)
	LDI  R31,HIGH(_lcd_buff)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G101
	__DELAY_USW 400
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0xB:
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
SUBOPT_0xC:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xE:
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
SUBOPT_0xF:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET


	.CSEG
_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0xFA0
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
