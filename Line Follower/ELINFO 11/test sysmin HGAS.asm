
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

	.INCLUDE "test sysmin HGAS.vec"
	.INCLUDE "test sysmin HGAS.inc"

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
;       1 /*****************************************************
;       2 This program was produced by the
;       3 CodeWizardAVR V1.25.3 Standard
;       4 Automatic Program Generator
;       5 © Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;       6 http://www.hpinfotech.com
;       7 
;       8 Project :
;       9 Version :
;      10 Date    : 6/25/2008
;      11 Author  : F4CG
;      12 Company : F4CG
;      13 Comments: test PID
;      14 
;      15 
;      16 Chip type           : ATmega16
;      17 Program type        : Application
;      18 Clock frequency     : 12.000000 MHz
;      19 Memory model        : Small
;      20 External SRAM size  : 0
;      21 Data Stack size     : 256
;      22 *****************************************************/
;      23 
;      24 #include <mega16.h>
;      25 #include <delay.h>
;      26 #include <stdio.h>
;      27 #include <lcd.h>
;      28 
;      29 #define sw_ok     PINC.0
;      30 #define sw_cancel PINC.1
;      31 #define sw_up     PINC.2
;      32 #define sw_down   PINC.3
;      33 
;      34 #define Enki PORTD.4
;      35 #define kirplus PORTD.6
;      36 #define kirmin PORTD.3
;      37 #define Enka PORTD.5
;      38 #define kaplus PORTD.1
;      39 #define kamin PORTD.0
;      40 
;      41 #define ADC_VREF_TYPE 0x20
;      42 
;      43 #asm
;      44    .equ __lcd_port=0x18 ;PORTB
   .equ __lcd_port=0x18 ;PORTB
;      45 #endasm
;      46 
;      47 char lcd[16];
_lcd:
	.BYTE 0x10
;      48 unsigned char sensor, adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7;
;      49 //unsigned char b7=37,b6=50,b5=9,b4=10,b3=8,b2=15,b1=25,b0=30;
;      50 unsigned char eeprom bt7=7,bt6=7,bt5=7,bt4=7,bt3=7,bt2=7,bt1=7,bt0=9;

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
;      57 int PV, error, last_error, d_error, i_speed=0;
_PV:
	.BYTE 0x2
_error:
	.BYTE 0x2
_last_error:
	.BYTE 0x2
_d_error:
	.BYTE 0x2
_i_speed:
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
;      62 
;      63 eeprom byte Kp = 20;

	.ESEG
_Kp:
	.DB  0x14
;      64 eeprom byte Ki = 10;
_Ki:
	.DB  0xA
;      65 eeprom byte Kd = 15;
_Kd:
	.DB  0xF
;      66 eeprom byte MAXSpeed = 255;
_MAXSpeed:
	.DB  0xFF
;      67 eeprom byte MINSpeed = 0;
_MINSpeed:
	.DB  0x0
;      68 eeprom byte WarnaGaris = 0; // 1 : putih; 0 : hitam
_WarnaGaris:
	.DB  0x0
;      69 eeprom byte SensLine = 2; // banyaknya sensor dlm 1 garis
_SensLine:
	.DB  0x2
;      70 eeprom byte Skenario = 2;
_Skenario:
	.DB  0x2
;      71 eeprom byte Mode = 1;
_Mode:
	.DB  0x1
;      72 
;      73 void showMenu();
;      74 void displaySensorBit();
;      75 void maju();
;      76 void mundur();
;      77 void bkan();
;      78 void bkir();
;      79 void rotkan();
;      80 void rotkir();
;      81 void stop();
;      82 void ikuti_garis();
;      83 void cek_sensor();
;      84 void baca_sensor();
;      85 void tune_batas();
;      86 void auto_scan();
;      87 void pemercepat();
;      88 void pelambat();
;      89 void TesBlink();
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
;     111 };*/
;     112 
;     113 void define_char(byte flash *pc,byte char_code)
;     114 {
;     115     byte i,a;
;     116     a=(char_code<<3) | 0x40;
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
;     117     for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
;     118 }
;     119 
;     120 void main(void)
;     121 {
_main:
;     122 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     123 DDRA=0x00;
	OUT  0x1A,R30
;     124 
;     125 PORTB=0x00;
	OUT  0x18,R30
;     126 DDRB=0xFF;
	LDI  R30,LOW(255)
	OUT  0x17,R30
;     127 
;     128 PORTC=0x0F;
	LDI  R30,LOW(15)
	OUT  0x15,R30
;     129 DDRC=0x00;
	LDI  R30,LOW(0)
	OUT  0x14,R30
;     130 
;     131 PORTD=0x00;
	OUT  0x12,R30
;     132 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
;     133 
;     134 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
;     135 TCNT0=0x00;
	OUT  0x32,R30
;     136 OCR0=0x00;
	OUT  0x3C,R30
;     137 
;     138 TCCR1A=0x00;
	OUT  0x2F,R30
;     139 TCCR1B=0x00;
	OUT  0x2E,R30
;     140 TCNT1H=0x00;
	OUT  0x2D,R30
;     141 TCNT1L=0x00;
	OUT  0x2C,R30
;     142 ICR1H=0x00;
	OUT  0x27,R30
;     143 ICR1L=0x00;
	OUT  0x26,R30
;     144 OCR1AH=0x00;
	OUT  0x2B,R30
;     145 OCR1AL=0x00;
	OUT  0x2A,R30
;     146 OCR1BH=0x00;
	OUT  0x29,R30
;     147 OCR1BL=0x00;
	OUT  0x28,R30
;     148 
;     149 ASSR=0x00;
	OUT  0x22,R30
;     150 TCCR2=0x00;
	OUT  0x25,R30
;     151 TCNT2=0x00;
	OUT  0x24,R30
;     152 OCR2=0x00;
	OUT  0x23,R30
;     153 
;     154 MCUCR=0x00;
	OUT  0x35,R30
;     155 MCUCSR=0x00;
	OUT  0x34,R30
;     156 
;     157 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;     158 
;     159 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     160 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     161 
;     162 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
;     163 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
;     164 
;     165 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
;     166 
;     167 //define_char(char0,0);
;     168 
;     169 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
;     170 stop();
	RCALL _stop
;     171 
;     172 delay_ms(125);
	CALL SUBOPT_0x0
;     173 lcd_gotoxy(0,0);
;     174         // 0123456789ABCDEF
;     175 lcd_putsf("  baru_belajar  ");
	__POINTW1FN _0,0
	CALL SUBOPT_0x1
;     176 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     177 lcd_putsf("      by :      ");
	__POINTW1FN _0,17
	CALL SUBOPT_0x1
;     178 delay_ms(500);
	CALL SUBOPT_0x3
;     179 lcd_clear();
;     180 
;     181 delay_ms(125);
	CALL SUBOPT_0x0
;     182 lcd_gotoxy(0,0);
;     183         // 0123456789ABCDEF
;     184 lcd_putsf(" ?????????????? ");
	__POINTW1FN _0,34
	CALL SUBOPT_0x1
;     185 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     186 lcd_putsf(" !!!!!!!!!!!!!! ");
	__POINTW1FN _0,51
	CALL SUBOPT_0x1
;     187 delay_ms(1300);
	LDI  R30,LOW(1300)
	LDI  R31,HIGH(1300)
	CALL SUBOPT_0x4
;     188 lcd_clear();
	CALL _lcd_clear
;     189 
;     190 delay_ms(125);
	CALL SUBOPT_0x0
;     191 lcd_gotoxy(0,0);
;     192         // 0123456789ABCDEF
;     193 lcd_putsf("     LPKTA     ");
	__POINTW1FN _0,68
	CALL SUBOPT_0x1
;     194 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     195 lcd_putsf(" FT - UGM - 11 ");
	__POINTW1FN _0,84
	CALL SUBOPT_0x1
;     196 delay_ms(500);
	CALL SUBOPT_0x3
;     197 lcd_clear();
;     198 
;     199 TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     200 #asm("sei")
	sei
;     201 
;     202 //                    <<-----------SEMI RESET-----------<<
;     203 
;     204 mundur();
	RCALL _mundur
;     205 //TesBlink();
;     206 delay_ms(200);
	CALL SUBOPT_0x5
;     207 stop();
	RCALL _stop
;     208 // read eeprom
;     209 var_Kp  = Kp;
	CALL SUBOPT_0x6
	LDI  R31,0
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
;     210 var_Ki  = Ki;
	CALL SUBOPT_0x7
	LDI  R31,0
	STS  _var_Ki,R30
	STS  _var_Ki+1,R31
;     211 var_Kd  = Kd;
	CALL SUBOPT_0x8
	LDI  R31,0
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
;     212 MAXPWM  = (int)MAXSpeed + 1;
	CALL SUBOPT_0x9
	LDI  R31,0
	ADIW R30,1
	STS  _MAXPWM,R30
	STS  _MAXPWM+1,R31
;     213 MINPWM  = MINSpeed;
	CALL SUBOPT_0xA
	LDI  R31,0
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
;     214 
;     215 intervalPWM = (MAXSpeed - MINSpeed) / 8;
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
;     216 PV = 0;
	LDI  R30,0
	STS  _PV,R30
	STS  _PV+1,R30
;     217 error = 0;
	LDI  R30,0
	STS  _error,R30
	STS  _error+1,R30
;     218 last_error = 0;
	LDI  R30,0
	STS  _last_error,R30
	STS  _last_error+1,R30
;     219 
;     220 showMenu();
	RCALL _showMenu
;     221 maju();
	RCALL _maju
;     222 //pemercepat();
;     223 //pelambat();
;     224 displaySensorBit();
	RCALL _displaySensorBit
;     225 while (1)
_0x1A:
;     226       {
;     227             displaySensorBit();
	RCALL _displaySensorBit
;     228             ikuti_garis();
	CALL _ikuti_garis
;     229       };
	RJMP _0x1A
;     230 }
_0x1D:
	RJMP _0x1D
;     231 
;     232 void TesBlink()
;     233 {
;     234     for(;;)
;     235     {
;     236         lcd_gotoxy(1,0);
;     237         lcd_putsf("Tes Blink");
;     238         lcd_gotoxy(1,1);
;     239         lcd_putsf("Tes Blink");
;     240         delay_ms(500);
;     241         lcd_gotoxy(1,1);
;     242         lcd_putsf("         ");
;     243         delay_ms(500);
;     244         lcd_clear();
;     245     }
;     246 }
;     247 
;     248 
;     249 void pemercepat()
;     250 {
_pemercepat:
;     251         lpwm=0;
	CALL SUBOPT_0xB
;     252         rpwm=0;
;     253 
;     254         rotkir();
	RCALL _rotkir
;     255 
;     256         for(b=0;b<255;b++)
	LDI  R30,0
	STS  _b,R30
	STS  _b+1,R30
_0x22:
	CALL SUBOPT_0xC
	BRGE _0x23
;     257         {
;     258             delay_ms(125);
	CALL SUBOPT_0xD
;     259 
;     260             lpwm++;
	CALL SUBOPT_0xE
	ADIW R30,1
	CALL SUBOPT_0xF
;     261             rpwm++;
	CALL SUBOPT_0x10
	ADIW R30,1
	CALL SUBOPT_0x11
;     262 
;     263             lcd_clear();
	CALL SUBOPT_0x12
;     264 
;     265             lcd_gotoxy(0,0);
;     266             sprintf(lcd," %d %d",lpwm,rpwm);
;     267             lcd_puts(lcd);
;     268         }
	CALL SUBOPT_0x13
	RJMP _0x22
_0x23:
;     269         lpwm=0;
	CALL SUBOPT_0xB
;     270         rpwm=0;
;     271 }
	RET
