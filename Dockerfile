# This is a Dockerfile just to test using the human_datetime_py extension in a container.
# Python 3.13 will be installed via uv as it is the version compatible with the extension.
# For a Dockerfile template you can adapt for your application, please see Dockefile.template.
FROM alpine:latest

# Install dmd compiler and uv
RUN sed -i '2s/^# *//' /etc/apk/repositories
RUN apk update && apk add --no-cache dmd uv

# Test dmd installed.
RUN dmd --version

# Test uv installed.
RUN uv --version

# Install Python 3.13 (compatible with the human_datetime_py ext module)
RUN uv python install 3.13

# Test Python installed.
RUN uv run python --version

# Create directories.
RUN mkdir -p /usr/app/source
WORKDIR /usr/app

# Install human_datetime_py ext module dependencies
# Also build it and install it to site_packages
COPY requirements_ext.txt ./
COPY *.py ./
COPY source/*.d ./source
RUN uv venv venv
RUN source venv/bin/activate
RUN uv pip install -r requirements_ext.txt
COPY libpython3.13.a ./
RUN uv run setup.py build_ext --inplace
RUN uv run install.py
RUN deactivate

# Run test app.
CMD [ "uv", "run", "test_ext.py" ]
