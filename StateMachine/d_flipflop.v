module d_flip_flop (
    input wire clk,
    input wire reset,
    input wire d,
    output reg q
);

    // Define the states
    typedef enum reg [1:0] {
        STATE_0 = 2'b00,  // State representing q=0
        STATE_1 = 2'b01   // State representing q=1
    } state_t;

    // Declare the current state and next state variables
    state_t current_state, next_state;

    // Sequential block for state transitions
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            current_state <= STATE_0;  // Reset state to STATE_0
        end else begin
            current_state <= next_state;  // Transition to next state
        end
    end

    // Combinational block for next state logic
    always @(*) begin
        case (current_state)
            STATE_0: begin
                if (d)
                    next_state = STATE_1;
                else
                    next_state = STATE_0;
            end

            STATE_1: begin
                if (d)
                    next_state = STATE_1;
                else
                    next_state = STATE_0;
            end

            default: begin
                next_state = STATE_0;
            end
        endcase
    end

    // Output logic
    always @(*) begin
        case (current_state)
            STATE_0: q = 1'b0;
            STATE_1: q = 1'b1;
            default: q = 1'b0;
        endcase
    end

endmodule
