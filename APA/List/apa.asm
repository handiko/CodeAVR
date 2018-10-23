
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 11.059200 MHz
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

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  _ext_int0_isr
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
	.DW  0x0000


__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

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
;Date    : 6/1/2012
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATmega32
;Program type            : Application
;AVR Core Clock frequency: 11.059200 MHz
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
;#include <delay.h>
;#include <stdio.h>
;
;bit baca_adc = 0;
;unsigned char adc[25];
;unsigned char adc_temp[25];
;
;#define ADC_VREF_TYPE 0x20
;
;#define SEL1	PINB.0
;#define SEL2	PINB.1
;#define SEL3	PINB.2
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0029 {

	.CSEG
_read_adc:
; 0000 002A ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 002B // Delay needed for the stabilization of the ADC input voltage
; 0000 002C delay_us(10);
	__DELAY_USB 37
; 0000 002D // Start the AD conversion
; 0000 002E ADCSRA|=0x40;
	SBI  0x6,6
; 0000 002F // Wait for the AD conversion to complete
; 0000 0030 while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 0031 ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0032 return ADCH;
	IN   R30,0x5
	JMP  _0x2060001
; 0000 0033 }
;
;void scan_adc(void)
; 0000 0036 {
_scan_adc:
; 0000 0037  	char i;
; 0000 0038 
; 0000 0039         if((!SEL1)&&(!SEL2)&&(!SEL3))
	ST   -Y,R17
;	i -> R17
	SBIC 0x16,0
	RJMP _0x7
	SBIC 0x16,1
	RJMP _0x7
	SBIS 0x16,2
	RJMP _0x8
_0x7:
	RJMP _0x6
_0x8:
; 0000 003A         {
; 0000 003B         	for(i=0;i<3;i++)
	LDI  R17,LOW(0)
_0xA:
	CPI  R17,3
	BRSH _0xB
; 0000 003C                 {
; 0000 003D                 	adc[i] = read_adc(i);
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc)
	SBCI R31,HIGH(-_adc)
	PUSH R31
	PUSH R30
	ST   -Y,R17
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 003E                         if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRSH _0xC
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 003F                 }
_0xC:
	SUBI R17,-1
	RJMP _0xA
_0xB:
; 0000 0040         }
; 0000 0041         else if((!SEL1)&&(!SEL2)&&(SEL3))
	RJMP _0xD
_0x6:
	SBIC 0x16,0
	RJMP _0xF
	SBIC 0x16,1
	RJMP _0xF
	SBIC 0x16,2
	RJMP _0x10
_0xF:
	RJMP _0xE
_0x10:
; 0000 0042         {
; 0000 0043         	for(i=3;i<6;i++)
	LDI  R17,LOW(3)
_0x12:
	CPI  R17,6
	BRSH _0x13
; 0000 0044                 {
; 0000 0045                 	adc[i] = read_adc(i-3);
	CALL SUBOPT_0x0
	MOVW R26,R30
	SUBI R30,LOW(-_adc)
	SBCI R31,HIGH(-_adc)
	PUSH R31
	PUSH R30
	MOVW R30,R26
	SBIW R30,3
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0046                         if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRSH _0x14
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 0047                 }
_0x14:
	SUBI R17,-1
	RJMP _0x12
_0x13:
; 0000 0048         }
; 0000 0049         else if((!SEL1)&&(SEL2)&&(!SEL3))
	RJMP _0x15
_0xE:
	SBIC 0x16,0
	RJMP _0x17
	SBIS 0x16,1
	RJMP _0x17
	SBIS 0x16,2
	RJMP _0x18
_0x17:
	RJMP _0x16
