
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega8535
;Program type             : Application
;Clock frequency          : 8,000000 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 128 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega8535
	#pragma AVRPART MEMORY PROG_FLASH 8192
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 607
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x60

	.LISTMAC
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

	.EQU __SRAM_START=0x0060
	.EQU __SRAM_END=0x025F
	.EQU __DSTACK_SIZE=0x0080
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

;NAME DEFINITIONS FOR GLOBAL VARIABLES ALLOCATED TO REGISTERS
	.DEF _kesalahan=R4
	.DEF _k=R6
	.DEF _i=R9
	.DEF _indeks=R8

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	RJMP __RESET
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
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00
	RJMP 0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0001

_0x3:
	.DB  0x0,0xCC,0x8C,0x46
_0x4:
	.DB  0x0,0x6,0x8D,0x46
_0x4D:
	.DB  0x0,0x0,0x0,0x0,0x0,0x0
_0x0:
	.DB  0x50,0x6C,0x65,0x61,0x73,0x65,0x20,0x70
	.DB  0x72,0x65,0x73,0x73,0x20,0x27,0x41,0x27
	.DB  0x0,0x74,0x6F,0x20,0x6C,0x6F,0x63,0x6B
	.DB  0x0,0x53,0x74,0x61,0x72,0x74,0x69,0x6E
	.DB  0x67,0x0,0x75,0x6E,0x6C,0x6F,0x63,0x6B
	.DB  0x65,0x64,0x0,0x77,0x72,0x6F,0x6E,0x67
	.DB  0x20,0x70,0x61,0x73,0x73,0x77,0x6F,0x72
	.DB  0x64,0x0,0x65,0x6E,0x74,0x65,0x72,0x20
	.DB  0x75,0x27,0x72,0x20,0x70,0x61,0x73,0x73
	.DB  0x0,0x2D,0x2D,0x2D,0x2D,0x2D,0x45,0x4C
	.DB  0x53,0x20,0x31,0x38,0x2D,0x2D,0x2D,0x2D
	.DB  0x2D,0x0
_0x2000060:
	.DB  0x1
_0x2000000:
	.DB  0x2D,0x4E,0x41,0x4E,0x0,0x49,0x4E,0x46
	.DB  0x0
_0x2040003:
	.DB  0x80,0x0,0xC0,0x0,0x94,0x0,0xD4

__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

	.DW  0x04
	.DW  _password1
	.DW  _0x3*2

	.DW  0x04
	.DW  _password2
	.DW  _0x4*2

	.DW  0x11
	.DW  _0x8
	.DW  _0x0*2

	.DW  0x08
	.DW  _0x8+17
	.DW  _0x0*2+17

	.DW  0x09
	.DW  _0x8+25
	.DW  _0x0*2+25

	.DW  0x09
	.DW  _0xD
	.DW  _0x0*2+34

	.DW  0x0F
	.DW  _0xD+9
	.DW  _0x0*2+43

	.DW  0x0F
	.DW  _0x30
	.DW  _0x0*2+58

	.DW  0x11
	.DW  _0x48
	.DW  _0x0*2+73

	.DW  0x06
	.DW  0x04
	.DW  _0x4D*2

	.DW  0x01
	.DW  __seed_G100
	.DW  _0x2000060*2

	.DW  0x07
	.DW  _base_y
	.DW  _0x2040003*2

_0xFFFFFFFF:
	.DW  0

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
	LDI  R24,(14-2)+1
	LDI  R26,2
	CLR  R27
__CLEAR_REG:
	ST   X+,R30
	DEC  R24
	BRNE __CLEAR_REG

;CLEAR SRAM
	LDI  R24,LOW(__CLEAR_SRAM_SIZE)
	LDI  R25,HIGH(__CLEAR_SRAM_SIZE)
	LDI  R26,__SRAM_START
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

;HARDWARE STACK POINTER INITIALIZATION
	LDI  R30,LOW(__SRAM_END-__HEAP_SIZE)
	OUT  SPL,R30
	LDI  R30,HIGH(__SRAM_END-__HEAP_SIZE)
	OUT  SPH,R30

;DATA STACK POINTER INITIALIZATION
	LDI  R28,LOW(__SRAM_START+__DSTACK_SIZE)
	LDI  R29,HIGH(__SRAM_START+__DSTACK_SIZE)

	RJMP _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0xE0

	.CSEG
;#include <mega8535.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include <stdlib.h>
;#include <stdio.h>
;
;int kesalahan = 0, k;
;float nilai=0, password1 = 18022, password2 = 18051;

	.DSEG
;char temp[12], array[10], i=0, indeks=0;
;//variabel indeks digunakan untuk mendeteksi jika indeks=0 unlock, indeks=1 lock
;
;// Alphanumeric LCD Module functions
;
;#include <i2clcd.h>
    .equ __sda_bit=1
	.equ __scl_bit=0
    //.equ __i2c_port=0x1b ;PORTA
   //.equ __i2c_port=0x18 ;PORTB
   .equ __i2c_port=0x15 ;PORTC
   //.equ __i2c_port=0x12 ;PORT
;
;void lock()
; 0000 0010 {

	.CSEG
_lock:
; 0000 0011  while (indeks==0)
_0x5:
	TST  R8
	BRNE _0x7
; 0000 0012       {
; 0000 0013       lcd_gotoxy(0,0);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL _lcd_gotoxy
; 0000 0014       lcd_puts("Please press 'A'");
	__POINTW1MN _0x8,0
	RCALL SUBOPT_0x1
; 0000 0015       lcd_gotoxy(0,1);
	RCALL SUBOPT_0x0
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 0016       lcd_puts("to lock");
	__POINTW1MN _0x8,17
	RCALL SUBOPT_0x1
; 0000 0017 
; 0000 0018       PORTD = 0b11111110;
	RCALL SUBOPT_0x2
; 0000 0019       delay_ms(30);
; 0000 001A       if (PIND.7 == 0)
	SBIC 0x10,7
	RJMP _0x9
; 0000 001B        {
; 0000 001C         indeks=1;
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 001D         PORTD.0=1;//terkunci
	SBI  0x12,0
; 0000 001E         lcd_clear();
	RCALL _lcd_clear
; 0000 001F         lcd_gotoxy(0,0);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL _lcd_gotoxy
; 0000 0020         lcd_puts("Starting");
	__POINTW1MN _0x8,25
	RCALL SUBOPT_0x1
; 0000 0021         delay_ms(1000);
	RCALL SUBOPT_0x3
; 0000 0022         lcd_clear();
	RCALL _lcd_clear
; 0000 0023         }
; 0000 0024       }
_0x9:
	RJMP _0x5
_0x7:
; 0000 0025 }
	RET

	.DSEG
