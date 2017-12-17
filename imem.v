`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:22:58 12/04/2017 
// Design Name: 
// Module Name:    imem 
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
module imem(
	 input reset,
    input [31:0] PC,
    output [31:0] instr
    );

	reg [31:0] ROM[1023:0];

	initial 
		$readmemh("code.txt", ROM);
		
	assign instr = ROM[PC[11:2]];
endmodule
