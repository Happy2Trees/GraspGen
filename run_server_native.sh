#!/usr/bin/env bash
# Launch the GraspGen ZMQ inference server in its isolated uv venv (native, no Docker).
#
# Env overrides:
#   GRASPGEN_MODELS_DIR     (default /hdd2/GraspGenModels)
#   GRASPGEN_GRIPPER_CONFIG (default <models>/checkpoints/graspgen_franka_panda.yml)
#   GRASPGEN_HOST/PORT      (default 0.0.0.0 / 5556)
#   GRASPGEN_GPU_DEVICE     (default 0)
#   GRASPGEN_LOG            (default <repo>/runs/graspgen_server.log)
set -euo pipefail
HERE="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
VENV="$HERE/.venv"
MODELS="${GRASPGEN_MODELS_DIR:-/hdd2/GraspGenModels}"
CFG="${GRASPGEN_GRIPPER_CONFIG:-$MODELS/checkpoints/graspgen_franka_panda.yml}"
HOST="${GRASPGEN_HOST:-0.0.0.0}"
PORT="${GRASPGEN_PORT:-5556}"
LOG="${GRASPGEN_LOG:-$HERE/runs/graspgen_server.log}"
mkdir -p "$(dirname "$LOG")"
exec >>"$LOG" 2>&1
export CUDA_VISIBLE_DEVICES="${GRASPGEN_GPU_DEVICE:-0}"
# torch ships its own CUDA libs; system CUDA 12.8 only needed at build time.
source "$VENV/bin/activate"
echo "=== $(date) starting GraspGen server: cfg=$CFG host=$HOST port=$PORT gpu=$CUDA_VISIBLE_DEVICES ==="
exec python "$HERE/client-server/graspgen_server.py" \
    --gripper_config "$CFG" --host "$HOST" --port "$PORT"
