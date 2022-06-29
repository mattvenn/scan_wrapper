import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
from scan_wrapper import *

@cocotb.test()
async def test_scan_controller(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.fork(clock.start())

    dut.reset = 1
    dut.active_select = 1
    dut.inputs = 0
    await ClockCycles(dut.clk, 1)
    dut.reset = 0
    await ClockCycles(dut.clk, 500)


