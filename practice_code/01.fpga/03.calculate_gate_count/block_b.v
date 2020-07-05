
module block_b( //5clk delay
	input			clk,
	input			rst_b,

	input	[35:0]	data_in_01,// sign 1, exp 5, frac 10
	input	[35:0]	data_in_02,

	output	[35:0]	data_out

);
wire	signed 	[35:0]	data_in_01_tmp = data_in_01[35]? $signed({data_in_01[35], ~data_in_01[34:0]+35'd1}): data_in_01;
wire	signed 	[35:0]	data_in_02_tmp = data_in_02[35]? $signed({data_in_02[35], ~data_in_02[34:0]+35'd1}): data_in_02;
reg	signed	[36:0] 	data_sum_tmp;	
always @(posedge clk or negedge rst_b)begin
	if(!rst_b)begin
		data_sum_tmp	<=	37'd0;
	end else begin
		data_sum_tmp	<=	data_in_01_tmp + data_in_02_tmp;
	end
end

assign	data_out = (data_sum_tmp[36-:2] == 2'd0) ? {1'b0, 35'h7_ffff_ffff}:
				   (data_sum_tmp[36-:2] == 2'd1) ? {1'b1, ~data_sum_tmp[34:0]+35'd1} :
				   (data_sum_tmp[36-:2] == 2'd2) ? data_sum_tmp[35:0]: 36'h7_ffff_ffff;



endmodule
