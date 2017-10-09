// DESCRIPTION: LAP core
//
module core (/*AUTOARG*/
   // Outputs
   passed,
   // Inputs
   clk, mclk, reset
   );
   input clk;
   input mclk;
   input reset;
   output passed;

   import proj_pkgs::*;

   dbus_t    rb[LAP_N][LAP_N+1];   // row bus col N+1 not used
   dbus_t    cb[LAP_N+1][LAP_N];   // column bus
   sbus_t    sb[LAP_N];            // sum bus
   sbus_t    pb[LAP_N];            // parital bus

   rowaddr_t ra[LAP_N];            // array busses
   coladdr_t ca[LAP_N];   
   paraddr_t par[LAP_N];
   pawaddr_t paw[LAP_N];

   genvar x;
   generate
      for (x = 0; x < LAP_N; x = x+1) begin : gr // generate rams
	 sram #(.MEM_INIT_FILE("col.txt"),.ADDR_WIDTH(LAP_COL_CACHE_ADR_BITS), 
		.DATA_WIDTH(LAP_SA_ALUWIDTH)) 
	 cc(.rclk(clk), .radr(ca[x].adr), .ren(ca[x].rd), .rdata(cb[0][x].data),
	      .wclk(mclk), .wadr(0), .wen(0), .wdata(0));
	 
	 sram #(.MEM_INIT_FILE("row.txt"),.ADDR_WIDTH(LAP_ROW_CACHE_ADR_BITS), 
		.DATA_WIDTH(LAP_SA_ALUWIDTH)) 
	 rc(.rclk(clk), .radr(ra[x].adr), .ren(ra[x].rd), .rdata(rb[x][0].data),
	      .wclk(mclk), .wadr(0), .wen(0), .wdata(0));

         sram #(.MEM_INIT_FILE("part.txt"),.ADDR_WIDTH(LAP_PAR_CACHE_ADR_BITS), 
		.DATA_WIDTH(LAP_SA_ACCWIDTH)) 
	 pc(.rclk(clk), .radr(par[x].adr), .ren(par[x].rd), .rdata(pb[x].data),
	    .wclk(clk), .wadr(paw[x].adr), .wen(paw[x].wr), .wdata(sb[x].data));
	 // FIX when adding partial
      end // block: gr
   endgenerate

   assign cb[0][0].opcd = saop; // note, opcd on cb[0][0] not otherwise driven

   genvar r,c;
   generate
      for (r = 0; r < LAP_N; r = r+1) begin : rpe 
	 for (c = 0; c < LAP_N; c = c+1) begin : cpe
	    pe #(r,c) pe(.clk(clk),  
			 .up(cb[r][c]),   .down(cb[r+1][c]), 
			 .left(rb[r][c]), .right(rb[r][c+1]));
	 end
      end
   endgenerate

   genvar col;
   generate
      for (col = 0; col < LAP_N; col = col+1) begin : se
	 se se(.clk(clk), 
	       .up(cb[LAP_N][col]), .pb(pb[col]),   .down(sb[col]));
      end
   endgenerate

   sa_inst_t finst;
   pa_inst_t winst;
   assign finst = '{ 4'h5,32'hAAAA,32'hBBBB,16'hCCCC,32'hDDDD,LAP_N-1};
   logic ifavail, ifrd;
   assign ifavail = 1'b1;
   opcd_t saop;
   logic wload;
   
   vinst_ctl vctl0 (.clk(clk), .reset(reset), 
		  .inst(finst), .iavail(ifavail),
		  .ird(ifrd), .next(wload), .saop(saop), .oinst(winst),
		  .ca(ca[0]), .ra(ra[0]));

   always_ff @(posedge clk) begin // stage address
      for (int i=0; i<LAP_N-1; i++) begin
	 ra[i+1] <= ra[i]; 
	 ca[i+1] <= ca[i]; 
      end
   end
     
  winst_ctl wctl0(.clk(clk), .reset(reset), 
		  .inst(winst), .load(wload),
		  .next(), .oinst(),
		 .par(par[0]), .spaw(paw[0]));   

   always_ff @(posedge clk) begin // stage address
      for (int i=0; i<LAP_N-1; i++) begin
	 par[i+1] <= par[i]; 
	 paw[i+1] <= paw[i]; 
      end
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
