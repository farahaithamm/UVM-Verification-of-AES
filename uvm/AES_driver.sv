package AES_driver_pkg;
import uvm_pkg::*;
import AES_transaction_pkg::*;
`include "uvm_macros.svh"

class AES_driver extends uvm_driver #(AES_seq_item);
    `uvm_component_utils(AES_driver)

    virtual intf vif;
    AES_seq_item seq_item;

    function new(string name = "AES_driver", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        if (!uvm_config_db#(virtual intf)::get(this, "", "my_vif", vif))
            `uvm_fatal(get_full_name(), "Driver - Unable to get the virtual interface")
    
        seq_item = AES_seq_item::type_id::create("AES_seq_item");

    endfunction

    task run_phase (uvm_phase phase);
        super.run_phase(phase);
        forever begin
            seq_item_port.get_next_item(seq_item);
            vif.rst_n <= seq_item.rst_n;
            vif.plain_text <= seq_item.plain_text;
            vif.cipher_key <= seq_item.cipher_key;
            vif.valid_in <= seq_item.valid_in;
            vif.flag <= seq_item.flag;
            repeat(2) @(vif.cb);
            seq_item_port.item_done();
        end
    endtask
endclass
endpackage