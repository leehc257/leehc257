`timescale 1 ns/10 ps

`define IMAGE_V_SIZE	30
`define IMAGE_H_SIZE	1920

`define H_BACK_PORCH	148 // hmax - hpe + 1  148
`define H_FRONT_PORCH	88 // hps - width     88
`define H_WIDTH			44 // hpe - hps       44

`define V_BACK_PORCH	36 // vmax - vpe + 1   36
`define V_FRONT_PORCH	4 // vps - width      4
`define V_WIDTH			5 // vpe - vps        5


module gpu_1port(
	input			clk,
	input			rst_b,

	output			vs_in,
	output			hs_in,
	output			de_in,

	output	[7:0]	r_in,
	output	[7:0]	g_in,
	output	[7:0]	b_in

);


reg		[11:0] clk_cnt;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		clk_cnt	<=	12'd0;
	end else begin
		if(clk_cnt == `IMAGE_H_SIZE + `H_BACK_PORCH	+ `H_FRONT_PORCH + `H_WIDTH)begin
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
		if(clk_cnt > `H_BACK_PORCH + `H_WIDTH && clk_cnt <=  `H_BACK_PORCH +`IMAGE_H_SIZE + `H_WIDTH)begin
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

reg		[7:0]	r_data;
reg		[7:0]	g_data;
reg		[7:0]	b_data;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		r_data	<=	8'd0;
		g_data	<=	8'd0;
		b_data	<=	8'd0;
		img_cnt	<=	0;
	end else if(!vs_tmp)begin
		img_cnt	<=	0;
	end else if(de_tmp)begin
		img_cnt	<=	img_cnt	 + 1;
		r_data	<=	im_buf[img_cnt*3 + 0];
		g_data	<=	im_buf[img_cnt*3 + 1];
		b_data	<=	im_buf[img_cnt*3 + 2];
	end else begin
		img_cnt	<=	img_cnt;
		r_data	<=	8'd0;
		g_data	<=	8'd0;
		b_data	<=	8'd0;
	end
end


assign	vs_in	=	vs_tmp;
assign	hs_in	=	hs_tmp_d1;
assign	de_in	=	de_tmp_d1;

assign	r_in	=	r_data;
assign	g_in	=	g_data;
assign	b_in	=	b_data;





endmodule
