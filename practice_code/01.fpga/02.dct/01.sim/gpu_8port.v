`timescale 1 ns/10 ps

`define IMAGE_V_SIZE	30
`define IMAGE_H_SIZE	1920

`define H_ACTIVE		240

`define H_BACK_PORCH	148 // hmax - hpe + 1  148
`define H_FRONT_PORCH	88 // hps - width     88
`define H_WIDTH			44 // hpe - hps       44

`define V_BACK_PORCH	36 // vmax - vpe + 1   36
`define V_FRONT_PORCH	4 // vps - width      4
`define V_WIDTH			5 // vpe - vps        5


module gpu_8port(
	input			clk,
	input			rst_b,

	output			vs_in,
	output			hs_in,
	output			de_in,

	output	[7:0]	r_in_01,
	output	[7:0]	g_in_01,
	output	[7:0]	b_in_01,

	output	[7:0]	r_in_02,
	output	[7:0]	g_in_02,
	output	[7:0]	b_in_02,

	output	[7:0]	r_in_03,
	output	[7:0]	g_in_03,
	output	[7:0]	b_in_03,

	output	[7:0]	r_in_04,
	output	[7:0]	g_in_04,
	output	[7:0]	b_in_04,

	output	[7:0]	r_in_05,
	output	[7:0]	g_in_05,
	output	[7:0]	b_in_05,

	output	[7:0]	r_in_06,
	output	[7:0]	g_in_06,
	output	[7:0]	b_in_06,

	output	[7:0]	r_in_07,
	output	[7:0]	g_in_07,
	output	[7:0]	b_in_07,

	output	[7:0]	r_in_08,
	output	[7:0]	g_in_08,
	output	[7:0]	b_in_08

);


reg		[11:0] clk_cnt;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		clk_cnt	<=	12'd0;
	end else begin
		if(clk_cnt == `H_ACTIVE + `H_BACK_PORCH	+ `H_FRONT_PORCH + `H_WIDTH)begin
			clk_cnt	<=	12'd1;
		end else begin
			clk_cnt	<=	clk_cnt	+ 12'd1;
		end
	end
