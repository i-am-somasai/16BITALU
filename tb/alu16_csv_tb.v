`timescale 1ns/1ps

module alu16_csv_tb;
    // CONFIG: which ALU?
    // 0 = ripple, 1 = CLA
    integer ALU_ID = 1;

    reg  [15:0] a;
    reg  [15:0] b;
    reg  [3:0]  s;
    wire [15:0] yout;
    wire        carry;

    reg [15:0] prev_y;
    integer    toggles;
    integer    a_hw, b_hw;

    integer    i;
    integer    fh;
    
    /*
    // Choose ONE ALU here:
    // Baseline ripple:
    alu16_ripple dut (
        .a(a), .b(b), .s(s),
        .yout(yout), .carry(carry)
    );
    */
    // OR: Carry-lookahead ALU:
    alu16_cla dut (
        .a(a), .b(b), .s(s),
        .yout(yout), .carry(carry)
    );
    initial begin
        ALU_ID = 1;
    end

    // popcount function
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

    initial begin
        fh = $fopen("alu_data.csv", "w");
        if (fh == 0) begin
            $display("ERROR: Could not open file alu_data.csv");
            $finish;
        end

        // CSV header
        $fwrite(fh, "alu_id,opcode,a,b,a_hw,b_hw,y_toggles\n");

        // Init
        a      = 16'd0;
        b      = 16'd0;
        s      = 4'd0;
        prev_y = 16'd0;

        // generate N samples
        for (i = 0; i < 10000; i = i + 1) begin
            a = $random;
            b = $random;
            s = $random % 16; // 0..15

            #1; // let outputs settle

            a_hw   = popcount16(a);
            b_hw   = popcount16(b);
            toggles = popcount16(yout ^ prev_y);
            prev_y  = yout;

            $fwrite(fh, "%0d,%0d,%0d,%0d,%0d,%0d,%0d\n",
                    ALU_ID, s, a, b, a_hw, b_hw, toggles);
        end

        $fclose(fh);
        $finish;
    end
endmodule
