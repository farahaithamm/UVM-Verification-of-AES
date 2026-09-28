vlib work
vlog ../AES_Encrypt_only/*.v -Epretty AES_Encrypt_Files.v +cover -covercells
vlog ../AES_Decrypt_only/*.v -Epretty AES_Decrypt_Files.v +cover -covercells
vsim -voptargs=+acc work.AES_top -cover -classdebug -uvmcontrol=all +UVM_VERBOSITY=UVM_HIGH
add wave /AES_top/dut/*
run -all
