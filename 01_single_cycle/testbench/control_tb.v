module control_tb();
  reg [6:0] op;
  reg [2:0] funct3;
  reg funct7b5, Zero;
  wire [1:0] ResultSrc;
  wire MemWrite, PCSrc, ALUSrc, RegWrite, Jump;
  wire [1:0] ImmSrc;
  wire [3:0] ALUControl;

  control DUT (
    .op(op),
    .funct3(funct3),
    .funct7b5(funct7b5),
    .Zero(Zero),
    .ResultSrc(ResultSrc),
    .MemWrite(MemWrite),
    .PCSrc(PCSrc),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .Jump(Jump),
    .ImmSrc(ImmSrc),
    .ALUControl(ALUControl)
  );

  initial begin
    // Teste para lw (load word)
    op = 7'b0000011; funct3 = 3'b010; funct7b5 = 1'b0; Zero = 1'b0; #10;
    if (RegWrite !== 1 || ALUSrc !== 1 || MemWrite !== 0 || PCSrc !== 0) 
      $display("Erro no lw");

    // Teste para sw (store word)
    op = 7'b0100011; funct3 = 3'b010; funct7b5 = 1'b0; Zero = 1'b0; #10;
    if (MemWrite !== 1 || ALUSrc !== 1 || RegWrite !== 0 || PCSrc !== 0) 
      $display("Erro no sw");

    // Teste para beq (branch if equal)
    op = 7'b1100011; funct3 = 3'b000; funct7b5 = 1'b0; Zero = 1'b1; #10;
    if (PCSrc !== 1) $display("Erro no beq");

    // Teste para R-type (exemplo: add, sub)
    op = 7'b0110011; funct3 = 3'b000; funct7b5 = 1'b0; Zero = 1'b0; #10;
    if (ALUControl !== 4'b0000 || RegWrite !== 1 || ALUSrc !== 0 || MemWrite !== 0) 
      $display("Erro no R-type");

    // Teste para I-type ALU (exemplo: addi)
    op = 7'b0010011; funct3 = 3'b000; funct7b5 = 1'b0; Zero = 1'b0; #10;
    if (ALUControl !== 4'b0000 || ALUSrc !== 1 || RegWrite !== 1) 
      $display("Erro no I-type ALU");

    // Teste para Reset
    op = 7'b0000000; funct3 = 3'b000; funct7b5 = 1'b0; Zero = 1'b0; #10;
    if (RegWrite !== 0 || ALUSrc !== 0 || MemWrite !== 0 || PCSrc !== 0) 
      $display("Erro no Reset");
    $finish;
  end
endmodule