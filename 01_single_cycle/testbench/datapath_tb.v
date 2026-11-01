module datapath_tb();
  reg clk;
  reg reset;
  reg [1:0] ResultSrc;
  reg PCSrc, ALUSrc, RegWrite;
  reg [1:0] ImmSrc;
  reg [3:0] ALUControl;
  reg [31:0] Instr;
  reg [31:0] ReadData;
  wire Zero;
  wire [31:0] PC;
  wire [31:0] ALUResult, WriteData;

  datapath DUT (
    .clk(clk),
    .reset(reset),
    .ResultSrc(ResultSrc),
    .PCSrc(PCSrc),
    .ALUSrc(ALUSrc),
    .RegWrite(RegWrite),
    .ImmSrc(ImmSrc),
    .ALUControl(ALUControl),
    .Instr(Instr),
    .ReadData(ReadData),
    .Zero(Zero),
    .PC(PC),
    .ALUResult(ALUResult),
    .WriteData(WriteData)
  );

  always begin
    #5 clk = ~clk;
  end

  initial begin
    clk = 0;
    reset = 0;
    ResultSrc = 2'b00;
    PCSrc = 0;
    ALUSrc = 0;
    RegWrite = 1;
    ImmSrc = 2'b00;
    ALUControl = 4'b0000;
    Instr = 32'h00000000;
    ReadData = 32'h00000000;

    #10;

    // reset
    reset = 1;
    #10;
    reset = 0;

    // (PCPlus4)
    Instr = 32'h00000000;  // NOP
    #10;
    if (PC !== 32'h4) $display("Erro: PC não incrementou corretamente.");

    // ALU (add)
    ALUControl = 4'b0000; 
    Instr = 32'b00000000000000000000000000010000; 
    ReadData = 32'h00000000;
    #10;
    if (ALUResult !== 32'h00000010) $display("Erro: ALU resultado incorreto.");

    ResultSrc = 2'b00; // ALU result
    #10;
    if (WriteData !== ALUResult) $display("Erro: WriteData incorreto.");

    ImmSrc = 2'b01;  
    #10;
    Instr = 32'h00000193; // I-type 
    if (WriteData !== 32'h00000193) $display("Erro: WriteData com Immediate incorreto.");

    RegWrite = 1;
    #10;
    if (WriteData !== 32'h00000193) $display("Erro: Registro não escrito corretamente.");

    $finish;
  end
endmodule