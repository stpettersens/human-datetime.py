#!/usr/bin/env bash

# Build extension in container:
source /usr/build/.venv/bin/activate
uv run setup.py build_ext --inplace

# Keep container running:
tail -f /dev/null
