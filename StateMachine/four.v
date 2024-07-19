// Ecercise 8.2.4

module fsm22_behavioral (
    output reg Dout,
    input wire clk,
    input wire Reset,
    input wire Din
);
    parameter S0 = 4'b0001;
    parameter S1 = 4'b0010;
    parameter S2 = 4'b0100;
    parameter S3 = 4'b1000;

    reg [3:0] state, next_state;

    always @(posedge clk or posedge Reset) begin
        if (Reset) begin
            state <= S0;
            Dout <= 1'b0;
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            S0: begin
                if (Din) begin
                    next_state = S1;
                    Dout = 1'b1;
                end else begin
                    next_state = S0;
                    Dout = 1'b0;
                end
            end
            S1: begin
                if (Din) begin
                    next_state = S3;
                    Dout = 1'b0;
                end else begin
                    next_state = S2;
                    Dout = 1'b1;
                end
            end
            S2: begin
                if (Din) begin
                    next_state = S3;
                    Dout = 1'b1;
                end else begin
                    next_state = S0;
                    Dout = 1'b0;
                end
            end
            S3: begin
                if (Din) begin
                    next_state = S0;
                    Dout = 1'b1;
                end else begin
                    next_state = S3;
                    Dout = 1'b0;
                end
            end
            default: next_state = S0;
        endcase
    end

endmodule

module fsm22_behavioral_tb;

    parameter CLK_PERIOD = 10;

    reg clk;
    reg Reset;
    reg Din;
    wire Dout;

    fsm22_behavioral DUT (
        .clk(clk),
        .Reset(Reset),
        .Din(Din),
        .Dout(Dout)
    );

    always #((CLK_PERIOD / 2)) clk <= ~clk;

    initial begin
        $dumpfile("fsm22_behavioral_tb.vcd");
        $dumpvars(0, fsm22_behavioral_tb);

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

module fsm22_behavioral_wb;

    reg clk;
    reg Reset;
    reg Din;
    wire Dout;

    fsm22_behavioral DUT (
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
        $dumpfile("fsm22_behavioral_wb.vcd");
        $dumpvars(0, fsm22_behavioral_wb);

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
