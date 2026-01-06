#!/bin/bash
# Setup build environment for iStoreOS compilation
# Usage: ./scripts/setup-build-env.sh

set -e

echo "🚀 Setting up iStoreOS build environment..."

# 更新系统包
sudo apt-get update

# 安装编译依赖
sudo apt-get install -y \
    build-essential \
    ccache \
    ecj \
    fastjar \
    file \
    g++ \
    gawk \
    gettext \
    git \
    java-propose-classpath \
    libelf-dev \
    libncurses5-dev \
    libncursesw5-dev \
    libssl-dev \
    python3 \
    python3-pip \
    python3-setuptools \
    python3-dev \
    qemu-utils \
    rsync \
    subversion \
    swig \
    time \
    unzip \
    wget \
    zlib1g-dev

# 安装Python依赖
pip3 install --upgrade pip
pip3 install wheel

echo "✅ Build environment setup complete!"
