// UART TX Testbench
//
// Author: Branden Allen
// Date  : 2017.09.27
//
`include "uart.v"

module uart_test();
	
	reg clk, rst, tx_en;
	reg [7:0] tx_data;
	wire tx_ready;
	wire tx;
	wire [10:0] ctr;
	wire [ 4:0] stage;

	initial begin
		$monitor("%4g %1b %1b %10b %5b %10b %1b", $time, clk, tx_ready, ctr, stage, tx_data, tx);
		clk= 1;
		rst= 0;
		tx_en= 0;
		tx_data= 8'b01010101;
		#5     rst= 1;
		#10    rst= 0;
		#100   tx_en= 1;
		#105   tx_data= 8'hf;
		#1000  $finish;
	end

	always begin
		#5 clk=~ clk;
	end

	uart #(.BAUD_THRESHOLD(4)) u0(
		.clk(clk),
		.rst(rst),
		.tx_data(tx_data),
		.tx_en(tx_en),
		.tx(tx),
		.tx_ready(tx_ready),
		.ctr(ctr),
		.stage(stage)
		);
endmodule

