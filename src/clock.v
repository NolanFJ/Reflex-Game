    /*
    output: 5 clocks for each level + denoising: 
    - 5Hz   
    - 10Hz   
    - 15Hz
    - 18Hz
    - 50hz clock for denoising 

    */

    module clock_module
    (
        input wire master_clk,
        output reg clk_5Hz = 0,
        output reg clk_10Hz = 0,
        output reg clk_15Hz = 0,
        output reg clk_18Hz = 0,
        output reg clk_50Hz = 0
    );

    // Counter limits
    parameter COUNT_5HZ = 9_999_999;       // 100MHz / (2 * 5Hz)
    parameter COUNT_10HZ = 4_999_999;      // 100MHz / (2 * 10Hz)
    parameter COUNT_15HZ = 3_333_332;      // 100MHz / (2 * 15Hz) - rounded
    parameter COUNT_18HZ = 2_777_777;      // 100Mhz / (2 * 18Hz) - rounded
    parameter COUNT_50HZ = 999_999;        // 100MHz / (2 * 50Hz)

    reg [31:0] counter_5Hz = 0;
    reg [31:0] counter_10Hz = 0;
    reg [31:0] counter_15Hz = 0;
    reg [31:0] counter_18Hz = 0;
    reg [31:0] counter_50Hz = 0;

    always @(posedge master_clk) begin
        // 5 Hz clock divider
        if (counter_5Hz == COUNT_5HZ) begin
            counter_5Hz <= 0;
            clk_5Hz <= ~clk_5Hz;
        end else begin
            counter_5Hz <= counter_5Hz + 1;
        end

        // 10 Hz clock divider
        if (counter_10Hz == COUNT_10HZ) begin
            counter_10Hz <= 0;
            clk_10Hz <= ~clk_10Hz;
        end else begin
            counter_10Hz <= counter_10Hz + 1;
        end

        // 15 Hz clock divider
        if (counter_15Hz == COUNT_15HZ) begin
            counter_15Hz <= 0;
            clk_15Hz <= ~clk_15Hz;
        end else begin
            counter_15Hz <= counter_15Hz + 1;
        end

        // 18 Hz clock divider
        if (counter_18Hz == COUNT_18HZ) begin
            counter_18Hz <= 0;
            clk_18Hz <= ~clk_18Hz;
        end else begin
            counter_18Hz <= counter_18Hz + 1;
        end

        // 50 Hz clock divider
        if (counter_50Hz == COUNT_50HZ) begin
            counter_50Hz <= 0;
            clk_50Hz <= ~clk_50Hz;
            // $display("[%t] clk_50Hz edge: %b", $time, ~clk_50Hz);
        end else begin
            counter_50Hz <= counter_50Hz + 1;
        end
    end

    endmodule