module mux2 (
    input  wire [31:0] in0,
    input  wire [31:0] in1,
    input  wire        sel,
    output wire [31:0] out
);

    assign out = sel ? in1 : in0;

endmodule
