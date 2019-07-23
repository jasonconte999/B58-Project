module jumpy_hawk(
		CLOCK_50,						//	On Board 50 MHz
        	KEY,
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B,   						//	VGA Blue[9:0]
		HEX0,
		HEX1
);
	input [3:0] KEY;
	input CLOCK_50;
	output [6:0] HEX0, HEX1;

	output VGA_CLK;   				//	VGA Clock
	output VGA_HS;					//	VGA H_SYNC
	output VGA_VS;					//	VGA V_SYNC
	output VGA_BLANK_N;				//	VGA BLANK
	output VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]

	
	// Create the colour, x, y and writeEn wires that are inputs to the controller.
	wire [2:0] colour;
	wire [7:0] x;
	wire [6:0] y;
	wire [7:0] score;
	wire writeEn;
	wire go;
	wire clk;
	wire [1:0] alu_select;
	wire finished_draw, collision;
	reg bird_curr;
	reg wall_curr;
	reg cur_state;//

	assign go = KEY[0];
	assign clk = CLOCK_50;
	
	
	control C0(
		.clk(clk),
		.resetn(resetn),
		.go(go), 
		.touched(collision),
		.cur_state(cur_state),
		.bird_curr(bird_curr),
		.wall_curr(wall_curr)
	);

	datapath D0(
		.clk(clk),
		.x_out(x),
		.y_out(y),
		.colour_out(colour), //[7:0]
		.score_out(score), //[7:0]
		.collision(collision),
		.finished_draw(finished_draw),
		.cur_state(cur_state) //[3:0]
	);
	
	/*
	control_bird bird_controller(
		.clk(clk),
		.resetn(resetn),
		.press_key(go),
		.touched(collision),
		.current(bird_curr)
	);
	
	control_wall wall_controller(
		.go(go),
		.touched(collision),
		.clk(clk),
		.resetn(resetn),
		.current(wall_curr)
	);
	
	control C0(
		.clk(clk),
		.finished_draw(finished_draw),
		.collision(collision),
		.alu_select(alu_select)
	);
	

	datapath D0(
		.clk(clk),
		.alu_select(alu_select),
		.x_out(x),
		.y_out(y),
		.bird_curr(bird_curr),
		.wall_curr(wall_curr),
		.colour_out(colour),
		.score_out(score),
		.finished_draw(finished_draw),
		.collision(collision)
	);
	*/


	vga_adapter VGA(
			.resetn(resetn),
			.clock(clk),
			.colour(colour),
			.x(x),
			.y(y),
			.plot(writeEn),
			/* Signals for the DAC to drive the monitor. */
			.VGA_R(VGA_R),
			.VGA_G(VGA_G),
			.VGA_B(VGA_B),
			.VGA_HS(VGA_HS),
			.VGA_VS(VGA_VS),
			.VGA_BLANK(VGA_BLANK_N),
			.VGA_SYNC(VGA_SYNC_N),
			.VGA_CLK(VGA_CLK));
		defparam VGA.RESOLUTION = "160x120";
		defparam VGA.MONOCHROME = "FALSE";
		defparam VGA.BITS_PER_COLOUR_CHANNEL = 1;
		defparam VGA.BACKGROUND_IMAGE = "black.mif";

	hex_decoder H0(
		.hex_digit(score[3:0]), 
		.segments(HEX0)
	);
	hex_decoder H1(
		.hex_digit(score[7:4]), 
		.segments(HEX1)
	);

endmodule
