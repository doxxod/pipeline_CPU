`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:25:19 12/04/2017 
// Design Name: 
// Module Name:    alu 
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
`define AND 4'b0000
`define OR  4'b0001
`define ADD 4'b0010
`define XOR 4'b0011
`define CMP 4'b0100
`define SFT 4'b0101
`define SUB 4'b0110
`define NOR 4'b0111

module alu(
	input [31:0] A,
	input [31:0] B,
	input [2:0] cmp_sel, 
	input [2:0] sft_sel,
	input [3:0] ALUctr,
	output [31:0] ALUout
	);
	
	wire [31:0] sft_out, cmp_out;
	wire [31:0] CMP_A, CMP_B, CMP_C, CMP_D, CMP_E, CMP_F, CMP_G;
	assign sft_out = (sft_sel == 5) ? (A << B[10:6]) : /*SLL*/
					 (sft_sel == 4) ? (B << A[4:0])  : /*SLLV*/
					 (sft_sel == 3) ? (A >> B[10:6]) : /*SRL*/
					 (sft_sel == 2) ? (B >> A[4:0])  : /*SRLV*/
					 (sft_sel == 1) ? $signed($signed(A) >>> B[10:6]) : /*SRA*/
					  $signed($signed(B) >>> A[4:0]);  /*SRAV*/

	assign CMP_A = $signed(A) < $signed(B) ? 1 : 0; /*SLT or SLTI*/
	assign CMP_B = A < B ? 1 : 0; /*SLTIU, SLTU*/
	
	assign cmp_out = (cmp_sel == 1) ? CMP_B : CMP_A;

	assign ALUout = (ALUctr == `AND) ? (A & B) :
					(ALUctr == `OR)  ? (A | B) :
					(ALUctr == `ADD) ? (A + B) :
					(ALUctr == `SUB) ? (A - B) :
					(ALUctr == `XOR) ? (A ^ B) : 
					(ALUctr == `CMP) ? cmp_out :
					(ALUctr == `SFT) ? sft_out : 
					(ALUctr == `NOR) ? (~(A | B)) : 0;
endmodule
