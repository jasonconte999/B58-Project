module draw_rect(
	input [7:0] start_x,
	input [7:0] start_y,
	input [7:0] width,
	input [7:0] height,
	input clk,
	input enable,
	output [7:0] x_out,
	output [7:0] y_out,
	output finished_draw
    );
    
	reg [7:0] draw_x, draw_y;
	reg finished_draw_reg;

	always @(posedge clk)
	begin
		if (draw_x < width)
			draw_x = draw_x + 1;
		else if (draw_y < height - 1) begin
			draw_x = 8'b0;
			draw_y = draw_y + 1;
			end
		else
			finished_draw_reg = 1'b1;
	end
	
	assign x_out = start_x + draw_x;
	assign y_out = start_y + draw_y;

	assign finished_draw = finished_draw_reg;
    
endmodule
