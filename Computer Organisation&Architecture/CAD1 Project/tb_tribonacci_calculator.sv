/* 
This is a verification module for Tribonacci Calculator used
as an example in Quartus / Modelsim tutorial
*/

module tb_tribonacci_calculator;

  logic clk, reset_n;  //logic introduces a new 4-state data type called clk and reset_n
  logic [4:0] input_s;
  logic begin_tribo;
  logic [15:0] tribo_out;
  logic done;

  // instantiate your design
 tribonacci_calculator uut(clk, reset_n, input_s, begin_tribo, tribo_out, done);

  // Clock Generator
  always
  begin
	#1250      //waits for 1250, a delay of 1250 ns we can say
	clk = 1'b1;     //assigns clock to 1
	#1250       //delay of 1250 ns again
	clk = 1'b0;     //assigns clock to 0
  end

  initial       //creates an initial block
  begin     //beginning of the intial block
	/* ------------- Input of 5 ------------- */
        // Reset
	@(posedge clk) reset_n = 0;     //when the clock is on the positive edge, assign reset_n value to 0
	for (int k = 0; k < 2; k++) @(posedge clk);     //executes when the condition, k<2, is true at the positive edge of the clock 
	reset_n = 1;        //makes reset_n value 1
	begin_tribo = 1'b0;     //makes begin_tribo value 0
	for (int k = 0; k < 2; k++) @(posedge clk);     //executes when the condition is held
	// Inputs into module/ Assert begin_tribo
	input_s = 5;        //assigns the input_s value to 5
	begin_tribo = 1'b1;     //makes begin_tribo value 1
	for (int k = 0; k < 2; k++) @(posedge clk);
	begin_tribo = 1'b0;     //makes the begin_tribo value 0
	
	
	wait (done == 1);       // Wait until calculation is done	

	// Idle cycles before next input
	for (int k = 0; k < 2; k++) @(posedge clk);

	// Display
	$display("\n---------------------\n");      //displays the given text
	$display("Input: 5\n");     //displays the given text

	if (tribo_out === 7)
	    $display("CORRECT RESULT: %d, GOOD JOB!\n", tribo_out);
	else
	    $display("INCORRECT RESULT: %d, SHOULD BE: 7\n", tribo_out);

	$display("---------------------\n");


	/* ------------- Input of 9 ------------- */
        // Reset
	@(posedge clk) reset_n = 0;
	for (int k = 0; k < 2; k++) @(posedge clk);
	reset_n = 1;
	begin_tribo = 1'b0;
	for (int k = 0; k < 2; k++) @(posedge clk);
	
	// Inputs into module/ Assert begin_tribo
	input_s = 9;
	begin_tribo = 1'b1;
	for (int k = 0; k < 2; k++) @(posedge clk);
	begin_tribo = 1'b0;
	
	// Wait until calculation is done	
	wait (done == 1);

	// Idle cycles before next input
	for (int k = 0; k < 2; k++) @(posedge clk);

	// Display
	$display("\n---------------------\n");
	$display("Input: 9\n");

	if (tribo_out === 81)
	    $display("CORRECT RESULT: %d, GOOD JOB!\n", tribo_out);
	else
	    $display("INCORRECT RESULT: %d, SHOULD BE: 81\n", tribo_out);

	$display("---------------------\n");



	/* ------------- Input of 12 ------------- */
        // Reset
	@(posedge clk) reset_n = 0;
	for (int k = 0; k < 2; k++) @(posedge clk);
	reset_n = 1;
	begin_tribo = 1'b0;
	for (int k = 0; k < 2; k++) @(posedge clk);
	
	// Inputs into module/ Assert begin_tribo
	input_s = 12;
	begin_tribo = 1'b1;
	for (int k = 0; k < 2; k++) @(posedge clk);
	begin_tribo = 1'b0;
	
	// Wait until calculation is done	
	wait (done == 1);

	// Idle cycles before next input
	for (int k = 0; k < 2; k++) @(posedge clk);

	// Display
	$display("\n---------------------\n");
	$display("Input: 12\n");

	if (tribo_out === 504)
	    $display("CORRECT RESULT: %d, GOOD JOB!\n", tribo_out);
	else
	    $display("INCORRECT RESULT: %d, SHOULD BE: 504\n", tribo_out);

	$display("---------------------\n");
	
	
	
	//MODIFIED PART OF THE CODE FOR INPUT 15 (THE TRIBONACCI OF FIRST 15 NUMBERS)
	
	/* ------------- Input of 15 ------------- */
        // Reset
	@(posedge clk) reset_n = 0;
	for (int k = 0; k < 2; k++) @(posedge clk);
	reset_n = 1;
	begin_tribo = 1'b0;
	for (int k = 0; k < 2; k++) @(posedge clk);
	
	// Inputs into module/ Assert begin_tribo
	input_s = 15;
	begin_tribo = 1'b1;
	for (int k = 0; k < 2; k++) @(posedge clk);
	begin_tribo = 1'b0;
	
	// Wait until calculation is done	
	wait (done == 1);

	// Idle cycles before next input
	for (int k = 0; k < 2; k++) @(posedge clk);

	// Display
	$display("\n---------------------\n");
	$display("Input: 15\n");

	if (tribo_out === 3136)
	    $display("CORRECT RESULT: %d, GOOD JOB!\n", tribo_out);
	else
	    $display("INCORRECT RESULT: %d, SHOULD BE: 3136\n", tribo_out);

	$display("---------------------\n");
	

	$stop;      //stops the execution
  end
endmodule