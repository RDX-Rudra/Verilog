module d_flipflop(
    input wire clk,
    input wire reset,
    input wire d,
    output reg q
);
    parameter IDLE = 2'b00;
    parameter SET = 2'b01;
    parameter RESET = 2'b10;

    reg [1:0] state, next_state;

    always @(posedge clk, posedge reset)
    begin
        if (reset)
        begin
            state <= IDLE;
            q <= 1'b0;
        end
        else
            state <= next_state;
    end

    always @(*)
    begin
        case (state)
            IDLE: begin
                if (d)
                    next_state = SET;
                else
                    next_state = RESET;
            end
            SET: begin
                next_state = IDLE;
                q <= 1'b1;
            end
            RESET: begin
                next_state = IDLE;
                q <= 1'b0;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule

module d_flipflop_tb;

    parameter CLK_PERIOD = 10;

    reg clk;
    reg reset;
    reg d;
    wire q;

    d_flipflop DUT(
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    always #((CLK_PERIOD / 2)) clk <= ~clk;

    initial begin
        $dumpfile("d_flipflop_tb.vcd");
        $dumpvars(0, d_flipflop_tb);

        reset = 1;
        #20 reset = 0;

        d = 0;
        #20 d = 1;
        #20 d = 0;
        #20 d = 1;
        #20 d = 0;
        #20 $finish;
    end

endmodule

module d_flipflop_wb;

    reg clk;
    reg reset;
    reg d;
    wire q;

    d_flipflop DUT(
        .clk(clk),
        .reset(reset),
        .d(d),
        .q(q)
    );

    always #5 clk <= ~clk;

    initial begin

        reset = 1;
        #20 reset = 0;

        repeat (10) begin
            #10 d = ~d;
        end
        #10 $finish;
    end
endmodule