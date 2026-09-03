module pc (
    input [31:0] next_addr,
    input clk, rst_n,
    output reg [31:0] addr
);

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n)
            addr <= 32'b0;
        else
            addr <= next_addr;
    end

endmodule