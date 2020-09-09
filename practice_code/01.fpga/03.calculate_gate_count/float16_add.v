
module float16_add( //5clk delay
	input			clk,
	input			rst_b,

	input			de_in,
	input	[15:0]	data_in_01,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_02,

	output			de_out,
	output	[15:0]	data_out

);

reg		[9:0]	de_in_d;

always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		de_in_d	<=	10'd0;
	end else begin
		de_in_d	<=	{de_in_d[8:0], de_in};
	end
end

reg				sign_1, sign_2;//de_in_d[0]
reg		[4:0]	exp_1, exp_2;
reg		[9:0]	frac_1, frac_2;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		sign_1	<=	1'd0;
		sign_2	<=	1'd0;
		exp_1	<=	5'd0;
		exp_2	<=	5'd0;
		frac_1	<=	10'd0;
		frac_2	<=	10'd0;
	end else begin
		sign_1	<=	data_in_01[15];
		sign_2	<=	data_in_02[15];
		exp_1	<=	data_in_01[14-:5];
		exp_2	<=	data_in_02[14-:5];
		frac_1	<=	data_in_01[9-:10];
		frac_2	<=	data_in_02[9-:10];
	end
end
// preprocess
reg		[25:0]	frac_1_pre, frac_2_pre;//de_in_d[1]
always @(posedge clk or negedge rst_b) begin 
	if(!rst_b)begin
		frac_1_pre		<=	26'd0;
		frac_2_pre		<=	26'd0;
	end else if(exp_1 == 5'd0) begin // data 1 == zero
		frac_1_pre		<=	26'd0;
		frac_2_pre		<=	{1'd1, frac_2, 15'd0} ;
	end else if(exp_2 == 5'd0) begin // data 2 == zero
		frac_1_pre		<=	{1'd1, frac_1, 15'd0} ;
		frac_2_pre		<=	26'd0;
	end else if(exp_1 > exp_2) begin // max == exp_1
		frac_1_pre		<=	{1'd1, frac_1, 15'd0} ;
		frac_2_pre		<=	{1'd1, frac_2, 15'd0} >> (exp_1 - exp_2);
	end else begin // exp_1 <= exp_2
		frac_1_pre		<=	{1'd1, frac_1, 15'd0} >> (exp_2 - exp_1);
		frac_2_pre		<=	{1'd1, frac_2, 15'd0} ;
	end
end

reg				sign_1_d1, sign_2_d1;
reg		[4:0]	exp_1_d1, exp_2_d1;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		sign_1_d1	<=	1'd0;
		sign_2_d1	<=	1'd0;
		exp_1_d1	<=	5'd0;
		exp_2_d1	<=	5'd0;
	end else begin
		sign_1_d1	<=	sign_1;
		sign_2_d1	<=	sign_2;
		exp_1_d1	<=	exp_1;
		exp_2_d1	<=	exp_2;
	end
end
reg				sign_sel;
reg		[26:0] frac_sum; // de_in_d[2]
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		frac_sum	<=	27'd0;
		sign_sel	<=	1'd0;
	end else if(sign_1_d1 == sign_2_d1)begin
		frac_sum	<=	{1'd0, frac_1_pre} + {1'd0, frac_2_pre};
		sign_sel	<=	sign_1_d1;
	end else begin// diff sign
		if(frac_1_pre >= frac_2_pre) begin
			frac_sum	<=	{1'd0, frac_1_pre} - {1'd0, frac_2_pre};
			sign_sel	<=	sign_1_d1;
		end else begin
			frac_sum	<=	{1'd0, frac_2_pre} - {1'd0, frac_1_pre};
			sign_sel	<=	sign_2_d1;
		end
	end
end
reg		[5:0]	new_exp;
reg		[4:0]	max_exp; 
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		max_exp	<=	5'd0;
	end else begin
		if(exp_1_d1 >= exp_2_d1) begin
			max_exp	<=	exp_1_d1;
		end else begin
			max_exp	<=	exp_2_d1;
		end
	end
end
reg				sign_sel_d1;
reg		[9:0]	frac_norm;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		sign_sel_d1	<=	1'd0;
	end else begin
		sign_sel_d1	<=	sign_sel;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		new_exp	<=	6'd0;
	end else begin
		casex(frac_sum[26-:17])//overflow, carrybit, frac_data
			17'b1x_xxxx_xxxx_xxxx_xxx : begin new_exp	<=	max_exp + 6'd1; 	frac_norm	<=	frac_sum[25-:10];	end //left_shift
			17'b01_xxxx_xxxx_xxxx_xxx : begin new_exp	<=	max_exp 	  ; 	frac_norm	<=	frac_sum[24-:10];	end //
			17'b00_1xxx_xxxx_xxxx_xxx : begin new_exp	<=	max_exp - 6'd1; 	frac_norm	<=	frac_sum[23-:10];	end //
			17'b00_01xx_xxxx_xxxx_xxx : begin new_exp	<=	max_exp - 6'd2; 	frac_norm	<=	frac_sum[22-:10];	end //
			17'b00_001x_xxxx_xxxx_xxx : begin new_exp	<=	max_exp - 6'd3; 	frac_norm	<=	frac_sum[21-:10];	end //
			17'b00_0001_xxxx_xxxx_xxx : begin new_exp	<=	max_exp - 6'd4; 	frac_norm	<=	frac_sum[20-:10];	end //
			17'b00_0000_1xxx_xxxx_xxx : begin new_exp	<=	max_exp - 6'd5; 	frac_norm	<=	frac_sum[19-:10];	end //
			17'b00_0000_01xx_xxxx_xxx : begin new_exp	<=	max_exp - 6'd6; 	frac_norm	<=	frac_sum[18-:10];	end //
			17'b00_0000_001x_xxxx_xxx : begin new_exp	<=	max_exp - 6'd7; 	frac_norm	<=	frac_sum[17-:10];	end //
			17'b00_0000_0001_xxxx_xxx : begin new_exp	<=	max_exp - 6'd8; 	frac_norm	<=	frac_sum[16-:10];	end //
			17'b00_0000_0000_1xxx_xxx : begin new_exp	<=	max_exp - 6'd9; 	frac_norm	<=	frac_sum[15-:10];	end //
			17'b00_0000_0000_01xx_xxx : begin new_exp	<=	max_exp - 6'd10; 	frac_norm	<=	frac_sum[14-:10];	end //
			17'b00_0000_0000_001x_xxx : begin new_exp	<=	max_exp - 6'd11; 	frac_norm	<=	frac_sum[13-:10];	end //
			17'b00_0000_0000_0001_xxx : begin new_exp	<=	max_exp - 6'd12; 	frac_norm	<=	frac_sum[12-:10];	end //
			17'b00_0000_0000_0000_1xx : begin new_exp	<=	max_exp - 6'd13; 	frac_norm	<=	frac_sum[11-:10];	end //
			17'b00_0000_0000_0000_01x : begin new_exp	<=	max_exp - 6'd14; 	frac_norm	<=	frac_sum[10-:10];	end //
			17'b00_0000_0000_0000_001 : begin new_exp	<=	max_exp - 6'd15; 	frac_norm	<=	frac_sum[ 9-:10];	end //
			default : begin	new_exp	<=	6'd0; frac_norm	<=	10'd0;end //data zero
		endcase
	end
end
reg		[4:0]	final_exp;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		final_exp	<=	5'd0;
	end else if(new_exp[5])begin
		final_exp	<=	5'd31;
	end else begin
		final_exp	<=	new_exp[4:0];
	end
end
reg		[9:0]	final_frac;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		final_frac	<=	10'd0;
	end else if(new_exp[5])begin
		final_frac	<=	10'd1023;
	end else begin
		final_frac	<=	frac_norm	;
	end
end
reg				final_sign;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		final_sign	<=	1'd0;
	end else begin
		final_sign	<=	sign_sel_d1;
	end
end

assign			de_out		= de_in_d[4];
assign			data_out	= {final_sign, final_exp, final_frac};

endmodule
