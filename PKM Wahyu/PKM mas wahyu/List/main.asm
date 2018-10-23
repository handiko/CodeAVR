
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

_0x0:
	.DB  0x2C,0x2C,0x4A,0x54,0x46,0x5F,0x42,0x41
	.DB  0x4C,0x45,0x52,0x41,0x4E,0x54,0x45,0x2C
	.DB  0x3E,0x24,0x54,0x45,0x4C,0x2C,0x7E,0x0
	.DB  0x2C,0x2C,0x4A,0x54,0x46,0x5F,0x42,0x41
	.DB  0x4C,0x45,0x52,0x41,0x4E,0x54,0x45,0x2C
	.DB  0x3E,0x24,0x54,0x45,0x4C,0x2A,0x2C,0x50
	.DB  0x45,0x54,0x49,0x52,0x2A,0x2C,0x0,0x2A
	.DB  0x32,0x35,0x2A,0x2C,0x0,0x45,0x4E,0x44
	.DB  0x2A,0x2C,0x0,0x2C,0x2C,0x4A,0x54,0x46
	.DB  0x5F,0x42,0x41,0x4C,0x45,0x52,0x41,0x4E
	.DB  0x54,0x45,0x2C,0x3E,0x24,0x54,0x45,0x4C
	.DB  0x2A,0x2C,0x4F,0x4D,0x45,0x47,0x41,0x2A
	.DB  0x2C,0x0,0x2C,0x2A,0x33,0x2A,0x2C,0x0
	.DB  0x2A,0x32,0x35,0x2A,0x0,0x2A,0x45,0x4E
	.DB  0x44,0x2A,0x2C,0x0,0x2D,0x2D,0x2D,0x2D
	.DB  0x4A,0x54,0x46,0x2E,0x55,0x47,0x4D,0x2D
	.DB  0x2D,0x2D,0x2D,0x2D,0x0,0x20,0x53,0x69
	.DB  0x73,0x74,0x65,0x6D,0x0,0x20,0x4D,0x6F
	.DB  0x6E,0x69,0x74,0x6F,0x72,0x69,0x6E,0x67
	.DB  0x0,0x20,0x44,0x73,0x2E,0x20,0x42,0x61
	.DB  0x6C,0x65,0x72,0x61,0x6E,0x74,0x65,0x0
	.DB  0x20,0x47,0x6E,0x2E,0x20,0x4D,0x65,0x72
	.DB  0x61,0x70,0x69,0x20,0x44,0x49,0x59,0x0
	.DB  0x53,0x79,0x73,0x74,0x65,0x6D,0x20,0x72
	.DB  0x75,0x6E,0x6E,0x69,0x6E,0x67,0x0,0x53
	.DB  0x79,0x73,0x74,0x65,0x6D,0x20,0x73,0x74
	.DB  0x61,0x6E,0x62,0x79,0x0,0x53,0x79,0x73
	.DB  0x74,0x65,0x6D,0x20,0x73,0x74,0x6F,0x70
	.DB  0x65,0x64,0x20,0x21,0x0,0x72,0x65,0x63
	.DB  0x65,0x69,0x76,0x69,0x6E,0x67,0x0,0x53
	.DB  0x65,0x6E,0x64,0x69,0x6E,0x67,0x20,0x64
	.DB  0x61,0x74,0x61,0x2E,0x2E,0x0,0x2C,0x2C
	.DB  0x4A,0x54,0x46,0x5F,0x42,0x41,0x4C,0x45
	.DB  0x52,0x41,0x4E,0x54,0x45,0x2C,0x0,0x3E
	.DB  0x24,0x54,0x45,0x4C,0x2A,0x2C,0x0,0x54
	.DB  0x45,0x4C,0x45,0x2A,0x2C,0x0,0x53,0x4C
	.DB  0x45,0x45,0x50,0x2A,0x2C,0x0,0x57,0x41
	.DB  0x4B,0x45,0x2A,0x2C,0x0,0x41,0x4E,0x53
	.DB  0x2D,0x42,0x41,0x4C,0x45,0x52,0x41,0x4E
	.DB  0x54,0x45,0x2C,0x0,0x41,0x4E,0x53,0x2D
	.DB  0x52,0x55,0x4E,0x4E,0x49,0x4E,0x47,0x2C
	.DB  0x0,0x41,0x4E,0x53,0x2D,0x31,0x0,0x41
	.DB  0x4E,0x53,0x2D,0x32,0x0,0x41,0x4E,0x53
	.DB  0x2D,0x33,0x0,0x6B,0x69,0x72,0x69,0x6D
	.DB  0x20,0x64,0x61,0x74,0x61,0x20,0x73,0x65
	.DB  0x6B,0x61,0x72,0x61,0x6E,0x67,0x0,0x41
	.DB  0x4E,0x53,0x2D,0x53,0x54,0x41,0x4E,0x42
	.DB  0x59,0x2C,0x0,0x4E,0x41,0x4E,0x53,0x2C
	.DB  0x0,0x53,0x45,0x4C,0x45,0x53,0x41,0x49
	.DB  0x0
_0x2000003:
	.DB  0x80,0xC0

