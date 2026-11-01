`timescale 1ns / 100ps 
// Program Counter (PC)
module PC (	
	input wire clk,reset, zeroFlagE, branchFlagE, // Sinal de controle para o mux do próximo PC
	input wire [31:0] PCTargetE,   // Valor do PC de destino para o próximo PC (calculado no estágio EX)
	output wire [31:0] PC,     // Valor atual do PC
	output wire flushCTRL_ID, flush_INST
);
	reg [31:0] PCReg;
	wire [31:0] PCNext, PCPlus1;
	wire PCSrc; // Sinal de controle para o mux do próximo PC
	wire [31:0] branchOffset; // Valor do PC + 4 para o próximo PC

	always@(posedge clk or posedge reset) begin
		if (reset) PCReg <= 32'h0000;  // Endereço inicial do PC
		else PCReg <= PCNext;          // Se reset = 0 -> Atualiza o PC com o próximo valor
	end

	assign PC = PCReg;
	
	adder PCnext (	// Somador para calcular o próximo PC (PC + 4)
		.A(PCReg),
		.B(32'd1), 
		.Result(PCPlus1),
		.Cout(), // Carry-out não utilizado
		.Cin(1'b0) // Carry-in é 0 para somar o valor do mux ao PC	
	);

	mux PCadder_mux (	// Mux do próximo PC
		.A(PCPlus1), // PC + 1
		.B(PCTargetE), // PC de branch calculado no estágio EX
		.sel(PCSrc),
		.Y(PCNext)
	);


	assign PCSrc = (branchFlagE && zeroFlagE); // Se for um branch e o zero flag for 1, seleciona o endereço de desvio
	assign flushCTRL_ID = PCSrc; // Sinal para limpar o estágio de controle e instrução no ID
	assign flush_INST = flushCTRL_ID; // Sinal para limpar a instrução no estágio de IF (pode ser o mesmo sinal do controle)
	

endmodule