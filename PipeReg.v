`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:25:33 12/04/2017 
// Design Name: 
// Module Name:    PipeReg 
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
module PipeReg #(parameter WIDTH = 32)(
	input [WIDTH - 1:0] a,
	output [WIDTH - 1:0] b,
	input clk
	);
	 
	reg [WIDTH -1:0] out;
	initial out = 0;
	assign b = out;
	 
	always @(posedge clk) begin
		out <= a;
	end
	
endmodule
