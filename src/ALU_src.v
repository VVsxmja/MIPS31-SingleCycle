module ALU_src_A(
  input [31:0] reg_out1,
  input [4:0] shamt,
  input [2:0] ALU_srcA,
  output reg [31:0] A
);
  `include "mips_def.vh"
  
  always @(*) begin
    case (ALU_srcA)
      `ALU_srcA_regout1          : A = reg_out1;
      `ALU_srcA_shamt            : A = shamt;
      default                    : A = 32'b0;
    endcase
  end
endmodule

module ALU_src_B(
  input [31:0] reg_out2,
  input [15:0] imm16,
  input [2:0] ALU_srcB,
  output reg [31:0] B
);
  `include "mips_def.vh"
  
  always @(*) begin
    case (ALU_srcB)
      `ALU_srcB_regout2          : B = reg_out2;
      `ALU_srcB_signext          : B = {{16{imm16[15]}}, imm16};
      `ALU_srcB_zeroext          : B = {16'b0, imm16};
      `ALU_srcB_high16           : B = {imm16, 16'b0};
      default                    : B = 32'b0;
    endcase
  end
endmodule