
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega32
;Program type             : Application
;Clock frequency          : 11.059200 MHz
;Memory model             : Small
;Optimize for             : Speed
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
	.DEF _rx_wr_index=R5
	.DEF _rx_rd_index=R4
	.DEF _rx_counter=R7
	.DEF _tx_wr_index=R6
	.DEF _tx_rd_index=R9
	.DEF _tx_counter=R8
	.DEF _timer1_count=R11

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

_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000

_0x0:
	.DB  0x64,0x65,0x62,0x75,0x67,0x20,0x72,0x65
	.DB  0x61,0x64,0x79,0x20,0x0

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
;Date    : 9/14/2012
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
;/******************* ADC ***************************/
;
;#include <delay.h>
;
;#define ADC_VREF_TYPE 0x20
;#define ADC_BUSY_LED    PORTC.4
;#define I_ADC_BUSY_LED  PORTC.5
;
;// Read the 8 most significant bits
;// of the AD conversion result
;unsigned char read_adc(unsigned char adc_input)
; 0000 0025 {

	.CSEG
_read_adc:
; 0000 0026     ADC_BUSY_LED = 1;
;	adc_input -> Y+0
	SBI  0x15,4
; 0000 0027     I_ADC_BUSY_LED = 0;
	CBI  0x15,5
; 0000 0028 
; 0000 0029     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
; 0000 002A 
; 0000 002B     // Delay needed for the stabilization of the ADC input voltage
; 0000 002C     delay_us(10);
	__DELAY_USB 37
; 0000 002D 
; 0000 002E     // Start the AD conversion
; 0000 002F     ADCSRA|=0x40;
	SBI  0x6,6
; 0000 0030 
; 0000 0031     // Wait for the AD conversion to complete
; 0000 0032     while ((ADCSRA & 0x10)==0);
_0x7:
	SBIS 0x6,4
	RJMP _0x7
; 0000 0033     ADCSRA|=0x10;
	SBI  0x6,4
; 0000 0034 
; 0000 0035     ADC_BUSY_LED = 0;
	CBI  0x15,4
; 0000 0036 
; 0000 0037     return ADCH;
	IN   R30,0x5
	RJMP _0x2060001
; 0000 0038 }
;
;/******************* END OF ADC ********************/
;
;/********************** USART INTERRUPT*************************/
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART Receiver buffer
;#define RX_BUFFER_SIZE 8
;unsigned char rx_buffer[RX_BUFFER_SIZE];
;
;#if RX_BUFFER_SIZE <= 256
;    unsigned char rx_wr_index,rx_rd_index,rx_counter;
;#else
;    unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;// This flag is set on USART Receiver buffer overflow
;bit rx_buffer_overflow;
;
;// USART Receiver interrupt service routine
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 006F {
_usart_rx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 0070     unsigned char status,data;
; 0000 0071     status=UCSRA;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0072     data=UDR;
	IN   R16,12
; 0000 0073     if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0xC
; 0000 0074     {
; 0000 0075         rx_buffer[rx_wr_index++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
; 0000 0076         #if RX_BUFFER_SIZE == 256
; 0000 0077             // special case for receiver buffer size=256
; 0000 0078             if (++rx_counter == 0)
; 0000 0079             {
; 0000 007A         #else
; 0000 007B             if (rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0xD
	CLR  R5
; 0000 007C             if (++rx_counter == RX_BUFFER_SIZE)
_0xD:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BRNE _0xE
; 0000 007D             {
; 0000 007E                 rx_counter=0;
	CLR  R7
; 0000 007F         #endif
; 0000 0080                 rx_buffer_overflow=1;
	SET
	BLD  R2,0
; 0000 0081             }
; 0000 0082     }
_0xE:
; 0000 0083 }
_0xC:
	LD   R16,Y+
	LD   R17,Y+
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;unsigned char getchar(void)
; 0000 008A {
; 0000 008B     unsigned char data;
; 0000 008C     while (rx_counter==0);
;	data -> R17
; 0000 008D     data=rx_buffer[rx_rd_index++];
; 0000 008E     #if RX_BUFFER_SIZE != 256
; 0000 008F         if (rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 0090     #endif
; 0000 0091     #asm("cli")
; 0000 0092     --rx_counter;
; 0000 0093     #asm("sei")
; 0000 0094     return data;
; 0000 0095 }
;#pragma used-
;#endif
;
;// USART Transmitter buffer
;#define TX_BUFFER_SIZE 8
;unsigned char tx_buffer[TX_BUFFER_SIZE];
;
;#if TX_BUFFER_SIZE <= 256
;    unsigned char tx_wr_index,tx_rd_index,tx_counter;
;#else
;    unsigned int tx_wr_index,tx_rd_index,tx_counter;
;#endif
;
;// USART Transmitter interrupt service routine
;interrupt [USART_TXC] void usart_tx_isr(void)
; 0000 00A5 {
_usart_tx_isr:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00A6     if (tx_counter)
	TST  R8
	BREQ _0x13
; 0000 00A7     {
; 0000 00A8         --tx_counter;
	DEC  R8
; 0000 00A9         UDR=tx_buffer[tx_rd_index++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
; 0000 00AA         #if TX_BUFFER_SIZE != 256
; 0000 00AB             if (tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	LDI  R30,LOW(8)
	CP   R30,R9
	BRNE _0x14
	CLR  R9
; 0000 00AC         #endif
; 0000 00AD     }
_0x14:
; 0000 00AE }
_0x13:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(unsigned char c)
; 0000 00B5 {
_putchar:
; 0000 00B6     while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0x15:
	LDI  R30,LOW(8)
	CP   R30,R8
	BREQ _0x15
; 0000 00B7     #asm("cli")
	cli
; 0000 00B8     if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0))
	TST  R8
	BRNE _0x19
	SBIC 0xB,5
	RJMP _0x18
_0x19:
; 0000 00B9     {
; 0000 00BA         tx_buffer[tx_wr_index++]=c;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00BB         #if TX_BUFFER_SIZE != 256
; 0000 00BC             if (tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	LDI  R30,LOW(8)
	CP   R30,R6
	BRNE _0x1B
	CLR  R6
; 0000 00BD         #endif
; 0000 00BE         ++tx_counter;
_0x1B:
	INC  R8
; 0000 00BF     }
; 0000 00C0     else
	RJMP _0x1C
_0x18:
; 0000 00C1     UDR=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00C2     #asm("sei")
_0x1C:
	sei
; 0000 00C3 }
_0x2060001:
	ADIW R28,1
	RET
;#pragma used-
;#endif
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;/**************************** END OF USART INTERRUPT*************/
;
;/**************************** MACRO ****************************/
;
;#define TIME_CONST_1  100
;
;#if TIME_CONST_1 > 200
;#error "TIME_CONST_1 harus bernilai dibawah 200"
;#endif
;
;#define PTT_ON  (PORTB = 0xFF)
;#define PTT_OFF (PORTB = 0x00)
;#define DEBUG_PORT  PIND.7
;#define TX_LED  PORTC.0
;#define RX_LED  PORTC.1
;#define _1200_BAUD  PORTC.2
;#define _38400_BAUD PORTC.3
;#define CARRIER_DETECT  PIND.6
;
;/**************************** GLOBAL VARIABLE ******************/
;
;unsigned char   sensor_1[TIME_CONST_1] ,
;                sensor_2[TIME_CONST_1] ,
;                sensor_3[TIME_CONST_1] ,
;                sensor_4[TIME_CONST_1] ;
;
;eeprom unsigned char   sensor_1_min , sensor_2_min , sensor_3_min , sensor_4_min ,
;                    sensor_1_ave , sensor_2_ave , sensor_3_ave , sensor_4_ave ,
;                    sensor_1_max , sensor_2_max , sensor_3_max , sensor_4_max ;
;
;/**************************** FUNCTION DECLARATION *************/
;void set_time_gap(void);
;void init_port_a(void);
;void init_port_b(void);
;void init_port_c(void);
;void init_port_d(void);
;void init_timer(void);
;void init_usart(unsigned int baud);
;void kirim_data(void);
;void init_adc(void);
;void olah_data(void);
;void receive_command(void);
;
;/******************* TIMER 0 sampling adc **********************/
;// Timer 0 overflow interrupt service routine
;interrupt [TIM0_OVF] void timer0_ovf_isr(void)
; 0000 00F8 {
_timer0_ovf_isr:
	ST   -Y,R30
; 0000 00F9     // Place your code here
; 0000 00FA     // time gap ???
; 0000 00FB     TCNT0=0x01;
	LDI  R30,LOW(1)
	OUT  0x32,R30
; 0000 00FC }
	LD   R30,Y+
	RETI
;
;/******************* TIMER 1 transmit data *********************/
;#if TIME_CONST_1 < 128
;    char timer1_count;
;#else
;    unsigned char timer1_count;
;#endif
;void set_time_gap(void)
; 0000 0105 {
_set_time_gap:
; 0000 0106     /*
; 0000 0107     // time gap 30ms
; 0000 0108     TCNT1H=0xFE;
; 0000 0109     TCNT1L=0xBC;
; 0000 010A     */
; 0000 010B 
; 0000 010C     // time gap 20ms
; 0000 010D     TCNT1H=0xFF;
	LDI  R30,LOW(255)
	OUT  0x2D,R30
; 0000 010E     TCNT1L=0x28;
	LDI  R30,LOW(40)
	OUT  0x2C,R30
; 0000 010F }
	RET
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0113 {
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
; 0000 0114     // Place your code here
; 0000 0115     timer1_count++;
	INC  R11
; 0000 0116 
; 0000 0117     if(timer1_count < TIME_CONST_1)
	LDI  R30,LOW(100)
	CP   R11,R30
	BRLO PC+3
	JMP _0x1D
; 0000 0118     {
; 0000 0119         sensor_1[timer1_count] = read_adc(0);
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_sensor_1)
	SBCI R31,HIGH(-_sensor_1)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 011A         sensor_2[timer1_count] = read_adc(1);
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_sensor_2)
	SBCI R31,HIGH(-_sensor_2)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 011B         sensor_3[timer1_count] = read_adc(2);
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_sensor_3)
	SBCI R31,HIGH(-_sensor_3)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 011C         sensor_4[timer1_count] = read_adc(3);
	MOV  R30,R11
	LDI  R31,0
	SUBI R30,LOW(-_sensor_4)
	SBCI R31,HIGH(-_sensor_4)
	PUSH R31
	PUSH R30
	LDI  R30,LOW(3)
	ST   -Y,R30
	RCALL _read_adc
	POP  R26
	POP  R27
	ST   X,R30
; 0000 011D 
; 0000 011E         if(CARRIER_DETECT)
	SBIS 0x10,6
	RJMP _0x1E
; 0000 011F         {
; 0000 0120             if((timer1_count % 30) == 0)
	MOV  R26,R11
	CLR  R27
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __MODW21
	SBIW R30,0
	BRNE _0x1F
; 0000 0121             {
; 0000 0122                 init_usart(1200);
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _init_usart
; 0000 0123                 receive_command();
	RCALL _receive_command
; 0000 0124             }
; 0000 0125         }
_0x1F:
; 0000 0126         if(!DEBUG_PORT)
_0x1E:
	SBIC 0x10,7
	RJMP _0x20
; 0000 0127         {
; 0000 0128             if((timer1_count % 30) == 0)
	MOV  R26,R11
	CLR  R27
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	CALL __MODW21
	SBIW R30,0
	BRNE _0x21
; 0000 0129             {
; 0000 012A                 init_usart(38400);
	LDI  R30,LOW(38400)
	LDI  R31,HIGH(38400)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _init_usart
; 0000 012B                 putsf("debug ready ");
	__POINTW1FN _0x0,0
	ST   -Y,R31
	ST   -Y,R30
	RCALL _putsf
; 0000 012C             }
; 0000 012D         }
_0x21:
; 0000 012E     }
_0x20:
; 0000 012F     if(timer1_count == TIME_CONST_1)
_0x1D:
	LDI  R30,LOW(100)
	CP   R30,R11
	BRNE _0x22
; 0000 0130     {
; 0000 0131         timer1_count = 0;
	CLR  R11
; 0000 0132 
; 0000 0133         init_usart(1200);
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _init_usart
; 0000 0134 
; 0000 0135         olah_data();
	RCALL _olah_data
; 0000 0136 
; 0000 0137         RX_LED = 0;
	CBI  0x15,1
; 0000 0138         TX_LED = 1;
	SBI  0x15,0
; 0000 0139         PTT_ON;
	LDI  R30,LOW(255)
	OUT  0x18,R30
; 0000 013A         delay_ms(300);
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 013B 
; 0000 013C         kirim_data();
	RCALL _kirim_data
; 0000 013D         kirim_data();
	RCALL _kirim_data
; 0000 013E         kirim_data();
	RCALL _kirim_data
; 0000 013F 
; 0000 0140         delay_ms(150);
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
; 0000 0141         PTT_OFF;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0142         TX_LED = 0;
	CBI  0x15,0
; 0000 0143     }
; 0000 0144 
; 0000 0145     set_time_gap();
_0x22:
	RCALL _set_time_gap
; 0000 0146 }
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
;void init_port_a(void)
; 0000 014B {
_init_port_a:
; 0000 014C     // Port A initialization
; 0000 014D     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 014E     // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=P
; 0000 014F     PORTA=0x01;
	LDI  R30,LOW(1)
	OUT  0x1B,R30
; 0000 0150     DDRA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1A,R30
; 0000 0151 }
	RET
;
;void init_port_b(void)
; 0000 0154 {
_init_port_b:
; 0000 0155     // Port B initialization
; 0000 0156     // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0157     // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0158     PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0159     DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
; 0000 015A }
	RET
;
;void init_port_c(void)
; 0000 015D {
_init_port_c:
; 0000 015E     // Port C initialization
; 0000 015F     // Func7=Out Func6=Out Func5=Out Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0160     // State7=0 State6=0 State5=0 State4=0 State3=0 State2=0 State1=0 State0=0
; 0000 0161     PORTC=0x00;
	LDI  R30,LOW(0)
	OUT  0x15,R30
; 0000 0162     DDRC=0xFF;
	LDI  R30,LOW(255)
	OUT  0x14,R30
; 0000 0163 }
	RET
;
;void init_port_d(void)
; 0000 0166 {
_init_port_d:
; 0000 0167     // Port D initialization
; 0000 0168     // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=Out Func0=In
; 0000 0169     // State7=P State6=P State5=P State4=P State3=P State2=P State1=1 State0=P
; 0000 016A     PORTD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 016B     DDRD=0x02;
	LDI  R30,LOW(2)
	OUT  0x11,R30
; 0000 016C }
	RET
;
;void init_timer(void)
; 0000 016F {
_init_timer:
; 0000 0170     // TIMER 0 sampling ADC
; 0000 0171 
; 0000 0172     // Timer/Counter 0 initialization
; 0000 0173     // Clock source: System Clock
; 0000 0174     // Clock value: 10.800 kHz
; 0000 0175     // Mode: Normal top=0xFF
; 0000 0176     // OC0 output: Disconnected
; 0000 0177     TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
; 0000 0178     TCNT0=0xCA;
	LDI  R30,LOW(202)
	OUT  0x32,R30
; 0000 0179     OCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 017A 
; 0000 017B     // TIMER_1 transmit data
; 0000 017C 
; 0000 017D     // Timer/Counter 1 initialization
; 0000 017E     // Clock source: System Clock
; 0000 017F     // Clock value: 10.800 kHz
; 0000 0180     // Mode: Normal top=0xFFFF
; 0000 0181     // OC1A output: Discon.
; 0000 0182     // OC1B output: Discon.
; 0000 0183     // Noise Canceler: Off
; 0000 0184     // Input Capture on Falling Edge
; 0000 0185     // Timer1 Overflow Interrupt: On
; 0000 0186     // Input Capture Interrupt: Off
; 0000 0187     // Compare A Match Interrupt: Off
; 0000 0188     // Compare B Match Interrupt: Off
; 0000 0189     TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 018A     TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 018B 
; 0000 018C     set_time_gap();
	RCALL _set_time_gap
; 0000 018D }
	RET
;
;void init_usart(unsigned int baud)
; 0000 0190 {
_init_usart:
; 0000 0191     if(baud==1200)
;	baud -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x4B0)
	LDI  R30,HIGH(0x4B0)
	CPC  R27,R30
	BRNE _0x29
; 0000 0192     {
; 0000 0193         // USART initialization
; 0000 0194         // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0195         // USART Receiver: On
; 0000 0196         // USART Transmitter: On
; 0000 0197         // USART Mode: Asynchronous
; 0000 0198         // USART Baud Rate: 1200
; 0000 0199         UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 019A         UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 019B         UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 019C         UBRRH=0x02;
	LDI  R30,LOW(2)
	OUT  0x20,R30
; 0000 019D         UBRRL=0x3F;
	LDI  R30,LOW(63)
	OUT  0x9,R30
; 0000 019E 
; 0000 019F         _1200_BAUD = 1;
	SBI  0x15,2
; 0000 01A0         _38400_BAUD = 0;
	CBI  0x15,3
; 0000 01A1     }
; 0000 01A2 
; 0000 01A3     if(baud==38400)
_0x29:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x9600)
	LDI  R30,HIGH(0x9600)
	CPC  R27,R30
	BRNE _0x2E
; 0000 01A4     {
; 0000 01A5         // USART initialization
; 0000 01A6         // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 01A7         // USART Receiver: On
; 0000 01A8         // USART Transmitter: On
; 0000 01A9         // USART Mode: Asynchronous
; 0000 01AA         // USART Baud Rate: 38400
; 0000 01AB         UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 01AC         UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 01AD         UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 01AE         UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 01AF         UBRRL=0x11;
	LDI  R30,LOW(17)
	OUT  0x9,R30
; 0000 01B0 
; 0000 01B1         _1200_BAUD = 0;
	CBI  0x15,2
; 0000 01B2         _38400_BAUD = 1;
	SBI  0x15,3
; 0000 01B3     }
; 0000 01B4 }
_0x2E:
	ADIW R28,2
	RET
