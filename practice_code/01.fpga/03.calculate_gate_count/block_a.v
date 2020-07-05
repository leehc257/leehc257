
module block_a( //5clk delay
	input			clk,
	input			rst_b,

	input	[35:0]	data_in_01,// sign 1, exp 5, frac 10
	input	[35:0]	data_in_02,

	output	[35:0]	data_out

);

reg		[36:0] 	data_sum_tmp;	
always @(posedge clk or negedge rst_b)begin
	if(!rst_b)begin
		data_sum_tmp	<=	37'd0;
	end else if(data_in_01 == data_in_02) begin
		data_sum_tmp	<=	{data_in_01[35], {1'd0, data_in_01[34:0]} + {1'd0, data_in_02[34:0]}};
	end else begin
		if(data_in_01[34:0] > data_in_02[34:0])begin
			data_sum_tmp	<=	{data_in_01[35], {1'd0, data_in_01[34:0]} - {1'd0, data_in_02[34:0]}};
		end else begin
			data_sum_tmp	<=	{data_in_02[35], {1'd0, data_in_02[34:0]} - {1'd0, data_in_01[34:0]}};
		end
	end
end

assign data_out = !data_sum_tmp[35] ? {data_sum_tmp[36], data_sum_tmp[34:0]} : {data_sum_tmp[36], 35'h7_ffff_ffff};
				  



endmodule
