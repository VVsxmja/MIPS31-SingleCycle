module pcreg(
  input clk,
  input rst,
  input [31:0] NPC_out,
  output [31:0] pc
);
  reg [31:0] pc_reg;
  
  assign pc = pc_reg;
  
  always @ (negedge clk or posedge rst) begin
    if (rst) begin 
      pc_reg = 32'h00400000;
    end else if (!clk) begin
      pc_reg = NPC_out;  
    end
  end
endmodule

module npc(
  input [31:0] pc_inc,
  input [31:0] ALU_out,
  input [15:0] offset,
  input [25:0] instr_index,
  input [2:0] NPC_src,
  input [2:0] NPC_branch_cond,
  output reg [31:0] NPC_out
);
  `include "mips_def.vh"
  
  wire [31:0] npc_branch;
  wire [31:0] npc_jump;
  
  pc_branch _pc_branch(
    .pc_inc              (pc_inc),
    .branch_cond         (NPC_branch_cond),
    .offset              (offset),
    .ALU_out             (ALU_out),
    .npc                 (npc_branch)
  );
  
  pc_jump _pc_jump(
    .pc_inc              (pc_inc),
    .instr_index         (instr_index),
    .npc                 (npc_jump)
  );
  
       
  always @(*) begin
    case (NPC_src)
      `NPC_src_pc_inc    : NPC_out = pc_inc;
      `NPC_src_branch    : NPC_out = npc_branch;
      `NPC_src_jump      : NPC_out = npc_jump;
      `NPC_src_jr        : NPC_out = ALU_out;
      default            : NPC_out = pc_inc;
    endcase
  end
endmodule

module pc_inc4(
  input [31:0] pc,
  output [31:0] pc_inc
);
  assign pc_inc = pc + 4;
endmodule

module pc_branch(
  input [31:0] pc_inc,
  input [2:0] branch_cond,
  input [15:0] offset,
  input [31:0] ALU_out,
  output reg [31:0] npc
);
  `include "mips_def.vh"
    
  // signed ext of (offset << 2)
  wire [31:0] ext_offset = {{14{offset[15]}}, offset, 2'b00};
  
  reg cond;
  
  // calculate cond for branch
  always @(*) begin
    case (branch_cond)
      `BRANCH_equal           : cond = (ALU_out == 0) ? 1'b1 : 1'b0;
      `BRANCH_not_equal       : cond = (ALU_out == 0) ? 1'b0 : 1'b1;
      default                 : cond = 0;
    endcase
    npc = pc_inc + (cond ? ext_offset : 32'b0);
  end
endmodule

module pc_jump(
  input [31:0] pc_inc,
  input [25:0] instr_index,
  output [31:0] npc
);
  assign npc = {pc_inc[31:28], instr_index, 2'b00};
endmodule