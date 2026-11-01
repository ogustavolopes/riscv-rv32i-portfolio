module register_file(
    input wire clk,
    input wire reset,                // sinal de reset
    input wire WE3,                  // Write Enable
    input wire [4:0] RA1, RA2, WA3,  // Endereços dos registradores
    input wire [31:0] WD3,           // Dado a ser escrito
    output wire [31:0] RD1, RD2      // Dados lidos
);
    reg [31:0] REG_MEM_BLOCK[31:0];  // Banco de registradores
    integer i;

    always @(posedge clk) begin
        if (reset) begin
            // Zera todos os registradores e inicializa x5 e x9
            for (i = 0; i < 32; i = i + 1)
                REG_MEM_BLOCK[i] <= 32'b0;

            REG_MEM_BLOCK[5] <= 32'd6;
            REG_MEM_BLOCK[9] <= 32'h2004;
        end else if (WE3 && WA3 != 0) begin
            // Escreve no registrador se habilitado e diferente de x0
            REG_MEM_BLOCK[WA3] <= WD3;
        end
    end
    // Leitura assíncrona (x0 sempre retorna zero)
    assign RD1 = (RA1 != 0) ? REG_MEM_BLOCK[RA1] : 32'b0;
    assign RD2 = (RA2 != 0) ? REG_MEM_BLOCK[RA2] : 32'b0;
endmodule
