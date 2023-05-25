module sccomp_dataflow(
  input clk_in,
  input reset,
  output [31:0] inst,
  output [31:0] pc
);
  wire [31:0] imem_rdata;
  wire [31:0] dmem_rdata;
  wire [31:0] pcreg_out;
  wire dmem_write;
  wire [10:0] dmem_addr;
  wire [31:0] dmem_wdata;
  
  assign inst = imem_rdata;
  assign pc = pcreg_out;
  
  // this CPU is Harvard architechture. we map pc and dmem_addr
  // in order to test with MARS (von neumann architechture)
  wire [31:0] mapped_pc = (pcreg_out - 32'h00400000) >> 2;
  wire [31:0] mapped_dmem_addr = dmem_addr - 32'h10010000;

  // according to homework spec, cpu must be named sccpu
  cpu sccpu(
    .clk        (clk_in),
    .rst        (reset),
    .inst       (imem_rdata),
    .MEM_rdata  (dmem_rdata),
    .pc         (pcreg_out),
    .MEM_write  (dmem_write),
    .MEM_addr   (dmem_addr),
    .MEM_wdata  (dmem_wdata)
  );
  
  dmem _dmem(
    .clk        (clk_in),
    .rst        (reset),
    .mem_write  (dmem_write),
    .addr       (dmem_addr),
    .wdata      (dmem_wdata),
    .rdata      (dmem_rdata)
  );
  
  imem _imem(
    .a          (mapped_pc),
    .spo        (imem_rdata)
  );
  
endmodule