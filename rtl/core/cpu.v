module cpu(abus bus);
   initial begin $display("Hello World from module one");
   end
   assign bus.addr = 8'h4;
//   assign bus.data = 16'h5;

   always @*
     $display("cpu addr %x, data %x",bus.addr, bus.data);
   
   
endmodule:cpu // one
