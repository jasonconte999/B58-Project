module control_wall(go, touched, clk, current_out);
    input go;
    input touched;
    input clk;
    output [4:0] current_out;
    
    localparam W_READY = 5'b00101, W_MOVE = 5'b00110, W_STOP = 5'b00111, W_DRAW = 5'b01000, W_DEL = 5'b01001, W_UPDATE = 5'b01010, W_DRAW_B = 5'b01101, W_DEL_B = 5'b01100;
    reg [3:0] afterDraw, current;
    reg [19:0]counter = 20'b00000000000000000000;
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
					current = W_READY;
            end
				//W_DRAW: current = W_DRAW_B;
				W_DRAW: current = W_DEL;
            W_DEL: current = W_DRAW_B;
				W_DRAW_B: current = W_DEL_B;
				W_DEL_B: current = W_UPDATE;
				W_UPDATE: current =  afterDraw;
            default current = W_READY;
        endcase
    end
	 
	 /*
	 RateDivider rd4(
		.d(28'b000000000000000000001000000),
		.r(28'b000000000000000000000000010),
		.clock(clk),
		.Clear_b(reset),
		.ParLoad(start),
		.Enable(1'b1),
		.pulse(pulse2)
	);*/
	 
	 assign current_out = current;
    
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

/*
module control_wall(go, touched, clk, finished_draw,  current_out, progress);
    input go;
    input touched;
    input clk;
	 input finished_draw;
    output [3:0] current_out;
	 output progress;
    
    localparam W_READY = 4'b0101, W_MOVE = 4'b0110, W_STOP = 4'b0111, W_DRAW = 4'b1000, W_DEL = 4'b1001, W_UPDATE = 4'b1010;
    reg [3:0] afterDraw, current;
	 reg finished;
    
    // state table for wall
    always@(posedge clk)
    begin: state_table
        case(current)
            W_READY: begin
					finished <= 1'b0;
                afterDraw = go ? W_MOVE : W_READY; // move until the go is high
                current = W_DRAW;
					 finished <=1'b1;
            end
            W_MOVE : begin 
					finished <= 1'b0;
                afterDraw = touched ? W_STOP : W_MOVE; // stop if it's touched
                current = W_DRAW;
					 finished <=1'b1;
            end
            W_STOP: begin
					finished <= 1'b0;
					if (touched)begin
						current = W_READY;
						finished <=1'b1;
					end
            end
				W_DRAW: begin
				current = W_DEL;
				end
            W_DEL: begin
				current = W_UPDATE;
				end
				W_UPDATE: begin
				finished <=1'b0;
				current =  afterDraw;
				finished <=1'b1;
				end
            default current = W_READY;
        endcase
    end
	 assign progress = current == W_DRAW || current == W_DEL ? finished_draw : 
						 finished; //DEFAULT
	 
	 assign current_out = current;
    

endmodule
*/