_0x8:
	.BYTE 0x22
;
;void enter()
; 0000 0028 {

	.CSEG
_enter:
; 0000 0029 if (nilai==password1 | nilai == password2)
	LDS  R30,_password1
	LDS  R31,_password1+1
	LDS  R22,_password1+2
	LDS  R23,_password1+3
	RCALL SUBOPT_0x4
	MOV  R0,R30
	LDS  R30,_password2
	LDS  R31,_password2+1
	LDS  R22,_password2+2
	LDS  R23,_password2+3
	RCALL SUBOPT_0x4
	OR   R30,R0
	BREQ _0xC
; 0000 002A    {
; 0000 002B    lcd_clear();
	RCALL _lcd_clear
; 0000 002C    lcd_gotoxy(0,0);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL _lcd_gotoxy
; 0000 002D    lcd_puts("unlocked");
	__POINTW1MN _0xD,0
	RCALL SUBOPT_0x1
; 0000 002E    delay_ms(1000);
	RCALL SUBOPT_0x3
; 0000 002F    for(k = 0; k < 10; k++){ //Membuka
	CLR  R6
	CLR  R7
_0xF:
	RCALL SUBOPT_0x5
	BRGE _0x10
; 0000 0030      PORTB.3 = 1;
	SBI  0x18,3
; 0000 0031      delay_ms(1);
	RCALL SUBOPT_0x6
; 0000 0032      PORTB.3 = 0;
	CBI  0x18,3
; 0000 0033      delay_ms(19);
	LDI  R30,LOW(19)
	LDI  R31,HIGH(19)
	RCALL SUBOPT_0x7
; 0000 0034    }
	RCALL SUBOPT_0x8
	RJMP _0xF
_0x10:
; 0000 0035    delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RCALL SUBOPT_0x7
; 0000 0036    for(k = 0; k < 10; k++){
	CLR  R6
	CLR  R7
_0x16:
	RCALL SUBOPT_0x5
	BRGE _0x17
; 0000 0037      PORTB.3 = 1;
	SBI  0x18,3
; 0000 0038      delay_ms(2);
	RCALL SUBOPT_0x9
; 0000 0039      PORTB.3 = 0;
	CBI  0x18,3
; 0000 003A      delay_ms(18);
	LDI  R30,LOW(18)
	LDI  R31,HIGH(18)
	RCALL SUBOPT_0x7
; 0000 003B    }
	RCALL SUBOPT_0x8
	RJMP _0x16
_0x17:
; 0000 003C    delay_ms(5000);
	LDI  R30,LOW(5000)
	LDI  R31,HIGH(5000)
	RCALL SUBOPT_0x7
; 0000 003D    i=0; nilai=0; kesalahan = 0;
	RCALL SUBOPT_0xA
	CLR  R4
	CLR  R5
; 0000 003E    PORTD.0=0;//kunci terbuka
	CBI  0x12,0
; 0000 003F    indeks=0;
	CLR  R8
; 0000 0040    }
; 0000 0041 else
	RJMP _0x1E
_0xC:
; 0000 0042    {
; 0000 0043    lcd_clear();
	RCALL _lcd_clear
; 0000 0044    lcd_gotoxy(0,0);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL _lcd_gotoxy
; 0000 0045    lcd_puts("wrong password");
	__POINTW1MN _0xD,9
	RCALL SUBOPT_0x1
; 0000 0046    delay_ms(2500);
	LDI  R30,LOW(2500)
	LDI  R31,HIGH(2500)
	RCALL SUBOPT_0x7
; 0000 0047    i=0; nilai=0;
	RCALL SUBOPT_0xA
; 0000 0048    kesalahan++;
	MOVW R30,R4
	ADIW R30,1
	MOVW R4,R30
; 0000 0049    if(kesalahan == 3){
	LDI  R30,LOW(3)
	LDI  R31,HIGH(3)
	CP   R30,R4
	CPC  R31,R5
	BRNE _0x1F
; 0000 004A       PORTA.0 = 1;
	SBI  0x1B,0
; 0000 004B       for(k = 0; k < 20; k++){
	CLR  R6
	CLR  R7
_0x23:
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	CP   R6,R30
	CPC  R7,R31
	BRGE _0x24
; 0000 004C         PORTA.1 = 1;
	SBI  0x1B,1
; 0000 004D         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x7
; 0000 004E         PORTA.1 = 0;
	CBI  0x1B,1
; 0000 004F         delay_ms(500);
	LDI  R30,LOW(500)
	LDI  R31,HIGH(500)
	RCALL SUBOPT_0x7
; 0000 0050       }
	RCALL SUBOPT_0x8
	RJMP _0x23
_0x24:
; 0000 0051       PORTA.0 = 0;
	CBI  0x1B,0
; 0000 0052    }
; 0000 0053    else{
	RJMP _0x2B
_0x1F:
; 0000 0054       indeks=1;//karena password salah jadi masih terkunci
	LDI  R30,LOW(1)
	MOV  R8,R30
; 0000 0055    }
_0x2B:
; 0000 0056 }
_0x1E:
; 0000 0057 }
	RET

	.DSEG
_0xD:
	.BYTE 0x18
;
;void simpan_dlm_1variabel()
; 0000 005A {

	.CSEG
_simpan_dlm_1variabel:
; 0000 005B        if (i==1){nilai=array[i];}
	LDI  R30,LOW(1)
	CP   R30,R9
	BRNE _0x2C
	RCALL SUBOPT_0xB
	LDI  R26,LOW(_nilai)
	LDI  R27,HIGH(_nilai)
	CLR  R31
	CLR  R22
	CLR  R23
	RCALL __CDF1
	RCALL __PUTDP1
; 0000 005C 
; 0000 005D        if (i>=2 && i<=8)
_0x2C:
	LDI  R30,LOW(2)
	CP   R9,R30
	BRLO _0x2E
	LDI  R30,LOW(8)
	CP   R30,R9
	BRSH _0x2F
_0x2E:
	RJMP _0x2D
_0x2F:
; 0000 005E            {
; 0000 005F            nilai=(nilai*10)+array[i];
	RCALL SUBOPT_0xC
	RCALL SUBOPT_0xD
	MOVW R26,R30
	MOVW R24,R22
	RCALL SUBOPT_0xB
	RCALL SUBOPT_0xE
	RCALL SUBOPT_0xF
	RCALL __ADDF12
	STS  _nilai,R30
	STS  _nilai+1,R31
	STS  _nilai+2,R22
	STS  _nilai+3,R23
; 0000 0060            }
; 0000 0061 }
_0x2D:
	RET
