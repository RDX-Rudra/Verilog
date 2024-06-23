// Exercise 2.8.1

module fsml_behavioral (
    output reg Dout,
    input wire clk,
    input wire Reset,
    input wire Din
);
    parameter Start = 2'b00;
    parameter Midway = 2'b01;
    parameter Done = 2'b10;

    reg [1:0] state, next_state;

    always @(posedge clk or posedge Reset) begin
        if (Reset) begin
            state <= Start;
            Dout <= 1'b0; 
        end else begin
            state <= next_state;
        end
    end

    always @(*) begin
        case (state)
            Start: begin
                if (Din) begin
                    next_state = Midway;
                    Dout = 1'b0;
                end else begin
                    next_state = Start;
                    Dout = 1'b0;
                end
            end
            Midway: begin
                next_state = Done;
                Dout = 1'b0;
            end
            Done: begin
                if (Din) begin
                    next_state = Start;
                    Dout = 1'b1;
                end else begin
                    next_state = Start;
                    Dout = 1'b0;
                end
            end
            default: next_state = Start;
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
        $monitor ("Time,,, %0d, Reset: %b, Din: %b, Dout: %b, clk: %b, current_state: %b", $time, Reset, Din, Dout, clk, DUT.state);
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
