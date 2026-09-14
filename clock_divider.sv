module clock_divider4(
    input logic clk100,
    input logic reset,
    output logic clk25 );


    logic [1:0] counter;

    always_ff@(posedge clk100) begin
        if (reset)
            counter <= 'd0;
        else 
            counter <= counter + 1;
    end

    assign clk25 = counter[1]; // bit 1 is high means a 4 on 2 bits

endmodule: clock_divider4