module WB_Mux (
    input logic [1:0] writeback_sel_w,
    input logic [31:0] ALU_res_w, rdata, pc_w,
    output logic [31:0] wdata 
);
   
    always_comb begin

         case (writeback_sel_w)
            2'b00: wdata = pc_w + 4;
            2'b01: wdata = ALU_res_w;
            2'b10: wdata = rdata;
            default: wdata = 32'b0; 
        endcase

    end

endmodule