;
;#define SEPARATOR   ','
;void kirim_data(void)
; 0000 01B8 {
_kirim_data:
; 0000 01B9     putchar('$');
	LDI  R30,LOW(36)
	ST   -Y,R30
	RCALL _putchar
; 0000 01BA 
; 0000 01BB     putchar('3');
	LDI  R30,LOW(51)
	ST   -Y,R30
	RCALL _putchar
; 0000 01BC     putchar('S');
	LDI  R30,LOW(83)
	ST   -Y,R30
	RCALL _putchar
; 0000 01BD     putchar('E');
	LDI  R30,LOW(69)
	ST   -Y,R30
	RCALL _putchar
; 0000 01BE     putchar('C');
	LDI  R30,LOW(67)
	ST   -Y,R30
	RCALL _putchar
; 0000 01BF 
; 0000 01C0     putchar(SEPARATOR);
	LDI  R30,LOW(44)
	ST   -Y,R30
	RCALL _putchar
; 0000 01C1     putchar(sensor_1_min);
	LDI  R26,LOW(_sensor_1_min)
	LDI  R27,HIGH(_sensor_1_min)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01C2     putchar(sensor_1_ave);
	LDI  R26,LOW(_sensor_1_ave)
	LDI  R27,HIGH(_sensor_1_ave)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01C3     putchar(sensor_1_max);
	LDI  R26,LOW(_sensor_1_max)
	LDI  R27,HIGH(_sensor_1_max)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01C4 
; 0000 01C5     putchar(sensor_2_min);
	LDI  R26,LOW(_sensor_2_min)
	LDI  R27,HIGH(_sensor_2_min)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01C6     putchar(sensor_2_ave);
	LDI  R26,LOW(_sensor_2_ave)
	LDI  R27,HIGH(_sensor_2_ave)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01C7     putchar(sensor_2_max);
	LDI  R26,LOW(_sensor_2_max)
	LDI  R27,HIGH(_sensor_2_max)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01C8 
; 0000 01C9     putchar(sensor_3_min);
	LDI  R26,LOW(_sensor_3_min)
	LDI  R27,HIGH(_sensor_3_min)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01CA     putchar(sensor_3_ave);
	LDI  R26,LOW(_sensor_3_ave)
	LDI  R27,HIGH(_sensor_3_ave)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01CB     putchar(sensor_3_max);
	LDI  R26,LOW(_sensor_3_max)
	LDI  R27,HIGH(_sensor_3_max)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01CC 
; 0000 01CD     putchar(sensor_4_min);
	LDI  R26,LOW(_sensor_4_min)
	LDI  R27,HIGH(_sensor_4_min)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01CE     putchar(sensor_4_ave);
	LDI  R26,LOW(_sensor_4_ave)
	LDI  R27,HIGH(_sensor_4_ave)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01CF     putchar(sensor_4_max);
	LDI  R26,LOW(_sensor_4_max)
	LDI  R27,HIGH(_sensor_4_max)
	CALL __EEPROMRDB
	ST   -Y,R30
	RCALL _putchar
; 0000 01D0 
; 0000 01D1     putchar(SEPARATOR);
	LDI  R30,LOW(44)
	ST   -Y,R30
	RCALL _putchar
; 0000 01D2     putchar('*');
	LDI  R30,LOW(42)
	ST   -Y,R30
	RCALL _putchar
; 0000 01D3 
; 0000 01D4     putchar(13);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _putchar
; 0000 01D5 }
	RET
