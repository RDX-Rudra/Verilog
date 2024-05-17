module full_adder1b(
    input a, b, c,
    output sum, cout
);
    wire w1, w2;
    xor(w1, a, b);
    xor(sum, w1, c);
    assign cout = ((a & b) | (b & c) | (c & a));
endmodule

module parallel_adder4b (
    input [3:0]x, y;
    input cin,
    output [3:0] sum,
    output carry
);
    wire cout1, cout2, cout3;
    full_adder1b FA1 (x[0], y[0], cin, sum[0], cout1);
    full_adder1b FA1 (x[1], y[1], cout1, sum[1], cout2);
    full_adder1b FA1 (x[2], y[2], cout2, sum[2], cout3);
    full_adder1b FA1 (x[3], y[3], cout3, sum[3], carry);
endmodule