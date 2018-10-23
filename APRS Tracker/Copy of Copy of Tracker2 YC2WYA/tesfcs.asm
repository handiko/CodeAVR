
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
	.DEF _n=R3
	.DEF _crc=R4

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
_data:
	.DB  0x82,0xA0,0xB4,0xA8,0x64,0x66,0xE0,0xB2
	.DB  0x88,0x64,0xB0,0x82,0x86,0x72,0xAE,0x92
	.DB  0x88,0x8A,0x62,0x40,0x62,0xAE,0x92,0x88
	.DB  0x8A,0x64,0x40,0x65,0x3,0xF0,0x3A,0x3A
	.DB  0x3A,0x20,0x48,0x41,0x4E,0x44,0x49,0x4B
	.DB  0x4F,0x20,0x28,0x33,0x36,0x37,0x30,0x39
	.DB  0x29,0x20,0x4D,0x4F,0x42,0x49,0x4C,0x45
	.DB  0x20,0x41,0x50,0x52,0x53,0x20,0x54,0x52
	.DB  0x41,0x43,0x4B,0x45,0x52,0x20,0x3A,0x3A
	.DB  0x3A,0xD

_0x3:
	.DB  0x3D,0x30,0x37,0x34,0x35,0x2E,0x38,0x35
	.DB  0x53,0x2F,0x31,0x31,0x30,0x32,0x32,0x2E
	.DB  0x35,0x32,0x45,0x39
_0x69:
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x14
	.DW  _koordinat
	.DW  _0x3*2

	.DW  0x01
	.DW  0x03
	.DW  _0x69*2

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
;Version : PROTOCOL & HARDWARE TEST
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
;
;#define _1200		0
;#define _2200		1
;#define CONST_1200      46
;#define CONST_2200      22
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
;void set_dac(char value);
;void set_nada(char i_nada);
;void tes_nada_1200(void);
;void tes_nada_2200(void);
;void kirim_karakter(unsigned char input);
;void kirim_paket(void);
;void ubah_nada(void);
;void hitung_fcs(char in_fcs);
;void kirim_crc(void);
;
;flash char flag = 0x7E;
;flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
;flash char data[74] =
;{ 	('A'<<1),('P'<<1),('Z'<<1),('T'<<1),('2'<<1),('3'<<1),0b11100000,
;	('Y'<<1),('D'<<1),('2'<<1),('X'<<1),('A'<<1),('C'<<1),('9'<<1),
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('1'<<1),(' '<<1),('1'<<1),
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1,
;        0x03,0xf0, // index 29
;        ':',':',':',' ','H','A','N','D','I','K','O',' ','(','3','6','7','0','9',')',' ',
;        'M','O','B','I','L','E',' ','A','P','R','S',' ','T','R','A','C','K','E','R',' ',':',':',':',0x0D
;};
;char koordinat[20] =
;{       '=','0','7','4','5','.','8','5','S','/','1','1','0','2','2','.','5','2','E','9'
;};

	.DSEG
;bit nada = _1200;
;bit flag_s;
;char n = 0;
;static char bit_stuff = 0;
;unsigned short crc;
;
;void hitung_time_const(char waktu)
; 0000 004F {	unsigned short _TCNT1;

	.CSEG
_hitung_time_const:
; 0000 0050 
; 0000 0051 	_TCNT1 = (1 + 0xFFFF)-(waktu * 10800);
	RCALL __SAVELOCR2
;	waktu -> Y+2
;	_TCNT1 -> R16,R17
	LDD  R26,Y+2
	LDI  R27,0
	LDI  R30,LOW(10800)
	LDI  R31,HIGH(10800)
	RCALL __MULW12U
	CLR  R22
	CLR  R23
	__GETD2N 0x10000
	RCALL __SWAPD12
	RCALL __SUBD12
	MOVW R16,R30
; 0000 0052 
; 0000 0053         TCNT1L = _TCNT1 & 0xFF;
	MOV  R30,R16
	OUT  0x2C,R30
; 0000 0054         TCNT1H = _TCNT1 >> 8;
	MOV  R30,R17
	ANDI R31,HIGH(0x0)
	OUT  0x2D,R30
; 0000 0055 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;
;void tes_nada_1200(void)
; 0000 0058 {	char i;
_tes_nada_1200:
; 0000 0059 	int j;
; 0000 005A         L_BUSY = 1;
	RCALL __SAVELOCR4
;	i -> R17
;	j -> R18,R19
	SBI  0x12,5
; 0000 005B 	for(j=0; j<1000; j++)
	__GETWRN 18,19,0
_0x7:
	__CPWRN 18,19,1000
	BRGE _0x8
; 0000 005C     	{	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0xA:
	CPI  R17,16
	BRSH _0xB
; 0000 005D         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 005E         		delay_us(CONST_1200);
	__DELAY_USB 170
; 0000 005F         	}
	SUBI R17,-1
	RJMP _0xA
_0xB:
; 0000 0060     	}
	__ADDWRN 18,19,1
	RJMP _0x7
_0x8:
; 0000 0061         L_BUSY = 0;
	CBI  0x12,5
; 0000 0062 }
	RJMP _0x2000002
