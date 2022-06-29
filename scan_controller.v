`default_nettype none

module scan_controller (
    input wire clk,
    input wire reset,

    input wire [8:0] active_select,
    input wire [7:0] inputs,
    output wire [7:0] outputs,
    output wire ready,

    // scan chain interface
    output wire scan_clk,
    output wire scan_data_out,
    input wire  scan_data_in,
    output wire scan_select,
    output wire scan_latch_enable
    );

    parameter NUM_DESIGNS = 100; 

    localparam LOAD = 0;
    localparam READ = 1;

    reg [8:0] current_design;
    reg state;

    reg [7:0] inputs_r;
    reg [7:0] outputs_r;

    assign outputs = outputs_r;

    wire start_load = state == LOAD && current_design == 0;
    wire start_read = state == READ && current_design == 0;

    always @(posedge clk) begin
        if(reset) begin
            current_design <= 0;
            state <= LOAD; 
            inputs_r <= 0;
            outputs_r <= 0;
        end else begin
            current_design <= current_design + 1;
            if(current_design == NUM_DESIGNS - 1) begin
                current_design <= 0;
                state <= !state;
                if(state == LOAD) begin
                    inputs_r <= inputs;
                end else begin // READ
                    //
                end
            end
        end
    end
        


endmodule
