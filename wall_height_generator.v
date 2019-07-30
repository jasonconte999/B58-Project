/*module whg(HEX0, HEX1, SW, KEY, LEDR);
    input [1:0] SW;
    input [3:0] KEY;
	 output [7:0] LEDR;
    //input CLOCK_50;
    output [6:0] HEX0, HEX1;
    wire [7:0] r;
	 
    wall_height_generator whg(
	    .clk(KEY[2]),
	    .out(r)
	    );
	
	assign LEDR[7:0] = r;
		 
    hex_display h0(
	    .IN(r[3:0]), 
	    .OUT(HEX0)
	    );
		 
    hex_display h1(
	    .IN(r[7:4]), 
	    .OUT(HEX1)
	    );
endmodule

module hex_display(IN, OUT);
    input [3:0] IN;
	 output reg [7:0] OUT;
	 
	 always @(*)
	 begin
		case(IN[3:0])
			4'b0000: OUT = 7'b1000000;
			4'b0001: OUT = 7'b1111001;
			4'b0010: OUT = 7'b0100100;
			4'b0011: OUT = 7'b0110000;
			4'b0100: OUT = 7'b0011001;
			4'b0101: OUT = 7'b0010010;
			4'b0110: OUT = 7'b0000010;
			4'b0111: OUT = 7'b1111000;
			4'b1000: OUT = 7'b0000000;
			4'b1001: OUT = 7'b0011000;
			4'b1010: OUT = 7'b0001000;
			4'b1011: OUT = 7'b0000011;
			4'b1100: OUT = 7'b1000110;
			4'b1101: OUT = 7'b0100001;
			4'b1110: OUT = 7'b0000110;
			4'b1111: OUT = 7'b0001110;
			
			default: OUT = 7'b0111111;
		endcase

	end
endmodule

*/

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
