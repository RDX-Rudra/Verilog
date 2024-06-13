module fulladder1b(a, b, c_in, s, c_out);
    input a, b, c_in;
    output s, c_out;
    assign s = a ^ b ^ c_in;
    assign c_out = (a & b) | (b & c_in) | (c_in & a);
endmodule

module comptwo(x, negx);
    input [7:0] x;
    output [7:0] negx;
    assign negx = (~x) + 1;
endmodule

module and8b(x, y, andout);
    input [7:0] x, y;
    output [7:0] andout;
    assign andout = x & y;
endmodule

module or8b(x, y, orout);
    input [7:0] x, y;
    output [7:0] orout;
    assign orout = x | y;
endmodule

module nand8b(x, y, nandout);
    input [7:0] x, y;
    output [7:0] nandout;
    assign nandout = ~(x & y);
endmodule

module xor8b(x, y, xorout);
    input [7:0] x, y;
    output [7:0] xorout;
    assign xorout = x ^ y;
endmodule

module nor8b(x, y, norout);
    input [7:0] x, y;
    output [7:0] norout;
    assign norout = ~(x | y);
endmodule

module not8b(x, notout);
    input [7:0] x;
    output [7:0] notout;
    assign notout = ~x;
endmodule

module sub8b(x, y, c_in, d, c_out);
    input [7:0] x, y;
    input c_in;
    output [7:0] d;
    output c_out;
    wire [7:0] neg_y;
    comptwo neg(y, neg_y);
    add8b adder(x, neg_y, c_in, d, c_out);
endmodule

module add8b(x, y, c_in, s, c_out);
    input [7:0] x, y;
    input c_in;
    output [7:0] s;
    output c_out;
    wire [7:0] c;
    fulladder1b fa0(x[0], y[0], c_in, s[0], c[0]);
    fulladder1b fa1(x[1], y[1], c[0], s[1], c[1]);
    fulladder1b fa2(x[2], y[2], c[1], s[2], c[2]);
    fulladder1b fa3(x[3], y[3], c[2], s[3], c[3]);
    fulladder1b fa4(x[4], y[4], c[3], s[4], c[4]);
    fulladder1b fa5(x[5], y[5], c[4], s[5], c[5]);
    fulladder1b fa6(x[6], y[6], c[5], s[6], c[6]);
    fulladder1b fa7(x[7], y[7], c[6], s[7], c_out);
endmodule

