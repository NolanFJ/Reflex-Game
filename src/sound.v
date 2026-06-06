module sound(
    input            clk,
    input      [9:0] N,          // tone frequency control
    input            game_over,
    output reg       sout
);
    reg [9:0] f_count;
    reg       f_clk;
    reg [7:0] dc_count;
    reg       game_over_prev;    // Track previous game_over state for edge detection
    
    // Internal play timer: play for fixed duration (2 seconds @ 100 MHz)
    localparam [27:0] SOUND_DURATION_CYCLES = 28'd200_000_000; 
    reg [27:0] play_timer;
    reg [7:0] latched_volume;    // Latch the volume when triggered
    reg [9:0] latched_N;         // Latch the tone frequency when triggered

    initial begin
        f_count        = 0;
        sout           = 0;
        f_clk          = 0;
        dc_count       = 0;
        game_over_prev = 0;
        play_timer     = 28'd0;
        latched_volume = 8'd0;
        latched_N      = 10'd0;
    end

    // Stage 1: Frequency divider with duty cycle
    always @(posedge clk) begin

        // Detect rising edge of game_over
        if (game_over && !game_over_prev) begin
            play_timer     <= SOUND_DURATION_CYCLES;
            latched_volume <= 8'd150; // High volume for clear audibility
            
            // If incoming N is too small or zero, default to a audible mid-range frequency
            if (N < 10'd50) begin
                latched_N <= 10'd512; 
            end else begin
                latched_N <= N;
            end
            
            $display("[sound.v] Game Over triggered! Playing sound for 2 seconds at t=%0t", $time);
        end 
        // Decrement timer if running
        else if (play_timer != 0) begin
            play_timer <= play_timer - 1;
        end

        // Update previous state for edge detection
        game_over_prev <= game_over;

        // Output Generation Logic
        if (play_timer == 0) begin
            f_count  <= 0;
            f_clk    <= 0;
            dc_count <= 0;
            sout     <= 0;
        end else begin
            // Playback active: scale frequency based on latched_N
            if (f_count >= latched_N) begin
                f_count  <= 0;
                f_clk    <= ~f_clk;
                dc_count <= 0;
            end else begin
                f_count  <= f_count + 1;
                dc_count <= dc_count + 1;
            end

            // Set PWM output based on the latched duty cycle (volume)
            if (dc_count < latched_volume)
                sout <= 1;
            else
                sout <= 0;
        end
    end

endmodule