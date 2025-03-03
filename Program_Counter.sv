module pc (
	input logic clk, rst,
        input logic [31:0] ALU_out,
	output logic [31:0] pc
);
	always_ff @(posedge clk ) begin
		if(rst)
			pc <= 0;
		else
			pc <= ALU_out;
		end
endmodule