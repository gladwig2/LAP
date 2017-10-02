
module INV (input A, output F);
      // An inverter
   assign F = ~A;

endmodule // INV

module AOI (input A, B, C, D, output F);

   assign F = ~((A & B) | (C & D));

endmodule // AOI

module MUX2 (input SEL, A, B, output F);
      // 2:1 multiplexer
     // wires SELB and FB are implicit
     // Module instances...
   logic SELB,FB;
   
   INV G1 (SEL, SELB);

   AOI G2 (SELB, A, SEL, B, FB);

   INV G3 (.A(FB), .F(F));
               // Named mapping
endmodule // MUX2



