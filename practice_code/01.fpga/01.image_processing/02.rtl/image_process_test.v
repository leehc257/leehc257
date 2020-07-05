
module image_process_test(
	input			clk,
	input			rst_b,

	input			vs_in,
	input			hs_in,
	input			de_in,

	input	[7:0]	r_in,
	input	[7:0]	g_in,
	input	[7:0]	b_in
	
	output			vs_out,
	output			hs_out,
	output			de_out,

	output	[7:0]	y,
	output	[7:0]	cb,
	output	[7:0]	cr

);

reg		[9:0]	vs_in_d;
reg		[9:0]	hs_in_d;
reg		[9:0]	de_in_d;

reg		[7:0]	r_in_d1;
reg		[7:0]	g_in_d1;
reg		[7:0]	b_in_d1;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		vs_in_d	<=	10'd0;
		hs_in_d	<=	10'd0;
		de_in_d	<=	10'd0;
		
		r_in_d1	<=	8'd0;
		g_in_d1	<=	8'd0;
		b_in_d1	<=	8'd0;
	end else begin
		vs_in_d	<=	{vs_in_d[8:0], vs_in};
		hs_in_d	<=	{hs_in_d[8:0], hs_in};
		de_in_d	<=	{de_in_d[8:0], de_in};
		
		r_in_d1	<=	r_in;
		g_in_d1	<=	g_in;
		b_in_d1	<=	b_in;
	end
end

reg		[7:0]	Y_data ;
reg		[7:0]	cb_data;
reg		[7:0]	cr_data;

always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		Y_data 	<=	8'd0;
		cb_data	<=	8'd0;
		cr_data	<=	8'd0;
	end else begin
		Y_data 	<=	16+ (((r_in<<6) +(r_in<<1) + (g_in<<7) + g_in + (b_in <<4) +(b_in<<3) + b_in ) >>8);
		cb_data	<=	128+ ((-((r_in<<5)+(r_in<<2)+(r_in<<1))-((g_in<<6)+(g_in<<3)+(g_in<<1))+(b_in<<7)-(b_in<<4))>>8);
		cr_data	<=	128+(((r_in<<7)-(r_in<<4)-((g_in<<6)+(g_in<<5)-(g_in<<1))-((b_in<<4)+(b_in<<1)))>>8);
	end
end

assign		y_out	=	Y_data ;	
assign		cb_out	=	cb_data;
assign		cr_out	=	cr_data;

assign		vs_out	=	vs_in_d[4];
assign		hs_out	=	hs_in_d[4];
assign		de_out	=	de_in_d[4];
//wire			vs_h_delay;
//wire			hs_h_delay;
//wire			de_h_delay;
//
//
//wire			vs_sobel;
//wire			hs_sobel;
//wire			de_sobel;
//wire	[7:0]	y_sobel;	
//
//wire			vs_check;
//wire			hs_check;
//wire			de_check;
//wire	[7:0]	y_check ;
//wire	[7:0]	cb_check;
//wire	[7:0]	cr_check;
//rgb2ycbcr	rgb2ycbcr(// 5clk delay, BT.709
//	.clk		(clk	),
//	.rst_b		(rst_b	),
//                        
//	.vs_in		(vs_in	),
//	.hs_in		(hs_in	),
//	.de_in		(de_in	),
//                        
//	.r_in		(r_in	),
//	.g_in		(g_in	),
//	.b_in		(b_in	),
//	
//	.vs_out		(vs_check),
//	.hs_out		(hs_check),
//	.de_out		(de_check),
//
//	.y_out		(y_check ),
//	.cb_out		(cb_check),
//	.cr_out		(cr_check)
//
//);
//sobel_filter	sobel_filter(
//	.clk		(clk		),
//	.rst_b		(rst_b		),
//                            
//	.vs_in		(vs_in_d[0]		),
//	.hs_in		(hs_in_d[0]		),
//	.de_in		(de_in_d[0]		),
//
//	.y_in		(Y_data 	),
//
//	.vs_out		(vs_sobel),
//	.hs_out		(hs_sobel),
//	.de_out		(de_sobel),
//
//	.y_out		(y_sobel)
//	
//
//);
//
//image_write	image_write(
//	.clk		(clk	),
//	.rst_b		(rst_b	),
//
//	.vs_in		(vs_sobel),
//	.hs_in		(hs_sobel),
//	.de_in		(de_sobel),
//
//	.r_in		(y_sobel),
//	.g_in		(y_sobel),
//	.b_in		(y_sobel)
//
//);

endmodule
