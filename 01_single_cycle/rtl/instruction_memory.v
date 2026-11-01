module instruction_memory(
	input [31:0] A,
	output [31:0] RD
);
	reg [31:0] I_MEM_BLOCK[65535:0];

   	initial begin
		$readmemh("C:/CiDigital/SD132/trabalho_final_01/instructionsValidas.txt",I_MEM_BLOCK);
	end

   	assign RD = I_MEM_BLOCK[A[31:2] - 32'h400]; 
endmodule