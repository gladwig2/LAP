// DESCRIPTION: LAP core
//
module core (/*AUTOARG*/
   // Outputs
   passed,
   // Inputs
   clk,mclk,reset
   );

   input clk;
   input mclk;
   input reset;
   output passed;

   import proj_pkgs::*;

   parameter Xmax = LAP_N;
   parameter Ymax = LAP_N;
   
   dbus_t dx[Xmax][Ymax];
   dbus_t dy[Xmax][Ymax];

   genvar x,y;
   generate
      for (x = 0; x < Xmax; x = x+1) begin : pex
	 sram #(.MEM_INIT_FILE("Aop.txt"),.ADDR_WIDTH(LAP_AOP_CACHE_ADR_BITS), 
		.DATA_WIDTH(LAP_SA_ALUWIDTH)) 
	 aram(.rclk(clk), .radr(abus[x].adr), .ren(abus[x].rd), .rdata(dx[0][x].data),
	      .wclk(mclk), .wadr(0), .wen(0), .wdata(0));
	 
	 sram #(.MEM_INIT_FILE("Bop.txt"),.ADDR_WIDTH(LAP_BOP_CACHE_ADR_BITS), 
		.DATA_WIDTH(LAP_SA_ALUWIDTH)) 
	 bram(.rclk(clk), .radr(bbus[x].adr), .ren(bbus[x].rd), .rdata(dy[x][0].data),
	      .wclk(mclk), .wadr(0), .wen(0), .wdata(0));

         sram #(.MEM_INIT_FILE("Cop.txt"),.ADDR_WIDTH(LAP_COP_CACHE_ADR_BITS), 
		.DATA_WIDTH(LAP_SA_ALUWIDTH)) 
	 cram(.rclk(clk), .radr(0), .ren(0), .rdata(),
	      .wclk(clk), .wadr(cbus[x].adr), .wen(cbus[x].wr), .wdata(dy[x][Ymax].data));

	 for (y = 0; y < Ymax; y = y+1) begin : pey
	    pe pe(.clk(clk), 
		  .up(dy[x][y]), 
		  .down(dy[x][y+1]), 
		  .left(dx[x][y]), 
		  .right(dx[x+1][y]));
	 end
      end
   endgenerate

   abus_t abus[LAP_N];
   bbus_t bbus[LAP_N];   
   cbus_t cbus[LAP_N];

   sa_inst_t finst;
   assign finst = '{ 0,0,32'hAAAA,32'hBBBB,16'hCCCC,32'hDDDD,LAP_N-1};
   logic ifavail, ifrd;
   assign ifavail = 1'b1;
   
   vinst_ctl vctl0 (.clk(clk), .reset(reset), 
		  .inst(finst), .iavail(ifavail),
		  .ird(ifrd),
		  .abus(abus[0]), .bbus(bbus[0]), .cbus(cbus[0]));

   always_ff @(posedge clk) begin
      for (int i=0; i<LAP_N-1; i++) begin
	 abus[i+1] <= abus[i]; // stage busses
	 bbus[i+1] <= bbus[i]; // 
	 cbus[i+1] <= cbus[i]; // FIX
      end
//      abus[LAP_N-1:1] <= abus[LAP_N-2:0];
//      bbus[LAP_N-1:1] <= bbus[LAP_N-2:0];
//      cbus[LAP_N-1:1] <= cbus[LAP_N-2:0]; // fix
   end
     
   
   reg [31:0] count_c;
   reg [31:0] count_f;
   
//   always @ (posedge clk) begin
   always_ff @(posedge clk)  begin
      if (!reset) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 count_c <= 32'h0;
	 // End of automatics
      end else begin
	 count_c <= count_c + 1;
      end
   end
   
   always @ (posedge clk) begin
      if (!reset) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 count_f <= 32'h0;
	 passed <= 1'h0;
	 // End of automatics
      end else begin
	 count_f <= count_f + 1;
	 if (count_f == 5) passed <= 1'b1;
      end
   end // always @ (posedge clk)

endmodule
