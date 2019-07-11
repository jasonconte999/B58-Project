module datapath(
	input clk,
	input [1:0] alu_select,
	output x_out;
	output y_out;
	output colour_out;
	output score_out;
    );
    
    // registers
    reg [7:0] wall_x, bird_vy, bird_y, score;
	reg [7:0] draw_x, draw_y;

    localparam BIRD_Y_START = 8'b00111100; //Bird starts at y=60
    localparam BIRD_VY_START = 8'b00000000; //Bird's vertical speed starts at 0
    localparam BIRD_VY_SPEED = 8'b00000100; //Bird's vertical speed decreases by speed 4
    localparam BIRD_VY_JUMP = 8'b00001010; //When bird jumps, velocity becomes 10
    localparam BIRD_COLOUR = 3'b010;
    localparam WALL_X_START = 8'b01100100; //Wall starts at x=100
    localparam WALL_X_SPEED = 8'b00000100; //Wall moves at speed 4
    localparam WALL_WIDTH = 8'b0000001010; //Wall is 10 pixels thick
    localparam WALL_COLOUR = 3'b100;
    localparam BACKGROUND_COLOUR = 3'b111;
	
	localparam UPDATE_WALL = 6'd0,
		UPDATE_BIRD_Y = 6'd1,
		UPDATE_BIRD_VY = 6'd2,
		DEL_WALL = 6'd3,
		DEL_BIRD = 6'd4,
		DRAW_WALL = 6'd5,
		DRAW_BIRD = 6'd6;

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
    
endmodule
