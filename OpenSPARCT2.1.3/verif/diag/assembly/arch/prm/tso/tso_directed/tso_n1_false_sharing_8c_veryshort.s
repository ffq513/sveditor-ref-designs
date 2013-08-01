/*
* ========== Copyright Header Begin ==========================================
* 
* OpenSPARC T2 Processor File: tso_n1_false_sharing_8c_veryshort.s
* Copyright (C) 1995-2007 Sun Microsystems, Inc. All Rights Reserved
* 4150 Network Circle, Santa Clara, California 95054, U.S.A.
*
* DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER. 
*
* This program is free software; you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation; version 2 of the License.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program; if not, write to the Free Software
* Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
*
* For the avoidance of doubt, and except that if any non-GPL license 
* choice is available it will apply instead, Sun elects to use only 
* the General Public License version 2 (GPLv2) at this time for any 
* software where a choice of GPL license versions is made 
* available with the language indicating that GPLv2 or any later version 
* may be used, or where a choice of which version of the GPL is applied is 
* otherwise unspecified. 
*
* Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara, 
* CA 95054 USA or visit www.sun.com if you need additional information or 
* have any questions. 
*
* 
* ========== Copyright Header End ============================================
*/
#define data_base_reg	  		%o1
#define to_reg	  			%o2
#define my_id_reg	  		%o3
#define test_reg	  		%o4
#define global_cnt_reg	  		%o5

#define TIMEOUT 	  		0x1000
#define ITERATIONS 	  		0x1

#include "hboot.s"

.global main

main:
        set     ITERATIONS,	global_cnt_reg
	mov	%g0, my_id_reg

th_fork(th_main,%l0)

th_main_0:
        add     my_id_reg, 0x00, my_id_reg	! this is my ID address
	ba	go; nop
th_main_1:
        add     my_id_reg, 0x04, my_id_reg
	ba	go; nop
th_main_2:
        add     my_id_reg, 0x08, my_id_reg
	ba	go; nop
th_main_3:
        add     my_id_reg, 0x0c, my_id_reg
	ba	go; nop
th_main_4:
        add     my_id_reg, 0x10, my_id_reg
	ba	go; nop
th_main_5:
        add     my_id_reg, 0x14, my_id_reg
	ba	go; nop
th_main_6:
        add     my_id_reg, 0x18, my_id_reg
	ba	go; nop
th_main_7:
        add     my_id_reg, 0x1c, my_id_reg
	ba	go; nop
th_main_8:
        add     my_id_reg, 0x20, my_id_reg
	ba	go; nop
th_main_9:
        add     my_id_reg, 0x24, my_id_reg
	ba	go; nop
th_main_10:
        add     my_id_reg, 0x28, my_id_reg
	ba	go; nop
th_main_11:
        add     my_id_reg, 0x2c, my_id_reg
	ba	go; nop
th_main_12:
        add     my_id_reg, 0x30, my_id_reg
	ba	go; nop
th_main_13:
        add     my_id_reg, 0x34, my_id_reg
	ba	go; nop
th_main_14:
        add     my_id_reg, 0x38, my_id_reg
	ba	go; nop
th_main_15:
        add     my_id_reg, 0x3c, my_id_reg
	ba	go; nop
th_main_16:
        add     my_id_reg, 0x40, my_id_reg
	ba	go; nop
th_main_17:
        add     my_id_reg, 0x44, my_id_reg
	ba	go; nop
th_main_18:
        add     my_id_reg, 0x48, my_id_reg
	ba	go; nop
th_main_19:
        add     my_id_reg, 0x4c, my_id_reg
	ba	go; nop
th_main_20:
        add     my_id_reg, 0x50, my_id_reg
	ba	go; nop
th_main_21:
        add     my_id_reg, 0x54, my_id_reg
	ba	go; nop
th_main_22:
        add     my_id_reg, 0x58, my_id_reg
	ba	go; nop
th_main_23:
        add     my_id_reg, 0x5c, my_id_reg
	ba	go; nop
th_main_24:
        add     my_id_reg, 0x60, my_id_reg
	ba	go; nop
th_main_25:
        add     my_id_reg, 0x64, my_id_reg
	ba	go; nop
th_main_26:
        add     my_id_reg, 0x68, my_id_reg
	ba	go; nop
th_main_27:
        add     my_id_reg, 0x6c, my_id_reg
	ba	go; nop
th_main_28:
        add     my_id_reg, 0x70, my_id_reg
	ba	go; nop
th_main_29:
        add     my_id_reg, 0x74, my_id_reg
	ba	go; nop
th_main_30:
        add     my_id_reg, 0x78, my_id_reg
	ba	go; nop
th_main_31:
        add     my_id_reg, 0x7c, my_id_reg
	ba	go; nop

go:
	setx    protected_area,	%l0, data_base_reg	! the data area

	set 	4, %l0					! count
	add	my_id_reg, data_base_reg, data_base_reg
	add	my_id_reg, data_base_reg, %i1
loop1:
	st 	%i1, [data_base_reg]  			! store my ID in there
	inc	%i1
	deccc	%l0
	bne 	loop1					! repeat
	nop

	dec	%i1
	ld 	[data_base_reg], %l1			! read the data area
	subcc 	%l1, %i1, %l1				! should be same as i1
	bne	bad_end
	nop

check_done:
	deccc	global_cnt_reg
        be	good_end
	nop
	ba	go
	nop

good_end:
        ta      T_GOOD_TRAP
bad_end:
        ta      T_BAD_TRAP

!==========================

	.data
.global protected_area
protected_area:
	.word	0xbeef
	.skip 0x1000
	.word	0xbeef
	
.end
