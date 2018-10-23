
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
	.DEF __lcd_x=R5
	.DEF __lcd_y=R4
	.DEF __lcd_maxx=R7

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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x2C,0x0,0x2C,0x4A,0x54,0x46
	.DB  0x5F,0x42,0x41,0x4C,0x45,0x52,0x41,0x4E
	.DB  0x54,0x45,0x2C,0x24,0x54,0x45,0x4C,0x2A
	.DB  0x2C,0x50,0x45,0x54,0x49,0x52,0x2A,0x2C
	.DB  0x0,0x2A,0x35,0x30,0x2A,0x2C,0x0,0x2C
	.DB  0x4A,0x54,0x46,0x5F,0x42,0x41,0x4C,0x45
	.DB  0x52,0x41,0x4E,0x54,0x45,0x2C,0x24,0x54
	.DB  0x45,0x4C,0x2A,0x2C,0x4F,0x4D,0x45,0x47
	.DB  0x41,0x2A,0x2C,0x0,0x2C,0x2A,0x33,0x2A
	.DB  0x2C,0x0,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x0,0x2A,0x35,0x30,0x2A
	.DB  0x0,0x2A,0x45,0x4E,0x44,0x2A,0x2C,0x0
	.DB  0x2D,0x2D,0x2D,0x2D,0x4A,0x54,0x46,0x2E
	.DB  0x55,0x47,0x4D,0x2D,0x2D,0x2D,0x2D,0x2D
	.DB  0x0,0x20,0x53,0x69,0x73,0x74,0x65,0x6D
	.DB  0x0,0x20,0x4D,0x6F,0x6E,0x69,0x74,0x6F
	.DB  0x72,0x69,0x6E,0x67,0x0,0x20,0x44,0x73
	.DB  0x2E,0x20,0x42,0x61,0x6C,0x65,0x72,0x61
	.DB  0x6E,0x74,0x65,0x0,0x20,0x47,0x6E,0x2E
	.DB  0x20,0x4D,0x65,0x72,0x61,0x70,0x69,0x20
	.DB  0x44,0x49,0x59,0x0,0x53,0x79,0x73,0x74
	.DB  0x65,0x6D,0x20,0x72,0x75,0x6E,0x6E,0x69
	.DB  0x6E,0x67,0x0,0x53,0x79,0x73,0x74,0x65
	.DB  0x6D,0x20,0x73,0x74,0x61,0x6E,0x62,0x79
	.DB  0x0,0x53,0x79,0x73,0x74,0x65,0x6D,0x20
	.DB  0x73,0x74,0x6F,0x70,0x65,0x64,0x20,0x21
	.DB  0x0,0x24,0x24,0x23,0x23,0x0,0x31,0x2E
	.DB  0x4A,0x61,0x6C,0x61,0x6E,0x6B,0x61,0x6E
	.DB  0x20,0x0,0x20,0x53,0x69,0x73,0x74,0x65
	.DB  0x6D,0x20,0x0,0x32,0x2E,0x53,0x65,0x74
	.DB  0x74,0x69,0x6E,0x67,0x20,0x74,0x72,0x65
	.DB  0x73,0x2D,0x0,0x20,0x68,0x6F,0x6C,0x64
	.DB  0x20,0x73,0x65,0x6E,0x73,0x6F,0x72,0x0
	.DB  0x33,0x2E,0x53,0x65,0x74,0x74,0x69,0x6E
	.DB  0x67,0x20,0x6A,0x75,0x6D,0x2D,0x0,0x20
	.DB  0x6C,0x61,0x68,0x20,0x73,0x65,0x6E,0x73
	.DB  0x6F,0x72,0x0,0x34,0x2E,0x4C,0x69,0x68
	.DB  0x61,0x74,0x20,0x64,0x61,0x74,0x61,0x0
	.DB  0x35,0x2E,0x41,0x6B,0x74,0x69,0x66,0x6B
	.DB  0x61,0x6E,0x20,0x0,0x36,0x2E,0x4D,0x61
	.DB  0x74,0x69,0x6B,0x61,0x6E,0x0,0x37,0x2E
	.DB  0x54,0x65,0x73,0x20,0x70,0x61,0x6E,0x63
	.DB  0x61,0x72,0x0,0x38,0x2E,0x54,0x65,0x73
	.DB  0x20,0x74,0x65,0x72,0x69,0x6D,0x61,0x0
	.DB  0x39,0x2E,0x53,0x6C,0x65,0x65,0x70,0x20
	.DB  0x6D,0x6F,0x64,0x65,0x0,0x31,0x30,0x2E
	.DB  0x57,0x61,0x6B,0x65,0x2D,0x75,0x70,0x0
	.DB  0x31,0x31,0x2E,0x0,0x31,0x32,0x2E,0x0
	.DB  0x31,0x33,0x2E,0x0,0x31,0x34,0x2E,0x0
	.DB  0x31,0x35,0x2E,0x0,0x31,0x36,0x2E,0x0
	.DB  0x72,0x65,0x63,0x65,0x69,0x76,0x69,0x6E
	.DB  0x67,0x0,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x2C,0x2C,0x4A
	.DB  0x54,0x46,0x5F,0x42,0x41,0x4C,0x45,0x52
	.DB  0x41,0x4E,0x54,0x45,0x2C,0x0,0x53,0x65
	.DB  0x6E,0x64,0x69,0x6E,0x67,0x20,0x64,0x61
	.DB  0x74,0x61,0x3A,0x0,0x74,0x69,0x70,0x65
	.DB  0x20,0x70,0x72,0x6F,0x74,0x6F,0x6B,0x6F
	.DB  0x6C,0x0,0x24,0x54,0x45,0x4C,0x2A,0x2C
	.DB  0x0,0x61,0x6C,0x61,0x6D,0x61,0x74,0x20
	.DB  0x73,0x74,0x61,0x73,0x69,0x75,0x6E,0x0
	.DB  0x54,0x45,0x4C,0x45,0x2A,0x2C,0x0,0x6D
	.DB  0x6F,0x64,0x65,0x20,0x73,0x65,0x74,0x74
	.DB  0x69,0x6E,0x67,0x0,0x53,0x4C,0x45,0x45
	.DB  0x50,0x2A,0x2C,0x0,0x57,0x41,0x4B,0x45
	.DB  0x2A,0x2C,0x0,0x74,0x69,0x70,0x65,0x20
	.DB  0x6D,0x65,0x6D,0x6F,0x72,0x69,0x0,0x69
	.DB  0x64,0x20,0x73,0x74,0x61,0x73,0x69,0x75
	.DB  0x6E,0x0,0x41,0x4E,0x53,0x2D,0x42,0x41
	.DB  0x4C,0x45,0x52,0x41,0x4E,0x54,0x45,0x2C
	.DB  0x0,0x73,0x74,0x61,0x74,0x75,0x73,0x20
	.DB  0x73,0x65,0x72,0x76,0x69,0x63,0x65,0x0
	.DB  0x41,0x4E,0x53,0x2D,0x53,0x45,0x52,0x56
	.DB  0x49,0x43,0x45,0x2C,0x0,0x41,0x4E,0x53
	.DB  0x2D,0x53,0x4C,0x45,0x45,0x50,0x2C,0x0
	.DB  0x64,0x61,0x74,0x61,0x20,0x31,0x20,0x6B
	.DB  0x6F,0x6E,0x64,0x75,0x6B,0x74,0x69,0x66
	.DB  0x69,0x74,0x61,0x73,0x0,0x41,0x4E,0x53
	.DB  0x2D,0x31,0x0,0x64,0x61,0x74,0x61,0x20
	.DB  0x32,0x20,0x6B,0x6F,0x6E,0x64,0x75,0x6B
	.DB  0x74,0x69,0x66,0x69,0x74,0x61,0x73,0x0
	.DB  0x41,0x4E,0x53,0x2D,0x32,0x0,0x64,0x61
	.DB  0x74,0x61,0x20,0x33,0x20,0x6B,0x6F,0x6E
	.DB  0x64,0x75,0x6B,0x74,0x69,0x66,0x69,0x74
	.DB  0x61,0x73,0x0,0x41,0x4E,0x53,0x2D,0x33
	.DB  0x0,0x6B,0x69,0x72,0x69,0x6D,0x20,0x64
	.DB  0x61,0x74,0x61,0x20,0x73,0x65,0x6B,0x61
	.DB  0x72,0x61,0x6E,0x67,0x0,0x6D,0x6F,0x64
	.DB  0x65,0x20,0x73,0x6C,0x65,0x65,0x70,0x0
	.DB  0x4E,0x41,0x4E,0x53,0x2C,0x0,0x53,0x45
	.DB  0x4C,0x45,0x53,0x41,0x49,0x0,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x14
	.DW  _0x9
	.DW  _0x0*2

	.DW  0x1D
	.DW  _0x9+20
	.DW  _0x0*2+20

	.DW  0x06
	.DW  _0x9+49
	.DW  _0x0*2+49

	.DW  0x1D
	.DW  _0x9+55
	.DW  _0x0*2+55

	.DW  0x06
	.DW  _0x9+84
	.DW  _0x0*2+84

	.DW  0x0A
	.DW  _0x9+90
	.DW  _0x0*2+90

	.DW  0x1D
	.DW  _0x15
	.DW  _0x0*2+20

	.DW  0x05
	.DW  _0x15+29
	.DW  _0x0*2+100

	.DW  0x07
	.DW  _0x15+34
	.DW  _0x0*2+105

	.DW  0x1D
	.DW  _0x15+41
	.DW  _0x0*2+55

	.DW  0x06
	.DW  _0x15+70
	.DW  _0x0*2+84

	.DW  0x05
	.DW  _0x80
	.DW  _0x0*2+225

	.DW  0x0C
	.DW  _0x93
	.DW  _0x0*2+230

	.DW  0x09
	.DW  _0x93+12
	.DW  _0x0*2+242

	.DW  0x10
	.DW  _0x94
	.DW  _0x0*2+251

	.DW  0x0D
	.DW  _0x94+16
	.DW  _0x0*2+267

	.DW  0x0F
	.DW  _0x95
	.DW  _0x0*2+280

	.DW  0x0C
	.DW  _0x95+15
	.DW  _0x0*2+295

	.DW  0x0D
	.DW  _0x96
	.DW  _0x0*2+307

	.DW  0x08
	.DW  _0x96+13
	.DW  _0x0*2+272

	.DW  0x0C
	.DW  _0x97
	.DW  _0x0*2+320

	.DW  0x08
	.DW  _0x97+12
	.DW  _0x0*2+272

	.DW  0x0A
	.DW  _0x98
	.DW  _0x0*2+332

	.DW  0x08
	.DW  _0x98+10
	.DW  _0x0*2+272

	.DW  0x0D
	.DW  _0x99
	.DW  _0x0*2+342

	.DW  0x06
	.DW  _0x99+13
	.DW  _0x0*2+314

	.DW  0x0D
	.DW  _0x9A
	.DW  _0x0*2+355

	.DW  0x06
	.DW  _0x9A+13
	.DW  _0x0*2+314

	.DW  0x0D
	.DW  _0x9B
	.DW  _0x0*2+368

	.DW  0x02
	.DW  _0x9B+13
	.DW  _0x0*2+240

	.DW  0x0B
	.DW  _0x9C
	.DW  _0x0*2+381

	.DW  0x02
	.DW  _0x9C+11
	.DW  _0x0*2+240

	.DW  0x04
	.DW  _0x9D
	.DW  _0x0*2+392

	.DW  0x01
	.DW  _0x9D+4
	.DW  _0x0*2+19

	.DW  0x04
	.DW  _0x9E
	.DW  _0x0*2+396

	.DW  0x01
	.DW  _0x9E+4
	.DW  _0x0*2+19

	.DW  0x04
	.DW  _0x9F
	.DW  _0x0*2+400

	.DW  0x01
	.DW  _0x9F+4
	.DW  _0x0*2+19

	.DW  0x04
	.DW  _0xA0
	.DW  _0x0*2+404

	.DW  0x01
	.DW  _0xA0+4
	.DW  _0x0*2+19

	.DW  0x04
	.DW  _0xA1
	.DW  _0x0*2+408

	.DW  0x01
	.DW  _0xA1+4
	.DW  _0x0*2+19

	.DW  0x04
	.DW  _0xA2
	.DW  _0x0*2+412

	.DW  0x01
	.DW  _0xA2+4
	.DW  _0x0*2+19

	.DW  0x01
	.DW  _0xB0
	.DW  _0x0*2+19

	.DW  0x24
	.DW  _0xB0+1
	.DW  _0x0*2+426

	.DW  0x0E
	.DW  _0xB0+37
	.DW  _0x0*2+476

	.DW  0x07
	.DW  _0xB0+51
	.DW  _0x0*2+490

	.DW  0x0F
	.DW  _0xB0+58
	.DW  _0x0*2+497

	.DW  0x07
	.DW  _0xB0+73
	.DW  _0x0*2+512

	.DW  0x0D
	.DW  _0xB0+80
	.DW  _0x0*2+519

	.DW  0x08
	.DW  _0xB0+93
	.DW  _0x0*2+532

	.DW  0x0D
	.DW  _0xB0+101
	.DW  _0x0*2+519

	.DW  0x07
	.DW  _0xB0+114
	.DW  _0x0*2+540

	.DW  0x0C
	.DW  _0xB0+121
	.DW  _0x0*2+547

	.DW  0x06
	.DW  _0xB0+133
	.DW  _0x0*2+534

	.DW  0x0B
	.DW  _0xB0+139
	.DW  _0x0*2+559

	.DW  0x0F
	.DW  _0xB0+150
	.DW  _0x0*2+570

	.DW  0x0F
	.DW  _0xB0+165
	.DW  _0x0*2+585

	.DW  0x0D
	.DW  _0xB0+180
	.DW  _0x0*2+600

	.DW  0x0F
	.DW  _0xB0+193
	.DW  _0x0*2+585

	.DW  0x0B
	.DW  _0xB0+208
	.DW  _0x0*2+613

	.DW  0x15
	.DW  _0xB0+219
	.DW  _0x0*2+624

	.DW  0x06
	.DW  _0xB0+240
	.DW  _0x0*2+645

	.DW  0x02
	.DW  _0xB0+246
	.DW  _0x0*2+18

	.DW  0x15
	.DW  _0xB0+248
	.DW  _0x0*2+651

	.DW  0x06
	.DW  _0xB0+269
	.DW  _0x0*2+672

	.DW  0x02
	.DW  _0xB0+275
	.DW  _0x0*2+18

	.DW  0x15
	.DW  _0xB0+277
	.DW  _0x0*2+678

	.DW  0x06
	.DW  _0xB0+298
	.DW  _0x0*2+699

	.DW  0x02
	.DW  _0xB0+304
	.DW  _0x0*2+18

	.DW  0x0B
	.DW  _0xB0+306
	.DW  _0x0*2+725

	.DW  0x06
	.DW  _0xB0+317
	.DW  _0x0*2+736

	.DW  0x01
	.DW  _0xB0+323
	.DW  _0x0*2+19

	.DW  0x0D
	.DW  _0xB0+324
	.DW  _0x0*2+750

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
;Date    : 5/1/2012
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
;#include <alcd.h>
;#include <stdio.h>
;#include <delay.h>
;#include <string.h>
;
;#ifndef _EEP_SIZE
;#define _EEP_SIZE 1000
;#endif
;
;#define MAX_EEP_SIZE 1000
;
;#ifdef _EEP_SIZE
;#if    _EEP_SIZE > MAX_EEP_SIZE
;#undef _EEP_SIZE
;#define _EEP_SIZE MAX_EEP_SIZE
;#message EEPROM SUDAH DI-SET KE : _EEP_SIZE BYTE(S)
;#endif
;#endif
;
;#define ADC_VREF_TYPE 0x40
;
;void goto_menu(void);
;void pattern_menu_a(char *str1,char *str2,char up,char down,char ent);
;void pattern_menu_b(char *str1,char *str2,char up,char down,char ent,char can);
;void menu1(void);
;void menu2(void);
;void menu3(void);
;void menu4(void);
;void menu5(void);
;void menu6(void);
;void menu7(void);
;void menu8(void);
;void menu9(void);
;void menu10(void);
;void menu11(void);
;void menu12(void);
;void menu13(void);
;void menu14(void);
;void menu15(void);
;void menu16(void);
;void menu17(void);
;void menu18(void);
;void menu19(void);
;void menu20(void);
;void menu21(void);
;void menu22(void);
;void menu23(void);
;void menu24(void);
;void menu25(void);
;void menu26(void);
;void menu27(void);
;void menu28(void);
;void menu29(void);
;void menu30(void);
;void menu31(void);
;void menu32(void);
;void menu33(void);
;void menu34(void);
;void menu35(void);
;void menu36(void);
;void menu37(void);
;void menu38(void);
;void menu39(void);
;void menu40(void);
;unsigned int read_adc(unsigned char adc_input);
;void switch_to_modem(void);
;void switch_clear(void);
;//void reflect_data_until(unsigned char limiter);
;void banner_pembuka(void);
;void banner_sys(void);
;void banner_sys_freeze(void);
;void kirim_data_komplit(void);
;void kirim_data_sekarang(void);
;
;bit data_valid;
;eeprom char data_petir[_EEP_SIZE];
;eeprom char no_menu,last_menu;
;char lcd_buff[33];
;char data_perintah[200];
;
;#define INDIKATOR_1 PORTC.2
;#define INDIKATOR_2 PORTC.3
;
;#define SEL_A	PORTC.1
;#define SEL_B	PORTC.0
;
;#define TOM_ENTER	PIND.4
;#define TOM_UP		PIND.5
;#define TOM_DOWN  	PIND.6
;#define TOM_CANCEL	PIND.7
;
;#define SENSE_1	1
;#define SENSE_2	2
;#define SENSE_3 3
;#define SENSE_4	4
;#define SENSE_5	5
;#define SENSE_6 6
;
;#define PTT		PORTA.0
;#define CARIER_DET	PIND.0
;
;#define S_SLEEP	0
;#define S_WAKE	1
;
;eeprom char sys_mode = 0;
;eeprom char chn_omega1 = 1;
;eeprom char chn_omega2 = 2;
;eeprom char chn_omega3 = 3;
;eeprom char chn_petir = 4;
;eeprom int xcount = 0;
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0089 {

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
; 0000 008A 	TCNT1H=0xFB;
	LDI  R30,LOW(251)
	OUT  0x2D,R30
; 0000 008B 	TCNT1L=0xF0;
	LDI  R30,LOW(240)
	OUT  0x2C,R30
; 0000 008C 
; 0000 008D         #asm("cli")
	cli
; 0000 008E         if(sys_mode)
	CALL SUBOPT_0x0
	BREQ _0x3
; 0000 008F         {
; 0000 0090         	if(xcount>_EEP_SIZE)
	CALL SUBOPT_0x1
	CPI  R30,LOW(0x3E9)
	LDI  R26,HIGH(0x3E9)
	CPC  R31,R26
	BRLT _0x4
; 0000 0091         	{
; 0000 0092         		xcount = 0;
	CALL SUBOPT_0x2
; 0000 0093                 	kirim_data_komplit();
	RCALL _kirim_data_komplit
; 0000 0094         	}
; 0000 0095         	data_petir[xcount]=read_adc(chn_petir);
_0x4:
	CALL SUBOPT_0x1
	SUBI R30,LOW(-_data_petir)
	SBCI R31,HIGH(-_data_petir)
	PUSH R31
	PUSH R30
	LDI  R26,LOW(_chn_petir)
	LDI  R27,HIGH(_chn_petir)
	CALL SUBOPT_0x3
	POP  R26
	POP  R27
	CALL __EEPROMWRB
; 0000 0096         	xcount++;
	CALL SUBOPT_0x1
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 0097         }
; 0000 0098         //#asm("sei")
; 0000 0099 }
_0x3:
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
;#define STATION_STRING	",JTF_BALERANTE,"
;
;void kirim_data_komplit(void)
; 0000 009E {
_kirim_data_komplit:
; 0000 009F 	int i,j,k=0;
; 0000 00A0         PTT = 1;
	CALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
	__GETWRN 20,21,0
	SBI  0x1B,0
; 0000 00A1         PORTD.1 = 1;
	SBI  0x12,1
; 0000 00A2         delay_ms(500);
	CALL SUBOPT_0x4
; 0000 00A3         puts("$$$$$$$$$$$$$$$$$$,");
	__POINTW1MN _0x9,0
	CALL SUBOPT_0x5
; 0000 00A4         for(i=0;i<20;i++)
	__GETWRN 16,17,0
_0xB:
	__CPWRN 16,17,20
	BRGE _0xC
; 0000 00A5         {
; 0000 00A6         	puts(STATION_STRING"$TEL*,PETIR*,");
	__POINTW1MN _0x9,20
	CALL SUBOPT_0x5
; 0000 00A7                 for(j=0;j<50;j++)
	__GETWRN 18,19,0
_0xE:
	__CPWRN 18,19,50
	BRGE _0xF
; 0000 00A8                 {
; 0000 00A9                 	putchar(data_petir[k]);
	LDI  R26,LOW(_data_petir)
	LDI  R27,HIGH(_data_petir)
	ADD  R26,R20
	ADC  R27,R21
	CALL SUBOPT_0x6
; 0000 00AA                         putchar(',');
; 0000 00AB                         k++;
	__ADDWRN 20,21,1
; 0000 00AC                 }
	__ADDWRN 18,19,1
	RJMP _0xE
_0xF:
; 0000 00AD                 puts("*50*,");
	__POINTW1MN _0x9,49
	CALL SUBOPT_0x5
; 0000 00AE                 putchar('\n');
	CALL SUBOPT_0x7
; 0000 00AF         }
	__ADDWRN 16,17,1
	RJMP _0xB
_0xC:
; 0000 00B0 
; 0000 00B1         puts(STATION_STRING"$TEL*,OMEGA*,");
	__POINTW1MN _0x9,55
	CALL SUBOPT_0x5
; 0000 00B2         putchar(read_adc(chn_omega1));
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 00B3         putchar(',');
; 0000 00B4         putchar(read_adc(chn_omega2));
	CALL SUBOPT_0xA
	CALL SUBOPT_0x9
; 0000 00B5         putchar(',');
; 0000 00B6         putchar(read_adc(chn_omega3));
	CALL SUBOPT_0xB
	ST   -Y,R30
	CALL _putchar
; 0000 00B7         puts(",*3*,");
	__POINTW1MN _0x9,84
	CALL SUBOPT_0x5
; 0000 00B8         putchar('\n');
	CALL SUBOPT_0x7
; 0000 00B9         puts("#########");
	__POINTW1MN _0x9,90
	CALL SUBOPT_0x5
; 0000 00BA         PTT = 0;
	CBI  0x1B,0
; 0000 00BB }
	CALL __LOADLOCR6
	ADIW R28,6
	RET

	.DSEG
