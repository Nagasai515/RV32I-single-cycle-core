`timescale 1ns / 1ps

module control_unit (
    input  wire [6:0] opcode,

    output reg        RegWrite,
    output reg        ALUSrc,
    output reg        MemRead,
    output reg        MemWrite,
    output reg        Branch,
    output reg        Jump,        // for jalr

    output reg [2:0]  ALUOp,
    output reg [2:0]  ImmType
);

    /*
        RV32I opcodes used:

        0110011 : R-type
        0010011 : I-type ALU (addi, andi, ori)
        0000011 : Load (lw)
        0100011 : Store (sw)
        1100011 : Branch (beq, bne)
        1100111 : JALR
        0110111 : LUI
    */

    always @(*) begin
        // -------------------------
        // DEFAULTS (very important)
        // -------------------------
        RegWrite = 0;
        ALUSrc   = 0;
        MemRead  = 0;
        MemWrite = 0;
        Branch   = 0;
        Jump     = 0;
        ALUOp    = 3'b000;
        ImmType  = 3'b000;

        case (opcode)

            // ---------------------------------
            // R-TYPE (add, sub, and, or, etc.)
            // ---------------------------------
            7'b0110011: begin
                RegWrite = 1;
                ALUSrc   = 0;
                ALUOp    = 3'b010; // R-type decode
            end

            // ---------------------------------
            // I-TYPE ALU (addi, andi, ori)
            // ---------------------------------
            7'b0010011: begin
                RegWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 3'b011; // I-type ALU
                ImmType  = 3'b000; // I-type immediate
            end

            // ---------------------------------
            // LOAD (lw)
            // ---------------------------------
            7'b0000011: begin
                RegWrite = 1;
                ALUSrc   = 1;
                MemRead  = 1;
                ALUOp    = 3'b000; // ADD (address calc)
                ImmType  = 3'b000; // I-type immediate
            end

            // ---------------------------------
            // STORE (sw)
            // ---------------------------------
            7'b0100011: begin
                ALUSrc   = 1;
                MemWrite = 1;
                ALUOp    = 3'b000; // ADD (address calc)
                ImmType  = 3'b001; // S-type immediate
            end

            // ---------------------------------
            // BRANCH (beq, bne)
            // ---------------------------------
            7'b1100011: begin
                Branch   = 1;
                ALUSrc   = 0;
                ALUOp    = 3'b001; // Branch compare
                ImmType  = 3'b010; // B-type immediate
            end

            // ---------------------------------
            // JALR
            // ---------------------------------
            7'b1100111: begin
                RegWrite = 1;
                Jump     = 1;
                ALUSrc   = 1;
                ALUOp    = 3'b000; // rs1 + imm
                ImmType  = 3'b000; // I-type immediate
            end

            // ---------------------------------
            // LUI
            // ---------------------------------
            7'b0110111: begin
                RegWrite = 1;
                ALUSrc   = 1;
                ALUOp    = 3'b100; // LUI operation
                ImmType  = 3'b011; // U-type immediate
            end

            default: begin
                // keep safe defaults
            end

        endcase
    end

endmodule

