# cocotb setup
export COCOTB_REDUCED_LOG_FMT=1
MODULE = test_scan_wrapper
TOPLEVEL = scan_wrapper
VERILOG_SOURCES = scan_wrapper.v

COMPILE_ARGS=-I $(PDK_ROOT)/sky130A/ 

include $(shell cocotb-config --makefiles)/Makefile.sim
