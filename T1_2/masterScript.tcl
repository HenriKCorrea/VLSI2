## Tip of the day: to run the script, write in genus console ->   include masterScript.tcl
#Or, write in kriti console ->     genus include masterScript.tcl

#===============================================================================
## Specifying explicit search path and configuration
#===============================================================================

#Scripts
#set_db script_search_path ./

#setting lib path

# declara variavel que irá para o settings.tcl e o script fica com comando puro
#set path_lib "/soft64/design-kits/stm/65nm-cmos065_536"
#set_db lib_search_path $path_lib

set_db lib_search_path "/soft64/design-kits/stm/65nm-cmos065_536"

#setting technology library
#set core_lib "${path_lib}/CORE65GPSVT_5.1/libs/CORE65GPSVT_nom_1.00V_25C.lib"

# .lib é a biblioteca logica
set_db library "/soft64/design-kits/stm/65nm-cmos065_536/CORE65GPSVT_5.1/libs/CORE65GPSVT_nom_1.00V_25C.lib"


#setting technology lef library
# .lef é biblioteca física
#set core_lef $/soft64/design-kits/stm/65nm-cmos065_536/EncounterTechnoKit_cmos065_7m4x0y2z_AP@5.3.1/TECH/cmos065_7m4x0y2z_AP_Worst.lef \
#			/soft64/design-kits/stm/65nm-cmos065_536/PRHS65_7.0.a/CADENCE/LEF/PRHS65_soc.lef \
#			/soft64/design-kits/stm/65nm-cmos065_536/CORE65GPSVT_5.1/CADENCE/LEF/CORE65GPSVT_soc.lef"
#set_db lef_libraty $core_lef


set_db lef_library "/soft64/design-kits/stm/65nm-cmos065_536/EncounterTechnoKit_cmos065_7m4x0y2z_AP@5.3.1/TECH/cmos065_7m4x0y2z_AP_Worst.lef \
			/soft64/design-kits/stm/65nm-cmos065_536/PRHS65_7.0.a/CADENCE/LEF/PRHS65_soc.lef \
			/soft64/design-kits/stm/65nm-cmos065_536/CORE65GPSVT_5.1/CADENCE/LEF/CORE65GPSVT_soc.lef"
      
      

#setting capacitance table
#TODO: use correct set_db command
#set cap_tab "${path_lib}/EncounterTechnoKit_cmos065_7m4x0y2z_AP@5.3.1/TECH/cmos065_7m4x0y2z_AP_Worst.captable"
set_db cap_table_file "/soft64/design-kits/stm/65nm-cmos065_536/EncounterTechnoKit_cmos065_7m4x0y2z_AP@5.3.1/TECH/cmos065_7m4x0y2z_AP_Worst.captable"


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
create_clock -add -name clk -period 1000 clk

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

