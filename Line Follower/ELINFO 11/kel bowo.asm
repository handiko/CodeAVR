
;CodeVisionAVR C Compiler V1.25.3 Professional
;(C) Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 8.000000 MHz
;Memory model           : Small
;Optimize for           : Size
;(s)printf features     : int, width
;(s)scanf features      : int, width
;External SRAM size     : 0
;Data Stack size        : 256 byte(s)
;Heap size              : 0 byte(s)
;Promote char to int    : No
;char is unsigned       : Yes
;8 bit enums            : Yes
;Word align FLASH struct: No
;Enhanced core instructions    : On
;Smart register allocation : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega16
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1024
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+@1)
	LDI  R27,HIGH(@0+@1)
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

	.INCLUDE "kel bowo.vec"
	.INCLUDE "kel bowo.inc"

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
	LDI  R24,LOW(0x400)
	LDI  R25,HIGH(0x400)
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
	LDI  R30,LOW(0x45F)
	OUT  SPL,R30
	LDI  R30,HIGH(0x45F)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(0x160)
	LDI  R29,HIGH(0x160)

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x160
;       1 
;       2 /*****************************************************
;       3 This program was produced by the
;       4 CodeWizardAVR V1.25.3 Standard
;       5 Automatic Program Generator
;       6 © Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;       7 http://www.hpinfotech.com
;       8 
;       9 Project :
;      10 Version :
;      11 Date    : 6/25/2008
;      12 Author  : F4CG
;      13 Company : F4CG
;      14 Comments: test PID
;      15 
;      16 
;      17 Chip type           : ATmega16
;      18 Program type        : Application
;      19 Clock frequency     : 12.000000 MHz
;      20 Memory model        : Small
;      21 External SRAM size  : 0
;      22 Data Stack size     : 256
;      23 *****************************************************/
;      24 
;      25 #include <mega16.h>
;      26 #include <delay.h>
;      27 #include <stdio.h>
;      28 #include <lcd.h>
;      29 
;      30 #define sw_ok           PINC.0
;      31 #define sw_cancel       PINC.1
;      32 #define sw_up           PINC.2
;      33 #define sw_down         PINC.3
;      34 
;      35 #define Enki    PORTD.7
;      36 #define kirplus PORTD.5
;      37 #define kirmin  PORTD.4
;      38 #define Enka    PORTD.6
;      39 #define kaplus  PORTD.3
;      40 #define kamin   PORTD.2
;      41 
;      42 #define ADC_VREF_TYPE 0x20
;      43 
;      44 #asm
;      45    .equ __lcd_port=0x18 ;PORTB
   .equ __lcd_port=0x18 ;PORTB
;      46 #endasm
;      47 
;      48 char lcd[16];
_lcd:
	.BYTE 0x10
;      49 unsigned char sensor, adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7;
;      50 eeprom unsigned char bt7=7,bt6=7,bt5=7,bt4=7,bt3=7,bt2=7,bt1=7,bt0=9;

	.ESEG
_bt7:
	.DB  0x7
_bt6:
	.DB  0x7
_bt5:
	.DB  0x7
_bt4:
	.DB  0x7
_bt3:
	.DB  0x7
_bt2:
	.DB  0x7
_bt1:
	.DB  0x7
_bt0:
	.DB  0x9
;      51 unsigned char ba7=7,ba6=7,ba5=7,ba4=7,ba3=7,ba2=7,ba1=7,ba0=9;

	.DSEG
_ba6:
	.BYTE 0x1
_ba5:
	.BYTE 0x1
_ba4:
	.BYTE 0x1
_ba3:
	.BYTE 0x1
_ba2:
	.BYTE 0x1
_ba1:
	.BYTE 0x1
_ba0:
	.BYTE 0x1
;      52 unsigned char bb7=7,bb6=7,bb5=7,bb4=7,bb3=7,bb2=7,bb1=7,bb0=9;
_bb7:
	.BYTE 0x1
_bb6:
	.BYTE 0x1
_bb5:
	.BYTE 0x1
_bb4:
	.BYTE 0x1
_bb3:
	.BYTE 0x1
_bb2:
	.BYTE 0x1
_bb1:
	.BYTE 0x1
_bb0:
	.BYTE 0x1
;      53 unsigned char xcount;
_xcount:
	.BYTE 0x1
;      54 bit s0,s1,s2,s3,s4,s5,s6,s7;
;      55 int lpwm, rpwm, MAXPWM=255, MINPWM=0, intervalPWM;
_lpwm:
	.BYTE 0x2
_rpwm:
	.BYTE 0x2
_MAXPWM:
	.BYTE 0x2
_MINPWM:
	.BYTE 0x2
_intervalPWM:
	.BYTE 0x2
;      56 typedef unsigned char byte;
;      57 int PV, error, last_error, d_error;
_PV:
	.BYTE 0x2
_error:
	.BYTE 0x2
_last_error:
	.BYTE 0x2
_d_error:
	.BYTE 0x2
;      58 int var_Kp, var_Ki, var_Kd;
_var_Kp:
	.BYTE 0x2
_var_Ki:
	.BYTE 0x2
_var_Kd:
	.BYTE 0x2
;      59 byte kursorPID, kursorSpeed, kursorGaris;
_kursorPID:
	.BYTE 0x1
_kursorSpeed:
	.BYTE 0x1
_kursorGaris:
	.BYTE 0x1
;      60 char lcd_buffer[33];
_lcd_buffer:
	.BYTE 0x21
;      61 int b;
_b:
	.BYTE 0x2
;      62 int x;
_x:
	.BYTE 0x2
;      63 
;      64 eeprom byte Kp = 10;

	.ESEG
_Kp:
	.DB  0xA
;      65 eeprom byte Ki = 5;
_Ki:
	.DB  0x5
;      66 eeprom byte Kd = 7;
_Kd:
	.DB  0x7
;      67 eeprom byte MAXSpeed = 255;
_MAXSpeed:
	.DB  0xFF
;      68 eeprom byte MINSpeed = 0;
_MINSpeed:
	.DB  0x0
;      69 eeprom byte WarnaGaris = 0;     // 1 : putih, 0 : hitam
_WarnaGaris:
	.DB  0x0
;      70 eeprom byte SensLine = 2;       // banyaknya sensor dlm 1 garis
_SensLine:
	.DB  0x2
;      71 eeprom byte Skenario = 2;
_Skenario:
	.DB  0x2
;      72 eeprom byte Mode = 1;
_Mode:
	.DB  0x1
;      73 
;      74 void showMenu();
;      75 void displaySensorBit();
;      76 void maju();
;      77 void mundur();
;      78 void bkan();
;      79 void bkir();
;      80 void rotkan();
;      81 void rotkir();
;      82 void stop();
;      83 void ikuti_garis();
;      84 void cek_sensor();
;      85 void baca_sensor();
;      86 void tune_batas();
;      87 void auto_scan();
;      88 void pemercepat();
;      89 void pelambat();
;      90 
;      91 unsigned char read_adc(unsigned char adc_input)
;      92 {

	.CSEG
_read_adc:
;      93     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
;      94     delay_us(10);       // time sampling
	__DELAY_USB 27
;      95     ADCSRA|=0x40;
	SBI  0x6,6
;      96     while ((ADCSRA & 0x10)==0);
_0x14:
	SBIS 0x6,4
	RJMP _0x14
;      97     ADCSRA|=0x10;
	SBI  0x6,4
;      98     return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
;      99 }
;     100 
;     101 /*flash byte char0[8]=
;     102 {
;     103     0b1100000,
;     104     0b0011000,
;     105     0b0000110,
;     106     0b1111111,
;     107     0b1111111,
;     108     0b0000110,
;     109     0b0011000,
;     110     0b1100000
;     111 };/
;     112 
;     113 void define_char(byte flash *pc,byte char_code)
;     114 {
;     115         byte i,a;
;     116         a=(char_code<<3) | 0x40;
;     117         for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
;     118 }*/
;     119 
;     120 void main(void)
;     121 {
_main:
;     122         PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     123         DDRA=0x00;
	OUT  0x1A,R30
;     124 
;     125         PORTB=0x00;
	OUT  0x18,R30
;     126         DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     127 
;     128         PORTC=0x0F;
	LDI  R30,LOW(15)
	OUT  0x15,R30
;     129         DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
;     130 
;     131         PORTD=0x00;
	OUT  0x12,R30
;     132         DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
;     133 
;     134         TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;     135 
;     136         ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     137         SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     138 
;     139         ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
;     140         ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
;     141 
;     142         lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
;     143 
;     144         TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     145         stop();
	RCALL _stop
;     146 
;     147         delay_ms(125);
	CALL SUBOPT_0x0
;     148         lcd_gotoxy(0,0);
;     149                 // 0123456789ABCDEF
;     150         lcd_putsf("  baru_belajar  ");
	__POINTW1FN _0,0
	CALL SUBOPT_0x1
;     151         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     152         lcd_putsf("      by :      ");
	__POINTW1FN _0,17
	CALL SUBOPT_0x1
;     153         delay_ms(500);
	CALL SUBOPT_0x3
;     154         lcd_clear();
;     155 
;     156         delay_ms(125);
	CALL SUBOPT_0x0
;     157         lcd_gotoxy(0,0);
;     158                 // 0123456789ABCDEF
;     159         lcd_putsf(" ?????????????? ");
	__POINTW1FN _0,34
	CALL SUBOPT_0x1
;     160         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     161         lcd_putsf(" !!!!!!!!!!!!!! ");
	__POINTW1FN _0,51
	CALL SUBOPT_0x1
;     162         delay_ms(1300);
	LDI  R30,LOW(1300)
	LDI  R31,HIGH(1300)
	CALL SUBOPT_0x4
;     163         lcd_clear();
	CALL _lcd_clear
;     164 
;     165         delay_ms(125);
	CALL SUBOPT_0x0
;     166         lcd_gotoxy(0,0);
;     167                 // 0123456789ABCDEF
;     168         lcd_putsf("     LPKTA     ");
	__POINTW1FN _0,68
	CALL SUBOPT_0x1
;     169         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     170         lcd_putsf(" FT - UGM - 11 ");
	__POINTW1FN _0,84
	CALL SUBOPT_0x1
;     171         delay_ms(500);
	CALL SUBOPT_0x3
;     172         lcd_clear();
;     173 
;     174         TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     175         #asm("sei")
	sei
;     176 
;     177         mundur();
	RCALL _mundur
;     178         delay_ms(200);
	CALL SUBOPT_0x5
;     179         stop();
	RCALL _stop
;     180         var_Kp  = Kp;
	CALL SUBOPT_0x6
	LDI  R31,0
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
;     181         var_Ki  = Ki;
	CALL SUBOPT_0x7
	LDI  R31,0
	STS  _var_Ki,R30
	STS  _var_Ki+1,R31
;     182         var_Kd  = Kd;
	CALL SUBOPT_0x8
	LDI  R31,0
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
;     183         MAXPWM  = (int)MAXSpeed + 1;
	CALL SUBOPT_0x9
	LDI  R31,0
	ADIW R30,1
	STS  _MAXPWM,R30
	STS  _MAXPWM+1,R31
;     184         MINPWM  = MINSpeed;
	CALL SUBOPT_0xA
	LDI  R31,0
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
;     185 
;     186         intervalPWM = (MAXSpeed - MINSpeed) / 8;
	CALL SUBOPT_0x9
	MOV  R0,R30
	CALL SUBOPT_0xA
	MOV  R26,R0
	SUB  R26,R30
	MOV  R30,R26
	LSR  R30
	LSR  R30
	LSR  R30
	LDI  R31,0
	STS  _intervalPWM,R30
	STS  _intervalPWM+1,R31
;     187         PV = 0;
	LDI  R30,0
	STS  _PV,R30
	STS  _PV+1,R30
;     188         error = 0;
	LDI  R30,0
	STS  _error,R30
	STS  _error+1,R30
;     189         last_error = 0;
	LDI  R30,0
	STS  _last_error,R30
	STS  _last_error+1,R30
;     190 
;     191         showMenu();
	RCALL _showMenu
;     192         maju();
	RCALL _maju
;     193         displaySensorBit();
	RCALL _displaySensorBit
;     194         #asm("sei")
	sei
;     195         TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;     196         while (1)
_0x17:
;     197         {
;     198                 displaySensorBit();
	RCALL _displaySensorBit
;     199                 //ikuti_garis();
;     200                 lpwm = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0xB
;     201                 rpwm = 100;
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0xC
;     202 
;     203                 kirplus = 0;
	CBI  0x12,5
;     204                 kirmin = 1;
	SBI  0x12,4
;     205 
;     206                 kaplus = 1;
	SBI  0x12,3
;     207                 kamin  = 0;
	CBI  0x12,2
;     208         };
	RJMP _0x17
;     209 }
_0x1A:
	RJMP _0x1A
