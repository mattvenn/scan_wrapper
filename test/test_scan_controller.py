import cocotb
from cocotb.clock import Clock
from cocotb.triggers import RisingEdge, FallingEdge, ClockCycles
from scan_wrapper import *

# utility functions. using 2nd bit as reset and 1st bit as clock for synchronous design examples
async def reset(dut):
    await RisingEdge(dut.ready);
    dut.inputs = 0b10
    await RisingEdge(dut.ready);
    dut.inputs = 0b11
    await RisingEdge(dut.ready);
    dut.inputs = 0b0

async def single_cycle(dut):
    await RisingEdge(dut.ready);
    dut.inputs = 0b1
    await RisingEdge(dut.ready);
    dut.inputs = 0b0

@cocotb.test()
async def test_lesson_1(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.fork(clock.start())

    dut.reset = 1
    dut.active_select = 0
    await ClockCycles(dut.clk, 1)
    dut.reset = 0

    dut.inputs = 0x00
    await RisingEdge(dut.ready);
    await RisingEdge(dut.ready);
    assert dut.outputs == 0x00

    dut.inputs = 0x01
    await RisingEdge(dut.ready);
    await RisingEdge(dut.ready);
    assert dut.outputs == 0xAA

    dut.inputs = 0x02
    await RisingEdge(dut.ready);
    await RisingEdge(dut.ready);
    assert dut.outputs == 0x55


@cocotb.test()
async def test_lesson_2(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.fork(clock.start())

    dut.active_select = 1

    # reset the dut
    await reset(dut)

    # wait one clock cycle to sync
    await single_cycle(dut)

    for i in range(255):
        assert dut.outputs.value == i
        await single_cycle(dut)

@cocotb.test()
async def test_lesson_3(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.fork(clock.start())

    dut.reset = 1
    dut.active_select = 2
    await ClockCycles(dut.clk, 1)
    dut.reset = 0

    await reset(dut)

    # wait one clock cycle to sync
    await single_cycle(dut)

    for i in range(8):
        assert dut.outputs == 1<<i
        await single_cycle(dut)

@cocotb.test()
async def test_lesson_4(dut):
    clock = Clock(dut.clk, 10, units="us")
    cocotb.fork(clock.start())

    dut.reset = 1
    dut.active_select = 3
    await ClockCycles(dut.clk, 1)
    dut.reset = 0

    await reset(dut)

    morse = "110110010011001100"
    # wait one clock cycle to sync
    for char in morse:
        await single_cycle(dut)
        assert dut.outputs[0] == int(char)

