module datapath(
		input clk,
		input [3:0] cur_state,
		output [7:0] x_out,
		output [7:0] y_out,
		output [7:0] colour_out,
		output [7:0] score_out,
		output collision,
		output finished_draw
	);
	
	localparam DRAW_BIRD = 3'b000;
	localparam DRAW_WALL_TOP = 3'b001;
	localparam DRAW_WALL_BOT = 3'b010;
	localparam BIRD_W = 8'b00000011;
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

	wire [7:0] bird_top_y, bird_bot_y, wall_left_x, wall_right_x, wall_top_hole_y, wall_bot_hole_y, wall_top_h, wall_bot_h;
	wire [7:0] draw_x, draw_y, draw_w, draw_h, draw_x_out, draw_y_out;
	wire draw_enable;
	reg [7:0] score;

	assign bird_bot_y = bird_top_y + BIRD_W;
	assign wall_right_x = wall_left_x + WALL_W;
	assign wall_bot_hole_y = wall_top_hole_y + HOLE_HEIGHT;
	assign wall_top_h = wall_top_hole_y - WALL_TOP_Y;
	assign wall_bot_h = WALL_BOT_Y - wall_bot_hole_y;
	assign draw_x = cur_state == DRAW_WALL_TOP || cur_state == DRAW_WALL_BOT ? wall_left_x : 
						 cur_state == DRAW_BIRD ? BIRD_LEFT_X : 
						 8'b00000000; //DEFAULT
	assign draw_y = cur_state == DRAW_WALL_BOT ? wall_bot_hole_y : 
						 cur_state == DRAW_WALL_TOP ? WALL_TOP_Y : 
						 cur_state == DRAW_BIRD ? bird_top_y : 
						 8'b00000000; //DEFAULT
	assign draw_w = cur_state == DRAW_WALL_TOP || cur_state == DRAW_WALL_BOT ? WALL_W : 
						 cur_state == DRAW_BIRD ? BIRD_W : 
						 8'b00000000; //DEFAULT
	assign draw_h = cur_state == DRAW_WALL_BOT ? wall_bot_h : 
						 cur_state == DRAW_WALL_TOP ? wall_top_h : 
						 cur_state == DRAW_BIRD ? BIRD_W : 
						 8'b00000000; //DEFAULT
	assign draw_enable = cur_state == DRAW_WALL_TOP || cur_state == DRAW_WALL_BOT || cur_state == DRAW_BIRD ? 1'b1 : 
						 1'b0; //DEFAULT
	assign x_out = draw_enable ? draw_x_out : 8'b00000000;
	assign y_out = draw_enable ? draw_y_out : 8'b00000000;
	
	assign score_out = score;
	
	assign colour_out = wall_top_hole_y;
    
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
		.resetn(1'b1),
		.out(wall_top_hole_y)
	);

	check_touched ct(
		.bird_xleft(BIRD_LEFT_X), //00001000
		.bird_xright(BIRD_RIGHT_X), //00001100
		.bird_ytop(bird_top_y), //00000100
		.bird_ybottom(bird_bot_y), //00000111
		.wall_xleft(wall_left_x), //00010000
		.wall_xright(wall_right_x), //00011010
		.wall_topy(wall_top_hole_y), //00010000
		.wall_bottomy(wall_bot_hole_y), //01000010
		.touched(collision)
	);

	draw_rect dr(
		.start_x(draw_x),
		.start_y(draw_y),
		.width(draw_w),
		.height(draw_h),
		.clk(clk),
		.enable(draw_enable),
		.x_out(draw_x_out),
		.y_out(draw_y_out),
		.finished_draw(finished_draw)
    	);
    
endmodule
