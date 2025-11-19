#!/bin/sh
# Build extension:
uv run setup.py build_ext --inplace
# Keep container running:
tail -f /dev/null
