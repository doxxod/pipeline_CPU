`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company:        BUAA
// Engineer:       JinZe
// 
// Create Date:    11:47:32 12/04/2017 
// Design Name: 
// Module Name:    datapath 
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
`define rs 25:21
`define rt 20:16
`define rd 15:11
`define imm16 15:0
`define imm26 25:0

module datapath(
		input clk, reset,
		input [2:0] F_CMP_D1_D_sel, F_CMP_D2_D_sel, F_ALUA_E_sel, F_ALUB_E_sel, 
		input stall_data,
		output Wr_M, Wr_W,
		output [4:0] A1_d, A2_d, A1_e, A2_e, A3_e, A3_m, A3_w,
		output [31:0] IR_D	
    );
	 
	//------------------------------------------------------------
	wire [31:0] instruction;
	wire [31:0] PC, PCplus4, NPC, NPC0, NPC1, to_NPC1;
	wire [31:0] signimmsh, PCbranch;
	//------------------------------------------------------------
	wire [31:0] NPC_D, PC4_D, PC_D;
	wire [31:0] RD1, RD2;
	wire [4:0] A1, A2;
	wire [31:0] signimm, unsignimm, immzero, EXTout;
	wire [31:0] D1, D2;
	wire zero;
	//------------------------------------------------------------
	wire [31:0] V1_E, V2_E, E32_E, PC4_E, IR_E, ALUout_1, ALUout_2, ALUout;
	wire [4:0] A1_E, A2_E, to_A3_E, A3;
	wire [31:0] A, to_B, B;
	wire zero_E;
	wire [2:0] busy;
	wire [3:0] ALUctr;
	//------------------------------------------------------------
	wire [31:0] V2_M, AO_M, PC4_M, IR_M;
	wire [4:0] A3_M;
	wire [31:0] DMout;
	wire zero_M;
	wire [2:0] busy_M;
	//------------------------------------------------------------
	wire [31:0] AO_W, PC4_W, RD_W, IR_W, Result_W;
	wire [4:0] A3_W;
	wire zero_W;
	wire [2:0] busy_W;
	//------------------------------------------------------------
	
	//-------------defination----------------------------------------------------------------
	wire [1:0] RegDst_W, PCSrc_W;
	wire [1:0] ALUSrc_W;
	wire ALUSrc1_W, ALUSrc2_W;
	wire [1:0] MemtoReg_W;
	wire RegWr_W, MemWr_W, nPC_sel_W;
	wire [1:0] EXTOp_W;
	wire [1:0] store_W, load_W;
	wire [2:0] cmp_sel_W;
	wire [2:0] sft_sel_W;
	wire MorD_W;
	wire H_L_sel_W;
	wire [2:0] ALUop_W;
	wire stall_J_W;
	wire [3:0] ALUctr_W;

	wire [1:0] RegDst_D, PCSrc_D;
	wire [1:0] ALUSrc_D;
	wire ALUSrc1_D, ALUSrc2_D;
	wire [1:0] MemtoReg_D;
	wire RegWr_D, MemWr_D, nPC_sel_D;
	wire [1:0] EXTOp_D;
	wire [1:0] store_D, load_D;
	wire [2:0] cmp_sel_D;
	wire [2:0] sft_sel_D;
	wire MorD_D;
	wire H_L_sel_D;
	wire [2:0] ALUop_D;
	wire stall_J_D;
	wire [3:0] ALUctr_D;
	
	wire [1:0] RegDst_E, PCSrc_E;
	wire [1:0] ALUSrc_E;
	wire ALUSrc1_E, ALUSrc2_E;
	wire [1:0] MemtoReg_E;
	wire RegWr_E, MemWr_E, nPC_sel_E;
	wire [1:0] EXTOp_E;
	wire [1:0] store_E, load_E;
	wire [2:0] cmp_sel_E;
	wire [2:0] sft_sel_E;
	wire MorD_E;
	wire H_L_sel_E;
	wire [2:0] ALUop_E;
	wire stall_J_E;
	wire [3:0] ALUctr_E;

	wire [1:0] RegDst_M, PCSrc_M;
	wire [1:0] ALUSrc_M;
	wire ALUSrc1_M, ALUSrc2_M;
	wire [1:0] MemtoReg_M;
	wire RegWr_M, MemWr_M, nPC_sel_M;
	wire [1:0] EXTOp_M;
	wire [1:0] store_M, load_M;
	wire [2:0] cmp_sel_M;
	wire [2:0] sft_sel_M;
	wire MorD_M;
	wire H_L_sel_M;
	wire [2:0] ALUop_M;
	wire stall_J_M;
	wire [3:0] ALUctr_M;

	//--------------------------------------------------------------------------------------
	assign instr = instruction;
	
	flopr #(32) PCreg(clk, reset, NPC, stall_data, busy, PC);
	adder       PCadd1(PC, 32'b100, PCplus4);
	sl2         immsh(signimm, signimmsh);
	adder       PCadd2(PC, signimmsh, PCbranch);
	mux2 #(32)  getNPC0(PCplus4, PCbranch, selNPC0, NPC0);
	mux3 #(32)  getNPC(NPC0, NPC1, D1, PCSrc_D, NPC);
	imem        im(reset, PC, instruction);

	//D pipeline reg-----------------------------------------
	PipeReg_D #(32) PIPE_PC_D(PC, PC_D, clk, reset, stall_data, busy);
	PipeReg_D #(32) PIPE_IR_D(instruction, IR_D, clk, reset, stall_data, busy);
	PipeReg_D #(32) PIRP_NPC_D(PCplus4, NPC_D, clk, reset, stall_data, busy);
	
	//D function
	//------------------------NPC----------------------------
	assign NPC1 = {NPC_D[31:28], IR_D[`imm26], 2'b00};
	//------------------------GRF----------------------------
	mux2 #(5)  M_A1_D(IR_D[`rs], IR_D[`rt], ALUSrc1_D, A1);
	mux2 #(5)  M_A2_D(IR_D[`rt], IR_D[`rs], ALUSrc2_D, A2);
	grf        GRF(clk, reset, Wr_W, Result_W, A1, A2, A3_W, PC4_W, RD1, RD2, stall_J_W, busy_W);
	//------------------------EXT----------------------------
	signext    se(IR_D[`imm16], signimm);
	unsignext  unse(IR_D[`imm16], unsignimm);
	extzero    unsezero(IR_D[`imm16], immzero);
	mux3 #(32) M_EXT_D(unsignimm, signimm, immzero, EXTOp_D, EXTout);
	//------------------------CMP----------------------------
	mux6 #(32) MF_CMP_D1(RD1, RD_W, PC4_W, AO_W, AO_M, PC4_M, F_CMP_D1_D_sel, D1);
	mux6 #(32) MF_CMP_D2(RD2, RD_W, PC4_W, AO_W, AO_M, PC4_M, F_CMP_D2_D_sel, D2);
	cmp        CMP(D1, D2, cmp_sel_D, zero);
	assign selNPC0 = nPC_sel_D & zero;
	assign stall_B = nPC_sel_D & zero;
	assign A1_d = A1;
	assign A2_d = A2;
	//-------------------------------------------------------

	//E pipeline reg-----------------------------------------
	PipeReg_E #(1)  PIPE_ZERO_E(zero, zero_E, clk, stall_data, busy);
	PipeReg_E #(32) PIPE_IR_E(IR_D, IR_E, clk, stall_data, busy);
	PipeReg_E #(32) PIPE_V1_E(D1, V1_E, clk, stall_data, busy);
	PipeReg_E #(32) PIPE_V2_E(D2, V2_E, clk, stall_data, busy);
	PipeReg_E #(5)  PIPE_A1_E(A1_d, A1_E, clk, stall_data, busy);
	PipeReg_E #(5)  PIPE_A2_E(A2_d, A2_E, clk, stall_data, busy);
	PipeReg_E #(5)  PIPE_A3_E(IR_D[`rd], to_A3_E, clk, stall_data, busy); // it is the a3
	PipeReg_E #(32) PIPE_E32_E(EXTout, E32_E, clk, stall_data, busy);
	PipeReg_P #(32) PIPE_PC4_E(PC_D, PC4_E, clk, stall_data, busy);

	//E function
	mux3 #(5)  M_A3_E(A2_E, to_A3_E, 5'h1f, RegDst_E, A3);
	mux6 #(32) MF_ALUA_E(V1_E, RD_W, PC4_W, AO_W, AO_M, PC4_M, F_ALUA_E_sel, A);
	mux6 #(32) MF_ALUB_E(V2_E, RD_W, PC4_W, AO_W, AO_M, PC4_M, F_ALUB_E_sel, to_B);
	mux3 #(32) M_ALUB_E(to_B, E32_E, 0, ALUSrc_E, B);
	alu ALU(A, B, cmp_sel_E, sft_sel_E, ALUctr_E, ALUout_1);
	mul_div    MUL_DIV(A, B, ALUctr, ALUout_2, H_L_sel_E, busy, clk, reset);
	assign ALUctr = busy ? 0 : ALUctr_E;
	assign ALUout = (MorD_E == 1) ? ALUout_2 : ALUout_1;
	assign A1_e = A1_E;
	assign A2_e = A2_E;
	assign A3_e = A3;
	//-------------------------------------------------------

	//M pipeline reg-----------------------------------------
	PipeReg #(1)  PIPE_ZERO_M(zero_E, zero_M, clk);
	PipeReg #(32) PIPE_IR_M(IR_E, IR_M, clk);
	PipeReg #(32) PIPE_V2_M(to_B, V2_M, clk);
	PipeReg #(32) PIPE_AO_M(ALUout, AO_M, clk);
	PipeReg #(5)  PIPE_A3_M(A3, A3_M, clk);
	PipeReg #(32) PIPE_PC4_M(PC4_E, PC4_M, clk);
	PipeReg #(3)  PIPE_BUSY_M(busy, busy_M, clk);

	//M function
	dmem dm(clk, reset, store_M, load_M, MemWr_M, AO_M, PC4_M, V2_M, DMout);
	assign A3_m = A3_M;
	//-------------------------------------------------------

	//W pipeline reg-----------------------------------------
	PipeReg #(1)  PIPE_ZERO_W(zero_M, zero_W, clk);
	PipeReg #(32) PIPE_IR_W(IR_M, IR_W, clk);
	PipeReg #(5)  PIPE_A3_W(A3_M, A3_W, clk);
	PipeReg #(32) PIPE_AO_W(AO_M, AO_W, clk);
	PipeReg #(32) PIPE_RD_W(DMout, RD_W, clk);
	PipeReg #(32) PIPE_PC4_W(PC4_M, PC4_W, clk);
	PipeReg #(3)  PIPE_BUSY_W(busy_M, busy_W, clk);

	//W function
	//-------------------------------------------------------
	mux3 #(32) M_Result_W(AO_W, RD_W, PC4_W, MemtoReg_W, Result_W);
	assign A3_w = A3_W;
	//-------------------------------------------------------

	assign Wr_M = RegWr_M;
	assign Wr_W = RegWr_W;

	//---------------controll signal----------------------------------------------------------
	maindec md_W(IR_W[31:26], IR_W[5:0], IR_W[20:16], zero_W, RegDst_W, PCSrc_W, ALUSrc_W, ALUSrc1_W, ALUSrc2_W, MemtoReg_W, RegWr_W, MemWr_W, nPC_sel_W, EXTOp_W, store_W, load_W, cmp_sel_W, sft_sel_W, MorD_W, H_L_sel_M,  ALUop_W, stall_J_W);
	aludec  ad_W(IR_W[5:0], ALUop_W, ALUctr_W);
	
	maindec md_D(IR_D[31:26], IR_D[5:0], IR_D[20:16], zero_D, RegDst_D, PCSrc_D, ALUSrc_D, ALUSrc1_D, ALUSrc2_D, MemtoReg_D, RegWr_D, MemWr_D, nPC_sel_D, EXTOp_D, store_D, load_D, cmp_sel_D, sft_sel_D, MorD_D, H_L_sel_D, ALUop_D, stall_J_D);
	aludec  ad_D(IR_D[5:0], ALUop_D, ALUctr_D);

	maindec md_E(IR_E[31:26], IR_E[5:0], IR_E[20:16], zero_E, RegDst_E, PCSrc_E, ALUSrc_E, ALUSrc1_E, ALUSrc2_E, MemtoReg_E, RegWr_E, MemWr_E, nPC_sel_E, EXTOp_E, store_E, load_E, cmp_sel_E, sft_sel_E, MorD_E, H_L_sel_E, ALUop_E, stall_J_E);
	aludec  ad_E(IR_E[5:0], ALUop_E, ALUctr_E);

	maindec md_M(IR_M[31:26], IR_M[5:0], IR_M[20:16], zero_M, RegDst_M, PCSrc_M, ALUSrc_M, ALUSrc1_M, ALUSrc2_M, MemtoReg_M, RegWr_M, MemWr_M, nPC_sel_M, EXTOp_M, store_M, load_M, cmp_sel_M, sft_sel_M,  MorD_M, H_L_sel_M, ALUop_M, stall_J_M);
	aludec  ad_M(IR_M[5:0], ALUop_M, ALUctr_M);
	//-----------------------------------------------------------------------------------------

endmodule