__GLOBAL_INI_TBL:
	.DW  0x18
	.DW  _0xE
	.DW  _0x0*2

	.DW  0x1F
	.DW  _0x18
	.DW  _0x0*2+24

	.DW  0x06
	.DW  _0x18+31
	.DW  _0x0*2+55

	.DW  0x06
	.DW  _0x18+37
	.DW  _0x0*2+61

	.DW  0x1F
	.DW  _0x18+43
	.DW  _0x0*2+67

	.DW  0x06
	.DW  _0x18+74
	.DW  _0x0*2+98

	.DW  0x02
	.DW  _0x18+80
	.DW  _0x0*2+22

	.DW  0x1F
	.DW  _0x23
	.DW  _0x0*2+24

	.DW  0x05
	.DW  _0x23+31
	.DW  _0x0*2+104

	.DW  0x07
	.DW  _0x23+36
	.DW  _0x0*2+109

	.DW  0x1F
	.DW  _0x23+43
	.DW  _0x0*2+67

	.DW  0x06
	.DW  _0x23+74
	.DW  _0x0*2+98

	.DW  0x11
	.DW  _0x46
	.DW  _0x0*2+254

	.DW  0x08
	.DW  _0x46+17
	.DW  _0x0*2+271

	.DW  0x07
	.DW  _0x46+25
	.DW  _0x0*2+279

	.DW  0x08
	.DW  _0x46+32
	.DW  _0x0*2+286

	.DW  0x07
	.DW  _0x46+40
	.DW  _0x0*2+294

	.DW  0x06
	.DW  _0x46+47
	.DW  _0x0*2+288

	.DW  0x0F
	.DW  _0x46+53
	.DW  _0x0*2+301

	.DW  0x0D
	.DW  _0x46+68
	.DW  _0x0*2+316

	.DW  0x06
	.DW  _0x46+81
	.DW  _0x0*2+329

	.DW  0x02
	.DW  _0x46+87
	.DW  _0x0*2+53

	.DW  0x06
	.DW  _0x46+89
	.DW  _0x0*2+335

	.DW  0x02
	.DW  _0x46+95
	.DW  _0x0*2+53

	.DW  0x06
	.DW  _0x46+97
	.DW  _0x0*2+341

	.DW  0x02
	.DW  _0x46+103
	.DW  _0x0*2+53

	.DW  0x0C
	.DW  _0x46+105
	.DW  _0x0*2+367

	.DW  0x06
	.DW  _0x46+117
	.DW  _0x0*2+379

	.DW  0x02
	.DW  _0x46+123
	.DW  _0x0*2+22

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
;#define STATION_STRING	",JTF_BALERANTE,"
;#define FLAG	"~"
;
;#define _MAX_RAM_VAR 150
;
;#define ADC_VREF_TYPE 0x40
;
;/*
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
;*/
;
;unsigned char read_adc(unsigned char adc_input);
;void switch_to_modem(void);
;void switch_clear(void);
;void banner_pembuka(void);
;void banner_sys(void);
;void banner_sys_freeze(void);
;void kirim_data_komplit(void);
;void kirim_data_sekarang(void);
;void usart_no_rx(void);
;void usart_init(void);
;
;eeprom char data_petir[_EEP_SIZE];
;eeprom char no_menu,last_menu;
;char lcd_buff[33];
;char data_perintah[_MAX_RAM_VAR];
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
;eeprom char sys_mode = 1;
;eeprom char chn_omega1 = 1;
;eeprom char chn_omega2 = 2;
;eeprom char chn_omega3 = 3;
;eeprom char chn_petir = 4;
;eeprom int xcount = 0;
;
;void itostring(unsigned char in)
; 0000 0091 {

	.CSEG
_itostring:
; 0000 0092 	char a,b,c;
; 0000 0093 
; 0000 0094         a=in/100;
	CALL __SAVELOCR4
;	in -> Y+4
;	a -> R17
;	b -> R16
;	c -> R19
	LDD  R26,Y+4
	LDI  R27,0
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21
	MOV  R17,R30
; 0000 0095         b=(in%100)/10;
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
; 0000 0096         c=in%10;
	LDD  R26,Y+4
	CLR  R27
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL __MODW21
	MOV  R19,R30
; 0000 0097 
; 0000 0098         a+=48;
	SUBI R17,-LOW(48)
; 0000 0099         b+=48;
	SUBI R16,-LOW(48)
; 0000 009A         c+=48;
	SUBI R19,-LOW(48)
; 0000 009B 
; 0000 009C         putchar(a);
	ST   -Y,R17
	CALL _putchar
; 0000 009D         putchar(b);
	ST   -Y,R16
	CALL _putchar
; 0000 009E         putchar(c);
	ST   -Y,R19
	CALL _putchar
; 0000 009F }
	CALL __LOADLOCR4
	ADIW R28,5
	RET
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00A2 {
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
; 0000 00A3         char c;
; 0000 00A4         if(sys_mode)
	ST   -Y,R17
;	c -> R17
	CALL SUBOPT_0x0
	BRNE PC+3
	JMP _0x3
; 0000 00A5         {
; 0000 00A6         	if(xcount==_EEP_SIZE)
	CALL SUBOPT_0x1
	CPI  R30,LOW(0x3E8)
	LDI  R26,HIGH(0x3E8)
	CPC  R31,R26
	BRNE _0x4
; 0000 00A7         	{
; 0000 00A8         		xcount = 0;
	CALL SUBOPT_0x2
; 0000 00A9                         #asm("cli")
	cli
; 0000 00AA                         for(c=0;c<3;c++)
	LDI  R17,LOW(0)
_0x6:
	CPI  R17,3
	BRSH _0x7
; 0000 00AB                         {
; 0000 00AC                         	kirim_data_komplit();
	RCALL _kirim_data_komplit
; 0000 00AD                         }
	SUBI R17,-1
	RJMP _0x6
_0x7:
; 0000 00AE                         #asm("sei")
	sei
; 0000 00AF                         goto jump;
	RJMP _0x8
; 0000 00B0         	}
; 0000 00B1 
; 0000 00B2                 data_petir[xcount]=read_adc(chn_petir);
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
; 0000 00B3         	xcount++;
	CALL SUBOPT_0x1
	ADIW R30,1
	CALL __EEPROMWRW
	SBIW R30,1
; 0000 00B4 
; 0000 00B5                 if((xcount%120)==0)
	CALL SUBOPT_0x1
	MOVW R26,R30
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL __MODW21
	SBIW R30,0
	BRNE _0x9
; 0000 00B6                 {
; 0000 00B7                 	PTT = 1;
	SBI  0x1B,0
; 0000 00B8                         PORTD.1 = 1;
	SBI  0x12,1
; 0000 00B9                         delay_ms(600);
	LDI  R30,LOW(600)
	LDI  R31,HIGH(600)
	CALL SUBOPT_0x4
; 0000 00BA                         putchar(13);
	CALL SUBOPT_0x5
; 0000 00BB                         puts(",,JTF_BALERANTE,>$TEL,"FLAG);
	__POINTW1MN _0xE,0
	CALL SUBOPT_0x6
; 0000 00BC                         putchar(13);
	CALL SUBOPT_0x5
; 0000 00BD                         delay_ms(100);
	CALL SUBOPT_0x7
; 0000 00BE                         PTT = 0;
	CBI  0x1B,0
; 0000 00BF                 }
; 0000 00C0         }
_0x9:
; 0000 00C1 
; 0000 00C2         jump:
_0x3:
_0x8:
; 0000 00C3 
; 0000 00C4         TCNT1H=0xEB;
	LDI  R30,LOW(235)
	OUT  0x2D,R30
; 0000 00C5 	TCNT1L=0xB0;
	LDI  R30,LOW(176)
	OUT  0x2C,R30
; 0000 00C6 }
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

	.DSEG
_0xE:
	.BYTE 0x18
;
;void kirim_data_komplit(void)
; 0000 00C9 {

	.CSEG
_kirim_data_komplit:
; 0000 00CA 	int i,j,k=0;
; 0000 00CB 
; 0000 00CC         delay_ms(5000);
	CALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
	__GETWRN 20,21,0
	CALL SUBOPT_0x8
; 0000 00CD         PTT = 1;
	CALL SUBOPT_0x9
; 0000 00CE         PORTD.1 = 1;
; 0000 00CF         delay_ms(1000);
; 0000 00D0         for(i=0;i<40;i++)
	__GETWRN 16,17,0
_0x16:
	__CPWRN 16,17,40
	BRGE _0x17
; 0000 00D1         {
; 0000 00D2         	putchar(0x0D);
	CALL SUBOPT_0x5
; 0000 00D3                 puts(","STATION_STRING">$TEL*,PETIR*,");
	__POINTW1MN _0x18,0
	CALL SUBOPT_0x6
; 0000 00D4                 for(j=0;j<25;j++)
	__GETWRN 18,19,0
_0x1A:
	__CPWRN 18,19,25
	BRGE _0x1B
; 0000 00D5                 {
; 0000 00D6                 	if(k==(_EEP_SIZE)) goto stop;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	CP   R30,R20
	CPC  R31,R21
	BREQ _0x1D
; 0000 00D7                         itostring(data_petir[k]);
	LDI  R26,LOW(_data_petir)
	LDI  R27,HIGH(_data_petir)
	ADD  R26,R20
	ADC  R27,R21
	CALL SUBOPT_0xA
; 0000 00D8                         putchar(',');
; 0000 00D9                         k++;
	__ADDWRN 20,21,1
; 0000 00DA                 }
	__ADDWRN 18,19,1
	RJMP _0x1A
_0x1B:
; 0000 00DB                 puts("*25*,");
	__POINTW1MN _0x18,31
	CALL SUBOPT_0x6
; 0000 00DC         }
	__ADDWRN 16,17,1
	RJMP _0x16
_0x17:
; 0000 00DD 
; 0000 00DE         stop:
_0x1D:
; 0000 00DF 
; 0000 00E0         puts("END*,");
	__POINTW1MN _0x18,37
	CALL SUBOPT_0x6
; 0000 00E1         putchar(0x0D);
	CALL SUBOPT_0x5
; 0000 00E2 
; 0000 00E3         puts(","STATION_STRING">$TEL*,OMEGA*,");
	__POINTW1MN _0x18,43
	CALL SUBOPT_0x6
; 0000 00E4         itostring(read_adc(chn_omega1));
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 00E5         putchar(',');
; 0000 00E6         itostring(read_adc(chn_omega2));
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
; 0000 00E7         putchar(',');
; 0000 00E8         itostring(read_adc(chn_omega3));
	CALL SUBOPT_0xE
	ST   -Y,R30
	RCALL _itostring
; 0000 00E9         puts(",*3*,");
	__POINTW1MN _0x18,74
	CALL SUBOPT_0x6
; 0000 00EA         puts(FLAG);
	__POINTW1MN _0x18,80
	CALL SUBOPT_0x6
; 0000 00EB         putchar(0x0D);
	CALL SUBOPT_0x5
; 0000 00EC         PTT = 0;
	CBI  0x1B,0
; 0000 00ED }
	CALL __LOADLOCR6
	ADIW R28,6
	RET

	.DSEG