;     272 
;     273 void pelambat()
;     274 {
_pelambat:
;     275         lpwm=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0xF
;     276         rpwm=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x11
;     277 
;     278         rotkan();
	RCALL _rotkan
;     279 
;     280         for(b=0;b<255;b++)
	LDI  R30,0
	STS  _b,R30
	STS  _b+1,R30
_0x25:
	CALL SUBOPT_0xC
	BRGE _0x26
;     281         {
;     282             delay_ms(125);
	CALL SUBOPT_0xD
;     283 
;     284             lpwm--;
	CALL SUBOPT_0xE
	SBIW R30,1
	CALL SUBOPT_0xF
;     285             rpwm--;
	CALL SUBOPT_0x10
	SBIW R30,1
	CALL SUBOPT_0x11
;     286 
;     287             lcd_clear();
	CALL SUBOPT_0x12
;     288 
;     289             lcd_gotoxy(0,0);
;     290             sprintf(lcd," %d %d",lpwm,rpwm);
;     291             lcd_puts(lcd);
;     292         }
	CALL SUBOPT_0x13
	RJMP _0x25
_0x26:
;     293         lpwm=0;
	CALL SUBOPT_0xB
;     294         rpwm=0;
;     295 }
	RET
;     296 
;     297 void baca_sensor()
;     298 {
_baca_sensor:
;     299     sensor=0;
	CLR  R5
;     300     adc0=read_adc(0);
	CALL SUBOPT_0x14
	MOV  R4,R30
;     301     adc1=read_adc(1);
	CALL SUBOPT_0x15
	MOV  R7,R30
;     302     adc2=read_adc(2);
	CALL SUBOPT_0x16
	MOV  R6,R30
;     303     adc3=read_adc(3);
	CALL SUBOPT_0x17
	MOV  R9,R30
;     304     adc4=read_adc(4);
	CALL SUBOPT_0x18
	MOV  R8,R30
;     305     adc5=read_adc(5);
	CALL SUBOPT_0x19
	MOV  R11,R30
;     306     adc6=read_adc(6);
	CALL SUBOPT_0x1A
	MOV  R10,R30
;     307     adc7=read_adc(7);
	CALL SUBOPT_0x1B
	MOV  R13,R30
;     308 
;     309     if(adc0>bt0){s0=1;sensor=sensor|1<<0;}
	CALL SUBOPT_0x1C
	CP   R30,R4
	BRSH _0x27
	SET
	BLD  R2,0
	LDI  R30,LOW(1)
	RJMP _0x1C2
;     310     else {s0=0;sensor=sensor|0<<0;}
_0x27:
	CLT
	BLD  R2,0
	LDI  R30,LOW(0)
_0x1C2:
	OR   R5,R30
;     311 
;     312     if(adc1>bt1){s1=1;sensor=sensor|1<<1;}
	CALL SUBOPT_0x1D
	CP   R30,R7
	BRSH _0x29
	SET
	BLD  R2,1
	LDI  R30,LOW(2)
	RJMP _0x1C3
;     313     else {s1=0;sensor=sensor|0<<1;}
_0x29:
	CLT
	BLD  R2,1
	LDI  R30,LOW(0)
_0x1C3:
	OR   R5,R30
;     314 
;     315     if(adc2>bt2){s2=1;sensor=sensor|1<<2;}
	CALL SUBOPT_0x1E
	CP   R30,R6
	BRSH _0x2B
	SET
	BLD  R2,2
	LDI  R30,LOW(4)
	RJMP _0x1C4
;     316     else {s2=0;sensor=sensor|0<<2;}
_0x2B:
	CLT
	BLD  R2,2
	LDI  R30,LOW(0)
_0x1C4:
	OR   R5,R30
;     317 
;     318     if(adc3>bt3){s3=1;sensor=sensor|1<<3;}
	CALL SUBOPT_0x1F
	CP   R30,R9
	BRSH _0x2D
	SET
	BLD  R2,3
	LDI  R30,LOW(8)
	RJMP _0x1C5
;     319     else {s3=0;sensor=sensor|0<<3;}
_0x2D:
	CLT
	BLD  R2,3
	LDI  R30,LOW(0)
_0x1C5:
	OR   R5,R30
;     320 
;     321     if(adc4>bt4){s4=1;sensor=sensor|1<<4;}
	CALL SUBOPT_0x20
	CP   R30,R8
	BRSH _0x2F
	SET
	BLD  R2,4
	LDI  R30,LOW(16)
	RJMP _0x1C6
;     322     else {s4=0;sensor=sensor|0<<4;}
_0x2F:
	CLT
	BLD  R2,4
	LDI  R30,LOW(0)
_0x1C6:
	OR   R5,R30
;     323 
;     324     if(adc5>bt5){s5=1;sensor=sensor|1<<5;}
	CALL SUBOPT_0x21
	CP   R30,R11
	BRSH _0x31
	SET
	BLD  R2,5
	LDI  R30,LOW(32)
	RJMP _0x1C7
;     325     else {s5=0;sensor=sensor|0<<5;}
_0x31:
	CLT
	BLD  R2,5
	LDI  R30,LOW(0)
_0x1C7:
	OR   R5,R30
;     326 
;     327     if(adc6>bt6){s6=1;sensor=sensor|1<<6;}
	CALL SUBOPT_0x22
	CP   R30,R10
	BRSH _0x33
	SET
	BLD  R2,6
	LDI  R30,LOW(64)
	RJMP _0x1C8
;     328     else {s6=0;sensor=sensor|0<<6;}
_0x33:
	CLT
	BLD  R2,6
	LDI  R30,LOW(0)
_0x1C8:
	OR   R5,R30
;     329 
;     330     if(adc7>bt7){s7=1;sensor=sensor|1<<7;}
	CALL SUBOPT_0x23
	CP   R30,R13
	BRSH _0x35
	SET
	BLD  R2,7
	LDI  R30,LOW(128)
	RJMP _0x1C9
;     331     else {s7=0;sensor=sensor|0<<7;}
_0x35:
	CLT
	BLD  R2,7
	LDI  R30,LOW(0)
_0x1C9:
	OR   R5,R30
;     332 }
	RET
;     333 
;     334 void tampil(unsigned char dat)
;     335 {
_tampil:
;     336     unsigned char data;
;     337 
;     338     data = dat / 100;
	ST   -Y,R17
;	dat -> Y+1
;	data -> R17
	LDD  R26,Y+1
	LDI  R30,LOW(100)
	CALL SUBOPT_0x24
;     339     data+=0x30;
;     340     lcd_putchar(data);
;     341 
;     342     dat%=100;
	LDI  R30,LOW(100)
	CALL __MODB21U
	STD  Y+1,R30
;     343     data = dat / 10;
	LDD  R26,Y+1
	LDI  R30,LOW(10)
	CALL SUBOPT_0x24
;     344     data+=0x30;
;     345     lcd_putchar(data);
;     346 
;     347     dat%=10;
	LDI  R30,LOW(10)
	CALL __MODB21U
	STD  Y+1,R30
;     348     data = dat + 0x30;
	SUBI R30,-LOW(48)
	MOV  R17,R30
;     349     lcd_putchar(data);
	ST   -Y,R17
	CALL _lcd_putchar
;     350 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;     351 
;     352 void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom )
;     353 {
_tulisKeEEPROM:
;     354         lcd_gotoxy(0,0);
;	NoMenu -> Y+2
;	NoSubMenu -> Y+1
;	var_in_eeprom -> Y+0
	CALL SUBOPT_0x25
;     355         lcd_putsf("Tulis ke EEPROM ");
	__POINTW1FN _0,127
	CALL SUBOPT_0x1
;     356         lcd_putsf("...             ");
	__POINTW1FN _0,144
	CALL SUBOPT_0x1
;     357         switch (NoMenu)
	LDD  R30,Y+2
;     358         {
;     359           case 1: // PID
	CPI  R30,LOW(0x1)
	BRNE _0x3A
;     360                 switch (NoSubMenu)
	LDD  R30,Y+1
;     361                 {
;     362                   case 1: // Kp
	CPI  R30,LOW(0x1)
	BRNE _0x3E
;     363                         Kp = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL __EEPROMWRB
;     364                         break;
	RJMP _0x3D
;     365                   case 2: // Ki
_0x3E:
	CPI  R30,LOW(0x2)
	BRNE _0x3F
;     366                         Ki = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMWRB
;     367                         break;
	RJMP _0x3D
;     368                   case 3: // Kd
_0x3F:
	CPI  R30,LOW(0x3)
	BRNE _0x3D
;     369                         Kd = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL __EEPROMWRB
;     370                         break;
;     371                 }
_0x3D:
;     372                 break;
	RJMP _0x39
;     373           case 2: // Speed
_0x3A:
	CPI  R30,LOW(0x2)
	BRNE _0x41
;     374                 switch (NoSubMenu)
	LDD  R30,Y+1
;     375                 {
;     376                   case 1: // MAX
	CPI  R30,LOW(0x1)
	BRNE _0x45
;     377                         MAXSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL __EEPROMWRB
;     378                         break;
	RJMP _0x44
;     379                   case 2: // MIN
_0x45:
	CPI  R30,LOW(0x2)
	BRNE _0x44
;     380                         MINSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL __EEPROMWRB
;     381                         break;
;     382                 }
_0x44:
;     383                 break;
	RJMP _0x39
;     384           case 3: // Warna Garis
_0x41:
	CPI  R30,LOW(0x3)
	BRNE _0x47
;     385                 switch (NoSubMenu)
	LDD  R30,Y+1
;     386                 {
;     387                   case 1: // Warna
	CPI  R30,LOW(0x1)
	BRNE _0x4B
;     388                         WarnaGaris = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMWRB
;     389                         break;
	RJMP _0x4A
;     390                   case 2: // SensL
_0x4B:
	CPI  R30,LOW(0x2)
	BRNE _0x4A
;     391                         SensLine = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMWRB
;     392                         break;
;     393                 }
_0x4A:
;     394                 break;
	RJMP _0x39
;     395           case 4: // Skenario
_0x47:
	CPI  R30,LOW(0x4)
	BRNE _0x39
;     396                 Skenario = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMWRB
;     397                 break;
;     398         }
_0x39:
;     399         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	CALL SUBOPT_0x4
;     400 }
	ADIW R28,3
	RET
