module datapath_wall(input clk, input [3:0] cur_state, output [7:0] x_out, output [7:0] y_out);
	
	localparam WALL_X_SPEED = 8'b00001100;//Speed of wall is 4
	localparam WALL_HEIGHT = 8'b01111000;//height of wall is 120
	localparam WALL_START = 1'b0;//wall starts at 160
	localparam WALL_RESET = 8'b10100000;//wall starts at 160
	localparam HOLE_Y = 8'b00100000;
	//localparam HOLE_HEIGHT = 8'b00110010; //Hole is 50 pixels high
	
	wire [7:0] wall_top_hole_y;
	// registers
	reg [7:0] wall_x = WALL_START;
	reg [7:0] hole_y; //HOLE_Y;//wall_top_hole_y;
	
	
	localparam UPDATE_WALL = 4'b1000;
	
	wire pulse_x;
	
	RateDivider rd2(
		.d(8'b10000000),
		.clock(clk & cur_state == UPDATE_WALL),
		.Clear_b(1'b1),
		.ParLoad(1'b1),
		.Enable(1'b1),
		.pulse(pulse_x)
	);
	
	// State mapping
	always @(posedge pulse_x)
	begin
		if(WALL_X_SPEED < wall_x)
			wall_x <= wall_x - WALL_X_SPEED;
		else
		begin
			wall_x <= WALL_RESET;
			hole_y <= wall_top_hole_y;//HOLE_Y;//wall_top_hole_y;
		end
  	end
	
	assign x_out = wall_x;
	assign y_out = wall_top_hole_y;//hole_y;
	/*
	use this if wall_height_generator does not work
	reg [7:0] wall_top_hole_y;
	wall_top_hole_y = {$random} % 100;
	*/
	//need for hole
	wall_height_generator rg(
		.clk(clk),
		//.resetn(1'b1),//cur_state == 4'b0000),
		.out(wall_top_hole_y)
	);
	

endmodule	
