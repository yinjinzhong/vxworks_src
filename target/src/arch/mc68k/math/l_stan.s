/* l_stan.s - Motorola 68040 FP tangent routines (LIB) */

/* Copyright 1991-1993 Wind River Systems, Inc. */
	.data
	.globl	_copyright_wind_river
	.long	_copyright_wind_river

/*
modification history
--------------------
01f,21jul93,kdl  added .text (SPR #2372).
01e,23aug92,jcf  changed bxxx to jxx.
01d,26may92,rrr  the tree shuffle
01c,10jan92,kdl  general cleanup.
01b,17dec91,kdl	 put in changes from Motorola v3.3 (from FPSP 2.1):
		 reduce argument by one step before general reduction
		 loop.
01a,15aug91,kdl  original version, from Motorola FPSP v2.0.
*/

/*
DESCRIPTION

	stansa 3.2 12/18/90

	The entry point __l_stan computes the tangent of
	an input argument;
	__l_stand does the same except for denormalized input.

	Input: Double-extended number X in location pointed to
		by address register a0.

	Output: The value tan(X) returned in floating-point register Fp0.

	Accuracy and Monotonicity: The returned result is within 3 ulp in
		64 significant bit, i.e. within 0.5001 ulp to 53 bits if the
		result is subsequently rounded to double precision. The
		result is provably monotonic in double precision.

	Speed: The program sTAN takes approximately 170 cycles for
		input argument X such that |X| < 15Pi, which is the the usual
		situation.

	Algorithm:

	1. If |X| >= 15Pi or |X| < 2**(-40), go to 6.

	2. Decompose X as X = N(Pi/2) + r where |r| <= Pi/4. Let
		k = N mod 2, so in particular, k = 0 or 1.

	3. If k is odd, go to 5.

	4. (k is even) Tan(X) = tan(r) and tan(r) is approximated by a
		rational function U/V where
		U = r + r*s*(P1 + s*(P2 + s*P3)), and
		V = 1 + s*(Q1 + s*(Q2 + s*(Q3 + s*Q4))),  s = r*r.
		Exit.

	5. (k is odd) Tan(X) = -cot(r). Since tan(r) is approximated by a
		rational function U/V where
		U = r + r*s*(P1 + s*(P2 + s*P3)), and
		V = 1 + s*(Q1 + s*(Q2 + s*(Q3 + s*Q4))), s = r*r,
		-Cot(r) = -V/U. Exit.

	6. If |X| > 1, go to 8.

	7. (|X|<2**(-40)) Tan(X) = X. Exit.

	8. Overwrite X by X := X rem 2Pi. Now that |X| <= Pi, go back to 2.


		Copyright (C) Motorola, Inc. 1990
			All Rights Reserved

	THIS IS UNPUBLISHED PROPRIETARY SOURCE CODE OF MOTOROLA
	The copyright notice above does not evidence any
	actual or intended publication of such source code.

STAN	idnt	2,1 Motorola 040 Floating Point Software Package

	section	8

NOMANUAL
*/

#include "fpsp040L.h"

BOUNDS1:	.long 0x3FD78000,0x4004BC7E
TWOBYPI:	.long 0x3FE45F30,0x6DC9C883

TANQ4:	.long 0x3EA0B759,0xF50F8688
TANP3:	.long 0xBEF2BAA5,0xA8924F04

TANQ3:	.long 0xBF346F59,0xB39BA65F,0x00000000,0x00000000

TANP2:	.long 0x3FF60000,0xE073D3FC,0x199C4A00,0x00000000

TANQ2:	.long 0x3FF90000,0xD23CD684,0x15D95FA1,0x00000000

TANP1:	.long 0xBFFC0000,0x8895A6C5,0xFB423BCA,0x00000000

TANQ1:	.long 0xBFFD0000,0xEEF57E0D,0xA84BC8CE,0x00000000

