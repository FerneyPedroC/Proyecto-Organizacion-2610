module paralregisterSclear #(
    parameter DATA_WIDTH = 8   // Ancho del registro (por defecto 8 bits)
)(
    input  wire                  clk,     // Reloj
    input  wire                  rst,     // Reset asíncrono activo en alto
    input  wire                  sclr,    // Clear síncrono
    input  wire                  enable,  // Habilitación de escritura
    input  wire [DATA_WIDTH-1:0] d,       // Dato de entrada
    output reg  [DATA_WIDTH-1:0] q        // Dato de salida
);

    // =====================================================
    // REGISTRO PARALELO CON:
    // - Reset asíncrono
    // - Clear síncrono
    // - Enable de escritura
    // =====================================================

    always @(posedge clk or posedge rst) begin

        // ---------------------------------------------
        // RESET ASÍNCRONO
        // ---------------------------------------------
        if (rst) begin
            q <= {DATA_WIDTH{1'b0}};
        end

        // ---------------------------------------------
        // ESCRITURA HABILITADA
        // ---------------------------------------------
        else if (enable) begin

            // -----------------------------------------
            // CLEAR SÍNCRONO
            // -----------------------------------------
            if (sclr) begin
                q <= {DATA_WIDTH{1'b0}};
            end

            // -----------------------------------------
            // CARGA NORMAL
            // -----------------------------------------
            else begin
                q <= d;
            end
        end

        // Si enable = 0:
        // el registro conserva su valor

    end

endmodule