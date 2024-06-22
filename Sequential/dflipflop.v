module dflipflop (
    output reg Q, Qn,
    input wire clk, d
);
    always @ (posedge clk)
        begin
            Q<=d;
            Qn <= ~d;
        end
endmodule

module tb_dflipflop(
    output reg clk, d,
    input wire Q, Qn
);
    initial begin
        clk = 1'b0;
        d = 1'b0;
    end

    always begin
        #5 clk = ~clk;
    end

    always @(posedge clk) begin
        #2 d = 1'b0;
        #8 d = 1'b1;
        #10 d = 1'b0;
        #10 d = 1'b1;
        #5 $finish;
    end
endmodule

module wb_dflipflop;
    wire c, d, Q, Qn;

    initial begin
        $monitor($time, " c=%b d=%b Q=%b Qn=%b", c, d, Q, Qn);
        $dumpfile("dflipflop.vcd");
        $dumpvars(0,wb_dflipflop);
    end

    dflipflop dff (Q, Qn, c, d);
    tb_dflipflop tb(c, d, Q, Qn);
endmodule