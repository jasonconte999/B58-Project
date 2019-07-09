module datapath(
    input clk,
    input resetn,
    input [7:0] data_in,
    input ld_alu_out, 
    input ld_x, ld_a, ld_b, ld_c,
    input ld_r,
    input alu_op, 
    input [1:0] alu_select,
    output reg [7:0] data_result
    );
    
    // input registers
    reg [7:0] wall_x, bird_vy, bird_y;

    // output of the alu
    reg [7:0] alu_out;
    // alu input muxes
    reg [7:0] alu_a, alu_b;

    localparam BIRD_Y_START = 8'b00111100; //Bird starts at y=60
    localparam BIRD_VY_START = 8'b00000000; //Bird's vertical speed starts at 0
    localparam BIRD_VY_SPEED = 8'b00000100; //Bird's vertical speed decreases by speed 4
    localparam BIRD_VY_JUMP = 8'b00001010; //When bird jumps, velocity becomes 10
    localparam WALL_X_START = 8'b01100100; //Wall starts at x=100
    localparam WALL_X_SPEED = 8'b00000100; //Wall moves at speed 4
    localparam WALL_WIDTH = 8'b0000001010; //Wall is 10 pixels thick
    
    // Reset registers if necessary
    always@(posedge clk) begin
        if(!resetn) begin
            wall_x <= WALL_X_START; 
            bird_vy <= BIRD_VY_START; 
            bird_y <= BIRD_Y_START;
        end
    end

    // The ALU input multiplexers
    always @(*)
    begin
        case (alu_select)
            2'd0:
                alu_a = wall_x;
		alu_b = WALL_X_SPEED;
            2'd1:
                alu_a = bird_vy;
		alu_b = BIRD_VY_SPEED;
            2'd2:
                alu_a = bird_y;
		alu_b = bird_vy;
            default: alu_a = 8'b0;
        endcase
    end

    // The ALU 
    always @(*)
    begin : ALU
        // alu
        case (alu_op)
            0: begin
                   alu_out = alu_a - alu_b; //performs subtraction
               end
            default: alu_out = 8'b0;
        endcase
    end

    // The ALU output multiplexers
    always @(*)
    begin
        case (alu_select)
            2'd0:
                wall_x = alu_out;
            2'd1:
                bird_vy = alu_out;
            2'd2:
                bird_y = alu_out;
            default: alu_a = 8'b0;
        endcase
    end
    
endmodule
