module top_cpu (
    input wire clk,
    input wire reset
);

    // -------------------------
    // PC and Next PC Logic
    // -------------------------
    wire [31:0] pc, next_pc, pc_plus_4, branch_target;

    pc PC_REG (
        .clk(clk),
        .reset(reset),
        .next_pc(next_pc),
        .pc(pc)
    );

    pc_adder PC_PLUS4 (
        .pc(pc),
        .pc_plus_4(pc_plus_4)
    );

    // -------------------------
    // Instruction Memory
    // -------------------------
    wire [31:0] instruction;

    instruction_memory IMEM (
        .address(pc),
        .instruction(instruction)
    );

    // -------------------------
    // Instruction Fields
    // -------------------------
    wire [4:0] rs1 = instruction[19:15];
    wire [4:0] rs2 = instruction[24:20];
    wire [4:0] rd  = instruction[11:7];

    wire [2:0] funct3 = instruction[14:12];
    wire       funct7b5 = instruction[30];
    wire [6:0] opcode = instruction[6:0];

    // -------------------------
    // Control Unit
    // -------------------------
    wire RegWrite, ALUSrc, MemRead, MemWrite, MemToReg, Branch;
    wire [1:0] ALUOp;

    control_unit CU (
        .opcode(opcode),
        .RegWrite(RegWrite),
        .ALUSrc(ALUSrc),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .MemToReg(MemToReg),
        .Branch(Branch),
        .ALUOp(ALUOp)
    );

    // -------------------------
    // Register File
    // -------------------------
    wire [31:0] reg_data1, reg_data2;
    wire [31:0] write_back_data;

    register_file RF (
        .clk(clk),
        .reg_write(RegWrite),
        .rs1(rs1),
        .rs2(rs2),
        .rd(rd),
        .write_data(write_back_data),
        .read_data1(reg_data1),
        .read_data2(reg_data2)
    );

    // -------------------------
    // Immediate Generator
    // -------------------------
    wire [31:0] immediate;

    imm_gen IMMGEN (
        .instr(instruction),
        .imm_out(immediate)
    );

    // -------------------------
    // ALU Input MUX (ALUSrc)
    // -------------------------
    wire [31:0] alu_B;

    mux2 ALU_SRC_MUX (
        .in0(reg_data2),
        .in1(immediate),
        .sel(ALUSrc),
        .out(alu_B)
    );

    // -------------------------
    // ALU Control
    // -------------------------
    wire [3:0] alu_control_signal;

    alu_control ALUCTRL (
        .ALUOp(ALUOp),
        .funct3(funct3),
        .funct7b5(funct7b5),
        .alu_control(alu_control_signal)
    );

    // -------------------------
    // ALU
    // -------------------------
    wire [31:0] alu_result;
    wire zero_flag;

    alu ALU_MAIN (
        .A(reg_data1),
        .B(alu_B),
        .alu_control(alu_control_signal),
        .result(alu_result),
        .zero(zero_flag)
    );

    // -------------------------
    // Data Memory
    // -------------------------
    wire [31:0] mem_data;

    data_memory DMEM (
        .clk(clk),
        .MemRead(MemRead),
        .MemWrite(MemWrite),
        .address(alu_result),
        .write_data(reg_data2),
        .read_data(mem_data)
    );

    // -------------------------
    // Write Back MUX (MemToReg)
    // -------------------------
    mux2 WB_MUX (
        .in0(alu_result),
        .in1(mem_data),
        .sel(MemToReg),
        .out(write_back_data)
    );

    // -------------------------
    // Branch Adder
    // -------------------------
    branch_adder BRANCH_ADD (
        .pc(pc),
        .imm(immediate),
        .branch_target(branch_target)
    );

    // -------------------------
    // PCSrc Logic
    // -------------------------
    wire PCSrc = Branch & zero_flag;

    // -------------------------
    // Next PC MUX
    // -------------------------
    mux2 PC_MUX (
        .in0(pc_plus_4),
        .in1(branch_target),
        .sel(PCSrc),
        .out(next_pc)
    );

endmodule
