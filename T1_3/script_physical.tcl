#To start innovus use the following commands: 
#innovus -common_ui 
#source script_physical.tcl

##=====================================================================================
# Environment Configuration / Read logic synthesis phase data
##=====================================================================================

#Attempt to download logic synthesys phase output data
sh downloadOutputFolder.sh

#Copy .sdc file from logic synthesis phase and rename it to constraints_pre_physical.sdc
##SDC files (Synopsis Design Constrains) typically contain timing analysis information, such as the clock specifications, case analysis constraints, I/O timings, and path exceptions that make each mode unique. 
mkdir -p physicalOutput 
cp "output/high/NOM/design_post_logic_synthesis_high_NOM.sdc" "physicalOutput/constraints_pre_physical.sdc"

#set technology node in nanometers
##Specifies the process technology value to set for all the applications. Units in nanometers (nm).
set_db design_process_node 65

#Specifies power/grounds nets in the design
set_db init_power_nets vdd
set_db init_ground_nets gnd

#Read design data from logic synthesis output phase
source "/home/vlsi2_g04/VLSI2-master/T1_3/output/high/NOM/snapshot_high_NOM/write_snapshot_high_NOM.post_rtl_aes128_fast.invs_setup.tcl"

##=====================================================================================
# Floorplanning
##=====================================================================================

#Specifies the floorplan dimensions by size; or by die, I/O, or core coordinates.
#create floorplan -site <name> -core density size <ratio> <core utilization> <margins> 
create_floorplan -site CORE -core_density_size 1.1 0.7 20.0 20.0 20.0 20.0

#Define I/O pins properties for signals such as clock, reset and all other design signals
##The edit_pin command modifies properties of pins, such as pin spreading, pin location, pin width and depth, spacing, snap-to location, and status.
edit_pin -pin_width 0.1 -pin_depth 0.52 -fix_overlap 1 -unit micron -spread_direction clockwise -side Top -layer 4 -spread_type center -spacing 1.0 -pin {clk {data_in[0]} {data_in[1]} {data_in[2]} {data_in[3]} {data_in[4]} {data_in[5]} {data_in[6]} {data_in[7]} {data_in[8]} {data_in[9]} {data_in[10]} {data_in[11]} {data_in[12]} {data_in[13]} {data_in[14]} {data_in[15]} {data_in[16]} {data_in[17]} {data_in[18]} {data_in[19]} {data_in[20]} {data_in[21]} {data_in[22]} {data_in[23]} {data_in[24]} {data_in[25]} {data_in[26]} {data_in[27]} {data_in[28]} {data_in[29]} {data_in[30]} {data_in[31]} {data_in[32]} {data_in[33]} {data_in[34]} {data_in[35]} {data_in[36]} {data_in[37]} {data_in[38]} {data_in[39]} {data_in[40]} {data_in[41]} {data_in[42]} {data_in[43]} {data_in[44]} {data_in[45]} {data_in[46]} {data_in[47]} {data_in[48]} {data_in[49]} {data_in[50]} {data_in[51]} {data_in[52]} {data_in[53]} {data_in[54]} {data_in[55]} {data_in[56]} {data_in[57]} {data_in[58]} {data_in[59]} {data_in[60]} {data_in[61]} {data_in[62]} {data_in[63]} {data_out[0]} {data_out[1]} {data_out[2]} {data_out[3]} {data_out[4]} {data_out[5]} {data_out[6]} {data_out[7]} {data_out[8]} {data_out[9]} {data_out[10]} {data_out[11]} {data_out[12]} {data_out[13]} {data_out[14]} {data_out[15]} {data_out[16]} {data_out[17]} {data_out[18]} {data_out[19]} {data_out[20]} {data_out[21]} {data_out[22]} {data_out[23]} {data_out[24]} {data_out[25]} {data_out[26]} {data_out[27]} {data_out[28]} {data_out[29]} {data_out[30]} {data_out[31]} {data_out[32]} {data_out[33]} {data_out[34]} {data_out[35]} {data_out[36]} {data_out[37]} {data_out[38]} {data_out[39]} {data_out[40]} {data_out[41]} {data_out[42]} {data_out[43]} {data_out[44]} {data_out[45]} {data_out[46]} {data_out[47]} {data_out[48]} {data_out[49]} {data_out[50]} {data_out[51]} {data_out[52]} {data_out[53]} {data_out[54]} {data_out[55]} {data_out[56]} {data_out[57]} {data_out[58]} {data_out[59]} {data_out[60]} {data_out[61]} {data_out[62]} {data_out[63]} {data_out[64]} {data_out[65]} {data_out[66]} {data_out[67]} {data_out[68]} {data_out[69]} {data_out[70]} {data_out[71]} {data_out[72]} {data_out[73]} {data_out[74]} {data_out[75]} {data_out[76]} {data_out[77]} {data_out[78]} {data_out[79]} {data_out[80]} {data_out[81]} {data_out[82]} {data_out[83]} {data_out[84]} {data_out[85]} {data_out[86]} {data_out[87]} {data_out[88]} {data_out[89]} {data_out[90]} {data_out[91]} {data_out[92]} {data_out[93]} {data_out[94]} {data_out[95]} {data_out[96]} {data_out[97]} {data_out[98]} {data_out[99]} {data_out[100]} {data_out[101]} {data_out[102]} {data_out[103]} {data_out[104]} {data_out[105]} {data_out[106]} {data_out[107]} {data_out[108]} {data_out[109]} {data_out[110]} {data_out[111]} {data_out[112]} {data_out[113]} {data_out[114]} {data_out[115]} {data_out[116]} {data_out[117]} {data_out[118]} {data_out[119]} {data_out[120]} {data_out[121]} {data_out[122]} {data_out[123]} {data_out[124]} {data_out[125]} {data_out[126]} {data_out[127]} done load mode reset start}

