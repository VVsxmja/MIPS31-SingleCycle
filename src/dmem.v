module dmem(
  input clk,
  input rst,
  input mem_write,
  input [10:0] addr,
  input [31:0] wdata,
  output [31:0] rdata
);
  reg [31:0] mem [0:2047];
  
  integer i;
  
	always @(posedge clk or posedge rst) begin
		if (rst) begin
          for (i = 0; i <= 2047; i = i + 1) begin
            mem[i] = 32'b0;
          end
		end else if (mem_write) begin
			mem[addr] = wdata;
		end
	end
	
	assign rdata = mem[addr];
endmodule