;
;void init_adc(void)
; 0000 01D8 {
_init_adc:
; 0000 01D9     // ADC initialization
; 0000 01DA     // ADC Clock frequency: 86.400 kHz
; 0000 01DB     // ADC Voltage Reference: AREF pin
; 0000 01DC     // Only the 8 most significant bits of
; 0000 01DD     // the AD conversion result are used
; 0000 01DE     ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
; 0000 01DF     ADCSRA=0x87;
	LDI  R30,LOW(135)
	OUT  0x6,R30
; 0000 01E0 }
	RET
;
;void olah_data(void)
; 0000 01E3 {
_olah_data:
; 0000 01E4     #if TIME_CONST_1 < 128
; 0000 01E5         char i;
; 0000 01E6     #else
; 0000 01E7         unsigned char i;
; 0000 01E8     #endif
; 0000 01E9 
; 0000 01EA     unsigned int ave_temp_1 = 0 , ave_temp_2 = 0 , ave_temp_3 = 0 , ave_temp_4 = 0;
; 0000 01EB 
; 0000 01EC     sensor_1_min = 255;
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	STD  Y+3,R30
	CALL __SAVELOCR6
;	i -> R17
;	ave_temp_1 -> R18,R19
;	ave_temp_2 -> R20,R21
;	ave_temp_3 -> Y+8
;	ave_temp_4 -> Y+6
	__GETWRN 18,19,0
	__GETWRN 20,21,0
	LDI  R26,LOW(_sensor_1_min)
	LDI  R27,HIGH(_sensor_1_min)
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
; 0000 01ED     sensor_1_ave = 0;
	LDI  R26,LOW(_sensor_1_ave)
	LDI  R27,HIGH(_sensor_1_ave)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 01EE     sensor_1_max = 0;
	LDI  R26,LOW(_sensor_1_max)
	LDI  R27,HIGH(_sensor_1_max)
	CALL __EEPROMWRB
; 0000 01EF 
; 0000 01F0     sensor_2_min = 255;
	LDI  R26,LOW(_sensor_2_min)
	LDI  R27,HIGH(_sensor_2_min)
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
; 0000 01F1     sensor_2_ave = 0;
	LDI  R26,LOW(_sensor_2_ave)
	LDI  R27,HIGH(_sensor_2_ave)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 01F2     sensor_2_max = 0;
	LDI  R26,LOW(_sensor_2_max)
	LDI  R27,HIGH(_sensor_2_max)
	CALL __EEPROMWRB
; 0000 01F3 
; 0000 01F4     sensor_3_min = 255;
	LDI  R26,LOW(_sensor_3_min)
	LDI  R27,HIGH(_sensor_3_min)
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
; 0000 01F5     sensor_3_ave = 0;
	LDI  R26,LOW(_sensor_3_ave)
	LDI  R27,HIGH(_sensor_3_ave)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 01F6     sensor_3_max = 0;
	LDI  R26,LOW(_sensor_3_max)
	LDI  R27,HIGH(_sensor_3_max)
	CALL __EEPROMWRB
; 0000 01F7 
; 0000 01F8     sensor_4_min = 255;
	LDI  R26,LOW(_sensor_4_min)
	LDI  R27,HIGH(_sensor_4_min)
	LDI  R30,LOW(255)
	CALL __EEPROMWRB
; 0000 01F9     sensor_4_ave = 0;
	LDI  R26,LOW(_sensor_4_ave)
	LDI  R27,HIGH(_sensor_4_ave)
	LDI  R30,LOW(0)
	CALL __EEPROMWRB
; 0000 01FA     sensor_4_max = 0;
	LDI  R26,LOW(_sensor_4_max)
	LDI  R27,HIGH(_sensor_4_max)
	CALL __EEPROMWRB
; 0000 01FB 
; 0000 01FC     for(i=0;i<TIME_CONST_1;i++)
	LDI  R17,LOW(0)
_0x34:
	CPI  R17,100
	BRLO PC+3
	JMP _0x35
; 0000 01FD     {
; 0000 01FE         if(sensor_1[i] < sensor_1_min) sensor_1_min = sensor_1[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_1)
	SBCI R31,HIGH(-_sensor_1)
	LD   R0,Z
	LDI  R26,LOW(_sensor_1_min)
	LDI  R27,HIGH(_sensor_1_min)
	CALL __EEPROMRDB
	CP   R0,R30
	BRSH _0x36
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_1)
	SBCI R31,HIGH(-_sensor_1)
	LD   R30,Z
	LDI  R26,LOW(_sensor_1_min)
	LDI  R27,HIGH(_sensor_1_min)
	CALL __EEPROMWRB
; 0000 01FF         if(sensor_1[i] > sensor_1_max) sensor_1_max = sensor_1[i];
_0x36:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_1)
	SBCI R31,HIGH(-_sensor_1)
	LD   R0,Z
	LDI  R26,LOW(_sensor_1_max)
	LDI  R27,HIGH(_sensor_1_max)
	CALL __EEPROMRDB
	CP   R30,R0
	BRSH _0x37
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_1)
	SBCI R31,HIGH(-_sensor_1)
	LD   R30,Z
	LDI  R26,LOW(_sensor_1_max)
	LDI  R27,HIGH(_sensor_1_max)
	CALL __EEPROMWRB
