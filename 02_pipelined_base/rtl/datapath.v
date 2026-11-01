`timescale 1ns / 100ps 
// Datapath do sistema RISC-V completo
module datapath( 
	input clk, reset,
	input ALUSrcD, RegWriteD, MemWriteD, JumpD, BranchD, ResultSrcD,
	input [1:0] ImmSrcD, 
	input [2:0] ALUControlD,
	output signed [31:0] InstrD
); 
	wire [31:0] PCF, PCD, PCE;
	wire [31:0] InstrF; // Instrução lida da memória no estágio IF
	wire [31:0] ImmExtD, RD1D, RD2D;
	wire [4:0] RdD, RdE, RdM, RdW;
	wire flush_INST, flush_CTRL_ID, ZeroE;
	//Sinais de controle para os estágios EX, MEM e WB (passados pelo pipeline)
	
	wire PCSrcE, ALUSrcE, RegWriteE, MemWriteE, JumpE, BranchE, ResultSrcE;
	wire [2:0] ALUControlE;
	wire signed [31:0] InstrE;
	wire [31:0] ImmExtE, RD1E, RD2E, SrcA, SrcB, ALUResultE, PCTargetE;

	wire RegWriteM, MemWriteM, ResultSrcM;
	wire [31:0] ALUResultM, WriteDataM, ReadDataM;

	wire RegWriteW, MemWriteW;
	wire [31:0] ResultW, ALUResultW, ReadDataW;

	assign RdD = InstrD[11:7]; // Campo de destino (wa3) para o banco de registradores, vindo da instrução decodificada
	assign RdM = RdE; // O campo de destino (wa3) para o estágio MEM vem do estágio EX
	assign SrcA = RD1E; 
	assign RegWriteM = RegWriteE;
	assign MemWriteM = MemWriteE;
	assign ALUResultM = ALUResultE;
	assign WriteDataM = RD2E; 
	assign ResultSrcM = ResultSrcE;

	//Instruction Fetch (IF)
	PC PC_inst (   	// Program Counter
		.clk(clk), .reset(reset), .zeroFlagE(ZeroE), .branchFlagE(BranchE), .PCTargetE(PCTargetE),
	  	.PC(PCF), .flushCTRL_ID(flush_CTRL_ID), .flush_INST(flush_INST)
	);

	
	instruction_memory InstrMemory ( 	// Instancia da memória de instruções
		.A(PCF),
		.RD(InstrF) 
	);
	
	if_id_reg IF_ID_inst (	// Registrador de pipeline IF/ID
		.clk(clk), .reset(reset), .flush_INST(flush_INST), .PCF(PCF),
		.InstrF(InstrF), .InstrD(InstrD), .PCD(PCD)
	);

	//Instruction Decode (ID)
	register_file Register_inst (	// Banco de registradores
		.clk(clk),
		.WE3(RegWriteW),
		.RA1(InstrD[19:15]),
		.RA2(InstrD[24:20]),
		.WA3(RdW),
		.WD3(ResultW),
		.RD1(RD1D),
		.RD2(RD2D),
		.reset(reset)
	);
 
	extend Extend_inst (	// Unidade de extensão de imediato
		.Instr(InstrD[31:7]),
		.ImmSrc(ImmSrcD),
		.ImmExt(ImmExtD)
	);
	
	id_ex_reg ID_EX_inst (	// Registrador de pipeline ID/EX
		.clk(clk), .reset(reset),
		.ALUSrcD(ALUSrcD), .RegWriteD(RegWriteD), .MemWriteD(MemWriteD), .JumpD(JumpD), .BranchD(BranchD),
		.ResultSrcD(ResultSrcD), .ALUControlD(ALUControlD), .RdD(RdD),
		.RD1D(RD1D), .RD2D(RD2D), .ImmExtD(ImmExtD), .PCD(PCD),
		.flush_CTRL_ID(flush_CTRL_ID),
		.ALUSrcE(ALUSrcE), .RegWriteE(RegWriteE), .MemWriteE(MemWriteE), .JumpE(JumpE), .BranchE(BranchE),
		.ResultSrcE(ResultSrcE), .ALUControlE(ALUControlE), .RdE(RdE),.RD1E(RD1E), .RD2E(RD2E), .ImmExtE(ImmExtE), .PCE(PCE)
	);

	//Execute (EX)
   	mux ALU_mux (		// Mux da ALU
		.A(RD2E), 
		.B(ImmExtE), 
		.sel(ALUSrcE),
		.Y(SrcB)
	);

   	alu ALU_inst (		// Unidade Lógica e Aritmética
		.A(SrcA),
		.B(SrcB),
		.ALUControl(ALUControlE),
		.Zero(ZeroE),
		.Result(ALUResultE)
	);

	adder BranchAdder (	// Somador para calcular o endereço de desvio (PC + imediato)
		.A(PCE),
		.B({{2{ImmExtE[31]}}, ImmExtE[31:2]}),
		.Result(PCTargetE),
		.Cout(), // Carry-out não utilizado
		.Cin(1'b0) // Carry-in é 0 para somar o valor do mux ao PC	
	);


	//Memory (MEM)
	data_memory DataMemory (	// Instancia da memória de dados
		.clk(clk), 
		.WE(MemWriteM),
		.A(ALUResultM), 
		.WD(WriteDataM),
		.RD(ReadDataM) 
	);

	//Write Back (WB)
   	mux Result_mux (	// Mux do resultado
		.A(ALUResultW),
		.B (ReadDataW),
		.sel(ResultSrcW),
		.Y(ResultW)
	);

	mem_wb_reg MEM_WB_inst (	// Registrador de pipeline MEM/WB
		.clk(clk), .reset(reset),
		.RegWriteM(RegWriteM), 
		.ResultSrcM(ResultSrcM), .AluResultM(ALUResultM), .ReadDataM(ReadDataM),
		.RdM(RdM),
		.RegWriteW(RegWriteW), 
		.ResultSrcW(ResultSrcW), .AluResultW(ALUResultW), .ReadDataW(ReadDataW),
		.RdW(RdW)
	);
endmodule 