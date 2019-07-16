// not done yet, edit later
// use a linear feedback shift register to generate nearly random numbers
// the output then be used to determine the bottom height of the wall in game
module Random_gen(clk, reset, out)
    input clk, reset;
    // 6 bit output
    output reg [5:0] out;
    // xor
    wire feedback = out[4] ^ out[5];
    
    always @ (posedge clock or posedge reset)
    begin
    if (reset)
        out <= 6'hF;
    else
        out <= {out[4:0], feedback}
    end
endmodule

