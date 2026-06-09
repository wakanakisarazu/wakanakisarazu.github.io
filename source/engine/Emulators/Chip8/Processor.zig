// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 Wakana Kisarazu <wakanakisarazu.work@gmail.com>



pub const Registers = struct 
{
    v:  [16]u8,
    pc: u16,
    i:  u16,
    sp: u8,
};

pub const Opcode = struct 
{
    raw: u16,

    fn lowByte(this: @This()) u8 { return @truncate(this.raw & 0x00FF); }
    fn highByte(this: @This()) u8 { return @truncate(this.raw >> 8); }

    fn x(this: @This()) usize { return @as(usize, (this.raw & 0x0F00) >> 8); }
    fn y(this: @This()) usize { return @as(usize, (this.raw & 0x00F0) >> 4); }

    fn n(this: @This()) u4 { return @truncate(this.raw & 0x000F); }
    fn nn(this: @This()) u8 { return @truncate(this.raw & 0x00FF); }
    fn nnn(this: @This()) u16 { return this.raw & 0x0FFF; }
};


registers:  Registers,


pub fn init() @This() 
{
    return .{
        .registers = .{
            .v = .{0} ** 16,
            .pc = 512,
            .i = 0,
            .sp = 0,
        },
    };
}

pub fn execute(this: *@This(), opcode: Opcode) void
{
    // Finish later, imma play some games
    // im tired as shit.
}