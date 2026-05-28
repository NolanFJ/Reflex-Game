`timescale 1ns/1ps

module number_tb;

    // Clock and control signals
    reg clk_sys;
    reg rst;
    reg button_press;
    
    // Outputs from DUT
    wire [3:0] digit_four;
    wire [3:0] digit_three;
    wire [3:0] digit_two;
    wire [3:0] digit_one;
    wire game_over;
    
    // Divided clocks from clock module
    wire first_clk;
    wire second_clk;
    wire third_clk;
    wire fourth_clk;
    wire debouncer_clk;

    // Instantiate clock module to generate divided clocks
    clock_module clk_inst (
        .master_clk(clk_sys),
        .clk_5Hz(first_clk),
        .clk_10Hz(second_clk),
        .clk_15Hz(third_clk),
        .clk_18Hz(fourth_clk),
        .clk_50Hz(debouncer_clk) 
    );

    // Instantiate number module (Device Under Test)
    number dut (
        .clk_sys(clk_sys),
        .first_clk(first_clk),
        .second_clk(second_clk),
        .third_clk(third_clk),
        .fourth_clk(fourth_clk),
        .rst(rst),
        .button_press(button_press),
        .digit_four(digit_four),
        .digit_three(digit_three),
        .digit_two(digit_two),
        .digit_one(digit_one),
        .game_over(game_over)
    );

    // Generate clk_sys (e.g., 100 MHz = 10ns period)
    initial begin
        clk_sys = 0;
        forever #5 clk_sys = ~clk_sys;
    end

    // Main test
    initial begin
        $dumpfile("number_tb.vcd");
        $dumpvars(0, number_tb);
        
        // Initialize
        button_press = 0;
        rst = 1;
        #100;
        rst = 0;
        #100;
        
        $display("=== Starting Number Module Test ===");
        $display("Time: %t | D4:%d D3:%d D2:%d D1:%d | Press_count: %d", 
                 $time, digit_four, digit_three, digit_two, digit_one, dut.press_count);
        
        // Let digits rotate on their clocks for a bit
        #100_000;
        $display("Time: %t | D4:%d D3:%d D2:%d D1:%d | After rotation", 
                 $time, digit_four, digit_three, digit_two, digit_one);
        
        // Press button - move to digit_two
        #50_000;
        button_press = 1;
        #100;
        button_press = 0;
        #50_000;
        $display("Time: %t | D4:%d D3:%d D2:%d D1:%d | After button 1", 
                 $time, digit_four, digit_three, digit_two, digit_one);
        
        // Let digit_two rotate
        #100_000;
        $display("Time: %t | D4:%d D3:%d D2:%d D1:%d | D2 rotating", 
                 $time, digit_four, digit_three, digit_two, digit_one);
        
        // Press button - move to digit_three
        #50_000;
        button_press = 1;
        #100;
        button_press = 0;
        #50_000;
        $display("Time: %t | D4:%d D3:%d D2:%d D1:%d | After button 2", 
                 $time, digit_four, digit_three, digit_two, digit_one);
        
        // Let digit_three rotate
        #100_000;
        $display("Time: %t | D4:%d D3:%d D2:%d D1:%d | D3 rotating", 
                 $time, digit_four, digit_three, digit_two, digit_one);
        
        // Press button - move to digit_four
        #50_000;
        button_press = 1;
        #100;
        button_press = 0;
        #50_000;
        $display("Time: %t | D4:%d D3:%d D2:%d D1:%d | After button 3", 
                 $time, digit_four, digit_three, digit_two, digit_one);
        
        // Let digit_four rotate
        #100_000;
        $display("Time: %t | D4:%d D3:%d D2:%d D1:%d | D4 rotating", 
                 $time, digit_four, digit_three, digit_two, digit_one);
        
        // Press button 4 times - game over
        #50_000;
        button_press = 1;
        #100;
        button_press = 0;
        #100;
        $display("Time: %t | Game Over: %b", $time, game_over);
        
        #50_000;
        $finish;
    end

    // Monitor changes
    always @(posedge button_press) begin
        $display("Button pressed at %t | Press count: %d", $time, dut.press_count);
    end

endmodule