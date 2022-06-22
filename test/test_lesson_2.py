import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
from scan_wrapper import *

@cocotb.test()
async def test_lesson_2(dut):

    await reset(dut)
    for i in range(255):
        data = await capture_data(dut)
        await single_cycle(dut)
        # TODO not sure why it's out by one
        assert convert_to_int(data) == i + 1

