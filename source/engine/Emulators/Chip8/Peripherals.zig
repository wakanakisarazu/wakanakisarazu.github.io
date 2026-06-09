// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 Wakana Kisarazu <wakanakisarazu.work@gmail.com>



const DISPLAY_WIDTH = 64;
const DISPLAY_HEIGHT = 32;
const KEYPAD_STATE_SIZE = 16;

pub const Timers = struct 
{
    delay:  u8,
    sound:  u8,
};


timers:     Timers,
keypad:     [KEYPAD_STATE_SIZE]bool,
display:    [DISPLAY_WIDTH * DISPLAY_HEIGHT]bool,


pub fn init() @This() 
{
    return .{
        .timers = .{
            .delay = 0,
            .sound = 0,
        },
        .keypad = .{false} ** KEYPAD_STATE_SIZE,
        .display = .{false} ** (DISPLAY_WIDTH * DISPLAY_HEIGHT),
    };
}