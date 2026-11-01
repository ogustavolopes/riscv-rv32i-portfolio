`timescale 1ns / 100ps

module instruction_memory_tb();
  reg [31:0] A;
  wire [31:0] RD;

  instruction_memory DUT (
    .A(A),
    .RD(RD)
  );

  reg [31:0] expected_instr [0:3];
  integer i;

  initial begin
    expected_instr[0] = 32'hFFC4A303; // lw x6, -4(x9)
    expected_instr[1] = 32'h0064A423; // sw x6, 8(x9)
    expected_instr[2] = 32'h0062E233; // or x4, x5, x6
    expected_instr[3] = 32'hFE420AE3; // beq x4, x4, L7

    $display("\n Teste de Memoria de Instrucoes -- Baseado no Test0");

    for (i = 0; i < 4; i = i + 1) begin
        A = 32'h00001000 + (i * 4); 
        #10; 
         
        if (RD === expected_instr[i]) begin
            $display("Execução correta! Endereco: 0x%h | Lido: 0x%h | Esperado: 0x%h", A, RD, expected_instr[i]);
        end else begin
            $display("Execução falha! Endereco: 0x%h | Lido: 0x%h | Esperado: 0x%h", A, RD, expected_instr[i]);
        end
    end
    A = 32'h00000000;
    #10;
    $display("\nTeste Endereco Baixo (0x0): Saida = 0x%h (Esperado: xxxxxxxx)\n", RD);

    $finish;
  end
endmodule