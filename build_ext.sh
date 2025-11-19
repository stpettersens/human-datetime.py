#!/bin/sh
uv run setup.py build_ext
tail -f /dev/null
