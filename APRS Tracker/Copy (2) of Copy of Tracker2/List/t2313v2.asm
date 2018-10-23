
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATtiny2313
;Program type             : Application
;Clock frequency          : 11.059200 MHz
;Memory model             : Tiny
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 32 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATtiny2313
	#pragma AVRPART MEMORY PROG_FLASH 2048
	#pragma AVRPART MEMORY EEPROM 128
	#pragma AVRPART MEMORY INT_SRAM SIZE 223
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
	.EQU UDRE=0x5
	.EQU RXC=0x7
	.EQU USR=0xB
	.EQU UDR=0xC
	.EQU EERE=0x0
	.EQU EEWE=0x1
	.EQU EEMWE=0x2
	.EQU EECR=0x1C
	.EQU EEDR=0x1D
	.EQU EEARL=0x1E
	.EQU WDTCR=0x21
	.EQU MCUSR=0x34
	.EQU MCUCR=0x35
	.EQU SPL=0x3D
	.EQU SREG=0x3F
	.EQU GPIOR0=0x13
	.EQU GPIOR1=0x14
	.EQU GPIOR2=0x15

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
	.EQU __SRAM_END=0x00DF
	.EQU __DSTACK_SIZE=0x0020
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
	RCALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMWRD
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
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	RCALL __EEPROMRDW
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
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SN
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1SNS
	LDD  R26,Y+@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RN
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RN
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1RNS
	MOV  R26,R@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMN
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMN
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
	.ENDM

	.MACRO __PUTB1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X,R30
	.ENDM

	.MACRO __PUTW1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	ST   X+,R30
	ST   X,R31
	.ENDM

	.MACRO __PUTD1PMNS
	LDS  R26,@0
	SUBI R26,-@1
	RCALL __PUTDP1
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _fcshi=R3
	.DEF _fcslo=R2
	.DEF _count_1=R5
	.DEF _x_counter=R4
	.DEF _tone=R6

;GPIOR0-GPIOR2 INITIALIZATION VALUES
	.EQU __GPIOR0_INIT=0x00
	.EQU __GPIOR1_INIT=0x00
	.EQU __GPIOR2_INIT=0x00

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_latitude:
	.DB  0x30,0x37,0x34,0x35,0x2E,0x37,0x39,0x53
_longitude:
	.DB  0x31,0x31,0x30,0x30,0x35,0x2E,0x32,0x31
	.DB  0x45
_comment:
	.DB  0x54,0x45,0x53,0x54,0x49,0x4E,0x47,0x20
	.DB  0x46,0x4F,0x52,0x20,0x45,0x4D,0x45,0x52
	.DB  0x47,0x45,0x4E,0x43,0x59,0x20,0x42,0x45
	.DB  0x41,0x43,0x4F,0x4E,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20,0x20,0x20,0x20,0x20,0x20
	.DB  0x20,0x20,0x20

_0x3:
	.DB  0x41,0x50,0x55,0x32,0x35,0x4D
_0x4:
	.DB  0x59,0x44,0x32,0x58,0x42,0x43
_0x5:
	.DB  0x57,0x49,0x44,0x45,0x32,0x0,0x20
_0x6D:
	.DB  0x0,0x0,0xB0,0x4

__GLOBAL_INI_TBL:
	.DW  0x06
	.DW  _destination
	.DW  _0x3*2

	.DW  0x06
	.DW  _source
	.DW  _0x4*2

	.DW  0x07
	.DW  _digi
	.DW  _0x5*2

	.DW  0x04
	.DW  0x04
	.DW  _0x6D*2

_0xFFFFFFFF:
	.DW  0

__RESET:
	CLI
	CLR  R30
	OUT  EECR,R30
	OUT  MCUCR,R30

;DISABLE WATCHDOG
	LDI  R31,0x18
	IN   R26,MCUSR
	CBR  R26,8
	OUT  MCUSR,R26
	OUT  WDTCR,R31
	OUT  WDTCR,R30

;CLEAR R2-R14
	LDI  R24,(14-2)+1
	LDI  R26,2
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,__CLEAR_SRAM_SIZE
	LDI  R26,__SRAM_START
__CLEAR_SRAM:
	ST   X+,R30
	DEC  R24
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

