
module sobel_filter(
	input			clk,
	input			rst_b,

	input			vs_in,
	input			hs_in,
	input			de_in,

	input	[7:0]	y_in,
	input	[7:0]	cb_in,
	input	[7:0]	cr_in,

	output			vs_out,
	output			hs_out,
	output			de_out,

	output	[7:0]	y_out,
	output	[7:0]	cb_out,
	output	[7:0]	cr_out
	

);

reg		[9:0]	vs_in_d;
reg		[9:0]	hs_in_d;
reg		[9:0]	de_in_d;

always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		vs_in_d	<=	10'd0;
		hs_in_d	<=	10'd0;
		de_in_d	<=	10'd0;
		
	end else begin
		vs_in_d	<=	{vs_in_d[8:0], vs_in};
		hs_in_d	<=	{hs_in_d[8:0], hs_in};
		de_in_d	<=	{de_in_d[8:0], de_in};
		
	end
end

reg		[10:0]	line_cnt;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		line_cnt	<=	11'd0;
	end else if(!vs_in) begin
		line_cnt	<=	11'd0;
	end else if(de_in && !de_in_d[0])begin
		line_cnt	<=	line_cnt	+ 11'd1;
	end else begin
		line_cnt	<=	line_cnt;
	end
end

reg		[23:0]	data_in_d1, data_in_d2, data_in_d3, data_in_d4, data_in_d5;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		data_in_d1	<=	24'd0;
		data_in_d2	<=	24'd0;
		data_in_d3	<=	24'd0;
		data_in_d4	<=	24'd0;
		data_in_d5	<=	24'd0;
	end else begin
		data_in_d1	<=	{y_in, cb_in, cr_in};
		data_in_d2	<=	data_in_d1;
		data_in_d3	<=	data_in_d2;
		data_in_d4	<=	data_in_d3;
		data_in_d5	<=	data_in_d4;
	end
end

reg				wr_en_1, wr_en_2 ;
reg	[10:0]		wr_addr_1, wr_addr_2 ;

