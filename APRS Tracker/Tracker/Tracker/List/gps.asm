
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
	.DEF _crc=R2

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
	RJMP _ext_int1_isr
	RJMP 0x00
	RJMP 0x00
	RJMP _timer1_ovf_isr
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

_matrix:
	.DB  0x7,0xA,0xD,0xE,0xF,0xE,0xD,0xA
	.DB  0x7,0x5,0x2,0x1,0x0,0x1,0x2,0x5
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

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
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;© Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project :
;Version :
;Date    : 9/29/2012
;Author  :
;Company :
;Comments:
;
;
;Chip type               : ATtiny2313
;AVR Core Clock frequency: 11.059200 MHz
;Memory model            : Tiny
;External RAM size       : 0
;Data Stack size         : 32
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
;#include <stdio.h>
;
;#define _1200		0
;#define _2200		1
;
;#ifdef	_OPTIMIZE_SIZE_
;	#define CONST_1200      46
;	#define CONST_2200      22
;#else
;	#define CONST_1200      50
;	#define CONST_2200      25
;#endif
;
;#define GAP_TIME_	18
;#define INITIAL_TIME_C	5
;#define FWD_TIME_C	2
;#define TX_DELAY_	40
;#define FLAG_		0x7E
;#define	CONTROL_FIELD_	0x03
;#define PROTOCOL_ID_	0xF0
;#define TD_POSISI_	'!'
;#define TD_STATUS_	'>'
;#define SYM_TAB_OVL_	'/'
;#define SYM_CODE_	'l'
;#define TX_TAIL_	2
;
;#include <delay.h>
;#include <stdarg.h>
;
;#define TX_NOW  PIND.3
;#define PTT     PORTB.3
;#define DAC_0   PORTB.7
;#define DAC_1   PORTB.6
;#define DAC_2   PORTB.5
;#define DAC_3   PORTB.4
;#define L_BUSY	PORTD.5
;#define L_STBY  PORTD.4
;
;void set_dac(char value);
;void set_nada(char i_nada);
;void kirim_karakter(unsigned char input);
;void kirim_paket(void);
;void ubah_nada(void);
;void hitung_crc(char in_crc);
;void kirim_crc(void);
;void ekstrak_gps(void);
;void init_usart(void);
;void clear_usart(void);
;void timer_detik(char detik);
;
;flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
;eeprom char data_1[28] =
;{
;	('A'<<1),('P'<<1),('Z'<<1),('T'<<1),('2'<<1),('3'<<1),0b11100000,
;    ('Y'<<1),('D'<<1),('2'<<1),('X'<<1),('A'<<1),('C'<<1),('9'<<1),
;    ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('1'<<1),(' '<<1),('1'<<1),
;    ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1
;};
;eeprom char posisi_lat[8] =
;{
;	'0','7','4','5','.','3','1','S'
;};
;eeprom char posisi_long[9] =
;{
;	'1','1','0','2','2','.','5','2','E'
;};
;eeprom char data_extension[7] =
;{
;	'P','H','G','2','0','0','0'
;};
;eeprom char komentar[14] =
;{
;	'L','a','b','.','S','S','T','K',' ','T','i','m','-','1'
;
;};
;eeprom char status[47] =
;{
;	'A','T','t','i','n','y','2','3','1','3',' ',
;    'A','P','R','S',' ','t','r','a','c','k','e','r',' ',
;    'h','a','n','d','i','k','o','g','e','s','a','n','g','@','g','m','a','i','l','.','c','o','m'
;};
;eeprom char beacon_stat = 0;
;eeprom char xcount = 0;
;bit nada = _1200;
;static char bit_stuff = 0;
;unsigned short crc;
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0070 {

	.CSEG
_ext_int1_isr:
	RCALL SUBOPT_0x0
; 0000 0071     L_STBY = 0;
; 0000 0072     delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RCALL SUBOPT_0x1
; 0000 0073     kirim_paket();
	RCALL _kirim_paket
; 0000 0074     L_STBY = 1;
	SBI  0x12,4
; 0000 0075 }
	RJMP _0x76
;
;// Timer1 overflow interrupt service routine
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0079 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x0
; 0000 007A // Place your code here
; 0000 007B     L_STBY = 0;
; 0000 007C     xcount++;
	RCALL SUBOPT_0x2
	SUBI R30,-LOW(1)
	RCALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 007D     if(xcount == 1)
	RCALL SUBOPT_0x2
	CPI  R30,LOW(0x1)
	BRNE _0x9
; 0000 007E     {
; 0000 007F         kirim_paket();
	RCALL _kirim_paket
; 0000 0080     }
; 0000 0081 
; 0000 0082     else if((xcount%2) == 0)
	RJMP _0xA
_0x9:
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x3
	MOVW R26,R30
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RCALL __MODW21
	SBIW R30,0
	BRNE _0xB
; 0000 0083     {
; 0000 0084         L_BUSY = 1;
	SBI  0x12,5
; 0000 0085         ekstrak_gps();
	RCALL _ekstrak_gps
; 0000 0086         L_BUSY = 0;
	CBI  0x12,5
; 0000 0087     }
; 0000 0088 
; 0000 0089     else if(xcount == GAP_TIME_)
	RJMP _0x10
_0xB:
	RCALL SUBOPT_0x2
	CPI  R30,LOW(0x12)
	BRNE _0x11
; 0000 008A     {
; 0000 008B         xcount = 0;
	LDI  R26,LOW(_xcount)
	LDI  R27,HIGH(_xcount)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 008C     }
; 0000 008D 
; 0000 008E     L_STBY = 1;
_0x11:
_0x10:
_0xA:
	SBI  0x12,4
