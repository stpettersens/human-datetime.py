make:
	uv pip install -r requirements_ext.txt
	uv run prebuild.py

ext: zones
	uv run setup.py build_ext --inplace
	uv run install.py

zones:
	uv run create_iana_file.py

test:
	uv run test_ext.py

clean:
	uv run clean.py
