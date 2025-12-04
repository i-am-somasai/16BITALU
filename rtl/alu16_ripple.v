// ---------------------------
// Baseline 16-bit ALU (ripple)
// ---------------------------
module alu16_ripple (
    input  [15:0] a,
    input  [15:0] b,
    input  [3:0]  s,
    output reg [15:0] yout,
    output reg carry
);
    reg [31:0] temp;

    always @(*) begin
        yout  = 16'd0;
        carry = 1'b0;
        temp  = 32'd0;

        case (s)
            4'b0000: begin // ADD
                temp  = a + b;
                yout  = temp[15:0];
                carry = temp[16];
            end

            4'b0001: begin // SUB
                temp  = a - b;
                yout  = temp[15:0];
                carry = temp[16];
            end

            4'b0010: yout = a | b;              // OR
            4'b0011: yout = a & b;              // AND
            4'b0100: yout = a ^ b;              // XOR
            4'b0101: yout = ~a;                 // NOT A
            4'b0110: yout = ~b;                 // NOT B

            4'b0111: yout = (a > b) ? 16'h0001 : 16'h0000; // A>B
            4'b1000: yout = (a < b) ? 16'h0001 : 16'h0000; // A<B

            4'b1001: begin                      // A >> 1
                yout  = a >> 1;
                carry = a[0];                   // bit shifted out
            end

            4'b1010: begin                      // B >> 1
                yout  = b >> 1;
                carry = b[0];
            end

            4'b1011: begin                      // A / B
                if (b != 0)
                    yout = a / b;
                else
                    yout = 16'd0;
            end

            4'b1100: yout = ~(a | b);           // NOR
            4'b1101: yout = ~(a ^ b);           // XNOR
            4'b1110: yout = ~(a & b);           // NAND

            4'b1111: begin                      // A * B
                temp = a * b;
                yout = temp[15:0];
            end

            default: begin
                yout  = 16'd0;
                carry = 1'b0;
            end
        endcase
    end
endmodule
