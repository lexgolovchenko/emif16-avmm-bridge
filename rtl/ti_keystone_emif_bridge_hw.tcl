# TCL File Generated by Component Editor 15.1
# Thu Feb 22 13:09:50 GMT+03:00 2018
# DO NOT MODIFY


#
# ti_keystone_emif_bridge "TI Keystone EMIF Bridge" v1.0
#  2018.02.22.13:09:50
#
#

#
# request TCL package from ACDS 15.1
#
# package require -exact qsys 15.1
package require -exact qsys 13.1


#
# module ti_keystone_emif_bridge
#
set_module_property DESCRIPTION ""
set_module_property NAME ti_keystone_emif_bridge
set_module_property VERSION 1.0
set_module_property INTERNAL false
set_module_property OPAQUE_ADDRESS_MAP true
set_module_property AUTHOR ""
set_module_property DISPLAY_NAME "TI Keystone EMIF Bridge"
set_module_property INSTANTIATE_IN_SYSTEM_MODULE true
set_module_property EDITABLE true
set_module_property REPORT_TO_TALKBACK false
set_module_property ALLOW_GREYBOX_GENERATION false
set_module_property REPORT_HIERARCHY false


#
# file sets
#
add_fileset QUARTUS_SYNTH QUARTUS_SYNTH "" ""
set_fileset_property QUARTUS_SYNTH TOP_LEVEL emif16_avmm_bridge
set_fileset_property QUARTUS_SYNTH ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property QUARTUS_SYNTH ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file emif16_avmm_bridge.sv SYSTEM_VERILOG PATH emif16_avmm_bridge.sv TOP_LEVEL_FILE

add_fileset SIM_VERILOG SIM_VERILOG "" ""
set_fileset_property SIM_VERILOG TOP_LEVEL emif16_avmm_bridge
set_fileset_property SIM_VERILOG ENABLE_RELATIVE_INCLUDE_PATHS false
set_fileset_property SIM_VERILOG ENABLE_FILE_OVERWRITE_MODE false
add_fileset_file emif16_avmm_bridge.sv SYSTEM_VERILOG PATH emif16_avmm_bridge.sv


#
# parameters
#
add_parameter SYNC_STAGES NATURAL 2 ""
set_parameter_property SYNC_STAGES DEFAULT_VALUE 2
set_parameter_property SYNC_STAGES DISPLAY_NAME SYNC_STAGES
set_parameter_property SYNC_STAGES WIDTH ""
set_parameter_property SYNC_STAGES TYPE NATURAL
set_parameter_property SYNC_STAGES UNITS None
set_parameter_property SYNC_STAGES ALLOWED_RANGES 0:2147483647
set_parameter_property SYNC_STAGES DESCRIPTION ""
set_parameter_property SYNC_STAGES HDL_PARAMETER true
add_parameter HOLD_CYCLES NATURAL 2 ""
set_parameter_property HOLD_CYCLES DEFAULT_VALUE 2
set_parameter_property HOLD_CYCLES DISPLAY_NAME HOLD_CYCLES
set_parameter_property HOLD_CYCLES WIDTH ""
set_parameter_property HOLD_CYCLES TYPE NATURAL
set_parameter_property HOLD_CYCLES UNITS None
set_parameter_property HOLD_CYCLES ALLOWED_RANGES 0:2147483647
set_parameter_property HOLD_CYCLES DESCRIPTION ""
set_parameter_property HOLD_CYCLES HDL_PARAMETER true


#
# display items
#


#
# connection point avalon_master
#
add_interface avalon_master avalon start
set_interface_property avalon_master addressUnits WORDS
set_interface_property avalon_master associatedClock clock_sink
set_interface_property avalon_master associatedReset reset_sink
set_interface_property avalon_master bitsPerSymbol 8
set_interface_property avalon_master burstOnBurstBoundariesOnly false
set_interface_property avalon_master burstcountUnits WORDS
set_interface_property avalon_master doStreamReads false
set_interface_property avalon_master doStreamWrites false
set_interface_property avalon_master holdTime 0
set_interface_property avalon_master linewrapBursts false
set_interface_property avalon_master maximumPendingReadTransactions 0
set_interface_property avalon_master maximumPendingWriteTransactions 0
set_interface_property avalon_master readLatency 0
set_interface_property avalon_master readWaitTime 0
set_interface_property avalon_master setupTime 0
set_interface_property avalon_master timingUnits Cycles
set_interface_property avalon_master writeWaitTime 0
set_interface_property avalon_master ENABLED true
set_interface_property avalon_master EXPORT_OF ""
set_interface_property avalon_master PORT_NAME_MAP ""
set_interface_property avalon_master CMSIS_SVD_VARIABLES ""
set_interface_property avalon_master SVD_ADDRESS_GROUP ""

add_interface_port avalon_master avm_readdata_i readdata Input 16
add_interface_port avalon_master avm_waitrequest_i waitrequest Input 1
add_interface_port avalon_master avm_address_o address Output 24
add_interface_port avalon_master avm_byteenable_o byteenable Output 2
add_interface_port avalon_master avm_read_o read Output 1
add_interface_port avalon_master avm_write_o write Output 1
add_interface_port avalon_master avm_writedata_o writedata Output 16


#
# connection point clock_sink
#
add_interface clock_sink clock end
set_interface_property clock_sink clockRate 0
set_interface_property clock_sink ENABLED true
set_interface_property clock_sink EXPORT_OF ""
set_interface_property clock_sink PORT_NAME_MAP ""
set_interface_property clock_sink CMSIS_SVD_VARIABLES ""
set_interface_property clock_sink SVD_ADDRESS_GROUP ""

add_interface_port clock_sink clk_i clk Input 1


#
# connection point reset_sink
#
add_interface reset_sink reset end
set_interface_property reset_sink associatedClock clock_sink
set_interface_property reset_sink synchronousEdges DEASSERT
set_interface_property reset_sink ENABLED true
set_interface_property reset_sink EXPORT_OF ""
set_interface_property reset_sink PORT_NAME_MAP ""
set_interface_property reset_sink CMSIS_SVD_VARIABLES ""
set_interface_property reset_sink SVD_ADDRESS_GROUP ""

add_interface_port reset_sink rst_i reset Input 1


#
# connection point emif
#
add_interface emif conduit end
set_interface_property emif associatedClock ""
set_interface_property emif associatedReset ""
set_interface_property emif ENABLED true
set_interface_property emif EXPORT_OF ""
set_interface_property emif PORT_NAME_MAP ""
set_interface_property emif CMSIS_SVD_VARIABLES ""
set_interface_property emif SVD_ADDRESS_GROUP ""

add_interface_port emif e_addr_i addr_i Input 24
add_interface_port emif e_ben_i ben_i Input 2
add_interface_port emif e_cen_i cen_i Input 1
add_interface_port emif e_data_io data_io Bidir 16
add_interface_port emif e_oen_i oen_i Input 1
add_interface_port emif e_wait_o wait_o Output 1
add_interface_port emif e_wen_i wen_i Input 1

