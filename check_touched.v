module check_touched(
	input [7:0] bird_xleft, bird_xright, bird_ytop, bird_ybottom, wall_xleft, wall_xright, wall_topy, wall_bottomy,
	output touched
);
	wire in_the_hole, touched_top_bottom;
	// check x coordinate: left and right positions of bird and wall
	assign in_the_hole = (bird_xright >= wall_xleft) && (bird_xleft <= wall_xright);
	// check y coordinate: top and bottom positions of bird and wall
	assign touched_top_bottom  = (bird_ytop <= wall_topy) || (bird_ybottom >= wall_bottomy);
	touched = in_the_hole && touched_top_bottom;
endmodule
