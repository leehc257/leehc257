
module float16_conv_5x5( //23clk delay
	input			clk,
	input			rst_b,

	input			de_in,
	input	[15:0]	data_in_11,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_12,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_13,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_14,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_15,// sign 1, exp 5, frac 10
	
	input	[15:0]	data_in_21,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_22,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_23,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_24,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_25,// sign 1, exp 5, frac 10

	input	[15:0]	data_in_31,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_32,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_33,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_34,// sign 1, exp 5, frac 10
	input	[15:0]	data_in_35,// sign 1, exp 5, frac 10

	input	[15:0]	coef_in_11,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_12,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_13,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_14,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_15,// sign 1, exp 5, frac 10
	
	input	[15:0]	coef_in_21,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_22,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_23,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_24,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_25,// sign 1, exp 5, frac 10

	input	[15:0]	coef_in_31,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_32,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_33,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_34,// sign 1, exp 5, frac 10
	input	[15:0]	coef_in_35,// sign 1, exp 5, frac 10

	output			de_out,
	output	[15:0]	data_out

);
wire			mul_de;
wire	[15:0]	mul_data_11, mul_data_21, mul_data_31;
wire	[15:0]	mul_data_12, mul_data_22, mul_data_32;
wire	[15:0]	mul_data_13, mul_data_23, mul_data_33;
wire	[15:0]	mul_data_14, mul_data_24, mul_data_34;
wire	[15:0]	mul_data_15, mul_data_25, mul_data_35;
float16_mul	float16_mul_11( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_11),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_11),

	.de_out		(mul_de),
	.data_out	(mul_data_11)
);
float16_mul	float16_mul_12( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_12),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_12),

	.de_out		(),
	.data_out	(mul_data_12)
);
float16_mul	float16_mul_13( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_13),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_13),

	.de_out		(),
	.data_out	(mul_data_13)
);
float16_mul	float16_mul_14( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_14),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_14),

	.de_out		(),
	.data_out	(mul_data_14)
);
float16_mul	float16_mul_15( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_15),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_15),

	.de_out		(),
	.data_out	(mul_data_15)
);


float16_mul	float16_mul_21( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_21),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_21),

	.de_out		(),
	.data_out	(mul_data_21)
);
float16_mul	float16_mul_22( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_22),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_22),

	.de_out		(),
	.data_out	(mul_data_22)
);
float16_mul	float16_mul_23( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_23),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_23),

	.de_out		(),
	.data_out	(mul_data_23)
);
float16_mul	float16_mul_24( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_24),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_24),

	.de_out		(),
	.data_out	(mul_data_24)
);
float16_mul	float16_mul_25( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_25),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_25),

	.de_out		(),
	.data_out	(mul_data_25)
);
float16_mul	float16_mul_31( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_31),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_31),

	.de_out		(),
	.data_out	(mul_data_31)
);
float16_mul	float16_mul_32( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_32),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_32),

	.de_out		(),
	.data_out	(mul_data_32)
);
float16_mul	float16_mul_33( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_33),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_33),

	.de_out		(),
	.data_out	(mul_data_33)
);
float16_mul	float16_mul_34( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_34),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_34),

	.de_out		(),
	.data_out	(mul_data_34)
);
float16_mul	float16_mul_35( //3clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(de_in),
	.data_in_01	(data_in_35),// sign 1, exp 5, frac 10
	.data_in_02	(coef_in_35),

	.de_out		(),
	.data_out	(mul_data_35)
);
reg		[15:0]	mul_data_35_d1, mul_data_35_d2, mul_data_35_d3, mul_data_35_d4, mul_data_35_d5;
always @(posedge clk or negedge rst_b) begin
	if(!rst_b)begin
		mul_data_35_d1	<=	16'd0;
		mul_data_35_d2	<=	16'd0;
		mul_data_35_d3	<=	16'd0;
		mul_data_35_d4	<=	16'd0;
		mul_data_35_d5	<=	16'd0;
	end else begin
		mul_data_35_d1	<=	mul_data_35;
		mul_data_35_d2	<=	mul_data_35_d1;
		mul_data_35_d3	<=	mul_data_35_d2;
		mul_data_35_d4	<=	mul_data_35_d3;
		mul_data_35_d5	<=	mul_data_35_d4;
	end