INVTWOPI: .long 0x3FFC0000,0xA2F9836E,0x4E44152A,0x00000000

TWOPI1:	.long 0x40010000,0xC90FDAA2,0x00000000,0x00000000
TWOPI2:	.long 0x3FDF0000,0x85A308D4,0x00000000,0x00000000

|--N*PI/2, -32 <= N <= 32, IN A LEADING TERM IN EXT. AND TRAILING
|--TERM IN SGL. NOTE THAT PI IS 64-BIT LONG, THUS N*PI/2 IS AT
|--MOST 69 BITS LONG.
	.globl	__l_PITBL
__l_PITBL:
  .long  0xC0040000,0xC90FDAA2,0x2168C235,0x21800000
  .long  0xC0040000,0xC2C75BCD,0x105D7C23,0xA0D00000
  .long  0xC0040000,0xBC7EDCF7,0xFF523611,0xA1E80000
  .long  0xC0040000,0xB6365E22,0xEE46F000,0x21480000
  .long  0xC0040000,0xAFEDDF4D,0xDD3BA9EE,0xA1200000
  .long  0xC0040000,0xA9A56078,0xCC3063DD,0x21FC0000
  .long  0xC0040000,0xA35CE1A3,0xBB251DCB,0x21100000
  .long  0xC0040000,0x9D1462CE,0xAA19D7B9,0xA1580000
  .long  0xC0040000,0x96CBE3F9,0x990E91A8,0x21E00000
  .long  0xC0040000,0x90836524,0x88034B96,0x20B00000
  .long  0xC0040000,0x8A3AE64F,0x76F80584,0xA1880000
  .long  0xC0040000,0x83F2677A,0x65ECBF73,0x21C40000
  .long  0xC0030000,0xFB53D14A,0xA9C2F2C2,0x20000000
  .long  0xC0030000,0xEEC2D3A0,0x87AC669F,0x21380000
  .long  0xC0030000,0xE231D5F6,0x6595DA7B,0xA1300000
  .long  0xC0030000,0xD5A0D84C,0x437F4E58,0x9FC00000
  .long  0xC0030000,0xC90FDAA2,0x2168C235,0x21000000
  .long  0xC0030000,0xBC7EDCF7,0xFF523611,0xA1680000
  .long  0xC0030000,0xAFEDDF4D,0xDD3BA9EE,0xA0A00000
  .long  0xC0030000,0xA35CE1A3,0xBB251DCB,0x20900000
  .long  0xC0030000,0x96CBE3F9,0x990E91A8,0x21600000
  .long  0xC0030000,0x8A3AE64F,0x76F80584,0xA1080000
  .long  0xC0020000,0xFB53D14A,0xA9C2F2C2,0x1F800000
  .long  0xC0020000,0xE231D5F6,0x6595DA7B,0xA0B00000
  .long  0xC0020000,0xC90FDAA2,0x2168C235,0x20800000
  .long  0xC0020000,0xAFEDDF4D,0xDD3BA9EE,0xA0200000
  .long  0xC0020000,0x96CBE3F9,0x990E91A8,0x20E00000
  .long  0xC0010000,0xFB53D14A,0xA9C2F2C2,0x1F000000
  .long  0xC0010000,0xC90FDAA2,0x2168C235,0x20000000
  .long  0xC0010000,0x96CBE3F9,0x990E91A8,0x20600000
  .long  0xC0000000,0xC90FDAA2,0x2168C235,0x1F800000
  .long  0xBFFF0000,0xC90FDAA2,0x2168C235,0x1F000000
  .long  0x00000000,0x00000000,0x00000000,0x00000000
  .long  0x3FFF0000,0xC90FDAA2,0x2168C235,0x9F000000
  .long  0x40000000,0xC90FDAA2,0x2168C235,0x9F800000
  .long  0x40010000,0x96CBE3F9,0x990E91A8,0xA0600000
  .long  0x40010000,0xC90FDAA2,0x2168C235,0xA0000000
  .long  0x40010000,0xFB53D14A,0xA9C2F2C2,0x9F000000
  .long  0x40020000,0x96CBE3F9,0x990E91A8,0xA0E00000
  .long  0x40020000,0xAFEDDF4D,0xDD3BA9EE,0x20200000
  .long  0x40020000,0xC90FDAA2,0x2168C235,0xA0800000
  .long  0x40020000,0xE231D5F6,0x6595DA7B,0x20B00000
  .long  0x40020000,0xFB53D14A,0xA9C2F2C2,0x9F800000
  .long  0x40030000,0x8A3AE64F,0x76F80584,0x21080000
  .long  0x40030000,0x96CBE3F9,0x990E91A8,0xA1600000
  .long  0x40030000,0xA35CE1A3,0xBB251DCB,0xA0900000
  .long  0x40030000,0xAFEDDF4D,0xDD3BA9EE,0x20A00000
  .long  0x40030000,0xBC7EDCF7,0xFF523611,0x21680000
  .long  0x40030000,0xC90FDAA2,0x2168C235,0xA1000000
  .long  0x40030000,0xD5A0D84C,0x437F4E58,0x1FC00000
  .long  0x40030000,0xE231D5F6,0x6595DA7B,0x21300000
  .long  0x40030000,0xEEC2D3A0,0x87AC669F,0xA1380000
  .long  0x40030000,0xFB53D14A,0xA9C2F2C2,0xA0000000
  .long  0x40040000,0x83F2677A,0x65ECBF73,0xA1C40000
  .long  0x40040000,0x8A3AE64F,0x76F80584,0x21880000
  .long  0x40040000,0x90836524,0x88034B96,0xA0B00000
  .long  0x40040000,0x96CBE3F9,0x990E91A8,0xA1E00000
  .long  0x40040000,0x9D1462CE,0xAA19D7B9,0x21580000
  .long  0x40040000,0xA35CE1A3,0xBB251DCB,0xA1100000
  .long  0x40040000,0xA9A56078,0xCC3063DD,0xA1FC0000
  .long  0x40040000,0xAFEDDF4D,0xDD3BA9EE,0x21200000
  .long  0x40040000,0xB6365E22,0xEE46F000,0xA1480000
  .long  0x40040000,0xBC7EDCF7,0xFF523611,0x21E80000
  .long  0x40040000,0xC2C75BCD,0x105D7C23,0x20D00000
  .long  0x40040000,0xC90FDAA2,0x2168C235,0xA1800000

