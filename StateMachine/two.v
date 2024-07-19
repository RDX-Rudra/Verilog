// Exercise 8.2.2

module fsml_behavioral (
    output reg Dout,
    input wire clk,
    input wire Reset,
    input wire Din
);
    parameter IDLE = 3'b001;
    parameter MIDWAY = 3'b010;
    parameter DONE = 3'b100;

    reg [2:0] state, next_state;

    always @(posedge clk or posedge Reset) begin
        if (Reset) begin
            state <= IDLE;
            Dout <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            IDLE: begin
                if (Din) begin
                    next_state = MIDWAY;
                    Dout = 1'b0;
                end else begin
                    next_state = IDLE;
                    Dout = 1'b0;
                end
            end
            MIDWAY: begin
                next_state = DONE;
                Dout = 1'b0;
            end
            DONE: begin
                next_state = IDLE;
                Dout = Din;
            end
            default: next_state = IDLE;
        endcase
    end

endmodule

module fsml_behavioral_tb;

    parameter CLK_PERIOD = 10;

    reg clk;
    reg Reset;
    reg Din;
    wire Dout;

    fsml_behavioral DUT (
        .clk(clk),
        .Reset(Reset),
        .Din(Din),
        .Dout(Dout)
    );

    always #((CLK_PERIOD / 2)) clk <= ~clk;

    initial begin
        $dumpfile("fsml_behavioral_tb.vcd");
        $dumpvars(0, fsml_behavioral_tb);

        Reset = 1;
        #20 Reset = 0;

        Din = 0;
        #20 Din = 1;
        #20 Din = 0;
        #20 Din = 1;
        #20 Din = 0;
        #20 $finish;
    end

endmodule

module fsml_behavioral_wb;

    reg clk;
    reg Reset;
    reg Din;
    wire Dout;

    fsml_behavioral DUT (
        .clk(clk),
        .Reset(Reset),
        .Din(Din),
        .Dout(Dout)
    );

    initial begin
        clk = 0;
    end

    always #5 clk <= ~clk;

    initial begin
        $monitor("Time %0t, Reset: %b, Din: %b, Dout: %b, clk: %b, current_state: %b", $time, Reset, Din, Dout, clk, DUT.state);
        $dumpfile("fsml_behavioral_wb.vcd");
        $dumpvars(0, fsml_behavioral_wb);

        Reset = 1;
        #20 Reset = 0;

        Din = 0;
        #10 Din = 1;
        #10 Din = 0;
        #10 Din = 1;
        #10 Din = 0;
        #10 Din = 1;
        #10 Din = 0;

        #50 $finish;
    end

endmodule
