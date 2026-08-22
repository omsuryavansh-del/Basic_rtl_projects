import f_pkg::*;

class scoreboard;

    transaction tr;
    mailbox scbm;
    logic [7:0] chimpu;
    int num_checked = 0;
    task check();
    int fifo[$:7];

    forever begin
    scbm.get(tr);
    
    $display("transaction recieved from monitor rst_n = %0b || w_en = %0b || rd_en = %0b || data_in = %0b || data_out = %0b",
                    tr.rst_n,tr.write_en,tr.read_en,tr.data_in,tr.data_out);
    if(!tr.rst_n)begin 
        fifo.delete();
    end
    else begin
    if(tr.write_en && (fifo.size() < 8)) begin 
        fifo.push_back(tr.data_in);
    end

    if(tr.read_en && (fifo.size() > 0)) begin
        chimpu = fifo.pop_front();
    end
    
    if((fifo.size() == 8) !== tr.full) $display("full mismatch expected = %0d || got = %0d",fifo.size(),tr.full);
    if((fifo.size() == 0) !== tr.empty) $display("empty mismatch expected = %0d || got = %0d",fifo.size(),tr.empty);
    
    if(tr.read_en && !tr.empty) begin
    if(chimpu !== tr.data_out) begin
        $display("test failed rst_n = %0b | expected :: data_out = %0b || data_in = %0b || got :: w_en = %0b || rd_en = %0b || data_out = %0b ",
                    tr.rst_n,chimpu,tr.data_in,tr.write_en,tr.read_en,tr.data_out);
    end 
    else begin
        $display("test passed expected data_out = %0b || got data_out = %0b ", chimpu,tr.data_out);
    end
    end
    end
    num_checked++;
    end
    endtask

endclass