_0x18:
	.BYTE 0x52
;
;void kirim_data_sekarang(void)
; 0000 00F0 {

	.CSEG
_kirim_data_sekarang:
; 0000 00F1 	char i,j;
; 0000 00F2         int k=0;
; 0000 00F3 
; 0000 00F4         for(i=0;i<40;i++)
	CALL __SAVELOCR4
;	i -> R17
;	j -> R16
;	k -> R18,R19
	__GETWRN 18,19,0
	LDI  R17,LOW(0)
_0x21:
	CPI  R17,40
	BRSH _0x22
; 0000 00F5         {
; 0000 00F6         	putchar(0x0D);
	CALL SUBOPT_0x5
; 0000 00F7                 puts(","STATION_STRING">$TEL*,PETIR*,");
	__POINTW1MN _0x23,0
	CALL SUBOPT_0x6
; 0000 00F8                 for(j=0;j<25;j++)
	LDI  R16,LOW(0)
_0x25:
	CPI  R16,25
	BRSH _0x26
; 0000 00F9                 {
; 0000 00FA                 	if(k==xcount) goto selesai;
	CALL SUBOPT_0x1
	CP   R30,R18
	CPC  R31,R19
	BREQ _0x28
; 0000 00FB                         itostring(data_petir[k]);
	LDI  R26,LOW(_data_petir)
	LDI  R27,HIGH(_data_petir)
	ADD  R26,R18
	ADC  R27,R19
	CALL SUBOPT_0xA
; 0000 00FC                         putchar(',');
; 0000 00FD                         k++;
	__ADDWRN 18,19,1
; 0000 00FE                 }
	SUBI R16,-1
	RJMP _0x25
_0x26:
; 0000 00FF                 puts("*25*");
	__POINTW1MN _0x23,31
	CALL SUBOPT_0x6
; 0000 0100         }
	SUBI R17,-1
	RJMP _0x21
_0x22:
; 0000 0101 
; 0000 0102        	selesai:
_0x28:
; 0000 0103 
; 0000 0104         puts("*END*,");
	__POINTW1MN _0x23,36
	CALL SUBOPT_0x6
; 0000 0105         putchar(0x0D);
	CALL SUBOPT_0x5
; 0000 0106 
; 0000 0107         puts(","STATION_STRING">$TEL*,OMEGA*,");
	__POINTW1MN _0x23,43
	CALL SUBOPT_0x6
; 0000 0108         itostring(read_adc(chn_omega1));
	CALL SUBOPT_0xB
	CALL SUBOPT_0xC
; 0000 0109         putchar(',');
; 0000 010A         itostring(read_adc(chn_omega2));
	CALL SUBOPT_0xD
	CALL SUBOPT_0xC
; 0000 010B         putchar(',');
; 0000 010C         itostring(read_adc(chn_omega3));
	CALL SUBOPT_0xE
	ST   -Y,R30
	RCALL _itostring
; 0000 010D         puts(",*3*,");
	__POINTW1MN _0x23,74
	CALL SUBOPT_0x6
; 0000 010E }
	CALL __LOADLOCR4
	ADIW R28,4
	RET

	.DSEG
_0x23:
	.BYTE 0x50
;
;void adc_init(void)
; 0000 0111 {

	.CSEG
_adc_init:
; 0000 0112    	ADMUX = ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(64)
	OUT  0x7,R30
; 0000 0113 	ADCSRA = 0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
; 0000 0114 }
	RET
;
;unsigned char read_adc(unsigned char adc_input)
; 0000 0117 {
_read_adc:
; 0000 0118 	ADMUX = adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x40
	OUT  0x7,R30
; 0000 0119 	delay_us(10);
	__DELAY_USB 37
; 0000 011A 	ADCSRA |= 0x40;
	SBI  0x6,6
; 0000 011B 	while ((ADCSRA & 0x10) == 0);
_0x29:
	SBIS 0x6,4
	RJMP _0x29
; 0000 011C 	ADCSRA |= 0x10;
	SBI  0x6,4
; 0000 011D         if(ADCW>255) {ADCW=255;}
	IN   R30,0x4
	IN   R31,0x4+1
	CPI  R30,LOW(0x100)
	LDI  R26,HIGH(0x100)
	CPC  R31,R26
	BRLO _0x2C
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	OUT  0x4+1,R31
	OUT  0x4,R30
; 0000 011E 	return ADCW;
_0x2C:
	IN   R30,0x4
	IN   R31,0x4+1
	JMP  _0x2080002
; 0000 011F }
;
;void usart_init(void)
; 0000 0122 {
_usart_init:
; 0000 0123 	UCSRA = 0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0124 	UCSRB = 0xD8;
	LDI  R30,LOW(216)
	RJMP _0x2080004
; 0000 0125 	UCSRC = 0x86;
; 0000 0126 	UBRRH = 0x02;
; 0000 0127 	UBRRL = 0x3F;
; 0000 0128 }
;
;void switch_to_modem(void)
; 0000 012B {
_switch_to_modem:
; 0000 012C 	PORTC.0 = 1; PORTC.1 = 0;
	SBI  0x15,0
	CBI  0x15,1
; 0000 012D }
	RET
;
;void switch_clear(void)
; 0000 0130 {
; 0000 0131   	SEL_B = 1; SEL_A = 1;
; 0000 0132 }
;
;void banner_pembuka(void)
; 0000 0135 {
_banner_pembuka:
; 0000 0136  	lcd_clear();
	CALL SUBOPT_0xF
; 0000 0137         lcd_gotoxy(0,0);
; 0000 0138         	 //0123456789abcdef
; 0000 0139         lcd_putsf("----JTF.UGM-----");
	__POINTW1FN _0x0,116
	CALL SUBOPT_0x10
; 0000 013A        	delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 013B         lcd_clear();
	CALL SUBOPT_0xF
; 0000 013C         lcd_gotoxy(0,0);
; 0000 013D         	 //0123456789abcdef
; 0000 013E         lcd_putsf(" Sistem");
	__POINTW1FN _0x0,133
	CALL SUBOPT_0x10
; 0000 013F         lcd_gotoxy(0,1);
	CALL SUBOPT_0x12
; 0000 0140         lcd_putsf(" Monitoring");
	__POINTW1FN _0x0,141
	CALL SUBOPT_0x10
; 0000 0141         delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 0142         lcd_clear();
	CALL SUBOPT_0xF
; 0000 0143         lcd_gotoxy(0,0);
; 0000 0144         	 //0123456789abcdef
; 0000 0145         lcd_putsf(" Ds. Balerante");
	__POINTW1FN _0x0,153
	CALL SUBOPT_0x10
; 0000 0146         lcd_gotoxy(0,1);
	CALL SUBOPT_0x12
; 0000 0147         lcd_putsf(" Gn. Merapi DIY");
	__POINTW1FN _0x0,168
	CALL SUBOPT_0x10
; 0000 0148         delay_ms(1000);
	CALL SUBOPT_0x11
; 0000 0149         lcd_clear();
	CALL _lcd_clear
; 0000 014A }
	RET
