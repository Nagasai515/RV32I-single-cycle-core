module control_unit (
    input  wire [6:0] opcode,
    output reg        RegWrite,
    output reg        ALUSrc,
    output reg        MemRead,
    output reg        MemWrite,
    output reg        MemToReg,
    output reg        Branch,
    output reg [1:0]  ALUOp
);

    always @(*) begin
        case (opcode)

            // -------------------------------------------------
            // R-TYPE (add, sub, and, or, xor, sll, srl, sra...)
            // opcode = 0110011
            // -------------------------------------------------
            7'b0110011: begin
                RegWrite = 1;
                ALUSrc   = 0;
                MemRead  = 0;
                MemWrite = 0;
                MemToReg = 0;
                Branch   = 0;
                ALUOp    = 2'b10;  // Use funct3/funct7
            end

            // -------------------------------------------------
            // LW (Load Word)
            // opcode = 0000011
            // -------------------------------------------------
            7'b0000011: begin
                RegWrite = 1;
                ALUSrc   = 1;      // Use immediate
                MemRead  = 1;
                MemWrite = 0;
                MemToReg = 1;      // Data from memory
                Branch   = 0;
                ALUOp    = 2'b00;  // ADD for address
            end

            // -------------------------------------------------
            // SW (Store Word)
            // opcode = 0100011
            // -------------------------------------------------
            7'b0100011: begin
                RegWrite = 0;
                ALUSrc   = 1;
                MemRead  = 0;
                MemWrite = 1;
                MemToReg = 0;      // Don't care
                Branch   = 0;
                ALUOp    = 2'b00;  // ADD for address
            end

            // -------------------------------------------------
            // BEQ (Branch if Equal)
            // opcode = 1100011
            // -------------------------------------------------
            7'b1100011: begin
                RegWrite = 0;
                ALUSrc   = 0;      // Use registers
                MemRead  = 0;
                MemWrite = 0;
                MemToReg = 0;      // Don't care
                Branch   = 1;
                ALUOp    = 2'b01;  // SUB for comparison
            end

            // -------------------------------------------------
            // ADDI (I-type ALU immediate)
            // opcode = 0010011
            // -------------------------------------------------
            7'b0010011: begin
                RegWrite = 1;
                ALUSrc   = 1;      // Immediate
                MemRead  = 0;
                MemWrite = 0;
                MemToReg = 0;      // ALU result
                Branch   = 0;
                ALUOp    = 2'b10;  // Use funct3 like R-type
            end

            // -------------------------------------------------
            // DEFAULT
            // -------------------------------------------------
            default: begin
                RegWrite = 0;
                ALUSrc   = 0;
                MemRead  = 0;
                MemWrite = 0;
                MemToReg = 0;
                Branch   = 0;
                ALUOp    = 2'b00;
            end

        endcase
    end

endmodule
