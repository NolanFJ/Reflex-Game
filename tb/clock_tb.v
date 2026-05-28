`timescale 1ns/1ps
module clock_tb_fast;

    reg master_clk;
    wire clk_5Hz;
    wire clk_10Hz;
    wire clk_15Hz;
    wire clk_18Hz;
    wire clk_50Hz;

    time last_5Hz_edge  = 0;
    time last_10Hz_edge = 0;
    time last_15Hz_edge = 0;
    time last_18Hz_edge = 0;
    time last_50Hz_edge = 0;
    time current_period;

    // Scaled-down parameters so simulation finishes in microseconds
    // Formula: period = 2 * (COUNT+1) * 10ns
    // COUNT_5HZ  = 99  -> 2 * 100 * 10ns = 2000ns period
    // COUNT_10HZ = 49  -> 2 *  50 * 10ns = 1000ns period
    // COUNT_15HZ = 32  -> 2 *  33 * 10ns =  660ns period
    // COUNT_18HZ = 27  -> 2 *  28 * 10ns =  560ns period
    // COUNT_50HZ = 0   -> 2 *   1 * 10ns =   20ns period
    clock_module #(
        .COUNT_5HZ  (99),
        .COUNT_10HZ (49),
        .COUNT_15HZ (32),
        .COUNT_18HZ (27),
        .COUNT_50HZ (0)
    ) uut (
        .master_clk (master_clk),
        .clk_5Hz    (clk_5Hz),
        .clk_10Hz   (clk_10Hz),
        .clk_15Hz   (clk_15Hz),
        .clk_18Hz   (clk_18Hz),
        .clk_50Hz   (clk_50Hz)
    );

    // 100MHz master clock
    initial master_clk = 0;
    always #5 master_clk = ~master_clk;

    // Period measurement blocks
    always @(posedge clk_5Hz) begin
        if (last_5Hz_edge > 0) begin
            current_period = $time - last_5Hz_edge;
            $display("[%0t ns] clk_5Hz  period: %0t ns (expected 2000)", $time, current_period);
            if (current_period != 2000) $display("  -> ERROR: Incorrect 5Hz period!");
        end
        last_5Hz_edge = $time;
    end

    always @(posedge clk_10Hz) begin
        if (last_10Hz_edge > 0) begin
            current_period = $time - last_10Hz_edge;
            $display("[%0t ns] clk_10Hz period: %0t ns (expected 1000)", $time, current_period);
            if (current_period != 1000) $display("  -> ERROR: Incorrect 10Hz period!");
        end
        last_10Hz_edge = $time;
    end

    always @(posedge clk_15Hz) begin
        if (last_15Hz_edge > 0) begin
            current_period = $time - last_15Hz_edge;
            $display("[%0t ns] clk_15Hz period: %0t ns (expected 660)", $time, current_period);
            if (current_period != 660) $display("  -> ERROR: Incorrect 15Hz period!");
        end
        last_15Hz_edge = $time;
    end

    always @(posedge clk_18Hz) begin
        if (last_18Hz_edge > 0) begin
            current_period = $time - last_18Hz_edge;
            $display("[%0t ns] clk_18Hz period: %0t ns (expected 560)", $time, current_period);
            if (current_period != 560) $display("  -> ERROR: Incorrect 18Hz period!");
        end
        last_18Hz_edge = $time;
    end

    always @(posedge clk_50Hz) begin
        if (last_50Hz_edge > 0) begin
            current_period = $time - last_50Hz_edge;
            $display("[%0t ns] clk_50Hz period: %0t ns (expected 20)", $time, current_period);
            if (current_period != 20) $display("  -> ERROR: Incorrect 50Hz period!");
        end
        last_50Hz_edge = $time;
    end

    initial begin
        $display("Starting scaled-down clock simulation...");
        $display("------------------------------------------");
        #6000; // enough for 3 full cycles of the slowest (5Hz scaled = 2000ns)
        $display("------------------------------------------");
        $display("Simulation complete.");
        $finish;
    end

endmodule