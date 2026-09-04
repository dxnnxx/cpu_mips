module next_pc (
    input [31:0] addr,
    input [31:0] extended_imm,
    input Branch,
    input zero,
    output [31:0] next_addr
);

    wire [31:0] pc_plus_4;
    wire [31:0] branch_target;
    wire        take_branch;

    assign pc_plus_4 = addr + 32'd4; // byte addressing

    assign branch_target = pc_plus_4 + (extended_imm << 2);

    assign take_branch = Branch && zero; // the AND gate

    assign next_addr = take_branch ? branch_target : pc_plus_4;

endmodule