
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

	.INCLUDE "kel muksin.vec"
	.INCLUDE "kel muksin.inc"

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
;      30 #define sw_ok     PINC.0
;      31 #define sw_cancel PINC.1
;      32 #define sw_up     PINC.2
;      33 #define sw_down   PINC.3
;      34 
;      35 #define Enki PORTD.4
;      36 #define kirplus PORTD.6
;      37 #define kirmin PORTD.3
;      38 #define Enka PORTD.5
;      39 #define kaplus PORTD.1
;      40 #define kamin PORTD.0
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
;     144         TCCR0=0x00;
	LDI  R30,LOW(0)
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
;     194         while (1)
_0x17:
;     195         {
;     196                 displaySensorBit();
	RCALL _displaySensorBit
;     197                 ikuti_garis();
	CALL _ikuti_garis
;     198         };
	RJMP _0x17
;     199 }
_0x1A:
	RJMP _0x1A
;     200 
;     201 void pemercepat()
;     202 {
_pemercepat:
;     203         lpwm=0;
	CALL SUBOPT_0xB
;     204         rpwm=0;
;     205 
;     206         rotkir();
	RCALL _rotkir
;     207 
;     208         for(b=0;b<255;b++)
	LDI  R30,0
	STS  _b,R30
	STS  _b+1,R30
_0x1C:
	CALL SUBOPT_0xC
	BRGE _0x1D
;     209         {
;     210                 delay_ms(125);
	CALL SUBOPT_0xD
;     211 
;     212                 lpwm++;
	CALL SUBOPT_0xE
	ADIW R30,1
	CALL SUBOPT_0xF
;     213                 rpwm++;
	CALL SUBOPT_0x10
	ADIW R30,1
	CALL SUBOPT_0x11
;     214 
;     215                 lcd_clear();
	CALL SUBOPT_0x12
;     216 
;     217                 lcd_gotoxy(0,0);
;     218                 sprintf(lcd," %d %d",lpwm,rpwm);
;     219                 lcd_puts(lcd);
;     220         }
	CALL SUBOPT_0x13
	RJMP _0x1C
_0x1D:
;     221         lpwm=0;
	CALL SUBOPT_0xB
;     222         rpwm=0;
;     223 }
	RET
;     224 
;     225 void pelambat()
;     226 {
_pelambat:
;     227         lpwm=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0xF
;     228         rpwm=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x11
;     229 
;     230         rotkan();
	RCALL _rotkan
;     231 
;     232         for(b=0;b<255;b++)
	LDI  R30,0
	STS  _b,R30
	STS  _b+1,R30
_0x1F:
	CALL SUBOPT_0xC
	BRGE _0x20
;     233         {
;     234                 delay_ms(125);
	CALL SUBOPT_0xD
;     235 
;     236                 lpwm--;
	CALL SUBOPT_0xE
	SBIW R30,1
	CALL SUBOPT_0xF
;     237                 rpwm--;
	CALL SUBOPT_0x10
	SBIW R30,1
	CALL SUBOPT_0x11
;     238 
;     239                 lcd_clear();
	CALL SUBOPT_0x12
;     240 
;     241                 lcd_gotoxy(0,0);
;     242                 sprintf(lcd," %d %d",lpwm,rpwm);
;     243                 lcd_puts(lcd);
;     244         }
	CALL SUBOPT_0x13
	RJMP _0x1F
_0x20:
;     245         lpwm=0;
	CALL SUBOPT_0xB
;     246         rpwm=0;
;     247 }
	RET
;     248 
;     249 void baca_sensor()
;     250 {
_baca_sensor:
;     251         sensor=0;
	CLR  R5
;     252         adc0=read_adc(0);
	CALL SUBOPT_0x14
	MOV  R4,R30
;     253         adc1=read_adc(1);
	CALL SUBOPT_0x15
	MOV  R7,R30
;     254         adc2=read_adc(2);
	CALL SUBOPT_0x16
	MOV  R6,R30
;     255         adc3=read_adc(3);
	CALL SUBOPT_0x17
	MOV  R9,R30
;     256         adc4=read_adc(4);
	CALL SUBOPT_0x18
	MOV  R8,R30
;     257         adc5=read_adc(5);
	CALL SUBOPT_0x19
	MOV  R11,R30
;     258         adc6=read_adc(6);
	CALL SUBOPT_0x1A
	MOV  R10,R30
;     259         adc7=read_adc(7);
	CALL SUBOPT_0x1B
	MOV  R13,R30
;     260 
;     261         if(adc0>bt0){s0=1;sensor=sensor|1<<0;}
	CALL SUBOPT_0x1C
	CP   R30,R4
	BRSH _0x21
	SET
	BLD  R2,0
	LDI  R30,LOW(1)
	RJMP _0x1C1
;     262         else {s0=0;sensor=sensor|0<<0;}
_0x21:
	CLT
	BLD  R2,0
	LDI  R30,LOW(0)
_0x1C1:
	OR   R5,R30
;     263 
;     264         if(adc1>bt1){s1=1;sensor=sensor|1<<1;}
	CALL SUBOPT_0x1D
	CP   R30,R7
	BRSH _0x23
	SET
	BLD  R2,1
	LDI  R30,LOW(2)
	RJMP _0x1C2
;     265         else {s1=0;sensor=sensor|0<<1;}
_0x23:
	CLT
	BLD  R2,1
	LDI  R30,LOW(0)
_0x1C2:
	OR   R5,R30
;     266 
;     267         if(adc2>bt2){s2=1;sensor=sensor|1<<2;}
	CALL SUBOPT_0x1E
	CP   R30,R6
	BRSH _0x25
	SET
	BLD  R2,2
	LDI  R30,LOW(4)
	RJMP _0x1C3
;     268         else {s2=0;sensor=sensor|0<<2;}
_0x25:
	CLT
	BLD  R2,2
	LDI  R30,LOW(0)
_0x1C3:
	OR   R5,R30
;     269 
;     270         if(adc3>bt3){s3=1;sensor=sensor|1<<3;}
	CALL SUBOPT_0x1F
	CP   R30,R9
	BRSH _0x27
	SET
	BLD  R2,3
	LDI  R30,LOW(8)
	RJMP _0x1C4
;     271         else {s3=0;sensor=sensor|0<<3;}
_0x27:
	CLT
	BLD  R2,3
	LDI  R30,LOW(0)
_0x1C4:
	OR   R5,R30
;     272 
;     273         if(adc4>bt4){s4=1;sensor=sensor|1<<4;}
	CALL SUBOPT_0x20
	CP   R30,R8
	BRSH _0x29
	SET
	BLD  R2,4
	LDI  R30,LOW(16)
	RJMP _0x1C5
;     274         else {s4=0;sensor=sensor|0<<4;}
_0x29:
	CLT
	BLD  R2,4
	LDI  R30,LOW(0)
_0x1C5:
	OR   R5,R30
;     275 
;     276         if(adc5>bt5){s5=1;sensor=sensor|1<<5;}
	CALL SUBOPT_0x21
	CP   R30,R11
	BRSH _0x2B
	SET
	BLD  R2,5
	LDI  R30,LOW(32)
	RJMP _0x1C6
;     277         else {s5=0;sensor=sensor|0<<5;}
_0x2B:
	CLT
	BLD  R2,5
	LDI  R30,LOW(0)
_0x1C6:
	OR   R5,R30
;     278 
;     279         if(adc6>bt6){s6=1;sensor=sensor|1<<6;}
	CALL SUBOPT_0x22
	CP   R30,R10
	BRSH _0x2D
	SET
	BLD  R2,6
	LDI  R30,LOW(64)
	RJMP _0x1C7
;     280         else {s6=0;sensor=sensor|0<<6;}
_0x2D:
	CLT
	BLD  R2,6
	LDI  R30,LOW(0)
_0x1C7:
	OR   R5,R30
;     281 
;     282         if(adc7>bt7){s7=1;sensor=sensor|1<<7;}
	CALL SUBOPT_0x23
	CP   R30,R13
	BRSH _0x2F
	SET
	BLD  R2,7
	LDI  R30,LOW(128)
	RJMP _0x1C8
;     283         else {s7=0;sensor=sensor|0<<7;}
_0x2F:
	CLT
	BLD  R2,7
	LDI  R30,LOW(0)
_0x1C8:
	OR   R5,R30
;     284 }
	RET
;     285 
;     286 void tampil(unsigned char dat)
;     287 {
_tampil:
;     288     unsigned char data;
;     289 
;     290     data = dat / 100;
	ST   -Y,R17
;	dat -> Y+1
;	data -> R17
	LDD  R26,Y+1
	LDI  R30,LOW(100)
	CALL SUBOPT_0x24
;     291     data+=0x30;
;     292     lcd_putchar(data);
;     293 
;     294     dat%=100;
	LDI  R30,LOW(100)
	CALL __MODB21U
	STD  Y+1,R30
;     295     data = dat / 10;
	LDD  R26,Y+1
	LDI  R30,LOW(10)
	CALL SUBOPT_0x24
;     296     data+=0x30;
;     297     lcd_putchar(data);
;     298 
;     299     dat%=10;
	LDI  R30,LOW(10)
	CALL __MODB21U
	STD  Y+1,R30
;     300     data = dat + 0x30;
	SUBI R30,-LOW(48)
	MOV  R17,R30
;     301     lcd_putchar(data);
	ST   -Y,R17
	CALL _lcd_putchar
;     302 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;     303 
;     304 void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom )
;     305 {
_tulisKeEEPROM:
;     306         lcd_gotoxy(0,0);
;	NoMenu -> Y+2
;	NoSubMenu -> Y+1
;	var_in_eeprom -> Y+0
	CALL SUBOPT_0x25
;     307         lcd_putsf("Tulis ke EEPROM ");
	__POINTW1FN _0,107
	CALL SUBOPT_0x1
;     308         lcd_putsf("...             ");
	__POINTW1FN _0,124
	CALL SUBOPT_0x1
;     309         switch (NoMenu)
	LDD  R30,Y+2
;     310         {
;     311           case 1: // PID
	CPI  R30,LOW(0x1)
	BRNE _0x34
;     312                 switch (NoSubMenu)
	LDD  R30,Y+1
;     313                 {
;     314                   case 1: // Kp
	CPI  R30,LOW(0x1)
	BRNE _0x38
;     315                         Kp = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL __EEPROMWRB
;     316                         break;
	RJMP _0x37
;     317                   case 2: // Ki
_0x38:
	CPI  R30,LOW(0x2)
	BRNE _0x39
;     318                         Ki = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMWRB
;     319                         break;
	RJMP _0x37
;     320                   case 3: // Kd
_0x39:
	CPI  R30,LOW(0x3)
	BRNE _0x37
;     321                         Kd = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL __EEPROMWRB
;     322                         break;
;     323                 }
_0x37:
;     324                 break;
	RJMP _0x33
;     325           case 2: // Speed
_0x34:
	CPI  R30,LOW(0x2)
	BRNE _0x3B
;     326                 switch (NoSubMenu)
	LDD  R30,Y+1
;     327                 {
;     328                   case 1: // MAX
	CPI  R30,LOW(0x1)
	BRNE _0x3F
;     329                         MAXSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL __EEPROMWRB
;     330                         break;
	RJMP _0x3E
;     331                   case 2: // MIN
_0x3F:
	CPI  R30,LOW(0x2)
	BRNE _0x3E
;     332                         MINSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL __EEPROMWRB
;     333                         break;
;     334                 }
_0x3E:
;     335                 break;
	RJMP _0x33
;     336           case 3: // Warna Garis
_0x3B:
	CPI  R30,LOW(0x3)
	BRNE _0x41
;     337                 switch (NoSubMenu)
	LDD  R30,Y+1
;     338                 {
;     339                   case 1: // Warna
	CPI  R30,LOW(0x1)
	BRNE _0x45
;     340                         WarnaGaris = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMWRB
;     341                         break;
	RJMP _0x44
;     342                   case 2: // SensL
_0x45:
	CPI  R30,LOW(0x2)
	BRNE _0x44
;     343                         SensLine = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMWRB
;     344                         break;
;     345                 }
_0x44:
;     346                 break;
	RJMP _0x33
;     347           case 4: // Skenario
_0x41:
	CPI  R30,LOW(0x4)
	BRNE _0x33
;     348                 Skenario = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMWRB
;     349                 break;
;     350         }
_0x33:
;     351         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x4
;     352 }
	ADIW R28,3
	RET
