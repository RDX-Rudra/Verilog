module traffic_light_controller (
    input wire CLK,
    input wire RESET,
    input wire CAR,
    input wire TIMEOUT,
    output reg GRN,
    output reg YLW,
    output reg RED
);

    // State encoding
    parameter GREEN = 3'b001, YELLOW = 3'b010, RED = 3'b100;
    
    // State memory
    reg [2:0] current_state, next_state;

    always @(posedge CLK or posedge RESET) begin
        if (RESET)
            current_state <= GREEN; // Default state
        else
            current_state <= next_state;
    end

    // Next state logic
    always @(*) begin
        case (current_state)
            GREEN: begin
                if (CAR)
                    next_state = YELLOW;
                else
                    next_state = GREEN;
            end
            
            YELLOW: begin
                next_state = RED;
            end
            
            RED: begin
                if (TIMEOUT)
                    next_state = GREEN;
                else
                    next_state = RED;
            end
            
            default: next_state = GREEN; // Safety default
        endcase
    end

    // Output logic
    always @(*) begin
        // Default values to avoid latches
        GRN = 0;
        YLW = 0;
        RED = 0;

        case (current_state)
            GREEN: begin
                GRN = 1;
            end
            
            YELLOW: begin
                YLW = 1;
            end
            
            RED: begin
                RED = 1;
            end
        endcase
    end

endmodule

