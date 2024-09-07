`timescale 1ns / 1ps

module mu01 (
    input clk,
    input reset
);

    localparam FETCH = 1'b0;
    localparam EXEC  = 1'b1;

    localparam [3:0] 
        LDA  = 4'b0000,
        LDAI = 4'b1000,
        STO  = 4'b0001,
        ADD  = 4'b0010,
        ADDI = 4'b1010,
        SUB  = 4'b0011,
        SUBI = 4'b1011,
        JMP  = 4'b0100,
        JGE  = 4'b0101,
        JNE  = 4'b0110,
        STP  = 4'b0111;

    reg cs, ns;
    reg [11:0] pc;
    reg [15:0] acc, ir;
    reg [15:0] mem[0:4095];

    wire [11:0] operand;
    wire [3:0] opcode;
    assign operand = ir[11:0];
    assign opcode  = ir[15:12];

    reg overflow, underflow;

    wire [15:0] signed_operand;
    assign signed_operand = {{4{operand[11]}}, operand};

    integer i;
    initial begin
        for (i = 0; i < 4095; i = i + 1) mem[i] = 16'h0000;

        mem[0] = {LDAI, 12'h7FFF}; 
        mem[1] = {ADDI, 12'h0001}; 
        mem[2] = {STO,  12'hFFF};  
        mem[3] = {STP,  12'h000};  
        mem[4] = {LDAI, 12'h8000}; 
        mem[5] = {SUBI, 12'h0001}; 
        mem[6] = {STO,  12'hFFF};  
        mem[7] = {STP,  12'h000};  
    end

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            cs <= FETCH;
            pc <= 12'h000;
            acc <= 16'h0000;
            overflow <= 0;
            underflow <= 0;
        end else begin
            cs <= ns;
        end
    end

    always @(posedge clk) begin
        if (!reset) begin
            case (cs)
                FETCH: begin
                    ir <= mem[pc];
                    pc <= pc + 1;
                end
                EXEC: begin
                    case (opcode)
                        LDA: begin
                            acc <= mem[operand];
                        end
                        LDAI: begin
                            acc <= {{4{operand[11]}}, operand};
                        end
                        STO: begin
                            mem[operand] <= acc;
                        end
                        ADD: begin
                            {overflow, acc} <= acc + mem[operand];
                            underflow <= 0;
                        end
                        ADDI: begin
                            {overflow, acc} <= acc + signed_operand;
                            underflow <= 0;
                        end
                        SUB: begin
                            {underflow, acc} <= acc - mem[operand];
                            overflow <= 0;
                        end
                        SUBI: begin
                            {underflow, acc} <= acc - signed_operand;
                            overflow <= 0;
                        end
                        JMP: begin
                            pc <= operand;
                        end
                        JGE: begin
                            if (acc >= 0) begin
                                pc <= operand;
                            end
                        end
                        JNE: begin
                            if (acc != 0) begin
                                pc <= operand;
                            end
                        end
                        STP: begin
                            ns <= EXEC; 
                        end
                        default: begin
                            ns <= EXEC; 
                        end
                    endcase
                end
            endcase
        end
    end

    always @(cs) begin
        case (cs)
            FETCH: ns = EXEC;
            EXEC: ns = FETCH;
        endcase
    end
endmodule 

module mu01_tg (output reg clk, reset);

    initial begin
        $monitor($time,,,"cs=%b: operand=%b opcode=%b acc=%b pc=%b mem[FFF]=%h overflow=%b underflow=%b",
            t_mu01.cs, t_mu01.operand, t_mu01.opcode,
            t_mu01.acc, t_mu01.pc, t_mu01.mem[12'hfff], t_mu01.overflow, t_mu01.underflow);
        clk = 1'b0; 
        reset = 1'b1;
        #4 reset = 1'b0;
        #30 $finish;
    end

    always #1 clk = ~clk;
endmodule 

module mu01_wb;
    wire clk, reset;

    mu01 t_mu01(clk, reset);
    mu01_tg tg(clk, reset);
endmodule