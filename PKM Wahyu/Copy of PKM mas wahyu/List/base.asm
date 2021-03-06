
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

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x0:
	.DB  0x6B,0x69,0x72,0x69,0x6D,0x20,0x70,0x65
	.DB  0x72,0x69,0x6E,0x74,0x61,0x68,0x0,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x54,0x45,0x4C
	.DB  0x2C,0x53,0x45,0x54,0x2D,0x57,0x41,0x4B
	.DB  0x45,0x2C,0x41,0x53,0x4B,0x2D,0x4F,0x4D
	.DB  0x45,0x47,0x41,0x32,0x2C,0x41,0x53,0x4B
	.DB  0x2D,0x49,0x44,0x2C,0x41,0x53,0x4B,0x2C
	.DB  0x4F,0x4D,0x45,0x47,0x41,0x33,0x2C,0x53
	.DB  0x41,0x44,0x2D,0x54,0x2C,0x41,0x53,0x4B
	.DB  0x2D,0x4F,0x4D,0x45,0x47,0x41,0x31,0x2C
	.DB  0x53,0x45,0x54,0x2D,0x53,0x4C,0x45,0x45
	.DB  0x50,0x23,0x23,0x23,0x23,0x0,0x6D,0x65
	.DB  0x6E,0x75,0x6E,0x67,0x67,0x75,0x20,0x64
	.DB  0x61,0x74,0x61,0x20,0x64,0x69,0x74,0x65
	.DB  0x72,0x69,0x6D,0x61,0x2E,0x2E,0x2E,0x2E
	.DB  0x2E,0x2E,0x2E,0x2E,0x2E,0x2E,0x2E,0x2E
	.DB  0x2E,0x0,0x44,0x41,0x54,0x41,0x20,0x44
	.DB  0x41,0x52,0x49,0x20,0x53,0x54,0x41,0x53
	.DB  0x49,0x55,0x4E,0x20,0x54,0x45,0x4C,0x45
	.DB  0x0,0x24,0x24,0x24,0x24,0x24,0x24,0x54
	.DB  0x45,0x4C,0x2C,0x41,0x53,0x4B,0x2D,0x53
	.DB  0x54,0x41,0x54,0x2C,0x41,0x53,0x4B,0x2D
	.DB  0x4F,0x4D,0x45,0x47,0x41,0x32,0x2C,0x41
	.DB  0x53,0x4B,0x2D,0x49,0x44,0x2C,0x41,0x53
	.DB  0x4B,0x2D,0x4F,0x4D,0x45,0x47,0x41,0x33
	.DB  0x2C,0x53,0x41,0x44,0x2D,0x54,0x2C,0x41
	.DB  0x53,0x4B,0x2D,0x4F,0x4D,0x45,0x47,0x41
	.DB  0x31,0x2C,0x53,0x45,0x54,0x2D,0x57,0x41
	.DB  0x4B,0x45,0x23,0x23,0x23,0x23,0x0,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x54,0x45,0x4C
	.DB  0x2C,0x41,0x53,0x4B,0x2D,0x53,0x54,0x41
	.DB  0x54,0x2C,0x53,0x41,0x44,0x2D,0x54,0x2C
	.DB  0x53,0x45,0x54,0x2D,0x57,0x41,0x4B,0x45
	.DB  0x2C,0x41,0x53,0x4B,0x2D,0x49,0x44,0x2C
	.DB  0x41,0x53,0x4B,0x2D,0x53,0x54,0x41,0x54
	.DB  0x2C,0x41,0x53,0x4B,0x2D,0x4F,0x4D,0x45
	.DB  0x47,0x41,0x31,0x2C,0x41,0x53,0x4B,0x2D
	.DB  0x4F,0x4D,0x45,0x47,0x41,0x32,0x2C,0x41
	.DB  0x53,0x4B,0x2D,0x4F,0x4D,0x45,0x47,0x41
	.DB  0x33,0x2C,0x53,0x45,0x54,0x2D,0x53,0x4C
	.DB  0x45,0x45,0x50,0x23,0x23,0x23,0x23,0x0
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x0,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x54,0x45,0x4C
	.DB  0x2C,0x53,0x45,0x54,0x2D,0x57,0x41,0x4B
	.DB  0x45,0x2C,0x41,0x46,0x78,0x4B,0x2D,0x4E
	.DB  0x4F,0x57,0x23,0x23,0x23,0x23,0x23,0x0
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x24,0x24,0x24,0x24,0x24,0x24
	.DB  0x24,0x24,0x24,0x23,0x23,0x23,0x23,0x23
	.DB  0x23,0x23,0x23,0x23,0x23,0x23,0x23,0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
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
;� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
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
;#include <delay.h>
;#include <alcd.h>
;#include <stdio.h>
;
;char eeprom data_rx[1000];
;
;void tampil_lcd(void)
; 0000 0020 {

	.CSEG
_tampil_lcd:
; 0000 0021       	char i;
; 0000 0022         for(i=0;;i++)
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x4:
; 0000 0023         {
; 0000 0024                 if(data_rx[i]=='#') goto out;
	CALL SUBOPT_0x0
	CPI  R30,LOW(0x23)
	BREQ _0x7
; 0000 0025                 if(data_rx[i]==',') {delay_ms(500);lcd_clear();}
	CALL SUBOPT_0x0
	CPI  R30,LOW(0x2C)
	BRNE _0x8
	CALL SUBOPT_0x1
	RCALL _lcd_clear
; 0000 0026                 lcd_putchar(data_rx[i]);
_0x8:
	CALL SUBOPT_0x0
	ST   -Y,R30
	RCALL _lcd_putchar
; 0000 0027         }
	SUBI R17,-1
	RJMP _0x4
; 0000 0028         out:
_0x7:
; 0000 0029 }
	LD   R17,Y+
	RET
