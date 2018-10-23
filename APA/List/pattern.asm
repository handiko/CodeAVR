
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _time=R4
	.DEF _i=R7

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
	JMP  _timer1_ovf_isr
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

_0x50:
	.DB  0x0,0x0
_0x0:
	.DB  0x6D,0x75,0x6C,0x61,0x69,0x0,0x73,0x65
	.DB  0x6C,0x65,0x73,0x61,0x69,0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x06
	.DW  _0x3
	.DW  _0x0*2

	.DW  0x08
	.DW  _0x3+6
	.DW  _0x0*2+6

	.DW  0x02
	.DW  0x04
	.DW  _0x50*2

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
;Date    : 6/7/2012
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
;
;#include <delay.h>
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;#define TRIGGER	PINB.0
;#define MUX_A	PINB.0
;#define MUX_B	PINB.1
;#define MUX_C	PINB.2
;
;unsigned char read_adc(unsigned char adc_input);
;char ratusan(unsigned char in);
;char puluhan(unsigned char in);
;char satuan(unsigned char in);
;
;unsigned int time=0;
;unsigned char sen_buff[4],sen[26];
;char i;
;bit en_adc;
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0030 {

	.CSEG
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
; 0000 0031 	// Place your code here
; 0000 0032 
; 0000 0033        /* if(TRIGGER==1)
; 0000 0034         {
; 0000 0035         	if(en_adc==0)
; 0000 0036                 {
; 0000 0037                 	for(i=0;i<25;i++)
; 0000 0038                         {
; 0000 0039                         	sen[i+1]=0;
; 0000 003A                         }
; 0000 003B                 }
; 0000 003C                 en_adc=1;
; 0000 003D         }
; 0000 003E 
; 0000 003F         if(en_adc==0)
; 0000 0040         {
; 0000 0041         	for(i=0;i<25;i++)
; 0000 0042                 {
; 0000 0043                 	sen[i+1]=0;
; 0000 0044                 }
; 0000 0045         }
; 0000 0046 
; 0000 0047         if(en_adc==1)
; 0000 0048         {
; 0000 0049                 putchar(13);
; 0000 004A                 puts("mulai");
; 0000 004B                 for(i=0;i<25;i++)
; 0000 004C                 {
; 0000 004D                 	putchar(13);
; 0000 004E                         putchar(ratusan(sen[i+1]));
; 0000 004F                         putchar(puluhan(sen[i+1]));
; 0000 0050                         putchar(satuan(sen[i+1]));
; 0000 0051                 }
; 0000 0052                 putchar(13);
; 0000 0053                 puts("selesai");
; 0000 0054                 putchar(13);
; 0000 0055 
; 0000 0056                 en_adc=0;
; 0000 0057         } */
; 0000 0058 
; 0000 0059         putchar(13);
	CALL SUBOPT_0x0
; 0000 005A         puts("mulai");
	__POINTW1MN _0x3,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
; 0000 005B         for(i=0;i<25;i++)
	CLR  R7
_0x5:
	LDI  R30,LOW(25)
	CP   R7,R30
	BRSH _0x6
; 0000 005C         {
; 0000 005D         	putchar(13);
	CALL SUBOPT_0x0
; 0000 005E                 putchar(ratusan(sen[i+1]));
	CALL SUBOPT_0x1
	RCALL _ratusan
	ST   -Y,R30
	CALL _putchar
; 0000 005F                 putchar(puluhan(sen[i+1]));
	CALL SUBOPT_0x1
	RCALL _puluhan
	ST   -Y,R30
	CALL _putchar
; 0000 0060                 putchar(satuan(sen[i+1]));
	CALL SUBOPT_0x1
	RCALL _satuan
	ST   -Y,R30
	CALL _putchar
; 0000 0061         }
	INC  R7
	RJMP _0x5
_0x6:
; 0000 0062         putchar(13);
	CALL SUBOPT_0x0
; 0000 0063         puts("selesai");
	__POINTW1MN _0x3,6
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
; 0000 0064         putchar(13);
	CALL SUBOPT_0x0
; 0000 0065 
; 0000 0066         //en_adc=0;
; 0000 0067 
; 0000 0068         TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
; 0000 0069 	TCNT1L=0x94;
	LDI  R30,LOW(148)
	OUT  0x2C,R30
; 0000 006A }
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

	.DSEG