;GPIOR0-GPIOR2 INITIALIZATION
	LDI  R30,__GPIOR0_INIT
	OUT  GPIOR0,R30
	;__GPIOR1_INIT = __GPIOR0_INIT
	OUT  GPIOR1,R30
	;__GPIOR2_INIT = __GPIOR0_INIT
	OUT  GPIOR2,R30

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x80

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V1.25.3 Professional
;Automatic Program Generator
;© Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : APRS BEACON
;Version : 2 (bread board version)
;Date    : 12/23/2011
;Author  : HANDIKO GESANG ANUGRAH S.
;Company : LABORATORIUM SENSOR DAN TELEKONTROL
;	  JURUSAN TEKNIK FISIKA
;          FAKULTAS TEKNIK
;          UNIVERSITAS GADJAH MADA
;
;Chip type           : ATtiny2313
;Program type        : Application
;Clock frequency     : 11.059200 MHz
;Memory model        : Small
;External SRAM size  : 0
;Data Stack size     : 32
;
;Comment : Polynomial Generator G(x) = x^16 + x^12 + x^5 + 1
; 	  First test for protocol management and basic function without GPS
;
;*****************************************************/
;
;#include <tiny2313.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;
;#define on      1
;#define off     0
;
;#define CONST_1200      52
;#define CONST_2200      28
;#define CONST_POLYNOM   0b10001000000100001	// x^16 + x^12 + x^5 + 1
;//#define CONST_POLYNOM	0b11000000000000101	// x^16 + x^15 + x^2 + 1
;
;#define TX_NOW  PIND.2
;#define L_STBY  PORTD.3
;#define L_TX	PORTD.4
;#define L_AUX   PORTD.5
;#define PTT     PORTD.6
;#define DAC_0   PORTB.0
;#define DAC_1   PORTB.1
;#define DAC_2   PORTB.2
;#define DAC_3   PORTB.3
;
;void protocol(void);
;void send_data(char input);
;void fliptone(void);
;void set_dac(char value);
;void send_tone(int nada);
;void send_fcs(char infcs);
;void calc_fcs(char in);
;void init_clock(void);
;void init_ports(void);
;
;flash char flag = 0x7E;
;flash char ssid_2 = 0b01100100;
;flash char ssid_9 = 0b01110010;
;flash char ssid_2final = 0b01100101;
;// flash char ssid_9final = 0b01110011;
;char destination[7] = {
;        0x41,0x50,0x55,0x32,0x35,0x4D,
;        0               // SSID
;        // APU25N-2     // 0b011SSIDx format, SSID = 2 = 0b0010
;};

	.DSEG
