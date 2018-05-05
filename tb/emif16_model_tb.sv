
module emif16_model_tb #(
    parameter SEED = 0
);
    timeunit 1ns;
    timeprecision 1ps;

    // 166 MHz clock
    parameter T_clk = 6.02ns;

    logic clk = 0;
    always #(T_clk / 2) clk <= ~clk;

    // ----------------------------------------------------------------
    // UUT
    // ----------------------------------------------------------------

    wire  [15:0] e_data ;
    logic [23:0] e_addr ;
    logic  [1:0] e_ben  ;
    logic        e_cen  ;
    logic        e_wait ;
    logic        e_wen  ;
    logic        e_oen  ;

    emif16_model uut (
        .clk_i     ( clk    ),

        .e_data_io ( e_data ),
        .e_addr_o  ( e_addr ),
        .e_ben_o   ( e_ben  ),
        .e_cen_o   ( e_cen  ),
        .e_wait_i  ( e_wait ),
        .e_wen_o   ( e_wen  ),
        .e_oen_o   ( e_oen  )
    );

    // ----------------------------------------------------------------
    // Asynchronus memory slave with wait signal
    // ----------------------------------------------------------------

    logic [1:0][7:0] mem [int];
    logic [1:0][7:0] mem_rddata;
    bit mem_use_wait = 0;

    assign e_data = (!e_oen && !e_cen) ? mem_rddata : 'z;

    initial begin : mem_slave
        // Default state of WAIT - Asserted
        e_wait = 1;

        forever begin
            fork
                begin : mem_write_read
                    @(negedge e_wen or negedge e_oen);
                    if (!e_cen) begin
                        if (!e_wen) begin
                            if (!e_ben[0])
                                mem[e_addr][0] = e_data[7:0];
                            if (!e_ben[1])
                                mem[e_addr][1] = e_data[15:8];
                        end
                        else if (!e_oen)
                            mem_rddata = mem[e_addr];
                    end
                end

                begin : mem_wait
                    @(negedge e_wen or negedge e_oen);
                    if (mem_use_wait) begin
                        // Hold WAIT asserted
                        tick($urandom_range(2, 20));
                        // Deassert WAIT
                        e_wait = 0;
                        // Assert WAIT after end of strobe
                        @(posedge e_wen or posedge e_oen);
                        e_wait = 1;
                    end
                end
            join
        end
    end

    // ----------------------------------------------------------------
    // Test program
    // ----------------------------------------------------------------

    initial begin : main
        $urandom(SEED);

        tick(3);

        // Test without emif wait signal
        mem_use_wait = 0;
        emif_setup(0, 0);
        emif_write_read_test(100);
        emif_setup(0, 1);
        emif_write_read_test(100);

        // Test with emif wait signal
        mem_use_wait = 1;
        emif_setup(1, 0);
        emif_write_read_test(100);
        emif_setup(1, 1);
        emif_write_read_test(100);

        // foreach (mem[i])
        //     $display("mem[%h] = %h", i, mem[i]);

        $display("Test passed!");
        $finish;
    end


    function void emif_setup(bit ew, bit ss=0);
        uut.ce_cfg[0].ew       = ew;
        uut.ce_cfg[0].ss       = ss;

        uut.ce_cfg[0].w_setup  = $urandom_range(1, 3);
        uut.ce_cfg[0].w_strobe = $urandom_range(3, 7);
        uut.ce_cfg[0].w_hold   = $urandom_range(1, 3);
        uut.ce_cfg[0].r_setup  = $urandom_range(1, 3);
        uut.ce_cfg[0].r_strobe = $urandom_range(3, 7);
        uut.ce_cfg[0].r_hold   = $urandom_range(1, 3);
    endfunction


    typedef struct packed {
        bit     [23:0] addr ;
        bit      [1:0] be   ;
        bit [1:0][7:0] data ;
    } write_trans_t;


    task automatic emif_write_read_test(int len);
        write_trans_t write_trans_buf [$];
        write_trans_t t;
        logic [1:0][7:0] e_rddata;

        // bunch of EMIF writes
        for (int i = 0; i < len; ++i) begin
            t.addr = $urandom();
            t.be   = $urandom_range(1, 3);
            t.data = $urandom();

            if (i == len - 1)
                uut.write(t.addr, t.be, t.data, 1);
            else
                uut.write(t.addr, t.be, t.data);

            write_trans_buf.push_back(t);
        end

        // read data back
        while (write_trans_buf.size() > 0) begin
            t = write_trans_buf.pop_front();

            if (t.be == 0) begin
                if (mem.exists(t.addr)) begin
                    $display("mem[%h] must not exists!", t.addr);
                    $finish;
                end
            end
            else begin
                if (write_trans_buf.size() == 0)
                    uut.read(t.addr, t.be, e_rddata, 1);
                else
                    uut.read(t.addr, t.be, e_rddata);

                if (t.be[0] && (e_rddata[0] != t.data[0])) begin
                    $display("Read mem[%h][0]. Data mismatch!", t.addr);
                    $finish;
                end
                if (t.be[1] && (e_rddata[1] != t.data[1])) begin
                    $display("Read mem[%h][1]. Data mismatch!", t.addr);
                    $finish;
                end
            end
        end
    endtask


    task tick(int n);
        repeat(n) @(posedge clk);
    endtask

endmodule
