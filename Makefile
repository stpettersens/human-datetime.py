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

docker: zones
	uv run prebuild.py
	docker build -t human_datetime_py_img .

container:
	docker run --rm --name human_datetime_py_test human_datetime_py_img

build_env_gnu: zones
	uv run prebuild.py
	docker build -f Dockerfile.build_env_gnu -t human_datetime_py_build_img_gnu .

build_env_musl: zones
	uv run prebuild.py
	docker build -f Dockerfile.build_env_musl -t human_datetime_py_build_img_musl .

ext_gnu_docker:
	docker run --rm --name htdpy_build_gnu -d human_datetime_py_build_img_gnu
	sleep 10
	docker cp htdpy_build_gnu:/usr/build/human_datetime_py.cpython-313-x86_64-linux-gnu.so .
	docker stop htdpy_build_gnu

ext_musl_docker:
	docker run --rm --name htdpy_build_musl -d human_datetime_py_build_img_musl
	sleep 10
	docker cp htdpy_build_musl:/usr/build/human_datetime_py.cpython-313-x86_64-linux-musl.so .
	docker stop htdpy_build_musl

clean:
	uv run clean.py