;char source[7] = {
;        0x59,0x44,0x32,0x58,0x42,0x43,
;        0               // SSID
;        // YD2XBC-9     // 0b011SSIDx format, SSID = 9 = 0b1001
;};
;char digi[7] = {
;        // 0x57,0x49,0x44,0x45,0x32,0x32,0x20    // atau
;        0x57,0x49,0x44,0x45,0x32,
;        0,              // SSID
;        0x20
;        // WIDE2-2      // 0b011SSIDx format, SSID = 2 = 0b0010
;};
;flash char control_field = 0x03;
;flash char protocol_id = 0xF0;
;flash char data_type = 0x21;
;flash char latitude[8] = {
;        0x30,0x37,0x34,0x35,0x2E,0x37,0x39,0x53			// format string
;        // 0,7,4,5,0x2E,7,9,0x53				// format int
;        // 0745.79S
;};
;flash char symbol_table = 0x2F;
;flash char longitude[9] = {
;        0x31,0x31,0x30,0x30,0x35,0x2E,0x32,0x31,0x45
;        // 1,1,0,0,5,0x2E,2,1,0x45
;        // 11005.21E
;};
;flash char symbol_code = 0x3E;
;flash char comment[43] = {
;        0x54,0x45,0x53,0x54,0x49,0x4E,0x47,0x20,                // testing(spasi)
;        0x46,0x4F,0x52,0x20,                                    // for(spasi)
;        0x45,0x4D,0x45,0x52,0x47,0x45,0x4E,0x43,0x59,0x20,      // emergency(spasi)
;        0x42,0x45,0x41,0x43,0x4F,0x4E,0x20,                     // beacon(spasi)
;        0x20,0x20,0x20,0x20,0x20,0x20,0x20,                     // (spasi)
;        0x20,0x20,0x20,0x20,0x20,0x20,0x20                      // (spasi)
;        // testing for emergency beacon
;};
;char fcshi;
;char fcslo;
;char count_1 = 0;
;char x_counter = 0;
;bit flag_state;
;bit crc_flag = 0;
;int tone = 1200;
;long fcs_arr = 0;
;
;void init_data(void) {
; 0000 0073 void init_data(void) {

	.CSEG
_init_data:
; 0000 0074 	int i;
; 0000 0075         for(i=0;i<7;i++) {
	RCALL __SAVELOCR2
;	i -> R16,R17
	RCALL SUBOPT_0x0
_0x7:
	RCALL SUBOPT_0x1
	BRGE _0x8
; 0000 0076                 digi[i] <<= 1;
	MOV  R26,R16
	SUBI R26,-LOW(_digi)
	RCALL SUBOPT_0x2
; 0000 0077                 destination[i] <<= 1;
	SUBI R26,-LOW(_destination)
	RCALL SUBOPT_0x2
; 0000 0078                 source[i] <<= 1;
	SUBI R26,-LOW(_source)
	LD   R30,X
	LSL  R30
	ST   X,R30
; 0000 0079         }
	RCALL SUBOPT_0x3
	RJMP _0x7
_0x8:
; 0000 007A 
; 0000 007B         destination[6] = ssid_2;
	LDI  R30,LOW(100)
	__PUTB1MN _destination,6
; 0000 007C         source[6] = ssid_9;
	LDI  R30,LOW(114)
	__PUTB1MN _source,6
; 0000 007D         digi[5] = ssid_2final;
	LDI  R30,LOW(101)
	__PUTB1MN _digi,5
; 0000 007E }
	RJMP _0x2000002
;
;void protocol(void) {
; 0000 0080 void protocol(void) {
_protocol:
; 0000 0081         int i;
; 0000 0082 
; 0000 0083         init_data();						// persiapkan bit shifting
	RCALL __SAVELOCR2
;	i -> R16,R17
	RCALL _init_data
; 0000 0084 
; 0000 0085         PTT = on;
	SBI  0x12,6
; 0000 0086         L_TX = on;
	SBI  0x12,4
; 0000 0087         delay_ms(250);                  			// tunggu sampai radio stabil
	RCALL SUBOPT_0x4
; 0000 0088 
; 0000 0089         crc_flag = 0;
	CBI  0x13,1
; 0000 008A         flag_state = 1;
	SBI  0x13,0
; 0000 008B         for(i=0;i<24;i++)       send_data(flag);             	// kirim flag 24 kali
	RCALL SUBOPT_0x0
_0x12:
	__CPWRN 16,17,24
	BRGE _0x13
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	RJMP _0x12
_0x13:
; 0000 008C flag_state = 0;
	CBI  0x13,0
; 0000 008D         for(i=0;i<7;i++)        send_data(destination[i]);      // kirim callsign tujuan
	RCALL SUBOPT_0x0
_0x17:
	RCALL SUBOPT_0x1
	BRGE _0x18
	LDI  R26,LOW(_destination)
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3
	RJMP _0x17
_0x18:
; 0000 008E for(i=0;i<7;i++)        send_data(source[i]);
	RCALL SUBOPT_0x0
_0x1A:
	RCALL SUBOPT_0x1
	BRGE _0x1B
	LDI  R26,LOW(_source)
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3
	RJMP _0x1A
_0x1B:
; 0000 008F send_data(ssid_9);
	LDI  R30,LOW(114)
	RCALL SUBOPT_0x5
; 0000 0090         for(i=0;i<7;i++)        send_data(digi[i]);             // kirim path digi
	RCALL SUBOPT_0x0
_0x1D:
	RCALL SUBOPT_0x1
	BRGE _0x1E
	LDI  R26,LOW(_digi)
	RCALL SUBOPT_0x6
	RCALL SUBOPT_0x3
	RJMP _0x1D
_0x1E:
; 0000 0091 send_data(control_field);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x5
; 0000 0092         send_data(protocol_id);                                 // kirim data PID
	LDI  R30,LOW(240)
	RCALL SUBOPT_0x5
; 0000 0093         send_data(data_type);                                   // kirim data type info
	LDI  R30,LOW(33)
	RCALL SUBOPT_0x5
; 0000 0094         for(i=0;i<8;i++)        send_data(latitude[i]);         // kirim data lintang posisi
	RCALL SUBOPT_0x0
_0x20:
	__CPWRN 16,17,8
	BRGE _0x21
	MOVW R30,R16
	SUBI R30,LOW(-_latitude*2)
	SBCI R31,HIGH(-_latitude*2)
	LPM  R30,Z
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	RJMP _0x20
_0x21:
; 0000 0095 send_data(symbol_table);
	LDI  R30,LOW(47)
	RCALL SUBOPT_0x5
; 0000 0096         for(i=0;i<9;i++)        send_data(longitude[i]);        // kirim data bujur posisi
	RCALL SUBOPT_0x0
_0x23:
	__CPWRN 16,17,9
	BRGE _0x24
	MOVW R30,R16
	SUBI R30,LOW(-_longitude*2)
	SBCI R31,HIGH(-_longitude*2)
	LPM  R30,Z
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	RJMP _0x23
_0x24:
; 0000 0097 send_data(symbol_code);
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x5
; 0000 0098         for(i=0;i<43;i++);      send_data(comment[i]);          // kirim komen
	RCALL SUBOPT_0x0
_0x26:
	__CPWRN 16,17,43
	BRGE _0x27
	RCALL SUBOPT_0x3
	RJMP _0x26
_0x27:
	MOVW R30,R16
	SUBI R30,LOW(-_comment*2)
	SBCI R31,HIGH(-_comment*2)
	LPM  R30,Z
	RCALL SUBOPT_0x5
; 0000 0099         crc_flag = 1;    	calc_fcs(0);	               	// hitung FCS
	SBI  0x13,1
	RCALL SUBOPT_0x7
	RCALL _calc_fcs
; 0000 009A         send_fcs(fcshi);                                        // kirim 8 MSB dari FCS
	ST   -Y,R3
	RCALL _send_fcs
; 0000 009B         send_fcs(fcslo);                                        // kirim 8 LSB dari FCS
	ST   -Y,R2
	RCALL _send_fcs
; 0000 009C         flag_state = 1;
	SBI  0x13,0
; 0000 009D         for(i=0;i<12;i++)       send_data(flag);             	// kirim flag 12 kali
	RCALL SUBOPT_0x0
_0x2D:
	__CPWRN 16,17,12
	BRGE _0x2E
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x5
	RCALL SUBOPT_0x3
	RJMP _0x2D
_0x2E:
; 0000 009E flag_state = 0;
	CBI  0x13,0
; 0000 009F         PTT = off;
	CBI  0x12,6
; 0000 00A0         L_TX = off;
	CBI  0x12,4
; 0000 00A1 }
_0x2000002:
	RCALL __LOADLOCR2P
	RET
;
;void send_data(char input) {
; 0000 00A3 void send_data(char input) {
_send_data:
	PUSH R15
; 0000 00A4         int i;
; 0000 00A5         bit x;
; 0000 00A6         for(i=0;i<8;i++) {
	RCALL __SAVELOCR2
;	input -> Y+2
;	i -> R16,R17
;	x -> R15.0
	RCALL SUBOPT_0x0
_0x36:
	__CPWRN 16,17,8
	BRGE _0x37
; 0000 00A7                 x = (input >> i) & 0x01;
	RCALL SUBOPT_0x8
; 0000 00A8                 if(!flag_state)	calc_fcs(x);
	SBIC 0x13,0
	RJMP _0x38
	LDI  R30,0
	SBRC R15,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _calc_fcs
; 0000 00A9                 if(x) {
_0x38:
	SBRS R15,0
	RJMP _0x39
; 0000 00AA                         if(!flag_state) count_1++;
	SBIS 0x13,0
	INC  R5
; 0000 00AB                         if(count_1==5)  fliptone();
	LDI  R30,LOW(5)
	CP   R30,R5
	BRNE _0x3B
	RCALL _fliptone
; 0000 00AC                         send_tone(tone);
_0x3B:
	RCALL SUBOPT_0x9
; 0000 00AD                 }
; 0000 00AE                 if(!x)  fliptone();
_0x39:
	SBRS R15,0
	RCALL _fliptone
; 0000 00AF         }
	RCALL SUBOPT_0x3
	RJMP _0x36
_0x37:
; 0000 00B0 }
	RJMP _0x2000001
;
;void fliptone(void) {
; 0000 00B2 void fliptone(void) {
_fliptone:
; 0000 00B3         count_1 = 0;
	CLR  R5
; 0000 00B4         switch(tone) {
	MOVW R30,R6
; 0000 00B5                 case 1200:      tone=2200;      send_tone(tone);        break;
	CPI  R30,LOW(0x4B0)
	LDI  R26,HIGH(0x4B0)
	CPC  R31,R26
	BRNE _0x40
	LDI  R30,LOW(2200)
	LDI  R31,HIGH(2200)
	RJMP _0x6C
; 0000 00B6                 case 2200:      tone=1200;      send_tone(tone);        break;
_0x40:
	CPI  R30,LOW(0x898)
	LDI  R26,HIGH(0x898)
	CPC  R31,R26
	BRNE _0x3F
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
_0x6C:
	MOVW R6,R30
	RCALL SUBOPT_0x9
; 0000 00B7         }
_0x3F:
; 0000 00B8 }
	RET
;
;void set_dac(char value) {
; 0000 00BA void set_dac(char value) {
_set_dac:
; 0000 00BB         DAC_0 = value & 0x01;
;	value -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x42
	CBI  0x18,0
	RJMP _0x43
_0x42:
	SBI  0x18,0
_0x43:
; 0000 00BC         DAC_1 =( value >> 1 ) & 0x01;
	RCALL SUBOPT_0xA
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x44
	CBI  0x18,1
	RJMP _0x45
_0x44:
	SBI  0x18,1
_0x45:
; 0000 00BD         DAC_2 =( value >> 2 ) & 0x01;
	RCALL SUBOPT_0xA
	RCALL __ASRW2
	ANDI R30,LOW(0x1)
	BRNE _0x46
	CBI  0x18,2
	RJMP _0x47
_0x46:
	SBI  0x18,2
_0x47:
; 0000 00BE         DAC_3 =( value >> 3 ) & 0x01;
	RCALL SUBOPT_0xA
	RCALL __ASRW3
	ANDI R30,LOW(0x1)
	BRNE _0x48
	CBI  0x18,3
	RJMP _0x49
_0x48:
	SBI  0x18,3
_0x49:
; 0000 00BF }
	ADIW R28,1
	RET
;
;void send_tone(int nada) {
; 0000 00C1 void send_tone(int nada) {
_send_tone:
; 0000 00C2         if(nada==1200) {
;	nada -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x4B0)
	LDI  R30,HIGH(0x4B0)
	CPC  R27,R30
	BRNE _0x4A
; 0000 00C3                 set_dac(7);     delay_us(CONST_1200);
	RCALL SUBOPT_0xB
; 0000 00C4 
; 0000 00C5                 set_dac(10);    delay_us(CONST_1200);
	RCALL SUBOPT_0xC
; 0000 00C6                 set_dac(13);    delay_us(CONST_1200);
	RCALL SUBOPT_0xD
; 0000 00C7                 set_dac(14);    delay_us(CONST_1200);
	RCALL SUBOPT_0xE
; 0000 00C8 
; 0000 00C9                 set_dac(15);    delay_us(CONST_1200);
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x10
; 0000 00CA 
; 0000 00CB                 set_dac(14);    delay_us(CONST_1200);
	RCALL SUBOPT_0xE
; 0000 00CC                 set_dac(13);    delay_us(CONST_1200);
	RCALL SUBOPT_0xD
; 0000 00CD                 set_dac(10);    delay_us(CONST_1200);
	RCALL SUBOPT_0xC
; 0000 00CE 
; 0000 00CF                 set_dac(7);     delay_us(CONST_1200);
	RCALL SUBOPT_0xB
; 0000 00D0 
; 0000 00D1                 set_dac(5);     delay_us(CONST_1200);
	RCALL SUBOPT_0x11
; 0000 00D2                 set_dac(2);     delay_us(CONST_1200);
	RCALL SUBOPT_0x12
; 0000 00D3                 set_dac(1);     delay_us(CONST_1200);
	RCALL SUBOPT_0x13
; 0000 00D4 
; 0000 00D5                 set_dac(0);     delay_us(CONST_1200);
	RCALL SUBOPT_0x7
	RCALL _set_dac
	RCALL SUBOPT_0x10
; 0000 00D6 
; 0000 00D7                 set_dac(1);     delay_us(CONST_1200);
	RCALL SUBOPT_0x13
; 0000 00D8                 set_dac(2);     delay_us(CONST_1200);
	RCALL SUBOPT_0x12
; 0000 00D9                 set_dac(5);     delay_us(CONST_1200);
	RCALL SUBOPT_0x11
; 0000 00DA         }
; 0000 00DB 
; 0000 00DC         else {
	RJMP _0x4B
_0x4A:
; 0000 00DD                 set_dac(7);     delay_us(CONST_2200);
	RCALL SUBOPT_0x14
; 0000 00DE 
; 0000 00DF                 set_dac(10);    delay_us(CONST_2200);
	RCALL SUBOPT_0x15
; 0000 00E0                 set_dac(13);    delay_us(CONST_2200);
	RCALL SUBOPT_0x16
; 0000 00E1                 set_dac(14);    delay_us(CONST_2200);
	RCALL SUBOPT_0x17
; 0000 00E2 
; 0000 00E3                 set_dac(15);    delay_us(CONST_2200);
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x18
; 0000 00E4 
; 0000 00E5                 set_dac(14);    delay_us(CONST_2200);
	RCALL SUBOPT_0x17
; 0000 00E6                 set_dac(13);    delay_us(CONST_2200);
	RCALL SUBOPT_0x16
; 0000 00E7                 set_dac(10);    delay_us(CONST_2200);
	RCALL SUBOPT_0x15
; 0000 00E8 
; 0000 00E9                 set_dac(7);     delay_us(CONST_2200);
	RCALL SUBOPT_0x14
; 0000 00EA 
; 0000 00EB                 set_dac(5);     delay_us(CONST_2200);
	RCALL SUBOPT_0x19
; 0000 00EC                 set_dac(2);     delay_us(CONST_2200);
	RCALL SUBOPT_0x1A
; 0000 00ED                 set_dac(1);     delay_us(CONST_2200);
	RCALL SUBOPT_0x1B
; 0000 00EE 
; 0000 00EF                 set_dac(0);     delay_us(CONST_2200);
	RCALL SUBOPT_0x7
	RCALL _set_dac
	RCALL SUBOPT_0x18
; 0000 00F0 
; 0000 00F1                 set_dac(1);     delay_us(CONST_2200);
	RCALL SUBOPT_0x1B
; 0000 00F2                 set_dac(2);     delay_us(CONST_2200);
	RCALL SUBOPT_0x1A
; 0000 00F3                 set_dac(5);     delay_us(CONST_2200);
	RCALL SUBOPT_0x19
; 0000 00F4 
; 0000 00F5                 set_dac(7);     delay_us(CONST_2200);
	RCALL SUBOPT_0x14
; 0000 00F6 
; 0000 00F7                 set_dac(10);    delay_us(CONST_2200);
	RCALL SUBOPT_0x15
; 0000 00F8                 set_dac(13);    delay_us(CONST_2200);
	RCALL SUBOPT_0x16
; 0000 00F9                 set_dac(14);    delay_us(CONST_2200);
	RCALL SUBOPT_0x17
; 0000 00FA 
; 0000 00FB                 set_dac(15);    delay_us(CONST_2200);
	RCALL SUBOPT_0xF
	RCALL SUBOPT_0x18
; 0000 00FC 
; 0000 00FD                 set_dac(14);    delay_us(CONST_2200);
	RCALL SUBOPT_0x17
; 0000 00FE                 set_dac(13);    delay_us(CONST_2200);
	RCALL SUBOPT_0x16
; 0000 00FF                 set_dac(10);    delay_us(CONST_2200);
	RCALL SUBOPT_0x15
; 0000 0100 
; 0000 0101                 set_dac(7);     delay_us(CONST_2200);
	RCALL SUBOPT_0x14
; 0000 0102 
; 0000 0103                 set_dac(5);     delay_us(CONST_2200);
	RCALL SUBOPT_0x19
; 0000 0104                 set_dac(2);     delay_us(CONST_2200);
	RCALL SUBOPT_0x1A
; 0000 0105                 set_dac(1);     delay_us(CONST_2200);
	RCALL SUBOPT_0x1B
; 0000 0106 
; 0000 0107                 set_dac(0);     delay_us(CONST_2200);
	RCALL SUBOPT_0x7
	RCALL _set_dac
	RCALL SUBOPT_0x18
; 0000 0108 
; 0000 0109                 set_dac(1);     delay_us(CONST_2200);
	RCALL SUBOPT_0x1B
; 0000 010A                 set_dac(2);     delay_us(CONST_2200);
	RCALL SUBOPT_0x1A
; 0000 010B                 set_dac(5);     delay_us(CONST_2200);
	RCALL SUBOPT_0x19
; 0000 010C         }
_0x4B:
; 0000 010D }
	ADIW R28,2
	RET
;
;void send_fcs(char infcs) {
; 0000 010F void send_fcs(char infcs) {
_send_fcs:
	PUSH R15
; 0000 0110         int j=7;
; 0000 0111         bit x;
; 0000 0112         while(j>0) {
	RCALL __SAVELOCR2
;	infcs -> Y+2
;	j -> R16,R17
;	x -> R15.0
	__GETWRN 16,17,7
_0x4C:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRGE _0x4E
; 0000 0113                 x = (infcs >> j) & 0x01;
	RCALL SUBOPT_0x8
; 0000 0114                 if(x) {
	SBRS R15,0
	RJMP _0x4F
; 0000 0115                         count_1++;
	INC  R5
; 0000 0116                         if(count_1==5)    fliptone();
	LDI  R30,LOW(5)
	CP   R30,R5
	BRNE _0x50
	RCALL _fliptone
; 0000 0117                         send_tone(tone);
_0x50:
	RCALL SUBOPT_0x9
; 0000 0118                 }
; 0000 0119                 if(!x)  fliptone();
_0x4F:
	SBRS R15,0
	RCALL _fliptone
; 0000 011A                 j--;
	__SUBWRN 16,17,1
; 0000 011B         }
	RJMP _0x4C
_0x4E:
; 0000 011C }
_0x2000001:
	RCALL __LOADLOCR2
	ADIW R28,3
	POP  R15
	RET
;
;void calc_fcs(char in) {
; 0000 011E void calc_fcs(char in) {
_calc_fcs:
; 0000 011F 	int i;
; 0000 0120  	fcs_arr += in;
	RCALL __SAVELOCR2
;	in -> Y+2
;	i -> R16,R17
	LDD  R30,Y+2
	RCALL SUBOPT_0x1C
	RCALL SUBOPT_0x1D
	RCALL __CWD1
	RCALL __ADDD12
	RCALL SUBOPT_0x1E
; 0000 0121   	x_counter++;
	INC  R4
; 0000 0122 
; 0000 0123    	if(crc_flag) {
	SBIS 0x13,1
	RJMP _0x52
; 0000 0124       	 	for(i=0;i<16;i++) {
	RCALL SUBOPT_0x0
_0x54:
	__CPWRN 16,17,16
	BRGE _0x55
; 0000 0125                 	if((fcs_arr >> 16)==1) {
	RCALL SUBOPT_0x1F
	BRNE _0x56
; 0000 0126       	 			fcs_arr ^= CONST_POLYNOM;
	RCALL SUBOPT_0x20
; 0000 0127                         }
; 0000 0128           		fcs_arr <<= 1;
_0x56:
	RCALL SUBOPT_0x21
; 0000 0129           	}
	RCALL SUBOPT_0x3
	RJMP _0x54
_0x55:
; 0000 012A           	fcshi = fcs_arr >> 8; 		// ambil 8 bit paling kiri
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(8)
	RCALL __ASRD12
	MOV  R3,R30
; 0000 012B        		fcslo = fcs_arr & 0b11111111; 	// ambil 8 bit paling kanan
	LDS  R30,_fcs_arr
	MOV  R2,R30
; 0000 012C     	}
; 0000 012D 
; 0000 012E      	if((x_counter==17) && ((fcs_arr >> 16)==1)) {
_0x52:
	LDI  R30,LOW(17)
	CP   R30,R4
	BRNE _0x58
	RCALL SUBOPT_0x1F
	BREQ _0x59
_0x58:
	RJMP _0x57
_0x59:
; 0000 012F          	fcs_arr ^= CONST_POLYNOM;
	RCALL SUBOPT_0x20
; 0000 0130                 x_counter -= 1;
	RCALL SUBOPT_0x22
; 0000 0131       	}
; 0000 0132 
; 0000 0133         if(x_counter==17) {
_0x57:
	LDI  R30,LOW(17)
	CP   R30,R4
	BRNE _0x5A
; 0000 0134          	x_counter -= 1;
	RCALL SUBOPT_0x22
; 0000 0135         }
; 0000 0136 
; 0000 0137        	fcs_arr <<= 1;
_0x5A:
	RCALL SUBOPT_0x21
; 0000 0138 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;
;void init_clock(void) {
; 0000 013A void init_clock(void) {
_init_clock:
; 0000 013B // Crystal Oscillator division factor: 1
; 0000 013C #pragma optsize-
; 0000 013D 	CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 013E 	CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 013F 	#ifdef _OPTIMIZE_SIZE_
; 0000 0140 #pragma optsize+
; 0000 0141 	#endif
; 0000 0142 }
	RET
;
;void init_ports(void) {
; 0000 0144 void init_ports(void) {
_init_ports:
; 0000 0145         // Port B initialization
; 0000 0146 	// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=Out Func0=Out
; 0000 0147 	// State7=T State6=T State5=T State4=T State3=0 State2=0 State1=0 State0=0
; 0000 0148 	PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
; 0000 0149 	DDRB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x17,R30
; 0000 014A 
; 0000 014B 	// Port D initialization
; 0000 014C 	// Func6=Out Func5=Out Func4=Out Func3=Out Func2=In Func1=In Func0=In
; 0000 014D 	// State6=0 State5=0 State4=0 State3=0 State2=P State1=T State0=T
; 0000 014E 	PORTD=0x04;
	LDI  R30,LOW(4)
	OUT  0x12,R30
; 0000 014F 	DDRD=0x78;
	LDI  R30,LOW(120)
	OUT  0x11,R30
; 0000 0150         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0151         DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 0152 }
	RET
;
;void main(void) {
; 0000 0154 void main(void) {
_main:
; 0000 0155         init_clock();
	RCALL _init_clock
; 0000 0156         init_ports();
	RCALL _init_ports
; 0000 0157 
; 0000 0158         L_STBY = on;
	SBI  0x12,3
; 0000 0159         delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 015A         L_STBY = off;
	CBI  0x12,3
; 0000 015B         PTT = on;
	SBI  0x12,6
; 0000 015C         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 015D         PTT = off;
	CBI  0x12,6
; 0000 015E 
; 0000 015F         while (1) {
_0x63:
; 0000 0160                 if(!TX_NOW) {
	SBIC 0x10,2
	RJMP _0x66
; 0000 0161                         delay_ms(250);
	RCALL SUBOPT_0x4
; 0000 0162                         L_STBY = off;
	CBI  0x12,3
; 0000 0163                         protocol();
	RCALL _protocol
; 0000 0164                 }
; 0000 0165                 L_STBY = on;
_0x66:
	SBI  0x12,3
; 0000 0166         };
	RJMP _0x63
; 0000 0167 }
_0x6B:
	RJMP _0x6B

	.DSEG
_destination:
	.BYTE 0x7
_source:
	.BYTE 0x7
_digi:
	.BYTE 0x7
_fcs_arr:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x0:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1:
	__CPWRN 16,17,7
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LD   R30,X
	LSL  R30
	ST   X,R30
	MOV  R26,R16
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x3:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	RJMP _send_data

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	ADD  R26,R16
	LD   R30,X
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x8:
	LDD  R26,Y+2
	LDI  R27,0
	MOV  R30,R16
	RCALL __ASRW12
	BST  R30,0
	BLD  R15,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x9:
	ST   -Y,R7
	ST   -Y,R6
	RJMP _send_tone

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xA:
	LD   R30,Y
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xE:
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(15)
	ST   -Y,R30
	RJMP _set_dac

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x10:
	__DELAY_USB 192
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x12:
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:28 WORDS
SUBOPT_0x18:
	__DELAY_USB 103
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	RJMP SUBOPT_0x18

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1C:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x1D:
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:26 WORDS
SUBOPT_0x1E:
	STS  _fcs_arr,R30
	STS  _fcs_arr+1,R31
	STS  _fcs_arr+2,R22
	STS  _fcs_arr+3,R23
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1F:
	RCALL SUBOPT_0x1D
	LDI  R30,LOW(16)
	RCALL __ASRD12
	__CPD1N 0x1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x20:
	RCALL SUBOPT_0x1D
	__GETD1N 0x11021
	RCALL __XORD12
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x21:
	LDS  R30,_fcs_arr
	LDS  R31,_fcs_arr+1
	LDS  R22,_fcs_arr+2
	LDS  R23,_fcs_arr+3
	RCALL __LSLD1
	RJMP SUBOPT_0x1E

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	MOV  R30,R4
	RCALL SUBOPT_0x1C
	SBIW R30,1
	MOV  R4,R30
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

__ADDD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	ADC  R23,R25
	RET

__XORD12:
	EOR  R30,R26
	EOR  R31,R27
	EOR  R22,R24
	EOR  R23,R25
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

__ASRD12:
	TST  R30
	MOV  R0,R30
	MOVW R30,R26
	MOVW R22,R24
	BREQ __ASRD12R
__ASRD12L:
	ASR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R0
	BRNE __ASRD12L
__ASRD12R:
	RET

__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__LSLD1:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
