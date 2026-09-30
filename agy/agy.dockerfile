# syntax=docker/dockerfile:1
# v2's sandbox.image, now the workload content
FROM dhi.io/sbx-templates:shell-docker

# Install prerequisites required by SDKMAN!
USER root
RUN apt-get update && apt-get install -y --no-install-recommends \
    zip \
    unzip \
    ca-certificates \
 && rm -rf /var/lib/apt/lists/*

# Install antigravity cli into the artifact so the sandbox creation does not need to download the content
USER agent
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -eu; \
    curl -fsSL --compressed https://antigravity.google/cli/install.sh | bash; \
    test -x /home/agent/.local/bin/agy;

# Install SDKMAN!
ENV SDKMAN_DIR="/home/agent/.sdkman"
RUN curl -fsSL "https://get.sdkman.io" | bash \
 && bash -c "source ${SDKMAN_DIR}/bin/sdkman-init.sh && sdk version"

# agy detects remote environment and switches to copy/paste OAuth token 
# instead of browser-based OAuth flow, which is not supported in sandbox
ENV SSH_CONNECTION="sandbox 0 sandbox 0"

# Expose agy CLI and SDKMAN! candidate binaries in PATH
ENV PATH="/home/agent/.local/bin:${SDKMAN_DIR}/candidates/java/current/bin:${SDKMAN_DIR}/candidates/gradle/current/bin:${SDKMAN_DIR}/candidates/maven/current/bin:${PATH}"

WORKDIR /home/agent/workspace
ENTRYPOINT ["agy"]
CMD ["--dangerously-skip-permissions", "--mode=accept-edits"]