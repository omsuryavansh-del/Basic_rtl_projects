interface fifo_if(input clk);
logic rst_n;
logic write_en;
logic read_en;
logic [7:0] data_in;
logic [7:0] data_out;
logic full;
logic empty;

endinterface