`timescale 1ns / 1ps

module instruction_memory (
    input  wire [31:0] address,
    output wire [31:0] instruction
);

    // 256 words × 32-bit = 1 KB instruction memory
    reg [31:0] mem [0:255];
    integer i;

initial begin
    // =====================================================
    // Register initialization
    // =====================================================
    mem[0]  = 32'h00500093; // addi x1, x0, 5
    mem[1]  = 32'h00A00113; // addi x2, x0, 10

    // =====================================================
    // R-type ALU operations
    // =====================================================
    mem[2]  = 32'h002081B3; // add  x3, x1, x2   = 15
    mem[3]  = 32'h40110233; // sub  x4, x2, x1   = 5
    mem[4]  = 32'h0020F2B3; // and  x5, x1, x2
    mem[5]  = 32'h0020E333; // or   x6, x1, x2
    mem[6]  = 32'h0020C3B3; // xor  x7, x1, x2

    // =====================================================
    // I-type ALU operations
    // =====================================================
    mem[7]  = 32'h00308413; // addi x8, x1, 3
    mem[8]  = 32'h0070F493; // andi x9, x1, 7
    mem[9]  = 32'h0080E513; // ori  x10, x1, 8

    // =====================================================
    // Memory operations
    // =====================================================
    mem[10] = 32'h00302023; // sw   x3, 0(x0)
    mem[11] = 32'h00002883; // lw   x17, 0(x0)

    // =====================================================
    // Branch instructions
    // =====================================================
    mem[12] = 32'h00388463; // beq  x17, x3, +8  (skip next)
    mem[13] = 32'h00100913; // addi x18, x0, 1   (skipped)

    mem[14] = 32'h00389463; // bne  x17, x3, +8  (not taken)
    mem[15] = 32'h00200993; // addi x19, x0, 2

    // =====================================================
    // Optional JALR test (safe)
    // x20 = PC+4, jump to itself+0 ? no PC corruption
    // =====================================================
    mem[16] = 32'h000A8067; // jalr x0, 0(x21)  (acts like NOP)

    // =====================================================
    // INFINITE LOOP (branch-based, supported)
    // =====================================================
    mem[17] = 32'h00000063; // beq x0, x0, 0  (infinite loop)

    // =====================================================
    // Fill rest with NOPs
    // =====================================================
    for (i = 18; i < 256; i = i + 1)
        mem[i] = 32'h00000013; // NOP (addi x0, x0, 0)
end

    // Word-aligned instruction fetch
    assign instruction = mem[address[9:2]];

endmodule
