`timescale 1ns/1ps

module tb_mips_single_cycle;
    reg clk;
    reg rst_n;

    // DUT instantiation
    mips_single_cycle uut(
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveform/tb_mips_single_cycle.vcd");
        $dumpvars(0, tb_mips_single_cycle);

        clk = 0;
        rst_n = 0;

        // ==========================================
        // Load program into instruction memory
        // ==========================================

        // Instruction 0
        uut.inst_mem.memory[0] = {6'h23, 5'd0, 5'd8, 16'd0}; // lw $t0, 0($zero)

        // Instruction 1
        uut.inst_mem.memory[1] = {6'h23, 5'd0, 5'd9, 16'd4}; // lw $t1, 4($zero)

        uut.inst_mem.memory[2] = {6'h00, 5'd8, 5'd9, 5'd10, 5'd0, 6'h20}; // add $t2, $t0, $t1
        uut.inst_mem.memory[3] = {6'h00, 5'd10, 5'd9, 5'd11, 5'd0, 6'h22}; // sub $t3, $t2, $t1
        uut.inst_mem.memory[4] = {6'h00, 5'd8, 5'd9, 5'd12, 5'd0, 6'h24}; // and $t4, $t0, $t1
        uut.inst_mem.memory[5] = {6'h00, 5'd8, 5'd9, 5'd13, 5'd0, 6'h25}; // or $t5, $t0, $t1

        uut.inst_mem.memory[6] = {6'h2B, 5'd0, 5'd10, 16'd8}; // sw $t2, 8($zero)
        uut.inst_mem.memory[7] = {6'h23, 5'd0, 5'd14, 16'd8}; // lw $t6, 8($zero)

        uut.inst_mem.memory[8] = {6'h04, 5'd10, 5'd14, 16'd1}; // beq $t2, $t6, 1
        uut.inst_mem.memory[9] = {6'h00, 5'd8, 5'd8, 5'd15, 5'd0, 6'h25}; // or $t7, $t0, $t0 - shouldn't execute
        uut.inst_mem.memory[10] = {6'h04, 5'd0, 5'd0, -16'sd1}; // beq $t2, $t6, -1


        // ==========================================
        // Initialize data memory
        // ==========================================

        uut.data_mem.memory[0] = 32'd10;
        uut.data_mem.memory[1] = 32'd6;


        // ==========================================
        // Reset
        // ==========================================

        #12;
        rst_n = 1;


        // ==========================================
        // Run CPU
        // ==========================================

        #100;

        // ==========================================
        // Inspect registers
        // ==========================================

        $display("Register 8  = %d, expected to be 10", uut.reg_file.registers[8]);
        $display("Register 9  = %d, expected to be 6", uut.reg_file.registers[9]);
        $display("Register 10  = %d, expected to be 16", uut.reg_file.registers[10]);
        $display("Register 11  = %d, expected to be 10", uut.reg_file.registers[11]);
        $display("Register 12  = %d, expected to be 2", uut.reg_file.registers[12]);
        $display("Register 13  = %d, expected to be 14", uut.reg_file.registers[13]);
        $display("Register 14  = %d, expected to be 16", uut.reg_file.registers[14]);
        $display("Register 15  = %d, expected to be 0", uut.reg_file.registers[15]);

        // ==========================================
        // Inspect memory
        // ==========================================

        $display("\nMemory[0] = %d", uut.data_mem.memory[0]);
        $display("Memory[1] = %d", uut.data_mem.memory[1]);
        $display("Memory[2] = %d", uut.data_mem.memory[2]);


        $finish;
    end
endmodule
