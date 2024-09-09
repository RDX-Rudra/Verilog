module vending_machine (
    input wire clk,
    input wire reset,
    input wire Nin,
    input wire Din,
    output reg Dispense,
    output reg Change
);

    // State Encoding
    parameter S0 = 3'b000; // 0¢
    parameter S5 = 3'b001; // 5¢
    parameter S10 = 3'b010; // 10¢
    parameter S15 = 3'b011; // 15¢
    parameter S20 = 3'b100; // 20¢ or more

    reg [2:0] current_state, next_state;

    // State Transition Block
    always @(current_state, Nin, Din) begin
        case (current_state)
            S0: begin
                if (Nin) next_state = S5;
                else if (Din) next_state = S10;
                else next_state = S0;
            end
            S5: begin
                if (Nin) next_state = S10;
                else if (Din) next_state = S15;
                else next_state = S5;
            end
            S10: begin
                if (Nin) next_state = S15;
                else if (Din) next_state = S20;
                else next_state = S10;
            end
            S15: begin
                if (Nin) next_state = S20;
                else if (Din) next_state = S20; // move to S20 but will give change
                else next_state = S15;
            end
            S20: begin
                if (Nin || Din) next_state = S0; // reset to initial state after dispensing
                else next_state = S20;
            end
            default: next_state = S0;
        endcase
    end

    // State Memory Block
    always @(posedge clk or posedge reset) begin
        if (reset)
            current_state <= S0;
        else
            current_state <= next_state;
    end

    // Output Logic Block
    always @(current_state) begin
        Dispense = 0;
        Change = 0;
        case (current_state)
            S20: begin
                Dispense = 1;
                if (next_state == S0) Change = 1; // if state moves to initial state give change
            end
        endcase
    end
endmodule

module tb_vending_machine;
    reg clk;
    reg reset;
    reg Nin;
    reg Din;
    wire Dispense;
    wire Change;

    vending_machine uut (
        .clk(clk),
        .reset(reset),
        .Nin(Nin),
        .Din(Din),
        .Dispense(Dispense),
        .Change(Change)
    );

    initial begin
        // Initialize signals
        clk = 0;
        reset = 0;
        Nin = 0;
        Din = 0;

        // Apply reset
        reset = 1;
        #10;
        reset = 0;

        // Test sequence
        #10; Nin = 1; #10; Nin = 0; // Insert nickel
        #10; Nin = 1; #10; Nin = 0; // Insert another nickel
        #10; Din = 1; #10; Din = 0; // Insert dime
        #10; Din = 1; #10; Din = 0; // Insert another dime

        #10; $finish;
    end

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $monitor("At time %t, Nin = %b, Din = %b, Dispense = %b, Change = %b",
                 $time, Nin, Din, Dispense, Change);
    end
endmodule

