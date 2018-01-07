FROM ubuntu:16.04

LABEL maintainer="Syed Ahmed <syed.ahmed.emails@gmail.com>"

RUN apt-get update -qq && \
    DEBIAN_FRONTEND=noninteractive apt-get install -yq --no-install-recommends \
        build-essential \
        ca-certificates \
        curl \
        git \
        language-pack-en \
        libcurl4-openssl-dev \
        libffi-dev \
        libsqlite3-dev \
        libzmq3-dev \
        libfreetype6-dev \
        libpng12-dev \
        pandoc \
        python3 \
        python3-dev \
        pkg-config \
        vim \
	wget \
        sqlite3 \
        rsync \
        software-properties-common \
        unzip \
        texlive-fonts-recommended \
        texlive-latex-base \
        texlive-latex-extra \
        zlib1g-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

RUN curl -O https://bootstrap.pypa.io/get-pip.py && \
    python3 get-pip.py && \
    rm get-pip.py && \
    pip3 --no-cache-dir install requests[security] && \
    rm -rf /root/.cache

RUN pip3 --no-cache-dir install \
        Cython \
        Jinja2 \
        MarkupSafe \
        Pillow \
        Pygments \
        appnope \
        argparse \
        backports-abc \
        backports.ssl-match-hostname \
        certifi \
        cycler \
        decorator \
        future \
        gnureadline \
        h5py \
        ipykernel \
        ipython-genutils \
        ipywidgets \
        jsonschema \
        jupyter \
        jupyter-client \
        jupyter-console \
        jupyter-core \
        matplotlib \
        mistune \
        nbconvert \
        nbformat \
        nltk \
        notebook \
        numpy \
        path.py \
        pexpect \
        pickleshare \
        ptyprocess \
        pyparsing \
        python-dateutil \
        pytz \
        pyzmq \
        qtconsole \
        scipy \
        simplegeneric \
        singledispatch \
        six \
        terminado \
        tornado \
        traitlets \
        h5py \
        scikit-learn \
        && \
        python3 -m ipykernel.kernelspec && \
        rm -rf /root/.cache

COPY jupyter_notebook_config.py /root/.jupyter/

EXPOSE 8888

WORKDIR /workspace

CMD ["bash"]
