interface intf(input logic clk);
    logic rst_n, valid_in;
    logic [127:0] plain_text, cipher_key, cipher_text;
    logic valid_out, flag;


    clocking cb @(posedge clk);
        output valid_in, plain_text, cipher_key, flag;
        input cipher_text, valid_out;
    endclocking

endinterface
