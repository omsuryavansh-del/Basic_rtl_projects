import f_pkg:: *;
class generator;
    transaction tr;
    mailbox gen_to_drv;

    task generator(input int n);
        repeat(n) begin
        tr = new();
        assert(tr.randomize()) else $fatal(1,"fatal:: randomization failed");
        gen_to_drv.put(tr);
        end
    endtask
        
endclass