_0x3:
	.BYTE 0xE
;
;#define ADC_VREF_TYPE 0x20
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0071 {

	.CSEG
_read_adc:
; 0000 0072 	ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 0073 	// Delay needed for the stabilization of the ADC input voltage
; 0000 0074 	delay_us(10);
	__DELAY_USB 37
; 0000 0075 	// Start the AD conversion
; 0000 0076 	ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0077 	// Wait for the AD conversion to complete
; 0000 0078 	while ((ADCSRA & 0x10)==0);
_0x7:
	SBIS 0x6,4
	RJMP _0x7
; 0000 0079 	ADCSRA|=0x10;
	SBI  0x6,4
; 0000 007A 	return ADCH;
	IN   R30,0x5
	JMP  _0x2060001
; 0000 007B }
;
;// Declare your global variables here
;
;char ratusan(unsigned char in)
; 0000 0080 {
_ratusan:
; 0000 0081 	in/=100;
;	in -> Y+0
	LD   R26,Y
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	ST   Y,R30
; 0000 0082         //in/=10;
; 0000 0083 
; 0000 0084         return (in +'0');
	SUBI R30,-LOW(48)
	JMP  _0x2060001
; 0000 0085 }
;
;char puluhan(unsigned char in)
; 0000 0088 {
_puluhan:
; 0000 0089 	in%=100;
;	in -> Y+0
	LD   R26,Y
	CLR  R27
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	ST   Y,R30
; 0000 008A 
; 0000 008B         return ((in / 10)+'0');
	LD   R26,Y
	LDI  R27,0
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __DIVW21
	SUBI R30,-LOW(48)
	JMP  _0x2060001
; 0000 008C }
;
;char satuan(unsigned char in)
; 0000 008F {
_satuan:
; 0000 0090 	return ((in % 10)+'0');
;	in -> Y+0
	LD   R26,Y
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	SUBI R30,-LOW(48)
	JMP  _0x2060001
; 0000 0091 }
;
;void main(void)
; 0000 0094 {
_main:
; 0000 0095 	// Declare your local variables here
; 0000 0096 
; 0000 0097 	// Input/Output Ports initialization
; 0000 0098 	// Port A initialization
; 0000 0099 	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 009A 	// State7=P State6=P State5=P State4=P State3=T State2=T State1=T State0=T
; 0000 009B 	PORTA=0xF0;
	LDI  R30,LOW(240)
	OUT  0x1B,R30
; 0000 009C 	DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 009D 
; 0000 009E 	// Port B initialization
; 0000 009F 	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A0 	// State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 00A1 	PORTB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 00A2 	DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
; 0000 00A3 
; 0000 00A4 	// Port C initialization
; 0000 00A5 	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 00A6 	// State7=P State6=P State5=P State4=P State3=P State2=P State1=P State0=P
; 0000 00A7 	PORTC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x15,R30
; 0000 00A8 	DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
; 0000 00A9 
; 0000 00AA 	// Port D initialization
; 0000 00AB 	// Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
; 0000 00AC 	// State7=P State6=P State5=P State4=P State3=P State2=P State1=1 State0=P
; 0000 00AD 	PORTD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 00AE 	DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 00AF 
; 0000 00B0 	// Timer/Counter 1 initialization
; 0000 00B1 	// Clock source: System Clock
; 0000 00B2 	// Clock value: 10.800 kHz
; 0000 00B3 	// Mode: Normal top=0xFFFF
; 0000 00B4 	// OC1A output: Discon.
; 0000 00B5 	// OC1B output: Discon.
; 0000 00B6 	// Noise Canceler: Off
; 0000 00B7 	// Input Capture on Falling Edge
; 0000 00B8 	// Timer1 Overflow Interrupt: On
; 0000 00B9 	// Input Capture Interrupt: Off
; 0000 00BA 	// Compare A Match Interrupt: Off
; 0000 00BB 	// Compare B Match Interrupt: Off
; 0000 00BC 	TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 00BD 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 00BE 	TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
; 0000 00BF 	TCNT1L=0x94;
	LDI  R30,LOW(148)
	OUT  0x2C,R30
; 0000 00C0 	ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 00C1 	ICR1L=0x00;
	OUT  0x26,R30
; 0000 00C2 	OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 00C3 	OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 00C4 	OCR1BH=0x00;
	OUT  0x29,R30
; 0000 00C5 	OCR1BL=0x00;
	OUT  0x28,R30
; 0000 00C6 
; 0000 00C7 	// Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 00C8 	TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 00C9 
; 0000 00CA 	// USART initialization
; 0000 00CB 	// Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 00CC 	// USART Receiver: Off
; 0000 00CD 	// USART Transmitter: On
; 0000 00CE 	// USART Mode: Asynchronous
; 0000 00CF 	// USART Baud Rate: 1200
; 0000 00D0 	UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00D1 	UCSRB=0x08;
	LDI  R30,LOW(8)
	OUT  0xA,R30
; 0000 00D2 	UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 00D3 	UBRRH=0x02;
	LDI  R30,LOW(2)
	OUT  0x20,R30
; 0000 00D4 	UBRRL=0x3F;
	LDI  R30,LOW(63)
	OUT  0x9,R30
; 0000 00D5 
; 0000 00D6 	// Analog Comparator initialization
; 0000 00D7 	// Analog Comparator: Off
; 0000 00D8 	// Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 00D9 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00DA 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 00DB 
; 0000 00DC 	// ADC initialization
; 0000 00DD 	// ADC Clock frequency: 691.200 kHz
; 0000 00DE 	// ADC Voltage Reference: AREF pin
; 0000 00DF 	// Only the 8 most significant bits of
; 0000 00E0 	// the AD conversion result are used
; 0000 00E1 	ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 00E2 	ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 00E3 
; 0000 00E4         en_adc=0;
	CLT
	BLD  R2,0
; 0000 00E5 
; 0000 00E6         for(i=0;i<25;i++)
	CLR  R7
_0xB:
	LDI  R30,LOW(25)
	CP   R7,R30
	BRSH _0xC
; 0000 00E7         {
; 0000 00E8         	sen[i+1]=0;
	MOV  R30,R7
	LDI  R31,0
	__ADDW1MN _sen,1
	LDI  R26,LOW(0)
	STD  Z+0,R26
; 0000 00E9         }
	INC  R7
	RJMP _0xB
_0xC:
; 0000 00EA 
; 0000 00EB 	// Global enable interrupts
; 0000 00EC 	#asm("sei")
	sei
; 0000 00ED 
; 0000 00EE 	while (1)
_0xD:
; 0000 00EF       	{
; 0000 00F0       		// Place your code here
; 0000 00F1                 //putchar('C');
; 0000 00F2 
; 0000 00F3 
; 0000 00F4                 if((MUX_A==0)&&(MUX_B==0)&&(MUX_C==0))
	CALL SUBOPT_0x2
	BRNE _0x11
	CALL SUBOPT_0x3
	BRNE _0x11
	CALL SUBOPT_0x4
	BREQ _0x12
_0x11:
	RJMP _0x10
_0x12:
; 0000 00F5                 {
; 0000 00F6                 	sen_buff[0]=read_adc(0);
	CALL SUBOPT_0x5
; 0000 00F7                         sen_buff[1]=read_adc(1);
; 0000 00F8                         sen_buff[2]=read_adc(2);
; 0000 00F9                         sen_buff[3]=read_adc(3);
; 0000 00FA 
; 0000 00FB                         if(sen_buff[0]>sen[17])	sen[17]=sen_buff[0];
	__GETB1MN _sen,17
	LDS  R26,_sen_buff
	CP   R30,R26
	BRSH _0x13
	LDS  R30,_sen_buff
	__PUTB1MN _sen,17
; 0000 00FC                         if(sen_buff[1]>sen[9])	sen[9]=sen_buff[1];
_0x13:
	__GETB2MN _sen_buff,1
	__GETB1MN _sen,9
	CP   R30,R26
	BRSH _0x14
	__GETB1MN _sen_buff,1
	__PUTB1MN _sen,9
; 0000 00FD                         if(sen_buff[2]>sen[1])	sen[1]=sen_buff[2];
_0x14:
	__GETB2MN _sen_buff,2
	__GETB1MN _sen,1
	CP   R30,R26
	BRSH _0x15
	__GETB1MN _sen_buff,2
	__PUTB1MN _sen,1
; 0000 00FE                         if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
_0x15:
	CALL SUBOPT_0x6
	BRSH _0x16
	CALL SUBOPT_0x7
; 0000 00FF                 }
_0x16:
; 0000 0100 
; 0000 0101                 else if((MUX_A==0)&&(MUX_B==0)&&(MUX_C==1))
	RJMP _0x17
_0x10:
	CALL SUBOPT_0x2
	BRNE _0x19
	CALL SUBOPT_0x3
	BRNE _0x19
	SBIC 0x16,2
	RJMP _0x1A
_0x19:
	RJMP _0x18
_0x1A:
; 0000 0102                 {
; 0000 0103                 	sen_buff[0]=read_adc(0);
	CALL SUBOPT_0x5
; 0000 0104                         sen_buff[1]=read_adc(1);
; 0000 0105                         sen_buff[2]=read_adc(2);
; 0000 0106                         sen_buff[3]=read_adc(3);
; 0000 0107 
; 0000 0108                         if(sen_buff[0]>sen[18])	sen[18]=sen_buff[0];
	__GETB1MN _sen,18
	LDS  R26,_sen_buff
	CP   R30,R26
	BRSH _0x1B
	LDS  R30,_sen_buff
	__PUTB1MN _sen,18
; 0000 0109                         if(sen_buff[1]>sen[10])	sen[10]=sen_buff[1];
_0x1B:
	__GETB2MN _sen_buff,1
	__GETB1MN _sen,10
	CP   R30,R26
	BRSH _0x1C
	__GETB1MN _sen_buff,1
	__PUTB1MN _sen,10
; 0000 010A                         if(sen_buff[2]>sen[2])	sen[2]=sen_buff[2];
_0x1C:
	__GETB2MN _sen_buff,2
	__GETB1MN _sen,2
	CP   R30,R26
	BRSH _0x1D
	__GETB1MN _sen_buff,2
	__PUTB1MN _sen,2
; 0000 010B                         if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
_0x1D:
	CALL SUBOPT_0x6
	BRSH _0x1E
	CALL SUBOPT_0x7
; 0000 010C                 }
_0x1E:
; 0000 010D 
; 0000 010E                 else if((MUX_A==0)&&(MUX_B==1)&&(MUX_C==0))
	RJMP _0x1F
_0x18:
	CALL SUBOPT_0x2
	BRNE _0x21
	SBIS 0x16,1
	RJMP _0x21
	CALL SUBOPT_0x4
	BREQ _0x22
_0x21:
	RJMP _0x20
_0x22:
; 0000 010F                 {
; 0000 0110                 	sen_buff[0]=read_adc(0);
	CALL SUBOPT_0x5
; 0000 0111                         sen_buff[1]=read_adc(1);
; 0000 0112                         sen_buff[2]=read_adc(2);
; 0000 0113                         sen_buff[3]=read_adc(3);
; 0000 0114 
; 0000 0115                         if(sen_buff[0]>sen[19])	sen[18]=sen_buff[0];
	__GETB1MN _sen,19
	LDS  R26,_sen_buff
	CP   R30,R26
	BRSH _0x23
	LDS  R30,_sen_buff
	__PUTB1MN _sen,18
; 0000 0116                         if(sen_buff[1]>sen[11])	sen[11]=sen_buff[1];
_0x23:
	__GETB2MN _sen_buff,1
	__GETB1MN _sen,11
	CP   R30,R26
	BRSH _0x24
	__GETB1MN _sen_buff,1
	__PUTB1MN _sen,11
; 0000 0117                         if(sen_buff[2]>sen[3])	sen[3]=sen_buff[2];
_0x24:
	__GETB2MN _sen_buff,2
	__GETB1MN _sen,3
	CP   R30,R26
	BRSH _0x25
	__GETB1MN _sen_buff,2
	__PUTB1MN _sen,3
; 0000 0118                         if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
_0x25:
	CALL SUBOPT_0x6
	BRSH _0x26
	CALL SUBOPT_0x7
; 0000 0119                 }
_0x26:
; 0000 011A 
; 0000 011B                 else if((MUX_A==0)&&(MUX_B==1)&&(MUX_C==1))
	RJMP _0x27
_0x20:
	CALL SUBOPT_0x2
	BRNE _0x29
	SBIS 0x16,1
	RJMP _0x29
	SBIC 0x16,2
	RJMP _0x2A
_0x29:
	RJMP _0x28
_0x2A:
; 0000 011C                 {
; 0000 011D                 	sen_buff[0]=read_adc(0);
	CALL SUBOPT_0x5
; 0000 011E                         sen_buff[1]=read_adc(1);
; 0000 011F                         sen_buff[2]=read_adc(2);
; 0000 0120                         sen_buff[3]=read_adc(3);
; 0000 0121 
; 0000 0122                         if(sen_buff[0]>sen[20])	sen[20]=sen_buff[0];
	__GETB1MN _sen,20
	LDS  R26,_sen_buff
	CP   R30,R26
	BRSH _0x2B
	LDS  R30,_sen_buff
	__PUTB1MN _sen,20
; 0000 0123                         if(sen_buff[1]>sen[12])	sen[12]=sen_buff[1];
_0x2B:
	__GETB2MN _sen_buff,1
	__GETB1MN _sen,12
	CP   R30,R26
	BRSH _0x2C
	__GETB1MN _sen_buff,1
	__PUTB1MN _sen,12
; 0000 0124                         if(sen_buff[2]>sen[4])	sen[4]=sen_buff[2];
_0x2C:
	__GETB2MN _sen_buff,2
	__GETB1MN _sen,4
	CP   R30,R26
	BRSH _0x2D
	__GETB1MN _sen_buff,2
	__PUTB1MN _sen,4
; 0000 0125                         if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
_0x2D:
	CALL SUBOPT_0x6
	BRSH _0x2E
	CALL SUBOPT_0x7
; 0000 0126                 }
_0x2E:
; 0000 0127 
; 0000 0128                 else if((MUX_A==1)&&(MUX_B==0)&&(MUX_C==0))
	RJMP _0x2F
_0x28:
	SBIS 0x16,0
	RJMP _0x31
	CALL SUBOPT_0x3
	BRNE _0x31
	CALL SUBOPT_0x4
	BREQ _0x32
_0x31:
	RJMP _0x30
_0x32:
; 0000 0129                 {
; 0000 012A                 	sen_buff[0]=read_adc(0);
	CALL SUBOPT_0x5
; 0000 012B                         sen_buff[1]=read_adc(1);
; 0000 012C                         sen_buff[2]=read_adc(2);
; 0000 012D                         sen_buff[3]=read_adc(3);
; 0000 012E 
; 0000 012F                         if(sen_buff[0]>sen[21])	sen[21]=sen_buff[0];
	__GETB1MN _sen,21
	LDS  R26,_sen_buff
	CP   R30,R26
	BRSH _0x33
	LDS  R30,_sen_buff
	__PUTB1MN _sen,21
; 0000 0130                         if(sen_buff[1]>sen[13])	sen[13]=sen_buff[1];
_0x33:
	__GETB2MN _sen_buff,1
	__GETB1MN _sen,13
	CP   R30,R26
	BRSH _0x34
	__GETB1MN _sen_buff,1
	__PUTB1MN _sen,13
; 0000 0131                         if(sen_buff[2]>sen[5])	sen[5]=sen_buff[2];
_0x34:
	__GETB2MN _sen_buff,2
	__GETB1MN _sen,5
	CP   R30,R26
	BRSH _0x35
	__GETB1MN _sen_buff,2
	__PUTB1MN _sen,5
; 0000 0132                         if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
_0x35:
	CALL SUBOPT_0x6
	BRSH _0x36
	CALL SUBOPT_0x7
; 0000 0133                 }
_0x36:
; 0000 0134 
; 0000 0135                 else if((MUX_A==1)&&(MUX_B==0)&&(MUX_C==1))
	RJMP _0x37
_0x30:
	SBIS 0x16,0
	RJMP _0x39
	CALL SUBOPT_0x3
	BRNE _0x39
	SBIC 0x16,2
	RJMP _0x3A
_0x39:
	RJMP _0x38
_0x3A:
; 0000 0136                 {
; 0000 0137                 	sen_buff[0]=read_adc(0);
	CALL SUBOPT_0x5
; 0000 0138                         sen_buff[1]=read_adc(1);
; 0000 0139                         sen_buff[2]=read_adc(2);
; 0000 013A                         sen_buff[3]=read_adc(3);
; 0000 013B 
; 0000 013C                         if(sen_buff[0]>sen[22])	sen[22]=sen_buff[0];
	__GETB1MN _sen,22
	LDS  R26,_sen_buff
	CP   R30,R26
	BRSH _0x3B
	LDS  R30,_sen_buff
	__PUTB1MN _sen,22
; 0000 013D                         if(sen_buff[1]>sen[14])	sen[14]=sen_buff[1];
_0x3B:
	__GETB2MN _sen_buff,1
	__GETB1MN _sen,14
	CP   R30,R26
	BRSH _0x3C
	__GETB1MN _sen_buff,1
	__PUTB1MN _sen,14
; 0000 013E                         if(sen_buff[2]>sen[6])	sen[6]=sen_buff[2];
_0x3C:
	__GETB2MN _sen_buff,2
	__GETB1MN _sen,6
	CP   R30,R26
	BRSH _0x3D
	__GETB1MN _sen_buff,2
	__PUTB1MN _sen,6
; 0000 013F                         if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
_0x3D:
	CALL SUBOPT_0x6
	BRSH _0x3E
	CALL SUBOPT_0x7
; 0000 0140                 }
_0x3E:
; 0000 0141 
; 0000 0142                 else if((MUX_A==1)&&(MUX_B==1)&&(MUX_C==0))
	RJMP _0x3F
_0x38:
	SBIS 0x16,0
	RJMP _0x41
	SBIS 0x16,1
	RJMP _0x41
	CALL SUBOPT_0x4
	BREQ _0x42
_0x41:
	RJMP _0x40
_0x42:
; 0000 0143                 {
; 0000 0144                 	sen_buff[0]=read_adc(0);
	CALL SUBOPT_0x5
; 0000 0145                         sen_buff[1]=read_adc(1);
; 0000 0146                         sen_buff[2]=read_adc(2);
; 0000 0147                         sen_buff[3]=read_adc(3);
; 0000 0148 
; 0000 0149                         if(sen_buff[0]>sen[23])	sen[23]=sen_buff[0];
	__GETB1MN _sen,23
	LDS  R26,_sen_buff
	CP   R30,R26
	BRSH _0x43
	LDS  R30,_sen_buff
	__PUTB1MN _sen,23
; 0000 014A                         if(sen_buff[1]>sen[15])	sen[15]=sen_buff[1];
_0x43:
	__GETB2MN _sen_buff,1
	__GETB1MN _sen,15
	CP   R30,R26
	BRSH _0x44
	__GETB1MN _sen_buff,1
	__PUTB1MN _sen,15
; 0000 014B                         if(sen_buff[2]>sen[7])	sen[7]=sen_buff[2];
_0x44:
	__GETB2MN _sen_buff,2
	__GETB1MN _sen,7
	CP   R30,R26
	BRSH _0x45
	__GETB1MN _sen_buff,2
	__PUTB1MN _sen,7
; 0000 014C                         if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
_0x45:
	CALL SUBOPT_0x6
	BRSH _0x46
	CALL SUBOPT_0x7
; 0000 014D                 }
_0x46:
; 0000 014E 
; 0000 014F                 else if((MUX_A==1)&&(MUX_B==1)&&(MUX_C==1))
	RJMP _0x47
_0x40:
	SBIS 0x16,0
	RJMP _0x49
	SBIS 0x16,1
	RJMP _0x49
	SBIC 0x16,2
	RJMP _0x4A
_0x49:
	RJMP _0x48
_0x4A:
; 0000 0150                 {
; 0000 0151                 	sen_buff[0]=read_adc(0);
	CALL SUBOPT_0x5
; 0000 0152                         sen_buff[1]=read_adc(1);
; 0000 0153                         sen_buff[2]=read_adc(2);
; 0000 0154                         sen_buff[3]=read_adc(3);
; 0000 0155 
; 0000 0156                         if(sen_buff[0]>sen[24])	sen[24]=sen_buff[0];
	__GETB1MN _sen,24
	LDS  R26,_sen_buff
	CP   R30,R26
	BRSH _0x4B
	LDS  R30,_sen_buff
	__PUTB1MN _sen,24
; 0000 0157                         if(sen_buff[1]>sen[16])	sen[16]=sen_buff[1];
_0x4B:
	__GETB2MN _sen_buff,1
	__GETB1MN _sen,16
	CP   R30,R26
	BRSH _0x4C
	__GETB1MN _sen_buff,1
	__PUTB1MN _sen,16
; 0000 0158                         if(sen_buff[2]>sen[8])	sen[8]=sen_buff[2];
_0x4C:
	__GETB2MN _sen_buff,2
	__GETB1MN _sen,8
	CP   R30,R26
	BRSH _0x4D
	__GETB1MN _sen_buff,2
	__PUTB1MN _sen,8
; 0000 0159                         if(sen_buff[3]>sen[25])	sen[25]=sen_buff[3];
_0x4D:
	CALL SUBOPT_0x6
	BRSH _0x4E
	CALL SUBOPT_0x7
; 0000 015A                 }
_0x4E:
; 0000 015B       	}
_0x48:
_0x47:
_0x3F:
_0x37:
_0x2F:
_0x27:
_0x1F:
_0x17:
	RJMP _0xD
; 0000 015C }
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
_putchar:
putchar0:
     sbis usr,udre
     rjmp putchar0
     ld   r30,y
     out  udr,r30
_0x2060001:
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
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _putchar
	LDD  R17,Y+0
	ADIW R28,3
	RET

	.CSEG

	.CSEG

	.DSEG
_sen_buff:
	.BYTE 0x4
_sen:
	.BYTE 0x1A

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(13)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1:
	MOV  R30,R7
	LDI  R31,0
	__ADDW1MN _sen,1
	LD   R30,Z
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R26,0
	SBIC 0x16,0
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R26,0
	SBIC 0x16,1
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4:
	LDI  R26,0
	SBIC 0x16,2
	LDI  R26,1
	CPI  R26,LOW(0x0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:151 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _read_adc
	STS  _sen_buff,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL _read_adc
	__PUTB1MN _sen_buff,1
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL _read_adc
	__PUTB1MN _sen_buff,2
	LDI  R30,LOW(3)
	ST   -Y,R30
	CALL _read_adc
	__PUTB1MN _sen_buff,3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x6:
	__GETB2MN _sen_buff,3
	__GETB1MN _sen,25
	CP   R30,R26
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x7:
	__GETB1MN _sen_buff,3
	__PUTB1MN _sen,25
	RET


	.CSEG
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

;END OF CODE MARKER
__END_OF_CODE:
