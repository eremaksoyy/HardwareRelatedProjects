module tb_mips_mc;
			logic clk;
			logic reset;
			logic [5:0] Opcode_Out;	
			mips_mc utb(.clk(clk), .reset(reset), .Opcode_Out(Opcode_Out));
			initial
				forever #10000 clk=~clk;
			initial begin
					clk=0; #20000;
					reset=1;
					reset=0;
					#1000000 $finish;
	end
endmodule

