`timescale 1ns / 1ps

/* Enhanced Behavioral design of a simple processor (MU01) */

module mu01 (
    input clk,
    input reset,
    input [15:0] in_port,   // Input port for external data (I/O support)
    output reg [15:0] out_port // Output port for external data (I/O support)
);

    /* Two phases of instruction execution used here */
    localparam FETCH = 1'b0;
    localparam EXEC  = 1'b1;

    /* Extended Instruction Set supported by the processor */
    localparam [3:0] 
        LDA  = 4'b0000, // Load accumulator
        LDAI = 4'b1000, // Load immediate
        STO  = 4'b0001, // Store to memory
        ADD  = 4'b0010, // Add
        ADDI = 4'b1010, // Add immediate
        SUB  = 4'b0011, // Subtract
        SUBI = 4'b1011, // Subtract immediate
        JMP  = 4'b0100, // Unconditional jump
        JGE  = 4'b0101, // Jump if greater or equal to zero
        JNE  = 4'b0110, // Jump if not equal
        STP  = 4'b0111, // Stop processor
        MUL  = 4'b1100, // Multiply
        DIV  = 4'b1101, // Divide
        INC  = 4'b1110, // Increment accumulator
        DEC  = 4'b1111, // Decrement accumulator
        IN   = 4'b0111, // Read from input port
        OUT  = 4'b1001; // Write to output port

    /* cs represents current state, and
     * ns represents the next state */
    reg cs, ns;

    reg [11:0] pc; // 12-bit program counter
    reg [15:0] acc, ir; // 16-bit accumulator and instruction register
    reg [15:0] mem[0:4095]; // 4096 (i.e., 4k) memory locations, each 16-bit in size

    wire [11:0] operand;
    wire [3:0] opcode;
    assign operand = ir[11:0];
    assign opcode  = ir[15:12];

    // Overflow, underflow, zero, and negative flags
    reg overflow, underflow, zero, negative;

    // Sign-extended immediate operand
    wire [15:0] signed_operand;
    assign signed_operand = {{4{operand[11]}}, operand};

    integer i;
    initial begin
        /* Initialize the memory locations before instruction execution starts */
        for (i = 0; i < 4095; i = i + 1) mem[i] = 16'h0000;

        /* Sample program to demonstrate new instructions */
        mem[0] = {LDAI, 12'h7FFF}; // LDAI 7FFFH (largest positive 16-bit number)
        mem[1] = {ADDI, 12'h0001}; // ADDI 0001H (this will cause overflow)
        mem[2] = {STO,  12'hFFF};  // STO  FFFH (store the result to memory)
        mem[3] = {MUL,  12'h0002}; // MUL by 2
        mem[4] = {DIV,  12'h0002}; // DIV by 2
        mem[5] = {IN,   12'h0000}; // Read input from port
        mem[6] = {OUT,  12'h0000}; // Write output to port
        mem[7] = {INC,  12'h0000}; // Increment accumulator
        mem[8] = {DEC,  12'h0000}; // Decrement accumulator
        mem[9] = {STP,  12'h000};  // STP
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cs <= FETCH;
            pc <= 12'h000;
            acc <= 16'h0000;
            overflow <= 0;
            underflow <= 0;
            zero <= 0;
            negative <= 0;
        end else begin
            cs <= ns;
        end
    end

    always @(cs) begin
        case (cs)
            /* Instruction fetch */
            FETCH: begin
                ir <= mem[pc];
                pc <= pc + 1;
                ns <= EXEC;
            end

            /* Instruction decoding, execution, memory access (if needed)
             * and writeback, all is taken care of during this EXEC phase
             * for this simple processor */
            EXEC: begin
                case (opcode)
                    LDA: begin // Load accumulator
                        acc <= mem[operand];
                        zero <= (acc == 0);
                        negative <= (acc[15] == 1);
                        ns <= FETCH;
                    end
                    LDAI: begin // Load accumulator immediate
                        acc <= signed_operand;
                        zero <= (acc == 0);
                        negative <= (acc[15] == 1);
                        ns <= FETCH;
                    end
                    STO: begin // Store to memory
                        mem[operand] <= acc;
                        ns <= FETCH;
                    end
                    ADD: begin // Add
                        {overflow, acc} <= acc + mem[operand];
                        underflow <= 0;
                        zero <= (acc == 0);
                        negative <= (acc[15] == 1);
                        ns <= FETCH;
                    end
                    ADDI: begin // Add immediate
                        {overflow, acc} <= acc + signed_operand;
                        underflow <= 0;
                        zero <= (acc == 0);
                        negative <= (acc[15] == 1);
                        ns <= FETCH;
                    end
                    SUB: begin // Subtract
                        {underflow, acc} <= acc - mem[operand];
                        overflow <= 0;
                        zero <= (acc == 0);
                        negative <= (acc[15] == 1);
                        ns <= FETCH;
                    end
                    SUBI: begin // Subtract immediate
                        {underflow, acc} <= acc - signed_operand;
                        overflow <= 0;
                        zero <= (acc == 0);
                        negative <= (acc[15] == 1);
                        ns <= FETCH;
                    end
                    MUL: begin // Multiply
                        {overflow, acc} <= acc * mem[operand];
                        underflow <= 0;
                        zero <= (acc == 0);
                        negative <= (acc[15] == 1);
                        ns <= FETCH;
                    end
                    DIV: begin // Divide
                        if (mem[operand] != 0) begin
                            acc <= acc / mem[operand];
                            overflow <= 0;
                        end else begin
                            // Error handling for division by zero
                            overflow <= 1;
                        end
                        underflow <= 0;
                        zero <= (acc == 0);
                        negative <= (acc[15] == 1);
                        ns <= FETCH;
                    end
                    INC: begin // Increment accumulator
                        acc <= acc + 1;
                        zero <= (acc == 0);
                        negative <= (acc[15] == 1);
                        ns <= FETCH;
                    end
                    DEC: begin // Decrement accumulator
                        acc <= acc - 1;
                        zero <= (acc == 0);
                        negative <= (acc[15] == 1);
                        ns <= FETCH;
                    end
                    IN: begin // Read from input port
                        acc <= in_port;
                        zero <= (acc == 0);
                        negative <= (acc[15] == 1);
                        ns <= FETCH;
                    end
                    OUT: begin // Write to output port
                        out_port <= acc;
                        ns <= FETCH;
                    end
                    JMP: begin // Unconditional jump
                        pc <= operand;
                        ns <= FETCH;
                    end
                    JGE: begin // Jump if accumulator value greater than or equal to zero
                        if (acc >= 0) begin
                            pc <= operand;
                        end
                        ns <= FETCH;
                    end
                    JNE: begin // Jump if accumulator value not equal to zero
                        if (acc != 0) begin
                            pc <= operand;
                        end
                        ns <= FETCH;
                    end
                    STP: begin // Halt processor
                        ns <= EXEC; // stay in EXEC state
                    end
                    default: begin // Any unknown instruction will halt the processor
                        ns <= EXEC; // stay in EXEC state
                    end
                endcase // case (opcode)
            end
        endcase // case (cs)
    end
endmodule // mu01

module mu01_tg (output reg clk, reset);

    initial begin
        $monitor($time,,,"cs=%b: operand=%b opcode=%b acc=%b pc=%b mem[FFF]=%h overflow=%b underflow=%b zero=%b negative=%b",
            t_mu01.cs, t_mu01.operand, t_mu01.opcode,
            t_mu01.acc, t_mu01.pc, t_mu01.mem[12'hFFF],
            t_mu01.overflow, t_mu01.underflow, t_mu01.zero, t_mu01.negative);
        
        #0 reset = 1'b1; clk = 1'b0;
        #8 reset = 1'b0; // De-assert reset after some time
        #600 $finish;
    end

    always #5 clk = ~clk; // Toggle clock every 5 ns

    mu01 t_mu01 (clk, reset);

endmodule // mu01_tg
