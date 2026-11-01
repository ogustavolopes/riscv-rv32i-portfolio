`timescale 1ns / 100ps 
// Registro de pipeline MEM/WB
module mem_wb_reg(
    input clk, reset, RegWriteM, ResultSrcM,
    input [4:0] RdM,
    input [31:0] AluResultM, ReadDataM,
    output reg RegWriteW, ResultSrcW,
    output reg [4:0] RdW,
    output reg [31:0] AluResultW, ReadDataW    
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            AluResultW <= 32'h00000000;
            ReadDataW <= 32'h00000000;
            RegWriteW <= 0;
            ResultSrcW <= 1'b0;
            RdW <= 5'b00000;
        end
        else begin
            AluResultW <= AluResultM;
            ReadDataW <= ReadDataM;
            RegWriteW <= RegWriteM;
            ResultSrcW <= ResultSrcM;
            RdW <= RdM;
        end
    end

endmodule