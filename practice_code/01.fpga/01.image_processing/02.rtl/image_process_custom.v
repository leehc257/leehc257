
module image_process_custom( // 10clk delay
	input			clk,
	input			rst_b,

	input			vs_in,
	input			hs_in,
	input			de_in,

	input	[23:0]	rgb_data_in,
	
	input	[3:0]	sw_opt,

	output			vs_out,
	output			hs_out,
	output			de_out,

	output	[23:0]	rgb_data_out

);

wire			vs_tmp;
wire			hs_tmp;
wire			de_tmp;

wire	[7:0]	y_tmp ;
wire	[7:0]	cb_tmp;
wire	[7:0]	cr_tmp;
rgb2ycbcr	rgb2ycbcr(// 5clk delay, BT.709
	.clk		(clk  ),	
	.rst_b		(rst_b),
                      
	.vs_in		(vs_in),
	.hs_in		(hs_in),
	.de_in		(de_in),

	.r_in		(rgb_data_in[23-:8]),
	.g_in		(rgb_data_in[15-:8]),
	.b_in		(rgb_data_in[ 7-:8]),
	
	.vs_out		(vs_tmp),
	.hs_out		(hs_tmp),
	.de_out		(de_tmp),

	.y_out		(y_tmp ),
	.cb_out		(cb_tmp),
	.cr_out		(cr_tmp)

);


wire			vs_sobel;
wire			hs_sobel;
wire			de_sobel;

wire	[7:0]	y_sobel	;
wire	[7:0]	cb_sobel;
wire	[7:0]	cr_sobel;
sobel_filter	sobel_filter(
	.clk		(clk  ),
	.rst_b		(rst_b),

	.vs_in		(vs_tmp),
	.hs_in		(hs_tmp),
	.de_in		(de_tmp),
                       
	.y_in		(y_tmp ),
	.cb_in		(cb_tmp),
	.cr_in		(cr_tmp),

	.vs_out		(vs_sobel),
	.hs_out		(hs_sobel),
	.de_out		(de_sobel),
                         
	.y_out		(y_sobel ),
	.cb_out		(cb_sobel),
	.cr_out		(cr_sobel)
	

);

wire		vs_sel = (sw_opt[0])? vs_sobel : vs_tmp;
wire		hs_sel = (sw_opt[0])? hs_sobel : hs_tmp;
wire		de_sel = (sw_opt[0])? de_sobel : de_tmp;

wire	[7:0]	y_sel  = (sw_opt[0])? y_sobel : y_tmp;	
wire	[7:0]	cb_sel = (sw_opt[0])? cb_sobel : cb_tmp;	
wire	[7:0]	cr_sel = (sw_opt[0])? cr_sobel : cr_tmp;	



ycbcr2rgb	ycbcr2rgb(//5 clk delay, BT.709
	.clk		(clk  ),
	.rst_b		(rst_b),

	.vs_in		(vs_sel),
	.hs_in		(hs_sel),
	.de_in		(de_sel),
                         
	.y_in		(y_sel ),
	.cb_in		(cb_sel),
	.cr_in		(cr_sel),
	
	.vs_out		(vs_out),
	.hs_out		(hs_out),
	.de_out		(de_out),

	.r_out		(rgb_data_out[23-:8]),
	.g_out		(rgb_data_out[15-:8]),
	.b_out		(rgb_data_out[ 7-:8])

);
endmodule
