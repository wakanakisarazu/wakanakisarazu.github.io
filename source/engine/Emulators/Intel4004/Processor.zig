// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 Wakana Kisarazu <wakanakisarazu.work@gmail.com>



pub const Registers = struct 
{
    r:      [16]u4,
    stack:  [3]u16,
    pc:     u12,
    sp:     u2,
    carry:  u1,
};


registers:   Registers,


pub fn init() @This() 
{
    return .{
        .register = .{
            .r = .{0} ** 16,
            .pc = 0,
            .stack = .{0} ** 3,
            .sp = 0,
            .carry = 0,
        },
    };
}