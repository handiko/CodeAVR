
;CodeVisionAVR C Compiler V1.25.3 Professional
;(C) Copyright 1998-2007 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type              : ATmega16
;Program type           : Application
;Clock frequency        : 12.000000 MHz
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

	.INCLUDE "Fix penyisihan2.vec"
	.INCLUDE "Fix penyisihan2.inc"

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
;      29 #define sw_ok     PINB.1
;      30 #define sw_cancel PINB.0
;      31 #define sw_up     PINB.3
;      32 #define sw_down   PINB.2
;      33 
;      34 #define sKi  PINB.5
;      35 #define sKa  PINB.6
;      36 
;      37 #define Enki PORTD.4
;      38 #define kirplus PORTD.6
;      39 #define kirmin PORTD.3
;      40 #define Enka PORTD.5
;      41 #define kaplus PORTD.1
;      42 #define kamin PORTD.0
;      43 
;      44 #define ADC_VREF_TYPE 0x20
;      45 
;      46 // Alphanumeric LCD Module functions
;      47 #asm
;      48    .equ __lcd_port=0x15 ;PORTC
   .equ __lcd_port=0x15 ;PORTC
;      49 #endasm
;      50 
;      51 char lcd[16];
_lcd:
	.BYTE 0x10
;      52 unsigned char sensor, adc0, adc1, adc2, adc3, adc4, adc5, adc6, adc7;
;      53 //unsigned char b7=37,b6=50,b5=9,b4=10,b3=8,b2=15,b1=25,b0=30;
;      54 unsigned char bt7=7,bt6=7,bt5=7,bt4=7,bt3=7,bt2=7,bt1=7,bt0=9;
_bt6:
	.BYTE 0x1
_bt5:
	.BYTE 0x1
_bt4:
	.BYTE 0x1
_bt3:
	.BYTE 0x1
_bt2:
	.BYTE 0x1
_bt1:
	.BYTE 0x1
_bt0:
	.BYTE 0x1
;      55 unsigned char ba7=7,ba6=7,ba5=7,ba4=7,ba3=7,ba2=7,ba1=7,ba0=9;
_ba7:
	.BYTE 0x1
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
;      56 unsigned char bb7=7,bb6=7,bb5=7,bb4=7,bb3=7,bb2=7,bb1=7,bb0=9;
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
;      57 unsigned char xcount;
_xcount:
	.BYTE 0x1
;      58 bit s0,s1,s2,s3,s4,s5,s6,s7;
;      59 int lpwm, rpwm, MAXPWM=255, MINPWM=0, intervalPWM;
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
;      60 typedef unsigned char byte;
;      61 int PV, error, last_error;
_PV:
	.BYTE 0x2
_error:
	.BYTE 0x2
_last_error:
	.BYTE 0x2
;      62 int var_Kp, var_Ki, var_Kd;
_var_Kp:
	.BYTE 0x2
_var_Ki:
	.BYTE 0x2
_var_Kd:
	.BYTE 0x2
;      63 byte kursorPID, kursorSpeed, kursorGaris;
_kursorPID:
	.BYTE 0x1
_kursorSpeed:
	.BYTE 0x1
_kursorGaris:
	.BYTE 0x1
;      64 char lcd_buffer[33];
_lcd_buffer:
	.BYTE 0x21
;      65 int b;
_b:
	.BYTE 0x2
;      66 
;      67 eeprom byte Kp = 20;

	.ESEG
_Kp:
	.DB  0x14
;      68 eeprom byte Ki = 10;
_Ki:
	.DB  0xA
;      69 eeprom byte Kd = 15;
_Kd:
	.DB  0xF
;      70 eeprom byte MAXSpeed = 255;
_MAXSpeed:
	.DB  0xFF
;      71 eeprom byte MINSpeed = 0;
_MINSpeed:
	.DB  0x0
;      72 eeprom byte WarnaGaris = 0; // 1 : putih; 0 : hitam
_WarnaGaris:
	.DB  0x0
;      73 eeprom byte SensLine = 2; // banyaknya sensor dlm 1 garis
_SensLine:
	.DB  0x2
;      74 eeprom byte Skenario = 2;
_Skenario:
	.DB  0x2
;      75 eeprom byte Mode = 1;
_Mode:
	.DB  0x1
;      76 
;      77 void showMenu();
;      78 void displaySensorBit();
;      79 void maju();
;      80 void mundur();
;      81 void bkan();
;      82 void bkir();
;      83 void rotkan();
;      84 void rotkir();
;      85 void stop();
;      86 void ikuti_garis();
;      87 void cek_sensor();
;      88 void baca_sensor();
;      89 void tune_batas();
;      90 void auto_scan();
;      91 void pemercepat();
;      92 void pelambat();
;      93 void TesBlink();
;      94 
;      95 unsigned char read_adc(unsigned char adc_input)
;      96 {

	.CSEG
_read_adc:
;      97     ADMUX=adc_input | (ADC_VREF_TYPE & 0xff);
;	adc_input -> Y+0
	LD   R30,Y
	ORI  R30,0x20
	OUT  0x7,R30
;      98     // Delay needed for the stabilization of the ADC input voltage
;      99     delay_us(10);
	__DELAY_USB 40
;     100     // Start the AD conversion
;     101     ADCSRA|=0x40;
	SBI  0x6,6
;     102     // Wait for the AD conversion to complete
;     103     while ((ADCSRA & 0x10)==0);
_0x1C:
	SBIS 0x6,4
	RJMP _0x1C
;     104     ADCSRA|=0x10;
	SBI  0x6,4
;     105     return ADCH;
	IN   R30,0x5
	ADIW R28,1
	RET
;     106 }
;     107 
;     108 
;     109 flash byte char0[8]=
;     110 {
;     111     0b1100000,
;     112     0b0011000,
;     113     0b0000110,
;     114     0b1111111,
;     115     0b1111111,
;     116     0b0000110,
;     117     0b0011000,
;     118     0b1100000
;     119 };
;     120 
;     121 void define_char(byte flash *pc,byte char_code)
;     122 {
_define_char:
;     123     byte i,a;
;     124     a=(char_code<<3) | 0x40;
	ST   -Y,R17
	ST   -Y,R16
;	*pc -> Y+3
;	char_code -> Y+2
;	i -> R17
;	a -> R16
	LDD  R30,Y+2
	LSL  R30
	LSL  R30
	LSL  R30
	ORI  R30,0x40
	MOV  R16,R30
;     125     for (i=0; i<8; i++) lcd_write_byte(a++,*pc++);
	LDI  R17,LOW(0)
_0x20:
	CPI  R17,8
	BRSH _0x21
	ST   -Y,R16
	INC  R16
	LDD  R30,Y+4
	LDD  R31,Y+4+1
	ADIW R30,1
	STD  Y+4,R30
	STD  Y+4+1,R31
	SBIW R30,1
	LPM  R30,Z
	ST   -Y,R30
	CALL _lcd_write_byte
;     126 }
	SUBI R17,-1
	RJMP _0x20
_0x21:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,5
	RET
;     127 
;     128 void main(void)
;     129 {
_main:
;     130 PORTA=0x00;
	LDI  R30,LOW(0)
	OUT  0x1B,R30
;     131 DDRA=0x00;
	OUT  0x1A,R30
;     132 
;     133 PORTB=0x0F;
	LDI  R30,LOW(15)
	OUT  0x18,R30
;     134 DDRB=0x00;
	LDI  R30,LOW(0)
	OUT  0x17,R30
;     135 
;     136 PORTC=0x00;
	OUT  0x15,R30
;     137 DDRC=0x00;
	OUT  0x14,R30
;     138 
;     139 PORTD=0x00;
	OUT  0x12,R30
;     140 DDRD=0xFF;
	LDI  R30,LOW(255)
	OUT  0x11,R30
;     141 
;     142 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
;     143 TCNT0=0x00;
	OUT  0x32,R30
;     144 OCR0=0x00;
	OUT  0x3C,R30
;     145 
;     146 TCCR1A=0x00;
	OUT  0x2F,R30
;     147 TCCR1B=0x00;
	OUT  0x2E,R30
;     148 TCNT1H=0x00;
	OUT  0x2D,R30
;     149 TCNT1L=0x00;
	OUT  0x2C,R30
;     150 ICR1H=0x00;
	OUT  0x27,R30
;     151 ICR1L=0x00;
	OUT  0x26,R30
;     152 OCR1AH=0x00;
	OUT  0x2B,R30
;     153 OCR1AL=0x00;
	OUT  0x2A,R30
;     154 OCR1BH=0x00;
	OUT  0x29,R30
;     155 OCR1BL=0x00;
	OUT  0x28,R30
;     156 
;     157 ASSR=0x00;
	OUT  0x22,R30
;     158 TCCR2=0x00;
	OUT  0x25,R30
;     159 TCNT2=0x00;
	OUT  0x24,R30
;     160 OCR2=0x00;
	OUT  0x23,R30
;     161 
;     162 MCUCR=0x00;
	OUT  0x35,R30
;     163 MCUCSR=0x00;
	OUT  0x34,R30
;     164 
;     165 TIMSK=0x01;
	LDI  R30,LOW(1)
	OUT  0x39,R30
;     166 
;     167 ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
;     168 SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
;     169 
;     170 ADMUX=ADC_VREF_TYPE & 0xff;
	LDI  R30,LOW(32)
	OUT  0x7,R30
;     171 ADCSRA=0x84;
	LDI  R30,LOW(132)
	OUT  0x6,R30
;     172 
;     173 lcd_init(16);
	LDI  R30,LOW(16)
	ST   -Y,R30
	CALL _lcd_init
;     174 
;     175 define_char(char0,0);
	LDI  R30,LOW(_char0*2)
	LDI  R31,HIGH(_char0*2)
	ST   -Y,R31
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _define_char
;     176 
;     177 TCCR0=0x00;
	LDI  R30,LOW(0)
	OUT  0x33,R30
;     178 stop();
	RCALL _stop
;     179 
;     180 delay_ms(125);
	CALL SUBOPT_0x0
;     181 lcd_gotoxy(0,0);
;     182         // 0123456789ABCDEF
;     183 lcd_putsf("  baru_belajar  ");
	__POINTW1FN _0,0
	CALL SUBOPT_0x1
;     184 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     185 lcd_putsf("      by :      ");
	__POINTW1FN _0,17
	CALL SUBOPT_0x1
;     186 delay_ms(500);
	CALL SUBOPT_0x3
;     187 lcd_clear();
;     188 
;     189 delay_ms(125);
	CALL SUBOPT_0x0
;     190 lcd_gotoxy(0,0);
;     191         // 0123456789ABCDEF
;     192 lcd_putsf(" ############## ");
	__POINTW1FN _0,34
	CALL SUBOPT_0x1
;     193 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     194 lcd_putsf(" Handiko Gesang ");
	__POINTW1FN _0,51
	CALL SUBOPT_0x1
;     195 delay_ms(1300);
	LDI  R30,LOW(1300)
	LDI  R31,HIGH(1300)
	CALL SUBOPT_0x4
;     196 lcd_clear();
	CALL _lcd_clear
;     197 
;     198 delay_ms(125);
	CALL SUBOPT_0x0
;     199 lcd_gotoxy(0,0);
;     200         // 0123456789ABCDEF
;     201 lcd_putsf(" TEKNIK FISIKA ");
	__POINTW1FN _0,68
	CALL SUBOPT_0x1
;     202 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     203 lcd_putsf("------UGM------");
	__POINTW1FN _0,84
	CALL SUBOPT_0x1
;     204 delay_ms(500);
	CALL SUBOPT_0x3
;     205 lcd_clear();
;     206 
;     207 TCCR0=0x05;
	LDI  R30,LOW(5)
	OUT  0x33,R30
;     208 #asm("sei")
	sei
;     209 
;     210 //                    <<-----------SEMI RESET-----------<<
;     211 stop();
	RCALL _stop
;     212 // read eeprom
;     213 var_Kp  = Kp;
	CALL SUBOPT_0x5
	LDI  R31,0
	STS  _var_Kp,R30
	STS  _var_Kp+1,R31
;     214 var_Ki  = Ki;
	CALL SUBOPT_0x6
	LDI  R31,0
	STS  _var_Ki,R30
	STS  _var_Ki+1,R31
;     215 var_Kd  = Kd;
	CALL SUBOPT_0x7
	LDI  R31,0
	STS  _var_Kd,R30
	STS  _var_Kd+1,R31
;     216 MAXPWM  = (int)MAXSpeed + 1;
	CALL SUBOPT_0x8
	LDI  R31,0
	ADIW R30,1
	STS  _MAXPWM,R30
	STS  _MAXPWM+1,R31
;     217 MINPWM  = MINSpeed;
	CALL SUBOPT_0x9
	LDI  R31,0
	STS  _MINPWM,R30
	STS  _MINPWM+1,R31
;     218 
;     219 intervalPWM = (MAXSpeed - MINSpeed) / 8;
	CALL SUBOPT_0x8
	MOV  R0,R30
	CALL SUBOPT_0x9
	MOV  R26,R0
	SUB  R26,R30
	MOV  R30,R26
	LSR  R30
	LSR  R30
	LSR  R30
	LDI  R31,0
	STS  _intervalPWM,R30
	STS  _intervalPWM+1,R31
;     220 PV = 0;
	LDI  R30,0
	STS  _PV,R30
	STS  _PV+1,R30
;     221 error = 0;
	LDI  R30,0
	STS  _error,R30
	STS  _error+1,R30
;     222 last_error = 0;
	LDI  R30,0
	STS  _last_error,R30
	STS  _last_error+1,R30
;     223 
;     224 showMenu();
	RCALL _showMenu
;     225 maju();
	RCALL _maju
;     226 //pemercepat();
;     227 //pelambat();
;     228 displaySensorBit();
	RCALL _displaySensorBit
;     229 while (1)
_0x22:
;     230       {
;     231             displaySensorBit();
	RCALL _displaySensorBit
;     232             ikuti_garis();
	CALL _ikuti_garis
;     233       };
	RJMP _0x22
;     234 }
_0x25:
	RJMP _0x25