;     210 
;     211 void pemercepat()
;     212 {
_pemercepat:
;     213         lpwm=0;
	CALL SUBOPT_0xD
;     214         rpwm=0;
;     215 
;     216         rotkir();
	RCALL _rotkir
;     217 
;     218         for(b=0;b<255;b++)
	LDI  R30,0
	STS  _b,R30
	STS  _b+1,R30
_0x1C:
	CALL SUBOPT_0xE
	BRGE _0x1D
;     219         {
;     220                 delay_ms(125);
	CALL SUBOPT_0xF
;     221 
;     222                 lpwm++;
	CALL SUBOPT_0x10
	ADIW R30,1
	CALL SUBOPT_0x11
;     223                 rpwm++;
	ADIW R30,1
	CALL SUBOPT_0x12
;     224 
;     225                 lcd_clear();
;     226 
;     227                 lcd_gotoxy(0,0);
;     228                 sprintf(lcd," %d %d",lpwm,rpwm);
;     229                 lcd_puts(lcd);
;     230         }
	CALL SUBOPT_0x13
	RJMP _0x1C
_0x1D:
;     231         lpwm=0;
	CALL SUBOPT_0xD
;     232         rpwm=0;
;     233 }
	RET
;     234 
;     235 void pelambat()
;     236 {
_pelambat:
;     237         lpwm=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0xB
;     238         rpwm=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0xC
;     239 
;     240         rotkan();
	RCALL _rotkan
;     241 
;     242         for(b=0;b<255;b++)
	LDI  R30,0
	STS  _b,R30
	STS  _b+1,R30
_0x1F:
	CALL SUBOPT_0xE
	BRGE _0x20
;     243         {
;     244                 delay_ms(125);
	CALL SUBOPT_0xF
;     245 
;     246                 lpwm--;
	CALL SUBOPT_0x10
	SBIW R30,1
	CALL SUBOPT_0x11
;     247                 rpwm--;
	SBIW R30,1
	CALL SUBOPT_0x12
;     248 
;     249                 lcd_clear();
;     250 
;     251                 lcd_gotoxy(0,0);
;     252                 sprintf(lcd," %d %d",lpwm,rpwm);
;     253                 lcd_puts(lcd);
;     254         }
	CALL SUBOPT_0x13
	RJMP _0x1F
_0x20:
;     255         lpwm=0;
	CALL SUBOPT_0xD
;     256         rpwm=0;
;     257 }
	RET
;     258 
;     259 void baca_sensor()
;     260 {
_baca_sensor:
;     261         sensor=0;
	CLR  R5
;     262         adc0=read_adc(0);
	CALL SUBOPT_0x14
	MOV  R4,R30
;     263         adc1=read_adc(1);
	CALL SUBOPT_0x15
	MOV  R7,R30
;     264         adc2=read_adc(2);
	CALL SUBOPT_0x16
	MOV  R6,R30
;     265         adc3=read_adc(3);
	CALL SUBOPT_0x17
	MOV  R9,R30
;     266         adc4=read_adc(4);
	CALL SUBOPT_0x18
	MOV  R8,R30
;     267         adc5=read_adc(5);
	CALL SUBOPT_0x19
	MOV  R11,R30
;     268         adc6=read_adc(6);
	CALL SUBOPT_0x1A
	MOV  R10,R30
;     269         adc7=read_adc(7);
	CALL SUBOPT_0x1B
	MOV  R13,R30
;     270 
;     271         if(adc0>bt0){s0=1;sensor=sensor|1<<0;}
	CALL SUBOPT_0x1C
	CP   R30,R4
	BRSH _0x21
	SET
	BLD  R2,0
	LDI  R30,LOW(1)
	RJMP _0x1E0
;     272         else {s0=0;sensor=sensor|0<<0;}
_0x21:
	CLT
	BLD  R2,0
	LDI  R30,LOW(0)
_0x1E0:
	OR   R5,R30
;     273 
;     274         if(adc1>bt1){s1=1;sensor=sensor|1<<1;}
	CALL SUBOPT_0x1D
	CP   R30,R7
	BRSH _0x23
	SET
	BLD  R2,1
	LDI  R30,LOW(2)
	RJMP _0x1E1
;     275         else {s1=0;sensor=sensor|0<<1;}
_0x23:
	CLT
	BLD  R2,1
	LDI  R30,LOW(0)
_0x1E1:
	OR   R5,R30
;     276 
;     277         if(adc2>bt2){s2=1;sensor=sensor|1<<2;}
	CALL SUBOPT_0x1E
	CP   R30,R6
	BRSH _0x25
	SET
	BLD  R2,2
	LDI  R30,LOW(4)
	RJMP _0x1E2
;     278         else {s2=0;sensor=sensor|0<<2;}
_0x25:
	CLT
	BLD  R2,2
	LDI  R30,LOW(0)
_0x1E2:
	OR   R5,R30
;     279 
;     280         if(adc3>bt3){s3=1;sensor=sensor|1<<3;}
	CALL SUBOPT_0x1F
	CP   R30,R9
	BRSH _0x27
	SET
	BLD  R2,3
	LDI  R30,LOW(8)
	RJMP _0x1E3
;     281         else {s3=0;sensor=sensor|0<<3;}
_0x27:
	CLT
	BLD  R2,3
	LDI  R30,LOW(0)
_0x1E3:
	OR   R5,R30
;     282 
;     283         if(adc4>bt4){s4=1;sensor=sensor|1<<4;}
	CALL SUBOPT_0x20
	CP   R30,R8
	BRSH _0x29
	SET
	BLD  R2,4
	LDI  R30,LOW(16)
	RJMP _0x1E4
;     284         else {s4=0;sensor=sensor|0<<4;}
_0x29:
	CLT
	BLD  R2,4
	LDI  R30,LOW(0)
_0x1E4:
	OR   R5,R30
;     285 
;     286         if(adc5>bt5){s5=1;sensor=sensor|1<<5;}
	CALL SUBOPT_0x21
	CP   R30,R11
	BRSH _0x2B
	SET
	BLD  R2,5
	LDI  R30,LOW(32)
	RJMP _0x1E5
;     287         else {s5=0;sensor=sensor|0<<5;}
_0x2B:
	CLT
	BLD  R2,5
	LDI  R30,LOW(0)
_0x1E5:
	OR   R5,R30
;     288 
;     289         if(adc6>bt6){s6=1;sensor=sensor|1<<6;}
	CALL SUBOPT_0x22
	CP   R30,R10
	BRSH _0x2D
	SET
	BLD  R2,6
	LDI  R30,LOW(64)
	RJMP _0x1E6
;     290         else {s6=0;sensor=sensor|0<<6;}
_0x2D:
	CLT
	BLD  R2,6
	LDI  R30,LOW(0)
_0x1E6:
	OR   R5,R30
;     291 
;     292         if(adc7>bt7){s7=1;sensor=sensor|1<<7;}
	CALL SUBOPT_0x23
	CP   R30,R13
	BRSH _0x2F
	SET
	BLD  R2,7
	LDI  R30,LOW(128)
	RJMP _0x1E7
;     293         else {s7=0;sensor=sensor|0<<7;}
_0x2F:
	CLT
	BLD  R2,7
	LDI  R30,LOW(0)
_0x1E7:
	OR   R5,R30
;     294 }
	RET
;     295 
;     296 void tampil(unsigned char dat)
;     297 {
_tampil:
;     298     unsigned char data;
;     299 
;     300     data = dat / 100;
	ST   -Y,R17
;	dat -> Y+1
;	data -> R17
	LDD  R26,Y+1
	LDI  R30,LOW(100)
	CALL SUBOPT_0x24
;     301     data+=0x30;
;     302     lcd_putchar(data);
;     303 
;     304     dat%=100;
	LDI  R30,LOW(100)
	CALL __MODB21U
	STD  Y+1,R30
;     305     data = dat / 10;
	LDD  R26,Y+1
	LDI  R30,LOW(10)
	CALL SUBOPT_0x24
;     306     data+=0x30;
;     307     lcd_putchar(data);
;     308 
;     309     dat%=10;
	LDI  R30,LOW(10)
	CALL __MODB21U
	STD  Y+1,R30
;     310     data = dat + 0x30;
	SUBI R30,-LOW(48)
	MOV  R17,R30
;     311     lcd_putchar(data);
	ST   -Y,R17
	CALL _lcd_putchar
;     312 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;     313 
;     314 void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom )
;     315 {
_tulisKeEEPROM:
;     316         lcd_gotoxy(0,0);
;	NoMenu -> Y+2
;	NoSubMenu -> Y+1
;	var_in_eeprom -> Y+0
	CALL SUBOPT_0x25
;     317         lcd_putsf("Tulis ke EEPROM ");
	__POINTW1FN _0,107
	CALL SUBOPT_0x1
;     318         lcd_putsf("...             ");
	__POINTW1FN _0,124
	CALL SUBOPT_0x1
;     319         switch (NoMenu)
	LDD  R30,Y+2
;     320         {
;     321           case 1: // PID
	CPI  R30,LOW(0x1)
	BRNE _0x34
;     322                 switch (NoSubMenu)
	LDD  R30,Y+1
;     323                 {
;     324                   case 1: // Kp
	CPI  R30,LOW(0x1)
	BRNE _0x38
;     325                         Kp = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL __EEPROMWRB
;     326                         break;
	RJMP _0x37
;     327                   case 2: // Ki
_0x38:
	CPI  R30,LOW(0x2)
	BRNE _0x39
;     328                         Ki = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMWRB
;     329                         break;
	RJMP _0x37
;     330                   case 3: // Kd
_0x39:
	CPI  R30,LOW(0x3)
	BRNE _0x37
;     331                         Kd = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL __EEPROMWRB
;     332                         break;
;     333                 }
_0x37:
;     334                 break;
	RJMP _0x33
;     335           case 2: // Speed
_0x34:
	CPI  R30,LOW(0x2)
	BRNE _0x3B
;     336                 switch (NoSubMenu)
	LDD  R30,Y+1
;     337                 {
;     338                   case 1: // MAX
	CPI  R30,LOW(0x1)
	BRNE _0x3F
;     339                         MAXSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL __EEPROMWRB
;     340                         break;
	RJMP _0x3E
;     341                   case 2: // MIN
_0x3F:
	CPI  R30,LOW(0x2)
	BRNE _0x3E
;     342                         MINSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL __EEPROMWRB
;     343                         break;
;     344                 }
_0x3E:
;     345                 break;
	RJMP _0x33
;     346           case 3: // Warna Garis
_0x3B:
	CPI  R30,LOW(0x3)
	BRNE _0x41
;     347                 switch (NoSubMenu)
	LDD  R30,Y+1
;     348                 {
;     349                   case 1: // Warna
	CPI  R30,LOW(0x1)
	BRNE _0x45
;     350                         WarnaGaris = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMWRB
;     351                         break;
	RJMP _0x44
;     352                   case 2: // SensL
_0x45:
	CPI  R30,LOW(0x2)
	BRNE _0x44
;     353                         SensLine = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMWRB
;     354                         break;
;     355                 }
_0x44:
;     356                 break;
	RJMP _0x33
;     357           case 4: // Skenario
_0x41:
	CPI  R30,LOW(0x4)
	BRNE _0x33
;     358                 Skenario = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMWRB
;     359                 break;
;     360         }
_0x33:
;     361         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x4
;     362 }
	ADIW R28,3
	RET
