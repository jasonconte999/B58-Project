module control_wall(go, touched, clk, resetn, start, move);
    input go;
    input touched;
    input clk;
    input resetn;
    output reg start;
    output reg move;
    
    localparam W_READY = 2'b00, W_MOVE = 2'b01; W_STOP = 2'b11;    
    reg [1:0] current, next;
    
    localparam W_READY = 2'b00, W_MOVE = 2'b01, W_STOP = 2'b11;
    //state table for wall
    always@(*)
    begin: state_table
        case(current)
            W_READY: next = go ? W_MOVE : W_READY;
            W_MOVE : next = touched ? W_STOP : W_MOVE;
            W_STOP: next = W_READY;
            default next = W_READY;
        endcase
    end
    //enable signals
    always@(*)
        begin: enable_signals
            start = 1'b0;
            move = 1'b0;
            case(current)
                W_READY: start = 1'b1;
                W_MOVE: move = 1'b1;
            endcase
        end
    
    //state register
    always@(posedge clk)    localparam W_READY = 2'b00, W_MOVE = 2'b01; W_STOP = 2'b11;
    begin: state_FFS
        if (!resetn)
            current <= W_READY;
        else
            current <= next;
    end
endmodule
    
    
