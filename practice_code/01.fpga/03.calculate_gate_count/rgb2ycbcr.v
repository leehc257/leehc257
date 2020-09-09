
module rgb2ycbcr(// 5clk delay, BT.709
	input			clk,
	input			rst_b,

	input			vs_in,
	input			hs_in,
	input			de_in,

	input	[7:0]	r_in,
	input	[7:0]	g_in,
	input	[7:0]	b_in,
	
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

reg		[15:0]	y_r, y_g, y_b;
reg		[15:0]	cb_r, cb_g, cb_b;
reg		[15:0]	cr_r, cr_g, cr_b;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		y_r		<=	16'd0;
		cb_r	<=	16'd0;
		cr_r	<=	16'd0;

		y_g		<=	16'd0;
		cb_g	<=	16'd0;
		cr_g	<=	16'd0;

		y_b		<=	16'd0;
		cb_b	<=	16'd0;
		cr_b	<=	16'd0;
	end else if(de_in) begin
		y_r		<=	8'd66 * r_in;
		cb_r	<=	8'd38 * r_in;
		cr_r	<=	8'd112 * r_in;

		y_g		<=	8'd129 * g_in;
		cb_g	<=	8'd74 * g_in;
		cr_g	<=	8'd94 * g_in;

		y_b		<=	8'd25 * b_in;
		cb_b	<=	8'd112 * b_in;
		cr_b	<=	8'd18 * b_in;
	end else begin
		y_r		<=	16'd0;
		cb_r	<=	16'd0;
		cr_r	<=	16'd0;
		
		y_g		<=	16'd0;
		cb_g	<=	16'd0;
		cr_g	<=	16'd0;

		y_b		<=	16'd0;
		cb_b	<=	16'd0;
		cr_b	<=	16'd0;
	end
end
reg		[16:0]	y_r_g, cb_r_g, cr_g_b;// 16bit + 16bit(no sign bit)
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		y_r_g	<=	17'd0;
		cb_r_g	<=	17'd0;
		cr_g_b	<=	17'd0;
	end else if(de_in_d[0]) begin
		y_r_g 	<=	y_r + y_g;
		cb_r_g	<=	cb_r + cb_g;
		cr_g_b	<=	cr_g + cr_b;
	end else begin
		y_r_g	<=	17'd0;
		cb_r_g	<=	17'd0;
		cr_g_b	<=	17'd0;
	end
end
reg		[16:0]	y_b_128, cb_b_128, cr_r_128;// 16bit + 16bit(no sign bit)
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		y_b_128 	<=	17'd0;
		cb_b_128	<=	17'd0; 
		cr_r_128	<=	17'd0;
	end else if(de_in_d[0])begin
		y_b_128 	<=	y_b + 16'd128;
		cb_b_128	<=	cb_b + 16'd128; 
		cr_r_128	<=	cr_r + 16'd128;
	end else begin
		y_b_128 	<=	17'd0;
		cb_b_128	<=	17'd0; 
		cr_r_128	<=	17'd0;
	end
end
reg		[18:0] y_sum; // 17bit + 17bit = 18bit + 1bit(sign bit)
reg		[17:0] cb_sum, cr_sum; // 17bit + 17bit = 17bit + 1bit(sign bit)
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		y_sum	<=	19'd0;
	end else if(de_in_d[1])begin
		y_sum	<=	y_r_g + y_b_128;
	end else begin
		y_sum	<=	19'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cb_sum	<=	18'd0;
	end else if(de_in_d[1])begin
		if(cb_r_g <= cb_b_128) begin// plus
			cb_sum	<=	{1'd0, cb_b_128 - cb_r_g};
		end else begin
			cb_sum	<=	{1'd1, cb_r_g - cb_b_128 };
		end
	end else begin
		cb_sum	<=	18'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cr_sum	<=	18'd0;
	end else if(de_in_d[1])begin
		if(cr_r_128 >= cr_g_b) begin
			cr_sum	<=	{1'd0, cr_r_128 - cr_g_b};
		end else begin
			cr_sum	<=	{1'd1, cr_g_b - cr_r_128};
		end
	end else begin
		cr_sum	<=	18'd0;
	end
end
reg		[10:0]	y_shift_sum;// 10bit + 8bit : no minus sign
reg		[9:0]	cb_shift_sum, cr_shift_sum;// 9bit + 8bit : no minus sign
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		y_shift_sum	<=	11'd0;
	end else if(de_in_d[2]) begin
		y_shift_sum	<=	{1'd0, y_sum[17-:10]} + 11'd16 ;
	end else begin
		y_shift_sum	<=	11'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cb_shift_sum	<=	10'd0;
	end else if(de_in_d[2]) begin
		if(cb_sum[17]) begin//minus
			cb_shift_sum	<=	10'd128 - {1'd0, cb_sum[16-:9]}  ;
		end else begin
			cb_shift_sum	<=	{1'd0, cb_sum[16-:9]} + 10'd128;
		end
	end else begin
		cb_shift_sum	<=	10'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cr_shift_sum	<=	10'd0;
	end else if(de_in_d[2]) begin
		if(cr_sum[17]) begin//minus
			cr_shift_sum	<=	10'd128 - {1'd0, cr_sum[16-:9]} ; 
		end else begin
			cr_shift_sum	<=	{1'd0, cr_sum[16-:9]} + 10'd128;
		end
	end else begin
		cr_shift_sum	<=	10'd0;
	end
end

reg	[7:0]	y_tmp, cb_tmp, cr_tmp;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		y_tmp	<=	8'd0;
	end else if(de_in_d[3]) begin
		if(|y_shift_sum[10:8])begin
			y_tmp	<=	8'd255;
		end else begin
			y_tmp	<=	y_shift_sum[7:0];
		end
	end else begin
		y_tmp	<=	8'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		cb_tmp	<=	8'd0;
	end else if(de_in_d[3]) begin
		if(|cb_shift_sum[9:8])begin
			cb_tmp	<=	8'd255;
		end else begin
			cb_tmp	<=	cb_shift_sum[7:0];
		end
	end else begin
		cb_tmp	<=	8'd0;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		 cr_tmp	<=	8'd0;
	end else if(de_in_d[3]) begin
		if(|cr_shift_sum[9:8])begin
			cr_tmp	<=	8'd255;
		end else begin
			cr_tmp	<=	cr_shift_sum[7:0];
		end
	end else begin
		cr_tmp	<=	8'd0;
	end
end
assign		y_out	=	y_tmp;	
assign		cb_out	=	cb_tmp;
assign		cr_out	=	cr_tmp;

assign		vs_out	=	vs_in_d[4];
assign		hs_out	=	hs_in_d[4];
assign		de_out	=	de_in_d[4];


endmodule