;
;void terima_data(void)
; 0000 002C {
_terima_data:
; 0000 002D 	char i,c_buff;
; 0000 002E         while(getchar()!='$');
	ST   -Y,R17
	ST   -Y,R16
;	i -> R17
;	c_buff -> R16
_0x9:
	CALL _getchar
	CPI  R30,LOW(0x24)
	BRNE _0x9
; 0000 002F         while(getchar()=='$');
_0xC:
	CALL _getchar
	CPI  R30,LOW(0x24)
	BREQ _0xC
; 0000 0030         for(i=0;;i++)
	LDI  R17,LOW(0)
_0x10:
; 0000 0031         {
; 0000 0032         	c_buff = getchar();
	CALL _getchar
	MOV  R16,R30
; 0000 0033                 data_rx[i]=c_buff;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_data_rx)
	SBCI R27,HIGH(-_data_rx)
	MOV  R30,R16
	CALL __EEPROMWRB
; 0000 0034                 if(data_rx[i]=='#') goto out;
	CALL SUBOPT_0x0
	CPI  R30,LOW(0x23)
	BREQ _0x13
; 0000 0035         }
	SUBI R17,-1
	RJMP _0x10
; 0000 0036         out:
_0x13:
; 0000 0037 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;
;void main(void)
; 0000 003A {
_main:
; 0000 003B // Declare your local variables here
; 0000 003C 
; 0000 003D // Input/Output Ports initialization
; 0000 003E // Port A initialization
; 0000 003F // Func7=Out Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=Out
; 0000 0040 // State7=0 State6=T State5=T State4=T State3=T State2=T State1=T State0=0
; 0000 0041 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 0042 DDRA=0x81;
	LDI  R30,LOW(129)
	OUT  0x1A,R30
; 0000 0043 
; 0000 0044 // Port B initialization
; 0000 0045 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0046 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0047 PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0048 DDRB=0x00;
	OUT  0x17,R30
; 0000 0049 
; 0000 004A // Port C initialization
; 0000 004B // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 004C // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 004D PORTC=0x00;
	OUT  0x15,R30
; 0000 004E DDRC=0x00;
	OUT  0x14,R30
; 0000 004F 
; 0000 0050 // Port D initialization
; 0000 0051 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
; 0000 0052 // State7=P State6=P State5=P State4=P State3=T State2=T State1=1 State0=P
; 0000 0053 PORTD=0xF3;
	LDI  R30,LOW(243)
	OUT  0x12,R30
; 0000 0054 DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 0055 
; 0000 0056 // Timer/Counter 0 initialization
; 0000 0057 // Clock source: System Clock
; 0000 0058 // Clock value: Timer 0 Stopped
; 0000 0059 // Mode: Normal top=0xFF
; 0000 005A // OC0 output: Disconnected
; 0000 005B TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
; 0000 005C TCNT0=0x00;
	OUT  0x32,R30
; 0000 005D OCR0=0x00;
	OUT  0x3C,R30
; 0000 005E 
; 0000 005F // Timer/Counter 1 initialization
; 0000 0060 // Clock source: System Clock
; 0000 0061 // Clock value: Timer1 Stopped
; 0000 0062 // Mode: Normal top=0xFFFF
; 0000 0063 // OC1A output: Discon.
; 0000 0064 // OC1B output: Discon.
; 0000 0065 // Noise Canceler: Off
; 0000 0066 // Input Capture on Falling Edge
; 0000 0067 // Timer1 Overflow Interrupt: Off
; 0000 0068 // Input Capture Interrupt: Off
; 0000 0069 // Compare A Match Interrupt: Off
; 0000 006A // Compare B Match Interrupt: Off
; 0000 006B TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 006C TCCR1B=0x00;
	OUT  0x2E,R30
; 0000 006D TCNT1H=0x00;
	OUT  0x2D,R30
; 0000 006E TCNT1L=0x00;
	OUT  0x2C,R30
; 0000 006F ICR1H=0x00;
	OUT  0x27,R30
; 0000 0070 ICR1L=0x00;
	OUT  0x26,R30
; 0000 0071 OCR1AH=0x00;
	OUT  0x2B,R30
; 0000 0072 OCR1AL=0x00;
	OUT  0x2A,R30
; 0000 0073 OCR1BH=0x00;
	OUT  0x29,R30
; 0000 0074 OCR1BL=0x00;
	OUT  0x28,R30
; 0000 0075 
; 0000 0076 // Timer/Counter 2 initialization
; 0000 0077 // Clock source: System Clock
; 0000 0078 // Clock value: Timer2 Stopped
; 0000 0079 // Mode: Normal top=0xFF
; 0000 007A // OC2 output: Disconnected
; 0000 007B ASSR=0x00;
	OUT  0x22,R30
; 0000 007C TCCR2=0x00;
	OUT  0x25,R30
; 0000 007D TCNT2=0x00;
	OUT  0x24,R30
; 0000 007E OCR2=0x00;
	OUT  0x23,R30
; 0000 007F 
; 0000 0080 // External Interrupt(s) initialization
; 0000 0081 // INT0: Off
; 0000 0082 // INT1: Off
; 0000 0083 // INT2: Off
; 0000 0084 MCUCR=0x00;
	OUT  0x35,R30
; 0000 0085 MCUCSR=0x00;
	OUT  0x34,R30
; 0000 0086 
; 0000 0087 // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0088 TIMSK=0x00;
	OUT  0x39,R30
; 0000 0089 
; 0000 008A // USART initialization
; 0000 008B // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 008C // USART Receiver: On
; 0000 008D // USART Transmitter: On
; 0000 008E // USART Mode: Asynchronous
; 0000 008F // USART Baud Rate: 1200
; 0000 0090 UCSRA=0x00;
	OUT  0xB,R30
; 0000 0091 UCSRB=0x18;
	LDI  R30,LOW(24)
	OUT  0xA,R30
; 0000 0092 UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 0093 UBRRH=0x02;
	LDI  R30,LOW(2)
	OUT  0x20,R30
; 0000 0094 UBRRL=0x3F;
	LDI  R30,LOW(63)
	OUT  0x9,R30
; 0000 0095 
; 0000 0096 // Analog Comparator initialization
; 0000 0097 // Analog Comparator: Off
; 0000 0098 // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 0099 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 009A SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 009B 
; 0000 009C // ADC initialization
; 0000 009D // ADC disabled
; 0000 009E ADCSRA=0x00;
	OUT  0x6,R30
; 0000 009F 
; 0000 00A0 // SPI initialization
; 0000 00A1 // SPI disabled
; 0000 00A2 SPCR=0x00;
	OUT  0xD,R30
; 0000 00A3 
; 0000 00A4 // TWI initialization
; 0000 00A5 // TWI disabled
; 0000 00A6 TWCR=0x00;
	OUT  0x36,R30
; 0000 00A7 
; 0000 00A8 // Alphanumeric LCD initialization
; 0000 00A9 // Connections specified in the
; 0000 00AA // Project|Configure|C Compiler|Libraries|Alphanumeric LCD menu:
; 0000 00AB // RS - PORTB Bit 0
; 0000 00AC // RD - PORTB Bit 1
; 0000 00AD // EN - PORTB Bit 2
; 0000 00AE // D4 - PORTB Bit 4
; 0000 00AF // D5 - PORTB Bit 5
; 0000 00B0 // D6 - PORTB Bit 6
; 0000 00B1 // D7 - PORTB Bit 7
; 0000 00B2 // Characters/line: 16
; 0000 00B3 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 00B4 delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x2
; 0000 00B5 delay_ms(4000);
	LDI  R30,LOW(4000)
	LDI  R31,HIGH(4000)
	CALL SUBOPT_0x2
; 0000 00B6 while (1)
_0x14:
; 0000 00B7       	{
; 0000 00B8         	lcd_clear();
	CALL SUBOPT_0x3
; 0000 00B9                 lcd_putsf("kirim perintah");
; 0000 00BA                 delay_ms(500);
; 0000 00BB                 PORTA.0 = 1;
	CALL SUBOPT_0x4
; 0000 00BC                 PORTD.1 = 1;
; 0000 00BD                 delay_ms(300);
; 0000 00BE                 putsf("$$$$$$TEL,SET-WAKE,ASK-OMEGA2,ASK-ID,ASK,OMEGA3,SAD-T,ASK-OMEGA1,SET-SLEEP####");
	__POINTW1FN _0x0,15
	CALL SUBOPT_0x5
; 0000 00BF                 lcd_clear();
; 0000 00C0                 lcd_putsf("menunggu data diterima.............");
; 0000 00C1                 PORTA.0 = 0;
; 0000 00C2                 terima_data();
; 0000 00C3                 lcd_clear();
; 0000 00C4                 lcd_putsf("DATA DARI STASIUN TELE");
; 0000 00C5                 delay_ms(500);
; 0000 00C6                 lcd_clear();
	CALL SUBOPT_0x6
; 0000 00C7                 tampil_lcd();
; 0000 00C8                 delay_ms(3000);
; 0000 00C9 
; 0000 00CA                 lcd_clear();
	CALL SUBOPT_0x3
; 0000 00CB                 lcd_putsf("kirim perintah");
; 0000 00CC                 delay_ms(500);
; 0000 00CD                 PORTA.0 = 1;
	CALL SUBOPT_0x4
; 0000 00CE                 PORTD.1 = 1;
; 0000 00CF                 delay_ms(300);
; 0000 00D0                 putsf("$$$$$$TEL,ASK-STAT,ASK-OMEGA2,ASK-ID,ASK-OMEGA3,SAD-T,ASK-OMEGA1,SET-WAKE####");
	__POINTW1FN _0x0,153
	CALL SUBOPT_0x5
; 0000 00D1                 lcd_clear();
; 0000 00D2                 lcd_putsf("menunggu data diterima.............");
; 0000 00D3                 PORTA.0 = 0;
; 0000 00D4                 terima_data();
; 0000 00D5                 lcd_clear();
; 0000 00D6                 lcd_putsf("DATA DARI STASIUN TELE");
; 0000 00D7                 delay_ms(500);
; 0000 00D8                 lcd_clear();
	CALL SUBOPT_0x6
; 0000 00D9                 tampil_lcd();
; 0000 00DA                 delay_ms(3000);
; 0000 00DB 
; 0000 00DC                 lcd_clear();
	CALL SUBOPT_0x3
; 0000 00DD                 lcd_putsf("kirim perintah");
; 0000 00DE                 delay_ms(500);
; 0000 00DF                 PORTA.0 = 1;
	CALL SUBOPT_0x4
; 0000 00E0                 PORTD.1 = 1;
; 0000 00E1                 delay_ms(300);
; 0000 00E2                 putsf("$$$$$$TEL,ASK-STAT,SAD-T,SET-WAKE,ASK-ID,ASK-STAT,ASK-OMEGA1,ASK-OMEGA2,ASK-OMEGA3,SET-SLEEP####");
	__POINTW1FN _0x0,231
	CALL SUBOPT_0x5
; 0000 00E3                 lcd_clear();
; 0000 00E4                 lcd_putsf("menunggu data diterima.............");
; 0000 00E5                 PORTA.0 = 0;
; 0000 00E6                 terima_data();
; 0000 00E7                 lcd_clear();
; 0000 00E8                 lcd_putsf("DATA DARI STASIUN TELE");
; 0000 00E9                 delay_ms(500);
; 0000 00EA                 lcd_clear();
	CALL SUBOPT_0x6
; 0000 00EB                 tampil_lcd();
; 0000 00EC                 delay_ms(3000);
; 0000 00ED 
; 0000 00EE                 lcd_clear();
	CALL SUBOPT_0x3
; 0000 00EF                 lcd_putsf("kirim perintah");
; 0000 00F0                 delay_ms(500);
; 0000 00F1                 PORTA.0 = 1;
	CALL SUBOPT_0x4
; 0000 00F2                 PORTD.1 = 1;
; 0000 00F3                 delay_ms(300);
; 0000 00F4                 putsf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$##################################");
	__POINTW1FN _0x0,328
	CALL SUBOPT_0x5
; 0000 00F5                 lcd_clear();
; 0000 00F6                 lcd_putsf("menunggu data diterima.............");
; 0000 00F7                 PORTA.0 = 0;
; 0000 00F8                 terima_data();
; 0000 00F9                 lcd_clear();
; 0000 00FA                 lcd_putsf("DATA DARI STASIUN TELE");
; 0000 00FB                 delay_ms(500);
; 0000 00FC                 lcd_clear();
	CALL SUBOPT_0x6
; 0000 00FD                 tampil_lcd();
; 0000 00FE                 delay_ms(3000);
; 0000 00FF 
; 0000 0100                 lcd_clear();
	CALL SUBOPT_0x3
; 0000 0101                 lcd_putsf("kirim perintah");
; 0000 0102                 delay_ms(500);
; 0000 0103                 PORTA.0 = 1;
	CALL SUBOPT_0x4
; 0000 0104                 PORTD.1 = 1;
; 0000 0105                 delay_ms(300);
; 0000 0106                 putsf("$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$##################################");
	__POINTW1FN _0x0,328
	CALL SUBOPT_0x5
; 0000 0107                 lcd_clear();
; 0000 0108                 lcd_putsf("menunggu data diterima.............");
; 0000 0109                 PORTA.0 = 0;
; 0000 010A                 terima_data();
; 0000 010B                 lcd_clear();
; 0000 010C                 lcd_putsf("DATA DARI STASIUN TELE");
; 0000 010D                 delay_ms(500);
; 0000 010E                 lcd_clear();
	CALL SUBOPT_0x6
; 0000 010F                 tampil_lcd();
; 0000 0110                 delay_ms(3000);
; 0000 0111 
; 0000 0112                 lcd_clear();
	CALL SUBOPT_0x3
; 0000 0113                 lcd_putsf("kirim perintah");
; 0000 0114                 delay_ms(500);
; 0000 0115                 PORTA.0 = 1;
	CALL SUBOPT_0x4
; 0000 0116                 PORTD.1 = 1;
; 0000 0117                 delay_ms(300);
; 0000 0118                 putsf("$$$$$$TEL,SET-WAKE,AFxK-NOW#####");
	__POINTW1FN _0x0,399
	CALL SUBOPT_0x5
; 0000 0119                 lcd_clear();
; 0000 011A                 lcd_putsf("menunggu data diterima.............");
; 0000 011B                 PORTA.0 = 0;
; 0000 011C                 terima_data();
; 0000 011D                 lcd_clear();
; 0000 011E                 lcd_putsf("DATA DARI STASIUN TELE");
; 0000 011F                 delay_ms(500);
; 0000 0120                 lcd_clear();
	CALL SUBOPT_0x6
; 0000 0121                 tampil_lcd();
; 0000 0122                 delay_ms(3000);
; 0000 0123 
; 0000 0124                 lcd_clear();
	CALL SUBOPT_0x3
; 0000 0125                 lcd_putsf("kirim perintah");
; 0000 0126                 delay_ms(500);
; 0000 0127                 PORTA.0 = 1;
	CALL SUBOPT_0x4
; 0000 0128                 PORTD.1 = 1;
; 0000 0129                 delay_ms(300);
; 0000 012A                 putsf("$$$$$$$$$$$$$$$$$$$$$$$$$$$############");
	__POINTW1FN _0x0,432
	CALL SUBOPT_0x5
; 0000 012B                 lcd_clear();
; 0000 012C                 lcd_putsf("menunggu data diterima.............");
; 0000 012D                 PORTA.0 = 0;
; 0000 012E                 terima_data();
; 0000 012F                 lcd_clear();
; 0000 0130                 lcd_putsf("DATA DARI STASIUN TELE");
; 0000 0131                 delay_ms(500);
; 0000 0132                 lcd_clear();
	CALL SUBOPT_0x6
; 0000 0133                 tampil_lcd();
; 0000 0134                 delay_ms(3000);
; 0000 0135       	}
	RJMP _0x14
; 0000 0136 }
_0x41:
	RJMP _0x41
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
	CALL SUBOPT_0x7
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x7
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
_lcd_putsf:
	ST   -Y,R17
