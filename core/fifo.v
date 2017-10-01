// Prototype FIFO
//
// Input register buffered in memory when wr_en set high, 
// bufferd words presented at the output while the rd_en is set high.
// Simultaneous read/write operation permitted.
//
// Buffer size and word width may be set with the NCBIT and WIDTH
// parameters respectively.  The number of buffer words is 2**NCBIT.
//
// Author: Branden Allen
// Date  : 2017.09.29
//

module fifo(
	input  wire              rst     ,
	input  wire              clk     ,
	input  wire [WIDTH-1:0]  idata   ,    //Input Data
	output reg  [WIDTH-1:0]  odata   ,    //Output
	input  wire              rd_en   ,    //Read Enable
	input  wire              wr_en   ,    //Write Enable
	output wire              full    ,    //FIFO Full Flag
	output wire              empty        //FIFO Empty Flag
	);

	//Module Parameters
	parameter WIDTH  = 8         ; 
	parameter NCBIT  = 7         ;
	parameter NWRD   = 1<<NCBIT  ;
	parameter SIZE   = WIDTH*NWRD;

	//Internal Members
	reg  [SIZE-1 :0]  mem         ;
	reg  [NWRD-1 :0]  ctr         ;

	//Data Addressing
	assign empty = ctr== 0    ? 1'b1 : 1'b0;        //FIFO Empty Flag
	assign full  = ctr== NWRD ? 1'b1 : 1'b0;        //FIFO Full Flag

	always @ (posedge clk) begin
		if(rst) begin
			odata<= { WIDTH {1'b0} };
			mem  <= { WIDTH {1'b0} };
			ctr  <= { NWRD  {1'b0} };
		end else begin
			if(wr_en & rd_en & ~empty) begin
				odata<= mem[WIDTH-1:0];
				mem<= mem>>WIDTH;
				mem[ctr*WIDTH-1-:WIDTH]<= idata;
			end else if(wr_en) begin
				mem[ctr*WIDTH-1-:WIDTH]<= idata;
				ctr<= ctr+ 1;
			end else if(rd_en & ~empty) begin
				odata<= mem[WIDTH-1:0];
				mem<= mem>>WIDTH;
				ctr<= ctr- 1;
			end
		end
	end
endmodule
