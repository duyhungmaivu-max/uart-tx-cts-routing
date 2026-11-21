# Clock: 50 MHz = 20 ns
create_clock -name clk -period 20 [get_ports clk]

# Clock uncertainty
set_clock_uncertainty 0.2 [get_clocks clk]

# Input delays
set_input_delay 2.0 -clock clk \
    [get_ports {rst_n tx_start tx_data*}]

# Output delays
set_output_delay 2.0 -clock clk \
    [get_ports {tx tx_busy}]
