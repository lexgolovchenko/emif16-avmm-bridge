
module emif_bridge_sys_tb #(
    parameter SEED = 0
);
    timeunit 1ns;
    timeprecision 1ps;

    // EMIF 166 MHz clock (CPU core / 6)
    parameter T_eclk = 6.02ns;
    logic e_clk = 0;
    always #(T_eclk / 2) e_clk <= ~e_clk;

    // UUT clock
    parameter T_clk = 10ns;
    logic clk = 0;
    logic rst = 1;
    always  #(T_clk / 2) clk <= ~clk;
    initial #(T_clk * 2) rst <= 0;

    // ----------------------------------------------------------------
    // EMIF16 BFM
    // ----------------------------------------------------------------

    wire  [15:0] e_data ;
    logic [23:0] e_addr ;
    logic  [1:0] e_ben  ;
    logic        e_cen  ;
    logic        e_wait ;
    logic        e_wen  ;
    logic        e_oen  ;


    emif16_model emif (
        .clk_i     ( e_clk  ),

        .e_data_io ( e_data ),
        .e_addr_o  ( e_addr ),
        .e_ben_o   ( e_ben  ),
        .e_cen_o   ( e_cen  ),
        .e_wait_i  ( e_wait ),
        .e_wen_o   ( e_wen  ),
        .e_oen_o   ( e_oen  )
    );


    function void emif_setup();
        // Extended Waid & Select Strobe Enabled
        emif.ce_cfg[0].ew = 1;
        emif.ce_cfg[0].ss = 1;

        emif.ce_cfg[0].w_setup  = $urandom_range(1, 3);
        emif.ce_cfg[0].w_strobe = $urandom_range(1, 7);
        emif.ce_cfg[0].w_hold   = $urandom_range(5, 7);
        emif.ce_cfg[0].r_setup  = $urandom_range(1, 3);
        emif.ce_cfg[0].r_strobe = $urandom_range(1, 7);
        emif.ce_cfg[0].r_hold   = $urandom_range(5, 7);

        // N.B. w_hold and r_hold should be large enough that
        // wait have time to return to asserted state before next EMIF16 cycle
    endfunction

    initial begin
        emif_setup();
    end

    // ----------------------------------------------------------------
    // UUT
    // ----------------------------------------------------------------

    // N.B. Avalon-MM memories are byte-addressable,
    // but EMIF16 address is address of 16-bit word
    // In this testbench we need address translation,
    // but DPS uses byte addressing

    // EMIF16 bridge memory map

    // Slave BFM
    localparam SLAVE0_BASE = 'h0000_7800;
    localparam SLAVE0_SPAN = 1024;
    localparam SLAVE1_BASE = 'h0000_7000;
    localparam SLAVE1_SPAN = 1024 * 2;
    localparam SLAVE2_BASE = 'h0000_2000;
    localparam SLAVE2_SPAN = 1024 * 4;
    localparam SLAVE3_BASE = 'h0000_0000;
    localparam SLAVE3_SPAN = 1024 * 8;

    // On Chip RAM
    localparam MEM0_BASE = 'h0000_6000;
    localparam MEM0_SPAN = 4096;
    localparam MEM1_BASE = 'h0000_5000;
    localparam MEM1_SPAN = 4096;
    localparam MEM2_BASE = 'h0000_4000;
    localparam MEM2_SPAN = 4096;
    localparam MEM3_BASE = 'h0000_3000;
    localparam MEM3_SPAN = 4096;

    emif16_avmm_bridge_test_sys uut (
        .clk_clk       (  clk   ),
        .reset_reset_n ( ~rst   ),

        .emif_data_io  ( e_data ),
        .emif_addr_i   ( e_addr ),
        .emif_ben_i    ( e_ben  ),
        .emif_cen_i    ( e_cen  ),
        .emif_wait_o   ( e_wait ),
        .emif_wen_i    ( e_wen  ),
        .emif_oen_i    ( e_oen  )
    );

    // ----------------------------------------------------------------
    // EMIF16 BFM test Programm
    // ----------------------------------------------------------------

    typedef struct packed {
        logic [1:0][7:0] data;
        logic      [1:0] be;
        logic     [23:0] addr;
    } trans_t;

    function void display_trans(trans_t tr);
        $display("A %6.6x - BE %1x - D %4.4x",
                 tr.addr, tr.be, tr.data);
    endfunction

    function void display_read_trans(trans_t tr, logic [15:0] rddata);
        $display("A %6.6x - BE %1x - D %4.4x - RD %4.4x",
                 tr.addr, tr.be, tr.data, rddata);
    endfunction

    trans_t tr_buf [];
    logic [23:0] addr_buf [$];

    task automatic memory_test(int qsys_base, int qsys_span, int test_size);
        static bit verbose = 0;

        trans_t tr;
        logic [1:0][7:0] rddata;
        logic [23:0] addr;

        // Memory is byte-addressable
        // but EMIF16 address is address of 16-bit word
        int base = qsys_base / 2;
        int span = qsys_span / 2;

        addr_buf = {};
        tr_buf = {};
        tr_buf = new[test_size];

        // generate unique random address
        while (addr_buf.size() != test_size) begin
            addr = $urandom_range(base, base + span - 1);
            if (!(addr inside {addr_buf}))
                addr_buf.push_back(addr);
        end

        // bunch of write transactions
        for (int i = 0; i < test_size; ++i) begin
            // Create random EMIF16 transction
            tr = 'x;
            tr.addr = addr_buf[i];
            tr.be   = $urandom_range(1, 3);
            // tr.addr = base + i;
            if (tr.be[0])
                tr.data[0] = $random;
            if (tr.be[1])
                tr.data[1] = $random;

            emif.write(tr.addr, tr.be, tr.data);
            // display_trans(tr);

            // Save transaction
            tr_buf[i] = tr;
        end

        // $display("");

        // Read in different order!
        tr_buf.shuffle();

        // bunch of read transactions
        for (int i = 0; i < test_size; ++i) begin
            tr = tr_buf[i];
            emif.read(tr.addr, tr.be, rddata);

            if (verbose)
                display_read_trans(tr, rddata);

            if (tr.be[0]) begin
                if (rddata[0] !== tr.data[0]) begin
                    $display("%m: Error! Data mismatch!");
                    display_read_trans(tr, rddata);
                    $finish;
                end
            end
            if (tr.be[1]) begin
                if (rddata[1] !== tr.data[1]) begin
                    $display("%m: Error! Data mismatch!");
                    display_read_trans(tr, rddata);
                    $finish;
                end
            end
        end

        if (verbose)
            $display("");
    endtask

    // ----------------------------------------------------------------
    // Avalon-MM Slave BFM
    // ----------------------------------------------------------------

    `define SLAVE $root.emif_bridge_sys_tb.uut.mm_slave_bfm_0
    `include "../../tb/avmm_slave_bfm_test_program.svh"
    `undef SLAVE

    `define SLAVE $root.emif_bridge_sys_tb.uut.mm_slave_bfm_1
    `include "../../tb/avmm_slave_bfm_test_program.svh"
    `undef SLAVE

    `define SLAVE $root.emif_bridge_sys_tb.uut.mm_slave_bfm_2
    `include "../../tb/avmm_slave_bfm_test_program.svh"
    `undef SLAVE

    `define SLAVE $root.emif_bridge_sys_tb.uut.mm_slave_bfm_3
    `include "../../tb/avmm_slave_bfm_test_program.svh"
    `undef SLAVE

    // ----------------------------------------------------------------
    // Main thread
    // ----------------------------------------------------------------

    logic [1:0][7:0] rddata;

    initial begin : main
        $urandom(SEED);

        // Wait reset deassertion
        wait(uut.ti_keystone_emif_bridge_0.rst_i == 0);
        e_tick(5);

        memory_test(MEM0_BASE, MEM0_SPAN, 100);
        memory_test(MEM1_BASE, MEM1_SPAN, 100);
        memory_test(MEM2_BASE, MEM2_SPAN, 100);
        memory_test(MEM3_BASE, MEM3_SPAN, 100);

        memory_test(SLAVE0_BASE, SLAVE0_SPAN, 100);
        memory_test(SLAVE1_BASE, SLAVE1_SPAN, 100);
        memory_test(SLAVE2_BASE, SLAVE2_SPAN, 100);
        memory_test(SLAVE3_BASE, SLAVE3_SPAN, 100);

        $display("\nTest passed!\n",);

        $finish;
    end

    task e_tick(int n);
        repeat(n) @(posedge e_clk);
    endtask

endmodule
