module datapath_wall(input clk, input [1:0] cur_state, output [7:0] x_out);
   // registers
	reg [7:0] wall_x = 8'd160;//wall starts at 160
	
	localparam WALL_X_SPEED = 8'd4;//Speed of wall is 4
	localparam WALL_HEIGHT = 8'b01111000;//height of wall is 120
	
	localparam 	UPDATE_WALL = 3'd0;
	
   // State mapping
   always @(*)
   begin
		case (cur_state)
			UPDATE_WALL:
				begin
					wall_x <= wall_x - WALL_X_SPEED;
				end
		endcase
   end
   
	assign x_out = wall_x;

endmodule	