;
;void banner_sys(void)
; 0000 014D {
_banner_sys:
; 0000 014E  	lcd_clear();
	CALL SUBOPT_0xF
; 0000 014F         lcd_gotoxy(0,0);
; 0000 0150         if(sys_mode)	lcd_putsf("System running");
	CALL SUBOPT_0x0
	BREQ _0x35
	__POINTW1FN _0x0,184
	RJMP _0xA8
; 0000 0151         else		lcd_putsf("System stanby");
_0x35:
	__POINTW1FN _0x0,199
_0xA8:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
; 0000 0152 }
	RET
;
;void banner_sys_freeze(void)
; 0000 0155 {
; 0000 0156  	lcd_clear();
; 0000 0157         lcd_gotoxy(0,0);
; 0000 0158         lcd_putsf("System stoped !");
; 0000 0159 }
;
;/*
;void goto_menu(void)
;{
;	switch_clear();
;        usart_no_rx();
;        for(;;)
;        {
;		#asm("cli")
;                if(no_menu==0)	banner_sys_freeze();
;
;                else if(no_menu==1)	menu1();
;                else if(no_menu==2)	menu2();
;                else if(no_menu==3)	menu3();
;                else if(no_menu==4)	menu4();
;                else if(no_menu==5)	menu5();
;                else if(no_menu==6)	menu6();
;                else if(no_menu==7)	menu7();
;                else if(no_menu==8)	menu8();
;                else if(no_menu==9)	menu9();
;                else if(no_menu==10)	menu10();
;                else if(no_menu==11)	menu11();
;                else if(no_menu==12)	menu12();
;                else if(no_menu==13)	menu13();
;                else if(no_menu==14)	menu14();
;                else if(no_menu==15)	menu15();
;                else if(no_menu==16)	menu16();
;                else if(no_menu==17)	menu17();
;                else if(no_menu==18)	menu18();
;                else if(no_menu==19)	menu19();
;                else if(no_menu==20)	menu20();
;                else if(no_menu==21)	menu21();
;                else if(no_menu==22)	menu22();
;                else if(no_menu==23)	menu23();
;                else if(no_menu==24)	menu24();
;                else if(no_menu==25)	menu25();
;                else if(no_menu==26)	menu26();
;                else if(no_menu==27)	menu27();
;                else if(no_menu==28)	menu28();
;                else if(no_menu==29)	menu29();
;                else if(no_menu==30)	menu30();
;                else if(no_menu==31)	menu31();
;                else if(no_menu==32)	menu32();
;                else if(no_menu==33)	menu33();
;                else if(no_menu==34)	menu34();
;                else if(no_menu==35)	menu35();
;                else if(no_menu==36)	menu36();
;                else if(no_menu==37)	menu37();
;                else if(no_menu==38)	menu38();
;                else if(no_menu==39)	menu39();
;                else if(no_menu==40)	menu40();
;
;                else if(no_menu==100)	goto esc;
;
;                #asm("sei")
;        }
;        esc:
;        sys_mode = 1;
;        lcd_clear();
;        delay_ms(500);
;        banner_sys();
;        usart_init();
;        puts(FLAG);
;}
;
;void pattern_menu_a(char *str1,char *str2,char up,char down,char ent)
;{
;	last_menu = no_menu;
;	lcd_clear();
;        lcd_gotoxy(0,0);
;        lcd_puts(str1);
;	lcd_gotoxy(0,1);
;        lcd_puts(str2);
;        delay_ms(500);
;        while((TOM_UP)&&(TOM_DOWN)&&(TOM_ENTER)&&(TOM_CANCEL));
;        if(TOM_UP==0)
;        {
;        	delay_ms(200);
;        	no_menu = up;
;        }
;        if(TOM_DOWN==0)
;        {
;        	delay_ms(200);
;        	no_menu = down;
;        }
;        if(TOM_ENTER==0)
;        {
;        	delay_ms(200);
;        	no_menu = ent;
;        }
;        if(TOM_CANCEL==0)
;        {
;        	delay_ms(200);
;        	no_menu = last_menu;
;        }
;}
;
;void pattern_menu_b(char *str1,char *str2,char up,char down,char ent,char can)
;{
;	last_menu = no_menu;
;	lcd_clear();
;        lcd_gotoxy(0,0);
;        lcd_puts(str1);
;	lcd_gotoxy(0,1);
;        lcd_puts(str2);
;        delay_ms(500);
;        while((TOM_UP)&&(TOM_DOWN)&&(TOM_ENTER)&&(TOM_CANCEL));
;        if(!TOM_UP)
;        {
;        	delay_ms(200);
;        	no_menu = up;
;        }
;        if(!TOM_DOWN)
;        {
;        	delay_ms(200);
;        	no_menu = down;
;        }
;        if(!TOM_ENTER)
;        {
;        	delay_ms(200);
;        	no_menu = ent;
;        }
;        if(!TOM_CANCEL)
;        {
;        	delay_ms(200);
;                no_menu = can;
;        }
;}
;
;void menu1(void) //fixed
;{
;	pattern_menu_b(	"1.Jalankan ",
;        		" Sistem ",
;                        2,16,100,0);
;}
;
;void menu2(void)
;{                      //0123456789abcdef
;	pattern_menu_b(	"2.Setting tres-",
;        		" hold sensor",
;                        3,1,0,last_menu);
;}
;
;void menu3(void)
;{                      //0123456789abcdef
;	pattern_menu_b(	"3.Setting jum-",
;        		" lah sensor",
;                        4,2,0,last_menu);
;}
;
;void menu4(void)
;{                      //0123456789abcdef
;	pattern_menu_b(	"4.Lihat data",
;        		" sensor",
;                        5,3,0,last_menu);
;}
;
;void menu5(void)
;{                      //0123456789abcdef
;	pattern_menu_b(	"5.Aktifkan ",
;        		" sensor",
;                        6,4,0,last_menu);
;}
;
;void menu6(void)
;{                      //0123456789abcdef
;	pattern_menu_b(	"6.Matikan",
;        		" sensor",
;                        7,5,0,last_menu);
;}
;
;void menu7(void)
;{                      //0123456789abcdef
;	pattern_menu_b(	"7.Tes pancar",
;        		" data",
;                        8,6,0,last_menu);
;}
;
;void menu8(void)
;{                      //0123456789abcdef
;	pattern_menu_b(	"8.Tes terima",
;        		" data",
;                        9,7,0,last_menu);
;}
;
;void menu9(void)
;{
;	pattern_menu_b(	"9.Sleep mode",
;        		" ",
;                        10,8,0,last_menu);
;}
;
;void menu10(void)
;{
;	pattern_menu_b(	"10.Wake-up",
;        		" ",
;                        11,9,0,last_menu);
;}
;
;void menu11(void)
;{
;	pattern_menu_b(	"11.",
;        		"",
;                        12,10,11,last_menu);
;}
;
;void menu12(void)
;{
;	pattern_menu_b(	"12.",
;        		"",
;                        13,11,12,last_menu);
;}
;
;void menu13(void)
;{
;	pattern_menu_b(	"13.",
;        		"",
;                        14,12,0,last_menu);
;}
;
;void menu14(void)
;{
;	pattern_menu_b(	"14.",
;        		"",
;                        15,13,14,last_menu);
;}
;
;void menu15(void)
;{
;	pattern_menu_b(	"15.",
;        		"",
;                        16,14,10,last_menu);
;}
;
;void menu16(void)
;{
;	pattern_menu_b(	"16.",
;        		"",
;                        1,15,10,last_menu);
;}
;
;void menu17(void)
;{
;
;}
;
;void menu18(void)
;{
;
;}
;
;void menu19(void)
;{
;
;}
;
;void menu20(void)
;{
;
;}
;
;void menu21(void)
;{
;
;}
;
;void menu22(void)
;{
;
;}
;void menu23(void)
;{
;
;}
;
;void menu24(void)
;{
;
;}
;
;void menu25(void)
;{
;
;}
;
;void menu26(void)
;{
;
;}
;
;void menu27(void)
;{
;
;}
;
;void menu28(void)
;{
;
;}
;
;void menu29(void)
;{
;
;}
;
;void menu30(void)
;{
;
;}
;
;void menu31(void)
;{
;
;}
;
;void menu32(void)
;{
;
;}
;
;void menu33(void)
;{
;
;}
;
;void menu34(void)
;{
;
;}
;
;void menu35(void)
;{
;
;}
;
;void menu36(void)
;{
;
;}
;
;void menu37(void)
;{
;
;}
;
;void menu38(void)
;{
;
;}
;
;void menu39(void)
;{
;
;}
;
;void menu40(void)
;{
;
;}
;
;*/
;void tx_data(char *str2)
; 0000 02C4 {
_tx_data:
; 0000 02C5 	PORTD.1 = 1;
;	*str2 -> Y+0
	SBI  0x12,1
; 0000 02C6         puts(str2);
	LD   R30,Y
	LDD  R31,Y+1
	CALL SUBOPT_0x6
; 0000 02C7 }
	JMP  _0x2080003
