module forwarding (
    input EX_MEM_RegWrite, MEM_WB_RegWrite,

    input [4:0] rs, rt, EX_MEM_rd, MEM_WB_rd, // rs, rt from ID

    output reg [1:0] ForwardA, ForwardB
);

    always @(*) begin

        // Initialize to no forward
        ForwardA = 2'b00;
        ForwardB = 2'b00;

        // ============================
        // ForwardA 
        // (deal forwarding separately 
        //  for the two ALU inputs)
        // forwarding for rs and rt can
        // happen simultaneously
        // ============================

        if (EX_MEM_RegWrite && 
            (EX_MEM_rd != 5'd0) && 
            (EX_MEM_rd == rs)) begin

            ForwardA = 2'b10;

        end else if (MEM_WB_RegWrite && 
                    (MEM_WB_rd != 5'd0) &&
                    (MEM_WB_rd == rs)) begin
            
            ForwardA = 2'b01;

        end
         
        // ============================
        // ForwardB
        // ============================
        
        if (EX_MEM_RegWrite &&
            (EX_MEM_rd != 5'd0) &&
            (EX_MEM_rd == rt)) begin

            ForwardB = 2'b10;

        end else if (MEM_WB_RegWrite &&
                    (MEM_WB_rd != 5'd0) &&
                    (MEM_WB_rd == rt)) begin

            ForwardB = 2'b01;

        end
    end

endmodule

