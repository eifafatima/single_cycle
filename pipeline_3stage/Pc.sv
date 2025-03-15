module Pc(
	input logic clk, reset,
	input logic [31:0] ALU_out,
	output logic [31:0] Pc
);
	
	always_ff @(posedge clk) begin

		if (reset)
			Pc <= 32'b0;
		else
			Pc <= ALU_out;
	end

endmodule