;     353 
;     354 void setByte( byte NoMenu, byte NoSubMenu )
;     355 {
_setByte:
;     356         byte var_in_eeprom;
;     357         byte plus5 = 0;
;     358         char limitPilih = -1;
;     359 
;     360         lcd_clear();
	CALL __SAVELOCR4
;	NoMenu -> Y+5
;	NoSubMenu -> Y+4
;	var_in_eeprom -> R17
;	plus5 -> R16
;	limitPilih -> R19
	LDI  R16,0
	LDI  R19,255
	CALL SUBOPT_0x26
;     361         lcd_gotoxy(0, 0);
;     362         switch (NoMenu)
	LDD  R30,Y+5
;     363         {
;     364           case 1: // PID
	CPI  R30,LOW(0x1)
	BRNE _0x4B
;     365                 switch (NoSubMenu)
	LDD  R30,Y+4
;     366                 {
;     367                   case 1: // Kp
	CPI  R30,LOW(0x1)
	BRNE _0x4F
;     368                         lcd_putsf("Set Kp :        ");
	__POINTW1FN _0,141
	CALL SUBOPT_0x1
;     369                         var_in_eeprom = Kp;
	CALL SUBOPT_0x6
	RJMP _0x1C9
;     370                         break;
;     371                   case 2: // Ki
_0x4F:
	CPI  R30,LOW(0x2)
	BRNE _0x50
;     372                         lcd_putsf("Set Ki :        ");
	__POINTW1FN _0,158
	CALL SUBOPT_0x1
;     373                         var_in_eeprom = Ki;
	CALL SUBOPT_0x7
	RJMP _0x1C9
;     374                         break;
;     375                   case 3: // Kd
_0x50:
	CPI  R30,LOW(0x3)
	BRNE _0x4E
;     376                         lcd_putsf("Set Kd :        ");
	__POINTW1FN _0,175
	CALL SUBOPT_0x1
;     377                         var_in_eeprom = Kd;
	CALL SUBOPT_0x8
_0x1C9:
	MOV  R17,R30
;     378                         break;
;     379                 }
_0x4E:
;     380                 break;
	RJMP _0x4A
;     381           case 2: // Speed
_0x4B:
	CPI  R30,LOW(0x2)
	BRNE _0x52
;     382                 plus5 = 1;
	LDI  R16,LOW(1)
;     383                 switch (NoSubMenu)
	LDD  R30,Y+4
;     384                 {
;     385                   case 1: // MAX
	CPI  R30,LOW(0x1)
	BRNE _0x56
;     386                         lcd_putsf("Set MAX Speed : ");
	__POINTW1FN _0,192
	CALL SUBOPT_0x1
;     387                         var_in_eeprom = MAXSpeed;
	CALL SUBOPT_0x9
	RJMP _0x1CA
;     388                         break;
;     389                   case 2: // MIN
_0x56:
	CPI  R30,LOW(0x2)
	BRNE _0x55
;     390                         lcd_putsf("Set MIN Speed : ");
	__POINTW1FN _0,209
	CALL SUBOPT_0x1
;     391                         var_in_eeprom = MINSpeed;
	CALL SUBOPT_0xA
_0x1CA:
	MOV  R17,R30
;     392                         break;
;     393                 }
_0x55:
;     394                 break;
	RJMP _0x4A
;     395           case 3: // Warna Garis
_0x52:
	CPI  R30,LOW(0x3)
	BRNE _0x58
;     396                 switch (NoSubMenu)
	LDD  R30,Y+4
;     397                 {
;     398                   case 1: // Warna
	CPI  R30,LOW(0x1)
	BRNE _0x5C
;     399                         limitPilih = 1;
	LDI  R19,LOW(1)
;     400                         lcd_putsf("Warna Garis   : ");
	__POINTW1FN _0,226
	CALL SUBOPT_0x1
;     401                         var_in_eeprom = WarnaGaris;
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	RJMP _0x1CB
;     402                         break;
;     403                   case 2: // SensL
_0x5C:
	CPI  R30,LOW(0x2)
	BRNE _0x5B
;     404                         limitPilih = 3;
	LDI  R19,LOW(3)
;     405                         lcd_putsf("SensLine :      ");
	__POINTW1FN _0,243
	CALL SUBOPT_0x1
;     406                         var_in_eeprom = SensLine;
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
_0x1CB:
	MOV  R17,R30
;     407                         break;
;     408                 }
_0x5B:
;     409                 break;
	RJMP _0x4A
;     410           case 4: // Skenario
_0x58:
	CPI  R30,LOW(0x4)
	BRNE _0x4A
;     411                   lcd_putsf("Skenario :      ");
	__POINTW1FN _0,260
	CALL SUBOPT_0x1
;     412                   var_in_eeprom = Skenario;
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	MOV  R17,R30
;     413                   limitPilih = 8;
	LDI  R19,LOW(8)
;     414                   break;
;     415         }
_0x4A:
;     416 
;     417         while (sw_cancel)
_0x5F:
	SBIS 0x13,1
	RJMP _0x61
;     418         {
;     419                 delay_ms(250);
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x4
;     420                 lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
;     421                 tampil(var_in_eeprom);
	ST   -Y,R17
	CALL _tampil
;     422 
;     423                 if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x62
;     424                 {
;     425                         lcd_clear();
	CALL _lcd_clear
;     426                         tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R17
	CALL _tulisKeEEPROM
;     427                         goto exitSetByte;
	RJMP _0x63
;     428                 }
;     429                 if (!sw_down)
_0x62:
	SBIC 0x13,3
	RJMP _0x64
;     430                 {
;     431                         if ( plus5 )
	CPI  R16,0
	BREQ _0x65
;     432                                 if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x66
;     433                                         var_in_eeprom = 255;
	LDI  R17,LOW(255)
;     434                                 else
	RJMP _0x67
_0x66:
;     435                                         var_in_eeprom -= 5;
	SUBI R17,LOW(5)
;     436                         else
_0x67:
	RJMP _0x68
_0x65:
;     437                                 if ( !limitPilih )
	CPI  R19,0
	BRNE _0x69
;     438                                         var_in_eeprom--;
	RJMP _0x1CC
;     439                                 else
_0x69:
;     440                                 {
;     441                                         if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x6B
;     442                                           var_in_eeprom = limitPilih;
	MOV  R17,R19
;     443                                         else
	RJMP _0x6C
_0x6B:
;     444                                           var_in_eeprom--;
_0x1CC:
	SUBI R17,1
;     445                                 }
_0x6C:
_0x68:
;     446                 }
;     447                 if (!sw_up)
_0x64:
	SBIC 0x13,2
	RJMP _0x6D
;     448                 {
;     449                         if ( plus5 )
	CPI  R16,0
	BREQ _0x6E
;     450                                 if ( var_in_eeprom == 255 )
	CPI  R17,255
	BRNE _0x6F
;     451                                         var_in_eeprom = 0;
	LDI  R17,LOW(0)
;     452                                 else
	RJMP _0x70
_0x6F:
;     453                                         var_in_eeprom += 5;
	SUBI R17,-LOW(5)
;     454                         else
_0x70:
	RJMP _0x71
_0x6E:
;     455                                 if ( !limitPilih )
	CPI  R19,0
	BRNE _0x72
;     456                                         var_in_eeprom++;
	RJMP _0x1CD
;     457                                 else
_0x72:
;     458                                 {
;     459                                         if ( var_in_eeprom == limitPilih )
	CP   R19,R17
	BRNE _0x74
;     460                                           var_in_eeprom = 0;
	LDI  R17,LOW(0)
;     461                                         else
	RJMP _0x75
_0x74:
;     462                                           var_in_eeprom++;
_0x1CD:
	SUBI R17,-1
;     463                                 }
_0x75:
_0x71:
;     464                 }
;     465         }
_0x6D:
	RJMP _0x5F
_0x61:
;     466       exitSetByte:
_0x63:
;     467         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
;     468         lcd_clear();
	CALL _lcd_clear
;     469 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;     470 
;     471 void showMenu()
;     472 {
_showMenu:
;     473         //TIMSK = 0x00;
;     474         #asm("cli")
	cli
;     475         lcd_clear();
	CALL _lcd_clear
;     476     menu01:
_0x76:
;     477         delay_ms(225);   // bouncing sw
	CALL SUBOPT_0x27
;     478         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     479                 // 0123456789abcdef
;     480         lcd_putsf("  Set PID       ");
	__POINTW1FN _0,277
	CALL SUBOPT_0x1
;     481         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     482         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0,294
	CALL SUBOPT_0x1
;     483 
;     484         // kursor awal
;     485         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     486         lcd_putchar(0);
	CALL SUBOPT_0x28
;     487 
;     488         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x77
;     489         {
;     490                 delay_ms(225);
	CALL SUBOPT_0x27
;     491                 lcd_clear();
	CALL _lcd_clear
;     492                 kursorPID = 1;
	LDI  R30,LOW(1)
	STS  _kursorPID,R30
;     493                 goto setPID;
	RJMP _0x78
;     494         }
;     495         if (!sw_down)
_0x77:
	SBIC 0x13,3
	RJMP _0x79
;     496         {
;     497                 delay_ms(225);
	CALL SUBOPT_0x27
;     498                 goto menu02;
	RJMP _0x7A
;     499         }
;     500         if (!sw_up)
_0x79:
	SBIC 0x13,2
	RJMP _0x7B
;     501         {
;     502                 delay_ms(225);
	CALL SUBOPT_0x27
;     503                 lcd_clear();
	CALL _lcd_clear
;     504                 goto menu06;
	RJMP _0x7C
;     505         }
;     506 
;     507         goto menu01;
_0x7B:
	RJMP _0x76
;     508     menu02:
_0x7A:
;     509         delay_ms(225);
	CALL SUBOPT_0x27
;     510         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     511                  // 0123456789abcdef
;     512         lcd_putsf("  Set PID       ");
	__POINTW1FN _0,277
	CALL SUBOPT_0x1
;     513         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     514         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0,294
	CALL SUBOPT_0x1
;     515 
;     516         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     517         lcd_putchar(0);
	CALL SUBOPT_0x28
;     518 
;     519         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x7D
;     520         {
;     521                 delay_ms(225);
	CALL SUBOPT_0x27
;     522                 lcd_clear();
	CALL _lcd_clear
;     523                 kursorSpeed = 1;
	LDI  R30,LOW(1)
	STS  _kursorSpeed,R30
;     524                 goto setSpeed;
	RJMP _0x7E
;     525         }
;     526         if (!sw_up)
_0x7D:
	SBIC 0x13,2
	RJMP _0x7F
;     527         {
;     528                 delay_ms(225);
	CALL SUBOPT_0x27
;     529                 goto menu01;
	RJMP _0x76
;     530         }
;     531         if (!sw_down)
_0x7F:
	SBIC 0x13,3
	RJMP _0x80
;     532         {
;     533                 delay_ms(225);
	CALL SUBOPT_0x27
;     534                 lcd_clear();
	CALL _lcd_clear
;     535                 goto menu03;
	RJMP _0x81
;     536         }
;     537         goto menu02;
_0x80:
	RJMP _0x7A
;     538     menu03:
_0x81:
;     539         delay_ms(225);
	CALL SUBOPT_0x27
;     540         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     541                 // 0123456789abcdef
;     542         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0,311
	CALL SUBOPT_0x1
;     543         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     544         lcd_putsf("  Skenario      ");
	__POINTW1FN _0,328
	CALL SUBOPT_0x1
;     545 
;     546         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     547         lcd_putchar(0);
	CALL SUBOPT_0x28
;     548 
;     549         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x82
;     550         {
;     551                 delay_ms(225);
	CALL SUBOPT_0x27
;     552                 lcd_clear();
	CALL _lcd_clear
;     553                 kursorGaris = 1;
	LDI  R30,LOW(1)
	STS  _kursorGaris,R30
;     554                 goto setGaris;
	RJMP _0x83
;     555         }
;     556         if (!sw_up)
_0x82:
	SBIC 0x13,2
	RJMP _0x84
;     557         {
;     558                 delay_ms(225);
	CALL SUBOPT_0x27
;     559                 lcd_clear();
	CALL _lcd_clear
;     560                 goto menu02;
	RJMP _0x7A
;     561         }
;     562         if (!sw_down)
_0x84:
	SBIC 0x13,3
	RJMP _0x85
;     563         {
;     564                 delay_ms(225);
	CALL SUBOPT_0x27
;     565                 goto menu04;
	RJMP _0x86
;     566         }
;     567         goto menu03;
_0x85:
	RJMP _0x81
;     568     menu04:
_0x86:
;     569         delay_ms(225);
	CALL SUBOPT_0x27
;     570         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     571                 // 0123456789abcdef
;     572         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0,311
	CALL SUBOPT_0x1
;     573         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     574         lcd_putsf("  Skenario      ");
	__POINTW1FN _0,328
	CALL SUBOPT_0x1
;     575 
;     576         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     577         lcd_putchar(0);
	CALL SUBOPT_0x28
;     578 
;     579         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x87
;     580         {
;     581                 delay_ms(225);
	CALL SUBOPT_0x27
;     582                 lcd_clear();
	CALL _lcd_clear
;     583                 goto setSkenario;
	RJMP _0x88
;     584         }
;     585         if (!sw_up)
_0x87:
	SBIC 0x13,2
	RJMP _0x89
;     586         {
;     587                 delay_ms(225);
	CALL SUBOPT_0x27
;     588                 goto menu03;
	RJMP _0x81
;     589         }
;     590         if (!sw_down)
_0x89:
	SBIC 0x13,3
	RJMP _0x8A
;     591         {
;     592                 delay_ms(225);
	CALL SUBOPT_0x27
;     593                 lcd_clear();
	CALL _lcd_clear
;     594                 goto menu05;
	RJMP _0x8B
;     595         }
;     596         goto menu04;
_0x8A:
	RJMP _0x86
;     597     menu05:            // Bikin sendiri lhoo ^^d
_0x8B:
;     598         delay_ms(225);
	CALL SUBOPT_0x27
;     599         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     600         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0,345
	CALL SUBOPT_0x1
;     601         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     602         lcd_putsf("  Start!!      ");
	__POINTW1FN _0,365
	CALL SUBOPT_0x1
;     603 
;     604         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     605         lcd_putchar(0);
	CALL SUBOPT_0x28
;     606 
;     607         if  (!sw_ok)
	SBIC 0x13,0
	RJMP _0x8C
;     608         {
;     609             delay_ms(225);
	CALL SUBOPT_0x27
;     610             lcd_clear();
	CALL _lcd_clear
;     611             goto mode;
	RJMP _0x8D
;     612         }
;     613 
;     614         if  (!sw_up)
_0x8C:
	SBIC 0x13,2
	RJMP _0x8E
;     615         {
;     616             delay_ms(225);
	CALL SUBOPT_0x27
;     617             lcd_clear();
	CALL _lcd_clear
;     618             goto menu04;
	RJMP _0x86
;     619         }
;     620 
;     621         if  (!sw_down)
_0x8E:
	SBIC 0x13,3
	RJMP _0x8F
;     622         {
;     623             delay_ms(225);
	CALL SUBOPT_0x27
;     624             goto menu06;
	RJMP _0x7C
;     625         }
;     626 
;     627         goto menu05;
_0x8F:
	RJMP _0x8B
;     628     menu06:
_0x7C:
;     629         delay_ms(225);
	CALL SUBOPT_0x27
;     630         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     631         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0,345
	CALL SUBOPT_0x1
;     632         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     633         lcd_putsf("  Start!!      ");
	__POINTW1FN _0,365
	CALL SUBOPT_0x1
;     634 
;     635         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     636         lcd_putchar(0);
	CALL SUBOPT_0x28
;     637 
;     638         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x90
;     639         {
;     640                 delay_ms(225);
	CALL SUBOPT_0x27
;     641                 lcd_clear();
	CALL _lcd_clear
;     642                 goto startRobot;
	RJMP _0x91
;     643         }
;     644 
;     645         if (!sw_up)
_0x90:
	SBIC 0x13,2
	RJMP _0x92
;     646         {
;     647                 delay_ms(225);
	CALL SUBOPT_0x27
;     648                 goto menu05;
	RJMP _0x8B
;     649         }
;     650 
;     651         if (!sw_down)
_0x92:
	SBIC 0x13,3
	RJMP _0x93
;     652         {
;     653                 delay_ms(225);
	CALL SUBOPT_0x27
;     654                 lcd_clear();
	CALL _lcd_clear
;     655                 goto menu01;
	RJMP _0x76
;     656         }
;     657 
;     658         goto menu06;
_0x93:
	RJMP _0x7C
;     659 
;     660 
;     661     setPID:
_0x78:
;     662         delay_ms(225);
	CALL SUBOPT_0x27
;     663         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     664                 // 0123456789ABCDEF
;     665         lcd_putsf("  Kp   Ki   Kd  ");
	__POINTW1FN _0,381
	CALL SUBOPT_0x1
;     666         // lcd_putsf(" 250  200  300  ");
;     667         lcd_putchar(' ');
	CALL SUBOPT_0x29
;     668         tampil(Kp); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x29
;     669         tampil(Ki); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x29
;     670         tampil(Kd); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x8
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x29
;     671 
;     672         switch (kursorPID)
	LDS  R30,_kursorPID
;     673         {
;     674           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x97
;     675                 lcd_gotoxy(1,0); // kursor Kp
	LDI  R30,LOW(1)
	RJMP _0x1CE
;     676                 lcd_putchar(0);
;     677                 break;
;     678           case 2:
_0x97:
	CPI  R30,LOW(0x2)
	BRNE _0x98
;     679                 lcd_gotoxy(6,0); // kursor Ki
	LDI  R30,LOW(6)
	RJMP _0x1CE
;     680                 lcd_putchar(0);
;     681                 break;
;     682           case 3:
_0x98:
	CPI  R30,LOW(0x3)
	BRNE _0x96
;     683                 lcd_gotoxy(11,0); // kursor Kd
	LDI  R30,LOW(11)
_0x1CE:
	ST   -Y,R30
	CALL SUBOPT_0x2B
;     684                 lcd_putchar(0);
;     685                 break;
;     686         }
_0x96:
;     687 
;     688         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x9A
;     689         {
;     690                 delay_ms(225);
	CALL SUBOPT_0x27
;     691                 setByte( 1, kursorPID);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDS  R30,_kursorPID
	CALL SUBOPT_0x2C
;     692                 delay_ms(200);
;     693         }
;     694         if (!sw_up)
_0x9A:
	SBIC 0x13,2
	RJMP _0x9B
;     695         {
;     696                 delay_ms(225);
	CALL SUBOPT_0x27
;     697                 if (kursorPID == 3) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x3)
	BRNE _0x9C
;     698                         kursorPID = 1;
	LDI  R30,LOW(1)
	RJMP _0x1CF
;     699                 } else kursorPID++;
_0x9C:
	LDS  R30,_kursorPID
	SUBI R30,-LOW(1)
_0x1CF:
	STS  _kursorPID,R30
;     700         }
;     701         if (!sw_down)
_0x9B:
	SBIC 0x13,3
	RJMP _0x9E
