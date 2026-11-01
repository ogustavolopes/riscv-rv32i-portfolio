`timescale 1ns / 100ps 
// Unidade de controle do sistema
module control( 
	input wire [6:0] op,		//opcode da instrução
	input wire [2:0] funct3,    //funct3 da instrução
	input wire funct7b5, 		//Bit 5 do funct7 da instrução
	output wire ResultSrcD,//Sinal de seleção do Mux do resultado			
	output wire	MemWriteD, 		//Sinal do Write Enable da memória
	output wire ALUSrcD, 		//Sinal de seleção do Mux da ALU
	output wire RegWriteD, 		//Sinal do Write Enable do banco de registradores
	output wire BranchD,			//Sinal de desvio condicional
	output wire [1:0] ImmSrcD,	//Sinal de seleção do Extend
	output reg [2:0] ALUControlD //Sinal de controle da ALU  
);  
	reg [8:0] control_signals;  //Sinais pro decodificador principal
	wire [1:0] ALUop;           //Sinal pro decodificador da ALU
	wire RtypeSub;              //Sinais pro decodificador da ALU do R-type
	
  	assign RtypeSub = funct7b5 & op[5]; //TRUE for R-type substract

	always@(*) begin
		case(op)
			7'b0000011: control_signals = 9'b1_00_1_0_1_0_00;  //lw
			7'b0100011: control_signals = 9'b0_01_1_1_x_0_00;  //sw
			7'b0110011: control_signals = 9'b1_xx_0_0_0_0_10;  //R-type
			7'b1100011: control_signals = 9'b0_10_0_0_x_1_01;  //beq
			7'b0010011: control_signals = 9'b1_00_1_0_0_0_10;  //I-type ALU
			7'b0000000: control_signals = 9'b0_00_0_0_0_0_00;  //reset conditionm
			default:control_signals     = 9'bx_xx_x_x_x_x_xx;
		endcase
	end

	assign {RegWriteD,ImmSrcD,ALUSrcD,MemWriteD,ResultSrcD,BranchD,ALUop} = control_signals;  //Desestruturação dos sinais de controle
   
    always@(*) begin
		case(ALUop) 
			2'b00: ALUControlD = 3'b000; //Addition (lw, sw, addi)
			2'b01: ALUControlD = 3'b001; //Subtraction (beq)
			2'b10:
				case(funct3)//R-type 
					3'b000:    
						if (RtypeSub) ALUControlD = 3'b001; //Sub
						else ALUControlD = 3'b000;          //Add
					3'b010: ALUControlD = 3'b101;           //Slt 
					3'b110: ALUControlD = 3'b011;           //Or
					3'b111: ALUControlD = 3'b010;           //And
					default: ALUControlD = 3'bxxx; 
				endcase
			default: ALUControlD = 3'bxxx;
		endcase
  	end

endmodule