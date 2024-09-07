module ram64x8 (
    input wire clk,reset,       // Clock input
    input wire rw,         // Write enable
    input wire [5:0] addr, // Address input (6 bits to address 64 locations)
    input wire [7:0] din,  // Data input (8 bits)
    output reg [7:0] dout  // Data output (8 bits)
);

    // Declare the RAM array (64 locations of 8-bit width each)
    reg [7:0] ram [63:0];

    // Process to handle read and write operations
    always @(negedge clk or negedge reset) begin
        if(!reset) begin
            dout <= 8'd0;
        end else begin
            if (rw) begin
                // Write operation
                ram[addr] <= din;
                dout <= 0;
            end else begin
            // Read operation
                dout <= ram[addr];
            end
        end
    end

endmodule

module ram_fsm(
    input wire clk,reset,   // Clock input
    output reg rw,         // Write enable
    output reg [5:0] addr,
    output reg [7:0] din // Address input (6 bits to address 64 locations)
);


    // State encoding using parametersvfg
    parameter Writeat35= 0, Readat35 = 1, Writeat39 = 2, Readat39 = 3 ;

    // State variables
    reg [1:0] current_state, next_state;

    // State transition logic (combinational block)
    always @(*) begin
        case (current_state)
            Writeat35:begin
                rw = 1;
                addr = 8'd35;
                din = 8'hFF;
                next_state = Readat35;
            end
            
            Readat35:begin
                rw = 0;
                addr = 8'd35;
                next_state = Writeat39;
            end

            Writeat39:begin
                rw = 1;
                addr = 8'd39;
                din = 8'hAA;
                next_state = Readat39;
            end

            Readat39:begin
                rw = 0;
                addr = 8'd39;
                next_state = Writeat35;
            end
            // default:begin
            //     next_state = Writeat35;
            // end
                
        endcase
    end

    // State register update (sequential block)
    always @(posedge clk or negedge reset) begin
        if (!reset)
            current_state <= Writeat35;
        else
            current_state <= next_state;
    end
endmodule


module tb_ram64x8();

    reg clk;
    reg reset;
    wire rw;
    wire [5:0] addr;
    wire [7:0] din;
    wire [7:0] dout;

    // Instantiate the RAM and FSM modules

    ram_fsm fsm (
        .clk(clk),
        .reset(reset),//input
        .rw(rw),
        .din(din),
        .addr(addr)
    );


    ram64x8 dut (
        .clk(clk),//input
        .reset(reset),//input
        .rw(rw),
        .addr(addr),
        .din(din),
        .dout(dout)
    );

    // Clock generation
    initial begin
        clk = 0;
        reset = 0;
        $monitor("Time = %t, reset = %b,clk=%b rw = %b, addr = %d, din = %d, dout = %d fsm %d -> %d", $time, reset, clk, rw, addr, din, dout, fsm.current_state ,fsm.next_state );
        // Initialize signals
        #10  reset = 1;
        #50;
        $finish;
    end

    always #5 clk = ~clk;
endmodule
