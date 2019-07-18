module datapath(
		input clk,
		input [3:0] cur_state,
		output x_out
		output y_out;
		output collision;
		output finished_draw;
		output colour_out;
		output score_out;
	);
	//States
	localparam DRAW_BIRD = 3'b000;
	localparam DRAW_WALL_TOP = 3'b001;
	localparam DRAW_WALL_BOT = 3'b010;

	localparam BIRD_W = 8'b00000100;
	localparam BIRD_LEFT_X = 8'b00001000;
	localparam BIRD_RIGHT_X = 8'b00001100; //left x + bird width
	localparam BIRD_COLOUR = 3'b010;
	localparam WALL_HEIGHT = 8'b01111000;
	localparam WALL_TOP_Y = 8'b00000000;
	localparam WALL_BOT_Y = 8'b01111000; //Top y + wall height
	localparam HOLE_HEIGHT = 8'b00110010; //Hole is 50 pixels high
	localparam WALL_W = 8'b00001010; //Wall is 10 pixels thick
	localparam WALL_COLOUR = 3'b100;
	localparam BACKGROUND_COLOUR = 3'b111;

	wire [7:0] bird_top_y, bird_bot_y, wall_left_x, wall_right_x, wall_top_hole_y, wall_bot_hole_y, wall_top_h, wall_bot_h, draw_x, draw_y, draw_w, draw_h;
	wire collision, draw_enable;

	assign bird_bot_y = bird_top_y + BIRD_W;
	assign wall_right_x = wall_left_x + WALL_W;
	assign wall_bot_hole_y = wall_top_hole_y + HOLE_HEIGHT;
	assign wall_top_h = wall_top_hole_y - WALL_TOP_Y;
	assign wall_bot_h = WALL_BOT_Y - wall_bot_hole_y;

	// State mapping
	always @(posedge clk)
	begin
		case (cur_state)
			DRAW_BIRD:
				begin
					draw_x = BIRD_LEFT_X;
					draw_y = bird_top_y;
					draw_w = BIRD_W;
					draw_h = BIRD_W;
					draw_enable = 1'b1;
				end
			DRAW_WALL_TOP:
				begin
					draw_x = wall_left_x;
					draw_y = WALL_TOP_Y;
					draw_w = WALL_W;
					draw_h = wall_top_h;
					draw_enable = 1'b1;
				end
			DRAW_WALL_BOT:
				begin
					draw_x = wall_left_x;
					draw_y = wall_bot_hole_y;
					draw_w = WALL_W;
					draw_h = wall_bot_h;
					draw_enable = 1'b1;
				end
		endcase
	end
    
	datapath_bird db (
		.clk(clk),
		.cur_state(cur_state),
		.y_out(bird_top_y)
	);

	datapath_wall dw (
		.clk(clk), 
		.cur_state(cur_state),
		.x_out(wall_left_x)
	);

	wall_height_generator rg(
		.clk(clk),
		.reset(),
		.out(wall_top_hole_y)
	);

	check_touched ct(
		.bird_xleft(BIRD_LEFT_X),
		.bird_xright(BIRD_RIGHT_X),
		.bird_ytop(bird_top_y),
		.bird_ybottom(bird_bot_y),
		.wall_xleft(wall_left_x),
		.wall_xright(wall_right_x),
		.wall_topy(wall_top_hole_y),
		.wall_bottomy(wall_bot_hole_y),
		.touched(collision)
	);

	draw_rect dr(
		.start_x(draw_x),
		.start_y(draw_y),
		.width(draw_w),
		.height(draw_h),
		.clk(clk),
		.enable(draw_enable),
		.x_out(x_out),
		.y_out(y_out),
		.finished_draw(finished_draw)
    	);
    
endmodule
