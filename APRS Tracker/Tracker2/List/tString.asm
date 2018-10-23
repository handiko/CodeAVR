
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

_matrix:
	.DB  0x7,0xA,0xD,0xE,0xF,0xE,0xD,0xA
	.DB  0x7,0x5,0x2,0x1,0x0,0x1,0x2,0x5

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
;Date    : 1/21/2012
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
;#include <delay.h>
;
;#define _1200		0
;#define _2200		1
;#define CONST_1200      42
;#define CONST_2200      18
;
;#define TX_NOW  PIND.3
;#define PTT     PORTB.3
;#define DAC_0   PORTB.4
;#define DAC_1   PORTB.5
;#define DAC_2   PORTB.6
;#define DAC_3   PORTB.7
;
;#define L_TX	PORTD.4
;
;flash char flag = 0x7E;
;eeprom char string[98] =
;{ 	('A'<<1),('P'<<1),('U'<<1),('2'<<1),('5'<<1),('N'<<1),0b11100000,
;	('Y'<<1),('D'<<1),('2'<<1),('X'<<1),('B'<<1),('C'<<1),('1'<<1),
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1),
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('1'<<1),(' '<<1),0b01100011,
;
;        0x03,0xF0,0x79,
;
;        ('0'<<1),('7'<<1),('4'<<1),('5'<<1),('.'<<1),('5'<<1),('8'<<1),('S'<<1),
;        ('/'<<1),
;        ('1'<<1),('1'<<1),('0'<<1),('2'<<1),('2'<<1),('.'<<1),('2'<<1),('2'<<1),('E'<<1),
;
;        ('$'<<1),
;
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),('-'<<1),('2'<<1),(' '<<1),
;        ('E'<<1),('x'<<1),('p'<<1),('e'<<1),('r'<<1),('i'<<1),('m'<<1),('e'<<1),('n'<<1),('t'<<1),('a'<<1),('l'<<1),(' '<<1),
;        ('V'<<1),('H'<<1),('F'<<1),(' '<<1),
;        ('D'<<1),('i'<<1),('g'<<1),('i'<<1),('p'<<1),('e'<<1),('a'<<1),('t'<<1),('e'<<1),('r'<<1),(' '<<1),
;        ('{'<<1),('U'<<1),('I'<<1),('V'<<1),('3'<<1),('2'<<1),('}'<<1),
;
;        0b00110100,
;        0b10101000,
;        0b00100111,
;        0b11111010,
;        0b11111001
;};
;bit tone = _1200;
;flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
;
;void send_data(void);
;void fliptone(void);
;void set_dac(char value);
;void send_tone(char nada);
;
;void tes_nada_1200(void)
; 0000 004C {	char i;

	.CSEG
_tes_nada_1200:
; 0000 004D 	int j;
; 0000 004E 	for(j=0; j<1000; j++)
	RCALL __SAVELOCR4
;	i -> R17
;	j -> R18,R19
	__GETWRN 18,19,0
_0x4:
	__CPWRN 18,19,1000
	BRGE _0x5
; 0000 004F     	{	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x7:
	CPI  R17,16
	BRSH _0x8
; 0000 0050         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 0051         		delay_us(CONST_1200);
	__DELAY_USB 155
; 0000 0052         	}
	SUBI R17,-1
	RJMP _0x7
_0x8:
; 0000 0053     	}
	__ADDWRN 18,19,1
	RJMP _0x4
_0x5:
; 0000 0054 }
	RJMP _0x2000001
;
;void tes_nada_2400(void)
; 0000 0057 {	char i;
_tes_nada_2400:
; 0000 0058 	int j;
; 0000 0059         for(j=0; j<2000; j++)
	RCALL __SAVELOCR4
;	i -> R17
;	j -> R18,R19
	__GETWRN 18,19,0
_0xA:
	__CPWRN 18,19,2000
	BRGE _0xB
; 0000 005A         {	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0xD:
	CPI  R17,16
	BRSH _0xE
; 0000 005B         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 005C                 	delay_us(CONST_2200);
	RCALL SUBOPT_0x1
; 0000 005D                 }
	SUBI R17,-1
	RJMP _0xD
_0xE:
; 0000 005E         }
	__ADDWRN 18,19,1
	RJMP _0xA
