module encoder_1hot_4to2 (
    output wire [1:0] YZ,
    input wire [3:0] ABCD
);
    assign YZ[1] = ABCD[3] | ABCD[2];
    assign YZ[0] = ABCD[3] | ABCD[1];
endmodule

module tb_encoder (
    output reg [3:0] ABCD,
    input [1:0] YZ
);
    initial begin
        ABCD = 4'b0000;  
        #5 ABCD = 4'b0001;
        #5 ABCD = 4'b0010;
        #5 ABCD = 4'b0100;
        #5 ABCD = 4'b1000;
    end
endmodule

module wb_en;
    wire [3:0] ABCD;
    wire [1:0] YZ;
    
    encoder_1hot_4to2 enc_1hot(YZ, ABCD);
    tb_encoder tb(ABCD, YZ);
endmodule
