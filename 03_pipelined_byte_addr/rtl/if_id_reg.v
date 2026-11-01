`timescale 1ns / 100ps 
// Registro de pipeline IF/ID
module if_id_reg (
    input clk, reset,
    input flush_INST, // Sinal para limpar o registro (devido a um desvio)
    input [31:0] InstrF, PCF,
    output reg [31:0] InstrD, PCD
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            InstrD <= 32'h0000;
            PCD <= 32'h0000;
        end
        else if (flush_INST) begin
            InstrD <= 32'h0000;
            PCD <= PCF;
        end
        else begin
            InstrD <= InstrF;
            PCD <= PCF;
        end
    end
endmodule
