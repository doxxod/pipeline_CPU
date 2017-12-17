`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:20:25 12/04/2017 
// Design Name: 
// Module Name:    flopr 
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
module flopr #(parameter WIDTH = 8)(
    input clk,
    input reset,
    input [WIDTH - 1:0] d,
	 input stall_data,
	 input [2:0] busy,
    output [WIDTH - 1:0] q
    );
	 
	reg [WIDTH - 1:0] Q;
	initial Q = 32'h00003000;
	assign q = Q;
	
	always @(posedge clk) begin
		if(reset) Q <= 32'h00003000;
		else if(stall_data == 0 && busy == 0) begin 
			Q <= d;
		end
	end
		
endmodule