;     235 
;     236 void TesBlink()
;     237 {
;     238     for(;;)
;     239     {
;     240         lcd_gotoxy(1,0);
;     241         lcd_putsf("Tes Blink");
;     242         lcd_gotoxy(1,1);
;     243         lcd_putsf("Tes Blink");
;     244         delay_ms(500);
;     245         lcd_gotoxy(1,1);
;     246         lcd_putsf("         ");
;     247         delay_ms(500);
;     248         lcd_clear();
;     249     }
;     250 }
;     251 
;     252 
;     253 void pemercepat()
;     254 {
_pemercepat:
;     255         lpwm=0;
	CALL SUBOPT_0xA
;     256         rpwm=0;
;     257 
;     258         rotkir();
	RCALL _rotkir
;     259 
;     260         for(b=0;b<255;b++)
	LDI  R30,0
	STS  _b,R30
	STS  _b+1,R30
_0x2A:
	CALL SUBOPT_0xB
	BRGE _0x2B
;     261         {
;     262             delay_ms(125);
	CALL SUBOPT_0xC
;     263 
;     264             lpwm++;
	CALL SUBOPT_0xD
	ADIW R30,1
	CALL SUBOPT_0xE
;     265             rpwm++;
	CALL SUBOPT_0xF
	ADIW R30,1
	CALL SUBOPT_0x10
;     266 
;     267             lcd_clear();
	CALL SUBOPT_0x11
;     268 
;     269             lcd_gotoxy(0,0);
;     270             sprintf(lcd," %d %d",lpwm,rpwm);
;     271             lcd_puts(lcd);
;     272         }
	CALL SUBOPT_0x12
	RJMP _0x2A
_0x2B:
;     273         lpwm=0;
	CALL SUBOPT_0xA
;     274         rpwm=0;
;     275 }
	RET
;     276 
;     277 void pelambat()
;     278 {
_pelambat:
;     279         lpwm=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0xE
;     280         rpwm=255;
	LDI  R30,LOW(255)
	LDI  R31,HIGH(255)
	CALL SUBOPT_0x10
;     281 
;     282         rotkan();
	RCALL _rotkan
;     283 
;     284         for(b=0;b<255;b++)
	LDI  R30,0
	STS  _b,R30
	STS  _b+1,R30
_0x2D:
	CALL SUBOPT_0xB
	BRGE _0x2E
;     285         {
;     286             delay_ms(125);
	CALL SUBOPT_0xC
;     287 
;     288             lpwm--;
	CALL SUBOPT_0xD
	SBIW R30,1
	CALL SUBOPT_0xE
;     289             rpwm--;
	CALL SUBOPT_0xF
	SBIW R30,1
	CALL SUBOPT_0x10
;     290 
;     291             lcd_clear();
	CALL SUBOPT_0x11
;     292 
;     293             lcd_gotoxy(0,0);
;     294             sprintf(lcd," %d %d",lpwm,rpwm);
;     295             lcd_puts(lcd);
;     296         }
	CALL SUBOPT_0x12
	RJMP _0x2D
_0x2E:
;     297         lpwm=0;
	CALL SUBOPT_0xA
;     298         rpwm=0;
;     299 }
	RET
;     300 
;     301 void baca_sensor()
;     302 {
_baca_sensor:
;     303     sensor=0;
	CLR  R5
;     304     adc0=read_adc(0);
	CALL SUBOPT_0x13
	MOV  R4,R30
;     305     adc1=read_adc(1);
	CALL SUBOPT_0x14
	MOV  R7,R30
;     306     adc2=read_adc(2);
	CALL SUBOPT_0x15
	MOV  R6,R30
;     307     adc3=read_adc(3);
	CALL SUBOPT_0x16
	MOV  R9,R30
;     308     adc4=read_adc(4);
	CALL SUBOPT_0x17
	MOV  R8,R30
;     309     adc5=read_adc(5);
	CALL SUBOPT_0x18
	MOV  R11,R30
;     310     adc6=read_adc(6);
	CALL SUBOPT_0x19
	MOV  R10,R30
;     311     adc7=read_adc(7);
	CALL SUBOPT_0x1A
	MOV  R13,R30
;     312 
;     313     if(adc0>bt0){s0=1;sensor=sensor|1<<0;}
	LDS  R30,_bt0
	CP   R30,R4
	BRSH _0x2F
	SET
	BLD  R2,0
	LDI  R30,LOW(1)
	RJMP _0x1D1
;     314     else {s0=0;sensor=sensor|0<<0;}
_0x2F:
	CLT
	BLD  R2,0
	LDI  R30,LOW(0)
_0x1D1:
	OR   R5,R30
;     315 
;     316     if(adc1>bt1){s1=1;sensor=sensor|1<<1;}
	LDS  R30,_bt1
	CP   R30,R7
	BRSH _0x31
	SET
	BLD  R2,1
	LDI  R30,LOW(2)
	RJMP _0x1D2
;     317     else {s1=0;sensor=sensor|0<<1;}
_0x31:
	CLT
	BLD  R2,1
	LDI  R30,LOW(0)
_0x1D2:
	OR   R5,R30
;     318 
;     319     if(adc2>bt2){s2=1;sensor=sensor|1<<2;}
	LDS  R30,_bt2
	CP   R30,R6
	BRSH _0x33
	SET
	BLD  R2,2
	LDI  R30,LOW(4)
	RJMP _0x1D3
;     320     else {s2=0;sensor=sensor|0<<2;}
_0x33:
	CLT
	BLD  R2,2
	LDI  R30,LOW(0)
_0x1D3:
	OR   R5,R30
;     321 
;     322     if(adc3>bt3){s3=1;sensor=sensor|1<<3;}
	LDS  R30,_bt3
	CP   R30,R9
	BRSH _0x35
	SET
	BLD  R2,3
	LDI  R30,LOW(8)
	RJMP _0x1D4
;     323     else {s3=0;sensor=sensor|0<<3;}
_0x35:
	CLT
	BLD  R2,3
	LDI  R30,LOW(0)
_0x1D4:
	OR   R5,R30
;     324 
;     325     if(adc4>bt4){s4=1;sensor=sensor|1<<4;}
	LDS  R30,_bt4
	CP   R30,R8
	BRSH _0x37
	SET
	BLD  R2,4
	LDI  R30,LOW(16)
	RJMP _0x1D5
;     326     else {s4=0;sensor=sensor|0<<4;}
_0x37:
	CLT
	BLD  R2,4
	LDI  R30,LOW(0)
_0x1D5:
	OR   R5,R30
;     327 
;     328     if(adc5>bt5){s5=1;sensor=sensor|1<<5;}
	LDS  R30,_bt5
	CP   R30,R11
	BRSH _0x39
	SET
	BLD  R2,5
	LDI  R30,LOW(32)
	RJMP _0x1D6
;     329     else {s5=0;sensor=sensor|0<<5;}
_0x39:
	CLT
	BLD  R2,5
	LDI  R30,LOW(0)
_0x1D6:
	OR   R5,R30
;     330 
;     331     if(adc6>bt6){s6=1;sensor=sensor|1<<6;}
	LDS  R30,_bt6
	CP   R30,R10
	BRSH _0x3B
	SET
	BLD  R2,6
	LDI  R30,LOW(64)
	RJMP _0x1D7
;     332     else {s6=0;sensor=sensor|0<<6;}
_0x3B:
	CLT
	BLD  R2,6
	LDI  R30,LOW(0)
_0x1D7:
	OR   R5,R30
;     333 
;     334     if(adc7>bt7){s7=1;sensor=sensor|1<<7;}
	CP   R12,R13
	BRSH _0x3D
	SET
	BLD  R2,7
	LDI  R30,LOW(128)
	RJMP _0x1D8
;     335     else {s7=0;sensor=sensor|0<<7;}
_0x3D:
	CLT
	BLD  R2,7
	LDI  R30,LOW(0)
_0x1D8:
	OR   R5,R30
;     336 }
	RET
;     337 
;     338 void tampil(unsigned char dat)
;     339 {
_tampil:
;     340     unsigned char data;
;     341 
;     342     data = dat / 100;
	ST   -Y,R17
;	dat -> Y+1
;	data -> R17
	LDD  R26,Y+1
	LDI  R30,LOW(100)
	CALL SUBOPT_0x1B
;     343     data+=0x30;
;     344     lcd_putchar(data);
;     345 
;     346     dat%=100;
	LDI  R30,LOW(100)
	CALL __MODB21U
	STD  Y+1,R30
;     347     data = dat / 10;
	LDD  R26,Y+1
	LDI  R30,LOW(10)
	CALL SUBOPT_0x1B
;     348     data+=0x30;
;     349     lcd_putchar(data);
;     350 
;     351     dat%=10;
	LDI  R30,LOW(10)
	CALL __MODB21U
	STD  Y+1,R30
;     352     data = dat + 0x30;
	SUBI R30,-LOW(48)
	MOV  R17,R30
;     353     lcd_putchar(data);
	ST   -Y,R17
	CALL _lcd_putchar
;     354 }
	LDD  R17,Y+0
	ADIW R28,2
	RET
;     355 
;     356 void tulisKeEEPROM ( byte NoMenu, byte NoSubMenu, byte var_in_eeprom )
;     357 {
_tulisKeEEPROM:
;     358         lcd_gotoxy(0,0);
;	NoMenu -> Y+2
;	NoSubMenu -> Y+1
;	var_in_eeprom -> Y+0
	CALL SUBOPT_0x1C
;     359         lcd_putsf("Tulis ke EEPROM ");
	__POINTW1FN _0,127
	CALL SUBOPT_0x1
;     360         lcd_putsf("...             ");
	__POINTW1FN _0,144
	CALL SUBOPT_0x1
;     361         switch (NoMenu)
	LDD  R30,Y+2
;     362         {
;     363           case 1: // PID
	CPI  R30,LOW(0x1)
	BRNE _0x42
;     364                 switch (NoSubMenu)
	LDD  R30,Y+1
;     365                 {
;     366                   case 1: // Kp
	CPI  R30,LOW(0x1)
	BRNE _0x46
;     367                         Kp = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL __EEPROMWRB
;     368                         break;
	RJMP _0x45
;     369                   case 2: // Ki
_0x46:
	CPI  R30,LOW(0x2)
	BRNE _0x47
;     370                         Ki = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMWRB
;     371                         break;
	RJMP _0x45
;     372                   case 3: // Kd
_0x47:
	CPI  R30,LOW(0x3)
	BRNE _0x45
;     373                         Kd = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL __EEPROMWRB
;     374                         break;
;     375                 }
_0x45:
;     376                 break;
	RJMP _0x41
;     377           case 2: // Speed
_0x42:
	CPI  R30,LOW(0x2)
	BRNE _0x49
;     378                 switch (NoSubMenu)
	LDD  R30,Y+1
;     379                 {
;     380                   case 1: // MAX
	CPI  R30,LOW(0x1)
	BRNE _0x4D
;     381                         MAXSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL __EEPROMWRB
;     382                         break;
	RJMP _0x4C
;     383                   case 2: // MIN
_0x4D:
	CPI  R30,LOW(0x2)
	BRNE _0x4C
;     384                         MINSpeed = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL __EEPROMWRB
;     385                         break;
;     386                 }
_0x4C:
;     387                 break;
	RJMP _0x41
;     388           case 3: // Warna Garis
_0x49:
	CPI  R30,LOW(0x3)
	BRNE _0x4F
;     389                 switch (NoSubMenu)
	LDD  R30,Y+1
;     390                 {
;     391                   case 1: // Warna
	CPI  R30,LOW(0x1)
	BRNE _0x53
;     392                         WarnaGaris = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMWRB
;     393                         break;
	RJMP _0x52
;     394                   case 2: // SensL
_0x53:
	CPI  R30,LOW(0x2)
	BRNE _0x52
;     395                         SensLine = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMWRB
;     396                         break;
;     397                 }
_0x52:
;     398                 break;
	RJMP _0x41
;     399           case 4: // Skenario
_0x4F:
	CPI  R30,LOW(0x4)
	BRNE _0x41
;     400                 Skenario = var_in_eeprom;
	LD   R30,Y
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMWRB
;     401                 break;
;     402         }
_0x41:
;     403         delay_ms(200);
	CALL SUBOPT_0x1D
;     404 }
	ADIW R28,3
	RET
