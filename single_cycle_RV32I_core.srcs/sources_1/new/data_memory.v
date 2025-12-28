`timescale 1ns / 1ps

module data_memory (
    input  wire        clk,
    input  wire        MemRead,
    input  wire        MemWrite,
    input  wire [31:0] address,
    input  wire [31:0] write_data,
    output reg  [31:0] read_data
);

    reg [31:0] mem [0:255];   // 256 words = 1KB data memory
    integer i;

    // Initialize memory to 0 for clean simulation
    initial begin
        for (i = 0; i < 256; i = i + 1)
            mem[i] = 32'd0;
    end

    // -------------------------
    // WRITE (synchronous)
    // -------------------------
    always @(posedge clk) begin
        if (MemWrite) begin
            mem[address[9:2]] <= write_data;

            // DEBUG
            $display("Time=%0t | MEM WRITE | mem[%0d] = %0d (0x%h)",
                     $time, address[9:2], write_data, write_data);
        end
    end

    // -------------------------
    // READ (combinational)
    // -------------------------
    always @(*) begin
        if (MemRead)
            read_data = mem[address[9:2]];
        else
            read_data = 32'd0;
    end

endmodule
