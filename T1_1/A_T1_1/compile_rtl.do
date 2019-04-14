# Simple script to automate the verification process

#------------------------------------------------------------------------------
#    Project directory settings (Put your actual directory paths here)
#------------------------------------------------------------------------------
set script_dir "/home/vlsi2_g04/VLSI2-master/T1_1/A_T1_1"
set proj_dir "/home/vlsi2_g04/VLSI2-master/aes_crypto_core/trunk"
set sim_dir "$proj_dir/sim"
set rtl_dir "$proj_dir/rtl"
set tb_dir "$proj_dir/tb"


#------------------------------------------------------------------------------
#    Compile RTL and TB modules
#------------------------------------------------------------------------------
cd $sim_dir

vlib work
#vmap work work

vcom -cover bscet -work work $rtl_dir/aes_package.vhd
vcom -cover bscet -work work $rtl_dir/key_expander.vhd
vcom -cover bscet -work work $rtl_dir/aes128_fast.vhd
vcom -work work $tb_dir/aes_tb_package.vhd
vcom -work work $tb_dir/aes_tester.vhd


#------------------------------------------------------------------------------
#    Simulation
#------------------------------------------------------------------------------
vsim -coverage -novopt work.aes_tester
add wave -position insertpoint sim:/aes_tester/aes_i/*

#------------------------------------------------------------------------------
#    Setup VCD to monitor wave signals
#------------------------------------------------------------------------------
vcd file $script_dir/aes_old.vcd
vcd add -r /*

#------------------------------------------------------------------------------
#    Run simulation
#------------------------------------------------------------------------------
run 200000 ns

#------------------------------------------------------------------------------
#    Generate reports
#------------------------------------------------------------------------------
coverage report -file $script_dir/aes_cover_old.txt
coverage save $script_dir/aes_cover_old.cov
vcd checkpoint
restart -f

#------------------------------------------------------------------------------
#    Run simulation (again)
#------------------------------------------------------------------------------
run 200000 ns

