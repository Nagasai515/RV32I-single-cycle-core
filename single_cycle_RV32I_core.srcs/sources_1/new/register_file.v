`timescale 1ns / 1ps

module register_file (
    input  wire        clk,
    input  wire        reg_write,
    input  wire [4:0]  rs1,
    input  wire [4:0]  rs2,
    input  wire [4:0]  rd,
    input  wire [31:0] write_data,
    output wire [31:0] read_data1,
    output wire [31:0] read_data2
);

    reg [31:0] regs [0:31];
    integer i;
initial begin
    for (i = 0; i < 32; i = i + 1)
        regs[i] = 32'd0;
end


    // ----------------------------
    // WRITE Logic
    // ----------------------------
    always @(posedge clk) begin
        if (reg_write && rd != 5'd0) begin
            regs[rd] <= write_data;

            `ifndef SYNTHESIS
                $display("Time=%0t | Write: x%0d = %0d (0x%h)",
                         $time, rd, write_data, write_data);
            `endif
        end
    end

    // ----------------------------
    // READ Logic (asynchronous)
    // ----------------------------
    assign read_data1 = (rs1 == 5'd0) ? 32'd0 : regs[rs1];
    assign read_data2 = (rs2 == 5'd0) ? 32'd0 : regs[rs2];

    // ----------------------------
    // DEBUG: dump registers every cycle
    // ----------------------------
    always @(posedge clk) begin
        `ifndef SYNTHESIS
            $display("------ Register File @ time %0t ------", $time);
            $display("x0 = %0d", 32'd0);
            $display("x1 = %0d", regs[1]);
            $display("x2 = %0d", regs[2]);
            $display("x3 = %0d", regs[3]);
            $display("x4 = %0d", regs[4]);
            $display("x5 = %0d", regs[5]);
            $display("--------------------------------------");
        `endif
    end

endmodule
