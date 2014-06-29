
;CodeVisionAVR C Compiler V2.05.0 Professional
;(C) Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com

;Chip type                : ATmega162
;Program type             : Application
;Clock frequency          : 11,059200 MHz
;Memory model             : Small
;Optimize for             : Size
;(s)printf features       : int, width
;(s)scanf features        : int, width
;External RAM size        : 0
;Data Stack size          : 256 byte(s)
;Heap size                : 0 byte(s)
;Promote 'char' to 'int'  : Yes
;'char' is unsigned       : Yes
;8 bit enums              : Yes
;global 'const' stored in FLASH: No
;Enhanced core instructions    : On
;Smart register allocation     : On
;Automatic register allocation : On

	#pragma AVRPART ADMIN PART_NAME ATmega162
	#pragma AVRPART MEMORY PROG_FLASH 16384
	#pragma AVRPART MEMORY EEPROM 512
	#pragma AVRPART MEMORY INT_SRAM SIZE 1279
	#pragma AVRPART MEMORY INT_SRAM START_ADDR 0x100

	#define CALL_SUPPORTED 1

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
	.EQU MCUCSR=0x34
	.EQU MCUCR=0x35
	.EQU EMCUCR=0x36
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

	.EQU __SRAM_START=0x0100
	.EQU __SRAM_END=0x04FF
	.EQU __DSTACK_SIZE=0x0100
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
	CALL __EEPROMWRB
	.ENDM

	.MACRO __PUTW1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRW
	.ENDM

	.MACRO __PUTD1EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
	CALL __EEPROMWRD
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
	CALL __GETW1PF
	ICALL
	.ENDM

	.MACRO __CALL2EN
	LDI  R26,LOW(@0+(@1))
	LDI  R27,HIGH(@0+(@1))
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
	.DEF _rx_wr_index0=R5
	.DEF _rx_rd_index0=R4
	.DEF _rx_counter0=R7
	.DEF _tx_wr_index0=R6
	.DEF _tx_rd_index0=R9
	.DEF _tx_counter0=R8
	.DEF _rx_wr_index1=R11
	.DEF _rx_rd_index1=R10
	.DEF _rx_counter1=R13
	.DEF _tx_wr_index1=R12

	.CSEG
	.ORG 0x00

;START OF CODE MARKER
__START_OF_CODE:

;INTERRUPT VECTORS
	JMP  __RESET
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  0x00
	JMP  _usart0_rx_isr
	JMP  _usart1_rx_isr
	JMP  0x00
	JMP  0x00
	JMP  _usart0_tx_isr
	JMP  _usart1_tx_isr
	JMP  0x00
	JMP  0x00
	JMP  0x00

_tbl10_G101:
	.DB  0x10,0x27,0xE8,0x3,0x64,0x0,0xA,0x0
	.DB  0x1,0x0
_tbl16_G101:
	.DB  0x0,0x10,0x0,0x1,0x10,0x0,0x1,0x0

;REGISTER BIT VARIABLES INITIALIZATION
__REG_BIT_VARS:
	.DW  0x0000


__GLOBAL_INI_TBL:
	.DW  0x01
	.DW  0x02
	.DW  __REG_BIT_VARS*2

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
	OUT  EMCUCR,R30

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
	LDI  R26,LOW(__SRAM_START)
	LDI  R27,HIGH(__SRAM_START)
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

	JMP  _main

	.ESEG
	.ORG 0

	.DSEG
	.ORG 0x200

	.CSEG
;/*****************************************************
;This program was produced by the
;CodeWizardAVR V2.05.0 Professional
;Automatic Program Generator
;� Copyright 1998-2010 Pavel Haiduc, HP InfoTech s.r.l.
;http://www.hpinfotech.com
;
;Project : Master Program Radar Base
;Version : 1.3
;Date    : 29/06/2014
;Author  : deanzaka
;Company : Solusi247
;Comments:
;
;
;Chip type               : ATmega162
;Program type            : Application
;AVR Core Clock frequency: 11,059200 MHz
;Memory model            : Small
;External RAM size       : 0
;Data Stack size         : 256
;*****************************************************/
;
;#include <mega162.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.SET power_ctrl_reg=mcucr
	#endif
