module fulladder1b(a,b,c_in,s,c_out);
	input a,b,c_in;
	output s,c_out;
	assign s = a^b^c_in;
	assign c_out = (a & b) | (b & c_in) | (c_in & a);
endmodule

module comptwo(x,negx);
input [7:0] x;
output [7:0] negx;
assign negx = (~x) + 1;
endmodule

module sub8b(x,y,c_in,d,b_out);
	input [7:0] x,y;
	input c_in;
	output [7:0] d;
	output b_out;
	wire [7:0] c_wire;
	wire [7:0] y_n;
	comptwo neg0 (y,y_n);
	fulladder1b b0 (x[0],y_n[0],c_in,d[0],c_wire[0]);
	fulladder1b b1 (x[1],y_n[1],c_wire[0],d[1],c_wire[1]);
	fulladder1b b2 (x[2],y_n[2],c_wire[1],d[2],c_wire[2]);
	fulladder1b b3 (x[3],y_n[3],c_wire[2],d[3],c_wire[3]);
	fulladder1b b4 (x[3],y_n[3],c_wire[2],d[3],c_wire[3]);
	fulladder1b b5 (x[4],y_n[4],c_wire[3],d[4],c_wire[4]);
	fulladder1b b6 (x[5],y_n[5],c_wire[4],d[5],c_wire[5]);
	fulladder1b b7 (x[6],y_n[6],c_wire[5],d[6],c_wire[6]);
	fulladder1b b8 (x[7],y_n[7],c_wire[6],d[7],c_wire[7]);
	assign b_out = (~c_wire[7]);
endmodule
module add8b(x,y,c_in,s,c_out);
	input [7:0] x,y;
	input c_in;
	output [7:0] s;
	output c_out;
	wire [6:0] c_wire;
	
	fulladder1b b0 (x[0],y[0],c_in,s[0],c_wire[0]);
	fulladder1b b1 (x[1],y[1],c_wire[0],s[1],c_wire[1]);
	fulladder1b b2 (x[2],y[2],c_wire[1],s[2],c_wire[2]);
	fulladder1b b3 (x[3],y[3],c_wire[2],s[3],c_wire[3]);
	fulladder1b b4 (x[3],y[3],c_wire[2],s[3],c_wire[3]);
	fulladder1b b5 (x[4],y[4],c_wire[3],s[4],c_wire[4]);
	fulladder1b b6 (x[5],y[5],c_wire[4],s[5],c_wire[5]);
	fulladder1b b7 (x[6],y[6],c_wire[5],s[6],c_wire[6]);
	fulladder1b b8 (x[7],y[7],c_wire[6],s[7],c_out);
	
endmodule

module and8b(x,y,andout);
input [7:0] x,y;

output [7:0] andout;
assign andout = x&y;

endmodule

module or8b(x,y,orout);
input [7:0] x,y;

output [7:0] orout;
assign orout = x|y;

endmodule

module nand8b(x,y,nandout);
input [7:0] x,y;
output [7:0] nandout;
assign nandout = ~(x&y);
endmodule

module xor8b(x,y,xorout);
input [7:0] x,y;
output [7:0] xorout;
assign xorout = x^y;
endmodule

 module nor8b(x,y,norout);
input [7:0] x,y;
output [7:0] norout;
assign norout = ~(x|y);
endmodule

module not8b(x,y,notout);
input [7:0] x,y;
output [7:0] notout;
assign notout = ~x;
endmodule

module and8b1(x,y,andout);
input [7:0] x,y;
output [7:0] andout;
wire [7:0] y_n;
comptwo neg1 (y,y_n);
assign andout = x&y_n;

endmodule

module or8b1(x,y,orout);
input [7:0] x,y;
output [7:0] orout;
wire [7:0] y_n;
comptwo neg1 (y,y_n);
assign orout = x|y_n;

endmodule

module nand8b1(x,y,nandout);
input [7:0] x,y;
output [7:0] nandout;
wire [7:0] y_n;
comptwo neg1 (y,y_n);
assign nandout = ~(x&y_n);
endmodule

module xor8b1(x,y,xorout);
input [7:0] x,y;
output [7:0] xorout;
wire [7:0] y_n;
comptwo neg1 (y,y_n);
assign xorout = x^y_n;
endmodule

module nor8b1(x,y,norout);
input [7:0] x,y;
output [7:0] norout;
wire [7:0] y_n;
comptwo neg1 (y,y_n);
assign norout = ~(x|y_n);
endmodule

module not8b1(x,y,notout);
input [7:0] x,y;
output [7:0] notout;
assign notout = ~y;
endmodule 

