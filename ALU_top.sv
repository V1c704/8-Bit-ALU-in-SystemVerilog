`timescale 1ns / 1ps

module ALU_top(
        input logic [7:0] A,
        input logic [7:0] B,
        input logic       is_signed,
        input logic [3:0] sel,
        output logic [7:0] result,
        output logic      OF,
        output logic      CF,
        output logic      SF,
        output logic      ZF
    );
    
    logic [9:0] out_add, out_sub, out_mul, out_div, out_neg, out_abs, out_min, out_max;
    logic [9:0] out_and, out_or, out_xor, out_not;
    logic [9:0] out_shl, out_shr, out_rol, out_ror;
    logic [9:0] result_temp;
    
    Arithmetic_Unit AU(
        .A(A),        
        .B(B),        
        .is_signed(is_signed),
        .ADD(out_add),      
        .SUB(out_sub),      
        .MUL(out_mul),      
        .DIV(out_div),      
        .NEG(out_neg),      
        .ABS(out_abs),      
        .MIN(out_min),      
        .MAX(out_max)       
    );
    
    Logic_Unit LU(
        .A(A),      
        .B(B),      
        .out_and(out_and),
        .out_or(out_or), 
        .out_xor(out_xor),
        .out_not(out_not) 
    );
    
    Shift_Unit SU(
        .A(A),        
        .B(B),        
        .is_signed(is_signed),
        .shl(out_shl),      
        .shr(out_shr),      
        .rol(out_rol),      
        .ror(out_ror)       
    );
    
    
    always_comb begin
        case(sel)
            4'd0: result_temp = out_add;
            4'd1: result_temp = out_sub;
            4'd2: result_temp = out_mul;
            4'd3: result_temp = out_div;
            4'd4: result_temp = out_neg;
            4'd5: result_temp = out_abs;
            4'd6: result_temp = out_min;
            4'd7: result_temp = out_max;
            
            4'd8: result_temp = out_and;
            4'd9: result_temp = out_or;
            4'd10: result_temp = out_xor;
            4'd11: result_temp = out_not;
            
            4'd12: result_temp = out_shl;
            4'd13: result_temp = out_shr;
            4'd14: result_temp = out_rol;
            4'd15: result_temp = out_ror;
            
            default: result_temp = 10'd0;
        endcase
    end
    
    assign result = result_temp[7:0];
    assign CF = result_temp[8];
    assign OF = result_temp[9];
    assign SF = result_temp[7];
    assign ZF = (result_temp[7:0] == 8'd0);
    
endmodule
