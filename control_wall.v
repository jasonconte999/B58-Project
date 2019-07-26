module control_wall(go, touched, clk, resetn, current);
    input go;
    input touched;
    input clk;
    input resetn;
    output reg [3:0] current;
    
    localparam W_READY = 4'b0101, W_MOVE = 4'b0110, W_STOP = 4'b0111, W_DRAW = 4'b1000;
    reg [3:0] next, afterDraw;

    
    // state table for wall
    always@(*)
    begin: state_table
        case(current)
            W_READY: begin
                afterDraw = go ? W_MOVE : W_READY; // move until the go is high
                next = W_DRAW;
            end
            W_MOVE : begin 
                afterDraw = touched ? W_STOP : W_MOVE; // stop if it's touched
                next = W_DRAW;
            end
            W_STOP: begin
                //afterDraw = W_READY;
                //next = W_DRAW;
					if (touched) next = W_READY;
            end
            W_DRAW: next = afterDraw;
            default next = W_READY;
        endcase
    end
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
    
    //state register
    always@(posedge clk)
    begin: state_FFS
        if (!resetn)
            current <= W_READY;
        else
            current <= next;
    end
endmodule