;     401 
;     402 void setByte( byte NoMenu, byte NoSubMenu )
;     403 {
_setByte:
;     404         byte var_in_eeprom;
;     405         byte plus5 = 0;
;     406         char limitPilih = -1;
;     407 
;     408         lcd_clear();
	CALL __SAVELOCR4
;	NoMenu -> Y+5
;	NoSubMenu -> Y+4
;	var_in_eeprom -> R17
;	plus5 -> R16
;	limitPilih -> R19
	LDI  R16,0
	LDI  R19,255
	CALL SUBOPT_0x26
;     409         lcd_gotoxy(0, 0);
;     410         switch (NoMenu)
	LDD  R30,Y+5
;     411         {
;     412           case 1: // PID
	CPI  R30,LOW(0x1)
	BRNE _0x51
;     413                 switch (NoSubMenu)
	LDD  R30,Y+4
;     414                 {
;     415                   case 1: // Kp
	CPI  R30,LOW(0x1)
	BRNE _0x55
;     416                         lcd_putsf("Set Kp :        ");
	__POINTW1FN _0,161
	CALL SUBOPT_0x1
;     417                         var_in_eeprom = Kp;
	CALL SUBOPT_0x6
	RJMP _0x1CA
;     418                         break;
;     419                   case 2: // Ki
_0x55:
	CPI  R30,LOW(0x2)
	BRNE _0x56
;     420                         lcd_putsf("Set Ki :        ");
	__POINTW1FN _0,178
	CALL SUBOPT_0x1
;     421                         var_in_eeprom = Ki;
	CALL SUBOPT_0x7
	RJMP _0x1CA
;     422                         break;
;     423                   case 3: // Kd
_0x56:
	CPI  R30,LOW(0x3)
	BRNE _0x54
;     424                         lcd_putsf("Set Kd :        ");
	__POINTW1FN _0,195
	CALL SUBOPT_0x1
;     425                         var_in_eeprom = Kd;
	CALL SUBOPT_0x8
_0x1CA:
	MOV  R17,R30
;     426                         break;
;     427                 }
_0x54:
;     428                 break;
	RJMP _0x50
;     429           case 2: // Speed
_0x51:
	CPI  R30,LOW(0x2)
	BRNE _0x58
;     430                 plus5 = 1;
	LDI  R16,LOW(1)
;     431                 switch (NoSubMenu)
	LDD  R30,Y+4
;     432                 {
;     433                   case 1: // MAX
	CPI  R30,LOW(0x1)
	BRNE _0x5C
;     434                         lcd_putsf("Set MAX Speed : ");
	__POINTW1FN _0,212
	CALL SUBOPT_0x1
;     435                         var_in_eeprom = MAXSpeed;
	CALL SUBOPT_0x9
	RJMP _0x1CB
;     436                         break;
;     437                   case 2: // MIN
_0x5C:
	CPI  R30,LOW(0x2)
	BRNE _0x5B
;     438                         lcd_putsf("Set MIN Speed : ");
	__POINTW1FN _0,229
	CALL SUBOPT_0x1
;     439                         var_in_eeprom = MINSpeed;
	CALL SUBOPT_0xA
_0x1CB:
	MOV  R17,R30
;     440                         break;
;     441                 }
_0x5B:
;     442                 break;
	RJMP _0x50
;     443           case 3: // Warna Garis
_0x58:
	CPI  R30,LOW(0x3)
	BRNE _0x5E
;     444                 switch (NoSubMenu)
	LDD  R30,Y+4
;     445                 {
;     446                   case 1: // Warna
	CPI  R30,LOW(0x1)
	BRNE _0x62
;     447                         limitPilih = 1;
	LDI  R19,LOW(1)
;     448                         lcd_putsf("Warna Garis   : ");
	__POINTW1FN _0,246
	CALL SUBOPT_0x1
;     449                         var_in_eeprom = WarnaGaris;
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	RJMP _0x1CC
;     450                         break;
;     451                   case 2: // SensL
_0x62:
	CPI  R30,LOW(0x2)
	BRNE _0x61
;     452                         limitPilih = 3;
	LDI  R19,LOW(3)
;     453                         lcd_putsf("SensLine :      ");
	__POINTW1FN _0,263
	CALL SUBOPT_0x1
;     454                         var_in_eeprom = SensLine;
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
_0x1CC:
	MOV  R17,R30
;     455                         break;
;     456                 }
_0x61:
;     457                 break;
	RJMP _0x50
;     458           case 4: // Skenario
_0x5E:
	CPI  R30,LOW(0x4)
	BRNE _0x50
;     459                   lcd_putsf("Skenario :      ");
	__POINTW1FN _0,280
	CALL SUBOPT_0x1
;     460                   var_in_eeprom = Skenario;
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	MOV  R17,R30
;     461                   limitPilih = 8;
	LDI  R19,LOW(8)
;     462                   break;
;     463         }
_0x50:
;     464 
;     465         while (sw_cancel)
_0x65:
	SBIS 0x13,1
	RJMP _0x67
;     466         {
;     467                 delay_ms(150);
	CALL SUBOPT_0x27
;     468                 lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
;     469                 tampil(var_in_eeprom);
	ST   -Y,R17
	CALL _tampil
;     470 
;     471                 if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x68
;     472                 {
;     473                         lcd_clear();
	CALL _lcd_clear
;     474                         tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R17
	CALL _tulisKeEEPROM
;     475                         goto exitSetByte;
	RJMP _0x69
;     476                 }
;     477                 if (!sw_down)
_0x68:
	SBIC 0x13,3
	RJMP _0x6A
;     478                 {
;     479                         if ( plus5 )
	CPI  R16,0
	BREQ _0x6B
;     480                                 if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x6C
;     481                                         var_in_eeprom = 255;
	LDI  R17,LOW(255)
;     482                                 else
	RJMP _0x6D
_0x6C:
;     483                                         var_in_eeprom -= 5;
	SUBI R17,LOW(5)
;     484                         else
_0x6D:
	RJMP _0x6E
_0x6B:
;     485                                 if ( !limitPilih )
	CPI  R19,0
	BRNE _0x6F
;     486                                         var_in_eeprom--;
	RJMP _0x1CD
;     487                                 else
_0x6F:
;     488                                 {
;     489                                         if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x71
;     490                                           var_in_eeprom = limitPilih;
	MOV  R17,R19
;     491                                         else
	RJMP _0x72
_0x71:
;     492                                           var_in_eeprom--;
_0x1CD:
	SUBI R17,1
;     493                                 }
_0x72:
_0x6E:
;     494                 }
;     495                 if (!sw_up)
_0x6A:
	SBIC 0x13,2
	RJMP _0x73
;     496                 {
;     497                         if ( plus5 )
	CPI  R16,0
	BREQ _0x74
;     498                                 if ( var_in_eeprom == 255 )
	CPI  R17,255
	BRNE _0x75
;     499                                         var_in_eeprom = 0;
	LDI  R17,LOW(0)
;     500                                 else
	RJMP _0x76
_0x75:
;     501                                         var_in_eeprom += 5;
	SUBI R17,-LOW(5)
;     502                         else
_0x76:
	RJMP _0x77
_0x74:
;     503                                 if ( !limitPilih )
	CPI  R19,0
	BRNE _0x78
;     504                                         var_in_eeprom++;
	RJMP _0x1CE
;     505                                 else
_0x78:
;     506                                 {
;     507                                         if ( var_in_eeprom == limitPilih )
	CP   R19,R17
	BRNE _0x7A
;     508                                           var_in_eeprom = 0;
	LDI  R17,LOW(0)
;     509                                         else
	RJMP _0x7B
_0x7A:
;     510                                           var_in_eeprom++;
_0x1CE:
	SUBI R17,-1
;     511                                 }
_0x7B:
_0x77:
;     512                 }
;     513         }
_0x73:
	RJMP _0x65
_0x67:
;     514       exitSetByte:
_0x69:
;     515         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
;     516         lcd_clear();
	CALL _lcd_clear
;     517 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;     518 
;     519 void showMenu()
;     520 {
_showMenu:
;     521         //TIMSK = 0x00;
;     522         #asm("cli")
	cli
;     523         lcd_clear();
	CALL _lcd_clear
;     524     menu01:
_0x7C:
;     525         delay_ms(125);   // bouncing sw
	CALL SUBOPT_0x0
;     526         lcd_gotoxy(0,0);
;     527                 // 0123456789abcdef
;     528         lcd_putsf("  Set PID       ");
	__POINTW1FN _0,297
	CALL SUBOPT_0x1
;     529         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     530         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0,314
	CALL SUBOPT_0x1
;     531 
;     532         // kursor awal
;     533         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     534         lcd_putchar(0);
	CALL SUBOPT_0x28
;     535 
;     536         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x7D
;     537         {
;     538                 lcd_clear();
	CALL _lcd_clear
;     539                 kursorPID = 1;
	LDI  R30,LOW(1)
	STS  _kursorPID,R30
;     540                 goto setPID;
	RJMP _0x7E
;     541         }
;     542         if (!sw_down)
_0x7D:
	SBIS 0x13,3
;     543         {
;     544                 goto menu02;
	RJMP _0x80
;     545         }
;     546         if (!sw_up)
	SBIC 0x13,2
	RJMP _0x81
;     547         {
;     548                 lcd_clear();
	CALL _lcd_clear
;     549                 goto menu06;
	RJMP _0x82
;     550         }
;     551 
;     552         goto menu01;
_0x81:
	RJMP _0x7C
;     553     menu02:
_0x80:
;     554         delay_ms(125);
	CALL SUBOPT_0x0
;     555         lcd_gotoxy(0,0);
;     556                  // 0123456789abcdef
;     557         lcd_putsf("  Set PID       ");
	__POINTW1FN _0,297
	CALL SUBOPT_0x1
;     558         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     559         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0,314
	CALL SUBOPT_0x1
;     560 
;     561         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     562         lcd_putchar(0);
	CALL SUBOPT_0x28
;     563 
;     564         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x83
;     565         {
;     566                 lcd_clear();
	CALL _lcd_clear
;     567                 kursorSpeed = 1;
	LDI  R30,LOW(1)
	STS  _kursorSpeed,R30
;     568                 goto setSpeed;
	RJMP _0x84
;     569         }
;     570         if (!sw_up)
_0x83:
	SBIS 0x13,2
;     571         {
;     572                 goto menu01;
	RJMP _0x7C
;     573         }
;     574         if (!sw_down)
	SBIC 0x13,3
	RJMP _0x86
;     575         {
;     576                 lcd_clear();
	CALL _lcd_clear
;     577                 goto menu03;
	RJMP _0x87
;     578         }
;     579         goto menu02;
_0x86:
	RJMP _0x80
;     580     menu03:
_0x87:
;     581         delay_ms(125);
	CALL SUBOPT_0x0
;     582         lcd_gotoxy(0,0);
;     583                 // 0123456789abcdef
;     584         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0,331
	CALL SUBOPT_0x1
;     585         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     586         lcd_putsf("  Skenario      ");
	__POINTW1FN _0,348
	CALL SUBOPT_0x1
;     587 
;     588         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     589         lcd_putchar(0);
	CALL SUBOPT_0x28
;     590 
;     591         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x88
;     592         {
;     593                 lcd_clear();
	CALL _lcd_clear
;     594                 kursorGaris = 1;
	LDI  R30,LOW(1)
	STS  _kursorGaris,R30
;     595                 goto setGaris;
	RJMP _0x89
;     596         }
;     597         if (!sw_up)
_0x88:
	SBIC 0x13,2
	RJMP _0x8A
;     598         {
;     599                 lcd_clear();
	CALL _lcd_clear
;     600                 goto menu02;
	RJMP _0x80
;     601         }
;     602         if (!sw_down)
_0x8A:
	SBIS 0x13,3
;     603         {
;     604                 goto menu04;
	RJMP _0x8C
;     605         }
;     606         goto menu03;
	RJMP _0x87
;     607     menu04:
_0x8C:
;     608         delay_ms(125);
	CALL SUBOPT_0x0
;     609         lcd_gotoxy(0,0);
;     610                 // 0123456789abcdef
;     611         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0,331
	CALL SUBOPT_0x1
;     612         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     613         lcd_putsf("  Skenario      ");
	__POINTW1FN _0,348
	CALL SUBOPT_0x1
;     614 
;     615         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     616         lcd_putchar(0);
	CALL SUBOPT_0x28
;     617 
;     618         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x8D
;     619         {
;     620                 lcd_clear();
	CALL _lcd_clear
;     621                 goto setSkenario;
	RJMP _0x8E
;     622         }
;     623         if (!sw_up)
_0x8D:
	SBIS 0x13,2
;     624         {
;     625                 goto menu03;
	RJMP _0x87
;     626         }
;     627         if (!sw_down)
	SBIC 0x13,3
	RJMP _0x90
;     628         {
;     629                 lcd_clear();
	CALL _lcd_clear
;     630                 goto menu05;
	RJMP _0x91
;     631         }
;     632         goto menu04;
_0x90:
	RJMP _0x8C
;     633     menu05:            // Bikin sendiri lhoo ^^d
_0x91:
;     634         delay_ms(125);
	CALL SUBOPT_0x0
;     635         lcd_gotoxy(0,0);
;     636         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0,365
	CALL SUBOPT_0x1
;     637         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     638         lcd_putsf("  Start!!      ");
	__POINTW1FN _0,385
	CALL SUBOPT_0x1
;     639 
;     640         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     641         lcd_putchar(0);
	CALL SUBOPT_0x28
;     642 
;     643         if  (!sw_ok)
	SBIC 0x13,0
	RJMP _0x92
;     644         {
;     645             lcd_clear();
	CALL _lcd_clear
;     646             goto mode;
	RJMP _0x93
;     647         }
;     648 
;     649         if  (!sw_up)
_0x92:
	SBIC 0x13,2
	RJMP _0x94
;     650         {
;     651             lcd_clear();
	CALL _lcd_clear
;     652             goto menu04;
	RJMP _0x8C
;     653         }
;     654 
;     655         if  (!sw_down)
_0x94:
	SBIS 0x13,3
;     656         {
;     657             goto menu06;
	RJMP _0x82
;     658         }
;     659 
;     660         goto menu05;
	RJMP _0x91
;     661     menu06:
_0x82:
;     662         delay_ms(125);
	CALL SUBOPT_0x0
;     663         lcd_gotoxy(0,0);
;     664         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0,365
	CALL SUBOPT_0x1
;     665         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     666         lcd_putsf("  Start!!      ");
	__POINTW1FN _0,385
	CALL SUBOPT_0x1
;     667 
;     668         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     669         lcd_putchar(0);
	CALL SUBOPT_0x28
;     670 
;     671         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0x96
;     672         {
;     673                 lcd_clear();
	CALL _lcd_clear
;     674                 goto startRobot;
	RJMP _0x97
;     675         }
;     676 
;     677         if (!sw_up)
_0x96:
	SBIS 0x13,2
;     678         {
;     679                 goto menu05;
	RJMP _0x91
;     680         }
;     681 
;     682         if (!sw_down)
	SBIC 0x13,3
	RJMP _0x99
;     683         {
;     684                 lcd_clear();
	CALL _lcd_clear
;     685                 goto menu01;
	RJMP _0x7C
;     686         }
;     687 
;     688         goto menu06;
_0x99:
	RJMP _0x82
;     689 
;     690 
;     691     setPID:
_0x7E:
;     692         delay_ms(150);
	CALL SUBOPT_0x27
;     693         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     694                 // 0123456789ABCDEF
;     695         lcd_putsf("  Kp   Ki   Kd  ");
	__POINTW1FN _0,401
	CALL SUBOPT_0x1
;     696         // lcd_putsf(" 250  200  300  ");
;     697         lcd_putchar(' ');
	CALL SUBOPT_0x29
;     698         tampil(Kp); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x29
;     699         tampil(Ki); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x29
;     700         tampil(Kd); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x8
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x29
;     701 
;     702         switch (kursorPID)
	LDS  R30,_kursorPID
;     703         {
;     704           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0x9D
;     705                 lcd_gotoxy(1,0); // kursor Kp
	LDI  R30,LOW(1)
	RJMP _0x1CF
;     706                 lcd_putchar(0);
;     707                 break;
;     708           case 2:
_0x9D:
	CPI  R30,LOW(0x2)
	BRNE _0x9E
;     709                 lcd_gotoxy(6,0); // kursor Ki
	LDI  R30,LOW(6)
	RJMP _0x1CF
;     710                 lcd_putchar(0);
;     711                 break;
;     712           case 3:
_0x9E:
	CPI  R30,LOW(0x3)
	BRNE _0x9C
;     713                 lcd_gotoxy(11,0); // kursor Kd
	LDI  R30,LOW(11)
_0x1CF:
	ST   -Y,R30
	CALL SUBOPT_0x2B
;     714                 lcd_putchar(0);
;     715                 break;
;     716         }
_0x9C:
;     717 
;     718         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xA0
;     719         {
;     720                 setByte( 1, kursorPID);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDS  R30,_kursorPID
	CALL SUBOPT_0x2C
;     721                 delay_ms(200);
;     722         }
;     723         if (!sw_up)
_0xA0:
	SBIC 0x13,2
	RJMP _0xA1
;     724         {
;     725                 if (kursorPID == 3) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x3)
	BRNE _0xA2
;     726                         kursorPID = 1;
	LDI  R30,LOW(1)
	RJMP _0x1D0
;     727                 } else kursorPID++;
_0xA2:
	LDS  R30,_kursorPID
	SUBI R30,-LOW(1)
_0x1D0:
	STS  _kursorPID,R30
;     728         }
;     729         if (!sw_down)
_0xA1:
	SBIC 0x13,3
	RJMP _0xA4
