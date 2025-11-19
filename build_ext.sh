#!/bin/sh
uv run setup.py build_ext --inplace
tail -f /dev/null
