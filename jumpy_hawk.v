module jumpy_hawk(
		CLOCK_50,						//	On Board 50 MHz
        	SW,
		LEDR,
		KEY,
		VGA_CLK,   						//	VGA Clock
		VGA_HS,							//	VGA H_SYNC
		VGA_VS,							//	VGA V_SYNC
		VGA_BLANK_N,						//	VGA BLANK
		VGA_SYNC_N,						//	VGA SYNC
		VGA_R,   						//	VGA Red[9:0]
		VGA_G,	 						//	VGA Green[9:0]
		VGA_B   						//	VGA Blue[9:0]
);
	input [17:0] SW;
	input CLOCK_50;
	input [2:0] KEY;
	output [17:0] LEDR;

	output VGA_CLK;   				//	VGA Clock
	output VGA_HS;					//	VGA H_SYNC
	output VGA_VS;					//	VGA V_SYNC
	output VGA_BLANK_N;				//	VGA BLANK
	output VGA_SYNC_N;				//	VGA SYNC
	output	[9:0]	VGA_R;   				//	VGA Red[9:0]
	output	[9:0]	VGA_G;	 				//	VGA Green[9:0]
	output	[9:0]	VGA_B;   				//	VGA Blue[9:0]
	
	wire [7:0] x, y, score, vga_x, vga_y;
	wire [7:0] colour;
	wire collision;
	
	wire [3:0] cur_state;
	assign cur_state[0] = SW[0];
	assign cur_state[1] = SW[1];
	assign cur_state[2] = SW[2];
	assign cur_state[3] = SW[3];
	
	wire pulse;
	assign reset = KEY[0];
	assign start = KEY[1];
	
	//28'b0000000000000000000000000001
	//28'b0001111111111111111111111111
	//28'b0000000000001111111111111111
	
	
	/*
	control C(
		.clk(SW[17]),
		.resetn(1'b1),
		.go(SW[1]),
		.touched(SW[4]),
		.flag(SW[2]),
		.collision(SW[3]),
		.bird_curr(LEDR[3:0]),
		.wall_curr(LEDR[7:4]),
		.cur_state_out(LEDR[17:14])
	);*/
	
	wire finished_draw;
	/*
	reg [3:0] state = 4'b1111;
	reg toggle = 1'b0;
	reg temp = 1'b0;
	reg [3:0] counter = 4'b0000;
	always @(posedge pulse)
	begin
		if(SW[17] == 1'b1 && !temp) begin
			state = 4'b0001;
			temp = 1'b1;
		end
		if(temp) begin
		if(!finished_draw)
			toggle = 1'b0;
		if(finished_draw && !toggle && state == 4'b0001)
		begin
			state = 4'b0100;
			toggle = 1'b1;
		end
		else if (finished_draw && !toggle && state == 4'b0100 && counter < 4'b0111)
		begin
			counter = counter + 4'b0001;
		end
		else if (finished_draw && !toggle && state == 4'b0100 && counter == 4'b0111)
		begin
			state = 4'b1000;
			toggle = 1'b1;
			counter = 4'b0000;
		end
		else if(state == 4'b1000 && counter < 4'b0111)
			counter = counter + 4'b0001;
		else if(state == 4'b1000 && counter == 4'b0111)
			state = 4'b0001;
		end
	end
	assign LEDR[3:0] = state;
	assign cur_state = state;*/
   //assign finished_draw = SW[8];
	

	datapath D0(
		.clk(clk),
		.cur_state(cur_state),
		.x_out(x),
		.y_out(y),
		.colour_out(colour),
		.score_out(score),
		.collision(collision),
		.finished_draw(finished_draw)
	);
	
	assign vga_x = x;
	assign vga_y = y;
	//assign vga_x = SW[3] ? x : 8'b00000000;
	//assign vga_y = SW[3] ? y : 8'b00000000;

	vga_adapter VGA(
			.resetn(1'b1),
			.clock(CLOCK_50),
			.colour(colour),
			.x(vga_x),
			.y(vga_y),
			.plot(!finished_draw),
			
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
		
	
	//assign LEDR[7:0] = x;
	//assign LEDR[16:9] = 8'b11111111;
	assign LEDR[7:0] = score;
	//assign LEDR[0] = collision;
	//assign LEDR[7:0] = x;
	
	//ToDo
	//Yatzu wall generator not generating
	//Bird not moving. Expect its something to do with the numbers hardcoded in the module
	//Revert wall spawn left side
	//revert colour out from 8bits to 3bits

endmodule