_0xB:
; 0000 005F }
_0x2000001:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0062 {	L_TX = 1;
_ext_int1_isr:
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
	SBI  0x12,4
; 0000 0063 	delay_ms(200);
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RCALL SUBOPT_0x2
; 0000 0064         PTT = 1;
	SBI  0x18,3
; 0000 0065         delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x2
; 0000 0066         send_data();
	RCALL _send_data
; 0000 0067         PTT = 0;
	CBI  0x18,3
; 0000 0068         L_TX = 0;
	CBI  0x12,4
; 0000 0069 
; 0000 006A         delay_ms(1000);
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL SUBOPT_0x2
; 0000 006B         tes_nada_1200();
	RCALL _tes_nada_1200
; 0000 006C         tes_nada_2400();
	RCALL _tes_nada_2400
; 0000 006D }
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
;void send_data(void)
; 0000 0070 {	char i;
_send_data:
	PUSH R15
; 0000 0071 	char j;
; 0000 0072         bit x;
; 0000 0073         for(i=0; i<35; i++)
	RCALL __SAVELOCR2
;	i -> R17
;	j -> R16
;	x -> R15.0
	LDI  R17,LOW(0)
_0x18:
	CPI  R17,35
	BRSH _0x19
; 0000 0074         {	for(j=0; j<8; j++)
	LDI  R16,LOW(0)
_0x1B:
	CPI  R16,8
	BRSH _0x1C
; 0000 0075         	{	x = (flag >> j) & 0x01;
	RCALL SUBOPT_0x3
; 0000 0076                 	if(x) send_tone(tone);
	SBRS R15,0
	RJMP _0x1D
	RCALL SUBOPT_0x4
; 0000 0077                         else fliptone();
	RJMP _0x1E
_0x1D:
	RCALL _fliptone
; 0000 0078                 }
_0x1E:
	SUBI R16,-1
	RJMP _0x1B
_0x1C:
; 0000 0079         }
	SUBI R17,-1
	RJMP _0x18
_0x19:
; 0000 007A 	for(i=0; i<98; i++)
	LDI  R17,LOW(0)
_0x20:
	CPI  R17,98
	BRSH _0x21
; 0000 007B         {	for(j=0; j<8; j++)
	LDI  R16,LOW(0)
_0x23:
	CPI  R16,8
	BRSH _0x24
; 0000 007C         	{	x = (string[i] >> j) & 0x01;
	MOV  R26,R17
	LDI  R27,0
	SUBI R26,LOW(-_string)
	SBCI R27,HIGH(-_string)
	RCALL __EEPROMRDB
	RCALL SUBOPT_0x5
	MOVW R26,R30
	MOV  R30,R16
	RCALL __ASRW12
	BST  R30,0
	BLD  R15,0
; 0000 007D                 	if(x) send_tone(tone);
	SBRS R15,0
	RJMP _0x25
	RCALL SUBOPT_0x4
; 0000 007E                         else fliptone();
	RJMP _0x26
_0x25:
	RCALL _fliptone
; 0000 007F                 }
_0x26:
	SUBI R16,-1
	RJMP _0x23
_0x24:
; 0000 0080         }
	SUBI R17,-1
	RJMP _0x20
_0x21:
; 0000 0081         for(i=0; i<12; i++)
	LDI  R17,LOW(0)
_0x28:
	CPI  R17,12
	BRSH _0x29
; 0000 0082         {	for(j=0; j<8; j++)
	LDI  R16,LOW(0)
_0x2B:
	CPI  R16,8
	BRSH _0x2C
; 0000 0083         	{	x = (flag >> j) & 0x01;
	RCALL SUBOPT_0x3
; 0000 0084                 	if(x) send_tone(tone);
	SBRS R15,0
	RJMP _0x2D
	RCALL SUBOPT_0x4
; 0000 0085                         else fliptone();
	RJMP _0x2E
_0x2D:
	RCALL _fliptone
; 0000 0086                 }
_0x2E:
	SUBI R16,-1
	RJMP _0x2B
_0x2C:
; 0000 0087         }
	SUBI R17,-1
	RJMP _0x28
_0x29:
; 0000 0088 }
	RCALL __LOADLOCR2P
	POP  R15
	RET