;     702         {
;     703                 delay_ms(225);
	CALL SUBOPT_0x27
;     704                 if (kursorPID == 1) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x1)
	BRNE _0x9F
;     705                         kursorPID = 3;
	LDI  R30,LOW(3)
	RJMP _0x1D0
;     706                 } else kursorPID--;
_0x9F:
	LDS  R30,_kursorPID
	SUBI R30,LOW(1)
_0x1D0:
	STS  _kursorPID,R30
;     707         }
;     708 
;     709         if (!sw_cancel)
_0x9E:
	SBIC 0x13,1
	RJMP _0xA1
;     710         {
;     711                 delay_ms(225);
	CALL SUBOPT_0x27
;     712                 lcd_clear();
	CALL _lcd_clear
;     713                 goto menu01;
	RJMP _0x76
;     714         }
;     715 
;     716         goto setPID;
_0xA1:
	RJMP _0x78
;     717 
;     718     setSpeed:
_0x7E:
;     719         delay_ms(225);
	CALL SUBOPT_0x27
;     720         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     721                 // 0123456789ABCDEF
;     722         lcd_putsf("   MAX    MIN   ");
	__POINTW1FN _0,398
	CALL SUBOPT_0x1
;     723         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
;     724 
;     725         //lcd_putsf("   250    200   ");
;     726         tampil(MAXSpeed);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x2A
;     727         lcd_putchar(' '); lcd_putchar(' ');lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
;     728         tampil(MINSpeed);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2A
;     729         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
;     730 
;     731         switch (kursorSpeed)
	LDS  R30,_kursorSpeed
