module control (input logic clk, reset, Zero,input logic [5:0] Op,output logic IorD, 
						MemRead, MemWrite, MemToReg, IRWrite, output logic ALUSrcA, RegWrite, 
						RegDst, PCSel,output logic [1:0] PCSource,output logic [1:0] ALUSrcB,
						output logic [1:0] ALUOp);
							
	reg PCWrite;
	reg PCWriteCond;
	
	assign PCSel = (PCWrite | (PCWriteCond & Zero));
				
	parameter Fetch = 4'b0000;	//Stage 0 - fetch
	parameter Decode = 4'b0001;	//Stage 1 - decode
	parameter LoadORStore = 4'b0010;	//Stage 2 - load or store
	parameter MemAccessLoad = 4'b0011;	//Stage 3 - L1
	parameter WriteBack = 4'b0100;	//Stage 4 - Write Back
	parameter MemAccessStore = 4'b0101;	//Satge 5 - Store
	parameter Execution = 4'b0110;	//Stage 6 - R-type 
	parameter RType = 4'b0111;		//Stage 7
	parameter Beq = 4'b1000;	//Stage 8 - Branch
	parameter J = 4'b1001;	//Stage 9 - Jump
	
	reg [3:0] state;
	reg [3:0] nextstate;
	
	 always@(posedge clk)
	 
		 if (reset)
			state <= Fetch;
		 else
			state <= nextstate;
		
	always@(state or Op) begin
		case (state)
        Fetch:  
				 nextstate = Decode;
		  
        Decode:  
			case(Op)
             6'b100011:	nextstate = LoadORStore;	 //load(lw)
             6'b101011:	nextstate = LoadORStore;	 //store(sw)
             6'b000000:	nextstate = Execution;	 //r
             6'b000100:	nextstate = Beq;	 //branch(beq)
				 6'b000010:	nextstate = J;	 //jump(j)
             default: nextstate = Fetch;
			endcase
					  
        LoadORStore: case(Op)
								6'b100011: nextstate = MemAccessLoad;//lw
								6'b101011: nextstate = MemAccessStore;//sw
								default: nextstate = Fetch;
							endcase
					  
        MemAccessLoad:     nextstate = WriteBack;
        WriteBack:    		nextstate = Fetch;
        MemAccessStore:    nextstate = Fetch;
        Execution: 	      nextstate = RType;
        RType:      	      nextstate = Fetch;
        Beq:   		  		nextstate = Fetch;
		  J:	           		nextstate = Fetch;
        default: nextstate = Fetch;
      endcase
   end 
	 
	 always@(state) begin
		IorD=1'b0; MemRead=1'b0; MemWrite=1'b0; MemToReg=1'b0; IRWrite=1'b0; 
		PCSource=1'b0; ALUSrcB=2'b00; ALUSrcA=1'b0; RegWrite=1'b0; RegDst=1'b0; 
		PCWrite=1'b0; PCWriteCond=1'b0; ALUOp=2'b00;
		
		case (state)
			Fetch:
				begin
					MemRead = 1'b1;
					IRWrite = 1'b1;
					ALUSrcB = 2'b01;
					PCWrite = 1'b1;
				end
						 
			Decode:
				ALUSrcB = 2'b11;
							
			LoadORStore:
				begin
					ALUSrcA = 1'b1;
					ALUSrcB = 2'b10;
				end
						 
			MemAccessLoad:
				begin
					MemRead = 1'b1;
					IorD    = 1'b1;
				end
						 
			WriteBack:
				begin
					RegWrite = 1'b1;
					MemToReg = 1'b1;
					RegDst = 1'b0;
				end
						 
			MemAccessStore:
				begin
					MemWrite = 1'b1;
					IorD     = 1'b1;
				end
						 
			Execution:
				begin
					ALUSrcA = 1'b1;
					ALUOp   = 2'b10;
				end
						 
			RType:
				begin
					RegDst = 1'b1;
					RegWrite = 1'b1;
				end
						 
			Beq:
				begin
					ALUSrcA = 1'b1;
					ALUOp   = 2'b01;
					PCWriteCond = 1'b1;
					PCSource = 2'b01;
				end
						 
			J:
				begin
					PCSource = 2'b10;
					PCWrite = 1'b1;
				end
		endcase	
    end
	 
endmodule
				
				
