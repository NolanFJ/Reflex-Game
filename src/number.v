/*
Inputs: 
    - clock 
    - button press
    - reset button press 

    
Outputs: 
    - each of the digits of the numbers (4 digits)
    
Questions: 
    - what should we do with this module when game is over? 
*/

module number (
    input clk_sys, 
    input first_clk, 
    input second_clk,
    input third_clk, 
    input fourth_clk,
    input rst, 
    input button_press, 
    output reg [3:0] digit_four,
    output reg [3:0] digit_three,
    output reg [3:0] digit_two,
    output reg [3:0] digit_one,
    output reg game_over 
);

    /* Track button press count */
    reg [2:0] press_count;
    reg button_press_prev;

    /* assign all the digits a random start digit */ 
    /* digit one to four is left to right so imagine digit one as the minute tens */ 
    initial begin
        digit_one = $random % 10;
        digit_two = $random % 10;
        digit_three = $random % 10;
        digit_four = $random % 10;
    end

    /* 
    Detect when the button is pressed 
        - keeps track of count of button presses to determine game end
        - only increments the corresponding digit based on button press count
    */
    always @ (posedge clk_sys) begin
        if (rst) begin
            press_count <= 3'd0;
            button_press_prev <= 1'b0;
        end else begin
            button_press_prev <= button_press;
            if (~button_press_prev && button_press) begin
                if (press_count == 3'd4) begin
                    game_over <= 1'b1; 
                end else begin
                    press_count <= press_count + 3'd1;
                    $display("Button pressed! Press count: %d", press_count + 1);
                end
            end
        end
    end

    /* on each clock edge increment corresponding digit by 1, reset to 0 if goes above 9 */ 

    always @ (posedge first_clk) begin
        if (rst) begin
            digit_one <= $random % 10;
        /* Only increment digit_one when press_count == 0 */ 
        end else if (press_count == 2'd0) begin
            if (digit_one == 9) begin
                digit_one <= 0;
            end else begin
                digit_one <= digit_one + 1;
            end
        end
    end
    
    always @ (posedge second_clk) begin
        if (rst) begin
            digit_two <= $random % 10;
        /* Only increment digit_two when press_count == 1 */ 
        end else if (press_count == 2'd1) begin
            if (digit_two == 9) begin
                digit_two <= 0;
            end else begin
                digit_two <= digit_two + 1;
            end
        end
    end
    
    always @ (posedge third_clk) begin
        if (rst) begin
            digit_three <= $random % 10;
        /* Only increment digit_three when press_count == 2 */ 
        end else if (press_count == 2'd2) begin
            if (digit_three == 9) begin
                digit_three <= 0;
            end else begin
                digit_three <= digit_three + 1;
            end
        end
    end
    
    always @ (posedge fourth_clk) begin
        if (rst) begin
            digit_four <= $random % 10;
        /* Only increment digit_four when press_count == 3 */ 
        end else if (press_count == 2'd3) begin
            if (digit_four == 9) begin
                digit_four <= 0;
            end else begin
                digit_four <= digit_four + 1;
            end
        end
    end
endmodule
