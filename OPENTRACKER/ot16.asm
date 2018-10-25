
;CodeVisionAVR C Compiler V1.25.3 Professional
;(C) Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega8535
;Program type           : Application
;Clock frequency        : 11.059200 MHz
;Memory model           : Small
;Optimize for           : Speed
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 128 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : Yes
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: Yes
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8535
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 512
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

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

	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_adc_noise_red=0x10
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0

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
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ANDWMNN
	LDS  R30,@0+@1
	ANDI R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ANDI R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ANDD1N
	ANDI R30,LOW(@0)
	ANDI R31,HIGH(@0)
	ANDI R22,BYTE3(@0)
	ANDI R23,BYTE4(@0)
	.ENDM

	.MACRO __ORBMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	.ENDM

	.MACRO __ORWMNN
	LDS  R30,@0+@1
	ORI  R30,LOW(@2)
	STS  @0+@1,R30
	LDS  R30,@0+@1+1
	ORI  R30,HIGH(@2)
	STS  @0+@1+1,R30
	.ENDM

	.MACRO __ORD1N
	ORI  R30,LOW(@0)
	ORI  R31,HIGH(@0)
	ORI  R22,BYTE3(@0)
	ORI  R23,BYTE4(@0)
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

	.MACRO __CLRD1S
	LDI  R30,0
	STD  Y+@0,R30
	STD  Y+@0+1,R30
	STD  Y+@0+2,R30
	STD  Y+@0+3,R30
	.ENDM

	.MACRO __GETD1S
	LDD  R30,Y+@0
	LDD  R31,Y+@0+1
	LDD  R22,Y+@0+2
	LDD  R23,Y+@0+3
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

	.MACRO __POINTB1MN
	LDI  R30,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW1MN
	LDI  R30,LOW(@0+@1)
	LDI  R31,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTD1M
	LDI  R30,LOW(@0)
	LDI  R31,HIGH(@0)
	LDI  R22,BYTE3(@0)
	.ENDM

	.MACRO __POINTW1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	.ENDM

	.MACRO __POINTD1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	LDI  R22,BYTE3(2*@0+@1)
	.ENDM

	.MACRO __POINTB2MN
	LDI  R26,LOW(@0+@1)
	.ENDM

	.MACRO __POINTW2MN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
	.ENDM

	.MACRO __POINTBRM
	LDI  R@0,LOW(@1)
	.ENDM

	.MACRO __POINTWRM
	LDI  R@0,LOW(@2)
	LDI  R@1,HIGH(@2)
	.ENDM

	.MACRO __POINTBRMN
	LDI  R@0,LOW(@1+@2)
	.ENDM

	.MACRO __POINTWRMN
	LDI  R@0,LOW(@2+@3)
	LDI  R@1,HIGH(@2+@3)
	.ENDM

	.MACRO __POINTWRFN
	LDI  R@0,LOW(@2*2+@3)
	LDI  R@1,HIGH(@2*2+@3)
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

	.MACRO __GETD2S
	LDD  R26,Y+@0
	LDD  R27,Y+@0+1
	LDD  R24,Y+@0+2
	LDD  R25,Y+@0+3
	.ENDM

	.MACRO __GETB1MN
	LDS  R30,@0+@1
	.ENDM

	.MACRO __GETB1HMN
	LDS  R31,@0+@1
	.ENDM

	.MACRO __GETW1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	.ENDM

	.MACRO __GETD1MN
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	LDS  R22,@0+@1+2
	LDS  R23,@0+@1+3
	.ENDM

	.MACRO __GETBRMN
	LDS  R@0,@1+@2
	.ENDM

	.MACRO __GETWRMN
	LDS  R@0,@2+@3
	LDS  R@1,@2+@3+1
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
	LDS  R26,@0+@1
	.ENDM

	.MACRO __GETW2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	.ENDM

	.MACRO __GETD2MN
	LDS  R26,@0+@1
	LDS  R27,@0+@1+1
	LDS  R24,@0+@1+2
	LDS  R25,@0+@1+3
	.ENDM

	.MACRO __PUTB1MN
	STS  @0+@1,R30
	.ENDM

	.MACRO __PUTW1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	.ENDM

	.MACRO __PUTD1MN
	STS  @0+@1,R30
	STS  @0+@1+1,R31
	STS  @0+@1+2,R22
	STS  @0+@1+3,R23
	.ENDM

	.MACRO __PUTBR0MN
	STS  @0+@1,R0
	.ENDM

	.MACRO __PUTDZ2
	STD  Z+@0,R26
	STD  Z+@0+1,R27
	STD  Z+@0+2,R24
	STD  Z+@0+3,R25
	.ENDM

	.MACRO __PUTBMRN
	STS  @0+@1,R@2
	.ENDM

	.MACRO __PUTWMRN
	STS  @0+@1,R@2
	STS  @0+@1+1,R@3
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
	LDS  R30,@0+@1
	LDS  R31,@0+@1+1
	ICALL
	.ENDM

	.MACRO __CALL1FN
	LDI  R30,LOW(2*@0+@1)
	LDI  R31,HIGH(2*@0+@1)
	RCALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	RCALL __PUTDP1
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
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z,R0
	.ENDM

	.MACRO __CLRD1SX
	MOVW R30,R28
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	CLR  R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z+,R0
	ST   Z,R0
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
	SUBI R30,LOW(-@0)
	SBCI R31,HIGH(-@0)
	ST   Z,R@1
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

	.CSEG
	.ORG 0

	.INCLUDE "ot16.vec"
	.INCLUDE "ot16.inc"

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
	LDI  R24,13
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(0x200)
	LDI  R25,HIGH(0x200)
	LDI  R26,0x60
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

;STACK POINTER INITIALIZATION
	LDI  R30,LOW(0x25F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x25F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0xE0)
	LDI  R29,HIGH(0xE0)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xE0
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V2.05.0 Professional
;       4 Automatic Program Generator
;       5 © Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.com
;       7 
;       8 Project :
;       9 Version :
;      10 Date    : 1/11/2012
;      11 Author  :
;      12 Company :
;      13 Comments:
;      14 
;      15 
;      16 Chip type               : ATmega8535
;      17 Program type            : Application
;      18 AVR Core Clock frequency: 11.059200 MHz
;      19 Memory model            : Small
;      20 External RAM size       : 0
;      21 Data Stack size         : 128
;      22 
;      23 Polynomial Generator G(x) = x^16 + x^12 + x^5 + 1
;      24 
;      25 *****************************************************/
;      26 
;      27 #include <mega8535.h>
;      28 #include <delay.h>
;      29 #include <string.h>
;      30 #include <ctype.h>
;      31 
;      32 #define FRAMING_ERROR (1<<FE)
;      33 #define PARITY_ERROR (1<<UPE)
;      34 #define DATA_OVERRUN (1<<OVR)
;      35 #define DATA_REGISTER_EMPTY (1<<UDRE)
;      36 #define RX_COMPLETE (1<<RXC)
;      37 
;      38 #define RX_BUFFER_SIZE 8
;      39 #define TX_BUFFER_SIZE 8
;      40 
;      41 char tx_buffer[TX_BUFFER_SIZE];
_tx_buffer:
	.BYTE 0x8
;      42 char rx_buffer[RX_BUFFER_SIZE];
_rx_buffer:
	.BYTE 0x8
