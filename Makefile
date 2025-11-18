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

docker_ext:
	uv run prebuild.py
	docker build -f Dockerfile_build_for_host -t human_datetime_py_build_only .
	docker run --rm --name human_datetime_py_built human_datetime_py_build_only
	docker cp human_datetime_py_built:/usr/build/*.so .
	docker stop human_datetime_py_built
	uv run install.py

clean:
	uv run clean.py
