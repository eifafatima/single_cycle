module DFF(
	input logic clk, rst, 
	input logic [31:0] In,
	output logic [31:0] Out
);

	always_ff @ (posedge clk) begin
		
		
		if (rst)
			Out <= 32'b0;
		else
			Out <= In;
			
	end
	
endmodule
