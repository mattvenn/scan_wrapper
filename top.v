`default_nettype none

module top(
    input wire clk,
    input wire reset,

    input wire [8:0] active_select,
    input wire [7:0] inputs,
    output wire [7:0] outputs,
    output wire ready
);

    `ifdef COCOTB
    initial begin
        $dumpfile ("top.vcd");
        $dumpvars (0, top);
        #1;
    end
    `endif

    scan_controller #(.NUM_DESIGNS(NUM_MACROS)) scan_controller(
        .clk            (clk),
        .reset          (reset),
        .active_select  (active_select),
        .inputs         (inputs),
        .outputs        (outputs),
        .ready          (ready),
        .scan_clk       (scan_clk),
        .scan_data_out  (scan_data_out),
        .scan_data_in   (scan_data_in),
        .scan_select    (scan_select),
        .scan_latch_enable(scan_latch_enable)
    );

    localparam NUM_MACROS = 100;
    localparam NUM_LESSONS = 4;
    localparam EXTRA_MACRO = NUM_MACROS - NUM_LESSONS;

    wire [NUM_MACROS:0] data, scan, latch, cclk;
    wire scan_clk, scan_data_out, scan_data_in, scan_select, scan_latch_enable;
    assign scan_data_in = data[NUM_MACROS-1];

    scan_wrapper_lesson_1 #(.NUM_IOS(8)) instance_0 (
        .clk_in         (scan_clk),
        .data_in        (scan_data_out),
        .scan_select_in (scan_select),
        .latch_enable_in(scan_latch_enable),
        .clk_out        (cclk[0]),
        .data_out       (data[0]),
        .scan_select_out(scan[0]),
        .latch_enable_out(latch[0])
        );

    scan_wrapper_lesson_2 #(.NUM_IOS(8)) instance_1 (
        .clk_in          (cclk [0]),
        .data_in         (data [0]),
        .scan_select_in  (scan [0]),
        .latch_enable_in (latch[0]),
        .clk_out         (cclk  [1]),
        .data_out        (data [1]),
        .scan_select_out (scan [1]),
        .latch_enable_out(latch[1])
        );

    scan_wrapper_lesson_3 #(.NUM_IOS(8)) instance_2 (
        .clk_in          (cclk  [1]),
        .data_in         (data [1]),
        .scan_select_in  (scan [1]),
        .latch_enable_in (latch[1]),
        .clk_out         (cclk  [2]),
        .data_out        (data [2]),
        .scan_select_out (scan [2]),
        .latch_enable_out(latch[2])
        );

    scan_wrapper_lesson_4 #(.NUM_IOS(8)) instance_3 (
        .clk_in          (cclk  [2]),
        .data_in         (data [2]),
        .scan_select_in  (scan [2]),
        .latch_enable_in (latch[2]),
        .clk_out         (cclk  [3]),
        .data_out        (data [3]),
        .scan_select_out (scan [3]),
        .latch_enable_out(latch[3])
        );


    scan_wrapper_lesson_1 #(.NUM_IOS(8)) extra_scan_wrappers [EXTRA_MACRO-1:0] (
        .clk_in          (cclk [NUM_MACROS-2:NUM_LESSONS-1]),
        .data_in         (data [NUM_MACROS-2:NUM_LESSONS-1]),
        .scan_select_in  (scan [NUM_MACROS-2:NUM_LESSONS-1]),
        .latch_enable_in (latch[NUM_MACROS-2:NUM_LESSONS-1]),
        .clk_out         (cclk [NUM_MACROS-1:NUM_LESSONS]),
        .data_out        (data [NUM_MACROS-1:NUM_LESSONS]),
        .scan_select_out (scan [NUM_MACROS-1:NUM_LESSONS]),
        .latch_enable_out(latch[NUM_MACROS-1:NUM_LESSONS])
        );
    

endmodule
