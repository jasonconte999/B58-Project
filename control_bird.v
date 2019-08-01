module control_bird(clk, flag, press_key, touched, current_out);
        input clk;
        input press_key;
        input touched;
        input flag; // whether bird is too high
        output [4:0] current_out;
        //current state and next state
        reg [3:0] next, afterDraw, current;
        
        localparam B_START = 5'b00000, B_RAISING = 5'b00001, B_FALLING = 5'b00010, B_STOP = 5'b00011, B_DRAW = 5'b00100, B_DEL = 5'b01111, B_UPDATE = 5'b01110, B_UPDATE_VY = 5'b01011; 
	
			reg [19:0]counter = 20'b00000000000000000000;
        always@(posedge clk)
        begin: state_table
                case(current)
                        B_START: begin
                                afterDraw <= press_key ? B_RAISING : B_START;
                                current <= B_DRAW;
                        end
                        B_RAISING: begin
                                if (touched) afterDraw <= B_STOP;
                                else afterDraw  <= flag ? B_FALLING : B_RAISING;
                                current <= B_DRAW;
                        end
                        B_FALLING: begin
                                if (touched) afterDraw <= B_STOP;
                                else begin 
										  afterDraw  <= press_key ? B_RAISING : B_FALLING;
										  end
                                current <= B_DRAW;
                        end
                        B_STOP: begin
									current <= B_START;
                        end
								B_DRAW: begin
									if(counter < 20'b00000000000010000000)
										counter = counter + 1'b1;
									else
									begin
										counter = 1'b0;
										current = B_DEL;
									end
								end
                        B_DEL: current <= B_UPDATE;
								B_UPDATE: current <= B_UPDATE_VY;
								B_UPDATE_VY: current <= afterDraw;
                        default current <= B_START;
                endcase
        end
	assign current_out = current;
        
        /*//enable signals
        always@(*)
        begin: enable_signals
                start = 1'b0;
                move = 1'b0;
                
                case(current)
                        B_START: start = 1'b1;
                        B_RAISING: move = 1'b1;
                        B_FALLING: move  = 1'b1;
                endcase
        end*/
                
        /*
        //state register
        always@(posedge clk)
        begin: state_FFS
                if (!resetn)
                        current <= B_START;
                else
                        current <= next;
        end*/
endmodule

/*
module control_bird(clk, flag, press_key, touched, finished_draw, current_out, progress);
        input clk;
        input press_key;
        input touched;
        input flag; // whether bird is too high
		  input finished_draw;
        output [3:0] current_out;
		  output progress;
        //current state and next state
        reg [3:0] next, afterDraw, current;
        
        localparam B_START = 4'b0000, B_RAISING = 4'b0001, B_FALLING = 4'b0010, B_STOP = 4'b0011, B_DRAW = 4'b0100, B_DEL = 4'b1111, B_UPDATE = 4'b1110; 
	
		reg finished;
        always@(posedge clk)
        begin: state_table
					
                case(current)
                        B_START: begin
											finished <= 1'b0;
                                afterDraw <= press_key ? B_RAISING : B_START;
                                current <= B_DRAW;
										  finished <= 1'b1;
                        end
                        B_RAISING: begin
										finished <= 1'b0;
                                if (touched) afterDraw <= B_STOP;
                                else afterDraw  <= flag ? B_FALLING : B_RAISING;
                                current <= B_DRAW;
										  finished <= 1'b1;
                        end
                        B_FALLING: begin
										finished <= 1'b0;
                                if (touched) afterDraw <= B_STOP;
                                else afterDraw  <= press_key ? B_RAISING : B_FALLING;
                                current <= B_DRAW;
										  finished <= 1'b1;
                        end
                        B_STOP: begin
									finished <= 1'b0;
									if (touched) begin
									current <= B_START;
									finished <= 1'b1;
									end
                        end
								B_DRAW: current <= B_DEL;
                        B_DEL: current <= B_UPDATE;
								B_UPDATE: begin
								finished <=1'b0;
								current <= afterDraw;
								finished <=1'b1;
								end
                        default current <= B_START;
                endcase
        end
	assign current_out = current;
	
	assign progress = current == B_DRAW || current == B_DEL ? finished_draw : 
						 finished; //DEFAULT
                

endmodule
*/