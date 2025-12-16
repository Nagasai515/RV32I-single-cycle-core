module imm_gen (
    input  wire [31:0] instr,
    output reg  [31:0] imm_out
);

    wire [6:0] opcode = instr[6:0];

    always @(*) begin
        case (opcode)

            // -----------------------
            // I-TYPE (e.g., LW, ADDI)
            // -----------------------
            7'b0000011, // lw
            7'b0010011: // addi, andi, ori, etc.
                imm_out = {{21{instr[31]}}, instr[30:20]};

            // -----------------------
            // S-TYPE (SW)
            // -----------------------
            7'b0100011: // sw
                imm_out = {{21{instr[31]}}, instr[30:25], instr[11:7]};

            // -----------------------
            // B-TYPE (BEQ, BNE)
            // -----------------------
            7'b1100011: // beq, bne, blt, bge
                imm_out = {{20{instr[31]}}, instr[7], instr[30:25], instr[11:8], 1'b0};

            // -----------------------
            // DEFAULT (NOP)
            // -----------------------
            default: 
                imm_out = 32'd0;

        endcase
    end

endmodule
