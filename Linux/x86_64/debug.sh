#!/bin/bash -e

make > /dev/null
gdb ./build/app
