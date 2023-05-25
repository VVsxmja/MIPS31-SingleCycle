module regfile(
  input clk,
  input rst,
  input [4:0] write_id,
  input [31:0] write_input,
  input [4:0] read_id1,
  input [4:0] read_id2,
  output [31:0] read_output1,
  output [31:0] read_output2
);
  // the actual registers.
  // 
  // - for outputs, r0 is always 0, and the actual r[0]
  //   is never used during reading. 
  // 
  // - for inputs, anything written into r[0] is regarded.
  reg [31:0] array_reg [31:0];

  // r0 is hardwired to zero.
  wire r0;
  assign r0 = 0;
  
  // - in MIPS, an instruction can read no more than 2 
  //   regs at the same time, so providing 2 output is enough.
  // 
  // - if read_id == 0, output hardwired zero.
  assign read_output1 = read_id1 ? array_reg[read_id1] : r0;
  assign read_output2 = read_id2 ? array_reg[read_id2] : r0;
  
  // loop variable.
  integer i;
  
  always @ (posedge clk or posedge rst) begin
    if (rst == 1) begin
      // reset: set all regs with 0.
      for (i = 0; i < 32; i = i + 1) begin
        array_reg[i] = 0;
      end
    end else if (write_id != 0) begin
      // write if write_id != 0.
      array_reg[write_id] = write_input;
    end
  end
endmodule