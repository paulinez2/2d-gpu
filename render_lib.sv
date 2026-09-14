module render_bars (
    input logic vertical, // whether vertical or horizontal bars
    input logic [9:0] px, py, 
    output logic pixel_on,
    output logic [11:0] color
);
    always_comb begin
        pixel_on = 1'b0;
        color = 12'hBDF;

        if (vertical) begin
            if (px < 120) begin
                pixel_on = 1'b0;
                color = 12'hF9C;
            end 
            else if ((px < 360) & (px > 240)) begin
                pixel_on = 1'b1;
                color = 12'hF9C;
            end
            else begin
                pixel_on = 1'b0;
                color = 12'hBDF;
            end
        end

        else begin 
            if (py < 160) begin
                pixel_on = 1'b0;
                color = 12'hF9C;
            end 
            else if ((py < 480) & (py > 320)) begin
                pixel_on = 1'b1;
                color = 12'hF9C;
            end 
            else begin
                pixel_on = 1'b0;
                color = 12'hBDF;
            end
        end
    end

endmodule : render_bars

module render_checkerboard (
    input logic [9:0] px,
    input logic [9:0] py,

    output logic pixel_on,
    output logic [11:0] color
);

    always_comb begin

        pixel_on = 1'b1;

        if ((px[9:5] + py[8:5]) % 2 == 0)
            color = 12'hF9C;   // pastel pink
        else
            color = 12'hBDF;   // pastel blue
    end
endmodule


module render_rectangle (
    input logic [9:0] px,
    input logic [9:0] py,

    input logic [9:0] x_pos,
    input logic [9:0] y_pos,

    input logic [9:0] width,
    input logic [9:0] height,

    output logic pixel_on,
    output logic [11:0] color
);

    always_comb begin

        pixel_on = 1'b0;
        color = 12'hBDF;

        if ((px >= x_pos) &&
            (px < x_pos + width) &&
            (py >= y_pos) &&
            (py < y_pos + height)) begin

            pixel_on = 1'b1;
            color = 12'hF9C;
        end
    end

endmodule


module render_circle (
    input logic [9:0] px,
    input logic [9:0] py,

    input logic [9:0] center_x,
    input logic [9:0] center_y,

    input logic [9:0] radius,

    output logic pixel_on,
    output logic [11:0] color
);

    logic signed [10:0] dx;
    logic signed [10:0] dy;

    logic [21:0] distance;

    always_comb begin

        pixel_on = 1'b0;
        color = 12'hBDF;

        dx = px - center_x;
        dy = py - center_y;

        distance = dx*dx + dy*dy;

        if (distance <= radius*radius) begin

            pixel_on = 1'b1;
            color = 12'hF9C;

        end

    end

endmodule