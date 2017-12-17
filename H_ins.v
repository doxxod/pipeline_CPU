`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:36:40 12/05/2017 
// Design Name: 
// Module Name:    H_ins 
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
`define RS instr[25:21]
`define RT instr[20:16]
//source
`define ALU 2'b01
`define DM  2'b10
`define PC  2'b11
`define NW  2'b00
module H_ins(
	input [31:0] instr,
	input Tuse_rs0, Tuse_rs1, Tuse_rt0, Tuse_rt1,
	input [1:0] res_e, res_m, res_w,
	input [4:0] A3_e, A3_m, A3_w,
	output stall_data
	);
	
	wire stall_rs0_e1, stall_rs0_e2, stall_rs0_m1, stall_rs1_e2, stall_rt0_e1, stall_rs, stall_rt;
	
	assign stall_rs0_e1 = (Tuse_rs0 & (res_e == `ALU) & (`RS == A3_e) & (`RS != 0)) ? 1 : 0;
	assign stall_rs0_e2 = (Tuse_rs0 & (res_e == `DM)  & (`RS == A3_e) & (`RS != 0)) ? 1 : 0;
	assign stall_rs0_m1 = (Tuse_rs0 & (res_m == `DM)  & (`RS == A3_m) & (`RS != 0)) ? 1 : 0;

	assign stall_rs1_e2 = (Tuse_rs1 & (res_e == `DM)  & (`RS == A3_e) & (`RS != 0)) ? 1 : 0;

	assign stall_rs = (stall_rs0_e1 | stall_rs0_e2 | stall_rs0_m1 | stall_rs1_e2) ? 1 : 0;
	//-------------------------------------------------------------------

	assign stall_rt0_e1 = (Tuse_rt0 & (res_e == `ALU) & (`RT == A3_e) & (`RT != 0)) ? 1 : 0;
	assign stall_rt0_e2 = (Tuse_rt0 & (res_e == `DM)  & (`RT == A3_e) & (`RT != 0)) ? 1 : 0;
	assign stall_rt0_m1 = (Tuse_rt0 & (res_m == `DM)  & (`RT == A3_m) & (`RT != 0)) ? 1 : 0;

	assign stall_rt1_e2 = (Tuse_rt1 & (res_e == `DM)  & (`RT == A3_e) & (`RT != 0)) ? 1 : 0;

	assign stall_rt = (stall_rt0_e1 | stall_rt0_e2 | stall_rt0_m1 | stall_rt1_e2) ? 1 : 0;
	//-------------------------------------------------------------------

	assign stall_data = (stall_rs | stall_rt) ? 1 : 0;

endmodule
