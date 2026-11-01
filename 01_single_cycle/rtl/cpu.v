module cpu (
	input clk,reset,
	output [31:0] WriteData, DataAddr,
	output MemWrite
);
   	wire [31:0] PC, Instr, ReadData;

   	SingleCycleCore core (
		.clk(clk),
		.reset(reset),
		.Instr(Instr),
		.ReadData(ReadData),
		.PC(PC),
		.MemWrite(MemWrite),
		.ALUResult(DataAddr),
		.WriteData(WriteData) 
	);

	instruction_memory InstrMemory ( 
		.A(PC),
		.RD(Instr) 
	);

	data_memory DataMemory (
		.clk(clk), 
		.WE(MemWrite),
		.A(DataAddr), 
		.WD(WriteData),
		.RD(ReadData) 
	);
endmodule