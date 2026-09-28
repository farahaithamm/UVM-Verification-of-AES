module AES_top;
import uvm_pkg::*;
import AES_Test_pkg::*;
`include "uvm_macros.svh"

bit clk;
always #5 clk = ~clk;

intf inf(clk);

AES_128 dut(
    .clk(inf.clk),
    .rst_n(inf.rst_n),
    .plain_text(inf.plain_text),
    .cipher_key(inf.cipher_key),
    .valid_in(inf.valid_in),
    .cipher_text(inf.cipher_text),
    .valid_out(inf.valid_out),
    .flag(inf.flag)
);

initial begin
    uvm_config_db #(virtual intf)::set(null, "uvm_test_top", "my_vif", inf);
    run_test("AES_Test");
end
endmodule 