_0x2000017:
	CALL SUBOPT_0x8
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
	CALL SUBOPT_0x2
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
	CALL SUBOPT_0x9
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
_putsf:
	ST   -Y,R17
_0x2020006:
	CALL SUBOPT_0x8
	BREQ _0x2020008
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2020006
_0x2020008:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _putchar
_0x2080001:
	LDD  R17,Y+0
	ADIW R28,3
	RET

	.CSEG

	.CSEG

	.ESEG
_data_rx:
	.BYTE 0x3E8

	.DSEG
__base_y_G100:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x0:
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_data_rx)
	SBCI R27,HIGH(-_data_rx)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 15 TIMES, CODE SIZE REDUCTION:53 WORDS
SUBOPT_0x1:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x3:
	CALL _lcd_clear
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x4:
	SBI  0x1B,0
	SBI  0x12,1
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:135 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	CALL _putsf
	CALL _lcd_clear
	__POINTW1FN _0x0,94
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	CBI  0x1B,0
	CALL _terima_data
	CALL _lcd_clear
	__POINTW1FN _0x0,130
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x6:
	CALL _lcd_clear
	CALL _tampil_lcd
	LDI  R30,LOW(3000)
	LDI  R31,HIGH(3000)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x8:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x9:
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

;END OF CODE MARKER
__END_OF_CODE:
