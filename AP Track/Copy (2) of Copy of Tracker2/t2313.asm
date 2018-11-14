
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
;global 'const' stored in FLASH: Yes
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
	.DEF _rx_wr_index=R3
	.DEF _rx_rd_index=R2
	.DEF _rx_counter=R5
	.DEF _fcshi=R4
	.DEF _fcslo=R7
	.DEF _count_1=R6
	.DEF _x_counter=R9

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
	RJMP _usart_rx_isr
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

_string:
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

_0x67:
	.DB  0x0,0x0,0x0,0x0

__GLOBAL_INI_TBL:
	.DW  0x04
	.DW  0x06
	.DW  _0x67*2

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
;Version : STRING TEST
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
;Polynomial Generator G(x) = x^16 + x^12 + x^5 + 1
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
;#include <string.h>
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef	UPE
;#define UPE 2
;#endif
;
;#ifndef	OVR
;#define OVR 3
;#endif
;
;#ifndef	FE
;#define FE 4
;#endif
;
;#ifndef	UDRE
;#define UDRE 5
;#endif
;
;#ifndef	RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<OVR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;#define RX_BUFFER_SIZE 8
;
;char rx_buffer[RX_BUFFER_SIZE];
;bit rx_buffer_overflow;
;
;#if RX_BUFFER_SIZE<256
;	unsigned char rx_wr_index,rx_rd_index,rx_counter;
;	#else
;	unsigned int rx_wr_index,rx_rd_index,rx_counter;
;#endif
;
;interrupt [USART_RXC] void usart_rx_isr(void)
; 0000 004A {	char status,data;

	.CSEG
_usart_rx_isr:
	ST   -Y,R30
	IN   R30,SREG
	ST   -Y,R30
; 0000 004B 	status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 004C 	data=UDR;
	IN   R16,12
; 0000 004D 	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 004E    	{	rx_buffer[rx_wr_index]=data;
	MOV  R30,R3
	SUBI R30,-LOW(_rx_buffer)
	ST   Z,R16
; 0000 004F    		if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R3
	LDI  R30,LOW(8)
	CP   R30,R3
	BRNE _0x4
	CLR  R3
; 0000 0050    		if (++rx_counter == RX_BUFFER_SIZE)
_0x4:
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x5
; 0000 0051       		{	rx_counter=0;
	CLR  R5
; 0000 0052       			rx_buffer_overflow=1;
	SBI  0x13,0
; 0000 0053       		};
_0x5:
; 0000 0054    	};
_0x3:
; 0000 0055 }
	RCALL __LOADLOCR2P
	LD   R30,Y+
	OUT  SREG,R30
	LD   R30,Y+
	RETI
