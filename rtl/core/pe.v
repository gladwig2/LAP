import proj_pkgs::dbus_t;
module pe (input logic clk, input dbus_t up, output dbus_t down, input dbus_t left, output dbus_t right);
   initial begin
      $display("Hello Word, %m");
   end

   always_ff @(posedge clk) begin
      down.data = up.data;
      right.data = left.data;
      $display("%m, down %h, right %h",down.data, right.data);
   end
   

endmodule // pe

