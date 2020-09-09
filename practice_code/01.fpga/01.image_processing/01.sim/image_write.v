
module image_write(
	input			clk,
	input			rst_b,

	input			vs_in,
	input			hs_in,
	input			de_in,

	input	[7:0]	r_in,
	input	[7:0]	g_in,
	input	[7:0]	b_in

);
integer fdata;
initial begin
	fdata = $fopen("../05.result_data/result_image.ppm");
end
always @(posedge clk)
	if(de_in)
		$fdisplay(fdata, "%d %d %d\n", r_in, g_in, b_in);


initial begin
	$fdisplay(fdata, "P3");
	$fdisplay(fdata, "1920 1080");
	$fdisplay(fdata, "256");
end


endmodule
