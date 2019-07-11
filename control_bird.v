module control_bird(clk, resetn, press_key, touched start, move);
        input clk;
        input resetn;
        input press_key;
        input touched;
        output reg start;
        output reg move;
        //current state and next state
        reg [2:0] current, next;
        
        localparam B_READY = 3'b000, B_START = 3'b010, B_RAISING = 3'b110, B_FALLING = 3'b011, B_STOP = 3'b001;
        
        always@(*)
        begin: state_table
                case(current)
                        B_READY: next = press_key ? B_START : B_READY;
                        B_START: next = press_key ? B_RAISING : B_FALLING;
                        B_RAISING: begin
                                if(touched) next <= B_STOP;
                                else next  = press_key ? B_RAISING : B_FALLING;
                        end
                        B_FALLING: begin
                                if(touched) next <= B_STOP;
                                else next  = press_key ? B_RAISING : B_FALLING;
                        end
                        B_STOP: next = B_READY;
                        default next = B_READY;
                endcase
        end
        
        //enable signals
        always@(*)
        begin: enable_signals
                start = 1'b0;
                move = 1'b0;
                
                case(current)
                        B_START: start = 1'b1;
                        B_RAISING: move = 1'b1;
                        B_FALLING: move  = 1'b1;
                endcase
        end
                
        
        //state register
        always@(posedge clk)
        begin: state_FFS
                if (!resetn)
                        current <= B_READY;
                else
                        current <= next;
        end
endmodule