; 0000 0200         ave_temp_1 += sensor_1[i];
_0x37:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_1)
	SBCI R31,HIGH(-_sensor_1)
	LD   R30,Z
	LDI  R31,0
	__ADDWRR 18,19,30,31
; 0000 0201 
; 0000 0202         if(sensor_2[i] < sensor_2_min) sensor_2_min = sensor_2[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_2)
	SBCI R31,HIGH(-_sensor_2)
	LD   R0,Z
	LDI  R26,LOW(_sensor_2_min)
	LDI  R27,HIGH(_sensor_2_min)
	CALL __EEPROMRDB
	CP   R0,R30
	BRSH _0x38
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_2)
	SBCI R31,HIGH(-_sensor_2)
	LD   R30,Z
	LDI  R26,LOW(_sensor_2_min)
	LDI  R27,HIGH(_sensor_2_min)
	CALL __EEPROMWRB
; 0000 0203         if(sensor_2[i] > sensor_2_max) sensor_2_max = sensor_2[i];
_0x38:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_2)
	SBCI R31,HIGH(-_sensor_2)
	LD   R0,Z
	LDI  R26,LOW(_sensor_2_max)
	LDI  R27,HIGH(_sensor_2_max)
	CALL __EEPROMRDB
	CP   R30,R0
	BRSH _0x39
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_2)
	SBCI R31,HIGH(-_sensor_2)
	LD   R30,Z
	LDI  R26,LOW(_sensor_2_max)
	LDI  R27,HIGH(_sensor_2_max)
	CALL __EEPROMWRB