_0x9:
	.BYTE 0x64
;
;
;
;void kirim_data_sekarang(void)
; 0000 00C0 {

	.CSEG
_kirim_data_sekarang:
; 0000 00C1 	char i,j;
; 0000 00C2         int k=0;
; 0000 00C3 
; 0000 00C4         #asm("cli")
	CALL __SAVELOCR4
;	i -> R17
;	j -> R16
;	k -> R18,R19
	__GETWRN 18,19,0
	cli
; 0000 00C5 
; 0000 00C6         for(i=0;i<20;i++)
	LDI  R17,LOW(0)
_0x13:
	CPI  R17,20
	BRSH _0x14
; 0000 00C7         {
; 0000 00C8         	puts(STATION_STRING"$TEL*,PETIR*,");
	__POINTW1MN _0x15,0
	CALL SUBOPT_0x5
; 0000 00C9                 for(j=0;j<50;j++)
	LDI  R16,LOW(0)
_0x17:
	CPI  R16,50
	BRSH _0x18
; 0000 00CA                 {
; 0000 00CB                 	putchar(data_petir[k]);
	LDI  R26,LOW(_data_petir)
	LDI  R27,HIGH(_data_petir)
	ADD  R26,R18
	ADC  R27,R19
	CALL SUBOPT_0x6
; 0000 00CC                         putchar(',');
; 0000 00CD                         k++;
	__ADDWRN 18,19,1
; 0000 00CE                         if(k==xcount) goto selesai;
	CALL SUBOPT_0x1
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x1A
; 0000 00CF                 }
	SUBI R16,-1
	RJMP _0x17
_0x18:
; 0000 00D0                 puts("*50*");
	__POINTW1MN _0x15,29
	CALL SUBOPT_0x5
; 0000 00D1                 putchar('\n');
	CALL SUBOPT_0x7
; 0000 00D2         }
	SUBI R17,-1
	RJMP _0x13
_0x14:
; 0000 00D3 
; 0000 00D4        	selesai:
_0x1A:
; 0000 00D5 
; 0000 00D6         puts("*END*,");
	__POINTW1MN _0x15,34
	CALL SUBOPT_0x5
; 0000 00D7         putchar('\n');
	CALL SUBOPT_0x7
; 0000 00D8 
; 0000 00D9         puts(STATION_STRING"$TEL*,OMEGA*,");
	__POINTW1MN _0x15,41
	CALL SUBOPT_0x5
; 0000 00DA         putchar(read_adc(chn_omega1));
	CALL SUBOPT_0x8
	CALL SUBOPT_0x9
; 0000 00DB         putchar(',');
; 0000 00DC         putchar(read_adc(chn_omega2));
	CALL SUBOPT_0xA
	CALL SUBOPT_0x9
; 0000 00DD         putchar(',');
; 0000 00DE         putchar(read_adc(chn_omega3));
	CALL SUBOPT_0xB
	ST   -Y,R30
	CALL _putchar
; 0000 00DF         puts(",*3*,");
	__POINTW1MN _0x15,70
	CALL SUBOPT_0x5
; 0000 00E0         putchar('\n');
	CALL SUBOPT_0x7
; 0000 00E1 }
	CALL __LOADLOCR4
	RJMP _0x2080004

	.DSEG
