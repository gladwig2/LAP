package proj_pkgs;

   parameter LAP_SA_ALUWIDTH = 16;
   parameter LAP_SA_CMDWIDTH = 4;
   parameter LAP_N = 4;  // SA array side size
   parameter LAP_AOP_CACHE_ADR_BITS = 4; // address row of LAP_N elements
   parameter LAP_AOP_ADR_LSB = $clog2(LAP_N);
   parameter LAP_AOP_ADR_MSB = LAP_AOP_ADR_LSB + LAP_AOP_CACHE_ADR_BITS -1;

   parameter LAP_BOP_CACHE_ADR_BITS = 4; // address row of LAP_N elements
   parameter LAP_BOP_ADR_LSB = $clog2(LAP_N);
   parameter LAP_BOP_ADR_MSB = LAP_AOP_ADR_LSB + LAP_BOP_CACHE_ADR_BITS -1;

   parameter LAP_COP_CACHE_ADR_BITS = 4; // address row of LAP_N elements
   parameter LAP_COP_ADR_LSB = $clog2(LAP_N);
   parameter LAP_COP_ADR_MSB = LAP_AOP_ADR_LSB + LAP_COP_CACHE_ADR_BITS -1;
   
   typedef struct packed {
      logic [LAP_SA_ALUWIDTH - 1:0] data;
      logic [LAP_SA_CMDWIDTH - 1:0] cmd;
   } dbus_t;

   typedef struct packed {
      logic [LAP_AOP_CACHE_ADR_BITS-1:0] aadr;
      logic 				 rd;
   } abus_t;

   typedef struct packed {
      logic [LAP_BOP_CACHE_ADR_BITS-1:0] badr;
      logic 				 rd;
   } bbus_t;

   typedef struct packed {
      logic [LAP_COP_CACHE_ADR_BITS-1:0] cadr;
      logic 				 wr;
   } cbus_t;

   // note, below are achitectural sizes, may be smaller in implementation
   typedef struct 		 packed {
      logic [3:0] 		 opcode;
      logic 			 cont;   // continuation of previous action, new addresses
      logic [31:0] 		 aadr;  // operand a starting address, byte offset
      logic [31:0] 		 badr;  // operand b starting address, byte offset
      logic [15:0] 		 padr;  // partial sum temp storage address
      logic [31:0] 		 cadr;  // result starting address, for final result storage
      logic [9:0] 		 vsize; // max size of vector (n of nxn)
   } sa_inst_t; // instructions for sa unit
   
endpackage;