;
;#ifndef _DEBUG_TERMINAL_IO_
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;	char getchar(void)
; 0000 005B 	{	char data;
; 0000 005C 		while (rx_counter==0);
;	data -> R17
; 0000 005D 		data=rx_buffer[rx_rd_index];
; 0000 005E 		if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
; 0000 005F 		#asm("cli")
; 0000 0060 		--rx_counter;
; 0000 0061 		#asm("sei")
; 0000 0062 		return data;
; 0000 0063 	}
;#pragma used-
;#endif
;
;#define _1200		0
;#define _2200		1
;#define CONST_1200      46
;#define CONST_2400      20  // 22 = 2200Hz, = 2400Hz
;#define CONST_POLYNOM   0b10001000000100001	// x^16 + x^12 + x^5 + 1
;//#define CONST_POLYNOM	0b11000000000000101	// x^16 + x^15 + x^2 + 1
;
;#define TX_NOW  PIND.3
;#define PTT     PORTB.3
;#define DAC_0   PORTB.4
;#define DAC_1   PORTB.5
;#define DAC_2   PORTB.6
;#define DAC_3   PORTB.7
;
;#define L_TX	PORTD.4
;#define L_BUSY	PORTD.5
;#define L_STBY  PORTD.6
;
;void protocol(void);
;void send_data(char input);
;void fliptone(void);
;void set_dac(char value);
;void send_tone(char nada);
;//void send_fcs(char infcs);
;void calc_fcs(char in);
;//void getComma();
;//void ekstrak_gps();
;void init_usart(void);
;void clear_usart(void);
;
;flash char flag = 0x7E;
;
;/*
;char destination[7] =
;{     	'A'<<1, 'P'<<1, 'U'<<1, '2'<<1, '5'<<1, 'N'<<1, '2'<<1
;};
;char source[7] =
;{      	'Y'<<1, 'D'<<1, '2'<<1, 'X'<<1, 'B'<<1, 'C'<<1, '9'<<1
;};
;char digi[7] =
;{       'W'<<1, 'I'<<1, 'D'<<1, 'E'<<1, '2'<<1, ' '<<1, ('2'<<1)
;};
;char digi2[7] =
;{       'W'<<1, 'I'<<1, 'D'<<1, 'E'<<1, '1'<<1, ' '<<1, ('1'<<1)+1
;};
;flash char control_field = 0x03;
;flash unsigned char protocol_id = 0xF0;
;flash char data_type = 0x21;
;eeprom char latitude[8] =
;{	'0'<<1, '7'<<1, '4'<<1, '5'<<1, '.'<<1, '7'<<1, '9'<<1, 'S'<<1
;        // 0745.79S
;};
;flash char symbol_table = (0x2F << 1);
;eeprom char longitude[9] =
;{	'1'<<1, '1'<<1, '0'<<1, '0'<<1, '5'<<1, '.'<<1, '2'<<1, '1'<<1, 'E'<<1
;        // 11005.21E
;};
;flash char symbol_code = (0x3E<<1);
;flash char comment[] =
;{	'V'<<1, 'H'<<1, 'F'<<1, ' '<<1,
;	'D'<<1, 'i'<<1, 'g'<<1, 'i'<<1, 'p'<<1, 'e'<<1, 'a'<<1, 't'<<1, 'e'<<1, 'r'<<1, ' '<<1,
;	'D'<<1, 's'<<1, '.'<<1, ' '<<1, 'P'<<1, 'o'<<1, 'g'<<1, 'u'<<1, 'n'<<1, 'g'<<1, ' '<<1,
;        'k'<<1, 'i'<<1, 'd'<<1, 'u'<<1, 'l'<<1
;};  */
;flash char string[98] =
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
;unsigned char fcshi;
;unsigned char fcslo;
;char count_1 = 0;
;char x_counter = 0;
;bit flag_state;
;bit crc_flag = 0;
;bit tone = _1200;
;long fcs_arr = 0;
;flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};	// pemetaan tegangan sinusoidal
;
;void tes_nada_1200(void)
; 0000 00CC {	char i;
_tes_nada_1200:
; 0000 00CD 	int j;
; 0000 00CE         L_BUSY = 1;
	RCALL __SAVELOCR4
;	i -> R17
;	j -> R18,R19
	SBI  0x12,5
; 0000 00CF 	for(j=0; j<1200; j++)
	__GETWRN 18,19,0
_0xF:
	__CPWRN 18,19,1200
	BRGE _0x10
; 0000 00D0     	{	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x12:
	CPI  R17,16
	BRSH _0x13
; 0000 00D1         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 00D2         		delay_us(CONST_1200);
	__DELAY_USB 170
; 0000 00D3         	}
	SUBI R17,-1
	RJMP _0x12
_0x13:
; 0000 00D4     	}
	__ADDWRN 18,19,1
	RJMP _0xF
_0x10:
; 0000 00D5         L_BUSY = 0;
	CBI  0x12,5
; 0000 00D6 }
	RJMP _0x2060002
