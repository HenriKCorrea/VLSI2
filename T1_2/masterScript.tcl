#===============================================================================
## Specifying explicit search path and configuration
#===============================================================================

#Read configurations file
include settings.tcl

#Scripts
set_db script_search_path $path_script

#setting lib path
set_db lib_search_path $path_lib

#setting technology library
set_db library $core_lib_nom

#setting technology lef library
set_db lef_library $core_lef    
      
#setting capacitance table
set_db cap_table_file $cap_tab

# HDL files
set_db hdl_search_path $path_rtl


#===============================================================================
## Load HDL Files
#===============================================================================
read_hdl -vhdl {aes_package.vhd key_expander.vhd aes128_fast.vhd}

#===============================================================================
## Load Multi-Mode Multi-Corner file
#===============================================================================
read_mmmc design_mmmc.tcl

#===============================================================================
## Elaborate designs
#===============================================================================
elaborate aes128_fast

#===============================================================================
## Loop synthesize, report and export design
#===============================================================================
init_design


foreach i $effort {
	foreach j $corner {
		set_analysis_view -setup view_${j}
   
		set_db syn_generic_effort ${i}
		syn_generic

		set_db syn_map_effort ${i}
		syn_map

		report timing > output/${i}/${j}/timing_${i}_${j}.txt
		report area > output/${i}/${j}/area_${i}_${j}.txt
		report power > output/${i}/${j}/power_${i}_${j}.txt
    
		write_sdc -view view_${j} > output/${i}/${j}/design_post_logic_synthesis_${i}_${j}.sdc
		write_sdf -view view_${j} > output/${i}/${j}/design_post_logic_synthesis_${i}_${j}.sdf
		write_hdl > output/${i}/${j}/design_post_logic_synthesis_${i}_${j}.v
		
		write_snapshot -outdir output/${i}/${j}/snapshot_${i}_${j} -innovus -tag write_snapshot_${i}_${j}.post_rtl
	}
}


#===============================================================================
## Apply low power design config
#===============================================================================
set_db lp_insert_clock_gating true
set_db lp_insert_discrete_clock_gating_logic true


#===============================================================================
## Synthesize
#===============================================================================
set_analysis_view -setup view_NOM

set_db syn_generic_effort {high} 
syn_generic
set_db syn_map_effort {high} 
syn_map

#===============================================================================
## Report
#===============================================================================
report area > output/lowpower/area_high_NOM_lowpower.txt
report power > output/lowpower/power_high_NOM_lowpower.txt
report timing > output/lowpower/timing_high_NOM_lowpower.txt

#===============================================================================
## Export design
#===============================================================================
write_sdc -view view_NOM > output/lowpower/design_post_logic_synthesis_high_NOM_lowpower.sdc
write_sdf -view view_NOM > output/lowpower/design_post_logic_synthesis_high_NOM_lowpower.sdf
write_hdl > output/lowpower/design_post_logic_synthesis_high_NOM_lowpower.v

write_snapshot -innovus -outdir output/lowpower/snapshot_high_NOM_lowpower -tag write_snapshot_high_NOM_lowpower.post_rtl 