_0x15:
	.BYTE 0x4C
;
;void adc_init(void)
; 0000 00E4 {

	.CSEG
_adc_init:
; 0000 00E5    	ADMUX = ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 00E6 	ADCSRA = 0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 00E7 }
	RET
;
;unsigned int read_adc(unsigned char adc_input)
; 0000 00EA {
_read_adc:
; 0000 00EB 	ADMUX = adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 00EC 	delay_us(10);
	__DELAY_USB 37
; 0000 00ED 	ADCSRA |= 0x40;
	SBI  0x6,6
; 0000 00EE 	while ((ADCSRA & 0x10) == 0);
_0x1B:
	SBIS 0x6,4
	RJMP _0x1B
; 0000 00EF 	ADCSRA |= 0x10;
	SBI  0x6,4
; 0000 00F0         if(ADCW>127) ADCW=127;
	IN   R30,0x4
	IN   R31,0x4+1
	CPI  R30,LOW(0x80)
	LDI  R26,HIGH(0x80)
	CPC  R31,R26
	BRLO _0x1E
	LDI  R30,LOW(127)
	LDI  R31,HIGH(127)
	OUT  0x4+1,R31
	OUT  0x4,R30
; 0000 00F1 	return ADCW;
_0x1E:
	IN   R30,0x4
	IN   R31,0x4+1
	ADIW R28,1
	RET
; 0000 00F2 }
;
;void usart_init(void)
; 0000 00F5 {
_usart_init:
; 0000 00F6 	UCSRA = 0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 00F7 	UCSRB = 0xD8;
	LDI  R30,LOW(216)
	RJMP _0x2080003
; 0000 00F8 	UCSRC = 0x86;
; 0000 00F9 	UBRRH = 0x02;
; 0000 00FA 	UBRRL = 0x3F;
; 0000 00FB }
;
;void switch_to_modem(void)
; 0000 00FE {
_switch_to_modem:
; 0000 00FF 	SEL_B = 1; SEL_A = 0;
	SBI  0x15,0
	CBI  0x15,1
; 0000 0100 }
	RET
;
;void switch_clear(void)
; 0000 0103 {
_switch_clear:
; 0000 0104   	SEL_B = 1; SEL_A = 1;
	SBI  0x15,0
	SBI  0x15,1
; 0000 0105 }
	RET
;/*
;void reflect_data_until(unsigned char limiter)
;{
;	int i;
;
;        //data_stat = 0;
;        for(i=0;;i++)
;        {
;        	data[i] = getchar();
;                lcd_putchar(data[i]);
;                if(data[i]==limiter)
;                {
;                	//data_stat = 1;
;                        goto esc;
;                }
;                if(i == (_EEP_SIZE-1))goto esc;
;                //if(i == 20)goto esc;
;        }
;
;        esc:
;        data_stat = 1;
;        if(data_stat)
;        {
;        	PTT = 1;
;                //delay_ms(500);
;                puts("FSTART");
;        	for(i=0;((data[i]!=limiter)&&(i!=(_EEP_SIZE-1)));i++)
;                	putchar(data[i]);
;                puts("FEND");
;                PTT = 0;
;                delay_ms(500);
;                lcd_clear();
;                banner_sys();
;        }
;}*/
;
;void banner_pembuka(void)
; 0000 012B {
_banner_pembuka:
; 0000 012C  	lcd_clear();
	CALL SUBOPT_0xC
; 0000 012D         lcd_gotoxy(0,0);
; 0000 012E         	 //0123456789abcdef
; 0000 012F         lcd_putsf("----JTF.UGM-----");
	__POINTW1FN _0x0,112
	CALL SUBOPT_0xD
; 0000 0130        	delay_ms(1000);
	CALL SUBOPT_0xE
; 0000 0131         lcd_clear();
; 0000 0132         lcd_gotoxy(0,0);
; 0000 0133         	 //0123456789abcdef
; 0000 0134         lcd_putsf(" Sistem");
	__POINTW1FN _0x0,129
	CALL SUBOPT_0xD
; 0000 0135         lcd_gotoxy(0,1);
	CALL SUBOPT_0xF
; 0000 0136         lcd_putsf(" Monitoring");
	__POINTW1FN _0x0,137
	CALL SUBOPT_0xD
; 0000 0137         delay_ms(1000);
	CALL SUBOPT_0xE
; 0000 0138         lcd_clear();
; 0000 0139         lcd_gotoxy(0,0);
; 0000 013A         	 //0123456789abcdef
; 0000 013B         lcd_putsf(" Ds. Balerante");
	__POINTW1FN _0x0,149
	CALL SUBOPT_0xD
; 0000 013C         lcd_gotoxy(0,1);
	CALL SUBOPT_0xF
; 0000 013D         lcd_putsf(" Gn. Merapi DIY");
	__POINTW1FN _0x0,164
	CALL SUBOPT_0xD
; 0000 013E         delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CALL SUBOPT_0x10
; 0000 013F         lcd_clear();
	CALL _lcd_clear
; 0000 0140 }
	RET
;
;void banner_sys(void)
; 0000 0143 {
_banner_sys:
; 0000 0144  	lcd_clear();
	CALL SUBOPT_0xC
; 0000 0145         lcd_gotoxy(0,0);
; 0000 0146         if(sys_mode)	lcd_putsf("System running");
	CALL SUBOPT_0x0
	BREQ _0x27
	__POINTW1FN _0x0,180
	RJMP _0x10C
; 0000 0147         else		lcd_putsf("System stanby");
_0x27:
	__POINTW1FN _0x0,195
_0x10C:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0148 }
	RET
;
;void banner_sys_freeze(void)
; 0000 014B {
_banner_sys_freeze:
; 0000 014C  	lcd_clear();
	CALL SUBOPT_0xC
; 0000 014D         lcd_gotoxy(0,0);
; 0000 014E         lcd_putsf("System stoped !");
	__POINTW1FN _0x0,209
	CALL SUBOPT_0xD
; 0000 014F }
	RET
;
;void goto_menu(void)
; 0000 0152 {
_goto_menu:
; 0000 0153 	switch_clear();
	RCALL _switch_clear
; 0000 0154         for(;;)
_0x2A:
; 0000 0155         {
; 0000 0156 		#asm("cli")
	cli
; 0000 0157                 if(no_menu==0)	banner_sys_freeze();
	CALL SUBOPT_0x11
	CPI  R30,0
	BRNE _0x2C
	RCALL _banner_sys_freeze
; 0000 0158 
; 0000 0159                 else if(no_menu==1)	menu1();
	RJMP _0x2D
_0x2C:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x1)
	BRNE _0x2E
	RCALL _menu1
; 0000 015A                 else if(no_menu==2)	menu2();
	RJMP _0x2F
_0x2E:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x2)
	BRNE _0x30
	RCALL _menu2