;     732         {
;     733           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0xA5
;     734                 lcd_gotoxy(2,0); // kursor MAX
	LDI  R30,LOW(2)
	RJMP _0x1D1
;     735                 lcd_putchar(0);
;     736                 break;
;     737           case 2:
_0xA5:
	CPI  R30,LOW(0x2)
	BRNE _0xA4
;     738                 lcd_gotoxy(9,0); // kursor MIN
	LDI  R30,LOW(9)
_0x1D1:
	ST   -Y,R30
	CALL SUBOPT_0x2B
;     739                 lcd_putchar(0);
;     740                 break;
;     741         }
_0xA4:
;     742 
;     743         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xA7
;     744         {
;     745                 delay_ms(225);
	CALL SUBOPT_0x27
;     746                 setByte( 2, kursorSpeed);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R30,_kursorSpeed
	CALL SUBOPT_0x2C
;     747                 delay_ms(200);
;     748         }
;     749         if (!sw_up)
_0xA7:
	SBIC 0x13,2
	RJMP _0xA8
;     750         {
;     751                 delay_ms(225);
	CALL SUBOPT_0x27
;     752                 if (kursorSpeed == 2)
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x2)
	BRNE _0xA9
;     753                 {
;     754                         kursorSpeed = 1;
	LDI  R30,LOW(1)
	RJMP _0x1D2
;     755                 } else kursorSpeed++;
_0xA9:
	LDS  R30,_kursorSpeed
	SUBI R30,-LOW(1)
_0x1D2:
	STS  _kursorSpeed,R30
;     756         }
;     757         if (!sw_down)
_0xA8:
	SBIC 0x13,3
	RJMP _0xAB
;     758         {
;     759                 delay_ms(225);
	CALL SUBOPT_0x27
;     760                 if (kursorSpeed == 1)
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x1)
	BRNE _0xAC
;     761                 {
;     762                         kursorSpeed = 2;
	LDI  R30,LOW(2)
	RJMP _0x1D3
;     763                 } else kursorSpeed--;
_0xAC:
	LDS  R30,_kursorSpeed
	SUBI R30,LOW(1)
_0x1D3:
	STS  _kursorSpeed,R30
;     764         }
;     765 
;     766         if (!sw_cancel)
_0xAB:
	SBIC 0x13,1
	RJMP _0xAE
;     767         {
;     768                 delay_ms(225);
	CALL SUBOPT_0x27
;     769                 lcd_clear();
	CALL _lcd_clear
;     770                 goto menu02;
	RJMP _0x7A
;     771         }
;     772 
;     773         goto setSpeed;
_0xAE:
	RJMP _0x7E
;     774 
;     775      setGaris: // not yet
_0x83:
;     776         delay_ms(225);
	CALL SUBOPT_0x27
;     777         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     778                 // 0123456789ABCDEF
;     779         if ( WarnaGaris == 1 )
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0xAF
;     780                 lcd_putsf("  WARNA : Putih ");
	__POINTW1FN _0,415
	RJMP _0x1D4
;     781         else
_0xAF:
;     782                 lcd_putsf("  WARNA : Hitam ");
	__POINTW1FN _0,432
_0x1D4:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
;     783 
;     784         //lcd_putsf("  LEBAR: 1.5 cm ");
;     785         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     786         lcd_putsf("  SensL :        ");
	__POINTW1FN _0,449
	CALL SUBOPT_0x1
;     787         lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x2D
;     788         tampil( SensLine );
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _tampil
;     789 
;     790         switch (kursorGaris)
	LDS  R30,_kursorGaris
;     791         {
;     792           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0xB4
;     793                 lcd_gotoxy(0,0); // kursor Warna
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x1D5
;     794                 lcd_putchar(0);
;     795                 break;
;     796           case 2:
_0xB4:
	CPI  R30,LOW(0x2)
	BRNE _0xB3
;     797                 lcd_gotoxy(0,1); // kursor SensL
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x1D5:
	ST   -Y,R30
	CALL _lcd_gotoxy
;     798                 lcd_putchar(0);
	CALL SUBOPT_0x28
;     799                 break;
;     800         }
_0xB3:
;     801 
;     802         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xB6
;     803         {
;     804                 delay_ms(225);
	CALL SUBOPT_0x27
;     805                 setByte( 3, kursorGaris);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDS  R30,_kursorGaris
	CALL SUBOPT_0x2C
;     806                 delay_ms(200);
;     807         }
;     808         if (!sw_up)
_0xB6:
	SBIC 0x13,2
	RJMP _0xB7
;     809         {
;     810                 delay_ms(225);
	CALL SUBOPT_0x27
;     811                 if (kursorGaris == 2)
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x2)
	BRNE _0xB8
;     812                 {
;     813                         kursorGaris = 1;
	LDI  R30,LOW(1)
	RJMP _0x1D6
;     814                 } else kursorGaris++;
_0xB8:
	LDS  R30,_kursorGaris
	SUBI R30,-LOW(1)
_0x1D6:
	STS  _kursorGaris,R30
;     815         }
;     816         if (!sw_down)
_0xB7:
	SBIC 0x13,3
	RJMP _0xBA
;     817         {
;     818                 delay_ms(225);
	CALL SUBOPT_0x27
;     819                 if (kursorGaris == 1)
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x1)
	BRNE _0xBB
;     820                 {
;     821                         kursorGaris = 2;
	LDI  R30,LOW(2)
	RJMP _0x1D7
;     822                 } else kursorGaris--;
_0xBB:
	LDS  R30,_kursorGaris
	SUBI R30,LOW(1)
_0x1D7:
	STS  _kursorGaris,R30
;     823         }
;     824 
;     825         if (!sw_cancel)
_0xBA:
	SBIC 0x13,1
	RJMP _0xBD
;     826         {
;     827                 delay_ms(225);
	CALL SUBOPT_0x27
;     828                 lcd_clear();
	CALL _lcd_clear
;     829                 goto menu03;
	RJMP _0x81
;     830         }
;     831 
;     832         goto setGaris;
_0xBD:
	RJMP _0x83
;     833 
;     834      setSkenario:
_0x88:
;     835         delay_ms(225);
	CALL SUBOPT_0x27
;     836         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     837                 // 0123456789ABCDEF
;     838         lcd_putsf("Sken. yg  dpake:");
	__POINTW1FN _0,467
	CALL SUBOPT_0x1
;     839         lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
;     840         tampil( Skenario );
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _tampil
;     841 
;     842         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xBE
;     843         {
;     844                 delay_ms(225);
	CALL SUBOPT_0x27
;     845                 setByte( 4, 0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2C
;     846                 delay_ms(200);
;     847         }
;     848 
;     849         if (!sw_cancel)
_0xBE:
	SBIC 0x13,1
	RJMP _0xBF
;     850         {
;     851                 delay_ms(225);
	CALL SUBOPT_0x27
;     852                 lcd_clear();
	CALL _lcd_clear
;     853                 goto menu04;
	RJMP _0x86
;     854         }
;     855 
;     856         goto setSkenario;
_0xBF:
	RJMP _0x88
;     857 
;     858      mode:
_0x8D:
;     859         delay_ms(125);
	CALL SUBOPT_0xD
;     860         if  (!sw_up)
	SBIC 0x13,2
	RJMP _0xC0
;     861         {
;     862             delay_ms(225);
	CALL SUBOPT_0x27
;     863             if (Mode==6)
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x6)
	BRNE _0xC1
;     864             {
;     865                 Mode=1;
	LDI  R30,LOW(1)
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMWRB
;     866             }
;     867 
;     868             else Mode++;
	RJMP _0xC2
_0xC1:
	CALL SUBOPT_0x2E
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
;     869 
;     870             goto nomorMode;
_0xC2:
	RJMP _0xC3
;     871         }
;     872 
;     873         if  (!sw_down)
_0xC0:
	SBIC 0x13,3
	RJMP _0xC4
;     874         {
;     875             delay_ms(225);
	CALL SUBOPT_0x27
;     876             if  (Mode==1)
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x1)
	BRNE _0xC5
;     877             {
;     878                 Mode=6;
	LDI  R30,LOW(6)
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMWRB
;     879             }
;     880 
;     881             else Mode--;
	RJMP _0xC6
_0xC5:
	CALL SUBOPT_0x2E
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
;     882 
;     883             goto nomorMode;
_0xC6:
;     884         }
;     885 
;     886         nomorMode:
_0xC4:
_0xC3:
;     887             if (Mode==1)
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x1)
	BRNE _0xC7
;     888             {
;     889                 lcd_clear();
	CALL SUBOPT_0x26
;     890                 lcd_gotoxy(0,0);
;     891                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     892                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     893                 lcd_putsf(" 1.Lihat ADC");
	__POINTW1FN _0,501
	CALL SUBOPT_0x1
;     894             }
;     895 
;     896             if  (Mode==2)
_0xC7:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x2)
	BRNE _0xC8
;     897             {
;     898                 lcd_clear();
	CALL SUBOPT_0x26
;     899                 lcd_gotoxy(0,0);
;     900                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     901                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     902                 lcd_putsf(" 2.Test Mode");
	__POINTW1FN _0,514
	CALL SUBOPT_0x1
;     903             }
;     904 
;     905             if  (Mode==3)
_0xC8:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x3)
	BRNE _0xC9
;     906             {
;     907                 lcd_clear();
	CALL SUBOPT_0x26
;     908                 lcd_gotoxy(0,0);
;     909                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     910                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     911                 lcd_putsf(" 3.Cek Sensor ");
	__POINTW1FN _0,527
	CALL SUBOPT_0x1
;     912             }
;     913 
;     914             if  (Mode==4)
_0xC9:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x4)
	BRNE _0xCA
;     915             {
;     916                 lcd_clear();
	CALL SUBOPT_0x26
;     917                 lcd_gotoxy(0,0);
;     918                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     919                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     920                 lcd_putsf(" 4.Auto Tune 1-1");
	__POINTW1FN _0,542
	CALL SUBOPT_0x1
;     921             }
;     922 
;     923              if  (Mode==5)
_0xCA:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x5)
	BRNE _0xCB
