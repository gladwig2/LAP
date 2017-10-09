// Module se: Sum Element, adds partial sums from partial cache with incoming results
import proj_pkgs::dbus_t;
import proj_pkgs::sbus_t;

module se (input logic clk, input dbus_t up, sbus_t pb, output sbus_t down);

   opcd_t rop;
   
   always_ff @(posedge clk) begin
	 rop <= up.opcd;
   end

   always_ff @(posedge clk) begin
      down.data <= {16'h0000,up.data}; //FIX
   end

endmodule // pe