; 0000 015B                 else if(no_menu==3)	menu3();
	RJMP _0x31
_0x30:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x3)
	BRNE _0x32
	RCALL _menu3
; 0000 015C                 else if(no_menu==4)	menu4();
	RJMP _0x33
_0x32:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x4)
	BRNE _0x34
	RCALL _menu4
; 0000 015D                 else if(no_menu==5)	menu5();
	RJMP _0x35
_0x34:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x5)
	BRNE _0x36
	RCALL _menu5
; 0000 015E                 else if(no_menu==6)	menu6();
	RJMP _0x37
_0x36:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x6)
	BRNE _0x38
	RCALL _menu6
; 0000 015F                 else if(no_menu==7)	menu7();
	RJMP _0x39
_0x38:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x7)
	BRNE _0x3A
	RCALL _menu7
; 0000 0160                 else if(no_menu==8)	menu8();
	RJMP _0x3B
_0x3A:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x8)
	BRNE _0x3C
	RCALL _menu8
; 0000 0161                 else if(no_menu==9)	menu9();
	RJMP _0x3D
_0x3C:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x9)
	BRNE _0x3E
	RCALL _menu9
; 0000 0162                 else if(no_menu==10)	menu10();
	RJMP _0x3F
_0x3E:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0xA)
	BRNE _0x40
	RCALL _menu10
; 0000 0163                 else if(no_menu==11)	menu11();
	RJMP _0x41
_0x40:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0xB)
	BRNE _0x42
	RCALL _menu11
; 0000 0164                 else if(no_menu==12)	menu12();
	RJMP _0x43
_0x42:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0xC)
	BRNE _0x44
	RCALL _menu12
; 0000 0165                 else if(no_menu==13)	menu13();
	RJMP _0x45
_0x44:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0xD)
	BRNE _0x46
	RCALL _menu13
; 0000 0166                 else if(no_menu==14)	menu14();
	RJMP _0x47
_0x46:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0xE)
	BRNE _0x48
	RCALL _menu14
; 0000 0167                 else if(no_menu==15)	menu15();
	RJMP _0x49
_0x48:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0xF)
	BRNE _0x4A
	RCALL _menu15
; 0000 0168                 else if(no_menu==16)	menu16();
	RJMP _0x4B
_0x4A:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x10)
	BRNE _0x4C
	RCALL _menu16
; 0000 0169                 else if(no_menu==17)	menu17();
	RJMP _0x4D
_0x4C:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x11)
	BRNE _0x4E
	RCALL _menu17
; 0000 016A                 else if(no_menu==18)	menu18();
	RJMP _0x4F
_0x4E:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x12)
	BRNE _0x50
	RCALL _menu18
; 0000 016B                 else if(no_menu==19)	menu19();
	RJMP _0x51
_0x50:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x13)
	BRNE _0x52
	RCALL _menu19
; 0000 016C                 else if(no_menu==20)	menu20();
	RJMP _0x53
_0x52:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x14)
	BRNE _0x54
	RCALL _menu20
; 0000 016D                 else if(no_menu==21)	menu21();
	RJMP _0x55
_0x54:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x15)
	BRNE _0x56
	RCALL _menu21
; 0000 016E                 else if(no_menu==22)	menu22();
	RJMP _0x57
_0x56:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x16)
	BRNE _0x58
	RCALL _menu22
; 0000 016F                 else if(no_menu==23)	menu23();
	RJMP _0x59
_0x58:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x17)
	BRNE _0x5A
	RCALL _menu23
; 0000 0170                 else if(no_menu==24)	menu24();
	RJMP _0x5B
_0x5A:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x18)
	BRNE _0x5C
	RCALL _menu24
; 0000 0171                 else if(no_menu==25)	menu25();
	RJMP _0x5D
_0x5C:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x19)
	BRNE _0x5E
	RCALL _menu25
; 0000 0172                 else if(no_menu==26)	menu26();
	RJMP _0x5F
_0x5E:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x1A)
	BRNE _0x60
	RCALL _menu26
; 0000 0173                 else if(no_menu==27)	menu27();
	RJMP _0x61
_0x60:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x1B)
	BRNE _0x62
	RCALL _menu27
; 0000 0174                 else if(no_menu==28)	menu28();
	RJMP _0x63
_0x62:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x1C)
	BRNE _0x64
	RCALL _menu28
; 0000 0175                 else if(no_menu==29)	menu29();
	RJMP _0x65
_0x64:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x1D)
	BRNE _0x66
	RCALL _menu29
; 0000 0176                 else if(no_menu==30)	menu30();
	RJMP _0x67
_0x66:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x1E)
	BRNE _0x68
	RCALL _menu30
; 0000 0177                 else if(no_menu==31)	menu31();
	RJMP _0x69
_0x68:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x1F)
	BRNE _0x6A
	RCALL _menu31
; 0000 0178                 else if(no_menu==32)	menu32();
	RJMP _0x6B
_0x6A:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x20)
	BRNE _0x6C
	RCALL _menu32
; 0000 0179                 else if(no_menu==33)	menu33();
	RJMP _0x6D
_0x6C:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x21)
	BRNE _0x6E
	RCALL _menu33
; 0000 017A                 else if(no_menu==34)	menu34();
	RJMP _0x6F
_0x6E:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x22)
	BRNE _0x70
	RCALL _menu34
; 0000 017B                 else if(no_menu==35)	menu35();
	RJMP _0x71
_0x70:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x23)
	BRNE _0x72
	RCALL _menu35
; 0000 017C                 else if(no_menu==36)	menu36();
	RJMP _0x73
_0x72:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x24)
	BRNE _0x74
	RCALL _menu36
; 0000 017D                 else if(no_menu==37)	menu37();
	RJMP _0x75
_0x74:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x25)
	BRNE _0x76
	RCALL _menu37
; 0000 017E                 else if(no_menu==38)	menu38();
	RJMP _0x77
_0x76:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x26)
	BRNE _0x78
	RCALL _menu38
; 0000 017F                 else if(no_menu==39)	menu39();
	RJMP _0x79
_0x78:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x27)
	BRNE _0x7A
	RCALL _menu39
; 0000 0180                 else if(no_menu==40)	menu40();
	RJMP _0x7B
_0x7A:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x28)
	BRNE _0x7C
	RCALL _menu40
; 0000 0181 
; 0000 0182                 else if(no_menu==100)	goto esc;
	RJMP _0x7D
_0x7C:
	CALL SUBOPT_0x11
	CPI  R30,LOW(0x64)
	BREQ _0x7F
; 0000 0183         }
_0x7D:
_0x7B:
_0x79:
_0x77:
_0x75:
_0x73:
_0x71:
_0x6F:
_0x6D:
_0x6B:
_0x69:
_0x67:
_0x65:
_0x63:
_0x61:
_0x5F:
_0x5D:
_0x5B:
_0x59:
_0x57:
_0x55:
_0x53:
_0x51:
_0x4F:
_0x4D:
_0x4B:
_0x49:
_0x47:
_0x45:
_0x43:
_0x41:
_0x3F:
_0x3D:
_0x3B:
_0x39:
_0x37:
_0x35:
_0x33:
_0x31:
_0x2F:
_0x2D:
	RJMP _0x2A
; 0000 0184         esc:
_0x7F:
; 0000 0185         lcd_clear();
	CALL _lcd_clear
; 0000 0186         delay_ms(500);
	CALL SUBOPT_0x4
; 0000 0187         //#asm("sei")
; 0000 0188         banner_sys();
	RCALL _banner_sys
; 0000 0189         puts("$$##");
	__POINTW1MN _0x80,0
	CALL SUBOPT_0x5
; 0000 018A }
	RET

	.DSEG
_0x80:
	.BYTE 0x5
;
;void pattern_menu_a(char *str1,char *str2,char up,char down,char ent)
; 0000 018D {

	.CSEG
; 0000 018E 	last_menu = no_menu;
;	*str1 -> Y+5
;	*str2 -> Y+3
;	up -> Y+2
;	down -> Y+1
;	ent -> Y+0
; 0000 018F 	lcd_clear();
; 0000 0190         lcd_gotoxy(0,0);
; 0000 0191         lcd_puts(str1);
; 0000 0192 	lcd_gotoxy(0,1);
; 0000 0193         lcd_puts(str2);
; 0000 0194         delay_ms(500);
; 0000 0195         while((TOM_UP)&&(TOM_DOWN)&&(TOM_ENTER)&&(TOM_CANCEL));
; 0000 0196         if(TOM_UP==0)
; 0000 0197         {
; 0000 0198         	delay_ms(200);
; 0000 0199         	no_menu = up;
; 0000 019A         }
; 0000 019B         if(TOM_DOWN==0)
; 0000 019C         {
; 0000 019D         	delay_ms(200);
; 0000 019E         	no_menu = down;
; 0000 019F         }
; 0000 01A0         if(TOM_ENTER==0)
; 0000 01A1         {
; 0000 01A2         	delay_ms(200);
; 0000 01A3         	no_menu = ent;
; 0000 01A4         }
; 0000 01A5         if(TOM_CANCEL==0)
; 0000 01A6         {
; 0000 01A7         	delay_ms(200);
; 0000 01A8         	no_menu = last_menu;
; 0000 01A9         }
; 0000 01AA }
;
;void pattern_menu_b(char *str1,char *str2,char up,char down,char ent,char can)
; 0000 01AD {
_pattern_menu_b:
; 0000 01AE 	last_menu = no_menu;
;	*str1 -> Y+6
;	*str2 -> Y+4
;	up -> Y+3
;	down -> Y+2
;	ent -> Y+1
;	can -> Y+0
	CALL SUBOPT_0x11
	LDI  R26,LOW(_last_menu)
	LDI  R27,HIGH(_last_menu)
	CALL __EEPROMWRB
; 0000 01AF 	lcd_clear();
	CALL SUBOPT_0xC
; 0000 01B0         lcd_gotoxy(0,0);
; 0000 01B1         lcd_puts(str1);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	CALL SUBOPT_0x12
; 0000 01B2 	lcd_gotoxy(0,1);
	CALL SUBOPT_0xF
; 0000 01B3         lcd_puts(str2);
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	CALL SUBOPT_0x12
; 0000 01B4         delay_ms(500);
	CALL SUBOPT_0x4
; 0000 01B5         while((TOM_UP)&&(TOM_DOWN)&&(TOM_ENTER)&&(TOM_CANCEL));
_0x8A:
	SBIS 0x10,5
	RJMP _0x8D
	SBIS 0x10,6
	RJMP _0x8D
	SBIS 0x10,4
	RJMP _0x8D
	SBIC 0x10,7
	RJMP _0x8E
_0x8D:
	RJMP _0x8C
_0x8E:
	RJMP _0x8A
_0x8C:
; 0000 01B6         if(!TOM_UP)
	SBIC 0x10,5
	RJMP _0x8F
; 0000 01B7         {
; 0000 01B8         	delay_ms(200);
	CALL SUBOPT_0x13
; 0000 01B9         	no_menu = up;
	LDD  R30,Y+3
	CALL SUBOPT_0x14
; 0000 01BA         }
; 0000 01BB         if(!TOM_DOWN)
_0x8F:
	SBIC 0x10,6
	RJMP _0x90
; 0000 01BC         {
; 0000 01BD         	delay_ms(200);
	CALL SUBOPT_0x13
; 0000 01BE         	no_menu = down;
	LDD  R30,Y+2
	CALL SUBOPT_0x14
; 0000 01BF         }
; 0000 01C0         if(!TOM_ENTER)
_0x90:
	SBIC 0x10,4
	RJMP _0x91
; 0000 01C1         {
; 0000 01C2         	delay_ms(200);
	CALL SUBOPT_0x13
; 0000 01C3         	no_menu = ent;
	LDD  R30,Y+1
	CALL SUBOPT_0x14
; 0000 01C4         }
; 0000 01C5         if(!TOM_CANCEL)
_0x91:
	SBIC 0x10,7
	RJMP _0x92
; 0000 01C6         {
; 0000 01C7         	delay_ms(200);
	CALL SUBOPT_0x13
; 0000 01C8                 no_menu = can;
	LD   R30,Y
	CALL SUBOPT_0x14
; 0000 01C9         }
; 0000 01CA }
_0x92:
	ADIW R28,8
	RET
