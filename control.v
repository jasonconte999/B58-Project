module control(clk, resetn, go, touched, cur_state, bird_curr, wall_curr);
        input clk, resetn, collision;
	input reg go;
        output reg cur_state, bird_curr, wall_curr;
	reg next;
        
	localparam WALL = 3'b00, BIRD = 3'b01; // BACKGROUND = 3'b10,
	
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
			/*
			BACKGROUND: begin
				cur_state = ;
				next = WALL;
			*/
			WALL: begin
				cur_state = wall_curr;
				next = BIRD;
			end
			BIRD: begin 
				cur_state = bird_curr;
				next = WALL;
			end
                        default next = WALL;
                endcase
        end
        
        //state register
        always@(posedge clk)
        begin: state_FFS
                if (!resetn)
                        cur_state <= WALL;
                else
                        cur_state <= next;
        end
endmodule
