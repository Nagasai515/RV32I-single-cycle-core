`timescale 1ns / 1ps

module pc (
    input  wire        clk,
    input  wire        reset,
    input  wire [31:0] next_pc,
    output reg  [31:0] pc
);

    always @(posedge clk) begin
        if (reset)
            pc <= 32'b0;         // Start from address 0
        else
            pc <= next_pc;       // Update PC
    end

endmodule
