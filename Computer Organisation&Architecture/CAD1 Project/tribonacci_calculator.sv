/* 
This is a synchronous Tribonacci Calculator Design used
as an example in Quartus / Modelsim tutorial
*/

module tribonacci_calculator (input logic clk, reset_n,		//module implements a function with certain values, which are given as input and output variables.
                             input logic [4:0] input_s,
                             input logic begin_tribo,
                            output logic [15:0] tribo_out,
                            output logic done);

  enum logic [1:0] {IDLE=2'b00, COMPUTE=2'b01, DONE=2'b10} state;		//enum is used to define a new data type, our own data type that we create, which is logic here. The variables are 2-bit here.

  logic  [4:0] count;	//declares a 5-bit logic type variable
  logic [15:0] R0, R1, R2;  //declares a 16-bit logic type variable

  always_ff @(posedge clk, negedge reset_n)	// this command line is used to model sequential flip-flop logic(because of _ff part and the fact that there is a clock), and it only 
															//operates when the clock is on the positive edge and the reset is on the negative edge. 
  begin		//goes inside the loop if any of the two conditions above is true
    if (!reset_n) begin		//operates when reset_n value = 0 (so that it'll be 1 inside the if condition, which is true)
      state <= IDLE;		//assigns state variable as 0, IDLE, when reset_n variable equals to 0
      done <= 0;		//assigns done variable to 0
    end else		//operates when reset_n = 1
      case (state)	//this block of code will execute based on the given value of state variables in the design.
        IDLE:	//if the current state is IDLE, which is 0, executes the next given operations
          if (begin_tribo) begin		//executes when begin_tribo = 1
            count <= input_s;		//assigns the count value to the given input value at the beginning
            R0 <= 1;		//assigns R0 value as 1
            R1 <= 1;		//assigns R1 value as 1
				R2 <= 0;		//assigns R2 value as 0
            state <= COMPUTE;		//makes the state COMPUTE 2'b01 now
          end
        COMPUTE:		//if the state is at COMPUTE, executethe next lines
          if (count > 2) begin		//executes if count value equals to 2
            count <= count - 1;		//decreases the count value by 1
            R0 <= R0 + R1 + R2;		//assigns R0 value as the sum of the three values, which are R0, R1, and R2
				R1 <= R0;		//saves R0 value to R1
            R2 <= R1;		//saves R1 value to R2. So after the last 3 lines of code, the R2 holds the sum of R0, R1, and R2 values
            $display("state = %s, count = %3d, R0 = %4d, R1 = %4d, R2 = %4d", state, count, R0, R1, R2);		//displays the arguments in the given order. 
          end else begin		//executes if count value <= 2
            state <= DONE;		//makes state value DONE now, which is 2'b10
            done <= 1;		//assigns done value as 1
            tribo_out <= R0;		//saves the value of R0 to tribo_out which is an output
          end
        DONE:		//is the state varible is at the DONE, execute the upcoming lines
          state <= IDLE;		//makes state value IDLE, which is 2'b00
      endcase		//ends the conditional blocks of code
  end
endmodule