`timescale 1ns / 100ps
// Multiplexador 3 para 1 de 32 bits
module mux3_1(
    input  wire [31:0] A,   // Entrada bit 00
    input  wire [31:0] B,   // Entrada bit 01
    input  wire [31:0] C,   // Entrada bit 10
    input  wire [1:0]  sel, // Sinal de seleção
    output reg [31:0] Y    // Saída multiplexada
);
    always @(*) begin
        case (sel)
            2'b00: Y = A; // Seleciona A
            2'b01: Y = B; // Seleciona B
            2'b10: Y = C; // Seleciona C
            default: Y = 32'b0; // Valor padrão para casos inválidos
        endcase
    end
endmodule
