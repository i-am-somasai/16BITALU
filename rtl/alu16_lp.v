// ----------------------------------------
// Low-power 16-bit ALU with clock enable
// ----------------------------------------
module alu16_lp (
    input        clk,
    input        en,   // enable (acts like clock gating)
    input  [15:0] a,
    input  [15:0] b,
    input  [3:0]  s,
    output reg [15:0] yout,
    output reg        carry
);
    wire [15:0] y_comb;
    wire        c_comb;

    // Use the ripple ALU as combinational core
    alu16_ripple core (
        .a(a),
        .b(b),
        .s(s),
        .yout(y_comb),
        .carry(c_comb)
    );

    always @(posedge clk) begin
        if (en) begin
            yout  <= y_comb;
            carry <= c_comb;
        end
        // else: hold old value → fewer toggles → less dynamic power
    end
endmodule
