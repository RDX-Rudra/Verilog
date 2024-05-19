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
endmodule //end_of_dut

module tb_mux1b4to1(
    output reg a, b, c, d,
    output reg s1, s2,
    input e
);
    initial begin
        $monitor($time,,, "a=%b b=%b c=%b d=%b s1=%b s2=%b e=%b", a,b,c,d,s1,s2,e);
        a = 1'b0; b = 1'b1; c = 1'b0; d = 1'b1; s1 = 1'b0; s2 = 1'b0;
        #5 {s1,s2} = 2'b01;
        #5 {s1,s2} = 2'b10;
        #5 {s1,s2} = 2'b11;
        #5 $finish;
    end
endmodule // end_of_testbench


module wb;
    wire a, b, c, d, s1, s2, e;
    mux1b4to1 dut(a, b, c, d, s1, s2, e);
    tb_mux1b4to1 tb(a, b, c, d, s1, s2, e);
endmodule // end_of_workbench