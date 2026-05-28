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
    output [3:0] an
);

    wire [3:0] digit_four;
    wire [3:0] digit_three;
    wire [3:0] digit_two;
    wire [3:0] digit_one;
    wire game_over;

    wire first_clk; 
    wire second_clk; 
    wire third_clk; 
    wire fourth_clk;
    wire debouncer_clk;

    clock clock_inst (
        .clk_sys(clk_sys),
        .clk_5hz(first_clk),
        .clk_10hz(second_clk),
        .clk_15hz(third_clk),
        .clk_18hz(fourth_clk)
        .clk_50hz(debouncer_clk)
    );

    number num_inst (
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

    score score_inst (
        .clk_sys(clk_sys),
        .rst(rst),
        .game_over(game_over),
        .button_press(button_press),
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
        .game_over(game_over),
        .button_press(button_press),
        .seg(seg),
        .dp(dp),
        .an(an)
    );

endmodule