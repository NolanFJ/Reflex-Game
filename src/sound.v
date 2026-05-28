module sound(
    input            clk,
    input      [7:0] volume,   // 0=silent, 255=max volume
    input      [9:0] N,        // tone frequency control
    output reg       sout
);
    reg [9:0] f_count;
    reg       f_clk;
    reg [7:0] dc_count;

    initial begin
        f_count  = 0;
        sout     = 0;
        f_clk    = 0;
        dc_count = 0;
    end

    // Stage 1: Frequency divider — only runs when volume > 0
    always @(posedge clk) begin
        if (volume == 0) begin
            f_count <= 0;
            f_clk   <= 0;    // hold f_clk low when silent
        end
        else if (f_count >= N) begin      
            f_count <= 0;
            f_clk   <= ~f_clk;
        end
        else
            f_count <= f_count + 1;
    end

    // Stage 2: Duty cycle
    always @(posedge f_clk) begin
        dc_count <= dc_count + 1;
        if (dc_count < volume)
            sout <= 1;
        else
            sout <= 0;
    end

endmodule