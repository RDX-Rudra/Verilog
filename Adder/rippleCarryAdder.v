module full_adder1b(
    input a, b, c,
    output sum, cout
);
    wire w1, w2;
    xor(w1, a, b);
    xor(sum, w1, c);
    assign cout = ((a & b) | (b & c) | (c & a));
endmodule

