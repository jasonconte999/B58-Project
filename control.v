module control(clk, resetn, go, touched, current, bird_curr, wall_curr);
        input clk, resetn, go, collision;
        output reg current, bird_curr, wall_curr;
        
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
