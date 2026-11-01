module data_memory(
    input wire clk,
    input wire WE,
    input wire [31:0] A,
    input wire [31:0] WD,
    output wire [31:0] RD
);
    reg [31:0] RAM[0:65535];  // Memória de 64KB (palavras)

    // Leitura assíncrona usando índice direto
    assign RD = RAM[A];

    // Escrita síncrona
    always @(posedge clk) begin
        if (WE) RAM[A] <= WD;
    end

    // Inicializa posição (x2000) com 10
    initial begin
        RAM[32'h2000] = 32'd10;
    end
endmodule