;#include <string.h>
;#include <delay.h>
;#include "motor.h"
;
;#ifndef RXB8
;#define RXB8 1
;#endif
;
;#ifndef TXB8
;#define TXB8 0
;#endif
;
;#ifndef UPE
;#define UPE 2
;#endif
;
;#ifndef DOR
;#define DOR 3
;#endif
;
;#ifndef FE
;#define FE 4
;#endif
;
;#ifndef UDRE
;#define UDRE 5
;#endif
;
;#ifndef RXC
;#define RXC 7
;#endif
;
;#define FRAMING_ERROR (1<<FE)
;#define PARITY_ERROR (1<<UPE)
;#define DATA_OVERRUN (1<<DOR)
;#define DATA_REGISTER_EMPTY (1<<UDRE)
;#define RX_COMPLETE (1<<RXC)
;
;// USART0 Receiver buffer
;#define RX_BUFFER_SIZE0 32
;char rx_buffer0[RX_BUFFER_SIZE0];
;
;#if RX_BUFFER_SIZE0 <= 256
;unsigned char rx_wr_index0,rx_rd_index0,rx_counter0;
;#else
;unsigned int rx_wr_index0,rx_rd_index0,rx_counter0;
;#endif
;
;// This flag is set on USART0 Receiver buffer overflow
;bit rx_buffer_overflow0;
;
;// USART0 Receiver interrupt service routine
;interrupt [USART0_RXC] void usart0_rx_isr(void)
; 0000 004E {

	.CSEG
_usart0_rx_isr:
	CALL SUBOPT_0x0
; 0000 004F char status,data;
; 0000 0050 status=UCSR0A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,11
; 0000 0051 data=UDR0;
	IN   R16,12
; 0000 0052 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x3
; 0000 0053    {
; 0000 0054    rx_buffer0[rx_wr_index0++]=data;
	MOV  R30,R5
	INC  R5
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	ST   Z,R16
; 0000 0055 #if RX_BUFFER_SIZE0 == 256
; 0000 0056    // special case for receiver buffer size=256
; 0000 0057    if (++rx_counter0 == 0)
; 0000 0058       {
; 0000 0059 #else
; 0000 005A    if (rx_wr_index0 == RX_BUFFER_SIZE0) rx_wr_index0=0;
	LDI  R30,LOW(32)
	CP   R30,R5
	BRNE _0x4
	CLR  R5
; 0000 005B    if (++rx_counter0 == RX_BUFFER_SIZE0)
_0x4:
	INC  R7
	LDI  R30,LOW(32)
	CP   R30,R7
	BRNE _0x5
; 0000 005C       {
; 0000 005D       rx_counter0=0;
	CLR  R7
; 0000 005E #endif
; 0000 005F       rx_buffer_overflow0=1;
	SET
	BLD  R2,0
; 0000 0060       }
; 0000 0061    }
_0x5:
; 0000 0062 }
_0x3:
	RJMP _0x2F
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Get a character from the USART0 Receiver buffer
;#define _ALTERNATE_GETCHAR_
;#pragma used+
;char getchar(void)
; 0000 0069 {
_getchar:
; 0000 006A char data;
; 0000 006B while (rx_counter0==0);
	ST   -Y,R17
;	data -> R17
_0x6:
	TST  R7
	BREQ _0x6
; 0000 006C data=rx_buffer0[rx_rd_index0++];
	MOV  R30,R4
	INC  R4
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer0)
	SBCI R31,HIGH(-_rx_buffer0)
	LD   R17,Z
; 0000 006D #if RX_BUFFER_SIZE0 != 256
; 0000 006E if (rx_rd_index0 == RX_BUFFER_SIZE0) rx_rd_index0=0;
	LDI  R30,LOW(32)
	CP   R30,R4
	BRNE _0x9
	CLR  R4
; 0000 006F #endif
; 0000 0070 #asm("cli")
_0x9:
	cli
; 0000 0071 --rx_counter0;
	DEC  R7
; 0000 0072 #asm("sei")
	sei
	RJMP _0x2060002
; 0000 0073 return data;
; 0000 0074 }
;#pragma used-
;#endif
;
;// USART0 Transmitter buffer
;#define TX_BUFFER_SIZE0 32
;char tx_buffer0[TX_BUFFER_SIZE0];
;
;#if TX_BUFFER_SIZE0 <= 256
;unsigned char tx_wr_index0,tx_rd_index0,tx_counter0;
;#else
;unsigned int tx_wr_index0,tx_rd_index0,tx_counter0;
;#endif
;
;// USART0 Transmitter interrupt service routine
;interrupt [USART0_TXC] void usart0_tx_isr(void)
; 0000 0084 {
_usart0_tx_isr:
	CALL SUBOPT_0x0
; 0000 0085 if (tx_counter0)
	TST  R8
	BREQ _0xA
; 0000 0086    {
; 0000 0087    --tx_counter0;
	DEC  R8
; 0000 0088    UDR0=tx_buffer0[tx_rd_index0++];
	MOV  R30,R9
	INC  R9
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R30,Z
	OUT  0xC,R30
; 0000 0089 #if TX_BUFFER_SIZE0 != 256
; 0000 008A    if (tx_rd_index0 == TX_BUFFER_SIZE0) tx_rd_index0=0;
	LDI  R30,LOW(32)
	CP   R30,R9
	BRNE _0xB
	CLR  R9
; 0000 008B #endif
; 0000 008C    }
_0xB:
; 0000 008D }
_0xA:
	RJMP _0x2E
