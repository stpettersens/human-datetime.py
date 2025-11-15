make:
	uv pip install -r requirements.txt
	uv run prebuild.py

module:
	uv run setup.py build_ext --inplace
	uv run install.py

clean:
	uv run clean.py
