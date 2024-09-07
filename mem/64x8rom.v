// ROM module
module rom64x8(
    input clk,reset,
    input [5:0] addr,
    output reg [7:0] data
);

// ROM memory
reg [7:0] rom [0:63];


initial begin
    for(integer i=0; i<64; i++) begin
        rom[i] = i;
    end
        
    always @(posedge clk or negedge reset) begin
        if(!reset) begin
            data <= 8'd0;
        end else begin
            data <= rom[addr];
        end
    end
end
endmodule


//TestBench 

module tb_rom_64x8;
    reg clk,reset;
    // Inputs
    reg [5:0] addr;

    // Outputs
    wire [7:0] data;

    // Instantiate the Unit Under Test (UUT)
    rom64x8 dut (
        .addr(addr), 
        .data(data),
        .clk(clk),
        .reset(reset)
    );

    initial begin  
        clk = 1'b0;
        reset = 1'b0;

        // Monitor changes
        $monitor("At time %t, clk=%b, reset=%b, addr = %d, data = %d", $time,clk,reset, addr, data);
        
        // Apply different test cases
            addr = 6'd32;
        #10 addr = 6'd39;
        #10 addr = 6'd42;
            reset = 1'b1;
        #10 addr = 6'd50;
        #10 addr = 6'd61;

        #10 $finish;
    end
    always #5 clk = ~clk;

endmodule