;
;#ifndef _DEBUG_TERMINAL_IO_
;// Write a character to the USART0 Transmitter buffer
;#define _ALTERNATE_PUTCHAR_
;#pragma used+
;void putchar(char c)
; 0000 0094 {
_putchar:
; 0000 0095 while (tx_counter0 == TX_BUFFER_SIZE0);
;	c -> Y+0
_0xC:
	LDI  R30,LOW(32)
	CP   R30,R8
	BREQ _0xC
; 0000 0096 #asm("cli")
	cli
; 0000 0097 if (tx_counter0 || ((UCSR0A & DATA_REGISTER_EMPTY)==0))
	TST  R8
	BRNE _0x10
	SBIC 0xB,5
	RJMP _0xF
_0x10:
; 0000 0098    {
; 0000 0099    tx_buffer0[tx_wr_index0++]=c;
	MOV  R30,R6
	INC  R6
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer0)
	SBCI R31,HIGH(-_tx_buffer0)
	LD   R26,Y
	STD  Z+0,R26
; 0000 009A #if TX_BUFFER_SIZE0 != 256
; 0000 009B    if (tx_wr_index0 == TX_BUFFER_SIZE0) tx_wr_index0=0;
	LDI  R30,LOW(32)
	CP   R30,R6
	BRNE _0x12
	CLR  R6
; 0000 009C #endif
; 0000 009D    ++tx_counter0;
_0x12:
	INC  R8
; 0000 009E    }
; 0000 009F else
	RJMP _0x13
_0xF:
; 0000 00A0    UDR0=c;
	LD   R30,Y
	OUT  0xC,R30
; 0000 00A1 #asm("sei")
_0x13:
	sei
	RJMP _0x2060001
