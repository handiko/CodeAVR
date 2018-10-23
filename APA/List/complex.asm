
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 12.000000 MHz
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
	.DEF _timebase=R4
	.DEF _count=R6
	.DEF _rx_wr_index=R9
	.DEF _rx_rd_index=R8
	.DEF _rx_counter=R11
	.DEF _tx_wr_index=R10
	.DEF _tx_rd_index=R13
	.DEF _tx_counter=R12

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
	JMP  _timer0_ovf_isr
	JMP  0x00
	JMP  _usart_rx_isr
	JMP  0x00
	JMP  _usart_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x124:
	.DB  0x0,0x0,0x0,0x0
_0x0:
	.DB  0x4D,0x6F,0x64,0x65,0x20,0x4D,0x61,0x6E
	.DB  0x75,0x61,0x6C,0x20,0x20,0x3C,0x3D,0x3D
	.DB  0x0,0x4D,0x6F,0x64,0x65,0x20,0x41,0x75
	.DB  0x74,0x6F,0x6D,0x61,0x74,0x20,0x20,0x20
	.DB  0x20,0x0,0x4D,0x6F,0x64,0x65,0x20,0x4D
	.DB  0x61,0x6E,0x75,0x61,0x6C,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x4D,0x6F,0x64,0x65,0x20
	.DB  0x41,0x75,0x74,0x6F,0x6D,0x61,0x74,0x20
	.DB  0x3C,0x3D,0x3D,0x0,0x52,0x55,0x4E,0x20
	.DB  0x3F,0x3F,0x3F,0x0,0x45,0x4E,0x54,0x45
	.DB  0x52,0x20,0x41,0x47,0x41,0x49,0x4E,0x2E
	.DB  0x2E,0x0,0x48,0x69,0x74,0x75,0x6E,0x67
	.DB  0x20,0x6D,0x75,0x6E,0x64,0x75,0x72,0x0
	.DB  0x77,0x61,0x6B,0x74,0x75,0x20,0x3D,0x20
	.DB  0x25,0x64,0x0,0x57,0x41,0x4B,0x54,0x55
	.DB  0x20,0x48,0x41,0x42,0x49,0x53,0x20,0x21
	.DB  0x21,0x0,0x41,0x4E,0x41,0x4C,0x59,0x5A
	.DB  0x49,0x4E,0x47,0x0,0x25,0x64,0x20,0x25
	.DB  0x64,0x20,0x25,0x64,0x20,0x25,0x64,0x0
	.DB  0x43,0x4F,0x4D,0x50,0x4C,0x45,0x54,0x45
	.DB  0x2E,0x2E,0x21,0x21,0x0,0x57,0x61,0x69
	.DB  0x74,0x20,0x43,0x6F,0x6D,0x6D,0x61,0x6E
	.DB  0x64,0x0,0x41,0x6E,0x74,0x65,0x6E,0x20
	.DB  0x50,0x20,0x41,0x6E,0x61,0x6C,0x79,0x7A
	.DB  0x65,0x72,0x0,0x20,0x54,0x65,0x63,0x68
	.DB  0x6E,0x6F,0x20,0x20,0x41,0x6E,0x74,0x65
	.DB  0x6E,0x61,0x20,0x0,0x20,0x54,0x65,0x6B
	.DB  0x6E,0x69,0x6B,0x20,0x20,0x46,0x69,0x73
	.DB  0x69,0x6B,0x61,0x20,0x0,0x20,0x20,0x20
	.DB  0x20,0x55,0x20,0x20,0x47,0x20,0x20,0x4D
	.DB  0x20,0x20,0x20,0x20,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x0D
	.DW  _0x46
	.DW  _0x0*2+165

	.DW  0x04
	.DW  0x04
	.DW  _0x124*2

	.DW  0x02
	.DW  __base_y_G100
	.DW  _0x2000003*2

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
;Date    : 6/3/2012
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 12.000000 MHz
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
;#include <delay.h>
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;#ifndef _ADC_SEL_
;	#define _ADC_SEL_
;	#define SEL_1	PORTD.2
;	#define SEL_2	PORTD.3
;	#define SEL_3	PORTD.4
;#endif
;
;#ifndef _SEV_SEL_
;	#define _SEV_SEL_
;        #define SEV_1	PORTB.0
;        #define SEV_2	PORTB.1
;        #define SEV_3	PORTB.2
;        #define SEV_4	PORTB.3
;
;        #define en_1	PORTB.0
;	#define en_2 	PORTB.1
;	#define en_3	PORTB.2
;	#define en_4	PORTB.3
;
;        #define DIG_1	PORTB.4
;        #define DIG_2	PORTB.5
;        #define DIG_3	PORTB.6
;        #define DIG_4	PORTB.7
;#endif
;
;#ifndef PTT
;#define PTT	PORTA.4
;#endif
;
;#ifndef BELL
;#define BELL 	PORTC.3
;#endif
;
;#ifndef TOM_ENT
;#define	TOM_ENT	PINA.6
;#endif
;
;#ifndef	TOM_BACK
;#define TOM_BACK PINA.5
;#endif
;
;#pragma optsize+
;
;unsigned int timebase=0,count=0;
;
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 0051 {

	.CSEG
_timer0_ovf_isr:
	CALL SUBOPT_0x0
; 0000 0052 	// Reinitialize Timer 0 value
; 0000 0053 	TCNT0=0x6A;
	LDI  R30,LOW(106)
	OUT  0x32,R30
; 0000 0054 	// Place your code here
; 0000 0055         count++;
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
; 0000 0056         if(count==10000)
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	CP   R30,R6
	CPC  R31,R7
	BRNE _0x3
; 0000 0057         {
; 0000 0058         	count=0;
	CLR  R6
	CLR  R7
; 0000 0059                 timebase++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 005A         	if(timebase>120) timebase=0;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CP   R30,R4
	CPC  R31,R5
	BRSH _0x4
	CLR  R4
	CLR  R5
; 0000 005B         }
_0x4:
; 0000 005C }
_0x3:
	CALL SUBOPT_0x1
	RETI
