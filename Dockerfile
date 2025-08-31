# Inference worker image (1 GPU per container)
FROM nvidia/cuda:12.3.2-base-ubuntu22.04

# Base utils
RUN apt-get update && apt-get install -y --no-install-recommends \
    curl ca-certificates bash tini psmisc procps && \
    rm -rf /var/lib/apt/lists/*

# Install inference CLI (ТОЛЬКО установка, без запуска)
RUN curl -fsSL https://devnet.inference.net/install.sh | sh

# Entrypoint with retries and env-based code
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/usr/bin/tini","--","/entrypoint.sh"]
