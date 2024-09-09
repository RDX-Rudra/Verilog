module sequence_detector (
    input wire clk,
    input wire reset,
    input wire DIN,
    output reg FOUND
);

    // State encoding
    parameter S0 = 3'b001, S1 = 3'b010, S2 = 3'b100, S3 = 3'b111;

    reg [2:0] current_state, next_state;

    // State memory block
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= S0;
        end else begin
            current_state <= next_state;
        end
    end

    // Next state logic block
    always @(*) begin
        case (current_state)
            S0: if (DIN == 1'b0) next_state = S1;
                else next_state = S0;
            S1: if (DIN == 1'b1) next_state = S2;
                else next_state = S0;
            S2: if (DIN == 1'b0) next_state = S3;
                else next_state = S0;
            S3: if (DIN == 1'b1) next_state = S1;
                else next_state = S0;
            default: next_state = S0;
        endcase
    end

    // Output logic block
    always @(*) begin
        FOUND = (current_state == S3) && (DIN == 1'b1);
    end

endmodule


module tb_sequence_detector;

    reg clk;
    reg reset;
    reg DIN;
    wire FOUND;

    sequence_detector uut (
        .clk(clk),
        .reset(reset),
        .DIN(DIN),
        .FOUND(FOUND)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk; // 10ns clock period
    end

    initial begin
        // Initialize signals
        reset = 1;
        DIN = 0;

        // Apply reset
        #15 reset = 0;

        // Test sequence: 0101 -> FOUND should be asserted
        #10 DIN = 0;
        #10 DIN = 1;
        #10 DIN = 0;
        #10 DIN = 1;
        
        // Add additional test cases as needed
        #10 $stop;
    end

    initial begin
        $monitor("At time %t, DIN = %b, FOUND = %b", $time, DIN, FOUND);
    end

endmodule
