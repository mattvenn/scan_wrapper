import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
from scan_wrapper import *

@cocotb.test()
async def test_lesson_1(dut):
    await reset(dut)

    for i in range(8):
        data = await capture_data(dut)
        assert convert_to_int(data) == 1<<i
        await single_cycle(dut)
