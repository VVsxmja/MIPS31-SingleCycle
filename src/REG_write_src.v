module REG_write_src(
  input [31:0] ALU_out,
  input [31:0] MEM_out,
  input [31:0] pc_inc,
  input [2:0] REG_w_src,
  output reg [31:0] REG_wdata
);
  `include "mips_def.vh"
  
  always @ (*) begin
    case (REG_w_src)
      `REG_w_src_ALU    : REG_wdata = ALU_out;
      `REG_w_src_MEM    : REG_wdata = MEM_out;
      `REG_w_src_PC_inc : REG_wdata = pc_inc;
      default           : REG_wdata = 32'b0;
    endcase
  end
endmodule