module memTopo32LittleEndian_tb;
    parameter DATA_WIDTH = 32;
    parameter ADDRESS_WIDTH = 6; 
    reg clk; reg [1:0] size; reg [ADDRESS_WIDTH-1:0] addr;
    reg [DATA_WIDTH-1:0] din; reg sign_ext;
    reg writeEnable; wire [DATA_WIDTH-1:0] dout;
    memTopo32LittleEndian #(
        .DATA_WIDTH(DATA_WIDTH),
        .ADDRESS_WIDTH(ADDRESS_WIDTH)
    ) DUT (
        .clk(clk),
        .size(size),
        .addr(addr),
        .din(din),
        .sign_ext(sign_ext),
        .writeEnable(writeEnable),
        .dout(dout)
    );
    initial begin clk = 0; forever #5 clk = ~clk; end
    initial begin
        $monitor("Tempo: %0t | WE:%b Size:%b addr:%h din:%h sign_ext:%b || dout:%h", 
                 $time, writeEnable, size, addr, din, sign_ext, dout);
    end
    initial begin
        // Condições Iniciais
        writeEnable = 0;
        size = 2'b10; // Word por padrão
        addr = 0;
        din = 0;
        sign_ext = 0; // 0 = Signed, 1 = Unsigned
        $display("\n--- INICIANDO TESTES LSU (Load/Store Unit) RISC-V ---");#15;
        // 1. Teste de Word (SW e LW) - 32 bits
        $display("\n[Teste 1] SW / LW -> Endereco 0x00");
        // SW (Store Word): size = 10
        @(negedge clk);
        writeEnable = 1; addr = 6'h00; din = 32'h12345678; size = 2'b10;
        // LW (Load Word)
        @(negedge clk);
        writeEnable = 0; // Prepara para ler
        #5;$display("LW Esperado: 12345678 | Lido: %h", dout);
        // 2. Teste de Half-Word (SH, LH, LHU) - 16 bits
        $display("\n[Teste 2] SH / LH / LHU -> Enderecos 0x04 e 0x06");
        // SH: Escrevendo 16 bits na parte baixa (0x04) e alta (0x06)
        @(negedge clk);
        writeEnable = 1; size = 2'b01; 
        addr = 6'h04; din = 32'hXXXX80FE; // 80FE tem o MSB=1 (negativo se signed)
        @(negedge clk);
        addr = 6'h06; din = 32'hXXXX7F01; // 7F01 tem o MSB=0 (positivo)
        @(negedge clk);
        writeEnable = 0;
        // LH (Load Half-Word Signed) no 0x04
        addr = 6'h04; sign_ext = 1'b0; // Extensão de sinal ativada
        #5; $display("LH (0x04) Esperado: ffff80fe | Lido: %h", dout);
        // LHU (Load Half-Word Unsigned) no 0x04
        addr = 6'h04; sign_ext = 1'b1; // Zero extension
        #5; $display("LHU (0x04) Esperado: 000080fe | Lido: %h", dout);
        // LH no 0x06 (positivo)
        addr = 6'h06; sign_ext = 1'b0;
        #5; $display("LH (0x06) Esperado: 00007f01 | Lido: %h", dout);
        // 3. Teste de Byte (SB, LB, LBU) e Verificacao de Little Endian
        $display("\n[Teste 3] SB / LB / LBU e Prova de Little Endian -> Enderecos 0x08 a 0x0B");
        // SB (Store Byte) em endereços sequenciais
        @(negedge clk);
        writeEnable = 1; size = 2'b00;
        addr = 6'h08; din = 32'hFFFFFFE1; // E1 (MSB = 1)
        @(negedge clk);
        addr = 6'h09; din = 32'hFFFFFF22; // 22 (MSB = 0)
        @(negedge clk);
        addr = 6'h0A; din = 32'hFFFFFFA3; // A3 (MSB = 1)
        @(negedge clk);
        addr = 6'h0B; din = 32'hFFFFFF04; // 04 (MSB = 0)
        @(negedge clk);
        writeEnable = 0;
        addr = 6'h08; size = 2'b10; // size 10 = Word
        #5; $display("Prova Little Endian (LW em 0x08) | Esperado: 04a322e1 | Lido: %h", dout);
        // --- TESTES DE LEITURA COM EXTENSÃO DE SINAL ---
        size = 2'b00; // Muda para leitura de Byte
        // LB (Load Byte Signed) no 0x08 (E1 = negativo)
        addr = 6'h08; sign_ext = 1'b0;
        #5; $display("LB (0x08) Esperado: ffffffe1 | Lido: %h", dout);
        // LBU (Load Byte Unsigned) no 0x08 (E1)
        addr = 6'h08; sign_ext = 1'b1;
        #5; $display("LBU (0x08) Esperado: 000000e1 | Lido: %h", dout);
        // LB no 0x09 (22 = positivo)
        addr = 6'h09; sign_ext = 1'b0;
        #5; $display("LB (0x09) Esperado: 00000022 | Lido: %h", dout);
        $display("\n--- TESTES FINALIZADOS ---\n");
        $finish;
    end
endmodule
