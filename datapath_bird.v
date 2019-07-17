module datapath_bird(
	input clk,
	input [1:0] cur_state,
	output y_out
    );
    
    // registers
    reg [7:0] bird_vy, bird_y, score;
	reg [7:0] draw_x, draw_y;

	localparam BIRD_Y_START = 8'b00111100; //Bird starts at y=60
	localparam BIRD_VY_START = 8'b00000000; //Bird's vertical speed starts at 0
	localparam BIRD_VY_SPEED = 8'b00000100; //Bird's vertical speed decreases by speed 4
	localparam BIRD_VY_JUMP = 8'b00001010; //When bird jumps, velocity becomes 10
	
	localparam BACKGROUND_COLOUR = 3'b111;
	localparam GRAVITY = 8'b0000001000;

	localparam UPDATE_BIRD_Y = 6'd0,
		UPDATE_BIRD_VY = 6'd1,
		DEL_BIRD = 6'd2;

    // State mapping
    always @(*)
    begin
        case (cur_state)
		UPDATE_BIRD_Y:
			begin
				bird_y <= bird_y + bird_vy;
			end
		UPDATE_BIRD_VY:
			begin
				bird_vy <= bird_vy - GRAVITY;
			end
        endcase
    end
    
endmodule
