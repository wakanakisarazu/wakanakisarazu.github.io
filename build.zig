// SPDX-License-Identifier: GPL-3.0-or-later
// SPDX-FileCopyrightText: 2026 Wakana Kisarazu <wakanakisarazu.work@gmail.com>

const std = @import("std");
const Build = std.Build;
const Target = std.Target;



pub fn build(b: *Build) void
{
    const optimizeMode = b.standardOptimizeOption(.{
        .preferred_optimize_mode = .Debug,
    });

    const resolvedTarget = b.standardTargetOptions(.{
        .default_target = .{ .cpu_arch = .wasm32, .os_tag = .freestanding, .abi = .none }
    });
}