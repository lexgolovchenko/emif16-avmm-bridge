onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -group {EMIF BFM} /emif_bridge_sys_tb/emif/clk_i
add wave -noupdate -group {EMIF BFM} -radix hexadecimal /emif_bridge_sys_tb/emif/e_data_io
add wave -noupdate -group {EMIF BFM} -radix hexadecimal /emif_bridge_sys_tb/emif/e_addr_o
add wave -noupdate -group {EMIF BFM} -radix hexadecimal /emif_bridge_sys_tb/emif/e_ben_o
add wave -noupdate -group {EMIF BFM} /emif_bridge_sys_tb/emif/e_cen_o
add wave -noupdate -group {EMIF BFM} /emif_bridge_sys_tb/emif/e_wait_i
add wave -noupdate -group {EMIF BFM} /emif_bridge_sys_tb/emif/e_wen_o
add wave -noupdate -group {EMIF BFM} /emif_bridge_sys_tb/emif/e_oen_o
add wave -noupdate -group {EMIF BFM} -radix hexadecimal /emif_bridge_sys_tb/emif/e_data_o
add wave -noupdate -group {EMIF BFM} /emif_bridge_sys_tb/emif/e_wait_r
add wave -noupdate -group {EMIF BFM} /emif_bridge_sys_tb/emif/e_wait_sync
add wave -noupdate -group {EMIF BFM} /emif_bridge_sys_tb/emif/__wr_state
add wave -noupdate -group {EMIF BFM} /emif_bridge_sys_tb/emif/__rd_state
add wave -noupdate -group {EMIF Bridge} /emif_bridge_sys_tb/uut/ti_keystone_emif_bridge_0/clk_i
add wave -noupdate -group {EMIF Bridge} /emif_bridge_sys_tb/uut/ti_keystone_emif_bridge_0/rst_i
add wave -noupdate -group {EMIF Bridge} -radix hexadecimal /emif_bridge_sys_tb/uut/ti_keystone_emif_bridge_0/avm_address_o
add wave -noupdate -group {EMIF Bridge} -radix hexadecimal /emif_bridge_sys_tb/uut/ti_keystone_emif_bridge_0/avm_writedata_o
add wave -noupdate -group {EMIF Bridge} -radix hexadecimal /emif_bridge_sys_tb/uut/ti_keystone_emif_bridge_0/avm_readdata_i
add wave -noupdate -group {EMIF Bridge} -radix hexadecimal /emif_bridge_sys_tb/uut/ti_keystone_emif_bridge_0/avm_byteenable_o
add wave -noupdate -group {EMIF Bridge} /emif_bridge_sys_tb/uut/ti_keystone_emif_bridge_0/avm_write_o
add wave -noupdate -group {EMIF Bridge} /emif_bridge_sys_tb/uut/ti_keystone_emif_bridge_0/avm_read_o
add wave -noupdate -group {EMIF Bridge} /emif_bridge_sys_tb/uut/ti_keystone_emif_bridge_0/avm_waitrequest_i
add wave -noupdate -group {EMIF Bridge} /emif_bridge_sys_tb/uut/ti_keystone_emif_bridge_0/state
add wave -noupdate -group {EMIF Bridge} -radix hexadecimal /emif_bridge_sys_tb/uut/ti_keystone_emif_bridge_0/avm_readdata_r
add wave -noupdate -group mem0 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_0/readdata
add wave -noupdate -group mem0 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_0/address
add wave -noupdate -group mem0 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_0/chipselect
add wave -noupdate -group mem0 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_0/clk
add wave -noupdate -group mem0 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_0/clken
add wave -noupdate -group mem0 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_0/reset
add wave -noupdate -group mem0 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_0/reset_req
add wave -noupdate -group mem0 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_0/write
add wave -noupdate -group mem0 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_0/writedata
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/readdata
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/address
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/byteenable
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/chipselect
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/clk
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/clken
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/reset
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/reset_req
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/write
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/writedata
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/clocken0
add wave -noupdate -group mem2 -radix hexadecimal /emif_bridge_sys_tb/uut/onchip_memory2_2/wren
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/clk
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/reset
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/avs_waitrequest
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/avs_readdatavalid
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/avs_readdata
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/avs_write
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/avs_read
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/avs_address
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/avs_byteenable
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/avs_burstcount
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/avs_beginbursttransfer
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/avs_begintransfer
add wave -noupdate -expand -group slave0 -radix hexadecimal /emif_bridge_sys_tb/uut/mm_slave_bfm_0/avs_writedata
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {247369 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 200
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {94078 ps} {330326 ps}
