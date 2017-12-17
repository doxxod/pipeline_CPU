`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:30:49 12/13/2017 
// Design Name: 
// Module Name:    PipeReg_P 
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
module PipeReg_P #(parameter WIDTH = 32)(
	input [WIDTH - 1:0] a,
	output [WIDTH - 1:0] b,
	input clk, stall_data,
	input [2:0] busy
    );
	
	reg [WIDTH - 1:0] out;
	initial out = 0;
	assign b = out;
	
	always @(posedge clk) begin
		if(stall_data) begin
			//
		end
		else if(busy == 0) begin
			out <= a;
		end
	end
	
endmodule