;     924             {
;     925                 lcd_clear();
	CALL SUBOPT_0x26
;     926                 lcd_gotoxy(0,0);
;     927                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     928                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     929                 lcd_putsf(" 5.Auto Tune ");
	__POINTW1FN _0,559
	CALL SUBOPT_0x1
;     930             }
;     931 
;     932             if  (Mode==6)
_0xCB:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x6)
	BRNE _0xCC
;     933             {
;     934                 lcd_clear();
	CALL SUBOPT_0x26
;     935                 lcd_gotoxy(0,0);
;     936                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     937                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     938                 lcd_putsf(" 6.Cek PWM Aktif");
	__POINTW1FN _0,573
	CALL SUBOPT_0x1
;     939             }
;     940 
;     941         if  (!sw_ok)
_0xCC:
	SBIC 0x13,0
	RJMP _0xCD
;     942         {
;     943             delay_ms(225);
	CALL SUBOPT_0x27
;     944             switch  (Mode)
	CALL SUBOPT_0x2E
;     945             {
;     946                 case 1:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0xD1
;     947                 {
;     948                     for(;;)
_0xD3:
;     949                     {
;     950                         lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x30
;     951                         sprintf(lcd,"  %d %d %d %d",read_adc(3),read_adc(2),read_adc(1),read_adc(0));
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
;     952                         lcd_puts(lcd);
	CALL _lcd_puts
;     953                         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;     954                         sprintf(lcd,"%d %d %d %d",read_adc(7),read_adc(6),read_adc(5),read_adc(4));
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
;     955                         lcd_puts(lcd);
	CALL _lcd_puts
;     956                         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
;     957                         lcd_clear();
	CALL _lcd_clear
;     958                     }
	RJMP _0xD3
;     959                 }
;     960                 break;
;     961 
;     962                 case 2:
_0xD1:
	CPI  R30,LOW(0x2)
	BRNE _0xD5
;     963                 {
;     964                     cek_sensor();
	RCALL _cek_sensor
;     965                 }
;     966                 break;
	RJMP _0xD0
;     967 
;     968                 case 3:
_0xD5:
	CPI  R30,LOW(0x3)
	BRNE _0xD6
;     969                 {
;     970                     cek_sensor();
	RCALL _cek_sensor
;     971                 }
;     972                 break;
	RJMP _0xD0
;     973 
;     974                 case 4:
_0xD6:
	CPI  R30,LOW(0x4)
	BRNE _0xD7
;     975                 {
;     976                     tune_batas();
	RCALL _tune_batas
;     977 
;     978                 }
;     979                 break;
	RJMP _0xD0
;     980 
;     981                 case 5:
_0xD7:
	CPI  R30,LOW(0x5)
	BRNE _0xD8
;     982                 {
;     983                     auto_scan();
	RCALL _auto_scan
;     984                     goto menu01;
	RJMP _0x76
;     985                 }
;     986                 break;
;     987 
;     988                 case 6:
_0xD8:
	CPI  R30,LOW(0x6)
	BRNE _0xD0
;     989                 {
;     990                     pemercepat();
	CALL _pemercepat
;     991                     pelambat();
	CALL _pelambat
;     992                     goto menu01;
	RJMP _0x76
;     993                 }
;     994                 break;
;     995             }
_0xD0:
;     996         }
;     997 
;     998         if  (!sw_cancel)
_0xCD:
	SBIC 0x13,1
	RJMP _0xDA
;     999         {
;    1000             lcd_clear();
	CALL _lcd_clear
;    1001             goto menu05;
	RJMP _0x8B
;    1002         }
;    1003 
;    1004         goto mode;
_0xDA:
	RJMP _0x8D
;    1005 
;    1006      startRobot:
_0x91:
;    1007         //TIMSK = 0x01;
;    1008         #asm("sei")
	sei
;    1009         lcd_clear();
	CALL _lcd_clear
;    1010 }
	RET
;    1011 
;    1012 void displaySensorBit()
;    1013 {
_displaySensorBit:
;    1014     baca_sensor();
	CALL _baca_sensor
;    1015     lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2D
;    1016     if (s7) lcd_putchar('1');
	SBRS R2,7
	RJMP _0xDB
	LDI  R30,LOW(49)
	RJMP _0x1D8
;    1017     else    lcd_putchar('0');
_0xDB:
	LDI  R30,LOW(48)
_0x1D8:
	ST   -Y,R30
	CALL _lcd_putchar
;    1018     if (s6) lcd_putchar('1');
	SBRS R2,6
	RJMP _0xDD
	LDI  R30,LOW(49)
	RJMP _0x1D9
;    1019     else    lcd_putchar('0');
_0xDD:
	LDI  R30,LOW(48)
_0x1D9:
	ST   -Y,R30
	CALL _lcd_putchar
;    1020     if (s5) lcd_putchar('1');
	SBRS R2,5
	RJMP _0xDF
	LDI  R30,LOW(49)
	RJMP _0x1DA
;    1021     else    lcd_putchar('0');
_0xDF:
	LDI  R30,LOW(48)
_0x1DA:
	ST   -Y,R30
	CALL _lcd_putchar
;    1022     if (s4) lcd_putchar('1');
	SBRS R2,4
	RJMP _0xE1
	LDI  R30,LOW(49)
	RJMP _0x1DB
;    1023     else    lcd_putchar('0');
_0xE1:
	LDI  R30,LOW(48)
_0x1DB:
	ST   -Y,R30
	CALL _lcd_putchar
;    1024     if (s3) lcd_putchar('1');
	SBRS R2,3
	RJMP _0xE3
	LDI  R30,LOW(49)
	RJMP _0x1DC
;    1025     else    lcd_putchar('0');
_0xE3:
	LDI  R30,LOW(48)
_0x1DC:
	ST   -Y,R30
	CALL _lcd_putchar
;    1026     if (s2) lcd_putchar('1');
	SBRS R2,2
	RJMP _0xE5
	LDI  R30,LOW(49)
	RJMP _0x1DD
;    1027     else    lcd_putchar('0');
_0xE5:
	LDI  R30,LOW(48)
_0x1DD:
	ST   -Y,R30
	CALL _lcd_putchar
;    1028     if (s1) lcd_putchar('1');
	SBRS R2,1
	RJMP _0xE7
	LDI  R30,LOW(49)
	RJMP _0x1DE
;    1029     else    lcd_putchar('0');
_0xE7:
	LDI  R30,LOW(48)
_0x1DE:
	ST   -Y,R30
	CALL _lcd_putchar
;    1030     if (s0) lcd_putchar('1');
	SBRS R2,0
	RJMP _0xE9
	LDI  R30,LOW(49)
	RJMP _0x1DF
;    1031     else    lcd_putchar('0');
_0xE9:
	LDI  R30,LOW(48)
_0x1DF:
	ST   -Y,R30
	CALL _lcd_putchar
;    1032 }
	RET
