module check_touched(
	input bird_xleft,
	input bird_xright,
	input bird_ytop,
	input bird_ybottom,
	input wall_xleft,
	input wall_xright,
	input wall_topy,
	input wall_bottomy,
	output touched
);
	wire in_the_hole;
	wire touched_top_bottom;
	assign in_the_hole = bird_xright >= wall_xleft && bird_xleft <= wall_xright;
	assign touched_top_bottom  = bird_ytop <= wall_topy || bird_ybottom >= wall_bottomy;
	touched = in_the_hole && touched_top_bottom;
endmodule
