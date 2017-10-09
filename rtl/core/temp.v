// Description: Array Control

import proj_pkgs::*;

module vinst_ctl (input clk, reset, 
		  input  sa_inst_t inst, input logic iavail,
		  output ird,
		  output rowaddr_t ra, output coladdr_t ca, output paraddr_t pa);
   
   
   sa_inst_t       inst_r; //current instruction
   logic [LAP_N-1:0] 			   vcnt,wcnt ;  //vector count
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
      if (reset) begin
	 ra.rd <= 0;
	 ca.rd <= 0;
	 pa.wr <= 0;
      end else if (load_r) begin
	 ra.rd <= 1;
	 ca.rd <= 1;
	 pa.wr <= 1; // fix
      end else if (done[0]) begin
	 ra.rd <= 0;
	 ca.rd <= 0;
	 pa.wr <= 0; // fix
      end // else hold values

      if (load_r) begin
	 ra.adr <= inst_r.radr[LAP_ROW_ADR_MSB:LAP_ROW_ADR_LSB];
	 ca.adr <= inst_r.cadr[LAP_COL_ADR_MSB:LAP_COL_ADR_LSB];
	 pa.adr <= inst_r.padr[LAP_PAR_ADR_MSB:LAP_PAR_ADR_LSB]; // fix
      end else if (!done[0]) begin
	 ra.adr <= ra.adr + 1;
	 ca.adr <= ca.adr + 1;
	 pa.adr <= pa.adr + 1; // fix
      end // else hold values



      if (reset) begin
	 pa.wr <= 0;
	 wcnt  <= 0;
      end else if (done[2]) begin
	 pa.wr <= 1; 
	 wcnt  <= inst.vsize[LAP_N-1:0];
      end else begin
	 wcnt <= (|wcnt) ? wcnt - 1 : 0;
	 pa.wr <= wcnt != 0;
      end 

      if (done[2]) begin
	 pa.adr <= inst_r.padr[LAP_PAR_ADR_MSB:LAP_PAR_ADR_LSB]; 
      end else if (!done[0]) begin
	 pa.adr <= pa.adr + 1; 
      end // else hold values

   end

endmodule // vinst_ctl


	 
	
