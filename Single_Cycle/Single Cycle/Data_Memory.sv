module Data_Memory(
	input logic clk, write_enable, read_enable,
	input logic [31:0] address, writedata,
	output logic [31:0] readdata
);
	
	logic [31:0] memory [0:1023];
	
	always_ff @(negedge clk) begin
		if (write_enable)
			memory[address] <= writedata;
	end
	
	always_comb begin
		if (read_enable == 1'b1)
			readdata = memory[address];
		else
			readdata = 32'b0;
	end

endmodule