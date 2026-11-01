`timescale 1ns / 100ps
// Multiplexador 2 para 1 de 32 bits
module mux(
    input  wire [31:0] A,   // Entrada bit 0
    input  wire [31:0] B,   // Entrada bit 1
    input  wire        sel, // Sinal de seleção
    output wire [31:0] Y    // Saída multiplexada
);
    assign Y = sel ? B : A;
endmodule
