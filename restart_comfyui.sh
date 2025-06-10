#!/bin/bash
set -e

USER_NAME="${USER:-$(whoami)}"
HOME_DIR="/home/$USER_NAME"
MINICONDA_DIR="$HOME_DIR/miniconda"
COMFYUI_DIR="$HOME_DIR/ComfyUI"
PYTHON_BIN="$MINICONDA_DIR/envs/comfyui/bin/python"
MAIN_PY="$COMFYUI_DIR/main.py"
LOG_FILE="$COMFYUI_DIR/comfyui.log"
PORT=8188

source "$MINICONDA_DIR/etc/profile.d/conda.sh"
conda activate comfyui

echo "🔄 Restarting ComfyUI on port $PORT..."

# 查找并杀死当前监听该端口的进程
PIDS=$(ss -tlnp | grep ":$PORT" | grep -oP 'pid=\K[0-9]+')
if [[ -n "$PIDS" ]]; then
    echo "🛑 Stopping existing ComfyUI instance(s)..."
    for pid in $PIDS; do
        kill "$pid" && echo "✅ Killed process $pid"
    done
    sleep 2
else
    echo "ℹ️ No ComfyUI process found on port $PORT."
fi

# 确保端口已释放
for i in {1..5}; do
    if ss -tlnp | grep -q ":$PORT"; then
        echo "⏳ Waiting for port $PORT to be released..."
        sleep 2
    else
        break
    fi
done

# 启动 ComfyUI
echo "🚀 Starting ComfyUI..."
nohup "$PYTHON_BIN" "$MAIN_PY" --listen 0.0.0.0 --port "$PORT" > "$LOG_FILE" 2>&1 &

# 等待服务启动
echo "⏳ Waiting for ComfyUI to start..."
for i in {1..15}; do
    sleep 2
    if ss -tlnp | grep -q ":$PORT"; then
        echo "✅ ComfyUI restarted at http://<your-ip>:$PORT"
        exit 0
    fi
done

echo "❌ ComfyUI failed to start. Check logs at: $LOG_FILE"