end
reg		[11:0]	hs_cnt;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		hs_cnt	<=	12'd0;
	end else if(clk_cnt == 12'd1)begin
		if(hs_cnt == `IMAGE_V_SIZE  + `V_BACK_PORCH	+ `V_FRONT_PORCH + `V_WIDTH) begin
			hs_cnt	<=	12'd1;
		end else begin
			hs_cnt	<=	hs_cnt + 12'd1;
		end
	end else begin
		hs_cnt	<=	hs_cnt;
	end
end
reg				vs_tmp;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		vs_tmp	<=	1'd1;
	end else if(hs_cnt <= `V_WIDTH )begin
		vs_tmp	<=	1'd0;
	end else begin
		vs_tmp	<=	1'd1;

	end
end
reg				hs_tmp;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		hs_tmp	<=	1'd0;
	//end else if(clk_cnt >= `H_BACK_PORCH +`IMAGE_H_SIZE+ `H_FRONT_PORCH)begin
	end else if(clk_cnt > `H_WIDTH)begin
		hs_tmp	<=	1'd1;
	end else begin
		hs_tmp	<=	1'd0;
	end
end

reg				de_tmp;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		de_tmp	<=	1'd0;
	end else if(hs_cnt >`V_BACK_PORCH + `V_WIDTH && hs_cnt <=  `V_BACK_PORCH +`IMAGE_V_SIZE + `V_WIDTH) begin
		if(clk_cnt > `H_BACK_PORCH + `H_WIDTH && clk_cnt <=  `H_BACK_PORCH +`H_ACTIVE + `H_WIDTH)begin
			de_tmp	<=	1'd1;
		end else begin
			de_tmp	<=	1'd0;
		end
	end else begin
		de_tmp	<=	1'd0;
	end
end

reg		vs_tmp_d1;
reg		hs_tmp_d1;
reg		de_tmp_d1;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		vs_tmp_d1	<=	1'd0;
		hs_tmp_d1	<=	1'd0;
		de_tmp_d1	<=	1'd0;
	end else begin
		vs_tmp_d1	<=	vs_tmp;
		hs_tmp_d1	<=	hs_tmp;
		de_tmp_d1	<=	de_tmp;
	end
end

reg		[7:0]	im_buf [3* `IMAGE_H_SIZE * `IMAGE_V_SIZE:0 ];
initial begin
	$readmemh("../03.input_data/test_image2.hex", im_buf);
end

reg		[100000:0] img_cnt;

reg		[7:0]	r_data_01, r_data_02, r_data_03, r_data_04, r_data_05, r_data_06, r_data_07, r_data_08;
reg		[7:0]	g_data_01, g_data_02, g_data_03, g_data_04, g_data_05, g_data_06, g_data_07, g_data_08;
reg		[7:0]	b_data_01, b_data_02, b_data_03, b_data_04, b_data_05, b_data_06, b_data_07, b_data_08;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		r_data_01	<=	8'd0;
		g_data_01	<=	8'd0;
		b_data_01	<=	8'd0;
		r_data_02	<=	8'd0;
		g_data_02	<=	8'd0;
		b_data_02	<=	8'd0;
		r_data_03	<=	8'd0;
		g_data_03	<=	8'd0;
		b_data_03	<=	8'd0;
		r_data_04	<=	8'd0;
		g_data_04	<=	8'd0;
		b_data_04	<=	8'd0;
		r_data_05	<=	8'd0;
		g_data_05	<=	8'd0;
		b_data_05	<=	8'd0;
		r_data_06	<=	8'd0;
		g_data_06	<=	8'd0;
		b_data_06	<=	8'd0;
		r_data_07	<=	8'd0;
		g_data_07	<=	8'd0;
		b_data_07	<=	8'd0;
		r_data_08	<=	8'd0;
		g_data_08	<=	8'd0;
		b_data_08	<=	8'd0;
		img_cnt	<=	0;
	end else if(!vs_tmp)begin
		img_cnt	<=	0;
	end else if(de_tmp)begin
		img_cnt	<=	img_cnt	 + 1;
		r_data_01	<=	im_buf[img_cnt*3*8 + 0];
		g_data_01	<=	im_buf[img_cnt*3*8 + 1];
		b_data_01	<=	im_buf[img_cnt*3*8 + 2];
		r_data_02	<=	im_buf[img_cnt*3*8 + 3];
		g_data_02	<=	im_buf[img_cnt*3*8 + 4];
		b_data_02	<=	im_buf[img_cnt*3*8 + 5];
		r_data_03	<=	im_buf[img_cnt*3*8 + 6];
		g_data_03	<=	im_buf[img_cnt*3*8 + 7];
		b_data_03	<=	im_buf[img_cnt*3*8 + 8];
		r_data_04	<=	im_buf[img_cnt*3*8 + 9];
		g_data_04	<=	im_buf[img_cnt*3*8 + 10];
		b_data_04	<=	im_buf[img_cnt*3*8 + 11];
		r_data_05	<=	im_buf[img_cnt*3*8 + 12];
		g_data_05	<=	im_buf[img_cnt*3*8 + 13];
		b_data_05	<=	im_buf[img_cnt*3*8 + 14];
		r_data_06	<=	im_buf[img_cnt*3*8 + 15];
		g_data_06	<=	im_buf[img_cnt*3*8 + 16];
		b_data_06	<=	im_buf[img_cnt*3*8 + 17];
		r_data_07	<=	im_buf[img_cnt*3*8 + 18];
		g_data_07	<=	im_buf[img_cnt*3*8 + 19];
		b_data_07	<=	im_buf[img_cnt*3*8 + 20];
		r_data_08	<=	im_buf[img_cnt*3*8 + 21];
		g_data_08	<=	im_buf[img_cnt*3*8 + 22];
		b_data_08	<=	im_buf[img_cnt*3*8 + 23];
	end else begin
		img_cnt	<=	img_cnt;
		r_data_01	<=	8'd0;
		g_data_01	<=	8'd0;
		b_data_01	<=	8'd0;
		r_data_02	<=	8'd0;
		g_data_02	<=	8'd0;
		b_data_02	<=	8'd0;
		r_data_03	<=	8'd0;
		g_data_03	<=	8'd0;
		b_data_03	<=	8'd0;
		r_data_04	<=	8'd0;
		g_data_04	<=	8'd0;
		b_data_04	<=	8'd0;
		r_data_05	<=	8'd0;
		g_data_05	<=	8'd0;
		b_data_05	<=	8'd0;
		r_data_06	<=	8'd0;
		g_data_06	<=	8'd0;
		b_data_06	<=	8'd0;
		r_data_07	<=	8'd0;
		g_data_07	<=	8'd0;
		b_data_07	<=	8'd0;
		r_data_08	<=	8'd0;
		g_data_08	<=	8'd0;
		b_data_08	<=	8'd0;
	end
end


assign	vs_in	=	vs_tmp;
assign	hs_in	=	hs_tmp_d1;
assign	de_in	=	de_tmp_d1;

assign	r_in_01	=	r_data_01;
assign	g_in_01	=	g_data_01;
assign	b_in_01	=	b_data_01;
                             
assign	r_in_02	=	r_data_02;
assign	g_in_02	=	g_data_02;
assign	b_in_02	=	b_data_02;
                             
assign	r_in_03	=	r_data_03;
assign	g_in_03	=	g_data_03;
assign	b_in_03	=	b_data_03;
                             
assign	r_in_04	=	r_data_04;
assign	g_in_04	=	g_data_04;
assign	b_in_04	=	b_data_04;
                             
assign	r_in_05	=	r_data_05;
assign	g_in_05	=	g_data_05;
assign	b_in_05	=	b_data_05;
                             
assign	r_in_06	=	r_data_06;
assign	g_in_06	=	g_data_06;
assign	b_in_06	=	b_data_06;
                             
assign	r_in_07	=	r_data_07;
assign	g_in_07	=	g_data_07;
assign	b_in_07	=	b_data_07;
                             
assign	r_in_08	=	r_data_08;
assign	g_in_08	=	g_data_08;
assign	b_in_08	=	b_data_08;





endmodule
