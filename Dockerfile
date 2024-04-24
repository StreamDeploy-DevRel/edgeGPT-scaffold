# Start with a base image that supports ARM architecture (Raspberry Pi compatible)
FROM balenalib/raspberry-pi-debian:latest

# Set the maintainer label
LABEL maintainer="Tony Loehr <tony@streamdeploy.com>"

# Add Coral's package source list
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | tee /etc/apt/sources.list.d/coral-edgetpu.list \
    && curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -

# Install essential packages and Python libraries
RUN install_packages libedgetpu1-std \
                     python3-pycoral \
                     python3-pip

# Update pip and install virtual environment support
RUN pip3 install --upgrade pip \
    && pip3 install virtualenv virtualenvwrapper

# Setup virtual environment variables
RUN echo "# virtualenv and virtualenvwrapper" >> ~/.bashrc \
    && echo "export WORKON_HOME=~/.virtualenvs" >> ~/.bashrc \
    && echo "export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python3" >> ~/.bashrc \
    && echo "source /usr/local/bin/virtualenvwrapper.sh" >> ~/.bashrc

# Create a virtual environment for the application
RUN /bin/bash -c "source /usr/local/bin/virtualenvwrapper.sh \
    && mkvirtualenv coral_env -p python3"

# Activate the virtual environment and install dependencies
RUN /bin/bash -c "source ~/.virtualenvs/coral_env/bin/activate \
    && pip3 install numpy tensorflow==2.16.1"

# Add support for the Edge TPU runtime
RUN echo "deb https://packages.cloud.google.com/apt coral-edgetpu-stable main" | sudo tee /etc/apt/sources.list.d/coral-edgetpu.list \
    && sudo apt-get update && sudo apt-get install -y libedgetpu1-std python3-edgetpu

# Setup work directory
WORKDIR /app

# Copy your application code
COPY . /app

# Command to run on container start
CMD ["/bin/bash", "-c", "source ~/.virtualenvs/coral_env/bin/activate && python3 nanogpt_coral.py"]
