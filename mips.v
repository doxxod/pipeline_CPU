`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    11:27:32 12/04/2017 
// Design Name: 
// Module Name:    mips 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
module mips(input clk, reset);
	 wire [31:0] instr;
	 wire [2:0] F_CMP_D1_D_sel, F_CMP_D2_D_sel, F_ALUA_E_sel, F_ALUB_E_sel;
	 wire stall_data;
	 wire [4:0] A1_d, A2_d, A1_e, A2_e, A3_e, A3_m, A3_w;
	 wire RegWr_M, RegWr_W;
	 
	 datapath dp(clk, reset, F_CMP_D1_D_sel, F_CMP_D2_D_sel, F_ALUA_E_sel, F_ALUB_E_sel, stall_data, RegWr_M, RegWr_W, A1_d, A2_d, A1_e, A2_e, A3_e, A3_m, A3_w, instr);
	 controller c(clk, reset, A1_d, A2_d, A1_e, A2_e, A3_e, A3_m, A3_w, instr, RegWr_M, RegWr_W, F_CMP_D1_D_sel, F_CMP_D2_D_sel, F_ALUA_E_sel, F_ALUB_E_sel, stall_data);

endmodule
