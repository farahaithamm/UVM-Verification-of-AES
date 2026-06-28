package AES_Test_pkg;
import uvm_pkg::*;
import AES_env_pkg::*;
import AES_sequences_pkg::*;
`include "uvm_macros.svh"

class AES_Test extends uvm_test;
    `uvm_component_utils(AES_Test)

    AES_env env;
    AES_reset_sequence reset_seq;
    AES_encrypt_sequence encrypt_seq;
    // AES_decrypt_sequence decrypt_seq;
    // AES_enc_dec_sequence both_seq;
    virtual intf vif;

    function new(string name = "AES_Test", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase(uvm_phase phase);
        super.build_phase(phase);
        env = AES_env::type_id::create("env", this);
        reset_seq = AES_reset_sequence::type_id::create("reset_seq");
        encrypt_seq = AES_encrypt_sequence::type_id::create("encrypt_seq");
        // decrypt_seq = AES_decrypt_sequence::type_id::create("decrypt_seq");
        // both_seq = AES_enc_dec_sequence::type_id::create("both_seq");  
        if (!uvm_config_db #(virtual intf)::get(this, "", "my_vif", vif)) begin
            `uvm_fatal(get_full_name(), "Test - Unable to get the virtual interface")
        end 

        uvm_config_db #(virtual intf)::set(this, "env", "my_vif", vif);

    endfunction

    task run_phase(uvm_phase phase);
        super.run_phase(phase);
        phase.raise_objection(this);
        reset_seq.start(env.ag.sqr);
        encrypt_seq.start(env.ag.sqr);
        // decrypt_seq.start(env.ag.sqr);
        // both_seq.start(env.ag.sqr);
        phase.drop_objection(this);
    endtask
endclass
endpackage