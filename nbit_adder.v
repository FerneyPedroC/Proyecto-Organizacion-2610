module nbit_adder #(parameter N = 8) // Generic N
(
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    input wire cin,
    output wire [N-1:0] s,
    output wire cout
);

wire [N:0] carry; // Extended size for carry to include carry out
assign carry[0] = cin;

genvar i;
generate
    for (i = 0; i < N; i = i + 1) begin : adder
        full_adder fa(
            .a(a[i]),
            .b(b[i]),
            .cin(carry[i]),
            .s(s[i]),
            .cout(carry[i+1])
        );
    end
endgenerate

assign cout = carry[N]; // Carry out is the last bit of extended carry

endmodule