;
;void scanning_keypad()//scanning pendeteksian penekanan keypad
; 0000 0064 {
_scanning_keypad:
; 0000 0065 lcd_gotoxy(0,0);
	RCALL SUBOPT_0x0
	RCALL SUBOPT_0x0
	RCALL _lcd_gotoxy
; 0000 0066 lcd_puts("enter u'r pass");
	__POINTW1MN _0x30,0
	RCALL SUBOPT_0x1
; 0000 0067 
; 0000 0068 PORTD = 0b11110111;
	LDI  R30,LOW(247)
	RCALL SUBOPT_0x10
; 0000 0069 delay_ms(30);
; 0000 006A if (PIND.7 == 0) {i++; array[i]=1; simpan_dlm_1variabel(); delay_ms(300);}
	SBIC 0x10,7
	RJMP _0x31
	RCALL SUBOPT_0x11
	LDI  R26,LOW(1)
	RCALL SUBOPT_0x12
; 0000 006B if (PIND.6 == 0) {i++; array[i]=4; simpan_dlm_1variabel(); delay_ms(300);}
_0x31:
	SBIC 0x10,6
	RJMP _0x32
	RCALL SUBOPT_0x11
	LDI  R26,LOW(4)
	RCALL SUBOPT_0x12
; 0000 006C if (PIND.5 == 0) {i++; array[i]=7; simpan_dlm_1variabel(); delay_ms(300);}
_0x32:
	SBIC 0x10,5
	RJMP _0x33
	RCALL SUBOPT_0x11
	LDI  R26,LOW(7)
	RCALL SUBOPT_0x12
; 0000 006D if (PIND.4 == 0) {lcd_clear();i=0;nilai=0;delay_ms(300);}
_0x33:
	SBIC 0x10,4
	RJMP _0x34
	RCALL _lcd_clear
	RCALL SUBOPT_0xA
	RCALL SUBOPT_0x13
; 0000 006E 
; 0000 006F PORTD = 0b11111011;
_0x34:
	LDI  R30,LOW(251)
	RCALL SUBOPT_0x10
; 0000 0070 delay_ms(30);
; 0000 0071 if (PIND.7 == 0) {i++; array[i]=2; simpan_dlm_1variabel(); delay_ms(300);}
	SBIC 0x10,7
	RJMP _0x35
	RCALL SUBOPT_0x11
	LDI  R26,LOW(2)
	RCALL SUBOPT_0x12
; 0000 0072 if (PIND.6 == 0) {i++; array[i]=5; simpan_dlm_1variabel(); delay_ms(300);}
_0x35:
	SBIC 0x10,6
	RJMP _0x36
	RCALL SUBOPT_0x11
	LDI  R26,LOW(5)
	RCALL SUBOPT_0x12
; 0000 0073 if (PIND.5 == 0) {i++; array[i]=8; simpan_dlm_1variabel(); delay_ms(300);}
_0x36:
	SBIC 0x10,5
	RJMP _0x37
	RCALL SUBOPT_0x11
	LDI  R26,LOW(8)
	RCALL SUBOPT_0x12
; 0000 0074 if (PIND.4 == 0) {i++; array[i]=0; simpan_dlm_1variabel(); delay_ms(300);}
_0x37:
	SBIC 0x10,4
	RJMP _0x38
	RCALL SUBOPT_0x11
	LDI  R26,LOW(0)
	RCALL SUBOPT_0x12
; 0000 0075 
; 0000 0076 PORTD = 0b11111101;
_0x38:
	LDI  R30,LOW(253)
	RCALL SUBOPT_0x10
; 0000 0077 delay_ms(30);
; 0000 0078 if (PIND.7 == 0) {i++; array[i]=3; simpan_dlm_1variabel(); delay_ms(300);}
	SBIC 0x10,7
	RJMP _0x39
	RCALL SUBOPT_0x11
	LDI  R26,LOW(3)
	RCALL SUBOPT_0x12
; 0000 0079 if (PIND.6 == 0) {i++; array[i]=6; simpan_dlm_1variabel(); delay_ms(300);}
_0x39:
	SBIC 0x10,6
	RJMP _0x3A
	RCALL SUBOPT_0x11
	LDI  R26,LOW(6)
	RCALL SUBOPT_0x12
; 0000 007A if (PIND.5 == 0) {i++; array[i]=9; simpan_dlm_1variabel(); delay_ms(300);}
_0x3A:
	SBIC 0x10,5
	RJMP _0x3B
	RCALL SUBOPT_0x11
	LDI  R26,LOW(9)
	RCALL SUBOPT_0x12
; 0000 007B if (PIND.4 == 0) {delay_ms(300);}
_0x3B:
	SBIS 0x10,4
	RCALL SUBOPT_0x13
; 0000 007C 
; 0000 007D PORTD = 0b11111110;
	RCALL SUBOPT_0x2
; 0000 007E delay_ms(30);
; 0000 007F if (PIND.7 == 0) {delay_ms(300);}
	SBIS 0x10,7
	RCALL SUBOPT_0x13
; 0000 0080 if (PIND.6 == 0) {delay_ms(300);}
	SBIS 0x10,6
	RCALL SUBOPT_0x13
; 0000 0081 if (PIND.5 == 0) {i=0; nilai=0; lcd_clear(); delay_ms(300);}
	SBIC 0x10,5
	RJMP _0x3F
	RCALL SUBOPT_0xA
	RCALL _lcd_clear
	RCALL SUBOPT_0x13
; 0000 0082 if (PIND.4 == 0) {enter();delay_ms(300);}
_0x3F:
	SBIC 0x10,4
	RJMP _0x40
	RCALL _enter
	RCALL SUBOPT_0x13
; 0000 0083 }
_0x40:
	RET

	.DSEG
_0x30:
	.BYTE 0xF
