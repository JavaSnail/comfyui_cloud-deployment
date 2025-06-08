# 🚀 ComfyUI 部署脚本说明文档

本项目包含 3 个脚本，分别完成 GPU 驱动与 CUDA 安装、ComfyUI 环境搭建、ComfyUI 启动。推荐使用 **Linux 11 + CUDA 12.4 + cuDNN 9.1**。

---

## 📂 脚本说明

| 脚本文件              | 功能描述                     | 是否需要 sudo |
|-----------------------|------------------------------|----------------|
| `install_gpu_stack.sh` | 安装 NVIDIA 驱动、CUDA、cuDNN | ✅ 是          |
| `setup_comfyui_env.sh` | 安装 Miniconda、ComfyUI 环境  | ❌ 否          |
| `start_comfyui.sh`     | 启动 ComfyUI 服务             | ❌ 否          |

---

## 🧰 环境准备（首次运行）

### 1️⃣ 安装 GPU 驱动 + CUDA + cuDNN

```bash
sudo bash install_gpu_stack.sh
````

* 如果安装过程中报错 `linux-headers-$(uname -r)` 找不到，会自动安装 `linux-headers-cloud-amd64`。
* 成功后建议手动执行重启：

```bash
sudo reboot
```

---

### 2️⃣ 安装 ComfyUI 环境（激活 Conda + Python 依赖）

```bash
bash setup_comfyui_env.sh
```

* 安装内容：

    * Miniconda（安装在 `~/miniconda`）
    * Conda 环境名为 `comfyui`
    * 安装 Python 3.10、`torch` + `torchvision`（CUDA 12.1 对应）、`aiohttp` 等
    * 克隆并部署 ComfyUI 主程序

---

### 3️⃣ 启动 ComfyUI 服务

```bash
bash start_comfyui.sh
```

* 默认监听端口：`8188`
* 启动后访问地址：

```
http://<你的服务器IP>:8188
```

* 日志输出文件路径：

```
~/ComfyUI/comfyui.log
```

---

## 📌 注意事项

* 若更新了 custom\_nodes（如 ComfyUI-Manager），需要重新安装依赖：

```bash
conda activate comfyui
pip install -r ~/ComfyUI/custom_nodes/ComfyUI-Manager/requirements.txt
```

* 若报错 `ModuleNotFoundError: No module named 'torch'`，请确保执行了 `conda activate comfyui` 并安装了 CUDA 对应的 PyTorch 版本。

