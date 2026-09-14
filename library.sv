//`default_nettype none

// checks if A & B are equal
module Comparator
#(parameter WIDTH = 4)
  (input logic [WIDTH-1:0] A, B,
   output logic AeqB);

   assign AeqB = (A == B);

endmodule : Comparator

// compares A & B with magnitude 
module MagComp 
#(parameter WIDTH = 8)
  (input logic [WIDTH-1:0] A, B,
   output logic AltB, AeqB, AgtB);

   always_comb begin
     AltB = 1'b0;
     AeqB = 1'b0;
     AgtB = 1'b0;
     if (A == B)
       AeqB = 1'b1;
    else if (A < B)
      AltB = 1'b1;
    else if (A > B)
      AgtB = 1'b1;

   end 
endmodule : MagComp

// adds A & B 
module Adder
#(parameter WIDTH = 5)
  (input logic [WIDTH-1:0] A, B,
   input logic cin,
   output logic cout,
   output logic [WIDTH-1:0] sum);

   assign {cout, sum} = A + B + cin;

endmodule : Adder

// subtracts A-B 
module Subtracter
#(parameter WIDTH = 5)
  (input logic [WIDTH-1:0] A, B,
   input logic bin,
   output logic bout,
   output logic [WIDTH-1:0] diff);

   assign {bout, diff} = A - B - bin;

endmodule : Subtracter

// multiplexer with width parameter
module Multiplexer
#(parameter WIDTH = 8,
            SEL = $clog2(WIDTH))
  (input logic [WIDTH-1:0] I, 
   input logic [SEL-1:0] S,
   output logic Y);

   assign Y = I[S];

endmodule : Multiplexer

// multiplexer with 2 inputs 
module Mux2to1
#(parameter WIDTH = 7)
  (input logic S,
   input logic [WIDTH-1:0] I0, I1,
   output logic [WIDTH-1:0] Y);
  always_comb begin
    Y = (S) ? I1 : I0;
  end 

endmodule : Mux2to1

//  decoder module
module Decoder
#(parameter WIDTH = 8,
            SEL = $clog2(WIDTH))
  (input logic en, [SEL-1:0] I,
   output logic [WIDTH-1:0] D);

   always_comb begin
    D = 0;
    if (en === 1'b1)
      D[I] = 1'b1;
    // if (en) begin
    //   D = (1 << I);
    // end else begin
    //   D = {WIDTH{1'b0}}; 
    // end
  end
    
endmodule : Decoder

// d flip flop
module DFlipFlop
   (input logic D, clock, reset_L, preset_L,
    output logic Q);

    always_ff @(posedge clock, negedge reset_L, negedge preset_L)
        if (~preset_L & ~reset_L)
            Q <= 1'bX;
        else if (~reset_L)
            Q <= 1'b0;
        else if (~preset_L)
            Q <= 1'b1;
        else
            Q <= D;

endmodule : DFlipFlop

// register
module Register
#(parameter WIDTH = 4)
   (input logic en, clear, clock, [WIDTH-1:0] D,
    output logic [WIDTH-1:0] Q);

    always_ff @(posedge clock)
        if (en)
            Q <= D;
        else if (clear)
            Q <= '0;

endmodule : Register

// Counter
module Counter
#(parameter WIDTH = 4)
   (input logic en, clear, clock, load, up,
    input logic [WIDTH-1:0] D,
    output logic [WIDTH-1:0] Q);

    always_ff @(posedge clock)
        if (clear)
            Q <= 0;
        else if (load)
            Q <= D;
        else if (en & up)
            Q <= Q + 1;
        else if (en & ~up)
            Q <= Q - 1;

endmodule : Counter 

// ShiftRegisterSIPO
// serial input, parallel output
module ShiftRegisterSIPO
#(parameter WIDTH = 4)
   (input logic en, left, serial, clock,
    output logic [WIDTH-1:0] Q);
    
    always_ff @(posedge clock)
      if (en) begin
        if (left)
          Q <= {Q[WIDTH-2:0], serial};
        else if (~left)
          Q <= {serial, Q[WIDTH-1:1]};
      end 
endmodule : ShiftRegisterSIPO 

// ShiftRegisterPIPO
module ShiftRegisterPIPO
#(parameter WIDTH = 4)
   (input logic en, left, load, clock, 
    input logic [WIDTH-1:0] D,
    output logic [WIDTH-1:0] Q);

    always_ff @(posedge clock)
      if (load)
        Q <= D;
      else if (en & ~load) begin
        if (left)
          Q <= (Q << 1);
        else if (~left)
          Q <= Q >> 1;
      end 
      // else if (load)

endmodule : ShiftRegisterPIPO 

// BarrelshiftRegister
module BarrelShiftRegister
#(parameter WIDTH = 4)
   (input logic en, load, clock, 
    input logic [WIDTH-1:0] D,
    input logic [1:0] by,
    output logic [WIDTH-1:0] Q);

    always_ff @(posedge clock)
        if (load)
            Q <= D;
        else if (en & by >= 2'b00)
            Q <= D << by; 

endmodule : BarrelShiftRegister 

// Synchronizer 
module Synchronizer
   (input logic async, clock,
    output logic sync);

    logic pressed;

    DFlipFlop FF0(.D(async), .Q(pressed), .preset_L(1'b1), .reset_L(1'b1), .*);
    DFlipFlop FF1(.D(pressed), .Q(sync), .preset_L(1'b1), .reset_L(1'b1), .*);

endmodule : Synchronizer 

// BusDrivers 
module BusDriver
#(parameter WIDTH = 4)
   (input logic en, 
    input logic [WIDTH-1:0] data, 
    output logic [WIDTH-1:0] buff,
    inout tri [WIDTH-1:0] bus);

    assign bus = (en) ? data: 'bz;
    assign buff = bus; 

endmodule : BusDriver 

// Memory  
module Memory
#(parameter DW = 16, W = 256, AW = $clog2(W))
    (input logic re, we, clock,
     input logic [AW-1:0] addr,
     inout tri [DW-1:0] data);
     
    logic [DW-1:0] M[W];
    logic [DW-1:0] rData;
    assign data = (re) ? rData: 'bz;
    always_ff @(posedge clock)
        if (we)
            M[addr] <= data;
    always_comb
        rData = M[addr];

endmodule : Memory 

module Clock_Divider #(
    parameter int INPUT_FREQ  = 100_000_000,
    parameter int OUTPUT_FREQ = 1_000_000
)(
    input  logic clk,
    input  logic rst,
    output logic clk_out
);

    localparam int DIVISOR = INPUT_FREQ / (2 * OUTPUT_FREQ);

    logic [$clog2(DIVISOR)-1:0] count;

    always_ff @(posedge clk) begin
        if (rst) begin
            count   <= '0;
            clk_out <= 1'b0;
        end else if (count == DIVISOR - 1) begin
            count   <= '0;
            clk_out <= ~clk_out;
        end else begin
            count <= count + 1'b1;
        end
    end

endmodule : Clock_Divider

module Edge_Detector (
    input  logic clk,
    input  logic rst,
    input  logic signal_in,
    output logic edge_detected
);

    logic signal_prev;

    always_ff @(posedge clk) begin
        if (rst) begin
            signal_prev   <= 1'b0;
            edge_detected <= 1'b0;
        end else begin
            edge_detected <= signal_in & ~signal_prev;
            signal_prev   <= signal_in;
        end
    end

endmodule : Edge_Detector