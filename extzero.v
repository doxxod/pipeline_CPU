`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:23:59 12/04/2017 
// Design Name: 
// Module Name:    extzero 
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
module extzero(
    input [15:0] imm16,
    output [31:0] imm32
    );
	assign imm32 = {imm16, 16'b0000000000000000};

endmodule