; 0000 0204         ave_temp_2 += sensor_2[i];
_0x39:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_2)
	SBCI R31,HIGH(-_sensor_2)
	LD   R30,Z
	LDI  R31,0
	__ADDWRR 20,21,30,31
; 0000 0205 
; 0000 0206         if(sensor_3[i] < sensor_3_min) sensor_3_min = sensor_3[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_3)
	SBCI R31,HIGH(-_sensor_3)
	LD   R0,Z
	LDI  R26,LOW(_sensor_3_min)
	LDI  R27,HIGH(_sensor_3_min)
	CALL __EEPROMRDB
	CP   R0,R30
	BRSH _0x3A
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_3)
	SBCI R31,HIGH(-_sensor_3)
	LD   R30,Z
	LDI  R26,LOW(_sensor_3_min)
	LDI  R27,HIGH(_sensor_3_min)
	CALL __EEPROMWRB
; 0000 0207         if(sensor_3[i] > sensor_3_max) sensor_3_max = sensor_3[i];
_0x3A:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_3)
	SBCI R31,HIGH(-_sensor_3)
	LD   R0,Z
	LDI  R26,LOW(_sensor_3_max)
	LDI  R27,HIGH(_sensor_3_max)
	CALL __EEPROMRDB
	CP   R30,R0
	BRSH _0x3B
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_3)
	SBCI R31,HIGH(-_sensor_3)
	LD   R30,Z
	LDI  R26,LOW(_sensor_3_max)
	LDI  R27,HIGH(_sensor_3_max)
	CALL __EEPROMWRB