#define	INARG		FP_SCR4

#define	TWOTO63      L_SCR1
#define	ENDFLAG		L_SCR2
#define	N            L_SCR3

|	xref	__l_t_frcinx
|	xref	__l_t_extdnrm


	.text

	.globl	__l_stand
__l_stand:
|--TAN(X) = X FOR DENORMALIZED X

	jra 		__l_t_extdnrm

	.globl	__l_stan
__l_stan:
	fmovex		a0@,fp0			|...lOAD INPUT

	movel		A0@,d0
	movew		A0@(4),d0
	andil		#0x7FFFFFFF,d0

	cmpil		#0x3FD78000,d0		|...|X| >= 2**(-40)?
	jge 		TANOK1
	jra 		TANSM
TANOK1:
	cmpil		#0x4004BC7E,d0		|...|X| < 15 PI?
	jlt 		TANMAIN
	jra 		REDUCEX


TANMAIN:
|--THIS IS THE USUAL CASE, |X| <= 15 PI.
|--THE ARGUMENT REDUCTION IS DONE BY TABLE LOOK UP.
	fmovex		fp0,fp1
	fmuld		TWOBYPI,fp1	|...X*2/PI

|--HIDE THE NEXT TWO INSTRUCTIONS
	lea		__l_PITBL+0x200,a1 |...TABLE OF N*PI/2, N = -32,...,32

