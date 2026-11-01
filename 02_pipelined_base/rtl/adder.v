`timescale 1ns / 100ps
// Somador de 32 bits utilizando arvore de Sklansky
// referencias: slide 7 da aula 31 (sd122) e pag. 242 do livro risc-v
module adder(
    input  wire [31:0] A,
    input  wire [31:0] B,
    input  wire        Cin,
    output wire [31:0] Result,
    output wire        Cout
);
    wire [31:0] g_ab = A & B;   // generate individual: sinaliza se o bit deve acionar o carry-in do bit seguinte
    wire [31:0] p_ab = A ^ B;   // propagate individual: sinaliza se o carry_in do bit pode acionar o carry-in do bit seguinte
    wire [31:0] g_ci;           // generate combinado: sinaliza se o carry_in do bit foi acionado pelos bits anteriores

    assign g_ci[0] = Cin;                               // carry-in do bit 0
    assign g_ci[1] = g_ab[0] | (p_ab[0] & g_ci[0]);     // carry-in do bit 1
    assign g_ci[2] = g_ab[1] | (p_ab[1] & g_ci[1]);     // carry-in do bit 2

    wire   g_2_1   = g_ab[2] | (p_ab[2] & g_ab[1]);      
    wire   p_2_1   = p_ab[2] &  p_ab[1];                 
    assign g_ci[3] = g_2_1   | (p_2_1   & g_ci[1]);     // carry-in do bit 3
    assign g_ci[4] = g_ab[3] | (p_ab[3] & g_ci[3]);     // carry-in do bit 4

    wire   g_4_3   = g_ab[4] | (p_ab[4] & g_ab[3]);     
    wire   p_4_3   = p_ab[4] &  p_ab[3];                
    assign g_ci[5] = g_4_3   | (p_4_3   & g_ci[3]);     // carry-in do bit 5

    wire   g_5_3   = g_ab[5] | (p_ab[5] & g_4_3);       
    wire   p_5_3   = p_ab[5] &  p_4_3;                  
    assign g_ci[6] = g_5_3   | (p_5_3   & g_ci[3]);     // carry-in do bit 6

    wire   g_6_5   = g_ab[6] | (p_ab[6] & g_ab[5]);     
    wire   p_6_5   = p_ab[6] &  p_ab[5];                
    wire   g_6_3   = g_6_5   | (p_6_5   & g_4_3);       
    wire   p_6_3   = p_6_5   &  p_4_3;                  
    assign g_ci[7] = g_6_3   | (p_6_3   & g_ci[3]);     // carry-in do bit 7
    assign g_ci[8] = g_ab[7] | (p_ab[7] & g_ci[7]);     // carry-in do bit 8

    wire   g_8_7   = g_ab[8] | (p_ab[8] & g_ab[7]);
    wire   p_8_7   = p_ab[8] &  p_ab[7];
    assign g_ci[9] = g_8_7   | (p_8_7   & g_ci[7]);     // carry-in do bit 9

    wire   g_9_7    = g_ab[9] | (p_ab[9] & g_8_7);      
    wire   p_9_7    = p_ab[9] &  p_8_7;                         
    assign g_ci[10] = g_9_7   | (p_9_7   & g_ci[7]);    // carry-in do bit 10

    wire   g_10_9   = g_ab[10] | (p_ab[10] & g_ab[9]);                  
    wire   p_10_9   = p_ab[10] &  p_ab[9];                  
    wire   g_10_7   = g_10_9   | (p_10_9   & g_8_7);    
    wire   p_10_7   = p_10_9   &  p_8_7;                
    assign g_ci[11] = g_10_7   | (p_10_7   & g_ci[7]);  // carry-in do bit 11

    wire   g_11_7   = g_ab[11] | (p_ab[11] & g_10_7);
    wire   p_11_7   = p_ab[11] &  p_10_7;
    assign g_ci[12] = g_11_7   | (p_11_7   & g_ci[7]);  // carry-in do bit 12

    wire   g_12_11  = g_ab[12] | (p_ab[12] & g_ab[11]);
    wire   p_12_11  = p_ab[12] &  p_ab[11];
    wire   g_12_7   = g_12_11  | (p_12_11  & g_10_7);
    wire   p_12_7   = p_12_11  &  p_10_7;
    assign g_ci[13] = g_12_7   | (p_12_7   & g_ci[7]);  // carry-in do bit 13

    wire   g_13_11  = g_ab[13] | (p_ab[13] & g_12_11);
    wire   p_13_11  = p_ab[13] &  p_12_11;
    wire   g_13_7   = g_13_11  | (p_13_11  & g_10_7);
    wire   p_13_7   = p_13_11  &  p_10_7;
    assign g_ci[14] = g_13_7   | (p_13_7   & g_ci[7]);  // carry-in do bit 14

    wire   g_14_13  = g_ab[14] | (p_ab[14] & g_ab[13]);
    wire   p_14_13  = p_ab[14] &  p_ab[13];
    wire   g_14_11  = g_14_13  | (p_14_13  & g_12_11);
    wire   p_14_11  = p_14_13  &  p_12_11;
    wire   g_14_7   = g_14_11  | (p_14_11  & g_10_7);
    wire   p_14_7   = p_14_11  &  p_10_7;       
    assign g_ci[15] = g_14_7   | (p_14_7   & g_ci[7]);   // carry-in do bit 15
    assign g_ci[16] = g_ab[15] | (p_ab[15] & g_ci[15]);  // carry-in do bit 16

    wire   g_16_15  = g_ab[16] | (p_ab[16] & g_ab[15]);     
    wire   p_16_15  = p_ab[16] &  p_ab[15];     
    assign g_ci[17] = g_16_15  | (p_16_15  & g_ci[15]);  // carry-in do bit 17

    wire   g_17_15  = g_ab[17] | (p_ab[17] & g_16_15);      
    wire   p_17_15  = p_ab[17] &  p_16_15;      
    assign g_ci[18] = g_17_15  | (p_17_15  & g_ci[15]);  // carry-in do bit 18

    wire   g_18_17  = g_ab[18] | (p_ab[18] & g_ab[17]);     
    wire   p_18_17  = p_ab[18] &  p_ab[17];     
    wire   g_18_15  = g_18_17  | (p_18_17  & g_16_15);      
    wire   p_18_15  = p_18_17  &  p_16_15;      
    assign g_ci[19] = g_18_15  | (p_18_15  & g_ci[15]);  // carry-in do bit 19

    wire   g_19_15  = g_ab[19] | (p_ab[19] & g_18_15);      
    wire   p_19_15  = p_ab[19] &  p_18_15;      
    assign g_ci[20] = g_19_15  | (p_19_15  & g_ci[15]);  // carry-in do bit 20

    wire   g_20_19  = g_ab[20] | (p_ab[20] & g_ab[19]);     
    wire   p_20_19  = p_ab[20] &  p_ab[19];     
    wire   g_20_15  = g_20_19  | (p_20_19  & g_18_15);      
    wire   p_20_15  = p_20_19  &  p_18_15;      
    assign g_ci[21] = g_20_15  | (p_20_15  & g_ci[15]);  // carry-in do bit 21

    wire   g_21_19  = g_ab[21] | (p_ab[21] & g_20_19);      
    wire   p_21_19  = p_ab[21] &  p_20_19;      
    wire   g_21_15  = g_21_19  | (p_21_19  & g_18_15);      
    wire   p_21_15  = p_21_19  &  p_18_15;      
    assign g_ci[22] = g_21_15  | (p_21_15  & g_ci[15]);  // carry-in do bit 22

    wire   g_22_21  = g_ab[22] | (p_ab[22] & g_ab[21]);     
    wire   p_22_21  = p_ab[22] &  p_ab[21];     
    wire   g_22_19  = g_22_21  | (p_22_21  & g_20_19);      
    wire   p_22_19  = p_22_21  &  p_20_19;      
    wire   g_22_15  = g_22_19  | (p_22_19  & g_18_15);      
    wire   p_22_15  = p_22_19  &  p_18_15;      
    assign g_ci[23] = g_22_15  | (p_22_15  & g_ci[15]);  // carry-in do bit 23

    wire   g_23_15  = g_ab[23] | (p_ab[23] & g_22_15);      
    wire   p_23_15  = p_ab[23] &  p_22_15;      
    assign g_ci[24] = g_23_15  | (p_23_15  & g_ci[15]);  // carry-in do bit 24

    wire   g_24_23  = g_ab[24] | (p_ab[24] & g_ab[23]);
    wire   p_24_23  = p_ab[24] &  p_ab[23];
    wire   g_24_15  = g_24_23  | (p_24_23  & g_22_15);
    wire   p_24_15  = p_24_23  &  p_22_15;
    assign g_ci[25] = g_24_15  | (p_24_15  & g_ci[15]);  // carry-in do bit 25

    wire   g_25_23  = g_ab[25] | (p_ab[25] & g_24_23);
    wire   p_25_23  = p_ab[25] &  p_24_23;
    wire   g_25_15  = g_25_23  | (p_25_23  & g_22_15);
    wire   p_25_15  = p_25_23  &  p_22_15;
    assign g_ci[26] = g_25_15  | (p_25_15  & g_ci[15]);  // carry-in do bit 26

    wire   g_26_25  = g_ab[26] | (p_ab[26] & g_ab[25]);
    wire   p_26_25  = p_ab[26] &  p_ab[25];
    wire   g_26_23  = g_26_25  | (p_26_25  & g_24_23);
    wire   p_26_23  = p_26_25  &  p_24_23;
    wire   g_26_15  = g_26_23  | (p_26_23  & g_22_15);
    wire   p_26_15  = p_26_23  &  p_22_15;
    assign g_ci[27] = g_26_15  | (p_26_15  & g_ci[15]);  // carry-in do bit 27

    wire   g_27_23  = g_ab[27] | (p_ab[27] & g_26_23);
    wire   p_27_23  = p_ab[27] &  p_26_23;
    wire   g_27_15  = g_27_23  | (p_27_23  & g_22_15);
    wire   p_27_15  = p_27_23  &  p_22_15;
    assign g_ci[28] = g_27_15  | (p_27_15  & g_ci[15]);  // carry-in do bit 28

    wire   g_28_27  = g_ab[28] | (p_ab[28] & g_ab[27]);
    wire   p_28_27  = p_ab[28] &  p_ab[27];
    wire   g_28_23  = g_28_27  | (p_28_27  & g_26_23);
    wire   p_28_23  = p_28_27  &  p_26_23;
    wire   g_28_15  = g_28_23  | (p_28_23  & g_22_15);                      
    wire   p_28_15  = p_28_23  &  p_22_15;                          
    assign g_ci[29] = g_28_15  | (p_28_15  & g_ci[15]);  // carry-in do bit 29

    wire   g_29_27  = g_ab[29] | (p_ab[29] & g_28_27);
    wire   p_29_27  = p_ab[29] &  p_28_27;
    wire   g_29_23  = g_29_27  | (p_29_27  & g_26_23);
    wire   p_29_23  = p_29_27  &  p_26_23;
    wire   g_29_15  = g_29_23  | (p_29_23  & g_22_15);
    wire   p_29_15  = p_29_23  &  p_22_15;
    assign g_ci[30] = g_29_15  | (p_29_15  & g_ci[15]);  // carry-in do bit 30

    wire   g_30_29  = g_ab[30] | (p_ab[30] & g_ab[29]);
    wire   p_30_29  = p_ab[30] &  p_ab[29];
    wire   g_30_27  = g_30_29  | (p_30_29  & g_28_27);
    wire   p_30_27  = p_30_29  &  p_28_27;
    wire   g_30_23  = g_30_27  | (p_30_27  & g_26_23);
    wire   p_30_23  = p_30_27  &  p_26_23;
    wire   g_30_15  = g_30_23  | (p_30_23  & g_22_15);
    wire   p_30_15  = p_30_23  &  p_22_15;
    assign g_ci[31] = g_30_15  | (p_30_15  & g_ci[15]);  // carry-in do bit 31

    assign Result = p_ab ^ g_ci;                         // Resultado da operacao
    assign Cout = g_ab[31] | (p_ab[31] & g_ci[31]);      // carry-out da operacao
endmodule
