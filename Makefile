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

# needs PDK_ROOT and OPENLANE_ROOT set from your environment
OPENLANE_TAG ?= 2021.11.23_01.42.34
OPENLANE_IMAGE_NAME ?= efabless/openlane:$(OPENLANE_TAG)
harden:
	docker run --rm \
	-v $(OPENLANE_ROOT):/openlane \
	-v $(PDK_ROOT):$(PDK_ROOT) \
	-v $(CURDIR):/work \
	-e PDK_ROOT=$(PDK_ROOT) \
	-u $(shell id -u $(USER)):$(shell id -g $(USER)) \
	$(OPENLANE_IMAGE_NAME) \
	/bin/bash -c "./flow.tcl -overwrite -design /work/ -run_path /work/runs -tag adder"

clean::
	rm -rf *vcd sim_build test/__pycache__

.PHONY: clean
