
module image_write_8port(
	input			clk,
	input			rst_b,

	input			vs_in,
	input			hs_in,
	input			de_in,

	output	[7:0]	r_in_01,
	output	[7:0]	g_in_01,
	output	[7:0]	b_in_01,

	output	[7:0]	r_in_02,
	output	[7:0]	g_in_02,
	output	[7:0]	b_in_02,

	output	[7:0]	r_in_03,
	output	[7:0]	g_in_03,
	output	[7:0]	b_in_03,

	output	[7:0]	r_in_04,
	output	[7:0]	g_in_04,
	output	[7:0]	b_in_04,

	output	[7:0]	r_in_05,
	output	[7:0]	g_in_05,
	output	[7:0]	b_in_05,

	output	[7:0]	r_in_06,
	output	[7:0]	g_in_06,
	output	[7:0]	b_in_06,

	output	[7:0]	r_in_07,
	output	[7:0]	g_in_07,
	output	[7:0]	b_in_07,

	output	[7:0]	r_in_08,
	output	[7:0]	g_in_08,
	output	[7:0]	b_in_08

);
integer fdata;
initial begin
	fdata = $fopen("../05.result_data/result_image.ppm");
end
always @(posedge clk)
	if(de_in)
		$fdisplay(fdata, "%d %d %d\n%d %d %d\n%d %d %d\n%d %d %d\n%d %d %d\n%d %d %d\n%d %d %d\n%d %d %d\n",
						 r_in_01, g_in_01, b_in_01, 
						 r_in_02, g_in_02, b_in_02, 
						 r_in_03, g_in_03, b_in_03, 
						 r_in_04, g_in_04, b_in_04, 
						 r_in_05, g_in_05, b_in_05, 
						 r_in_06, g_in_06, b_in_06, 
						 r_in_07, g_in_07, b_in_07, 
						 r_in_08, g_in_08, b_in_08 );


initial begin
	$fdisplay(fdata, "P3");
	$fdisplay(fdata, "1920 1080");
	$fdisplay(fdata, "256");
end


endmodule
