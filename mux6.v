`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:20:09 12/11/2017 
// Design Name: 
// Module Name:    mux6 
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
module mux6 #(parameter WIDTH = 32)(
	input [WIDTH - 1:0] d0, d1, d2, d3, d4, d5, //d4 and d5 is PC4_W and PC4_M
	input [2:0] sel,
	output [WIDTH - 1:0] out
    );

	assign out = (sel == 5) ? (d5 + 8): 
				 (sel == 4) ? d4: 
				 (sel == 3) ? d3 : 
				 (sel == 2) ? (d2 + 8) : 
				 (sel == 1) ? d1 : d0;

endmodule