|--FP1 IS NOW READY
	fmovel		fp1,d0		|...CONVERT TO INTEGER

	asll		#4,d0
	addal		d0,a1		|...ADDRESS N*PIBY2 IN Y1, Y2

	fsubx		a1@+,fp0	|...X-Y1
|--HIDE THE NEXT ONE

	fsubs		a1@,fp0		|...FP0 IS R = (X-Y1)-Y2

	rorl		#5,d0
	andil		#0x80000000,d0	|...D0 WAS ODD IFF d0 < 0

TANCONT:

	cmpil		#0,d0
	jlt 		NODD

	fmovex		fp0,fp1
	fmulx		fp1,fp1	 	|...S = R*R

	fmoved		TANQ4,fp3
	fmoved		TANP3,fp2

	fmulx		fp1,fp3	 	|...SQ4
	fmulx		fp1,fp2	 	|...SP3

	faddd		TANQ3,fp3	|...Q3+SQ4
	faddx		TANP2,fp2	|...P2+SP3

	fmulx		fp1,fp3	 	|...S(Q3+SQ4)
	fmulx		fp1,fp2	 	|...S(P2+SP3)

	faddx		TANQ2,fp3	|...Q2+S(Q3+SQ4)
	faddx		TANP1,fp2	|...P1+S(P2+SP3)

	fmulx		fp1,fp3	 	|...S(Q2+S(Q3+SQ4))
	fmulx		fp1,fp2	 	|...S(P1+S(P2+SP3))

	faddx		TANQ1,fp3	|...Q1+S(Q2+S(Q3+SQ4))
	fmulx		fp0,fp2	 	|...RS(P1+S(P2+SP3))

	fmulx		fp3,fp1	 	|...S(Q1+S(Q2+S(Q3+SQ4)))


	faddx		fp2,fp0	 	|...R+RS(P1+S(P2+SP3))


	.long 0xf23c44a2,0x3f800000	/*	fadds	&0x3F800000,fp1 */

	fmovel		d1,fpcr		| restore users exceptions
	fdivx		fp1,fp0		| last inst - possible exception set

	jra 		__l_t_frcinx

NODD:
	fmovex		fp0,fp1
	fmulx		fp0,fp0	 	|...S = R*R

	fmoved		TANQ4,fp3
	fmoved		TANP3,fp2

	fmulx		fp0,fp3	 	|...SQ4
	fmulx		fp0,fp2	 	|...SP3

	faddd		TANQ3,fp3	|...Q3+SQ4
	faddx		TANP2,fp2	|...P2+SP3

	fmulx		fp0,fp3	 	|...S(Q3+SQ4)
	fmulx		fp0,fp2	 	|...S(P2+SP3)

	faddx		TANQ2,fp3	|...Q2+S(Q3+SQ4)
	faddx		TANP1,fp2	|...P1+S(P2+SP3)

	fmulx		fp0,fp3	 	|...S(Q2+S(Q3+SQ4))
	fmulx		fp0,fp2	 	|...S(P1+S(P2+SP3))

	faddx		TANQ1,fp3	|...Q1+S(Q2+S(Q3+SQ4))
	fmulx		fp1,fp2	 	|...RS(P1+S(P2+SP3))

	fmulx		fp3,fp0	 	|...S(Q1+S(Q2+S(Q3+SQ4)))


	faddx		fp2,fp1	 	|...R+RS(P1+S(P2+SP3))
	.long 0xf23c4422,0x3f800000	/* fadds  &0x3F800000,fp0 */


	fmovex		fp1,a7@-
	eoril		#0x80000000,a7@

	fmovel		d1,fpcr	 	| restore users exceptions
	fdivx		a7@+,fp0	| last inst - possible exception set

	jra 		__l_t_frcinx