;
;void usart_no_rx(void)
; 0000 02CA {
_usart_no_rx:
; 0000 02CB 	// USART initialization
; 0000 02CC 	// Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 02CD 	// USART Receiver: Off
; 0000 02CE 	// USART Transmitter: On
; 0000 02CF 	// USART Mode: Asynchronous
; 0000 02D0 	// USART Baud Rate: 1200
; 0000 02D1 	UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 02D2 	UCSRB=0x08;
	LDI  R30,LOW(8)
_0x2080004:
	OUT  0xA,R30
; 0000 02D3 	UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 02D4 	UBRRH=0x02;
	LDI  R30,LOW(2)
	OUT  0x20,R30
; 0000 02D5 	UBRRL=0x3F;
	LDI  R30,LOW(63)
	OUT  0x9,R30
; 0000 02D6 }
	RET
;
;void baca_perintah(void)
; 0000 02D9 {
_baca_perintah:
; 0000 02DA 	char i;
; 0000 02DB         if(!CARIER_DET)
	ST   -Y,R17
;	i -> R17
	SBIC 0x10,0
	RJMP _0x39
; 0000 02DC         {
; 0000 02DD         	#asm("cli")
	cli
; 0000 02DE                 for(i=0;;i++)
	LDI  R17,LOW(0)
_0x3B:
; 0000 02DF         	{
; 0000 02E0         		if(i==_MAX_RAM_VAR-2) goto esc;
	CPI  R17,148
	BRNE _0x3D
	RJMP _0x3E
; 0000 02E1                         data_perintah[i]=getchar();
_0x3D:
	CALL SUBOPT_0x13
	PUSH R31
	PUSH R30
	CALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
; 0000 02E2                 	if(data_perintah[i]==0x7E) goto exec;
	CALL SUBOPT_0x13
	LD   R26,Z
	CPI  R26,LOW(0x7E)
	BREQ _0x40
; 0000 02E3                 	if(i==1)
	CPI  R17,1
	BRNE _0x41
; 0000 02E4                         {
; 0000 02E5                         	lcd_clear();
	CALL _lcd_clear
; 0000 02E6                                 lcd_putsf("receiving");
	__POINTW1FN _0x0,229
	CALL SUBOPT_0x10
; 0000 02E7                         }
; 0000 02E8         	}
_0x41:
	SUBI R17,-1
	RJMP _0x3B
; 0000 02E9         	exec:
_0x40:
; 0000 02EA                 usart_no_rx();
	RCALL _usart_no_rx
; 0000 02EB                 lcd_clear();
	CALL _lcd_clear
; 0000 02EC                 lcd_putsf("Sending data..");
	__POINTW1FN _0x0,239
	CALL SUBOPT_0x10
; 0000 02ED                 PTT = 1;
	CALL SUBOPT_0x9
; 0000 02EE                 PORTD.1 = 1;
; 0000 02EF                 delay_ms(1000);
; 0000 02F0                 putchar(13);
	CALL SUBOPT_0x5
; 0000 02F1                 tx_data(","STATION_STRING);
	__POINTW1MN _0x46,0
	CALL SUBOPT_0x14
; 0000 02F2                 for(i=0;;i++)
	LDI  R17,LOW(0)
_0x48:
; 0000 02F3                 {
; 0000 02F4 
; 0000 02F5                 	if(data_perintah[i]=='$')
	CALL SUBOPT_0x13
	LD   R26,Z
	CPI  R26,LOW(0x24)
	BRNE _0x4A
; 0000 02F6                         {
; 0000 02F7                         	if((data_perintah[i+1]=='T')&&
; 0000 02F8                                 (data_perintah[i+2]=='E')&&
; 0000 02F9                                 (data_perintah[i+3]=='L'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	BRNE _0x4C
	CALL SUBOPT_0x17
	BRNE _0x4C
	MOVW R30,R22
	__ADDW1MN _data_perintah,3
	LD   R26,Z
	CPI  R26,LOW(0x4C)
	BREQ _0x4D
_0x4C:
	RJMP _0x4B
_0x4D:
; 0000 02FA                                 {
; 0000 02FB                         		tx_data(">$TEL*,");
	__POINTW1MN _0x46,17
	CALL SUBOPT_0x14
; 0000 02FC                                         i+=3;
	SUBI R17,-LOW(3)
; 0000 02FD                                 }
; 0000 02FE 
; 0000 02FF                                 else if(data_perintah[i+1]=='$')
	RJMP _0x4E
_0x4B:
	CALL SUBOPT_0x15
	__ADDW1MN _data_perintah,1
	LD   R26,Z
	CPI  R26,LOW(0x24)
	BRNE _0x4F
; 0000 0300                                 {
; 0000 0301                                 	lcd_clear();
	CALL _lcd_clear
; 0000 0302                                 }
; 0000 0303 
; 0000 0304                                 else if((data_perintah[i+1]!='T')||
	RJMP _0x50
_0x4F:
; 0000 0305                                 (data_perintah[i+2]!='E')||
; 0000 0306                                 (data_perintah[i+3]!='L'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x16
	BRNE _0x52
	CALL SUBOPT_0x17
	BRNE _0x52
	CALL SUBOPT_0x18
	CPI  R26,LOW(0x4C)
	BREQ _0x51
_0x52:
; 0000 0307                                 {
; 0000 0308                                         goto esc;
	RJMP _0x3E
; 0000 0309                                 }
; 0000 030A                         }
_0x51:
_0x50:
_0x4E:
; 0000 030B 
; 0000 030C                         else if(data_perintah[i]==',')
	RJMP _0x54
_0x4A:
	CALL SUBOPT_0x13
	LD   R26,Z
	CPI  R26,LOW(0x2C)
	BREQ PC+3
	JMP _0x55
; 0000 030D                         {
; 0000 030E                         	if(data_perintah[i+1]==',')
	CALL SUBOPT_0x15
	__ADDW1MN _data_perintah,1
	LD   R26,Z
	CPI  R26,LOW(0x2C)
	BRNE _0x56
; 0000 030F                                 {
; 0000 0310                                 	lcd_clear();
	CALL _lcd_clear
; 0000 0311                                 }
; 0000 0312 
; 0000 0313                                 else if((data_perintah[i+1]=='S')&&
	RJMP _0x57
_0x56:
; 0000 0314                                 (data_perintah[i+2]=='A')&&
; 0000 0315                                 (data_perintah[i+3]=='D'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x19
	BRNE _0x59
	CALL SUBOPT_0x1A
	CPI  R26,LOW(0x41)
	BRNE _0x59
	CALL SUBOPT_0x18
	CPI  R26,LOW(0x44)
	BREQ _0x5A
_0x59:
	RJMP _0x58
_0x5A:
; 0000 0316                                 {
; 0000 0317                                 	if(data_perintah[i+5]=='T')
	CALL SUBOPT_0x15
	__ADDW1MN _data_perintah,5
	LD   R26,Z
	CPI  R26,LOW(0x54)
	BRNE _0x5B
; 0000 0318                                         {
; 0000 0319                                         	tx_data("TELE*,");
	__POINTW1MN _0x46,25
	CALL SUBOPT_0x14
; 0000 031A                                                 i+=5;
	SUBI R17,-LOW(5)
; 0000 031B                                         }
; 0000 031C                                 }
_0x5B:
; 0000 031D 
; 0000 031E                                 else if((data_perintah[i+1]=='S')&&
	RJMP _0x5C
_0x58:
; 0000 031F                                 (data_perintah[i+2]=='E')&&
; 0000 0320                                 (data_perintah[i+3]=='T'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x19
	BRNE _0x5E
	CALL SUBOPT_0x17
	BRNE _0x5E
	CALL SUBOPT_0x18
	CPI  R26,LOW(0x54)
	BREQ _0x5F
_0x5E:
	RJMP _0x5D
_0x5F:
; 0000 0321                                 {
; 0000 0322                                 	if((data_perintah[i+5]=='S')&&
; 0000 0323                                         (data_perintah[i+6]=='L')&&
; 0000 0324                                         (data_perintah[i+7]=='E')&&
; 0000 0325                                         (data_perintah[i+8]=='E')&&
; 0000 0326                                         (data_perintah[i+9]=='P'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x53)
	BRNE _0x61
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x4C)
	BRNE _0x61
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x45)
	BRNE _0x61
	MOVW R30,R22
	__ADDW1MN _data_perintah,8
	LD   R26,Z
	CPI  R26,LOW(0x45)
	BRNE _0x61
	MOVW R30,R22
	__ADDW1MN _data_perintah,9
	LD   R26,Z
	CPI  R26,LOW(0x50)
	BREQ _0x62
_0x61:
	RJMP _0x60
_0x62:
; 0000 0327                                         {
; 0000 0328                                         	tx_data("SLEEP*,");
	__POINTW1MN _0x46,32
	CALL SUBOPT_0x14
; 0000 0329                                                 sys_mode = S_SLEEP;
	LDI  R26,LOW(_sys_mode)
	LDI  R27,HIGH(_sys_mode)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 032A                                                 i+=9;
	SUBI R17,-LOW(9)
; 0000 032B                                         }
; 0000 032C 
; 0000 032D                                         else if((data_perintah[i+5]=='W')&&
	RJMP _0x63
_0x60:
; 0000 032E                                         (data_perintah[i+6]=='A')&&
; 0000 032F                                         (data_perintah[i+7]=='K')&&
; 0000 0330                                         (data_perintah[i+8]=='E'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x57)
	BRNE _0x65
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x41)
	BRNE _0x65
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x4B)
	BRNE _0x65
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x45)
	BREQ _0x66
_0x65:
	RJMP _0x64
_0x66:
; 0000 0331                                         {
; 0000 0332                                         	tx_data("WAKE*,");
	__POINTW1MN _0x46,40
	CALL SUBOPT_0x14
; 0000 0333                                                 sys_mode = S_WAKE;
	LDI  R26,LOW(_sys_mode)
	LDI  R27,HIGH(_sys_mode)
	LDI  R30,LOW(1)
	CALL __EEPROMWRB
; 0000 0334                                                 i+=8;
	SUBI R17,-LOW(8)
; 0000 0335                                         }
; 0000 0336                                 }
_0x64:
_0x63:
; 0000 0337 
; 0000 0338                                 else if((data_perintah[i+1]=='M')&&
	RJMP _0x67
_0x5D:
; 0000 0339                                 (data_perintah[i+2]=='E')&&
; 0000 033A                                 (data_perintah[i+3]=='M'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x4D)
	BRNE _0x69
	CALL SUBOPT_0x17
	BRNE _0x69
	CALL SUBOPT_0x18
	CPI  R26,LOW(0x4D)
	BREQ _0x6A
_0x69:
	RJMP _0x68
_0x6A:
; 0000 033B                                 {
; 0000 033C                                 	if((data_perintah[i+5]=='E')&&
; 0000 033D                                         (data_perintah[i+6]=='E')&&
; 0000 033E                                         (data_perintah[i+7]=='P'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x45)
	BRNE _0x6C
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x45)
	BRNE _0x6C
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x50)
	BREQ _0x6D
_0x6C:
	RJMP _0x6B
_0x6D:
; 0000 033F                                         {
; 0000 0340                                         	tx_data("EEP*,");
	__POINTW1MN _0x46,47
	CALL SUBOPT_0x14
; 0000 0341                                                 i+=7;
	SUBI R17,-LOW(7)
; 0000 0342                                         }
; 0000 0343                                 }
_0x6B:
; 0000 0344 
; 0000 0345                                 else if((data_perintah[i+1]=='A')&&
	RJMP _0x6E
_0x68:
; 0000 0346                                 (data_perintah[i+2]=='S')&&
; 0000 0347                                 (data_perintah[i+3]=='K')&&
; 0000 0348                                 (sys_mode))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x41)
	BRNE _0x70
	CALL SUBOPT_0x1A
	CPI  R26,LOW(0x53)
	BRNE _0x70
	CALL SUBOPT_0x18
	CPI  R26,LOW(0x4B)
	BRNE _0x70
	CALL SUBOPT_0x0
	BRNE _0x71
_0x70:
	RJMP _0x6F
_0x71:
; 0000 0349                                 {
; 0000 034A                                 	if((data_perintah[i+5]=='I')&&
; 0000 034B                                         (data_perintah[i+6]=='D'))
	CALL SUBOPT_0x15
	MOVW R0,R30
	__ADDW1MN _data_perintah,5
	LD   R26,Z
	CPI  R26,LOW(0x49)
	BRNE _0x73
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x44)
	BREQ _0x74
_0x73:
	RJMP _0x72
_0x74:
; 0000 034C                                         {
; 0000 034D                                         	tx_data("ANS-BALERANTE,");
	__POINTW1MN _0x46,53
	CALL SUBOPT_0x14
; 0000 034E                                                 i+=6;
	SUBI R17,-LOW(6)
; 0000 034F                                         }
; 0000 0350 
; 0000 0351                                         else if((data_perintah[i+5]=='S')&&
	RJMP _0x75
_0x72:
; 0000 0352                                         (data_perintah[i+6]=='T')&&
; 0000 0353                                         (data_perintah[i+7]=='A')&&
; 0000 0354                                         (data_perintah[i+8]=='T'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x53)
	BRNE _0x77
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x54)
	BRNE _0x77
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x41)
	BRNE _0x77
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x54)
	BREQ _0x78
_0x77:
	RJMP _0x76
_0x78:
; 0000 0355                                         {
; 0000 0356                                         	tx_data("ANS-RUNNING,");
	__POINTW1MN _0x46,68
	CALL SUBOPT_0x14
; 0000 0357                                                 i+=8;
	SUBI R17,-LOW(8)
; 0000 0358                                         }
; 0000 0359 
; 0000 035A                                         else if((data_perintah[i+5]=='O')&&
	RJMP _0x79
_0x76:
; 0000 035B                                         (data_perintah[i+6]=='M')&&
; 0000 035C                                         (data_perintah[i+7]=='E')&&
; 0000 035D                                         (data_perintah[i+8]=='G')&&
; 0000 035E                                         (data_perintah[i+9]=='A'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x4F)
	BRNE _0x7B
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x4D)
	BRNE _0x7B
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x45)
	BRNE _0x7B
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x47)
	BRNE _0x7B
	MOVW R30,R22
	__ADDW1MN _data_perintah,9
	LD   R26,Z
	CPI  R26,LOW(0x41)
	BREQ _0x7C
_0x7B:
	RJMP _0x7A
_0x7C:
; 0000 035F                                         {
; 0000 0360                                         	if(data_perintah[i+10]=='1')
	CALL SUBOPT_0x15
	__ADDW1MN _data_perintah,10
	LD   R26,Z
	CPI  R26,LOW(0x31)
	BRNE _0x7D
; 0000 0361                                                 {
; 0000 0362                                                 	tx_data("ANS-1");
	__POINTW1MN _0x46,81
	CALL SUBOPT_0x14
; 0000 0363         						itostring(read_adc(chn_omega1));
	CALL SUBOPT_0xB
	ST   -Y,R30
	RCALL _itostring
; 0000 0364                                                 	puts(",");
	__POINTW1MN _0x46,87
	RJMP _0xA9
; 0000 0365                                                 	i+=10;
; 0000 0366                                                 }
; 0000 0367 
; 0000 0368                                                 else if(data_perintah[i+10]=='2')
_0x7D:
	CALL SUBOPT_0x15
	__ADDW1MN _data_perintah,10
	LD   R26,Z
	CPI  R26,LOW(0x32)
	BRNE _0x7F
; 0000 0369                                                 {
; 0000 036A                                                 	tx_data("ANS-2");
	__POINTW1MN _0x46,89
	CALL SUBOPT_0x14
; 0000 036B         						itostring(read_adc(chn_omega2));
	CALL SUBOPT_0xD
	ST   -Y,R30
	RCALL _itostring
; 0000 036C                                                 	puts(",");
	__POINTW1MN _0x46,95
	RJMP _0xA9
; 0000 036D                                                 	i+=10;
; 0000 036E                                                 }
; 0000 036F 
; 0000 0370                                                 else if(data_perintah[i+10]=='3')
_0x7F:
	CALL SUBOPT_0x15
	__ADDW1MN _data_perintah,10
	LD   R26,Z
	CPI  R26,LOW(0x33)
	BRNE _0x81
; 0000 0371                                                 {
; 0000 0372                                                 	tx_data("ANS-3");
	__POINTW1MN _0x46,97
	CALL SUBOPT_0x14
; 0000 0373         						itostring(read_adc(chn_omega3));
	CALL SUBOPT_0xE
	ST   -Y,R30
	RCALL _itostring
; 0000 0374                                                 	puts(",");
	__POINTW1MN _0x46,103
_0xA9:
	ST   -Y,R31
	ST   -Y,R30
	CALL _puts
; 0000 0375                                                 	i+=10;
	SUBI R17,-LOW(10)
; 0000 0376                                                 }
; 0000 0377                                         }
_0x81:
; 0000 0378 
; 0000 0379                                 	else if((data_perintah[i+5]=='N')&&
	RJMP _0x82
_0x7A:
; 0000 037A                                         (data_perintah[i+6]=='O')&&
; 0000 037B                                         (data_perintah[i+7]=='W'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x4E)
	BRNE _0x84
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x4F)
	BRNE _0x84
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x57)
	BREQ _0x85
_0x84:
	RJMP _0x83
_0x85:
; 0000 037C                                         {
; 0000 037D                                         	lcd_gotoxy(0,1);
	CALL SUBOPT_0x12
; 0000 037E                                                 lcd_putsf("kirim data sekarang");
	__POINTW1FN _0x0,347
	CALL SUBOPT_0x10
; 0000 037F                                                 kirim_data_sekarang();
	CALL SUBOPT_0x20
; 0000 0380                                                 PTT = 0;
; 0000 0381 
; 0000 0382                                                 delay_ms(5000);
; 0000 0383 
; 0000 0384                                                 PTT = 1;
	CALL SUBOPT_0x21
; 0000 0385                                                 delay_ms(500);
; 0000 0386                                                 kirim_data_sekarang();
	CALL SUBOPT_0x20
; 0000 0387                                                 PTT = 0;
; 0000 0388 
; 0000 0389                                                 delay_ms(5000);
; 0000 038A 
; 0000 038B                                                 PTT = 1;
	CALL SUBOPT_0x21
; 0000 038C                                                 delay_ms(500);
; 0000 038D                                                 kirim_data_sekarang();
	CALL SUBOPT_0x20
; 0000 038E                                                 PTT = 0;
; 0000 038F 
; 0000 0390                                                 delay_ms(5000);
; 0000 0391 
; 0000 0392                                                 PTT = 1;
	CALL SUBOPT_0x21
; 0000 0393                                                 delay_ms(500);
; 0000 0394                                                 kirim_data_sekarang();
	RCALL _kirim_data_sekarang
; 0000 0395                                                 xcount=0;
	CALL SUBOPT_0x2
; 0000 0396                                                 i+=7;
	SUBI R17,-LOW(7)
; 0000 0397                                         }
; 0000 0398                                 }
_0x83:
_0x82:
_0x79:
_0x75:
; 0000 0399 
; 0000 039A                                 else if(((data_perintah[i+1]=='A')&&
	RJMP _0x92
_0x6F:
; 0000 039B                                 (data_perintah[i+2]=='S')&&
; 0000 039C                                 (data_perintah[i+3]=='K'))&&
; 0000 039D                                 (!sys_mode))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1F
	CPI  R26,LOW(0x41)
	BRNE _0x94
	CALL SUBOPT_0x1A
	CPI  R26,LOW(0x53)
	BRNE _0x94
	CALL SUBOPT_0x18
	CPI  R26,LOW(0x4B)
	BREQ _0x95
_0x94:
	RJMP _0x96
_0x95:
	CALL SUBOPT_0x0
	BREQ _0x97
_0x96:
	RJMP _0x93
_0x97:
; 0000 039E                                 {
; 0000 039F                                 	if((data_perintah[i+5]=='S')&&
; 0000 03A0                                         (data_perintah[i+6]=='T')&&
; 0000 03A1                                         (data_perintah[i+7]=='A')&&
; 0000 03A2                                         (data_perintah[i+8]=='T'))
	CALL SUBOPT_0x15
	CALL SUBOPT_0x1B
	CPI  R26,LOW(0x53)
	BRNE _0x99
	CALL SUBOPT_0x1C
	CPI  R26,LOW(0x54)
	BRNE _0x99
	CALL SUBOPT_0x1D
	CPI  R26,LOW(0x41)
	BRNE _0x99
	CALL SUBOPT_0x1E
	CPI  R26,LOW(0x54)
	BREQ _0x9A
_0x99:
	RJMP _0x98
_0x9A:
; 0000 03A3                                         {
; 0000 03A4                                         	tx_data("ANS-STANBY,");
	__POINTW1MN _0x46,105
	CALL SUBOPT_0x14
; 0000 03A5                                         	i+=8;
	SUBI R17,-LOW(8)
; 0000 03A6                                         	goto skip;
	RJMP _0x9B
; 0000 03A7                                         }
; 0000 03A8 
; 0000 03A9                                         else
_0x98:
; 0000 03AA                                         {
; 0000 03AB                                         	tx_data("NANS,");
	__POINTW1MN _0x46,117
	CALL SUBOPT_0x14
; 0000 03AC                                         	i+=3;
	SUBI R17,-LOW(3)
; 0000 03AD                                         	goto skip;
	RJMP _0x9B
; 0000 03AE                                         }
; 0000 03AF                                 }
; 0000 03B0                         }
_0x93:
_0x92:
_0x6E:
_0x67:
_0x5C:
_0x57:
; 0000 03B1 
; 0000 03B2                         else if(data_perintah[i]==0x7E)
	RJMP _0x9D
_0x55:
	CALL SUBOPT_0x13
	LD   R26,Z
	CPI  R26,LOW(0x7E)
	BREQ _0x3E
; 0000 03B3                         {
; 0000 03B4                         	goto esc;
; 0000 03B5                         }
; 0000 03B6 
; 0000 03B7                         skip:
_0x9D:
_0x54:
_0x9B:
; 0000 03B8                 }
	SUBI R17,-1
	RJMP _0x48
