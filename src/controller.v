module controller(
  input [5:0] opcode,
  input [4:0] rd,
  input [4:0] rs,
  input [4:0] rt,
  input [15:0] immediate,
  input [25:0] instr_index,
  input [4:0] sa,    
  input [5:0] func,
  output reg [2:0] NPC_src,
  output reg [2:0] NPC_branch_cond,
  output reg [7:0] ALU_operation,
  output reg [2:0] ALU_srcA,
  output reg [2:0] ALU_srcB,
  output reg [4:0] REG_wid,
  output reg [2:0] REG_w_src,
  output reg MEM_write
);
  `include "mips_def.vh"
  
  // calculate operation code for ALU
  always @ (*) begin
    case (opcode)
      `OPCODEtype_r     : begin
        case (func)
          `FUNC_add     : ALU_operation = `ALU_add;
          `FUNC_addu    : ALU_operation = `ALU_addu;
          `FUNC_sub     : ALU_operation = `ALU_sub;
          `FUNC_subu    : ALU_operation = `ALU_subu;
          `FUNC_and     : ALU_operation = `ALU_and;
          `FUNC_or      : ALU_operation = `ALU_or;
          `FUNC_xor     : ALU_operation = `ALU_xor;
          `FUNC_nor     : ALU_operation = `ALU_nor;
          `FUNC_slt     : ALU_operation = `ALU_slt;
          `FUNC_sltu    : ALU_operation = `ALU_sltu;
          `FUNC_sll     : ALU_operation = `ALU_sll;
          `FUNC_srl     : ALU_operation = `ALU_srl;
          `FUNC_sra     : ALU_operation = `ALU_sra;
          `FUNC_sllv    : ALU_operation = `ALU_sll;
          `FUNC_srlv    : ALU_operation = `ALU_srl;
          `FUNC_srav    : ALU_operation = `ALU_sra;
          `FUNC_jr      : ALU_operation = `ALU_passa;
          default       : ALU_operation = `ALU_nop;
        endcase
      end
      `OPCODE_addi      : ALU_operation = `ALU_add;      //
      `OPCODE_addiu     : ALU_operation = `ALU_addu;     //
      `OPCODE_andi      : ALU_operation = `ALU_and;      //
      `OPCODE_ori       : ALU_operation = `ALU_or;       //
      `OPCODE_xori      : ALU_operation = `ALU_xor;      //
      `OPCODE_lw        : ALU_operation = `ALU_addu;     // for address offset calculation
      `OPCODE_sw        : ALU_operation = `ALU_addu;     // for address offset calculation
      `OPCODE_beq       : ALU_operation = `ALU_subu;     // comparison
      `OPCODE_bne       : ALU_operation = `ALU_subu;     //
      `OPCODE_slti      : ALU_operation = `ALU_slt;      //
      `OPCODE_sltiu     : ALU_operation = `ALU_sltu;     //
      `OPCODE_lui       : ALU_operation = `ALU_passb;    //
      `OPCODE_j         : ALU_operation = `ALU_addu;     //
      `OPCODE_jal       : ALU_operation = `ALU_addu;     //
      default           : ALU_operation = `ALU_nop;      //
    endcase
  end
  
  // calculate source of next PC
  always @(*) begin
    case (opcode)
      `OPCODEtype_r     : begin
        case (func)
          `FUNC_jr      : NPC_src = `NPC_src_jr;
          default       : NPC_src = `NPC_src_pc_inc;
        endcase
      end
      `OPCODE_beq       : NPC_src = `NPC_src_branch;
      `OPCODE_bne       : NPC_src = `NPC_src_branch;
      `OPCODE_j         : NPC_src = `NPC_src_jump;
      `OPCODE_jal       : NPC_src = `NPC_src_jump;
      default           : NPC_src = `NPC_src_pc_inc;
    endcase
  end
      
  // calculate branch condition type
  always @(*) begin
    case (opcode)
      `OPCODE_beq       : NPC_branch_cond = `BRANCH_equal;
      `OPCODE_bne       : NPC_branch_cond = `BRANCH_not_equal;
      default           : NPC_branch_cond = `BRANCH_no_branch;
    endcase
  end
  
  // calculate ALU_srcA/B
  always @ (*) begin
    case (opcode)
      `OPCODEtype_r     : begin
        case (func)
          `FUNC_sll     : ALU_srcA = `ALU_srcA_shamt;
          `FUNC_srl     : ALU_srcA = `ALU_srcA_shamt;
          `FUNC_sra     : ALU_srcA = `ALU_srcA_shamt;
          default       : ALU_srcA = `ALU_srcA_regout1;
        endcase
      end
      default           : ALU_srcA = `ALU_srcA_regout1;
    endcase
  end
  
  always @ (*) begin
    case (opcode)
      `OPCODE_addi      : ALU_srcB = `ALU_srcB_signext;
      `OPCODE_addiu     : ALU_srcB = `ALU_srcB_signext;
      `OPCODE_andi      : ALU_srcB = `ALU_srcB_zeroext;
      `OPCODE_ori       : ALU_srcB = `ALU_srcB_zeroext;
      `OPCODE_xori      : ALU_srcB = `ALU_srcB_zeroext;
      `OPCODE_lw        : ALU_srcB = `ALU_srcB_signext;
      `OPCODE_sw        : ALU_srcB = `ALU_srcB_signext;
      `OPCODE_slti      : ALU_srcB = `ALU_srcB_signext;
      `OPCODE_sltiu     : ALU_srcB = `ALU_srcB_signext;
      `OPCODE_lui       : ALU_srcB = `ALU_srcB_high16 ;
      default           : ALU_srcB = `ALU_srcB_regout2;
    endcase
  end
  
  // calculate REG_wid
  always @ (*) begin
    case (opcode)
      `OPCODEtype_r     : begin
        case (func)
          `FUNC_add     : REG_wid = rd;  
          `FUNC_addu    : REG_wid = rd;  
          `FUNC_sub     : REG_wid = rd;  
          `FUNC_subu    : REG_wid = rd;  
          `FUNC_and     : REG_wid = rd;  
          `FUNC_or      : REG_wid = rd;  
          `FUNC_xor     : REG_wid = rd;  
          `FUNC_nor     : REG_wid = rd;  
          `FUNC_slt     : REG_wid = rd;  
          `FUNC_sltu    : REG_wid = rd;  
          `FUNC_sll     : REG_wid = rd;  
          `FUNC_srl     : REG_wid = rd;  
          `FUNC_sra     : REG_wid = rd;  
          `FUNC_sllv    : REG_wid = rd;  
          `FUNC_srlv    : REG_wid = rd;  
          `FUNC_srav    : REG_wid = rd;  
          `FUNC_jr      : REG_wid = 5'b0;
          default       : REG_wid = 5'b0;
        endcase
      end
      `OPCODE_addi      : REG_wid = rt;  
      `OPCODE_addiu     : REG_wid = rt;  
      `OPCODE_andi      : REG_wid = rt;  
      `OPCODE_ori       : REG_wid = rt;  
      `OPCODE_xori      : REG_wid = rt;  
      `OPCODE_lw        : REG_wid = rt;  
      `OPCODE_sw        : REG_wid = 5'b0;
      `OPCODE_beq       : REG_wid = 5'b0;
      `OPCODE_bne       : REG_wid = 5'b0;
      `OPCODE_slti      : REG_wid = rt;  
      `OPCODE_sltiu     : REG_wid = rt;  
      `OPCODE_lui       : REG_wid = rt;  
      `OPCODE_j         : REG_wid = 5'b0;
      `OPCODE_jal       : REG_wid = 5'd31;
      default           : REG_wid = 5'b0;
    endcase
  end
  
  
  // control whether to write ALU_out or MEM_out to regfile
  always @ (*) begin
    case (opcode)
      `OPCODE_lw        : REG_w_src = `REG_w_src_MEM;
      `OPCODE_jal       : REG_w_src = `REG_w_src_PC_inc;
      default           : REG_w_src = `REG_w_src_ALU;
    endcase
  end
      
  // control whether to write or read dmem
  always @ (*) begin
    case (opcode)
      `OPCODE_sw        : MEM_write = 1;
      default           : MEM_write = 0;
    endcase
  end
endmodule