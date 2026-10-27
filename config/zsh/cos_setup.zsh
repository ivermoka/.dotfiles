# Auto-starts the COS VPN/tunnel (see ~/projects/gli/cos-gli) if it isn't
# already up. Actual logic lives in the `cos` bin; this just checks status.
if command -v cos >/dev/null 2>&1; then
    cos status >/dev/null 2>&1 || cos start
fi