;     363 
;     364 void setByte( byte NoMenu, byte NoSubMenu )
;     365 {
_setByte:
;     366         byte var_in_eeprom;
;     367         byte plus5 = 0;
;     368         char limitPilih = -1;
;     369 
;     370         lcd_clear();
	CALL __SAVELOCR4
;	NoMenu -> Y+5
;	NoSubMenu -> Y+4
;	var_in_eeprom -> R17
;	plus5 -> R16
;	limitPilih -> R19
	LDI  R16,0
	LDI  R19,255
	CALL SUBOPT_0x26
;     371         lcd_gotoxy(0, 0);
;     372         switch (NoMenu)
	LDD  R30,Y+5
;     373         {
;     374           case 1: // PID
	CPI  R30,LOW(0x1)
	BRNE _0x4B
;     375                 switch (NoSubMenu)
	LDD  R30,Y+4
;     376                 {
;     377                   case 1: // Kp
	CPI  R30,LOW(0x1)
	BRNE _0x4F
;     378                         lcd_putsf("Set Kp :        ");
	__POINTW1FN _0,141
	CALL SUBOPT_0x1
;     379                         var_in_eeprom = Kp;
	CALL SUBOPT_0x6
	RJMP _0x1E8
;     380                         break;
;     381                   case 2: // Ki
_0x4F:
	CPI  R30,LOW(0x2)
	BRNE _0x50
;     382                         lcd_putsf("Set Ki :        ");
	__POINTW1FN _0,158
	CALL SUBOPT_0x1
;     383                         var_in_eeprom = Ki;
	CALL SUBOPT_0x7
	RJMP _0x1E8
;     384                         break;
;     385                   case 3: // Kd
_0x50:
	CPI  R30,LOW(0x3)
	BRNE _0x4E
;     386                         lcd_putsf("Set Kd :        ");
	__POINTW1FN _0,175
	CALL SUBOPT_0x1
;     387                         var_in_eeprom = Kd;
	CALL SUBOPT_0x8
_0x1E8:
	MOV  R17,R30
;     388                         break;
;     389                 }
_0x4E:
;     390                 break;
	RJMP _0x4A
;     391           case 2: // Speed
_0x4B:
	CPI  R30,LOW(0x2)
	BRNE _0x52
;     392                 plus5 = 1;
	LDI  R16,LOW(1)
;     393                 switch (NoSubMenu)
	LDD  R30,Y+4
;     394                 {
;     395                   case 1: // MAX
	CPI  R30,LOW(0x1)
	BRNE _0x56
;     396                         lcd_putsf("Set MAX Speed : ");
	__POINTW1FN _0,192
	CALL SUBOPT_0x1
;     397                         var_in_eeprom = MAXSpeed;
	CALL SUBOPT_0x9
	RJMP _0x1E9
;     398                         break;
;     399                   case 2: // MIN
_0x56:
	CPI  R30,LOW(0x2)
	BRNE _0x55
;     400                         lcd_putsf("Set MIN Speed : ");
	__POINTW1FN _0,209
	CALL SUBOPT_0x1
;     401                         var_in_eeprom = MINSpeed;
	CALL SUBOPT_0xA
_0x1E9:
	MOV  R17,R30
;     402                         break;
;     403                 }
_0x55:
;     404                 break;
	RJMP _0x4A
;     405           case 3: // Warna Garis
_0x52:
	CPI  R30,LOW(0x3)
	BRNE _0x58
;     406                 switch (NoSubMenu)
	LDD  R30,Y+4
;     407                 {
;     408                   case 1: // Warna
	CPI  R30,LOW(0x1)
	BRNE _0x5C
;     409                         limitPilih = 1;
	LDI  R19,LOW(1)
;     410                         lcd_putsf("Warna Garis   : ");
	__POINTW1FN _0,226
	CALL SUBOPT_0x1
;     411                         var_in_eeprom = WarnaGaris;
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	RJMP _0x1EA
;     412                         break;
;     413                   case 2: // SensL
_0x5C:
	CPI  R30,LOW(0x2)
	BRNE _0x5B
;     414                         limitPilih = 3;
	LDI  R19,LOW(3)
;     415                         lcd_putsf("SensLine :      ");
	__POINTW1FN _0,243
	CALL SUBOPT_0x1
;     416                         var_in_eeprom = SensLine;
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
_0x1EA:
	MOV  R17,R30
;     417                         break;
;     418                 }
_0x5B:
;     419                 break;
	RJMP _0x4A
;     420           case 4: // Skenario
_0x58:
	CPI  R30,LOW(0x4)
	BRNE _0x4A
;     421                   lcd_putsf("Skenario :      ");
	__POINTW1FN _0,260
	CALL SUBOPT_0x1
;     422                   var_in_eeprom = Skenario;
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	MOV  R17,R30
;     423                   limitPilih = 8;
	LDI  R19,LOW(8)
;     424                   break;
;     425         }
_0x4A:
;     426 
;     427         while (sw_cancel)
_0x5F:
	SBIS 0x13,1
	RJMP _0x61
;     428         {
;     429                 delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x4
;     430                 lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
;     431                 tampil(var_in_eeprom);
	ST   -Y,R17
	CALL _tampil
;     432 
;     433                 if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x62
;     434                 {
;     435                         lcd_clear();
	CALL _lcd_clear
;     436                         tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R17
	CALL _tulisKeEEPROM
;     437                         goto exitSetByte;
	RJMP _0x63
;     438                 }
;     439                 if (!sw_down)
_0x62:
	SBIC 0x13,3
	RJMP _0x64
;     440                 {
;     441                         if ( plus5 )
	CPI  R16,0
	BREQ _0x65
;     442                                 if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x66
;     443                                         var_in_eeprom = 255;
	LDI  R17,LOW(255)
;     444                                 else
	RJMP _0x67
_0x66:
;     445                                         var_in_eeprom -= 5;
	SUBI R17,LOW(5)
;     446                         else
_0x67:
	RJMP _0x68
_0x65:
;     447                                 if ( !limitPilih )
	CPI  R19,0
	BRNE _0x69
;     448                                         var_in_eeprom--;
	RJMP _0x1EB
;     449                                 else
_0x69:
;     450                                 {
;     451                                         if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x6B
;     452                                           var_in_eeprom = limitPilih;
	MOV  R17,R19
;     453                                         else
	RJMP _0x6C
_0x6B:
;     454                                           var_in_eeprom--;
_0x1EB:
	SUBI R17,1
;     455                                 }
_0x6C:
_0x68:
;     456                 }
;     457                 if (!sw_up)
_0x64:
	SBIC 0x13,2
	RJMP _0x6D
;     458                 {
;     459                         if ( plus5 )
	CPI  R16,0
	BREQ _0x6E
;     460                                 if ( var_in_eeprom == 255 )
	CPI  R17,255
	BRNE _0x6F
;     461                                         var_in_eeprom = 0;
	LDI  R17,LOW(0)
;     462                                 else
	RJMP _0x70
_0x6F:
;     463                                         var_in_eeprom += 5;
	SUBI R17,-LOW(5)
;     464                         else
_0x70:
	RJMP _0x71
_0x6E:
;     465                                 if ( !limitPilih )
	CPI  R19,0
	BRNE _0x72
;     466                                         var_in_eeprom++;
	RJMP _0x1EC
;     467                                 else
_0x72:
;     468                                 {
;     469                                         if ( var_in_eeprom == limitPilih )
	CP   R19,R17
	BRNE _0x74
;     470                                           var_in_eeprom = 0;
	LDI  R17,LOW(0)
;     471                                         else
	RJMP _0x75
_0x74:
;     472                                           var_in_eeprom++;
_0x1EC:
	SUBI R17,-1
;     473                                 }
_0x75:
_0x71:
;     474                 }
;     475         }
_0x6D:
	RJMP _0x5F
_0x61:
;     476       exitSetByte:
_0x63:
;     477         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
;     478         lcd_clear();
	CALL _lcd_clear
;     479 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;     480 
;     481 void showMenu()
;     482 {
_showMenu:
;     483         //TIMSK = 0x00;
;     484         //#asm("cli")
;     485         lcd_clear();
	CALL _lcd_clear
;     486     menu01:
_0x76:
;     487         delay_ms(225);   // bouncing sw
	CALL SUBOPT_0x27
;     488         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     489                 // 0123456789abcdef
;     490         lcd_putsf("  Set PID       ");
	__POINTW1FN _0,277
	CALL SUBOPT_0x1
;     491         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     492         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0,294
	CALL SUBOPT_0x1
;     493 
;     494         // kursor awal
;     495         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     496         lcd_putchar(0);
	CALL SUBOPT_0x28
;     497 
;     498         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x77
;     499         {
;     500                 delay_ms(225);
	CALL SUBOPT_0x27
;     501                 lcd_clear();
	CALL _lcd_clear
;     502                 kursorPID = 1;
	LDI  R30,LOW(1)
	STS  _kursorPID,R30
;     503                 goto setPID;
	RJMP _0x78
;     504         }
;     505         if (!sw_down)
_0x77:
	SBIC 0x13,3
	RJMP _0x79
;     506         {
;     507                 delay_ms(225);
	CALL SUBOPT_0x27
;     508                 goto menu02;
	RJMP _0x7A
;     509         }
;     510         if (!sw_up)
_0x79:
	SBIC 0x13,2
	RJMP _0x7B
;     511         {
;     512                 delay_ms(225);
	CALL SUBOPT_0x27
;     513                 lcd_clear();
	CALL _lcd_clear
;     514                 goto menu06;
	RJMP _0x7C
;     515         }
;     516 
;     517         goto menu01;
_0x7B:
	RJMP _0x76
;     518     menu02:
_0x7A:
;     519         delay_ms(225);
	CALL SUBOPT_0x27
;     520         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     521                  // 0123456789abcdef
;     522         lcd_putsf("  Set PID       ");
	__POINTW1FN _0,277
	CALL SUBOPT_0x1
;     523         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     524         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0,294
	CALL SUBOPT_0x1
;     525 
;     526         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     527         lcd_putchar(0);
	CALL SUBOPT_0x28
;     528 
;     529         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x7D
;     530         {
;     531                 delay_ms(225);
	CALL SUBOPT_0x27
;     532                 lcd_clear();
	CALL _lcd_clear
;     533                 kursorSpeed = 1;
	LDI  R30,LOW(1)
	STS  _kursorSpeed,R30
;     534                 goto setSpeed;
	RJMP _0x7E
;     535         }
;     536         if (!sw_up)
_0x7D:
	SBIC 0x13,2
	RJMP _0x7F
;     537         {
;     538                 delay_ms(225);
	CALL SUBOPT_0x27
;     539                 goto menu01;
	RJMP _0x76
;     540         }
;     541         if (!sw_down)
_0x7F:
	SBIC 0x13,3
	RJMP _0x80
;     542         {
;     543                 delay_ms(225);
	CALL SUBOPT_0x27
;     544                 lcd_clear();
	CALL _lcd_clear
;     545                 goto menu03;
	RJMP _0x81
;     546         }
;     547         goto menu02;
_0x80:
	RJMP _0x7A
;     548     menu03:
_0x81:
;     549         delay_ms(225);
	CALL SUBOPT_0x27
;     550         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     551                 // 0123456789abcdef
;     552         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0,311
	CALL SUBOPT_0x1
;     553         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     554         lcd_putsf("  Skenario      ");
	__POINTW1FN _0,328
	CALL SUBOPT_0x1
;     555 
;     556         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     557         lcd_putchar(0);
	CALL SUBOPT_0x28
;     558 
;     559         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x82
;     560         {
;     561                 delay_ms(225);
	CALL SUBOPT_0x27
;     562                 lcd_clear();
	CALL _lcd_clear
;     563                 kursorGaris = 1;
	LDI  R30,LOW(1)
	STS  _kursorGaris,R30
;     564                 goto setGaris;
	RJMP _0x83
;     565         }
;     566         if (!sw_up)
_0x82:
	SBIC 0x13,2
	RJMP _0x84
;     567         {
;     568                 delay_ms(225);
	CALL SUBOPT_0x27
;     569                 lcd_clear();
	CALL _lcd_clear
;     570                 goto menu02;
	RJMP _0x7A
;     571         }
;     572         if (!sw_down)
_0x84:
	SBIC 0x13,3
	RJMP _0x85
;     573         {
;     574                 delay_ms(225);
	CALL SUBOPT_0x27
;     575                 goto menu04;
	RJMP _0x86
;     576         }
;     577         goto menu03;
_0x85:
	RJMP _0x81
;     578     menu04:
_0x86:
;     579         delay_ms(225);
	CALL SUBOPT_0x27
;     580         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     581                 // 0123456789abcdef
;     582         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0,311
	CALL SUBOPT_0x1
;     583         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     584         lcd_putsf("  Skenario      ");
	__POINTW1FN _0,328
	CALL SUBOPT_0x1
;     585 
;     586         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     587         lcd_putchar(0);
	CALL SUBOPT_0x28
;     588 
;     589         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x87
;     590         {
;     591                 delay_ms(225);
	CALL SUBOPT_0x27
;     592                 lcd_clear();
	CALL _lcd_clear
;     593                 goto setSkenario;
	RJMP _0x88
;     594         }
;     595         if (!sw_up)
_0x87:
	SBIC 0x13,2
	RJMP _0x89
;     596         {
;     597                 delay_ms(225);
	CALL SUBOPT_0x27
;     598                 goto menu03;
	RJMP _0x81
;     599         }
;     600         if (!sw_down)
_0x89:
	SBIC 0x13,3
	RJMP _0x8A
;     601         {
;     602                 delay_ms(225);
	CALL SUBOPT_0x27
;     603                 lcd_clear();
	CALL _lcd_clear
;     604                 goto menu05;
	RJMP _0x8B
;     605         }
;     606         goto menu04;
_0x8A:
	RJMP _0x86
;     607     menu05:            // Bikin sendiri lhoo ^^d
_0x8B:
;     608         delay_ms(225);
	CALL SUBOPT_0x27
;     609         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     610         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0,345
	CALL SUBOPT_0x1
;     611         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     612         lcd_putsf("  Start!!      ");
	__POINTW1FN _0,365
	CALL SUBOPT_0x1
;     613 
;     614         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     615         lcd_putchar(0);
	CALL SUBOPT_0x28
;     616 
;     617         if  (!sw_ok)
	SBIC 0x13,0
	RJMP _0x8C
;     618         {
;     619             delay_ms(225);
	CALL SUBOPT_0x27
;     620             lcd_clear();
	CALL _lcd_clear
;     621             goto mode;
	RJMP _0x8D
;     622         }
;     623 
;     624         if  (!sw_up)
_0x8C:
	SBIC 0x13,2
	RJMP _0x8E
;     625         {
;     626             delay_ms(225);
	CALL SUBOPT_0x27
;     627             lcd_clear();
	CALL _lcd_clear
;     628             goto menu04;
	RJMP _0x86
;     629         }
;     630 
;     631         if  (!sw_down)
_0x8E:
	SBIC 0x13,3
	RJMP _0x8F
;     632         {
;     633             delay_ms(225);
	CALL SUBOPT_0x27
;     634             goto menu06;
	RJMP _0x7C
;     635         }
;     636 
;     637         goto menu05;
_0x8F:
	RJMP _0x8B
;     638     menu06:
_0x7C:
;     639         delay_ms(225);
	CALL SUBOPT_0x27
;     640         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     641         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0,345
	CALL SUBOPT_0x1
;     642         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     643         lcd_putsf("  Start!!      ");
	__POINTW1FN _0,365
	CALL SUBOPT_0x1
;     644 
;     645         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     646         lcd_putchar(0);
	CALL SUBOPT_0x28
;     647 
;     648         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x90
;     649         {
;     650                 delay_ms(225);
	CALL SUBOPT_0x27
;     651                 lcd_clear();
	CALL _lcd_clear
;     652                 goto startRobot;
	RJMP _0x91
;     653         }
;     654 
;     655         if (!sw_up)
_0x90:
	SBIC 0x13,2
	RJMP _0x92
;     656         {
;     657                 delay_ms(225);
	CALL SUBOPT_0x27
;     658                 goto menu05;
	RJMP _0x8B
;     659         }
;     660 
;     661         if (!sw_down)
_0x92:
	SBIC 0x13,3
	RJMP _0x93
;     662         {
;     663                 delay_ms(225);
	CALL SUBOPT_0x27
;     664                 lcd_clear();
	CALL _lcd_clear
;     665                 goto menu01;
	RJMP _0x76
;     666         }
;     667 
;     668         goto menu06;
_0x93:
	RJMP _0x7C
;     669 
;     670 
;     671     setPID:
_0x78:
;     672         delay_ms(225);
	CALL SUBOPT_0x27
;     673         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     674                 // 0123456789ABCDEF
;     675         lcd_putsf("  Kp   Ki   Kd  ");
	__POINTW1FN _0,381
	CALL SUBOPT_0x1
;     676         // lcd_putsf(" 250  200  300  ");
;     677         lcd_putchar(' ');
	CALL SUBOPT_0x29
;     678         tampil(Kp); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x29
;     679         tampil(Ki); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x29
;     680         tampil(Kd); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x8
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x29
;     681 
;     682         switch (kursorPID)
	LDS  R30,_kursorPID
;     683         {
;     684           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x97
;     685                 lcd_gotoxy(1,0); // kursor Kp
	LDI  R30,LOW(1)
	RJMP _0x1ED
;     686                 lcd_putchar(0);
;     687                 break;
;     688           case 2:
_0x97:
	CPI  R30,LOW(0x2)
	BRNE _0x98
;     689                 lcd_gotoxy(6,0); // kursor Ki
	LDI  R30,LOW(6)
	RJMP _0x1ED
;     690                 lcd_putchar(0);
;     691                 break;
;     692           case 3:
_0x98:
	CPI  R30,LOW(0x3)
	BRNE _0x96
;     693                 lcd_gotoxy(11,0); // kursor Kd
	LDI  R30,LOW(11)
_0x1ED:
	ST   -Y,R30
	CALL SUBOPT_0x2B
;     694                 lcd_putchar(0);
;     695                 break;
;     696         }
_0x96:
;     697 
;     698         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x9A
;     699         {
;     700                 delay_ms(225);
	CALL SUBOPT_0x27
;     701                 setByte( 1, kursorPID);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDS  R30,_kursorPID
	CALL SUBOPT_0x2C
;     702                 delay_ms(200);
;     703         }
;     704         if (!sw_up)
_0x9A:
	SBIC 0x13,2
	RJMP _0x9B
;     705         {
;     706                 delay_ms(225);
	CALL SUBOPT_0x27
;     707                 if (kursorPID == 3) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x3)
	BRNE _0x9C
;     708                         kursorPID = 1;
	LDI  R30,LOW(1)
	RJMP _0x1EE
;     709                 } else kursorPID++;
_0x9C:
	LDS  R30,_kursorPID
	SUBI R30,-LOW(1)
_0x1EE:
	STS  _kursorPID,R30
;     710         }
;     711         if (!sw_down)
_0x9B:
	SBIC 0x13,3
	RJMP _0x9E
