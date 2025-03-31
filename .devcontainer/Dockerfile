FROM ubuntu:22.04

# Avoid warnings by switching to noninteractive
ENV DEBIAN_FRONTEND=noninteractive

# Install only the necessary packages for Flutter development
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    wget \
    unzip \
    xz-utils \
    zip \
    openjdk-11-jdk \
    libgtk-3-dev \
    cmake \
    ninja-build \
    clang \
    libwebkit2gtk-4.0-dev \
    ca-certificates \
    ruby-full \
    sudo

# Clean up
RUN apt-get autoremove -y \
    && apt-get clean -y \
    && rm -rf /var/lib/apt/lists/*

# Switch back to dialog for any ad-hoc use of apt
ENV DEBIAN_FRONTEND=dialog

# Set up user
ARG USERNAME=devpod
ARG USER_UID=1000
ARG USER_GID=$USER_UID

RUN groupadd --gid $USER_GID $USERNAME \
    && useradd --uid $USER_UID --gid $USER_GID -m $USERNAME \
    && echo $USERNAME ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/$USERNAME \
    && chmod 0440 /etc/sudoers.d/$USERNAME

# Set up Android SDK
USER $USERNAME
ENV ANDROID_SDK_ROOT=/home/$USERNAME/android-sdk
RUN mkdir -p ${ANDROID_SDK_ROOT}

# Install Android SDK components
RUN cd /home/$USERNAME \
    && mkdir -p cmdline-tools \
    && wget -q https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip \
    && unzip commandlinetools-linux-8512546_latest.zip -d cmdline-tools \
    && rm commandlinetools-linux-8512546_latest.zip \
    && mkdir -p ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && mv cmdline-tools/cmdline-tools/* ${ANDROID_SDK_ROOT}/cmdline-tools/latest \
    && rmdir cmdline-tools/cmdline-tools cmdline-tools

# Accept licenses and install required Android packages
RUN yes | ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} --licenses \
    && ${ANDROID_SDK_ROOT}/cmdline-tools/latest/bin/sdkmanager --sdk_root=${ANDROID_SDK_ROOT} \
    "platform-tools" \
    "platforms;android-33" \
    "build-tools;33.0.0" \
    "extras;android;m2repository" \
    "extras;google;m2repository"

# Install Flutter
ENV FLUTTER_ROOT=/home/$USERNAME/flutter
RUN git clone https://github.com/flutter/flutter.git -b stable ${FLUTTER_ROOT}
ENV PATH=${PATH}:${FLUTTER_ROOT}/bin:${FLUTTER_ROOT}/bin/cache/dart-sdk/bin

# Install Cocoapods for iOS development
RUN gem install cocoapods

# Install Deno
RUN curl -fsSL https://deno.land/x/install/install.sh | sh

# Install Bun
RUN curl -fsSL https://bun.sh/install | bash

# Add Deno and Bun to PATH
RUN echo 'export PATH="$PATH:$HOME/.deno/bin:$HOME/.bun/bin"' >> /home/$USERNAME/.bashrc

# Create a startup script
RUN echo '#!/bin/bash' > /home/$USERNAME/startup.sh \
    && echo 'echo "Flutter development environment ready!"' >> /home/$USERNAME/startup.sh \
    && echo 'echo "Flutter: $(flutter --version | head -n 1)"' >> /home/$USERNAME/startup.sh \
    && echo 'echo "Dart: $(dart --version)"' >> /home/$USERNAME/startup.sh \
    && echo 'echo "Bun: $(bun --version)"' >> /home/$USERNAME/startup.sh \
    && echo 'echo "Deno: $(deno --version)"' >> /home/$USERNAME/startup.sh \
    && echo 'exec "$@"' >> /home/$USERNAME/startup.sh \
    && chmod +x /home/$USERNAME/startup.sh

# Change permissions
RUN sudo chown -R $USERNAME:$USERNAME /home/$USERNAME

# Set the working directory
WORKDIR /workspaces

# Set entrypoint to our startup script
ENTRYPOINT ["/home/devpod/startup.sh"]
# Default command if nothing is provided
CMD ["sleep", "infinity"]