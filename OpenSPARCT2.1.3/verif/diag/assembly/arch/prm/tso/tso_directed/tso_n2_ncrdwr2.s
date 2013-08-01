/*
* ========== Copyright Header Begin ==========================================
* 
* OpenSPARC T2 Processor File: tso_n2_ncrdwr2.s
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
#define MAIN_PAGE_HV_ALSO
#define PART0_NZ_RANOTPA_2 0
#define ENABLE_PCIE_LINK_TRAINING    

#define H_HT0_DAE_invalid_asi_0x14
#define SUN_H_HT0_DAE_invalid_asi_0x14 \
        inc     %l5;\
        done; nop

#define H_HT0_DAE_nc_page_0x16
#define SUN_H_HT0_DAE_nc_page_0x16 \
        inc     %l4;\
        done; nop
	
#define H_HT0_Data_Real_Tran_Miss_0x3f
#define SUN_H_HT0_Data_Real_Tran_Miss_0x3f \
        inc     %l3;\
        done; nop
	
#include "hboot.s"

.text
.global main
main:
  ta T_CHANGE_HPRIV
  nop
	
  wr      %g0, 0x4, %fprs         /* make sure fef is 1 */
  
/************************************
  set up pointers
*************************************/
setx 0xc100beef00, %g1, %g3          ! MEM32 address space

/************************************ 
   Start doing non cacheable access 
   RW's are done to the DMUPIO space 
   starting from 0xC1
*************************************/
   mov %g0, %g4
   set 0x1, %g2
   set 0x10, %g5

   stloop1:
      stx %g2, [%g3 + %g4]
      inc %g2
      add 0x8, %g4, %g4
      deccc %g5
   bne stloop1
   nop

   mov 0x78, %g4
   set 0x10, %g2
   set 0x10, %g5

   ldloop1:
      ldx [%g3 + %g4], %g1
      subcc   %g2, %g1, %g0
      bne     h_bad_end
      nop
      dec %g2
      sub %g4, 0x8, %g4
      deccc %g5
   bne ldloop1
   nop
!================================

   mov 0, %l3			!! initialize the interrupt counter
   mov 0, %l4			!! initialize the interrupt counter
   mov 0, %l5			!! initialize the interrupt counter

   setx user_data_start, %g1, %g2
   ldd	[%g2], %f0		!! set up f regs in case data gets stored
   ldd	[%g2+8], %f2
   ldd	[%g2+16], %f4
   ldd	[%g2+24], %f6
   ldd	[%g2+32], %f8 
   ldd	[%g2+40], %f10 
   ldd	[%g2+48], %f12 
   ldd	[%g2+56], %f14 
   ldd	[%g2+64], %f16 

!!! These are mentioned in PRM 9.1.2
!!! it says that block loads and stores
!!! should get a DAE_invalid_asi exception
	
   mov  %g3, %g4

!================================
   stda %f0, [%g3]ASI_BLK_P	!! asi 0xf0
   ldda [%g3]ASI_BLK_P, %f0	!! should take an exception
   ldx  [%g4 +  0], %o0		!! check that the stda stored data
   ldx  [%g4 +  8], %o1
   ldx  [%g4 + 16], %o2
   ldx  [%g4 + 24], %o3
   ldx  [%g4 + 32], %o4
   ldx  [%g4 + 40], %o5
   ldx  [%g4 + 48], %o6
   ldx  [%g4 + 56], %o7
!================================
   add  0x40, %g4, %g4
   stda %f16, [%g3]ASI_BLK_PL	!! asi 0xf8
   ldda [%g3]ASI_BLK_PL, %f16	!! should take an exception
   ldx  [%g4 +  0], %o0		!! check that the stda stored data
   ldx  [%g4 +  8], %o1
   ldx  [%g4 + 16], %o2
   ldx  [%g4 + 24], %o3
   ldx  [%g4 + 32], %o4
   ldx  [%g4 + 40], %o5
   ldx  [%g4 + 48], %o6
   ldx  [%g4 + 56], %o7
!================================
   add  0x40, %g4, %g4
   stda %f0, [%g3]ASI_BLK_S	!! asi 0xf1
   ldda [%g3]ASI_BLK_S, %f0	!! should take an exception
   ldx  [%g4 +  0], %o0		!! check that the stda stored data
   ldx  [%g4 +  8], %o1
   ldx  [%g4 + 16], %o2
   ldx  [%g4 + 24], %o3
   ldx  [%g4 + 32], %o4
   ldx  [%g4 + 40], %o5
   ldx  [%g4 + 48], %o6
   ldx  [%g4 + 56], %o7
!================================
   add  0x40, %g4, %g4
   stda %f16, [%g3]ASI_BLK_SL	!! asi 0xf9
   ldda [%g3]ASI_BLK_SL, %f16	!! should take an exception
   ldx  [%g4 +  0], %o0		!! check that the stda stored data
   ldx  [%g4 +  8], %o1
   ldx  [%g4 + 16], %o2
   ldx  [%g4 + 24], %o3
   ldx  [%g4 + 32], %o4
   ldx  [%g4 + 40], %o5
   ldx  [%g4 + 48], %o6
   ldx  [%g4 + 56], %o7
!================================

!!! These are mentioned in PRM (v1.1) 9.1.2 it says that 
!!! 16-byte loads generated by ldda ASI*QUAD_LDD* should get a DAE_nc_page,
!!! and stores should take a DAE_invalid_asi exception.
	
   add  0x40, %g4, %g4
   stda %f0, [%g4]ASI_BLK_INIT_ST_QUAD_LDD_P		!! asi 0xe2
   ldda [%g4]ASI_BLK_INIT_ST_QUAD_LDD_P, %l0		!! should take an exception
