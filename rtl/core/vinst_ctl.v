// Description: Array Control

import proj_pkgs::*;

module vinst_ctl (input clk, reset, 
		  input        sa_inst_t inst, input logic iavail,
		  output logic ird, next,
		  output       opcd_t saop,
		  output       pa_inst_t oinst, 
		  output       rowaddr_t ra, output coladdr_t ca);
   
   sa_inst_t                   inst_r; //current instruction
   opcd_t                      s_saop[1:0];
   logic [LAP_N-1:0] 	       cnt ;  //vector read count
   logic 		       load,load_r,iavail_r, busy;


   assign ird = load;  // external

   always_ff @(posedge clk) begin 
      iavail_r <= iavail;
      load     <= (!reset) & iavail_r & !busy & !load;
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
	    next <= (cnt == 2);
	 end
      end
   end // always_ff @

   always_ff @(posedge clk) begin
      if (reset) begin
	 ra.rd <= 0;
	 ca.rd <= 0;
      end else if (load_r) begin
	 ra.rd <= 1;
	 ca.rd <= 1;
      end else if (cnt == 0) begin
	 ra.rd <= 0;
	 ca.rd <= 0;
      end // else hold values

      if (load_r) begin
	 ra.adr <= inst_r.radr[LAP_ROW_ADR_MSB:LAP_ROW_ADR_LSB];
	 ca.adr <= inst_r.cadr[LAP_COL_ADR_MSB:LAP_COL_ADR_LSB];
      end else if (ra.rd) begin
	 ra.adr <= ra.adr + 1;
	 ca.adr <= ca.adr + 1;
      end // else hold values
   end // always_ff @
   
   
   always @(posedge clk) begin
      if (load_r) begin
	 s_saop[0] <= inst_r.opcode;
      end
      s_saop[1] <= s_saop[0];
   end // always_ff @
   assign saop = s_saop[1];
   
   always_ff @(posedge clk) begin
      oinst.opcode <= inst_r.opcode;
      oinst.padr   <= inst_r.padr;
      oinst.sadr   <= inst_r.sadr;
      oinst.vsize  <= inst_r.vsize;
   end

endmodule // vinst_ctl


	 
	
