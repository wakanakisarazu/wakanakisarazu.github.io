# SPDX-License-Identifier: GPL-3.0-or-later
# SPDX-FileCopyrightText: 2026 Wakana Kisarazu <wakanakisarazu.work@gmail.com>
import std/[strutils, strformat]



proc makeDir(dir: string) =
    if not dirExists(dir):
        exec fmt"mkdir -p {dir}"

type BuildMode {.pure.} = enum
    debug, release

proc buildNim(mode: BuildMode): string =
    var args: seq[string]

    if mode == debug:
        args = @[
            "nim", "js",
            "-d:release",
            "--opt:size",
            "-o:target/main.js",
            "source/main.nim"
        ]
    
        echo fmt "+++ buildNim args: {args}"

    elif mode == release:
        args = @[
            "nim", "js", 
            "-d:release",
            "--opt:size",
            "-o:target/main.js",
            "source/main.nim"
        ]

    let cmd = args.join(" ")
    let (output, code) = gorgeEx(cmd)

    return output

proc buildHtml(mode: BuildMode): string =
    var args: seq[string]

    if mode == debug:
        args = @[
            "cp", "-r",
            "source/*.html",
            "target/"
        ]

        echo fmt "+++ buildHtml args: {args}"
    
    elif mode == release:
        args = @[
            "cp", "-r",
            "source/*.html",
            "target/"
        ]
    
    let cmd = args.join(" ")
    let (output, code) = gorgeEx(cmd)

    return output

proc buildCss(mode: BuildMode): string =
    var args: seq[string]

    if mode == debug:
        args = @[
            "cp", "-r",
            "source/*.css",
            "target/"
        ]

        echo fmt "+++ buildCss args: {args}"
    
    elif mode == release:
        args = @[
            "cp", "-r",
            "source/*.css",
            "target/"
        ]
    
    let cmd = args.join(" ")
    let (output, code) = gorgeEx(cmd)

    return output

proc buildXterm(mode: BuildMode): string = 
    var args: seq[string]

    if mode == debug:
        args = @[
            "cp", "-r",
            "node_modules/@xterm/xterm",
            "target/"
        ]

        echo fmt "+++ buildXterm args: {args}"

    elif mode == release:
        args = @[
            "cp", "-r",
            "node_modules/@xterm/xterm",
            "target/"
        ]

    let cmd = args.join(" ")
    let (output, code) = gorgeEx(cmd)

    return output

proc buildAssets(mode: BuildMode): string =
    var args: seq[string]

    if mode == debug:
        args = @[
            "cp", "-r",
            "assets/",
            "target/"
        ]

        echo fmt "+++ buildAssets args: {args}"

    elif mode == release:
        args = @[
            "cp", "-r",
            "assets/",
            "target/"
        ]

    let cmd = args.join(" ")
    let (output, code) = gorgeEx(cmd)

    return output


task compileDebug, "Compile the project in debug mode":
    makeDir("target")

    echo buildNim(debug)
    echo buildHtml(debug)
    echo buildCss(debug)
    echo buildXterm(debug)
    echo buildAssets(debug)

task compileRelease, "Compile the project in release mode":
    makeDir("target")

    discard buildNim(release)
    discard buildHtml(release)
    discard buildCss(release)
    discard buildXterm(release)
    discard buildAssets(release)

task clean, "Clean the project":
    const args = @[
        "rm", "-rfv",
        "target"
    ]

    let cmd = args.join(" ")
    exec cmd