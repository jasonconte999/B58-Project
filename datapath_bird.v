module datapath_bird(input clk, input [3:0] cur_state, output [7:0] y_out);
    
    // registers
	//if starts at 8'b00010000, will ignore last bit. Can accomodate for this by taking everything up until this bit
	//Note: this only occurs if you try to access the value of bird_vy at all. If you dont, it wil; decrement just fine
	//reg [17:0] bird_vy = 18'b000000000000001000; 
	reg [7:0] bird_vy = 8'b00001000; 
	reg [7:0] bird_y = 8'b01000000;
	reg raising = 1'b1, stopped = 1'b0;

	//localparam BIRD_Y_START = 8'b00111100; //Bird starts at y=60
	//localparam BIRD_VY_START = 8'b00000000; //Bird's vertical speed starts at 0
	localparam BIRD_VY_SPEED = 8'b00000100; //Bird's vertical speed decreases by speed 4
	localparam BIRD_VY_JUMP = 8'b00001010; //When bird jumps, velocity becomes 10
	localparam GRAVITY = 8'b0000001000;
	localparam UPDATE_BIRD_Y = 4'b0110;
	localparam UPDATE_BIRD_VY = 4'b0111;
	
	wire pulse_y, pulse_vy;
	
	RateDivider rd0(
		.d(8'b10000000),
		.clock(clk & cur_state == UPDATE_BIRD_Y),
		.Clear_b(1'b1),
		.ParLoad(1'b1),
		.Enable(1'b1),
		.pulse(pulse_y)
	);
	
	RateDivider rd1(
		.d(8'b10000000),
		.clock(clk & cur_state == UPDATE_BIRD_VY),
		.Clear_b(1'b1),
		.ParLoad(1'b1),
		.Enable(1'b1),
		.pulse(pulse_vy)
	);
	
    	// State mapping
	always @(posedge pulse_y)
	begin
		if(raising && !stopped)
			bird_y <= bird_y - bird_vy;//- 3'b101;
		else if(!raising && !stopped)
			bird_y <= bird_y + bird_vy;
	end
	
	always @(posedge pulse_y)
	begin
		if(raising && bird_y < bird_vy) begin //hits roof
			bird_vy <= 1'b0;
			raising <= 1'b0;
		end
		else if(!raising && bird_y + bird_vy > 8'b01000000) begin //hits floor
			bird_vy <= 1'b0;
			stopped <= 1'b1;
		end
		else if (raising && bird_vy - 1'b1 > 1'b0)//(falling == 1'b0) && 
			bird_vy <= bird_vy - 3'b001;
		else if (raising && bird_vy - 1'b1 == 1'b0)
			raising <= 1'b0;
		else if (!raising) //&& !stopped)
			bird_vy <= bird_vy + 1'b1;
	end
	
	assign y_out = bird_y;
    
endmodule
