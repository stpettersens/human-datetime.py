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

docker: zone
	uv run prebuild.py
	docker build -t human_datetime_py_img .

container:
	docker run --rm --name human_datetime_py_test human_datetime_py_img

build_env_gnu: zone
	uv run prebuild.py
	docker build -f Dockerfile.build_env_gnu -t human_datetime_py_build_img_gnu .

build_env_musl: zone
	uv run prebuild.py
	docker build -f Dockerfile.build_env_musl -t human_datetime_py_build_img .

ext_gnu_docker:
	docker run --name htdpy_build -d human_datetime_py_build_img

ext_gnu_docker:
	@echo TODO

clean:
	uv run clean.py