;      43 bit rx_buffer_overflow;
;      44 
;      45 #if RX_BUFFER_SIZE<256
;      46 	unsigned char rx_wr_index,rx_rd_index,rx_counter;
;      47 	#else
;      48 	unsigned int rx_wr_index,rx_rd_index,rx_counter;
;      49 #endif
;      50 
;      51 #if TX_BUFFER_SIZE<256
;      52 	unsigned char tx_wr_index,tx_rd_index,tx_counter;
;      53 	#else
;      54 	unsigned int tx_wr_index,tx_rd_index,tx_counter;
;      55 #endif
;      56 
;      57 interrupt [USART_RXC] void usart_rx_isr(void) {

	.CSEG
_usart_rx_isr:
;      58 	char status,data;
;      59 	status=UCSRA;
	RCALL __SAVELOCR2
;	status -> R17
;	data -> R16
	IN   R17,11
;      60 	data=UDR;
	IN   R16,12
;      61 	if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0) {
	MOV  R30,R17
	MOV  R24,R30
	RCALL __LSLB12
	MOV  R1,R30
	RCALL __LSLB12
	LDI  R31,0
	SBRC R30,7
	SER  R31
	MOV  R26,R1
	LDI  R27,0
	SBRC R26,7
	SER  R27
	OR   R30,R26
	OR   R31,R27
	MOVW R22,R30
	RCALL __LSLB12
	LDI  R31,0
	SBRC R30,7
	SER  R31
	OR   R30,R22
	OR   R31,R23
	MOV  R26,R24
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BREQ PC+2
	RJMP _0x3
;      62    		rx_buffer[rx_wr_index]=data;
	MOV  R30,R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	ST   Z,R16
;      63    		if (++rx_wr_index == RX_BUFFER_SIZE) rx_wr_index=0;
	INC  R5
	LDI  R30,LOW(8)
	CP   R30,R5
	BREQ PC+2
	RJMP _0x4
	CLR  R5
;      64    		if (++rx_counter == RX_BUFFER_SIZE) {
_0x4:
	INC  R7
	LDI  R30,LOW(8)
	CP   R30,R7
	BREQ PC+2
	RJMP _0x5
;      65       			rx_counter=0;
	CLR  R7
;      66       			rx_buffer_overflow=1;
	SET
	BLD  R2,0
;      67       		};
_0x5:
;      68    	};
_0x3:
;      69 }
	RCALL __LOADLOCR2P
	RETI
;      70 
;      71 interrupt [USART_TXC] void usart_tx_isr(void) {
_usart_tx_isr:
;      72 	if (tx_counter) {
	TST  R8
	BRNE PC+2
	RJMP _0x6
;      73    		--tx_counter;
	DEC  R8
;      74    		UDR=tx_buffer[tx_rd_index];
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R30,Z
	OUT  0xC,R30
;      75    		if (++tx_rd_index == TX_BUFFER_SIZE) tx_rd_index=0;
	INC  R9
	LDI  R30,LOW(8)
	CP   R30,R9
	BREQ PC+2
	RJMP _0x7
	CLR  R9
;      76    	};
_0x7:
_0x6:
;      77 }
	RETI
;      78 
;      79 #ifndef _DEBUG_TERMINAL_IO_
;      80 	#define _ALTERNATE_GETCHAR_
;      81 #pragma used+
;      82 	char getchar(void) {
_getchar:
	PUSH R15
;      83 		char data;
;      84 		while (rx_counter==0);
	ST   -Y,R17
;	data -> R17
_0x8:
	TST  R7
	BREQ PC+2
	RJMP _0xA
	RJMP _0x8
_0xA:
;      85 		data=rx_buffer[rx_rd_index];
	MOV  R30,R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer)
	SBCI R31,HIGH(-_rx_buffer)
	LD   R17,Z
;      86 		if (++rx_rd_index == RX_BUFFER_SIZE) rx_rd_index=0;
	INC  R4
	LDI  R30,LOW(8)
	CP   R30,R4
	BREQ PC+2
	RJMP _0xB
	CLR  R4
;      87 		#asm("cli")
_0xB:
	cli
;      88 		--rx_counter;
	DEC  R7
;      89 		#asm("sei")
	sei
;      90 		return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
;      91 	}
;      92 #pragma used-
;      93 #endif
;      94 
;      95 #ifndef _DEBUG_TERMINAL_IO_
;      96 	#define _ALTERNATE_PUTCHAR_
;      97 #pragma used+
;      98 	void putchar(char c) {
_putchar:
	PUSH R15
;      99 		while (tx_counter == TX_BUFFER_SIZE);
;	c -> Y+0
_0xC:
	LDI  R30,LOW(8)
	CP   R30,R8
	BREQ PC+2
	RJMP _0xE
	RJMP _0xC
_0xE:
;     100 		#asm("cli")
	cli
;     101 		if (tx_counter || ((UCSRA & DATA_REGISTER_EMPTY)==0)) {
	TST  R8
	BREQ PC+2
	RJMP _0x10
	IN   R30,0xB
	MOV  R1,R30
	RCALL __LSLB12
	LDI  R31,0
	SBRC R30,7
	SER  R31
	MOV  R26,R1
	LDI  R27,0
	AND  R30,R26
	AND  R31,R27
	SBIW R30,0
	BRNE PC+2
	RJMP _0x10
	RJMP _0xF
_0x10:
;     102    			tx_buffer[tx_wr_index]=c;
	MOV  R30,R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer)
	SBCI R31,HIGH(-_tx_buffer)
	LD   R26,Y
	STD  Z+0,R26
;     103    			if (++tx_wr_index == TX_BUFFER_SIZE) tx_wr_index=0;
	INC  R6
	LDI  R30,LOW(8)
	CP   R30,R6
	BREQ PC+2
	RJMP _0x12
	CLR  R6
;     104    			++tx_counter;
_0x12:
	INC  R8
;     105    		}
;     106 		else
	RJMP _0x13
_0xF:
;     107    		UDR=c;
	LD   R30,Y
	OUT  0xC,R30
;     108 		#asm("sei")
_0x13:
	sei
;     109 	}
	ADIW R28,1
	RET
