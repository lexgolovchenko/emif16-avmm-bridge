
# QUARTUS_PATH = c:/altera/15.1/quartus
# PYTHON3 = c:/Anaconda3/python

TOP_ENTITY = emif_bridge_sys_tb

VSIM_OPT = -L altera_ver -L lpm_ver -L sgate_ver -L altera_mf_ver \
		   -L altera_lnsim_ver -L cycloneiv_hssi_ver \
		   -L cycloneiv_pcie_hip_ver -L cycloneiv_ver

QSYS_LIB_PATH = ../../rtl
vpath %.qsys ../../tb
QSYS_SRC = emif16_avmm_bridge_test_sys.qsys

vpath %.sv ../../tb
HDL_SRC  = emif16_avmm_bridge_test_sys_tb.sv emif16_model.sv

include ../../scripts/makefiles/modelsim/modelsim.mk
