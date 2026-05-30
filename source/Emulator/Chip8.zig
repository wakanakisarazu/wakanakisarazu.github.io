// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 Wakana Kisarazu <wakanakisarazu.work@gmail.com>

const std = @import("std");
const wasm = std.wasm;



const Error = error 
{
    DataTooLarge,
    StackOverflow,
    StackUnderflow,
    UnknownOpcode,
};

const Device = struct 
{   
    const DISPLAY_WIDTH = 64;
    const DISPLAY_HEIGHT = 32;

    const STACK_MEMORY_SIZE = 16;
    const SYSTEM_MEMORY_SIZE = 4096;
    const GRAPHICS_MEMORY_SIZE = DISPLAY_WIDTH * DISPLAY_HEIGHT;

    const FONT_SET: [80]u8 = [_]u8 {
        0xF0, 0x90, 0x90, 0x90, 0xF0,
        0x20, 0x60, 0x20, 0x20, 0x70,
        0xF0, 0x10, 0xF0, 0x80, 0xF0,
        0xF0, 0x10, 0xF0, 0x10, 0xF0,
        0x90, 0x90, 0xF0, 0x10, 0x10,
        0xF0, 0x80, 0xF0, 0x10, 0xF0,
        0xF0, 0x80, 0xF0, 0x90, 0xF0,
        0xF0, 0x10, 0x20, 0x40, 0x40,
        0xF0, 0x90, 0xF0, 0x90, 0xF0,
        0xF0, 0x90, 0xF0, 0x10, 0xF0,
        0xF0, 0x90, 0xF0, 0x90, 0x90,
        0xE0, 0x90, 0xE0, 0x90, 0xE0,
        0xF0, 0x80, 0x80, 0x80, 0xF0,
        0xE0, 0x90, 0x90, 0x90, 0xE0,
        0xF0, 0x80, 0xF0, 0x80, 0xF0,
        0xF0, 0x80, 0xF0, 0x80, 0x80, 
    };

    const Registers = struct {
        v:  [16]u8,
        pc: u16,
        i:  u16,
        sp: u8,
    };

    const Timers = struct {
        delay:  u8,
        sound:  u8,
    };

    stack_memory:       [STACK_MEMORY_SIZE]u16,
    system_memory:      [SYSTEM_MEMORY_SIZE]u8,
    graphics_memory:    [GRAPHICS_MEMORY_SIZE]bool,

    registers:          Registers,
    timers:             Timers,

    keypad:             [16]bool,

    draw_flag:          bool,

    const Opcode = struct {
        raw: u16,

        fn lowByte(this: @This()) u8 { return @truncate(this.raw & 0x00FF); }
        fn highByte(this: @This()) u8 { return @truncate(this.raw >> 8); }

        fn x(this: @This()) usize { return @as(usize, (this.raw & 0x0F00) >> 8); }
        fn y(this: @This()) usize { return @as(usize, (this.raw & 0x00F0) >> 4); }

        fn n(this: @This()) u4 { return @truncate(this.raw & 0x000F); }
        fn nn(this: @This()) u8 { return @truncate(this.raw & 0x00FF); }
        fn nnn(this: @This()) u16 { return this.raw & 0x0FFF; }

    };


    fn fetchOpcode(this: *@This()) Opcode {
        return .{ 
            .raw = 
            @as(u16, this.system_memory[this.registers.pc] << 8) 
            |
            @as(u16, this.system_memory[this.registers.pc] + 1)
        };
    }

    fn init() @This() {
        return .{
            .stack_memory = [_]u16 {0} ** STACK_MEMORY_SIZE,

            .system_memory = clear_and_load_font: {
                var cache = [_]u8 {0} ** SYSTEM_MEMORY_SIZE;

                for (0..80) |idx| { cache[idx] = FONT_SET[idx]; }

                break :clear_and_load_font cache;
            },

            .graphics_memory = [_]bool {0} ** GRAPHICS_MEMORY_SIZE,

            .registers = .{
                .v = [_]u8 {0} ** 16,
                .pc = 0x200,
                .i = 0,
                .sp = 0,
            },

            .timers = .{
                .delay = 0,
                .sound = 0,
            },

            .keypad = [_]bool {0} ** 16,

            .draw_flag = false,
        };
    }

    fn load(this: *@This(), data: []const u8) Error!void {
        if (data.len <= (SYSTEM_MEMORY_SIZE - 512)) {
            for (0..data.len) |idx| { 
                this.system_memory[idx + 512] = data[idx]; 
            }
        } else {
            return Error.DataTooLarge;
        }
    }

    fn cycle(this: *@This()) Error!void {
        const opcode: Opcode = this.fetchOpcode();

        switch (opcode.raw & 0xF000) {

            0x0000 => {
                
                switch (opcode.n()) {

                    0x0000 => {
                        this.graphics_memory = [_]bool {false} ** GRAPHICS_MEMORY_SIZE;
                        this.draw_flag = true;

                        this.registers.pc += 2;
                    },

                    0x000E => {
                        
                    }
                }
            }
        }
    }
};