module sub8b1(x,y,c_in1,d1,c_out1);
input [7:0] x,y;
input c_in1;
output [7:0] d1;
output c_out1;
add8b add1 (x,y,c_in1,d1,c_out1);
endmodule

module add8b1(x,y,c_in1,s1,c_out1);
input [7:0] x,y;
input c_in1;
output [7:0] s1;
output c_out1;
sub8b sub1 (x,y,c_in1,s1,c_out1);
endmodule

module mux1b16to1 (
    input add_r,sub_r,and_r,or_r,nand_r,xor_r,nor_r,not_r,add_r1,sub_r1,and_r1,or_r1,nand_r1,xor_r1,nor_r1,not_r1,
    input [3:0] cntrl,
    output out
);

    wire o0,o1,o2,o3,o4,o5,o6,o7,o8,o9,o10,o11,o12,o13,o14,o15;

	assign o0  = ((~cntrl[3])&(~cntrl[2])&(~cntrl[1])&(~cntrl[0]))&(add_r);
	assign o1  = ((~cntrl[3])&(~cntrl[2])&(~cntrl[1])&(cntrl[0]))&(sub_r);
	assign o2  = ((~cntrl[3])&(~cntrl[2])&(cntrl[1])&(~cntrl[0]))&(and_r);
	assign o3  = ((~cntrl[3])&(~cntrl[2])&(cntrl[1])&(cntrl[0]))&(or_r);
    assign o4  = ((~cntrl[3])&(cntrl[2])&(~cntrl[1])&(~cntrl[0]))&(nand_r);
	assign o5  = ((~cntrl[3])&(cntrl[2])&(~cntrl[1])&(cntrl[0]))&(xor_r);
	assign o6  = ((~cntrl[3])&(cntrl[2])&(cntrl[1])&(~cntrl[0]))&(nor_r);
	assign o7  = ((~cntrl[3])&(cntrl[2])&(cntrl[1])&(cntrl[0]))&(not_r);
    assign o8  = ((cntrl[3])&(~cntrl[2])&(~cntrl[1])&(~cntrl[0]))&(add_r1);
	assign o9  = ((cntrl[3])&(~cntrl[2])&(~cntrl[1])&(cntrl[0]))&(sub_r1);
	assign o10 = ((cntrl[3])&(~cntrl[2])&(cntrl[1])&(~cntrl[0]))&(and_r1);
	assign o11 = ((cntrl[3])&(~cntrl[2])&(cntrl[1])&(cntrl[0]))&(or_r1);
    assign o12 = ((cntrl[3])&(cntrl[2])&(~cntrl[1])&(~cntrl[0]))&(nand_r1);
	assign o13 = ((cntrl[3])&(cntrl[2])&(~cntrl[1])&(cntrl[0]))&(xor_r1);
	assign o14 = ((cntrl[3])&(cntrl[2])&(cntrl[1])&(~cntrl[0]))&(nor_r1);
	assign o15 = ((cntrl[3])&(cntrl[2])&(cntrl[1])&(cntrl[0]))&(not_r1);

    assign out = o0|o1|o2|o3|o4|o5|o6|o7|o8|o9|o10|o11|o11|o12|o13|o14|o15;

endmodule

module carrymux1b4to1(
    input add_c,sub_c,add_c1,sub_c1,
	input [3:0] cntrl,
    output carry
);
    wire p,q,r,s;

	assign p = ((~cntrl[3])&(~cntrl[0]))&add_c;
	assign q = ((~cntrl[3])&cntrl[0])&sub_c;
	assign r = (cntrl[3]&(~cntrl[0]))&add_c1;
	assign s = (cntrl[3]&cntrl[0])&sub_c1;

	assign carry = p|q|r|s;
endmodule