;
;void fliptone(void)
; 0000 008B {	if(tone == _1200)
_fliptone:
	SBIC 0x13,0
	RJMP _0x2F
; 0000 008C         {	tone = _2200;
	SBI  0x13,0
; 0000 008D         	send_tone(tone);
	RJMP _0x4C
; 0000 008E         }
; 0000 008F         else
_0x2F:
; 0000 0090         {	tone = _1200;
	CBI  0x13,0
; 0000 0091         	send_tone(tone);
_0x4C:
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _send_tone
; 0000 0092         }
; 0000 0093 }
	RET
;
;void set_dac(char value)
; 0000 0096 {	DAC_0 = value & 0x01;
_set_dac:
;	value -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x35
	CBI  0x18,4
	RJMP _0x36
_0x35:
	SBI  0x18,4
_0x36:
; 0000 0097         DAC_1 =( value >> 1 ) & 0x01;
	LD   R30,Y
	RCALL SUBOPT_0x5
	ASR  R31
	ROR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x37
	CBI  0x18,5
	RJMP _0x38
_0x37:
	SBI  0x18,5
_0x38:
; 0000 0098         DAC_2 =( value >> 2 ) & 0x01;
	LD   R30,Y
	RCALL SUBOPT_0x5
	RCALL __ASRW2
	ANDI R30,LOW(0x1)
	BRNE _0x39
	CBI  0x18,6
	RJMP _0x3A
_0x39:
	SBI  0x18,6
_0x3A:
; 0000 0099         DAC_3 =( value >> 3 ) & 0x01;
	LD   R30,Y
	RCALL SUBOPT_0x5
	RCALL __ASRW3
	ANDI R30,LOW(0x1)
	BRNE _0x3B
	CBI  0x18,7
	RJMP _0x3C
_0x3B:
	SBI  0x18,7
_0x3C:
; 0000 009A }
	ADIW R28,1
	RET
;
;void send_tone(char nada)
; 0000 009D {	char i;
_send_tone:
; 0000 009E 	if(nada == _1200)
	ST   -Y,R17
;	nada -> Y+1
;	i -> R17
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x3D
; 0000 009F     	{	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x3F:
	CPI  R17,16
	BRSH _0x40
; 0000 00A0         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 00A1         		delay_us(CONST_1200);
	__DELAY_USB 155
; 0000 00A2         	}
	SUBI R17,-1
	RJMP _0x3F
_0x40:
; 0000 00A3     	}
; 0000 00A4     	else
	RJMP _0x41
_0x3D:
; 0000 00A5     	{	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x43:
	CPI  R17,16
	BRSH _0x44
; 0000 00A6         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 00A7         		delay_us(CONST_2200);
	RCALL SUBOPT_0x1
; 0000 00A8         	}
	SUBI R17,-1
	RJMP _0x43
_0x44:
; 0000 00A9                 for(i=0; i<15; i++)
	LDI  R17,LOW(0)
_0x46:
	CPI  R17,15
	BRSH _0x47
; 0000 00AA         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 00AB         		delay_us(CONST_2200);
	RCALL SUBOPT_0x1
; 0000 00AC         	}
	SUBI R17,-1
	RJMP _0x46
_0x47:
; 0000 00AD     	}
_0x41:
; 0000 00AE }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void main(void)
; 0000 00B1 {
_main:
; 0000 00B2 #pragma optsize-
; 0000 00B3 	CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00B4 	CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00B5 	#ifdef _OPTIMIZE_SIZE_
; 0000 00B6 #pragma optsize+
; 0000 00B7 	#endif
; 0000 00B8 
; 0000 00B9 	PORTB=0x00;
	OUT  0x18,R30
; 0000 00BA 	DDRB=0xF8;
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 00BB 	PORTD=0x01;
	LDI  R30,LOW(1)
	OUT  0x12,R30
; 0000 00BC 	DDRD=0x70;
	LDI  R30,LOW(112)
	OUT  0x11,R30
; 0000 00BD 
; 0000 00BE         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00BF         DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 00C0 
; 0000 00C1 	GIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x3B,R30
; 0000 00C2 	MCUCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0000 00C3 	EIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 00C4 
; 0000 00C5         #asm("sei")
	sei
; 0000 00C6 
; 0000 00C7 	while (1)
_0x48:
; 0000 00C8       	{
; 0000 00C9       	}
	RJMP _0x48
; 0000 00CA }
_0x4B:
	RJMP _0x4B

	.ESEG
