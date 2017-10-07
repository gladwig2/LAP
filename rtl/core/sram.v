// Module sram
// Description: synchronous SRAM

module sram (rclk, radr, rdata, ren, wclk, wdata, wadr,wen); 
   parameter DATA_WIDTH = 8 ;
   parameter ADDR_WIDTH = 8 ;
   parameter RAM_DEPTH = 1 << ADDR_WIDTH;
   parameter MEM_INIT_FILE = "";
   
   input                  rclk;
   input                  wclk;
   input [ADDR_WIDTH-1:0] radr;
   input [ADDR_WIDTH-1:0] wadr;
   input                  wen;
   input                  ren; 
   input [DATA_WIDTH-1:0] wdata;
   
   output [DATA_WIDTH-1:0] rdata;

   reg [DATA_WIDTH-1:0]    data_out; // output of aysnc ram
   reg [DATA_WIDTH-1:0]    mem [0:RAM_DEPTH-1];
   logic [ADDR_WIDTH-1:0]  rradr,rwadr;
   logic                   rwe;

//--------------Code Starts Here------------------ 

initial begin
//  if (MEM_INIT_FILE != "") begin // this doesn't work for some reason
//   $display("hello from SRAM %m, %s",MEM_INIT_FILE);
    $readmemh(MEM_INIT_FILE, mem);
//    $readmemh("cop.txt", mem);
//  end
end

// read side
   always_ff @ (posedge rclk) begin
      if (ren) begin
	 rradr <= radr;
      end
      rdata <= mem[rradr];
   end

   always_ff @ (posedge wclk) begin
      rwadr <= wadr;
      rwe <= wen;
      if ( rwe ) begin
	 mem[rwadr] = wdata;
      end
   end
   
endmodule // sram