;
;void tampil_lcd()
; 0000 0086 {

	.CSEG
_tampil_lcd:
; 0000 0087 if (nilai>0)
	RCALL SUBOPT_0xC
	RCALL __CPD02
	BRGE _0x41
; 0000 0088     {
; 0000 0089         ftoa(nilai,0,temp);
	LDS  R30,_nilai
	LDS  R31,_nilai+1
	LDS  R22,_nilai+2
	LDS  R23,_nilai+3
	RCALL __PUTPARD1
	RCALL SUBOPT_0x0
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	RCALL SUBOPT_0x14
	RCALL _ftoa
; 0000 008A         lcd_gotoxy(0,1);
	RCALL SUBOPT_0x0
	LDI  R30,LOW(1)
	ST   -Y,R30
	RCALL _lcd_gotoxy
; 0000 008B         lcd_puts(temp);
	LDI  R30,LOW(_temp)
	LDI  R31,HIGH(_temp)
	RCALL SUBOPT_0x1
; 0000 008C     }
; 0000 008D }
_0x41:
	RET
;
;void main(void)
; 0000 0090 {
_main:
; 0000 0091 DDRA.0 = 1;
	SBI  0x1A,0
; 0000 0092 DDRA.1 = 1;
	SBI  0x1A,1
; 0000 0093 PORTD = 0xff;
	LDI  R30,LOW(255)
	OUT  0x12,R30
; 0000 0094 DDRD = 0x0f;
	LDI  R30,LOW(15)
	OUT  0x11,R30
; 0000 0095 
; 0000 0096 DDRB.3 = 1;
	SBI  0x17,3
; 0000 0097 
; 0000 0098 
; 0000 0099 // Analog Comparator initialization
; 0000 009A // Analog Comparator: Off
; 0000 009B // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 009C ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 009D SFIOR=0x00;
	LDI  R30,LOW(0)
	OUT  0x30,R30
; 0000 009E 
; 0000 009F // LCD module initialization
; 0000 00A0 lcd_init();
	RCALL _lcd_init
; 0000 00A1 lcd_puts("-----ELS 18-----");
	__POINTW1MN _0x48,0
	RCALL SUBOPT_0x1
; 0000 00A2 delay_ms(1500);
	LDI  R30,LOW(1500)
	LDI  R31,HIGH(1500)
	RCALL SUBOPT_0x7
; 0000 00A3 lcd_clear();
	RCALL _lcd_clear
; 0000 00A4 
; 0000 00A5 while (1)
_0x49:
; 0000 00A6       {
; 0000 00A7       lock();
	RCALL _lock
; 0000 00A8       scanning_keypad();
	RCALL _scanning_keypad
; 0000 00A9       tampil_lcd();
	RCALL _tampil_lcd
; 0000 00AA       };
	RJMP _0x49
; 0000 00AB }
_0x4C:
	RJMP _0x4C

	.DSEG
_0x48:
	.BYTE 0x11

	.CSEG
_ftoa:
	SBIW R28,4
	LDI  R30,LOW(0)
	ST   Y,R30
	STD  Y+1,R30
	STD  Y+2,R30
	LDI  R30,LOW(63)
	STD  Y+3,R30
	RCALL __SAVELOCR2
	LDD  R30,Y+11
	LDD  R31,Y+11+1
	CPI  R30,LOW(0xFFFF)
	LDI  R26,HIGH(0xFFFF)
	CPC  R31,R26
	BRNE _0x200000D
	RCALL SUBOPT_0x15
	__POINTW1FN _0x2000000,0
	RCALL SUBOPT_0x14
	RCALL _strcpyf
	RJMP _0x20C0005
_0x200000D:
	CPI  R30,LOW(0x7FFF)
	LDI  R26,HIGH(0x7FFF)
	CPC  R31,R26
	BRNE _0x200000C
	RCALL SUBOPT_0x15
	__POINTW1FN _0x2000000,1
	RCALL SUBOPT_0x14
	RCALL _strcpyf
	RJMP _0x20C0005
_0x200000C:
	LDD  R26,Y+12
	TST  R26
	BRPL _0x200000F
	RCALL SUBOPT_0x16
	RCALL __ANEGF1
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x18
	LDI  R30,LOW(45)
	ST   X,R30
_0x200000F:
	LDD  R26,Y+8
	CPI  R26,LOW(0x7)
	BRLO _0x2000010
	LDI  R30,LOW(6)
	STD  Y+8,R30
_0x2000010:
	LDD  R17,Y+8
_0x2000011:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x2000013
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	RCALL SUBOPT_0x1B
	RJMP _0x2000011
_0x2000013:
	RCALL SUBOPT_0x1C
	RCALL __ADDF12
	RCALL SUBOPT_0x17
	LDI  R17,LOW(0)
	__GETD1N 0x3F800000
	RCALL SUBOPT_0x1B
_0x2000014:
	RCALL SUBOPT_0x1C
	RCALL __CMPF12
	BRLO _0x2000016
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x1B
	SUBI R17,-LOW(1)
	CPI  R17,39
	BRLO _0x2000017
	RCALL SUBOPT_0x15
	__POINTW1FN _0x2000000,5
	RCALL SUBOPT_0x14
	RCALL _strcpyf
	RJMP _0x20C0005
_0x2000017:
	RJMP _0x2000014
_0x2000016:
	CPI  R17,0
	BRNE _0x2000018
	RCALL SUBOPT_0x18
	LDI  R30,LOW(48)
	ST   X,R30
	RJMP _0x2000019
_0x2000018:
_0x200001A:
	MOV  R30,R17
	SUBI R17,1
	CPI  R30,0
	BREQ _0x200001C
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0x1A
	__GETD2N 0x3F000000
	RCALL __ADDF12
	RCALL __PUTPARD1
	RCALL _floor
	RCALL SUBOPT_0x1B
	RCALL SUBOPT_0x1C
	RCALL __DIVF21
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x19
	RCALL SUBOPT_0xF
	RCALL __MULF12
	RCALL SUBOPT_0x1E
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x17
	RJMP _0x200001A
_0x200001C:
_0x2000019:
	LDD  R30,Y+8
	CPI  R30,0
	BREQ _0x20C0004
	RCALL SUBOPT_0x18
	LDI  R30,LOW(46)
	ST   X,R30
_0x200001E:
	LDD  R30,Y+8
	SUBI R30,LOW(1)
	STD  Y+8,R30
	SUBI R30,-LOW(1)
	BREQ _0x2000020
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0xD
	RCALL SUBOPT_0x17
	RCALL SUBOPT_0x16
	RCALL __CFD1U
	MOV  R16,R30
	RCALL SUBOPT_0x18
	RCALL SUBOPT_0x1D
	RCALL SUBOPT_0x1E
	RCALL SUBOPT_0xF
	RCALL __SWAPD12
	RCALL __SUBF12
	RCALL SUBOPT_0x17
	RJMP _0x200001E
