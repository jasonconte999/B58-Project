module SevenSegDecoder(e, m);
    input [3:0] e;
    output [6:0] m;
	 
	 assign a = e[0];
	 assign b = e[1];
	 assign c = e[2];
	 assign d = e[3];

    assign m[0] = ~((~a | b | c | d) & (a | b | ~c | d) & (~a | ~b | c | ~d) & (~a | b | ~c | ~d));
    assign m[1] = ~((~a | ~b | ~d) & (a | ~b | ~c) & (a | ~c | ~d) & (~a | b | ~c | d));
    assign m[2] = ~(( ~b | ~c | ~d) & (a | ~c | ~d) & (a | ~b | c | d)) ;
    assign m[3] = ~((~a | ~b | ~c) & (~a | b |c) & (a | b| ~c | d)& (a | ~b |c|~d)) ;
    assign m[4] = ~((~a | d) & (~a | b | c) & (b | ~c | d)) ;
    assign m[5] = ~((~a | c | d) & (~b | c | d) & (~a | ~b | d) & (~a | b | ~c | ~d)) ;
    assign m[6] = ~((b | c | d) & (~a | ~b | ~c | d) & (a | b | ~c | ~d)) ;

endmodule