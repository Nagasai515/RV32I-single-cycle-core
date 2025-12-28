`timescale 1ns / 1ps

module top_cpu (
    input wire clk,
    input wire reset
);

    // =========================================================
    // PC and Next PC Logic
    // =========================================================
    wire [31:0] pc, pc_next, pc_plus4, branch_target;

    pc PC_REG (
        .clk(clk),
        .reset(reset),
        .next_pc(pc_next),
        .pc(pc)
    );

    pc_adder PC_PLUS4 (
        .pc(pc),
        .pc_plus_4(pc_plus4)
    );

    // =========================================================
    // Instruction Memory
    // =========================================================
    wire [31:0] instr;

    instruction_memory IMEM (
        .address(pc),
        .instruction(instr)
    );

    // =========================================================
    // Instruction Fields
    // =========================================================
    wire [6:0] opcode = instr[6:0];
    wire [4:0] rd     = instr[11:7];
    wire [2:0] funct3 = instr[14:12];
    wire [4:0] rs1    = instr[19:15];
    wire [4:0] rs2    = instr[24:20];
    wire [6:0] funct7 = instr[31:25];

    // =========================================================
    // Control Unit
    // =========================================================
    wire RegWrite, ALUSrc, MemRead, MemWrite, Branch, Jump;
    wire [2:0] ALUOp;

    control_unit CU (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .Branch(Branch),
        .Jump(Jump),
        .ALUOp(ALUOp)
    );

    // =========================================================
    // Register File
    // =========================================================
    wire [31:0] rs1_data, rs2_data, wb_data;

    register_file RF (
        .clk(clk),
        .reg_write(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(wb_data),
        .read_data1(rs1_data),
        .read_data2(rs2_data)
    );

    // =========================================================
    // Immediate Generator
    // =========================================================
    wire [31:0] imm;

    imm_gen IMMGEN (
        .instr(instr),
        .imm_out(imm)
    );

    // =========================================================
    // ALU input mux
    // =========================================================
    wire [31:0] alu_in2;

    mux2 ALUSRC_MUX (
        .in0(rs2_data),
        .in1(imm),
        .sel(ALUSrc),
        .out(alu_in2)
    );

    // =========================================================
    // ALU Control
    // =========================================================
    wire [3:0] alu_ctrl;

    alu_control ALUCTRL (
        .funct3(funct3),
        .funct7(funct7),
        .alu_op(ALUOp),
        .alu_ctrl(alu_ctrl)
    );

    // =========================================================
    // ALU
    // =========================================================
    wire [31:0] alu_result;
    wire zero;

    alu ALU_MAIN (
        .a(rs1_data),
        .b(alu_in2),
        .alu_ctrl(alu_ctrl),
        .result(alu_result),
        .zero(zero)
    );

    // =========================================================
    // Data Memory
    // =========================================================
    wire [31:0] mem_data;

    data_memory DMEM (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(alu_result),
        .write_data(rs2_data),
        .read_data(mem_data)
    );

    // =========================================================
    // Branch Target Adder
    // =========================================================
    branch_adder BR_ADD (
        .pc(pc),
        .imm(imm),
        .branch_target(branch_target)
    );

    // =========================================================
    // Branch Decision Logic (TOP-LEVEL ONLY)
    // =========================================================
    reg branch_taken;

    always @(*) begin
        branch_taken = 1'b0;
        if (Branch) begin
            case (funct3)
                3'b000: branch_taken = zero;     // BEQ
                3'b001: branch_taken = ~zero;    // BNE
                default: branch_taken = 1'b0;
            endcase
        end
    end

    // =========================================================
    // JALR target (TOP-LEVEL ONLY)
    // =========================================================
    wire [31:0] jalr_target = alu_result & ~32'b1;

    // =========================================================
    // Write Back MUX (TOP-LEVEL ONLY)
    // =========================================================
    assign wb_data =
        Jump     ? pc_plus4 :
        MemRead ? mem_data :
                   alu_result;

    // =========================================================
    // Next PC Selection (TOP-LEVEL ONLY)
    // =========================================================
    assign pc_next =
        Jump         ? jalr_target :
        branch_taken ? branch_target :
                        pc_plus4;

endmodule
