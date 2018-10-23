
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
	.DEF _kursorPID=R5
	.DEF _kursorSpeed=R4
	.DEF _kursorGaris=R7
	.DEF _sensor=R6
	.DEF _adc0=R9
	.DEF _adc1=R8
	.DEF _adc2=R11
	.DEF _adc3=R10
	.DEF _adc4=R13
	.DEF _adc5=R12

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
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00

_char0:
	.DB  0x60,0x18,0x6,0x7F,0x7F,0x6,0x18,0x60
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x54,0x75,0x6C,0x69,0x73,0x20,0x6B,0x65
	.DB  0x20,0x45,0x45,0x50,0x52,0x4F,0x4D,0x20
	.DB  0x0,0x2E,0x2E,0x2E,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x53,0x65,0x74,0x20,0x4B,0x70
	.DB  0x20,0x3A,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x53,0x65,0x74,0x20,0x4B
	.DB  0x69,0x20,0x3A,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x53,0x65,0x74,0x20
	.DB  0x4B,0x64,0x20,0x3A,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x53,0x65,0x74
	.DB  0x20,0x4D,0x41,0x58,0x20,0x53,0x70,0x65
	.DB  0x65,0x64,0x20,0x3A,0x20,0x0,0x53,0x65
	.DB  0x74,0x20,0x4D,0x49,0x4E,0x20,0x53,0x70
	.DB  0x65,0x65,0x64,0x20,0x3A,0x20,0x0,0x57
	.DB  0x61,0x72,0x6E,0x61,0x20,0x47,0x61,0x72
	.DB  0x69,0x73,0x20,0x20,0x20,0x3A,0x20,0x0
	.DB  0x53,0x65,0x6E,0x73,0x4C,0x69,0x6E,0x65
	.DB  0x20,0x3A,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x0,0x53,0x6B,0x65,0x6E,0x61,0x72,0x69
	.DB  0x6F,0x20,0x3A,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x53,0x65,0x74,0x20
	.DB  0x50,0x49,0x44,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x0,0x20,0x20,0x53,0x65,0x74
	.DB  0x20,0x53,0x70,0x65,0x65,0x64,0x20,0x20
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x53,0x65
	.DB  0x74,0x20,0x47,0x61,0x72,0x69,0x73,0x20
	.DB  0x20,0x20,0x20,0x20,0x0,0x20,0x20,0x4E
	.DB  0x6F,0x74,0x20,0x55,0x73,0x65,0x64,0x20
	.DB  0x21,0x20,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x53,0x65,0x74,0x20,0x4D,0x6F,0x64,0x65
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x53,0x74,0x61,0x72
	.DB  0x74,0x21,0x21,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x20,0x4B,0x70,0x20,0x20
	.DB  0x20,0x4B,0x69,0x20,0x20,0x20,0x4B,0x64
	.DB  0x20,0x20,0x0,0x20,0x20,0x20,0x4D,0x41
	.DB  0x58,0x20,0x20,0x20,0x20,0x4D,0x49,0x4E
	.DB  0x20,0x20,0x20,0x0,0x20,0x20,0x57,0x41
	.DB  0x52,0x4E,0x41,0x20,0x3A,0x20,0x50,0x75
	.DB  0x74,0x69,0x68,0x20,0x0,0x20,0x20,0x57
	.DB  0x41,0x52,0x4E,0x41,0x20,0x3A,0x20,0x48
	.DB  0x69,0x74,0x61,0x6D,0x20,0x0,0x20,0x20
	.DB  0x53,0x65,0x6E,0x73,0x4C,0x20,0x3A,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x53,0x6B,0x65,0x6E,0x2E,0x20,0x79,0x67
	.DB  0x20,0x20,0x64,0x70,0x61,0x6B,0x65,0x3A
	.DB  0x0,0x20,0x4D,0x6F,0x64,0x65,0x20,0x3A
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x0,0x20,0x31,0x2E,0x4C,0x69,0x68
	.DB  0x61,0x74,0x20,0x41,0x44,0x43,0x0,0x20
	.DB  0x32,0x2E,0x54,0x65,0x73,0x74,0x20,0x4D
	.DB  0x6F,0x64,0x65,0x0,0x20,0x33,0x2E,0x43
	.DB  0x65,0x6B,0x20,0x53,0x65,0x6E,0x73,0x6F
	.DB  0x72,0x20,0x0,0x20,0x34,0x2E,0x41,0x75
	.DB  0x74,0x6F,0x20,0x54,0x75,0x6E,0x65,0x20
	.DB  0x31,0x2D,0x31,0x0,0x20,0x35,0x2E,0x41
	.DB  0x75,0x74,0x6F,0x20,0x54,0x75,0x6E,0x65
	.DB  0x20,0x0,0x20,0x36,0x2E,0x43,0x65,0x6B
	.DB  0x20,0x50,0x57,0x4D,0x20,0x41,0x6B,0x74
	.DB  0x69,0x66,0x0,0x20,0x25,0x64,0x20,0x25
	.DB  0x64,0x20,0x25,0x64,0x20,0x25,0x64,0x0
	.DB  0x20,0x54,0x65,0x73,0x74,0x3A,0x53,0x65
	.DB  0x6E,0x73,0x6F,0x72,0x20,0x20,0x20,0x20
	.DB  0x0,0x20,0x62,0x62,0x30,0x20,0x20,0x62
	.DB  0x61,0x30,0x20,0x20,0x62,0x74,0x30,0x0
	.DB  0x20,0x25,0x64,0x20,0x20,0x25,0x64,0x20
	.DB  0x20,0x25,0x64,0x0,0x20,0x62,0x62,0x31
	.DB  0x20,0x20,0x62,0x61,0x31,0x20,0x20,0x62
	.DB  0x74,0x31,0x0,0x20,0x62,0x62,0x32,0x20
	.DB  0x20,0x62,0x61,0x32,0x20,0x20,0x62,0x74
	.DB  0x32,0x0,0x20,0x62,0x62,0x33,0x20,0x20
	.DB  0x62,0x61,0x33,0x20,0x20,0x62,0x74,0x33
	.DB  0x0,0x20,0x62,0x62,0x34,0x20,0x20,0x62
	.DB  0x61,0x34,0x20,0x20,0x62,0x74,0x34,0x0
	.DB  0x20,0x62,0x62,0x35,0x20,0x20,0x62,0x61
	.DB  0x35,0x20,0x20,0x62,0x74,0x35,0x0,0x20
	.DB  0x62,0x62,0x36,0x20,0x20,0x62,0x61,0x36
	.DB  0x20,0x20,0x62,0x74,0x36,0x0,0x20,0x62
	.DB  0x62,0x37,0x20,0x20,0x62,0x61,0x37,0x20
	.DB  0x20,0x62,0x74,0x37,0x0,0x25,0x64,0x20
	.DB  0x25,0x64,0x20,0x25,0x64,0x20,0x25,0x64
	.DB  0x20,0x25,0x64,0x20,0x25,0x64,0x20,0x25
	.DB  0x64,0x20,0x25,0x64,0x0,0x25,0x64,0x20
	.DB  0x20,0x20,0x25,0x64,0x0,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x0,0x20,0x53
	.DB  0x6B,0x65,0x6E,0x61,0x72,0x69,0x6F,0x2D
	.DB  0x53,0x74,0x61,0x72,0x74,0x41,0x0,0x20
	.DB  0x20,0x4F,0x4B,0x20,0x3F,0x0,0x20,0x20
	.DB  0x53,0x6B,0x65,0x6E,0x61,0x72,0x69,0x6F
	.DB  0x2D,0x31,0x41,0x0,0x20,0x20,0x53,0x6B
	.DB  0x65,0x6E,0x61,0x72,0x69,0x6F,0x2D,0x32
	.DB  0x41,0x0,0x20,0x20,0x53,0x6B,0x65,0x6E
	.DB  0x61,0x72,0x69,0x6F,0x2D,0x33,0x41,0x0
	.DB  0x20,0x20,0x53,0x6B,0x65,0x6E,0x61,0x72
	.DB  0x69,0x6F,0x2D,0x34,0x41,0x0,0x20,0x20
	.DB  0x53,0x6B,0x65,0x6E,0x61,0x72,0x69,0x6F
	.DB  0x2D,0x35,0x41,0x0,0x20,0x53,0x6B,0x65
	.DB  0x6E,0x61,0x72,0x69,0x6F,0x2D,0x53,0x74
	.DB  0x61,0x72,0x74,0x42,0x0,0x20,0x20,0x53
	.DB  0x6B,0x65,0x6E,0x61,0x72,0x69,0x6F,0x2D
	.DB  0x31,0x42,0x0,0x20,0x20,0x53,0x6B,0x65
	.DB  0x6E,0x61,0x72,0x69,0x6F,0x2D,0x32,0x42
	.DB  0x0,0x20,0x20,0x53,0x6B,0x65,0x6E,0x61
	.DB  0x72,0x69,0x6F,0x2D,0x33,0x42,0x0,0x20
	.DB  0x20,0x53,0x6B,0x65,0x6E,0x61,0x72,0x69
	.DB  0x6F,0x2D,0x34,0x42,0x0,0x20,0x20,0x53
	.DB  0x6B,0x65,0x6E,0x61,0x72,0x69,0x6F,0x2D
	.DB  0x35,0x42,0x0
_0x2020003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  0x02
	.DW  __REG_BIT_VARS*2

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
;Project : Line Follower Micro - Liffoco 2012
;Version : v1.0
;Date    : 12/6/2012
;Author  : Handiko Gesang
;Company : Lab. STTK
;Comments: Lalalalalalalala
;
;
;Chip type               : ATmega16
;Program type            : Application
;AVR Core Clock frequency: 12.000000 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
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
;#include <delay.h>
;
;// Alphanumeric LCD Module functions
;#include <alcd.h>
;
;#define ADC_VREF_TYPE 0x20
;
;#define sw_up           PIND.4
;#define sw_down         PIND.6
;#define sw_ok           PIND.5
;#define sw_cancel       PIND.3
;
;#define backlight       PORTB.3
;
;//#define sKa     PINC.0
;//#define sKi     PINC.1
;
;#define Enki    PORTC.2
;#define kirplus PORTC.3
;#define kirmin  PORTC.4
;#define Enka    PORTC.5
;#define kaplus  PORTC.7
;#define kamin   PORTC.6
;
;bit s0,s1,s2,s3,s4,s5,s6,s7,sKa,sKi;
;char lcd[32];
;//char diffPWM = 10;
;unsigned char kursorPID, kursorSpeed, kursorGaris;
;unsigned char sensor, adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7;
;unsigned char xcount;
;unsigned char SP = 0;
;int lpwm, rpwm, MAXPWM, MINPWM, intervalPWM;
;int MV, P, I, D, PV, error, last_error, rate;
;int var_Kp, var_Ki, var_Kd;
;
;eeprom unsigned char Kp = 17; //33
;eeprom unsigned char Ki = 0;
;eeprom unsigned char Kd = 11; //16
;eeprom unsigned char tempKp = 17; //33
;eeprom unsigned char tempKi = 0;
;eeprom unsigned char tempKd = 11; //16
;eeprom unsigned char MAXSpeed = 255;
;eeprom unsigned char MINSpeed = 105;
;eeprom unsigned char WarnaGaris = 1; // 1 : putih; 0 : hitam
;eeprom unsigned char SensLine = 2; // banyaknya sensor dlm 1 garis
;eeprom unsigned char Skenario = 2;
;eeprom unsigned char Mode = 1;
;eeprom unsigned char NoStrategi = 1;
;eeprom unsigned char bt7=7,bt6=7,bt5=7,bt4=7,bt3=7,bt2=7,bt1=7,bt0=7;
;eeprom unsigned char ba7=7,ba6=7,ba5=7,ba4=7,ba3=7,ba2=7,ba1=7,ba0=7;
;eeprom unsigned char bb7=200,bb6=200,bb5=200,bb4=200,bb3=200,bb2=200,bb1=200,bb0=200;
;
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 004F {

	.CSEG
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0050         // Place your code here
; 0000 0051         xcount++;
	LDS  R30,_xcount
	SUBI R30,-LOW(1)
	STS  _xcount,R30
; 0000 0052         if(xcount<=lpwm)Enki=1;
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRLT _0x3
	SBI  0x15,2
; 0000 0053         else Enki=0;
	RJMP _0x6
_0x3:
	CBI  0x15,2
; 0000 0054         if(xcount<=rpwm)Enka=1;
_0x6:
	CALL SUBOPT_0x2
	CALL SUBOPT_0x1
	BRLT _0x9
	SBI  0x15,5
; 0000 0055         else Enka=0;
	RJMP _0xC
_0x9:
	CBI  0x15,5
; 0000 0056         TCNT0=0xFF;
_0xC:
	LDI  R30,LOW(255)
	OUT  0x32,R30
; 0000 0057 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;
;typedef unsigned char byte;
;flash byte char0[8]={
;0b1100000,
;0b0011000,
;0b0000110,
;0b1111111,
;0b1111111,
;0b0000110,
;0b0011000,
;0b1100000};
;
;unsigned char read_adc(unsigned char adc_input);
;void define_char(byte flash *pc,byte char_code);
;void tampil(unsigned char dat);
;void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom );
;void setByte( byte NoMenu, byte NoSubMenu );
;void showMenu(void);
;void baca_sensor(void);
;void displaySensorBit(void);
;void maju(void);
;void mundur(void);
;void stop(char s);
;void pemercepat(void);
;void pelambat(void);
;void rotkan(void);
;void rotkir(void);
;void cek_sensor(void);
;void tune_batas(void);
;void auto_scan(void);
;void scanBlackLine(void);
;void scanSudut(void);
;void cekPointStarta(void);
;void cekPoint1a(void);
;void cekPoint2a(void);
;void cekPoint3a(void);
;void cekPoint4a(void);
;void cekPoint5a(void);
;void strategiA(void);
;void cekPointStartb(void);
;void cekPoint1b(void);
;void cekPoint2b(void);
;void cekPoint3b(void);
;void cekPoint4b(void);
;void cekPoint5b(void);
;void strategiB(void);
;void indikatorSudut(void);
;void indikatorPerempatan(void);
;
;unsigned char read_adc(unsigned char adc_input)
; 0000 008A {
_read_adc:
; 0000 008B         ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 008C 
; 0000 008D         // Delay needed for the stabilization of the ADC input voltage
; 0000 008E         delay_us(10);
	__DELAY_USB 40
; 0000 008F 
; 0000 0090         // Start the AD conversion
; 0000 0091         ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0092 
; 0000 0093         // Wait for the AD conversion to complete
; 0000 0094         while ((ADCSRA & 0x10)==0);
_0xF:
	SBIS 0x6,4
	RJMP _0xF
; 0000 0095         ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0096         return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0097 }
;
;void define_char(byte flash *pc,byte char_code)
; 0000 009A {
_define_char:
; 0000 009B         byte i,a;
; 0000 009C         a=(char_code<<3) | 0x40;
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
; 0000 009D         for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
	LDI  R17,LOW(0)
_0x13:
	CPI  R17,8
	BRSH _0x14
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R30,Z
	ST   -Y,R30
	CALL _lcd_write_byte
	SUBI R17,-1
	RJMP _0x13
_0x14:
; 0000 009E }
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;
;void tampil(unsigned char dat)
; 0000 00A1 {
_tampil:
; 0000 00A2         unsigned char data;
; 0000 00A3 
; 0000 00A4         data = dat / 100;
	ST   -Y,R17
;	dat -> Y+1
;	data -> R17
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x3
; 0000 00A5         data+=0x30;
; 0000 00A6         lcd_putchar(data);
; 0000 00A7 
; 0000 00A8         dat%=100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	STD  Y+1,R30
; 0000 00A9         data = dat / 10;
	LDD  R26,Y+1
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x3
; 0000 00AA         data+=0x30;
; 0000 00AB         lcd_putchar(data);
; 0000 00AC 
; 0000 00AD         dat%=10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STD  Y+1,R30
; 0000 00AE         data = dat + 0x30;
	SUBI R30,-LOW(48)
	MOV  R17,R30
; 0000 00AF         lcd_putchar(data);
	ST   -Y,R17
	CALL _lcd_putchar
; 0000 00B0 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom )
; 0000 00B3 {
_tulisKeEEPROM:
; 0000 00B4         lcd_gotoxy(0, 0);
;	NoMenu -> Y+2
;	NoSubMenu -> Y+1
;	var_in_eeprom -> Y+0
	CALL SUBOPT_0x4
; 0000 00B5         lcd_putsf("Tulis ke EEPROM ");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0x5
; 0000 00B6         lcd_putsf("...             ");
	__POINTW1FN _0x0,17
	CALL SUBOPT_0x5
; 0000 00B7         switch (NoMenu)
	LDD  R30,Y+2
	CALL SUBOPT_0x6
; 0000 00B8         {
; 0000 00B9                 case 1: // PID
	BRNE _0x18
; 0000 00BA                 switch (NoSubMenu)
	LDD  R30,Y+1
	CALL SUBOPT_0x6
; 0000 00BB                 {
; 0000 00BC                         case 1: // Kp
	BRNE _0x1C
; 0000 00BD                         Kp = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	RJMP _0x3B4
; 0000 00BE                         break;
; 0000 00BF 
; 0000 00C0                         case 2: // Ki
_0x1C:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1D
; 0000 00C1                         Ki = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	RJMP _0x3B4
; 0000 00C2                         break;
; 0000 00C3 
; 0000 00C4                         case 3: // Kd
_0x1D:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1B
; 0000 00C5                         Kd = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
_0x3B4:
	CALL __EEPROMWRB
; 0000 00C6                         break;
; 0000 00C7                 }
_0x1B:
; 0000 00C8                 break;
	RJMP _0x17
; 0000 00C9 
; 0000 00CA                 case 2: // Speed
_0x18:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x1F
; 0000 00CB                 switch (NoSubMenu)
	LDD  R30,Y+1
	CALL SUBOPT_0x6
; 0000 00CC                 {
; 0000 00CD                         case 1: // MAX
	BRNE _0x23
; 0000 00CE                         MAXSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	RJMP _0x3B5
; 0000 00CF                         break;
; 0000 00D0 
; 0000 00D1                         case 2: // MIN
_0x23:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x22
; 0000 00D2                         MINSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
_0x3B5:
	CALL __EEPROMWRB
; 0000 00D3                         break;
; 0000 00D4                 }
_0x22:
; 0000 00D5                 break;
	RJMP _0x17
; 0000 00D6 
; 0000 00D7                 case 3: // Warna Garis
_0x1F:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x25
; 0000 00D8                 switch (NoSubMenu)
	LDD  R30,Y+1
	CALL SUBOPT_0x6
; 0000 00D9                 {
; 0000 00DA                         case 1: // Warna
	BRNE _0x29
; 0000 00DB                         WarnaGaris = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	RJMP _0x3B6
; 0000 00DC                         break;
; 0000 00DD 
; 0000 00DE                         case 2: // SensL
_0x29:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x28
; 0000 00DF                         SensLine = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
_0x3B6:
	CALL __EEPROMWRB
; 0000 00E0                         break;
; 0000 00E1                 }
_0x28:
; 0000 00E2                 break;
	RJMP _0x17
; 0000 00E3 
; 0000 00E4                 case 4: // Skenario
_0x25:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x17
; 0000 00E5                 Skenario = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMWRB
; 0000 00E6                 break;
; 0000 00E7         }
_0x17:
; 0000 00E8         delay_ms(200);
	CALL SUBOPT_0x7
; 0000 00E9 }
	ADIW R28,3
	RET
