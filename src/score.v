module score (
    input clk_sys,
    input rst,
    input game_over,
    input [3:0] digit_four,
    input [3:0] digit_three,
    input [3:0] digit_two,
    input [3:0] digit_one,
    output reg [3:0] score_digit_four,   // blank
    output reg [3:0] score_digit_three,  // blank
    output reg [3:0] score_digit_two,    // tens
    output reg [3:0] score_digit_one     // ones
);

    wire [13:0] raw = (digit_four  * 14'd1)
                    + (digit_three * 14'd2)
                    + (digit_two   * 14'd3)
                    + (digit_one   * 14'd4);

    wire [6:0] scaled = raw * 14'd100 / 14'd90;

    always @(posedge clk_sys) begin
        if (rst) begin
            score_digit_four  <= 4'hF;
            score_digit_three <= 4'hF;
            score_digit_two   <= 4'd0;
            score_digit_one   <= 4'd0;
        end else if (game_over) begin
            score_digit_four  <= 4'hF;
            score_digit_three <= 4'hF;
            score_digit_two   <= (scaled >= 7'd100) ? 4'd9 : scaled / 10;
            score_digit_one   <= (scaled >= 7'd100) ? 4'd9 : scaled % 10;
        end
    end

endmodule