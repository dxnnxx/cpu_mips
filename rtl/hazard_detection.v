module hazard_detection (
    input ID_EX_MemRead,

    input [4:0] ID_EX_rt, IF_ID_rs, IF_ID_rt,
    
    output reg PCWrite, IF_ID_Write, ControlStall
);
    
    always @(*) begin

        // default: no stall
        PCWrite = 1'b1;
        IF_ID_Write = 1'b1;
        ControlStall = 1'b0;

        // When LW
        if (ID_EX_MemRead && (ID_EX_rt != 5'd0) &&
            (ID_EX_rt == IF_ID_rs || ID_EX_rt == IF_ID_rt)) begin

            PCWrite = 1'b0;
            IF_ID_Write = 1'b0;
            ControlStall = 1'b1;

        end
    end

endmodule