// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T2 Processor File: xpcs_tx_randomizer.v
// Copyright (C) 1995-2007 Sun Microsystems, Inc. All Rights Reserved
// 4150 Network Circle, Santa Clara, California 95054, U.S.A.
//
// * DO NOT ALTER OR REMOVE COPYRIGHT NOTICES OR THIS FILE HEADER. 
//
// This program is free software; you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation; version 2 of the License.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program; if not, write to the Free Software
// Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
// 
// For the avoidance of doubt, and except that if any non-GPL license 
// choice is available it will apply instead, Sun elects to use only 
// the General Public License version 2 (GPLv2) at this time for any 
// software where a choice of GPL license versions is made 
// available with the language indicating that GPLv2 or any later version 
// may be used, or where a choice of which version of the GPL is applied is 
// otherwise unspecified. 
//
// Please contact Sun Microsystems, Inc., 4150 Network Circle, Santa Clara, 
// CA 95054 USA or visit www.sun.com if you need additional information or 
// have any questions. 
// 
// ========== Copyright Header End ============================================
/**********************************************************************/
/* Project Name  :  Vega                                              */
/* Module Name   :  xpcs_tx_randomizer                   	      */
/* Description   :  Randomizer to generate the flag for random idle   */
/*		    generation and timer for align pattern generation.*/
/*		    Randomizer and timer are compliant per Clause 48  */
/*                  of IEEE802.3ae (see fig. 48-5 PCS Idle Randomizer */
/*                                                                    */
/*                  Polynomial 1 + x^3 + x^7                          */
/*    								      */
/* Assumptions   : none.					      */
/*    								      */
/* Parent module : xpcs_tx_randomizer.v				      */
/* Child modules : none.					      */
/* Author Name   : Carlos Castil                                      */
/* Date Created  : 11/10/02                                           */
/*                                                                    */
/*              Copyright (c) 2002, Sun Microsystems, Inc.            */
/*                   Sun Proprietary and Confidential                 */
/*                                                                    */ 
/* Modifications :                                                    */
/**********************************************************************/
 
module xpcs_tx_randomizer (tx_clk, 
                           reset, 
                           align_count_exp, 
                           clr_align_count, 
                           code_sel);

input		tx_clk;  	// 156 MHz clock
input		reset;   	

input           clr_align_count;  // Align transmitted 

output		align_count_exp;// High at the end of the loadable timer.
                                //  Will go low after ||A|| is trasmitted.

output		code_sel;	//  0: LSB of randomizer = 0 for even
                                //  1: LSB of randomizer = 1 for odd


reg  [6:0]	pat;		// pseudo random pattern generated by LFSR
reg  [4:0]      align_count;      // Align counter

wire		feedback;	// feedback loop to input of LFSR
wire [6:0]	del_pat;	// delay for hold time for lfsr


assign          feedback = pat[0];
assign          code_sel = pat[0];

assign          align_count_exp = (align_count == 5'b00000); 


/*
** Primitive polynomial 1 + x^3 + x^7
*/
always @(posedge tx_clk)
    if 
      (reset) pat <= 7'h1;
    else
      begin
       pat[0] <= del_pat[0];
       pat[1] <= del_pat[1];
       pat[2] <= del_pat[2];
       pat[3] <= del_pat[3];
       pat[4] <= del_pat[4];
       pat[5] <= del_pat[5];
       pat[6] <= del_pat[6];
     end

/*
** Delay For hold time requirement
*/
xpcs_tx_del delay_pattern (
      .Z(del_pat),
      .A({feedback,			// x^7
          pat[6],
          pat[5],
          pat[4] ^ feedback,		// x^3
          pat[3], 
          pat[2],
          pat[1]}) );

/*
** Align counter
*/

always @ (posedge tx_clk)
  if (reset)
     align_count <= 5'b10000;
  else if (clr_align_count)
     align_count <= {1'b1,pat[3:0]};
  else if (align_count == 5'b00000)
     align_count <= align_count;
  else
     align_count <= align_count - 5'b00001; 
  


endmodule

