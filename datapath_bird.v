module datapath_bird(input clk, input jump, input [4:0] cur_state, input collision, output [7:0] y_out);
    

	//localparam BIRD_Y_START = 8'b00111100; //Bird starts at y=60
	//localparam BIRD_VY_START = 8'b00000000; //Bird's vertical speed starts at 0
	localparam BIRD_VY_SPEED = 8'b00000100; //Bird's vertical speed decreases by speed 4
	localparam BIRD_VY_JUMP = 8'b00001010; //When bird jumps, velocity becomes 10
	localparam GRAVITY = 8'b0000001000;
	localparam BIRD_Y_START = 8'b01000000;
	localparam BIRD_VY_START = 8'b00001000;
	
	localparam UPDATE_BIRD_Y = 5'b01110;
	localparam UPDATE_BIRD_VY = 5'b01011;

	reg [7:0] bird_vy = BIRD_VY_START; 
	reg [7:0] bird_y = BIRD_Y_START;
	reg raising = 1'b1, stopped = 1'b0;
	
	wire pulse_y, pulse_vy;
	
	RateDivider rd0(
		.d(20'b00000000111100000000),
		.r(28'b000000000000000000000000010),
		.clock(clk & cur_state == UPDATE_BIRD_Y),
		.Clear_b(1'b1),
		.ParLoad(1'b1),
		.Enable(1'b1),
		.pulse(pulse_y)
	);
	
	RateDivider rd1(
		.d(20'b00000000011111000000),
		.r(28'b000000000000000000000000010),
		.clock(clk & cur_state == UPDATE_BIRD_VY),
		.Clear_b(1'b1),
		.ParLoad(1'b1),
		.Enable(1'b1),
		.pulse(pulse_vy)
	);
	reg [20:0] counter = 1'b0;
	
    	// State mapping
	always @(posedge pulse_y)
	begin
		if(collision && counter == 1'b0)
			counter <= 1'b1;
		else if (counter > 1'b0 && counter < 10'b0001000000)
			counter <= counter + 1'b1;
		else if (counter >= 10'b0001000000)
		begin
			bird_y <= BIRD_Y_START;
			counter = 1'b0;
		end
		else if(raising && !stopped && bird_y >= bird_vy)
			bird_y <= bird_y - bird_vy;//- 3'b101;
		else if(!raising && !stopped)
			bird_y <= bird_y + bird_vy;
	end
	
	always @(posedge pulse_vy)
	begin
		
		if(collision)
			bird_vy <= BIRD_VY_START;
		else if(!raising && jump)
		begin
			raising <= 1'b1;
			bird_vy <= 8'b00001000;
			stopped <= 1'b0;
		end
		else if(raising && bird_y < bird_vy) begin //hits roof
			bird_vy <= 1'b0;
			raising <= 1'b0;
		end
		else if(!raising && bird_y + bird_vy > 8'b01101100) begin //hits floor
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
