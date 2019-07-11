module datapath(
	input clk,
	input [1:0] alu_select,
	output x_out;
	output y_out;
	output colour_out;
	output score_out;
    );
    
    datapath_bird db (
	);

	datapath_wall dw (
	);
    
endmodule
