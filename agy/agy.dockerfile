# syntax=docker/dockerfile:1
# v2's sandbox.image, now the workload content
FROM docker/sandbox-templates:shell-docker@sha256:1560168ac5fb9ce23d413c878349334c5845c07e264cd675d7867f0c78ad1761

# Install antigravity cli into the artifact so the sandbox creation does not need to download the content
USER agent
SHELL ["/bin/bash", "-o", "pipefail", "-c"]
RUN set -eu; \
    curl -fsSL --compressed https://antigravity.google/cli/install.sh | bash; \
    test -x /home/agent/.local/bin/agy;

# agy detects remote environment and switches to copy/paste OAuth token 
# instead of browser-based OAuth flow, which is not supported in sandbox
ENV SSH_CONNECTION="sandbox 0 sandbox 0"
WORKDIR /home/agent/workspace
ENTRYPOINT ["agy"]
CMD ["--dangerously-skip-permissions", "--mode=accept-edits"]