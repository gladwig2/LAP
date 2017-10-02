module mem(abus bus);
//   logic dummya,dummyb;
   initial begin $display("Hello World from module two");
   end
   assign bus.data = 16'h5555;

   always @*
     $display("mem %m addr %x, data %x",bus.addr, bus.data);
   
//   assign dummya = |bus.addr;
//   assign dummyb = |bus.data;
   
endmodule:mem // one
