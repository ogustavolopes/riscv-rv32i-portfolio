`timescale 1ns / 100ps  
// Unidade central de processamento (CPU)
module cpu ( 
	input clk,reset		 //Sinal de Write Enable da memória
);
   	wire [31:0] PC, InstrD;
	wire ALUSrcD, RegWriteD, ZeroE, PCSrcD, MemWriteD, JumpD, BranchD, ResultSrcD;
	wire [1:0] ImmSrcD;
	wire [2:0] ALUControlD;

   	control Control(		// Instancia da unidade de controle
	.op(InstrD[6:0]), .funct3(InstrD[14:12]), .funct7b5(InstrD[30]), .ResultSrcD(ResultSrcD),			
	.MemWriteD(MemWriteD), .ALUSrcD(ALUSrcD), .RegWriteD(RegWriteD), .BranchD(BranchD),
	.ImmSrcD(ImmSrcD), .ALUControlD(ALUControlD) 
	);
 
	datapath Datapath(		//Instancia do datapath 
	.clk(clk), .reset(reset), .ALUSrcD(ALUSrcD), .RegWriteD(RegWriteD), .MemWriteD(MemWriteD), .JumpD(JumpD), .BranchD(BranchD),
	.ImmSrcD(ImmSrcD), .ResultSrcD(ResultSrcD),	.ALUControlD(ALUControlD),	.InstrD(InstrD)
	);	
	

endmodule