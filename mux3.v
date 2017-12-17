`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:22:48 12/04/2017 
// Design Name: 
// Module Name:    mux3 
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
module mux3 #(parameter WIDTH = 8)(
	input [WIDTH - 1:0] d0,
    input [WIDTH - 1:0] d1,
    input [WIDTH - 1:0] d2,
    input [1:0] sel,
    output [WIDTH - 1:0] out
    );
	 
	assign  out = sel == 2'b00 ? d0 : sel == 2'b01 ?  d1 : d2;

endmodule

