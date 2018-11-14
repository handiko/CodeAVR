
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
;Promote 'char' to 'int'  : No
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
	.DEF _n=R7
	.DEF _k=R6

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

_data:
	.DB  0x82,0xA0,0xAA,0x64,0x6A,0x9C,0xE0,0xB2
	.DB  0x88,0x64,0xB0,0x84,0x86,0x62,0xAE,0x92
	.DB  0x88,0x8A,0x64,0x40,0x64,0xAE,0x92,0x88
	.DB  0x8A,0x62,0x40,0x63,0x3,0xF0,0x79,0x60
	.DB  0x6E,0x68,0x6A,0x5C,0x6A,0x70,0xA6,0x5E
	.DB  0x62,0x62,0x60,0x64,0x64,0x5C,0x64,0x64
	.DB  0x8A,0x48,0xAE,0x92,0x88,0x8A,0x64,0x5A
	.DB  0x64,0x40,0x8A,0xF0,0xE0,0xCA,0xE4,0xD2
	.DB  0xDA,0xCA,0xDC,0xE8,0xC2,0xD8,0x40,0xAC
	.DB  0x90,0x8C,0x40,0x88,0xD2,0xCE,0xD2,0xE0
	.DB  0xCA,0xC2,0xE8,0xCA,0xE4,0x40,0xF6,0xAA
	.DB  0x92,0xAC,0x66,0x64,0xFA,0x34,0xA8,0x27
	.DB  0xFA,0xF9
_matrix:
	.DB  0x7,0xA,0xD,0xE,0xF,0xE,0xD,0xA
	.DB  0x7,0x5,0x2,0x1,0x0,0x1,0x2,0x5
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0xA5:
	.DB  0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x04
	.DW  _0xA5*2

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
;Version : PROTOCOL TEST
;Date    : 12/23/2011
;Author  : HANDIKO GESANG ANUGRAH S.
;Company : TIM TELEMETRI & RADIO INSTRUMENTASI
;	  LABORATORIUM SENSOR DAN SISTEM TELEKONTROL
;	  JURUSAN TEKNIK FISIKA
;          FAKULTAS TEKNIK
;          UNIVERSITAS GADJAH MADA
;
;Chip type           : ATtiny2313
;Program type        : Application
;Clock frequency     : 11.059200 MHz
;Memory model        : Tiny
;External SRAM size  : 0
;Data Stack size     : 32
;
;Pembangkit Polynomial, G(x) = x^16 + x^12 + x^5 + 1
;		       G(x) = 0b10001000000100001
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
;#include <stdio.h>
;
;#define _1200		0
;#define _2200		1
;#define CONST_1200      46
;#define CONST_2400      22  			// 22 = 2200Hz, 20 = 2400Hz, 21 = 2500Hz??, 22 = 2420Hz??, 24 = 22xxHz??
;#define CONST_POLYNOM   0b10001000000100001	// x^16 + x^12 + x^5 + 1
;
;#define TX_NOW  PIND.3
;#define PTT     PORTB.3
;#define DAC_0   PORTB.7
;#define DAC_1   PORTB.6
;#define DAC_2   PORTB.5
;#define DAC_3   PORTB.4
;
;#define L_BUSY	PORTD.5
;#define L_STBY  PORTD.4
;
;void protocol(void);
;void send_data(char input);
;void fliptone(void);
;void set_dac(char value);
;void send_tone(char nada);
;void send_fcs(char infcs);
;void calc_fcs(char in);
;
;flash char flag = 0x7E;
;flash char data[98] =  // eeprom char data[93] = // ????? eepromnya rusak
;{ 	// address field
;	('A'<<1),('P'<<1),('U'<<1),('2'<<1),('5'<<1),('N'<<1),0b11100000,		// destination, index 0 - 6
;	('Y'<<1),('D'<<1),('2'<<1),('X'<<1),('B'<<1),('C'<<1),('1'<<1),         // source, index 7 - 13
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1),         // digi, index 14 - 20
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('1'<<1),(' '<<1),('1'<<1)+1,       // digi, index 21 - 27
;
;        // control & PID field, index 28 - 29
;        0x03,0xF0,
;
;        // data type, index 30
;        0b01111001,
;
;        // data field
;        ('0'<<1),('7'<<1),('4'<<1),('5'<<1),('.'<<1),('5'<<1),('8'<<1),('S'<<1),		// latitude, index 31 - 38
;        ('/'<<1),                                                                          	// symbol table, index 39
;        ('1'<<1),('1'<<1),('0'<<1),('2'<<1),('2'<<1),('.'<<1),('2'<<1),('2'<<1),('E'<<1),  	// longitude, index 40 - 48
;
;        // symbol code, index 49
;        ('$'<<1),
;
;        // comment field, index 50 - 92
;
;
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),('-'<<1),('2'<<1),(' '<<1),
;        ('E'<<1),('x'<<1),('p'<<1),('e'<<1),('r'<<1),('i'<<1),('m'<<1),('e'<<1),('n'<<1),('t'<<1),('a'<<1),('l'<<1),(' '<<1),
;        ('V'<<1),('H'<<1),('F'<<1),(' '<<1),
;        ('D'<<1),('i'<<1),('g'<<1),('i'<<1),('p'<<1),('e'<<1),('a'<<1),('t'<<1),('e'<<1),('r'<<1),(' '<<1),
;        ('{'<<1),('U'<<1),('I'<<1),('V'<<1),('3'<<1),('2'<<1),('}'<<1),
;
;        // entah apa ini
;        0b00110100,
;        0b10101000,
;        0b00100111,
;        0b11111010,
;        0b11111001
;};
;unsigned char fcshi;
;unsigned char fcslo;
;char count_1 = 0;
;char x_counter = 0;
;char n = 0;
;bit flag_state;
;bit crc_flag = 0;
;bit tone = _1200;
;long fcs_arr = 0;
;flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};	// pemetaan tegangan sinusoidal
;
;void tes_nada_1200(void)
; 0000 006C {	char i;

	.CSEG
_tes_nada_1200:
; 0000 006D 	int j;
; 0000 006E         L_BUSY = 1;
	RCALL __SAVELOCR4
;	i -> R17
;	j -> R18,R19
	SBI  0x12,5
; 0000 006F 	for(j=0; j<1200; j++)
	__GETWRN 18,19,0
_0x6:
	__CPWRN 18,19,1200
	BRGE _0x7
; 0000 0070     	{	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x9:
	CPI  R17,16
	BRSH _0xA
; 0000 0071         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 0072         		delay_us(CONST_1200);
	__DELAY_USB 170
; 0000 0073         	}
	SUBI R17,-1
	RJMP _0x9
_0xA:
; 0000 0074     	}
	__ADDWRN 18,19,1
	RJMP _0x6
