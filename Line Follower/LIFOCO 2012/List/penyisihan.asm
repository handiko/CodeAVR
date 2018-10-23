
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
	.DEF _kp=R5
	.DEF _kd=R4
	.DEF _lines=R7
	.DEF _speed=R6
	.DEF _start=R9
	.DEF _hi1=R8
	.DEF _hi2=R11
	.DEF _hi3=R10
	.DEF _hi4=R13
	.DEF _hi5=R12

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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x20,0x20,0x20,0x20,0x73,0x74,0x61,0x72
	.DB  0x74,0x3F,0x0,0x20,0x20,0x73,0x63,0x61
	.DB  0x6E,0x6E,0x69,0x6E,0x67,0x2E,0x2E,0x2E
	.DB  0x0,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x0
	.DB  0x20,0x20,0x20,0x70,0x72,0x6F,0x73,0x65
	.DB  0x73,0x2E,0x2E,0x2E,0x0,0x20,0x20,0x73
	.DB  0x63,0x61,0x6E,0x6E,0x69,0x6E,0x67,0x0
	.DB  0x20,0x20,0x73,0x65,0x6C,0x65,0x73,0x61
	.DB  0x69,0x21,0x0,0x53,0x70,0x65,0x65,0x64
	.DB  0x31,0x3D,0x25,0x64,0x0,0x4C,0x65,0x76
	.DB  0x65,0x6C,0x3D,0x25,0x64,0x0,0x50,0x3D
	.DB  0x25,0x64,0x0,0x44,0x3D,0x25,0x64,0x0
	.DB  0x61,0x75,0x74,0x6F,0x20,0x73,0x63,0x61
	.DB  0x6E,0x2E,0x2E,0x3F,0x0,0x62,0x61,0x63
	.DB  0x61,0x20,0x73,0x65,0x6E,0x73,0x6F,0x72
	.DB  0x2E,0x2E,0x3F,0x0,0x73,0x74,0x61,0x72
	.DB  0x74,0x3D,0x25,0x64,0x0,0x20,0x20,0x20
	.DB  0x4B,0x41,0x4D,0x41,0x42,0x52,0x4F,0x54
	.DB  0x4F,0x21,0x20,0x20,0x20,0x0,0x20,0x20
	.DB  0x20,0x20,0x4A,0x54,0x46,0x20,0x20,0x55
	.DB  0x47,0x4D,0x20,0x20,0x20,0x20,0x0
_0x2040003:
	.DB  0x80,0xC0
_0x20A0060:
	.DB  0x1
_0x20A0000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x02
	.DW  __base_y_G102
	.DW  _0x2040003*2

	.DW  0x01
	.DW  __seed_G105
	.DW  _0x20A0060*2

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
;/*
;program punya agus, arep, sohib
;*/
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
;#include <stdio.h>
;#include <delay.h>
;#include <math.h>
;#include <alcd.h>
;
;#define enter   PINC.2
;#define back    PINC.1
;#define plus    PINC.0
;#define minus   PIND.7
;#define dir_ki   PORTD.3
;#define dir_ka   PORTD.6
;#define pwm_ki   OCR1B
;#define pwm_ka   OCR1A
;#define ADC_VREF_TYPE 0x20
;
;unsigned char kp,kd,lines,speed,start;
;//unsigned char hi[8],lo[8],ref[8];
;unsigned char hi1,hi2,hi3,hi4,hi5,hi6,hi7,hi8;
;unsigned char lo1,lo2,lo3,lo4,lo5,lo6,lo7,lo8;
;unsigned char ref1,ref2,ref3,ref4,ref5,ref6,ref7,ref8;
;char buf[33];
;int error,error_lalu;
;int level,select;
;
;eeprom unsigned char ekp=50,ekd=50,espeed=255,estart=1; //,eref[8]={255,255,255,255,255,255,255,255};
;eeprom unsigned char eref1=255;
;eeprom unsigned char eref2=255;
;eeprom unsigned char eref3=255;
;eeprom unsigned char eref4=255;
;eeprom unsigned char eref5=255;
;eeprom unsigned char eref6=255;
;eeprom unsigned char eref7=255;
;eeprom unsigned char eref8=255;
;eeprom int elevel=50;
;
;unsigned char read_adc(unsigned char adc_input)
; 0000 0029 {

	.CSEG
_read_adc:
; 0000 002A ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 002B delay_us(10);
	__DELAY_USB 40
; 0000 002C ADCSRA|=0x40;
	SBI  0x6,6
; 0000 002D while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 002E ADCSRA|=0x10;
	SBI  0x6,4
; 0000 002F return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
; 0000 0030 }
;
;void set_motor(int L, int R){
; 0000 0032 void set_motor(int L, int R){
_set_motor:
; 0000 0033  if (R<0){
;	L -> Y+2
;	R -> Y+0
	LDD  R26,Y+1
	TST  R26
	BRPL _0x6
; 0000 0034 
; 0000 0035  dir_ka=0;
	CBI  0x12,6
; 0000 0036  pwm_ka=255+R;
	LD   R30,Y
	LDD  R31,Y+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0037   if(R<-150){R=-150;}
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0xFF6A)
	LDI  R30,HIGH(0xFF6A)
	CPC  R27,R30
	BRGE _0x9
	LDI  R30,LOW(65386)
	LDI  R31,HIGH(65386)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0038  }
_0x9:
; 0000 0039 
; 0000 003A  if (L<0){
_0x6:
	LDD  R26,Y+3
	TST  R26
	BRPL _0xA
; 0000 003B 
; 0000 003C  dir_ki=0;
	CBI  0x12,3
; 0000 003D  pwm_ki=255+L;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	SUBI R30,LOW(-255)
	SBCI R31,HIGH(-255)
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 003E  if(L<-150){L=-150;}
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0xFF6A)
	LDI  R30,HIGH(0xFF6A)
	CPC  R27,R30
	BRGE _0xD
	LDI  R30,LOW(65386)
	LDI  R31,HIGH(65386)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 003F  }
