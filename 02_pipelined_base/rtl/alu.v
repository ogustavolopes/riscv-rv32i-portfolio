`timescale 1ns / 100ps 
// Unidade Lógica e Aritmética (ALU)
module alu (
	input wire signed [31:0] A,          // Operando A (SrcA)
  input wire signed [31:0] B,          // Operando B (SrcB)      
	input wire signed [2:0] ALUControl,  // Sinal de controle da ALU (ALUControl)
	output wire signed Zero,             // Sinal de zero (Zero)
	output wire signed [31:0] Result     // Resultado da ALU (ALUResult)
);
  reg [31:0] ResultReg;
  wire [31:0] inv, Sum;       // Sinais auxiliares
  wire slt;                   // 

  assign inv = ALUControl[0] ? ~B : B;  // Inverte B se ALUControl[0] = 1
  assign Sum = A + inv + ALUControl[0]; // Soma ou subtração com Carry-In
  assign slt = (A < B) ? 1 : 0;          // Se A < B, seta pra 1
    
  always@(*)
    case(ALUControl)
      3'b000: ResultReg <= Sum;         // Add
      3'b001: ResultReg <= Sum;         // Sub
      3'b010: ResultReg <= A&B;         // And
      3'b011: ResultReg <= A|B;         // Or
      3'b101: ResultReg <= {31'b0,slt}; // Slt (Set on less than)
      default:  ResultReg <= 'bx;
    endcase

  assign Zero = (ResultReg == 32'b0);   // Sinal de zero
  assign Result = ResultReg;            // Resultado da ALU
endmodule 