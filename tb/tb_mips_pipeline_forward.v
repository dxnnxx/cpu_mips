`timescale 1ns/1ps

module tb_mips_pipeline_forward;
    reg clk;
    reg rst_n;

    // UUT instantiation
    mips_pipeline uut(
        .clk(clk),
        .rst_n(rst_n)
    );

    // Clock generation
    always #5 clk = ~clk;

    initial begin
        $dumpfile("waveform/tb_mips_pipeline_forward.vcd");
        $dumpvars(0, tb_mips_pipeline_forward);

        clk = 0;
        rst_n = 0;

        // ==========================================
        // Load program into instruction memory
        // ==========================================

        // Instruction 0
        uut.inst_mem.memory[0] = {6'h23, 5'd0, 5'd8, 16'd0}; // lw $t0, 0($zero)

        // Instruction 1
        uut.inst_mem.memory[1] = {6'h23, 5'd0, 5'd9, 16'd4}; // lw $t1, 4($zero)

        // uut.inst_mem.memory[2] = {6'h00, 5'd0, 5'd0, 5'd0, 5'd0, 6'h0};
        // uut.inst_mem.memory[3] = {6'h00, 5'd0, 5'd0, 5'd0, 5'd0, 6'h0};
        // uut.inst_mem.memory[4] = {6'h00, 5'd0, 5'd0, 5'd0, 5'd0, 6'h0};

        uut.inst_mem.memory[5] = {6'h00, 5'd8, 5'd9, 5'd10, 5'd0, 6'h20}; // add $t2, $t0, $t1
        uut.inst_mem.memory[6] = {6'h00, 5'd10, 5'd9, 5'd11, 5'd0, 6'h22}; // sub $t3, $t2, $t1

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

        #200;

        // ==========================================
        // Inspect registers
        // ==========================================

        $display("Register 8  = %d, expected to be 10", uut.reg_file.registers[8]);
        $display("Register 9  = %d, expected to be 6", uut.reg_file.registers[9]);
        $display("Register 10  = %d, expected to be 16", uut.reg_file.registers[10]);
        $display("Register 11  = %d, expected to be 10", uut.reg_file.registers[11]);
        // $display("Register 12  = %d, expected to be 2", uut.reg_file.registers[12]);
        // $display("Register 13  = %d, expected to be 14", uut.reg_file.registers[13]);
        // $display("Register 14  = %d, expected to be 16", uut.reg_file.registers[14]);
        // $display("Register 15  = %d, expected to be 0", uut.reg_file.registers[15]);

        // ==========================================
        // Inspect memory
        // ==========================================

        $display("\nMemory[0] = %d", uut.data_mem.memory[0]);
        $display("Memory[1] = %d", uut.data_mem.memory[1]);
        // $display("Memory[2] = %d", uut.data_mem.memory[2]);


        $finish;


    end

    // always @(posedge clk) begin
        // $display("time=%0t PC=%d IF_ID_inst=%h ID_EX_RegWrite=%b EX_MEM_RegWrite=%b MEM_WB_RegWrite=%b\n",
                // $time,
                // uut.addr,
                // uut.IF_ID_inst,
                // uut.ID_EX_RegWrite,
                // uut.EX_MEM_RegWrite,
                // uut.MEM_WB_RegWrite);
    // end

    initial begin
        // Print Table Header with fixed column widths
        $display("\n%-7s %-5s %-12s %-12s %-12s %-12s", "time", "PC", "IF/ID", "ID/EX", "EX/MEM", "MEM/WB");
        
        // Run simulation monitoring loop
        forever @(posedge clk) begin
            // Print pipeline state every cycle
            $display("%-7t %-5d %-12h %-12h %-12h %-12h", 
                     $time, 
                     uut.addr,
                     uut.IF_ID_inst, 
                     uut.ID_EX_inst, 
                     uut.EX_MEM_inst, 
                     uut.MEM_WB_inst);
        end
    end




endmodule