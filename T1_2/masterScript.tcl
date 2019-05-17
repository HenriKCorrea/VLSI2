#===============================================================================
## Specifying explicit search path and configuration
#===============================================================================

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
## Apply low power design config
#===============================================================================
####TODO
#set_db lp_insert_clock_gating true
#set_db lp_insert_discrete_clock_gating_logic true

#===============================================================================
## Loop synthesize, report and export design
#===============================================================================
##TODO: Perguntar para professora se na linha 56 o nome colocado é design_mmmc.tcl
## Além disso ver como captar os valores de i e j para colocar nos nomes dos arquivos
inti_design
foreach i $effort {
	foreach j $corner {
		set_analysis_view -setup design_mmmc.tcl
		init_design
   
		set_db syn_generic_effort $i
		syn_generic

		set_db syn_map_effort $i
		syn_map

		report timing > timing_$i_$j.txt
    report area > area_$i_$j.txt
    report gates > gates_$i_$j.txt
    
    write_sdc > design_post_logic_synthesis_$i_$j.sdc
    write_sdf > design_post_logic_synthesis_$i_$j.sdf
    write_hdl > design_post_logic_synthesis_$i_$j.v
		
		write_snapshot -outdir pedemanga_$i_$j -innovus -tag write_snapshot.post_rtl
	}
{

#===============================================================================
## Apply constraints
#===============================================================================

#constraints
#read_sdc ./inputconstraints.sdc



#===============================================================================
## Synthesize
#===============================================================================
#TODO -> put inside for each
#set syn_generic_effort {low} 
#syn_generic
#set syn_map_effort {low} 
#syn_map

#===============================================================================
## Report
#===============================================================================
#report area > area.txt
#report gates > gates.txt
#report timing > timing.txt

#===============================================================================
## Export design
#===============================================================================

#write_sdc > design_post_logic_synthesis.sdc
#write_sdf > design_post_logic_synthesis.sdf
#write_hdl > design_post_logic_synthesis.v

#write_snapshot -innovus -outdir farinha -tag write_snapshot 

