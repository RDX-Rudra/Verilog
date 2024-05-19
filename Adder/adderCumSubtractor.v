module full_adder1b(
    input x, y, z,
    output sum, carry
);
    assign sum = x ^ y ^ z;
    assign carry = ((x & y) | (z & x) | (z & y));

endmodule//end_of_1bit_full_adder

module adder_cum_subtractor4b (
    input [3:0]x, z,
    input cin,
    output [3:0] sum,
    output carry
);
    wire cout1, cout2, cout3;
    wire [3:0]y;
    // xor(y[0], z[0], cin);
    // xor(y[1], z[1], cin);
    // xor(y[2], z[2], cin);
    // xor(y[3], z[3], cin);
    assign y = {z[3] ^ cin, z[2] ^ cin, z[1] ^ cin, z[0] ^ cin};
    full_adder1b FA1 (x[0], y[0], cin, sum[0], cout1);
    full_adder1b FA2 (x[1], y[1], cout1, sum[1], cout2);
    full_adder1b FA3 (x[2], y[2], cout2, sum[2], cout3);
    full_adder1b FA4 (x[3], y[3], cout3, sum[3], carry);
endmodule //end_of_dut_4bit_full_adder

module tb_adder4b(
	output reg [3:0] bin1, bin2,
    output reg cin,
	input [3:0]sum,
    input carry
);
	initial begin
		$monitor("%t, When bin1=%b, bin2=%b cin=%b then Result is =%b , Carry =%b",$time,bin1,bin2,cin,sum,carry);
		   {bin1,bin2,cin} = 9'b010110101;
		#5 {bin1,bin2,cin} = 9'b001111101;
		#5 {bin1,bin2,cin} = 9'b111100110;
		#5 {bin1,bin2,cin} = 9'b011100011;
		#5 {bin1,bin2,cin} = 9'b000000011;
		#5 {bin1,bin2,cin} = 9'b111100000;
		#5 {bin1,bin2,cin} = 9'b011100011;
		#5 {bin1,bin2,cin} = 9'b011100010;
        #5 $finish;
	end
endmodule //end_of_tb

module wb;
    wire [3:0] bin1, bin2, sum, bin3;
    wire cin, carry;
    initial begin
        $dumpfile("addersubtractor.vcd");
        $dumpvars(0, wb);
    end
    adder_cum_subtractor4b dut (bin1, bin2, cin, sum, carry);
    tb_adder4b tb (bin1, bin2, cin, sum, carry);
    
endmodule //end_of_workbench