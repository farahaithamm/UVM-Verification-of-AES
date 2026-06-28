package AES_scoreboard_pkg;
import uvm_pkg::*;
import AES_transaction_pkg::*;
`include "uvm_macros.svh"

class AES_scoreboard extends uvm_scoreboard;
    `uvm_component_utils(AES_scoreboard)

    integer file;
    logic [127:0] expected_out;

    uvm_analysis_imp #(AES_seq_item,AES_scoreboard) imp;

    function new(string name = "AES_scoreboard", uvm_component parent = null);
        super.new(name, parent);
    endfunction

    function void build_phase (uvm_phase phase);
        super.build_phase(phase);
        imp = new("imp", this);
    endfunction

    function void write (AES_seq_item t);
        if (t.valid_out) begin
            file = $fopen("data.txt","w");
            if (!file) begin
                `uvm_error(get_full_name(), "FAILED TO OPEN data.txt")
                return;
            end

            $fdisplay(file,"%032h", t.plain_text);
            $fdisplay(file,"%032h", t.cipher_key);
            $fclose(file);

            if (t.flag) begin
                if ($system("python  ../ref_model/aes_enc.py") != 0) begin
                    `uvm_error(get_full_name(), "PYTHON ENCRYPTION FAILED")
                    return;
                end
            end
            else begin
                if ($system("python  ../ref_model/aes_dec.py") != 0) begin
                    `uvm_error(get_full_name(), "PYTHON DECRYPTION FAILED")
                    return;
                end
            end

            file = $fopen("output.txt","r");
            if (!file) begin
                `uvm_error(get_full_name(), "FAILED TO OPEN output.txt")
                return;
            end

            $fscanf(file,"%h",expected_out);
            $fclose(file);

            if(expected_out == t.cipher_text)
                $display("SUCCESS: Output is %h, Expected Output is %h ", t.cipher_text , expected_out);
            else 
                $display("FAILURE: Output is %h, Expected Output is %h ", t.cipher_text , expected_out);  

        end
    endfunction
endclass
endpackage
