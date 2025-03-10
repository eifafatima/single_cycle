module Register_File(
	input logic clk, reg_write,
	input logic [4:0] rsource1, rsource2, rdestination, 
	input logic [31:0] write_data,
	output logic [31:0] rdata1, rdata2
);
	logic [31:0] registers [0:31];

	always_comb begin 
		rdata1 = registers[rsource1];
		rdata2 = registers[rsource2];
	end

	always_ff @(negedge clk) begin
		registers[0] <= 32'b0;
		if (reg_write == 1'b1)
			registers[rdestination] <= write_data;
	end

	

endmodule