;     712         {
;     713                 delay_ms(225);
	CALL SUBOPT_0x27
;     714                 if (kursorPID == 1) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x1)
	BRNE _0x9F
;     715                         kursorPID = 3;
	LDI  R30,LOW(3)
	RJMP _0x1EF
;     716                 } else kursorPID--;
_0x9F:
	LDS  R30,_kursorPID
	SUBI R30,LOW(1)
_0x1EF:
	STS  _kursorPID,R30
;     717         }
;     718 
;     719         if (!sw_cancel)
_0x9E:
	SBIC 0x13,1
	RJMP _0xA1
;     720         {
;     721                 delay_ms(225);
	CALL SUBOPT_0x27
;     722                 lcd_clear();
	CALL _lcd_clear
;     723                 goto menu01;
	RJMP _0x76
;     724         }
;     725 
;     726         goto setPID;
_0xA1:
	RJMP _0x78
;     727 
;     728     setSpeed:
_0x7E:
;     729         delay_ms(225);
	CALL SUBOPT_0x27
;     730         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     731                 // 0123456789ABCDEF
;     732         lcd_putsf("   MAX    MIN   ");
	__POINTW1FN _0,398
	CALL SUBOPT_0x1
;     733         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
;     734 
;     735         //lcd_putsf("   250    200   ");
;     736         tampil(MAXSpeed);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x2A
;     737         lcd_putchar(' '); lcd_putchar(' ');lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
;     738         tampil(MINSpeed);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2A
;     739         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
;     740 
;     741         switch (kursorSpeed)
	LDS  R30,_kursorSpeed
;     742         {
;     743           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0xA5
;     744                 lcd_gotoxy(2,0); // kursor MAX
	LDI  R30,LOW(2)
	RJMP _0x1F0
;     745                 lcd_putchar(0);
;     746                 break;
;     747           case 2:
_0xA5:
	CPI  R30,LOW(0x2)
	BRNE _0xA4
;     748                 lcd_gotoxy(9,0); // kursor MIN
	LDI  R30,LOW(9)
_0x1F0:
	ST   -Y,R30
	CALL SUBOPT_0x2B
;     749                 lcd_putchar(0);
;     750                 break;
;     751         }
_0xA4:
;     752 
;     753         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xA7
;     754         {
;     755                 delay_ms(225);
	CALL SUBOPT_0x27
;     756                 setByte( 2, kursorSpeed);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R30,_kursorSpeed
	CALL SUBOPT_0x2C
;     757                 delay_ms(200);
;     758         }
;     759         if (!sw_up)
_0xA7:
	SBIC 0x13,2
	RJMP _0xA8
;     760         {
;     761                 delay_ms(225);
	CALL SUBOPT_0x27
;     762                 if (kursorSpeed == 2)
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x2)
	BRNE _0xA9
;     763                 {
;     764                         kursorSpeed = 1;
	LDI  R30,LOW(1)
	RJMP _0x1F1
;     765                 } else kursorSpeed++;
_0xA9:
	LDS  R30,_kursorSpeed
	SUBI R30,-LOW(1)
_0x1F1:
	STS  _kursorSpeed,R30
;     766         }
;     767         if (!sw_down)
_0xA8:
	SBIC 0x13,3
	RJMP _0xAB
;     768         {
;     769                 delay_ms(225);
	CALL SUBOPT_0x27
;     770                 if (kursorSpeed == 1)
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x1)
	BRNE _0xAC
;     771                 {
;     772                         kursorSpeed = 2;
	LDI  R30,LOW(2)
	RJMP _0x1F2
;     773                 } else kursorSpeed--;
_0xAC:
	LDS  R30,_kursorSpeed
	SUBI R30,LOW(1)
_0x1F2:
	STS  _kursorSpeed,R30
;     774         }
;     775 
;     776         if (!sw_cancel)
_0xAB:
	SBIC 0x13,1
	RJMP _0xAE
;     777         {
;     778                 delay_ms(225);
	CALL SUBOPT_0x27
;     779                 lcd_clear();
	CALL _lcd_clear
;     780                 goto menu02;
	RJMP _0x7A
;     781         }
;     782 
;     783         goto setSpeed;
_0xAE:
	RJMP _0x7E
;     784 
;     785      setGaris: // not yet
_0x83:
;     786         delay_ms(225);
	CALL SUBOPT_0x27
;     787         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     788                 // 0123456789ABCDEF
;     789         if ( WarnaGaris == 1 )
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0xAF
;     790                 lcd_putsf("  WARNA : Putih ");
	__POINTW1FN _0,415
	RJMP _0x1F3
;     791         else
_0xAF:
;     792                 lcd_putsf("  WARNA : Hitam ");
	__POINTW1FN _0,432
_0x1F3:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
;     793 
;     794         //lcd_putsf("  LEBAR: 1.5 cm ");
;     795         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     796         lcd_putsf("  SensL :        ");
	__POINTW1FN _0,449
	CALL SUBOPT_0x1
;     797         lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x2D
;     798         tampil( SensLine );
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _tampil
;     799 
;     800         switch (kursorGaris)
	LDS  R30,_kursorGaris
;     801         {
;     802           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0xB4
;     803                 lcd_gotoxy(0,0); // kursor Warna
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x1F4
;     804                 lcd_putchar(0);
;     805                 break;
;     806           case 2:
_0xB4:
	CPI  R30,LOW(0x2)
	BRNE _0xB3
;     807                 lcd_gotoxy(0,1); // kursor SensL
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x1F4:
	ST   -Y,R30
	CALL _lcd_gotoxy
;     808                 lcd_putchar(0);
	CALL SUBOPT_0x28
;     809                 break;
;     810         }
_0xB3:
;     811 
;     812         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xB6
;     813         {
;     814                 delay_ms(225);
	CALL SUBOPT_0x27
;     815                 setByte( 3, kursorGaris);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDS  R30,_kursorGaris
	CALL SUBOPT_0x2C
;     816                 delay_ms(200);
;     817         }
;     818         if (!sw_up)
_0xB6:
	SBIC 0x13,2
	RJMP _0xB7
;     819         {
;     820                 delay_ms(225);
	CALL SUBOPT_0x27
;     821                 if (kursorGaris == 2)
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x2)
	BRNE _0xB8
;     822                 {
;     823                         kursorGaris = 1;
	LDI  R30,LOW(1)
	RJMP _0x1F5
;     824                 } else kursorGaris++;
_0xB8:
	LDS  R30,_kursorGaris
	SUBI R30,-LOW(1)
_0x1F5:
	STS  _kursorGaris,R30
;     825         }
;     826         if (!sw_down)
_0xB7:
	SBIC 0x13,3
	RJMP _0xBA
;     827         {
;     828                 delay_ms(225);
	CALL SUBOPT_0x27
;     829                 if (kursorGaris == 1)
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x1)
	BRNE _0xBB
;     830                 {
;     831                         kursorGaris = 2;
	LDI  R30,LOW(2)
	RJMP _0x1F6
;     832                 } else kursorGaris--;
_0xBB:
	LDS  R30,_kursorGaris
	SUBI R30,LOW(1)
_0x1F6:
	STS  _kursorGaris,R30
;     833         }
;     834 
;     835         if (!sw_cancel)
_0xBA:
	SBIC 0x13,1
	RJMP _0xBD
;     836         {
;     837                 delay_ms(225);
	CALL SUBOPT_0x27
;     838                 lcd_clear();
	CALL _lcd_clear
;     839                 goto menu03;
	RJMP _0x81
;     840         }
;     841 
;     842         goto setGaris;
_0xBD:
	RJMP _0x83
;     843 
;     844      setSkenario:
_0x88:
;     845         delay_ms(225);
	CALL SUBOPT_0x27
;     846         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     847                 // 0123456789ABCDEF
;     848         lcd_putsf("Sken. yg  dpake:");
	__POINTW1FN _0,467
	CALL SUBOPT_0x1
;     849         lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
;     850         tampil( Skenario );
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _tampil
;     851 
;     852         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xBE
;     853         {
;     854                 delay_ms(225);
	CALL SUBOPT_0x27
;     855                 setByte( 4, 0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2C
;     856                 delay_ms(200);
;     857         }
;     858 
;     859         if (!sw_cancel)
_0xBE:
	SBIC 0x13,1
	RJMP _0xBF
;     860         {
;     861                 delay_ms(225);
	CALL SUBOPT_0x27
;     862                 lcd_clear();
	CALL _lcd_clear
;     863                 goto menu04;
	RJMP _0x86
;     864         }
;     865 
;     866         goto setSkenario;
_0xBF:
	RJMP _0x88
;     867 
;     868      mode:
_0x8D:
;     869         delay_ms(125);
	CALL SUBOPT_0xF
;     870         if  (!sw_up)
	SBIC 0x13,2
	RJMP _0xC0
;     871         {
;     872             delay_ms(225);
	CALL SUBOPT_0x27
;     873             if (Mode==6)
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x6)
	BRNE _0xC1
;     874             {
;     875                 Mode=1;
	LDI  R30,LOW(1)
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMWRB
;     876             }
;     877 
;     878             else Mode++;
	RJMP _0xC2
_0xC1:
	CALL SUBOPT_0x2E
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
;     879 
;     880             goto nomorMode;
_0xC2:
	RJMP _0xC3
;     881         }
;     882 
;     883         if  (!sw_down)
_0xC0:
	SBIC 0x13,3
	RJMP _0xC4
;     884         {
;     885             delay_ms(225);
	CALL SUBOPT_0x27
;     886             if  (Mode==1)
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x1)
	BRNE _0xC5
;     887             {
;     888                 Mode=6;
	LDI  R30,LOW(6)
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMWRB
;     889             }
;     890 
;     891             else Mode--;
	RJMP _0xC6
_0xC5:
	CALL SUBOPT_0x2E
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
;     892 
;     893             goto nomorMode;
_0xC6:
;     894         }
;     895 
;     896         nomorMode:
_0xC4:
_0xC3:
;     897             if (Mode==1)
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x1)
	BRNE _0xC7
;     898             {
;     899                 lcd_clear();
	CALL SUBOPT_0x26
;     900                 lcd_gotoxy(0,0);
;     901                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     902                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     903                 lcd_putsf(" 1.Lihat ADC");
	__POINTW1FN _0,501
	CALL SUBOPT_0x1
;     904             }
;     905 
;     906             if  (Mode==2)
_0xC7:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x2)
	BRNE _0xC8
