module SingleCycleCore_tb();
  reg clk, reset;
  reg [31:0] Instr, ReadData;
  wire [31:0] PC, ALUResult, WriteData;
  wire MemWrite;

  SingleCycleCore DUT (
    .clk(clk),
    .reset(reset),
    .Instr(Instr),
    .ReadData(ReadData),
    .PC(PC),
    .MemWrite(MemWrite),
    .ALUResult(ALUResult),
    .WriteData(WriteData)
  );

  initial begin
    clk = 0;
    reset = 1;
    Instr = 32'h00000000;
    ReadData = 32'h00000000;
    #10;
    reset = 0;
    #10;
    Instr = 32'h00000193; 
    ReadData = 32'h00000000;
    #10;
    Instr = 32'h00000013;
    #10;
    Instr = 32'h00002023;
    ReadData = 32'h00000001;
    #10;
    Instr = 32'h00000393;
    #10;
    $finish;
  end

  always #5 clk = ~clk;

endmodule