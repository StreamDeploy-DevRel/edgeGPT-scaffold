# edgeGPT-scaffold

Use this scaffold to develop ML / AI applications locally on a Raspberry Pi + Coral USB Accelerator

Build the Docker image
```
docker build -t nanogpt-coral .
```

Run the Docker container
```
docker run -it --device /dev/bus/usb:/dev/bus/usb nanogpt-coral
```
