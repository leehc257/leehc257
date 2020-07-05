
module ycbcr2rgb(//5 clk delay, BT.709
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

	output	[7:0]	r_out,
	output	[7:0]	g_out,
	output	[7:0]	b_out

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
reg		[7:0]	y_minus; // 1bit sign 7bit data
reg		[8:0]	cb_minus, cr_minus; // 1bit sign 8bit data
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		y_minus		<=	8'd0;
	end else if(de_in)begin
		y_minus	<=	y_in - 8'd16;
	end else begin
		y_minus		<=	8'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cb_minus		<=	9'd0;
	end else if(de_in)begin
		if(cb_in >= 8'd128) begin
			cb_minus	<=	{1'b0, cb_in - 8'd128};
		end else begin
			cb_minus	<=	{1'b1, 8'd128 - cb_in};
		end
	end else begin
		cb_minus		<=	9'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cr_minus		<=	9'd0;
	end else if(de_in)begin
		if(cr_in >= 8'd128) begin
			cr_minus	<=	{1'b0, cr_in - 8'd128};
		end else begin
			cr_minus	<=	{1'b1, 8'd128 - cr_in};
		end
	end else begin
		cr_minus		<=	9'd0;
	end
end
reg		[16:0]	y_mul; // 9*8bit
reg		[15:0]	cb_mul_g;
reg		[18:0]	cb_mul_b;
reg		[17:0]	cr_mul_r;
reg		[16:0]	cr_mul_g; //9bit*9bit
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		y_mul	<=	17'd0;
	end else if(de_in_d[0])begin
		y_mul	<=	9'd298 * y_minus;
	end else begin
		y_mul	<=	17'd0;
	end
end
wire	[14:0]	cb_mul_tmp_1 = 7'd100 * cb_minus[7:0];
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cb_mul_g	<=	16'd0;
	end else if(de_in_d[0])begin
		cb_mul_g	<=	{!cb_minus[8], cb_mul_tmp_1};
	end else begin
		cb_mul_g	<=	16'd0;
	end
end
wire	[17:0]	cb_mul_tmp_2 = 10'd516 * cb_minus[7:0];
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cb_mul_b	<=	19'd0;
	end else if(de_in_d[0])begin
		cb_mul_b	<=	{cb_minus[8], cb_mul_tmp_2};
	end else begin
		cb_mul_b	<=	19'd0;
	end
end
wire	[16:0]	cr_mul_tmp_1 = 9'd409 * cr_minus[7:0];
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cr_mul_r	<=	18'd0;
	end else if(de_in_d[0])begin
		cr_mul_r	<=	{cr_minus[8], cr_mul_tmp_1};
	end else begin
		cr_mul_r	<=	18'd0;
	end
end
wire	[15:0]	cr_mul_tmp_2 = 8'd208 * cr_minus[7:0];
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cr_mul_g	<=	17'd0;
	end else if(de_in_d[0])begin
		cr_mul_g	<=	{!cr_minus[8], cr_mul_tmp_2};
	end else begin
		cr_mul_g	<=	17'd0;
	end
end
reg		[16:0]	r_add_1;
reg		[18:0]	r_add_2;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		r_add_1	<=	17'd0;
	end else if(de_in_d[1])begin
		r_add_1	<=	y_mul;
	end else begin
		r_add_1	<=	17'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		r_add_2	<=	19'd0;
	end else if(de_in_d[1])begin
		if(cr_mul_r[17]) begin
			if(cr_mul_r[16:0] >= 17'd128) begin
				r_add_2	<=	{1'd1, {1'd0, cr_mul_r[16:0]} - 18'd128};
			end else begin
				r_add_2	<=	{1'd0, 18'd128 - {1'd0, cr_mul_r[16:0]}};
			end
		end else begin
			r_add_2	<=	{1'd0, {1'd0, cr_mul_r[16:0]} + 18'd128};
		end
	end else begin
		r_add_2	<=	19'd0;
	end
end
reg		[18:0]	g_add_1;
reg		[17:0]	g_add_2;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		g_add_1	<=	19'd0;
	end else if(de_in_d[1])begin
		if(cb_mul_g[15]) begin
			if({2'd0, cb_mul_g[14:0]} >= y_mul) begin
				g_add_1	<=	{1'd1, {3'd0, cb_mul_g[14:0]} - {1'd0, y_mul}};
			end else begin
				g_add_1	<=	{1'd0, {1'd0, y_mul} - {3'd0, cb_mul_g[14:0]}};
			end
		end else begin
			g_add_1	<=	{1'd0, {1'd0, y_mul} + {3'd0, cb_mul_g[14:0]}};
		end
	end else begin
		g_add_1	<=	19'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		g_add_2	<=	18'd0;
	end else if(de_in_d[1])begin
		if(cr_mul_g[16]) begin
			if(cr_mul_g[15:0] >= 16'd128) begin
				g_add_2	<=	{1'd1, {1'd0, cr_mul_g[15:0]} - 17'd128};
			end else begin
				g_add_2	<=	{1'd0, 17'd128 - {1'd0, cr_mul_g[15:0]}};
			end
		end else begin
			g_add_2	<=	{1'd0, 17'd128 + {1'd0, cr_mul_g[15:0]}};
		end
	end else begin
		g_add_2	<=	18'd0;
	end
end

reg		[19:0]	b_add_1;
reg		[7:0]	b_add_2;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		b_add_1	<=	20'd0;
	end else if(de_in_d[1])begin
		if(cb_mul_b[18]) begin
			if( cb_mul_b[17:0] >= {1'd0, y_mul}) begin
				b_add_1	<=	{1'd1, {1'd0, cb_mul_b[17:0]} - {2'd0, y_mul}};
			end else begin
				b_add_1	<=	{1'd0, {2'd0, y_mul} - {1'd0, cb_mul_b[17:0]}};
			end
		end else begin
			b_add_1	<=	{1'd0, {2'd0, y_mul} + {1'd0, cb_mul_b[17:0]}};
		end
	end else begin
		b_add_1	<=	20'd0;
	end
end

always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		b_add_2	<=	8'd0;
	end else if(de_in_d[1]) begin
		b_add_2	<=	8'd128;
	end else begin
		b_add_2	<=	8'd0;
	end
end

reg		[19:0]	r_add_3;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		r_add_3	<=	19'd0;
	end else if(de_in_d[2]) begin
		if(r_add_2[18]) begin
			if(r_add_2[17:0] >= {1'd0, r_add_1}) begin // underflow
				r_add_3	<=	19'd0;
			end else begin
				r_add_3	<=	{1'd0, r_add_1} - r_add_2[17:0];
			end
		end else begin
			r_add_3	<=	{1'd0, r_add_1} + r_add_2[17:0];
		end
	end else begin
		r_add_3	<=	19'd0;
	end
end
reg		[18:0]	g_add_3;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		g_add_3	<=	19'd0;
	end else if(de_in_d[2]) begin
		if(g_add_1[18] ^ g_add_2[17]) begin // sign a != sign b
			if({1'd0, g_add_1[17:0]} >= {2'd0, g_add_2[16:0]})begin
				if(g_add_1[18]) begin // underflow
					g_add_3	<=	19'd0;
				end else begin
					g_add_3	<=	{1'd0, g_add_1[17:0]} - {2'd0, g_add_2[16:0]};
				end
			end else begin
				if(g_add_2[17])begin // underflow
					g_add_3	<=	19'd0;
				end else begin
					g_add_3	<=	{2'd0, g_add_2[16:0]} - {1'd0, g_add_1[17:0]};
				end
			end 
		end else begin
			g_add_3	<=	{1'd0, g_add_1[17:0]} + {2'd0, g_add_2[16:0]};
		end
	end else begin
		g_add_3	<=	19'd0;
	end
end
reg		[19:0]	b_add_3;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		b_add_3	<=	20'd0;
	end else if(de_in_d[2]) begin
		if(b_add_1[19]) begin
			if(b_add_1[18:0] >= 19'd128) begin//underflow
				b_add_3	<=	20'd0;
			end else begin
				b_add_3	<=	20'd128 - {1'd0, b_add_1[18:0]};
			end
		end else begin
			b_add_3	<=	{1'd0, b_add_1[18:0]} + 20'd128;
		end
	end else begin
		b_add_3	<=	20'd0;
	end
end

reg		[7:0]	r_data, g_data, b_data;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		r_data	<=	8'd0;
	end else if(de_in_d[3])begin
		if(|r_add_3[19:16])begin//overflow
			r_data	<=	8'd255;
		end else begin
			r_data	<=	r_add_3[15-:8];
		end
	end else begin
		r_data	<=	8'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		g_data	<=	8'd0;
	end else if(de_in_d[3])begin
		if(|g_add_3[18:16])begin//overflow
			g_data	<=	8'd255;
		end else begin
			g_data	<=	g_add_3[15-:8];
		end
	end else begin
		g_data	<=	8'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		b_data	<=	8'd0;
	end else if(de_in_d[3])begin
		if(|b_add_3[19:16])begin//overflow
			b_data	<=	8'd255;
		end else begin
			b_data	<=	b_add_3[15-:8];
		end
	end else begin
		b_data	<=	8'd0;
	end
end

assign		vs_out 		=	vs_in_d[4];
assign		hs_out 		=	hs_in_d[4];
assign		de_out 		=	de_in_d[4];

assign		r_out		=	r_data;
assign		g_out		=	g_data;
assign		b_out		=	b_data;
endmodule