;
;void setByte( byte NoMenu, byte NoSubMenu )
; 0000 00EC {
_setByte:
; 0000 00ED         byte var_in_eeprom;
; 0000 00EE         byte plus5 = 0;
; 0000 00EF         char limitPilih = -1;
; 0000 00F0 
; 0000 00F1         lcd_clear();
	CALL __SAVELOCR4
;	NoMenu -> Y+5
;	NoSubMenu -> Y+4
;	var_in_eeprom -> R17
;	plus5 -> R16
;	limitPilih -> R19
	LDI  R16,0
	LDI  R19,255
	CALL SUBOPT_0x8
; 0000 00F2         lcd_gotoxy(0, 0);
; 0000 00F3         switch (NoMenu)
	LDD  R30,Y+5
	CALL SUBOPT_0x6
; 0000 00F4         {
; 0000 00F5                 case 1: // PID
	BRNE _0x2F
; 0000 00F6                 switch (NoSubMenu)
	LDD  R30,Y+4
	CALL SUBOPT_0x6
; 0000 00F7                 {
; 0000 00F8                         case 1: // Kp
	BRNE _0x33
; 0000 00F9                         lcd_putsf("Set Kp :        ");
	__POINTW1FN _0x0,34
	CALL SUBOPT_0x5
; 0000 00FA                         var_in_eeprom = Kp;
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	RJMP _0x3B7
; 0000 00FB                         break;
; 0000 00FC 
; 0000 00FD                         case 2: // Ki
_0x33:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x34
; 0000 00FE                         lcd_putsf("Set Ki :        ");
	__POINTW1FN _0x0,51
	CALL SUBOPT_0x5
; 0000 00FF                         var_in_eeprom = Ki;
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	RJMP _0x3B7
; 0000 0100                         break;
; 0000 0101 
; 0000 0102                         case 3: // Kd
_0x34:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x32
; 0000 0103                         lcd_putsf("Set Kd :        ");
	__POINTW1FN _0x0,68
	CALL SUBOPT_0x5
; 0000 0104                         var_in_eeprom = Kd;
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
_0x3B7:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 0105                         break;
; 0000 0106                 }
_0x32:
; 0000 0107                 break;
	RJMP _0x2E
; 0000 0108 
; 0000 0109                 case 2: // Speed
_0x2F:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x36
; 0000 010A                 plus5 = 1;
	LDI  R16,LOW(1)
; 0000 010B                 switch (NoSubMenu)
	LDD  R30,Y+4
	CALL SUBOPT_0x6
; 0000 010C                 {
; 0000 010D                         case 1: // MAX
	BRNE _0x3A
; 0000 010E                         lcd_putsf("Set MAX Speed : ");
	__POINTW1FN _0x0,85
	CALL SUBOPT_0x5
; 0000 010F                         var_in_eeprom = MAXSpeed;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	RJMP _0x3B8
; 0000 0110                         break;
; 0000 0111 
; 0000 0112                         case 2: // MIN
_0x3A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x39
; 0000 0113                         lcd_putsf("Set MIN Speed : ");
	__POINTW1FN _0x0,102
	CALL SUBOPT_0x5
; 0000 0114                         var_in_eeprom = MINSpeed;
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
_0x3B8:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 0115                         break;
; 0000 0116                 }
_0x39:
; 0000 0117                 break;
	RJMP _0x2E
; 0000 0118 
; 0000 0119                 case 3: // Warna Garis
_0x36:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x3C
; 0000 011A                 switch (NoSubMenu)
	LDD  R30,Y+4
	CALL SUBOPT_0x6
; 0000 011B                 {
; 0000 011C                         case 1: // Warna
	BRNE _0x40
; 0000 011D                         limitPilih = 1;
	LDI  R19,LOW(1)
; 0000 011E                         lcd_putsf("Warna Garis   : ");
	__POINTW1FN _0x0,119
	CALL SUBOPT_0x5
; 0000 011F                         var_in_eeprom = WarnaGaris;
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	RJMP _0x3B9
; 0000 0120                         break;
; 0000 0121 
; 0000 0122                         case 2: // SensL
_0x40:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x3F
; 0000 0123                         limitPilih = 3;
	LDI  R19,LOW(3)
; 0000 0124                         lcd_putsf("SensLine :      ");
	__POINTW1FN _0x0,136
	CALL SUBOPT_0x5
; 0000 0125                         var_in_eeprom = SensLine;
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
_0x3B9:
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 0126                         break;
; 0000 0127                 }
_0x3F:
; 0000 0128                 break;
	RJMP _0x2E
; 0000 0129 
; 0000 012A                 case 4: // Skenario
_0x3C:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0x2E
; 0000 012B                 lcd_putsf("Skenario :      ");
	__POINTW1FN _0x0,153
	CALL SUBOPT_0x5
; 0000 012C                 var_in_eeprom = Skenario;
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	MOV  R17,R30
; 0000 012D                 limitPilih = 8;
	LDI  R19,LOW(8)
; 0000 012E                 break;
; 0000 012F         }
_0x2E:
; 0000 0130 
; 0000 0131         while (sw_cancel)
_0x43:
	SBIS 0x10,3
	RJMP _0x45
; 0000 0132         {
; 0000 0133                 delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0134                 lcd_gotoxy(0, 1);
	CALL SUBOPT_0xA
; 0000 0135                 tampil(var_in_eeprom);
	ST   -Y,R17
	RCALL _tampil
; 0000 0136 
; 0000 0137                 if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x46
; 0000 0138                 {
; 0000 0139                         lcd_clear();
	CALL _lcd_clear
; 0000 013A                         tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R17
	RCALL _tulisKeEEPROM
; 0000 013B                         goto exitSetByte;
	RJMP _0x47
; 0000 013C                 }
; 0000 013D 
; 0000 013E                 if (!sw_down)
_0x46:
	SBIC 0x10,6
	RJMP _0x48
; 0000 013F                 {
; 0000 0140                         if ( plus5 )
	CPI  R16,0
	BREQ _0x49
; 0000 0141                                 if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x4A
; 0000 0142                                         var_in_eeprom = 255;
	LDI  R17,LOW(255)
; 0000 0143                                 else
	RJMP _0x4B
_0x4A:
; 0000 0144                                         var_in_eeprom -= 5;
	MOV  R30,R17
	LDI  R31,0
	SBIW R30,5
	MOV  R17,R30
; 0000 0145                         else
_0x4B:
	RJMP _0x4C
_0x49:
; 0000 0146                                 if ( !limitPilih )
	CPI  R19,0
	BREQ _0x3BA
; 0000 0147                                         var_in_eeprom--;
; 0000 0148                                 else
; 0000 0149                                 {
; 0000 014A                                         if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x4F
; 0000 014B                                                 var_in_eeprom = limitPilih;
	MOV  R17,R19
; 0000 014C                                         else
	RJMP _0x50
_0x4F:
; 0000 014D                                                 var_in_eeprom--;
_0x3BA:
	SUBI R17,1
; 0000 014E                                 }
_0x50:
_0x4C:
; 0000 014F                 }
; 0000 0150 
; 0000 0151                 if (!sw_up)
_0x48:
	SBIC 0x10,4
	RJMP _0x51
; 0000 0152                 {
; 0000 0153                         if ( plus5 )
	CPI  R16,0
	BREQ _0x52
; 0000 0154                                 if ( var_in_eeprom == 255 )
	CPI  R17,255
	BRNE _0x53
; 0000 0155                                         var_in_eeprom = 0;
	LDI  R17,LOW(0)
; 0000 0156                                 else
	RJMP _0x54
_0x53:
; 0000 0157                                         var_in_eeprom += 5;
	SUBI R17,-LOW(5)
; 0000 0158                         else
_0x54:
	RJMP _0x55
_0x52:
; 0000 0159                                 if ( !limitPilih )
	CPI  R19,0
	BREQ _0x3BB
; 0000 015A                                         var_in_eeprom++;
; 0000 015B                                 else
; 0000 015C                                 {
; 0000 015D                                         if ( var_in_eeprom == limitPilih )
	CP   R19,R17
	BRNE _0x58
; 0000 015E                                                 var_in_eeprom = 0;
	LDI  R17,LOW(0)
; 0000 015F                                         else
	RJMP _0x59
_0x58:
; 0000 0160                                                 var_in_eeprom++;
_0x3BB:
	SUBI R17,-1
; 0000 0161                                 }
_0x59:
_0x55:
; 0000 0162                 }
; 0000 0163         }
_0x51:
	RJMP _0x43
_0x45:
; 0000 0164 
; 0000 0165         exitSetByte:
_0x47:
; 0000 0166         delay_ms(100);
	CALL SUBOPT_0xB
; 0000 0167         lcd_clear();
; 0000 0168 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;
;void showMenu(void)
; 0000 016B {
_showMenu:
; 0000 016C         lcd_clear();
	CALL _lcd_clear
; 0000 016D     menu01:
_0x5A:
; 0000 016E         delay_ms(125);   // bouncing sw
	CALL SUBOPT_0xC
; 0000 016F         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0170                 // 0123456789abcdef
; 0000 0171         lcd_putsf("  Set PID       ");
	__POINTW1FN _0x0,170
	CALL SUBOPT_0x5
; 0000 0172         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0173         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x5
; 0000 0174 
; 0000 0175         // kursor awal
; 0000 0176         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0177         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0178 
; 0000 0179         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x5B
; 0000 017A         {
; 0000 017B                 lcd_clear();
	CALL _lcd_clear
; 0000 017C                 kursorPID = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 017D                 goto setPID;
	RJMP _0x5C
; 0000 017E         }
; 0000 017F         if (!sw_down)
_0x5B:
	SBIS 0x10,6
; 0000 0180         {
; 0000 0181                 goto menu02;
	RJMP _0x5E
; 0000 0182         }
; 0000 0183         if (!sw_up)
	SBIC 0x10,4
	RJMP _0x5F
; 0000 0184         {
; 0000 0185                 lcd_clear();
	CALL _lcd_clear
; 0000 0186                 goto menu06;
	RJMP _0x60
; 0000 0187         }
; 0000 0188         if (!sw_cancel)
_0x5F:
	SBIC 0x10,3
	RJMP _0x61
; 0000 0189         {
; 0000 018A                 delay_ms(125);
	CALL SUBOPT_0xC
; 0000 018B                 backlight = 0;
	CBI  0x18,3
; 0000 018C         }
; 0000 018D 
; 0000 018E         goto menu01;
_0x61:
	RJMP _0x5A
; 0000 018F     menu02:
_0x5E:
; 0000 0190         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0191         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0192                  // 0123456789abcdef
; 0000 0193         lcd_putsf("  Set PID       ");
	__POINTW1FN _0x0,170
	CALL SUBOPT_0x5
; 0000 0194         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0195         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0x0,187
	CALL SUBOPT_0x5
; 0000 0196 
; 0000 0197         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0198         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0199 
; 0000 019A         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x64
; 0000 019B         {
; 0000 019C                 lcd_clear();
	CALL _lcd_clear
; 0000 019D                 kursorSpeed = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 019E                 goto setSpeed;
	RJMP _0x65
; 0000 019F         }
; 0000 01A0         if (!sw_up)
_0x64:
	SBIS 0x10,4
; 0000 01A1         {
; 0000 01A2                 goto menu01;
	RJMP _0x5A
; 0000 01A3         }
; 0000 01A4         if (!sw_down)
	SBIC 0x10,6
	RJMP _0x67
; 0000 01A5         {
; 0000 01A6                 lcd_clear();
	CALL _lcd_clear
; 0000 01A7                 goto menu03;
	RJMP _0x68
; 0000 01A8         }
; 0000 01A9         if (!sw_cancel)
_0x67:
	SBIC 0x10,3
	RJMP _0x69
; 0000 01AA         {
; 0000 01AB                 delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01AC                 backlight = 0;
	CBI  0x18,3
; 0000 01AD         }
; 0000 01AE         goto menu02;
_0x69:
	RJMP _0x5E
; 0000 01AF     menu03:
_0x68:
; 0000 01B0         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01B1         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 01B2                 // 0123456789abcdef
; 0000 01B3         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0x0,204
	CALL SUBOPT_0x5
; 0000 01B4         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 01B5         lcd_putsf("  Not Used !    ");
	__POINTW1FN _0x0,221
	CALL SUBOPT_0x5
; 0000 01B6 
; 0000 01B7         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 01B8         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 01B9 
; 0000 01BA         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x6C
; 0000 01BB         {
; 0000 01BC                 lcd_clear();
	CALL _lcd_clear
; 0000 01BD                 kursorGaris = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 01BE                 goto setGaris;
	RJMP _0x6D
; 0000 01BF         }
; 0000 01C0         if (!sw_up)
_0x6C:
	SBIC 0x10,4
	RJMP _0x6E
; 0000 01C1         {
; 0000 01C2                 lcd_clear();
	CALL _lcd_clear
; 0000 01C3                 goto menu02;
	RJMP _0x5E
; 0000 01C4         }
; 0000 01C5         if (!sw_down)
_0x6E:
	SBIS 0x10,6
; 0000 01C6         {
; 0000 01C7                 goto menu04;
	RJMP _0x70
; 0000 01C8         }
; 0000 01C9         if (!sw_cancel)
	SBIC 0x10,3
	RJMP _0x71
; 0000 01CA         {
; 0000 01CB                 delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01CC                 backlight = 0;
	CBI  0x18,3
; 0000 01CD         }
; 0000 01CE         goto menu03;
_0x71:
	RJMP _0x68
; 0000 01CF     menu04:
_0x70:
; 0000 01D0         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01D1         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 01D2                 // 0123456789abcdef
; 0000 01D3         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0x0,204
	CALL SUBOPT_0x5
; 0000 01D4         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 01D5         lcd_putsf("  Not Used !    ");
	__POINTW1FN _0x0,221
	CALL SUBOPT_0x5
; 0000 01D6 
; 0000 01D7         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 01D8         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 01D9 
; 0000 01DA         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x74
; 0000 01DB         {
; 0000 01DC                 lcd_clear();
	CALL _lcd_clear
; 0000 01DD                 goto setSkenario;
	RJMP _0x75
; 0000 01DE         }
; 0000 01DF         if (!sw_up)
_0x74:
	SBIS 0x10,4
; 0000 01E0         {
; 0000 01E1                 goto menu03;
	RJMP _0x68
; 0000 01E2         }
; 0000 01E3         if (!sw_down)
	SBIC 0x10,6
	RJMP _0x77
; 0000 01E4         {
; 0000 01E5                 lcd_clear();
	CALL _lcd_clear
; 0000 01E6                 goto menu05;
	RJMP _0x78
; 0000 01E7         }
; 0000 01E8         if (!sw_cancel)
_0x77:
	SBIC 0x10,3
	RJMP _0x79
; 0000 01E9         {
; 0000 01EA                 delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01EB                 backlight = 0;
	CBI  0x18,3
; 0000 01EC         }
; 0000 01ED         goto menu04;
_0x79:
	RJMP _0x70
; 0000 01EE     menu05:            // Bikin sendiri lhoo ^^d
_0x78:
; 0000 01EF         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 01F0         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 01F1         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0x0,238
	CALL SUBOPT_0x5
; 0000 01F2         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 01F3         lcd_putsf("  Start!!      ");
	__POINTW1FN _0x0,258
	CALL SUBOPT_0x5
; 0000 01F4 
; 0000 01F5         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 01F6         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 01F7 
; 0000 01F8         if  (!sw_ok)
	SBIC 0x10,5
	RJMP _0x7C
; 0000 01F9         {
; 0000 01FA             lcd_clear();
	CALL _lcd_clear
; 0000 01FB             goto mode;
	RJMP _0x7D
; 0000 01FC         }
; 0000 01FD 
; 0000 01FE         if  (!sw_up)
_0x7C:
	SBIC 0x10,4
	RJMP _0x7E
; 0000 01FF         {
; 0000 0200             lcd_clear();
	CALL _lcd_clear
; 0000 0201             goto menu04;
	RJMP _0x70
; 0000 0202         }
; 0000 0203 
; 0000 0204         if  (!sw_down)
_0x7E:
	SBIS 0x10,6
; 0000 0205         {
; 0000 0206             goto menu06;
	RJMP _0x60
; 0000 0207         }
; 0000 0208         if (!sw_cancel)
	SBIC 0x10,3
	RJMP _0x80
; 0000 0209         {
; 0000 020A                 delay_ms(125);
	CALL SUBOPT_0xC
; 0000 020B                 backlight = 0;
	CBI  0x18,3
; 0000 020C         }
; 0000 020D 
; 0000 020E         goto menu05;
_0x80:
	RJMP _0x78
; 0000 020F     menu06:
_0x60:
; 0000 0210         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0211         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0212         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0x0,238
	CALL SUBOPT_0x5
; 0000 0213         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0214         lcd_putsf("  Start!!      ");
	__POINTW1FN _0x0,258
	CALL SUBOPT_0x5
; 0000 0215 
; 0000 0216         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0217         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0218 
; 0000 0219         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x83
; 0000 021A         {
; 0000 021B                 lcd_clear();
	CALL _lcd_clear
; 0000 021C                 goto startRobot;
	RJMP _0x84
; 0000 021D         }
; 0000 021E 
; 0000 021F         if (!sw_up)
_0x83:
	SBIS 0x10,4
; 0000 0220         {
; 0000 0221                 goto menu05;
	RJMP _0x78
; 0000 0222         }
; 0000 0223 
; 0000 0224         if (!sw_down)
	SBIC 0x10,6
	RJMP _0x86
; 0000 0225         {
; 0000 0226                 lcd_clear();
	CALL _lcd_clear
; 0000 0227                 goto menu01;
	RJMP _0x5A
; 0000 0228         }
; 0000 0229 
; 0000 022A         goto menu06;
_0x86:
	RJMP _0x60
; 0000 022B 
; 0000 022C 
; 0000 022D     setPID:
_0x5C:
; 0000 022E         delay_ms(150);
	CALL SUBOPT_0x9
; 0000 022F         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0230                 // 0123456789ABCDEF
; 0000 0231         lcd_putsf("  Kp   Ki   Kd  ");
	__POINTW1FN _0x0,274
	CALL SUBOPT_0x5
; 0000 0232         // lcd_putsf(" 250  200  300  ");
; 0000 0233         lcd_putchar(' ');
	CALL SUBOPT_0xE
; 0000 0234         tampil(Kp); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0xF
	CALL SUBOPT_0x10
	CALL SUBOPT_0xE
; 0000 0235         tampil(Ki); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x11
	CALL SUBOPT_0x10
	CALL SUBOPT_0xE
; 0000 0236         tampil(Kd); lcd_putchar(' '); lcd_putchar(' ');
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL SUBOPT_0x12
	CALL SUBOPT_0xE
; 0000 0237 
; 0000 0238         switch (kursorPID)
	MOV  R30,R5
	CALL SUBOPT_0x6
; 0000 0239         {
; 0000 023A           case 1:
	BRNE _0x8A
; 0000 023B                 lcd_gotoxy(1,0); // kursor Kp
	LDI  R30,LOW(1)
	RJMP _0x3BC
; 0000 023C                 lcd_putchar(0);
; 0000 023D                 break;
; 0000 023E           case 2:
_0x8A:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x8B
; 0000 023F                 lcd_gotoxy(6,0); // kursor Ki
	LDI  R30,LOW(6)
	RJMP _0x3BC
; 0000 0240                 lcd_putchar(0);
; 0000 0241                 break;
; 0000 0242           case 3:
_0x8B:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x89
; 0000 0243                 lcd_gotoxy(11,0); // kursor Kd
	LDI  R30,LOW(11)
_0x3BC:
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 0244                 lcd_putchar(0);
; 0000 0245                 break;
; 0000 0246         }
_0x89:
; 0000 0247 
; 0000 0248         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x8D
; 0000 0249         {
; 0000 024A                 setByte( 1, kursorPID);
	LDI  R30,LOW(1)
	ST   -Y,R30
	ST   -Y,R5
	CALL SUBOPT_0x14
; 0000 024B                 delay_ms(200);
; 0000 024C         }
; 0000 024D         if (!sw_up)
_0x8D:
	SBIC 0x10,4
	RJMP _0x8E
; 0000 024E         {
; 0000 024F                 if (kursorPID == 3) {
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x8F
; 0000 0250                         kursorPID = 1;
	LDI  R30,LOW(1)
	MOV  R5,R30
; 0000 0251                 } else kursorPID++;
	RJMP _0x90
_0x8F:
	INC  R5
; 0000 0252         }
_0x90:
; 0000 0253         if (!sw_down)
_0x8E:
	SBIC 0x10,6
	RJMP _0x91
; 0000 0254         {
; 0000 0255                 if (kursorPID == 1) {
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x92
; 0000 0256                         kursorPID = 3;
	LDI  R30,LOW(3)
	MOV  R5,R30
; 0000 0257                 } else kursorPID--;
	RJMP _0x93
_0x92:
	DEC  R5
; 0000 0258         }
_0x93:
; 0000 0259 
; 0000 025A         if (!sw_cancel)
_0x91:
	SBIC 0x10,3
	RJMP _0x94
; 0000 025B         {
; 0000 025C                 lcd_clear();
	CALL _lcd_clear
; 0000 025D                 goto menu01;
	RJMP _0x5A
; 0000 025E         }
; 0000 025F 
; 0000 0260         goto setPID;
_0x94:
	RJMP _0x5C
; 0000 0261 
; 0000 0262     setSpeed:
_0x65:
; 0000 0263         delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0264         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0265                 // 0123456789ABCDEF
; 0000 0266         lcd_putsf("   MAX    MIN   ");
	__POINTW1FN _0x0,291
	CALL SUBOPT_0x5
; 0000 0267         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
; 0000 0268 
; 0000 0269         //lcd_putsf("   250    200   ");
; 0000 026A         tampil(MAXSpeed);
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL SUBOPT_0x12
; 0000 026B         lcd_putchar(' '); lcd_putchar(' ');lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
; 0000 026C         tampil(MINSpeed);
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x12
; 0000 026D         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0xE
	CALL SUBOPT_0xE
; 0000 026E 
; 0000 026F         switch (kursorSpeed)
	MOV  R30,R4
	CALL SUBOPT_0x6
; 0000 0270         {
; 0000 0271           case 1:
	BRNE _0x98
; 0000 0272                 lcd_gotoxy(2,0); // kursor MAX
	LDI  R30,LOW(2)
	RJMP _0x3BD
; 0000 0273                 lcd_putchar(0);
; 0000 0274                 break;
; 0000 0275           case 2:
_0x98:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0x97
; 0000 0276                 lcd_gotoxy(9,0); // kursor MIN
	LDI  R30,LOW(9)
_0x3BD:
	ST   -Y,R30
	CALL SUBOPT_0x13
; 0000 0277                 lcd_putchar(0);
; 0000 0278                 break;
; 0000 0279         }
_0x97:
; 0000 027A 
; 0000 027B         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0x9A
; 0000 027C         {
; 0000 027D                 setByte( 2, kursorSpeed);
	LDI  R30,LOW(2)
	ST   -Y,R30
	ST   -Y,R4
	CALL SUBOPT_0x14
; 0000 027E                 delay_ms(200);
; 0000 027F         }
; 0000 0280         if (!sw_up)
_0x9A:
	SBIC 0x10,4
	RJMP _0x9B
; 0000 0281         {
; 0000 0282                 if (kursorSpeed == 2)
	LDI  R30,LOW(2)
	CP   R30,R4
	BRNE _0x9C
; 0000 0283                 {
; 0000 0284                         kursorSpeed = 1;
	LDI  R30,LOW(1)
	MOV  R4,R30
; 0000 0285                 } else kursorSpeed++;
	RJMP _0x9D
_0x9C:
	INC  R4
; 0000 0286         }
_0x9D:
; 0000 0287         if (!sw_down)
_0x9B:
	SBIC 0x10,6
	RJMP _0x9E
; 0000 0288         {
; 0000 0289                 if (kursorSpeed == 1)
	LDI  R30,LOW(1)
	CP   R30,R4
	BRNE _0x9F
; 0000 028A                 {
; 0000 028B                         kursorSpeed = 2;
	LDI  R30,LOW(2)
	MOV  R4,R30
; 0000 028C                 } else kursorSpeed--;
	RJMP _0xA0
_0x9F:
	DEC  R4
; 0000 028D         }
_0xA0:
; 0000 028E 
; 0000 028F         if (!sw_cancel)
_0x9E:
	SBIC 0x10,3
	RJMP _0xA1
; 0000 0290         {
; 0000 0291                 lcd_clear();
	CALL _lcd_clear
; 0000 0292                 goto menu02;
	RJMP _0x5E
; 0000 0293         }
; 0000 0294 
; 0000 0295         goto setSpeed;
_0xA1:
	RJMP _0x65
; 0000 0296 
; 0000 0297      setGaris: // not yet
_0x6D:
; 0000 0298         delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0299         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 029A                 // 0123456789ABCDEF
; 0000 029B         if ( WarnaGaris == 1 )
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0xA2
; 0000 029C                 lcd_putsf("  WARNA : Putih ");
	__POINTW1FN _0x0,308
	RJMP _0x3BE
; 0000 029D         else
_0xA2:
; 0000 029E                 lcd_putsf("  WARNA : Hitam ");
	__POINTW1FN _0x0,325
_0x3BE:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 029F 
; 0000 02A0         //lcd_putsf("  LEBAR: 1.5 cm ");
; 0000 02A1         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 02A2         lcd_putsf("  SensL :        ");
	__POINTW1FN _0x0,342
	CALL SUBOPT_0x5
; 0000 02A3         lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x15
; 0000 02A4         tampil( SensLine );
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _tampil
; 0000 02A5 
; 0000 02A6         switch (kursorGaris)
	MOV  R30,R7
	CALL SUBOPT_0x6
; 0000 02A7         {
; 0000 02A8           case 1:
	BRNE _0xA7
; 0000 02A9                 lcd_gotoxy(0,0); // kursor Warna
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x3BF
; 0000 02AA                 lcd_putchar(0);
; 0000 02AB                 break;
; 0000 02AC           case 2:
_0xA7:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xA6
; 0000 02AD                 lcd_gotoxy(0,1); // kursor SensL
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x3BF:
	ST   -Y,R30
	CALL _lcd_gotoxy
; 0000 02AE                 lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 02AF                 break;
; 0000 02B0         }
_0xA6:
; 0000 02B1 
; 0000 02B2         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0xA9
; 0000 02B3         {
; 0000 02B4                 setByte( 3, kursorGaris);
	LDI  R30,LOW(3)
	ST   -Y,R30
	ST   -Y,R7
	CALL SUBOPT_0x14
; 0000 02B5                 delay_ms(200);
; 0000 02B6         }
; 0000 02B7         if (!sw_up)
_0xA9:
	SBIC 0x10,4
	RJMP _0xAA
; 0000 02B8         {
; 0000 02B9                 if (kursorGaris == 2)
	LDI  R30,LOW(2)
	CP   R30,R7
	BRNE _0xAB
; 0000 02BA                 {
; 0000 02BB                         kursorGaris = 1;
	LDI  R30,LOW(1)
	MOV  R7,R30
; 0000 02BC                 } else kursorGaris++;
	RJMP _0xAC
_0xAB:
	INC  R7
; 0000 02BD         }
_0xAC:
; 0000 02BE         if (!sw_down)
_0xAA:
	SBIC 0x10,6
	RJMP _0xAD
; 0000 02BF         {
; 0000 02C0                 if (kursorGaris == 1)
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0xAE
; 0000 02C1                 {
; 0000 02C2                         kursorGaris = 2;
	LDI  R30,LOW(2)
	MOV  R7,R30
; 0000 02C3                 } else kursorGaris--;
	RJMP _0xAF
_0xAE:
	DEC  R7
; 0000 02C4         }
_0xAF:
; 0000 02C5 
; 0000 02C6         if (!sw_cancel)
_0xAD:
	SBIC 0x10,3
	RJMP _0xB0
; 0000 02C7         {
; 0000 02C8                 lcd_clear();
	CALL _lcd_clear
; 0000 02C9                 goto menu03;
	RJMP _0x68
; 0000 02CA         }
; 0000 02CB 
; 0000 02CC         goto setGaris;
_0xB0:
	RJMP _0x6D
; 0000 02CD 
; 0000 02CE      setSkenario:
_0x75:
; 0000 02CF         delay_ms(150);
	CALL SUBOPT_0x9
; 0000 02D0         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 02D1                 // 0123456789ABCDEF
; 0000 02D2         lcd_putsf("Sken. yg  dpake:");
	__POINTW1FN _0x0,360
	CALL SUBOPT_0x5
; 0000 02D3         lcd_gotoxy(0, 1);
	CALL SUBOPT_0xA
; 0000 02D4         tampil( Skenario );
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _tampil
; 0000 02D5 
; 0000 02D6         if (!sw_ok)
	SBIC 0x10,5
	RJMP _0xB1
; 0000 02D7         {
; 0000 02D8                 setByte( 4, 0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL SUBOPT_0x14
; 0000 02D9                 delay_ms(200);
; 0000 02DA         }
; 0000 02DB 
; 0000 02DC         if (!sw_cancel)
_0xB1:
	SBIC 0x10,3
	RJMP _0xB2
; 0000 02DD         {
; 0000 02DE                 lcd_clear();
	CALL _lcd_clear
; 0000 02DF                 goto menu04;
	RJMP _0x70
; 0000 02E0         }
; 0000 02E1 
; 0000 02E2         goto setSkenario;
_0xB2:
	RJMP _0x75
; 0000 02E3 
; 0000 02E4      mode:
_0x7D:
; 0000 02E5         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 02E6         if  (!sw_up)
	SBIC 0x10,4
	RJMP _0xB3
; 0000 02E7         {
; 0000 02E8             if (Mode==6)
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x6)
	BRNE _0xB4
; 0000 02E9             {
; 0000 02EA                 Mode=1;
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 02EB             }
; 0000 02EC 
; 0000 02ED             else Mode++;
	RJMP _0xB5
_0xB4:
	CALL SUBOPT_0x16
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 02EE 
; 0000 02EF             goto nomorMode;
_0xB5:
	RJMP _0xB6
; 0000 02F0         }
; 0000 02F1 
; 0000 02F2         if  (!sw_down)
_0xB3:
	SBIC 0x10,6
	RJMP _0xB7
; 0000 02F3         {
; 0000 02F4             if  (Mode==1)
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x1)
	BRNE _0xB8
; 0000 02F5             {
; 0000 02F6                 Mode=6;
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	LDI  R30,LOW(6)
	CALL __EEPROMWRB
; 0000 02F7             }
; 0000 02F8 
; 0000 02F9             else Mode--;
	RJMP _0xB9
_0xB8:
	CALL SUBOPT_0x16
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
; 0000 02FA 
; 0000 02FB             goto nomorMode;
_0xB9:
; 0000 02FC         }
; 0000 02FD 
; 0000 02FE         nomorMode:
_0xB7:
_0xB6:
; 0000 02FF             if (Mode==1)
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x1)
	BRNE _0xBA
; 0000 0300             {
; 0000 0301                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 0302                 lcd_gotoxy(0,0);
; 0000 0303                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 0304                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0305                 lcd_putsf(" 1.Lihat ADC");
	__POINTW1FN _0x0,394
	CALL SUBOPT_0x5
; 0000 0306             }
; 0000 0307 
; 0000 0308             if  (Mode==2)
_0xBA:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x2)
	BRNE _0xBB
; 0000 0309             {
; 0000 030A                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 030B                 lcd_gotoxy(0,0);
; 0000 030C                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 030D                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 030E                 lcd_putsf(" 2.Test Mode");
	__POINTW1FN _0x0,407
	CALL SUBOPT_0x5
; 0000 030F             }
; 0000 0310 
; 0000 0311             if  (Mode==3)
_0xBB:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x3)
	BRNE _0xBC
; 0000 0312             {
; 0000 0313                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 0314                 lcd_gotoxy(0,0);
; 0000 0315                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 0316                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0317                 lcd_putsf(" 3.Cek Sensor ");
	__POINTW1FN _0x0,420
	CALL SUBOPT_0x5
; 0000 0318             }
; 0000 0319 
; 0000 031A             if  (Mode==4)
_0xBC:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x4)
	BRNE _0xBD
; 0000 031B             {
; 0000 031C                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 031D                 lcd_gotoxy(0,0);
; 0000 031E                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 031F                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0320                 lcd_putsf(" 4.Auto Tune 1-1");
	__POINTW1FN _0x0,435
	CALL SUBOPT_0x5
; 0000 0321             }
; 0000 0322 
; 0000 0323              if  (Mode==5)
_0xBD:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x5)
	BRNE _0xBE
; 0000 0324             {
; 0000 0325                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 0326                 lcd_gotoxy(0,0);
; 0000 0327                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 0328                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0329                 lcd_putsf(" 5.Auto Tune ");
	__POINTW1FN _0x0,452
	CALL SUBOPT_0x5
; 0000 032A             }
; 0000 032B 
; 0000 032C             if  (Mode==6)
_0xBE:
	CALL SUBOPT_0x16
	CPI  R30,LOW(0x6)
	BRNE _0xBF
; 0000 032D             {
; 0000 032E                 lcd_clear();
	CALL SUBOPT_0x8
; 0000 032F                 lcd_gotoxy(0,0);
; 0000 0330                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x17
; 0000 0331                 lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0332                 lcd_putsf(" 6.Cek PWM Aktif");
	__POINTW1FN _0x0,466
	CALL SUBOPT_0x5
; 0000 0333             }
; 0000 0334 
; 0000 0335         if  (!sw_ok)
_0xBF:
	SBIC 0x10,5
	RJMP _0xC0
; 0000 0336         {
; 0000 0337             switch  (Mode)
	CALL SUBOPT_0x16
	CALL SUBOPT_0x6
; 0000 0338             {
; 0000 0339                 case 1:
	BRNE _0xC4
; 0000 033A                 {
; 0000 033B                     for(;;)
_0xC6:
; 0000 033C                     {
; 0000 033D                         lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x18
; 0000 033E                         sprintf(lcd," %d %d %d %d",read_adc(3),read_adc(2),read_adc(1),read_adc(0));
	CALL SUBOPT_0x19
	__POINTW1FN _0x0,483
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1F
; 0000 033F                         lcd_puts(lcd);
	CALL _lcd_puts
; 0000 0340                         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 0341                         sprintf(lcd,"%d %d %d %d",read_adc(7),read_adc(6),read_adc(5),read_adc(4));
	CALL SUBOPT_0x19
	__POINTW1FN _0x0,484
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x20
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x21
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x22
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x23
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x1F
; 0000 0342                         lcd_puts(lcd);
	CALL _lcd_puts
; 0000 0343                         delay_ms(100);
	CALL SUBOPT_0xB
; 0000 0344                         lcd_clear();
; 0000 0345                     }
	RJMP _0xC6
; 0000 0346                 }
; 0000 0347                 break;
; 0000 0348 
; 0000 0349                 case 2:
_0xC4:
	CPI  R30,LOW(0x2)
	LDI  R26,HIGH(0x2)
	CPC  R31,R26
	BRNE _0xC8
; 0000 034A                 {
; 0000 034B                     cek_sensor();
	RCALL _cek_sensor
; 0000 034C                 }
; 0000 034D                 break;
	RJMP _0xC3
; 0000 034E 
; 0000 034F                 case 3:
_0xC8:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0xC9
; 0000 0350                 {
; 0000 0351                     cek_sensor();
	RCALL _cek_sensor
; 0000 0352                 }
; 0000 0353                 break;
	RJMP _0xC3
; 0000 0354 
; 0000 0355                 case 4:
_0xC9:
	CPI  R30,LOW(0x4)
	LDI  R26,HIGH(0x4)
	CPC  R31,R26
	BRNE _0xCA
; 0000 0356                 {
; 0000 0357                     tune_batas();
	RCALL _tune_batas
; 0000 0358 
; 0000 0359                 }
; 0000 035A                 break;
	RJMP _0xC3
; 0000 035B 
; 0000 035C                 case 5:
_0xCA:
	CPI  R30,LOW(0x5)
	LDI  R26,HIGH(0x5)
	CPC  R31,R26
	BRNE _0xCB
; 0000 035D                 {
; 0000 035E                     auto_scan();
	RCALL _auto_scan
; 0000 035F                     goto menu01;
	RJMP _0x5A
; 0000 0360                 }
; 0000 0361                 break;
; 0000 0362 
; 0000 0363                 case 6:
_0xCB:
	CPI  R30,LOW(0x6)
	LDI  R26,HIGH(0x6)
	CPC  R31,R26
	BRNE _0xC3
; 0000 0364                 {
; 0000 0365                     pemercepat();
	RCALL _pemercepat
; 0000 0366                     pelambat();
	RCALL _pelambat
; 0000 0367                     goto menu01;
	RJMP _0x5A
; 0000 0368                 }
; 0000 0369                 break;
; 0000 036A             }
_0xC3:
; 0000 036B         }
; 0000 036C 
; 0000 036D         if  (!sw_cancel)
_0xC0:
	SBIC 0x10,3
	RJMP _0xCD