_0x2000020:
_0x20C0004:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	LDI  R30,LOW(0)
	ST   X,R30
_0x20C0005:
	RCALL __LOADLOCR2
	ADIW R28,13
	RET

	.DSEG

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x40
	.EQU __sm_mask=0xB0
	.EQU __sm_powerdown=0x20
	.EQU __sm_powersave=0x30
	.EQU __sm_standby=0xA0
	.EQU __sm_ext_standby=0xB0
	.EQU __sm_adc_noise_red=0x10
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.DSEG

	.CSEG
_lcd_write:
	RCALL __SAVELOCR2
	LDI  R17,0
	LDI  R16,0
	RCALL _i2c_start
	MOV  R17,R30
	CPI  R17,1
	BRNE _0x2040004
	LDI  R30,LOW(78)
	ST   -Y,R30
	RCALL _i2c_write
	MOV  R16,R30
	SBRS R2,0
	RJMP _0x2040006
	LDD  R30,Y+2
	ORI  R30,8
	RJMP _0x204000C
_0x2040006:
	LDD  R30,Y+2
	ANDI R30,0XF7
_0x204000C:
	STD  Y+2,R30
	ST   -Y,R30
	RCALL _i2c_write
	MOV  R16,R30
	RCALL _i2c_stop
_0x2040004:
	MOV  R30,R16
	RCALL __LOADLOCR2
	ADIW R28,3
	RET
_lcd_reset:
	ST   -Y,R17
	LDI  R30,LOW(20)
	LDI  R31,HIGH(20)
	RCALL SUBOPT_0x7
	LDI  R17,LOW(52)
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	RCALL SUBOPT_0x7
	ORI  R17,LOW(4)
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x6
	ORI  R17,LOW(4)
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x6
	LDI  R17,LOW(36)
	RCALL SUBOPT_0x1F
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x6
	LD   R17,Y+
	RET
_lcd_cmd:
	ST   -Y,R17
	LDD  R30,Y+1
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x20
	LDD  R30,Y+1
	SWAP R30
	RCALL SUBOPT_0x21
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	LDD  R17,Y+0
	RJMP _0x20C0002
_lcd_init:
	RCALL _i2c_init
	RCALL _lcd_reset
	LDI  R30,LOW(12)
	ST   -Y,R30
	RCALL _lcd_cmd
	LDI  R30,LOW(6)
	ST   -Y,R30
	RCALL _lcd_cmd
	LDI  R30,LOW(128)
	RJMP _0x20C0003
_lcd_data:
	ST   -Y,R17
	LDD  R30,Y+1
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x20
	LDD  R30,Y+1
	SWAP R30
	RCALL SUBOPT_0x22
	RCALL SUBOPT_0x20
	RCALL SUBOPT_0x9
	RCALL SUBOPT_0x9
	LDD  R17,Y+0
	RJMP _0x20C0002
_lcd_puts:
	RCALL __SAVELOCR2
	__GETWRN 16,17,0
_0x204000A:
	RCALL SUBOPT_0x23
	CPI  R30,0
	BREQ _0x204000B
	RCALL SUBOPT_0x23
	ST   -Y,R30
	RCALL _lcd_data
	__ADDWRN 16,17,1
	RJMP _0x204000A
_0x204000B:
	RCALL __LOADLOCR2
	RJMP _0x20C0001
_lcd_clear:
	LDI  R30,LOW(1)
_0x20C0003:
	ST   -Y,R30
	RCALL _lcd_cmd
	RET
_lcd_gotoxy:
	LD   R30,Y
	LDI  R26,LOW(_base_y)
	LDI  R27,HIGH(_base_y)
	RCALL SUBOPT_0xE
	LSL  R30
	ROL  R31
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	LDD  R26,Y+1
	ADD  R30,R26
	ST   -Y,R30
	RCALL _lcd_cmd
_0x20C0002:
	ADIW R28,2
	RET

	.CSEG

	.CSEG
_ftrunc:
   ldd  r23,y+3
   ldd  r22,y+2
   ldd  r31,y+1
   ld   r30,y
   bst  r23,7
   lsl  r23
   sbrc r22,7
   sbr  r23,1
   mov  r25,r23
   subi r25,0x7e
   breq __ftrunc0
   brcs __ftrunc0
   cpi  r25,24
   brsh __ftrunc1
   clr  r26
   clr  r27
   clr  r24
__ftrunc2:
   sec
   ror  r24
   ror  r27
   ror  r26
   dec  r25
   brne __ftrunc2
   and  r30,r26
   and  r31,r27
   and  r22,r24
   rjmp __ftrunc1
__ftrunc0:
   clt
   clr  r23
   clr  r30
   clr  r31
   clr  r22
__ftrunc1:
   cbr  r22,0x80
   lsr  r23
   brcc __ftrunc3
   sbr  r22,0x80
__ftrunc3:
   bld  r23,7
   ld   r26,y+
   ld   r27,y+
   ld   r24,y+
   ld   r25,y+
   cp   r30,r26
   cpc  r31,r27
   cpc  r22,r24
   cpc  r23,r25
   bst  r25,7
   ret
_floor:
	RCALL SUBOPT_0x24
	RCALL __PUTPARD1
	RCALL _ftrunc
	RCALL __PUTD1S0
    brne __floor1
__floor0:
	RCALL SUBOPT_0x24
	RJMP _0x20C0001
__floor1:
    brtc __floor0
	RCALL SUBOPT_0x24
	__GETD2N 0x3F800000
	RCALL __SUBF12
_0x20C0001:
	ADIW R28,4
	RET

	.CSEG
_strcpyf:
    ld   r30,y+
    ld   r31,y+
    ld   r26,y+
    ld   r27,y+
    movw r24,r26
strcpyf0:
	lpm  r0,z+
    st   x+,r0
    tst  r0
    brne strcpyf0
    movw r30,r24
    ret

	.DSEG
_nilai:
	.BYTE 0x4
_password1:
	.BYTE 0x4
_password2:
	.BYTE 0x4
_temp:
	.BYTE 0xC
_array:
	.BYTE 0xA
__seed_G100:
	.BYTE 0x4
