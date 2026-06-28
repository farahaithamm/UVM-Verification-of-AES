package AES_agent_pkg;
import uvm_pkg::*;
import AES_monitor_pkg::*;
import AES_driver_pkg::*;
import AES_sequencer_pkg::*;
import AES_transaction_pkg::*;
`include "uvm_macros.svh"

class AES_agent extends uvm_agent;
    `uvm_component_utils(AES_agent)

    AES_monitor mon;
    AES_driver drv;
    AES_sequencer sqr;

    virtual intf vif;
    uvm_analysis_port#(AES_seq_item) ap;

    function new(string name = "AES_agent", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);

        mon = AES_monitor::type_id::create("mon", this);
        drv = AES_driver::type_id::create("drv", this);
        sqr = AES_sequencer::type_id::create("sqr", this);

        ap = new("ap", this);

        if (!uvm_config_db#(virtual intf)::get(this, "", "my_vif", vif))
            `uvm_error(get_full_name(), "Agent - Unable to get the virtual interface")

        uvm_config_db#(virtual intf)::set(this, "mon", "my_vif", vif);
        uvm_config_db#(virtual intf)::set(this, "drv", "my_vif", vif);

    endfunction


    function void connect_phase(uvm_phase phase);
        super.connect_phase(phase);
        drv.seq_item_port.connect(sqr.seq_item_export);
        mon.ap.connect(ap);
    endfunction
endclass
endpackage