; 0000 00A2 }
;#pragma used-
;#endif
;
;// USART1 Receiver buffer
;#define RX_BUFFER_SIZE1 32
;char rx_buffer1[RX_BUFFER_SIZE1];
;
;#if RX_BUFFER_SIZE1 <= 256
;unsigned char rx_wr_index1,rx_rd_index1,rx_counter1;
;#else
;unsigned int rx_wr_index1,rx_rd_index1,rx_counter1;
;#endif
;
;// This flag is set on USART1 Receiver buffer overflow
;bit rx_buffer_overflow1;
;
;// USART1 Receiver interrupt service routine
;interrupt [USART1_RXC] void usart1_rx_isr(void)
; 0000 00B5 {
_usart1_rx_isr:
	CALL SUBOPT_0x0
; 0000 00B6 char status,data;
; 0000 00B7 status=UCSR1A;
	ST   -Y,R17
	ST   -Y,R16
;	status -> R17
;	data -> R16
	IN   R17,2
; 0000 00B8 data=UDR1;
	IN   R16,3
; 0000 00B9 if ((status & (FRAMING_ERROR | PARITY_ERROR | DATA_OVERRUN))==0)
	MOV  R30,R17
	ANDI R30,LOW(0x1C)
	BRNE _0x14
; 0000 00BA    {
; 0000 00BB    rx_buffer1[rx_wr_index1++]=data;
	MOV  R30,R11
	INC  R11
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	ST   Z,R16
; 0000 00BC #if RX_BUFFER_SIZE1 == 256
; 0000 00BD    // special case for receiver buffer size=256
; 0000 00BE    if (++rx_counter1 == 0)
; 0000 00BF       {
; 0000 00C0 #else
; 0000 00C1    if (rx_wr_index1 == RX_BUFFER_SIZE1) rx_wr_index1=0;
	LDI  R30,LOW(32)
	CP   R30,R11
	BRNE _0x15
	CLR  R11
; 0000 00C2    if (++rx_counter1 == RX_BUFFER_SIZE1)
_0x15:
	INC  R13
	LDI  R30,LOW(32)
	CP   R30,R13
	BRNE _0x16
; 0000 00C3       {
; 0000 00C4       rx_counter1=0;
	CLR  R13
; 0000 00C5 #endif
; 0000 00C6       rx_buffer_overflow1=1;
	SET
	BLD  R2,1
; 0000 00C7       }
; 0000 00C8    }
_0x16:
; 0000 00C9 }
_0x14:
_0x2F:
	LD   R16,Y+
	LD   R17,Y+
_0x2E:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	RETI
;
;// Get a character from the USART1 Receiver buffer
;#pragma used+
;char getchar1(void)
; 0000 00CE {
_getchar1:
; 0000 00CF char data;
; 0000 00D0 while (rx_counter1==0);
	ST   -Y,R17
;	data -> R17
_0x17:
	TST  R13
	BREQ _0x17
; 0000 00D1 data=rx_buffer1[rx_rd_index1++];
	MOV  R30,R10
	INC  R10
	LDI  R31,0
	SUBI R30,LOW(-_rx_buffer1)
	SBCI R31,HIGH(-_rx_buffer1)
	LD   R17,Z
; 0000 00D2 #if RX_BUFFER_SIZE1 != 256
; 0000 00D3 if (rx_rd_index1 == RX_BUFFER_SIZE1) rx_rd_index1=0;
	LDI  R30,LOW(32)
	CP   R30,R10
	BRNE _0x1A
	CLR  R10
; 0000 00D4 #endif
; 0000 00D5 #asm("cli")
_0x1A:
	cli
; 0000 00D6 --rx_counter1;
	DEC  R13
; 0000 00D7 #asm("sei")
	sei
_0x2060002:
; 0000 00D8 return data;
	MOV  R30,R17
	LD   R17,Y+
	RET
; 0000 00D9 }
;#pragma used-
;// USART1 Transmitter buffer
;#define TX_BUFFER_SIZE1 32
;char tx_buffer1[TX_BUFFER_SIZE1];
;
;#if TX_BUFFER_SIZE1 <= 256
;unsigned char tx_wr_index1,tx_rd_index1,tx_counter1;
;#else
;unsigned int tx_wr_index1,tx_rd_index1,tx_counter1;
;#endif
;
;// USART1 Transmitter interrupt service routine
;interrupt [USART1_TXC] void usart1_tx_isr(void)
; 0000 00E7 {
_usart1_tx_isr:
	ST   -Y,R26
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
; 0000 00E8 if (tx_counter1)
	LDS  R30,_tx_counter1
	CPI  R30,0
	BREQ _0x1B
; 0000 00E9    {
; 0000 00EA    --tx_counter1;
	SUBI R30,LOW(1)
	STS  _tx_counter1,R30
; 0000 00EB    UDR1=tx_buffer1[tx_rd_index1++];
	LDS  R30,_tx_rd_index1
	SUBI R30,-LOW(1)
	STS  _tx_rd_index1,R30
	SUBI R30,LOW(1)
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer1)
	SBCI R31,HIGH(-_tx_buffer1)
	LD   R30,Z
	OUT  0x3,R30
; 0000 00EC #if TX_BUFFER_SIZE1 != 256
; 0000 00ED    if (tx_rd_index1 == TX_BUFFER_SIZE1) tx_rd_index1=0;
	LDS  R26,_tx_rd_index1
	CPI  R26,LOW(0x20)
	BRNE _0x1C
	LDI  R30,LOW(0)
	STS  _tx_rd_index1,R30
; 0000 00EE #endif
; 0000 00EF    }
_0x1C:
; 0000 00F0 }
_0x1B:
	LD   R30,Y+
	OUT  SREG,R30
	LD   R31,Y+
	LD   R30,Y+
	LD   R26,Y+
	RETI
