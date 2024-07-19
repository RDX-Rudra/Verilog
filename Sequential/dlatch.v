module dlatch (output reg Q, Qn,
    input wire c, d
);
    always @ (c or d)
        if(c == 1'b1)
            begin
                Q <= d;
                Qn <= ~d;
            end
endmodule

module tb_dlatch(
    output reg c, d,
    input wire Q, Qn
);
    initial begin
        c = 1'b0;
        d = 1'b0;
        #5 c = 1'b1;
        #10 d = 1'b1;
        #10 d = 1'b0;
        #10 d = 1'b1;
        #5 $finish;
    end
    
    always begin
        #5 c = ~c;
    end
endmodule

module wb_dlatch;
    wire c, d, Q, Qn;

    initial begin
        $monitor($time, " c=%b d=%b Q=%b Qn=%b", c, d, Q, Qn);
        $dumpfile("dlatch.vcd");
        $dumpvars(0,wb_dlatch);
    end

    dlatch dlat (Q, Qn, c, d);
    tb_dlatch tb(c, d, Q, Qn);
endmodule
