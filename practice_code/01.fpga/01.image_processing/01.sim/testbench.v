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

wire			vs_in;
wire			hs_in;
wire			de_in;

wire	[7:0]	r_in;
wire	[7:0]	g_in;
wire	[7:0]	b_in;

gpu_1port	gpu_1port(
	.clk	(clk  	),
	.rst_b	(rst_b	),

	.vs_in	(vs_in	),
	.hs_in	(hs_in	),
	.de_in	(de_in	),

	.r_in	(r_in	),
	.g_in	(g_in	),
	.b_in	(b_in	)

);
wire			vs_in_tmp;
wire			hs_in_tmp;
wire			de_in_tmp;

wire	[7:0]	r_in_tmp;
wire	[7:0]	g_in_tmp;
wire	[7:0]	b_in_tmp;

de_delay	de_delay( // 2clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),
                      
	.vs_in		(vs_in),
	.hs_in		(hs_in),
	.de_in		(de_in),
	
	.delay_num	(11'd1),
	.row_size	(11'd30),
	.col_size	(12'd1920),

	.vs_out		(),
	.hs_out		(),
	.de_out		()

);
image_process_custom	image_process_custom( // 10clk delay
	.clk		(clk  	),
	.rst_b		(rst_b	),

	.vs_in		(vs_in),
	.hs_in		(hs_in),
	.de_in		(de_in),

	.rgb_data_in({r_in, g_in, b_in}),
	
	.vs_out		(vs_in_tmp),
	.hs_out		(hs_in_tmp),
	.de_out		(de_in_tmp),

	.rgb_data_out({r_in_tmp, g_in_tmp, b_in_tmp})

);
//
//image_write	image_write(
//	.clk	(clk  	),
//	.rst_b	(rst_b	),
//
//	.vs_in	(vs_in_tmp	),
//	.hs_in	(hs_in_tmp	),
//	.de_in	(de_in_tmp	),
//
//	.r_in	(r_in_tmp	),
//	.g_in	(g_in_tmp	),
//	.b_in	(b_in_tmp	)
//
//);


endmodule
