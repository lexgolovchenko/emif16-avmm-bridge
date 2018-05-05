
generate begin
    import avalon_mm_pkg::*;

    localparam ADDR_W     = `SLAVE.AV_ADDRESS_W    ;
    localparam SYMB_W     = `SLAVE.AV_SYMBOL_W     ;
    localparam NUMSYMB    = `SLAVE.AV_NUMSYMBOLS   ;
    localparam BURSTCNT_W = `SLAVE.AV_BURSTCOUNT_W ;

    localparam MAX_COMMAND_BACKPRESSURE = 5;
    localparam MAX_BURST                = 2 ** (BURSTCNT_W - 1);
    localparam MAX_DATA_IDLE            = 3;

    logic [NUMSYMB - 1:0][SYMB_W - 1:0] mem [logic [ADDR_W - 1:0]];

    function void set_backpressure_cycles();
        automatic int backpressure_cycles;
        for (int i = 0; i < MAX_BURST; ++i) begin
            backpressure_cycles = $urandom_range(0, MAX_COMMAND_BACKPRESSURE);
            `SLAVE.set_interface_wait_time(backpressure_cycles, i);
        end
    endfunction

    // ----------------------------------------------------------------
    // Slave BFM initialization
    // ----------------------------------------------------------------

    initial begin
        // set random backpressure cycles for first command
        set_backpressure_cycles();
    end

    // ----------------------------------------------------------------
    // Slave BFM request processing thread
    // ----------------------------------------------------------------

    always @(`SLAVE.signal_command_received) begin
        logic [ADDR_W - 1:0] addr;
        logic [BURSTCNT_W - 1:0] burstcnt;
        Request_t req;
        logic [NUMSYMB - 1:0] byteena;
        logic [NUMSYMB - 1:0][SYMB_W - 1:0] data;
        int data_latency;
        int read_response_latency;

        // set random backpressure cycles for next command
        set_backpressure_cycles();

        // get and process command
        `SLAVE.pop_command();
        addr = `SLAVE.get_command_address();
        burstcnt = `SLAVE.get_command_burst_count();
        req = `SLAVE.get_command_request();

        if (req == REQ_WRITE) begin
            for (int i = 0; i < burstcnt; ++i) begin
                data = `SLAVE.get_command_data(i);
                byteena = `SLAVE.get_command_byte_enable(i);

                for (int j = 0; j < NUMSYMB; ++j)
                    if (byteena[j])
                        mem[addr + i][j] = data[j];
            end
        end
        else begin // req == REQ_READ
            `SLAVE.set_response_request(REQ_READ);
            `SLAVE.set_response_burst_size(burstcnt);

            for (int i = 0; i < burstcnt; ++i) begin
                `SLAVE.set_response_data(mem[addr + i], i);
                data_latency = $urandom_range(0, MAX_DATA_IDLE);
            end

            `SLAVE.push_response();
        end
    end

end endgenerate
