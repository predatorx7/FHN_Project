FROM ubuntu:22.04

LABEL name="predatorx7/flutterv2-vscode-devcontainer" \
      vendor="Mushaheed Syed" \
      version="1.0.0" \
      release="22060006" \
      summary="Dev environment for Flutter Android development." \
      description="This container image will make a dev environment for Flutter Android"

# Prerequisites

# Install basics
RUN apt-get update -y && \
  apt-get upgrade -y

RUN apt-get install -y --no-install-recommends \
  nano \
  sudo \
  git \
  wget \
  curl \
  zip \
  xz-utils \
  libglu1-mesa \
  unzip \
  openjdk-8-jdk \
  openjdk-11-jdk \
  apt-transport-https \
  ca-certificates \
  gnupg \
  zsh \
  openssh-client \
  apt-utils \
  # For resource monitoring
  htop \
  # For fish like suggestions
  zsh-autosuggestions

RUN apt-get clean

ARG _DEVELOPER_HOME="/home/developer"

# Set up new user
RUN useradd -ms /usr/bin/zsh developer
USER developer
WORKDIR ${_DEVELOPER_HOME}

# Prepare Android directories and system variables
ENV ANDROID_SDK_ROOT ${_DEVELOPER_HOME}/Android/Sdk
# Adding ANDROID_HOME, a deprecated android sdk variable path, for compatibility with ancient tools
ENV ANDROID_HOME "$ANDROID_SDK_ROOT"
ENV ANDROID_SDK_URL="https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip"
RUN mkdir -p .android && touch .android/repositories.cfg
RUN mkdir -p ${ANDROID_SDK_ROOT}

# Set up Android SDK
RUN wget --progress=dot:giga ${ANDROID_SDK_URL} -O cmdline-tools.zip 
RUN unzip cmdline-tools.zip && rm cmdline-tools.zip
RUN mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools
# moving sdk tools to latest folder because sdk manager always complains and 
# cannot find determine ANDROID SDK's location
RUN mv cmdline-tools ${ANDROID_SDK_ROOT}/cmdline-tools/latest
RUN cd ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin && yes | ./sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses
# You can replace the install targets below with yours (get it from `sdkmanager --sdk_root=$ANDROID_HOME --list_installed`)
RUN cd ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin && ./sdkmanager --sdk_root=${ANDROID_SDK_ROOT} "build-tools;33.0.0-rc4" "patcher;v4" "platform-tools" "platforms;android-31"
ENV PATH "$PATH:${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin:${ANDROID_SDK_ROOT}/platform-tools"

# Prepare flutter directories & variables
# URL for Flutter 3 latest SDK
ARG FLUTTER_SDK_URL=https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.0.1-stable.tar.xz

# Download Flutter SDK
RUN wget -O flutter_linux-stable.tar.xz ${FLUTTER_SDK_URL}
RUN tar -xf flutter_linux-stable.tar.xz && rm flutter_linux-stable.tar.xz
ENV FLUTTER_ROOT=${_DEVELOPER_HOME}/flutter
ENV PATH "$PATH:${FLUTTER_ROOT}/bin/cache/dart-sdk/bin:${FLUTTER_ROOT}/bin"

# Run basic check to download Dark SDK
RUN flutter doctor

RUN flutter config --no-analytics

# Causing some problems
# RUN yes "y" | flutter doctor --android-licenses

RUN flutter doctor -v

# pre-download development binaries
RUN flutter precache

# Create ssh config dir
RUN mkdir -p -m 0700 ${_DEVELOPER_HOME}/.ssh;

COPY ./.devcontainer/docker.zshrc.sh ${_DEVELOPER_HOME}/.zshrc

USER root

RUN sudo chown developer:developer ${_DEVELOPER_HOME}/.zshrc
RUN echo developer:developer | chpasswd;
RUN sudo adduser developer sudo

USER developer