_base_y:
	.BYTE 0x8

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 13 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x0:
	LDI  R30,LOW(0)
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _lcd_puts

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x2:
	LDI  R30,LOW(254)
	OUT  0x12,R30
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x3:
	LDI  R30,LOW(1000)
	LDI  R31,HIGH(1000)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x4:
	LDS  R26,_nilai
	LDS  R27,_nilai+1
	LDS  R24,_nilai+2
	LDS  R25,_nilai+3
	RCALL __EQD12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x5:
	LDI  R30,LOW(10)
	LDI  R31,HIGH(10)
	CP   R6,R30
	CPC  R7,R31
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x6:
	LDI  R30,LOW(1)
	LDI  R31,HIGH(1)
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 34 TIMES, CODE SIZE REDUCTION:64 WORDS
SUBOPT_0x7:
	ST   -Y,R31
	ST   -Y,R30
	RJMP _delay_ms

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x8:
	MOVW R30,R6
	ADIW R30,1
	MOVW R6,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0x9:
	LDI  R30,LOW(2)
	LDI  R31,HIGH(2)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:25 WORDS
SUBOPT_0xA:
	CLR  R9
	LDI  R30,LOW(0)
	STS  _nilai,R30
	STS  _nilai+1,R30
	STS  _nilai+2,R30
	STS  _nilai+3,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0xB:
	MOV  R30,R9
	LDI  R31,0
	SUBI R30,LOW(-_array)
	SBCI R31,HIGH(-_array)
	LD   R30,Z
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0xC:
	LDS  R26,_nilai
	LDS  R27,_nilai+1
	LDS  R24,_nilai+2
	LDS  R25,_nilai+3
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:6 WORDS
SUBOPT_0xD:
	__GETD1N 0x41200000
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 14 TIMES, CODE SIZE REDUCTION:24 WORDS
SUBOPT_0xE:
	LDI  R31,0
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0xF:
	RCALL __CWD1
	RCALL __CDF1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x10:
	OUT  0x12,R30
	LDI  R30,LOW(30)
	LDI  R31,HIGH(30)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x11:
	INC  R9
	MOV  R30,R9
	RCALL SUBOPT_0xE
	SUBI R30,LOW(-_array)
	SBCI R31,HIGH(-_array)
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 10 TIMES, CODE SIZE REDUCTION:34 WORDS
SUBOPT_0x12:
	STD  Z+0,R26
	RCALL _simpan_dlm_1variabel
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 6 TIMES, CODE SIZE REDUCTION:8 WORDS
SUBOPT_0x13:
	LDI  R30,LOW(300)
	LDI  R31,HIGH(300)
	RJMP SUBOPT_0x7

;OPTIMIZER ADDED SUBROUTINE, CALLED 7 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x14:
	ST   -Y,R31
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x15:
	LDD  R30,Y+6
	LDD  R31,Y+6+1
	RJMP SUBOPT_0x14

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x16:
	__GETD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:10 WORDS
SUBOPT_0x17:
	__PUTD1S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 5 TIMES, CODE SIZE REDUCTION:18 WORDS
SUBOPT_0x18:
	LDD  R26,Y+6
	LDD  R27,Y+6+1
	ADIW R26,1
	STD  Y+6,R26
	STD  Y+6+1,R27
	SBIW R26,1
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x19:
	__GETD2S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1A:
	__GETD1N 0x3DCCCCCD
	RCALL __MULF12
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 4 TIMES, CODE SIZE REDUCTION:7 WORDS
SUBOPT_0x1B:
	__PUTD1S 2
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1C:
	__GETD1S 2
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:2 WORDS
SUBOPT_0x1D:
	MOV  R30,R16
	SUBI R30,-LOW(48)
	ST   X,R30
	MOV  R30,R16
	RJMP SUBOPT_0xE

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x1E:
	__GETD2S 9
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 16 TIMES, CODE SIZE REDUCTION:13 WORDS
SUBOPT_0x1F:
	ST   -Y,R17
	RJMP _lcd_write

;OPTIMIZER ADDED SUBROUTINE, CALLED 8 TIMES, CODE SIZE REDUCTION:5 WORDS
SUBOPT_0x20:
	ANDI R17,LOW(251)
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x21:
	ANDI R30,LOW(0xF0)
	ORI  R30,4
	MOV  R17,R30
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x22:
	ANDI R30,LOW(0xF0)
	ORI  R30,LOW(0x5)
	MOV  R17,R30
	RJMP SUBOPT_0x1F

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:3 WORDS
SUBOPT_0x23:
	MOVW R30,R16
	LDD  R26,Y+2
	LDD  R27,Y+2+1
	ADD  R26,R30
	ADC  R27,R31
	LD   R30,X
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:4 WORDS
SUBOPT_0x24:
	RCALL __GETD1S0
	RET


	.CSEG
	.equ __i2c_dir=__i2c_port-1
	.equ __i2c_pin=__i2c_port-2
_i2c_init:
	cbi  __i2c_port,__scl_bit
	cbi  __i2c_port,__sda_bit
	sbi  __i2c_dir,__scl_bit
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay2
_i2c_start:
	cbi  __i2c_dir,__sda_bit
	cbi  __i2c_dir,__scl_bit
	clr  r30
	nop
	sbis __i2c_pin,__sda_bit
	ret
	sbis __i2c_pin,__scl_bit
	ret
	rcall __i2c_delay1
	sbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	ldi  r30,1
__i2c_delay1:
	ldi  r22,13
	rjmp __i2c_delay2l
_i2c_stop:
	sbi  __i2c_dir,__sda_bit
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
__i2c_delay2:
	ldi  r22,27
__i2c_delay2l:
	dec  r22
	brne __i2c_delay2l
	ret
_i2c_read:
	ldi  r23,8
__i2c_read0:
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_read3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_read3
	rcall __i2c_delay1
	clc
	sbic __i2c_pin,__sda_bit
	sec
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	rol  r30
	dec  r23
	brne __i2c_read0
	ld   r23,y+
	tst  r23
	brne __i2c_read1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_read2
__i2c_read1:
	sbi  __i2c_dir,__sda_bit
__i2c_read2:
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	sbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_delay1

_i2c_write:
	ld   r30,y+
	ldi  r23,8
__i2c_write0:
	lsl  r30
	brcc __i2c_write1
	cbi  __i2c_dir,__sda_bit
	rjmp __i2c_write2
__i2c_write1:
	sbi  __i2c_dir,__sda_bit