;
;void menu1(void) //fixed
; 0000 01CD {
_menu1:
; 0000 01CE 	pattern_menu_b(	"1.Jalankan ",
; 0000 01CF         		" Sistem ",
; 0000 01D0                         2,16,100,0);
	__POINTW1MN _0x93,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x93,12
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R30,LOW(100)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x2080007
; 0000 01D1 }

	.DSEG
_0x93:
	.BYTE 0x15
;
;void menu2(void)
; 0000 01D4 {                      //0123456789abcdef

	.CSEG
_menu2:
; 0000 01D5 	pattern_menu_b(	"2.Setting tres-",
; 0000 01D6         		" hold sensor",
; 0000 01D7                         3,1,0,last_menu);
	__POINTW1MN _0x94,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x94,16
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 01D8 }

	.DSEG
_0x94:
	.BYTE 0x1D
;
;void menu3(void)
; 0000 01DB {                      //0123456789abcdef

	.CSEG
_menu3:
; 0000 01DC 	pattern_menu_b(	"3.Setting jum-",
; 0000 01DD         		" lah sensor",
; 0000 01DE                         4,2,0,last_menu);
	__POINTW1MN _0x95,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x95,15
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 01DF }

	.DSEG
_0x95:
	.BYTE 0x1B
;
;void menu4(void)
; 0000 01E2 {                      //0123456789abcdef

	.CSEG
_menu4:
; 0000 01E3 	pattern_menu_b(	"4.Lihat data",
; 0000 01E4         		" sensor",
; 0000 01E5                         5,3,0,last_menu);
	__POINTW1MN _0x96,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x96,13
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 01E6 }

	.DSEG
_0x96:
	.BYTE 0x15
;
;void menu5(void)
; 0000 01E9 {                      //0123456789abcdef

	.CSEG
_menu5:
; 0000 01EA 	pattern_menu_b(	"5.Aktifkan ",
; 0000 01EB         		" sensor",
; 0000 01EC                         6,4,0,last_menu);
	__POINTW1MN _0x97,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x97,12
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 01ED }

	.DSEG
_0x97:
	.BYTE 0x14
;
;void menu6(void)
; 0000 01F0 {                      //0123456789abcdef

	.CSEG
_menu6:
; 0000 01F1 	pattern_menu_b(	"6.Matikan",
; 0000 01F2         		" sensor",
; 0000 01F3                         7,5,0,last_menu);
	__POINTW1MN _0x98,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x98,10
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(5)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 01F4 }

	.DSEG
_0x98:
	.BYTE 0x12
;
;void menu7(void)
; 0000 01F7 {                      //0123456789abcdef

	.CSEG
_menu7:
; 0000 01F8 	pattern_menu_b(	"7.Tes pancar",
; 0000 01F9         		" data",
; 0000 01FA                         8,6,0,last_menu);
	__POINTW1MN _0x99,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x99,13
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(6)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 01FB }

	.DSEG
_0x99:
	.BYTE 0x13
;
;void menu8(void)
; 0000 01FE {                      //0123456789abcdef

	.CSEG
_menu8:
; 0000 01FF 	pattern_menu_b(	"8.Tes terima",
; 0000 0200         		" data",
; 0000 0201                         9,7,0,last_menu);
	__POINTW1MN _0x9A,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x9A,13
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(7)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 0202 }

	.DSEG
_0x9A:
	.BYTE 0x13
;
;void menu9(void)
; 0000 0205 {

	.CSEG
_menu9:
; 0000 0206 	pattern_menu_b(	"9.Sleep mode",
; 0000 0207         		" ",
; 0000 0208                         10,8,0,last_menu);
	__POINTW1MN _0x9B,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x9B,13
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(8)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 0209 }

	.DSEG
_0x9B:
	.BYTE 0xF
;
;void menu10(void)
; 0000 020C {

	.CSEG
_menu10:
; 0000 020D 	pattern_menu_b(	"10.Wake-up",
; 0000 020E         		" ",
; 0000 020F                         11,9,0,last_menu);
	__POINTW1MN _0x9C,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x9C,11
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R30,LOW(9)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 0210 }

	.DSEG
_0x9C:
	.BYTE 0xD
;
;void menu11(void)
; 0000 0213 {

	.CSEG
_menu11:
; 0000 0214 	pattern_menu_b(	"11.",
; 0000 0215         		"",
; 0000 0216                         12,10,11,last_menu);
	__POINTW1MN _0x9D,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x9D,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(10)
	ST   -Y,R30
	LDI  R30,LOW(11)
	RJMP _0x2080006
; 0000 0217 }

	.DSEG
_0x9D:
	.BYTE 0x5
;
;void menu12(void)
; 0000 021A {

	.CSEG
_menu12:
; 0000 021B 	pattern_menu_b(	"12.",
; 0000 021C         		"",
; 0000 021D                         13,11,12,last_menu);
	__POINTW1MN _0x9E,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x9E,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(11)
	ST   -Y,R30
	LDI  R30,LOW(12)
	RJMP _0x2080006
; 0000 021E }

	.DSEG
_0x9E:
	.BYTE 0x5
;
;void menu13(void)
; 0000 0221 {

	.CSEG
_menu13:
; 0000 0222 	pattern_menu_b(	"13.",
; 0000 0223         		"",
; 0000 0224                         14,12,0,last_menu);
	__POINTW1MN _0x9F,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0x9F,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(14)
	ST   -Y,R30
	LDI  R30,LOW(12)
	ST   -Y,R30
	LDI  R30,LOW(0)
	RJMP _0x2080006
; 0000 0225 }

	.DSEG
_0x9F:
	.BYTE 0x5
;
;void menu14(void)
; 0000 0228 {

	.CSEG
_menu14:
; 0000 0229 	pattern_menu_b(	"14.",
; 0000 022A         		"",
; 0000 022B                         15,13,14,last_menu);
	__POINTW1MN _0xA0,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xA0,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(15)
	ST   -Y,R30
	LDI  R30,LOW(13)
	ST   -Y,R30
	LDI  R30,LOW(14)
	RJMP _0x2080006
; 0000 022C }

	.DSEG
_0xA0:
	.BYTE 0x5
;
;void menu15(void)
; 0000 022F {

	.CSEG
_menu15:
; 0000 0230 	pattern_menu_b(	"15.",
; 0000 0231         		"",
; 0000 0232                         16,14,10,last_menu);
	__POINTW1MN _0xA1,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xA1,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(16)
	ST   -Y,R30
	LDI  R30,LOW(14)
	RJMP _0x2080005
; 0000 0233 }

	.DSEG
_0xA1:
	.BYTE 0x5
;
;void menu16(void)
; 0000 0236 {

	.CSEG
_menu16:
; 0000 0237 	pattern_menu_b(	"16.",
; 0000 0238         		"",
; 0000 0239                         1,15,10,last_menu);
	__POINTW1MN _0xA2,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xA2,4
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(15)
_0x2080005:
	ST   -Y,R30
	LDI  R30,LOW(10)
_0x2080006:
	ST   -Y,R30
	LDI  R26,LOW(_last_menu)
	LDI  R27,HIGH(_last_menu)
	CALL __EEPROMRDB
_0x2080007:
	ST   -Y,R30
	RCALL _pattern_menu_b
; 0000 023A }
	RET

	.DSEG
_0xA2:
	.BYTE 0x5
;
;void menu17(void)
; 0000 023D {

	.CSEG
_menu17:
; 0000 023E 
; 0000 023F }
	RET
;
;void menu18(void)
; 0000 0242 {
_menu18:
; 0000 0243 
; 0000 0244 }
	RET
;
;void menu19(void)
; 0000 0247 {
_menu19:
; 0000 0248 
; 0000 0249 }
	RET
;
;void menu20(void)
; 0000 024C {
_menu20:
; 0000 024D 
; 0000 024E }
	RET
;
;void menu21(void)
; 0000 0251 {
_menu21:
; 0000 0252 
; 0000 0253 }
	RET
;
;void menu22(void)
; 0000 0256 {
_menu22:
; 0000 0257 
; 0000 0258 }
	RET
;void menu23(void)
; 0000 025A {
_menu23:
; 0000 025B 
; 0000 025C }
	RET
;
;void menu24(void)
; 0000 025F {
_menu24:
; 0000 0260 
; 0000 0261 }
	RET
;
;void menu25(void)
; 0000 0264 {
_menu25:
; 0000 0265 
; 0000 0266 }
	RET
;
;void menu26(void)
; 0000 0269 {
_menu26:
; 0000 026A 
; 0000 026B }
	RET
;
;void menu27(void)
; 0000 026E {
_menu27:
; 0000 026F 
; 0000 0270 }
	RET
;
;void menu28(void)
; 0000 0273 {
_menu28:
; 0000 0274 
; 0000 0275 }
	RET
;
;void menu29(void)
; 0000 0278 {
_menu29:
; 0000 0279 
; 0000 027A }
	RET
;
;void menu30(void)
; 0000 027D {
_menu30:
; 0000 027E 
; 0000 027F }
	RET
;
;void menu31(void)
; 0000 0282 {
_menu31:
; 0000 0283 
; 0000 0284 }
	RET
;
;void menu32(void)
; 0000 0287 {
_menu32:
; 0000 0288 
; 0000 0289 }
	RET
;
;void menu33(void)
; 0000 028C {
_menu33:
; 0000 028D 
; 0000 028E }
	RET
;
;void menu34(void)
; 0000 0291 {
_menu34:
; 0000 0292 
; 0000 0293 }
	RET
;
;void menu35(void)
; 0000 0296 {
_menu35:
; 0000 0297 
; 0000 0298 }
	RET
;
;void menu36(void)
; 0000 029B {
_menu36:
; 0000 029C 
; 0000 029D }
	RET
