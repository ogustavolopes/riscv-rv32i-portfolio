`timescale 1ns / 100ps 

module data_memory_tb();
	reg clk;
  reg WE;
  reg [31:0] A;
  reg [31:0] WD;
  wire [31:0] RD;

  data_memory DUT (
    .clk(clk),
    .WE(WE),
    .A(A),
    .WD(WD),
    .RD(RD)
  );

  always begin
    #5 clk = ~clk;
  end

  initial begin
    clk = 0;
    WE = 0;
    A = 32'h0;
    WD = 32'd0;

    #10;
    A = 32'h2000;
    WE = 0;
    #10;
    if (RD !== 32'd10) $display("Erro na leitura inicial: %d", RD);

    #10;
    A = 32'h3000;
    WD = 32'd50;
    WE = 1;
    #10;
    WE = 0;

    A = 32'h3000;
    #10;
    if (RD !== 32'd50) $display("Erro na leitura após escrita: %d", RD);

    #10;
    A = 32'h4000;
    WD = 32'd100;
    WE = 1;
    #10;
    WE = 0;

    A = 32'h4000;
    #10;
    if (RD !== 32'd100) $display("Erro na leitura após escrita: %d", RD);

    $finish;
  end
endmodule