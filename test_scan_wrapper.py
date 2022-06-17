import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
import random

@cocotb.test()
async def test_scan_wrapper(dut):
    clock = Clock(dut.clk, 10, units="ns")
    cocotb.fork(clock.start())

    # prepare for loading the scan chain
    dut.scan_select = 1
    dut.latch_enable = 0
    dut.data_in = 0
    await ClockCycles(dut.clk, 1)

    data = [0, 1, 0, 1, 0, 1, 0, 1]

    # load it
    for i in range(8):
        dut.data_in = data[i]
        await ClockCycles(dut.clk, 1)

    # latch the data from the chain into the module
    dut.latch_enable = 1
    await ClockCycles(dut.clk, 1)
    dut.latch_enable = 0
    await ClockCycles(dut.clk, 1)

    # capture the module's output into the scan chain
    dut.scan_select = 0
    await ClockCycles(dut.clk, 1)

    # dump the data out of the chain
    dut.scan_select = 1
    await ClockCycles(dut.clk, 8)