;     730         {
;     731                 if (kursorPID == 1) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x1)
	BRNE _0xA5
;     732                         kursorPID = 3;
	LDI  R30,LOW(3)
	RJMP _0x1D1
;     733                 } else kursorPID--;
_0xA5:
	LDS  R30,_kursorPID
	SUBI R30,LOW(1)
_0x1D1:
	STS  _kursorPID,R30
;     734         }
;     735 
;     736         if (!sw_cancel)
_0xA4:
	SBIC 0x13,1
	RJMP _0xA7
;     737         {
;     738                 lcd_clear();
	CALL _lcd_clear
;     739                 goto menu01;
	RJMP _0x7C
;     740         }
;     741 
;     742         goto setPID;
_0xA7:
	RJMP _0x7E
;     743 
;     744     setSpeed:
_0x84:
;     745         delay_ms(150);
	CALL SUBOPT_0x27
;     746         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     747                 // 0123456789ABCDEF
;     748         lcd_putsf("   MAX    MIN   ");
	__POINTW1FN _0,418
	CALL SUBOPT_0x1
;     749         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
;     750 
;     751         //lcd_putsf("   250    200   ");
;     752         tampil(MAXSpeed);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x2A
;     753         lcd_putchar(' '); lcd_putchar(' ');lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
;     754         tampil(MINSpeed);
	CALL SUBOPT_0xA
	CALL SUBOPT_0x2A
;     755         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0x29
	CALL SUBOPT_0x29
;     756 
;     757         switch (kursorSpeed)
	LDS  R30,_kursorSpeed
;     758         {
;     759           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0xAB
;     760                 lcd_gotoxy(2,0); // kursor MAX
	LDI  R30,LOW(2)
	RJMP _0x1D2
;     761                 lcd_putchar(0);
;     762                 break;
;     763           case 2:
_0xAB:
	CPI  R30,LOW(0x2)
	BRNE _0xAA
;     764                 lcd_gotoxy(9,0); // kursor MIN
	LDI  R30,LOW(9)
_0x1D2:
	ST   -Y,R30
	CALL SUBOPT_0x2B
;     765                 lcd_putchar(0);
;     766                 break;
;     767         }
_0xAA:
;     768 
;     769         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xAD
;     770         {
;     771                 setByte( 2, kursorSpeed);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R30,_kursorSpeed
	CALL SUBOPT_0x2C
;     772                 delay_ms(200);
;     773         }
;     774         if (!sw_up)
_0xAD:
	SBIC 0x13,2
	RJMP _0xAE
;     775         {
;     776                 if (kursorSpeed == 2)
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x2)
	BRNE _0xAF
;     777                 {
;     778                         kursorSpeed = 1;
	LDI  R30,LOW(1)
	RJMP _0x1D3
;     779                 } else kursorSpeed++;
_0xAF:
	LDS  R30,_kursorSpeed
	SUBI R30,-LOW(1)
_0x1D3:
	STS  _kursorSpeed,R30
;     780         }
;     781         if (!sw_down)
_0xAE:
	SBIC 0x13,3
	RJMP _0xB1
;     782         {
;     783                 if (kursorSpeed == 1)
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x1)
	BRNE _0xB2
;     784                 {
;     785                         kursorSpeed = 2;
	LDI  R30,LOW(2)
	RJMP _0x1D4
;     786                 } else kursorSpeed--;
_0xB2:
	LDS  R30,_kursorSpeed
	SUBI R30,LOW(1)
_0x1D4:
	STS  _kursorSpeed,R30
;     787         }
;     788 
;     789         if (!sw_cancel)
_0xB1:
	SBIC 0x13,1
	RJMP _0xB4
;     790         {
;     791                 lcd_clear();
	CALL _lcd_clear
;     792                 goto menu02;
	RJMP _0x80
;     793         }
;     794 
;     795         goto setSpeed;
_0xB4:
	RJMP _0x84
;     796 
;     797      setGaris: // not yet
_0x89:
;     798         delay_ms(150);
	CALL SUBOPT_0x27
;     799         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     800                 // 0123456789ABCDEF
;     801         if ( WarnaGaris == 1 )
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0xB5
;     802                 lcd_putsf("  WARNA : Putih ");
	__POINTW1FN _0,435
	RJMP _0x1D5
;     803         else
_0xB5:
;     804                 lcd_putsf("  WARNA : Hitam ");
	__POINTW1FN _0,452
_0x1D5:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
;     805 
;     806         //lcd_putsf("  LEBAR: 1.5 cm ");
;     807         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     808         lcd_putsf("  SensL :        ");
	__POINTW1FN _0,469
	CALL SUBOPT_0x1
;     809         lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x2D
;     810         tampil( SensLine );
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _tampil
;     811 
;     812         switch (kursorGaris)
	LDS  R30,_kursorGaris
;     813         {
;     814           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0xBA
;     815                 lcd_gotoxy(0,0); // kursor Warna
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x1D6
;     816                 lcd_putchar(0);
;     817                 break;
;     818           case 2:
_0xBA:
	CPI  R30,LOW(0x2)
	BRNE _0xB9
;     819                 lcd_gotoxy(0,1); // kursor SensL
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x1D6:
	ST   -Y,R30
	CALL _lcd_gotoxy
;     820                 lcd_putchar(0);
	CALL SUBOPT_0x28
;     821                 break;
;     822         }
_0xB9:
;     823 
;     824         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xBC
;     825         {
;     826                 setByte( 3, kursorGaris);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDS  R30,_kursorGaris
	CALL SUBOPT_0x2C
;     827                 delay_ms(200);
;     828         }
;     829         if (!sw_up)
_0xBC:
	SBIC 0x13,2
	RJMP _0xBD
;     830         {
;     831                 if (kursorGaris == 2)
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x2)
	BRNE _0xBE
;     832                 {
;     833                         kursorGaris = 1;
	LDI  R30,LOW(1)
	RJMP _0x1D7
;     834                 } else kursorGaris++;
_0xBE:
	LDS  R30,_kursorGaris
	SUBI R30,-LOW(1)
_0x1D7:
	STS  _kursorGaris,R30
;     835         }
;     836         if (!sw_down)
_0xBD:
	SBIC 0x13,3
	RJMP _0xC0
;     837         {
;     838                 if (kursorGaris == 1)
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x1)
	BRNE _0xC1
;     839                 {
;     840                         kursorGaris = 2;
	LDI  R30,LOW(2)
	RJMP _0x1D8
;     841                 } else kursorGaris--;
_0xC1:
	LDS  R30,_kursorGaris
	SUBI R30,LOW(1)
_0x1D8:
	STS  _kursorGaris,R30
;     842         }
;     843 
;     844         if (!sw_cancel)
_0xC0:
	SBIC 0x13,1
	RJMP _0xC3
;     845         {
;     846                 lcd_clear();
	CALL _lcd_clear
;     847                 goto menu03;
	RJMP _0x87
;     848         }
;     849 
;     850         goto setGaris;
_0xC3:
	RJMP _0x89
;     851 
;     852      setSkenario:
_0x8E:
;     853         delay_ms(150);
	CALL SUBOPT_0x27
;     854         lcd_gotoxy(0,0);
	CALL SUBOPT_0x25
;     855                 // 0123456789ABCDEF
;     856         lcd_putsf("Sken. yg  dpake:");
	__POINTW1FN _0,487
	CALL SUBOPT_0x1
;     857         lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
;     858         tampil( Skenario );
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _tampil
;     859 
;     860         if (!sw_ok)
	SBIC 0x13,0
	RJMP _0xC4
;     861         {
;     862                 setByte( 4, 0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x2C
;     863                 delay_ms(200);
;     864         }
;     865 
;     866         if (!sw_cancel)
_0xC4:
	SBIC 0x13,1
	RJMP _0xC5
;     867         {
;     868                 lcd_clear();
	CALL _lcd_clear
;     869                 goto menu04;
	RJMP _0x8C
;     870         }
;     871 
;     872         goto setSkenario;
_0xC5:
	RJMP _0x8E
;     873 
;     874      mode:
_0x93:
;     875         delay_ms(125);
	CALL SUBOPT_0xD
;     876         if  (!sw_up)
	SBIC 0x13,2
	RJMP _0xC6
;     877         {
;     878             if (Mode==6)
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x6)
	BRNE _0xC7
;     879             {
;     880                 Mode=1;
	LDI  R30,LOW(1)
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMWRB
;     881             }
;     882 
;     883             else Mode++;
	RJMP _0xC8
_0xC7:
	CALL SUBOPT_0x2E
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
;     884 
;     885             goto nomorMode;
_0xC8:
	RJMP _0xC9
;     886         }
;     887 
;     888         if  (!sw_down)
_0xC6:
	SBIC 0x13,3
	RJMP _0xCA
;     889         {
;     890             if  (Mode==1)
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x1)
	BRNE _0xCB
;     891             {
;     892                 Mode=6;
	LDI  R30,LOW(6)
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMWRB
;     893             }
;     894 
;     895             else Mode--;
	RJMP _0xCC
