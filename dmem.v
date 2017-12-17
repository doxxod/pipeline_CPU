`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:26:32 12/04/2017 
// Design Name: 
// Module Name:    dmem 
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
module dmem(
    input clk, reset,
	input [1:0] store, load,
    input MemWr,
    input [31:0] ALUout,
	input [31:0] PC,
    input [31:0] MemData,
    output [31:0] ReadData
    );
	 
	reg [31:0] RAM[1023:0];
	reg [31:0] out;
	
	integer i;
	
	always @(posedge clk) begin
		if(reset) begin
			for(i = 0; i <= 1023; i = i + 1) begin
				RAM[i] <= 0;
			end
		end
		else if(MemWr) begin
			case(store)
				2'b00: RAM[ALUout[11:2]] = MemData;
				2'b01: begin
					case(ALUout[1])
						0: RAM[ALUout[11:2]][15:0] = MemData[15:0];
						1: RAM[ALUout[11:2]][31:16] = MemData[15:0];
						default: RAM[ALUout[11:2]] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
					endcase
					end
				2'b10: begin
					case(ALUout[1:0])
						2'b00: RAM[ALUout[11:2]][7:0] = MemData[7:0];
						2'b01: RAM[ALUout[11:2]][15:8] = MemData[7:0];
						2'b10: RAM[ALUout[11:2]][23:16] = MemData[7:0];
						2'b11: RAM[ALUout[11:2]][31:24] = MemData[7:0];
						default: RAM[ALUout[11:2]] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
					endcase
					end
				default: RAM[ALUout[11:2]] = 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
			endcase
		 $display("%d@%h: *%h <= %h", $time, PC, ALUout, RAM[ALUout[11:2]]);
		end
	end
	
	always @* begin
		case(load)
			2'b00: out <= RAM[ALUout[11:2]];
			2'b01: begin
				case(ALUout[1])
					0: out <= {{16{RAM[ALUout[11:2]][15]}}, RAM[ALUout[11:2]][15:0]};
					1: out <= {{16{RAM[ALUout[11:2]][31]}}, RAM[ALUout[11:2]][31:16]};
					default: out <= 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
					endcase
				end
			2'b10: begin
				case(ALUout[1:0])
					2'b00: out <= {{24{RAM[ALUout[11:2]][7]}}, RAM[ALUout[11:2]][7:0]};
					2'b01: out <= {{24{RAM[ALUout[11:2]][15]}}, RAM[ALUout[11:2]][15:8]};
					2'b10: out <= {{24{RAM[ALUout[11:2]][23]}}, RAM[ALUout[11:2]][23:16]};
					2'b11: out <= {{24{RAM[ALUout[11:2]][31]}}, RAM[ALUout[11:2]][31:24]};
					default: out <= 32'bxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx;
				endcase
			end
		endcase
	end
			
	assign ReadData = out;
endmodule
