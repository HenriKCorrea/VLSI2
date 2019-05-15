#===============================================================================
## Specifying explicit search path and configuration
#===============================================================================

#setting lib path variables
set path_lib "/soft64/design-kits/stm/65nm-cmos065_536"

#setting technology library variables (lógica)
set core_lib "${path_lib}/CORE65GPSVT_5.1/libs/CORE65GPSVT_nom_1.00V_25C.lib"

#setting technology lef library variables (física)
set core_lef "${path_lib}/EncounterTechnoKit_cmos065_7m4x0y2z_AP@5.3.1/TECH/cmos065_7m4x0y2z_AP_Worst.lef \
			${path_lib}/PRHS65_7.0.a/CADENCE/LEF/PRHS65_soc.lef \
			${path_lib}/CORE65GPSVT_5.1/CADENCE/LEF/CORE65GPSVT_soc.lef"

#setting capacitance table variable
set cap_tab "${path_lib}/EncounterTechnoKit_cmos065_7m4x0y2z_AP@5.3.1/TECH/cmos065_7m4x0y2z_AP_Worst.captable"




