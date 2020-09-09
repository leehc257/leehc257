`timescale 1 ns/10 ps

`define Clock_period  10

module testbench_mul();

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
	data_a <= 16'b1100011111010010;
	data_b <= 16'b0100000001110010;
	data_c <= 16'b1100110001011000;
	#10
	data_a <= 16'b0100000001110010;
	data_b <= 16'b1100000001001001;
	data_c <= 16'b1100010011000011;
	#10
	data_a <= 16'b1100000001001001;
	data_b <= 16'b0100110001101110;
	data_c <= 16'b1101000010111111;
	#10
	data_a <= 16'b0100110001101110;
	data_b <= 16'b0100101101110011;
	data_c <= 16'b0101110000100000;
	#10
	data_a <= 16'b0100101101110011;
	data_b <= 16'b0011110010010010;
	data_c <= 16'b0100110001000001;
	#10
	data_a <= 16'b0011110010010010;
	data_b <= 16'b0100011001011000;
	data_c <= 16'b0100011101000000;
	#10
	data_a <= 16'b0100011001011000;
	data_b <= 16'b0100110001101101;
	data_c <= 16'b0101011100000101;
	#10
	data_a <= 16'b0100110001101101;
	data_b <= 16'b1011111101011111;
	data_c <= 16'b1101000000010100;
	#10
	data_a <= 16'b1011111101011111;
	data_b <= 16'b1100010100011010;
	data_c <= 16'b0100100010110011;
	#10
	data_a <= 16'b1100010100011010;
	data_b <= 16'b1100011111010010;
	data_c <= 16'b0101000011111101;
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
float16_mul	float16_mul( //5clk delay
	.clk			(clk	),
	.rst_b			(rst_b	),

	.de_in			(de_in),
	.data_in_01		(data_a),// sign 1, exp 5, frac 10
	.data_in_02		(data_b),

	.de_out			(result_en),
	.data_out		(result_data)

);

endmodule