_0x18:
; 0000 004A         {
; 0000 004B         	for(i=6;i<9;i++)
	LDI  R17,LOW(6)
_0x1A:
	CPI  R17,9
	BRSH _0x1B
; 0000 004C                 {
; 0000 004D                 	adc[i] = read_adc(i-6);
	CALL SUBOPT_0x0
	MOVW R26,R30
	SUBI R30,LOW(-_adc)
	SBCI R31,HIGH(-_adc)
	PUSH R31
	PUSH R30
	MOVW R30,R26
	SBIW R30,6
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 004E                         if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRSH _0x1C
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 004F                 }
_0x1C:
	SUBI R17,-1
	RJMP _0x1A
_0x1B:
; 0000 0050         }
; 0000 0051         else if((!SEL1)&&(SEL2)&&(!SEL3))
	RJMP _0x1D
_0x16:
	SBIC 0x16,0
	RJMP _0x1F
	SBIS 0x16,1
	RJMP _0x1F
	SBIS 0x16,2
	RJMP _0x20
_0x1F:
	RJMP _0x1E
_0x20:
; 0000 0052         {
; 0000 0053         	for(i=9;i<12;i++)
	LDI  R17,LOW(9)
_0x22:
	CPI  R17,12
	BRSH _0x23
; 0000 0054                 {
; 0000 0055                 	adc[i] = read_adc(i-9);
	CALL SUBOPT_0x0
	MOVW R26,R30
	SUBI R30,LOW(-_adc)
	SBCI R31,HIGH(-_adc)
	PUSH R31
	PUSH R30
	MOVW R30,R26
	SBIW R30,9
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0056                         if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRSH _0x24
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 0057                 }
_0x24:
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 0058         }
; 0000 0059 
; 0000 005A         else if((!SEL1)&&(SEL2)&&(!SEL3))
	RJMP _0x25
_0x1E:
	SBIC 0x16,0
	RJMP _0x27
	SBIS 0x16,1
	RJMP _0x27
	SBIS 0x16,2
	RJMP _0x28
_0x27:
	RJMP _0x26
_0x28:
; 0000 005B         {
; 0000 005C         	for(i=12;i<15;i++)
	LDI  R17,LOW(12)
_0x2A:
	CPI  R17,15
	BRSH _0x2B
; 0000 005D                 {
; 0000 005E                 	adc[i] = read_adc(i-12);
	CALL SUBOPT_0x0
	MOVW R26,R30
	SUBI R30,LOW(-_adc)
	SBCI R31,HIGH(-_adc)
	PUSH R31
	PUSH R30
	MOVW R30,R26
	SBIW R30,12
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 005F                         if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRSH _0x2C
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 0060                 }
_0x2C:
	SUBI R17,-1
	RJMP _0x2A
_0x2B:
; 0000 0061         }
; 0000 0062         else if((!SEL1)&&(SEL2)&&(!SEL3))
	RJMP _0x2D
_0x26:
	SBIC 0x16,0
	RJMP _0x2F
	SBIS 0x16,1
	RJMP _0x2F
	SBIS 0x16,2
	RJMP _0x30
_0x2F:
	RJMP _0x2E
_0x30:
; 0000 0063         {
; 0000 0064         	for(i=15;i<18;i++)
	LDI  R17,LOW(15)
_0x32:
	CPI  R17,18
	BRSH _0x33
; 0000 0065                 {
; 0000 0066                 	adc[i] = read_adc(i-15);
	CALL SUBOPT_0x0
	MOVW R26,R30
	SUBI R30,LOW(-_adc)
	SBCI R31,HIGH(-_adc)
	PUSH R31
	PUSH R30
	MOVW R30,R26
	SBIW R30,15
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0067                         if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRSH _0x34
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 0068                 }
_0x34:
	SUBI R17,-1
	RJMP _0x32
_0x33:
; 0000 0069         }
; 0000 006A         else if((!SEL1)&&(SEL2)&&(!SEL3))
	RJMP _0x35
_0x2E:
	SBIC 0x16,0
	RJMP _0x37
	SBIS 0x16,1
	RJMP _0x37
	SBIS 0x16,2
	RJMP _0x38
_0x37:
	RJMP _0x36
