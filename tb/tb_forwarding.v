`timescale 1ns/1ps

module tb_forwarding;
    reg EX_MEM_RegWrite, MEM_WB_RegWrite;

    reg [4:0] rs, rt, EX_MEM_rd, MEM_WB_rd; // rs, rt from ID

    wire [1:0] ForwardA, ForwardB;

    forwarding uut(
        .EX_MEM_RegWrite(EX_MEM_RegWrite), .MEM_WB_RegWrite(MEM_WB_RegWrite),

        .rs(rs), .rt(rt), .EX_MEM_rd(EX_MEM_rd), .MEM_WB_rd(MEM_WB_rd),
        
        .ForwardA(ForwardA), .ForwardB(ForwardB)
    );


    initial begin
        // Execute hazard for rs AND rt
        EX_MEM_RegWrite = 1'b1;
        rs = 5'b00001;
        EX_MEM_rd = 5'b00001;

        MEM_WB_RegWrite = 1'b1;
        rt = 5'b00010;
        MEM_WB_rd = 5'b00010;

        #1;

        $display("ForwardA=%0b, ForwardB=%0b", ForwardA, ForwardB);
    end
endmodule