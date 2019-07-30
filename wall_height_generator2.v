module wall_height_generator2(clk, out);
    input clk;
	 output wire [7:0] out;
	 reg [7:0] random_number;
	 reg [3:0] current;
    
    localparam a = 4'b0000, b = 4'b0001, c = 4'b0010, d = 4'b0011, e = 4'b0100, f = 4'b0101, g = 4'b0110, h = 4'b0111, i = 4'b1000, j = 4'b1001, k = 4'b1010;


    always@(posedge clk)
    begin: state_table
        case(current)
            a: begin
                random_number = 8'b00110010;
                current = b;
            end
            b : begin 
                random_number = 8'b00111100;
                current = c;
            end
            c: begin
					random_number = 8'b00101000;
                current = d;
				end
				d: begin
				random_number = 8'b01000110;
                current = e;
				end
				e: begin
				random_number = 8'b00011110;
                current = f;
				end
				f: begin
				random_number = 8'b01010000;
                current = g;
				end
				g:begin
				random_number = 8'b00001010;
                current = h;
				end
				h:begin
				random_number = 8'b01011010;
                current = i;
				end
				i:begin
				random_number = 8'b01100100;
                current = j;
				end
				j:begin
				random_number = 8'b00000000;
                current = k;
				end
				k:begin
				random_number = 8'b00110111;
                current = a;
				end
        endcase
    end
	 
	 assign out = random_number;
endmodule
