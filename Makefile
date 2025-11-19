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

build_env:
	uv run prebuild.py
	docker build -f Dockerfile.build_env -t human_datetime_py_build_img .

ext_docker:
	docker run --name htdpy_build -d human_datetime_py_build_img
	uv run install.py
	uv run test_ext.py

clean:
	uv run clean.py