_0x7:
; 0000 0075         L_BUSY = 0;
	CBI  0x12,5
; 0000 0076 }
	RJMP _0x2060001
;
;void tes_nada_2400(void)
; 0000 0079 {	char i;
_tes_nada_2400:
; 0000 007A 	int j;
; 0000 007B         L_STBY = 1;
	RCALL __SAVELOCR4
;	i -> R17
;	j -> R18,R19
	SBI  0x12,4
; 0000 007C         for(j=0; j<2200; j++)
	__GETWRN 18,19,0
_0x10:
	__CPWRN 18,19,2200
	BRGE _0x11
; 0000 007D         {	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x13:
	CPI  R17,16
	BRSH _0x14
; 0000 007E         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 007F                 	delay_us(CONST_2400);
	RCALL SUBOPT_0x1
; 0000 0080                 }
	SUBI R17,-1
	RJMP _0x13
_0x14:
; 0000 0081         }
	__ADDWRN 18,19,1
	RJMP _0x10
_0x11:
; 0000 0082         L_STBY = 0;
	CBI  0x12,4
; 0000 0083 }
_0x2060001:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;
;void fliptone2(void)
; 0000 0086 {	if(tone == _1200)
_fliptone2:
	SBIC 0x13,2
	RJMP _0x17
; 0000 0087         {	tone = _2200;
	SBI  0x13,2
; 0000 0088         	send_tone(tone);
	RJMP _0xA2
; 0000 0089         }
; 0000 008A         else
_0x17:
; 0000 008B         {	tone = _1200;
	CBI  0x13,2
; 0000 008C         	send_tone(tone);
_0xA2:
	LDI  R30,0
	SBIC 0x13,2
	LDI  R30,1
	ST   -Y,R30
	RCALL _send_tone
; 0000 008D         }
; 0000 008E }
	RET
