import f_pkg::*;

class environment;
    
    virtual fifo_if f_if;
    generator gen;
    driver dr;
    monitor mon;
    scoreboard scb;

    mailbox gen_to_drv;
    mailbox mon_to_scb;

    function new();

        gen = new();
        dr = new();
        mon = new();
        scb = new();
        gen_to_drv = new();
        mon_to_scb = new();

        gen.gen_to_drv = gen_to_drv;
        dr.driver_mbx = gen_to_drv;

        mon.mon_to_scb = mon_to_scb;
        scb.scbm = mon_to_scb;

    endfunction

    function void connect();
    dr.f_if = f_if;
    mon.f_if = f_if;
    endfunction

    task run(input int n);
    int target = scb.num_checked + n;
    fork
    gen.generator(n);
    dr.drive();
    mon.monitor();
    scb.check();
    join_none

    wait(scb.num_checked == target);
    disable fork;

    endtask

endclass 