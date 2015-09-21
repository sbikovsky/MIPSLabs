/*
 MIPS System: CPU Core + Memory 
 */

module mips_system ( input wire    clk,
                     input wire    rst,
                     
                     output        mem_instr_read,
                     output [31:0] mem_instr_addr_bus, mem_instr_read_bus,
                                     
                     output        mem_data_write, mem_data_read,                     
                     output [31:0] mem_data_addr_bus, mem_data_read_bus, mem_data_write_bus );

     wire        i_read_en;   
     wire [31:0] i_addr;
     wire [31:0] i_instr;
     wire        d_read_en;   
     wire        d_write_en;   
     wire [31:0] d_addr;   
     wire [31:0] d_write_data;   
     wire [31:0] d_read_data;
     
     assign mem_instr_read     = i_read_en;
     assign mem_instr_addr_bus = i_addr;
     assign mem_instr_read_bus = i_instr;
     
     assign mem_data_write     = d_write_en;
     assign mem_data_read      = d_read_en;
     
     assign mem_data_addr_bus  = d_addr;
     assign mem_data_read_bus  = d_read_data;
     assign mem_data_write_bus = d_write_data;
   
     pipeline pipeline_inst (
          .clk(clk),
          .rst(rst),
          .i_read_en(i_read_en),
          .i_addr(i_addr),
          .i_instr_in(i_instr),  
          .d_read_en(d_read_en),
          .d_write_en(d_write_en),
          .d_addr(d_addr),
          .d_write_data(d_write_data),
          .d_data_in(d_read_data));

     dp_memory memory_inst (
          .clk(clk),
          .i_read_en(i_read_en),
          .i_addr(i_addr),
          .i_instr_out(i_instr),
          .d_read_en(d_read_en),
          .d_write_en(d_write_en),
          .d_addr(d_addr),
          .d_write_data(d_write_data),
          .d_data_out(d_read_data));
   
endmodule // mips_system