_string:
	.DB  LOW(0x64AAA082),HIGH(0x64AAA082),BYTE3(0x64AAA082),BYTE4(0x64AAA082)
	.DB  LOW(0xB2E09C6A),HIGH(0xB2E09C6A),BYTE3(0xB2E09C6A),BYTE4(0xB2E09C6A)
	.DB  LOW(0x84B06488),HIGH(0x84B06488),BYTE3(0x84B06488),BYTE4(0x84B06488)
	.DB  LOW(0x92AE6286),HIGH(0x92AE6286),BYTE3(0x92AE6286),BYTE4(0x92AE6286)
	.DB  LOW(0x40648A88),HIGH(0x40648A88),BYTE3(0x40648A88),BYTE4(0x40648A88)
	.DB  LOW(0x8892AE64),HIGH(0x8892AE64),BYTE3(0x8892AE64),BYTE4(0x8892AE64)
	.DB  LOW(0x6340628A),HIGH(0x6340628A),BYTE3(0x6340628A),BYTE4(0x6340628A)
	.DB  LOW(0x6079F003),HIGH(0x6079F003),BYTE3(0x6079F003),BYTE4(0x6079F003)
	.DB  LOW(0x5C6A686E),HIGH(0x5C6A686E),BYTE3(0x5C6A686E),BYTE4(0x5C6A686E)
	.DB  LOW(0x5EA6706A),HIGH(0x5EA6706A),BYTE3(0x5EA6706A),BYTE4(0x5EA6706A)
	.DB  LOW(0x64606262),HIGH(0x64606262),BYTE3(0x64606262),BYTE4(0x64606262)
	.DB  LOW(0x64645C64),HIGH(0x64645C64),BYTE3(0x64645C64),BYTE4(0x64645C64)
	.DB  LOW(0x92AE488A),HIGH(0x92AE488A),BYTE3(0x92AE488A),BYTE4(0x92AE488A)
	.DB  LOW(0x5A648A88),HIGH(0x5A648A88),BYTE3(0x5A648A88),BYTE4(0x5A648A88)
	.DB  LOW(0xF08A4064),HIGH(0xF08A4064),BYTE3(0xF08A4064),BYTE4(0xF08A4064)
	.DB  LOW(0xD2E4CAE0),HIGH(0xD2E4CAE0),BYTE3(0xD2E4CAE0),BYTE4(0xD2E4CAE0)
	.DB  LOW(0xE8DCCADA),HIGH(0xE8DCCADA),BYTE3(0xE8DCCADA),BYTE4(0xE8DCCADA)
	.DB  LOW(0xAC40D8C2),HIGH(0xAC40D8C2),BYTE3(0xAC40D8C2),BYTE4(0xAC40D8C2)
	.DB  LOW(0x88408C90),HIGH(0x88408C90),BYTE3(0x88408C90),BYTE4(0x88408C90)
	.DB  LOW(0xE0D2CED2),HIGH(0xE0D2CED2),BYTE3(0xE0D2CED2),BYTE4(0xE0D2CED2)
	.DB  LOW(0xCAE8C2CA),HIGH(0xCAE8C2CA),BYTE3(0xCAE8C2CA),BYTE4(0xCAE8C2CA)
	.DB  LOW(0xAAF640E4),HIGH(0xAAF640E4),BYTE3(0xAAF640E4),BYTE4(0xAAF640E4)
	.DB  LOW(0x6466AC92),HIGH(0x6466AC92),BYTE3(0x6466AC92),BYTE4(0x6466AC92)
	.DB  LOW(0x27A834FA),HIGH(0x27A834FA),BYTE3(0x27A834FA),BYTE4(0x27A834FA)
	.DW  0xF9FA

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:30 WORDS
SUBOPT_0x0:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_matrix*2)
	SBCI R31,HIGH(-_matrix*2)
	LPM  R30,Z
	ST   -Y,R30
	RJMP _set_dac

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1:
	__DELAY_USB 66
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	MOV  R30,R16
	LDI  R26,LOW(126)
	RCALL __LSRB12
	BST  R30,0
	BLD  R15,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	ST   -Y,R30
	RJMP _send_tone

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	LDI  R31,0
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

__LSRB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSRB12R
__LSRB12L:
	LSR  R30
	DEC  R0
	BRNE __LSRB12L
__LSRB12R:
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

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
