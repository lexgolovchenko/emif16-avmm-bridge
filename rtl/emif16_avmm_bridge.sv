
module emif16_avmm_bridge #(
    parameter SYNC_STAGES = 2,
    parameter HOLD_CYCLES = 2
)(
    // Async EMIF16 signals
    inout  logic [15:0] e_data_io   ,
    input  logic [23:0] e_addr_i    ,
    input  logic  [1:0] e_ben_i     ,
    input  logic        e_cen_i     ,
    output logic        e_wait_o    ,
    input  logic        e_wen_i     ,
    input  logic        e_oen_i     ,

    // Internal FPGA clock & reset
    input  logic        clk_i       ,
    input  logic        rst_i       ,

    // Avalon-MM signals
    output logic [23:0] avm_address_o       ,
    output logic [15:0] avm_writedata_o     ,
    input  logic [15:0] avm_readdata_i      ,
    output logic  [1:0] avm_byteenable_o    ,
    output logic        avm_write_o         ,
    output logic        avm_read_o          ,
    input  logic        avm_waitrequest_i
);

    // ----------------------------------------------------------------
    // Synchronize EMIF control signals
    // ----------------------------------------------------------------

    logic [SYNC_STAGES - 1:0] cen_r;
    always_ff @(posedge clk_i)
        cen_r <= (cen_r << 1) | e_cen_i;

    wire cen = cen_r[SYNC_STAGES - 1];

    // ----------------------------------------------------------------
    // Handling EMIF16 WAIT
    // ----------------------------------------------------------------

    logic [$clog2(HOLD_CYCLES):0] hold_ewait_cnt;

    enum logic [2:0] {
        IDLE,
        HOLD_EWAIT,
        WRITE,
        READ,
        WAIT_STROBE_END
    } state;

    always_ff @(posedge clk_i or posedge rst_i)
        if (rst_i)
            state <= IDLE;
        else case (state)
            IDLE:
                if (!cen)
                    state <= HOLD_EWAIT;

            HOLD_EWAIT:
                if (hold_ewait_cnt == '0) begin
                    if (!e_wen_i)
                        state <= WRITE;
                    else if (!e_oen_i)
                        state <= READ;
                end

            WRITE:
                if (!avm_waitrequest_i)
                    state <= WAIT_STROBE_END;

            READ:
                if (!avm_waitrequest_i)
                    state <= WAIT_STROBE_END;

            WAIT_STROBE_END:
                if (cen)
                    state <= IDLE;
        endcase


    always_ff @(posedge clk_i)
        if (state != HOLD_EWAIT)
            hold_ewait_cnt <= HOLD_CYCLES - 1;
        else
            hold_ewait_cnt <= hold_ewait_cnt - 1'b1;

    // ----------------------------------------------------------------
    // Drive Avalon-MM
    // ----------------------------------------------------------------

    assign avm_write_o = (state == WRITE);
    assign avm_read_o  = (state == READ);

    always_ff @(posedge clk_i) begin
        if (state == IDLE && !cen) begin
            avm_address_o    <= e_addr_i;
            avm_byteenable_o <= ~e_ben_i;
            avm_writedata_o  <= e_data_io;
        end
    end

    logic [15:0] avm_readdata_r;

    always_ff @(posedge clk_i)
        if (state == READ && !avm_waitrequest_i)
            avm_readdata_r <= avm_readdata_i;

    // ----------------------------------------------------------------
    // Drive EMIF
    // ----------------------------------------------------------------

    assign e_data_io = (!e_cen_i && !e_oen_i) ? avm_readdata_r : 'z;
    assign e_wait_o = ~(state == WAIT_STROBE_END);

endmodule