;
;void tes_nada_2400(void)
; 0000 00D9 {	char i;
_tes_nada_2400:
; 0000 00DA 	int j;
; 0000 00DB         L_STBY =1;
	RCALL __SAVELOCR4
;	i -> R17
;	j -> R18,R19
	SBI  0x12,6
; 0000 00DC         for(j=0; j<2400; j++)
	__GETWRN 18,19,0
_0x19:
	__CPWRN 18,19,2400
	BRGE _0x1A
; 0000 00DD         {	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x1C:
	CPI  R17,16
	BRSH _0x1D
; 0000 00DE         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 00DF                 	delay_us(CONST_2400);
	__DELAY_USB 74
; 0000 00E0                 }
	SUBI R17,-1
	RJMP _0x1C
_0x1D:
; 0000 00E1         }
	__ADDWRN 18,19,1
	RJMP _0x19
_0x1A:
; 0000 00E2         L_STBY = 0;
	CBI  0x12,6
; 0000 00E3 }
_0x2060002:
	RCALL __LOADLOCR4
	ADIW R28,4
	RET
;
;interrupt [EXT_INT1] void ext_int1_isr(void)
; 0000 00E6 {	L_STBY = 0;
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
	CBI  0x12,6
; 0000 00E7         L_BUSY = 0;
	CBI  0x12,5
; 0000 00E8         delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RCALL SUBOPT_0x1
	RCALL _delay_ms
; 0000 00E9         clear_usart();
	RCALL _clear_usart
; 0000 00EA         protocol();
	RCALL _protocol
; 0000 00EB         init_usart();
	RCALL _init_usart
; 0000 00EC }
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
;/*
;
;void protocol(void)
;{	char i;
;        PTT = 1;
;        L_TX = 1;
;        delay_ms(500);                  			// tunggu sampai radio stabil
;        crc_flag = 0;
;        flag_state = 1;
;        for(i=0;i<30;i++)       send_data(flag);             	// kirim flag 24 kali
;        flag_state = 0;
;        for(i=0;i<7;i++)        send_data(destination[i]);      // kirim callsign tujuan
;        for(i=0;i<7;i++)        send_data(source[i]);           // kirim callsign asal
;        for(i=0;i<7;i++)        send_data(digi[i]);             // kirim path digi
;        for(i=0;i<7;i++)        send_data(digi2[i]);            // kirim path digi
;        send_data(control_field);                               // kirim data control field
;        send_data(protocol_id);                                 // kirim data PID
;        send_data(data_type);                                   // kirim data type info
;        for(i=0;i<8;i++)        send_data(latitude[i]);         // kirim data lintang posisi
;        send_data(symbol_table);                                // kirim simbol tabel
;        for(i=0;i<9;i++)        send_data(longitude[i]);        // kirim data bujur posisi
;        send_data(symbol_code);                                 // kirim simbol kode
;        for(i=0;i<strlenf(comment);i++);      	send_data(comment[i]);          // kirim komen
;        crc_flag = 1;    	calc_fcs(0);	        	// hitung FCS
;        send_fcs(fcshi);                                        // kirim 8 MSB dari FCS
;        send_fcs(fcslo);                                        // kirim 8 LSB dari FCS
;        flag_state = 1;
;        for(i=0;i<24;i++)       send_data(flag);             	// kirim flag 12 kali
;        flag_state = 0;
;        PTT = 0;
;        L_TX = 0;
;}   */
;
;void send_data(char input)
; 0000 0110 {	char i;
_send_data:
	PUSH R15
; 0000 0111         bit x;
; 0000 0112         for(i=0;i<8;i++)
	ST   -Y,R17
;	input -> Y+1
;	i -> R17
;	x -> R15.0
	LDI  R17,LOW(0)
_0x25:
	CPI  R17,8
	BRSH _0x26
; 0000 0113         {	x = (input >> i) & 0x01;
	MOV  R30,R17
	LDD  R26,Y+1
	RCALL __LSRB12
	BST  R30,0
	BLD  R15,0
; 0000 0114                 //if(!flag_state)	calc_fcs(x);
; 0000 0115                 if(x)
	SBRS R15,0
	RJMP _0x27
; 0000 0116                 {	//if(!flag_state) count_1++;
; 0000 0117                         //if(count_1==5)  fliptone();
; 0000 0118                         send_tone(tone);
	LDI  R30,0
	SBIC 0x13,3
	LDI  R30,1
	ST   -Y,R30
	RCALL _send_tone
; 0000 0119                 }
; 0000 011A                 if(!x)  fliptone();
_0x27:
	SBRS R15,0
	RCALL _fliptone
; 0000 011B         }
	SUBI R17,-1
	RJMP _0x25
_0x26:
; 0000 011C }
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;void protocol(void)
; 0000 011F {	char i;
_protocol:
; 0000 0120 	for(i=0; i<50; i++)		send_data(flag);
	ST   -Y,R17
;	i -> R17
	LDI  R17,LOW(0)
_0x2A:
	CPI  R17,50
	BRSH _0x2B
	LDI  R30,LOW(126)
	ST   -Y,R30
	RCALL _send_data
	SUBI R17,-1
	RJMP _0x2A
_0x2B:
; 0000 0121 for(i=0; i<strlenf(string); i++)send_data(string[i]);
	LDI  R17,LOW(0)
_0x2D:
	LDI  R30,LOW(_string*2)
	LDI  R31,HIGH(_string*2)
	RCALL SUBOPT_0x1
	RCALL _strlenf
	MOV  R26,R17
	LDI  R27,0
	CP   R26,R30
	CPC  R27,R31
	BRSH _0x2E
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_string*2)
	SBCI R31,HIGH(-_string*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _send_data
	SUBI R17,-1
	RJMP _0x2D
_0x2E:
; 0000 0122 for(i=0; i<15; i++)		send_data(flag);
	LDI  R17,LOW(0)
_0x30:
	CPI  R17,15
	BRSH _0x31
	LDI  R30,LOW(126)
	ST   -Y,R30
	RCALL _send_data
	SUBI R17,-1
	RJMP _0x30
_0x31:
; 0000 0123 }
	LD   R17,Y+
	RET
