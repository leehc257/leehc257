
module logictest_signed( //5clk delay
	input			clk,
	input			rst_b,

	input			de_in,
	input	[25:0]	data_in_01,// sign 1, exp 5, frac 10
	input	[25:0]	data_in_02,
	
	input			opt,

	output			de_out,
	output	[25:0]	data_out

);
wire	[25:0]	a_data;
wire	[25:0]	b_data;
(* keep_hierarchy = "TRUE" *) block_a	block_a( //5clk delay
	.clk		(clk		),
	.rst_b		(rst_b		),

	.data_in_01	(data_in_01	),// sign 1, exp 5, frac 10
	.data_in_02	(data_in_02	),

	.data_out	(a_data)

);
(* keep_hierarchy = "TRUE" *)block_b	block_b( //5clk delay
	.clk		(clk		),
	.rst_b		(rst_b		),

	.data_in_01	(data_in_01	),// sign 1, exp 5, frac 10
	.data_in_02	(data_in_02	),

	.data_out	(b_data)

);
assign data_out = (opt)? a_data : b_data;



endmodule
