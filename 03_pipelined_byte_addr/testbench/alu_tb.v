`timescale 1ns / 100ps
  
module alu_tb();
  reg [31:0] A, B;
  reg [2:0] ALUControl;
  wire Zero;
  wire [31:0] Result;

  alu DUT (
    .A(A),
    .B(B),
    .ALUControl(ALUControl),
    .Zero(Zero),
    .Result(Result)
  );

  initial begin
    // Testes automáticos para cada operação da ALU
    // Caso 1: Soma
    A = 32'd15; B = 32'd5; ALUControl = 3'b000; #10;
    if (Result !== 32'd20) $display("\nErro na soma: %d + %d = %d, esperado 20", A, B, Result);

    // Caso 2: Subtração
    A = 32'd15; B = 32'd5; ALUControl = 3'b001; #10;
    if (Result !== 32'd10) $display("Erro na subtração: %d - %d = %d, esperado 10", A, B, Result);

    // Caso 3: AND
    A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALUControl = 4'b0010; #10;
    if (Result !== 32'h00000000) $display("Erro no AND: %h & %h = %h, esperado 00000000", A, B, Result);

    // Caso 4: OR
    A = 32'hF0F0F0F0; B = 32'h0F0F0F0F; ALUControl = 4'b0011; #10;
    if (Result !== 32'hFFFFFFFF) $display("Erro no OR: %h | %h = %h, esperado FFFFFFFF", A, B, Result);

    // Caso 5: SLT (Signed Less Than)
    A = 32'd5; B = 32'd9; ALUControl = 4'b0101; #10;
    if (Result !== 32'd1) $display("Erro no SLT: %d < %d = %d, esperado 1", A, B, Result);

    // Verificando Zero Flag
    A = 32'd0; B = 32'd0; ALUControl = 4'b0000; #10;
    if (Zero !== 1) $display("Erro na flag Zero: esperado 1, encontrado %b", Zero);

    A = 32'd1; B = 32'd1; ALUControl = 4'b0000; #10;
    if (Zero !== 0) $display("Erro na flag Zero: esperado 0, encontrado %b", Zero);

    $finish;
  end
endmodule
