module mux1b4to1 (
    input a, b, c, d,
    input s1, s2,
    output e
);
    wire p, q, r, s;
    assign p=((-s1) & (-s2)) & a;
    assign q=((-s1) & (s2)) & b;
    assign r=((s1) & (-s2)) & c;
    assign s=((s1) & (s2)) & d;
    assign e = p|q|r|s;
endmodule