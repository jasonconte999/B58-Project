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
                case(finished_draw)
			DRAW_WALL: next = DRAW_BIRD;
			cur_state = wall_curr;
			DRAW_BIRD: next = ;
			cur_state = bird_curr;
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