_0xCB:
	CALL SUBOPT_0x2E
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
;     896 
;     897             goto nomorMode;
_0xCC:
;     898         }
;     899 
;     900         nomorMode:
_0xCA:
_0xC9:
;     901             if (Mode==1)
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x1)
	BRNE _0xCD
;     902             {
;     903                 lcd_clear();
	CALL SUBOPT_0x26
;     904                 lcd_gotoxy(0,0);
;     905                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     906                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     907                 lcd_putsf(" 1.Lihat ADC");
	__POINTW1FN _0,521
	CALL SUBOPT_0x1
;     908             }
;     909 
;     910             if  (Mode==2)
_0xCD:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x2)
	BRNE _0xCE
;     911             {
;     912                 lcd_clear();
	CALL SUBOPT_0x26
;     913                 lcd_gotoxy(0,0);
;     914                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     915                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     916                 lcd_putsf(" 2.Test Mode");
	__POINTW1FN _0,534
	CALL SUBOPT_0x1
;     917             }
;     918 
;     919             if  (Mode==3)
_0xCE:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x3)
	BRNE _0xCF
;     920             {
;     921                 lcd_clear();
	CALL SUBOPT_0x26
;     922                 lcd_gotoxy(0,0);
;     923                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     924                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     925                 lcd_putsf(" 3.Cek Sensor ");
	__POINTW1FN _0,547
	CALL SUBOPT_0x1
;     926             }
;     927 
;     928             if  (Mode==4)
_0xCF:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x4)
	BRNE _0xD0
;     929             {
;     930                 lcd_clear();
	CALL SUBOPT_0x26
;     931                 lcd_gotoxy(0,0);
;     932                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     933                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     934                 lcd_putsf(" 4.Auto Tune 1-1");
	__POINTW1FN _0,562
	CALL SUBOPT_0x1
;     935             }
;     936 
;     937              if  (Mode==5)
_0xD0:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x5)
	BRNE _0xD1
;     938             {
;     939                 lcd_clear();
	CALL SUBOPT_0x26
;     940                 lcd_gotoxy(0,0);
;     941                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     942                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     943                 lcd_putsf(" 5.Auto Tune ");
	__POINTW1FN _0,579
	CALL SUBOPT_0x1
;     944             }
;     945 
;     946             if  (Mode==6)
_0xD1:
	CALL SUBOPT_0x2E
	CPI  R30,LOW(0x6)
	BRNE _0xD2
;     947             {
;     948                 lcd_clear();
	CALL SUBOPT_0x26
;     949                 lcd_gotoxy(0,0);
;     950                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x2F
;     951                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     952                 lcd_putsf(" 6.Cek PWM Aktif");
	__POINTW1FN _0,593
	CALL SUBOPT_0x1
;     953             }
;     954 
;     955         if  (!sw_ok)
_0xD2:
	SBIC 0x13,0
	RJMP _0xD3
;     956         {
;     957             switch  (Mode)
	CALL SUBOPT_0x2E
;     958             {
;     959                 case 1:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0xD7
;     960                 {
;     961                     for(;;)
_0xD9:
;     962                     {
;     963                         lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x30
;     964                         sprintf(lcd,"  %d %d %d %d",read_adc(3),read_adc(2),read_adc(1),read_adc(0));
	CALL SUBOPT_0x31
	__POINTW1FN _0,610
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
;     965                         lcd_puts(lcd);
	CALL _lcd_puts
;     966                         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;     967                         sprintf(lcd,"%d %d %d %d",read_adc(7),read_adc(6),read_adc(5),read_adc(4));
	CALL SUBOPT_0x31
	__POINTW1FN _0,612
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
;     968                         lcd_puts(lcd);
	CALL _lcd_puts
;     969                         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
;     970                         lcd_clear();
	CALL _lcd_clear
;     971                     }
	RJMP _0xD9
;     972                 }
;     973                 break;
;     974 
;     975                 case 2:
_0xD7:
	CPI  R30,LOW(0x2)
	BRNE _0xDB
;     976                 {
;     977                     cek_sensor();
	RCALL _cek_sensor
;     978                 }
;     979                 break;
	RJMP _0xD6
;     980 
;     981                 case 3:
_0xDB:
	CPI  R30,LOW(0x3)
	BRNE _0xDC
;     982                 {
;     983                     cek_sensor();
	RCALL _cek_sensor
;     984                 }
;     985                 break;
	RJMP _0xD6
;     986 
;     987                 case 4:
_0xDC:
	CPI  R30,LOW(0x4)
	BRNE _0xDD
;     988                 {
;     989                     tune_batas();
	RCALL _tune_batas
;     990 
;     991                 }
;     992                 break;
	RJMP _0xD6
;     993 
;     994                 case 5:
_0xDD:
	CPI  R30,LOW(0x5)
	BRNE _0xDE
;     995                 {
;     996                     auto_scan();
	RCALL _auto_scan
;     997                     goto menu01;
	RJMP _0x7C
;     998                 }
;     999                 break;
;    1000 
;    1001                 case 6:
_0xDE:
	CPI  R30,LOW(0x6)
	BRNE _0xD6
;    1002                 {
;    1003                     pemercepat();
	CALL _pemercepat
;    1004                     pelambat();
	CALL _pelambat
;    1005                     goto menu01;
	RJMP _0x7C
;    1006                 }
;    1007                 break;
;    1008             }
_0xD6:
;    1009         }
;    1010 
;    1011         if  (!sw_cancel)
_0xD3:
	SBIC 0x13,1
	RJMP _0xE0
;    1012         {
;    1013             lcd_clear();
	CALL _lcd_clear
;    1014             goto menu05;
	RJMP _0x91
;    1015         }
;    1016 
;    1017         goto mode;
_0xE0:
	RJMP _0x93
;    1018 
;    1019      startRobot:
_0x97:
;    1020         //TIMSK = 0x01;
;    1021         #asm("sei")
	sei
;    1022         lcd_clear();
	CALL _lcd_clear
;    1023 }
	RET
;    1024 
;    1025 void displaySensorBit()
;    1026 {
_displaySensorBit:
;    1027     baca_sensor();
	CALL _baca_sensor
;    1028 
;    1029     lcd_gotoxy(2,1);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x2D
;    1030     if (s7) lcd_putchar('1');
	SBRS R2,7
	RJMP _0xE1
	LDI  R30,LOW(49)
	RJMP _0x1D9
;    1031     else    lcd_putchar('0');
_0xE1:
	LDI  R30,LOW(48)
_0x1D9:
	ST   -Y,R30
	CALL _lcd_putchar
;    1032     if (s6) lcd_putchar('1');
	SBRS R2,6
	RJMP _0xE3
	LDI  R30,LOW(49)
	RJMP _0x1DA
;    1033     else    lcd_putchar('0');
_0xE3:
	LDI  R30,LOW(48)
_0x1DA:
	ST   -Y,R30
	CALL _lcd_putchar
;    1034     if (s5) lcd_putchar('1');
	SBRS R2,5
	RJMP _0xE5
	LDI  R30,LOW(49)
	RJMP _0x1DB
;    1035     else    lcd_putchar('0');
_0xE5:
	LDI  R30,LOW(48)
_0x1DB:
	ST   -Y,R30
	CALL _lcd_putchar
;    1036     if (s4) lcd_putchar('1');
	SBRS R2,4
	RJMP _0xE7
	LDI  R30,LOW(49)
	RJMP _0x1DC
;    1037     else    lcd_putchar('0');
_0xE7:
	LDI  R30,LOW(48)
_0x1DC:
	ST   -Y,R30
	CALL _lcd_putchar
;    1038     if (s3) lcd_putchar('1');
	SBRS R2,3
	RJMP _0xE9
	LDI  R30,LOW(49)
	RJMP _0x1DD
;    1039     else    lcd_putchar('0');
_0xE9:
	LDI  R30,LOW(48)
_0x1DD:
	ST   -Y,R30
	CALL _lcd_putchar
;    1040     if (s2) lcd_putchar('1');
	SBRS R2,2
	RJMP _0xEB
	LDI  R30,LOW(49)
	RJMP _0x1DE
;    1041     else    lcd_putchar('0');
_0xEB:
	LDI  R30,LOW(48)
_0x1DE:
	ST   -Y,R30
	CALL _lcd_putchar
;    1042     if (s1) lcd_putchar('1');
	SBRS R2,1
	RJMP _0xED
	LDI  R30,LOW(49)
	RJMP _0x1DF
;    1043     else    lcd_putchar('0');
_0xED:
	LDI  R30,LOW(48)
_0x1DF:
	ST   -Y,R30
	CALL _lcd_putchar
;    1044     if (s0) lcd_putchar('1');
	SBRS R2,0
	RJMP _0xEF
	LDI  R30,LOW(49)
	RJMP _0x1E0
;    1045     else    lcd_putchar('0');
_0xEF:
	LDI  R30,LOW(48)
_0x1E0:
	ST   -Y,R30
	CALL _lcd_putchar
;    1046 }
	RET
;    1047 
;    1048 interrupt [TIM0_OVF] void timer0_ovf_isr(void)
;    1049 {
_timer0_ovf_isr:
	ST   -Y,R26
	ST   -Y,R27
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
;    1050         xcount++;
	LDS  R30,_xcount
	SUBI R30,-LOW(1)
	STS  _xcount,R30
;    1051         if(xcount<=lpwm)Enki=1; // PORTC.1 = 1;
	CALL SUBOPT_0xE
	CALL SUBOPT_0x34
	BRLT _0xF1
	SBI  0x12,4
;    1052         else Enki=0;  // PORTC.1 = 0;
	RJMP _0xF2
_0xF1:
	CBI  0x12,4
;    1053         if(xcount<=rpwm)Enka=1;
_0xF2:
	CALL SUBOPT_0x10
	CALL SUBOPT_0x34
	BRLT _0xF3
	SBI  0x12,5
;    1054         else Enka=0;
	RJMP _0xF4
_0xF3:
	CBI  0x12,5
;    1055         TCNT0=0xFF;
_0xF4:
	LDI  R30,LOW(255)
	OUT  0x32,R30
;    1056 }
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R27,Y+
	LD   R26,Y+
	RETI
;    1057 
;    1058 void maju(){kaplus=1;kamin=0;kirplus=1;kirmin=0;}
_maju:
	SBI  0x12,1
	CBI  0x12,0
	SBI  0x12,6
	CBI  0x12,3
	RET
;    1059 
;    1060 void mundur(){kaplus=0;kamin=1;kirplus=0;kirmin=1;}
_mundur:
	CBI  0x12,1
	SBI  0x12,0
	CBI  0x12,6
	SBI  0x12,3
	RET
;    1061 
;    1062 void bkan(){kaplus=0;kamin=0;kirplus=1;kirmin=0;}
_bkan:
	CBI  0x12,1
	CBI  0x12,0
	SBI  0x12,6
	CBI  0x12,3
	RET
;    1063 
;    1064 void bkir(){kaplus=1;kamin=0;kirplus=0;kirmin=0;}
_bkir:
	SBI  0x12,1
	CBI  0x12,0
	CBI  0x12,6
	CBI  0x12,3
	RET
;    1065 
;    1066 void rotkan(){kaplus=0;kamin=1;kirplus=1;kirmin=0;}
_rotkan:
	CBI  0x12,1
	SBI  0x12,0
	SBI  0x12,6
	CBI  0x12,3
	RET
;    1067 
;    1068 void rotkir(){kaplus=1;kamin=0;kirplus=0;kirmin=1;}
_rotkir:
	SBI  0x12,1
	CBI  0x12,0
	CBI  0x12,6
	SBI  0x12,3
	RET
;    1069 
;    1070 void stop(){ kaplus=0;kamin=0;kirplus=0;kirmin=0; }
_stop:
	CBI  0x12,1
	CBI  0x12,0
	CBI  0x12,6
	CBI  0x12,3
	RET
