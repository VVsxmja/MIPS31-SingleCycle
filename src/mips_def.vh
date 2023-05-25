// ALU Definitions
//
// - give names to control codes sent into ALU.
//
// - represents the actual operation to be performed
//   by ALU. different instructions could generate
//   same control codes.

`define ALU_nop     8'd0
`define ALU_add     8'd1
`define ALU_addu    8'd2
`define ALU_sub     8'd3
`define ALU_subu    8'd4
`define ALU_mul     8'd5    // not implemented
`define ALU_mulu    8'd6    // not implemented
`define ALU_div     8'd7    // not implemented
`define ALU_divu    8'd8    // not implemented
`define ALU_slt     8'd9
`define ALU_sltu    8'd10
`define ALU_and     8'd11
`define ALU_or      8'd12
`define ALU_xor     8'd13
`define ALU_nor     8'd14
`define ALU_passa   8'd15
`define ALU_passb   8'd16
`define ALU_sll     8'd17
`define ALU_srl     8'd18
`define ALU_sra     8'd19
// `define ALU_   8'd

// Instruction related definitions

`define OPCODEtype_r      6'b000000
`define OPCODE_addi       6'b001000
`define OPCODE_addiu      6'b001001
`define OPCODE_andi       6'b001100
`define OPCODE_ori        6'b001101
`define OPCODE_xori       6'b001110
`define OPCODE_lw         6'b100011
`define OPCODE_sw         6'b101011
`define OPCODE_beq        6'b000100
`define OPCODE_bne        6'b000101
`define OPCODE_slti       6'b001010
`define OPCODE_sltiu      6'b001011
`define OPCODE_lui        6'b001111
`define OPCODE_j          6'b000010
`define OPCODE_jal        6'b000011
// `define OPCODE_        6'b0


`define FUNC_add          6'b100000
`define FUNC_addu         6'b100001
`define FUNC_sub          6'b100010
`define FUNC_subu         6'b100011
`define FUNC_and          6'b100100
`define FUNC_or           6'b100101
`define FUNC_xor          6'b100110
`define FUNC_nor          6'b100111
`define FUNC_slt          6'b101010
`define FUNC_sltu         6'b101011
`define FUNC_sll          6'b000000
`define FUNC_srl          6'b000010
`define FUNC_sra          6'b000011
`define FUNC_sllv         6'b000100
`define FUNC_srlv         6'b000110
`define FUNC_srav         6'b000111
`define FUNC_jr           6'b001000
// `define FUNC_          6'b0

// source of port A of ALU
`define ALU_srcA_regout1  3'd0
`define ALU_srcA_shamt    3'd1

// source of port B of ALU
`define ALU_srcB_regout2  3'd0
`define ALU_srcB_signext  3'd1
`define ALU_srcB_zeroext  3'd2
`define ALU_srcB_high16   3'd3

// source of REG WRITE operation
`define REG_w_src_ALU     3'd0
`define REG_w_src_MEM     3'd1
`define REG_w_src_PC_inc  3'd2

// source of next PC
`define NPC_src_pc_inc    3'd0
`define NPC_src_branch    3'd1
`define NPC_src_jump      3'd2
`define NPC_src_jr        3'd3

// branch conditions
`define BRANCH_no_branch  3'd0
`define BRANCH_equal      3'd1
`define BRANCH_not_equal  3'd2