;
;void tes_nada_2200(void)
; 0000 0065 {	char i;
_tes_nada_2200:
; 0000 0066 	int j;
; 0000 0067         L_STBY = 1;
	RCALL __SAVELOCR4
;	i -> R17
;	j -> R18,R19
	SBI  0x12,4
; 0000 0068         for(j=0; j<2000; j++)
	__GETWRN 18,19,0
_0x11:
	__CPWRN 18,19,2000
	BRGE _0x12
; 0000 0069         {	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x14:
	CPI  R17,16
	BRSH _0x15
; 0000 006A         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 006B                 	delay_us(CONST_2200);
	RCALL SUBOPT_0x1
; 0000 006C                 }
	SUBI R17,-1
	RJMP _0x14
_0x15:
; 0000 006D         }
	__ADDWRN 18,19,1
	RJMP _0x11
_0x12:
; 0000 006E         L_STBY = 0;
	CBI  0x12,4
; 0000 006F }
_0x2000002:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 0072 {	delay_ms(250);
_ext_int1_isr:
	RCALL SUBOPT_0x2
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RCALL SUBOPT_0x3
; 0000 0073         kirim_paket();
	RCALL _kirim_paket
; 0000 0074 }
	RJMP _0x68
;
;interrupt [TIM1_OVF] void timer1_ovf_isr(void)
; 0000 0077 {	n++;
_timer1_ovf_isr:
	RCALL SUBOPT_0x2
	INC  R3
; 0000 0078 	if(n==5)
	LDI  R30,LOW(5)
	CP   R30,R3
	BRNE _0x18
; 0000 0079         {	L_STBY = 0;
	CBI  0x12,4
; 0000 007A         	L_BUSY = 0;
	CBI  0x12,5
; 0000 007B                 n=0;
	CLR  R3
; 0000 007C                 kirim_paket();
	RCALL _kirim_paket
; 0000 007D         }
; 0000 007E         TCNT1H=0x02;
_0x18:
	RCALL SUBOPT_0x4
; 0000 007F 	TCNT1L=0xE0;
; 0000 0080 
; 0000 0081         hitung_time_const(6);
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _hitung_time_const
; 0000 0082 }
_0x68:
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
;void kirim_paket(void)
; 0000 0085 {	char i;
_kirim_paket:
; 0000 0086 
; 0000 0087 	crc = 0xFFFF;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R4,R30
; 0000 0088 	PTT = 1;
	SBI  0x18,3
; 0000 0089 
; 0000 008A         flag_s=1;
	SBI  0x13,1
; 0000 008B         for(i=0;i<100;i++)	kirim_karakter(flag);
	LDI  R17,LOW(0)
_0x22:
	CPI  R17,100
	BRSH _0x23
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x5
	SUBI R17,-1
	RJMP _0x22
_0x23:
; 0000 008C flag_s=0;
	CBI  0x13,1
; 0000 008D         bit_stuff = 0;
	RCALL SUBOPT_0x6
; 0000 008E         for(i=0;i<30;i++)	kirim_karakter(data[i]);
	LDI  R17,LOW(0)
_0x27:
	CPI  R17,30
	BRSH _0x28
	RCALL SUBOPT_0x7
	SUBI R17,-1
	RJMP _0x27
_0x28:
; 0000 008F for(i=0;i<20;i++)	kirim_karakter(koordinat[i]);
	LDI  R17,LOW(0)
_0x2A:
	CPI  R17,20
	BRSH _0x2B
	LDI  R26,LOW(_koordinat)
	ADD  R26,R17
	LD   R30,X
	RCALL SUBOPT_0x5
	SUBI R17,-1
	RJMP _0x2A
_0x2B:
; 0000 0090 for(i=30;i<74;i++)	kirim_karakter(data[i]);
	LDI  R17,LOW(30)
_0x2D:
	CPI  R17,74
	BRSH _0x2E
	RCALL SUBOPT_0x7
	SUBI R17,-1
	RJMP _0x2D
_0x2E:
; 0000 0091 kirim_crc();
	RCALL _kirim_crc
; 0000 0092         flag_s=1;
	SBI  0x13,1
; 0000 0093         for(i=0;i<5;i++)	kirim_karakter(flag);
	LDI  R17,LOW(0)
_0x32:
	CPI  R17,5
	BRSH _0x33
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x5
	SUBI R17,-1
	RJMP _0x32
_0x33:
; 0000 0094 flag_s=0;
	CBI  0x13,1
; 0000 0095 
; 0000 0096         PTT = 0;
	CBI  0x18,3
; 0000 0097 }
	LD   R17,Y+
	RET
