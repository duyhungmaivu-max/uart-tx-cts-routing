module uart_tx #(
    parameter CLK_FREQ = 50000000,
    parameter BAUD_RATE = 115200
)(
    input wire clk,
    input wire rst_n,
    input wire tx_start,
    input wire [7:0] tx_data,
    output reg tx,
    output reg tx_busy
);

localparam CLKS_PER_BIT = CLK_FREQ / BAUD_RATE;

localparam IDLE  = 2'b00;
localparam START = 2'b01;
localparam DATA  = 2'b10;
localparam STOP  = 2'b11;

reg [1:0] state;
reg [31:0] clk_count;
reg [2:0] bit_index;
reg [7:0] data_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        state <= IDLE;
        tx <= 1'b1;
        tx_busy <= 1'b0;
        clk_count <= 0;
        bit_index <= 0;
        data_reg <= 0;
    end else begin
        case (state)
            IDLE: begin
                tx <= 1'b1;
                tx_busy <= 1'b0;
                clk_count <= 0;

                if (tx_start) begin
                    data_reg <= tx_data;
                    tx_busy <= 1'b1;
                    state <= START;
                end
            end

            START: begin
                tx <= 1'b0;

                if (clk_count == CLKS_PER_BIT-1) begin
                    clk_count <= 0;
                    bit_index <= 0;
                    state <= DATA;
                end else
                    clk_count <= clk_count + 1;
            end

            DATA: begin
                tx <= data_reg[bit_index];

                if (clk_count == CLKS_PER_BIT-1) begin
                    clk_count <= 0;

                    if (bit_index == 7)
                        state <= STOP;
                    else
                        bit_index <= bit_index + 1;
                end else
                    clk_count <= clk_count + 1;
            end

            STOP: begin
                tx <= 1'b1;

                if (clk_count == CLKS_PER_BIT-1) begin
                    clk_count <= 0;
                    tx_busy <= 1'b0;
                    state <= IDLE;
                end else
                    clk_count <= clk_count + 1;
            end
        endcase
    end
end

endmodule
