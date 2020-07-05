
module delete_block(// 2 clk delay
	input			clk,
	input			rst_b,

	input			vs_in,
	input			hs_in,
	input			de_in,

	input	[7:0]	data1_in,
	input	[7:0]	data2_in,
	input	[7:0]	data3_in,
	
	output			vs_out,
	output			hs_out,
	output			de_out,

	output	[7:0]	data1_out,
	output	[7:0]	data2_out,
	output	[7:0]	data3_out

);

reg		[9:0]	vs_in_d;
reg		[9:0]	hs_in_d;
reg		[9:0]	de_in_d;
reg		[7:0]	data_1_in_d1, data_2_in_d1, data_3_in_d1; 
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		vs_in_d	<=	10'd0;
		hs_in_d	<=	10'd0;
		de_in_d	<=	10'd0;
		data_1_in_d1	<=	10'd0;
		data_2_in_d1	<=	10'd0;
		data_3_in_d1	<=	10'd0;
	end else begin
		vs_in_d	<=	{vs_in_d[8:0], vs_in};
		hs_in_d	<=	{hs_in_d[8:0], hs_in};
		de_in_d	<=	{de_in_d[8:0], de_in};
		data_1_in_d1	<=	data1_in;
		data_2_in_d1	<=	data2_in;
		data_3_in_d1	<=	data3_in;
	end
end
reg		[11:0]	row_cnt;
reg		[11:0]	col_cnt;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		row_cnt	<=	12'd0;
	end else if(~vs_in) begin
		row_cnt	<=	12'd0;
	end else if(de_in && ~de_in_d[0])begin
		row_cnt	<=	row_cnt + 12'd1;
	end else begin
		row_cnt	<=	row_cnt;
	end
end
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		col_cnt	<=	12'd0;
	end else if(de_in) begin
		col_cnt	<=	col_cnt + 12'd1;
	end else begin
		col_cnt	<=	12'd0;
	end
end
reg		[7:0]	data_1_del, data_2_del, data_3_del; 
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		data_1_del	<=	8'd0;
		data_2_del	<=	8'd0;
		data_3_del	<=	8'd0;
	end else if(de_in_d[0])begin
		if(row_cnt >= 12'd11 && row_cnt <= 12'd20 && col_cnt >= 12'd11 && col_cnt <= 12'd20) begin
			data_1_del	<=	8'd0;
			data_2_del	<=	8'd0;
			data_3_del	<=	8'd0;
		end else begin
			data_1_del	<=	data_1_in_d1;
			data_2_del	<=	data_2_in_d1;
			data_3_del	<=	data_3_in_d1;
		end
	end else begin
		data_1_del	<=	8'd0;
		data_2_del	<=	8'd0;
		data_3_del	<=	8'd0;
	end
end

assign			vs_out		= vs_in_d[1];
assign			hs_out		= hs_in_d[1];
assign			de_out		= de_in_d[1];
assign			data1_out	= data_1_del;
assign			data2_out	= data_2_del;
assign			data3_out	= data_3_del;

endmodule
