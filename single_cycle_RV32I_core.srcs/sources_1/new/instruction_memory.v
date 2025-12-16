module instruction_memory (
    input  wire [31:0] address,
    output wire [31:0] instruction
);

    reg [31:0] mem [0:255];
    integer i;

    initial begin
        // Program
          mem[0]  = 32'h00500093; // addi x1, x0, 5
        mem[1]  = 32'h00a00113; // addi x2, x0, 10
        mem[2]  = 32'h002081b3; // add  x3, x1, x2
        mem[3]  = 32'h00300023; // sw   x3, 0(x0)
        mem[4]  = 32'h00002203; // lw   x4, 0(x0)
        mem[5]  = 32'h00320263; // beq  x4, x3, +8
        mem[6]  = 32'h06300293; // addi x5, x0, 99 (skipped)
        mem[7]  = 32'h00320333; // add  x6, x4, x3
        mem[8]  = 32'h00600223; // sw   x6, 4(x0)
        mem[9]  = 32'h00402383; // lw   x7, 4(x0)
        mem[10] = 32'h00638463; // beq  x7, x6, +8
        mem[11] = 32'h07b00413; // addi x8, x0, 123 (skipped)
        mem[12] = 32'h00148493; // addi x9, x9, 1
        mem[13] = 32'h00948463; // beq  x9, x9, -4 (loop)

        // Fill rest with NOPs
        for (i = 6; i < 256; i = i + 1)
            mem[i] = 32'h00000013;
    end

    assign instruction = mem[address[9:2]];

endmodule
