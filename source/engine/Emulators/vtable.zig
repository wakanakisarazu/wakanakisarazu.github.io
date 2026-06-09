// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 Wakana Kisarazu <wakanakisarazu.work@gmail.com>



const ImplementationData = struct 
{   
    const OutputMethod = enum {
        none,
        textbuffer,
        framebuffer,
    };

    const InputMethod = enum {
        none,
        keypad,
        keyboard,
    };

    name:           []const u8,

    output_method:  OutputMethod,
    input_method:   InputMethod,

    has_audio:      bool,
    has_timer:      bool,
};


pointer:    *anyopaque,

data:       ImplementationData,

startFn:    *const fn(*anyopaque) void,
loadFn:     *const fn(*anyopaque, []const u8) anyerror!void,
stopFn:     *const fn(*anyopaque) void,