; 0000 036E         {
; 0000 036F             lcd_clear();
	CALL _lcd_clear
; 0000 0370             goto menu05;
	RJMP _0x78
; 0000 0371         }
; 0000 0372 
; 0000 0373         goto mode;
_0xCD:
	RJMP _0x7D
; 0000 0374 
; 0000 0375      startRobot:
_0x84:
; 0000 0376         lcd_clear();
	CALL _lcd_clear
; 0000 0377 }
	RET
;
;void baca_sensor(void)
; 0000 037A {
_baca_sensor:
; 0000 037B     sensor=0;
	CLR  R6
; 0000 037C     adc0=read_adc(7);
	CALL SUBOPT_0x20
	MOV  R9,R30
; 0000 037D     adc1=read_adc(6);
	CALL SUBOPT_0x21
	MOV  R8,R30
; 0000 037E     adc2=read_adc(5);
	CALL SUBOPT_0x22
	MOV  R11,R30
; 0000 037F     adc3=read_adc(4);
	CALL SUBOPT_0x23
	MOV  R10,R30
; 0000 0380     adc4=read_adc(3);
	CALL SUBOPT_0x1A
	MOV  R13,R30
; 0000 0381     adc5=read_adc(2);
	CALL SUBOPT_0x1C
	MOV  R12,R30
; 0000 0382     adc6=read_adc(1);
	CALL SUBOPT_0x1D
	STS  _adc6,R30
; 0000 0383     adc7=read_adc(0);
	CALL SUBOPT_0x1E
	STS  _adc7,R30
; 0000 0384 
; 0000 0385     if(adc0>bt0){s0=1;sensor=sensor|1<<0;}      // deteksi hitam
	CALL SUBOPT_0x24
	CP   R30,R9
	BRSH _0xCE
	SET
	BLD  R2,0
	LDI  R30,LOW(1)
	RJMP _0x3C0
; 0000 0386     else {s0=0;sensor=sensor|0<<0;}             // deteksi putih
_0xCE:
	CLT
	BLD  R2,0
	LDI  R30,LOW(0)
_0x3C0:
	OR   R6,R30
; 0000 0387 
; 0000 0388     if(adc1>bt1){s1=1;sensor=sensor|1<<1;}
	CALL SUBOPT_0x25
	CP   R30,R8
	BRSH _0xD0
	SET
	BLD  R2,1
	LDI  R30,LOW(2)
	RJMP _0x3C1
; 0000 0389     else {s1=0;sensor=sensor|0<<1;}
_0xD0:
	CLT
	BLD  R2,1
	LDI  R30,LOW(0)
_0x3C1:
	OR   R6,R30
; 0000 038A 
; 0000 038B     if(adc2>bt2){s2=1;sensor=sensor|1<<2;}
	CALL SUBOPT_0x26
	CP   R30,R11
	BRSH _0xD2
	SET
	BLD  R2,2
	LDI  R30,LOW(4)
	RJMP _0x3C2
; 0000 038C     else {s2=0;sensor=sensor|0<<2;}
_0xD2:
	CLT
	BLD  R2,2
	LDI  R30,LOW(0)
_0x3C2:
	OR   R6,R30
; 0000 038D 
; 0000 038E     if(adc3>bt3){s3=1;sensor=sensor|1<<3;}
	CALL SUBOPT_0x27
	CP   R30,R10
	BRSH _0xD4
	SET
	BLD  R2,3
	LDI  R30,LOW(8)
	RJMP _0x3C3
; 0000 038F     else {s3=0;sensor=sensor|0<<3;}
_0xD4:
	CLT
	BLD  R2,3
	LDI  R30,LOW(0)
_0x3C3:
	OR   R6,R30
; 0000 0390 
; 0000 0391     if(adc4>bt4){s4=1;sensor=sensor|1<<4;}
	CALL SUBOPT_0x28
	CP   R30,R13
	BRSH _0xD6
	SET
	BLD  R2,4
	LDI  R30,LOW(16)
	RJMP _0x3C4
; 0000 0392     else {s4=0;sensor=sensor|0<<4;}
_0xD6:
	CLT
	BLD  R2,4
	LDI  R30,LOW(0)
_0x3C4:
	OR   R6,R30
; 0000 0393 
; 0000 0394     if(adc5>bt5){s5=1;sensor=sensor|1<<5;}
	CALL SUBOPT_0x29
	CP   R30,R12
	BRSH _0xD8
	SET
	BLD  R2,5
	LDI  R30,LOW(32)
	RJMP _0x3C5
; 0000 0395     else {s5=0;sensor=sensor|0<<5;}
_0xD8:
	CLT
	BLD  R2,5
	LDI  R30,LOW(0)
_0x3C5:
	OR   R6,R30
; 0000 0396 
; 0000 0397     if(adc6>bt6){s6=1;sensor=sensor|1<<6;}
	CALL SUBOPT_0x2A
	LDS  R26,_adc6
	CP   R30,R26
	BRSH _0xDA
	SET
	BLD  R2,6
	LDI  R30,LOW(64)
	RJMP _0x3C6
; 0000 0398     else {s6=0;sensor=sensor|0<<6;}
_0xDA:
	CLT
	BLD  R2,6
	LDI  R30,LOW(0)
_0x3C6:
	OR   R6,R30
; 0000 0399 
; 0000 039A     if(adc7>bt7){s7=1;sensor=sensor|1<<7;}
	CALL SUBOPT_0x2B
	LDS  R26,_adc7
	CP   R30,R26
	BRSH _0xDC
	SET
	BLD  R2,7
	LDI  R30,LOW(128)
	RJMP _0x3C7
; 0000 039B     else {s7=0;sensor=sensor|0<<7;}
_0xDC:
	CLT
	BLD  R2,7
	LDI  R30,LOW(0)
_0x3C7:
	OR   R6,R30
; 0000 039C 
; 0000 039D     // hitam dari 1 dibuat 0
; 0000 039E     // putih dari 0 dibuat 1
; 0000 039F     s0 = ~s0;
	LDI  R30,LOW(1)
	EOR  R2,R30
; 0000 03A0     s1 = ~s1;
	LDI  R30,LOW(2)
	EOR  R2,R30
; 0000 03A1     s2 = ~s2;
	LDI  R30,LOW(4)
	EOR  R2,R30
; 0000 03A2     s3 = ~s3;
	LDI  R30,LOW(8)
	EOR  R2,R30
; 0000 03A3     s4 = ~s4;
	LDI  R30,LOW(16)
	EOR  R2,R30
; 0000 03A4     s5 = ~s5;
	LDI  R30,LOW(32)
	EOR  R2,R30
; 0000 03A5     s6 = ~s6;
	LDI  R30,LOW(64)
	EOR  R2,R30
; 0000 03A6     s7 = ~s7;
	LDI  R30,LOW(128)
	EOR  R2,R30
; 0000 03A7 
; 0000 03A8     sensor = ~sensor;
	COM  R6
; 0000 03A9 
; 0000 03AA     if(PINC.0)  sKa = 0;
	SBIS 0x13,0
	RJMP _0xDE
	CLT
	RJMP _0x3C8
; 0000 03AB     else        sKa = 1;
_0xDE:
	SET
_0x3C8:
	BLD  R3,0
; 0000 03AC 
; 0000 03AD     if(PINC.1)  sKi = 0;
	SBIS 0x13,1
	RJMP _0xE0
	CLT
	RJMP _0x3C9
; 0000 03AE     else        sKi = 1;
_0xE0:
	SET
_0x3C9:
	BLD  R3,1
; 0000 03AF }
	RET
;
;void displaySensorBit(void)
; 0000 03B2 {
_displaySensorBit:
; 0000 03B3     baca_sensor();
	RCALL _baca_sensor
; 0000 03B4 
; 0000 03B5     lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x15
; 0000 03B6     if (s7) lcd_putchar('1');
	SBRS R2,7
	RJMP _0xE2
	LDI  R30,LOW(49)
	RJMP _0x3CA
; 0000 03B7     else    lcd_putchar('0');
_0xE2:
	LDI  R30,LOW(48)
_0x3CA:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03B8     if (s6) lcd_putchar('1');
	SBRS R2,6
	RJMP _0xE4
	LDI  R30,LOW(49)
	RJMP _0x3CB
; 0000 03B9     else    lcd_putchar('0');
_0xE4:
	LDI  R30,LOW(48)
_0x3CB:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03BA     if (s5) lcd_putchar('1');
	SBRS R2,5
	RJMP _0xE6
	LDI  R30,LOW(49)
	RJMP _0x3CC
; 0000 03BB     else    lcd_putchar('0');
_0xE6:
	LDI  R30,LOW(48)
_0x3CC:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03BC     if (s4) lcd_putchar('1');
	SBRS R2,4
	RJMP _0xE8
	LDI  R30,LOW(49)
	RJMP _0x3CD
; 0000 03BD     else    lcd_putchar('0');
_0xE8:
	LDI  R30,LOW(48)
_0x3CD:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03BE     if (s3) lcd_putchar('1');
	SBRS R2,3
	RJMP _0xEA
	LDI  R30,LOW(49)
	RJMP _0x3CE
; 0000 03BF     else    lcd_putchar('0');
_0xEA:
	LDI  R30,LOW(48)
_0x3CE:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03C0     if (s2) lcd_putchar('1');
	SBRS R2,2
	RJMP _0xEC
	LDI  R30,LOW(49)
	RJMP _0x3CF
; 0000 03C1     else    lcd_putchar('0');
_0xEC:
	LDI  R30,LOW(48)
_0x3CF:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03C2     if (s1) lcd_putchar('1');
	SBRS R2,1
	RJMP _0xEE
	LDI  R30,LOW(49)
	RJMP _0x3D0
; 0000 03C3     else    lcd_putchar('0');
_0xEE:
	LDI  R30,LOW(48)
_0x3D0:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03C4     if (s0) lcd_putchar('1');
	SBRS R2,0
	RJMP _0xF0
	LDI  R30,LOW(49)
	RJMP _0x3D1
; 0000 03C5     else    lcd_putchar('0');
_0xF0:
	LDI  R30,LOW(48)
_0x3D1:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 03C6 }
	RET
;
;void maju(void)
; 0000 03C9 {
_maju:
; 0000 03CA         kaplus=1;kirplus=1;
	SBI  0x15,7
	SBI  0x15,3
; 0000 03CB         kamin=0;kirmin=0;
	CBI  0x15,6
	RJMP _0x208000C
; 0000 03CC }
;
;void mundur(void)
; 0000 03CF {
_mundur:
; 0000 03D0         kaplus=0;kirplus=0;
	CBI  0x15,7
	CBI  0x15,3
; 0000 03D1         kamin=1;kirmin=1;
	SBI  0x15,6
	RJMP _0x208000B
; 0000 03D2 }
;
;void bkir(void)
; 0000 03D5 {
_bkir:
; 0000 03D6         kirplus=0;
	RJMP _0x208000A
; 0000 03D7         kirmin=1;
; 0000 03D8 }
;
;void bkan(void)
; 0000 03DB {
_bkan:
; 0000 03DC         kaplus=0;
	CBI  0x15,7
; 0000 03DD         kamin=1;
	SBI  0x15,6
; 0000 03DE }
	RET
;
;void stop(char s)
; 0000 03E1 {
_stop:
; 0000 03E2         char i;
; 0000 03E3         for(i=0;i<s;i++)
	ST   -Y,R17
;	s -> Y+1
;	i -> R17
	LDI  R17,LOW(0)
_0x10B:
	LDD  R30,Y+1
	CP   R17,R30
	BRSH _0x10C
; 0000 03E4         {
; 0000 03E5                 rpwm=255;lpwm=255;
	CALL SUBOPT_0x2C
	CALL SUBOPT_0x2D
; 0000 03E6                 Enki = 1;
	SBI  0x15,2
; 0000 03E7                 Enka = 1;
	SBI  0x15,5
; 0000 03E8                 kaplus=1;kirplus=1;
	SBI  0x15,7
	SBI  0x15,3
; 0000 03E9                 kamin=1;kirmin=1;
	SBI  0x15,6
	SBI  0x15,4
; 0000 03EA                 delay_ms(10);
	CALL SUBOPT_0x2E
; 0000 03EB         }
	SUBI R17,-1
	RJMP _0x10B
_0x10C:
; 0000 03EC 
; 0000 03ED         rpwm=0;lpwm=0;
	CALL SUBOPT_0x2F
	CALL SUBOPT_0x30
; 0000 03EE }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void rotkan(void)
; 0000 03F1 {
_rotkan:
; 0000 03F2         kaplus=0;kamin=1;
	CBI  0x15,7
	SBI  0x15,6
; 0000 03F3         kirplus=1;kirmin=0;
	SBI  0x15,3
_0x208000C:
	CBI  0x15,4
; 0000 03F4 }
	RET
;
;void rotkir(void)
; 0000 03F7 {
_rotkir:
; 0000 03F8         kaplus=1;kamin=0;
	SBI  0x15,7
	CBI  0x15,6
; 0000 03F9         kirplus=0;kirmin=1;
_0x208000A:
	CBI  0x15,3
_0x208000B:
	SBI  0x15,4
; 0000 03FA }
	RET