;
;void menu37(void)
; 0000 02A0 {
_menu37:
; 0000 02A1 
; 0000 02A2 }
	RET
;
;void menu38(void)
; 0000 02A5 {
_menu38:
; 0000 02A6 
; 0000 02A7 }
	RET
;
;void menu39(void)
; 0000 02AA {
_menu39:
; 0000 02AB 
; 0000 02AC }
	RET
;
;void menu40(void)
; 0000 02AF {
_menu40:
; 0000 02B0 
; 0000 02B1 }
	RET
;
;void tx_data(char *str1,char *str2)
; 0000 02B4 {
_tx_data:
; 0000 02B5 	PORTD.1 = 1;
;	*str1 -> Y+2
;	*str2 -> Y+0
	SBI  0x12,1
; 0000 02B6         delay_ms(100);
	CALL SUBOPT_0x15
; 0000 02B7         lcd_gotoxy(0,1);
	CALL SUBOPT_0xF
; 0000 02B8         lcd_puts(str1);
	LDD  R30,Y+2
	LDD  R31,Y+2+1
	CALL SUBOPT_0x12
; 0000 02B9         puts(str2);
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x5
; 0000 02BA         delay_ms(100);
	CALL SUBOPT_0x15
; 0000 02BB         lcd_clear();
	CALL _lcd_clear
; 0000 02BC }
_0x2080004:
	ADIW R28,4
	RET
;
;void usart_no_rx(void)
; 0000 02BF {
_usart_no_rx:
; 0000 02C0 	// USART initialization
; 0000 02C1 	// Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02C2 	// USART Receiver: Off
; 0000 02C3 	// USART Transmitter: On
; 0000 02C4 	// USART Mode: Asynchronous
; 0000 02C5 	// USART Baud Rate: 1200
; 0000 02C6 	UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 02C7 	UCSRB=0x08;
	LDI  R30,LOW(8)
_0x2080003:
	OUT  0xA,R30
; 0000 02C8 	UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 02C9 	UBRRH=0x02;
	LDI  R30,LOW(2)
	OUT  0x20,R30
; 0000 02CA 	UBRRL=0x3F;
	LDI  R30,LOW(63)
	OUT  0x9,R30
; 0000 02CB }
	RET
;
;void baca_perintah(void)
; 0000 02CE {
_baca_perintah:
; 0000 02CF 	char i;
; 0000 02D0         if(!CARIER_DET)
	ST   -Y,R17
;	i -> R17
	SBIC 0x10,0
	RJMP _0xA5
; 0000 02D1         {
; 0000 02D2         	#asm("cli")
	cli
; 0000 02D3                 for(i=0;;i++)
	LDI  R17,LOW(0)
_0xA7:
; 0000 02D4         	{
; 0000 02D5         		data_perintah[i]=getchar();
	CALL SUBOPT_0x16
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 02D6                 	if(data_perintah[i]=='#') goto exec;
	CALL SUBOPT_0x16
	LD   R26,Z
	CPI  R26,LOW(0x23)
	BREQ _0xAA
; 0000 02D7                 	if(i==1)
	CPI  R17,1
	BRNE _0xAB
; 0000 02D8                         {
; 0000 02D9                         	lcd_clear();
	CALL _lcd_clear
; 0000 02DA                                 lcd_putsf("receiving");
	__POINTW1FN _0x0,416
	CALL SUBOPT_0xD
; 0000 02DB                         }
; 0000 02DC         	}
_0xAB:
	SUBI R17,-1
	RJMP _0xA7
; 0000 02DD         	exec:
_0xAA:
; 0000 02DE                 usart_no_rx();
	RCALL _usart_no_rx
; 0000 02DF                 PTT = 1;
	SBI  0x1B,0
; 0000 02E0                 PORTD.1 = 1;
	SBI  0x12,1
; 0000 02E1                 delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	CALL SUBOPT_0x10
; 0000 02E2         	lcd_clear();
	CALL _lcd_clear
; 0000 02E3                 tx_data("","$$$$$$$$$$$$$$$$$$$,"STATION_STRING);
	__POINTW1MN _0xB0,0
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,1
	CALL SUBOPT_0x17
; 0000 02E4                 for(i=0;;i++)
	LDI  R17,LOW(0)
_0xB2:
; 0000 02E5                 {
; 0000 02E6 			lcd_clear();
	CALL _lcd_clear
; 0000 02E7                         lcd_putsf("Sending data:");
	__POINTW1FN _0x0,462
	CALL SUBOPT_0xD
; 0000 02E8                         delay_ms(150);
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x10
; 0000 02E9                 	if(data_perintah[i]=='$')
	CALL SUBOPT_0x16
	LD   R26,Z
	CPI  R26,LOW(0x24)
	BRNE _0xB4
; 0000 02EA                         {
; 0000 02EB                         	if((data_perintah[i+1]=='T')&&
; 0000 02EC                                 (data_perintah[i+2]=='E')&&
; 0000 02ED                                 (data_perintah[i+3]=='L'))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	BRNE _0xB6
	CALL SUBOPT_0x1A
	BRNE _0xB6
	MOVW R30,R22
	__ADDW1MN _data_perintah,3
	LD   R26,Z
	CPI  R26,LOW(0x4C)
	BREQ _0xB7
_0xB6:
	RJMP _0xB5
_0xB7:
; 0000 02EE                                 {
; 0000 02EF                         		tx_data("tipe protokol","$TEL*,");
	__POINTW1MN _0xB0,37
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,51
	CALL SUBOPT_0x17
; 0000 02F0                                         i+=3;
	SUBI R17,-LOW(3)
; 0000 02F1                                 }
; 0000 02F2 
; 0000 02F3                                 else if(data_perintah[i+1]=='$')
	RJMP _0xB8
_0xB5:
	CALL SUBOPT_0x18
	__ADDW1MN _data_perintah,1
	LD   R26,Z
	CPI  R26,LOW(0x24)
	BRNE _0xB9
; 0000 02F4                                 {
; 0000 02F5                                 	lcd_clear();
	CALL _lcd_clear
; 0000 02F6                                 }
; 0000 02F7 
; 0000 02F8                                 else if((data_perintah[i+1]!='T')||
	RJMP _0xBA
_0xB9:
; 0000 02F9                                 (data_perintah[i+2]!='E')||
; 0000 02FA                                 (data_perintah[i+3]!='L'))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x19
	BRNE _0xBC
	CALL SUBOPT_0x1A
	BRNE _0xBC
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x4C)
	BREQ _0xBB
_0xBC:
; 0000 02FB                                 {
; 0000 02FC                                         goto esc;
	RJMP _0xBE
; 0000 02FD                                 }
; 0000 02FE                         }
_0xBB:
_0xBA:
_0xB8:
; 0000 02FF 
; 0000 0300                         else if(data_perintah[i]==',')
	RJMP _0xBF
_0xB4:
	CALL SUBOPT_0x16
	LD   R26,Z
	CPI  R26,LOW(0x2C)
	BREQ PC+3
	JMP _0xC0
; 0000 0301                         {
; 0000 0302                         	if(data_perintah[i+1]==',')
	CALL SUBOPT_0x18
	__ADDW1MN _data_perintah,1
	LD   R26,Z
	CPI  R26,LOW(0x2C)
	BRNE _0xC1
; 0000 0303                                 {
; 0000 0304                                 	lcd_clear();
	CALL _lcd_clear
; 0000 0305                                 }
; 0000 0306 
; 0000 0307                                 else if((data_perintah[i+1]=='S')&&
	RJMP _0xC2
_0xC1:
; 0000 0308                                 (data_perintah[i+2]=='A')&&
; 0000 0309                                 (data_perintah[i+3]=='D'))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1C
	BRNE _0xC4
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x41)
	BRNE _0xC4
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x44)
	BREQ _0xC5
_0xC4:
	RJMP _0xC3
_0xC5:
; 0000 030A                                 {
; 0000 030B                                 	if(data_perintah[i+5]=='T')
	CALL SUBOPT_0x18
	__ADDW1MN _data_perintah,5
	LD   R26,Z
	CPI  R26,LOW(0x54)
	BRNE _0xC6
; 0000 030C                                         {
; 0000 030D                                         	tx_data("alamat stasiun","TELE*,");
	__POINTW1MN _0xB0,58
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,73
	CALL SUBOPT_0x17
; 0000 030E                                                 i+=5;
	SUBI R17,-LOW(5)
; 0000 030F                                         }
; 0000 0310                                 }
_0xC6:
; 0000 0311 
; 0000 0312                                 else if((data_perintah[i+1]=='S')&&
	RJMP _0xC7
_0xC3:
; 0000 0313                                 (data_perintah[i+2]=='E')&&
; 0000 0314                                 (data_perintah[i+3]=='T'))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1C
	BRNE _0xC9
	CALL SUBOPT_0x1A
	BRNE _0xC9
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x54)
	BREQ _0xCA
_0xC9:
	RJMP _0xC8
_0xCA:
; 0000 0315                                 {
; 0000 0316                                 	if((data_perintah[i+5]=='S')&&
; 0000 0317                                         (data_perintah[i+6]=='L')&&
; 0000 0318                                         (data_perintah[i+7]=='E')&&
; 0000 0319                                         (data_perintah[i+8]=='E')&&
; 0000 031A                                         (data_perintah[i+9]=='P'))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x53)
	BRNE _0xCC
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x4C)
	BRNE _0xCC
	CALL SUBOPT_0x20
	CPI  R26,LOW(0x45)
	BRNE _0xCC
	MOVW R30,R22
	__ADDW1MN _data_perintah,8
	LD   R26,Z
	CPI  R26,LOW(0x45)
	BRNE _0xCC
	MOVW R30,R22
	__ADDW1MN _data_perintah,9
	LD   R26,Z
	CPI  R26,LOW(0x50)
	BREQ _0xCD
_0xCC:
	RJMP _0xCB
_0xCD:
; 0000 031B                                         {
; 0000 031C                                         	tx_data("mode setting","SLEEP*,");
	__POINTW1MN _0xB0,80
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,93
	CALL SUBOPT_0x17
; 0000 031D                                                 sys_mode = S_SLEEP;
	LDI  R26,LOW(_sys_mode)
	LDI  R27,HIGH(_sys_mode)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 031E                                                 i+=9;
	SUBI R17,-LOW(9)
; 0000 031F                                         }
; 0000 0320 
; 0000 0321                                         else if((data_perintah[i+5]=='W')&&
	RJMP _0xCE
_0xCB:
; 0000 0322                                         (data_perintah[i+6]=='A')&&
; 0000 0323                                         (data_perintah[i+7]=='K')&&
; 0000 0324                                         (data_perintah[i+8]=='E'))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x57)
	BRNE _0xD0
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x41)
	BRNE _0xD0
	CALL SUBOPT_0x20
	CPI  R26,LOW(0x4B)
	BRNE _0xD0
	CALL SUBOPT_0x21
	CPI  R26,LOW(0x45)
	BREQ _0xD1
