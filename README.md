# Google Antigravity CLI (agy) Sandbox Kit

Docker Sandboxes v3 workload for running Antigravity CLI (agy) in YOLO mode inside an isolated sandbox.

The kit installs the official agy binary, starts with `--dangerously-skip-permissions --mode=accept-edits`, and forces headless OAuth flow so authentication works without local browser.

OAuth is managed by Docker Sandboxes' host-side credential proxy. Sign in once on the first sandbox created, and then sandboxes can reuse that login without exposing the access and refresh tokens inside the sandbox.