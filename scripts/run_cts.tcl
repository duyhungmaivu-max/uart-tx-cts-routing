# UART TX - Clock Tree Synthesis
# Project 3: OpenROAD / Nangate45

set project_dir [file normalize [pwd]]
set platform_dir [file normalize \
    "$env(HOME)/asic_projects/OpenROAD-flow-scripts/flow/platforms/nangate45"]

set lib_file "$platform_dir/lib/NangateOpenCellLibrary_typical.lib"
set tech_lef "$platform_dir/lef/NangateOpenCellLibrary.tech.lef"
set cell_lef "$platform_dir/lef/NangateOpenCellLibrary.macro.lef"

# 1. Load technology and libraries
read_lef $tech_lef
read_lef $cell_lef
read_liberty $lib_file

# 2. Load placement database
read_db "$project_dir/results/placement_hold_fixed.odb"

# 3. Load timing constraints
read_sdc "$project_dir/constraints/uart_tx.sdc"

# 4. Configure timing
set_wire_rc -signal -layer metal3
set_wire_rc -clock -layer metal5

# 5. Configure clock propagation
# Do not set propagated clocks before CTS.

# 6. Clock Tree Synthesis
clock_tree_synthesis \
    -buf_list {CLKBUF_X1 CLKBUF_X2 CLKBUF_X3} \
    -root_buf CLKBUF_X3

# 7. Legalize newly inserted clock buffers
detailed_placement

# 8. Update timing
set_propagated_clock [all_clocks]
estimate_parasitics -placement

# 9. Save CTS database
write_db "$project_dir/results/cts.odb"

# 10. Timing reports
report_worst_slack -max > \
    "$project_dir/reports/cts_setup_wns.rpt"

report_worst_slack -min > \
    "$project_dir/reports/cts_hold_wns.rpt"

report_checks -path_delay max -group_path_count 10 > \
    "$project_dir/reports/cts_setup_paths.rpt"

report_checks -path_delay min -group_path_count 10 > \
    "$project_dir/reports/cts_hold_paths.rpt"

puts "=================================="
puts "UART TX CLOCK TREE SYNTHESIS DONE"
puts "=================================="