;
;void fliptone(void)
; 0000 0126 {	count_1 = 0;
_fliptone:
	CLR  R6
; 0000 0127         if(tone == _1200)
	SBIC 0x13,3
	RJMP _0x32
; 0000 0128         {	tone = _2200;
	SBI  0x13,3
; 0000 0129         	send_tone(tone);
	RJMP _0x66
; 0000 012A         }
; 0000 012B         else
_0x32:
; 0000 012C         {	tone = _1200;
	CBI  0x13,3
; 0000 012D         	send_tone(tone);
_0x66:
	LDI  R30,0
	SBIC 0x13,3
	LDI  R30,1
	ST   -Y,R30
	RCALL _send_tone
; 0000 012E         }
; 0000 012F }
	RET
;
;void set_dac(char value)
; 0000 0132 {	DAC_0 = value & 0x01;
_set_dac:
;	value -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x38
	CBI  0x18,4
	RJMP _0x39
_0x38:
	SBI  0x18,4
_0x39:
; 0000 0133         DAC_1 =( value >> 1 ) & 0x01;
	LD   R30,Y
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x3A
	CBI  0x18,5
	RJMP _0x3B
_0x3A:
	SBI  0x18,5
_0x3B:
; 0000 0134         DAC_2 =( value >> 2 ) & 0x01;
	LD   R30,Y
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x3C
	CBI  0x18,6
	RJMP _0x3D
_0x3C:
	SBI  0x18,6
_0x3D:
; 0000 0135         DAC_3 =( value >> 3 ) & 0x01;
	LD   R30,Y
	LSR  R30
	LSR  R30
	LSR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x3E
	CBI  0x18,7
	RJMP _0x3F
_0x3E:
	SBI  0x18,7
_0x3F:
; 0000 0136 }
	ADIW R28,1
	RET
