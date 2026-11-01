module memByteAddressable32WF_tb;
    parameter DATA_WIDTH = 32; parameter ADDRESS_WIDTH = 4; reg clk;
    reg [3:0] byteEnable; reg [ADDRESS_WIDTH-1:0] addr; reg [DATA_WIDTH-1:0] din;
    wire [DATA_WIDTH-1:0] dout;
    memByteAddressable32WF #(.DATA_WIDTH(DATA_WIDTH), .ADDRESS_WIDTH(ADDRESS_WIDTH)) DUT (
        .clk(clk), .byteEnable(byteEnable), .addr(addr), .din(din), .dout(dout));
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin
        byteEnable = 4'b0000; addr = 0; din = 0;
        $display("\n--- INICIANDO TESTE DA MEMORIA (RISC-V ISA) ---");#15;
        // 1. Teste de Instrução SW (Store Word) - 32 bits
        $display("\n[Teste 1] SW - Escrevendo 32 bits completos no endereco 0");
        @(negedge clk); addr = 4'h0;
        din = 32'hDEADBEEF; // Dado a ser escrito
        byteEnable = 4'b1111; // Habilita os 4 blocos de memória
        @(negedge clk); byteEnable = 4'b0000; // Desabilita escrita para leitura
        #1;$display("Endereço 0 | Esperado: deadbeef | Lido: %h", dout);
        // 2. Teste de Instrução SH (Store Half-Word) - 16 bits
        $display("\n[Teste 2] SH - Escrevendo Meias-Palavras (16 bits) no endereco 1");
        // Escrevendo na Parte Baixa (Lower Half)
        @(negedge clk); addr = 4'h1;
        din = 32'hXXXXBABA;   // Apenas BABA deve ser gravado
        byteEnable = 4'b0011; // Habilita apenas mem_byte0 e mem_byte1
        // Escrevendo na Parte Alta (Upper Half)
        @(negedge clk);
        din = 32'hCAFE0000;   // Apenas CAFE deve ser gravado
        byteEnable = 4'b1100; // Habilita apenas mem_byte2 e mem_byte3
        @(negedge clk); byteEnable = 4'b0000; #1;
        // O resultado final deve ser a junção das duas escritas independentes
        $display("Endereço 1 | Esperado: cafebaba | Lido: %h", dout);
        // 3. Teste de Instrução SB (Store Byte) - 8 bits
        $display("\n[Teste 3] SB - Escrevendo Bytes avulsos (8 bits) no endereco 2");
        addr = 4'h2;
        // Escreve Byte 0 (LSB - Little Endian)
        @(negedge clk);
        din = 32'hXXXXXX11; byteEnable = 4'b0001;
        // Escreve Byte 1
        @(negedge clk);
        din = 32'hXXXX22XX; byteEnable = 4'b0010;
        // Escreve Byte 2
        @(negedge clk);
        din = 32'hXX33XXXX; byteEnable = 4'b0100;
        // Escreve Byte 3 (MSB)
        @(negedge clk);
        din = 32'h44XXXXXX; byteEnable = 4'b1000;
        @(negedge clk);
        byteEnable = 4'b0000;
        #1;
        // Lendo a palavra inteira (deve conter os 4 bytes enfileirados)
        $display("Endereço 2 | Esperado: 44332211 | Lido: %h", dout);
        $display("\n--- TESTES FINALIZADOS ---\n");
        $finish;
    end

endmodule