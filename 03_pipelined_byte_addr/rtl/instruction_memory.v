`timescale 1ns / 100ps
// Memória de instruções de 64KB
module instruction_memory(
	input [31:0] A,		// Endereço da instrução
	output [31:0] RD	// Instrução lida
);
	reg [31:0] I_MEM_BLOCK[65535:0];  // Bloco de memória de instruções (64KB)

   	initial begin
		$readmemh("C:/CiDigital/SD212/RISCVpipelinedMemByte/testMemByte.txt",I_MEM_BLOCK);
		// Endereço onde esta o arquivos de instruções
	end

   	assign RD = I_MEM_BLOCK[A];  // Leitura da instrução 
endmodule
