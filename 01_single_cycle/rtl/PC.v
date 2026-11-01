module PC (	
	input wire clk,reset,
	input wire [31:0] PCNext,
	output wire [31:0] PC 
);
  reg [31:0] PCReg;

  always@(posedge clk or posedge reset) begin
	  if (reset) PCReg <= 32'h1000;
	  else PCReg <= PCNext;
  end	
  
  assign PC = PCReg;
endmodule