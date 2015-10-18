`timescale 1ns / 1ps

/**
 Dual-port Instrcution/Data memory
 */

module dp_memory( 
    input wire         clk,
    input wire rst,
    input  wire        i_read_en,
    input  wire [31:0] i_addr,
    output wire [31:0] i_instr_out,
    
    output wb_done_o,

    input  wire         d_read_en,
    input  wire         d_write_en,
    input  wire [31:0]  d_addr,
    input  wire [31:0]  d_write_data,
    output wire [31:0]  d_data_out,
    
    // wb signals
    input  [31:0] wbm_dat_i,
    input  wbm_ack_i,
    output [31:0] wbm_dat_o,
    output wbm_we_o,
    output [3:0] wbm_sel_o,
    output [31:0] wbm_adr_o,
    output wbm_cyc_o,
    output wbm_stb_o
);

     localparam     mem_high_addr = 32'h00000400;
     
     wire i_bram_select, d_bram_select;
     
     reg [31:0] mem[0:mem_high_addr - 1];
     
     initial begin
          $readmemh("../../sw/test.rom", mem);      
     end
     
     assign i_bram_select = (i_addr < mem_high_addr) ? 1'b1 : 1'b0;
     assign d_bram_select = (d_addr < mem_high_addr) ? 1'b1 : 1'b0;
     
     always @(posedge clk) begin
          if (d_write_en && d_bram_select)
               mem [d_addr] <= d_write_data;      
     end
   
     assign i_instr_out = (i_read_en && i_bram_select) ? mem[i_addr] : 0;
     //assign d_data_out  = (d_read_en && d_bram_select) ? mem[d_addr] : 0;
     
     master_wb mwb_inst(
    
        .clk(clk),
        .rst(rst),
        
        .done_o(wb_done_o),
        
        .d_read_en(d_read_en),
        .d_write_en(d_write_en),
        .d_addr(d_addr),
        .d_write_data(d_write_data),
        .d_data_out(d_data_out),
    
        .wbm_dat_i(wbm_dat_i),
        .wbm_ack_i(wbm_ack_i),
        .wbm_dat_o(wbm_dat_o),
        .wbm_we_o(wbm_we_o),
        .wbm_sel_o(wbm_sel_o),
        .wbm_adr_o(wbm_adr_o),
        .wbm_cyc_o(wbm_cyc_o),
        .wbm_stb_o(wbm_stb_o)
     );
     
endmodule
     
