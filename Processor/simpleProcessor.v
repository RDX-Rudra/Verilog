`timescale 1ns / 1ps /* this directive indicates that all numbers used for delay have a unit of nanoseconds */

/* ----------------------------------------------
 * Behavioral design of a simple processor (MU01)
 * for classroom teaching
 * ----------------------------------------------
 * Author: Santanu Chatterjee, Dept. of CSE, MAKAUT,WB
 */

module mu01
  (input clk, reset);

   /* Two phases of instruction execution used here */
   localparam
             FETCH = 1'b0,
             EXEC  = 1'b1;

   /* Instruction Set supported by the processor,
    * Mnemonic, and the corresponding opcode */
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

   /* cs represents current state, and
    * ns represents the next state */
   reg              cs, ns;

   reg [11:0]       pc; // 12 bit program counter
   reg [15:0]       acc, ir; // 16 bit accumulator and instruction register
   reg [15:0]       mem[0:4095]; // 4096 (i.e., 4k) memory locations, each 16 bit in size

   wire [11:0]      operand;
   wire [3:0]       opcode;
   assign operand = ir[11:0];
   assign opcode  = ir[15:12];

   integer          i;
   initial begin
      /* initialize the memory locations before instruction execution starts */
      for(i=0; i<4095; i=i+1) mem[i] = 16'h0000;
      
      /* Write the program into memory here (in opcodes of course) */
      
      /* NOTE: This is the area which you might need to replace with
       * your own assembly program if you are asked to write your own
       * assembly program for this processor to do any specific task.
       * The simple example shown here is just a 4 line assembly code
       * to give you an idea how it is done here. Even though it is an
       * example, it should run without problems. STP is basically a 
       * HALT instruction for the processor. Rest of the opcodes should 
       * be easily understandable from their associated mnemonics. 
       * For example, LDAI is LoaD Accumulator Immediate, STO is STOre, 
       * etc.*/

      /* start of program */
      mem[0] = {LDAI, 12'h005}; // LDAI 005H
      mem[1] = {ADDI, 12'h004}; // ADDI 004H
      mem[2] = {STO,  12'hfff}; // STO  FFFH
      mem[3] = {STP,  12'h000}; // STP
      /* end of program */
      
   end

   /* The rest of the code in this module would be easy to 
    * understand if you remember how state machines are 
    * written in Verilog. That part is clearly explained in
    * the textbook by Moorby */
   
   always @(posedge clk, posedge reset) begin
      if (reset) begin 
	 cs<=FETCH;
	 pc<=12'h000;
	 acc<=16'h0000;
      end
      else
	cs<=ns;
   end

   always @(cs)
     case (cs)
       
       /* instruction fetch */
       FETCH: begin
	  ir=mem[pc];
	  pc=pc+1;
	  ns=EXEC;
       end

       /* instruction decoding, execution, memory access (if needed)
	* and writeback, all is taken care of during this EXEC phase
	* for this simple processor */
       EXEC:
	 case (opcode)
	   LDA: begin // load accumulator
	      acc=mem[operand];
	      ns=FETCH;
	   end
	   LDAI: begin // load accumulator immediate
	      /* since accumulator is 16 bits and operand is 12 bits,
	       * what we are doing here is zero extending the operand 
	       * value with leading zeros. NOTE: If you are asked to sign extend 
	       * the value from the operand, you need to change this 
	       * part of the code to make that happen */
	      acc={4'b0000, operand};
	      ns=FETCH;
	   end
	   STO: begin // store to memory
	      mem[operand]=acc;
	      ns=FETCH;
	   end
	   ADD: begin // add
	      acc=acc+mem[operand];
	      ns=FETCH;
	   end
	   ADDI: begin // add immediate
	      acc=acc+operand;
	      ns=FETCH;
	   end
	   SUB: begin // subtract
	      acc=acc-mem[operand];
	      ns=FETCH;
	   end
	   SUBI: begin // subtract immediate
	      acc=acc-operand;
	      ns=FETCH;
	   end
	   JMP: begin // unconditional jump
	      pc=operand;
	      ns=FETCH;
	   end
	   JGE: begin // jump if accumulator value greater than or equal to zero
	      pc=(acc>=0)?operand:pc;
	      ns=FETCH;
	   end
	   JNE: begin // jump if accumulator value not equal to zero
	      pc=(acc!=0)?operand:pc;
	      ns=FETCH;
	   end
	   STP: begin // halt procesor
	      ir={STP, 12'h000};
	      ns=EXEC;
	   end
	   default: begin // any unknown instruction will halt the processor
	      ir={STP, 12'h000};
	      ns=EXEC;
	   end
	 endcase // case (opcode)
     endcase // case (cs)
endmodule // mu01


module mu01_tg   // test generator
  (output reg clk, reset);

   initial begin
      $monitor($time,,,"cs=%b: operand=%b opcode=%b acc=%b pc=%b mem[FFF]=%h",
	       t_mu01.cs, t_mu01.operand, t_mu01.opcode,
	       t_mu01.acc, t_mu01.pc, t_mu01.mem[12'hfff]);
      clk=1'b0; 
      reset=1'b1;
      #4 reset=1'b0;
      #30 $finish;
   end

   always #1 clk=~clk;
endmodule // mu01_tg


module mu01_wb; // work bench
   wire clk, reset;

   mu01     t_mu01(clk, reset);
   mu01_tg  tg(clk, reset);
endmodule // mu01_wb