;    1071 
;    1072 void cek_sensor()
;    1073 {
_cek_sensor:
;    1074         int t;
;    1075 
;    1076         baca_sensor();
	ST   -Y,R17
	ST   -Y,R16
;	t -> R16,R17
	CALL _baca_sensor
;    1077         lcd_clear();
	CALL _lcd_clear
;    1078         delay_ms(125);
	CALL SUBOPT_0x0
;    1079                 // wait 125ms
;    1080         lcd_gotoxy(0,0);
;    1081                 //0123456789abcdef
;    1082         lcd_putsf(" Test:Sensor    ");
	__POINTW1FN _0,624
	CALL SUBOPT_0x1
;    1083 
;    1084         for (t=0; t<30000; t++) {displaySensorBit();}
	__GETWRN 16,17,0
_0xF6:
	__CPWRN 16,17,30000
	BRGE _0xF7
	CALL _displaySensorBit
	__ADDWRN 16,17,1
	RJMP _0xF6
_0xF7:
;    1085 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1086 
;    1087 void tune_batas()
;    1088 {
_tune_batas:
;    1089     lcd_clear();
	CALL _lcd_clear
;    1090     for(;;)
_0xF9:
;    1091     {
;    1092         read_adc(0);
	CALL SUBOPT_0x14
;    1093         if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_bb0
	CP   R26,R30
	BRSH _0xFB
	CALL SUBOPT_0x14
	STS  _bb0,R30
;    1094         if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
_0xFB:
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_ba0
	CP   R30,R26
	BRSH _0xFC
	CALL SUBOPT_0x14
	STS  _ba0,R30
;    1095 
;    1096         bt0=((bb0+ba0)/2);
_0xFC:
	CALL SUBOPT_0x35
;    1097 
;    1098         lcd_clear();
	CALL SUBOPT_0x36
;    1099         lcd_gotoxy(1,0);
;    1100         lcd_putsf(" bb0  ba0  bt0");
	__POINTW1FN _0,641
	CALL SUBOPT_0x1
;    1101         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1102         sprintf(lcd," %d  %d  %d",bb0,ba0,bt0);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x37
	LDS  R30,_bb0
	CALL SUBOPT_0x32
	LDS  R30,_ba0
	CALL SUBOPT_0x32
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
;    1103         lcd_puts(lcd);
	CALL SUBOPT_0x39
;    1104         delay_ms(50);
;    1105 
;    1106         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0xFD
;    1107         {
;    1108             delay_ms(125);
	CALL SUBOPT_0xD
;    1109             goto sensor1;
	RJMP _0xFE
;    1110         }
;    1111     }
_0xFD:
	RJMP _0xF9
;    1112     sensor1:
_0xFE:
;    1113     for(;;)
_0x100:
;    1114     {
;    1115         read_adc(1);
	CALL SUBOPT_0x15
;    1116         if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_bb1
	CP   R26,R30
	BRSH _0x102
	CALL SUBOPT_0x15
	STS  _bb1,R30
;    1117         if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
_0x102:
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_ba1
	CP   R30,R26
	BRSH _0x103
	CALL SUBOPT_0x15
	STS  _ba1,R30
;    1118 
;    1119         bt1=((bb1+ba1)/2);
_0x103:
	CALL SUBOPT_0x3A
;    1120 
;    1121         lcd_clear();
	CALL SUBOPT_0x36
;    1122         lcd_gotoxy(1,0);
;    1123         lcd_putsf(" bb1  ba1  bt1");
	__POINTW1FN _0,668
	CALL SUBOPT_0x1
;    1124         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1125         sprintf(lcd," %d  %d  %d",bb1,ba1,bt1);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x37
	LDS  R30,_bb1
	CALL SUBOPT_0x32
	LDS  R30,_ba1
	CALL SUBOPT_0x32
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
;    1126         lcd_puts(lcd);
	CALL SUBOPT_0x39
;    1127         delay_ms(50);
;    1128 
;    1129         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x104
;    1130         {
;    1131             delay_ms(150);
	CALL SUBOPT_0x27
;    1132             goto sensor2;
	RJMP _0x105
;    1133         }
;    1134     }
_0x104:
	RJMP _0x100
;    1135     sensor2:
_0x105:
;    1136     for(;;)
_0x107:
;    1137     {
;    1138         read_adc(2);
	CALL SUBOPT_0x16
;    1139         if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_bb2
	CP   R26,R30
	BRSH _0x109
	CALL SUBOPT_0x16
	STS  _bb2,R30
;    1140         if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
_0x109:
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_ba2
	CP   R30,R26
	BRSH _0x10A
	CALL SUBOPT_0x16
	STS  _ba2,R30
;    1141 
;    1142         bt2=((bb2+ba2)/2);
_0x10A:
	CALL SUBOPT_0x3B
;    1143 
;    1144         lcd_clear();
	CALL SUBOPT_0x36
;    1145         lcd_gotoxy(1,0);
;    1146         lcd_putsf(" bb2  ba2  bt2");
	__POINTW1FN _0,683
	CALL SUBOPT_0x1
;    1147         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1148         sprintf(lcd," %d  %d  %d",bb2,ba2,bt2);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x37
	LDS  R30,_bb2
	CALL SUBOPT_0x32
	LDS  R30,_ba2
	CALL SUBOPT_0x32
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
;    1149         lcd_puts(lcd);
	CALL SUBOPT_0x3C
;    1150         delay_ms(10);
;    1151 
;    1152         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x10B
;    1153         {
;    1154             delay_ms(150);
	CALL SUBOPT_0x27
;    1155             goto sensor3;
	RJMP _0x10C
;    1156         }
;    1157     }
_0x10B:
	RJMP _0x107
;    1158     sensor3:
_0x10C:
;    1159     for(;;)
_0x10E:
;    1160     {
;    1161         read_adc(3);
	CALL SUBOPT_0x17
;    1162         if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_bb3
	CP   R26,R30
	BRSH _0x110
	CALL SUBOPT_0x17
	STS  _bb3,R30
;    1163         if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
_0x110:
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_ba3
	CP   R30,R26
	BRSH _0x111
	CALL SUBOPT_0x17
	STS  _ba3,R30
;    1164 
;    1165         bt3=((bb3+ba3)/2);
_0x111:
	CALL SUBOPT_0x3D
;    1166 
;    1167         lcd_clear();
	CALL SUBOPT_0x36
;    1168         lcd_gotoxy(1,0);
;    1169         lcd_putsf(" bb3  ba3  bt3");
	__POINTW1FN _0,698
	CALL SUBOPT_0x1
;    1170         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1171         sprintf(lcd," %d  %d  %d",bb3,ba3,bt3);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x37
	LDS  R30,_bb3
	CALL SUBOPT_0x32
	LDS  R30,_ba3
	CALL SUBOPT_0x32
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
;    1172         lcd_puts(lcd);
	CALL SUBOPT_0x3C
;    1173         delay_ms(10);
;    1174 
;    1175         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x112
;    1176         {
;    1177             delay_ms(150);
	CALL SUBOPT_0x27
;    1178             goto sensor4;
	RJMP _0x113
;    1179         }
;    1180     }
_0x112:
	RJMP _0x10E
;    1181     sensor4:
_0x113:
;    1182     for(;;)
_0x115:
;    1183     {
;    1184         read_adc(4);
	CALL SUBOPT_0x18
;    1185         if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_bb4
	CP   R26,R30
	BRSH _0x117
	CALL SUBOPT_0x18
	STS  _bb4,R30
;    1186         if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
_0x117:
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_ba4
	CP   R30,R26
	BRSH _0x118
	CALL SUBOPT_0x18
	STS  _ba4,R30
;    1187 
;    1188         bt4=((bb4+ba4)/2);
_0x118:
	CALL SUBOPT_0x3E
;    1189 
;    1190         lcd_clear();
	CALL SUBOPT_0x36
;    1191         lcd_gotoxy(1,0);
;    1192         lcd_putsf(" bb4  ba4  bt4");
	__POINTW1FN _0,713
	CALL SUBOPT_0x1
;    1193         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1194         sprintf(lcd," %d  %d  %d",bb4,ba4,bt4);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x37
	LDS  R30,_bb4
	CALL SUBOPT_0x32
	LDS  R30,_ba4
	CALL SUBOPT_0x32
	CALL SUBOPT_0x20
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
;    1195         lcd_puts(lcd);
	CALL SUBOPT_0x3C
;    1196         delay_ms(10);
;    1197 
;    1198         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x119
;    1199         {
;    1200             delay_ms(150);
	CALL SUBOPT_0x27
;    1201             goto sensor5;
	RJMP _0x11A
;    1202         }
;    1203     }
_0x119:
	RJMP _0x115
;    1204     sensor5:
_0x11A:
;    1205     for(;;)
_0x11C:
;    1206     {
;    1207         read_adc(5);
	CALL SUBOPT_0x19
;    1208         if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_bb5
	CP   R26,R30
	BRSH _0x11E
	CALL SUBOPT_0x19
	STS  _bb5,R30
;    1209         if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
_0x11E:
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_ba5
	CP   R30,R26
	BRSH _0x11F
	CALL SUBOPT_0x19
	STS  _ba5,R30
;    1210 
;    1211         bt5=((bb5+ba5)/2);
_0x11F:
	CALL SUBOPT_0x3F
;    1212 
;    1213         lcd_clear();
	CALL SUBOPT_0x36
;    1214         lcd_gotoxy(1,0);
;    1215         lcd_putsf(" bb5  ba5  bt5");
	__POINTW1FN _0,728
	CALL SUBOPT_0x1
;    1216         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1217         sprintf(lcd," %d  %d  %d",bb5,ba5,bt5);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x37
	LDS  R30,_bb5
	CALL SUBOPT_0x32
	LDS  R30,_ba5
	CALL SUBOPT_0x32
	CALL SUBOPT_0x21
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
;    1218         lcd_puts(lcd);
	CALL SUBOPT_0x3C
;    1219         delay_ms(10);
;    1220 
;    1221         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x120
;    1222         {
;    1223             delay_ms(150);
	CALL SUBOPT_0x27
;    1224             goto sensor6;
	RJMP _0x121
;    1225         }
;    1226     }
_0x120:
	RJMP _0x11C
;    1227     sensor6:
_0x121:
;    1228     for(;;)
_0x123:
;    1229     {
;    1230         read_adc(06);
	CALL SUBOPT_0x1A
;    1231         if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_bb6
	CP   R26,R30
	BRSH _0x125
	CALL SUBOPT_0x1A
	STS  _bb6,R30
;    1232         if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
_0x125:
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_ba6
	CP   R30,R26
	BRSH _0x126
	CALL SUBOPT_0x1A
	STS  _ba6,R30
;    1233 
;    1234         bt6=((bb6+ba6)/2);
_0x126:
	CALL SUBOPT_0x40
;    1235 
;    1236         lcd_clear();
	CALL SUBOPT_0x36
;    1237         lcd_gotoxy(1,0);
;    1238         lcd_putsf(" bb6  ba6  bt6");
	__POINTW1FN _0,743
	CALL SUBOPT_0x1
;    1239         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1240         sprintf(lcd," %d  %d  %d",bb6,ba6,bt6);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x37
	LDS  R30,_bb6
	CALL SUBOPT_0x32
	LDS  R30,_ba6
	CALL SUBOPT_0x32
	CALL SUBOPT_0x22
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
;    1241         lcd_puts(lcd);
	CALL SUBOPT_0x3C
;    1242         delay_ms(10);
;    1243 
;    1244         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x127
;    1245         {
;    1246             delay_ms(150);
	CALL SUBOPT_0x27
;    1247             goto sensor7;
	RJMP _0x128
;    1248         }
;    1249     }
_0x127:
	RJMP _0x123
;    1250     sensor7:
_0x128:
;    1251     for(;;)
_0x12A:
;    1252     {
;    1253         read_adc(7);
	CALL SUBOPT_0x1B
;    1254         if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
	CALL SUBOPT_0x1B
	MOV  R26,R30
	LDS  R30,_bb7
	CP   R26,R30
	BRSH _0x12C
	CALL SUBOPT_0x1B
	STS  _bb7,R30
;    1255         if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
_0x12C:
	CALL SUBOPT_0x1B
	CP   R12,R30
	BRSH _0x12D
	CALL SUBOPT_0x1B
	MOV  R12,R30
;    1256 
;    1257         bt7=((bb7+ba7)/2);
_0x12D:
	CALL SUBOPT_0x41
;    1258 
;    1259         lcd_clear();
;    1260         lcd_gotoxy(1,0);
;    1261         lcd_putsf(" bb7  ba7  bt7");
	__POINTW1FN _0,758
	CALL SUBOPT_0x1
;    1262         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x2D
;    1263         sprintf(lcd," %d  %d  %d",bb7,ba7,bt7);
	CALL SUBOPT_0x31
	CALL SUBOPT_0x37
	LDS  R30,_bb7
	CALL SUBOPT_0x32
	MOV  R30,R12
	CALL SUBOPT_0x32
	CALL SUBOPT_0x23
	CALL SUBOPT_0x32
	CALL SUBOPT_0x38
;    1264         lcd_puts(lcd);
	CALL SUBOPT_0x3C
;    1265         delay_ms(10);
;    1266 
;    1267         if(!sw_ok)
	SBIC 0x13,0
	RJMP _0x12E
;    1268         {
;    1269             delay_ms(150);
	CALL SUBOPT_0x27
;    1270             goto selesai;
	RJMP _0x12F
;    1271         }
;    1272     }
_0x12E:
	RJMP _0x12A
;    1273     selesai:
_0x12F:
;    1274     lcd_clear();
	CALL _lcd_clear
;    1275 }
	RET
;    1276 
;    1277 void auto_scan()
;    1278 {
_auto_scan:
;    1279     for(;;)
_0x131:
;    1280     {
;    1281     read_adc(0);
	CALL SUBOPT_0x14
;    1282         if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_bb0
	CP   R26,R30
	BRSH _0x133
	CALL SUBOPT_0x14
	STS  _bb0,R30
;    1283         if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
_0x133:
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_ba0
	CP   R30,R26
	BRSH _0x134
	CALL SUBOPT_0x14
	STS  _ba0,R30
;    1284 
;    1285         bt0=((bb0+ba0)/2);
_0x134:
	CALL SUBOPT_0x35
;    1286 
;    1287     read_adc(1);
	CALL SUBOPT_0x15
;    1288         if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_bb1
	CP   R26,R30
	BRSH _0x135
	CALL SUBOPT_0x15
	STS  _bb1,R30
;    1289         if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
_0x135:
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_ba1
	CP   R30,R26
	BRSH _0x136
	CALL SUBOPT_0x15
	STS  _ba1,R30
;    1290 
;    1291         bt1=((bb1+ba1)/2);
_0x136:
	CALL SUBOPT_0x3A
;    1292 
;    1293     read_adc(2);
	CALL SUBOPT_0x16
;    1294         if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_bb2
	CP   R26,R30
	BRSH _0x137
	CALL SUBOPT_0x16
	STS  _bb2,R30
;    1295         if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
_0x137:
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_ba2
	CP   R30,R26
	BRSH _0x138
	CALL SUBOPT_0x16
	STS  _ba2,R30
;    1296 
;    1297         bt2=((bb2+ba2)/2);
_0x138:
	CALL SUBOPT_0x3B
;    1298 
;    1299     read_adc(3);
	CALL SUBOPT_0x17
;    1300         if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_bb3
	CP   R26,R30
	BRSH _0x139
	CALL SUBOPT_0x17
	STS  _bb3,R30
;    1301         if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
_0x139:
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_ba3
	CP   R30,R26
	BRSH _0x13A
	CALL SUBOPT_0x17
	STS  _ba3,R30
;    1302 
;    1303         bt3=((bb3+ba3)/2);
_0x13A:
	CALL SUBOPT_0x3D
;    1304 
;    1305     read_adc(4);
	CALL SUBOPT_0x18
;    1306         if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_bb4
	CP   R26,R30
	BRSH _0x13B
	CALL SUBOPT_0x18
	STS  _bb4,R30
;    1307         if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
_0x13B:
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_ba4
	CP   R30,R26
	BRSH _0x13C
	CALL SUBOPT_0x18
	STS  _ba4,R30
;    1308 
;    1309         bt4=((bb4+ba4)/2);
_0x13C:
	CALL SUBOPT_0x3E
;    1310 
;    1311     read_adc(5);
	CALL SUBOPT_0x19
;    1312         if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_bb5
	CP   R26,R30
	BRSH _0x13D
	CALL SUBOPT_0x19
	STS  _bb5,R30
;    1313         if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
_0x13D:
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_ba5
	CP   R30,R26
	BRSH _0x13E
	CALL SUBOPT_0x19
	STS  _ba5,R30
;    1314 
;    1315         bt5=((bb5+ba5)/2);
_0x13E:
	CALL SUBOPT_0x3F
;    1316 
;    1317     read_adc(6);
	CALL SUBOPT_0x1A
;    1318         if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_bb6
	CP   R26,R30
	BRSH _0x13F
	CALL SUBOPT_0x1A
	STS  _bb6,R30
;    1319         if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
_0x13F:
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_ba6
	CP   R30,R26
	BRSH _0x140
	CALL SUBOPT_0x1A
	STS  _ba6,R30
;    1320 
;    1321         bt6=((bb6+ba6)/2);
_0x140:
	CALL SUBOPT_0x40
;    1322 
;    1323     read_adc(7);
	CALL SUBOPT_0x1B
;    1324         if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
	CALL SUBOPT_0x1B
	MOV  R26,R30
	LDS  R30,_bb7
	CP   R26,R30
	BRSH _0x141
	CALL SUBOPT_0x1B
	STS  _bb7,R30
;    1325         if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
_0x141:
	CALL SUBOPT_0x1B
	CP   R12,R30
	BRSH _0x142
	CALL SUBOPT_0x1B
	MOV  R12,R30
;    1326 
;    1327         bt7=((bb7+ba7)/2);
_0x142:
	CALL SUBOPT_0x41
;    1328 
;    1329         lcd_clear();
;    1330         lcd_gotoxy(1,0);
;    1331         sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
	CALL SUBOPT_0x31
	__POINTW1FN _0,773
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x23
	CALL SUBOPT_0x32
	CALL SUBOPT_0x22
	CALL SUBOPT_0x32
	CALL SUBOPT_0x21
	CALL SUBOPT_0x32
	CALL SUBOPT_0x20
	CALL SUBOPT_0x32
	CALL SUBOPT_0x1F
	CALL SUBOPT_0x32
	CALL SUBOPT_0x1E
	CALL SUBOPT_0x32
	CALL SUBOPT_0x1D
	CALL SUBOPT_0x32
	CALL SUBOPT_0x1C
	CALL SUBOPT_0x32
	LDI  R24,32
	CALL _sprintf
	ADIW R28,36
;    1332         lcd_puts(lcd);
	CALL SUBOPT_0x31
	CALL _lcd_puts
;    1333         delay_ms(120);
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x4
;    1334 
;    1335         if (!sw_ok){showMenu();}
	SBIC 0x13,0
	RJMP _0x143
	CALL _showMenu
;    1336     }
_0x143:
	RJMP _0x131
;    1337 }
;    1338 
;    1339 int x;

	.DSEG
_x:
	.BYTE 0x2
;    1340 void ikuti_garis()
;    1341 {

	.CSEG
_ikuti_garis:
;    1342     baca_sensor();
	CALL _baca_sensor
;    1343 
;    1344     // MAXSpeed-Kp*
;    1345 
;    1346     if(sensor==0b00000001){bkan();      error = 15;     x=1;}  //kanan
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x144
	CALL _bkan
	LDI  R30,LOW(15)
	LDI  R31,HIGH(15)
	CALL SUBOPT_0x42
;    1347     if(sensor==0b00000011){bkan();      error = 10;     x=1;}
_0x144:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x145
	CALL _bkan
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x42
;    1348     if(sensor==0b00000010){maju();      error = 8;      x=1;}
_0x145:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x146
	CALL _maju
	LDI  R30,LOW(8)
	LDI  R31,HIGH(8)
	CALL SUBOPT_0x42
;    1349     if(sensor==0b00000110){maju();      error = 5;      x=1;}
_0x146:
	LDI  R30,LOW(6)
	CP   R30,R5
	BRNE _0x147
	CALL _maju
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x42
;    1350     if(sensor==0b00000100){maju();      error = 3;      x=1;}
_0x147:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x148
	CALL _maju
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CALL SUBOPT_0x42
;    1351     if(sensor==0b00001100){maju();      error = 2;      x=1;}
_0x148:
	LDI  R30,LOW(12)
	CP   R30,R5
	BRNE _0x149
	CALL _maju
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	CALL SUBOPT_0x42
;    1352     if(sensor==0b00001000){maju();      error = 1;      x=1;}
_0x149:
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x14A
	CALL _maju
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	CALL SUBOPT_0x42
;    1353 
;    1354     //if(sensor==0b00011000){maju();rpwm=75;lpwm=75;}  //tengah
;    1355 
;    1356     if(sensor==0b00010000){maju();      error = -1;     x=0;}
_0x14A:
	LDI  R30,LOW(16)
	CP   R30,R5
	BRNE _0x14B
	CALL _maju
	LDI  R30,LOW(65535)
	LDI  R31,HIGH(65535)
	CALL SUBOPT_0x43
;    1357     if(sensor==0b00110000){maju();      error = -2;     x=0;}
_0x14B:
	LDI  R30,LOW(48)
	CP   R30,R5
	BRNE _0x14C
	CALL _maju
	LDI  R30,LOW(65534)
	LDI  R31,HIGH(65534)
	CALL SUBOPT_0x43
;    1358     if(sensor==0b00100000){maju();      error = -3;     x=0;}
_0x14C:
	LDI  R30,LOW(32)
	CP   R30,R5
	BRNE _0x14D
	CALL _maju
	LDI  R30,LOW(65533)
	LDI  R31,HIGH(65533)
	CALL SUBOPT_0x43
;    1359     if(sensor==0b01100000){maju();      error = -5;     x=0;}
_0x14D:
	LDI  R30,LOW(96)
	CP   R30,R5
	BRNE _0x14E
	CALL _maju
	LDI  R30,LOW(65531)
	LDI  R31,HIGH(65531)
	CALL SUBOPT_0x43
;    1360     if(sensor==0b01000000){maju();      error = -8;     x=0;}
_0x14E:
	LDI  R30,LOW(64)
	CP   R30,R5
	BRNE _0x14F
	CALL _maju
	LDI  R30,LOW(65528)
	LDI  R31,HIGH(65528)
	CALL SUBOPT_0x43
;    1361     if(sensor==0b11000000){bkir();      error = -10;    x=0;}
_0x14F:
	LDI  R30,LOW(192)
	CP   R30,R5
	BRNE _0x150
	CALL _bkir
	LDI  R30,LOW(65526)
	LDI  R31,HIGH(65526)
	CALL SUBOPT_0x43
;    1362     if(sensor==0b10000000){bkir();      error = -15;    x=0;}  //kiri
_0x150:
	LDI  R30,LOW(128)
	CP   R30,R5
	BRNE _0x151
	CALL _bkir
	LDI  R30,LOW(65521)
	LDI  R31,HIGH(65521)
	CALL SUBOPT_0x43
;    1363 
;    1364         d_error =error-last_error;
_0x151:
	LDS  R26,_last_error
	LDS  R27,_last_error+1
	CALL SUBOPT_0x44
	SUB  R30,R26
	SBC  R31,R27
	STS  _d_error,R30
	STS  _d_error+1,R31
;    1365         PV      =(Kp*error)+(Kd*d_error);
	CALL SUBOPT_0x6
	MOV  R26,R30
	CALL SUBOPT_0x44
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
;    1366 
;    1367         rpwm=i_speed+PV;
	LDS  R26,_i_speed
	LDS  R27,_i_speed+1
	ADD  R30,R26
	ADC  R31,R27
	CALL SUBOPT_0x11
;    1368         lpwm=i_speed-PV;
	LDS  R26,_PV
	LDS  R27,_PV+1
	LDS  R30,_i_speed
	LDS  R31,_i_speed+1
	SUB  R30,R26
	SBC  R31,R27
	CALL SUBOPT_0xF
;    1369 
;    1370         last_error=error;
	CALL SUBOPT_0x44
	STS  _last_error,R30
	STS  _last_error+1,R31
;    1371 
;    1372     /*if(sensor==0b00000000)                                  //lepas
;    1373     {
;    1374         if(x)
;    1375         {
;    1376             stop();rotkan();rpwm=150;lpwm=150;
;    1377         }
;    1378 
;    1379         else
;    1380         {
;    1381             stop();rotkir();rpwm=150;lpwm=150;
;    1382         }
;    1383     }
;    1384 
;    1385     //sudutkanan
;    1386     sensor&=0b00001011;
;    1387     if(sensor==0b00001011)
;    1388     {
;    1389         stop();
;    1390         delay_ms(2);
;    1391         sensor&=0b00001111;
;    1392         if(sensor==0b00001111)
;    1393         {
;    1394             delay_ms(2);
;    1395             sensor&=0b00001110;
;    1396             if(sensor==0b00001110)
;    1397             {
;    1398                 delay_ms(2);
;    1399                 sensor&=0b00001100;
;    1400                 if(sensor==0b00001100)
;    1401                 {
;    1402                     bkan();rpwm=0;lpwm=250;
;    1403                 }
;    1404             }
;    1405         }
;    1406     }
;    1407 
;    1408 
;    1409     //sudutkiri
;    1410     sensor&=0b11010000;
;    1411     if(sensor==0b11010000)
;    1412     {
;    1413         stop();
;    1414         delay_ms(2);
;    1415         sensor&=0b11110000;
;    1416         if(sensor==0b11110000)
;    1417         {
;    1418             delay_ms(2);
;    1419             sensor&=0b01110000;
;    1420             if(sensor==0b01110000)
;    1421             {
;    1422                 delay_ms(2);
;    1423                 sensor&=0b00110000;
;    1424                 if(sensor==0b00110000)
;    1425                 {
;    1426                     bkir();rpwm=250;lpwm=0;
;    1427                 }
;    1428             }
;    1429         }
;    1430     }*/
;    1431 
;    1432     if(lpwm>=255)       lpwm = 255;
	LDS  R26,_lpwm
	LDS  R27,_lpwm+1
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	BRLT _0x152
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0xF
;    1433     if(lpwm<=0)         lpwm = 0;
_0x152:
	LDS  R26,_lpwm
	LDS  R27,_lpwm+1
	CALL __CPW02
	BRLT _0x153
	LDI  R30,0
	STS  _lpwm,R30
	STS  _lpwm+1,R30
;    1434 
;    1435     if(rpwm>=255)       rpwm = 255;
_0x153:
	LDS  R26,_rpwm
	LDS  R27,_rpwm+1
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	BRLT _0x154
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x11
;    1436     if(rpwm<=0)         rpwm = 0;
_0x154:
	LDS  R26,_rpwm
	LDS  R27,_rpwm+1
	CALL __CPW02
	BRLT _0x155
	LDI  R30,0
	STS  _rpwm,R30
	STS  _rpwm+1,R30
;    1437 
;    1438     sprintf(lcd_buffer,"%d   %d",lpwm, rpwm);
_0x155:
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,797
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
;    1439     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x25
;    1440     lcd_putsf("                ");
	__POINTW1FN _0,805
	CALL SUBOPT_0x1
;    1441     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x25
;    1442     lcd_puts(lcd_buffer);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;    1443     delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x4
;    1444 }
	RET

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
	BREQ _0x156
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x158
	__CPWRN 16,17,2
	BRLO _0x159
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x158:
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
_0x159:
	RJMP _0x15A
_0x156:
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _putchar
_0x15A:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__print_G2:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
_0x15B:
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
	JMP _0x15D
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x161
	CPI  R18,37
	BRNE _0x162
	LDI  R17,LOW(1)
	RJMP _0x163
_0x162:
	CALL SUBOPT_0x45
_0x163:
	RJMP _0x160
_0x161:
	CPI  R30,LOW(0x1)
	BRNE _0x164
	CPI  R18,37
	BRNE _0x165
	CALL SUBOPT_0x45
	RJMP _0x1E1
_0x165:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x166
	LDI  R16,LOW(1)
	RJMP _0x160
_0x166:
	CPI  R18,43
	BRNE _0x167
	LDI  R20,LOW(43)
	RJMP _0x160
_0x167:
	CPI  R18,32
	BRNE _0x168
	LDI  R20,LOW(32)
	RJMP _0x160
_0x168:
	RJMP _0x169
_0x164:
	CPI  R30,LOW(0x2)
	BRNE _0x16A
_0x169:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x16B
	ORI  R16,LOW(128)
	RJMP _0x160
_0x16B:
	RJMP _0x16C
_0x16A:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x160
_0x16C:
	CPI  R18,48
	BRLO _0x16F
	CPI  R18,58
	BRLO _0x170
_0x16F:
	RJMP _0x16E
_0x170:
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x160
_0x16E:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x174
	CALL SUBOPT_0x46
	LD   R30,X
	CALL SUBOPT_0x47
	RJMP _0x175
_0x174:
	CPI  R30,LOW(0x73)
	BRNE _0x177
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
	CALL _strlen
	MOV  R17,R30
	RJMP _0x178
_0x177:
	CPI  R30,LOW(0x70)
	BRNE _0x17A
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x178:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x17B
_0x17A:
	CPI  R30,LOW(0x64)
	BREQ _0x17E
	CPI  R30,LOW(0x69)
	BRNE _0x17F
_0x17E:
	ORI  R16,LOW(4)
	RJMP _0x180
_0x17F:
	CPI  R30,LOW(0x75)
	BRNE _0x181
_0x180:
	LDI  R30,LOW(_tbl10_G2*2)
	LDI  R31,HIGH(_tbl10_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x182
_0x181:
	CPI  R30,LOW(0x58)
	BRNE _0x184
	ORI  R16,LOW(8)
	RJMP _0x185
_0x184:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x1B6
_0x185:
	LDI  R30,LOW(_tbl16_G2*2)
	LDI  R31,HIGH(_tbl16_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x182:
	SBRS R16,2
	RJMP _0x187
	CALL SUBOPT_0x46
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,0
	BRGE _0x188
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x188:
	CPI  R20,0
	BREQ _0x189
	SUBI R17,-LOW(1)
	RJMP _0x18A
_0x189:
	ANDI R16,LOW(251)
_0x18A:
	RJMP _0x18B
_0x187:
	CALL SUBOPT_0x46
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x18B:
_0x17B:
	SBRC R16,0
	RJMP _0x18C
_0x18D:
	CP   R17,R21
	BRSH _0x18F
	SBRS R16,7
	RJMP _0x190
	SBRS R16,2
	RJMP _0x191
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x192
_0x191:
	LDI  R18,LOW(48)
_0x192:
	RJMP _0x193
_0x190:
	LDI  R18,LOW(32)
_0x193:
	CALL SUBOPT_0x45
	SUBI R21,LOW(1)
	RJMP _0x18D
_0x18F:
_0x18C:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x194
_0x195:
	CPI  R19,0
	BREQ _0x197
	SBRS R16,3
	RJMP _0x198
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x1E2
_0x198:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x1E2:
	ST   -Y,R30
	CALL SUBOPT_0x49
	CPI  R21,0
	BREQ _0x19A
	SUBI R21,LOW(1)
_0x19A:
	SUBI R19,LOW(1)
	RJMP _0x195
_0x197:
	RJMP _0x19B
_0x194:
_0x19D:
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
_0x19F:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x1A1
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x19F
_0x1A1:
	CPI  R18,58
	BRLO _0x1A2
	SBRS R16,3
	RJMP _0x1A3
	SUBI R18,-LOW(7)
	RJMP _0x1A4
_0x1A3:
	SUBI R18,-LOW(39)
_0x1A4:
_0x1A2:
	SBRC R16,4
	RJMP _0x1A6
	CPI  R18,49
	BRSH _0x1A8
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x1A7
_0x1A8:
	RJMP _0x1E3
_0x1A7:
	CP   R21,R19
	BRLO _0x1AC
	SBRS R16,0
	RJMP _0x1AD
_0x1AC:
	RJMP _0x1AB
_0x1AD:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x1AE
	LDI  R18,LOW(48)
_0x1E3:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x1AF
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x49
	CPI  R21,0
	BREQ _0x1B0
	SUBI R21,LOW(1)
_0x1B0:
_0x1AF:
_0x1AE:
_0x1A6:
	CALL SUBOPT_0x45
	CPI  R21,0
	BREQ _0x1B1
	SUBI R21,LOW(1)
_0x1B1:
_0x1AB:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x19E
	RJMP _0x19D
_0x19E:
_0x19B:
	SBRS R16,0
	RJMP _0x1B2
_0x1B3:
	CPI  R21,0
	BREQ _0x1B5
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x47
	RJMP _0x1B3
_0x1B5:
_0x1B2:
_0x1B6:
_0x175:
_0x1E1:
	LDI  R17,LOW(0)
_0x160:
	RJMP _0x15B
_0x15D:
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
	BRSH _0x1B8
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
_0x1B8:
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
_0x1B9:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x1BB
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x1B9
_0x1BB:
	LDD  R17,Y+0
	RJMP _0x1C1
_lcd_putsf:
	ST   -Y,R17
_0x1BC:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x1BE
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x1BC
_0x1BE:
	LDD  R17,Y+0
_0x1C1:
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
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x4A
	CALL SUBOPT_0x4A
	CALL __long_delay_G3
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL __lcd_init_write_G3
	CALL __long_delay_G3
	LDI  R30,LOW(40)
	CALL SUBOPT_0x4B
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4B
	LDI  R30,LOW(133)
	CALL SUBOPT_0x4B
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G3
	CPI  R30,LOW(0x5)
	BREQ _0x1BF
	LDI  R30,LOW(0)
	RJMP _0x1C0
_0x1BF:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x1C0:
	ADIW R28,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:87 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 54 TIMES, CODE SIZE REDUCTION:103 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _lcd_putsf

;OPTIMIZER ADDED SUBROUTINE, CALLED 21 TIMES, CODE SIZE REDUCTION:77 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 35 TIMES, CODE SIZE REDUCTION:65 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
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
	__POINTW1FN _0,120
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1C:
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1D:
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1E:
	LDI  R26,LOW(_bt2)
	LDI  R27,HIGH(_bt2)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x1F:
	LDI  R26,LOW(_bt3)
	LDI  R27,HIGH(_bt3)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x20:
	LDI  R26,LOW(_bt4)
	LDI  R27,HIGH(_bt4)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	LDI  R26,LOW(_bt5)
	LDI  R27,HIGH(_bt5)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	LDI  R26,LOW(_bt6)
	LDI  R27,HIGH(_bt6)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x25:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x26:
	CALL _lcd_clear
	RJMP SUBOPT_0x25

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x27:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
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
	__POINTW1FN _0,504
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x30:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x31:
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:114 WORDS
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x35:
	LDS  R30,_ba0
	LDS  R26,_bb0
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt0)
	LDI  R27,HIGH(_bt0)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x36:
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x30

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x37:
	__POINTW1FN _0,656
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x38:
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RJMP SUBOPT_0x31

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x39:
	CALL _lcd_puts
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3A:
	LDS  R30,_ba1
	LDS  R26,_bb1
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt1)
	LDI  R27,HIGH(_bt1)
	CALL __EEPROMWRB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3B:
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
SUBOPT_0x3C:
	CALL _lcd_puts
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x3D:
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
SUBOPT_0x3E:
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
SUBOPT_0x3F:
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
SUBOPT_0x40:
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
SUBOPT_0x41:
	MOV  R30,R12
	LDS  R26,_bb7
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	LDI  R26,LOW(_bt7)
	LDI  R27,HIGH(_bt7)
	CALL __EEPROMWRB
	RJMP SUBOPT_0x36

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:45 WORDS
SUBOPT_0x42:
	STS  _error,R30
	STS  _error+1,R31
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _x,R30
	STS  _x+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x43:
	STS  _error,R30
	STS  _error+1,R31
	LDI  R30,0
	STS  _x,R30
	STS  _x+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x44:
	LDS  R30,_error
	LDS  R31,_error+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x45:
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
SUBOPT_0x46:
	LDD  R26,Y+16
	LDD  R27,Y+16+1
	SBIW R26,4
	STD  Y+16,R26
	STD  Y+16+1,R27
	ADIW R26,4
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x47:
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
SUBOPT_0x48:
	CALL __GETW1P
	STD  Y+6,R30
	STD  Y+6+1,R31
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x49:
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
SUBOPT_0x4A:
	CALL __long_delay_G3
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4B:
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
