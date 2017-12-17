`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:35:54 12/05/2017 
// Design Name: 
// Module Name:    F_ctr 
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
`define M2E_PC  5
`define M2E_ALU 4
`define W2E_ALU 3
`define W2E_PC  2
`define W2E_DM  1

`define M2D_PC  5
`define M2D_ALU 4
`define W2D_ALU 3
`define W2D_PC  2
`define W2D_DM  1

//source
`define ALU 2'b01
`define DM  2'b10
`define PC  2'b11
`define NW  2'b00

module F_ctr(
	input [4:0] A1_d,
	input [4:0] A2_d,
	input [4:0] A1_e,
	input [4:0] A2_e,
	input [4:0] A3_e,
	input [4:0] A3_m,
	input [4:0] A3_w,
	input [31:0] instr,
	input RegWr_M, RegWr_W,
	input [1:0] res_e, res_m, res_w,
	//input Tuse_rs0, Tuse_rs1, Tuse_rt0, Tuse_rt1,
	output [2:0] F_CMP_D1_D_sel,
	output [2:0] F_CMP_D2_D_sel,
	output [2:0] F_ALUA_E_sel,
	output [2:0] F_ALUB_E_sel
	);

	//A_Tdec ResFrom(instr[31:26], Tuse_rs0, Tuse_rs1, Tuse_rt0, Tuse_rt1, res_e, res_m, res_w);

	assign F_CMP_D1_D_sel = ((A1_d == A3_m) & (res_m == `PC)  & (A3_m != 0) & (RegWr_M != 0)) ? `M2D_PC  :
						    ((A1_d == A3_m) & (res_m == `ALU) & (A3_m != 0) & (RegWr_M != 0)) ? `M2D_ALU : 
						    ((A1_d == A3_w) & (res_w == `PC)  & (A3_w != 0) & (RegWr_W != 0)) ? `W2D_PC  :
 							((A1_d == A3_w) & (res_w == `ALU) & (A3_w != 0) & (RegWr_W != 0)) ? `W2D_ALU : 
 							((A1_d == A3_w) & (res_w == `DM)  & (A3_w != 0) & (RegWr_W != 0)) ? `W2D_DM  : 0;

	assign F_CMP_D2_D_sel = ((A2_d == A3_m) & (res_m == `ALU) & (A3_m != 0) & (RegWr_M != 0)) ? `M2D_ALU : 
							((A2_d == A3_m) & (res_m == `PC)  & (A3_m != 0) & (RegWr_M != 0)) ? `M2D_PC  : 
							((A2_d == A3_w) & (res_w == `DM)  & (A3_w != 0) & (RegWr_W != 0)) ? `W2D_DM  : 
							((A2_d == A3_w) & (res_w == `PC)  & (A3_w != 0) & (RegWr_W != 0)) ? `W2D_PC  :
							((A2_d == A3_w) & (res_w == `ALU) & (A3_w != 0) & (RegWr_W != 0)) ? `W2D_ALU : 0;

	assign F_ALUA_E_sel   = ((A1_e == A3_m) & (res_m == `ALU) & (A3_m != 0) & (RegWr_M != 0)) ? `M2E_ALU : 
							((A1_e == A3_m) & (res_m == `PC)  & (A3_m != 0) & (RegWr_M != 0)) ? `M2E_PC  : 
							((A1_e == A3_w) & (res_w == `DM)  & (A3_w != 0) & (RegWr_W != 0)) ? `W2E_DM  :
							((A1_e == A3_w) & (res_w == `PC)  & (A3_w != 0) & (RegWr_W != 0)) ? `W2E_PC  :
							((A1_e == A3_w) & (res_w == `ALU) & (A3_w != 0) & (RegWr_W != 0)) ? `W2E_ALU : 0;

	assign F_ALUB_E_sel   = ((A2_e == A3_m) & (res_m == `ALU) & (A3_m != 0) & (RegWr_M != 0)) ? `M2E_ALU :
						    ((A2_e == A3_m) & (res_m == `PC)  & (A3_m != 0) & (RegWr_M != 0)) ? `M2E_PC  : 
						    ((A2_e == A3_w) & (res_w == `DM)  & (A3_w != 0) & (RegWr_W != 0)) ? `W2E_DM  :
						    ((A2_e == A3_w) & (res_w == `PC)  & (A3_w != 0) & (RegWr_W != 0)) ? `W2E_PC  :
						    ((A2_e == A3_w) & (res_w == `ALU) & (A3_w != 0) & (RegWr_W != 0)) ? `W2E_ALU : 0;

endmodule