_0x38:
; 0000 006B         {
; 0000 006C         	for(i=18;i<21;i++)
	LDI  R17,LOW(18)
_0x3A:
	CPI  R17,21
	BRSH _0x3B
; 0000 006D                 {
; 0000 006E                 	adc[i] = read_adc(i-18);
	CALL SUBOPT_0x0
	MOVW R26,R30
	SUBI R30,LOW(-_adc)
	SBCI R31,HIGH(-_adc)
	PUSH R31
	PUSH R30
	MOVW R30,R26
	SBIW R30,18
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 006F                         if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRSH _0x3C
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 0070                 }
_0x3C:
	SUBI R17,-1
	RJMP _0x3A
_0x3B:
; 0000 0071         }
; 0000 0072         else if((!SEL1)&&(SEL2)&&(!SEL3))
	RJMP _0x3D
_0x36:
	SBIC 0x16,0
	RJMP _0x3F
	SBIS 0x16,1
	RJMP _0x3F
	SBIS 0x16,2
	RJMP _0x40
_0x3F:
	RJMP _0x3E
_0x40:
; 0000 0073         {
; 0000 0074         	for(i=21;i<24;i++)
	LDI  R17,LOW(21)
_0x42:
	CPI  R17,24
	BRSH _0x43
; 0000 0075                 {
; 0000 0076                 	adc[i] = read_adc(i-21);
	CALL SUBOPT_0x0
	MOVW R26,R30
	SUBI R30,LOW(-_adc)
	SBCI R31,HIGH(-_adc)
	PUSH R31
	PUSH R30
	MOVW R30,R26
	SBIW R30,21
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 0077                         if(adc[i]>adc_temp[i])	adc_temp[i]=adc[i];
	CALL SUBOPT_0x0
	CALL SUBOPT_0x1
	BRSH _0x44
	CALL SUBOPT_0x2
	CALL SUBOPT_0x3
; 0000 0078                 }
_0x44:
	SUBI R17,-1
	RJMP _0x42
_0x43:
; 0000 0079         }
; 0000 007A 
; 0000 007B         adc[24]=read_adc(3);
_0x3E:
_0x3D:
_0x35:
_0x2D:
_0x25:
_0x1D:
_0x15:
_0xD:
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	__PUTB1MN _adc,24
; 0000 007C         if(adc[24]>adc_temp[24])
	__GETB2MN _adc,24
	__GETB1MN _adc_temp,24
	CP   R30,R26
	BRSH _0x45
; 0000 007D         	adc_temp[24]=adc[24];
	__GETB1MN _adc,24
	__PUTB1MN _adc_temp,24
; 0000 007E }
_0x45:
	LD   R17,Y+
	RET
;
;void string_putchar(unsigned char nilai)
; 0000 0081 {
_string_putchar:
; 0000 0082 	char ratusan;
; 0000 0083         char puluhan;
; 0000 0084         char satuan;
; 0000 0085 
; 0000 0086         ratusan = nilai/100;
	CALL __SAVELOCR4
;	nilai -> Y+4
;	ratusan -> R17
;	puluhan -> R16
;	satuan -> R19
	LDD  R26,Y+4
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOV  R17,R30
; 0000 0087         puluhan = (nilai%100)/10;
	LDD  R26,Y+4
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	MOV  R16,R30
; 0000 0088         satuan = nilai%10;
	LDD  R26,Y+4
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOV  R19,R30
; 0000 0089 
; 0000 008A         putchar(ratusan);
	ST   -Y,R17
	RCALL _putchar
; 0000 008B         putchar(puluhan);
	ST   -Y,R16
	RCALL _putchar
; 0000 008C         putchar(satuan);
	ST   -Y,R19
	RCALL _putchar
; 0000 008D }
	CALL __LOADLOCR4
	ADIW R28,5
	RET
;
;// External Interrupt 0 service routine
;interrupt [EXT_INT0] void ext_int0_isr(void)
; 0000 0091 {
_ext_int0_isr:
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
; 0000 0092 // Place your code here
; 0000 0093 	char j;
; 0000 0094 
; 0000 0095 	baca_adc = 1;
	ST   -Y,R17
;	j -> R17
	SET
	BLD  R2,0
; 0000 0096         for(j=0;j<25;j++)
	LDI  R17,LOW(0)
_0x47:
	CPI  R17,25
	BRSH _0x48
; 0000 0097         {
; 0000 0098         	adc_temp[j] = 0;
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_temp)
	SBCI R31,HIGH(-_adc_temp)
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 0099         }
	SUBI R17,-1
	RJMP _0x47
