
module emif16_avmm_bridge_tb #(
    parameter SEED = 0
);
    timeunit 1ns;
    timeprecision 1ns;

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
        emif.ce_cfg[0].w_hold   = $urandom_range(5, 8);
        emif.ce_cfg[0].r_setup  = $urandom_range(1, 3);
        emif.ce_cfg[0].r_strobe = $urandom_range(1, 7);
        emif.ce_cfg[0].r_hold   = $urandom_range(5, 8);
    endfunction

    // ----------------------------------------------------------------
    // UUT
    // ----------------------------------------------------------------

    logic [23:0] address     ;
    logic [15:0] writedata   ;
    logic [15:0] readdata    ;
    logic  [1:0] byteenable  ;
    logic        write       ;
    logic        read        ;
    logic        waitrequest ;

    emif16_avmm_bridge #(
        .SYNC_STAGES (2),
        .HOLD_CYCLES (2)
    ) uut (
        .e_data_io         ( e_data ),
        .e_addr_i          ( e_addr ),
        .e_ben_i           ( e_ben  ),
        .e_cen_i           ( e_cen  ),
        .e_wait_o          ( e_wait ),
        .e_wen_i           ( e_wen  ),
        .e_oen_i           ( e_oen  ),

        .clk_i             ( clk    ),
        .rst_i             ( rst    ),

        .avm_address_o     ( address     ),
        .avm_writedata_o   ( writedata   ),
        .avm_readdata_i    ( readdata    ),
        .avm_byteenable_o  ( byteenable  ),
        .avm_write_o       ( write       ),
        .avm_read_o        ( read        ),
        .avm_waitrequest_i ( waitrequest )
    );

    // ----------------------------------------------------------------
    // Avalon-MM Slave with waitrequest
    // ----------------------------------------------------------------

    logic [1:0][7:0] avs_mem [int];

    initial begin : avalon_slave
        // Default state - waitrequest asserted
        waitrequest = 1;

        wait(rst == 0);
        tick(1);

        forever begin
            @(posedge write or posedge read);
            // Hold waitrequest
            tick($urandom_range(0, 10));
            // Perform request
            if (write) begin
                if (byteenable[0])
                    avs_mem[address][0] = writedata[7:0];
                if (byteenable[1])
                    avs_mem[address][1] = writedata[15:8];
            end
            else begin // if (read) begin
                readdata = avs_mem[address];
            end
            // Deassert waitrequest
            waitrequest = 0;
            tick(1);
            waitrequest = 1;
        end
    end

    task tick(int n);
        repeat(n) @(posedge clk);
    endtask

    // ----------------------------------------------------------------
    // Test program
    // ----------------------------------------------------------------

    initial begin : main
        emif_setup();
        e_tick(10);

        emif_write_read_test(100);
        $display("\nTest passed!\n");

        $finish;
    end


    typedef struct packed {
        bit     [23:0] addr ;
        bit      [1:0] be   ;
        bit [1:0][7:0] data ;
    } write_trans_t;


    task automatic emif_write_read_test(int len);
        static bit verbose = 0;

        write_trans_t write_trans_buf [$];
        write_trans_t t;
        logic [1:0][7:0] e_rddata;

        // bunch of EMIF writes
        for (int i = 0; i < len; ++i) begin
            t.addr = $urandom();
            t.be   = $urandom_range(1, 3);
            t.data = $urandom();

            if (i == len - 1)
                emif.write(t.addr, t.be, t.data, 1);
            else
                emif.write(t.addr, t.be, t.data);

            write_trans_buf.push_back(t);
        end

        if (avs_mem.size() != len) begin
            $display("Amount of written data in avs_mem and specified value mismatch!");
            $finish;
        end

        // read data back
        while (write_trans_buf.size() > 0) begin
            t = write_trans_buf.pop_front();

            if (t.be == 0) begin
                if (avs_mem.exists(t.addr)) begin
                    $display("avs_mem[%h] must not exists!", t.addr);
                    $finish;
                end
            end
            else begin
                if (write_trans_buf.size() == 0)
                    emif.read(t.addr, t.be, e_rddata, 1);
                else
                    emif.read(t.addr, t.be, e_rddata);

                if (t.be[0] && (e_rddata[0] !== t.data[0])) begin
                    $display("Read avs_mem[%h][0]. Data mismatch!", t.addr);
                    $finish;
                end
                if (t.be[1] && (e_rddata[1] !== t.data[1])) begin
                    $display("Read avs_mem[%h][1]. Data mismatch!", t.addr);
                    $finish;
                end

                if (verbose)
                    $display("A=%x, BE=%x, REFD=%x, RD=%x",
                             t.addr, t.be, t.data, e_rddata);
            end
        end
    endtask

    task e_tick(int n);
        repeat(n) @(posedge e_clk);
    endtask




endmodule
