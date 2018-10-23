
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

_0x92:
	.DB  0x0

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x03
	.DW  _0x92*2

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
;#define GAP_TIME_	30
;
;// konstanta waktu opening flag
;#define TX_DELAY_	45
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
;// definisi konstanta karakter simbol tabel dan overlay (\)
;#define SYM_TAB_OVL_	'\\'
;
;// definisi konstanta karakter simbol station (Area Locns)
;#define SYM_CODE_	'l'
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
;        ('A'<<1),('P'<<1),('R'<<1),('S'<<1),(' '<<1),(' '<<1),(' '<<1),
;
;        // source field, tergeser kiri 1 bit
;	('Y'<<1),('D'<<1),('2'<<1),('X'<<1),('A'<<1),('C'<<1),('6'<<1),
;
;        // path, tergeser kiri 1 bit
;        ('W'<<1),('I'<<1),('D'<<1),('E'<<1),('2'<<1),(' '<<1),('2'<<1)+1
;};
;
;// variabel penyimpan data awal posisi lintang dan update data gps
;eeprom char posisi_lat[8] =
;{
;	// latitude
;        '0','7','4','3','.','3','1','S'
;};
;
;// variabel penyimpan data awal posisi bujur dan update data gps
;eeprom char posisi_long[9] =
;{
;	// longitude
;        '1','1','0','2','3','.','5','2','E'
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
;eeprom char komentar[18] =
;{
;	// komentar
;        //'L','a','b','.','S','S','T','K',' ','T','i','m','-','1'
;        //':',':',':',' ','1','4','4','.','3','9','0','M','H','z',' ',':',':',':'
;        'C','O','R','E',' ','O','R','D','A',' ','D','I','Y',' ',' ',' ',' ',' '
;
;};
;
;// variabel penyimpan konstanta string status
;eeprom char status[47] =
;{
;	// status teks
;        'A','T','t','i','n','y','2','3','1','3',' ',
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
; 0000 0174 /***************************************************************************************
; 0000 0175 *	ABSTRAKSI	:	interupsi eksternal, ketika input TX_NOW bernilai LOW,
; 0000 0176 *				[EXT_INT1] aktif
; 0000 0177 *
; 0000 0178 *      	INPUT		:	input TX_NOW
; 0000 0179 *	OUTPUT		:       LED standby dan LED busy
; 0000 017A *	RETURN		:       tak ada
; 0000 017B */
; 0000 017C {

	.CSEG
_ext_int1_isr:
	RCALL SUBOPT_0x0
; 0000 017D 	// matikan LED standby
; 0000 017E         L_STBY = 0;
; 0000 017F 
; 0000 0180         // tunggu 250ms (bounce switch)
; 0000 0181         delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	RCALL SUBOPT_0x1
; 0000 0182 
; 0000 0183         // kirim paket data
; 0000 0184         kirim_paket();
; 0000 0185 
; 0000 0186         // nyalakan LED standby
; 0000 0187         L_STBY = 1;
	SBI  0x12,4
; 0000 0188 
; 0000 0189 } 	// EndOf interrupt [EXT_INT1] void ext_int1_isr(void)
	RJMP _0x91
;
;
;/***************************************************************************************/
;	interrupt 		[TIM1_OVF] void timer1_ovf_isr(void)
; 0000 018E /***************************************************************************************
; 0000 018F *	ABSTRAKSI  	: 	interupsi overflow TIMER 1 [TIM1_OVF], di-set overflow
; 0000 0190 *				ketika waktu telah mencapai 1 detik. Pengendali urutan
; 0000 0191 *				waktu (timeline)antara transmisi data APRS dan parsing
; 0000 0192 *				data gps
; 0000 0193 *
; 0000 0194 *      	INPUT		:	tak ada
; 0000 0195 *	OUTPUT		:       kondisi LED standby dan LED busy
; 0000 0196 *	RETURN		:       tak ada
; 0000 0197 */
; 0000 0198 {
_timer1_ovf_isr:
	RCALL SUBOPT_0x0
; 0000 0199 	// matikan LED stanby
; 0000 019A         L_STBY = 0;
; 0000 019B 
; 0000 019C         // tambahkan 1 nilai variabel xcount
; 0000 019D         xcount++;
	INC  R3
; 0000 019E 
; 0000 019F         // seleksi nilai variabel xcount
; 0000 01A0         if((xcount%2) == 0)
	MOV  R26,R3
	LDI  R30,LOW(2)
	RCALL __MODB21
	CPI  R30,0
	BRNE _0x9
; 0000 01A1         {	// jika ya
; 0000 01A2         	// nyalakan LED busy
; 0000 01A3                 L_BUSY = 1;
	SBI  0x12,5
; 0000 01A4 
; 0000 01A5                 // dapatkan data koordinat sekarang
; 0000 01A6                 ekstrak_gps();
	RCALL _ekstrak_gps
; 0000 01A7 
; 0000 01A8                 //matikan LED busy
; 0000 01A9                 L_BUSY = 0;
	CBI  0x12,5
; 0000 01AA         }
; 0000 01AB 
; 0000 01AC         // terima dan ekstrak data gps ketika timer detik bernilai genap saja
; 0000 01AD         if((xcount%8) == 0)
_0x9:
	MOV  R26,R3
	LDI  R30,LOW(8)
	RCALL __MODB21
	CPI  R30,0
	BRNE _0xE
; 0000 01AE         {	// jika ya
; 0000 01AF         	// nyalakan LED busy
; 0000 01B0                 L_BUSY = 1;
	SBI  0x12,5
; 0000 01B1 
; 0000 01B2                 // dapatkan data koordinat sekarang
; 0000 01B3                 ekstrak_gps();
	RCALL _ekstrak_gps
; 0000 01B4 
; 0000 01B5                 //matikan LED busy
; 0000 01B6                 L_BUSY = 0;
	CBI  0x12,5
; 0000 01B7 
; 0000 01B8                 // berikan delay sebentar
; 0000 01B9                 delay_ms(500);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x1
; 0000 01BA 
; 0000 01BB                 // kirim paket data
; 0000 01BC                 kirim_paket();
; 0000 01BD 
; 0000 01BE                 // reset variable counter
; 0000 01BF                 xcount = 0;
	CLR  R3
; 0000 01C0         }
; 0000 01C1 
; 0000 01C2         // nyalakan LED standby
; 0000 01C3         L_STBY = 1;
_0xE:
	SBI  0x12,4
; 0000 01C4 
; 0000 01C5         // reset kembali konstanta waktu timer
; 0000 01C6         TCNT1H = 0xAB;
	RCALL SUBOPT_0x3
; 0000 01C7         TCNT1L = 0xA0;
; 0000 01C8 
; 0000 01C9 }       // EndOf interrupt [TIM1_OVF] void timer1_ovf_isr(void)
_0x91:
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
; 0000 01CE /***************************************************************************************
; 0000 01CF *	ABSTRAKSI  	: 	pengendali urutan pengiriman data APRS
; 0000 01D0 *				penyusun protokol APRS
; 0000 01D1 *
; 0000 01D2 *      	INPUT		:	tak ada
; 0000 01D3 *	OUTPUT		:       kondisi LED dan output transistor switch TX
; 0000 01D4 *	RETURN		:       tak ada
; 0000 01D5 */
; 0000 01D6 {
_kirim_paket:
; 0000 01D7 	char i;
; 0000 01D8 
; 0000 01D9         // inisialisasi nilai CRC dengan 0xFFFF
; 0000 01DA 	crc = 0xFFFF;
	ST   -Y,R17
;	i -> R17
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	MOVW R4,R30
; 0000 01DB 
; 0000 01DC         // tambahkan 1 nilai counter pancar
; 0000 01DD         beacon_stat++;
	RCALL SUBOPT_0x4
	SUBI R30,-LOW(1)
	RCALL __EEPROMWRB
	SUBI R30,LOW(1)
; 0000 01DE 
; 0000 01DF         // nyalakan LED TX dan PTT switch
; 0000 01E0 	PTT = 1;
	SBI  0x18,3
; 0000 01E1 
; 0000 01E2         // tunggu 300ms
; 0000 01E3         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL SUBOPT_0x5
; 0000 01E4 
; 0000 01E5         /**********************************************************************************
; 0000 01E6 
; 0000 01E7         			APRS AX.25 PROTOCOL
; 0000 01E8 
; 0000 01E9         |------------------------------------------------------------------------
; 0000 01EA         |   opn. FLAG	|	DESTINATION	|	SOURCE	|	DIGI'S	| CONTROL...
; 0000 01EB         |---------------|-----------------------|---------------|---------------|
; 0000 01EC         |   0x7E 1Bytes |	7 Bytes		|       7 Bytes |  0 - 56 Bytes	|
; 0000 01ED         |------------------------------------------------------------------------
; 0000 01EE 
; 0000 01EF         	-----------------------------------------------------------------
; 0000 01F0         DIGI'S..|	CONTROL FIELD	|	PROTOCOL ID	|	INFO	| FCS...
; 0000 01F1                 |-----------------------|-----------------------|---------------|
; 0000 01F2                 |    0x03 1 Bytes	|     0xF0 1 Bytes	|  0 - 256 Bytes|
; 0000 01F3                 -----------------------------------------------------------------
; 0000 01F4 
; 0000 01F5         	--------------------------------|
; 0000 01F6         INFO... |	FCS	|   cls. FLAG	|
; 0000 01F7                 |---------------|---------------|
; 0000 01F8                 |	2 Bytes	|   0x7E 1Bytes |
; 0000 01F9                 --------------------------------|
; 0000 01FA 
; 0000 01FB         Sumber : APRS101, Tucson Amateur Packet Radio Club. www.tapr.org
; 0000 01FC         ************************************************************************************/
; 0000 01FD 
; 0000 01FE         // kirim karakter opening flag
; 0000 01FF         for(i=0;i<TX_DELAY_;i++)
	LDI  R17,LOW(0)
_0x18:
	CPI  R17,45
	BRGE _0x19
; 0000 0200         	kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x6
	SUBI R17,-1
	RJMP _0x18
_0x19:
; 0000 0203 bit_stuff = 0;
	RCALL SUBOPT_0x7
; 0000 0204 
; 0000 0205         // kirimkan field : destination, source, PATH 1, PATH 2, control, Protocol ID, dan
; 0000 0206         	// data type ID
; 0000 0207         for(i=0;i<21;i++)
	LDI  R17,LOW(0)
_0x1B:
	CPI  R17,21
	BRGE _0x1C
; 0000 0208         	kirim_karakter(data_1[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_data_1)
	SBCI R27,HIGH(-_data_1)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x1B
_0x1C:
; 0000 020B kirim_karakter(0x03);
	LDI  R30,LOW(3)
	RCALL SUBOPT_0x6
; 0000 020C 
; 0000 020D         // krimkan protocol ID
; 0000 020E         kirim_karakter(PROTOCOL_ID_);
	LDI  R30,LOW(240)
	RCALL SUBOPT_0x6
; 0000 020F 
; 0000 0210         // jika sudah 20 kali memancar,
; 0000 0211         if(beacon_stat == 20)
	RCALL SUBOPT_0x4
	CPI  R30,LOW(0x14)
	BRNE _0x1D
; 0000 0212         {
; 0000 0213         	// jika ya
; 0000 0214                 // kirim tipe data status
; 0000 0215                 kirim_karakter(TD_STATUS_);
	LDI  R30,LOW(62)
	RCALL SUBOPT_0x6
; 0000 0216 
; 0000 0217                 // kirim teks status
; 0000 0218                 for(i=0;i<47;i++)
	LDI  R17,LOW(0)
_0x1F:
	CPI  R17,47
	BRGE _0x20
; 0000 0219                 	kirim_karakter(status[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_status)
	SBCI R27,HIGH(-_status)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x1F
_0x20:
; 0000 021C beacon_stat = 0;
	LDI  R26,LOW(_beacon_stat)
	LDI  R27,HIGH(_beacon_stat)
	LDI  R30,LOW(0)
	RCALL __EEPROMWRB
; 0000 021D 
; 0000 021E                 // lompat ke kirim crc
; 0000 021F                 goto lompat;
	RJMP _0x21
; 0000 0220         }
; 0000 0221 
; 0000 0222         // krimkan tipe data posisi
; 0000 0223         kirim_karakter(TD_POSISI_);
_0x1D:
	LDI  R30,LOW(33)
	RCALL SUBOPT_0x6
; 0000 0224 
; 0000 0225         // kirimkan posisi lintang
; 0000 0226         for(i=0;i<8;i++)
	LDI  R17,LOW(0)
_0x23:
	CPI  R17,8
	BRGE _0x24
; 0000 0227         	kirim_karakter(posisi_lat[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_posisi_lat)
	SBCI R27,HIGH(-_posisi_lat)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x23
_0x24:
; 0000 022A kirim_karakter('\\');
	LDI  R30,LOW(92)
	RCALL SUBOPT_0x6
; 0000 022B 
; 0000 022C         // kirimkan posisi bujur
; 0000 022D 	for(i=0;i<9;i++)
	LDI  R17,LOW(0)
_0x26:
	CPI  R17,9
	BRGE _0x27
; 0000 022E         	kirim_karakter(posisi_long[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_posisi_long)
	SBCI R27,HIGH(-_posisi_long)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x26
_0x27:
; 0000 0231 kirim_karakter('l');
	LDI  R30,LOW(108)
	RCALL SUBOPT_0x6
; 0000 0232 
; 0000 0233         kirim_karakter('/');
	LDI  R30,LOW(47)
	RCALL SUBOPT_0x6
; 0000 0234         kirim_karakter('A');
	LDI  R30,LOW(65)
	RCALL SUBOPT_0x6
; 0000 0235         kirim_karakter('=');
	LDI  R30,LOW(61)
	RCALL SUBOPT_0x6
; 0000 0236 
; 0000 0237         for(i=0;i<6;i++)
	LDI  R17,LOW(0)
_0x29:
	CPI  R17,6
	BRGE _0x2A
; 0000 0238         	kirim_karakter(altitude[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_altitude)
	SBCI R27,HIGH(-_altitude)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x29
_0x2A:
; 0000 023B if(beacon_stat == 5)
	RCALL SUBOPT_0x4
	CPI  R30,LOW(0x5)
	BRNE _0x2B
; 0000 023C         {
; 0000 023D         	// kirimkan field informasi : data ekstensi tipe PHGD
; 0000 023E         	for(i=0;i<7;i++)
	LDI  R17,LOW(0)
_0x2D:
	CPI  R17,7
	BRGE _0x2E
; 0000 023F         		kirim_karakter(data_extension[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_data_extension)
	SBCI R27,HIGH(-_data_extension)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x2D
_0x2E:
; 0000 0242 for(i=0;i<18;i++)
	LDI  R17,LOW(0)
_0x30:
	CPI  R17,18
	BRGE _0x31
; 0000 0243         		kirim_karakter(komentar[i]);
	RCALL SUBOPT_0x8
	SUBI R26,LOW(-_komentar)
	SBCI R27,HIGH(-_komentar)
	RCALL SUBOPT_0x9
	SUBI R17,-1
	RJMP _0x30
_0x31:
; 0000 0244 }
; 0000 0245 
; 0000 0246 
; 0000 0247         // label lompatan
; 0000 0248         lompat:
_0x2B:
_0x21:
; 0000 0249 
; 0000 024A         // kirimkan field : FCS (CRC-16 CCITT)
; 0000 024B         kirim_crc();
	RCALL _kirim_crc
; 0000 024C 
; 0000 024D         // kirimkan karakter closing flag
; 0000 024E         for(i=0;i<TX_TAIL_;i++)
	LDI  R17,LOW(0)
_0x33:
	CPI  R17,15
	BRGE _0x34
; 0000 024F         	kirim_karakter(FLAG_);
	LDI  R30,LOW(126)
	RCALL SUBOPT_0x6
	SUBI R17,-1
	RJMP _0x33
_0x34:
; 0000 0252 delay_ms(50);
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RCALL SUBOPT_0x5
; 0000 0253         PTT = 0;
	CBI  0x18,3
; 0000 0254 
; 0000 0255 
; 0000 0256 }       // EndOf void kirim_paket(void)
	LD   R17,Y+
	RET
;
;
;/***************************************************************************************/
;	void 			kirim_crc(void)
; 0000 025B /***************************************************************************************
; 0000 025C *	ABSTRAKSI  	: 	Pengendali urutan pengiriman data CRC-16 CCITT Penyusun
; 0000 025D *				nilai 8 MSB dan 8 LSB dari nilai CRC yang telah dihitung.
; 0000 025E *				Generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
; 0000 025F *				leading one.
; 0000 0260 *
; 0000 0261 *      	INPUT		:	tak ada
; 0000 0262 *	OUTPUT		:       tak ada
; 0000 0263 *	RETURN		:       tak ada
; 0000 0264 */
; 0000 0265 {
_kirim_crc:
; 0000 0266 	static unsigned char crc_lo;
; 0000 0267 	static unsigned char crc_hi;
; 0000 0268 
; 0000 0269         // Exor-kan nilai CRC terakhir dengan 0xFF, masukkan ke 8 LSB
; 0000 026A         crc_lo = crc ^ 0xFF;
	LDI  R30,LOW(255)
	EOR  R30,R4
	STS  _crc_lo_S0000003000,R30
; 0000 026B 
; 0000 026C         // geser kanan 8 bit dan Exor-kan nilai CRC terakhir dengan 0xFF, masukkan ke 8 MSB
; 0000 026D         crc_hi = (crc >> 8) ^ 0xFF;
	MOV  R30,R5
	ANDI R31,HIGH(0x0)
	LDI  R26,LOW(255)
	EOR  R30,R26
	STS  _crc_hi_S0000003000,R30
; 0000 026E 
; 0000 026F         // kirim 8 LSB
; 0000 0270         kirim_karakter(crc_lo);
	LDS  R30,_crc_lo_S0000003000
	RCALL SUBOPT_0x6
; 0000 0271 
; 0000 0272         // kirim 8 MSB
; 0000 0273         kirim_karakter(crc_hi);
	LDS  R30,_crc_hi_S0000003000
	RCALL SUBOPT_0x6
; 0000 0274 
; 0000 0275 }       // EndOf void kirim_crc(void)
	RET
;
;
;/***************************************************************************************/
;	void 			kirim_karakter(unsigned char input)
; 0000 027A /***************************************************************************************
; 0000 027B *	ABSTRAKSI  	: 	mengirim data APRS karakter-demi-karakter, menghitung FCS
; 0000 027C *				field dan melakukan bit stuffing. Polarisasi data adalah
; 0000 027D *				NRZI (Non Return to Zero, Inverted). Bit dikirimkan sebagai
; 0000 027E *				bit terakhir yang ditahan jika bit masukan adalah bit 1.
; 0000 027F *				Bit dikirimkan sebagai bit terakhir yang di-invert jika bit
; 0000 0280 *				masukan adalah bit 0. Tone 1200Hz dan 2200Hz masing - masing
; 0000 0281 * 				merepresentasikan bit 0 dan 1 atau sebaliknya. Polarisasi
; 0000 0282 *				tone adalah tidak penting dalam polarisasi data NRZI.
; 0000 0283 *
; 0000 0284 *      	INPUT		:	byte data protokol APRS
; 0000 0285 *	OUTPUT		:       tak ada
; 0000 0286 *	RETURN		:       tak ada
; 0000 0287 */
; 0000 0288 {
_kirim_karakter:
	PUSH R15
; 0000 0289 	char i;
; 0000 028A 	bit in_bit;
; 0000 028B 
; 0000 028C         // kirimkan setiap byte data (8 bit)
; 0000 028D 	for(i=0;i<8;i++)
	ST   -Y,R17
;	input -> Y+1
;	i -> R17
;	in_bit -> R15.0
	LDI  R17,LOW(0)
_0x38:
	CPI  R17,8
	BRGE _0x39
; 0000 028E         {
; 0000 028F         	// ambil 1 bit berurutan dari LSB ke MSB setiap perulangan for 0 - 7
; 0000 0290                 in_bit = (input >> i) & 0x01;
	MOV  R30,R17
	LDD  R26,Y+1
	RCALL __LSRB12
	BST  R30,0
	BLD  R15,0
; 0000 0291 
; 0000 0292                 // jika data adalah flag, nol-kan pengingat bit stuffing
; 0000 0293                 if(input==0x7E)	{bit_stuff = 0;}
	CPI  R26,LOW(0x7E)
	BRNE _0x3A
	RCALL SUBOPT_0x7
; 0000 0294 
; 0000 0295                 // jika bukan flag, hitung nilai CRC dari bit data saat ini
; 0000 0296                 else		{hitung_crc(in_bit);}
	RJMP _0x3B
_0x3A:
	LDI  R30,0
	SBRC R15,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _hitung_crc
_0x3B:
; 0000 0297 
; 0000 0298                 // jika bit data saat ini adalah
; 0000 0299                 // nol
; 0000 029A                 if(!in_bit)
	SBRS R15,0
; 0000 029B                 {	// jika ya
; 0000 029C                 	// ubah tone dan bentuk gelombang sinus
; 0000 029D                         ubah_nada();
	RJMP _0x8F
; 0000 029E 
; 0000 029F                         // nol-kan pengingat bit stuffing
; 0000 02A0                         bit_stuff = 0;
; 0000 02A1                 }
; 0000 02A2                 // satu
; 0000 02A3                 else
; 0000 02A4                 {	// jika ya
; 0000 02A5                 	// jaga tone dan bentuk gelombang sinus
; 0000 02A6                         set_nada(nada);
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _set_nada
; 0000 02A7 
; 0000 02A8                         // hitung sebagai bit stuffing (bit satu berurut) tambahkan 1 nilai bit stuffing
; 0000 02A9                         bit_stuff++;
	LDS  R30,_bit_stuff_G000
	SUBI R30,-LOW(1)
	STS  _bit_stuff_G000,R30
; 0000 02AA 
; 0000 02AB                         // jika sudah terjadi bit satu berurut sebanyak 5 kali
; 0000 02AC                         if(bit_stuff==5)
	LDS  R26,_bit_stuff_G000
	CPI  R26,LOW(0x5)
	BRNE _0x3E
; 0000 02AD                         {
; 0000 02AE                         	// kirim bit nol :
; 0000 02AF                                 // ubah tone dan bentuk gelombang sinus
; 0000 02B0                                 ubah_nada();
_0x8F:
	RCALL _ubah_nada
; 0000 02B1 
; 0000 02B2                                 // nol-kan pengingat bit stuffing
; 0000 02B3                                 bit_stuff = 0;
	RCALL SUBOPT_0x7
; 0000 02B4 
; 0000 02B5                         }
; 0000 02B6                 }
_0x3E:
; 0000 02B7         }
	SUBI R17,-1
	RJMP _0x38
_0x39:
; 0000 02B8 
; 0000 02B9 }      // EndOf void kirim_karakter(unsigned char input)
	LDD  R17,Y+0
	ADIW R28,2
	POP  R15
	RET
;
;
;/***************************************************************************************/
;	void 			hitung_crc(char in_crc)
; 0000 02BE /***************************************************************************************
; 0000 02BF *	ABSTRAKSI  	: 	menghitung nilai CRC-16 CCITT dari tiap bit data yang terkirim,
; 0000 02C0 *				generator polinomial, G(x) = x^16 + x^12 + x^5 + 1 tanpa
; 0000 02C1 *				leading one
; 0000 02C2 *
; 0000 02C3 *      	INPUT		:	bit data yang terkirim
; 0000 02C4 *	OUTPUT		:       tak ada
; 0000 02C5 *	RETURN		:       tak ada
; 0000 02C6 */
; 0000 02C7 {
_hitung_crc:
; 0000 02C8 	static unsigned short xor_in;
; 0000 02C9 
; 0000 02CA         // simpan nilai Exor dari CRC sementara dengan bit data yang baru terkirim
; 0000 02CB 	xor_in = crc ^ in_crc;
;	in_crc -> Y+0
	LD   R30,Y
	LDI  R31,0
	SBRC R30,7
	SER  R31
	EOR  R30,R4
	EOR  R31,R5
	STS  _xor_in_S0000005000,R30
	STS  _xor_in_S0000005000+1,R31
; 0000 02CC 
; 0000 02CD         // geser kanan nilai CRC sebanyak 1 bit
; 0000 02CE 	crc >>= 1;
	LSR  R5
	ROR  R4
; 0000 02CF 
; 0000 02D0         // jika hasil nilai Exor di-and-kan dengan satu bernilai satu
; 0000 02D1         if(xor_in & 0x01)
	LDS  R30,_xor_in_S0000005000
	ANDI R30,LOW(0x1)
	BREQ _0x3F
; 0000 02D2         	// maka nilai CRC di-Exor-kan dengan generator polinomial
; 0000 02D3                 crc ^= 0x8408;
	LDI  R30,LOW(33800)
	LDI  R31,HIGH(33800)
	__EORWRR 4,5,30,31
; 0000 02D4 
; 0000 02D5 }      // EndOf void hitung_crc(char in_crc)
_0x3F:
	RJMP _0x2060001
;
;
;/***************************************************************************************/
;	void 			ubah_nada(void)
; 0000 02DA /***************************************************************************************
; 0000 02DB *	ABSTRAKSI  	: 	Menukar seting tone terakhir dengan tone yang baru. Tone
; 0000 02DC *				1200Hz dan 2200Hz masing - masing merepresentasikan bit
; 0000 02DD *				0 dan 1 atau sebaliknya. Polarisasi tone adalah tidak
; 0000 02DE *				penting dalam polarisasi data NRZI.
; 0000 02DF *
; 0000 02E0 *      	INPUT		:	tak ada
; 0000 02E1 *	OUTPUT		:       tak ada
; 0000 02E2 *	RETURN		:       tak ada
; 0000 02E3 */
; 0000 02E4 {
_ubah_nada:
; 0000 02E5 	// jika tone terakhir adalah :
; 0000 02E6         // 1200Hz
; 0000 02E7         if(nada ==_1200)
	SBIC 0x13,0
	RJMP _0x40
; 0000 02E8 	{	// jika ya
; 0000 02E9         	// ubah tone saat ini menjadi 2200Hz
; 0000 02EA                 nada = _2200;
	SBI  0x13,0
; 0000 02EB 
; 0000 02EC                 // bangkitkan gelombang sinus 2200Hz
; 0000 02ED         	set_nada(nada);
	RJMP _0x90
; 0000 02EE 	}
; 0000 02EF         // 2200Hz
; 0000 02F0         else
_0x40:
; 0000 02F1         {	// jika ya
; 0000 02F2         	// ubah tone saat ini menjadi 1200Hz
; 0000 02F3                 nada = _1200;
	CBI  0x13,0
; 0000 02F4 
; 0000 02F5                 // bangkitkan gelombang sinus 1200Hz
; 0000 02F6         	set_nada(nada);
_0x90:
	LDI  R30,0
	SBIC 0x13,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _set_nada
; 0000 02F7         }
; 0000 02F8 
; 0000 02F9 }       // EndOf void ubah_nada(void)
	RET
;
;
;/***************************************************************************************/
;	void 			set_dac(char value)
; 0000 02FE /***************************************************************************************
; 0000 02FF *	ABSTRAKSI  	: 	Men-set dan reset output DAC sebagai bilangan biner yang
; 0000 0300 *				merepresentasikan nilai diskrit dari gelombang sinus yang
; 0000 0301 *				sedang dibentuk saat ini sehingga membentuk tegangan sampling
; 0000 0302 *				dari gelombang.
; 0000 0303 *
; 0000 0304 *      	INPUT		:	nilai matrix rekonstruksi diskrit gelombang sinusoid
; 0000 0305 *	OUTPUT		:       DAC 0 - 3, tegangan kontinyu pada output Low Pass Filter
; 0000 0306 *	RETURN		:       tak ada
; 0000 0307 */
; 0000 0308 {
_set_dac:
; 0000 0309 	// ambil nilai LSB dari matrix rekonstruksi dan set sebagai DAC-0
; 0000 030A         DAC_0 = value & 0x01;
;	value -> Y+0
	LD   R30,Y
	ANDI R30,LOW(0x1)
	BRNE _0x46
	CBI  0x18,7
	RJMP _0x47
_0x46:
	SBI  0x18,7
_0x47:
; 0000 030B 
; 0000 030C         // ambil nilai dari matrix rekonstruksi, geser kanan 1 bit, ambil bit paling kanan
; 0000 030D         	// dan set sebagai DAC-1
; 0000 030E         DAC_1 =( value >> 1 ) & 0x01;
	LD   R30,Y
	ASR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x48
	CBI  0x18,6
	RJMP _0x49
_0x48:
	SBI  0x18,6
_0x49:
; 0000 030F 
; 0000 0310         // ambil nilai dari matrix rekonstruksi, geser kanan 2 bit, ambil bit paling kanan
; 0000 0311         	// dan set sebagai DAC-2
; 0000 0312         DAC_2 =( value >> 2 ) & 0x01;
	LD   R30,Y
	ASR  R30
	ASR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x4A
	CBI  0x18,5
	RJMP _0x4B
_0x4A:
	SBI  0x18,5
_0x4B:
; 0000 0313 
; 0000 0314         // ambil nilai dari matrix rekonstruksi, geser kanan 3 bit, ambil bit tersebut dan
; 0000 0315         	// set sebagai DAC-3 (MSB)
; 0000 0316         DAC_3 =( value >> 3 ) & 0x01;
	LD   R30,Y
	ASR  R30
	ASR  R30
	ASR  R30
	ANDI R30,LOW(0x1)
	BRNE _0x4C
	CBI  0x18,4
	RJMP _0x4D
_0x4C:
	SBI  0x18,4
_0x4D:
; 0000 0317 
; 0000 0318 }      	// EndOf void set_dac(char value)
_0x2060001:
	ADIW R28,1
	RET
;
;
;/***************************************************************************************/
;	void 			set_nada(char i_nada)
; 0000 031D /***************************************************************************************
; 0000 031E *	ABSTRAKSI  	: 	Membentuk baudrate serta frekensi tone 1200Hz dan 2200Hz
; 0000 031F *				dari konstanta waktu. Men-setting nilai DAC. Lakukan fine
; 0000 0320 *				tuning pada jumlah masing - masing perulangan for dan
; 0000 0321 *				konstanta waktu untuk meng-adjust parameter baudrate dan
; 0000 0322 *				frekuensi tone.
; 0000 0323 *
; 0000 0324 *      	INPUT		:	nilai frekuensi tone yang akan ditransmisikan
; 0000 0325 *	OUTPUT		:       nilai DAC
; 0000 0326 *	RETURN		:       tak ada
; 0000 0327 */
; 0000 0328 {
_set_nada:
; 0000 0329 	char i;
; 0000 032A 
; 0000 032B         // jika frekuensi tone yang akan segera dipancarkan adalah :
; 0000 032C         // 1200Hz
; 0000 032D 	if(i_nada == _1200)
	ST   -Y,R17
;	i_nada -> Y+1
;	i -> R17
	LDD  R30,Y+1
	CPI  R30,0
	BRNE _0x4E
; 0000 032E     	{
; 0000 032F         	// jika ya
; 0000 0330         	for(i=0; i<16; i++)
	LDI  R17,LOW(0)
_0x50:
	CPI  R17,16
	BRGE _0x51
; 0000 0331         	{
; 0000 0332                 	// set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 0333                 		// dan urutan perulangan for 0 - 15
; 0000 0334                 	set_dac(matrix[i]);
	RCALL SUBOPT_0xA
; 0000 0335 
; 0000 0336                         // bangkitkan frekuensi 1200Hz dari konstanta waktu
; 0000 0337         		delay_us(CONST_1200);
	__DELAY_USB 170
; 0000 0338         	}
	SUBI R17,-1
	RJMP _0x50
_0x51:
; 0000 0339     	}
; 0000 033A         // 2200Hz
; 0000 033B     	else
	RJMP _0x52
_0x4E:
; 0000 033C     	{
; 0000 033D         	// jika ya
; 0000 033E         	for(i=0; i<15; i++)
	LDI  R17,LOW(0)
_0x54:
	CPI  R17,15
	BRGE _0x55
; 0000 033F         	{
; 0000 0340                 	// set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 0341                 		// dan urutan perulangan for 0 - 15
; 0000 0342                 	set_dac(matrix[i]);
	RCALL SUBOPT_0xA
; 0000 0343 
; 0000 0344                         // bangkitkan frekuensi 2200Hz dari konstanta waktu
; 0000 0345                 	delay_us(CONST_2200);
	__DELAY_USB 92
; 0000 0346                 }
	SUBI R17,-1
	RJMP _0x54
_0x55:
; 0000 0347                 // sekali lagi, untuk mengatur baudrate lakukan fine tune pada jumlah for
; 0000 0348                 for(i=0; i<12; i++)
	LDI  R17,LOW(0)
_0x57:
	CPI  R17,12
	BRGE _0x58
; 0000 0349                 {
; 0000 034A                 	// set nilai DAC sesuai urutan matrix rekonstruksi gelombang sinus
; 0000 034B                 		// dan urutan perulangan for
; 0000 034C                 	set_dac(matrix[i]);
	RCALL SUBOPT_0xA
; 0000 034D 
; 0000 034E                         // bangkitkan frekuensi 2200Hz dari konstanta waktu
; 0000 034F                 	delay_us(CONST_2200);
	__DELAY_USB 92
; 0000 0350                 }
	SUBI R17,-1
	RJMP _0x57
_0x58:
; 0000 0351     	}
_0x52:
; 0000 0352 
; 0000 0353 } 	// EndOf void set_nada(char i_nada)
	LDD  R17,Y+0
	ADIW R28,2
	RET
;
;
;/***************************************************************************************/
;	void 			getComma(void)
; 0000 0358 /***************************************************************************************
; 0000 0359 *	ABSTRAKSI  	: 	Menunggu data RX serial berupa karakter koma dan segera
; 0000 035A *				kembali pada fungsi yang memanggilnya.
; 0000 035B *
; 0000 035C *      	INPUT		:	RX data serial $GPGLL gps
; 0000 035D *	OUTPUT		:       tak ada
; 0000 035E *	RETURN		:       tak ada
; 0000 035F */
; 0000 0360 {
_getComma:
; 0000 0361 	// jika data yang diterima bukan karakter koma, terima terus
; 0000 0362         	// jika data yang diterima adalah koma, keluar
; 0000 0363         while(getchar() != ',');
_0x59:
	RCALL _getchar
	CPI  R30,LOW(0x2C)
	BRNE _0x59
; 0000 0364 
; 0000 0365 }      	// EndOf void getComma(void)
	RET
;
;
;/***************************************************************************************/
;	void 			ekstrak_gps(void)
; 0000 036A /***************************************************************************************
; 0000 036B *	ABSTRAKSI  	: 	Menunggu interupsi RX data serial dari USART, memparsing
; 0000 036C *				data $GPGLL yang diterima menjadi data posisi, dan mengupdate
; 0000 036D *				data variabel posisi.
; 0000 036E *
; 0000 036F *      	INPUT		:	RX data serial $GPGLL gps
; 0000 0370 *	OUTPUT		:       tak ada
; 0000 0371 *	RETURN		:       tak ada
; 0000 0372 */
; 0000 0373 {
_ekstrak_gps:
; 0000 0374 	int i,j;
; 0000 0375         static char buff_posisi[17], buff_altitude[9];
; 0000 0376         unsigned int n_altitude[6];
; 0000 0377 
; 0000 0378         /************************************************************************************************
; 0000 0379         	$GPGLL - GLL - Geographic Position Latitude / Longitude
; 0000 037A 
; 0000 037B                 Contoh : $GPGLL,3723.2475,N,12158.3416,W,161229.487,A*2C
; 0000 037C 
; 0000 037D         |-----------------------------------------------------------------------------------------------|
; 0000 037E         |	Nama		| 	Contoh		|		Deskripsi			|
; 0000 037F         |-----------------------|-----------------------|-----------------------------------------------|
; 0000 0380         |	Message ID	|	$GPGLL		|	header protokol GLL			|
; 0000 0381         |	Latitude	|	3723.2475	|	ddmm.mmmm 	, d=degree, m=minute	|
; 0000 0382         |	N/S indicator	|	N		|	N=utara, S=selatan			|
; 0000 0383         |	Longitude	|	12158.3416	|	dddmm.mmmm	, d=degree, m=minute	|
; 0000 0384         |	W/E indicator	|	W		|	W=barat, E=timur			|
; 0000 0385         |	Waktu UTC (GMT)	|	161229.487	|	HHMMSS.SS  ,H=hour, M=minute, S=second	|
; 0000 0386         |	Status		|	A		|	A=data valid, V=data invalid		|
; 0000 0387         |	Checksum	|	*2C		|						|
; 0000 0388         |-----------------------------------------------------------------------------------------------|
; 0000 0389 
; 0000 038A         	Sumber : GPS SiRF EM-406A datasheet
; 0000 038B 
; 0000 038C         *************************************************************************************************/
; 0000 038D 
; 0000 038E         // jika data yang diterima bukan karakter $, terima terus
; 0000 038F         	// jika data yang diterima adalah $, lanjutkan
; 0000 0390         while(getchar() != '$');
	SBIW R28,12
	RCALL __SAVELOCR4
;	i -> R16,R17
;	j -> R18,R19
;	n_altitude -> Y+4
_0x5C:
	RCALL _getchar
	CPI  R30,LOW(0x24)
	BRNE _0x5C
; 0000 0391 
; 0000 0392         // tunggu dan terima data tanpa proses lebih lanjut (lewatkan karakter G)
; 0000 0393 	getchar();
	RCALL _getchar
; 0000 0394 
; 0000 0395         // tunggu dan terima data tanpa proses lebih lanjut (lewatkan karakter P)
; 0000 0396         getchar();
	RCALL _getchar
; 0000 0397 
; 0000 0398         // tunggu data, jika yang diterima adalah karakter G
; 0000 0399         if(getchar() == 'G')
	RCALL _getchar
	CPI  R30,LOW(0x47)
	BREQ PC+2
	RJMP _0x5F
; 0000 039A         {
; 0000 039B         	// maka
; 0000 039C         	// tunggu data, jika yang diterima adalah karakter G
; 0000 039D                 if(getchar() == 'G')
	RCALL _getchar
	CPI  R30,LOW(0x47)
	BREQ PC+2
	RJMP _0x60
; 0000 039E         	{
; 0000 039F                 	// maka
; 0000 03A0                         // tunggu data, jika yang diterima adalah karakter A
; 0000 03A1                         if(getchar() == 'A')
	RCALL _getchar
	CPI  R30,LOW(0x41)
	BREQ PC+2
	RJMP _0x61
; 0000 03A2                 	{
; 0000 03A3                         	// maka
; 0000 03A4                                 // tunggu koma dan lanjutkan
; 0000 03A5                                 getComma();
	RCALL _getComma
; 0000 03A6                                 getComma();
	RCALL _getComma
; 0000 03A7 
; 0000 03A8                                 // ambil 7 byte data berurut dan masukkan dalam buffer data
; 0000 03A9                         	for(i=0; i<7; i++)	buff_posisi[i] = getchar();
	RCALL SUBOPT_0xB
_0x63:
	__CPWRN 16,17,7
	BRGE _0x64
	MOV  R30,R16
	SUBI R30,-LOW(_buff_posisi_S000000A000)
	PUSH R30
	RCALL _getchar
	POP  R26
	ST   X,R30
	RCALL SUBOPT_0xC
	RJMP _0x63
_0x64:
; 0000 03AC getComma();
	RCALL _getComma
; 0000 03AD 
; 0000 03AE                                 // ambil 1 byte data dan masukkan dalam buffer data
; 0000 03AF                                 buff_posisi[7] = getchar();
	RCALL _getchar
	__PUTB1MN _buff_posisi_S000000A000,7
; 0000 03B0 
; 0000 03B1                                 // tunggu koma dan lanjutkan
; 0000 03B2                                 getComma();
	RCALL _getComma
; 0000 03B3 
; 0000 03B4                                 // ambil 8 byte data berurut dan masukkan dalam buffer data
; 0000 03B5                                 for(i=0; i<8; i++)	buff_posisi[i+8] = getchar();
	RCALL SUBOPT_0xB
_0x66:
	RCALL SUBOPT_0xD
	BRGE _0x67
	MOV  R30,R16
	__ADDB1MN _buff_posisi_S000000A000,8
	PUSH R30
	RCALL _getchar
	POP  R26
	ST   X,R30
	RCALL SUBOPT_0xC
	RJMP _0x66
_0x67:
; 0000 03B8 getComma();
	RCALL _getComma
; 0000 03B9 
; 0000 03BA                                 // ambil 1 byte data dan masukkan dalam buffer data
; 0000 03BB                                 buff_posisi[16] = getchar();
	RCALL _getchar
	__PUTB1MN _buff_posisi_S000000A000,16
; 0000 03BC 
; 0000 03BD                                 // tunggu dan lewatkan 3 koma
; 0000 03BE                                 getComma();
	RCALL _getComma
; 0000 03BF                                 getComma();
	RCALL _getComma
; 0000 03C0                                 getComma();
	RCALL _getComma
; 0000 03C1                                 getComma();
	RCALL _getComma
; 0000 03C2 
; 0000 03C3                                 // ambil 8 byte data ketinggian dalam meter
; 0000 03C4                                 for(i=0;i<8;i++)        buff_altitude[i] = getchar();
	RCALL SUBOPT_0xB
_0x69:
	RCALL SUBOPT_0xD
	BRGE _0x6A
	MOV  R30,R16
	SUBI R30,-LOW(_buff_altitude_S000000A000)
	PUSH R30
	RCALL _getchar
	POP  R26
	ST   X,R30
	RCALL SUBOPT_0xC
	RJMP _0x69
_0x6A:
; 0000 03C7 for(i=0;i<8;i++)	{posisi_lat[i]=buff_posisi[i];}
	RCALL SUBOPT_0xB
_0x6C:
	RCALL SUBOPT_0xD
	BRGE _0x6D
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
	RJMP _0x6C
_0x6D:
; 0000 03C8         			for(i=0;i<9;i++)	{posisi_long[i]=buff_posisi[i+8];}
	RCALL SUBOPT_0xB
_0x6F:
	__CPWRN 16,17,9
	BRGE _0x70
	MOVW R26,R16
	SUBI R26,LOW(-_posisi_long)
	SBCI R27,HIGH(-_posisi_long)
	MOV  R30,R16
	__ADDB1MN _buff_posisi_S000000A000,8
	LD   R30,Z
	RCALL __EEPROMWRB
	RCALL SUBOPT_0xC
	RJMP _0x6F
_0x70:
; 0000 03C9 
; 0000 03CA                                 // nol-kan variable ketinggian
; 0000 03CB                                 for(i=0;i<6;i++)        n_altitude[i] = '0';
	RCALL SUBOPT_0xB
_0x72:
	RCALL SUBOPT_0xE
	BRGE _0x73
	RCALL SUBOPT_0xF
	LDI  R30,LOW(48)
	LDI  R31,HIGH(48)
	ST   X+,R30
	ST   X,R31
	RCALL SUBOPT_0xC
	RJMP _0x72
_0x73:
; 0000 03CE for(i=0;i<8;i++)
	RCALL SUBOPT_0xB
_0x75:
	RCALL SUBOPT_0xD
	BRGE _0x76
; 0000 03CF                                 {
; 0000 03D0                                         if(buff_altitude[i] == '.')     goto selesai;
	RCALL SUBOPT_0x10
	BREQ _0x78
; 0000 03D1                                         if((buff_altitude[i] != '.')&&(buff_altitude[i] != ',')&&(buff_altitude[i] != 'M'))
	RCALL SUBOPT_0x10
	BREQ _0x7A
	LDI  R26,LOW(_buff_altitude_S000000A000)
	ADD  R26,R16
	LD   R26,X
	CPI  R26,LOW(0x2C)
	BREQ _0x7A
	LDI  R26,LOW(_buff_altitude_S000000A000)
	ADD  R26,R16
	LD   R26,X
	CPI  R26,LOW(0x4D)
	BRNE _0x7B
_0x7A:
	RJMP _0x79
_0x7B:
; 0000 03D2                                         {
; 0000 03D3                                                 // geser dari satuan ke puluhan dst.
; 0000 03D4                                                 for(j=0;j<6;j++)        n_altitude[j] = n_altitude[j+1];
	__GETWRN 18,19,0
_0x7D:
	__CPWRN 18,19,6
	BRGE _0x7E
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
	RJMP _0x7D
_0x7E:
; 0000 03D7 n_altitude[5] = buff_altitude[i];
	LDI  R26,LOW(_buff_altitude_S000000A000)
	ADD  R26,R16
	LD   R30,X
	LDI  R31,0
	SBRC R30,7
	SER  R31
	RCALL SUBOPT_0x11
; 0000 03D8                                         }
; 0000 03D9                                 }
_0x79:
	RCALL SUBOPT_0xC
	RJMP _0x75
_0x76:
; 0000 03DA 
; 0000 03DB                                 selesai:
_0x78:
; 0000 03DC 
; 0000 03DD                                 // atoi
; 0000 03DE                                 for(i=0;i<6;i++)        n_altitude[i] -= '0';
	RCALL SUBOPT_0xB
_0x80:
	RCALL SUBOPT_0xE
	BRGE _0x81
	RCALL SUBOPT_0xF
	LD   R30,X+
	LD   R31,X+
	SBIW R30,48
	ST   -X,R31
	ST   -X,R30
	RCALL SUBOPT_0xC
	RJMP _0x80
_0x81:
; 0000 03E1 n_altitude[0] *= 100000;
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	LDI  R26,LOW(34464)
	LDI  R27,HIGH(34464)
	RCALL __MULW12U
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 03E2                                 n_altitude[1] *=  10000;
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	LDI  R26,LOW(10000)
	LDI  R27,HIGH(10000)
	RCALL __MULW12U
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 03E3                                 n_altitude[2] *=   1000;
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDI  R26,LOW(1000)
	LDI  R27,HIGH(1000)
	RCALL __MULW12U
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 03E4                                 n_altitude[3] *=    100;
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	LDI  R26,LOW(100)
	LDI  R27,HIGH(100)
	RCALL __MULW12U
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 03E5                                 n_altitude[4] *=     10;
	LDD  R30,Y+12
	LDD  R31,Y+12+1
	LDI  R26,LOW(10)
	LDI  R27,HIGH(10)
	RCALL __MULW12U
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 03E6 
; 0000 03E7                                 // jumlahkan satuan + puluhan + ratusan dst.
; 0000 03E8                                 n_altitude[5] += (n_altitude[0] + n_altitude[1] + n_altitude[2] + n_altitude[3] + n_altitude[4]);
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
; 0000 03E9 
; 0000 03EA                                 // meter to feet
; 0000 03EB                                 n_altitude[5] *= 3;
	LDD  R30,Y+14
	LDD  R31,Y+14+1
	LDI  R26,LOW(3)
	LDI  R27,HIGH(3)
	RCALL __MULW12U
	RCALL SUBOPT_0x14
; 0000 03EC 
; 0000 03ED                                 // num to 'string'
; 0000 03EE                                 n_altitude[0] = n_altitude[5] / 100000;
	RCALL SUBOPT_0x15
	RCALL __DIVD21U
	STD  Y+4,R30
	STD  Y+4+1,R31
; 0000 03EF                                 n_altitude[5] %= 100000;
	RCALL SUBOPT_0x13
	RCALL SUBOPT_0x15
	RCALL __MODD21U
	RCALL SUBOPT_0x14
; 0000 03F0 
; 0000 03F1                                 n_altitude[1] = n_altitude[5] / 10000;
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	RCALL __DIVW21U
	STD  Y+6,R30
	STD  Y+6+1,R31
; 0000 03F2                                 n_altitude[5] %= 10000;
	RCALL SUBOPT_0x13
	LDI  R30,LOW(10000)
	LDI  R31,HIGH(10000)
	RCALL __MODW21U
	RCALL SUBOPT_0x14
; 0000 03F3 
; 0000 03F4                                 n_altitude[2] = n_altitude[5] / 1000;
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __DIVW21U
	STD  Y+8,R30
	STD  Y+8+1,R31
; 0000 03F5                                 n_altitude[5] %= 1000;
	RCALL SUBOPT_0x13
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	RCALL __MODW21U
	RCALL SUBOPT_0x14
; 0000 03F6 
; 0000 03F7                                 n_altitude[3] = n_altitude[5] / 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __DIVW21U
	STD  Y+10,R30
	STD  Y+10+1,R31
; 0000 03F8                                 n_altitude[5] %= 100;
	RCALL SUBOPT_0x13
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	RCALL __MODW21U
	RCALL SUBOPT_0x14
; 0000 03F9 
; 0000 03FA                                 n_altitude[4] = n_altitude[5] / 10;
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __DIVW21U
	STD  Y+12,R30
	STD  Y+12+1,R31
; 0000 03FB                                 n_altitude[5] %= 10;
	RCALL SUBOPT_0x13
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL __MODW21U
	RCALL SUBOPT_0x11
; 0000 03FC 
; 0000 03FD                                 // itoa, pindahkan dari variable numerik ke eeprom
; 0000 03FE                                 for(i=0;i<6;i++)        altitude[i] = (char)(n_altitude[i] + '0');
	RCALL SUBOPT_0xB
_0x83:
	RCALL SUBOPT_0xE
	BRGE _0x84
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
	RJMP _0x83
_0x84:
; 0000 03FF }
; 0000 0400                 }
_0x61:
; 0000 0401         }
_0x60:
; 0000 0402 
; 0000 0403 } 	// EndOf void ekstrak_gps(void)
_0x5F:
	RCALL __LOADLOCR4
	ADIW R28,16
	RET
;
;
;/***************************************************************************************/
;	void main(void)
; 0000 0408 /***************************************************************************************
; 0000 0409 *
; 0000 040A *	MAIN PROGRAM
; 0000 040B *
; 0000 040C */
; 0000 040D {
_main:
; 0000 040E 	// pengaturan clock CPU dan menjaga agar kompatibel dengan versi code vision terdahulu
; 0000 040F #pragma optsize-
; 0000 0410 	CLKPR=0x80;
	LDI  R30,LOW(128)
	OUT  0x26,R30
; 0000 0411 	CLKPR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0412 	#ifdef _OPTIMIZE_SIZE_
; 0000 0413 #pragma optsize+
; 0000 0414 	#endif
; 0000 0415 
; 0000 0416         // set bit register PORTB
; 0000 0417         PORTB=0x00;
	OUT  0x18,R30
; 0000 0418 
; 0000 0419         // set bit Data Direction Register PORTB
; 0000 041A 	DDRB=0xF8;
	LDI  R30,LOW(248)
	OUT  0x17,R30
; 0000 041B 
; 0000 041C         // set bit register PORTD
; 0000 041D         PORTD=0x09;
	LDI  R30,LOW(9)
	OUT  0x12,R30
; 0000 041E 
; 0000 041F         // set bit Data Direction Register PORTD
; 0000 0420 	DDRD=0x30;
	LDI  R30,LOW(48)
	OUT  0x11,R30
; 0000 0421 
; 0000 0422         // set parameter 4800baud, 8, N, 1
; 0000 0423         UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
; 0000 0424 	UCSRB=0x10;
	LDI  R30,LOW(16)
	OUT  0xA,R30
; 0000 0425 	UCSRC=0x06;
	LDI  R30,LOW(6)
	OUT  0x3,R30
; 0000 0426 	UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 0427 	UBRRL=0x8F;
	LDI  R30,LOW(143)
	OUT  0x9,R30
; 0000 0428 
; 0000 0429         // set register Analog Comparator
; 0000 042A         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 042B 
; 0000 042C         // set register EXT_IRQ_1 (External Interrupt 1 Request), Low Interrupt
; 0000 042D 	GIMSK=0x80;
	OUT  0x3B,R30
; 0000 042E 	MCUCR=0x08;
	LDI  R30,LOW(8)
	OUT  0x35,R30
; 0000 042F 	EIFR=0x80;
	LDI  R30,LOW(128)
	OUT  0x3A,R30
; 0000 0430 
; 0000 0431         // set register Timer 1, System clock 10.8kHz, Timer 1 overflow
; 0000 0432 	TCCR1B=0x05;
	LDI  R30,LOW(5)
	OUT  0x2E,R30
; 0000 0433 
; 0000 0434         // set konstanta waktu 5 detik sebagai awalan
; 0000 0435         //timer_detik(INITIAL_TIME_C);
; 0000 0436         TCNT1H = 0xAB;
	RCALL SUBOPT_0x3
; 0000 0437         TCNT1L = 0xA0;
; 0000 0438 
; 0000 0439         // set interupsi timer untuk Timer 1
; 0000 043A         TIMSK=0x80;
	LDI  R30,LOW(128)
	OUT  0x39,R30
; 0000 043B 
; 0000 043C         xcount = 0;
	CLR  R3
; 0000 043D 
; 0000 043E         // indikator awalan hardware aktif :
; 0000 043F         // nyalakan LED busy
; 0000 0440         L_BUSY = 1;
	SBI  0x12,5
; 0000 0441 
; 0000 0442         // tunggu 500ms
; 0000 0443         delay_ms(500);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5
; 0000 0444 
; 0000 0445         // nyalakan LED standby
; 0000 0446         L_STBY = 1;
	SBI  0x12,4
; 0000 0447 
; 0000 0448         // tunggu 500ms
; 0000 0449         delay_ms(500);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5
; 0000 044A 
; 0000 044B         // matikan LED busy
; 0000 044C         L_BUSY = 0;
	CBI  0x12,5
; 0000 044D 
; 0000 044E         // tunggu 500ms
; 0000 044F         delay_ms(500);
	RCALL SUBOPT_0x2
	RCALL SUBOPT_0x5
; 0000 0450 
; 0000 0451         // aktifkan interupsi global (berdasar setting register)
; 0000 0452         #asm("sei")
	sei
; 0000 0453 
; 0000 0454         // tidak lakukan apapun selain menunggu interupsi timer1_ovf_isr
; 0000 0455         while (1)
_0x8B:
; 0000 0456         {
; 0000 0457         	// blok ini kosong
; 0000 0458         };
	RJMP _0x8B
; 0000 0459 
; 0000 045A }	// END OF MAIN PROGRAM
_0x8E:
	RJMP _0x8E
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
	.DB  LOW(0xB2404040),HIGH(0xB2404040),BYTE3(0xB2404040),BYTE4(0xB2404040)
	.DB  LOW(0x82B06488),HIGH(0x82B06488),BYTE3(0x82B06488),BYTE4(0x82B06488)
	.DB  LOW(0x92AE6C86),HIGH(0x92AE6C86),BYTE3(0x92AE6C86),BYTE4(0x92AE6C86)
	.DB  LOW(0x40648A88),HIGH(0x40648A88),BYTE3(0x40648A88),BYTE4(0x40648A88)
	.DB  0x65
_posisi_lat:
	.DB  LOW(0x33343730),HIGH(0x33343730),BYTE3(0x33343730),BYTE4(0x33343730)
	.DB  LOW(0x5331332E),HIGH(0x5331332E),BYTE3(0x5331332E),BYTE4(0x5331332E)
_posisi_long:
	.DB  LOW(0x32303131),HIGH(0x32303131),BYTE3(0x32303131),BYTE4(0x32303131)
	.DB  LOW(0x32352E33),HIGH(0x32352E33),BYTE3(0x32352E33),BYTE4(0x32352E33)
	.DB  0x45
_altitude:
	.BYTE 0x6
_data_extension:
	.DB  LOW(0x32474850),HIGH(0x32474850),BYTE3(0x32474850),BYTE4(0x32474850)
	.DW  0x3230
	.DB  0x30
_komentar:
	.DB  LOW(0x45524F43),HIGH(0x45524F43),BYTE3(0x45524F43),BYTE4(0x45524F43)
	.DB  LOW(0x44524F20),HIGH(0x44524F20),BYTE3(0x44524F20),BYTE4(0x44524F20)
	.DB  LOW(0x49442041),HIGH(0x49442041),BYTE3(0x49442041),BYTE4(0x49442041)
	.DB  LOW(0x20202059),HIGH(0x20202059),BYTE3(0x20202059),BYTE4(0x20202059)
	.DW  0x2020
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 20 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x6:
	ST   -Y,R30
	RJMP _kirim_karakter

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x7:
	LDI  R30,LOW(0)
	STS  _bit_stuff_G000,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:16 WORDS
SUBOPT_0x8:
	MOV  R26,R17
	LDI  R27,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
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
