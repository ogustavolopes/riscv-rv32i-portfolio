`timescale 1ns / 100ps 
// Extend o imediato de 12 bits para 32 bits
module extend(
    input signed [31:7] Instr,   // Recebe os bits da instrução 
    input signed [1:0] ImmSrc,   // Sinal de controle para selecionar o tipo de extensão
    output signed [31:0] ImmExt  // Imediato estendido de 32 bits
);
    //ImmSrc --> 0 para load e 1 para store
    //ImmSrc --> 00: tipo I, 01: tipo S, 10 tipo B

    reg [31:0] exit;
    assign ImmExt[31:0] = exit;

    always@(*)begin
        case (ImmSrc)
            2'b00: begin
                exit <= {{20{Instr[31]}},Instr[31:20]};  // Extensão do imediato tipo I
            end
            2'b01: begin
                exit <= {{20{Instr[31]}},Instr[31:25],Instr[11:7]};  // Extensão do imediato tipo S
            end
            2'b10: begin
                exit <= {{20{Instr[31]}},Instr[7],Instr[30:25],Instr[11:8],1'b0};  // Extensão do imediato tipo B
            end
            2'b11: begin
                exit <= {{12{Instr[31]}}, Instr[19:12], Instr[20], Instr[30:21], 1'b0};  // Extensão do imediato tipo J
            end
            default: exit <= 32'd0;
        endcase
    end
endmodule