;
;// Write a character to the USART1 Transmitter buffer
;#pragma used+
;void putchar1(char c)
; 0000 00F5 {
_putchar1:
; 0000 00F6 while (tx_counter1 == TX_BUFFER_SIZE1);
;	c -> Y+0
_0x1D:
	LDS  R26,_tx_counter1
	CPI  R26,LOW(0x20)
	BREQ _0x1D
; 0000 00F7 #asm("cli")
	cli
; 0000 00F8 if (tx_counter1 || ((UCSR1A & DATA_REGISTER_EMPTY)==0))
	LDS  R30,_tx_counter1
	CPI  R30,0
	BRNE _0x21
	SBIC 0x2,5
	RJMP _0x20
_0x21:
; 0000 00F9    {
; 0000 00FA    tx_buffer1[tx_wr_index1++]=c;
	MOV  R30,R12
	INC  R12
	LDI  R31,0
	SUBI R30,LOW(-_tx_buffer1)
	SBCI R31,HIGH(-_tx_buffer1)
	LD   R26,Y
	STD  Z+0,R26
; 0000 00FB #if TX_BUFFER_SIZE1 != 256
; 0000 00FC    if (tx_wr_index1 == TX_BUFFER_SIZE1) tx_wr_index1=0;
	LDI  R30,LOW(32)
	CP   R30,R12
	BRNE _0x23
	CLR  R12
; 0000 00FD #endif
; 0000 00FE    ++tx_counter1;
_0x23:
	LDS  R30,_tx_counter1
	SUBI R30,-LOW(1)
	STS  _tx_counter1,R30
; 0000 00FF    }
; 0000 0100 else
	RJMP _0x24
_0x20:
; 0000 0101    UDR1=c;
	LD   R30,Y
	OUT  0x3,R30
; 0000 0102 #asm("sei")
_0x24:
	sei
_0x2060001:
; 0000 0103 }
	ADIW R28,1
	RET