;
;void send_tone(char nada)
; 0000 0139 {	char i;
_send_tone:
; 0000 013A 	char j;
; 0000 013B 	if(nada == _1200)
	RCALL __SAVELOCR2
;	nada -> Y+2
;	i -> R17
;	j -> R16
	LDD  R30,Y+2
	CPI  R30,0
	BRNE _0x40
; 0000 013C     	{	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x42:
	CPI  R17,16
	BRSH _0x43
; 0000 013D         	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 013E         		delay_us(CONST_1200);
	__DELAY_USB 170
; 0000 013F         	}
	SUBI R17,-1
	RJMP _0x42
_0x43:
; 0000 0140     	}
; 0000 0141     	else
	RJMP _0x44
_0x40:
; 0000 0142     	{	for(j=0; j<2; j++)
	LDI  R16,LOW(0)
_0x46:
	CPI  R16,2
	BRSH _0x47
; 0000 0143                 {	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x49:
	CPI  R17,16
	BRSH _0x4A
; 0000 0144                 	{	set_dac(matrix[i]);
	RCALL SUBOPT_0x0
; 0000 0145                         	delay_us(CONST_2400);
	__DELAY_USB 74
; 0000 0146                 	}
	SUBI R17,-1
	RJMP _0x49
_0x4A:
; 0000 0147                 }
	SUBI R16,-1
	RJMP _0x46
_0x47:
; 0000 0148     	}
_0x44:
; 0000 0149 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;
;void send_fcs(char infcs)
; 0000 014C {	char j=7;
; 0000 014D         bit x;
; 0000 014E         while(j>0)
;	infcs -> Y+1
;	j -> R17
;	x -> R15.0
; 0000 014F         {	x = (infcs >> j) & 0x01;
; 0000 0150                 if(x)
; 0000 0151                 {	count_1++;
; 0000 0152                         if(count_1==5)    fliptone();
; 0000 0153                         send_tone(tone);
; 0000 0154                 }
; 0000 0155                 if(!x)  fliptone();
; 0000 0156                 j--;
; 0000 0157         }
; 0000 0158 }
;
;void calc_fcs(char in)
; 0000 015B {	char i;
; 0000 015C  	fcs_arr += in;
;	in -> Y+1
;	i -> R17
; 0000 015D         x_counter++;
; 0000 015E    	if(crc_flag)
; 0000 015F         {	for(i=0;i<16;i++) 		// selesaikan hitungan
; 0000 0160         	{	if((fcs_arr >> 16)==1) 	fcs_arr ^= CONST_POLYNOM;
; 0000 0161           		fcs_arr <<= 1;
; 0000 0162           	}
; 0000 0163           	fcshi = fcs_arr >> 8; 		// ambil 8 bit paling kiri
; 0000 0164        		fcslo = fcs_arr & 0b11111111; 	// ambil 8 bit paling kanan
; 0000 0165     	}
; 0000 0166      	if((x_counter==17) && ((fcs_arr >> 16)==1))
; 0000 0167         {	fcs_arr ^= CONST_POLYNOM;
; 0000 0168                 x_counter -= 1;
; 0000 0169       	}
; 0000 016A         if(x_counter==17) 	x_counter -= 1;	// hitung terus
; 0000 016B        	fcs_arr <<= 1;
; 0000 016C }
;
;/*
;
;void getComma()
;{	while(getchar() != ',');
;}
;
;void ekstrak_gps()
;{	char i;
;        while(getchar() != '$');
;        // led rx_gps on
;	getchar();
;        getchar();
;        if(getchar() == 'G')
;        {	if(getchar() == 'L')
;        	{	if(getchar() == 'L')
;                	{	getComma();
;                        	for(i=0; i<7; i++)	latitude[i] = getchar();
;                                getchar();
;                                getchar();
;                                getComma();
;                                latitude[7] = getchar();
;                                getComma();
;                                for(i=0; i<8; i++)	longitude[i] = getchar();
;                                getchar();
;                                getchar();
;                                getComma();
;                                longitude[8] = getchar();
;                        }
;                }
;        }
;        // led rx gps off
;} */
;
;void init_usart(void)
; 0000 0190 {	UCSRA=0x00;
_init_usart:
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0191 	UCSRB=0x90;
	LDI  R30,LOW(144)
	OUT  0xA,R30
; 0000 0192 	UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 0193 	UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 0194 	UBRRL=0x8F;
	LDI  R30,LOW(143)
	RJMP _0x2060001
; 0000 0195 }
;
;void clear_usart(void)
; 0000 0198 { 	UCSRA=0;
_clear_usart:
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0199 	UCSRB=0;
	OUT  0xA,R30
; 0000 019A 	UCSRC=0;
	OUT  0x3,R30
; 0000 019B 	UBRRH=0;
	OUT  0x2,R30
; 0000 019C 	UBRRL=0;
_0x2060001:
	OUT  0x9,R30
; 0000 019D }
	RET
