##=====================================================================================
# Environment Configuration
##=====================================================================================

#Read configurations file
#include settings.tcl

#Scripts
#set_db script_search_path "/home/vlsi2_g04/VLSI2-master/T1_3/output/high/NOM/snapshot_high_NOM/"

#set technology node
## Especifica o nodo tecnológico em nanometros
set_db design_process_node 65

#set power/grounds nets
set_db init_power_nets vdd
set_db init_ground_nets gnd

#configuration files
source "/home/vlsi2_g04/VLSI2-master/T1_3/output/high/NOM/snapshot_high_NOM/write_snapshot_high_NOM.post_rtl_aes128_fast.invs_setup.tcl"

##=====================================================================================
# Floorplanning
##=====================================================================================

#create floorplan -site <name> -core density size <ratio> <core utilization> <margins>
create_floorplan -site CORE -core_density_size 1.1 0.7 20.0 20.0 20.0 20.0

#create floorplan -site <name> -core size <width> <height> <margins>
#create floorplan -site CORE -core size 400 400 20.0 20.0 20.0 20.0



