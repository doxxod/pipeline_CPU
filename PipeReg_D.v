`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:23:18 12/04/2017 
// Design Name: 
// Module Name:    PipeReg_D 
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
module PipeReg_D #(parameter WIDTH = 32)(
	input [WIDTH - 1:0] a,
	output [WIDTH - 1:0] b,
	input clk, reset, stall_data,
	input [2:0] busy
    );
	 
	reg [WIDTH - 1:0] out;
	initial out = 0;
	assign b = out;
	
	always @(posedge clk) begin
		if(reset) out <= 0;
		//else if(stall_B) out <= 0;
		else if(stall_data == 0 && busy == 0) begin
				out <= a;
		end
	end

endmodule
