`timescale 1ns / 1ps

module multiplier(
		out, a_in, b_in, clk, start, reset, finish, bcd
	);
	
parameter N = 8;
parameter M = 8;
// Outputs
output[(N+M)-1:0] out;
output finish;

// Inputs
input start;
input clk;
input reset;
input [N-1:0] a_in;
input [M-1:0] b_in;

// Reference registers
reg[(N+M)-1:0] out_reg;
reg finish_reg = 0;
reg [(N+M)-1:0] a_in_reg;
reg [M-1:0] b_in_reg;
reg [3:0] bits;

// Continuous assignment
assign out = out_reg;
assign finish = finish_reg;

integer i, j;  

// Reset clk and inputs
always @(negedge reset)
begin
	out_reg = 0;
	a_in_reg = 0;
	b_in_reg = 0;
end

always @(posedge clk)
begin
	if(!reset)
	begin
		case(start)
			1'b0: begin
				a_in_reg = a_in;
				b_in_reg = b_in;
				bits = M;
				finish_reg = 0;
				out_reg = 0;
				$display("Values loaded into the input register!");
			end
			
			1'b1: begin
				if(b_in_reg[0]==1)
				begin
					out_reg = out_reg + a_in_reg;
				end
				bits = bits - 1;
				a_in_reg = a_in_reg<<1;
				b_in_reg = b_in_reg>>1;				
			end
		endcase
		if(bits==0)
		begin
			$display("Multiplication completed!");
			finish_reg = 1'b1;
		end
	end
end
endmodule