__i2c_write2:
	rcall __i2c_delay2
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay1
__i2c_write3:
	sbis __i2c_pin,__scl_bit
	rjmp __i2c_write3
	rcall __i2c_delay1
	sbi  __i2c_dir,__scl_bit
	dec  r23
	brne __i2c_write0
	cbi  __i2c_dir,__sda_bit
	rcall __i2c_delay1
	cbi  __i2c_dir,__scl_bit
	rcall __i2c_delay2
	ldi  r30,1
	sbic __i2c_pin,__sda_bit
	clr  r30
	sbi  __i2c_dir,__scl_bit
	rjmp __i2c_delay1

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

__ANEGF1:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __ANEGF10
	SUBI R23,0x80
__ANEGF10:
	RET

__ROUND_REPACK:
	TST  R21
	BRPL __REPACK
	CPI  R21,0x80
	BRNE __ROUND_REPACK0
	SBRS R30,0
	RJMP __REPACK
__ROUND_REPACK0:
	ADIW R30,1
	ADC  R22,R25
	ADC  R23,R25
	BRVS __REPACK1

__REPACK:
	LDI  R21,0x80
	EOR  R21,R23
	BRNE __REPACK0
	PUSH R21
	RJMP __ZERORES
__REPACK0:
	CPI  R21,0xFF
	BREQ __REPACK1
	LSL  R22
	LSL  R0
	ROR  R21
	ROR  R22
	MOV  R23,R21
	RET
__REPACK1:
	PUSH R21
	TST  R0
	BRMI __REPACK2
	RJMP __MAXRES
__REPACK2:
	RJMP __MINRES

__UNPACK:
	LDI  R21,0x80
	MOV  R1,R25
	AND  R1,R21
	LSL  R24
	ROL  R25
	EOR  R25,R21
	LSL  R21
	ROR  R24

__UNPACK1:
	LDI  R21,0x80
	MOV  R0,R23
	AND  R0,R21
	LSL  R22
	ROL  R23
	EOR  R23,R21
	LSL  R21
	ROR  R22
	RET

__CFD1U:
	SET
	RJMP __CFD1U0
__CFD1:
	CLT
__CFD1U0:
	PUSH R21
	RCALL __UNPACK1
	CPI  R23,0x80
	BRLO __CFD10
	CPI  R23,0xFF
	BRCC __CFD10
	RJMP __ZERORES
__CFD10:
	LDI  R21,22
	SUB  R21,R23
	BRPL __CFD11
	NEG  R21
	CPI  R21,8
	BRTC __CFD19
	CPI  R21,9
__CFD19:
	BRLO __CFD17
	SER  R30
	SER  R31
	SER  R22
	LDI  R23,0x7F
	BLD  R23,7
	RJMP __CFD15
__CFD17:
	CLR  R23
	TST  R21
	BREQ __CFD15
__CFD18:
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R23
	DEC  R21
	BRNE __CFD18
	RJMP __CFD15
__CFD11:
	CLR  R23
__CFD12:
	CPI  R21,8
	BRLO __CFD13
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R23
	SUBI R21,8
	RJMP __CFD12
__CFD13:
	TST  R21
	BREQ __CFD15
__CFD14:
	LSR  R23
	ROR  R22
	ROR  R31
	ROR  R30
	DEC  R21
	BRNE __CFD14
__CFD15:
	TST  R0
	BRPL __CFD16
	RCALL __ANEGD1
__CFD16:
	POP  R21
	RET

__CDF1U:
	SET
	RJMP __CDF1U0
__CDF1:
	CLT
__CDF1U0:
	SBIW R30,0
	SBCI R22,0
	SBCI R23,0
	BREQ __CDF10
	CLR  R0
	BRTS __CDF11
	TST  R23
	BRPL __CDF11
	COM  R0
	RCALL __ANEGD1
__CDF11:
	MOV  R1,R23
	LDI  R23,30
	TST  R1
__CDF12:
	BRMI __CDF13
	DEC  R23
	LSL  R30
	ROL  R31
	ROL  R22
	ROL  R1
	RJMP __CDF12
__CDF13:
	MOV  R30,R31
	MOV  R31,R22
	MOV  R22,R1
	PUSH R21
	RCALL __REPACK
	POP  R21
__CDF10:
	RET

__SWAPACC:
	PUSH R20
	MOVW R20,R30
	MOVW R30,R26
	MOVW R26,R20
	MOVW R20,R22
	MOVW R22,R24
	MOVW R24,R20
	MOV  R20,R0
	MOV  R0,R1
	MOV  R1,R20
	POP  R20
	RET

__UADD12:
	ADD  R30,R26
	ADC  R31,R27
	ADC  R22,R24
	RET

__NEGMAN1:
	COM  R30
	COM  R31
	COM  R22
	SUBI R30,-1
	SBCI R31,-1
	SBCI R22,-1
	RET

__SUBF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129
	LDI  R21,0x80
	EOR  R1,R21

	RJMP __ADDF120

__ADDF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R25,0x80
	BREQ __ADDF129

__ADDF120:
	CPI  R23,0x80
	BREQ __ADDF128
__ADDF121:
	MOV  R21,R23
	SUB  R21,R25
	BRVS __ADDF1211
	BRPL __ADDF122
	RCALL __SWAPACC
	RJMP __ADDF121
__ADDF122:
	CPI  R21,24
	BRLO __ADDF123
	CLR  R26
	CLR  R27
	CLR  R24
__ADDF123:
	CPI  R21,8
	BRLO __ADDF124
	MOV  R26,R27
	MOV  R27,R24
	CLR  R24
	SUBI R21,8
	RJMP __ADDF123
__ADDF124:
	TST  R21
	BREQ __ADDF126
__ADDF125:
	LSR  R24
	ROR  R27
	ROR  R26
	DEC  R21
	BRNE __ADDF125
__ADDF126:
	MOV  R21,R0
	EOR  R21,R1
	BRMI __ADDF127
	RCALL __UADD12
	BRCC __ADDF129
	ROR  R22
	ROR  R31
	ROR  R30
	INC  R23
	BRVC __ADDF129
	RJMP __MAXRES
__ADDF128:
	RCALL __SWAPACC
__ADDF129:
	RCALL __REPACK
	POP  R21
	RET
__ADDF1211:
	BRCC __ADDF128
	RJMP __ADDF129
__ADDF127:
	SUB  R30,R26
	SBC  R31,R27
	SBC  R22,R24
	BREQ __ZERORES
	BRCC __ADDF1210
	COM  R0
	RCALL __NEGMAN1