TANBORS:
|--IF |X| > 15PI, WE USE THE GENERAL ARGUMENT REDUCTION.
|--IF |X| < 2**(-40), RETURN X OR 1.
	cmpil		#0x3FFF8000,d0
	jgt 		REDUCEX

TANSM:

	fmovex		fp0,a7@-
	fmovel		d1,fpcr		 | restore users exceptions
	fmovex		a7@+,fp0	| last inst - posibble exception set

	jra 		__l_t_frcinx


REDUCEX:
|--WHEN REDUCEX IS USED, THE CODE WILL INEVITABLY BE SLOW.
|--THIS REDUCTION METHOD, HOWEVER, IS MUCH FASTER THAN USING
|--THE REMAINDER INSTRUCTION WHICH IS NOW IN SOFTWARE.

	fmovemx	fp2-fp5,A7@-		|...save fp2 through fp5
	movel		d2,A7@-
	.long 0xf23c4480,0x00000000	/* fmoves  &0x00000000,fp1 */

|--If compact form of abs(arg) in d0=0x7ffeffff, argument is so large that
|--there is a danger of unwanted overflow in first LOOP iteration.  In this
|--case, reduce argument by one remainder step to make subsequent reduction
|--safe.
	cmpil	#0x7ffeffff,d0			| is argument dangerously large?
	jne 	LOOP
	movel	#0x7ffe0000,a6@(FP_SCR2)	| yes
|						| create 2**16383*PI/2
	movel	#0xc90fdaa2,a6@(FP_SCR2+4)
	clrl	a6@(FP_SCR2+8)
	ftstx	fp0				| test sign of argument
	movel	#0x7fdc0000,a6@(FP_SCR3)	| create low half of 2**16383*
|						| PI/2 at FP_SCR3
	movel	#0x85a308d3,a6@(FP_SCR3+4)
	clrl  	a6@(FP_SCR3+8)
	fblt	red_neg
	orw	#0x8000,a6@(FP_SCR2)		| positive arg
	orw	#0x8000,a6@(FP_SCR3)
red_neg:
	faddx 	a6@(FP_SCR2),fp0	| high part of reduction is exact
	fmovex  fp0,fp1			| save high result in fp1
	faddx 	a6@(FP_SCR3),fp0	| low part of reduction
	fsubx   fp0,fp1			| determine low component of result
	faddx 	a6@(FP_SCR3),fp1	| fp0/fp1 are reduced argument.

|--ON ENTRY, FP0 IS X, ON RETURN, FP0 IS X REM PI/2, |X| <= PI/4.
|--integer quotient will be stored in N
|--Intermeditate remainder is 66-bit long|  (R,r) in (FP0,FP1)

LOOP:
	fmovex		fp0,a6@(INARG)	|...+-2**K * F, 1 <= F < 2
	movew		a6@(INARG),d0
        movel          d0,a1		|...save a copy of d0
	andil		#0x00007FFF,d0
	subil		#0x00003FFF,d0	|...D0 IS K
	cmpil		#28,d0
	jle 		LASTLOOP
CONTLOOP:
	subil		#27,d0	 	|...D0 IS L := K-27
	movel		#0,a6@(ENDFLAG)
	jra 		WORK
LASTLOOP:
	clrl		d0		|...D0 IS L := 0
	movel		#1,a6@(ENDFLAG)

WORK:
|--FIND THE REMAINDER OF (R,r) W.R.T.	2**L * (PI/2). L IS SO CHOSEN
|--THAT	INT( X * (2/PI) / 2**(L) ) < 2**29.

|--CREATE 2**(-L) * (2/PI), SIGN(INARG)*2**(63),
|--2**L * (PIby2_1), 2**L * (PIby2_2)

	movel		#0x00003FFE,d2	|...BIASED EXPO OF 2/PI
	subl		d0,d2		|...BIASED EXPO OF 2**(-L)*(2/PI)

	movel		#0xA2F9836E,a6@(FP_SCR1+4)
	movel		#0x4E44152A,a6@(FP_SCR1+8)
	movew		d2,a6@(FP_SCR1)	|...FP_SCR1 is 2**(-L)*(2/PI)

	fmovex		fp0,fp2
	fmulx		a6@(FP_SCR1),fp2
