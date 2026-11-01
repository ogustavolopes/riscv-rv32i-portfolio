`timescale 1ns / 100ps 
// Memória de Dados de 64KB
module data_memory(
    input wire clk,
    input wire WE,           // Sinal de escrita (Write Enable)
    input wire [31:0] A,     // Endereço de acesso (ALU Result)
    input wire [31:0] WD,    // Dados para escrita (Write Data)
    output wire [31:0] RD    // Dados lidos (Read Data)
);
    reg [31:0] RAM[0:65535];  // Memória de 64KB (palavras)
    integer i;
    assign RD = RAM[A[17:2]]; // Leitura assíncrona usando índice direto de 16 bits (A[17:2]) para acessar a memória, ignorando os bits mais altos e os bits de byte (A[1:0]) para garantir acesso a palavras alinhadas.

    // Escrita síncrona
    always @(posedge clk) begin
        if (WE) RAM[A[17:2]] <= WD;
    end

    // Inicializa posição (x2000) com 10
    initial begin
        
        RAM[0] = 0;
        RAM[1] = 1;
        RAM[2] = 2;
        RAM[3] = 3;
        RAM[4] = 4;
        RAM[5] = 5;
        RAM[6] = 6;
        RAM[7] = 7;
        RAM[8] = 8;
        RAM[9] = 9;

        for (i = 10; i < 65535; i = i + 1) begin
            RAM[i] = 32'h00000000;
        end
    end
endmodule