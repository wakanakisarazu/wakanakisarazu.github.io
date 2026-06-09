// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 Wakana Kisarazu <wakanakisarazu.work@gmail.com>



const READ_ONLY_COUNT = 16;
const READ_ONLY_SIZE = 256;

const READ_WRITE_REGISTERS = 4;
const READ_WRITE_COUNT = 16;
const READ_WRITE_SIZE = 20;

const ReadOnly = struct 
{ 
    data: [READ_ONLY_SIZE]u8,
    port: u4,

    pub fn init() @This() { 
        return .{ 
            .data = .{0} ** READ_ONLY_SIZE,
            .port = 0,
        };
    }

    pub fn read(this: @This(), offset: usize) u8 { return this.data[offset]; }
    pub fn write(this: *@This(), offset: usize, value: u8) void { this.data[offset] = value; }
};

const ReadWrite = struct 
{
    registers: [READ_WRITE_REGISTERS][READ_WRITE_SIZE]u4,
    port: u4,

    pub fn init() @This() { 
        return .{ 
            .registers = .{ .{0} ** READ_WRITE_SIZE } ** 4,
            .port = 0,
        };
    }

    pub fn read(this: @This(), register: usize, offset: usize) u4 { return this.registers[register][offset]; }
    pub fn write(this: *@This(), register: usize, offset: usize, value: u4) void { this.registers[register][offset] = value; }
};


ro: [READ_ONLY_COUNT]ReadOnly,
rw: [READ_WRITE_COUNT]ReadWrite,


pub fn init() @This()
{
    return .{
        .ro = .{ReadOnly.init()} ** READ_ONLY_COUNT,
        .rw = .{ReadWrite.init()} ** READ_WRITE_COUNT,
    };
}

pub fn load(this: *@This(), data: []const u8) !void
{
    const maxDataSize = READ_ONLY_COUNT * READ_ONLY_SIZE;

    if (data.len > maxDataSize) {
        return error.DataTooLarge;
    } else {
        for (data, 0..) |byte, idx| {
            const chip = idx / 256;
            const offset = idx % 256;

            this.ro[chip].data[offset] = byte;
        }
    }
}