# UART TX - Detailed Routing
# OpenROAD / Nangate45

set project_dir [file normalize \
    [file join [file dirname [info script]] ..]]

set platform_dir [file normalize \
    "$env(HOME)/asic_projects/OpenROAD-flow-scripts/flow/platforms/nangate45"]

set lib_file [file join $platform_dir lib NangateOpenCellLibrary_typical.lib]

# 1. Load Liberty
read_liberty $lib_file

# 2. Load Global Routing database
read_db [file join $project_dir results global_route.odb]

# 3. Load SDC
read_sdc [file join $project_dir constraints uart_tx.sdc]

# 4. Configure routing layers
set_routing_layers -signal metal2-metal10 -clock metal2-metal10

# 5. Configure wire RC
set_wire_rc -signal -layer metal3
set_wire_rc -clock -layer metal5

# 6. Regenerate routing guides
# Routing guides are not guaranteed to persist in ODB.
global_route -guide_file \
    [file join $project_dir results detailed_route_input.guide]

# 7. Detailed Routing
# Routing layers were configured using set_routing_layers
set_routing_layers -signal metal2-metal10 -clock metal2-metal10
detailed_route -verbose 1

# 8. Save routed database
write_db [file join $project_dir results detailed_route.odb]

# 9. Export DEF
write_def [file join $project_dir results detailed_route.def]

puts "=================================="
puts "UART TX DETAILED ROUTING COMPLETED"
puts "=================================="
