
module mem_1port #(
	parameter		ADDR_BIT = 10,
	parameter		DATA_BIT = 32
)(
	input					clk,
	input					rst_b,
	     	
	input					wr_en,
	input	[ADDR_BIT-1:0]	wr_addr,	
	input	[DATA_BIT-1:0]	wr_data,	
		
	input	 				rd_en,
	input	[ADDR_BIT-1:0]	rd_addr,	
	output	[DATA_BIT-1:0]	rd_data	

);
reg		[DATA_BIT-1:0] buffer [2**ADDR_BIT-1:0];

always @(posedge clk or negedge rst_b) begin
	if(wr_en) begin
		buffer[wr_addr]	<=	wr_data;
	end
end

reg		[DATA_BIT-1:0] rd_data_tmp;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		rd_data_tmp	<=	{DATA_BIT{1'd0}};
	end else if(rd_en)begin
		rd_data_tmp	<=	buffer[rd_addr];
	end
end

assign		rd_data = rd_data_tmp;
endmodule
