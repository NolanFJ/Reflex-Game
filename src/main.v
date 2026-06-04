/* 
main module should connect everything
- should have all the inputs necessary 
*/ 
module main (
    input clk_sys, 
    input rst, 
    input button_press, 

    output [6:0] seg,
    output dp,
    output [3:0] an,
    output AIN,
    output SHUTDOWN_N,
    output GAIN

);

    wire [3:0] digit_four;
    wire [3:0] digit_three;
    wire [3:0] digit_two;
    wire [3:0] digit_one;
    wire game_over;
    wire [2:0] press_count;

    wire [3:0] score_digit_four;
    wire [3:0] score_digit_three;
    wire [3:0] score_digit_two;
    wire [3:0] score_digit_one;

    wire first_clk; 
    wire second_clk; 
    wire third_clk; 
    wire fourth_clk;
    wire debouncer_clk;
    
    // Debounced inputs
    wire button_press_debounced;
    wire rst_debounced;

    reg game_over_prev;
    reg [27:0] sound_timer;
    wire play_sound = (sound_timer != 0);

    always @(posedge clk_sys or posedge rst) begin
        if (rst) begin
            game_over_prev <= 1'b0;
            sound_timer <= 28'd0;
        end else begin
            if (game_over) begin
                sound_timer <= 28'd100_000_000;
            end else if (sound_timer != 0) begin
                sound_timer <= sound_timer - 1;
            end
        end
    end

    assign SHUTDOWN_N = 1'b1;
    assign GAIN = 1'b0;

    clock_module clock_inst (
        .master_clk(clk_sys),
        .clk_5Hz(first_clk),
        .clk_10Hz(second_clk),
        .clk_15Hz(third_clk),
        .clk_18Hz(fourth_clk),
        .clk_50Hz(debouncer_clk)
    );

    // Debounce button press input
    debouncer button_debouncer (
        .clk(clk_sys),
        .rst(rst),
        .clk_en(debouncer_clk),
        .btn_in(button_press),
        .btn_out(button_press_debounced)
    );

    // Debounce reset input
    debouncer rst_debouncer (
        .clk(clk_sys),
        .rst(1'b0),
        .clk_en(debouncer_clk),
        .btn_in(rst),
        .btn_out(rst_debounced)
    );

    number num_inst (
        .clk_sys(clk_sys),
        .first_clk(first_clk),
        .second_clk(second_clk),
        .third_clk(third_clk),
        .fourth_clk(fourth_clk),
         .rst(rst_debounced),
        .button_press(button_press_debounced),
        .digit_four(digit_four),
        .digit_three(digit_three),
        .digit_two(digit_two),
        .digit_one(digit_one),
        .game_over(game_over),
        .press_count(press_count)
    );

    score score_inst (
        .clk_sys(clk_sys),
        .rst(rst_debounced),
        .game_over(game_over),
        .digit_four(digit_four),
        .digit_three(digit_three),
        .digit_two(digit_two),
        .digit_one(digit_one),
        .score_digit_four(score_digit_four),
        .score_digit_three(score_digit_three),
        .score_digit_two(score_digit_two),
        .score_digit_one(score_digit_one)
    );

    display disp_inst (
        .clk_sys(clk_sys),
        .digit_four(digit_four),
        .digit_three(digit_three),
        .digit_two(digit_two),
        .digit_one(digit_one),
        .rst(rst_debounced),
        .game_over(game_over),
        .score_digit_four(score_digit_four),
        .score_digit_three(score_digit_three),
        .score_digit_two(score_digit_two),
        .score_digit_one(score_digit_one),
        .button_press(button_press_debounced),
        .press_count(press_count),
        .seg(seg),
        .dp(dp),
        .an(an)
    );

    sound sound_inst (
        .clk(clk_sys),
        .volume(play_sound ? 8'd200 : 8'd0),
        .N(10'd400),
        .sout(AIN)  
    );

endmodule