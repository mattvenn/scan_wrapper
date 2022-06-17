`default_nettype none
`define UNIT_DELAY #1
`define FUNCTIONAL
`define USE_POWER_PINS
`include "libs.ref/sky130_fd_sc_hd/verilog/primitives.v"
`include "libs.ref/sky130_fd_sc_hd/verilog/sky130_fd_sc_hd.v"

module scan_wrapper (
    input wire clk,
    input wire data_in,
    input wire scan_select,
    input wire latch_enable,
    output wire data_out
    );

    `ifdef COCOTB_SIM
        initial begin
            $dumpfile ("scan_wrapper.vcd");
            $dumpvars (0, scan_wrapper);
            #1;
        end
    `endif

    parameter NUM_IOS = 8;

    // wires needed
    wire [NUM_IOS-1:0] scan_data_out;   // output of the each scan chain flop
    wire [NUM_IOS-1:0] scan_data_in;    // input of each scan chain flop
    wire [NUM_IOS-1:0] module_data_in;  // the data that enters the user module
    wire [NUM_IOS-1:0] module_data_out; // the data from the user module

    // scan chain - link all the flops, with data coming from data_in
    assign scan_data_in = {scan_data_out[NUM_IOS-2:0], data_in};
    
    // end of the chain is the last scan flop's out
    assign data_out = scan_data_out[NUM_IOS-1];

    // scan flops have a mux on their inputs to choose either data from the user module or the previous flop's output
    // https://antmicro-skywater-pdk-docs.readthedocs.io/en/test-submodules-in-rtd/contents/libraries/sky130_fd_sc_ls/cells/sdfxtp/README.html
    sky130_fd_sc_hd__sdfxtp_1 scan_flop [NUM_IOS-1:0] (
        .CLK        (clk), 
        .D          (module_data_out),
        .SCD        (scan_data_in),
        .SCE        (scan_select),
        .Q          (scan_data_out),
        .VPWR       (1'b1),
        .VGND       (1'b0)
    );

    // latch is used to latch the input data of the user module while the scan chain is used to capture the user module's outputs
    // https://antmicro-skywater-pdk-docs.readthedocs.io/en/test-submodules-in-rtd/contents/libraries/sky130_fd_sc_hd/cells/dlxtp/README.html
    sky130_fd_sc_hd__dlxtp_1 latch [NUM_IOS-1:0] (
        .D          (scan_data_out),
        .GATE       (latch_enable),
        .Q          (module_data_in),
        .VPWR       (1'b1),
        .VGND       (1'b0)
    );

    // instantiate the user module
    user_module #(.NUM_IOS(NUM_IOS)) user_module(
        .inputs     (module_data_in),
        .outputs    (module_data_out)
    );

endmodule

module user_module (
    input wire [NUM_IOS-1:0] inputs,
    output wire [NUM_IOS-1:0] outputs
    );

    parameter NUM_IOS = 1;

    assign outputs = inputs;

endmodule