module alu(x,y,cntrl,out,carry);
input [7:0] x,y;
input [3:0] cntrl;
output [7:0] out;
output carry;
wire [7:0] add_r,sub_r,and_r,or_r,nand_r,xor_r,nor_r,not_r,add_r1,sub_r1,and_r1,or_r1,nand_r1,xor_r1,nor_r1,not_r1;
wire add_c,sub_c,add_c1,sub_c1;
add8b addres (x,y,1'b0,add_r,add_c);
sub8b subres (x,y,1'b0,sub_r,sub_c);
and8b andres (x,y,and_r);
or8b orres (x,y,or_r);
nand8b nandres (x,y,nand_r);
xor8b xorres (x,y,xor_r);
nor8b norres (x,y,nor_r);
not8b notres (x,y,not_r);
add8b1 add1 (x,y,1'b0,add_r1,add_c1);
sub8b1 sub1 (x,y,1'b0,sub_r1,sub_c1);
and8b1 and1 (x,y,and_r1);
or8b1 or1 (x,y,or_r1);
nand8b1 nand1 (x,y,nand_r1);
xor8b1 xor1 (x,y,xor_r1);
nor8b1 nor1 (x,y,nor_r1);
not8b1 not1 (x,y,not_r1);

    mux1b16to1 res0 (add_r[0],sub_r[0],and_r[0],or_r[0],nand_r[0],xor_r[0],nor_r[0],not_r[0],add_r1[0],sub_r1[0],and_r1[0],or_r1[0],nand_r1[0],xor_r1[0],nor_r1[0],not_r1[0],cntrl,out[0]);
    mux1b16to1 res1 (add_r[1],sub_r[1],and_r[1],or_r[1],nand_r[1],xor_r[1],nor_r[1],not_r[1],add_r1[1],sub_r1[1],and_r1[1],or_r1[1],nand_r1[1],xor_r1[1],nor_r1[1],not_r1[1],cntrl,out[1]);
    mux1b16to1 res2 (add_r[2],sub_r[2],and_r[2],or_r[2],nand_r[2],xor_r[2],nor_r[2],not_r[2],add_r1[2],sub_r1[2],and_r1[2],or_r1[2],nand_r1[2],xor_r1[2],nor_r1[2],not_r1[2],cntrl,out[2]);
    mux1b16to1 res3 (add_r[3],sub_r[3],and_r[3],or_r[3],nand_r[3],xor_r[3],nor_r[3],not_r[3],add_r1[3],sub_r1[3],and_r1[3],or_r1[3],nand_r1[3],xor_r1[3],nor_r1[3],not_r1[3],cntrl,out[3]);
    mux1b16to1 res4 (add_r[4],sub_r[4],and_r[4],or_r[4],nand_r[4],xor_r[4],nor_r[4],not_r[4],add_r1[4],sub_r1[4],and_r1[4],or_r1[4],nand_r1[4],xor_r1[4],nor_r1[4],not_r1[4],cntrl,out[4]);
    mux1b16to1 res5 (add_r[5],sub_r[5],and_r[5],or_r[5],nand_r[5],xor_r[5],nor_r[5],not_r[5],add_r1[5],sub_r1[5],and_r1[5],or_r1[5],nand_r1[5],xor_r1[5],nor_r1[5],not_r1[5],cntrl,out[5]);
    mux1b16to1 res6 (add_r[6],sub_r[6],and_r[6],or_r[6],nand_r[6],xor_r[6],nor_r[6],not_r[6],add_r1[6],sub_r1[6],and_r1[6],or_r1[6],nand_r1[6],xor_r1[6],nor_r1[6],not_r1[6],cntrl,out[6]);
    mux1b16to1 res7 (add_r[7],sub_r[7],and_r[7],or_r[7],nand_r[7],xor_r[7],nor_r[7],not_r[7],add_r1[7],sub_r1[7],and_r1[7],or_r1[7],nand_r1[7],xor_r1[7],nor_r1[7],not_r1[7],cntrl,out[7]);
    
    carrymux1b4to1 carrym (add_c,sub_c,add_c1,sub_c1,cntrl,carry);

endmodule

module testbench(
	output reg [7:0] x,y,
	output reg [3:0] cntrl,
	input wire [7:0] out,
	input wire carry
);
	initial
		begin
			$monitor ($time, " x=%b, y=%b, control_input= %b, output=%b, carry=%b", x,y,cntrl,out,carry);
			x=8'b01001111; y=8'b10100101; cntrl=4'b0000;
			#5 cntrl = 4'b0001;
			#5 cntrl = 4'b0010;
			#5 cntrl = 4'b0011;
			#5 cntrl = 4'b0100;
			#5 cntrl = 4'b0101;
			#5 cntrl = 4'b0110;
			#5 cntrl = 4'b0111;
			#5 cntrl = 4'b1000;
			#5 cntrl = 4'b1001;
			#5 cntrl = 4'b1010;
			#5 cntrl = 4'b1011;
			#5 cntrl = 4'b1100;
			#5 cntrl = 4'b1101;
			#5 cntrl = 4'b1110;
			#5 cntrl = 4'b1111;
			#5 $finish;
		end
endmodule

module workbench;
	wire [7:0] x,y;
	wire [3:0] cntrl;
	wire [7:0] out;
	wire carry;
    
    initial begin
        $dumpfile("simple_alu.vcd");
        $dumpvars(0,workbench);
    end    
    alu DUT(x,y,cntrl,out,carry);
    testbench tb (x,y,cntrl,out,carry);
endmodule
			