#!/bin/bash
set -e

echo "🔧 Step 0: Install Linux kernel headers..."
sudo apt update
if ! sudo apt install -y build-essential linux-headers-$(uname -r); then
    echo "Fallback: Installing linux-headers-cloud-amd64..."
    sudo apt install -y linux-headers-cloud-amd64
fi

echo "🖥 Step 1: Install NVIDIA GPU driver..."
if ! command -v nvidia-smi >/dev/null; then
    curl -fsSL https://raw.githubusercontent.com/GoogleCloudPlatform/compute-gpu-installation/main/linux/install_gpu_driver.py -o install_gpu_driver.py
    sudo python3 install_gpu_driver.py
else
    echo "✔️ GPU driver already installed. Skipping..."
fi

echo "📦 Step 2: Install CUDA 12.4..."
CUDA_DEB="cuda-repo-debian12-12-4-local_12.4.1-550.54.15-1_amd64.deb"
CUDA_PKG="cuda-toolkit-12-4"
if ! dpkg -l | grep -q $CUDA_PKG; then
    wget -N https://developer.download.nvidia.com/compute/cuda/12.4.1/local_installers/$CUDA_DEB
    sudo dpkg -i $CUDA_DEB
    sudo cp /var/cuda-repo-debian12-12-4-local/cuda-*-keyring.gpg /usr/share/keyrings/
    sudo add-apt-repository contrib -y
    sudo apt-get update
    sudo apt-get install -y $CUDA_PKG
else
    echo "✔️ CUDA Toolkit already installed."
fi

echo "💡 Step 3: Install cuDNN 9.1..."
CUDNN_DEB="cudnn-local-repo-debian12-9.1.0_1.0-1_amd64.deb"
CUDNN_PKG="cudnn-cuda-12"
if ! dpkg -l | grep -q $CUDNN_PKG; then
    wget -N https://developer.download.nvidia.com/compute/cudnn/9.1.0/local_installers/$CUDNN_DEB
    sudo dpkg -i $CUDNN_DEB
    sudo cp /var/cudnn-local-repo-debian12-9.1.0/cudnn-local-0C975CD8-keyring.gpg /usr/share/keyrings/
    sudo apt-get update
    sudo apt-get install -y $CUDNN_PKG
else
    echo "✔️ cuDNN already installed."
fi

echo "🎉 GPU stack installation completed! Please REBOOT the system before continuing."
