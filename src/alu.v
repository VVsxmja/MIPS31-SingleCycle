module ALU(
  input clk,
  input rst,
  input [31:0] A,
  input [31:0] B,
  input [7:0] operation, // see mips_def.vh
  output reg [31:0] result,
  output reg overflow, // not checked by cpu currently
  output reg zero // used by BEQ and BNE
);
  `include "mips_def.vh"
  
  // signed A, let verilog use signed compare
  wire signed [31:0] signedA = A;
  
  // signed B, let verilog use signed compare
  wire signed [31:0] signedB = B;
  
  // shift amount is A or sa, limited into 5 bits
  wire [4:0] shamt = A[4:0];
  
  // do calculation
  always @ (*) begin
    case (operation)
      `ALU_nop      : result = 32'b0;
      `ALU_add      : result = A + B;
      `ALU_addu     : result = A + B;
      `ALU_sub      : result = A - B;
      `ALU_subu     : result = A - B;
      `ALU_slt      : result = ((signedA < signedB) ? 32'd1 : 31'd0); 
      `ALU_sltu     : result = ((A < B) ? 32'd1 : 31'd0);
      `ALU_and      : result = A & B; 
      `ALU_or       : result = A | B; 
      `ALU_xor      : result = A ^ B; 
      `ALU_nor      : result = ~(A | B);
      `ALU_passa    : result = A; 
      `ALU_passb    : result = B;
      `ALU_sll      : result = B << shamt; 
      `ALU_srl      : result = B >> shamt; 
      `ALU_sra      : result = signedB >>> shamt; 
      default       : result = 32'b0; // should not happen
    endcase
  end
  
  // set zero if result is zero
  always @(*) begin
    zero = (result == 32'b0 ? 1'b1 : 1'b0);
  end
    
  // detect overflow for signed addition/subtraction operations
  always @(*) begin
    case (operation)
      `ALU_add      : overflow = ((A[31] ~^ B[31]) & (A[31] ^ result[31]));
      `ALU_sub      : overflow = ((A[31]  ^ B[31]) & (A[31] ^ result[31]));
      default       : overflow = 1'b0;
    endcase
  end
endmodule