__ADDF1210:
	TST  R22
	BRMI __ADDF129
	LSL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVC __ADDF1210

__ZERORES:
	CLR  R30
	CLR  R31
	CLR  R22
	CLR  R23
	POP  R21
	RET

__MINRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	SER  R23
	POP  R21
	RET

__MAXRES:
	SER  R30
	SER  R31
	LDI  R22,0x7F
	LDI  R23,0x7F
	POP  R21
	RET

__MULF12:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BREQ __ZERORES
	CPI  R25,0x80
	BREQ __ZERORES
	EOR  R0,R1
	SEC
	ADC  R23,R25
	BRVC __MULF124
	BRLT __ZERORES
__MULF125:
	TST  R0
	BRMI __MINRES
	RJMP __MAXRES
__MULF124:
	PUSH R0
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R17
	CLR  R18
	CLR  R25
	MUL  R22,R24
	MOVW R20,R0
	MUL  R24,R31
	MOV  R19,R0
	ADD  R20,R1
	ADC  R21,R25
	MUL  R22,R27
	ADD  R19,R0
	ADC  R20,R1
	ADC  R21,R25
	MUL  R24,R30
	RCALL __MULF126
	MUL  R27,R31
	RCALL __MULF126
	MUL  R22,R26
	RCALL __MULF126
	MUL  R27,R30
	RCALL __MULF127
	MUL  R26,R31
	RCALL __MULF127
	MUL  R26,R30
	ADD  R17,R1
	ADC  R18,R25
	ADC  R19,R25
	ADC  R20,R25
	ADC  R21,R25
	MOV  R30,R19
	MOV  R31,R20
	MOV  R22,R21
	MOV  R21,R18
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	POP  R0
	TST  R22
	BRMI __MULF122
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	RJMP __MULF123
__MULF122:
	INC  R23
	BRVS __MULF125
__MULF123:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__MULF127:
	ADD  R17,R0
	ADC  R18,R1
	ADC  R19,R25
	RJMP __MULF128
__MULF126:
	ADD  R18,R0
	ADC  R19,R1
__MULF128:
	ADC  R20,R25
	ADC  R21,R25
	RET

__DIVF21:
	PUSH R21
	RCALL __UNPACK
	CPI  R23,0x80
	BRNE __DIVF210
	TST  R1
__DIVF211:
	BRPL __DIVF219
	RJMP __MINRES
__DIVF219:
	RJMP __MAXRES
__DIVF210:
	CPI  R25,0x80
	BRNE __DIVF218
__DIVF217:
	RJMP __ZERORES
__DIVF218:
	EOR  R0,R1
	SEC
	SBC  R25,R23
	BRVC __DIVF216
	BRLT __DIVF217
	TST  R0
	RJMP __DIVF211
__DIVF216:
	MOV  R23,R25
	PUSH R17
	PUSH R18
	PUSH R19
	PUSH R20
	CLR  R1
	CLR  R17
	CLR  R18
	CLR  R19
	CLR  R20
	CLR  R21
	LDI  R25,32
__DIVF212:
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	CPC  R20,R17
	BRLO __DIVF213
	SUB  R26,R30
	SBC  R27,R31
	SBC  R24,R22
	SBC  R20,R17
	SEC
	RJMP __DIVF214
__DIVF213:
	CLC
__DIVF214:
	ROL  R21
	ROL  R18
	ROL  R19
	ROL  R1
	ROL  R26
	ROL  R27
	ROL  R24
	ROL  R20
	DEC  R25
	BRNE __DIVF212
	MOVW R30,R18
	MOV  R22,R1
	POP  R20
	POP  R19
	POP  R18
	POP  R17
	TST  R22
	BRMI __DIVF215
	LSL  R21
	ROL  R30
	ROL  R31
	ROL  R22
	DEC  R23
	BRVS __DIVF217
__DIVF215:
	RCALL __ROUND_REPACK
	POP  R21
	RET

__CMPF12:
	TST  R25
	BRMI __CMPF120
	TST  R23
	BRMI __CMPF121
	CP   R25,R23
	BRLO __CMPF122
	BRNE __CMPF121
	CP   R26,R30
	CPC  R27,R31
	CPC  R24,R22
	BRLO __CMPF122
	BREQ __CMPF123
__CMPF121:
	CLZ
	CLC
	RET
__CMPF122:
	CLZ
	SEC
	RET
__CMPF123:
	SEZ
	CLC
	RET
__CMPF120:
	TST  R23
	BRPL __CMPF122
	CP   R25,R23
	BRLO __CMPF121
	BRNE __CMPF122
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	BRLO __CMPF122
	BREQ __CMPF123
	RJMP __CMPF121

__ANEGD1:
	COM  R31
	COM  R22
	COM  R23
	NEG  R30
	SBCI R31,-1
	SBCI R22,-1
	SBCI R23,-1
	RET

__CBD1:
	MOV  R31,R30
	ADD  R31,R31
	SBC  R31,R31
	MOV  R22,R31
	MOV  R23,R31
	RET

__CWD1:
	MOV  R22,R31
	ADD  R22,R22
	SBC  R22,R22
	MOV  R23,R22
	RET

__EQD12:
	CP   R30,R26
	CPC  R31,R27
	CPC  R22,R24
	CPC  R23,R25
	LDI  R30,1
	BREQ __EQD12T
	CLR  R30
__EQD12T:
	RET

__PUTDP1:
	ST   X+,R30
	ST   X+,R31
	ST   X+,R22
	ST   X,R23
	RET

__GETD1S0:
	LD   R30,Y
	LDD  R31,Y+1
	LDD  R22,Y+2
	LDD  R23,Y+3
	RET

__PUTD1S0:
	ST   Y,R30
	STD  Y+1,R31
	STD  Y+2,R22
	STD  Y+3,R23
	RET

__PUTPARD1:
	ST   -Y,R23
	ST   -Y,R22
	ST   -Y,R31
	ST   -Y,R30
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

__CPD02:
	CLR  R0
	CP   R0,R26
	CPC  R0,R27
	CPC  R0,R24
	CPC  R0,R25
	RET

__SAVELOCR2:
	ST   -Y,R17
	ST   -Y,R16
	RET

__LOADLOCR2:
	LDD  R17,Y+1
	LD   R16,Y
	RET

;END OF CODE MARKER
__END_OF_CODE:
