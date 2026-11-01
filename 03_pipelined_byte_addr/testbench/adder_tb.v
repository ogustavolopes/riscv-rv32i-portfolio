`timescale 1ns / 100ps

module adder_tb();
    reg [31:0] A;
    reg [31:0] B;
    reg Cin;
    wire [31:0] Result;
    wire Cout;

    adder dut(.A(A),.B(B),.Cin(Cin),.Result(Result),.Cout(Cout));

    reg [31:0] result_tb;
    reg        Cout_tb;
    always @(*) begin
        {Cout_tb, result_tb} = {1'b0, A} + {1'b0, B} + {{32{1'b0}}, Cin};
    end
    reg done;
    
    initial begin
        $display("\nTeste 1: inicializa todos os bits de entrada com 0 e varre o conjunto A[31:16] de 0000 ate ffff");
        A = 32'h00000000; B = 32'h00000000; Cin = 1'b0;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("Erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("Esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (A[31:16] < 16'hffff) begin
                A[31:16] = A[31:16] + 16'h0001;
            end else begin
                done = 1'b1;
                $display("Sucesso: teste 1 executado sem erro");
            end
        end

        $display("\nTeste 2: inicializa todos os bits de entrada com 0 e varre o conjunto A[23:8] de 0000 ate ffff");
        A = 32'h00000000; B = 32'h00000000; Cin = 1'b0;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("Erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("Esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (A[23:8] < 16'hffff) begin
                A[23:8] = A[23:8] + 16'h0001;
            end else begin
                done = 1'b1;
                $display("Sucesso: teste 2 executado sem erro");
            end
        end

        $display("\nTeste 3: inicializa todos os bits de entrada com 0 e varre o conjunto A[15:0] de 0000 ate ffff");
        A = 32'h00000000; B = 32'h00000000; Cin = 1'b0;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("Erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("Esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (A[15:0] < 16'hffff) begin
                A[15:0] = A[15:0] + 16'h0001;
            end else begin
                done = 1'b1;
                $display("Sucesso: teste 3 executado sem erro");
            end
        end

        $display("\nTeste 4: inicializa todos os bits de entrada com 0 e varre o conjunto B[31:16] de 0000 ate ffff");
        A = 32'h00000000; B = 32'h00000000; Cin = 1'b0;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("Erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("Esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (B[31:16] < 16'hffff) begin
                B[31:16] = B[31:16] + 16'h0001;
            end else begin
                done = 1'b1;
                $display("Sucesso: teste 4 executado sem erro");
            end
        end

        $display("\nTeste 5: inicializa todos os bits de entrada com 0 e varre o conjunto B[23:8] de 0000 ate ffff");
        A = 32'h00000000; B = 32'h00000000; Cin = 1'b0;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (B[23:8] < 16'hffff) begin
                B[23:8] = B[23:8] + 16'h0001;
            end else begin
                done = 1'b1;
                $display("Sucesso: teste 5 executado sem erro");
            end
        end
        
        $display("\nTeste 6: inicializa todos os bits de entrada com 0 e varre o conjunto B[15:0] de 0000 ate ffff");
        A = 32'h00000000; B = 32'h00000000; Cin = 1'b0;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (B[15:0] < 16'hffff) begin
                B[15:0] = B[15:0] + 16'h0001;
            end else begin
                done = 1'b1;
            end
        end
        $display("sucesso: teste 6 executado sem erro");

        $display("\nTeste 7: inicializa todos os bits de entrada com 1 e varre o conjunto A[31:16] de ffff ate 0000");
        A   = 32'hffffffff;
        B   = 32'hffffffff;
        Cin = 1'b1;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (A[31:16] > 16'h0000) begin
                A[31:16] = A[31:16] - 16'h0001;
            end else begin
                done = 1'b1;
            end
        end
        $display("sucesso: teste 7 executado sem erro");

        $display("\nTeste 8: inicializa todos os bits de entrada com 1 e varre o conjunto A[23:8] de ffff ate 0000");
        A   = 32'hffffffff;
        B   = 32'hffffffff;
        Cin = 1'b1;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (A[23:8] > 16'h0000) begin
                A[23:8] = A[23:8] - 16'h0001;
            end else begin
                done = 1'b1;
            end
        end
        $display("sucesso: teste 8 executado sem erro");

        $display("\nTeste 9: inicializa todos os bits de entrada com 1 e varre o conjunto A[15:0] de ffff ate 0000");
        A   = 32'hffffffff;
        B   = 32'hffffffff;
        Cin = 1'b1;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (A[15:0] > 16'h0000) begin
                A[15:0] = A[15:0] - 16'h0001;
            end else begin
                done = 1'b1;
            end
        end
        $display("sucesso: teste 9 executado sem erro");

        $display("\nTeste 10: inicializa todos os bits de entrada com 1 e varre o conjunto B[31:16] de ffff ate 0000");
        A   = 32'hffffffff;
        B   = 32'hffffffff;
        Cin = 1'b1;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (B[31:16] > 16'h0000) begin
                B[31:16] = B[31:16] - 16'h0001;
            end else begin
                done = 1'b1;
            end
        end
        $display("sucesso: teste 10 executado sem erro");

        $display("\nTeste 11: inicializa todos os bits de entrada com 1 e varre o conjunto B[23:8] de ffff ate 0000");
        A   = 32'hffffffff;
        B   = 32'hffffffff;
        Cin = 1'b1;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (B[23:8] > 16'h0000) begin
                B[23:8] = B[23:8] - 16'h0001;
            end else begin
                done = 1'b1;
            end
        end
        $display("sucesso: teste 11 executado sem erro");

        $display("\nTeste 12: inicializa todos os bits de entrada com 1 e varre o conjunto B[15:0] de ffff ate 0000");
        A   = 32'hffffffff;
        B   = 32'hffffffff;
        Cin = 1'b1;
        done   = 1'b0;
        while(done == 1'b0) #(1) begin
            if((Result != result_tb) || (Cout != Cout_tb)) begin
                $display("Erro:     A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, Result,    Cout);
                $display("Esperado: A=h%8h B=h%8h Cin=b%1b Result=h%8h Cout=b%1b", A, B, Cin, result_tb, Cout_tb);
                $finish;
            end else if (B[15:0] > 16'h0000) begin
                B[15:0] = B[15:0] - 16'h0001;
            end else begin
                done = 1'b1;
            end
        end
        $display("Sucesso: teste 12 executado sem erro");
        $finish;
    end
endmodule
