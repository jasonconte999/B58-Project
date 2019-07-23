module control(clk, resetn, go, touched, cur_state, bird_curr, wall_curr);
        input clk, resetn, go, collision;
        output reg cur_state, bird_curr, wall_curr;
	reg next;
        
	localparam DRAW_WALL = 2'b00, DRAW_BIRD = 2'b01;
	
        control_bird bird_controller(
                .clk(clk),
                .resetn(resetn),
                .press_key(go),
                .touched(collision),
                .current(bird_curr)
	      );
	
	control_wall wall_controller(
		.go(go),
		.touched(collision),
		.clk(clk),
		.resetn(resetn),
		.current(wall_curr)
	      );
  
	always@(*)
        begin: state_table
                case(cur_state)
			DRAW_WALL: begin
				cur_state = wall_curr;
				next = DRAW_BIRD;
			end
			DRAW_BIRD: begin 
				cur_state = bird_curr;
				next = DRAW_WALL;
			end
                        default next = DRAW_WALL;
                endcase
        end
        
        //state register
        always@(posedge clk)
        begin: state_FFS
                if (!resetn)
                        cur_state <= DRAW_WALL;
                else
                        cur_state <= next;
        end
endmodule