!================================
   add  0x40, %g4, %g4
   stda %f0, [%g4]ASI_BLK_INIT_ST_QUAD_LDD_P_LITTLE	!! asi 0xea
   ldda [%g4]ASI_BLK_INIT_ST_QUAD_LDD_P_LITTLE, %l0	!! should take an exception
!================================
   add  0x40, %g4, %g4
   stda %f0, [%g4]ASI_BLK_INIT_ST_QUAD_LDD_S		!! asi 0xe3
   ldda [%g4]ASI_BLK_INIT_ST_QUAD_LDD_S, %l0		!! should take an exception
!================================
   add  0x40, %g4, %g4
   stda %f0, [%g4]ASI_BLK_INIT_ST_QUAD_LDD_S_LITTLE	!! asi 0xeb
   ldda [%g4]ASI_BLK_INIT_ST_QUAD_LDD_S_LITTLE, %l0	!! should take an exception
!================================
! this gets a Data_Access_MMU_Miss_0x31
!   add  0x40, %g4, %g4
!   stda %f0, [%g4]ASI_AS_IF_USER_BLK_INIT_ST_QUAD_LDD_P	!! asi 0x22
!   ldda [%g4]ASI_AS_IF_USER_BLK_INIT_ST_QUAD_LDD_P, %l0
!================================
!   add  0x40, %g4, %g4
!   stda %f0, [%g4]ASI_AS_IF_USER_BLK_INIT_ST_QUAD_LDD_S	!! asi 0x23
!   ldda [%g4]ASI_AS_IF_USER_BLK_INIT_ST_QUAD_LDD_S, %l0
!================================
   add  0x40, %g4, %g4
   stda %f0, [%g4]ASI_NUCLEUS_QUAD_LDD				!! asi 0x24
   ldda [%g4]ASI_NUCLEUS_QUAD_LDD, %l0
!================================
   add  0x40, %g4, %g4
   stda %f0, [%g4]ASI_QUAD_LDD_REAL				!! asi 0x26
   ldda [%g4]ASI_QUAD_LDD_REAL, %l0
!================================
   add  0x40, %g4, %g4
   stda %f0, [%g4]ASI_NUCLEUS_BLK_INIT_ST_QUAD_LDD		!! asi 0x27
   ldda [%g4]ASI_NUCLEUS_BLK_INIT_ST_QUAD_LDD, %l0
!================================
!   add  0x40, %g4, %g4
!   stda %f0, [%g4]ASI_AS_IF_USER_BLK_INIT_ST_QUAD_LDD_P_LITTLE	!! asi 0x2a
!   ldda [%g4]ASI_AS_IF_USER_BLK_INIT_ST_QUAD_LDD_P_LITTLE, %l0
!================================
!   add  0x40, %g4, %g4
!   stda %f0, [%g4]ASI_AS_IF_USER_BLK_INIT_ST_QUAD_LDD_S_LITTLE	!! asi 0x2b
!   ldda [%g4]ASI_AS_IF_USER_BLK_INIT_ST_QUAD_LDD_S_LITTLE, %l0
!================================
   add  0x40, %g4, %g4
   stda %f0, [%g4]ASI_NUCLEUS_QUAD_LDD_LITTLE			!! asi 0x2c
   ldda [%g4]ASI_NUCLEUS_QUAD_LDD_LITTLE, %l0	
!================================
   add  0x40, %g4, %g4
   stda %f0, [%g4]ASI_QUAD_LDD_REAL_LITTLE			!! asi 0x2e
   ldda [%g4]ASI_QUAD_LDD_REAL_LITTLE, %l0
!================================
   add  0x40, %g4, %g4
   stda %f0, [%g4]ASI_NUCLEUS_BLK_INIT_ST_QUAD_LDD_LITTLE	!! asi 0x2f
   ldda [%g4]ASI_NUCLEUS_BLK_INIT_ST_QUAD_LDD_LITTLE, %l0
!================================

   sub     %l4, 12, %l4		!! There should have been 12 nc_page interrupts
   brnz    %l4, h_bad_end
   nop
	
   sub     %l5, 10, %l5		!! There should have been 10 invalid_asi interrupts
   brnz    %l5, h_bad_end
   nop
	
normal_end:
        ta      T_GOOD_TRAP
        nop

h_bad_end:
        ta      T_BAD_TRAP
        nop
/*
 * Data section
 */

.data
.align 0x40
user_data_start:
    .xword 0xD6B3479DDB28926C
    .xword 0x1122334455667788
    .xword 0x2233445566778811
    .xword 0x3344556677881122
    .xword 0x4455667788112233
    .xword 0x5566778811223344
    .xword 0x6677881122334455
    .xword 0x7881122334455667
    .xword 0x8811223344556677



SECTION .NCDATA  DATA_VA=0xc100be0000

attr_data {
        Name = .NCDATA,
        VA=0xc100be0000,
        RA=0xc100be0000,
        PA=0xc100be0000,
        part_0_ctx_nonzero_tsb_config_2,
        TTE_G=0, TTE_Context=PCONTEXT, TTE_V=1, TTE_Size=0, TTE_SIZE_PTR=0, TTE_NFO=0,
        TTE_IE=0, TTE_Soft2=0, TTE_Diag=0, TTE_Soft=0,
        TTE_L=0, TTE_CP=0, TTE_CV=0, TTE_E=1, TTE_P=0, TTE_W=1
        }

.data
.global ncdata_base
ncdata_base:
        .skip 1000