_0xD0:
	RJMP _0xCF
_0xD1:
; 0000 0325                                         {
; 0000 0326                                         	tx_data("mode setting","WAKE*,");
	__POINTW1MN _0xB0,101
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,114
	CALL SUBOPT_0x17
; 0000 0327                                                 sys_mode = S_WAKE;
	LDI  R26,LOW(_sys_mode)
	LDI  R27,HIGH(_sys_mode)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0328                                                 i+=8;
	SUBI R17,-LOW(8)
; 0000 0329                                         }
; 0000 032A                                 }
_0xCF:
_0xCE:
; 0000 032B 
; 0000 032C                                 else if((data_perintah[i+1]=='M')&&
	RJMP _0xD2
_0xC8:
; 0000 032D                                 (data_perintah[i+2]=='E')&&
; 0000 032E                                 (data_perintah[i+3]=='M'))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x22
	CPI  R26,LOW(0x4D)
	BRNE _0xD4
	CALL SUBOPT_0x1A
	BRNE _0xD4
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x4D)
	BREQ _0xD5
_0xD4:
	RJMP _0xD3
_0xD5:
; 0000 032F                                 {
; 0000 0330                                 	if((data_perintah[i+5]=='E')&&
; 0000 0331                                         (data_perintah[i+6]=='E')&&
; 0000 0332                                         (data_perintah[i+7]=='P'))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x45)
	BRNE _0xD7
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x45)
	BRNE _0xD7
	CALL SUBOPT_0x20
	CPI  R26,LOW(0x50)
	BREQ _0xD8
_0xD7:
	RJMP _0xD6
_0xD8:
; 0000 0333                                         {
; 0000 0334                                         	tx_data("tipe memori","EEP*,");
	__POINTW1MN _0xB0,121
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,133
	CALL SUBOPT_0x17
; 0000 0335                                                 i+=7;
	SUBI R17,-LOW(7)
; 0000 0336                                         }
; 0000 0337                                 }
_0xD6:
; 0000 0338 
; 0000 0339                                 else if((data_perintah[i+1]=='A')&&
	RJMP _0xD9
_0xD3:
; 0000 033A                                 (data_perintah[i+2]=='S')&&
; 0000 033B                                 (data_perintah[i+3]=='K')&&
; 0000 033C                                 (sys_mode))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x22
	CPI  R26,LOW(0x41)
	BRNE _0xDB
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x53)
	BRNE _0xDB
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x4B)
	BRNE _0xDB
	CALL SUBOPT_0x0
	BRNE _0xDC
_0xDB:
	RJMP _0xDA
_0xDC:
; 0000 033D                                 {
; 0000 033E                                 	if((data_perintah[i+5]=='I')&&
; 0000 033F                                         (data_perintah[i+6]=='D'))
	CALL SUBOPT_0x18
	MOVW R0,R30
	__ADDW1MN _data_perintah,5
	LD   R26,Z
	CPI  R26,LOW(0x49)
	BRNE _0xDE
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x44)
	BREQ _0xDF
_0xDE:
	RJMP _0xDD
_0xDF:
; 0000 0340                                         {
; 0000 0341                                         	tx_data("id stasiun","ANS-BALERANTE,");
	__POINTW1MN _0xB0,139
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,150
	CALL SUBOPT_0x17
; 0000 0342                                                 i+=6;
	SUBI R17,-LOW(6)
; 0000 0343                                         }
; 0000 0344 
; 0000 0345                                         else if((data_perintah[i+5]=='S')&&
	RJMP _0xE0
_0xDD:
; 0000 0346                                         (data_perintah[i+6]=='T')&&
; 0000 0347                                         (data_perintah[i+7]=='A')&&
; 0000 0348                                         (data_perintah[i+8]=='T'))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x53)
	BRNE _0xE2
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x54)
	BRNE _0xE2
	CALL SUBOPT_0x20
	CPI  R26,LOW(0x41)
	BRNE _0xE2
	CALL SUBOPT_0x21
	CPI  R26,LOW(0x54)
	BREQ _0xE3
_0xE2:
	RJMP _0xE1
_0xE3:
; 0000 0349                                         {
; 0000 034A                                         	if(sys_mode)
	CALL SUBOPT_0x0
	BREQ _0xE4
; 0000 034B                                                 {
; 0000 034C                                                 	tx_data("status service","ANS-SERVICE,");
	__POINTW1MN _0xB0,165
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,180
	RJMP _0x10D
; 0000 034D                                                 	i+=8;
; 0000 034E                                                 }
; 0000 034F 
; 0000 0350                                                 else if(!sys_mode)
_0xE4:
	CALL SUBOPT_0x0
	BRNE _0xE6
; 0000 0351                                                 {
; 0000 0352                                                 	tx_data("status service","ANS-SLEEP,");
	__POINTW1MN _0xB0,193
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,208
_0x10D:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _tx_data
; 0000 0353                                                 	i+=8;
	SUBI R17,-LOW(8)
; 0000 0354                                                 }
; 0000 0355                                         }
_0xE6:
; 0000 0356 
; 0000 0357                                         else if((data_perintah[i+5]=='O')&&
	RJMP _0xE7
_0xE1:
; 0000 0358                                         (data_perintah[i+6]=='M')&&
; 0000 0359                                         (data_perintah[i+7]=='E')&&
; 0000 035A                                         (data_perintah[i+8]=='G')&&
; 0000 035B                                         (data_perintah[i+9]=='A'))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x4F)
	BRNE _0xE9
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x4D)
	BRNE _0xE9
	CALL SUBOPT_0x20
	CPI  R26,LOW(0x45)
	BRNE _0xE9
	CALL SUBOPT_0x21
	CPI  R26,LOW(0x47)
	BRNE _0xE9
	MOVW R30,R22
	__ADDW1MN _data_perintah,9
	LD   R26,Z
	CPI  R26,LOW(0x41)
	BREQ _0xEA
_0xE9:
	RJMP _0xE8
_0xEA:
; 0000 035C                                         {
; 0000 035D                                         	if(data_perintah[i+10]=='1')
	CALL SUBOPT_0x18
	__ADDW1MN _data_perintah,10
	LD   R26,Z
	CPI  R26,LOW(0x31)
	BRNE _0xEB
; 0000 035E                                                 {
; 0000 035F                                                 	tx_data("data 1 konduktifitas","ANS-1");
	__POINTW1MN _0xB0,219
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,240
	CALL SUBOPT_0x17
; 0000 0360                                                 	putchar(read_adc(chn_omega1));
	CALL SUBOPT_0x8
	ST   -Y,R30
	CALL _putchar
; 0000 0361                                                 	puts(",");
	__POINTW1MN _0xB0,246
	RJMP _0x10E
; 0000 0362                                                 	i+=10;
; 0000 0363                                                 }
; 0000 0364 
; 0000 0365                                                 else if(data_perintah[i+10]=='2')
_0xEB:
	CALL SUBOPT_0x18
	__ADDW1MN _data_perintah,10
	LD   R26,Z
	CPI  R26,LOW(0x32)
	BRNE _0xED
; 0000 0366                                                 {
; 0000 0367                                                 	tx_data("data 2 konduktifitas","ANS-2");
	__POINTW1MN _0xB0,248
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,269
	CALL SUBOPT_0x17
; 0000 0368                                                 	putchar(read_adc(chn_omega2));
	CALL SUBOPT_0xA
	ST   -Y,R30
	CALL _putchar
; 0000 0369                                                 	puts(",");
	__POINTW1MN _0xB0,275
	RJMP _0x10E
; 0000 036A                                                 	i+=10;
; 0000 036B                                                 }
; 0000 036C 
; 0000 036D                                                 else if(data_perintah[i+10]=='3')
_0xED:
	CALL SUBOPT_0x18
	__ADDW1MN _data_perintah,10
	LD   R26,Z
	CPI  R26,LOW(0x33)
	BRNE _0xEF
; 0000 036E                                                 {
; 0000 036F                                                 	tx_data("data 3 konduktifitas","ANS-3");
	__POINTW1MN _0xB0,277
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,298
	CALL SUBOPT_0x17
; 0000 0370                                                 	putchar(read_adc(chn_omega3));
	CALL SUBOPT_0xB
	ST   -Y,R30
	CALL _putchar
; 0000 0371                                                 	puts(",");
	__POINTW1MN _0xB0,304
_0x10E:
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
; 0000 0372                                                 	i+=10;
	SUBI R17,-LOW(10)
; 0000 0373                                                 }
; 0000 0374                                         }
_0xEF:
; 0000 0375 
; 0000 0376                                 	else if((data_perintah[i+5]=='N')&&
	RJMP _0xF0
_0xE8:
; 0000 0377                                         (data_perintah[i+6]=='O')&&
; 0000 0378                                         (data_perintah[i+7]=='W'))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x4E)
	BRNE _0xF2
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x4F)
	BRNE _0xF2
	CALL SUBOPT_0x20
	CPI  R26,LOW(0x57)
	BREQ _0xF3
_0xF2:
	RJMP _0xF1
_0xF3:
; 0000 0379                                         {
; 0000 037A                                         	lcd_gotoxy(0,1);
	CALL SUBOPT_0xF
; 0000 037B                                                 lcd_putsf("kirim data sekarang");
	__POINTW1FN _0x0,705
	CALL SUBOPT_0xD
; 0000 037C                                                 kirim_data_sekarang();
	CALL SUBOPT_0x23
; 0000 037D                                                 PTT = 0;
; 0000 037E                                                 delay_ms(5000);
; 0000 037F                                                 PTT = 1;
	SBI  0x1B,0
; 0000 0380                                                 delay_ms(500);
	CALL SUBOPT_0x4
; 0000 0381                                                 kirim_data_sekarang();
	CALL SUBOPT_0x23
; 0000 0382                                                 PTT = 0;
; 0000 0383                                                 delay_ms(5000);
; 0000 0384                                                 PTT = 1;
	SBI  0x1B,0
; 0000 0385                                                 delay_ms(500);
	CALL SUBOPT_0x4
; 0000 0386                                                 kirim_data_sekarang();
	RCALL _kirim_data_sekarang
; 0000 0387                                                 xcount=0;
	CALL SUBOPT_0x2
; 0000 0388                                                 i+=7;
	SUBI R17,-LOW(7)
; 0000 0389                                         }
; 0000 038A                                 }
_0xF1:
_0xF0:
_0xE7:
_0xE0:
; 0000 038B 
; 0000 038C                                 else if((data_perintah[i+1]=='A')&&
	RJMP _0xFC
_0xDA:
; 0000 038D                                 (data_perintah[i+2]=='S')&&
; 0000 038E                                 (data_perintah[i+3]=='K')&&
; 0000 038F                                 (!sys_mode))
	CALL SUBOPT_0x18
	CALL SUBOPT_0x22
	CPI  R26,LOW(0x41)
	BRNE _0xFE
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x53)
	BRNE _0xFE
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x4B)
	BRNE _0xFE
	CALL SUBOPT_0x0
	BREQ _0xFF
