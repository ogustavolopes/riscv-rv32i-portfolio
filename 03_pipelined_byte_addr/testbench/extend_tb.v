`timescale 1ns / 100ps
 
module extend_tb();
    reg [24:0] Instr;
    reg [1:0] ImmSrc;
    wire [31:0] ImmExt;
    
    extend dut (.Instr(Instr), .ImmSrc(ImmSrc), .ImmExt(ImmExt));

    initial begin
        Instr = 25'hF0F0F0;
        ImmSrc = 2'b00; // I-type
        #10;
        $display("I-type: ImmExt = %h", ImmExt);

        ImmSrc = 2'b01; // S-type
        #10;
        $display("S-type: ImmExt = %h", ImmExt);

        ImmSrc = 2'b10; // B-type
        #10;
        $display("B-type: ImmExt = %h", ImmExt);
        $stop;
    end
endmodule