;     110 #pragma used-
;     111 #endif
;     112 
;     113 #define PTT		PORTB.4
;     114 #define	DAC_0		PORTB.0
;     115 #define DAC_1		PORTB.1
;     116 #define DAC_2		PORTB.2
;     117 #define DAC_3		PORTB.3
;     118 #define TX_NOW		PIND.5
;     119 #define	MODE		PIND.4
;     120 #define TX_LED		PORTD.2
;     121 #define STBY_LED	PORTD.3
;     122 
;     123 #define on	1
;     124 #define off	0
;     125 #define GPS_ENABLED	(gps_status=1)
;     126 #define GPS_DISABLED	(gps_status=0)
;     127 
;     128 #define PTT_ON	(PTT = on)
;     129 #define PTT_OFF	(PTT = off)
;     130 #define TX_LED_ON	(TX_LED = on)
;     131 #define TX_LED_OFF	(TX_LED = off)
;     132 #define STBY_LED_ON	(STBY_LED = off)
;     133 #define STBY_LED_OFF	(STBY_LED = off)
;     134 
;     135 #define CONST_1200      52
;     136 #define CONST_2200      28
;     137 #define CONST_POLYNOM   0b10001000000100001	// x^16 + x^12 + x^5 + 1
;     138 //#define CONST_POLYNOM	0b11000000000000101	// x^16 + x^15 + x^2 + 1
;     139 
;     140 flash char flag[24] = {
;     141  	0x7E,0x7E,0x7E,0x7E,
;     142         0x7E,0x7E,0x7E,0x7E,
;     143         0x7E,0x7E,0x7E,0x7E,
;     144         0x7E,0x7E,0x7E,0x7E,
;     145         0x7E,0x7E,0x7E,0x7E,
;     146         0x7E,0x7E,0x7E,0x7E
;     147 };
;     148 flash char ssid_2 = 0b01100100;
;     149 flash char ssid_9 = 0b01110010;
;     150 flash char ssid_2final = 0b01100101;
;     151 //flash char ssid_9final = 0b01110011;
;     152 eeprom char destination[7] = {

	.ESEG
_destination:
;     153         0x41,0x50,0x55,0x32,0x35,0x4D,
;     154         0               // SSID
;     155         // APU25N-2     // 0b011SSIDx format, SSID = 2 = 0b0010
;     156 };
	.DB  0x41
	.DB  0x50
	.DB  0x55
	.DB  0x32
	.DB  0x35
	.DB  0x4D
	.DB  0x0
;     157 eeprom char source[7] = {
_source:
;     158         0x59,0x44,0x32,0x58,0x42,0x43,
;     159         0               // SSID
;     160         // YD2XBC-9     // 0b011SSIDx format, SSID = 9 = 0b1001
;     161 };
	.DB  0x59
	.DB  0x44
	.DB  0x32
	.DB  0x58
	.DB  0x42
	.DB  0x43
	.DB  0x0
;     162 eeprom char digi[7] = {
_digi:
;     163         // 0x57,0x49,0x44,0x45,0x32,0x32,0x20    // atau
;     164         0x57,0x49,0x44,0x45,0x32,
;     165         0,              // SSID
;     166         0x20
;     167         // WIDE2-2      // 0b011SSIDx format, SSID = 2 = 0b0010
;     168 };
	.DB  0x57
	.DB  0x49
	.DB  0x44
	.DB  0x45
	.DB  0x32
	.DB  0x0
	.DB  0x20
;     169 char destination_final[7];

	.DSEG
_destination_final:
	.BYTE 0x7
;     170 char source_final[7];
_source_final:
	.BYTE 0x7
;     171 char digi_final[7];
_digi_final:
	.BYTE 0x7
;     172 flash char control_field = 0x03;

	.CSEG
;     173 flash char protocol_id = 0xF0;
;     174 flash char data_type = 0x21;
;     175 eeprom char latitude[8] = {

	.ESEG
_latitude:
;     176         0x30,0x37,0x34,0x35,0x2E,0x37,0x39,0x53			// format string
;     177         // 0,7,4,5,0x2E,7,9,0x53				// format int
;     178         // 0745.79S
;     179 };
	.DB  0x30
	.DB  0x37
	.DB  0x34
	.DB  0x35
	.DB  0x2E
	.DB  0x37
	.DB  0x39
	.DB  0x53
;     180 eeprom char symbol_table = 0x2F;
_symbol_table:
	.DB  0x2F
;     181 eeprom char longitude[9] = {
_longitude:
;     182         0x31,0x31,0x30,0x30,0x35,0x2E,0x32,0x31,0x45
;     183         // 1,1,0,0,5,0x2E,2,1,0x45
;     184         // 11005.21E
;     185 };
	.DB  0x31
	.DB  0x31
	.DB  0x30
	.DB  0x30
	.DB  0x35
	.DB  0x2E
	.DB  0x32
	.DB  0x31
	.DB  0x45
;     186 eeprom char symbol_code = 0x3E;
_symbol_code:
	.DB  0x3E
;     187 eeprom char comment[43] = {
_comment:
;     188         0x54,0x45,0x53,0x54,0x49,0x4E,0x47,0x20,                // testing(spasi)
;     189         0x46,0x4F,0x52,0x20,                                    // for(spasi)
;     190         0x45,0x4D,0x45,0x52,0x47,0x45,0x4E,0x43,0x59,0x20,      // emergency(spasi)
;     191         0x42,0x45,0x41,0x43,0x4F,0x4E,0x20,                     // beacon(spasi)
;     192         0x20,0x20,0x20,0x20,0x20,0x20,0x20,                     // (spasi)
;     193         0x20,0x20,0x20,0x20,0x20,0x20,0x20                      // (spasi)
;     194         // testing for emergency beacon
;     195 };
	.DB  0x54
	.DB  0x45
	.DB  0x53
	.DB  0x54
	.DB  0x49
	.DB  0x4E
	.DB  0x47
	.DB  0x20
	.DB  0x46
	.DB  0x4F
	.DB  0x52
	.DB  0x20
	.DB  0x45
	.DB  0x4D
	.DB  0x45
	.DB  0x52
	.DB  0x47
	.DB  0x45
	.DB  0x4E
	.DB  0x43
	.DB  0x59
	.DB  0x20
	.DB  0x42
	.DB  0x45
	.DB  0x41
	.DB  0x43
	.DB  0x4F
	.DB  0x4E
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
	.DB  0x20
;     196 
;     197 eeprom char gpsString[300];
_gpsString:
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
	.DB  0x0
;     198 char gpsString_buff[300];

	.DSEG
_gpsString_buff:
	.BYTE 0x12C
;     199 
;     200 char fcshi;
;     201 char fcslo;
;     202 char count_1 = 0;
;     203 char x_counter = 0;
;     204 bit flag_state;
;     205 bit crc_flag = 0;
;     206 int tone = 1200;
_tone:
	.BYTE 0x2
;     207 long fcs_arr = 0;
_fcs_arr:
	.BYTE 0x4
;     208 bit gps_status;
;     209 
;     210 void init_data(void);
;     211 void protocol(void);
;     212 void send_data(char input);
;     213 void fliptone(void);
;     214 void set_dac(char value);
;     215 void send_tone(int nada);
;     216 void send_fcs(char infcs);
;     217 void calc_fcs(char in);
;     218 void Port_init(void);
;     219 void USART_init(unsigned int baud_rate);
;     220 
;     221 void init_data(void) {

	.CSEG
_init_data:
	PUSH R15
;     222 	int i;
;     223         for(i=0;i<7;i++) {
	RCALL __SAVELOCR2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x16:
	__CPWRN 16,17,7
	BRLT PC+2
	RJMP _0x17
;     224                 digi_final[i] = digi[i] << 1;
	MOVW R30,R16
	SUBI R30,LOW(-_digi_final)
	SBCI R31,HIGH(-_digi_final)
	MOVW R0,R30
	LDI  R26,LOW(_digi)
	LDI  R27,HIGH(_digi)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	LSL  R30
	MOVW R26,R0
	ST   X,R30
;     225                 destination_final[i] = destination[i] << 1;
	MOVW R30,R16
	SUBI R30,LOW(-_destination_final)
	SBCI R31,HIGH(-_destination_final)
	MOVW R0,R30
	LDI  R26,LOW(_destination)
	LDI  R27,HIGH(_destination)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	LSL  R30
	MOVW R26,R0
	ST   X,R30
;     226                 source_final[i] = source[i] << 1;
	MOVW R30,R16
	SUBI R30,LOW(-_source_final)
	SBCI R31,HIGH(-_source_final)
	MOVW R0,R30
	LDI  R26,LOW(_source)
	LDI  R27,HIGH(_source)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	LSL  R30
	MOVW R26,R0
	ST   X,R30
;     227         }
_0x15:
	__ADDWRN 16,17,1
	RJMP _0x16
_0x17:
;     228 
;     229         destination_final[6] = ssid_2;
	__POINTW2MN _destination_final,6
	LDI  R30,LOW(_ssid_2*2)
	LDI  R31,HIGH(_ssid_2*2)
	LPM  R30,Z
	ST   X,R30
;     230         source_final[6] = ssid_9;
	__POINTW2MN _source_final,6
	LDI  R30,LOW(_ssid_9*2)
	LDI  R31,HIGH(_ssid_9*2)
	LPM  R30,Z
	ST   X,R30
;     231         digi_final[5] = ssid_2final;
	__POINTW2MN _digi_final,5
	LDI  R30,LOW(_ssid_2final*2)
	LDI  R31,HIGH(_ssid_2final*2)
	LPM  R30,Z
	ST   X,R30
;     232 }
	RCALL __LOADLOCR2P
	RET
