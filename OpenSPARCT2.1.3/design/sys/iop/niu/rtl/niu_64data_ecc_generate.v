// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T2 Processor File: niu_64data_ecc_generate.v
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
 `timescale 1ns/1ns
// ****************************************************************************
//                Copyright (c) 2002 by Sun Microsystems Inc.
//
// All rights reserved. No part of this design may be reproduced stored
// in a retrieval system, or transmitted, in any form or by any means,
// electronic, mechanical, photocopying, recording, or otherwise, without
// prior written permission of Sun Microsystems, Inc.
//
//                       Sun Proprietary/Confidential
//
// ****************************************************************************
//      File Name : niu_64data_ecc_generate.sv
//        Version : /main/1
//    Last Update : 07/01/04 18:20:35 loj
// ****************************************************************************
//    Module      :  niu_64data_ecc_generate
//    Description :  SEC-DED Checkbit Generation
//                   din[63:0] refers to data bits[63:0]
//                   For SEC and SEC-DED, dout[71:0] refers to
//                   {data bits[63:0], check bits[7:0]} if the -p switch
//                   is not set and {check bits[7:0]} if the -p switch is set.
//                   This module is used while writing data       
// ***************************************************************************
// Revision History
// Date        Author  Description
// 07/01/04    loj   Initial verilog generated from ECC automation script
// ****************************************************************************

module niu_64data_ecc_generate (din, dout);

input  [63:0] din;
output [71:0] dout;

wire [7:0] chk;

assign chk[7] = din[61] ^ din[58] ^ din[56] ^ din[53] ^ din[51] ^ din[48] ^ din[45] ^ din[42] ^ din[39] ^ din[37] ^ din[35] ^ din[31] ^ din[29] ^ din[27] ^ din[23] ^ din[22] ^ din[18] ^ din[15] ^ din[14] ^ din[10] ^ din[9] ^ din[6] ^ din[4] ^ din[3] ^ din[1] ^ din[0];
assign chk[6] = din[61] ^ din[59] ^ din[56] ^ din[53] ^ din[50] ^ din[48] ^ din[46] ^ din[43] ^ din[40] ^ din[38] ^ din[34] ^ din[32] ^ din[30] ^ din[26] ^ din[24] ^ din[21] ^ din[18] ^ din[17] ^ din[13] ^ din[10] ^ din[8] ^ din[6] ^ din[5] ^ din[3] ^ din[1] ^ din[0];
assign chk[5] = din[62] ^ din[59] ^ din[56] ^ din[54] ^ din[51] ^ din[49] ^ din[45] ^ din[43] ^ din[40] ^ din[37] ^ din[35] ^ din[33] ^ din[29] ^ din[28] ^ din[25] ^ din[21] ^ din[20] ^ din[16] ^ din[13] ^ din[12] ^ din[11] ^ din[6] ^ din[5] ^ din[3] ^ din[2] ^ din[0];
assign chk[4] = din[62] ^ din[59] ^ din[57] ^ din[54] ^ din[51] ^ din[48] ^ din[47] ^ din[44] ^ din[41] ^ din[38] ^ din[36] ^ din[32] ^ din[30] ^ din[27] ^ din[24] ^ din[22] ^ din[19] ^ din[16] ^ din[15] ^ din[11] ^ din[9] ^ din[7] ^ din[5] ^ din[3] ^ din[2] ^ din[0];
assign chk[3] = din[62] ^ din[60] ^ din[57] ^ din[55] ^ din[52] ^ din[49] ^ din[46] ^ din[43] ^ din[41] ^ din[38] ^ din[35] ^ din[33] ^ din[31] ^ din[27] ^ din[26] ^ din[23] ^ din[19] ^ din[17] ^ din[14] ^ din[12] ^ din[10] ^ din[7] ^ din[5] ^ din[4] ^ din[2] ^ din[0];
assign chk[2] = din[63] ^ din[60] ^ din[57] ^ din[54] ^ din[52] ^ din[49] ^ din[46] ^ din[44] ^ din[42] ^ din[39] ^ din[36] ^ din[34] ^ din[30] ^ din[29] ^ din[25] ^ din[22] ^ din[20] ^ din[18] ^ din[14] ^ din[13] ^ din[8] ^ din[7] ^ din[5] ^ din[4] ^ din[2] ^ din[1];
assign chk[1] = din[63] ^ din[60] ^ din[58] ^ din[55] ^ din[53] ^ din[50] ^ din[47] ^ din[44] ^ din[41] ^ din[39] ^ din[37] ^ din[33] ^ din[31] ^ din[28] ^ din[25] ^ din[24] ^ din[21] ^ din[17] ^ din[15] ^ din[11] ^ din[8] ^ din[7] ^ din[6] ^ din[4] ^ din[2] ^ din[1];
assign chk[0] = din[63] ^ din[61] ^ din[58] ^ din[55] ^ din[52] ^ din[50] ^ din[47] ^ din[45] ^ din[42] ^ din[40] ^ din[36] ^ din[34] ^ din[32] ^ din[28] ^ din[26] ^ din[23] ^ din[20] ^ din[19] ^ din[16] ^ din[12] ^ din[9] ^ din[7] ^ din[6] ^ din[4] ^ din[3] ^ din[1];

assign dout[71] = din[63];
assign dout[70] = din[62];
assign dout[69] = din[61];
assign dout[68] = din[60];
assign dout[67] = din[59];
assign dout[66] = din[58];
assign dout[65] = din[57];
assign dout[64] = din[56];
assign dout[63] = din[55];
assign dout[62] = din[54];
assign dout[61] = din[53];
assign dout[60] = din[52];
assign dout[59] = din[51];
assign dout[58] = din[50];
assign dout[57] = din[49];
assign dout[56] = din[48];
assign dout[55] = din[47];
assign dout[54] = din[46];
assign dout[53] = din[45];
assign dout[52] = din[44];
assign dout[51] = din[43];
assign dout[50] = din[42];
assign dout[49] = din[41];
assign dout[48] = din[40];
assign dout[47] = din[39];
assign dout[46] = din[38];
assign dout[45] = din[37];
assign dout[44] = din[36];
assign dout[43] = din[35];
assign dout[42] = din[34];
assign dout[41] = din[33];
assign dout[40] = din[32];
assign dout[39] = din[31];
assign dout[38] = din[30];
assign dout[37] = din[29];
assign dout[36] = din[28];
assign dout[35] = din[27];
assign dout[34] = din[26];
assign dout[33] = din[25];
assign dout[32] = din[24];
assign dout[31] = din[23];
assign dout[30] = din[22];
assign dout[29] = din[21];
assign dout[28] = din[20];
assign dout[27] = din[19];
assign dout[26] = din[18];
assign dout[25] = din[17];
assign dout[24] = din[16];
assign dout[23] = din[15];
assign dout[22] = din[14];
assign dout[21] = din[13];
assign dout[20] = din[12];
assign dout[19] = din[11];
assign dout[18] = din[10];
assign dout[17] = din[9];
assign dout[16] = din[8];
assign dout[15] = din[7];
assign dout[14] = din[6];
assign dout[13] = din[5];
assign dout[12] = din[4];
assign dout[11] = din[3];
assign dout[10] = din[2];
assign dout[9] = din[1];
assign dout[8] = din[0];
assign dout[7] = chk[7];
assign dout[6] = chk[6];
assign dout[5] = chk[5];
assign dout[4] = chk[4];
assign dout[3] = chk[3];
assign dout[2] = chk[2];
assign dout[1] = chk[1];
assign dout[0] = chk[0];


endmodule
