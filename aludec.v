`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    10:39:03 12/05/2017 
// Design Name: 
// Module Name:    aludec 
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
`define AND  4'b0000
`define OR   4'b0001
`define ADD  4'b0010
`define XOR  4'b0011
`define CMP  4'b0100
`define SFT  4'b0101
`define SUB  4'b0110
`define NOR  4'b0111
`define MUL  4'b1000
`define MULU 4'b1001
`define DIV  4'b1010
`define DIVU 4'b1011

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

`define MULT_F  6'b011000
`define MULTU_F 6'b011001 
`define DIV_F   6'b011010
`define DIVU_F  6'b011011 

module aludec(
	 input [5:0] funct,
    input [2:0] ALUop,
    output [3:0] ALUctr
    );
	
   reg [3:0] ctr;
	assign ALUctr = ctr;
	
	always @*
		case(ALUop)
		4'b0000: ctr <= `ADD;
		4'b0001: ctr <= `SUB;
		4'b0011: ctr <= `OR;
		4'b0100: ctr <= `XOR;
		4'b0101: ctr <= `CMP;
		4'b0110: ctr <= `AND;
		default: case(funct)
			`OR_F  : ctr <= `OR;
			`NOR_F : ctr <= `NOR;
			`AND_F : ctr <= `AND;
			`XOR_F : ctr <= `XOR;
			`ADDU_F: ctr <= `ADD; 
			`ADD_F : ctr <= `ADD;
			`SUBU_F: ctr <= `SUB;
			`SUB_F : ctr <= `SUB; 
			`SLL_F : ctr <= `SFT;
			`SRL_F : ctr <= `SFT;
			`SRA_F : ctr <= `SFT;
			`SLLV_F: ctr <= `SFT;
			`SRLV_F: ctr <= `SFT;
			`JR_F  : ctr <= `ADD; 
			`SLT_F : ctr <= `CMP;
			`SLTU_F: ctr <= `CMP; 
			`SRAV_F: ctr <= `SFT; 
			`MOVZ_F: ctr <= `ADD;
			`MULT_F: ctr <= `MUL;
			`DIV_F : ctr <= `DIV;
			`DIVU_F: ctr <= `DIVU;
			`MULTU_F: ctr<= `MULU;
			default:  ctr <= 4'bxxxx; 
		 endcase
	  endcase
	 
endmodule

 /*assign ALUctr = ((ALUop == 0) + (ALUop == 2) * ((funct == `ADDU_F) + (funct == `ADD_F) + (funct == `JR_F) + (funct == `MOVZ_F))) ? `ADD : 
	  				  ((ALUop == 1) + (ALUop == 2) * ((funct == `SUBU_F) + (funct == `SUB_F))) ? `SUB : 
	  				  ((ALUop == 3) + (ALUop == 2) * (funct == `OR_F)) ? `OR  :
	  				  ((ALUop == 4) + (ALUop == 2) * (funct == `XOR_F)) ? `XOR :
	  				  ((ALUop == 5) + (ALUop == 2) * ((funct == `SLT_F) + (funct == `SLTU_F))) ? `CMP :
	  				  ((ALUop == 2) + (ALUop == 2) * (funct == `NOR)) ? `NOR :
	  				  ((ALUop == 2) + (ALUop == 2) * ((funct == `SLL_F) + (funct == `SLLV_F) + (funct == `SRL_F) + (funct == `SRA_F) + (funct == `SRAV_F) + (funct == `SRLV_F))) ? `SFT : 0 ;*/

