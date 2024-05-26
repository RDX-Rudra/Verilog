module full_adder1b(
    input x, y, z,
    output sum, carry
);
    assign sum = x ^ y ^ z;
    assign carry = ((x & y) | (z & x) | (z & y));
endmodule

module adder_cum_subtractor4b (
    input [3:0] x, z,
    input cin,
    output [3:0] sum,
    output carry
);
    wire cout1, cout2, cout3;
    wire [3:0] y;
    assign y = {z[3] ^ cin, z[2] ^ cin, z[1] ^ cin, z[0] ^ cin};
    full_adder1b FA1 (x[0], y[0], cin, sum[0], cout1);
    full_adder1b FA2 (x[1], y[1], cout1, sum[1], cout2);
    full_adder1b FA3 (x[2], y[2], cout2, sum[2], cout3);
    full_adder1b FA4 (x[3], y[3], cout3, sum[3], carry);
endmodule

module adder_cum_subtractor8b (
    input [7:0] a, b,
    input op,
    output [7:0] result,
    output carry_out
);
    wire carry;
    wire [3:0] sum1, sum2;
    adder_cum_subtractor4b A1 (a[3:0], b[3:0], op, sum1, carry);
    adder_cum_subtractor4b A2 (a[7:4], b[7:4], carry, sum2, carry_out);
    assign result = {sum2, sum1};
endmodule

module mux1b4to1 (
    input a, b, c, d,
    input s1, s2,
    output e
);
    wire p, q, r, s;
    assign p=((~s1) & (~s2)) & a;
    assign q=((~s1) & (s2)) & b;
    assign r=((s1) & (~s2)) & c;
    assign s=((s1) & (s2)) & d;
    assign e = p|q|r|s;
endmodule

module alu (
    input [7:0] a, b,
    input [3:0] opcode,
    output reg [7:0] result,
    output carry_out
);
    wire [7:0] sum, diff, and_result, or_result;
    wire carry_sum, carry_diff;

    adder_cum_subtractor8b ADDER (a, b, 1'b0, sum, carry_sum);
    adder_cum_subtractor8b SUBTRACTOR (a, b, 1'b1, diff, carry_diff);

    assign and_result = a & b;
    assign or_result = a | b;

    always @(*) begin
        case (opcode)
            4'b0000: result = sum;           // ADD
            4'b0001: result = diff;          // SUBTRACT
            4'b0010: result = and_result;    // AND
            4'b0011: result = or_result;     // OR
            // Add more operations as needed
            default: result = 8'b00000000;
        endcase
    end

    assign carry_out = (opcode == 4'b0000) ? carry_sum : 
                       (opcode == 4'b0001) ? carry_diff : 1'b0;
endmodule
