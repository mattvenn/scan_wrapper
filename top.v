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

    scan_controller scan_controller(
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

    wire [2:0] data;
    wire scan_clk, scan_data_out, scan_data_in, scan_select, scan_latch_enable;

    scan_wrapper_lesson_1 #(.NUM_IOS(8)) scan_wrapper_lesson1 (
        .clk            (scan_clk),
        .data_in        (scan_data_out),
        .scan_select    (scan_select),
        .latch_enable   (scan_latch_enable),
        .data_out       (data[0])
        );

    scan_wrapper_lesson_2 #(.NUM_IOS(8))scan_wrapper_lesson2 (
        .clk            (scan_clk),
        .data_in        (data[0]),
        .scan_select    (scan_select),
        .latch_enable   (scan_latch_enable),
        .data_out       (data[1])
        );

    scan_wrapper_lesson_3 #(.NUM_IOS(8))scan_wrapper_lesson3 (
        .clk            (scan_clk),
        .data_in        (data[1]),
        .scan_select    (scan_select),
        .latch_enable   (scan_latch_enable),
        .data_out       (data[2])
        );

    scan_wrapper_lesson_4 #(.NUM_IOS(8))scan_wrapper_lesson4 (
        .clk            (scan_clk),
        .data_in        (data[2]),
        .scan_select    (scan_select),
        .latch_enable   (scan_latch_enable),
        .data_out       (scan_data_in)
        );

endmodule