;     405 
;     406 void setByte( byte NoMenu, byte NoSubMenu )
;     407 {
_setByte:
;     408         byte var_in_eeprom;
;     409         byte plus5 = 0;
;     410         char limitPilih = -1;
;     411 
;     412         lcd_clear();
	CALL __SAVELOCR4
;	NoMenu -> Y+5
;	NoSubMenu -> Y+4
;	var_in_eeprom -> R17
;	plus5 -> R16
;	limitPilih -> R19
	LDI  R16,0
	LDI  R19,255
	CALL SUBOPT_0x1E
;     413         lcd_gotoxy(0, 0);
;     414         switch (NoMenu)
	LDD  R30,Y+5
;     415         {
;     416           case 1: // PID
	CPI  R30,LOW(0x1)
	BRNE _0x59
;     417                 switch (NoSubMenu)
	LDD  R30,Y+4
;     418                 {
;     419                   case 1: // Kp
	CPI  R30,LOW(0x1)
	BRNE _0x5D
;     420                         lcd_putsf("Set Kp :        ");
	__POINTW1FN _0,161
	CALL SUBOPT_0x1
;     421                         var_in_eeprom = Kp;
	CALL SUBOPT_0x5
	RJMP _0x1D9
;     422                         break;
;     423                   case 2: // Ki
_0x5D:
	CPI  R30,LOW(0x2)
	BRNE _0x5E
;     424                         lcd_putsf("Set Ki :        ");
	__POINTW1FN _0,178
	CALL SUBOPT_0x1
;     425                         var_in_eeprom = Ki;
	CALL SUBOPT_0x6
	RJMP _0x1D9
;     426                         break;
;     427                   case 3: // Kd
_0x5E:
	CPI  R30,LOW(0x3)
	BRNE _0x5C
;     428                         lcd_putsf("Set Kd :        ");
	__POINTW1FN _0,195
	CALL SUBOPT_0x1
;     429                         var_in_eeprom = Kd;
	CALL SUBOPT_0x7
_0x1D9:
	MOV  R17,R30
;     430                         break;
;     431                 }
_0x5C:
;     432                 break;
	RJMP _0x58
;     433           case 2: // Speed
_0x59:
	CPI  R30,LOW(0x2)
	BRNE _0x60
;     434                 plus5 = 1;
	LDI  R16,LOW(1)
;     435                 switch (NoSubMenu)
	LDD  R30,Y+4
;     436                 {
;     437                   case 1: // MAX
	CPI  R30,LOW(0x1)
	BRNE _0x64
;     438                         lcd_putsf("Set MAX Speed : ");
	__POINTW1FN _0,212
	CALL SUBOPT_0x1
;     439                         var_in_eeprom = MAXSpeed;
	CALL SUBOPT_0x8
	RJMP _0x1DA
;     440                         break;
;     441                   case 2: // MIN
_0x64:
	CPI  R30,LOW(0x2)
	BRNE _0x63
;     442                         lcd_putsf("Set MIN Speed : ");
	__POINTW1FN _0,229
	CALL SUBOPT_0x1
;     443                         var_in_eeprom = MINSpeed;
	CALL SUBOPT_0x9
_0x1DA:
	MOV  R17,R30
;     444                         break;
;     445                 }
_0x63:
;     446                 break;
	RJMP _0x58
;     447           case 3: // Warna Garis
_0x60:
	CPI  R30,LOW(0x3)
	BRNE _0x66
;     448                 switch (NoSubMenu)
	LDD  R30,Y+4
;     449                 {
;     450                   case 1: // Warna
	CPI  R30,LOW(0x1)
	BRNE _0x6A
;     451                         limitPilih = 1;
	LDI  R19,LOW(1)
;     452                         lcd_putsf("Warna Garis   : ");
	__POINTW1FN _0,246
	CALL SUBOPT_0x1
;     453                         var_in_eeprom = WarnaGaris;
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	RJMP _0x1DB
;     454                         break;
;     455                   case 2: // SensL
_0x6A:
	CPI  R30,LOW(0x2)
	BRNE _0x69
;     456                         limitPilih = 3;
	LDI  R19,LOW(3)
;     457                         lcd_putsf("SensLine :      ");
	__POINTW1FN _0,263
	CALL SUBOPT_0x1
;     458                         var_in_eeprom = SensLine;
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
_0x1DB:
	MOV  R17,R30
;     459                         break;
;     460                 }
_0x69:
;     461                 break;
	RJMP _0x58
;     462           case 4: // Skenario
_0x66:
	CPI  R30,LOW(0x4)
	BRNE _0x58
;     463                   lcd_putsf("Skenario :      ");
	__POINTW1FN _0,280
	CALL SUBOPT_0x1
;     464                   var_in_eeprom = Skenario;
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	MOV  R17,R30
;     465                   limitPilih = 8;
	LDI  R19,LOW(8)
;     466                   break;
;     467         }
_0x58:
;     468 
;     469         while (sw_cancel)
_0x6D:
	SBIS 0x16,0
	RJMP _0x6F
;     470         {
;     471                 delay_ms(150);
	CALL SUBOPT_0x1F
;     472                 lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
;     473                 tampil(var_in_eeprom);
	ST   -Y,R17
	CALL _tampil
;     474 
;     475                 if (!sw_ok)
	SBIC 0x16,1
	RJMP _0x70
;     476                 {
;     477                         lcd_clear();
	CALL _lcd_clear
;     478                         tulisKeEEPROM( NoMenu, NoSubMenu, var_in_eeprom );
	LDD  R30,Y+5
	ST   -Y,R30
	LDD  R30,Y+5
	ST   -Y,R30
	ST   -Y,R17
	CALL _tulisKeEEPROM
;     479                         goto exitSetByte;
	RJMP _0x71
;     480                 }
;     481                 if (!sw_down)
_0x70:
	SBIC 0x16,2
	RJMP _0x72
;     482                 {
;     483                         if ( plus5 )
	CPI  R16,0
	BREQ _0x73
;     484                                 if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x74
;     485                                         var_in_eeprom = 255;
	LDI  R17,LOW(255)
;     486                                 else
	RJMP _0x75
_0x74:
;     487                                         var_in_eeprom -= 5;
	SUBI R17,LOW(5)
;     488                         else
_0x75:
	RJMP _0x76
_0x73:
;     489                                 if ( !limitPilih )
	CPI  R19,0
	BRNE _0x77
;     490                                         var_in_eeprom--;
	RJMP _0x1DC
;     491                                 else
_0x77:
;     492                                 {
;     493                                         if ( var_in_eeprom == 0 )
	CPI  R17,0
	BRNE _0x79
;     494                                           var_in_eeprom = limitPilih;
	MOV  R17,R19
;     495                                         else
	RJMP _0x7A
_0x79:
;     496                                           var_in_eeprom--;
_0x1DC:
	SUBI R17,1
;     497                                 }
_0x7A:
_0x76:
;     498                 }
;     499                 if (!sw_up)
_0x72:
	SBIC 0x16,3
	RJMP _0x7B
;     500                 {
;     501                         if ( plus5 )
	CPI  R16,0
	BREQ _0x7C
;     502                                 if ( var_in_eeprom == 255 )
	CPI  R17,255
	BRNE _0x7D
;     503                                         var_in_eeprom = 0;
	LDI  R17,LOW(0)
;     504                                 else
	RJMP _0x7E
_0x7D:
;     505                                         var_in_eeprom += 5;
	SUBI R17,-LOW(5)
;     506                         else
_0x7E:
	RJMP _0x7F
_0x7C:
;     507                                 if ( !limitPilih )
	CPI  R19,0
	BRNE _0x80
;     508                                         var_in_eeprom++;
	RJMP _0x1DD
;     509                                 else
_0x80:
;     510                                 {
;     511                                         if ( var_in_eeprom == limitPilih )
	CP   R19,R17
	BRNE _0x82
;     512                                           var_in_eeprom = 0;
	LDI  R17,LOW(0)
;     513                                         else
	RJMP _0x83
_0x82:
;     514                                           var_in_eeprom++;
_0x1DD:
	SUBI R17,-1
;     515                                 }
_0x83:
_0x7F:
;     516                 }
;     517         }
_0x7B:
	RJMP _0x6D
_0x6F:
;     518       exitSetByte:
_0x71:
;     519         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
;     520         lcd_clear();
	CALL _lcd_clear
;     521 }
	CALL __LOADLOCR4
	ADIW R28,6
	RET
;     522 
;     523 void showMenu()
;     524 {
_showMenu:
;     525         lcd_clear();
	CALL _lcd_clear
;     526     menu01:
_0x84:
;     527         delay_ms(125);   // bouncing sw
	CALL SUBOPT_0x0
;     528         lcd_gotoxy(0,0);
;     529                 // 0123456789abcdef
;     530         lcd_putsf("  Set PID       ");
	__POINTW1FN _0,297
	CALL SUBOPT_0x1
;     531         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     532         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0,314
	CALL SUBOPT_0x1
;     533 
;     534         // kursor awal
;     535         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1C
;     536         lcd_putchar(0);
	CALL SUBOPT_0x20
;     537 
;     538         if (!sw_ok)
	SBIC 0x16,1
	RJMP _0x85
;     539         {
;     540                 lcd_clear();
	CALL _lcd_clear
;     541                 kursorPID = 1;
	LDI  R30,LOW(1)
	STS  _kursorPID,R30
;     542                 goto setPID;
	RJMP _0x86
;     543         }
;     544         if (!sw_down)
_0x85:
	SBIS 0x16,2
;     545         {
;     546                 goto menu02;
	RJMP _0x88
;     547         }
;     548         if (!sw_up)
	SBIC 0x16,3
	RJMP _0x89
;     549         {
;     550                 lcd_clear();
	CALL _lcd_clear
;     551                 goto menu06;
	RJMP _0x8A
;     552         }
;     553 
;     554         goto menu01;
_0x89:
	RJMP _0x84
;     555     menu02:
_0x88:
;     556         delay_ms(125);
	CALL SUBOPT_0x0
;     557         lcd_gotoxy(0,0);
;     558                  // 0123456789abcdef
;     559         lcd_putsf("  Set PID       ");
	__POINTW1FN _0,297
	CALL SUBOPT_0x1
;     560         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     561         lcd_putsf("  Set Speed     ");
	__POINTW1FN _0,314
	CALL SUBOPT_0x1
;     562 
;     563         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     564         lcd_putchar(0);
	CALL SUBOPT_0x20
;     565 
;     566         if (!sw_ok)
	SBIC 0x16,1
	RJMP _0x8B
;     567         {
;     568                 lcd_clear();
	CALL _lcd_clear
;     569                 kursorSpeed = 1;
	LDI  R30,LOW(1)
	STS  _kursorSpeed,R30
;     570                 goto setSpeed;
	RJMP _0x8C
;     571         }
;     572         if (!sw_up)
_0x8B:
	SBIS 0x16,3
;     573         {
;     574                 goto menu01;
	RJMP _0x84
;     575         }
;     576         if (!sw_down)
	SBIC 0x16,2
	RJMP _0x8E
;     577         {
;     578                 lcd_clear();
	CALL _lcd_clear
;     579                 goto menu03;
	RJMP _0x8F
;     580         }
;     581         goto menu02;
_0x8E:
	RJMP _0x88
;     582     menu03:
_0x8F:
;     583         delay_ms(125);
	CALL SUBOPT_0x0
;     584         lcd_gotoxy(0,0);
;     585                 // 0123456789abcdef
;     586         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0,331
	CALL SUBOPT_0x1
;     587         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     588         lcd_putsf("  Skenario      ");
	__POINTW1FN _0,348
	CALL SUBOPT_0x1
;     589 
;     590         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1C
;     591         lcd_putchar(0);
	CALL SUBOPT_0x20
;     592 
;     593         if (!sw_ok)
	SBIC 0x16,1
	RJMP _0x90
;     594         {
;     595                 lcd_clear();
	CALL _lcd_clear
;     596                 kursorGaris = 1;
	LDI  R30,LOW(1)
	STS  _kursorGaris,R30
;     597                 goto setGaris;
	RJMP _0x91
;     598         }
;     599         if (!sw_up)
_0x90:
	SBIC 0x16,3
	RJMP _0x92
;     600         {
;     601                 lcd_clear();
	CALL _lcd_clear
;     602                 goto menu02;
	RJMP _0x88
;     603         }
;     604         if (!sw_down)
_0x92:
	SBIS 0x16,2
;     605         {
;     606                 goto menu04;
	RJMP _0x94
;     607         }
;     608         goto menu03;
	RJMP _0x8F
;     609     menu04:
_0x94:
;     610         delay_ms(125);
	CALL SUBOPT_0x0
;     611         lcd_gotoxy(0,0);
;     612                 // 0123456789abcdef
;     613         lcd_putsf("  Set Garis     ");
	__POINTW1FN _0,331
	CALL SUBOPT_0x1
;     614         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     615         lcd_putsf("  Skenario      ");
	__POINTW1FN _0,348
	CALL SUBOPT_0x1
;     616 
;     617         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     618         lcd_putchar(0);
	CALL SUBOPT_0x20
;     619 
;     620         if (!sw_ok)
	SBIC 0x16,1
	RJMP _0x95
;     621         {
;     622                 lcd_clear();
	CALL _lcd_clear
;     623                 goto setSkenario;
	RJMP _0x96
;     624         }
;     625         if (!sw_up)
_0x95:
	SBIS 0x16,3
;     626         {
;     627                 goto menu03;
	RJMP _0x8F
;     628         }
;     629         if (!sw_down)
	SBIC 0x16,2
	RJMP _0x98
;     630         {
;     631                 lcd_clear();
	CALL _lcd_clear
;     632                 goto menu05;
	RJMP _0x99
;     633         }
;     634         goto menu04;
_0x98:
	RJMP _0x94
;     635     menu05:            // Bikin sendiri lhoo ^^d
_0x99:
;     636         delay_ms(125);
	CALL SUBOPT_0x0
;     637         lcd_gotoxy(0,0);
;     638         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0,365
	CALL SUBOPT_0x1
;     639         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     640         lcd_putsf("  Start!!      ");
	__POINTW1FN _0,385
	CALL SUBOPT_0x1
;     641 
;     642         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1C
;     643         lcd_putchar(0);
	CALL SUBOPT_0x20
;     644 
;     645         if  (!sw_ok)
	SBIC 0x16,1
	RJMP _0x9A
;     646         {
;     647             lcd_clear();
	CALL _lcd_clear
;     648             goto mode;
	RJMP _0x9B
;     649         }
;     650 
;     651         if  (!sw_up)
_0x9A:
	SBIC 0x16,3
	RJMP _0x9C
;     652         {
;     653             lcd_clear();
	CALL _lcd_clear
;     654             goto menu04;
	RJMP _0x94
;     655         }
;     656 
;     657         if  (!sw_down)
_0x9C:
	SBIS 0x16,2
;     658         {
;     659             goto menu06;
	RJMP _0x8A
;     660         }
;     661 
;     662         goto menu05;
	RJMP _0x99
;     663     menu06:
_0x8A:
;     664         delay_ms(125);
	CALL SUBOPT_0x0
;     665         lcd_gotoxy(0,0);
;     666         lcd_putsf("  Set Mode         ");
	__POINTW1FN _0,365
	CALL SUBOPT_0x1
;     667         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     668         lcd_putsf("  Start!!      ");
	__POINTW1FN _0,385
	CALL SUBOPT_0x1
;     669 
;     670         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     671         lcd_putchar(0);
	CALL SUBOPT_0x20
;     672 
;     673         if (!sw_ok)
	SBIC 0x16,1
	RJMP _0x9E
;     674         {
;     675                 lcd_clear();
	CALL _lcd_clear
;     676                 goto startRobot;
	RJMP _0x9F
;     677         }
;     678 
;     679         if (!sw_up)
_0x9E:
	SBIS 0x16,3
;     680         {
;     681                 goto menu05;
	RJMP _0x99
;     682         }
;     683 
;     684         if (!sw_down)
	SBIC 0x16,2
	RJMP _0xA1
;     685         {
;     686                 lcd_clear();
	CALL _lcd_clear
;     687                 goto menu01;
	RJMP _0x84
;     688         }
;     689 
;     690         goto menu06;
_0xA1:
	RJMP _0x8A
;     691 
;     692 
;     693     setPID:
_0x86:
;     694         delay_ms(150);
	CALL SUBOPT_0x1F
;     695         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1C
;     696                 // 0123456789ABCDEF
;     697         lcd_putsf("  Kp   Ki   Kd  ");
	__POINTW1FN _0,401
	CALL SUBOPT_0x1
;     698         // lcd_putsf(" 250  200  300  ");
;     699         lcd_putchar(' ');
	CALL SUBOPT_0x21
;     700         tampil(Kp); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x5
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
;     701         tampil(Ki); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x6
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
;     702         tampil(Kd); lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x7
	CALL SUBOPT_0x22
	CALL SUBOPT_0x21
;     703 
;     704         switch (kursorPID)
	LDS  R30,_kursorPID
;     705         {
;     706           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0xA5
;     707                 lcd_gotoxy(1,0); // kursor Kp
	LDI  R30,LOW(1)
	RJMP _0x1DE
;     708                 lcd_putchar(0);
;     709                 break;
;     710           case 2:
_0xA5:
	CPI  R30,LOW(0x2)
	BRNE _0xA6
;     711                 lcd_gotoxy(6,0); // kursor Ki
	LDI  R30,LOW(6)
	RJMP _0x1DE
;     712                 lcd_putchar(0);
;     713                 break;
;     714           case 3:
_0xA6:
	CPI  R30,LOW(0x3)
	BRNE _0xA4
;     715                 lcd_gotoxy(11,0); // kursor Kd
	LDI  R30,LOW(11)
_0x1DE:
	ST   -Y,R30
	CALL SUBOPT_0x23
;     716                 lcd_putchar(0);
;     717                 break;
;     718         }
_0xA4:
;     719 
;     720         if (!sw_ok)
	SBIC 0x16,1
	RJMP _0xA8
;     721         {
;     722                 setByte( 1, kursorPID);
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDS  R30,_kursorPID
	CALL SUBOPT_0x24
;     723                 delay_ms(200);
;     724         }
;     725         if (!sw_up)
_0xA8:
	SBIC 0x16,3
	RJMP _0xA9
;     726         {
;     727                 if (kursorPID == 3) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x3)
	BRNE _0xAA
;     728                         kursorPID = 1;
	LDI  R30,LOW(1)
	RJMP _0x1DF
;     729                 } else kursorPID++;
_0xAA:
	LDS  R30,_kursorPID
	SUBI R30,-LOW(1)
