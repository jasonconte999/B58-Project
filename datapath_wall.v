module datapath_wall(input clk, input [3:0] cur_state, output [7:0] x_out);
	
	localparam WALL_X_SPEED = 8'b00000100;//Speed of wall is 4
	localparam WALL_HEIGHT = 8'b01111000;//height of wall is 120
	localparam WALL_START = 8'b10100000;//wall starts at 160
	//localparam HOLE_HEIGHT = 8'b00110010; //Hole is 50 pixels high
	
	// registers
	reg [7:0] wall_x = WALL_START;
	
	localparam 	UPDATE_WALL = 3'd0;
	
   	// State mapping
   	always @(*)
   	begin
		case (cur_state)
			UPDATE_WALL:
				begin
					wall_x <= wall_x - WALL_X_SPEED;
					if(wall_x <= 0)//if wall_x is less than or equal to 0 reset its value
						wall_x <= WALL_START;
				end
		endcase
  	end
	
	assign x_out = wall_x;
	/*
	use this if wall_height_generator does not work
	reg [7:0] wall_top_hole_y;
	wall_top_hole_y = {$random} % 100;
	*/
	//need for hole
	wall_height_generator rg(
		.clk(clk),
		.resetn(1'b1),
		.out(wall_top_hole_y)
	);
	

endmodule	
