#!/bin/bash
set -e

USER_NAME="${USER:-$(whoami)}"
HOME_DIR="/home/$USER_NAME"
MINICONDA_DIR="$HOME_DIR/miniconda"
COMFYUI_DIR="$HOME_DIR/ComfyUI"

# 安装 Miniconda
if [ ! -d "$MINICONDA_DIR" ]; then
    echo "📦 Installing Miniconda..."
    wget -N https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    bash Miniconda3-latest-Linux-x86_64.sh -b -p "$MINICONDA_DIR"
else
    echo "✔️ Miniconda already installed."
fi
source "$MINICONDA_DIR/etc/profile.d/conda.sh"

# 创建 conda 环境
if ! conda info --envs | grep -q '^comfyui'; then
    echo "🧪 Creating Conda environment..."
    conda create -n comfyui python=3.10 -y
fi
conda activate comfyui

# 安装依赖工具
sudo apt install -y git wget

# 克隆 ComfyUI
if [ ! -d "$COMFYUI_DIR" ]; then
    echo "📁 Cloning ComfyUI..."
    git clone https://github.com/comfyanonymous/ComfyUI.git "$COMFYUI_DIR"
fi

# 安装 Python 依赖
cd "$COMFYUI_DIR"
pip install --upgrade pip
pip install torch torchvision --index-url https://download.pytorch.org/whl/cu121
pip install aiohttp
pip install -r requirements.txt

echo "🎉 ComfyUI environment setup complete!"
