# we build on top of the aflplusplus base image
FROM cmuqa/fuzzing:base

# download the source code for the system under test
WORKDIR /workspace
ARG LIBXML2_VERSION="v2.9.2"
RUN git clone https://github.com/GNOME/libxml2 /workspace/libxml2 \
 && cd /workspace/libxml2 \
 && git checkout "${LIBXML2_VERSION}"

# build the program with fuzzing instrumentation using afl-clang-fast
# - we will also compile the program with Address Sanitizer (ASAN)
#   to detect memory corruption errors that might not otherwise
#   lead to an immediate crash
RUN cd /workspace/libxml2 \
 && CC=afl-clang-fast ./autogen.sh \
 && AFL_USE_ASAN=1 make -j$(nproc)

# build the fuzzing test harness
# - we use -I to add the libxml2 include directory to the include path
# - libxml2/.libs/libxml2.a is used to link the fuzzing test harness
#   against the compiled libxml2 library
# - -lz and -lm are used to dynamically link the libz and libm libraries
#   that are required by libxml2
COPY harness.c .
RUN AFL_USE_ASAN=1 afl-clang-fast ./harness.c \
      -I libxml2/include \
      libxml2/.libs/libxml2.a -lz -lm \
      -o fuzzer
