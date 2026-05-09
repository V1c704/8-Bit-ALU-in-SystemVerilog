`timescale 1ns / 1ps

module Shift_Unit(
        input logic  [7:0] A,
        input logic  [7:0] B,
        input logic        is_signed,
        output logic [9:0] shl,
        output logic [9:0] shr,
        output logic [9:0] rol,
        output logic [9:0] ror
    );
    
    
    logic [7:0] shl_tmp;
    logic [7:0] shr_tmp;
    logic [7:0] rol_tmp;
    logic [7:0] ror_tmp;
    logic OF_shl, CF_shl;
    logic OF_shr, CF_shr;
    logic OF_rol, CF_rol;
    logic OF_ror, CF_ror;
    logic [2:0] rot;
    logic [15:0] ext_shl;
    logic [15:0] ext_shr;
    logic [7:0] B_abs;
    logic [15:0] A_sgnext;
    
    always_comb begin
        B_abs = (is_signed && B[7])? (~B + 1'b1) : B;
        rot = B_abs[2:0];
        
        shl_tmp = (B_abs < 8) ? (A << B_abs) : 8'd0;
        
        if(is_signed) begin //SHR signed
            if(B_abs >= 8) begin
                shr_tmp = {8{A[7]}}; //umplu shr_tmp cu A[7]
                end
                else begin
                    A_sgnext = { {8{A[7]}}, A};
                    A_sgnext = A_sgnext >> B_abs;
                    shr_tmp = A_sgnext[7:0];
                    end
            end
            else begin //SHR unsigned
                if(B_abs >= 8) begin
                    shr_tmp = 8'd0;
                    end
                    else begin
                        shr_tmp = A >> B_abs;
                        end
                end
        
        rol_tmp = (rot == 0) ? A : ((A << rot) | (A >> (8 - rot)));
        ror_tmp = (rot == 0) ? A : ((A >> rot) | (A << (8 - rot)));
        
        if(B_abs == 0) begin
            CF_shl = 0;
            CF_shr = 0;
            CF_rol = 0;
            CF_ror = 0; 
            end
            else begin
                ext_shl = A << B_abs;
                CF_shl = (B_abs <= 8) ? ext_shl[8] : 1'b0;
                
                ext_shr = {A, 8'd0} >> B_abs;
                CF_shr = (B_abs <=8) ? ext_shr[7] : 1'b0;
                
                CF_rol = rol_tmp[0];
                CF_ror = ror_tmp[7]; 
                end
        if(is_signed && B_abs == 8'd1) begin
            OF_shl = shl_tmp[7] ^ A[7];
            OF_shr = 1'b0;
            OF_rol = rol_tmp[7] ^ A[7];
            OF_ror = ror_tmp[7] ^ A[7];
            end
            else begin
                OF_shl = 0;
                OF_shr = 0;
                OF_rol = 0;
                OF_ror = 0;
                end
                
        shl = {OF_shl, CF_shl, shl_tmp};
        shr = {OF_shr, CF_shr, shr_tmp};
        rol = {OF_rol, CF_rol, rol_tmp}; 
        ror = {OF_ror, CF_ror, ror_tmp};
        
        end
endmodule
