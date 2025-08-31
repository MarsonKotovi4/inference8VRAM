#!/usr/bin/env bash
set -Eeuo pipefail

CODE="${INFERENCE_CODE:-}"
if [[ -z "${CODE}" ]]; then
  echo "ERROR: INFERENCE_CODE env var is not set"
  echo "Set it via: -e INFERENCE_CODE=YOUR_CODE"
  exit 64
fi

echo "[entrypoint] Using INFERENCE_CODE=${CODE}"

# up to 5 retries with backoff
for try in 1 2 3 4 5; do
  echo "[entrypoint] starting inference (try $try)..."
  # ВАЖНО: запуск отдельной командой
  if exec inference node start --code "${CODE}"; then
    exit 0
  fi
  backoff=$(( try * 10 ))
  echo "[entrypoint] process exited. retrying in ${backoff}s..."
  sleep "${backoff}"
done

echo "[entrypoint] failed to start after 5 retries"
exit 1
