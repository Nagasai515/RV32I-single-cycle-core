`timescale 1ns / 1ps

module imm_gen (
    input  wire [31:0] instr,
    output reg  [31:0] imm_out
);

    wire [6:0] opcode = instr[6:0];

    always @(*) begin
        case (opcode)

            // -----------------------
            // I-TYPE
            // addi, andi, ori, lw, jalr
            // imm[11:0] = instr[31:20]
            // -----------------------
            7'b0010011, // addi, andi, ori
            7'b0000011, // lw
            7'b1100111: // jalr
                imm_out = {{20{instr[31]}}, instr[31:20]};

            // -----------------------
            // S-TYPE
            // sw
            // imm = instr[31:25] | instr[11:7]
            // -----------------------
            7'b0100011:
                imm_out = {{20{instr[31]}}, instr[31:25], instr[11:7]};

            // -----------------------
            // B-TYPE
            // beq, bne
            // imm = {instr[31], instr[7], instr[30:25], instr[11:8], 0}
            // -----------------------
            7'b1100011:
                imm_out = {{19{instr[31]}},
                           instr[31],
                           instr[7],
                           instr[30:25],
                           instr[11:8],
                           1'b0};

            // -----------------------
            // U-TYPE
            // lui
            // imm = instr[31:12] << 12
            // -----------------------
            7'b0110111:
                imm_out = {instr[31:12], 12'b0};

            // -----------------------
            // DEFAULT
            // -----------------------
            default:
                imm_out = 32'd0;

        endcase
    end

endmodule
