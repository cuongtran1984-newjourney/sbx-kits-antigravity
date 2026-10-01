# Google Antigravity CLI (agy) Sandbox Kit

Docker Sandboxes v3 workload for running Antigravity CLI (agy) in YOLO mode inside an isolated sandbox.

The kit installs the official agy binary, starts with `--dangerously-skip-permissions --mode=accept-edits`, and forces headless OAuth flow so authentication works without local browser.

OAuth is managed by Docker Sandboxes' host-side credential proxy. Sign in once on the first sandbox created, and then sandboxes can reuse that login without exposing the access and refresh tokens inside the sandbox.

## MCP Gateway

Register an MCP server on the host, then select it when creating the sandbox:

```sh
sbx mcp add context7 --url https://mcp.context7.com/mcp
sbx run ./agy . --static-mcp context7
```

Gateway provisioning belongs to the sandbox runtime; v3 has no MCP Gateway
capability. When `MCP_GATEWAY_URL` is present, the kit's startup hook registers
`mcp-gateway` with `agy mcp add --header`, using the gateway URL and the
runtime's `MCP_SENTINEL_TOKEN_NAME` as its Bearer auth sentinel. The proxy
substitutes the real gateway credential; the kit does not embed it.

The hook refreshes the gateway entry on each start, preserves other servers and
configuration, and writes nothing when the gateway URL is absent. Use `/mcp` in agy to
inspect the connection. The static server set is selected at sandbox creation;
create a new sandbox to change it.

References: [Docker's gateway registration pattern](https://hub.docker.com/r/docker/sbx-kit-copilot)
and [Antigravity MCP configuration](https://www.antigravity.google/docs/mcp).

## How authentication works

TBD