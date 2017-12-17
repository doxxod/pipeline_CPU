`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:37:24 12/05/2017 
// Design Name: 
// Module Name:    maindec 
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

//opcode
`define RTYPE 6'b000000
`define ADDI  6'b001000
`define ADDIU 6'b001001
`define ANDI  6'b001100
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
`define XORI  6'b001110


//funct
`define ADDU_F 6'b100001
`define SUBU_F 6'b100011
`define ADD_F  6'b100000
`define AND_F  6'b100100
`define OR_F   6'b100101
`define XOR_F  6'b100110
`define SUB_F  6'b100010
`define SLT_F  6'b101010
`define SLTU_F 6'b101011
`define SLL_F  6'b000000
`define JR_F   6'b001000
`define JALR_F 6'b001001
`define SRAV_F 6'b000111
`define MOVZ_F 6'b001010
`define SLLV_F 6'b000100
`define SRLV_F 6'b000110
`define SRL_F  6'b000010
`define SRA_F  6'b000011
`define NOR_F  6'b100111

`define MULT_F 6'b011000
`define MULTU_F 6'b011001 
`define DIV_F  6'b011010
`define DIVU_F 6'b011011 
`define MFHI_F 6'b010000
`define MFLO_F 6'b010010
`define MTHI_F 6'b010001 
`define MTLO_F 6'b010011

//B_funct 
`define BGEZ_F    5'b00001
`define BGEZAL_F  5'b10001
`define BGEZALL_F 5'b10011
`define BGEZL_F   5'b00011
`define BLTZ_F    5'b00000
`define BLTZAL_F  5'b10000 
`define BLTZALL_F 5'b10010 
`define BGTZL_F   5'b00010 

module maindec(
	 input [5:0] opcode,
	 input [5:0] funct,
	 input [4:0] B_funct,    /////////
	 input  zero,
    output [1:0] RegDst,
    output [1:0] PCSrc,
    output [1:0] ALUSrc,
    output ALUSrc1,
    output ALUSrc2,
    output [1:0] MemtoReg,
    output RegWr,
    output MemWr,
    output nPC_sel,
    output [1:0] EXTOp,
	 output [1:0] store,
	 output [1:0] load,
	 output [2:0] cmp_sel,//////
	 output [2:0] sft_sel,
	 output MorD,
	 output H_L_sel,
	 output [2:0] ALUop,
    output stall_J
    );
	 
	assign RegDst   = (opcode == `RTYPE)  ? 1 :
					  ((opcode == `JAL) + (opcode == `BZ) * ((B_funct == `BGEZAL_F) + (B_funct == `BLTZAL_F))) ? 2 : 0;

	assign PCSrc    = (opcode == `J) + (opcode == `JAL) ? 1 :
				      ((opcode == `RTYPE) * ((funct == `JR_F) + (funct == `JALR_F))) ? 2 : 0;

	assign ALUSrc   = (opcode == `RTYPE) * ((funct == `SLL_F) + (funct == `SRA_F) + (funct == `SRL_F)) + 
					  (opcode == `SB) + (opcode == `LH) + (opcode == `ORI) + (opcode == `SLTI) + (opcode == `SLTIU) + 
					  (opcode == `LW) + (opcode == `SW) + (opcode == `LUI) + (opcode == `ANDI) + (opcode == `ADDI) + 
					  (opcode == `ADDIU) + (opcode == `LB) + (opcode == `SH) + (opcode == `XORI) ? 1 : 0;

	assign ALUSrc1  = (opcode == `RTYPE) * ((funct == `SLL_F) + (funct == `SRA_F) + (funct == `SRL_F) + (funct == `MOVZ_F)) ? 1 : 0;

	assign ALUSrc2  = (opcode == `RTYPE) * (funct == `MOVZ_F) ? 1 : 0;

	assign MemtoReg = (opcode == `RTYPE) * (funct == `JR_F) + (opcode == `LW) + (opcode == `LH) + (opcode == `LB) + (opcode == `SH)? 1 :
					  ((opcode ==`JAL) + (opcode == `RTYPE) * (funct == `JALR_F) + (opcode == `BZ) * ((B_funct == `BGEZAL_F) + (B_funct == `BLTZAL_F))) ? 2 : 0;

	assign RegWr    = ((opcode == `RTYPE) * ((funct != `MULT_F) & (funct != `MULTU_F) & (funct != `DIV_F) & (funct != `DIVU_F)) + (opcode == `ORI) + (opcode == `SLTI) + (opcode == `SLTIU) + (opcode == `LW) + (opcode == `LH) + (opcode == `LB) + (opcode == `LUI) + (opcode == `ANDI) + 
					  + (opcode == `XORI) + (opcode == `JAL) + (opcode == `ADDI) + (opcode == `ADDIU) + (opcode == `BZ) * ((B_funct == `BGEZAL_F) * zero & (B_funct == `BLTZAL_F) * zero)) ? 1 : 0;

	assign MemWr    = (opcode == `SW) + (opcode == `SB) + (opcode == `SH) ? 1 : 0;

	assign nPC_sel  = (opcode == `BEQ) + (opcode == `BZ) + (opcode == `BNE) + (opcode == `BLEZ) + (opcode == `BGTZ) ? 1 : 0;

	assign EXTOp    = (opcode == `SB) + (opcode == `LH) + (opcode == `LB) + (opcode == `SH) + (opcode == `LW) + (opcode == `SW) + (opcode == `ADDI) + (opcode == `ADDIU) + 
					  (opcode == `BEQ) + (opcode == `BZ) + (opcode == `BLEZ) + (opcode == `BGTZ) + (opcode == `BNE) + (opcode == `SLTI) + (opcode == `SLTIU) ? 1 : (opcode == `LUI) ? 2 : 0;

	assign store    =  opcode == `SB ? 2 : opcode == `SH ? 1 : 0;

	assign load     =  opcode == `LB ? 2 : opcode == `LH ? 1 : 0;

	assign cmp_sel  = (opcode == `BZ) * ((B_funct == `BLTZ_F) + (B_funct == `BLTZAL_F)) + (opcode == `SLTIU) + (opcode == `RTYPE) * (funct == `SLTU_F) ? 1 : 
					  (opcode == `BGTZ) ? 2 :
					  (opcode == `BLEZ) ? 3 :
					  (opcode == `BNE)  ? 4 : 
					  (opcode == `BEQ)  ? 5 :
					  ((opcode == `RTYPE) * (funct == `MOVZ_F)) ? 6 : 0;

	assign sft_sel  = (opcode == `RTYPE) * (funct == `SLL_F)  ? 5 :
					  (opcode == `RTYPE) * (funct == `SLLV_F) ? 4 :
					  (opcode == `RTYPE) * (funct == `SRL_F)  ? 3 :
					  (opcode == `RTYPE) * (funct == `SRLV_F) ? 2 :
					  (opcode == `RTYPE) * (funct == `SRA_F)  ? 1 : 0;

	assign MorD     = (opcode == `RTYPE) * ((funct == `MULT_F) + (funct == `MULTU_F) + (funct == `DIV_F) + (funct == `DIVU_F) + (funct == `MFLO_F) + (funct == `MFHI_F)) ? 1 : 0;

	assign H_L_sel  = (opcode == `RTYPE) * ((funct == `MTHI_F) + (funct == `MFHI_F) + (funct == `MFLO_F) + (funct == `MFHI_F)) ? 1 : 0;


	assign ALUop    = (opcode == `SLTI) + (opcode == `SLTIU) ? 5 :
					  (opcode == `XORI)  ? 4 :
					  (opcode == `RTYPE) ? 2 : 
					  (opcode == `ORI)   ? 3 :
					  (opcode == `ANDI)  ? 6 : 0;
	
	assign stall_J  = ((opcode == `RTYPE) * ((funct == `JR_F) + (funct == `JALR_F))+ (opcode == `J) + 
		   			  (opcode == `JAL) + (opcode == `BZ) * ((B_funct == `BGEZAL_F) + (B_funct == `BLTZAL_F))) ? 1 : 0;

endmodule

