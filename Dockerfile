FROM bmbf-build as bmbf-build-qpm
ARG NDK_VERSION=r22

WORKDIR /app
COPY qpm.json .
RUN /QPM/QPM collect
RUN /QPM/QPM restore
RUN echo /android-ndk-${NDK_VERSION} >ndkpath.txt

FROM bmbf-build-qpm
COPY . .
RUN pwsh -Command ./build.ps1