###
#Powerplan (post floorplanning step)
####

#Resets the global net as well as all of the tie-high and tie-low nets.
delete_global_net_connections

#Connecting pins in multiple instances to VDD and GND global net
connect_global_net vdd -type pg_pin -pin_base_name vdd -inst_base_name *
connect_global_net gnd -type pg_pin -pin_base_name gnd -inst_base_name *
connect_global_net vdd -type tie_hi -inst_base_name *
connect_global_net gnd -type tie_lo -inst_base_name *

#Power rings
##Creates rings for VDD and GND nets around the core boundary and creates power stripes if necessary. 
add_rings -nets {gnd vdd} -type core_rings -follow core -layer {top M1 bottom M1 left M2 right M2} -width {top 6 bottom 6 left 6 right 6} -spacing {top 2 bottom 2 left 2 right 2} -offset {top 2.5 bottom 2.5 left 2.5 right 2.5} -center 0 -extend_corners {} -threshold 0 -jog_distance 0 -snap_wire_center_to_grid none

#Special routing
##Routes power structures (interconnections) to pins and pads.
route_special -connect {block_pin pad_pin pad_ring core_pin floating_stripe} -layer_change_range { M1(1) AP(8) } -block_pin_target {nearest_target} -pad_pin_port_connect {all_port one_geom} -pad_pin_target {nearest_target} -core_pin_target {first_after_row_end} -floating_stripe_target {block_ring pad_ring ring stripe ring_pin block_pin followpin} -allow_jogging 1 -crossover_via_layer_range { M1(1) AP(8) } -nets { gnd vdd } -allow_layer_change 1 -block_pin use_lef -target_via_layer_range { M1(1) AP(8) }

#Finishing flooplan/power planing
##Saves the floorplan / IO information to a file
write_floorplan physicalOutput/aes128_fast.fp
write_io_file physicalOutput/aes128_fast.io

##in future synthesis, load the configurations
#read_floorplan aes128_fast.fp
#read_io_file aes128_fast.io

