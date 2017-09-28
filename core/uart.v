// Bi-directional UART interface
//
// Author: Branden Allen
// Date  : 2017.09.27
//

module uart(
	input  wire        clk            ,
	input  wire        rst            ,
	input  wire [ 7:0] tx_data        ,
	input  wire        tx_en          ,
	output reg         tx_ready       ,
	output reg         tx             ,
	output reg  [ 4:0] stage          ,
	output reg  [10:0] ctr             
	);

	parameter          BAUD_THRESHOLD= 10;
	reg         [ 7:0] tx_buffer         ;

	//Module Initial Values
	task reset; 
		begin
			tx       <= 1;
			tx_ready <= 1;
			ctr      <= 0;
			stage    <= 0;
			tx_buffer<= 0;
		end
	endtask

	//Enable trigger, latch output data
	always @ (posedge tx_en) begin
		tx_ready<= 0;
		tx_buffer<= tx_data;
	end

	//BEGIN PRIMARY BLOCK
	always @ (posedge clk) begin
		//Clock Counter
		if(rst) begin
			reset;
		end else if(~tx_ready) begin
			//Clock Counter
			ctr<= ctr+ 1'b1;

			//TX Serialization Block
			case(stage)
				5'h0     : tx<= 0;
				5'h1     : tx<= tx_buffer[0];
				5'h2     : tx<= tx_buffer[1];
				5'h3     : tx<= tx_buffer[2];
				5'h4     : tx<= tx_buffer[3];
				5'h5     : tx<= tx_buffer[4];
				5'h6     : tx<= tx_buffer[5];
				5'h7     : tx<= tx_buffer[6];
				5'h8     : tx<= tx_buffer[7];
				5'h9     : tx<= 0;
				5'ha     : tx<= 0;
				5'hb     : reset;
				default  : tx<= 1;
			endcase
		end else begin
			tx<= 1;
		end

		//Stage increment (BAUD rate)
		if(ctr== BAUD_THRESHOLD) begin
			stage<= stage+1'b1;
			ctr<= 0;
		end
	end
	//END PRIMARY BLOCK
endmodule
