module mux1b4to1 (
    input a, b, c, d,
    input [1:0]s,
    output reg e
);
    always @(a, b, c, d, s) begin
        case (s)
            2'b00: e=a; 
            2'b01: e=b; 
            2'b10: e=c; 
            2'b11: e=d; 
        endcase
    end
endmodule //end_of_dut

module tb_mux1b4to1(
    output reg a, b, c, d,
    output reg [1:0]s,
    input e
);
    initial begin
        {a, b, c, d, s}= 6'b010100;
        #5 s=2'b01;
        #5 s=2'b10;
        #5 s=2'b11;
        #5 $finish;
    end
endmodule //end_of_testbench

module wb;
    wire a, b, c, d;
    wire [1:0] s;
    wire e;

    initial begin
        $monitor($time, " a=%b b=%b c=%b d=%b s=%b e=%b", a, b, c, d, s, e);
        $dumpfile("mux1b4to1_behav.vcd");
        $dumpvars(0,wb);
    end

    mux1b4to1 dut(a, b, c, d, s, e);
    tb_mux1b4to1 tb(a, b, c, d, s, e);
endmodule// end_of_workbench