_0x48:
; 0000 009A         for(j=0;j<25;j++)
	LDI  R17,LOW(0)
_0x4A:
	CPI  R17,25
	BRSH _0x4B
; 0000 009B         {
; 0000 009C         	scan_adc();
	RCALL _scan_adc
; 0000 009D                 delay_ms(2);
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 009E         }
	SUBI R17,-1
	RJMP _0x4A
_0x4B:
; 0000 009F         for(j=0;j<25;j++)
	LDI  R17,LOW(0)
_0x4D:
	CPI  R17,25
	BRSH _0x4E
; 0000 00A0         {
; 0000 00A1         	string_putchar(adc_temp[j]);
	CALL SUBOPT_0x0
	SUBI R30,LOW(-_adc_temp)
	SBCI R31,HIGH(-_adc_temp)
	LD   R30,Z
	ST   -Y,R30
	RCALL _string_putchar
; 0000 00A2                 putchar(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _putchar
; 0000 00A3         }
	SUBI R17,-1
	RJMP _0x4D
_0x4E:
; 0000 00A4 }
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
;// Declare your global variables here
;
;void main(void)
; 0000 00A9 {
_main:
; 0000 00AA // Declare your local variables here
; 0000 00AB 
; 0000 00AC // Input/Output Ports initialization
; 0000 00AD // Port A initialization
; 0000 00AE // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00AF // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 00B0 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 00B1 DDRA=0x00;
	OUT  0x1A,R30
; 0000 00B2 
; 0000 00B3 // Port B initialization
; 0000 00B4 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00B5 // State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 00B6 PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 00B7 DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 00B8 
; 0000 00B9 // Port C initialization
; 0000 00BA // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00BB // State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 00BC PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 00BD DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 00BE 
; 0000 00BF // Port D initialization
; 0000 00C0 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
; 0000 00C1 // State7=P State6=P State5=P State4=P State3=P State2=P State1=1 State0=P
; 0000 00C2 PORTD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 00C3 DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 00C4 
; 0000 00C5 // Timer/Counter 0 initialization
; 0000 00C6 // Clock source: System Clock
; 0000 00C7 // Clock value: Timer 0 Stopped
; 0000 00C8 // Mode: Normal top=0xFF
; 0000 00C9 // OC0 output: Disconnected
; 0000 00CA TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 00CB TCNT0=0x00;
	OUT  0x32,R30
; 0000 00CC OCR0=0x00;
	OUT  0x3C,R30
; 0000 00CD 
; 0000 00CE // Timer/Counter 1 initialization
; 0000 00CF // Clock source: System Clock
; 0000 00D0 // Clock value: Timer1 Stopped
; 0000 00D1 // Mode: Normal top=0xFFFF
; 0000 00D2 // OC1A output: Discon.
; 0000 00D3 // OC1B output: Discon.
; 0000 00D4 // Noise Canceler: Off
; 0000 00D5 // Input Capture on Falling Edge
; 0000 00D6 // Timer1 Overflow Interrupt: Off
; 0000 00D7 // Input Capture Interrupt: Off
; 0000 00D8 // Compare A Match Interrupt: Off
; 0000 00D9 // Compare B Match Interrupt: Off
; 0000 00DA TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 00DB TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 00DC TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 00DD TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 00DE ICR1H=0x00;
	OUT  0x27,R30
; 0000 00DF ICR1L=0x00;
	OUT  0x26,R30
; 0000 00E0 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00E1 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00E2 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00E3 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00E4 
; 0000 00E5 // Timer/Counter 2 initialization
; 0000 00E6 // Clock source: System Clock
; 0000 00E7 // Clock value: Timer2 Stopped
; 0000 00E8 // Mode: Normal top=0xFF
; 0000 00E9 // OC2 output: Disconnected
; 0000 00EA ASSR=0x00;
	OUT  0x22,R30
; 0000 00EB TCCR2=0x00;
	OUT  0x25,R30
; 0000 00EC TCNT2=0x00;
	OUT  0x24,R30
; 0000 00ED OCR2=0x00;
	OUT  0x23,R30
; 0000 00EE 
; 0000 00EF // External Interrupt(s) initialization
; 0000 00F0 // INT0: On
; 0000 00F1 // INT0 Mode: Falling Edge
; 0000 00F2 // INT1: Off
; 0000 00F3 // INT2: Off
; 0000 00F4 GICR|=0x40;
	IN   R30,0x3B
	ORI  R30,0x40
	OUT  0x3B,R30
; 0000 00F5 MCUCR=0x02;
	LDI  R30,LOW(2)
	OUT  0x35,R30
; 0000 00F6 MCUCSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x34,R30
; 0000 00F7 GIFR=0x40;
	LDI  R30,LOW(64)
	OUT  0x3A,R30
; 0000 00F8 
; 0000 00F9 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00FA TIMSK=0x00;
	LDI  R30,LOW(0)
	OUT  0x39,R30
; 0000 00FB 
; 0000 00FC // USART initialization
; 0000 00FD // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00FE // USART Receiver: Off
; 0000 00FF // USART Transmitter: On
; 0000 0100 // USART Mode: Asynchronous
; 0000 0101 // USART Baud Rate: 9600
; 0000 0102 UCSRA=0x00;
	OUT  0xB,R30
; 0000 0103 UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 0104 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0105 UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 0106 UBRRL=0x47;
	LDI  R30,LOW(71)
	OUT  0x9,R30
; 0000 0107 
; 0000 0108 // Analog Comparator initialization
; 0000 0109 // Analog Comparator: Off
; 0000 010A // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 010B ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 010C SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 010D 
; 0000 010E // Analog Comparator initialization
; 0000 010F // Analog Comparator: Off
; 0000 0110 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0111 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0112 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 0113 
; 0000 0114 // ADC initialization
; 0000 0115 // ADC Clock frequency: 691.200 kHz
; 0000 0116 // ADC Voltage Reference: AREF pin
; 0000 0117 // Only the 8 most significant bits of
; 0000 0118 // the AD conversion result are used
; 0000 0119 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 011A ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 011B 
; 0000 011C // SPI initialization
; 0000 011D // SPI disabled
; 0000 011E SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 011F 
; 0000 0120 // TWI initialization
; 0000 0121 // TWI disabled
; 0000 0122 TWCR=0x00;
	OUT  0x36,R30
; 0000 0123 
; 0000 0124 // Global enable interrupts
; 0000 0125 #asm("sei")
	sei
; 0000 0126 
; 0000 0127 while (1)
_0x4F:
; 0000 0128       {
; 0000 0129       // Place your code here
; 0000 012A 
; 0000 012B       }
	RJMP _0x4F
; 0000 012C }
_0x52:
	RJMP _0x52
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
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2060001:
	ADIW R28,1
	RET

	.CSEG

	.CSEG

	.DSEG
_adc:
	.BYTE 0x19
_adc_temp:
	.BYTE 0x19

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x0:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:46 WORDS
SUBOPT_0x1:
	MOVW R0,R30
	SUBI R30,LOW(-_adc)
	SBCI R31,HIGH(-_adc)
	LD   R26,Z
	MOVW R30,R0
	SUBI R30,LOW(-_adc_temp)
	SBCI R31,HIGH(-_adc_temp)
	LD   R30,Z
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x2:
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_adc_temp)
	SBCI R27,HIGH(-_adc_temp)
	RJMP SUBOPT_0x0

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x3:
	SUBI R30,LOW(-_adc)
	SBCI R31,HIGH(-_adc)
	LD   R30,Z
	ST   X,R30
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

__ANEGW1:
	NEG  R31
	NEG  R30
	SBCI R31,0
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

__SAVELOCR4:
	ST   -Y,R19
__SAVELOCR3:
	ST   -Y,R18
__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

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