;     907             {
;     908                 lcd_clear();
	CALL SUBOPT_0x26
;     909                 lcd_gotoxy(0,0);
;     910                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     911                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     912                 lcd_putsf(" 2.Test Mode");
	__POINTW1FN _0,514
	CALL SUBOPT_0x1
;     913             }
;     914 
;     915             if  (Mode==3)
_0xC8:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x3)
	BRNE _0xC9
;     916             {
;     917                 lcd_clear();
	CALL SUBOPT_0x26
;     918                 lcd_gotoxy(0,0);
;     919                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     920                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     921                 lcd_putsf(" 3.Cek Sensor ");
	__POINTW1FN _0,527
	CALL SUBOPT_0x1
;     922             }
;     923 
;     924             if  (Mode==4)
_0xC9:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x4)
	BRNE _0xCA
;     925             {
;     926                 lcd_clear();
	CALL SUBOPT_0x26
;     927                 lcd_gotoxy(0,0);
;     928                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     929                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     930                 lcd_putsf(" 4.Auto Tune 1-1");
	__POINTW1FN _0,542
	CALL SUBOPT_0x1
;     931             }
;     932 
;     933              if  (Mode==5)
_0xCA:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x5)
	BRNE _0xCB
;     934             {
;     935                 lcd_clear();
	CALL SUBOPT_0x26
;     936                 lcd_gotoxy(0,0);
;     937                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     938                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     939                 lcd_putsf(" 5.Auto Tune ");
	__POINTW1FN _0,559
	CALL SUBOPT_0x1
;     940             }
;     941 
;     942             if  (Mode==6)
_0xCB:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x6)
	BRNE _0xCC
;     943             {
;     944                 lcd_clear();
	CALL SUBOPT_0x26
;     945                 lcd_gotoxy(0,0);
;     946                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     947                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     948                 lcd_putsf(" 6.Cek PWM Aktif");
	__POINTW1FN _0,573
	CALL SUBOPT_0x1
;     949             }
;     950 
;     951         if  (!sw_ok)
_0xCC:
	SBIC 0x13,0
	RJMP _0xCD
;     952         {
;     953             delay_ms(225);
	CALL SUBOPT_0x27
;     954             switch  (Mode)
	CALL SUBOPT_0x2E
;     955             {
;     956                 case 1:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0xD1
;     957                 {
;     958                     for(;;)
_0xD3:
;     959                     {
;     960                         lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x30
;     961                         sprintf(lcd,"  %d %d %d %d",read_adc(3),read_adc(2),read_adc(1),read_adc(0));
	CALL SUBOPT_0x31
	__POINTW1FN _0,590
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x17
	CALL SUBOPT_0x32
	CALL SUBOPT_0x16
	CALL SUBOPT_0x32
	CALL SUBOPT_0x15
	CALL SUBOPT_0x32
	CALL SUBOPT_0x14
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
;     962                         lcd_puts(lcd);
	CALL _lcd_puts
;     963                         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;     964                         sprintf(lcd,"%d %d %d %d",read_adc(7),read_adc(6),read_adc(5),read_adc(4));
	CALL SUBOPT_0x31
	__POINTW1FN _0,592
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1B
	CALL SUBOPT_0x32
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x32
	CALL SUBOPT_0x19
	CALL SUBOPT_0x32
	CALL SUBOPT_0x18
	CALL SUBOPT_0x32
	CALL SUBOPT_0x33
;     965                         lcd_puts(lcd);
	CALL _lcd_puts
;     966                         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
;     967                         lcd_clear();
	CALL _lcd_clear
;     968                     }
	RJMP _0xD3
;     969                 }
;     970                 break;
;     971 
;     972                 case 2:
_0xD1:
	CPI  R30,LOW(0x2)
	BRNE _0xD5
;     973                 {
;     974                     cek_sensor();
	RCALL _cek_sensor
;     975                 }
;     976                 break;
	RJMP _0xD0
;     977 
;     978                 case 3:
_0xD5:
	CPI  R30,LOW(0x3)
	BRNE _0xD6
;     979                 {
;     980                     cek_sensor();
	RCALL _cek_sensor
;     981                 }
;     982                 break;
	RJMP _0xD0
;     983 
;     984                 case 4:
_0xD6:
	CPI  R30,LOW(0x4)
	BRNE _0xD7
;     985                 {
;     986                     tune_batas();
	RCALL _tune_batas
;     987 
;     988                 }
;     989                 break;
	RJMP _0xD0
;     990 
;     991                 case 5:
_0xD7:
	CPI  R30,LOW(0x5)
	BRNE _0xD8
;     992                 {
;     993                     auto_scan();
	RCALL _auto_scan
;     994                     goto menu01;
	RJMP _0x76
;     995                 }
;     996                 break;
;     997 
;     998                 case 6:
_0xD8:
	CPI  R30,LOW(0x6)
	BRNE _0xD0
;     999                 {
;    1000                     pemercepat();
	CALL _pemercepat
;    1001                     pelambat();
	CALL _pelambat
;    1002                     goto menu01;
	RJMP _0x76
;    1003                 }
;    1004                 break;
;    1005             }
_0xD0:
;    1006         }
;    1007 
;    1008         if  (!sw_cancel)
_0xCD:
	SBIC 0x13,1
	RJMP _0xDA
;    1009         {
;    1010             lcd_clear();
	CALL _lcd_clear
;    1011             goto menu05;
	RJMP _0x8B
;    1012         }
;    1013 
;    1014         goto mode;
_0xDA:
	RJMP _0x8D
;    1015 
;    1016      startRobot:
_0x91:
;    1017         //TIMSK = 0x01;
;    1018         //#asm("sei")
;    1019         lcd_clear();
	CALL _lcd_clear
;    1020 }
	RET
;    1021 
;    1022 void displaySensorBit()
;    1023 {
_displaySensorBit:
;    1024     baca_sensor();
	CALL _baca_sensor
;    1025     lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2D
;    1026     if (s7) lcd_putchar('1');
	SBRS R2,7
	RJMP _0xDB
	LDI  R30,LOW(49)
	RJMP _0x1F7
;    1027     else    lcd_putchar('0');
_0xDB:
	LDI  R30,LOW(48)
_0x1F7:
	ST   -Y,R30
	CALL _lcd_putchar
;    1028     if (s6) lcd_putchar('1');
	SBRS R2,6
	RJMP _0xDD
	LDI  R30,LOW(49)
	RJMP _0x1F8
;    1029     else    lcd_putchar('0');
_0xDD:
	LDI  R30,LOW(48)
_0x1F8:
	ST   -Y,R30
	CALL _lcd_putchar
;    1030     if (s5) lcd_putchar('1');
	SBRS R2,5
	RJMP _0xDF
	LDI  R30,LOW(49)
	RJMP _0x1F9
;    1031     else    lcd_putchar('0');
_0xDF:
	LDI  R30,LOW(48)
_0x1F9:
	ST   -Y,R30
	CALL _lcd_putchar
;    1032     if (s4) lcd_putchar('1');
	SBRS R2,4
	RJMP _0xE1
	LDI  R30,LOW(49)
	RJMP _0x1FA
;    1033     else    lcd_putchar('0');
_0xE1:
	LDI  R30,LOW(48)
_0x1FA:
	ST   -Y,R30
	CALL _lcd_putchar
;    1034     if (s3) lcd_putchar('1');
	SBRS R2,3
	RJMP _0xE3
	LDI  R30,LOW(49)
	RJMP _0x1FB
;    1035     else    lcd_putchar('0');
_0xE3:
	LDI  R30,LOW(48)
_0x1FB:
	ST   -Y,R30
	CALL _lcd_putchar
;    1036     if (s2) lcd_putchar('1');
	SBRS R2,2
	RJMP _0xE5
	LDI  R30,LOW(49)
	RJMP _0x1FC
;    1037     else    lcd_putchar('0');
_0xE5:
	LDI  R30,LOW(48)
_0x1FC:
	ST   -Y,R30
	CALL _lcd_putchar
;    1038     if (s1) lcd_putchar('1');
	SBRS R2,1
	RJMP _0xE7
	LDI  R30,LOW(49)
	RJMP _0x1FD
;    1039     else    lcd_putchar('0');
_0xE7:
	LDI  R30,LOW(48)
_0x1FD:
	ST   -Y,R30
	CALL _lcd_putchar
;    1040     if (s0) lcd_putchar('1');
	SBRS R2,0
	RJMP _0xE9
	LDI  R30,LOW(49)
	RJMP _0x1FE
;    1041     else    lcd_putchar('0');
_0xE9:
	LDI  R30,LOW(48)
_0x1FE:
	ST   -Y,R30
	CALL _lcd_putchar
;    1042 }
	RET
