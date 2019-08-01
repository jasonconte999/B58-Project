module datapath_wall(input clk, input [4:0] cur_state, output [7:0] x_out, input collision, output [7:0] y_out, output [7:0] score_out);
	
	localparam WALL_X_SPEED = 8'b00000001;//Speed of wall is 4
	localparam WALL_HEIGHT = 8'b01111000;//height of wall is 120
	localparam WALL_START = 1'b0;//wall starts at 160
	localparam WALL_RESET = 8'b10100000;//wall starts at 160
	localparam HOLE_Y = 8'b00100000;
	//localparam HOLE_HEIGHT = 8'b00110010; //Hole is 50 pixels high
	
	wire [7:0] wall_top_hole_y;
	// registers
	reg [7:0] wall_x = WALL_RESET;
	reg [7:0] hole_y = HOLE_Y; //HOLE_Y;//wall_top_hole_y;
	reg [7:0] score = 1'b0;
	
	
	localparam UPDATE_WALL = 5'b01010;
	
	wire pulse_x;
	
	RateDivider rd2(
		.d(20'b00100000000000000000),
		.r(28'b000000000000000000000000010),
		.clock(clk & cur_state == UPDATE_WALL),
		.Clear_b(1'b1),
		.ParLoad(1'b1),
		.Enable(1'b1),
		.pulse(pulse_x)
	);
	reg [20:0] counter = 1'b0;
	
	// State mapping
	always @(posedge pulse_x)
	begin
		if(collision && counter == 1'b0)
			counter <= 1'b1;
		else if (counter > 1'b0 && counter < 10'b0001000000)
			counter <= counter + 1'b1;
		else if (counter >= 10'b0001000000)
		begin
			wall_x <= WALL_RESET;
			score <= 1'b0;
			counter = 1'b0;
		end
		else if(WALL_X_SPEED < wall_x)
			wall_x <= wall_x - WALL_X_SPEED;
		else
		begin
			wall_x <= WALL_RESET;
			hole_y <= 8'b00111100;//wall_top_hole_y[4:0];//HOLE_Y;//HOLE_Y;//wall_top_hole_y;
			score <= score + 1'b1;
		end
  	end
	
	assign x_out = wall_x;
	assign y_out = hole_y;//hole_y;
	assign score_out = score;
	
	wall_height_generator whg(
		.clk(pulse_x),
		.out(wall_top_hole_y)
	);
	/*
	use this if wall_height_generator does not work
	reg [7:0] wall_top_hole_y;
	wall_top_hole_y = {$random} % 100;
	*/
	//need for hole
	/*wall_height_generator rg(
		.clk(clk),
		.resetn(1'b1),//cur_state == 4'b0000),
		.out(wall_top_hole_y)
	);*/
	

endmodule	