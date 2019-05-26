#setting technology library variables 
set core_lib_nom "/soft64/design-kits/stm/65nm-cmos065_536/CORE65GPSVT_5.1/libs/CORE65GPSVT_nom_1.00V_25C.lib"
set core_lib_wc "/soft64/design-kits/stm/65nm-cmos065_536/CORE65GPSVT_5.1/libs/CORE65GPSVT_wc_1.00V_125C.lib"
set core_lib_bc "/soft64/design-kits/stm/65nm-cmos065_536/CORE65GPSVT_5.1/libs/CORE65GPSVT_bc_1.02V_125C.lib"

#op cond
create_opcond -name cond_NOM -process 1.0 -voltage 1.00 -temperature 25.0
create_opcond -name cond_WC -process 1.0 -voltage 1.00 -temperature 125.0
create_opcond -name cond_BC -process 1.0 -voltage 1.02 -temperature 125.0

#create library set
create_library_set -name NOM -timing $core_lib_nom
create_library_set -name WC -timing $core_lib_wc
create_library_set -name BC -timing $core_lib_bc

# timing_condition
create_timing_condition -name NOM_timing -opcond cond_NOM -library_sets NOM	-opcond_library $core_lib_nom
create_timing_condition -name WC_timing -opcond cond_WC -library_sets WC -opcond_library $core_lib_wc
create_timing_condition -name BC_timing -opcond cond_BC -library_sets BC -opcond_library $core_lib_bc

#constraints
create_constraint_mode -name default_constraint -sdc_files inputconstraints.sdc

#delay corner
create_delay_corner -name delay_corner_NOM -timing_condition NOM_timing
create_delay_corner -name delay_corner_BC -timing_condition BC_timing
create_delay_corner -name delay_corner_WC -timing_condition WC_timing

#analysis_view
create_analysis_view -name view_NOM -constraint_mode default_constraint -delay_corner delay_corner_NOM
create_analysis_view -name view_BC -constraint_mode default_constraint -delay_corner delay_corner_BC
create_analysis_view -name view_WC -constraint_mode default_constraint -delay_corner delay_corner_WC

set_analysis_view -setup view_NOM