;    1043 
;    1044 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1045 {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    1046         xcount++;
	LDS  R30,_xcount
	SUBI R30,-LOW(1)
	STS  _xcount,R30
;    1047         if(xcount<=lpwm)Enki=1; // PORTC.1 = 1;
	CALL SUBOPT_0x10
	CALL SUBOPT_0x34
	BRLT _0xEB
	SBI  0x12,7
;    1048         else Enki=0;  // PORTC.1 = 0;
	RJMP _0xEC
_0xEB:
	CBI  0x12,7
;    1049         if(xcount<=rpwm)Enka=1;
_0xEC:
	LDS  R30,_rpwm
	LDS  R31,_rpwm+1
	CALL SUBOPT_0x34
	BRLT _0xED
	SBI  0x12,6
;    1050         else Enka=0;
	RJMP _0xEE
_0xED:
	CBI  0x12,6
;    1051         TCNT0=0xFF;
_0xEE:
	LDI  R30,LOW(255)
	OUT  0x32,R30
;    1052 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;    1053 
;    1054 void maju(){kaplus=1;kamin=0;kirplus=1;kirmin=0;}
_maju:
	SBI  0x12,3
	CBI  0x12,2
	SBI  0x12,5
	CBI  0x12,4
	RET
;    1055 
;    1056 void mundur(){kaplus=0;kamin=1;kirplus=0;kirmin=1;}
_mundur:
	CBI  0x12,3
	SBI  0x12,2
	CBI  0x12,5
	SBI  0x12,4
	RET
;    1057 
;    1058 void bkan(){kaplus=0;kamin=0;kirplus=1;kirmin=0;}
;    1059 
;    1060 void bkir(){kaplus=1;kamin=0;kirplus=0;kirmin=0;}
;    1061 
;    1062 void rotkan(){kaplus=0;kamin=1;kirplus=1;kirmin=0;}
_rotkan:
	CBI  0x12,3
	SBI  0x12,2
	SBI  0x12,5
	CBI  0x12,4
	RET
;    1063 
;    1064 void rotkir(){kaplus=1;kamin=0;kirplus=0;kirmin=1;}
_rotkir:
	SBI  0x12,3
	CBI  0x12,2
	CBI  0x12,5
	SBI  0x12,4
	RET
;    1065 
;    1066 void stop(){ kaplus=0;kamin=0;kirplus=0;kirmin=0; }
_stop:
	CBI  0x12,3
	CBI  0x12,2
	CBI  0x12,5
	CBI  0x12,4
	RET
;    1067 
;    1068 void cek_sensor()
;    1069 {
_cek_sensor:
;    1070         int t;
;    1071 
;    1072         baca_sensor();
	ST   -Y,R17
	ST   -Y,R16
;	t -> R16,R17
	CALL _baca_sensor
;    1073         lcd_clear();
	CALL _lcd_clear
;    1074         delay_ms(125);
	CALL SUBOPT_0x0
;    1075                 // wait 125ms
;    1076         lcd_gotoxy(0,0);
;    1077                 //0123456789abcdef
;    1078         lcd_putsf(" Test:Sensor    ");
	__POINTW1FN _0,604
	CALL SUBOPT_0x1
;    1079 
;    1080         for (t=0; t<30000; t++) {displaySensorBit();}
	__GETWRN 16,17,0
_0xF0:
	__CPWRN 16,17,30000
	BRGE _0xF1
	CALL _displaySensorBit
	__ADDWRN 16,17,1
	RJMP _0xF0
_0xF1:
;    1081 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1082 
;    1083 void tune_batas()
;    1084 {
_tune_batas:
;    1085     lcd_clear();
	CALL SUBOPT_0x26
;    1086     lcd_gotoxy(0,0);
;    1087     lcd_putsf(" Cek Memory ?");
	__POINTW1FN _0,621
	CALL SUBOPT_0x1
;    1088     lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;    1089     lcd_putsf(" Y / N ");
	__POINTW1FN _0,635
	CALL SUBOPT_0x1
;    1090     for(;;)
_0xF3:
;    1091     {
;    1092         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0xF5
;    1093         {
;    1094                 delay_ms(200);
	CALL SUBOPT_0x5
;    1095                 lcd_clear();
	CALL SUBOPT_0x26
;    1096                 lcd_gotoxy(0,0);
;    1097                 sprintf(lcd," %d %d %d %d %d %d %d %d",bt0, bt1, bt2, bt3, bt4, bt5, bt6, bt7);
	CALL SUBOPT_0x31
	__POINTW1FN _0,643
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x35
	CALL SUBOPT_0x36
	CALL SUBOPT_0x37
	CALL SUBOPT_0x38
	CALL SUBOPT_0x39
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x3D
;    1098                 lcd_puts(lcd);
	CALL _lcd_puts
;    1099                 delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x4
;    1100         }
;    1101 
;    1102         if(!sw_cancel)
_0xF5:
	SBIS 0x13,1
;    1103         {
;    1104                 break;
	RJMP _0xF4
;    1105         }
;    1106     }
	RJMP _0xF3
_0xF4:
;    1107     for(;;)
_0xF8:
;    1108     {
;    1109         read_adc(0);
	CALL SUBOPT_0x14
;    1110         if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_bb0
	CP   R26,R30
	BRSH _0xFA
	CALL SUBOPT_0x14
	STS  _bb0,R30
;    1111         if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
_0xFA:
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_ba0
	CP   R30,R26
	BRSH _0xFB
	CALL SUBOPT_0x14
	STS  _ba0,R30
;    1112 
;    1113         bt0=((bb0+ba0)/2);
_0xFB:
	CALL SUBOPT_0x3E
;    1114 
;    1115         lcd_clear();
	CALL SUBOPT_0x3F
;    1116         lcd_gotoxy(1,0);
;    1117         lcd_putsf(" bb0  ba0  bt0");
	__POINTW1FN _0,668
	CALL SUBOPT_0x1
;    1118         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1119         sprintf(lcd," %d  %d  %d",bb0,ba0,bt0);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb0
	CALL SUBOPT_0x32
	LDS  R30,_ba0
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
	CALL SUBOPT_0x41
;    1120         lcd_puts(lcd);
	CALL SUBOPT_0x42
;    1121         delay_ms(50);
;    1122 
;    1123         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0xFC
;    1124         {
;    1125             delay_ms(125);
	CALL SUBOPT_0xF
;    1126             goto sensor1;
	RJMP _0xFD
;    1127         }
;    1128     }
_0xFC:
	RJMP _0xF8
;    1129     sensor1:
_0xFD:
;    1130     for(;;)
_0xFF:
;    1131     {
;    1132         read_adc(1);
	CALL SUBOPT_0x15
;    1133         if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_bb1
	CP   R26,R30
	BRSH _0x101
	CALL SUBOPT_0x15
	STS  _bb1,R30
;    1134         if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
_0x101:
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_ba1
	CP   R30,R26
	BRSH _0x102
	CALL SUBOPT_0x15
	STS  _ba1,R30
;    1135 
;    1136         bt1=((bb1+ba1)/2);
_0x102:
	CALL SUBOPT_0x43
;    1137 
;    1138         lcd_clear();
	CALL SUBOPT_0x3F
;    1139         lcd_gotoxy(1,0);
;    1140         lcd_putsf(" bb1  ba1  bt1");
	__POINTW1FN _0,695
	CALL SUBOPT_0x1
;    1141         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1142         sprintf(lcd," %d  %d  %d",bb1,ba1,bt1);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb1
	CALL SUBOPT_0x32
	LDS  R30,_ba1
	CALL SUBOPT_0x32
	CALL SUBOPT_0x36
	CALL SUBOPT_0x41
;    1143         lcd_puts(lcd);
	CALL SUBOPT_0x42
;    1144         delay_ms(50);
;    1145 
;    1146         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x103
;    1147         {
;    1148             delay_ms(150);
	CALL SUBOPT_0x44
;    1149             goto sensor2;
	RJMP _0x104
;    1150         }
;    1151     }
_0x103:
	RJMP _0xFF
;    1152     sensor2:
_0x104:
;    1153     for(;;)
_0x106:
;    1154     {
;    1155         read_adc(2);
	CALL SUBOPT_0x16
;    1156         if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_bb2
	CP   R26,R30
	BRSH _0x108
	CALL SUBOPT_0x16
	STS  _bb2,R30
;    1157         if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
_0x108:
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_ba2
	CP   R30,R26
	BRSH _0x109
	CALL SUBOPT_0x16
	STS  _ba2,R30
;    1158 
;    1159         bt2=((bb2+ba2)/2);
_0x109:
	CALL SUBOPT_0x45
;    1160 
;    1161         lcd_clear();
	CALL SUBOPT_0x3F
;    1162         lcd_gotoxy(1,0);
;    1163         lcd_putsf(" bb2  ba2  bt2");
	__POINTW1FN _0,710
	CALL SUBOPT_0x1
;    1164         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1165         sprintf(lcd," %d  %d  %d",bb2,ba2,bt2);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb2
	CALL SUBOPT_0x32
	LDS  R30,_ba2
	CALL SUBOPT_0x32
	CALL SUBOPT_0x37
	CALL SUBOPT_0x41
;    1166         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1167         delay_ms(10);
;    1168 
;    1169         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x10A
;    1170         {
;    1171             delay_ms(150);
	CALL SUBOPT_0x44
;    1172             goto sensor3;
	RJMP _0x10B
;    1173         }
;    1174     }
_0x10A:
	RJMP _0x106
;    1175     sensor3:
_0x10B:
;    1176     for(;;)
_0x10D:
;    1177     {
;    1178         read_adc(3);
	CALL SUBOPT_0x17
;    1179         if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_bb3
	CP   R26,R30
	BRSH _0x10F
	CALL SUBOPT_0x17
	STS  _bb3,R30
;    1180         if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
_0x10F:
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_ba3
	CP   R30,R26
	BRSH _0x110
	CALL SUBOPT_0x17
	STS  _ba3,R30
;    1181 
;    1182         bt3=((bb3+ba3)/2);
_0x110:
	CALL SUBOPT_0x47
;    1183 
;    1184         lcd_clear();
	CALL SUBOPT_0x3F
;    1185         lcd_gotoxy(1,0);
;    1186         lcd_putsf(" bb3  ba3  bt3");
	__POINTW1FN _0,725
	CALL SUBOPT_0x1
;    1187         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1188         sprintf(lcd," %d  %d  %d",bb3,ba3,bt3);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb3
	CALL SUBOPT_0x32
	LDS  R30,_ba3
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
	CALL SUBOPT_0x41
;    1189         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1190         delay_ms(10);
;    1191 
;    1192         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x111
;    1193         {
;    1194             delay_ms(150);
	CALL SUBOPT_0x44
;    1195             goto sensor4;
	RJMP _0x112
;    1196         }
;    1197     }
_0x111:
	RJMP _0x10D
;    1198     sensor4:
_0x112:
;    1199     for(;;)
_0x114:
;    1200     {
;    1201         read_adc(4);
	CALL SUBOPT_0x18
;    1202         if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_bb4
	CP   R26,R30
	BRSH _0x116
	CALL SUBOPT_0x18
	STS  _bb4,R30
;    1203         if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
_0x116:
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_ba4
	CP   R30,R26
	BRSH _0x117
	CALL SUBOPT_0x18
	STS  _ba4,R30
;    1204 
;    1205         bt4=((bb4+ba4)/2);
_0x117:
	CALL SUBOPT_0x48
;    1206 
;    1207         lcd_clear();
	CALL SUBOPT_0x3F
;    1208         lcd_gotoxy(1,0);
;    1209         lcd_putsf(" bb4  ba4  bt4");
	__POINTW1FN _0,740
	CALL SUBOPT_0x1
;    1210         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1211         sprintf(lcd," %d  %d  %d",bb4,ba4,bt4);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb4
	CALL SUBOPT_0x32
	LDS  R30,_ba4
	CALL SUBOPT_0x32
	CALL SUBOPT_0x39
	CALL SUBOPT_0x41
;    1212         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1213         delay_ms(10);
;    1214 
;    1215         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x118
;    1216         {
;    1217             delay_ms(150);
	CALL SUBOPT_0x44
;    1218             goto sensor5;
	RJMP _0x119
;    1219         }
;    1220     }
_0x118:
	RJMP _0x114
;    1221     sensor5:
_0x119:
;    1222     for(;;)
_0x11B:
;    1223     {
;    1224         read_adc(5);
	CALL SUBOPT_0x19
;    1225         if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_bb5
	CP   R26,R30
	BRSH _0x11D
	CALL SUBOPT_0x19
	STS  _bb5,R30
;    1226         if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
_0x11D:
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_ba5
	CP   R30,R26
	BRSH _0x11E
	CALL SUBOPT_0x19
	STS  _ba5,R30
;    1227 
;    1228         bt5=((bb5+ba5)/2);
_0x11E:
	CALL SUBOPT_0x49
;    1229 
;    1230         lcd_clear();
	CALL SUBOPT_0x3F
;    1231         lcd_gotoxy(1,0);
;    1232         lcd_putsf(" bb5  ba5  bt5");
	__POINTW1FN _0,755
	CALL SUBOPT_0x1
;    1233         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1234         sprintf(lcd," %d  %d  %d",bb5,ba5,bt5);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb5
	CALL SUBOPT_0x32
	LDS  R30,_ba5
	CALL SUBOPT_0x32
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x41
;    1235         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1236         delay_ms(10);
;    1237 
;    1238         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x11F
;    1239         {
;    1240             delay_ms(150);
	CALL SUBOPT_0x44
;    1241             goto sensor6;
	RJMP _0x120
;    1242         }
;    1243     }
_0x11F:
	RJMP _0x11B
;    1244     sensor6:
_0x120:
;    1245     for(;;)
_0x122:
;    1246     {
;    1247         read_adc(06);
	CALL SUBOPT_0x1A
;    1248         if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_bb6
	CP   R26,R30
	BRSH _0x124
	CALL SUBOPT_0x1A
	STS  _bb6,R30
;    1249         if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
_0x124:
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_ba6
	CP   R30,R26
	BRSH _0x125
	CALL SUBOPT_0x1A
	STS  _ba6,R30
;    1250 
;    1251         bt6=((bb6+ba6)/2);
_0x125:
	CALL SUBOPT_0x4A
;    1252 
;    1253         lcd_clear();
	CALL SUBOPT_0x3F
;    1254         lcd_gotoxy(1,0);
;    1255         lcd_putsf(" bb6  ba6  bt6");
	__POINTW1FN _0,770
	CALL SUBOPT_0x1
;    1256         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1257         sprintf(lcd," %d  %d  %d",bb6,ba6,bt6);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb6
	CALL SUBOPT_0x32
	LDS  R30,_ba6
	CALL SUBOPT_0x32
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x41
;    1258         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1259         delay_ms(10);
;    1260 
;    1261         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x126
;    1262         {
;    1263             delay_ms(150);
	CALL SUBOPT_0x44
;    1264             goto sensor7;
	RJMP _0x127
;    1265         }
;    1266     }
_0x126:
	RJMP _0x122
;    1267     sensor7:
_0x127:
;    1268     for(;;)
_0x129:
;    1269     {
;    1270         read_adc(7);
	CALL SUBOPT_0x1B
;    1271         if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
	CALL SUBOPT_0x1B
	MOV  R26,R30
	LDS  R30,_bb7
	CP   R26,R30
	BRSH _0x12B
	CALL SUBOPT_0x1B
	STS  _bb7,R30
;    1272         if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
_0x12B:
	CALL SUBOPT_0x1B
	CP   R12,R30
	BRSH _0x12C
	CALL SUBOPT_0x1B
	MOV  R12,R30
;    1273 
;    1274         bt7=((bb7+ba7)/2);
_0x12C:
	CALL SUBOPT_0x4B
;    1275 
;    1276         lcd_clear();
;    1277         lcd_gotoxy(1,0);
;    1278         lcd_putsf(" bb7  ba7  bt7");
	__POINTW1FN _0,785
	CALL SUBOPT_0x1
;    1279         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1280         sprintf(lcd," %d  %d  %d",bb7,ba7,bt7);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb7
	CALL SUBOPT_0x32
	MOV  R30,R12
	CALL SUBOPT_0x32
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x41
;    1281         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1282         delay_ms(10);
;    1283 
;    1284         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x12D
;    1285         {
;    1286             delay_ms(150);
	CALL SUBOPT_0x44
;    1287             goto selesai;
	RJMP _0x12E
;    1288         }
;    1289     }
_0x12D:
	RJMP _0x129
;    1290     selesai:
_0x12E:
;    1291     lcd_clear();
	CALL _lcd_clear
;    1292 }
	RET
;    1293 
;    1294 void auto_scan()
;    1295 {
_auto_scan:
;    1296     for(;;)
_0x130:
;    1297     {
;    1298     read_adc(0);
	CALL SUBOPT_0x14
;    1299         if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_bb0
	CP   R26,R30
	BRSH _0x132
	CALL SUBOPT_0x14
	STS  _bb0,R30
;    1300         if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
_0x132:
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_ba0
	CP   R30,R26
	BRSH _0x133
	CALL SUBOPT_0x14
	STS  _ba0,R30
;    1301 
;    1302         bt0=((bb0+ba0)/2);
_0x133:
	CALL SUBOPT_0x3E
;    1303 
;    1304     read_adc(1);
	CALL SUBOPT_0x15
;    1305         if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_bb1
	CP   R26,R30
	BRSH _0x134
	CALL SUBOPT_0x15
	STS  _bb1,R30
;    1306         if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
_0x134:
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_ba1
	CP   R30,R26
	BRSH _0x135
	CALL SUBOPT_0x15
	STS  _ba1,R30
;    1307 
;    1308         bt1=((bb1+ba1)/2);
_0x135:
	CALL SUBOPT_0x43
;    1309 
;    1310     read_adc(2);
	CALL SUBOPT_0x16
;    1311         if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_bb2
	CP   R26,R30
	BRSH _0x136
	CALL SUBOPT_0x16
	STS  _bb2,R30
;    1312         if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
_0x136:
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_ba2
	CP   R30,R26
	BRSH _0x137
	CALL SUBOPT_0x16
	STS  _ba2,R30
;    1313 
;    1314         bt2=((bb2+ba2)/2);
_0x137:
	CALL SUBOPT_0x45
;    1315 
;    1316     read_adc(3);
	CALL SUBOPT_0x17
;    1317         if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_bb3
	CP   R26,R30
	BRSH _0x138
	CALL SUBOPT_0x17
	STS  _bb3,R30
;    1318         if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
_0x138:
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_ba3
	CP   R30,R26
	BRSH _0x139
	CALL SUBOPT_0x17
	STS  _ba3,R30
;    1319 
;    1320         bt3=((bb3+ba3)/2);
_0x139:
	CALL SUBOPT_0x47
;    1321 
;    1322     read_adc(4);
	CALL SUBOPT_0x18
;    1323         if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_bb4
	CP   R26,R30
	BRSH _0x13A
	CALL SUBOPT_0x18
	STS  _bb4,R30
;    1324         if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
_0x13A:
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_ba4
	CP   R30,R26
	BRSH _0x13B
	CALL SUBOPT_0x18
	STS  _ba4,R30
;    1325 
;    1326         bt4=((bb4+ba4)/2);
_0x13B:
	CALL SUBOPT_0x48
;    1327 
;    1328     read_adc(5);
	CALL SUBOPT_0x19
;    1329         if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_bb5
	CP   R26,R30
	BRSH _0x13C
	CALL SUBOPT_0x19
	STS  _bb5,R30
;    1330         if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
_0x13C:
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_ba5
	CP   R30,R26
	BRSH _0x13D
	CALL SUBOPT_0x19
	STS  _ba5,R30
;    1331 
;    1332         bt5=((bb5+ba5)/2);
_0x13D:
	CALL SUBOPT_0x49
;    1333 
;    1334     read_adc(6);
	CALL SUBOPT_0x1A
;    1335         if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_bb6
	CP   R26,R30
	BRSH _0x13E
	CALL SUBOPT_0x1A
	STS  _bb6,R30
;    1336         if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
_0x13E:
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_ba6
	CP   R30,R26
	BRSH _0x13F
	CALL SUBOPT_0x1A
	STS  _ba6,R30
;    1337 
;    1338         bt6=((bb6+ba6)/2);
_0x13F:
	CALL SUBOPT_0x4A
;    1339 
;    1340     read_adc(7);
	CALL SUBOPT_0x1B
;    1341         if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
	CALL SUBOPT_0x1B
	MOV  R26,R30
	LDS  R30,_bb7
	CP   R26,R30
	BRSH _0x140
	CALL SUBOPT_0x1B
	STS  _bb7,R30
;    1342         if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
_0x140:
	CALL SUBOPT_0x1B
	CP   R12,R30
	BRSH _0x141
	CALL SUBOPT_0x1B
	MOV  R12,R30
;    1343 
;    1344         bt7=((bb7+ba7)/2);
_0x141:
	CALL SUBOPT_0x4B
;    1345 
;    1346         lcd_clear();
;    1347         lcd_gotoxy(1,0);
;    1348         sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x39
	CALL SUBOPT_0x38
	CALL SUBOPT_0x37
	CALL SUBOPT_0x36
	CALL SUBOPT_0x35
	CALL SUBOPT_0x3D
;    1349         lcd_puts(lcd);
	CALL _lcd_puts
;    1350         delay_ms(120);
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x4
;    1351 
;    1352         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x142
;    1353         {
;    1354                 //showMenu();
;    1355                 lcd_clear();
	CALL SUBOPT_0x3F
;    1356                 lcd_gotoxy(1,0);
;    1357                 sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x4C
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x39
	CALL SUBOPT_0x38
	CALL SUBOPT_0x37
	CALL SUBOPT_0x36
	CALL SUBOPT_0x35
	CALL SUBOPT_0x3D
;    1358                 lcd_puts(lcd);
	CALL _lcd_puts
;    1359         }
;    1360     }
_0x142:
	RJMP _0x130
;    1361 }
;    1362 
;    1363 void ikuti_garis()
;    1364 {
;    1365         baca_sensor();
;    1366 
;    1367         if((sensor==0b00000001) || (0b11111110)){bkan();      error = 15;     x=1;}  //kanan
;    1368         if((sensor==0b00000011) || (0b11111100)){maju();      error = 10;     x=1;}
;    1369         if((sensor==0b00000010) || (0b11111101)){maju();      error = 8;      x=1;}
;    1370         if((sensor==0b00000110) || (0b11111001)){maju();      error = 5;      x=1;}
;    1371         if((sensor==0b00000100) || (0b11111011)){maju();      error = 3;      x=1;}
;    1372         if((sensor==0b00001100) || (0b11110011)){maju();      error = 2;      x=1;}
;    1373         if((sensor==0b00001000) || (0b11110111)){maju();      error = 1;      x=1;}
;    1374 
;    1375         if((sensor==0b00010000) || (0b11101111)){maju();      error = -1;     x=0;}
;    1376         if((sensor==0b00110000) || (0b11001111)){maju();      error = -2;     x=0;}
;    1377         if((sensor==0b00100000) || (0b11011111)){maju();      error = -3;     x=0;}
;    1378         if((sensor==0b01100000) || (0b1001111)){maju();      error = -5;     x=0;}
;    1379         if((sensor==0b01000000) || (0b10111111)){maju();      error = -8;     x=0;}
;    1380         if((sensor==0b11000000) || (0b00111111)){maju();      error = -10;    x=0;}
;    1381         if((sensor==0b10000000) || (0b01111111)){bkir();      error = -15;    x=0;}  //kiri
;    1382 
;    1383         if(
;    1384                 (sensor==0b10000001) ||
;    1385                 (sensor==0b11000011) ||
;    1386                 (sensor==0b01000010)
;    1387                 ||
;    1388                 (sensor==0b01111110) ||
;    1389                 (sensor==0b00111100) ||
;    1390                 (sensor==0b10111101))
;    1391                 {
;    1392                         bkir();
;    1393                         error = -20;
;    1394                 }
;    1395 
;    1396         d_error = error-last_error;
;    1397         PV      = (Kp*error)+(Kd*d_error);
;    1398 
;    1399         rpwm=intervalPWM+PV;
;    1400         lpwm=intervalPWM-PV;
;    1401 
;    1402         last_error=error;
;    1403 
;    1404         if(lpwm>=255)       lpwm = 255;
;    1405         if(lpwm<=0)         lpwm = 0;
;    1406 
;    1407         if(rpwm>=255)       rpwm = 255;
;    1408         if(rpwm<=0)         rpwm = 0;
;    1409 
;    1410         sprintf(lcd_buffer,"%d   %d",lpwm, rpwm);
;    1411         lcd_gotoxy(0, 0);
;    1412         //lcd_putsf("                ");
;    1413         //lcd_gotoxy(0, 0);
;    1414         lcd_puts(lcd_buffer);
;    1415         delay_ms(5);
;    1416 }
;    1417 

_getchar:
     sbis usr,rxc
     rjmp _getchar
     in   r30,udr
	RET
_putchar:
     sbis usr,udre
     rjmp _putchar
     ld   r30,y
     out  udr,r30
	ADIW R28,1
	RET
__put_G2:
	ST   -Y,R17
	ST   -Y,R16
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	CALL __GETW1P
	SBIW R30,0
	BREQ _0x174
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x176
	__CPWRN 16,17,2
	BRLO _0x177
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x176:
	LDD  R26,Y+4
	LDD  R27,Y+4+1
	LD   R30,X+
	LD   R31,X+
	ADIW R30,1
	ST   -X,R31
	ST   -X,R30
	SBIW R30,1
	LDD  R26,Y+6
	STD  Z+0,R26
_0x177:
	RJMP _0x178
_0x174:
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _putchar
_0x178:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__print_G2:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
_0x179:
	LDD  R30,Y+18
	LDD  R31,Y+18+1
	ADIW R30,1
	STD  Y+18,R30
	STD  Y+18+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R18,R30
	CPI  R30,0
	BRNE PC+3
	JMP _0x17B
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x17F
	CPI  R18,37
	BRNE _0x180
	LDI  R17,LOW(1)
	RJMP _0x181
_0x180:
	CALL SUBOPT_0x4D
_0x181:
	RJMP _0x17E
_0x17F:
	CPI  R30,LOW(0x1)
	BRNE _0x182
	CPI  R18,37
	BRNE _0x183
	CALL SUBOPT_0x4D
	RJMP _0x1FF
_0x183:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x184
	LDI  R16,LOW(1)
	RJMP _0x17E
_0x184:
	CPI  R18,43
	BRNE _0x185
	LDI  R20,LOW(43)
	RJMP _0x17E
_0x185:
	CPI  R18,32
	BRNE _0x186
	LDI  R20,LOW(32)
	RJMP _0x17E
_0x186:
	RJMP _0x187
_0x182:
	CPI  R30,LOW(0x2)
	BRNE _0x188
_0x187:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x189
	ORI  R16,LOW(128)
	RJMP _0x17E
_0x189:
	RJMP _0x18A
_0x188:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x17E
_0x18A:
	CPI  R18,48
	BRLO _0x18D
	CPI  R18,58
	BRLO _0x18E
_0x18D:
	RJMP _0x18C
_0x18E:
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x17E
_0x18C:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x192
	CALL SUBOPT_0x4E
	LD   R30,X
	CALL SUBOPT_0x4F
	RJMP _0x193
_0x192:
	CPI  R30,LOW(0x73)
	BRNE _0x195
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x50
	CALL _strlen
	MOV  R17,R30
	RJMP _0x196
_0x195:
	CPI  R30,LOW(0x70)
	BRNE _0x198
	CALL SUBOPT_0x4E
	CALL SUBOPT_0x50
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x196:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x199
_0x198:
	CPI  R30,LOW(0x64)
	BREQ _0x19C
	CPI  R30,LOW(0x69)
	BRNE _0x19D
_0x19C:
	ORI  R16,LOW(4)
	RJMP _0x19E
_0x19D:
	CPI  R30,LOW(0x75)
	BRNE _0x19F
_0x19E:
	LDI  R30,LOW(_tbl10_G2*2)
	LDI  R31,HIGH(_tbl10_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x1A0
_0x19F:
	CPI  R30,LOW(0x58)
	BRNE _0x1A2
	ORI  R16,LOW(8)
	RJMP _0x1A3
_0x1A2:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x1D4
_0x1A3:
	LDI  R30,LOW(_tbl16_G2*2)
	LDI  R31,HIGH(_tbl16_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x1A0:
	SBRS R16,2
	RJMP _0x1A5
	CALL SUBOPT_0x4E
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,0
	BRGE _0x1A6
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x1A6:
	CPI  R20,0
	BREQ _0x1A7
	SUBI R17,-LOW(1)
	RJMP _0x1A8
_0x1A7:
	ANDI R16,LOW(251)
_0x1A8:
	RJMP _0x1A9
_0x1A5:
	CALL SUBOPT_0x4E
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x1A9:
_0x199:
	SBRC R16,0
	RJMP _0x1AA
_0x1AB:
	CP   R17,R21
	BRSH _0x1AD
	SBRS R16,7
	RJMP _0x1AE
	SBRS R16,2
	RJMP _0x1AF
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x1B0
_0x1AF:
	LDI  R18,LOW(48)
_0x1B0:
	RJMP _0x1B1
_0x1AE:
	LDI  R18,LOW(32)
_0x1B1:
	CALL SUBOPT_0x4D
	SUBI R21,LOW(1)
	RJMP _0x1AB
_0x1AD:
_0x1AA:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x1B2
_0x1B3:
	CPI  R19,0
	BREQ _0x1B5
	SBRS R16,3
	RJMP _0x1B6
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x200
_0x1B6:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x200:
	ST   -Y,R30
	CALL SUBOPT_0x51
	CPI  R21,0
	BREQ _0x1B8
	SUBI R21,LOW(1)
_0x1B8:
	SUBI R19,LOW(1)
	RJMP _0x1B3
_0x1B5:
	RJMP _0x1B9
_0x1B2:
_0x1BB:
	LDI  R18,LOW(48)
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,2
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,2
	CALL __GETW1PF
	STD  Y+8,R30
	STD  Y+8+1,R31
_0x1BD:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x1BF
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x1BD
_0x1BF:
	CPI  R18,58
	BRLO _0x1C0
	SBRS R16,3
	RJMP _0x1C1
	SUBI R18,-LOW(7)
	RJMP _0x1C2
_0x1C1:
	SUBI R18,-LOW(39)
_0x1C2:
_0x1C0:
	SBRC R16,4
	RJMP _0x1C4
	CPI  R18,49
	BRSH _0x1C6
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x1C5
_0x1C6:
	RJMP _0x201
_0x1C5:
	CP   R21,R19
	BRLO _0x1CA
	SBRS R16,0
	RJMP _0x1CB
_0x1CA:
	RJMP _0x1C9
_0x1CB:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x1CC
	LDI  R18,LOW(48)
_0x201:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x1CD
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x51
	CPI  R21,0
	BREQ _0x1CE
	SUBI R21,LOW(1)
_0x1CE:
_0x1CD:
_0x1CC:
_0x1C4:
	CALL SUBOPT_0x4D
	CPI  R21,0
	BREQ _0x1CF
	SUBI R21,LOW(1)
_0x1CF:
_0x1C9:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x1BC
	RJMP _0x1BB
_0x1BC:
_0x1B9:
	SBRS R16,0
	RJMP _0x1D0
_0x1D1:
	CPI  R21,0
	BREQ _0x1D3
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x4F
	RJMP _0x1D1
_0x1D3:
_0x1D0:
_0x1D4:
_0x193:
_0x1FF:
	LDI  R17,LOW(0)
_0x17E:
	RJMP _0x179
_0x17B:
	CALL __LOADLOCR6
	ADIW R28,20
	RET
_sprintf:
	PUSH R15
	MOV  R15,R24
	SBIW R28,2
	ST   -Y,R17
	ST   -Y,R16
	MOVW R26,R28
	CALL __ADDW2R15
	MOVW R16,R26
	MOVW R26,R28
	ADIW R26,6
	CALL __ADDW2R15
	CALL __GETW1P
	STD  Y+2,R30
	STD  Y+2+1,R31
	MOVW R26,R28
	ADIW R26,4
	CALL __ADDW2R15
	CALL __GETW1P
	ST   -Y,R31
	ST   -Y,R30
	ST   -Y,R17
	ST   -Y,R16
	MOVW R30,R28
	ADIW R30,6
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	LDI  R31,HIGH(0)
	ST   -Y,R31
	ST   -Y,R30
	CALL __print_G2
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	LDI  R30,LOW(0)
	ST   X,R30
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,4
	POP  R15
	RET
    .equ __lcd_direction=__lcd_port-1
    .equ __lcd_pin=__lcd_port-2
    .equ __lcd_rs=0
    .equ __lcd_rd=1
    .equ __lcd_enable=2
    .equ __lcd_busy_flag=7

	.DSEG
__base_y_G3:
	.BYTE 0x4
__lcd_x:
	.BYTE 0x1
__lcd_y:
	.BYTE 0x1
__lcd_maxx:
	.BYTE 0x1

	.CSEG
__lcd_delay_G3:
    ldi   r31,15
__lcd_delay0:
    dec   r31
    brne  __lcd_delay0
	RET
__lcd_ready:
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
    cbi   __lcd_port,__lcd_rs     ;RS=0
__lcd_busy:
	CALL __lcd_delay_G3
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G3
    in    r26,__lcd_pin
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G3
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G3
    cbi   __lcd_port,__lcd_enable ;EN=0
    sbrc  r26,__lcd_busy_flag
    rjmp  __lcd_busy
	RET
__lcd_write_nibble_G3:
    andi  r26,0xf0
    or    r26,r27
    out   __lcd_port,r26          ;write
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G3
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G3
	RET
__lcd_write_data:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf0 | (1<<__lcd_rs) | (1<<__lcd_rd) | (1<<__lcd_enable) ;set as output    
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G3
    ld    r26,y
    swap  r26
	CALL __lcd_write_nibble_G3
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
__lcd_read_nibble_G3:
    sbi   __lcd_port,__lcd_enable ;EN=1
	CALL __lcd_delay_G3
    in    r30,__lcd_pin           ;read
    cbi   __lcd_port,__lcd_enable ;EN=0
	CALL __lcd_delay_G3
    andi  r30,0xf0
	RET
_lcd_read_byte0_G3:
	CALL __lcd_delay_G3
	CALL __lcd_read_nibble_G3
    mov   r26,r30
	CALL __lcd_read_nibble_G3
    cbi   __lcd_port,__lcd_rd     ;RD=0
    swap  r30
    or    r30,r26
	RET
_lcd_gotoxy:
	CALL __lcd_ready
	LD   R30,Y
	LDI  R31,0
	SUBI R30,LOW(-__base_y_G3)
	SBCI R31,HIGH(-__base_y_G3)
	LD   R30,Z
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	CALL __lcd_write_data
	LDD  R30,Y+1
	STS  __lcd_x,R30
	LD   R30,Y
	STS  __lcd_y,R30
	ADIW R28,2
	RET
_lcd_clear:
	CALL __lcd_ready
	LDI  R30,LOW(2)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(12)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL __lcd_ready
	LDI  R30,LOW(1)
	ST   -Y,R30
	CALL __lcd_write_data
	LDI  R30,LOW(0)
	STS  __lcd_y,R30
	STS  __lcd_x,R30
	RET
_lcd_putchar:
    push r30
    push r31
    ld   r26,y
    set
    cpi  r26,10
    breq __lcd_putchar1
    clt
	LDS  R30,__lcd_x
	SUBI R30,-LOW(1)
	STS  __lcd_x,R30
	LDS  R30,__lcd_maxx
	LDS  R26,__lcd_x
	CP   R30,R26
	BRSH _0x1D6
	__lcd_putchar1:
	LDS  R30,__lcd_y
	SUBI R30,-LOW(1)
	STS  __lcd_y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDS  R30,__lcd_y
	ST   -Y,R30
	CALL _lcd_gotoxy
	brts __lcd_putchar0
_0x1D6:
    rcall __lcd_ready
    sbi  __lcd_port,__lcd_rs ;RS=1
    ld   r26,y
    st   -y,r26
    rcall __lcd_write_data
__lcd_putchar0:
    pop  r31
    pop  r30
	ADIW R28,1
	RET
_lcd_puts:
	ST   -Y,R17
_0x1D7:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x1D9
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x1D7
_0x1D9:
	LDD  R17,Y+0
	RJMP _0x1DF
_lcd_putsf:
	ST   -Y,R17
_0x1DA:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x1DC
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x1DA
_0x1DC:
	LDD  R17,Y+0
_0x1DF:
	ADIW R28,3
	RET
__long_delay_G3:
    clr   r26
    clr   r27
__long_delay0:
    sbiw  r26,1         ;2 cycles
    brne  __long_delay0 ;2 cycles
	RET
__lcd_init_write_G3:
    cbi  __lcd_port,__lcd_rd 	  ;RD=0
    in    r26,__lcd_direction
    ori   r26,0xf7                ;set as output
    out   __lcd_direction,r26
    in    r27,__lcd_port
    andi  r27,0xf
    ld    r26,y
	CALL __lcd_write_nibble_G3
    sbi   __lcd_port,__lcd_rd     ;RD=1
	ADIW R28,1
	RET
_lcd_init:
    cbi   __lcd_port,__lcd_enable ;EN=0
    cbi   __lcd_port,__lcd_rs     ;RS=0
	LD   R30,Y
	STS  __lcd_maxx,R30
	SUBI R30,-LOW(128)
	__PUTB1MN __base_y_G3,2
	LD   R30,Y
	SUBI R30,-LOW(192)
	__PUTB1MN __base_y_G3,3
	CALL SUBOPT_0x52
	CALL SUBOPT_0x52
	CALL SUBOPT_0x52
	CALL __long_delay_G3
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL __lcd_init_write_G3
	CALL __long_delay_G3
	LDI  R30,LOW(40)
	CALL SUBOPT_0x53
	LDI  R30,LOW(4)
	CALL SUBOPT_0x53
	LDI  R30,LOW(133)
	CALL SUBOPT_0x53
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G3
	CPI  R30,LOW(0x5)
	BREQ _0x1DD
	LDI  R30,LOW(0)
	RJMP _0x1DE
_0x1DD:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x1DE:
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 55 TIMES, CODE SIZE REDUCTION:105 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:81 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	ST   -Y,R31
	ST   -Y,R30
	CALL _delay_ms
	JMP  _lcd_clear

;OPTIMIZER ADDED SUBROUTINE, CALLED 77 TIMES, CODE SIZE REDUCTION:149 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xA:
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xB:
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xD:
	LDI  R30,0
	STS  _lpwm,R30
	STS  _lpwm+1,R30
	LDI  R30,0
	STS  _rpwm,R30
	STS  _rpwm+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xE:
	LDS  R26,_b
	LDS  R27,_b+1
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xF:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x10:
	LDS  R30,_lpwm
	LDS  R31,_lpwm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x11:
	RCALL SUBOPT_0xB
	LDS  R30,_rpwm
	LDS  R31,_rpwm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:37 WORDS
SUBOPT_0x12:
	RCALL SUBOPT_0xC
	CALL _lcd_clear
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	CALL _lcd_gotoxy
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,100
	ST   -Y,R31
	ST   -Y,R30
	RCALL SUBOPT_0x10
	CALL __CWD1
	CALL __PUTPARD1
	LDS  R30,_rpwm
	LDS  R31,_rpwm+1
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x13:
	LDS  R30,_b
	LDS  R31,_b+1
	ADIW R30,1
	STS  _b,R30
	STS  _b+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(5)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(6)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1B:
	LDI  R30,LOW(7)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(_bt2)
	LDI  R27,HIGH(_bt2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(_bt3)
	LDI  R27,HIGH(_bt3)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(_bt4)
	LDI  R27,HIGH(_bt4)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_bt5)
	LDI  R27,HIGH(_bt5)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(_bt6)
	LDI  R27,HIGH(_bt6)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x23:
	LDI  R26,LOW(_bt7)
	LDI  R27,HIGH(_bt7)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x24:
	CALL __DIVB21U
	MOV  R17,R30
	SUBI R17,-LOW(48)
	ST   -Y,R17
	CALL _lcd_putchar
	LDD  R26,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 23 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x26:
	CALL _lcd_clear
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 45 TIMES, CODE SIZE REDUCTION:85 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(225)
	LDI  R31,HIGH(225)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x28:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(32)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x2A:
	ST   -Y,R30
	CALL _tampil
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x2C:
	ST   -Y,R30
	CALL _setByte
	RJMP SUBOPT_0x5

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x2D:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x2E:
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x2F:
	__POINTW1FN _0,484
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x30:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 26 TIMES, CODE SIZE REDUCTION:47 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 56 TIMES, CODE SIZE REDUCTION:162 WORDS
SUBOPT_0x32:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x33:
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x34:
	LDS  R26,_xcount
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x35:
	RCALL SUBOPT_0x1C
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x36:
	RCALL SUBOPT_0x1D
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x37:
	RCALL SUBOPT_0x1E
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x38:
	RCALL SUBOPT_0x1F
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x39:
	RCALL SUBOPT_0x20
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3A:
	RCALL SUBOPT_0x21
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3B:
	RCALL SUBOPT_0x22
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	RCALL SUBOPT_0x23
	RJMP SUBOPT_0x32

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3D:
	LDI  R24,32
	CALL _sprintf
	ADIW R28,36
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3E:
	LDS  R30,_ba0
	LDS  R26,_bb0
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x3F:
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x40:
	__POINTW1FN _0,683
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x41:
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x42:
	CALL _lcd_puts
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x43:
	LDS  R30,_ba1
	LDS  R26,_bb1
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x44:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x45:
	LDS  R30,_ba2
	LDS  R26,_bb2
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt2)
	LDI  R27,HIGH(_bt2)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x46:
	CALL _lcd_puts
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x47:
	LDS  R30,_ba3
	LDS  R26,_bb3
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt3)
	LDI  R27,HIGH(_bt3)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x48:
	LDS  R30,_ba4
	LDS  R26,_bb4
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt4)
	LDI  R27,HIGH(_bt4)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x49:
	LDS  R30,_ba5
	LDS  R26,_bb5
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt5)
	LDI  R27,HIGH(_bt5)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4A:
	LDS  R30,_ba6
	LDS  R26,_bb6
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt6)
	LDI  R27,HIGH(_bt6)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x4B:
	MOV  R30,R12
	LDS  R26,_bb7
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt7)
	LDI  R27,HIGH(_bt7)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x3F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4C:
	__POINTW1FN _0,644
	ST   -Y,R31
	ST   -Y,R30
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x4D:
	ST   -Y,R18
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x4E:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,4
	STD  Y+16,R26
	STD  Y+16+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4F:
	ST   -Y,R30
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x50:
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x51:
	LDD  R30,Y+15
	LDD  R31,Y+15+1
	ST   -Y,R31
	ST   -Y,R30
	MOVW R30,R28
	ADIW R30,15
	ST   -Y,R31
	ST   -Y,R30
	JMP  __put_G2

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x52:
	CALL __long_delay_G3
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x53:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __long_delay_G3

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

_strlenf:
	clr  r26
	clr  r27
	ld   r30,y+
	ld   r31,y+
__strlenf0:
	lpm  r0,z+
	tst  r0
	breq __strlenf1
	adiw r26,1
	rjmp __strlenf0
__strlenf1:
	movw r30,r26
	ret

_delay_ms:
	ld   r30,y+
	ld   r31,y+
	adiw r30,0
	breq __delay_ms1
__delay_ms0:
	__DELAY_USW 0x7D0
	wdr
	sbiw r30,1
	brne __delay_ms0
__delay_ms1:
	ret

__ADDW2R15:
	CLR  R0
	ADD  R26,R15
	ADC  R27,R0
	RET

__ANEGW1:
	COM  R30
	COM  R31
	ADIW R30,1
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
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

__MODB21U:
	RCALL __DIVB21U
	MOV  R30,R26
	RET

__GETW1P:
	LD   R30,X+
	LD   R31,X
	SBIW R26,1
	RET

__GETW1PF:
	LPM  R0,Z+
	LPM  R31,Z
	MOV  R30,R0
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

;END OF CODE MARKER
__END_OF_CODE:
