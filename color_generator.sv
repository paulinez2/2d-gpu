module color_gen(
    input logic [9:0] px, py, 
    input logic visible, pixel_on,
    input logic [11:0] color,
    output logic [3:0] red, green, blue);

    always_comb begin
        if (pixel_on && visible) begin
            red = color[11:8];
            green = color[7:4];
            blue = color[3:0];
        end
        else if (visible) begin 
            red = color[11:8];
            green = color[7:4];
            blue = color[3:0];
        end 
        else begin
            red = 'd0;
            green = 'd0; 
            blue  = 'd0;
        end

    end
    // // going to start with simple plain background

    // always_comb begin
    //     if (visible) begin
    //         red = 4'h0; // just red for now.
    //         green = 4'h0;
    //         blue = 4'hF;
    //     end
    //     else begin
    //         red = 'd0;
    //         green = 'd0; 
    //         blue  = 'd0;
    //     end
    // end
endmodule : color_gen  