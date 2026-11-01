`timescale 1ns / 100ps
 
module register_file_tb();
    reg clk = 0;
    reg reset = 1;
    reg WE3 = 0;
    reg [4:0] RA1 = 0, RA2 = 0, WA3 = 0;
    reg [31:0] WD3 = 0;
    wire [31:0] RD1, RD2;

    register_file DUT(
        .clk(clk), 
        .reset(reset), 
        .WE3(WE3),
        .RA1(RA1), 
        .RA2(RA2), 
        .WA3(WA3),
        .WD3(WD3), 
        .RD1(RD1), 
        .RD2(RD2)
    );

    always #5 clk = ~clk;
    
    initial begin
        $display("\n");
        $monitor("Time=%0t RA1=%0d RA2=%0d RD1=%h RD2=%h", $time, RA1, RA2, RD1, RD2);
        #3 reset = 1;
        #10 reset = 0;

        // Escreve 0x12345678 em x5
        #5 WE3 = 1; WA3 = 5; WD3 = 32'h12345678;
        #10 WE3 = 0;

        // Lê x5 e x9 (x9 está como 0x204 no initial)
        RA1 = 5;
        RA2 = 9;
        #10;
        $finish;
    end
endmodule