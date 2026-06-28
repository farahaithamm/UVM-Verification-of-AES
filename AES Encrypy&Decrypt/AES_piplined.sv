module AES_128 (
    input clk, rst_n, valid_in, flag,
    input [127:0] plain_text,
    input [127:0] cipher_key,
    output reg [127:0] cipher_text,
    output reg valid_out
);

wire [127:0] plain_text_df, cipher_key_df, cipher_text_df;
wire flag_df, valid_out1, valid_out2, valid_out3;

ff plain_text_ff (
        .clk(clk), 
        .rst_n(rst_n), 
        .valid_in(valid_in),
        .data_in(plain_text),
        .data_out(plain_text_df),
        .valid_out(valid_out1)
);

ff cipher_key_ff (
        .clk(clk), 
        .rst_n(rst_n), 
        .valid_in(valid_in),
        .data_in(cipher_key),
        .data_out(cipher_key_df),
        .valid_out(valid_out2)
);

ff #(.N(1)) flag_ff (
        .clk(clk),
        .rst_n(rst_n),
        .valid_in(valid_in),
        .data_in(flag),
        .data_out(flag_df),
        .valid_out(valid_out3)
);

AES aes(
        .plain_text_128(plain_text_df),
        .cipher_key_128(cipher_key_df),
        .cipher_text_128(cipher_text_df),
        .flag(flag_df)
);

ff cipher_text_ff (
        .clk(clk), 
        .rst_n(rst_n), 
        .valid_in(valid_out1 & valid_out2 & valid_out3),
        .data_in(cipher_text_df),
        .data_out(cipher_text),
        .valid_out(valid_out)
);
    
endmodule