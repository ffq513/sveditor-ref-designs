// ========== Copyright Header Begin ==========================================
// 
// OpenSPARC T2 Processor File: dmu_imu_rds_msi_addr_decode.v
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
module dmu_imu_rds_msi_addr_decode 
	(
	clk,
	rst_l,
	daemon_csrbus_valid,
	daemon_csrbus_addr,
	csrbus_src_bus,
	daemon_csrbus_wr,
	daemon_csrbus_wr_out,
	daemon_csrbus_wr_data,
	daemon_csrbus_wr_data_out,
	daemon_csrbus_mapped,
	csrbus_acc_vio,
	daemon_transaction_in_progress,
	instance_id,
	daemon_csrbus_done,
	msi_mapping_select,
	msi_clear_reg_select,
	int_mondo_data_0_reg_select_pulse,
	int_mondo_data_1_reg_select_pulse
	);

//====================================================================
//     Polarity declarations
//====================================================================
input  clk;  // Clock signal
input  rst_l;  // Reset
input  daemon_csrbus_valid;  // Daemon_Valid
input  [`FIRE_CSRBUS_ADDR_WIDTH - 1:0] daemon_csrbus_addr;  // Daemon_Addr
input  [1:0] csrbus_src_bus;  // Source bus
input  daemon_csrbus_wr;  // Read/Write signal
output daemon_csrbus_wr_out;  // Read/Write signal
input  [`FIRE_CSRBUS_DATA_WIDTH-1:0] daemon_csrbus_wr_data;  // Write data
output [`FIRE_CSRBUS_DATA_WIDTH-1:0] daemon_csrbus_wr_data_out;  // Write data
output daemon_csrbus_mapped;  // mapped
output csrbus_acc_vio;  // acc_vio
input  daemon_transaction_in_progress;  // daemon_transaction_in_progress
input  instance_id;  // Instance ID
output daemon_csrbus_done;  // Operation is done
output msi_mapping_select;  // select signal
output msi_clear_reg_select;  // select signal
output int_mondo_data_0_reg_select_pulse;  // select signal
output int_mondo_data_1_reg_select_pulse;  // select signal

//====================================================================
//     Type declarations
//====================================================================
wire clk;  // Clock signal
wire rst_l;  // Reset
wire daemon_csrbus_valid;  // Daemon_Valid
wire [`FIRE_CSRBUS_ADDR_WIDTH - 1:0] daemon_csrbus_addr;  // Daemon_Addr
wire [1:0] csrbus_src_bus;  // Source bus
wire daemon_csrbus_wr;  // Read/Write signal
reg daemon_csrbus_wr_out;  // Read/Write signal
wire [`FIRE_CSRBUS_DATA_WIDTH-1:0] daemon_csrbus_wr_data;  // Write data
reg [`FIRE_CSRBUS_DATA_WIDTH-1:0] daemon_csrbus_wr_data_out;  // Write data
wire daemon_csrbus_mapped;  // mapped
wire csrbus_acc_vio;  // acc_vio
wire daemon_transaction_in_progress;  // daemon_transaction_in_progress
wire instance_id;  // Instance ID
wire daemon_csrbus_done;  // Operation is done
reg msi_mapping_select;  // select signal
reg msi_clear_reg_select;  // select signal
reg int_mondo_data_0_reg_select_pulse;  // select signal
reg int_mondo_data_1_reg_select_pulse;  // select signal


//====================================================================
//     Clocked valid
//====================================================================
reg clocked_valid;
reg clocked_valid_pulse;
always @(posedge clk)
  begin
     if(~rst_l)
       begin
          clocked_valid <= 1'b0;
          clocked_valid_pulse <= 1'b0;
       end
     else
       begin
          clocked_valid <= daemon_csrbus_valid;
          clocked_valid_pulse <= daemon_csrbus_valid & ~clocked_valid;
       end
  end

//====================================================================
//    Address Decode
//====================================================================
reg msi_mapping_addr_decoded;
reg msi_clear_reg_addr_decoded;
reg int_mondo_data_0_reg_addr_decoded;
reg int_mondo_data_1_reg_addr_decoded;