end
wire			add_de_1;
wire	[15:0]	add_data_1_12, add_data_1_34;
wire	[15:0]	add_data_2_12, add_data_2_34;
wire	[15:0]	add_data_3_12, add_data_3_34;
wire	[15:0]	add_data_12_55;
float16_add	float16_add_1_11_12( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(mul_de),
	.data_in_01	(mul_data_11),// sign 1, exp 5, frac 10
	.data_in_02	(mul_data_12),

	.de_out		(add_de_1),
	.data_out	(add_data_1_12)
);
float16_add	float16_add_2_11_12( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(mul_de),
	.data_in_01	(mul_data_21),// sign 1, exp 5, frac 10
	.data_in_02	(mul_data_22),

	.de_out		(),
	.data_out	(add_data_2_12)
);
float16_add	float16_add_3_11_12( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(mul_de),
	.data_in_01	(mul_data_31),// sign 1, exp 5, frac 10
	.data_in_02	(mul_data_32),

	.de_out		(),
	.data_out	(add_data_3_12)
);
float16_add	float16_add_1_13_14( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(mul_de),
	.data_in_01	(mul_data_13),// sign 1, exp 5, frac 10
	.data_in_02	(mul_data_14),

	.de_out		(),
	.data_out	(add_data_1_34)
);
float16_add	float16_add_2_23_24( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(mul_de),
	.data_in_01	(mul_data_23),// sign 1, exp 5, frac 10
	.data_in_02	(mul_data_24),

	.de_out		(),
	.data_out	(add_data_2_34)
);
float16_add	float16_add_3_33_34( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(mul_de),
	.data_in_01	(mul_data_33),// sign 1, exp 5, frac 10
	.data_in_02	(mul_data_34),

	.de_out		(),
	.data_out	(add_data_3_34)
);
float16_add	float16_add_12_55( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(mul_de),
	.data_in_01	(mul_data_15),// sign 1, exp 5, frac 10
	.data_in_02	(mul_data_25),

	.de_out		(),
	.data_out	(add_data_12_55)
);
wire			add_de_2;
wire	[15:0]	add_data_1_14;
wire	[15:0]	add_data_2_14;
wire	[15:0]	add_data_3_14;
wire	[15:0]	add_data_123_555;
float16_add	float16_add_1_14( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(add_de_1),
	.data_in_01	(add_data_1_12),// sign 1, exp 5, frac 10
	.data_in_02	(add_data_1_34),

	.de_out		(add_de_2),
	.data_out	(add_data_1_14)
);
float16_add	float16_add_2_14( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(add_de_2),
	.data_in_01	(add_data_2_12),// sign 1, exp 5, frac 10
	.data_in_02	(add_data_2_34),

	.de_out		(),
	.data_out	(add_data_2_14)
);
float16_add	float16_add_3_14( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(add_de_1),
	.data_in_01	(add_data_3_12),// sign 1, exp 5, frac 10
	.data_in_02	(add_data_3_34),

	.de_out		(),
	.data_out	(add_data_3_14)
);
float16_add	float16_add_123_555( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(add_de_1),
	.data_in_01	(add_data_12_55),// sign 1, exp 5, frac 10
	.data_in_02	(mul_data_35_d5	),

	.de_out		(),
	.data_out	(add_data_123_555)
);
wire			add_de_3;
wire	[15:0]	add_data_12_14;
wire	[15:0]	add_data_3_else;

float16_add	float16_add_12_14( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(add_de_2),
	.data_in_01	(add_data_1_14),// sign 1, exp 5, frac 10
	.data_in_02	(add_data_2_14),

	.de_out		(add_de_3),
	.data_out	(add_data_12_14)
);
float16_add	float16_add_3_else( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(add_de_2),
	.data_in_01	(add_data_3_14  ),// sign 1, exp 5, frac 10
	.data_in_02	(add_data_123_555),

	.de_out		(),
	.data_out	(add_data_3_else)
);

wire			add_de_4;
wire	[15:0]	add_data_all;
float16_add	float16_add_123_15( //5clk delay
	.clk		(clk  ),
	.rst_b		(rst_b),

	.de_in		(add_de_3),
	.data_in_01	(add_data_12_14),// sign 1, exp 5, frac 10
	.data_in_02	(add_data_3_else),

	.de_out		(add_de_4),
	.data_out	(add_data_12_14)
);

assign	  	de_out		= add_de_4;
assign		data_out	= add_data_12_14;


endmodule
