module control(SW, LEDR, KEY);
	input clk, resetn, touched, flag, collision, go;
	output reg [3:0] cur_state;
	output [3:0] bird_curr, wall_curr;
	reg [3:0] next, cur_par_state;
	reg gogo;
	wire [3:0] bird_state_out, wall_state_out;
	
	always@(posedge clk)
	begin
		if (go == 1'b0) gogo <= 1'b1;
	end
	///*
	control_bird bird_controller(
		.clk(clk),
		.flag(flag),
		.resetn(resetn),
		.press_key(gogo),
		.touched(collision),
		.current(bird_state_out));
	
	control_wall wall_controller(
		.go(gogo),
		.touched(collision),
		.clk(clk),
		.resetn(resetn),
		.current(wall_state_out));
		
	
	//wire [3:0] bird_state_out, wall_state_out;
	//assign bird_state_out = 4'b1001;
	//assign wall_state_out = 4'b1011;
	
	always@(posedge clk)
        begin: state_table
        case(cur_par_state)
			/*
			BACKGROUND: begin
				next = wall_curr;
			end
			*/
			4'b0000: begin
				cur_par_state <= 4'b0001;
				next <= bird_state_out;
			end
			4'b0001: begin 
				cur_par_state <= 4'b0000;
				next <= wall_state_out;
			end
			default next <= wall_state_out;
        endcase
        end
    //state register
    always@(posedge clk)
        begin: state_FFS
                        cur_state <= next;
        end
		  
	assign bird_curr = bird_state_out;
	assign wall_curr = wall_state_out;
	
        if (!resetn)
                        cur_state <= wall_state_out;
                else
                        cur_state <= next;
        end
		  
	assign bird_curr = bird_state_out;
	assign wall_curr = wall_state_out;
endmodule

