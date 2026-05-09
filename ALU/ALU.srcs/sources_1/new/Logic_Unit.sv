`timescale 1ns / 1ps

module Logic_Unit(
        input logic  [7:0] A,
        input logic  [7:0] B,
        output logic [9:0] out_and,
        output logic [9:0] out_or,
        output logic [9:0] out_xor,
        output logic [9:0] out_not
    );
    
    always_comb begin
        out_and = {2'b00, A & B};
        out_or = {2'b00, A | B};
        out_xor = {2'b00, A ^ B};
        out_not = {2'b00, ~A};
        end
        
endmodule