;
;void main(void)
; 0000 01A0 {
_main:
; 0000 01A1 #pragma optsize-
; 0000 01A2 	CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 01A3 	CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 01A4 	#ifdef _OPTIMIZE_SIZE_
; 0000 01A5 #pragma optsize+
; 0000 01A6 	#endif
; 0000 01A7 
; 0000 01A8 	PORTB=0x00;
	OUT  0x18,R30
; 0000 01A9 	DDRB=0xF8;
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 01AA 	PORTD=0x01;
	LDI  R30,LOW(1)
	OUT  0x12,R30
; 0000 01AB 	DDRD=0x70;
	LDI  R30,LOW(112)
	OUT  0x11,R30
; 0000 01AC 
; 0000 01AD         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01AE         DIDR=0x00;
	LDI  R30,LOW(0)
	OUT  0x1,R30
; 0000 01AF 
; 0000 01B0 	GIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x3B,R30
; 0000 01B1 	MCUCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0000 01B2 	EIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 01B3 
; 0000 01B4         init_usart();
	RCALL _init_usart
; 0000 01B5         L_BUSY = 1;
	SBI  0x12,5
; 0000 01B6         delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 01B7         L_STBY = 1;
	SBI  0x12,6
; 0000 01B8         delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 01B9         L_BUSY = 0;
	CBI  0x12,5
; 0000 01BA         delay_ms(500);
	RCALL SUBOPT_0x2
; 0000 01BB         L_STBY = 0;
	CBI  0x12,6
; 0000 01BC 
; 0000 01BD         #asm("sei")
	sei
; 0000 01BE 
; 0000 01BF         while (1)
_0x62:
; 0000 01C0         {	//ekstrak_gps();
; 0000 01C1                 delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	RCALL SUBOPT_0x1
	RCALL _delay_ms
; 0000 01C2                 tes_nada_1200();
	RCALL _tes_nada_1200
; 0000 01C3                 tes_nada_2400();
	RCALL _tes_nada_2400
; 0000 01C4         };
	RJMP _0x62
; 0000 01C5 }
_0x65:
	RJMP _0x65
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
_strlenf:
    clr  r26
    clr  r27
    ld   r30,y+
    ld   r31,y+
strlenf0:
	lpm  r0,z+
    tst  r0
    breq strlenf1
    adiw r26,1
    rjmp strlenf0
strlenf1:
    movw r30,r26
    ret

	.CSEG

	.DSEG
_rx_buffer:
	.BYTE 0x8
_fcs_arr:
	.BYTE 0x4

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:22 WORDS
SUBOPT_0x0:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_matrix*2)
	SBCI R31,HIGH(-_matrix*2)
	LPM  R30,Z
	ST   -Y,R30
	RJMP _set_dac

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x1
	RJMP _delay_ms


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

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

;END OF CODE MARKER
__END_OF_CODE:
