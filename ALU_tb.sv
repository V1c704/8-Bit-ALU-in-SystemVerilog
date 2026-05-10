`timescale 1ns / 1ps

module ALU_tb();

logic [7:0] A;
logic [7:0] B;
logic is_signed;
logic [3:0] sel;
logic [7:0] result;
logic OF;
logic CF;
logic SF;
logic ZF;

ALU_top ALU_test(
    .A(A),        
    .B(B),        
    .is_signed(is_signed),
    .sel(sel),      
    .result(result),  
    .OF(OF),       
    .CF(CF),       
    .SF(SF),       
    .ZF(ZF)               
);

initial begin
    A = 8'd0;
    B = 8'd0;
    sel = 4'd0;
    is_signed = 1'b0;
    #10;
        
    //ADD unsigned
    sel = 4'd0; is_signed = 0; A = 8'd10; B = 8'd20; 
    #10;
    //ADD unsigned + CF
    sel = 4'd0; is_signed = 0; A = 8'd250; B = 8'd10;
    #10;
    //ADD signed
    sel = 4'd0; is_signed = 1; A = 8'h10; B = 8'd20; 
    #10;
    //ADD signed + OF
    sel = 4'd0; is_signed = 1; A = 8'd120; B = 8'd10;
    #10;  
     
    //SUB unsigned
    sel = 4'd1; is_signed = 0; A = 8'd50; B = 8'd20;
    #10;
    //SUB unsigned + CF
    sel = 4'd1; is_signed = 0; A = 8'd20; B = 8'd50;
    #10;
    //SUB unsigned + ZF
    sel = 4'd1; is_signed = 0; A = 8'd50; B = 8'd50;
    #10;
    //SUB signed -> (50 - (-10))
    sel = 4'd1; is_signed = 1; A = 8'd50; B = 8'hF6;
    #10;
    //SUB signed + OF -> (-120 - 20)
    sel = 4'd1; is_signed = 1; A = 8'h88; B = 8'd20;
    #10;
     
    //MUL unsigned
    sel = 4'd2; is_signed = 0; A = 8'd10; B = 8'd5;
    #10;
    //MUL unsigned + CF
    sel = 4'd2; is_signed = 0; A = 8'd20; B = 8'd20;
    #10;
    //MUL signed + OF
    sel = 4'd2; is_signed = 1; A = 8'd20; B = 8'd10;
    #10;
    
    //DIV unsigned
    sel = 4'd3; is_signed = 0; A = 8'd50; B = 8'd5;
    #10;
    //DIV + CF (.../0)
    sel = 4'd3; is_signed = 0; A = 8'd50; B = 8'd0;
    #10;
    
    //NEG
    sel = 4'd4; is_signed = 1; A = 8'd5; B = 8'd0;
    #10;
    //ABS
    sel = 4'd5; is_signed = 1; A = 8'hFB; B = 8'd0;
    #10;
    //MIN signed -> min(-10,5)
    sel = 4'd6; is_signed = 1; A = 8'hF6; B = 8'd5;
    #10;
    //MAX unsigned
    sel = 4'd7; is_signed = 0; A = 8'd250; B = 8'd50;
    #10;
    
    //AND
    sel = 4'd8; is_signed = 0; A = 8'hF0; B = 8'hAA;
    #10;
    //OR
    sel = 4'd9; is_signed = 0; A = 8'h0F; B = 8'h55;
    #10;
    //XOR
    sel = 4'd10; is_signed = 0; A = 8'hFF; B = 8'hAA;
    #10;
    //NOT
    sel = 4'd11; is_signed = 0; A = 8'd0; B = 8'd0;
    #10;
    
    //SHL + CF + OF
    sel = 4'd12; is_signed = 0; A = 8'h81; B = 8'd1;
    #10;
    //SHR unsigned
    sel = 4'd13; is_signed = 0; A = 8'hFF; B = 8'd4;
    #10;
    //SHR signed
    sel = 4'd13; is_signed = 1; A = 8'h80; B = 8'd3;
    #10;
    //ROL
    sel = 4'd14; is_signed = 0; A = 8'h81; B = 8'd1;
    #10;
    //ROR unsigned
    sel = 4'd15; is_signed = 0; A = 8'h81; B = 8'd1;
    #10;
    //ROR signed + OF
    sel = 4'd15; is_signed = 0; A = 8'h03; B = 8'd1;
    #10;
    $stop;
end

endmodule
