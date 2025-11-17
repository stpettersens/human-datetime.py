make:
	uv pip install -r requirements_ext.txt
	uv run prebuild.py

ext:
	uv run setup.py build_ext --inplace
	uv run install.py

zones:
	uv run create_iana_file.py

test:
	uv run test_ext.py

docker:
	uv run prebuild.py
	docker build -t human_datetime_py_img .

container:
	docker run --rm --name human_datetime_py_test human_datetime_py_img

clean:
	uv run clean.py
