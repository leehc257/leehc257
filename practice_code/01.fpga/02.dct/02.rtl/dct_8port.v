`timescale 1 ns/10 ps
module dct_8port(
	input			clk,
	input			rst_b,

	input			de_in,

	input	[7:0]	data_in_01,
	input	[7:0]	data_in_02,
	input	[7:0]	data_in_03,
	input	[7:0]	data_in_04,
	input	[7:0]	data_in_05,
	input	[7:0]	data_in_06,
	input	[7:0]	data_in_07,
	input	[7:0]	data_in_08

);

parameter  Param_a = $signed({1'b0, 8'd251});
parameter  Param_b = $signed({1'b0, 8'd236});
parameter  Param_c = $signed({1'b0, 8'd212});
parameter  Param_d = $signed({1'b0, 8'd181});
parameter  Param_e = $signed({1'b0, 8'd142});
parameter  Param_f = $signed({1'b0, 8'd97});
parameter  Param_g = $signed({1'b0, 8'd49});


reg		[9:0]	de_in_d;
always @(posedge clk or negedge rst_b)begin
	if(!rst_b)begin
		de_in_d	<=	10'd0;
	end else begin
		de_in_d	<=	{de_in_d[8:0], de_in};
	end
end
//initial{{{
reg signed [8:0]	data_0_1;
reg signed [8:0]	data_0_2;
reg signed [8:0]	data_0_3;
reg signed [8:0]	data_0_4;
reg signed [8:0]	data_0_5;
reg signed [8:0]	data_0_6;
reg signed [8:0]	data_0_7;
reg signed [8:0]	data_0_8;
always @(posedge clk or negedge rst_b)begin
	if(!rst_b)begin
		data_0_1	<=	9'sd0;
		data_0_2	<=	9'sd0;
		data_0_3	<=	9'sd0;
		data_0_4	<=	9'sd0;
		data_0_5	<=	9'sd0;
		data_0_6	<=	9'sd0;
		data_0_7	<=	9'sd0;
		data_0_8	<=	9'sd0;
	end else if(de_in) begin
		data_0_1	<=	$signed({1'b0, data_in_01});
		data_0_2	<=	$signed({1'b0, data_in_02});
		data_0_3	<=	$signed({1'b0, data_in_03});
		data_0_4	<=	$signed({1'b0, data_in_04});
		data_0_5	<=	$signed({1'b0, data_in_05});
		data_0_6	<=	$signed({1'b0, data_in_06});
		data_0_7	<=	$signed({1'b0, data_in_07});
		data_0_8	<=	$signed({1'b0, data_in_08});
	end else begin
		data_0_1	<=	9'sd0;
		data_0_2	<=	9'sd0;
		data_0_3	<=	9'sd0;
		data_0_4	<=	9'sd0;
		data_0_5	<=	9'sd0;
		data_0_6	<=	9'sd0;
		data_0_7	<=	9'sd0;
		data_0_8	<=	9'sd0;
	end
end/*}}}*/
//cal 1{{{
reg signed [9:0]	data_1_1;
reg signed [9:0]	data_1_2;
reg signed [9:0]	data_1_3;
reg signed [9:0]	data_1_4;
reg signed [9:0]	data_1_5;
reg signed [9:0]	data_1_6;
reg signed [9:0]	data_1_7;
reg signed [9:0]	data_1_8;
always @(posedge clk or negedge rst_b)begin
	if(!rst_b)begin
		data_1_1	<=	10'sd0;
		data_1_2	<=	10'sd0;
		data_1_3	<=	10'sd0;
		data_1_4	<=	10'sd0;
		data_1_5	<=	10'sd0;
		data_1_6	<=	10'sd0;
		data_1_7	<=	10'sd0;
		data_1_8	<=	10'sd0;
	end else if(de_in_d[0]) begin
		data_1_1	<=	data_0_1 + data_0_8;
		data_1_2	<=	data_0_2 + data_0_7;
		data_1_3	<=	data_0_3 + data_0_6;
		data_1_4	<=	data_0_4 + data_0_5;
		data_1_5	<=	data_0_4 - data_0_5;
		data_1_6	<=	data_0_3 - data_0_6;
		data_1_7	<=	data_0_2 - data_0_7;
		data_1_8	<=	data_0_1 - data_0_8;
	end else begin
		data_1_1	<=	10'sd0;
		data_1_2	<=	10'sd0;
		data_1_3	<=	10'sd0;
		data_1_4	<=	10'sd0;
		data_1_5	<=	10'sd0;
		data_1_6	<=	10'sd0;
		data_1_7	<=	10'sd0;
		data_1_8	<=	10'sd0;
	end
end/*}}}*/
//cal 2{{{
wire	signed	[17:0]	data_1_6_d = data_1_6 * Param_d;//sign 1, int 9, dec 8
wire	signed	[17:0]	data_1_7_d = data_1_7 * Param_d;
reg signed [10:0]	data_2_1;
reg signed [10:0]	data_2_2;
reg signed [10:0]	data_2_3;
reg signed [10:0]	data_2_4;
reg signed [10:0]	data_2_5;
reg signed [18:0]	data_2_6;  //sign 1, int10, dec8
reg signed [18:0]	data_2_7;
reg signed [10:0]	data_2_8;
always @(posedge clk or negedge rst_b)begin
	if(!rst_b)begin
		data_2_1	<=	11'sd0;
        data_2_2	<=	11'sd0;
        data_2_3	<=	11'sd0;
        data_2_4	<=	11'sd0;
        data_2_5	<=	11'sd0;
        data_2_6	<=	19'sd0;
        data_2_7	<=	19'sd0;
        data_2_8	<=	11'sd0;
	end else if(de_in_d[1]) begin
		data_2_1	<=	data_1_1 + data_1_4;
        data_2_2	<=	data_1_2 + data_1_3;
        data_2_3	<=	data_1_2 - data_1_3;
        data_2_4	<=	data_1_1 - data_1_4;
        data_2_5	<=	data_1_5;
        data_2_6	<=	-data_1_6_d + data_1_7_d;
        data_2_7	<=	data_1_6_d + data_1_7_d;
        data_2_8	<=	data_1_8;
	end else begin
		data_2_1	<=	11'sd0;
        data_2_2	<=	11'sd0;
        data_2_3	<=	11'sd0;
        data_2_4	<=	11'sd0;
        data_2_5	<=	11'sd0;
        data_2_6	<=	19'sd0;
        data_2_7	<=	19'sd0;
        data_2_8	<=	11'sd0;
	end
end/*}}}*/
wire	signed	[18:0]	data_2_5_rev = {data_2_5, 8'd0};
//cal 3{{{
wire	signed	[18:0]	data_2_1_d =	data_2_1 * Param_d; //sign 1, int10, dec 8
wire	signed	[18:0]	data_2_2_d =	data_2_2 * Param_d;
wire	signed	[18:0]	data_2_3_f = 	data_2_3 * Param_f;
wire	signed	[18:0]	data_2_4_b = 	data_2_4 * Param_b;
wire	signed	[18:0]	data_2_3_b = 	data_2_3 * Param_b;
wire	signed	[18:0]	data_2_4_f = 	data_2_4 * Param_f;
reg signed [19:0]	data_3_1;//dec8
reg signed [19:0]	data_3_2;
reg signed [19:0]	data_3_3;
reg signed [19:0]	data_3_4;
reg signed [19:0]	data_3_5; // sign 1, int 11, dec 8
reg signed [19:0]	data_3_6;  
reg signed [19:0]	data_3_7;
reg signed [19:0]	data_3_8;
always @(posedge clk or negedge rst_b)begin
	if(!rst_b)begin
		data_3_1	<=	20'sd0;
        data_3_2	<=	20'sd0;
        data_3_3	<=	20'sd0;
        data_3_4	<=	20'sd0;
        data_3_5	<=	20'sd0;
        data_3_6	<=	20'sd0;
        data_3_7	<=	20'sd0;
        data_3_8	<=	20'sd0;
	end else if(de_in_d[2]) begin
		data_3_1	<=	 data_2_1_d + data_2_2_d;
        data_3_2	<=	 data_2_1_d - data_2_2_d;
        data_3_3	<=	 data_2_3_f + data_2_4_b;
        data_3_4	<=	-data_2_3_b + data_2_4_f;
        data_3_5	<=	 $signed({data_2_5, 8'd0}) + data_2_6;
        data_3_6	<=	 $signed({data_2_5, 8'd0}) - data_2_6;
        data_3_7	<=	- data_2_7 + $signed({data_2_8, 8'd0});
        data_3_8	<=	 data_2_7  + $signed({data_2_8, 8'd0});
	end else begin
		data_3_1	<=	20'sd0;
        data_3_2	<=	20'sd0;
        data_3_3	<=	20'sd0;
        data_3_4	<=	20'sd0;
        data_3_5	<=	20'sd0;
        data_3_6	<=	20'sd0;
        data_3_7	<=	20'sd0;
        data_3_8	<=	20'sd0;
	end
end//*}}}*/
//cal 4{{{
wire	signed 	[27:0]	data_3_5_g = data_3_5 * Param_g; // sign 1, int 11, dec 16
wire	signed 	[27:0]	data_3_8_a = data_3_8 * Param_a;
wire	signed 	[27:0]	data_3_6_e = data_3_6 * Param_e;
wire	signed 	[27:0]	data_3_7_c = data_3_7 * Param_c;
wire	signed 	[27:0]	data_3_6_c = data_3_6 * Param_c;
wire	signed 	[27:0]	data_3_7_e = data_3_7 * Param_e;
wire	signed 	[27:0]	data_3_5_a = data_3_5 * Param_a;
wire	signed 	[27:0]	data_3_8_g = data_3_8 * Param_g;
reg signed [19:0]	data_4_1;//sign 1, int 11, dec 8
reg signed [28:0]	data_4_2;//sign 1, int 12, dec 16
reg signed [19:0]	data_4_3;
reg signed [28:0]	data_4_4;
reg signed [19:0]	data_4_5;
reg signed [28:0]	data_4_6;  
reg signed [19:0]	data_4_7;
reg signed [28:0]	data_4_8;
always @(posedge clk or negedge rst_b)begin
	if(!rst_b)begin
		data_4_1	<=	20'sd0;
        data_4_2	<=	29'sd0;
        data_4_3	<=	20'sd0;
        data_4_4	<=	29'sd0;
        data_4_5	<=	20'sd0;
        data_4_6	<=	29'sd0;
        data_4_7	<=	20'sd0;
        data_4_8	<=	29'sd0;
	end else if(de_in_d[3]) begin
		data_4_1	<=	data_3_1 ;
        data_4_2	<=	data_3_5_g + data_3_8_a;
        data_4_3	<=	data_3_3 ;
        data_4_4	<=	-data_3_6_e + data_3_7_c;
        data_4_5	<=	data_3_2 ;
        data_4_6	<=	data_3_6_c + data_3_7_e;
        data_4_7	<=	data_3_4 ;
        data_4_8	<=	data_3_5_a + data_3_8_g;
	end else begin
		data_4_1	<=	20'sd0;
        data_4_2	<=	29'sd0;
        data_4_3	<=	20'sd0;
        data_4_4	<=	29'sd0;
        data_4_5	<=	20'sd0;
        data_4_6	<=	29'sd0;
        data_4_7	<=	20'sd0;
        data_4_8	<=	29'sd0;
	end
end//*}}}*//*}}}*/

reg signed [18:0]	data_5_1;//sign 1, int 11, dec 7
reg signed [27:0]	data_5_2;//sign 1, int 12, dec 15
reg signed [18:0]	data_5_3;
reg signed [27:0]	data_5_4;
reg signed [18:0]	data_5_5;
reg signed [27:0]	data_5_6;  
reg signed [18:0]	data_5_7;
reg signed [27:0]	data_5_8;

always @(posedge clk or negedge rst_b)begin
	if(!rst_b)begin
		data_5_1	<=	19'sd0;
        data_5_2	<=	28'sd0;
        data_5_3	<=	19'sd0;
        data_5_4	<=	28'sd0;
        data_5_5	<=	19'sd0;
        data_5_6	<=	28'sd0;
        data_5_7	<=	19'sd0;
        data_5_8	<=	28'sd0;
	end else if(de_in_d[4]) begin
		data_5_1	<=	data_4_1 >>1;
        data_5_2	<=	data_4_2 >>1;
        data_5_3	<=	data_4_3 >>1;
        data_5_4	<=	data_4_4 >>1;
        data_5_5	<=	data_4_5 >>1;
        data_5_6	<=	data_4_6 >>1;
        data_5_7	<=	data_4_7 >>1;
        data_5_8	<=	data_4_8 >>1;
	end else begin
		data_5_1	<=	19'sd0;
        data_5_2	<=	28'sd0;
        data_5_3	<=	19'sd0;
        data_5_4	<=	28'sd0;
        data_5_5	<=	19'sd0;
        data_5_6	<=	28'sd0;
        data_5_7	<=	19'sd0;
        data_5_8	<=	28'sd0;
	end
end


wire	signed [2:0]	test_tmp = 3'sd2;
wire	signed [5:0] test_sign = test_tmp;




endmodule
