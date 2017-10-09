// Description: Array Control

import proj_pkgs::*;

module winst_ctl (input clk, reset, 
		  input        pa_inst_t inst, input logic load,
		  output logic next,
		  output       pa_inst_t oinst, // tbd
		  output       paraddr_t par, pawaddr_t spaw);
   
   pa_inst_t                   inst_r; //current instruction
   logic [LAP_N-1:0] 	       cnt ;  //vector read count
   logic 		       load_r, busy;
   pawaddr_t                   s_paw[3];

   always_ff @(posedge clk) begin 
      load_r   <= load;
   end

   always_ff @(posedge clk) begin
      if (reset) begin
	 cnt <= 0;
	 busy <= 0;
	 next <= 0;
	 inst_r.opcode <= 0; // fix, nop
      end else begin
	 if (load) begin
	    inst_r <= inst;
	    busy <= 1;
	 end else begin
	    busy <= busy & !(cnt == 3);
	 end
	 if (load_r) begin
	    cnt <= inst_r.vsize[LAP_N-1:0];
	 end else begin
	    cnt <= (|cnt) ? cnt - 1 : 0;
	    next <= (cnt == 3);
	 end
      end
   end // always_ff @

   always_ff @(posedge clk) begin
      if (reset) begin
	 par.rd <= 0;
	 par.wr <= 0;
      end else if (load_r) begin
	 par.rd <= 1; // fix
	 par.wr <= 1; // fix
      end else if (cnt == 0) begin
	 par.rd <= 0;
	 par.wr <= 0;
      end // else hold values

      if (load_r) begin
	 par.adr <= inst_r.padr[LAP_PAR_ADR_MSB:LAP_PAR_ADR_LSB];
      end else if (par.rd) begin
	 par.adr <= par.adr + 1;
      end // else hold values
   end // always_ff @
   
   always @(posedge clk) begin
      s_paw[0].adr <= par.adr;
      s_paw[0].wr   <= par.wr;
      {s_paw[2],s_paw[1]} <= {s_paw[1],s_paw[0]};
   end // always_ff @
   assign spaw = s_paw[2];
   
//   always_ff @(posedge clk) begin
//      oinst.opcode <= inst_r.opcode;
//      oinst.padr   <= inst_r.padr;
//      oinst.sadr   <= inst_r.sadr;
//      oinst.vsize  <= inst_r.vsize;
//   end

endmodule // vinst_ctl


	 
	