; 0000 0208         ave_temp_3 += sensor_3[i];
_0x3B:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_3)
	SBCI R31,HIGH(-_sensor_3)
	LD   R30,Z
	LDI  R31,0
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 0209 
; 0000 020A         if(sensor_4[i] < sensor_4_min) sensor_4_min = sensor_4[i];
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_4)
	SBCI R31,HIGH(-_sensor_4)
	LD   R0,Z
	LDI  R26,LOW(_sensor_4_min)
	LDI  R27,HIGH(_sensor_4_min)
	CALL __EEPROMRDB
	CP   R0,R30
	BRSH _0x3C
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_4)
	SBCI R31,HIGH(-_sensor_4)
	LD   R30,Z
	LDI  R26,LOW(_sensor_4_min)
	LDI  R27,HIGH(_sensor_4_min)
	CALL __EEPROMWRB
; 0000 020B         if(sensor_4[i] > sensor_4_max) sensor_4_max = sensor_4[i];
_0x3C:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_4)
	SBCI R31,HIGH(-_sensor_4)
	LD   R0,Z
	LDI  R26,LOW(_sensor_4_max)
	LDI  R27,HIGH(_sensor_4_max)
	CALL __EEPROMRDB
	CP   R30,R0
	BRSH _0x3D
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_4)
	SBCI R31,HIGH(-_sensor_4)
	LD   R30,Z
	LDI  R26,LOW(_sensor_4_max)
	LDI  R27,HIGH(_sensor_4_max)
	CALL __EEPROMWRB