;
;void send_data2(char input)
; 0000 0091 {	char i;
_send_data2:
	PUSH R15
; 0000 0092         bit x;
; 0000 0093         for(i=0;i<8;i++)
	ST   -Y,R17
;	input -> Y+1
;	i -> R17
;	x -> R15.0
	LDI  R17,LOW(0)
_0x1E:
	CPI  R17,8
	BRSH _0x1F
; 0000 0094         {	x = (input >> i) & 0x01;
	MOV  R30,R17
	LDD  R26,Y+1
	RCALL __LSRB12
	BST  R30,0
	BLD  R15,0
; 0000 0095                 if(x)	send_tone(tone);
	SBRS R15,0
	RJMP _0x20
	LDI  R30,0
	SBIC 0x13,2
	LDI  R30,1
	ST   -Y,R30
	RCALL _send_tone
; 0000 0096                 if(!x)  fliptone2();
_0x20:
	SBRS R15,0
	RCALL _fliptone2
; 0000 0097         }
	SUBI R17,-1
	RJMP _0x1E
_0x1F:
; 0000 0098 }
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;char k;
;void protocol2(void)
; 0000 009C { 	PTT = 1;
_protocol2:
	SBI  0x18,3
; 0000 009D 	delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 009E         for(k=0;k<50;k++)	send_data2(flag);
	CLR  R6
_0x25:
	LDI  R30,LOW(50)
	CP   R6,R30
	BRSH _0x26
	LDI  R30,LOW(126)
	ST   -Y,R30
	RCALL _send_data2
	INC  R6
	RJMP _0x25
_0x26:
; 0000 009F for(k=0;k<98;k++)	send_data2(data[k]);
	CLR  R6
_0x28:
	LDI  R30,LOW(98)
	CP   R6,R30
	BRSH _0x29
	MOV  R30,R6
	LDI  R31,0
	SUBI R30,LOW(-_data*2)
	SBCI R31,HIGH(-_data*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _send_data2
	INC  R6
	RJMP _0x28
_0x29:
; 0000 00A0 for(k=0;k<25;k++)	send_data2(flag);
	CLR  R6
_0x2B:
	LDI  R30,LOW(25)
	CP   R6,R30
	BRSH _0x2C
	LDI  R30,LOW(126)
	ST   -Y,R30
	RCALL _send_data2
	INC  R6
	RJMP _0x2B
_0x2C:
; 0000 00A1 PORTB.3  = 0;
	CBI  0x18,3
; 0000 00A2 }
	RET
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 00A5 {	L_STBY = 0;
_ext_int1_isr:
	RCALL SUBOPT_0x3
	RCALL SUBOPT_0x4
; 0000 00A6         L_BUSY = 0;
; 0000 00A7         delay_ms(250);
; 0000 00A8         protocol2();
; 0000 00A9 }
	RJMP _0xA4
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 00AC {	n++;
_timer1_ovf_isr:
	RCALL SUBOPT_0x3
	INC  R7
; 0000 00AD 	if(n == 3)
	LDI  R30,LOW(3)
	CP   R30,R7
	BRNE _0x33
; 0000 00AE         {	n = 0;
	CLR  R7
; 0000 00AF         	L_STBY = 0;
	RCALL SUBOPT_0x4
; 0000 00B0         	L_BUSY = 0;
; 0000 00B1         	delay_ms(250);
; 0000 00B2         	protocol2();
; 0000 00B3 
; 0000 00B4         }
; 0000 00B5         TCNT1H=0x02;
_0x33:
	RCALL SUBOPT_0x5
; 0000 00B6 	TCNT1L=0xE0;
; 0000 00B7 }
_0xA4:
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
;void protocol(void)
; 0000 00BA {	char i;
; 0000 00BB         PTT = 1;
;	i -> R17
; 0000 00BC         delay_ms(500);				// tunggu sampai radio stabil
; 0000 00BD 
; 0000 00BE         crc_flag = 0;
; 0000 00BF         flag_state = 1;				// disable hitung fcs
; 0000 00C0         for(i=0;i<50;i++)
; 0000 00C1         	send_data(flag);             	// kirim flag 50 kali
; 0000 00C2 flag_state = 0;
; 0000 00C3         for(i=0;i<93;i++)
; 0000 00C4         	send_data(data[i]);		// kirim data
; 0000 00C5 crc_flag = 1;
; 0000 00C6         calc_fcs(0);	        		// hitung FCS
; 0000 00C7         	send_fcs(fcshi);          	// kirim 8 MSB dari FCS
; 0000 00C8         	send_fcs(fcslo);               	// kirim 8 LSB dari FCS
; 0000 00C9         flag_state = 1;
; 0000 00CA         for(i=0;i<5;i++)
; 0000 00CB         	send_data(flag);             	// kirim flag 15 kali
; 0000 00CC flag_state = 0;
; 0000 00CD         // ulangi lagi
; 0000 00CE 	crc_flag = 0;
; 0000 00CF         flag_state = 1;				// disable hitung fcs
; 0000 00D0         for(i=0;i<5;i++)
; 0000 00D1         	send_data(flag);             	// kirim flag 50 kali
; 0000 00D2 flag_state = 0;
; 0000 00D3         for(i=0;i<93;i++)
; 0000 00D4         	send_data(data[i]);		// kirim data
; 0000 00D5 crc_flag = 1;
; 0000 00D6         calc_fcs(0);	        		// hitung FCS
; 0000 00D7         	send_fcs(fcshi);          	// kirim 8 MSB dari FCS
; 0000 00D8         	send_fcs(fcslo);               	// kirim 8 LSB dari FCS
; 0000 00D9         flag_state = 1;
; 0000 00DA         for(i=0;i<15;i++)
; 0000 00DB         	send_data(flag);             	// kirim flag 15 kali
; 0000 00DC flag_state = 0;
; 0000 00DD         PTT = 0;
; 0000 00DE }
;
;void send_data(char input)
; 0000 00E1 {	char i;
; 0000 00E2         bit x;
; 0000 00E3         for(i=0;i<8;i++)
;	input -> Y+1
;	i -> R17
;	x -> R15.0
; 0000 00E4         {	x = (input >> i) & 0x01;
; 0000 00E5                 if(!flag_state)	calc_fcs(x);
; 0000 00E6                 if(x)
; 0000 00E7                 {	if(!flag_state) count_1++;
; 0000 00E8                         if(count_1==5)  fliptone();
; 0000 00E9                         send_tone(tone);
; 0000 00EA                 }
; 0000 00EB                 if(!x)  fliptone();
; 0000 00EC         }
; 0000 00ED }
;
;void fliptone(void)
; 0000 00F0 {	count_1 = 0;
; 0000 00F1         if(tone == _1200)
; 0000 00F2         {	tone = _2200;
; 0000 00F3         	send_tone(tone);
; 0000 00F4         }
; 0000 00F5         else
; 0000 00F6         {	tone = _1200;
; 0000 00F7         	send_tone(tone);
; 0000 00F8         }
; 0000 00F9 }
;
;void set_dac(char value)
; 0000 00FC {	DAC_0 = value & 0x01;   	// LSB
_set_dac:
;	value -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x74
	CBI  0x18,7
	RJMP _0x75
_0x74:
	SBI  0x18,7
_0x75:
; 0000 00FD         DAC_1 =( value >> 1 ) & 0x01;
	LD   R30,Y
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x76
	CBI  0x18,6
	RJMP _0x77
_0x76:
	SBI  0x18,6
_0x77:
; 0000 00FE         DAC_2 =( value >> 2 ) & 0x01;
	LD   R30,Y
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x78
	CBI  0x18,5
	RJMP _0x79
_0x78:
	SBI  0x18,5
_0x79:
; 0000 00FF         DAC_3 =( value >> 3 ) & 0x01;	// MSB
	LD   R30,Y
	LSR  R30
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x7A
	CBI  0x18,4
	RJMP _0x7B
_0x7A:
	SBI  0x18,4
_0x7B:
; 0000 0100 }
	ADIW R28,1
	RET
;
;void send_tone(char nada)
; 0000 0103 {	char i;
_send_tone:
; 0000 0104 	char j;
; 0000 0105 	if(nada == _1200)
	RCALL __SAVELOCR2
;	nada -> Y+2
;	i -> R17
;	j -> R16
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x7C
; 0000 0106     	{	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x7E:
	CPI  R17,16
	BRSH _0x7F
; 0000 0107         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 0108         		delay_us(CONST_1200);
	__DELAY_USB 170
; 0000 0109         	}
	SUBI R17,-1
	RJMP _0x7E
_0x7F:
; 0000 010A     	}
; 0000 010B     	else
	RJMP _0x80
_0x7C:
; 0000 010C     	{	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x82:
	CPI  R17,16
	BRSH _0x83
; 0000 010D         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 010E                 	delay_us(CONST_2400);
	RCALL SUBOPT_0x1
; 0000 010F                 }
	SUBI R17,-1
	RJMP _0x82
_0x83:
; 0000 0110                 for(i=0; i<13; i++)
	LDI  R17,LOW(0)
_0x85:
	CPI  R17,13
	BRSH _0x86
; 0000 0111                 {	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 0112                 	delay_us(CONST_2400);
	RCALL SUBOPT_0x1
; 0000 0113                 }
	SUBI R17,-1
	RJMP _0x85
_0x86:
; 0000 0114     	}
_0x80:
; 0000 0115 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;
;void send_fcs(char infcs)
; 0000 0118 {	char j=7;
; 0000 0119         bit x;
; 0000 011A         while(j>0)
;	infcs -> Y+1
;	j -> R17
;	x -> R15.0
; 0000 011B         {	x = (infcs >> j) & 0x01;
; 0000 011C                 if(x)
; 0000 011D                 {	count_1++;
; 0000 011E                         if(count_1==5)    fliptone();
; 0000 011F                         send_tone(tone);
; 0000 0120                 }
; 0000 0121                 if(!x)  fliptone();
; 0000 0122                 j--;
; 0000 0123         };
; 0000 0124 }
;
;void calc_fcs(char in)
; 0000 0127 {	char i;
; 0000 0128  	fcs_arr += in;
;	in -> Y+1
;	i -> R17
; 0000 0129         x_counter++;
; 0000 012A    	if(crc_flag)
; 0000 012B         {	for(i=0;i<16;i++) 			// selesaikan hitungan
; 0000 012C         	{	if((fcs_arr >> 16)==1) 	fcs_arr ^= CONST_POLYNOM;
; 0000 012D           		fcs_arr <<= 1;
; 0000 012E           	}
; 0000 012F           	fcshi = fcs_arr >> 8; 			// ambil 8 bit paling kiri
; 0000 0130        		fcslo = fcs_arr & 0b11111111; 		// ambil 8 bit paling kanan
; 0000 0131     	}
; 0000 0132      	if((x_counter==17) && ((fcs_arr >> 16)==1))	// syarat batas
; 0000 0133         {	fcs_arr ^= CONST_POLYNOM;
; 0000 0134                 x_counter -= 1;
; 0000 0135       	}
; 0000 0136         if(x_counter==17) 	x_counter -= 1;		// hitung terus
; 0000 0137        	fcs_arr <<= 1;
; 0000 0138 }
;
;void main(void)
; 0000 013B {
_main:
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
; 0000 0142 
; 0000 0143         PORTB=0x00;
	OUT  0x18,R30
; 0000 0144 	DDRB=0xF8;
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 0145         PORTD=0x09;
	LDI  R30,LOW(9)
	OUT  0x12,R30
; 0000 0146 	DDRD=0x30;
	LDI  R30,LOW(48)
	OUT  0x11,R30
; 0000 0147 
; 0000 0148 
; 0000 0149         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 014A         DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 014B 
; 0000 014C 	GIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x3B,R30
; 0000 014D 	MCUCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0000 014E 	EIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 014F 
; 0000 0150 	TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0151 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 0152 	TCNT1H=0x02;
	RCALL SUBOPT_0x5
; 0000 0153 	TCNT1L=0xE0;
; 0000 0154 	ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 0155 	ICR1L=0x00;
	OUT  0x24,R30
; 0000 0156         TIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x39,R30
; 0000 0157 
; 0000 0158         // 39, 29, = 8 detik
; 0000 0159         // 38, 28, = 4 detik
; 0000 015A         // 1F, 0F, = 2 detik
; 0000 015B         // 1E, 0E, = 1 detik
; 0000 015C 
; 0000 015D #pragma optsize-
; 0000 015E 	WDTCR=0x38;
	LDI  R30,LOW(56)
	OUT  0x21,R30
; 0000 015F 	WDTCR=0x28;
	LDI  R30,LOW(40)
	OUT  0x21,R30
; 0000 0160 	#ifdef _OPTIMIZE_SIZE_
; 0000 0161 #pragma optsize+
; 0000 0162 	#endif
; 0000 0163 
; 0000 0164         L_BUSY = 1;
	SBI  0x12,5
; 0000 0165         delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 0166         L_STBY = 1;
	SBI  0x12,4
; 0000 0167         delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 0168         L_BUSY = 0;
	CBI  0x12,5
; 0000 0169         delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 016A         L_STBY = 0;
	CBI  0x12,4
; 0000 016B 
; 0000 016C         #asm("sei")
	sei
; 0000 016D 
; 0000 016E         while (1)
_0x9E:
; 0000 016F         {       delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
; 0000 0170                 tes_nada_1200();
	RCALL _tes_nada_1200
; 0000 0171                 tes_nada_2400();
	RCALL _tes_nada_2400
; 0000 0172         };
	RJMP _0x9E
; 0000 0173 }
_0xA1:
	RJMP _0xA1
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.EQU __sm_mask=0x50
	.EQU __sm_powerdown=0x10
	.EQU __sm_standby=0x40
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.CSEG

	.DSEG
_fcs_arr:
	.BYTE 0x4

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
	__DELAY_USB 81
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x3:
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
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4:
	CBI  0x12,4
	CBI  0x12,5
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	RJMP _protocol2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(2)
	OUT  0x2D,R30
	LDI  R30,LOW(224)
	OUT  0x2C,R30
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