always @(daemon_csrbus_addr or daemon_csrbus_valid or instance_id)
  begin
    if (~daemon_csrbus_valid)
      begin
        msi_mapping_addr_decoded = 1'b0;
        msi_clear_reg_addr_decoded = 1'b0;
        int_mondo_data_0_reg_addr_decoded = 1'b0;
        int_mondo_data_1_reg_addr_decoded = 1'b0;
      end
    else
      case (instance_id)

        `FIRE_DLC_IMU_RDS_MSI_INSTANCE_ID_VALUE_A:
          begin
        msi_mapping_addr_decoded =
                {8'b0,daemon_csrbus_addr[26:8]} ==
                    `FIRE_DLC_IMU_RDS_MSI_CSR_A_MSI_MAPPING_HW_ADDR >>
                        `FIRE_DLC_IMU_RDS_MSI_CSR_MSI_MAPPING_LOW_ADDR_WIDTH;
        msi_clear_reg_addr_decoded =
                {8'b0,daemon_csrbus_addr[26:8]} ==
                    `FIRE_DLC_IMU_RDS_MSI_CSR_A_MSI_CLEAR_REG_RW1C_ALIAS_HW_ADDR >>
                        `FIRE_DLC_IMU_RDS_MSI_CSR_MSI_CLEAR_REG_RW1C_ALIAS_LOW_ADDR_WIDTH |
                {8'b0,daemon_csrbus_addr[26:8]} ==
                    `FIRE_DLC_IMU_RDS_MSI_CSR_A_MSI_CLEAR_REG_RW1S_ALIAS_HW_ADDR >>
                        `FIRE_DLC_IMU_RDS_MSI_CSR_MSI_CLEAR_REG_RW1S_ALIAS_LOW_ADDR_WIDTH;
        int_mondo_data_0_reg_addr_decoded =
                daemon_csrbus_addr[26:0] == `FIRE_DLC_IMU_RDS_MSI_CSR_A_INT_MONDO_DATA_0_REG_HW_ADDR;
        int_mondo_data_1_reg_addr_decoded =
                daemon_csrbus_addr[26:0] == `FIRE_DLC_IMU_RDS_MSI_CSR_A_INT_MONDO_DATA_1_REG_HW_ADDR;
          end

        `FIRE_DLC_IMU_RDS_MSI_INSTANCE_ID_VALUE_B:
          begin
        msi_mapping_addr_decoded =
                {8'b0,daemon_csrbus_addr[26:8]} ==
                    `FIRE_DLC_IMU_RDS_MSI_CSR_B_MSI_MAPPING_HW_ADDR >>
                        `FIRE_DLC_IMU_RDS_MSI_CSR_MSI_MAPPING_LOW_ADDR_WIDTH;
        msi_clear_reg_addr_decoded =
                {8'b0,daemon_csrbus_addr[26:8]} ==
                    `FIRE_DLC_IMU_RDS_MSI_CSR_B_MSI_CLEAR_REG_RW1C_ALIAS_HW_ADDR >>
                        `FIRE_DLC_IMU_RDS_MSI_CSR_MSI_CLEAR_REG_RW1C_ALIAS_LOW_ADDR_WIDTH |
                {8'b0,daemon_csrbus_addr[26:8]} ==
                    `FIRE_DLC_IMU_RDS_MSI_CSR_B_MSI_CLEAR_REG_RW1S_ALIAS_HW_ADDR >>
                        `FIRE_DLC_IMU_RDS_MSI_CSR_MSI_CLEAR_REG_RW1S_ALIAS_LOW_ADDR_WIDTH;
        int_mondo_data_0_reg_addr_decoded =
                daemon_csrbus_addr[26:0] == `FIRE_DLC_IMU_RDS_MSI_CSR_B_INT_MONDO_DATA_0_REG_HW_ADDR;
        int_mondo_data_1_reg_addr_decoded =
                daemon_csrbus_addr[26:0] == `FIRE_DLC_IMU_RDS_MSI_CSR_B_INT_MONDO_DATA_1_REG_HW_ADDR;
          end

        default:
          begin
            msi_mapping_addr_decoded = 1'b0;
            msi_clear_reg_addr_decoded = 1'b0;
            int_mondo_data_0_reg_addr_decoded = 1'b0;
            int_mondo_data_1_reg_addr_decoded = 1'b0;
// vlint flag_system_call off
            // synopsys translate_off
            if(daemon_csrbus_valid)
               begin // axis tbcall_region
`ifdef PR_ERROR if ($time > 1 && rst_l) `PR_ERROR("dmu_imu_rds_msi_addr_decode",`MON_ERROR,"ERROR: Instance ID for module dmu_imu_rds_msi_csr is bad"); `endif
               end // end of tbcall_region
            // synopsys translate_on
// vlint flag_system_call on
          end
      endcase
  end

//====================================================================
//      Register violations
//====================================================================
//----- reg_acc_vio: msi_mapping
reg msi_mapping_acc_vio;
always @(csrbus_src_bus or daemon_csrbus_wr or
         msi_mapping_addr_decoded or
         daemon_transaction_in_progress)
  begin
    if (daemon_transaction_in_progress | ~msi_mapping_addr_decoded)
      msi_mapping_acc_vio = 1'b0;
    else
      case ({csrbus_src_bus, daemon_csrbus_wr})
        // reads
          {`FIRE_CSRBUS_SRC_BUS_ENC_JTAG, 1'b0}:
              msi_mapping_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_SLOW, 1'b0}:
              msi_mapping_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_MED, 1'b0}:
              msi_mapping_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_FAST, 1'b0}:
              msi_mapping_acc_vio = 1'b0;
        // writes
          {`FIRE_CSRBUS_SRC_BUS_ENC_JTAG, 1'b1}:
              msi_mapping_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_SLOW, 1'b1}:
              msi_mapping_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_MED, 1'b1}:
              msi_mapping_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_FAST, 1'b1}:
              msi_mapping_acc_vio = 1'b0;

          default: 
             begin
                msi_mapping_acc_vio = 1'b0;
                begin // axis tbcall_region
                      // vlint flag_system_call off
                      // synopsys translate_off
`ifdef PR_ERROR if ($time > 1 && rst_l) `PR_ERROR("dmu_imu_rds_msi_addr_decode",`MON_ERROR,"acc_vio: default case of dmu_imu_rds_msi_csr_a_msi_mapping"); `endif
                    // synopsys translate_on
                    // vlint flag_system_call on
                end // end of tbcall_region
             end
      endcase
  end
//----- reg_acc_vio: msi_clear_reg
reg msi_clear_reg_acc_vio;
always @(csrbus_src_bus or daemon_csrbus_wr or
         msi_clear_reg_addr_decoded or
         daemon_transaction_in_progress)
  begin
    if (daemon_transaction_in_progress | ~msi_clear_reg_addr_decoded)
      msi_clear_reg_acc_vio = 1'b0;
    else
      case ({csrbus_src_bus, daemon_csrbus_wr})
        // reads
          {`FIRE_CSRBUS_SRC_BUS_ENC_JTAG, 1'b0}:
              msi_clear_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_SLOW, 1'b0}:
              msi_clear_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_MED, 1'b0}:
              msi_clear_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_FAST, 1'b0}:
              msi_clear_reg_acc_vio = 1'b0;
        // writes
          {`FIRE_CSRBUS_SRC_BUS_ENC_JTAG, 1'b1}:
              msi_clear_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_SLOW, 1'b1}:
              msi_clear_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_MED, 1'b1}:
              msi_clear_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_FAST, 1'b1}:
              msi_clear_reg_acc_vio = 1'b0;

          default: 
             begin
                msi_clear_reg_acc_vio = 1'b0;
                begin // axis tbcall_region
                      // vlint flag_system_call off
                      // synopsys translate_off
`ifdef PR_ERROR if ($time > 1 && rst_l) `PR_ERROR("dmu_imu_rds_msi_addr_decode",`MON_ERROR,"acc_vio: default case of dmu_imu_rds_msi_csr_a_msi_clear_reg_rw1c_alias"); `endif
                    // synopsys translate_on
                    // vlint flag_system_call on
                end // end of tbcall_region
             end
      endcase
  end
//----- reg_acc_vio: int_mondo_data_0_reg
reg int_mondo_data_0_reg_acc_vio;
always @(csrbus_src_bus or daemon_csrbus_wr or
         int_mondo_data_0_reg_addr_decoded or
         daemon_transaction_in_progress)
  begin
    if (daemon_transaction_in_progress | ~int_mondo_data_0_reg_addr_decoded)
      int_mondo_data_0_reg_acc_vio = 1'b0;
    else
      case ({csrbus_src_bus, daemon_csrbus_wr})
        // reads
          {`FIRE_CSRBUS_SRC_BUS_ENC_JTAG, 1'b0}:
              int_mondo_data_0_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_SLOW, 1'b0}:
              int_mondo_data_0_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_MED, 1'b0}:
              int_mondo_data_0_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_FAST, 1'b0}:
              int_mondo_data_0_reg_acc_vio = 1'b0;
        // writes
          {`FIRE_CSRBUS_SRC_BUS_ENC_JTAG, 1'b1}:
              int_mondo_data_0_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_SLOW, 1'b1}:
              int_mondo_data_0_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_MED, 1'b1}:
              int_mondo_data_0_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_FAST, 1'b1}:
              int_mondo_data_0_reg_acc_vio = 1'b0;

          default: 
             begin
                int_mondo_data_0_reg_acc_vio = 1'b0;
                begin // axis tbcall_region
                      // vlint flag_system_call off
                      // synopsys translate_off
`ifdef PR_ERROR if ($time > 1 && rst_l) `PR_ERROR("dmu_imu_rds_msi_addr_decode",`MON_ERROR,"acc_vio: default case of dmu_imu_rds_msi_csr_a_int_mondo_data_0_reg"); `endif
                    // synopsys translate_on
                    // vlint flag_system_call on
                end // end of tbcall_region
             end
      endcase
  end
//----- reg_acc_vio: int_mondo_data_1_reg
reg int_mondo_data_1_reg_acc_vio;
always @(csrbus_src_bus or daemon_csrbus_wr or
         int_mondo_data_1_reg_addr_decoded or
         daemon_transaction_in_progress)
  begin
    if (daemon_transaction_in_progress | ~int_mondo_data_1_reg_addr_decoded)
      int_mondo_data_1_reg_acc_vio = 1'b0;
    else
      case ({csrbus_src_bus, daemon_csrbus_wr})
        // reads
          {`FIRE_CSRBUS_SRC_BUS_ENC_JTAG, 1'b0}:
              int_mondo_data_1_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_SLOW, 1'b0}:
              int_mondo_data_1_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_MED, 1'b0}:
              int_mondo_data_1_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_FAST, 1'b0}:
              int_mondo_data_1_reg_acc_vio = 1'b0;
        // writes
          {`FIRE_CSRBUS_SRC_BUS_ENC_JTAG, 1'b1}:
              int_mondo_data_1_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_SLOW, 1'b1}:
              int_mondo_data_1_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_MED, 1'b1}:
              int_mondo_data_1_reg_acc_vio = 1'b0;
          {`FIRE_CSRBUS_SRC_BUS_ENC_PIO_FAST, 1'b1}:
              int_mondo_data_1_reg_acc_vio = 1'b0;

          default: 
             begin
                int_mondo_data_1_reg_acc_vio = 1'b0;
                begin // axis tbcall_region
                      // vlint flag_system_call off
                      // synopsys translate_off
`ifdef PR_ERROR if ($time > 1 && rst_l) `PR_ERROR("dmu_imu_rds_msi_addr_decode",`MON_ERROR,"acc_vio: default case of dmu_imu_rds_msi_csr_a_int_mondo_data_1_reg"); `endif
                    // synopsys translate_on
                    // vlint flag_system_call on
                end // end of tbcall_region
             end
      endcase
  end

//====================================================================
//    Status: daemon_csrbus_mapped / csrbus_acc_vio
//====================================================================
//----- OUTPUT: daemon_csrbus_mapped
assign daemon_csrbus_mapped = clocked_valid_pulse &
                                (
                                  msi_mapping_addr_decoded |
                                  msi_clear_reg_addr_decoded |
                                  int_mondo_data_0_reg_addr_decoded |
                                  int_mondo_data_1_reg_addr_decoded
                                );


// daemon_csrbus_mapped gets asserted after fixed number of cycles
// after daemon_csrbus_valid become high
/* 0in assert_together -name mapped_after_valid
       -leader $0in_rising_edge($0in_delay(daemon_csrbus_valid, 1))
       -follower $0in_rising_edge(daemon_csrbus_mapped)
       -message ("daemon_csrbus_mapped was not asserted 1 clock cycles from csrbus_valid")
       -module dmu_imu_rds_msi_addr_decode
       -clock clk
       -active $0in_rising_edge(daemon_csrbus_mapped)
*/

// daemon_csrbus_mapped is a pulse
/* 0in assert_timer -name daemon_csrbus_mapped_pulse
       -var daemon_csrbus_mapped -max 1
       -message "daemon_csrbus_mapped pulse length is not 1"
       -module dmu_imu_rds_msi_addr_decode
       -clock clk
*/
//----- OUTPUT: csrbus_acc_vio
assign csrbus_acc_vio = clocked_valid_pulse &
                        msi_mapping_acc_vio |
                        msi_clear_reg_acc_vio |
                        int_mondo_data_0_reg_acc_vio |
                        int_mondo_data_1_reg_acc_vio;

//====================================================================
//    Select
//====================================================================
always @(posedge clk)
  begin
     if(~rst_l)
       begin
          msi_mapping_select <= 1'b0;
          msi_clear_reg_select <= 1'b0;
          int_mondo_data_0_reg_select_pulse <= 1'b0;
          int_mondo_data_1_reg_select_pulse <= 1'b0;
       end
     else
       begin
          msi_mapping_select <=
         ~ msi_mapping_acc_vio &
         msi_mapping_addr_decoded;

          msi_clear_reg_select <=
         ~ msi_clear_reg_acc_vio &
         msi_clear_reg_addr_decoded;

          int_mondo_data_0_reg_select_pulse <=
         ~int_mondo_data_0_reg_acc_vio &
         clocked_valid_pulse &
         int_mondo_data_0_reg_addr_decoded;

          int_mondo_data_1_reg_select_pulse <=
         ~int_mondo_data_1_reg_acc_vio &
         clocked_valid_pulse &
         int_mondo_data_1_reg_addr_decoded;

        end
  end

//====================================================================
//    daemon_csrbus_wr / daemon_csrbus_wr_data
//====================================================================
always @(posedge clk)
  begin
     if(~rst_l)
       begin
          daemon_csrbus_wr_out      <= 1'b0;
          daemon_csrbus_wr_data_out <= `FIRE_CSRBUS_DATA_WIDTH'b0;
       end
     else
       begin
          daemon_csrbus_wr_out      <= daemon_csrbus_wr;
          daemon_csrbus_wr_data_out <= daemon_csrbus_wr_data;
        end
  end

//====================================================================
//    Cycle Counter: Used for ExtReadTiming / ExtWriteTiming
//====================================================================

//====================================================================
//   OUTPUT: daemon_csrbus_done (pipelining)
//====================================================================
//----- DONE for internal/extern registers
reg stage_1_daemon_csrbus_done_internal_0;
reg stage_1_daemon_csrbus_done_internal_1;
reg stage_2_daemon_csrbus_done_internal_0;
reg stage_3_daemon_csrbus_done_internal_0;
reg stage_4_daemon_csrbus_done_internal_0;

always @(posedge clk)
  begin
     if(~rst_l)
       begin
         stage_1_daemon_csrbus_done_internal_0 <= 1'b0;
         stage_1_daemon_csrbus_done_internal_1 <= 1'b0;
       end
     else
       begin
         stage_1_daemon_csrbus_done_internal_0 <=
                 int_mondo_data_0_reg_select_pulse |
                 int_mondo_data_1_reg_select_pulse |
                 msi_mapping_select & clocked_valid_pulse;
         stage_1_daemon_csrbus_done_internal_1 <=
                 msi_clear_reg_select & clocked_valid_pulse;
       end
     if(~rst_l)
       begin
         stage_2_daemon_csrbus_done_internal_0 <= 1'b0;
       end
     else
       begin
         stage_2_daemon_csrbus_done_internal_0 <=
                 stage_1_daemon_csrbus_done_internal_0 |
                 stage_1_daemon_csrbus_done_internal_1;
       end
     if(~rst_l)
       begin
         stage_3_daemon_csrbus_done_internal_0 <= 1'b0;
       end
     else
       begin
         stage_3_daemon_csrbus_done_internal_0 <=
                 stage_2_daemon_csrbus_done_internal_0;
       end
     if(~rst_l)
       begin
         stage_4_daemon_csrbus_done_internal_0 <= 1'b0;
       end
     else
       begin
         stage_4_daemon_csrbus_done_internal_0 <=
                 stage_3_daemon_csrbus_done_internal_0;
       end
  end

//----- OUTPUT: daemon_csrbus_done
assign daemon_csrbus_done = daemon_csrbus_valid &
          (
            stage_4_daemon_csrbus_done_internal_0
          );

// daemon_csrbus_done gets asserted only when csrbus_valid is high
/* 0in assert -name daemon_csrbus_done_high
       -var daemon_csrbus_valid -active daemon_csrbus_done
       -message "csrbus_done got asserted while csrbus_valid is low"
       -module dmu_imu_rds_msi_addr_decode
       -clock clk
*/

// daemon_csrbus_done is a pulse
/* 0in assert_timer -name daemon_csrbus_done_pulse
       -var daemon_csrbus_done -max 1
       -message "csrbus_done pulse length is not 1"
       -module dmu_imu_rds_msi_addr_decode
       -clock clk
*/

endmodule // dmu_imu_rds_msi_addr_decode
