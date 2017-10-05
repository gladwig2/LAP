// DESCRIPTION: LAP core
//
module core (/*AUTOARG*/
   // Outputs
   passed,
   // Inputs
   clk, fastclk, reset_l
   );

   input clk /*verilator sc_clock*/;
   input fastclk /*verilator sc_clock*/;
   input reset_l;
   output passed;

   parameter Xmax = 3;
   parameter Ymax = 3;

   import proj_pkgs::dbus_t;
   
   dbus_t dx[Xmax][Ymax];
   dbus_t dy[Xmax][Ymax];
   assign dx[0][0] = '{1,1};
   assign dy[0][0] = '{2,2};

   genvar x,y;
   generate
      for (x = 0; x < Xmax; x = x+1) begin : pex
	 for (y = 0; y < Ymax; y = y+1) begin : pey
	    pe pe(.clk(fastclk), 
		  .up(dy[x][y]), 
		  .down(dy[x][y+1]), 
		  .left(dx[x][y]), 
		  .right(dx[x+1][y]));
	 end
      end
   endgenerate
   
   reg [31:0] count_c;
   reg [31:0] count_f;
   
//   always @ (posedge clk) begin
   always_ff @(posedge clk)  begin
      if (!reset_l) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 count_c <= 32'h0;
	 // End of automatics
      end else begin
	 count_c <= count_c + 1;
      end
   end
   
   always @ (posedge fastclk) begin
      if (!reset_l) begin
	 /*AUTORESET*/
	 // Beginning of autoreset for uninitialized flops
	 count_f <= 32'h0;
	 passed <= 1'h0;
	 // End of automatics
      end else begin
	 count_f <= count_f + 1;
	 if (count_f == 5) passed <= 1'b1;
      end
   end // always @ (posedge fastclk)

endmodule
