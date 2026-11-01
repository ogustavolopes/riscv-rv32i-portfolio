`timescale 1ns / 100ps 

module cpu_tb();
    reg clk, reset;

    // Instanciação da CPU Top-Level (agora só tem clk e reset nas portas)
    cpu DUT (
        .clk(clk),
        .reset(reset)
    ); 

    // ==========================================================================
    // Visualização dos sinais internos (Mapeados por Estágios do Pipeline)
    // ==========================================================================
    
    // --- FETCH (IF) ---
    wire [31:0] debug_pc       = DUT.Datapath.PC_inst.PC;
    wire [31:0] debug_pcnext   = DUT.Datapath.PC_inst.PCNext;
    wire [31:0] debug_pctarget = DUT.Datapath.PCTargetE;
    wire [31:0] debug_instr_F  = DUT.Datapath.InstrF; // A instrução lida da memória

    // --- DECODE (ID) ---
    wire [31:0] debug_instr_D  = DUT.Datapath.InstrD; // Instrução registrada no ID
    wire [4:0]  x_ra1          = DUT.Datapath.InstrD[19:15];
    wire [4:0]  x_ra2          = DUT.Datapath.InstrD[24:20];
    wire [31:0] x_rd1          = DUT.Datapath.RD1D;
    wire [31:0] x_rd2          = DUT.Datapath.RD2D;
    wire [31:7] x_inextend     = DUT.Datapath.InstrD[31:7];
    wire [31:0] x_immext       = DUT.Datapath.ImmExtD;

    // --- EXECUTE (EX) ---
    wire [31:0] x_srca         = DUT.Datapath.SrcA;
    wire [31:0] x_srcb         = DUT.Datapath.SrcB;
    wire [31:0] x_alu_result   = DUT.Datapath.ALUResultE;
    wire        x_zero         = DUT.Datapath.ZeroE;
    
    // --- MEMORY (MEM) ---
    wire [31:0] x_dm_address   = DUT.Datapath.DataMemory.addr;
    wire [31:0] x_dm_wd        = DUT.Datapath.DataMemory.din_aligned;
    wire [31:0] x_dm_rd        = DUT.Datapath.DataMemory.dout;
    
    // --- WRITE BACK (WB) ---
    wire [31:0] x_result       = DUT.Datapath.ResultW;
    wire [4:0]  x_wa3          = DUT.Datapath.Register_inst.WA3;
    wire [31:0] x_wd3          = DUT.Datapath.Register_inst.WD3;
    
    // --- CONTROL UNIT (Gerados no Decode) ---
    wire [6:0] x_op            = DUT.Control.op;
    wire       x_regwrite      = DUT.Control.RegWriteD; 
    wire [1:0] x_immsrc        = DUT.Control.ImmSrcD;
    wire       x_alusrc        = DUT.Control.ALUSrcD;
    wire       x_memwrite      = DUT.Control.MemWriteD;
    wire       x_resultsrc     = DUT.Control.ResultSrcD; // Agora é 1 bit
    wire       x_branch        = DUT.Control.BranchD;
    wire [1:0] x_aluop         = DUT.Control.ALUop;
    wire [2:0] x_aluctrl       = DUT.Control.ALUControlD;
    wire [2:0] x_funct3        = DUT.Control.funct3;
    wire       x_funct7b5      = DUT.Control.funct7b5;
    // ==========================================================================

    parameter MAX_CYCLES = 35; // Tamanho máximo do histórico
    integer i;
    integer cycle_count;

    // ==========================================================================
    // Buffers para armazenar o histórico
    // ==========================================================================
    reg [31:0] h_pc [0:MAX_CYCLES];
    reg [31:0] h_pcnext [0:MAX_CYCLES];
    reg [31:0] h_pctarget [0:MAX_CYCLES];
    reg [31:0] h_instr_F [0:MAX_CYCLES];
    reg [31:0] h_instr_D [0:MAX_CYCLES];

    reg [4:0]  h_ra1 [0:MAX_CYCLES]; 
    reg [4:0]  h_ra2 [0:MAX_CYCLES]; 
    reg [4:0]  h_wa3 [0:MAX_CYCLES];
    reg [31:0] h_wd3 [0:MAX_CYCLES];
    reg [31:0] h_rd1 [0:MAX_CYCLES]; 
    reg [31:0] h_rd2 [0:MAX_CYCLES]; 

    reg [31:7] h_inextend [0:MAX_CYCLES]; 
    reg [31:0] h_immext [0:MAX_CYCLES]; 
    reg [31:0] h_srca [0:MAX_CYCLES]; 
    reg [31:0] h_srcb [0:MAX_CYCLES]; 
    reg [31:0] h_alu_result [0:MAX_CYCLES];
    reg        h_zero [0:MAX_CYCLES];

    reg [31:0] h_dm_addr [0:MAX_CYCLES];
    reg [31:0] h_dm_wd [0:MAX_CYCLES]; 
    reg [31:0] h_dm_rd [0:MAX_CYCLES];
    reg [31:0] h_result [0:MAX_CYCLES];

    reg [6:0]  h_op [0:MAX_CYCLES];
    reg        h_regwrite [0:MAX_CYCLES];
    reg [1:0]  h_immsrc [0:MAX_CYCLES];
    reg        h_alusrc [0:MAX_CYCLES];
    reg        h_memwrite [0:MAX_CYCLES];
    reg        h_resultsrc [0:MAX_CYCLES];
    reg        h_branch [0:MAX_CYCLES];
    reg [1:0]  h_aluop [0:MAX_CYCLES];
    reg        h_jump [0:MAX_CYCLES];
    reg [2:0]  h_aluctrl [0:MAX_CYCLES];
    reg [2:0]  h_funct3 [0:MAX_CYCLES];
    reg        h_funct7b5 [0:MAX_CYCLES];

    // Clock Generation
    always #5 clk = ~clk; 

    // ==========================================================================
    // Captura de Dados
    // ==========================================================================
    always @(negedge clk) begin
        if (!reset && cycle_count < MAX_CYCLES) begin
            h_pc[cycle_count]         = debug_pc;
            h_pcnext[cycle_count]     = debug_pcnext;
            h_pctarget[cycle_count]   = debug_pctarget;
            h_instr_F[cycle_count]    = debug_instr_F;
            h_instr_D[cycle_count]    = debug_instr_D;
            
            h_ra1[cycle_count]        = x_ra1;
            h_ra2[cycle_count]        = x_ra2;
            h_wa3[cycle_count]        = x_wa3;
            h_wd3[cycle_count]        = x_wd3;
            h_rd1[cycle_count]        = x_rd1;
            h_rd2[cycle_count]        = x_rd2;
            
            h_inextend[cycle_count]   = x_inextend;
            h_immext[cycle_count]     = x_immext;
            h_srca[cycle_count]       = x_srca;
            h_srcb[cycle_count]       = x_srcb;
            h_alu_result[cycle_count] = x_alu_result;
            h_zero[cycle_count]       = x_zero;

            h_dm_addr[cycle_count]    = x_dm_address;
            h_dm_wd[cycle_count]      = x_dm_wd;
            h_dm_rd[cycle_count]      = x_dm_rd;
            h_result[cycle_count]     = x_result;

            h_op[cycle_count]         = x_op;
            h_regwrite[cycle_count]   = x_regwrite;
            h_immsrc[cycle_count]     = x_immsrc;
            h_alusrc[cycle_count]     = x_alusrc;
            h_memwrite[cycle_count]   = x_memwrite;
            h_resultsrc[cycle_count]  = x_resultsrc;
            h_branch[cycle_count]     = x_branch;
            h_aluop[cycle_count]      = x_aluop;
            h_aluctrl[cycle_count]    = x_aluctrl;
            h_funct3[cycle_count]     = x_funct3;
            h_funct7b5[cycle_count]   = x_funct7b5;

            cycle_count = cycle_count + 1;
        end
    end
    
    // ==========================================================================
    // Execução e Impressão
    // ==========================================================================
    initial begin
        clk = 0;
        reset = 1;
        cycle_count = 0;
        #12 reset = 0; 

        // Aguarda os ciclos definidos
        #(MAX_CYCLES * 10); 
        
        /* $display("\n===================================================================================================");
        $display(" TABELA 1: INSTRUCTION FETCH (IF) & DECODE (ID)");
        $display("===================================================================================================");
        $display(" Cycle | PC       | InstrF   | InstrD   | PCNext   | PCTarget");
        $display("-------|----------|----------|----------|----------|----------");
        for (i = 0; i < cycle_count; i = i + 1) begin
            $display(" %5d | %h | %h | %h | %h | %h", 
                i, h_pc[i], h_instr_F[i], h_instr_D[i], h_pcnext[i], h_pctarget[i]);
        end */

        $display("\n===================================================================================================");
        $display(" TABELA 2: REGISTER FILE (WB & ID)");
        $display("===================================================================================================");
        $display(" Cycle | RA1 | RA2 | WA3 | WD3      | RD1      | RD2");
        $display("-------|-----|-----|-----|----------|----------|----------");
        for (i = 0; i < cycle_count; i = i + 1) begin
            $display(" %5d |  %2d |  %2d |  %2d | %h | %h | %h", 
                i, h_ra1[i], h_ra2[i], h_wa3[i], h_wd3[i], h_rd1[i], h_rd2[i]);
        end

        /* $display("\n===================================================================================================");
        $display(" TABELA 3: EXTEND (ID) & ALU (EX)");
        $display("===================================================================================================");
        $display(" Cycle | ImmExt     | SrcA     | SrcB     | ALUResult   | Zero");
        $display("-------|------------|----------|----------|-------------|----------");
        for (i = 0; i < cycle_count; i = i + 1) begin
            $display(" %5d | %h   | %h | %h | %h    | %b", 
                i, h_immext[i], h_srca[i], h_srcb[i], h_alu_result[i], h_zero[i]);
        end */

        $display("\n===================================================================================================");
        $display(" TABELA 4: DATA MEMORY (MEM) & RESULT MUX (WB)");
        $display("===================================================================================================");
        $display(" Cycle | Address  | WriteData | ReadData  | Result");
        $display("-------|----------|-----------|-----------|----------");
        for (i = 0; i < cycle_count; i = i + 1) begin
            $display(" %5d | %h | %h  | %h  | %h", 
                i, h_dm_addr[i], h_dm_wd[i], h_dm_rd[i], h_result[i]);
        end

        $display("\n===================================================================================================");
        $display(" TABELA 5: CONTROL UNIT (ID STAGE)");
        $display("===================================================================================================");
        $display(" Cycle | OpCode   | RegWrite | ImmSrc | ALUSrc  | MemWrite | ResultSrc | Branch | ALUOp | Jump");
        $display("-------|----------|----------|--------|---------|----------|-----------|--------|-------|--------");
        for (i = 0; i < cycle_count; i = i + 1) begin
            $display(" %5d | %b  |    %b     |   %b   |    %b    |    %b     |     %b     |    %b   |   %b  |   %b ", 
                i, h_op[i], h_regwrite[i], h_immsrc[i], h_alusrc[i], h_memwrite[i], h_resultsrc[i], h_branch[i], h_aluop[i], h_jump[i]);
        end

       /*  $display("\n===================================================================================================");
        $display(" TABELA 6: CONTROL SIGNALS (ID STAGE)");
        $display("===================================================================================================");
        $display(" Cycle | OpCode   | Funct3 | Funct7b5");
        $display("-------|----------|--------|-----------");
        for (i = 0; i < cycle_count; i = i + 1) begin
            $display(" %5d | %b  |   %b   |    %b    ", 
                i, h_op[i], h_funct3[i], h_funct7b5[i]);
        end */
        
        $display("\n===================================================================================================");
        $display("Fim da simulacao.");
        $stop;
    end
endmodule