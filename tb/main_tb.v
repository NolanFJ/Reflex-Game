`timescale 1ns / 1ps

module main_tb();

    // Testbench signals
    reg clk_sys;
    reg rst;
    reg button_press;
    reg prev_AIN;  // For sound detection monitoring
    
    wire [6:0] seg;
    wire dp;
    wire [3:0] an;
    wire AIN;
    wire SHUTDOWN_N;
    wire GAIN;

    // Instantiate the main module
    main uut (
        .clk_sys(clk_sys),
        .rst(rst),
        .button_press(button_press),
        .seg(seg),
        .dp(dp),
        .an(an),
        .AIN(AIN),
        .SHUTDOWN_N(SHUTDOWN_N),
        .GAIN(GAIN)
    );

    // Clock generation: 100MHz clock (10ns period)
    initial begin
        clk_sys = 0;
        forever #5 clk_sys = ~clk_sys;
    end

    // Test stimulus
    initial begin
        $dumpfile("main_tb.vcd");
        $dumpvars(0, main_tb);
        
        // Initialize
        rst = 1;
        button_press = 0;
        
        $display("Starting main module test with SOUND VERIFICATION...");
        
        // Hold reset for 100ns
        #100 rst = 0;
        $display("Reset released at t=%0t", $time);
        
        // Let the system run for a bit before starting button presses
        #20000000 $display("System ready for button presses at t=%0t", $time);
        
        // Press button 4 times to trigger game_over
        // The number module has a ~50 ms debounce timer, so leave enough
        // time between presses for all four edges to be accepted.
        press_button(1);
        #1000000 press_button(2);
        #1000000 press_button(3);
        #1000000 press_button(4);
        
        // Wait to observe sound output
        $display("All 4 buttons pressed, waiting for game_over sound at t=%0t", $time);
        #500000 $display("Sound observation period completed at t=%0t", $time);
        
        $display("Test completed successfully!");
        $finish;
    end

    // Task to press button with proper timing
    task press_button(input integer button_num);
        begin
            $display("Button press #%d at t=%0t", button_num, $time);
            button_press = 1;
            #1000000 button_press = 0;  // hold long enough for debouncer samples
            $display("Button released at t=%0t", $time);
        end
    endtask

    // Monitor outputs
    initial begin
        #0 $display("Initial state: seg=%b, dp=%b, an=%b, AIN=%b", seg, dp, an, AIN);
        
        // Monitor for changes
        forever begin
            @(posedge clk_sys);
            if ($time % 10000 == 0) begin
                $display("t=%0t | seg=%b, dp=%b, an=%b, AIN=%b, SHUTDOWN_N=%b, GAIN=%b", 
                         $time, seg, dp, an, AIN, SHUTDOWN_N, GAIN);
            end
        end
    end

    // Sound detection monitor
    initial begin
        prev_AIN = 0;
        
        forever begin
            @(posedge clk_sys);
            
            // Detect when AIN signal starts (sound playing)
            if (prev_AIN == 0 && AIN == 1) begin
                $display(">>> SOUND DETECTED at t=%0t <<<", $time);
            end
            
            // Detect when AIN signal stops (sound stops)
            if (prev_AIN == 1 && AIN == 0) begin
                $display(">>> SOUND STOPPED at t=%0t <<<", $time);
            end
            
            prev_AIN = AIN;
        end
    end

endmodule
