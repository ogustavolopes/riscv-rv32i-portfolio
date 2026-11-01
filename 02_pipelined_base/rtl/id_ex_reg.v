`timescale 1ns / 100ps 
// Registro de pipeline ID/EX
module id_ex_reg(
    input clk, reset, RegWriteD, MemWriteD, JumpD, BranchD, ALUSrcD, flush_CTRL_ID, ResultSrcD,
    input [2:0] ALUControlD,
    input [4:0] RdD,
    input [31:0] RD1D, RD2D, ImmExtD, PCD,
    output reg RegWriteE, MemWriteE, JumpE, BranchE, ALUSrcE, ResultSrcE,
    output reg [2:0] ALUControlE,
    output reg [4:0] RdE,
    output reg [31:0] RD1E, RD2E, ImmExtE, PCE
);

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            RegWriteE <= 0;
            MemWriteE <= 0;
            JumpE <= 0;
            BranchE <= 0;
            ALUSrcE <= 0;
            ResultSrcE <= 0;
            ALUControlE <= 3'b000;
            RdE <= 5'b00000;
            RD1E <= 32'h00000000;
            RD2E <= 32'h00000000;
            ImmExtE <= 32'h00000000;
            PCE <= 32'h00000000;
        end
        else if (flush_CTRL_ID) begin
            RegWriteE <= 0;
            MemWriteE <= 0;
            JumpE <= 0;
            BranchE <= 0;
            ALUSrcE <= 0;
            ResultSrcE <= 0;
            ALUControlE <= 3'b000;

            RdE <= RdD; 
            RD1E <= RD1D;
            RD2E <= RD2D;
            ImmExtE <= ImmExtD;
            PCE <= PCD;
        end
        else begin
            RegWriteE <= RegWriteD;
            MemWriteE <= MemWriteD;
            JumpE <= JumpD;
            BranchE <= BranchD;
            ALUSrcE <= ALUSrcD;
            ResultSrcE <= ResultSrcD;
            ALUControlE <= ALUControlD;
            RdE <= RdD;
            RD1E <= RD1D;
            RD2E <= RD2D;
            ImmExtE <= ImmExtD;
            PCE <= PCD;
        end
    end

endmodule