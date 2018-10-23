
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
	.DEF _crc=R4

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

_data_1:
	.DB  0x82,0xA0,0xA4,0xA6,0x40,0x40,0x60,0xA6
	.DB  0x8A,0xA4,0x9A,0x9E,0x40,0x60,0xAE,0x92
	.DB  0x88,0x8A,0x64,0x40,0x65
_posisi_lat:
	.DB  0x30,0x37,0x34,0x39,0x2E,0x34,0x38,0x53
_posisi_long:
	.DB  0x31,0x31,0x30,0x30,0x37,0x2E,0x34,0x30
	.DB  0x45
_def_t:
	.DB  0x3A,0x53,0x45,0x52,0x4D,0x4F,0x20,0x20
	.DB  0x20,0x20,0x3A,0x50,0x41,0x52,0x4D,0x2E
	.DB  0x4C,0x65,0x76,0x65,0x6C,0x2C,0x43,0x61
	.DB  0x68,0x61,0x79,0x61,0x2C,0x50,0x69,0x65
	.DB  0x7A,0x6F,0x31,0x2C,0x50,0x69,0x65,0x7A
	.DB  0x6F,0x32,0x0
_unit_t:
	.DB  0x3A,0x53,0x45,0x52,0x4D,0x4F,0x20,0x20
	.DB  0x20,0x20,0x3A,0x55,0x4E,0x49,0x54,0x2E
	.DB  0x6D,0x65,0x74,0x65,0x72,0x2C,0x56,0x6F
	.DB  0x6C,0x74,0x2C,0x56,0x6F,0x6C,0x74,0x2C
	.DB  0x56,0x6F,0x6C,0x74,0x0