_0x1DF:
	STS  _kursorPID,R30
;     730         }
;     731         if (!sw_down)
_0xA9:
	SBIC 0x16,2
	RJMP _0xAC
;     732         {
;     733                 if (kursorPID == 1) {
	LDS  R26,_kursorPID
	CPI  R26,LOW(0x1)
	BRNE _0xAD
;     734                         kursorPID = 3;
	LDI  R30,LOW(3)
	RJMP _0x1E0
;     735                 } else kursorPID--;
_0xAD:
	LDS  R30,_kursorPID
	SUBI R30,LOW(1)
_0x1E0:
	STS  _kursorPID,R30
;     736         }
;     737 
;     738         if (!sw_cancel)
_0xAC:
	SBIC 0x16,0
	RJMP _0xAF
;     739         {
;     740                 lcd_clear();
	CALL _lcd_clear
;     741                 goto menu01;
	RJMP _0x84
;     742         }
;     743 
;     744         goto setPID;
_0xAF:
	RJMP _0x86
;     745 
;     746     setSpeed:
_0x8C:
;     747         delay_ms(150);
	CALL SUBOPT_0x1F
;     748         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1C
;     749                 // 0123456789ABCDEF
;     750         lcd_putsf("   MAX    MIN   ");
	__POINTW1FN _0,418
	CALL SUBOPT_0x1
;     751         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
;     752 
;     753         //lcd_putsf("   250    200   ");
;     754         tampil(MAXSpeed);
	CALL SUBOPT_0x8
	CALL SUBOPT_0x22
;     755         lcd_putchar(' '); lcd_putchar(' ');lcd_putchar(' '); lcd_putchar(' ');
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
;     756         tampil(MINSpeed);
	CALL SUBOPT_0x9
	CALL SUBOPT_0x22
;     757         lcd_putchar(' ');lcd_putchar(' ');lcd_putchar(' ');
	CALL SUBOPT_0x21
	CALL SUBOPT_0x21
;     758 
;     759         switch (kursorSpeed)
	LDS  R30,_kursorSpeed
;     760         {
;     761           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0xB3
;     762                 lcd_gotoxy(2,0); // kursor MAX
	LDI  R30,LOW(2)
	RJMP _0x1E1
;     763                 lcd_putchar(0);
;     764                 break;
;     765           case 2:
_0xB3:
	CPI  R30,LOW(0x2)
	BRNE _0xB2
;     766                 lcd_gotoxy(9,0); // kursor MIN
	LDI  R30,LOW(9)
_0x1E1:
	ST   -Y,R30
	CALL SUBOPT_0x23
;     767                 lcd_putchar(0);
;     768                 break;
;     769         }
_0xB2:
;     770 
;     771         if (!sw_ok)
	SBIC 0x16,1
	RJMP _0xB5
;     772         {
;     773                 setByte( 2, kursorSpeed);
	LDI  R30,LOW(2)
	ST   -Y,R30
	LDS  R30,_kursorSpeed
	CALL SUBOPT_0x24
;     774                 delay_ms(200);
;     775         }
;     776         if (!sw_up)
_0xB5:
	SBIC 0x16,3
	RJMP _0xB6
;     777         {
;     778                 if (kursorSpeed == 2)
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x2)
	BRNE _0xB7
;     779                 {
;     780                         kursorSpeed = 1;
	LDI  R30,LOW(1)
	RJMP _0x1E2
;     781                 } else kursorSpeed++;
_0xB7:
	LDS  R30,_kursorSpeed
	SUBI R30,-LOW(1)
_0x1E2:
	STS  _kursorSpeed,R30
;     782         }
;     783         if (!sw_down)
_0xB6:
	SBIC 0x16,2
	RJMP _0xB9
;     784         {
;     785                 if (kursorSpeed == 1)
	LDS  R26,_kursorSpeed
	CPI  R26,LOW(0x1)
	BRNE _0xBA
;     786                 {
;     787                         kursorSpeed = 2;
	LDI  R30,LOW(2)
	RJMP _0x1E3
;     788                 } else kursorSpeed--;
_0xBA:
	LDS  R30,_kursorSpeed
	SUBI R30,LOW(1)
_0x1E3:
	STS  _kursorSpeed,R30
;     789         }
;     790 
;     791         if (!sw_cancel)
_0xB9:
	SBIC 0x16,0
	RJMP _0xBC
;     792         {
;     793                 lcd_clear();
	CALL _lcd_clear
;     794                 goto menu02;
	RJMP _0x88
;     795         }
;     796 
;     797         goto setSpeed;
_0xBC:
	RJMP _0x8C
;     798 
;     799      setGaris: // not yet
_0x91:
;     800         delay_ms(150);
	CALL SUBOPT_0x1F
;     801         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1C
;     802                 // 0123456789ABCDEF
;     803         if ( WarnaGaris == 1 )
	LDI  R26,LOW(_WarnaGaris)
	LDI  R27,HIGH(_WarnaGaris)
	CALL __EEPROMRDB
	CPI  R30,LOW(0x1)
	BRNE _0xBD
;     804                 lcd_putsf("  WARNA : Putih ");
	__POINTW1FN _0,435
	RJMP _0x1E4
;     805         else
_0xBD:
;     806                 lcd_putsf("  WARNA : Hitam ");
	__POINTW1FN _0,452
_0x1E4:
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_putsf
;     807 
;     808         //lcd_putsf("  LEBAR: 1.5 cm ");
;     809         lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     810         lcd_putsf("  SensL :        ");
	__POINTW1FN _0,469
	CALL SUBOPT_0x1
;     811         lcd_gotoxy(10,1);
	LDI  R30,LOW(10)
	CALL SUBOPT_0x25
;     812         tampil( SensLine );
	LDI  R26,LOW(_SensLine)
	LDI  R27,HIGH(_SensLine)
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _tampil
;     813 
;     814         switch (kursorGaris)
	LDS  R30,_kursorGaris
;     815         {
;     816           case 1:
	CPI  R30,LOW(0x1)
	BRNE _0xC2
;     817                 lcd_gotoxy(0,0); // kursor Warna
	LDI  R30,LOW(0)
	ST   -Y,R30
	RJMP _0x1E5
;     818                 lcd_putchar(0);
;     819                 break;
;     820           case 2:
_0xC2:
	CPI  R30,LOW(0x2)
	BRNE _0xC1
;     821                 lcd_gotoxy(0,1); // kursor SensL
	LDI  R30,LOW(0)
	ST   -Y,R30
	LDI  R30,LOW(1)
_0x1E5:
	ST   -Y,R30
	CALL _lcd_gotoxy
;     822                 lcd_putchar(0);
	CALL SUBOPT_0x20
;     823                 break;
;     824         }
_0xC1:
;     825 
;     826         if (!sw_ok)
	SBIC 0x16,1
	RJMP _0xC4
;     827         {
;     828                 setByte( 3, kursorGaris);
	LDI  R30,LOW(3)
	ST   -Y,R30
	LDS  R30,_kursorGaris
	CALL SUBOPT_0x24
;     829                 delay_ms(200);
;     830         }
;     831         if (!sw_up)
_0xC4:
	SBIC 0x16,3
	RJMP _0xC5
;     832         {
;     833                 if (kursorGaris == 2)
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x2)
	BRNE _0xC6
;     834                 {
;     835                         kursorGaris = 1;
	LDI  R30,LOW(1)
	RJMP _0x1E6
;     836                 } else kursorGaris++;
_0xC6:
	LDS  R30,_kursorGaris
	SUBI R30,-LOW(1)
_0x1E6:
	STS  _kursorGaris,R30
;     837         }
;     838         if (!sw_down)
_0xC5:
	SBIC 0x16,2
	RJMP _0xC8
;     839         {
;     840                 if (kursorGaris == 1)
	LDS  R26,_kursorGaris
	CPI  R26,LOW(0x1)
	BRNE _0xC9
;     841                 {
;     842                         kursorGaris = 2;
	LDI  R30,LOW(2)
	RJMP _0x1E7
;     843                 } else kursorGaris--;
_0xC9:
	LDS  R30,_kursorGaris
	SUBI R30,LOW(1)
_0x1E7:
	STS  _kursorGaris,R30
;     844         }
;     845 
;     846         if (!sw_cancel)
_0xC8:
	SBIC 0x16,0
	RJMP _0xCB
;     847         {
;     848                 lcd_clear();
	CALL _lcd_clear
;     849                 goto menu03;
	RJMP _0x8F
;     850         }
;     851 
;     852         goto setGaris;
_0xCB:
	RJMP _0x91
;     853 
;     854      setSkenario:
_0x96:
;     855         delay_ms(150);
	CALL SUBOPT_0x1F
;     856         lcd_gotoxy(0,0);
	CALL SUBOPT_0x1C
;     857                 // 0123456789ABCDEF
;     858         lcd_putsf("Sken. yg  dpake:");
	__POINTW1FN _0,487
	CALL SUBOPT_0x1
;     859         lcd_gotoxy(0, 1);
	CALL SUBOPT_0x2
;     860         tampil( Skenario );
	LDI  R26,LOW(_Skenario)
	LDI  R27,HIGH(_Skenario)
	CALL __EEPROMRDB
	ST   -Y,R30
	CALL _tampil
;     861 
;     862         if (!sw_ok)
	SBIC 0x16,1
	RJMP _0xCC
;     863         {
;     864                 setByte( 4, 0);
	LDI  R30,LOW(4)
	ST   -Y,R30
	LDI  R30,LOW(0)
	CALL SUBOPT_0x24
;     865                 delay_ms(200);
;     866         }
;     867 
;     868         if (!sw_cancel)
_0xCC:
	SBIC 0x16,0
	RJMP _0xCD
;     869         {
;     870                 lcd_clear();
	CALL _lcd_clear
;     871                 goto menu04;
	RJMP _0x94
;     872         }
;     873 
;     874         goto setSkenario;
_0xCD:
	RJMP _0x96
;     875 
;     876      mode:
_0x9B:
;     877         delay_ms(125);
	CALL SUBOPT_0xC
;     878         if  (!sw_up)
	SBIC 0x16,3
	RJMP _0xCE
;     879         {
;     880             if (Mode==6)
	CALL SUBOPT_0x26
	CPI  R30,LOW(0x6)
	BRNE _0xCF
;     881             {
;     882                 Mode=1;
	LDI  R30,LOW(1)
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMWRB
;     883             }
;     884 
;     885             else Mode++;
	RJMP _0xD0
_0xCF:
	CALL SUBOPT_0x26
	SUBI R30,-LOW(1)
	CALL __EEPROMWRB
	SUBI R30,LOW(1)
;     886 
;     887             goto nomorMode;
_0xD0:
	RJMP _0xD1
;     888         }
;     889 
;     890         if  (!sw_down)
_0xCE:
	SBIC 0x16,2
	RJMP _0xD2
;     891         {
;     892             if  (Mode==1)
	CALL SUBOPT_0x26
	CPI  R30,LOW(0x1)
	BRNE _0xD3
;     893             {
;     894                 Mode=6;
	LDI  R30,LOW(6)
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMWRB
;     895             }
;     896 
;     897             else Mode--;
	RJMP _0xD4
_0xD3:
	CALL SUBOPT_0x26
	SUBI R30,LOW(1)
	CALL __EEPROMWRB
	SUBI R30,-LOW(1)
;     898 
;     899             goto nomorMode;
_0xD4:
;     900         }
;     901 
;     902         nomorMode:
_0xD2:
_0xD1:
;     903             if (Mode==1)
	CALL SUBOPT_0x26
	CPI  R30,LOW(0x1)
	BRNE _0xD5
;     904             {
;     905                 lcd_clear();
	CALL SUBOPT_0x1E
;     906                 lcd_gotoxy(0,0);
;     907                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x27
;     908                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     909                 lcd_putsf(" 1.Lihat ADC");
	__POINTW1FN _0,521
	CALL SUBOPT_0x1
;     910             }
;     911 
;     912             if  (Mode==2)
_0xD5:
	CALL SUBOPT_0x26
	CPI  R30,LOW(0x2)
	BRNE _0xD6
;     913             {
;     914                 lcd_clear();
	CALL SUBOPT_0x1E
;     915                 lcd_gotoxy(0,0);
;     916                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x27
;     917                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     918                 lcd_putsf(" 2.Test Mode");
	__POINTW1FN _0,534
	CALL SUBOPT_0x1
;     919             }
;     920 
;     921             if  (Mode==3)
_0xD6:
	CALL SUBOPT_0x26
	CPI  R30,LOW(0x3)
	BRNE _0xD7
;     922             {
;     923                 lcd_clear();
	CALL SUBOPT_0x1E
;     924                 lcd_gotoxy(0,0);
;     925                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x27
;     926                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     927                 lcd_putsf(" 3.Cek Sensor ");
	__POINTW1FN _0,547
	CALL SUBOPT_0x1
;     928             }
;     929 
;     930             if  (Mode==4)
_0xD7:
	CALL SUBOPT_0x26
	CPI  R30,LOW(0x4)
	BRNE _0xD8
