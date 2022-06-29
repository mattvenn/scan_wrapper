# User config
set script_dir [file dirname [file normalize [info script]]]

# name of your project, should also match the name of the top module
set ::env(DESIGN_NAME) scan_wrapper_lesson_1

# save some time
set ::env(RUN_KLAYOUT_XOR) 0
set ::env(RUN_KLAYOUT_DRC) 0

# add your source files here
set ::env(VERILOG_FILES) "$::env(DESIGN_DIR)/scan_wrapper.v \ 
                        $::env(DESIGN_DIR)/mini_design.v"

set ::env(SYNTH_READ_BLACKBOX_LIB) 1

# target density, change this if you can't get your design to fit
#set ::env(PL_TARGET_DENSITY) 0.4
set ::env(FP_CORE_UTIL) 45
#set ::env(PL_TARGET_DENSITY) [ expr ($::env(FP_CORE_UTIL)+5) / 100.0 ]

# don't put clock buffers on the outputs, need tristates to be the final cells
set ::env(PL_RESIZER_BUFFER_OUTPUT_PORTS) 0

# set absolute size of the die to 300 x 300 um
set ::env(DIE_AREA) "0 0 100 100"
set ::env(FP_SIZING) absolute

# clock period is ns
set ::env(CLOCK_PERIOD) "1000"
set ::env(CLOCK_PORT) "clk_in"

# macro needs to work inside Caravel, so can't be core and can't use metal 5
set ::env(DESIGN_IS_CORE) 0
set ::env(RT_MAX_LAYER) {met4}

# define power straps so the macro works inside Caravel's PDN
set ::env(VDD_NETS) [list {vccd1}]
set ::env(GND_NETS) [list {vssd1}]

# make pins wider to solve routing issues
set ::env(FP_IO_VTHICKNESS_MULT) 4
set ::env(FP_IO_HTHICKNESS_MULT) 4
