`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:20:57 12/04/2017 
// Design Name: 
// Module Name:    mux2 
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
module mux2 #(parameter WIDTH = 8)(
    input [WIDTH - 1:0] d0,
    input [WIDTH - 1:0] d1,
    input sel,
    output [WIDTH - 1:0] out
	 );

	 assign  out = sel ? d1 : d0;
endmodule
