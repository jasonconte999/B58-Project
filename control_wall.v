module control_wall(go, touched, clk, current_out);
    input go;
    input touched;
    input clk;
    output [3:0] current_out;
    
    localparam W_READY = 4'b0101, W_MOVE = 4'b0110, W_STOP = 4'b0111, W_DRAW = 4'b1000, W_DEL = 4'b1001, W_UPDATE = 4'b1010;
    reg [3:0] next, afterDraw, current;

    
    // state table for wall
    always@(posedge clk)
    begin: state_table
        case(current)
            W_READY: begin
                afterDraw = go ? W_MOVE : W_READY; // move until the go is high
                current = W_DRAW;
            end
            W_MOVE : begin 
                afterDraw = touched ? W_STOP : W_MOVE; // stop if it's touched
                current = W_DRAW;
            end
            W_STOP: begin
                //afterDraw = W_READY;
                //next = W_DRAW;
					if (touched) current = W_READY;
            end
	    W_DEL: current = W_UPDATE;
	    W_UPDATE: current =  W_DRAW;
            W_DRAW: current = afterDraw;
            default current = W_READY;
        endcase
    end
	 
	 assign current_out = current;
    /*
    //state table for wall
    always@(*)
    begin: state_table
        case(current)
            W_READY: next = go ? W_MOVE : W_READY; //move until the go is high
            W_MOVE : next = touched ? W_STOP : W_MOVE; //stop if it's touched
            W_STOP: next = W_READY;
            default next = W_READY;
        endcase
    end
    */
    
    /*
    //enable signals
    always@(*)
        begin: enable_signals
            start = 1'b0;
            move = 1'b0;
            case(current)
                W_READY: start = 1'b1;
                W_MOVE: move = 1'b1;
            endcase
        end*/
    /*
    //state register
    always@(posedge clk)
    begin: state_FFS
        if (!resetn)
            current <= W_READY;
        else
            current <= next;
    end*/
endmodule
