
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
;'char' is unsigned       : No
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
	.DEF _xcount=R3
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
_tbl10_G100:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G100:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

_0x8F:
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x03
	.DW  _0x8F*2

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
;/***************************************************************************************
;*
;*				HANYA UNTUK TUJUAN EDUKASIONAL
;*				FOR EDUCATION PURPOSE ONLY
;*
;*				COPYRIGHT (c)2012, HANDIKO GESANG ANUGRAH SEJATI
;*				(handikogesang@gmail.com)
;*
;*				2 FEBRUARY 2012
;*
;*				BASIC APRS BEACON, GPS PARSER, & APRS ENCODER ONLY
;*				TANPA FITUR SMART BEACONING(TM), TELEMETRY, DAN PC CONFIG
;*
;*				LAST REVISION 30 SEPTEMBER 2012
;*
;*				DOKUMEN INI BEBAS UNTUK DISEBARLUASKAN.
;*				HARAP TIDAK MELAKUKAN PERUBAHAN APAPUN ATAS ISI DOKUMEN INI
;*				DAN MENCANTUMKAN NAMA DAN EMAIL PENULIS JIKA INGIN MENYEBAR-
;*				LUASKAN DOKUMEN INI.
;*
;* Project 		: 	APRS BEACON
;* Version 		: 	GPS SUPPORTED, EEPROM DATA PROTECTOR SUPPORTED
;* Date    		: 	02/02/2012
;* Author  		: 	HANDIKO GESANG ANUGRAH S.
;* Company 		: 	TIM INSTRUMENTASI TELEMETRI DAN TELEKONTROL
;* 	  			LABORATORIUM SENSOR DAN SISTEM TELEKONTROL
;* 	  			JURUSAN TEKNIK FISIKA
;*           			FAKULTAS TEKNIK
;*           			UNIVERSITAS GADJAH MADA
;*
;* Chip type           	: 	ATtiny2313
;* Program type        	: 	Application
;* Clock frequency     	: 	11.059200 MHz
;* Memory model        	: 	Tiny
;* External SRAM size  	: 	0
;* Data Stack size     	: 	32
;*
;* File			:	final.c
;*
;* Fungsi - fungsi	: 	void set_dac(char value)
;* 				void set_nada(char i_nada)
;* 				void kirim_karakter(unsigned char input)
;* 				void kirim_paket(void)
;* 				void ubah_nada(void)
;* 				void hitung_crc(char in_crc)
;* 				void kirim_crc(void)
;* 				void ekstrak_gps(void)
;*
;* Variabel global	:	char rx_buffer[RX_BUFFER_SIZE]
;* 				bit rx_buffer_overflow
;*                               flash char matrix[ ]
;*				eeprom char data_1[ ]
;*				eeprom char posisi_lat[ ]
;*				eeprom char posisi_long[ ]
;*				eeprom char data_extension[ ]
;*				eeprom char komentar[ ]
;*				eeprom char status[ ]
;*				eeprom char beacon_stat
;*				char xcount
;*				bit nada
;*				static char bit_stuff
;*				unsigned short crc;
;*
;* Konstanta custom	:	_1200
;* 				_2200
;* 				CONST_1200
;* 				CONST_2200
;* 				GAP_TIME_
;*				FLAG_
;*				CONTROL_FIELD_
;*				PROTOCOL_ID_
;*				TD_POSISI_
;*				TD_STATUS_
;*				SYM_TAB_OVL_
;*				SYM_CODE_
;*
;* Chip I/O		:	TX_NOW  PIND.3
;* 				PTT     PORTB.3
;* 				DAC_0   PORTB.7
;* 				DAC_1   PORTB.6
;* 				DAC_2   PORTB.5
;* 				DAC_3   PORTB.4
;* 				L_BUSY	PORTD.5
;* 				L_STBY  PORTD.4
;*
;* Vektor		:	RJMP __RESET
;*				RJMP _ext_int1_isr
;*				RJMP _timer1_ovf_isr
;*
;* Fuse bit		:	BODLEVEL1 = 0
;*
;*
;***************************************************************************************/
;
;// header firmware
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
;#include <tiny4313_bits.h>
;
;
;
;/***************************************************************************************
;*
;*	DEFINISI KONSTANTA - KONSTANTA CUSTOM
;*
;*/
;// definisi konstanta kondisi tone yang dikirimkan
;#define _1200		0
;#define _2200		1
;
;// definisi konstanta waktu de-sampling (rekonstruksi) diskrit gelombang sinus untuk tone
;	// 1200Hz dan 2200Hz dalam microsecond (us). Silahkan fine tune konstanta ini untuk
;        // adjusting baudrate dan cek hasilnya dengan menginputkan audio dari hardware APRS
;        // pada PC / Laptop lalu cek hasil tone dan baudrate dengan Cool Edit pro pada
;        // tampilan waveform atau spektral.
;
;
;        // Konstanta untuk kompilasi dalam mode optimasi ukuran
;#ifdef	_OPTIMIZE_SIZE_
;	#define CONST_1200      46
;	#define CONST_2200      25  // 22-25    22-->2400Hz   25-->2200Hz
;
;        // Konstanta untuk kompilasi dalam mode optimasi kecepatan
;#else
;	#define CONST_1200      50
;	#define CONST_2200      25
;#endif
;
;// waktu jeda antara transmisi data dalam detik (s)
;#define GAP_TIME_	12
;
;// konstanta waktu opening flag
;#define TX_DELAY_	100
;
;// definisi konstanta karakter Flag
;#define FLAG_		0x7E
;
;// definisi konstanta karakter Control Field
;#define	CONTROL_FIELD_	0x03
;
;// definisi konstanta karakter PID
;#define PROTOCOL_ID_	0xF0
;
;// definisi konstanta karakter Tipe Data posisi
;#define TD_POSISI_	'!'
;
;// definisi konstanta karakter Tipe Data status
;#define TD_STATUS_	'>'
;
;// definisi konstanta karakter simbol tabel dan overlay (/)
;#define SYM_TAB_OVL_	'/'
;
;// definisi konstanta karakter simbol station (Ambulance)
;#define SYM_CODE_	'a'
;
;// konstanta waktu closing flag
;#define TX_TAIL_	15
;
;//	AKHIR DARI DEFINISI KONSTANTA - KONSTANTA CUSTOM
;
;
;/**************************************************************************************/
;
;// header firmware
;#include <delay.h>
;#include <stdarg.h>
;
;/***************************************************************************************
;*
;*	DEFINISI INPUT - OUTPUT ATTINY2313
;*
;*/
;// definisi input TX manual (request interupsi eksternal) INT1
;#define TX_NOW  PIND.3
;
;// definisi output LED TX dan transistor sebagai switch TX (Hi = TX, Lo = waiting)
;#define PTT     PORTB.3
;
;// definisi output tegangan DAC ladder resistor sebagai generator sinusoid ( DAC_0 = LSB,
;	// DAC_3 = MSB )
;#define DAC_0   PORTB.7
;#define DAC_1   PORTB.6
;#define DAC_2   PORTB.5
;#define DAC_3   PORTB.4
;
;// definisi output LED saat terima dan ekstrak data GPS (Hi = parsing, Lo = waiting)
;#define L_BUSY	PORTD.5
;
;// definisi output LED saat menunggu interupsi (Hi = waiting, Lo = ada proses)
;#define L_STBY  PORTD.4
;
;//	AKHIR DARI DEFINISI INPUT - OUTPUT ATTINY2313
;
;
;/***************************************************************************************
;*
;*	DEKLARASI PROTOTYPE FUNGSI - FUNGSI
;*
;*/
;void set_dac(char value);
;void set_nada(char i_nada);
;void kirim_karakter(unsigned char input);
;void kirim_paket(void);
;void ubah_nada(void);
;void hitung_crc(char in_crc);
;void kirim_crc(void);
;void ekstrak_gps(void);
;
;
;//	AKHIR DARI DEKLARASI PROTOTYPE FUNGSI - FUNGSI
;
;
;/***************************************************************************************
;*
;*	DEKLARASI VARIABEL GLOBAL
;*
;*/
;
;// variabel penyimpan nilai rekonstruksi diskrit gelombang sinusoid (matrix 16 ele.)
;flash char matrix[16] = {7,10,13,14,15,14,13,10,7,5,2,1,0,1,2,5};
;
;// variabel penyimpan data adresses
;eeprom unsigned char data_1[21] =
;{
;	// destination field, tergeser kiri 1 bit
;        ('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),('0'<<1),
;
;        // source field, tergeser kiri 1 bit
;	    // ('Y'<<1),('B'<<1),('2'<<1),('Y'<<1),('O'<<1),('U'<<1),('1'<<1),
;        // ('Y'<<1),('B'<<1),('2'<<1),('Z'<<1),('Y'<<1),(' '<<1),('1'<<1),
;        ('Y'<<1),('C'<<1),('2'<<1),('Z'<<1),('Y'<<1),('E'<<1),('1'<<1),
;
;        // path, tergeser kiri 1 bit
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1
;};
;
;// variabel penyimpan data awal posisi lintang dan update data gps
;eeprom char posisi_lat[8] =
;{
;	// latitude
;        '0','0','0','0','.','0','0','0'
;};
;
;// variabel penyimpan data awal posisi bujur dan update data gps
;eeprom char posisi_long[9] =
;{
;	// longitude
;        '0','0','0','0','0','.','0','0','E'
;};
;
;eeprom char altitude[6];
;
;// variabel penyimpan data extensi tipe PHGD
;eeprom char data_extension[7] =
;{
;	// header tipe data ekstensi
;        'P','H','G',
;
;        /************************************************************************************************
;        |-----------------------------------------------------------------------------------------------|
;	|	PHGD CODE (Power Height Gain Directivity)						|
;        |-----------------------------------------------------------------------------------------------|
;        |	P		|	H		|	G		|	D		|
;        |-----------------------|-----------------------|-----------------------|-----------------------|
;        |  0 rep.of  0 watts	|  0 rep.of  10 ft.	|  0 rep.of   0dBi	|  0 rep.of  omni.	|
;        |  1 rep.of  1 watts	|  1 rep.of  20 ft.	|  1 rep.of   1dBi	|  1 rep.of  NE		|
;        |  2 rep.of  4 watts	|  2 rep.of  40 ft.	|  2 rep.of   2dBi	|  2 rep.of  E		|
;        |  3 rep.of  9 watts	|  3 rep.of  80 ft.	|  3 rep.of   3dBi	|  3 rep.of  SE		|
;        |  4 rep.of  16 watts   |  4 rep.of  160 ft.	|  4 rep.of   4dBi	|  4 rep.of  S		|
;        |  5 rep.of  25 watts 	|  5 rep.of  320 ft.	|  5 rep.of   5dBi	|  5 rep.of  SW		|
;        |  6 rep.of  36 watts	|  6 rep.of  640 ft.	|  6 rep.of   6dBi	|  6 rep.of  W		|
;        |  7 rep.of  49 watts	|  7 rep.of  1280 ft.	|  7 rep.of   7dBi	|  7 rep.of  NW		|
;        |  8 rep.of  64 watts	|  8 rep.of  2560 ft.	|  8 rep.of   8dBi	|  8 rep.of  N		|
;        |  9 rep.of  81 watts	|  9 rep.of  5120 ft.	|  9 rep.of   9dBi	|-----------------------|
;        *************************************************************************************************/
;
;
;        // nilai representasi dari PHGD
;        // power : 4 watts, P = 2
;        '2',
;
;        // height above average terrain : 10 feet, H = 0
;        '0',
;
;        // antenna gain : 2dBi, G = 2
;        '2',
;
;        // antenna directivity : omnidirectional, D = 0
;        '0'
;
;};
;
;// variabel penyimpan konstanta string komentar
;eeprom char komentar[28] =
;{
;	'C','O','R','E',' ','O','R','D','A',' ','D','I','Y',' ',//'M','o','b','i','l','e',' ','T','r','a','c','k','e','r'
;                                                            'A','m','b','u','l','a','n','c','e',' ',' ',' ',' ',' '
;
;};
;
;eeprom char status[47] =
;{
;	    'A','T','t','i','n','y','2','3','1','3',' ',
;        'A','P','R','S',' ','t','r','a','c','k','e','r',' ',
;        'h','a','n','d','i','k','o','g','e','s','a','n','g','@','g','m','a','i','l','.','c','o','m'
;};
;
;// variabel pengingat urutan beacon dan status
;eeprom char beacon_stat = 0;
;
;// variabel penyimpan nilai urutan interupsi, 0 ketika inisialisasi dan reset, 1 ketika TX,
;	// 2 - GAP_TIME_ ketika parsing data gps
;char xcount = 0;
;
;// variabel penyimpan tone terakhir, _1200 = 0, _2200 = 1, inisialisasi sebagai 1200Hz
;bit nada = _1200;
;
;// variabel penyimpan enablisasi bit stuffing, 0 = disable bit stuffing, 1 = enable bit stuffing
;static char bit_stuff = 0;
;
;// variabel penyimpan nilai sementara dan nilai akhir CRC-16 CCITT
;unsigned short crc;
;
;//	AKHIR DARI DEKLARASI VARIABEL GLOBAL
;
;
;/***************************************************************************************
;*
;*	KONSTANTA EVALUATOR
;*
;*/
;// cek define _1200
;#ifndef	_1200
;#error	"KONSTANTA _1200 BELUM TERDEFINISI"
;#endif
;
;// cek define _2200
;#ifndef	_2200
;#error	"KONSTANTA _2200 BELUM TERDEFINISI"
;#endif
;
;// cek define CONST_1200
;#ifndef	CONST_1200
;#error	"KONSTANTA CONST_1200 BELUM TERDEFINISI"
;#endif
;
;// cek define CONST_2200
;#ifndef	CONST_2200
;#error	"KONSTANTA CONST_2200 BELUM TERDEFINISI"
;#endif
;
;// cek define GAP_TIME_
;#ifndef	GAP_TIME_
;#error	"KONSTANTA GAP_TIME_ BELUM TERDEFINISI"
;#endif
;
;// cek nilai GAP_TIME_ (harus antara 15 - 30)
;#if	(GAP_TIME_ < 15)
;//#error	"GAP_TIME_ harus bernilai antara 15 - 60. GAP_TIME_ yang terlalu singkat menyebabkan kepadatan traffic"
;#endif
;#if	(GAP_TIME_ > 60)
;#error	"GAP_TIME_ harus bernilai antara 15 - 60. GAP_TIME_ yang terlalu panjang menyebabkan 'loose of track'  "
;#endif
;
;//	AKHIR DARI KONSTANTA EVALUATOR
;
;
;/***************************************************************************************/
;	interrupt 		[EXT_INT1] void ext_int1_isr(void)
; 0000 0172 /***************************************************************************************
; 0000 0173 *	ABSTRAKSI	:	interupsi eksternal, ketika input TX_NOW bernilai LOW,
; 0000 0174 *				[EXT_INT1] aktif
; 0000 0175 *
; 0000 0176 *      	INPUT		:	input TX_NOW
; 0000 0177 *	OUTPUT		:       LED standby dan LED busy
; 0000 0178 *	RETURN		:       tak ada
; 0000 0179 */
; 0000 017A {

	.CSEG
_ext_int1_isr:
	RCALL SUBOPT_0x0
; 0000 017B 	// matikan LED standby
; 0000 017C         L_STBY = 0;
; 0000 017D 
; 0000 017E         // tunggu 250ms (bounce switch)
; 0000 017F         delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RCALL SUBOPT_0x1
; 0000 0180 
; 0000 0181         // kirim paket data
; 0000 0182         kirim_paket();
; 0000 0183 
; 0000 0184         // nyalakan LED standby
; 0000 0185         L_STBY = 1;
	SBI  0x12,4
; 0000 0186 
; 0000 0187 } 	// EndOf interrupt [EXT_INT1] void ext_int1_isr(void)
	RJMP _0x8E
;
;
;/***************************************************************************************/
;	interrupt 		[TIM1_OVF] void timer1_ovf_isr(void)
; 0000 018C /***************************************************************************************
; 0000 018D *	ABSTRAKSI  	: 	interupsi overflow TIMER 1 [TIM1_OVF], di-set overflow
; 0000 018E *				ketika waktu telah mencapai 1 detik. Pengendali urutan
; 0000 018F *				waktu (timeline)antara transmisi data APRS dan parsing
; 0000 0190 *				data gps
; 0000 0191 *
; 0000 0192 *      	INPUT		:	tak ada
; 0000 0193 *	OUTPUT		:       kondisi LED standby dan LED busy
; 0000 0194 *	RETURN		:       tak ada
; 0000 0195 */
; 0000 0196 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x0
; 0000 0197 	// matikan LED stanby
; 0000 0198         L_STBY = 0;
; 0000 0199 
; 0000 019A         // tambahkan 1 nilai variabel xcount
; 0000 019B         xcount++;
	INC  R3
; 0000 019C 
; 0000 019D         // seleksi nilai variabel xcount
; 0000 019E         if((xcount%2) == 0)
	MOV  R26,R3
	LDI  R30,LOW(2)
	RCALL __MODB21
	CPI  R30,0
	BRNE _0x9
; 0000 019F         {	// jika ya
; 0000 01A0         	// nyalakan LED busy
; 0000 01A1                 L_BUSY = 1;
	SBI  0x12,5
; 0000 01A2 
; 0000 01A3                 // dapatkan data koordinat sekarang
; 0000 01A4                 ekstrak_gps();
	RCALL _ekstrak_gps
; 0000 01A5 
; 0000 01A6                 //matikan LED busy
; 0000 01A7                 L_BUSY = 0;
	CBI  0x12,5
; 0000 01A8         }
; 0000 01A9 
; 0000 01AA         // terima dan ekstrak data gps ketika timer detik bernilai genap saja
; 0000 01AB         if((xcount%8) == 0)
_0x9:
	MOV  R26,R3
	LDI  R30,LOW(8)
	RCALL __MODB21
	CPI  R30,0
	BRNE _0xE
; 0000 01AC         {	// jika ya
; 0000 01AD         	// nyalakan LED busy
; 0000 01AE                 L_BUSY = 1;
	SBI  0x12,5
; 0000 01AF 
; 0000 01B0                 // dapatkan data koordinat sekarang
; 0000 01B1                 ekstrak_gps();
	RCALL _ekstrak_gps
; 0000 01B2 
; 0000 01B3                 //matikan LED busy
; 0000 01B4                 L_BUSY = 0;
	CBI  0x12,5
; 0000 01B5 
; 0000 01B6                 // berikan delay sebentar
; 0000 01B7                 delay_ms(500);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x1
; 0000 01B8 
; 0000 01B9                 // kirim paket data
; 0000 01BA                 kirim_paket();
; 0000 01BB 
; 0000 01BC                 // reset variable counter
; 0000 01BD                 xcount = 0;
	CLR  R3
; 0000 01BE         }
; 0000 01BF 
; 0000 01C0         // nyalakan LED standby
; 0000 01C1         L_STBY = 1;
_0xE:
	SBI  0x12,4
; 0000 01C2 
; 0000 01C3         // reset kembali konstanta waktu timer
; 0000 01C4         TCNT1H = 0xAB;
	RCALL SUBOPT_0x3
; 0000 01C5         TCNT1L = 0xA0;
; 0000 01C6 
; 0000 01C7 }       // EndOf interrupt [TIM1_OVF] void timer1_ovf_isr(void)
_0x8E:
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
;
;/***************************************************************************************/
;	void 			kirim_paket(void)
; 0000 01CC /***************************************************************************************
; 0000 01CD *	ABSTRAKSI  	: 	pengendali urutan pengiriman data APRS
; 0000 01CE *				penyusun protokol APRS
; 0000 01CF *
; 0000 01D0 *      	INPUT		:	tak ada
; 0000 01D1 *	OUTPUT		:       kondisi LED dan output transistor switch TX
; 0000 01D2 *	RETURN		:       tak ada
; 0000 01D3 */
; 0000 01D4 {
_kirim_paket:
; 0000 01D5 	char i;
; 0000 01D6 
; 0000 01D7         // inisialisasi nilai CRC dengan 0xFFFF
; 0000 01D8 	crc = 0xFFFF;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R4,R30
; 0000 01D9 
; 0000 01DA         // tambahkan 1 nilai counter pancar
; 0000 01DB         beacon_stat++;
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(1)
	RCALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 01DC 
; 0000 01DD         // nyalakan LED TX dan PTT switch
; 0000 01DE 	PTT = 1;
	SBI  0x18,3
; 0000 01DF 
; 0000 01E0         // tunggu 300ms
; 0000 01E1         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x5
; 0000 01E2 
; 0000 01E3         /**********************************************************************************
; 0000 01E4 
; 0000 01E5         			APRS AX.25 PROTOCOL
; 0000 01E6 
; 0000 01E7         |------------------------------------------------------------------------
; 0000 01E8         |   opn. FLAG	|	DESTINATION	|	SOURCE	|	DIGI'S	| CONTROL...
; 0000 01E9         |---------------|-----------------------|---------------|---------------|
; 0000 01EA         |   0x7E 1Bytes |	7 Bytes		|       7 Bytes |  0 - 56 Bytes	|
; 0000 01EB         |------------------------------------------------------------------------
; 0000 01EC 
; 0000 01ED         	-----------------------------------------------------------------
; 0000 01EE         DIGI'S..|	CONTROL FIELD	|	PROTOCOL ID	|	INFO	| FCS...
; 0000 01EF                 |-----------------------|-----------------------|---------------|
; 0000 01F0                 |    0x03 1 Bytes	|     0xF0 1 Bytes	|  0 - 256 Bytes|
; 0000 01F1                 -----------------------------------------------------------------
; 0000 01F2 
; 0000 01F3         	--------------------------------|
; 0000 01F4         INFO... |	FCS	|   cls. FLAG	|
; 0000 01F5                 |---------------|---------------|
; 0000 01F6                 |	2 Bytes	|   0x7E 1Bytes |
; 0000 01F7                 --------------------------------|
; 0000 01F8 
; 0000 01F9         Sumber : APRS101, Tucson Amateur Packet Radio Club. www.tapr.org
; 0000 01FA         ************************************************************************************/
; 0000 01FB 
; 0000 01FC         // kirim karakter opening flag
; 0000 01FD         for(i=0;i<TX_DELAY_;i++)
	LDI  R17,LOW(0)
_0x18:
	CPI  R17,100
	BRGE _0x19
; 0000 01FE         	kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x6
	SUBI R17,-1
	RJMP _0x18
_0x19:
; 0000 0201 bit_stuff = 0;
	RCALL SUBOPT_0x7
; 0000 0202 
; 0000 0203         // kirimkan field : destination, source, PATH 1, PATH 2, control, Protocol ID, dan
; 0000 0204         	// data type ID
; 0000 0205         for(i=0;i<21;i++)
	LDI  R17,LOW(0)
_0x1B:
	CPI  R17,21
	BRGE _0x1C
; 0000 0206         	kirim_karakter(data_1[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_data_1)
	SBCI R27,HIGH(-_data_1)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x1B
_0x1C:
; 0000 0209 kirim_karakter(0x03);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x6
; 0000 020A 
; 0000 020B         // krimkan protocol ID
; 0000 020C         kirim_karakter(PROTOCOL_ID_);
	LDI  R30,LOW(240)
	RCALL SUBOPT_0x6
; 0000 020D 
; 0000 020E         // jika sudah 20 kali memancar,
; 0000 020F         if(beacon_stat == 20)
	RCALL SUBOPT_0x4
	CPI  R30,LOW(0x14)
	BRNE _0x1D
; 0000 0210         {
; 0000 0211         	// jika ya
; 0000 0212                 // kirim tipe data status
; 0000 0213                 kirim_karakter(TD_STATUS_);
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x6
; 0000 0214 
; 0000 0215                 // kirim teks status
; 0000 0216                 for(i=0;i<47;i++)
	LDI  R17,LOW(0)
_0x1F:
	CPI  R17,47
	BRGE _0x20
; 0000 0217                 	kirim_karakter(status[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_status)
	SBCI R27,HIGH(-_status)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x1F
_0x20:
; 0000 021A beacon_stat = 0;
	LDI  R26,LOW(_beacon_stat)
	LDI  R27,HIGH(_beacon_stat)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 021B 
; 0000 021C                 // lompat ke kirim crc
; 0000 021D                 goto lompat;
	RJMP _0x21
; 0000 021E         }
; 0000 021F 
; 0000 0220         // krimkan tipe data posisi
; 0000 0221         kirim_karakter(TD_POSISI_);
_0x1D:
	LDI  R30,LOW(33)
	RCALL SUBOPT_0x6
; 0000 0222 
; 0000 0223         // kirimkan posisi lintang
; 0000 0224         for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x23:
	CPI  R17,8
	BRGE _0x24
; 0000 0225         	kirim_karakter(posisi_lat[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_posisi_lat)
	SBCI R27,HIGH(-_posisi_lat)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x23
_0x24:
; 0000 0228 kirim_karakter('/');
	LDI  R30,LOW(47)
	RCALL SUBOPT_0x6
; 0000 0229 
; 0000 022A         // kirimkan posisi bujur
; 0000 022B 	for(i=0;i<9;i++)
	LDI  R17,LOW(0)
_0x26:
	CPI  R17,9
	BRGE _0x27
; 0000 022C         	kirim_karakter(posisi_long[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_posisi_long)
	SBCI R27,HIGH(-_posisi_long)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x26
_0x27:
; 0000 022F kirim_karakter('a');
	LDI  R30,LOW(97)
	RCALL SUBOPT_0x6
; 0000 0230 
; 0000 0231         kirim_karakter('/');
	LDI  R30,LOW(47)
	RCALL SUBOPT_0x6
; 0000 0232         kirim_karakter('A');
	LDI  R30,LOW(65)
	RCALL SUBOPT_0x6
; 0000 0233         kirim_karakter('=');
	LDI  R30,LOW(61)
	RCALL SUBOPT_0x6
; 0000 0234 
; 0000 0235         for(i=0;i<6;i++)
	LDI  R17,LOW(0)
_0x29:
	CPI  R17,6
	BRGE _0x2A
; 0000 0236                 kirim_karakter(altitude[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_altitude)
	SBCI R27,HIGH(-_altitude)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x29
_0x2A:
; 0000 0239 if(beacon_stat == 5)
	RCALL SUBOPT_0x4
	CPI  R30,LOW(0x5)
	BRNE _0x2B
; 0000 023A         {
; 0000 023B         	// kirimkan field informasi : data ekstensi tipe PHGD
; 0000 023C         	//for(i=0;i<7;i++)
; 0000 023D         	//	kirim_karakter(data_extension[i]);
; 0000 023E 
; 0000 023F                 // kirimkan field informasi : comment
; 0000 0240        		for(i=0;i<28;i++)
	LDI  R17,LOW(0)
_0x2D:
	CPI  R17,28
	BRGE _0x2E
; 0000 0241         		kirim_karakter(komentar[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_komentar)
	SBCI R27,HIGH(-_komentar)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x2D
_0x2E:
; 0000 0242 }
; 0000 0243 
; 0000 0244 
; 0000 0245         // label lompatan
; 0000 0246         lompat:
_0x2B:
_0x21:
; 0000 0247 
; 0000 0248         // kirimkan field : FCS (CRC-16 CCITT)
; 0000 0249         kirim_crc();
	RCALL _kirim_crc
; 0000 024A 
; 0000 024B         // kirimkan karakter closing flag
; 0000 024C         for(i=0;i<TX_TAIL_;i++)
	LDI  R17,LOW(0)
_0x30:
	CPI  R17,15
	BRGE _0x31
; 0000 024D         	kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x6
	SUBI R17,-1
	RJMP _0x30
_0x31:
; 0000 0250 delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0x5
; 0000 0251         PTT = 0;
	CBI  0x18,3
; 0000 0252 
; 0000 0253 
; 0000 0254 }       // EndOf void kirim_paket(void)
	LD   R17,Y+
	RET
;
;
;/***************************************************************************************/
;	void 			kirim_crc(void)
; 0000 0259 /***************************************************************************************
; 0000 025A *	ABSTRAKSI  	: 	Pengendali urutan pengiriman data CRC-16 CCITT Penyusun
; 0000 025B *				nilai 8 MSB dan 8 LSB dari nilai CRC yang telah dihitung.
; 0000 025C *				Generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
; 0000 025D *				leading one.
; 0000 025E *
; 0000 025F *      	INPUT		:	tak ada
; 0000 0260 *	OUTPUT		:       tak ada
; 0000 0261 *	RETURN		:       tak ada
; 0000 0262 */
; 0000 0263 {
_kirim_crc:
; 0000 0264 	static unsigned char crc_lo;
; 0000 0265 	static unsigned char crc_hi;
; 0000 0266 
; 0000 0267         // Exor-kan nilai CRC terakhir dengan 0xFF, masukkan ke 8 LSB
; 0000 0268         crc_lo = crc ^ 0xFF;
	LDI  R30,LOW(255)
	EOR  R30,R4
	STS  _crc_lo_S0000003000,R30
; 0000 0269 
; 0000 026A         // geser kanan 8 bit dan Exor-kan nilai CRC terakhir dengan 0xFF, masukkan ke 8 MSB
; 0000 026B         crc_hi = (crc >> 8) ^ 0xFF;
	MOV  R30,R5
	ANDI R31,HIGH(0x0)
	LDI  R26,LOW(255)
	EOR  R30,R26
	STS  _crc_hi_S0000003000,R30
; 0000 026C 
; 0000 026D         // kirim 8 LSB
; 0000 026E         kirim_karakter(crc_lo);
	LDS  R30,_crc_lo_S0000003000
	RCALL SUBOPT_0x6
; 0000 026F 
; 0000 0270         // kirim 8 MSB
; 0000 0271         kirim_karakter(crc_hi);
	LDS  R30,_crc_hi_S0000003000
	RCALL SUBOPT_0x6
; 0000 0272 
; 0000 0273 }       // EndOf void kirim_crc(void)
	RET
;
;
;/***************************************************************************************/
;	void 			kirim_karakter(unsigned char input)
; 0000 0278 /***************************************************************************************
; 0000 0279 *	ABSTRAKSI  	: 	mengirim data APRS karakter-demi-karakter, menghitung FCS
; 0000 027A *				field dan melakukan bit stuffing. Polarisasi data adalah
; 0000 027B *				NRZI (Non Return to Zero, Inverted). Bit dikirimkan sebagai
; 0000 027C *				bit terakhir yang ditahan jika bit masukan adalah bit 1.
; 0000 027D *				Bit dikirimkan sebagai bit terakhir yang di-invert jika bit
; 0000 027E *				masukan adalah bit 0. Tone 1200Hz dan 2200Hz masing - masing
; 0000 027F * 				merepresentasikan bit 0 dan 1 atau sebaliknya. Polarisasi
; 0000 0280 *				tone adalah tidak penting dalam polarisasi data NRZI.
; 0000 0281 *
; 0000 0282 *      	INPUT		:	byte data protokol APRS
; 0000 0283 *	OUTPUT		:       tak ada
; 0000 0284 *	RETURN		:       tak ada
; 0000 0285 */
; 0000 0286 {
_kirim_karakter:
	PUSH R15
; 0000 0287 	char i;
; 0000 0288 	bit in_bit;
; 0000 0289 
; 0000 028A         // kirimkan setiap byte data (8 bit)
; 0000 028B 	for(i=0;i<8;i++)
	ST   -Y,R17
;	input -> Y+1
;	i -> R17
;	in_bit -> R15.0
	LDI  R17,LOW(0)
_0x35:
	CPI  R17,8
	BRGE _0x36
; 0000 028C         {
; 0000 028D         	// ambil 1 bit berurutan dari LSB ke MSB setiap perulangan for 0 - 7
; 0000 028E                 in_bit = (input >> i) & 0x01;
	MOV  R30,R17
	LDD  R26,Y+1
	RCALL __LSRB12
	BST  R30,0
	BLD  R15,0
; 0000 028F 
; 0000 0290                 // jika data adalah flag, nol-kan pengingat bit stuffing
; 0000 0291                 if(input==0x7E)	{bit_stuff = 0;}
	CPI  R26,LOW(0x7E)
	BRNE _0x37
	RCALL SUBOPT_0x7
; 0000 0292 
; 0000 0293                 // jika bukan flag, hitung nilai CRC dari bit data saat ini
; 0000 0294                 else		{hitung_crc(in_bit);}
	RJMP _0x38
_0x37:
	LDI  R30,0
	SBRC R15,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _hitung_crc
_0x38:
; 0000 0295 
; 0000 0296                 // jika bit data saat ini adalah
; 0000 0297                 // nol
; 0000 0298                 if(!in_bit)
	SBRS R15,0
; 0000 0299                 {	// jika ya
; 0000 029A                 	// ubah tone dan bentuk gelombang sinus
; 0000 029B                         ubah_nada();
	RJMP _0x8C
; 0000 029C 
; 0000 029D                         // nol-kan pengingat bit stuffing
; 0000 029E                         bit_stuff = 0;
; 0000 029F                 }
; 0000 02A0                 // satu
; 0000 02A1                 else
; 0000 02A2                 {	// jika ya
; 0000 02A3                 	// jaga tone dan bentuk gelombang sinus
; 0000 02A4                         set_nada(nada);
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _set_nada
; 0000 02A5 
; 0000 02A6                         // hitung sebagai bit stuffing (bit satu berurut) tambahkan 1 nilai bit stuffing
; 0000 02A7                         bit_stuff++;
	LDS  R30,_bit_stuff_G000
	SUBI R30,-LOW(1)
	STS  _bit_stuff_G000,R30
; 0000 02A8 
; 0000 02A9                         // jika sudah terjadi bit satu berurut sebanyak 5 kali
; 0000 02AA                         if(bit_stuff==5)
	LDS  R26,_bit_stuff_G000
	CPI  R26,LOW(0x5)
	BRNE _0x3B
; 0000 02AB                         {
; 0000 02AC                         	// kirim bit nol :
; 0000 02AD                                 // ubah tone dan bentuk gelombang sinus
; 0000 02AE                                 ubah_nada();
_0x8C:
	RCALL _ubah_nada
; 0000 02AF 
; 0000 02B0                                 // nol-kan pengingat bit stuffing
; 0000 02B1                                 bit_stuff = 0;
	RCALL SUBOPT_0x7
; 0000 02B2 
; 0000 02B3                         }
; 0000 02B4                 }
_0x3B:
; 0000 02B5         }
	SUBI R17,-1
	RJMP _0x35
_0x36:
; 0000 02B6 
; 0000 02B7 }      // EndOf void kirim_karakter(unsigned char input)
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;
;/***************************************************************************************/
;	void 			hitung_crc(char in_crc)
; 0000 02BC /***************************************************************************************
; 0000 02BD *	ABSTRAKSI  	: 	menghitung nilai CRC-16 CCITT dari tiap bit data yang terkirim,
; 0000 02BE *				generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
; 0000 02BF *				leading one
; 0000 02C0 *
; 0000 02C1 *      	INPUT		:	bit data yang terkirim
; 0000 02C2 *	OUTPUT		:       tak ada
; 0000 02C3 *	RETURN		:       tak ada
; 0000 02C4 */
; 0000 02C5 {
_hitung_crc:
; 0000 02C6 	static unsigned short xor_in;
; 0000 02C7 
; 0000 02C8         // simpan nilai Exor dari CRC sementara dengan bit data yang baru terkirim
; 0000 02C9 	xor_in = crc ^ in_crc;
;	in_crc -> Y+0
	LD   R30,Y
	LDI  R31,0
	SBRC R30,7
	SER  R31
	EOR  R30,R4
	EOR  R31,R5
	STS  _xor_in_S0000005000,R30
	STS  _xor_in_S0000005000+1,R31
; 0000 02CA 
; 0000 02CB         // geser kanan nilai CRC sebanyak 1 bit
; 0000 02CC 	crc >>= 1;
	LSR  R5
	ROR  R4
; 0000 02CD 
; 0000 02CE         // jika hasil nilai Exor di-and-kan dengan satu bernilai satu
; 0000 02CF         if(xor_in & 0x01)
	LDS  R30,_xor_in_S0000005000
	ANDI R30,LOW(0x1)
	BREQ _0x3C
; 0000 02D0         	// maka nilai CRC di-Exor-kan dengan generator polinomial
; 0000 02D1                 crc ^= 0x8408;
	LDI  R30,LOW(33800)
	LDI  R31,HIGH(33800)
	__EORWRR 4,5,30,31
; 0000 02D2 
; 0000 02D3 }      // EndOf void hitung_crc(char in_crc)
_0x3C:
	RJMP _0x2060001
;
;
;/***************************************************************************************/
;	void 			ubah_nada(void)
; 0000 02D8 /***************************************************************************************
; 0000 02D9 *	ABSTRAKSI  	: 	Menukar seting tone terakhir dengan tone yang baru. Tone
; 0000 02DA *				1200Hz dan 2200Hz masing - masing merepresentasikan bit
; 0000 02DB *				0 dan 1 atau sebaliknya. Polarisasi tone adalah tidak
; 0000 02DC *				penting dalam polarisasi data NRZI.
; 0000 02DD *
; 0000 02DE *      	INPUT		:	tak ada
; 0000 02DF *	OUTPUT		:       tak ada
; 0000 02E0 *	RETURN		:       tak ada
; 0000 02E1 */
; 0000 02E2 {
_ubah_nada:
; 0000 02E3 	// jika tone terakhir adalah :
; 0000 02E4         // 1200Hz
; 0000 02E5         if(nada ==_1200)
	SBIC 0x13,0
	RJMP _0x3D
; 0000 02E6 	{	// jika ya
; 0000 02E7         	// ubah tone saat ini menjadi 2200Hz
; 0000 02E8                 nada = _2200;
	SBI  0x13,0
; 0000 02E9 
; 0000 02EA                 // bangkitkan gelombang sinus 2200Hz
; 0000 02EB         	set_nada(nada);
	RJMP _0x8D
; 0000 02EC 	}
; 0000 02ED         // 2200Hz
; 0000 02EE         else
_0x3D:
; 0000 02EF         {	// jika ya
; 0000 02F0         	// ubah tone saat ini menjadi 1200Hz
; 0000 02F1                 nada = _1200;
	CBI  0x13,0
; 0000 02F2 
; 0000 02F3                 // bangkitkan gelombang sinus 1200Hz
; 0000 02F4         	set_nada(nada);
_0x8D:
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _set_nada
; 0000 02F5         }
; 0000 02F6 
; 0000 02F7 }       // EndOf void ubah_nada(void)
	RET
;
;
;/***************************************************************************************/
;	void 			set_dac(char value)
; 0000 02FC /***************************************************************************************
; 0000 02FD *	ABSTRAKSI  	: 	Men-set dan reset output DAC sebagai bilangan biner yang
; 0000 02FE *				merepresentasikan nilai diskrit dari gelombang sinus yang
; 0000 02FF *				sedang dibentuk saat ini sehingga membentuk tegangan sampling
; 0000 0300 *				dari gelombang.
; 0000 0301 *
; 0000 0302 *      	INPUT		:	nilai matrix rekonstruksi diskrit gelombang sinusoid
; 0000 0303 *	OUTPUT		:       DAC 0 - 3, tegangan kontinyu pada output Low Pass Filter
; 0000 0304 *	RETURN		:       tak ada
; 0000 0305 */
; 0000 0306 {
_set_dac:
; 0000 0307 	// ambil nilai LSB dari matrix rekonstruksi dan set sebagai DAC-0
; 0000 0308         DAC_0 = value & 0x01;
;	value -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x43
	CBI  0x18,7
	RJMP _0x44
_0x43:
	SBI  0x18,7
_0x44:
; 0000 0309 
; 0000 030A         // ambil nilai dari matrix rekonstruksi, geser kanan 1 bit, ambil bit paling kanan
; 0000 030B         	// dan set sebagai DAC-1
; 0000 030C         DAC_1 =( value >> 1 ) & 0x01;
	LD   R30,Y
	ASR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x45
	CBI  0x18,6
	RJMP _0x46
_0x45:
	SBI  0x18,6
_0x46:
; 0000 030D 
; 0000 030E         // ambil nilai dari matrix rekonstruksi, geser kanan 2 bit, ambil bit paling kanan
; 0000 030F         	// dan set sebagai DAC-2
; 0000 0310         DAC_2 =( value >> 2 ) & 0x01;
	LD   R30,Y
	ASR  R30
	ASR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x47
	CBI  0x18,5
	RJMP _0x48
_0x47:
	SBI  0x18,5
_0x48:
; 0000 0311 
; 0000 0312         // ambil nilai dari matrix rekonstruksi, geser kanan 3 bit, ambil bit tersebut dan
; 0000 0313         	// set sebagai DAC-3 (MSB)
; 0000 0314         DAC_3 =( value >> 3 ) & 0x01;
	LD   R30,Y
	ASR  R30
	ASR  R30
	ASR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x49
	CBI  0x18,4
	RJMP _0x4A
_0x49:
	SBI  0x18,4
_0x4A:
; 0000 0315 
; 0000 0316 }      	// EndOf void set_dac(char value)
_0x2060001:
	ADIW R28,1
	RET
;
;
;/***************************************************************************************/
;	void 			set_nada(char i_nada)
; 0000 031B /***************************************************************************************
; 0000 031C *	ABSTRAKSI  	: 	Membentuk baudrate serta frekensi tone 1200Hz dan 2200Hz
; 0000 031D *				dari konstanta waktu. Men-setting nilai DAC. Lakukan fine
; 0000 031E *				tuning pada jumlah masing - masing perulangan for dan
; 0000 031F *				konstanta waktu untuk meng-adjust parameter baudrate dan
; 0000 0320 *				frekuensi tone.
; 0000 0321 *
; 0000 0322 *      	INPUT		:	nilai frekuensi tone yang akan ditransmisikan
; 0000 0323 *	OUTPUT		:       nilai DAC
; 0000 0324 *	RETURN		:       tak ada
; 0000 0325 */
; 0000 0326 {
_set_nada:
; 0000 0327 	char i;
; 0000 0328 
; 0000 0329         // jika frekuensi tone yang akan segera dipancarkan adalah :
; 0000 032A         // 1200Hz
; 0000 032B 	if(i_nada == _1200)
	ST   -Y,R17
;	i_nada -> Y+1
;	i -> R17
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x4B
; 0000 032C     	{
; 0000 032D         	// jika ya
; 0000 032E         	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x4D:
	CPI  R17,16
	BRGE _0x4E
; 0000 032F         	{
; 0000 0330                 	// set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 0331                 		// dan urutan perulangan for 0 - 15
; 0000 0332                 	set_dac(matrix[i]);
	RCALL SUBOPT_0xA
; 0000 0333 
; 0000 0334                         // bangkitkan frekuensi 1200Hz dari konstanta waktu
; 0000 0335         		delay_us(CONST_1200);
	__DELAY_USB 170
; 0000 0336         	}
	SUBI R17,-1
	RJMP _0x4D
_0x4E:
; 0000 0337     	}
; 0000 0338         // 2200Hz
; 0000 0339     	else
	RJMP _0x4F
_0x4B:
; 0000 033A     	{
; 0000 033B         	// jika ya
; 0000 033C         	for(i=0; i<15; i++)
	LDI  R17,LOW(0)
_0x51:
	CPI  R17,15
	BRGE _0x52
; 0000 033D         	{
; 0000 033E                 	// set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 033F                 		// dan urutan perulangan for 0 - 15
; 0000 0340                 	set_dac(matrix[i]);
	RCALL SUBOPT_0xA
; 0000 0341 
; 0000 0342                         // bangkitkan frekuensi 2200Hz dari konstanta waktu
; 0000 0343                 	delay_us(CONST_2200);
	__DELAY_USB 92
; 0000 0344                 }
	SUBI R17,-1
	RJMP _0x51
_0x52:
; 0000 0345                 // sekali lagi, untuk mengatur baudrate lakukan fine tune pada jumlah for
; 0000 0346                 for(i=0; i<12; i++)
	LDI  R17,LOW(0)
_0x54:
	CPI  R17,12
	BRGE _0x55
; 0000 0347                 {
; 0000 0348                 	// set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 0349                 		// dan urutan perulangan for
; 0000 034A                 	set_dac(matrix[i]);
	RCALL SUBOPT_0xA
; 0000 034B 
; 0000 034C                         // bangkitkan frekuensi 2200Hz dari konstanta waktu
; 0000 034D                 	delay_us(CONST_2200);
	__DELAY_USB 92
; 0000 034E                 }
	SUBI R17,-1
	RJMP _0x54
_0x55:
; 0000 034F     	}
_0x4F:
; 0000 0350 
; 0000 0351 } 	// EndOf void set_nada(char i_nada)
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;
;/***************************************************************************************/
;	void 			getComma(void)
; 0000 0356 /***************************************************************************************
; 0000 0357 *	ABSTRAKSI  	: 	Menunggu data RX serial berupa karakter koma dan segera
; 0000 0358 *				kembali pada fungsi yang memanggilnya.
; 0000 0359 *
; 0000 035A *      	INPUT		:	RX data serial $GPGLL gps
; 0000 035B *	OUTPUT		:       tak ada
; 0000 035C *	RETURN		:       tak ada
; 0000 035D */
; 0000 035E {
_getComma:
; 0000 035F 	// jika data yang diterima bukan karakter koma, terima terus
; 0000 0360         	// jika data yang diterima adalah koma, keluar
; 0000 0361         while(getchar() != ',');
_0x56:
	RCALL _getchar
	CPI  R30,LOW(0x2C)
	BRNE _0x56
; 0000 0362 
; 0000 0363 }      	// EndOf void getComma(void)
	RET
;
;
;/***************************************************************************************/
;	void 			ekstrak_gps(void)
; 0000 0368 /***************************************************************************************
; 0000 0369 *	ABSTRAKSI  	: 	Menunggu interupsi RX data serial dari USART, memparsing
; 0000 036A *				data $GPGLL yang diterima menjadi data posisi, dan mengupdate
; 0000 036B *				data variabel posisi.
; 0000 036C *
; 0000 036D *      	INPUT		:	RX data serial $GPGLL gps
; 0000 036E *	OUTPUT		:       tak ada
; 0000 036F *	RETURN		:       tak ada
; 0000 0370 */
; 0000 0371 {
_ekstrak_gps:
; 0000 0372 	int i,j;
; 0000 0373         static char buff_posisi[17], buff_altitude[9];
; 0000 0374         unsigned int n_altitude[6];
; 0000 0375 
; 0000 0376         /************************************************************************************************
; 0000 0377         	$GPGLL - GLL - Geographic Position Latitude / Longitude
; 0000 0378 
; 0000 0379                 Contoh : $GPGLL,3723.2475,N,12158.3416,W,161229.487,A*2C
; 0000 037A 
; 0000 037B         |-----------------------------------------------------------------------------------------------|
; 0000 037C         |	Nama		| 	Contoh		|		Deskripsi			|
; 0000 037D         |-----------------------|-----------------------|-----------------------------------------------|
; 0000 037E         |	Message ID	|	$GPGLL		|	header protokol GLL			|
; 0000 037F         |	Latitude	|	3723.2475	|	ddmm.mmmm 	, d=degree, m=minute	|
; 0000 0380         |	N/S indicator	|	N		|	N=utara, S=selatan			|
; 0000 0381         |	Longitude	|	12158.3416	|	dddmm.mmmm	, d=degree, m=minute	|
; 0000 0382         |	W/E indicator	|	W		|	W=barat, E=timur			|
; 0000 0383         |	Waktu UTC (GMT)	|	161229.487	|	HHMMSS.SS  ,H=hour, M=minute, S=second	|
; 0000 0384         |	Status		|	A		|	A=data valid, V=data invalid		|
; 0000 0385         |	Checksum	|	*2C		|						|
; 0000 0386         |-----------------------------------------------------------------------------------------------|
; 0000 0387 
; 0000 0388         	Sumber : GPS SiRF EM-406A datasheet
; 0000 0389 
; 0000 038A         *************************************************************************************************/
; 0000 038B 
; 0000 038C         // jika data yang diterima bukan karakter $, terima terus
; 0000 038D         	// jika data yang diterima adalah $, lanjutkan
; 0000 038E         while(getchar() != '$');
	SBIW R28,12
	RCALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
;	n_altitude -> Y+4
_0x59:
	RCALL _getchar
	CPI  R30,LOW(0x24)
	BRNE _0x59
; 0000 038F 
; 0000 0390         // tunggu dan terima data tanpa proses lebih lanjut (lewatkan karakter G)
; 0000 0391 	getchar();
	RCALL _getchar
; 0000 0392 
; 0000 0393         // tunggu dan terima data tanpa proses lebih lanjut (lewatkan karakter P)
; 0000 0394         getchar();
	RCALL _getchar
; 0000 0395 
; 0000 0396         // tunggu data, jika yang diterima adalah karakter G
; 0000 0397         if(getchar() == 'G')
	RCALL _getchar
	CPI  R30,LOW(0x47)
	BREQ PC+2
	RJMP _0x5C
; 0000 0398         {
; 0000 0399         	// maka
; 0000 039A         	// tunggu data, jika yang diterima adalah karakter G
; 0000 039B                 if(getchar() == 'G')
	RCALL _getchar
	CPI  R30,LOW(0x47)
	BREQ PC+2
	RJMP _0x5D
; 0000 039C         	{
; 0000 039D                 	// maka
; 0000 039E                         // tunggu data, jika yang diterima adalah karakter A
; 0000 039F                         if(getchar() == 'A')
	RCALL _getchar
	CPI  R30,LOW(0x41)
	BREQ PC+2
	RJMP _0x5E
; 0000 03A0                 	{
; 0000 03A1                         	// maka
; 0000 03A2                                 // tunggu koma dan lanjutkan
; 0000 03A3                                 getComma();
	RCALL _getComma
; 0000 03A4                                 getComma();
	RCALL _getComma
; 0000 03A5 
; 0000 03A6                                 // ambil 7 byte data berurut dan masukkan dalam buffer data
; 0000 03A7                         	for(i=0; i<7; i++)	buff_posisi[i] = getchar();
	RCALL SUBOPT_0xB
_0x60:
	__CPWRN 16,17,7
	BRGE _0x61
	MOV  R30,R16
	SUBI R30,-LOW(_buff_posisi_S000000A000)
	PUSH R30
	RCALL _getchar
	POP  R26
	ST   X,R30
	RCALL SUBOPT_0xC
	RJMP _0x60
_0x61:
; 0000 03AA getComma();
	RCALL _getComma
; 0000 03AB 
; 0000 03AC                                 // ambil 1 byte data dan masukkan dalam buffer data
; 0000 03AD                                 buff_posisi[7] = getchar();
	RCALL _getchar
	__PUTB1MN _buff_posisi_S000000A000,7
; 0000 03AE 
; 0000 03AF                                 // tunggu koma dan lanjutkan
; 0000 03B0                                 getComma();
	RCALL _getComma
; 0000 03B1 
; 0000 03B2                                 // ambil 8 byte data berurut dan masukkan dalam buffer data
; 0000 03B3                                 for(i=0; i<8; i++)	buff_posisi[i+8] = getchar();
	RCALL SUBOPT_0xB
_0x63:
	RCALL SUBOPT_0xD
	BRGE _0x64
	MOV  R30,R16
	__ADDB1MN _buff_posisi_S000000A000,8
	PUSH R30
	RCALL _getchar
	POP  R26
	ST   X,R30
	RCALL SUBOPT_0xC
	RJMP _0x63
_0x64:
; 0000 03B6 getComma();
	RCALL _getComma
; 0000 03B7 
; 0000 03B8                                 // ambil 1 byte data dan masukkan dalam buffer data
; 0000 03B9                                 buff_posisi[16] = getchar();
	RCALL _getchar
	__PUTB1MN _buff_posisi_S000000A000,16
; 0000 03BA 
; 0000 03BB                                 // tunggu dan lewatkan 3 koma
; 0000 03BC                                 getComma();
	RCALL _getComma
; 0000 03BD                                 getComma();
	RCALL _getComma
; 0000 03BE                                 getComma();
	RCALL _getComma
; 0000 03BF                                 getComma();
	RCALL _getComma
; 0000 03C0 
; 0000 03C1                                 // ambil 8 byte data ketinggian dalam meter
; 0000 03C2                                 for(i=0;i<8;i++)        buff_altitude[i] = getchar();
	RCALL SUBOPT_0xB
_0x66:
	RCALL SUBOPT_0xD
	BRGE _0x67
	MOV  R30,R16
	SUBI R30,-LOW(_buff_altitude_S000000A000)
	PUSH R30
	RCALL _getchar
	POP  R26
	ST   X,R30
	RCALL SUBOPT_0xC
	RJMP _0x66
_0x67:
; 0000 03C5 for(i=0;i<8;i++)	{posisi_lat[i]=buff_posisi[i];}
	RCALL SUBOPT_0xB
_0x69:
	RCALL SUBOPT_0xD
	BRGE _0x6A
	MOVW R30,R16
	SUBI R30,LOW(-_posisi_lat)
	SBCI R31,HIGH(-_posisi_lat)
	MOVW R0,R30
	LDI  R26,LOW(_buff_posisi_S000000A000)
	ADD  R26,R16
	LD   R30,X
	MOVW R26,R0
	RCALL __EEPROMWRB
	RCALL SUBOPT_0xC
	RJMP _0x69
_0x6A:
; 0000 03C6         			for(i=0;i<9;i++)	{posisi_long[i]=buff_posisi[i+8];}
	RCALL SUBOPT_0xB
_0x6C:
	__CPWRN 16,17,9
	BRGE _0x6D
	MOVW R26,R16
	SUBI R26,LOW(-_posisi_long)
	SBCI R27,HIGH(-_posisi_long)
	MOV  R30,R16
	__ADDB1MN _buff_posisi_S000000A000,8
	LD   R30,Z
	RCALL __EEPROMWRB
	RCALL SUBOPT_0xC
	RJMP _0x6C
_0x6D:
; 0000 03C7 
; 0000 03C8                                 // nol-kan variable ketinggian
; 0000 03C9                                 for(i=0;i<6;i++)        n_altitude[i] = '0';
	RCALL SUBOPT_0xB
_0x6F:
	RCALL SUBOPT_0xE
	BRGE _0x70
	RCALL SUBOPT_0xF
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   X+,R30
	ST   X,R31
	RCALL SUBOPT_0xC
	RJMP _0x6F
_0x70:
; 0000 03CC for(i=0;i<8;i++)
	RCALL SUBOPT_0xB
_0x72:
	RCALL SUBOPT_0xD
	BRGE _0x73
; 0000 03CD                                 {
; 0000 03CE                                         if(buff_altitude[i] == '.')     goto selesai;
	RCALL SUBOPT_0x10
	BREQ _0x75
; 0000 03CF                                         if((buff_altitude[i] != '.')&&(buff_altitude[i] != ',')&&(buff_altitude[i] != 'M'))
	RCALL SUBOPT_0x10
	BREQ _0x77
	LDI  R26,LOW(_buff_altitude_S000000A000)
	ADD  R26,R16
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BREQ _0x77
	LDI  R26,LOW(_buff_altitude_S000000A000)
	ADD  R26,R16
	LD   R26,X
	CPI  R26,LOW(0x4D)
	BRNE _0x78
_0x77:
	RJMP _0x76
_0x78:
; 0000 03D0                                         {
; 0000 03D1                                                 // geser dari satuan ke puluhan dst.
; 0000 03D2                                                 for(j=0;j<6;j++)        n_altitude[j] = n_altitude[j+1];
	__GETWRN 18,19,0
_0x7A:
	__CPWRN 18,19,6
	BRGE _0x7B
	MOV  R30,R18
	MOV  R26,R28
	SUBI R26,-(4)
	LSL  R30
	ADD  R30,R26
	MOV  R0,R30
	MOV  R30,R18
	SUBI R30,-LOW(1)
	MOV  R26,R28
	SUBI R26,-(4)
	LSL  R30
	ADD  R26,R30
	RCALL __GETW1P
	MOV  R26,R0
	ST   X+,R30
	ST   X,R31
	__ADDWRN 18,19,1
	RJMP _0x7A
_0x7B:
; 0000 03D5 n_altitude[5] = buff_altitude[i];
	LDI  R26,LOW(_buff_altitude_S000000A000)
	ADD  R26,R16
	LD   R30,X
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RCALL SUBOPT_0x11
; 0000 03D6                                         }
; 0000 03D7                                 }
_0x76:
	RCALL SUBOPT_0xC
	RJMP _0x72
_0x73:
; 0000 03D8 
; 0000 03D9                                 selesai:
_0x75:
; 0000 03DA 
; 0000 03DB                                 // atoi
; 0000 03DC                                 for(i=0;i<6;i++)        n_altitude[i] -= '0';
	RCALL SUBOPT_0xB
_0x7D:
	RCALL SUBOPT_0xE
	BRGE _0x7E
	RCALL SUBOPT_0xF
	LD   R30,X+
	LD   R31,X+
	SBIW R30,48
	ST   -X,R31
	ST   -X,R30
	RCALL SUBOPT_0xC
	RJMP _0x7D
_0x7E:
; 0000 03DF n_altitude[0] *= 100000;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDI  R26,LOW(34464)
	LDI  R27,HIGH(34464)
	RCALL __MULW12U
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 03E0                                 n_altitude[1] *=  10000;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL __MULW12U
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 03E1                                 n_altitude[2] *=   1000;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL __MULW12U
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 03E2                                 n_altitude[3] *=    100;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	RCALL __MULW12U
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 03E3                                 n_altitude[4] *=     10;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12U
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 03E4 
; 0000 03E5                                 // jumlahkan satuan + puluhan + ratusan dst.
; 0000 03E6                                 n_altitude[5] += (n_altitude[0] + n_altitude[1] + n_altitude[2] + n_altitude[3] + n_altitude[4]);
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	RCALL SUBOPT_0x12
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	RCALL SUBOPT_0x12
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	RCALL SUBOPT_0x12
	LDD  R26,Y+12
	LDD  R27,Y+12+1
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x12
	RCALL SUBOPT_0x11
; 0000 03E7 
; 0000 03E8                                 // meter to feet
; 0000 03E9                                 n_altitude[5] *= 3;
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __MULW12U
	RCALL SUBOPT_0x14
; 0000 03EA 
; 0000 03EB                                 // num to 'string'
; 0000 03EC                                 n_altitude[0] = n_altitude[5] / 100000;
	RCALL SUBOPT_0x15
	RCALL __DIVD21U
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 03ED                                 n_altitude[5] %= 100000;
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x15
	RCALL __MODD21U
	RCALL SUBOPT_0x14
; 0000 03EE 
; 0000 03EF                                 n_altitude[1] = n_altitude[5] / 10000;
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	RCALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 03F0                                 n_altitude[5] %= 10000;
	RCALL SUBOPT_0x13
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	RCALL __MODW21U
	RCALL SUBOPT_0x14
; 0000 03F1 
; 0000 03F2                                 n_altitude[2] = n_altitude[5] / 1000;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 03F3                                 n_altitude[5] %= 1000;
	RCALL SUBOPT_0x13
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MODW21U
	RCALL SUBOPT_0x14
; 0000 03F4 
; 0000 03F5                                 n_altitude[3] = n_altitude[5] / 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 03F6                                 n_altitude[5] %= 100;
	RCALL SUBOPT_0x13
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21U
	RCALL SUBOPT_0x14
; 0000 03F7 
; 0000 03F8                                 n_altitude[4] = n_altitude[5] / 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 03F9                                 n_altitude[5] %= 10;
	RCALL SUBOPT_0x13
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	RCALL SUBOPT_0x11
; 0000 03FA 
; 0000 03FB                                 // itoa, pindahkan dari variable numerik ke eeprom
; 0000 03FC                                 for(i=0;i<6;i++)        altitude[i] = (char)(n_altitude[i] + '0');
	RCALL SUBOPT_0xB
_0x80:
	RCALL SUBOPT_0xE
	BRGE _0x81
	MOVW R30,R16
	SUBI R30,LOW(-_altitude)
	SBCI R31,HIGH(-_altitude)
	MOVW R0,R30
	RCALL SUBOPT_0xF
	LD   R30,X
	SUBI R30,-LOW(48)
	MOVW R26,R0
	RCALL __EEPROMWRB
	RCALL SUBOPT_0xC
	RJMP _0x80
_0x81:
; 0000 03FD }
; 0000 03FE                 }
_0x5E:
; 0000 03FF         }
_0x5D:
; 0000 0400 
; 0000 0401 } 	// EndOf void ekstrak_gps(void)
_0x5C:
	RCALL __LOADLOCR4
	ADIW R28,16
	RET
;
;
;/***************************************************************************************/
;	void main(void)
; 0000 0406 /***************************************************************************************
; 0000 0407 *
; 0000 0408 *	MAIN PROGRAM
; 0000 0409 *
; 0000 040A */
; 0000 040B {
_main:
; 0000 040C 	// pengaturan clock CPU dan menjaga agar kompatibel dengan versi code vision terdahulu
; 0000 040D #pragma optsize-
; 0000 040E 	CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 040F 	CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0410 	#ifdef _OPTIMIZE_SIZE_
; 0000 0411 #pragma optsize+
; 0000 0412 	#endif
; 0000 0413 
; 0000 0414         // set bit register PORTB
; 0000 0415         PORTB=0x00;
	OUT  0x18,R30
; 0000 0416 
; 0000 0417         // set bit Data Direction Register PORTB
; 0000 0418 	DDRB=0xF8;
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 0419 
; 0000 041A         // set bit register PORTD
; 0000 041B         PORTD=0x09;
	LDI  R30,LOW(9)
	OUT  0x12,R30
; 0000 041C 
; 0000 041D         // set bit Data Direction Register PORTD
; 0000 041E 	DDRD=0x30;
	LDI  R30,LOW(48)
	OUT  0x11,R30
; 0000 041F 
; 0000 0420         // set parameter 4800baud, 8, N, 1
; 0000 0421         UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0422 	UCSRB=0x10;
	LDI  R30,LOW(16)
	OUT  0xA,R30
; 0000 0423 	UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 0424 	UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 0425 	UBRRL=0x8F;
	LDI  R30,LOW(143)
	OUT  0x9,R30
; 0000 0426 
; 0000 0427         // set register Analog Comparator
; 0000 0428         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 0429 
; 0000 042A         // set register EXT_IRQ_1 (External Interrupt 1 Request), Low Interrupt
; 0000 042B 	GIMSK=0x80;
	OUT  0x3B,R30
; 0000 042C 	MCUCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0000 042D 	EIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 042E 
; 0000 042F         // set register Timer 1, System clock 10.8kHz, Timer 1 overflow
; 0000 0430 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 0431 
; 0000 0432         // set konstanta waktu 5 detik sebagai awalan
; 0000 0433         //timer_detik(INITIAL_TIME_C);
; 0000 0434         TCNT1H = 0xAB;
	RCALL SUBOPT_0x3
; 0000 0435         TCNT1L = 0xA0;
; 0000 0436 
; 0000 0437         // set interupsi timer untuk Timer 1
; 0000 0438         TIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x39,R30
; 0000 0439 
; 0000 043A         xcount = 0;
	CLR  R3
; 0000 043B 
; 0000 043C         // indikator awalan hardware aktif :
; 0000 043D         // nyalakan LED busy
; 0000 043E         L_BUSY = 1;
	SBI  0x12,5
; 0000 043F 
; 0000 0440         // tunggu 500ms
; 0000 0441         delay_ms(500);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5
; 0000 0442 
; 0000 0443         // nyalakan LED standby
; 0000 0444         L_STBY = 1;
	SBI  0x12,4
; 0000 0445 
; 0000 0446         // tunggu 500ms
; 0000 0447         delay_ms(500);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5
; 0000 0448 
; 0000 0449         // matikan LED busy
; 0000 044A         L_BUSY = 0;
	CBI  0x12,5
; 0000 044B 
; 0000 044C         // tunggu 500ms
; 0000 044D         delay_ms(500);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5
; 0000 044E 
; 0000 044F         // aktifkan interupsi global (berdasar setting register)
; 0000 0450         #asm("sei")
	sei
; 0000 0451 
; 0000 0452         // tidak lakukan apapun selain menunggu interupsi timer1_ovf_isr
; 0000 0453         while (1)
_0x88:
; 0000 0454         {
; 0000 0455         	// blok ini kosong
; 0000 0456         };
	RJMP _0x88
; 0000 0457 
; 0000 0458 }	// END OF MAIN PROGRAM
_0x8B:
	RJMP _0x8B
;/*
;*
;*	END OF FILE
;*
;****************************************************************************************/
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
	.DB  LOW(0xA6A4A082),HIGH(0xA6A4A082),BYTE3(0xA6A4A082),BYTE4(0xA6A4A082)
	.DB  LOW(0xB2604040),HIGH(0xB2604040),BYTE3(0xB2604040),BYTE4(0xB2604040)
	.DB  LOW(0xB2B46486),HIGH(0xB2B46486),BYTE3(0xB2B46486),BYTE4(0xB2B46486)
	.DB  LOW(0x92AE628A),HIGH(0x92AE628A),BYTE3(0x92AE628A),BYTE4(0x92AE628A)
	.DB  LOW(0x40648A88),HIGH(0x40648A88),BYTE3(0x40648A88),BYTE4(0x40648A88)
	.DB  0x65
_posisi_lat:
	.DB  LOW(0x30303030),HIGH(0x30303030),BYTE3(0x30303030),BYTE4(0x30303030)
	.DB  LOW(0x3030302E),HIGH(0x3030302E),BYTE3(0x3030302E),BYTE4(0x3030302E)
_posisi_long:
	.DB  LOW(0x30303030),HIGH(0x30303030),BYTE3(0x30303030),BYTE4(0x30303030)
	.DB  LOW(0x30302E30),HIGH(0x30302E30),BYTE3(0x30302E30),BYTE4(0x30302E30)
	.DB  0x45
_altitude:
	.BYTE 0x6
_komentar:
	.DB  LOW(0x45524F43),HIGH(0x45524F43),BYTE3(0x45524F43),BYTE4(0x45524F43)
	.DB  LOW(0x44524F20),HIGH(0x44524F20),BYTE3(0x44524F20),BYTE4(0x44524F20)
	.DB  LOW(0x49442041),HIGH(0x49442041),BYTE3(0x49442041),BYTE4(0x49442041)
	.DB  LOW(0x6D412059),HIGH(0x6D412059),BYTE3(0x6D412059),BYTE4(0x6D412059)
	.DB  LOW(0x616C7562),HIGH(0x616C7562),BYTE3(0x616C7562),BYTE4(0x616C7562)
	.DB  LOW(0x2065636E),HIGH(0x2065636E),BYTE3(0x2065636E),BYTE4(0x2065636E)
	.DB  LOW(0x20202020),HIGH(0x20202020),BYTE3(0x20202020),BYTE4(0x20202020)
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
_buff_altitude_S000000A000:
	.BYTE 0x9

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
	RJMP _kirim_paket

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(171)
	OUT  0x2D,R30
	LDI  R30,LOW(160)
	OUT  0x2C,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x4:
	LDI  R26,LOW(_beacon_stat)
	LDI  R27,HIGH(_beacon_stat)
	RCALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x5:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 19 TIMES, CODE SIZE REDUCTION:16 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:14 WORDS
SUBOPT_0xA:
	MOV  R30,R17
	LDI  R31,0
	SUBI R30,LOW(-_matrix*2)
	SBCI R31,HIGH(-_matrix*2)
	LPM  R30,Z
	ST   -Y,R30
	RJMP _set_dac

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xB:
	__GETWRN 16,17,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xC:
	__ADDWRN 16,17,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xD:
	__CPWRN 16,17,8
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	__CPWRN 16,17,6
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xF:
	MOV  R30,R16
	MOV  R26,R28
	SUBI R26,-(4)
	LSL  R30
	ADD  R26,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x10:
	LDI  R26,LOW(_buff_altitude_S000000A000)
	ADD  R26,R16
	LD   R26,X
	CPI  R26,LOW(0x2E)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	STD  Y+14,R30
	STD  Y+14+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x12:
	ADD  R30,R26
	ADC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x13:
	LDD  R26,Y+14
	LDD  R27,Y+14+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x14:
	RCALL SUBOPT_0x11
	RJMP SUBOPT_0x13

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x15:
	CLR  R24
	CLR  R25
	__GETD1N 0x186A0
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

__DIVB21U:
	CLR  R0
	LDI  R25,8
__DIVB21U1:
	LSL  R26
	ROL  R0
	SUB  R0,R30
	BRCC __DIVB21U2
	ADD  R0,R30
	RJMP __DIVB21U3
__DIVB21U2:
	SBR  R26,1
__DIVB21U3:
	DEC  R25
	BRNE __DIVB21U1
	MOV  R30,R26
	MOV  R26,R0
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

__DIVD21U:
	PUSH R19
	PUSH R20
	PUSH R21
	CLR  R0
	CLR  R1
	CLR  R20
	CLR  R21
	LDI  R19,32
__DIVD21U1:
	LSL  R26
	ROL  R27
	ROL  R24
	ROL  R25
	ROL  R0
	ROL  R1
	ROL  R20
	ROL  R21
	SUB  R0,R30
	SBC  R1,R31
	SBC  R20,R22
	SBC  R21,R23
	BRCC __DIVD21U2
	ADD  R0,R30
	ADC  R1,R31
	ADC  R20,R22
	ADC  R21,R23
	RJMP __DIVD21U3
__DIVD21U2:
	SBR  R26,1
__DIVD21U3:
	DEC  R19
	BRNE __DIVD21U1
	MOVW R30,R26
	MOVW R22,R24
	MOVW R26,R0
	MOVW R24,R20
	POP  R21
	POP  R20
	POP  R19
	RET

__MODB21:
	CLT
	SBRS R26,7
	RJMP __MODB211
	NEG  R26
	SET
__MODB211:
	SBRC R30,7
	NEG  R30
	RCALL __DIVB21U
	MOV  R30,R26
	BRTC __MODB212
	NEG  R30
__MODB212:
	RET

__MODW21U:
	RCALL __DIVW21U
	MOVW R30,R26
	RET

__MODD21U:
	RCALL __DIVD21U
	MOVW R30,R26
	MOVW R22,R24
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	DEC  R26
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
