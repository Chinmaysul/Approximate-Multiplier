    module wallace_multiplier_8x8( 
        input [7:0] a, 
        input [7:0] b, 
        output [15:0] product 
    ); 
     
    wire [15:0] partial_products [0:7]; 
    wire [11:0] stage1_sums [0:3]; 
    wire [7:0] stage1_carries [0:3]; 
    wire [7:0] stage2_sums; 
    wire [3:0] stage2_carries; 
    wire [3:0] stage3_sums; 
    wire [1:0] stage3_carries; 
    wire [1:0] stage4_sum; 
    wire stage4_carry; 
     
    // Generate partial products 
    genvar i, j; 
    generate 
        for (i = 0; i < 8; i = i + 1) begin 
            for (j = 0; j < 8; j = j + 1) begin 
                assign partial_products[j][i] = a[i] & b[j]; 
            end 
        end 
    endgenerate 
     
    // Stage 1 compression 
    csa_compressor_4_2 csa_1(.a({partial_products[0][3:0], 4'b0}), 
                            .b({partial_products[1][4:0], 3'b0}), 
                            .c({partial_products[2][5:0], 2'b0}), 
                            .d({partial_products[3][6:0], 1'b0}), 
                            .sum(stage1_sums[0]), 
                            .carry(stage1_carries[0])); 
     
    csa_compressor_4_2 csa_2(.a({partial_products[4][7:0]}), 
                            .b({partial_products[5][7:0]}), 
                            .c({partial_products[6][7:0]}), 
                            .d({partial_products[7][7:0]}), 
                            .sum(stage1_sums[1]), 
                            .carry(stage1_carries[1])); 
     
    csa_compressor_4_2 csa_3(.a({stage1_sums[0][11:4], 4'b0}), 
                            .b({stage1_carries[0], 4'b0}), 
                            .c({stage1_sums[1][11:4], 4'b0}), 
                            .d({stage1_carries[1], 4'b0}), 
                            .sum(stage1_sums[2]), 
                            .carry(stage1_carries[2])); 
     
    csa_compressor_4_2 csa_4(.a({stage1_sums[2][11:8], 8'b0}), 
                            .b({stage1_carries[2], 8'b0}), 
                            .c({8'b0}), 
                            .d({8'b0}), 
                            .sum(stage1_sums[3]), 
                            .carry(stage1_carries[3])); 
     
    // Stage 2 compression 
    csa_compressor_3_2 csa_5(.a(stage1_sums[3][7:0]), 
                            .b(stage1_carries[3]), 
                            .c({stage1_sums[2][7:0], 8'b0}), 
                            .sum(stage2_sums), 
                            .carry(stage2_carries)); 
     
    // Stage 3 compression 
    csa_compressor_3_2 csa_6(.a(stage2_sums[7:4]), 
                            .b(stage2_carries), 
                            .c({stage2_sums[3:0], 4'b0}), 
                            .sum(stage3_sums), 
                            .carry(stage3_carries)); 
     
    // Stage 4 compression 
    csa_compressor_2_2 csa_7(.a(stage3_sums), 
                            .b(stage3_carries), 
                            .sum(stage4_sum), 
                            .carry(stage4_carry)); 
     
    assign product = {stage4_carry, stage4_sum, stage1_sums[0][3:0], partial_products[0][0]}; 
     
    endmodule 
     
    module csa_compressor_4_2( 
        input [15:0] a, 
        input [15:0] b, 
        input [15:0] c, 
        input [15:0] d, 
        output [11:0] sum, 
        output [7:0] carry 
    ); 
     
    wire [15:0] temp1, temp2; 
     
    // 4:2 Compressor 
    assign temp1 = a ^ b ^ c ^ d; 
    assign temp2 = ((a & b) | (a & c) | (b & c)) + d; 
     
    assign sum = temp1[11:0]; 
    assign carry = temp2[7:0]; 
     
    endmodule 
     
    module csa_compressor_3_2( 
        input [7:0] a, 
        input [7:0] b, 
        input [15:0] c, 
        output [7:0] sum, 
        output [3:0] carry 
    ); 
     
    wire [7:0] temp1, temp2; 
     
    // 3:2 Compressor 
    assign temp1 = a ^ b ^ c[7:0]; 
    assign temp2 = ((a & b) | (a & c[7:0]) | (b & c[7:0])) + c[15:8]; 
     
    assign sum = temp1; 
    assign carry = temp2[3:0]; 
     
    endmodule 
     
    module csa_compressor_2_2( 
        input [3:0] a, 
        input [3:0] b, 
        output [1:0] sum, 
        output carry 
    ); 
     
    wire [3:0] temp1, temp2; 
     
    // 2:2 Compressor 
    assign temp1 = a ^ b; 
    assign temp2 = (a & b); 
     
    assign sum = temp1[1:0]; 
    assign carry = temp2[0]; 
     
    endmodule 