;
;void kirim_crc(void)
; 0000 009A { 	static unsigned char crc_lo;
_kirim_crc:
; 0000 009B 	static unsigned char crc_hi;
; 0000 009C 
; 0000 009D         crc_lo = crc ^ 0xFF;
	LDI  R30,LOW(255)
	EOR  R30,R4
	STS  _crc_lo_S0000006000,R30
; 0000 009E         crc_hi = (crc >> 8) ^ 0xFF;
	MOV  R30,R5
	ANDI R31,HIGH(0x0)
	LDI  R26,LOW(255)
	EOR  R30,R26
	STS  _crc_hi_S0000006000,R30
; 0000 009F         kirim_karakter(crc_lo);
	LDS  R30,_crc_lo_S0000006000
	RCALL SUBOPT_0x5
; 0000 00A0         kirim_karakter(crc_hi);
	LDS  R30,_crc_hi_S0000006000
	RCALL SUBOPT_0x5
; 0000 00A1 }
	RET
;
;void kirim_karakter(unsigned char input)
; 0000 00A4 {	char i;
_kirim_karakter:
	PUSH R15
; 0000 00A5 	bit r_bit;
; 0000 00A6 
; 0000 00A7 	for(i=0;i<8;i++)
	ST   -Y,R17
;	input -> Y+1
;	i -> R17
;	r_bit -> R15.0
	LDI  R17,LOW(0)
_0x39:
	CPI  R17,8
	BRSH _0x3A
; 0000 00A8         {	r_bit = input & 0x01;
	LDD  R30,Y+1
	BST  R30,0
	BLD  R15,0
; 0000 00A9                 if(flag_s)	{bit_stuff = 0;}
	SBIS 0x13,1
	RJMP _0x3B
	RCALL SUBOPT_0x6
; 0000 00AA                 else 	{hitung_fcs(r_bit);}
	RJMP _0x3C
_0x3B:
	LDI  R30,0
	SBRC R15,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _hitung_fcs
_0x3C:
; 0000 00AB                 if(!r_bit)
	SBRS R15,0
; 0000 00AC                 {	ubah_nada();
	RJMP _0x66
; 0000 00AD                         bit_stuff = 0;
; 0000 00AE                 }
; 0000 00AF                 else
; 0000 00B0                 {	set_nada(nada);
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _set_nada
; 0000 00B1                         bit_stuff = bit_stuff + 1;
	LDS  R30,_bit_stuff_G000
	SUBI R30,-LOW(1)
	STS  _bit_stuff_G000,R30
; 0000 00B2                         if(bit_stuff==5)
	LDS  R26,_bit_stuff_G000
	CPI  R26,LOW(0x5)
	BRNE _0x3F
; 0000 00B3                         {	ubah_nada();
_0x66:
	RCALL _ubah_nada
; 0000 00B4                                 bit_stuff = 0;
	RCALL SUBOPT_0x6
; 0000 00B5                         }
; 0000 00B6                 }
_0x3F:
; 0000 00B7                 input >>= 1;
	LDD  R30,Y+1
	LSR  R30
	STD  Y+1,R30
; 0000 00B8         }
	SUBI R17,-1
	RJMP _0x39
_0x3A:
; 0000 00B9 }
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;void hitung_fcs(char in_fcs)
; 0000 00BC {  	static unsigned short xor;
_hitung_fcs:
; 0000 00BD 
; 0000 00BE 	xor = crc ^ in_fcs;
;	in_fcs -> Y+0
	LD   R30,Y
	LDI  R31,0
	EOR  R30,R4
	EOR  R31,R5
	STS  _xor_S0000008000,R30
	STS  _xor_S0000008000+1,R31
; 0000 00BF 	crc >>= 1;
	LSR  R5
	ROR  R4
; 0000 00C0         if(xor & 0x01)	{crc ^= 0x8408;}
	LDS  R30,_xor_S0000008000
	ANDI R30,LOW(0x1)
	BREQ _0x40
	LDI  R30,LOW(33800)
	LDI  R31,HIGH(33800)
	__EORWRR 4,5,30,31
; 0000 00C1 }
_0x40:
	RJMP _0x2000001
