import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
from scan_wrapper import *

@cocotb.test()
async def test_lesson_1(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.fork(clock.start())

    await load_data(dut, [0]*8)
    data = await capture_data(dut)
    print(data)
    assert data == [0]*8

    await load_data(dut, [0]*7 + [1])
    data = await capture_data(dut)
    print(data)
    assert data == [1, 0, 1, 0, 1, 0, 1, 0]

    await load_data(dut, [0]*6 + [1, 0])
    data = await capture_data(dut)
    print(data)
    assert data == [0, 1, 0, 1, 0, 1, 0, 1]

