module datapath(input logic clk, reset, IorD, MemRead, MemWrite, MemToReg, input logic IRWrite, ALUSrcA, RegWrite, RegDst, PCSel,				
					 input logic [1:0] PCSource, input logic [1:0] ALUSrcB,input logic [3:0] ALUCtrl, output logic Zero,output logic [5:0] Op,
					 output logic [5:0] Function);
				
	parameter PCSTART = 128; //starting address of instruction memory			
	logic [7:0] PC;			
	logic [31:0] ALUOut;			
	logic [31:0] ALUResult;			
	logic [31:0] OpA;			
	logic [31:0] OpB;
	logic [31:0] A;
	logic [31:0] B;
	logic [31:0] Instruction;
	logic [31:0] MDR;
	logic [31:0] dA;
	logic [31:0] dB;
	logic [7:0] address;
	logic [31:0] MemData;
	logic [31:0] RF_WriteData;
	logic [4:0] RF_rd;
	reg[31:0] mem[255:0];
	reg[31:0] registers[31:0];

				
	assign Op = Instruction[31:26];
	assign Function = Instruction[5:0];
			
	assign address = (IorD) ? ALUOut : PC;
	initial $readmemh("unified_memory.dat", mem);
	
	
	always @(posedge clk) begin
		if(MemWrite)
			mem[address] <= B;
	end
	
	assign MemData = (MemRead)?mem[address] : 32'bx;				
				
	always @(posedge clk)begin
		if(reset)
			PC <= PCSTART;
		else
			if(PCSel)begin
				case (PCSource)
					1'b0: PC <= ALUResult;
					1'b1: PC <= ALUOut;
				endcase
			end
	end	
	
	
	always @(posedge clk) begin
		if (IRWrite)
			Instruction <= MemData;
	end
	
	
	always @(posedge clk) begin
		MDR <= MemData;
	end

	//Register File			
	//$r0 is always 0			
	assign dA = (Instruction[25:21]!=0) ? registers[Instruction[25:21]] : 0;			
	assign dB = (Instruction[20:16]!=0) ? registers[Instruction[20:16]] : 0;			
	assign RF_WriteData = (MemToReg) ? MDR : ALUOut;			
	assign RF_rd = (RegDst) ? Instruction[15:11] : Instruction[20:16];			
				
				
	always @(posedge clk) begin			
		if (RegWrite) begin		
			registers[RF_rd] <= RF_WriteData;	
		end		
	end			
		
		
	//A and B registers				
	always @(posedge clk) begin			
		if (reset)		
			A <= 0;	
		else		
			A<=dA;	
	end			
				
	always @(posedge clk) begin			
		if (reset)		
			B <= 0;	
		else		
			B<=dB;	
	end			
		
		
	//ALU					
	assign OpA = (ALUSrcA) ? A : PC;			
				
	always_comb			
	begin			
		case(ALUSrcB)		
		2'b00: OpB = B;		
		2'b01: OpB = 4;		
		2'b10: OpB = {{(16){Instruction[15]}}, Instruction[15:0]};		
		2'b11: OpB = {{(14){Instruction[15]}}, Instruction[15:0],2'b00};		
		endcase		
	end			
				
	assign Zero = (ALUResult==0); //Zero == 1 when ALUResult is 0 (for branch)			
				
	always_comb			
	begin			
		case(ALUCtrl)		
		4'b0000: ALUResult = OpA & OpB;	//and	
		4'b0001: ALUResult = OpA | OpB;	//or	
		4'b0010: ALUResult = OpA ^ OpB;	//add		
		4'b0011: ALUResult = ~(OpA | OpB);		
		4'b0110: ALUResult = OpA + OpB;	//branch		
		4'b1110: ALUResult = OpA - OpB;		
		4'b1111: ALUResult = OpA < OpB?1:0;	//ALUResult is 1 when OpA<Opb, otherwise 0	
		default: ALUResult = OpA + OpB;		
		endcase		
	end			
			
		
	always@(posedge clk) begin
		ALUOut <= ALUResult;
	end
					
endmodule				