;
;void pemercepat(void)
; 0000 03FD {
_pemercepat:
; 0000 03FE         int b;
; 0000 03FF 
; 0000 0400         lpwm=0;
	ST   -Y,R17
	ST   -Y,R16
;	b -> R16,R17
	CALL SUBOPT_0x30
; 0000 0401         rpwm=0;
	CALL SUBOPT_0x2F
; 0000 0402 
; 0000 0403         maju();
	RCALL _maju
; 0000 0404 
; 0000 0405         for(b=0;b<255;b++)
	__GETWRN 16,17,0
_0x12A:
	__CPWRN 16,17,255
	BRGE _0x12B
; 0000 0406         {
; 0000 0407             delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0408 
; 0000 0409             lpwm++;
	LDI  R26,LOW(_lpwm)
	LDI  R27,HIGH(_lpwm)
	CALL SUBOPT_0x31
; 0000 040A             rpwm++;
	LDI  R26,LOW(_rpwm)
	LDI  R27,HIGH(_rpwm)
	CALL SUBOPT_0x31
; 0000 040B 
; 0000 040C             lcd_clear();
	CALL SUBOPT_0x8
; 0000 040D 
; 0000 040E             lcd_gotoxy(0,0);
; 0000 040F             sprintf(lcd," %d %d",lpwm,rpwm);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x32
; 0000 0410             lcd_puts(lcd);
	CALL _lcd_puts
; 0000 0411         }
	__ADDWRN 16,17,1
	RJMP _0x12A
_0x12B:
; 0000 0412         lpwm=0;
	CALL SUBOPT_0x30
; 0000 0413         rpwm=0;
	CALL SUBOPT_0x2F
; 0000 0414 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void pelambat(void)
; 0000 0417 {
_pelambat:
; 0000 0418         int b;
; 0000 0419 
; 0000 041A         lpwm=255;
	ST   -Y,R17
	ST   -Y,R16
;	b -> R16,R17
	CALL SUBOPT_0x2D
; 0000 041B         rpwm=255;
	CALL SUBOPT_0x2C
; 0000 041C 
; 0000 041D         mundur();
	RCALL _mundur
; 0000 041E 
; 0000 041F         for(b=0;b<255;b++)
	__GETWRN 16,17,0
_0x12D:
	__CPWRN 16,17,255
	BRGE _0x12E
; 0000 0420         {
; 0000 0421             delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0422 
; 0000 0423             lpwm--;
	LDI  R26,LOW(_lpwm)
	LDI  R27,HIGH(_lpwm)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0424             rpwm--;
	LDI  R26,LOW(_rpwm)
	LDI  R27,HIGH(_rpwm)
	LD   R30,X+
	LD   R31,X+
	SBIW R30,1
	ST   -X,R31
	ST   -X,R30
; 0000 0425 
; 0000 0426             lcd_clear();
	CALL SUBOPT_0x8
; 0000 0427 
; 0000 0428             lcd_gotoxy(0,0);
; 0000 0429             sprintf(lcd," %d %d",lpwm,rpwm);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x32
; 0000 042A             lcd_puts(lcd);
	CALL _lcd_puts
; 0000 042B         }
	__ADDWRN 16,17,1
	RJMP _0x12D
_0x12E:
; 0000 042C         lpwm=0;
	CALL SUBOPT_0x30
; 0000 042D         rpwm=0;
	CALL SUBOPT_0x2F
; 0000 042E }
	RJMP _0x2080009
;
;void cek_sensor(void)
; 0000 0431 {
_cek_sensor:
; 0000 0432         int t;
; 0000 0433 
; 0000 0434         baca_sensor();
	ST   -Y,R17
	ST   -Y,R16
;	t -> R16,R17
	RCALL _baca_sensor
; 0000 0435         lcd_clear();
	CALL _lcd_clear
; 0000 0436         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0437                 // wait 125ms
; 0000 0438         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0439                 //0123456789abcdef
; 0000 043A         lcd_putsf(" Test:Sensor    ");
	__POINTW1FN _0x0,496
	CALL SUBOPT_0x5
; 0000 043B 
; 0000 043C         for (t=0; t<30000; t++) {displaySensorBit();}
	__GETWRN 16,17,0
_0x130:
	__CPWRN 16,17,30000
	BRGE _0x131
	RCALL _displaySensorBit
	__ADDWRN 16,17,1
	RJMP _0x130
_0x131:
; 0000 043D }
	RJMP _0x2080009
;
;void tune_batas(void)
; 0000 0440 {
_tune_batas:
; 0000 0441         int k;
; 0000 0442 
; 0000 0443         ba7=7;
	CALL SUBOPT_0x33
;	k -> R16,R17
; 0000 0444         ba6=7;
; 0000 0445         ba5=7;
; 0000 0446         ba4=7;
; 0000 0447         ba3=7;
; 0000 0448         ba2=7;
; 0000 0449         ba1=7;
; 0000 044A         ba0=7;
; 0000 044B         bb7=200;
; 0000 044C         bb6=200;
; 0000 044D         bb5=200;
; 0000 044E         bb4=200;
; 0000 044F         bb3=200;
; 0000 0450         bb2=200;
; 0000 0451         bb1=200;
; 0000 0452         bb0=200;
; 0000 0453 
; 0000 0454         lcd_clear();
	CALL _lcd_clear
; 0000 0455 
; 0000 0456     for(;;)
_0x133:
; 0000 0457     {
; 0000 0458         k = 0;
	__GETWRN 16,17,0
; 0000 0459 
; 0000 045A         k = read_adc(0);
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x34
; 0000 045B         if  (k<bb0)   {bb0=k;}
	BRGE _0x135
	MOV  R30,R16
	LDI  R26,LOW(_bb0)
	LDI  R27,HIGH(_bb0)
	CALL __EEPROMWRB
; 0000 045C         if  (k>ba0)   {ba0=k;}
_0x135:
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x136
	MOV  R30,R16
	LDI  R26,LOW(_ba0)
	LDI  R27,HIGH(_ba0)
	CALL __EEPROMWRB
; 0000 045D 
; 0000 045E         bt0=((bb0+ba0)/2);
_0x136:
	CALL SUBOPT_0x37
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x35
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL SUBOPT_0x39
; 0000 045F 
; 0000 0460         lcd_clear();
; 0000 0461         lcd_gotoxy(1,0);
; 0000 0462         lcd_putsf(" bb0  ba0  bt0");
	__POINTW1FN _0x0,513
	CALL SUBOPT_0x5
; 0000 0463         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 0464         sprintf(lcd," %d  %d  %d",bb0,ba0,bt0);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x37
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x35
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3B
; 0000 0465         lcd_puts(lcd);
	CALL SUBOPT_0x3C
; 0000 0466         delay_ms(50);
; 0000 0467 
; 0000 0468         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x137
; 0000 0469         {
; 0000 046A             delay_ms(125);
	CALL SUBOPT_0xC
; 0000 046B             goto sensor1;
	RJMP _0x138
; 0000 046C         }
; 0000 046D     }
_0x137:
	RJMP _0x133
; 0000 046E     sensor1:
_0x138:
; 0000 046F     for(;;)
_0x13A:
; 0000 0470     {
; 0000 0471         k = read_adc(1);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x3D
; 0000 0472         if  (k<bb1)   {bb1=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x13C
	MOV  R30,R16
	LDI  R26,LOW(_bb1)
	LDI  R27,HIGH(_bb1)
	CALL __EEPROMWRB
; 0000 0473         if  (k>ba1)   {ba1=k;}
_0x13C:
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x13D
	MOV  R30,R16
	LDI  R26,LOW(_ba1)
	LDI  R27,HIGH(_ba1)
	CALL __EEPROMWRB
; 0000 0474 
; 0000 0475         bt1=((bb1+ba1)/2);
_0x13D:
	CALL SUBOPT_0x3F
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL SUBOPT_0x39
; 0000 0476 
; 0000 0477         lcd_clear();
; 0000 0478         lcd_gotoxy(1,0);
; 0000 0479         lcd_putsf(" bb1  ba1  bt1");
	__POINTW1FN _0x0,540
	CALL SUBOPT_0x5
; 0000 047A         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 047B         sprintf(lcd," %d  %d  %d",bb1,ba1,bt1);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3F
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x25
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3B
; 0000 047C         lcd_puts(lcd);
	CALL SUBOPT_0x3C
; 0000 047D         delay_ms(50);
; 0000 047E 
; 0000 047F         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x13E
; 0000 0480         {
; 0000 0481             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0482             goto sensor2;
	RJMP _0x13F
; 0000 0483         }
; 0000 0484     }
_0x13E:
	RJMP _0x13A
; 0000 0485     sensor2:
_0x13F:
; 0000 0486     for(;;)
_0x141:
; 0000 0487     {
; 0000 0488         k = read_adc(2);
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x40
; 0000 0489         if  (k<bb2)   {bb2=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x143
	MOV  R30,R16
	LDI  R26,LOW(_bb2)
	LDI  R27,HIGH(_bb2)
	CALL __EEPROMWRB
; 0000 048A         if  (k>ba2)   {ba2=k;}
_0x143:
	CALL SUBOPT_0x41
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x144
	MOV  R30,R16
	LDI  R26,LOW(_ba2)
	LDI  R27,HIGH(_ba2)
	CALL __EEPROMWRB
; 0000 048B 
; 0000 048C         bt2=((bb2+ba2)/2);
_0x144:
	CALL SUBOPT_0x42
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x41
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt2)
	LDI  R27,HIGH(_bt2)
	CALL SUBOPT_0x39
; 0000 048D 
; 0000 048E         lcd_clear();
; 0000 048F         lcd_gotoxy(1,0);
; 0000 0490         lcd_putsf(" bb2  ba2  bt2");
	__POINTW1FN _0x0,555
	CALL SUBOPT_0x5
; 0000 0491         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 0492         sprintf(lcd," %d  %d  %d",bb2,ba2,bt2);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x42
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x41
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3B
; 0000 0493         lcd_puts(lcd);
	CALL SUBOPT_0x43
; 0000 0494         delay_ms(10);
; 0000 0495 
; 0000 0496         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x145
; 0000 0497         {
; 0000 0498             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0499             goto sensor3;
	RJMP _0x146
; 0000 049A         }
; 0000 049B     }
_0x145:
	RJMP _0x141
; 0000 049C     sensor3:
_0x146:
; 0000 049D     for(;;)
_0x148:
; 0000 049E     {
; 0000 049F         k = read_adc(3);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x44
; 0000 04A0         if  (k<bb3)   {bb3=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x14A
	MOV  R30,R16
	LDI  R26,LOW(_bb3)
	LDI  R27,HIGH(_bb3)
	CALL __EEPROMWRB
; 0000 04A1         if  (k>ba3)   {ba3=k;}
_0x14A:
	CALL SUBOPT_0x45
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x14B
	MOV  R30,R16
	LDI  R26,LOW(_ba3)
	LDI  R27,HIGH(_ba3)
	CALL __EEPROMWRB
; 0000 04A2 
; 0000 04A3         bt3=((bb3+ba3)/2);
_0x14B:
	CALL SUBOPT_0x46
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x45
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt3)
	LDI  R27,HIGH(_bt3)
	CALL SUBOPT_0x39
; 0000 04A4 
; 0000 04A5         lcd_clear();
; 0000 04A6         lcd_gotoxy(1,0);
; 0000 04A7         lcd_putsf(" bb3  ba3  bt3");
	__POINTW1FN _0x0,570
	CALL SUBOPT_0x5
; 0000 04A8         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 04A9         sprintf(lcd," %d  %d  %d",bb3,ba3,bt3);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x46
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x45
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3B
; 0000 04AA         lcd_puts(lcd);
	CALL SUBOPT_0x43
; 0000 04AB         delay_ms(10);
; 0000 04AC 
; 0000 04AD         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x14C
; 0000 04AE         {
; 0000 04AF             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 04B0             goto sensor4;
	RJMP _0x14D
; 0000 04B1         }
; 0000 04B2     }
_0x14C:
	RJMP _0x148
; 0000 04B3     sensor4:
_0x14D:
; 0000 04B4     for(;;)
_0x14F:
; 0000 04B5     {
; 0000 04B6         k = read_adc(4);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x47
; 0000 04B7         if  (k<bb4)   {bb4=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x151
	MOV  R30,R16
	LDI  R26,LOW(_bb4)
	LDI  R27,HIGH(_bb4)
	CALL __EEPROMWRB
; 0000 04B8         if  (k>ba4)   {ba4=k;}
_0x151:
	CALL SUBOPT_0x48
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x152
	MOV  R30,R16
	LDI  R26,LOW(_ba4)
	LDI  R27,HIGH(_ba4)
	CALL __EEPROMWRB
; 0000 04B9 
; 0000 04BA         bt4=((bb4+ba4)/2);
_0x152:
	CALL SUBOPT_0x49
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x48
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt4)
	LDI  R27,HIGH(_bt4)
	CALL SUBOPT_0x39
; 0000 04BB 
; 0000 04BC         lcd_clear();
; 0000 04BD         lcd_gotoxy(1,0);
; 0000 04BE         lcd_putsf(" bb4  ba4  bt4");
	__POINTW1FN _0x0,585
	CALL SUBOPT_0x5
; 0000 04BF         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 04C0         sprintf(lcd," %d  %d  %d",bb4,ba4,bt4);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x49
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x48
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3B
; 0000 04C1         lcd_puts(lcd);
	CALL SUBOPT_0x43
; 0000 04C2         delay_ms(10);
; 0000 04C3 
; 0000 04C4         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x153
; 0000 04C5         {
; 0000 04C6             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 04C7             goto sensor5;
	RJMP _0x154
; 0000 04C8         }
; 0000 04C9     }
_0x153:
	RJMP _0x14F
; 0000 04CA     sensor5:
_0x154:
; 0000 04CB     for(;;)
_0x156:
; 0000 04CC     {
; 0000 04CD         k = read_adc(5);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x4A
; 0000 04CE         if  (k<bb5)   {bb5=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x158
	MOV  R30,R16
	LDI  R26,LOW(_bb5)
	LDI  R27,HIGH(_bb5)
	CALL __EEPROMWRB
; 0000 04CF         if  (k>ba5)   {ba5=k;}
_0x158:
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x159
	MOV  R30,R16
	LDI  R26,LOW(_ba5)
	LDI  R27,HIGH(_ba5)
	CALL __EEPROMWRB
; 0000 04D0 
; 0000 04D1         bt5=((bb5+ba5)/2);
_0x159:
	CALL SUBOPT_0x4C
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt5)
	LDI  R27,HIGH(_bt5)
	CALL SUBOPT_0x39
; 0000 04D2 
; 0000 04D3         lcd_clear();
; 0000 04D4         lcd_gotoxy(1,0);
; 0000 04D5         lcd_putsf(" bb5  ba5  bt5");
	__POINTW1FN _0x0,600
	CALL SUBOPT_0x5
; 0000 04D6         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 04D7         sprintf(lcd," %d  %d  %d",bb5,ba5,bt5);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x29
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3B
; 0000 04D8         lcd_puts(lcd);
	CALL SUBOPT_0x43
; 0000 04D9         delay_ms(10);
; 0000 04DA 
; 0000 04DB         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x15A
; 0000 04DC         {
; 0000 04DD             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 04DE             goto sensor6;
	RJMP _0x15B
; 0000 04DF         }
; 0000 04E0     }
_0x15A:
	RJMP _0x156
; 0000 04E1     sensor6:
_0x15B:
; 0000 04E2     for(;;)
_0x15D:
; 0000 04E3     {
; 0000 04E4         k = read_adc(06);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x4D
; 0000 04E5         if  (k<bb6)   {bb6=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x15F
	MOV  R30,R16
	LDI  R26,LOW(_bb6)
	LDI  R27,HIGH(_bb6)
	CALL __EEPROMWRB
; 0000 04E6         if  (k>ba6)   {ba6=k;}
_0x15F:
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x160
	MOV  R30,R16
	LDI  R26,LOW(_ba6)
	LDI  R27,HIGH(_ba6)
	CALL __EEPROMWRB
; 0000 04E7 
; 0000 04E8         bt6=((bb6+ba6)/2);
_0x160:
	CALL SUBOPT_0x4F
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt6)
	LDI  R27,HIGH(_bt6)
	CALL SUBOPT_0x39
; 0000 04E9 
; 0000 04EA         lcd_clear();
; 0000 04EB         lcd_gotoxy(1,0);
; 0000 04EC         lcd_putsf(" bb6  ba6  bt6");
	__POINTW1FN _0x0,615
	CALL SUBOPT_0x5
; 0000 04ED         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 04EE         sprintf(lcd," %d  %d  %d",bb6,ba6,bt6);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x4F
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3B
; 0000 04EF         lcd_puts(lcd);
	CALL SUBOPT_0x43
; 0000 04F0         delay_ms(10);
; 0000 04F1 
; 0000 04F2         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x161
; 0000 04F3         {
; 0000 04F4             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 04F5             goto sensor7;
	RJMP _0x162
; 0000 04F6         }
; 0000 04F7     }
_0x161:
	RJMP _0x15D
; 0000 04F8     sensor7:
_0x162:
; 0000 04F9     for(;;)
_0x164:
; 0000 04FA     {
; 0000 04FB         k = read_adc(7);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x50
; 0000 04FC         if  (k<bb7)   {bb7=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x166
	MOV  R30,R16
	LDI  R26,LOW(_bb7)
	LDI  R27,HIGH(_bb7)
	CALL __EEPROMWRB
; 0000 04FD         if  (k>ba7)   {ba7=k;}
_0x166:
	CALL SUBOPT_0x51
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x167
	MOV  R30,R16
	LDI  R26,LOW(_ba7)
	LDI  R27,HIGH(_ba7)
	CALL __EEPROMWRB
; 0000 04FE 
; 0000 04FF         bt7=((bb7+ba7)/2);
_0x167:
	CALL SUBOPT_0x52
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x51
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt7)
	LDI  R27,HIGH(_bt7)
	CALL SUBOPT_0x39
; 0000 0500 
; 0000 0501         lcd_clear();
; 0000 0502         lcd_gotoxy(1,0);
; 0000 0503         lcd_putsf(" bb7  ba7  bt7");
	__POINTW1FN _0x0,630
	CALL SUBOPT_0x5
; 0000 0504         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x15
; 0000 0505         sprintf(lcd," %d  %d  %d",bb7,ba7,bt7);
	CALL SUBOPT_0x19
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x52
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x51
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x3B
; 0000 0506         lcd_puts(lcd);
	CALL SUBOPT_0x43
; 0000 0507         delay_ms(10);
; 0000 0508 
; 0000 0509         if(!sw_ok)
	SBIC 0x10,5
	RJMP _0x168
; 0000 050A         {
; 0000 050B             delay_ms(150);
	CALL SUBOPT_0x9
; 0000 050C             goto selesai;
	RJMP _0x169
; 0000 050D         }
; 0000 050E     }
_0x168:
	RJMP _0x164
; 0000 050F     selesai:
_0x169:
; 0000 0510     lcd_clear();
	RJMP _0x2080008
; 0000 0511 }
;
;void auto_scan(void)
; 0000 0514 {
_auto_scan:
; 0000 0515         int k;
; 0000 0516 
; 0000 0517         ba7=7;
	CALL SUBOPT_0x33
;	k -> R16,R17
; 0000 0518         ba6=7;
; 0000 0519         ba5=7;
; 0000 051A         ba4=7;
; 0000 051B         ba3=7;
; 0000 051C         ba2=7;
; 0000 051D         ba1=7;
; 0000 051E         ba0=7;
; 0000 051F         bb7=200;
; 0000 0520         bb6=200;
; 0000 0521         bb5=200;
; 0000 0522         bb4=200;
; 0000 0523         bb3=200;
; 0000 0524         bb2=200;
; 0000 0525         bb1=200;
; 0000 0526         bb0=200;
; 0000 0527 
; 0000 0528         for(;;)
_0x16B:
; 0000 0529         {
; 0000 052A                 k = 0;
	__GETWRN 16,17,0
; 0000 052B 
; 0000 052C                 k = read_adc(0);
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x34
; 0000 052D                 if  (k<bb0)   {bb0=k;}
	BRGE _0x16D
	MOV  R30,R16
	LDI  R26,LOW(_bb0)
	LDI  R27,HIGH(_bb0)
	CALL __EEPROMWRB
; 0000 052E                 if  (k>ba0)   {ba0=k;}
_0x16D:
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x16E
	MOV  R30,R16
	LDI  R26,LOW(_ba0)
	LDI  R27,HIGH(_ba0)
	CALL __EEPROMWRB
; 0000 052F 
; 0000 0530                 bt0=((bb0+ba0)/2);
_0x16E:
	CALL SUBOPT_0x37
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x35
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL __EEPROMWRB
; 0000 0531 
; 0000 0532                 k = read_adc(1);
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x3D
; 0000 0533                 if  (k<bb1)   {bb1=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x16F
	MOV  R30,R16
	LDI  R26,LOW(_bb1)
	LDI  R27,HIGH(_bb1)
	CALL __EEPROMWRB
; 0000 0534                 if  (k>ba1)   {ba1=k;}
_0x16F:
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x170
	MOV  R30,R16
	LDI  R26,LOW(_ba1)
	LDI  R27,HIGH(_ba1)
	CALL __EEPROMWRB
; 0000 0535 
; 0000 0536                 bt1=((bb1+ba1)/2);
_0x170:
	CALL SUBOPT_0x3F
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x3E
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL __EEPROMWRB
; 0000 0537 
; 0000 0538                 k = read_adc(2);
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x40
; 0000 0539                 if  (k<bb2)   {bb2=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x171
	MOV  R30,R16
	LDI  R26,LOW(_bb2)
	LDI  R27,HIGH(_bb2)
	CALL __EEPROMWRB
; 0000 053A                 if  (k>ba2)   {ba2=k;}
_0x171:
	CALL SUBOPT_0x41
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x172
	MOV  R30,R16
	LDI  R26,LOW(_ba2)
	LDI  R27,HIGH(_ba2)
	CALL __EEPROMWRB
; 0000 053B 
; 0000 053C                 bt2=((bb2+ba2)/2);
_0x172:
	CALL SUBOPT_0x42
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x41
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt2)
	LDI  R27,HIGH(_bt2)
	CALL __EEPROMWRB
; 0000 053D 
; 0000 053E                 k = read_adc(3);
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x44
; 0000 053F                 if  (k<bb3)   {bb3=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x173
	MOV  R30,R16
	LDI  R26,LOW(_bb3)
	LDI  R27,HIGH(_bb3)
	CALL __EEPROMWRB
; 0000 0540                 if  (k>ba3)   {ba3=k;}
_0x173:
	CALL SUBOPT_0x45
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x174
	MOV  R30,R16
	LDI  R26,LOW(_ba3)
	LDI  R27,HIGH(_ba3)
	CALL __EEPROMWRB
; 0000 0541 
; 0000 0542                 bt3=((bb3+ba3)/2);
_0x174:
	CALL SUBOPT_0x46
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x45
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt3)
	LDI  R27,HIGH(_bt3)
	CALL __EEPROMWRB
; 0000 0543 
; 0000 0544                 k = read_adc(4);
	CALL SUBOPT_0x23
	CALL SUBOPT_0x47
; 0000 0545                 if  (k<bb4)   {bb4=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x175
	MOV  R30,R16
	LDI  R26,LOW(_bb4)
	LDI  R27,HIGH(_bb4)
	CALL __EEPROMWRB
; 0000 0546                 if  (k>ba4)   {ba4=k;}
_0x175:
	CALL SUBOPT_0x48
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x176
	MOV  R30,R16
	LDI  R26,LOW(_ba4)
	LDI  R27,HIGH(_ba4)
	CALL __EEPROMWRB
; 0000 0547 
; 0000 0548                 bt4=((bb4+ba4)/2);
_0x176:
	CALL SUBOPT_0x49
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x48
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt4)
	LDI  R27,HIGH(_bt4)
	CALL __EEPROMWRB
; 0000 0549 
; 0000 054A                 k = read_adc(5);
	CALL SUBOPT_0x22
	CALL SUBOPT_0x4A
; 0000 054B                 if  (k<bb5)   {bb5=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x177
	MOV  R30,R16
	LDI  R26,LOW(_bb5)
	LDI  R27,HIGH(_bb5)
	CALL __EEPROMWRB
; 0000 054C                 if  (k>ba5)   {ba5=k;}
_0x177:
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x178
	MOV  R30,R16
	LDI  R26,LOW(_ba5)
	LDI  R27,HIGH(_ba5)
	CALL __EEPROMWRB
; 0000 054D 
; 0000 054E                 bt5=((bb5+ba5)/2);
_0x178:
	CALL SUBOPT_0x4C
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt5)
	LDI  R27,HIGH(_bt5)
	CALL __EEPROMWRB
; 0000 054F 
; 0000 0550                 k = read_adc(6);
	CALL SUBOPT_0x21
	CALL SUBOPT_0x4D
; 0000 0551                 if  (k<bb6)   {bb6=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x179
	MOV  R30,R16
	LDI  R26,LOW(_bb6)
	LDI  R27,HIGH(_bb6)
	CALL __EEPROMWRB
; 0000 0552                 if  (k>ba6)   {ba6=k;}
_0x179:
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x17A
	MOV  R30,R16
	LDI  R26,LOW(_ba6)
	LDI  R27,HIGH(_ba6)
	CALL __EEPROMWRB
; 0000 0553 
; 0000 0554                 bt6=((bb6+ba6)/2);
_0x17A:
	CALL SUBOPT_0x4F
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt6)
	LDI  R27,HIGH(_bt6)
	CALL __EEPROMWRB
; 0000 0555 
; 0000 0556                 k = read_adc(7);
	CALL SUBOPT_0x20
	CALL SUBOPT_0x50
; 0000 0557                 if  (k<bb7)   {bb7=k;}
	CP   R26,R30
	CPC  R27,R31
	BRGE _0x17B
	MOV  R30,R16
	LDI  R26,LOW(_bb7)
	LDI  R27,HIGH(_bb7)
	CALL __EEPROMWRB
; 0000 0558                 if  (k>ba7)   {ba7=k;}
_0x17B:
	CALL SUBOPT_0x51
	CALL SUBOPT_0x36
	CP   R30,R26
	CPC  R31,R27
	BRGE _0x17C
	MOV  R30,R16
	LDI  R26,LOW(_ba7)
	LDI  R27,HIGH(_ba7)
	CALL __EEPROMWRB
; 0000 0559 
; 0000 055A                 bt7=((bb7+ba7)/2);
_0x17C:
	CALL SUBOPT_0x52
	MOV  R0,R30
	CLR  R1
	CALL SUBOPT_0x51
	CALL SUBOPT_0x38
	LDI  R26,LOW(_bt7)
	LDI  R27,HIGH(_bt7)
	CALL SUBOPT_0x39
; 0000 055B 
; 0000 055C                 lcd_clear();
; 0000 055D                 lcd_gotoxy(1,0);
; 0000 055E                 sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
	CALL SUBOPT_0x19
	__POINTW1FN _0x0,645
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x2B
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x29
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x28
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x27
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x26
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x25
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x24
	CALL SUBOPT_0x1B
	LDI  R24,32
	CALL _sprintf
	ADIW R28,36
; 0000 055F                 lcd_puts(lcd);
	CALL SUBOPT_0x19
	CALL _lcd_puts
; 0000 0560                 delay_ms(120);
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x53
; 0000 0561 
; 0000 0562                 if (!sw_ok)
	SBIS 0x10,5
; 0000 0563                 {
; 0000 0564                         goto selesai_auto_scan;
	RJMP _0x17E
; 0000 0565                 }
; 0000 0566         }
	RJMP _0x16B
; 0000 0567 
; 0000 0568     selesai_auto_scan:
_0x17E:
; 0000 0569     lcd_clear();
_0x2080008:
	CALL _lcd_clear
; 0000 056A }
_0x2080009:
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void scanBlackLine(void)
; 0000 056D {
_scanBlackLine:
; 0000 056E         switch(sensor)
	MOV  R30,R6
	LDI  R31,0
; 0000 056F         {
; 0000 0570                 case 0b11111110:        // ujung kiri
	CPI  R30,LOW(0xFE)
	LDI  R26,HIGH(0xFE)
	CPC  R31,R26
	BRNE _0x182
; 0000 0571                 PV = -10;
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	CALL SUBOPT_0x54
; 0000 0572                 maju();
	RJMP _0x3D2
; 0000 0573                 break;
; 0000 0574 
; 0000 0575                 case 0b11111000:
_0x182:
	CPI  R30,LOW(0xF8)
	LDI  R26,HIGH(0xF8)
	CPC  R31,R26
	BREQ _0x184
; 0000 0576                 case 0b11111100:
	CPI  R30,LOW(0xFC)
	LDI  R26,HIGH(0xFC)
	CPC  R31,R26
	BRNE _0x185
_0x184:
; 0000 0577                 PV = -6;
	LDI  R30,LOW(65530)
	LDI  R31,HIGH(65530)
	CALL SUBOPT_0x54
; 0000 0578                 maju();
	RJMP _0x3D2
; 0000 0579                 break;
; 0000 057A 
; 0000 057B                 case 0b11111101:
_0x185:
	CPI  R30,LOW(0xFD)
	LDI  R26,HIGH(0xFD)
	CPC  R31,R26
	BRNE _0x186
; 0000 057C                 PV = -5;
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	CALL SUBOPT_0x54
; 0000 057D                 maju();
	RJMP _0x3D2
; 0000 057E                 break;
; 0000 057F 
; 0000 0580                 case 0b11110001:
_0x186:
	CPI  R30,LOW(0xF1)
	LDI  R26,HIGH(0xF1)
	CPC  R31,R26
	BREQ _0x188
; 0000 0581                 case 0b11111001:
	CPI  R30,LOW(0xF9)
	LDI  R26,HIGH(0xF9)
	CPC  R31,R26
	BRNE _0x189
_0x188:
; 0000 0582                 PV = -4;
	LDI  R30,LOW(65532)
	LDI  R31,HIGH(65532)
	CALL SUBOPT_0x54
; 0000 0583                 maju();
	RJMP _0x3D2
; 0000 0584                 break;
; 0000 0585 
; 0000 0586                 case 0b11111011:
_0x189:
	CPI  R30,LOW(0xFB)
	LDI  R26,HIGH(0xFB)
	CPC  R31,R26
	BRNE _0x18A
; 0000 0587                 PV = -3;
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	CALL SUBOPT_0x54
; 0000 0588                 maju();
	RJMP _0x3D2
; 0000 0589                 break;
; 0000 058A 
; 0000 058B                 case 0b11100011:
_0x18A:
	CPI  R30,LOW(0xE3)
	LDI  R26,HIGH(0xE3)
	CPC  R31,R26
	BREQ _0x18C
; 0000 058C                 case 0b11110011:
	CPI  R30,LOW(0xF3)
	LDI  R26,HIGH(0xF3)
	CPC  R31,R26
	BRNE _0x18D
_0x18C:
; 0000 058D                 PV = -2;
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CALL SUBOPT_0x54
; 0000 058E                 maju();
	RJMP _0x3D2
; 0000 058F                 break;
; 0000 0590 
; 0000 0591                 case 0b11110111:
_0x18D:
	CPI  R30,LOW(0xF7)
	LDI  R26,HIGH(0xF7)
	CPC  R31,R26
	BRNE _0x18E
; 0000 0592                 PV = -1;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL SUBOPT_0x54
; 0000 0593                 maju();
	RJMP _0x3D2
; 0000 0594                 break;
; 0000 0595 
; 0000 0596                 //////////////
; 0000 0597                 case 0b11100111:        // tengah
_0x18E:
	CPI  R30,LOW(0xE7)
	LDI  R26,HIGH(0xE7)
	CPC  R31,R26
	BRNE _0x18F
; 0000 0598                 PV = 0;
	LDI  R30,LOW(0)
	STS  _PV,R30
	STS  _PV+1,R30
; 0000 0599                 maju();
	RJMP _0x3D2
; 0000 059A                 break;
; 0000 059B                 //////////////
; 0000 059C 
; 0000 059D                 case 0b11101111:
_0x18F:
	CPI  R30,LOW(0xEF)
	LDI  R26,HIGH(0xEF)
	CPC  R31,R26
	BRNE _0x190
; 0000 059E                 PV = 1;
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x54
; 0000 059F                 maju();
	RJMP _0x3D2
; 0000 05A0                 break;
; 0000 05A1 
; 0000 05A2                 case 0b11000111:
_0x190:
	CPI  R30,LOW(0xC7)
	LDI  R26,HIGH(0xC7)
	CPC  R31,R26
	BREQ _0x192
; 0000 05A3                 case 0b11001111:
	CPI  R30,LOW(0xCF)
	LDI  R26,HIGH(0xCF)
	CPC  R31,R26
	BRNE _0x193
_0x192:
; 0000 05A4                 PV = 2;
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x54
; 0000 05A5                 maju();
	RJMP _0x3D2
; 0000 05A6                 break;
; 0000 05A7 
; 0000 05A8                 case 0b11011111:
_0x193:
	CPI  R30,LOW(0xDF)
	LDI  R26,HIGH(0xDF)
	CPC  R31,R26
	BRNE _0x194
; 0000 05A9                 PV = 3;
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x54
; 0000 05AA                 maju();
	RJMP _0x3D2
; 0000 05AB                 break;
; 0000 05AC 
; 0000 05AD                 case 0b10001111:
_0x194:
	CPI  R30,LOW(0x8F)
	LDI  R26,HIGH(0x8F)
	CPC  R31,R26
	BREQ _0x196
; 0000 05AE                 case 0b10011111:
	CPI  R30,LOW(0x9F)
	LDI  R26,HIGH(0x9F)
	CPC  R31,R26
	BRNE _0x197
_0x196:
; 0000 05AF                 PV = 4;
	LDI  R30,LOW(4)
	LDI  R31,HIGH(4)
	CALL SUBOPT_0x54
; 0000 05B0                 maju();
	RJMP _0x3D2
; 0000 05B1                 break;
; 0000 05B2 
; 0000 05B3                 case 0b10111111:
_0x197:
	CPI  R30,LOW(0xBF)
	LDI  R26,HIGH(0xBF)
	CPC  R31,R26
	BRNE _0x198
; 0000 05B4                 PV = 5;
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x54
; 0000 05B5                 maju();
	RJMP _0x3D2
; 0000 05B6                 break;
; 0000 05B7 
; 0000 05B8                 case 0b00011111:
_0x198:
	CPI  R30,LOW(0x1F)
	LDI  R26,HIGH(0x1F)
	CPC  R31,R26
	BREQ _0x19A
; 0000 05B9                 case 0b00111111:
	CPI  R30,LOW(0x3F)
	LDI  R26,HIGH(0x3F)
	CPC  R31,R26
	BRNE _0x19B
_0x19A:
; 0000 05BA                 PV = 6;
	LDI  R30,LOW(6)
	LDI  R31,HIGH(6)
	CALL SUBOPT_0x54
; 0000 05BB                 maju();
	RJMP _0x3D2
; 0000 05BC                 break;
; 0000 05BD 
; 0000 05BE                 case 0b01111111:        // ujung kanan
_0x19B:
	CPI  R30,LOW(0x7F)
	LDI  R26,HIGH(0x7F)
	CPC  R31,R26
	BRNE _0x19C
; 0000 05BF                 PV = 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x54
; 0000 05C0                 maju();
	RJMP _0x3D2
; 0000 05C1                 break;
; 0000 05C2 
; 0000 05C3                 case 0b11111111:        // loss
_0x19C:
	CPI  R30,LOW(0xFF)
	LDI  R26,HIGH(0xFF)
	CPC  R31,R26
	BRNE _0x19D
; 0000 05C4                 if(PV<0)
	LDS  R26,_PV+1
	TST  R26
	BRPL _0x19E
; 0000 05C5                 {
; 0000 05C6                         lpwm = MINPWM;
	CALL SUBOPT_0x55
	CALL SUBOPT_0x56
; 0000 05C7                         rpwm = MINPWM;
; 0000 05C8                         bkir();
	RCALL _bkir
; 0000 05C9                         goto exit;
	RJMP _0x19F
; 0000 05CA                 }
; 0000 05CB                 else if(PV>0)
_0x19E:
	CALL SUBOPT_0x57
	CALL __CPW02
	BRGE _0x1A1
; 0000 05CC                 {
; 0000 05CD                         lpwm = MINPWM;
	CALL SUBOPT_0x58
; 0000 05CE                         rpwm = MINPWM;
; 0000 05CF                         bkan();
	RCALL _bkan
; 0000 05D0                         goto exit;
	RJMP _0x19F
; 0000 05D1                 }
; 0000 05D2                 break;
_0x1A1:
	RJMP _0x181
; 0000 05D3 
; 0000 05D4                 case 0b11000000:
_0x19D:
	CPI  R30,LOW(0xC0)
	LDI  R26,HIGH(0xC0)
	CPC  R31,R26
	BREQ _0x1A3
; 0000 05D5                 case 0b00000011:
	CPI  R30,LOW(0x3)
	LDI  R26,HIGH(0x3)
	CPC  R31,R26
	BRNE _0x1A4
_0x1A3:
; 0000 05D6                 case 0b11100000:
	RJMP _0x1A5
_0x1A4:
	CPI  R30,LOW(0xE0)
	LDI  R26,HIGH(0xE0)
	CPC  R31,R26
	BRNE _0x1A6
_0x1A5:
; 0000 05D7                 case 0b00000111:
	RJMP _0x1A7
_0x1A6:
	CPI  R30,LOW(0x7)
	LDI  R26,HIGH(0x7)
	CPC  R31,R26
	BRNE _0x181
_0x1A7:
; 0000 05D8                 maju();
_0x3D2:
	RCALL _maju
; 0000 05D9                 break;
; 0000 05DA         }
_0x181:
; 0000 05DB 
; 0000 05DC         error = SP - PV;
	LDS  R30,_SP
	LDI  R31,0
	CALL SUBOPT_0x57
	SUB  R30,R26
	SBC  R31,R27
	STS  _error,R30
	STS  _error+1,R31
; 0000 05DD         P = (var_Kp * error) / 2;
	CALL SUBOPT_0x59
	LDS  R26,_var_Kp
	LDS  R27,_var_Kp+1
	CALL SUBOPT_0x5A
	STS  _P,R30
	STS  _P+1,R31
; 0000 05DE 
; 0000 05DF         rate = error - last_error;
	LDS  R26,_last_error
	LDS  R27,_last_error+1
	CALL SUBOPT_0x59
	SUB  R30,R26
	SBC  R31,R27
	STS  _rate,R30
	STS  _rate+1,R31
; 0000 05E0         I    = (rate * var_Ki) / 2;
	LDS  R30,_var_Ki
	LDS  R31,_var_Ki+1
	LDS  R26,_rate
	LDS  R27,_rate+1
	CALL SUBOPT_0x5A
	STS  _I,R30
	STS  _I+1,R31
; 0000 05E1 
; 0000 05E2         D = ((error / 11) * (MINPWM / 20) * var_Kd);
	LDS  R26,_error
	LDS  R27,_error+1
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL __DIVW21
	MOVW R22,R30
	CALL SUBOPT_0x5B
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL __DIVW21
	MOVW R26,R22
	CALL __MULW12
	LDS  R26,_var_Kd
	LDS  R27,_var_Kd+1
	CALL __MULW12
	STS  _D,R30
	STS  _D+1,R31
; 0000 05E3 
; 0000 05E4         last_error = error;
	CALL SUBOPT_0x59
	STS  _last_error,R30
	STS  _last_error+1,R31
; 0000 05E5 
; 0000 05E6         MV = P + I + D;
	LDS  R30,_I
	LDS  R31,_I+1
	LDS  R26,_P
	LDS  R27,_P+1
	ADD  R30,R26
	ADC  R31,R27
	LDS  R26,_D
	LDS  R27,_D+1
	ADD  R30,R26
	ADC  R31,R27
	STS  _MV,R30
	STS  _MV+1,R31
; 0000 05E7 
; 0000 05E8         intervalPWM = (MAXPWM - MINPWM) / 8;
	CALL SUBOPT_0x5B
	LDS  R30,_MAXPWM
	LDS  R31,_MAXPWM+1
	SUB  R30,R26
	SBC  R31,R27
	MOVW R26,R30
	CALL SUBOPT_0x5C
; 0000 05E9 
; 0000 05EA         //rpwm = MINPWM + (intervalPWM * (0 + MV));
; 0000 05EB         //lpwm = MINPWM + (intervalPWM * (0 - MV));
; 0000 05EC 
; 0000 05ED         rpwm = MINPWM + MV;
	LDS  R30,_MV
	LDS  R31,_MV+1
	CALL SUBOPT_0x5B
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x5D
; 0000 05EE         lpwm = MINPWM - MV;
	LDS  R26,_MV
	LDS  R27,_MV+1
	CALL SUBOPT_0x55
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0x5E
; 0000 05EF 
; 0000 05F0         if(lpwm>255)
	LDS  R26,_lpwm
	LDS  R27,_lpwm+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1A9
; 0000 05F1         {
; 0000 05F2                 rpwm = rpwm - (lpwm - 255);
	CALL SUBOPT_0x0
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	LDS  R26,_rpwm
	LDS  R27,_rpwm+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _rpwm,R26
	STS  _rpwm+1,R27
; 0000 05F3                 lpwm = 255;
	CALL SUBOPT_0x2D
; 0000 05F4         }
; 0000 05F5 
; 0000 05F6         if(rpwm>255)
_0x1A9:
	LDS  R26,_rpwm
	LDS  R27,_rpwm+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x1AA
; 0000 05F7         {
; 0000 05F8                 lpwm = lpwm - (rpwm - 255);
	CALL SUBOPT_0x2
	SUBI R30,LOW(255)
	SBCI R31,HIGH(255)
	LDS  R26,_lpwm
	LDS  R27,_lpwm+1
	SUB  R26,R30
	SBC  R27,R31
	STS  _lpwm,R26
	STS  _lpwm+1,R27
; 0000 05F9                 rpwm = 255;
	CALL SUBOPT_0x2C
; 0000 05FA         }
; 0000 05FB 
; 0000 05FC         if(lpwm < 0)
_0x1AA:
	LDS  R26,_lpwm+1
	TST  R26
	BRPL _0x1AB
; 0000 05FD         {
; 0000 05FE                 stop(3);
	CALL SUBOPT_0x5F
; 0000 05FF                 rotkir();
	RCALL _rotkir
; 0000 0600                 lpwm = -1 * lpwm;
	CALL SUBOPT_0x0
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	CALL SUBOPT_0x5E
; 0000 0601         }
; 0000 0602 
; 0000 0603         if(rpwm < 0)
_0x1AB:
	LDS  R26,_rpwm+1
	TST  R26
	BRPL _0x1AC
; 0000 0604         {
; 0000 0605                 stop(3);
	CALL SUBOPT_0x5F
; 0000 0606                 rotkan();
	RCALL _rotkan
; 0000 0607                 rpwm = -1 * rpwm;
	CALL SUBOPT_0x2
	LDI  R26,LOW(65535)
	LDI  R27,HIGH(65535)
	CALL __MULW12
	CALL SUBOPT_0x5D
; 0000 0608         }
; 0000 0609 
; 0000 060A         if(lpwm==0)
_0x1AC:
	CALL SUBOPT_0x0
	SBIW R30,0
	BRNE _0x1AD
; 0000 060B         {
; 0000 060C                 if(PV<0)
	LDS  R26,_PV+1
	TST  R26
	BRPL _0x1AE
; 0000 060D                 {
; 0000 060E                         lpwm = MAXPWM/2;
	CALL SUBOPT_0x60
	CALL SUBOPT_0x61
; 0000 060F                         rpwm = MAXPWM/2;
	CALL SUBOPT_0x5D
; 0000 0610                         bkir();
	RCALL _bkir
; 0000 0611                         goto exit;
	RJMP _0x19F
; 0000 0612                 }
; 0000 0613                 else if(PV>0)
_0x1AE:
	CALL SUBOPT_0x57
	CALL __CPW02
	BRGE _0x1B0
; 0000 0614                 {
; 0000 0615                         lpwm = MAXPWM/2;
	CALL SUBOPT_0x60
	CALL SUBOPT_0x61
; 0000 0616                         rpwm = MAXPWM/2;
	CALL SUBOPT_0x5D
; 0000 0617                         bkan();
	RCALL _bkan
; 0000 0618                         goto exit;
; 0000 0619                 }
; 0000 061A         }
_0x1B0:
; 0000 061B 
; 0000 061C         if(rpwm==0)
_0x1AD:
; 0000 061D         {
; 0000 061E         }
; 0000 061F 
; 0000 0620         exit:
_0x19F:
; 0000 0621 
; 0000 0622         //debug pwm
; 0000 0623         sprintf(lcd,"%d   %d",lpwm, rpwm);
	CALL SUBOPT_0x19
	__POINTW1FN _0x0,669
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x0
	CALL __CWD1
	CALL __PUTPARD1
	CALL SUBOPT_0x2
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
; 0000 0624         lcd_gotoxy(0, 0);
	CALL SUBOPT_0x4
; 0000 0625         lcd_putsf("                ");
	__POINTW1FN _0x0,677
	CALL SUBOPT_0x5
; 0000 0626         lcd_gotoxy(0, 0);
	CALL SUBOPT_0x4
; 0000 0627         lcd_puts(lcd);
	CALL SUBOPT_0x19
	CALL _lcd_puts
; 0000 0628         delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x53
; 0000 0629 
; 0000 062A         /*
; 0000 062B         //debug MV
; 0000 062C         sprintf(lcd_buffer,"MV:%d",MV);
; 0000 062D         lcd_gotoxy(0,0);
; 0000 062E         lcd_putsf("                ");
; 0000 062F         lcd_gotoxy(0,0);
; 0000 0630         lcd_puts(lcd_buffer);
; 0000 0631         delay_ms(10);
; 0000 0632         */
; 0000 0633 }
	RET
;
;void scanSudut(void)
; 0000 0636 {
_scanSudut:
; 0000 0637         if((!sKa)&&(sensor==255))
	SBRC R3,0
	RJMP _0x1B3
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x1B4
_0x1B3:
	RJMP _0x1B2
_0x1B4:
; 0000 0638         {
; 0000 0639                 indikatorSudut();
	CALL SUBOPT_0x62
; 0000 063A                 baca_sensor();
; 0000 063B                 //while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
; 0000 063C                 while(sensor==255)
_0x1B5:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x1B7
; 0000 063D                 {
; 0000 063E                         baca_sensor();
	CALL SUBOPT_0x63
; 0000 063F                         lpwm=MINPWM;
; 0000 0640                         rpwm=MINPWM;
; 0000 0641                         rotkan();
	RCALL _rotkan
; 0000 0642                 }
	RJMP _0x1B5
_0x1B7:
; 0000 0643                 stop(5);
	CALL SUBOPT_0x64
; 0000 0644                 goto exit_sudut;
	RJMP _0x1B8
; 0000 0645         }
; 0000 0646 
; 0000 0647         if((!sKi)&&(sensor==255))
_0x1B2:
	SBRC R3,1
	RJMP _0x1BA
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x1BB
_0x1BA:
	RJMP _0x1B9
_0x1BB:
; 0000 0648         {
; 0000 0649                 indikatorSudut();
	CALL SUBOPT_0x62
; 0000 064A                 baca_sensor();
; 0000 064B                 //while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
; 0000 064C                 while(sensor==255)
_0x1BC:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x1BE
; 0000 064D                 {
; 0000 064E                         baca_sensor();
	CALL SUBOPT_0x63
; 0000 064F                         lpwm=MINPWM;
; 0000 0650                         rpwm=MINPWM;
; 0000 0651                         rotkir();
	RCALL _rotkir
; 0000 0652                 }
	RJMP _0x1BC
_0x1BE:
; 0000 0653                 stop(5);
	CALL SUBOPT_0x64
; 0000 0654                 goto exit_sudut;
; 0000 0655         }
; 0000 0656 
; 0000 0657         exit_sudut:
_0x1B9:
_0x1B8:
; 0000 0658 
; 0000 0659         maju();
	RJMP _0x2080007
; 0000 065A }
;
;// strategi track A penyisihan, warna : merah , hijau
;
;void cekPointStarta(void)
; 0000 065F {
_cekPointStarta:
; 0000 0660         start1:
_0x1BF:
; 0000 0661 
; 0000 0662         maju();
	CALL SUBOPT_0x65
; 0000 0663         displaySensorBit();
; 0000 0664         scanBlackLine();
; 0000 0665         if((!sKa) && (sensor==255))
	SBRC R3,0
	RJMP _0x1C1
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x1C2
_0x1C1:
	RJMP _0x1C0
_0x1C2:
; 0000 0666         {
; 0000 0667                 stop(5);
	CALL SUBOPT_0x64
; 0000 0668 
; 0000 0669                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 066A 
; 0000 066B                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x1C3:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x1C6
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x1C6
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x1C7
_0x1C6:
	RJMP _0x1C5
_0x1C7:
; 0000 066C                 {
; 0000 066D                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 066E                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 066F                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x67
; 0000 0670                         rotkir();
; 0000 0671                 }
	RJMP _0x1C3
_0x1C5:
; 0000 0672 
; 0000 0673                 stop(5);
	CALL SUBOPT_0x64
; 0000 0674 
; 0000 0675                 goto cekpoint11;
	RJMP _0x1C8
; 0000 0676         }
; 0000 0677         scanSudut();
_0x1C0:
	RCALL _scanSudut
; 0000 0678         goto start1;
	RJMP _0x1BF
; 0000 0679 
; 0000 067A         cekpoint11:
_0x1C8:
; 0000 067B }
	RET
;
;void cekPoint1a(void)
; 0000 067E {
_cekPoint1a:
; 0000 067F         //cek point 1
; 0000 0680         cekpoint11:
_0x1C9:
; 0000 0681 
; 0000 0682         maju();
	CALL SUBOPT_0x65
; 0000 0683         displaySensorBit();
; 0000 0684         scanBlackLine();
; 0000 0685 
; 0000 0686         if((!sKa)&&(sensor==255))
	SBRC R3,0
	RJMP _0x1CB
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x1CC
_0x1CB:
	RJMP _0x1CA
_0x1CC:
; 0000 0687         {
; 0000 0688                 indikatorSudut();
	CALL SUBOPT_0x68
; 0000 0689                 stop(5);
; 0000 068A 
; 0000 068B                 while(sensor==255)
_0x1CD:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x1CF
; 0000 068C                 {
; 0000 068D                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 068E                         lpwm=MAXPWM / 2;
	CALL SUBOPT_0x61
; 0000 068F                         rpwm=MAXPWM / 2;
	CALL SUBOPT_0x69
; 0000 0690                         rotkan();
; 0000 0691                         if((!sKa)&&(!sKi))
	SBRC R3,0
	RJMP _0x1D1
	SBRS R3,1
	RJMP _0x1D2
_0x1D1:
	RJMP _0x1D0
_0x1D2:
; 0000 0692                         {
; 0000 0693                                 indikatorPerempatan();
	CALL SUBOPT_0x6A
; 0000 0694                                 stop(5);
; 0000 0695 
; 0000 0696                                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x1D3:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x1D6
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x1D6
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x1D7
_0x1D6:
	RJMP _0x1D5
_0x1D7:
; 0000 0697                                 {
; 0000 0698                                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0699                                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 069A                                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x69
; 0000 069B                                         rotkan();
; 0000 069C                                 }
	RJMP _0x1D3
_0x1D5:
; 0000 069D                         }
; 0000 069E                 }
_0x1D0:
	RJMP _0x1CD
_0x1CF:
; 0000 069F                 stop(5);
	CALL SUBOPT_0x64
; 0000 06A0                 goto cekpoint12;
	RJMP _0x1D8
; 0000 06A1         }
; 0000 06A2 
; 0000 06A3         if((!sKi)&&(sensor==255))
_0x1CA:
	SBRC R3,1
	RJMP _0x1DA
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x1DB
_0x1DA:
	RJMP _0x1D9
_0x1DB:
; 0000 06A4         {
; 0000 06A5                 indikatorSudut();
	CALL SUBOPT_0x68
; 0000 06A6                 stop(5);
; 0000 06A7 
; 0000 06A8                 baca_sensor();
	RCALL _baca_sensor
; 0000 06A9                 while(sensor==255)
_0x1DC:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x1DE
; 0000 06AA                 {
; 0000 06AB                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 06AC                         lpwm=MAXPWM / 2;
	CALL SUBOPT_0x61
; 0000 06AD                         rpwm=MAXPWM / 2;
	CALL SUBOPT_0x67
; 0000 06AE                         rotkir();
; 0000 06AF                         if((!sKa)&&(!sKi))
	SBRC R3,0
	RJMP _0x1E0
	SBRS R3,1
	RJMP _0x1E1
_0x1E0:
	RJMP _0x1DF
_0x1E1:
; 0000 06B0                         {
; 0000 06B1                                 indikatorPerempatan();
	CALL SUBOPT_0x6A
; 0000 06B2                                 stop(5);
; 0000 06B3 
; 0000 06B4                                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x1E2:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x1E5
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x1E5
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x1E6
_0x1E5:
	RJMP _0x1E4
_0x1E6:
; 0000 06B5                                 {
; 0000 06B6                                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 06B7                                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 06B8                                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x69
; 0000 06B9                                         rotkan();
; 0000 06BA                                 }
	RJMP _0x1E2
_0x1E4:
; 0000 06BB                         }
; 0000 06BC                 }
_0x1DF:
	RJMP _0x1DC
_0x1DE:
; 0000 06BD                 stop(5);
	CALL SUBOPT_0x64
; 0000 06BE                 goto cekpoint12;
	RJMP _0x1D8
; 0000 06BF         }
; 0000 06C0         goto cekpoint11;
_0x1D9:
	RJMP _0x1C9
; 0000 06C1 
; 0000 06C2         cekpoint12:
_0x1D8:
; 0000 06C3 
; 0000 06C4         maju();
	CALL SUBOPT_0x65
; 0000 06C5         displaySensorBit();
; 0000 06C6         scanBlackLine();
; 0000 06C7         if((!sKi)&&(sensor==255))
	SBRC R3,1
	RJMP _0x1E8
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x1E9
_0x1E8:
	RJMP _0x1E7
_0x1E9:
; 0000 06C8         {
; 0000 06C9                 stop(5);
	CALL SUBOPT_0x64
; 0000 06CA 
; 0000 06CB                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 06CC 
; 0000 06CD                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x1EA:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x1ED
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x1ED
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x1EE
_0x1ED:
	RJMP _0x1EC
_0x1EE:
; 0000 06CE                 {
; 0000 06CF                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 06D0                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 06D1                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x67
; 0000 06D2                         rotkir();
; 0000 06D3                 }
	RJMP _0x1EA
_0x1EC:
; 0000 06D4 
; 0000 06D5                 stop(5);
	CALL SUBOPT_0x64
; 0000 06D6                 goto cekpoint13;
	RJMP _0x1EF
; 0000 06D7         }
; 0000 06D8 
; 0000 06D9         goto cekpoint12;
_0x1E7:
	RJMP _0x1D8
; 0000 06DA 
; 0000 06DB         cekpoint13:
_0x1EF:
; 0000 06DC 
; 0000 06DD         maju();
	CALL SUBOPT_0x65
; 0000 06DE         displaySensorBit();
; 0000 06DF         scanBlackLine();
; 0000 06E0         if((!sKi) && (sensor==255))
	SBRC R3,1
	RJMP _0x1F1
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x1F2
_0x1F1:
	RJMP _0x1F0
_0x1F2:
; 0000 06E1         {
; 0000 06E2                 stop(5);
	CALL SUBOPT_0x64
; 0000 06E3 
; 0000 06E4                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 06E5 
; 0000 06E6                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x1F3:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x1F6
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x1F6
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x1F7
_0x1F6:
	RJMP _0x1F5
_0x1F7:
; 0000 06E7                 {
; 0000 06E8                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 06E9                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 06EA                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x69
; 0000 06EB                         rotkan();
; 0000 06EC                 }
	RJMP _0x1F3
_0x1F5:
; 0000 06ED 
; 0000 06EE                 stop(5);
	CALL SUBOPT_0x64
; 0000 06EF                 goto cekpoint14;
	RJMP _0x1F8
; 0000 06F0         }
; 0000 06F1         scanSudut();
_0x1F0:
	RCALL _scanSudut
; 0000 06F2         goto cekpoint13;
	RJMP _0x1EF
; 0000 06F3 
; 0000 06F4         cekpoint14:
_0x1F8:
; 0000 06F5 
; 0000 06F6         maju();
	CALL SUBOPT_0x65
; 0000 06F7         displaySensorBit();
; 0000 06F8         scanBlackLine();
; 0000 06F9         if((!sKi)&&(!sKa)&&(sensor<255))
	SBRC R3,1
	RJMP _0x1FA
	SBRC R3,0
	RJMP _0x1FA
	LDI  R30,LOW(255)
	CP   R6,R30
	BRLO _0x1FB
_0x1FA:
	RJMP _0x1F9
_0x1FB:
; 0000 06FA         {
; 0000 06FB                 stop(5);
	CALL SUBOPT_0x64
; 0000 06FC                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 06FD 
; 0000 06FE                 while(sensor<255)
_0x1FC:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x1FE
; 0000 06FF                 {
; 0000 0700                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0701                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0702                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x67
; 0000 0703                         rotkir();
; 0000 0704                 }
	RJMP _0x1FC
_0x1FE:
; 0000 0705 
; 0000 0706                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x1FF:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x202
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x202
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x203
_0x202:
	RJMP _0x201
_0x203:
; 0000 0707                 {
; 0000 0708                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0709                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 070A                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x67
; 0000 070B                         rotkir();
; 0000 070C                 }
	RJMP _0x1FF
_0x201:
; 0000 070D 
; 0000 070E                 stop(5);
	CALL SUBOPT_0x64
; 0000 070F                 goto cekpoint21;
	RJMP _0x204
; 0000 0710         }
; 0000 0711         goto cekpoint14;
_0x1F9:
	RJMP _0x1F8
; 0000 0712 
; 0000 0713         cekpoint21:
_0x204:
; 0000 0714 }
	RET
;
;void cekPoint2a(void)
; 0000 0717 {
_cekPoint2a:
; 0000 0718         //cek point 2
; 0000 0719         cekpoint21:
_0x205:
; 0000 071A 
; 0000 071B         maju();
	CALL SUBOPT_0x65
; 0000 071C         displaySensorBit();
; 0000 071D         scanBlackLine();
; 0000 071E 
; 0000 071F         if((!sKa)&&(!sKi))
	SBRC R3,0
	RJMP _0x207
	SBRS R3,1
	RJMP _0x208
_0x207:
	RJMP _0x206
_0x208:
; 0000 0720         {
; 0000 0721                 while((!sKa)&&(!sKi));
_0x209:
	SBRC R3,0
	RJMP _0x20C
	SBRS R3,1
	RJMP _0x20D
_0x20C:
	RJMP _0x20B
_0x20D:
	RJMP _0x209
_0x20B:
; 0000 0722                 while((sKa)&&(sKi))
_0x20E:
	SBRS R3,0
	RJMP _0x211
	SBRC R3,1
	RJMP _0x212
_0x211:
	RJMP _0x210
_0x212:
; 0000 0723                 {
; 0000 0724                         maju();
	CALL SUBOPT_0x65
; 0000 0725                         displaySensorBit();
; 0000 0726                         scanBlackLine();
; 0000 0727                 }
	RJMP _0x20E
_0x210:
; 0000 0728                 if((!sKa)&&(!sKi))
	SBRC R3,0
	RJMP _0x214
	SBRS R3,1
	RJMP _0x215
_0x214:
	RJMP _0x213
_0x215:
; 0000 0729                 {
; 0000 072A                         stop(5);
	CALL SUBOPT_0x64
; 0000 072B                         indikatorPerempatan();
	CALL SUBOPT_0x6B
; 0000 072C 
; 0000 072D                         baca_sensor();
; 0000 072E                         while(sensor<255)
_0x216:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x218
; 0000 072F                         {
; 0000 0730                                 baca_sensor();
	CALL SUBOPT_0x66
; 0000 0731                                 lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0732                                 rpwm=MAXPWM/2;
	CALL SUBOPT_0x67
; 0000 0733                                 rotkir();
; 0000 0734                         }
	RJMP _0x216
_0x218:
; 0000 0735 
; 0000 0736                         baca_sensor();
	CALL _baca_sensor
; 0000 0737                         while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x219:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x21C
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x21C
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x21D
_0x21C:
	RJMP _0x21B
_0x21D:
; 0000 0738                         {
; 0000 0739                                 baca_sensor();
	CALL SUBOPT_0x66
; 0000 073A                                 lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 073B                                 rpwm=MAXPWM/2;
	CALL SUBOPT_0x67
; 0000 073C                                 rotkir();
; 0000 073D                         }
	RJMP _0x219
_0x21B:
; 0000 073E 
; 0000 073F                         stop(5);
	CALL SUBOPT_0x64
; 0000 0740                 }
; 0000 0741                 goto cekpoint22;
_0x213:
	RJMP _0x21E
; 0000 0742         }
; 0000 0743         goto cekpoint21;
_0x206:
	RJMP _0x205
; 0000 0744 
; 0000 0745         cekpoint22:
_0x21E:
; 0000 0746 
; 0000 0747         maju();
	CALL SUBOPT_0x65
; 0000 0748         displaySensorBit();
; 0000 0749         scanBlackLine();
; 0000 074A         if((!sKa)&&(sensor==255))
	SBRC R3,0
	RJMP _0x220
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x221
_0x220:
	RJMP _0x21F
_0x221:
; 0000 074B         {
; 0000 074C                 indikatorSudut();
	CALL SUBOPT_0x68
; 0000 074D                 stop(5);
; 0000 074E 
; 0000 074F                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 0750 
; 0000 0751                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x222:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x225
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x225
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x226
_0x225:
	RJMP _0x224
_0x226:
; 0000 0752                 {
; 0000 0753                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0754                         lpwm=MAXPWM / 2;
	CALL SUBOPT_0x61
; 0000 0755                         rpwm=MAXPWM / 2;
	CALL SUBOPT_0x69
; 0000 0756                         rotkan();
; 0000 0757                 }
	RJMP _0x222
_0x224:
; 0000 0758                 stop(5);
	CALL SUBOPT_0x64
; 0000 0759                 goto exit_sudut22;
	RJMP _0x227
; 0000 075A         }
; 0000 075B 
; 0000 075C         if((!sKi)&&(sensor==255))
_0x21F:
	SBRC R3,1
	RJMP _0x229
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x22A
_0x229:
	RJMP _0x228
_0x22A:
; 0000 075D         {
; 0000 075E                 indikatorSudut();
	CALL SUBOPT_0x68
; 0000 075F                 stop(5);
; 0000 0760                 baca_sensor();
	CALL _baca_sensor
; 0000 0761                 while(sensor==255)
_0x22B:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x22D
; 0000 0762                 {
; 0000 0763                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0764                         lpwm=MAXPWM / 2;
	CALL SUBOPT_0x61
; 0000 0765                         rpwm=MAXPWM / 2;
	CALL SUBOPT_0x67
; 0000 0766                         rotkir();
; 0000 0767                         if((!sKa)&&(sensor==255))
	SBRC R3,0
	RJMP _0x22F
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x230
_0x22F:
	RJMP _0x22E
_0x230:
; 0000 0768                         {
; 0000 0769                                 stop(5);
	CALL SUBOPT_0x64
; 0000 076A                                 indikatorPerempatan();
	CALL SUBOPT_0x6B
; 0000 076B 
; 0000 076C                                 baca_sensor();
; 0000 076D                                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x231:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x234
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x234
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x235
_0x234:
	RJMP _0x233
_0x235:
; 0000 076E                                 {
; 0000 076F                                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0770                                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0771                                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x69
; 0000 0772                                         rotkan();
; 0000 0773                                 }
	RJMP _0x231
_0x233:
; 0000 0774 
; 0000 0775                                 stop(5);
	CALL SUBOPT_0x64
; 0000 0776                                 goto cekpoint3;
	RJMP _0x236
; 0000 0777                         }
; 0000 0778                 }
_0x22E:
	RJMP _0x22B
_0x22D:
; 0000 0779 
; 0000 077A                 stop(5);
	CALL SUBOPT_0x64
; 0000 077B                 goto exit_sudut22;
; 0000 077C         }
; 0000 077D 
; 0000 077E         exit_sudut22:
_0x228:
_0x227:
; 0000 077F 
; 0000 0780         maju();
	RCALL _maju
; 0000 0781         goto cekpoint22;
	RJMP _0x21E
; 0000 0782 
; 0000 0783         cekpoint3:
_0x236:
; 0000 0784         maju();
_0x2080007:
	RCALL _maju
; 0000 0785 }
	RET
;
;void cekPoint3a(void)
; 0000 0788 {
_cekPoint3a:
; 0000 0789         char f;
; 0000 078A 
; 0000 078B         //cek point 3
; 0000 078C         MINPWM = 100;
	ST   -Y,R17
;	f -> R17
	CALL SUBOPT_0x6C
; 0000 078D         var_Kp = 11;
	CALL SUBOPT_0x6D
; 0000 078E         var_Ki = 0;
; 0000 078F         var_Kd = 7;
; 0000 0790 
; 0000 0791         // cari simpangan
; 0000 0792         while(sKi)
_0x237:
	SBRS R3,1
	RJMP _0x239
; 0000 0793         {
; 0000 0794                 maju();
	CALL SUBOPT_0x65
; 0000 0795                 displaySensorBit();
; 0000 0796                 scanBlackLine();
; 0000 0797         }
	RJMP _0x237
_0x239:
; 0000 0798         indikatorSudut();
	CALL SUBOPT_0x68
; 0000 0799 
; 0000 079A         // putar kanan
; 0000 079B         stop(5);
; 0000 079C         baca_sensor();
	CALL _baca_sensor
; 0000 079D         while(sKi)
_0x23A:
	SBRS R3,1
	RJMP _0x23C
; 0000 079E         {
; 0000 079F                 mundur();
	CALL SUBOPT_0x6E
; 0000 07A0                 lpwm = MINPWM;
; 0000 07A1                 rpwm = MINPWM;
; 0000 07A2                 baca_sensor();
	CALL _baca_sensor
; 0000 07A3         }
	RJMP _0x23A
_0x23C:
; 0000 07A4         stop(3);
	CALL SUBOPT_0x5F
; 0000 07A5         baca_sensor();
	CALL _baca_sensor
; 0000 07A6         while(sensor<255)
_0x23D:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x23F
; 0000 07A7         {
; 0000 07A8                 rotkir();
	CALL SUBOPT_0x6F
; 0000 07A9                 lpwm = MINPWM;
; 0000 07AA                 rpwm = MINPWM;
; 0000 07AB                 baca_sensor();
	CALL _baca_sensor
; 0000 07AC         }
	RJMP _0x23D
_0x23F:
; 0000 07AD         baca_sensor();
	CALL _baca_sensor
; 0000 07AE         while(s3)
_0x240:
	SBRS R2,3
	RJMP _0x242
; 0000 07AF         {
; 0000 07B0                 rotkir();
	CALL SUBOPT_0x6F
; 0000 07B1                 lpwm = MINPWM;
; 0000 07B2                 rpwm = MINPWM;
; 0000 07B3                 baca_sensor();
	CALL _baca_sensor
; 0000 07B4         }
	RJMP _0x240
_0x242:
; 0000 07B5 
; 0000 07B6         // counting simpangan
; 0000 07B7         stop(5);
	CALL SUBOPT_0x64
; 0000 07B8         baca_sensor();
	CALL _baca_sensor
; 0000 07B9         while(sKi)
_0x243:
	SBRS R3,1
	RJMP _0x245
; 0000 07BA         {
; 0000 07BB                 maju();
	CALL SUBOPT_0x65
; 0000 07BC                 displaySensorBit();
; 0000 07BD                 scanBlackLine();
; 0000 07BE         }
	RJMP _0x243
_0x245:
; 0000 07BF         indikatorSudut();
	RCALL _indikatorSudut
; 0000 07C0         while(!sKi)
_0x246:
	SBRC R3,1
	RJMP _0x248
; 0000 07C1         {
; 0000 07C2                 maju();
	CALL SUBOPT_0x65
; 0000 07C3                 displaySensorBit();
; 0000 07C4                 scanBlackLine();
; 0000 07C5         }
	RJMP _0x246
_0x248:
; 0000 07C6         while(sKi)
_0x249:
	SBRS R3,1
	RJMP _0x24B
; 0000 07C7         {
; 0000 07C8                 maju();
	CALL SUBOPT_0x65
; 0000 07C9                 displaySensorBit();
; 0000 07CA                 scanBlackLine();
; 0000 07CB         }
	RJMP _0x249
_0x24B:
; 0000 07CC         indikatorSudut();
	RCALL _indikatorSudut
; 0000 07CD         while(!sKi)
_0x24C:
	SBRC R3,1
	RJMP _0x24E
; 0000 07CE         {
; 0000 07CF                 maju();
	CALL SUBOPT_0x65
; 0000 07D0                 displaySensorBit();
; 0000 07D1                 scanBlackLine();
; 0000 07D2         }
	RJMP _0x24C
_0x24E:
; 0000 07D3         for(f=0;f<30;f++)
	LDI  R17,LOW(0)
_0x250:
	CPI  R17,30
	BRSH _0x251
; 0000 07D4         {
; 0000 07D5                 maju();
	CALL SUBOPT_0x65
; 0000 07D6                 displaySensorBit();
; 0000 07D7                 scanBlackLine();
; 0000 07D8         }
	SUBI R17,-1
	RJMP _0x250
_0x251:
; 0000 07D9         while(sKa)
_0x252:
	SBRS R3,0
	RJMP _0x254
; 0000 07DA         {
; 0000 07DB                 maju();
	CALL _maju
; 0000 07DC                 displaySensorBit();
	CALL _displaySensorBit
; 0000 07DD         }
	RJMP _0x252
_0x254:
; 0000 07DE         indikatorSudut();
	CALL SUBOPT_0x68
; 0000 07DF 
; 0000 07E0         // putar kiri
; 0000 07E1         stop(5);
; 0000 07E2         baca_sensor();
	CALL _baca_sensor
; 0000 07E3         while(sKi)
_0x255:
	SBRS R3,1
	RJMP _0x257
; 0000 07E4         {
; 0000 07E5                 mundur();
	CALL SUBOPT_0x6E
; 0000 07E6                 lpwm = MINPWM;
; 0000 07E7                 rpwm = MINPWM;
; 0000 07E8                 baca_sensor();
	CALL _baca_sensor
; 0000 07E9         }
	RJMP _0x255
_0x257:
; 0000 07EA         stop(5);
	CALL SUBOPT_0x64
; 0000 07EB         baca_sensor();
	CALL _baca_sensor
; 0000 07EC         while(sensor<255)
_0x258:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x25A
; 0000 07ED         {
; 0000 07EE                 rotkan();
	RCALL _rotkan
; 0000 07EF                 lpwm = MINPWM;
	CALL SUBOPT_0x58
; 0000 07F0                 rpwm = MINPWM;
; 0000 07F1                 baca_sensor();
	CALL _baca_sensor
; 0000 07F2         }
	RJMP _0x258
_0x25A:
; 0000 07F3         while(s4)
_0x25B:
	SBRS R2,4
	RJMP _0x25D
; 0000 07F4         {
; 0000 07F5                 rotkan();
	RCALL _rotkan
; 0000 07F6                 lpwm = MINPWM;
	CALL SUBOPT_0x58
; 0000 07F7                 rpwm = MINPWM;
; 0000 07F8                 baca_sensor();
	CALL _baca_sensor
; 0000 07F9         }
	RJMP _0x25B
_0x25D:
; 0000 07FA 
; 0000 07FB         // counting simpangan
; 0000 07FC         stop(5);
	CALL SUBOPT_0x64
; 0000 07FD         baca_sensor();
	CALL _baca_sensor
; 0000 07FE         while(sKi)
_0x25E:
	SBRS R3,1
	RJMP _0x260
; 0000 07FF         {
; 0000 0800                 maju();
	CALL SUBOPT_0x65
; 0000 0801                 displaySensorBit();
; 0000 0802                 scanBlackLine();
; 0000 0803         }
	RJMP _0x25E
_0x260:
; 0000 0804         indikatorSudut();
	RCALL _indikatorSudut
; 0000 0805         while(!sKi)
_0x261:
	SBRC R3,1
	RJMP _0x263
; 0000 0806         {
; 0000 0807                 maju();
	CALL SUBOPT_0x65
; 0000 0808                 displaySensorBit();
; 0000 0809                 scanBlackLine();
; 0000 080A         }
	RJMP _0x261
_0x263:
; 0000 080B         while(sKi)
_0x264:
	SBRS R3,1
	RJMP _0x266
; 0000 080C         {
; 0000 080D                 maju();
	CALL SUBOPT_0x65
; 0000 080E                 displaySensorBit();
; 0000 080F                 scanBlackLine();
; 0000 0810         }
	RJMP _0x264
_0x266:
; 0000 0811         indikatorSudut();
	CALL SUBOPT_0x68
; 0000 0812 
; 0000 0813         // putar kanan
; 0000 0814         stop(5);
; 0000 0815         baca_sensor();
	CALL _baca_sensor
; 0000 0816         while(sKi)
_0x267:
	SBRS R3,1
	RJMP _0x269
; 0000 0817         {
; 0000 0818                 mundur();
	CALL SUBOPT_0x6E
; 0000 0819                 lpwm = MINPWM;
; 0000 081A                 rpwm = MINPWM;
; 0000 081B                 baca_sensor();
	CALL _baca_sensor
; 0000 081C         }
	RJMP _0x267
_0x269:
; 0000 081D         while(sensor<255)
_0x26A:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x26C
; 0000 081E         {
; 0000 081F                 rotkir();
	CALL SUBOPT_0x6F
; 0000 0820                 lpwm = MINPWM;
; 0000 0821                 rpwm = MINPWM;
; 0000 0822                 baca_sensor();
	CALL _baca_sensor
; 0000 0823         }
	RJMP _0x26A
_0x26C:
; 0000 0824         while(sensor==255)
_0x26D:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x26F
; 0000 0825         {
; 0000 0826                 rotkir();
	CALL SUBOPT_0x6F
; 0000 0827                 lpwm = MINPWM;
; 0000 0828                 rpwm = MINPWM;
; 0000 0829                 baca_sensor();
	CALL _baca_sensor
; 0000 082A         }
	RJMP _0x26D
_0x26F:
; 0000 082B 
; 0000 082C         for(f=0;f<50;f++)
	LDI  R17,LOW(0)
_0x271:
	CPI  R17,50
	BRSH _0x272
; 0000 082D         {
; 0000 082E                 maju();
	CALL SUBOPT_0x65
; 0000 082F                 displaySensorBit();
; 0000 0830                 scanBlackLine();
; 0000 0831         }
	SUBI R17,-1
	RJMP _0x271
_0x272:
; 0000 0832         // done !
; 0000 0833         indikatorSudut();
	RCALL _indikatorSudut
; 0000 0834 }
	LD   R17,Y+
	RET
;
;void cekPoint4a(void)
; 0000 0837 {
_cekPoint4a:
; 0000 0838         // cekpoint 4;
; 0000 0839         MINPWM = 100;
	CALL SUBOPT_0x6C
; 0000 083A         var_Kp = 17;
	LDI  R30,LOW(17)
	LDI  R31,HIGH(17)
	CALL SUBOPT_0x70
; 0000 083B         var_Ki = 0;
	LDI  R30,LOW(0)
	STS  _var_Ki,R30
	STS  _var_Ki+1,R30
; 0000 083C         var_Kd = 11;
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	CALL SUBOPT_0x71
; 0000 083D 
; 0000 083E         cekpoint4:
_0x273:
; 0000 083F 
; 0000 0840         maju();
	CALL SUBOPT_0x65
; 0000 0841         displaySensorBit();
; 0000 0842         scanBlackLine();
; 0000 0843 
; 0000 0844         if(!sKa)
	SBRC R3,0
	RJMP _0x274
; 0000 0845         {
; 0000 0846                 stop(5);
	CALL SUBOPT_0x64
; 0000 0847                 indikatorSudut();
	CALL SUBOPT_0x62
; 0000 0848                 baca_sensor();
; 0000 0849                 while(sKa)
_0x275:
	SBRS R3,0
	RJMP _0x277
; 0000 084A                 {
; 0000 084B                         mundur();
	CALL SUBOPT_0x6E
; 0000 084C                         lpwm = MINPWM;
; 0000 084D                         rpwm = MINPWM;
; 0000 084E                         baca_sensor();
	CALL _baca_sensor
; 0000 084F                 }
	RJMP _0x275
_0x277:
; 0000 0850 
; 0000 0851                 stop(5);
	CALL SUBOPT_0x64
; 0000 0852 
; 0000 0853                 baca_sensor();
	CALL _baca_sensor
; 0000 0854                 while(sensor<255)
_0x278:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x27A
; 0000 0855                 {
; 0000 0856                         baca_sensor();
	CALL SUBOPT_0x63
; 0000 0857                         lpwm = MINPWM;
; 0000 0858                         rpwm = MINPWM;
; 0000 0859                         rotkan();
	CALL _rotkan
; 0000 085A                 }
	RJMP _0x278
_0x27A:
; 0000 085B 
; 0000 085C                 baca_sensor();
	CALL _baca_sensor
; 0000 085D                 while(s4)
_0x27B:
	SBRS R2,4
	RJMP _0x27D
; 0000 085E                 {
; 0000 085F                         baca_sensor();
	CALL SUBOPT_0x63
; 0000 0860                         lpwm = MINPWM;
; 0000 0861                         rpwm = MINPWM;
; 0000 0862                         rotkan();
	CALL _rotkan
; 0000 0863                 }
	RJMP _0x27B
_0x27D:
; 0000 0864 
; 0000 0865                 stop(5);
	CALL SUBOPT_0x64
; 0000 0866                 goto cekpoint41;
	RJMP _0x27E
; 0000 0867         }
; 0000 0868         goto cekpoint4;
_0x274:
	RJMP _0x273
; 0000 0869 
; 0000 086A         cekpoint41:
_0x27E:
; 0000 086B 
; 0000 086C         maju();
	CALL SUBOPT_0x65
; 0000 086D         displaySensorBit();
; 0000 086E         scanBlackLine();
; 0000 086F 
; 0000 0870         if(!sKi)
	SBRC R3,1
	RJMP _0x27F
; 0000 0871         {
; 0000 0872                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 0873                 MINPWM = 100;
	CALL SUBOPT_0x6C
; 0000 0874                 while(!sKi)
_0x280:
	SBRC R3,1
	RJMP _0x282
; 0000 0875                 {
; 0000 0876                         maju();
	CALL SUBOPT_0x65
; 0000 0877                         displaySensorBit();
; 0000 0878                         scanBlackLine();
; 0000 0879                 }
	RJMP _0x280
_0x282:
; 0000 087A                 goto cekpoint42;
	RJMP _0x283
; 0000 087B         }
; 0000 087C 
; 0000 087D         goto cekpoint41;
_0x27F:
	RJMP _0x27E
; 0000 087E 
; 0000 087F         cekpoint42:
_0x283:
; 0000 0880 
; 0000 0881         maju();
	CALL SUBOPT_0x65
; 0000 0882         displaySensorBit();
; 0000 0883         scanBlackLine();
; 0000 0884         if(!sKi)
	SBRC R3,1
	RJMP _0x284
; 0000 0885         {
; 0000 0886                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 0887                 MINPWM = 110;
	CALL SUBOPT_0x72
; 0000 0888                 while(!sKi)
_0x285:
	SBRC R3,1
	RJMP _0x287
; 0000 0889                 {
; 0000 088A                         maju();
	CALL SUBOPT_0x65
; 0000 088B                         displaySensorBit();
; 0000 088C                         scanBlackLine();
; 0000 088D                 }
	RJMP _0x285
_0x287:
; 0000 088E                 goto cekpoint43;
	RJMP _0x288
; 0000 088F         }
; 0000 0890         goto cekpoint42;
_0x284:
	RJMP _0x283
; 0000 0891 
; 0000 0892         cekpoint43:
_0x288:
; 0000 0893 
; 0000 0894         maju();
	CALL SUBOPT_0x65
; 0000 0895         displaySensorBit();
; 0000 0896         scanBlackLine();
; 0000 0897         if(!sKi)
	SBRC R3,1
	RJMP _0x289
; 0000 0898         {
; 0000 0899                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 089A                 MINPWM = 120;
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x73
; 0000 089B                 while(!sKi)
_0x28A:
	SBRC R3,1
	RJMP _0x28C
; 0000 089C                 {
; 0000 089D                         maju();
	CALL SUBOPT_0x65
; 0000 089E                         displaySensorBit();
; 0000 089F                         scanBlackLine();
; 0000 08A0                 }
	RJMP _0x28A
_0x28C:
; 0000 08A1                 goto cekpoint44;
	RJMP _0x28D
; 0000 08A2         }
; 0000 08A3         goto cekpoint43;
_0x289:
	RJMP _0x288
; 0000 08A4 
; 0000 08A5         cekpoint44:
_0x28D:
; 0000 08A6 
; 0000 08A7         maju();
	CALL SUBOPT_0x65
; 0000 08A8         displaySensorBit();
; 0000 08A9         scanBlackLine();
; 0000 08AA         if(!sKi)
	SBRC R3,1
	RJMP _0x28E
; 0000 08AB         {
; 0000 08AC                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 08AD                 MINPWM = 130;
	LDI  R30,LOW(130)
	LDI  R31,HIGH(130)
	CALL SUBOPT_0x73
; 0000 08AE                 while(!sKi)
_0x28F:
	SBRC R3,1
	RJMP _0x291
; 0000 08AF                 {
; 0000 08B0                         maju();
	CALL SUBOPT_0x65
; 0000 08B1                         displaySensorBit();
; 0000 08B2                         scanBlackLine();
; 0000 08B3                 }
	RJMP _0x28F
_0x291:
; 0000 08B4                 goto cekpoint45;
	RJMP _0x292
; 0000 08B5         }
; 0000 08B6         goto cekpoint44;
_0x28E:
	RJMP _0x28D
; 0000 08B7 
; 0000 08B8         cekpoint45:
_0x292:
; 0000 08B9 
; 0000 08BA         maju();
	CALL SUBOPT_0x65
; 0000 08BB         displaySensorBit();
; 0000 08BC         scanBlackLine();
; 0000 08BD         if(!sKi)
	SBRC R3,1
	RJMP _0x293
; 0000 08BE         {
; 0000 08BF                 indikatorSudut();
	RCALL _indikatorSudut
; 0000 08C0                 MINPWM = 140;
	LDI  R30,LOW(140)
	LDI  R31,HIGH(140)
	CALL SUBOPT_0x73
; 0000 08C1                 while(!sKi)
_0x294:
	SBRC R3,1
	RJMP _0x296
; 0000 08C2                 {
; 0000 08C3                         maju();
	CALL SUBOPT_0x65
; 0000 08C4                         displaySensorBit();
; 0000 08C5                         scanBlackLine();
; 0000 08C6                 }
	RJMP _0x294
_0x296:
; 0000 08C7                 goto cekpoint5;
	RJMP _0x297
; 0000 08C8         }
; 0000 08C9         goto cekpoint45;
_0x293:
	RJMP _0x292
; 0000 08CA 
; 0000 08CB         cekpoint5:
_0x297:
; 0000 08CC         indikatorSudut();
	RCALL _indikatorSudut
; 0000 08CD }
	RET
;
;void cekPoint5a(void)
; 0000 08D0 {
_cekPoint5a:
; 0000 08D1         //cek point 5
; 0000 08D2         MINPWM = 110;
	CALL SUBOPT_0x72
; 0000 08D3         var_Kp = 11;
	CALL SUBOPT_0x6D
; 0000 08D4         var_Ki = 0;
; 0000 08D5         var_Kd = 7;
; 0000 08D6 
; 0000 08D7         cekpoint5:
_0x298:
; 0000 08D8 
; 0000 08D9         maju();
	CALL SUBOPT_0x65
; 0000 08DA         displaySensorBit();
; 0000 08DB         scanBlackLine();
; 0000 08DC         MINPWM = MINPWM + 4;
	CALL SUBOPT_0x55
	ADIW R30,4
	CALL SUBOPT_0x73
; 0000 08DD         if(sensor==255)
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x299
; 0000 08DE         {
; 0000 08DF                 rotkan();
	CALL _rotkan
; 0000 08E0                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 08E1                 stop(150);
	LDI  R30,LOW(150)
	ST   -Y,R30
	CALL _stop
; 0000 08E2                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 08E3                 goto exit;
	RJMP _0x29A
; 0000 08E4         }
; 0000 08E5         goto cekpoint5;
_0x299:
	RJMP _0x298
; 0000 08E6 
; 0000 08E7         exit:
_0x29A:
; 0000 08E8 }
	RET
;
;void cekPointFinalA(void)
; 0000 08EB {
; 0000 08EC }
;
;void strategiA(void)
; 0000 08EF {
_strategiA:
; 0000 08F0         if(NoStrategi < 2)      goto level_1a;
	CALL SUBOPT_0x74
	CPI  R30,LOW(0x2)
	BRLO _0x29C
; 0000 08F1         else if(NoStrategi < 3) goto level_2a;
	CALL SUBOPT_0x74
	CPI  R30,LOW(0x3)
	BRLO _0x29F
; 0000 08F2         else if(NoStrategi < 4) goto level_3a;
	CALL SUBOPT_0x74
	CPI  R30,LOW(0x4)
	BRSH _0x2A1
	RJMP _0x2A2
; 0000 08F3         else if(NoStrategi < 5) goto level_4a;
_0x2A1:
	CALL SUBOPT_0x74
	CPI  R30,LOW(0x5)
	BRSH _0x2A4
	RJMP _0x2A5
; 0000 08F4 
; 0000 08F5         else if(NoStrategi < 6) goto level_5a;
_0x2A4:
	CALL SUBOPT_0x74
	CPI  R30,LOW(0x6)
	BRSH _0x2A7
	RJMP _0x2A8
; 0000 08F6         else                    goto level_6a;
_0x2A7:
	RJMP _0x2AA
; 0000 08F7 
; 0000 08F8         level_1a:
_0x29C:
; 0000 08F9 
; 0000 08FA         backlight = 1;
	CALL SUBOPT_0x75
; 0000 08FB         NoStrategi = 1;
; 0000 08FC         delay_ms(50);
; 0000 08FD         lcd_clear();
	CALL SUBOPT_0x8
; 0000 08FE         lcd_gotoxy(0,0);
; 0000 08FF         lcd_putsf(" Skenario-StartA");
	__POINTW1FN _0x0,694
	CALL SUBOPT_0x5
; 0000 0900         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0901         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 0902         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0903         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0904 
; 0000 0905         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x2AD
; 0000 0906         {
; 0000 0907                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0908                 goto level_6a;
	RJMP _0x2AA
; 0000 0909         }
; 0000 090A         if(!sw_down)
_0x2AD:
	SBIC 0x10,6
	RJMP _0x2AE
; 0000 090B         {
; 0000 090C                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 090D                 goto level_2a;
	RJMP _0x29F
; 0000 090E         }
; 0000 090F         if(!sw_ok)
_0x2AE:
	SBIC 0x10,5
	RJMP _0x2AF
; 0000 0910         {
; 0000 0911                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0912                 backlight = 0;
	CBI  0x18,3
; 0000 0913 
; 0000 0914                 cekPointStarta();
	RCALL _cekPointStarta
; 0000 0915                 cekPoint1a();
	CALL SUBOPT_0x78
; 0000 0916                 cekPoint2a();
; 0000 0917                 cekPoint3a();
; 0000 0918                 cekPoint4a();
; 0000 0919                 cekPoint5a();
; 0000 091A 
; 0000 091B                 goto exit_strategi;
	RJMP _0x2B2
; 0000 091C         }
; 0000 091D         if(!sw_cancel)
_0x2AF:
	SBIC 0x10,3
	RJMP _0x2B3
; 0000 091E         {
; 0000 091F                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0920                 goto exit_strategi;
	RJMP _0x2B2
; 0000 0921         }
; 0000 0922 
; 0000 0923         goto level_1a;
_0x2B3:
	RJMP _0x29C
; 0000 0924 
; 0000 0925         level_2a:
_0x29F:
; 0000 0926 
; 0000 0927         backlight = 1;
	CALL SUBOPT_0x79
; 0000 0928         NoStrategi = 2;
; 0000 0929         delay_ms(50);
; 0000 092A         lcd_clear();
	CALL SUBOPT_0x8
; 0000 092B         lcd_gotoxy(0,0);
; 0000 092C         lcd_putsf("  Skenario-1A");
	__POINTW1FN _0x0,718
	CALL SUBOPT_0x5
; 0000 092D         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 092E         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 092F         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0930         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0931 
; 0000 0932         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x2B6
; 0000 0933         {
; 0000 0934                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0935                 goto level_1a;
	RJMP _0x29C
; 0000 0936         }
; 0000 0937         if(!sw_down)
_0x2B6:
	SBIC 0x10,6
	RJMP _0x2B7
; 0000 0938         {
; 0000 0939                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 093A                 goto level_3a;
	RJMP _0x2A2
; 0000 093B         }
; 0000 093C          if(!sw_ok)
_0x2B7:
	SBIC 0x10,5
	RJMP _0x2B8
; 0000 093D         {
; 0000 093E                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 093F                 backlight = 0;
	CBI  0x18,3
; 0000 0940 
; 0000 0941                 cekPoint1a();
	CALL SUBOPT_0x78
; 0000 0942                 cekPoint2a();
; 0000 0943                 cekPoint3a();
; 0000 0944                 cekPoint4a();
; 0000 0945                 cekPoint5a();
; 0000 0946 
; 0000 0947                 goto exit_strategi;
	RJMP _0x2B2
; 0000 0948         }
; 0000 0949         if(!sw_cancel)
_0x2B8:
	SBIC 0x10,3
	RJMP _0x2BB
; 0000 094A         {
; 0000 094B                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 094C                 goto exit_strategi;
	RJMP _0x2B2
; 0000 094D         }
; 0000 094E         goto level_2a;
_0x2BB:
	RJMP _0x29F
; 0000 094F 
; 0000 0950         level_3a:
_0x2A2:
; 0000 0951 
; 0000 0952         backlight = 1;
	CALL SUBOPT_0x7A
; 0000 0953         NoStrategi = 3;
; 0000 0954         delay_ms(50);
; 0000 0955         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0956         lcd_gotoxy(0,0);
; 0000 0957         lcd_putsf("  Skenario-2A");
	__POINTW1FN _0x0,732
	CALL SUBOPT_0x5
; 0000 0958         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0959         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 095A         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 095B         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 095C 
; 0000 095D         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x2BE
; 0000 095E         {
; 0000 095F                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0960                 goto level_2a;
	RJMP _0x29F
; 0000 0961         }
; 0000 0962         if(!sw_down)
_0x2BE:
	SBIC 0x10,6
	RJMP _0x2BF
; 0000 0963         {
; 0000 0964                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0965                 goto level_4a;
	RJMP _0x2A5
; 0000 0966         }
; 0000 0967          if(!sw_ok)
_0x2BF:
	SBIC 0x10,5
	RJMP _0x2C0
; 0000 0968         {
; 0000 0969                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 096A                 backlight = 0;
	CBI  0x18,3
; 0000 096B 
; 0000 096C                 cekPoint2a();
	RCALL _cekPoint2a
; 0000 096D                 cekPoint3a();
	CALL SUBOPT_0x7B
; 0000 096E                 cekPoint4a();
; 0000 096F                 cekPoint5a();
; 0000 0970 
; 0000 0971                 goto exit_strategi;
	RJMP _0x2B2
; 0000 0972         }
; 0000 0973         if(!sw_cancel)
_0x2C0:
	SBIC 0x10,3
	RJMP _0x2C3
; 0000 0974         {
; 0000 0975                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0976                 goto exit_strategi;
	RJMP _0x2B2
; 0000 0977         }
; 0000 0978         goto level_3a;
_0x2C3:
	RJMP _0x2A2
; 0000 0979 
; 0000 097A         level_4a:
_0x2A5:
; 0000 097B 
; 0000 097C         backlight = 1;
	CALL SUBOPT_0x7C
; 0000 097D         NoStrategi = 4;
; 0000 097E         delay_ms(50);
; 0000 097F         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0980         lcd_gotoxy(0,0);
; 0000 0981         lcd_putsf("  Skenario-3A");
	__POINTW1FN _0x0,746
	CALL SUBOPT_0x5
; 0000 0982         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0983         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 0984         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0985         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0986 
; 0000 0987         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x2C6
; 0000 0988         {
; 0000 0989                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 098A                 goto level_3a;
	RJMP _0x2A2
; 0000 098B         }
; 0000 098C         if(!sw_down)
_0x2C6:
	SBIC 0x10,6
	RJMP _0x2C7
; 0000 098D         {
; 0000 098E                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 098F                 goto level_5a;
	RJMP _0x2A8
; 0000 0990         }
; 0000 0991          if(!sw_ok)
_0x2C7:
	SBIC 0x10,5
	RJMP _0x2C8
; 0000 0992         {
; 0000 0993                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0994                 backlight = 0;
	CBI  0x18,3
; 0000 0995 
; 0000 0996                 cekPoint3a();
	CALL SUBOPT_0x7B
; 0000 0997                 cekPoint4a();
; 0000 0998                 cekPoint5a();
; 0000 0999 
; 0000 099A                 goto exit_strategi;
	RJMP _0x2B2
; 0000 099B         }
; 0000 099C         if(!sw_cancel)
_0x2C8:
	SBIC 0x10,3
	RJMP _0x2CB
; 0000 099D         {
; 0000 099E                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 099F                 goto exit_strategi;
	RJMP _0x2B2
; 0000 09A0         }
; 0000 09A1         goto level_4a;
_0x2CB:
	RJMP _0x2A5
; 0000 09A2 
; 0000 09A3         level_5a:
_0x2A8:
; 0000 09A4 
; 0000 09A5         backlight = 1;
	CALL SUBOPT_0x7D
; 0000 09A6         NoStrategi = 5;
; 0000 09A7         delay_ms(50);
; 0000 09A8         lcd_clear();
	CALL SUBOPT_0x8
; 0000 09A9         lcd_gotoxy(0,0);
; 0000 09AA         lcd_putsf("  Skenario-4A");
	__POINTW1FN _0x0,760
	CALL SUBOPT_0x5
; 0000 09AB         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 09AC         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 09AD         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 09AE         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 09AF 
; 0000 09B0         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x2CE
; 0000 09B1         {
; 0000 09B2                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 09B3                 goto level_4a;
	RJMP _0x2A5
; 0000 09B4         }
; 0000 09B5         if(!sw_down)
_0x2CE:
	SBIC 0x10,6
	RJMP _0x2CF
; 0000 09B6         {
; 0000 09B7                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 09B8                 goto level_6a;
	RJMP _0x2AA
; 0000 09B9         }
; 0000 09BA          if(!sw_ok)
_0x2CF:
	SBIC 0x10,5
	RJMP _0x2D0
; 0000 09BB         {
; 0000 09BC                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 09BD                 backlight = 0;
	CBI  0x18,3
; 0000 09BE 
; 0000 09BF                 cekPoint4a();
	RCALL _cekPoint4a
; 0000 09C0                 cekPoint5a();
	RCALL _cekPoint5a
; 0000 09C1 
; 0000 09C2                 goto exit_strategi;
	RJMP _0x2B2
; 0000 09C3         }
; 0000 09C4         if(!sw_cancel)
_0x2D0:
	SBIC 0x10,3
	RJMP _0x2D3
; 0000 09C5         {
; 0000 09C6                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 09C7                 goto exit_strategi;
	RJMP _0x2B2
; 0000 09C8         }
; 0000 09C9         goto level_5a;
_0x2D3:
	RJMP _0x2A8
; 0000 09CA 
; 0000 09CB         level_6a:
_0x2AA:
; 0000 09CC 
; 0000 09CD         backlight = 1;
	CALL SUBOPT_0x7E
; 0000 09CE         NoStrategi = 6;
; 0000 09CF         delay_ms(50);
; 0000 09D0         lcd_clear();
	CALL SUBOPT_0x8
; 0000 09D1         lcd_gotoxy(0,0);
; 0000 09D2         lcd_putsf("  Skenario-5A");
	__POINTW1FN _0x0,774
	CALL SUBOPT_0x5
; 0000 09D3         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 09D4         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 09D5         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 09D6         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 09D7 
; 0000 09D8         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x2D6
; 0000 09D9         {
; 0000 09DA                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 09DB                 goto level_5a;
	RJMP _0x2A8
; 0000 09DC         }
; 0000 09DD         if(!sw_down)
_0x2D6:
	SBIC 0x10,6
	RJMP _0x2D7
; 0000 09DE         {
; 0000 09DF                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 09E0                 goto level_1a;
	RJMP _0x29C
; 0000 09E1         }
; 0000 09E2          if(!sw_ok)
_0x2D7:
	SBIC 0x10,5
	RJMP _0x2D8
; 0000 09E3         {
; 0000 09E4                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 09E5                 backlight = 0;
	CBI  0x18,3
; 0000 09E6 
; 0000 09E7                 cekPoint5a();
	RCALL _cekPoint5a
; 0000 09E8 
; 0000 09E9                 goto exit_strategi;
	RJMP _0x2B2
; 0000 09EA         }
; 0000 09EB         if(!sw_cancel)
_0x2D8:
	SBIC 0x10,3
	RJMP _0x2DB
; 0000 09EC         {
; 0000 09ED                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 09EE                 goto exit_strategi;
	RJMP _0x2B2
; 0000 09EF         }
; 0000 09F0         goto level_6a;
_0x2DB:
	RJMP _0x2AA
; 0000 09F1 
; 0000 09F2         exit_strategi:
_0x2B2:
; 0000 09F3         lcd_clear();
	CALL _lcd_clear
; 0000 09F4         backlight = 0;
	RJMP _0x2080006
; 0000 09F5 }
;
;// strategi track B penyisihan, warna : biru , kuning
;
;void cekPointStartb(void)
; 0000 09FA {
_cekPointStartb:
; 0000 09FB         start1:
_0x2DE:
; 0000 09FC 
; 0000 09FD         maju();
	CALL SUBOPT_0x65
; 0000 09FE         displaySensorBit();
; 0000 09FF         scanBlackLine();
; 0000 0A00         if((!sKi) && (sensor==255))
	SBRC R3,1
	RJMP _0x2E0
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x2E1
_0x2E0:
	RJMP _0x2DF
_0x2E1:
; 0000 0A01         {
; 0000 0A02                 stop(5);
	CALL SUBOPT_0x64
; 0000 0A03                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 0A04 
; 0000 0A05                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x2E2:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x2E5
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x2E5
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x2E6
_0x2E5:
	RJMP _0x2E4
_0x2E6:
; 0000 0A06                 {
; 0000 0A07                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0A08                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0A09                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x69
; 0000 0A0A                         rotkan();
; 0000 0A0B                 }
	RJMP _0x2E2
_0x2E4:
; 0000 0A0C 
; 0000 0A0D                 stop(5);
	CALL SUBOPT_0x64
; 0000 0A0E                 goto cekpoint11;
	RJMP _0x2E7
; 0000 0A0F         }
; 0000 0A10         scanSudut();
_0x2DF:
	RCALL _scanSudut
; 0000 0A11         goto start1;
	RJMP _0x2DE
; 0000 0A12 
; 0000 0A13         cekpoint11:
_0x2E7:
; 0000 0A14 }
	RET
;
;void cekPoint1b(void)
; 0000 0A17 {
_cekPoint1b:
; 0000 0A18         //cek point 1
; 0000 0A19         cekpoint11:
_0x2E8:
; 0000 0A1A 
; 0000 0A1B         maju();
	CALL SUBOPT_0x65
; 0000 0A1C         displaySensorBit();
; 0000 0A1D         scanBlackLine();
; 0000 0A1E 
; 0000 0A1F         if((!sKa)&&(sensor==255))
	SBRC R3,0
	RJMP _0x2EA
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x2EB
_0x2EA:
	RJMP _0x2E9
_0x2EB:
; 0000 0A20         {
; 0000 0A21                 indikatorSudut();
	CALL SUBOPT_0x68
; 0000 0A22                 stop(5);
; 0000 0A23 
; 0000 0A24                 while(sensor==255)
_0x2EC:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x2EE
; 0000 0A25                 {
; 0000 0A26                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0A27                         lpwm=MAXPWM / 2;
	CALL SUBOPT_0x61
; 0000 0A28                         rpwm=MAXPWM / 2;
	CALL SUBOPT_0x69
; 0000 0A29                         rotkan();
; 0000 0A2A                         if(!sKi)
	SBRC R3,1
	RJMP _0x2EF
; 0000 0A2B                         {
; 0000 0A2C                                 indikatorPerempatan();
	CALL SUBOPT_0x6A
; 0000 0A2D                                 stop(5);
; 0000 0A2E 
; 0000 0A2F                                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x2F0:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x2F3
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x2F3
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x2F4
_0x2F3:
	RJMP _0x2F2
_0x2F4:
; 0000 0A30                                 {
; 0000 0A31                                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0A32                                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0A33                                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x67
; 0000 0A34                                         rotkir();
; 0000 0A35                                 }
	RJMP _0x2F0
_0x2F2:
; 0000 0A36                         }
; 0000 0A37                 }
_0x2EF:
	RJMP _0x2EC
_0x2EE:
; 0000 0A38                 stop(5);
	CALL SUBOPT_0x64
; 0000 0A39                 goto cekpoint12;
	RJMP _0x2F5
; 0000 0A3A         }
; 0000 0A3B 
; 0000 0A3C         if((!sKi)&&(sensor==255))
_0x2E9:
	SBRC R3,1
	RJMP _0x2F7
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x2F8
_0x2F7:
	RJMP _0x2F6
_0x2F8:
; 0000 0A3D         {
; 0000 0A3E                 indikatorSudut();
	CALL SUBOPT_0x68
; 0000 0A3F                 stop(5);
; 0000 0A40 
; 0000 0A41                 baca_sensor();
	CALL _baca_sensor
; 0000 0A42                 while(sensor==255)
_0x2F9:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x2FB
; 0000 0A43                 {
; 0000 0A44                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0A45                         lpwm=MAXPWM / 2;
	CALL SUBOPT_0x61
; 0000 0A46                         rpwm=MAXPWM / 2;
	CALL SUBOPT_0x67
; 0000 0A47                         rotkir();
; 0000 0A48                         if(!sKa)
	SBRC R3,0
	RJMP _0x2FC
; 0000 0A49                         {
; 0000 0A4A                                 indikatorPerempatan();
	CALL SUBOPT_0x6A
; 0000 0A4B                                 stop(5);
; 0000 0A4C 
; 0000 0A4D                                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x2FD:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x300
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x300
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x301
_0x300:
	RJMP _0x2FF
_0x301:
; 0000 0A4E                                 {
; 0000 0A4F                                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0A50                                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0A51                                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x67
; 0000 0A52                                         rotkir();
; 0000 0A53                                 }
	RJMP _0x2FD
_0x2FF:
; 0000 0A54                         }
; 0000 0A55                 }
_0x2FC:
	RJMP _0x2F9
_0x2FB:
; 0000 0A56                 stop(5);
	CALL SUBOPT_0x64
; 0000 0A57                 goto cekpoint12;
	RJMP _0x2F5
; 0000 0A58         }
; 0000 0A59         goto cekpoint11;
_0x2F6:
	RJMP _0x2E8
; 0000 0A5A 
; 0000 0A5B         cekpoint12:
_0x2F5:
; 0000 0A5C 
; 0000 0A5D         maju();
	CALL SUBOPT_0x65
; 0000 0A5E         displaySensorBit();
; 0000 0A5F         scanBlackLine();
; 0000 0A60         if((!sKa)&&(sensor==255))
	SBRC R3,0
	RJMP _0x303
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x304
_0x303:
	RJMP _0x302
_0x304:
; 0000 0A61         {
; 0000 0A62                 stop(5);
	CALL SUBOPT_0x64
; 0000 0A63                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 0A64 
; 0000 0A65                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x305:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x308
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x308
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x309
_0x308:
	RJMP _0x307
_0x309:
; 0000 0A66                 {
; 0000 0A67                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0A68                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0A69                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x69
; 0000 0A6A                         rotkan();
; 0000 0A6B                 }
	RJMP _0x305
_0x307:
; 0000 0A6C 
; 0000 0A6D                 stop(5);
	CALL SUBOPT_0x64
; 0000 0A6E                 goto cekpoint13;
	RJMP _0x30A
; 0000 0A6F         }
; 0000 0A70 
; 0000 0A71         goto cekpoint12;
_0x302:
	RJMP _0x2F5
; 0000 0A72 
; 0000 0A73         cekpoint13:
_0x30A:
; 0000 0A74 
; 0000 0A75         maju();
	CALL SUBOPT_0x65
; 0000 0A76         displaySensorBit();
; 0000 0A77         scanBlackLine();
; 0000 0A78         if((!sKa) && (sensor==255))
	SBRC R3,0
	RJMP _0x30C
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x30D
_0x30C:
	RJMP _0x30B
_0x30D:
; 0000 0A79         {
; 0000 0A7A                 stop(5);
	CALL SUBOPT_0x64
; 0000 0A7B                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 0A7C 
; 0000 0A7D                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x30E:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x311
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x311
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x312
_0x311:
	RJMP _0x310
_0x312:
; 0000 0A7E                 {
; 0000 0A7F                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0A80                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0A81                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x67
; 0000 0A82                         rotkir();
; 0000 0A83                 }
	RJMP _0x30E
_0x310:
; 0000 0A84 
; 0000 0A85                 stop(5);
	CALL SUBOPT_0x64
; 0000 0A86                 goto cekpoint14;
	RJMP _0x313
; 0000 0A87         }
; 0000 0A88         scanSudut();
_0x30B:
	RCALL _scanSudut
; 0000 0A89         goto cekpoint13;
	RJMP _0x30A
; 0000 0A8A 
; 0000 0A8B         cekpoint14:
_0x313:
; 0000 0A8C 
; 0000 0A8D         maju();
	CALL SUBOPT_0x65
; 0000 0A8E         displaySensorBit();
; 0000 0A8F         scanBlackLine();
; 0000 0A90         if((!sKi)&&(!sKa)&&(sensor<255))
	SBRC R3,1
	RJMP _0x315
	SBRC R3,0
	RJMP _0x315
	LDI  R30,LOW(255)
	CP   R6,R30
	BRLO _0x316
_0x315:
	RJMP _0x314
_0x316:
; 0000 0A91         {
; 0000 0A92                 stop(5);
	CALL SUBOPT_0x64
; 0000 0A93                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 0A94 
; 0000 0A95                 while(sensor<255)
_0x317:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x319
; 0000 0A96                 {
; 0000 0A97                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0A98                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0A99                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x69
; 0000 0A9A                         rotkan();
; 0000 0A9B                 }
	RJMP _0x317
_0x319:
; 0000 0A9C 
; 0000 0A9D                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x31A:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x31D
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x31D
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x31E
_0x31D:
	RJMP _0x31C
_0x31E:
; 0000 0A9E                 {
; 0000 0A9F                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0AA0                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0AA1                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x69
; 0000 0AA2                         rotkan();
; 0000 0AA3                 }
	RJMP _0x31A
_0x31C:
; 0000 0AA4 
; 0000 0AA5                 stop(5);
	CALL SUBOPT_0x64
; 0000 0AA6                 goto cekpoint21;
	RJMP _0x31F
; 0000 0AA7         }
; 0000 0AA8         goto cekpoint14;
_0x314:
	RJMP _0x313
; 0000 0AA9 
; 0000 0AAA         cekpoint21:
_0x31F:
; 0000 0AAB }
	RET
;
;void cekPoint2b(void)
; 0000 0AAE {
_cekPoint2b:
; 0000 0AAF         //cek point 2
; 0000 0AB0         cekpoint21:
_0x320:
; 0000 0AB1 
; 0000 0AB2         maju();
	CALL SUBOPT_0x65
; 0000 0AB3         displaySensorBit();
; 0000 0AB4         scanBlackLine();
; 0000 0AB5 
; 0000 0AB6         if((!sKa)&&(!sKi))
	SBRC R3,0
	RJMP _0x322
	SBRS R3,1
	RJMP _0x323
_0x322:
	RJMP _0x321
_0x323:
; 0000 0AB7         {
; 0000 0AB8                 while((!sKa)&&(!sKi))
_0x324:
	SBRC R3,0
	RJMP _0x327
	SBRS R3,1
	RJMP _0x328
_0x327:
	RJMP _0x326
_0x328:
; 0000 0AB9                 {
; 0000 0ABA                         maju();
	CALL SUBOPT_0x65
; 0000 0ABB                         displaySensorBit();
; 0000 0ABC                         scanBlackLine();
; 0000 0ABD                 }
	RJMP _0x324
_0x326:
; 0000 0ABE                 while((sKa)&&(sKi))
_0x329:
	SBRS R3,0
	RJMP _0x32C
	SBRC R3,1
	RJMP _0x32D
_0x32C:
	RJMP _0x32B
_0x32D:
; 0000 0ABF                 {
; 0000 0AC0                         maju();
	CALL SUBOPT_0x65
; 0000 0AC1                         displaySensorBit();
; 0000 0AC2                         scanBlackLine();
; 0000 0AC3                 }
	RJMP _0x329
_0x32B:
; 0000 0AC4                 if((!sKa)&&(!sKi))
	SBRC R3,0
	RJMP _0x32F
	SBRS R3,1
	RJMP _0x330
_0x32F:
	RJMP _0x32E
_0x330:
; 0000 0AC5                 {
; 0000 0AC6                         stop(5);
	CALL SUBOPT_0x64
; 0000 0AC7                         indikatorPerempatan();
	CALL SUBOPT_0x6B
; 0000 0AC8 
; 0000 0AC9                         baca_sensor();
; 0000 0ACA                         while(sensor<255)
_0x331:
	LDI  R30,LOW(255)
	CP   R6,R30
	BRSH _0x333
; 0000 0ACB                         {
; 0000 0ACC                                 baca_sensor();
	CALL SUBOPT_0x66
; 0000 0ACD                                 lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0ACE                                 rpwm=MAXPWM/2;
	CALL SUBOPT_0x69
; 0000 0ACF                                 rotkan();
; 0000 0AD0                         }
	RJMP _0x331
_0x333:
; 0000 0AD1 
; 0000 0AD2                         baca_sensor();
	CALL _baca_sensor
; 0000 0AD3                         while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x334:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x337
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x337
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x338
_0x337:
	RJMP _0x336
_0x338:
; 0000 0AD4                         {
; 0000 0AD5                                 baca_sensor();
	CALL SUBOPT_0x66
; 0000 0AD6                                 lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0AD7                                 rpwm=MAXPWM/2;
	CALL SUBOPT_0x69
; 0000 0AD8                                 rotkan();
; 0000 0AD9                         }
	RJMP _0x334
_0x336:
; 0000 0ADA 
; 0000 0ADB                         stop(5);
	CALL SUBOPT_0x64
; 0000 0ADC                 }
; 0000 0ADD                 goto cekpoint22;
_0x32E:
	RJMP _0x339
; 0000 0ADE         }
; 0000 0ADF         goto cekpoint21;
_0x321:
	RJMP _0x320
; 0000 0AE0 
; 0000 0AE1         cekpoint22:
_0x339:
; 0000 0AE2 
; 0000 0AE3         maju();
	CALL SUBOPT_0x65
; 0000 0AE4         displaySensorBit();
; 0000 0AE5         scanBlackLine();
; 0000 0AE6         if((!sKi)&&(sensor==255))
	SBRC R3,1
	RJMP _0x33B
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x33C
_0x33B:
	RJMP _0x33A
_0x33C:
; 0000 0AE7         {
; 0000 0AE8                 indikatorSudut();
	CALL SUBOPT_0x68
; 0000 0AE9                 stop(5);
; 0000 0AEA 
; 0000 0AEB                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 0AEC 
; 0000 0AED                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x33D:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x340
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x340
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x341
_0x340:
	RJMP _0x33F
_0x341:
; 0000 0AEE                 {
; 0000 0AEF                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0AF0                         lpwm=MAXPWM / 2;
	CALL SUBOPT_0x61
; 0000 0AF1                         rpwm=MAXPWM / 2;
	CALL SUBOPT_0x67
; 0000 0AF2                         rotkir();
; 0000 0AF3                 }
	RJMP _0x33D
_0x33F:
; 0000 0AF4                 stop(5);
	CALL SUBOPT_0x64
; 0000 0AF5                 goto exit_sudut22;
	RJMP _0x342
; 0000 0AF6         }
; 0000 0AF7 
; 0000 0AF8         if((!sKa)&&(sensor==255))
_0x33A:
	SBRC R3,0
	RJMP _0x344
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x345
_0x344:
	RJMP _0x343
_0x345:
; 0000 0AF9         {
; 0000 0AFA                 indikatorSudut();
	CALL SUBOPT_0x68
; 0000 0AFB                 stop(5);
; 0000 0AFC 
; 0000 0AFD                 baca_sensor();
	CALL _baca_sensor
; 0000 0AFE                 while(sensor==255)
_0x346:
	LDI  R30,LOW(255)
	CP   R30,R6
	BRNE _0x348
; 0000 0AFF                 {
; 0000 0B00                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0B01                         lpwm=MAXPWM / 2;
	CALL SUBOPT_0x61
; 0000 0B02                         rpwm=MAXPWM / 2;
	CALL SUBOPT_0x69
; 0000 0B03                         rotkan();
; 0000 0B04                         if((!sKi)&&(sensor==255))
	SBRC R3,1
	RJMP _0x34A
	LDI  R30,LOW(255)
	CP   R30,R6
	BREQ _0x34B
_0x34A:
	RJMP _0x349
_0x34B:
; 0000 0B05                         {
; 0000 0B06                                 stop(5);
	CALL SUBOPT_0x64
; 0000 0B07                                 indikatorPerempatan();
	CALL SUBOPT_0x6B
; 0000 0B08 
; 0000 0B09                                 baca_sensor();
; 0000 0B0A                                 while((sensor!=0b11100111)&&(sensor!=0b11101111)&&(sensor!=0b11110111))
_0x34C:
	LDI  R30,LOW(231)
	CP   R30,R6
	BREQ _0x34F
	LDI  R30,LOW(239)
	CP   R30,R6
	BREQ _0x34F
	LDI  R30,LOW(247)
	CP   R30,R6
	BRNE _0x350
_0x34F:
	RJMP _0x34E
_0x350:
; 0000 0B0B                                 {
; 0000 0B0C                                         baca_sensor();
	CALL SUBOPT_0x66
; 0000 0B0D                                         lpwm=MAXPWM/2;
	CALL SUBOPT_0x61
; 0000 0B0E                                         rpwm=MAXPWM/2;
	CALL SUBOPT_0x67
; 0000 0B0F                                         rotkir();
; 0000 0B10                                 }
	RJMP _0x34C
_0x34E:
; 0000 0B11 
; 0000 0B12                                 stop(5);
	CALL SUBOPT_0x64
; 0000 0B13                                 goto cekpoint3;
	RJMP _0x351
; 0000 0B14                         }
; 0000 0B15                 }
_0x349:
	RJMP _0x346
_0x348:
; 0000 0B16 
; 0000 0B17                 stop(5);
	CALL SUBOPT_0x64
; 0000 0B18                 goto exit_sudut22;
; 0000 0B19         }
; 0000 0B1A 
; 0000 0B1B         exit_sudut22:
_0x343:
_0x342:
; 0000 0B1C 
; 0000 0B1D         maju();
	CALL _maju
; 0000 0B1E         goto cekpoint22;
	RJMP _0x339
; 0000 0B1F 
; 0000 0B20         cekpoint3:
_0x351:
; 0000 0B21         maju();
	CALL _maju
; 0000 0B22 }
	RET
;
;void cekPoint3b(void)
; 0000 0B25 {
_cekPoint3b:
; 0000 0B26         //cek point 3
; 0000 0B27         for(;;)
_0x353:
; 0000 0B28         {
; 0000 0B29                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 0B2A         }
	RJMP _0x353
; 0000 0B2B }
;
;void cekPoint4b(void)
; 0000 0B2E {
_cekPoint4b:
; 0000 0B2F         //cek point 4
; 0000 0B30         for(;;)
_0x356:
; 0000 0B31         {
; 0000 0B32                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 0B33         }
	RJMP _0x356
; 0000 0B34 }
;
;void cekPoint5b(void)
; 0000 0B37 {
_cekPoint5b:
; 0000 0B38         //cek point 5
; 0000 0B39         for(;;)
_0x359:
; 0000 0B3A         {
; 0000 0B3B                 indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 0B3C         }
	RJMP _0x359
; 0000 0B3D }
;
;void cekPointFinalB(void)
; 0000 0B40 {
; 0000 0B41 }
;
;void strategiB(void)
; 0000 0B44 {
_strategiB:
; 0000 0B45         if(NoStrategi < 2)      goto level_1b;
	CALL SUBOPT_0x74
	CPI  R30,LOW(0x2)
	BRLO _0x35C
; 0000 0B46         else if(NoStrategi < 3) goto level_2b;
	CALL SUBOPT_0x74
	CPI  R30,LOW(0x3)
	BRLO _0x35F
; 0000 0B47         else if(NoStrategi < 4) goto level_3b;
	CALL SUBOPT_0x74
	CPI  R30,LOW(0x4)
	BRSH _0x361
	RJMP _0x362
; 0000 0B48         else if(NoStrategi < 5) goto level_4b;
_0x361:
	CALL SUBOPT_0x74
	CPI  R30,LOW(0x5)
	BRSH _0x364
	RJMP _0x365
; 0000 0B49 
; 0000 0B4A         else if(NoStrategi < 6) goto level_5b;
_0x364:
	CALL SUBOPT_0x74
	CPI  R30,LOW(0x6)
	BRSH _0x367
	RJMP _0x368
; 0000 0B4B         else                    goto level_6b;
_0x367:
	RJMP _0x36A
; 0000 0B4C 
; 0000 0B4D         level_1b:
_0x35C:
; 0000 0B4E 
; 0000 0B4F         backlight = 1;
	CALL SUBOPT_0x75
; 0000 0B50         NoStrategi = 1;
; 0000 0B51         delay_ms(50);
; 0000 0B52         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0B53         lcd_gotoxy(0,0);
; 0000 0B54         lcd_putsf(" Skenario-StartB");
	__POINTW1FN _0x0,788
	CALL SUBOPT_0x5
; 0000 0B55         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0B56         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 0B57         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0B58         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0B59 
; 0000 0B5A         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x36D
; 0000 0B5B         {
; 0000 0B5C                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0B5D                 goto level_6b;
	RJMP _0x36A
; 0000 0B5E         }
; 0000 0B5F         if(!sw_down)
_0x36D:
	SBIC 0x10,6
	RJMP _0x36E
; 0000 0B60         {
; 0000 0B61                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0B62                 goto level_2b;
	RJMP _0x35F
; 0000 0B63         }
; 0000 0B64         if(!sw_ok)
_0x36E:
	SBIC 0x10,5
	RJMP _0x36F
; 0000 0B65         {
; 0000 0B66                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0B67                 backlight = 0;
	CBI  0x18,3
; 0000 0B68 
; 0000 0B69                 cekPointStartb();
	RCALL _cekPointStartb
; 0000 0B6A                 cekPoint1b();
	CALL SUBOPT_0x7F
; 0000 0B6B                 cekPoint2b();
; 0000 0B6C                 cekPoint3b();
; 0000 0B6D                 cekPoint4b();
; 0000 0B6E                 cekPoint5b();
; 0000 0B6F 
; 0000 0B70                 goto exit_strategi;
	RJMP _0x372
; 0000 0B71         }
; 0000 0B72         if(!sw_cancel)
_0x36F:
	SBIC 0x10,3
	RJMP _0x373
; 0000 0B73         {
; 0000 0B74                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0B75                 goto exit_strategi;
	RJMP _0x372
; 0000 0B76         }
; 0000 0B77 
; 0000 0B78         goto level_1b;
_0x373:
	RJMP _0x35C
; 0000 0B79 
; 0000 0B7A         level_2b:
_0x35F:
; 0000 0B7B 
; 0000 0B7C         backlight = 1;
	CALL SUBOPT_0x79
; 0000 0B7D         NoStrategi = 2;
; 0000 0B7E         delay_ms(50);
; 0000 0B7F         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0B80         lcd_gotoxy(0,0);
; 0000 0B81         lcd_putsf("  Skenario-1B");
	__POINTW1FN _0x0,805
	CALL SUBOPT_0x5
; 0000 0B82         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0B83         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 0B84         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0B85         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0B86 
; 0000 0B87         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x376
; 0000 0B88         {
; 0000 0B89                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0B8A                 goto level_1b;
	RJMP _0x35C
; 0000 0B8B         }
; 0000 0B8C         if(!sw_down)
_0x376:
	SBIC 0x10,6
	RJMP _0x377
; 0000 0B8D         {
; 0000 0B8E                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0B8F                 goto level_3b;
	RJMP _0x362
; 0000 0B90         }
; 0000 0B91          if(!sw_ok)
_0x377:
	SBIC 0x10,5
	RJMP _0x378
; 0000 0B92         {
; 0000 0B93                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0B94                 backlight = 0;
	CBI  0x18,3
; 0000 0B95 
; 0000 0B96                 cekPoint1b();
	CALL SUBOPT_0x7F
; 0000 0B97                 cekPoint2b();
; 0000 0B98                 cekPoint3b();
; 0000 0B99                 cekPoint4b();
; 0000 0B9A                 cekPoint5b();
; 0000 0B9B 
; 0000 0B9C                 goto exit_strategi;
	RJMP _0x372
; 0000 0B9D         }
; 0000 0B9E         if(!sw_cancel)
_0x378:
	SBIC 0x10,3
	RJMP _0x37B
; 0000 0B9F         {
; 0000 0BA0                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0BA1                 goto exit_strategi;
	RJMP _0x372
; 0000 0BA2         }
; 0000 0BA3         goto level_2b;
_0x37B:
	RJMP _0x35F
; 0000 0BA4 
; 0000 0BA5         level_3b:
_0x362:
; 0000 0BA6 
; 0000 0BA7         backlight = 1;
	CALL SUBOPT_0x7A
; 0000 0BA8         NoStrategi = 3;
; 0000 0BA9         delay_ms(50);
; 0000 0BAA         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0BAB         lcd_gotoxy(0,0);
; 0000 0BAC         lcd_putsf("  Skenario-2B");
	__POINTW1FN _0x0,819
	CALL SUBOPT_0x5
; 0000 0BAD         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0BAE         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 0BAF         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0BB0         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0BB1 
; 0000 0BB2         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x37E
; 0000 0BB3         {
; 0000 0BB4                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0BB5                 goto level_2b;
	RJMP _0x35F
; 0000 0BB6         }
; 0000 0BB7         if(!sw_down)
_0x37E:
	SBIC 0x10,6
	RJMP _0x37F
; 0000 0BB8         {
; 0000 0BB9                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0BBA                 goto level_4b;
	RJMP _0x365
; 0000 0BBB         }
; 0000 0BBC          if(!sw_ok)
_0x37F:
	SBIC 0x10,5
	RJMP _0x380
; 0000 0BBD         {
; 0000 0BBE                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0BBF                 backlight = 0;
	CBI  0x18,3
; 0000 0BC0 
; 0000 0BC1                 cekPoint2b();
	RCALL _cekPoint2b
; 0000 0BC2                 cekPoint3b();
	CALL SUBOPT_0x80
; 0000 0BC3                 cekPoint4b();
; 0000 0BC4                 cekPoint5b();
; 0000 0BC5 
; 0000 0BC6                 goto exit_strategi;
	RJMP _0x372
; 0000 0BC7         }
; 0000 0BC8         if(!sw_cancel)
_0x380:
	SBIC 0x10,3
	RJMP _0x383
; 0000 0BC9         {
; 0000 0BCA                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0BCB                 goto exit_strategi;
	RJMP _0x372
; 0000 0BCC         }
; 0000 0BCD         goto level_3b;
_0x383:
	RJMP _0x362
; 0000 0BCE 
; 0000 0BCF         level_4b:
_0x365:
; 0000 0BD0 
; 0000 0BD1         backlight = 1;
	CALL SUBOPT_0x7C
; 0000 0BD2         NoStrategi = 4;
; 0000 0BD3         delay_ms(50);
; 0000 0BD4         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0BD5         lcd_gotoxy(0,0);
; 0000 0BD6         lcd_putsf("  Skenario-3B");
	__POINTW1FN _0x0,833
	CALL SUBOPT_0x5
; 0000 0BD7         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0BD8         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 0BD9         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0BDA         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0BDB 
; 0000 0BDC         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x386
; 0000 0BDD         {
; 0000 0BDE                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0BDF                 goto level_3b;
	RJMP _0x362
; 0000 0BE0         }
; 0000 0BE1         if(!sw_down)
_0x386:
	SBIC 0x10,6
	RJMP _0x387
; 0000 0BE2         {
; 0000 0BE3                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0BE4                 goto level_5b;
	RJMP _0x368
; 0000 0BE5         }
; 0000 0BE6          if(!sw_ok)
_0x387:
	SBIC 0x10,5
	RJMP _0x388
; 0000 0BE7         {
; 0000 0BE8                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0BE9                 backlight = 0;
	CBI  0x18,3
; 0000 0BEA 
; 0000 0BEB                 cekPoint3b();
	CALL SUBOPT_0x80
; 0000 0BEC                 cekPoint4b();
; 0000 0BED                 cekPoint5b();
; 0000 0BEE 
; 0000 0BEF                 goto exit_strategi;
	RJMP _0x372
; 0000 0BF0         }
; 0000 0BF1         if(!sw_cancel)
_0x388:
	SBIC 0x10,3
	RJMP _0x38B
; 0000 0BF2         {
; 0000 0BF3                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0BF4                 goto exit_strategi;
	RJMP _0x372
; 0000 0BF5         }
; 0000 0BF6         goto level_4b;
_0x38B:
	RJMP _0x365
; 0000 0BF7 
; 0000 0BF8         level_5b:
_0x368:
; 0000 0BF9 
; 0000 0BFA         backlight = 1;
	CALL SUBOPT_0x7D
; 0000 0BFB         NoStrategi = 5;
; 0000 0BFC         delay_ms(50);
; 0000 0BFD         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0BFE         lcd_gotoxy(0,0);
; 0000 0BFF         lcd_putsf("  Skenario-4B");
	__POINTW1FN _0x0,847
	CALL SUBOPT_0x5
; 0000 0C00         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0C01         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 0C02         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0C03         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0C04 
; 0000 0C05         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x38E
; 0000 0C06         {
; 0000 0C07                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0C08                 goto level_4b;
	RJMP _0x365
; 0000 0C09         }
; 0000 0C0A         if(!sw_down)
_0x38E:
	SBIC 0x10,6
	RJMP _0x38F
; 0000 0C0B         {
; 0000 0C0C                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0C0D                 goto level_6b;
	RJMP _0x36A
; 0000 0C0E         }
; 0000 0C0F          if(!sw_ok)
_0x38F:
	SBIC 0x10,5
	RJMP _0x390
; 0000 0C10         {
; 0000 0C11                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0C12                 backlight = 0;
	CBI  0x18,3
; 0000 0C13 
; 0000 0C14                 cekPoint4b();
	RCALL _cekPoint4b
; 0000 0C15                 cekPoint5b();
	RCALL _cekPoint5b
; 0000 0C16 
; 0000 0C17                 goto exit_strategi;
	RJMP _0x372
; 0000 0C18         }
; 0000 0C19         if(!sw_cancel)
_0x390:
	SBIC 0x10,3
	RJMP _0x393
; 0000 0C1A         {
; 0000 0C1B                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0C1C                 goto exit_strategi;
	RJMP _0x372
; 0000 0C1D         }
; 0000 0C1E         goto level_5b;
_0x393:
	RJMP _0x368
; 0000 0C1F 
; 0000 0C20         level_6b:
_0x36A:
; 0000 0C21 
; 0000 0C22         backlight = 1;
	CALL SUBOPT_0x7E
; 0000 0C23         NoStrategi = 6;
; 0000 0C24         delay_ms(50);
; 0000 0C25         lcd_clear();
	CALL SUBOPT_0x8
; 0000 0C26         lcd_gotoxy(0,0);
; 0000 0C27         lcd_putsf("  Skenario-5B");
	__POINTW1FN _0x0,861
	CALL SUBOPT_0x5
; 0000 0C28         lcd_gotoxy(0,1);
	CALL SUBOPT_0xA
; 0000 0C29         lcd_putsf("  OK ?");
	CALL SUBOPT_0x76
; 0000 0C2A         lcd_gotoxy(0,0);
	CALL SUBOPT_0x4
; 0000 0C2B         lcd_putchar(0);
	CALL SUBOPT_0xD
; 0000 0C2C 
; 0000 0C2D         if(!sw_up)
	SBIC 0x10,4
	RJMP _0x396
; 0000 0C2E         {
; 0000 0C2F                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0C30                 goto level_5b;
	RJMP _0x368
; 0000 0C31         }
; 0000 0C32         if(!sw_down)
_0x396:
	SBIC 0x10,6
	RJMP _0x397
; 0000 0C33         {
; 0000 0C34                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0C35                 goto level_1b;
	RJMP _0x35C
; 0000 0C36         }
; 0000 0C37          if(!sw_ok)
_0x397:
	SBIC 0x10,5
	RJMP _0x398
; 0000 0C38         {
; 0000 0C39                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0C3A                 backlight = 0;
	CBI  0x18,3
; 0000 0C3B 
; 0000 0C3C                 cekPoint5b();
	RCALL _cekPoint5b
; 0000 0C3D 
; 0000 0C3E                 goto exit_strategi;
	RJMP _0x372
; 0000 0C3F         }
; 0000 0C40         if(!sw_cancel)
_0x398:
	SBIC 0x10,3
	RJMP _0x39B
; 0000 0C41         {
; 0000 0C42                 delay_ms(250);
	CALL SUBOPT_0x77
; 0000 0C43                 goto exit_strategi;
	RJMP _0x372
; 0000 0C44         }
; 0000 0C45         goto level_6b;
_0x39B:
	RJMP _0x36A
; 0000 0C46 
; 0000 0C47         exit_strategi:
_0x372:
; 0000 0C48         lcd_clear();
	CALL _lcd_clear
; 0000 0C49         backlight = 0;
	RJMP _0x2080006
; 0000 0C4A }
;
;////////////////////////////////////////
;
;void indikatorSudut(void)
; 0000 0C4F {
_indikatorSudut:
; 0000 0C50         backlight = 1;
	RJMP _0x2080005
; 0000 0C51         delay_ms(100);
; 0000 0C52         backlight = 0;
; 0000 0C53 }
;
;void indikatorPerempatan(void)
; 0000 0C56 {
_indikatorPerempatan:
; 0000 0C57         backlight = 1;
	SBI  0x18,3
; 0000 0C58         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x53
; 0000 0C59         backlight = 0;
	CBI  0x18,3
; 0000 0C5A         delay_ms(150);
	CALL SUBOPT_0x9
; 0000 0C5B         backlight = 1;
_0x2080005:
	SBI  0x18,3
; 0000 0C5C         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x53
; 0000 0C5D         backlight = 0;
_0x2080006:
	CBI  0x18,3
; 0000 0C5E }
	RET
;
;/////////////////////////////////////
;
;void main(void)
; 0000 0C63 {
_main:
; 0000 0C64         PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0C65         DDRA=0x00;
	OUT  0x1A,R30
; 0000 0C66         PORTB=0x00;
	OUT  0x18,R30
; 0000 0C67         DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0C68         PORTC=0x03;
	LDI  R30,LOW(3)
	OUT  0x15,R30
; 0000 0C69         DDRC=0xFC;
	LDI  R30,LOW(252)
	OUT  0x14,R30
; 0000 0C6A         PORTD=0x78;
	LDI  R30,LOW(120)
	OUT  0x12,R30
; 0000 0C6B         DDRD=0x00;
	LDI  R30,LOW(0)
	OUT  0x11,R30
; 0000 0C6C 
; 0000 0C6D         TCCR0=0x04;
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 0C6E         TCNT0=0xFF;
	LDI  R30,LOW(255)
	OUT  0x32,R30
; 0000 0C6F         OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 0C70 
; 0000 0C71         TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
; 0000 0C72 
; 0000 0C73         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0C74         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0C75 
; 0000 0C76         ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 0C77         ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 0C78 
; 0000 0C79         lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 0C7A         define_char(char0,0);
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _define_char
; 0000 0C7B 
; 0000 0C7C         indikatorSudut();
	RCALL _indikatorSudut
; 0000 0C7D         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x53
; 0000 0C7E         backlight = 1;
	SBI  0x18,3
; 0000 0C7F 
; 0000 0C80         stop(1);
	CALL SUBOPT_0x81
; 0000 0C81         TCCR0=0x04;
	LDI  R30,LOW(4)
	OUT  0x33,R30
; 0000 0C82         #asm("sei")
	sei
; 0000 0C83 
; 0000 0C84         showMenu();
	CALL _showMenu
; 0000 0C85         backlight = 0;
	CBI  0x18,3
; 0000 0C86 
; 0000 0C87         var_Kp  = Kp;
	CALL SUBOPT_0xF
	LDI  R31,0
	CALL SUBOPT_0x70
; 0000 0C88         var_Ki  = Ki;
	CALL SUBOPT_0x11
	CALL SUBOPT_0x82
; 0000 0C89         var_Kd  = Kd;
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL SUBOPT_0x83
	CALL SUBOPT_0x71
; 0000 0C8A 
; 0000 0C8B         tempKp = Kp;
	CALL SUBOPT_0xF
	LDI  R26,LOW(_tempKp)
	LDI  R27,HIGH(_tempKp)
	CALL __EEPROMWRB
; 0000 0C8C         tempKd = Ki;
	CALL SUBOPT_0x11
	LDI  R26,LOW(_tempKd)
	LDI  R27,HIGH(_tempKd)
	CALL __EEPROMWRB
; 0000 0C8D         tempKi = Ki;
	CALL SUBOPT_0x11
	LDI  R26,LOW(_tempKi)
	LDI  R27,HIGH(_tempKi)
	CALL __EEPROMWRB
; 0000 0C8E 
; 0000 0C8F         MAXPWM = (int)MAXSpeed;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL SUBOPT_0x83
	STS  _MAXPWM,R30
	STS  _MAXPWM+1,R31
; 0000 0C90         MINPWM = MINSpeed;
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x83
	CALL SUBOPT_0x73
; 0000 0C91 
; 0000 0C92         intervalPWM = (MAXSpeed - MINSpeed) / 8;
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL __EEPROMRDB
	MOV  R0,R30
	CLR  R1
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL SUBOPT_0x83
	MOVW R26,R0
	SUB  R26,R30
	SBC  R27,R31
	CALL SUBOPT_0x5C
; 0000 0C93         PV = 0;
	LDI  R30,LOW(0)
	STS  _PV,R30
	STS  _PV+1,R30
; 0000 0C94         error = 0;
	STS  _error,R30
	STS  _error+1,R30
; 0000 0C95         last_error = 0;
	STS  _last_error,R30
	STS  _last_error+1,R30
; 0000 0C96 
; 0000 0C97         delay_ms(200);
	CALL SUBOPT_0x7
; 0000 0C98         indikatorPerempatan();
	RCALL _indikatorPerempatan
; 0000 0C99 
; 0000 0C9A         maju();
	CALL _maju
; 0000 0C9B 
; 0000 0C9C         while (1)
_0x3AE:
; 0000 0C9D         {
; 0000 0C9E                 displaySensorBit();
	CALL _displaySensorBit
; 0000 0C9F                 scanBlackLine();
	CALL _scanBlackLine
; 0000 0CA0                 scanSudut();
	RCALL _scanSudut
; 0000 0CA1 
; 0000 0CA2                 // strategi track A
; 0000 0CA3                 if(!sw_up)      // interupsi
	SBIC 0x10,4
	RJMP _0x3B1
; 0000 0CA4                 {
; 0000 0CA5                         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0CA6                         stop(1);
	CALL SUBOPT_0x81
; 0000 0CA7                         lcd_clear();
	CALL _lcd_clear
; 0000 0CA8                         strategiA();
	RCALL _strategiA
; 0000 0CA9                         goto exitRobot;
	RJMP _0x3B2
; 0000 0CAA                 }
; 0000 0CAB 
; 0000 0CAC                 // strategi track B
; 0000 0CAD                 if(!sw_down)    // interupsi
_0x3B1:
	SBIC 0x10,6
	RJMP _0x3B3
; 0000 0CAE                 {
; 0000 0CAF                         delay_ms(125);
	CALL SUBOPT_0xC
; 0000 0CB0                         stop(1);
	CALL SUBOPT_0x81
; 0000 0CB1                         lcd_clear();
	CALL _lcd_clear
; 0000 0CB2                         strategiB();
	RCALL _strategiB
; 0000 0CB3                         goto exitRobot;
	RJMP _0x3B2
; 0000 0CB4                 }
; 0000 0CB5         };
_0x3B3:
	RJMP _0x3AE
; 0000 0CB6 
; 0000 0CB7         var_Kp = tempKp;
; 0000 0CB8         var_Ki = tempKi;
; 0000 0CB9         var_Kd = tempKd;
; 0000 0CBA 
; 0000 0CBB         exitRobot:
_0x3B2:
; 0000 0CBC         goto exitRobot;
	RJMP _0x3B2
; 0000 0CBD }
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
	CALL SUBOPT_0x31
	SBIW R30,1
	LDD  R26,Y+4
	STD  Z+0,R26
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	TST  R31
	BRMI _0x2000014
	CALL SUBOPT_0x31
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
	CALL SUBOPT_0x84
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x84
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
	CALL SUBOPT_0x85
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x86
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x85
	CALL SUBOPT_0x87
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x85
	CALL SUBOPT_0x87
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
	CALL SUBOPT_0x85
	CALL SUBOPT_0x88
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
	CALL SUBOPT_0x85
	CALL SUBOPT_0x88
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
	CALL SUBOPT_0x84
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
	CALL SUBOPT_0x84
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
	CALL SUBOPT_0x86
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x84
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
	CALL SUBOPT_0x86
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
	CALL SUBOPT_0x89
	SBIW R30,0
	BRNE _0x2000072
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	RJMP _0x2080004
_0x2000072:
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	MOVW R16,R26
	CALL SUBOPT_0x89
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
_0x2080004:
	CALL __LOADLOCR4
	ADIW R28,10
	POP  R15
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

	.DSEG

	.CSEG
__lcd_write_nibble_G101:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2020004
	SBI  0x18,4
	RJMP _0x2020005
_0x2020004:
	CBI  0x18,4
_0x2020005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2020006
	SBI  0x18,5
	RJMP _0x2020007
_0x2020006:
	CBI  0x18,5
_0x2020007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2020008
	SBI  0x18,6
	RJMP _0x2020009
_0x2020008:
	CBI  0x18,6
_0x2020009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x202000A
	SBI  0x18,7
	RJMP _0x202000B
_0x202000A:
	CBI  0x18,7
_0x202000B:
	__DELAY_USB 8
	SBI  0x18,2
	__DELAY_USB 20
	CBI  0x18,2
	__DELAY_USB 20
	RJMP _0x2080001
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
	__DELAY_USB 200
	RJMP _0x2080001
_lcd_write_byte:
	LDD  R30,Y+1
	ST   -Y,R30
	RCALL __lcd_write_data
	CALL SUBOPT_0x8A
	RJMP _0x2080003
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
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
_0x2080003:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x8B
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x8B
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2020011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2020010
_0x2020011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2020013
	RJMP _0x2080001
_0x2020013:
_0x2020010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	CALL SUBOPT_0x8A
	RJMP _0x2080001
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
	RJMP _0x2080002
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
_0x2080002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,6
	SBI  0x17,7
	SBI  0x17,2
	SBI  0x17,0
	SBI  0x17,1
	CBI  0x18,2
	CBI  0x18,0
	CBI  0x18,1
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G101,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G101,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x53
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8C
	CALL SUBOPT_0x8C
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G101
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
	.BYTE 0x20
_adc6:
	.BYTE 0x1
_adc7:
	.BYTE 0x1
_xcount:
	.BYTE 0x1
_SP:
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
_MV:
	.BYTE 0x2
_P:
	.BYTE 0x2
_I:
	.BYTE 0x2
_D:
	.BYTE 0x2
_PV:
	.BYTE 0x2
_error:
	.BYTE 0x2
_last_error:
	.BYTE 0x2
_rate:
	.BYTE 0x2
_var_Kp:
	.BYTE 0x2
_var_Ki:
	.BYTE 0x2
_var_Kd:
	.BYTE 0x2

	.ESEG
_Kp:
	.DB  0x11
_Ki:
	.DB  0x0
_Kd:
	.DB  0xB
_tempKp:
	.DB  0x11
_tempKi:
	.DB  0x0
_tempKd:
	.DB  0xB
_MAXSpeed:
	.DB  0xFF
_MINSpeed:
	.DB  0x69
_WarnaGaris:
	.DB  0x1
_SensLine:
	.DB  0x2
_Skenario:
	.DB  0x2
_Mode:
	.DB  0x1
_NoStrategi:
	.DB  0x1
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
	.DB  0x7
_ba7:
	.DB  0x7
_ba6:
	.DB  0x7
_ba5:
	.DB  0x7
_ba4:
	.DB  0x7
_ba3:
	.DB  0x7
_ba2:
	.DB  0x7
_ba1:
	.DB  0x7
_ba0:
	.DB  0x7
_bb7:
	.DB  0xC8
_bb6:
	.DB  0xC8
_bb5:
	.DB  0xC8
_bb4:
	.DB  0xC8
_bb3:
	.DB  0xC8
_bb2:
	.DB  0xC8
_bb1:
	.DB  0xC8
_bb0:
	.DB  0xC8

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
;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x0:
	LDS  R30,_lpwm
	LDS  R31,_lpwm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	LDS  R26,_xcount
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2:
	LDS  R30,_rpwm
	LDS  R31,_rpwm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x3:
	CALL __DIVW21
	MOV  R17,R30
	SUBI R17,-LOW(48)
	ST   -Y,R17
	CALL _lcd_putchar
	LDD  R26,Y+1
	CLR  R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 50 TIMES, CODE SIZE REDUCTION:193 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 72 TIMES, CODE SIZE REDUCTION:139 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:41 WORDS
SUBOPT_0x6:
	LDI  R31,0
	CPI  R30,LOW(0x1)
	LDI  R26,HIGH(0x1)
	CPC  R31,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x8:
	CALL _lcd_clear
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:113 WORDS
SUBOPT_0xA:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 18 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(32)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x10:
	ST   -Y,R30
	CALL _tampil
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	CALL __EEPROMRDB
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0xD

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x14:
	CALL _setByte
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x15:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x16:
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x17:
	__POINTW1FN _0x0,377
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x18:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:114 WORDS
SUBOPT_0x1B:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(7)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(6)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	LDI  R30,LOW(5)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x24:
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x25:
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(_bt2)
	LDI  R27,HIGH(_bt2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x27:
	LDI  R26,LOW(_bt3)
	LDI  R27,HIGH(_bt3)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x28:
	LDI  R26,LOW(_bt4)
	LDI  R27,HIGH(_bt4)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x29:
	LDI  R26,LOW(_bt5)
	LDI  R27,HIGH(_bt5)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2A:
	LDI  R26,LOW(_bt6)
	LDI  R27,HIGH(_bt6)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDI  R26,LOW(_bt7)
	LDI  R27,HIGH(_bt7)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2C:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x2D:
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2E:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2F:
	LDI  R30,LOW(0)
	STS  _rpwm,R30
	STS  _rpwm+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x30:
	LDI  R30,LOW(0)
	STS  _lpwm,R30
	STS  _lpwm+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x31:
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x32:
	__POINTW1FN _0x0,489
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x0
	CALL __CWD1
	CALL __PUTPARD1
	RCALL SUBOPT_0x2
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:77 WORDS
SUBOPT_0x33:
	ST   -Y,R17
	ST   -Y,R16
	LDI  R26,LOW(_ba7)
	LDI  R27,HIGH(_ba7)
	LDI  R30,LOW(7)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba6)
	LDI  R27,HIGH(_ba6)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba5)
	LDI  R27,HIGH(_ba5)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba4)
	LDI  R27,HIGH(_ba4)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba3)
	LDI  R27,HIGH(_ba3)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba2)
	LDI  R27,HIGH(_ba2)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba1)
	LDI  R27,HIGH(_ba1)
	CALL __EEPROMWRB
	LDI  R26,LOW(_ba0)
	LDI  R27,HIGH(_ba0)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb7)
	LDI  R27,HIGH(_bb7)
	LDI  R30,LOW(200)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb6)
	LDI  R27,HIGH(_bb6)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb5)
	LDI  R27,HIGH(_bb5)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb4)
	LDI  R27,HIGH(_bb4)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb3)
	LDI  R27,HIGH(_bb3)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb2)
	LDI  R27,HIGH(_bb2)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb1)
	LDI  R27,HIGH(_bb1)
	CALL __EEPROMWRB
	LDI  R26,LOW(_bb0)
	LDI  R27,HIGH(_bb0)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x34:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb0)
	LDI  R27,HIGH(_bb0)
	CALL __EEPROMRDB
	MOVW R26,R16
	LDI  R31,0
	CP   R26,R30
	CPC  R27,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x35:
	LDI  R26,LOW(_ba0)
	LDI  R27,HIGH(_ba0)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x36:
	MOVW R26,R16
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x37:
	LDI  R26,LOW(_bb0)
	LDI  R27,HIGH(_bb0)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0x38:
	LDI  R31,0
	MOVW R26,R0
	ADD  R26,R30
	ADC  R27,R31
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x39:
	CALL __EEPROMWRB
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3A:
	__POINTW1FN _0x0,528
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x3B:
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RJMP SUBOPT_0x19

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	CALL _lcd_puts
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3D:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb1)
	LDI  R27,HIGH(_bb1)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3E:
	LDI  R26,LOW(_ba1)
	LDI  R27,HIGH(_ba1)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3F:
	LDI  R26,LOW(_bb1)
	LDI  R27,HIGH(_bb1)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x40:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb2)
	LDI  R27,HIGH(_bb2)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x41:
	LDI  R26,LOW(_ba2)
	LDI  R27,HIGH(_ba2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	LDI  R26,LOW(_bb2)
	LDI  R27,HIGH(_bb2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x43:
	CALL _lcd_puts
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb3)
	LDI  R27,HIGH(_bb3)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x45:
	LDI  R26,LOW(_ba3)
	LDI  R27,HIGH(_ba3)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x46:
	LDI  R26,LOW(_bb3)
	LDI  R27,HIGH(_bb3)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x47:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb4)
	LDI  R27,HIGH(_bb4)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x48:
	LDI  R26,LOW(_ba4)
	LDI  R27,HIGH(_ba4)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x49:
	LDI  R26,LOW(_bb4)
	LDI  R27,HIGH(_bb4)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb5)
	LDI  R27,HIGH(_bb5)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	LDI  R26,LOW(_ba5)
	LDI  R27,HIGH(_ba5)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	LDI  R26,LOW(_bb5)
	LDI  R27,HIGH(_bb5)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4D:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb6)
	LDI  R27,HIGH(_bb6)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4E:
	LDI  R26,LOW(_ba6)
	LDI  R27,HIGH(_ba6)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	LDI  R26,LOW(_bb6)
	LDI  R27,HIGH(_bb6)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_bb7)
	LDI  R27,HIGH(_bb7)
	CALL __EEPROMRDB
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	LDI  R26,LOW(_ba7)
	LDI  R27,HIGH(_ba7)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x52:
	LDI  R26,LOW(_bb7)
	LDI  R27,HIGH(_bb7)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 68 TIMES, CODE SIZE REDUCTION:131 WORDS