; 0000 008F 
; 0000 0090     timer_detik(FWD_TIME_C);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _timer_detik
; 0000 0091 }
_0x76:
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
;/***************************************************************************************/
;    void             kirim_paket(void)
; 0000 0095 /***************************************************************************************
; 0000 0096 *    ABSTRAKSI      :     pengendali urutan pengiriman data APRS
; 0000 0097 *                penyusun protokol APRS
; 0000 0098 *
; 0000 0099 *          INPUT        :    tak ada
; 0000 009A *    OUTPUT        :       kondisi LED dan output transistor switch TX
; 0000 009B *    RETURN        :       tak ada
; 0000 009C */
; 0000 009D {
_kirim_paket:
; 0000 009E     char i;
; 0000 009F 
; 0000 00A0         // inisialisasi nilai CRC dengan 0xFFFF
; 0000 00A1     crc = 0xFFFF;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R2,R30
; 0000 00A2 
; 0000 00A3         // tambahkan 1 nilai counter pancar
; 0000 00A4         beacon_stat++;
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(1)
	RCALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 00A5 
; 0000 00A6         // nyalakan LED TX dan PTT switch
; 0000 00A7     PTT = 1;
	SBI  0x18,3
; 0000 00A8 
; 0000 00A9         // tunggu 500ms
; 0000 00AA         delay_ms(500);
	RCALL SUBOPT_0x5
; 0000 00AB 
; 0000 00AC         /**********************************************************************************
; 0000 00AD 
; 0000 00AE                     APRS AX.25 PROTOCOL
; 0000 00AF 
; 0000 00B0         |------------------------------------------------------------------------
; 0000 00B1         |   opn. FLAG    |    DESTINATION    |    SOURCE    |    DIGI'S    | CONTROL...
; 0000 00B2         |---------------|-----------------------|---------------|---------------|
; 0000 00B3         |   0x7E 1Bytes |    7 Bytes        |       7 Bytes |  0 - 56 Bytes    |
; 0000 00B4         |------------------------------------------------------------------------
; 0000 00B5 
; 0000 00B6             -----------------------------------------------------------------
; 0000 00B7         DIGI'S..|    CONTROL FIELD    |    PROTOCOL ID    |    INFO    | FCS...
; 0000 00B8                 |-----------------------|-----------------------|---------------|
; 0000 00B9                 |    0x03 1 Bytes    |     0xF0 1 Bytes    |  0 - 256 Bytes|
; 0000 00BA                 -----------------------------------------------------------------
; 0000 00BB 
; 0000 00BC             --------------------------------|
; 0000 00BD         INFO... |    FCS    |   cls. FLAG    |
; 0000 00BE                 |---------------|---------------|
; 0000 00BF                 |    2 Bytes    |   0x7E 1Bytes |
; 0000 00C0                 --------------------------------|
; 0000 00C1 
; 0000 00C2         Sumber : APRS101, Tucson Amateur Packet Radio Club. www.tapr.org
; 0000 00C3         ************************************************************************************/
; 0000 00C4 
; 0000 00C5         // kirim karakter opening flag
; 0000 00C6         for(i=0;i<TX_DELAY_;i++)
	LDI  R17,LOW(0)
_0x17:
	CPI  R17,40
	BRSH _0x18
; 0000 00C7             kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x6
	SUBI R17,-1
	RJMP _0x17
_0x18:
; 0000 00CA bit_stuff = 0;
	RCALL SUBOPT_0x7
; 0000 00CB 
; 0000 00CC         // kirimkan field : destination, source, PATH 1, PATH 2, control, Protocol ID, dan
; 0000 00CD             // data type ID
; 0000 00CE         for(i=0;i<28;i++)
	LDI  R17,LOW(0)
_0x1A:
	CPI  R17,28
	BRSH _0x1B
; 0000 00CF             kirim_karakter(data_1[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_data_1)
	SBCI R27,HIGH(-_data_1)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x1A
_0x1B:
; 0000 00D2 kirim_karakter(0x03);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x6
; 0000 00D3 
; 0000 00D4         // krimkan protocol ID
; 0000 00D5         kirim_karakter(PROTOCOL_ID_);
	LDI  R30,LOW(240)
	RCALL SUBOPT_0x6
; 0000 00D6 
; 0000 00D7         // jika sudah 20 kali memancar,
; 0000 00D8         if(beacon_stat == 20)
	RCALL SUBOPT_0x4
	CPI  R30,LOW(0x14)
	BRNE _0x1C
; 0000 00D9         {
; 0000 00DA             // jika ya
; 0000 00DB                 // kirim tipe data status
; 0000 00DC                 kirim_karakter(TD_STATUS_);
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x6
; 0000 00DD 
; 0000 00DE                 // kirim teks status
; 0000 00DF                 for(i=0;i<47;i++)
	LDI  R17,LOW(0)
_0x1E:
	CPI  R17,47
	BRSH _0x1F
; 0000 00E0                     kirim_karakter(status[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_status)
	SBCI R27,HIGH(-_status)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x1E
_0x1F:
; 0000 00E3 beacon_stat = 0;
	LDI  R26,LOW(_beacon_stat)
	LDI  R27,HIGH(_beacon_stat)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 00E4 
; 0000 00E5                 // lompat ke kirim crc
; 0000 00E6                 goto lompat;
	RJMP _0x20
; 0000 00E7         }
; 0000 00E8 
; 0000 00E9         // krimkan tipe data posisi
; 0000 00EA         kirim_karakter(TD_POSISI_);
_0x1C:
	LDI  R30,LOW(33)
	RCALL SUBOPT_0x6
; 0000 00EB 
; 0000 00EC         // kirimkan posisi lintang
; 0000 00ED         for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,8
	BRSH _0x23
; 0000 00EE             kirim_karakter(posisi_lat[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_posisi_lat)
	SBCI R27,HIGH(-_posisi_lat)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 00F1 kirim_karakter('/');
	LDI  R30,LOW(47)
	RCALL SUBOPT_0x6
; 0000 00F2 
; 0000 00F3         // kirimkan posisi bujur
; 0000 00F4     for(i=0;i<9;i++)
	LDI  R17,LOW(0)
_0x25:
	CPI  R17,9
	BRSH _0x26
; 0000 00F5             kirim_karakter(posisi_long[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_posisi_long)
	SBCI R27,HIGH(-_posisi_long)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x25
_0x26:
; 0000 00F8 kirim_karakter('l');
	LDI  R30,LOW(108)
	RCALL SUBOPT_0x6
; 0000 00F9 
; 0000 00FA         // hanya kirim PHGD code dan komentar pada pancaran ke-5
; 0000 00FB         if(beacon_stat == 5)
	RCALL SUBOPT_0x4
	CPI  R30,LOW(0x5)
	BRNE _0x27
; 0000 00FC         {
; 0000 00FD             // kirimkan field informasi : data ekstensi tipe PHGD
; 0000 00FE             for(i=0;i<7;i++)
	LDI  R17,LOW(0)
_0x29:
	CPI  R17,7
	BRSH _0x2A
; 0000 00FF                 kirim_karakter(data_extension[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_data_extension)
	SBCI R27,HIGH(-_data_extension)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x29
_0x2A:
; 0000 0102 for(i=0;i<14;i++)
	LDI  R17,LOW(0)
_0x2C:
	CPI  R17,14
	BRSH _0x2D
; 0000 0103                 kirim_karakter(komentar[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_komentar)
	SBCI R27,HIGH(-_komentar)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x2C
_0x2D:
; 0000 0104 }
; 0000 0105 
; 0000 0106 
; 0000 0107         // label lompatan
; 0000 0108         lompat:
_0x27:
_0x20:
; 0000 0109 
; 0000 010A         // kirimkan field : FCS (CRC-16 CCITT)
; 0000 010B         kirim_crc();
	RCALL _kirim_crc
; 0000 010C 
; 0000 010D         // kirimkan karakter closing flag
; 0000 010E         for(i=0;i<TX_TAIL_;i++)
	LDI  R17,LOW(0)
_0x2F:
	CPI  R17,2
	BRSH _0x30
; 0000 010F             kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x6
	SUBI R17,-1
	RJMP _0x2F
_0x30:
; 0000 0112 PORTB.3 = 0;
	CBI  0x18,3
; 0000 0113 
; 0000 0114 
; 0000 0115 }       // EndOf void kirim_paket(void)
	LD   R17,Y+
	RET
;
;
;/***************************************************************************************/
;    void             kirim_crc(void)
; 0000 011A /***************************************************************************************
; 0000 011B *    ABSTRAKSI      :     Pengendali urutan pengiriman data CRC-16 CCITT Penyusun
; 0000 011C *                nilai 8 MSB dan 8 LSB dari nilai CRC yang telah dihitung.
; 0000 011D *                Generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
; 0000 011E *                leading one.
; 0000 011F *
; 0000 0120 *          INPUT        :    tak ada
; 0000 0121 *    OUTPUT        :       tak ada
; 0000 0122 *    RETURN        :       tak ada
; 0000 0123 */
; 0000 0124 {
_kirim_crc:
; 0000 0125     static unsigned char crc_lo;
; 0000 0126     static unsigned char crc_hi;
; 0000 0127 
; 0000 0128         // Exor-kan nilai CRC terakhir dengan 0xFF, masukkan ke 8 LSB
; 0000 0129         crc_lo = crc ^ 0xFF;
	LDI  R30,LOW(255)
	EOR  R30,R2
	STS  _crc_lo_S0000003000,R30
; 0000 012A 
; 0000 012B         // geser kanan 8 bit dan Exor-kan nilai CRC terakhir dengan 0xFF, masukkan ke 8 MSB
; 0000 012C         crc_hi = (crc >> 8) ^ 0xFF;
	MOV  R30,R3
	ANDI R31,HIGH(0x0)
	LDI  R26,LOW(255)
	EOR  R30,R26
	STS  _crc_hi_S0000003000,R30
; 0000 012D 
; 0000 012E         // kirim 8 LSB
; 0000 012F         kirim_karakter(crc_lo);
	LDS  R30,_crc_lo_S0000003000
	RCALL SUBOPT_0x6
; 0000 0130 
; 0000 0131         // kirim 8 MSB
; 0000 0132         kirim_karakter(crc_hi);
	LDS  R30,_crc_hi_S0000003000
	RCALL SUBOPT_0x6
; 0000 0133 
; 0000 0134 }       // EndOf void kirim_crc(void)
	RET
;
;
;/***************************************************************************************/
;    void             kirim_karakter(unsigned char input)
; 0000 0139 /***************************************************************************************
; 0000 013A *    ABSTRAKSI      :     mengirim data APRS karakter-demi-karakter, menghitung FCS
; 0000 013B *                field dan melakukan bit stuffing. Polarisasi data adalah
; 0000 013C *                NRZI (Non Return to Zero, Inverted). Bit dikirimkan sebagai
; 0000 013D *                bit terakhir yang ditahan jika bit masukan adalah bit 1.
; 0000 013E *                Bit dikirimkan sebagai bit terakhir yang di-invert jika bit
; 0000 013F *                masukan adalah bit 0. Tone 1200Hz dan 2200Hz masing - masing
; 0000 0140 *                 merepresentasikan bit 0 dan 1 atau sebaliknya. Polarisasi
; 0000 0141 *                tone adalah tidak penting dalam polarisasi data NRZI.
; 0000 0142 *
; 0000 0143 *          INPUT        :    byte data protokol APRS
; 0000 0144 *    OUTPUT        :       tak ada
; 0000 0145 *    RETURN        :       tak ada
; 0000 0146 */
; 0000 0147 {
_kirim_karakter:
	PUSH R15
; 0000 0148     char i;
; 0000 0149     bit in_bit;
; 0000 014A 
; 0000 014B         // kirimkan setiap byte data (8 bit)
; 0000 014C     for(i=0;i<8;i++)
	ST   -Y,R17
;	input -> Y+1
;	i -> R17
;	in_bit -> R15.0
	LDI  R17,LOW(0)
_0x34:
	CPI  R17,8
	BRSH _0x35
; 0000 014D         {
; 0000 014E             // ambil 1 bit berurutan dari LSB ke MSB setiap perulangan for 0 - 7
; 0000 014F                 in_bit = (input >> i) & 0x01;
	LDD  R26,Y+1
	LDI  R27,0
	MOV  R30,R17
	RCALL __ASRW12
	BST  R30,0
	BLD  R15,0
; 0000 0150 
; 0000 0151                 // jika data adalah flag, nol-kan pengingat bit stuffing
; 0000 0152                 if(input==0x7E)    {bit_stuff = 0;}
	LDD  R26,Y+1
	CPI  R26,LOW(0x7E)
	BRNE _0x36
	RCALL SUBOPT_0x7
; 0000 0153 
; 0000 0154                 // jika bukan flag, hitung nilai CRC dari bit data saat ini
; 0000 0155                 else        {hitung_crc(in_bit);}
	RJMP _0x37
_0x36:
	LDI  R30,0
	SBRC R15,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _hitung_crc
_0x37:
; 0000 0156 
; 0000 0157                 // jika bit data saat ini adalah
; 0000 0158                 // nol
; 0000 0159                 if(!in_bit)
	SBRS R15,0
; 0000 015A                 {    // jika ya
; 0000 015B                     // ubah tone dan bentuk gelombang sinus
; 0000 015C                         ubah_nada();
	RJMP _0x74
; 0000 015D 
; 0000 015E                         // nol-kan pengingat bit stuffing
; 0000 015F                         bit_stuff = 0;
; 0000 0160                 }
; 0000 0161                 // satu
; 0000 0162                 else
; 0000 0163                 {    // jika ya
; 0000 0164                     // jaga tone dan bentuk gelombang sinus
; 0000 0165                         set_nada(nada);
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _set_nada
; 0000 0166 
; 0000 0167                         // hitung sebagai bit stuffing (bit satu berurut) tambahkan 1 nilai bit stuffing
; 0000 0168                         bit_stuff++;
	LDS  R30,_bit_stuff_G000
	SUBI R30,-LOW(1)
	STS  _bit_stuff_G000,R30
; 0000 0169 
; 0000 016A                         // jika sudah terjadi bit satu berurut sebanyak 5 kali
; 0000 016B                         if(bit_stuff==5)
	LDS  R26,_bit_stuff_G000
	CPI  R26,LOW(0x5)
	BRNE _0x3A
; 0000 016C                         {
; 0000 016D                             // kirim bit nol :
; 0000 016E                                 // ubah tone dan bentuk gelombang sinus
; 0000 016F                                 ubah_nada();
_0x74:
	RCALL _ubah_nada
; 0000 0170 
; 0000 0171                                 // nol-kan pengingat bit stuffing
; 0000 0172                                 bit_stuff = 0;
	RCALL SUBOPT_0x7
; 0000 0173 
; 0000 0174                         }
; 0000 0175                 }
_0x3A:
; 0000 0176         }
	SUBI R17,-1
	RJMP _0x34
_0x35:
; 0000 0177 
; 0000 0178 }      // EndOf void kirim_karakter(unsigned char input)
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;
;/***************************************************************************************/
;    void             hitung_crc(char in_crc)
; 0000 017D /***************************************************************************************
; 0000 017E *    ABSTRAKSI      :     menghitung nilai CRC-16 CCITT dari tiap bit data yang terkirim,
; 0000 017F *                generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
; 0000 0180 *                leading one
; 0000 0181 *
; 0000 0182 *          INPUT        :    bit data yang terkirim
; 0000 0183 *    OUTPUT        :       tak ada
; 0000 0184 *    RETURN        :       tak ada
; 0000 0185 */
; 0000 0186 {
_hitung_crc:
; 0000 0187     static unsigned short xor_in;
; 0000 0188 
; 0000 0189         // simpan nilai Exor dari CRC sementara dengan bit data yang baru terkirim
; 0000 018A     xor_in = crc ^ in_crc;
;	in_crc -> Y+0
	RCALL SUBOPT_0xA
	EOR  R30,R2
	EOR  R31,R3
	STS  _xor_in_S0000005000,R30
	STS  _xor_in_S0000005000+1,R31
; 0000 018B 
; 0000 018C         // geser kanan nilai CRC sebanyak 1 bit
; 0000 018D     crc >>= 1;
	LSR  R3
	ROR  R2
; 0000 018E 
; 0000 018F         // jika hasil nilai Exor di-and-kan dengan satu bernilai satu
; 0000 0190         if(xor_in & 0x01)
	LDS  R30,_xor_in_S0000005000
	ANDI R30,LOW(0x1)
	BREQ _0x3B
; 0000 0191             // maka nilai CRC di-Exor-kan dengan generator polinomial
; 0000 0192                 crc ^= 0x8408;
	LDI  R30,LOW(33800)
	LDI  R31,HIGH(33800)
	__EORWRR 2,3,30,31
; 0000 0193 
; 0000 0194 }      // EndOf void hitung_crc(char in_crc)
_0x3B:
	RJMP _0x2060002
;
;
;/***************************************************************************************/
;    void             ubah_nada(void)
; 0000 0199 /***************************************************************************************
; 0000 019A *    ABSTRAKSI      :     Menukar seting tone terakhir dengan tone yang baru. Tone
; 0000 019B *                1200Hz dan 2200Hz masing - masing merepresentasikan bit
; 0000 019C *                0 dan 1 atau sebaliknya. Polarisasi tone adalah tidak
; 0000 019D *                penting dalam polarisasi data NRZI.
; 0000 019E *
; 0000 019F *          INPUT        :    tak ada
; 0000 01A0 *    OUTPUT        :       tak ada
; 0000 01A1 *    RETURN        :       tak ada
; 0000 01A2 */
; 0000 01A3 {
_ubah_nada:
; 0000 01A4     // jika tone terakhir adalah :
; 0000 01A5         // 1200Hz
; 0000 01A6         if(nada ==_1200)
	SBIC 0x13,0
	RJMP _0x3C
; 0000 01A7     {    // jika ya
; 0000 01A8             // ubah tone saat ini menjadi 2200Hz
; 0000 01A9                 nada = _2200;
	SBI  0x13,0
; 0000 01AA 
; 0000 01AB                 // bangkitkan gelombang sinus 2200Hz
; 0000 01AC             set_nada(nada);
	RJMP _0x75
; 0000 01AD     }
; 0000 01AE         // 2200Hz
; 0000 01AF         else
_0x3C:
; 0000 01B0         {    // jika ya
; 0000 01B1             // ubah tone saat ini menjadi 1200Hz
; 0000 01B2                 nada = _1200;
	CBI  0x13,0
; 0000 01B3 
; 0000 01B4                 // bangkitkan gelombang sinus 1200Hz
; 0000 01B5             set_nada(nada);
_0x75:
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _set_nada
; 0000 01B6         }
; 0000 01B7 
; 0000 01B8 }       // EndOf void ubah_nada(void)
	RET
;
;
;/***************************************************************************************/
;    void             set_dac(char value)
; 0000 01BD /***************************************************************************************
; 0000 01BE *    ABSTRAKSI      :     Men-set dan reset output DAC sebagai bilangan biner yang
; 0000 01BF *                merepresentasikan nilai diskrit dari gelombang sinus yang
; 0000 01C0 *                sedang dibentuk saat ini sehingga membentuk tegangan sampling
; 0000 01C1 *                dari gelombang.
; 0000 01C2 *
; 0000 01C3 *          INPUT        :    nilai matrix rekonstruksi diskrit gelombang sinusoid
; 0000 01C4 *    OUTPUT        :       DAC 0 - 3, tegangan kontinyu pada output Low Pass Filter
; 0000 01C5 *    RETURN        :       tak ada
; 0000 01C6 */
; 0000 01C7 {
_set_dac:
; 0000 01C8     // ambil nilai LSB dari matrix rekonstruksi dan set sebagai DAC-0
; 0000 01C9         DAC_0 = value & 0x01;
;	value -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x42
	CBI  0x18,7
	RJMP _0x43
_0x42:
	SBI  0x18,7
_0x43:
; 0000 01CA 
; 0000 01CB         // ambil nilai dari matrix rekonstruksi, geser kanan 1 bit, ambil bit paling kanan
; 0000 01CC             // dan set sebagai DAC-1
; 0000 01CD         DAC_1 =( value >> 1 ) & 0x01;
	RCALL SUBOPT_0xA
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x44
	CBI  0x18,6
	RJMP _0x45
_0x44:
	SBI  0x18,6
_0x45:
; 0000 01CE 
; 0000 01CF         // ambil nilai dari matrix rekonstruksi, geser kanan 2 bit, ambil bit paling kanan
; 0000 01D0             // dan set sebagai DAC-2
; 0000 01D1         DAC_2 =( value >> 2 ) & 0x01;
	RCALL SUBOPT_0xA
	RCALL __ASRW2
	ANDI R30,LOW(0x1)
	BRNE _0x46
	CBI  0x18,5
	RJMP _0x47
_0x46:
	SBI  0x18,5
_0x47:
; 0000 01D2 
; 0000 01D3         // ambil nilai dari matrix rekonstruksi, geser kanan 3 bit, ambil bit tersebut dan
; 0000 01D4             // set sebagai DAC-3 (MSB)
; 0000 01D5         DAC_3 =( value >> 3 ) & 0x01;
	RCALL SUBOPT_0xA
	RCALL __ASRW3
	ANDI R30,LOW(0x1)
	BRNE _0x48
	CBI  0x18,4
	RJMP _0x49
_0x48:
	SBI  0x18,4
_0x49:
; 0000 01D6 
; 0000 01D7 }          // EndOf void set_dac(char value)
_0x2060002:
	ADIW R28,1
	RET
;
;
;/***************************************************************************************/
;    void             set_nada(char i_nada)
; 0000 01DC /***************************************************************************************
; 0000 01DD *    ABSTRAKSI      :     Membentuk baudrate serta frekensi tone 1200Hz dan 2200Hz
; 0000 01DE *                dari konstanta waktu. Men-setting nilai DAC. Lakukan fine
; 0000 01DF *                tuning pada jumlah masing - masing perulangan for dan
; 0000 01E0 *                konstanta waktu untuk meng-adjust parameter baudrate dan
; 0000 01E1 *                frekuensi tone.
; 0000 01E2 *
; 0000 01E3 *          INPUT        :    nilai frekuensi tone yang akan ditransmisikan
; 0000 01E4 *    OUTPUT        :       nilai DAC
; 0000 01E5 *    RETURN        :       tak ada
; 0000 01E6 */
; 0000 01E7 {
_set_nada:
; 0000 01E8     char i;
; 0000 01E9 
; 0000 01EA         // jika frekuensi tone yang akan segera dipancarkan adalah :
; 0000 01EB         // 1200Hz
; 0000 01EC     if(i_nada == _1200)
	ST   -Y,R17
;	i_nada -> Y+1
;	i -> R17
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x4A
; 0000 01ED         {
; 0000 01EE             // jika ya
; 0000 01EF             for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x4C:
	CPI  R17,16
	BRSH _0x4D
; 0000 01F0             {
; 0000 01F1                     // set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 01F2                         // dan urutan perulangan for 0 - 15
; 0000 01F3                     set_dac(matrix[i]);
	RCALL SUBOPT_0xB
; 0000 01F4 
; 0000 01F5                         // bangkitkan frekuensi 1200Hz dari konstanta waktu
; 0000 01F6                 delay_us(CONST_1200);
	__DELAY_USB 170
; 0000 01F7             }
	SUBI R17,-1
	RJMP _0x4C
_0x4D:
; 0000 01F8         }
; 0000 01F9         // 2200Hz
; 0000 01FA         else
	RJMP _0x4E
_0x4A:
; 0000 01FB         {
; 0000 01FC             // jika ya
; 0000 01FD             for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x50:
	CPI  R17,16
	BRSH _0x51
; 0000 01FE             {
; 0000 01FF                     // set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 0200                         // dan urutan perulangan for 0 - 15
; 0000 0201                     set_dac(matrix[i]);
	RCALL SUBOPT_0xB
; 0000 0202 
; 0000 0203                         // bangkitkan frekuensi 2200Hz dari konstanta waktu
; 0000 0204                     delay_us(CONST_2200);
	__DELAY_USB 81
; 0000 0205                 }
	SUBI R17,-1
	RJMP _0x50
_0x51:
; 0000 0206                 // sekali lagi, untuk mengatur baudrate lakukan fine tune pada jumlah for
; 0000 0207                 for(i=0; i<13; i++)
	LDI  R17,LOW(0)
_0x53:
	CPI  R17,13
	BRSH _0x54
; 0000 0208                 {
; 0000 0209                     // set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 020A                         // dan urutan perulangan for
; 0000 020B                     set_dac(matrix[i]);
	RCALL SUBOPT_0xB
; 0000 020C 
; 0000 020D                         // bangkitkan frekuensi 2200Hz dari konstanta waktu
; 0000 020E                     delay_us(CONST_2200);
	__DELAY_USB 81
; 0000 020F                 }
	SUBI R17,-1
	RJMP _0x53
_0x54:
; 0000 0210         }
_0x4E:
; 0000 0211 
; 0000 0212 }     // EndOf void set_nada(char i_nada)
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;
;/***************************************************************************************/
;    void             getComma(void)
; 0000 0217 /***************************************************************************************
; 0000 0218 *    ABSTRAKSI      :     Menunggu data RX serial berupa karakter koma dan segera
; 0000 0219 *                kembali pada fungsi yang memanggilnya.
; 0000 021A *
; 0000 021B *          INPUT        :    RX data serial $GPGLL gps
; 0000 021C *    OUTPUT        :       tak ada
; 0000 021D *    RETURN        :       tak ada
; 0000 021E */
; 0000 021F {
_getComma:
; 0000 0220     // jika data yang diterima bukan karakter koma, terima terus
; 0000 0221             // jika data yang diterima adalah koma, keluar
; 0000 0222         while(getchar() != ',');
_0x55:
	RCALL _getchar
	CPI  R30,LOW(0x2C)
	BRNE _0x55
; 0000 0223 
; 0000 0224 }          // EndOf void getComma(void)
	RET
;
;
;/***************************************************************************************/
;    void             ekstrak_gps(void)
; 0000 0229 /***************************************************************************************
; 0000 022A *    ABSTRAKSI      :     Menunggu interupsi RX data serial dari USART, memparsing
; 0000 022B *                data $GPGLL yang diterima menjadi data posisi, dan mengupdate
; 0000 022C *                data variabel posisi.
; 0000 022D *
; 0000 022E *          INPUT        :    RX data serial $GPGLL gps
; 0000 022F *    OUTPUT        :       tak ada
; 0000 0230 *    RETURN        :       tak ada
; 0000 0231 */
; 0000 0232 {
_ekstrak_gps:
; 0000 0233     int i;
; 0000 0234         static char buff_posisi[17];
; 0000 0235 
; 0000 0236         // aktifkan USART param. : 4800baudrate, 8, N, 1
; 0000 0237         init_usart();
	RCALL __SAVELOCR2
;	i -> R16,R17
	RCALL _init_usart
; 0000 0238 
; 0000 0239         /************************************************************************************************
; 0000 023A             $GPGLL - GLL - Geographic Position Latitude / Longitude
; 0000 023B 
; 0000 023C                 Contoh : $GPGLL,3723.2475,N,12158.3416,W,161229.487,A*2C
; 0000 023D 
; 0000 023E         |-----------------------------------------------------------------------------------------------|
; 0000 023F         |    Nama        |     Contoh        |        Deskripsi            |
; 0000 0240         |-----------------------|-----------------------|-----------------------------------------------|
; 0000 0241         |    Message ID    |    $GPGLL        |    header protokol GLL            |
; 0000 0242         |    Latitude    |    3723.2475    |    ddmm.mmmm     , d=degree, m=minute    |
; 0000 0243         |    N/S indicator    |    N        |    N=utara, S=selatan            |
; 0000 0244         |    Longitude    |    12158.3416    |    dddmm.mmmm    , d=degree, m=minute    |
; 0000 0245         |    W/E indicator    |    W        |    W=barat, E=timur            |
; 0000 0246         |    Waktu UTC (GMT)    |    161229.487    |    HHMMSS.SS  ,H=hour, M=minute, S=second    |
; 0000 0247         |    Status        |    A        |    A=data valid, V=data invalid        |
; 0000 0248         |    Checksum    |    *2C        |                        |
; 0000 0249         |-----------------------------------------------------------------------------------------------|
; 0000 024A 
; 0000 024B             Sumber : GPS SiRF EM-406A datasheet
; 0000 024C 
; 0000 024D         *************************************************************************************************/
; 0000 024E 
; 0000 024F         // jika data yang diterima bukan karakter $, terima terus
; 0000 0250             // jika data yang diterima adalah $, lanjutkan
; 0000 0251         while(getchar() != '$');
_0x58:
	RCALL _getchar
	CPI  R30,LOW(0x24)
	BRNE _0x58
; 0000 0252 
; 0000 0253         // tunggu dan terima data tanpa proses lebih lanjut (lewatkan karakter G)
; 0000 0254     getchar();
	RCALL _getchar
; 0000 0255 
; 0000 0256         // tunggu dan terima data tanpa proses lebih lanjut (lewatkan karakter P)
; 0000 0257         getchar();
	RCALL _getchar
; 0000 0258 
; 0000 0259         // tunggu data, jika yang diterima adalah karakter G
; 0000 025A         if(getchar() == 'R')
	RCALL _getchar
	CPI  R30,LOW(0x52)
	BREQ PC+2
	RJMP _0x5B
; 0000 025B         {
; 0000 025C             // maka
; 0000 025D             // tunggu data, jika yang diterima adalah karakter L
; 0000 025E                 if(getchar() == 'M')
	RCALL _getchar
	CPI  R30,LOW(0x4D)
	BREQ PC+2
	RJMP _0x5C
; 0000 025F             {
; 0000 0260                     // maka
; 0000 0261                         // tunggu data, jika yang diterima adalah karakter L
; 0000 0262                         if(getchar() == 'C')
	RCALL _getchar
	CPI  R30,LOW(0x43)
	BREQ PC+2
	RJMP _0x5D
; 0000 0263                     {
; 0000 0264                             // maka
; 0000 0265                                 // tunggu koma dan lanjutkan
; 0000 0266                                 getComma();
	RCALL _getComma
; 0000 0267                                 getComma();
	RCALL _getComma
; 0000 0268                                 getComma();
	RCALL _getComma
; 0000 0269 
; 0000 026A                                 // ambil 7 byte data berurut dan masukkan dalam buffer data
; 0000 026B                             for(i=0; i<7; i++)    buff_posisi[i] = getchar();
	RCALL SUBOPT_0xC
_0x5F:
	__CPWRN 16,17,7
	BRGE _0x60
	MOV  R30,R16
	SUBI R30,-LOW(_buff_posisi_S000000A000)
	PUSH R30
	RCALL _getchar
	POP  R26
	ST   X,R30
	RCALL SUBOPT_0xD
	RJMP _0x5F
_0x60:
; 0000 026E getComma();
	RCALL _getComma
; 0000 026F 
; 0000 0270                                 // ambil 1 byte data dan masukkan dalam buffer data
; 0000 0271                                 buff_posisi[7] = getchar();
	RCALL _getchar
	__PUTB1MN _buff_posisi_S000000A000,7
; 0000 0272 
; 0000 0273                                 // tunggu koma dan lanjutkan
; 0000 0274                                 getComma();
	RCALL _getComma
; 0000 0275 
; 0000 0276                                 // ambil 8 byte data berurut dan masukkan dalam buffer data
; 0000 0277                                 for(i=0; i<8; i++)	buff_posisi[i+8] = getchar();
	RCALL SUBOPT_0xC
_0x62:
	__CPWRN 16,17,8
	BRGE _0x63
	MOV  R30,R16
	__ADDB1MN _buff_posisi_S000000A000,8
	PUSH R30
	RCALL _getchar
	POP  R26
	ST   X,R30
	RCALL SUBOPT_0xD
	RJMP _0x62
_0x63:
; 0000 027A getComma();
	RCALL _getComma
; 0000 027B 
; 0000 027C                                 // ambil 1 byte data dan masukkan dalam buffer data
; 0000 027D                                 buff_posisi[16] = getchar();
	RCALL _getchar
	__PUTB1MN _buff_posisi_S000000A000,16
; 0000 027E 
; 0000 027F                                 // segera matikan USART untuk menghindari interupsi [USART_RXC]
; 0000 0280                                 clear_usart();
	RCALL _clear_usart
; 0000 0281 
; 0000 0282                                 // pindahkan data dari buffer kedalam variabel posisi
; 0000 0283                                 for(i=0;i<8;i++)	{posisi_lat[i]=buff_posisi[i];}
	RCALL SUBOPT_0xC
_0x65:
	__CPWRN 16,17,8
	BRGE _0x66
	MOVW R30,R16
	SUBI R30,LOW(-_posisi_lat)
	SBCI R31,HIGH(-_posisi_lat)
	MOVW R0,R30
	LDI  R26,LOW(_buff_posisi_S000000A000)
	ADD  R26,R16
	LD   R30,X
	MOVW R26,R0
	RCALL __EEPROMWRB
	RCALL SUBOPT_0xD
	RJMP _0x65
_0x66:
; 0000 0284         			for(i=0;i<9;i++)	{posisi_long[i]=buff_posisi[i+8];}
	RCALL SUBOPT_0xC
_0x68:
	__CPWRN 16,17,9
	BRGE _0x69
	MOVW R26,R16
	SUBI R26,LOW(-_posisi_long)
	SBCI R27,HIGH(-_posisi_long)
	MOV  R30,R16
	__ADDB1MN _buff_posisi_S000000A000,8
	LD   R30,Z
	RCALL __EEPROMWRB
	RCALL SUBOPT_0xD
	RJMP _0x68
_0x69:
; 0000 0285 
; 0000 0286                         }
; 0000 0287                 }
_0x5D:
; 0000 0288         }
_0x5C:
; 0000 0289 
; 0000 028A } 	// EndOf void ekstrak_gps(void)
_0x5B:
	RCALL __LOADLOCR2P
	RET
;
;
;/***************************************************************************************/
;	void 			init_usart(void)
; 0000 028F /***************************************************************************************
; 0000 0290 *	ABSTRAKSI  	: 	Setting parameter USART : RX only, 4800baud, 8, N, 1
; 0000 0291 *
; 0000 0292 *      	INPUT		:	tak ada
; 0000 0293 *	OUTPUT		:       tak ada
; 0000 0294 *	RETURN		:       tak ada
; 0000 0295 */
; 0000 0296 {
_init_usart:
; 0000 0297 	// set parameter 4800baud, 8, N, 1
; 0000 0298 	UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0299 	UCSRB=0x10;
	LDI  R30,LOW(16)
	OUT  0xA,R30
; 0000 029A 	UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 029B 	UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 029C 	UBRRL=0x8F;
	LDI  R30,LOW(143)
	RJMP _0x2060001
; 0000 029D 
; 0000 029E }       // EndOf void init_usart(void)
;
;
;/***************************************************************************************/
;	void 			clear_usart(void)
; 0000 02A3 /***************************************************************************************
; 0000 02A4 *	ABSTRAKSI  	: 	Me-nonaktifkan dan menghapus parameter USART
; 0000 02A5 *
; 0000 02A6 *      	INPUT		:	tak ada
; 0000 02A7 *	OUTPUT		:       tak ada
; 0000 02A8 *	RETURN		:       tak ada
; 0000 02A9 */
; 0000 02AA {
_clear_usart:
; 0000 02AB 	// hapus parameter terakhir dari USART
; 0000 02AC         UCSRA=0;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 02AD 	UCSRB=0;
	OUT  0xA,R30
; 0000 02AE 	UCSRC=0;
	OUT  0x3,R30
; 0000 02AF 	UBRRH=0;
	OUT  0x2,R30
; 0000 02B0 	UBRRL=0;
_0x2060001:
	OUT  0x9,R30
; 0000 02B1 
; 0000 02B2 }       // EndOf void clear_usart(void)
	RET
;
;
;/***************************************************************************************/
;	void 			timer_detik(char detik)
; 0000 02B7 /***************************************************************************************
; 0000 02B8 *	ABSTRAKSI  	: 	Menghitung nilai register TCNT1H dan TCNT1L dari input nilai
; 0000 02B9 *				konstanta timer dalam satuan detik. Formula untuk menghitung
; 0000 02BA *				nilai register :
; 0000 02BB *				_TCNT1 = (TCNT1H << 8) + TCNT1L
; 0000 02BC *				_TCNT1 = (1 + 0xFFFF) - (konstanta_timer_detik * (sys_clock / prescaler))
; 0000 02BD *
; 0000 02BE *      	INPUT		:	konstanta timer dalam satuan detik
; 0000 02BF *	OUTPUT		:       tak ada
; 0000 02C0 *	RETURN		:       tak ada
; 0000 02C1 */
; 0000 02C2 {
_timer_detik:
; 0000 02C3 	unsigned short _TCNT1;
; 0000 02C4 
; 0000 02C5         // hitung nilai vaiabel _TCNT1 dari nilai input berdasarkan formula :
; 0000 02C6          	// _TCNT1 = (1 + 0xFFFF) - (konstanta_timer_detik * (sys_clock / prescaler))
; 0000 02C7                 // menjadi bilangan 16 bit
; 0000 02C8 	_TCNT1 = (1 + 0xFFFF) - (detik * 10800);
	RCALL __SAVELOCR2
;	detik -> Y+2
;	_TCNT1 -> R16,R17
	LDD  R26,Y+2
	LDI  R27,0
	LDI  R30,LOW(10800)
	LDI  R31,HIGH(10800)
	RCALL __MULW12
	RCALL __CWD1
	__GETD2N 0x10000
	RCALL __SWAPD12
	RCALL __SUBD12
	MOVW R16,R30
; 0000 02C9 
; 0000 02CA         // ambil 8 bit paling kanan dan jadikan nilai register TCNT1L
; 0000 02CB         TCNT1L = _TCNT1 & 0xFF;
	MOV  R30,R16
	OUT  0x2C,R30
; 0000 02CC 
; 0000 02CD         // ambil 8 bit paling kiri dan jadikan nilai register TCNT1H
; 0000 02CE         TCNT1H = _TCNT1 >> 8;
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	OUT  0x2D,R30
; 0000 02CF 
; 0000 02D0 }       // EndOf void timer_detik(char detik)
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;
;// Declare your global variables here
;
;void main(void)
; 0000 02D5 {
_main:
; 0000 02D6 // Declare your local variables here
; 0000 02D7 
; 0000 02D8 // Crystal Oscillator division factor: 1
; 0000 02D9 #pragma optsize-
; 0000 02DA CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 02DB CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 02DC #ifdef _OPTIMIZE_SIZE_
; 0000 02DD #pragma optsize+
; 0000 02DE #endif
; 0000 02DF 
; 0000 02E0 // set bit register PORTB
; 0000 02E1         PORTB=0x00;
	OUT  0x18,R30
; 0000 02E2 
; 0000 02E3         // set bit Data Direction Register PORTB
; 0000 02E4 	DDRB=0xF8;
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 02E5 
; 0000 02E6         // set bit register PORTD
; 0000 02E7         PORTD=0x09;
	LDI  R30,LOW(9)
	OUT  0x12,R30
; 0000 02E8 
; 0000 02E9         // set bit Data Direction Register PORTD
; 0000 02EA 	DDRD=0x30;
	LDI  R30,LOW(48)
	OUT  0x11,R30
; 0000 02EB 
; 0000 02EC         // set register Analog Comparator
; 0000 02ED         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 02EE 
; 0000 02EF         // set register EXT_IRQ_1 (External Interrupt 1 Request), Low Interrupt
; 0000 02F0 	GIMSK=0x80;
	OUT  0x3B,R30
; 0000 02F1 	MCUCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0000 02F2 	EIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 02F3 
; 0000 02F4         // set register Timer 1, System clock 10.8kHz, Timer 1 overflow
; 0000 02F5 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 02F6 
; 0000 02F7         // set konstanta waktu 5 detik sebagai awalan
; 0000 02F8         timer_detik(INITIAL_TIME_C);
	ST   -Y,R30
	RCALL _timer_detik
; 0000 02F9 
; 0000 02FA         // set interupsi timer untuk Timer 1
; 0000 02FB         TIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x39,R30
; 0000 02FC 
; 0000 02FD         // indikator awalan hardware aktif :
; 0000 02FE         // nyalakan LED busy
; 0000 02FF         L_BUSY = 1;
	SBI  0x12,5
; 0000 0300 
; 0000 0301         // tunggu 500ms
; 0000 0302         delay_ms(500);
	RCALL SUBOPT_0x5
; 0000 0303 
; 0000 0304         // nyalakan LED standby
; 0000 0305         L_STBY = 1;
	SBI  0x12,4
; 0000 0306 
; 0000 0307         // tunggu 500ms
; 0000 0308         delay_ms(500);
	RCALL SUBOPT_0x5
; 0000 0309 
; 0000 030A         // matikan LED busy
; 0000 030B         L_BUSY = 0;
	CBI  0x12,5
; 0000 030C 
; 0000 030D         // tunggu 500ms
; 0000 030E         delay_ms(500);
	RCALL SUBOPT_0x5
; 0000 030F 
; 0000 0310     // Global enable interrupts
; 0000 0311     #asm("sei")
	sei
; 0000 0312 
; 0000 0313     while (1)
_0x70:
; 0000 0314     {
; 0000 0315       // Place your code here
; 0000 0316 
; 0000 0317     }
	RJMP _0x70
; 0000 0318 }
_0x73:
	RJMP _0x73
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG
_getchar:
getchar0:
     sbis usr,rxc
     rjmp getchar0
     in   r30,udr
	RET

	.CSEG

	.CSEG

	.ESEG
_data_1:
	.DB  LOW(0xA8B4A082),HIGH(0xA8B4A082),BYTE3(0xA8B4A082),BYTE4(0xA8B4A082)
	.DB  LOW(0xB2E06664),HIGH(0xB2E06664),BYTE3(0xB2E06664),BYTE4(0xB2E06664)
	.DB  LOW(0x82B06488),HIGH(0x82B06488),BYTE3(0x82B06488),BYTE4(0x82B06488)
	.DB  LOW(0x92AE7286),HIGH(0x92AE7286),BYTE3(0x92AE7286),BYTE4(0x92AE7286)
	.DB  LOW(0x40628A88),HIGH(0x40628A88),BYTE3(0x40628A88),BYTE4(0x40628A88)
	.DB  LOW(0x8892AE62),HIGH(0x8892AE62),BYTE3(0x8892AE62),BYTE4(0x8892AE62)
	.DB  LOW(0x6540648A),HIGH(0x6540648A),BYTE3(0x6540648A),BYTE4(0x6540648A)
_posisi_lat:
	.DB  LOW(0x35343730),HIGH(0x35343730),BYTE3(0x35343730),BYTE4(0x35343730)
	.DB  LOW(0x5331332E),HIGH(0x5331332E),BYTE3(0x5331332E),BYTE4(0x5331332E)
_posisi_long:
	.DB  LOW(0x32303131),HIGH(0x32303131),BYTE3(0x32303131),BYTE4(0x32303131)
	.DB  LOW(0x32352E32),HIGH(0x32352E32),BYTE3(0x32352E32),BYTE4(0x32352E32)
	.DB  0x45
_data_extension:
	.DB  LOW(0x32474850),HIGH(0x32474850),BYTE3(0x32474850),BYTE4(0x32474850)
	.DW  0x3030
	.DB  0x30
_komentar:
	.DB  LOW(0x2E62614C),HIGH(0x2E62614C),BYTE3(0x2E62614C),BYTE4(0x2E62614C)
	.DB  LOW(0x4B545353),HIGH(0x4B545353),BYTE3(0x4B545353),BYTE4(0x4B545353)
	.DB  LOW(0x6D695420),HIGH(0x6D695420),BYTE3(0x6D695420),BYTE4(0x6D695420)
	.DW  0x312D
_status:
	.DB  LOW(0x69745441),HIGH(0x69745441),BYTE3(0x69745441),BYTE4(0x69745441)
	.DB  LOW(0x3332796E),HIGH(0x3332796E),BYTE3(0x3332796E),BYTE4(0x3332796E)
	.DB  LOW(0x41203331),HIGH(0x41203331),BYTE3(0x41203331),BYTE4(0x41203331)
	.DB  LOW(0x20535250),HIGH(0x20535250),BYTE3(0x20535250),BYTE4(0x20535250)
	.DB  LOW(0x63617274),HIGH(0x63617274),BYTE3(0x63617274),BYTE4(0x63617274)
	.DB  LOW(0x2072656B),HIGH(0x2072656B),BYTE3(0x2072656B),BYTE4(0x2072656B)
	.DB  LOW(0x646E6168),HIGH(0x646E6168),BYTE3(0x646E6168),BYTE4(0x646E6168)
	.DB  LOW(0x676F6B69),HIGH(0x676F6B69),BYTE3(0x676F6B69),BYTE4(0x676F6B69)
	.DB  LOW(0x6E617365),HIGH(0x6E617365),BYTE3(0x6E617365),BYTE4(0x6E617365)
	.DB  LOW(0x6D674067),HIGH(0x6D674067),BYTE3(0x6D674067),BYTE4(0x6D674067)
	.DB  LOW(0x2E6C6961),HIGH(0x2E6C6961),BYTE3(0x2E6C6961),BYTE4(0x2E6C6961)
	.DW  0x6F63
	.DB  0x6D
_beacon_stat:
	.DB  0x0
_xcount:
	.DB  0x0

	.DSEG
_bit_stuff_G000:
	.BYTE 0x1
_crc_lo_S0000003000:
	.BYTE 0x1
_crc_hi_S0000003000:
	.BYTE 0x1
_xor_in_S0000005000:
	.BYTE 0x2
_buff_posisi_S000000A000:
	.BYTE 0x11

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x0:
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
	CBI  0x12,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R26,LOW(_xcount)
	LDI  R27,HIGH(_xcount)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x3:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(_beacon_stat)
	LDI  R27,HIGH(_beacon_stat)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  _bit_stuff_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x8:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	RCALL __EEPROMRDB
	RJMP SUBOPT_0x6

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xA:
	LD   R30,Y
	RJMP SUBOPT_0x3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0xB:
	MOV  R30,R17
	RCALL SUBOPT_0x3
	SUBI R30,LOW(-_matrix*2)
	SBCI R31,HIGH(-_matrix*2)
	LPM  R30,Z
	ST   -Y,R30
	RJMP _set_dac

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xC:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0xD:
	__ADDWRN 16,17,1
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

__SUBD12:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	SBC  R23,R25
	RET

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

__ASRW3:
	ASR  R31
	ROR  R30
__ASRW2:
	ASR  R31
	ROR  R30
	ASR  R31
	ROR  R30
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__MULW12U:
	MOV  R0,R26
	MOV  R1,R27
	LDI  R24,17
	CLR  R26
	SUB  R27,R27
	RJMP __MULW12U1
__MULW12U3:
	BRCC __MULW12U2
	ADD  R26,R0
	ADC  R27,R1
__MULW12U2:
	LSR  R27
	ROR  R26
__MULW12U1:
	ROR  R31
	ROR  R30
	DEC  R24
	BRNE __MULW12U3
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

__SWAPD12:
	MOV  R1,R24
	MOV  R24,R22
	MOV  R22,R1
	MOV  R1,R25
	MOV  R25,R23
	MOV  R23,R1

__SWAPW12:
	MOV  R1,R27
	MOV  R27,R31
	MOV  R31,R1

__SWAPB12:
	MOV  R1,R26
	MOV  R26,R30
	MOV  R30,R1
	RET

__EEPROMRDB:
	SBIC EECR,EEWE
	RJMP __EEPROMRDB
	PUSH R31
	IN   R31,SREG
	CLI
	OUT  EEARL,R26
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
