# UART TX Post-Route Static Timing Analysis

set project_dir [file normalize [file join [file dirname [info script]] ..]]

set platform_dir "$env(HOME)/asic_projects/OpenROAD-flow-scripts/flow/platforms/nangate45"

set lib_file "$platform_dir/lib/NangateOpenCellLibrary_typical.lib"

# Load technology and library
read_lef "$platform_dir/lef/NangateOpenCellLibrary.tech.lef"
read_lef "$platform_dir/lef/NangateOpenCellLibrary.macro.lef"

read_liberty $lib_file

# Load routed database
read_db "$project_dir/results/detailed_route_drc_clean.odb"

# Load timing constraints
read_sdc "$project_dir/constraints/uart_tx.sdc"

# Set RC estimation parameters
set_wire_rc -signal -layer metal3
set_wire_rc -clock -layer metal5

# Estimate parasitics from detailed routing
estimate_parasitics -global_routing

# Update timing
estimate_parasitics -global_routing

# Setup timing
report_worst_slack -max > \
    "$project_dir/reports/final_setup_wns.rpt"

# Hold timing
report_worst_slack -min > \
    "$project_dir/reports/final_hold_wns.rpt"

# Setup paths
report_checks -path_delay max -group_path_count 10 > \
    "$project_dir/reports/final_setup_paths.rpt"

# Hold paths
report_checks -path_delay min -group_path_count 10 > \
    "$project_dir/reports/final_hold_paths.rpt"

puts "===================================="
puts "UART TX POST-ROUTE STA COMPLETED"
puts "===================================="