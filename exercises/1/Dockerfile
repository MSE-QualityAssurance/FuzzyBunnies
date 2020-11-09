# we build on top of the aflplusplus base image
FROM cmuqa/fuzzing:base

# install dependencies for the system under test
RUN sudo apt-get install --no-install-recommends libpng-dev

# download the source code for the system under test
WORKDIR /workspace
ARG GIF2PNG_VERSION="2.5.11"
RUN git clone https://gitlab.com/esr/gif2png.git /workspace/gif2png \
 && cd /workspace/gif2png \
 && git checkout "${GIF2PNG_VERSION}"
