module fifo (
    input clk,
    input rst_n,

    input write_en,
    output read_en,

    input [7:0] data_in,
    output reg [7:0] data_out,

    output reg full,
    output reg empty

);

reg [3:0] wptr;                               // 4 bit write pointer 
reg [3:0] rdptr;                              // 4 bit read pointer

reg [7:0] mem [7:0];                          // 8 bit memory array with depth of 8

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        wptr <= 4'b0;
        rdptr <= 4'b0;
        data_out <= 8'b0;        
    end

    else begin
        if (write_en) begin 
            mem[wptr[2:0]] <= data_in;
            wptr <= wptr + 1'b1;
        end
        if (read_en) begin
            mem[rdptr[2:0]] <= data_out;
            rdptr <= rdptr + 1'b1;
        end
        
        if(wptr == rdptr) begin
            empty <= 1'b1;
        end
        if((wptr[3] != rdptr[3]) && (wptr[2:0] == rdptr[2])) begin 
            full <= 1'b1;
        end
    end


end






endmodule