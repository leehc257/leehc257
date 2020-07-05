
module de_delay( // 2clk delay
	input			clk,
	input			rst_b

	input			vs_in,
	input			hs_in,
	input			de_in,
	
	input	[10:0]	delay_num,
	input	[10:0]	row_size,
	input	[11:0]	col_size,

	output			vs_out,
	output			hs_out,
	output			de_out

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
	end else if(!vs_in)begin
		line_cnt	<=	11'd0;
	end else if(de_in && ~de_in_d[0]) begin
		line_cnt	<=	line_cnt + 11'd1;
	end else begin
		line_cnt	<=	line_cnt;
	end
end
reg		[11:0]	clk_cnt;

always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		clk_cnt	<=	12'd0;
	end else if(line_cnt == row_size && hs_in && !hs_in_d[0])begin // rising edge
		clk_cnt	<=	12'd2;
	end else if(|clk_cnt) begin
		if(&clk_cnt) begin
			clk_cnt	<=	clk_cnt;
		end else begin
			clk_cnt	<=	clk_cnt	 + 12'd1;
		end
	end else begin
		clk_cnt	<=	12'd0;
	end
end
reg		[10:0]	new_line_cnt;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		new_line_cnt	<=	11'd0;
	end else if(!vs_in) begin
		new_line_cnt	<=	11'd0;
	end else if(hs_in && !hs_in_d[0] && line_cnt == row_size) begin
		new_line_cnt	<=	new_line_cnt	+ 11'd1;
	end else begin
		new_line_cnt	<=	new_line_cnt;
	end
end
reg		[10:0]	hs_back_porch;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		hs_back_porch	<=	11'd0;
	end else if(line_cnt < row_size - 11'd1) begin
		hs_back_porch	<=	hs_back_porch;
	end else if(line_cnt == row_size - 11'd1) begin
		if(hs_in && !hs_in_d[0] )begin
			hs_back_porch	<=	11'd1;
		end else if(hs_in && !de_in) begin
			hs_back_porch	<=	hs_back_porch + 11'd1;
		end else begin
			hs_back_porch	<=	hs_back_porch;
		end
	end else begin
		hs_back_porch	<=	hs_back_porch;
	end
end


reg				new_de;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		new_de	<=	1'd0;
	end else if(!vs_in) begin
		new_de	<=	1'd0;
	end else if(clk_cnt >= {1'd0, hs_back_porch} && clk_cnt < {1'd0, hs_back_porch} + col_size  && new_line_cnt <= delay_num && new_line_cnt >=11'd1)begin
		new_de	<=	1'd1;
	end else begin
		new_de	<=	1'd0;
	end
end

reg				loss_de;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		loss_de	<=	1'd0;
	end else if(line_cnt <= delay_num)begin
		loss_de	<=	1'd0;
	end else begin
		loss_de	<=	de_in_d[0];
	end
end

reg		[4:0]		new_de_d;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		new_de_d	<=	5'd0;
	end else begin
		new_de_d	<=	{new_de_d[3:0], new_de};
	end
end
reg		[11:0]		hs_cnt_total;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		hs_cnt_total	<=	12'd0;
	end else if(line_cnt == 11'd9) begin
		hs_cnt_total	<=	12'd0;
	end else if(line_cnt == 11'd10)begin
		hs_cnt_total	<=	hs_cnt_total	+ 12'd1;
	end else begin
		hs_cnt_total	<=	hs_cnt_total;
	end
end
// -------------------------front porch-----------------------
reg		[11:0]		vs_blank_cnt_f;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		vs_blank_cnt_f	<=	12'd0;
	end else if(!vs_in && vs_in_d[0]) begin
		vs_blank_cnt_f	<=	12'd1;
	end else if(|vs_blank_cnt_f)begin
		if(de_in) begin
			vs_blank_cnt_f	<=	12'd0;
		end else if(vs_blank_cnt_f == hs_cnt_total) begin
			vs_blank_cnt_f	<=	12'd1;
		end else begin
			vs_blank_cnt_f	<=	vs_blank_cnt_f + 12'd1;
		end
	end else begin
		vs_blank_cnt_f	<=	12'd0;
	end
end
reg		[11:0]		vs_delay_line_cnt_f;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		vs_delay_line_cnt_f	<=	12'd0;
	end else if(vs_blank_cnt_f == 12'd1) begin
		vs_delay_line_cnt_f	<=	vs_delay_line_cnt_f	+ 12'd1;
	end else if(de_in) begin
		vs_delay_line_cnt_f	<=	12'd0;
	end else begin
		vs_delay_line_cnt_f	<=	vs_delay_line_cnt_f;
	end
end

reg					new_vs_f;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		new_vs_f	<=	1'd0;
	end else if(vs_delay_line_cnt_f <= delay_num) begin //3clk delay
		new_vs_f	<=	1'd1;
	end else begin
		new_vs_f	<=	1'd0;
	end
end
// -------------------------front porch-----------------------

// -------------------------back porch-----------------------
reg		[11:0]		 vs_blank_cnt_b;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		vs_blank_cnt_b	<=	12'd0;
	end else if(!vs_in)begin
		vs_blank_cnt_b	<=	12'd0;
	end else begin
		if(vs_in && !vs_in_d[0])begin
			vs_blank_cnt_b	<=	12'd1;
		end else if(|vs_blank_cnt_b	)begin
			if(vs_blank_cnt_b	== hs_cnt_total	) begin
				vs_blank_cnt_b	<=	12'd1;
			end else begin
				vs_blank_cnt_b	<=	vs_blank_cnt_b	+ 12'd1;
			end
		end else begin
			vs_blank_cnt_b	<=	12'd0;
		end
	end
end
reg		[11:0]		vs_delay_line_cnt_b;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		vs_delay_line_cnt_b	<=	12'd0;
	end else if(vs_blank_cnt_b == 12'd1) begin
		vs_delay_line_cnt_b	<=	vs_delay_line_cnt_b	+ 12'd1;
	end else if(de_in) begin
		vs_delay_line_cnt_b	<=	12'd0;
	end else begin
		vs_delay_line_cnt_b	<=	vs_delay_line_cnt_b;
	end
end
reg					new_vs_b;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		new_vs_b	<=	1'd0;
	end else if(vs_delay_line_cnt_b	<= delay_num) begin //3clk delay
		new_vs_b	<=	1'd0;
	end else begin
		new_vs_b	<=	1'd1;
	end
end
reg		loss_de_d1;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		loss_de_d1	<=	1'd0;
	end else begin
		loss_de_d1	<=	loss_de;
	end
end
// -------------------------back porch-----------------------
assign			vs_out = new_vs_f | new_vs_b;
assign			hs_out = hs_in_d[2];
assign			de_out = loss_de_d1 | new_de_d[2]    ;

reg		[10:0]	test_cnt;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		test_cnt	<=	11'd0;
	end else if(hs_in && !de_in) begin
		test_cnt	<=	test_cnt + 11'd1;
	end else begin
		test_cnt	<=	11'd0;
	end
end
wire				new_line_pulse = (clk_cnt ==2)? 1'd1: 1'd0;

endmodule
