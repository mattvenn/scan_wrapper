# cocotb setup
export COCOTB_REDUCED_LOG_FMT=1

COMPILE_ARGS=-I $(PDK_ROOT)/sky130A/ 

include $(shell cocotb-config --makefiles)/Makefile.sim
export PYTHONPATH := test

custom: test_lesson_1 test_lesson_2 test_lesson_3 test_lesson_4

test_lesson_1:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -DCOCOTB -o sim_build/sim.vvp -s scan_wrapper_lesson_1  -g2012 scan_wrapper.v mini_design.v -I $(PDK_ROOT)/sky130A/ 
	MODULE=test.test_lesson_1 vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

test_lesson_2:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -DCOCOTB -o sim_build/sim.vvp -s scan_wrapper_lesson_2  -g2012 scan_wrapper.v mini_design.v -I $(PDK_ROOT)/sky130A/ 
	MODULE=test.test_lesson_2 vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

test_lesson_3:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -DCOCOTB -o sim_build/sim.vvp -s scan_wrapper_lesson_3  -g2012 scan_wrapper.v mini_design.v -I $(PDK_ROOT)/sky130A/ 
	MODULE=test.test_lesson_3 vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

test_lesson_4:
	rm -rf sim_build/
	mkdir sim_build/
	iverilog -DCOCOTB -o sim_build/sim.vvp -s scan_wrapper_lesson_4  -g2012 scan_wrapper.v mini_design.v -I $(PDK_ROOT)/sky130A/ 
	MODULE=test.test_lesson_4 vvp -M $$(cocotb-config --prefix)/cocotb/libs -m libcocotbvpi_icarus sim_build/sim.vvp
	! grep failure results.xml

clean::
	rm -rf *vcd sim_build test/__pycache__

.PHONY: clean
