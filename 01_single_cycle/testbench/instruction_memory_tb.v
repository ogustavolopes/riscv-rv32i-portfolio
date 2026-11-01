module instruction_memory_tb();
  reg [31:0] A;
  wire [31:0] RD;

  instruction_memory DUT (
    .A(A),
    .RD(RD)
  );

  initial begin
    A = 32'h00000000;
    #10;
    if (RD !== 32'hXXXXXXXX) $display("Erro: Instrução incorreta para A = 0x00000000.");

    A = 32'h00000004;
    #10;
    if (RD !== 32'hXXXXXXXX) $display("Erro: Instrução incorreta para A = 0x00000004.");

    A = 32'h00000008;
    #10;
    if (RD !== 32'hXXXXXXXX) $display("Erro: Instrução incorreta para A = 0x00000008.");

    A = 32'h0000000C;
    #10;
    if (RD !== 32'hXXXXXXXX) $display("Erro: Instrução incorreta para A = 0x0000000C.");

    $finish;
  end
endmodule