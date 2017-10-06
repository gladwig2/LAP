// Module Oshot
// Description: One Shot with delay. Will set osig to 1 when sig is 1 but will
//  hold it to 0 for stgs after that. Reset clears all

module oshot (input logic clk,reset, sig, output osig);
   parameter STAGES = 1; // 1 acts as a 'normal' one shot
   logic [STAGES - 1:0] ssig;
   
   assign osig = ssig[0];
   
   generate
      always_ff @(posedge clk) begin
	 if (reset) begin
	    ssig <= 0; // does that extend?
	 end else begin
            ssig[0] <= sig & !|ssig;
	    if (STAGES > 1) begin
	       ssig[STAGES-1:1] <= ssig[STAGES-2:0];
	    end
	 end
      end
   endgenerate
   
endmodule; // oshot

	 