;     931             {
;     932                 lcd_clear();
	CALL SUBOPT_0x1E
;     933                 lcd_gotoxy(0,0);
;     934                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x27
;     935                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     936                 lcd_putsf(" 4.Auto Tune 1-1");
	__POINTW1FN _0,562
	CALL SUBOPT_0x1
;     937             }
;     938 
;     939              if  (Mode==5)
_0xD8:
	CALL SUBOPT_0x26
	CPI  R30,LOW(0x5)
	BRNE _0xD9
;     940             {
;     941                 lcd_clear();
	CALL SUBOPT_0x1E
;     942                 lcd_gotoxy(0,0);
;     943                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x27
;     944                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     945                 lcd_putsf(" 5.Auto Tune ");
	__POINTW1FN _0,579
	CALL SUBOPT_0x1
;     946             }
;     947 
;     948             if  (Mode==6)
_0xD9:
	CALL SUBOPT_0x26
	CPI  R30,LOW(0x6)
	BRNE _0xDA
;     949             {
;     950                 lcd_clear();
	CALL SUBOPT_0x1E
;     951                 lcd_gotoxy(0,0);
;     952                 lcd_putsf(" Mode :         ");
	CALL SUBOPT_0x27
;     953                 lcd_gotoxy(0,1);
	CALL SUBOPT_0x2
;     954                 lcd_putsf(" 6.Cek PWM Aktif");
	__POINTW1FN _0,593
	CALL SUBOPT_0x1
;     955             }
;     956 
;     957         if  (!sw_ok)
_0xDA:
	SBIC 0x16,1
	RJMP _0xDB
;     958         {
;     959             switch  (Mode)
	CALL SUBOPT_0x26
;     960             {
;     961                 case 1:
	CPI  R30,LOW(0x1)
	BREQ PC+3
	JMP _0xDF
;     962                 {
;     963                     for(;;)
_0xE1:
;     964                     {
;     965                         lcd_gotoxy(2,0);
	LDI  R30,LOW(2)
	CALL SUBOPT_0x28
;     966                         sprintf(lcd,"  %d %d %d %d",read_adc(3),read_adc(2),read_adc(1),read_adc(0));
	CALL SUBOPT_0x29
	__POINTW1FN _0,610
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x16
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x15
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x14
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x13
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
;     967                         lcd_puts(lcd);
	CALL _lcd_puts
;     968                         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x25
;     969                         sprintf(lcd,"%d %d %d %d",read_adc(7),read_adc(6),read_adc(5),read_adc(4));
	CALL SUBOPT_0x29
	__POINTW1FN _0,612
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0x1A
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x19
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x18
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x17
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x2B
;     970                         lcd_puts(lcd);
	CALL _lcd_puts
;     971                         delay_ms(100);
	LDI  R30,LOW(100)
	LDI  R31,HIGH(100)
	CALL SUBOPT_0x4
;     972                         lcd_clear();
	CALL _lcd_clear
;     973                     }
	RJMP _0xE1
;     974                 }
;     975                 break;
;     976 
;     977                 case 2:
_0xDF:
	CPI  R30,LOW(0x2)
	BRNE _0xE3
;     978                 {
;     979                     cek_sensor();
	RCALL _cek_sensor
;     980                 }
;     981                 break;
	RJMP _0xDE
;     982 
;     983                 case 3:
_0xE3:
	CPI  R30,LOW(0x3)
	BRNE _0xE4
;     984                 {
;     985                     cek_sensor();
	RCALL _cek_sensor
;     986                 }
;     987                 break;
	RJMP _0xDE
;     988 
;     989                 case 4:
_0xE4:
	CPI  R30,LOW(0x4)
	BRNE _0xE5
;     990                 {
;     991                     tune_batas();
	RCALL _tune_batas
;     992 
;     993                 }
;     994                 break;
	RJMP _0xDE
;     995 
;     996                 case 5:
_0xE5:
	CPI  R30,LOW(0x5)
	BRNE _0xE6
;     997                 {
;     998                     auto_scan();
	RCALL _auto_scan
;     999                     goto menu01;
	RJMP _0x84
;    1000                 }
;    1001                 break;
;    1002 
;    1003                 case 6:
_0xE6:
	CPI  R30,LOW(0x6)
	BRNE _0xDE
;    1004                 {
;    1005                     pemercepat();
	CALL _pemercepat
;    1006                     pelambat();
	CALL _pelambat
;    1007                     goto menu01;
	RJMP _0x84
;    1008                 }
;    1009                 break;
;    1010             }
_0xDE:
;    1011         }
;    1012 
;    1013         if  (!sw_cancel)
_0xDB:
	SBIC 0x16,0
	RJMP _0xE8
;    1014         {
;    1015             lcd_clear();
	CALL _lcd_clear
;    1016             goto menu05;
	RJMP _0x99
;    1017         }
;    1018 
;    1019         goto mode;
_0xE8:
	RJMP _0x9B
;    1020 
;    1021      startRobot:
_0x9F:
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
	CALL SUBOPT_0x25
;    1030     if (s7) lcd_putchar('1');
	SBRS R2,7
	RJMP _0xE9
	LDI  R30,LOW(49)
	RJMP _0x1E8
;    1031     else    lcd_putchar('0');
_0xE9:
	LDI  R30,LOW(48)
_0x1E8:
	ST   -Y,R30
	CALL _lcd_putchar
;    1032     if (s6) lcd_putchar('1');
	SBRS R2,6
	RJMP _0xEB
	LDI  R30,LOW(49)
	RJMP _0x1E9
;    1033     else    lcd_putchar('0');
_0xEB:
	LDI  R30,LOW(48)
_0x1E9:
	ST   -Y,R30
	CALL _lcd_putchar
;    1034     if (s5) lcd_putchar('1');
	SBRS R2,5
	RJMP _0xED
	LDI  R30,LOW(49)
	RJMP _0x1EA
;    1035     else    lcd_putchar('0');
_0xED:
	LDI  R30,LOW(48)
_0x1EA:
	ST   -Y,R30
	CALL _lcd_putchar
;    1036     if (s4) lcd_putchar('1');
	SBRS R2,4
	RJMP _0xEF
	LDI  R30,LOW(49)
	RJMP _0x1EB
;    1037     else    lcd_putchar('0');
_0xEF:
	LDI  R30,LOW(48)
_0x1EB:
	ST   -Y,R30
	CALL _lcd_putchar
;    1038     if (s3) lcd_putchar('1');
	SBRS R2,3
	RJMP _0xF1
	LDI  R30,LOW(49)
	RJMP _0x1EC
;    1039     else    lcd_putchar('0');
_0xF1:
	LDI  R30,LOW(48)
_0x1EC:
	ST   -Y,R30
	CALL _lcd_putchar
;    1040     if (s2) lcd_putchar('1');
	SBRS R2,2
	RJMP _0xF3
	LDI  R30,LOW(49)
	RJMP _0x1ED
;    1041     else    lcd_putchar('0');
_0xF3:
	LDI  R30,LOW(48)
_0x1ED:
	ST   -Y,R30
	CALL _lcd_putchar
;    1042     if (s1) lcd_putchar('1');
	SBRS R2,1
	RJMP _0xF5
	LDI  R30,LOW(49)
	RJMP _0x1EE
;    1043     else    lcd_putchar('0');
_0xF5:
	LDI  R30,LOW(48)
_0x1EE:
	ST   -Y,R30
	CALL _lcd_putchar
;    1044     if (s0) lcd_putchar('1');
	SBRS R2,0
	RJMP _0xF7
	LDI  R30,LOW(49)
	RJMP _0x1EF
;    1045     else    lcd_putchar('0');
_0xF7:
	LDI  R30,LOW(48)
_0x1EF:
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
;    1051         if(xcount<=lpwm)Enki=1;
	CALL SUBOPT_0xD
	CALL SUBOPT_0x2C
	BRLT _0xF9
	SBI  0x12,4
;    1052         else Enki=0;
	RJMP _0xFA
_0xF9:
	CBI  0x12,4
;    1053         if(xcount<=rpwm)Enka=1;
_0xFA:
	CALL SUBOPT_0xF
	CALL SUBOPT_0x2C
	BRLT _0xFB
	SBI  0x12,5
;    1054         else Enka=0;
	RJMP _0xFC
_0xFB:
	CBI  0x12,5
;    1055         TCNT0=0xFF;
_0xFC:
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
_0xFE:
	__CPWRN 16,17,30000
	BRGE _0xFF
	CALL _displaySensorBit
	__ADDWRN 16,17,1
	RJMP _0xFE
_0xFF:
;    1085 }
	LD   R16,Y+
	LD   R17,Y+
	RET