; 0000 03B9 
; 0000 03BA                 esc:
_0x3E:
; 0000 03BB 
; 0000 03BC                 lcd_clear();
	RCALL _lcd_clear
; 0000 03BD                 tx_data(FLAG);
	__POINTW1MN _0x46,123
	CALL SUBOPT_0x14
; 0000 03BE                 putchar(0x0D);
	CALL SUBOPT_0x5
; 0000 03BF                 delay_ms(100);
	CALL SUBOPT_0x7
; 0000 03C0                 PTT = 0;
	CBI  0x1B,0
; 0000 03C1                 lcd_putsf("SELESAI");
	__POINTW1FN _0x0,385
	CALL SUBOPT_0x10
; 0000 03C2                 delay_ms(100);
	CALL SUBOPT_0x7
; 0000 03C3                 lcd_clear();
	RCALL _lcd_clear
; 0000 03C4         	banner_sys();
	RCALL _banner_sys
; 0000 03C5                 usart_init();
	RCALL _usart_init
; 0000 03C6 
; 0000 03C7                 #asm("sei")
	sei
; 0000 03C8                 goto keluar;
; 0000 03C9 	}
; 0000 03CA         keluar:
_0x39:
; 0000 03CB }
	LD   R17,Y+
	RET

	.DSEG
