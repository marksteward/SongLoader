# The github action builds QPM using 18.04 (and therefore libssl1.0.0)
FROM ubuntu:18.04

# Prerequisites
RUN apt-get update && \
    apt-get -y install wget unzip libssl1.0.0 && \
    rm -rf /var/lib/apt/lists/*

RUN apt-get update && \
    wget https://github.com/PowerShell/PowerShell/releases/download/v7.1.3/powershell_7.1.3-1.ubuntu.20.04_amd64.deb && \
    apt-get -y install ./powershell_7.1.3-1.ubuntu.20.04_amd64.deb && \
    rm powershell_7.1.3-1.ubuntu.20.04_amd64.deb && \
    rm -rf /var/lib/apt/lists/*

ARG NDK_VERSION=r22
RUN wget https://dl.google.com/android/repository/android-ndk-${NDK_VERSION}-linux-x86_64.zip && \
    unzip android-ndk-${NDK_VERSION}-linux-x86_64.zip && \
    rm android-ndk-${NDK_VERSION}-linux-x86_64.zip

# Build deps
RUN apt-get update && \
    apt-get -y install git make file && \
    rm -rf /var/lib/apt/lists/*

# Download this from a build of QuestPackageManager
WORKDIR /app
COPY QPM-ubuntu-x64.zip .
RUN unzip QPM-ubuntu-x64.zip -d QPM

COPY qpm.json .
RUN chmod a+x QPM/QPM && \
    QPM/QPM collect

RUN QPM/QPM restore

COPY . .
RUN echo /android-ndk-${NDK_VERSION} >ndkpath.txt && \
    pwsh -Command ./build.ps1

