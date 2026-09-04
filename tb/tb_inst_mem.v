`timescale 1ns/1ps

module tb_inst_mem;

    reg  [31:0] addr;
    wire [31:0] inst;

    inst_mem uut (
        .addr(addr),
        .inst(inst)
    );

    initial begin

        // Put some instructions into memory
        uut.memory[0] = {6'h00,5'd0,5'd1,5'd5,5'h0,6'h0}; //add r5,r0,r1
        uut.memory[1] = {6'h23,5'd0,5'd9 ,16'd1};
        uut.memory[2] = 32'hDEADBEEF;

        // Address 0 → memory[0]
        addr = 32'd0;
        #10;

        if (inst !== {6'h00,5'd0,5'd1,5'd5,5'h0,6'h0})
            $display("Address 0: FAIL");
        else
            $display("Address 0: PASS");


        // Address 4 → memory[1]
        addr = 32'd4;
        #10;

        if (inst !== {6'h23,5'd0,5'd9 ,16'd1})
            $display("Address 4: FAIL");
        else
            $display("Address 4: PASS");


        // Address 8 → memory[2]
        addr = 32'd8;
        #10;

        if (inst !== 32'hDEADBEEF)
            $display("Address 8: FAIL");
        else
            $display("Address 8: PASS");


        $finish;
    end

endmodule