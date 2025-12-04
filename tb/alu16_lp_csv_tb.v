`timescale 1ns/1ps

module alu16_lp_csv_tb;

    // -------------------------------------------------
    // CONFIG
    // -------------------------------------------------
    integer ALU_ID = 2;   // 2 = low power ALU

    // -------------------------------------------------
    // Signals
    // -------------------------------------------------
    reg         clk;
    reg         en;
    reg  [15:0] a;
    reg  [15:0] b;
    reg  [3:0]  s;
    wire [15:0] yout;
    wire        carry;

    reg  [15:0] prev_y;
    integer     toggles;
    integer     a_hw, b_hw;

    integer     i;
    integer     fh;

    // -------------------------------------------------
    // DUT
    // -------------------------------------------------
    alu16_lp dut (
        .clk   (clk),
        .en    (en),
        .a     (a),
        .b     (b),
        .s     (s),
        .yout  (yout),
        .carry (carry)
    );

    // -------------------------------------------------
    // Popcount function
    // -------------------------------------------------
    function integer popcount16;
        input [15:0] x;
        integer k;
        begin
            popcount16 = 0;
            for (k = 0; k < 16; k = k + 1)
                if (x[k])
                    popcount16 = popcount16 + 1;
        end
    endfunction

    // -------------------------------------------------
    // Clock generation (100 MHz)
    // -------------------------------------------------
    initial begin
        clk = 1'b0;
        forever #5 clk = ~clk;
    end

    // -------------------------------------------------
    // Main stimulus + CSV logging
    // -------------------------------------------------
    initial begin
        // ----------------------------
        // Open CSV file
        // ----------------------------
        fh = $fopen("alu_data_lp.csv", "w");
        if (fh == 0) begin
            $display("ERROR: could not open alu_data_lp.csv");
            $finish;
        end

        // Write CSV header
        $fwrite(fh,
            "alu_id,opcode,a,b,a_hw,b_hw,en,y_toggles\n");
        $fflush(fh);

        // Init
        a = 0; 
        b = 0; 
        s = 0; 
        en = 1;
        prev_y = 0;

        // Small time so simulator settles
        #20;

        // ----------------------------
        // Generate samples
        // ----------------------------
        for (i = 0; i < 10000; i = i + 1) begin

            // Drive random inputs
            a = $random;
            b = $random;
            s = $random % 16;

            // Enable pattern:
            // 3 cycles ON, 1 cycle OFF (realistic gating)
            if ((i % 4) == 0)
                en = 0;
            else
                en = 1;

            // Wait for registered update
            @(posedge clk);
            #2;   // ? allow nonblocking updates to settle

            // Feature extraction
            a_hw    = popcount16(a);
            b_hw    = popcount16(b);
            toggles = popcount16(yout ^ prev_y);
            prev_y  = yout;

            // Write row
            $fwrite(fh, "%0d,%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                    ALU_ID, s, a, b, a_hw, b_hw, en, toggles);

            // ? force Vivado to flush buffer
            $fflush(fh);
        end

        // ----------------------------
        // Finalize file
        // ----------------------------
        #50;          // ? CRITICAL: allow write buffer to commit
        $fclose(fh);

        $display("Low-power ALU CSV generation DONE.");
        $finish;
    end

endmodule