_eqn_t:
	.DB  0x3A,0x53,0x45,0x52,0x4D,0x4F,0x20,0x20
	.DB  0x20,0x20,0x3A,0x45,0x51,0x4E,0x53,0x2E
	.DB  0x30,0x2C,0x30,0x2E,0x30,0x30,0x34,0x2C
	.DB  0x30,0x2C,0x30,0x2C,0x30,0x2E,0x30,0x31
	.DB  0x39,0x2C,0x30,0x2C,0x30,0x2C,0x30,0x2E
	.DB  0x30,0x31,0x39,0x2C,0x30,0x2C,0x30,0x2C
	.DB  0x30,0x2E,0x30,0x31,0x39,0x2C,0x30,0x2C
	.DB  0x30,0x2C,0x31,0x2C,0x30,0x0

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
;Date    : 11/1/2013
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
;#include <stdint.h>
;
;#define ADC_VREF_TYPE 0x20
;
;#define _1200           0
;#define _2200           1
;
;#ifdef        _OPTIMIZE_SIZE_
;        #define CONST_1200      46
;        #define CONST_2200      26  // 22-25    22-->2400Hz   25-->2200Hz
;#else
;        #define CONST_1200      50
;        #define CONST_2200      25
;#endif
;
;#define CONST_BAUD      820
;
;#define GAP_TIME_       30
;#define TX_DELAY_       45
;#define FLAG_           0x7E
;#define CONTROL_FIELD_  0x03
;#define PROTOCOL_ID_    0xF0
;#define TD_POSISI_      '!'
;#define TD_TELEM_       'T'
;#define TELEM_NUM_      '#'
;#define SEPARATOR_      ','
;#define SYM_TAB_OVL_    '/'
;#define SYM_CODE_       'r'
;#define TX_TAIL_        2
;
;#include <delay.h>
;#include <stdarg.h>
;
;#define PTT     PORTB.7
;
;void set_nada(char i_nada);
;void kirim_karakter(unsigned char input);
;void kirim_paket(void);
;void ubah_nada(void);
;void hitung_crc(char in_crc);
;void kirim_crc(void);
;//unsigned char read_adc(unsigned char adc_input);
;void _itoa_(void);
;
;flash unsigned char data_1[21] =
;{
;        ('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),('0'<<1),
;        ('S'<<1),('E'<<1),('R'<<1),('M'<<1),('O'<<1),(' '<<1),('0'<<1),
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1
;};
;flash char posisi_lat[8] =
;{
;        '0','7','4','9','.','4','8','S'
;};
;flash char posisi_long[9] =
;{
;        '1','1','0','0','7','.','4','0','E'
;};
;flash unsigned char def_t[43] =
;{
;        ":SERMO    :PARM.Level,Cahaya,Piezo1,Piezo2"
;};
;flash unsigned char unit_t[37] =
;{
;        ":SERMO    :UNIT.meter,Volt,Volt,Volt"
;};
;flash unsigned char eqn_t[62] =
;{
;        ":SERMO    :EQNS.0,0.004,0,0,0.019,0,0,0.019,0,0,0.019,0,0,1,0"
;};
;eeprom char beacon_stat = 0;
;//char xcount = 0;
;bit nada = _1200;
;static char bit_stuff = 0;
;unsigned short crc;
;
;#ifndef        _1200
;#error        "KONSTANTA _1200 BELUM TERDEFINISI"
;#endif
;
;#ifndef        _2200
;#error        "KONSTANTA _2200 BELUM TERDEFINISI"
;#endif
;
;#ifndef        CONST_1200
;#error        "KONSTANTA CONST_1200 BELUM TERDEFINISI"
;#endif
;
;#ifndef        CONST_2200
;#error        "KONSTANTA CONST_2200 BELUM TERDEFINISI"
;#endif
;
;#ifndef        GAP_TIME_
;#error        "KONSTANTA GAP_TIME_ BELUM TERDEFINISI"
;#endif
;
;#if        (GAP_TIME_ < 15)
;//#error        "GAP_TIME_ harus bernilai antara 15 - 60. GAP_TIME_ yang terlalu singkat menyebabkan kepadatan traffic"
;#endif
;#if        (GAP_TIME_ > 60)
;#error        "GAP_TIME_ harus bernilai antara 15 - 60. GAP_TIME_ yang terlalu panjang menyebabkan 'loose of track'  "
;#endif
;
;//        AKHIR DARI KONSTANTA EVALUATOR
;
;eeprom static uint16_t idx = 150;
;eeprom static int _idx[3];
;eeprom static unsigned char s1 = 0;
;eeprom static unsigned char s2 = 0;
;eeprom static unsigned char s3 = 0;
;eeprom static unsigned char s4 = 0;
;eeprom static unsigned char _ch1[3];
;eeprom static unsigned char _ch2[3];
;eeprom static unsigned char _ch3[3];
;eeprom static unsigned char _ch4[3];
;
;
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0093 {

	.CSEG
_read_adc:
; 0000 0094     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 0095 
; 0000 0096     // Delay needed for the stabilization of the ADC input voltage
; 0000 0097     delay_us(10);
	__DELAY_USB 37
; 0000 0098 
; 0000 0099     // Start the AD conversion
; 0000 009A     ADCSRA|=0x40;
	SBI  0x6,6
; 0000 009B 
; 0000 009C     // Wait for the AD conversion to complete
; 0000 009D     while ((ADCSRA & 0x10)==0);
_0x3:
	SBIS 0x6,4
	RJMP _0x3
; 0000 009E     ADCSRA|=0x10;
	SBI  0x6,4
; 0000 009F 
; 0000 00A0     return ADCH;
	IN   R30,0x5
	RJMP _0x2000001
; 0000 00A1 }
;
;void _itoa_(void)
; 0000 00A4 {
__itoa_:
; 0000 00A5         static int rat,pul,sat;
; 0000 00A6         static int idx_buff;
; 0000 00A7 
; 0000 00A8         rat = s1 / 100;
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x1
; 0000 00A9         s1 = s1 % 100;
	RCALL SUBOPT_0x0
	CALL __MODW21
	RCALL SUBOPT_0x2
; 0000 00AA         pul = s1 / 10;
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 00AB         sat = s1 % 10;
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x5
; 0000 00AC 
; 0000 00AD         _ch1[0] = rat + '0';
	LDI  R26,LOW(__ch1_G000)
	LDI  R27,HIGH(__ch1_G000)
	CALL __EEPROMWRB
; 0000 00AE         _ch1[1] = pul + '0';
	__POINTW2MN __ch1_G000,1
	RCALL SUBOPT_0x6
; 0000 00AF         _ch1[2] = sat + '0';
	__POINTW2MN __ch1_G000,2
	RCALL SUBOPT_0x7
; 0000 00B0 
; 0000 00B1         rat = s2 / 100;
	RCALL SUBOPT_0x8
	RCALL SUBOPT_0x1
; 0000 00B2         s2 = s2 % 100;
	RCALL SUBOPT_0x8
	CALL __MODW21
	RCALL SUBOPT_0x9
; 0000 00B3         pul = s2 / 10;
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x4
; 0000 00B4         sat = s2 % 10;
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x5
; 0000 00B5 
; 0000 00B6         _ch2[0] = rat + '0';
	LDI  R26,LOW(__ch2_G000)
	LDI  R27,HIGH(__ch2_G000)
	CALL __EEPROMWRB
; 0000 00B7         _ch2[1] = pul + '0';
	__POINTW2MN __ch2_G000,1
	RCALL SUBOPT_0x6
; 0000 00B8         _ch2[2] = sat + '0';
	__POINTW2MN __ch2_G000,2
	RCALL SUBOPT_0x7
; 0000 00B9 
; 0000 00BA         rat = s3 / 100;
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0x1
; 0000 00BB         s3 = s3 % 100;
	RCALL SUBOPT_0xB
	CALL __MODW21
	RCALL SUBOPT_0xC
; 0000 00BC         pul = s3 / 10;
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x4
; 0000 00BD         sat = s3 % 10;
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x5
; 0000 00BE 
; 0000 00BF         _ch3[0] = rat + '0';
	LDI  R26,LOW(__ch3_G000)
	LDI  R27,HIGH(__ch3_G000)
	CALL __EEPROMWRB
; 0000 00C0         _ch3[1] = pul + '0';
	__POINTW2MN __ch3_G000,1
	RCALL SUBOPT_0x6
; 0000 00C1         _ch3[2] = sat + '0';
	__POINTW2MN __ch3_G000,2
	RCALL SUBOPT_0x7
; 0000 00C2 
; 0000 00C3         rat = s4 / 100;
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0x1
; 0000 00C4         s4 = s4 % 100;
	RCALL SUBOPT_0xE
	CALL __MODW21
	RCALL SUBOPT_0xF
; 0000 00C5         pul = s4 / 10;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x4
; 0000 00C6         sat = s4 % 10;
	RCALL SUBOPT_0x10
	RCALL SUBOPT_0x5
; 0000 00C7 
; 0000 00C8         _ch4[0] = rat + '0';
	LDI  R26,LOW(__ch4_G000)
	LDI  R27,HIGH(__ch4_G000)
	CALL __EEPROMWRB
; 0000 00C9         _ch4[1] = pul + '0';
	__POINTW2MN __ch4_G000,1
	RCALL SUBOPT_0x6
; 0000 00CA         _ch4[2] = sat + '0';
	__POINTW2MN __ch4_G000,2
	RCALL SUBOPT_0x7
; 0000 00CB 
; 0000 00CC         idx_buff = idx;
	RCALL SUBOPT_0x11
	RCALL SUBOPT_0x12
; 0000 00CD 
; 0000 00CE         rat = idx_buff / 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x1
; 0000 00CF         idx_buff = idx_buff % 100;
	LDS  R26,_idx_buff_S0000001000
	LDS  R27,_idx_buff_S0000001000+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __MODW21
	RCALL SUBOPT_0x12
; 0000 00D0         pul = idx_buff / 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x4
; 0000 00D1         sat = idx_buff % 10;
	LDS  R26,_idx_buff_S0000001000
	LDS  R27,_idx_buff_S0000001000+1
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	STS  _sat_S0000001000,R30
	STS  _sat_S0000001000+1,R31
; 0000 00D2 
; 0000 00D3         _idx[0] = rat + '0';
	LDS  R30,_rat_S0000001000
	LDS  R31,_rat_S0000001000+1
	ADIW R30,48
	LDI  R26,LOW(__idx_G000)
	LDI  R27,HIGH(__idx_G000)
	CALL __EEPROMWRW
; 0000 00D4         _idx[1] = pul + '0';
	__POINTW2MN __idx_G000,2
	LDS  R30,_pul_S0000001000
	LDS  R31,_pul_S0000001000+1
	ADIW R30,48
	CALL __EEPROMWRW
; 0000 00D5         _idx[2] = sat + '0';
	__POINTW2MN __idx_G000,4
	LDS  R30,_sat_S0000001000
	LDS  R31,_sat_S0000001000+1
	ADIW R30,48
	CALL __EEPROMWRW
; 0000 00D6 }
	RET
;
;void kirim_paket(void)
; 0000 00D9 {
_kirim_paket:
; 0000 00DA         char i;
; 0000 00DB 
; 0000 00DC         //crc = 0xFFFF;
; 0000 00DD         beacon_stat++;
	ST   -Y,R17
;	i -> R17
	RCALL SUBOPT_0x13
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 00DE         PTT = 1;
	SBI  0x18,7
; 0000 00DF         //delay_ms(100);
; 0000 00E0 
; 0000 00E1 
; 0000 00E2         for(i=0;i<TX_DELAY_;i++)
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,45
	BRSH _0xA
; 0000 00E3         	kirim_karakter(0x00);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _kirim_karakter
	SUBI R17,-1
	RJMP _0x9
_0xA:
; 0000 00E5 crc = 0xFFFF;
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R4,R30
; 0000 00E6 
; 0000 00E7         kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00E8 
; 0000 00E9         bit_stuff = 0;
	LDI  R30,LOW(0)
	STS  _bit_stuff_G000,R30
; 0000 00EA 
; 0000 00EB         for(i=0;i<21;i++)
	LDI  R17,LOW(0)
_0xC:
	CPI  R17,21
	BRSH _0xD
; 0000 00EC                 kirim_karakter(data_1[i]);
	RCALL SUBOPT_0x14
	SUBI R30,LOW(-_data_1*2)
	SBCI R31,HIGH(-_data_1*2)
	RCALL SUBOPT_0x15
	SUBI R17,-1
	RJMP _0xC
_0xD:
; 0000 00EE kirim_karakter(0x03);
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00EF 
; 0000 00F0                 kirim_karakter(PROTOCOL_ID_);
	LDI  R30,LOW(240)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00F1 
; 0000 00F2         if(beacon_stat == 20)
	RCALL SUBOPT_0x13
	CPI  R30,LOW(0x14)
	BRNE _0xE
; 0000 00F3         {
; 0000 00F4                 kirim_karakter(TD_POSISI_);
	LDI  R30,LOW(33)
	RCALL SUBOPT_0x16
; 0000 00F5 
; 0000 00F6                 for(i=0;i<8;i++)
_0x10:
	CPI  R17,8
	BRSH _0x11
; 0000 00F7                 kirim_karakter(posisi_lat[i]);
	RCALL SUBOPT_0x14
	SUBI R30,LOW(-_posisi_lat*2)
	SBCI R31,HIGH(-_posisi_lat*2)
	RCALL SUBOPT_0x15
	SUBI R17,-1
	RJMP _0x10
_0x11:
; 0000 00F9 kirim_karakter('/');
	LDI  R30,LOW(47)
	RCALL SUBOPT_0x16
; 0000 00FA 
; 0000 00FB                 for(i=0;i<9;i++)
_0x13:
	CPI  R17,9
	BRSH _0x14
; 0000 00FC                 kirim_karakter(posisi_long[i]);
	RCALL SUBOPT_0x14
	SUBI R30,LOW(-_posisi_long*2)
	SBCI R31,HIGH(-_posisi_long*2)
	RCALL SUBOPT_0x15
	SUBI R17,-1
	RJMP _0x13
_0x14:
; 0000 00FE kirim_karakter('r');
	LDI  R30,LOW(114)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 00FF         }
; 0000 0100 
; 0000 0101         else if(beacon_stat == 21)
	RJMP _0x15
_0xE:
	RCALL SUBOPT_0x13
	CPI  R30,LOW(0x15)
	BRNE _0x16
; 0000 0102                 for(i=0;i<42;i++)       kirim_karakter(def_t[i]);
	LDI  R17,LOW(0)
_0x18:
	CPI  R17,42
	BRSH _0x19
	RCALL SUBOPT_0x14
	SUBI R30,LOW(-_def_t*2)
	SBCI R31,HIGH(-_def_t*2)
	RCALL SUBOPT_0x15
	SUBI R17,-1
	RJMP _0x18
_0x19:
; 0000 0104 else if(beacon_stat == 22)
	RJMP _0x1A
_0x16:
	RCALL SUBOPT_0x13
	CPI  R30,LOW(0x16)
	BRNE _0x1B
; 0000 0105                 for(i=0;i<61;i++)       kirim_karakter(eqn_t[i]);
	LDI  R17,LOW(0)
_0x1D:
	CPI  R17,61
	BRSH _0x1E
	RCALL SUBOPT_0x14
	SUBI R30,LOW(-_eqn_t*2)
	SBCI R31,HIGH(-_eqn_t*2)
	RCALL SUBOPT_0x15
	SUBI R17,-1
	RJMP _0x1D
_0x1E:
; 0000 0107 else if(beacon_stat == 23)
	RJMP _0x1F
_0x1B:
	RCALL SUBOPT_0x13
	CPI  R30,LOW(0x17)
	BRNE _0x20
; 0000 0108                 for(i=0;i<36;i++)       kirim_karakter(unit_t[i]);
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,36
	BRSH _0x23
	RCALL SUBOPT_0x14
	SUBI R30,LOW(-_unit_t*2)
	SBCI R31,HIGH(-_unit_t*2)
	RCALL SUBOPT_0x15
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 010A else if(beacon_stat == 25)
	RJMP _0x24
_0x20:
	RCALL SUBOPT_0x13
	CPI  R30,LOW(0x19)
	BRNE _0x25
; 0000 010B                 beacon_stat = 0;
	LDI  R26,LOW(_beacon_stat)
	LDI  R27,HIGH(_beacon_stat)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 010C         else
	RJMP _0x26
_0x25:
; 0000 010D         {
; 0000 010E                         kirim_karakter(TD_TELEM_);
	LDI  R30,LOW(84)
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 010F                         kirim_karakter(TELEM_NUM_);
	LDI  R30,LOW(35)
	RCALL SUBOPT_0x16
; 0000 0110                 for(i=0;i<3;i++)
_0x28:
	CPI  R17,3
	BRSH _0x29
; 0000 0111                         kirim_karakter(_idx[i]);
	MOV  R30,R17
	LDI  R26,LOW(__idx_G000)
	LDI  R27,HIGH(__idx_G000)
	LDI  R31,0
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	RCALL SUBOPT_0x17
	SUBI R17,-1
	RJMP _0x28
_0x29:
; 0000 0112 kirim_karakter(',');
	LDI  R30,LOW(44)
	RCALL SUBOPT_0x16
; 0000 0113                 for(i=0;i<3;i++)
_0x2B:
	CPI  R17,3
	BRSH _0x2C
; 0000 0114                         kirim_karakter(_ch1[i]);
	RCALL SUBOPT_0x18
	SUBI R26,LOW(-__ch1_G000)
	SBCI R27,HIGH(-__ch1_G000)
	RCALL SUBOPT_0x17
	SUBI R17,-1
	RJMP _0x2B
_0x2C:
; 0000 0115 kirim_karakter(',');
	LDI  R30,LOW(44)
	RCALL SUBOPT_0x16
; 0000 0116                 for(i=0;i<3;i++)
_0x2E:
	CPI  R17,3
	BRSH _0x2F
; 0000 0117                         kirim_karakter(_ch2[i]);
	RCALL SUBOPT_0x18
	SUBI R26,LOW(-__ch2_G000)
	SBCI R27,HIGH(-__ch2_G000)
	RCALL SUBOPT_0x17
	SUBI R17,-1
	RJMP _0x2E
_0x2F:
; 0000 0118 kirim_karakter(',');
	LDI  R30,LOW(44)
	RCALL SUBOPT_0x16
; 0000 0119                 for(i=0;i<3;i++)
_0x31:
	CPI  R17,3
	BRSH _0x32
; 0000 011A                         kirim_karakter(_ch3[i]);
	RCALL SUBOPT_0x18
	SUBI R26,LOW(-__ch3_G000)
	SBCI R27,HIGH(-__ch3_G000)
	RCALL SUBOPT_0x17
	SUBI R17,-1
	RJMP _0x31
_0x32:
; 0000 011B kirim_karakter(',');
	LDI  R30,LOW(44)
	RCALL SUBOPT_0x16
; 0000 011C                 for(i=0;i<3;i++)
_0x34:
	CPI  R17,3
	BRSH _0x35
; 0000 011D                         kirim_karakter(_ch4[i]);
	RCALL SUBOPT_0x18
	SUBI R26,LOW(-__ch4_G000)
	SBCI R27,HIGH(-__ch4_G000)
	RCALL SUBOPT_0x17
	SUBI R17,-1
	RJMP _0x34
_0x35:
; 0000 011E kirim_karakter(',');
	LDI  R30,LOW(44)
	RCALL SUBOPT_0x16
; 0000 011F                 for(i=0;i<3;i++)
_0x37:
	CPI  R17,3
	BRSH _0x38
; 0000 0120                         kirim_karakter('0');
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL _kirim_karakter
	SUBI R17,-1
	RJMP _0x37
_0x38:
; 0000 0121 kirim_karakter(',');
	LDI  R30,LOW(44)
	RCALL SUBOPT_0x16
; 0000 0122                 for(i=0;i<8;i++)
_0x3A:
	CPI  R17,8
	BRSH _0x3B
; 0000 0123                         kirim_karakter('0');
	LDI  R30,LOW(48)
	ST   -Y,R30
	RCALL _kirim_karakter
	SUBI R17,-1
	RJMP _0x3A
_0x3B:
; 0000 0125 }
_0x26:
_0x24:
_0x1F:
_0x1A:
_0x15:
; 0000 0126 
; 0000 0127         kirim_crc();
	RCALL _kirim_crc
; 0000 0128 
; 0000 0129         kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x16
; 0000 012A 
; 0000 012B         for(i=0;i<TX_TAIL_;i++)
_0x3D:
	CPI  R17,2
	BRSH _0x3E
; 0000 012C         	kirim_karakter(0x00);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _kirim_karakter
	SUBI R17,-1
	RJMP _0x3D
_0x3E:
; 0000 012D PORTB.7 = 0;
	CBI  0x18,7
; 0000 012E 
; 0000 012F 
; 0000 0130 }       // EndOf void kirim_paket(void)
	LD   R17,Y+
	RET
;
;
;/***************************************************************************************/
;        void                         kirim_crc(void)
; 0000 0135 /***************************************************************************************
; 0000 0136 *        ABSTRAKSI          :         Pengendali urutan pengiriman data CRC-16 CCITT Penyusun
; 0000 0137 *                                nilai 8 MSB dan 8 LSB dari nilai CRC yang telah dihitung.
; 0000 0138 *                                Generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
; 0000 0139 *                                leading one.
; 0000 013A *
; 0000 013B *        INPUT                :        tak ada
; 0000 013C *        OUTPUT                :       tak ada
; 0000 013D *        RETURN                :       tak ada
; 0000 013E */
; 0000 013F {
_kirim_crc:
; 0000 0140         static unsigned char crc_lo;
; 0000 0141         static unsigned char crc_hi;
; 0000 0142 
; 0000 0143         // Exor-kan nilai CRC terakhir dengan 0xFF, masukkan ke 8 LSB
; 0000 0144         crc_lo = crc ^ 0xFF;
	LDI  R30,LOW(255)
	EOR  R30,R4
	STS  _crc_lo_S0000003000,R30
; 0000 0145 
; 0000 0146         // geser kanan 8 bit dan Exor-kan nilai CRC terakhir dengan 0xFF, masukkan ke 8 MSB
; 0000 0147         crc_hi = (crc >> 8) ^ 0xFF;
	MOV  R30,R5
	ANDI R31,HIGH(0x0)
	LDI  R26,LOW(255)
	EOR  R30,R26
	STS  _crc_hi_S0000003000,R30
; 0000 0148 
; 0000 0149         // kirim 8 LSB
; 0000 014A         kirim_karakter(crc_lo);
	LDS  R30,_crc_lo_S0000003000
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 014B 
; 0000 014C         // kirim 8 MSB
; 0000 014D         kirim_karakter(crc_hi);
	LDS  R30,_crc_hi_S0000003000
	ST   -Y,R30
	RCALL _kirim_karakter
; 0000 014E 
; 0000 014F }       // EndOf void kirim_crc(void)
	RET
;
;
;/***************************************************************************************/
;        void                         kirim_karakter(unsigned char input)
; 0000 0154 /***************************************************************************************
; 0000 0155 *        ABSTRAKSI          :         mengirim data APRS karakter-demi-karakter, menghitung FCS
; 0000 0156 *                                field dan melakukan bit stuffing. Polarisasi data adalah
; 0000 0157 *                                NRZI (Non Return to Zero, Inverted). Bit dikirimkan sebagai
; 0000 0158 *                                bit terakhir yang ditahan jika bit masukan adalah bit 1.
; 0000 0159 *                                Bit dikirimkan sebagai bit terakhir yang di-invert jika bit
; 0000 015A *                                masukan adalah bit 0. Tone 1200Hz dan 2200Hz masing - masing
; 0000 015B *                                 merepresentasikan bit 0 dan 1 atau sebaliknya. Polarisasi
; 0000 015C *                                tone adalah tidak penting dalam polarisasi data NRZI.
; 0000 015D *
; 0000 015E *              INPUT                :        byte data protokol APRS
; 0000 015F *        OUTPUT                :       tak ada
; 0000 0160 *        RETURN                :       tak ada
; 0000 0161 */
; 0000 0162 {
_kirim_karakter:
	PUSH R15
; 0000 0163         char i;
; 0000 0164         bit in_bit;
; 0000 0165 
; 0000 0166         // kirimkan setiap byte data (8 bit)
; 0000 0167         for(i=0;i<8;i++)
	ST   -Y,R17
;	input -> Y+1
;	i -> R17
;	in_bit -> R15.0
	LDI  R17,LOW(0)
_0x42:
	CPI  R17,8
	BRSH _0x43
; 0000 0168         {
; 0000 0169                 // ambil 1 bit berurutan dari LSB ke MSB setiap perulangan for 0 - 7
; 0000 016A                 in_bit = (input >> i) & 0x01;
	LDD  R26,Y+1
	LDI  R27,0
	MOV  R30,R17
	CALL __ASRW12
	BST  R30,0
	BLD  R15,0
; 0000 016B 
; 0000 016C                 // jika data adalah flag, nol-kan pengingat bit stuffing
; 0000 016D                 if(input==0x7E)        {bit_stuff = 0;}
	LDD  R26,Y+1
	CPI  R26,LOW(0x7E)
	BRNE _0x44
	LDI  R30,LOW(0)
	STS  _bit_stuff_G000,R30
; 0000 016E 
; 0000 016F                 // jika bukan flag, hitung nilai CRC dari bit data saat ini
; 0000 0170                 else                {hitung_crc(in_bit);}
	RJMP _0x45
_0x44:
	LDI  R30,0
	SBRC R15,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _hitung_crc
_0x45:
; 0000 0171 
; 0000 0172                 // jika bit data saat ini adalah
; 0000 0173                 // nol
; 0000 0174                 if(!in_bit)
	SBRS R15,0
; 0000 0175                 {        // jika ya
; 0000 0176                         // ubah tone dan bentuk gelombang sinus
; 0000 0177                         ubah_nada();
	RJMP _0x64
; 0000 0178 
; 0000 0179                         // nol-kan pengingat bit stuffing
; 0000 017A                         bit_stuff = 0;
; 0000 017B                 }
; 0000 017C                 // satu
; 0000 017D                 else
; 0000 017E                 {        // jika ya
; 0000 017F                         // jaga tone dan bentuk gelombang sinus
; 0000 0180                         set_nada(nada);
	RCALL SUBOPT_0x19
; 0000 0181 
; 0000 0182                         // hitung sebagai bit stuffing (bit satu berurut) tambahkan 1 nilai bit stuffing
; 0000 0183                         bit_stuff++;
	LDS  R30,_bit_stuff_G000
	SUBI R30,-LOW(1)
	STS  _bit_stuff_G000,R30
; 0000 0184 
; 0000 0185                         // jika sudah terjadi bit satu berurut sebanyak 5 kali
; 0000 0186                         if(bit_stuff==5)
	LDS  R26,_bit_stuff_G000
	CPI  R26,LOW(0x5)
	BRNE _0x48
; 0000 0187                         {
; 0000 0188                                 // kirim bit nol :
; 0000 0189                                 // ubah tone dan bentuk gelombang sinus
; 0000 018A                                 ubah_nada();
_0x64:
	RCALL _ubah_nada
; 0000 018B 
; 0000 018C                                 // nol-kan pengingat bit stuffing
; 0000 018D                                 bit_stuff = 0;
	LDI  R30,LOW(0)
	STS  _bit_stuff_G000,R30
; 0000 018E 
; 0000 018F                         }
; 0000 0190                 }
_0x48:
; 0000 0191         }
	SUBI R17,-1
	RJMP _0x42
_0x43:
; 0000 0192 
; 0000 0193 }      // EndOf void kirim_karakter(unsigned char input)
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;
;/***************************************************************************************/
;        void                         hitung_crc(char in_crc)
; 0000 0198 /***************************************************************************************
; 0000 0199 *        ABSTRAKSI          :         menghitung nilai CRC-16 CCITT dari tiap bit data yang terkirim,
; 0000 019A *                                generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
; 0000 019B *                                leading one
; 0000 019C *
; 0000 019D *              INPUT                :        bit data yang terkirim
; 0000 019E *        OUTPUT                :       tak ada
; 0000 019F *        RETURN                :       tak ada
; 0000 01A0 */
; 0000 01A1 {
_hitung_crc:
; 0000 01A2         static unsigned short xor_in;
; 0000 01A3 
; 0000 01A4         // simpan nilai Exor dari CRC sementara dengan bit data yang baru terkirim
; 0000 01A5         xor_in = crc ^ in_crc;
;	in_crc -> Y+0
	LD   R30,Y
	LDI  R31,0
	EOR  R30,R4
	EOR  R31,R5
	STS  _xor_in_S0000005000,R30
	STS  _xor_in_S0000005000+1,R31
; 0000 01A6 
; 0000 01A7         // geser kanan nilai CRC sebanyak 1 bit
; 0000 01A8         crc >>= 1;
	LSR  R5
	ROR  R4
; 0000 01A9 
; 0000 01AA         // jika hasil nilai Exor di-and-kan dengan satu bernilai satu
; 0000 01AB         if(xor_in & 0x01)
	LDS  R30,_xor_in_S0000005000
	ANDI R30,LOW(0x1)
	BREQ _0x49
; 0000 01AC                 // maka nilai CRC di-Exor-kan dengan generator polinomial
; 0000 01AD                 crc ^= 0x8408;
	LDI  R30,LOW(33800)
	LDI  R31,HIGH(33800)
	__EORWRR 4,5,30,31
; 0000 01AE 
; 0000 01AF }      // EndOf void hitung_crc(char in_crc)
_0x49:
	RJMP _0x2000001
;
;
;/***************************************************************************************/
;        void                         ubah_nada(void)
; 0000 01B4 /***************************************************************************************
; 0000 01B5 *        ABSTRAKSI          :         Menukar seting tone terakhir dengan tone yang baru. Tone
; 0000 01B6 *                                1200Hz dan 2200Hz masing - masing merepresentasikan bit
; 0000 01B7 *                                0 dan 1 atau sebaliknya. Polarisasi tone adalah tidak
; 0000 01B8 *                                penting dalam polarisasi data NRZI.
; 0000 01B9 *
; 0000 01BA *              INPUT                :        tak ada
; 0000 01BB *        OUTPUT                :       tak ada
; 0000 01BC *        RETURN                :       tak ada
; 0000 01BD */
; 0000 01BE {
_ubah_nada:
; 0000 01BF         // jika tone terakhir adalah :
; 0000 01C0         // 1200Hz
; 0000 01C1         if(nada ==_1200)
	SBRC R2,0
	RJMP _0x4A
; 0000 01C2         {        // jika ya
; 0000 01C3                 // ubah tone saat ini menjadi 2200Hz
; 0000 01C4                 nada = _2200;
	SET
	RJMP _0x65
; 0000 01C5 
; 0000 01C6                 // bangkitkan gelombang sinus 2200Hz
; 0000 01C7                 set_nada(nada);
; 0000 01C8         }
; 0000 01C9         // 2200Hz
; 0000 01CA         else
_0x4A:
; 0000 01CB         {        // jika ya
; 0000 01CC                 // ubah tone saat ini menjadi 1200Hz
; 0000 01CD                 nada = _1200;
	CLT
_0x65:
	BLD  R2,0
; 0000 01CE 
; 0000 01CF                 // bangkitkan gelombang sinus 1200Hz
; 0000 01D0                 set_nada(nada);
	RCALL SUBOPT_0x19
; 0000 01D1         }
; 0000 01D2 
; 0000 01D3 }       // EndOf void ubah_nada(void)
	RET
;
;
;
;/***************************************************************************************/
;        void                         set_nada(char i_nada)
; 0000 01D9 /***************************************************************************************
; 0000 01DA *        ABSTRAKSI          :         Membentuk baudrate serta frekensi tone 1200Hz dan 2200Hz
; 0000 01DB *                                dari konstanta waktu. Men-setting nilai DAC. Lakukan fine
; 0000 01DC *                                tuning pada jumlah masing - masing perulangan for dan
; 0000 01DD *                                konstanta waktu untuk meng-adjust parameter baudrate dan
; 0000 01DE *                                frekuensi tone.
; 0000 01DF *
; 0000 01E0 *              INPUT                :        nilai frekuensi tone yang akan ditransmisikan
; 0000 01E1 *        OUTPUT                :       nilai DAC
; 0000 01E2 *        RETURN                :       tak ada
; 0000 01E3 */
; 0000 01E4 {
_set_nada:
; 0000 01E5         //char i;
; 0000 01E6 
; 0000 01E7         // jika frekuensi tone yang akan segera dipancarkan adalah :
; 0000 01E8         // 1200Hz
; 0000 01E9         if(i_nada == _1200)
;	i_nada -> Y+0
	LD   R30,Y
	CPI  R30,0
	BRNE _0x4C
; 0000 01EA         {
; 0000 01EB                 // jika ya
; 0000 01EC                 PORTD.1 = 1;
	SBI  0x12,1
; 0000 01ED                 delay_us(CONST_BAUD);
	RJMP _0x66
; 0000 01EE         }
; 0000 01EF         // 2200Hz
; 0000 01F0         else
_0x4C:
; 0000 01F1         {
; 0000 01F2                 // jika ya
; 0000 01F3                 PORTD.1 = 0;
	CBI  0x12,1
; 0000 01F4                 delay_us(CONST_BAUD);
_0x66:
	__DELAY_USW 2267
; 0000 01F5         }
; 0000 01F6 
; 0000 01F7 }         // EndOf void set_nada(char i_nada)
_0x2000001:
	ADIW R28,1
	RET
;
;// Declare your global variables here
;
;void ambil_data(void)
; 0000 01FC {
_ambil_data:
; 0000 01FD         unsigned int bs1 = 0,bs2 = 0,bs3 = 0,bs4 = 0;
; 0000 01FE 
; 0000 01FF         int i;
; 0000 0200 
; 0000 0201         for(i=0;i<100;i++)
	SBIW R28,4
	LDI  R30,LOW(0)
	STD  Y+2,R30
	STD  Y+3,R30
	CALL __SAVELOCR6
;	bs1 -> R16,R17
;	bs2 -> R18,R19
;	bs3 -> R20,R21
;	bs4 -> Y+8
;	i -> Y+6
	__GETWRN 16,17,0
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	STD  Y+6,R30
	STD  Y+6+1,R30
_0x53:
	RCALL SUBOPT_0x1A
	BRGE _0x54
; 0000 0202         {
; 0000 0203                 bs1 = bs1 + read_adc(0);
	RCALL SUBOPT_0x1B
; 0000 0204                 bs2 = bs2 + read_adc(1);
; 0000 0205                 bs3 = bs3 + read_adc(2);
; 0000 0206                 bs4 = bs4 + read_adc(3);
; 0000 0207 
; 0000 0208                 delay_ms(25);
; 0000 0209         }
	RCALL SUBOPT_0x1C
	RJMP _0x53
_0x54:
; 0000 020A 
; 0000 020B         s1 = bs1 / 100;
	RCALL SUBOPT_0x1D
; 0000 020C         s2 = bs2 / 100;
	RCALL SUBOPT_0x1E
; 0000 020D         s3 = bs3 / 100;
	RCALL SUBOPT_0x1F
; 0000 020E         s4 = bs4 / 100;
	RCALL SUBOPT_0x20
; 0000 020F 
; 0000 0210         bs1 = s1;
	RCALL SUBOPT_0x21
; 0000 0211         bs2 = s2;
; 0000 0212         bs3 = s3;
; 0000 0213         bs4 = s4;
; 0000 0214 
; 0000 0215         for(i=0;i<100;i++)
_0x56:
	RCALL SUBOPT_0x1A
	BRGE _0x57
; 0000 0216         {
; 0000 0217                 bs1 = bs1 + read_adc(0);
	RCALL SUBOPT_0x1B
; 0000 0218                 bs2 = bs2 + read_adc(1);
; 0000 0219                 bs3 = bs3 + read_adc(2);
; 0000 021A                 bs4 = bs4 + read_adc(3);
; 0000 021B 
; 0000 021C                 delay_ms(25);
; 0000 021D         }
	RCALL SUBOPT_0x1C
	RJMP _0x56
_0x57:
; 0000 021E 
; 0000 021F         s1 = bs1 / 100;
	RCALL SUBOPT_0x1D
; 0000 0220         s2 = bs2 / 100;
	RCALL SUBOPT_0x1E
; 0000 0221         s3 = bs3 / 100;
	RCALL SUBOPT_0x1F
; 0000 0222         s4 = bs4 / 100;
	RCALL SUBOPT_0x20
; 0000 0223 
; 0000 0224         bs1 = s1;
	RCALL SUBOPT_0x21
; 0000 0225         bs2 = s2;
; 0000 0226         bs3 = s3;
; 0000 0227         bs4 = s4;
; 0000 0228 
; 0000 0229         for(i=0;i<100;i++)
_0x59:
	RCALL SUBOPT_0x1A
	BRGE _0x5A
; 0000 022A         {
; 0000 022B                 bs1 = bs1 + read_adc(0);
	RCALL SUBOPT_0x1B
; 0000 022C                 bs2 = bs2 + read_adc(1);
; 0000 022D                 bs3 = bs3 + read_adc(2);
; 0000 022E                 bs4 = bs4 + read_adc(3);
; 0000 022F 
; 0000 0230                 delay_ms(25);
; 0000 0231         }
	RCALL SUBOPT_0x1C
	RJMP _0x59
_0x5A:
; 0000 0232 
; 0000 0233         s1 = bs1 / 100;
	RCALL SUBOPT_0x1D
; 0000 0234         s2 = bs2 / 100;
	RCALL SUBOPT_0x1E
; 0000 0235         s3 = bs3 / 100;
	RCALL SUBOPT_0x1F
; 0000 0236         s4 = bs4 / 100;
	RCALL SUBOPT_0x20
; 0000 0237 
; 0000 0238         s3 = s4 + 10;
	LDI  R26,LOW(_s4_G000)
	LDI  R27,HIGH(_s4_G000)
	CALL __EEPROMRDB
	SUBI R30,-LOW(10)
	RCALL SUBOPT_0xC
; 0000 0239 
; 0000 023A         idx++;
	RCALL SUBOPT_0x11
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 023B         if(idx > 999) idx = 0;
	RCALL SUBOPT_0x11
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRLO _0x5B
	LDI  R26,LOW(_idx_G000)
	LDI  R27,HIGH(_idx_G000)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
; 0000 023C }
_0x5B:
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;
;void main(void)
; 0000 023F {
_main:
; 0000 0240         PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0241         DDRA=0x00;
	OUT  0x1A,R30
; 0000 0242         PORTB=0x00;
	OUT  0x18,R30
; 0000 0243         DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 0244         PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0245         DDRC=0x00;
	OUT  0x14,R30
; 0000 0246         PORTD=0x03;
	LDI  R30,LOW(3)
	OUT  0x12,R30
; 0000 0247         DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 0248 
; 0000 0249         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 024A         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 024B 
; 0000 024C         ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 024D         ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 024E 
; 0000 024F         while (1)
_0x5C:
; 0000 0250         {
; 0000 0251                 // Place your code here
; 0000 0252                 delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0253 
; 0000 0254                 ambil_data();
	RCALL _ambil_data
; 0000 0255                 _itoa_();
	RCALL __itoa_
; 0000 0256 
; 0000 0257                 PORTB.7 = 1;
	SBI  0x18,7
; 0000 0258                 kirim_paket();
	RCALL _kirim_paket
; 0000 0259                 PORTB.7 = 0;
	CBI  0x18,7
; 0000 025A 
; 0000 025B                 delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 025C         }
	RJMP _0x5C
; 0000 025D }
_0x63:
	RJMP _0x63

	.ESEG
_beacon_stat:
	.DB  0x0

	.DSEG
_bit_stuff_G000:
	.BYTE 0x1

	.ESEG
_idx_G000:
	.DW  0x96
__idx_G000:
	.BYTE 0x6
_s1_G000:
	.DB  0x0
_s2_G000:
	.DB  0x0
_s3_G000:
	.DB  0x0
_s4_G000:
	.DB  0x0
__ch1_G000:
	.BYTE 0x3
__ch2_G000:
	.BYTE 0x3
__ch3_G000:
	.BYTE 0x3
__ch4_G000:
	.BYTE 0x3

	.DSEG
_rat_S0000001000:
	.BYTE 0x2
_pul_S0000001000:
	.BYTE 0x2
_sat_S0000001000:
	.BYTE 0x2
_idx_buff_S0000001000:
	.BYTE 0x2
_crc_lo_S0000003000:
	.BYTE 0x1
_crc_hi_S0000003000:
	.BYTE 0x1
_xor_in_S0000005000:
	.BYTE 0x2

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_s1_G000)
	LDI  R27,HIGH(_s1_G000)
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1:
	CALL __DIVW21
	STS  _rat_S0000001000,R30
	STS  _rat_S0000001000+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_s1_G000)
	LDI  R27,HIGH(_s1_G000)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3:
	LDI  R26,LOW(_s1_G000)
	LDI  R27,HIGH(_s1_G000)
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	CALL __DIVW21
	STS  _pul_S0000001000,R30
	STS  _pul_S0000001000+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x5:
	CALL __MODW21
	STS  _sat_S0000001000,R30
	STS  _sat_S0000001000+1,R31
	LDS  R30,_rat_S0000001000
	SUBI R30,-LOW(48)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x6:
	LDS  R30,_pul_S0000001000
	SUBI R30,-LOW(48)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x7:
	LDS  R30,_sat_S0000001000
	SUBI R30,-LOW(48)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_s2_G000)
	LDI  R27,HIGH(_s2_G000)
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_s2_G000)
	LDI  R27,HIGH(_s2_G000)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_s2_G000)
	LDI  R27,HIGH(_s2_G000)
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_s3_G000)
	LDI  R27,HIGH(_s3_G000)
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDI  R26,LOW(_s3_G000)
	LDI  R27,HIGH(_s3_G000)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_s3_G000)
	LDI  R27,HIGH(_s3_G000)
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_s4_G000)
	LDI  R27,HIGH(_s4_G000)
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDI  R26,LOW(_s4_G000)
	LDI  R27,HIGH(_s4_G000)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_s4_G000)
	LDI  R27,HIGH(_s4_G000)
	CALL __EEPROMRDB
	LDI  R31,0
	MOVW R26,R30
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_idx_G000)
	LDI  R27,HIGH(_idx_G000)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x12:
	STS  _idx_buff_S0000001000,R30
	STS  _idx_buff_S0000001000+1,R31
	LDS  R26,_idx_buff_S0000001000
	LDS  R27,_idx_buff_S0000001000+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x13:
	LDI  R26,LOW(_beacon_stat)
	LDI  R27,HIGH(_beacon_stat)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x14:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x15:
	LPM  R30,Z
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x16:
	ST   -Y,R30
	RCALL _kirim_karakter
	LDI  R17,LOW(0)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x17:
	CALL __EEPROMRDB
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x18:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	LDI  R30,0
	SBRC R2,0
	LDI  R30,1
	ST   -Y,R30
	RJMP _set_nada

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1A:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	CPI  R26,LOW(0x64)
	LDI  R30,HIGH(0x64)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R31,0
	__ADDWRR 16,17,30,31
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R31,0
	__ADDWRR 18,19,30,31
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R31,0
	__ADDWRR 20,21,30,31
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	LDI  R31,0
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDI  R30,LOW(25)
	LDI  R31,HIGH(25)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1C:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1D:
	MOVW R26,R16
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1E:
	MOVW R26,R18
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	RJMP SUBOPT_0x9

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	MOVW R26,R20
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x20:
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	RJMP SUBOPT_0xF

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_s1_G000)
	LDI  R27,HIGH(_s1_G000)
	CALL __EEPROMRDB
	MOV  R16,R30
	CLR  R17
	LDI  R26,LOW(_s2_G000)
	LDI  R27,HIGH(_s2_G000)
	CALL __EEPROMRDB
	MOV  R18,R30
	CLR  R19
	LDI  R26,LOW(_s3_G000)
	LDI  R27,HIGH(_s3_G000)
	CALL __EEPROMRDB
	MOV  R20,R30
	CLR  R21
	LDI  R26,LOW(_s4_G000)
	LDI  R27,HIGH(_s4_G000)
	CALL __EEPROMRDB
	LDI  R31,0
	STD  Y+8,R30
	STD  Y+8+1,R31
	LDI  R30,LOW(0)
	STD  Y+6,R30
	STD  Y+6+1,R30
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
