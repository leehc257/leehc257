`timescale 1 ns/10 ps

`define Clock_period  10

module testbench();

reg			clk;
reg			rst_b;

initial begin
	clk		=	1'b0;
	rst_b	=	1'b1;
	#100
	rst_b	=	1'b0;
	#100
	rst_b	=	1'b1;

end
always #(`Clock_period/2) 	clk	= !clk;

reg		[15:0]	data_a;
reg		[15:0]	data_b;
reg		[15:0]	data_c;
reg				de_in;
initial begin
	de_in  = 1'd0;
	data_a = 16'd0;
	data_b = 16'd0;
	data_c = 16'd0;
	#500
	#5
	de_in  <= 1'd1;
	data_a <= 16'b1100011010010101;
	data_b <= 16'b1011100110011010;
	data_c <= 16'b1100011101001000;
	#10
	data_a <= 16'b1011100110011010;
	data_b <= 16'b0100001101100101;
	data_c <= 16'b0100000111111110;
	#10
	data_a <= 16'b0100001101100101;
	data_b <= 16'b0100011000011111;
	data_c <= 16'b0100100011101001;
	#10
	data_a <= 16'b0100011000011111;
	data_b <= 16'b1100010000100101;
	data_c <= 16'b0011111111101000;
	#10
	data_a <= 16'b1100010000100101;
	data_b <= 16'b0100000110111000;
	data_c <= 16'b1011110100100100;
	#10
	data_a <= 16'b0100000110111000;
	data_b <= 16'b0011111011011011;
	data_c <= 16'b0100010010010011;
	#10
	data_a <= 16'b0011111011011011;
	data_b <= 16'b1100001101011001;
	data_c <= 16'b1011111111010111;
	#10
	data_a <= 16'b1100001101011001;
	data_b <= 16'b1100100000010011;
	data_c <= 16'b1100100111101001;
	#10
	data_a <= 16'b1100100000010011;
	data_b <= 16'b0011100110110111;
	data_c <= 16'b1100011101101111;
	#10
	data_a <= 16'b0011100110110111;
	data_b <= 16'b1100011010010101;
	data_c <= 16'b1100010111011110;
	#10
	de_in  <= 1'd0;
end
wire			result_en;
wire	[15:0]	result_data;	

wire			data_a_sign = data_a[15];
wire	[4:0]	data_a_exp  = data_a[14-:5];
wire	[9:0]	data_a_frac = data_a[9-:10];
wire			data_b_sign = data_b[15];
wire	[4:0]	data_b_exp  = data_b[14-:5];
wire	[9:0]	data_b_frac = data_b[9-:10];
wire			data_c_sign = data_c[15];
wire	[4:0]	data_c_exp  = data_c[14-:5];
wire	[9:0]	data_c_frac = data_c[9-:10];

wire			data_result_sign = result_data[15];
wire	[4:0]	data_result_exp  = result_data[14-:5];
wire	[9:0]	data_result_frac = result_data[9-:10];
float16_add	float16_add( //5clk delay
	.clk			(clk	),
	.rst_b			(rst_b	),

	.de_in			(de_in),
	.data_in_01		(data_a),// sign 1, exp 5, frac 10
	.data_in_02		(data_b),

	.de_out			(result_en),
	.data_out		(result_data)

);

endmodule
