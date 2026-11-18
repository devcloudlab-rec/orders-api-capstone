# Agent sandbox image: pinned Claude Code CLI + lab Python deps (for offline pytest).
# Build (from the repo root): docker build -t agent-sandbox:2.1.319 -f sandbox/Dockerfile .
ARG CLAUDE_CODE_VERSION=2.1.319
FROM python:3.13-slim
ARG CLAUDE_CODE_VERSION

RUN apt-get update \
  && apt-get install -y --no-install-recommends curl ca-certificates git \
  && rm -rf /var/lib/apt/lists/* \
  && useradd -m -u 1000 -s /bin/bash agent

# Native Claude Code install (pinned). Install as root, then expose on PATH for uid 1000.
RUN curl -fsSL https://claude.ai/install.sh | bash -s -- "${CLAUDE_CODE_VERSION}" \
  && install -m 0755 /root/.local/bin/claude /usr/local/bin/claude \
  && /usr/local/bin/claude --version | grep -F "${CLAUDE_CODE_VERSION}"

COPY --from=ghcr.io/astral-sh/uv:0.6.14 /uv /usr/local/bin/uv

# Bake lab deps into the image so pytest works without PyPI egress (allowlist is Anthropic-only).
WORKDIR /opt/lab-build
COPY pyproject.toml uv.lock ./
RUN uv sync --frozen --no-install-project --directory /opt/lab-build \
  && chown -R agent:agent /opt/lab-build
ENV VIRTUAL_ENV=/opt/lab-build/.venv
ENV PATH="/opt/lab-build/.venv/bin:/usr/local/bin:${PATH}"
ENV UV_PROJECT_ENVIRONMENT=/opt/lab-build/.venv

COPY sandbox/agent-entrypoint.sh /usr/local/bin/agent-entrypoint
USER agent
ENV HOME=/home/agent
ENTRYPOINT ["/usr/local/bin/agent-entrypoint"]
WORKDIR /workspace
