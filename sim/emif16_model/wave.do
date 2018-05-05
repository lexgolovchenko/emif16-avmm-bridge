onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/clk_i
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/e_data_io
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/e_addr_o
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal -childformat {{{/emif16_model_tb/uut/e_ben_o[1]} -radix hexadecimal} {{/emif16_model_tb/uut/e_ben_o[0]} -radix hexadecimal}} -subitemconfig {{/emif16_model_tb/uut/e_ben_o[1]} {-height 15 -radix hexadecimal} {/emif16_model_tb/uut/e_ben_o[0]} {-height 15 -radix hexadecimal}} /emif16_model_tb/uut/e_ben_o
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/e_cen_o
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/e_wen_o
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/e_oen_o
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/e_wait_i
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/e_data_o
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/e_wait_r
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/e_wait_sync
add wave -noupdate -expand -group {EMIF MODEL} /emif16_model_tb/uut/__wait_cnt
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/__wr_state
add wave -noupdate -expand -group {EMIF MODEL} -radix hexadecimal /emif16_model_tb/uut/__rd_state
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {45664710 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
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
WaveRestoreZoom {0 ps} {87972518 ps}
