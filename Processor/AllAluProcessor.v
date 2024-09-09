`timescale 1ns / 1ps

module mu01
  (input clk, reset);

   localparam
             FETCH = 1'b0,
             EXEC  = 1'b1;

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
                    STP  = 4'b0111,
                    MUL  = 4'b1001, // New opcode for multiplication
                    DIV  = 4'b1010, // New opcode for division
                    SHL  = 4'b1100, // New opcode for left shift
                    SHR  = 4'b1101, // New opcode for right shift
                    AND  = 4'b1110, // New opcode for AND
                    OR   = 4'b1111, // New opcode for OR
                    XOR  = 4'b0000; // New opcode for XOR

   reg              cs, ns;
   reg [11:0]       pc; // 12-bit program counter
   reg [15:0]       acc, ir; // 16-bit accumulator and instruction register
   reg [15:0]       mem[0:4095]; // 4096 (4K) memory locations, each 16-bit in size
   reg              overflow, underflow; // Flags for overflow and underflow

   wire [11:0]      operand;
   wire [3:0]       opcode;
   assign operand = ir[11:0];
   assign opcode  = ir[15:12];

   integer i;
   initial begin
      // Initialize memory locations before instruction execution starts
      for(i=0; i<4095; i=i+1) mem[i] = 16'h0000;
      
      // Programs for various operations
      // Subtraction: 5 - 3
      mem[0] = {LDAI, 12'h005}; // LDAI 005H
      mem[1] = {SUBI, 12'h003}; // SUBI 003H
      mem[2] = {STO,  12'hFFF}; // STO  FFFH
      mem[3] = {STP,  12'h000}; // STP
      
      // Multiplication: 3 * 2
      mem[4] = {LDAI, 12'h003}; // LDAI 003H
      mem[5] = {STO,  12'hFFE}; // STO  FFEH
      mem[6] = {LDAI, 12'h000}; // LDAI 000H
      mem[7] = {MUL,  12'hFFE}; // MUL  FFEH
      mem[8] = {STO,  12'hFFF}; // STO  FFFH
      mem[9] = {STP,  12'h000}; // STP

      // Division: 6 / 2
      mem[10] = {LDAI, 12'h006}; // LDAI 006H
      mem[11] = {STO,  12'hFFD}; // STO  FFDH
      mem[12] = {LDAI, 12'h002}; // LDAI 002H
      mem[13] = {DIV,  12'hFFD}; // DIV  FFDH
      mem[14] = {STO,  12'hFFF}; // STO  FFFH
      mem[15] = {STP,  12'h000}; // STP

      // Left Shift: Shift 1 left by 2 positions
      mem[16] = {LDAI, 12'h0001}; // LDAI 0001H
      mem[17] = {STO,  12'hFFE}; // STO  FFEH
      mem[18] = {LDAI, 12'h0002}; // LDAI 0002H
      mem[19] = {SHL,  12'hFFE}; // SHL  FFEH
      mem[20] = {STO,  12'hFFF}; // STO  FFFH
      mem[21] = {STP,  12'h000}; // STP

      // Right Shift: Shift 4 right by 1 position
      mem[22] = {LDAI, 12'h0004}; // LDAI 0004H
      mem[23] = {STO,  12'hFFE}; // STO  FFEH
      mem[24] = {LDAI, 12'h0001}; // LDAI 0001H
      mem[25] = {SHR,  12'hFFE}; // SHR  FFEH
      mem[26] = {STO,  12'hFFF}; // STO  FFFH
      mem[27] = {STP,  12'h000}; // STP

      // AND: 6 AND 3
      mem[28] = {LDAI, 12'h006}; // LDAI 006H
      mem[29] = {STO,  12'hFFE}; // STO  FFEH
      mem[30] = {LDAI, 12'h003}; // LDAI 003H
      mem[31] = {AND,  12'hFFE}; // AND  FFEH
      mem[32] = {STO,  12'hFFF}; // STO  FFFH
      mem[33] = {STP,  12'h000}; // STP

      // OR: 6 OR 3
      mem[34] = {LDAI, 12'h006}; // LDAI 006H
      mem[35] = {STO,  12'hFFE}; // STO  FFEH
      mem[36] = {LDAI, 12'h003}; // LDAI 003H
      mem[37] = {OR,   12'hFFE}; // OR   FFEH
      mem[38] = {STO,  12'hFFF}; // STO  FFFH
      mem[39] = {STP,  12'h000}; // STP

      // XOR: 6 XOR 3
      mem[40] = {LDAI, 12'h006}; // LDAI 006H
      mem[41] = {STO,  12'hFFE}; // STO  FFEH
      mem[42] = {LDAI, 12'h003}; // LDAI 003H
      mem[43] = {XOR,  12'hFFE}; // XOR  FFEH
      mem[44] = {STO,  12'hFFF}; // STO  FFFH
      mem[45] = {STP,  12'h000}; // STP
   end

   always @(posedge clk, posedge reset) begin
      if (reset) begin 
         cs <= FETCH;
         pc <= 12'h000;
         acc <= 16'h0000;
         overflow <= 1'b0;
         underflow <= 1'b0;
      end
      else
         cs <= ns;
   end

   always @(cs)
     case (cs)
       FETCH: begin
          ir = mem[pc];
          pc = pc + 1;
          ns = EXEC;
       end

       EXEC:
         case (opcode)
           LDA: begin
              acc = mem[operand];
              ns = FETCH;
           end
           LDAI: begin
              acc = {4'b0000, operand};
              ns = FETCH;
           end
           STO: begin
              mem[operand] = acc;
              ns = FETCH;
           end
           ADD: begin
              {overflow, acc} = acc + mem[operand]; // Check overflow
              ns = FETCH;
           end
           ADDI: begin
              {overflow, acc} = acc + operand; // Check overflow
              ns = FETCH;
           end
           SUB: begin
              {underflow, acc} = acc - mem[operand]; // Check underflow
              ns = FETCH;
           end
           SUBI: begin
              {underflow, acc} = acc - operand; // Check underflow
              ns = FETCH;
           end
           MUL: begin
              acc = acc * mem[operand];
              ns = FETCH;
           end
           DIV: begin
              if (mem[operand] != 0) begin
                 acc = acc / mem[operand];
              end
              else begin
                 // Division by zero handling
                 acc = 16'hFFFF;
              end
              ns = FETCH;
           end
           SHL: begin
              acc = acc << operand;
              ns = FETCH;
           end
           SHR: begin
              acc = acc >> operand;
              ns = FETCH;
           end
           AND: begin
              acc = acc & mem[operand];
              ns = FETCH;
           end
           OR: begin
              acc = acc | mem[operand];
              ns = FETCH;
           end
           XOR: begin
              acc = acc ^ mem[operand];
              ns = FETCH;
           end
           JMP: begin
              pc = operand;
              ns = FETCH;
           end
           JGE: begin
              pc = (acc >= 0) ? operand : pc;
              ns = FETCH;
           end
           JNE: begin
              pc = (acc != 0) ? operand : pc;
              ns = FETCH;
           end
           STP: begin
              ns = EXEC;
           end
           default: begin
              ns = EXEC;
           end
         endcase
     endcase
endmodule

module mu01_tg   // test generator
  (output reg clk, reset);

   initial begin
      $monitor($time,,,"cs=%b: operand=%b opcode=%b acc=%b pc=%b mem[FFF]=%h",
	       t_mu01.cs, t_mu01.operand, t_mu01.opcode,
	       t_mu01.acc, t_mu01.pc, t_mu01.mem[12'hfff]);
      clk = 1'b0; 
      reset = 1'b1;
      #4 reset = 1'b0;
      #30 $finish;
   end

   always #1 clk = ~clk;
endmodule

module mu01_wb; // work bench
   wire clk, reset;

   mu01     t_mu01(clk, reset);
   mu01_tg  tg(clk, reset);
endmodule
