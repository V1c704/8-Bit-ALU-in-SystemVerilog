`timescale 1ns / 1ps

module Artithmetic_Unit(
        input logic  [7:0] A,
        input logic  [7:0] B,
        input logic        is_signed,
        output logic [9:0] ADD,
        output logic [9:0] SUB,
        output logic [9:0] MUL,
        output logic [9:0] DIV,
        output logic [9:0] NEG,
        output logic [9:0] ABS,
        output logic [9:0] MIN,
        output logic [9:0] MAX
    );
    
    logic [8:0]  add_temp;
    logic [8:0]  sub_temp;
    logic [7:0]  abs_A;
    logic [7:0]  abs_B;
    logic [15:0] mul_temp;
    logic [15:0] mul_signed;
    logic [7:0]  div_temp;
    logic        sign;
    logic        OF_add;
    logic        OF_sub;
    logic        OF_mul;
    logic        CF_mul;
    
    
    always_comb begin
        add_temp = A + B;
        sub_temp = A - B;
        
        if(is_signed) begin //A si B sunt signed
                OF_add = (A[7] == B[7]) && (add_temp[7] != A[7]);
                ADD = {OF_add, 1'b0, add_temp[7:0]}; 
                
                OF_sub = (A[7] != B[7]) && (sub_temp[7] != A[7]);
                SUB = {OF_sub, 1'b0, sub_temp[7:0]};
                
                abs_A = A[7]?(~A + 1'b1) : A;
                abs_B = B[7]?(~B + 1'b1) : B;
                
                mul_temp = abs_A * abs_B; //16bit mul
                div_temp = abs_A / abs_B; //16bit div
                sign = A[7] ^ B[7]; //semnul rezultatului
                
                if(sign) begin 
                    mul_signed = ~mul_temp + 1'b1;
                    DIV = {(A == 8'h80 && B == 8'hFF), (B == 8'h00), ~div_temp + 1'b1};
                    end
                    else begin
                        mul_signed = mul_temp;
                        DIV = {(A == 8'h80 && B == 8'hFF), (B == 8'h00), div_temp};
                        end
                    
                    OF_mul = (mul_signed[15:8] != {8{mul_signed[7]}});
                    MUL = {OF_mul, 1'b0, mul_signed[7:0]};  
                    
                    NEG = {(A == 8'h80), 1'b0, ~A + 1'b1};
                    ABS = {(A == 8'h80), 1'b0, abs_A};
                    
                    if(A[7] != B[7]) begin
                        if(A[7]) begin
                            MIN = {2'b00, A};
                            MAX = {2'b00, B};
                            end
                            else begin
                                MIN = {2'b00, B};
                                MAX = {2'b00, A};
                                end
                                                
                        end
                        else begin
                            if(A < B) begin
                                MIN = {2'b00, A};
                                MAX = {2'b00, B};
                                end 
                                else begin
                                    MIN = {2'b00, B};
                                    MAX = {2'b00, A};
                                    end
                            end
                                
                    end
                    else begin //A si B sunt unsigned
                        ADD = {1'b0, add_temp[8], add_temp[7:0]};
                        SUB = {1'b0, (A < B), sub_temp[7:0]};
                        
                        mul_temp = A * B;
                        CF_mul = (mul_temp[15:8] != 8'h00);
                        
                        MUL = {1'b0, CF_mul, mul_temp[7:0]};
                        DIV = {1'b0, (B == 8'h00), A / B};
                        
                        NEG = {1'b0, (A != 8'h00), ~A + 1'b1};
                        ABS = {2'b00, A};
                        
                        MIN = {2'b00, (A < B) ? A : B};
                        MAX = {2'b00, (A > B) ? A : B};
                        end
                
        end       
endmodule
