module full_adder1b(
    input x, y, z,
    output sum, carry
);
    assign sum = x ^ y ^ z;
    assign carry = ((x & y) | (z & x) | (z & y));

endmodule

module inverse(
    input [3:0] bin2,
    input cin,
    output [3:0] bin3
);  

    wire [3:0] select = {cin,cin,cin,cin};
    assign bin3 = (select ^ bin2);

endmodule


module adder4b(
    input [3:0] bin1, 
    input [3:0] bin3,
    input cin,
    output [3:0] sum,
    output carry
);  
    
    wire cout1, cout2, cout3;

    full_adder1b adder1(bin1[0], bin3[0], cin, sum[0], cout1);
    full_adder1b adder2(bin1[1], bin3[1], cout1, sum[1], cout2);
    full_adder1b adder3(bin1[2], bin3[2], cout2, sum[2], cout3);
    full_adder1b adder4(bin1[3], bin3[3], cout3, sum[3], carry);
     
endmodule

module tb_adder4b(
	output reg [3:0] bin1, bin2,
    output reg cin,
	input [3:0]sum,
    input carry
);
	initial begin
		$monitor("%t, When bin1=%b, bin2=%b cin=%b then Result is =%b , Carry =%b",$time,bin1,bin2,cin,sum,carry);
		   {bin1,bin2,cin} = 9'b010110100;
		#5 {bin1,bin2,cin} = 9'b001111101;
		#5 {bin1,bin2,cin} = 9'b111100110;
		#5 {bin1,bin2,cin} = 9'b011100011;
		#5 {bin1,bin2,cin} = 9'b000000011;
		#5 {bin1,bin2,cin} = 9'b111100000;
		#5 {bin1,bin2,cin} = 9'b011100011;
		#5 {bin1,bin2,cin} = 9'b011100010;
        #5 $finish;
	end
endmodule

module wb;
    wire [3:0] bin1, bin2, sum, bin3;
    wire cin, carry;
    initial begin
        $dumpfile("adder.vcd");
        $dumpvars(0, wb);
    end
    inverse newbin (bin2,cin,bin3);
    adder4b dut (bin1, bin3, cin, sum, carry);
    tb_adder4b tb (bin1, bin2, cin, sum, carry);
endmodule