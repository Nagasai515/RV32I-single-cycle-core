module alu_control (
    input  wire [1:0]  ALUOp,       // from main Control Unit
    input  wire [2:0]  funct3,      // instr[14:12]
    input  wire        funct7b5,    // instr[30] (bit 5 of funct7)
    output reg  [3:0]  alu_control  // to ALU
);

    always @(*) begin
        case (ALUOp)

            // --------------------------------
            // LW, SW ? always ADD
            // --------------------------------
            2'b00: alu_control = 4'b0010;   // ADD

            // --------------------------------
            // BEQ ? use SUB
            // --------------------------------
            2'b01: alu_control = 4'b0110;   // SUB

            // --------------------------------
            // R-type ? use funct3 + funct7
            // --------------------------------
            2'b10: begin
                case (funct3)
                    
                    3'b000: begin
                        // ADD or SUB
                        if (funct7b5 == 1'b1)
                            alu_control = 4'b0110;   // SUB
                        else
                            alu_control = 4'b0010;   // ADD
                    end

                    3'b111: alu_control = 4'b0000;   // AND
                    3'b110: alu_control = 4'b0001;   // OR
                    3'b100: alu_control = 4'b0011;   // XOR

                    3'b001: alu_control = 4'b0100;   // SLL
                    3'b101: begin
                        if (funct7b5 == 1'b1)
                            alu_control = 4'b0111;   // SRA
                        else
                            alu_control = 4'b0101;   // SRL
                    end

                    3'b010: alu_control = 4'b1000;   // SLT

                    default: alu_control = 4'b0000;
                endcase
            end

            // --------------------------------
            // Default
            // --------------------------------
            default: alu_control = 4'b0000;

        endcase
    end

endmodule