|--WE MUST NOW FIND INT(FP2). SINCE WE NEED THIS VALUE IN
/* |--FLOATING POINT FORMAT, THE TWO FMOVE'S	FMOVE.l FP <--> N */
|--WILL BE TOO INEFFICIENT. THE WAY AROUND IT IS THAT
|--(SIGN(INARG)*2**63	+	FP2) - SIGN(INARG)*2**63 WILL GIVE
|--US THE DESIRED VALUE IN FLOATING POINT.

|--HIDE SIX CYCLES OF INSTRUCTION
        movel		a1,d2
        swap		d2
	andil		#0x80000000,d2
	oril		#0x5F000000,d2	|...D2 IS SIGN(INARG)*2**63 IN SGL
	movel		d2,a6@(TWOTO63)

	movel		d0,d2
	addil		#0x00003FFF,d2	|...BIASED EXPO OF 2**L * (PI/2)

|--FP2 IS READY
	fadds		a6@(TWOTO63),fp2	|...THE FRACTIONAL PART OF fp1 IS ROUNDED

|--HIDE 4 CYCLES OF INSTRUCTION|  creating 2**(L)*Piby2_1  and  2**(L)*Piby2_2
        movew		d2,a6@(FP_SCR2)
	clrw          	a6@(FP_SCR2+2)
	movel		#0xC90FDAA2,a6@(FP_SCR2+4)
	clrl		a6@(FP_SCR2+8)		|...FP_SCR2 is  2**(L) * Piby2_1

|--FP2 IS READY
	fsubs		a6@(TWOTO63),fp2		|...FP2 is N

	addil		#0x00003FDD,d0
        movew		d0,a6@(FP_SCR3)
	clrw          	a6@(FP_SCR3+2)
	movel		#0x85A308D3,a6@(FP_SCR3+4)
	clrl		a6@(FP_SCR3+8)		|...FP_SCR3 is 2**(L) * Piby2_2

	movel		a6@(ENDFLAG),d0

|--We are now ready to perform (R+r) - N*P1 - N*P2, P1 = 2**(L) * Piby2_1 and
|--P2 = 2**(L) * Piby2_2
	fmovex		fp2,fp4
	fmulx		a6@(FP_SCR2),fp4		|...w = N*P1
	fmovex		fp2,fp5
	fmulx		a6@(FP_SCR3),fp5	|...w = N*P2
	fmovex		fp4,fp3
|--we want P+p = W+w  but  |p| <= half ulp of P
|--Then, we need to compute  A := R-P   and  a := r-p
	faddx		fp5,fp3			|...FP3 is P
	fsubx		fp3,fp4			|...w-P

	fsubx		fp3,fp0			|...FP0 is A := R - P
        faddx		fp5,fp4			|...FP4 is p = (W-P)+w

	fmovex		fp0,fp3			|...FP3 A
	fsubx		fp4,fp1			|...FP1 is a := r - p

|--Now we need to normalize (A,a) to  "new (R,r)" where R+r = A+a but
|--|r| <= half ulp of R.
	faddx		fp1,fp0			|...FP0 is R := A+a
|--No need to calculate r if this is the last loop
	cmpil		#0,d0
	jgt 		RESTORE

|--Need to calculate r
	fsubx		fp0,fp3			|...A-R
	faddx		fp3,fp1			|...FP1 is r := (A-R)+a
	jra 		LOOP

RESTORE:
        fmovel		fp2,a6@(N)
	movel		A7@+,d2
	fmovemx	A7@+,fp2-fp5


	movel		a6@(N),d0
        rorl		#1,d0


	jra 		TANCONT

|	end