;    1033 
;    1034 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1035 {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    1036         xcount++;
	LDS  R30,_xcount
	SUBI R30,-LOW(1)
	STS  _xcount,R30
;    1037         if(xcount<=lpwm)Enki=1; // PORTC.1 = 1;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x34
	BRLT _0xEB
	SBI  0x12,4
;    1038         else Enki=0;  // PORTC.1 = 0;
	RJMP _0xEC
_0xEB:
	CBI  0x12,4
;    1039         if(xcount<=rpwm)Enka=1;
_0xEC:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x34
	BRLT _0xED
	SBI  0x12,5
;    1040         else Enka=0;
	RJMP _0xEE
_0xED:
	CBI  0x12,5
;    1041         TCNT0=0xFF;
_0xEE:
	LDI  R30,LOW(255)
	OUT  0x32,R30
;    1042 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;    1043 
;    1044 void maju(){kaplus=1;kamin=0;kirplus=1;kirmin=0;}
_maju:
	SBI  0x12,1
	CBI  0x12,0
	SBI  0x12,6
	CBI  0x12,3
	RET
;    1045 
;    1046 void mundur(){kaplus=0;kamin=1;kirplus=0;kirmin=1;}
_mundur:
	CBI  0x12,1
	SBI  0x12,0
	CBI  0x12,6
	SBI  0x12,3
	RET
;    1047 
;    1048 void bkan(){kaplus=0;kamin=0;kirplus=1;kirmin=0;}
_bkan:
	CBI  0x12,1
	CBI  0x12,0
	SBI  0x12,6
	CBI  0x12,3
	RET
;    1049 
;    1050 void bkir(){kaplus=1;kamin=0;kirplus=0;kirmin=0;}
_bkir:
	SBI  0x12,1
	CBI  0x12,0
	CBI  0x12,6
	CBI  0x12,3
	RET
;    1051 
;    1052 void rotkan(){kaplus=0;kamin=1;kirplus=1;kirmin=0;}
_rotkan:
	CBI  0x12,1
	SBI  0x12,0
	SBI  0x12,6
	CBI  0x12,3
	RET
;    1053 
;    1054 void rotkir(){kaplus=1;kamin=0;kirplus=0;kirmin=1;}
_rotkir:
	SBI  0x12,1
	CBI  0x12,0
	CBI  0x12,6
	SBI  0x12,3
	RET
;    1055 
;    1056 void stop(){ kaplus=0;kamin=0;kirplus=0;kirmin=0; }
_stop:
	CBI  0x12,1
	CBI  0x12,0
	CBI  0x12,6
	CBI  0x12,3
	RET
;    1057 
;    1058 void cek_sensor()
;    1059 {
_cek_sensor:
;    1060         int t;
;    1061 
;    1062         baca_sensor();
	ST   -Y,R17
	ST   -Y,R16
;	t -> R16,R17
	CALL _baca_sensor
;    1063         lcd_clear();
	CALL _lcd_clear
;    1064         delay_ms(125);
	CALL SUBOPT_0x0
;    1065                 // wait 125ms
;    1066         lcd_gotoxy(0,0);
;    1067                 //0123456789abcdef
;    1068         lcd_putsf(" Test:Sensor    ");
	__POINTW1FN _0,604
	CALL SUBOPT_0x1
;    1069 
;    1070         for (t=0; t<30000; t++) {displaySensorBit();}
	__GETWRN 16,17,0
_0xF0:
	__CPWRN 16,17,30000
	BRGE _0xF1
	CALL _displaySensorBit
	__ADDWRN 16,17,1
	RJMP _0xF0
_0xF1:
;    1071 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1072 
;    1073 void tune_batas()
;    1074 {
_tune_batas:
;    1075     lcd_clear();
	CALL SUBOPT_0x26
;    1076     lcd_gotoxy(0,0);
;    1077     lcd_putsf(" Cek Memory ?");
	__POINTW1FN _0,621
	CALL SUBOPT_0x1
;    1078     lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;    1079     lcd_putsf(" Y / N ");
	__POINTW1FN _0,635
	CALL SUBOPT_0x1
;    1080     for(;;)
_0xF3:
;    1081     {
;    1082         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0xF5
;    1083         {
;    1084                 delay_ms(200);
	CALL SUBOPT_0x5
;    1085                 lcd_clear();
	CALL SUBOPT_0x26
;    1086                 lcd_gotoxy(0,0);
;    1087                 sprintf(lcd," %d %d %d %d %d %d %d %d",bt0, bt1, bt2, bt3, bt4, bt5, bt6, bt7);
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
;    1088                 lcd_puts(lcd);
	CALL _lcd_puts
;    1089                 delay_ms(2000);
	LDI  R30,LOW(2000)
	LDI  R31,HIGH(2000)
	CALL SUBOPT_0x4
;    1090         }
;    1091 
;    1092         if(!sw_cancel)
_0xF5:
	SBIS 0x13,1
;    1093         {
;    1094                 break;
	RJMP _0xF4
;    1095         }
;    1096     }
	RJMP _0xF3
_0xF4:
;    1097     for(;;)
_0xF8:
;    1098     {
;    1099         read_adc(0);
	CALL SUBOPT_0x14
;    1100         if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_bb0
	CP   R26,R30
	BRSH _0xFA
	CALL SUBOPT_0x14
	STS  _bb0,R30
;    1101         if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
_0xFA:
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_ba0
	CP   R30,R26
	BRSH _0xFB
	CALL SUBOPT_0x14
	STS  _ba0,R30
;    1102 
;    1103         bt0=((bb0+ba0)/2);
_0xFB:
	CALL SUBOPT_0x3E
;    1104 
;    1105         lcd_clear();
	CALL SUBOPT_0x3F
;    1106         lcd_gotoxy(1,0);
;    1107         lcd_putsf(" bb0  ba0  bt0");
	__POINTW1FN _0,668
	CALL SUBOPT_0x1
;    1108         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1109         sprintf(lcd," %d  %d  %d",bb0,ba0,bt0);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb0
	CALL SUBOPT_0x32
	LDS  R30,_ba0
	CALL SUBOPT_0x32
	CALL SUBOPT_0x35
	CALL SUBOPT_0x41
;    1110         lcd_puts(lcd);
	CALL SUBOPT_0x42
;    1111         delay_ms(50);
;    1112 
;    1113         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0xFC
;    1114         {
;    1115             delay_ms(125);
	CALL SUBOPT_0xD
;    1116             goto sensor1;
	RJMP _0xFD
;    1117         }
;    1118     }
_0xFC:
	RJMP _0xF8
;    1119     sensor1:
_0xFD:
;    1120     for(;;)
_0xFF:
;    1121     {
;    1122         read_adc(1);
	CALL SUBOPT_0x15
;    1123         if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_bb1
	CP   R26,R30
	BRSH _0x101
	CALL SUBOPT_0x15
	STS  _bb1,R30
;    1124         if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
_0x101:
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_ba1
	CP   R30,R26
	BRSH _0x102
	CALL SUBOPT_0x15
	STS  _ba1,R30
;    1125 
;    1126         bt1=((bb1+ba1)/2);
_0x102:
	CALL SUBOPT_0x43
;    1127 
;    1128         lcd_clear();
	CALL SUBOPT_0x3F
;    1129         lcd_gotoxy(1,0);
;    1130         lcd_putsf(" bb1  ba1  bt1");
	__POINTW1FN _0,695
	CALL SUBOPT_0x1
;    1131         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1132         sprintf(lcd," %d  %d  %d",bb1,ba1,bt1);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb1
	CALL SUBOPT_0x32
	LDS  R30,_ba1
	CALL SUBOPT_0x32
	CALL SUBOPT_0x36
	CALL SUBOPT_0x41
;    1133         lcd_puts(lcd);
	CALL SUBOPT_0x42
;    1134         delay_ms(50);
;    1135 
;    1136         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x103
;    1137         {
;    1138             delay_ms(150);
	CALL SUBOPT_0x44
;    1139             goto sensor2;
	RJMP _0x104
;    1140         }
;    1141     }
_0x103:
	RJMP _0xFF
;    1142     sensor2:
_0x104:
;    1143     for(;;)
_0x106:
;    1144     {
;    1145         read_adc(2);
	CALL SUBOPT_0x16
;    1146         if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_bb2
	CP   R26,R30
	BRSH _0x108
	CALL SUBOPT_0x16
	STS  _bb2,R30
;    1147         if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
_0x108:
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_ba2
	CP   R30,R26
	BRSH _0x109
	CALL SUBOPT_0x16
	STS  _ba2,R30
;    1148 
;    1149         bt2=((bb2+ba2)/2);
_0x109:
	CALL SUBOPT_0x45
;    1150 
;    1151         lcd_clear();
	CALL SUBOPT_0x3F
;    1152         lcd_gotoxy(1,0);
;    1153         lcd_putsf(" bb2  ba2  bt2");
	__POINTW1FN _0,710
	CALL SUBOPT_0x1
;    1154         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1155         sprintf(lcd," %d  %d  %d",bb2,ba2,bt2);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb2
	CALL SUBOPT_0x32
	LDS  R30,_ba2
	CALL SUBOPT_0x32
	CALL SUBOPT_0x37
	CALL SUBOPT_0x41
;    1156         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1157         delay_ms(10);
;    1158 
;    1159         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x10A
;    1160         {
;    1161             delay_ms(150);
	CALL SUBOPT_0x44
;    1162             goto sensor3;
	RJMP _0x10B
;    1163         }
;    1164     }
_0x10A:
	RJMP _0x106
;    1165     sensor3:
_0x10B:
;    1166     for(;;)
_0x10D:
;    1167     {
;    1168         read_adc(3);
	CALL SUBOPT_0x17
;    1169         if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_bb3
	CP   R26,R30
	BRSH _0x10F
	CALL SUBOPT_0x17
	STS  _bb3,R30
;    1170         if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
_0x10F:
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_ba3
	CP   R30,R26
	BRSH _0x110
	CALL SUBOPT_0x17
	STS  _ba3,R30
;    1171 
;    1172         bt3=((bb3+ba3)/2);
_0x110:
	CALL SUBOPT_0x47
;    1173 
;    1174         lcd_clear();
	CALL SUBOPT_0x3F
;    1175         lcd_gotoxy(1,0);
;    1176         lcd_putsf(" bb3  ba3  bt3");
	__POINTW1FN _0,725
	CALL SUBOPT_0x1
;    1177         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1178         sprintf(lcd," %d  %d  %d",bb3,ba3,bt3);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb3
	CALL SUBOPT_0x32
	LDS  R30,_ba3
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
	CALL SUBOPT_0x41
;    1179         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1180         delay_ms(10);
;    1181 
;    1182         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x111
;    1183         {
;    1184             delay_ms(150);
	CALL SUBOPT_0x44
;    1185             goto sensor4;
	RJMP _0x112
;    1186         }
;    1187     }
_0x111:
	RJMP _0x10D
;    1188     sensor4:
_0x112:
;    1189     for(;;)
_0x114:
;    1190     {
;    1191         read_adc(4);
	CALL SUBOPT_0x18
;    1192         if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_bb4
	CP   R26,R30
	BRSH _0x116
	CALL SUBOPT_0x18
	STS  _bb4,R30
;    1193         if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
_0x116:
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_ba4
	CP   R30,R26
	BRSH _0x117
	CALL SUBOPT_0x18
	STS  _ba4,R30
;    1194 
;    1195         bt4=((bb4+ba4)/2);
_0x117:
	CALL SUBOPT_0x48
;    1196 
;    1197         lcd_clear();
	CALL SUBOPT_0x3F
;    1198         lcd_gotoxy(1,0);
;    1199         lcd_putsf(" bb4  ba4  bt4");
	__POINTW1FN _0,740
	CALL SUBOPT_0x1
;    1200         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1201         sprintf(lcd," %d  %d  %d",bb4,ba4,bt4);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb4
	CALL SUBOPT_0x32
	LDS  R30,_ba4
	CALL SUBOPT_0x32
	CALL SUBOPT_0x39
	CALL SUBOPT_0x41
;    1202         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1203         delay_ms(10);
;    1204 
;    1205         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x118
;    1206         {
;    1207             delay_ms(150);
	CALL SUBOPT_0x44
;    1208             goto sensor5;
	RJMP _0x119
;    1209         }
;    1210     }
_0x118:
	RJMP _0x114
;    1211     sensor5:
_0x119:
;    1212     for(;;)
_0x11B:
;    1213     {
;    1214         read_adc(5);
	CALL SUBOPT_0x19
;    1215         if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_bb5
	CP   R26,R30
	BRSH _0x11D
	CALL SUBOPT_0x19
	STS  _bb5,R30
;    1216         if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
_0x11D:
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_ba5
	CP   R30,R26
	BRSH _0x11E
	CALL SUBOPT_0x19
	STS  _ba5,R30
;    1217 
;    1218         bt5=((bb5+ba5)/2);
_0x11E:
	CALL SUBOPT_0x49
;    1219 
;    1220         lcd_clear();
	CALL SUBOPT_0x3F
;    1221         lcd_gotoxy(1,0);
;    1222         lcd_putsf(" bb5  ba5  bt5");
	__POINTW1FN _0,755
	CALL SUBOPT_0x1
;    1223         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1224         sprintf(lcd," %d  %d  %d",bb5,ba5,bt5);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb5
	CALL SUBOPT_0x32
	LDS  R30,_ba5
	CALL SUBOPT_0x32
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x41
;    1225         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1226         delay_ms(10);
;    1227 
;    1228         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x11F
;    1229         {
;    1230             delay_ms(150);
	CALL SUBOPT_0x44
;    1231             goto sensor6;
	RJMP _0x120
;    1232         }
;    1233     }
_0x11F:
	RJMP _0x11B
;    1234     sensor6:
_0x120:
;    1235     for(;;)
_0x122:
;    1236     {
;    1237         read_adc(06);
	CALL SUBOPT_0x1A
;    1238         if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_bb6
	CP   R26,R30
	BRSH _0x124
	CALL SUBOPT_0x1A
	STS  _bb6,R30
;    1239         if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
_0x124:
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_ba6
	CP   R30,R26
	BRSH _0x125
	CALL SUBOPT_0x1A
	STS  _ba6,R30
;    1240 
;    1241         bt6=((bb6+ba6)/2);
_0x125:
	CALL SUBOPT_0x4A
;    1242 
;    1243         lcd_clear();
	CALL SUBOPT_0x3F
;    1244         lcd_gotoxy(1,0);
;    1245         lcd_putsf(" bb6  ba6  bt6");
	__POINTW1FN _0,770
	CALL SUBOPT_0x1
;    1246         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1247         sprintf(lcd," %d  %d  %d",bb6,ba6,bt6);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb6
	CALL SUBOPT_0x32
	LDS  R30,_ba6
	CALL SUBOPT_0x32
	CALL SUBOPT_0x3B
	CALL SUBOPT_0x41
;    1248         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1249         delay_ms(10);
;    1250 
;    1251         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x126
;    1252         {
;    1253             delay_ms(150);
	CALL SUBOPT_0x44
;    1254             goto sensor7;
	RJMP _0x127
;    1255         }
;    1256     }
_0x126:
	RJMP _0x122
;    1257     sensor7:
_0x127:
;    1258     for(;;)
_0x129:
;    1259     {
;    1260         read_adc(7);
	CALL SUBOPT_0x1B
;    1261         if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
	CALL SUBOPT_0x1B
	MOV  R26,R30
	LDS  R30,_bb7
	CP   R26,R30
	BRSH _0x12B
	CALL SUBOPT_0x1B
	STS  _bb7,R30
;    1262         if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
_0x12B:
	CALL SUBOPT_0x1B
	CP   R12,R30
	BRSH _0x12C
	CALL SUBOPT_0x1B
	MOV  R12,R30
;    1263 
;    1264         bt7=((bb7+ba7)/2);
_0x12C:
	CALL SUBOPT_0x4B
;    1265 
;    1266         lcd_clear();
;    1267         lcd_gotoxy(1,0);
;    1268         lcd_putsf(" bb7  ba7  bt7");
	__POINTW1FN _0,785
	CALL SUBOPT_0x1
;    1269         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1270         sprintf(lcd," %d  %d  %d",bb7,ba7,bt7);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x40
	LDS  R30,_bb7
	CALL SUBOPT_0x32
	MOV  R30,R12
	CALL SUBOPT_0x32
	CALL SUBOPT_0x3C
	CALL SUBOPT_0x41
;    1271         lcd_puts(lcd);
	CALL SUBOPT_0x46
;    1272         delay_ms(10);
;    1273 
;    1274         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x12D
;    1275         {
;    1276             delay_ms(150);
	CALL SUBOPT_0x44
;    1277             goto selesai;
	RJMP _0x12E
;    1278         }
;    1279     }
_0x12D:
	RJMP _0x129
;    1280     selesai:
_0x12E:
;    1281     lcd_clear();
	CALL _lcd_clear
;    1282 }
	RET
;    1283 
;    1284 void auto_scan()
;    1285 {
_auto_scan:
;    1286     for(;;)
_0x130:
;    1287     {
;    1288     read_adc(0);
	CALL SUBOPT_0x14
;    1289         if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_bb0
	CP   R26,R30
	BRSH _0x132
	CALL SUBOPT_0x14
	STS  _bb0,R30
;    1290         if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
_0x132:
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_ba0
	CP   R30,R26
	BRSH _0x133
	CALL SUBOPT_0x14
	STS  _ba0,R30
;    1291 
;    1292         bt0=((bb0+ba0)/2);
_0x133:
	CALL SUBOPT_0x3E
;    1293 
;    1294     read_adc(1);
	CALL SUBOPT_0x15
;    1295         if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_bb1
	CP   R26,R30
	BRSH _0x134
	CALL SUBOPT_0x15
	STS  _bb1,R30
;    1296         if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
_0x134:
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_ba1
	CP   R30,R26
	BRSH _0x135
	CALL SUBOPT_0x15
	STS  _ba1,R30
;    1297 
;    1298         bt1=((bb1+ba1)/2);
_0x135:
	CALL SUBOPT_0x43
;    1299 
;    1300     read_adc(2);
	CALL SUBOPT_0x16
;    1301         if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_bb2
	CP   R26,R30
	BRSH _0x136
	CALL SUBOPT_0x16
	STS  _bb2,R30
;    1302         if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
_0x136:
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_ba2
	CP   R30,R26
	BRSH _0x137
	CALL SUBOPT_0x16
	STS  _ba2,R30
;    1303 
;    1304         bt2=((bb2+ba2)/2);
_0x137:
	CALL SUBOPT_0x45
;    1305 
;    1306     read_adc(3);
	CALL SUBOPT_0x17
;    1307         if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_bb3
	CP   R26,R30
	BRSH _0x138
	CALL SUBOPT_0x17
	STS  _bb3,R30
;    1308         if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
_0x138:
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_ba3
	CP   R30,R26
	BRSH _0x139
	CALL SUBOPT_0x17
	STS  _ba3,R30
;    1309 
;    1310         bt3=((bb3+ba3)/2);
_0x139:
	CALL SUBOPT_0x47
;    1311 
;    1312     read_adc(4);
	CALL SUBOPT_0x18
;    1313         if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_bb4
	CP   R26,R30
	BRSH _0x13A
	CALL SUBOPT_0x18
	STS  _bb4,R30
;    1314         if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
_0x13A:
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_ba4
	CP   R30,R26
	BRSH _0x13B
	CALL SUBOPT_0x18
	STS  _ba4,R30
;    1315 
;    1316         bt4=((bb4+ba4)/2);
_0x13B:
	CALL SUBOPT_0x48
;    1317 
;    1318     read_adc(5);
	CALL SUBOPT_0x19
;    1319         if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_bb5
	CP   R26,R30
	BRSH _0x13C
	CALL SUBOPT_0x19
	STS  _bb5,R30
;    1320         if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
_0x13C:
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_ba5
	CP   R30,R26
	BRSH _0x13D
	CALL SUBOPT_0x19
	STS  _ba5,R30
;    1321 
;    1322         bt5=((bb5+ba5)/2);
_0x13D:
	CALL SUBOPT_0x49
;    1323 
;    1324     read_adc(6);
	CALL SUBOPT_0x1A
;    1325         if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_bb6
	CP   R26,R30
	BRSH _0x13E
	CALL SUBOPT_0x1A
	STS  _bb6,R30
;    1326         if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
_0x13E:
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_ba6
	CP   R30,R26
	BRSH _0x13F
	CALL SUBOPT_0x1A
	STS  _ba6,R30
;    1327 
;    1328         bt6=((bb6+ba6)/2);
_0x13F:
	CALL SUBOPT_0x4A
;    1329 
;    1330     read_adc(7);
	CALL SUBOPT_0x1B
;    1331         if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
	CALL SUBOPT_0x1B
	MOV  R26,R30
	LDS  R30,_bb7
	CP   R26,R30
	BRSH _0x140
	CALL SUBOPT_0x1B
	STS  _bb7,R30
;    1332         if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
_0x140:
	CALL SUBOPT_0x1B
	CP   R12,R30
	BRSH _0x141
	CALL SUBOPT_0x1B
	MOV  R12,R30
;    1333 
;    1334         bt7=((bb7+ba7)/2);
_0x141:
	CALL SUBOPT_0x4B
;    1335 
;    1336         lcd_clear();
;    1337         lcd_gotoxy(1,0);
;    1338         sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
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
;    1339         lcd_puts(lcd);
	CALL _lcd_puts
;    1340         delay_ms(120);
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x4
;    1341 
;    1342         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x142
;    1343         {
;    1344                 //showMenu();
;    1345                 lcd_clear();
	CALL SUBOPT_0x3F
;    1346                 lcd_gotoxy(1,0);
;    1347                 sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
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
;    1348                 lcd_puts(lcd);
	CALL _lcd_puts
;    1349         }
;    1350     }
_0x142:
	RJMP _0x130
;    1351 }
;    1352 
;    1353 void ikuti_garis()
;    1354 {
_ikuti_garis:
;    1355         baca_sensor();
	CALL _baca_sensor
;    1356 
;    1357         if(sensor==0b00000001){bkan();      error = 15;     x=1;}  //kanan
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x143
	CALL _bkan
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x4D
;    1358         if(sensor==0b00000011){maju();      error = 10;     x=1;}
_0x143:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x144
	CALL _maju
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x4D
;    1359         if(sensor==0b00000010){maju();      error = 8;      x=1;}
_0x144:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x145
	CALL _maju
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x4D
;    1360         if(sensor==0b00000110){maju();      error = 5;      x=1;}
_0x145:
	LDI  R30,LOW(6)
	CP   R30,R5
	BRNE _0x146
	CALL _maju
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x4D
;    1361         if(sensor==0b00000100){maju();      error = 3;      x=1;}
_0x146:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x147
	CALL _maju
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x4D
;    1362         if(sensor==0b00001100){maju();      error = 2;      x=1;}
_0x147:
	LDI  R30,LOW(12)
	CP   R30,R5
	BRNE _0x148
	CALL _maju
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x4D
;    1363         if(sensor==0b00001000){maju();      error = 1;      x=1;}
_0x148:
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x149
	CALL _maju
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x4D
;    1364 
;    1365         if(sensor==0b00010000){maju();      error = -1;     x=0;}
_0x149:
	LDI  R30,LOW(16)
	CP   R30,R5
	BRNE _0x14A
	CALL _maju
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL SUBOPT_0x4E
;    1366         if(sensor==0b00110000){maju();      error = -2;     x=0;}
_0x14A:
	LDI  R30,LOW(48)
	CP   R30,R5
	BRNE _0x14B
	CALL _maju
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CALL SUBOPT_0x4E
;    1367         if(sensor==0b00100000){maju();      error = -3;     x=0;}
_0x14B:
	LDI  R30,LOW(32)
	CP   R30,R5
	BRNE _0x14C
	CALL _maju
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	CALL SUBOPT_0x4E
;    1368         if(sensor==0b01100000){maju();      error = -5;     x=0;}
_0x14C:
	LDI  R30,LOW(96)
	CP   R30,R5
	BRNE _0x14D
	CALL _maju
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	CALL SUBOPT_0x4E
;    1369         if(sensor==0b01000000){maju();      error = -8;     x=0;}
_0x14D:
	LDI  R30,LOW(64)
	CP   R30,R5
	BRNE _0x14E
	CALL _maju
	LDI  R30,LOW(65528)
	LDI  R31,HIGH(65528)
	CALL SUBOPT_0x4E
;    1370         if(sensor==0b11000000){maju();      error = -10;    x=0;}
_0x14E:
	LDI  R30,LOW(192)
	CP   R30,R5
	BRNE _0x14F
	CALL _maju
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	CALL SUBOPT_0x4E
;    1371         if(sensor==0b10000000){bkir();      error = -15;    x=0;}  //kiri
_0x14F:
	LDI  R30,LOW(128)
	CP   R30,R5
	BRNE _0x150
	CALL _bkir
	LDI  R30,LOW(65521)
	LDI  R31,HIGH(65521)
	CALL SUBOPT_0x4E
;    1372 
;    1373         d_error = error-last_error;
_0x150:
	LDS  R26,_last_error
	LDS  R27,_last_error+1
	CALL SUBOPT_0x4F
	SUB  R30,R26
	SBC  R31,R27
	STS  _d_error,R30
	STS  _d_error+1,R31
;    1374         PV      = (Kp*error)+(Kd*d_error);
	CALL SUBOPT_0x6
	MOV  R26,R30
	CALL SUBOPT_0x4F
	LDI  R27,0
	CALL __MULW12
	MOVW R22,R30
	CALL SUBOPT_0x8
	MOV  R26,R30
	LDS  R30,_d_error
	LDS  R31,_d_error+1
	LDI  R27,0
	CALL __MULW12
	ADD  R30,R22
	ADC  R31,R23
	STS  _PV,R30
	STS  _PV+1,R31
;    1375 
;    1376         rpwm=intervalPWM+PV;
	LDS  R26,_intervalPWM
	LDS  R27,_intervalPWM+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x11
;    1377         lpwm=intervalPWM-PV;
	LDS  R26,_PV
	LDS  R27,_PV+1
	LDS  R30,_intervalPWM
	LDS  R31,_intervalPWM+1
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0xF
;    1378 
;    1379         last_error=error;
	CALL SUBOPT_0x4F
	STS  _last_error,R30
	STS  _last_error+1,R31
;    1380 
;    1381         if(lpwm>=255)       lpwm = 255;
	LDS  R26,_lpwm
	LDS  R27,_lpwm+1
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	BRLT _0x151
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0xF
;    1382         if(lpwm<=0)         lpwm = 0;
_0x151:
	LDS  R26,_lpwm
	LDS  R27,_lpwm+1
	CALL __CPW02
	BRLT _0x152
	LDI  R30,0
	STS  _lpwm,R30
	STS  _lpwm+1,R30
;    1383 
;    1384         if(rpwm>=255)       rpwm = 255;
_0x152:
	LDS  R26,_rpwm
	LDS  R27,_rpwm+1
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	BRLT _0x153
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x11
;    1385         if(rpwm<=0)         rpwm = 0;
_0x153:
	LDS  R26,_rpwm
	LDS  R27,_rpwm+1
	CALL __CPW02
	BRLT _0x154
	LDI  R30,0
	STS  _rpwm,R30
	STS  _rpwm+1,R30
;    1386 
;    1387         sprintf(lcd_buffer,"%d   %d",lpwm, rpwm);
_0x154:
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,800
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xE
	CALL __CWD1
	CALL __PUTPARD1
	CALL SUBOPT_0x10
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
;    1388         lcd_gotoxy(0, 0);
	CALL SUBOPT_0x25
;    1389         lcd_putsf("                ");
	__POINTW1FN _0,808
	CALL SUBOPT_0x1
;    1390         lcd_gotoxy(0, 0);
	CALL SUBOPT_0x25
;    1391         lcd_puts(lcd_buffer);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;    1392         delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x4
;    1393 }
	RET
;    1394 

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
	BREQ _0x155
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x157
	__CPWRN 16,17,2
	BRLO _0x158
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x157:
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
_0x158:
	RJMP _0x159
_0x155:
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _putchar
_0x159:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__print_G2:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
_0x15A:
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
	JMP _0x15C
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x160
	CPI  R18,37
	BRNE _0x161
	LDI  R17,LOW(1)
	RJMP _0x162
_0x161:
	CALL SUBOPT_0x50
_0x162:
	RJMP _0x15F
_0x160:
	CPI  R30,LOW(0x1)
	BRNE _0x163
	CPI  R18,37
	BRNE _0x164
	CALL SUBOPT_0x50
	RJMP _0x1E0
_0x164:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x165
	LDI  R16,LOW(1)
	RJMP _0x15F
_0x165:
	CPI  R18,43
	BRNE _0x166
	LDI  R20,LOW(43)
	RJMP _0x15F
_0x166:
	CPI  R18,32
	BRNE _0x167
	LDI  R20,LOW(32)
	RJMP _0x15F
_0x167:
	RJMP _0x168
_0x163:
	CPI  R30,LOW(0x2)
	BRNE _0x169
_0x168:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x16A
	ORI  R16,LOW(128)
	RJMP _0x15F
_0x16A:
	RJMP _0x16B
_0x169:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x15F
_0x16B:
	CPI  R18,48
	BRLO _0x16E
	CPI  R18,58
	BRLO _0x16F
_0x16E:
	RJMP _0x16D
_0x16F:
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x15F
_0x16D:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x173
	CALL SUBOPT_0x51
	LD   R30,X
	CALL SUBOPT_0x52
	RJMP _0x174
_0x173:
	CPI  R30,LOW(0x73)
	BRNE _0x176
	CALL SUBOPT_0x51
	CALL SUBOPT_0x53
	CALL _strlen
	MOV  R17,R30
	RJMP _0x177
_0x176:
	CPI  R30,LOW(0x70)
	BRNE _0x179
	CALL SUBOPT_0x51
	CALL SUBOPT_0x53
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x177:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x17A
_0x179:
	CPI  R30,LOW(0x64)
	BREQ _0x17D
	CPI  R30,LOW(0x69)
	BRNE _0x17E
_0x17D:
	ORI  R16,LOW(4)
	RJMP _0x17F
_0x17E:
	CPI  R30,LOW(0x75)
	BRNE _0x180
_0x17F:
	LDI  R30,LOW(_tbl10_G2*2)
	LDI  R31,HIGH(_tbl10_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x181
_0x180:
	CPI  R30,LOW(0x58)
	BRNE _0x183
	ORI  R16,LOW(8)
	RJMP _0x184
_0x183:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x1B5
_0x184:
	LDI  R30,LOW(_tbl16_G2*2)
	LDI  R31,HIGH(_tbl16_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x181:
	SBRS R16,2
	RJMP _0x186
	CALL SUBOPT_0x51
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,0
	BRGE _0x187
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x187:
	CPI  R20,0
	BREQ _0x188
	SUBI R17,-LOW(1)
	RJMP _0x189
_0x188:
	ANDI R16,LOW(251)
_0x189:
	RJMP _0x18A
_0x186:
	CALL SUBOPT_0x51
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x18A:
_0x17A:
	SBRC R16,0
	RJMP _0x18B
_0x18C:
	CP   R17,R21
	BRSH _0x18E
	SBRS R16,7
	RJMP _0x18F
	SBRS R16,2
	RJMP _0x190
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x191
_0x190:
	LDI  R18,LOW(48)
_0x191:
	RJMP _0x192
_0x18F:
	LDI  R18,LOW(32)
_0x192:
	CALL SUBOPT_0x50
	SUBI R21,LOW(1)
	RJMP _0x18C
_0x18E:
_0x18B:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x193
_0x194:
	CPI  R19,0
	BREQ _0x196
	SBRS R16,3
	RJMP _0x197
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x1E1
_0x197:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x1E1:
	ST   -Y,R30
	CALL SUBOPT_0x54
	CPI  R21,0
	BREQ _0x199
	SUBI R21,LOW(1)
_0x199:
	SUBI R19,LOW(1)
	RJMP _0x194
_0x196:
	RJMP _0x19A
_0x193:
_0x19C:
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
_0x19E:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x1A0
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x19E
_0x1A0:
	CPI  R18,58
	BRLO _0x1A1
	SBRS R16,3
	RJMP _0x1A2
	SUBI R18,-LOW(7)
	RJMP _0x1A3
_0x1A2:
	SUBI R18,-LOW(39)
_0x1A3:
_0x1A1:
	SBRC R16,4
	RJMP _0x1A5
	CPI  R18,49
	BRSH _0x1A7
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x1A6
_0x1A7:
	RJMP _0x1E2
_0x1A6:
	CP   R21,R19
	BRLO _0x1AB
	SBRS R16,0
	RJMP _0x1AC
_0x1AB:
	RJMP _0x1AA
_0x1AC:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x1AD
	LDI  R18,LOW(48)
_0x1E2:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x1AE
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x54
	CPI  R21,0
	BREQ _0x1AF
	SUBI R21,LOW(1)
_0x1AF:
_0x1AE:
_0x1AD:
_0x1A5:
	CALL SUBOPT_0x50
	CPI  R21,0
	BREQ _0x1B0
	SUBI R21,LOW(1)
_0x1B0:
_0x1AA:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x19D
	RJMP _0x19C
_0x19D:
_0x19A:
	SBRS R16,0
	RJMP _0x1B1
_0x1B2:
	CPI  R21,0
	BREQ _0x1B4
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x52
	RJMP _0x1B2
_0x1B4:
_0x1B1:
_0x1B5:
_0x174:
_0x1E0:
	LDI  R17,LOW(0)
_0x15F:
	RJMP _0x15A
_0x15C:
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
	BRSH _0x1B7
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
_0x1B7:
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
_0x1B8:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x1BA
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x1B8
_0x1BA:
	LDD  R17,Y+0
	RJMP _0x1C0
_lcd_putsf:
	ST   -Y,R17
_0x1BB:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x1BD
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x1BB
_0x1BD:
	LDD  R17,Y+0
_0x1C0:
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
	CALL SUBOPT_0x55
	CALL SUBOPT_0x55
	CALL SUBOPT_0x55
	CALL __long_delay_G3
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL __lcd_init_write_G3
	CALL __long_delay_G3
	LDI  R30,LOW(40)
	CALL SUBOPT_0x56
	LDI  R30,LOW(4)
	CALL SUBOPT_0x56
	LDI  R30,LOW(133)
	CALL SUBOPT_0x56
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G3
	CPI  R30,LOW(0x5)
	BREQ _0x1BE
	LDI  R30,LOW(0)
	RJMP _0x1BF
_0x1BE:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x1BF:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 56 TIMES, CODE SIZE REDUCTION:107 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 78 TIMES, CODE SIZE REDUCTION:151 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xB:
	LDI  R30,0
	STS  _lpwm,R30
	STS  _lpwm+1,R30
	LDI  R30,0
	STS  _rpwm,R30
	STS  _rpwm+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xC:
	LDS  R26,_b
	LDS  R27,_b+1
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xD:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xE:
	LDS  R30,_lpwm
	LDS  R31,_lpwm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xF:
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x10:
	LDS  R30,_rpwm
	LDS  R31,_rpwm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x11:
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x12:
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
	RCALL SUBOPT_0xE
	CALL __CWD1
	CALL __PUTPARD1
	RCALL SUBOPT_0x10
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 25 TIMES, CODE SIZE REDUCTION:93 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x4D:
	STS  _error,R30
	STS  _error+1,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _x,R30
	STS  _x+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x4E:
	STS  _error,R30
	STS  _error+1,R31
	LDI  R30,0
	STS  _x,R30
	STS  _x+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x4F:
	LDS  R30,_error
	LDS  R31,_error+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x50:
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
SUBOPT_0x51:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,4
	STD  Y+16,R26
	STD  Y+16+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x52:
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
SUBOPT_0x53:
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x54:
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
SUBOPT_0x55:
	CALL __long_delay_G3
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x56:
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

__MULW12U:
	MUL  R31,R26
	MOV  R31,R0
	MUL  R30,R27
	ADD  R31,R0
	MUL  R30,R26
	MOV  R30,R0
	ADD  R31,R1
	RET

__MULW12:
	RCALL __CHKSIGNW
	RCALL __MULW12U
	BRTC __MULW121
	RCALL __ANEGW1
__MULW121:
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

__CPW02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
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
