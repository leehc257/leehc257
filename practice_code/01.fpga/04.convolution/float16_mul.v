
module float16_mul( //3clk delay
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
reg		[10:0]	frac_1, frac_2;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		sign_1	<=	1'd0;
		sign_2	<=	1'd0;
		exp_1	<=	5'd0;
		exp_2	<=	5'd0;
		frac_1	<=	11'd0;
		frac_2	<=	11'd0;
	end else begin
		sign_1	<=	data_in_01[15];
		sign_2	<=	data_in_02[15];
		exp_1	<=	data_in_01[14-:5];
		exp_2	<=	data_in_02[14-:5];
		frac_1	<=	{1'b1, data_in_01[9-:10]};
		frac_2	<=	{1'b1, data_in_02[9-:10]};
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
// preprocess
reg		[21:0]	frac_mul;//de_in_d[1]
always @(posedge clk or negedge rst_b) begin 
	if(!rst_b)begin
		frac_mul		<=	22'd0;
	end else if(exp_1 == 5'd0 || exp_2 == 5'd0) begin // data  == zero
		frac_mul		<=	22'd0;
	end else begin 
		frac_mul		<=	frac_1 * frac_2;
	end
end
reg		[6:0]	exp_mul;
always @(posedge clk or negedge rst_b) begin 
	if(!rst_b)begin
		exp_mul	<=	7'd0;
	end else if(exp_1_d1 == 5'd0 || exp_2 == 5'd0) begin // data == zero
		exp_mul	<=	7'd0;
	end else begin
		exp_mul	<=	{2'd0,exp_1_d1} + {2'd0,exp_2_d1} - 7'd15 + {6'd0, frac_mul[21]};
	end
end
reg				sign_mul;
reg		[21:0]	frac_mul_d1;
always @(posedge clk or negedge rst_b) begin 
	if(!rst_b)begin
		sign_mul	<=	1'd0;
		frac_mul_d1	<=	22'd0;
	end else begin
		sign_mul	<=	sign_1_d1 ^ sign_2_d1;
		frac_mul_d1	<=	frac_mul;	
	end
end
reg		[4:0]	final_exp;
reg				final_sign;	
reg		[9:0]	final_frac;
always @(posedge clk or negedge rst_b) begin 
	if(!rst_b)begin
		final_exp	<=	5'd0;
		final_sign	<=	1'd0;
	end else if(de_in_d[1]) begin
		final_exp	<=	exp_mul[6]?  5'd1 : (exp_mul[5]?  5'd31 : exp_mul[4:0]) ;
		final_sign	<=	sign_mul;
	end else begin
		final_exp	<=	5'd0;
		final_sign	<=	1'd0;
	end
end
always @(posedge clk or negedge rst_b) begin 
	if(!rst_b)begin
		final_frac	<=	10'd0;
	end else if(de_in_d[1]) begin
		if(exp_mul[6]) begin// underflow
			final_frac	<=	10'd0;
		end else begin
			if(exp_mul[5]) begin //overflow
				final_frac	<=	10'd1023;
			end else begin
				if(frac_mul_d1[21]) begin
					final_frac	<=	frac_mul_d1[20-:10];
				end else begin
					final_frac	<=	frac_mul_d1[19-:10];
				end
			end
		end
	end else begin
		final_frac	<=	10'd0;
	end
end
assign			de_out		= de_in_d[2];
assign			data_out	= {final_sign, final_exp, final_frac};

endmodule
