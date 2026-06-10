module registro_mdr (
    input  wire       clk,
    input  wire       rst,

    input  wire       mdr_en,
    input  wire       mdr_alu_n,

    input  wire [7:0] bus_alu,
    input  wire [7:0] DATA_EX_in,

    output wire [7:0] bus_C,
    output wire [7:0] BUS_DATA_OUT
);

    reg [7:0] reg_top;
    reg [7:0] reg_bot;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_top <= 8'h00;
        end
        else if (mdr_en) begin
            reg_top <= DATA_EX_in;
        end
    end

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            reg_bot <= 8'h00;
        end
        else if (mdr_en) begin
            reg_bot <= bus_alu;
        end
    end

    assign bus_C = (mdr_alu_n) ? reg_top : bus_alu;

    assign BUS_DATA_OUT = reg_bot;

endmodule