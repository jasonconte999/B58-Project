module control(clk, touched, flag, collision, go, cur_state_out, bird_curr, wall_curr);
	input clk;
	input touched;
	input flag;
	input collision;
	input go;
	output [4:0] cur_state_out;
	output [3:0] bird_curr, wall_curr;
	reg [3:0] next, cur_par_state = 4'b0000;
	reg gogo;
	wire [4:0] bird_state_out, wall_state_out;
	
	always@(posedge clk)
	begin
		if (go == 1'b0) gogo <= 1'b1;
	end
	///*
	control_bird bird_controller(
		.clk(cur_par_state == 4'b0000),
		.flag(flag),
		.press_key(gogo),
		.touched(collision),
		.current_out(bird_state_out));
	
	control_wall wall_controller(
		.go(gogo),
		.touched(collision),
		.clk(cur_par_state == 4'b0001),
		.current_out(wall_state_out));
		
		
	
	
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
				//cur_state <= bird_state_out;
			end
			4'b0001: begin 
				cur_par_state <= 4'b0000;
				//cur_state <= wall_state_out;
			end
			//default cur_state <= wall_state_out;
        endcase
        end
		  
	 /*
    //state register
    always@(posedge clk)
        begin: state_FFS
				if (!resetn)
                        cur_state <= wall_state_out;
        else
                        cur_state <= next;
        end*/
		  
	assign bird_curr = bird_state_out;
	assign wall_curr = wall_state_out;
	assign cur_state_out = cur_par_state == 4'b0000 ? bird_state_out : wall_state_out;
endmodule

/*
module control(clk, touched, flag, collision, go, finished_draw, cur_state_out, bird_curr, wall_curr);
	input clk;
	input touched;
	input flag;
	input collision;
	input go;
	input finished_draw;
	output [3:0] cur_state_out;
	output [3:0] bird_curr, wall_curr;
	reg [3:0] next, cur_par_state = 4'b0000;
	reg gogo;
	wire [3:0] bird_state_out, wall_state_out;
	
	always@(posedge clk)
	begin
		if (go == 1'b0) gogo <= 1'b1;
	end
	///*
	control_bird bird_controller(
		.clk(cur_par_state == 4'b0000),
		.flag(flag),
		.press_key(gogo),
		.touched(collision),
		.finished_draw(finished_draw),
		.current_out(bird_state_out),
		.progress(progress_b)
		);
	
	control_wall wall_controller(
		.go(gogo),
		.touched(collision),
		.clk(cur_par_state == 4'b0001),
		.finished_draw(finished_draw),
		.current_out(wall_state_out),
		.progress(progress_w)
		);

	reg toggle = 1'b0;
	always@(posedge clk)
	  begin
		//if(!progress)
		//	toggle = 1'b0;
		if(progress_b && cur_par_state == 4'b0000)
			begin
				cur_par_state <= 4'b0001;
				toggle = 1'b1;
			end
		else if(progress_w && cur_par_state == 4'b0001)
			begin
				cur_par_state <= 4'b0000;
				toggle = 1'b1;
			end
	  end
	  
		  
	assign bird_curr = bird_state_out;
	assign wall_curr = wall_state_out;
	assign cur_state_out = cur_par_state == 4'b0000 ? bird_state_out : wall_state_out;
endmodule
*/