;     233 
;     234 void protocol(void) {
_protocol:
	PUSH R15
;     235         int i;
;     236 
;     237         init_data();						// persiapkan bit shifting
	RCALL __SAVELOCR2
;	i -> R16,R17
	RCALL _init_data
;     238 
;     239         PTT_ON;
	SBI  0x18,4
;     240         TX_LED_ON;
	SBI  0x12,2
;     241         delay_ms(250);                  			// tunggu sampai radio stabil
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
;     242 
;     243         crc_flag = 0;
	CLT
	BLD  R2,2
;     244         flag_state = 1;
	SET
	BLD  R2,1
;     245         for(i=0;i<24;i++)       send_data(flag[i]);             // kirim flag 24 kali
	__GETWRN 16,17,0
_0x19:
	__CPWRN 16,17,24
	BRLT PC+2
	RJMP _0x1A
	MOVW R30,R16
	SUBI R30,LOW(-_flag*2)
	SBCI R31,HIGH(-_flag*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _send_data
;     246         flag_state = 0;
_0x18:
	__ADDWRN 16,17,1
	RJMP _0x19
_0x1A:
	CLT
	BLD  R2,1
;     247         for(i=0;i<7;i++)        send_data(destination_final[i]);// kirim callsign tujuan
	__GETWRN 16,17,0
_0x1C:
	__CPWRN 16,17,7
	BRLT PC+2
	RJMP _0x1D
	LDI  R26,LOW(_destination_final)
	LDI  R27,HIGH(_destination_final)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	ST   -Y,R30
	RCALL _send_data
;     248         for(i=0;i<7;i++)        send_data(source_final[i]);     // kirim callsign asal
_0x1B:
	__ADDWRN 16,17,1
	RJMP _0x1C
_0x1D:
	__GETWRN 16,17,0
_0x1F:
	__CPWRN 16,17,7
	BRLT PC+2
	RJMP _0x20
	LDI  R26,LOW(_source_final)
	LDI  R27,HIGH(_source_final)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	ST   -Y,R30
	RCALL _send_data
;     249         send_data(ssid_9);
_0x1E:
	__ADDWRN 16,17,1
	RJMP _0x1F
_0x20:
	LDI  R30,LOW(_ssid_9*2)
	LDI  R31,HIGH(_ssid_9*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _send_data
;     250         for(i=0;i<7;i++)        send_data(digi_final[i]);       // kirim path digi
	__GETWRN 16,17,0
_0x22:
	__CPWRN 16,17,7
	BRLT PC+2
	RJMP _0x23
	LDI  R26,LOW(_digi_final)
	LDI  R27,HIGH(_digi_final)
	ADD  R26,R16
	ADC  R27,R17
	LD   R30,X
	ST   -Y,R30
	RCALL _send_data
;     251         send_data(control_field);                               // kirim data control field
_0x21:
	__ADDWRN 16,17,1
	RJMP _0x22
_0x23:
	LDI  R30,LOW(_control_field*2)
	LDI  R31,HIGH(_control_field*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _send_data
;     252         send_data(protocol_id);                                 // kirim data PID
	LDI  R30,LOW(_protocol_id*2)
	LDI  R31,HIGH(_protocol_id*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _send_data
;     253         send_data(data_type);                                   // kirim data type info
	LDI  R30,LOW(_data_type*2)
	LDI  R31,HIGH(_data_type*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _send_data
;     254         for(i=0;i<8;i++)        send_data(latitude[i]);         // kirim data lintang posisi
	__GETWRN 16,17,0
_0x25:
	__CPWRN 16,17,8
	BRLT PC+2
	RJMP _0x26
	LDI  R26,LOW(_latitude)
	LDI  R27,HIGH(_latitude)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _send_data
;     255         send_data(symbol_table);                                // kirim simbol tabel
_0x24:
	__ADDWRN 16,17,1
	RJMP _0x25
_0x26:
	LDI  R26,LOW(_symbol_table)
	LDI  R27,HIGH(_symbol_table)
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _send_data
;     256         for(i=0;i<9;i++)        send_data(longitude[i]);        // kirim data bujur posisi
	__GETWRN 16,17,0
_0x28:
	__CPWRN 16,17,9
	BRLT PC+2
	RJMP _0x29
	LDI  R26,LOW(_longitude)
	LDI  R27,HIGH(_longitude)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _send_data
;     257         send_data(symbol_code);                                 // kirim simbol kode
_0x27:
	__ADDWRN 16,17,1
	RJMP _0x28
_0x29:
	LDI  R26,LOW(_symbol_code)
	LDI  R27,HIGH(_symbol_code)
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _send_data
;     258         for(i=0;i<43;i++);      send_data(comment[i]);          // kirim komen
	__GETWRN 16,17,0
_0x2B:
	__CPWRN 16,17,43
	BRLT PC+2
	RJMP _0x2C
_0x2A:
	__ADDWRN 16,17,1
	RJMP _0x2B
_0x2C:
	LDI  R26,LOW(_comment)
	LDI  R27,HIGH(_comment)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _send_data
;     259         crc_flag = 1;    	calc_fcs(0);	               	// hitung FCS
	SET
	BLD  R2,2
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _calc_fcs
;     260         send_fcs(fcshi);                                        // kirim 8 MSB dari FCS
	ST   -Y,R11
	RCALL _send_fcs
;     261         send_fcs(fcslo);                                        // kirim 8 LSB dari FCS
	ST   -Y,R10
	RCALL _send_fcs
;     262         flag_state = 1;
	SET
	BLD  R2,1
;     263         for(i=0;i<12;i++)       send_data(flag[i]);             // kirim flag 12 kali
	__GETWRN 16,17,0
_0x2E:
	__CPWRN 16,17,12
	BRLT PC+2
	RJMP _0x2F
	MOVW R30,R16
	SUBI R30,LOW(-_flag*2)
	SBCI R31,HIGH(-_flag*2)
	LPM  R30,Z
	ST   -Y,R30
	RCALL _send_data
;     264         flag_state = 0;
_0x2D:
	__ADDWRN 16,17,1
	RJMP _0x2E
_0x2F:
	CLT
	BLD  R2,1
;     265         PTT_OFF;
	CBI  0x18,4
;     266         TX_LED_OFF;
	CBI  0x12,2
;     267 }
	RCALL __LOADLOCR2P
	RET
;     268 
;     269 void send_data(char input) {
_send_data:
	PUSH R15
;     270         int i;
;     271         bit x;
;     272         for(i=0;i<8;i++) {
	RCALL __SAVELOCR2
;	input -> Y+2
;	i -> R16,R17
;	x -> R15.0
	__GETWRN 16,17,0
_0x31:
	__CPWRN 16,17,8
	BRLT PC+2
	RJMP _0x32
;     273                 x = (input >> i) & 0x01;
;	input -> Y+2
;	x -> R15.0
	MOVW R30,R16
	LDD  R26,Y+2
	LDI  R27,0
	RCALL __ASRW12
	BST  R30,0
	BLD  R15,0
;     274                 if(!flag_state)	calc_fcs(x);
	SBRC R2,1
	RJMP _0x33
	LDI  R30,0
	SBRC R15,0
	LDI  R30,1
	ST   -Y,R30
	RCALL _calc_fcs
;     275                 if(x) {
_0x33:
	SBRS R15,0
	RJMP _0x34
;     276                         if(!flag_state) count_1++;
;	input -> Y+2
;	x -> R15.0
	SBRC R2,1
	RJMP _0x35
	INC  R13
;     277                         if(count_1==5)  fliptone();
_0x35:
	LDI  R30,LOW(5)
	CP   R30,R13
	BREQ PC+2
	RJMP _0x36
	RCALL _fliptone
;     278                         send_tone(tone);
_0x36:
	LDS  R30,_tone
	LDS  R31,_tone+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _send_tone
;     279                 }
;     280                 if(!x)  fliptone();
_0x34:
	SBRC R15,0
	RJMP _0x37
	RCALL _fliptone
;     281         }
_0x37:
_0x30:
	__ADDWRN 16,17,1
	RJMP _0x31
_0x32:
;     282 }
	RCALL __LOADLOCR2
	ADIW R28,3
	POP  R15
	RET
;     283 
;     284 void fliptone(void) {
_fliptone:
	PUSH R15
;     285         count_1 = 0;
	CLR  R13
;     286         switch(tone) {
	LDS  R30,_tone
	LDS  R31,_tone+1
;     287                 case 1200:      tone=2200;      send_tone(tone);        break;
	CPI  R30,LOW(0x4B0)
	LDI  R26,HIGH(0x4B0)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x3B
	LDI  R30,LOW(2200)
	LDI  R31,HIGH(2200)
	STS  _tone,R30
	STS  _tone+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RCALL _send_tone
	RJMP _0x3A
;     288                 case 2200:      tone=1200;      send_tone(tone);        break;
_0x3B:
	CPI  R30,LOW(0x898)
	LDI  R26,HIGH(0x898)
	CPC  R31,R26
	BREQ PC+2
	RJMP _0x3A
	LDI  R30,LOW(1200)
	LDI  R31,HIGH(1200)
	STS  _tone,R30
	STS  _tone+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RCALL _send_tone
;     289         }
_0x3A:
;     290 }
	RET
;     291 
;     292 void set_dac(char value) {
_set_dac:
	PUSH R15
;     293         DAC_0 = value & 0x01;
;	value -> Y+0
	LD   R30,Y
	BST  R30,0
	IN   R26,0x18
	BLD  R26,0
	OUT  0x18,R26
;     294         DAC_1 =( value >> 1 ) & 0x01;
	LSR  R30
	BST  R30,0
	IN   R26,0x18
	BLD  R26,1
	OUT  0x18,R26
;     295         DAC_2 =( value >> 2 ) & 0x01;
	LD   R30,Y
	LSR  R30
	LSR  R30
	BST  R30,0
	IN   R26,0x18
	BLD  R26,2
	OUT  0x18,R26
;     296         DAC_3 =( value >> 3 ) & 0x01;
	LD   R30,Y
	LSR  R30
	LSR  R30
	LSR  R30
	BST  R30,0
	IN   R26,0x18
	BLD  R26,3
	OUT  0x18,R26
;     297 }
	ADIW R28,1
	RET
;     298 
;     299 void send_tone(int nada) {
_send_tone:
	PUSH R15
;     300 	if(nada==1200) {
;	nada -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x4B0)
	LDI  R30,HIGH(0x4B0)
	CPC  R27,R30
	BREQ PC+2
	RJMP _0x3D
;     301                 set_dac(7);     delay_us(CONST_1200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     302 
;     303                 set_dac(10);    delay_us(CONST_1200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     304                 set_dac(13);    delay_us(CONST_1200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     305                 set_dac(14);    delay_us(CONST_1200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     306 
;     307                 set_dac(15);    delay_us(CONST_1200);
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     308 
;     309                 set_dac(14);    delay_us(CONST_1200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     310                 set_dac(13);    delay_us(CONST_1200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     311                 set_dac(10);    delay_us(CONST_1200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     312 
;     313                 set_dac(7);     delay_us(CONST_1200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     314 
;     315                 set_dac(5);     delay_us(CONST_1200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     316                 set_dac(2);     delay_us(CONST_1200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     317                 set_dac(1);     delay_us(CONST_1200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     318 
;     319                 set_dac(0);     delay_us(CONST_1200);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     320 
;     321                 set_dac(1);     delay_us(CONST_1200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     322                 set_dac(2);     delay_us(CONST_1200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     323                 set_dac(5);     delay_us(CONST_1200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 192
;     324         }
;     325 
;     326         else {
	RJMP _0x3E
_0x3D:
;     327                 set_dac(7);     delay_us(CONST_2200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     328 
;     329                 set_dac(10);    delay_us(CONST_2200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     330                 set_dac(13);    delay_us(CONST_2200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     331                 set_dac(14);    delay_us(CONST_2200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     332 
;     333                 set_dac(15);    delay_us(CONST_2200);
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     334 
;     335                 set_dac(14);    delay_us(CONST_2200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     336                 set_dac(13);    delay_us(CONST_2200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     337                 set_dac(10);    delay_us(CONST_2200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     338 
;     339                 set_dac(7);     delay_us(CONST_2200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     340 
;     341                 set_dac(5);     delay_us(CONST_2200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     342                 set_dac(2);     delay_us(CONST_2200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     343                 set_dac(1);     delay_us(CONST_2200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     344 
;     345                 set_dac(0);     delay_us(CONST_2200);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     346 
;     347                 set_dac(1);     delay_us(CONST_2200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     348                 set_dac(2);     delay_us(CONST_2200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     349                 set_dac(5);     delay_us(CONST_2200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     350 
;     351                 set_dac(7);     delay_us(CONST_2200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     352 
;     353                 set_dac(10);    delay_us(CONST_2200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     354                 set_dac(13);    delay_us(CONST_2200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     355                 set_dac(14);    delay_us(CONST_2200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     356 
;     357                 set_dac(15);    delay_us(CONST_2200);
	LDI  R30,LOW(15)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     358 
;     359                 set_dac(14);    delay_us(CONST_2200);
	LDI  R30,LOW(14)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     360                 set_dac(13);    delay_us(CONST_2200);
	LDI  R30,LOW(13)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     361                 set_dac(10);    delay_us(CONST_2200);
	LDI  R30,LOW(10)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     362 
;     363                 set_dac(7);     delay_us(CONST_2200);
	LDI  R30,LOW(7)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     364 
;     365                 set_dac(5);     delay_us(CONST_2200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     366                 set_dac(2);     delay_us(CONST_2200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     367                 set_dac(1);     delay_us(CONST_2200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     368 
;     369                 set_dac(0);     delay_us(CONST_2200);
	LDI  R30,LOW(0)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     370 
;     371                 set_dac(1);     delay_us(CONST_2200);
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     372                 set_dac(2);     delay_us(CONST_2200);
	LDI  R30,LOW(2)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     373                 set_dac(5);     delay_us(CONST_2200);
	LDI  R30,LOW(5)
	ST   -Y,R30
	RCALL _set_dac
	__DELAY_USB 103
;     374         }
_0x3E:
;     375 }
	ADIW R28,2
	RET
;     376 
;     377 void send_fcs(char infcs) {
_send_fcs:
	PUSH R15
;     378         int j=7;
;     379         bit x;
;     380         while(j>0) {
	RCALL __SAVELOCR2
;	infcs -> Y+2
;	j -> R16,R17
;	x -> R15.0
	LDI  R16,7
	LDI  R17,0
_0x3F:
	CLR  R0
	CP   R0,R16
	CPC  R0,R17
	BRLT PC+2
	RJMP _0x41
;     381                 x = (infcs >> j) & 0x01;
;	infcs -> Y+2
;	x -> R15.0
	MOVW R30,R16
	LDD  R26,Y+2
	LDI  R27,0
	RCALL __ASRW12
	BST  R30,0
	BLD  R15,0
;     382                 if(x) {
	SBRS R15,0
	RJMP _0x42
;     383                         count_1++;
;	infcs -> Y+2
;	x -> R15.0
	INC  R13
;     384                         if(count_1==5)    fliptone();
	LDI  R30,LOW(5)
	CP   R30,R13
	BREQ PC+2
	RJMP _0x43
	RCALL _fliptone
;     385                         send_tone(tone);
_0x43:
	LDS  R30,_tone
	LDS  R31,_tone+1
	ST   -Y,R31
	ST   -Y,R30
	RCALL _send_tone
;     386                 }
;     387                 if(!x)  fliptone();
_0x42:
	SBRC R15,0
	RJMP _0x44
	RCALL _fliptone
;     388                 j--;
_0x44:
	__SUBWRN 16,17,1
;     389         }
	RJMP _0x3F
_0x41:
;     390 }
	RCALL __LOADLOCR2
	ADIW R28,3
	POP  R15
	RET
;     391 
;     392 void calc_fcs(char in) {
_calc_fcs:
	PUSH R15
;     393 	int i;
;     394  	fcs_arr += in;
	RCALL __SAVELOCR2
;	in -> Y+2
;	i -> R16,R17
	LDD  R30,Y+2
	LDI  R31,0
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	RCALL __CWD1
	RCALL __ADDD12
	STS  _fcs_arr,R30
	STS  _fcs_arr+1,R31
	STS  _fcs_arr+2,R22
	STS  _fcs_arr+3,R23
;     395   	x_counter++;
	INC  R12
;     396 
;     397    	if(crc_flag) {
	SBRS R2,2
	RJMP _0x45
;     398       	 	for(i=0;i<16;i++) {
	__GETWRN 16,17,0
_0x47:
	__CPWRN 16,17,16
	BRLT PC+2
	RJMP _0x48
;     399                 	if((fcs_arr >> 16)==1) {
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	LDI  R30,LOW(16)
	RCALL __ASRD12
	__CPD1N 0x1
	BREQ PC+2
	RJMP _0x49
;     400       	 			fcs_arr ^= CONST_POLYNOM;
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	__GETD1N 0x11021
	RCALL __XORD12
	STS  _fcs_arr,R30
	STS  _fcs_arr+1,R31
	STS  _fcs_arr+2,R22
	STS  _fcs_arr+3,R23
;     401                         }
;     402           		fcs_arr <<= 1;
_0x49:
	LDS  R30,_fcs_arr
	LDS  R31,_fcs_arr+1
	LDS  R22,_fcs_arr+2
	LDS  R23,_fcs_arr+3
	RCALL __LSLD1
	STS  _fcs_arr,R30
	STS  _fcs_arr+1,R31
	STS  _fcs_arr+2,R22
	STS  _fcs_arr+3,R23
;     403           	}
_0x46:
	__ADDWRN 16,17,1
	RJMP _0x47
_0x48:
;     404           	fcshi = fcs_arr >> 8; 		// ambil 8 bit paling kiri
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	LDI  R30,LOW(8)
	RCALL __ASRD12
	MOV  R11,R30
;     405        		fcslo = fcs_arr & 0b11111111; 	// ambil 8 bit paling kanan
	LDS  R30,_fcs_arr
	LDS  R31,_fcs_arr+1
	LDS  R22,_fcs_arr+2
	LDS  R23,_fcs_arr+3
	__ANDD1N 0xFF
	MOV  R10,R30
;     406     	}
;     407 
;     408      	if((x_counter==17) && ((fcs_arr >> 16)==1)) {
_0x45:
	LDI  R30,LOW(17)
	CP   R30,R12
	BREQ PC+2
	RJMP _0x4B
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	LDI  R30,LOW(16)
	RCALL __ASRD12
	__CPD1N 0x1
	BREQ PC+2
	RJMP _0x4B
	RJMP _0x4C
_0x4B:
	RJMP _0x4A
_0x4C:
;     409          	fcs_arr ^= CONST_POLYNOM;
	LDS  R26,_fcs_arr
	LDS  R27,_fcs_arr+1
	LDS  R24,_fcs_arr+2
	LDS  R25,_fcs_arr+3
	__GETD1N 0x11021
	RCALL __XORD12
	STS  _fcs_arr,R30
	STS  _fcs_arr+1,R31
	STS  _fcs_arr+2,R22
	STS  _fcs_arr+3,R23
;     410                 x_counter -= 1;
	DEC  R12
;     411       	}
;     412 
;     413         if(x_counter==17) {
_0x4A:
	LDI  R30,LOW(17)
	CP   R30,R12
	BREQ PC+2
	RJMP _0x4D
;     414          	x_counter -= 1;
	DEC  R12
;     415         }
;     416 
;     417        	fcs_arr <<= 1;
_0x4D:
	LDS  R30,_fcs_arr
	LDS  R31,_fcs_arr+1
	LDS  R22,_fcs_arr+2
	LDS  R23,_fcs_arr+3
	RCALL __LSLD1
	STS  _fcs_arr,R30
	STS  _fcs_arr+1,R31
	STS  _fcs_arr+2,R22
	STS  _fcs_arr+3,R23
;     418 }
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
;     419 
;     420 void TerimaMentahGPS(void) {
_TerimaMentahGPS:
	PUSH R15
;     421         int i;
;     422         for(i=0; i<300; i++) {
	RCALL __SAVELOCR2
;	i -> R16,R17
	__GETWRN 16,17,0
_0x4F:
	__CPWRN 16,17,300
	BRLT PC+2
	RJMP _0x50
;     423          	gpsString[i] = gpsString_buff[i] = getchar();
	MOVW R30,R16
	SUBI R30,LOW(-_gpsString)
	SBCI R31,HIGH(-_gpsString)
	PUSH R31
	PUSH R30
	MOVW R30,R16
	SUBI R30,LOW(-_gpsString_buff)
	SBCI R31,HIGH(-_gpsString_buff)
	PUSH R31
	PUSH R30
	RCALL _getchar
	POP  R26
	POP  R27
	ST   X,R30
	POP  R26
	POP  R27
	RCALL __EEPROMWRB
;     424         }
_0x4E:
	__ADDWRN 16,17,1
	RJMP _0x4F
_0x50:
;     425 
;     426 }
	RCALL __LOADLOCR2P
	RET
;     427 
;     428 void ParsingStringGPS(void) {
_ParsingStringGPS:
	PUSH R15
;     429  	int i, j, k, hitung_koma=0;
;     430         for(i=0; i<strlen(gpsString_buff); i++) {
	SBIW R28,2
	LDI  R24,2
	LDI  R26,LOW(0)
	LDI  R27,HIGH(0)
	LDI  R30,LOW(_0x51*2)
	LDI  R31,HIGH(_0x51*2)
	RCALL __INITLOCB
	RCALL __SAVELOCR6
;	i -> R16,R17
;	j -> R18,R19
;	k -> R20,R21
;	hitung_koma -> Y+6
	__GETWRN 16,17,0
_0x53:
	LDI  R30,LOW(_gpsString_buff)
	LDI  R31,HIGH(_gpsString_buff)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strlen
	CP   R16,R30
	CPC  R17,R31
	BRLO PC+2
	RJMP _0x54
;     431         	if(     (
;     432                 	(gpsString[i] == '$') &&
;     433                         (gpsString[i+3] == 'R') &&
;     434                         (gpsString[i+4] == 'M') &&
;     435                 	(gpsString[i+5] == 'C')
;     436                         )) {
	LDI  R26,LOW(_gpsString)
	LDI  R27,HIGH(_gpsString)
	ADD  R26,R16
	ADC  R27,R17
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x24)
	BREQ PC+2
	RJMP _0x56
	MOVW R30,R16
	__ADDW1MN _gpsString,3
	MOVW R26,R30
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x52)
	BREQ PC+2
	RJMP _0x56
	MOVW R30,R16
	__ADDW1MN _gpsString,4
	MOVW R26,R30
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x4D)
	BREQ PC+2
	RJMP _0x56
	MOVW R30,R16
	__ADDW1MN _gpsString,5
	MOVW R26,R30
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x43)
	BREQ PC+2
	RJMP _0x56
	RJMP _0x57
_0x56:
	RJMP _0x55
_0x57:
;     437                         for(k=i; k<strlen(gpsString_buff); k++) {
	MOVW R20,R16
_0x59:
	LDI  R30,LOW(_gpsString_buff)
	LDI  R31,HIGH(_gpsString_buff)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _strlen
	CP   R20,R30
	CPC  R21,R31
	BRLO PC+2
	RJMP _0x5A
;     438                            	if(gpsString[k] == ',') hitung_koma++;
	LDI  R26,LOW(_gpsString)
	LDI  R27,HIGH(_gpsString)
	ADD  R26,R20
	ADC  R27,R21
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x2C)
	BREQ PC+2
	RJMP _0x5B
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
;     439                 		if((hitung_koma == 2) && (gpsString[k+1] == 'V')) goto lompat;
_0x5B:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,2
	BREQ PC+2
	RJMP _0x5D
	MOVW R30,R20
	__ADDW1MN _gpsString,1
	MOVW R26,R30
	RCALL __EEPROMRDB
	CPI  R30,LOW(0x56)
	BREQ PC+2
	RJMP _0x5D
	RJMP _0x5E
_0x5D:
	RJMP _0x5C
_0x5E:
	RJMP _0x5F
;     440                 		if((hitung_koma == 3) && (isdigit(gpsString[k+1]))) {
_0x5C:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,3
	BREQ PC+2
	RJMP _0x61
	MOVW R30,R20
	__ADDW1MN _gpsString,1
	MOVW R26,R30
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _isdigit
	CPI  R30,0
	BRNE PC+2
	RJMP _0x61
	RJMP _0x62
_0x61:
	RJMP _0x60
_0x62:
;     441                 			for(j=0; j<7; j++) latitude[j] = gpsString[k+j+1];
	__GETWRN 18,19,0
_0x64:
	__CPWRN 18,19,7
	BRLT PC+2
	RJMP _0x65
	MOVW R30,R18
	SUBI R30,LOW(-_latitude)
	SBCI R31,HIGH(-_latitude)
	MOVW R0,R30
	MOVW R30,R18
	ADD  R30,R20
	ADC  R31,R21
	__ADDW1MN _gpsString,1
	MOVW R26,R30
	RCALL __EEPROMRDB
	MOVW R26,R0
	RCALL __EEPROMWRB
;     442                 		}
_0x63:
	__ADDWRN 18,19,1
	RJMP _0x64
_0x65:
;     443                 		if((hitung_koma == 4) && (isdigit(gpsString[k+1]))) latitude[7]=gpsString[k+1];
_0x60:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,4
	BREQ PC+2
	RJMP _0x67
	MOVW R30,R20
	__ADDW1MN _gpsString,1
	MOVW R26,R30
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _isdigit
	CPI  R30,0
	BRNE PC+2
	RJMP _0x67
	RJMP _0x68
_0x67:
	RJMP _0x66
_0x68:
	__POINTW1MN _latitude,7
	MOVW R0,R30
	MOVW R30,R20
	__ADDW1MN _gpsString,1
	MOVW R26,R30
	RCALL __EEPROMRDB
	MOVW R26,R0
	RCALL __EEPROMWRB
;     444                 		if((hitung_koma == 5) && (isdigit(gpsString[k+1]))) {
_0x66:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,5
	BREQ PC+2
	RJMP _0x6A
	MOVW R30,R20
	__ADDW1MN _gpsString,1
	MOVW R26,R30
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _isdigit
	CPI  R30,0
	BRNE PC+2
	RJMP _0x6A
	RJMP _0x6B
_0x6A:
	RJMP _0x69
_0x6B:
;     445                 			for(j=0; j<8; j++) longitude[j] = gpsString[k+j+1];
	__GETWRN 18,19,0
_0x6D:
	__CPWRN 18,19,8
	BRLT PC+2
	RJMP _0x6E
	MOVW R30,R18
	SUBI R30,LOW(-_longitude)
	SBCI R31,HIGH(-_longitude)
	MOVW R0,R30
	MOVW R30,R18
	ADD  R30,R20
	ADC  R31,R21
	__ADDW1MN _gpsString,1
	MOVW R26,R30
	RCALL __EEPROMRDB
	MOVW R26,R0
	RCALL __EEPROMWRB
;     446                 		}
_0x6C:
	__ADDWRN 18,19,1
	RJMP _0x6D
_0x6E:
;     447                			if((hitung_koma == 6) && (isdigit(gpsString[k+1]))) {
_0x69:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	SBIW R26,6
	BREQ PC+2
	RJMP _0x70
	MOVW R30,R20
	__ADDW1MN _gpsString,1
	MOVW R26,R30
	RCALL __EEPROMRDB
	ST   -Y,R30
	RCALL _isdigit
	CPI  R30,0
	BRNE PC+2
	RJMP _0x70
	RJMP _0x71
_0x70:
	RJMP _0x6F
_0x71:
;     448                                  	longitude[8]=gpsString[k+1];
	__POINTW1MN _longitude,8
	MOVW R0,R30
	MOVW R30,R20
	__ADDW1MN _gpsString,1
	MOVW R26,R30
	RCALL __EEPROMRDB
	MOVW R26,R0
	RCALL __EEPROMWRB
;     449                                         goto lompat;
	RJMP _0x5F
;     450                                 }
;     451                         }
_0x6F:
_0x58:
	__ADDWRN 20,21,1
	RJMP _0x59
_0x5A:
;     452                 }
;     453 
;     454                 lompat:
_0x55:
_0x5F:
;     455         }
_0x52:
	__ADDWRN 16,17,1
	RJMP _0x53
_0x54:
;     456 }
	RCALL __LOADLOCR6
	ADIW R28,8
	RET
;     457 
;     458 void Port_init(void) {
_Port_init:
	PUSH R15
;     459 	// Port B initialization
;     460 	// Func7=In Func6=In Func5=In Func4=Out Func3=Out Func2=Out Func1=Out Func0=Out
;     461 	// State7=T State6=T State5=T State4=0 State3=0 State2=0 State1=0 State0=0
;     462 	PORTB=0x00;
	LDI  R30,LOW(0)
	OUT  0x18,R30
;     463 	DDRB=0x1F;
	LDI  R30,LOW(31)
	OUT  0x17,R30
;     464 
;     465 	// Port D initialization
;     466 	// Func7=In Func6=In Func5=In Func4=In Func3=Out Func2=Out Func1=In Func0=In
;     467 	// State7=T State6=T State5=P State4=P State3=0 State2=0 State1=P State0=P
;     468 	PORTD=0x33;
	LDI  R30,LOW(51)
	OUT  0x12,R30
;     469 	DDRD=0x0C;
	LDI  R30,LOW(12)
	OUT  0x11,R30
;     470 }
	RET
;     471 
;     472 void USART_init(unsigned int baud_rate) {
_USART_init:
	PUSH R15
;     473 	if(baud_rate == 4800) {
;	baud_rate -> Y+0
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x12C0)
	LDI  R30,HIGH(0x12C0)
	CPC  R27,R30
	BREQ PC+2
	RJMP _0x72
;     474         	// USART initialization
;     475 		// Communication Parameters: 8 Data, 1 Stop, No Parity
;     476 		// USART Receiver: On
;     477 		// USART Transmitter: On
;     478 		// USART Mode: Asynchronous
;     479 		// USART Baud Rate: 4800
;     480 		UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;     481 		UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
;     482 		UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     483 		UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     484 		UBRRL=0x8F;
	LDI  R30,LOW(143)
	OUT  0x9,R30
;     485         }
;     486         if(baud_rate == 38400) {
_0x72:
	LD   R26,Y
	LDD  R27,Y+1
	CPI  R26,LOW(0x9600)
	LDI  R30,HIGH(0x9600)
	CPC  R27,R30
	BREQ PC+2
	RJMP _0x73
;     487         	// USART initialization
;     488 		// Communication Parameters: 8 Data, 1 Stop, No Parity
;     489 		// USART Receiver: On
;     490 		// USART Transmitter: On
;     491 		// USART Mode: Asynchronous
;     492 		// USART Baud Rate: 38400
;     493 		UCSRA=0x00;
	LDI  R30,LOW(0)
	OUT  0xB,R30
;     494 		UCSRB=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
;     495 		UCSRC=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
;     496 		UBRRH=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
;     497 		UBRRL=0x11;
	LDI  R30,LOW(17)
	OUT  0x9,R30
;     498         }
;     499 }
_0x73:
	ADIW R28,2
	RET
;     500 
;     501 void main(void) {
_main:
;     502 	Port_init();
	RCALL _Port_init
;     503         USART_init(4800);
	LDI  R30,LOW(4800)
	LDI  R31,HIGH(4800)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _USART_init
;     504 
;     505 	ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     506 	SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     507 
;     508         while(1) {
_0x74:
;     509          	STBY_LED_ON;
	CBI  0x12,3
;     510 
;     511                 if(MODE) 	GPS_ENABLED;
	SBIS 0x10,4
	RJMP _0x77
	SET
	BLD  R2,3
;     512         	if(!MODE) 	GPS_DISABLED;
_0x77:
	SBIC 0x10,4
	RJMP _0x78
	CLT
	BLD  R2,3
;     513 
;     514                 if(gps_status) 	goto pakai_gps;
_0x78:
	SBRS R2,3
	RJMP _0x79
	RJMP _0x7A
;     515         	if(!gps_status) goto gak_pakai_gps;
_0x79:
	SBRC R2,3
	RJMP _0x7B
	RJMP _0x7C
;     516 
;     517                 gak_pakai_gps:
_0x7B:
_0x7C:
;     518                 	if(!TX_NOW) {
	SBIC 0x10,5
	RJMP _0x7D
;     519                 		delay_ms(125);
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _delay_ms
;     520                        	 	STBY_LED_OFF;
	CBI  0x12,3
;     521                 		protocol();
	RCALL _protocol
;     522                 	}
;     523                         goto jump;
_0x7D:
	RJMP _0x7E
;     524                 pakai_gps:
_0x7A:
;     525                 	#asm("sei")
	sei
;     526                 	TerimaMentahGPS();
	RCALL _TerimaMentahGPS
;     527                 	#asm("cli")
	cli
;     528                 	ParsingStringGPS();
	RCALL _ParsingStringGPS
;     529                         STBY_LED_OFF;
	CBI  0x12,3
;     530                 	protocol();
	RCALL _protocol
;     531                 jump:
_0x7E:
;     532         }
	RJMP _0x74
_0x76:
;     533 }
_0x7F:
	RJMP _0x7F
_isdigit:
	ldi  r30,1
	ld   r31,y+
	cpi  r31,'0'
	brlo __isdigit0
	cpi  r31,'9'+1
	brlo __isdigit1
__isdigit0:
	clr  r30
__isdigit1:
	ret

_strlen:
	ld   r26,y+
	ld   r27,y+
	clr  r30
	clr  r31
__strlen0:
	ld   r22,x+
	tst  r22
	breq __strlen1
	adiw r30,1
	rjmp __strlen0
__strlen1:
	ret

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

__LSLB12:
	TST  R30
	MOV  R0,R30
	MOV  R30,R26
	BREQ __LSLB12R
__LSLB12L:
	LSL  R30
	DEC  R0
	BRNE __LSLB12L
__LSLB12R:
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
	SBIC EECR,EEWE
	RJMP __EEPROMWRB
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

__LOADLOCR2P:
	LD   R16,Y+
	LD   R17,Y+
	RET

__INITLOCB:
__INITLOCW:
	ADD R26,R28
	ADC R27,R29
__INITLOC0:
	LPM  R0,Z+
	ST   X+,R0
	DEC  R24
	BRNE __INITLOC0
	RET

;END OF CODE MARKER
__END_OF_CODE:
