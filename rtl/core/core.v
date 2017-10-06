// DESCRIPTION: LAP core
//
module core (/*AUTOARG*/
   // Outputs
   passed,
   // Inputs
   clk,reset
   );

   input clk;
   input reset;
   output passed;

   parameter Xmax = 3;
   parameter Ymax = 3;

   import proj_pkgs::*;
   
   dbus_t dx[Xmax][Ymax];
   dbus_t dy[Xmax][Ymax];
   assign dx[0][0] = '{1,1};
   assign dy[0][0] = '{2,2};

   genvar x,y;
   generate
      for (x = 0; x < Xmax; x = x+1) begin : pex
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
   assign finst = '{ 0,0,32'h5555,32'h6666,16'h7777,32'h8888,LAP_N-1};
   logic ifavail, ifrd;
   assign ifavail = 1'b1;
   
   vinst_ctl vctl0 (.clk(clk), .reset(reset), 
		  .inst(finst), .iavail(ifavail),
		  .ird(ifrd),
		  .abus(abus[0]), .bbus(bbus[0]), .cbus(cbus[0]));

   always_ff @(posedge clk) begin
      abus[LAP_N-1:1] <= abus[LAP_N-2:0];
      bbus[LAP_N-1:1] <= bbus[LAP_N-2:0];
      cbus[LAP_N-1:1] <= cbus[LAP_N-2:0]; // fix
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
