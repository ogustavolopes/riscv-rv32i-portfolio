`timescale 1ns / 100ps
 
module PC_tb;
    reg clk;
    reg reset;
    reg [31:0] PCNext;
    wire [31:0] PC_out;

    integer i;
    reg [31:0] expected_val;
    integer errors;

    PC DUT (
        .clk(clk),
        .reset(reset),
        .PCNext(PCNext),
        .PC(PC_out)
    );
    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 0;
        PCNext = 32'h0000_0000;
        errors = 0;

        $display("\n[%0t] Teste 1: Reset Assincrono...", $time);
        #2 reset = 1; 
        #2;          
        
        if (PC_out !== 32'h0000_1000) begin
            $display("[FALHA] Reset falhou! Esperado: 1000, Obtido: %h", PC_out);
            errors = errors + 1;
        end else begin
            $display("[SUCESSO] Reset OK (PC = 1000)");
        end
        #6 reset = 0; 

        $display("[%0t] Teste 2: Carga Sequencial Simples...", $time);
        PCNext = 32'h0000_1004; // Próxima instrução típica
        @(posedge clk); 
        #1;            
        
        if (PC_out !== 32'h0000_1004) begin
            $display("[FALHA] Atualizacao simples falhou. Esperado: 1004, Obtido: %h", PC_out);
            errors = errors + 1;
        end else begin
            $display("[SUCESSO] Carga 1004 OK");
        end

        $display("[%0t] Teste 3: Limites (0x00... e 0xFF...)...", $time);
        
        // Teste MAX (32 bits tudo em 1)
        PCNext = 32'hFFFF_FFFF;
        @(posedge clk); #1;
        if (PC_out !== 32'hFFFF_FFFF) begin 
            $display("[FALHA] Max Value falhou."); errors = errors + 1; 
        end

        // Teste MIN (32 bits tudo em 0)
        PCNext = 32'h0000_0000;
        @(posedge clk); #1;
        if (PC_out !== 32'h0000_0000) begin 
            $display("[FALHA] Min Value falhou."); errors = errors + 1; 
        end
        $display("[SUCESSO] Limites OK");

        $display("[%0t] Teste 4: Stress Aleatorio (50 ciclos)...", $time);
        
        for (i = 0; i < 50; i = i + 1) begin
            // Gera valor aleatório de 32 bits
            expected_val = $random; 
            PCNext = expected_val;

            @(posedge clk);
            #1; 

            if (PC_out !== expected_val) begin
                $display("[FALHA] Iteracao %0d: PCNext=%h, PC_out=%h", i, expected_val, PC_out);
                errors = errors + 1;
            end
        end
        $display("[SUCESSO] 50 vetores aleatorios passados com sucesso.");

        $display("[%0t] Teste 5: Prioridade de Reset sobre Dados...", $time);
        PCNext = 32'hDEAD_BEEF; // Tenta escrever um valor qualquer
        reset = 1;             
        @(posedge clk); #1;
        
        if (PC_out !== 32'h0000_1000) begin
            $display("[FALHA] Reset nao teve prioridade! PC=%h", PC_out);
            errors = errors + 1;
        end else begin
            $display("[SUCESSO] Reset sobrepos o dado corretamente.");
        end
        $display("---------------------------------------------------");
        if (errors == 0)
            $display("RESULTADO: TODOS OS TESTES PASSARAM!");
        else
            $display("RESULTADO: %0d ERROS ENCONTRADOS.", errors);
        $display("---------------------------------------------------");
        $stop;
    end
endmodule