;#pragma used-
;
;#pragma used+
;void printf1(char *st)
; 0000 0108 {
; 0000 0109     int i, c;
; 0000 010A     i = strlen(st);
;	*st -> Y+4
;	i -> R16,R17
;	c -> R18,R19
; 0000 010B 
; 0000 010C     for(c = 0; c < i; c++)
; 0000 010D     {
; 0000 010E         putchar1(st[c]);
; 0000 010F     }
; 0000 0110 }
;#pragma used-
;
;// Standard Input/Output functions
;#include <stdio.h>
;
;// Declare your global variables here
;
;void main(void)
; 0000 0119 {
_main:
; 0000 011A // Declare your local variables here
; 0000 011B 
; 0000 011C // Crystal Oscillator division factor: 1
; 0000 011D #pragma optsize-
; 0000 011E CLKPR=0x80;
	LDI  R30,LOW(128)
	STS  97,R30
; 0000 011F CLKPR=0x00;
	LDI  R30,LOW(0)
	STS  97,R30
; 0000 0120 #ifdef _OPTIMIZE_SIZE_
; 0000 0121 #pragma optsize+
; 0000 0122 #endif
; 0000 0123 
; 0000 0124 // Input/Output Ports initialization
; 0000 0125 // Port A initialization
; 0000 0126 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0127 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0128 PORTA=0x00;
	OUT  0x1B,R30
; 0000 0129 DDRA=0x00;
	OUT  0x1A,R30
; 0000 012A 
; 0000 012B // Port B initialization
; 0000 012C // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 012D // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 012E PORTB=0x00;
	OUT  0x18,R30
; 0000 012F DDRB=0x00;
	OUT  0x17,R30
; 0000 0130 
; 0000 0131 // Port C initialization
; 0000 0132 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0133 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 0134 PORTC=0x00;
	OUT  0x15,R30
; 0000 0135 DDRC=0x00;
	OUT  0x14,R30
; 0000 0136 
; 0000 0137 // Port D initialization
; 0000 0138 // Func7=In Func6=In Func5=In Func4=In Func3=In Func2=In Func1=In Func0=In
; 0000 0139 // State7=T State6=T State5=T State4=T State3=T State2=T State1=T State0=T
; 0000 013A PORTD=0x00;
	OUT  0x12,R30
; 0000 013B DDRD=0x00;
	OUT  0x11,R30
; 0000 013C 
; 0000 013D // Port E initialization
; 0000 013E // Func2=In Func1=In Func0=In
; 0000 013F // State2=T State1=T State0=T
; 0000 0140 PORTE=0x00;
	OUT  0x7,R30
; 0000 0141 DDRE=0x00;
	OUT  0x6,R30
; 0000 0142 
; 0000 0143 // Timer/Counter 0 initialization
; 0000 0144 // Clock source: System Clock
; 0000 0145 // Clock value: Timer 0 Stopped
; 0000 0146 // Mode: Normal top=0xFF
; 0000 0147 // OC0 output: Disconnected
; 0000 0148 TCCR0=0x00;
	OUT  0x33,R30
; 0000 0149 TCNT0=0x00;
	OUT  0x32,R30
; 0000 014A OCR0=0x00;
	OUT  0x31,R30
; 0000 014B 
; 0000 014C // Timer/Counter 1 initialization
; 0000 014D // Clock source: System Clock
; 0000 014E // Clock value: Timer1 Stopped
; 0000 014F // Mode: Normal top=0xFFFF
; 0000 0150 // OC1A output: Discon.
; 0000 0151 // OC1B output: Discon.
; 0000 0152 // Noise Canceler: Off
; 0000 0153 // Input Capture on Falling Edge
; 0000 0154 // Timer1 Overflow Interrupt: Off
; 0000 0155 // Input Capture Interrupt: Off
; 0000 0156 // Compare A Match Interrupt: Off
; 0000 0157 // Compare B Match Interrupt: Off
; 0000 0158 TCCR1A=0x00;
	OUT  0x2F,R30
; 0000 0159 TCCR1B=0x00;
	CALL SUBOPT_0x1
; 0000 015A TCNT1H=0x00;
; 0000 015B TCNT1L=0x00;
; 0000 015C ICR1H=0x00;
; 0000 015D ICR1L=0x00;
; 0000 015E OCR1AH=0x00;
; 0000 015F OCR1AL=0x00;
; 0000 0160 OCR1BH=0x00;
; 0000 0161 OCR1BL=0x00;
; 0000 0162 
; 0000 0163 // Timer/Counter 2 initialization
; 0000 0164 // Clock source: System Clock
; 0000 0165 // Clock value: Timer2 Stopped
; 0000 0166 // Mode: Normal top=0xFF
; 0000 0167 // OC2 output: Disconnected
; 0000 0168 ASSR=0x00;
	LDI  R30,LOW(0)
	OUT  0x26,R30
; 0000 0169 TCCR2=0x00;
	OUT  0x27,R30
; 0000 016A TCNT2=0x00;
	OUT  0x23,R30
; 0000 016B OCR2=0x00;
	OUT  0x22,R30
; 0000 016C 
; 0000 016D // Timer/Counter 3 initialization
; 0000 016E // Clock value: Timer3 Stopped
; 0000 016F // Mode: Normal top=0xFFFF
; 0000 0170 // OC3A output: Discon.
; 0000 0171 // OC3B output: Discon.
; 0000 0172 // Noise Canceler: Off
; 0000 0173 // Input Capture on Falling Edge
; 0000 0174 // Timer3 Overflow Interrupt: Off
; 0000 0175 // Input Capture Interrupt: Off
; 0000 0176 // Compare A Match Interrupt: Off
; 0000 0177 // Compare B Match Interrupt: Off
; 0000 0178 TCCR3A=0x00;
	STS  139,R30
; 0000 0179 TCCR3B=0x00;
	STS  138,R30
; 0000 017A TCNT3H=0x00;
	STS  137,R30
; 0000 017B TCNT3L=0x00;
	STS  136,R30
; 0000 017C ICR3H=0x00;
	STS  129,R30
; 0000 017D ICR3L=0x00;
	STS  128,R30
; 0000 017E OCR3AH=0x00;
	STS  135,R30
; 0000 017F OCR3AL=0x00;
	STS  134,R30
; 0000 0180 OCR3BH=0x00;
	STS  133,R30
; 0000 0181 OCR3BL=0x00;
	STS  132,R30
; 0000 0182 
; 0000 0183 // External Interrupt(s) initialization
; 0000 0184 // INT0: Off
; 0000 0185 // INT1: Off
; 0000 0186 // INT2: Off
; 0000 0187 // Interrupt on any change on pins PCINT0-7: Off
; 0000 0188 // Interrupt on any change on pins PCINT8-15: Off
; 0000 0189 MCUCR=0x00;
	OUT  0x35,R30
; 0000 018A EMCUCR=0x00;
	OUT  0x36,R30
; 0000 018B 
; 0000 018C // Timer(s)/Counter(s) Interrupt(s) initialization
; 0000 018D TIMSK=0x00;
	OUT  0x39,R30
; 0000 018E 
; 0000 018F ETIMSK=0x00;
	STS  125,R30
; 0000 0190 
; 0000 0191 // USART0 initialization
; 0000 0192 // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 0193 // USART0 Receiver: On
; 0000 0194 // USART0 Transmitter: On
; 0000 0195 // USART0 Mode: Asynchronous
; 0000 0196 // USART0 Baud Rate: 57600
; 0000 0197 UCSR0A=0x00;
	OUT  0xB,R30
; 0000 0198 UCSR0B=0xD8;
	LDI  R30,LOW(216)
	OUT  0xA,R30
; 0000 0199 UCSR0C=0x86;
	LDI  R30,LOW(134)
	OUT  0x20,R30
; 0000 019A UBRR0H=0x00;
	LDI  R30,LOW(0)
	OUT  0x20,R30
; 0000 019B UBRR0L=0x0B;
	LDI  R30,LOW(11)
	OUT  0x9,R30
; 0000 019C 
; 0000 019D // USART1 initialization
; 0000 019E // Communication Parameters: 8 Data, 1 Stop, No Parity
; 0000 019F // USART1 Receiver: On
; 0000 01A0 // USART1 Transmitter: On
; 0000 01A1 // USART1 Mode: Asynchronous
; 0000 01A2 // USART1 Baud Rate: 57600
; 0000 01A3 UCSR1A=0x00;
	LDI  R30,LOW(0)
	OUT  0x2,R30
; 0000 01A4 UCSR1B=0xD8;
	LDI  R30,LOW(216)
	OUT  0x1,R30
; 0000 01A5 UCSR1C=0x86;
	LDI  R30,LOW(134)
	OUT  0x3C,R30
; 0000 01A6 UBRR1H=0x00;
	LDI  R30,LOW(0)
	OUT  0x3C,R30
; 0000 01A7 UBRR1L=0x0B;
	LDI  R30,LOW(11)
	OUT  0x0,R30
; 0000 01A8 
; 0000 01A9 // Analog Comparator initialization
; 0000 01AA // Analog Comparator: Off
; 0000 01AB // Analog Comparator Input Capture by Timer/Counter 1: Off
; 0000 01AC ACSR=0x80;
	LDI  R30,LOW(128)
	OUT  0x8,R30
; 0000 01AD 
; 0000 01AE // SPI initialization
; 0000 01AF // SPI disabled
; 0000 01B0 SPCR=0x00;
	LDI  R30,LOW(0)
	OUT  0xD,R30
; 0000 01B1 
; 0000 01B2 // Global enable interrupts
; 0000 01B3 #asm("sei")
	sei
; 0000 01B4 
; 0000 01B5 motor_set();
	RCALL _motor_set
; 0000 01B6 while (1)
_0x28:
; 0000 01B7       {
; 0000 01B8       // Place your code here
; 0000 01B9       if(rx_counter0) putchar1(getchar());
	TST  R7
	BREQ _0x2B
	RCALL _getchar
	ST   -Y,R30
	RCALL _putchar1
; 0000 01BA       if(rx_counter1) putchar(getchar1());
_0x2B:
	TST  R13
	BREQ _0x2C
	RCALL _getchar1
	ST   -Y,R30
	RCALL _putchar
; 0000 01BB 
; 0000 01BC       motor(CW, 800);
_0x2C:
	LDI  R30,LOW(1)
	ST   -Y,R30
	LDI  R30,LOW(800)
	LDI  R31,HIGH(800)
	ST   -Y,R31
	ST   -Y,R30
	RCALL _motor
; 0000 01BD       }
	RJMP _0x28
; 0000 01BE }
_0x2D:
	NOP
	RJMP _0x2D
