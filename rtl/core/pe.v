import proj_pkgs::dbus_t;
import proj_pkgs::opcd_t;
module pe (input logic clk, input dbus_t up, output dbus_t down, input dbus_t left, output dbus_t right);
   parameter r = 0; // row
   parameter c = 0; // column
   initial begin
      $display("PE %d,%d",r,c);
   end
   
   opcd_t rop;
   
   always_ff @(posedge clk) begin
      if (c==0) begin
	 rop <= up.opcd;
	 down.opcd <= up.opcd;
	 right.opcd <= up.opcd;
      end else begin
	 rop <= left.opcd;
	 down.opcd <= left.opcd;
	 right.opcd <= left.opcd;
      end
   end

   always_ff @(posedge clk) begin
      if (rop == OPCD_PASS) begin
	 down.data <= up.data;
	 right.data <= left.data;
      end else begin
	 down.data <= up.data + left.data;
	 right.data <= up.data + left.data;
      end
   end

endmodule // pe

