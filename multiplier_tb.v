`timescale 1ns / 1ps 

module multiplier_tb; 
	reg[7:0] a;
	reg[7:0] b;
	wire[15:0] product;
    	wallace_multiplier_8x8 dut(a,b,product);
    
    
    initial begin
    
	    a = 8'b00001010;
	    b = 8'b00000101;
	    $display("a=%d, b=%d, product=%d", a,b,product);
	    #10
	    
	    a = 8'b00010010;
	    b = 8'b00001111;
	    $display("a=%d, b=%d, product=%d", a,b,product);
	    #10
	    
	    a = 8'b00010100;
	    b = 8'b00000101;
	    $display("a=%d, b=%d, product=%d", a,b,product);
	    #10

	    $finish;
    
    end
    
endmodule
