package AES_subscriber_pkg;
import uvm_pkg::*;
import AES_transaction_pkg::*;
`include "uvm_macros.svh"

class AES_subscriber extends uvm_subscriber #(AES_seq_item);
    `uvm_component_utils(AES_subscriber)
    AES_seq_item seq_item;

    covergroup signals_cg;
        rst_n_cp : coverpoint seq_item.rst_n{
            bins rst_on = {0};
            bins rst_off = {1};
            bins rst_on_to_off = (0 => 1) ;
            bins rst_off_to_on = (1 => 0) ;
        }
        valid_in_cp : coverpoint seq_item.valid_in ;
        valid_out_cp : coverpoint seq_item.valid_out;
    endgroup 

    function new(string name = "AES_subscriber", uvm_component parent = null);
        super.new(name, parent);
        signals_cg = new;
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        seq_item = AES_seq_item::type_id::create("seq_item", this);
    endfunction

    function void write (AES_seq_item t);
        seq_item = t;
        signals_cg.sample();
    endfunction
endclass
endpackage