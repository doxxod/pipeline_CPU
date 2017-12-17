`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:34:29 12/05/2017 
// Design Name: 
// Module Name:    A_Tdec 
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
//source
`define ALU 2'b01
`define DM  2'b10
`define PC  2'b11
`define NW  2'b00

//opcode
`define RTYPE 6'b000000
`define ADDI  6'b001000
`define ANDI  6'b001100
`define XORI  6'b001110
`define ADDIU 6'b001001
`define SLTI  6'b001010
`define SLTIU 6'b001011
`define LUI   6'b001111
`define ORI   6'b001101
`define LW    6'b100011
`define SW    6'b101011
`define BEQ   6'b000100
`define JAL   6'b000011
`define J     6'b000010
`define SB    6'b101000
`define LH    6'b100001
`define SH    6'b101001
`define LB    6'b100000
`define BZ    6'b000001
`define BGTZ  6'b000111
`define BLEZ  6'b000110
`define BNE   6'b000101

//funct
`define ADDU_F 6'b100001
`define ADD_F  6'b100000
`define SUB_F  6'b100010
`define AND_F  6'b100100 
`define SUBU_F 6'b100011
`define ADD_F  6'b100000
`define SUB_F  6'b100010
`define SLT_F  6'b101010
`define SLL_F  6'b000000
`define JR_F   6'b001000
`define JALR_F 6'b001001
`define SRAV_F 6'b000111
`define MOVZ_F 6'b001010
`define SLLV_F 6'b000100
`define SRLV_F 6'b000110
`define SRL_F  6'b000010
`define SRA_F  6'b000011

//B_funct 
`define BGEZ_F    5'b00001
`define BGEZAL_F  5'b10001
`define BGEZALL_F 5'b10011
`define BGEZL_F   5'b00011
`define BLTZ_F    5'b00000
`define BLTZAL_F  5'b10000 
`define BLTZALL_F 5'b10010 
`define BGTZL_F   5'b00010 

module A_Tdec(
	input clk, reset,
	input [5:0] opcode,
	input [5:0] funct,
	input [4:0] B_funct,
	output Tuse_rs0, Tuse_rs1, Tuse_rt0, Tuse_rt1,	
	output [1:0] res_e, res_m, res_w
	);

	wire [1:0] RES;

	//res_* means that the current level needs * level's result is from where; 
	//this opcode is needer;

	//------------------analysis it at level D------------------
	
	//--------------Tuse decode begin---------------------------
	assign Tuse_rs0 = ((opcode == `BEQ) + (opcode == `BZ) + (opcode == `BGTZ) + (opcode == `BLEZ) +
					  (opcode == `BNE) + (opcode == `RTYPE) * ((funct == `JR_F) + (funct == `JALR_F))) ? 1 : 0;

	assign Tuse_rs1 = ((opcode == `RTYPE) * ((funct != `JR_F) & (funct != `JALR_F)) + (opcode == `LUI) + (opcode == `ORI) + (opcode == `ANDI) + (opcode == `XORI) + (opcode == `ADDI) +
					    (opcode == `ADDIU) + (opcode == `SLTI) + (opcode == `SLTIU) + (opcode == `LW) + (opcode == `SW) + (opcode == `SB) + (opcode == `LB) + (opcode == `SH) + (opcode == `LH)) ? 1 : 0;

	assign Tuse_rt0 = ((opcode == `BEQ) + (opcode == `BNE) + (opcode == `RTYPE) * (funct == `MOVZ_F)) ? 1 : 0;
		
	assign Tuse_rt1 = ((opcode == `RTYPE) * (funct != `MOVZ_F) + (opcode == `SW) + (opcode == `SB) + (opcode == `SH)) ? 1 : 0;
	//--------------Tuse decode end-----------------------------

	//--------------Tnew decode begin--------------------------- 
	assign RES = ((opcode == `JAL) + (opcode == `RTYPE) * (funct == `JALR_F) + (opcode == `BZ) * ((B_funct == `BGEZAL_F) + (B_funct == `BLTZAL_F))) ? `PC :
				 ((opcode == `RTYPE) * (funct != `JALR_F) + (opcode == `LUI) + (opcode == `ANDI) + (opcode == `ORI) + (opcode == `ADDI) + 
				 (opcode == `ADDIU) + (opcode == `SLTI) + (opcode == `XORI) + (opcode == `SLTIU)) ? `ALU :
				 ((opcode == `LW) + (opcode == `LH) + (opcode == `LB)) ? `DM : `NW;
	//--------------Tnew decode end-----------------------------
	
	//-------------------decode end-----------------------------

	//------------------pipeline reg----------------------------
	//------level E------------
	PipeReg_R #(2) PIRE_RES_E(RES, res_e, clk);
	//-------------------------

	//------level M------------
	PipeReg_R #(2) PIPE_RES_M(res_e, res_m, clk);
	//-------------------------

	//------level W------------
	PipeReg_R #(2) PIPE_RES_W(res_m, res_w, clk);
	//-------------------------
	//-----------------------------------------------------------
endmodule