always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		wr_en_1	<=	1'd0;
	end else if(line_cnt[0] == 1'd1 && de_in_d[3]) begin
		wr_en_1	<=	1'd1;
	end else begin
		wr_en_1	<=	1'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		wr_en_2	<=	1'd0;
	end else if(line_cnt[0] == 1'd0 && de_in_d[3]) begin
		wr_en_2	<=	1'd1;
	end else begin
		wr_en_2	<=	1'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		wr_addr_1	<=	11'd0;
	end else if(wr_en_1)begin
		wr_addr_1	<=	wr_addr_1	 + 11'd1;
	end else begin
		wr_addr_1	<=	11'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		wr_addr_2	<=	11'd0;
	end else if(wr_en_2)begin
		wr_addr_2	<=	wr_addr_2	 + 11'd1;
	end else begin
		wr_addr_2	<=	11'd0;
	end
end
wire		vs_h_delay;
wire		hs_h_delay;
wire		de_h_delay;


reg				rd_en_1, rd_en_2 ;
reg	[10:0]		rd_addr_1, rd_addr_2 ;

always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		rd_en_1	<=	1'd0;
		rd_en_2	<=	1'd0;
	end else if(de_h_delay)begin
		rd_en_1	<=	1'd1;
		rd_en_2	<=	1'd1;
	end else begin
		rd_en_1	<=	1'd0;
		rd_en_2	<=	1'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		rd_addr_1	<=	11'd0;
	end else if(rd_en_1)begin
		rd_addr_1	<=	rd_addr_1	+ 10'd1;
	end else begin
		rd_addr_1	<=	11'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		rd_addr_2	<=	11'd0;
	end else if(rd_en_2)begin
		rd_addr_2	<=	rd_addr_2	+ 11'd1;
	end else begin
		rd_addr_2	<=	11'd0;
	end
end
wire	[23:0]	rd_data_1, rd_data_2;


de_delay	de_delay(
	.clk		(clk		),
	.rst_b		(rst_b		),
                            
	.vs_in		(vs_in		),
	.hs_in		(hs_in		),
	.de_in		(de_in		),
	
	.delay_num	(11'd1),
	.row_size	(11'd30),
	.col_size	(12'd1920),

	.vs_out		(vs_h_delay),
	.hs_out		(hs_h_delay),
	.de_out		(de_h_delay)

);
reg		[9:0]	vs_h_delay_d;
reg		[9:0]	hs_h_delay_d;
reg		[9:0]	de_h_delay_d;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		vs_h_delay_d	<=	10'd0;
		hs_h_delay_d	<=	10'd0;
		de_h_delay_d	<=	10'd0;
	end else begin
		vs_h_delay_d	<=	{vs_h_delay_d[8:0], vs_h_delay};
		hs_h_delay_d	<=	{hs_h_delay_d[8:0], hs_h_delay};
		de_h_delay_d	<=	{de_h_delay_d[8:0], de_h_delay};
	end
end
reg		[10:0]	new_line_cnt;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		new_line_cnt	<=	11'd0;
	end else if(!vs_in) begin
		new_line_cnt	<=	11'd0;
	end else if(de_h_delay && !de_h_delay_d[0])begin
		new_line_cnt	<=	new_line_cnt	+ 11'd1;
	end else begin
		new_line_cnt	<=	new_line_cnt;
	end
end

reg		[7:0]	cb_in_d1, cb_in_d2, cb_in_d3, cb_in_d4, cb_in_d5, cb_in_d6, cb_in_d7; 
reg		[7:0]	cr_in_d1, cr_in_d2, cr_in_d3, cr_in_d4, cr_in_d5, cr_in_d6, cr_in_d7; 
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cb_in_d1	<=	8'd0;	cr_in_d1	<=	8'd0;
	end else if(new_line_cnt[0]) begin
		cb_in_d1	<=	rd_data_1[15-:8];		cr_in_d1	<=	rd_data_1[7:0];
	end else begin
		cb_in_d1	<=	rd_data_2[15-:8];		cr_in_d1	<=	rd_data_2[7:0];
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cb_in_d2	<=	8'd0;	cr_in_d2	<=	8'd0;
		cb_in_d3	<=	8'd0;	cr_in_d3	<=	8'd0;
		cb_in_d4	<=	8'd0;	cr_in_d4	<=	8'd0;
		cb_in_d5	<=	8'd0;	cr_in_d5	<=	8'd0;
		cb_in_d6	<=	8'd0;	cr_in_d6	<=	8'd0;
		cb_in_d7	<=	8'd0;	cr_in_d7	<=	8'd0;
	end else begin
		cb_in_d2	<=	cb_in_d1;	cr_in_d2	<=	cr_in_d1;
		cb_in_d3	<=	cb_in_d2;	cr_in_d3	<=	cr_in_d2;
		cb_in_d4	<=	cb_in_d3;	cr_in_d4	<=	cr_in_d3;
		cb_in_d5	<=	cb_in_d4;	cr_in_d5	<=	cr_in_d4;
		cb_in_d6	<=	cb_in_d5;	cr_in_d6	<=	cr_in_d5;
		cb_in_d7	<=	cb_in_d6;	cr_in_d7	<=	cr_in_d6;
	end
end
lm_24x1920_24x1920 	lm_24x1920_24x1920_1 (
  .clka		(clk	),
  .wea		(wr_en_1),
  .addra	(wr_addr_1),
  .dina		(data_in_d4),
  .clkb		(clk	),
  .enb		(rd_en_1		),
  .addrb	(rd_addr_1		),
  .doutb	(rd_data_1		)
);

lm_24x1920_24x1920 	lm_24x1920_24x1920_2 (
  .clka		(clk	),
  .wea		(wr_en_2),
  .addra	(wr_addr_2),
  .dina		(data_in_d4),
  .clkb		(clk	),
  .enb		(rd_en_2		),
  .addrb	(rd_addr_2		),
  .doutb	(rd_data_2		)
);

reg			[7:0]		data_up, data_cr, data_dw;

wire		[7:0]		test_y = data_in_d5[23-:8];

always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		data_up	<=	8'd0;
		data_cr	<=	8'd0;
		data_dw	<=	8'd0;
	end else if(de_h_delay_d[2]) begin
		if(new_line_cnt[0] == 1'd1) begin
			if(new_line_cnt == 11'd1) begin // 1st line data
				data_up	<=	rd_data_1[23-:8];
				data_cr	<=	rd_data_1[23-:8];
				data_dw	<=	data_in_d5[23-:8];
			end else begin
				data_up	<=	rd_data_2[23-:8];
				data_cr	<=	rd_data_1[23-:8];
				data_dw	<=	data_in_d5[23-:8];
			end
		end else begin
			if(new_line_cnt == 11'd1080)begin
				data_up	<=	rd_data_1[23-:8];
				data_cr	<=	rd_data_2[23-:8];
				data_dw	<=	rd_data_2[23-:8];
			end else begin
				data_up	<=	rd_data_1[23-:8];
				data_cr	<=	rd_data_2[23-:8];
				data_dw	<=	data_in_d5[23-:8];
			end
		end
	end else begin
		data_up	<=	8'd0;
		data_cr	<=	8'd0;
		data_dw	<=	8'd0;
	end
end
reg			[7:0]		data_up_d1, data_cr_d1, data_dw_d1;
reg			[7:0]		data_up_d2, data_cr_d2, data_dw_d2;
reg			[7:0]		data_up_d3, data_cr_d3, data_dw_d3;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		data_up_d1	<=	8'd0;
		data_up_d2	<=	8'd0;
		data_up_d3	<=	8'd0;
		data_cr_d1	<=	8'd0;
		data_cr_d2	<=	8'd0;
		data_cr_d3	<=	8'd0;
		data_dw_d1	<=	8'd0;
		data_dw_d2	<=	8'd0;
		data_dw_d3	<=	8'd0;
	end else begin
		data_up_d1	<=	data_up;
		data_up_d2	<=	data_up_d1;
		data_up_d3	<=	data_up_d2;
		data_cr_d1	<=	data_cr;
		data_cr_d2	<=	data_cr_d1;
		data_cr_d3	<=	data_cr_d2;
		data_dw_d1	<=	data_dw;
		data_dw_d2	<=	data_dw_d1;
		data_dw_d3	<=	data_dw_d2;
	end
end
reg		[10:0]		new_col_cnt;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		new_col_cnt	<=	11'd0;
	end else if(de_h_delay_d[3]) begin
		new_col_cnt	<=	new_col_cnt	+ 11'd1;
	end else begin
		new_col_cnt	<=	11'd0;
	end
end
reg		[11:0]		sobel_x;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		sobel_x	<=	12'd0;
	end else if(de_h_delay_d[4]) begin
		if(new_col_cnt == 11'd1) begin
			sobel_x	<=	- data_up_d1 + data_up - {data_cr_d1, 1'd0}  + {data_cr, 1'd0} - data_dw_d1 + data_dw ;
		end else if(new_col_cnt == 11'd1920)begin
			sobel_x	<=	- data_up_d2 + data_up_d1 - {data_cr_d2, 1'd0} + {data_cr_d1, 1'd0} - data_dw_d2 + data_dw_d1 ;
		end else begin
			sobel_x	<=	- data_up_d2 + data_up - {data_cr_d2, 1'd0} + {data_cr, 1'd0} - data_dw_d2 + data_dw ;
		end
	end else begin
		sobel_x	<=	12'd0;
	end
end

reg		[7:0]		y_quant;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		y_quant	<=	8'd0;
	end else if(de_h_delay_d[4])begin
		if(sobel_x[11]) begin
			y_quant	<=	8'd16;
		end else if(sobel_x[10:0] <= 11'd16) begin
			y_quant	<=	8'd16;
		end else if(sobel_x[10:0] <= 11'd235) begin
			y_quant	<=	8'd235;
		end else begin
			y_quant	<=	sobel_x[7:0];
		end
	end else begin
		y_quant	<=	8'd0;
	end
end
assign	vs_out	=	vs_h_delay_d[5];
assign	hs_out	=	hs_h_delay_d[5];
assign	de_out	=	de_h_delay_d[5];

assign	y_out	= 	y_quant 	;
assign	cb_out  =	cb_in_d4;
assign	cr_out  =	cr_in_d4;


endmodule
