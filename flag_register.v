module flag_register #(parameter MAX_WIDTH = 8)
(
    input wire clk,
    input wire rst,
    input wire enaf,
    input wire [MAX_WIDTH-1:0] dataa,
    input wire carry,
    output reg C,
    output reg N,
    output reg P,
    output reg Z
);

// (Opcional) Inicialización para simulación
initial begin
    C = 1'b0;
    N = 1'b0;
    P = 1'b0;
    Z = 1'b0;
end

// Flip-flops: actualización en flanco de reloj
always @(posedge clk or posedge rst) begin
    if (rst) begin
        C <= 1'b0;
        N <= 1'b0;
        P <= 1'b0;
        Z <= 1'b0;
    end 
    else if (enaf) begin
        C <= carry;                         // Carry
        N <= dataa[MAX_WIDTH-1];           // Bit más significativo (signo)
        P <= ~dataa[MAX_WIDTH-1] & |dataa; // Positivo: MSB=0 y no cero
        Z <= (dataa == {MAX_WIDTH{1'b0}}); // Cero
    end
end

endmodule
