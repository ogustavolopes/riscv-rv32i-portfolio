module memTopo32LittleEndian #(
    parameter DATA_WIDTH = 32,
    parameter ADDRESS_WIDTH = 14
) (
    input wire clk, //! Clock
    input wire [1:0] size, //! funct3[1:0] 00: byte, 01: half, 10: word
    input wire [31:0] addr, //! Endereco
    input wire [DATA_WIDTH -1:0] din, //! Entrada de dados
    input wire sign_ext , //! funct3[2] 0: extensão de sinal , 1: zero extension
    input wire writeEnable , //! Habilita escrita (vem do controle)
    output wire [DATA_WIDTH -1:0] dout //! Saida de dados
);
    wire [3:0] byteEnable;
    wire [31:0] mem_dout;
    wire [31:0] rdata;
    reg [DATA_WIDTH -1:0] din_aligned;

    always @(*) begin //Alinha dados de escrita
        case(addr[1:0])
            2'b00: din_aligned = din;
            2'b01: din_aligned = din << 8;
            2'b10: din_aligned = din << 16;
            2'b11: din_aligned = din << 24;
        endcase
    end

    byteEnableDecoder decoder (
    .addr_offset(addr[1:0]),
    .size(size),
    .byteEnable(byteEnable),
    .writeEnable(writeEnable)
    );
    memByteAddressable32WF #(
        .DATA_WIDTH(32),
        .ADDRESS_WIDTH(ADDRESS_WIDTH) // Passa o 14 para frente
    ) mem_inst (
    .clk(clk),
    .byteEnable(byteEnable),
    .addr(addr[15:2]), // endereçamento por palavra (alinhado)
    .din(din_aligned),
    .dout(mem_dout)
    );
    memReadManager read_inst (
    .dout(mem_dout),
    .addr_offset(addr[1:0]),
    .size(size),
    .sign_extend(sign_ext),
    .rdata(rdata)
    );
    assign dout = rdata;

    // Inicialização manual dos bancos de memória para o Testbench
    integer i;
    initial begin
        // Primeiro, limpa as primeiras 65536 posições de todos os bancos com zero
        for (i = 0; i < 65536; i = i + 1) begin
            mem_inst.mem_byte0.mem[i] = 8'h00;
            mem_inst.mem_byte1.mem[i] = 8'h00;
            mem_inst.mem_byte2.mem[i] = 8'h00;
            mem_inst.mem_byte3.mem[i] = 8'h00;
        end

        // Endereço 0 (Palavra 0): 0x56783412 (Little Endian)
        mem_inst.mem_byte0.mem[0] = 8'h12; // .byte 0x12
        mem_inst.mem_byte1.mem[0] = 8'h34; // .byte 0x34
        mem_inst.mem_byte2.mem[0] = 8'h78; // .hword 0x5678 (LSB)
        mem_inst.mem_byte3.mem[0] = 8'h56; // .hword 0x5678 (MSB)

        // Endereço 4 (Palavra 1): 0x9ABCDEF0
        mem_inst.mem_byte0.mem[1] = 8'hF0; 
        mem_inst.mem_byte1.mem[1] = 8'hDE;
        mem_inst.mem_byte2.mem[1] = 8'hBC;
        mem_inst.mem_byte3.mem[1] = 8'h9A;
    end

endmodule