_0xFE:
	RJMP _0xFD
_0xFF:
; 0000 0390                                 {
; 0000 0391                                 	tx_data("mode sleep","NANS,");
	__POINTW1MN _0xB0,306
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,317
	CALL SUBOPT_0x17
; 0000 0392                                         i+=10;
	SUBI R17,-LOW(10)
; 0000 0393                                 }
; 0000 0394                         }
_0xFD:
_0xFC:
_0xD9:
_0xD2:
_0xC7:
_0xC2:
; 0000 0395 
; 0000 0396                         else if(data_perintah[i]=='#')
	RJMP _0x100
_0xC0:
	CALL SUBOPT_0x16
	LD   R26,Z
	CPI  R26,LOW(0x23)
	BREQ _0xBE
; 0000 0397                         {
; 0000 0398                         	goto esc;
; 0000 0399                         }
; 0000 039A 
; 0000 039B                 }
_0x100:
_0xBF:
	SUBI R17,-1
	RJMP _0xB2
; 0000 039C 
; 0000 039D                 esc:
_0xBE:
; 0000 039E 
; 0000 039F                 PTT = 1;
	SBI  0x1B,0
; 0000 03A0                 lcd_clear();
	RCALL _lcd_clear
; 0000 03A1                 lcd_putsf("SELESAI");
	__POINTW1FN _0x0,742
	CALL SUBOPT_0xD
; 0000 03A2                 delay_ms(100);
	CALL SUBOPT_0x15
; 0000 03A3                 lcd_clear();
	RCALL _lcd_clear
; 0000 03A4                 putchar('\n');
	CALL SUBOPT_0x7
; 0000 03A5                 tx_data("","############");
	__POINTW1MN _0xB0,323
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1MN _0xB0,324
	CALL SUBOPT_0x17
; 0000 03A6                 PTT = 0;
	CBI  0x1B,0
; 0000 03A7         	banner_sys();
	RCALL _banner_sys
; 0000 03A8                 usart_init();
	RCALL _usart_init
; 0000 03A9 
; 0000 03AA                 goto keluar;
; 0000 03AB 	}
; 0000 03AC         keluar:
_0xA5:
; 0000 03AD         //#asm("sei")
; 0000 03AE }
	LD   R17,Y+
	RET

	.DSEG
_0xB0:
	.BYTE 0x151
;
;void main(void)
; 0000 03B1 {

	.CSEG
_main:
; 0000 03B2 	PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 03B3 	DDRA=0x81;
	LDI  R30,LOW(129)
	OUT  0x1A,R30
; 0000 03B4 	PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 03B5 	DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 03B6 	PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 03B7 	DDRC=0x0F;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 03B8 	PORTD=0xF7;
	LDI  R30,LOW(247)
	OUT  0x12,R30
; 0000 03B9 	DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 03BA 
; 0000 03BB         TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 03BC 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 03BD 	TCNT1H=0xFB;
	LDI  R30,LOW(251)
	OUT  0x2D,R30
; 0000 03BE 	TCNT1L=0xF0;
	LDI  R30,LOW(240)
	OUT  0x2C,R30
; 0000 03BF 	ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x27,R30
; 0000 03C0 	ICR1L=0x00;
	OUT  0x26,R30
; 0000 03C1 	OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 03C2 	OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 03C3 	OCR1BH=0x00;
	OUT  0x29,R30
; 0000 03C4 	OCR1BL=0x00;
	OUT  0x28,R30
; 0000 03C5 
; 0000 03C6 	TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 03C7 
; 0000 03C8         data_valid = 0;
	CLT
	BLD  R2,0
; 0000 03C9 
; 0000 03CA 	usart_init();
	RCALL _usart_init
; 0000 03CB 	adc_init();
	RCALL _adc_init
; 0000 03CC 	lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 03CD         banner_pembuka();
	RCALL _banner_pembuka
; 0000 03CE         no_menu = 1;
	LDI  R26,LOW(_no_menu)
	LDI  R27,HIGH(_no_menu)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 03CF         last_menu = no_menu;
	CALL SUBOPT_0x11
	LDI  R26,LOW(_last_menu)
	LDI  R27,HIGH(_last_menu)
	CALL __EEPROMWRB
; 0000 03D0         switch_to_modem();
	RCALL _switch_to_modem
; 0000 03D1         //goto_menu();
; 0000 03D2         banner_sys();
	RCALL _banner_sys
; 0000 03D3         //#asm("sei")
; 0000 03D4 
; 0000 03D5 	while (1)
_0x107:
; 0000 03D6       	{
; 0000 03D7                 if(!TOM_ENTER) {no_menu = last_menu; goto_menu();}
	SBIC 0x10,4
	RJMP _0x10A
	LDI  R26,LOW(_last_menu)
	LDI  R27,HIGH(_last_menu)
	CALL __EEPROMRDB
	CALL SUBOPT_0x14
	RCALL _goto_menu
; 0000 03D8                 baca_perintah();
_0x10A:
	RCALL _baca_perintah
; 0000 03D9       	}
	RJMP _0x107
; 0000 03DA }
_0x10B:
	RJMP _0x10B
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
	SBI  0x18,4
	RJMP _0x2000005
_0x2000004:
	CBI  0x18,4
_0x2000005:
	LD   R30,Y
	ANDI R30,LOW(0x20)
	BREQ _0x2000006
	SBI  0x18,5
	RJMP _0x2000007
_0x2000006:
	CBI  0x18,5
_0x2000007:
	LD   R30,Y
	ANDI R30,LOW(0x40)
	BREQ _0x2000008
	SBI  0x18,6
	RJMP _0x2000009
_0x2000008:
	CBI  0x18,6
_0x2000009:
	LD   R30,Y
	ANDI R30,LOW(0x80)
	BREQ _0x200000A
	SBI  0x18,7
	RJMP _0x200000B
_0x200000A:
	CBI  0x18,7
_0x200000B:
	__DELAY_USB 7
	SBI  0x18,2
	__DELAY_USB 18
	CBI  0x18,2
	__DELAY_USB 18
	JMP  _0x2080002
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
	__DELAY_USB 184
	JMP  _0x2080002
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
	LDD  R5,Y+1
	LDD  R4,Y+0
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x24
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x24
	LDI  R30,LOW(0)
	MOV  R4,R30
	MOV  R5,R30
	RET
_lcd_putchar:
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BREQ _0x2000011
	CP   R5,R7
	BRLO _0x2000010
_0x2000011:
	LDI  R30,LOW(0)
	ST   -Y,R30
	INC  R4
	ST   -Y,R4
	RCALL _lcd_gotoxy
	LD   R26,Y
	CPI  R26,LOW(0xA)
	BRNE _0x2000013
	JMP  _0x2080002
_0x2000013:
_0x2000010:
	INC  R5
	SBI  0x18,0
	LD   R30,Y
	ST   -Y,R30
	RCALL __lcd_write_data
	CBI  0x18,0
	JMP  _0x2080002
_lcd_puts:
	ST   -Y,R17
_0x2000014:
	CALL SUBOPT_0x25
	BREQ _0x2000016
	ST   -Y,R17
	RCALL _lcd_putchar
	RJMP _0x2000014
_0x2000016:
	JMP  _0x2080001
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
	JMP  _0x2080001
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
	LDD  R7,Y+0
	LD   R30,Y
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G100,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G100,3
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x10
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	CALL SUBOPT_0x26
	LDI  R30,LOW(32)
	ST   -Y,R30
	RCALL __lcd_write_nibble_G100
	__DELAY_USW 276
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
	JMP  _0x2080002
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
_0x2080002:
	ADIW R28,1
	RET
_puts:
	ST   -Y,R17
_0x2020003:
	CALL SUBOPT_0x25
	BREQ _0x2020005
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2020003
_0x2020005:
	CALL SUBOPT_0x7
_0x2080001:
	LDD  R17,Y+0
	ADIW R28,3
	RET

	.CSEG

	.CSEG

	.ESEG
_data_petir:
	.BYTE 0x3E8
_no_menu:
	.BYTE 0x1
_last_menu:
	.BYTE 0x1

	.DSEG
_data_perintah:
	.BYTE 0xC8

	.ESEG
_sys_mode:
	.DB  0x0
_chn_omega1:
	.DB  0x1
_chn_omega2:
	.DB  0x2
_chn_omega3:
	.DB  0x3
_chn_petir:
	.DB  0x4
_xcount:
	.DW  0x0

	.DSEG
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_sys_mode)
	LDI  R27,HIGH(_sys_mode)
	CALL __EEPROMRDB
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	LDI  R26,LOW(_xcount)
	LDI  R27,HIGH(_xcount)
	CALL __EEPROMRDW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_xcount)
	LDI  R27,HIGH(_xcount)
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	CALL __EEPROMWRW
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x3:
	CALL __EEPROMRDB
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x6:
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(44)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(10)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_chn_omega1)
	LDI  R27,HIGH(_chn_omega1)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x9:
	ST   -Y,R30
	CALL _putchar
	LDI  R30,LOW(44)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_chn_omega2)
	LDI  R27,HIGH(_chn_omega2)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_chn_omega3)
	LDI  R27,HIGH(_chn_omega3)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0xC:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xD:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	RJMP SUBOPT_0xC

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 44 TIMES, CODE SIZE REDUCTION:83 WORDS
SUBOPT_0x11:
	LDI  R26,LOW(_no_menu)
	LDI  R27,HIGH(_no_menu)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x14:
	LDI  R26,LOW(_no_menu)
	LDI  R27,HIGH(_no_menu)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x16:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_data_perintah)
	SBCI R31,HIGH(-_data_perintah)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x17:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _tx_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:35 WORDS
SUBOPT_0x18:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	MOVW R22,R30
	MOVW R0,R30
	__ADDW1MN _data_perintah,1
	LD   R26,Z
	CPI  R26,LOW(0x54)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1A:
	MOVW R30,R0
	__ADDW1MN _data_perintah,2
	LD   R26,Z
	CPI  R26,LOW(0x45)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	MOVW R30,R22
	__ADDW1MN _data_perintah,3
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	MOVW R22,R30
	MOVW R0,R30
	__ADDW1MN _data_perintah,1
	LD   R26,Z
	CPI  R26,LOW(0x53)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	MOVW R30,R0
	__ADDW1MN _data_perintah,2
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1E:
	MOVW R22,R30
	MOVW R0,R30
	__ADDW1MN _data_perintah,5
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1F:
	MOVW R30,R0
	__ADDW1MN _data_perintah,6
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x20:
	MOVW R30,R22
	__ADDW1MN _data_perintah,7
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	MOVW R30,R22
	__ADDW1MN _data_perintah,8
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x22:
	MOVW R22,R30
	MOVW R0,R30
	__ADDW1MN _data_perintah,1
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x23:
	CALL _kirim_data_sekarang
	CBI  0x1B,0
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x24:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x25:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x26:
	LDI  R30,LOW(48)
	ST   -Y,R30
	CALL __lcd_write_nibble_G100
	__DELAY_USW 276
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
