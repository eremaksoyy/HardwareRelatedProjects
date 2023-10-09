module alucontrol(ALUOp,Function,ALUCtrl);

	input [1:0] ALUOp;
	input [5:0] Function; 

	output reg [3:0] ALUCtrl;	//for R-type instructions

	always@(ALUOp or Function)begin
		casex({ALUOp,Function})
			8'b00_xxxxxx : ALUCtrl=4'b0010;		//lw or sw
			8'b01_xxxxxx : ALUCtrl=4'b0110; 	//beq
			8'b1x_xx0000 : ALUCtrl=4'b0010; 	//add
			8'b1x_xx0010 : ALUCtrl=4'b0110; 	//sub
			8'b1x_xx0100 : ALUCtrl=4'b0000; 	//and
			8'b1x_xx0101 : ALUCtrl=4'b0001; 	//or
			8'b1x_xx1010 : ALUCtrl=4'b0111; 	//slt
		endcase
	end
	
endmodule
