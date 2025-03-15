module ControlUnit(
	input logic clk, rst,
	input logic register_write_in, write_enable_in, read_enable_in,
	input logic [1:0] writeback_sel_in,
	output logic register_write_out, write_enable_out, read_enable_out,
	output logic [1:0] writeback_sel_out
);

	always_ff @ (posedge clk) begin

		if (rst) begin
			register_write_out <= 1'b0;
			write_enable_out <= 1'b0;
			read_enable_out <= 1'b0;
			writeback_sel_out <= 2'b0;
		end

		else begin
			register_write_out <= register_write_in;
			write_enable_out <= write_enable_in;
			read_enable_out <= read_enable_in;
			writeback_sel_out <= writeback_sel_in;
		end

	end
	
endmodule
