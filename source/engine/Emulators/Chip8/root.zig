// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 Wakana Kisarazu <wakanakisarazu.work@gmail.com>

const Processor = @import("Processor.zig");
const Memory = @import("Memory.zig");
const Peripherals = @import("Peripherals.zig");



processor:      Processor,
memory:         Memory,
peripherals:    Peripherals,


pub fn start() @This()
{
    return .{
        .processor = Processor.init(),
        .memory = Memory.init(),
        .peripherals = Peripherals.init()
    };
}

pub fn load(this: *@This(), data: []const u8) !void
{
    try this.memory.load(data);
}

pub fn step(this: *@This()) !void
{
    const opcode = Processor.Opcode {
        .raw = @as(
            u16, 
            this.memory.read(this.processor.registers.pc) << 8
        ) | this.memory.read(this.processor.registers.pc + 1), 
    };
}

pub fn stop(this: *@This()) void
{
    _ = this;
}