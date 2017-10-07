// Description: Array Control

//import proj_pkgs::sa_inst_t;
//import proj_pkgs::abus_t;
//import proj_pkgs::bbus_t;
//import proj_pkgs::cbus_t;
import proj_pkgs::*;

module vinst_ctl (input clk, reset, 
		  input  sa_inst_t inst, input logic iavail,
		  output ird,
		  output abus_t abus, output bbus_t bbus, output cbus_t cbus);
   
   
   sa_inst_t       inst_r; //current instruction
   logic [LAP_N-1:0] 			   vcnt ;  //vector count
   logic 				   ird, load,load_r,iavail_r;
   logic [2:0] 				   done;

   assign ird = load;  // external
   
   oshot #(.STAGES(3)) oshot0(clk,reset, iavail_r & |done, load);

   always_ff @(posedge clk) begin 
      iavail_r <= iavail; 
      load_r <= load;
   end
   
   always_ff @(posedge clk) begin
//      $display("inst_r.aadr, badr %x %x",inst_r.aadr, inst_r.badr);
      if (reset) begin
	 vcnt <= 0;
	 inst_r.opcode <= 0; // fix, nop
	 done <= 0;
      end else begin
	 if (load) begin
	    inst_r <= inst;
	    vcnt <= inst.vsize[LAP_N-1:0];
	 end else begin
	    vcnt <= (|vcnt) ? vcnt - 1 : 0;
	 end
	 done[2] <= vcnt == 2;
	 done[1] <= vcnt == 1;
	 done[0] <= vcnt == 0;
      end
   end // always_ff @

   always_ff @(posedge clk) begin
      abus.rd <= (load_r | abus.rd & !done[0]) & !reset;
      bbus.rd <= (load_r | bbus.rd & !done[0]) & !reset;
      if (load_r) begin
	 abus.adr <= inst_r.aadr[LAP_AOP_ADR_MSB:LAP_AOP_ADR_LSB];
	 bbus.adr <= inst_r.badr[LAP_BOP_ADR_MSB:LAP_BOP_ADR_LSB];
	 cbus.adr <= inst_r.cadr[LAP_COP_ADR_MSB:LAP_COP_ADR_LSB]; // fix
      end else if (!done[0]) begin
	 abus.adr <= abus.adr + 1;
	 bbus.adr <= bbus.adr + 1;
	 cbus.adr <= cbus.adr + 1; // fix
      end else begin
	 abus.adr <= abus.adr;
	 bbus.adr <= bbus.adr;
	 cbus.adr <= cbus.adr; // fix
      end
   end

   always_ff @(posedge clk) begin 
      cbus.wr <= done[0]; // FIX
   end

endmodule // vinst_ctl


	 
	
