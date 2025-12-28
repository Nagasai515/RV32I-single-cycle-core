`timescale 1ns / 1ps

module cpu_tb;

    reg clk;
    reg reset;

    // Instantiate CPU
    top_cpu CPU (
        .clk(clk),
        .reset(reset)
    );

    // Clock generation: 10 ns period
    initial begin
        clk = 0;
        forever #5 clk = ~clk;   // 10 ns clock
    end

    // Reset logic
    initial begin
        reset = 1;
        #20 reset = 0;           // Release reset after 20 ns
    end

    // Simulation runtime
    initial begin
        #3000 $finish;
    end

    // Monitor useful values
    initial begin
        $monitor("Time=%0t | PC=%h | Instruction=%h",
                 $time, CPU.pc, CPU.instr);
    end

endmodule