SUBOPT_0x53:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x54:
	STS  _PV,R30
	STS  _PV+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:63 WORDS
SUBOPT_0x55:
	LDS  R30,_MINPWM
	LDS  R31,_MINPWM+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:117 WORDS
SUBOPT_0x56:
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RCALL SUBOPT_0x55
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x57:
	LDS  R26,_PV
	LDS  R27,_PV+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x58:
	RCALL SUBOPT_0x55
	RJMP SUBOPT_0x56

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x59:
	LDS  R30,_error
	LDS  R31,_error+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x5A:
	CALL __MULW12
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5B:
	LDS  R26,_MINPWM
	LDS  R27,_MINPWM+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x5C:
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL __DIVW21
	STS  _intervalPWM,R30
	STS  _intervalPWM+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0x5D:
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 32 TIMES, CODE SIZE REDUCTION:59 WORDS
SUBOPT_0x5E:
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5F:
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 60 TIMES, CODE SIZE REDUCTION:351 WORDS
SUBOPT_0x60:
	LDS  R26,_MAXPWM
	LDS  R27,_MAXPWM+1
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 30 TIMES, CODE SIZE REDUCTION:55 WORDS
SUBOPT_0x61:
	RCALL SUBOPT_0x5E
	RJMP SUBOPT_0x60

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x62:
	CALL _indikatorSudut
	JMP  _baca_sensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x63:
	CALL _baca_sensor
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 55 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x64:
	LDI  R30,LOW(5)
	ST   -Y,R30
	JMP  _stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 39 TIMES, CODE SIZE REDUCTION:149 WORDS
