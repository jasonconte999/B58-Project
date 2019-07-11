module check_touched(
	input bird_xleft;
	input bird_xright;
	input bird_ytop;
	input bird_ybottom;
	input wall_xleft;
	input wall_xrigth;
	input wall_topy;
	input wall_bottomy;
	output touched;
);
	assign touched = bird_xright >= wall_xleft | bird_xleft <= wall_xright;
endmodule
			
