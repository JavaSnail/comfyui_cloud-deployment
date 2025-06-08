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

if ss -tlnp | grep -q ":$PORT"; then
    echo "⚠️ ComfyUI is already running on port $PORT."
else
    echo "🚀 Starting ComfyUI on port $PORT..."
    nohup "$PYTHON_BIN" "$MAIN_PY" --listen 0.0.0.0 --port "$PORT" > "$LOG_FILE" 2>&1 &
    echo "⏳ Waiting for ComfyUI to start..."
    for i in {1..15}; do
        sleep 2
        if ss -tlnp | grep -q ":$PORT"; then
            echo "✅ ComfyUI started at http://<your-ip>:$PORT"
            exit 0
        fi
    done
    echo "❌ ComfyUI failed to start. Check logs at: $LOG_FILE"
fi
