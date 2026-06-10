module Paralregister #(
    parameter DATA_WIDTH = 8    // Ancho del registro (por defecto 8 bits)
)(
    input  wire                   clk,    // Reloj
    input  wire                   rst,    // Reset asíncrono activo en alto
    input  wire                   enable, // Habilitación de escritura
    input  wire [DATA_WIDTH-1:0]  d,      // Dato de entrada
    output reg  [DATA_WIDTH-1:0]  q       // Dato de salida
);

    // Proceso secuencial: escritura en flanco de subida del reloj
    // Reset asíncrono: se activa independientemente del reloj
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            q <= {DATA_WIDTH{1'b0}};   // Reset: lleva la salida a 0
        end else if (enable) begin
            q <= d;                     // Escritura: captura el dato de entrada
        end
        // Si enable=0 y rst=0: el registro mantiene su valor anterior
    end

endmodule