_0x46:
	.BYTE 0x7D
;
;void main(void)
; 0000 03CE {

	.CSEG
_main:
; 0000 03CF 	PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
; 0000 03D0 	DDRA=0x81;
	LDI  R30,LOW(129)
	OUT  0x1A,R30
; 0000 03D1 	PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 03D2 	DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 03D3 	PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 03D4 	DDRC=0x0F;
	LDI  R30,LOW(15)
	OUT  0x14,R30
; 0000 03D5 	PORTD=0xF7;
	LDI  R30,LOW(247)
	OUT  0x12,R30
; 0000 03D6 	DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 03D7 
; 0000 03D8         TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 03D9 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 03DA 	TCNT1H=0xEB;
	LDI  R30,LOW(235)
	OUT  0x2D,R30
; 0000 03DB 	TCNT1L=0xB0;
	LDI  R30,LOW(176)
	OUT  0x2C,R30
; 0000 03DC 
; 0000 03DD 	TIMSK=0x04;
	LDI  R30,LOW(4)
	OUT  0x39,R30
; 0000 03DE 
; 0000 03DF         WDTCR=0x00;
	LDI  R30,LOW(0)
	OUT  0x21,R30
; 0000 03E0 
; 0000 03E1         PORTD.1 = 1;
	SBI  0x12,1
; 0000 03E2 
; 0000 03E3 	adc_init();
	RCALL _adc_init
; 0000 03E4 	lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	RCALL _lcd_init
; 0000 03E5         usart_init();
	RCALL _usart_init
; 0000 03E6         banner_pembuka();
	RCALL _banner_pembuka
; 0000 03E7         //no_menu = 1;
; 0000 03E8         //last_menu = no_menu;
; 0000 03E9         switch_to_modem();
	RCALL _switch_to_modem
; 0000 03EA         banner_sys();
	RCALL _banner_sys
; 0000 03EB         #asm("sei")
	sei
; 0000 03EC 
; 0000 03ED 	while (1)
_0xA4:
; 0000 03EE       	{
; 0000 03EF                 //if(!TOM_ENTER) {no_menu = last_menu; goto_menu();}
; 0000 03F0                 baca_perintah();
	RCALL _baca_perintah
; 0000 03F1       	}
	RJMP _0xA4
; 0000 03F2 }
_0xA7:
	RJMP _0xA7
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
_0x2080003:
	ADIW R28,2
	RET
