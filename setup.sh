#!/usr/bin/env bash
#
# Arturito setup.
#
# What this does:
#   1. Installs Hermes Agent if it is missing (it asks first).
#   2. Copies Arturito's personality (SOUL.md) into your Hermes home folder.
#   3. Sets the model and saves YOUR OWN API key on your machine only.
#
# Nothing is sent anywhere except by the official Hermes installer.
# Your key is written to ~/.hermes/.env and is never stored in this repo.
#
# Options (environment variables):
#   HERMES_HOME      Hermes data folder.     Default: ~/.hermes
#   ARTURITO_MODEL   xAI model to use.       Default: grok-4-1-fast-reasoning

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HERMES_HOME="${HERMES_HOME:-$HOME/.hermes}"
MODEL="${ARTURITO_MODEL:-grok-4-1-fast-reasoning}"
ENV_FILE="$HERMES_HOME/.env"
INSTALL_URL="https://hermes-agent.nousresearch.com/install.sh"

say()  { printf '\n==> %s\n' "$*"; }
note() { printf '    %s\n' "$*"; }
fail() { printf '\nERROR: %s\n' "$*" >&2; exit 1; }

# ask_yes "Question" -> returns 0 for yes (the default), 1 for no
ask_yes() {
  local answer
  read -r -p "$1 [Y/n] " answer
  case "$answer" in
    [nN]*) return 1 ;;
    *)     return 0 ;;
  esac
}

# set_env KEY VALUE -> add or replace KEY in the Hermes .env file
set_env() {
  local key="$1" value="$2" tmp
  mkdir -p "$HERMES_HOME"
  touch "$ENV_FILE"
  chmod 600 "$ENV_FILE"
  tmp="$(mktemp "$ENV_FILE.XXXXXX")"
  grep -v -E "^[[:space:]]*${key}=" "$ENV_FILE" > "$tmp" || true
  printf '%s=%s\n' "$key" "$value" >> "$tmp"
  chmod 600 "$tmp"
  mv "$tmp" "$ENV_FILE"
}

[ -t 0 ] || fail "Run this in a terminal. It needs to ask you a few questions."
[ -f "$REPO_DIR/SOUL.md" ] || fail "SOUL.md not found next to setup.sh. Run it from the arturito folder."

# ---------------------------------------------------------------- 1. Hermes
say "Step 1 of 3: Hermes Agent"
if command -v hermes >/dev/null 2>&1; then
  note "Found: $(hermes --version 2>/dev/null | head -n 1)"
else
  note "Hermes is not installed."
  note "The official installer is: $INSTALL_URL"
  if ask_yes "Download and run it now?"; then
    command -v curl >/dev/null 2>&1 || fail "curl is missing. Install curl and run this again."
    curl -fsSL "$INSTALL_URL" | bash -s -- --skip-setup
    export PATH="$HOME/.local/bin:$PATH"
    hash -r
  fi
  command -v hermes >/dev/null 2>&1 || fail "Hermes is still not on your PATH. Open a new terminal and run 'bash setup.sh' again."
  note "Installed: $(hermes --version 2>/dev/null | head -n 1)"
fi

# ---------------------------------------------------------------- 2. Soul
say "Step 2 of 3: Arturito's personality"
read -r -p "What should Arturito call you? [${USER:-friend}] " NAME
NAME="${NAME:-${USER:-friend}}"
SAFE_NAME="$(printf '%s' "$NAME" | sed -e 's/[\\&|]/\\&/g')"

mkdir -p "$HERMES_HOME"
if [ -f "$HERMES_HOME/SOUL.md" ]; then
  BACKUP="$HERMES_HOME/SOUL.md.bak.$(date +%Y%m%d_%H%M%S)"
  cp "$HERMES_HOME/SOUL.md" "$BACKUP"
  note "Your old SOUL.md was saved as $BACKUP"
fi
sed -e "s|{{NAME}}|$SAFE_NAME|g" "$REPO_DIR/SOUL.md" > "$HERMES_HOME/SOUL.md"
note "Wrote $HERMES_HOME/SOUL.md"

# ---------------------------------------------------------------- 3. Model
say "Step 3 of 3: Model and API key"
note "Arturito was built on xAI ($MODEL)."
note "You need your own key. Get one at https://console.x.ai/"
if ask_yes "Use xAI?"; then
  hermes config set model.provider xai
  hermes config set model.default "$MODEL"
  hermes config set model.base_url https://api.x.ai/v1

  read -r -s -p "Paste your xAI API key (it will not show on screen): " XAI_KEY
  printf '\n'
  if [ -n "$XAI_KEY" ]; then
    set_env XAI_API_KEY "$XAI_KEY"
    note "Saved your key in $ENV_FILE (only you can read it)."
  else
    note "No key entered. Add it later with: hermes config set XAI_API_KEY <your key>"
  fi
  unset XAI_KEY
else
  note "Opening the Hermes model picker instead."
  hermes model
fi

# ---------------------------------------------------------------- Done
say "Arturito is ready."
note "Chat now:          hermes"
note "Add Discord:       hermes gateway setup     (pick Discord)"
note "Run the gateway:   hermes gateway run"
note "Change the soul:   edit $HERMES_HOME/SOUL.md"
