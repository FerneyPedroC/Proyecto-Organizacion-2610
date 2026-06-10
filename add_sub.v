module add_sub #(parameter N = 8) // Generic N
(
    input wire [N-1:0] a,
    input wire [N-1:0] b,
    input wire addn_sub, // addn_sub: 0 for addition, 1 for subtraction
    output wire [N-1:0] s,
    output wire cout
);

wire [N-1:0] bxor;
wire [N-1:0] addn_sub_vector;

// Generate add_nsub_vector where all bits are equal to addn_sub
assign addn_sub_vector = {N{addn_sub}};

// XOR operation to prepare b for addition/subtraction
assign bxor = b ^ addn_sub_vector;

// Instantiate the n-bit adder for the actual addition/subtraction
nbit_adder #(.N(N)) adder_instance (
    .a(a),
    .b(bxor),
    .cin(addn_sub), // Use addn_sub as carry-in to control addition/subtraction
    .s(s),
    .cout(cout)
);

endmodule