;
;#define ADC_VREF_TYPE 0x20
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0063 {
; 0000 0064 	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
; 0000 0065 	// Delay needed for the stabilization of the ADC input voltage
; 0000 0066 	delay_us(10);
; 0000 0067 	// Start the AD conversion
; 0000 0068 	ADCSRA|=0x40;
; 0000 0069 	// Wait for the AD conversion to complete
; 0000 006A 	while ((ADCSRA & 0x10)==0);
; 0000 006B 	ADCSRA|=0x10;
; 0000 006C 	return ADCH;
; 0000 006D }
;
;
;#define OVR 3
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE<256
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
; 0000 0087 {
_usart_rx_isr:
	CALL SUBOPT_0x0
; 0000 0088 char status,data;
; 0000 0089 status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 008A data=UDR;
	IN   R16,12
; 0000 008B if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x8
; 0000 008C    {
; 0000 008D    rx_buffer[rx_wr_index]=data;
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 008E    if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x9
	CLR  R9
; 0000 008F    if (++rx_counter == RX_BUFFER_SIZE)
_0x9:
	INC  R11
	LDI  R30,LOW(8)
	CP   R30,R11
	BRNE _0xA
; 0000 0090       {
; 0000 0091       rx_counter=0;
	CLR  R11
; 0000 0092       rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0093       };
_0xA:
; 0000 0094    };
_0x8:
; 0000 0095 }
	LD   R16,Y+
	LD   R17,Y+
	CALL SUBOPT_0x1
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 009C {
; 0000 009D char data;
; 0000 009E while (rx_counter==0);
;	data -> R17
; 0000 009F data=rx_buffer[rx_rd_index];
; 0000 00A0 if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 00A1 #asm("cli")
; 0000 00A2 --rx_counter;
; 0000 00A3 #asm("sei")
; 0000 00A4 return data;
; 0000 00A5 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE<256
;unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 00B5 {
_usart_tx_isr:
	CALL SUBOPT_0x0
; 0000 00B6 if (tx_counter)
	TST  R12
	BREQ _0xF
; 0000 00B7    {
; 0000 00B8    --tx_counter;
	DEC  R12
; 0000 00B9    UDR=tx_buffer[tx_rd_index];
	MOV  R30,R13
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00BA    if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R13
	LDI  R30,LOW(8)
	CP   R30,R13
	BRNE _0x10
	CLR  R13
; 0000 00BB    };
_0x10:
_0xF:
; 0000 00BC }
	CALL SUBOPT_0x1
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 00C3 {
; 0000 00C4 while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
; 0000 00C5 #asm("cli")
; 0000 00C6 if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
; 0000 00C7    {
; 0000 00C8    tx_buffer[tx_wr_index]=c;
; 0000 00C9    if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
; 0000 00CA    ++tx_counter;
; 0000 00CB    }
; 0000 00CC else
; 0000 00CD    UDR=c;
; 0000 00CE #asm("sei")
; 0000 00CF }
;#pragma used-
;#endif
;
;// Declare your global variables here
;void menu(void);
;void navi_mode(void);
;void mode_manual(void);
;void mode_automatis(void);
;void run_manual(void);
;void run_automatis(void);
;void sev_seg(unsigned int value);
;void analyzing(void);
;void hitung_skor(void);
;void clear_sensor(void);
;void kirim_to_pc(void);
;
;char lcd[32],
;	no_menu=0,
;        detik;
;
;unsigned char adc_menu;
;unsigned int skor;
;
;unsigned char senbuff[25],
;	sen[25];
;
;void menu(void)
; 0000 00EB {
; 0000 00EC 	lcd_clear();
; 0000 00ED         for(;;)
; 0000 00EE         {
; 0000 00EF         	adc_menu = read_adc(7);
; 0000 00F0                 if(no_menu==0)	{navi_mode();}
; 0000 00F1                 else if(no_menu==1)	{run_manual();}
; 0000 00F2                 else if(no_menu==2)	{run_automatis();}
; 0000 00F3         }
; 0000 00F4 }
;
;void navi_mode(void)
; 0000 00F7 {
; 0000 00F8         adc_menu = read_adc(7);
; 0000 00F9         if(adc_menu < 128)
; 0000 00FA         {
; 0000 00FB         	mode_manual();
; 0000 00FC         }
; 0000 00FD         else if(adc_menu > 128)
; 0000 00FE         {
; 0000 00FF         	mode_automatis();
; 0000 0100         }
; 0000 0101 }
;
;void mode_manual(void)
; 0000 0104 {
; 0000 0105   	lcd_clear();
; 0000 0106         lcd_gotoxy(0,0);
; 0000 0107         	// 0123456789abcdef
; 0000 0108         lcd_putsf("Mode Manual  <==");
; 0000 0109       	lcd_gotoxy(0,1);
; 0000 010A         lcd_putsf("Mode Automat    ");
; 0000 010B         delay_ms(100);
; 0000 010C         if(!TOM_ENT)
; 0000 010D         {
; 0000 010E         	delay_ms(125);
; 0000 010F                 no_menu = 1;
; 0000 0110         }
; 0000 0111 }
;
;void mode_automatis(void)
; 0000 0114 {
; 0000 0115         lcd_clear();
; 0000 0116         lcd_gotoxy(0,0);
; 0000 0117         	// 0123456789abcdef
; 0000 0118         lcd_putsf("Mode Manual     ");
; 0000 0119       	lcd_gotoxy(0,1);
; 0000 011A         lcd_putsf("Mode Automat <==");
; 0000 011B         delay_ms(100);
; 0000 011C         if(!TOM_ENT)
; 0000 011D         {
; 0000 011E         	delay_ms(125);
; 0000 011F                 no_menu = 2;
; 0000 0120         }
; 0000 0121 }
;
;void run_manual(void)
; 0000 0124 {
; 0000 0125                 lagi:
; 0000 0126         lcd_clear();
; 0000 0127         lcd_gotoxy(0,0);
; 0000 0128         lcd_putsf("RUN ???");
; 0000 0129         lcd_gotoxy(0,1);
; 0000 012A         lcd_putsf("ENTER AGAIN..");
; 0000 012B         delay_ms(250);
; 0000 012C         if(!TOM_ENT)
; 0000 012D         {
; 0000 012E         	delay_ms(250);
; 0000 012F                 goto run_manual;
; 0000 0130         }
; 0000 0131         if(!TOM_BACK)
; 0000 0132         {
; 0000 0133         	no_menu=0;
; 0000 0134         	goto exit;
; 0000 0135         }
; 0000 0136         	goto lagi;
; 0000 0137                 run_manual:
; 0000 0138 
; 0000 0139        	lcd_clear();
; 0000 013A         lcd_putsf("Hitung mundur");
; 0000 013B 
; 0000 013C         timebase = 0;
; 0000 013D         count=0;
; 0000 013E 
; 0000 013F         do
; 0000 0140         {
; 0000 0141         	detik = 120 - timebase;
; 0000 0142                 sev_seg(detik);
; 0000 0143                 lcd_clear();
; 0000 0144                 sprintf(lcd,"waktu = %d",detik);
; 0000 0145                 lcd_puts(lcd);
; 0000 0146                 if(!TOM_ENT) goto keluar;
; 0000 0147         }
; 0000 0148         while(detik>0);
; 0000 0149         keluar:
; 0000 014A         sev_seg(0);
; 0000 014B         delay_ms(400);
; 0000 014C 
; 0000 014D         BELL = 1;
; 0000 014E         lcd_clear();
; 0000 014F         lcd_putsf("WAKTU HABIS !!");
; 0000 0150         delay_ms(4000);
; 0000 0151         BELL = 0;
; 0000 0152 
; 0000 0153         while(TOM_ENT);
; 0000 0154         lcd_clear();
; 0000 0155         lcd_putsf("ANALYZING");
; 0000 0156         delay_ms(500);
; 0000 0157 
; 0000 0158         timebase=0;
; 0000 0159         count=0;
; 0000 015A         PTT = 1;
; 0000 015B         delay_ms(250);
; 0000 015C         clear_sensor();
; 0000 015D 
; 0000 015E         do
; 0000 015F         {
; 0000 0160         	detik = 5 - timebase;
; 0000 0161                 analyzing();
; 0000 0162         }
; 0000 0163 
; 0000 0164         while(detik>0);
; 0000 0165 
; 0000 0166         PTT = 0;
; 0000 0167         delay_ms(500);
; 0000 0168         hitung_skor();
; 0000 0169 
; 0000 016A         lcd_clear();
; 0000 016B 
; 0000 016C         lcd_gotoxy(0,0);
; 0000 016D         sprintf(lcd,"%d %d %d %d",sen[0],sen[1],sen[2],sen[3]);
; 0000 016E         lcd_puts(lcd);
; 0000 016F         lcd_gotoxy(0,1);
; 0000 0170         sprintf(lcd,"%d %d %d %d",sen[4],sen[5],sen[6],sen[7]);
; 0000 0171         lcd_puts(lcd);
; 0000 0172         delay_ms(500);
; 0000 0173 
; 0000 0174         lcd_clear();
; 0000 0175         lcd_gotoxy(0,0);
; 0000 0176         sprintf(lcd,"%d %d %d %d",sen[8],sen[9],sen[10],sen[11]);
; 0000 0177         lcd_puts(lcd);
; 0000 0178         lcd_gotoxy(0,1);
; 0000 0179         sprintf(lcd,"%d %d %d %d",sen[12],sen[13],sen[14],sen[15]);
; 0000 017A         lcd_puts(lcd);
; 0000 017B         delay_ms(500);
; 0000 017C 
; 0000 017D         lcd_clear();
; 0000 017E         lcd_gotoxy(0,0);
; 0000 017F         sprintf(lcd,"%d %d %d %d",sen[16],sen[17],sen[18],sen[19]);
; 0000 0180         lcd_puts(lcd);
; 0000 0181         lcd_gotoxy(0,1);
; 0000 0182         sprintf(lcd,"%d %d %d %d",sen[20],sen[21],sen[22],sen[23]);
; 0000 0183         lcd_puts(lcd);
; 0000 0184         delay_ms(500);
; 0000 0185 
; 0000 0186         lcd_clear();
; 0000 0187         lcd_gotoxy(0,0);
; 0000 0188         sprintf(lcd,"%d",sen[24]);
; 0000 0189         lcd_puts(lcd);
; 0000 018A         lcd_gotoxy(0,1);
; 0000 018B         sprintf(lcd,"%d",skor);
; 0000 018C         lcd_puts(lcd);
; 0000 018D         delay_ms(500);
; 0000 018E 
; 0000 018F         //kirim_to_pc();
; 0000 0190 
; 0000 0191         do
; 0000 0192         {
; 0000 0193         	sev_seg(skor);
; 0000 0194                 lcd_clear();
; 0000 0195         	lcd_putsf("COMPLETE..!!");
; 0000 0196         }
; 0000 0197         while(TOM_ENT);
; 0000 0198 
; 0000 0199         delay_ms(100);
; 0000 019A         no_menu=0;
; 0000 019B                 exit:
; 0000 019C }
;
;void run_automatis(void)
; 0000 019F {
; 0000 01A0 		autom:
; 0000 01A1         lcd_clear();
; 0000 01A2         lcd_gotoxy(0,0);
; 0000 01A3         lcd_putsf("RUN ???");
; 0000 01A4         lcd_gotoxy(0,1);
; 0000 01A5         lcd_putsf("ENTER AGAIN..");
; 0000 01A6         delay_ms(250);
; 0000 01A7         if(!TOM_ENT)
; 0000 01A8         {
; 0000 01A9         	delay_ms(125);
; 0000 01AA                 goto run_autom;
; 0000 01AB         }
; 0000 01AC         if(!TOM_BACK)
; 0000 01AD         {
; 0000 01AE         	no_menu=0;
; 0000 01AF         	goto exit;
; 0000 01B0         }
; 0000 01B1         	goto autom;
; 0000 01B2        	run_autom:
; 0000 01B3         lcd_clear();
; 0000 01B4         lcd_puts("Wait Command");
; 0000 01B5 
; 0000 01B6         while(getchar()!='a');
; 0000 01B7 
; 0000 01B8         lcd_clear();
; 0000 01B9         lcd_putsf("Hitung mundur");
; 0000 01BA 
; 0000 01BB         timebase = 0;
; 0000 01BC         count=0;
; 0000 01BD 
; 0000 01BE         do
; 0000 01BF         {
; 0000 01C0         	detik = 120 - timebase;
; 0000 01C1                 sev_seg(detik);
; 0000 01C2                 lcd_clear();
; 0000 01C3                 sprintf(lcd,"waktu = %d",detik);
; 0000 01C4                 lcd_puts(lcd);
; 0000 01C5                 if(!TOM_ENT) goto lanjut;
; 0000 01C6         }
; 0000 01C7         while(detik>0);
; 0000 01C8 
; 0000 01C9         BELL = 1;
; 0000 01CA         lanjut:
; 0000 01CB         lcd_clear();
; 0000 01CC         lcd_putsf("WAKTU HABIS !!");
; 0000 01CD         delay_ms(4000);
; 0000 01CE         BELL = 0;
; 0000 01CF 
; 0000 01D0         while(getchar()!='b');
; 0000 01D1 
; 0000 01D2         lcd_clear();
; 0000 01D3         lcd_putsf("ANALYZING");
; 0000 01D4 
; 0000 01D5         timebase=0;
; 0000 01D6         count=0;
; 0000 01D7         PTT = 1;
; 0000 01D8         delay_ms(250);
; 0000 01D9         clear_sensor();
; 0000 01DA 
; 0000 01DB         do
; 0000 01DC         {
; 0000 01DD         	detik = 5 - timebase;
; 0000 01DE                 analyzing();
; 0000 01DF         }
; 0000 01E0         while(detik>0);
; 0000 01E1 
; 0000 01E2         PTT = 0;
; 0000 01E3         delay_ms(500);
; 0000 01E4         hitung_skor();
; 0000 01E5 
; 0000 01E6         lcd_clear();
; 0000 01E7 
; 0000 01E8         lcd_gotoxy(0,0);
; 0000 01E9         sprintf(lcd,"%d %d %d %d",sen[0],sen[1],sen[2],sen[3]);
; 0000 01EA         lcd_gotoxy(0,1);
; 0000 01EB         sprintf(lcd,"%d %d %d %d",sen[4],sen[5],sen[6],sen[7]);
; 0000 01EC         delay_ms(300);
; 0000 01ED 
; 0000 01EE         lcd_gotoxy(0,0);
; 0000 01EF         sprintf(lcd,"%d %d %d %d",sen[8],sen[9],sen[10],sen[11]);
; 0000 01F0         lcd_gotoxy(0,1);
; 0000 01F1         sprintf(lcd,"%d %d %d %d",sen[12],sen[13],sen[14],sen[15]);
; 0000 01F2         delay_ms(300);
; 0000 01F3 
; 0000 01F4         lcd_gotoxy(0,0);
; 0000 01F5         sprintf(lcd,"%d %d %d %d",sen[16],sen[17],sen[18],sen[19]);
; 0000 01F6         lcd_gotoxy(0,1);
; 0000 01F7         sprintf(lcd,"%d %d %d %d",sen[20],sen[21],sen[22],sen[23]);
; 0000 01F8         delay_ms(300);
; 0000 01F9 
; 0000 01FA         lcd_gotoxy(0,0);
; 0000 01FB         sprintf(lcd,"%d",sen[24]);
; 0000 01FC         lcd_gotoxy(0,1);
; 0000 01FD         sprintf(lcd,"%d",skor);
; 0000 01FE         delay_ms(300);
; 0000 01FF 
; 0000 0200         kirim_to_pc();
; 0000 0201 
; 0000 0202         do
; 0000 0203         {
; 0000 0204         	sev_seg(skor);
; 0000 0205                 lcd_clear();
; 0000 0206         	lcd_putsf("COMPLETE..!!");
; 0000 0207         }
; 0000 0208         while(getchar()!='c');
; 0000 0209 
; 0000 020A         goto run_autom;
; 0000 020B         exit:
; 0000 020C }

	.DSEG
_0x46:
	.BYTE 0xD
;
;void sev_seg(unsigned int value)
; 0000 020F {

	.CSEG
; 0000 0210 	char 	ribuan,
; 0000 0211         	ratusan,
; 0000 0212                 puluhan,
; 0000 0213                 satuan;
; 0000 0214 
; 0000 0215         satuan=value%10;
;	value -> Y+4
;	ribuan -> R17
;	ratusan -> R16
;	puluhan -> R19
;	satuan -> R18
; 0000 0216         value/=10;
; 0000 0217         puluhan=value%10;
; 0000 0218         value/=10;
; 0000 0219         ratusan=value%10;
; 0000 021A         value/=10;
; 0000 021B         ribuan=value%10;
; 0000 021C 
; 0000 021D 	PORTB = 0;
; 0000 021E         en_1 = 1;
; 0000 021F         en_2 = 0;
; 0000 0220         en_3 = 0;
; 0000 0221         en_4 = 0;
; 0000 0222         PORTB |= (ribuan << 4);
; 0000 0223         delay_ms(5);
; 0000 0224 
; 0000 0225         PORTB = 0;
; 0000 0226         en_1 = 0;
; 0000 0227         en_2 = 1;
; 0000 0228         en_3 = 0;
; 0000 0229         en_4 = 0;
; 0000 022A         PORTB |= (ratusan << 4);
; 0000 022B         delay_ms(5);
; 0000 022C 
; 0000 022D 	PORTB = 0;
; 0000 022E         en_1 = 0;
; 0000 022F         en_2 = 0;
; 0000 0230         en_3 = 1;
; 0000 0231         en_4 = 0;
; 0000 0232         PORTB |= (puluhan << 4);
; 0000 0233         delay_ms(5);
; 0000 0234 
; 0000 0235         PORTB = 0;
; 0000 0236         en_1 = 0;
; 0000 0237         en_2 = 0;
; 0000 0238         en_3 = 0;
; 0000 0239         en_4 = 1;
; 0000 023A         PORTB |= (satuan << 4);
; 0000 023B         delay_ms(5);
; 0000 023C }
;
;void analyzing(void)
; 0000 023F {
; 0000 0240 	char i;
; 0000 0241 
; 0000 0242         SEL_1 = 0;
;	i -> R17
; 0000 0243         SEL_2 = 0;
; 0000 0244         SEL_3 = 0;
; 0000 0245         delay_ms(10);
; 0000 0246         for(i=0;i<3;i++)
; 0000 0247         {
; 0000 0248         	senbuff[i] = read_adc(i);
; 0000 0249                 if(senbuff[i]>sen[i]) sen[i]=senbuff[i];
; 0000 024A         }
; 0000 024B 
; 0000 024C         SEL_1 = 1;
; 0000 024D         SEL_2 = 0;
; 0000 024E         SEL_3 = 0;
; 0000 024F         delay_ms(10);
; 0000 0250         for(i=0;i<3;i++)
; 0000 0251         {
; 0000 0252         	senbuff[i+3] = read_adc(i);
; 0000 0253                 if(senbuff[i+3]>sen[i+3]) sen[i+3]=senbuff[i+3];
; 0000 0254         }
; 0000 0255 
; 0000 0256         SEL_1 = 0;
; 0000 0257         SEL_2 = 1;
; 0000 0258         SEL_3 = 0;
; 0000 0259         delay_ms(10);
; 0000 025A         for(i=0;i<3;i++)
; 0000 025B         {
; 0000 025C         	senbuff[i+6] = read_adc(i);
; 0000 025D                 if(senbuff[i+6]>sen[i+6]) sen[i+6]=senbuff[i+6];
; 0000 025E         }
; 0000 025F 
; 0000 0260         SEL_1 = 1;
; 0000 0261         SEL_2 = 1;
; 0000 0262         SEL_3 = 0;
; 0000 0263         delay_ms(10);
; 0000 0264         for(i=0;i<3;i++)
; 0000 0265         {
; 0000 0266         	senbuff[i+9] = read_adc(i);
; 0000 0267                 if(senbuff[i+9]>sen[i+9]) sen[i+9]=senbuff[i+9];
; 0000 0268         }
; 0000 0269 
; 0000 026A         SEL_1 = 0;
; 0000 026B         SEL_2 = 0;
; 0000 026C         SEL_3 = 1;
; 0000 026D         delay_ms(10);
; 0000 026E         for(i=0;i<3;i++)
; 0000 026F         {
; 0000 0270         	senbuff[i+12] = read_adc(i);
; 0000 0271                 if(senbuff[i+12]>sen[i+12]) sen[i+12]=senbuff[i+12];
; 0000 0272         }
; 0000 0273 
; 0000 0274         SEL_1 = 1;
; 0000 0275         SEL_2 = 0;
; 0000 0276         SEL_3 = 1;
; 0000 0277         delay_ms(10);
; 0000 0278         for(i=0;i<3;i++)
; 0000 0279         {
; 0000 027A         	senbuff[i+15] = read_adc(i);
; 0000 027B                 if(senbuff[i+15]>sen[i+15]) sen[i+15]=senbuff[i+15];
; 0000 027C         }
; 0000 027D 
; 0000 027E         SEL_1 = 0;
; 0000 027F         SEL_2 = 1;
; 0000 0280         SEL_3 = 1;
; 0000 0281         delay_ms(10);
; 0000 0282         for(i=0;i<3;i++)
; 0000 0283         {
; 0000 0284         	senbuff[i+18] = read_adc(i);
; 0000 0285                 if(senbuff[i+18]>sen[i+18]) sen[i+18]=senbuff[i+18];
; 0000 0286         }
; 0000 0287 
; 0000 0288         SEL_1 = 1;
; 0000 0289         SEL_2 = 1;
; 0000 028A         SEL_3 = 1;
; 0000 028B         delay_ms(10);
; 0000 028C         for(i=0;i<3;i++)
; 0000 028D         {
; 0000 028E         	senbuff[i+21] = read_adc(i);
; 0000 028F                 if(senbuff[i+21]>sen[i+21]) sen[i+21]=senbuff[i+21];
; 0000 0290         }
; 0000 0291 
; 0000 0292         senbuff[24] = read_adc(3);
; 0000 0293         if(senbuff[24]>sen[24]) sen[24]=senbuff[24];
; 0000 0294 }
;
;void hitung_skor(void)
; 0000 0297 {
; 0000 0298 	long skor_temp=0;
; 0000 0299 
; 0000 029A         skor_temp = (long)(sen[0]+
;	skor_temp -> Y+0
; 0000 029B         		sen[1]+
; 0000 029C                         sen[2]+
; 0000 029D                         sen[3]+
; 0000 029E                         sen[4]+
; 0000 029F                         sen[5]+
; 0000 02A0                         sen[6]+
; 0000 02A1                         sen[7]+
; 0000 02A2                         sen[8]+
; 0000 02A3                         sen[9]+
; 0000 02A4                         sen[10]+
; 0000 02A5                         sen[11]+
; 0000 02A6                         sen[12]+
; 0000 02A7                         sen[13]+
; 0000 02A8                         sen[14]+
; 0000 02A9                         sen[15]+
; 0000 02AA                         sen[16]+
; 0000 02AB                         sen[17]+
; 0000 02AC                         sen[18]+
; 0000 02AD                         sen[19]+
; 0000 02AE                         sen[20]+
; 0000 02AF                         sen[21]+
; 0000 02B0                         sen[22]+
; 0000 02B1                         sen[23]+
; 0000 02B2                         sen[24]);
; 0000 02B3         skor_temp*=1000;
; 0000 02B4         skor_temp/=6375;
; 0000 02B5         skor=skor_temp;
; 0000 02B6 }
;
;void clear_sensor(void)
; 0000 02B9 {
; 0000 02BA 	char i;
; 0000 02BB 
; 0000 02BC         for(i=0;i<25;i++)
;	i -> R17
; 0000 02BD         {
; 0000 02BE         	sen[i]=0;
; 0000 02BF         }
; 0000 02C0 }
;
;void kirim_to_pc(void)
; 0000 02C3 {
; 0000 02C4 	char 	ribuan,
; 0000 02C5         	ratusan,
; 0000 02C6                 puluhan,
; 0000 02C7                 satuan,
; 0000 02C8                 i;
; 0000 02C9 
; 0000 02CA         ribuan = skor/1000;
;	ribuan -> R17
;	ratusan -> R16
;	puluhan -> R19
;	satuan -> R18
;	i -> R21
; 0000 02CB         ratusan = (skor%1000)/100;
; 0000 02CC         puluhan = ((skor%1000)%100)/10;
; 0000 02CD         satuan = ((skor%1000)%100)%10;
; 0000 02CE 
; 0000 02CF         putchar('c');putchar(ribuan+'0');putchar(ratusan+'0');putchar(puluhan+'0');putchar(satuan+'0');
; 0000 02D0         putchar(13);
; 0000 02D1         for(i=0;i<25;i++)
; 0000 02D2         {
; 0000 02D3         	putchar(sen[i]+'0');
; 0000 02D4         }
; 0000 02D5         putchar(13);
; 0000 02D6 }
;
;void main(void)
; 0000 02D9 {
_main:
; 0000 02DA 	// Declare your local variables here
; 0000 02DB 
; 0000 02DC 	// Input/Output Ports initialization
; 0000 02DD 	// Port A initialization
; 0000 02DE 	// Func7=In Func6=In Func5=In Func4=Out Func3=In Func2=In Func1=In Func0=In
; 0000 02DF 	// State7=T State6=P State5=P State4=0 State3=T State2=T State1=T State0=T
; 0000 02E0 	PORTA=0x60;
	LDI  R30,LOW(96)
	OUT  0x1B,R30
; 0000 02E1 	DDRA=0x10;
	LDI  R30,LOW(16)
	OUT  0x1A,R30
; 0000 02E2 
; 0000 02E3 	// Port B initialization
; 0000 02E4 	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 02E5 	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 02E6 	PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 02E7 	DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 02E8 
; 0000 02E9 	// Port C initialization
; 0000 02EA 	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 02EB 	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 02EC 	PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 02ED 	DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 02EE 
; 0000 02EF 	// Port D initialization
; 0000 02F0 	// Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=In
; 0000 02F1 	// State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=1 State0=P
; 0000 02F2 	PORTD=0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 02F3 	DDRD=0xFE;
	LDI  R30,LOW(254)
	OUT  0x11,R30
; 0000 02F4 
; 0000 02F5 	// Timer/Counter 0 initialization
; 0000 02F6 	// Clock source: System Clock
; 0000 02F7 	// Clock value: 1500.000 kHz
; 0000 02F8 	// Mode: Normal top=0xFF
; 0000 02F9 	// OC0 output: Disconnected
; 0000 02FA 	TCCR0=0x02;
	LDI  R30,LOW(2)
	OUT  0x33,R30
; 0000 02FB 	TCNT0=0x6A;
	LDI  R30,LOW(106)
	OUT  0x32,R30
; 0000 02FC 	OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 02FD 
; 0000 02FE 	// Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 02FF 	TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0300 
; 0000 0301 	// USART initialization
; 0000 0302 	// Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0303 	// USART Receiver: On
; 0000 0304 	// USART Transmitter: On
; 0000 0305 	// USART Mode: Asynchronous
; 0000 0306 	// USART Baud Rate: 9600
; 0000 0307 	UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0308 	UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0309 	UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 030A 	UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 030B 	UBRRL=0x4D;
	LDI  R30,LOW(77)
	OUT  0x9,R30
; 0000 030C 
; 0000 030D 	// Analog Comparator initialization
; 0000 030E 	// Analog Comparator: Off
; 0000 030F 	// Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0310 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0311 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0312 
; 0000 0313 	// ADC initialization
; 0000 0314 	// ADC Clock frequency: 750.000 kHz
; 0000 0315 	// ADC Voltage Reference: AREF pin
; 0000 0316 	// Only the 8 most significant bits of
; 0000 0317 	// the AD conversion result are used
; 0000 0318 	ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0319 	ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 031A 
; 0000 031B 	// Alphanumeric LCD initialization
; 0000 031C 	// Connections specified in the
; 0000 031D 	// Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 031E 	// RS - PORTC Bit 0
; 0000 031F 	// RD - PORTC Bit 1
; 0000 0320 	// EN - PORTC Bit 2
; 0000 0321 	// D4 - PORTC Bit 4
; 0000 0322 	// D5 - PORTC Bit 5
; 0000 0323 	// D6 - PORTC Bit 6
; 0000 0324 	// D7 - PORTC Bit 7
; 0000 0325 	// Characters/line: 16
; 0000 0326 	lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 0327 
; 0000 0328 	// Global enable interrupts
; 0000 0329         lcd_clear();
	RCALL _lcd_clear
; 0000 032A         lcd_putsf("Anten P Analyzer");
	__POINTW1FN _0x0,178
	CALL SUBOPT_0x2
; 0000 032B 	lcd_gotoxy(0,1);
	CALL SUBOPT_0x3
; 0000 032C         lcd_putsf(" Techno  Antena ");
	__POINTW1FN _0x0,195
	CALL SUBOPT_0x2
; 0000 032D 
; 0000 032E         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x4
; 0000 032F 
; 0000 0330 	lcd_clear();
	RCALL _lcd_clear
; 0000 0331         lcd_putsf(" Teknik  Fisika ");
	__POINTW1FN _0x0,212
	CALL SUBOPT_0x2
; 0000 0332 	lcd_gotoxy(0,1);
	CALL SUBOPT_0x3
; 0000 0333         lcd_putsf("    U  G  M    ");
	__POINTW1FN _0x0,229
	CALL SUBOPT_0x2
; 0000 0334 
; 0000 0335         no_menu=0;
	LDI  R30,LOW(0)
	STS  _no_menu,R30
; 0000 0336 
; 0000 0337         #asm("sei")
	sei
; 0000 0338 
; 0000 0339 	while (1)
_0xD7:
; 0000 033A       	{
; 0000 033B       		// Place your code here
; 0000 033C                 //menu();
; 0000 033D                 PORTB = 0;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 033E                 PORTB.4 = 1;
	SBI  0x18,4
; 0000 033F                 PORTB.0 = 1;
	CALL SUBOPT_0x5
; 0000 0340                 delay_ms(1000);
; 0000 0341                 PORTB.0 = 0;
	CALL SUBOPT_0x6
; 0000 0342                 PORTB.1 = 1;
; 0000 0343                 delay_ms(1000);
; 0000 0344                 PORTB.1 = 0;
	CALL SUBOPT_0x7
; 0000 0345                 PORTB.2 = 1;
; 0000 0346                 delay_ms(1000);
; 0000 0347                 PORTB.2 = 0;
	CALL SUBOPT_0x8
; 0000 0348                 PORTB.3 = 1;
; 0000 0349                 delay_ms(1000);
; 0000 034A                 PORTB.3 = 0;
	CBI  0x18,3
; 0000 034B 
; 0000 034C                 PORTB.5 = 1;
	SBI  0x18,5
; 0000 034D                 PORTB.0 = 1;
	CALL SUBOPT_0x5
; 0000 034E                 delay_ms(1000);
; 0000 034F                 PORTB.0 = 0;
	CALL SUBOPT_0x6
; 0000 0350                 PORTB.1 = 1;
; 0000 0351                 delay_ms(1000);
; 0000 0352                 PORTB.1 = 0;
	CALL SUBOPT_0x7
; 0000 0353                 PORTB.2 = 1;
; 0000 0354                 delay_ms(1000);
; 0000 0355                 PORTB.2 = 0;
	CALL SUBOPT_0x8
; 0000 0356                 PORTB.3 = 1;
; 0000 0357                 delay_ms(1000);
; 0000 0358                 PORTB.3 = 0;
	CBI  0x18,3
; 0000 0359 
; 0000 035A                 PORTB.6 = 1;
	SBI  0x18,6
; 0000 035B                 PORTB.0 = 1;
	CALL SUBOPT_0x5
; 0000 035C                 delay_ms(1000);
; 0000 035D                 PORTB.0 = 0;
	CALL SUBOPT_0x6
; 0000 035E                 PORTB.1 = 1;
; 0000 035F                 delay_ms(1000);
; 0000 0360                 PORTB.1 = 0;
	CALL SUBOPT_0x7
; 0000 0361                 PORTB.2 = 1;
; 0000 0362                 delay_ms(1000);
; 0000 0363                 PORTB.2 = 0;
	CALL SUBOPT_0x8
; 0000 0364                 PORTB.3 = 1;
; 0000 0365                 delay_ms(1000);
; 0000 0366                 PORTB.3 = 0;
	CBI  0x18,3
; 0000 0367 
; 0000 0368                 PORTB.7 = 1;
	SBI  0x18,7
; 0000 0369                 PORTB.0 = 1;
	CALL SUBOPT_0x5
; 0000 036A                 delay_ms(1000);
; 0000 036B                 PORTB.0 = 0;
	CALL SUBOPT_0x6
; 0000 036C                 PORTB.1 = 1;
; 0000 036D                 delay_ms(1000);
; 0000 036E                 PORTB.1 = 0;
	CALL SUBOPT_0x7
; 0000 036F                 PORTB.2 = 1;
; 0000 0370                 delay_ms(1000);
; 0000 0371                 PORTB.2 = 0;
	CALL SUBOPT_0x8
; 0000 0372                 PORTB.3 = 1;
; 0000 0373                 delay_ms(1000);
; 0000 0374                 PORTB.3 = 0;
	CBI  0x18,3
; 0000 0375       	}
	RJMP _0xD7
; 0000 0376 }
_0x122:
	RJMP _0x122
;#pragma optsize-
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
__lcd_write_nibble_G100:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2000004
	SBI  0x15,4
	RJMP _0x2000005
_0x2000004:
	CBI  0x15,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x15,5
	RJMP _0x2000007
_0x2000006:
	CBI  0x15,5
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x15,6
	RJMP _0x2000009
_0x2000008:
	CBI  0x15,6
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x15,7
	RJMP _0x200000B
_0x200000A:
	CBI  0x15,7
_0x200000B:
	__DELAY_USB 8
	SBI  0x15,2
	__DELAY_USB 20
	CBI  0x15,2
	__DELAY_USB 20
	RJMP _0x2080001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USB 200
	RJMP _0x2080001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G100)
	SBCI R31,HIGH(-__base_y_G100)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
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
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	RJMP _0x2080001
_0x2000013:
_0x2000010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x15,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x15,0
	RJMP _0x2080001
_lcd_putsf:
	ST   -Y,R17
_0x2000017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000017
_0x2000019:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x14,4
	SBI  0x14,5
	SBI  0x14,6
	SBI  0x14,7
	SBI  0x14,2
	SBI  0x14,0
	SBI  0x14,1
	CBI  0x15,2
	CBI  0x15,0
	CBI  0x15,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x4
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	CALL SUBOPT_0xA
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 300
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
_0x2080001:
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

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8
_lcd:
	.BYTE 0x20
_no_menu:
	.BYTE 0x1
_detik:
	.BYTE 0x1
_adc_menu:
	.BYTE 0x1
_skor:
	.BYTE 0x2
_senbuff:
	.BYTE 0x19
_sen:
	.BYTE 0x19
__base_y_G100:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	SBI  0x18,0
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	CBI  0x18,0
	SBI  0x18,1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	CBI  0x18,1
	SBI  0x18,2
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	CBI  0x18,2
	SBI  0x18,3
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G100
	__DELAY_USW 300
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

;END OF CODE MARKER
__END_OF_CODE:
