
module FWD_UNIT (
	input logic register_write_w,
	input logic [31:0] inst_e, inst_w,
	output logic xo_a, xo_2
);
	logic [4:0] rsource1_e, rsource2_e, wdestination_w;
	logic [6:0] opd_e, opd_w;
	
	assign rsource1_e = inst_e[19:15];
    assign rsource2_e = inst_e[24:20];
	assign wdestination_w = inst_w[11:7];
	assign opd_e = inst_e[6:0];
	assign opd_w = inst_w[6:0];

	always_comb begin
    	xo_a = 1'b0;
    	xo_2 = 1'b0;
    
   		if ((register_write_w) && (opd_w != 7'b0100011) && (opd_w != 7'b1100011)) begin
        	if ((rsource1_e == wdestination_w) && (opd_e != 7'b0110111) && (opd_e != 7'b1101111)) begin
                xo_a = 1'b1;

            if ((rsource2_e == wdestination_w) && (opd_e != 7'b0010011) && (opd_e != 7'b0000011))
                xo_2 = 1'b1;
        	end
    	end
	end

endmodule
