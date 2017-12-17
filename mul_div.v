`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:00:28 12/17/2017 
// Design Name: 
// Module Name:    mul_div 
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
`define MUL  4'b1000
`define MULU 4'b1001
`define DIV  4'b1010
`define DIVU 4'b1011

module mul_div(
	input [31:0] A, B,
	input [3:0] ALUctr,
	output [31:0] ALUout, 
	input H_L_sel,
	input [2:0] busy,
	input clk, reset
    );

	reg [31:0] hi, lo;
	reg [2:0] b;
	reg [63:0] out;
	assign busy = b;
	assign ALUout = (H_L_sel == 1) ? hi : lo;
	
	always @(posedge clk) begin
		if(reset) begin
			hi = 0;
			lo = 0;
			b = 0;
		end
		else 
			if(busy == 0) begin
				if(ALUctr == `MUL) begin
					out = $signed($signed(A) * $signed(B));
					b = 5;
					hi = out[63:32];
					lo = out[31:0];
				end
				else if(ALUctr == `MULU) begin
					out = A * B;
					b = 5;
					hi = out[63:32];
					lo = out[31:0];
				end
				else if(ALUctr == `DIV) begin
					lo = $signed($signed(A) / $signed(B));
					hi = $signed($signed(A) % $signed(B));
					b = 10;
				end
				else if(ALUctr == `DIVU) begin
					lo = A / B;
					hi = A % B;
					b = 10;
				end
			end
			else if(b >= 1) begin 
				b = b - 1;
			end
		end


endmodule