#Adds well-tap cells
#Well tap cells are placed in order to ensure the substrate/well is kept at vdd/gnd potential or very close to it.
add_well_taps -cell HS65_LS_FILLERNPWPFP3 -cell_interval 20 -prefix WELLTAP

##=====================================================================================
# placement (place standard cells)
##=====================================================================================

#Global placement disregards scan connections while placing scan groups.
set_db place_global_ignore_scan false
#Specifies the number of threads to use for multi-threading, or the maximum number of computers to use for distributed processing
set_multi_cpu_usage -local_cpu 8 -cpu_per_remote_host 8 -remote_host 0 -keep_license true
#pecifies the multiple-CPU processing configuration for distributed processing or Superthreading
set_distributed_hosts -local
set_db place_design_floorplan_mode 0

#Places standard cells based on the global settings for placement, RC extraction, timing analysis, and early global routing.
place_design

#Optimization post placement
#NOTE. After optimization, the command opt_design generates a timing report. Redirecting this report to /dev/null since the report will be generated later using the appropriate commands (time_design)
opt_design -pre_cts -report_dir /dev/null

#Peroform timing analysis report (post placement) 
time_design -pre_cts -ideal_clock -path_report -drv_report -slack_report -num_paths 50 -report_prefix aes128_fast_preCTS -report_dir physicalOutput/timingReports/aes128_fast_preCTS

##=====================================================================================
# CTS (Clock Tree Synthesis)
##=====================================================================================

#Legacy CTS Engine (Documentation has been removed for those commands since 
eval_legacy { setCTSMode -engine ck }
eval_legacy { set_ccopt_property buffer_cells { HS65_GS_BFX2 HS65_GS_BFX22 HS65_GS_BFX40 HS65_GS_BFX7 } }
eval_legacy { set_ccopt_property inverter_cells { HS65_GS_IVX13 HS65_GS_IVX31 HS65_GS_VIX4 HS65_GS_IVX49 HS65_GS_IVX7 } }
eval_legacy { set_ccopt_property use_inverters true }
eval_legacy { create_ccopt_clock_tree_spec -filename physicalOutput/ccopt.spec }

#Optimization post CTS - Innovus CTS Engine
#NOTE. After optimization, the command opt_design generates a timing report. Redirecting this report to /dev/null since the report will be generated later using the appropriate commands (time_design)
set_db timing_analysis_type ocv
set_db opt_fix_fanout_load true
opt_design -post_cts -drv -report_dir /dev/null

#Peroform timing analysis report (post Clock Tree Synthesis) 
time_design -post_cts -ideal_clock -path_report -drv_report -slack_report -num_paths 50 -report_prefix aes128_fast_postCTS -report_dir physicalOutput/timingReports/aes128_fast_postCTS

#Nano route (design)
route_design -global_detail -wire_opt

#Optimization post route
#NOTE. After optimization, the command opt_design generates a timing report. Redirecting this report to /dev/null since the report will be generated later using the appropriate commands (time_design)
set_db timing_analysis_type ocv
set_db opt_fix_fanout_load true
opt_design -post_route -drv -report_dir /dev/null

#Peroform timing analysis report (post Route) 
time_design -post_route -ideal_clock -path_report -drv_report -slack_report -num_paths 50 -report_prefix aes128_fast_postRoute -report_dir physicalOutput/timingReports/aes128_fast_postRoute

#Verification
check_drc -out_file physicalOutput/check_drc.txt
check_connectivity -type all -error 1000 -warning 50 -out_file physicalOutput/check_connectivity.txt
check_legacy_design -all -no_html -out_file physicalOutput/check_legacy_design.txt

#Reports and outputs
report_area -out_file physicalOutput/report_area.txt
report_power -out_file physicalOutput/report_power.txt
report_timing -early > physicalOutput/report_timing_early.txt
report_timing -late > physicalOutput/report_timing_late.txt
write_netlist physicalOutput/design_pos_physical.v
write_def -floorplan -netlist -routing physicalOutput/design_pos_physical.def
write_sdf physicalOutput/timing_pos_physical.sdf