;#include <mega162.h>
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.SET power_ctrl_reg=mcucr
	#endif
;#include <delay.h>
;#include "motor.h"
;void motor_set()
; 0001 0005 {

	.CSEG
_motor_set:
; 0001 0006 
; 0001 0007 
; 0001 0008 PORTD.5 = 0;
	CBI  0x12,5
; 0001 0009 PORTD.6 = 0;
	CBI  0x12,6
; 0001 000A PORTD.7 = 0;
	CBI  0x12,7
; 0001 000B 
; 0001 000C 
; 0001 000D DDRD.5 = 1;
	SBI  0x11,5
; 0001 000E DDRD.6 = 1;
	SBI  0x11,6
; 0001 000F DDRD.7 = 1;
	SBI  0x11,7
; 0001 0010 
; 0001 0011 // Timer/Counter 1 initialization
; 0001 0012 // Clock source: System Clock
; 0001 0013 // Clock value: 11059,200 kHz
; 0001 0014 // Mode: Fast PWM top=0x03FF
; 0001 0015 // OC1A output: Non-Inv.
; 0001 0016 // OC1B output: Non-Inv.
; 0001 0017 // Noise Canceler: Off
; 0001 0018 // Input Capture on Falling Edge
; 0001 0019 // Timer1 Overflow Interrupt: Off
; 0001 001A // Input Capture Interrupt: Off
; 0001 001B // Compare A Match Interrupt: Off
; 0001 001C // Compare B Match Interrupt: Off
; 0001 001D TCCR1A=0xA3;
	LDI  R30,LOW(163)
	OUT  0x2F,R30
; 0001 001E TCCR1B=0x09;
	LDI  R30,LOW(9)
	CALL SUBOPT_0x1
; 0001 001F TCNT1H=0x00;
; 0001 0020 TCNT1L=0x00;
; 0001 0021 ICR1H=0x00;
; 0001 0022 ICR1L=0x00;
; 0001 0023 OCR1AH=0x00;
; 0001 0024 OCR1AL=0x00;
; 0001 0025 OCR1BH=0x00;
; 0001 0026 OCR1BL=0x00;
; 0001 0027 }
	RET