_0xD:
; 0000 0040 
; 0000 0041  if (R>=0){
_0xA:
	LDD  R26,Y+1
	TST  R26
	BRMI _0xE
; 0000 0042 
; 0000 0043  dir_ka=1;
	SBI  0x12,6
; 0000 0044  pwm_ka=R;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0000 0045  if(R>255){R=255;}
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x11
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	ST   Y,R30
	STD  Y+1,R31
; 0000 0046  }
_0x11:
; 0000 0047 
; 0000 0048  if (L>=0){
_0xE:
	LDD  R26,Y+3
	TST  R26
	BRMI _0x12
; 0000 0049 
; 0000 004A  dir_ki=1;
	SBI  0x12,3
; 0000 004B  pwm_ki=L;
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	OUT  0x28+1,R31
	OUT  0x28,R30
; 0000 004C  if(L>255){L=255;}
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CPI  R26,LOW(0x100)
	LDI  R30,HIGH(0x100)
	CPC  R27,R30
	BRLT _0x15
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	STD  Y+2,R30
	STD  Y+2+1,R31
; 0000 004D 
; 0000 004E }
_0x15:
; 0000 004F }
_0x12:
	RJMP _0x20C0004
;
;
;void baca()            // scan sensor 8
; 0000 0053 {
_baca:
; 0000 0054 while(1){
_0x16:
; 0000 0055 lcd_clear();
	CALL _lcd_clear
; 0000 0056 lines=0;
	CLR  R7
; 0000 0057 
; 0000 0058         lcd_gotoxy(4,0);
	LDI  R30,LOW(4)
	CALL SUBOPT_0x0
; 0000 0059         if(read_adc(0)>ref1){
	CALL SUBOPT_0x1
	MOV  R26,R30
	LDS  R30,_ref1
	CP   R30,R26
	BRSH _0x19
; 0000 005A         lcd_putchar('1');
	LDI  R30,LOW(49)
	RJMP _0x6C
; 0000 005B         }
; 0000 005C         else lcd_putchar('0');
_0x19:
	LDI  R30,LOW(48)
_0x6C:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 005D 
; 0000 005E         lcd_gotoxy(5,0);
	LDI  R30,LOW(5)
	CALL SUBOPT_0x0
; 0000 005F         if(read_adc(1)>ref2){
	CALL SUBOPT_0x2
	MOV  R26,R30
	LDS  R30,_ref2
	CP   R30,R26
	BRSH _0x1B
; 0000 0060         lcd_putchar('1');
	LDI  R30,LOW(49)
	RJMP _0x6D
; 0000 0061         }
; 0000 0062         else lcd_putchar('0');
_0x1B:
	LDI  R30,LOW(48)
_0x6D:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0063 
; 0000 0064         lcd_gotoxy(6,0);
	LDI  R30,LOW(6)
	CALL SUBOPT_0x0
; 0000 0065         if(read_adc(2)>ref3){
	CALL SUBOPT_0x3
	MOV  R26,R30
	LDS  R30,_ref3
	CP   R30,R26
	BRSH _0x1D
; 0000 0066         lcd_putchar('1');
	LDI  R30,LOW(49)
	RJMP _0x6E
; 0000 0067         }
; 0000 0068         else lcd_putchar('0');
_0x1D:
	LDI  R30,LOW(48)
_0x6E:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0069 
; 0000 006A         lcd_gotoxy(7,0);
	LDI  R30,LOW(7)
	CALL SUBOPT_0x0
; 0000 006B         if(read_adc(3)>ref4){
	CALL SUBOPT_0x4
	MOV  R26,R30
	LDS  R30,_ref4
	CP   R30,R26
	BRSH _0x1F
; 0000 006C         lcd_putchar('1');
	LDI  R30,LOW(49)
	RJMP _0x6F
; 0000 006D         }
; 0000 006E         else lcd_putchar('0');
_0x1F:
	LDI  R30,LOW(48)
_0x6F:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 006F 
; 0000 0070         lcd_gotoxy(8,0);
	LDI  R30,LOW(8)
	CALL SUBOPT_0x0
; 0000 0071         if(read_adc(4)>ref5){
	CALL SUBOPT_0x5
	MOV  R26,R30
	LDS  R30,_ref5
	CP   R30,R26
	BRSH _0x21
; 0000 0072         lcd_putchar('1');
	LDI  R30,LOW(49)
	RJMP _0x70
; 0000 0073         }
; 0000 0074         else lcd_putchar('0');
_0x21:
	LDI  R30,LOW(48)
_0x70:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0075 
; 0000 0076         lcd_gotoxy(9,0);
	LDI  R30,LOW(9)
	CALL SUBOPT_0x0
; 0000 0077         if(read_adc(5)>ref6){
	CALL SUBOPT_0x6
	MOV  R26,R30
	LDS  R30,_ref6
	CP   R30,R26
	BRSH _0x23
; 0000 0078         lcd_putchar('1');
	LDI  R30,LOW(49)
	RJMP _0x71
; 0000 0079         }
; 0000 007A         else lcd_putchar('0');
_0x23:
	LDI  R30,LOW(48)
_0x71:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 007B 
; 0000 007C         lcd_gotoxy(10,0);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x0
; 0000 007D         if(read_adc(6)>ref7){
	CALL SUBOPT_0x7
	MOV  R26,R30
	LDS  R30,_ref7
	CP   R30,R26
	BRSH _0x25
; 0000 007E         lcd_putchar('1');
	LDI  R30,LOW(49)
	RJMP _0x72
; 0000 007F         }
; 0000 0080         else lcd_putchar('0');
_0x25:
	LDI  R30,LOW(48)
_0x72:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0081 
; 0000 0082         lcd_gotoxy(11,0);
	LDI  R30,LOW(11)
	CALL SUBOPT_0x0
; 0000 0083         if(read_adc(7)>ref8){
	CALL SUBOPT_0x8
	MOV  R26,R30
	LDS  R30,_ref8
	CP   R30,R26
	BRSH _0x27
; 0000 0084         lcd_putchar('1');
	LDI  R30,LOW(49)
	RJMP _0x73
; 0000 0085         }
; 0000 0086         else lcd_putchar('0');
_0x27:
	LDI  R30,LOW(48)
_0x73:
	ST   -Y,R30
	CALL _lcd_putchar
; 0000 0087 
; 0000 0088         delay_ms(3);
	CALL SUBOPT_0x9
; 0000 0089 }
	RJMP _0x16
; 0000 008A }
;
;void auto_scan(){
; 0000 008C void auto_scan(){
_auto_scan:
; 0000 008D unsigned char data,i;
; 0000 008E 
; 0000 008F lcd_clear();
	ST   -Y,R17
	ST   -Y,R16
;	data -> R17
;	i -> R16
	CALL SUBOPT_0xA
; 0000 0090 lcd_gotoxy(0,0);
; 0000 0091 lcd_putsf("    start?");
	__POINTW1FN _0x0,0
	CALL SUBOPT_0xB
; 0000 0092 lcd_gotoxy(0,1);
	CALL SUBOPT_0xC
; 0000 0093 lcd_putsf("  scanning...");
	__POINTW1FN _0x0,11
	CALL SUBOPT_0xB
; 0000 0094 delay_ms(300);
	CALL SUBOPT_0xD
; 0000 0095 for(;;) {
_0x2A:
; 0000 0096 if(!back) {
	SBIC 0x13,1
	RJMP _0x2C
; 0000 0097 delay_ms(100);
	CALL SUBOPT_0xE
; 0000 0098 break;}
	RJMP _0x2B
; 0000 0099 }
_0x2C:
	RJMP _0x2A
_0x2B:
; 0000 009A lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x0
; 0000 009B lcd_putsf("              ");
	__POINTW1FN _0x0,25
	CALL SUBOPT_0xB
; 0000 009C delay_ms(100);
	CALL SUBOPT_0xE
; 0000 009D lcd_gotoxy(0,0);
	LDI  R30,LOW(0)
	CALL SUBOPT_0x0
; 0000 009E lcd_putsf("   proses...");
	__POINTW1FN _0x0,40
	CALL SUBOPT_0xB
; 0000 009F 
; 0000 00A0 hi1=read_adc(0);
	CALL SUBOPT_0x1
	MOV  R8,R30
; 0000 00A1 hi2=read_adc(1);
	CALL SUBOPT_0x2
	MOV  R11,R30
; 0000 00A2 hi3=read_adc(2);
	CALL SUBOPT_0x3
	MOV  R10,R30
; 0000 00A3 hi4=read_adc(3);
	CALL SUBOPT_0x4
	MOV  R13,R30
; 0000 00A4 hi5=read_adc(4);
	CALL SUBOPT_0x5
	MOV  R12,R30
; 0000 00A5 hi6=read_adc(5);
	CALL SUBOPT_0x6
	STS  _hi6,R30
; 0000 00A6 hi7=read_adc(6);
	CALL SUBOPT_0x7
	STS  _hi7,R30
; 0000 00A7 hi8=read_adc(7);
	CALL SUBOPT_0x8
	STS  _hi8,R30
; 0000 00A8 lo1=read_adc(0);
	CALL SUBOPT_0x1
	STS  _lo1,R30
; 0000 00A9 lo2=read_adc(1);
	CALL SUBOPT_0x2
	STS  _lo2,R30
; 0000 00AA lo3=read_adc(2);
	CALL SUBOPT_0x3
	STS  _lo3,R30
; 0000 00AB lo4=read_adc(3);
	CALL SUBOPT_0x4
	STS  _lo4,R30
; 0000 00AC lo5=read_adc(4);
	CALL SUBOPT_0x5
	STS  _lo5,R30
; 0000 00AD lo6=read_adc(5);
	CALL SUBOPT_0x6
	STS  _lo6,R30
; 0000 00AE lo7=read_adc(6);
	CALL SUBOPT_0x7
	STS  _lo7,R30
; 0000 00AF lo8=read_adc(7);
	CALL SUBOPT_0x8
	STS  _lo8,R30
; 0000 00B0 
; 0000 00B1 do {
_0x2E:
; 0000 00B2 if(read_adc(0)>hi1){hi1=read_adc(0);}
	CALL SUBOPT_0x1
	CP   R8,R30
	BRSH _0x30
	CALL SUBOPT_0x1
	MOV  R8,R30
; 0000 00B3 if(read_adc(1)>hi2){hi2=read_adc(1);}
_0x30:
	CALL SUBOPT_0x2
	CP   R11,R30
	BRSH _0x31
	CALL SUBOPT_0x2
	MOV  R11,R30
; 0000 00B4 if(read_adc(2)>hi3){hi3=read_adc(2);}
_0x31:
	CALL SUBOPT_0x3
	CP   R10,R30
	BRSH _0x32
	CALL SUBOPT_0x3
	MOV  R10,R30
; 0000 00B5 if(read_adc(3)>hi4){hi4=read_adc(3);}
_0x32:
	CALL SUBOPT_0x4
	CP   R13,R30
	BRSH _0x33
	CALL SUBOPT_0x4
	MOV  R13,R30
; 0000 00B6 if(read_adc(4)>hi5){hi5=read_adc(4);}
_0x33:
	CALL SUBOPT_0x5
	CP   R12,R30
	BRSH _0x34
	CALL SUBOPT_0x5
	MOV  R12,R30
; 0000 00B7 if(read_adc(5)>hi6){hi6=read_adc(5);}
_0x34:
	CALL SUBOPT_0x6
	MOV  R26,R30
	LDS  R30,_hi6
	CP   R30,R26
	BRSH _0x35
	CALL SUBOPT_0x6
	STS  _hi6,R30
; 0000 00B8 if(read_adc(6)>hi7){hi7=read_adc(6);}
_0x35:
	CALL SUBOPT_0x7
	MOV  R26,R30
	LDS  R30,_hi7
	CP   R30,R26
	BRSH _0x36
	CALL SUBOPT_0x7
	STS  _hi7,R30
; 0000 00B9 if(read_adc(7)>hi8){hi8=read_adc(7);}
_0x36:
	CALL SUBOPT_0x8
	MOV  R26,R30
	LDS  R30,_hi8
	CP   R30,R26
	BRSH _0x37
	CALL SUBOPT_0x8
	STS  _hi8,R30
; 0000 00BA if(read_adc(0)<lo1){lo1=read_adc(0);}
_0x37:
	CALL SUBOPT_0x1
	MOV  R26,R30
	LDS  R30,_lo1
	CP   R26,R30
	BRSH _0x38
	CALL SUBOPT_0x1
	STS  _lo1,R30
; 0000 00BB if(read_adc(1)<lo2){lo2=read_adc(1);}
_0x38:
	CALL SUBOPT_0x2
	MOV  R26,R30
	LDS  R30,_lo2
	CP   R26,R30
	BRSH _0x39
	CALL SUBOPT_0x2
	STS  _lo2,R30
; 0000 00BC if(read_adc(2)<lo3){lo3=read_adc(2);}
_0x39:
	CALL SUBOPT_0x3
	MOV  R26,R30
	LDS  R30,_lo3
	CP   R26,R30
	BRSH _0x3A
	CALL SUBOPT_0x3
	STS  _lo3,R30
; 0000 00BD if(read_adc(3)<lo4){lo4=read_adc(3);}
_0x3A:
	CALL SUBOPT_0x4
	MOV  R26,R30
	LDS  R30,_lo4
	CP   R26,R30
	BRSH _0x3B
	CALL SUBOPT_0x4
	STS  _lo4,R30
; 0000 00BE if(read_adc(4)<lo5){lo5=read_adc(4);}
_0x3B:
	CALL SUBOPT_0x5
	MOV  R26,R30
	LDS  R30,_lo5
	CP   R26,R30
	BRSH _0x3C
	CALL SUBOPT_0x5
	STS  _lo5,R30
; 0000 00BF if(read_adc(5)<lo6){lo6=read_adc(5);}
_0x3C:
	CALL SUBOPT_0x6
	MOV  R26,R30
	LDS  R30,_lo6
	CP   R26,R30
	BRSH _0x3D
	CALL SUBOPT_0x6
	STS  _lo6,R30
; 0000 00C0 if(read_adc(6)<lo7){lo7=read_adc(6);}
_0x3D:
	CALL SUBOPT_0x7
	MOV  R26,R30
	LDS  R30,_lo7
	CP   R26,R30
	BRSH _0x3E
	CALL SUBOPT_0x7
	STS  _lo7,R30
; 0000 00C1 if(read_adc(7)<lo8){lo8=read_adc(7);}
_0x3E:
	CALL SUBOPT_0x8
	MOV  R26,R30
	LDS  R30,_lo8
	CP   R26,R30
	BRSH _0x3F
	CALL SUBOPT_0x8
	STS  _lo8,R30
; 0000 00C2 delay_ms(1);
_0x3F:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0xF
; 0000 00C3 }
; 0000 00C4 while(!back);
	SBIS 0x13,1
	RJMP _0x2E
; 0000 00C5 delay_ms(100);
	CALL SUBOPT_0xE
; 0000 00C6 goto ref;
; 0000 00C7 
; 0000 00C8 ref:
; 0000 00C9 delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0xF
; 0000 00CA ref1=hi1+lo1;
	LDS  R30,_lo1
	ADD  R30,R8
	STS  _ref1,R30
; 0000 00CB ref2=hi2+lo2;
	LDS  R30,_lo2
	ADD  R30,R11
	STS  _ref2,R30
; 0000 00CC ref3=hi3+lo3;
	LDS  R30,_lo3
	ADD  R30,R10
	STS  _ref3,R30
; 0000 00CD ref4=hi4+lo4;
	LDS  R30,_lo4
	ADD  R30,R13
	STS  _ref4,R30
; 0000 00CE ref5=hi5+lo5;
	LDS  R30,_lo5
	ADD  R30,R12
	STS  _ref5,R30
; 0000 00CF ref6=hi6+lo6;
	LDS  R30,_lo6
	LDS  R26,_hi6
	ADD  R30,R26
	STS  _ref6,R30
; 0000 00D0 ref7=hi7+lo7;
	LDS  R30,_lo7
	LDS  R26,_hi7
	ADD  R30,R26
	STS  _ref7,R30
; 0000 00D1 ref8=hi8+lo8;
	LDS  R30,_lo8
	LDS  R26,_hi8
	ADD  R30,R26
	STS  _ref8,R30
; 0000 00D2 
; 0000 00D3 ref1=ref1/2;
	LDS  R26,_ref1
	CALL SUBOPT_0x10
	STS  _ref1,R30
; 0000 00D4 ref2=ref2/2;
	LDS  R26,_ref2
	CALL SUBOPT_0x10
	STS  _ref2,R30
; 0000 00D5 ref3=ref3/2;
	LDS  R26,_ref3
	CALL SUBOPT_0x10
	STS  _ref3,R30
; 0000 00D6 ref4=ref4/2;
	LDS  R26,_ref4
	CALL SUBOPT_0x10
	STS  _ref4,R30
; 0000 00D7 ref5=ref5/2;
	LDS  R26,_ref5
	CALL SUBOPT_0x10
	STS  _ref5,R30
; 0000 00D8 ref6=ref6/2;
	LDS  R26,_ref6
	CALL SUBOPT_0x10
	STS  _ref6,R30
; 0000 00D9 ref7=ref7/2;
	LDS  R26,_ref7
	CALL SUBOPT_0x10
	STS  _ref7,R30
; 0000 00DA ref8=ref8/2;
	LDS  R26,_ref8
	CALL SUBOPT_0x10
	STS  _ref8,R30
; 0000 00DB 
; 0000 00DC eref1=ref1;
	LDS  R30,_ref1
	LDI  R26,LOW(_eref1)
	LDI  R27,HIGH(_eref1)
	CALL __EEPROMWRB
; 0000 00DD eref2=ref2;
	LDS  R30,_ref2
	LDI  R26,LOW(_eref2)
	LDI  R27,HIGH(_eref2)
	CALL __EEPROMWRB
; 0000 00DE eref3=ref3;
	LDS  R30,_ref3
	LDI  R26,LOW(_eref3)
	LDI  R27,HIGH(_eref3)
	CALL __EEPROMWRB
; 0000 00DF eref4=ref4;
	LDS  R30,_ref4
	LDI  R26,LOW(_eref4)
	LDI  R27,HIGH(_eref4)
	CALL __EEPROMWRB
; 0000 00E0 eref5=ref5;
	LDS  R30,_ref5
	LDI  R26,LOW(_eref5)
	LDI  R27,HIGH(_eref5)
	CALL __EEPROMWRB
; 0000 00E1 eref6=ref6;
	LDS  R30,_ref6
	LDI  R26,LOW(_eref6)
	LDI  R27,HIGH(_eref6)
	CALL __EEPROMWRB
; 0000 00E2 eref7=ref7;
	LDS  R30,_ref7
	LDI  R26,LOW(_eref7)
	LDI  R27,HIGH(_eref7)
	CALL __EEPROMWRB
; 0000 00E3 eref8=ref8;
	LDS  R30,_ref8
	LDI  R26,LOW(_eref8)
	LDI  R27,HIGH(_eref8)
	CALL __EEPROMWRB
; 0000 00E4 //eref1=ref1;
; 0000 00E5 
; 0000 00E6 lcd_clear();
	CALL SUBOPT_0xA
; 0000 00E7 lcd_gotoxy(0,0);
; 0000 00E8 lcd_putsf("  scanning");
	__POINTW1FN _0x0,53
	CALL SUBOPT_0xB
; 0000 00E9 lcd_gotoxy(0,1);
	CALL SUBOPT_0xC
; 0000 00EA lcd_putsf("  selesai!");
	__POINTW1FN _0x0,64
	CALL SUBOPT_0xB
; 0000 00EB delay_ms(300);
	CALL SUBOPT_0xD
; 0000 00EC baca();
	RCALL _baca
; 0000 00ED }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void set()
; 0000 00F0 {
_set:
; 0000 00F1 unsigned char n=1;
; 0000 00F2 while(1){
	ST   -Y,R17
;	n -> R17
	LDI  R17,1
_0x41:
; 0000 00F3 delay_ms(120);
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0xF
; 0000 00F4 
; 0000 00F5         if(!back){         //plus=up minus=down enter=ok back=cancel
	SBIS 0x13,1
; 0000 00F6         n=n+1;
	SUBI R17,-LOW(1)
; 0000 00F7         }
; 0000 00F8         if(n>7){
	CPI  R17,8
	BRLO _0x45
; 0000 00F9         n=1;
	LDI  R17,LOW(1)
; 0000 00FA         }
; 0000 00FB 
; 0000 00FC         if(n==0){
_0x45:
	CPI  R17,0
	BRNE _0x46
; 0000 00FD         n=7;
	LDI  R17,LOW(7)
; 0000 00FE         }
; 0000 00FF 
; 0000 0100 /////////////////////////////////////////////////////////////////mulai set
; 0000 0101 
; 0000 0102           if(n==2){
_0x46:
	CPI  R17,2
	BRNE _0x47
; 0000 0103           lcd_clear();
	CALL SUBOPT_0xA
; 0000 0104           lcd_gotoxy(0,0);
; 0000 0105           sprintf(buf,"Speed1=%d",speed);
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,75
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R6
	CALL SUBOPT_0x12
; 0000 0106           lcd_puts(buf);
	CALL _lcd_puts
; 0000 0107                         if(!plus){
	SBIS 0x13,0
; 0000 0108                                 speed=speed+1;
	INC  R6
; 0000 0109 
; 0000 010A                         }
; 0000 010B                         if(!minus){
	SBIC 0x10,7
	RJMP _0x49
; 0000 010C                                 speed=speed-1;
	MOV  R30,R6
	CALL SUBOPT_0x13
	MOV  R6,R30
; 0000 010D 
; 0000 010E                 }
; 0000 010F                 }
_0x49:
; 0000 0110 
; 0000 0111           if(n==1){
_0x47:
	CPI  R17,1
	BRNE _0x4A
; 0000 0112           lcd_clear();
	CALL SUBOPT_0xA
; 0000 0113           lcd_gotoxy(0,0);
; 0000 0114           sprintf(buf,"Level=%d",level);
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,85
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x14
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
; 0000 0115           lcd_puts(buf);
	CALL SUBOPT_0x11
	CALL _lcd_puts
; 0000 0116                         if(!plus){
	SBIC 0x13,0
	RJMP _0x4B
; 0000 0117                                 level=level+1;
	CALL SUBOPT_0x15
; 0000 0118                         }
; 0000 0119                         if(!min){
_0x4B:
	LDI  R30,LOW(_min)
	LDI  R31,HIGH(_min)
	SBIW R30,0
	BRNE _0x4C
; 0000 011A                                 level=level-1;
	CALL SUBOPT_0x14
	SBIW R30,1
	STS  _level,R30
	STS  _level+1,R31
; 0000 011B                         }
; 0000 011C           }
_0x4C:
; 0000 011D 
; 0000 011E           if(n==3){
_0x4A:
	CPI  R17,3
	BRNE _0x4D
; 0000 011F           lcd_clear();
	CALL SUBOPT_0xA
; 0000 0120           lcd_gotoxy(0,0);
; 0000 0121           sprintf(buf,"P=%d",kp);
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,94
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R5
	CALL SUBOPT_0x12
; 0000 0122           lcd_puts(buf);
	CALL _lcd_puts
; 0000 0123 
; 0000 0124                         if(!plus){
	SBIS 0x13,0
; 0000 0125 
; 0000 0126                                kp=kp+1;
	INC  R5
; 0000 0127                         }
; 0000 0128                         if(!min){
	LDI  R30,LOW(_min)
	LDI  R31,HIGH(_min)
	SBIW R30,0
	BRNE _0x4F
; 0000 0129 
; 0000 012A                                kp=kp-1;
	MOV  R30,R5
	CALL SUBOPT_0x13
	MOV  R5,R30
; 0000 012B                 }
; 0000 012C                 }
_0x4F:
; 0000 012D 
; 0000 012E            if(n==4){
_0x4D:
	CPI  R17,4
	BRNE _0x50
; 0000 012F                 lcd_clear();
	CALL SUBOPT_0xA
; 0000 0130                 lcd_gotoxy(0,0);
; 0000 0131                 sprintf(buf,"D=%d", kd);
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,99
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R4
	CALL SUBOPT_0x12
; 0000 0132                 lcd_puts(buf);
	CALL _lcd_puts
; 0000 0133                         if(!plus){
	SBIS 0x13,0
; 0000 0134                                 kd=kd+1;
	INC  R4
; 0000 0135 
; 0000 0136                         }
; 0000 0137                         if(!min){
	LDI  R30,LOW(_min)
	LDI  R31,HIGH(_min)
	SBIW R30,0
	BRNE _0x52
; 0000 0138                                 kd=kd-1;
	MOV  R30,R4
	CALL SUBOPT_0x13
	MOV  R4,R30
; 0000 0139                 }
; 0000 013A                 }
_0x52:
; 0000 013B 
; 0000 013C           if(n==5){
_0x50:
	CPI  R17,5
	BRNE _0x53
; 0000 013D                 lcd_clear();
	CALL SUBOPT_0xA
; 0000 013E                 lcd_gotoxy(0,0);
; 0000 013F                 lcd_putsf("auto scan..?");
	__POINTW1FN _0x0,104
	CALL SUBOPT_0xB
; 0000 0140                         if(!plus){
	SBIS 0x13,0
; 0000 0141                                 auto_scan();
	RCALL _auto_scan
; 0000 0142                 }
; 0000 0143                 }
; 0000 0144 
; 0000 0145           if(n==6){
_0x53:
	CPI  R17,6
	BRNE _0x55
; 0000 0146                 lcd_clear();
	CALL SUBOPT_0xA
; 0000 0147                 lcd_gotoxy(0,0);
; 0000 0148                 lcd_putsf("baca sensor..?");
	__POINTW1FN _0x0,117
	CALL SUBOPT_0xB
; 0000 0149                 if(!plus)
	SBIS 0x13,0
; 0000 014A                         {
; 0000 014B                         baca();
	RCALL _baca
; 0000 014C                         }
; 0000 014D           }
; 0000 014E 
; 0000 014F            if(n==7){
_0x55:
	CPI  R17,7
	BRNE _0x57
; 0000 0150            lcd_clear();
	CALL SUBOPT_0xA
; 0000 0151                         lcd_gotoxy(0,0);
; 0000 0152                         sprintf(buf,"start=%d",start);
	CALL SUBOPT_0x11
	__POINTW1FN _0x0,132
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R9
	CALL SUBOPT_0x12
; 0000 0153                         lcd_puts(buf);
	CALL _lcd_puts
; 0000 0154                         if(!plus){
	SBIC 0x13,0
	RJMP _0x58
; 0000 0155                                 start=start+1;
	INC  R9
; 0000 0156                                 if(start>3)(start=1)  ;
	LDI  R30,LOW(3)
	CP   R30,R9
	BRSH _0x59
	LDI  R30,LOW(1)
	MOV  R9,R30
; 0000 0157                         }
_0x59:
; 0000 0158                         if(!min){
_0x58:
	LDI  R30,LOW(_min)
	LDI  R31,HIGH(_min)
	SBIW R30,0
	BRNE _0x5A
; 0000 0159                                 start=start-1;
	MOV  R30,R9
	CALL SUBOPT_0x13
	MOV  R9,R30
; 0000 015A                                 if(start<1)(start=3) ;
	LDI  R30,LOW(1)
	CP   R9,R30
	BRSH _0x5B
	LDI  R30,LOW(3)
	MOV  R9,R30
; 0000 015B                 }
_0x5B:
; 0000 015C                 }
_0x5A:
; 0000 015D 
; 0000 015E 
; 0000 015F          if(!enter)     //running plann
_0x57:
	SBIC 0x13,2
	RJMP _0x5C
; 0000 0160          {
; 0000 0161 
; 0000 0162                 if(speed!=espeed){
	LDI  R26,LOW(_espeed)
	LDI  R27,HIGH(_espeed)
	CALL __EEPROMRDB
	CP   R30,R6
	BREQ _0x5D
; 0000 0163                         espeed=speed;
	MOV  R30,R6
	LDI  R26,LOW(_espeed)
	LDI  R27,HIGH(_espeed)
	CALL __EEPROMWRB
; 0000 0164                 }
; 0000 0165                 if(kp!=ekp){
_0x5D:
	LDI  R26,LOW(_ekp)
	LDI  R27,HIGH(_ekp)
	CALL __EEPROMRDB
	CP   R30,R5
	BREQ _0x5E
; 0000 0166                         ekp=kp;
	MOV  R30,R5
	LDI  R26,LOW(_ekp)
	LDI  R27,HIGH(_ekp)
	CALL __EEPROMWRB
; 0000 0167                 }
; 0000 0168                 if(kd!=ekd){
_0x5E:
	LDI  R26,LOW(_ekd)
	LDI  R27,HIGH(_ekd)
	CALL __EEPROMRDB
	CP   R30,R4
	BREQ _0x5F
; 0000 0169                        ekd=kd;
	MOV  R30,R4
	LDI  R26,LOW(_ekd)
	LDI  R27,HIGH(_ekd)
	CALL __EEPROMWRB
; 0000 016A                 }
; 0000 016B                 if(start!=estart){
_0x5F:
	LDI  R26,LOW(_estart)
	LDI  R27,HIGH(_estart)
	CALL __EEPROMRDB
	CP   R30,R9
	BREQ _0x60
; 0000 016C                         estart=start;
	MOV  R30,R9
	LDI  R26,LOW(_estart)
	LDI  R27,HIGH(_estart)
	CALL __EEPROMWRB
; 0000 016D                 }
; 0000 016E                 if(level!=elevel){
_0x60:
	LDI  R26,LOW(_elevel)
	LDI  R27,HIGH(_elevel)
	CALL __EEPROMRDW
	LDS  R26,_level
	LDS  R27,_level+1
	CP   R30,R26
	CPC  R31,R27
	BREQ _0x61
; 0000 016F                         elevel=level;
	CALL SUBOPT_0x14
	LDI  R26,LOW(_elevel)
	LDI  R27,HIGH(_elevel)
	CALL __EEPROMWRW
; 0000 0170                 }
; 0000 0171 
; 0000 0172                  break;
_0x61:
	RJMP _0x43
; 0000 0173 
; 0000 0174 
; 0000 0175          }
; 0000 0176         }
_0x5C:
	RJMP _0x41
_0x43:
; 0000 0177 }
	LD   R17,Y+
	RET
;
;void set_simpang(){
; 0000 0179 void set_simpang(){
_set_simpang:
; 0000 017A level=level+1;
	CALL SUBOPT_0x15
; 0000 017B         if(level==1){
	LDS  R26,_level
	LDS  R27,_level+1
	SBIW R26,1
; 0000 017C         }
; 0000 017D }
	RET
;
;void baca_garis()        // baca sensornya
; 0000 0180 {
_baca_garis:
; 0000 0181 int L,R;
; 0000 0182 if(lines==0b00011000||lines==0b00010000||lines==0b00001000){
	CALL __SAVELOCR4
;	L -> R16,R17
;	R -> R18,R19
	LDI  R30,LOW(24)
	CP   R30,R7
	BREQ _0x64
	LDI  R30,LOW(16)
	CP   R30,R7
	BREQ _0x64
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0x63
_0x64:
; 0000 0183         set_motor(90,90);
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
; 0000 0184 }
; 0000 0185 if(lines==0b10000000){
_0x63:
	LDI  R30,LOW(128)
	CP   R30,R7
	BRNE _0x66
; 0000 0186         set_motor(-70,70);
	LDI  R30,LOW(65466)
	LDI  R31,HIGH(65466)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x16
; 0000 0187 }
; 0000 0188 if(lines==0b00000001){
_0x66:
	LDI  R30,LOW(1)
	CP   R30,R7
	BRNE _0x67
; 0000 0189         set_motor(70,-70);
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(65466)
	LDI  R31,HIGH(65466)
	CALL SUBOPT_0x16
; 0000 018A }
; 0000 018B }
_0x67:
	CALL __LOADLOCR4
_0x20C0004:
	ADIW R28,4
	RET
;
;void main(){
; 0000 018D void main(){
_main:
; 0000 018E PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 018F DDRA=0x00;
	OUT  0x1A,R30
; 0000 0190 PORTB=0x00;
	OUT  0x18,R30
; 0000 0191 DDRB=0x7F;
	LDI  R30,LOW(127)
	OUT  0x17,R30
; 0000 0192 PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0193 DDRC=0x00;
	OUT  0x14,R30
; 0000 0194 PORTD=0x00;
	OUT  0x12,R30
; 0000 0195 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
; 0000 0196 TCCR1A=0xA1;
	LDI  R30,LOW(161)
	OUT  0x2F,R30
; 0000 0197 TCCR1B=0x03;
	LDI  R30,LOW(3)
	OUT  0x2E,R30
; 0000 0198 
; 0000 0199 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
; 0000 019A 
; 0000 019B kp=ekp;
	LDI  R26,LOW(_ekp)
	LDI  R27,HIGH(_ekp)
	CALL __EEPROMRDB
	MOV  R5,R30
; 0000 019C kd=ekd;
	LDI  R26,LOW(_ekd)
	LDI  R27,HIGH(_ekd)
	CALL __EEPROMRDB
	MOV  R4,R30
; 0000 019D level=elevel;
	LDI  R26,LOW(_elevel)
	LDI  R27,HIGH(_elevel)
	CALL __EEPROMRDW
	STS  _level,R30
	STS  _level+1,R31
; 0000 019E speed=espeed;
	LDI  R26,LOW(_espeed)
	LDI  R27,HIGH(_espeed)
	CALL __EEPROMRDB
	MOV  R6,R30
; 0000 019F 
; 0000 01A0 lcd_clear();
	CALL SUBOPT_0xA
; 0000 01A1 lcd_gotoxy(0,0);
; 0000 01A2 lcd_putsf("   KAMABROTO!   ");
	__POINTW1FN _0x0,141
	CALL SUBOPT_0xB
; 0000 01A3 lcd_gotoxy(0,1);
	CALL SUBOPT_0xC
; 0000 01A4 lcd_putsf("    JTF  UGM    ");
	__POINTW1FN _0x0,158
	CALL SUBOPT_0xB
; 0000 01A5 delay_ms(300);
	CALL SUBOPT_0xD
; 0000 01A6 
; 0000 01A7 set();
	RCALL _set
; 0000 01A8 #asm("sei");
	sei
; 0000 01A9 while(1)
_0x68:
; 0000 01AA         {
; 0000 01AB                 baca_garis();
	RCALL _baca_garis
; 0000 01AC                 set_simpang();
	RCALL _set_simpang
; 0000 01AD         }
	RJMP _0x68
; 0000 01AE }
_0x6B:
	RJMP _0x6B
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
	BRMI _0x2000014
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
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
	CALL SUBOPT_0x17
_0x200001E:
	RJMP _0x200001B
_0x200001C:
	CPI  R30,LOW(0x1)
	BRNE _0x200001F
	CPI  R18,37
	BRNE _0x2000020
	CALL SUBOPT_0x17
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
	CALL SUBOPT_0x18
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	LDD  R26,Z+4
	ST   -Y,R26
	CALL SUBOPT_0x19
	RJMP _0x2000030
_0x200002F:
	CPI  R30,LOW(0x73)
	BRNE _0x2000032
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
	CALL _strlen
	MOV  R17,R30
	RJMP _0x2000033
_0x2000032:
	CPI  R30,LOW(0x70)
	BRNE _0x2000035
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1A
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
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
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
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1B
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
	CALL SUBOPT_0x17
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
	CALL SUBOPT_0x17
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
	CALL SUBOPT_0x19
	CPI  R21,0
	BREQ _0x200006B
	SUBI R21,LOW(1)
_0x200006B:
_0x200006A:
_0x2000069:
_0x2000061:
	CALL SUBOPT_0x17
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
	CALL SUBOPT_0x19
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
	CALL SUBOPT_0x1C
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
	CALL SUBOPT_0x1C
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
_min:
    ld   r26,y+
    ld   r27,y+
    ld   r30,y+
    ld   r31,y+
    cp   r30,r26
    cpc  r31,r27
    brlt __min0
    movw r30,r26
__min0:
    ret
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
__lcd_write_nibble_G102:
	LD   R30,Y
	ANDI R30,LOW(0x10)
	BREQ _0x2040004
	SBI  0x18,2
	RJMP _0x2040005
_0x2040004:
	CBI  0x18,2
_0x2040005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2040006
	SBI  0x18,3
	RJMP _0x2040007
_0x2040006:
	CBI  0x18,3
_0x2040007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2040008
	SBI  0x18,4
	RJMP _0x2040009
_0x2040008:
	CBI  0x18,4
_0x2040009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x204000A
	SBI  0x18,5
	RJMP _0x204000B
_0x204000A:
	CBI  0x18,5
_0x204000B:
	__DELAY_USB 8
	SBI  0x18,1
	__DELAY_USB 20
	CBI  0x18,1
	__DELAY_USB 20
	RJMP _0x20C0001
__lcd_write_data:
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
    ld    r30,y
    swap  r30
    st    y,r30
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
	__DELAY_USB 200
	RJMP _0x20C0001
_lcd_gotoxy:
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G102)
	SBCI R31,HIGH(-__base_y_G102)
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
	ST   -Y,R30
	RCALL __lcd_write_data
	CALL SUBOPT_0x9
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL __lcd_write_data
	CALL SUBOPT_0x9
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2040011
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R26,R30
	BRLO _0x2040010
_0x2040011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	ST   -Y,R30
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2040013
	RJMP _0x20C0001
_0x2040013:
_0x2040010:
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	SBI  0x18,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x18,0
	RJMP _0x20C0001
_lcd_puts:
	ST   -Y,R17
_0x2040014:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040014
_0x2040016:
	RJMP _0x20C0002
_lcd_putsf:
	ST   -Y,R17
_0x2040017:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2040019
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2040017
_0x2040019:
_0x20C0002:
	LDD  R17,Y+0
	ADIW R28,3
	RET
_lcd_init:
	SBI  0x17,2
	SBI  0x17,3
	SBI  0x17,4
	SBI  0x17,5
	SBI  0x17,1
	SBI  0x17,0
	SBI  0x17,6
	CBI  0x18,1
	CBI  0x18,0
	CBI  0x18,6
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G102,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G102,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0xF
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x1D
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G102
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

	.CSEG

	.DSEG

	.CSEG

	.DSEG
_hi6:
	.BYTE 0x1
_hi7:
	.BYTE 0x1
_hi8:
	.BYTE 0x1
_lo1:
	.BYTE 0x1
_lo2:
	.BYTE 0x1
_lo3:
	.BYTE 0x1
_lo4:
	.BYTE 0x1
_lo5:
	.BYTE 0x1
_lo6:
	.BYTE 0x1
_lo7:
	.BYTE 0x1
_lo8:
	.BYTE 0x1
_ref1:
	.BYTE 0x1
_ref2:
	.BYTE 0x1
_ref3:
	.BYTE 0x1
_ref4:
	.BYTE 0x1
_ref5:
	.BYTE 0x1
_ref6:
	.BYTE 0x1
_ref7:
	.BYTE 0x1
_ref8:
	.BYTE 0x1
_buf:
	.BYTE 0x21
_level:
	.BYTE 0x2

	.ESEG
_ekp:
	.DB  0x32
_ekd:
	.DB  0x32
_espeed:
	.DB  0xFF
_estart:
	.DB  0x1
_eref1:
	.DB  0xFF
_eref2:
	.DB  0xFF
_eref3:
	.DB  0xFF
_eref4:
	.DB  0xFF
_eref5:
	.DB  0xFF
_eref6:
	.DB  0xFF
_eref7:
	.DB  0xFF
_eref8:
	.DB  0xFF
_elevel:
	.DW  0x32

	.DSEG
__base_y_G102:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1
__seed_G105:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:54 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(5)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(6)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(7)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0xA:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xB:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:32 WORDS
SUBOPT_0x10:
	LDI  R27,0
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL __DIVW21
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(_buf)
	LDI  R31,HIGH(_buf)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x12:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	LDI  R24,4
	CALL _sprintf
	ADIW R28,8
	RJMP SUBOPT_0x11

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R31,0
	SBIW R30,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDS  R30,_level
	LDS  R31,_level+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	RCALL SUBOPT_0x14
	ADIW R30,1
	STS  _level,R30
	STS  _level+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _set_motor

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x17:
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
SUBOPT_0x18:
	LDD  R30,Y+16
	LDD  R31,Y+16+1
	SBIW R30,4
	STD  Y+16,R30
	STD  Y+16+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDD  R30,Y+13
	LDD  R31,Y+13+1
	ST   -Y,R31
	ST   -Y,R30
	LDD  R30,Y+17
	LDD  R31,Y+17+1
	ICALL
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
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
SUBOPT_0x1B:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	ADIW R26,4
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	MOVW R26,R28
	ADIW R26,12
	CALL __ADDW2R15
	CALL __GETW1P
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G102
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