; 0000 020C         ave_temp_4 += sensor_4[i];
_0x3D:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_sensor_4)
	SBCI R31,HIGH(-_sensor_4)
	LD   R30,Z
	LDI  R31,0
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADD  R30,R26
	ADC  R31,R27
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 020D     }
	SUBI R17,-1
	RJMP _0x34
_0x35:
; 0000 020E 
; 0000 020F     sensor_1_ave = (unsigned char)(ave_temp_1 / TIME_CONST_1);
	MOVW R26,R18
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(_sensor_1_ave)
	LDI  R27,HIGH(_sensor_1_ave)
	CALL __EEPROMWRB
; 0000 0210     sensor_2_ave = (unsigned char)(ave_temp_2 / TIME_CONST_1);
	MOVW R26,R20
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(_sensor_2_ave)
	LDI  R27,HIGH(_sensor_2_ave)
	CALL __EEPROMWRB
; 0000 0211     sensor_3_ave = (unsigned char)(ave_temp_3 / TIME_CONST_1);
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(_sensor_3_ave)
	LDI  R27,HIGH(_sensor_3_ave)
	CALL __EEPROMWRB
; 0000 0212     sensor_4_ave = (unsigned char)(ave_temp_4 / TIME_CONST_1);
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL __DIVW21U
	LDI  R26,LOW(_sensor_4_ave)
	LDI  R27,HIGH(_sensor_4_ave)
	CALL __EEPROMWRB