;    1086 
;    1087 void tune_batas()
;    1088 {
_tune_batas:
;    1089 
;    1090     lcd_clear();
	CALL _lcd_clear
;    1091     for(;;)
_0x101:
;    1092     {
;    1093         read_adc(0);
	CALL SUBOPT_0x13
;    1094         if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
	CALL SUBOPT_0x13
	MOV  R26,R30
	LDS  R30,_bb0
	CP   R26,R30
	BRSH _0x103
	CALL SUBOPT_0x13
	STS  _bb0,R30
;    1095         if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
_0x103:
	CALL SUBOPT_0x13
	MOV  R26,R30
	LDS  R30,_ba0
	CP   R30,R26
	BRSH _0x104
	CALL SUBOPT_0x13
	STS  _ba0,R30
;    1096 
;    1097         bt0=((bb0+ba0)/2);
_0x104:
	CALL SUBOPT_0x2D
;    1098 
;    1099         lcd_clear();
	CALL SUBOPT_0x2E
;    1100         lcd_gotoxy(1,0);
;    1101         lcd_putsf(" bb0  ba0  bt0");
	__POINTW1FN _0,641
	CALL SUBOPT_0x1
;    1102         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x25
;    1103         sprintf(lcd," %d  %d  %d",bb0,ba0,bt0);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2F
	LDS  R30,_bb0
	CALL SUBOPT_0x2A
	LDS  R30,_ba0
	CALL SUBOPT_0x2A
	LDS  R30,_bt0
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x30
;    1104         lcd_puts(lcd);
	CALL SUBOPT_0x31
;    1105         delay_ms(50);
;    1106 
;    1107         if(!sw_ok)
	SBIC 0x16,1
	RJMP _0x105
;    1108         {
;    1109             delay_ms(125);
	CALL SUBOPT_0xC
;    1110             goto sensor1;
	RJMP _0x106
;    1111         }
;    1112     }
_0x105:
	RJMP _0x101
;    1113     sensor1:
_0x106:
;    1114     for(;;)
_0x108:
;    1115     {
;    1116         read_adc(1);
	CALL SUBOPT_0x14
;    1117         if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_bb1
	CP   R26,R30
	BRSH _0x10A
	CALL SUBOPT_0x14
	STS  _bb1,R30
;    1118         if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
_0x10A:
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_ba1
	CP   R30,R26
	BRSH _0x10B
	CALL SUBOPT_0x14
	STS  _ba1,R30
;    1119 
;    1120         bt1=((bb1+ba1)/2);
_0x10B:
	CALL SUBOPT_0x32
;    1121 
;    1122         lcd_clear();
	CALL SUBOPT_0x2E
;    1123         lcd_gotoxy(1,0);
;    1124         lcd_putsf(" bb1  ba1  bt1");
	__POINTW1FN _0,668
	CALL SUBOPT_0x1
;    1125         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x25
;    1126         sprintf(lcd," %d  %d  %d",bb1,ba1,bt1);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2F
	LDS  R30,_bb1
	CALL SUBOPT_0x2A
	LDS  R30,_ba1
	CALL SUBOPT_0x2A
	LDS  R30,_bt1
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x30
;    1127         lcd_puts(lcd);
	CALL SUBOPT_0x31
;    1128         delay_ms(50);
;    1129 
;    1130         if(!sw_ok)
	SBIC 0x16,1
	RJMP _0x10C
;    1131         {
;    1132             delay_ms(150);
	CALL SUBOPT_0x1F
;    1133             goto sensor2;
	RJMP _0x10D
;    1134         }
;    1135     }
_0x10C:
	RJMP _0x108
;    1136     sensor2:
_0x10D:
;    1137     for(;;)
_0x10F:
;    1138     {
;    1139         read_adc(2);
	CALL SUBOPT_0x15
;    1140         if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_bb2
	CP   R26,R30
	BRSH _0x111
	CALL SUBOPT_0x15
	STS  _bb2,R30
;    1141         if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
_0x111:
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_ba2
	CP   R30,R26
	BRSH _0x112
	CALL SUBOPT_0x15
	STS  _ba2,R30
;    1142 
;    1143         bt2=((bb2+ba2)/2);
_0x112:
	CALL SUBOPT_0x33
;    1144 
;    1145         lcd_clear();
	CALL SUBOPT_0x2E
;    1146         lcd_gotoxy(1,0);
;    1147         lcd_putsf(" bb2  ba2  bt2");
	__POINTW1FN _0,683
	CALL SUBOPT_0x1
;    1148         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x25
;    1149         sprintf(lcd," %d  %d  %d",bb2,ba2,bt2);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2F
	LDS  R30,_bb2
	CALL SUBOPT_0x2A
	LDS  R30,_ba2
	CALL SUBOPT_0x2A
	LDS  R30,_bt2
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x30
;    1150         lcd_puts(lcd);
	CALL SUBOPT_0x34
;    1151         delay_ms(10);
;    1152 
;    1153         if(!sw_ok)
	SBIC 0x16,1
	RJMP _0x113
;    1154         {
;    1155             delay_ms(150);
	CALL SUBOPT_0x1F
;    1156             goto sensor3;
	RJMP _0x114
;    1157         }
;    1158     }
_0x113:
	RJMP _0x10F
;    1159     sensor3:
_0x114:
;    1160     for(;;)
_0x116:
;    1161     {
;    1162         read_adc(3);
	CALL SUBOPT_0x16
;    1163         if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_bb3
	CP   R26,R30
	BRSH _0x118
	CALL SUBOPT_0x16
	STS  _bb3,R30
;    1164         if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
_0x118:
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_ba3
	CP   R30,R26
	BRSH _0x119
	CALL SUBOPT_0x16
	STS  _ba3,R30
;    1165 
;    1166         bt3=((bb3+ba3)/2);
_0x119:
	CALL SUBOPT_0x35
;    1167 
;    1168         lcd_clear();
	CALL SUBOPT_0x2E
;    1169         lcd_gotoxy(1,0);
;    1170         lcd_putsf(" bb3  ba3  bt3");
	__POINTW1FN _0,698
	CALL SUBOPT_0x1
;    1171         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x25
;    1172         sprintf(lcd," %d  %d  %d",bb3,ba3,bt3);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2F
	LDS  R30,_bb3
	CALL SUBOPT_0x2A
	LDS  R30,_ba3
	CALL SUBOPT_0x2A
	LDS  R30,_bt3
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x30
;    1173         lcd_puts(lcd);
	CALL SUBOPT_0x34
;    1174         delay_ms(10);
;    1175 
;    1176         if(!sw_ok)
	SBIC 0x16,1
	RJMP _0x11A
;    1177         {
;    1178             delay_ms(150);
	CALL SUBOPT_0x1F
;    1179             goto sensor4;
	RJMP _0x11B
;    1180         }
;    1181     }
_0x11A:
	RJMP _0x116
;    1182     sensor4:
_0x11B:
;    1183     for(;;)
_0x11D:
;    1184     {
;    1185         read_adc(4);
	CALL SUBOPT_0x17
;    1186         if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_bb4
	CP   R26,R30
	BRSH _0x11F
	CALL SUBOPT_0x17
	STS  _bb4,R30
;    1187         if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
_0x11F:
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_ba4
	CP   R30,R26
	BRSH _0x120
	CALL SUBOPT_0x17
	STS  _ba4,R30
;    1188 
;    1189         bt4=((bb4+ba4)/2);
_0x120:
	CALL SUBOPT_0x36
;    1190 
;    1191         lcd_clear();
	CALL SUBOPT_0x2E
;    1192         lcd_gotoxy(1,0);
;    1193         lcd_putsf(" bb4  ba4  bt4");
	__POINTW1FN _0,713
	CALL SUBOPT_0x1
;    1194         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x25
;    1195         sprintf(lcd," %d  %d  %d",bb4,ba4,bt4);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2F
	LDS  R30,_bb4
	CALL SUBOPT_0x2A
	LDS  R30,_ba4
	CALL SUBOPT_0x2A
	LDS  R30,_bt4
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x30
;    1196         lcd_puts(lcd);
	CALL SUBOPT_0x34
;    1197         delay_ms(10);
;    1198 
;    1199         if(!sw_ok)
	SBIC 0x16,1
	RJMP _0x121
;    1200         {
;    1201             delay_ms(150);
	CALL SUBOPT_0x1F
;    1202             goto sensor5;
	RJMP _0x122
;    1203         }
;    1204     }
_0x121:
	RJMP _0x11D
;    1205     sensor5:
_0x122:
;    1206     for(;;)
_0x124:
;    1207     {
;    1208         read_adc(5);
	CALL SUBOPT_0x18
;    1209         if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_bb5
	CP   R26,R30
	BRSH _0x126
	CALL SUBOPT_0x18
	STS  _bb5,R30
;    1210         if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
_0x126:
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_ba5
	CP   R30,R26
	BRSH _0x127
	CALL SUBOPT_0x18
	STS  _ba5,R30
;    1211 
;    1212         bt5=((bb5+ba5)/2);
_0x127:
	CALL SUBOPT_0x37
;    1213 
;    1214         lcd_clear();
	CALL SUBOPT_0x2E
;    1215         lcd_gotoxy(1,0);
;    1216         lcd_putsf(" bb5  ba5  bt5");
	__POINTW1FN _0,728
	CALL SUBOPT_0x1
;    1217         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x25
;    1218         sprintf(lcd," %d  %d  %d",bb5,ba5,bt5);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2F
	LDS  R30,_bb5
	CALL SUBOPT_0x2A
	LDS  R30,_ba5
	CALL SUBOPT_0x2A
	LDS  R30,_bt5
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x30
;    1219         lcd_puts(lcd);
	CALL SUBOPT_0x34
;    1220         delay_ms(10);
;    1221 
;    1222         if(!sw_ok)
	SBIC 0x16,1
	RJMP _0x128
;    1223         {
;    1224             delay_ms(150);
	CALL SUBOPT_0x1F
;    1225             goto sensor6;
	RJMP _0x129
;    1226         }
;    1227     }
_0x128:
	RJMP _0x124
;    1228     sensor6:
_0x129:
;    1229     for(;;)
_0x12B:
;    1230     {
;    1231         read_adc(06);
	CALL SUBOPT_0x19
;    1232         if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_bb6
	CP   R26,R30
	BRSH _0x12D
	CALL SUBOPT_0x19
	STS  _bb6,R30
;    1233         if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
_0x12D:
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_ba6
	CP   R30,R26
	BRSH _0x12E
	CALL SUBOPT_0x19
	STS  _ba6,R30
;    1234 
;    1235         bt6=((bb6+ba6)/2);
_0x12E:
	CALL SUBOPT_0x38
;    1236 
;    1237         lcd_clear();
	CALL SUBOPT_0x2E
;    1238         lcd_gotoxy(1,0);
;    1239         lcd_putsf(" bb6  ba6  bt6");
	__POINTW1FN _0,743
	CALL SUBOPT_0x1
;    1240         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x25
;    1241         sprintf(lcd," %d  %d  %d",bb6,ba6,bt6);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2F
	LDS  R30,_bb6
	CALL SUBOPT_0x2A
	LDS  R30,_ba6
	CALL SUBOPT_0x2A
	LDS  R30,_bt6
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x30
;    1242         lcd_puts(lcd);
	CALL SUBOPT_0x34
;    1243         delay_ms(10);
;    1244 
;    1245         if(!sw_ok)
	SBIC 0x16,1
	RJMP _0x12F
;    1246         {
;    1247             delay_ms(150);
	CALL SUBOPT_0x1F
;    1248             goto sensor7;
	RJMP _0x130
;    1249         }
;    1250     }
_0x12F:
	RJMP _0x12B
;    1251     sensor7:
_0x130:
;    1252     for(;;)
_0x132:
;    1253     {
;    1254         read_adc(7);
	CALL SUBOPT_0x1A
;    1255         if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_bb7
	CP   R26,R30
	BRSH _0x134
	CALL SUBOPT_0x1A
	STS  _bb7,R30
;    1256         if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
_0x134:
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_ba7
	CP   R30,R26
	BRSH _0x135
	CALL SUBOPT_0x1A
	STS  _ba7,R30
;    1257 
;    1258         bt7=((bb7+ba7)/2);
_0x135:
	CALL SUBOPT_0x39
;    1259 
;    1260         lcd_clear();
;    1261         lcd_gotoxy(1,0);
;    1262         lcd_putsf(" bb7  ba7  bt7");
	__POINTW1FN _0,758
	CALL SUBOPT_0x1
;    1263         lcd_gotoxy(1,1);
	LDI  R30,LOW(1)
	CALL SUBOPT_0x25
;    1264         sprintf(lcd," %d  %d  %d",bb7,ba7,bt7);
	CALL SUBOPT_0x29
	CALL SUBOPT_0x2F
	LDS  R30,_bb7
	CALL SUBOPT_0x2A
	LDS  R30,_ba7
	CALL SUBOPT_0x2A
	MOV  R30,R12
	CALL SUBOPT_0x2A
	CALL SUBOPT_0x30
;    1265         lcd_puts(lcd);
	CALL SUBOPT_0x34
;    1266         delay_ms(10);
;    1267 
;    1268         if(!sw_ok)
	SBIC 0x16,1
	RJMP _0x136
;    1269         {
;    1270             delay_ms(150);
	CALL SUBOPT_0x1F
;    1271             goto selesai;
	RJMP _0x137
;    1272         }
;    1273     }
_0x136:
	RJMP _0x132
;    1274     selesai:
_0x137:
;    1275     lcd_clear();
	CALL _lcd_clear
;    1276 }
	RET
;    1277 
;    1278 void auto_scan()
;    1279 {
_auto_scan:
;    1280     for(;;)
_0x139:
;    1281     {
;    1282     read_adc(0);
	CALL SUBOPT_0x13
;    1283         if  (read_adc(0)<bb0)   {bb0=read_adc(0);}
	CALL SUBOPT_0x13
	MOV  R26,R30
	LDS  R30,_bb0
	CP   R26,R30
	BRSH _0x13B
	CALL SUBOPT_0x13
	STS  _bb0,R30
;    1284         if  (read_adc(0)>ba0)   {ba0=read_adc(0);}
_0x13B:
	CALL SUBOPT_0x13
	MOV  R26,R30
	LDS  R30,_ba0
	CP   R30,R26
	BRSH _0x13C
	CALL SUBOPT_0x13
	STS  _ba0,R30
;    1285 
;    1286         bt0=((bb0+ba0)/2);
_0x13C:
	CALL SUBOPT_0x2D
;    1287 
;    1288     read_adc(1);
	CALL SUBOPT_0x14
;    1289         if  (read_adc(1)<bb1)   {bb1=read_adc(1);}
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_bb1
	CP   R26,R30
	BRSH _0x13D
	CALL SUBOPT_0x14
	STS  _bb1,R30
;    1290         if  (read_adc(1)>ba1)   {ba1=read_adc(1);}
_0x13D:
	CALL SUBOPT_0x14
	MOV  R26,R30
	LDS  R30,_ba1
	CP   R30,R26
	BRSH _0x13E
	CALL SUBOPT_0x14
	STS  _ba1,R30
;    1291 
;    1292         bt1=((bb1+ba1)/2);
_0x13E:
	CALL SUBOPT_0x32
;    1293 
;    1294     read_adc(2);
	CALL SUBOPT_0x15
;    1295         if  (read_adc(2)<bb2)   {bb2=read_adc(2);}
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_bb2
	CP   R26,R30
	BRSH _0x13F
	CALL SUBOPT_0x15
	STS  _bb2,R30
;    1296         if  (read_adc(2)>ba2)   {ba2=read_adc(2);}
_0x13F:
	CALL SUBOPT_0x15
	MOV  R26,R30
	LDS  R30,_ba2
	CP   R30,R26
	BRSH _0x140
	CALL SUBOPT_0x15
	STS  _ba2,R30
;    1297 
;    1298         bt2=((bb2+ba2)/2);
_0x140:
	CALL SUBOPT_0x33
;    1299 
;    1300     read_adc(3);
	CALL SUBOPT_0x16
;    1301         if  (read_adc(3)<bb3)   {bb3=read_adc(3);}
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_bb3
	CP   R26,R30
	BRSH _0x141
	CALL SUBOPT_0x16
	STS  _bb3,R30
;    1302         if  (read_adc(3)>ba3)   {ba3=read_adc(3);}
_0x141:
	CALL SUBOPT_0x16
	MOV  R26,R30
	LDS  R30,_ba3
	CP   R30,R26
	BRSH _0x142
	CALL SUBOPT_0x16
	STS  _ba3,R30
;    1303 
;    1304         bt3=((bb3+ba3)/2);
_0x142:
	CALL SUBOPT_0x35
;    1305 
;    1306     read_adc(4);
	CALL SUBOPT_0x17
;    1307         if  (read_adc(4)<bb4)   {bb4=read_adc(4);}
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_bb4
	CP   R26,R30
	BRSH _0x143
	CALL SUBOPT_0x17
	STS  _bb4,R30
;    1308         if  (read_adc(4)>ba4)   {ba4=read_adc(4);}
_0x143:
	CALL SUBOPT_0x17
	MOV  R26,R30
	LDS  R30,_ba4
	CP   R30,R26
	BRSH _0x144
	CALL SUBOPT_0x17
	STS  _ba4,R30
;    1309 
;    1310         bt4=((bb4+ba4)/2);
_0x144:
	CALL SUBOPT_0x36
;    1311 
;    1312     read_adc(5);
	CALL SUBOPT_0x18
;    1313         if  (read_adc(5)<bb5)   {bb5=read_adc(5);}
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_bb5
	CP   R26,R30
	BRSH _0x145
	CALL SUBOPT_0x18
	STS  _bb5,R30
;    1314         if  (read_adc(5)>ba5)   {ba5=read_adc(5);}
_0x145:
	CALL SUBOPT_0x18
	MOV  R26,R30
	LDS  R30,_ba5
	CP   R30,R26
	BRSH _0x146
	CALL SUBOPT_0x18
	STS  _ba5,R30
;    1315 
;    1316         bt5=((bb5+ba5)/2);
_0x146:
	CALL SUBOPT_0x37
;    1317 
;    1318     read_adc(6);
	CALL SUBOPT_0x19
;    1319         if  (read_adc(6)<bb6)   {bb6=read_adc(6);}
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_bb6
	CP   R26,R30
	BRSH _0x147
	CALL SUBOPT_0x19
	STS  _bb6,R30
;    1320         if  (read_adc(6)>ba6)   {ba6=read_adc(6);}
_0x147:
	CALL SUBOPT_0x19
	MOV  R26,R30
	LDS  R30,_ba6
	CP   R30,R26
	BRSH _0x148
	CALL SUBOPT_0x19
	STS  _ba6,R30
;    1321 
;    1322         bt6=((bb6+ba6)/2);
_0x148:
	CALL SUBOPT_0x38
;    1323 
;    1324     read_adc(7);
	CALL SUBOPT_0x1A
;    1325         if  (read_adc(7)<bb7)   {bb7=read_adc(7);}
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_bb7
	CP   R26,R30
	BRSH _0x149
	CALL SUBOPT_0x1A
	STS  _bb7,R30
;    1326         if  (read_adc(7)>ba7)   {ba7=read_adc(7);}
_0x149:
	CALL SUBOPT_0x1A
	MOV  R26,R30
	LDS  R30,_ba7
	CP   R30,R26
	BRSH _0x14A
	CALL SUBOPT_0x1A
	STS  _ba7,R30
;    1327 
;    1328         bt7=((bb7+ba7)/2);
_0x14A:
	CALL SUBOPT_0x39
;    1329 
;    1330         lcd_clear();
;    1331         lcd_gotoxy(1,0);
;    1332         sprintf(lcd,"%d %d %d %d %d %d %d %d",bt7,bt6,bt5,bt4,bt3,bt2,bt1,bt0);
	CALL SUBOPT_0x29
	__POINTW1FN _0,773
	ST   -Y,R31
	ST   -Y,R30
	MOV  R30,R12
	CALL SUBOPT_0x2A
	LDS  R30,_bt6
	CALL SUBOPT_0x2A
	LDS  R30,_bt5
	CALL SUBOPT_0x2A
	LDS  R30,_bt4
	CALL SUBOPT_0x2A
	LDS  R30,_bt3
	CALL SUBOPT_0x2A
	LDS  R30,_bt2
	CALL SUBOPT_0x2A
	LDS  R30,_bt1
	CALL SUBOPT_0x2A
	LDS  R30,_bt0
	CALL SUBOPT_0x2A
	LDI  R24,32
	CALL _sprintf
	ADIW R28,36
;    1333         lcd_puts(lcd);
	CALL SUBOPT_0x29
	CALL _lcd_puts
;    1334         delay_ms(120);
	LDI  R30,LOW(120)
	LDI  R31,HIGH(120)
	CALL SUBOPT_0x4
;    1335 
;    1336         if (!sw_ok){showMenu();}
	SBIC 0x16,1
	RJMP _0x14B
	CALL _showMenu
;    1337     }
_0x14B:
	RJMP _0x139
;    1338 }
;    1339 
;    1340 int x;

	.DSEG