;
;void ubah_nada(void)
; 0000 00C4 {	if(nada ==_1200)
_ubah_nada:
	SBIC 0x13,0
	RJMP _0x41
; 0000 00C5 	{	nada = _2200;
	SBI  0x13,0
; 0000 00C6         	set_nada(nada);
	RJMP _0x67
; 0000 00C7 	}
; 0000 00C8         else
_0x41:
; 0000 00C9         {	nada = _1200;
	CBI  0x13,0
; 0000 00CA         	set_nada(nada);
_0x67:
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _set_nada
; 0000 00CB         }
; 0000 00CC }
	RET
;
;void set_dac(char value)
; 0000 00CF {	DAC_0 = value & 0x01;   	// LSB
_set_dac:
;	value -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x47
	CBI  0x18,7
	RJMP _0x48
_0x47:
	SBI  0x18,7
_0x48:
; 0000 00D0         DAC_1 =( value >> 1 ) & 0x01;
	LD   R30,Y
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x49
	CBI  0x18,6
	RJMP _0x4A
_0x49:
	SBI  0x18,6
_0x4A:
; 0000 00D1         DAC_2 =( value >> 2 ) & 0x01;
	LD   R30,Y
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x4B
	CBI  0x18,5
	RJMP _0x4C
_0x4B:
	SBI  0x18,5
_0x4C:
; 0000 00D2         DAC_3 =( value >> 3 ) & 0x01;	// MSB
	LD   R30,Y
	LSR  R30
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x4D
	CBI  0x18,4
	RJMP _0x4E
_0x4D:
	SBI  0x18,4
_0x4E:
; 0000 00D3 }
_0x2000001:
	ADIW R28,1
	RET
;
;void set_nada(char i_nada)
; 0000 00D6 {	char i;
_set_nada:
; 0000 00D7 
; 0000 00D8 	if(i_nada == _1200)
	ST   -Y,R17
;	i_nada -> Y+1
;	i -> R17
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x4F
; 0000 00D9     	{	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x51:
	CPI  R17,16
	BRSH _0x52
; 0000 00DA         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 00DB         		delay_us(CONST_1200);
	__DELAY_USB 170
; 0000 00DC         	}
	SUBI R17,-1
	RJMP _0x51
_0x52:
; 0000 00DD     	}
; 0000 00DE     	else
	RJMP _0x53
_0x4F:
; 0000 00DF     	{	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x55:
	CPI  R17,16
	BRSH _0x56
; 0000 00E0         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 00E1                 	delay_us(CONST_2200);
	RCALL SUBOPT_0x1
; 0000 00E2                 }
	SUBI R17,-1
	RJMP _0x55