; 0000 0213 }
	CALL __LOADLOCR6
	ADIW R28,10
	RET
;
;void receive_command(void)
; 0000 0216 {
_receive_command:
; 0000 0217     RX_LED = 1;
	SBI  0x15,1
; 0000 0218 }
	RET
;
;void main(void)
; 0000 021B {
_main:
; 0000 021C     init_port_a();
	RCALL _init_port_a
; 0000 021D     init_port_b();
	RCALL _init_port_b
; 0000 021E     init_port_c();
	RCALL _init_port_c
; 0000 021F     init_port_d();
	RCALL _init_port_d
; 0000 0220     init_usart(1200);
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _init_usart
; 0000 0221     init_adc();
	RCALL _init_adc
; 0000 0222     init_timer();
	RCALL _init_timer
; 0000 0223 
; 0000 0224     timer1_count = 0;
	CLR  R11
; 0000 0225 
; 0000 0226     // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 0227     TIMSK=0x05;
	LDI  R30,LOW(5)
	OUT  0x39,R30
; 0000 0228 
; 0000 0229     // Analog Comparator initialization
; 0000 022A     // Analog Comparator: Off
; 0000 022B     // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 022C     ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 022D     SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 022E 
; 0000 022F     // Global enable interrupts
; 0000 0230     #asm("sei")
	sei
; 0000 0231 
; 0000 0232     while (1)
_0x40:
; 0000 0233     {
; 0000 0234         // Place your code here
; 0000 0235     };
	RJMP _0x40
; 0000 0236 }
_0x43:
	RJMP _0x43
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
_putsf:
	ST   -Y,R17
_0x2000006:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x2000008
	ST   -Y,R17
	CALL _putchar
	RJMP _0x2000006
_0x2000008:
	LDI  R30,LOW(10)
	ST   -Y,R30
	CALL _putchar
	LDD  R17,Y+0
	ADIW R28,3
	RET

	.CSEG

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x8
_tx_buffer:
	.BYTE 0x8
_sensor_1:
	.BYTE 0x64
_sensor_2:
	.BYTE 0x64
_sensor_3:
	.BYTE 0x64
_sensor_4:
	.BYTE 0x64

	.ESEG
_sensor_1_min:
	.BYTE 0x1
_sensor_2_min:
	.BYTE 0x1
_sensor_3_min:
	.BYTE 0x1
_sensor_4_min:
	.BYTE 0x1
_sensor_1_ave:
	.BYTE 0x1
_sensor_2_ave:
	.BYTE 0x1
_sensor_3_ave:
	.BYTE 0x1
_sensor_4_ave:
	.BYTE 0x1
_sensor_1_max:
	.BYTE 0x1
_sensor_2_max:
	.BYTE 0x1
_sensor_3_max:
	.BYTE 0x1
_sensor_4_max:
	.BYTE 0x1

	.CSEG

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
