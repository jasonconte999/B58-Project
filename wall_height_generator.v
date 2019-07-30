// use a linear feedback shift register to generate nearly random numbers
// the output then be used to determine the height of the wall in game
module wall_height_generator(clk, out);
    input clk;
    output wire [7:0] out;
    // xor 2nd and 4th bits as feedback
    wire feedback = number[1] ^ number[4];
    
    reg [4:0] number, number_nxt, random_number;
    // record number of shifts
    reg [2:0] shift = 0, shift_nxt;
	 reg resetn = 1'b0;
	 
    always @ (posedge clk or negedge resetn)
    begin
        if (~resetn) begin
            number <= 5'hF;
				resetn = 1'b1;
				end
        else begin
            number <= number_nxt;
            shift <= shift_nxt;
				end
    end
	 
    always @ (*)
    begin
        number_nxt = number;
        shift_nxt <= shift;
        
        number_nxt <= {out[3:0], feedback};
        shift_nxt <= shift + 1;
        
        // after all shifts done, we get a random number
        if (shift == 5)begin
            random_number <= number;
				end
    end
    
    assign out = (random_number * 3);
endmodule
/*
// use a linear feedback shift register to generate nearly random numbers
// the output then be used to determine the height of the wall in game
module wall_height_generator(clk, resetn, out);
    input clk, resetn;
    output wire [7:0] out;
    // xor 2nd and 4th bits as feedback
    wire feedback = number[1] ^ number[4];
    
    reg [4:0] number, number_nxt, random_number;
    // record number of shifts
    reg [3:0] shift, shift_nxt;
	 
    always @ (posedge clk or negedge resetn)
    begin
        if (~resetn) begin
            number <= 5'hF;
            shift <= 0;
				end
        else
            number <= number_nxt;
            shift <= shift_nxt;
    end
	 
    always @ (*)
    begin
        number_nxt = number;
        shift_nxt <= shift;
        
        number_nxt <= {out[3:0], feedback};
        shift_nxt <= shift + 1;
        
        // after all shifts done, we get a random number
        if (shift == 5)
            shift <= 0;
            random_number <= number;
    end
    
    assign out = (random_number * 3);
endmodule
*/
