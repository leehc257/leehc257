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

wire	[7:0]	r_in_01;
wire	[7:0]	g_in_01;
wire	[7:0]	b_in_01;
wire	[7:0]	r_in_02;
wire	[7:0]	g_in_02;
wire	[7:0]	b_in_02;
wire	[7:0]	r_in_03;
wire	[7:0]	g_in_03;
wire	[7:0]	b_in_03;
wire	[7:0]	r_in_04;
wire	[7:0]	g_in_04;
wire	[7:0]	b_in_04;
wire	[7:0]	r_in_05;
wire	[7:0]	g_in_05;
wire	[7:0]	b_in_05;
wire	[7:0]	r_in_06;
wire	[7:0]	g_in_06;
wire	[7:0]	b_in_06;
wire	[7:0]	r_in_07;
wire	[7:0]	g_in_07;
wire	[7:0]	b_in_07;
wire	[7:0]	r_in_08;
wire	[7:0]	g_in_08;
wire	[7:0]	b_in_08;

wire	[7:0]	test_data = 8'd1;
wire	[7:0]	test_data1 = ~test_data;

gpu_8port	gpu_8port(
	.clk	(clk  	),
	.rst_b	(rst_b	),

	.vs_in	(vs_in	),
	.hs_in	(hs_in	),
	.de_in	(de_in	),

	.r_in_01	(r_in_01	),
	.g_in_01	(g_in_01	),
	.b_in_01	(b_in_01	),

	.r_in_02	(r_in_02	),
	.g_in_02	(g_in_02	),
	.b_in_02	(b_in_02	),
                        
	.r_in_03	(r_in_03	),
	.g_in_03	(g_in_03	),
	.b_in_03	(b_in_03	),
                        
	.r_in_04	(r_in_04	),
	.g_in_04	(g_in_04	),
	.b_in_04	(b_in_04	),
                        
	.r_in_05	(r_in_05	),
	.g_in_05	(g_in_05	),
	.b_in_05	(b_in_05	),
                        
	.r_in_06	(r_in_06	),
	.g_in_06	(g_in_06	),
	.b_in_06	(b_in_06	),
                        
	.r_in_07	(r_in_07	),
	.g_in_07	(g_in_07	),
	.b_in_07	(b_in_07	),
                        
	.r_in_08	(r_in_08	),
	.g_in_08	(g_in_08	),
	.b_in_08	(b_in_08	)
);

dct_8port	dct_8port(
	.clk		(clk  	),
	.rst_b		(rst_b	),

	.de_in		(de_in	),

	.data_in_01	(b_in_01),
	.data_in_02	(b_in_02),
	.data_in_03	(b_in_03),
	.data_in_04	(b_in_04),
	.data_in_05	(b_in_05),
	.data_in_06	(b_in_06),
	.data_in_07	(b_in_07),
	.data_in_08	(b_in_08)
);
//image_write_8port	image_write_8port(
//	.clk	(clk  	),
//	.rst_b	(rst_b	),
//
//	.vs_in	(vs_in	),
//	.hs_in	(hs_in	),
//	.de_in	(de_in	),
//
//	.r_in_01	(r_in_01	),
//	.g_in_01	(g_in_01	),
//	.b_in_01	(b_in_01	),
//
//	.r_in_02	(r_in_02	),
//	.g_in_02	(g_in_02	),
//	.b_in_02	(b_in_02	),
//                        
//	.r_in_03	(r_in_03	),
//	.g_in_03	(g_in_03	),
//	.b_in_03	(b_in_03	),
//                        
//	.r_in_04	(r_in_04	),
//	.g_in_04	(g_in_04	),
//	.b_in_04	(b_in_04	),
//                        
//	.r_in_05	(r_in_05	),
//	.g_in_05	(g_in_05	),
//	.b_in_05	(b_in_05	),
//                        
//	.r_in_06	(r_in_06	),
//	.g_in_06	(g_in_06	),
//	.b_in_06	(b_in_06	),
//                        
//	.r_in_07	(r_in_07	),
//	.g_in_07	(g_in_07	),
//	.b_in_07	(b_in_07	),
//                        
//	.r_in_08	(r_in_08	),
//	.g_in_08	(g_in_08	),
//	.b_in_08	(b_in_08	)
//
//);


endmodule
