onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/clk_i
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/e_data_io
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/e_addr_o
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/e_ben_o
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/e_cen_o
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/e_wait_i
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/e_wen_o
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/e_oen_o
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/ce_cfg
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/max_ext_wait
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/e_data_o
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/e_wait_r
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/e_wait_sync
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/__wr_state
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/__rd_state
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/__wait_cnt
add wave -noupdate -expand -group EMIF -radix hexadecimal /emif16_avmm_bridge_tb/emif/max_ext_wait_evt
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/clk_i
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/rst_i
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/avm_address_o
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/avm_writedata_o
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/avm_readdata_i
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/avm_byteenable_o
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/avm_write_o
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/avm_read_o
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/avm_waitrequest_i
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/cen_r
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/cen
add wave -noupdate -expand -group UUT -radix hexadecimal -childformat {{{/emif16_avmm_bridge_tb/uut/hold_ewait_cnt[1]} -radix hexadecimal} {{/emif16_avmm_bridge_tb/uut/hold_ewait_cnt[0]} -radix hexadecimal}} -subitemconfig {{/emif16_avmm_bridge_tb/uut/hold_ewait_cnt[1]} {-height 15 -radix hexadecimal} {/emif16_avmm_bridge_tb/uut/hold_ewait_cnt[0]} {-height 15 -radix hexadecimal}} /emif16_avmm_bridge_tb/uut/hold_ewait_cnt
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/state
add wave -noupdate -expand -group UUT -radix hexadecimal /emif16_avmm_bridge_tb/uut/avm_readdata_r
add wave -noupdate -expand -group SLAVE -radix hexadecimal /emif16_avmm_bridge_tb/address
add wave -noupdate -expand -group SLAVE -radix hexadecimal /emif16_avmm_bridge_tb/writedata
add wave -noupdate -expand -group SLAVE -radix hexadecimal /emif16_avmm_bridge_tb/readdata
add wave -noupdate -expand -group SLAVE -radix hexadecimal -childformat {{{/emif16_avmm_bridge_tb/byteenable[1]} -radix hexadecimal} {{/emif16_avmm_bridge_tb/byteenable[0]} -radix hexadecimal}} -subitemconfig {{/emif16_avmm_bridge_tb/byteenable[1]} {-height 15 -radix hexadecimal} {/emif16_avmm_bridge_tb/byteenable[0]} {-height 15 -radix hexadecimal}} /emif16_avmm_bridge_tb/byteenable
add wave -noupdate -expand -group SLAVE -radix hexadecimal /emif16_avmm_bridge_tb/write
add wave -noupdate -expand -group SLAVE -radix hexadecimal /emif16_avmm_bridge_tb/read
add wave -noupdate -expand -group SLAVE -radix hexadecimal /emif16_avmm_bridge_tb/waitrequest
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {511 ns} 0}
quietly wave cursor active 1
configure wave -namecolwidth 210
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ns} {2088 ns}