_x:
	.BYTE 0x2
;    1341 void ikuti_garis()
;    1342 {

	.CSEG
_ikuti_garis:
;    1343     baca_sensor();
	CALL _baca_sensor
;    1344 
;    1345     if(sensor==0b00000001){bkan();rpwm=0;lpwm=90;x=1;}  //kanan
	LDI  R30,LOW(1)
	CP   R30,R5
	BRNE _0x14C
	CALL SUBOPT_0x3A
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x3B
;    1346     if(sensor==0b00000011){bkan();rpwm=0;lpwm=80;x=1;}
_0x14C:
	LDI  R30,LOW(3)
	CP   R30,R5
	BRNE _0x14D
	CALL SUBOPT_0x3A
	CALL SUBOPT_0x3C
;    1347     if(sensor==0b00000010){maju();rpwm=10;lpwm=75;x=1;}
_0x14D:
	LDI  R30,LOW(2)
	CP   R30,R5
	BRNE _0x14E
	CALL _maju
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x3D
;    1348     if(sensor==0b00000110){maju();rpwm=20;lpwm=75;x=1;}
_0x14E:
	LDI  R30,LOW(6)
	CP   R30,R5
	BRNE _0x14F
	CALL _maju
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x3D
;    1349     if(sensor==0b00000100){maju();rpwm=35;lpwm=80;x=1;}
_0x14F:
	LDI  R30,LOW(4)
	CP   R30,R5
	BRNE _0x150
	CALL _maju
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	CALL SUBOPT_0x3E
;    1350     if(sensor==0b00001100){maju();rpwm=50;lpwm=80;x=1;}
_0x150:
	LDI  R30,LOW(12)
	CP   R30,R5
	BRNE _0x151
	CALL _maju
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x3E
;    1351     if(sensor==0b00001000){maju();rpwm=70;lpwm=80;x=1;}
_0x151:
	LDI  R30,LOW(8)
	CP   R30,R5
	BRNE _0x152
	CALL _maju
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x3E
;    1352 
;    1353     //if(sensor==0b00011000){maju();rpwm=75;lpwm=75;}  //tengah
;    1354 
;    1355     if(sensor==0b00010000){maju();rpwm=80;lpwm=70;x=0;}
_0x152:
	LDI  R30,LOW(16)
	CP   R30,R5
	BRNE _0x153
	CALL SUBOPT_0x3F
	LDI  R30,LOW(70)
	LDI  R31,HIGH(70)
	CALL SUBOPT_0x40
;    1356     if(sensor==0b00110000){maju();rpwm=80;lpwm=50;x=0;}
_0x153:
	LDI  R30,LOW(48)
	CP   R30,R5
	BRNE _0x154
	CALL SUBOPT_0x3F
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	CALL SUBOPT_0x40
;    1357     if(sensor==0b00100000){maju();rpwm=80;lpwm=35;x=0;}
_0x154:
	LDI  R30,LOW(32)
	CP   R30,R5
	BRNE _0x155
	CALL SUBOPT_0x3F
	LDI  R30,LOW(35)
	LDI  R31,HIGH(35)
	CALL SUBOPT_0x40
;    1358     if(sensor==0b01100000){maju();rpwm=75;lpwm=20;x=0;}
_0x155:
	LDI  R30,LOW(96)
	CP   R30,R5
	BRNE _0x156
	CALL SUBOPT_0x41
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CALL SUBOPT_0x40
;    1359     if(sensor==0b01000000){maju();rpwm=75;lpwm=10;x=0;}
_0x156:
	LDI  R30,LOW(64)
	CP   R30,R5
	BRNE _0x157
	CALL SUBOPT_0x41
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CALL SUBOPT_0x40
;    1360     if(sensor==0b11000000){bkir();rpwm=80;lpwm=0;x=0;}
_0x157:
	LDI  R30,LOW(192)
	CP   R30,R5
	BRNE _0x158
	CALL _bkir
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	CALL SUBOPT_0x42
;    1361     if(sensor==0b10000000){bkir();rpwm=90;lpwm=0;x=0;}  //kiri
_0x158:
	LDI  R30,LOW(128)
	CP   R30,R5
	BRNE _0x159
	CALL _bkir
	LDI  R30,LOW(90)
	LDI  R31,HIGH(90)
	CALL SUBOPT_0x42
;    1362 
;    1363     if(sensor==0b00000000)                                  //lepas
_0x159:
	TST  R5
	BRNE _0x15A
;    1364     {
;    1365         if(x)
	LDS  R30,_x
	LDS  R31,_x+1
	SBIW R30,0
	BREQ _0x15B
;    1366         {
;    1367             stop();rotkan();rpwm=150;lpwm=150;
	CALL _stop
	CALL _rotkan
	RJMP _0x1F0
;    1368         }
;    1369 
;    1370         else
_0x15B:
;    1371         {
;    1372             stop();rotkir();rpwm=150;lpwm=150;
	CALL _stop
	CALL _rotkir
_0x1F0:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0x10
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	CALL SUBOPT_0xE
;    1373         }
;    1374     }
;    1375 
;    1376     //sudutkanan
;    1377     sensor&=0b00001011;
_0x15A:
	LDI  R30,LOW(11)
	AND  R5,R30
;    1378     if(sensor==0b00001011)
	CP   R30,R5
	BRNE _0x15D
;    1379     {
;    1380         stop();
	CALL SUBOPT_0x43
;    1381         delay_ms(2);
;    1382         sensor&=0b00001111;
	LDI  R30,LOW(15)
	AND  R5,R30
;    1383         if(sensor==0b00001111)
	CP   R30,R5
	BRNE _0x15E
;    1384         {
;    1385             delay_ms(2);
	CALL SUBOPT_0x44
;    1386             sensor&=0b00001110;
	LDI  R30,LOW(14)
	AND  R5,R30
;    1387             if(sensor==0b00001110)
	CP   R30,R5
	BRNE _0x15F
;    1388             {
;    1389                 delay_ms(2);
	CALL SUBOPT_0x44
;    1390                 sensor&=0b00001100;
	LDI  R30,LOW(12)
	AND  R5,R30
;    1391                 if(sensor==0b00001100)
	CP   R30,R5
	BRNE _0x160
;    1392                 {
;    1393                     bkan();rpwm=0;lpwm=250;
	CALL SUBOPT_0x3A
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0xE
;    1394                 }
;    1395             }
_0x160:
;    1396         }
_0x15F:
;    1397     }
_0x15E:
;    1398 
;    1399 
;    1400     //sudutkiri
;    1401     sensor&=0b11010000;
_0x15D:
	LDI  R30,LOW(208)
	AND  R5,R30
;    1402     if(sensor==0b11010000)
	CP   R30,R5
	BRNE _0x161
;    1403     {
;    1404         stop();
	CALL SUBOPT_0x43
;    1405         delay_ms(2);
;    1406         sensor&=0b11110000;
	LDI  R30,LOW(240)
	AND  R5,R30
;    1407         if(sensor==0b11110000)
	CP   R30,R5
	BRNE _0x162
;    1408         {
;    1409             delay_ms(2);
	CALL SUBOPT_0x44
;    1410             sensor&=0b01110000;
	LDI  R30,LOW(112)
	AND  R5,R30
;    1411             if(sensor==0b01110000)
	CP   R30,R5
	BRNE _0x163
;    1412             {
;    1413                 delay_ms(2);
	CALL SUBOPT_0x44
;    1414                 sensor&=0b00110000;
	LDI  R30,LOW(48)
	AND  R5,R30
;    1415                 if(sensor==0b00110000)
	CP   R30,R5
	BRNE _0x164
;    1416                 {
;    1417                     bkir();rpwm=250;lpwm=0;
	CALL _bkir
	LDI  R30,LOW(250)
	LDI  R31,HIGH(250)
	CALL SUBOPT_0x10
	LDI  R30,0
	STS  _lpwm,R30
	STS  _lpwm+1,R30
;    1418                 }
;    1419             }
_0x164:
;    1420         }
_0x163:
;    1421     }
_0x162:
;    1422 
;    1423     sprintf(lcd_buffer,"%d   %d",lpwm, rpwm);
_0x161:
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	__POINTW1FN _0,797
	ST   -Y,R31
	ST   -Y,R30
	CALL SUBOPT_0xD
	CALL __CWD1
	CALL __PUTPARD1
	CALL SUBOPT_0xF
	CALL __CWD1
	CALL __PUTPARD1
	LDI  R24,8
	CALL _sprintf
	ADIW R28,12
;    1424     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1C
;    1425     lcd_putsf("                ");
	__POINTW1FN _0,805
	CALL SUBOPT_0x1
;    1426     lcd_gotoxy(0, 0);
	CALL SUBOPT_0x1C
;    1427     lcd_puts(lcd_buffer);
	LDI  R30,LOW(_lcd_buffer)
	LDI  R31,HIGH(_lcd_buffer)
	ST   -Y,R31
	ST   -Y,R30
	CALL _lcd_puts
;    1428     delay_ms(5);
	LDI  R30,LOW(5)
	LDI  R31,HIGH(5)
	CALL SUBOPT_0x4
;    1429 }
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
	BREQ _0x165
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	CALL __GETW1P
	MOVW R16,R30
	SBIW R30,0
	BREQ _0x167
	__CPWRN 16,17,2
	BRLO _0x168
	MOVW R30,R16
	SBIW R30,1
	MOVW R16,R30
	ST   X+,R30
	ST   X,R31
_0x167:
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
_0x168:
	RJMP _0x169
_0x165:
	LDD  R30,Y+6
	ST   -Y,R30
	CALL _putchar
_0x169:
	LDD  R17,Y+1
	LDD  R16,Y+0
	ADIW R28,7
	RET
__print_G2:
	SBIW R28,6
	CALL __SAVELOCR6
	LDI  R17,0
_0x16A:
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
	JMP _0x16C
	MOV  R30,R17
	CPI  R30,0
	BRNE _0x170
	CPI  R18,37
	BRNE _0x171
	LDI  R17,LOW(1)
	RJMP _0x172
_0x171:
	CALL SUBOPT_0x45
_0x172:
	RJMP _0x16F
_0x170:
	CPI  R30,LOW(0x1)
	BRNE _0x173
	CPI  R18,37
	BRNE _0x174
	CALL SUBOPT_0x45
	RJMP _0x1F1
_0x174:
	LDI  R17,LOW(2)
	LDI  R20,LOW(0)
	LDI  R16,LOW(0)
	CPI  R18,45
	BRNE _0x175
	LDI  R16,LOW(1)
	RJMP _0x16F
_0x175:
	CPI  R18,43
	BRNE _0x176
	LDI  R20,LOW(43)
	RJMP _0x16F
_0x176:
	CPI  R18,32
	BRNE _0x177
	LDI  R20,LOW(32)
	RJMP _0x16F
_0x177:
	RJMP _0x178
_0x173:
	CPI  R30,LOW(0x2)
	BRNE _0x179
_0x178:
	LDI  R21,LOW(0)
	LDI  R17,LOW(3)
	CPI  R18,48
	BRNE _0x17A
	ORI  R16,LOW(128)
	RJMP _0x16F
_0x17A:
	RJMP _0x17B
_0x179:
	CPI  R30,LOW(0x3)
	BREQ PC+3
	JMP _0x16F
_0x17B:
	CPI  R18,48
	BRLO _0x17E
	CPI  R18,58
	BRLO _0x17F
_0x17E:
	RJMP _0x17D
_0x17F:
	MOV  R26,R21
	LDI  R30,LOW(10)
	MUL  R30,R26
	MOVW R30,R0
	MOV  R21,R30
	MOV  R30,R18
	SUBI R30,LOW(48)
	ADD  R21,R30
	RJMP _0x16F
_0x17D:
	MOV  R30,R18
	CPI  R30,LOW(0x63)
	BRNE _0x183
	CALL SUBOPT_0x46
	LD   R30,X
	CALL SUBOPT_0x47
	RJMP _0x184
_0x183:
	CPI  R30,LOW(0x73)
	BRNE _0x186
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
	CALL _strlen
	MOV  R17,R30
	RJMP _0x187
_0x186:
	CPI  R30,LOW(0x70)
	BRNE _0x189
	CALL SUBOPT_0x46
	CALL SUBOPT_0x48
	CALL _strlenf
	MOV  R17,R30
	ORI  R16,LOW(8)
_0x187:
	ORI  R16,LOW(2)
	ANDI R16,LOW(127)
	LDI  R19,LOW(0)
	RJMP _0x18A
_0x189:
	CPI  R30,LOW(0x64)
	BREQ _0x18D
	CPI  R30,LOW(0x69)
	BRNE _0x18E
_0x18D:
	ORI  R16,LOW(4)
	RJMP _0x18F
_0x18E:
	CPI  R30,LOW(0x75)
	BRNE _0x190
