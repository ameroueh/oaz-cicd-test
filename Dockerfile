ARG BASE_IMAGE=ubuntu:18.04
FROM $BASE_IMAGE

SHELL [ "/bin/bash", "-c" ]

# Install toolchain
RUN apt-get -qq update
RUN apt-get install -qy software-properties-common
RUN apt-get -qq update
RUN add-apt-repository ppa:git-core/ppa
RUN apt-get install -qy git wget

# Add user

ARG UID=1000
RUN useradd -m oaz --uid=${UID}

# Install miniconda

USER oaz
WORKDIR /home/oaz

ARG MINICONDA_VERSION=4.7.12.1
ENV CONDA_DIR /home/oaz/miniconda3

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-$MINICONDA_VERSION-Linux-x86_64.sh -O miniconda.sh
RUN chmod +x miniconda.sh
RUN ./miniconda.sh -b -p $CONDA_DIR
RUN rm miniconda.sh

ENV PATH=$CONDA_DIR/bin:$PATH
RUN echo ". $CONDA_DIR/etc/profile.d/conda.sh" >> /home/oaz/.profile
RUN conda init bash

RUN conda create --name oaz python=3.6
RUN echo "conda activate oaz" >> /home/oaz/.bashrc

USER oaz
WORKDIR /home/oaz
