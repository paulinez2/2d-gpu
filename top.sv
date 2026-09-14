module top(
    input logic CLK100MHZ, BTNC,
    output logic [3:0] VGA_R, VGA_G, VGA_B,
    output logic VGA_HS, VGA_VS
);
    logic clk25;
    logic visible, pixel_on;
    logic [9:0] px, py;
    logic [11:0] color;

    vga_timing (.clk(clk25), 
                .rst_n(BTNC), 
                .px(px), 
                .py(py), 
                .visible(visible), 
                .hsync(VGA_HS), 
                .vsync(VGA_VS));

    clock_divider4(.clk100(CLK100MHZ), 
                   .reset(BTNC), 
                   .clk25(clk25));

    color_gen(.px(px), 
              .py(py), 
              .visible(visible), 
              .pixel_on(pixel_on),
              .color(color),
              .red(VGA_R), 
              .green(VGA_G), 
              .blue(VGA_B));

//    render_bars (.vertical(1'b1),  
//                 .px(px), 
//                 .py(py),  
//                 .pixel_on(pixel_on), 
//                 .color(color));

//    render_checkerboard (.px(px), 
//                         .py(py), 
//                         .pixel_on(pixel_on), 
//                         .color(color));


    /*logic [9:0] x_pos, y_pos, width, height;

    assign x_pos = 20;
    assign y_pos = 40;
    assign width = 200;
    assign height = 100;

    render_rectangle (.px(px), 
                      .py(py), 
                      .x_pos(x_pos), 
                      .y_pos(y_pos), 
                      .width(width), 
                      .height(height), 
                      .pixel_on(pixel_on), 
                      .color(color));*/

    logic [9:0] center_x, center_y, radius;
    
    assign center_x = 200;
    assign center_y = 200;
    assign radius = 10;
    render_circle (.px(px), 
                   .py(py), 
                   .center_x(center_x), 
                   .center_y(center_y), 
                   .radius(radius), 
                   .pixel_on(pixel_on), 
                   .color(color));

endmodule : top 