_0x18F:
	LDI  R30,LOW(_tbl10_G2*2)
	LDI  R31,HIGH(_tbl10_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(5)
	RJMP _0x191
_0x190:
	CPI  R30,LOW(0x58)
	BRNE _0x193
	ORI  R16,LOW(8)
	RJMP _0x194
_0x193:
	CPI  R30,LOW(0x78)
	BREQ PC+3
	JMP _0x1C5
_0x194:
	LDI  R30,LOW(_tbl16_G2*2)
	LDI  R31,HIGH(_tbl16_G2*2)
	STD  Y+6,R30
	STD  Y+6+1,R31
	LDI  R17,LOW(4)
_0x191:
	SBRS R16,2
	RJMP _0x196
	CALL SUBOPT_0x46
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	SBIW R26,0
	BRGE _0x197
	CALL __ANEGW1
	STD  Y+10,R30
	STD  Y+10+1,R31
	LDI  R20,LOW(45)
_0x197:
	CPI  R20,0
	BREQ _0x198
	SUBI R17,-LOW(1)
	RJMP _0x199
_0x198:
	ANDI R16,LOW(251)
_0x199:
	RJMP _0x19A
_0x196:
	CALL SUBOPT_0x46
	CALL __GETW1P
	STD  Y+10,R30
	STD  Y+10+1,R31
_0x19A:
_0x18A:
	SBRC R16,0
	RJMP _0x19B
_0x19C:
	CP   R17,R21
	BRSH _0x19E
	SBRS R16,7
	RJMP _0x19F
	SBRS R16,2
	RJMP _0x1A0
	ANDI R16,LOW(251)
	MOV  R18,R20
	SUBI R17,LOW(1)
	RJMP _0x1A1
_0x1A0:
	LDI  R18,LOW(48)
_0x1A1:
	RJMP _0x1A2
_0x19F:
	LDI  R18,LOW(32)
_0x1A2:
	CALL SUBOPT_0x45
	SUBI R21,LOW(1)
	RJMP _0x19C
_0x19E:
_0x19B:
	MOV  R19,R17
	SBRS R16,1
	RJMP _0x1A3
_0x1A4:
	CPI  R19,0
	BREQ _0x1A6
	SBRS R16,3
	RJMP _0x1A7
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	ADIW R30,1
	STD  Y+6,R30
	STD  Y+6+1,R31
	SBIW R30,1
	LPM  R30,Z
	RJMP _0x1F2
_0x1A7:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LD   R30,X+
	STD  Y+6,R26
	STD  Y+6+1,R27
_0x1F2:
	ST   -Y,R30
	CALL SUBOPT_0x49
	CPI  R21,0
	BREQ _0x1A9
	SUBI R21,LOW(1)
_0x1A9:
	SUBI R19,LOW(1)
	RJMP _0x1A4
_0x1A6:
	RJMP _0x1AA
_0x1A3:
_0x1AC:
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
_0x1AE:
	LDD  R30,Y+8
	LDD  R31,Y+8+1
	LDD  R26,Y+10
	LDD  R27,Y+10+1
	CP   R26,R30
	CPC  R27,R31
	BRLO _0x1B0
	SUBI R18,-LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	LDD  R30,Y+10
	LDD  R31,Y+10+1
	SUB  R30,R26
	SBC  R31,R27
	STD  Y+10,R30
	STD  Y+10+1,R31
	RJMP _0x1AE
_0x1B0:
	CPI  R18,58
	BRLO _0x1B1
	SBRS R16,3
	RJMP _0x1B2
	SUBI R18,-LOW(7)
	RJMP _0x1B3
_0x1B2:
	SUBI R18,-LOW(39)
_0x1B3:
_0x1B1:
	SBRC R16,4
	RJMP _0x1B5
	CPI  R18,49
	BRSH _0x1B7
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,1
	BRNE _0x1B6
_0x1B7:
	RJMP _0x1F3
_0x1B6:
	CP   R21,R19
	BRLO _0x1BB
	SBRS R16,0
	RJMP _0x1BC
_0x1BB:
	RJMP _0x1BA
_0x1BC:
	LDI  R18,LOW(32)
	SBRS R16,7
	RJMP _0x1BD
	LDI  R18,LOW(48)
_0x1F3:
	ORI  R16,LOW(16)
	SBRS R16,2
	RJMP _0x1BE
	ANDI R16,LOW(251)
	ST   -Y,R20
	CALL SUBOPT_0x49
	CPI  R21,0
	BREQ _0x1BF
	SUBI R21,LOW(1)
_0x1BF:
_0x1BE:
_0x1BD:
_0x1B5:
	CALL SUBOPT_0x45
	CPI  R21,0
	BREQ _0x1C0
	SUBI R21,LOW(1)
_0x1C0:
_0x1BA:
	SUBI R19,LOW(1)
	LDD  R26,Y+8
	LDD  R27,Y+8+1
	SBIW R26,2
	BRLO _0x1AD
	RJMP _0x1AC
_0x1AD:
_0x1AA:
	SBRS R16,0
	RJMP _0x1C1
_0x1C2:
	CPI  R21,0
	BREQ _0x1C4
	SUBI R21,LOW(1)
	LDI  R30,LOW(32)
	CALL SUBOPT_0x47
	RJMP _0x1C2
_0x1C4:
_0x1C1:
_0x1C5:
_0x184:
_0x1F1:
	LDI  R17,LOW(0)
_0x16F:
	RJMP _0x16A
_0x16C:
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
_lcd_write_byte:
	CALL __lcd_ready
	LDD  R30,Y+1
	CALL SUBOPT_0x4A
    sbi   __lcd_port,__lcd_rs     ;RS=1
	LD   R30,Y
	ST   -Y,R30
	CALL __lcd_write_data
	ADIW R28,2
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
	CALL SUBOPT_0x4A
	LDI  R30,LOW(12)
	CALL SUBOPT_0x4A
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
	BRSH _0x1C7
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
_0x1C7:
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
_0x1C8:
	LDD  R26,Y+1
	LDD  R27,Y+1+1
	LD   R30,X+
	STD  Y+1,R26
	STD  Y+1+1,R27
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x1CA
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x1C8
_0x1CA:
	LDD  R17,Y+0
	RJMP _0x1D0
_lcd_putsf:
	ST   -Y,R17
_0x1CB:
	LDD  R30,Y+1
	LDD  R31,Y+1+1
	ADIW R30,1
	STD  Y+1,R30
	STD  Y+1+1,R31
	SBIW R30,1
	LPM  R30,Z
	MOV  R17,R30
	CPI  R30,0
	BREQ _0x1CD
	ST   -Y,R17
	CALL _lcd_putchar
	RJMP _0x1CB
_0x1CD:
	LDD  R17,Y+0
_0x1D0:
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
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4B
	CALL SUBOPT_0x4B
	CALL __long_delay_G3
	LDI  R30,LOW(32)
	ST   -Y,R30
	CALL __lcd_init_write_G3
	CALL __long_delay_G3
	LDI  R30,LOW(40)
	CALL SUBOPT_0x4C
	LDI  R30,LOW(4)
	CALL SUBOPT_0x4C
	LDI  R30,LOW(133)
	CALL SUBOPT_0x4C
    in    r26,__lcd_direction
    andi  r26,0xf                 ;set as input
    out   __lcd_direction,r26
    sbi   __lcd_port,__lcd_rd     ;RD=1
	CALL _lcd_read_byte0_G3
	CPI  R30,LOW(0x5)
	BREQ _0x1CE
	LDI  R30,LOW(0)
	RJMP _0x1CF
_0x1CE:
	CALL __lcd_ready
	LDI  R30,LOW(6)
	ST   -Y,R30
	CALL __lcd_write_data
	CALL _lcd_clear
	LDI  R30,LOW(1)
_0x1CF:
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

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:75 WORDS
SUBOPT_0x4:
	ST   -Y,R31
	ST   -Y,R30
	JMP  _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R26,LOW(_Kp)
	LDI  R27,HIGH(_Kp)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x6:
	LDI  R26,LOW(_Ki)
	LDI  R27,HIGH(_Ki)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x7:
	LDI  R26,LOW(_Kd)
	LDI  R27,HIGH(_Kd)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x8:
	LDI  R26,LOW(_MAXSpeed)
	LDI  R27,HIGH(_MAXSpeed)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x9:
	LDI  R26,LOW(_MINSpeed)
	LDI  R27,HIGH(_MINSpeed)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0xA:
	LDI  R30,0
	STS  _lpwm,R30
	STS  _lpwm+1,R30
	LDI  R30,0
	STS  _rpwm,R30
	STS  _rpwm+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xB:
	LDS  R26,_b
	LDS  R27,_b+1
	CPI  R26,LOW(0xFF)
	LDI  R30,HIGH(0xFF)
	CPC  R27,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0xC:
	LDI  R30,LOW(125)
	LDI  R31,HIGH(125)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xD:
	LDS  R30,_lpwm
	LDS  R31,_lpwm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0xE:
	STS  _lpwm,R30
	STS  _lpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0xF:
	LDS  R30,_rpwm
	LDS  R31,_rpwm+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x10:
	STS  _rpwm,R30
	STS  _rpwm+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x11:
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
	RCALL SUBOPT_0xD
	CALL __CWD1
	CALL __PUTPARD1
	RCALL SUBOPT_0xF
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
SUBOPT_0x12:
	LDS  R30,_b
	LDS  R31,_b+1
	ADIW R30,1
	STS  _b,R30
	STS  _b+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x14:
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x15:
	LDI  R30,LOW(2)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x16:
	LDI  R30,LOW(3)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x17:
	LDI  R30,LOW(4)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x18:
	LDI  R30,LOW(5)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x19:
	LDI  R30,LOW(6)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1A:
	LDI  R30,LOW(7)
	ST   -Y,R30
	JMP  _read_adc

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x1B:
	CALL __DIVB21U
	MOV  R17,R30
	SUBI R17,-LOW(48)
	ST   -Y,R17
	CALL _lcd_putchar
	LDD  R26,Y+1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:61 WORDS
SUBOPT_0x1C:
	LDI  R30,LOW(0)
	ST   -Y,R30
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x1D:
	LDI  R30,LOW(200)
	LDI  R31,HIGH(200)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x1E:
	CALL _lcd_clear
	RJMP SUBOPT_0x1C

;OPTIMIZER ADDED SUBROUTINE, CALLED 12 TIMES, CODE SIZE REDUCTION:19 WORDS
SUBOPT_0x1F:
	LDI  R30,LOW(150)
	LDI  R31,HIGH(150)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x20:
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 17 TIMES, CODE SIZE REDUCTION:29 WORDS
SUBOPT_0x21:
	LDI  R30,LOW(32)
	ST   -Y,R30
	JMP  _lcd_putchar

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:9 WORDS
SUBOPT_0x22:
	ST   -Y,R30
	CALL _tampil
	RJMP SUBOPT_0x21

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x23:
	LDI  R30,LOW(0)
	ST   -Y,R30
	CALL _lcd_gotoxy
	RJMP SUBOPT_0x20

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x24:
	ST   -Y,R30
	CALL _setByte
	RJMP SUBOPT_0x1D

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:27 WORDS
SUBOPT_0x25:
	ST   -Y,R30
	LDI  R30,LOW(1)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 11 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x26:
	LDI  R26,LOW(_Mode)
	LDI  R27,HIGH(_Mode)
	CALL __EEPROMRDB
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x27:
	__POINTW1FN _0,504
	RJMP SUBOPT_0x1

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0x28:
	ST   -Y,R30
	LDI  R30,LOW(0)
	ST   -Y,R30
	JMP  _lcd_gotoxy

;OPTIMIZER ADDED SUBROUTINE, CALLED 22 TIMES, CODE SIZE REDUCTION:39 WORDS
SUBOPT_0x29:
	LDI  R30,LOW(_lcd)
	LDI  R31,HIGH(_lcd)
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 40 TIMES, CODE SIZE REDUCTION:114 WORDS
SUBOPT_0x2A:
	CLR  R31
	CLR  R22
	CLR  R23
	CALL __PUTPARD1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x2B:
	LDI  R24,16
	CALL _sprintf
	ADIW R28,20
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x2C:
	LDS  R26,_xcount
	LDI  R27,0
	CP   R30,R26
	CPC  R31,R27
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2D:
	LDS  R30,_ba0
	LDS  R26,_bb0
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	STS  _bt0,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 9 TIMES, CODE SIZE REDUCTION:21 WORDS
SUBOPT_0x2E:
	CALL _lcd_clear
	LDI  R30,LOW(1)
	RJMP SUBOPT_0x28

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:11 WORDS
SUBOPT_0x2F:
	__POINTW1FN _0,656
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0x30:
	LDI  R24,12
	CALL _sprintf
	ADIW R28,16
	RJMP SUBOPT_0x29

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x31:
	CALL _lcd_puts
	LDI  R30,LOW(50)
	LDI  R31,HIGH(50)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x32:
	LDS  R30,_ba1
	LDS  R26,_bb1
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	STS  _bt1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x33:
	LDS  R30,_ba2
	LDS  R26,_bb2
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	STS  _bt2,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x34:
	CALL _lcd_puts
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x35:
	LDS  R30,_ba3
	LDS  R26,_bb3
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	STS  _bt3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x36:
	LDS  R30,_ba4
	LDS  R26,_bb4
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	STS  _bt4,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x37:
	LDS  R30,_ba5
	LDS  R26,_bb5
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	STS  _bt5,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x38:
	LDS  R30,_ba6
	LDS  R26,_bb6
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	STS  _bt6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x39:
	LDS  R30,_ba7
	LDS  R26,_bb7
	ADD  R26,R30
	MOV  R30,R26
	LSR  R30
	MOV  R12,R30
	RJMP SUBOPT_0x2E

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x3A:
	CALL _bkan
	LDI  R30,0
	STS  _rpwm,R30
	STS  _rpwm+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:33 WORDS
SUBOPT_0x3B:
	RCALL SUBOPT_0xE
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	STS  _x,R30
	STS  _x+1,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x3C:
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3D:
	RCALL SUBOPT_0x10
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	RJMP SUBOPT_0x3B

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x3E:
	RCALL SUBOPT_0x10
	RJMP SUBOPT_0x3C

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x3F:
	CALL _maju
	LDI  R30,LOW(80)
	LDI  R31,HIGH(80)
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:17 WORDS
SUBOPT_0x40:
	RCALL SUBOPT_0xE
	LDI  R30,0
	STS  _x,R30
	STS  _x+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x41:
	CALL _maju
	LDI  R30,LOW(75)
	LDI  R31,HIGH(75)
	RJMP SUBOPT_0x10

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x42:
	RCALL SUBOPT_0x10
	LDI  R30,0
	STS  _lpwm,R30
	STS  _lpwm+1,R30
	LDI  R30,0
	STS  _x,R30
	STS  _x+1,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x43:
	CALL _stop
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x4

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x44:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x4

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

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4A:
	ST   -Y,R30
	CALL __lcd_write_data
	JMP  __lcd_ready

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x4B:
	CALL __long_delay_G3
	LDI  R30,LOW(48)
	ST   -Y,R30
	JMP  __lcd_init_write_G3

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x4C:
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
	__DELAY_USW 0xBB8
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
