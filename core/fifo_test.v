// Simple FIFO Testbench
//
// Author: Branden Allen
// Date  : 2017.09.30
//
`include "fifo.v"

module uart_test();
	
	reg clk, rst, wr_en, rd_en;
	reg  [7:0] idata;
	wire [7:0] odata;
	reg  [7:0] omem ;
	wire full, empty;

	initial begin
		$monitor("%4g %4x %1b %1b %1b %1b %3x %3x %3x", $time, clk, full, empty, wr_en, rd_en, idata, odata, omem);
		idata= 0;
		clk  = 1;
		rst  = 1;
		rd_en= 0;
		wr_en= 0;

		//Non-concurrent store and readout test
		#10    rst= 0;
		#20    wr_en= 1;
		#30    wr_en= 0;
		#100   rd_en= 1;
		#140   rd_en= 0;
		#148   rd_en= 1;
		#149   rd_en= 0;

		//Concurrent readout test
		#200   wr_en= 1;
		#200   rd_en= 1;
		#1000  $finish;
	end

	always begin
		#5 clk=~ clk;
	end

	always @ (posedge clk) begin
		idata<= idata+ 1'b1;
		if(idata> 8'hf) begin
			rd_en<= ~rd_en;
		end
		if(~empty) begin
			omem<= odata;
		end
	end

	fifo #(.WIDTH(8), .NCBIT(7)) f0(
		.rst(rst),
		.clk(clk),
		.idata(idata),
		.odata(odata),
		.next(rd_en),
		.wr_en(wr_en),
		.full(full),
		.empty(empty)
		);
endmodule

