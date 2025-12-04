// ---------------------------
// 16-bit ALU with CLA adder
// ---------------------------
module alu16_cla (
    input  [15:0] a,
    input  [15:0] b,
    input  [3:0]  s,
    output reg [15:0] yout,
    output reg carry
);
    wire [15:0] add_res;
    wire [15:0] sub_res;
    wire        add_cout;
    wire        sub_cout;

    // CLA-based add and sub
    cla16_addsub add_unit (
        .a(a), .b(b), .sub(1'b0),
        .sum(add_res), .cout(add_cout)
    );

    cla16_addsub sub_unit (
        .a(a), .b(b), .sub(1'b1),
        .sum(sub_res), .cout(sub_cout)
    );

    always @(*) begin
        yout  = 16'd0;
        carry = 1'b0;

        case (s)
            4'b0000: begin // ADD
                yout  = add_res;
                carry = add_cout;
            end

            4'b0001: begin // SUB
                yout  = sub_res;
                carry = sub_cout;
            end

            4'b0010: yout = a | b;
            4'b0011: yout = a & b;
            4'b0100: yout = a ^ b;
            4'b0101: yout = ~a;
            4'b0110: yout = ~b;

            4'b0111: yout = (a > b) ? 16'h0001 : 16'h0000;
            4'b1000: yout = (a < b) ? 16'h0001 : 16'h0000;

            4'b1001: begin
                yout  = a >> 1;
                carry = a[0];
            end

            4'b1010: begin
                yout  = b >> 1;
                carry = b[0];
            end

            4'b1011: begin
                if (b != 0)
                    yout = a / b;
                else
                    yout = 16'd0;
            end

            4'b1100: yout = ~(a | b);
            4'b1101: yout = ~(a ^ b);
            4'b1110: yout = ~(a & b);

            4'b1111: begin
                // you CAN replace this with a CLA-based multiplier later if you want
                yout = (a * b); 
            end

            default: begin
                yout  = 16'd0;
                carry = 1'b0;
            end
        endcase
    end
endmodule
