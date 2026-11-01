`timescale 1ns / 100ps

module mux_tb();

    reg [31:0] A;
    reg [31:0] B;
    reg sel;
    wire [31:0] Y;

    mux dut(.A(A),.B(B),.sel(sel),.Y(Y));

    initial begin
        A = 32'h01234567; B = 32'h89ABCDEF;
        sel = 0; #10; sel = 1; #10;

        A = 32'hFFFFFFFF; B = 32'hEEEEEEEE;
        sel = 0; #10; sel = 1; #10;

        A = 32'h01010101; B = 32'h0F1F0F1F;
        sel = 0; #10; sel = 1; #10;

        A = 32'h89ABCDEF; B = 32'h01234567;
        sel = 0; #10; sel = 1; #10;

        A = 32'h00AABBCC; B = 32'hDDEEFF11;
        sel = 0; #10; sel = 1; #10;
        $stop;
    end

endmodule
