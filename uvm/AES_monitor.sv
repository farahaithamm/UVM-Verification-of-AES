package AES_monitor_pkg;
    import uvm_pkg::*;
    import AES_transaction_pkg::*;
    `include "uvm_macros.svh"

    class AES_monitor extends uvm_monitor;
        `uvm_component_utils(AES_monitor)

        AES_seq_item seq_item;
        virtual intf vif;

        uvm_analysis_port#(AES_seq_item) ap;

        function new(string name = "AES_monitor", uvm_component parent = null);
            super.new(name, parent);
        endfunction

        function void build_phase (uvm_phase phase);
            super.build_phase(phase);
            seq_item = AES_seq_item::type_id::create("seq_item", this);
            ap = new("ap", this);

            if (!uvm_config_db#(virtual intf)::get(this, "", "my_vif", vif))
                `uvm_fatal(get_full_name(), "Monitor - Unable to get the virtual interface")
        endfunction

        task run_phase (uvm_phase phase);
            super.run_phase(phase);
            forever begin
                repeat(2)@(vif.cb);
                seq_item.rst_n <= vif.rst_n;
                seq_item.plain_text <= vif.plain_text;
                seq_item.cipher_key <= vif.cipher_key;
                seq_item.valid_in <= vif.valid_in;
                seq_item.valid_out <= vif.valid_out;
                seq_item.cipher_text <= vif.cipher_text;
                seq_item.flag <= vif.flag;
                #1step ap.write(seq_item);
            end
        endtask
    endclass
endpackage