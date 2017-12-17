`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:23:28 12/04/2017 
// Design Name: 
// Module Name:    grf 
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
module grf(
    input clk, reset,
    input RegWr,
    input [31:0] res,    //Wdata
    input [4:0] A1,
    input [4:0] A2,
    input [4:0] A3,      //Waddr
	 input [31:0] WPC,    //WPC
    output [31:0] RD1,   
    output [31:0] RD2,
	 input  stall_J_W,
	 input [2:0] busy
    );
	 
	reg [31:0] rf[31:0];
	reg [31:0] RES;
	integer i;
	
	always @(posedge clk) begin
		if(reset) begin
			for(i = 0; i <= 31; i = i + 1) begin
				rf[i] <= 0;
			end
		end
		else if(RegWr && A3 != 0 && busy == 0) begin
			if(stall_J_W) RES = res + 8;
			else RES = res;
			$display("%d@%h: $%d <= %h", $time, WPC, A3, RES);		
			rf[A3] <= RES;	
		end
	end
		
	assign RD1 = (A1 != 0) ? rf[A1] : 0;
	assign RD2 = (A2 != 0) ? rf[A2] : 0;

endmodule
