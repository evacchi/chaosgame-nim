# Package

version     = "0.1.0"
author      = "Your Name"
description = "Example .nimble file."
license     = "MIT"

bin = @["main"]

# Deps

requires "nim >= 0.15.0"
requires "sdl2 1.1"

# Dependencies

task make, "build executable":
  --define:release
  --opt:size
  switch("out", "main")
  setCommand "c", "main"

task tests, "run all tests":
  switch("out", "main")
  switch("r")
  setCommand "c", "tests/alltests"