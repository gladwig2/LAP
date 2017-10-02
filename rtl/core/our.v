/* verilator lint_off DECLFILENAME */
module our();
   abus Xbus();
   
   cpu one0(Xbus);
   mem two0(Xbus);
   
   initial begin $display("Hello World");
   $finish;
   end 
endmodule 

module cpu(abus bus);
   initial begin $display("Hello World from module one");
   end
   assign bus.addr = 8'b1;
   assign bus.data = 16'h5;
   
endmodule:cpu // one

module mem(abus bus);
//   logic dummya,dummyb;
   initial begin $display("Hello World from module two");
   end
   assign bus.addr = 8'b1;
   assign bus.data = 16'h5;
   
//   assign dummya = |bus.addr;
//   assign dummyb = |bus.data;
   
endmodule:mem // one
/* verilator lint_on DECLFILENAME */
