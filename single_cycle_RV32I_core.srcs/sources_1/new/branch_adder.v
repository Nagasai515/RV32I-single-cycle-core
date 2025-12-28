`timescale 1ns / 1ps

module branch_adder (
    input  wire [31:0] pc,
    input  wire [31:0] imm,
    output wire [31:0] branch_target
);

    assign branch_target = pc + imm;

endmodule