SUBOPT_0x65:
	CALL _maju
	CALL _displaySensorBit
	JMP  _scanBlackLine

;OPTIMIZER ADDED SUBROUTINE, CALLED 28 TIMES, CODE SIZE REDUCTION:51 WORDS
SUBOPT_0x66:
	CALL _baca_sensor
	RJMP SUBOPT_0x60

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x67:
	RCALL SUBOPT_0x5D
	JMP  _rotkir

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x68:
	CALL _indikatorSudut
	RJMP SUBOPT_0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x69:
	RCALL SUBOPT_0x5D
	JMP  _rotkan

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6A:
	CALL _indikatorPerempatan
	RJMP SUBOPT_0x64

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6B:
	CALL _indikatorPerempatan
	JMP  _baca_sensor

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x6C:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x6D:
	LDI  R30,LOW(11)
	LDI  R31,HIGH(11)
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
	LDI  R30,LOW(0)
	STS  _var_Ki,R30
	STS  _var_Ki+1,R30
	LDI  R30,LOW(7)
	LDI  R31,HIGH(7)
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6E:
	CALL _mundur
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x6F:
	CALL _rotkir
	RJMP SUBOPT_0x58

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x70:
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x71:
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x72:
	LDI  R30,LOW(110)
	LDI  R31,HIGH(110)
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x73:
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x74:
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x75:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x76:
	__POINTW1FN _0x0,711
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 48 TIMES, CODE SIZE REDUCTION:91 WORDS
SUBOPT_0x77:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x78:
	CALL _cekPoint1a
	CALL _cekPoint2a
	CALL _cekPoint3a
	CALL _cekPoint4a
	JMP  _cekPoint5a

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x79:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(2)
	CALL __EEPROMWRB
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7A:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(3)
	CALL __EEPROMWRB
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7B:
	CALL _cekPoint3a
	CALL _cekPoint4a
	JMP  _cekPoint5a

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7C:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(4)
	CALL __EEPROMWRB
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7D:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(5)
	CALL __EEPROMWRB
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7E:
	SBI  0x18,3
	LDI  R26,LOW(_NoStrategi)
	LDI  R27,HIGH(_NoStrategi)
	LDI  R30,LOW(6)
	CALL __EEPROMWRB
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7F:
	CALL _cekPoint1b
	CALL _cekPoint2b
	CALL _cekPoint3b
	CALL _cekPoint4b
	JMP  _cekPoint5b

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x80:
	CALL _cekPoint3b
	CALL _cekPoint4b
	JMP  _cekPoint5b

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x81:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _stop

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x82:
	LDI  R31,0
	STS  _var_Ki,R30
	STS  _var_Ki+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x83:
	CALL __EEPROMRDB
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x84:
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
SUBOPT_0x85:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x86:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x87:
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
SUBOPT_0x88:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x89:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8A:
	SBI  0x18,0
	LD   R30,Y
	ST   -Y,R30
	CALL __lcd_write_data
	CBI  0x18,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8B:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x53

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8C:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G101
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
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
