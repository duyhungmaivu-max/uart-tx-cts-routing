# UART TX ASIC Physical Design: CTS and Routing

Implementation of Clock Tree Synthesis (CTS), global routing,
detailed routing, DRC cleanup, and post-route Static Timing
Analysis (STA) for a UART transmitter using OpenROAD.

## Technology

- Platform: Nangate45
- Tool: OpenROAD
- Clock frequency: 50 MHz
- Clock period: 20 ns
- RTL: Verilog
- Timing constraints: SDC

## Design Flow

1. Load placement database
2. Clock Tree Synthesis
3. Clock buffer insertion
4. Global routing
5. Detailed routing
6. DRC verification and cleanup
7. Post-route Static Timing Analysis

## CTS Results

- Clock buffers inserted: 5
- Clock buffer type: CLKBUF_X3
- Maximum clock tree level: 2
- Setup WNS: +17.61 ns
- Hold WNS: 0.00 ns

## Routing Results

- Global routing completed
- Detailed routing completed
- Routed DEF generated
- Routed OpenDB database generated
- Final DRC violations: 0

## Final Timing Results

| Metric | Result |
|--------|--------|
| Clock period | 20 ns |
| Setup WNS | +17.60 ns |
| Hold WNS | 0.00 ns |
| Reported setup violations | 0 |
| Reported hold violations | 0 |
| Final DRC violations | 0 |

## Project Structure

uart_cts_routing/
├── rtl/
│   └── uart_tx.v
├── constraints/
│   └── uart_tx.sdc
├── scripts/
│   ├── run_cts.tcl
│   ├── run_global_route.tcl
│   ├── run_detailed_route.tcl
│   ├── run_post_route_sta.tcl
│   └── run_final_sta.tcl
├── reports/
├── results/
├── .gitignore
└── README.md

## Tools

- OpenROAD
- OpenSTA
- Nangate45 Open Cell Library

## Notes

The project demonstrates CTS, routing, timing verification,
and DRC cleanup using an open-source ASIC physical design flow.

The reported results are based on the configured OpenROAD
timing and physical verification checks, not a complete
foundry sign-off.
