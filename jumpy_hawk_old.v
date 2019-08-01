module jumpy_hawk(
		CLOCK_50,						//	On Board 50 MHz
        	SW,
		LEDR,
		KEY,
		HEX0,
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
	input [3:0] KEY;
	output [6:0] HEX0;
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
	
	wire [4:0] cur_state;
	//assign cur_state[0] = SW[0];
	//assign cur_state[1] = SW[1];
	//assign cur_state[2] = SW[2];
	//assign cur_state[3] = SW[3];
	
	wire pulse1, pulse2;
	assign reset = KEY[0];
	assign start = KEY[1];
	
	//28'b0000000000000000000000000001
	//28'b0001111111111111111111111111
	//28'b0000000000001111111111111111
	reg temp1 = 1'b0;
	always @(posedge CLOCK_50)
	begin
		if(SW[17])
			temp1 <= 1'b1;
	end
	
	RateDivider rd0(
		.d(28'b000000000000001000000000011),
		.r(28'b000000000000000000000001000),
		.clock(CLOCK_50),
		.Clear_b(reset),
		.ParLoad(start),
		.Enable(1'b1),
		.pulse(pulse1)
	);
	
	RateDivider rd1(
		.d(28'b000000000000000000000000011),
		.r(28'b000000000000000000000000010),
		.clock(CLOCK_50),
		.Clear_b(reset),
		.ParLoad(start),
		.Enable(1'b1),
		.pulse(pulse2)
	);
	
	
	control C(
		.clk(pulse1 == 1'b0 & temp1),
		.go(SW[1]),
		.touched(SW[4]),
		.flag(SW[2]),
		.collision(collision),
		.bird_curr(),
		.wall_curr(),
		.cur_state_out(cur_state)
	);
	//assign LEDR[10] = collision;
	
	wire finished_draw;
	//reg [3:0] state = 4'b1111;
	//reg toggle = 1'b0;
	//reg temp = 1'b0;
	//reg [3:0] counter = 4'b0000;
	/*
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
			state = 4'b0010;
			toggle = 1'b1;
		end
		else if(finished_draw && !toggle && state == 4'b0010)
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
			state = 4'b0101;
			toggle = 1'b1;
			counter = 4'b0000;
		end
		else if(finished_draw && !toggle && state == 4'b0101)
		begin
			state = 4'b1000;
			toggle = 1'b1;
		end
		else if(state == 4'b1000 && counter < 4'b0111)
			counter = counter + 4'b0001;
		else if(state == 4'b1000 && counter == 4'b0111)
		begin
			state = 4'b0000;
			counter = 4'b0000;
		end
		else if(finished_draw && !toggle && state == 4'b0000)
		begin
			state = 4'b0011;
			toggle = 1'b1;
		end
		else if (finished_draw && !toggle && state == 4'b0011 && counter < 4'b0111)
		begin
			counter = counter + 4'b0001;
		end
		else if (finished_draw && !toggle && state == 4'b0011 && counter == 4'b0111)
		begin
			state = 4'b0110;
			toggle = 1'b1;
			counter = 4'b0000;
		end
		else if(finished_draw && !toggle && state == 4'b0110)
		begin
			state = 4'b0111;
		end
		else if(state == 4'b0111 && counter < 4'b0111)
			counter = counter + 4'b0001;
		else if(state == 4'b0111 && counter == 4'b0111)
		begin
			state = 4'b0001;
			counter = 4'b0000;
		end
		end
	end*/
	//assign LEDR[3:0] = state;
	//assign cur_state = 4'b0000;
   //assign finished_draw = SW[8];
	
	/*
	reg [7:0] wall_top_hole_y;
	always @(*)
	begin
	wall_top_hole_y = {$random} % 100;
	end
	assign LEDR[7:0] = wall_top_hole_y;*/
	
	//assign cur_state = 4'b0100;

	datapath D0(
		.clk(pulse2),
		.cur_state(cur_state),
		.jump(!KEY[2]),
		.x_out(x),
		.y_out(y),
		.colour_out(colour),
		.score_out(score),
		.collision(collision),
		.finished_draw(LEDR[9])
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
	
	SevenSegDecoder decode0(
	.e(score),
	.m(HEX0)
    );
		/*
	reg temp1 = 1'b0;
	always @(*)
	begin
		if(SW[7])
			temp1 = 1'b1;
	end
	wall_height_generator rg(
		.clk(KEY[2]),
		.resetn(SW[7]),//cur_state == 4'b0000),
		.out(LEDR[7:0])
	);
	assign LEDR[9] = SW[7];*/
		
	//assign LEDR[7:0] = x;
	//assign LEDR[16:9] = 8'b11111111;
	//assign LEDR[7:0] = score;
	//assign LEDR[0] = collision;
	//assign LEDR[7:0] = x;
	
	//ToDo
	//collision sometimes works, sometimes doesnt
	//other 4bit states do not work. Must make 5 bit, however having issues
	//Map jump to key
	//Change input to coontrol after, using if B_RAISING and falling, jump
	//Yatzu wall generator not generating
	//Bird not moving. Expect its something to do with the numbers hardcoded in the module
	//Revert wall spawn left side
	//revert colour out from 8bits to 3bits

endmodule
