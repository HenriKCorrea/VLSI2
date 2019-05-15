#===============================================================================
## Specifying explicit search path and configuration
#===============================================================================

include settings.tcl

#Scripts
set_db script_search_path ./

#setting lib path
set_db lib_search_path $path_lib

#setting technology library
set_db library $core_lib

#setting technology lef library
set_db lef_library $core_lef    
      
#setting capacitance table
set_db cap_table_file $cap_tab

# HDL files
set_db hdl_search_path ./rtl


#===============================================================================
## Load HDL Files
#===============================================================================
read_hdl -vhdl {aes_package.vhd key_expander.vhd aes128_fast.vhd}


#===============================================================================
## Elaborate designs
#===============================================================================
elaborate aes128_fast

#===============================================================================
## Apply constraints
#===============================================================================

#constraints
read_sdc ./inputconstraints.sdc

#===============================================================================
## Synthesize
#===============================================================================
set syn_generic_effort {low} 
syn_generic
set syn_map_effort {low} 
syn_map

#===============================================================================
## Report
#===============================================================================
report area > area.txt
report gates > gates.txt
report timing > timing.txt

#===============================================================================
## Export design
#===============================================================================

write_sdc > design_post_logic_synthesis.sdc
write_sdf > design_post_logic_synthesis.sdf
write_hdl > design_post_logic_synthesis.v

write_snapshot -innovus -outdir farinha -tag write_snapshot 

