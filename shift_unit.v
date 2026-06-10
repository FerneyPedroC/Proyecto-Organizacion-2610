module shift_unit #(parameter N = 8)
(
    input wire [1:0] shamt,
    input wire [N-1:0] dataa,
    output reg [N-1:0] dataout
);

always @* begin  //// @* significa  |vuelve a evaluar este bloque cuando cambie cualquier señal usada dentro
    case (shamt)
        2'b00: dataout = dataa;
        2'b01: dataout = {1'b0, dataa[N-1:1]};
        2'b10: dataout = {dataa[N-2:0], 1'b0};
        default: dataout = {N{1'b0}};
    endcase
end

endmodule
