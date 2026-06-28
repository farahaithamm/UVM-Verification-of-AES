package AES_sequencer_pkg;
import uvm_pkg::*;
import AES_transaction_pkg::*;
`include "uvm_macros.svh"

class AES_sequencer extends uvm_sequencer #(AES_seq_item);
    `uvm_component_utils(AES_sequencer)

    function new(string name = "AES_sequencer", uvm_component parent = null);
        super.new(name, parent);
    endfunction
endclass
endpackage