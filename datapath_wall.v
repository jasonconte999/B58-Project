module datapath_wall(input clk, input [1:0] cur_state, output [7:0] x_out, output [7:0] y_out);
   // registers
	reg [7:0] wall_x, hole_y;
	
	wire [7:0] out;
	
	localparam WALL_X_SPEED = 8'b00000100;//Speed of wall is 4
	localparam WALL_HEIGHT = 8'b01111000;//height of wall is 120
	localparam HOLE_Y_SPEED = 8'b00000100;//hole moves at speed 4
	
	localparam 	UPDATE_WALL = 3'd0;

	wall_height_generator rg(
		.clk(clk),
		.reset(),
		.out(out)
	);
	
   // State mapping
   always @(*)
   begin
		case (cur_state)
			UPDATE_WALL:
				begin
					wall_x <= wall_x - WALL_X_SPEED;
					hole_y <= out;
				end
		endcase
   end
   
	assign x_out = wall_x;
	assign y_out = hole_y;

endmodule	
