module cpu(
  input clk,
  input rst,
  input [31:0] inst,
  input [31:0] MEM_rdata,
  output [31:0] pc,
  output MEM_write,
  output [31:0] MEM_addr,
  output [31:0] MEM_wdata
);
  // opcode = 6-bit primary operation code.
  wire [5:0] opcode = inst[31:26];
  
  // rd = 5-bit specifier for the destination register.
  wire [4:0] rd = inst[15:11];
    
  // rs = 5-bit specifier for the source register.
  wire [4:0] rs = inst[25:21];
      
  // rt = 5-bit specifier for the target 
  //      (source/destination) register or used to specify 
  //      functions within the primary opcode REGIMM.
  wire [4:0] rt = inst[20:16];
  
  // immediate = 16-bit signed immediate used for logical 
  //             operands, arithmetic signed operands, 
  //             load/store address byte offsets, and 
  //             PC-relative branch signed instruction 
  //             displacement.
  wire [15:0] immediate = inst[15:0];
  
  // instr_index = 26-bit index shifted left two bits 
  //               to supply the low-order 28 bits of 
  //               the jump target address.
  wire [25:0] instr_index = inst[25:0];
  
  // sa = 5-bit shift amount.
  wire [4:0] sa = inst[10:6];
  
  // func = 6-bit function field used to specify 
  //        functions within the primary opcode SPECIAL.
  wire [5:0] func = inst[5:0];
  
  wire [7:0] ALU_operation;
  wire [2:0] ALU_srcA;
  wire [2:0] ALU_srcB;
  
  wire [31:0] REG_out1; // into ALU_A
  wire [31:0] REG_out2; // into ALU_B or MEM_WDATA
  
  wire [31:0] ALU_A;
  wire [31:0] ALU_B;
  
  wire [31:0] ALU_out;
  wire ALU_overflow;
  wire ALU_zero;
  
  assign MEM_wdata = REG_out2;
  assign MEM_addr = ALU_out;
  
  wire [4:0] REG_wid;
  wire [31:0] REG_wdata;
  wire [2:0] REG_w_src;
  
  wire [31:0] PC_wdata;
  wire [31:0] PC_rdata;
  wire [31:0] pc_inc;
  assign pc = PC_rdata;
  
  wire [2:0] NPC_src;
  wire [2:0] NPC_branch_cond;
  
  controller _controller(
    .opcode                (opcode),                // 
    .rd                    (rd),                    // 
    .rs                    (rs),                    // 
    .rt                    (rt),                    // 
    .immediate             (immediate),             // 
    .instr_index           (instr_index),           // 
    .sa                    (sa),                    // 
    .func                  (func),                  // 
    .NPC_src               (NPC_src),               // >---------------
    .NPC_branch_cond       (NPC_branch_cond),       //                |
    .ALU_operation         (ALU_operation),         // >--------------|---
    .ALU_srcA              (ALU_srcA),              // >------------  |  |
    .ALU_srcB              (ALU_srcB),              // >-----------|  |  |
    .REG_wid               (REG_wid),               //             |  |  |
    .REG_w_src             (REG_w_src),             //             |  |  |
    .MEM_write             (MEM_write)              //             |  |  |
  );                                                //             |  |  |
                                                    //             |  |  |
  pcreg _pcreg(                                     //             |  |  |
    .clk                   (clk),                   //             |  |  |
    .rst                   (rst),                   //             |  |  |
    .NPC_out               (PC_wdata),              // <--------   |  |  |
    .pc                    (PC_rdata)               // >-----  |   |  |  |
  );                                                //      |  |   |  |  |
                                                    //      |  |   |  |  |
  pc_inc4 _pc_inc4(                                 //      |  |   |  |  |
    .pc                    (PC_rdata),              // <-----  |   |  |  |
    .pc_inc                (pc_inc)                 // >-----  |   |  |  |
  );                                                //      |  |   |  |  |
                                                    //      |  |   |  |  |
  npc _npc(                                         //      |  |   |  |  |
    .pc_inc                (pc_inc),                // <-----  |   |  |  |
    .ALU_out               (ALU_out),               // <-------|---|--|--|---
    .offset                (immediate),             //         |   |  |  |  |
    .instr_index           (instr_index),           //         |   |  |  |  |
    .NPC_src               (NPC_src),               // <-------|---|---  |  |
    .NPC_branch_cond       (NPC_branch_cond),       //         |   |     |  |
    .NPC_out               (PC_wdata)               // >--------   |     |  |
  );                                                //             |     |  |
                                                    //             |     |  |
  // according to homework spec, regfile must be named cpu_ref     |     |  |
  regfile cpu_ref(                                  //             |     |  |
    .clk                   (clk),                   //             |     |  |
    .rst                   (rst),                   //             |     |  |
    .write_id              (REG_wid),               //             |     |  |
    .write_input           (REG_wdata),             // <-----------|---  |  |
    .read_id1              (rs),                    //             |  |  |  |
    .read_id2              (rt),                    //             |  |  |  |
    .read_output1          (REG_out1),              // >----       |  |  |  |
    .read_output2          (REG_out2)               // >---|----   |  |  |  |
  );                                                //     |   |   |  |  |  |
                                                    //     |   |   |  |  |  |
  ALU_src_A _ALU_src_A(                             //     |   |   |  |  |  |
    .reg_out1              (REG_out1),              // <----   |   |  |  |  |
    .shamt                 (sa),                    //         |   |  |  |  |
    .ALU_srcA              (ALU_srcA),              // <-------|---|  |  |  |
    .A                     (ALU_A)                  //         |   |  |  |  |
  );                                                //         |   |  |  |  |
                                                    //         |   |  |  |  |
  ALU_src_B _ALU_src_B(                             //         |   |  |  |  |
    .reg_out2              (REG_out2),              // <--------   |  |  |  |
    .imm16                 (immediate),             //             |  |  |  |
    .ALU_srcB              (ALU_srcB),              // <------------  |  |  |
    .B                     (ALU_B)                  //                |  |  |
  );                                                //                |  |  |
                                                    //                |  |  |
  ALU _ALU(                                         //                |  |  |
    .clk                   (clk),                   //                |  |  |
    .rst                   (rst),                   //                |  |  |
    .A                     (ALU_A),                 //                |  |  |
    .B                     (ALU_B),                 //                |  |  |
    .operation             (ALU_operation),         // <--------------|---  |
    .result                (ALU_out),               // >--------------|------
    .overflow              (ALU_overflow),          //                |     |
    .zero                  (ALU_zero)               //                |     |
  );                                                //                |     |
                                                    //                |     |
  REG_write_src _REG_write_src(                     //                |     |
    .ALU_out               (ALU_out),               // <--------------|------
    .MEM_out               (MEM_rdata),             //                |
    .REG_w_src             (REG_w_src),             //                |
    .pc_inc                (pc_inc),                //                |
    .REG_wdata             (REG_wdata)              // >---------------
  );                                                // 
  
endmodule