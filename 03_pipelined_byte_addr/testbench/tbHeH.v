`timescale 1ns / 100ps

module tbHeH();

    reg clk, reset;

    // ==========================================================================
    // Instanciação da CPU Top-Level
    // ==========================================================================
    cpu DUT (
        .clk(clk),
        .reset(reset)
    );

    // ==========================================================================
    // Inicialização e Geração de Clock
    // ==========================================================================
    initial begin
        reset <= 1;
        #22; 
        reset <= 0;
    end

    always begin
        clk <= 1; #5; 
        clk <= 0; #5;
    end

    // ==========================================================================
    // Visualização dos Sinais Internos
    // ==========================================================================

    // --- ESTÁGIO 1: INSTRUCTION FETCH (IF) ---
    wire [31:0] debug_pc_IF       = DUT.Datapath.PC_inst.PC;
    wire [31:0] debug_instr_IF    = DUT.Datapath.InstrMemory.RD; 

    // --- ESTÁGIO 2: INSTRUCTION DECODE (ID) ---
    wire [31:0] debug_instr_ID    = DUT.Datapath.InstrD; 
    wire [4:0]  x_ra1_ID          = DUT.Datapath.InstrD[19:15];
    wire [4:0]  x_ra2_ID          = DUT.Datapath.InstrD[24:20];
    wire [31:0] x_immext_ID       = DUT.Datapath.ImmExtD;

    // --- ESTÁGIO 3: EXECUTE (EX) ---
    wire [31:0] x_srca_EX         = DUT.Datapath.SrcA;
    wire [31:0] x_srcb_EX         = DUT.Datapath.SrcB;
    wire [31:0] x_alu_result_EX   = DUT.Datapath.ALUResultE; // Ajustado pro fio saindo da ALU
    wire        x_zero_EX         = DUT.Datapath.ZeroE;

    // --- ESTÁGIO 4: MEMORY (MEM) ---
    wire [31:0] x_dm_address_MEM  = DUT.Datapath.DataMemory.A;
    wire [31:0] x_dm_wd_MEM       = DUT.Datapath.DataMemory.WD;
    wire        x_memwrite_MEM    = DUT.Datapath.DataMemory.WE; 
    wire [31:0] x_dm_rd_MEM       = DUT.Datapath.DataMemory.RD;

    // --- ESTÁGIO 5: WRITE BACK (WB) ---
    wire [31:0] x_result_WB       = DUT.Datapath.ResultW;
    wire [4:0]  x_wa3_WB          = DUT.Datapath.Register_inst.WA3; 
    wire [31:0] x_wd3_WB          = DUT.Datapath.Register_inst.WD3; 
    wire        x_regwrite_WB     = DUT.Datapath.RegWriteW;

    // ==========================================================================
    // Verificação Automática de Resultados
    // ==========================================================================
    always @(negedge clk) begin
        // Monitora o sinal WE da Data Memory internamente
        if(DUT.Datapath.DataMemory.WE) begin
            
            // Condição de sucesso: Escreveu 25 no endereço 100
            if(DUT.Datapath.DataMemory.A == 100 && DUT.Datapath.DataMemory.WD == 25) begin
                $display("==================================================");
                $display("SUCESSO! O Pipeline funcionou perfeitamente!");
                $display("Mem[100] recebeu o valor 25.");
                $display("==================================================");
                $stop;
            end 
            // Condição de falha
            else begin
                $display("FALHA! Escrita incorreta: Endereco=%d, Dado=%d", 
                         DUT.Datapath.DataMemory.A, 
                         DUT.Datapath.DataMemory.WD);
                $stop;
            end
        end
    end

endmodule