module datapath_wall(input clk, input [1:0] cur_state, output x_out, output y_out, output colour_out);
    
   // registers
	reg [7:0] wall_x;
	reg [7:0] draw_x, draw_y;

	localparam WALL_X_START = 8'b01100100; //Wall starts at x=100
	localparam WALL_X_SPEED = 8'b00000100; //Wall moves at speed 4
	localparam WALL_Y = 8'b00000000;
	localparam WALL_WIDTH = 8'b00001010; //Wall is 10 pixels thick
	localparam WALL_COLOUR = 3'b100;
	localparam WALL_HEIGHT = 8'b01111000;
	localparam HOLE_HEIGHT = 8'b00110010; //Hole is 50 pixels high
	localparam BACKGROUND_COLOUR = 3'b111;
	
	localparam 	UPDATE_WALL = 3'd0,
			DEL_WALL = 3'd1,
			DRAW_WALL = 3'd2;
			//UPDATE_SCORE = 3'd3; 

    // State mapping
    always @(*)
    begin
        case (cur_state)
				DEL_WALL:
						begin
							//draw black rectangle at current position of wall
							draw_rect(
								.start_x(wall_x),
								.start_y(WALL_Y),
								.width(WALL_WIDTH),
								.height(WALL_HEIGHT),
								.clk(clk),
								.x_out(x_out),
								.y_out(y_out),
								.finished_draw()//not sure about this
							);
						end
				UPDATE_WALL:
						begin
							wall_x <= wall_x - WALL_X_SPEED;
						end
				DRAW_WALL:
						begin
							//draw wall at new updated position
							draw_rect(
								.start_x(wall_x),
								.start_y(WALL_Y),
								.width(WALL_WIDTH),
								.height(WALL_HEIGHT),
								.clk(clk),
								.x_out(x_out),
								.y_out(y_out),
								.finished_draw()//not sure about this
							);
						end
		  endcase
    end
    
endmodule
