`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:24:08 12/04/2017 
// Design Name: 
// Module Name:    cmp 
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
module cmp(
	input [31:0] A, B,
	input [2:0] cmp_sel,
	output zero
    );

	wire [31:0] CMP_A;
	wire [31:0] CMP_B;
	wire [31:0] CMP_C;
	wire [31:0] CMP_D;
	wire [31:0] CMP_E;
	wire [31:0] CMP_G;
	wire [31:0] cmp;
	assign CMP_A = $signed(A) <  0 ? 1 : 0;  // >=
	assign CMP_B = $signed(A) >= 0 ? 1 : 0;  // <
	assign CMP_C = $signed(A) <= 0 ? 1 : 0;  // >
	assign CMP_D = $signed(A) >  0 ? 1 : 0;  // <=
	assign CMP_E = A == B ? 1 : 0;  // !=
	assign CMP_F = A != B ? 1 : 0;	// ==
	assign CMP_G = A != 0 ? 1 : 0;  // == 0 for movz
	assign cmp = (cmp_sel == 6) ? CMP_G : (cmp_sel == 5) ? CMP_F : (cmp_sel == 4) ? CMP_E : (cmp_sel == 3) ? CMP_D : (cmp_sel == 2) ? CMP_C : (cmp_sel == 1) ? CMP_B : CMP_A;
	
	assign zero = (cmp == 0) ? 1 : 0;
endmodule
