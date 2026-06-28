package AES_sequences_pkg;
import uvm_pkg::*;
import AES_transaction_pkg::*;
`include "uvm_macros.svh"

class AES_reset_sequence extends uvm_sequence;
    `uvm_object_utils(AES_reset_sequence)
    AES_seq_item seq_item;

    function new(string name = "AES_reset_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = AES_seq_item::type_id::create("seq_item");
        start_item(seq_item);
        seq_item.rst_n = 1'b0;
        seq_item.valid_in = 1'b0;
        finish_item(seq_item);
    endtask
endclass

class AES_encrypt_sequence extends uvm_sequence;
    `uvm_object_utils(AES_encrypt_sequence)
    AES_seq_item seq_item;

    function new(string name = "AES_encrypt_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = AES_seq_item::type_id::create("seq_item");
        repeat (100) begin
            start_item(seq_item);
            seq_item.randomize();
            seq_item.flag = 1'b1;
            finish_item(seq_item);
        end
    endtask
endclass

class AES_decrypt_sequence extends uvm_sequence;
    `uvm_object_utils(AES_decrypt_sequence)
    AES_seq_item seq_item;

    function new(string name = "AES_decrypt_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = AES_seq_item::type_id::create("seq_item");
        repeat (100) begin
            start_item(seq_item);
            seq_item.randomize();
            seq_item.flag = 1'b0;
            finish_item(seq_item);
        end
    endtask
endclass

class AES_enc_dec_sequence extends uvm_sequence;
    `uvm_object_utils(AES_enc_dec_sequence)
    AES_seq_item seq_item;

    function new(string name = "AES_enc_dec_sequence");
        super.new(name);
    endfunction

    task body();
        seq_item = AES_seq_item::type_id::create("seq_item");
        repeat (50) begin
            start_item(seq_item);
            seq_item.randomize();
            seq_item.flag = 1'b1;
            finish_item(seq_item);
        end
    endtask
endclass
endpackage