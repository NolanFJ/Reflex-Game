`timescale 1ns / 1ps

module main_tb();

    // Testbench signals
    reg clk_sys;
    reg rst;
    reg button_press;
    
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
        
        $display("Starting main module test...");
        
        // Hold reset for 100ns
        #100 rst = 0;
        $display("Reset released at t=%0t", $time);
        
        // Let the system run for a bit
        #1000 $display("System running normally at t=%0t", $time);
        
        // Test button press
        #1000 button_press = 1;
        $display("Button pressed at t=%0t", $time);
        
        #50 button_press = 0;
        $display("Button released at t=%0t", $time);
        
        // Let the system run for more time to see game behavior
        #5000 $display("Test continuing at t=%0t", $time);
        
        // Another button press
        #1000 button_press = 1;
        $display("Button pressed again at t=%0t", $time);
        
        #50 button_press = 0;
        $display("Button released at t=%0t", $time);
        
        // Run for extended period to observe gameplay
        #10000 $display("Final observation at t=%0t", $time);
        
        $display("Test completed successfully!");
        $finish;
    end

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

endmodule
