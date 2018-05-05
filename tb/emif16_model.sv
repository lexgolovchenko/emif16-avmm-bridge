/*
 * TI Keystone EMIF16 model
 */

// TODO:
// - multiple CE signals
// - configure polarity of wait signal

package emif16_model_pkg;
    typedef struct {
        bit       ew       ;    // 1 - enable Extended Wait Mode
        bit       ss       ;    // 1 - Enable Select Strobe Mode
        bit [3:0] w_setup  ;    // Timings
        bit [5:0] w_strobe ;
        bit [2:0] w_hold   ;
        bit [3:0] r_setup  ;
        bit [5:0] r_strobe ;
        bit [2:0] r_hold   ;
        bit [1:0] ta       ;
    } ce_cfg_t;
endpackage


module emif16_model (
    input  logic        clk_i     ,

    inout        [15:0] e_data_io ,
    output logic [23:0] e_addr_o  ,
    output logic  [1:0] e_ben_o   ,
    output logic        e_cen_o   ,
    input  logic        e_wait_i  ,
    output logic        e_wen_o   ,
    output logic        e_oen_o
);

    // ----------------------------------------------------------------
    // EMIF configuration (public)
    // ----------------------------------------------------------------

    emif16_model_pkg::ce_cfg_t ce_cfg [4];

    bit [7:0] max_ext_wait;

    initial begin : __init_cfg
        foreach (ce_cfg[i]) begin
            ce_cfg[i].ss       = '0;
            ce_cfg[i].ew       = '0;

            ce_cfg[i].w_setup  = '0;
            ce_cfg[i].w_strobe = '0;
            ce_cfg[i].w_hold   = '0;
            ce_cfg[i].r_setup  = '0;
            ce_cfg[i].r_strobe = '0;
            ce_cfg[i].r_hold   = '0;
            ce_cfg[i].ta       = '0;
        end

        max_ext_wait = 8'h80;
    end

    // ----------------------------------------------------------------
    // Tristate data bus
    // ----------------------------------------------------------------

    logic [15:0] e_data_o;
    assign e_data_io = !e_oen_o ? 'z : e_data_o;

    // ----------------------------------------------------------------
    // Synchronize E_WAIT signal to internal clock
    // ----------------------------------------------------------------

    // N.B. Probably, it's reason for minimum require time 2 EMIF clock period
    // for SETUP period and for asserted WAIT

    logic [1:0] e_wait_r;
    always_ff @(posedge clk_i)
        e_wait_r <= (e_wait_r << 1) | e_wait_i;

    wire e_wait_sync = e_wait_r[1];

    // ----------------------------------------------------------------
    // Operation states (for waveform)
    // ----------------------------------------------------------------

    enum {
        WR_IDLE,
        WR_SETUP,
        WR_STROBE,
        WR_EXT_WAIT,
        WR_HOLD,
        WR_TA
    } __wr_state = WR_IDLE;

    enum {
        RD_IDLE,
        RD_SETUP,
        RD_STROBE,
        RD_EXT_WAIT,
        RD_HOLD,
        RD_TA
    } __rd_state = RD_IDLE;

    int __wait_cnt = 0;

    event max_ext_wait_evt;

    // ----------------------------------------------------------------
    // Init outputs
    // ----------------------------------------------------------------

    initial begin : __init_outputs
        __emif_drive_idle();
    end

    task __emif_drive_idle();
        e_data_o = 'x;
        e_addr_o = 'x;
        e_ben_o  = 'x;
        e_wen_o  = '1;
        e_oen_o  = '1;
        e_cen_o  = '1;

        __wr_state = WR_IDLE;
        __rd_state = RD_IDLE;
    endtask

    // ----------------------------------------------------------------
    // Write API
    // ----------------------------------------------------------------

    task automatic write(
        input logic [23:0] addr ,
        input logic  [1:0] be   ,
        input logic [15:0] data ,
        input bit          ta=0 ,
        input bit    [1:0] ce=0
    );
        emif16_model_pkg::ce_cfg_t cfg = ce_cfg[0];

        e_addr_o = addr;
        e_ben_o  = ~be;

        e_data_o = data;

        // Setup
        __wr_state = WR_SETUP;
        if (!cfg.ss)
            e_cen_o = 0;
        __tick(cfg.w_setup + 1);

        // Strobe
        __wr_state = WR_STROBE;
        e_cen_o = 0;
        e_wen_o = 0;
        fork
            begin : strobe
                __tick(cfg.w_strobe + 1);

                disable ext_wait_mode;
                disable wait_assert_timer;
            end

            // N.B. Sync WAIT signal sould be asserted within the first half
            // of EMIF clock cycle of STROBE period
            //
            // Simplification - WAIT sould be asserted before STROBE period!!!

            if (cfg.ew) begin : ext_wait_mode
                if (e_wait_sync) begin
                    disable strobe;
                    __wr_state = WR_EXT_WAIT;

                    @(negedge e_wait_sync);
                    disable wait_assert_timer;

                    __wr_state = WR_STROBE;
                    __tick(4);
                end
            end

            // wait timer
            if (cfg.ew) begin : wait_assert_timer
                __wait_cnt = 0;

                if (e_wait_sync) begin
                    // start wait counter
                    forever begin
                        __tick(16);
                        if (__wait_cnt == max_ext_wait)
                            break;

                        __wait_cnt += 1;
                    end

                    disable ext_wait_mode;

                    -> max_ext_wait_evt;
                end
            end
        join

        // Hold
        __wr_state = WR_HOLD;
        if (cfg.ss)
            e_cen_o = 1;
        e_wen_o = 1;
        __tick(cfg.w_hold + 1);
        e_cen_o = 1;

        // Return to idle state
        __emif_drive_idle();

        // Additional delay for bus turnaround
        if (ta)
            __tick(cfg.ta + 1);
    endtask

    // ----------------------------------------------------------------
    // Read API
    // ----------------------------------------------------------------

    task automatic read(
        input  logic [23:0] addr ,
        input  logic  [1:0] be   ,
        output logic [15:0] data ,
        input  bit          ta=0 ,
        input  bit    [1:0] ce=0
    );
        emif16_model_pkg::ce_cfg_t cfg = ce_cfg[ce];

        e_addr_o = addr;
        e_ben_o  = ~be;

        // Setup
        __rd_state = RD_SETUP;
        if (!cfg.ss)
            e_cen_o = 0;
        __tick(cfg.r_setup + 1);

        // Strobe
        __rd_state = RD_STROBE;
        e_cen_o = 0;
        e_oen_o = 0;
        fork
            begin : strobe
                __tick(cfg.r_strobe + 1);

                disable ext_wait_mode;
                disable wait_assert_timer;
            end

            if (cfg.ew) begin : ext_wait_mode
                if (e_wait_sync) begin
                    disable strobe;
                    __rd_state = RD_EXT_WAIT;

                    @(negedge e_wait_sync);
                    disable wait_assert_timer;

                    __rd_state = RD_STROBE;
                    __tick(4);
                end
            end

            // wait timer
            if (cfg.ew) begin : wait_assert_timer
                __wait_cnt = 0;

                if (e_wait_sync) begin
                    // start wait counter
                    forever begin
                        __tick(16);
                        if (__wait_cnt == max_ext_wait)
                            break;

                        __wait_cnt += 1;
                    end

                    disable ext_wait_mode;

                    -> max_ext_wait_evt;
                end
            end
        join

        // Hold
        data = e_data_io;
        __rd_state = RD_HOLD;
        if (cfg.ss)
            e_cen_o = 1;
        e_oen_o = 1;
        __tick(cfg.r_hold + 1);
        e_cen_o = 1;

        // Return to idle state
        __emif_drive_idle();

        // Additional delay for bus turnaround
        if (ta)
            __tick(cfg.ta + 1);

    endtask


    task __tick(int n);
        repeat(n) @(posedge clk_i);
    endtask

endmodule
