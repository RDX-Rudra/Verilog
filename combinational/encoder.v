module encoder_1hot_4to2 (
    output wire [1:0] YZ,
    input wire [3:0] ABCD
);
    assign YZ[1] = ABCD[3] | ABCD[2];
    assign YZ[0] = ABCD[3] | ABCD[1];
endmodule



module wb_en;
    wire [3:0] ABCD;
    wire [1:0] YZ;
    
    encoder_1hot_4to2 enc_1hot(YZ, ABCD);
    tb_encoder tb(ABCD, YZ);
endmodule