_lcd_clear:
	LDI  R30,LOW(2)
	CALL SUBOPT_0x22
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL __lcd_write_data
	LDI  R30,LOW(1)
	CALL SUBOPT_0x22
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
	CALL SUBOPT_0x4
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
	CALL SUBOPT_0x23
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
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2020005
	ST   -Y,R17
	RCALL _putchar
	RJMP _0x2020003
_0x2020005:
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
_data_petir:
	.BYTE 0x3E8

	.DSEG
_data_perintah:
	.BYTE 0x96

	.ESEG
_sys_mode:
	.DB  0x1
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
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x0:
	LDI  R26,LOW(_sys_mode)
	LDI  R27,HIGH(_sys_mode)
	CALL __EEPROMRDB
	CPI  R30,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(13)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x6:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x9:
	SBI  0x1B,0
	SBI  0x12,1
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _itostring
	LDI  R30,LOW(44)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xB:
	LDI  R26,LOW(_chn_omega1)
	LDI  R27,HIGH(_chn_omega1)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0xC:
	ST   -Y,R30
	CALL _itostring
	LDI  R30,LOW(44)
	ST   -Y,R30
	JMP  _putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	LDI  R26,LOW(_chn_omega2)
	LDI  R27,HIGH(_chn_omega2)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xE:
	LDI  R26,LOW(_chn_omega3)
	LDI  R27,HIGH(_chn_omega3)
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0xF:
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x10:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x13:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_data_perintah)
	SBCI R31,HIGH(-_data_perintah)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:23 WORDS
SUBOPT_0x14:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _tx_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x15:
	MOV  R30,R17
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	MOVW R22,R30
	MOVW R0,R30
	__ADDW1MN _data_perintah,1
	LD   R26,Z
	CPI  R26,LOW(0x54)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x17:
	MOVW R30,R0
	__ADDW1MN _data_perintah,2
	LD   R26,Z
	CPI  R26,LOW(0x45)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x18:
	MOVW R30,R22
	__ADDW1MN _data_perintah,3
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x19:
	MOVW R22,R30
	MOVW R0,R30
	__ADDW1MN _data_perintah,1
	LD   R26,Z
	CPI  R26,LOW(0x53)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1A:
	MOVW R30,R0
	__ADDW1MN _data_perintah,2
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:15 WORDS
SUBOPT_0x1B:
	MOVW R22,R30
	MOVW R0,R30
	__ADDW1MN _data_perintah,5
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x1C:
	MOVW R30,R0
	__ADDW1MN _data_perintah,6
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1D:
	MOVW R30,R22
	__ADDW1MN _data_perintah,7
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1E:
	MOVW R30,R22
	__ADDW1MN _data_perintah,8
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1F:
	MOVW R22,R30
	MOVW R0,R30
	__ADDW1MN _data_perintah,1
	LD   R26,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x20:
	CALL _kirim_data_sekarang
	CBI  0x1B,0
	RJMP SUBOPT_0x8

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x21:
	SBI  0x1B,0
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x22:
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x23:
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