module mux1b16to1 (
    input add_r, sub_r, and_r, or_r, nand_r, xor_r, nor_r, not_r,
    input add_r1, sub_r1, and_r1, or_r1, nand_r1, xor_r1, nor_r1, not_r1,
    input [3:0] cntrl,
    output out
);
    assign out = ({cntrl == 4'b0000} & add_r) |
                 ({cntrl == 4'b0001} & sub_r) |
                 ({cntrl == 4'b0010} & and_r) |
                 ({cntrl == 4'b0011} & or_r) |
                 ({cntrl == 4'b0100} & nand_r) |
                 ({cntrl == 4'b0101} & xor_r) |
                 ({cntrl == 4'b0110} & nor_r) |
                 ({cntrl == 4'b0111} & not_r) |
                 ({cntrl == 4'b1000} & add_r1) |
                 ({cntrl == 4'b1001} & sub_r1) |
                 ({cntrl == 4'b1010} & and_r1) |
                 ({cntrl == 4'b1011} & or_r1) |
                 ({cntrl == 4'b1100} & nand_r1) |
                 ({cntrl == 4'b1101} & xor_r1) |
                 ({cntrl == 4'b1110} & nor_r1) |
                 ({cntrl == 4'b1111} & not_r1);
endmodule

module mux8b16to1(
    input [7:0] add_r, sub_r, and_r, or_r, nand_r, xor_r, nor_r, not_r,
    input [7:0] add_r1, sub_r1, and_r1, or_r1, nand_r1, xor_r1, nor_r1, not_r1,
    input [3:0] cntrl,
    output [7:0] out
);
    genvar i;
    generate
        for (i = 0; i < 8; i = i + 1) begin : mux_loop
            mux1b16to1 mux(
                add_r[i], sub_r[i], and_r[i], or_r[i], nand_r[i], xor_r[i], nor_r[i], not_r[i],
                add_r1[i], sub_r1[i], and_r1[i], or_r1[i], nand_r1[i], xor_r1[i], nor_r1[i], not_r1[i],
                cntrl, out[i]
            );
        end
    endgenerate
endmodule

module carrymux1b4to1(
    input add_c, sub_c, add_c1, sub_c1,
    input [3:0] cntrl,
    output carry
);
    assign carry = ({cntrl == 4'b0000} & add_c) |
                   ({cntrl == 4'b0001} & sub_c) |
                   ({cntrl == 4'b1000} & add_c1) |
                   ({cntrl == 4'b1001} & sub_c1);
endmodule

module alu(
    input [7:0] x, y,
    input [3:0] cntrl,
    input c_in,
    output [7:0] out,
    output c_out
);
    wire [7:0] add_r, sub_r, and_r, or_r, nand_r, xor_r, nor_r, not_r;
    wire [7:0] add_r1, sub_r1, and_r1, or_r1, nand_r1, xor_r1, nor_r1, not_r1;
    wire c_out_add, c_out_sub, c_out_add1, c_out_sub1;

    add8b adder(x, y, c_in, add_r, c_out_add);
    sub8b subtractor(x, y, c_in, sub_r, c_out_sub);
    and8b ander(x, y, and_r);
    or8b orer(x, y, or_r);
    nand8b nander(x, y, nand_r);
    xor8b xorer(x, y, xor_r);
    nor8b norer(x, y, nor_r);
    not8b noter(x, not_r);
    add8b adder1(x, y, c_in, add_r1, c_out_add1);
    sub8b subtractor1(x, y, c_in, sub_r1, c_out_sub1);
    and8b ander1(x, y, and_r1);
    or8b orer1(x, y, or_r1);
    nand8b nander1(x, y, nand_r1);
    xor8b xorer1(x, y, xor_r1);
    nor8b norer1(x, y, nor_r1);
    not8b noter1(x, not_r1);

    mux8b16to1 mux(
        add_r, sub_r, and_r, or_r, nand_r, xor_r, nor_r, not_r,
        add_r1, sub_r1, and_r1, or_r1, nand_r1, xor_r1, nor_r1, not_r1,
        cntrl, out
    );

    carrymux1b4to1 carrymux(
        c_out_add, c_out_sub, c_out_add1, c_out_sub1, cntrl, c_out
    );
endmodule

module testbench;
    reg [7:0] x, y;
    reg [3:0] cntrl;
    wire [7:0] out;
    wire carry;
    alu dut(x, y, cntrl, 1'b0, out, carry);

    initial begin
        $monitor($time, " x=%b, y=%b, control_input=%b, output=%b, carry=%b", x, y, cntrl, out, carry);
        x = 8'b01001111; y = 8'b10100101; cntrl = 4'b0000;
        #5 cntrl = 4'b0001;
        #5 cntrl = 4'b0010;
        #5 cntrl = 4'b0011;
        #5 cntrl = 4'b0100;
        #5 cntrl = 4'b0101;
        #5 cntrl = 4'b0110;
        #5 cntrl = 4'b0111;
        #5 cntrl = 4'b1000;
        #5 cntrl = 4'b1001;
        #5 cntrl = 4'b1010;
        #5 cntrl = 4'b1011;
        #5 cntrl = 4'b1100;
        #5 cntrl = 4'b1101;
        #5 cntrl = 4'b1110;
        #5 cntrl = 4'b1111;
        #5 $finish;
    end
endmodule

module workbench;
    initial begin
        $dumpfile("simple_alu.vcd");
        $dumpvars(0, workbench);
    end
    
    testbench tb();
endmodule
