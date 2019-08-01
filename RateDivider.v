`timescale 1ns / 1ns // `timescale time_unit/time_precision

module RateDivider(d, r, clock, Clear_b, ParLoad, Enable, pulse);
	input [27:0] d, r;
	input clock;
	input Clear_b;
	input ParLoad;
	input Enable;
	output pulse;
	reg [27:0] q; // declare q
	always @(posedge clock) // triggered every time clock rises
	begin
		if (Clear_b == 1'b0) // when Clear_b is 0...
		q <= 28'b0000000000000000000000000000; // set q to 0
		else if (ParLoad == 1'b0 || q == 28'b0000000000000000000000000000) // ...otherwise, check if parallel load
		q <= d; // load d
		else if (Enable == 1'b1) // ...otherwise update q (only when Enable is 1)
		q <= q - 1'b1; // increment q
		// q <= q - 1'b1; // alternatively, decrement q
	end
	assign pulse = (q < r) ? 1 : 0;
endmodule
