module control_bird(clk, resetn, flag, press_key, touched, current);
        input clk;
        input resetn;
        input press_key;
        input touched;
        input flag; // whether bird is too high
        output reg [3:0] current;
        //current state and next state
        reg [3:0] next, afterDraw;
        
        localparam B_START = 4'b0000, B_RAISING = 4'b0001, B_FALLING = 4'b0010, B_STOP = 4'b0011, B_DRAW = 4'b0100; /*B_READY = 3'b000,*/
        
        always@(*)
        begin: state_table
                case(current)
                        /*
                        B_READY: begin
                                afterDraw = press_key ? B_START : B_READY;
                                next = B_DRAW;
                        end*/
                        B_START: begin
                                afterDraw <= press_key ? B_RAISING : B_START;
                                next <= B_DRAW;
                        end
                        B_RAISING: begin
                                if (touched) afterDraw <= B_STOP;
                                else afterDraw  <= flag ? B_FALLING : B_RAISING;
                                next <= B_DRAW;
                        end
                        B_FALLING: begin
                                if (touched) afterDraw <= B_STOP;
                                else afterDraw  <= press_key ? B_RAISING : B_FALLING;
                                next <= B_DRAW;
                        end
                        B_STOP: begin
                                //afterDraw <= B_START;
                                //next <= B_DRAW;
				if (touched) next <= B_START;
                        end
                        B_DRAW: next <= afterDraw;
                        default next <= B_START;
                endcase
        end
        
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
                
        
        //state register
        always@(posedge clk)
        begin: state_FFS
                if (!resetn)
                        current <= B_START;
                else
                        current <= next;
        end
endmodule
