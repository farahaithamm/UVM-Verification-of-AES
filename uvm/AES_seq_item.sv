package AES_transaction_pkg;
import uvm_pkg::*;
`include "uvm_macros.svh"

class AES_seq_item extends uvm_sequence_item;
    `uvm_object_utils(AES_seq_item)

    rand logic rst_n, valid_in;
    rand logic [127:0] plain_text, cipher_key, cipher_text;
    logic valid_out;
    rand logic flag;

    function new(string name = "AES_seq_item");
        super.new(name);
    endfunction

    constraint reset_c {
        rst_n dist {0:=5, 1:=95}; 
    }; 
    constraint valid_in_c {
        valid_in dist {0:=5, 1:=95};
    };

    constraint flag_c {
        flag dist {0:=50, 1:=50};
    }
endclass
endpackage