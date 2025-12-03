make: ldc

ldc:
	uv pip install -r requirements_ldc.txt

dmd:
	uv pip install -r requirements_dmd.txt

ext: zones
	uv run prebuild.py
	uv run setup.py build_ext --inplace
	uv run install.py

zones:
	rdmd create_iana_file.d

test:
	uv run test_ext.py

python:
	docker build -f Dockerfile.python -t python_3_13_9_img
	docker run --rm --name python3_13_9 -d python_3_13_9_img
	sleep 15
	docker cp python3_13_9:/opt/python/3.13.9/libpython3.13.a .
	docker stop python3_13_9

docker: zones
	uv run prebuild.py
	docker build -f Dockerfile.test -t human_datetime_py_img .

container:
	docker run --rm --name human_datetime_py_test human_datetime_py_img

build_env_gnu: zones
	uv run prebuild.py
	docker build -f Dockerfile.build_env_gnu -t human_datetime_py_build_img_gnu .

build_env_musl: zones
	uv run prebuild.py
	docker build -f Dockerfile.build_env_musl -t human_datetime_py_build_img_musl .

ext_gnu_docker:
	docker run --rm --name hdt_build_gnu -d human_datetime_py_build_img_gnu
	sleep 15
	docker cp hdt_build_gnu:/usr/build/human_datetime_py.cpython-313-x86_64-linux-gnu.so .
	docker stop hdt_build_gnu
	uv run install.py
	uv run test_ext.py

ext_musl_docker:
	docker run --rm --name hdt_build_musl -d human_datetime_py_build_img_musl
	sleep 15
	docker cp hdt_build_musl:/usr/build/human_datetime_py.cpython-313-x86_64-linux-musl.so .
	docker stop hdt_build_musl
	uv run install.py
	uv run test_ext.py

clean:
	uv run clean.py
