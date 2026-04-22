#!/usr/bin/env bash
set -euo pipefail

echo "======================================"
echo "   Casino Heist — Setup Installer"
echo "======================================"
echo ""

# ── 1. Install foundryup if not present ───────────────────────────────────────
if ! command -v foundryup &>/dev/null; then
    echo "[*] foundryup not found. Installing..."
    curl -L https://foundry.paradigm.xyz | bash
    export PATH="$HOME/.foundry/bin:$PATH"
    echo "[✓] foundryup installed."
else
    echo "[✓] foundryup already installed."
fi

# ── 2. Install Foundry stable ─────────────────────────────────────────────────
echo ""
echo "[*] Installing Foundry (stable)..."
foundryup --version stable
echo "[✓] Foundry stable installed."
echo ""
echo "[*] Verifying installation..."
forge --version
cast --version
anvil --version
echo "[✓] All Foundry tools verified."

# ── 3. Install required libraries ─────────────────────────────────────────────
echo ""
echo "[*] Installing required libraries..."
forge install foundry-rs/forge-std \
    OpenZeppelin/openzeppelin-contracts \
    OpenZeppelin/openzeppelin-contracts-upgradeable
echo "[✓] Libraries installed."

# ── 4. Build to confirm everything compiles ───────────────────────────────────
echo ""
echo "[*] Building project..."
forge build
echo "[✓] Build successful."

echo ""
echo "======================================"
echo "   All done! Happy heisting. 🎰"
echo "======================================"