_0x56:
; 0000 00E3                 for(i=0; i<13; i++)
	LDI  R17,LOW(0)
_0x58:
	CPI  R17,13
	BRSH _0x59
; 0000 00E4                 {	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 00E5                 	delay_us(CONST_2200);
	RCALL SUBOPT_0x1
; 0000 00E6                 }
	SUBI R17,-1
	RJMP _0x58
_0x59:
; 0000 00E7     	}
_0x53:
; 0000 00E8 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;void main(void)
; 0000 00EB {
_main:
; 0000 00EC #pragma optsize-
; 0000 00ED 	CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 00EE 	CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 00EF 	#ifdef _OPTIMIZE_SIZE_
; 0000 00F0 #pragma optsize+
; 0000 00F1 	#endif
; 0000 00F2 
; 0000 00F3         PORTB=0x00;
	OUT  0x18,R30
; 0000 00F4 	DDRB=0xF8;
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 00F5         PORTD=0x09;
	LDI  R30,LOW(9)
	OUT  0x12,R30
; 0000 00F6 	DDRD=0x30;
	LDI  R30,LOW(48)
	OUT  0x11,R30
; 0000 00F7 
; 0000 00F8         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 00F9         DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 00FA 
; 0000 00FB 	GIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x3B,R30
; 0000 00FC 	MCUCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0000 00FD 	EIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 00FE 
; 0000 00FF 	TCCR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2F,R30
; 0000 0100 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 0101 	TCNT1H=0x02;
	RCALL SUBOPT_0x4
; 0000 0102 	TCNT1L=0xE0;
; 0000 0103 	ICR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x25,R30
; 0000 0104 	ICR1L=0x00;
	OUT  0x24,R30
; 0000 0105         TIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x39,R30
; 0000 0106 
; 0000 0107 #pragma optsize-
; 0000 0108 	// 39, 29, = 8 detik
; 0000 0109         // 38, 28, = 4 detik
; 0000 010A         // 1F, 0F, = 2 detik
; 0000 010B         // 1E, 0E, = 1 detik
; 0000 010C 	WDTCR=0x38;
	LDI  R30,LOW(56)
	OUT  0x21,R30
; 0000 010D 	WDTCR=0x28;
	LDI  R30,LOW(40)
	OUT  0x21,R30
; 0000 010E 	#ifdef _OPTIMIZE_SIZE_
; 0000 010F #pragma optsize+
; 0000 0110 	#endif
; 0000 0111 
; 0000 0112         L_BUSY = 1;
	SBI  0x12,5
; 0000 0113         delay_ms(500);
	RCALL SUBOPT_0x8
; 0000 0114         L_STBY = 1;
	SBI  0x12,4
; 0000 0115         delay_ms(500);
	RCALL SUBOPT_0x8
; 0000 0116         L_BUSY = 0;
	CBI  0x12,5
; 0000 0117         delay_ms(500);
	RCALL SUBOPT_0x8
; 0000 0118         L_STBY = 0;
	CBI  0x12,4
; 0000 0119 
; 0000 011A         #asm("sei")
	sei
; 0000 011B 
; 0000 011C         while (1)
_0x62:
; 0000 011D         {       delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RCALL SUBOPT_0x3
; 0000 011E                 tes_nada_1200();
	RCALL _tes_nada_1200
; 0000 011F                 tes_nada_2200();
	RCALL _tes_nada_2200
; 0000 0120         };
	RJMP _0x62
; 0000 0121 }
_0x65:
	RJMP _0x65

	.DSEG
_koordinat:
	.BYTE 0x14
_bit_stuff_G000:
	.BYTE 0x1
_crc_lo_S0000006000:
	.BYTE 0x1
_crc_hi_S0000006000:
	.BYTE 0x1
_xor_S0000008000:
	.BYTE 0x2

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x2:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4:
	LDI  R30,LOW(2)
	OUT  0x2D,R30
	LDI  R30,LOW(224)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x5:
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(0)
	STS  _bit_stuff_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x7:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_data*2)
	SBCI R31,HIGH(-_data*2)
	LPM  R30,Z
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RJMP SUBOPT_0x3


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
