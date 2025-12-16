module pc_adder (
    input  wire [31:0] pc,
    output wire [31:0] pc_plus_4
);

    assign pc_plus_4 = pc + 32'd4;

endmodule
