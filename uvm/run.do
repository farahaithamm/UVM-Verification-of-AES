vlib work
vsim -voptargs=+acc work.AES_top -cover -classdebug -uvmcontrol=all +UVM_VERBOSITY=UVM_HIGH
add wave /top/dut/*
run -all