module control_bird(clk, resetn, flag, press_key, touched, current_out);
        input clk;
        input resetn;
        input press_key;
        input touched;
        input flag; // whether bird is too high
        output [3:0] current_out;
        //current state and next state
        reg [3:0] next, afterDraw, current;
        
        localparam B_START = 4'b0000, B_RAISING = 4'b0001, B_FALLING = 4'b0010, B_STOP = 4'b0011, B_DRAW = 4'b0100, B_DEL = 4'b1111, B_UPDATE = 4'b1110; 
	
        always@(posedge clk)
        begin: state_table
                case(current)
                        /*
                        B_READY: begin
                                afterDraw = press_key ? B_START : B_READY;
                                next = B_DRAW;
                        end*/
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
                                else afterDraw  <= press_key ? B_RAISING : B_FALLING;
                                current <= B_DRAW;
                        end
                        B_STOP: begin
                                //afterDraw <= B_START;
                                //next <= B_DRAW;
				if (touched) current <= B_START;
                        end
			B_DEL: current <= B_UPDATE;
			B_UPDATE: current <= B_DRAW;
                        B_DRAW: current <= afterDraw;
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
