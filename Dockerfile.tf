FROM tensorflow/tensorflow:1.7.0-gpu-py3

RUN pip --no-cache-dir install \
        tensor2tensor[tensorflow_gpu] tensorflow-hub

WORKDIR "/workspace"