;
;void motor(unsigned char dir, unsigned int speed)
; 0001 002A {
_motor:
; 0001 002B 
; 0001 002C      if(dir == CW)
;	dir -> Y+2
;	speed -> Y+0
	LDD  R26,Y+2
	CPI  R26,LOW(0x1)
	BRNE _0x2000F
; 0001 002D      {
; 0001 002E           CS0_R=0;
	CBI  0x12,6
; 0001 002F           CS1_R=1;
	RJMP _0x2001F
; 0001 0030 
; 0001 0031      }
; 0001 0032      else if(dir == CCW)
_0x2000F:
	LDD  R26,Y+2
	CPI  R26,LOW(0x2)
	BRNE _0x20015
; 0001 0033      {
; 0001 0034           CS0_R=1;
	SBI  0x12,6
; 0001 0035           CS1_R=0;
	CBI  0x12,7
; 0001 0036      }
; 0001 0037      else
	RJMP _0x2001A
_0x20015:
; 0001 0038      {
; 0001 0039           CS0_R=1;
	SBI  0x12,6
; 0001 003A           CS1_R=1;
_0x2001F:
	SBI  0x12,7
; 0001 003B      }
_0x2001A:
; 0001 003C 
; 0001 003D      PWM_R = speed;
	LD   R30,Y
	LDD  R31,Y+1
	OUT  0x2A+1,R31
	OUT  0x2A,R30
; 0001 003E }
	ADIW R28,3
	RET
;

	.CSEG
	#ifndef __SLEEP_DEFINED__
	#define __SLEEP_DEFINED__
	.EQU __se_bit=0x20
	.SET power_ctrl_reg=mcucr
	#endif

	.CSEG

	.CSEG

	.DSEG
_rx_buffer0:
	.BYTE 0x20
_tx_buffer0:
	.BYTE 0x20
_rx_buffer1:
	.BYTE 0x20
_tx_buffer1:
	.BYTE 0x20
_tx_rd_index1:
	.BYTE 0x1
_tx_counter1:
	.BYTE 0x1

	.CSEG
;OPTIMIZER ADDED SUBROUTINE, CALLED 3 TIMES, CODE SIZE REDUCTION:1 WORDS
SUBOPT_0x0:
	ST   -Y,R30
	ST   -Y,R31
	IN   R30,SREG
	ST   -Y,R30
	RET

;OPTIMIZER ADDED SUBROUTINE, CALLED 2 TIMES, CODE SIZE REDUCTION:12 WORDS
SUBOPT_0x1:
	OUT  0x2E,R30
	LDI  R30,LOW(0)
	OUT  0x2D,R30
	OUT  0x2C,R30
	OUT  0x25,R30
	OUT  0x24,R30
	OUT  0x2B,R30
	OUT  0x2A,R30
	OUT  0x29,R30
	OUT  0x28,R30
	RET


	.CSEG
;END OF CODE MARKER
__END_OF_CODE:
