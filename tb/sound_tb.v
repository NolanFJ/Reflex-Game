`timescale 1ns / 1ps

module sound_tb;

    // Inputs (regs to drive)
    reg        clk;
    reg  [7:0] volume;
    reg  [9:0] N;

    // Output (wire to observe)
    wire       sout;

    // Instantiate the module
    sound uut (
        .clk    (clk),
        .volume (volume),
        .N      (N),
        .sout   (sout)
    );

    // Clock: 100MHz → 10ns period
    initial clk = 0;
    always #5 clk = ~clk;  // toggle every 5ns

    // Test sequence
    initial begin
        // Setup waveform dump (for GTKWave or Vivado sim)
        $dumpfile("sound_tb.vcd");
        $dumpvars(0, sound_tb);

        // --- Test 1: Silence ---
        // volume=0 means sout should stay 0
        volume = 8'd0;
        N      = 10'd50;
        #10000;  // wait 10,000ns
        $display("Test 1 DONE: Silence (volume=0), N=50");

        // --- Test 2: Mid tone, half volume ---
        // N=50 → f_clk freq = 100MHz / (2*50) = 1MHz
        // volume=128 → 50% duty cycle
        volume = 8'd128;
        N      = 10'd50;
        #50000;  // wait 50,000ns to see several cycles
        $display("Test 2 DONE: Mid tone, N=50, volume=128");

        // --- Test 3: High tone, full volume ---
        // N=10 → f_clk freq = 100MHz / (2*10) = 5MHz
        // volume=255 → ~100% duty cycle
        volume = 8'd255;
        N      = 10'd10;
        #50000;
        $display("Test 3 DONE: High tone, N=10, volume=255");

        // --- Test 4: Low tone, low volume ---
        // N=500 → f_clk freq = 100MHz / (2*500) = 100kHz
        // volume=30 → ~12% duty cycle
        volume = 8'd30;
        N      = 10'd500;
        #200000;
        $display("Test 4 DONE: Low tone, N=500, volume=30");

        // --- Test 5: Volume change mid-tone ---
        // Change volume while tone is playing
        N      = 10'd100;
        volume = 8'd50;
        #30000;
        $display("Volume changing...");
        volume = 8'd150;
        #30000;
        volume = 8'd255;
        #30000;
        $display("Test 5 DONE: Volume sweep");

        // --- Test 6: N=0 edge case ---
        // N=0 means f_count >= 0 is always true → f_clk toggles every clock
        // Just making sure it doesn't hang or crash
        volume = 8'd128;
        N      = 10'd0;
        #20000;
        $display("Test 6 DONE: Edge case N=0");

        $display("All tests complete.");
        $finish;
    end
    
    // print sout changes
    always @(sout) begin
        $display("Time=%0t  sout changed to %b", $time, sout);
    end

endmodule